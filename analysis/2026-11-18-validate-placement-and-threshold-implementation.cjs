const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const placement=require('./2026-11-18-twenty-eighth-element-candidates.cjs');
const thresholds=require('./2026-11-18-twenty-seventh-element-candidates.cjs');
const {files,baselineRef,compile,rules}=placement;
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const {actionList,expandedActions}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
(async()=>{
 selfTest();assert.equal(thresholds.baselineRef,baselineRef);assert.deepEqual(thresholds.files,files);
 const expectedSources={...files};placement.candidates.combined_recommended(expectedSources);thresholds.candidates.combined_recommended(expectedSources);
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 for(const n of Object.keys(files)) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply'))assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidates: ${n}`);
 }
 if(process.argv.includes('--apply'))for(const n of changedFiles) {
  const target=path.join('src',n),current=fs.readFileSync(target,'utf8');
  fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);
 }
 await compiler.readyPromise;
 const expected=await compile(expectedSources),baseline=await compile(files);
 assert.equal(baseline.nbElements,29954);assert.equal(expected.nbElements,29928);
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,29928);assert.deepEqual(actual.encounteredWarnings,[]);
 assert.deepEqual(rules(actual.result),rules(expected.result),'Compiled rules must match both reviewed packages');
 assert.deepEqual(nestedPredicates(actual.result),[]);
 const before=rules(baseline.result),after=rules(actual.result),helper='playPlacementWindupFeedback',helperRule=helper+' #1';
 assert(helper.length<=31);assert.deepEqual(Object.keys(after).filter(n=>!Object.hasOwn(before,n)),[helperRule]);
 const body=actionList(after[helperRule]);assert.equal(body.length,2);assert(body.every(a=>a.startsWith('Play Effect(')));assert.equal((body.join(' ').match(/Random Real\(/g)||[]).length,2);
 for(const [n,color] of [['[CHARGE_BATTERY] PLACE BATTERY #1','Yellow'],['CROUCH + INTERACT (LASER BARRICADE) #1','Blue']]) {
  const input=`Set Global Variable(tmp0, Color(${color}));`;assert(after[n].includes(input));
  const restored=after[n].replace(input,'Call Subroutine(dropPlacementInput);');
  const bodies={dropPlacementInput:[],[helper]:body.map(a=>a.replaceAll('Global.tmp0',`Color(${color})`))};
  assert.deepEqual(expandedActions(restored,bodies),expandedActions(before[n]));
 }
 for(const n of Object.keys(before)){assert(after[n]);assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);}
 for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1']){assert(before[n]);assert.equal(after[n],before[n]);}
 const changedRules=Object.keys(after).filter(n=>before[n]!==after[n]);
 assert.deepEqual(changedRules.slice().sort(),['BOSS DIES (ALL BOSS OBJECTIVES) #1','REVIVE PLAYER OR ADVANCE DEATH TIMER #1','[CHARGE_BATTERY] PLACE BATTERY #1','CROUCH + INTERACT (LASER BARRICADE) #1',helperRule].sort());
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:29954,elements:actual.nbElements,saved:26,warnings:actual.encounteredWarnings,compiledRulesMatchAuditedCandidates:true,helperExpansionPreservesColorsActionsJumpsAndRandomDraws:true,variableDeclarationsAndExistingConditionsUnchanged:true,firstVisibleTargetLoopAndCarryReleaseUnchanged:true,nestedArrayPredicates:[],addedSubroutines:[helperRule],changedFiles,changedRules,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,'2026-11-18-placement-and-threshold-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
