const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
const {scenario,start,applies}=require('./verify-augments.cjs');
const {checkWorkshop}=require('./verify-global-temporaries.cjs');
const root=path.resolve(__dirname,'..'),ruleName='[LONG_REACH] MELEE PUSH';
const slot=name=>files['variables.opy'].match(new RegExp('^#!define '+name+' (\\w+)$','m'))[1];
const ready=slot('augmentMeleePushReadyAt'),scale=slot('botKnockbackScale');
const zombie=(id,position=[0,0,2],extra={})=>({id,team:2,position,alive:true,visible:true,[scale]:1,...extra});
const state=(targets,extra={})=>scenario(4,{buttons:new Set(['Melee']),targets,...extra});
(async()=>{
    await compiler.readyPromise;
    const baseline={...files,'long_reach.opy':execFileSync('git',['show','HEAD:src/long_reach.opy'],{cwd:root,encoding:'utf8'}).replace(/\r\n/g,'\n')};
    const before=await compile(baseline),after=await compile(files);
    assert.deepEqual(before.warnings,[]);assert.deepEqual(after.warnings,[]);
    const oldRules=rules(before.result),newRules=rules(after.result);
    assert.equal(oldRules.length,newRules.length);
    for(let i=0;i<newRules.length;i++)if(newRules[i].name!==ruleName)assert.deepEqual(newRules[i],oldRules[i]);
    const compiled=new Map(newRules.map(r=>[r.name,r]));
    const oldCompiled=new Map(oldRules.map(r=>[r.name,r]));
    const push=compiled.get(ruleName),oldPush=oldCompiled.get(ruleName);
    // Keep the exact input edge and all guards/actions outside the selection expression.
    assert.equal(push.body.split('Set Global Variable(tmp0,')[0],oldPush.body.split('Set Global Variable(tmp0,')[0]);
    assert.equal(push.body.slice(push.body.indexOf('Abort If(Compare(Global.tmp0')),oldPush.body.slice(oldPush.body.indexOf('Abort If(Compare(Global.tmp0')));
    let cases=0;
    for(const test of [
        {name:'close tall target, aim at torso',target:zombie('hit',[0,0,2],{eyePosition:[0,4,2]})},
        {name:'aim below eye line at close range',target:zombie('hit'),overrides:{facing:[0,-0.8,0.6]}},
        {name:'small target in front of tall survivor',target:zombie('hit'),overrides:{eyePosition:[0,4,0]}},
        {name:'visible target up a ledge',target:zombie('hit',[0,3,3])},
    ]){
        const old=state([structuredClone(test.target)],test.overrides),next=state([structuredClone(test.target)],test.overrides);
        start(oldPush,old,oldCompiled);start(push,next,compiled);
        assert.equal(old.impulses.length,0,test.name+' baseline must reproduce the miss');
        assert.deepEqual(next.impulses.map(i=>i.target),['hit'],test.name);
        assert.equal(next.player[ready],109);cases++;
    }
    const radians=x=>x*Math.PI/180;
    for(const yaw of [0,90,179,-179])for(const offset of [-180,-30.1,-29.9,0,29.9,30.1,180]){
        const azimuth=radians(yaw+offset);
        const s=state([zombie('target',[5*Math.sin(azimuth),0,5*Math.cos(azimuth)])],{yaw});
        start(push,s,compiled);
        assert.equal(s.impulses.length,Math.abs(offset)<30?1:0,'yaw '+yaw+' offset '+offset);cases++;
    }
    for(const extra of [{alive:false},{visible:false},{team:1},{[scale]:0},{[slot('botIsAttached')]:true},{[slot('botIsTeleporting')]:true}]){
        const s=state([zombie('excluded',[0,0,3],extra)]);start(push,s,compiled);
        assert.equal(s.impulses.length,0);assert.equal(s.player[ready]??0,0);cases++;
    }
    for(const size of [0.5,1,2]){
        const s=state([zombie('edge',[0,0,10*size],{[scale]:0.7}),zombie('far',[0,0,10*size+0.01])]);
        s.player.sizeScale=size;start(push,s,compiled);
        assert.deepEqual(s.impulses.map(i=>[i.target,i.speed]),[['edge',17.5]]);
        assert.deepEqual(s.environmentCredits,['edge']);assert.equal(s.damage.length,0);cases++;
    }
    for(const status of ['Stunned','Asleep','Frozen','Knocked Down']){
        const s=state([zombie('target')],{status:new Set([status])});start(push,s,compiled);
        assert.equal(s.impulses.length,0);assert.equal(s.player[ready]??0,0);cases++;
    }
    const cooldown=state([zombie('target')]);cooldown.player[ready]=101;
    start(push,cooldown,compiled);assert.equal(cooldown.impulses.length,0);
    cooldown.time=101;start(push,cooldown,compiled);assert.equal(cooldown.impulses.length,1);cases++;
    const inactive=state([zombie('target')]);inactive.globals.isGameplayActive=false;start(push,inactive,compiled);assert.equal(inactive.impulses.length,0);cases++;
    const other=state([zombie('target')]);other.player.augmentId=1;start(push,other,compiled);assert.equal(other.impulses.length,0);cases++;
    assert(!applies(push,state([zombie('target')],{buttons:new Set(['Primary Fire'])})));
    assert(!applies(push,state([zombie('target')],{alive:false})));
    assert(!push.body.match(/Wait\(|Wait Until|Loop|Damage\(|Start Rule|Call Subroutine/));
    const raw=[...after.result.matchAll(/^rule \("((?:\\.|[^"\\])*)"\) \{\n[\s\S]*?^\}/gm)].find(m=>m[1]===ruleName)[0];
    checkWorkshop(raw);
    const saved={log:console.log,warn:console.warn,error:console.error};let exported;
    try{console.log=console.warn=console.error=()=>{};exported=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');}
    finally{Object.assign(console,saved);}
    assert.deepEqual(exported.encounteredWarnings,[]);assert.deepEqual(rules(exported.result),newRules);
    fs.writeFileSync(path.join(root,'main.ws.txt'),exported.result);
    const report={beforeElements:before.elements,afterElements:after.elements,deltaElements:after.elements-before.elements,
        behaviorCases:cases,reproducedBaselineMisses:4,changedRules:[ruleName],newVariables:0,warnings:after.warnings,
        verification:'Compiled actions checked for body aim, different eye heights, ledges, cone edges and angle wrapping; cooldown/input edge, range, wall/team/death/attachment/teleport exclusions, knockback scale and all other rules preserved.',
        executionTradeoff:'Horizontal angle math replaces the eye-point cone only on ready Melee presses; no polling or new loops.',
        limitation:'Native impulse physics, actual map visibility and input scheduling require an in-game check. Other causes of missed pushes are not ruled out.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-long-reach-push-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
