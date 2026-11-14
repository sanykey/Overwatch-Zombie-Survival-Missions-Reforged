const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, value} = require('./verify-augments.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const enemy = (id, extra = {}) => ({id, team: 2, position: [0, 0, 4], alive: true,
    visible: true, health: 10000, hero: 'Ana', ...extra});
const setup = (damage = 60, count = 2, mode = 'normal') => {
    const targets = [enemy('primary'), ...Array.from({length: count}, (_, i) => enemy('chain' + i))];
    for (const target of targets.slice(1)) {
        if (mode === 'dead') target.alive = false;
        if (mode === 'hidden') target.visible = false;
        if (mode === 'far') target.position = [0, 0, 14.001];
        if (mode === 'edge') target.position = [0, 0, 14];
        if (mode === 'warning') {target.hero = 'Winston'; target[slot('botSmolderState')] = 1;}
        if (mode === 'immune') target.invincible = true;
        if (mode === 'reduced') target.damageMultiplier = 0.25;
        if (mode === 'overkill') target.health = 1;
    }
    const s = scenario(4, {eventAbility: 'Primary Fire', eventDamage: damage,
        victim: targets[0], targets, buttons: new Set(['Crouch'])});
    Object.assign(s.player, {team: 1, enhancementId: 12});
    s.attacker = s.player; s.expectedDamager = s.player; s.allowArrayDamage = true;
    s.globals.tmp0 = ['outer loop']; s.globals.tmp1 = 123;
    return s;
};
const result = s => ({damage: s.damage.map(d => ({amount: d.amount, targets: d.targets.map(t => t.id)})),
    targets: s.targets, effects: s.effects, statuses: s.statusWrites});
(async () => {
    await compiler.readyPromise;
    const build = await compile(files); assert.deepEqual(build.warnings, []);
    const parsed = rules(build.result), map = new Map(parsed.map(r => [r.name, r]));
    const baseline = JSON.parse(fs.readFileSync(path.join(__dirname, '2026-11-14-bolt-chain-only-before.json'), 'utf8'));
    const oldArm = baseline.arm.name, armName = 'OVERCHARGE ARM ON DOUBLE CROUCH';
    const changed = parsed.filter((r, i) => baseline.rules[i]?.hash !==
        crypto.createHash('sha256').update(r.body).digest('hex')).map(r => r.name);
    assert.deepEqual(changed, ['EFFECTS/TEXTS', armName,
        'ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)',
        'PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION', 'applyHitEnhancements', 'PLAYER DIED']);
    assert.deepEqual(parsed.map(r => r.name), baseline.rules.map(r => r.name === oldArm ? armName : r.name));
    ['settings', 'variables', 'subroutines'].forEach((section, i) => {
        assert.equal(build.result.match(new RegExp('^' + section + '\\s*\\{[\\s\\S]*?^\\}', 'm'))[0], baseline.sections[i]);
    });
    assert(!/enhancementBolt|BOLT_STRIKE_(?:COOLDOWN|BURST_DAMAGE|STUN_DURATION)/.test(Object.values(files).join('\n')));
    const handler = map.get('applyHitEnhancements');
    const bolt = handler.body.slice(handler.body.indexOf('Compare((Event Player).enhancementId, ==, 12)'));
    assert(!/Set Status|Set Player Variable\(Event Player|Wait\(|Wait Until|Chase/.test(bolt));
    let cases = 0;
    // All retained chain behavior must match the preceding build exactly.
    const oldMap = new Map(map); oldMap.set('applyHitEnhancements', baseline.handler);
    const hit = map.get('PLAYER DEALT DAMAGE');
    for (const damage of [1, 4, 40, 60, 61, 100, 2000]) for (const count of [0, 1, 2, 3])
    for (const mode of ['normal', 'dead', 'hidden', 'far', 'edge', 'warning', 'immune', 'reduced', 'overkill']) {
        const previous = setup(damage, count, mode), current = setup(damage, count, mode);
        for (const time of [100, 100.008, 100.032, 100.05, 100.5]) {
            previous.time = current.time = time;
            start(hit, previous, oldMap); start(hit, current, map);
            assert.deepEqual(result(current), result(previous));
            assert.deepEqual(current.globals.tmp0, ['outer loop']); assert.equal(current.globals.tmp1, 123);
        }
        assert.equal(current.statusWrites.length, 0);
        assert(current.damage.every(d => d.amount === Math.min(15, damage / 4)));
        current.eventAbility = 0;
        const countBefore = current.damage.length; start(hit, current, map);
        assert.equal(current.damage.length, countBefore, 'Secondary scripted damage cannot recurse');
        assert(!applies(map.get(armName), current), 'Bolt has no crouch activation'); cases++;
    }
    // Keep Overcharge's double-crouch eligibility and spending unchanged.
    const energy = slot('enhancementCapacitorEnergy'), charge = slot('enhancementCapacitorCharge');
    for (const bank of [0, 1, 100, 150]) for (const armed of [0, 50]) for (const held of [false, true]) {
        const s = setup(); s.player.enhancementId = 9; s.player[energy] = bank; s.player[charge] = armed;
        s.buttons = new Set(held ? ['Crouch'] : []);
        assert.equal(applies(map.get(armName), s), applies(baseline.arm, s)); cases++;
    }
    for (const bank of [1, 100, 150]) {
        const s = setup(); s.player.enhancementId = 9; s.player[energy] = bank; s.player[charge] = 0;
        const gesture = start(map.get(armName), s, map);
        s.time = 100.1; s.buttons.clear(); gesture.resume();
        s.time = 100.2; s.buttons.add('Crouch'); gesture.resume();
        assert(gesture.done()); assert.equal(s.player[charge], Math.min(bank, 100));
        assert.equal(s.player[energy], Math.max(0, bank - 100)); cases++;
    }
    // Inspect emitted table entries rather than the obsolete per-player HUD layout.
    const entry = (expression, index) => {
        if (expression.startsWith('Custom String(')) expression = args(expression)[1];
        const table = args(expression)[0];
        if (table.startsWith('Array(')) return value(args(table)[index].replace(/Color\((\w+)\)/g, '"$1"'), setup());
        assert(table.startsWith('String Split('));
        const parts = args(table);
        return value(parts[0], setup()).split(String(value(parts[1], setup())))[index];
    };
    const hud = map.get('ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)').body;
    const hudArgs = args(hud.match(/Create HUD Text\((.*)\);/)[0]);
    assert.equal(entry(hudArgs[2], 12), 'Hits chain to nearby zombies');
    assert.equal(entry(hudArgs[8], 12), 'White'); cases++;
    const menu = parsed.filter(r => r.name === 'EFFECTS/TEXTS')
        .flatMap(r => [...r.body.matchAll(/Create HUD Text\((.*)\);/g)]).find(m => m[0].includes('Hits chain to'));
    let description = args(menu[0])[2];
    if (description.startsWith('Custom String(')) description = args(description)[1];
    assert.equal(entry(description, 12), 'Hits chain to 2 zombies within 10m for 25% dmg (max 15).'); cases++;
    fs.writeFileSync(path.join(__dirname, '..', 'main.ws.txt'), build.result);
    const report = {cases, beforeElements: baseline.elements, afterElements: build.elements,
        deltaElements: build.elements - baseline.elements, warnings: build.warnings,
        changedRules: changed, addedVariables: 0, removedBoltPlayerStateAliases: 3,
        retainedChainBehaviorComparedWithBaseline: true, nativeGameplayVerified: false};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-bolt-chain-only-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
