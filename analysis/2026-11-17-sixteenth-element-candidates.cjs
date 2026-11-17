// Read-only measurements of empty switch arms and adjacent pure guards.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='88f8406b7bd566df3dd9c73a5d84e55744cd9017';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function splitTop(s,separator) {
 const result=[];let start=0,depth=0,quote=false,escape=false;
 for(let i=0;i<s.length;i++) {
  const c=s[i];
  if(quote) {if(escape)escape=false;else if(c==='\\')escape=true;else if(c==='"')quote=false;continue;}
  if(c==='"')quote=true;else if(c==='(')depth++;else if(c===')')depth--;else if(c===separator&&depth===0) {result.push(s.slice(start,i).trim());start=i+1;}
 }
 assert.equal(depth,0);assert(!quote);result.push(s.slice(start).trim());return result;
}
function call(s) {const i=s.indexOf('(');assert(i>=0&&s.endsWith(')'),s);return {name:s.slice(0,i),args:splitTop(s.slice(i+1,-1),',')};}
function expectCall(s,name) {const c=call(s);assert.equal(c.name,name);return c.args;}
function numeric(s) {if(['Null','False'].includes(s))return 0;if(s==='True')return 1;assert(Number.isFinite(Number(s)),s);return Number(s);}
function switchBlocks(rule,selector) {
 const body=rule.match(/ actions \{ (.*?) \} \}$/)?.[1];assert(body);
 const pieces=splitTop(body,';');assert.equal(pieces.pop(),'');const actions=pieces.map(s=>s+';');
 const blocks=[];
 for(let i=0;i<actions.length;i++) if(actions[i].startsWith('Skip(Value In Array(Array(')) {
  const value=expectCall(actions[i].slice(0,-1),'Skip');assert.equal(value.length,1);
  const [offsetTable,indexExpr]=expectCall(value[0],'Value In Array');
  const [one,indexOf]=expectCall(indexExpr,'Add');assert.equal(numeric(one),1);
  const [idTable,source]=expectCall(indexOf,'Index Of Array Value');
  if(source!==selector)continue;
  const offsets=expectCall(offsetTable,'Array').map(numeric),ids=expectCall(idTable,'Array').map(numeric);
  assert.equal(offsets.length,ids.length+1);assert.equal(actions[i-1],'If(True);');
  const end=i+1+offsets[0];assert.equal(actions[end],'End;','Default jump must reach the switch frame end');
  const trace=id=>{
   const key=ids.indexOf(id),target=i+1+offsets[key+1];assert(target>i&&target<=end);
   const result=[];
   for(let j=target;j<end&&actions[j]!=='Else;';j++) {
    assert(!/^(?:If\(|Else If\(|Skip\(|Skip If\(|For Global Variable\(|While\(|End;)/.test(actions[j]),'Only flat switch arms are supported by this structural audit');
    result.push(actions[j]);
   }
   return result;
  };
  blocks.push({start:i-1,end,ids,trace});
 }
 return {actions,blocks,body};
}
function auditSwitchRemoval(before,after,selector,expectedBlocks,removedId) {
 const a=switchBlocks(before,selector),b=switchBlocks(after,selector);assert.equal(a.blocks.length,expectedBlocks);assert.equal(b.blocks.length,expectedBlocks);
 const sampleIds=[...Array.from({length:23},(_,i)=>i-2),100];let cases=0;
 for(let i=0;i<expectedBlocks;i++) {
  assert(a.blocks[i].ids.includes(removedId));assert(!b.blocks[i].ids.includes(removedId));
  assert.deepEqual(a.blocks[i].trace(removedId),[]);assert.deepEqual(b.blocks[i].trace(removedId),[]);
  for(const id of sampleIds) {assert.deepEqual(a.blocks[i].trace(id),b.blocks[i].trace(id),'Different compiled action sequence for selector '+id);cases++;}
 }
 const normalize=parsed=>{
  const result=[];let cursor=0;
  for(const block of parsed.blocks) {result.push(...parsed.actions.slice(cursor,block.start),'SWITCH('+selector+'): '+JSON.stringify(sampleIds.map(id=>block.trace(id))));cursor=block.end+1;}
  result.push(...parsed.actions.slice(cursor));return result;
 };
 assert.deepEqual(normalize(a),normalize(b),'All compiled actions outside the audited switches must remain identical');
 return cases;
}
const candidates={
 remove_empty_boss_switch_arms(f) {
  const file='core/subroutines.opy',a='            case ObjectiveType.BOSSES:\n                break\n';assert.equal(f[file].split(a).length-1,2);
  f[file]=f[file].replaceAll(a,'');
  replace(f,file,'            #Checks if current objective is bosses\n','');
 },
 remove_empty_brain_killer_arm(f) {
  replace(f,'abilities/player_initialization.opy','        case Enhancement.BRAIN_KILLER:\n            # No enhancement state slots: bonus damage is calculated directly from the damage event.\n            # HUD lives in ENHANCEMENT HUD (PERMANENT TABLE).\n            break\n','');
 },
 showdown_adjacent_abort_guards(f) {
  const file='objective_types/objective_type_showdown.opy',a='    if currentObjectiveType != ObjectiveType.SHOWDOWN:\n        return\n    if len(objectivePositionList) <= 1:\n        return';assert.equal(f[file].split(a).length-1,2);
  f[file]=f[file].replaceAll(a,'    if currentObjectiveType != ObjectiveType.SHOWDOWN or len(objectivePositionList) <= 1:\n        return');
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30067);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 candidates.combined_recommended=f=>{candidates.remove_empty_boss_switch_arms(f);candidates.remove_empty_brain_killer_arm(f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   let dispatchCases=0;
   if(name==='remove_empty_boss_switch_arms'||name==='combined_recommended') dispatchCases+=auditSwitchRemoval(before['objectivesManagement #1'],after['objectivesManagement #1'],'Global.phaseSlot10',2,2);
   if(name==='remove_empty_brain_killer_arm'||name==='combined_recommended') dispatchCases+=auditSwitchRemoval(before['PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION #1'],after['PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION #1'],'(Event Player).enhancementId',1,3);
   if(dispatchCases) row.compiledDispatchCases=dispatchCases;
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30052);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(Object.keys(after),Object.keys(before));
    for(const n of Object.keys(before)) assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
    assert.deepEqual(row.changedRules.slice().sort(),['objectivesManagement #1','PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION #1'].sort());
    row.sameVariablesRulesAndConditions=true;row.emptyCasesStillPerformNoActions=true;row.otherSwitchArmsAndSurroundingActionsUnchanged=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-sixteenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-sixteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-sixteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef,auditSwitchRemoval};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
