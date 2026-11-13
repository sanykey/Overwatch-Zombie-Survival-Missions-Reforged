// Reproduce menu-owned shared storage leaking into Laser Barricade, then verify isolation.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {applies, start, scenario, actions} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');

async function main() {
    await compiler.readyPromise;
    const old = {...files};
    for (const [file, name] of [['dash.opy', '[DASH] CHARGE RECHARGE'], ['highrise.opy', '[HIGHRISE] DOUBLE TAP']]) {
        const at = old[file].indexOf(`rule "${name}":`);
        const gate = old[file].indexOf('    @Condition isGameplayActive == true\n', at);
        assert(gate > at);
        old[file] = old[file].slice(0, gate) + old[file].slice(gate).replace('    @Condition isGameplayActive == true\n', '');
    }
    const before = await compile(old), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const oldMap = new Map(oldRules.map(r => [r.name, r])), map = new Map(newRules.map(r => [r.name, r]));
    const changed = newRules.filter((r, i) => r.body !== oldRules[i].body).map(r => r.name);
    assert.deepEqual(changed.sort(), ['[DASH] CHARGE RECHARGE', '[HIGHRISE] DOUBLE TAP'].sort());
    for (const name of changed) {
        assert.equal(map.get(name).body.replace('Global.isGameplayActive == True;\n', ''), oldMap.get(name).body);
    }
    assert.equal(before.result.match(/^variables \{[\s\S]*?^\}/m)[0], after.result.match(/^variables \{[\s\S]*?^\}/m)[0]);
    const placement = map.get('LASER BARRICADE (PLACEMENT)');
    let cases = 0;
    for (const enhancementId of [1, 13]) {
        const state = scenario(2);
        state.player.enhancementId = enhancementId;
        state.globals.isGameplayActive = false;
        start(oldMap.get('[DASH] CHARGE RECHARGE'), state, oldMap);
        assert.equal(state.player.augmentState2, 1, 'Dash seeds one charge while cycling through the menu');
        state.player.augmentId = 7;
        state.globals.isGameplayActive = true;
        state.buttons = new Set(['Crouch', 'Interact']);
        assert(!applies(placement, state), 'Leaked one-second cooldown prevents the first placement');
        state.time += 100;
        assert.equal(state.player.augmentState2, 1, 'No placement coroutine exists to count it down');
        assert(!applies(placement, state));

        for (const augment of [2, 3]) {
            const fresh = scenario(augment);
            fresh.player.enhancementId = enhancementId;
            fresh.globals.isGameplayActive = false;
            fresh.buttons.add('Jump');
            assert(!applies(map.get(augment === 2 ? '[DASH] CHARGE RECHARGE' : '[HIGHRISE] DOUBLE TAP'), fresh));
            fresh.player.augmentId = 7;
            fresh.globals.isGameplayActive = true;
            fresh.buttons = new Set(['Crouch', 'Interact']);
            assert(applies(placement, fresh), 'First placement is ready for Engineer and Brain Killer');
            cases++;
        }
    }
    // Run the unchanged compiled cooldown loop after a successful placement.
    const placementActions = actions(placement);
    const cooldownAt = placementActions.findIndex(a => a === 'Set Player Variable(Event Player, augmentState2, 25);');
    assert(cooldownAt > 0);
    const cooldown = {...placement, body: placement.body.split('actions {\n')[0] + 'actions {\n' + placementActions.slice(cooldownAt).join('\n') + '\n}'};
    const state = scenario(7, {buttons: new Set(['Crouch', 'Interact'])});
    const task = start(cooldown, state, map);
    for (let remaining = 24; remaining >= 0; remaining--) {
        state.time += 1;
        task.resume();
        assert.equal(state.player.augmentState2, remaining);
    }
    assert(task.done());
    assert(applies(placement, state), 'Placement rearms after 25 seconds');
    const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), newRules);
    fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    const report = {beforeElements: before.elements, afterElements: after.elements,
        elementDelta: after.elements - before.elements, addedVariables: 0, changedRules: changed,
        baselineBugReproduced: true, menuCases: cases, cooldownTicks: 25, warnings: after.warnings,
        limitation: 'Compiled-action simulation; no in-game run.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-barrier-menu-cooldown-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
