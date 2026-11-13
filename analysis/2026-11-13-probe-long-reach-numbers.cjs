const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const generator=fs.readFileSync('src/create numbers.js','utf8');
const rows=[[4,100,0.4,0.56],[6,45,0.2,0.4],[4,60,0.2,0.456],[5,100,0.15,0],[10,65,0.15,0.45],[2.5,70,0.35,0.35]];
(async()=>{
    await compiler.readyPromise;
    const baseline=await compile(files),results=[];
    for(const layout of ['prepend-hero','append-hero']) {
        const f={...files};
        const generated=vm.runInNewContext(generator.replace('let numberIndex = 0;',`numbers.push({offset:'NL_LONG_REACH_PROFILE_OFFSET',list:${JSON.stringify(rows.flat())}});\nlet numberIndex = 0;`));
        // Expand only the invocation, not its macro declaration.
        f['compressed numbers.opy']=f['compressed numbers.opy'].replace('    createNumbers()',generated);
        const old=/    eventPlayer\.augmentWeaponProfile = \[[\s\S]*?    \]\[AUGMENT_MELEE_WEAPON_HEROES\.index\(eventPlayer\.getHero\(\)\)\]/;
        assert(old.test(f['augments.opy']));
        const slice='numbersList.slice(NL_LONG_REACH_PROFILE_OFFSET + AUGMENT_MELEE_WEAPON_HEROES.index(eventPlayer.getHero()) * 4, 4)';
        const expr=layout==='prepend-hero'?'[eventPlayer.getHero()].concat('+slice+')':slice+'.concat([eventPlayer.getHero()])';
        f['augments.opy']=f['augments.opy'].replace(old,'    eventPlayer.augmentWeaponProfile = '+expr);
        f['augments.opy']=f['augments.opy'].replace('wait(eventPlayer.augmentWeaponProfile[4], Wait.IGNORE_CONDITION)','wait(0.7 / 1.15 - 0.15 if eventPlayer.augmentWeaponProfile[0] == Hero.GENJI else eventPlayer.augmentWeaponProfile[4], Wait.IGNORE_CONDITION)');
        if(layout==='append-hero') f['augments.opy']=f['augments.opy'].replace(/eventPlayer\.augmentWeaponProfile\[(\d)\]/g,(_,n)=>'eventPlayer.augmentWeaponProfile['+({0:4,1:0,2:1,3:2,4:3}[n])+']');
        const b=await compile(f);assert.deepEqual(b.warnings,[]);
        results.push({layout,elements:b.elements,saving:baseline.elements-b.elements,ruleElements:Number(b.result.match(/\/\/(\d+) elements\nrule \("LONG REACH MELEE WEAPONS"/)[1]),profileAction:b.result.split('\n').find(l=>l.includes('Set Player Variable(Event Player, augmentState2,')&&l.includes('Array Slice(Global.numbersList')),warnings:b.warnings});
    }
    const report={baseline:baseline.elements,rows,genjiRecoveryPreserved:0.7/1.15-0.15,compressedRoundingWouldProduce:0.459,results};
    fs.writeFileSync('analysis/2026-11-13-long-reach-numbers-probe.json',JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
