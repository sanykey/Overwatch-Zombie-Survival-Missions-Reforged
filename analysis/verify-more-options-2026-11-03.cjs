// Validate the six measured changes and refresh the generated Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {variants} = require('./probe-more-options-2026-11-03.cjs');

const selected = ['menu_glitch_both', 'biomorphing_goal_existing_color',
    'bot_stat_constant_speed', 'bot_stat_inline_damage_roundtrip',
    'inline_miniboss_roll', 'bot_kill_bonus_inline_roll'];
const expectedChangedRules = ['botRespawnInitialization', 'SPECIAL EFFECT CONTROLS',
    'BIOMORPHING GOAL START', 'BOT DIES'];

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `HEAD:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const expected = {...baseline};
    for (const name of selected) variants[name](expected);
    assert.deepEqual(files, expected, 'Sources differ from the measured variant');

    const before = await compile(baseline);
    const after = await compile(files);
    assert.equal(before.elements, 25786);
    assert.equal(after.elements, 25738);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 267);
    assert.equal(newRules.length, oldRules.length);
    const changedRules = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(oldRules[i].name, newRules[i].name);
        if (oldRules[i].body !== newRules[i].body) changedRules.push(newRules[i].name);
    }
    assert.deepEqual(changedRules, expectedChangedRules);

    // The existing color table must match the three ordinary goal colors.
    assert.equal(files['subroutines.opy'].split(
        'biomorphingResourceColorList = [Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE, Color.RED]').length - 1, 1);
    assert.equal(Object.values(files).join('\n').split('biomorphingResourceColorList =').length - 1, 1);
    for (const name of ['SPECIAL EFFECT CONTROLS', 'BOT DIES', 'botRespawnInitialization']) {
        const beforeBody = oldRules.find(rule => rule.name === name).body;
        const afterBody = newRules.find(rule => rule.name === name).body;
        assert.equal((beforeBody.match(/Random Integer\(/g) || []).length,
            (afterBody.match(/Random Integer\(/g) || []).length,
            `${name}: random draw count changed`);
    }

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
    console.log(JSON.stringify({before: before.elements, after: after.elements,
        saved: before.elements - after.elements, rulesCompared: oldRules.length,
        changedRules, warnings: after.warnings.length, directIncludeBuild: true}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
