// Compile read-only probes against the current committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='49c782059e0ae8bbae19e6fe3985efd9df8de6a4';
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
 boss_egg_constant_health(f) {
  for(const file of ['objective_types/objective_type_bosses.opy','objective_types/objective_type_zombie_egg.opy']) replace(f,file,'eventPlayer.botBaseHealth = 15000\n    eventPlayer.botBossHealth = eventPlayer.botBaseHealth','eventPlayer.botBaseHealth = 15000\n    eventPlayer.botBossHealth = 15000');
 },
 select_first_visible_filter(f) {
  replace(f,'core/subroutines.opy','    # botSelectionCandidateIndex: candidate-target index, to select the first target visible to this bot.\n    #!define botSelectionCandidateIndex tmp0\n    # Only a candidate that passed line of sight may become the search result.\n    eventPlayer.botCandidateTarget = null\n    for botSelectionCandidateIndex in range(len(botSelectionCandidateList)):\n        if isInLoS(botSelectionCandidateList[botSelectionCandidateIndex].getEyePosition(), eventPlayer.getPosition() + losOffsetConst):\n            eventPlayer.botCandidateTarget = botSelectionCandidateList[botSelectionCandidateIndex]\n            break',
  '    # Preserve candidate order and the empty-result sentinel; evaluates LOS for all candidates.\n    eventPlayer.botCandidateTarget = botSelectionCandidateList.filter(lambda candidate: isInLoS(candidate.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))[0]');
 },
 carry_condition_owner_binding(f) {
  replace(f,'abilities/enhancements.opy','@Condition (eventPlayer.wrestlerZombieCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not livingProjectileValid(eventPlayer.wrestlerZombieCarrier)) == true','@Condition [eventPlayer.wrestlerZombieCarrier].any(lambda carrier: carrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not livingProjectileValid(carrier)) == true');
 },
 carry_valid_and_chain(f) {
  const file='abilities/enhancements.opy',line=f[file].split('\n').find(s=>s.startsWith('#!define livingProjectileValid(carrier) '));assert(line);
  replace(f,file,line,'#!define livingProjectileValid(carrier) (isGameplayActive and entityExists(carrier) and carrier.isAlive() and not carrier.isCrowdControlled and not carrier.isAttached and carrier.getHero() == eventPlayer.wrestlerCarryHero and eventPlayer.isAlive() and not eventPlayer.botIsInitializing and not eventPlayer.botIsTeleporting and eventPlayer.botIsAttached and eventPlayer.hasStatus(Status.KNOCKED_DOWN))');
 },
 explosion_los_or(f) {replace(f,'core/subroutines.opy','(isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) if eventPlayer.isDummy() else true)','(not eventPlayer.isDummy() or isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))');},
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30092);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 let carryCases=0,targetCases=0,oldLosCalls=0,filterLosCalls=0;
 for(let mask=0;mask<2048;mask++) for(const state of [0,1,2]) {
  const flags=Array.from({length:11},(_,i)=>!!(mask&(1<<i)));
  const owner={state,flags};
  const old=owner.state===2||!owner.flags.every(Boolean);
  const next=[owner].some(carrier=>carrier.state===2||!carrier.flags.every(Boolean));
  assert.equal(old,next);carryCases++;
 }
 for(let n=0;n<=10;n++) for(let mask=0;mask<(1<<n);mask++) {
  const players=Array.from({length:n},(_,id)=>({id}));let beforeTarget=null;
  for(let i=0;i<n;i++) {oldLosCalls++;if(mask&(1<<i)) {beforeTarget=players[i];break;}}
  const selected=players.filter((_,i)=>{filterLosCalls++;return !!(mask&(1<<i));});
  // Model the consumer's existing != Null guard: missing First Of is zero/Null, never a player.
  const afterTarget=selected.length?selected[0]:null;
  assert.equal(beforeTarget,afterTarget);targetCases++;
 }
 report.carryPredicateModelCases=carryCases;report.targetSelectionModelCases=targetCases;
 report.modelLosCalls={loop:oldLosCalls,filter:filterLosCalls,note:'Logical call counts, not native CPU measurements'};
 candidates.combined_recommended=f=>{for(const n of ['boss_egg_constant_health']) candidates[n](f);};
 candidates.combined_without_full_los_scan=f=>{for(const n of ['boss_egg_constant_health']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   if(name.startsWith('combined_')) {
    assert.equal(r.nbElements,30090);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(Object.keys(after),Object.keys(before));
    const carry='LIVING PROJECTILE RELEASE #1',actions=s=>s.match(/ actions \{ (.*?) \} \}$/)?.[1];
    assert(actions(before[carry]));assert.equal(actions(after[carry]),actions(before[carry]));
    const conditions=s=>s.match(/conditions \{ (.*?) \}/)?.[1];
    for(const n of Object.keys(before)) if(n!==carry) assert.equal(conditions(after[n]),conditions(before[n]));
    assert.equal(conditions(after[carry]).split(';')[0],conditions(before[carry]).split(';')[0]);
    assert.equal(after[carry],before[carry]);
    const expected=['BOT BECOMES BOSS #1','BOT BECOMES ZOMBIE EGG #1'];
    assert.deepEqual(row.changedRules.slice().sort(),expected.sort());
    row.sameVariablesAndRules=true;row.carryActionsAndOwnerGuardUnchanged=true;row.otherConditionsUnchanged=true;
   }
   if(name==='carry_condition_owner_binding')row.rejectedForImportCompatibility=true;
   if(name==='select_first_visible_filter')row.excludedByUser=true;
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-thirteenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-thirteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-thirteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
