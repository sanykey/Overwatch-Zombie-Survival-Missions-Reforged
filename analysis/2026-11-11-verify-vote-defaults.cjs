// Compile the actual sources, audit the exact behavioral delta, and model vote outcomes.
// Run from the repository root: node analysis/2026-11-11-verify-vote-defaults.cjs
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

// Model the existing sequential tie breaking; explore every possible coin flip.
function winners(counts) {
    let results = new Set([0]);
    for (let i = 1; i < counts.length; i++) {
        const next = new Set();
        for (const winner of results) {
            if (counts[winner] < counts[i]) next.add(i);
            else {
                next.add(winner);
                if (winner && counts[winner] === counts[i]) next.add(i);
            }
        }
        results = next;
    }
    return [...results].sort((a, b) => a - b);
}

function challengeWinner(counts) {
    const total = counts.slice(1).reduce((a, n) => a + Math.max(0, n), 0);
    // Disabled entries remain -1, matching the existing weighted-average behavior.
    const average = total ? counts.reduce((a, n, i) => a + n * i, 0) / total : 0;
    let result = 0;
    for (let i = 1; i < counts.length; i++) {
        if (counts[result] < counts[i] || counts[i] > 0 && counts[result] === counts[i]
            && Math.abs(result - average) > Math.abs(i - average)) result = i;
    }
    return result || 1;
}

async function main() {
    await compiler.readyPromise;
    const baseline = {...files, 'global_start_menu.opy': execFileSync('git',
        ['show', 'HEAD:src/global_start_menu.opy'], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const slots = {determineZombieMode: 'phaseSlot5', determineChallenge: 'phaseSlot3',
        determineObjectiveType: 'phaseSlot4'};
    assert.equal(newRules.length, oldRules.length);
    let resets = 0;
    for (let i = 0; i < newRules.length; i++) {
        const current = newRules[i], old = oldRules[i];
        assert.equal(current.name, old.name);
        const slot = slots[current.name];
        if (!slot) { assert.deepEqual(current, old); continue; }
        // OverPy's aggressive optimization emits numeric zero as False/Null here.
        const reset = `Set Global Variable At Index(${slot}, False, Null);\n`;
        assert.equal(current.body.split(reset).length, 2);
        assert(current.body.indexOf(reset) < current.body.indexOf('For Global Variable('));
        assert.equal(current.body.replace(reset, ''), old.body,
            'Only the no-preference count may change; preserve counting, defaults and tie breaking');
        resets++;
    }
    assert.equal(resets, 3);
    assert.equal(after.elements - before.elements, 3);

    // Exhaust all disabled/zero/one/two-vote combinations across six real options.
    let cases = 0;
    for (let mask = 0; mask < 4 ** 6; mask++) {
        let remaining = mask;
        const counts = [0];
        for (let i = 0; i < 6; i++, remaining = Math.floor(remaining / 4))
            counts.push(remaining % 4 - 1);
        const max = Math.max(...counts);
        const expected = max > 0 ? counts.flatMap((n, i) => i && n === max ? [i] : []) : [0];
        assert.deepEqual(winners(counts), expected);
        const challenge = challengeWinner(counts);
        if (max > 0) assert(expected.includes(challenge));
        else assert.equal(challenge, 1);
        cases++;
    }
    // IDs 3, 4 and 8 are holes in the objective menu. Ignore disabled types.
    const objectives = [0, 0, 0, -1, -1, 0, 0, 0, -1, 0];
    assert.deepEqual(winners(objectives), [0]); // existing fallback chooses Mixed Objectives (9)
    assert.deepEqual(winners([0, ...Array(6).fill(0)]).map(i => i || 1), [1]);
    for (const id of [1, 2, 5, 6, 7, 9]) {
        const counts = [...objectives]; counts[id] = 1;
        assert.deepEqual(winners(counts), [id]); // a single vote must beat no preference
    }
    const report = {date: '2026-11-11', beforeElements: before.elements, afterElements: after.elements,
        addedElements: after.elements - before.elements, compiledResetActions: resets,
        allOtherCompiledActionsUnchanged: true, modeledVoteCombinations: cases,
        defaults: {zombieMode: 'All Zombies', challenge: 'None', objectiveType: 'Mixed Objectives'},
        warnings: after.warnings, inGameValidated: false};
    fs.writeFileSync(path.join(root, 'main.ws.txt'), after.result);
    fs.writeFileSync(path.join(__dirname, '2026-11-11-vote-defaults-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(e => { console.error(e); process.exitCode = 1; });
