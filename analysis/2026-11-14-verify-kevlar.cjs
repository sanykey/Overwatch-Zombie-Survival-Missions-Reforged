// Compile the Kevlar change and compare every unrelated emitted rule.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

(async () => {
    await compiler.readyPromise;
    const baseline = {...files};
    baseline['augments.opy'] = baseline['augments.opy']
        .replace('#!define AUGMENT_KEVLAR_KNOCKBACK_RESIST 50\n', '')
        .replace('%. {AUGMENT_KEVLAR_KNOCKBACK_RESIST}% knockback resistance', '%');
    baseline['player_initialization.opy'] = baseline['player_initialization.opy']
        .replace('            eventPlayer.setKnockbackReceived(100 - AUGMENT_KEVLAR_KNOCKBACK_RESIST)\n', '');
    const before = await compile(baseline);
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result);
    const newRules = rules(after.result);
    assert.equal(newRules.length, oldRules.length);
    const changed = newRules.filter((rule, i) => rule.body !== oldRules[i].body);
    assert.deepEqual(changed.map(r => r.name).sort(), [
        'AUGMENT MENU', 'PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION'
    ]);
    const init = changed.find(r => r.name === 'PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION').body;
    assert.match(init, /If\(Compare\(\(Event Player\)\.augmentId, ==, 1\)\);\nSet Knockback Received\(Event Player, 50\);\nAdd Health Pool To Player/);
    // Dash activation, expiry and death cleanup must remain byte-for-byte
    // equivalent in the compiled rules (covered by the comparison above).
    const fade = newRules.find(r => r.name === '[DASH] SMOKE FADE').body;
    assert.match(fade, /\(Event Player\)\.augmentId == 2/);
    assert.match(fade, /Set Knockback Received\(Event Player, 100\)/);
    const declarations = text => text.slice(0, text.indexOf('rule (')).replace(/\/\*[\s\S]*?\*\//g, '');
    assert.equal(declarations(before.result), declarations(after.result));
    fs.writeFileSync(path.join(__dirname, '../main.ws.txt'), after.result);
    const report = {
        beforeElements: before.elements, afterElements: after.elements,
        elementDelta: after.elements - before.elements,
        changedRules: changed.map(r => r.name),
        unchangedRules: newRules.length - changed.length,
        warnings: after.warnings,
        limitation: 'Compiled output checked; no in-game run. Native knockback only; scripted Apply Impulse is unchanged.'
    };
    fs.writeFileSync(path.join(__dirname, '2026-11-14-kevlar-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
