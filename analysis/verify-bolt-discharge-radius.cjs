// Execute the current combined damage handler at the discharge radius boundary.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start} = require('./verify-augments.cjs');

async function main() {
    await compiler.readyPromise;
    const before = await compile({...files, 'player_events.opy': execFileSync('git', ['show', 'HEAD:src/player_events.opy'], {encoding: 'utf8'}).replace(/\r\n/g, '\n')});
    const after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const oldDamage = oldRules.find(r => r.name === 'PLAYER DEALT DAMAGE');
    const damage = newRules.find(r => r.name === 'PLAYER DEALT DAMAGE');
    assert.deepEqual(newRules.map(r => r.name), oldRules.map(r => r.name));
    for (let i = 0; i < newRules.length; i++) {
        if (newRules[i].name !== damage.name) assert.deepEqual(newRules[i], oldRules[i]);
    }
    assert.equal(damage.body, oldDamage.body.replace('Players Within Radius(Victim, 5,', 'Players Within Radius(Victim, 10,'));
    const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
    const enemy = (id, x, extra = {}) => ({id, team: 2, position: [x, 0, 0], health: 1000, alive: true, visible: true, status: new Set(), ...extra});
    const s = scenario(1, {eventDamage: 100, eventAbility: 'Primary Fire'});
    Object.assign(s.player, {enhancementId: 12, team: 1, [slot('enhancementBoltEnergy')]: 0, [slot('enhancementBoltBurst')]: -1});
    s.allowArrayDamage = true;
    s.expectedDamager = s.player;
    s.victim = enemy('victim', 20);
    s.targets = [s.victim, enemy('near', 26), enemy('edge', 30), enemy('outside', 30.001), enemy('hidden', 26, {visible: false}), enemy('dead', 26, {alive: false}), enemy('ally', 26, {team: 1})];
    assert(start(damage, s, new Map(newRules.map(r => [r.name, r]))).done());
    assert.deepEqual(s.damage.at(-1).targets.map(t => t.id), ['victim', 'near', 'edge']);
    assert.equal(s.damage.at(-1).amount, 60);
    assert.deepEqual(s.statusWrites.map(w => [w.target, w.status, w.duration]), [['victim', 'Stunned', 2], ['near', 'Stunned', 2], ['edge', 'Stunned', 2]]);
    assert.equal(s.player[slot('enhancementBoltBurst')], 0);
    if (process.argv.includes('--write')) {
        const root = path.dirname(src);
        const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        assert.deepEqual(exported.encounteredWarnings, []);
        assert.deepEqual(rules(exported.result), newRules);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({before: before.elements, after: after.elements, delta: after.elements - before.elements, radius: 10, boundaryAndFiltersPassed: true, warnings: after.warnings}));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
