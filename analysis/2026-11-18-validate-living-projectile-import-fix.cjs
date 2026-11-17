const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-first-element-candidates.cjs');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const badRef='b2c1adf7b077e0d797fe6deb686cb6715c2201b0';
const baselineRef='998c18b';
function git(args){return execFileSync('git',args,{encoding:'utf8'}).replace(/\r\n/g,'\n');}
function sources(ref){return Object.fromEntries(git(['ls-tree','-r','--name-only',ref,'src']).trim().split('\n').filter(n=>n.endsWith('.opy')).map(n=>[n.slice(4),git(['show',ref+':'+n])]));}
(async()=>{
 selfTest();
 const old=await compile(sources(badRef+'^')),bad=await compile(sources(badRef)),baseline=await compile(sources(baselineRef));
 const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
 const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
 const compiler=require(path.join(extdir,ext,'npm/overpy.js'));await compiler.readyPromise;
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(baseline.nbElements,30005);assert.equal(actual.nbElements,30011);assert.deepEqual(actual.encounteredWarnings,[]);
 const originalFindings=nestedPredicates(old.result),badFindings=nestedPredicates(bad.result),beforeFindings=nestedPredicates(baseline.result),fixedFindings=nestedPredicates(actual.result);
 assert.deepEqual(originalFindings,[]);assert.equal(badFindings.length,1);assert.equal(beforeFindings.length,1);assert.deepEqual(fixedFindings,[]);
 for(const finding of [badFindings[0],beforeFindings[0]]){assert.deepEqual(finding.outer,['Is True For Any']);assert.equal(finding.inner,'Is True For All');}
 const before=rules(baseline.result),after=rules(actual.result),historical=rules(old.result),name='LIVING PROJECTILE RELEASE #1';
 assert.deepEqual(Object.keys(before),Object.keys(after));
 assert.deepEqual(Object.keys(before).filter(n=>before[n]!==after[n]),[name]);
 const conditions=s=>s.match(/conditions \{.*?\}/)?.[0],actions=s=>s.match(/actions \{.*\} \}$/)?.[0];
 assert(conditions(after[name]));assert.equal(conditions(after[name]),conditions(historical[name]));
 assert(actions(before[name]));assert.equal(actions(after[name]),actions(before[name]));
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,badRef,baselineRef,baseline:baseline.nbElements,elements:actual.nbElements,elementIncrease:6,warnings:actual.encounteredWarnings,originalFindings,badFindings,beforeFindings,fixedFindings,restoresConditionsBeforeBadCommit:true,releaseActionsUnchanged:true,otherRulesAndVariablesUnchanged:true,inGameImportValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-living-projectile-import-fix.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
