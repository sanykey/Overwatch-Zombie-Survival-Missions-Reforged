const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario: rawScenario, start, applies} = require('./verify-augments.cjs');
let compiledNumbers;
const scenario=(id,extra={})=>{const s=rawScenario(id,extra);s.globals.numbersList=compiledNumbers;s.globals.augmentMeleeWeaponHeroListConst=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbjörn'];s.globals.augmentMeleeBtnHeroListConst=['Reinhardt','Brigitte','Torbjörn'];return s;};
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const target = (id, z, extra={}) => ({id,position:[0,0,z],health:10000,alive:true,visible:true,...extra});
const cases = [
    ['LONG REACH VENDETTA SWORD','Vendetta',4.3,45,0.15,0.6,{}],
    ['LONG REACH MELEE WEAPONS','Reinhardt',4,100,0.4,0.96,{}],
    ['LONG REACH MELEE WEAPONS','Brigitte',6,45,0.2,0.6,{}],
    ['LONG REACH MELEE WEAPONS','D.Mon',4,60,0.2,0.656,{}],
    ['LONG REACH MELEE WEAPONS','Genji',5,100,0.15,0.7/1.15,{ultimate:true}],
    ['LONG REACH MELEE WEAPONS','Ramattra',10,65,0.15,0.6,{maxArmor:375}],
    ['LONG REACH MELEE WEAPONS','Torbjörn',2.5,70,0.35,0.7,{weapon:2}]
];
(async()=>{
    await compiler.readyPromise;
    const build = await compile(files); assert.deepEqual(build.warnings,[]);
    compiledNumbers=require('./2026-11-13-verify-long-reach-numbers.cjs').numbers(build);
    const compiled = new Map(rules(build.result).map(r=>[r.name,r]));
    let checks=0;
    for(const [name,hero,radius,amount,windup,interval,extra] of cases) {
        const bindings=['Primary Fire',...(['Reinhardt','Brigitte','Torbjörn'].includes(hero)?['Melee']:[])];
        for(const binding of bindings) for(const mode of ['hold','spam','release']) {
            const s=scenario(4,{hero,firing:binding==='Primary Fire',meleeing:binding==='Melee',buttons:new Set([binding]),...extra,
                targets:[target('native',radius),target('outer',radius+0.1),target('edge',radius*3),target('outside',radius*3+0.01),target('wall',radius+1,{visible:false})]});
            s.player.initialMaxHealth=525;
            assert(applies(compiled.get(name),s),hero+': '+binding+' '+mode);
            const task=start(compiled.get(name),s,compiled);
            // Advance frame by frame, repeatedly releasing/repressing during both
            // windup and recovery. Native firing can linger through release.
            for(let frame=1;frame<=240;frame++) {
                s.time=100+frame*0.016;
                if(mode==='spam') s.buttons=frame%2?new Set():new Set([binding]);
                if(mode==='release') {s.buttons.clear();s.firing=false;s.meleeing=false;}
                task.resume();
            }
            const hits=s.damage.filter(h=>h.targets[0].id==='outer');
            assert(hits.length>0,hero+': short click commits a hit');
            if(mode==='release') assert.equal(hits.length,1);
            else assert(hits.length>=3);
            assert(s.damage.every(h=>['outer','edge'].includes(h.targets[0].id)&&h.amount===amount));
            for(let i=1;i<hits.length;i++) assert(hits[i].time-hits[i-1].time>=interval-1e-9,hero+': click spam bypassed recovery');
            checks++;
        }
        // Actor-condition edges after a hit cannot abort the recovery wait.
        for(const interrupt of ['alive','blocking']) {
            const s=scenario(4,{hero,firing:true,...extra,targets:[target('hit',radius+0.1)]});s.player.initialMaxHealth=525;
            const task=start(compiled.get(name),s,compiled);s.time=task.deadline();task.resume();
            assert.equal(s.damage.length,1); const recoveryEnd=task.deadline();
            s[interrupt]=interrupt==='blocking';s.time+=0.016;task.resume();assert(!task.done());
            s[interrupt]=interrupt==='alive';s.time=recoveryEnd;task.resume();
            s.time=task.deadline();task.resume();assert.equal(s.damage.length,2);
            assert(s.damage[1].time-s.damage[0].time>=interval-1e-9);checks++;
        }
    }
    for(const [hero,damage] of [['Soldier: 76',40],['Zenyatta',60],['Venture',70]]) {
        const s=scenario(4,{hero,meleeing:true,targets:[target('hit',5)]});const t=start(compiled.get('LONG REACH QUICK MELEE'),s,compiled);
        s.time=t.deadline();t.resume();assert.equal(s.damage[0].amount,damage);checks++;
    }
    // Execute the shared query and actual-damage integrations independently.
    for(const enhancement of [0,3,9]) for(const invincible of [false,true]) {
        const s=scenario(4,{targets:[target('hit',5,{invincible}),target('edge',7.5,{invincible}),target('native',2.5),target('outside',7.501)]});
        s.player.enhancementId=enhancement;s.player[slot('enhancementCapacitorCharge')]=25;
        s.globals.tmp0=2.5;s.globals.tmp1=40;
        assert(start(compiled.get('extendAugmentMelee'),s,compiled).done());
        assert.deepEqual(s.damage.map(h=>h.targets[0].id),enhancement===9?['hit','hit','edge','edge']:['hit','edge']);
        assert.equal(s.statusWrites.length,enhancement===3&&!invincible?2:0);
        assert.equal(s.effects.length,1);assert.equal(s.effects[0].position[2],5);checks++;
    }
    for(const scale of [0.5,2]) {
        const s=scenario(4,{targets:[target('native',2.5*scale),target('inside',3*scale),target('edge',7.5*scale),target('outside',7.5*scale+0.001),target('behind',-4*scale),target('dead',4*scale,{alive:false}),target('hidden',4*scale,{visible:false})]});
        s.player.sizeScale=scale;s.globals.tmp0=2.5;s.globals.tmp1=40;
        assert(start(compiled.get('extendAugmentMelee'),s,compiled).done());
        assert.deepEqual(s.damage.map(h=>h.targets[0].id),['inside','edge']);checks++;
    }
    for(const [name,extra,windup] of [['LONG REACH QUICK MELEE',{meleeing:true},0.15],['LONG REACH CARNAGE',{hero:'Junker Queen',ability2:true},0.75]]) {
        for(const dead of [false,true]) {
            const s=scenario(4,{...extra,targets:[target('hit',6)]});
            assert(applies(compiled.get(name),s),name);
            const t=start(compiled.get(name),s,compiled);s.alive=!dead;s.time+=windup;t.resume();
            assert.equal(s.damage.length,dead?0:1);checks++;
        }
    }
    const before=require('./2026-11-13-long-reach-baseline.json');
    const cp=require('node:child_process');
    const vm=require('node:vm');
    const oldGenerator=cp.execFileSync('git',['show',before.baselineRef+':src/create numbers.js'],{encoding:'utf8'});
    const oldCompressed=files['compressed numbers.opy'].replace('    createNumbers()',vm.runInNewContext(oldGenerator));
    const baseline=await compile({...files,'compressed numbers.opy':oldCompressed,'augments.opy':cp.execFileSync('git',['show',before.baselineRef+':src/augments.opy'],{encoding:'utf8'}).replace(/\r\n/g,'\n')});
    const changed=new Set(['Initialize global variables','LONG REACH QUICK MELEE','LONG REACH VENDETTA SWORD','LONG REACH MELEE WEAPONS','LONG REACH CARNAGE','extendAugmentMelee']);
    const oldRules=rules(baseline.result);
    assert.deepEqual(rules(build.result).filter(r=>!changed.has(r.name)),oldRules.filter(r=>!changed.has(r.name)),'Every unrelated rule, including the push, stays identical');
    const initBody=b=>rules(b.result).find(r=>r.name==='Initialize global variables').body.split('\n').filter(l=>!l.startsWith('Set Global Variable(numbersList,')).join('\n');
    assert.equal(initBody(build),initBody(baseline),'Other initializers stay unchanged');
    assert.equal(before.total,baseline.elements,'Re-run the measurement if unrelated sources change');
    const compressionCost=b=>Number(b.result.split('\n').find(l=>l.includes('Set Global Variable(numbersList,')).match(/\/\/ (\d+) elements/)[1]);
    const compressionOverhead=compressionCost(build)-compressionCost(baseline);
    const rows=[...build.result.matchAll(/\/\/(\d+) elements?\s*\nrule \("([^"\n]+)"\)/g)].filter(m=>m[2].startsWith('LONG REACH')||m[2]==='extendAugmentMelee').map(m=>({name:m[2],before:before.rules.find(r=>r.name===m[2]).elements,after:+m[1]}));
    const report={beforeTotal:before.total,afterTotal:build.elements,rules:rows,virtualHits:rows.filter(r=>!r.name.endsWith('PUSH')).reduce((s,r)=>s+r.after,0),includingPush:rows.reduce((s,r)=>s+r.after,0),initialization:before.initialization,fullLogic:rows.reduce((s,r)=>s+r.after,before.initialization)+compressionOverhead,compressionInitializationOverhead:compressionOverhead,checks,warnings:build.warnings,limitation:'Controlled execution of compiled actions; native animation timing and scheduling require in-game testing.'};
    fs.writeFileSync('analysis/2026-11-13-long-reach-validation.json',JSON.stringify(report,null,2)+'\n');
    if(process.argv.includes('--export')) {
        const path=require('node:path');const root=path.resolve(__dirname,'..');
        const output=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(output.encounteredWarnings,[]);assert.equal(output.nbElements,build.elements);
        assert.deepEqual(rules(output.result),rules(build.result));
        fs.writeFileSync(path.join(root,'main.ws.txt'),output.result);
    }
    console.log(JSON.stringify(report,null,2));
})();
