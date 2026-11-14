const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
const crypto=require('node:crypto');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
const artifact=name=>path.join(__dirname,'2026-11-14-charge-battery-extraction-'+name+'.json');
const hash=body=>crypto.createHash('sha256').update(body).digest('hex');
const renamed={
    'CHARGE BATTERY RESETS COOLDOWNS ON ULTIMATE':'[CHARGE_BATTERY] RESET COOLDOWNS ON ULTIMATE',
    'CHARGE BATTERY HALVES NEW COOLDOWNS':'[CHARGE_BATTERY] HALVE NEW COOLDOWNS',
    'CHARGE BATTERY':'[CHARGE_BATTERY] PLACE BATTERY',
    'CHARGE BATTERY (USAGE AND COOLDOWNS)':'[CHARGE_BATTERY] USAGE AND COOLDOWNS',
};
(async()=>{
    await compiler.readyPromise;
    const before=JSON.parse(fs.readFileSync(artifact('before'),'utf8'));
    const after=await compile(files), current=rules(after.result);
    assert.deepEqual(after.warnings,[]);
    assert(after.elements<before.elements);
    assert.equal(current.length,before.rules.length-1);
    const remaining=[...current];
    for(const old of before.rules){
        if(old.name==='CHARGE BATTERY HALVES NEW COOLDOWNS')continue;
        if(old.name==='CHARGE BATTERY RESETS COOLDOWNS ON ULTIMATE'){
            const index=remaining.findIndex(r=>r.name===renamed[old.name]);
            assert(index>=0);
            assert.equal(remaining[index].body.split('actions {\n')[1],'Call Subroutine(resetAbilityCooldowns);\n}');
            remaining.splice(index,1);
            continue;
        }
        const expectedName=renamed[old.name]??old.name, expectedHash=old.hash??hash(old.body);
        const index=remaining.findIndex(r=>r.name===expectedName && hash(r.body)===expectedHash);
        assert(index>=0,old.name+' compiled conditions/actions changed');
        remaining.splice(index,1);
    }
    assert.equal(remaining.length,0);
    assert.equal(current.filter(r=>r.name.startsWith('[CHARGE_BATTERY]')).length,3);
    assert(!files['enhancements.opy'].includes('enhancementBattery'));
    assert(!files['player_initialization.opy'].includes('createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBattery'));
    // Keep the captured baseline compact: only rule names and action/condition hashes are needed.
    if(before.rules.some(r=>r.body))fs.writeFileSync(artifact('before'),JSON.stringify({elements:before.elements,warnings:before.warnings,
        rules:before.rules.map(r=>({name:r.name,hash:hash(r.body)}))},null,2)+'\n');
    const report={beforeElements:before.elements,afterElements:after.elements,deltaElements:after.elements-before.elements,
        rulesCompared:current.length,renamedRules:Object.values(renamed).filter(n=>!n.includes('HALVE NEW COOLDOWNS')),removedRule:'[CHARGE_BATTERY] HALVE NEW COOLDOWNS',warnings:after.warnings,
        verification:'Apart from the removed 7-second monitor and timestamp write, all compiled condition/action bodies match the pre-extraction working tree. HUD and initialization are unchanged.'};
    fs.writeFileSync(artifact('validation'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
