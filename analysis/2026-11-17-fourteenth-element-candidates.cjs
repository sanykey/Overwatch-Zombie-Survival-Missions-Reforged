// Read-only candidate measurements; gameplay files remain untouched.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='47b34eb31a984493f6720e483d80ac50903fb159';
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
 hitchhiker_health_owner_snapshot(f) {
  const file='abilities/enhancements.opy',start=f[file].indexOf('    # hitchhikerHealthTransferAmount:'),end=f[file].indexOf('    hitchhikerHealthRecipient.setHealth(',start);assert(start>=0&&end>start);
  let b=f[file].slice(start,end);assert.equal(b.split('eventPlayer.enhancementHitchhikerCarrier').length-1,5);b=b.replaceAll('eventPlayer.enhancementHitchhikerCarrier','hitchhikerHealthCarrier');
  f[file]=f[file].slice(0,start)+'    # Carrier reference is synchronous through donor selection; tmp3 is dead before either Set Health.\n    #!define hitchhikerHealthCarrier tmp3\n    hitchhikerHealthCarrier = eventPlayer.enhancementHitchhikerCarrier\n'+b+f[file].slice(end);
 },
 engineer_shared_armor_grant(f) {
  replace(f,'abilities/enhancements.opy','    scrapArmorGrantTarget.addHealthPool(Health.ARMOR, min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount), false, false)\n    scrapArmorGrantTarget.scrapArmorAmount = min(ENGINEER_ARMOR_MAX, scrapArmorGrantTarget.scrapArmorAmount + ENGINEER_ARMOR_STACK)',
   '    # Payment is complete: reuse tmp0 for the grant, consumed before messages/beam work or waits.\n    # Both Add Health Pool reevaluation/recovery flags stay false.\n    #!define scrapArmorGrantAmount tmp0\n    scrapArmorGrantAmount = min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount)\n    scrapArmorGrantTarget.addHealthPool(Health.ARMOR, scrapArmorGrantAmount, false, false)\n    scrapArmorGrantTarget.scrapArmorAmount += scrapArmorGrantAmount');
 },
 singleton_hero_comparisons(f) {
  const file='game/global_game_in_progress.opy';
  for(const hero of ['MERCY','SYMMETRA']) replace(f,file,'eventPlayer.getHero() in [Hero.'+hero+']','eventPlayer.getHero() == Hero.'+hero);
 },
 pull_center_rows(f) {
  replace(f,'core/subroutines.opy','sorted(pullAimCandidates.filter(lambda target: distance(pullAimOrigin, augmentGrapnelCenter(target)) <= pullAimRange and isInLoS(pullAimOrigin, augmentGrapnelCenter(target))), lambda target: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(pullAimEyePosition, augmentGrapnelCenter(target))))[0]',
   'sorted(pullAimCandidates.map(lambda target: [target, augmentGrapnelCenter(target)]).filter(lambda row: distance(pullAimOrigin, row[1]) <= pullAimRange and isInLoS(pullAimOrigin, row[1])), lambda row: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(pullAimEyePosition, row[1])))[0][0]');
 },
 stun_beam_origin_map(f) {
  replace(f,'items/supply_drops.opy','eventPlayer.powerUpStunBeamPosition + ((directionTowards(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)) * (min(3, distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst))))',
   '[eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst].map(lambda origin: eventPlayer.powerUpStunBeamPosition + directionTowards(eventPlayer.powerUpStunBeamPosition, origin) * min(3, distance(eventPlayer.powerUpStunBeamPosition, origin)))[0]');
 },
 stun_beam_position_map(f) {
  replace(f,'items/supply_drops.opy','eventPlayer.powerUpStunBeamPosition + ((directionTowards(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)) * (min(3, distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst))))',
   '[eventPlayer.powerUpStunBeamPosition].map(lambda lead: lead + directionTowards(lead, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst) * min(3, distance(lead, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)))[0]');
 },
 mutation_size_branches(f) {
  const file='core/subroutines.opy',start=f[file].indexOf('        #Size Growth\n'),end=f[file].indexOf('        #Radioactive\n',start);assert(start>=0&&end>start);
  f[file]=f[file].slice(0,start)+'        # Size Growth and Size Reduction share the same health update.\n        elif eventPlayer.botMutationId in [2, 3]:\n            eventPlayer.sizeScale *= 1.5 if eventPlayer.botMutationId == 2 else 0.6\n            eventPlayer.botBaseHealth *= eventPlayer.sizeScale\n            botMutationOutlineColor = Color.VIOLET if eventPlayer.botMutationId == 2 else Color.ROSE\n'+f[file].slice(end);
 },
 dash_protection_snapshot(f) {
  const file='abilities/hero_tuning.opy',predicate='eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null';
  const start=f[file].indexOf('def applyDamageReceivedModifier():'),end=f[file].indexOf('\n\nrule ',start);assert(start>=0&&end>start);
  let b=f[file].slice(start,end);assert.equal(b.split(predicate).length-1,2);b=b.replaceAll(predicate,'damageReceivedDashActive');
  const anchor='    eventPlayer.isDotProtected = ';assert(b.includes(anchor));
  b=b.replace(anchor,'    # Synchronous tmp1 output; preserve tmp0 for the caller\'s Dash direction.\n    #!define damageReceivedDashActive tmp1\n    damageReceivedDashActive = '+predicate+'\n'+anchor);
  f[file]=f[file].slice(0,start)+b+f[file].slice(end);
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30090);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 let seed=14017,armorCases=0,stunCases=0;
 const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296;};
 const amounts=[0,1,74,75,124.999999,125,125.000001,199,199.999999,200];
 for(let i=0;i<20000;i++) amounts.push(random()*200);
 for(const amount of amounts) {
  const grant=Math.min(75,200-amount),oldLedger=Math.min(200,amount+75),newLedger=amount+grant;
  assert.equal(oldLedger,newLedger);
  const a32=Math.fround(amount),grant32=Math.min(75,Math.fround(200-a32));
  assert.equal(Math.min(200,Math.fround(a32+75)),Math.fround(a32+grant32));armorCases++;
 }
 for(let i=0;i<10000;i++) {
  const lead=[random()*1000,random()*1000,random()*1000],body=[random()*1000,random()*1000,random()*1000];
  const origin=()=>body.map((v,j)=>v+(j===1?1.2:0));if(i===0) {body.fill(0);lead.splice(0,3,...origin());}
  const evaluate=bind=>{
   const calls=[];
   const dist=(a,b)=>{calls.push(['distance',a,b]);return Math.hypot(...a.map((v,j)=>v-b[j]));};
   const dir=(a,b)=>{calls.push(['direction',a,b]);const delta=b.map((v,j)=>v-a[j]),len=Math.hypot(...delta);return len?delta.map(v=>v/len):[0,0,0];};
   const add=(a,b)=>a.map((v,j)=>v+b[j]),scale=(v,s)=>v.map(x=>x*s);
   const value=bind?[origin()].map(o=>add(lead,scale(dir(lead,o),Math.min(3,dist(lead,o)))))[0]:add(lead,scale(dir(lead,origin()),Math.min(3,dist(lead,origin()))));
   return {value,calls};
  };
  assert.deepEqual(evaluate(false),evaluate(true));stunCases++;
 }
 report.armorLedgerModelCases=armorCases;report.stunBeamModelCases=stunCases;
 candidates.combined_recommended=f=>{for(const n of ['hitchhiker_health_owner_snapshot','engineer_shared_armor_grant','stun_beam_origin_map']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30081);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(Object.keys(after),Object.keys(before));
    for(const n of Object.keys(before)) assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
    assert.equal(after['selectTarget #1'],before['selectTarget #1']);
    assert.equal(after['applyDamageReceivedModifier #1'],before['applyDamageReceivedModifier #1']);
    assert.deepEqual(row.changedRules.slice().sort(),['HITCHHIKER LIFEBONDS #1','ENGINEER ARMOR TRANSFER #1','stun (100-109) #1'].sort());
    assert(after['ENGINEER ARMOR TRANSFER #1'].includes('Add Health Pool To Player(Global.tmp1, Armor, Global.tmp0, False, False);'));
    assert(after['stun (100-109) #1'].includes('Mapped Array(Array('));
    const life=f['abilities/enhancements.opy'],start=life.indexOf('    hitchhikerHealthRecipient.setHealth('),end=life.indexOf('\n\nrule "P.U.P.',start);
    assert(start>=0&&end>start);assert(!life.slice(start,end).includes('hitchhikerHealthCarrier'));
    row.sameVariablesRulesAndConditions=true;row.firstVisibleTargetLoopUnchanged=true;row.healthPoolFlagsUnchanged=true;row.hitchhikerSnapshotDeadBeforeSetHealth=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-fourteenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-fourteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-fourteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
