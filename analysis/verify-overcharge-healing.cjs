// Exercise the current combined healing handler, rather than the retired standalone rule.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define enhancementCapacitor' + name + ' (\\w+)$', 'm'))[1];

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(rule => [rule.name, rule]));
    const healing = compiled.get('PLAYER DEALT HEALING');
    assert(healing.body.includes('Player Dealt Healing;\nTeam 1;'));
    assert(!healing.body.includes('conditions {'), 'Keep eligibility in the combined event Actions');
    const energy = slot('Energy'), charge = slot('Charge'), deadline = slot('Deadline');
    const run = (name, state) => assert(start(compiled.get(name), state, compiled).done());
    let healingCases = 0, packCases = 0;
    for (const hero of ['Brigitte', 'Soldier: 76'])
    for (const enhancement of [0, 1, 9]) for (const amount of [0, 0.75, 30, 750])
    for (const ability of [0, 'Ability 2']) for (const self of [false, true]) {
        const state = scenario(10, {hero, eventHealing: amount, eventAbility: ability});
        Object.assign(state.player, {enhancementId: enhancement, [energy]: 17, [charge]: 60, [deadline]: 101});
        state.healee = self ? state.player : {id: 'ally', [energy]: 123};
        run('PLAYER DEALT HEALING', state);
        assert.equal(state.player[energy], 17 + (enhancement === 9 ? amount : 0),
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
        assert.equal(state.player[energy], 17 + amount, 'Count each pack once in either event order');
        assert.equal(state.player[charge], 60);
        assert.equal(state.player[deadline], 101);
        assert.equal(state.player.health, 500 + (augment === 8 ? amount : 0));
        packCases++;
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
        assert.equal(state.player[energy], 150);
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
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings, healingCases, packCases, damageCases,
        limitation: 'Native Inspire event attribution requires an in-game check.'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
