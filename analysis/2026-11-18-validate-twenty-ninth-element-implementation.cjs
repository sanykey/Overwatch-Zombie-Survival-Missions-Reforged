const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),vm=require('node:vm');
const {execFileSync}=require('node:child_process');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
(async()=>{
 selfTest();const expectedSources={...files};candidates.combined_recommended(expectedSources);
 const changedSources=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 const generator='tools/create numbers.js',originalGenerator=execFileSync('git',['show',baselineRef+':'+generator],{encoding:'utf8'}).replace(/\r\n/g,'\n');
 for(const n of Object.keys(files)) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply'))assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidate: ${n}`);
 }
 const currentGenerator=fs.readFileSync(generator,'utf8');
 if(process.argv.includes('--apply'))assert([originalGenerator,expectedSources.__numbersGenerator].includes(currentGenerator.replace(/\r\n/g,'\n')),'Unreviewed generator changes');
 else assert.equal(currentGenerator.replace(/\r\n/g,'\n'),expectedSources.__numbersGenerator);
 if(process.argv.includes('--apply')) {
  for(const n of changedSources){const target=path.join('src',n),current=fs.readFileSync(target,'utf8');fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);}
  fs.writeFileSync(generator,currentGenerator.includes('\r\n')?expectedSources.__numbersGenerator.replace(/\n/g,'\r\n'):expectedSources.__numbersGenerator);
 }
 await compiler.readyPromise;
 const baseline=await compile(files),expected=await compile(expectedSources);
 assert.equal(baseline.nbElements,29928);assert.equal(expected.nbElements,29908);
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,29908);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(rules(actual.result),rules(expected.result));assert.deepEqual(nestedPredicates(actual.result),[]);
 const output=s=>vm.runInNewContext(s,{}, {timeout:1000});
 const values=s=>[...s.matchAll(/^\s*(-?\d+(?:\.\d+)?),/gm)].map(m=>Number(m[1]));
 const definitions=s=>Object.fromEntries([...s.matchAll(/#!define (\w+) (\d+)/g)].map(m=>[m[1],Number(m[2])]));
 const oldOutput=output(originalGenerator),newOutput=output(fs.readFileSync(generator,'utf8'));
 const oldValues=values(oldOutput),newValues=values(newOutput),newDefinitions=definitions(newOutput);
 assert.equal(oldValues.length,580);assert.equal(newValues.length,592);assert.deepEqual(newValues.slice(0,580),oldValues);
 for(const [key,value] of Object.entries(definitions(oldOutput)))assert.equal(newDefinitions[key],value,key);
 assert.equal(newDefinitions.NL_BOSS_EXCLUDED_HERO_OFFSET,580);assert.equal(newDefinitions.NL_BOSS_EXCLUDED_HERO_LEN,12);
 const source=files['game/global_start_menu.opy'],list=n=>source.match(new RegExp('    '+n+' = \\[([^\\]]+)\\]'))[1].split(',').map(s=>s.trim());
 const heroes=list('botHeroList');assert.deepEqual(newValues.slice(580).map(i=>heroes[i]),list('bossesExcludedHeroList'));
 const before=rules(baseline.result),after=rules(actual.result);assert.deepEqual(Object.keys(before),Object.keys(after));
 const changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);assert.deepEqual(changedRules.slice().sort(),['Initialize global variables #1','setZombieMode #1'].sort());
 for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:29928,elements:actual.nbElements,saved:20,warnings:actual.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,originalNumericPrefixAndOffsetsUnchanged:true,excludedHeroesAndOrderUnchanged:true,numericTableLength:{before:580,after:592},variableDeclarationsAndConditionsUnchanged:true,nestedArrayPredicates:[],changedFiles:[...changedSources.map(n=>'src/'+n),generator],changedRules,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-ninth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
