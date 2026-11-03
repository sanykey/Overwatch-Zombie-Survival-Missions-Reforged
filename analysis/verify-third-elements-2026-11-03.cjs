// Verify the nine reductions against the preceding commit and rebuild the Workshop export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {variants, baselineFiles} = require('./probe-third-elements-2026-11-03.cjs');

const selected = ['winloss_empty_check', 'explosion_sound_radius', 'mission_rollback_loop',
    'grid_gamemode_membership', 'mutation_challenge_membership', 'bot_support_hero_membership',
    'menu_two_mode_membership', 'miniboss_ult_hero_membership', 'challenge_rule_membership'];
const changedNames = new Set([
    'botRespawnInitialization', 'explosionSequence', 'generateMapGrid',
    'GLOBAL MENU INITIALIZATION', 'setObjectiveType', 'SWARM SHOOTOUT', 'RANDOM ABILITIES',
    'WIN/LOSS CONDITIONS', 'BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)',
]);

async function main() {
    await compiler.readyPromise;
    const expectedFiles = {...baselineFiles};
    for (const name of selected) variants[name](expectedFiles);
    const before = await compile(baselineFiles);
    const expected = await compile(expectedFiles);
    const after = await compile(files);
    assert.equal(before.elements, 26188);
    assert.equal(expected.elements, 26139);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), expectedRules = rules(expected.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 239);
    assert.deepEqual(newRules, expectedRules, 'Implementation differs from measured variants');
    assert.equal(newRules.length, oldRules.length);
    const changed = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(newRules[i].name, oldRules[i].name);
        if (newRules[i].body !== oldRules[i].body) changed.push(newRules[i].name);
    }
    assert.deepEqual(new Set(changed), changedNames);
    assert.equal(changed.length, changedNames.size);

    const oldRoute = oldRules.find(row => row.name === 'setObjectiveType').body;
    const newRoute = newRules.find(row => row.name === 'setObjectiveType').body;
    const deleteAndRefresh = 'Modify Global Variable(objectivePositionList, Remove From Array By Index, Subtract(Count Of(Global.objectivePositionList), True));\n' +
        'Set Global Variable(phaseSlot12, First Of(Global.objectivePositionList));';
    const loop = `For Global Variable(tmp0, 0, 2, True);\n${deleteAndRefresh}\nEnd;`;
    assert(newRoute.includes(loop), 'Rollback loop must retain deletion and cache refresh order');
    assert.equal(newRoute.replace(loop, `${deleteAndRefresh}\n${deleteAndRefresh}`), oldRoute,
        'Rollback changed more than two repeated steps');

    // The existing bot pivot helper has its own audited synchronous tmp1 handoff.
    const withoutBotHelper = after.result.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(withoutBotHelper);

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
    const report = {date: '2026-11-03', before: before.elements, after: after.elements,
        saved: before.elements - after.elements, originalRulesCompared: oldRules.length,
        changedRules: changed, rollbackStepsPreserved: 2,
        scratchRulesCheckedExcludingExistingBotHelper: scratch.length, directIncludeBuild: true,
        emittedWarnings: 0, inGameValidated: false, runtimeBenchmarked: false};
    fs.writeFileSync(path.join(__dirname, 'third-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
