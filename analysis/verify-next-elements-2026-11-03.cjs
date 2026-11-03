// Verify the five reductions against the preceding commit and rebuild the Workshop export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {variants, baselineFiles} = require('./probe-next-elements-2026-11-03.cjs');

const selected = ['menu_los_point', 'special_menu_values', 'objective_type_cache_once',
    'zombie_mode_slice_table', 'bot_nearest_helper'];
const changedNames = new Set(['GLOBAL MENU INITIALIZATION', 'setZombieMode', 'setObjectiveType', 'teleportBots']);
const helperCall = 'Call Subroutine(setClosestPlayerTeleportCenter);';

async function main() {
    await compiler.readyPromise;
    const expectedFiles = {...baselineFiles};
    for (const name of selected) variants[name](expectedFiles);
    const before = await compile(baselineFiles);
    const expected = await compile(expectedFiles);
    const after = await compile(files);
    assert.equal(before.elements, 26271);
    assert.equal(expected.elements, 26188);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result);
    const expectedRules = rules(expected.result);
    const newRules = rules(after.result);
    const sortedRules = rows => [...rows].sort((a, b) =>
        a.name.localeCompare(b.name) || a.body.localeCompare(b.body));
    assert.deepEqual(sortedRules(newRules), sortedRules(expectedRules),
        'Implementation differs from measured variant');
    const helper = newRules.find(rule => rule.name === 'setClosestPlayerTeleportCenter');
    assert(helper);
    const helperActions = helper.body.split('actions {\n')[1].split('\n').filter(line => line.endsWith(';'));
    assert.equal(helperActions.length, 1, 'Helper must contain exactly one synchronous action');
    assert(helperActions[0].startsWith('Set Player Variable(Event Player, actorTeamSlot0, '));
    assert.equal((helperActions[0].match(/Global\.tmp1/g) || []).length, 1);
    assert(!/Wait\(|Start Rule\(/.test(helper.body));
    const withoutHelper = newRules.filter(rule => rule !== helper);
    assert.equal(withoutHelper.length, oldRules.length);
    const changed = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(withoutHelper[i].name, oldRules[i].name);
        if (withoutHelper[i].body !== oldRules[i].body) changed.push(oldRules[i].name);
    }
    assert.deepEqual(new Set(changed), changedNames);
    assert.equal(changed.length, changedNames.size);
    const teleportAfter = newRules.find(rule => rule.name === 'teleportBots');
    const teleportBefore = oldRules.find(rule => rule.name === 'teleportBots');
    let handoffs = 0;
    const restored = teleportAfter.body.replace(
        /Set Global Variable\(tmp1, ([^\n]+)\);\nCall Subroutine\(setClosestPlayerTeleportCenter\);/g,
        (_, pivot) => {
            handoffs++;
            return helperActions[0].replace('Global.tmp1', pivot);
        });
    assert.equal(handoffs, 5, 'Each helper call must immediately follow its pivot assignment');
    assert.equal(restored, teleportBefore.body, 'Pivot selection, waits or teleport control flow changed');
    assert.equal((after.result.match(/Call Subroutine\(setClosestPlayerTeleportCenter\)/g) || []).length, 5);

    const menuFiles = {...baselineFiles};
    for (const name of selected.filter(name => name !== 'bot_nearest_helper')) variants[name](menuFiles);
    const menuBuild = await compile(menuFiles);
    const scratchAudit = checkWorkshop(menuBuild.result);
    assert.equal(menuBuild.elements, 26212);

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
        changedRules: changed, synchronousHelperCalls: handoffs, helperMatchesOriginalSearch: true,
        scratchRulesAuditedWithoutHelper: scratchAudit.length, directIncludeBuild: true,
        emittedWarnings: 0, inGameValidated: false, runtimeBenchmarked: false};
    fs.writeFileSync(path.join(__dirname, 'next-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
