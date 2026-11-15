const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

(async () => {
    await compiler.readyPromise;
    const baseline = {...files, 'enhancements.opy': execFileSync('git', ['show', 'HEAD:src/enhancements.opy'], {cwd: root}).toString('utf8').replace(/\r\n/g, '\n')};
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(newRules.length, oldRules.length);
    const changed = newRules.filter((r, i) => r.body !== oldRules[i].body || r.name !== oldRules[i].name).map(r => r.name);
    assert.deepEqual(changed, ['LIVING PROJECTILE RELEASE']);
    const release = newRules.find(r => r.name === changed[0]).body;
    // Both the ongoing release condition and throw validation reject carrier CC.
    assert.equal((release.match(/Not\(\(.*?\)\.isCrowdControlled\)/g) || []).length, 2, release);
    const clear = release.indexOf('Clear Status(Event Player, Knocked Down);');
    const impulse = release.indexOf('Apply Impulse(');
    const wait = release.indexOf('Wait(');
    assert(clear > release.indexOf('Detach Players(') && clear < impulse && impulse < wait, release);
    assert(release.slice(0, clear).includes('Is Dead(Global.tmp0)'), release);
    assert.equal((release.match(/Clear Status\(Event Player, Knocked Down\);/g) || []).length, 2);
    fs.writeFileSync(path.join(__dirname, '2026-11-15-wrestler-interrupt-rule.ws.txt'), release + '\n');
    const build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, after.elements);
    assert.deepEqual(rules(build.result), newRules);
    fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    const report = {beforeElements: before.elements, afterElements: after.elements, deltaElements: after.elements - before.elements, changedRules: changed, unchangedRules: newRules.length - changed.length, warnings: after.warnings, newVariables: 0, nativeIncludesMatch: true, runtimeValidation: 'Not run; verify carrier death and stun/sleep/freeze/knockdown while holding, including simultaneous throw input. Manual throws and other release causes retain their previous behavior.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-wrestler-interrupt-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
