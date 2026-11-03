// Compare the implemented reductions with their measured source transforms and rebuild Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {variants} = require('./probe-sixth-elements-2026-11-03.cjs');

const baselineRef = '05e3ba5';
const selected = [
    'shared_move_speed', 'shared_objective_position_refresh',
    'shared_objective_type_refresh', 'shared_throttle_facing',
    'shared_allowed_heroes', 'shared_knockback_scale',
    'shared_size_scale', 'shared_boss_health',
];
const helperNames = [
    'applyScaledMoveSpeed', 'refreshCurrentObjectivePosition',
    'refreshCurrentObjectiveType', 'faceCurrentThrottle',
    'excludeCurrentHeroFromSelection', 'applyBotKnockbackScale',
    'applyCurrentSizeScale', 'applyBotBossHealth',
];

function expandOneActionHelpersForAudit(workshop, compiledRules) {
    let expanded = workshop;
    for (const name of helperNames) {
        const helper = compiledRules.find(rule => rule.name === name);
        assert(helper, `Missing helper: ${name}`);
        assert(helper.body.startsWith(`event {\nSubroutine;\n${name};\n}`),
            `${name}: expected subroutine event`);
        const match = helper.body.match(/actions \{\n([^\n]+)\n\}/);
        assert(match, `${name}: expected exactly one action`);
        assert(!/\btmp\d+\b|\bWait\(|Call Subroutine/.test(match[1]),
            `${name}: helper must not yield or touch scratch`);
        const call = `Call Subroutine(${name});`;
        assert(expanded.includes(call), `${name}: expected at least one call`);
        expanded = expanded.replaceAll(call, match[1]);
    }
    return expanded;
}

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const measured = {...baseline};
    for (const name of selected) variants[name](measured);
    for (const [file, contents] of Object.entries(measured))
        assert.equal(files[file], contents, `Source differs from measured variant: ${file}`);

    // compile() temporarily suppresses compiler logging, so run sequentially.
    const before = await compile(baseline);
    const expected = await compile(measured);
    const after = await compile(files);
    assert.equal(before.elements, 25925);
    assert.equal(expected.elements, 25848);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 247);
    assert.equal(newRules.length, 255);
    assert.deepEqual(newRules, rules(expected.result),
        'Implemented Workshop actions differ from measured variants');

    // Only the unchanged teleport pivot pair uses its separately audited tmp1 handoff.
    const auditOutput = expandOneActionHelpersForAudit(after.result, newRules).replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(auditOutput);
    let included;
    const savedLog = console.log;
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
    const report = {date: '2026-11-03', baselineRef, before: before.elements,
        after: after.elements, saved: before.elements - after.elements,
        oldRules: oldRules.length, newRules: newRules.length,
        oneActionHelpersChecked: helperNames.length,
        scratchRulesCheckedExcludingExistingBotHelper: scratch.length,
        directIncludeBuild: true, emittedWarnings: 0, inGameValidated: false};
    fs.writeFileSync(path.join(__dirname, 'sixth-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
