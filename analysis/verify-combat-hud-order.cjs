// Inspect emitted HUD sort values, and prove only their ordering changed.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args} = require('./verify-global-temporaries.cjs');

async function main() {
    await compiler.readyPromise;
    const current = await compile(files);
    assert.deepEqual(current.warnings, []);
    const parsed = rules(current.result);
    const rows = rule => [...rule.body.matchAll(/Create HUD Text\((.*)\);/g)].map(m => args(m[0]));
    const initialization = parsed.find(r => r.name === 'PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION');
    const personal = rows(initialization);
    assert.equal(personal.length, 16);
    // All enhancement cards, including both attachment statuses, precede augments.
    assert(personal.slice(0, -2).every(row => row[4] === 'Left' && row[5] === '97'));
    assert(personal.slice(-2).every(row => row[4] === 'Left' && row[5] === '98'));
    const fuel = rows(parsed.find(r => r.name === 'JETPACK FUEL HUD'));
    assert.equal(fuel.length, 1);
    assert.equal(fuel[0][4], 'Left');
    assert.equal(fuel[0][5], '99');
    const items = rows(parsed.find(r => r.name === 'EFFECT/TEXT (PERMANENT)'));
    assert(items.length > 0);
    assert(items.every(row => row[4] === 'Left' && row[5] === '100'));
    const roster = parsed.flatMap(rows).filter(row => row[5] === 'Slot Of(Event Player)');
    assert.equal(roster.length, 1);
    assert.equal(roster[0][4], 'Left');
    // Player slots are below 97. Distinct category values make creation order irrelevant.

    const before = structuredClone(files);
    const [enhancements, augments] = before['player_initialization.opy'].split('macro initializePlayerAugment():');
    before['player_initialization.opy'] = enhancements
        .replaceAll('HudPosition.ACTUALLY_LEFT, 97,', 'HudPosition.ACTUALLY_LEFT, 99,')
        // The two attachment status rows originally shared sort 100 with augments.
        .replace(/(hudSubheader\([^\n]*HudPosition.ACTUALLY_LEFT, )99,/g, (_, prefix) => prefix + '100,')
        + 'macro initializePlayerAugment():'
        + augments.replaceAll('HudPosition.ACTUALLY_LEFT, 98,', 'HudPosition.ACTUALLY_LEFT, 100,');
    const baseline = await compile(before);
    assert.deepEqual(baseline.warnings, []);
    const withoutHud = result => rules(result).map(rule => ({...rule,
        body: rule.body.split('\n').filter(line => !line.startsWith('Create HUD Text(')).join('\n')}));
    assert.deepEqual(withoutHud(current.result), withoutHud(baseline.result));
    assert.equal(current.elements, baseline.elements);
    // Preserve every HUD parameter except the intended personal-card sort values.
    const oldPersonal = rows(rules(baseline.result).find(r => r.name === initialization.name));
    for (let i = 0; i < personal.length; i++) {
        const restored = [...personal[i]];
        restored[5] = oldPersonal[i][5];
        assert.deepEqual(restored, oldPersonal[i]);
    }
    console.log(JSON.stringify({elements: current.elements, elementDelta: 0,
        personalHudRows: personal.length, order: ['roster', 'enhancement', 'augment', 'jetpack fuel', 'powerup'],
        warnings: 0, nativeRenderingVerified: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
