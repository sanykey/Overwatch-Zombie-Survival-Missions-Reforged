const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {candidates,files,baselineRef,actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function rules(s) {
 const counts={};
 return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
  const name=x.match(/^rule \("(.*)"\)/)[1],id=counts[name]=(counts[name]||0)+1;
  return [name+' #'+id,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
 }));
}
(async()=>{
 const expectedSources={...files};
 for(const n of ['camera_compare_toggle','revive_initial_constant','pup_common_color_and_beam','smolder_common_enrage_prefix']) candidates[n](expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 for(const n of changedFiles) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply')) assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidate: ${n}`);
 }
 if(process.argv.includes('--apply')) for(const n of changedFiles) {
  const target=path.join('src',n),current=fs.readFileSync(target,'utf8');
  fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);
 }
 await compiler.readyPromise;
 const r=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(r.nbElements,30042);assert.deepEqual(r.encounteredWarnings,[]);
 const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-seventeenth-probe-combined_recommended.ws.txt'),'utf8'));
 const actual=rules(r.result);assert(Object.keys(actual).length>100);assert.deepEqual(actual,expected,'Executable rules must match the audited candidate');
 const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-seventeenth-probe-baseline.ws.txt'),'utf8'),before=rules(baseline);
 const addedSubroutines=Object.keys(actual).filter(n=>!Object.hasOwn(before,n));
 assert.deepEqual(addedSubroutines.slice().sort(),['resetPupColorAndBeam #1','beginSmolderEnrage #1'].sort());
 assert.equal(Object.keys(actual).length,Object.keys(before).length+2);
 const bodies={};
 for(const n of addedSubroutines) {
  const helper=n.slice(0,-3);assert(helper.length<=31);assert(actual[n].includes('event { Subroutine;'));
  const body=actionList(actual[n]);assert(body.every(a=>!/^Wait|^Start Rule|^Abort|^Loop|^Skip|^If\(/.test(a)));bodies[helper]=body;
 }
 for(const n of Object.keys(before)) if(Object.keys(bodies).some(h=>actual[n].includes('Call Subroutine('+h+');'))) assert.deepEqual(expandedActions(actual[n],bodies),expandedActions(before[n]),'Extracted helpers must preserve actions and jump targets: '+n);
 const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline));assert.equal(variables(r.result),variables(baseline));
 for(const n of Object.keys(before)) {assert(actual[n]);assert.equal(actual[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
 const changedRules=Object.keys(actual).filter(n=>before[n]!==actual[n]);
 assert.deepEqual(changedRules.filter(n=>Object.hasOwn(before,n)).sort(),['CYCLE PLAYER CAMERA #1','PLAYER INITIALIZATION #1','P.U.P. TARGET #1','P.U.P. CONTROL #1','PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION #1','SMOLDER ACTIVATES FROM DAMAGE #1','SMOLDER ACTIVATED FROM BOSS EVENT #1'].sort());
 assert.equal(actual['selectTarget #1'],before['selectTarget #1']);
 fs.writeFileSync('main.ws.txt',r.result);
 const report={compiler:ext,baselineRef,baseline:30052,elements:r.nbElements,saved:30052-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsAndExistingConditionsUnchanged:true,helperExpansionRestoresActionsAndJumps:true,firstVisibleTargetLoopUnchanged:true,changedFiles,addedSubroutines,changedRules,inGameValidation:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-17-seventeenth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
