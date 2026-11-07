// Current delayed-damage variants compiled in memory; no source/export writes.
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
function livingRoster(s) {
    return s.replace('not entityExists(carrier), not carrier.isAlive()', 'carrier not in getLivingPlayers(Team.1)');
}
function snapshotThrow(s, restoreBaseline = false) {
    const old = `    eventPlayer.detach()
    if deadWeightCarrier.augmentHoldUntil == 0 and not livingProjectileInterrupted(deadWeightCarrier):
        eventPlayer.applyImpulse(deadWeightCarrier.getFacingDirection(), AUGMENT_CARRY_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.augmentThrowDamageCredit = deadWeightCarrier
    eventPlayer.botIsAttached = false
    deadWeightCarrier.augmentHeldZombie = null
    eventPlayer.augmentZombieCarrier = null

    if eventPlayer.augmentThrowDamageCredit != null:
        wait(AUGMENT_CARRY_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.augmentThrowDamageCredit, AUGMENT_CARRY_THROW_DAMAGE)
        eventPlayer.augmentThrowDamageCredit = null`;
    const next = `    #!define deadWeightShouldThrow tmp1
    deadWeightShouldThrow = deadWeightCarrier.augmentHoldUntil == 0 and not livingProjectileInterrupted(deadWeightCarrier)
    eventPlayer.detach()
    eventPlayer.botIsAttached = false
    deadWeightCarrier.augmentHeldZombie = null
    eventPlayer.augmentZombieCarrier = null
    if deadWeightShouldThrow:
        eventPlayer.applyImpulse(deadWeightCarrier.getFacingDirection(), AUGMENT_CARRY_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.augmentThrowDamageCredit = deadWeightCarrier
        wait(AUGMENT_CARRY_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.augmentThrowDamageCredit, AUGMENT_CARRY_THROW_DAMAGE)`;
    if(restoreBaseline) {
        s=s.replace('    # Boolean snapshot, consumed by the branch before its damage wait.\n    # No later action reads this scratch slot after yielding.\n','');
        return s.includes(next) ? s.replace(next,old) : s;
    }
    if(!s.includes(old))throw Error('Unexpected release layout');
    return s.replace(old,next);
}
function branchCleanup(s) {
    const cleanup=`    eventPlayer.botIsAttached = false
    deadWeightCarrier.augmentHeldZombie = null
    eventPlayer.augmentZombieCarrier = null`;
    const old=`        eventPlayer.augmentThrowDamageCredit = deadWeightCarrier
${cleanup}

    if eventPlayer.augmentThrowDamageCredit != null:
        wait(AUGMENT_CARRY_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.augmentThrowDamageCredit, AUGMENT_CARRY_THROW_DAMAGE)
        eventPlayer.augmentThrowDamageCredit = null`;
    const next=`        eventPlayer.augmentThrowDamageCredit = deadWeightCarrier
${cleanup.split('\n').map(x=>'    '+x).join('\n')}
        wait(AUGMENT_CARRY_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.augmentThrowDamageCredit, AUGMENT_CARRY_THROW_DAMAGE)
    else:
${cleanup.split('\n').map(x=>'    '+x).join('\n')}`;
    if(!s.includes(old))throw Error('Unexpected release layout');
    return s.replace(old,next);
}
async function main() {
    await compiler.readyPromise;
    const baseline = snapshotThrow(files['augments.opy'], true);
    for(const [name,fn] of Object.entries({baseline:s=>s,livingRoster,snapshotThrow,branchCleanup,combined:s=>snapshotThrow(livingRoster(s))})) {
        const r=await compile({...files,'augments.opy':fn(baseline)});
        process.stdout.write(JSON.stringify({name,elements:r.elements,warnings:r.warnings})+'\n');
    }
}
module.exports={livingRoster,snapshotThrow,branchCleanup};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
