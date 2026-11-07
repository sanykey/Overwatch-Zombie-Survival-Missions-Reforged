// Validate compiled Leech behavior independently of native game health-pool physics.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, actions} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(rule => [rule.name, rule]));
    const lifesteal = compiled.get('LEECH LIFESTEAL');
    const init = compiled.get('PLAYER AUGMENT INITIALIZATION');
    const run = (rule, state) => start(rule, state, compiled);
    const energy = slot('enhancementCapacitorEnergy'), backpack = slot('augmentScavengerBackpack');
    assert(lifesteal.body.includes('Player Dealt Damage;\nTeam 1;'));
    assert(!lifesteal.body.includes('conditions {'), 'Eligibility must remain in Actions for the Workshop workaround');
    const emittedActions = actions(lifesteal);
    assert(emittedActions[0].startsWith('If('));
    assert.deepEqual(emittedActions.filter(line => !line.startsWith('If(') && line !== 'End;'),
        ['Heal(Event Player, Event Player, Multiply(Event Damage, 0.15));'],
        'Only guarded healing, with self attribution and no damage recursion, waits or state writes');

    let damageCases = 0;
    for (let enhancement = 1; enhancement <= 11; enhancement++)
    for (const damage of [0, 1, 40, 100, 1000]) for (const ability of [0, 'Primary Fire']) {
        const s = scenario(10, {eventDamage: damage, eventAbility: ability, maxHealth: 10000});
        Object.assign(s.player, {enhancementId: enhancement, health: 100, [energy]: 17, [backpack]: 42});
        s.expectedHealer = s.player;
        assert(run(lifesteal, s).done());
        assert.equal(s.player.health, 100 + damage * 0.15);
        assert.equal(s.player[energy], 17, 'Damage handler does not directly charge Overcharge');
        assert.equal(s.player[backpack], 42, 'Leech needs no shared augment state');
        assert.equal(s.damage.length, 0);
        damageCases++;
    }
    const capped = scenario(10, {eventDamage: 100, maxHealth: 250, eventWasHealthPack: false});
    Object.assign(capped.player, {enhancementId: 9, health: 249, [energy]: 10});
    capped.expectedHealer = capped.player;
    run(lifesteal, capped); assert.equal(capped.player.health, 250);
    capped.eventHealing = 1; // Native healing event reports only the actual missing health.
    run(compiled.get('OVERCHARGE STORES HEALING'), capped);
    assert.equal(capped.player[energy], 10 + 1 / 3);
    let eligibilityCases = 0;
    for (let augment = 0; augment <= 10; augment++) for (const active of [undefined, false, 0, true]) {
        const s = scenario(augment, {eventDamage: 100, maxHealth: 1000});
        if (active === undefined) delete s.globals.isGameplayActive;
        else s.globals.isGameplayActive = active;
        s.player.health = 100; s.expectedHealer = s.player;
        assert(applies(lifesteal, s), 'The event enters Actions even when eligibility fails');
        assert(run(lifesteal, s).done());
        const eligible = augment === 10 && active === true;
        assert.equal(s.player.health, eligible ? 115 : 100, 'Rejected events must not heal');
        assert.equal(s.healBonus, eligible ? 15 : undefined);
        assert.equal(s.damage.length, 0);
        eligibilityCases++;
    }
    const pregame = scenario(10, {globals: {isGameplayActive: false}});
    assert(!applies(init, pregame));

    for (let enhancement = 1; enhancement <= 11; enhancement++) {
        const s = scenario(10);
        Object.assign(s.player, {enhancementId: enhancement, initialMaxHealth: 250, [energy]: 17, [backpack]: 42});
        assert(run(init, s).done());
        assert.deepEqual(s.healthPools, [{type: 'Health', amount: 50, recoverable: true, reevaluate: 0}]);
        assert.equal(s.armor, 0); assert.equal(s.huds, 1);
        assert.equal(s.player[energy], 17); assert.equal(s.player[backpack], 42);
    }
    for (const augment of [1, 10]) {
        const waiting = scenario(augment); waiting.player.initialMaxHealth = 0;
        const task = run(init, waiting);
        assert(!task.done()); assert.deepEqual(waiting.healthPools ?? [], []);
        waiting.player.initialMaxHealth = 250; task.resume(); assert(task.done());
        assert.equal(waiting.healthPools.length, 1);
        assert.equal(waiting.healthPools[0].type, augment === 1 ? 'Armor' : 'Health');
        assert.equal(waiting.healthPools[0].amount, augment === 1 ? 75 : 50);
    }
    const switchHero = scenario(10); switchHero.player.isHeroSwitchRespawn = true;
    assert(!applies(init, switchHero), 'Hero-switch guard prevents repeated initialization');
    for (const absent of [false, true]) {
        const s = scenario(0, {randomRoll: 10}); s.player.initialMaxHealth = 250;
        if (absent) delete s.player.augmentId;
        run(init, s); assert.equal(s.player.augmentId, 10);
        assert.deepEqual(s.randomCalls, [[1, 10]]); assert.equal(s.healthPools[0].amount, 50);
    }
    assert(init.body.includes('15% lifesteal | +50 health'));
    assert(!compiled.has('APOTHECARY ALLOW HEALTH PACK PICKUP'));
    assert(![...compiled.keys()].some(name => name.includes('BOLT')));
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings.length, damageCases, eligibilityCases,
        checked: '15% native/scripted damage/all 11 Enhancements/self attribution/healing cap/Overcharge actual healing/no recursion/50 recoverable normal health/readiness gate/Kevlar/hero-switch gate/random choice/no shared state'}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
