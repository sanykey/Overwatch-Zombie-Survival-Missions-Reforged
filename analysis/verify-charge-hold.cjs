// Exercise the emitted delay and cancellation for both weapon-charge transfers.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, actions} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(rule => [rule.name, rule]));
    const inventory = compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)');
    assert(actions(inventory).some(action => action.trim() === 'Wait(0.25, Abort When False);'));
    let cases = 0;
    for (const [name, id, bankName, chargeName, bank, spent, armed] of [
        ['BOLT STRIKE ARMS CHARGE', 12, 'enhancementBoltEnergy', 'enhancementBoltBurst', 350, 350, -1],
        ['OVERCHARGE ARMS CHARGE', 9, 'enhancementCapacitorEnergy', 'enhancementCapacitorCharge', 250, 100, 100]
    ]) {
        const energy = slot(bankName), charge = slot(chargeName), rule = compiled.get(name);
        assert.equal(actions(rule).map(action => action.trim()).filter(Boolean)[0], 'Wait(0.25, Abort When False);');
        for (const cancel of [null, 'release', 'death', 'game end', 'enhancement change']) {
            const state = scenario(1, {buttons: new Set(['Melee'])});
            Object.assign(state.player, {enhancementId: id, [energy]: bank, [charge]: 0});
            const task = start(rule, state, compiled);
            assert.equal(task.deadline(), 100.25);
            state.time = 100.249;
            task.resume();
            assert.equal(state.player[energy], bank);
            assert.equal(state.player[charge], 0);
            if (cancel === 'release') state.buttons.clear();
            if (cancel === 'death') state.alive = false;
            if (cancel === 'game end') state.globals.isGameplayActive = false;
            if (cancel === 'enhancement change') state.player.enhancementId = 1;
            task.resume();
            state.time = 100.25;
            task.resume();
            assert(task.done());
            assert.equal(state.player[energy], cancel ? bank : bank - spent);
            assert.equal(state.player[charge], cancel ? 0 : armed);
            state.buttons.clear();
            task.resume();
            assert.equal(state.player[charge], cancel ? 0 : armed, 'Release preserves an armed charge');
            cases++;
        }
    }
    const before = {...files, 'enhancements.opy': files['enhancements.opy'].replaceAll(
        '    # Match inventory powerup activation; releasing Melee early preserves the bank.\n    wait(0.25, Wait.ABORT_WHEN_FALSE)\n', '')};
    const baseline = await compile(before);
    assert.deepEqual(baseline.warnings, []);
    console.log(JSON.stringify({cases, beforeElements: baseline.elements, elements: build.elements,
        delta: build.elements - baseline.elements, warnings: 0}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
