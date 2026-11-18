const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-thirty-first-element-candidates.cjs');
const {actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
const call=(name,...args)=>`${name}(${args.join(', ')})`;
function geometryModel(){
 let state=182026,maxError=0;const random=()=>{state=(Math.imul(state,1664525)+1013904223)>>>0;return state/4294967296;};
 const sub=(a,b)=>a.map((x,i)=>x-b[i]),add=(a,b)=>a.map((x,i)=>x+b[i]),mul=(a,s)=>a.map(x=>x*s),norm=a=>Math.hypot(...a);
 let checked=0;
 for(let i=0;i<12000;i++){
  const corner=Array.from({length:3},()=>1000*random()-500),position=Array.from({length:3},()=>1000*random()-500);
  // Deliberately allow non-horizontal edges as well: the translation identity
  // does not require the placed edge's zero Y component.
  const edge=Array.from({length:3},()=>2*random()-1),delta=sub(position,corner);delta[1]=0;
  const scale=Math.min(6,Math.abs(edge.reduce((sum,x,j)=>sum+x*delta[j],0)));
  const old=norm(sub([position[0],corner[1],position[2]],add(corner,mul(edge,scale))));
  const next=norm(sub(delta,mul(edge,scale)));const error=Math.abs(old-next);maxError=Math.max(maxError,error);assert(error<1e-9);
  if(Math.abs(old-1.5)>1e-9)assert.equal(next<1.5,old<1.5);checked++;
 }
 // Axis-aligned, exactly representable threshold cases, including endpoints,
 // negative projections (the original Abs is intentional) and different heights.
 for(const x of [-10,-6,-1,0,1,6,10])for(const z of [0,1.5-1/1024,1.5,1.5+1/1024])for(const y of [-10,0,10]){
  const corner=[8,4,-16],position=[8+x,4+y,-16+z],edge=[1,0,0],scale=Math.min(6,Math.abs(x));
  const old=norm(sub([position[0],corner[1],position[2]],add(corner,mul(edge,scale))));
  const next=norm(sub([x,0,z],mul(edge,scale)));assert.equal(next,old);assert.equal(next<1.5,old<1.5);checked++;
 }
 return {checked,maxError,workshopFloatingPointTested:false};
}
async function main(){
 const expected={...files};candidates.combined(expected);const baseline=await compile(files),result=await compile(expected);assert.equal(baseline.nbElements,29889);assert.equal(result.nbElements,29871);assert.deepEqual(result.encounteredWarnings,[]);
 const before=rules(baseline.result),after=rules(result.result);assert.deepEqual(Object.keys(after),Object.keys(before));
 const mask='Global.horizontalMaskConst',literal='Add(Left, Forward)',init='Initialize global variables #1',barrier='[LASER_BARRICADE AUGMENT] BLOCKS ZOMBIES #1';
 const initActions=actionList(after[init]),assignment='Set Global Variable(horizontalMaskConst, Vector(1, 0, 1));';assert.equal(initActions.filter(a=>a===assignment).length,1);
 assert.deepEqual(initActions.filter(a=>a!==assignment),actionList(before[init]));
 const p=call('Position Of','Current Array Element'),c='(Event Player).actorTeamSlot26',e='(Event Player).augmentState1';
 const offset=call('Multiply',call('Subtract',p,c),literal),scale=call('Min','6',call('Absolute Value',call('Dot Product',e,offset))),along=call('Multiply',e,scale);
 const old=call('Distance Between',call('Vector',call('X Component Of',p),call('Y Component Of',c),call('Z Component Of',p)),call('Add',c,along));
 const next=call('Magnitude Of',call('Subtract',offset,along));
 assert.equal(before[barrier].split(old).length-1,2);assert.equal(after[barrier].replaceAll(mask,literal),before[barrier].replaceAll(old,next));
 let readers=0;
 for(const name of Object.keys(before)){
  readers+=after[name].split(mask).length-1;
  if(![init,barrier].includes(name))assert.equal(after[name].replaceAll(mask,literal),before[name],name);
 }
 assert.equal(readers,17);assert.equal(Object.values(after).join(' ').split(assignment).length-1,1);assert.deepEqual(nestedPredicates(result.result),[]);
 const declarations=s=>s.match(/^variables\s*\{([^}]*)\}/m)[1].split('player:').map(part=>[...part.matchAll(/\d+: (\w+)/g)].map(m=>m[1]));
 const oldVars=declarations(baseline.result),newVars=declarations(result.result);assert.equal(newVars[0].filter(n=>n==='horizontalMaskConst').length,1);assert.deepEqual(newVars[0].filter(n=>n!=='horizontalMaskConst'),oldVars[0]);assert.deepEqual(newVars[1],oldVars[1]);
 for(const group of newVars){assert(group.length<=128);assert(group.every(n=>n.length<=31));}
 // Only the pinned baseline and the audited candidate may be applied/validated.
 const sourceNames=Object.keys(files).filter(n=>n!=='__numbersGenerator'),apply=process.argv.includes('--apply');
 const current=Object.fromEntries(sourceNames.map(n=>[n,fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n')]));
 const isBaseline=sourceNames.every(n=>current[n]===files[n]),isCandidate=sourceNames.every(n=>current[n]===expected[n]);
 if(!apply)assert(isBaseline||isCandidate,'Workspace is neither the baseline nor the audited candidate');
 for(const n of sourceNames)assert([files[n],expected[n]].includes(current[n]),`Unreviewed source changes: ${n}`);
 assert.equal(fs.readFileSync('tools/create numbers.js','utf8').replace(/\r\n/g,'\n'),files.__numbersGenerator);
 const geometry=geometryModel(),changedFiles=sourceNames.filter(n=>files[n]!==expected[n]);
 if(apply)for(const n of changedFiles){const target=path.join('src',n),oldSource=fs.readFileSync(target,'utf8');fs.writeFileSync(target,oldSource.includes('\r\n')?expected[n].replace(/\n/g,'\r\n'):expected[n]);}
 const implemented=apply||isCandidate;
 await compiler.readyPromise;const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');assert.equal(actual.nbElements,implemented?result.nbElements:baseline.nbElements);assert.deepEqual(rules(actual.result),implemented?after:before);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(actual.result),[]);
 if(implemented)fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,candidate:result.nbElements,elements:actual.nbElements,saved:18,warnings:result.encounteredWarnings,status:implemented?'implemented':'measured only; gameplay sources unchanged',changedFiles:changedFiles.map(n=>'src/'+n),changedRules:Object.keys(before).filter(n=>before[n]!==after[n]),projectionReads:readers,addedGlobalVariables:1,variableCounts:{global:newVars[0].length,player:newVars[1].length},otherRulesEqualAfterExpandingConstant:true,initializationOnlyAddsImmutableVector:true,barrierOnlyChangesTranslatedDistanceTwice:true,geometryModel:geometry,nestedArrayPredicates:[],nativeBuildMatchesAuditedModel:true,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,implemented?'2026-11-18-thirty-first-element-implementation.json':'2026-11-18-thirty-first-element-validation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
}
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
