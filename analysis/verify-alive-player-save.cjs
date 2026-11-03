// Verify the two ALIVE-state writes move into one synchronous, scratch-free helper unchanged.
// On success, rebuild src/main.ws.txt and save alive-player-save-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '02313a4';
const file = 'players_game_in_progress.opy';
const callers = ['REVIVE PLAYER OR ADVANCE DEATH TIMER', 'updateUsers'];
const call = 'Call Subroutine(saveAlivePlayerState);';

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing actions: ' + rule.name);
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditHelper(body, originalWrite) {
    assert.equal(body.length, 1, 'Save helper must remain a single synchronous record write');
    assert.equal(body[0], originalWrite, 'Save helper changed the original player, index or row values');
    assert(!/\bGlobal\.tmp\d+\b/.test(body[0]), 'Save helper must not use shared scratch');
}

async function main() {
    const baseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements - after.elements, 13);
    const original = rules(before.result), updated = rules(after.result);
    const originalWrites = actions(original.find(r => r.name === 'updateUsers'))
        .filter(a => a.startsWith('Set Global Variable At Index(playerStatsList,'));
    assert.equal(originalWrites.length, 1);
    const originalWrite = originalWrites[0];
    const helper = updated.find(r => r.body.includes('\nsaveAlivePlayerState;\n'));
    assert(helper, 'Missing save helper');
    auditHelper(actions(helper), originalWrite);
    assert(!/Start Rule\(saveAlivePlayerState,/.test(after.result), 'Save helper must never be started asynchronously');
    assert.equal((after.result.match(/Call Subroutine\(saveAlivePlayerState\)/g) || []).length, 2);
    const originalsInOrder = updated.filter(r => r !== helper);
    assert.equal(originalsInOrder.length, original.length);
    let restoredCalls = 0;
    for (let i = 0; i < original.length; i++) {
        const current = originalsInOrder[i];
        assert.equal(current.name, original[i].name);
        if (!callers.includes(current.name)) {assert.deepEqual(current, original[i]); continue;}
        assert.equal(actions(current).filter(a => a === call).length, 1);
        assert.equal(current.body.replace(call, originalWrite), original[i].body,
            'Caller lifecycle checks, timer/index setup, waits or death-state saves changed');
        restoredCalls++;
    }
    assert.equal(restoredCalls, 2);
    const scratch = checkWorkshop(after.result);
    for (const forbidden of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);'])
        assert.throws(() => auditHelper([...actions(helper), forbidden], originalWrite), /single synchronous/);
    assert.throws(() => auditHelper([originalWrite.replaceAll('Event Player', 'Host Player')], originalWrite),
        /original player, index or row/);

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
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselinePlayerSourceRef: baselineRef,
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        originalCompiledRulesCompared: original.length, synchronousHelperCalls: 2, helperUsesScratch: false,
        helperContainsAsyncWork: false, originalPlayerIndexAndFieldsPreserved: true,
        callerChecksTimerAndIndexSetupPreserved: true, downedAndDeadWritesUnchanged: true,
        scratchRulesChecked: scratch.length, negativeAuditCases: 3, directIncludeBuildChecked: true,
        emittedWarnings: [], warningsSuppressedByMainSource: true, inGameValidated: false, runtimeBenchmarked: false,
        playerSourceSha256: crypto.createHash('sha256').update(files[file]).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'alive-player-save-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
