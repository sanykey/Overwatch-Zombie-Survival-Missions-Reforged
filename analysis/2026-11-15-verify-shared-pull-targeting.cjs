// Compare both compiled pull rules against the pre-extraction implementation.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {start, scenario, value} = require('./verify-augments.cjs');
const baselineRef = '4bae601';
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

function snapshot(compiled, rule, config) {
    const state = scenario(6, {buttons: new Set(['Crouch', 'Jump', 'Melee']), ...structuredClone(config)});
    state.player.team = 1;
    state.player.enhancementId = Number(files['variables.opy'].match(/WRESTLER = (\d+),/)[1]);
    const task = start(compiled.get(rule), state, compiled);
    if (rule === 'WRESTLER PULL') {state.time = task.deadline(); task.resume();}
    const result = {
        selected: rule === 'GRAPNEL LAUNCHER' ? state.player[slot('augmentGrapnelTarget')]?.id ?? null
            : state.statusWrites[0]?.target ?? null,
        statuses: state.statusWrites, impulses: state.impulses, effects: state.effects,
        beams: state.beams.map(beam => ({type: beam.type, color: beam.color,
            reevaluation: beam.reevaluation, from: value(beam.from, state), to: value(beam.to, state)})),
        readyAt: state.player[slot(rule === 'GRAPNEL LAUNCHER' ? 'augmentMovementReadyAt' : 'enhancementPullReadyAt')] ?? 0
    };
    // Both callers must stop using helper scratch before their next wait.
    for (const name of ['tmp0', 'tmp1', 'tmp2', 'tmp3']) state.globals[name] = 999;
    for (let step = 0; !task.done() && step < 40; step++) {state.time = task.deadline(); task.resume();}
    assert(task.done());
    assert.equal(state.liveEffects.size, 0);
    return result;
}

async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const name of ['variables.opy', 'subroutines.opy', 'augments.opy', 'enhancements.opy']) {
        baseline[name] = execFileSync('git', ['show', `${baselineRef}:src/${name}`],
            {encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baseline);
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert(after.elements < before.elements);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const changed = new Set(['GRAPNEL LAUNCHER', 'WRESTLER PULL']);
    assert.deepEqual(newRules.filter(rule => !changed.has(rule.name) && rule.name !== 'selectPullAimTarget'),
        oldRules.filter(rule => !changed.has(rule.name)));
    assert.equal(newRules.length, oldRules.length + 1);
    const declarations = source => source.match(/^(?:global|player)var .*$/gm);
    assert.deepEqual(declarations(files['variables.opy']), declarations(baseline['variables.opy']));
    const oldCompiled = new Map(oldRules.map(rule => [rule.name, rule]));
    const newCompiled = new Map(newRules.map(rule => [rule.name, rule]));
    const target = (id, position, extra = {}) => ({id, position, alive: true, visible: true,
        dummy: true, team: 2, ground: true, sizeScale: 1, ...extra});
    const cases = [{targets: []}, {targets: [target('center', [0, 0, 12]), target('closer', [3, 0, 8])]},
        {targets: [target('first tie', [0, 0, 12]), target('second tie', [0, 0, 12])]},
        {targets: [target('large', [0, 0, 20], {sizeScale: 3, eyePosition: [0, 8, 20]})]},
        {targets: [target('no LOS', [0, 0, 12])], lineOfSight: false}];
    for (const distance of [0, 6.99, 7, 24.99, 25, 25.01, 44.99, 45, 45.01, 48])
    for (const flags of [{}, {team: 1}, {alive: false}, {visible: false}, {dummy: false},
        {[slot('botIsInitializing')]: true}, {[slot('botIsAttached')]: true},
        {[slot('botIsTeleporting')]: true}, {team: 1, [slot('botIsTeleporting')]: 2},
        {team: 1, [slot('botIsTeleporting')]: [[0, 0, 10]]}]) {
        cases.push({targets: [target('candidate', [0, 0, distance], flags)]});
    }
    for (const x of [-20, -5, 0, 5, 20]) cases.push({targets: [target('angle', [x, 0, 12])]});
    let comparisons = 0;
    for (const rule of changed) for (const config of cases) {
        assert.deepEqual(snapshot(newCompiled, rule, config), snapshot(oldCompiled, rule, config),
            `${rule}: ${JSON.stringify(config)}`);
        comparisons++;
    }
    const report = {baselineRef, beforeElements: before.elements, afterElements: after.elements,
        elementDelta: after.elements - before.elements, unchangedUnrelatedRules: true, behavioralComparisons: comparisons,
        variableDeclarationsIdentical: true, warnings: after.warnings};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-shared-pull-targeting-validation.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
