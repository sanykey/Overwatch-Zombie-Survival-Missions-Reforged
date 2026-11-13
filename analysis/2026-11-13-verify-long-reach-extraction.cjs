const fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
const {scenario,start}=require('./verify-augments.cjs');
const baselinePath='analysis/2026-11-13-long-reach-extract-baseline.json';
(async()=>{
    await compiler.readyPromise;
    const baseline=JSON.parse(fs.readFileSync(baselinePath,'utf8'));
    const build=await compile(files);
    assert.deepEqual(build.warnings,[]);
    assert.equal(build.elements,baseline.elements);
    const newRules=rules(build.result);
    const sorted=rows=>[...rows].sort((a,b)=>a.name.localeCompare(b.name));
    const digest=text=>crypto.createHash('sha256').update(text).digest('hex');
    assert.equal(digest(JSON.stringify(sorted(newRules))),baseline.compiledRulesHash,'All compiled rule bodies must remain identical');
    const declarations=s=>s.match(/variables\s*\{[\s\S]*?\n\}/)[0];
    assert.equal(digest(declarations(build.result)),baseline.compiledVariablesHash);
    const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
    assert.equal(hash('src/player_initialization.opy'),baseline.hudSourceHash);
    assert.equal(hash('src/variables.opy'),baseline.variablesSourceHash);
    const names=newRules.filter(r=>r.name.startsWith('[LONG_REACH]')).map(r=>r.name);
    assert.equal(names.length,5);
    const newMap=new Map(newRules.map(r=>[r.name,r]));
    const slot=name=>files['variables.opy'].match(new RegExp('^#!define '+name+' (\\w+)$','m'))[1];
    // The push writer and HUD reader must keep owning the same cooldown slot.
    assert.equal(slot('augmentMeleePushReadyAt'),slot('augmentMovementReadyAt'));
    const push=newMap.get('[LONG_REACH] MELEE PUSH');
    const s=scenario(4,{meleeing:true,buttons:new Set(['Melee']),targets:[{id:'hit',position:[0,0,5],alive:true,visible:true}]});
    s.player[slot('augmentMeleePushReadyAt')]=0;
    s.targets[0][slot('botKnockbackScale')]=1;
    start(push,s,newMap);
    assert.equal(s.player[slot('augmentMovementReadyAt')],109);
    assert.equal(s.impulses.length,1);
    const report={before:baseline.elements,after:build.elements,unchangedCompiledRuleBodies:newRules.length,
        movedRules:names,hudSourceUnchanged:true,variableContractsUnchanged:true,
        pushCooldownVisibleToHud:9,warnings:build.warnings};
    if(process.argv.includes('--export')) {
        const path=require('node:path'),root=path.resolve(__dirname,'..');
        const output=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(output.encounteredWarnings,[]);assert.equal(output.nbElements,build.elements);
        assert.deepEqual(rules(output.result),newRules);
        fs.writeFileSync('main.ws.txt',output.result);report.exported=true;
    }
    fs.writeFileSync('analysis/2026-11-13-long-reach-extraction-validation.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
