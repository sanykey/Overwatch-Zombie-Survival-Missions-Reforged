// Execute emitted Workshop actions; native pool rendering/physics still need an in-game check.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, allowsInteraction, actions} = require('./verify-augments.cjs');

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    const gift = compiled.get('LEECH GRANTS ALLY OVERHEALTH');
    assert(gift.body.includes('Wait(0.3, Abort When False);'));
    assert(gift.body.includes('Remove From Array(All Living Players(All Teams), Event Player), Event Player, True)'));
    assert(gift.body.includes('Multiply(Facing Direction Of(Event Player), 30)'));
    assert(!gift.body.includes('Heal(') && !gift.body.includes('Damage('));
    assert(!gift.body.includes('Loop'), 'One application per uninterrupted hold');

    function setup(hp = 175, remaining = null) {
        const s = scenario(10, {poolState: new Map(), nextHealthPool: 100});
        Object.assign(s.player, {health: hp, team: 1});
        s.buttons = new Set(['Crouch', 'Interact']);
        const ally = {team: 1, alive: true, position: [0, 0, 10], health: 200, augmentId: 9};
        s.targets = [ally]; s.raycastTarget = ally;
        // A different source's pool must survive every replacement.
        s.poolState.set(90, {player: ally, remaining: 30}); ally.health += 30;
        if (remaining !== null) {
            ally.leechGrantedHealthPoolId = 99;
            if (remaining > 0) {s.poolState.set(99, {player: ally, remaining}); ally.health += remaining;}
        }
        return {s, ally};
    }
    const complete = s => {
        const queries = s.raycastCalls ?? 0;
        const task = start(gift, s, compiled);
        assert(!task.done()); assert.equal(s.raycastCalls ?? 0, queries);
        s.time += 0.299; task.resume(); assert(!task.done());
        s.time += 0.002; task.resume(); assert(task.done());
        return task;
    };
    let replacements = 0;
    for (const hp of [175, 176, 300, 1000]) for (const remaining of [null, 0, 1, 30, 50]) {
        const {s, ally} = setup(hp, remaining);
        complete(s);
        assert.equal(s.player.health, hp - 150);
        assert(s.player.health >= 25);
        assert.equal(ally.health, 280, 'Exactly 50 gift HP plus the unrelated 30 HP');
        assert(!s.poolState.has(99)); assert(s.poolState.has(90));
        assert.equal(s.poolState.get(ally.leechGrantedHealthPoolId).remaining, 50);
        assert.equal([...s.poolState.values()].filter(p => p.player === ally).length, 2);
        assert.deepEqual(s.healthPools, [{type: 'Health', amount: 50, recoverable: 0, reevaluate: 0}]);
        assert.equal(s.raycastCalls, 1); assert.equal(s.damage.length, 0);
        replacements++;
    }
    // A different Leech donor replaces the same recipient-owned pool.
    const shared = setup(500, 25); complete(shared.s);
    const firstPool = shared.ally.leechGrantedHealthPoolId;
    shared.s.player = {...shared.s.player, health: 300}; complete(shared.s);
    assert(!shared.s.poolState.has(firstPool)); assert.equal(shared.ally.health, 280);
    assert.equal(shared.s.player.health, 150);

    for (const hp of [0, 25, 150, 174.99]) assert(!applies(gift, setup(hp).s));
    for (const interrupt of ['Crouch', 'Interact', 'health', 'death', 'phase', 'augment', 'carry']) {
        const {s} = setup();
        const task = start(gift, s, compiled);
        if (interrupt === 'health') s.player.health = 174;
        else if (interrupt === 'death') s.alive = false;
        else if (interrupt === 'phase') s.globals.isGameplayActive = false;
        else if (interrupt === 'augment') s.player.augmentId = 9;
        else if (interrupt === 'carry') {
            s.player.enhancementId = 11;
            const heldSlot = files['variables.opy'].match(/^#!define enhancementHeldZombie (\w+)$/m)[1];
            s.player[heldSlot] = {alive: true};
        } else s.buttons.delete(interrupt);
        s.time += 0.301; task.resume(); assert(task.done());
        assert.equal(s.raycastCalls ?? 0, 0); assert.equal(s.healthPools, undefined);
    }
    for (const invalid of ['none', 'enemy', 'npc']) {
        const {s, ally} = setup();
        if (invalid === 'none') s.raycastTarget = 0;
        else if (invalid === 'enemy') ally.team = 2;
        else ally.dummy = true;
        complete(s); assert.equal(s.player.health, 175); assert.equal(s.healthPools, undefined);
    }
    const interact = compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)');
    const input = setup().s;
    assert(!allowsInteraction(interact, input), 'Crouch + Interact cannot also consume a powerup');
    input.buttons.delete('Crouch'); assert(applies(interact, input));

    const cleanupRule = compiled.get('PLAYER GETS DOWNED');
    const cleanup = {body: 'actions {\n' + actions(cleanupRule).slice(0, actions(cleanupRule).findIndex(a => a.startsWith('Wait('))).join('\n') + '\n}'};
    const dead = setup(175, 30);
    dead.s.player = dead.ally;
    start(cleanup, dead.s, compiled);
    assert.equal(dead.ally.leechGrantedHealthPoolId, 0);
    assert(!dead.s.poolState.has(99)); assert(dead.s.poolState.has(90));
    console.log(JSON.stringify({elements: build.elements, warnings: 0, replacements,
        checked: 'fixed cost/full-partial-empty pools/other sources/multiple donors/175 HP threshold/hold interruptions/invalid targets/input reservation/death cleanup'}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
