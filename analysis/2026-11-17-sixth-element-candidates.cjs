// Read-only probes against the current working tree (30,236 elements).
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='031ecfbdb4d612b60a6f1eb8f7a3b6b80974ad06';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
    teleport_merged_filters(f) {
        const file='game/bots_game_in_progress.opy';
        replace(f,file,'teleportCandidateSpawnPointList = botSpawnPointList.filter(lambda x: distance(x, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE)',
            'teleportCandidateSpawnPointList = botSpawnPointList.filter(lambda x: distance(x, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE and botSpawnPointTimerList[botSpawnPointList.index(x)] < 15)');
        replace(f,file,'                teleportCandidateSpawnPointList = teleportCandidateSpawnPointList.filter(lambda x: botSpawnPointTimerList[botSpawnPointList.index(x)] < 15)\n','');
    },
    teleport_indexed_filter(f) {
        candidates.teleport_merged_filters(f);
        replace(f,'game/bots_game_in_progress.opy',
            'botSpawnPointList.filter(lambda x: distance(x, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE and botSpawnPointTimerList[botSpawnPointList.index(x)] < 15)',
            'botSpawnPointList.filter(lambda x, i: distance(x, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE and botSpawnPointTimerList[i] < 15)');
    },
    teleport_redundant_nonempty(f) {
        replace(f,'game/bots_game_in_progress.opy','if botSpawnPointList != [] and teleportCandidateSpawnPointList != []:',
            'if teleportCandidateSpawnPointList != []:');
    },
    teleport_complement_else(f) {
        replace(f,'game/bots_game_in_progress.opy','        elif eventPlayer.botTarget != null:\n            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)',
            '        else:\n            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)');
    },
    engineer_direct_target(f) {
        const file='abilities/enhancements.opy';
        const line=f[file].split('\n').find(x=>x.startsWith('    scrapTransferCandidates = sorted('));
        assert(line);
        replace(f,file,line,line.replace('scrapTransferCandidates =','scrapArmorGrantTarget =')+'[0]');
        replace(f,file,'    if scrapTransferCandidates != []:','    if scrapArmorGrantTarget != null:');
        replace(f,file,'        scrapArmorGrantTarget = scrapTransferCandidates[0]\n','');
    },
    pregame_factor_default_condition(f) {
        replace(f,'game/player_start_menu.opy',
            'eventPlayer.augmentId == Augment.NO_PREFERENCE and (isVoting and (not eventPlayer.pregameChallengeVote and not eventPlayer.pregameZombieVote and not eventPlayer.pregameObjectiveVote and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE) or not isVoting and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE)',
            'eventPlayer.augmentId == Augment.NO_PREFERENCE and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE and (not isVoting or (not eventPlayer.pregameChallengeVote and not eventPlayer.pregameZombieVote and not eventPlayer.pregameObjectiveVote))');
    },
    pregame_horizontal_distance(f) {
        replace(f,'game/player_start_menu.opy',
            'distance(eventPlayer, vect(eventPlayer.pregamePosition.x, eventPlayer.getPosition().y, eventPlayer.pregamePosition.z))',
            'magnitude((eventPlayer.getPosition() - eventPlayer.pregamePosition) * vect(1, 0, 1))');
    },
};
async function main() {
    await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30236);const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    let teleportModelCases=0;
    for(let n=0;n<=4;n++) for(let state=0;state<16**n;state++) {
        const points=Array.from({length:n},(_,i)=>i+1),timers=[],distances=[];
        for(let i=0,value=state;i<n;i++,value=Math.floor(value/16)) {
            const digit=value%16;timers.push([0,14,15,16][digit%4]);distances.push([0,39.999,40,41][Math.floor(digit/4)]);
        }
        const old=points.filter(x=>distances[points.indexOf(x)]<40).filter(x=>timers[points.indexOf(x)]<15);
        const next=points.filter((_,i)=>distances[i]<40&&timers[i]<15);
        assert.deepEqual(old,next);
        assert.equal(points.length>0&&old.length>0,next.length>0);
        teleportModelCases++;
    }
    report.teleportModelCases=teleportModelCases;
    let pregameModelCases=0;
    for(const voting of [false,true,0]) for(const augment of [0,1,7]) for(const enhancement of [0,1,10])
        for(const challengeVote of [0,1,2,5]) for(const zombieVote of [0,1,2,5]) for(const objectiveVote of [0,1,2,5]) {
            const old=augment===0&&(voting&&(!challengeVote&&!zombieVote&&!objectiveVote&&enhancement===0)||!voting&&enhancement===0);
            const next=augment===0&&enhancement===0&&(!voting||(!challengeVote&&!zombieVote&&!objectiveVote));
            assert.equal(!!old,!!next);pregameModelCases++;
        }
    report.pregameModelCases=pregameModelCases;
    let engineerModelCases=0;
    for(const hasAlly of [false,true]) for(const allyArmor of [0,199,200,201]) for(const selfArmor of [0,199,200,201]) for(const scrap of [0,34,35,69,70,500]) {
        const candidates=hasAlly?[{id:'ally',armor:allyArmor}]:[],self={id:'self',armor:selfArmor};
        const finish=target=>target.armor>=200?'full':scrap<(target.id==='self'?70:35)?'no_scrap':target.id;
        const old=candidates.length?finish(candidates[0]):self.armor<200?finish(self):'full';
        const selected=candidates[0]||null;
        const next=selected!==null?finish(selected):self.armor<200?finish(self):'full';
        assert.equal(old,next);engineerModelCases++;
    }
    report.engineerModelCases=engineerModelCases;
    let seed=123;
    const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return (seed/4294967296-0.5)*2000;};
    for(let i=0;i<10000;i++) {
        const p=[random(),random(),random()],anchor=[random(),random(),random()];
        if(i<4) {p[0]=anchor[0]+[0,0.6,0.6-1e-9,0.6+1e-9][i];p[2]=anchor[2];}
        const before=[p[0]-anchor[0],p[1]-p[1],p[2]-anchor[2]],after=p.map((v,j)=>(v-anchor[j])*(j===1?0:1));
        const len=v=>Math.sqrt(v.reduce((sum,x)=>sum+x*x,0));assert.equal(len(before),len(after));
    }
    report.geometryModelCases=10000;
    candidates.combined_recommended=f=>{
        for(const name of ['teleport_indexed_filter','teleport_redundant_nonempty','teleport_complement_else','engineer_direct_target','pregame_factor_default_condition','pregame_horizontal_distance']) candidates[name](f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-sixth-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-sixth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-sixth-probe-baseline.ws.txt'),baseline.result);
}
module.exports={candidates,files};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
