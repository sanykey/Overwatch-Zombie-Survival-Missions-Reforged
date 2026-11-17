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
 shared_placement_windup_feedback(f) {
  const first='playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, COLOR, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)';
  const second='playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, COLOR, eventPlayer.getPosition(), 75)';
  for(const [file,color] of [['abilities/enhancement_charge_battery.opy','YELLOW'],['abilities/augment_laser_barricade.opy','BLUE']]) {
   replace(f,file,'    '+first.replaceAll('COLOR','Color.'+color)+'\n    '+second.replaceAll('COLOR','Color.'+color),'    # Synchronous feedback color; consumed by both Play Effects before the next wait.\n    placementWindupColor = Color.'+color+'\n    playPlacementWindupFeedback()');
  }
  const core='core/subroutines.opy';assert(/^#!mainFile [^\n]+\n/m.test(f[core]));f[core]=f[core].replace(/^(#!mainFile [^\n]+\n)/m,'$1\nsubroutine playPlacementWindupFeedback\n');
  f[core]+='\n\n# Synchronous placement-feedback input: tmp0 is dead before the caller\'s next wait.\n#!define placementWindupColor tmp0\n\ndef playPlacementWindupFeedback():\n    @Name "playPlacementWindupFeedback"\n    # Preserve the two random draws and their order; no waits/calls or live captures.\n    '+first.replaceAll('COLOR','placementWindupColor')+'\n    '+second.replaceAll('COLOR','placementWindupColor')+'\n';
 },
 hitchhiker_boolean_interrupt_array(f) {
  replace(f,'abilities/enhancements.opy','(not eventPlayer.hasSpawned() or not eventPlayer.enhancementHitchhikerCarrier.hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementHitchhikerCarrier.isDead() or not entityExists(eventPlayer.enhancementHitchhikerCarrier) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementHitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer, eventPlayer.enhancementHitchhikerCarrier) > 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale)','([not eventPlayer.hasSpawned(), not eventPlayer.enhancementHitchhikerCarrier.hasSpawned(), eventPlayer.isDead(), eventPlayer.enhancementHitchhikerCarrier.isDead(), not entityExists(eventPlayer.enhancementHitchhikerCarrier), eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.enhancementHitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN), distance(eventPlayer, eventPlayer.enhancementHitchhikerCarrier) > 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale].any())');
 },
 movement_augment_membership(f) {
  replace(f,'abilities/augments.opy','uiPhaseAndId(eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER or eventPlayer.augmentId == Augment.APOTHECARY)','uiPhaseAndId(eventPlayer.augmentId in [Augment.GRAPNEL_LAUNCHER, Augment.APOTHECARY])');
 },
};
const recommended=['shared_placement_windup_feedback'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,29954);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1']){assert(before[n]);assert.equal(after[n],before[n]);}
  assert.deepEqual(nestedPredicates(r.result),[]);row.noNestedArrayPredicates=true;row.variablesAndProtectedRulesUnchanged=true;
  if(['shared_placement_windup_feedback','combined_recommended'].includes(name)) {
   const helper='playPlacementWindupFeedback',helperRule=helper+' #1';assert(helper.length<=31);assert(after[helperRule]);
   const body=actionList(after[helperRule]);assert.equal(body.length,2);assert(body.every(a=>a.startsWith('Play Effect(')));
   assert.equal((body.join(' ').match(/Random Real\(/g)||[]).length,2);
   assert.equal((body.join(' ').match(/Global\.tmp0/g)||[]).length,2);
   for(const [n,color] of [['[CHARGE_BATTERY] PLACE BATTERY #1','Yellow'],['CROUCH + INTERACT (LASER BARRICADE) #1','Blue']]) {
    const input=`Set Global Variable(tmp0, Color(${color}));`;assert(after[n].includes(input));
    const drop=after[n].replace(input,'Call Subroutine(dropPlacementInput);');
    const bodies={dropPlacementInput:[],[helper]:body.map(a=>a.replaceAll('Global.tmp0',`Color(${color})`))};
    assert.deepEqual(expandedActions(drop,bodies),expandedActions(before[n]),'Native actions and jump targets must match, including random draws: '+n);
   }
   const added=Object.keys(after).filter(n=>!Object.hasOwn(before,n));assert.deepEqual(added,[helperRule]);
   for(const n of Object.keys(before)){assert(after[n]);assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
   assert.deepEqual(row.changedRules.slice().sort(),['[CHARGE_BATTERY] PLACE BATTERY #1','CROUCH + INTERACT (LASER BARRICADE) #1',helperRule].sort());
   row.helperExpansionPreservesColorsActionsJumpsAndRandomDraws=true;row.allExistingConditionsUnchanged=true;row.addedSubroutines=added;
   assert.equal(r.nbElements,29932);assert.deepEqual(r.encounteredWarnings,[]);
  }
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-eighth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-eighth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-eighth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
