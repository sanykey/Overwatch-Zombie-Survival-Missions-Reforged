// Compare the current build with the same sources before the HUD visibility fix.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

async function main() {
    await compiler.readyPromise;
    const baseline = execFileSync('git', ['rev-parse', 'HEAD'], {cwd: root, encoding: 'utf8'}).trim();
    const oldFiles = {...files, 'player_initialization.opy': execFileSync('git',
        ['show', `${baseline}:src/player_initialization.opy`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    const before = await compile(oldFiles), after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(newRules.length, oldRules.length);
    const changedRules = newRules.filter((r, i) => r.body !== oldRules[i].body).map(r => r.name);
    assert.deepEqual(changedRules, ['ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)']);
    const oldHud = oldRules.find(r => r.name === changedRules[0]).body;
    const newHud = newRules.find(r => r.name === changedRules[0]).body;
    // Only the first two HUD calls change. Strings, colors, order, conditions,
    // other persistent HUDs and the variable layout must remain identical.
    let restoredHud = newHud;
    for (const id of ['enhancementId', 'augmentId']) {
        // The compiler emits numeric zero as Null. This is an explicit !=
        // comparison, not the broader Workshop truthiness comparison to False.
        const visibleTo = `If-Then-Else(Compare((Local Player).${id}, !=, Null), Local Player, Null)`;
        assert.equal(newHud.split(visibleTo).length - 1, 1);
        restoredHud = restoredHud.replace(visibleTo, 'All Players(Team 1)');
    }
    assert.equal(restoredHud, oldHud);
    assert.equal(before.result.match(/variables \{[\s\S]*?\n\}/)[0],
        after.result.match(/variables \{[\s\S]*?\n\}/)[0]);
    const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
        'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), newRules);
    fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    const report = {baseline, beforeElements: before.elements, afterElements: after.elements,
        elementDelta: after.elements - before.elements, changedRules, warnings: after.warnings,
        limitation: 'Compiled output verified; POTG and spectator behavior require an in-game check.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-postmatch-huds-validation.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
