// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='1fff49d4114a55926fd4935a0c51e71ab9f54c9b';
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
 for(let i=0;i<s.length;i++) {const c=s[i];if(quote) {if(escape)escape=false;else if(c==='\\')escape=true;else if(c==='"')quote=false;continue;}if(c==='"')quote=true;else if(c==='(')depth++;else if(c===')')depth--;else if(c===separator&&depth===0) {result.push(s.slice(start,i).trim());start=i+1;}}
 assert.equal(depth,0);assert(!quote);result.push(s.slice(start).trim());return result;
}
function call(s) {const i=s.indexOf('(');assert(i>=0&&s.endsWith(')'),s);return {name:s.slice(0,i),args:splitTop(s.slice(i+1,-1),',')};}
function numeric(s) {if(['Null','False'].includes(s))return 0;if(s==='True')return 1;assert(Number.isFinite(Number(s)),s);return Number(s);}
function actionList(rule) {const body=rule.match(/ actions \{ (.*?) \} \}$/)?.[1];assert(body);const parts=splitTop(body,';');assert.equal(parts.pop(),'');return parts.map(s=>s+';');}
function expandedActions(rule,bodies={}) {
 const actions=actionList(rule),chunks=[],offsets=[];let offset=0;
 for(const action of actions) {
  offsets.push(offset);const match=action.match(/^Call Subroutine\((\w+)\);$/);
  const chunk=match&&bodies[match[1]]?bodies[match[1]]:[action];chunks.push(chunk);offset+=chunk.length;
 }
 offsets.push(offset);
 for(let i=0;i<actions.length;i++) {
  if(chunks[i].length!==1)continue;const a=actions[i];
  if(!a.startsWith('Skip(')&&!a.startsWith('Skip If('))continue;
  const c=call(a.slice(0,-1)),mapped=n=>{const target=i+1+n;assert(Number.isInteger(n)&&n>=0&&target<=actions.length);return offsets[target]-offsets[i+1];};
  const scalar=c.args[c.args.length-1];
  if(/^(?:\d+|Null|False|True)$/.test(scalar)) {
   chunks[i]=[c.name==='Skip'?`Skip(${mapped(numeric(scalar))});`:`Skip If(${c.args[0]}, ${mapped(numeric(scalar))});`];continue;
  }
  assert.equal(c.name,'Skip');const value=call(c.args[0]);assert.equal(value.name,'Value In Array');
  const table=call(value.args[0]);assert.equal(table.name,'Array');
  // Rebase every compiled switch offset when a Call expands to its original actions.
  chunks[i]=[`Skip(Value In Array(Array(${table.args.map(x=>mapped(numeric(x))).join(', ')}), ${value.args[1]}));`];
 }
 return chunks.flat();
}
function addHelper(f,file,name,body) {
 assert(name.length<=31);f[file]=f[file].replace(/^(#!mainFile [^\n]+\n)/,'$1subroutine '+name+'\n');
 f[file]+='\n\ndef '+name+'():\n    @Name "'+name+'"\n    # Synchronous only: retain caller eventPlayer, action order and all surrounding waits.\n'+body.map(s=>'    '+s).join('\n')+'\n';
}
const candidates={
 camera_compare_toggle(f) {
  replace(f,'game/player_camera.opy','eventPlayer.cameraMode = (eventPlayer.cameraMode + 1) % 2','eventPlayer.cameraMode = eventPlayer.cameraMode != CameraMode.PRECISE');
 },
 camera_boolean_toggle(f) {
  replace(f,'game/player_camera.opy','eventPlayer.cameraMode = (eventPlayer.cameraMode + 1) % 2','eventPlayer.cameraMode = not eventPlayer.cameraMode');
  replace(f,'core/variables.opy','# Human camera preference (0/1/2), retained across respawns and hero changes.','# Human camera preference (0/1, including equivalent False/True), retained across respawns and hero changes.');
 },
 revive_initial_constant(f) {replace(f,'game/players_game_in_progress.opy','    eventPlayer.reviveDuration = 5\n    eventPlayer.reviveTimeRemaining = eventPlayer.reviveDuration','    eventPlayer.reviveDuration = 5\n    eventPlayer.reviveTimeRemaining = 5');},
 pup_common_color_and_beam(f) {
  let count=0;
  for(const file of ['abilities/enhancements.opy','abilities/player_initialization.opy']) f[file]=f[file].replace(/^([ \t]+)eventPlayer\.enhancementPupColor = Color\.SKY_BLUE\n\1#Beam visibility\n\1eventPlayer\.enhancementIsPupBeamActive = false/gm,(_,indent)=>{count++;return indent+'resetPupColorAndBeam()';});
  assert.equal(count,5);
  addHelper(f,'abilities/enhancements.opy','resetPupColorAndBeam',['eventPlayer.enhancementPupColor = Color.SKY_BLUE','eventPlayer.enhancementIsPupBeamActive = false']);
 },
 smolder_common_enrage_prefix(f) {
  const file='game/zombie_types.opy',a='    eventPlayer.botSmolderState = 2\n    stopChasing(eventPlayer.botSmolderAnger)\n    eventPlayer.stopForcingButton(Button.CROUCH)';assert.equal(f[file].split(a).length-1,2);
  f[file]=f[file].replaceAll(a,'    beginSmolderEnrage()');
  addHelper(f,file,'beginSmolderEnrage',['eventPlayer.botSmolderState = 2','stopChasing(eventPlayer.botSmolderAnger)','eventPlayer.stopForcingButton(Button.CROUCH)']);
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30052);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 assert.equal((Object.values(files).join('\n').match(/\.cameraMode\s*=(?!=)/g)||[]).length,1,'Camera mode has only its toggle writer');
 let cameraCases=0;
 for(const initial of [0,1,2,null,false,true]) {
  let old=initial,next=initial;
  for(let i=0;i<100;i++) {
   old=(Number(old)+1)%2;next=Number(next)!==1;
   assert.equal(Number(next),old);assert.equal(next==1,old===1);
   assert.equal(['Normal','Precise'][Number(next)],['Normal','Precise'][old]);cameraCases++;
  }
 }
 report.cameraTransitionModelCases=cameraCases;
 report.cameraNotToggleCounterexample={initial:2,original:(2+1)%2,notToggle:Number(!2)};
 candidates.combined_recommended=f=>{for(const n of ['camera_compare_toggle','revive_initial_constant','pup_common_color_and_beam','smolder_common_enrage_prefix']) candidates[n](f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   const added=Object.keys(after).filter(n=>!Object.hasOwn(before,n));
   if(added.length) {
    const bodies={};
    for(const n of added) {
     const helper=n.slice(0,-3);assert(helper.length<=31);assert(after[n].includes('event { Subroutine;'));
     const body=actionList(after[n]);assert(body.every(a=>!/^Wait|^Start Rule|^Abort|^Loop|^Skip|^If\(/.test(a)));bodies[helper]=body;
    }
    for(const n of Object.keys(before)) if(Object.keys(bodies).some(h=>after[n].includes('Call Subroutine('+h+');'))) assert.deepEqual(expandedActions(after[n],bodies),expandedActions(before[n]),'Helper extraction must restore exact compiled actions and jump targets: '+n);
    row.addedSubroutines=added;row.helperExpansionRestoresActionsAndJumps=true;
   }
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30042);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(added.slice().sort(),['resetPupColorAndBeam #1','beginSmolderEnrage #1'].sort());
    for(const n of Object.keys(before)) {assert(after[n]);assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
    const changedExisting=row.changedRules.filter(n=>Object.hasOwn(before,n));
    assert.deepEqual(changedExisting.slice().sort(),['CYCLE PLAYER CAMERA #1','PLAYER INITIALIZATION #1','P.U.P. TARGET #1','P.U.P. CONTROL #1','PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION #1','SMOLDER ACTIVATES FROM DAMAGE #1','SMOLDER ACTIVATED FROM BOSS EVENT #1'].sort());
    assert.equal(after['selectTarget #1'],before['selectTarget #1']);
    row.sameVariablesAndExistingConditions=true;row.firstVisibleTargetLoopUnchanged=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-seventeenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-seventeenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-seventeenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef,actionList,expandedActions};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
