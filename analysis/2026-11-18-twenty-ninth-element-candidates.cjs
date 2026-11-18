// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const vm=require('node:vm');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const {actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='044632dee1ff9ba0dfcd40dd62cd80ccd0c13eb8';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const originalGeneratorSource=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
function inlineNumbers(f,generator) {
 const next={...f},file='core/compressed numbers.opy',output=vm.runInNewContext(generator,{}, {timeout:1000});assert.equal(typeof output,'string');
 next[file]=next[file].replace(/^#!define createNumbers\(\) __script__\([^\n]+\)\n/m,'').replace('    createNumbers()',output);
 assert(!next[file].includes('createNumbers()'));return next;
}
async function compile(f,nativeScripts=false) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(nativeScripts?f:inlineNumbers(f,f.__numbersGenerator||originalGeneratorSource)),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function heroLists(f) {
 const source=f['game/global_start_menu.opy'];
 const parse=name=>{const m=source.match(new RegExp('    '+name+' = \\[([^\\]]+)\\]'));assert(m);return m[1].split(',').map(s=>s.trim());};
 return {heroes:parse('botHeroList'),excluded:parse('bossesExcludedHeroList')};
}
const candidates={
 boss_exclusions_compressed_indices(f) {
  const {heroes,excluded}=heroLists(f),indices=excluded.map(h=>heroes.indexOf(h));assert(indices.every(i=>i>=0));
  const generator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
  const marker='];\n\nlet numberIndex = 0;';assert(generator.includes(marker));
  f.__numbersGenerator=generator.replace(marker,'  { // Boss exclusions: botHeroList indices, preserving the existing exclusion order.\n    offset: "NL_BOSS_EXCLUDED_HERO_OFFSET",\n    len: "NL_BOSS_EXCLUDED_HERO_LEN",\n    list: [\n'+indices.map((index,i)=>'      '+index+', // '+excluded[i].slice(5)).join('\n')+'\n    ],\n  },\n'+marker);
  replace(f,'game/global_start_menu.opy','    bossesExcludedHeroList = ['+excluded.join(', ')+']','    # Shared table stores botHeroList indices in the original exclusion order.\n    bossesExcludedHeroList = numbersList.slice(NL_BOSS_EXCLUDED_HERO_OFFSET, NL_BOSS_EXCLUDED_HERO_LEN).map(lambda index: botHeroList[index])');
 },
 boss_exclusions_from_hero_indices(f) {
  const {heroes,excluded}=heroLists(f);assert.equal(new Set(heroes).size,heroes.length);
  const indices=excluded.map(h=>{const i=heroes.indexOf(h);assert(i>=0);return i;});
  assert.deepEqual(indices.map(i=>heroes[i]),excluded);
  replace(f,'game/global_start_menu.opy','    bossesExcludedHeroList = ['+excluded.join(', ')+']','    # Indices into the hero list just assigned above, preserving exclusion order:\n    # Junkrat, Anran, Widow, JQ, Symmetra, Ana, Doomfist, Kiriko, Mauga, Sigma, Ball, Cat.\n    bossesExcludedHeroList = ['+indices.join(', ')+'].map(lambda index: botHeroList[index])');
 },
};
const recommended=['boss_exclusions_compressed_indices'];
candidates.combined_recommended=f=>recommended.forEach(n=>candidates[n](f));
async function main() {
 selfTest();await compiler.readyPromise;const baseline=await compile(files),before=rules(baseline.result);
 assert.equal(baseline.nbElements,29928);assert.deepEqual(baseline.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(baseline.result),[]);
 const originalGenerator=originalGeneratorSource;
 if(fs.readFileSync('tools/create numbers.js','utf8').replace(/\r\n/g,'\n')===originalGenerator) {
  const nativeBaseline=await compile(files,true);assert.equal(nativeBaseline.nbElements,baseline.nbElements);assert.deepEqual(rules(nativeBaseline.result),before);
 }
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};
 const lists=heroLists(files),indices=lists.excluded.map(h=>lists.heroes.indexOf(h));
 assert.deepEqual(indices.map(i=>lists.heroes[i]),lists.excluded);
 report.exclusionMapping=indices.map((index,i)=>({index,hero:lists.excluded[i]}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};fn(f);const r=await compile(f),after=rules(r.result);
  const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};
  assert.deepEqual(Object.keys(before),Object.keys(after));
  const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
  for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
  for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1']){assert(before[n]);assert.equal(after[n],before[n]);}
  assert.deepEqual(nestedPredicates(r.result),[]);row.noNestedArrayPredicates=true;row.variablesRuleSetConditionsAndProtectedRulesUnchanged=true;
  if(['boss_exclusions_compressed_indices','combined_recommended'].includes(name)) {
   const originalOutput=vm.runInNewContext(originalGenerator,{}, {timeout:1000}),nextOutput=vm.runInNewContext(f.__numbersGenerator,{}, {timeout:1000});
   const values=s=>[...s.matchAll(/^\s*(-?\d+(?:\.\d+)?),/gm)].map(m=>Number(m[1]));
   const definitions=s=>Object.fromEntries([...s.matchAll(/#!define (\w+) (\d+)/g)].map(m=>[m[1],Number(m[2])]));
   const oldValues=values(originalOutput),nextValues=values(nextOutput),oldDefs=definitions(originalOutput),nextDefs=definitions(nextOutput);
   assert.deepEqual(nextValues.slice(0,oldValues.length),oldValues);
   for(const [key,value] of Object.entries(oldDefs))assert.equal(nextDefs[key],value,key);
   assert.equal(nextDefs.NL_BOSS_EXCLUDED_HERO_OFFSET,oldValues.length);assert.equal(nextDefs.NL_BOSS_EXCLUDED_HERO_LEN,indices.length);
   assert.deepEqual(nextValues.slice(oldValues.length),indices);assert.deepEqual(nextValues.slice(oldValues.length).map(i=>lists.heroes[i]),lists.excluded);
   assert.equal(Object.values(files).join('\n').match(/^\s*botHeroList\s*=/gm).length,1);
   const name='setZombieMode #1',oldActions=actionList(before[name]),nextActions=actionList(after[name]);
   const oldSet=oldActions.find(a=>a.startsWith('Set Global Variable(bossesExcludedHeroList, ')),nextSet=nextActions.find(a=>a.startsWith('Set Global Variable(bossesExcludedHeroList, '));assert(oldSet&&nextSet);
   const expected=`Set Global Variable(bossesExcludedHeroList, Mapped Array(Array Slice(Global.numbersList, ${oldValues.length}, ${indices.length}), Value In Array(Global.botHeroList, Current Array Element)));`;
   assert.equal(nextSet,expected);assert.equal(before[name].replace(oldSet,()=>nextSet),after[name]);
   const init='Initialize global variables #1',oldInit=actionList(before[init]),newInit=actionList(after[init]);
   assert(oldInit[0].startsWith('Set Global Variable(numbersList, '));assert(newInit[0].startsWith('Set Global Variable(numbersList, '));
   assert.equal(before[init].replace(oldInit[0],()=>newInit[0]),after[init]);
   assert.deepEqual(row.changedRules.slice().sort(),[init,name].sort());assert.equal(r.nbElements,29908);assert.deepEqual(r.encounteredWarnings,[]);
   row.originalNumericPrefixAndOffsetsUnchanged=true;row.excludedHeroesAndOrderUnchanged=true;row.otherNativeActionsUnchanged=true;
   row.numericTableLength={before:oldValues.length,after:nextValues.length};
  }
  report.results.push(row);console.log(JSON.stringify(row));
  fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-ninth-probe-'+name+'.ws.txt'),r.result);
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-ninth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-18-twenty-ninth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={baselineRef,files,candidates,recommended,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
