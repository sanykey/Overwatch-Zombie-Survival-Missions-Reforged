// Run compiled input handlers across Augment changes during each Dash wait.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {execute, start, scenario} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');

async function main() {
    await compiler.readyPromise;
    const baseline = execFileSync('git', ['rev-parse', 'HEAD'], {cwd: root, encoding: 'utf8'}).trim();
    const oldFiles = {...files, 'augments.opy': execFileSync('git', ['show', `${baseline}:src/augments.opy`],
        {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    const before = await compile(oldFiles), after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const oldMap = new Map(oldRules.map(r => [r.name, r]));
    const newMap = new Map(newRules.map(r => [r.name, r]));
    const dash = 'DASH DOUBLE TAP', helper = 'useAugmentAirAction';
    assert.equal(newRules.length, oldRules.length);
    const changed = newRules.filter((r, i) => r.body !== oldRules[i].body).map(r => r.name);
    assert.deepEqual(changed.sort(), [dash, helper].sort());
    assert.equal(before.result.match(/variables \{[\s\S]*?\n\}/)[0],
        after.result.match(/variables \{[\s\S]*?\n\}/)[0]);

    // A Dash waiter created during selection remains suspended after choosing
    // Long Reach. Resume its press-release-press sequence after the change.
    function switchedInput(map, augment, phase) {
        const s = scenario(2);
        s.player.augmentState2 = 2;
        const task = start(map.get(dash), s, map);
        if (phase >= 1) {s.buttons.add('Jump'); task.resume();}
        if (phase >= 2) {s.buttons.delete('Jump'); task.resume();}
        s.player.augmentId = augment;
        Object.assign(s.player, {augmentState0: 0, augmentState1: 77, augmentState2: 88, augmentState3: 99});
        const snapshot = {...s.player};
        if (phase === 0) {s.buttons.add('Jump'); task.resume();}
        if (phase <= 1) {s.buttons.delete('Jump'); task.resume();}
        s.buttons.add('Jump'); task.resume();
        s.buttons.delete('Jump'); task.resume();
        return {s, task, snapshot};
    }
    const reproduced = switchedInput(oldMap, 4, 0);
    assert.equal(reproduced.s.impulses.length, 1, 'Baseline reproduces Long Reach extra jump');
    assert.equal(reproduced.s.player.augmentState0, 116, 'Baseline overwrites Long Reach push cooldown');

    let cases = 0;
    for (const augment of [0, 1, 4, 5, 6, 7, 8, 9, 10]) {
        for (const phase of [0, 1, 2]) {
            const {s, task, snapshot} = switchedInput(newMap, augment, phase);
            assert.equal(s.impulses.length, 0, `No jump for Augment ${augment}, wait ${phase}`);
            assert.deepEqual(s.player, snapshot, 'Other Augment slots remain owned by that Augment');
            assert(task.done(), 'Dash input stops after selection changes');
            cases++;
        }
    }
    // Dash's emitted actions are unchanged; its effect creation is outside this
    // evaluator. Execute Double Jump, including its cooldown, directly.
    assert.equal(newMap.get(helper).body.split('Else If(')[0], oldMap.get(helper).body.split('Else;')[0]);
    for (const augment of [3]) {
        const s = scenario(augment);
        Object.assign(s.player, {augmentState0: 0, augmentState1: 0, augmentState2: 2});
        assert(execute(newMap.get(helper), s, newMap).next().done);
        assert.equal(s.impulses.length, 1);
        if (augment === 3) {
            assert.equal(s.player.augmentState0, 116);
            assert(execute(newMap.get(helper), s, newMap).next().done);
            assert.equal(s.impulses.length, 1, 'Double Jump cooldown still prevents another jump');
        }
        cases++;
    }
    const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
        'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), newRules);
    fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    const report = {baseline, beforeElements: before.elements, afterElements: after.elements,
        elementDelta: after.elements - before.elements, changedRules: changed, cases,
        baselineBugReproduced: true, warnings: after.warnings,
        limitation: 'Compiled-action simulation; no in-game run.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-13-augment-jump-isolation-validation.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
