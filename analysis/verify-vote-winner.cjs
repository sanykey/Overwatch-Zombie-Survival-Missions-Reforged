// Verify the synchronous vote-helper contract, compiled equivalence and scratch lifetimes.
// On success, rebuild src/main.ws.txt and write vote-winner-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop, args} = require('./verify-global-temporaries.cjs');
const baselineRef = 'e735199';
const helperName = 'selectVoteWinner';
const callers = [['determineZombieMode', 'zombieSetting'], ['determineObjectiveType', 'objectiveTypeSetting']];

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing actions: ' + rule.name);
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditHelper(body) {
    // A strict whitelist rejects waits, asynchronous actions, nested calls and persistent readers.
    for (const action of body) {
        assert(/^(?:For Global Variable\(tmp0,|If\(|Else If\(|Set Global Variable\(tmp2,|End;)/.test(action),
            'Vote helper must remain synchronous and only write its result/index: ' + action);
        const globals = [...action.matchAll(/\bGlobal\.(\w+)\b/g)].map(m => m[1]);
        assert(globals.every(n => ['tmp0', 'tmp1', 'tmp2'].includes(n)), 'Unexpected helper state');
    }
    assert.equal(body[0], 'For Global Variable(tmp0, 1, Count Of(Global.tmp1), True);');
    assert.equal(body.filter(a => a.includes('Random Integer(')).length, 1);
}

function auditHandoff(body, setting) {
    const call = 'Call Subroutine(selectVoteWinner);';
    assert.equal(body.filter(a => a === call).length, 1);
    const i = body.indexOf(call);
    assert(/^Set Global Variable\(tmp1, Global\.\w+\);$/.test(body[i - 2]), 'Missing vote-count input');
    assert.equal(body[i - 1], `Set Global Variable(tmp2, Global.${setting});`);
    assert.equal(body[i + 1], `Set Global Variable(${setting}, Global.tmp2);`, 'Consume result before any async work');
    return {index: i, counts: args(body[i - 2])[1]};
}

function inlineForScratchAudit(output, helper) {
    let removed = 0, expanded = 0;
    const text = output.replace(/^rule \("((?:\\.|[^"\\])*)"\) \{\n([\s\S]*?)^\}/gm, (rule, name, body) => {
        if (/^\s*selectVoteWinner;$/m.test(body)) {removed++; return '';}
        return rule.replace(/^(\s*)Call Subroutine\(selectVoteWinner\);[^\n]*$/gm, (line, indent) => {
            expanded++;
            return helper.map(a => indent + a).join('\n');
        });
    });
    assert.equal(removed, 1);
    assert.equal(expanded, 2);
    return text;
}

function prepareScratchAudit(output) {
    const compiled = rules(output);
    const helperRule = compiled.find(r => r.body.includes('\nselectVoteWinner;\n'));
    assert(helperRule, 'Missing synchronous vote subroutine');
    const helper = actions(helperRule);
    auditHelper(helper);
    assert(!/Start Rule\(selectVoteWinner,/.test(output), 'Helper must never be started asynchronously');
    assert.equal((output.match(/Call Subroutine\(selectVoteWinner\)/g) || []).length, 2);
    for (const [name, setting] of callers) {
        const candidates = compiled.filter(r => r.name === name);
        assert.equal(candidates.length, 1, 'Unexpected vote-helper caller');
        auditHandoff(actions(candidates[0]), setting);
    }
    return inlineForScratchAudit(output, helper);
}

async function main() {
    const baseline = {...files, 'global_start_menu.opy': execFileSync('git',
        ['show', baselineRef + ':src/global_start_menu.opy'], {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements - after.elements, 32);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const helperRule = newRules.find(r => r.body.includes('\nselectVoteWinner;\n'));
    assert(helperRule, 'Missing synchronous vote subroutine');
    const helper = actions(helperRule);
    auditHelper(helper);
    assert(!/Start Rule\(selectVoteWinner,/.test(after.result), 'Helper must never be started asynchronously');
    assert.equal((after.result.match(/Call Subroutine\(selectVoteWinner\)/g) || []).length, 2);
    assert.equal(newRules.length, oldRules.length + 1);
    const originalsInOrder = newRules.filter(r => r !== helperRule);
    for (const [position, old] of oldRules.entries()) {
        const current = originalsInOrder[position];
        assert.equal(current.name, old.name, 'Original rule order changed');
        const caller = callers.find(([name]) => name === old.name);
        if (!caller) {assert.deepEqual(current, old); continue;}
        const [, setting] = caller;
        const updated = actions(current), original = actions(old);
        const {index, counts} = auditHandoff(updated, setting);
        const restoredHelper = helper.map(a => a.replaceAll('Global.tmp1', counts)
            .replaceAll('Global.tmp2', 'Global.' + setting)
            .replaceAll('Set Global Variable(tmp2,', 'Set Global Variable(' + setting + ','));
        // Replace only input/call/output actions by the equivalent original storage accesses.
        const restored = [...updated.slice(0, index - 2), ...restoredHelper, ...updated.slice(index + 2)];
        assert.deepEqual(restored, original, old.name + ': original loop, defaults or async launches changed');
    }
    const expanded = inlineForScratchAudit(after.result, helper);
    // Inline this audited synchronous helper only; the generic audit still rejects all other call boundaries.
    // Removing its standalone rule avoids treating the explicit argument reads as uninitialized inputs.
    const scratch = checkWorkshop(expanded);
    assert.deepEqual(checkWorkshop(after.result), scratch, 'Generic audit must use the same strict helper contract');
    for (const forbidden of ['Wait(1, Ignore Condition);', 'Start Rule(determineChallenge, Restart Rule);',
        'Call Subroutine(determineChallenge);'])
        assert.throws(() => auditHelper([...helper, forbidden]), /must remain synchronous/);
    assert.throws(() => checkWorkshop(expanded.replace('Set Global Variable(zombieSetting, Global.tmp2);',
        'Wait(1, Ignore Condition);\n        Set Global Variable(zombieSetting, Global.tmp2);')), /live across/);

    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), newRules);
    for (const [name, text] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), text, 'Concurrent source change');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselineMenuRef: baselineRef,
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        originalCompiledRulesCompared: oldRules.length, synchronousHelperCalls: 2, helperContainsAsyncWork: false,
        originalLoopsAndRandomCallConditionsPreserved: true, noPreferenceDefaultsPreserved: true,
        resultConsumedBeforeAsyncLaunch: true, scratchRulesChecked: scratch.length, negativeAuditCases: 4,
        scratchMethod: 'Inline only the strictly audited synchronous helper at both parameter/result handoffs, then run the existing compiled control-flow liveness audit. No general call-boundary exemptions.',
        directIncludeBuildChecked: true, emittedWarnings: [], warningsSuppressedByMainSource: true,
        inGameValidated: false, runtimeBenchmarked: false,
        sourceSha256: Object.fromEntries(Object.entries(files).map(([n, s]) => [n, crypto.createHash('sha256').update(s).digest('hex')]))};
    fs.writeFileSync(path.join(__dirname, 'vote-winner-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({before: report.before, after: report.after, saved: report.saved,
        originalCompiledRulesCompared: oldRules.length, scratchRulesChecked: scratch.length, negativeAuditCases: 4}));
}

module.exports = {prepareScratchAudit};
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
