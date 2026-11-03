// Compile numeric zero-check reductions in memory; src/ is not modified.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function replaceAll(f, old, next) {
    let count = 0;
    for (const file of Object.keys(f)) {
        count += f[file].split(old).length - 1;
        f[file] = f[file].replaceAll(old, next);
    }
    return count;
}

function numericStateChecks(f) {
    const names = [
        'eventPlayer.initialMaxHealth', 'biomorphingCapturePercent',
        'zombieSetting', 'challengeSetting', 'voteWinnerResult',
        'eventPlayer.pregameChallengeVote', 'eventPlayer.pregameZombieVote',
        'eventPlayer.pregameObjectiveVote', 'eventPlayer.powerUpTradePreviousItemId',
        'eventPlayer.powerUpItemId',
    ];
    let count = 0;
    for (const name of names) {
        count += replaceAll(f, `${name} == 0`, `not ${name}`);
        count += replaceAll(f, `${name} != 0`, name);
    }
    assert.equal(count, 14);
    return count;
}

function throttleTruth(f) {
    let count = 0;
    for (const file of Object.keys(f)) {
        f[file] = f[file].replace(
            /magnitude\(([A-Za-z_][A-Za-z0-9_.]*)\.getThrottle\(\)\)\s*(==|!=)\s*0/g,
            (_, player, op) => {
                count++;
                return op === '!=' ? `magnitude(${player}.getThrottle())`
                    : `not magnitude(${player}.getThrottle())`;
            });
    }
    assert.equal(count, 9);
    return count;
}

function blinkPhaseChecks(f) {
    const pairs = [
        ['ceil(getTotalTimeElapsed() * 0.2) % 2 == 0',
            'not (ceil(getTotalTimeElapsed() * 0.2) % 2)'],
        ['ceil(getTotalTimeElapsed() * 1.25) % 2 == 0',
            'not (ceil(getTotalTimeElapsed() * 1.25) % 2)'],
        ['ceil(getTotalTimeElapsed() * 2) % 2 == 0',
            'not (ceil(getTotalTimeElapsed() * 2) % 2)'],
        ['((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer, localPlayer) > 10 else 8))) % 2) == 0',
            'not (((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer, localPlayer) > 10 else 8))) % 2))'],
    ];
    const count = pairs.reduce((total, [old, next]) => total + replaceAll(f, old, next), 0);
    assert.equal(count, 5);
    return count;
}

function otherNumericChecks(f) {
    const pairs = [
        ['eventPlayer.powerUpBouncePadTimeRemaining % 0.25 == 0',
            'not (eventPlayer.powerUpBouncePadTimeRemaining % 0.25)'],
        ['random.randint(0, 1) == 0', 'not random.randint(0, 1)'],
        ['eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0',
            'not eventPlayer.getAbilityCooldown(Button.ABILITY_1)'],
        ['eventPlayer.getAbilityCooldown(x) == 0',
            'not eventPlayer.getAbilityCooldown(x)'],
    ];
    const count = pairs.reduce((total, [old, next]) => total + replaceAll(f, old, next), 0);
    assert.equal(count, 6);
    return count;
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    assert.equal(baseline.elements, 25350);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    const variants = {numericStateChecks, throttleTruth, blinkPhaseChecks, otherNumericChecks};
    for (const [name, transform] of Object.entries(variants)) {
        const next = {...files};
        try {
            const count = transform(next);
            const result = await compile(next);
            assert.equal(rules(result.result).length, rules(baseline.result).length);
            console.log(JSON.stringify({name, count, elements: result.elements,
                saved: baseline.elements - result.elements, warnings: result.warnings.length}));
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

module.exports = {numericStateChecks, throttleTruth, blinkPhaseChecks, otherNumericChecks};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
