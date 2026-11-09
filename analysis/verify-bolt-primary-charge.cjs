// Execute the combined damage handler: direct-hit credit must not depend on chains.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {scenario, start} = require('./verify-augments.cjs');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const energy = slot('enhancementBoltEnergy');
const enemy = id => ({id, team: 2, alive: true, visible: true, hero: 'Ana',
    position: [0, 0, 0], health: 1000, status: new Set()});
async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const compiled = new Map(rules(build.result).map(r => [r.name, r]));
    const hit = s => start(compiled.get('PLAYER DEALT DAMAGE'), s, compiled);
    const setup = () => {
        const s = scenario(1, {eventAbility: 'Primary Fire', eventDamage: 100});
        Object.assign(s.player, {enhancementId: 12, [energy]: 0});
        s.victim = enemy('primary'); s.targets = [s.victim];
        return s;
    };
    const solo = setup();
    hit(solo); assert.equal(solo.player[energy], 0.3);
    hit(solo); assert.equal(solo.player[energy], 0.6, 'Each damaging primary hit grants 0.3 without nearby enemies');
    for (const amount of [1, 100, 1000]) {
        const s = setup(); s.eventDamage = amount;
        s.targets.push(enemy('chain1'), enemy('chain2'));
        hit(s);
        assert.equal(s.player[energy], 0.3 + 2 * Math.min(15, amount * 0.25));
    }
    const immune = setup();
    immune.targets.push({...enemy('immune'), invincible: true});
    hit(immune); assert.equal(immune.player[energy], 0.3, 'Immune chain targets do not prevent primary credit');
    for (const bank of [349, 349.75, 350]) {
        const s = setup(); s.player[energy] = bank; hit(s);
        assert.equal(s.player[energy], Math.min(350, bank + 0.3));
    }
    for (const reject of ['scripted', 'zero', 'friendly', 'game end', 'other enhancement']) {
        const s = setup();
        if (reject === 'scripted') s.eventAbility = 0;
        if (reject === 'zero') s.eventDamage = 0;
        if (reject === 'friendly') s.victim.team = 1;
        if (reject === 'game end') s.globals.isGameplayActive = false;
        if (reject === 'other enhancement') s.player.enhancementId = 0;
        hit(s); assert.equal(s.player[energy], 0, reject);
    }
    const armed = setup(); armed.allowArrayDamage = true;
    armed.player[slot('enhancementBoltBurst')] = -1;
    hit(armed);
    assert.equal(armed.player[energy], 0.3, 'The triggering hit charges, discharge damage does not');
    assert.equal(armed.player[slot('enhancementBoltBurst')], 0);
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings,
        checked: '0.3 per primary hit; no chains; additive chain health loss; immune chains; cap; rejected hits; armed discharge'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
