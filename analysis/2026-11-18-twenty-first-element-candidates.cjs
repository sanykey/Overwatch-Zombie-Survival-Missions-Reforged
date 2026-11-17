// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const {expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
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
 battle_common_charge_label(f) {
  candidates.battle_common_charge_decrement(f);
  replace(f,'abilities/enhancements.opy','    if not eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):\n        if eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) <= 0.5:\n            return\n        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)\n    eventPlayer.enhancementBattleResetCharges -= 1','    if eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):\n        goto lbl_consume_battle_reset\n    if eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) <= 0.5:\n        return\n    eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)\n    lbl_consume_battle_reset:\n    eventPlayer.enhancementBattleResetCharges -= 1');
 },
 battle_common_charge_decrement(f) {
  replace(f,'abilities/enhancements.opy','    #If the ability charge increased\n    if eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):\n        eventPlayer.enhancementBattleResetCharges -= 1\n    #Else if ability is on cooldown\n    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) > 0.5:\n        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)\n        eventPlayer.enhancementBattleResetCharges -= 1','    # A charge consumes one reset; otherwise only a cooldown above 0.5 is reset.\n    if not eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):\n        if eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) <= 0.5:\n            return\n        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)\n    eventPlayer.enhancementBattleResetCharges -= 1');
 },
 supply_landing_single_assignment(f) {
  replace(f,'items/supply_drops.opy','            #Sets supply drop location\n            supplyDropLandingPosition = supplyDropCandidatePosition\n            #Sets supply drop location to be placed on ground (in the case that a walkable position is underground for some reason)\n            supplyDropLandingPosition = raycastHitPosition(supplyDropLandingPosition + 2 * Vector.UP, supplyDropLandingPosition + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)','            # Ground the selected candidate before publishing the landing position.\n            # The candidate is synchronous tmp1 input; raycast does not retain it.\n            supplyDropLandingPosition = raycastHitPosition(supplyDropCandidatePosition + 2 * Vector.UP, supplyDropCandidatePosition + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)');
 },
 boss_remaining_common_format(f) {
  replace(f,'core/subroutines.opy','"Objectives Remaining: {0}".format(len(objectivePositionList) - 1) if objectiveTypeSetting != ObjectiveType.BIOMORPHING else "Giant Zombies Remaining: {0}".format(len(objectivePositionList) - 1)',`f"{'Objectives' if objectiveTypeSetting != ObjectiveType.BIOMORPHING else 'Giant Zombies'} Remaining: {len(objectivePositionList) - 1}"`);
 },
 revive_common_format(f) {
  replace(f,'game/players_game_in_progress.opy','"Reviving: {0}s".format(ceil(eventPlayer.reviveTimeRemaining)) if eventPlayer.isReviving else "Revive: {0}s".format(ceil(eventPlayer.rescueTimeRemaining))',`f"{'Reviving' if eventPlayer.isReviving else 'Revive'}: {ceil(eventPlayer.reviveTimeRemaining if eventPlayer.isReviving else eventPlayer.rescueTimeRemaining)}s"`);
 },
};
const recommended=['supply_landing_single_assignment'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,30019);assert.deepEqual(baseline.encounteredWarnings,[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  assert.equal(after['selectTarget #1'],before['selectTarget #1']);row.variablesRulesConditionsAndSelectTargetUnchanged=true;
  if(['supply_landing_single_assignment','combined_recommended'].includes(name)) {
   const n='GENERATE SUPPLY DROPS #1',write='Set Global Variable(supplyDropLandingPosition, Global.tmp1);';
   const ray='Ray Cast Hit Position(Add(Global.supplyDropLandingPosition, Multiply(2, Up)), Global.supplyDropLandingPosition, All Players(All Teams), All Players(All Teams), False)';
   assert(before[n].includes(write));assert(before[n].includes(ray));
   const expected=before[n].replace(write,'Call Subroutine(removedWrite);').replace(ray,ray.replaceAll('Global.supplyDropLandingPosition','Global.tmp1'));
   assert.deepEqual(expandedActions(expected,{removedWrite:[]}),expandedActions(after[n]));
   row.sameRayInputsAndRemainingActionsAfterSkipRebasing=true;
  }
  if(name==='combined_recommended'){assert.equal(r.nbElements,30017);assert.deepEqual(r.encounteredWarnings,[]);}
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-first-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-first-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-first-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
