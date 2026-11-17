// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='7319276751bd9453720711409d7f461f61ac24f0';
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
 grid_remove_empty_all_guard(f) {
  replace(f,'core/global_startup.opy','            if mapGridList == [] or mapGridList.all(lambda x: distance(x, mapGridCandidatePosition) > 2.5):','            # Is True For All is true for an empty array too.\n            if mapGridList.all(lambda x: distance(x, mapGridCandidatePosition) > 2.5):');
 },
 rescue_initial_radius_constant(f) {
  replace(f,'core/subroutines.opy','                objectiveRad = 10\n                rescueSavedRadius = objectiveRad','                objectiveRad = 10\n                rescueSavedRadius = 10');
 },
};
const recommended=['grid_remove_empty_all_guard'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30019);assert.deepEqual(baseline.encounteredWarnings,[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 report.emptyAllNativeBehaviorSource='https://us.forums.blizzard.com/en/overwatch/t/wiki-workshop-syntax-script-database/335011?page=8';
 let gridGuardCases=0;
 for(let length=0;length<=12;length++)for(let mask=0;mask<2**length;mask++) {
  const outcomes=Array.from({length},(_,i)=>Boolean(mask&(1<<i)));
  assert.equal(length===0||outcomes.every(Boolean),outcomes.every(Boolean));gridGuardCases++;
 }
 report.gridGuardBooleanModelCases=gridGuardCases;
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);row.variablesRulesConditionsAndSelectTargetUnchanged=true;
  if(['grid_remove_empty_all_guard','combined_recommended'].includes(name)) {
   const n='generateMapGrid #1',predicate='Is True For All(Global.mapGridList, Compare(Distance Between(Current Array Element, Global.tmp0), >, 2.5))';
   const original='Or(Compare(Global.mapGridList, ==, Empty Array), '+predicate+')';
   assert(before[n].includes(original));assert.equal(before[n].replace(original,predicate),after[n]);
   row.onlyRedundantEmptyGuardChanged=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30013);assert.deepEqual(r.encounteredWarnings,[]);}
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-second-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-second-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-second-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
