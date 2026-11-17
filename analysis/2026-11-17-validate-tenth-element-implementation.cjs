const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {candidates,files,baselineRef}=require('./2026-11-17-tenth-element-candidates.cjs');
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
 for(const n of ['behemoth_gas_xz','slimer_eye_offset','player_icon_common_call','killzone_square_abs']) candidates[n](expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 // Refuse to overwrite unreviewed source changes; retain existing line endings.
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
 assert.equal(r.nbElements,30124);assert.deepEqual(r.encounteredWarnings,[]);
 const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-tenth-probe-combined_recommended.ws.txt'),'utf8'));
 const actual=rules(r.result);
 assert(Object.keys(actual).length>100);assert.deepEqual(actual,expected,'Executable rules must match the measured candidate');
 const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-tenth-probe-baseline.ws.txt'),'utf8'),before=rules(baseline);
 const changedRules=[...new Set([...Object.keys(before),...Object.keys(actual)])].filter(n=>before[n]!==actual[n]).sort();
 assert.deepEqual(changedRules,['BEHEMOTH GAS STREAM (BOSS) #1','botRespawnInitialization #1','SLIMER (MERCY) TENTACLE GRAB #1','EFFECTS/TEXTS #3','objectivesManagement #1'].sort());
 const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline));assert.equal(variables(r.result),variables(baseline));
 for(const n of changedRules) assert.equal(actual[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 fs.writeFileSync('main.ws.txt',r.result);
 const report={compiler:ext,baselineRef,baseline:30135,elements:r.nbElements,saved:30135-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsUnchanged:true,conditionsUnchanged:true,changedFiles,changedRules,inGameValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-17-tenth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
