// Compile candidate changes in memory; never modify gameplay sources or main.ws.txt.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='996bd52dca6bdfcffde6ad39758447422acf655a';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
 execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
 bot_throttle_xz(f) {replace(f,'core/subroutines.opy','distance(eventPlayer, vect(eventPlayer.botTarget.getPosition().x, eventPlayer.getPosition().y, eventPlayer.botTarget.getPosition().z))','magnitude((eventPlayer.getPosition() - eventPlayer.botTarget.getPosition()) * vect(1, 0, 1))');},
 rescue_progress_xz(f) {
  const file='objective_types/objective_type_survivor_rescue.opy';
  const a='distance(vect(currentObjectivePosition.x, eventPlayer.rescueStartPosition.y, currentObjectivePosition.z), eventPlayer.rescueStartPosition)';
  assert.equal(f[file].split(a).length-1,2);
  f[file]=f[file].replaceAll(a,'magnitude((currentObjectivePosition - eventPlayer.rescueStartPosition) * vect(1, 0, 1))');
  replace(f,file,'distance(eventPlayer, vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z))','magnitude((eventPlayer.getPosition() - currentObjectivePosition) * vect(1, 0, 1))');
 },
 boss_distance_branch(f) {replace(f,'core/subroutines.opy','distance(localPlayer, bossesStateList[0]) if bossesStateList != [] else distance(localPlayer, currentObjectivePosition)','distance(localPlayer, bossesStateList[0] if bossesStateList != [] else currentObjectivePosition)');},
 boss_counter_text(f) {replace(f,'core/subroutines.opy','"Objectives Remaining: {0}".format(len(objectivePositionList) - 1) if objectiveTypeSetting != ObjectiveType.BIOMORPHING else "Giant Zombies Remaining: {0}".format(len(objectivePositionList) - 1)',`f"{'Objectives' if objectiveTypeSetting != ObjectiveType.BIOMORPHING else 'Giant Zombies'} Remaining: {len(objectivePositionList) - 1}"`);},
 dash_axis_sign(f) {
  for(const axis of ['x','z']) replace(f,'abilities/augment_dash.opy',`1 if augmentDashDirection.${axis} > 0 else -1 if augmentDashDirection.${axis} < 0 else 0`,`sign(augmentDashDirection.${axis})`);
 },
 dash_axis_normalize(f) {
  for(const axis of ['x','z']) replace(f,'abilities/augment_dash.opy',`1 if augmentDashDirection.${axis} > 0 else -1 if augmentDashDirection.${axis} < 0 else 0`,`normalize(vect(augmentDashDirection.${axis}, 0, 0)).x`);
 },
 rescue_any(f) {replace(f,'objective_types/objective_type_survivor_rescue.opy','playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisibilityCount).any(lambda x: distance(rescueSurvivor, x) < objectiveRad)','playerTargetList.any(lambda x: x != rescueSurvivor and not x.invisibilityCount and distance(rescueSurvivor, x) < objectiveRad)');},
 satellite_any(f) {replace(f,'objective_types/objective_type_satellite_uplink.opy','satelliteTerminalPositionList.filter(lambda _, i: satelliteTerminalProgressList[i] < 100).any(lambda x: distance(x, eventPlayer) < objectiveRad and x.x != null)','satelliteTerminalPositionList.any(lambda x, i: satelliteTerminalProgressList[i] < 100 and distance(x, eventPlayer) < objectiveRad and x.x != null)');},
 revive_any(f) {
  for(const [a,b] of [['distance(x, eventPlayer)','distance(x, eventPlayer)'],['distance(eventPlayer, x)','distance(eventPlayer, x)']])
   replace(f,'game/players_game_in_progress.opy',`playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: ${a} < REVIVE_RADIUS)`,`playerTargetList.any(lambda x: x != eventPlayer and not x.invisibilityCount and ${b} < REVIVE_RADIUS)`);
 },
 spawn_all(f) {replace(f,'game/global_game_in_progress.opy','getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x, attackSpawnRooms[spawnRoomIndex]) > 45)','getPlayers(Team.1).all(lambda x: not x.hasSpawned() or distance(x, attackSpawnRooms[spawnRoomIndex]) > 45)');},
 idle_teleport_all(f) {replace(f,'game/bots_game_in_progress.opy','playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))','playerTargetList.all(lambda x: not x.invisibilityCount or not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))');},
 hidden_teleport_all(f) {replace(f,'game/bots_game_in_progress.opy','playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))','playerTargetList.all(lambda x: not x.isInViewAngle(eventPlayer.botTeleportPosition, 55) or not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))');},
 bot_death_xz(f) {replace(f,'game/bots_game_in_progress.opy','distance(eventPlayer, vect(eventPlayer.botTeleportPosition.x, eventPlayer.getPosition().y, eventPlayer.botTeleportPosition.z))','magnitude((eventPlayer.getPosition() - eventPlayer.botTeleportPosition) * vect(1, 0, 1))');},
 supply_range_map(f) {replace(f,'items/supply_drops.opy','mapGridList.filter(lambda x: distance(supplyDropClosestPlayer, x) < 35 and distance(supplyDropClosestPlayer, x) > 20)','mapGridList.filter(lambda x: [distance(supplyDropClosestPlayer, x)].any(lambda d: d < 35 and d > 20))');},
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files),baseRules=rules(baseline.result);
 const report={compiler:ext,baselineRef,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,results:[]};
 // Exhaustive predicate fusion models, including empty arrays and every acceptance mask.
 let cases=0;
 for(let n=0;n<=6;n++) for(let p=0;p<1<<n;p++) for(let q=0;q<1<<n;q++) {
  const a=Array.from({length:n},(_,i)=>i),P=i=>!!(p&(1<<i)),Q=i=>!!(q&(1<<i));
  assert.equal(a.filter(P).some(Q),a.some(i=>P(i)&&Q(i)));
  assert.equal(a.filter(P).every(Q),a.every(i=>!P(i)||Q(i)));
  cases++;
 }
 report.predicateModelCases=cases;
 // Check the coordinate substitution without changing the progress arithmetic.
 let seed=20261117,geometryCases=0;
 const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296*2000-1000;};
 const distance=(a,b)=>Math.sqrt(a.reduce((s,v,i)=>s+(v-b[i])**2,0));
 for(let i=0;i<10000;i++) {
  const a=[random(),random(),random()],b=[random(),random(),random()];
  if(i<5) {a[0]=b[0]+[0,2,10,10-1e-9,10+1e-9][i];a[2]=b[2];}
  const before=distance(a,[b[0],a[1],b[2]]),after=distance(a.map((v,j)=>(v-b[j])*(j===1?0:1)),[0,0,0]);
  assert.equal(before,after);
  for(const threshold of [0,0.25,2,10,45]) {assert.equal(before<threshold,after<threshold);assert.equal(before>threshold,after>threshold);}
  geometryCases++;
 }
 report.geometryModelCases=geometryCases;
 candidates.combined_recommended=f=>{for(const n of ['bot_throttle_xz','rescue_progress_xz','boss_distance_branch','bot_death_xz']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline,predicateModelCases:cases}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);
   const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,baseline.nbElements-19);assert.deepEqual(r.encounteredWarnings,[]);
    const declarations=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];
    assert(declarations(baseline.result));
    assert.equal(declarations(r.result),declarations(baseline.result));
    assert.deepEqual(changedRules.slice().sort(),['BOT DIES #1','INITIALIZE SURVIVOR TO BE RESCUED #1','objectivesManagement #1','restoreDefaultFacingMovement #1'].sort());
    for(const n of changedRules) assert.equal(next[n].match(/conditions \{.*?\}/)?.[0],baseRules[n].match(/conditions \{.*?\}/)?.[0]);
    row.sameDeclarationsAndConditions=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));
   fs.writeFileSync(path.join(__dirname,'2026-11-17-ninth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-ninth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-ninth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
