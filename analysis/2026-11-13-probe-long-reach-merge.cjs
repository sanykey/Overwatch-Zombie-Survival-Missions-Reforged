const fs=require('node:fs');
const assert=require('node:assert/strict');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
(async()=>{
    await compiler.readyPromise;
    const merged={...files};
    const begin=merged['augments.opy'].indexOf('rule "LONG REACH VENDETTA SWORD":');
    const end=merged['augments.opy'].indexOf('rule "LONG REACH MELEE WEAPONS":',begin);
    assert(begin>=0&&end>begin);
    merged['augments.opy']=merged['augments.opy'].slice(0,begin)+merged['augments.opy'].slice(end);
    const gate='    if eventPlayer.augmentId != Augment.LONG_REACH:\n        return';
    const start=merged['augments.opy'].indexOf('rule "LONG REACH MELEE WEAPONS":');
    merged['augments.opy']=merged['augments.opy'].slice(0,start)+merged['augments.opy'].slice(start).replace(gate,'    if eventPlayer.augmentId != Augment.LONG_REACH or eventPlayer.getHero() == Hero.VENDETTA and not isGameplayActive:\n        return');
    merged['augments.opy']=merged['augments.opy'].replace('[Hero.TORBJORN, 2.5, 70, 0.35, 0.35]','[Hero.TORBJORN, 2.5, 70, 0.35, 0.35],\n        [Hero.VENDETTA, AUGMENT_VENDETTA_RADIUS, 45, AUGMENT_VENDETTA_WINDUP, AUGMENT_VENDETTA_INTERVAL - AUGMENT_VENDETTA_WINDUP]');
    merged['global_startup.opy']=merged['global_startup.opy'].replace('Hero.RAMATTRA, Hero.TORBJORN]','Hero.RAMATTRA, Hero.TORBJORN, Hero.VENDETTA]');
    const before=await compile(files),after=await compile(merged);
    assert.deepEqual(after.warnings,[]);
    const selected=b=>[...b.result.matchAll(/\/\/(\d+) elements?\s*\nrule \("(LONG REACH (?:VENDETTA SWORD|MELEE WEAPONS))"\)/g)].map(m=>({name:m[2],elements:+m[1]}));
    // Actor/input parity for stable heroes. Hero switching during active waits
    // intentionally requires separate analysis because the event filter disappears.
    const {scenario,start:run,applies}=require('./verify-augments.cjs');
    const old=new Map(rules(before.result).map(r=>[r.name,r])),next=new Map(rules(after.result).map(r=>[r.name,r]));
    let checks=0;
    const heroes=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbj\u00f6rn','Vendetta'];
    for(const hero of heroes) for(const binding of ['Primary Fire','Melee']) for(const behavior of ['hold','spam','release']) {
        const setup=()=>{const s=scenario(4,{hero,firing:binding==='Primary Fire',meleeing:binding==='Melee',buttons:new Set([binding]),ultimate:hero==='Genji',maxArmor:hero==='Ramattra'?375:100,weapon:hero.startsWith('Torb')?2:1,targets:[{id:'hit',position:[0,0,12],alive:true,visible:true,health:10000}]});s.player.initialMaxHealth=525;s.globals.augmentMeleeWeaponHeroListConst=heroes.slice(0,6);s.globals.augmentMeleeBtnHeroListConst=[heroes[0],heroes[1],heroes[5]];return s;};
        const a=setup(),b=setup();b.globals.augmentMeleeWeaponHeroListConst=heroes;
        const oldRule=old.get(hero==='Vendetta'?'LONG REACH VENDETTA SWORD':'LONG REACH MELEE WEAPONS'),newRule=next.get('LONG REACH MELEE WEAPONS');
        assert.equal(applies(oldRule,a),applies(newRule,b));
        if(!applies(oldRule,a)) {checks++;continue;}
        const ta=run(oldRule,a,old),tb=run(newRule,b,next);
        for(let frame=1;frame<=180;frame++) for(const [s,t] of [[a,ta],[b,tb]]) {
            s.time=100+frame*0.016;
            if(behavior==='spam') s.buttons=frame%2?new Set():new Set([binding]);
            if(behavior==='release') {s.buttons.clear();s.firing=false;s.meleeing=false;}
            t.resume();
        }
        assert.deepEqual(b.damage,a.damage,hero+' '+binding+' '+behavior);checks++;
    }
    const report={before:before.elements,after:after.elements,saving:before.elements-after.elements,rulesBefore:selected(before),rulesAfter:selected(after),steadyHeroParityCases:checks,warnings:after.warnings,limitation:'In-memory prototype only. Cross-hero transitions and engine scheduling are not validated.'};
    fs.writeFileSync('analysis/2026-11-13-long-reach-merge-probe.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
