const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {candidates,files,baselineRef}=require('./2026-11-17-twelfth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function rules(s) {
 const counts={};
 return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
  const name=x.match(/^rule \("(.*)"\)/)[1],id=counts[name]=(counts[name]||0)+1;
  return [name+' #'+id,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
 }));
}
(async()=>{
 const expectedSources={...files};
 for(const n of ['remove_unused_teleport_status','inline_drop_finish','ammo_previous_clip_snapshot']) candidates[n](expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 // Validate all target files before applying the reviewed substitutions.
 for(const n of changedFiles) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply')) assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidate: ${n}`);
 }
 if(process.argv.includes('--apply')) for(const n of changedFiles) {
  const target=path.join('src',n),current=fs.readFileSync(target,'utf8');
  fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);
 }
 await compiler.readyPromise;
 const r=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(r.nbElements,30092);assert.deepEqual(r.encounteredWarnings,[]);
 const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-twelfth-probe-combined_recommended.ws.txt'),'utf8'));
 const actual=rules(r.result);
 assert(Object.keys(actual).length>100);assert.deepEqual(actual,expected,'Executable rules must match the measured candidate');
 const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-twelfth-probe-baseline.ws.txt'),'utf8'),before=rules(baseline);
 const removedSubroutines=Object.keys(before).filter(n=>!Object.hasOwn(actual,n)).sort();
 assert.deepEqual(removedSubroutines,['finishPowerUpDrop #1','successfulTeleportStatus #1'].sort());
 assert.equal(Object.keys(actual).length,Object.keys(before).length-2);
 const changedRules=[...new Set([...Object.keys(before),...Object.keys(actual)])].filter(n=>before[n]!==actual[n]).sort();
 assert.deepEqual(changedRules,['AMMO PACK REFILL FALLBACK #1','dropCarriedPowerUps #1','finishPowerUpDrop #1','successfulTeleportStatus #1'].sort());
 const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline));assert.equal(variables(r.result),variables(baseline));
 for(const n of Object.keys(actual)) assert.equal(actual[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 const dropFinish=before['finishPowerUpDrop #1'].match(/ actions \{ (.*?) \} \}$/)?.[1];assert(dropFinish);
 assert.equal(actual['dropCarriedPowerUps #1'],before['dropCarriedPowerUps #1'].replace('Call Subroutine(finishPowerUpDrop);',dropFinish));
 const ammoSource=fs.readFileSync('src/abilities/augments.opy','utf8');
 assert.equal(ammoSource.split('eventPlayer.getAmmo(augmentAmmoFallbackClipIndex)').length-1,4);
 fs.writeFileSync('main.ws.txt',r.result);
 const report={compiler:ext,baselineRef,baseline:30104,elements:r.nbElements,saved:30104-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsUnchanged:true,remainingConditionsUnchanged:true,inlineDropFinishPreservesActions:true,changedFiles,removedSubroutines,changedRules,inGameValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-17-twelfth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
