const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),vm=require('node:vm');
const {files,candidates,baselineRef,compile,rules,paletteModel,colorTables}=require('./2026-11-18-thirty-fourth-element-candidates.cjs');
const {actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
const output=g=>vm.runInNewContext(g,{}, {timeout:1000});
const values=s=>[...s.matchAll(/^\s*(-?\d+(?:\.\d+)?),/gm)].map(m=>Number(m[1]));
const defs=s=>Object.fromEntries([...s.matchAll(/#!define (\w+) (\d+)/g)].map(m=>[m[1],Number(m[2])]));
const mapped=(offset,len)=>`Mapped Array(Array Slice(Global.numbersList, ${offset}, ${len}), Value In Array(Global.augmentColorListConst, Current Array Element))`;
async function main(){
 const f={...files};candidates.shared_color_indices_challenge_field_0(f);
 const oldOutput=output(files.__numbersGenerator),newOutput=output(f.__numbersGenerator),oldValues=values(oldOutput),newValues=values(newOutput),oldDefs=defs(oldOutput),newDefs=defs(newOutput);
 assert.equal(oldValues.length,612);assert.equal(newValues.length,662);assert.deepEqual(newValues.slice(0,612),oldValues);for(const [key,value] of Object.entries(oldDefs))assert.equal(newDefs[key],value,key);
 const {base,palette}=paletteModel(files);assert.equal(base.length,11);assert.equal(palette.length,15);assert.deepEqual(palette.slice(0,11),base);
 const tables=colorTables(files),challenges=[...files['game/global_start_menu.opy'].matchAll(/\[(Color\.AQUA, (?:Color\.\w+|null)(?:, (?:Color\.\w+|null))+)\]\[localPlayer.pregameChallengeVote\]/g)];assert.equal(challenges.length,3);
 const entries=[...tables,...challenges.slice(0,1).map((m,i)=>({name:'challengeColor'+i,id:'CHALLENGE_COLORS_'+i,values:m[1].split(', ')}))];
 const mappings=entries.map(t=>{const offset=newDefs['NL_'+t.id+'_OFFSET'],len=newDefs['NL_'+t.id+'_LEN'];assert.equal(len,t.values.length);const indices=newValues.slice(offset,offset+len);assert(indices.every(i=>Number.isInteger(i)&&i>=0&&i<palette.length));assert.deepEqual(indices.map(i=>palette[i]),t.values);return {name:t.name,id:t.id,offset,len,indices,colors:t.values};});
 assert.equal(mappings[0].offset,612);assert.equal(mappings.at(-1).offset+mappings.at(-1).len,662);
 const source=Object.entries(files).filter(([n])=>n.endsWith('.opy')).map(([,s])=>s).join('\n');
 // All valid Augment IDs remain in the unchanged prefix. There is no palette
 // length based traversal; only these three existing indexed menu reads.
 assert.equal((source.match(/AUGMENT_COLORS\[localPlayer\.augmentId\]/g)||[]).length,3);
 assert.equal((source.match(/\.augmentId\s*=\s*[^=][^\n]*/g)||[]).length,3);
 assert(source.includes('eventPlayer.augmentId = Augment.NO_PREFERENCE'));
 assert(source.includes('eventPlayer.augmentId = random.randint(Augment.KEVLAR, Augment.LEECH)'));
 assert(source.includes('% (Augment.LEECH + 1)'));assert(!/len\((?:AUGMENT_COLORS|augmentColorListConst)\)/.test(source));
 for(let id=0;id<=10;id++)for(const increment of [1,10])assert((id+increment)%11>=0&&(id+increment)%11<=10);
 const baseline=await compile(files),candidate=await compile(f);assert.equal(baseline.nbElements,29802);assert.equal(candidate.nbElements,29766);assert.deepEqual(candidate.encounteredWarnings,[]);
 const before=rules(baseline.result),after=rules(candidate.result),init='Initialize global variables #1',menu='EFFECTS/TEXTS #1';assert.deepEqual(Object.keys(after),Object.keys(before));assert.deepEqual(Object.keys(before).filter(n=>before[n]!==after[n]),[init,menu]);
 const oldInit=actionList(before[init]),nextInit=actionList(after[init]),assignment=(a,name)=>{const rows=a.filter(s=>s.startsWith(`Set Global Variable(${name}, `));assert.equal(rows.length,1,name);return rows[0];};
 const oldPalette=assignment(oldInit,'augmentColorListConst'),nextPalette=assignment(nextInit,'augmentColorListConst');assert(oldPalette.endsWith('));'));assert.equal(nextPalette,oldPalette.slice(0,-3)+', Color(Purple), Color(Gray), Color(Rose), Null));');
 assert.equal(assignment(nextInit,'powerUpColorListConst'),`Set Global Variable(powerUpColorListConst, ${mapped(612,13)});`);
 assert(nextInit.indexOf(assignment(nextInit,'numbersList'))<nextInit.indexOf(nextPalette));assert(nextInit.indexOf(nextPalette)<nextInit.indexOf(assignment(nextInit,'powerUpColorListConst')));
 const changedAssignments=['numbersList','augmentColorListConst','powerUpColorListConst'];const unaffected=a=>a.filter(s=>!changedAssignments.some(n=>s.startsWith(`Set Global Variable(${n}, `)));assert.deepEqual(unaffected(nextInit),unaffected(oldInit));
 let expectedMenu=before[menu];for(const [i,name] of ['phaseSlot0','phaseSlot1','phaseSlot2'].entries()){
  const oldAction=assignment(actionList(before[menu]),name),t=mappings[i+1];expectedMenu=expectedMenu.replace(oldAction,()=>`Set Global Variable(${name}, ${mapped(t.offset,t.len)});`);
 }
 const nativeColor=v=>v==='null'?'Null':`Color(${v.slice(6).toLowerCase().split('_').map(s=>s[0].toUpperCase()+s.slice(1)).join(' ')})`;
 for(let i=0;i<1;i++){const t=mappings[i+4],old=`Value In Array(Array(${t.colors.map(nativeColor).join(', ')}), (Local Player).actorTeamSlot3)`;assert(expectedMenu.includes(old));expectedMenu=expectedMenu.replace(old,()=>`Value In Array(${mapped(t.offset,t.len)}, (Local Player).actorTeamSlot3)`);}
 assert.equal(after[menu],expectedMenu);
 for(const name of Object.keys(before))assert.equal(after[name].match(/conditions \{.*?\}/)?.[0],before[name].match(/conditions \{.*?\}/)?.[0]);
 const declarations=s=>s.match(/^variables\s*\{([^}]*)\}/m)[1].split('player:').map(p=>[...p.matchAll(/\d+: (\w+)/g)].map(m=>m[1]));const oldVars=declarations(baseline.result),newVars=declarations(candidate.result);assert.deepEqual(newVars.map(a=>a.slice().sort()),oldVars.map(a=>a.slice().sort()));assert(newVars.flat().every(n=>n.length<=31));assert.deepEqual(nestedPredicates(candidate.result),[]);
 const sourceNames=Object.keys(files).filter(n=>n!=='__numbersGenerator'),apply=process.argv.includes('--apply'),generator='tools/create numbers.js';
 const current=Object.fromEntries(sourceNames.map(n=>[n,fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n')]));
 const currentGenerator=fs.readFileSync(generator,'utf8').replace(/\r\n/g,'\n');
 const isBaseline=sourceNames.every(n=>current[n]===files[n])&&currentGenerator===files.__numbersGenerator,isCandidate=sourceNames.every(n=>current[n]===f[n])&&currentGenerator===f.__numbersGenerator;
 if(!apply)assert(isBaseline||isCandidate,'Workspace is neither the baseline nor the audited candidate');
 for(const n of sourceNames)assert([files[n],f[n]].includes(current[n]),`Unreviewed changes in ${n}`);
 assert([files.__numbersGenerator,f.__numbersGenerator].includes(currentGenerator),'Unreviewed generator changes');
 const changedSources=sourceNames.filter(n=>files[n]!==f[n]);
 if(apply){for(const n of changedSources){const target=path.join('src',n),oldSource=fs.readFileSync(target,'utf8');fs.writeFileSync(target,oldSource.includes('\r\n')?f[n].replace(/\n/g,'\r\n'):f[n]);}const oldGenerator=fs.readFileSync(generator,'utf8');fs.writeFileSync(generator,oldGenerator.includes('\r\n')?f.__numbersGenerator.replace(/\n/g,'\r\n'):f.__numbersGenerator);}
 const implemented=apply||isCandidate;
 await compiler.readyPromise;const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');assert.equal(actual.nbElements,implemented?candidate.nbElements:baseline.nbElements);assert.deepEqual(rules(actual.result),implemented?after:before);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(actual.result),[]);
 if(implemented){assert.equal(output(fs.readFileSync(generator,'utf8')),newOutput);fs.writeFileSync('main.ws.txt',actual.result);}
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,candidate:candidate.nbElements,elements:actual.nbElements,saved:36,warnings:actual.encounteredWarnings,status:implemented?'implemented':'measured only; gameplay sources unchanged',changedFiles:[...changedSources.map(n=>'src/'+n),generator],changedRules:[init,menu],numericTableLength:{before:612,after:662},paletteLength:{before:11,after:15},mappings,originalNumericPrefixAndDefinitionsUnchanged:true,allOriginalColorArraysReconstructedExactly:true,validAugmentIdsKeepOriginalColors:true,initializationDependencyOrderChecked:true,menuOnlyChangesColorExpressions:true,conditionsAndVariableNamesUnchanged:true,newRules:0,newVariables:0,newWaits:0,nestedArrayPredicates:[],nativeBuildMatchesAuditedModel:true,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,implemented?'2026-11-18-thirty-fourth-element-implementation.json':'2026-11-18-thirty-fourth-element-validation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({...report,mappings:report.mappings.map(m=>({name:m.name,offset:m.offset,len:m.len}))},null,2));
}
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
