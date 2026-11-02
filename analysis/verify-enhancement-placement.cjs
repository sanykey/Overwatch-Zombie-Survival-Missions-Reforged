// Verify shared placement rejection preserves both caller aborts and never yields with live scratch.
// On success, rebuild src/main.ws.txt and save enhancement-placement-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop, args} = require('./verify-global-temporaries.cjs');
const baselineRef = '48f00b8';
const helperName = 'checkEnhancementPlacement';
const callers = ['LASER BARRICADE (PLACEMENT)', 'CHARGE BATTERY'];
const call = 'Call Subroutine(checkEnhancementPlacement);';
const reject = 'Abort If(Global.tmp0);';
const waitForRelease = 'Wait Until(Or(Not(Is Button Held(Event Player, Button(Melee))), Is Dead(Event Player)), 99999);';
const rejectionClauses = [
    'Compare(Distance Between(Eye Position(Event Player), Ray Cast Hit Position(Eye Position(Event Player), Add(Eye Position(Event Player), Multiply(Facing Direction Of(Event Player), 31)), Null, Null, False)), >, 30)',
    'Is Dead(Event Player)',
];

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing actions: ' + rule.name);
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditHelper(body) {
    assert.equal(body.length, 1, 'Placement helper must remain a single synchronous result assignment');
    assert(body[0].startsWith('Set Global Variable(tmp0, Or('), 'Unexpected placement result');
    const assignmentArgs = args(body[0]);
    assert.equal(assignmentArgs.length, 2);
    assert.equal(assignmentArgs[0], 'tmp0');
    assert.deepEqual(args(assignmentArgs[1]), rejectionClauses, 'Placement ray/death predicates changed');
}

function auditCaller(body) {
    assert.equal(body.filter(a => a === call).length, 1, 'Expected one synchronous placement call');
    const i = body.indexOf(call);
    assert.equal(body[i - 1], waitForRelease, 'Check must remain after button release/death wait');
    assert.equal(body[i + 1], reject, 'Caller must immediately abort on rejection');
    return i;
}

function prepareScratchAudit(output) {
    const compiled = rules(output);
    const helper = compiled.find(r => r.body.includes('\ncheckEnhancementPlacement;\n'));
    assert(helper, 'Missing placement helper');
    const helperActions = actions(helper);
    auditHelper(helperActions);
    assert(!/Start Rule\(checkEnhancementPlacement,/.test(output), 'Placement helper must never run asynchronously');
    assert.equal((output.match(/Call Subroutine\(checkEnhancementPlacement\)/g) || []).length, 2);
    for (const name of callers) {
        const matches = compiled.filter(r => r.name === name);
        assert.equal(matches.length, 1);
        auditCaller(actions(matches[0]));
    }
    let removed = 0, expanded = 0;
    const result = output.replace(/^rule \("((?:\\.|[^"\\])*)"\) \{\n([\s\S]*?)^\}/gm, (rule, name, body) => {
        if (/^\s*checkEnhancementPlacement;$/m.test(body)) {removed++; return '';}
        return rule.replace(/^( *)Call Subroutine\(checkEnhancementPlacement\);[^\n]*$/gm, (line, indent) => {
            expanded++;
            return indent + helperActions[0];
        });
    });
    assert.equal(removed, 1);
    assert.equal(expanded, 2);
    return result;
}

async function main() {
    const file = 'enhancements.opy';
    const baseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements - after.elements, 15);
    const original = rules(before.result), updated = rules(after.result);
    const helper = updated.find(r => r.body.includes('\ncheckEnhancementPlacement;\n'));
    assert(helper, 'Missing placement helper');
    auditHelper(actions(helper));
    const originalsInOrder = updated.filter(r => r !== helper);
    assert.equal(originalsInOrder.length, original.length);
    let replaced = 0;
    for (let i = 0; i < original.length; i++) {
        const current = originalsInOrder[i];
        assert.equal(current.name, original[i].name);
        if (!callers.includes(current.name)) {assert.deepEqual(current, original[i]); continue;}
        auditCaller(actions(current));
        const originalAborts = rejectionClauses.map(c => `Abort If(${c});`).join('\n');
        const restored = current.body.replace(call + '\n' + reject, originalAborts);
        assert.equal(restored, original[i].body, 'Caller actions, waits, placement ray or cooldown changed');
        replaced++;
    }
    assert.equal(replaced, 2);
    const expanded = prepareScratchAudit(after.result);
    const scratch = checkWorkshop(expanded);
    assert.deepEqual(checkWorkshop(after.result), scratch, 'Generic scratch audit must enforce the same contract');
    for (const forbidden of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);'])
        assert.throws(() => auditHelper([...actions(helper), forbidden]), /single synchronous/);
    const delayed = after.result.replace(call, call + '\n        Wait(1, Ignore Condition);');
    assert.throws(() => checkWorkshop(delayed), /immediately abort/);
    const missingAbort = after.result.replace(/Abort If\(Global\.tmp0\);[^\n]*/, '');
    assert.throws(() => checkWorkshop(missingAbort), /immediately abort/);

    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), updated);
    for (const [name, text] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), text, 'Concurrent source edit');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselineEnhancementsRef: baselineRef,
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        originalCompiledRulesCompared: original.length, synchronousCalls: 2, helperContainsAsyncWork: false,
        callerAbortsPreserved: true, checkAfterButtonReleasePreserved: true, originalRaycastArgumentsPreserved: true,
        placementRaysAndCooldownsUnchanged: true, scratchRulesChecked: scratch.length, negativeAuditCases: 4,
        scratchMethod: 'Inline only the exact audited synchronous result assignment immediately followed by caller Abort If; retain conservative boundaries for unaudited calls.',
        directIncludeBuildChecked: true, emittedWarnings: [], warningsSuppressedByMainSource: true,
        inGameValidated: false, runtimeBenchmarked: false,
        enhancementsSha256: crypto.createHash('sha256').update(files[file]).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'enhancement-placement-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

module.exports = {prepareScratchAudit};
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
