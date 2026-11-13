const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario: rawScenario, start, applies} = require('./verify-augments.cjs');
let compiledNumbers;
const scenario=(id,extra={})=>{const s=rawScenario(id,extra);s.globals.numbersList=compiledNumbers;s.globals.augmentMeleeWeaponHeroListConst=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbjörn','Vendetta'];s.globals.augmentMeleeBtnHeroListConst=['Reinhardt','Brigitte','Torbjörn'];return s;};
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const target = (id, z, extra={}) => ({id,position:[0,0,z],health:10000,alive:true,visible:true,...extra});
const cases = [
    ['[LONG_REACH] MELEE WEAPONS','Vendetta',4.3,33.75,0.15,0.6,{}],
    ['[LONG_REACH] MELEE WEAPONS','Reinhardt',4,75,0.4,0.96,{}],
    ['[LONG_REACH] MELEE WEAPONS','Brigitte',6,33.75,0.2,0.6,{}],
    ['[LONG_REACH] MELEE WEAPONS','D.Mon',4,45,0.2,0.656,{}],
    ['[LONG_REACH] MELEE WEAPONS','Genji',5,75,0.15,0.7/1.15,{ultimate:true}],
    ['[LONG_REACH] MELEE WEAPONS','Ramattra',10,48.75,0.15,0.6,{maxArmor:375}],
    ['[LONG_REACH] MELEE WEAPONS','Torbjörn',2.5,52.5,0.35,0.7,{weapon:2}]
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
        const s=scenario(4,{hero,meleeing:true,targets:[target('hit',5)]});const t=start(compiled.get('[LONG_REACH] QUICK MELEE'),s,compiled);
        s.time=t.deadline();t.resume();assert.equal(s.damage[0].amount,damage);checks++;
    }
    // Execute the shared query and actual-damage integrations independently.
    for(const enhancement of [0,3,9]) for(const invincible of [false,true]) {
        const s=scenario(4,{targets:[target('hit',5,{invincible}),target('edge',7.5,{invincible}),target('native',2.5),target('outside',7.501)]});
        s.player.enhancementId=enhancement;s.player[slot('enhancementCapacitorCharge')]=25;
        s.player[slot('enhancementCapacitorDeadline')]=0;
        s.globals.tmp0=2.5;s.globals.tmp1=40;
        assert(start(compiled.get('[LONG_REACH] extendAugmentMelee'),s,compiled).done());
        assert.deepEqual(s.damage.map(h=>h.targets[0].id),enhancement===9&&!invincible?['hit','hit','edge','edge']:['hit','edge']);
        assert.equal(s.statusWrites.length,enhancement===3&&!invincible?2:0);
        assert.equal(s.effects.length,1);assert.equal(s.effects[0].position[2],5);checks++;
    }
    for(const scale of [0.5,2]) {
        const s=scenario(4,{targets:[target('native',2.5*scale),target('inside',3*scale),target('edge',7.5*scale),target('outside',7.5*scale+0.001),target('behind',-4*scale),target('dead',4*scale,{alive:false}),target('hidden',4*scale,{visible:false})]});
        s.player.sizeScale=scale;s.globals.tmp0=2.5;s.globals.tmp1=40;
        assert(start(compiled.get('[LONG_REACH] extendAugmentMelee'),s,compiled).done());
        assert.deepEqual(s.damage.map(h=>h.targets[0].id),['inside','edge']);checks++;
    }
    for(const [name,extra,windup] of [['[LONG_REACH] QUICK MELEE',{meleeing:true},0.15],['[LONG_REACH] CARNAGE',{hero:'Junker Queen',ability2:true},0.75]]) {
        for(const dead of [false,true]) {
            const s=scenario(4,{...extra,targets:[target('hit',6)]});
            assert(applies(compiled.get(name),s),name);
            const t=start(compiled.get(name),s,compiled);s.alive=!dead;s.time+=windup;t.resume();
            assert.equal(s.damage.length,dead?0:1);checks++;
        }
    }
    const weapon=compiled.get('[LONG_REACH] MELEE WEAPONS');
    assert(!compiled.has('[LONG_REACH] VENDETTA SWORD'));
    const swing=(hero='Vendetta',extra={})=>scenario(4,{hero,firing:true,targets:[target('hit',8)],...extra});
    // A released click remains committed; actor conditions still cancel windup.
    for(const cancel of [s=>{s.alive=false;},s=>{s.blocking=true;},s=>{s.ability1=true;},s=>{s.ability2=true;},s=>{s.ultimate=true;},s=>s.status.add('Stunned'),s=>{s.hero='Ana';},s=>{s.hero='Brigitte';}]) {
        const s=swing(),t=start(weapon,s,compiled);
        cancel(s);s.time=t.deadline();t.resume();
        assert.equal(s.damage.length,0);assert(t.done());checks++;
    }
    // Idle waits rebuild the profile for the current hero in either direction.
    for(const [from,to,damage,windup] of [['Vendetta','Brigitte',33.75,.2],['Reinhardt','Vendetta',33.75,.15]]) {
        const s=swing(from,{firing:false,buttons:new Set()}),t=start(weapon,s,compiled);
        s.hero=to;s.firing=true;s.buttons.add('Primary Fire');t.resume();
        assert(Math.abs(t.deadline()-s.time-windup)<1e-9);
        s.time=t.deadline();t.resume();assert.equal(s.damage[0].amount,damage);checks++;
    }
    // A different supported hero cannot bypass the shared recovery.
    for(const [from,to,windup] of [['Vendetta','Reinhardt',.4],['Reinhardt','Vendetta',.15]]) {
        const s=swing(from),t=start(weapon,s,compiled);
        s.time=t.deadline();t.resume();assert.equal(s.damage.length,1);
        const recoveryEnd=t.deadline();s.hero=to;s.time+=.016;t.resume();
        assert(!t.done());assert.equal(t.deadline(),recoveryEnd);assert.equal(s.damage.length,1);
        s.time=recoveryEnd;t.resume();assert(Math.abs(t.deadline()-s.time-windup)<1e-9);
        s.time=t.deadline();t.resume();assert.equal(s.damage.length,2);checks++;
    }
    // Preserve the old phase check at entry; it does not abort committed swings.
    for(const hero of ['Vendetta','Reinhardt']) {
        const s=swing(hero);s.globals.isGameplayActive=false;
        const t=start(weapon,s,compiled);assert.equal(t.done(),hero==='Vendetta');checks++;
    }
    // Run current behavior independently of this dated merge's historical layout.
    if(process.argv.includes('--behavior-only')) {
        console.log(JSON.stringify({checks,elements:build.elements,warnings:build.warnings},null,2));
        return;
    }
    const cp=require('node:child_process'),vm=require('node:vm');
    const baselineRef='3b5b9918b417c1ace2f2189d2b20aae504e1aa72';
    const old=p=>cp.execFileSync('git',['show',baselineRef+':src/'+p],{encoding:'utf8'}).replace(/\r\n/g,'\n').replace(/\bAUGMENT_(MELEE_RADIUS|MELEE_PUSH_COOLDOWN|MELEE_PUSH_IMPULSE|MELEE_PUSH_RADIUS|WEAPON_REACH_MULTIPLIER|CARNAGE_RADIUS|CARNAGE_DAMAGE|IMPACT_SIZE|MELEE_WEAPON_HEROES|MELEE_BUTTON_WEAPON_HEROES)\b/g, 'LONG_REACH_$1');
    const baseline=await compile({...files,'augments.opy':old('augments.opy').replaceAll('rule "LONG REACH ', 'rule "[LONG_REACH] ').replace('@Name "extendAugmentMelee"', '@Name "[LONG_REACH] extendAugmentMelee"'),'global_startup.opy':old('global_startup.opy'),
        'compressed numbers.opy':files['compressed numbers.opy'].replace('    createNumbers()',vm.runInNewContext(old('create numbers.js')))});
    assert.deepEqual(baseline.warnings,[]);
    const oldNumbers=require('./2026-11-13-verify-long-reach-numbers.cjs').numbers(baseline);
    assert.deepEqual(compiledNumbers.slice(0,-4),oldNumbers);
    [4.3,33.75,.15,.45].forEach((n,i)=>assert(Math.abs(compiledNumbers.at(-4+i)-n)<1e-12));
    const oldRules=rules(baseline.result),newRules=rules(build.result);
    const allowed=new Set(['Initialize global variables','VARIABLE ASSIGNMENT','[LONG_REACH] VENDETTA SWORD','[LONG_REACH] MELEE WEAPONS']);
    assert.deepEqual(newRules.filter(r=>!allowed.has(r.name)),oldRules.filter(r=>!allowed.has(r.name)));
    assert.deepEqual(build.result.match(/variables\s*\{[\s\S]*?\n\}/)[0],baseline.result.match(/variables\s*\{[\s\S]*?\n\}/)[0]);
    const changedRules=[...allowed].filter(name=>oldRules.find(r=>r.name===name)?.body!==newRules.find(r=>r.name===name)?.body);
    assert.equal(baseline.elements-build.elements,31);
    const report={baselineRef,before:baseline.elements,after:build.elements,saving:baseline.elements-build.elements,checks,changedRules,warnings:build.warnings,
        behavior:'All supported weapons share recovery across hero changes; a hero change during windup cancels the pending hit.',
        limitation:'Compiled action interpreter checks; native animation and Workshop scheduling need in-game validation.'};
    if(process.argv.includes('--export')) {
        const path=require('node:path'),root=path.resolve(__dirname,'..');
        const output=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(output.encounteredWarnings,[]);assert.equal(output.nbElements,build.elements);
        assert.deepEqual(rules(output.result),newRules);
        fs.writeFileSync(path.join(root,'main.ws.txt'),output.result);
        report.exported=true;
    }
    fs.writeFileSync('analysis/2026-11-13-long-reach-merged-validation.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
