// Read-only measurements against the current 30,180-element build.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='33abeaccc004012d11df511a4e02d64019b0eedd';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
    rescue_throttle_fallback_array(f) {
        replace(f,'objective_types/objective_type_survivor_rescue.opy',
            '(eventPlayer.rescuePathList.filter(lambda x: distance(eventPlayer, x) < 2)).last() if eventPlayer.rescuePathList.any(lambda x: distance(eventPlayer, x) < 2) else eventPlayer.rescueLeader',
            '[eventPlayer.rescueLeader].concat(eventPlayer.rescuePathList.filter(lambda x: distance(eventPlayer, x) < 2)).last()');
    },
    camera_origin_map(f) {
        replace(f,'game/player_camera.opy',
            'raycastHitPosition(CAMERA_ORIGIN, raycastHitPosition(CAMERA_ORIGIN, CAMERA_ORIGIN + eventPlayer.getFacingDirection() * -3, null, eventPlayer, true), null, eventPlayer, true)',
            '[CAMERA_ORIGIN].map(lambda origin: raycastHitPosition(origin, raycastHitPosition(origin, origin + eventPlayer.getFacingDirection() * -3, null, eventPlayer, true), null, eventPlayer, true))[0]');
    },
    pull_target_center_any(f) {
        replace(f,'core/subroutines.opy',
            'distance(pullAimOrigin, augmentGrapnelCenter(target)) <= pullAimRange and isInLoS(pullAimOrigin, augmentGrapnelCenter(target))',
            '[augmentGrapnelCenter(target)].any(lambda center: distance(pullAimOrigin, center) <= pullAimRange and isInLoS(pullAimOrigin, center))');
    },
    pull_target_center_any_inline(f) {
        candidates.pull_target_center_any(f);
        replace(f,'core/subroutines.opy','[augmentGrapnelCenter(target)].any(',
            '[((target.getPosition() + target.getEyePosition()) * 0.5)].any(');
    },
    wrestler_hud_binding(f) {
        replace(f,'abilities/player_initialization.opy',
            'f"Throw: [{inputBindingString(Button.INTERACT)}]" if localPlayer.enhancementCarryState != WrestlerCarryState.NONE else f"Grab: [{inputBindingString(Button.INTERACT)}]"',
            'f"{\'Throw\' if localPlayer.enhancementCarryState != WrestlerCarryState.NONE else \'Grab\'}: [{inputBindingString(Button.INTERACT)}]"');
    },
    hitchhiker_hud_binding(f) {
        replace(f,'abilities/player_initialization.opy',
            'f"[{inputBindingString(Button.CROUCH)}]: detach" if localPlayer.enhancementIsHitchhiking else f"[{inputBindingString(Button.CROUCH)}]: attach near ally"',
            'f"[{inputBindingString(Button.CROUCH)}]: {\'detach\' if localPlayer.enhancementIsHitchhiking else \'attach near ally\'}"');
    },
};
async function main() {
    await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30180);const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    let rescueCases=0;
    for(let n=0;n<=8;n++) for(let mask=0;mask<(1<<n);mask++) for(const leader of [0,{playerId:7}]) {
        const path=Array.from({length:n},(_,i)=>i%3===0?[0,0,0]:[i,-i,i/2]);
        const nearby=path.filter((_,i)=>!!(mask&(1<<i)));
        const old=nearby.length?nearby[nearby.length-1]:leader;
        const withFallback=[leader].concat(nearby),next=withFallback[withFallback.length-1];
        assert.deepEqual(old,next);rescueCases++;
    }
    report.rescueModelCases=rescueCases;
    let seed=987,cameraCases=0;
    const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return (seed/4294967296-0.5)*1000;};
    const add=(a,b)=>a.map((v,i)=>v+b[i]),scale=(a,n)=>a.map(v=>v*n);
    for(let i=0;i<10000;i++) {
        const body=[random(),random(),random()],eye=add(body,[random()/100,random()/100,random()/100]);
        const facing=[random()/1000,random()/1000,random()/1000];
        const origin=()=>add(body,[0,Math.hypot(...eye.map((v,j)=>v-body[j]))+0.5,0]);
        const evaluate=cache=>{
            const trace=[];
            const ray=(start,end)=>{trace.push({start,end});return add(start,scale(end.map((v,j)=>v-start[j]),trace.length===1?0.3:0.7));};
            const value=cache?[origin()].map(o=>ray(o,ray(o,add(o,scale(facing,-3)))))[0]:ray(origin(),ray(origin(),add(origin(),scale(facing,-3))));
            return {trace,value};
        };
        assert.deepEqual(evaluate(false),evaluate(true));cameraCases++;
    }
    report.cameraModelCases=cameraCases;
    let hudCases=0;
    for(const state of [0,1,2]) for(const binding of ['E','F','Mouse4','L1','Interact']) {
        const old=state!==0?`Throw: [${binding}]`:`Grab: [${binding}]`;
        const next=`${state!==0?'Throw':'Grab'}: [${binding}]`;
        assert.equal(old,next);hudCases++;
    }
    report.hudModelCases=hudCases;
    candidates.combined_recommended=f=>{
        candidates.rescue_throttle_fallback_array(f);
        candidates.camera_origin_map(f);
        candidates.wrestler_hud_binding(f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};
            if(name==='camera_origin_map'||name==='combined_recommended') {
                const camera=next['APPLY PLAYER CAMERA #1'];
                assert.equal((camera.match(/Ray Cast Hit Position\(/g)||[]).length,2);
                assert.equal((camera.match(/Current Array Element/g)||[]).length,3);
                assert.equal((camera.match(/Mapped Array\(/g)||[]).length,1);
                assert(!camera.includes('Evaluate Once('));
                row.cameraPreservesTwoRaysAndLiveExpression=true;
            }
            report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-eighth-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-eighth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-eighth-probe-baseline.ws.txt'),baseline.result);
}
module.exports={candidates,files};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
