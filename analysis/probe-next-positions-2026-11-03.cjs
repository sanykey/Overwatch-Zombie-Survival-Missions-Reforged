// Compile isolated position-expression candidates in memory; leave src/ untouched.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const knownPlayers = 'eventPlayer|localPlayer|player|victim|rescueSurvivor|reigniteSpawnSource|supplyDropClosestPlayer|barrierCollisionTarget|satelliteLaserTarget|eventPlayer\\.botTarget|eventPlayer\\.botAbilityTarget|eventPlayer\\.botLastTarget|eventPlayer\\.botReturnTarget|eventPlayer\\.powerUpStunTarget|eventPlayer\\.powerUpStunOrigin|eventPlayer\\.enhancementPupTarget|eventPlayer\\.rescueLeader|rescueSurvivor\\.rescueLeader|bossesStateList\\[0\\]|getClosestPlayer\\(eventPlayer, Team\\.1\\)';
const variants = {
    distance_second(f) {
        const re = new RegExp(`distance\\(([^,\\n]+),\\s*(${knownPlayers})\\.getPosition\\(\\)\\)`, 'g');
        return edit(f, re, (_, first, player) => `distance(${first}, ${player})`);
    },
    distance_first(f) {
        const re = new RegExp(`distance\\((${knownPlayers})\\.getPosition\\(\\),`, 'g');
        return edit(f, re, (_, player) => `distance(${player},`);
    },
    direction_first(f) {
        const re = new RegExp(`directionTowards\\((${knownPlayers})\\.getPosition\\(\\),`, 'g');
        return edit(f, re, (_, player) => `directionTowards(${player},`);
    },
    direction_second(f) {
        const re = new RegExp(`directionTowards\\(([^,\\n]+),\\s*(${knownPlayers})\\.getPosition\\(\\)\\)`, 'g');
        return edit(f, re, (_, first, player) => `directionTowards(${first}, ${player})`);
    },
    distance_lambda_first(f) {
        const re = /distance\(x\.getPosition\(\),/g;
        const allowed = new Set(['supply_drops.opy', 'subroutines.opy', 'objective_types/objective_type_survivor_rescue.opy', 'objective_types/objective_type_satellite_uplink.opy', 'objective_types/objective_type_kill_zone.opy', 'enhancements.opy', 'global_game_in_progress.opy', 'bots_game_in_progress.opy', 'objective_types/objective_type_bosses.opy']);
        return edit(f, re, () => 'distance(x,', allowed);
    },
    distance_lambda_second(f) {
        const re = /distance\(([^,\n]+),\s*x\.getPosition\(\)\)/g;
        const allowed = new Set(['zombie_types.opy', 'supply_drops.opy', 'objective_types/objective_type_zombie_egg.opy', 'objective_types/objective_type_satellite_uplink.opy', 'bots_game_in_progress.opy']);
        return edit(f, re, (_, first) => `distance(${first}, x)`, allowed);
    },
};
function edit(f, re, change, allowed = null) {
    const matches = [];
    for (const name of Object.keys(f)) {
        if (allowed && !allowed.has(name)) continue;
        f[name] = f[name].replace(re, (...args) => {
            const offset = args.at(-2);
            const line = f[name].slice(0, offset).split('\n').length;
            matches.push(`${name}:${line} ${args[0]}`);
            return change(...args);
        });
    }
    assert(matches.length > 0, 'No matches');
    return matches;
}
async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const candidate = {...files};
        try {
            const matches = transform(candidate);
            const result = await compile(candidate);
            console.log(JSON.stringify({name, count: matches.length, elements: result.elements,
                saved: baseline.elements - result.elements, warnings: result.warnings.length,
                matches}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const candidate = {...files};
    const counts = Object.fromEntries(Object.entries(variants).map(([name, transform]) => [name, transform(candidate).length]));
    const result = await compile(candidate);
    const oldRules = rules(baseline.result), newRules = rules(result.result);
    assert.equal(newRules.length, oldRules.length);
    const changedRules = newRules.filter((rule, i) => rule.body !== oldRules[i].body).map(rule => rule.name);
    console.log(JSON.stringify({name: 'combined', counts, elements: result.elements,
        saved: baseline.elements - result.elements, warnings: result.warnings.length,
        rules: oldRules.length, changedRuleCount: changedRules.length}));
}
module.exports = {variants};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
