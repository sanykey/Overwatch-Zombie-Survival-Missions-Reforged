// Validate the measured player-position reductions and refresh Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {variants} = require('./probe-after-25738-2026-11-03.cjs');

const baselineRef = 'a4bc82b';
const selected = ['supply_pickup_any', 'daytaker_shared_abort',
    'distance_two_player_positions', 'distance_known_player_first',
    'direction_two_player_positions'];

function keyedRules(list) {
    const seen = new Map();
    return new Map(list.map(rule => {
        const count = seen.get(rule.name) || 0;
        seen.set(rule.name, count + 1);
        return [`${rule.name}#${count}`, rule.body];
    }));
}

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const expected = {...baseline};
    for (const name of selected) variants[name](expected);
    assert.deepEqual(files, expected, 'Sources differ from the measured variant');

    const before = await compile(baseline);
    const after = await compile(files);
    assert.equal(before.elements, 25738);
    assert.equal(after.elements, 25504);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 267);
    assert.equal(newRules.length, 268);
    const oldByKey = keyedRules(oldRules), newByKey = keyedRules(newRules);
    const removedRules = [...oldByKey.keys()].filter(key => !newByKey.has(key));
    const addedRules = [...newByKey.keys()].filter(key => !oldByKey.has(key));
    const changedRules = [...oldByKey].filter(([key, body]) =>
        newByKey.get(key) !== body).map(([key]) => key);
    assert.deepEqual(removedRules, []);
    assert.deepEqual(addedRules, ['daytakerAbortReset#0']);
    assert.equal(changedRules.length, 69);
    assert(changedRules.includes('DAYTAKER (ILLARI) BURST#0'));
    assert(changedRules.includes('EFFECT/TEXT (GLOBAL)#0'));
    assert.equal((before.result.match(/Position Of\(/g) || []).length -
        (after.result.match(/Position Of\(/g) || []).length, 231,
        'Expected 231 explicit position wrappers to be removed');

    const savedLog = console.log;
    let included;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), newRules);
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during verification: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({baselineRef, before: before.elements, after: after.elements,
        saved: before.elements - after.elements, oldRules: oldRules.length,
        newRules: newRules.length, changedRules: changedRules.length,
        newHelper: addedRules[0], removedPositionWrappers: 231,
        warnings: after.warnings.length, directIncludeBuild: true,
        inGameValidated: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
