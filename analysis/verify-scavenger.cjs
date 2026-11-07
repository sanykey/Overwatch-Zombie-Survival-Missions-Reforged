// Exercise the compiled inventory transactions, loot rolls and actual item-use path.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, actions} = require('./verify-augments.cjs');
const {checkWorkshop, args} = require('./verify-global-temporaries.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const active = slot('powerUpItemId'), backpack = slot('augmentScavengerBackpack');
const interact = 'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)';

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const parsed = rules(build.result), compiled = new Map(parsed.map(rule => [rule.name, rule]));
    // The grouped predicate is an engine workaround, not just a source-level style:
    // OverPy normally expands it into separate conditions and restores the defect.
    const manualConditions = compiled.get('PLAYER DROPS POWER UP (MANUAL)').body.match(/conditions \{([\s\S]*?)\}/)[1];
    assert(manualConditions.includes('And(Global.isGameplayActive, Is Alive(Event Player)) == True;'));
    assert(!manualConditions.includes('Global.isGameplayActive == True;'));
    assert(!manualConditions.includes('\nIs Alive(Event Player) == True;'));
    const run = (name, state) => start(compiled.get(name), state, compiled);
    const state = (held = 0, reserve = [], augment = 9, enhancement = 1) => {
        const s = scenario(augment, {ground: true, buttons: new Set(['Interact']), maxHealth: 1000});
        Object.assign(s.player, {enhancementId: enhancement, [active]: held, [backpack]: [...reserve], health: 100});
        Object.assign(s.globals, {supplyPowerUpIdList: [], supplyPowerUpPositionList: [],
            supplyPowerUpEffectIdList: [], supplyPowerUpTextIdList: [],
            supplyDropLandingPosition: [100, 0, 0], supplyDropPosition: [100, 0, 0],
            isSupplyDropOpen: true, offsetUpQuarterConst: [0, 0.25, 0]});
        return s;
    };
    const ground = (s, id) => {
        s.globals.supplyPowerUpIdList = [id];
        s.globals.supplyPowerUpPositionList = [[0, 1.5, 3]];
        s.globals.supplyPowerUpEffectIdList = [101];
        s.globals.supplyPowerUpTextIdList = [201];
        s.liveEffects.add(101);
    };
    const pickup = (s, id) => {
        ground(s, id);
        assert(run(interact, s).done(), 'Pickup must commit without waits');
        assert(s.destroyedEffects.includes(101));
        assert(s.destroyedTexts.includes(201));
        assert.equal(s.globals.supplyPowerUpEffectIdList.length, 0);
        assert.equal(s.globals.supplyPowerUpTextIdList.length, 0);
        assert.equal(s.globals.supplyPowerUpIdList.length, s.globals.supplyPowerUpPositionList.length);
    };
    const interactRule = compiled.get(interact);
    const interactConditions = interactRule.body.match(/conditions \{([\s\S]*?)\}/)[1];
    assert(!interactConditions.includes('Global.isGameplayActive'), 'Keep phase eligibility out of Interact Conditions');
    assert.equal(actions(interactRule)[0], 'Abort If(Not(Global.isGameplayActive));', 'Reject pregame before any item query or mutation');
    for (const phase of [undefined, false, 0]) {
        const s = state(1, [7]); s.buttons.add('Crouch'); ground(s, 4);
        if (phase === undefined) delete s.globals.isGameplayActive;
        else s.globals.isGameplayActive = phase;
        s.globals.isSupplyDropOpen = false; s.globals.tmp0 = 1234;
        assert(applies(interactRule, s), 'The pressed input reaches the action-level phase guard');
        assert(run(interact, s).done());
        assert.equal(s.globals.isSupplyDropOpen, false);
        assert.deepEqual(s.globals.supplyPowerUpIdList, [4]);
        assert.deepEqual(s.player[backpack], [7]); assert.equal(s.player[active], 1);
        assert.equal(s.destroyedEffects.length, 0); assert.equal(s.globals.tmp0, 1234);
    }
    for (const stop of ['game end', 'released Interact', 'death']) {
        const s = state(1, [7]); s.player.infectionLevel = 5;
        const pending = run(interact, s); assert(!pending.done());
        if (stop === 'game end') s.globals.isGameplayActive = false;
        if (stop === 'released Interact') s.buttons.delete('Interact');
        if (stop === 'death') s.alive = false;
        s.time += 0.25; pending.resume(); assert(pending.done());
        assert.equal(s.player[active], 1, 'Interrupted item use must not consume the active item');
        assert.deepEqual(s.player[backpack], [7]); assert.equal(s.player.infectionLevel, 5);
        assert.equal(s.effects.length, 0);
    }

    const crate = state(); crate.buttons.add('Crouch'); ground(crate, 4);
    Object.assign(crate.globals, {supplyDropLandingPosition: [0, 1.5, 3],
        supplyDropPosition: [0, 1.5, 3], isSupplyDropOpen: false, supplyDropPowerUpCount: 3});
    crate.randomRolls = [1, 7, 13];
    assert(run(interact, crate).done());
    assert.equal(crate.globals.isSupplyDropOpen, true);
    assert.deepEqual(crate.globals.supplyPowerUpIdList, [4, 1, 7, 13]);
    assert.equal(crate.globals.supplyPowerUpPositionList.length, 4);
    assert.deepEqual(crate.player[backpack], [], 'Opening a crate takes precedence over stashing the aimed item');
    assert.equal(crate.player[active], 0);

    const carrier = state();
    pickup(carrier, 1); assert.equal(carrier.player[active], 1); assert.deepEqual(carrier.player[backpack], []);
    pickup(carrier, 3); assert.equal(carrier.player[active], 3); assert.deepEqual(carrier.player[backpack], []);
    assert.deepEqual(carrier.globals.supplyPowerUpIdList, [1], 'Plain Interact trades only the active item');
    carrier.buttons.add('Crouch');
    pickup(carrier, 7); assert.equal(carrier.player[active], 3); assert.deepEqual(carrier.player[backpack], [7]);
    pickup(carrier, 9); assert.equal(carrier.player[active], 3); assert.deepEqual(carrier.player[backpack], [7, 9]);
    ground(carrier, 13);
    assert(run(interact, carrier).done());
    assert.deepEqual(carrier.globals.supplyPowerUpIdList, [13], 'Full crouched backpack pickup leaves the item on the ground');
    assert.equal(carrier.player[active], 3); assert.deepEqual(carrier.player[backpack], [7, 9]);
    carrier.buttons.delete('Crouch');
    pickup(carrier, 1); assert.equal(carrier.player[active], 1); assert.deepEqual(carrier.player[backpack], [7, 9]);
    assert.deepEqual(carrier.globals.supplyPowerUpIdList, [3], 'Plain Interact still trades when the backpack is full');
    const reserveFirst = state(); reserveFirst.buttons.add('Crouch');
    pickup(reserveFirst, 5); assert.equal(reserveFirst.player[active], 0); assert.deepEqual(reserveFirst.player[backpack], [5]);
    reserveFirst.buttons.delete('Crouch'); pickup(reserveFirst, 2);
    assert.equal(reserveFirst.player[active], 2); assert.deepEqual(reserveFirst.player[backpack], [5]);
    // Execute the real Cure branch: it consumes only the active slot, never a reserve item.
    carrier.globals.supplyPowerUpIdList = []; carrier.globals.supplyPowerUpPositionList = [];
    carrier.player.infectionLevel = 5;
    const use = run(interact, carrier);
    assert(!use.done()); carrier.time += 0.25; use.resume(); assert(use.done());
    assert.equal(carrier.player[active], 0); assert.deepEqual(carrier.player[backpack], [7, 9]);
    assert.equal(carrier.player.infectionLevel, 0);
    assert(run(interact, carrier).done(), 'A reserve-only carrier cannot start an item-use action');
    assert.deepEqual(carrier.player[backpack], [7, 9]);

    for (const augment of [1, 8]) {
        const ordinary = state(1, [99], augment);
        ordinary.buttons.add('Crouch');
        pickup(ordinary, 4);
        assert.equal(ordinary.player[active], 4); assert.deepEqual(ordinary.globals.supplyPowerUpIdList, [1]);
        assert.deepEqual(ordinary.player[backpack], [99], 'Other augments never read/write the aliased backpack slot');
    }
    const primaryState = slot('enhancementBulkStacks');
    for (let enhancement = 1; enhancement <= 11; enhancement++) {
        const s = state(1, [], 9, enhancement); s.buttons.add('Crouch');
        const primaryValue = enhancement === 11 ? 0 : 42; // Dead Weight's idle held-target is null.
        s.player[primaryState] = primaryValue; pickup(s, 7);
        assert.deepEqual(s.player[backpack], [7]); assert.equal(s.player[primaryState], primaryValue, 'Backpack storage must not overwrite any primary enhancement state');
        assert.equal(s.player.health, 100, 'Scavenger no longer grants lifesteal');
    }
    // Scavenger and Laser Barricade are now mutually exclusive Augments.
    const barrier = state(1, [], 7); barrier.buttons.add('Crouch'); ground(barrier, 4);
    assert(!applies(compiled.get(interact), barrier));
    assert(applies(compiled.get('LASER BARRICADE (PLACEMENT)'), barrier));
    assert(compiled.get('LASER BARRICADE (PLACEMENT)').body.includes('Compare((Event Player).enhancementId, !=, 11)'));
    const usePreview = actions(compiled.get('PLAYER AUGMENT INITIALIZATION')).find(l => l.startsWith('Create Beam Effect('));
    assert(usePreview.includes('augmentState2, ==, -1'));
    // Duplicate item types occupy separate slots and must all be dropped exactly once.
    for (const held of [0, 1]) for (const reserve of [[], [7], [7, 7]]) {
        const s = state(held, reserve); s.buttons = new Set(['Reload']);
        const manual = 'PLAYER DROPS POWER UP (MANUAL)';
        if (!held && !reserve.length) { assert(!applies(compiled.get(manual), s)); continue; }
        const drop = run(manual, s);
        s.time += 0.249; drop.resume(); assert(!drop.done());
        s.time += 0.001; drop.resume(); assert(drop.done());
        assert.deepEqual(s.globals.supplyPowerUpIdList, [...(held ? [held] : []), ...reserve]);
        assert.equal(s.player[active], 0); assert.deepEqual(s.player[backpack], []);
        assert.equal(s.globals.supplyPowerUpPositionList.length, s.globals.supplyPowerUpIdList.length);
        assert.equal(new Set(s.globals.supplyPowerUpPositionList.map(JSON.stringify)).size, s.globals.supplyPowerUpIdList.length);
        assert(!applies(compiled.get(manual), s), 'Continuing to hold Reload cannot duplicate the drop');
    }
    for (const cancel of [s => s.buttons.clear(), s => {s.alive = false;}, s => {s.globals.isGameplayActive = false;}]) {
        const s = state(2, [5, 6]); s.buttons = new Set(['Reload']);
        const task = run('PLAYER DROPS POWER UP (MANUAL)', s); cancel(s); task.resume();
        assert(task.done()); assert.equal(s.player[active], 2); assert.deepEqual(s.player[backpack], [5, 6]);
        assert.equal(s.globals.supplyPowerUpIdList.length, 0, 'Interrupted hold must not publish any items');
    }
    const dead = state(2, [4, 8]); dead.alive = false; dead.ground = false; dead.walkablePosition = [10, 0, 10];
    assert(run('PLAYER DROPS POWER UP (DEATH)', dead).done());
    assert.deepEqual(dead.globals.supplyPowerUpIdList, [2, 4, 8]);
    assert.equal(dead.player[active], 0); assert.deepEqual(dead.player[backpack], []);
    const ordinaryDrop = state(4, [99], 1); ordinaryDrop.buttons = new Set(['Reload']);
    const task = run('PLAYER DROPS POWER UP (MANUAL)', ordinaryDrop); ordinaryDrop.time += 0.25; task.resume();
    assert(task.done()); assert.deepEqual(ordinaryDrop.globals.supplyPowerUpIdList, [4]);
    assert.deepEqual(ordinaryDrop.player[backpack], [99]);
    const ordinaryDeath = state(4, [99], 1); ordinaryDeath.alive = false; ordinaryDeath.ground = false;
    const corpseDrop = run('PLAYER DROPS POWER UP (DEATH)', ordinaryDeath);
    assert(!corpseDrop.done()); assert.deepEqual(ordinaryDeath.globals.supplyPowerUpIdList, []);
    ordinaryDeath.ground = true; ordinaryDeath.time += 0.25; corpseDrop.resume(); assert(corpseDrop.done());
    assert.deepEqual(ordinaryDeath.globals.supplyPowerUpIdList, [4]);
    assert.deepEqual(ordinaryDeath.globals.supplyPowerUpPositionList, [[0, 0.25, 0]]);
    assert.deepEqual(ordinaryDeath.player[backpack], [99], 'Other augments retain the original corpse-ground wait and their own state');

    // Two players contend for the same ground item. The second transaction
    // observes the committed lists and cannot acquire or destroy it a second time.
    for (const firstAugment of [1, 9]) {
        const first = state(0, [], firstAugment), second = state();
        if (firstAugment === 9) first.buttons.add('Crouch');
        second.buttons.add('Crouch'); ground(first, 6); second.globals = first.globals;
        assert(run(interact, first).done()); assert(run(interact, second).done());
        assert.equal(firstAugment === 9 ? first.player[backpack][0] : first.player[active], 6);
        assert.equal(second.player[active], 0); assert.deepEqual(second.player[backpack], []);
        assert.deepEqual(first.globals.supplyPowerUpIdList, []);
        assert.equal(second.destroyedEffects.length, 0);
    }
    const interruptedByDeath = state(2, [4, 8]); interruptedByDeath.buttons = new Set(['Reload']);
    const pendingDrop = run('PLAYER DROPS POWER UP (MANUAL)', interruptedByDeath);
    interruptedByDeath.alive = false;
    assert(run('PLAYER DROPS POWER UP (DEATH)', interruptedByDeath).done());
    interruptedByDeath.time += 0.25; pendingDrop.resume(); assert(pendingDrop.done());
    assert.deepEqual(interruptedByDeath.globals.supplyPowerUpIdList, [2, 4, 8], 'Death during Reload publishes each item once');
    const heroSwitch = state(3, [5, 7]); heroSwitch.player.isHeroSwitchRespawn = true;
    assert(!applies(compiled.get('PLAYER AUGMENT INITIALIZATION'), heroSwitch));
    assert.deepEqual(heroSwitch.player[backpack], [5, 7]);

    const loot = 'SCAVENGER BOT LOOT';
    assert(compiled.get(loot).body.includes('Player Earned Elimination;'), 'Kills and damage participation use elimination credit, not only final blows');
    for (let roll = 1; roll <= 20; roll++) {
        const s = state(); s.victim = {team: 2, dummy: true, position: [5, 2, 5]}; s.randomRolls = [roll, 7];
        run(loot, s);
        assert.deepEqual(s.player[backpack], roll === 1 ? [7] : []);
        assert.deepEqual(s.globals.supplyPowerUpIdList, []);
        assert.deepEqual(s.globals.supplyPowerUpPositionList, []);
        assert.equal(s.randomCalls.length, roll === 1 ? 2 : 1, 'Draw the item type only after a successful 1/20 roll');
    }
    for (let id = 1; id <= 13; id++) for (const reserve of [[], [3], [3, 4]]) for (const held of [0, 1]) {
        const s = state(held, reserve); s.victim = {team: 2, dummy: true, position: [5, 2, 5]}; s.randomRolls = [1, id];
        assert(run(loot, s).done(), 'Loot delivery must be synchronous');
        assert.equal(s.player[active], held, 'Loot never replaces or activates the main item');
        if (reserve.length < 2) {
            assert.deepEqual(s.player[backpack], [...reserve, id]);
            assert.deepEqual(s.globals.supplyPowerUpIdList, []); assert.deepEqual(s.globals.supplyPowerUpPositionList, []);
        } else {
            assert.deepEqual(s.player[backpack], reserve);
            assert.deepEqual(s.globals.supplyPowerUpIdList, [id]);
            assert.deepEqual(s.globals.supplyPowerUpPositionList, [[5, 2.25, 5]]);
        }
        assert.deepEqual(s.randomCalls, [[1, 20], [1, 13]]);
    }
    const consecutive = state(0, [3]); consecutive.victim = {team: 2, dummy: true, position: [5, 2, 5]};
    consecutive.randomRolls = [1, 5, 1, 6]; run(loot, consecutive); run(loot, consecutive);
    assert.deepEqual(consecutive.player[backpack], [3, 5]);
    assert.deepEqual(consecutive.globals.supplyPowerUpIdList, [6], 'After filling the last reserve slot, the next success falls to the ground');
    for (const victim of [{team: 1, dummy: true}, {team: 2, dummy: false}]) {
        const s = state(); s.victim = victim; assert(!applies(compiled.get(loot), s));
    }
    const other = state(0, [], 1); assert(!applies(compiled.get(loot), other));
    const stopped = state(); stopped.globals.isGameplayActive = false; assert(!applies(compiled.get(loot), stopped));
    assert(!compiled.has('SCAVENGER LIFESTEAL'));
    for (let enhancement = 1; enhancement <= 11; enhancement++) {
        const s = state(0, [], 9, enhancement); s.player[primaryState] = 123; s.player.initialMaxHealth = 250;
        assert(run('PLAYER AUGMENT INITIALIZATION', s).done()); assert.equal(s.huds, 1);
        assert.equal(s.player[primaryState], 123);
        assert.deepEqual(s.player[backpack], []);
    }
    for (const missing of [false, true]) {
        const s = state(); s.randomRoll = 9; s.player.initialMaxHealth = 250;
        if (missing) delete s.player.augmentId; else s.player.augmentId = 0;
        assert(run('PLAYER AUGMENT INITIALIZATION', s).done());
        assert.equal(s.player.augmentId, 9); assert.deepEqual(s.randomCalls, [[1, 10]]);
        s.randomRoll = 1; assert(run('PLAYER AUGMENT INITIALIZATION', s).done());
        assert.equal(s.player.augmentId, 9); assert.equal(s.randomCalls.length, 1);
    }
    const menu = 'PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)';
    for (let id = 0; id <= 10; id++) for (const reverse of [false, true]) {
        const s = state(0, [], id); s.globals.isPregameSetup = true;
        if (reverse) s.buttons.add('Secondary Fire');
        run(menu, s); assert.equal(s.player.augmentId, (id + (reverse ? 10 : 1)) % 11);
    }
    const declarations = actions(compiled.get('Initialize global variables'));
    for (const [name, size] of [['enhancementIconListConst', 12], ['augmentIconListConst', 11]]) {
        const line = declarations.find(l => l.startsWith('Set Global Variable(' + name + ','));
        assert(line); assert.equal(args(args(line)[1]).length, size);
    }
    // Inspect compiled HUD and scratch contracts in the two synchronous transactions.
    const init = compiled.get('PLAYER AUGMENT INITIALIZATION').body;
    assert(init.includes('Backpack: {0}/2'));
    assert(!compiled.get('PLAYER ENHANCEMENT INITIALIZATION').body.includes('Backpack:'));
    const useBody = compiled.get('powerUpUsage').body;
    assert(!useBody.includes(backpack), 'Reserve storage must never be a source for powerUpUsage');
    assert(!actions(compiled.get('dropCarriedPowerUps')).some(line => /^Wait/.test(line)));
    const raw = [...build.result.matchAll(/^rule \("(?:SCAVENGER BOT LOOT|dropCarriedPowerUps|PLAYER INTERACT [^"]*)"\) \{\n[\s\S]*?^\}/gm)].map(m => m[0]);
    // The only calls in these rules occur after the last scratch read.
    checkWorkshop(raw.join('\n'));
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings.length,
        checked: 'plain Interact active trade/crouch stash/empty active/full backpack rejection/mutually exclusive barricade/all 11 primary combinations/actual Cure use/locked reserve/ordinary players/duplicate IDs/hold/cancel/death/drop positions/elimination event/5% boundary/all 13 types/auto-stash/full fallback/consecutive wins/Scavenger no healing/scratch'}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
