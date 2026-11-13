// Inspect emitted combat HUD ordering and preserve all other compiled behavior.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args} = require('./verify-global-temporaries.cjs');
async function main() {
    await compiler.readyPromise;
    const current = await compile(files);
    assert.deepEqual(current.warnings, []);
    const parsed = rules(current.result);
    const rows = rule => [...rule.body.matchAll(/Create HUD Text\((.*)\);/g)].map(m => args(m[0]));
    const personal = rows(parsed.find(r => r.name === 'ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)'));
    assert.equal(personal.length, 5);
    assert.deepEqual(personal.map(row => Number(row[5])), [97, 98, 99, 98.5, 98.5]);
    assert(personal.every(row => row[4] === 'Left'));
    assert(personal[3][2].includes('Attached to'));
    assert(personal[4][2].includes('is attached'));
    const items = rows(parsed.find(r => r.name === 'EFFECT/TEXT (PERMANENT)'));
    assert(items.length > 0);
    assert(items.every(row => row[4] === 'Left' && row[5] === '100'));
    const roster = parsed.flatMap(rows).filter(row => row[5] === 'Slot Of(Event Player)');
    assert.equal(roster.length, 1);
    assert.equal(roster[0][4], 'Left');
    const before = {...files};
    before['player_initialization.opy'] = before['player_initialization.opy']
        .replaceAll('HudPosition.ACTUALLY_LEFT, 98.5,', 'HudPosition.ACTUALLY_LEFT, 97,');
    const baseline = await compile(before);
    assert.deepEqual(baseline.warnings, []);
    // Only the two attachment sort arguments may change.
    assert.equal(current.result.replace(/, Left, 98\.5(?:0)*,/g, ', Left, 97,'), baseline.result);
    assert.equal(current.elements, baseline.elements);
    if (process.argv.includes('--write')) {
        const build = await compiler.compile(fs.readFileSync('main.opy', 'utf8'),
            'en-US', process.cwd().replace(/\\/g, '/') + '/', 'main.opy');
        assert.deepEqual(build.encounteredWarnings, []);
        assert.equal(build.nbElements, current.elements);
        assert.deepEqual(rules(build.result), parsed);
        fs.writeFileSync('main.ws.txt', build.result);
    }
    console.log(JSON.stringify({elements: current.elements, elementDelta: 0,
        personalHudRows: personal.length,
        order: ['roster', 'enhancement', 'augment', 'attachment status', 'jetpack fuel', 'powerup'],
        warnings: 0, nativeRenderingVerified: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
