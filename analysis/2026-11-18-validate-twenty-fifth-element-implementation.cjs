const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {files,candidates,baselineRef,compile,rules}=require('./2026-11-18-twenty-fifth-element-candidates.cjs');
const {nestedPredicates,selfTest}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
(async()=>{
 selfTest();const expectedSources={...files};candidates.combined_recommended(expectedSources);
 const includeVote=process.argv.includes('--include-vote');
 if(includeVote)require('./2026-11-18-twenty-fourth-element-candidates.cjs').candidates.vote_winner_initializes_result(expectedSources);
 const expectedElements=includeVote?29971:29974;
 const changedFiles=Object.keys(files).filter(n=>files[n]!==expectedSources[n]);
 for(const n of Object.keys(files)) {
  const current=fs.readFileSync(path.join('src',n),'utf8').replace(/\r\n/g,'\n');
  if(process.argv.includes('--apply'))assert(current===files[n]||current===expectedSources[n],`Unreviewed changes in ${n}`);
  else assert.equal(current,expectedSources[n],`Source differs from reviewed candidate: ${n}`);
 }
 if(process.argv.includes('--apply'))for(const n of changedFiles) {
  const target=path.join('src',n),current=fs.readFileSync(target,'utf8');
  fs.writeFileSync(target,current.includes('\r\n')?expectedSources[n].replace(/\n/g,'\r\n'):expectedSources[n]);
 }
 await compiler.readyPromise;
 const expected=await compile(expectedSources),baseline=await compile(files);
 assert.equal(baseline.nbElements,30004);assert.equal(expected.nbElements,expectedElements);
 const actual=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.equal(actual.nbElements,expectedElements);assert.deepEqual(actual.encounteredWarnings,[]);
 assert.deepEqual(rules(actual.result),rules(expected.result),'Compiled rules must match reviewed candidates');
 assert.deepEqual(nestedPredicates(actual.result),[]);
 const before=rules(baseline.result),after=rules(actual.result);
 assert.deepEqual(Object.keys(after),Object.keys(before));
 const changedRules=Object.keys(before).filter(n=>before[n]!==after[n]);
 const expectedRules=['explosionSequence #1','RUSHER MOLTEN CORE BURNS PLAYERS (BOSS) #1','BEHEMOTH (ROAD) TOXIC CLOUD #1','BLASTER ROCKET HITS TARGET #1',Object.keys(before).find(n=>n.startsWith('PLAYER DEALT FINAL'))];
 if(includeVote)expectedRules.push('determineZombieMode #1','determineObjectiveType #1','Subroutine selectVoteWinner #1');
 assert.deepEqual(changedRules.slice().sort(),expectedRules.sort());
 for(const n of Object.keys(before))assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
 for(const n of ['selectTarget #1','LIVING PROJECTILE RELEASE #1','BOT INITIALIZATION #1'])assert.equal(after[n],before[n]);
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(actual.result),vars(baseline.result));
 fs.writeFileSync('main.ws.txt',actual.result);
 const report={compiler:ext,baselineRef,baseline:30004,elements:actual.nbElements,saved:30004-actual.nbElements,voteInitializationIncluded:includeVote,warnings:actual.encounteredWarnings,compiledRulesMatchAuditedCandidates:true,variableDeclarationsUnchanged:true,allConditionsUnchanged:true,firstVisibleTargetLoopAndCarryReleaseUnchanged:true,nestedArrayPredicates:[],changedFiles,changedRules,inGameValidation:false,serverLoadMeasured:false};
 fs.writeFileSync(path.join(__dirname,includeVote?'2026-11-18-vote-and-dot-implementation.json':'2026-11-18-twenty-fifth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
