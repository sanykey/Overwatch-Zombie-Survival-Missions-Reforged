const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

(async () => {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    // Compile a caller through the production macro to exercise its complete
    // expansion independently of movement physics and weapon timing.
    const probe = await compile({...files, 'player_events.opy': files['player_events.opy'] +
        '\nrule "ON HIT MACRO PROBE":\n    @Event eachPlayer\n    damageWithEnhancements(35, eventPlayer.augmentGrapnelTarget)\n'});
    assert.deepEqual(probe.warnings, []);
    const probeRules = new Map(rules(probe.result).map(r => [r.name, r]));
    const chargeSlot = slot('enhancementCapacitorCharge');
    const deadlineSlot = slot('enhancementCapacitorDeadline');
    const energySlot = slot('enhancementCapacitorEnergy');
    const targetSlot = slot('augmentGrapnelTarget');
    let checks = 0;
    const make = (enhancement, charge, deadline) => {
        const target = {id: 'zombie', team: 2, position: [0, 0, 4], health: 1000, alive: true, visible: true};
        const s = scenario(4, {targets: [target], victim: target});
        Object.assign(s.player, {enhancementId: enhancement, [chargeSlot]: charge,
            [deadlineSlot]: deadline, [energySlot]: 500, [targetSlot]: target});
        return s;
    };
    for (const enhancement of [0, 3, 9]) for (const charge of [0, 75])
    for (const deadline of [0, 99, 100.3, 100]) for (const invincible of [false, true]) {
        const s = make(enhancement, charge, deadline);
        s.victim.invincible = invincible;
        Object.assign(s.globals, {tmp0: 'preserve list', tmp1: 'preserve damage'});
        start(probeRules.get('ON HIT MACRO PROBE'), s, probeRules);
        const bonus = enhancement === 9 && charge > 0 && !invincible && (deadline === 0 || s.time < deadline);
        assert.deepEqual(s.damage.map(h => h.amount), bonus ? [35, charge] : [35]);
        assert.equal(s.player[deadlineSlot], bonus && deadline === 0 ? 100.3 : deadline);
        assert.equal(s.player[chargeSlot], charge);
        // Other enhancements reuse this player slot (Pyrotechnic's hit list).
        if (enhancement === 9) assert.equal(s.player[energySlot], 500);
        assert.equal(s.globals.tmp0, 'preserve list');
        assert.equal(s.globals.tmp1, 'preserve damage');
        assert.equal(s.statusWrites.filter(w => w.status === 'Burning').length, enhancement === 3 && !invincible ? 1 : 0);
        checks++;
    }
    for (const ability of [0, 'Primary Fire', 'Ability 1', 'Ultimate'])
    for (const amount of [0, 35]) for (const self of [false, true])
    for (const deadline of [0, 100, 100.3]) {
        const s = make(9, 75, deadline);
        s.eventAbility = ability; s.eventDamage = amount;
        if (self) s.victim = s.player;
        const nativeRule = compiled.get('PLAYER DEALT DAMAGE');
        s.attacker = s.player;
        if (applies(nativeRule, s)) start(nativeRule, s, compiled);
        const bonus = ability !== 0 && amount > 0 && !self && (deadline === 0 || s.time < deadline);
        assert.deepEqual(s.damage.map(h => h.amount), bonus ? [75] : []);
        assert.equal(s.player[deadlineSlot], bonus && deadline === 0 ? 100.3 : deadline);
        checks++;
    }
    const burst = make(9, 75, 0);
    for (const time of [100, 100.15, 100.3]) {
        burst.time = time;
        start(probeRules.get('ON HIT MACRO PROBE'), burst, probeRules);
    }
    assert.deepEqual(burst.damage.map(h => h.amount), [35, 75, 35, 75, 35]);
    assert.equal(burst.player[deadlineSlot], 100.3);
    checks++;
    const melee = make(9, 75, 0);
    Object.assign(melee.globals, {tmp0: 2.5, tmp1: 40});
    start(compiled.get('extendAugmentMelee'), melee, compiled);
    assert.deepEqual(melee.damage.map(h => h.amount), [40, 75]);
    assert(compiled.get('GRAPNEL LAUNCHER').body.includes('Call Subroutine(applyOvercharge);'));
    checks++;
    if (process.argv.includes('--export')) fs.writeFileSync('main.ws.txt', build.result);
    console.log(JSON.stringify({checks, elements: build.elements, warnings: build.warnings,
        exported: process.argv.includes('--export')}, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
