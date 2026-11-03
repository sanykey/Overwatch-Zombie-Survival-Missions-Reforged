// Validate the implemented reductions against the measured variants and rebuild Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {selected, newHelpers, inlineSynchronousHelpersForAudit} =
    require('./probe-tenth-elements-2026-11-03.cjs');

const baselineRef = '6593219';
const voteRules = [
    ['PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)', 'advanceChallengeVote'],
    ['PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)', 'advanceZombieVote'],
    ['PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)', 'advanceObjectiveVote'],
    ['PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)', 'advanceEnhancementChoice'],
];

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const expectedFiles = {...baseline};
    for (const [, transform] of selected) transform(expectedFiles);
    for (const [file, contents] of Object.entries(expectedFiles))
        assert.equal(files[file], contents, `Source differs from measured variant: ${file}`);

    // compile() temporarily suppresses compiler logging, so run sequentially.
    const before = await compile(baseline);
    const expected = await compile(expectedFiles);
    const after = await compile(files);
    assert.equal(before.elements, 25848);
    assert.equal(expected.elements, 25798);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 255);
    assert.equal(newRules.length, 267);
    assert.deepEqual(newRules, rules(expected.result),
        'Implemented Workshop actions differ from measured variants');
    for (const [ruleName, helperName] of voteRules) {
        const body = newRules.find(rule => rule.name === ruleName).body;
        assert(body, `Vote rule missing: ${ruleName}`);
        assert.equal(body.split(`Call Subroutine(${helperName});`).length - 1, 2,
            `${ruleName}: both vote steps must use the same helper`);
        assert(!body.includes('Wait('), `${ruleName}: vote offset must not cross a wait`);
    }

    // Expand synchronous helpers for scratch liveness, including the tmp0 vote input.
    // The unchanged teleport pivot pair has its separately audited tmp1 handoff.
    const scratch = checkWorkshop(inlineSynchronousHelpersForAudit(after.result, newRules));
    let included;
    const savedLog = console.log;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), newRules);
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    const report = {date: '2026-11-03', baselineRef, before: before.elements,
        after: after.elements, saved: before.elements - after.elements,
        oldRules: oldRules.length, newRules: newRules.length,
        newHelpersChecked: newHelpers.length,
        voteHandoffsChecked: voteRules.length,
        scratchRulesCheckedExcludingExistingBotHelper: scratch.length,
        directIncludeBuild: true, emittedWarnings: 0, inGameValidated: false};
    fs.writeFileSync(path.join(__dirname, 'tenth-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
