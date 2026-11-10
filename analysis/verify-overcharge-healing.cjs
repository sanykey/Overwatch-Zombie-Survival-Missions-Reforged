// Dealt-healing events never credit Overcharge; native stat deltas and pack pickups do.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define enhancementCapacitor' + name + ' (\\w+)$', 'm'))[1];
const near = (actual, expected, message) => assert(Math.abs(actual - expected) < 1e-8,
    `${message || 'Energy mismatch'}: ${actual} vs ${expected}`);

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(rule => [rule.name, rule]));
    const healing = compiled.get('PLAYER DEALT HEALING');
    assert(healing.body.includes('Player Dealt Healing;\nTeam 1;'));
    assert(!healing.body.includes('conditions {'), 'Keep eligibility in the combined event Actions');
    const energy = slot('Energy'), charge = slot('Charge'), deadline = slot('Deadline'), snapshot = slot('StatsSnapshot');
    const run = (name, state) => {
        const task = start(compiled.get(name), state, compiled);
        if (name === 'OVERCHARGE ARMS CHARGE') {
            state.time = task.deadline();
            task.resume();
        }
        assert(task.done());
    };
    let healingCases = 0, packCases = 0;
    for (const hero of ['Brigitte', 'Soldier: 76'])
    for (const enhancement of [0, 1, 9]) for (const amount of [0, 0.75, 30, 750])
    for (const ability of [0, 'Ability 2']) for (const self of [false, true]) {
        const state = scenario(10, {hero, eventHealing: amount, eventAbility: ability});
        Object.assign(state.player, {enhancementId: enhancement, [energy]: 17, [charge]: 60, [deadline]: 101});
        state.healee = self ? state.player : {id: 'ally', [energy]: 123};
        run('PLAYER DEALT HEALING', state);
        near(state.player[energy], 17,
            JSON.stringify({hero, enhancement, amount, ability, self}));
        assert.equal(state.player[charge], 60);
        assert.equal(state.player[deadline], 101);
        if (!self) assert.equal(state.healee[energy], 123, 'Credit the healer');
        healingCases++;
    }
    for (const augment of [1, 8]) for (const attribution of ['none', 'self', 'other'])
    for (const healerFirst of [false, true]) for (const amount of [0, 2.25, 75, 250]) {
        const state = scenario(augment, {eventHealing: amount, eventAbility: 0,
            eventWasHealthPack: true, matchTime: 10, maxHealth: 1000});
        Object.assign(state.globals, {difficultySetting: 1, matchEndTime: 0, healthpackPositionList: [[0, 0, 0]]});
        Object.assign(state.player, {enhancementId: 9, health: 500, [energy]: 17, [charge]: 60, [deadline]: 101});
        state.healer = attribution === 'self' ? state.player : attribution === 'other' ? {id: 'other'} : 0;
        state.healee = state.player;
        const dealt = () => { if (attribution === 'self') run('PLAYER DEALT HEALING', state); };
        if (healerFirst) dealt();
        run('PLAYER PICKS UP HEALTH PACK', state);
        if (!healerFirst) dealt();
        near(state.player[energy], 17 + amount / 3 + (augment === 8 ? amount / 3 : 0),
            'Credit pack and actual Apothecary healing once in either event order');
        assert.equal(state.player[charge], 60);
        assert.equal(state.player[deadline], 101);
        assert.equal(state.player.health, 500 + (augment === 8 ? amount : 0));
        packCases++;
    }
    for (const health of [750, 999, 1000]) for (const enhancement of [1, 9]) {
        const state = scenario(8, {eventHealing: 75, eventWasHealthPack: true, matchTime: 10, maxHealth: 1000});
        Object.assign(state.globals, {difficultySetting: 1, matchEndTime: 0, healthpackPositionList: [[0, 0, 0]]});
        Object.assign(state.player, {enhancementId: enhancement, health, [energy]: 17});
        run('PLAYER PICKS UP HEALTH PACK', state);
        const actualBonus = Math.min(75, 1000 - health);
        assert.equal(state.player.health, health + actualBonus);
        near(state.player[energy], 17 + (enhancement === 9 ? (75 + actualBonus) / 3 : 0),
            'Supplemental energy uses actual restored HP and only belongs to Overcharge');
        packCases++;
    }
    const storedStats = compiled.get('OVERCHARGE STORES HEALING AND ASSISTS');
    const total = stats => stats['Healing Dealt'] / 3 + 10 * (stats['Offensive Assists'] + stats['Defensive Assists']);
    const initialization = compiled.get('PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION').body;
    assert(initialization.includes(`Set Player Variable(Event Player, ${snapshot}, Add(Divide(Player Stat(Event Player, Healing Dealt), 3),`),
        'Initialize the combined snapshot from current stats');
    let statCases = 0;
    for (const initialHealing of [0, 0.75, 10000])
    for (const healingGain of [0, 0.25, 1, 2, 750, 750002.25])
    for (const assists of [0, 1, 3]) {
        const state = scenario(1);
        const stats = {'Healing Dealt': initialHealing, 'Offensive Assists': 2, 'Defensive Assists': 4};
        Object.assign(state.player, {enhancementId: 9, stats, [energy]: 17, [charge]: 60,
            [deadline]: 101, [snapshot]: total(stats)});
        assert(!applies(storedStats, state), 'Do not pay for healing/assists before initialization');
        stats['Healing Dealt'] += healingGain;
        stats['Defensive Assists'] += assists;
        if (healingGain || assists) {
            assert(applies(storedStats, state));
            run(storedStats.name, state);
        }
        near(state.player[energy], 17 + healingGain / 3 + assists * 10);
        assert.equal(state.player[charge], 60, 'New earnings do not modify the armed charge');
        assert.equal(state.player[deadline], 101);
        assert(!applies(storedStats, state), 'Unchanged stats cannot pay twice');
        state.alive = false;
        stats['Offensive Assists']++;
        run(storedStats.name, state);
        const earned = state.player[energy];
        near(earned, 27 + healingGain / 3 + assists * 10, 'Posthumous assists still count');
        Object.assign(stats, {'Healing Dealt': 0, 'Offensive Assists': 0, 'Defensive Assists': 0});
        run(storedStats.name, state);
        near(state.player[energy], earned, 'Stat reset does not remove banked energy');
        assert.equal(state.player[snapshot], 0, 'Resynchronize after a reset');
        stats['Healing Dealt'] = 2.25;
        run(storedStats.name, state);
        near(state.player[energy], earned + 2.25 / 3, 'Credit new healing after a reset');
        statCases++;
    }
    for (const enhancement of [0, 1, 9]) for (const gameplay of [false, true]) {
        const state = scenario(1);
        state.globals.isGameplayActive = gameplay;
        Object.assign(state.player, {enhancementId: enhancement, stats: {'Healing Dealt': 50}, [snapshot]: 0});
        assert.equal(Boolean(applies(storedStats, state)), enhancement === 9 && gameplay);
    }
    let damageCases = 0;
    for (const storedCharge of [0, 0.75, 100]) for (const amount of [0, 30])
    for (const ability of [0, 'Primary Fire', 'Ability 2']) for (const self of [false, true]) {
        const state = scenario(1, {eventDamage: amount, eventAbility: ability});
        Object.assign(state.player, {enhancementId: 9, health: 500,
            [energy]: 150, [charge]: storedCharge, [deadline]: 0});
        state.victim = self ? state.player : {team: 2, health: 1000};
        run('PLAYER DEALT DAMAGE', state);
        const eligible = storedCharge > 0 && amount > 0 && ability !== 0 && !self;
        assert.equal(state.damage.length, Number(eligible), JSON.stringify({storedCharge, amount, ability, self}));
        assert.equal(state.player[deadline], eligible ? 100.3 : 0);
        near(state.player[energy], 150);
        assert.equal(state.player[charge], storedCharge);
        if (eligible) {
            assert.equal(state.victim.health, 1000 - storedCharge);
            assert.equal(state.damage[0].amount, storedCharge);
            // The engine emits a scripted Damage event with no Event Ability.
            state.eventAbility = 0;
            state.eventDamage = storedCharge;
            run('PLAYER DEALT DAMAGE', state);
            assert.equal(state.damage.length, 1, 'Bonus damage must not recursively trigger itself');
        }
        damageCases++;
    }
    const burst = scenario(1, {eventDamage: 30, eventAbility: 'Primary Fire'});
    Object.assign(burst.player, {enhancementId: 9, [energy]: 250, [charge]: 0, [deadline]: 0});
    burst.buttons.add('Melee');
    run('OVERCHARGE ARMS CHARGE', burst);
    assert.equal(burst.player[charge], 100);
    assert.equal(burst.player[energy], 150);
    burst.buttons.delete('Melee');
    burst.time = 200;
    assert(!applies(compiled.get('OVERCHARGE CLEARS CHARGE'), burst), 'An armed charge waits for a hit');
    for (const time of [200, 200.1, 200.299]) {
        burst.time = time;
        burst.victim = {team: 2, health: 1000};
        run('PLAYER DEALT DAMAGE', burst);
        assert.equal(burst.victim.health, 900, 'Every target within the window gets the fixed bonus');
        assert.equal(burst.player[deadline], 200.3, 'Additional hits cannot extend the window');
    }
    burst.time = 200.3;
    run('PLAYER DEALT DAMAGE', burst);
    assert.equal(burst.damage.length, 3, 'No bonus at or after the deadline');
    run('OVERCHARGE CLEARS CHARGE', burst);
    assert.equal(burst.player[charge], 0, 'The active weapon charge is consumed');
    assert.equal(burst.player[deadline], 0);
    assert.equal(burst.player[energy], 150, 'Unspent energy survives the burst');
    burst.buttons.add('Melee');
    run('OVERCHARGE ARMS CHARGE', burst);
    assert.equal(burst.player[charge], 100, 'The next charge can be armed');
    assert.equal(burst.player[energy], 50);
    burst.alive = false;
    run('OVERCHARGE CLEARS CHARGE', burst);
    assert.equal(burst.player[charge], 0, 'Death clears the armed charge');
    assert.equal(burst.player[energy], 50);
    if (process.argv.includes('--export')) {
        const exported = await compiler.compile(fs.readFileSync('main.opy', 'utf8'), 'en-US',
            process.cwd().replace(/\\/g, '/') + '/', 'main.opy');
        assert.equal(exported.nbElements, build.elements);
        assert.deepEqual(exported.encounteredWarnings, []);
        fs.writeFileSync('main.ws.txt', exported.result);
    }
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings, healingCases, packCases, statCases, damageCases,
        limitation: 'Native Healing Dealt coverage and update timing require an in-game check.'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
