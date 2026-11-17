// Read-only candidate measurements against the current 30,204-element build.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='ef434df36083935622dc095b6584fda7dbed0a23';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n))).replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'').replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');}
async function compile(f) {const saved=[console.log,console.warn,console.error];try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}finally {[console.log,console.warn,console.error]=saved;}}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function rules(s) {const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];}));}
const candidates={
    extraction_control_xz(f) {
        replace(f,'objective_types/objective_type_extraction_point.opy',
            'distance(eventPlayer, vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z))',
            'magnitude((eventPlayer.getPosition() - currentObjectivePosition) * vect(1, 0, 1))');
    },
    extraction_resurrection_xz(f) {
        replace(f,'objective_types/objective_type_extraction_point.opy',
            'distance(currentObjectivePosition, vect(player.getPosition().x, currentObjectivePosition.y, player.getPosition().z))',
            'magnitude((currentObjectivePosition - player.getPosition()) * vect(1, 0, 1))');
    },
    extraction_hud_xz(f) {
        replace(f,'core/subroutines.opy',
            'distance(currentObjectivePosition, vect(localPlayer.getPosition().x, currentObjectivePosition.y, localPlayer.getPosition().z) if currentObjectivePosition.y - localPlayer.getEyePosition().y < 2 else localPlayer.getPosition())',
            'magnitude((currentObjectivePosition - localPlayer.getPosition()) * vect(1, 0, 1)) if currentObjectivePosition.y - localPlayer.getEyePosition().y < 2 else distance(currentObjectivePosition, localPlayer.getPosition())');
    },
    ammo_fallback_update_fields(f) {
        replace(f,'abilities/augments.opy',
            '    eventPlayer.augmentAmmoFallbackState = [eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1), eventPlayer.isReloading(), eventPlayer.augmentAmmoFallbackState[3], eventPlayer.augmentAmmoFallbackState[4]]',
            '    eventPlayer.augmentAmmoFallbackState[0] = eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0)\n    eventPlayer.augmentAmmoFallbackState[1] = eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1)\n    eventPlayer.augmentAmmoFallbackState[2] = eventPlayer.isReloading()');
    },
    ammo_reload_finished_cache(f) {
        const file='abilities/augments.opy';
        const predicate='eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()';
        assert.equal(f[file].split(predicate).length-1,2);
        f[file]=f[file].replaceAll(predicate,'augmentAmmoReloadFinished');
        replace(f,file,'    for augmentAmmoFallbackClipIndex in range(2):',
            '    #!define augmentAmmoReloadFinished tmp2\n    for augmentAmmoFallbackClipIndex in range(2):');
        const anchor='        augmentAmmoNativeCapacity = eventPlayer.getMaxAmmo(augmentAmmoFallbackClipIndex)\n';
        replace(f,file,anchor,anchor+'        augmentAmmoReloadFinished = eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()\n');
    },
    ammo_reload_predicate_factoring(f) {
        const a='eventPlayer.getAmmo(augmentAmmoFallbackClipIndex)',c='augmentAmmoNativeCapacity';
        const previousBelow='eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex]';
        const finished='eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()';
        const spent='('+a+' > eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3] or eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3] > '+c+')';
        replace(f,'abilities/augments.opy',
            a+' == '+c+' and ('+previousBelow+' or '+finished+') or eventPlayer.getHero() == Hero.WIDOWMAKER and '+finished+' and '+a+' < '+c+' and '+spent,
            a+' == '+c+' and '+previousBelow+' or '+finished+' and ('+a+' == '+c+' or eventPlayer.getHero() == Hero.WIDOWMAKER and '+a+' < '+c+' and '+spent+')');
    },
    hitchhiker_scalar_donor(f) {
        replace(f,'abilities/enhancements.opy',
            'hitchhikerHealthDonor = eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier).exclude(hitchhikerHealthRecipient)',
            'hitchhikerHealthDonor = eventPlayer.enhancementHitchhikerCarrier if hitchhikerHealthRecipient == eventPlayer else eventPlayer');
    },
    hitchhiker_recipient_compare(f) {
        replace(f,'abilities/enhancements.opy',
            'hitchhikerHealthRecipient = sorted(eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier), lambda x: x.getNormalizedHealth())[0]',
            'hitchhikerHealthRecipient = eventPlayer if eventPlayer.getNormalizedHealth() <= eventPlayer.enhancementHitchhikerCarrier.getNormalizedHealth() else eventPlayer.enhancementHitchhikerCarrier');
    },
    long_reach_input_hero_branch(f) {
        replace(f,'abilities/augment_long_reach.opy',
            '(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.getHero() in LONG_REACH_MELEE_BUTTON_WEAPON_HEROES and eventPlayer.isHoldingButton(Button.MELEE)) and (eventPlayer.getHero() == Hero.DMON or eventPlayer.isFiringPrimaryFire() or eventPlayer.getHero() in LONG_REACH_MELEE_BUTTON_WEAPON_HEROES and eventPlayer.isMeleeing())',
            '((eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.MELEE)) and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isMeleeing())) if eventPlayer.getHero() in LONG_REACH_MELEE_BUTTON_WEAPON_HEROES else (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and (eventPlayer.getHero() == Hero.DMON or eventPlayer.isFiringPrimaryFire()))');
    },
};
async function main() {
    await compiler.readyPromise;const baseline=await compile(files);assert.equal(baseline.nbElements,30204);const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    let stateUpdateCases=0;
    for(let oldBits=0;oldBits<8;oldBits++) for(let newBits=0;newBits<8;newBits++)
        for(const clip0 of [0,1,34,35,70,100]) for(const clip1 of [0,1,34,35,70,100]) {
            const state=[!!(oldBits&1),!!(oldBits&2),!!(oldBits&4),clip0,clip1];
            const flags=[!!(newBits&1),!!(newBits&2),!!(newBits&4)];
            const before=[...flags,state[3],state[4]],after=[...state];
            after[0]=flags[0];after[1]=flags[1];after[2]=flags[2];
            assert.deepEqual(before,after);stateUpdateCases++;
        }
    report.stateUpdateModelCases=stateUpdateCases;
    let reloadCases=0;
    for(const capacity of [0,1,35,70]) for(const targetCapacity of [0,35,70,140]) for(const ammo of [0,1,34,35,69,70,140])
        for(const previousAmmo of [0,34,35,70,140]) for(const previousBelow of [false,true]) for(const wasReloading of [false,true])
            for(const sequence of [[false,false],[false,true],[true,false],[true,true]]) for(const widow of [false,true]) for(const reloading of sequence) {
                const old=capacity>0&&targetCapacity>capacity&&(ammo===capacity&&(previousBelow||wasReloading&&!reloading)||widow&&wasReloading&&!reloading&&ammo<capacity&&(ammo>previousAmmo||previousAmmo>capacity));
                const finished=wasReloading&&!reloading;
                const next=capacity>0&&targetCapacity>capacity&&(ammo===capacity&&(previousBelow||finished)||widow&&finished&&ammo<capacity&&(ammo>previousAmmo||previousAmmo>capacity));
                assert.equal(old,next);reloadCases++;
            }
    report.reloadModelCases=reloadCases;
    let seed=789;
    const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return (seed/4294967296-0.5)*2000;};
    for(let i=0;i<10000;i++) {
        const p=[random(),random(),random()],center=[random(),random(),random()];
        if(i<4) {p[0]=center[0]+[0,10,10-1e-9,10+1e-9][i];p[2]=center[2];}
        const before=[p[0]-center[0],0,p[2]-center[2]],after=p.map((v,j)=>(v-center[j])*(j===1?0:1));
        const len=v=>Math.sqrt(v.reduce((sum,x)=>sum+x*x,0));assert.equal(len(before),len(after));
    }
    report.geometryModelCases=10000;
    candidates.combined_recommended=f=>{
        for(const name of ['extraction_control_xz','extraction_resurrection_xz','ammo_fallback_update_fields','ammo_reload_finished_cache']) candidates[name](f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-seventh-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-seventh-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-seventh-probe-baseline.ws.txt'),baseline.result);
}
module.exports={candidates,files};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
