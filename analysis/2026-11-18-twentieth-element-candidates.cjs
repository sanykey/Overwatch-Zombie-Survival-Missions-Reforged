// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='67621877cb36df2cbe004ec42510f2e220c07719';
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
 reignited_impulse_direction_snapshot(f) {
  const file='game/zombie_types.opy',expression='directionTowards(eventPlayer, eventPlayer.botTarget)';
  const line=f[file].split('\n').find(s=>s.includes('eventPlayer.applyImpulse(normalize('+expression+' + offsetUpQuarterConst)'));assert(line);
  assert.equal(line.split(expression).length-1,2);
  replace(f,file,line,'            # Synchronous impulse input; consumed before the movement helper and any wait.\n            #!define reignitedImpulseDirection tmp0\n            reignitedImpulseDirection = '+expression+'\n'+line.replaceAll(expression,'reignitedImpulseDirection'));
 },
 bot_stat_hero_snapshot(f) {
  const file='core/subroutines.opy',start=f[file].indexOf('    if eventPlayer.getHero() == Hero.REINHARDT:',f[file].indexOf('macro botStatManagementMacro():'));
  const end=f[file].indexOf('\n\n\nmacro mutationsMacro():',start);assert(start>0&&end>start);
  const body=f[file].slice(start,end);assert.equal((body.match(/eventPlayer\.getHero\(\)/g)||[]).length,9);
  f[file]=f[file].slice(0,start)+'    # Hero-table index is dead. Reuse tmp0 only for this synchronous branch dispatch.\n    #!define botStatHero tmp0\n    botStatHero = eventPlayer.getHero()\n'+body.replaceAll('eventPlayer.getHero()','botStatHero')+f[file].slice(end);
 },
 pup_impulse_direction_snapshot(f) {
  const file='abilities/enhancements.opy',expression='directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget)';
  const line=f[file].split('\n').find(s=>s.includes('eventPlayer.enhancementPupTarget.applyImpulse(directionFromAngles('));assert(line);
  assert.equal(line.split(expression).length-1,2);
  replace(f,file,line,'            # Synchronous impulse input; no waits/calls/captures before both angle reads.\n            #!define pupImpulseDirection tmp0\n            pupImpulseDirection = '+expression+'\n'+line.replaceAll(expression,'pupImpulseDirection'));
 },
};
const recommended=['pup_impulse_direction_snapshot','reignited_impulse_direction_snapshot'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30023);assert.deepEqual(baseline.encounteredWarnings,[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);row.variablesRulesConditionsAndSelectTargetUnchanged=true;
  for(const [candidate,n] of [['pup_impulse_direction_snapshot','P.U.P. CONTROL #1'],['reignited_impulse_direction_snapshot','REIGNITED (ANRAN) ABILITIES #1']]) {
   if(![candidate,'combined_recommended'].includes(name))continue;
   // Read the balanced native call, including aliased player variable names.
   const marker='Set Global Variable(tmp0, ',start=after[n].indexOf(marker+'Direction Towards(');assert(start>=0);
   const callStart=start+marker.length;let end=after[n].indexOf('(',callStart)+1,depth=1;
   for(;depth;end++){assert(end<after[n].length);if(after[n][end]==='(')depth++;else if(after[n][end]===')')depth--;}
   const nativeDirection=after[n].slice(callStart,end),assignment=marker+nativeDirection+');';
   assert(after[n].includes(assignment));assert.equal((after[n].match(/Global\.tmp0/g)||[]).length,2);
   // Removing a scratch assignment must also rebase compiled Skip offsets that cross it.
   const restored=after[n].replace(assignment,'Call Subroutine(snapshot);').replaceAll('Global.tmp0',nativeDirection);
   assert.deepEqual(expandedActions(restored,{snapshot:[]}),expandedActions(before[n]));
   row[candidate+'RestoresOriginalActionsAndJumps']=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30019);assert.deepEqual(r.encounteredWarnings,[]);}
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twentieth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twentieth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twentieth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
