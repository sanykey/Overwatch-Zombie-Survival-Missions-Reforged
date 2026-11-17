// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const {actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='b5c271c8b8e58d99ccdb48ceac20923f61525a77';
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
 rescue_window_minimum(f) {
  replace(f,'game/players_game_in_progress.opy','mustReviveTime -= 0 if mustReviveTime <= 30 else 10','mustReviveTime = max(30, mustReviveTime - 10)');
 },
 boss_damage_direct_threshold(f) {replace(f,'objective_types/objective_type_bosses.opy','elif eventDamage - 1000 > 0:','elif eventDamage > 1000:');},
 revive_conditional_half_increment(f) {
  replace(f,'game/players_game_in_progress.opy','        if eventPlayer.rescueTimeRemaining < 70:\n            eventPlayer.rescueTimeRemaining += 0.5','        eventPlayer.rescueTimeRemaining += 0.5 * (eventPlayer.rescueTimeRemaining < 70)');
 },
 infection_flag_direct(f) {
  replace(f,'game/players_game_in_progress.opy','    if eventPlayer.infectionLevel < 1:\n        eventPlayer.isInfected = false','    eventPlayer.isInfected = eventPlayer.infectionLevel >= 1');
 },
 infection_flag_and(f) {
  replace(f,'game/players_game_in_progress.opy','    if eventPlayer.infectionLevel < 1:\n        eventPlayer.isInfected = false','    eventPlayer.isInfected = eventPlayer.isInfected and eventPlayer.infectionLevel >= 1');
 },
 hitchhiker_mirror_and_lift(f) {
  replace(f,'abilities/enhancements.opy','            #Translate player behind parent\n            if hitchhikerLocalAttachmentOffset.z > 0:\n                # hitchhikerLocalAttachmentOffset: mirror a forward offset behind the parent.\n                hitchhikerLocalAttachmentOffset *= vect(1, 1, -1)\n            # hitchhikerLocalAttachmentOffset: raise the final local offset before capturing it in attachTo.\n            hitchhikerLocalAttachmentOffset += Vector.UP','            # Mirror the local forward axis behind the carrier and raise the attachment.\n            hitchhikerLocalAttachmentOffset = vect(hitchhikerLocalAttachmentOffset.x, hitchhikerLocalAttachmentOffset.y + 1, -abs(hitchhikerLocalAttachmentOffset.z))');
 },
};
const recommended=['boss_damage_direct_threshold','rescue_window_minimum'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,29954);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 const allSource=Object.values(files).join('\n');
 const rescueWrites=[...allSource.matchAll(/^\s*mustReviveTime\s*(?:=|-=)[^\n]*/gm)].map(m=>m[0].trim());
 assert.deepEqual(rescueWrites.sort(),['mustReviveTime = 60','mustReviveTime -= 0 if mustReviveTime <= 30 else 10'].sort());
 let rescueCases=0;
 for(const round of [x=>x,Math.fround])for(const initial of [30,40,50,60]) {
  let old=initial,next=initial;
  for(let i=0;i<1000;i++){old=round(old-(old<=30?0:10));next=round(Math.max(30,round(next-10)));assert.equal(next,old);rescueCases++;}
 }
 const damage=[0,1,999,1000,1001,1e9,Number.MAX_VALUE];
 for(let i=0;i<10000;i++)damage.push(i/7);
 for(const bytes of [4,8]) {
  const view=new DataView(new ArrayBuffer(bytes));
  if(bytes===4){view.setFloat32(0,1000);const center=view.getUint32(0);for(let i=-1024;i<=1024;i++){view.setUint32(0,center+i);damage.push(view.getFloat32(0));}}
  else {view.setFloat64(0,1000);const center=view.getBigUint64(0);for(let i=-1024;i<=1024;i++){view.setBigUint64(0,center+BigInt(i));damage.push(view.getFloat64(0));}}
 }
 let thresholdCases=0;
 for(const round of [x=>x,Math.fround])for(const input of damage){const x=round(input);if(!Number.isFinite(x))continue;assert.equal(round(x-1000)>0,x>1000);thresholdCases++;}
 report.rescueWrites=rescueWrites;report.rescueTransitionModelCases=rescueCases;report.damageThresholdModelCases=thresholdCases;
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1']){assert(before[n]);assert.equal(after[n],before[n]);}
  assert.deepEqual(nestedPredicates(r.result),[]);
  if(['boss_damage_direct_threshold','combined_recommended'].includes(name)) {
   const n='BOSS DIES (ALL BOSS OBJECTIVES) #1',old='Compare(Subtract(Event Damage, 1000), >, Null)';assert(before[n].includes(old));
   assert.equal(before[n].replace(old,'Compare(Event Damage, >, 1000)'),after[n]);row.bossChangesOnlyThreshold=true;
  }
  if(['rescue_window_minimum','combined_recommended'].includes(name)) {
   const n='REVIVE PLAYER OR ADVANCE DEATH TIMER #1';
   const old='Modify Global Variable(mustReviveTime, Subtract, If-Then-Else(Compare(Global.mustReviveTime, <=, 30), Null, 10));';
   assert(before[n].includes(old));assert.equal(before[n].replace(old,'Set Global Variable(mustReviveTime, Max(30, Subtract(Global.mustReviveTime, 10)));'),after[n]);row.rescueChangesOnlyBoundedDecrement=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,29950);assert.deepEqual(r.encounteredWarnings,[]);assert.equal(row.changedRules.length,2);}
  row.variablesRuleSetConditionsAndCarryReleaseUnchanged=true;row.noNestedArrayPredicates=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-seventh-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-seventh-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-seventh-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
