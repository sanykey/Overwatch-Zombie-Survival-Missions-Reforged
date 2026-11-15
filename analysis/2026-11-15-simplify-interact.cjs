const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const mode = process.argv[2];
function summarize(r) {
    const code = r.body.split('\n').filter(l => !/^\s*(?:"|\/\/)/.test(l)).map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
    return {name: r.name, hash: crypto.createHash('sha256').update(code).digest('hex')};
}
(async () => {
    await compiler.readyPromise;
    const compiled = await compiler.compile(fs.readFileSync(path.join(root, 'src/includes.opy'), 'utf8').replace(/^#!writeToOutputFile.*$/gm, ''), 'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
    const rules = [...compiled.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => ({name, body}));
    const report = {elements: compiled.nbElements, warnings: compiled.encounteredWarnings, rules: rules.map(summarize)};
    const target = path.join(__dirname, '2026-11-15-interact-' + mode + '.json');
    fs.writeFileSync(target, JSON.stringify(report, null, 2) + '\n');
    if (mode === 'after') {
        const before = JSON.parse(fs.readFileSync(path.join(__dirname, '2026-11-15-interact-before.json'), 'utf8'));
        // Compare by position: multiple unrelated rules share the same name.
        const baseline = before.rules.map(r => r.body === undefined ? r : summarize(r));
        assert.deepEqual(report.rules.map(r => r.name), baseline.map(r => r.name));
        const changed = report.rules.filter((r, i) => baseline[i].hash !== r.hash).map(r => r.name);
        assert.deepEqual(compiled.encounteredWarnings, []);
        assert.deepEqual(changed, ['PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)']);
        const interact = rules.find(r => r.name.startsWith('PLAYER INTERACT')).body;
        assert(interact.includes('Wait Until(Or(Is Button Held(Event Player, Button(Crouch)), Not('));
        assert(interact.includes('If(And('));
        assert(interact.includes('Abort If Condition Is False;'));
        assert(interact.includes('Not(Is Button Held(Event Player, Button(Crouch)))'));
        assert(!interact.includes('augmentBarrierPlacementCooldown'));
        assert(!interact.includes('enhancementCarryState'));
        assert(!interact.includes('Wait(0.5'));
        // Keep the stored baseline compact, including on the first run after capture.
        fs.writeFileSync(path.join(__dirname, '2026-11-15-interact-before.json'), JSON.stringify({...before, rules: baseline}, null, 2) + '\n');
        const summary = {beforeElements: before.elements, afterElements: report.elements, delta: report.elements - before.elements, warnings: report.warnings, changed};
        fs.writeFileSync(path.join(root, 'main.ws.txt'), compiled.result);
        console.log(JSON.stringify(summary, null, 2));
    } else console.log(JSON.stringify({elements: report.elements, warnings: report.warnings}));
})().catch(e => {console.error(e); process.exitCode = 1;});
