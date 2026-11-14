// Optional behavior changes are compiled only in memory, after the safe optimization.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {variants} = require('./2026-11-14-wrestler-optimization-probe.cjs');
const {removeWrestler} = require('./2026-11-14-wrestler-full-cost.cjs');
(async () => {
    await compiler.readyPromise;
    const baseline = await compile(files);
    const rows = [];
    for (const choices of [['noCountdownHud'], ['staticHud'], ['immediateThrowDamage'], ['noCarryProtection'], ['staticHud','immediateThrowDamage','noCarryProtection']]) {
        const candidate = {...files};
        choices.forEach(name => variants[name](candidate));
        const after = await compile(candidate);
        assert.deepEqual(after.warnings, []);
        rows.push({choices, elements:after.elements, saved:baseline.elements-after.elements});
    }
    const absent = {...files};
    removeWrestler(absent);
    const without = await compile(absent);
    assert.deepEqual(without.warnings, []);
    const report = {baseline:baseline.elements, withoutWrestler:without.elements,
        fullWrestlerCost:baseline.elements-without.elements, optionalCuts:rows,
        limitations:'Optional cuts measured independently from the safe optimized baseline. No feature cuts applied to production. No in-game validation.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-wrestler-feature-cuts.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(error => {console.error(error);process.exitCode=1;});
