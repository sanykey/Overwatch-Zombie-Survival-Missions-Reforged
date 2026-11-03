// Verify a per-iteration ID snapshot preserves all six objective cleanup actions and the original wait.
// On success, rebuild src/main.ws.txt and save objective-cleanup-id-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '3ebccb2';
const file = 'subroutines.opy';
const indexSlot = files['variables.opy'].match(/^#!define objectiveVisualCleanupIndex (\w+)/m)[1];
assert(!/^tmp\d+$/.test(indexSlot), 'The cleanup loop counter must remain phase-owned across its wait');
const expression = `Value In Array(Global.objectiveEntityIdList, Global.${indexSlot})`;
const snapshot = `Set Global Variable(tmp0, ${expression});`;
const loop = `For Global Variable(${indexSlot}, 0, Count Of(Global.objectiveEntityIdList), True);`;
const deletions = ['Destroy Progress Bar HUD Text', 'Destroy Progress Bar In-World Text',
    'Destroy Effect', 'Destroy HUD Text', 'Destroy Icon', 'Destroy In-World Text'].map(name => `${name}(Global.tmp0);`);
const wait = 'Wait(False, Ignore Condition);';

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing objective actions');
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditIteration(body) {
    assert.equal(body.filter(a => a === snapshot).length, 1, 'Expected one ID read in the loop body');
    const i = body.indexOf(snapshot);
    assert.equal(body[i - 1], loop, 'Snapshot must be assigned anew inside every cleanup iteration');
    assert.deepEqual(body.slice(i + 1, i + 7), deletions, 'Preserve all six synchronous deletions in their original order');
    assert.equal(body[i + 7], wait, 'Preserve the wait after all ID reads');
    assert.equal(body[i + 8], 'End;', 'Unexpected cleanup loop continuation');
}

async function main() {
    const baseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    assert(files[file].includes('#!define objectiveVisualCleanupId tmp0'));
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements - after.elements, 13);
    const original = rules(before.result), current = rules(after.result);
    assert.equal(current.length, original.length);
    const snapshotBlock = [snapshot, ...deletions].join('\n');
    const originalBlock = deletions.map(a => a.replace('Global.tmp0', expression)).join('\n');
    let changedRule;
    for (let i = 0; i < current.length; i++) {
        assert.equal(current[i].name, original[i].name);
        if (current[i].name !== 'objectivesManagement') {assert.deepEqual(current[i], original[i]); continue;}
        auditIteration(actions(current[i]));
        assert.equal(current[i].body.split(snapshotBlock).length - 1, 1);
        assert.equal(original[i].body.split(originalBlock).length - 1, 1);
        assert.equal(current[i].body.replace(snapshotBlock, originalBlock), original[i].body,
            'Only the six indexed ID reads may change; all other objective behavior must match');
        changedRule = current[i];
    }
    assert(changedRule);
    const scratch = checkWorkshop(after.result);
    for (const boundary of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);']) {
        const unsafe = after.result.replace(snapshot, snapshot + '\n        ' + boundary);
        assert.throws(() => checkWorkshop(unsafe), e => /live across/.test(e.message) && /tmp0/.test(e.message));
    }
    const outsideLoop = actions(changedRule);
    const i = outsideLoop.indexOf(snapshot);
    outsideLoop.splice(i, 1);
    outsideLoop.splice(i - 1, 0, snapshot);
    assert.throws(() => auditIteration(outsideLoop), /inside every cleanup iteration/);

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
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselineSubroutinesRef: baselineRef,
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        compiledRulesCompared: original.length, synchronousDeletionsPerId: 6, originalDeletionOrderPreserved: true,
        cleanupIndexSlot: indexSlot, cleanupIdScratch: 'tmp0', snapshotRefreshedPerIteration: true,
        originalWaitAndArrayResetPreserved: true, scratchRulesChecked: scratch.length, negativeAuditCases: 3,
        directIncludeBuildChecked: true, emittedWarnings: [], warningsSuppressedByMainSource: true,
        inGameValidated: false, runtimeBenchmarked: false,
        subroutinesSha256: crypto.createHash('sha256').update(files[file]).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'objective-cleanup-id-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
