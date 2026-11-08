// Execute emitted Workshop actions; native ray hits/physics still need an in-game check.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, actions, applies, value} = require('./verify-augments.cjs');
const {args, checkWorkshop} = require('./verify-global-temporaries.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const held = slot('enhancementHeldZombie'), owner = slot('deadWeightZombieCarrier');
const until = slot('enhancementHoldUntil'), attached = slot('botIsAttached');
const credit = slot('deadWeightThrowDamageCredit');
async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    assert(!compiled.has('DEAD WEIGHT LANDING'), 'Landing damage rule is removed');
    assert(!compiled.has('DEAD WEIGHT DELAYED DAMAGE'), 'No queue processor');
    const run = (name, state) => start(compiled.get(name), state, compiled);
    assert(compiled.get('useLivingProjectile').body.includes('Multiply(Facing Direction Of(Event Player), 4)'),
        'The emitted pickup ray extends exactly four meters');
    assert(!files['variables.opy'].match(/enum Augment:([\s\S]*?)\n\n/)[1].includes('DEAD_WEIGHT'));
    const enhancementInit = compiled.get('PLAYER ENHANCEMENT INITIALIZATION');
    const selection = {...enhancementInit, body: enhancementInit.body.split('actions {\n')[0]
        + 'actions {\n' + actions(enhancementInit).slice(0, 2).join('\n') + '\n}'};
    for (let id = 1; id <= 11; id++) for (const missing of [false, true]) {
        const s = scenario(1, {randomRoll: id});
        if (!missing) s.player.enhancementId = 0;
        start(selection, s, compiled);
        assert.equal(s.player.enhancementId, id);
        start(selection, s, compiled);
        assert.deepEqual(s.randomCalls, [[1, 11]], 'Enhancement rolls include Dead Weight and persist');
    }
    for (let id = 0; id <= 11; id++) for (const backwards of [false, true]) {
        const s = scenario(1, {buttons: new Set(['Melee', ...(backwards ? ['Secondary Fire'] : [])])});
        s.globals.isPregameSetup = true;
        s.globals[slot('enhancementOptionList')] = Array(12).fill('icon');
        s.player.enhancementId = id;
        run('PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)', s);
        assert.equal(s.player.enhancementId, (id + (backwards ? 11 : 1)) % 12);
    }
    for (let id = 0; id <= 10; id++) for (const backwards of [false, true]) {
        const s = scenario(id, {buttons: new Set(['Interact', ...(backwards ? ['Secondary Fire'] : [])])});
        s.globals.isPregameSetup = true;
        run('PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)', s);
        assert.equal(s.player.augmentId, (id + (backwards ? 10 : 1)) % 11);
    }
    for (let id = 1; id <= 10; id++) {
        const s = scenario(0, {randomRoll: id});
        s.player.enhancementId = 11; s.player.initialMaxHealth = 250;
        run('PLAYER AUGMENT INITIALIZATION', s);
        assert.equal(s.player.augmentId, id);
        assert.deepEqual(s.randomCalls, [[1, 10]], 'Augment rolls exclude the moved ability');
        run('PLAYER ENHANCEMENT INITIALIZATION', s);
        assert.equal(s.player.enhancementId, 11, 'An explicit Dead Weight selection survives initialization');
        assert.equal(s.huds, 2, 'Each slot has an independent gameplay HUD');
    }
    function setup(health = 100, statuses = []) {
        const s = scenario(1);
        s.player.enhancementId = 11;
        s.player.team = 1; s.player.alive = true; s.player.hero = s.hero;
        const bot = {id: 'zombie', team: 2, dummy: true, alive: true, exists: true,
            health, maxHealth: 1000, status: new Set(statuses), position: [0, 0, 2]};
        s.targets = [bot]; s.raycastTarget = bot;
        return {s, bot};
    }
    function botState(s, bot) {
        return {...s, player: bot, expectedDamager: s.player, targets: [s.player], status: bot.status,
            dummy: true, hero: 'Ana'};
    }
    const hudAction = actions(enhancementInit).find(line => line.startsWith('Create HUD Text(') && line.includes('Custom String("Dead Weight")'));
    const hudStatus = args(hudAction)[2].replaceAll('Input Binding String(Button(Interact))', '"Interact"');
    // A shared enhancement slot may retain a previous role's value. Numeric,
    // array and entity values must all become idle before the HUD/input reads it.
    for (const stale of [0, 12, [], [1, 2, 3], {id: 'old target', exists: false}]) {
        const {s, bot} = setup();
        s.player[held] = stale; s.player[until] = 0;
        if (stale !== 0) {
            assert(value(hudStatus, s).includes('0s |'), 'Stale state reproduces the reported permanent 0s');
            run('useLivingProjectile', s);
            assert.equal(s.raycastCalls ?? 0, 0, 'Phantom carry requests a throw without querying a new target');
        }
        run('PLAYER ENHANCEMENT INITIALIZATION', s);
        assert.equal(s.player[held], 0, 'Initialization must clear the shared held-target slot');
        assert(value(hudStatus, s).includes('to pick up'), 'Idle HUD must show pickup, without a timer');
        s.buttons.add('Interact');
        const inputTask = run('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)', s);
        assert(inputTask.done());
        assert.equal(s.player[held], bot, 'First press after initialization must grab instead of requesting a phantom throw');
        assert(value(hudStatus, s).includes('5s |'), 'The timer measures hold duration only');
        const bs = botState(s, bot); bs.time += 5;
        run('LIVING PROJECTILE RELEASE', bs);
        assert(value(hudStatus, s).includes('to pick up'), 'Release restores the idle HUD immediately');
    }
    // Every independent Augment can own all of its state while carrying/throwing.
    for (let id = 1; id <= 10; id++) {
        const {s, bot} = setup(); s.player.augmentId = id;
        const slots = ['augmentState0', 'augmentState1', 'augmentState2', 'augmentState3'];
        slots.forEach((name, i) => s.player[name] = [i, id]);
        const before = slots.map(name => s.player[name]);
        run('useLivingProjectile', s); run('useLivingProjectile', s);
        const bs = botState(s, bot), task = run('LIVING PROJECTILE RELEASE', bs);
        bs.time += 0.75; task.resume();
        assert(task.done());
        assert.deepEqual(slots.map(name => s.player[name]), before, `Augment ${id} state survives carry and throw`);
    }
    // The zombie release can run between Interact handling and barrier placement.
    // Reserve the entire consumed press, preserving an already-running cooldown.
    const interactName = 'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)';
    const placementName = 'LASER BARRICADE (PLACEMENT)';
    const cooldown = slot('augmentBarrierPlacementCooldown');
    const voting = setup(); voting.s.globals.isGameplayActive = false; voting.s.buttons.add('Interact');
    assert(run(interactName, voting.s).done());
    assert.equal(voting.s.raycastCalls ?? 0, 0); assert(!voting.s.player[held], 'Pregame input cannot grab a zombie');
    const ended = setup(); ended.s.player.augmentId = 7; ended.s.player[cooldown] = 0;
    run('useLivingProjectile', ended.s);
    ended.s.globals.isGameplayActive = false; ended.s.buttons = new Set(['Crouch', 'Interact']);
    assert(run(interactName, ended.s).done());
    assert.equal(ended.s.player[until], 105, 'The action guard must not request a throw after game end');
    assert.equal(ended.s.player[cooldown], 0, 'Rejected input must not reserve barricade placement');
    assert(run('LIVING PROJECTILE RELEASE', botState(ended.s, ended.bot)).done());
    assert.equal(ended.s.player[held], 0); assert.equal(ended.s.damage.length, 0, 'The bot release rule still drops safely');
    for (const cooldownBefore of [0, 10]) {
        const {s, bot} = setup(); s.player.augmentId = 7; s.player[cooldown] = cooldownBefore;
        run('useLivingProjectile', s);
        s.buttons = new Set(['Crouch', 'Interact']);
        assert(!applies(compiled.get(placementName), s), 'A held zombie reserves Crouch + Interact before the input handler runs');
        assert(applies(compiled.get(interactName), s), 'Throw remains available with Crouch and Laser Barricade');
        const inputTask = run(interactName, s);
        const bs = botState(s, bot), release = run('LIVING PROJECTILE RELEASE', bs);
        assert.equal(s.player[held], 0);
        assert(!applies(compiled.get(placementName), s), 'Bot cleanup must not enable placement on the throwing press');
        assert.equal(s.player[cooldown], cooldownBefore || -2);
        s.buttons.delete('Interact'); inputTask.resume();
        assert(inputTask.done());
        assert.equal(s.player[cooldown], cooldownBefore, 'Throw spends no barricade cooldown');
        bs.time += 0.75; release.resume();
        assert(release.done());
        s.buttons.add('Interact');
        assert.equal(applies(compiled.get(placementName), s), cooldownBefore === 0,
            'The next press can place a ready barricade normally');
    }
    for (const health of [0, 199, 200, 1000]) for (const status of [null, 'Rooted', 'Hacked', 'Stunned', 'Asleep', 'Frozen', 'Knocked Down']) {
        const {s, bot} = setup(health, status ? [status] : []);
        bot.alive = health > 0;
        run('useLivingProjectile', s);
        const qualifies = health > 0 && (health < 200 || ['Stunned', 'Asleep', 'Frozen', 'Knocked Down'].includes(status));
        assert.equal(s.player[held] === bot, qualifies, `${health} HP / ${status}`);
        assert.equal(s.raycastCalls, 1);
        if (qualifies) {
            assert.equal(bot[owner], s.player); assert.equal(bot[attached], true);
            assert.equal(bot.attachedTo, s.player); assert.equal(s.player[until], 105);
            assert.equal(s.statusWrites[0].duration, 6);
            assert.equal(s.statusWrites[0].status, 'Knocked Down');
            assert(s.statusWrites[0].duration > s.player[until] - s.time,
                'Knockdown lasts six seconds from pickup, beyond the five-second hold limit');
        }
    }
    for (const change of [b => b.team = 1, b => b.dummy = false, b => b.alive = false,
        b => b[attached] = true, b => b[slot('botIsTeleporting')] = true,
        b => b[slot('botIsInitializing')] = true]) {
        const {s, bot} = setup(); change(bot); run('useLivingProjectile', s);
        assert(!s.player[held]);
    }
    for (const status of ['Stunned', 'Asleep', 'Frozen', 'Knocked Down']) {
        const {s} = setup(); s.status.add(status); run('useLivingProjectile', s);
        assert(!s.player[held]); assert.equal(s.raycastCalls ?? 0, 0, 'Blocked carriers must not query a target');
    }
    const carriedCarrier = setup(); carriedCarrier.s.player.isAttached = true;
    run('useLivingProjectile', carriedCarrier.s); assert(!carriedCarrier.s.player[held]);
    for (const list of ['bossStateList', 'miniBossList']) for (const status of ['Stunned', 'Knocked Down']) {
        const {s, bot} = setup(100, [status]); s.globals[list] = [bot];
        run('useLivingProjectile', s);
        assert(!s.player[held], `${list} cannot be picked up even with low HP and CC`);
        assert.equal(s.statusWrites.length, 0);
    }
    const miss = setup(); miss.s.raycastTarget = 0; run('useLivingProjectile', miss.s);
    assert(!miss.s.player[held]);
    const input = setup(); input.s.buttons.add('Interact');
    assert(run(interactName, input.s).done());
    assert.equal(input.s.player[held], input.bot, 'Pickup consumes the press before item queries');
    assert(run(interactName, input.s).done());
    assert.equal(input.s.player[until], 0, 'Next press requests throw before item queries');
    const scavenger = setup(); scavenger.s.player.augmentId = 9;
    const backpack = slot('augmentScavengerBackpack'), active = slot('powerUpItemId');
    scavenger.s.player[backpack] = [3, 7]; scavenger.s.player[active] = 5;
    scavenger.s.buttons = new Set(['Crouch', 'Interact']);
    Object.assign(scavenger.s.globals, {supplyPowerUpIdList: [1], supplyPowerUpPositionList: [[0, 1.5, 3]],
        supplyPowerUpEffectIdList: [101], supplyPowerUpTextIdList: [201]});
    run(interactName, scavenger.s); run(interactName, scavenger.s);
    assert.equal(scavenger.s.player[until], 0, 'Throw consumes Interact before crouched backpack pickup');
    assert.deepEqual(scavenger.s.player[backpack], [3, 7]); assert.equal(scavenger.s.player[active], 5);
    assert.deepEqual(scavenger.s.globals.supplyPowerUpIdList, [1]); assert.equal(scavenger.s.destroyedEffects.length, 0);
    const competing = setup(); competing.s.raycastTarget = input.bot;
    run('useLivingProjectile', competing.s);
    assert(!competing.s.player[held], 'Another player cannot steal the held zombie');
    for (const reason of ['throw', 'timeout', 'carrier death', 'disconnect', 'hero switch', 'bot death', 'game end', 'cleansed', 'teleport', 'carrier attached']) {
        const {s, bot} = setup(); run('useLivingProjectile', s);
        const bs = botState(s, bot);
        // Other rules may reuse global scratch before a carry transition occurs.
        bs.globals.tmp0 = {id: 'unrelated scratch writer'};
        assert(!applies(compiled.get('LIVING PROJECTILE RELEASE'), bs), 'Pickup stays in the held state');
        bs.time = 104.99;
        assert(!applies(compiled.get('LIVING PROJECTILE RELEASE'), bs), 'Zombie remains held until the five-second deadline');
        if (reason === 'throw') {s.time = bs.time = 101; run('useLivingProjectile', s); assert.equal(s.raycastCalls, 1);}
        if (reason === 'timeout') bs.time = 105;
        if (reason === 'carrier death') s.player.alive = false;
        if (reason === 'disconnect') s.player.exists = false;
        if (reason === 'hero switch') s.player.hero = 'Mercy';
        if (reason === 'bot death') bs.alive = false;
        if (reason === 'game end') bs.globals.isGameplayActive = false;
        if (reason === 'cleansed') bot.status.clear();
        if (reason === 'teleport') bot[slot('botIsTeleporting')] = true;
        if (reason === 'carrier attached') s.player.isAttached = true;
        const task = run('LIVING PROJECTILE RELEASE', bs);
        if (reason === 'throw') {
            assert(!task.done()); assert.equal(bs.damage.length, 0, 'Only damage waits; cleanup is already complete');
            assert.equal(bot[credit], s.player);
            assert.equal(bot[owner], 0); assert.equal(s.player[held], 0);
            bs.globals.tmp0 = 12345;
            bs.time = 101.749; task.resume(); assert.equal(bs.damage.length, 0);
            assert(bot.status.has('Knocked Down'), 'Knockdown persists until throw damage');
            bs.time = 101.75; task.resume();
            assert.equal(bs.damage.length, 1);
            assert.equal(bs.damage[0].amount, 50); assert.equal(bs.damage[0].targets[0], bot);
            assert.equal(bs.damage[0].time, 101.75); assert.equal(bot.health, 50);
            assert(!bot.status.has('Knocked Down'), 'Throw damage clears knockdown in the same tick');
        } else assert.equal(bs.damage.length, 0, 'Dropping or interruption does not deal damage');
        assert(task.done(), reason);
        assert.equal(bot.attachedTo, null); assert.equal(!!bot[attached], false);
        assert.equal(bot[owner], 0); assert.equal(s.player[held], 0);
        assert.equal(bs.impulses.length, reason === 'throw' ? 1 : 0, reason);
        if (reason === 'throw') assert.equal(bs.impulses[0].speed, 12.5);
        if (reason === 'timeout') {
            s.time = 106;
            run('useLivingProjectile', s);
            assert.equal(s.player[held], bot);
            assert.equal(s.player[until], 111, 'Pickup overwrites the inactive old deadline');
        }
    }
    // No cooldown: the same living bot can be picked up again immediately.
    const repeat = setup(40);
    run('useLivingProjectile', repeat.s);
    repeat.s.time = 101;
    run('useLivingProjectile', repeat.s);
    const repeatBot = botState(repeat.s, repeat.bot);
    repeatBot.time = 101;
    const lethal = run('LIVING PROJECTILE RELEASE', repeatBot);
    assert.equal(repeat.bot.health, 40);
    assert.equal(repeat.bot[owner], 0); assert.equal(repeat.s.player[held], 0, 'Cleanup precedes the delay');
    repeatBot.time = 101.75; lethal.resume();
    assert.equal(repeat.bot.health, 0, 'Throw damage can kill the target');
    assert(!repeat.bot.status.has('Knocked Down'), 'Lethal throw also clears knockdown');
    assert.equal(repeat.bot[owner], 0); assert.equal(repeat.s.player[held], 0, 'Lethal damage still cleans up');
    // New pickup during the wait must not overwrite the first throw's credit.
    const next = setup(150);
    run('useLivingProjectile', next.s); run('useLivingProjectile', next.s);
    const bs = botState(next.s, next.bot);
    const ongoing = run('LIVING PROJECTILE RELEASE', bs);
    next.s.time = bs.time = 100.1;
    run('useLivingProjectile', next.s); run('useLivingProjectile', next.s);
    assert.equal(next.s.player[held], next.bot);
    bs.time = 100.75; ongoing.resume();
    assert.equal(bs.damage.length, 1); assert(ongoing.done(), 'Cleared knockdown interrupts a pickup during the damage wait');
    assert.equal(next.s.player[held], 0, 'Pending release proceeds after the first wait');
    bs.time = 101.5; ongoing.resume();
    assert(ongoing.done()); assert.equal(bs.damage.length, 1);
    assert.equal(next.bot.health, 100);
    // Retained credit is inactive; a later timeout must not schedule damage.
    next.s.time = bs.time = 102;
    run('useLivingProjectile', next.s);
    bs.time = 107;
    const dropped = run('LIVING PROJECTILE RELEASE', bs);
    assert(dropped.done()); assert.equal(bs.damage.length, 1, 'Old credit cannot damage on a later drop');
    // A different carrier may grab the bot while the first throw's damage waits.
    // Shared scratch can change, but the bot-owned damage attribution must not.
    const first = setup(180); run('useLivingProjectile', first.s); run('useLivingProjectile', first.s);
    const firstBot = botState(first.s, first.bot), pending = run('LIVING PROJECTILE RELEASE', firstBot);
    const second = setup(); second.s.globals = firstBot.globals; second.s.raycastTarget = first.bot;
    second.s.targets = [first.bot]; second.s.time = 100.1;
    run('useLivingProjectile', second.s); assert.equal(first.bot[owner], second.s.player);
    assert.equal(first.bot[credit], first.s.player);
    firstBot.time = 100.75; pending.resume(); assert(pending.done());
    assert.equal(firstBot.damage.length, 1); assert.equal(first.bot.health, 130);
    assert.equal(second.s.player[held], 0, 'First throw clears knockdown and releases the second carry safely');
    assert.equal(first.bot[owner], 0);
    const interact = actions(compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)'));
    assert(interact.findIndex(a => a.includes('Call Subroutine(useLivingProjectile)')) < interact.findIndex(a => a.includes('Filtered Array')));
    for (const name of ['RIDER DETACH WHEN DEAD OR TARGET IS DEAD', 'RIDER DETATCH FROM TEAMMATES WHILE ALIVE'])
        assert(compiled.get(name).body.includes('Compare((Event Player).augmentState0, ==, Null)'));
    const scratchRules = [...build.result.matchAll(/^rule \("(?:useLivingProjectile|LIVING PROJECTILE RELEASE)"\) \{\n[\s\S]*?^\}/gm)].map(match => match[0]);
    assert.equal(scratchRules.length, 2); checkWorkshop(scratchRules.join('\n'));
    console.log(JSON.stringify({elements: build.elements,
        warnings: build.warnings, checked: 'stale shared-state initialization / idle HUD without timer / hold countdown and HUD reset / first pickup after initialization / 4m ray / primary selection forward and backward / 11 Enhancements and 10 Augments / explicit choice and late-join rolls / independent HUDs / all Augment state preserved / Laser Barricade throw priority and cooldown / boss/miniboss pickup ban / 5s hold / 6s knockdown from pickup / cleared synchronously with throw damage / eligibility / CC / input / lifetime cleanup / 50 damage after 0.75s / native Wait(0.75) / persistent credit / release before wait / pending release after wait / lethal throw cleanup / no cooldown / immediate repeat pickup / no landing rule or splash / item priority / Rider guards',
        limitation: 'Raycast geometry, attachment appearance and throw physics require Overwatch.'}, null, 2));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
