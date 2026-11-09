// Emitted-action checks; native rule scheduling and physics still need in-game testing.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const cp = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start} = require('./verify-augments.cjs');
const slot = n => files['variables.opy'].match(new RegExp('^#!define ' + n + ' (\\w+)$', 'm'))[1];
async function main() {
    await compiler.readyPromise;
    const baseline = {...files, 'supply_drops.opy': cp.execFileSync('git', ['show', 'HEAD:src/supply_drops.opy'], {encoding:'utf8'}).replace(/\r\n/g, '\n')};
    const before = await compile(baseline), build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const parsed = rules(build.result), compiled = new Map(parsed.map(r => [r.name, r]));
    const input = 'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)';
    const old = rules(before.result);
    assert.deepEqual(parsed.map(r => r.name), old.map(r => r.name));
    parsed.forEach((r, i) => {if (r.name !== input) assert.deepEqual(r, old[i]);});
    const run = (n, s) => start(compiled.get(n), s, compiled);
    for (const barricade of [false, true]) {
        const s = scenario(barricade ? 7 : 1);
        Object.assign(s.player, {enhancementId:11, team:1, alive:true, hero:s.hero});
        const bot = {id:'zombie', team:2, dummy:true, alive:true, exists:true, health:100, maxHealth:1000, status:new Set(), position:[0,0,2]};
        s.targets = [bot]; s.raycastTarget = bot; s.buttons.add('Interact');
        const pickup = run(input, s);
        if (barricade) {s.buttons.delete('Interact'); pickup.resume();}
        assert(pickup.done());
        assert.equal(s.player[slot('enhancementHeldZombie')], bot);
        s.time = 101; s.buttons.add('Interact');
        const throwing = run(input, s);
        assert(!throwing.done());
        assert.equal(s.player[slot('enhancementHoldUntil')], 0);
        const bs = {...s, player:bot, expectedDamager:s.player, targets:[s.player], status:bot.status, dummy:true, hero:'Ana'};
        const release = run('LIVING PROJECTILE RELEASE', bs);
        assert.equal(s.player[slot('enhancementHeldZombie')], 0);
        let delayStart = 101;
        if (barricade) {
            s.time = 101.1; s.buttons.delete('Interact'); throwing.resume(); delayStart = 101.1;
            assert.equal(s.player[slot('augmentBarrierPlacementCooldown')], 0);
        }
        const queries = s.raycastCalls;
        s.time = delayStart + 0.499; s.buttons.delete('Interact'); throwing.resume();
        assert(!throwing.done(), 'Button release cannot abort the delay');
        s.buttons.add('Interact'); throwing.resume(); assert(!throwing.done());
        s.time = delayStart + 0.5; throwing.resume(); assert(throwing.done());
        assert.equal(s.raycastCalls, queries, 'No fallthrough to item/pickup queries');
        assert.equal(s.player[slot('enhancementHoldUntil')], 0, 'No cooldown timestamp');
        const next = run(input, s);
        assert.equal(s.player[slot('enhancementHeldZombie')], bot, 'A fresh press after the wait may grab again');
        if (barricade) {s.buttons.delete('Interact'); next.resume();}
        assert(next.done());
        bs.time = 101.75; release.resume(); assert.equal(bs.damage.at(-1).amount, 50);
    }
    if (process.argv.includes('--write')) {
        const root = path.dirname(src);
        const exported = await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'), 'en-US', root.replace(/\\/g,'/')+'/', 'main.opy');
        assert.deepEqual(exported.encounteredWarnings, []); assert.deepEqual(rules(exported.result), parsed);
        fs.writeFileSync(path.join(root,'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({before:before.elements, after:build.elements, delta:build.elements-before.elements, normalAndBarricadePassed:true, warnings:build.warnings}));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
