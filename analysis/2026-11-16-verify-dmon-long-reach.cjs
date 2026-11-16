const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');
const name = '[LONG_REACH] MELEE WEAPONS';
const makeState = (build, extra = {}) => {
    const state = scenario(4, {hero: 'D.Mon', firing: false,
        buttons: new Set(['Primary Fire']),
        targets: [{id: 'hit', position: [0, 0, 8], health: 10000, alive: true, visible: true}],
        ...extra});
    state.player.initialMaxHealth = 525;
    state.globals.numbersList = require('./2026-11-13-verify-long-reach-numbers.cjs').numbers(build);
    state.globals.augmentMeleeWeaponHeroListConst = ['Reinhardt', 'Brigitte', 'D.Mon', 'Genji', 'Ramattra', 'Torbjörn', 'Vendetta'];
    state.globals.augmentMeleeBtnHeroListConst = ['Reinhardt', 'Brigitte', 'Torbjörn'];
    return state;
};
const parsed = build => new Map(rules(build.result).map(rule => [rule.name, rule]));
(async () => {
    await compiler.readyPromise;
    // Reconstruct only the old firing requirement, preserving later hotkey edits.
    // Keep this regression reproducible after the implementation is committed.
    const oldSource = files['long_reach.opy'].replace(
        'eventPlayer.getHero() == Hero.DMON or eventPlayer.isFiringPrimaryFire()',
        'eventPlayer.isFiringPrimaryFire()');
    assert.notEqual(oldSource, files['long_reach.opy']);
    const before = await compile({...files, 'long_reach.opy': oldSource});
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = parsed(before), newRules = parsed(after);
    assert.deepEqual(rules(before.result).filter(r => r.name !== name), rules(after.result).filter(r => r.name !== name));
    const missed = makeState(before), stalled = start(oldRules.get(name), missed, oldRules);
    missed.time += 2; stalled.resume();
    assert.equal(missed.damage.length, 0, 'Baseline misses D.Mon sword input when the native firing flag is false');
    const held = makeState(after), task = start(newRules.get(name), held, newRules);
    for (let hit = 0; hit < 3; hit++) {
        if (hit) {held.time = task.deadline(); task.resume();}
        held.time = task.deadline(); task.resume();
        assert.equal(held.damage.length, hit + 1);
        assert.equal(held.damage[hit].amount, 45);
        assert(Math.abs(held.damage[hit].time - (100.2 + hit * 0.656)) < 1e-9);
    }
    const tapped = makeState(after), tap = start(newRules.get(name), tapped, newRules);
    tapped.buttons.clear(); tapped.time = tap.deadline(); tap.resume();
    assert.equal(tapped.damage.length, 1, 'Released click commits exactly one hit');
    tapped.time = tap.deadline(); tap.resume();
    tapped.time += 2; tap.resume(); assert.equal(tapped.damage.length, 1);
    const blockedStates = [{buttons: new Set()}, {blocking: true}, {ability1: true},
        {ability2: true}, {alternateForm: true}, {meleeing: true}, {ultimate: true},
        {alive: false}, {status: new Set(['Stunned'])}];
    for (const extra of blockedStates) {
        const state = makeState(after, extra);
        if (applies(newRules.get(name), state)) {
            const idle = start(newRules.get(name), state, newRules);
            state.time += 2; idle.resume();
        }
        assert.equal(state.damage.length, 0);
    }
    for (const hero of ['Reinhardt', 'Brigitte', 'Vendetta']) {
        const state = makeState(after, {hero});
        const idle = start(newRules.get(name), state, newRules);
        state.time += 2; idle.resume();
        assert.equal(state.damage.length, 0, hero + ' still requires the native attack state');
    }
    const output = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(output.encounteredWarnings, []);
    assert.deepEqual(rules(output.result), rules(after.result));
    fs.writeFileSync(path.join(root, 'main.ws.txt'), output.result);
    console.log(JSON.stringify({beforeElements: before.elements, afterElements: after.elements,
        deltaElements: after.elements - before.elements, changedRules: [name],
        verification: 'Reproduced missing native firing flag; held cadence, short click, input/form/ability/CC guards and other hero firing requirements checked.',
        limitation: 'Compiled-action interpreter only; native D.Mon flags and actual gameplay require an in-game check.'}, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
