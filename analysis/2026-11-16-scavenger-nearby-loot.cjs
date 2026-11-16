const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const artifact = suffix => path.join(__dirname, '2026-11-16-scavenger-nearby-' + suffix);
(async () => {
    await compiler.readyPromise;
    const result = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    if (process.argv[2] === 'before') {
        fs.writeFileSync(artifact('before.ws.txt'), result.result);
        fs.writeFileSync(artifact('before.json'), JSON.stringify({elements: result.nbElements}) + '\n');
        console.log(JSON.stringify({elements: result.nbElements}));
        return;
    }
    fs.writeFileSync(artifact('after.ws.txt'), result.result);
    const rules = code => new Map([...code.matchAll(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm)].map(m => [m[1], m[0].replace(/^\s*\/\/.*\n/gm, '')]));
    const baselineCode = fs.readFileSync(artifact('before.ws.txt'), 'utf8');
    const before = rules(baselineCode);
    const after = rules(result.result);
    const changed = [];
    for (const [name, body] of before) {
        if (body !== after.get(name)) changed.push(name);
    }
    assert.deepEqual(changed.sort(), ['AUGMENT MENU', 'BOT DIES', 'PLAYER EARNED ELIMINATION', 'collectEngineerScrap'].sort());
    assert.equal(after.size, before.size);
    assert(!after.get('PLAYER EARNED ELIMINATION').includes('Scavenger:'));
    const shared = after.get('collectNearbyZombieLoot');
    assert(shared.includes('Is Alive') || shared.includes('All Living Players'));
    assert(shared.includes('Distance Between'));
    assert(shared.includes('Compare(Distance Between(Current Array Element, Victim), <, 15)'));
    assert(shared.includes('Random Integer(True, 100), <=, 7'));
    assert(!/\bWait\(/.test(shared));
    const variables = code => code.match(/^variables \{[\s\S]*?^\}/m)[0];
    assert.equal(variables(result.result), variables(baselineCode));
    const baseline = JSON.parse(fs.readFileSync(artifact('before.json'), 'utf8'));
    const report = {beforeElements: baseline.elements, afterElements: result.nbElements,
        elementDelta: result.nbElements - baseline.elements, ruleCount: after.size,
        changedRules: changed, replacementRule: 'collectNearbyZombieLoot', warnings: result.encounteredWarnings,
        verification: 'Full source compilation; all other rule bodies identical except generated label comments; identical variable declarations; living Team 1 collectors at distance <15; 7% roll; one synchronous collection rule with no waits. Shared rule manually inspected: independent Engineer and Scavenger branches, active/backpack/ground routing preserved.',
        limitation: 'No in-game validation or CPU timing measurement.'};
    fs.writeFileSync(artifact('after.ws.txt'), result.result);
    fs.writeFileSync(artifact('validation.json'), JSON.stringify(report, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
