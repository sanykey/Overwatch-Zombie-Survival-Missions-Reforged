const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {candidates,files,baselineRef}=require('./2026-11-17-fifteenth-element-candidates.cjs');
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
 for(const n of ['dash_sign_boolean_difference','dash_zero_vector_false_compare']) candidates[n](expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 assert.deepEqual(changedFiles,['abilities/augment_dash.opy']);
 // Preserve unrelated edits and the source file's existing line endings.
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
 assert.equal(r.nbElements,30067);assert.deepEqual(r.encounteredWarnings,[]);
 const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-fifteenth-probe-combined_recommended.ws.txt'),'utf8'));
 const actual=rules(r.result);
 assert(Object.keys(actual).length>100);assert.deepEqual(actual,expected,'Executable rules must match the audited candidate');
 const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-fifteenth-probe-baseline.ws.txt'),'utf8'),before=rules(baseline);
 assert.deepEqual(Object.keys(actual),Object.keys(before));
 const changedRules=Object.keys(actual).filter(n=>before[n]!==actual[n]);assert.deepEqual(changedRules,['useAugmentAirAction #1']);
 const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline));assert.equal(variables(r.result),variables(baseline));
 for(const n of Object.keys(actual)) assert.equal(actual[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 const air=actual['useAugmentAirAction #1'];
 assert(air.includes('Vector(Subtract(Compare(X Component Of(Global.tmp0), >, Null), Compare(X Component Of(Global.tmp0), <, Null)), False, Subtract(Compare(Z Component Of(Global.tmp0), >, Null), Compare(Z Component Of(Global.tmp0), <, Null)))'));
 assert(air.includes('Skip If(Compare(Global.tmp0, ==, False), True);'));assert(!air.includes('Normalize('));
 assert.equal(actual['selectTarget #1'],before['selectTarget #1']);assert.equal(actual['applyDamageReceivedModifier #1'],before['applyDamageReceivedModifier #1']);
 fs.writeFileSync('main.ws.txt',r.result);
 const report={compiler:ext,baselineRef,baseline:30081,elements:r.nbElements,saved:30081-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variablesRulesAndConditionsUnchanged:true,explicitFalseComparisonInCompiledGate:true,noNormalizationOrDivisionAdded:true,firstVisibleTargetLoopUnchanged:true,damageReceivedModifierUnchanged:true,changedFiles,changedRules,inGameValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-17-fifteenth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
