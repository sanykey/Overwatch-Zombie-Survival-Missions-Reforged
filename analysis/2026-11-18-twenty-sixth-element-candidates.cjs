// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const {actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='e7f4fa53b3c336ff97405a2a98f8af81c278f2f9';
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
 bite_dot_lower_bound(f) {
  replace(f,'game/bots_game_in_progress.opy','    if eventPlayer.damageOverTimeRemaining < eventPlayer.botBiteDuration:\n        eventPlayer.damageOverTimeRemaining = eventPlayer.botBiteDuration','    eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, eventPlayer.botBiteDuration)');
 },
 gas_cloud_dot_lower_bound(f) {
  replace(f,'game/zombie_types.opy','    if eventPlayer.damageOverTimeRemaining < 2.5 and eventPlayer.botSpecialTargetList != []:\n        eventPlayer.damageOverTimeRemaining = 2.5','    if eventPlayer.botSpecialTargetList != []:\n        eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, 2.5)');
 },
 gas_cloud_conditional_growth(f) {
  replace(f,'game/zombie_types.opy','        if eventPlayer.botGasRadiusList[behemothGasCloudIndex] < 6 * eventPlayer.sizeScale:\n            eventPlayer.botGasRadiusList[behemothGasCloudIndex] += 0.2 * eventPlayer.sizeScale','        eventPlayer.botGasRadiusList[behemothGasCloudIndex] += 0.2 * eventPlayer.sizeScale * (eventPlayer.botGasRadiusList[behemothGasCloudIndex] < 6 * eventPlayer.sizeScale)');
 },
};
const recommended=['bite_dot_lower_bound','gas_cloud_dot_lower_bound'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
function withoutActions(rule,indices) {
 const actions=actionList(rule);for(const i of indices)actions[i]='Call Subroutine(removed);';
 return rule.replace(/actions \{.*\} \}$/,'actions { '+actions.join(' ')+' } }');
}
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,29971);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 let numericCases=0;
 for(const round of [x=>x,Math.fround])for(let i=-1000;i<=5000;i++)for(const bound of [0,0.1,0.5,1,2,2.5,3,10]) {
  const x=round(i/137),d=round(bound);assert.equal(x<d?d:x,Math.max(x,d));
  for(const targets of [false,true])assert.equal(x<2.5&&targets?2.5:x,targets?Math.max(x,2.5):x);
  numericCases++;
 }
 report.numericTimerCases=numericCases;report.gasGateCases=numericCases*2;
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1']){assert(before[n]);assert.equal(after[n],before[n]);}
  assert.deepEqual(nestedPredicates(r.result),[]);
  if(['bite_dot_lower_bound','combined_recommended'].includes(name)) {
   const n='BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT) #1',old=actionList(before[n]),next=actionList(after[n]);
   const set=old.findIndex(a=>a.startsWith('Set Player Variable(Event Player, damageOverTimeRemaining, '));assert(set>0);
   const bound=old[set].match(/^Set Player Variable\(Event Player, damageOverTimeRemaining, (.*)\);$/)[1];
   const skipped=old[set-1]===`Skip If(Compare((Event Player).damageOverTimeRemaining, >=, ${bound}), True);`;
   const removed=[set-1,set];
   if(!skipped){assert.equal(old[set-1],`If(Compare((Event Player).damageOverTimeRemaining, <, ${bound}));`);assert.equal(old[set+1],'End;');removed.push(set+1);}
   const at=next.indexOf(`Modify Player Variable(Event Player, damageOverTimeRemaining, Max, ${bound});`);assert(at>=0);
   assert.deepEqual(expandedActions(withoutActions(before[n],removed),{removed:[]}),expandedActions(withoutActions(after[n],[at]),{removed:[]}));
   row.biteReceiverDurationAndOtherActionsUnchanged=true;
  }
  if(['gas_cloud_dot_lower_bound','combined_recommended'].includes(name)) {
   const n='BEHEMOTH GAS STREAM (BOSS) #1',old=actionList(before[n]),next=actionList(after[n]);
   const set=old.indexOf('Set Player Variable(Event Player, damageOverTimeRemaining, 2.5);');assert(set>0);
   assert.equal(old[set-1],'If(And(Compare((Event Player).damageOverTimeRemaining, <, 2.5), Compare((Event Player).abilityTargetList, !=, Empty Array)));');assert.equal(old[set+1],'End;');
   const at=next.indexOf('Modify Player Variable(Event Player, damageOverTimeRemaining, Max, 2.5);');assert(at>0);
   assert.equal(next[at-1],'Skip If(Compare((Event Player).abilityTargetList, ==, Empty Array), True);');
   assert.deepEqual(expandedActions(withoutActions(before[n],[set-1,set,set+1]),{removed:[]}),expandedActions(withoutActions(after[n],[at-1,at]),{removed:[]}));
   row.gasTargetGateReceiverBoundAndOtherActionsUnchanged=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,29954);assert.deepEqual(r.encounteredWarnings,[]);assert.equal(row.changedRules.length,2);}
  row.variablesRuleSetConditionsAndCarryReleaseUnchanged=true;row.noNestedArrayPredicates=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-sixth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-sixth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-sixth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
