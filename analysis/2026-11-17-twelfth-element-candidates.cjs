// Read-only candidates; all source mutations stay in memory.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='bc31f30aefec463b6fe2d4859665529fbdd9202c';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function region(f,file,start,end,fn) {const a=f[file].indexOf(start),b=f[file].indexOf(end,a+start.length);assert(a>=0&&b>a);f[file]=f[file].slice(0,a)+fn(f[file].slice(a,b))+f[file].slice(b);}
const candidates={
 remove_unused_teleport_status(f) {
  const all=Object.values(f).join('\n');assert.equal((all.match(/\bsuccessfulTeleportStatus\b/g)||[]).length,3);
  replace(f,'game/bots_game_in_progress.opy','subroutine successfulTeleportStatus\n','');
  region(f,'game/bots_game_in_progress.opy','def successfulTeleportStatus():','def updateBotSpawnPoints():',()=> '');
 },
 inline_drop_finish(f) {
  const file='items/power_ups.opy';
  replace(f,file,'subroutine finishPowerUpDrop\n','');
  replace(f,file,'    finishPowerUpDrop()','    eventPlayer.powerUpItemId = PowerUpItem.NONE\n    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)');
  const start=f[file].indexOf('\n\ndef finishPowerUpDrop():');assert(start>=0);const body=f[file].slice(start);
  assert(!body.includes('wait(')&&!body.includes('return')&&!body.includes('rule "'));
  f[file]=f[file].slice(0,start).trimEnd()+'\n';
 },
 ammo_current_clip_snapshot(f) {
  const file='abilities/augments.opy',read='eventPlayer.getAmmo(augmentAmmoFallbackClipIndex)';
  region(f,file,'    for augmentAmmoFallbackClipIndex in range(2):','    # Valid state has five fields.',b=>{
   assert.equal(b.split(read).length-1,4);b=b.replaceAll(read,'augmentAmmoCurrentClipAmmo');
   const anchor='        augmentAmmoReloadFinished = eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()\n';assert(b.includes(anchor));
   return b.replace(anchor,anchor+'        # Per-clip ammo snapshot: consumed by the predicate and final Set Ammo; no intervening writes/waits/calls.\n        #!define augmentAmmoCurrentClipAmmo tmp3\n        augmentAmmoCurrentClipAmmo = '+read+'\n');
  });
 },
 ammo_previous_clip_snapshot(f) {
  const file='abilities/augments.opy',read='eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3]';
  region(f,file,'    for augmentAmmoFallbackClipIndex in range(2):','    # Valid state has five fields.',b=>{
   assert.equal(b.split(read).length-1,2);b=b.replaceAll(read,'augmentAmmoPreviousClipAmmo');
   const anchor='        augmentAmmoReloadFinished = eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()\n';assert(b.includes(anchor));
   return b.replace(anchor,anchor+'        # Prior-clip reload snapshot: synchronous predicate only, no waits or calls.\n        #!define augmentAmmoPreviousClipAmmo tmp3\n        augmentAmmoPreviousClipAmmo = '+read+'\n');
  });
 },
 downed_walkable_map(f) {replace(f,'game/players_game_in_progress.opy','nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2)','[nearestWalkablePosition(eventPlayer.getPosition())].map(lambda walkable: nearestWalkablePosition(walkable + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, walkable)), 0) * 2))[0]');},
 cooldown_button_loop(f) {
  const file='items/supply_drops.opy',buttons=['ABILITY_1','ABILITY_2','PRIMARY_FIRE','SECONDARY_FIRE','INTERACT','CROUCH','JUMP'];
  replace(f,file,buttons.map(n=>'    eventPlayer.setAbilityCooldown(Button.'+n+', 0)').join('\n'),'    # Cooldown reset index: synchronous; callers retain no scratch across this helper.\n    #!define resetCooldownButtonIndex tmp0\n    for resetCooldownButtonIndex in range(7):\n        eventPlayer.setAbilityCooldown([Button.ABILITY_1, Button.ABILITY_2, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.INTERACT, Button.CROUCH, Button.JUMP][resetCooldownButtonIndex], 0)');
 },
 abilities_boolean_args(f) {
  region(f,'core/subroutines.opy','def enableDisableAbilities():','def objectivesManagement():',()=> 'def enableDisableAbilities():\n    @Name "enableDisableAbilities"\n\n    if isPregameSetup:\n        eventPlayer.disableHeroHud()\n'+['PrimaryFire','SecondaryFire','Ability1','Ability2','Ult','Melee'].map(n=>'    eventPlayer.set'+n+'Enabled(not isPregameSetup)\n').join('')+'    if not isPregameSetup:\n        eventPlayer.enableHeroHud()\n\n\n');
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30104);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 let ammoCases=0;
 for(const capacity of [0,1,35,70]) for(const targetCapacity of [0,1,35,70,140]) for(const ammo of [0,1,34,35,69,70,140]) for(const previousAmmo of [0,34,35,70,140])
  for(const previousBelow of [false,true]) for(const finished of [false,true]) for(const widow of [false,true]) {
   const state=[false,false,false,previousAmmo,previousAmmo];
   for(const clip of [0,1]) {
    const old=capacity>0&&targetCapacity>capacity&&(ammo===capacity&&(previousBelow||finished)||widow&&finished&&ammo<capacity&&(ammo>state[clip+3]||state[clip+3]>capacity));
    const snapshot=state[clip+3];
    const next=capacity>0&&targetCapacity>capacity&&(ammo===capacity&&(previousBelow||finished)||widow&&finished&&ammo<capacity&&(ammo>snapshot||snapshot>capacity));
    assert.equal(old,next);
    assert.equal(old?ammo+targetCapacity-capacity:ammo,next?ammo+targetCapacity-capacity:ammo);ammoCases++;
   }
  }
 report.ammoSnapshotModelCases=ammoCases;
 // Reload completion remains sampled inside each clip iteration, after any preceding Set Ammo.
 const proposedAmmo={...files};candidates.ammo_previous_clip_snapshot(proposedAmmo);
 assert(proposedAmmo['abilities/augments.opy'].includes('for augmentAmmoFallbackClipIndex in range(2):\n        augmentAmmoNativeCapacity = eventPlayer.getMaxAmmo(augmentAmmoFallbackClipIndex)\n        # Re-read on each clip: the preceding clip\'s Set Ammo may change native reload state.\n        augmentAmmoReloadFinished = eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()'));
 assert.equal(proposedAmmo['abilities/augments.opy'].split('eventPlayer.getAmmo(augmentAmmoFallbackClipIndex)').length-1,4);
 candidates.combined_recommended=f=>{for(const n of ['remove_unused_teleport_status','inline_drop_finish','ammo_previous_clip_snapshot']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30092);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    const removed=Object.keys(before).filter(n=>!Object.hasOwn(after,n));
    assert.deepEqual(removed.sort(),['finishPowerUpDrop #1','successfulTeleportStatus #1'].sort());
    assert.equal(Object.keys(after).length,Object.keys(before).length-2);
    assert.deepEqual(row.changedRules.slice().sort(),['AMMO PACK REFILL FALLBACK #1','dropCarriedPowerUps #1','finishPowerUpDrop #1','successfulTeleportStatus #1'].sort());
    for(const n of Object.keys(after)) assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
    const dropFinish=before['finishPowerUpDrop #1'].match(/ actions \{ (.*?) \} \}$/)?.[1];assert(dropFinish);
    assert.equal(after['dropCarriedPowerUps #1'],before['dropCarriedPowerUps #1'].replace('Call Subroutine(finishPowerUpDrop);',dropFinish));
    row.removedSubroutines=removed;row.sameVariablesAndRemainingConditions=true;row.inlineDropFinishPreservesActions=true;row.reloadCompletionStillSampledPerClip=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-twelfth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-twelfth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-twelfth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
