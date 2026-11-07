// Execute emitted Workshop actions; native ray hits/physics still need an in-game check.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, actions, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const held = slot('augmentHeldZombie'), owner = slot('augmentZombieCarrier');
const until = slot('augmentHoldUntil'), attached = slot('botIsAttached');
const credit = slot('augmentThrowDamageCredit');
async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    assert(!compiled.has('DEAD WEIGHT LANDING'), 'Landing damage rule is removed');
    assert(!compiled.has('DEAD WEIGHT DELAYED DAMAGE'), 'No queue processor');
    const run = (name, state) => start(compiled.get(name), state, compiled);
    function setup(health = 100, statuses = []) {
        const s = scenario(11);
        s.player.team = 1; s.player.alive = true; s.player.hero = s.hero;
        const bot = {id: 'zombie', team: 2, dummy: true, alive: true, exists: true,
            health, maxHealth: 1000, status: new Set(statuses), position: [0, 0, 2]};
        s.targets = [bot]; s.raycastTarget = bot;
        return {s, bot};
    }
    function botState(s, bot) {
        return {...s, player: bot, targets: [s.player], status: bot.status,
            dummy: true, hero: 'Ana'};
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
    for (const list of ['bossStateList', 'miniBossList']) for (const status of ['Stunned', 'Knocked Down']) {
        const {s, bot} = setup(100, [status]); s.globals[list] = [bot];
        run('useLivingProjectile', s);
        assert(!s.player[held], `${list} cannot be picked up even with low HP and CC`);
        assert.equal(s.statusWrites.length, 0);
    }
    const miss = setup(); miss.s.raycastTarget = 0; run('useLivingProjectile', miss.s);
    assert(!miss.s.player[held]);
    const input = setup(); input.s.buttons.add('Interact');
    const interactName = 'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)';
    assert(run(interactName, input.s).done());
    assert.equal(input.s.player[held], input.bot, 'Pickup consumes the press before item queries');
    assert(run(interactName, input.s).done());
    assert.equal(input.s.player[until], 0, 'Next press requests throw before item queries');
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
    const interact = actions(compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)'));
    assert(interact.findIndex(a => a.includes('Call Subroutine(useLivingProjectile)')) < interact.findIndex(a => a.includes('Filtered Array')));
    for (const name of ['RIDER DETACH WHEN DEAD OR TARGET IS DEAD', 'RIDER DETATCH FROM TEAMMATES WHILE ALIVE'])
        assert(compiled.get(name).body.includes('augmentState0 == Null'));
    console.log(JSON.stringify({elements: build.elements,
        warnings: build.warnings, checked: 'boss/miniboss pickup ban / 5s hold / 6s knockdown from pickup / cleared synchronously with throw damage / eligibility / CC / input / lifetime cleanup / 50 damage after 0.75s / native Wait(0.75) / persistent credit / release before wait / pending release after wait / lethal throw cleanup / no cooldown / immediate repeat pickup / no landing rule or splash / item priority / Rider guards',
        limitation: 'Raycast geometry, attachment appearance and throw physics require Overwatch.'}, null, 2));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
