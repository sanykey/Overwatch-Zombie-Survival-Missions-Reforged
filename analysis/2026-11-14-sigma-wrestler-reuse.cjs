// Read-only probe: compile shared attachment/impulse helpers without editing src.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');

function sharedAttach(f) {
    replace(f, 'zombie_types.opy',
        '    eventPlayer.botAbilityTarget.attachTo(eventPlayer, vect(0, 3 if eventPlayer in bossStateList else 0, 1))',
        '    tmp0 = eventPlayer.botAbilityTarget\n    tmp1 = eventPlayer\n    tmp2 = vect(0, 3 if eventPlayer in bossStateList else 0, 1)\n    attachGrabbedTarget()');
    replace(f, 'enhancements.opy',
        '    livingProjectileCandidate.attachTo(eventPlayer, vect(0, 1.5, 1))',
        '    tmp1 = eventPlayer\n    tmp2 = vect(0, 1.5, 1)\n    attachGrabbedTarget()');
    f['variables.opy'] += '\nsubroutine attachGrabbedTarget\n';
    f['enhancements.opy'] += '\n\ndef attachGrabbedTarget():\n    @Name "attachGrabbedTarget"\n    tmp0.attachTo(tmp1, tmp2)\n';
}

function sharedImpulse(f) {
    replace(f, 'zombie_types.opy',
        '        eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)',
        '        tmp0 = eventPlayer.botAbilityTarget\n        tmp1 = directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)), 25)\n        tmp2 = 50\n        throwGrabbedTarget()');
    replace(f, 'enhancements.opy',
        '        eventPlayer.applyImpulse(wrestlerCarrier.getFacingDirection(), WRESTLER_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)\n        eventPlayer.wrestlerThrowDamageCredit = wrestlerCarrier',
        '        eventPlayer.wrestlerThrowDamageCredit = wrestlerCarrier\n        tmp1 = wrestlerCarrier.getFacingDirection()\n        tmp0 = eventPlayer\n        tmp2 = WRESTLER_THROW_SPEED\n        throwGrabbedTarget()');
    f['variables.opy'] += '\nsubroutine throwGrabbedTarget\n';
    f['enhancements.opy'] += '\n\ndef throwGrabbedTarget():\n    @Name "throwGrabbedTarget"\n    tmp0.applyImpulse(tmp1, tmp2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)\n';
}

function counts(result) {
    return Object.fromEntries([...result.matchAll(/^\/\/(\d+) elements\nrule \("([^"\n]+)"\)/gm)].map(([,n,name]) => [name, +n]));
}

(async () => {
    await compiler.readyPromise;
    const before = await compile(files);
    assert.deepEqual(before.warnings, []);
    const variants = [];
    for (const [name, transforms] of [ ['shared-attachment', [sharedAttach]], ['shared-throw-impulse', [sharedImpulse]], ['both', [sharedAttach, sharedImpulse]] ]) {
        const candidate = {...files};
        transforms.forEach(fn => fn(candidate));
        const after = await compile(candidate);
        assert.deepEqual(after.warnings, []);
        variants.push({name, elements: after.elements, delta: after.elements - before.elements});
    }
    const rules = counts(before.result);
    const report = {
        compiler: 'OverPy 9.7.21', baselineElements: before.elements,
        wrestlerPickupElements: rules.useLivingProjectile,
        wrestlerReleaseElements: rules['LIVING PROJECTILE RELEASE'],
        sigmaGrabElements: rules['DOWNFALLEN GRABS PLAYER'], variants,
        warnings: before.warnings,
        limitations: 'Static compilation only; no in-game validation or runtime profiling. Helpers preserve distinct attachment offsets and throw impulses; a unified lifecycle was not implemented because the two abilities have different behavior.'
    };
    fs.writeFileSync(path.join(__dirname, '2026-11-14-sigma-wrestler-reuse.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
