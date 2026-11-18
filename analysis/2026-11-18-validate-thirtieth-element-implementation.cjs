const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),vm=require('node:vm');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-thirtieth-element-candidates.cjs');
const {actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
const output=g=>vm.runInNewContext(g,{}, {timeout:1000});
const values=s=>[...s.matchAll(/^\s*(-?\d+(?:\.\d+)?),/gm)].map(m=>Number(m[1]));
const definitions=s=>Object.fromEntries([...s.matchAll(/#!define (\w+) (\d+)/g)].map(m=>[m[1],Number(m[2])]));
(async()=>{
 const expected={...files};candidates.combined(expected);
 const oldOutput=output(files.__numbersGenerator),nextOutput=output(expected.__numbersGenerator);
 const oldValues=values(oldOutput),nextValues=values(nextOutput),oldDefs=definitions(oldOutput),nextDefs=definitions(nextOutput);
 assert.equal(oldValues.length,592);assert.equal(nextValues.length,612);assert.deepEqual(nextValues.slice(0,592),oldValues);
 for(const [key,value] of Object.entries(oldDefs))assert.equal(nextDefs[key],value,key);
 const heroes=files['game/global_start_menu.opy'].match(/botHeroList = \[([^\]]+)\]/)[1].split(', ');
 assert.equal(Object.values(files).join('\n').match(/^\s*botHeroList\s*=/gm).length,1);
 const oldHeroSelection=files['core/subroutines.opy'].match(/random.choice\(\[(Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN[^\]]+)\]\)/)[1].split(', ');
 assert.deepEqual(nextValues.slice(592,600).map(i=>heroes[i]),oldHeroSelection);
 const metadata=files['game/global_start_menu.opy'].match(/numbersList.slice\(\[([^\]]+)\]\[zombieSetting - 1\], \[([^\]]+)\]\[zombieSetting - 1\]\)/);
 const metadataValues=metadata.slice(1).flatMap(s=>s.split(', ').map(n=>n==='0'?0:oldDefs[n]));
 assert.deepEqual(nextValues.slice(600),metadataValues);
 for(let mode=1;mode<=6;mode++)assert.deepEqual(nextValues.slice(nextValues[599+mode],nextValues[599+mode]+nextValues[605+mode]),oldValues.slice(metadataValues[mode-1],metadataValues[mode-1]+metadataValues[mode+5]));
 const baseline=await compile(files),model=await compile(expected);assert.equal(baseline.nbElements,29908);assert.equal(model.nbElements,29889);
 const before=rules(baseline.result),after=rules(model.result);assert.deepEqual(Object.keys(after),Object.keys(before));
 const changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);assert.deepEqual(changedRules,['Initialize global variables #1','botRespawnInitialization #1','setZombieMode #1']);
 // Each affected rule differs in exactly one action; all branches, waits and randomness remain.
 for(const name of changedRules){const a=actionList(before[name]),b=actionList(after[name]);assert.equal(a.length,b.length);const changes=a.map((v,i)=>v!==b[i]?i:-1).filter(i=>i>=0);assert.equal(changes.length,1);const i=changes[0];assert.equal(before[name].replace(a[i],()=>b[i]),after[name]);
  if(name==='botRespawnInitialization #1'){
   assert(a[i].startsWith('Start Forcing Player To Be Hero(Event Player, Random Value In Array(Array(Hero(Reinhardt), Hero(Wrecking Ball),'));
   assert.equal(b[i],'Start Forcing Player To Be Hero(Event Player, Value In Array(Global.botHeroList, Random Value In Array(Array Slice(Global.numbersList, 592, 8))));');
  }else if(name==='setZombieMode #1')assert.equal(b[i],'Set Global Variable(botSpawnRateList, Array Slice(Global.numbersList, Value In Array(Array Slice(Global.numbersList, 600, 6), Subtract(Global.zombieSetting, True)), Value In Array(Array Slice(Global.numbersList, 606, 6), Subtract(Global.zombieSetting, True))));');
  else {assert(a[i].startsWith('Set Global Variable(numbersList, '));assert(b[i].startsWith('Set Global Variable(numbersList, '));}
 }
 for(const name of Object.keys(before))assert.equal(after[name].match(/conditions \{.*?\}/)?.[0],before[name].match(/conditions \{.*?\}/)?.[0]);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(model.result),vars(baseline.result));assert.deepEqual(nestedPredicates(model.result),[]);
 const changedFiles=Object.keys(files).filter(n=>n!=='__numbersGenerator'&&files[n]!==expected[n]);
 // Check the workspace before applying any changes.
 for(const n of Object.keys(files).filter(n=>n!=='__numbersGenerator')){const actual=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');assert(process.argv.includes('--apply')?[files[n],expected[n]].includes(actual):actual===expected[n],n);}
 const generator='tools/create numbers.js',currentGenerator=fs.readFileSync(generator,'utf8').replace(/\r\n/g,'\n');assert(process.argv.includes('--apply')?[files.__numbersGenerator,expected.__numbersGenerator].includes(currentGenerator):currentGenerator===expected.__numbersGenerator);
 if(process.argv.includes('--apply')){for(const n of changedFiles)fs.writeFileSync(path.join('src',n),expected[n]);fs.writeFileSync(generator,expected.__numbersGenerator);}
 await compiler.readyPromise;const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,29889);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(rules(actual.result),after);assert.deepEqual(nestedPredicates(actual.result),[]);fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,elements:actual.nbElements,saved:baseline.nbElements-actual.nbElements,warnings:actual.encounteredWarnings,changedFiles:[...changedFiles.map(n=>'src/'+n),generator],changedRules,numericTableLength:{before:592,after:612},oldNumericPrefixAndDefinitionsUnchanged:true,minibossHeroesAndOrderUnchanged:true,spawnMetadataAndSlicesUnchanged:true,onlyOneActionPerChangedRule:true,conditionsAndVariablesUnchanged:true,nestedArrayPredicates:[],nativeBuildMatchesModel:true,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-thirtieth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
