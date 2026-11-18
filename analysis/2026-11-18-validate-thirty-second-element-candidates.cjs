const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-thirty-second-element-candidates.cjs');
const {actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
async function main(){
 const f={...files};candidates.satellite_center_beam_loop(f);const baseline=await compile(files),candidate=await compile(f);
 assert.equal(baseline.nbElements,29871);assert.equal(candidate.nbElements,29847);assert.deepEqual(candidate.encounteredWarnings,[]);
 const before=rules(baseline.result),after=rules(candidate.result),rule='PLAYERS REPAIR TERMINALS #1';
 assert.deepEqual(Object.keys(before),Object.keys(after));assert.deepEqual(Object.keys(before).filter(n=>before[n]!==after[n]),[rule]);
 const a=actionList(before[rule]),b=actionList(after[rule]),loop='For Global Variable(tmp0, 1, -2, -2);';
 assert.equal(b.filter(s=>s===loop).length,1);const index=b.indexOf(loop);assert(index>=0);
 const beam=b[index+1],append=b[index+2];assert(beam.startsWith('Create Beam Effect(All Players(All Teams), Bad Beam, '));
 assert.equal(append,'Modify Global Variable(objectiveEntityIdList, Append To Array, Last Created Entity);');assert.equal(b[index+3],'End;');
 assert.equal(beam.split('Evaluate Once(Global.tmp0)').length-1,2);assert.equal(beam.split('Global.tmp0').length-1,2);
 assert(beam.endsWith('Color(Sky Blue), Visible To Position and Radius);'));
 // Unroll only the new two-iteration loop. Its four native actions replace
 // four old actions, so all compiled Skip offsets must remain identical.
 const direction='Direction From Angles(Multiply(Total Time Elapsed, 360), 0)';
 const expanded=[1,-1].flatMap(side=>[beam.replaceAll('Evaluate Once(Global.tmp0)',String(side)).replaceAll(`Multiply(${direction}, 1)`,direction),append]);
 assert.deepEqual(expanded,a.slice(index,index+4));
 assert.deepEqual([...b.slice(0,index),...expanded,...b.slice(index+4)],a);
 assert.equal(a.length,b.length);
 // The following shaft loop initializes this same scratch slot immediately.
 assert.equal(b[index+4],'For Global Variable(tmp0, -1, 5, True);');
 assert(!b.slice(index,index+4).some(s=>/^Wait|^Call Subroutine|^Start Rule/.test(s)));
 for(const name of Object.keys(before))assert.equal(after[name].match(/conditions \{.*?\}/)?.[0],before[name].match(/conditions \{.*?\}/)?.[0]);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(candidate.result),vars(baseline.result));assert.deepEqual(nestedPredicates(candidate.result),[]);
 const changedFiles=Object.keys(files).filter(n=>n!=='__numbersGenerator'&&files[n]!==f[n]);assert.deepEqual(changedFiles,['objective_types/objective_type_satellite_uplink.opy']);
 // Apply only the audited change; reject unrelated source changes before writing.
 const sourceNames=Object.keys(files).filter(n=>n!=='__numbersGenerator'),apply=process.argv.includes('--apply');
 const current=Object.fromEntries(sourceNames.map(n=>[n,fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n')]));
 const isBaseline=sourceNames.every(n=>current[n]===files[n]),isCandidate=sourceNames.every(n=>current[n]===f[n]);
 if(!apply)assert(isBaseline||isCandidate,'Workspace is neither the baseline nor the audited candidate');
 for(const n of sourceNames)assert([files[n],f[n]].includes(current[n]),`Unreviewed changes in ${n}`);
 assert.equal(fs.readFileSync('tools/create numbers.js','utf8').replace(/\r\n/g,'\n'),files.__numbersGenerator);
 if(apply)for(const n of changedFiles){const target=path.join('src',n),oldSource=fs.readFileSync(target,'utf8');fs.writeFileSync(target,oldSource.includes('\r\n')?f[n].replace(/\n/g,'\r\n'):f[n]);}
 const implemented=apply||isCandidate;
 await compiler.readyPromise;const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');assert.equal(actual.nbElements,implemented?candidate.nbElements:baseline.nbElements);assert.deepEqual(rules(actual.result),implemented?after:before);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(actual.result),[]);
 if(implemented)fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,candidate:candidate.nbElements,elements:actual.nbElements,saved:24,warnings:actual.encounteredWarnings,status:implemented?'implemented':'measured only; gameplay sources unchanged',changedFiles:changedFiles.map(n=>'src/'+n),changedRules:[rule],beamCreationOrder:[1,-1],capturedSideReadsPerBeam:2,allActionsEqualAfterUnrolling:true,skipOffsetsUnchanged:true,conditionsAndVariablesUnchanged:true,followingLoopReinitializesScratch:true,newRules:0,newVariables:0,newWaits:0,nestedArrayPredicates:[],nativeBuildMatchesAuditedModel:true,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,implemented?'2026-11-18-thirty-second-element-implementation.json':'2026-11-18-thirty-second-element-validation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
}
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
