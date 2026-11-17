// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='e06b82ebb23cad6124d0497fabd8c37e464479d0';
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
 kevlar_ability_membership(f) {
  replace(f,'abilities/augments.opy','if eventAbility == null or eventAbility == Button.MELEE:','if eventAbility in [null, Button.MELEE]:');
 },
 bot_damage_ability_membership(f) {
  replace(f,'game/zombie_types.opy','@Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ULTIMATE) == true','@Condition (eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]) == true');
 },
 aimed_items_empty_comparison(f) {
  replace(f,'items/supply_drops.opy','elif len(aimedPowerUpPositions) > 0 and not','elif aimedPowerUpPositions != [] and not');
 },
};
const recommended=['kevlar_ability_membership','bot_damage_ability_membership','aimed_items_empty_comparison'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30011);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before)) {
   if(['bot_damage_ability_membership','combined_recommended'].includes(name)&&n==='BLASTER ROCKET HITS TARGET #1')continue;
   assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  }
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);
  assert.equal(after['LIVING PROJECTILE RELEASE #1'],before['LIVING PROJECTILE RELEASE #1']);
  assert.deepEqual(nestedPredicates(r.result),[]);
  const changes=[
   ['kevlar_ability_membership','KEVLAR RANGED DAMAGE COMPENSATION #1','Or(Compare(Event Ability, ==, Null), Compare(Event Ability, ==, Button(Melee)))','Array Contains(Array(Null, Button(Melee)), Event Ability)'],
   ['bot_damage_ability_membership','BLASTER ROCKET HITS TARGET #1','Or(Compare(Event Ability, ==, Button(Primary Fire)), Compare(Event Ability, ==, Button(Ultimate)))','Array Contains(Array(Button(Primary Fire), Button(Ultimate)), Event Ability)'],
   ['aimed_items_empty_comparison','PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP) #1','Compare(Count Of(Global.tmp0), >, Null)','Compare(Global.tmp0, !=, Empty Array)'],
  ];
  for(const [candidate,rule,oldExpression,newExpression] of changes)if([candidate,'combined_recommended'].includes(name)) {
   assert(before[rule].includes(oldExpression));assert.equal(before[rule].replace(oldExpression,newExpression),after[rule]);
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30004);assert.deepEqual(r.encounteredWarnings,[]);assert.equal(row.changedRules.length,3);}
  row.changesOnlyReviewedExpressions=true;
  row.variablesRuleSetAndCarryReleaseUnchanged=true;row.noNestedArrayPredicates=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-third-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-third-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-third-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
