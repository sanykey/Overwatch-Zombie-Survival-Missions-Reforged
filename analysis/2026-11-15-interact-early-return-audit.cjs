const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const source = fs.readFileSync(require('./source-layout.cjs').sourcePath('supply_drops.opy'), 'utf8').replace(/\r\n/g, '\n');
const start = source.indexOf('rule "PLAYER INTERACT');
const end = source.indexOf('\ndef instantRevive():', start);
const original = source.slice(start, end);
// Insert before dedented comments too: OverPy comments affect block boundaries.
const modified = original.replace(/\n((?:    #[^\n]*\n)*)    elif /g, '\n        return\n\n$1    if ');
assert.equal((original.match(/^    elif /gm) || []).length, 3);
(async () => {
    await compiler.readyPromise;
    const rows = [];
    for (const [name, rule] of [['elif', original], ['early-return', modified]]) {
        const fullSource = source.slice(0, start) + rule + source.slice(end);
        const input = fs.readFileSync(require('./source-layout.cjs').sourcePath('includes.opy'), 'utf8').replace('#!include "supply_drops.opy"', fullSource.replace(/^#!mainFile.*$/gm, ''));
        const result = await compiler.compile(input, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
        assert.deepEqual(result.encounteredWarnings, []);
        const compiled = result.result.match(/\/\/(\d+) elements\nrule \("PLAYER INTERACT[^\n]+\n[\s\S]*?^\}/m);
        rows.push({name, totalElements: result.nbElements, interactElements: Number(compiled[1]), warnings: result.encounteredWarnings});
        fs.writeFileSync(path.join(__dirname, '2026-11-15-interact-' + name + '.ws.txt'), compiled[0] + '\n');
    }
    fs.writeFileSync(path.join(__dirname, '2026-11-15-interact-early-return-results.json'), JSON.stringify(rows, null, 2) + '\n');
    console.log(JSON.stringify(rows, null, 2));
})().catch(e => {console.error(e);process.exitCode = 1;});
