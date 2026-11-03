// Read-only element-count probes against the current source tree.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function emptyListChecks(f) {
    const matches = [];
    for (const file of Object.keys(f)) {
        f[file] = f[file].replace(/len\(([A-Za-z_][A-Za-z0-9_.]*)\)\s*(==|!=|>|<=)\s*0/g,
            (old, list, operator, offset) => {
                const line = f[file].slice(0, offset).split('\n').length;
                matches.push(`${file}:${line} ${old}`);
                return `${list} ${operator === '==' || operator === '<=' ? '==' : '!='} []`;
            });
    }
    assert.equal(matches.length, 48);
    return matches;
}

function remainingPlayerPositions(f) {
    const changes = [
        ['zombie_types.opy',
            'distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget.getPosition())',
            'distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget)'],
        ['zombie_types.opy',
            'distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition())',
            'distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), x)'],
        ['zombie_types.opy',
            'distance(x.getPosition(), worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION))',
            'distance(x, worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION))'],
        ['zombie_types.opy',
            'directionTowards(eventPlayer, eventPlayer.botTarget.getPosition() if eventPlayer.botChargerDestination == null else eventPlayer.botChargerDestination)',
            'directionTowards(eventPlayer, eventPlayer.botTarget if eventPlayer.botChargerDestination == null else eventPlayer.botChargerDestination)'],
        ['zombie_types.opy',
            'directionTowards(eventPlayer, eventPlayer.botSpecialTargetList[eventPlayer.botEnsnarerTargetIndex].getPosition())',
            'directionTowards(eventPlayer, eventPlayer.botSpecialTargetList[eventPlayer.botEnsnarerTargetIndex])'],
        ['subroutines.opy', 'distance(player, rescueSurvivor[0].getPosition())',
            'distance(player, rescueSurvivor[0])'],
        ['players_game_in_progress.opy', 'distance(x.getPosition(), currentObjectivePosition)',
            'distance(x, currentObjectivePosition)'],
        ['supply_drops.opy',
            'directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex].getPosition())',
            'directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex])'],
        ['bots_game_in_progress.opy',
            'directionTowards(eventPlayer, sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer, x))[0].getPosition())',
            'directionTowards(eventPlayer, sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer, x))[0])'],
        ['objective_types/objective_type_survivor_rescue.opy',
            'else eventPlayer.rescueLeader.getPosition()), 0 if eventPlayer.rescueLeader',
            'else eventPlayer.rescueLeader), 0 if eventPlayer.rescueLeader'],
        ['objective_types/objective_type_survivor_rescue.opy',
            'distance(localPlayer, eventPlayer.getPosition() if distance(eventPlayer, localPlayer) > objectiveRad else currentObjectivePosition)',
            'distance(localPlayer, eventPlayer if distance(eventPlayer, localPlayer) > objectiveRad else currentObjectivePosition)'],
    ];
    const matches = [];
    for (const [file, old, next] of changes) {
        assert(f[file].includes(old), `Missing ${file}: ${old}`);
        assert.notEqual(old, next, `No-op ${file}: ${old}`);
        const count = f[file].split(old).length - 1;
        assert.equal(count, 1, `Expected one match in ${file}: ${old}`);
        matches.push(`${file}:${f[file].slice(0, f[file].indexOf(old)).split('\n').length}`);
        f[file] = f[file].replace(old, next);
    }
    return matches;
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    for (const [name, transform] of Object.entries({emptyListChecks, remainingPlayerPositions})) {
        const next = {...files};
        try {
            const matches = transform(next);
            const result = await compile(next);
            assert.equal(rules(result.result).length, rules(baseline.result).length);
            console.log(JSON.stringify({name, count: matches.length, elements: result.elements,
                saved: baseline.elements - result.elements, warnings: result.warnings.length,
                matches}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const combined = {...files};
    emptyListChecks(combined);
    remainingPlayerPositions(combined);
    const result = await compile(combined);
    const beforeRules = rules(baseline.result), afterRules = rules(result.result);
    assert.equal(afterRules.length, beforeRules.length);
    console.log(JSON.stringify({name: 'combined', elements: result.elements,
        saved: baseline.elements - result.elements, warnings: result.warnings.length,
        rules: afterRules.length, changedRules: afterRules.filter((rule, i) =>
            rule.body !== beforeRules[i].body).length}));
}

module.exports = {emptyListChecks, remainingPlayerPositions};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
