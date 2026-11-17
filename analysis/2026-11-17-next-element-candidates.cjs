// Independent probes against the current working tree. No gameplay-source writes.
const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
const crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');
process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {
    return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));
}
// Reproduce the audit after implementation using the preceding committed build.
const baselineRef='e27322c8af23ffb4d2e2cb9e8fba2fef1de1b4f7';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {
    return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n)))
        .replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'')
        .replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');
}
async function compile(f) {
    const saved=[console.log,console.warn,console.error];
    try {console.log=console.warn=console.error=()=>{}; return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}
    finally {[console.log,console.warn,console.error]=saved;}
}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function region(f,file,a,b,fn) {
    const i=f[file].indexOf(a),j=f[file].indexOf(b,i+a.length);assert(i>=0&&j>i,a);
    f[file]=f[file].slice(0,i)+fn(f[file].slice(i,j))+f[file].slice(j);
}
const candidates={
    bot_bite_single_assignment(f) {
        replace(f,'core/subroutines.opy','    eventPlayer.botBiteDamage = botBiteDamageList[botStatHeroIndex]\n    #Re-calibrate bite damage\n    eventPlayer.botBiteDamage *= 100 / botDamageDealtList[botStatHeroIndex]',
            '    eventPlayer.botBiteDamage = botBiteDamageList[botStatHeroIndex] * (100 / botDamageDealtList[botStatHeroIndex])');
    },
    shared_scripted_hit_tail(f) {
        const a='    enhancementHitDamage -= enhancementHitVictim.getHealth()\n    applyHitEnhancements()\n';
        replace(f,'core/subroutines.opy',a,'    finishScriptedEnhancementHit()\n');
        f['core/subroutines.opy']='subroutine finishScriptedEnhancementHit\n'+f['core/subroutines.opy']+'\ndef finishScriptedEnhancementHit():\n'+a;
    },
    battle_priority_with_fallback(f) {
        region(f,'abilities/enhancements.opy','    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):','    #Temp rein fix ability 2',()=>
            '    eventPlayer.enhancementBattleAbilityButton = [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].filter(lambda button: eventPlayer.isHoldingButton(button)).concat(eventPlayer.enhancementBattleAbilityButton)[0]\n');
    },
    battle_priority_loop(f) {
        region(f,'abilities/enhancements.opy','    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):','    #Temp rein fix ability 2',()=>
            '    for tmp0 in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP]:\n        if eventPlayer.isHoldingButton(tmp0):\n            eventPlayer.enhancementBattleAbilityButton = tmp0\n            break\n');
    },
    enable_abilities_common(f) {
        region(f,'core/subroutines.opy','    if isPregameSetup:\n        eventPlayer.disableHeroHud()','\n\ndef objectivesManagement',()=>
            '    if isPregameSetup:\n        eventPlayer.disableHeroHud()\n'+
            ['PrimaryFire','SecondaryFire','Ability1','Ability2','Ult','Melee'].map(n=>'    eventPlayer.set'+n+'Enabled(not isPregameSetup)\n').join('')+
            '    if not isPregameSetup:\n        eventPlayer.enableHeroHud()\n');
    },
    resist_use_cached_hud_flag(f) {
        const file='abilities/hero_tuning.opy';
        const line='    eventPlayer.setDamageReceived(0 if eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null else 50 if eventPlayer.powerUpSuperNanoGoodAuraId != 0 or eventPlayer.isUsingUltimate() else 100)\n';
        replace(f,file,line,'');
        const anchor='    eventPlayer.hasDamageResist = eventPlayer.isDotProtected or eventPlayer.powerUpSuperNanoGoodAuraId != 0\n';
        replace(f,file,anchor,anchor+'    eventPlayer.setDamageReceived(0 if eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null else 50 if eventPlayer.hasDamageResist else 100)\n');
    },
    pyro_boss_scale_expression(f) {
        region(f,'abilities/enhancements.opy','            if pyroBurnTarget in bossStateList:','        eventPlayer.enhancementPyroHitList.remove',()=>
            '            pyroBurnTarget.startDamageOverTime(eventPlayer, 3, pyroBurnDamagePerSecond / (2 if pyroBurnTarget in bossStateList else 1))\n');
    },
    mutation_name_table(f) {
        region(f,'core/subroutines.opy','macro mutationsMacro():','macro botEntityManagementMacro',b=>{
            b=b.replace(/^            eventPlayer.startForcingName\("[^"\n]+"\)\n/gm,'');
            return b.replace('        #Capture the color','        eventPlayer.startForcingName(["SPEED", "XL", "XS", "Radioactive", "Heavy"][eventPlayer.botMutationId - 1])\n        #Capture the color');
        });
    },
    mutation_color_table(f) {
        region(f,'core/subroutines.opy','macro mutationsMacro():','macro botEntityManagementMacro',b=>
            b.replace(/^            (?:#!define botMutationOutlineColor tmp2|botMutationOutlineColor = Color\.\w+)\n/gm,'')
                .replace('evalOnce(botMutationOutlineColor)','evalOnce([Color.PURPLE, Color.VIOLET, Color.ROSE, Color.LIME_GREEN, Color.BLACK][eventPlayer.botMutationId - 1])'));
    },
    objective_completion_sounds(f) {
        region(f,'core/subroutines.opy','        #Checks if current objective is showdown','        # Objective IDs 1..7 are contiguous; unsupported IDs previously produced no completion message.',b=>{
            b=b.replace(/^                playEffect\(getAllPlayers\(\), DynamicEffect.RING_EXPLOSION_SOUND[^\n]+\n/gm,'');
            return '        if currentObjectiveType in [ObjectiveType.KILL_ZONE, ObjectiveType.ZOMBIE_EGG, ObjectiveType.SATELLITE_UPLINK]:\n            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED if currentObjectiveType == ObjectiveType.KILL_ZONE else Color.LIME_GREEN, killZoneCenter if currentObjectiveType == ObjectiveType.KILL_ZONE else currentObjectivePosition, 200)\n'+b+
                '        if currentObjectiveType in [ObjectiveType.SHOWDOWN, ObjectiveType.BIOMORPHING, ObjectiveType.SURVIVOR_RESCUE]:\n            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, [Color.ORANGE, Color.WHITE, Color.ROSE, Color.VIOLET][currentObjectiveType - 1], currentObjectivePosition, 200)\n';
        });
    },
    objective_completion_effect_table(f) {
        region(f,'core/subroutines.opy','        #Checks if current objective is showdown','        # Objective IDs 1..7 are contiguous; unsupported IDs previously produced no completion message.',()=>`
        if currentObjectiveType in [ObjectiveType.SHOWDOWN, ObjectiveType.BIOMORPHING, ObjectiveType.SURVIVOR_RESCUE, ObjectiveType.KILL_ZONE, ObjectiveType.ZOMBIE_EGG, ObjectiveType.SATELLITE_UPLINK]:
            tmp0 = [Color.ORANGE, Color.WHITE, Color.GREEN, Color.VIOLET, Color.RED, Color.LIME_GREEN, Color.LIME_GREEN][currentObjectiveType - 1]
            tmp1 = killZoneCenter if currentObjectiveType == ObjectiveType.KILL_ZONE else currentObjectivePosition
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION if currentObjectiveType < ObjectiveType.KILL_ZONE else DynamicEffect.RING_EXPLOSION_SOUND, tmp0, tmp1, objectiveRad * (2 if currentObjectiveType == ObjectiveType.SHOWDOWN else 1) if currentObjectiveType < ObjectiveType.KILL_ZONE else 200)
            if currentObjectiveType != ObjectiveType.SATELLITE_UPLINK:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND if currentObjectiveType < ObjectiveType.KILL_ZONE else DynamicEffect.RING_EXPLOSION, Color.ROSE if currentObjectiveType == ObjectiveType.BIOMORPHING else tmp0, tmp1, 200 if currentObjectiveType < ObjectiveType.KILL_ZONE else objectiveRad * 2)
            if currentObjectiveType == ObjectiveType.ZOMBIE_EGG:
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, currentObjectivePosition, 3)
`);
    },
};
function rules(s) {
    const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
        const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;
        return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
    }));
}
async function main() {
    await compiler.readyPromise;
    const baseline=await compile(files),baseRules=rules(baseline.result);
    assert.equal(baseline.nbElements,30350,'These probes target the working tree after the first three optimizations');
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    candidates.combined_best=f=>{
        candidates.battle_priority_with_fallback(f);
        candidates.mutation_name_table(f);
        candidates.resist_use_cached_hud_flag(f);
    };
    // Model the priority chain, including no held buttons and the scalar old value.
    let priorityCases=0;
    for(let mask=0;mask<32;mask++) for(const previous of [null,0,false,1,2,3,4,5]) {
        let old=previous;
        for(let i=0;i<5;i++) if(mask & (1<<i)) {old=i+1;break;}
        const next=[1,2,3,4,5].filter((_,i)=>mask & (1<<i)).concat(previous)[0];
        assert.equal(old,next);priorityCases++;
    }
    report.priorityModelCases=priorityCases;
    for(const dash of [false,true]) for(const ult of [false,true]) for(const nano of [false,true])
        assert.equal(dash?0:(nano||ult)?50:100,dash?0:((dash||ult)||nano)?50:100);
    report.resistModelCases=8;
    const mutationNames=['SPEED','XL','XS','Radioactive','Heavy'];
    for(let id=1;id<=5;id++) assert.equal(mutationNames[id-1],id===1?'SPEED':id===2?'XL':id===3?'XS':id===4?'Radioactive':'Heavy');
    report.mutationNameModelCases=5;
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};
        try {
            fn(f);const r=await compile(f),next=rules(r.result);
            const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);
            const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};
            report.results.push(row);console.log(JSON.stringify(row));
            fs.writeFileSync(path.join(__dirname,'2026-11-17-next-probe-'+name+'.ws.txt'),r.result);
        } catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-next-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-next-probe-baseline.ws.txt'),baseline.result);
}
main().catch(e=>{console.error(e);process.exitCode=1;});
