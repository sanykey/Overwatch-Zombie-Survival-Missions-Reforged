// Compare complete compiler output before/after a path-only reorganization.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const artifact = suffix => path.join(__dirname, '2026-11-16-folder-layout-' + suffix + '.json');
const hash = text => crypto.createHash('sha256').update(text).digest('hex');
const executableText = text => text.slice(text.indexOf('*/') + 2)
    .replace(/\r\n/g, '\n').replace(/^\s*"[^\n]*"\s*$/gm, '')
    .replace(/\/\/[^\n]*/g, '').trim();
(async () => {
    await compiler.readyPromise;
    const result = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
        'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    // Compiler debug headers contain source locations, which intentionally change.
    const executable = executableText(result.result);
    const report = {compiler: 'OverPy 9.7.21', elements: result.nbElements,
        rules: [...result.result.matchAll(/^rule \(/gm)].length,
        executableHash: hash(executable), warnings: result.encounteredWarnings};
    if (process.argv[2] === 'before') {
        fs.writeFileSync(artifact('before'), JSON.stringify(report, null, 2) + '\n');
    } else {
        const before = JSON.parse(fs.readFileSync(artifact('before'), 'utf8'));
        assert.deepEqual(report, before, 'Compiled behavior or element count changed');
        const {readLegacyTree} = require('./source-layout.cjs');
        const files = readLegacyTree();
        const flattened = files['includes.opy'].replace(/^#!include "([^"]+)".*$/gm,
            (_, name) => files[name].replace(/^#!mainFile .*\n/gm, ''));
        const probe = await compiler.compile(flattened, 'en-US',
            path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
        assert.deepEqual(probe.encounteredWarnings, []);
        assert.equal(probe.nbElements, report.elements);
        assert.equal(hash(executableText(probe.result)), report.executableHash);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
        fs.writeFileSync(artifact('validation'), JSON.stringify({...report, elementDelta: 0,
            legacyProbeLoaderEquivalent: true,
            verification: 'Complete compiled executable text and ordered rules match before relocation; debug source locations and Workshop comments are excluded.'}, null, 2) + '\n');
    }
    console.log(JSON.stringify(report));
})().catch(error => { console.error(error); process.exitCode = 1; });
