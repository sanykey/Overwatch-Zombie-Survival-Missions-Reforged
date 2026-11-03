// Rebuild the two measured groups from the preceding commit and compare the compiled rules.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const baselineRef = '960d7de';
const affected = ['global_start_menu.opy', 'zombie_types.opy',
    'bots_game_in_progress.opy', 'subroutines.opy'];
const baseline = {...files};
for (const file of affected) {
    baseline[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.resolve(src, '..')}).toString('utf8').replace(/\r\n/g, '\n');
}

function replaceOne(sources, file, oldText, newText) {
    assert.equal(sources[file].split(oldText).length - 1, 1,
        `Expected one occurrence in ${file}: ${oldText.slice(0, 90)}`);
    sources[file] = sources[file].replace(oldText, newText);
}

function mergeVoteAssignments(sources) {
    for (const [list, index, field] of [
        ['zombieVoteList', 'zombieModeVoteIndex', 'pregameZombieVote'],
        ['challengeVoteList', 'challengeVoteIndex', 'pregameChallengeVote'],
        ['objectiveTypeVoteList', 'objectiveTypeVoteIndex', 'pregameObjectiveVote'],
    ]) {
        const count = `len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.${field} == ${index}))`;
        replaceOne(sources, 'global_start_menu.opy',
            `if ${list}[${index}][1]:\n            ${list}[${index}] = ${count}\n        else:\n            ${list}[${index}] = -1`,
            `${list}[${index}] = ${count} if ${list}[${index}][1] else -1`);
    }
}

function simplifyNonnegativeCountdowns(sources) {
    for (const [file, oldText, newText] of [
        ['zombie_types.opy', 'eventPlayer.botGasCloudTimeRemaining > 0',
            'eventPlayer.botGasCloudTimeRemaining'],
        ['zombie_types.opy', 'eventPlayer.botBlasterCharge <= 0',
            'not eventPlayer.botBlasterCharge'],
        ['zombie_types.opy', 'eventPlayer.botDaytakerCharge <= 0',
            'not eventPlayer.botDaytakerCharge'],
        ['zombie_types.opy', 'eventPlayer.botSmolderAnger <= 0',
            'not eventPlayer.botSmolderAnger'],
        ['bots_game_in_progress.opy', 'eventPlayer.botRespawnDelay <= 0',
            'not eventPlayer.botRespawnDelay'],
        ['subroutines.opy', 'eventPlayer.botGasCloudTimeRemaining > 0',
            'eventPlayer.botGasCloudTimeRemaining'],
        ['subroutines.opy', 'eventPlayer.botBlasterCharge > 0',
            'eventPlayer.botBlasterCharge'],
        ['subroutines.opy', 'eventPlayer.botDaytakerCharge > 0',
            'eventPlayer.botDaytakerCharge'],
    ]) replaceOne(sources, file, oldText, newText);
}

async function main() {
    await compiler.readyPromise;
    const votes = {...baseline};
    mergeVoteAssignments(votes);
    const expected = {...votes};
    simplifyNonnegativeCountdowns(expected);
    assert.deepEqual(files, expected, 'Current sources differ from the measured changes');

    const before = await compile(baseline);
    const afterVotes = await compile(votes);
    const after = await compile(files);
    assert.equal(before.elements, 25251);
    assert.equal(afterVotes.elements, 25245);
    assert.equal(after.elements, 25224);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(afterVotes.warnings, []);
    assert.deepEqual(after.warnings, []);

    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 268);
    assert.deepEqual(newRules.map(rule => rule.name), oldRules.map(rule => rule.name));
    const changedRules = newRules.filter((rule, i) => rule.body !== oldRules[i].body).length;

    // A direct include build must match the in-memory source build.
    const savedLog = console.log;
    let included;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), newRules);
    for (const [file, contents] of Object.entries(files)) {
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'),
            contents, `Source changed during verification: ${file}`);
    }
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({baselineRef, before: before.elements,
        afterVotes: afterVotes.elements, after: after.elements,
        savedVotes: before.elements - afterVotes.elements,
        savedCountdowns: afterVotes.elements - after.elements,
        saved: before.elements - after.elements, rules: newRules.length,
        changedRules, warnings: after.warnings.length, directIncludeBuild: true,
        inGameValidated: false}));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {mergeVoteAssignments, simplifyNonnegativeCountdowns};
