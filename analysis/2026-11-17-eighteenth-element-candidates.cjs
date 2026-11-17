// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='82a51f5f3f8661220b511317f3cc4cf3500842c8';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function splitTop(s,separator) {
 const result=[];let start=0,depth=0,quote=false,escape=false;
 for(let i=0;i<s.length;i++) {const c=s[i];if(quote) {if(escape)escape=false;else if(c==='\\')escape=true;else if(c==='"')quote=false;continue;}if(c==='"')quote=true;else if(c==='(')depth++;else if(c===')')depth--;else if(c===separator&&depth===0) {result.push(s.slice(start,i).trim());start=i+1;}}
 assert.equal(depth,0);assert(!quote);result.push(s.slice(start).trim());return result;
}
function call(s) {const i=s.indexOf('(');assert(i>=0&&s.endsWith(')'),s);return {name:s.slice(0,i),args:splitTop(s.slice(i+1,-1),',')};}
function numeric(s) {if(['Null','False'].includes(s))return 0;if(s==='True')return 1;assert(Number.isFinite(Number(s)),s);return Number(s);}
function actionList(rule) {const body=rule.match(/ actions \{ (.*?) \} \}$/)?.[1];assert(body);const parts=splitTop(body,';');assert.equal(parts.pop(),'');return parts.map(s=>s+';');}
function expandedActions(rule,bodies={}) {
 const actions=actionList(rule),chunks=[],offsets=[];let offset=0;
 for(const action of actions) {
  offsets.push(offset);const match=action.match(/^Call Subroutine\((\w+)\);$/);
  const chunk=match&&bodies[match[1]]?bodies[match[1]]:[action];chunks.push(chunk);offset+=chunk.length;
 }
 offsets.push(offset);
 for(let i=0;i<actions.length;i++) {
  if(chunks[i].length!==1)continue;const a=actions[i];
  if(!a.startsWith('Skip(')&&!a.startsWith('Skip If('))continue;
  const c=call(a.slice(0,-1)),mapped=n=>{const target=i+1+n;assert(Number.isInteger(n)&&n>=0&&target<=actions.length);return offsets[target]-offsets[i+1];};
  const scalar=c.args[c.args.length-1];
  if(/^(?:\d+|Null|False|True)$/.test(scalar)) {
   chunks[i]=[c.name==='Skip'?`Skip(${mapped(numeric(scalar))});`:`Skip If(${c.args[0]}, ${mapped(numeric(scalar))});`];continue;
  }
  assert.equal(c.name,'Skip');const value=call(c.args[0]);assert.equal(value.name,'Value In Array');
  const table=call(value.args[0]);assert.equal(table.name,'Array');
  // Rebase every compiled switch offset when a Call expands to its original actions.
  chunks[i]=[`Skip(Value In Array(Array(${table.args.map(x=>mapped(numeric(x))).join(', ')}), ${value.args[1]}));`];
 }
 return chunks.flat();
}
function addHelper(f,file,name,body) {
 assert(name.length<=31);f[file]=f[file].replace(/^(#!mainFile [^\n]+\n)/,'$1subroutine '+name+'\n');
 f[file]+='\n\ndef '+name+'():\n    @Name "'+name+'"\n    # Synchronous only: retain caller eventPlayer, action order and all surrounding waits.\n'+body.map(s=>'    '+s).join('\n')+'\n';
}
const candidates={
 reignited_redundant_target_guard(f) {
  replace(f,'game/zombie_types.opy','    @Condition (eventPlayer.isOnGround() and eventPlayer.botTarget != null and distance(eventPlayer, eventPlayer.botTarget) > 6 * eventPlayer.sizeScale','    @Condition (eventPlayer.isOnGround() and distance(eventPlayer, eventPlayer.botTarget) > 6 * eventPlayer.sizeScale');
 },
 spawn_hero_list_inline(f) {
  replace(f,'core/global_startup.opy','    # spawnedBotHeroList: hero types already present among zombies, to check the unique-skin limit.\n    #!define spawnedBotHeroList tmp0\n    spawnedBotHeroList = botHeroList.filter(lambda x: getNumberOfHeroes(x, Team.2))\n    # botSpawnSelectedHero: selected bot hero after the last use of spawnedBotHeroList.','    # botSpawnSelectedHero: selected bot hero; only inspect existing skins in the non-Smolder branch.');
  replace(f,'core/global_startup.opy','len(spawnedBotHeroList)','len(botHeroList.filter(lambda x: getNumberOfHeroes(x, Team.2)))');
 },
 biowaste_divisor_ternary(f) {
  replace(f,'objective_types/objective_type_biomorphing.opy','    biowasteDepositTimeDivisor = 8.9\n    #Extra points if correct biowaste type\n    if biomorphingGoalQueueList[0] == eventPlayer.biomorphingResourceType:\n        # biowasteDepositTimeDivisor: shorter deposit-time divisor for the requested resource, to award faster progress.\n        biowasteDepositTimeDivisor = 2.9','    # Extra points for the requested type; resolve before damage and retain the snapshot.\n    biowasteDepositTimeDivisor = 2.9 if biomorphingGoalQueueList[0] == eventPlayer.biomorphingResourceType else 8.9');
 },
 swarm_button_snapshot(f) {
  replace(f,'game/global_game_in_progress.opy','    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:\n        eventPlayer.allowButton(Button.SECONDARY_FIRE)\n        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)\n    else:\n        eventPlayer.allowButton(Button.PRIMARY_FIRE)\n        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)','    if eventPlayer.getHero() not in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n        # swarmFireButton: synchronous selection; consumed before any wait or subroutine.\n        #!define swarmFireButton tmp0\n        swarmFireButton = Button.SECONDARY_FIRE if eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN] else Button.PRIMARY_FIRE\n        eventPlayer.allowButton(swarmFireButton)\n        eventPlayer.startForcingButton(swarmFireButton)');
 },
};
const recommended=['spawn_hero_list_inline','reignited_redundant_target_guard'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 await compiler.readyPromise;
 const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30042);assert.deepEqual(baseline.encounteredWarnings,[]);
 const report={baselineRef,compiler:ext,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 const oldGuard=bits=>{const [target,ground,above,below,aim,ultimate]=bits;return target&&((ground&&target&&above&&below&&aim)||ultimate);};
 const newGuard=bits=>{const [target,ground,above,below,aim,ultimate]=bits;return target&&((ground&&above&&below&&aim)||ultimate);};
 const states=Array.from({length:64},(_,n)=>Array.from({length:6},(_,i)=>Boolean(n&(1<<i))));
 for(const state of states)assert.equal(oldGuard(state),newGuard(state));
 // Both the entry predicate and every reevaluation during Abort When False stay equivalent.
 for(const a of states)for(const b of states)assert.equal(oldGuard(a)&&oldGuard(b),newGuard(a)&&newGuard(b));
 report.reignitedGuardTruthCases=states.length;report.abortWaitTransitionCases=states.length**2;
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before)) {
   if(n==='REIGNITED (ANRAN) ABILITIES #1'&&['reignited_redundant_target_guard','combined_recommended'].includes(name)) continue;
   assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  }
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);
  if(['reignited_redundant_target_guard','combined_recommended'].includes(name)) {
   const n='REIGNITED (ANRAN) ABILITIES #1';
   assert.deepEqual(actionList(after[n]),actionList(before[n]));
   assert(after[n].includes('(Event Player).actorTeamSlot5 != Null;'));
   const expression='And(Is On Ground(Event Player), Compare((Event Player).actorTeamSlot5, !=, Null))';
   assert(before[n].includes(expression));assert.equal(after[n],before[n].replace(expression,'Is On Ground(Event Player)'));
   row.reignitedActionsIdentical=true;row.standaloneNullGuardRetained=true;
  }
  if(['spawn_hero_list_inline','combined_recommended'].includes(name)) {
   const n='SPAWN BOTS #1',old=before[n],snapshot='Set Global Variable(tmp0, Filtered Array(Global.botHeroList, Number Of Heroes(Current Array Element, Team 2))); ';
   assert(old.includes(snapshot));assert(old.includes('Count Of(Global.tmp0)'));
   assert.equal(after[n],old.replace(snapshot,'').replace('Count Of(Global.tmp0)','Count Of(Filtered Array(Global.botHeroList, Number Of Heroes(Current Array Element, Team 2)))'));
   row.spawnChangesOnlyFilterEvaluationAndScratchWrite=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30033);assert.deepEqual(r.encounteredWarnings,[]);}
  row.sameVariablesAndRuleSet=true;row.firstVisibleTargetLoopUnchanged=true;
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-17-eighteenth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-eighteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-eighteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
