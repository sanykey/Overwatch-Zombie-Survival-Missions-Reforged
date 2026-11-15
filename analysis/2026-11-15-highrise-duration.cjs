const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const baseline = path.join(__dirname, '2026-11-15-highrise-duration-before.json');
(async () => {
    await compiler.readyPromise;
    const compiled = await compiler.compile(fs.readFileSync(path.join(root, 'src/includes.opy'), 'utf8'),
        'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(compiled.encounteredWarnings, []);
    const rules = [...compiled.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)]
        .map(([, name, body]) => ({name, hash: crypto.createHash('sha256').update(body).digest('hex')}));
    if (process.argv[2] === 'before') {
        fs.writeFileSync(baseline, JSON.stringify({elements: compiled.nbElements, rules}, null, 2) + '\n');
        return;
    }
    const before = JSON.parse(fs.readFileSync(baseline, 'utf8'));
    assert.deepEqual(rules.map(r => r.name), before.rules.map(r => r.name));
    const changed = rules.filter((r, i) => r.hash !== before.rules[i].hash).map(r => r.name);
    // The activation subroutine also changes because its exported comment was updated.
    assert.deepEqual(changed.slice().sort(), ['[HIGHRISE] AIRBORNE DAMAGE', 'useAugmentAirAction', 'AUGMENT MENU', 'ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)'].sort());
    const body = compiled.result.match(/^rule \("\[HIGHRISE\] AIRBORNE DAMAGE"\) \{([\s\S]*?)^\}/m)[1];
    assert.match(body.replace(/\/\/[^\n]*/g, ''), /Wait Until\(Or\(Is On Ground\(Event Player\), Is Dead\(Event Player\)\), 7\);\s+Wait\(0\.1, Ignore Condition\);\s+Set Player Variable\(Event Player, augmentState3, False\);\s+Call Subroutine\(applyDamageDealtModifier\);/);
    const report = {compiler: 'OverPy 9.7.21', beforeElements: before.elements,
        afterElements: compiled.nbElements, deltaElements: compiled.nbElements - before.elements,
        warnings: compiled.encounteredWarnings, changed, newVariables: 0,
        limitations: 'Compiled output checked; no in-game test.'};
    fs.writeFileSync(path.join(root, 'main.ws.txt'), compiled.result);
    fs.writeFileSync(path.join(__dirname, '2026-11-15-highrise-duration-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => { console.error(e); process.exitCode = 1; });
