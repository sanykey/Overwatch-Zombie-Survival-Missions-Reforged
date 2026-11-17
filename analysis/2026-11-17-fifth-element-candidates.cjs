// Read-only candidate measurements against the current 30,250-element build.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='c9b8d180fe9466a021d8d858e1795846763f30c6';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function region(f,file,a,b,fn) {const i=f[file].indexOf(a),j=f[file].indexOf(b,i+a.length);assert(i>=0&&j>i,a);f[file]=f[file].slice(0,i)+fn(f[file].slice(i,j))+f[file].slice(j);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
    direct_biowaste_carrier(f) {
        region(f,'objective_types/objective_type_biomorphing.opy','        # biowasteCarrierIndex:','        biowasteCarrier.biomorphingResourceAmount',()=>
            '        #!define biowasteCarrier tmp1\n        biowasteCarrier = getPlayers(Team.2).filter(lambda player: player.biomorphingResourceAmount != BIOMORPHING_RESOURCE_AMOUNT)[0]\n');
    },
    inline_biowaste_pickup_position(f) {
        const file='objective_types/objective_type_biomorphing.opy';
        region(f,file,'    # biowastePickupPosition:','    eventPlayer.biomorphingResourceType = biomorphingResourceTypeList[biowastePickupIndex]',()=>
            '    #!define biowastePickupIndex tmp1\n    biowastePickupIndex = biomorphingResourcePositionList.index(sorted(biomorphingResourcePositionList, lambda x: distance(eventPlayer, x))[0])\n');
    },
    equal_spawn_weights_map(f) {
        const file='game/global_start_menu.opy';
        region(f,file,'        botSpawnRateList = []\n        # Keep the original 19 eligible heroes','        botSpawnRateList[21] = 5',()=>
            '        botSpawnRateList = botHeroList.slice(0, 19).map(lambda _: 5)\n');
    },
    biowaste_deposit_divisor(f) {
        region(f,'objective_types/objective_type_biomorphing.opy','    biowasteDepositTimeDivisor = 8.9','    #Damage player if resource is blood',()=>
            '    biowasteDepositTimeDivisor = 2.9 if biomorphingGoalQueueList[0] == eventPlayer.biomorphingResourceType else 8.9\n');
    },
    mission_position_single_assignment(f) {
        const file='game/global_start_menu.opy';
        const line=f[file].split('\n').find(x=>x.startsWith('            missionCandidatePosition = random.choice('));
        assert(line);
        replace(f,file,line+'\n            missionCandidatePosition += Vector.UP',line+' + Vector.UP');
    },
    rescue_prefix_slice(f) {
        replace(f,'objective_types/objective_type_survivor_rescue.opy',
            'rescueSurvivor.rescuePathList.remove(rescueSurvivor.rescuePathList.filter(lambda _, i: i <= rescueReachedPathIndex))',
            'rescueSurvivor.rescuePathList.remove(rescueSurvivor.rescuePathList.slice(0, rescueReachedPathIndex + 1))');
    },
    mixed_objective_suffix_slice(f) {
        replace(f,'game/global_start_menu.opy',
            'objectiveTypeList.filter(lambda _, i: i > len(objectiveTypeList) - 1 - (len(mixedObjectiveTypeList) - 1))',
            'objectiveTypeList.slice(max(0, len(objectiveTypeList) + 1 - len(mixedObjectiveTypeList)), len(mixedObjectiveTypeList))');
    },
    mission_zero_vector(f) {
        replace(f,'game/global_start_menu.opy','isInLoS(missionCandidatePosition + vect(0, 0, 0), missionCandidatePosition + 10 * Vector.UP)',
            'isInLoS(missionCandidatePosition, missionCandidatePosition + 10 * Vector.UP)');
    },
    supply_zero_vector(f) {
        replace(f,'items/supply_drops.opy','supplyDropLandingPosition + 2 * Vector.UP, supplyDropLandingPosition + vect(0, 0, 0)',
            'supplyDropLandingPosition + 2 * Vector.UP, supplyDropLandingPosition');
    },
    satellite_zero_vector(f) {
        replace(f,'objective_types/objective_type_satellite_uplink.opy','satelliteTerminalPositionList[evalOnce(satelliteFiringTerminalIndex)] + vect(0, 0, 0)',
            'satelliteTerminalPositionList[evalOnce(satelliteFiringTerminalIndex)]');
    },
    unit_multipliers(f) {
        replace(f,'core/subroutines.opy','1 * eventPlayer.sizeScale','eventPlayer.sizeScale');
        replace(f,'game/zombie_types.opy','evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1',
            'evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90)))');
    },
    showdown_revalidation(f) {
        const file='objective_types/objective_type_showdown.opy';
        const text='    if currentObjectiveType != ObjectiveType.SHOWDOWN:\n        return\n    if len(objectivePositionList) <= 1:\n        return\n';
        assert.equal(f[file].split(text).length-1,2);
        f[file]=f[file].replaceAll(text,'    if currentObjectiveType != ObjectiveType.SHOWDOWN or len(objectivePositionList) <= 1:\n        return\n');
    },
};
async function main() {
    await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30250);const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    let carrierModelCases=0;
    const valueAt=(a,i)=>i>=0&&i<a.length?a[i]:0;
    for(let n=0;n<=8;n++) for(let mask=0;mask<(1<<n);mask++) {
        const players=Array.from({length:n},(_,i)=>i+1);
        const eligible=players.filter((_,i)=>!!(mask&(1<<i)));
        const selected=valueAt(eligible,0);
        const old=valueAt(players,players.indexOf(selected));
        assert.equal(old,selected);carrierModelCases++;
    }
    report.carrierModelCases=carrierModelCases;
    const goalTypes=[0,1,2,3];
    for(const goal of goalTypes) for(const type of goalTypes) {
        let old=8.9;if(goal===type) old=2.9;
        assert.equal(old,goal===type?2.9:8.9);
    }
    report.depositDivisorModelCases=16;
    candidates.combined_recommended=f=>{
        candidates.direct_biowaste_carrier(f);
        candidates.inline_biowaste_pickup_position(f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-fifth-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-fifth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-fifth-probe-baseline.ws.txt'),baseline.result);
}
main().catch(e=>{console.error(e);process.exitCode=1;});
