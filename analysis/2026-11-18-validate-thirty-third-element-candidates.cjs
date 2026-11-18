const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-thirty-third-element-candidates.cjs');
const {actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function split(s){const parts=[];let depth=0,quote=false,escape=false,start=0;for(let i=0;i<s.length;i++){const c=s[i];if(quote){if(escape)escape=false;else if(c==='\\')escape=true;else if(c==='"')quote=false;continue;}if(c==='"')quote=true;else if(c==='(')depth++;else if(c===')')depth--;else if(c===','&&!depth){parts.push(s.slice(start,i).trim());start=i+1;}}parts.push(s.slice(start).trim());assert.equal(depth,0);assert(!quote);return parts;}
function call(s){const m=s.match(/^([^()]+)\((.*)\)$/);assert(m,s);return {name:m[1],args:split(m[2])};}
function normalize(rule,transform){const actions=actionList(rule),chunks=actions.map(transform),offsets=[0];for(const chunk of chunks)offsets.push(offsets.at(-1)+chunk.length);for(let i=0;i<actions.length;i++){
 if(chunks[i].length!==1||!/^Skip(?: If)?\(/.test(chunks[i][0]))continue;
 const parsed=call(chunks[i][0].slice(0,-1)),last=parsed.args.length-1,scalar=parsed.args[last];
 const mapped=value=>{const n=['False','Null'].includes(value)?0:value==='True'?1:Number(value);assert(Number.isInteger(n)&&n>=0,value);const target=i+1+n;assert(target<=actions.length);return String(offsets[target]-offsets[i+1]);};
 if(/^(?:\d+|Null|False|True)$/.test(scalar))parsed.args[last]=mapped(scalar);
 else {const table=call(scalar);assert.equal(table.name,'Value In Array');const array=call(table.args[0]);assert.equal(array.name,'Array');parsed.args[last]=`Value In Array(Array(${array.args.map(mapped).join(', ')}), ${table.args[1]})`;}
 chunks[i]=[`${parsed.name}(${parsed.args.join(', ')});`];
 }return chunks.flat();}
function inlineSnapshot(rule,slot,expression,expectedReads){let assigned=0,reads=0,active=false;const assignment=`Set Global Variable(${slot}, ${expression});`,reference='Global.'+slot;
 const actions=normalize(rule,action=>{
  if(action===assignment){assert(!active);assigned++;active=true;return [];}
  if(active){assert(!/^Wait|^Call Subroutine|^Start Rule/.test(action),'Snapshot crossed a wait or call');const n=action.split(reference).length-1;reads+=n;const next=action.replaceAll(reference,expression);assert(reads<=expectedReads);if(reads===expectedReads)active=false;return [next];}
  return [action];
 });assert.equal(assigned,1);assert.equal(reads,expectedReads);assert(!active);return actions;}
function inlinePullGeometry(rule){let eye=null,origin=null,eyeWrites=0,originWrites=0;assert(!actionList(rule).some(s=>/^Wait|^Call Subroutine|^Start Rule/.test(s)));
 return {actions:normalize(rule,action=>{
  if(action==='Set Global Variable(tmp1, Eye Position(Event Player));'){eye='Eye Position(Event Player)';eyeWrites++;return [];}
  if(action.startsWith('Set Global Variable(tmp3, ')){const expression=action.slice('Set Global Variable(tmp3, '.length,-2);origin=eye?expression.replaceAll('Global.tmp1',eye):expression;originWrites++;return [];}
  let next=action;if(eye)next=next.replaceAll('Global.tmp1',eye);if(origin)next=next.replaceAll('Global.tmp3',origin);return [next];
 }),counts:()=>({eyeWrites,originWrites})};
}
async function main(){
 const f={...files};candidates.combined(f);const baseline=await compile(files),candidate=await compile(f);assert.equal(baseline.nbElements,29847);assert.equal(candidate.nbElements,29802);assert.deepEqual(candidate.encounteredWarnings,[]);
 const before=rules(baseline.result),after=rules(candidate.result);assert.deepEqual(Object.keys(before),Object.keys(after));
 const snapshots={
  'BRUTE (REIN) SUPER SEISMIC SLAM #1':{slot:'tmp0',expression:'World Vector Of(Multiply(Multiply(3, (Event Player).sizeScale), Forward), Event Player, Rotation And Translation)',reads:4},
  'BLASTER (PHARAH) CHARGES ROCKET THEN FIRES #1':{slot:'tmp0',expression:'Add(Eye Position(Event Player), World Vector Of(Vector(False, 11, 5), Event Player, Rotation))',reads:2},
  'sentryTurret (50-59) #1':{slot:'tmp1',expression:'Add((Event Player).actorTeamSlot13, Multiply((Event Player).actorTeamSlot19, 0.5))',reads:2},
 };
 const pull='selectPullAimTarget #1',changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);assert.deepEqual(changedRules.slice().sort(),[...Object.keys(snapshots),pull].sort());
 for(const [rule,{slot,expression,reads}] of Object.entries(snapshots))assert.deepEqual(inlineSnapshot(after[rule],slot,expression,reads),normalize(before[rule],s=>[s]),rule);
 const a=inlinePullGeometry(before[pull]),b=inlinePullGeometry(after[pull]);assert.deepEqual(a.counts(),{eyeWrites:1,originWrites:1});assert.deepEqual(b.counts(),a.counts());assert.deepEqual(b.actions,a.actions);
 for(const name of Object.keys(before)){
  assert.equal(after[name].match(/conditions \{.*?\}/)?.[0],before[name].match(/conditions \{.*?\}/)?.[0],name);
  if(!changedRules.includes(name))assert.equal(after[name],before[name],name);
 }
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(candidate.result),vars(baseline.result));assert.deepEqual(nestedPredicates(candidate.result),[]);
 const sourceNames=Object.keys(files).filter(n=>n!=='__numbersGenerator'),apply=process.argv.includes('--apply');
 const current=Object.fromEntries(sourceNames.map(n=>[n,fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n')]));
 const isBaseline=sourceNames.every(n=>current[n]===files[n]),isCandidate=sourceNames.every(n=>current[n]===f[n]);
 if(!apply)assert(isBaseline||isCandidate,'Workspace is neither the baseline nor the audited candidate');
 for(const n of sourceNames)assert([files[n],f[n]].includes(current[n]),`Unreviewed changes in ${n}`);
 assert.equal(fs.readFileSync('tools/create numbers.js','utf8').replace(/\r\n/g,'\n'),files.__numbersGenerator);
 const changedFiles=sourceNames.filter(n=>files[n]!==f[n]);
 if(apply)for(const n of changedFiles){const target=path.join('src',n),oldSource=fs.readFileSync(target,'utf8');fs.writeFileSync(target,oldSource.includes('\r\n')?f[n].replace(/\n/g,'\r\n'):f[n]);}
 const implemented=apply||isCandidate;
 await compiler.readyPromise;const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');assert.equal(actual.nbElements,implemented?candidate.nbElements:baseline.nbElements);assert.deepEqual(rules(actual.result),implemented?after:before);assert.deepEqual(actual.encounteredWarnings,[]);assert.deepEqual(nestedPredicates(actual.result),[]);
 if(implemented)fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,candidate:candidate.nbElements,elements:actual.nbElements,saved:45,warnings:actual.encounteredWarnings,status:implemented?'implemented':'measured only; gameplay sources unchanged',changedFiles:changedFiles.map(n=>'src/'+n),changedRules,snapshots:Object.entries(snapshots).map(([rule,s])=>({rule,slot:s.slot,reads:s.reads})),allActionsMatchAfterInliningSnapshotsAndRebasingSkips:true,pullOriginAndEyeExpressionsMatchAfterInlining:true,conditionsAndVariablesUnchanged:true,newRules:0,newVariables:0,newWaits:0,nestedArrayPredicates:[],nativeBuildMatchesAuditedModel:true,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,implemented?'2026-11-18-thirty-third-element-implementation.json':'2026-11-18-thirty-third-element-validation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
}
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
