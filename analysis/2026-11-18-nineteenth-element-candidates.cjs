// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='d0cf55e6501091d10a846b2d3381134057d68773';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
const candidates={
 mixed_objective_recent_threshold(f) {
  replace(f,'game/global_start_menu.opy','i > len(objectiveTypeList) - 1 - (len(mixedObjectiveTypeList) - 1)','i > len(objectiveTypeList) - len(mixedObjectiveTypeList)');
 },
 force_field_zombie_snapshot(f) {
  replace(f,'items/supply_drops.opy','            if distance(getLivingPlayers(Team.2)[forceFieldZombieIndex], eventPlayer.powerUpForceFieldPosition) <= 7.5:\n                getLivingPlayers(Team.2)[forceFieldZombieIndex].applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex]), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)','            # Current zombie only: consumed before the next iteration, with no waits/calls/captures.\n            #!define forceFieldZombie tmp1\n            forceFieldZombie = getLivingPlayers(Team.2)[forceFieldZombieIndex]\n            if distance(forceFieldZombie, eventPlayer.powerUpForceFieldPosition) <= 7.5:\n                forceFieldZombie.applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, forceFieldZombie), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)');
 },
 satellite_filter_complement(f) {
  replace(f,'objective_types/objective_type_satellite_uplink.opy','satelliteTerminalCandidatePositionList.remove(satelliteTerminalCandidatePositionList.filter(lambda x: distance(x, satelliteTerminalPositionList[satelliteSpacingTerminalIndex]) < satelliteMinTerminalSpacing))','satelliteTerminalCandidatePositionList = satelliteTerminalCandidatePositionList.filter(lambda x: distance(x, satelliteTerminalPositionList[satelliteSpacingTerminalIndex]) >= satelliteMinTerminalSpacing)');
 },
 force_field_center_snapshot(f) {
  replace(f,'items/supply_drops.opy','        for forceFieldZombieIndex in range(getNumberOfLivingPlayers(Team.2)):\n','        # Synchronous tick center; dead before the outer loop wait.\n        #!define forceFieldTickCenter tmp2\n        forceFieldTickCenter = eventPlayer.powerUpForceFieldPosition\n        for forceFieldZombieIndex in range(getNumberOfLivingPlayers(Team.2)):\n');
  replace(f,'items/supply_drops.opy','if distance(getLivingPlayers(Team.2)[forceFieldZombieIndex], eventPlayer.powerUpForceFieldPosition) <= 7.5:','if distance(getLivingPlayers(Team.2)[forceFieldZombieIndex], forceFieldTickCenter) <= 7.5:');
  replace(f,'items/supply_drops.opy','applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex])','applyImpulse(directionTowards(forceFieldTickCenter, getLivingPlayers(Team.2)[forceFieldZombieIndex])');
 },
 stuck_bot_wait_ternary(f) {
  replace(f,'game/bots_game_in_progress.opy','    if eventPlayer.botTarget != null:\n        wait(random.uniform(7.5, 12.5), Wait.ABORT_WHEN_FALSE)\n    else:\n        wait(5, Wait.ABORT_WHEN_FALSE)','    wait(random.uniform(7.5, 12.5) if eventPlayer.botTarget != null else 5, Wait.ABORT_WHEN_FALSE)');
 },
 grapnel_status_ternary(f) {
  replace(f,'abilities/augments.opy','                if eventPlayer.augmentGrapnelTarget.isOnGround():\n                    eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.STUNNED, 0.5)\n                else:\n                    eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 3)','                eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.STUNNED if eventPlayer.augmentGrapnelTarget.isOnGround() else Status.KNOCKED_DOWN, 0.5 if eventPlayer.augmentGrapnelTarget.isOnGround() else 3)');
 },
};
const recommended=['force_field_zombie_snapshot','mixed_objective_recent_threshold'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30033);assert.deepEqual(baseline.encounteredWarnings,[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 let thresholdCases=0;
 // Objective count setting is 0..100 (+ final extraction); mixed pool contains at most seven IDs.
 for(let count=0;count<=101;count++)for(let pool=0;pool<=7;pool++)for(let index=0;index<=101;index++) {
  assert.equal(index>count-1-(pool-1),index>count-pool);
  assert.equal(Math.fround(Math.fround(count-1)-Math.fround(pool-1)),Math.fround(count-pool));thresholdCases++;
 }
 report.recentThresholdModelCases=thresholdCases;
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);let r;
  try {r=await compile(f);}catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));continue;}
  const after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);row.variablesRulesConditionsAndSelectTargetUnchanged=true;
  if(['force_field_zombie_snapshot','combined_recommended'].includes(name)) {
   const n='playerForceField (10-19) #1',lookup='Value In Array(All Living Players(Team 2), Global.tmp0)',assignment='Set Global Variable(tmp1, '+lookup+'); ';
   assert(after[n].includes(assignment));assert.equal((after[n].match(/Global\.tmp1/g)||[]).length,3);
   assert.equal(after[n].replace(assignment,'').replaceAll('Global.tmp1',lookup),before[n]);
   row.forceFieldSnapshotExpansionRestoresOriginalRule=true;
   // No extra yields or calls; tmp1 is read only by the gate and its immediate impulse.
   row.forceFieldPerZombieLivingQueries={beforeOutsideRadius:1,beforeInsideRadius:3,after:1};
  }
  if(['mixed_objective_recent_threshold','combined_recommended'].includes(name)) {
   const n='setObjectiveType #1';
   const original='Subtract(Subtract(Count Of(Global.objectiveTypeList), True), Subtract(Count Of(Global.phaseSlot8), True))';
   const replacement='Subtract(Count Of(Global.objectiveTypeList), Count Of(Global.phaseSlot8))';
   assert(before[n].includes(original));assert.equal(before[n].replace(original,replacement),after[n]);
   row.mixedObjectiveChangesOnlyIntegerThreshold=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30023);assert.deepEqual(r.encounteredWarnings,[]);}
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-nineteenth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-nineteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-nineteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
