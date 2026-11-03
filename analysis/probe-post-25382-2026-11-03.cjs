// Compile further Workshop-size candidates in memory; do not edit src/.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function zeroThrottleMagnitude(f) {
    const hits = [];
    for (const file of Object.keys(f)) {
        f[file] = f[file].replace(
            /([A-Za-z_][A-Za-z0-9_.]*)\.getThrottle\(\)\s*(==|!=)\s*vect\(0, 0, 0\)/g,
            (old, player, operator, offset) => {
                hits.push(`${file}:${f[file].slice(0, offset).split('\n').length}`);
                return `magnitude(${player}.getThrottle()) ${operator} 0`;
            });
    }
    assert.equal(hits.length, 9);
    return hits;
}

function radiusBuiltin(f) {
    const edits = [
        ['supply_drops.opy', 'airStrikeImpactPosition', 'Team.2', 5],
        ['objective_types/objective_type_satellite_uplink.opy', 'satelliteLaserImpactPosition', 'Team.2', 5],
        ['objective_types/objective_type_satellite_uplink.opy', 'satelliteLaserImpactPosition', 'Team.1', 5],
        ['enhancements.opy', 'eventPlayer.enhancementPupTarget', 'Team.2', 3],
    ];
    const hits = [];
    for (const [file, center, team, radius] of edits) {
        const old = center === 'eventPlayer.enhancementPupTarget'
            ? `getPlayers(${team}).filter(lambda player: distance(${center}, player) < ${radius})`
            : `getPlayers(${team}).filter(lambda player: distance(player, ${center}) < ${radius})`;
        const next = `getPlayersInRadius(${center}, ${radius}, ${team})`;
        assert.equal(f[file].split(old).length - 1, 1, `${file}: ${old}`);
        hits.push(`${file}:${f[file].slice(0, f[file].indexOf(old)).split('\n').length}`);
        f[file] = f[file].replace(old, next);
    }
    return hits;
}

function departedPlayerCleanup(f) {
    const file = 'global_game_in_progress.opy';
    for (const list of ['playerTargetList', 'objectivePlayerList']) {
        const old = `${list}.remove(${list}.filter(lambda x: not entityExists(x)))`;
        const next = `${list} = ${list}.filter(lambda x: entityExists(x))`;
        assert.equal(f[file].split(old).length - 1, 1, old);
        f[file] = f[file].replace(old, next);
    }
    return [`${file}:115`, `${file}:116`];
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    assert.equal(baseline.elements, 25382);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    const variants = {zeroThrottleMagnitude, radiusBuiltin, departedPlayerCleanup};
    for (const [name, transform] of Object.entries(variants)) {
        const next = {...files};
        try {
            const hits = transform(next);
            const result = await compile(next);
            assert.equal(rules(result.result).length, rules(baseline.result).length);
            console.log(JSON.stringify({name, count: hits.length, elements: result.elements,
                saved: baseline.elements - result.elements, warnings: result.warnings.length, hits}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const combined = {...files};
    for (const transform of Object.values(variants)) transform(combined);
    const result = await compile(combined);
    const oldRules = rules(baseline.result), newRules = rules(result.result);
    assert.equal(newRules.length, oldRules.length);
    console.log(JSON.stringify({name: 'combined', elements: result.elements,
        saved: baseline.elements - result.elements, warnings: result.warnings.length,
        rules: newRules.length, changedRules: newRules.filter((rule, i) =>
            rule.body !== oldRules[i].body).length}));
}

module.exports = {zeroThrottleMagnitude, radiusBuiltin, departedPlayerCleanup};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
