// Verify that the exported Workshop filter also encloses the Hybrid branch after recompilation.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const baselineRef = '0c4d9dc';
const file = 'subroutines.opy';
const oldLine = '    eventPlayer.explosionTargetList = getPlayers(Team.2) if not eventPlayer.isDummy() else getAllPlayers().filter(lambda x: distance(eventPlayer, x) < eventPlayer.explosionScale * 6 and isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))';
const newLine = '    # Filter the chosen team for both explosion types; dummy bot explosions also require line of sight.\n' +
    '    eventPlayer.explosionTargetList = (getPlayers(Team.2) if not eventPlayer.isDummy() else getAllPlayers()).filter(lambda x: distance(eventPlayer, x) < eventPlayer.explosionScale * 6 and (isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) if eventPlayer.isDummy() else true))';

async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    baseline[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.resolve(src, '..')}).toString('utf8').replace(/\r\n/g, '\n');
    assert.equal(baseline[file].split(oldLine).length - 1, 1);
    assert.equal(files[file], baseline[file].replace(oldLine, newLine),
        'Only the Hybrid target selection should change');
    const original = path.resolve(src, '..', 'ZSM examples', 'ZSMM (786TW)');
    const originalWorkshop = fs.readFileSync(path.join(original,
        '2026-10-30 ZSMM (786TW).ow'), 'utf8');
    const originalDecompiled = fs.readFileSync(path.join(original,
        '2026-10-30 ZSMM (786TW).opy'), 'utf8');
    assert.match(originalWorkshop,
        /Filtered Array\(!Is Dummy Bot\(Event Player\) \? All Players\(Team 2\) : All Players\(\s*All Teams\), Distance Between/);
    assert.match(originalDecompiled,
        /getPlayers\(Team\.2\) if not eventPlayer\.isDummy\(\) else getAllPlayers\(\)\.filter/);
    const savedConsole = {log: console.log, warn: console.warn, error: console.error};
    let decompiledBuild;
    try {
        console.log = console.warn = console.error = () => {};
        decompiledBuild = await compiler.compile(originalDecompiled, 'en-US',
            original.replace(/\\/g, '/') + '/', '2026-10-30 ZSMM (786TW).opy');
    } finally {Object.assign(console, savedConsole);}
    assert.equal(decompiledBuild.nbElements, 32264);
    const decompiledExplosion = rules(decompiledBuild.result)
        .find(rule => rule.name === 'explosionSequence').body;
    assert.match(decompiledExplosion,
        /If-Then-Else\(Is Dummy Bot\(Event Player\), Filtered Array\(All Players\(All Teams\)/);
    assert.match(decompiledExplosion, /All Players\(Team 2\)\)\);/);

    const before = await compile(baseline);
    const after = await compile(files);
    assert.equal(before.elements, 25224);
    assert.equal(after.elements, 25228);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, 268);
    assert.deepEqual(newRules.map(rule => rule.name), oldRules.map(rule => rule.name));
    const changed = newRules.filter((rule, i) => rule.body !== oldRules[i].body)
        .map(rule => rule.name);
    assert.deepEqual(changed, ['explosionSequence']);
    const explosion = newRules.find(rule => rule.name === 'explosionSequence').body;
    assert.match(explosion,
        /Filtered Array\(If-Then-Else\(Is Dummy Bot\(Event Player\), All Players\(All Teams\), All Players\(Team 2\)\), And\(Compare\(Distance Between\(Event Player, Current Array Element\), <, Multiply\(\(Event Player\)\.explosionScale, 6\)\)/);

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
    for (const [name, contents] of Object.entries(files)) {
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'),
            contents, `Source changed during verification: ${name}`);
    }
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({baselineRef, decompiledOriginal: decompiledBuild.nbElements,
        before: before.elements,
        after: after.elements, rules: newRules.length, changedRules: changed,
        warnings: after.warnings.length, directIncludeBuild: true,
        inGameValidated: false}));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
