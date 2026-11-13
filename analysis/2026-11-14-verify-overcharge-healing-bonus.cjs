const fs = require('node:fs');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compiler, compile} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {value, scenario} = require('./verify-augments.cjs');
const {args} = require('./verify-global-temporaries.cjs');

(async () => {
    await compiler.readyPromise;
    const baselineFiles = {...files};
    for (const name of ['player_initialization.opy', 'supply_drops.opy', 'global_start_menu.opy']) {
        baselineFiles[name] = execFileSync('git', ['show', `HEAD:src/${name}`], {encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baselineFiles);
    const after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, newRules.length);
    const changed = newRules.filter((r, i) => r.body !== oldRules[i].body).map(r => r.name);
    const beacon = newRules.find(r => r.name === 'beaconofHealing (40-49)');
    const healingActions = beacon.body.split('\n').filter(line => line.startsWith('Set Healing Dealt('));
    assert.equal(healingActions.length, 2);
    let cases = 0;
    for (let id = 0; id <= 13; id++) {
        const s = scenario(0);
        s.player.enhancementId = id;
        const base = id === 4 ? 130 : id === 9 ? 115 : 100;
        for (let repeat = 0; repeat < 2; repeat++) {
            // Evaluate the emitted Workshop expressions for activation and expiry.
            assert.equal(value(args(healingActions[0].replace(/;$/, ''))[1], s), base + 50);
            assert.equal(value(args(healingActions[1].replace(/;$/, ''))[1], s), base);
            cases += 2;
        }
    }
    const initIndex = newRules.findIndex(r => r.body.includes('Set Healing Dealt(Event Player, 115)'));
    assert(initIndex >= 0, 'Overcharge initializes its permanent bonus');
    // Switch dispatch offsets grow by one action from Overcharge onward.
    const withoutDispatch = body => body.split('\n').filter(line => !line.startsWith('Skip(Value In Array(')).join('\n');
    assert.equal(withoutDispatch(newRules[initIndex].body.replace('Set Healing Dealt(Event Player, 115);\n', '')), withoutDispatch(oldRules[initIndex].body));
    assert.equal(changed.length, 3, 'Only initialization, Beacon and menu change');
    assert.equal(after.result.match(/variables\s*\{[\s\S]*?\}/)[0], before.result.match(/variables\s*\{[\s\S]*?\}/)[0]);
    if (process.argv.includes('--export')) {
        const result = await compiler.compile(fs.readFileSync('main.opy', 'utf8'), 'en-US', process.cwd().replace(/\\/g, '/') + '/', 'main.opy');
        assert.equal(result.nbElements, after.elements);
        assert.deepEqual(result.encounteredWarnings, []);
        fs.writeFileSync('main.ws.txt', result.result);
    }
    const report = {cases, before: before.elements, after: after.elements,
        delta: after.elements - before.elements, changed, warnings: after.warnings};
    fs.writeFileSync('analysis/2026-11-14-overcharge-healing-bonus-validation.json', JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
