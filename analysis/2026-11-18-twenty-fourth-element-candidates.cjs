// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
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
 vote_winner_initializes_result(f) {
  const file='game/global_start_menu.opy';
  replace(f,file,'    voteWinnerResult = zombieSetting\n','');
  replace(f,file,'    voteWinnerResult = objectiveTypeSetting\n','');
  replace(f,file,'def selectVoteWinner():\n','def selectVoteWinner():\n    # Both callers start from NO_PREFERENCE (zero); initialize the output here.\n    voteWinnerResult = 0\n');
  replace(f,file,'# Synchronous helper inputs/result; consume them before any wait or asynchronous startRule.','# Synchronous helper input/output; selectVoteWinner initializes the result to zero.\n# Consume the result before any wait or asynchronous startRule.');
 },
 zombie_vote_initial_result_constant(f) {
  replace(f,'game/global_start_menu.opy','    voteWinnerResult = zombieSetting','    # The setting was reset to zero above; no waits or intervening setting writes.\n    voteWinnerResult = 0');
 },
 objective_vote_initial_result_constant(f) {
  replace(f,'game/global_start_menu.opy','    voteWinnerResult = objectiveTypeSetting','    # The setting was reset to NO_PREFERENCE above; preserve the initial winner.\n    voteWinnerResult = ObjectiveType.NO_PREFERENCE');
 },
};
const recommended=['vote_winner_initializes_result'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30004);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1'])assert.equal(after[n],before[n]);
  assert.deepEqual(nestedPredicates(r.result),[]);
  const selected=['vote_winner_initializes_result','combined_recommended'].includes(name)?['zombie_vote_initial_result_constant','objective_vote_initial_result_constant']:[name];
  for(const candidate of selected) {
   const n=candidate.startsWith('zombie')?'determineZombieMode #1':'determineObjectiveType #1';
   const reads=[...before[n].matchAll(/Set Global Variable\(tmp2, Global\.(\w+)\);/g)];assert.equal(reads.length,1);
   const setting=reads[0][1],oldExpression=reads[0][0];
   // The very same native value (Null is the compiler's zero) is already stored in the setting.
   assert(before[n].includes('Set Global Variable('+setting+', Null);'));
   const sharedInit=['vote_winner_initializes_result','combined_recommended'].includes(name);
   assert.equal(before[n].replace(oldExpression+(sharedInit?' ':''),sharedInit?'':'Set Global Variable(tmp2, Null);'),after[n]);
  }
  if(['vote_winner_initializes_result','combined_recommended'].includes(name)) {
   const n='Subroutine selectVoteWinner #1';assert(before[n]);assert.equal(before[n].replace(' actions { ',' actions { Set Global Variable(tmp2, Null); '),after[n]);
   assert.equal(Object.values(files).join('\n').match(/\bselectVoteWinner\(\)/g).length,3,'Exactly two synchronous callers and one definition');
   assert.equal(r.nbElements,30001);assert.deepEqual(r.encounteredWarnings,[]);assert.equal(row.changedRules.length,3);
  }else {assert(before['Subroutine selectVoteWinner #1']);assert.equal(after['Subroutine selectVoteWinner #1'],before['Subroutine selectVoteWinner #1']);}
  row.changesOnlyKnownZeroInitialization=true;row.variablesRulesConditionsAndSelectionLogicUnchanged=true;row.noNestedArrayPredicates=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fourth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fourth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-fourth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
