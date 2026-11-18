// Compile main.opy and check the Grapnel damage/range tuning landed in the output.
// Run: node analysis/2026-11-18-verify-grapnel-tuning.cjs
const fs = require('node:fs');
const path = require('node:path');
const { files, compile, compiler } = require('./measure-further-optimizations.cjs');

(async () => {
    await compiler.readyPromise;
    const out = await compile(files);
    if (out.warnings.length) console.log('warnings:', out.warnings);
    console.log('elements:', out.elements);

    const workshop = out.result;
    // Damage 75 at grapnel contact and the 45m pull-aim range (indexed per mode;
    // search radius adds a 2m buffer at runtime) in the shared selectPullAimTarget.
    const checks = [
        ['Damage 75 at contact', workshop.includes('Damage(Global.tmp3, Event Player, 75)')],
        ['range array (45, 20, 5)', workshop.includes('Array(45, 20, 5)')],
        ['menu 7-45m', workshop.includes('7-45m away') || workshop.includes('7–45m away')],
        ['menu 75 dmg', workshop.includes('75 dmg')],
        ['stale 35 dmg gone', !workshop.includes('35 dmg')],
        ['min range 7 kept', workshop.includes('>=, 7)') || workshop.includes('>= 7')],
    ];
    let failed = 0;
    for (const [name, ok] of checks) {
        console.log(ok ? 'PASS' : 'FAIL', name);
        if (!ok) failed++;
    }
    process.exit(failed ? 1 : 0);
})().catch(e => { console.error(e); process.exit(1); });
