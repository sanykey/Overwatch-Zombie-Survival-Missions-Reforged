// Read-only safety audit: compile in memory and use bounded counterexamples.
// Does not run the game or execute the unsafe Workshop loops.
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

function rule(result, name) {
    const start = result.indexOf(`rule ("${name}")`);
    assert(start >= 0, name);
    const end = result.indexOf('\n}\n', start);
    assert(end > start);
    return result.slice(start, end + 3);
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    const diagnostic = {...files};
    diagnostic['main.opy'] = diagnostic['main.opy'].replace(/ w_start_rule_crash| w_ow2_rule_condition_chase/g, '');
    const warnings = await compile(diagnostic);
    assert.equal(baseline.result, warnings.result, 'Warning suppressions must not change the Workshop code');
    const warningCounts = {};
    for (const warning of warnings.warnings) {
        const id = warning.message.match(/\((w_[^)]+)\)/)?.[1] || 'other';
        warningCounts[id] = (warningCounts[id] || 0) + 1;
    }

    assert(files['global_start_menu.opy'].includes('for equalSpawnWeightHeroIndex in range(19):'));
    assert(files['global_start_menu.opy'].includes('botSpawnRateList.append(5.263)'));
    const spawnRule = rule(baseline.result, 'SPAWN BOTS');
    const loopStart = spawnRule.indexOf('            While(');
    const loopEnd = spawnRule.indexOf('            End;', loopStart);
    assert(loopStart >= 0 && loopEnd > loopStart);
    const spawnLoop = spawnRule.slice(loopStart, loopEnd);
    assert(!spawnLoop.includes('Wait('));
    assert(!spawnLoop.includes('Count Of(Global.botSpawnRateList)'));
    const equalWeights = Array(19).fill(5.263);
    const sum = equalWeights.reduce((a, b) => a + b, 0);
    const roll = 99.999;
    assert(sum < roll && roll < 100);

    assert(files['global_startup.opy'].includes('"Number of Powerups Per Supply Drop", 5, 1, 10'));
    const singleCount = {...files};
    assert(singleCount['supply_drops.opy'].includes('120 / (supplyDropPowerUpCount - 1)'));
    singleCount['supply_drops.opy'] = singleCount['supply_drops.opy'].replace('120 / (supplyDropPowerUpCount - 1)', '120 / (1 - 1)');
    const singleBuild = await compile(singleCount);
    const tradeName = 'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)';
    const singleTradeRule = rule(singleBuild.result, tradeName);
    assert(singleTradeRule.includes('For Global Variable(tmp0, -60, 61, False)'));

    const determine = rule(baseline.result, 'determineObjectiveType');
    const fallbackStart = determine.indexOf('While(');
    const fallbackEnd = determine.indexOf('End;', fallbackStart);
    assert(fallbackStart >= 0 && fallbackEnd > fallbackStart);
    assert(!determine.slice(fallbackStart, fallbackEnd).includes('Wait('));

    const tradeSource = files['supply_drops.opy'].slice(files['supply_drops.opy'].indexOf('eventPlayer.powerUpTradeIndex ='));
    assert(/^eventPlayer\.powerUpTradeIndex =[^\n]+\n\s+wait\(\)/.test(tradeSource));
    const items = ['A', 'B'];
    const pIndex = 0, qIndex = 0;
    const awarded = [items[pIndex], items[qIndex]];
    items.splice(pIndex, 1);
    items.splice(qIndex, 1);
    assert.deepEqual(awarded, ['A', 'A']);
    assert.deepEqual(items, []);

    assert(files['players_game_in_progress.opy'].includes('eventPlayer.invisibilityCount = false'));
    assert(files['supply_drops.opy'].includes('eventPlayer.invisibilityCount--'));
    const cloakState = {count: 1, speed: 1.5};
    // A later initialization resets these values, then the old worker finishes.
    cloakState.count = 0;
    cloakState.speed = 1;
    cloakState.count--;
    cloakState.speed /= 1.5;
    assert.equal(cloakState.count, -1);
    assert(cloakState.speed < 1);

    const bio = rule(baseline.result, 'BIOWASTE MANAGEMENT');
    assert(bio.includes('Wait(0.15'));
    assert(!bio.includes('Global.isGameplayActive'));
    assert(files['variables.opy'].includes('#!define biomorphingResourcePositionList objectivePositionsSlot'));
    assert(files['variables.opy'].includes('#!define satelliteTerminalPositionList objectivePositionsSlot'));

    const names = ['SPAWN BOTS', 'determineObjectiveType', 'powerUpUsage', tradeName, 'BIOWASTE MANAGEMENT', 'PLAYER INITIALIZATION', 'cloakingDevice (60-69)'];
    console.log(JSON.stringify({
        date: '2026-11-04',
        sourceSha256: Object.fromEntries(Object.entries(files).map(([name, source]) =>
            [name, crypto.createHash('sha256').update(source).digest('hex')])),
        baseline: {elements: baseline.elements, warningsWithExistingSuppressions: baseline.warnings.length},
        diagnostics: {elements: warnings.elements, sameWorkshop: baseline.result === warnings.result, warningCounts, warnings: warnings.warnings},
        weightedSpawn: {weights: equalWeights.length, weight: equalWeights[0], sum, sampleRoll: roll, selectionExhaustsWeights: sum < roll, compiledLoop: spawnLoop},
        singleItemSupply: {allowedSetting: 1, denominator: 0, constantSpecializationStep: 'False (0)', compiledRule: singleTradeRule,
            limitation: 'Zero-step behavior of the actual Workshop server was not executed.'},
        disabledObjectives: {availableFallbackIdsWhenAllTypesDisabled: [], compiledRuleHasFallbackWhileWithoutWait: true},
        pickupInterleaving: {startingItems: ['A', 'B'], playerIndices: [pIndex, qIndex], awarded, remainingItems: items,
            schedule: 'Both players resolve index 0 and read A before either deletion; then each deletes index 0.'},
        cloakAfterInitializationThenOldCleanup: cloakState,
        compiledRules: Object.fromEntries(names.map(name => [name, rule(baseline.result, name)])),
        limitation: 'Static analysis and bounded models only. No game-server crash, player disconnect, or resource exhaustion was reproduced.',
    }, null, 2));
}

main().catch(error => { console.error(error); process.exitCode = 1; });
