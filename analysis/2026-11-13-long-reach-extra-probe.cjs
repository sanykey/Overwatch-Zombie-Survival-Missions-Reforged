// Compile exploratory candidates in memory; src/ and exports stay untouched.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const {files:currentFiles, compile, compiler} = require('./measure-further-optimizations.cjs');
const cp=require('node:child_process');
const baselineRef='3b5b9918b417c1ace2f2189d2b20aae504e1aa72';
const old=p=>cp.execFileSync('git',['show',baselineRef+':src/'+p],{encoding:'utf8'}).replace(/\r\n/g,'\n').replace(/\bAUGMENT_(MELEE_RADIUS|MELEE_PUSH_COOLDOWN|MELEE_PUSH_IMPULSE|MELEE_PUSH_RADIUS|WEAPON_REACH_MULTIPLIER|CARNAGE_RADIUS|CARNAGE_DAMAGE|IMPACT_SIZE|MELEE_WEAPON_HEROES|MELEE_BUTTON_WEAPON_HEROES)\b/g, 'LONG_REACH_$1');
const generator=old('create numbers.js');
const files={...currentFiles,'augments.opy':old('augments.opy'),'global_startup.opy':old('global_startup.opy')};
// Inline the old numeric table for the baseline; mergeVendetta replaces it below.
files['compressed numbers.opy']=files['compressed numbers.opy'].replace('    createNumbers()',vm.runInNewContext(generator));
function replace(f, file, from, to) {
    assert(f[file].includes(from), from);
    f[file] = f[file].replace(from, to);
}
function mergeVendetta(f) {
    const begin=f['augments.opy'].indexOf('rule "LONG REACH VENDETTA SWORD":');
    const end=f['augments.opy'].indexOf('rule "LONG REACH MELEE WEAPONS":',begin);
    assert(begin>=0&&end>begin);
    f['augments.opy']=f['augments.opy'].slice(0,begin)+f['augments.opy'].slice(end);
    const start=f['augments.opy'].indexOf('rule "LONG REACH MELEE WEAPONS":');
    f['augments.opy']=f['augments.opy'].slice(0,start)+f['augments.opy'].slice(start).replace(
        'if eventPlayer.augmentId != Augment.LONG_REACH:',
        'if eventPlayer.augmentId != Augment.LONG_REACH or eventPlayer.getHero() == Hero.VENDETTA and not isGameplayActive:');
    replace(f,'global_startup.opy','Hero.RAMATTRA, Hero.TORBJORN]','Hero.RAMATTRA, Hero.TORBJORN, Hero.VENDETTA]');
    const expanded=vm.runInNewContext(generator.replace('let numberIndex = 0;',
        "numbers.find(g=>g.offset==='NL_LONG_REACH_PROFILE_OFFSET').list.push(4.3,33.75,0.15,0.45);\nlet numberIndex = 0;"));
    f['compressed numbers.opy']=currentFiles['compressed numbers.opy'].replace('    createNumbers()',expanded);
}
function pushGuard(f) {
    replace(f,'augments.opy',
        'eventPlayer.augmentMeleePushReadyAt:\n        return\n    if eventPlayer.isCrowdControlled:',
        'eventPlayer.augmentMeleePushReadyAt or eventPlayer.isCrowdControlled:');
}
(async()=>{
    await compiler.readyPromise;
    const base=await compile(files);
    const report={baseline:base.elements,warnings:base.warnings,rules:[...base.result.matchAll(/\/\/(\d+) elements?\s*\nrule \("(LONG REACH [^"]+|extendAugmentMelee)"\)/g)].map(m=>({name:m[2],elements:+m[1]})),candidates:[]};
    assert(base.result.includes('Loop If Condition Is True;'));
    report.recoveryLoopAlreadyOptimized=true;
    for(const [name,edit] of Object.entries({mergeVendetta,pushGuard})) {
        const f={...files};
        try {
            edit(f);
            const b=await compile(f);
            report.candidates.push({name,total:b.elements,saving:base.elements-b.elements,warnings:b.warnings,
                rules:[...b.result.matchAll(/\/\/(\d+) elements?\s*\nrule \("(LONG REACH [^"]+|extendAugmentMelee)"\)/g)].map(m=>({name:m[2],elements:+m[1]}))});
            if(name==='mergeVendetta') {
                const nums=require('./2026-11-13-verify-long-reach-numbers.cjs').numbers(b);
                [4.3,33.75,.15,.45].forEach((v,i)=>assert(Math.abs(nums.at(-4+i)-v)<1e-12));
                const {rules}=require('./verify-player-variables.cjs');
                const {scenario,start,applies}=require('./verify-augments.cjs');
                const old=new Map(rules(base.result).map(r=>[r.name,r]));
                const next=new Map(rules(b.result).map(r=>[r.name,r]));
                const heroes=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbj\u00f6rn','Vendetta'];
                let checks=0;
                for(const hero of heroes) for(const binding of ['Primary Fire','Melee']) for(const mode of ['hold','spam','release']) {
                    const setup=(build,list)=>{
                        const s=scenario(4,{hero,firing:binding==='Primary Fire',meleeing:binding==='Melee',buttons:new Set([binding]),ultimate:hero==='Genji',maxArmor:hero==='Ramattra'?375:100,weapon:hero===heroes[5]?2:1,targets:[{id:'hit',position:[0,0,12],alive:true,visible:true,health:10000}]});
                        s.player.initialMaxHealth=525;
                        s.globals.numbersList=require('./2026-11-13-verify-long-reach-numbers.cjs').numbers(build);
                        s.globals.augmentMeleeWeaponHeroListConst=list;
                        s.globals.augmentMeleeBtnHeroListConst=[heroes[0],heroes[1],heroes[5]];
                        return s;
                    };
                    const a=setup(base,heroes.slice(0,6)),c=setup(b,heroes);
                    const ra=old.get(hero==='Vendetta'?'LONG REACH VENDETTA SWORD':'LONG REACH MELEE WEAPONS');
                    const rc=next.get('LONG REACH MELEE WEAPONS');
                    assert.equal(applies(ra,a),applies(rc,c));
                    if(!applies(ra,a)) {checks++;continue;}
                    const ta=start(ra,a,old),tc=start(rc,c,next);
                    for(let frame=1;frame<=180;frame++) for(const [s,t] of [[a,ta],[c,tc]]) {
                        s.time=100+frame*.016;
                        if(mode==='spam') s.buttons=frame%2?new Set():new Set([binding]);
                        if(mode==='release') {s.buttons.clear();s.firing=false;s.meleeing=false;}
                        t.resume();
                    }
                    assert.deepEqual(c.damage,a.damage,hero+' '+binding+' '+mode);
                    checks++;
                }
                report.stableHeroParityCases=checks;
                report.mergeLimitations='Cross-hero scheduling/recovery is not equivalent by construction and is not validated in game; this is an exploratory candidate.';
            }
        } catch(e) {report.candidates.push({name,error:String(e)});}
    }
    fs.writeFileSync('analysis/2026-11-13-long-reach-extra-probe.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
