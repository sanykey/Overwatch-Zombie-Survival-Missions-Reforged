// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const {actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='c0438ddd7fd38558d3b97e309551a41a6ff96e81';
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
 battle_cap_min(f) {
  replace(f,'abilities/player_events.opy','        if eventPlayer.enhancementBattleResetCharges < 2:\n            eventPlayer.enhancementBattleResetCharges += 1','        eventPlayer.enhancementBattleResetCharges = min(2, eventPlayer.enhancementBattleResetCharges + 1)');
 },
 battle_conditional_increment(f) {
  replace(f,'abilities/player_events.opy','        if eventPlayer.enhancementBattleResetCharges < 2:\n            eventPlayer.enhancementBattleResetCharges += 1','        # Numeric reset counter: comparisons contribute exactly 0 or 1.\n        eventPlayer.enhancementBattleResetCharges += eventPlayer.enhancementBattleResetCharges < 2');
 },
 rusher_dot_lower_bound(f) {
  replace(f,'game/zombie_types.opy','    if victim.damageOverTimeRemaining < 0.5:\n        victim.damageOverTimeRemaining = 0.5','    victim.damageOverTimeRemaining = max(victim.damageOverTimeRemaining, 0.5)');
 },
 explosion_dot_lower_bound(f) {
  replace(f,'core/subroutines.opy','        if eventPlayer.damageOverTimeRemaining < 3:\n            eventPlayer.damageOverTimeRemaining = 3','        eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, 3)');
 },
 blaster_dot_lower_bound(f) {
  replace(f,'game/zombie_types.opy','    if eventPlayer.damageOverTimeRemaining < blasterRocketBurnDuration:\n        eventPlayer.damageOverTimeRemaining = blasterRocketBurnDuration','    eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, blasterRocketBurnDuration)');
 },
 behemoth_blast_dot_lower_bound(f) {
  replace(f,'game/zombie_types.opy','            if eventPlayer.damageOverTimeRemaining < 2.5:\n                eventPlayer.damageOverTimeRemaining = 2.5','            eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, 2.5)');
 },
};
const recommended=['battle_conditional_increment','rusher_dot_lower_bound','explosion_dot_lower_bound','blaster_dot_lower_bound','behemoth_blast_dot_lower_bound'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
function withoutActions(rule,indices) {
 const actions=actionList(rule);for(const i of indices)actions[i]='Call Subroutine(removed);';
 return rule.replace(/actions \{.*\} \}$/,'actions { '+actions.join(' ')+' } }');
}
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30004);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 let counterCases=0,timerCases=0;
 const samples=[-1,0,0.5,1,1.5,2,2.5,3,10,100];
 for(let i=0;i<10000;i++)samples.push((i-5000)/137);
 for(const round of [x=>x,Math.fround])for(const input of samples) {
  const x=round(input);assert.equal(x<2?round(x+1):x,round(x+Number(x<2)));counterCases++;
  for(const bound of [0.5,1,2,2.5,3]){assert.equal(x<bound?bound:x,Math.max(x,bound));timerCases++;}
 }
 report.counterNumericModelCases=counterCases;report.timerNumericModelCases=timerCases;
 report.minCounterexample={initial:3,original:3,minVariant:2};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1'])assert.equal(after[n],before[n]);
  assert.deepEqual(nestedPredicates(r.result),[]);
  const timerRules={rusher_dot_lower_bound:'RUSHER MOLTEN CORE BURNS PLAYERS (BOSS) #1',explosion_dot_lower_bound:'explosionSequence #1',blaster_dot_lower_bound:'BLASTER ROCKET HITS TARGET #1',behemoth_blast_dot_lower_bound:'BEHEMOTH (ROAD) TOXIC CLOUD #1'};
  for(const [candidate,n] of Object.entries(timerRules))if([candidate,'combined_recommended'].includes(name)) {
   const old=actionList(before[n]),next=actionList(after[n]);
   const set=old.findIndex(a=>a.startsWith('Set Player Variable(')&&a.includes(', damageOverTimeRemaining, '));assert(set>0);
   const args=old[set].match(/^Set Player Variable\((Event Player|Victim), damageOverTimeRemaining, (.*)\);$/);assert(args);
   const owner=args[1],bound=args[2],value='('+owner+').damageOverTimeRemaining';
   const skipped=old[set-1]===`Skip If(Compare(${value}, >=, ${bound}), True);`;
   assert(skipped||old[set-1]===`If(Compare(${value}, <, ${bound}));`);
   const indices=[set-1,set];if(!skipped&&old[set+1]==='End;')indices.push(set+1);
   const modify=`Modify Player Variable(${owner}, damageOverTimeRemaining, Max, ${bound});`,at=next.indexOf(modify);assert(at>=0);
   assert.deepEqual(expandedActions(withoutActions(before[n],indices),{removed:[]}),expandedActions(withoutActions(after[n],[at]),{removed:[]}));
   row[candidate+'PreservesReceiverBoundAndOtherActions']=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,29974);assert.deepEqual(r.encounteredWarnings,[]);}
  row.variablesRuleSetConditionsAndCarryReleaseUnchanged=true;row.noNestedArrayPredicates=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fifth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fifth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fifth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
