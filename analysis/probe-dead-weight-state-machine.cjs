// Compare state-machine candidates in memory; never writes project sources/export.
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
// Reconstruct the preceding wait-based version after the event-driven version
// has been installed, so all measured candidates remain reproducible.
function waitRelease(s) {
    if (s.includes('waitUntil(eventPlayer.augmentZombieCarrier.augmentHoldUntil')) return s;
    s = s.replace('    @Condition (eventPlayer.augmentZombieCarrier.augmentHoldUntil <= getTotalTimeElapsed() or livingProjectileInterrupted(eventPlayer.augmentZombieCarrier)) == true\n', '');
    return s.replace('    # Synchronous carrier snapshot',
        '    waitUntil(eventPlayer.augmentZombieCarrier.augmentHoldUntil == 0 or livingProjectileInterrupted(eventPlayer.augmentZombieCarrier), max(0.016, eventPlayer.augmentZombieCarrier.augmentHoldUntil - getTotalTimeElapsed()))\n    # Synchronous carrier snapshot');
}
const baseline = waitRelease(files['augments.opy']);
function conditionRelease(s) {
    const declaration = s.match(/(?:    )?#!define livingProjectileInterrupted\(carrier\) .*\n/)[0];
    s = s.replace(declaration, '');
    const rule = 'rule "LIVING PROJECTILE RELEASE":';
    s = s.replace(rule, declaration.trimStart() + '\n' + rule);
    const wait = s.match(/    waitUntil\(eventPlayer.augmentZombieCarrier.augmentHoldUntil.*\n/)[0];
    s = s.replace(wait, '');
    s = s.replace('    @Condition eventPlayer.augmentZombieCarrier != null\n',
        '    @Condition eventPlayer.augmentZombieCarrier != null\n' +
        '    @Condition (eventPlayer.augmentZombieCarrier.augmentHoldUntil <= getTotalTimeElapsed() or livingProjectileInterrupted(eventPlayer.augmentZombieCarrier)) == true\n');
    return s;
}
function explicitState(s) {
    s = conditionRelease(s);
    // One retained owner, with state 1 = held and state 2 = flying. Owner null = idle.
    s = s.replace('livingProjectileCandidate.augmentZombieThrower != null', 'livingProjectileCandidate.augmentZombieCarrier != null');
    s = s.replace('livingProjectileCandidate.augmentZombieCarrier = eventPlayer\n',
        'livingProjectileCandidate.augmentZombieCarrier = eventPlayer\n    livingProjectileCandidate.augmentZombieState = 1\n');
    s = s.replace('    @Condition eventPlayer.augmentZombieCarrier != null\n',
        '    @Condition eventPlayer.augmentZombieCarrier != null\n    @Condition eventPlayer.augmentZombieState == 1\n');
    s = s.replace('        eventPlayer.augmentZombieThrower = deadWeightCarrier\n', '        eventPlayer.augmentZombieState = 2\n');
    const impulse = '        eventPlayer.applyImpulse(deadWeightCarrier.getFacingDirection(), AUGMENT_CARRY_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)\n';
    s = s.replace(impulse, impulse + '    else:\n        eventPlayer.augmentZombieCarrier = null\n');
    s = s.replace('    deadWeightCarrier.augmentHeldZombie = null\n    eventPlayer.augmentZombieCarrier = null\n', '    deadWeightCarrier.augmentHeldZombie = null\n');
    s = s.replace('    @Condition eventPlayer.augmentZombieThrower != null',
        '    @Condition eventPlayer.augmentZombieCarrier != null\n    @Condition eventPlayer.augmentZombieState == 2');
    s = s.replaceAll('eventPlayer.augmentZombieThrower', 'eventPlayer.augmentZombieCarrier');
    return s;
}
function inferredState(s) {
    s = explicitState(s);
    s = s.replace('    livingProjectileCandidate.augmentZombieState = 1\n', '');
    s = s.replace('    @Condition eventPlayer.augmentZombieCarrier != null\n    @Condition eventPlayer.augmentZombieState == 1',
        '    @Condition eventPlayer.augmentZombieCarrier.augmentHeldZombie == eventPlayer');
    s = s.replace('        eventPlayer.augmentZombieState = 2\n', '');
    s = s.replace('    @Condition eventPlayer.augmentZombieState == 2',
        '    @Condition eventPlayer.augmentZombieCarrier.augmentHeldZombie != eventPlayer');
    return s;
}
async function main() {
    if (!files['augments.opy'].includes('rule "DEAD WEIGHT LANDING"')) {
        process.stdout.write('Historical landing/cooldown study: see dead-weight-optimization.json. The current ability damages on throw and has no landing state.\n');
        return;
    }
    await compiler.readyPromise;
    for (const [name, change] of Object.entries({baseline: s=>s, conditionRelease, explicitState, inferredState})) {
        const candidate = {...files, 'augments.opy': change(baseline),
            'variables.opy': files['variables.opy'] + '\n#!define augmentZombieState augmentState1\n'};
        const r = await compile(candidate);
        process.stdout.write(JSON.stringify({name,elements:r.elements,warnings:r.warnings})+'\n');
    }
}
module.exports = {conditionRelease, explicitState, inferredState};
if (require.main === module) main().catch(e=>{console.error(e);process.exitCode=1;});
