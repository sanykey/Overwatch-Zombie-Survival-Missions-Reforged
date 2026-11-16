const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const mode = process.argv[2];
const artifact = suffix => path.join(__dirname, '2026-11-15-augment-files-' + suffix + '.json');
const renames = {
    'APOTHECARY CURE ICON': '[APOTHECARY AUGMENT] CURE ICON',
    'APOTHECARY CURE ICON DISCONNECT CLEANUP': '[APOTHECARY AUGMENT] CURE ICON DISCONNECT CLEANUP',
    'APOTHECARY ULTIMATE RECHARGE': '[APOTHECARY AUGMENT] ULTIMATE RECHARGE',
    'LASER BARRICADE BLOCKS ZOMBIES': '[LASER_BARRICADE AUGMENT] BLOCKS ZOMBIES',
};
const normalize = body => body.split('\n').filter(l => !/^\s*(?:"|\/\/)/.test(l)).map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
(async () => {
    await compiler.readyPromise;
    const input = fs.readFileSync(require('./source-layout.cjs').sourcePath('includes.opy'), 'utf8');
    const result = await compiler.compile(input, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    const rules = [...result.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name, code: normalize(body)}));
    const report = {elements: result.nbElements, eachPlayerRules: rules.filter(r => r.code.includes('Ongoing - Each Player;')).length,
        rules: rules.map(r => ({name: r.name, hash: crypto.createHash('sha256').update(r.code).digest('hex')})), warnings: result.encounteredWarnings};
    if (mode === 'before') {
        fs.writeFileSync(artifact('before'), JSON.stringify(report, null, 2) + '\n');
        console.log(JSON.stringify({elements: report.elements, eachPlayerRules: report.eachPlayerRules}));
        return;
    }
    const before = JSON.parse(fs.readFileSync(artifact('before'), 'utf8'));
    const sorted = list => list.map(r => JSON.stringify(r)).sort();
    assert.deepEqual(sorted(report.rules), sorted(before.rules.map(r => ({...r, name: renames[r.name] || r.name}))));
    assert.equal(report.elements, before.elements);
    assert.equal(report.eachPlayerRules, before.eachPlayerRules);
    // Rule labels of very different lengths must not affect generated instructions.
    const short = await compiler.compile('rule "A":\n    smallMessage(getAllPlayers(), "test")\n', 'en-US');
    const long = await compiler.compile('rule "[LASER BARRICADE AUGMENT] EXPLICIT DESCRIPTIVE RULE NAME FOR ELEMENT COUNT CHECK":\n    smallMessage(getAllPlayers(), "test")\n', 'en-US');
    assert.equal(short.nbElements, long.nbElements);
    assert.equal(normalize(short.result.match(/actions \{([\s\S]*?)\}/)[1]), normalize(long.result.match(/actions \{([\s\S]*?)\}/)[1]));
    const summary = {beforeElements: before.elements, afterElements: report.elements, elementDelta: report.elements - before.elements,
        eachPlayerRules: report.eachPlayerRules, identicalRuleBodies: report.rules.length, renamedRules: renames,
        nameLengthExperiment: {shortElements: short.nbElements, longElements: long.nbElements}, warnings: report.warnings,
        limitations: 'Static compiler equivalence; no in-game timing or UI measurement.'};
    fs.writeFileSync(artifact('after'), JSON.stringify(summary, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
    console.log(JSON.stringify(summary, null, 2));
})().catch(e => {console.error(e);process.exitCode = 1;});
