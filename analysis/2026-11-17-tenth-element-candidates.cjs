// Read-only experiments against the post-ninth-pass baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='2a9a9272850675cb507ef8f65a03616b936b90a3';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
 behemoth_gas_xz(f) {replace(f,'game/zombie_types.opy','distance(behemothGasCloudPosition, vect(x.getEyePosition().x, behemothGasCloudPosition.y, x.getEyePosition().z))','magnitude((behemothGasCloudPosition - x.getEyePosition()) * vect(1, 0, 1))');},
 slimer_eye_offset(f) {
  const a='eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.sizeScale if eventPlayer.isInAir() else eventPlayer.getEyePosition()';
  const b='eventPlayer.getEyePosition() + offsetUpHalfConst * (eventPlayer.sizeScale if eventPlayer.isInAir() else 0)';
  let uses=0;
  for(const file of ['game/zombie_types.opy','core/subroutines.opy']) {uses+=f[file].split(a).length-1;f[file]=f[file].replaceAll(a,b);}
  assert.equal(uses,4);
 },
 smolder_native_heroes(f) {replace(f,'game/zombie_types.opy','(getPlayers(Team.2).filter(lambda player: player.getHero() == Hero.WINSTON)).setUltCharge(100)','getPlayersOnHero(Hero.WINSTON, Team.2).setUltCharge(100)');},
 player_icon_common_call(f) {replace(f,'game/players_game_in_progress.opy','heroIcon(Hero.WINSTON) if isSmolderEventActive else heroIcon(eventPlayer.getHeroOfDuplication()) if eventPlayer.isDuplicatingAHero() else heroIcon(eventPlayer.getHero())','heroIcon(Hero.WINSTON if isSmolderEventActive else eventPlayer.getHeroOfDuplication() if eventPlayer.isDuplicatingAHero() else eventPlayer.getHero())');},
 killzone_square_abs(f) {
  const file='core/subroutines.opy',a='sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - killZoneCenter.y)) ** 2))';
  assert.equal(f[file].split(a).length-1,2);
  f[file]=f[file].replaceAll(a,'sqrt(objectiveRad ** 2 - ((localPlayer.getPosition().y - killZoneCenter.y) ** 2))');
 },
 bot_damage_percent(f) {replace(f,'core/subroutines.opy','eventPlayer.setDamageDealt(botDamageDealtList[botStatHeroIndex] / 100 * 100)','eventPlayer.setDamageDealt(botDamageDealtList[botStatHeroIndex])');},
 bot_stats_switch(f) {
  const file='core/subroutines.opy',start=f[file].indexOf('    if eventPlayer.getHero() == Hero.REINHARDT:\n'),end=f[file].indexOf('\n\n\nmacro mutationsMacro():',start);
  assert(start>=0&&end>start);const block=f[file].slice(start,end),lines=block.split('\n');
  let result='    switch eventPlayer.getHero():\n',cases=0;
  for(const line of lines) {
   const m=line.match(/^    (?:if|elif) eventPlayer\.getHero\(\) (== Hero\.\w+|in \[Hero\.ANA, Hero\.KIRIKO\]):$/);
   if(m) {
    if(cases) result+='            break\n';
    result+=m[1].startsWith('== ')?'        case '+m[1].slice(3)+':\n':'        case Hero.ANA:\n        case Hero.KIRIKO:\n';cases++;
   }else result+='    '+line+'\n';
  }
  assert.equal(cases,9);result+='            break';
  f[file]=f[file].slice(0,start)+result+f[file].slice(end);
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30135);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 // Models validate formula substitution; they do not emulate the Workshop engine.
 let seed=170011,geometryCases=0,offsetCases=0;
 const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296*2000-1000;};
 const length=v=>Math.sqrt(v.reduce((s,x)=>s+x*x,0));
 for(let i=0;i<10000;i++) {
  const cloud=[random(),random(),random()],eye=[random(),random(),random()];
  if(i<4) {eye[0]=cloud[0]+[0,6,6-1e-9,6+1e-9][i];eye[2]=cloud[2];}
  const before=length([cloud[0]-eye[0],0,cloud[2]-eye[2]]),after=length(cloud.map((v,j)=>(v-eye[j])*(j===1?0:1)));
  assert.equal(before,after);
  const dy=eye[1]-cloud[1];assert.equal(Math.abs(dy)**2,dy**2);geometryCases++;
  for(const air of [false,true]) for(const size of [0,0.7,1,1.55,2.5,10]) {
   const old=air?eye.map((v,j)=>v+(j===1?0.5*size:0)):eye;
   const next=eye.map((v,j)=>v+(j===1?0.5:0)*(air?size:0));
   assert.deepEqual(old,next);offsetCases++;
  }
 }
 report.geometryModelCases=geometryCases;report.offsetModelCases=offsetCases;
 let iconCases=0;
 for(const smolder of [false,true]) for(const duplicating of [false,true]) for(const hero of ['Winston','Mercy','Echo']) for(const duplicated of ['Ana','Winston','Roadhog']) {
  const icon=h=>'icon:'+h;
  assert.equal(smolder?icon('Winston'):duplicating?icon(duplicated):icon(hero),icon(smolder?'Winston':duplicating?duplicated:hero));iconCases++;
 }
 report.iconModelCases=iconCases;
 const numericSource=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'});
 const tables=[...numericSource.matchAll(/offset: "(NL_DAMAGE_DEALT_\w+_OFFSET)",[\s\S]*?list: \[([^\]]+)\]/g)].map(m=>({name:m[1],values:m[2].split(',').filter(x=>x.trim()).map(Number)}));
 assert.equal(tables.length,5);
 report.damagePercentRoundingAudit={entries:tables.reduce((n,t)=>n+t.values.length,0),float64Differences:[],float32Differences:[]};
 for(const t of tables) for(const value of t.values) {
  const old=value/100*100;
  if(old!==value) report.damagePercentRoundingAudit.float64Differences.push({table:t.name,value,before:old,after:value});
  const old32=Math.fround(Math.fround(Math.fround(value)/100)*100);
  if(old32!==Math.fround(value)) report.damagePercentRoundingAudit.float32Differences.push({table:t.name,value,before:old32,after:Math.fround(value)});
 }
 candidates.combined_recommended=f=>{for(const n of ['behemoth_gas_xz','slimer_eye_offset','player_icon_common_call','killzone_square_abs']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline,damagePercentRoundingAudit:report.damagePercentRoundingAudit}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30124);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(row.changedRules.slice().sort(),['BEHEMOTH GAS STREAM (BOSS) #1','botRespawnInitialization #1','SLIMER (MERCY) TENTACLE GRAB #1','EFFECTS/TEXTS #3','objectivesManagement #1'].sort());
    for(const n of row.changedRules) assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
    row.sameDeclarationsAndConditions=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-tenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-tenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-tenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
