// Verify the reconnect snapshot stays synchronous and preserves the live post-wait status read.
// On success, rebuild src/main.ws.txt and save reconnect-row-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '66b2054';
const file = 'players_game_in_progress.opy';

async function main() {
    const historicalBaseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    const source = files[file];
    const enumValues = {
        ReconnectField: {STATUS: 0, RESCUE_TIME_REMAINING: 1, REVIVE_TIME_REMAINING: 2, REVIVE_DURATION: 3, POSITION: 4},
        ReconnectStatus: {ALIVE: 0, DOWNED: 1, DEAD: 2},
    };
    for (const [name, values] of Object.entries(enumValues)) {
        const declaration = files['variables.opy'].match(new RegExp('^enum ' + name + ':\\n((?: +[^\\n]*\\n)+)', 'm'));
        assert(declaration, 'Missing enum: ' + name);
        const actual = Object.fromEntries([...declaration[1].matchAll(/(\w+) = (\d+),/g)].map(([, key, value]) => [key, Number(value)]));
        assert.deepEqual(actual, values, 'Reconnect field/status values must retain the original layout');
    }
    const numericSource = source.replace(/\b(ReconnectField|ReconnectStatus)\.(\w+)\b/g, (_, name, member) => {
        assert(Object.hasOwn(enumValues[name], member), 'Unknown reconnect enum member');
        return String(enumValues[name][member]);
    });
    assert(source.includes('#!define reconnectRowSnapshot tmp0'));
    assert.deepEqual([...numericSource.matchAll(/reconnectRowSnapshot\[(\d+)\]/g)].map(m => Number(m[1])), [1, 2, 3, 0, 0, 4]);
    const assignment = '            reconnectRowSnapshot = playerStatsList[eventPlayer.reconnectUserIndex]\n';
    const begin = source.indexOf(assignment), end = source.indexOf('                while eventPlayer.isAlive():', begin);
    assert(begin >= 0 && end > begin);
    assert(!/^\s*(?:wait|waitUntil|startRule|kill)\(/m.test(source.slice(begin, end)), 'Snapshot segment must not yield or trigger death');
    const finalStatus = 'if playerStatsList[eventPlayer.reconnectUserIndex][0] == 2:';
    const numericEnd = numericSource.indexOf('                while eventPlayer.isAlive():');
    assert(numericSource.indexOf(finalStatus, numericEnd) > numericEnd, 'Post-wait status must remain a live array read');
    // Reverse only this optimization, retaining unrelated helpers added to the same source file.
    const baseline = {...files, [file]: source.replace(assignment, '')
        .replaceAll('reconnectRowSnapshot[', 'playerStatsList[eventPlayer.reconnectUserIndex][')};

    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    const historical = await compile(historicalBaseline);
    const numeric = await compile({...files, [file]: numericSource});
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(historical.warnings, []);
    assert.deepEqual(numeric.warnings, []);
    assert.equal(numeric.elements, after.elements);
    assert.deepEqual(rules(numeric.result), rules(after.result), 'Enums changed compiled rules');
    assert.equal(before.elements - after.elements, 18);
    const original = rules(before.result), current = rules(after.result);
    assert.deepEqual(original.find(r => r.name === 'PLAYER INITIALIZATION'),
        rules(historical.result).find(r => r.name === 'PLAYER INITIALIZATION'),
        'Reconstructed initialization must still match the original uncached implementation');
    assert.equal(current.length, original.length);
    const snapshotExpression = 'Value In Array(Global.playerStatsList, (Event Player).reconnectUserIndex)';
    const snapshotAction = `Set Global Variable(tmp0, ${snapshotExpression});`;
    let comparedSnapshots = 0;
    for (let i = 0; i < current.length; i++) {
        assert.equal(current[i].name, original[i].name);
        if (current[i].name !== 'PLAYER INITIALIZATION') {assert.deepEqual(current[i], original[i]); continue;}
        assert(!/Global\.tmp0\b/.test(original[i].body), 'Original initialization has an unrelated tmp0 owner');
        assert.equal(current[i].body.split(snapshotAction).length - 1, 1);
        assert.equal((current[i].body.match(/Global\.tmp0\b/g) || []).length, 6);
        const restored = current[i].body.split('\n').filter(line => line !== snapshotAction).join('\n')
            .replaceAll('Global.tmp0', snapshotExpression);
        assert.equal(restored, original[i].body, 'Only the six intended reads may change');
        comparedSnapshots++;
    }
    assert.equal(comparedSnapshots, 1);
    const scratch = checkWorkshop(after.result);
    // A wait or asynchronous launch immediately after caching must be rejected.
    for (const boundary of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);']) {
        assert(after.result.includes(snapshotAction));
        const unsafe = after.result.replace(snapshotAction, snapshotAction + '\n        ' + boundary);
        assert.throws(() => checkWorkshop(unsafe), /live across/);
    }
    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), current);
    for (const [name, text] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), text, 'Concurrent source edit');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselinePlayerSourceRef: baselineRef,
        baselineMethod: 'Reverse only the reconnect snapshot in current sources; additionally compare the uncached initializer with the historical implementation.',
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        compiledRulesCompared: original.length, cachedReads: 6, postWaitStatusReadPreserved: true,
        scratchRulesChecked: scratch.length, negativeAsyncAuditCases: 2, directIncludeBuildChecked: true,
        emittedWarnings: [], warningsSuppressedByMainSource: true, inGameValidated: false, runtimeBenchmarked: false,
        enumValues, enumOnlyElementsUnchanged: true, enumOnlyCompiledRulesCompared: current.length,
        playerSourceSha256: crypto.createHash('sha256').update(source).digest('hex'),
        variableSourceSha256: crypto.createHash('sha256').update(files['variables.opy']).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'reconnect-row-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
