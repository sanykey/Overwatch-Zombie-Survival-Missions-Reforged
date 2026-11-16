const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const mode = process.argv[2];
assert(['before', 'after'].includes(mode));
const artifact = suffix => path.join(__dirname, '2026-11-15-ultimate-rider-merges-' + suffix + '.json');
const changed = ['PLAYER ULTIMATE DAMAGE RESIST', '[APOTHECARY AUGMENT] ULTIMATE RECHARGE',
    'RIDER DETACH WHEN DEAD OR TARGET IS DEAD', 'RIDER DETATCH FROM TEAMMATES WHILE ALIVE', 'RIDER DETACH'];
const normalize = body => body.split('\n').filter(l => !/^\s*(?:"|\/\/)/.test(l))
    .map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
(async () => {
    await compiler.readyPromise;
    const result = await compiler.compile(fs.readFileSync(require('./source-layout.cjs').sourcePath('includes.opy'), 'utf8'), 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    const rules = [...result.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name, body}));
    const report = {elements: result.nbElements, eachPlayerRules: rules.filter(r => r.body.includes('Ongoing - Each Player;')).length,
        rules: rules.map(r => ({name:r.name, hash:crypto.createHash('sha256').update(normalize(r.body)).digest('hex')})),
        riderActions: normalize(rules.find(r => r.name === (mode === 'before' ? changed[2] : changed[4])).body.match(/actions \{([\s\S]*)/)[1]),
        warnings:result.encounteredWarnings};
    if (mode === 'before') {
        fs.writeFileSync(artifact('before'), JSON.stringify(report, null, 2) + '\n');
        console.log(JSON.stringify({elements:report.elements, eachPlayerRules:report.eachPlayerRules, rules:report.rules.length}));
        return;
    }
    const before = JSON.parse(fs.readFileSync(artifact('before'), 'utf8'));
    assert.deepEqual(report.rules.filter(r => !changed.includes(r.name)), before.rules.filter(r => !changed.includes(r.name)));
    assert.equal(report.riderActions, before.riderActions);
    assert.equal(report.rules.length, before.rules.length - 2);
    assert.equal(report.eachPlayerRules, before.eachPlayerRules - 2);
    assert.equal(report.elements, before.elements + 2);
    const ultimate = rules.find(r => r.name === changed[0]).body;
    assert(ultimate.indexOf('augmentApothecaryReady') < ultimate.indexOf('Wait Until('));
    assert(ultimate.includes('Wait Until(Not(Is Using Ultimate(Event Player)), 999999999999);'));
    for (const name of [changed[1], changed[2], changed[3]]) assert(!rules.some(r => r.name === name));
    const summary = {beforeElements:before.elements, afterElements:report.elements, elementDelta:report.elements-before.elements,
        beforeEachPlayerRules:before.eachPlayerRules, afterEachPlayerRules:report.eachPlayerRules,
        beforeRules:before.rules.length, afterRules:report.rules.length,
        unchangedCompiledRules:report.rules.filter(r=>!changed.includes(r.name)).length, riderActionsUnchanged:true,
        warnings:report.warnings, limitations:'Compiled verification only; no in-game timing or UI test.'};
    fs.writeFileSync(artifact('after'), JSON.stringify(summary, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
    console.log(JSON.stringify(summary, null, 2));
})().catch(e => {console.error(e);process.exitCode=1;});
