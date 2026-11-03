// Verify the six size reductions against the preceding revision and rebuild the Workshop export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const baselineRef = 'ebacea2';
const changedFiles = [
    'global_game_in_progress.opy', 'global_startup.opy', 'players_game_in_progress.opy',
    'zombie_types.opy', 'supply_drops.opy',
];
const changedRules = new Set([
    'ATTACK SPAWN ROOM CONTROL', 'TRI\u00adGGER OVERTIME MUSIC',
    'PREGAME SPAWN ROOM ROTATION', 'PLAYER GETS DOWNED',
    'REVIVE PLAYER OR ADVANCE DEATH TIMER', 'ZOMBIES SPAWN AT REIGNITED',
    'sentryTurret (50-59)',
]);

async function main() {
    const baseline = {...files};
    for (const file of changedFiles)
        baseline[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
            {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');
    await compiler.readyPromise;
    const before = await compile(baseline);
    const after = await compile(files);
    assert.equal(before.elements, 26319);
    assert.equal(after.elements, 26271);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const original = rules(before.result);
    const updated = rules(after.result);
    const helper = updated.find(rule => rule.name === 'teleportDownedPlayerToWalkable');
    assert(helper, 'Missing downed-player helper');
    const helperActions = helper.body.split('actions {\n')[1].split('\n').filter(line => line.endsWith(';'));
    assert.equal(helperActions.length, 1, 'Helper must have one synchronous teleport action');
    assert(helperActions[0].startsWith('Teleport(Event Player, '));
    assert(!/Wait\(|Start Rule\(/.test(helper.body));
    const downedCallers = ['PLAYER GETS DOWNED', 'REVIVE PLAYER OR ADVANCE DEATH TIMER'];
    for (const name of downedCallers) {
        const oldRule = original.find(rule => rule.name === name);
        const newRule = updated.find(rule => rule.name === name);
        assert(oldRule.body.includes(helperActions[0]), 'Original teleport action must equal helper action');
        assert.equal(newRule.body.replace('Call Subroutine(teleportDownedPlayerToWalkable);', helperActions[0]),
            oldRule.body, 'Caller control flow or action order changed');
    }
    const noHelper = updated.filter(rule => rule !== helper);
    assert.equal(noHelper.length, original.length);
    const observed = [];
    for (let i = 0; i < original.length; i++) {
        assert.equal(noHelper[i].name, original[i].name);
        if (noHelper[i].body !== original[i].body) observed.push(noHelper[i].name);
    }
    assert.deepEqual(new Set(observed), changedRules, 'Unexpected compiled-rule changes');
    assert.equal(observed.length, changedRules.size);

    const saved = console.log;
    let included;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = saved; }
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), updated);
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({before: before.elements, after: after.elements,
        saved: before.elements - after.elements, originalRulesCompared: original.length,
        changedRules: observed, synchronousHelperCalls: 2, directIncludeBuild: true,
        emittedWarnings: included.encounteredWarnings.length, inGameValidated: false}, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
