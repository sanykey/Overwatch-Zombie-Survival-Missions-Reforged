const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-twenty-third-element-candidates.cjs');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
(async()=>{
 selfTest();const expectedSources={...files};candidates.combined_recommended(expectedSources);
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
 assert.equal(baseline.nbElements,30011);assert.equal(expected.nbElements,30004);
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,30004);assert.deepEqual(actual.encounteredWarnings,[]);
 assert.deepEqual(rules(actual.result),rules(expected.result),'Compiled rules must match reviewed candidates');
 assert.deepEqual(nestedPredicates(actual.result),[]);
 const before=rules(baseline.result),after=rules(actual.result);
 assert.deepEqual(Object.keys(after),Object.keys(before));
 const changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);
 assert.deepEqual(changedRules.slice().sort(),['BLASTER ROCKET HITS TARGET #1','KEVLAR RANGED DAMAGE COMPENSATION #1','PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP) #1'].sort());
 for(const n of Object.keys(before))if(n!=='BLASTER ROCKET HITS TARGET #1')assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1'])assert.equal(after[n],before[n]);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:30011,elements:actual.nbElements,saved:7,warnings:actual.encounteredWarnings,compiledRulesMatchAuditedCandidates:true,variableDeclarationsUnchanged:true,otherConditionsUnchanged:true,firstVisibleTargetLoopAndCarryReleaseUnchanged:true,nestedArrayPredicates:[],changedFiles,changedRules,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-third-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
