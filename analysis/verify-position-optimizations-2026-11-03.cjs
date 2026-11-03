// Validate the measured player-position reductions and refresh Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {variants} = require('./probe-after-25738-2026-11-03.cjs');
const {variants: nextVariants} = require('./probe-next-positions-2026-11-03.cjs');
const {emptyListChecks, remainingPlayerPositions} = require('./probe-next-current-2026-11-03.cjs');
const {zeroThrottleMagnitude, radiusBuiltin, departedPlayerCleanup} =
    require('./probe-post-25382-2026-11-03.cjs');
const {numericStateChecks, throttleTruth, blinkPhaseChecks, otherNumericChecks} =
    require('./probe-post-25350-2026-11-03.cjs');
const {cooldownZeroChecks, heroCountZeroChecks, nonemptyObjectiveList, otherUnsignedChecks} =
    require('./probe-post-25283-2026-11-03.cjs');

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
    const latestExpected = {...expected};
    const nextCounts = Object.fromEntries(Object.entries(nextVariants).map(([name, transform]) =>
        [name, transform(latestExpected).length]));
    const currentExpected = {...latestExpected};
    const currentCounts = {emptyListChecks: emptyListChecks(currentExpected).length,
        remainingPlayerPositions: remainingPlayerPositions(currentExpected).length};
    const finalExpected = {...currentExpected};
    const finalCounts = {zeroThrottleMagnitude: zeroThrottleMagnitude(finalExpected).length,
        radiusBuiltin: radiusBuiltin(finalExpected).length,
        departedPlayerCleanup: departedPlayerCleanup(finalExpected).length};
    const optimizedExpected = {...finalExpected};
    const optimizedCounts = {numericStateChecks: numericStateChecks(optimizedExpected),
        throttleTruth: throttleTruth(optimizedExpected),
        blinkPhaseChecks: blinkPhaseChecks(optimizedExpected),
        otherNumericChecks: otherNumericChecks(optimizedExpected)};
    const postExpected = {...optimizedExpected};
    const postCounts = {cooldownZeroChecks: cooldownZeroChecks(postExpected).length,
        heroCountZeroChecks: heroCountZeroChecks(postExpected).length,
        nonemptyObjectiveList: nonemptyObjectiveList(postExpected).length,
        otherUnsignedChecks: otherUnsignedChecks(postExpected).length};
    assert.deepEqual(files, postExpected, 'Sources differ from the measured variants');

    const before = await compile(baseline);
    const after = await compile(expected);
    const latest = await compile(latestExpected);
    const current = await compile(currentExpected);
    const final = await compile(finalExpected);
    const optimized = await compile(optimizedExpected);
    const post = await compile(files);
    assert.equal(before.elements, 25738);
    assert.equal(after.elements, 25504);
    assert.equal(latest.elements, 25441);
    assert.equal(current.elements, 25382);
    assert.equal(final.elements, 25350);
    assert.equal(optimized.elements, 25283);
    assert.equal(post.elements, 25251);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(latest.warnings, []);
    assert.deepEqual(current.warnings, []);
    assert.deepEqual(final.warnings, []);
    assert.deepEqual(optimized.warnings, []);
    assert.deepEqual(post.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const latestRules = rules(latest.result);
    const currentRules = rules(current.result);
    const finalRules = rules(final.result);
    const optimizedRules = rules(optimized.result);
    const postRules = rules(post.result);
    assert.equal(oldRules.length, 267);
    assert.equal(newRules.length, 268);
    assert.equal(latestRules.length, 268);
    assert.equal(currentRules.length, 268);
    assert.equal(finalRules.length, 268);
    assert.equal(optimizedRules.length, 268);
    assert.equal(postRules.length, 268);
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
    const previousByKey = keyedRules(newRules), latestByKey = keyedRules(latestRules);
    assert.deepEqual([...previousByKey.keys()], [...latestByKey.keys()]);
    const latestChangedRules = [...previousByKey].filter(([key, body]) =>
        latestByKey.get(key) !== body).map(([key]) => key);
    assert.equal(latestChangedRules.length, 40);
    assert.equal((after.result.match(/Position Of\(/g) || []).length -
        (latest.result.match(/Position Of\(/g) || []).length, 63,
        'Expected 63 further position wrappers to be removed');
    const currentByKey = keyedRules(currentRules);
    assert.deepEqual([...latestByKey.keys()], [...currentByKey.keys()]);
    const currentChangedRules = [...latestByKey].filter(([key, body]) =>
        currentByKey.get(key) !== body).map(([key]) => key);
    assert.equal(currentChangedRules.length, 32);
    assert.equal((latest.result.match(/Position Of\(/g) || []).length -
        (current.result.match(/Position Of\(/g) || []).length, 11,
        'Expected 11 remaining position wrappers to be removed');
    assert.equal((latest.result.match(/Count Of\(/g) || []).length -
        (current.result.match(/Count Of\(/g) || []).length, 48,
        'Expected 48 list counts to be removed');
    const finalByKey = keyedRules(finalRules);
    assert.deepEqual([...currentByKey.keys()], [...finalByKey.keys()]);
    const finalChangedRules = [...currentByKey].filter(([key, body]) =>
        finalByKey.get(key) !== body).map(([key]) => key);
    assert.equal(finalChangedRules.length, 12);
    assert.equal((final.result.match(/Magnitude Of\(/g) || []).length -
        (current.result.match(/Magnitude Of\(/g) || []).length, 9,
        'Expected nine throttle magnitudes');
    assert.equal((final.result.match(/Players Within Radius\(/g) || []).length -
        (current.result.match(/Players Within Radius\(/g) || []).length, 4,
        'Expected four radius lookups');
    const optimizedByKey = keyedRules(optimizedRules);
    assert.deepEqual([...finalByKey.keys()], [...optimizedByKey.keys()]);
    const optimizedChangedRules = [...finalByKey].filter(([key, body]) =>
        optimizedByKey.get(key) !== body).map(([key]) => key);
    assert.equal(optimizedChangedRules.length, 24);
    const postByKey = keyedRules(postRules);
    assert.deepEqual([...optimizedByKey.keys()], [...postByKey.keys()]);
    const postChangedRules = [...optimizedByKey].filter(([key, body]) =>
        postByKey.get(key) !== body).map(([key]) => key);
    assert.equal(postChangedRules.length, 16);

    const savedLog = console.log;
    let included;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, post.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), postRules);
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during verification: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({baselineRef, before: before.elements, previous: after.elements,
        middle: latest.elements, prior: current.elements, penultimate: final.elements,
        last: optimized.elements, after: post.elements, saved: optimized.elements - post.elements,
        previousCounts: nextCounts, middleCounts: currentCounts,
        priorCounts: finalCounts, lastCounts: optimizedCounts, counts: postCounts,
        oldRules: oldRules.length, newRules: postRules.length,
        previousChangedRules: changedRules.length, middleChangedRules: latestChangedRules.length,
        priorChangedRules: currentChangedRules.length,
        penultimateChangedRules: finalChangedRules.length,
        lastChangedRules: optimizedChangedRules.length,
        changedRules: postChangedRules.length,
        newHelper: addedRules[0], removedPositionWrappers: 231,
        furtherRemovedPositionWrappers: 63, latestRemovedPositionWrappers: 11,
        removedListCounts: 48,
        warnings: post.warnings.length, directIncludeBuild: true,
        inGameValidated: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
