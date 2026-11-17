const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-nineteenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
(async()=>{
 const expectedSources={...files};candidates.combined_recommended(expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 for(const n of Object.keys(files)) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply'))assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidate: ${n}`);
 }
 if(process.argv.includes('--apply'))for(const n of changedFiles) {
  const target=path.join('src',n),current=fs.readFileSync(target,'utf8');
  fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);
 }
 await compiler.readyPromise;
 const expected=await compile(expectedSources),baseline=await compile(files);
 assert.equal(baseline.nbElements,30033);assert.equal(expected.nbElements,30023);
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,30023);assert.deepEqual(actual.encounteredWarnings,[]);
 assert.deepEqual(rules(actual.result),rules(expected.result),'Compiled rules must match reviewed candidate');
 const before=rules(baseline.result),after=rules(actual.result);
 assert.deepEqual(Object.keys(after),Object.keys(before));
 const changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);
 assert.deepEqual(changedRules.slice().sort(),['setObjectiveType #1','playerForceField (10-19) #1'].sort());
 for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 assert.equal(after['selectTarget #1'],before['selectTarget #1']);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:30033,elements:actual.nbElements,saved:10,warnings:actual.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsAndConditionsUnchanged:true,firstVisibleTargetLoopUnchanged:true,changedFiles,changedRules,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-nineteenth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
