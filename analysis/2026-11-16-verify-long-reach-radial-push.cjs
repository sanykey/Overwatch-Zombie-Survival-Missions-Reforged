const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');
const name = '[LONG_REACH] MELEE PUSH';
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const ready = slot('augmentMeleePushReadyAt'), scale = slot('botKnockbackScale');
const bot = (id, position, extra = {}) => ({id, position, team: 2, alive: true, visible: true, [scale]: 1, ...extra});
const state = (targets, extra = {}) => scenario(4, {buttons: new Set(['Crouch', 'Jump']), targets, ...extra});
(async () => {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const file of ['long_reach.opy', 'augments.opy']) baseline[file] = execFileSync('git', ['show', 'fe62eda:src/' + file], {cwd: root, encoding: 'utf8'});
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []); assert.deepEqual(after.warnings, []);
    const allowed = new Set([name, 'AUGMENT MENU']);
    assert.deepEqual(rules(before.result).filter(r => !allowed.has(r.name)), rules(after.result).filter(r => !allowed.has(r.name)));
    const compiled = new Map(rules(after.result).map(r => [r.name, r])), push = compiled.get(name);
    let checks = 0;
    for (const size of [0.5, 1, 2]) {
        const s = state([bot('front', [0, 0, 10]), bot('back', [0, 0, -10]),
            bot('left', [-10, 0, 0]), bot('right', [10, 0, 0], {[scale]: 0.7}),
            bot('above', [0, 10, 0]), bot('outside', [0, 0, 10.001])]);
        s.player.sizeScale = size;
        assert(start(push, s, compiled).done());
        assert.deepEqual(s.impulses.map(i => i.target), ['front', 'back', 'left', 'right', 'above']);
        assert.deepEqual(s.impulses.map(i => i.speed), [25, 25, 25, 17.5, 25]);
        assert.equal(s.player[ready], 116);
        assert.equal(s.damage.length, 0);
        assert.deepEqual(s.effects, [{effect: 'Ring Explosion', color: 'Color(Red)', position: [0, 0.75, 0], size: 10}]);
        s.time = 115.999; start(push, s, compiled); assert.equal(s.impulses.length, 5);
        s.time = 116; start(push, s, compiled); assert.equal(s.impulses.length, 10);
        checks++;
    }
    for (const extra of [{visible: false}, {alive: false}, {team: 1}, {[scale]: 0},
        {[slot('botIsAttached')]: true}, {[slot('botIsTeleporting')]: true}]) {
        const s = state([bot('excluded', [0, 0, 3], extra)]);
        start(push, s, compiled); assert.equal(s.impulses.length, 0); assert.equal(s.player[ready] ?? 0, 0); checks++;
        assert.equal(s.effects.length, 0);
    }
    for (const buttons of [[], ['Melee'], ['Crouch'], ['Jump'], ['Crouch', 'Jump']]) {
        assert.equal(applies(push, state([], {buttons: new Set(buttons)})), buttons.length === 2); checks++;
    }
    for (const list of ['bossStateList', 'miniBossList']) {
        const boss = bot('boss', [0, 0, 3]);
        const s = state([boss]);
        s.globals[list] = [boss];
        start(push, s, compiled);
        assert.equal(s.impulses.length, 0);
        assert.equal(s.player[ready] ?? 0, 0);
        assert.equal(s.effects.length, 0);
        const mixed = state([boss, bot('ordinary', [0, 0, -3])]);
        mixed.globals[list] = [boss];
        start(push, mixed, compiled);
        assert.deepEqual(mixed.impulses.map(i => i.target), ['ordinary']);
        checks += 2;
    }
    const output = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.deepEqual(output.encounteredWarnings, []);
    assert.deepEqual(rules(output.result), rules(after.result));
    fs.writeFileSync(path.join(root, 'main.ws.txt'), output.result);
    console.log(JSON.stringify({beforeElements: before.elements, afterElements: after.elements,
        deltaElements: after.elements - before.elements, checks, warnings: after.warnings,
        nativeGameplayVerified: false}, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
