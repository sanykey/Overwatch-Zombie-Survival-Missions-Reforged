const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const energy = slot('enhancementBoltEnergy'), burst = slot('enhancementBoltBurst');
const flash = slot('botBoltFlashReadyAt'), smolder = slot('botSmolderState');
const anchor = slot('augmentGrapnelTarget');
const enemy = (id, x = 0, extra = {}) => ({id, team: 2, position: [x, 0, 4],
    alive: true, visible: true, health: 1000, hero: 'Ana', ...extra});
const setup = (amount, armed, count, immune) => {
    const primary = enemy('primary', 0, {invincible: immune});
    const s = scenario(4, {eventAbility: 'Primary Fire', eventDamage: amount,
        victim: primary, targets: [primary, ...Array.from({length: count}, (_, i) => enemy('chain' + i, i + 1))]});
    Object.assign(s.player, {enhancementId: 12, team: 1, [energy]: 0,
        [burst]: armed ? -1 : 0, [anchor]: primary});
    Object.assign(s.globals, {tmp0: 'outer targets', tmp1: 'outer damage'});
    s.allowArrayDamage = true; s.expectedDamager = s.player;
    s.attacker = s.player;
    return s;
};
const run = (map, name, s) => {assert(start(map.get(name), s, map).done());};
const summary = s => ({energy: s.player[energy], burst: s.player[burst],
    damage: s.damage.map(h => [h.amount, h.targets.map(t => t.id)]),
    health: s.targets.map(t => [t.id, t.health, t[flash]]), effects: s.effects, status: s.statusWrites});

(async () => {
    await compiler.readyPromise;
    const build = await compile(files); assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    assert(!/Wait\(|Wait Until|Start Rule|Chase/.test(compiled.get('applyBoltStrike').body));
    const probe = await compile({...files, 'player_events.opy': files['player_events.opy'] +
        '\nrule "BOLT MACRO PROBE":\n    @Event eachPlayer\n    damageWithEnhancements(eventPlayer.getHealth(), eventPlayer.augmentGrapnelTarget)\n'});
    assert.deepEqual(probe.warnings, []);
    const probeRules = new Map(rules(probe.result).map(r => [r.name, r]));
    const beforeArg = process.argv.indexOf('--before');
    const before = beforeArg >= 0 ? JSON.parse(fs.readFileSync(process.argv[beforeArg + 1], 'utf8')) : null;
    const old = before && new Map(rules(before.result).map(r => [r.name, r]));
    let checks = 0;
    for (const amount of [1, 40, 60, 100]) for (const armed of [false, true])
    for (const count of [0, 1, 3]) for (const immune of [false, true]) {
        const s = setup(amount, armed, count, immune); s.player.health = amount;
        run(probeRules, 'BOLT MACRO PROBE', s);
        const chainCount = immune ? 0 : Math.min(2, count);
        const chainDamage = Math.min(15, amount * 0.25);
        assert.deepEqual(s.damage.map(h => h.amount), [amount,
            ...Array(chainCount).fill(chainDamage), ...(armed && !immune ? [60] : [])]);
        assert.equal(s.player[energy], immune ? 0 : 0.3 + chainCount * chainDamage);
        assert.equal(s.player[burst], armed && immune ? -1 : 0);
        assert.equal(s.statusWrites.length, armed && !immune ? count + 1 : 0);
        assert(s.statusWrites.every(w => w.status === 'Stunned' && w.duration === 2));
        assert.equal(s.globals.tmp0, 'outer targets'); assert.equal(s.globals.tmp1, 'outer damage');
        // Native handling must preserve all gameplay results from before extraction.
        const native = setup(amount, armed, count, immune);
        run(compiled, 'PLAYER DEALT DAMAGE', native);
        if (old) {
            const baseline = setup(amount, armed, count, immune);
            run(old, 'PLAYER DEALT DAMAGE', baseline);
            assert.deepEqual(summary(native), summary(baseline));
        }
        checks++;
    }
    const reduced = setup(100, false, 2, false); reduced.player.health = 100;
    reduced.victim.damageMultiplier = 0.2;
    reduced.targets[1].damageMultiplier = 0.25; reduced.targets[2].health = 3;
    run(probeRules, 'BOLT MACRO PROBE', reduced);
    assert.deepEqual(reduced.damage.map(h => h.amount), [100, 5, 5]);
    assert.equal(reduced.player[energy], 0.3 + 1.25 + 3); checks++;
    const overkill = setup(100, false, 2, false); overkill.player.health = 100;
    overkill.victim.health = 10;
    run(probeRules, 'BOLT MACRO PROBE', overkill);
    assert.deepEqual(overkill.damage.map(h => h.amount), [100, 2.5, 2.5]); checks++;
    const capped = setup(100, false, 2, false); capped.player.health = 100;
    capped.player[energy] = 349; capped.targets[1].invincible = true;
    run(probeRules, 'BOLT MACRO PROBE', capped);
    assert.equal(capped.player[energy], 350); checks++;
    const rapid = setup(100, false, 2, false); rapid.player.health = 100;
    for (const time of [100, 100.1, 100.499, 100.5]) {
        rapid.time = time; run(probeRules, 'BOLT MACRO PROBE', rapid);
    }
    assert.equal(rapid.effects.length, 4); assert.equal(rapid.damage.length, 12);
    assert(rapid.effects.every(e => e.size === 0.375)); checks++;
    const filtered = setup(40, true, 0, false); filtered.player.health = 40;
    filtered.targets.push(enemy('edge', 10), enemy('outside', 10.001), enemy('hidden', 2, {visible: false}),
        enemy('dead', 3, {alive: false}), enemy('ally', 4, {team: 1}),
        enemy('warning', 5, {hero: 'Winston', [smolder]: 1}), enemy('active', 6, {hero: 'Winston', [smolder]: 2}));
    run(probeRules, 'BOLT MACRO PROBE', filtered);
    assert.deepEqual(filtered.damage.at(-1).targets.map(t => t.id), ['primary', 'edge', 'active']); checks++;
    for (const reject of ['zero', 'friendly', 'other enhancement', 'ordinary script']) {
        const s = setup(40, true, 2, false); s.player.health = 40;
        if (reject === 'zero') s.player.health = 0;
        if (reject === 'friendly') s.victim.team = 1;
        if (reject === 'other enhancement') s.player.enhancementId = 0;
        if (reject === 'ordinary script') s.eventAbility = 0;
        run(reject === 'ordinary script' ? compiled : probeRules,
            reject === 'ordinary script' ? 'PLAYER DEALT DAMAGE' : 'BOLT MACRO PROBE', s);
        assert.equal(s.player[energy], 0); assert.equal(s.player[burst], -1); checks++;
    }
    const melee = setup(40, true, 2, false);
    Object.assign(melee.globals, {tmp0: 2.5, tmp1: 40});
    melee.targets[1].position = [0, 0, 5]; melee.targets[2].position = [0, 0, 6];
    run(compiled, 'extendAugmentMelee', melee);
    assert.equal(melee.damage.filter(h => h.amount === 40).length, 3, 'All outer-loop targets survive chain scratch use');
    assert.equal(melee.damage.filter(h => h.amount === 60).length, 1, 'Discharge is consumed once per multi-target swing');
    assert.equal(melee.globals.tmp1, 40); checks++;
    // Native input assignment must not overwrite another enhancement's state
    // or scratch. actorTeamSlot25 also owns Overcharge statistics, Engineer
    // beam deadline, Battery placement cooldown and P.U.P. freeze-aura state.
    const sharedSlot = slot('enhancementCapacitorStatsSnapshot');
    for (const enhancement of [0, 1, 3, 5, 6, 7, 9, 10, 11, 13]) {
        const s = setup(40, false, 0, false);
        s.player.enhancementId = enhancement;
        s.player[sharedSlot] = 123;
        run(compiled, 'PLAYER DEALT DAMAGE', s);
        assert.equal(s.player[sharedSlot], 123, 'Native damage preserves other enhancement state');
        assert.equal(s.globals.tmp0, 'outer targets', 'Only native Bolt writes its input alias');
        checks++;
    }
    const nativeInput = setup(100, false, 2, false);
    run(compiled, 'PLAYER DEALT DAMAGE', nativeInput);
    assert.equal(nativeInput.globals.tmp0, 100);
    assert.equal(nativeInput.player[energy], 30.3);
    checks++;
    if (before) {
        const afterRules = rules(build.result).filter(r => r.name !== 'applyBoltStrike');
        const beforeRules = rules(before.result);
        assert.deepEqual(afterRules.map(r => r.name), beforeRules.map(r => r.name));
        const changed = beforeRules.filter((r, i) => afterRules[i].body !== r.body).map(r => r.name);
        assert.deepEqual(changed, ['GRAPNEL LAUNCHER', 'extendAugmentMelee', 'PLAYER DEALT DAMAGE']);
        assert.deepEqual([...compiled.keys()].filter(n => !old.has(n)), ['applyBoltStrike']);
    }
    if (process.argv.includes('--export')) fs.writeFileSync('main.ws.txt', build.result);
    console.log(JSON.stringify({checks, before: before?.elements, elements: build.elements,
        warnings: build.warnings, nativeCompared: !!old, exported: process.argv.includes('--export')}, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
