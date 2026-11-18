const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {expandedActions,actionList}=require('./2026-11-17-seventeenth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='c805b4e3f9a8a6314710082ffcb21c955c22c524';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
files.__numbersGenerator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
function extract(f,name,lines,count){let found=0;for(const file of names.map(n=>n.slice(4))){const pattern=new RegExp('^([ \\t]+)'+lines.map(s=>s.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')).join('\\n\\1'),'gm');f[file]=f[file].replace(pattern,(_,indent)=>{found++;return indent+name+'()';});}assert.equal(found,count,name);const file='core/subroutines.opy';f[file]=f[file].replace(/^(#!mainFile [^\n]+\n)/,'$1subroutine '+name+'\n');f[file]+='\n\ndef '+name+'():\n    @Name "'+name+'"\n    # Synchronous: preserve action order and eventPlayer; no waits or scratch.\n'+lines.map(s=>'    '+s).join('\n')+'\n';}
const helpers={
 lockBotMovementFlags:['eventPlayer.botIsThrottleOverridden = true','eventPlayer.botIsFacingOverridden = true'],
 restoreBotWallCollision:['eventPlayer.botIsWallCollisionEnabled = true','eventPlayer.enableEnvironmentCollision()'],
 restoreBotFacing:['eventPlayer.botIsFacingOverridden = false','restoreDefaultFacingMovement()'],
};
const candidates=Object.fromEntries(Object.entries(helpers).map(([name,lines])=>[name,f=>extract(f,name,lines,3)]));
candidates.combined=f=>Object.keys(helpers).forEach(name=>candidates[name](f));
candidates.satellite_center_beam_loop=f=>{
 const file='objective_types/objective_type_satellite_uplink.opy',start=f[file].indexOf('    #Laser center beam\n'),end=f[file].indexOf('    #Sattellite firing light shafts\n',start);assert(start>=0&&end>start);
 const old=f[file].slice(start,end);assert.equal(old.split('createBeam(').length-1,2);
 f[file]=f[file].slice(0,start)+`    # Two rotating center beams, preserving creation order: positive, then negative.
    # Only the side is captured; laser position and rotation keep reevaluating.
    # Scratch is dead after both Create Beam actions; the shaft loop reuses tmp0 below.
    #!define satelliteCenterBeamSide tmp0
    for satelliteCenterBeamSide in range(1, -2, -2):
        createBeam(getAllPlayers(), Beam.BAD, satelliteLaserPosition + 700 * Vector.UP + directionFromAngles(getTotalTimeElapsed() * 360, 0) * evalOnce(satelliteCenterBeamSide), satelliteLaserPosition + -700 * Vector.UP + directionFromAngles(getTotalTimeElapsed() * 360, 0) * evalOnce(satelliteCenterBeamSide), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
`+f[file].slice(end);
};
async function audit(baseline,result,helperNames){
 const before=rules(baseline.result),after=rules(result.result),bodies=Object.fromEntries(helperNames.map(n=>[n,actionList(after[n+' #1'])]));
 assert.deepEqual(Object.keys(after).filter(n=>!helperNames.some(h=>n===h+' #1')),Object.keys(before));
 for(const name of Object.keys(before)){
  assert.equal(after[name].match(/conditions \{.*?\}/)?.[0],before[name].match(/conditions \{.*?\}/)?.[0],name);
  assert.deepEqual(expandedActions(after[name],bodies),expandedActions(before[name]),name);
 }
 for(const body of Object.values(bodies)){assert.equal(body.length,2);assert(body.every(s=>!/^Wait|^Start Rule/.test(s)));}
 const vars=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(vars(baseline.result));assert.equal(vars(result.result),vars(baseline.result));
 assert.deepEqual(nestedPredicates(result.result),[]);assert.deepEqual(result.encounteredWarnings,[]);
 return {changedRules:Object.keys(before).filter(n=>before[n]!==after[n]),addedSubroutines:helperNames,allOriginalActionsEqualAfterExpansion:true,conditionsAndVariablesUnchanged:true,nestedArrayPredicates:[]};
}
async function main(){const baseline=await compile(files);assert.equal(baseline.nbElements,29871);const report={baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};for(const [name,fn] of Object.entries(candidates)){const f={...files};fn(f);const result=await compile(f);let validation;if(name==='satellite_center_beam_loop'){const before=rules(baseline.result),after=rules(result.result);assert.deepEqual(Object.keys(before),Object.keys(after));assert.deepEqual(nestedPredicates(result.result),[]);validation={changedRules:Object.keys(before).filter(n=>before[n]!==after[n]),detailedValidation:'2026-11-18-validate-thirty-second-element-candidates.cjs'};}else validation=await audit(baseline,result,name==='combined'?Object.keys(helpers):[name]);const row={name,elements:result.nbElements,saved:baseline.nbElements-result.nbElements,warnings:result.encounteredWarnings,...validation};report.results.push(row);console.log(row);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-second-'+name+'.ws.txt'),result.result);}fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-second-baseline.ws.txt'),baseline.result);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-second-element-candidates.json'),JSON.stringify(report,null,2)+'\n');}
const recommended=['satellite_center_beam_loop'];
module.exports={files,candidates,helpers,recommended,baselineRef,compile,rules,audit};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
