// Read-only audit of src/: compile a baseline and a candidate in memory.
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

function rule(result, name) {
    const start = result.indexOf(`rule ("${name}")`);
    assert(start >= 0, `Missing compiled rule: ${name}`);
    const end = result.indexOf('\n}\n', start);
    assert(end >= 0, `Missing rule end: ${name}`);
    return result.slice(start, end + 3);
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    const candidate = {...files};
    const file = 'objective_types/objective_type_bosses.opy';
    const before = 'bossReturnCandidateList = mapGridList.filter(lambda x: isInLoS(x, eventPlayer.botReturnTarget.getEyePosition()) and distance(x, eventPlayer.botReturnTarget) > 5 and distance(x, eventPlayer.botReturnTarget) < 20)';
    const after = 'bossReturnCandidateList = mapGridList.filter(lambda x: distance(x, eventPlayer.botReturnTarget) > 5 and distance(x, eventPlayer.botReturnTarget) < 20)\n        bossReturnCandidateList = bossReturnCandidateList.filter(lambda x: isInLoS(x, eventPlayer.botReturnTarget.getEyePosition()))';
    assert(candidate[file].includes(before), 'Source changed: recheck the candidate');
    candidate[file] = candidate[file].replace(before, after);
    const probe = await compile(candidate);
    const compiledCandidate = rule(probe.result, 'bossReturn');
    // Ensure size optimization has retained the separate spatial and LOS passes.
    assert(compiledCandidate.includes('Filtered Array(Global.tmp0, Is In Line of Sight('));
    const names = ['BOT TARGET VISIBLE', 'selectTarget', 'LASER BARRICADE BLOCKS ZOMBIES', 'sentryTurret (50-59)', 'bossReturn'];
    const fieldCandidate = {...files};
    const fieldFile = 'supply_drops.opy';
    const fieldStart = fieldCandidate[fieldFile].indexOf('def playerForceField():');
    const fieldEnd = fieldCandidate[fieldFile].indexOf('\ndef noCooldowns():', fieldStart);
    assert(fieldStart >= 0 && fieldEnd > fieldStart);
    const originalFieldSource = fieldCandidate[fieldFile].slice(fieldStart, fieldEnd);
    const fieldLoop = '        for forceFieldZombieIndex in range(getNumberOfLivingPlayers(Team.2)):';
    assert(originalFieldSource.includes(fieldLoop));
    const fieldSource = originalFieldSource.replace(fieldLoop,
        '        #!define forceFieldLivingZombieList tmp1\n' +
        '        forceFieldLivingZombieList = getLivingPlayers(Team.2)\n' +
        '        for forceFieldZombieIndex in range(len(forceFieldLivingZombieList)):')
        .replaceAll('getLivingPlayers(Team.2)[forceFieldZombieIndex]', 'forceFieldLivingZombieList[forceFieldZombieIndex]');
    fieldCandidate[fieldFile] = fieldCandidate[fieldFile].slice(0, fieldStart) + fieldSource + fieldCandidate[fieldFile].slice(fieldEnd);
    const fieldProbe = await compile(fieldCandidate);
    const fieldBaselineRule = rule(baseline.result, 'playerForceField (10-19)');
    const fieldCandidateRule = rule(fieldProbe.result, 'playerForceField (10-19)');
    assert(fieldCandidateRule.includes('Set Global Variable(tmp1, All Living Players(Team 2))'));
    const visibilityCandidate = {...files};
    const visibilityPairs = [
        ['players_game_in_progress.opy', 'getAllPlayers().filter(lambda _: eventPlayer.isInfected)', '(getAllPlayers() if eventPlayer.isInfected else [])'],
        ['players_game_in_progress.opy', 'getAllPlayers().filter(lambda _: eventPlayer.isReviving)', '(getAllPlayers() if eventPlayer.isReviving else [])'],
        ['subroutines.opy', 'getAllPlayers().filter(lambda _: eventPlayer.botGasProjectilePosition != null)', '(getAllPlayers() if eventPlayer.botGasProjectilePosition != null else [])'],
        ['subroutines.opy', 'getAllPlayers().filter(lambda _: eventPlayer.botTentacleTargetPosition != 0)', '(getAllPlayers() if eventPlayer.botTentacleTargetPosition != 0 else [])'],
    ];
    let replacedVisibilityFilters = 0;
    for (const [name, before, after] of visibilityPairs) {
        const count = visibilityCandidate[name].split(before).length - 1;
        assert(count > 0, `Missing visibility expression: ${before}`);
        replacedVisibilityFilters += count;
        visibilityCandidate[name] = visibilityCandidate[name].replaceAll(before, after);
    }
    const visibilityProbe = await compile(visibilityCandidate);
    assert(visibilityProbe.result.includes('If-Then-Else((Event Player).isInfected, All Players(All Teams), Empty Array)'));
    console.log(JSON.stringify({
        date: '2026-11-04',
        sourceSha256: Object.fromEntries(Object.entries(files).map(([name, contents]) =>
            [name, crypto.createHash('sha256').update(contents).digest('hex')])),
        baseline: {
            elements: baseline.elements,
            rules: (baseline.result.match(/^rule \(/gm) || []).length,
            warningsWithExistingSuppressions: baseline.warnings.length,
        },
        bossSpatialPrefilter: {
            elements: probe.elements,
            elementDelta: probe.elements - baseline.elements,
            warningsWithExistingSuppressions: probe.warnings.length,
            compiledRule: compiledCandidate,
        },
        forceFieldSnapshot: {
            elements: fieldProbe.elements,
            elementDelta: fieldProbe.elements - baseline.elements,
            warningsWithExistingSuppressions: fieldProbe.warnings.length,
            baselineLivingPlayersExpressionNodes: (fieldBaselineRule.match(/All Living Players\(Team 2\)/g) || []).length,
            candidateLivingPlayersExpressionNodes: (fieldCandidateRule.match(/All Living Players\(Team 2\)/g) || []).length,
            compiledRule: fieldCandidateRule,
            limitation: 'Expression-node counts are static, not counts of engine evaluations or timing measurements.',
        },
        constantVisibilityPredicates: {
            replacedExpressions: replacedVisibilityFilters,
            elements: visibilityProbe.elements,
            elementDelta: visibilityProbe.elements - baseline.elements,
            warningsWithExistingSuppressions: visibilityProbe.warnings.length,
            allPlayerUnusedParameterFiltersInSource: Object.values(files).join('\n').split('getAllPlayers().filter(lambda _:').length - 1,
            limitation: 'Each candidate retains reevaluation and removes an array filter with a player-independent predicate; runtime gain is unmeasured.',
        },
        baselineRules: Object.fromEntries(names.map(name => [name, rule(baseline.result, name)])),
        limitation: 'Compilation and static inspection only; no in-game server or client timing measurements.',
    }, null, 2));
}

main().catch(error => { console.error(error); process.exitCode = 1; });
