const fs=require('node:fs');
const cp=require('node:child_process');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const baselineRef='66ab566db341aac0c1a736827c22a44aab6684b9';
(async()=>{
    await compiler.readyPromise;
    // Keep every unrelated working-tree edit in both builds, including debug.opy.
    const baseline={...files,'augments.opy':cp.execFileSync('git',['show',baselineRef+':src/augments.opy'],{encoding:'utf8'}).replace(/\r\n/g,'\n')};
    const vm=require('node:vm');
    const generator=cp.execFileSync('git',['show',baselineRef+':src/create numbers.js'],{encoding:'utf8'});
    baseline['compressed numbers.opy']=baseline['compressed numbers.opy'].replace('    createNumbers()',vm.runInNewContext(generator));
    const b=await compile(baseline);
    const rows=[...b.result.matchAll(/\/\/(\d+) elements?\s*\nrule \("([^"\n]+)"\)/g)].filter(m=>m[2].startsWith('LONG REACH')||m[2]==='extendAugmentMelee').map(m=>({name:m[2],elements:+m[1]}));
    const initialization=b.result.split('\n').filter(l=>/Set Global Variable\(augmentMelee(?:Weapon|Btn)HeroListConst,/.test(l)).reduce((s,l)=>s+Number(l.match(/\/\/ (\d+) elements/)[1]),0);
    const report={baselineRef,total:b.elements,warnings:b.warnings,initialization,rules:rows};
    fs.writeFileSync('analysis/2026-11-13-long-reach-baseline.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})();
