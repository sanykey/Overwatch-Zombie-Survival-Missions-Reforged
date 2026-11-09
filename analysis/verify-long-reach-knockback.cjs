// Execute emitted button-push actions; native scheduling and physics need in-game testing.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const cp = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const slot = n => files['variables.opy'].match(new RegExp('^#!define ' + n + ' (\\w+)$', 'm'))[1];
const ready = slot('augmentMeleePushReadyAt');
const scale = slot('botKnockbackScale'), attached = slot('botIsAttached'), teleport = slot('botIsTeleporting');
const zombie = (id, position, extra = {}) => ({id,team:2,position,alive:true,visible:true,health:1000,[scale]:1,...extra});
// Compare the complete feature against its original base, including after commits.
const baselineRef = '7c2a6f1';
async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const p of ['augments.opy','player_initialization.opy','variables.opy']) baseline[p] = cp.execFileSync('git',['show',baselineRef+':src/'+p],{encoding:'utf8'}).replace(/\r\n/g,'\n');
    const before = await compile(baseline), build = await compile(files);
    assert.deepEqual(build.warnings,[]);
    const parsed = rules(build.result), compiled = new Map(parsed.map(r => [r.name,r]));
    const push = 'LONG REACH MELEE PUSH', input = compiled.get(push);
    const old = rules(before.result);
    assert.equal(parsed.length,old.length+1);
    const retained = parsed.filter(r => r.name !== push);
    assert.deepEqual(retained.map(r => r.name),old.map(r => r.name));
    const changes = old.filter((r,i) => retained[i].body !== r.body).map(r => r.name);
    assert.deepEqual(changes,['AUGMENT MENU','LONG REACH MELEE WEAPONS','LONG REACH CARNAGE','PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION']);
    const run = s => start(input,s,compiled);
    const state = (targets,extra = {}) => scenario(4,{buttons:new Set(['Melee']),targets,...extra});
    let cases = 0;
    for (const hero of ['Soldier: 76','Brigitte','Reinhardt','Torbjorn','Genji','Ana']) {
        const s = state([
            zombie('near',[0,0,2]), zombie('far',[0,0,5]), zombie('edge',[0,0,10],{[scale]:0.5}),
            zombie('outside',[0,0,10.001]), zombie('behind',[0,0,-4]), zombie('side',[5,0,2]),
            zombie('hidden',[0,0,3],{visible:false}), zombie('dead',[0,0,3],{alive:false}),
            zombie('attached',[0,0,3],{[attached]:true}), zombie('immune',[0,0,3],{[scale]:0}),
            zombie('teleport',[0,0,3],{[teleport]:true}), zombie('invincible',[0,0,3],{invincible:true}),
            zombie('ally',[0,0,3],{team:1})
        ],{hero});
        assert(run(s).done());
        assert.deepEqual(s.impulses.map(i=>[i.target,i.speed]),[['near',25],['far',25],['edge',12.5],['invincible',25]]);
        assert(s.impulses.every(i=>Math.abs(i.direction[1]-Math.sin(Math.PI/12))<1e-9 && Math.abs(i.direction[2]-Math.cos(Math.PI/12))<1e-9));
        assert.equal(s.player[ready],109);
        assert.equal(s.damage.length,0);
        assert.deepEqual(s.environmentCredits,['near','far','edge','invincible']);
        s.time=108.999; s.globals.tmp0='no query during cooldown';
        assert(run(s).done()); assert.equal(s.impulses.length,4); assert.equal(s.globals.tmp0,'no query during cooldown');
        s.time=109;
        assert(run(s).done()); assert.equal(s.impulses.length,8); assert.equal(s.player[ready],118);
        s.buttons=new Set(['Primary Fire']); assert(!applies(input,s),'Primary fire alone never starts a push');
        cases++;
    }
    for (const targets of [[],[zombie('hidden',[0,0,3],{visible:false})],[zombie('behind',[0,0,-3])],[zombie('attached',[0,0,3],{[attached]:true})],[zombie('immune',[0,0,3],{[scale]:0})]]) {
        const s=state(targets); assert(run(s).done()); assert.equal(s.player[ready]??0,0); assert.equal(s.impulses.length,0); cases++;
    }
    for (const status of ['Stunned','Asleep','Frozen','Knocked Down']) {
        const s=state([zombie('near',[0,0,2])],{status:new Set([status])});
        assert(run(s).done()); assert.equal(s.impulses.length,0); assert.equal(s.player[ready]??0,0); cases++;
    }
    const inactive=state([zombie('near',[0,0,2])]); inactive.globals.isGameplayActive=false;
    assert(run(inactive).done()); assert.equal(inactive.impulses.length,0); cases++;
    const other=state([zombie('near',[0,0,2])]); other.player.augmentId=1;
    assert(run(other).done()); assert.equal(other.impulses.length,0); cases++;
    const enlarged=state([zombie('edge',[0,0,20]),zombie('outside',[0,0,20.001])]); enlarged.player.sizeScale=2;
    assert(run(enlarged).done()); assert.deepEqual(enlarged.impulses.map(i=>i.target),['edge']); cases++;
    assert(!applies(input,{...enlarged,alive:false}));
    // All four damage controllers supply a literal 30-degree cone.
    for (const name of ['LONG REACH QUICK MELEE','LONG REACH VENDETTA SWORD','LONG REACH MELEE WEAPONS','LONG REACH CARNAGE']) {
        const query=compiled.get(name).body.split('\n').find(l=>l.startsWith('Set Global Variable(tmp0, Array('));
        assert(query && query.endsWith(', 30));'),name);
    }
    // Exercise the emitted damage query across every native range. The new
    // common cone narrows wide sweeps and widens Ramattra's former 6-degree cone.
    for (const radius of [2.5,4.3,4,6,5,10]) {
        const atAngle=(id,angle)=>zombie(id,[(radius+1)*Math.sin(angle*Math.PI/180),0,(radius+1)*Math.cos(angle*Math.PI/180)]);
        const s=state([atAngle('inside',29.9),atAngle('outside',30.1)]);
        Object.assign(s.globals,{tmp0:[radius,radius*3,30],tmp1:40});
        assert(start(compiled.get('extendAugmentMelee'),s,compiled).done());
        assert.deepEqual(s.damage.flatMap(h=>h.targets.map(t=>t.id)),['inside']); cases++;
    }
    const conditions=input.body.split('conditions {')[1].split('}')[0];
    assert(!conditions.includes(ready),'Cooldown expiry while holding Melee must not re-trigger');
    assert(!input.body.match(/Wait\(|Wait Until|Loop|Damage\(|Start Rule|Call Subroutine/));
    assert(input.body.includes('Cancel Contrary Motion'));
    const variables=f=>(f.match(/^playervar /gm)||[]).length;
    assert.equal(variables(files['variables.opy']),variables(baseline['variables.opy']));
    assert.equal((build.result.match(/^subroutines \{[\s\S]*?^\}/m)||[])[0],(before.result.match(/^subroutines \{[\s\S]*?^\}/m)||[])[0]);
    if(process.argv.includes('--write')) {
        const root=path.dirname(src);
        const out=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(out.encounteredWarnings,[]); assert.deepEqual(rules(out.result),parsed);
        fs.writeFileSync(path.join(root,'main.ws.txt'),out.result);
    }
    console.log(JSON.stringify({before:before.elements,after:build.elements,delta:build.elements-before.elements,cases,newPlayerVariables:0,newSubroutines:0,warnings:build.warnings}));
}
main().catch(e=>{console.error(e);process.exitCode=1;});
