const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file = suffix => path.join(__dirname, '2026-11-16-nearby-loot-macro-' + suffix);
const normalize = text => text.replace(/^\s*(?:\/\/.*|".*")\n/gm, '').replace(/;\s*\/\/[^\n]*/g, ';').split('\n').map(s => s.trim()).filter(Boolean).join('\n');
const rules = text => new Map([...text.matchAll(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm)].map(m => [m[1], m[0]]));
(async () => {
    await compiler.readyPromise;
    const result = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    if (process.argv[2] === 'before') {
        fs.writeFileSync(file('before.ws.txt'), result.result);
        fs.writeFileSync(file('before.json'), JSON.stringify({elements: result.nbElements}) + '\n');
        console.log(result.nbElements);
        return;
    }
    const oldCode = fs.readFileSync(file('before.ws.txt'), 'utf8');
    const before = rules(oldCode), after = rules(result.result);
    assert.equal(after.size, before.size - 1);
    assert(!after.has('collectNearbyZombieLoot'));
    for (const [name, body] of before) {
        if (!['BOT DIES', 'collectNearbyZombieLoot'].includes(name)) assert.equal(normalize(after.get(name)), normalize(body), name);
    }
    const actions = body => body.match(/    actions \{\n([\s\S]*)\n    \}\n\}/)[1];
    const inlined = before.get('BOT DIES').replace('Call Subroutine(collectNearbyZombieLoot);', actions(before.get('collectNearbyZombieLoot')));
    assert.equal(normalize(after.get('BOT DIES')), normalize(inlined));
    assert.equal(result.result.match(/^variables \{[\s\S]*?^\}/m)[0], oldCode.match(/^variables \{[\s\S]*?^\}/m)[0]);
    const baseline = JSON.parse(fs.readFileSync(file('before.json'), 'utf8'));
    const report = {beforeElements: baseline.elements, afterElements: result.nbElements, elementDelta: result.nbElements - baseline.elements,
        rulesBefore: before.size, rulesAfter: after.size, warnings: result.encounteredWarnings,
        verification: 'BOT DIES actions equal the original with the subroutine call expanded in place. All other rule instructions and variable declarations unchanged. Full compilation without warnings.',
        limitation: 'No in-game test or CPU timing measurement.'};
    fs.writeFileSync(file('validation.json'), JSON.stringify(report, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), result.result);
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
