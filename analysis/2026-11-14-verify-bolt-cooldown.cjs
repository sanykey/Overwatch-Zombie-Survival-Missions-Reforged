const assert = require('node:assert/strict');
const fs = require('node:fs');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const ready = slot('botBoltDamageReadyAt'), energy = slot('enhancementBoltEnergy');
const burst = slot('enhancementBoltBurst');
const enemy = id => ({id, team: 2, position: [0, 0, 4], alive: true,
    visible: true, health: 10000, hero: 'Ana'});
const setup = () => {
    const targets = ['a', 'b', 'c'].map(enemy);
    const s = scenario(4, {eventAbility: 'Primary Fire', eventDamage: 60,
        victim: targets[0], targets});
    Object.assign(s.player, {team: 1, enhancementId: 12, [energy]: 0, [burst]: 0});
    s.attacker = s.player; s.expectedDamager = s.player; s.allowArrayDamage = true;
    return s;
};
(async () => {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const map = new Map(rules(build.result).map(r => [r.name, r]));
    const hit = (s, time, victim = s.targets[0]) => {
        s.time = time; s.victim = victim;
        assert(start(map.get('PLAYER DEALT DAMAGE'), s, map).done());
    };
    let checks = 0;
    // A three-victim splash produces three chains total, not six. Rejected
    // events never move the deadline and still grant their primary-hit credit.
    for (const delay of [0, 0.001, 0.008, 0.015]) {
        const s = setup();
        for (let i = 0; i < 3; i++) hit(s, 100 + i * delay, s.targets[i]);
        assert.equal(s.damage.length, 3);
        assert(s.targets.every(t => t.health === 9985));
        assert.equal(s.player[energy], 9);
        assert.equal(s.targets[1][ready], 100.032);
        checks++;
    }
    // Exact boundary, no sliding deadline, independent targets.
    const boundary = setup();
    hit(boundary, 100); hit(boundary, 100.031);
    assert.equal(boundary.damage.length, 2);
    hit(boundary, 100.032);
    assert.equal(boundary.damage.length, 4);
    checks++;
    // Rapid fire stays effective even when each shot has simultaneous events.
    const rapid = setup();
    for (let i = 0; i < 20; i++) {
        hit(rapid, 100 + i * 0.05); hit(rapid, 100 + i * 0.05);
    }
    assert.equal(rapid.damage.length, 40);
    assert.equal(rapid.targets[1].health, 9700);
    assert.equal(rapid.effects.length, 4);
    checks++;
    // Like the flash limiter, the deadline belongs to the zombie, not attacker.
    const shared = setup(); hit(shared, 100);
    const second = setup(); second.targets = shared.targets; hit(second, 100.008);
    assert.equal(second.damage.length, 0);
    assert.equal(second.player[energy], 3);
    hit(second, 100.05); assert.equal(second.damage.length, 2);
    checks++;
    // The armed discharge must still fire once even when chains are blocked.
    const armed = setup(); hit(armed, 100); armed.player[burst] = -1;
    hit(armed, 100.008);
    assert.equal(armed.damage.length, 3);
    assert.equal(armed.damage.at(-1).amount, 60);
    assert.equal(armed.damage.at(-1).targets.length, 3);
    assert.equal(armed.statusWrites.length, 3);
    assert.equal(armed.player[burst], 0);
    hit(armed, 100.016); assert.equal(armed.damage.length, 3);
    checks++;
    const baseline = JSON.parse(fs.readFileSync('analysis/2026-11-14-bolt-cooldown-baseline.json', 'utf8'));
    const hashes = rules(build.result).filter(r => r.name !== 'applyHitEnhancements')
        .map(r => [r.name, crypto.createHash('sha256').update(JSON.stringify(r)).digest('hex')]);
    assert.deepEqual(hashes, baseline.ruleHashes, 'Unrelated rules stay identical');
    assert(!/Wait\(|Wait Until|Start Rule|Chase/.test(map.get('applyHitEnhancements').body));
    const names = result => result.match(/variables\s*\{[\s\S]*?\}/)[0];
    assert.equal(names(build.result), baseline.variables, 'No new variable slots');
    checks++;
    if (process.argv.includes('--export')) fs.writeFileSync('main.ws.txt', build.result);
    const report = {checks, before: baseline.elements, elements: build.elements,
        delta: build.elements - baseline.elements, warnings: build.warnings};
    fs.writeFileSync('analysis/2026-11-14-bolt-cooldown-validation.json', JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
