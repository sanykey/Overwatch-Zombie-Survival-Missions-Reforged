// Execute compiled pickup actions and inspect live player-owned icon expressions.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, value, applies} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..'), baselineRef = 'd9a0cf3';
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
async function main() {
    await compiler.readyPromise;
    const beforeFiles = {...files};
    for (const name of ['variables.opy', 'players_game_in_progress.opy', 'augments.opy'])
        beforeFiles[name] = execFileSync('git', ['show', `${baselineRef}:src/${name}`], {cwd: root}).toString('utf8').replace(/\r\n/g, '\n');
    const before = await compile(beforeFiles), after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const parsed = rules(after.result), baseline = rules(before.result);
    const added = ['APOTHECARY CURE ICON', 'APOTHECARY CURE ICON DISCONNECT CLEANUP'];
    const existing = parsed.filter(r => !added.includes(r.name)), changed = [];
    assert.equal(existing.length, baseline.length);
    for (let i = 0; i < existing.length; i++) {
        assert.equal(existing[i].name, baseline[i].name);
        if (existing[i].body !== baseline[i].body) changed.push(existing[i].name);
    }
    assert.deepEqual(changed.sort(), ['AUGMENT MENU', 'PLAYER PICKS UP HEALTH PACK'].sort());
    const compiled = new Map(parsed.map(r => [r.name, r]));
    const pointSlot = slot('augmentApothecaryPosition'), iconSlot = slot('augmentApothecaryCureIcon');
    const owner = (point, augmentId = 8) => ({augmentId, [pointSlot]: point, position: [100, 0, 0]});
    const make = (augment = 0, infection = 4, enhancement = 3, difficulty = 5, time = -1, owners = [], position = [0, 0, 0]) => {
        const state = scenario(augment, {eventWasHealthPack: true, eventHealing: 75, matchTime: time, ultCharge: 10, maxHealth: 1000, targets: owners});
        Object.assign(state.player, {enhancementId: enhancement, infectionLevel: infection, isInfected: infection >= 1, health: 500, position});
        Object.assign(state.globals, {difficultySetting: difficulty, matchEndTime: 0,
            offsetUpThreeQuartersConst: [0, 0.75, 0], offsetUpHalfConst: [0, 0.5, 0], healthpackPositionList: []});
        return state;
    };
    const run = (state, name = 'PLAYER PICKS UP HEALTH PACK') => assert(start(compiled.get(name), state, compiled).done());
    let pickupCases = 0;
    for (const augment of [0, 8]) for (const enhancement of [1, 3]) for (const infection of [-2, 0, 0.5, 1, 2.9, 3, 3.1, 4, 9, 30])
    for (const difficulty of [1, 3, 5]) for (const time of [30, 0, -30])
    for (const owners of [[], [owner([0, 0, 0])], [owner([5, 0, 0])], [owner([5.01, 0, 0])], [owner([0, 0, 0], 1)], [owner(0)]]) {
        const state = make(augment, infection, enhancement, difficulty, time, owners); run(state);
        const normal = difficulty < 3 || time > 0;
        const shared = augment === 8 || owners.some(p => p.augmentId === 8 && Array.isArray(p[pointSlot]) && Math.hypot(...p[pointSlot]) <= 5);
        const expected = normal && infection > 0 ? 0 : shared && enhancement !== 1 && infection > 0 ? Math.max(0, infection - Math.max(1, infection / 3)) : infection;
        assert.equal(state.player.infectionLevel, expected, JSON.stringify({augment, enhancement, infection, difficulty, time, owners}));
        assert.equal(state.player.health, augment === 8 ? 575 : 500);
        assert.equal(state.ultCharge, augment === 8 ? 17 : 10);
        assert.deepEqual(state.globals.healthpackPositionList, [[0, 0, 0]]);
        assert.equal(state.messages.length, !normal && !shared && infection >= 1 ? 1 : 0);
        assert.equal(!!state.stoppedDots, normal);
        pickupCases++;
    }
    // Different current points, moved points, shared points, and owner departure.
    const a = make(8, 0), b = make(8, 0, 3, 5, -1, [], [20, 0, 0]); run(a); run(b);
    const pickupAt = (point, owners) => {const state = make(0, 4, 3, 5, -1, owners, point); run(state); return state.player.infectionLevel;};
    assert.equal(pickupAt([0, 0, 0], [a.player, b.player]), 4 - 4 / 3);
    assert.equal(pickupAt([20, 0, 0], [a.player, b.player]), 4 - 4 / 3);
    a.player.position = [40, 0, 0]; run(a);
    assert.equal(pickupAt([0, 0, 0], [a.player, b.player]), 4, 'Old point must unbind');
    assert.equal(pickupAt([40, 0, 0], [a.player, b.player]), 4 - 4 / 3);
    b.player.position = [40, 0, 0]; run(b);
    assert.equal(pickupAt([20, 0, 0], [a.player, b.player]), 4);
    a.player.position = [60, 0, 0]; run(a);
    assert.equal(pickupAt([40, 0, 0], [a.player, b.player]), 4 - 4 / 3, 'Other owner keeps the shared point bound');
    assert.equal(pickupAt([40, 0, 0], [a.player]), 4, 'Departed owner has no point');
    assert.equal(pickupAt([60, 0, 0], [a.player]), 4 - 4 / 3);
    const iconRule = compiled.get(added[0]), iconOwner = make(8, 0, 3, 5, 30);
    assert(!applies(iconRule, iconOwner)); run(iconOwner);
    assert(applies(iconRule, iconOwner), 'Origin is a valid point'); run(iconOwner, added[0]);
    assert.equal(iconOwner.icons.length, 1);
    const icon = iconOwner.icons[0]; assert.equal(iconOwner.player[iconSlot], icon.id);
    let iconCases = 0;
    for (const infected of [false, true]) for (const enhancement of [1, 3]) for (const time of [30, 0, -1])
    for (const difficulty of [1, 5]) for (const active of [false, true]) {
        const viewer = {isInfected: infected, enhancementId: enhancement};
        iconOwner.targets = [viewer]; iconOwner.matchTime = time;
        iconOwner.globals.difficultySetting = difficulty; iconOwner.globals.isGameplayActive = active;
        assert.equal(value(icon.visibility, iconOwner).includes(viewer), active && difficulty >= 3 && time <= 0 && infected && enhancement !== 1);
        iconCases++;
    }
    iconOwner.globals.isGameplayActive = true;
    iconOwner.player.position = [20, 0, 10]; run(iconOwner);
    assert.deepEqual(value(icon.position, iconOwner), [20, 1.25, 10]);
    assert.equal(iconOwner.icons.length, 1, 'Moving point must reuse icon');
    iconOwner.alive = false; assert(applies(iconRule, iconOwner));
    assert(!/Is Alive|augmentState1/.test(iconRule.body), 'Icon does not depend on life or teleport charge');
    const secondIconOwner = make(8, 0, 3, 5, -1, [], [40, 0, 0]); run(secondIconOwner);
    secondIconOwner.lastEntity = iconOwner.lastEntity; run(secondIconOwner, added[0]);
    assert.notEqual(secondIconOwner.player[iconSlot], icon.id);
    assert.deepEqual(value(secondIconOwner.icons[0].position, secondIconOwner), [40, 1.25, 0]);
    assert(compiled.get(added[1]).body.includes('Player Left Match;')); run(iconOwner, added[1]);
    assert.deepEqual(iconOwner.destroyedIcons, [icon.id]); assert(!iconOwner.liveEffects.has(icon.id));
    assert(secondIconOwner.liveEffects.has(secondIconOwner.player[iconSlot]), 'Other owner retains its icon');
    const declarations = text => [...text.matchAll(/^(globalvar|playervar) (\w+)/gm)].map(m => m[0]);
    assert.deepEqual(declarations(files['variables.opy']), declarations(beforeFiles['variables.opy']));
    assert(!Object.values(files).join('\n').includes('apothecaryPackPositionList'));
    let build; const log = console.log;
    try {console.log = () => {}; build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');}
    finally {console.log = log;}
    assert.deepEqual(build.encounteredWarnings, []); assert.equal(build.nbElements, after.elements); assert.deepEqual(rules(build.result), parsed);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    const report = {baselineRef, beforeElements: before.elements, afterElements: after.elements, delta: after.elements - before.elements,
        changedRules: changed, addedRules: added, unchangedRules: existing.length - changed.length, newGlobals: 0, newPlayerVariables: 0,
        pickupCases, iconCases, multiOwnerAndDepartureChecks: true, warnings: after.warnings,
        limitations: 'Scripted compiled-action checks; native pickup geometry and icon rendering require Overwatch testing.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-apothecary-shared-packs-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
