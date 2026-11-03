// Verify the two selected reductions and refresh the generated Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {candidates} = require('./probe-current-opportunities-2026-11-03.cjs');

async function main() {
    await compiler.readyPromise;
    const baseline = {...files,
        'zombie_types.opy': execFileSync('git', ['show', 'HEAD:src/zombie_types.opy'],
            {encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    const expected = {...baseline};
    candidates.blaster_rocket_shared_duration(expected);
    candidates.downfallen_eye_offset(expected);
    assert.deepEqual(files, expected, 'Current sources differ from the two measured variants');

    const before = await compile(baseline);
    const after = await compile(files);
    assert.equal(before.elements, 25798);
    assert.equal(after.elements, 25786);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, newRules.length);
    const changedRules = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(oldRules[i].name, newRules[i].name);
        if (oldRules[i].body !== newRules[i].body) changedRules.push(newRules[i].name);
    }
    assert.deepEqual(changedRules, ['BLASTER ROCKET HITS TARGET', 'DOWNFALLEN GRABS PLAYER']);
    const blasterRule = newRules.find(rule => rule.name === 'BLASTER ROCKET HITS TARGET').body;
    assert(blasterRule.includes('Set Global Variable(tmp0'), 'Duration snapshot must be assigned');
    assert(!blasterRule.includes('Wait('), 'Duration snapshot must not cross a wait');

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
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({before: before.elements, after: after.elements,
        saved: before.elements - after.elements, rulesCompared: oldRules.length,
        changedRules, warnings: after.warnings.length, directIncludeBuild: true}));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
