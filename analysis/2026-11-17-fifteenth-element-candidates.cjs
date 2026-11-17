// Read-only measurements against the committed baseline.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='7be5c02cb9f9f84589bed4bf19ef535bec1bbaad';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
const candidates={
 dash_sign_boolean_difference(f) {
  for(const axis of ['x','z']) replace(f,'abilities/augment_dash.opy',`1 if augmentDashDirection.${axis} > 0 else -1 if augmentDashDirection.${axis} < 0 else 0`,`(augmentDashDirection.${axis} > 0) - (augmentDashDirection.${axis} < 0)`);
 },
 dash_zero_vector_false_compare(f) {
  replace(f,'abilities/augment_dash.opy','        if augmentDashDirection != vect(0, 0, 0):','        # This value is always vect(-1/0/1, 0, -1/0/1); only its zero vector equals False.\n        if augmentDashDirection != false:');
 },
 difficulty_shared_tables(f) {
  const file='core/subroutines.opy',start=f[file].indexOf('        #Difficulty: 1 Player "Normal"\n'),end=f[file].indexOf('\n\n\ndef setPrematchTimer():',start);assert(start>=0&&end>start);
  f[file]=f[file].slice(0,start)+`        # Retain the raw player count; only table selection uses this synchronous index.
        #!define difficultyStatTableIndex tmp0
        difficultyStatTableIndex = 0 if difficultySetting == Difficulty.NORMAL else 1 if difficultySetting == Difficulty.HARD else 3 if difficultySetting >= Difficulty.LEGENDARY else 2
        if difficultyStatTableIndex == 1:
            botHealthList[18] = 750
        elif difficultyStatTableIndex == 3:
            botHealthList = numbersList.slice(NL_BOT_HEALTH_LEGENDARY_OFFSET, NL_BOT_HEALTH_LEGENDARY_LEN)
        elif difficultyStatTableIndex == 2:
            botHealthList[18] = 1000
        # All four rows have 22 entries; preserve bite damage -> duration -> throttle -> damage order.
        botBiteDamageList = numbersList.slice([NL_BITE_DAMAGE_NORMAL_OFFSET, NL_BITE_DAMAGE_HARD_OFFSET, NL_BITE_DAMAGE_EXPERT_OFFSET, NL_BITE_DAMAGE_LEGENDARY_OFFSET][difficultyStatTableIndex], NL_BITE_DAMAGE_NORMAL_LEN)
        if difficultyStatTableIndex < 2:
            botBiteDurationList = numbersList.slice([NL_BITE_DURATIONS_NORMAL_OFFSET, NL_BITE_DURATIONS_HARD_OFFSET][difficultyStatTableIndex], NL_BITE_DURATIONS_NORMAL_LEN)
        botThrottleSpeedList = numbersList.slice([NL_THROTTLE_SPEEDS_NORMAL_OFFSET, NL_THROTTLE_SPEEDS_HARD_OFFSET, NL_THROTTLE_SPEEDS_EXPERT_OFFSET, NL_THROTTLE_SPEEDS_LEGENDARY_OFFSET][difficultyStatTableIndex], NL_THROTTLE_SPEEDS_NORMAL_LEN)
        botDamageDealtList = numbersList.slice([NL_DAMAGE_DEALT_NORMAL_OFFSET, NL_DAMAGE_DEALT_HARD_OFFSET, NL_DAMAGE_DEALT_EXPERT_OFFSET, NL_DAMAGE_DEALT_LEGENDARY_OFFSET][difficultyStatTableIndex], NL_DAMAGE_DEALT_NORMAL_LEN)`+f[file].slice(end);
 },
 satellite_local_progress(f) {
  const file='objective_types/objective_type_satellite_uplink.opy';
  const start=f[file].indexOf('    for satelliteRepairTerminalIndex in range('),end=f[file].indexOf('    #All terminals repaired\n',start);assert(start>=0&&end>start);
  f[file]=f[file].slice(0,start)+`    # Local numeric progress is dead before completion effects and before the rule's waits.
    #!define satelliteRepairProgress tmp2
    for satelliteRepairTerminalIndex in range(len(satelliteTerminalPositionList)):
        satelliteRepairProgress = satelliteTerminalProgressList[satelliteRepairTerminalIndex]
        if satelliteRepairProgress < 100:
            satelliteRepairPlayerCount = len(objectivePlayerList.filter(lambda x: distance(satelliteTerminalPositionList[satelliteRepairTerminalIndex], x) < objectiveRad))
            if satelliteRepairPlayerCount:
                if satelliteRepairPlayerCount > 1:
                    satelliteRepairProgress += 0.4
                # Keep both additions separate: collapsing them to 1.5 changes rounding.
                satelliteRepairProgress += 1.1
                satelliteTerminalProgressList[satelliteRepairTerminalIndex] = min(100, satelliteRepairProgress)
                if satelliteRepairProgress >= 100:
                    bigMessage(getAllPlayers(), "A terminal is back online!")
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, objectiveColor, satelliteTerminalPositionList[satelliteRepairTerminalIndex], objectiveRad * 2)
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, objectiveColor, satelliteTerminalPositionList[satelliteRepairTerminalIndex], 100)
`+f[file].slice(end);
 },
 mission_spacing_snapshot(f) {
  const file='game/global_start_menu.opy',a='distance(x, objectivePositionList.last()) > objectiveSpacingList[0] and distance(x, objectivePositionList.last()) < min(100, objectiveSpacingList[0] * 3)';
  replace(f,file,a,'distance(x, objectivePositionList.last()) > missionMinimumSpacing and distance(x, objectivePositionList.last()) < min(100, missionMinimumSpacing * 3)');
  replace(f,file,'            missionCandidatePosition = random.choice(', '            # Synchronous spacing read; consumed by the candidate query before wait.\n            #!define missionMinimumSpacing tmp0\n            missionMinimumSpacing = objectiveSpacingList[0]\n            missionCandidatePosition = random.choice(');
 },
};
async function main() {
 await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30081);assert.deepEqual(baseline.encounteredWarnings,[]);const before=rules(baseline.result);
 const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
 const edges=[-1,-0.5,-0.00001,-1e-30,-Number.MIN_VALUE,-0,0,Number.MIN_VALUE,1e-30,0.00001,0.5,1];
 const oldSign=x=>x>0?1:x<0?-1:0,nextSign=x=>Number(x>0)-Number(x<0);
 let axisCases=0,directionCases=0;
 for(const x of edges) {assert.equal(oldSign(x),nextSign(x));axisCases++;}
 let seed=150017;const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296*2-1;};
 for(let i=0;i<20000;i++) {
  const x=i<edges.length?edges[i]:random(),z=i<edges.length?edges[edges.length-1-i]:random();
  for(const v of [x,z,Math.fround(x),Math.fround(z)]) {assert.equal(oldSign(v),nextSign(v));axisCases++;}
  assert.deepEqual([oldSign(x),0,oldSign(z)],[nextSign(x),0,nextSign(z)]);directionCases++;
 }
 // Workshop vector/False equality follows the comparison contract in AGENTS.md.
 // Only these nine vectors reach the impulse gate; arrays, players and scalar values cannot.
 let vectorGateCases=0;
 for(const x of [-1,0,1]) for(const z of [-1,0,1]) {
  const value=[x,0,z],oldGate=value.some(v=>v!==0),equalsFalse=value.every(v=>v===0);
  assert.equal(oldGate,!equalsFalse);vectorGateCases++;
 }
 report.axisModelCases=axisCases;report.directionModelCases=directionCases;report.vectorGateCases=vectorGateCases;
 candidates.combined_recommended=f=>{candidates.dash_sign_boolean_difference(f);candidates.dash_zero_vector_false_compare(f);};
 console.log(JSON.stringify({baseline:report.baseline}));
 for(const [name,fn] of Object.entries(candidates)) {
  const f={...files};try {fn(f);const r=await compile(f),after=rules(r.result);
   const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:[...new Set([...Object.keys(before),...Object.keys(after)])].filter(n=>before[n]!==after[n])};
   if(name==='combined_recommended') {
    assert.equal(r.nbElements,30067);assert.deepEqual(r.encounteredWarnings,[]);
    const variables=s=>s.match(/^variables\s*\{[^}]*\}/m)?.[0];assert(variables(baseline.result));assert.equal(variables(r.result),variables(baseline.result));
    assert.deepEqual(Object.keys(after),Object.keys(before));assert.deepEqual(row.changedRules,['useAugmentAirAction #1']);
    for(const n of Object.keys(before)) assert.equal(after[n].match(/conditions \{.*?\}/)?.[0],before[n].match(/conditions \{.*?\}/)?.[0]);
    const air=after['useAugmentAirAction #1'];
    assert(air.includes('Vector(Subtract(Compare(X Component Of(Global.tmp0), >, Null), Compare(X Component Of(Global.tmp0), <, Null)), False, Subtract(Compare(Z Component Of(Global.tmp0), >, Null), Compare(Z Component Of(Global.tmp0), <, Null)))'));
    assert(air.includes('Skip If(Compare(Global.tmp0, ==, False), True);'));
    assert(!air.includes('Normalize('));
    row.sameVariablesRulesAndConditions=true;row.explicitFalseComparisonInCompiledGate=true;row.noNormalizationOrDivision=true;
   }
   report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-fifteenth-probe-'+name+'.ws.txt'),r.result);
  }catch(e){const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
 }
 fs.writeFileSync(path.join(__dirname,'2026-11-17-fifteenth-probe-baseline.ws.txt'),baseline.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-17-fifteenth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={candidates,files,baselineRef};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
