// Read-only probes against the current 30,287-element source tree.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='bf990811a4c5a85e21051dff8a27b50495bd5bdd';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function region(f,file,a,b,fn) {const i=f[file].indexOf(a),j=f[file].indexOf(b,i+a.length);assert(i>=0&&j>i,a);f[file]=f[file].slice(0,i)+fn(f[file].slice(i,j))+f[file].slice(j);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
function singles(s) {
    const found=new Map();
    for(const block of s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule ('))) {
        const name=block.match(/^rule \("(.*)"\)/)[1];
        for(const line of (block.split('    actions {')[1]||'').split('\n')) {
            const m=line.match(/^\s*([A-Z][^\n]*;).*\/\/ (\d+) elements/);
            if(!m||/^(?:If|Else|End|Skip|Wait|Loop|Abort|Call Subroutine|Start Rule|For|While|Break|Continue)\b/.test(m[1])) continue;
            const item=found.get(m[1])||{code:m[1],elements:Number(m[2]),rules:[]};item.rules.push(name);found.set(m[1],item);
        }
    }
    return [...found.values()].filter(x=>x.rules.length>=2&&x.elements>3).map(x=>({...x,estimatedSaving:(x.rules.length-1)*x.elements-x.rules.length-1})).sort((a,b)=>b.estimatedSaving-a.estimatedSaving).slice(0,20);
}
function sharedLine(f,old,helper,expected) {
    let count=0;
    for(const name of Object.keys(f)) f[name]=f[name].split('\n').map(line=>{
        if(line.trim()!==old) return line;
        count++;return line.slice(0,line.length-line.trimStart().length)+helper+'()';
    }).join('\n');
    assert.equal(count,expected,helper);
    f['core/subroutines.opy']='subroutine '+helper+'\n'+f['core/subroutines.opy']+'\ndef '+helper+'():\n    @Name "'+helper+'"\n    '+old+'\n';
}
const candidates={
    shared_showdown_ring(f) {sharedLine(f,'playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, currentObjectivePosition, objectiveRad * 2)','playShowdownRing',2);},
    shared_spawn_index(f) {sharedLine(f,'spawnRoomIndex = (spawnRoomIndex + 1) % len(attackSpawnRooms)','advanceSpawnRoomIndex',2);},
    shared_bio_queue(f) {sharedLine(f,'biomorphingQueuedTypeList = random.shuffle([0, 1, 2])','shuffleBiowasteQueue',2);},
    shared_special_target(f) {
        let count=0;
        const file='game/zombie_types.opy';
        f[file]=f[file].replace(/^( +)eventPlayer\.botAbilityTarget = eventPlayer\.botSpecialTargetList\[(shadowStepFloatTargetIndex|slimerFlightTargetIndex|smolderShockwaveTargetIndex)\]/gm,(_,indent)=>{count++;return indent+'selectIndexedAbilityTarget()';});
        assert.equal(count,3);
        f['core/subroutines.opy']='subroutine selectIndexedAbilityTarget\n'+f['core/subroutines.opy']+'\ndef selectIndexedAbilityTarget():\n    @Name "selectIndexedAbilityTarget"\n    eventPlayer.botAbilityTarget = eventPlayer.botSpecialTargetList[tmp0]\n';
    },
    revive_filter_any(f) {
        const file='game/players_game_in_progress.opy';
        for(const distance of ['distance(x, eventPlayer)','distance(eventPlayer, x)']) replace(f,file,
            'playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: '+distance+' < REVIVE_RADIUS)',
            'playerTargetList.exclude(eventPlayer).any(lambda x: not x.invisibilityCount and '+distance+' < REVIVE_RADIUS)');
    },
    rescue_filter_any(f) {
        replace(f,'objective_types/objective_type_survivor_rescue.opy',
            'playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisibilityCount).any(lambda x: distance(rescueSurvivor, x) < objectiveRad)',
            'playerTargetList.any(lambda x: x != rescueSurvivor and not x.invisibilityCount and distance(rescueSurvivor, x) < objectiveRad)');
    },
    terminal_filter_any(f) {
        replace(f,'objective_types/objective_type_satellite_uplink.opy',
            'satelliteTerminalPositionList.filter(lambda _, i: satelliteTerminalProgressList[i] < 100).any(lambda x: distance(x, eventPlayer) < objectiveRad and x.x != null)',
            'satelliteTerminalPositionList.any(lambda x, i: satelliteTerminalProgressList[i] < 100 and distance(x, eventPlayer) < objectiveRad and x.x != null)');
    },
    spawn_filter_all(f) {
        replace(f,'game/global_game_in_progress.opy',
            'getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x, attackSpawnRooms[spawnRoomIndex]) > 45)',
            'getPlayers(Team.1).all(lambda x: not x.hasSpawned() or distance(x, attackSpawnRooms[spawnRoomIndex]) > 45)');
    },
    teleport_filter_all(f) {
        const file='game/bots_game_in_progress.opy';
        replace(f,file,'playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.invisibilityCount or not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))');
        replace(f,file,'playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.isInViewAngle(eventPlayer.botTeleportPosition, 55) or not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))');
    },
    showdown_horizontal_distance(f) {
        replace(f,'objective_types/objective_type_showdown.opy',
            'distance(vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z), eventPlayer.getPosition())',
            'magnitude((currentObjectivePosition - eventPlayer.getPosition()) * vect(1, 0, 1))');
    },
    turret_common_offset(f) {
        replace(f,'items/supply_drops.opy',
            'eventPlayer.powerUpTurretPosition = eventPlayer.getPosition() + Vector.UP if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()) + Vector.UP',
            'eventPlayer.powerUpTurretPosition = (eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())) + Vector.UP');
    },
    rescue_horizontal_distance(f) {
        replace(f,'objective_types/objective_type_survivor_rescue.opy',
            'distance(rescueSurvivor, vect(x.x, rescueSurvivor.getPosition().y, x.z))',
            'magnitude((rescueSurvivor.getPosition() - x) * vect(1, 0, 1))');
    },
    turret_visible_target_cache(f) {
        region(f,'items/supply_drops.opy','    for eventPlayer.powerUpTurretTimeRemaining in range(30, 0, -0.125):','    # turretCleanupEffectIndex',b=>{
            const guard='        if getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting):';
            assert(b.includes(guard));
            b=b.replace(guard,'        #!define turretVisibleTargets tmp0\n        turretVisibleTargets = getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player))\n        if turretVisibleTargets.any(lambda player: not player.botIsTeleporting):');
            const search='sorted(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player)), lambda x:';
            assert(b.includes(search));
            return b.replace(search,'sorted(turretVisibleTargets, lambda x:');
        });
    },
};
async function main() {
    await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30287);const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),singleActionDuplicates:singles(baseline.result),results:[]};
    let turretCases=0;
    for(let mask=0;mask<256;mask++) {
        const targets=Array.from({length:4},(_,i)=>({id:i,visible:!!(mask&(1<<(2*i))),teleporting:!!(mask&(1<<(2*i+1))),angle:[10,20,20,0][i]}));
        const visible=targets.filter(x=>x.visible);
        const oldGuard=targets.some(x=>x.visible&&!x.teleporting),newGuard=visible.some(x=>!x.teleporting);
        assert.equal(oldGuard,newGuard);
        if(oldGuard) assert.equal(targets.filter(x=>x.visible).sort((a,b)=>a.angle-b.angle)[0].id,visible.sort((a,b)=>a.angle-b.angle)[0].id);
        turretCases++;
    }
    report.turretModelCases=turretCases;
    let seed=42;
    const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return (seed/4294967296-0.5)*2000;};
    for(let i=0;i<10000;i++) {
        const p=[random(),random(),random()],c=[random(),random(),random()];
        if(i<6) {p[0]=c[0]+[0,0.25,0.25-1e-9,0.25+1e-9,3,-3][i];p[2]=c[2];}
        const a=[c[0]-p[0],0,c[2]-p[2]],b=c.map((v,j)=>(v-p[j])*(j===1?0:1));
        const length=v=>Math.sqrt(v.reduce((sum,x)=>sum+x*x,0));
        assert.equal(length(a),length(b));
    }
    report.geometryModelCases=10000;
    candidates.combined_recommended=f=>{
        for(const name of ['shared_showdown_ring','shared_spawn_index','shared_bio_queue','shared_special_target','showdown_horizontal_distance','turret_common_offset','rescue_horizontal_distance','turret_visible_target_cache']) candidates[name](f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-fourth-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-fourth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-fourth-probe-baseline.ws.txt'),baseline.result);
}
module.exports={candidates,files};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
