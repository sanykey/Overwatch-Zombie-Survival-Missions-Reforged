// Read-only probes for nonnegative numeric predicates; leave src/ untouched.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function cooldownZeroChecks(f) {
    const hits = [];
    for (const file of Object.keys(f)) {
        f[file] = f[file].replace(
            /([A-Za-z_][A-Za-z0-9_.]*\.getAbilityCooldown\([^()]*\))\s*(<=|>)\s*0(?![\d.])/g,
            (old, value, operator, offset) => {
                hits.push(`${file}:${f[file].slice(0, offset).split('\n').length}`);
                return operator === '>' ? value : `not ${value}`;
            });
    }
    assert.equal(hits.length, 12);
    return hits;
}

function heroCountZeroChecks(f) {
    const hits = [];
    for (const file of Object.keys(f)) {
        f[file] = f[file].replace(/getNumberOfHeroes\(([^()]+)\)\s*(>|<=)\s*0(?![\d.])/g,
            (old, args, operator, offset) => {
                hits.push(`${file}:${f[file].slice(0, offset).split('\n').length}`);
                return operator === '>' ? `getNumberOfHeroes(${args})`
                    : `not getNumberOfHeroes(${args})`;
            });
    }
    assert.equal(hits.length, 4);
    return hits;
}

function nonemptyObjectiveList(f) {
    const file = 'players_game_in_progress.opy';
    const old = 'len(objectivePositionList) >= 1';
    assert.equal(f[file].split(old).length - 1, 1);
    f[file] = f[file].replace(old, 'len(objectivePositionList)');
    return [`${file}:94`];
}

function otherUnsignedChecks(f) {
    const edits = [
        ['objective_types/objective_type_satellite_uplink.opy',
            'satelliteRepairPlayerCount > 0', 'satelliteRepairPlayerCount'],
        ['enhancements.opy',
            'eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton) > 0',
            'eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton)'],
    ];
    const hits = [];
    for (const [file, old, next] of edits) {
        assert.equal(f[file].split(old).length - 1, 1, old);
        hits.push(`${file}:${f[file].slice(0, f[file].indexOf(old)).split('\n').length}`);
        f[file] = f[file].replace(old, next);
    }
    return hits;
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    assert.equal(baseline.elements, 25283);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    const variants = {cooldownZeroChecks, heroCountZeroChecks,
        nonemptyObjectiveList, otherUnsignedChecks};
    for (const [name, transform] of Object.entries(variants)) {
        const next = {...files};
        try {
            const hits = transform(next);
            const result = await compile(next);
            assert.equal(rules(result.result).length, rules(baseline.result).length);
            console.log(JSON.stringify({name, count: hits.length,
                saved: baseline.elements - result.elements, elements: result.elements,
                warnings: result.warnings.length, hits}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const combined = {...files};
    for (const transform of Object.values(variants)) transform(combined);
    const result = await compile(combined);
    const beforeRules = rules(baseline.result), afterRules = rules(result.result);
    assert.equal(afterRules.length, beforeRules.length);
    console.log(JSON.stringify({name: 'combined', elements: result.elements,
        saved: baseline.elements - result.elements, warnings: result.warnings.length,
        rules: afterRules.length, changedRules: afterRules.filter((rule, i) =>
            rule.body !== beforeRules[i].body).length}));
}

module.exports = {cooldownZeroChecks, heroCountZeroChecks,
    nonemptyObjectiveList, otherUnsignedChecks};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
