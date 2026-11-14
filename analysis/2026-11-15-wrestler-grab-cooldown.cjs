const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const baselinePath = path.join(__dirname, '2026-11-15-wrestler-grab-before.json');
const rules = result => [...result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => ({name, body: body.split('\n').filter(line => !/^\s*(?:"|\/\/)/.test(line)).map(line => line.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n')}));
(async () => {
    await compiler.readyPromise;
    const compiled = await compiler.compile(fs.readFileSync(path.join(root, 'src/includes.opy'), 'utf8').replace(/^#!writeToOutputFile.*$/gm, ''), 'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(compiled.encounteredWarnings, []);
    const snapshot = {elements: compiled.nbElements, rules: rules(compiled.result)};
    if (process.argv.includes('--before')) {
        fs.writeFileSync(baselinePath, JSON.stringify(snapshot));
        console.log(JSON.stringify({beforeElements: snapshot.elements}));
        return;
    }
    const before = JSON.parse(fs.readFileSync(baselinePath, 'utf8'));
    const changed = snapshot.rules.filter((rule, i) => rule.body !== before.rules[i]?.body || rule.name !== before.rules[i]?.name).map(rule => rule.name);
    assert.equal(snapshot.rules.length, before.rules.length);
    assert.deepEqual(changed, ['useLivingProjectile', 'LIVING PROJECTILE RELEASE']);
    const pickup = snapshot.rules.find(rule => rule.name === 'useLivingProjectile').body;
    const release = snapshot.rules.find(rule => rule.name === 'LIVING PROJECTILE RELEASE').body;
    assert(pickup.indexOf('Total Time Elapsed') < pickup.indexOf('Ray Cast Hit Player'));
    assert(/Set Player Variable\(Global\.tmp0, actorTeamSlot25, Add\(Total Time Elapsed, 1\.5(?:00)?\)\);/.test(release), release);
    const report = {compiler: 'OverPy 9.7.21', beforeElements: before.elements, afterElements: snapshot.elements, deltaElements: snapshot.elements - before.elements, changedRules: changed, warnings: compiled.encounteredWarnings, newWorkshopVariables: 0, limitations: 'Compiled output checked; in-game validation required.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-wrestler-grab-result.json'), JSON.stringify(report, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), compiled.result);
    console.log(JSON.stringify(report, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
