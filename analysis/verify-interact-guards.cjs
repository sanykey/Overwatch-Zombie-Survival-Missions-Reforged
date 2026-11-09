const assert = require('node:assert/strict');
const {files, compiler, compile} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start, applies, allowsInteraction, actions} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    const rule = compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)');
    const header = rule.body.split('actions {\n')[0];
    assert(!header.includes('augmentId') && !header.includes('enhancementId'));
    const held = slot('enhancementHeldZombie'), cooldown = slot('augmentBarrierPlacementCooldown');
    let cases = 0;
    for (let augment = 0; augment <= 10; augment++)
    for (const crouch of [false, true]) for (const carrying of [false, true])
    for (const cd of [-2, -1, 0, 1, 30]) {
        const s = scenario(augment, {buttons: new Set(['Interact', ...(crouch ? ['Crouch'] : [])])});
        Object.assign(s.player, {enhancementId: 11, [held]: carrying ? {} : 0, [cooldown]: cd});
        assert(applies(rule, s), 'Reservations no longer affect event Conditions');
        const expected = (carrying || augment !== 8 || !crouch) &&
            (carrying || augment !== 7 || (!crouch && cd >= 0));
        assert.equal(allowsInteraction(rule, s), expected, 'Preserve both original predicates');
        cases++;
    }
    const emitted = actions(rule);
    const call = emitted.indexOf('Call Subroutine(powerUpUsage);');
    assert.equal(emitted[call - 2], 'Wait(0.25, Abort When False);');
    const useOnly = {...rule, body: header + 'actions {\n' + emitted.slice(call - 2, call + 1).join('\n') + '\n}'};
    compiled.set('powerUpUsage', {body: 'actions {\nSet Player Variable(Event Player, powerUpItemId, 0);\n}'});
    for (const augment of [1, 7, 8, 10]) for (const change of ['none', 'crouch', 'phase', 'release', 'death', 'latch']) {
        const s = scenario(augment, {buttons: new Set(['Interact'])});
        s.player.powerUpItemId = 5;
        const task = start(useOnly, s, compiled);
        if (change === 'crouch') s.buttons.add('Crouch');
        if (change === 'phase') s.globals.isGameplayActive = false;
        if (change === 'release') s.buttons.delete('Interact');
        if (change === 'death') s.alive = false;
        if (change === 'latch') s.player[cooldown] = -1;
        s.time += 0.25; task.resume(); assert(task.done());
        const blocked = ['phase', 'release', 'death'].includes(change) ||
            (change === 'crouch' && [7, 8].includes(augment)) || (change === 'latch' && augment === 7);
        assert.equal(s.player.powerUpItemId, blocked ? 5 : 0);
        cases++;
    }
    console.log(JSON.stringify({elements: build.elements, warnings: 0, cases,
        checked: 'entry guards equivalent/Dead Weight precedence/barricade latch/post-hold input and phase checks'}, null, 2));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
