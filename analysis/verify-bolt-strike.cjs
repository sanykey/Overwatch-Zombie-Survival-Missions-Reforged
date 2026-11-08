// Execute the emitted Bolt Strike actions; native RNG/line-of-sight remain engine behavior.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const cp = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, actions, enhancementCount} = require('./verify-augments.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define '+name+' (\\w+)$','m'))[1];
const energy = slot('enhancementBoltEnergy'), burst = slot('enhancementBoltBurst');
const boltId = Number(files['variables.opy'].match(/^    BOLT_STRIKE = (\d+),$/m)[1]);
const damageName = 'BOLT STRIKE DAMAGE', armName = 'BOLT STRIKE ARMS CHARGE', clearName = 'BOLT STRIKE CLEARS CHARGE';
const enemy = (id,x,extra={}) => ({id,team:2,position:[x,0,0],health:1000,alive:true,visible:true,status:new Set(),...extra});
async function main() {
    await compiler.readyPromise;
    const build = await compile(files); assert.deepEqual(build.warnings,[]);
    const parsed = rules(build.result), compiled = new Map(parsed.map(r=>[r.name,r]));
    const boltRules = parsed.filter(r=>r.name.startsWith('BOLT STRIKE'));
    assert.deepEqual(boltRules.map(r=>r.name),[damageName,armName,clearName]);
    for (const rule of boltRules) {
        assert(!/Create Beam|Create Effect|Destroy Effect|Wait\(|Wait Until|Chase|Start Rule/.test(rule.body));
        assert(!rule.body.includes('Call Subroutine('),'No lightning cleanup subroutine');
    }
    assert(!files['main.opy'].includes('#!extension beamEffects'));
    assert(!Object.values(files).join('\n').match(/enhancementBolt(?:ChainEffect|EffectDeadline)|clearBoltEffects/));
    assert(!compiled.has('APOTHECARY ALLOW HEALTH PACK PICKUP'));
    assert.equal(boltId,12);assert.equal(enhancementCount,12);
    assert(files['variables.opy'].includes('    DEAD_WEIGHT = 11,'));
    const run = (name,s) => applies(compiled.get(name),s) ? start(compiled.get(name),s,compiled) : null;
    function state(overrides={}) {
        const s=scenario(1,{eventDamage:100,eventAbility:'Primary Fire',...overrides});
        Object.assign(s.player,{enhancementId:boltId,team:1,[energy]:0,[burst]:0});
        s.expectedDamager=s.player; s.victim=enemy('original',0);
        s.targets=[s.victim,enemy('a',1),enemy('b',2)];
        return s;
    }
    let cases=0;
    for(const amount of [1,40,80,100,1000]) {
        const s=state({eventDamage:amount});const initial=s.victim.health;
        assert(run(damageName,s).done()); const hit=Math.min(20,amount*.25);
        assert.deepEqual(s.damage.map(d=>d.amount),[hit,hit]);
        assert.equal(s.player[energy],2*hit);assert.equal(s.player[burst],0);
        assert.equal(s.victim.health,initial,'Unarmed chains never damage the original victim');
        assert.equal(s.shuffleCalls,1);assert.equal(s.effects.length,2);cases++;
    }
    const filtered=state();
    filtered.targets=[filtered.victim,enemy('dead',1,{alive:false}),enemy('hidden',1,{visible:false}),
        enemy('far',10.001),enemy('ally',1,{team:1}),enemy('a',10),enemy('b',2),enemy('third',3)];
    run(damageName,filtered);
    assert.deepEqual(filtered.damage.map(d=>d.targets[0].id),['a','b']);cases++;
    for(const targets of [0,1]) {
        const s=state();s.targets=s.targets.slice(0,targets+1);run(damageName,s);
        assert.equal(s.damage.length,targets);assert.equal(s.player[energy],targets*20);cases++;
    }
    const reduced=state(); reduced.targets[1].damageMultiplier=.25; reduced.targets[2].health=3;
    run(damageName,reduced);assert.equal(reduced.player[energy],8,'Only actual health loss is banked');cases++;
    const immune=state();immune.targets[1].invincible=true;immune.targets[2].invincible=true;
    run(damageName,immune);assert.equal(immune.player[energy],0);cases++;
    const capped=state();capped.player[energy]=195;run(damageName,capped);assert.equal(capped.player[energy],200);cases++;
    for(const phase of [undefined,false,0]) {
        const s=state(); if(phase===undefined) delete s.globals.isGameplayActive;else s.globals.isGameplayActive=phase;
        s.globals.tmp0=123;run(damageName,s);assert.equal(s.damage.length,0);assert.equal(s.shuffleCalls,undefined);
        assert.equal(s.globals.tmp0,123,'Phase rejection precedes target queries and scratch writes');cases++;
    }
    for(const primary of [0,1,9,11]) {
        const s=state();s.player.enhancementId=primary;run(damageName,s);
        assert.equal(s.damage.length,0);assert.equal(s.shuffleCalls,undefined);cases++;
    }
    for(const rejected of ['scripted','zero damage','friendly victim']) {
        const s=state();
        if(rejected==='scripted')s.eventAbility=0;
        if(rejected==='zero damage')s.eventDamage=0;
        if(rejected==='friendly victim')s.victim.team=1;
        assert.equal(run(damageName,s),null);cases++;
    }
    for(const bank of [0,199.999,200]) for(const held of [false,true]) for(const alive of [false,true]) {
        const s=state({buttons:new Set(held?['Melee']:[]),alive});s.player[energy]=bank;
        const armed=!!run(armName,s),expected=bank>=200 && held && alive;
        assert.equal(armed,expected);assert.equal(s.player[energy],expected?0:bank);
        assert.equal(s.player[burst],expected?-1:0);cases++;
    }
    const already=state({buttons:new Set(['Melee'])});already.player[energy]=200;already.player[burst]=-1;
    assert.equal(run(armName,already),null);assert.equal(already.player[energy],200);cases++;
    const inactive=state({buttons:new Set(['Melee'])});inactive.player[energy]=200;inactive.globals.isGameplayActive=false;
    assert.equal(run(armName,inactive),null);cases++;
    const armed=state();armed.player[burst]=-1;armed.targets=[armed.victim];armed.buttons.clear();
    run(damageName,armed);assert.equal(armed.player[burst],100.3);assert.equal(armed.victim.health,940);
    assert.deepEqual(armed.statusWrites.map(s=>[s.target,s.status,s.duration]),[['original','Stunned',2]]);
    assert.equal(armed.player[energy],0,'The 60 damage burst does not charge itself');cases++;
    for(const time of [100.299,100.3]) {
        const s=state({time});s.player[burst]=100.3;s.player[energy]=19;
        run(damageName,s);assert.equal(s.damage.length,time<100.3?3:2);
        assert.equal(s.player[energy],59,'Chains continue charging the next bank during a burst');
        assert.equal(s.player[burst],100.3,'Later hits do not extend the window');
        const task=run(clearName,s);assert.equal(!!task,time>=100.3);assert.equal(s.player[burst],time>=100.3?0:100.3);cases++;
    }
    for(const initial of [-1,100.3]) for(const reason of ['death','game end']) {
        const s=state();s.player[energy]=73;s.player[burst]=initial;
        if(reason==='death')s.alive=false;else s.globals.isGameplayActive=false;
        assert(run(clearName,s).done());assert.equal(s.player[burst],0);assert.equal(s.player[energy],73);cases++;
    }
    const idle=state();idle.alive=false;assert.equal(run(clearName,idle),null);cases++;
    const leech=state();leech.player.augmentId=10;leech.player.health=100;leech.maxHealth=1000;
    run(damageName,leech);const hits=[...leech.damage];leech.expectedHealer=leech.player;
    leech.eventAbility=0;
    for(const hit of hits) {
        leech.eventDamage=hit.amount;assert.equal(run(damageName,leech),null,'Scripted chain damage cannot recurse');
        run('LEECH LIFESTEAL',leech);
    }
    assert.equal(leech.player.health,106);assert.equal(leech.player[energy],40);assert.equal(leech.damage.length,2);cases++;
    for(let augment=1;augment<=10;augment++) {
        const s=state();s.player.augmentId=augment;s.player.initialMaxHealth=250;
        s.player[energy]=53;s.player[burst]=-1;
        const field=slot('augmentScavengerBackpack');s.player[field]=[7,9];
        assert(run('PLAYER ENHANCEMENT INITIALIZATION',s).done());
        assert.equal(s.player[energy],0);assert.equal(s.player[burst],0);assert.equal(s.huds,1);
        assert.deepEqual(s.player[field],[7,9]);cases++;
    }
    const switched=state();switched.player.isHeroSwitchRespawn=true;switched.player[energy]=57;switched.player[burst]=-1;
    assert.equal(run('PLAYER ENHANCEMENT INITIALIZATION',switched),null);assert.equal(switched.player[energy],57);cases++;
    const emitted=build.result.match(/^rule \("BOLT STRIKE DAMAGE"\) \{[\s\S]*?^\}/m)[0];checkWorkshop(emitted);
    assert(actions(compiled.get(damageName)).some(a=>a.includes('Randomized Array')));
    let comparison;
    const compareIndex=process.argv.indexOf('--compare-ref');
    if(compareIndex>=0) {
        const ref=process.argv[compareIndex+1];assert(ref && !ref.startsWith('--'));
        const git=(...args)=>cp.execFileSync('git',args,{encoding:'utf8',maxBuffer:16*1024*1024});
        const before={};
        for(const file of git('ls-tree','-r','--name-only',ref,'--','src').trim().split('\n').filter(n=>n.endsWith('.opy'))) {
            const name=file.slice(4);before[name==='includes.opy'?'main.opy':name]=git('show',ref+':'+file).replace(/\r\n/g,'\n');
        }
        const baseline=await compile(before);assert.deepEqual(baseline.warnings,[]);
        const old=rules(baseline.result), retained=parsed.filter(r=>!r.name.startsWith('BOLT STRIKE'));
        assert.equal(retained.length,old.length);
        const changed=[];
        retained.forEach((rule,index)=>{assert.equal(rule.name,old[index].name);if(rule.body!==old[index].body)changed.push(rule.name);});
        assert.deepEqual(changed,['Initialize global variables','EFFECTS/TEXTS','PLAYER ENHANCEMENT INITIALIZATION']);
        for(const section of ['settings','variables','subroutines']) {
            const re=new RegExp('^'+section+'\\s*\\{[\\s\\S]*?^\\}','m');
            assert.equal(build.result.match(re)[0],baseline.result.match(re)[0]);
        }
        for(const file of ['augments.opy','players_game_in_progress.opy','power_ups.opy','supply_drops.opy'])
            assert.equal(files[file],before[file],'Keep existing gameplay and UI workarounds: '+file);
        comparison={ref,beforeElements:baseline.elements,afterElements:build.elements,delta:build.elements-baseline.elements,
            addedRules:3,changedExistingRules:changed,unchangedExistingRules:old.length-changed.length,
            newVariables:0,mapsAndDeclarations:'identical'};
    }
    if(process.argv.includes('--export')) {
        const root=path.dirname(src);
        const exported=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(exported.encounteredWarnings,[]);assert.equal(exported.nbElements,build.elements);
        assert.deepEqual(rules(exported.result),parsed);fs.writeFileSync(path.join(root,'main.ws.txt'),exported.result);
    }
    const report={elements:build.elements,warnings:0,rules:parsed.length,cases,comparison,
        checked:'25%/20 cap/two visible living secondary targets/10m boundary/no victim/actual-health bank/200 cap/arming/window/expiry/death/retained bank/no recursion/Leech/all Augments/stable Dead Weight ID/no persistent effects/no waits',
        exported:process.argv.includes('--export'),limitation:'Native RNG distribution and geometry require the game; no client UI stability claim.'};
    if(process.argv.includes('--report')) fs.writeFileSync(path.join(path.dirname(src),'analysis/bolt-strike-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
}
main().catch(e=>{console.error(e);process.exitCode=1;});
