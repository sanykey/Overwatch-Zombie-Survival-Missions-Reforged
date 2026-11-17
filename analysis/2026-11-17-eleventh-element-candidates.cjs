// Measure synchronous helper extraction in memory; never edit gameplay sources.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='36517d8e40e897b02216bbe6b9c872c645df1d1a';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function expandHelpers(compiledRules) {
 const added=Object.keys(compiledRules).filter(n=>!Object.hasOwn(rulesCache,n));
 const bodies=Object.fromEntries(added.map(n=>{
  const rule=compiledRules[n],name=rule.match(/^rule \("([^"]+)"\)/)[1],body=rule.match(/ actions \{ (.*?) \} \}$/)?.[1];
  assert(body,name);assert(!/\b(?:Wait|Wait Until|Start Rule|Skip|Abort|Loop)\b/.test(body),name+' must be synchronous');return [name,body];
 }));
 const result={};
 for(const [n,rule] of Object.entries(compiledRules)) if(Object.hasOwn(rulesCache,n)) {
  const body=rule.match(/ actions \{ (.*?) \} \}$/)?.[1];
  if(!body) {result[n]=rule;continue;}
  const actions=splitActions(body),chunks=[],offsets=[];let offset=0;
  for(const action of actions) {
   offsets.push(offset);
   const call=action.match(/^Call Subroutine\((\w+)\);$/);
   const chunk=call&&bodies[call[1]]?splitActions(bodies[call[1]]):[action];
   chunks.push(chunk);offset+=chunk.length;
  }
  offsets.push(offset);
  // Restore relative jump distances when expanding a 1-action call back to 2 actions.
  // Dynamic Skip expressions remain unchanged and must still compare exactly below.
  for(let i=0;i<actions.length;i++) {
   if(chunks[i].length!==1)continue;
   const a=actions[i],skip=a.match(/^Skip\((\d+)\);$/),skipIf=a.match(/^Skip If\(.*?, (\d+)\);$/);
   if(skip||skipIf) {
    const count=Number((skip||skipIf)[1]),target=i+1+count;
    assert(target<=actions.length,'Static Skip must target within its action list');
    chunks[i]=[a.replace(/\d+\);$/,String(offsets[target]-offsets[i+1])+');')];
   }
  }
  result[n]=rule.replace(/ actions \{ .*? \} \}$/, ' actions { '+chunks.flat().join(' ')+' } }');
 }
 return result;
}
function splitActions(body) {
 const actions=[];let start=0,depth=0,quoted=false,escaped=false;
 for(let i=0;i<body.length;i++) {
  const c=body[i];
  if(quoted) {if(escaped)escaped=false;else if(c==='\\')escaped=true;else if(c==='"')quoted=false;continue;}
  if(c==='"')quoted=true;else if(c==='(')depth++;else if(c===')')depth--;else if(c===';'&&depth===0) {actions.push(body.slice(start,i+1).trim());start=i+1;}
 }
 assert.equal(body.slice(start).trim(),'');assert.equal(depth,0);assert(!quoted);
 return actions;
}
let rulesCache;
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function extract(f,name,actions,expected) {
 assert(name.length<=31);let count=0;
 for(const file of Object.keys(f)) {
  const lines=f[file].split('\n'),out=[];
  for(let i=0;i<lines.length;i++) {
   const indent=lines[i].match(/^\s*/)[0];
   if(actions.every((a,j)=>lines[i+j]===indent+a)) {out.push(indent+name+'()');i+=actions.length-1;count++;}
   else out.push(lines[i]);
  }
  f[file]=out.join('\n');
 }
 assert.equal(count,expected,name+' occurrence count');
 const file='core/subroutines.opy';
 f[file]='subroutine '+name+'\n'+f[file]+'\n\ndef '+name+'():\n    @Name "'+name+'"\n    # Synchronous extraction: preserve action order and caller eventPlayer; no waits or scratch.\n'+actions.map(a=>'    '+a).join('\n')+'\n';
}
const candidates={
 turret_barrel_scale(f) {replace(f,'items/supply_drops.opy','(eventPlayer.powerUpTurretDirection * 0.5 if getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting) else eventPlayer.getFacingDirection() * 0.5)','((eventPlayer.powerUpTurretDirection if getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting) else eventPlayer.getFacingDirection()) * 0.5)');},
 hitchhiker_attachment_scale(f) {replace(f,'abilities/enhancements.opy','directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementHitchhikerCarrier, eventPlayer)), 0) * eventPlayer.enhancementHitchhikerCarrier.sizeScale + eventPlayer.enhancementHitchhikerCarrier.sizeScale * Vector.UP','(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementHitchhikerCarrier, eventPlayer)), 0) + Vector.UP) * eventPlayer.enhancementHitchhikerCarrier.sizeScale');},
 redundant_unit_multipliers(f) {
  replace(f,'game/zombie_types.opy','evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1','evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90)))');
  const file='objective_types/objective_type_satellite_uplink.opy',a='directionFromAngles(getTotalTimeElapsed() * 360, 0) * 1';assert.equal(f[file].split(a).length-1,2);f[file]=f[file].replaceAll(a,'directionFromAngles(getTotalTimeElapsed() * 360, 0)');
  const battery='abilities/enhancement_charge_battery.opy';assert.equal(f[battery].split('getTotalTimeElapsed() * 1').length-1,2);f[battery]=f[battery].replaceAll('getTotalTimeElapsed() * 1','getTotalTimeElapsed()');
 },
 collision_native_then_flag(f) {extract(f,'enableBotCollisionAndFlag',['eventPlayer.enableEnvironmentCollision()','eventPlayer.botIsWallCollisionEnabled = true'],6);},
 collision_flag_then_native(f) {extract(f,'enableBotFlagAndCollision',['eventPlayer.botIsWallCollisionEnabled = true','eventPlayer.enableEnvironmentCollision()'],3);},
 begin_throttle_override(f) {extract(f,'beginBotThrottleOverride',['eventPlayer.botIsThrottleOverridden = true','eventPlayer.stopThrottleInDirection()'],4);},
 clear_movement_overrides(f) {extract(f,'clearBotMovementOverrides',['eventPlayer.botIsThrottleOverridden = false','eventPlayer.botIsFacingOverridden = false'],4);},
 boost_movement_speed(f) {extract(f,'boostMovementSpeed',['eventPlayer.movementSpeedScale *= 1.5','applyScaledMoveSpeed()'],3);},
 unboost_movement_speed(f) {extract(f,'unboostMovementSpeed',['eventPlayer.movementSpeedScale /= 1.5','applyScaledMoveSpeed()'],2);},
 detach_tracked_target(f) {extract(f,'detachTrackedAbilityTarget',['detachAbilityTarget()','eventPlayer.botAbilityTarget.isAttached = false'],3);},
 resume_bot_facing_now(f) {extract(f,'resumeBotFacingNow',['eventPlayer.botIsFacingOverridden = false','restoreDefaultFacingMovement()'],3);},
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30124);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);rulesCache=before;
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 let seed=367,attachmentCases=0,turretCases=0;
 const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296*2000-1000;};
 for(let i=0;i<10000;i++) {
  const position=[random(),random(),random()],angle=random(),direction=[Math.sin(angle),0,Math.cos(angle)],scale=Math.abs(random()/100),up=[0,1,0];
  assert.deepEqual(position.map((v,j)=>(v+direction[j]*scale)+scale*up[j]),position.map((v,j)=>v+(direction[j]+up[j])*scale));attachmentCases++;
  const turret=[random(),random(),random()],facing=[random(),random(),random()];
  for(const hasTarget of [false,true]) {
   const old=hasTarget?turret.map(v=>v*0.5):facing.map(v=>v*0.5),next=(hasTarget?turret:facing).map(v=>v*0.5);
   assert.deepEqual(old,next);turretCases++;
  }
 }
 report.attachmentModelCases=attachmentCases;report.turretModelCases=turretCases;
 candidates.combined_recommended=f=>{for(const n of ['turret_barrel_scale','hitchhiker_attachment_scale','collision_native_then_flag','begin_throttle_override','clear_movement_overrides','boost_movement_speed','detach_tracked_target']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   const added=Object.keys(after).filter(n=>!Object.hasOwn(before,n));
   if(added.length) {
    const expanded=expandHelpers(after);
    const remaining=Object.keys(before).filter(n=>before[n]!==expanded[n]);
    if(name==='combined_recommended') assert.deepEqual(remaining.sort(),['HITCHHIKER ATTACH/DETATCH #1','sentryTurret (50-59) #1'].sort());
    else assert.deepEqual(remaining,[],'Inlining extracted helpers must exactly restore baseline actions');
    row.addedSubroutines=added;row.helperExpansionRestoresOriginalActions=true;
   }
   const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
   for(const n of Object.keys(before)) {assert(after[n]);assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
   row.sameVariablesAndExistingConditions=true;
   if(name==='combined_recommended') {assert.equal(r.nbElements,30104);assert.equal(added.length,5);assert.deepEqual(r.encounteredWarnings,[]);}
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-eleventh-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-eleventh-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-eleventh-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
