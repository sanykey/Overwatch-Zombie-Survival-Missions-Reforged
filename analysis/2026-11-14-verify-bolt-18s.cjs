const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const ready = slot('enhancementBoltReadyAt'), burst = slot('enhancementBoltBurst');
const armName = 'BOLT STRIKE AND OVERCHARGE ARM ON DOUBLE CROUCH';
const enemy = id => ({id, team: 2, position: [0, 0, 4], alive: true,
    visible: true, health: 10000, hero: 'Ana'});
const setup = () => {
    const targets = ['primary', 'chain1', 'chain2'].map(enemy);
    const s = scenario(4, {eventAbility: 'Primary Fire', eventDamage: 60,
        victim: targets[0], targets, buttons: new Set(['Crouch'])});
    Object.assign(s.player, {team: 1, enhancementId: 12, [ready]: 0, [burst]: 0});
    s.attacker = s.player; s.expectedDamager = s.player; s.allowArrayDamage = true;
    return s;
};
(async () => {
    await compiler.readyPromise;
    const build = await compile(files); assert.deepEqual(build.warnings, []);
    const parsed = rules(build.result), map = new Map(parsed.map(r => [r.name, r]));
    const baseline = JSON.parse(fs.readFileSync(path.join(__dirname, '2026-11-14-bolt-18s-before.json'), 'utf8'));
    const changed = parsed.filter((r, i) => baseline.rules[i]?.hash !==
        crypto.createHash('sha256').update(r.body).digest('hex')).map(r => r.name);
    assert.deepEqual(changed, ['EFFECTS/TEXTS', armName,
        'ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)', 'applyHitEnhancements']);
    assert.deepEqual(parsed.map(r => r.name), baseline.rules.map(r => r.name));
    ['settings', 'variables', 'subroutines'].forEach((section, i) => {
        assert.equal(build.result.match(new RegExp('^' + section + '\\s*\\{[\\s\\S]*?^\\}', 'm'))[0], baseline.sections[i]);
    });
    assert(!Object.values(files).join('\n').includes('enhancementBoltEnergy'));
    let cases = 0;
    const arm = map.get(armName), hit = map.get('PLAYER DEALT DAMAGE');
    const tap = (s, release = 0.1, press = 0.2, between = () => {}) => {
        const t = s.time, run = start(arm, s, map);
        s.time = t + release; s.buttons.clear(); run.resume();
        between(s);
        if (press - release > 0.3) {
            s.time = t + release + 0.300001; run.resume();
        }
        s.time = t + press; s.buttons.add('Crouch'); run.resume();
        return run;
    };
    for (const deadline of [0, 99, 100, 100.001, 118]) for (const armed of [0, -1]) {
        const s = setup(); s.player[ready] = deadline; s.player[burst] = armed;
        assert.equal(applies(arm, s), deadline <= 100 && armed === 0); cases++;
    }
    const initial = setup(); assert(tap(initial).done());
    assert.equal(initial.player[ready], 118.2); assert.equal(initial.player[burst], -1); cases++;
    const held = setup(), holdRun = start(arm, held, map);
    held.time = 100.31; holdRun.resume(); assert(holdRun.done());
    assert.equal(held.player[ready], 0); assert.equal(held.player[burst], 0); cases++;
    const slow = setup(); assert(tap(slow, 0.1, 0.41).done());
    assert.equal(slow.player[ready], 0); cases++;
    for (const change of [s => {s.alive = false;}, s => {s.globals.isGameplayActive = false;},
        s => {s.player.enhancementId = 1;}, s => {s.player[ready] = 150;}]) {
        const s = setup(); tap(s, 0.1, 0.2, change);
        assert.equal(s.player[burst], 0, 'Second press rechecks eligibility'); cases++;
    }
    for (const damage of [1, 20, 60, 2000]) for (const count of [0, 1, 2]) {
        const s = setup(); s.eventDamage = damage; s.targets = s.targets.slice(0, count + 1);
        s.player[ready] = 118;
        start(hit, s, map); assert.equal(s.player[ready], 118);
        assert.equal(s.damage.length, count);
        assert(s.damage.every(d => d.amount === Math.min(15, damage / 4)));
        s.eventAbility = 0; start(hit, s, map);
        assert.equal(s.damage.length, count); assert.equal(s.player[ready], 118); cases++;
    }
    // Arming without any damage succeeds; the first subsequent hit discharges once.
    const active = setup(); tap(active); const deadline = active.player[ready];
    start(hit, active, map); assert.equal(active.player[burst], 0);
    assert.equal(active.damage.at(-1).amount, 60); assert.equal(active.statusWrites.length, 3);
    assert.equal(active.player[ready], deadline);
    active.time += 0.05; start(hit, active, map);
    assert.equal(active.statusWrites.length, 3);
    active.time = deadline - 0.001; assert(!applies(arm, active));
    active.time = deadline; assert(applies(arm, active));
    assert(tap(active).done()); assert.equal(active.player[ready], deadline + 18.2); cases++;
    // The unchanged death rule cancels the burst without touching its deadline.
    const deathBody = map.get('PLAYER DIED').body.split('Else If')[0];
    assert(deathBody.includes('Set Player Variable(Event Player, ' + burst + ', Null);'));
    assert(!deathBody.includes(ready)); cases++;
    // The combined input rule retains Overcharge's bank transfer.
    const over = setup(); over.player.enhancementId = 9;
    const bank = slot('enhancementCapacitorEnergy'), charge = slot('enhancementCapacitorCharge');
    over.player[bank] = 150; over.player[charge] = 0; tap(over);
    assert.equal(over.player[bank], 50); assert.equal(over.player[charge], 100); cases++;
    const hud = map.get('ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)').body;
    assert(hud.includes('Round To Integer(Subtract((Local Player).' + ready));
    assert(!/Wait\(|Wait Until|Chase/.test(map.get('applyHitEnhancements').body));
    fs.writeFileSync(path.join(__dirname, '..', 'main.ws.txt'), build.result);
    const report = {cases, beforeElements: baseline.elements, afterElements: build.elements,
        deltaElements: build.elements - baseline.elements, warnings: build.warnings,
        changedRules: changed, addedVariables: 0, cooldownStarts: 'arming',
        nativeGameplayVerified: false};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-bolt-18s-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
