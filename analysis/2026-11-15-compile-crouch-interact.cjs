const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const mode = process.argv[2];
assert(['before', 'after'].includes(mode));
const artifact = suffix => path.join(__dirname, '2026-11-15-crouch-interact-' + suffix + '.json');
const mergedName = 'CROUCH + INTERACT (APOTHECARY TELEPORT / LASER BARRICADE)';
const oldNames = ['APOTHECARY TELEPORT', 'LASER BARRICADE (PLACEMENT)'];
const normalize = body => body.split('\n').filter(l => !/^\s*(?:"|\/\/)/.test(l)).map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
(async () => {
    await compiler.readyPromise;
    const result = await compiler.compile(fs.readFileSync(path.join(src, 'includes.opy'), 'utf8'), 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    const rules = [...result.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name, body}));
    const report = {elements: result.nbElements, eachPlayerRules: rules.filter(r => r.body.includes('Ongoing - Each Player;')).length,
        rules: rules.map(r => ({name: r.name, hash: crypto.createHash('sha256').update(normalize(r.body)).digest('hex')})), warnings: result.encounteredWarnings};
    if (mode === 'before') {
        fs.writeFileSync(artifact('before'), JSON.stringify(report, null, 2) + '\n');
        console.log(JSON.stringify({elements: report.elements, eachPlayerRules: report.eachPlayerRules}));
        return;
    }
    const before = JSON.parse(fs.readFileSync(artifact('before'), 'utf8'));
    // Position within the filtered list disambiguates duplicate rule names.
    assert.deepEqual(report.rules.filter(r => r.name !== mergedName), before.rules.filter(r => !oldNames.includes(r.name)));
    assert.equal(report.rules.length, before.rules.length - 1);
    assert.equal(report.eachPlayerRules, before.eachPlayerRules - 1);
    const merged = rules.find(r => r.name === mergedName).body;
    assert(merged.includes('Wait(0.25, Abort When False);'));
    assert(merged.includes('Wait Until(Or(Not(Is Button Held(Event Player, Button(Interact))), Is Dead(Event Player)), 0.5);'));
    assert(merged.includes('Wait Until(Or(Not(Is Button Held(Event Player, Button(Interact))), Is Dead(Event Player)), 999999999999);'));
    assert(merged.includes('Teleport(Event Player,'));
    const summary = {beforeElements: before.elements, afterElements: report.elements, delta: report.elements - before.elements,
        beforeEachPlayerRules: before.eachPlayerRules, afterEachPlayerRules: report.eachPlayerRules,
        removed: oldNames, added: mergedName, unchangedRules: report.rules.length - 1, warnings: report.warnings,
        limitations: 'Compiled structure and rule comparison only; no in-game test.'};
    fs.writeFileSync(artifact('after'), JSON.stringify(summary, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
    console.log(JSON.stringify(summary, null, 2));
})().catch(e => {console.error(e);process.exitCode = 1;});
