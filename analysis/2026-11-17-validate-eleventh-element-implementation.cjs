const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {candidates,files,baselineRef}=require('./2026-11-17-eleventh-element-candidates.cjs');
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
 for(const n of ['turret_barrel_scale','hitchhiker_attachment_scale','collision_native_then_flag','begin_throttle_override','clear_movement_overrides','boost_movement_speed','detach_tracked_target']) candidates[n](expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 // Validate every target before writing; retain line endings and unrelated files.
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
 assert.equal(r.nbElements,30104);assert.deepEqual(r.encounteredWarnings,[]);
 const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-eleventh-probe-combined_recommended.ws.txt'),'utf8'));
 const actual=rules(r.result);
 assert(Object.keys(actual).length>100);assert.deepEqual(actual,expected,'Executable rules must match the audited candidate including Skip targets');
 const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-eleventh-probe-baseline.ws.txt'),'utf8'),before=rules(baseline);
 const addedSubroutines=Object.keys(actual).filter(n=>!Object.hasOwn(before,n)).sort();
 assert.deepEqual(addedSubroutines,['enableBotCollisionAndFlag #1','beginBotThrottleOverride #1','clearBotMovementOverrides #1','boostMovementSpeed #1','detachTrackedAbilityTarget #1'].sort());
 for(const n of addedSubroutines) {assert(n.slice(0,-3).length<=31);assert(actual[n].includes('event { Subroutine;'));}
 const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline));assert.equal(variables(r.result),variables(baseline));
 for(const n of Object.keys(before)) {assert(actual[n]);assert.equal(actual[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
 const audit=JSON.parse(fs.readFileSync(path.join(__dirname,'2026-11-17-eleventh-element-candidates.json'),'utf8')).results.find(row=>row.name==='combined_recommended');
 assert.equal(audit.elements,r.nbElements);assert(audit.helperExpansionRestoresOriginalActions);
 fs.writeFileSync('main.ws.txt',r.result);
 const changedRules=Object.keys(actual).filter(n=>before[n]!==actual[n]).sort();
 const report={compiler:ext,baselineRef,baseline:30124,elements:r.nbElements,saved:30124-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsUnchanged:true,existingConditionsUnchanged:true,helperExpansionCheckedInCandidateAudit:true,changedFiles,addedSubroutines,changedRules,inGameValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-17-eleventh-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
