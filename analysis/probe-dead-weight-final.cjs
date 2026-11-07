// Read-only compiler probes for the immediate-damage, no-cooldown ability.
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
function mergeMiss(s) {
    return s.replace('    if livingProjectileCandidate == null:\n        return\n    if [livingProjectileCandidate.getTeam()',
        '    if [livingProjectileCandidate == null, livingProjectileCandidate.getTeam()');
}
function groupEligibility(s) {
    return s.replace(/if not \((livingProjectileCandidate.getNormalizedHealth\(\) < 0.2 or .*?)\):/, (_, e) =>
        'if not [' + e.split(' or ').join(', ') + '].any():');
}
function shortHud(s) {
    const old=s.match(/\(f"\{max\(0, ceil\(eventPlayer.augmentHoldUntil.*?\) if eventPlayer.augmentId == Augment.LIVING_PROJECTILE/)[0];
    return s.replace(old, '("{0} | [{1}]".format(f"Throw: {max(0, ceil(eventPlayer.augmentHoldUntil - getTotalTimeElapsed()))}s" if eventPlayer.augmentHeldZombie != null else "Aim at a vulnerable zombie to pick up", inputBindingString(Button.INTERACT))) if eventPlayer.augmentId == Augment.LIVING_PROJECTILE');
}
function inlineInput(s) {
    return s.slice(s.indexOf('def useLivingProjectile():')).split('\n\n\n#!define livingProjectileInterrupted')[0]
        .replace('def useLivingProjectile():\n    @Name "useLivingProjectile"\n\n','').trimEnd();
}
function inlineBranch(f, guardMiss = true) {
    const s=f['augments.opy'];
    const body=inlineInput(s);
    const blocked=body.match(/    if (\[eventPlayer.isAttached.*):/)[1];
    const invalid=body.match(/    if (\[livingProjectileCandidate.getTeam.*):/)[1];
    const eligible=body.match(/    if not \((livingProjectileCandidate.getNormalizedHealth.*)\):/)[1];
    const query=body.match(/    livingProjectileCandidate = .*/)[0].trim();
    const pickup=body.slice(body.indexOf('    eventPlayer.augmentHeldZombie = livingProjectileCandidate')).trimEnd();
    const inner = `            # Synchronous input-only scratch; no wait or live capture.\n            #!define livingProjectileCandidate tmp0\n            ${query}\n` +
        (guardMiss ? `            if livingProjectileCandidate != null:\n                if not ${invalid} and (${eligible}):\n` : `            if livingProjectileCandidate != null and not ${invalid} and (${eligible}):\n`) +
        pickup.split('\n').map(line=>(guardMiss?'                ':'            ')+line).join('\n');
    const old='        useLivingProjectile()';
    f={...f,'augments.opy':s.replace(/def useLivingProjectile\(\):[\s\S]*?(?=\n\n\n#!define livingProjectileInterrupted)/,'')};
    const constants=s.match(/^#!define AUGMENT_CARRY_.*$/gm).join('\n');
    f['augments.opy']=f['augments.opy'].replace(/^#!define AUGMENT_CARRY_.*\n/gm,'');
    f['variables.opy']+='\n'+constants+'\n';
    f['supply_drops.opy']=f['supply_drops.opy'].replace('subroutine useLivingProjectile\n','').replace(old,
        `        if eventPlayer.augmentHeldZombie != null:\n            eventPlayer.augmentHoldUntil = 0\n        elif not ${blocked}:\n`+inner);
    return f;
}
async function main() {
    await compiler.readyPromise;
    const source=files['augments.opy'];
    for (const [name, change] of Object.entries({baseline:s=>s,mergeMiss,groupEligibility,shortHud,
        combined:s=>groupEligibility(mergeMiss(s))})) {
        const r=await compile({...files,'augments.opy':change(source)});
        process.stdout.write(JSON.stringify({name,elements:r.elements,warnings:r.warnings})+'\n');
    }
    for(const guardMiss of [true,false]) {
        const r=await compile(inlineBranch(files,guardMiss));
        process.stdout.write(JSON.stringify({name:'inlineBranch',guardMiss,elements:r.elements,warnings:r.warnings})+'\n');
    }

}
module.exports={mergeMiss,groupEligibility,shortHud,inlineBranch};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
