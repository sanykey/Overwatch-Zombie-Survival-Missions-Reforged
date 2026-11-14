// One-shot application: verifies the original build and all candidates before writing.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler, replace, src} = require('./measure-further-optimizations.cjs');
const {variants} = require('./2026-11-14-wrestler-optimization-probe.cjs');

function ruleBodies(result) {
    return [...result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name,
        hash: crypto.createHash('sha256').update(body.split('\n').filter(l => !/^\s*(?:"|\/\/)/.test(l))
            .map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n')).digest('hex')}));
}

(async () => {
    await compiler.readyPromise;
    let inputCases = 0;
    for (let augment = 0; augment <= 10; augment++) for (const crouch of [false,true])
        for (const deadline of [-2,-1,0,0.25,5]) for (const held of [false,true]) {
            // Apothecary=8, Laser Barricade=7; the proof only requires distinct IDs.
            const a = 8, b = 7;
            const oldBase = (augment !== a || !crouch) && (augment !== b || (!crouch && deadline >= 0));
            const newBase = !(([a,b].includes(augment) && crouch) || (augment === b && deadline < 0));
            assert.equal(oldBase, newBase);
            assert.equal(held || oldBase, held || newBase);
            // Held is false on every path reaching the late powerup wait:
            // pickup is written only by this synchronous handler; success returns.
            if (!held) assert.equal(held || oldBase, newBase);
            inputCases++;
        }
    for (let mask = 0; mask < 1024; mask++) {
        const [game,exists,carrierAlive,carrierAttached,sameHero,alive,initializing,teleporting,attached,knocked] =
            Array.from({length:10}, (_,i) => !!(mask & 1 << i));
        const interrupted = [!game,!exists,!carrierAlive,carrierAttached,!sameHero,!alive,initializing,teleporting,!attached,!knocked].some(Boolean);
        const valid = [game,exists,carrierAlive,!carrierAttached,sameHero,alive,!initializing,!teleporting,attached,knocked].every(Boolean);
        assert.equal(!interrupted, valid);
    }
    const before = await compile(files);
    assert.equal(before.elements, 30092, 'Original build changed; remeasure before applying');
    const candidate = {...files};
    for (const name of ['positiveCarryPredicate','simplerLateInputGuard','factoredAllInputPredicates']) variants[name](candidate);
    const reserved = '((eventPlayer.augmentId in [Augment.APOTHECARY, Augment.LASER_BARRICADE] and eventPlayer.isHoldingButton(Button.CROUCH)) or (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown < 0))';
    replace(candidate, 'supply_drops.opy', '(not ' + reserved + ')', 'not INTERACT_AUGMENT_INPUT_RESERVED');
    // The first replacement is in the macro; the second is the late check.
    replace(candidate, 'supply_drops.opy', '(not ' + reserved + ')', 'not INTERACT_AUGMENT_INPUT_RESERVED');
    replace(candidate, 'supply_drops.opy', '#!define INTERACT_AUGMENT_INPUT_ALLOWED', '#!define INTERACT_AUGMENT_INPUT_RESERVED ' + reserved + '\n#!define INTERACT_AUGMENT_INPUT_ALLOWED');
    replace(candidate, 'supply_drops.opy', '        # Recheck to prevent activation after game end or a reserved input change.\n',
        '        # Recheck to prevent activation after game end or a reserved input change.\n        # Pickup/throw success returns above; this handler is the only pickup caller,\n        # so no carried zombie can appear during this powerup wait.\n');
    replace(candidate, 'enhancements.opy', '#!define livingProjectileValid(carrier)',
        '# All entries are booleans/default zero; negate this predicate for interruptions.\n# Keeping positive checks avoids repeated Not values in the compiled array.\n#!define livingProjectileValid(carrier)');
    const after = await compile(candidate);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(after.elements, 30069);
    const oldRules = ruleBodies(before.result), newRules = ruleBodies(after.result);
    assert.equal(oldRules.length, newRules.length);
    const changed = oldRules.filter((r,i) => {
        assert.equal(r.name, newRules[i].name);
        return r.hash !== newRules[i].hash;
    }).map(r => r.name);
    assert.deepEqual(changed, ['PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)', 'LIVING PROJECTILE RELEASE']);
    const changedFiles = Object.keys(files).filter(name => files[name] !== candidate[name]);
    assert.deepEqual(changedFiles.sort(), ['enhancements.opy','supply_drops.opy']);
    // Only mutate after the full build, rule-scope and equivalence checks pass.
    for (const name of changedFiles) fs.writeFileSync(path.join(src, name), candidate[name].replace(/\n/g, '\r\n'));
    fs.writeFileSync(path.join(src, '..', 'main.ws.txt'), after.result);
    const report = {before: before.elements, after: after.elements, saved: before.elements-after.elements,
        compiler:'OverPy 9.7.21', warnings:after.warnings, changedRules:changed,
        unchangedRules:oldRules.length-changed.length, inputCases, carryBooleanCases:1024,
        newVariables:0, newSubroutines:0,
        limitations:'Compiled equivalence scope and boolean models; no in-game validation or runtime profiling. main.ws.txt also catches up with previously stale source changes.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-wrestler-safe-optimization.json'), JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(error => {console.error(error);process.exitCode=1;});
