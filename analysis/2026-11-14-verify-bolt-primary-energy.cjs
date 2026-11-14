const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const energy = slot('enhancementBoltEnergy'), burst = slot('enhancementBoltBurst');
const enemy = id => ({id, team: 2, position: [0, 0, 4], alive: true,
    visible: true, health: 1000, hero: 'Ana'});
(async () => {
    await compiler.readyPromise;
    // Reconstruct the immediately preceding charging behavior in memory.
    const baseline = {...files};
    baseline['player_events.opy'] = baseline['player_events.opy'].replace(
        'min(100, eventPlayer.enhancementBoltEnergy + enhancementHitDamage / 20)',
        'min(350, eventPlayer.enhancementBoltEnergy + enhancementHitDamage * 0.25)');
    for (const name of ['enhancements.opy', 'player_initialization.opy'])
        baseline[name] = baseline[name].replaceAll('enhancementBoltEnergy >= 100', 'enhancementBoltEnergy >= 350')
            .replace('enhancementBoltEnergy)}/100', 'enhancementBoltEnergy)}/350');
    baseline['global_start_menu.opy'] = baseline['global_start_menu.opy'].replace(
        'Primary damage grants 1 energy per 20 dmg. At 100 energy,', 'At 350 energy,');
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []); assert.deepEqual(after.warnings, []);
    const parsed = rules(after.result), map = new Map(parsed.map(r => [r.name, r]));
    const changedRules = ['applyHitEnhancements', 'BOLT STRIKE AND OVERCHARGE ARM ON DOUBLE CROUCH',
        'ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)', 'EFFECTS/TEXTS'];
    assert.deepEqual(parsed.filter(r => !changedRules.includes(r.name)),
        rules(before.result).filter(r => !changedRules.includes(r.name)));
    for (const section of ['settings', 'variables', 'subroutines']) {
        const re = new RegExp('^' + section + '\\s*\\{[\\s\\S]*?^\\}', 'm');
        assert.equal(after.result.match(re)[0], before.result.match(re)[0]);
    }
    let cases = 0;
    for (const amount of [0, 1, 4, 20, 40, 60, 100, 1999, 2000, 2001, 3000])
    for (const secondary of [0, 1, 2])
    for (const mode of ['normal', 'immune', 'reduced', 'overkill', 'blocked']) {
        const victim = enemy('primary');
        const targets = [victim, ...Array.from({length: secondary}, (_, i) => enemy('chain' + i))];
        const s = scenario(4, {eventAbility: 'Primary Fire', eventDamage: amount, victim, targets});
        Object.assign(s.player, {team: 1, enhancementId: 12, [energy]: 0, [burst]: 0});
        s.attacker = s.player; s.expectedDamager = s.player; s.allowArrayDamage = true;
        for (const target of targets.slice(1)) {
            if (mode === 'immune') target.invincible = true;
            if (mode === 'reduced') target.damageMultiplier = 0.25;
            if (mode === 'overkill') target.health = 1;
            if (mode === 'blocked') target[slot('botBoltDamageReadyAt')] = 101;
        }
        // Zero damage is rejected by the native rule's condition.
        if (amount > 0) start(map.get('PLAYER DEALT DAMAGE'), s, map);
        assert.equal(s.player[energy], Math.min(100, amount / 20));
        assert.equal(s.damage.length, amount > 0 && mode !== 'blocked' ? secondary : 0);
        if (s.damage.length) assert(s.damage.every(d => d.amount === Math.min(15, amount / 4)));
        const bank = s.player[energy];
        // Direct chain/burst damage has no Event Ability and cannot charge again.
        s.eventAbility = 0; s.eventDamage = 60;
        start(map.get('PLAYER DEALT DAMAGE'), s, map);
        assert.equal(s.player[energy], bank);
        s.eventAbility = 'Primary Fire'; s.eventDamage = 20; s.player[burst] = -1;
        start(map.get('PLAYER DEALT DAMAGE'), s, map);
        assert.equal(s.player[energy], Math.min(100, bank + 1));
        assert.equal(s.player[burst], 0);
        assert.equal(s.damage.at(-1).amount, 60);
        cases++;
    }
    for (const bank of [0, 99, 99.999, 100]) {
        const s = scenario(4, {buttons: new Set(['Crouch'])});
        Object.assign(s.player, {enhancementId: 12, [energy]: bank, [burst]: 0});
        assert.equal(applies(map.get('BOLT STRIKE AND OVERCHARGE ARM ON DOUBLE CROUCH'), s), bank >= 100);
        cases++;
    }
    fs.writeFileSync(path.join(__dirname, '..', 'main.ws.txt'), after.result);
    const report = {cases, beforeElements: before.elements, afterElements: after.elements,
        deltaElements: after.elements - before.elements, warnings: after.warnings,
        changedRules, variableDeclarationsUnchanged: true,
        nativeGameplayVerified: false};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-bolt-primary-energy-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
