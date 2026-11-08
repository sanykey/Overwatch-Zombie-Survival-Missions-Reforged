// Validate compiled Leech behavior independently of native game health-pool physics.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, actions, enhancementCount} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(rule => [rule.name, rule]));
    const lifesteal = compiled.get('LEECH LIFESTEAL');
    const combinedInit = compiled.get('PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION');
    // Keep this focused on the augment macro after initialization was merged.
    const initActions = actions(combinedInit);
    const augmentStart = initActions.findIndex(line => line === 'Skip If(Compare((Event Player).augmentId, !=, Null), True);');
    assert(augmentStart >= 0);
    const init = {...combinedInit, body: combinedInit.body.split('actions {\n')[0] +
        'actions {\n' + initActions.slice(augmentStart).join('\n') + '\n}'};
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
    for (let enhancement = 1; enhancement <= enhancementCount; enhancement++)
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
        const eligible = augment === 10; // d9571b0 intentionally removed the gameplay-phase gate.
        assert.equal(s.player.health, eligible ? 115 : 100, 'Rejected events must not heal');
        assert.equal(s.healBonus, eligible ? 15 : undefined);
        assert.equal(s.damage.length, 0);
        eligibilityCases++;
    }
    const pregame = scenario(10, {globals: {isGameplayActive: false}});
    assert(!applies(init, pregame));

    // Execute the emitted death-handler prefixes before unrelated cleanup/waits.
    const ordinary = compiled.get('BOT DIES');
    const boss = compiled.get('BOSS DIES (ALL BOSS OBJECTIVES)');
    const prefix = (rule, end) => ({body: 'actions {\n' + rule.body.split('actions {\n')[1].split(end)[0].trimEnd() + '\n}'});
    const ordinaryPrefix = prefix(ordinary, 'If(And(And((Event Player).');
    const bossPrefix = prefix(boss, 'If(Compare((Event Player).');
    // The boss prefix ends inside the outer environment block.
    bossPrefix.body = bossPrefix.body.slice(0, -2) + '\nEnd;\n}';
    let environmentCases = 0;
    for (const isBoss of [false, true])
    for (const environmental of [false, true])
    for (const team of [1, 2])
    for (const augment of [0, 9, 10])
    for (const hp of [1, 100, 200, 1000, 15000]) {
        const s = scenario(augment, {eventDamage: hp, maxHealth: 10000});
        s.player.health = 0; s.player.team = 2;
        s.attacker = {team, augmentId: augment, health: 100};
        s.expectedHealer = s.attacker; s.eventWasEnvironment = environmental;
        assert(run(isBoss ? bossPrefix : ordinaryPrefix, s).done());
        const eligible = environmental && team === 1 && augment === 10;
        assert.equal(s.attacker.health, 100 + (eligible ? Math.min(hp, isBoss ? 200 : hp) * 0.15 : 0));
        assert.equal(s.player.health, 0, 'Heal the credited attacker, never the dead bot');
        assert.equal(s.damage.length, 0, 'Environmental lifesteal does not deal recursive damage');
        environmentCases++;
    }

    for (let enhancement = 1; enhancement <= enhancementCount; enhancement++) {
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
    assert(compiled.has('BOLT STRIKE DAMAGE'));
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings.length, damageCases, eligibilityCases, environmentCases,
        checked: '15% native/scripted damage/all Enhancements including Bolt Strike/self attribution/healing cap/Overcharge actual healing/no recursion/50 recoverable normal health/readiness gate/Kevlar/hero-switch gate/random choice/no shared state'}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
