// Compile and inspect Jetpack's resource, flight and cleanup contracts.
// --write regenerates the importable export; --baseline-ref <ref> also checks
// unrelated rules and measures the replacement against a pre-Jetpack revision.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
// This module also accepts --baseline-ref; keep it local to this verifier.
const refIndex = process.argv.indexOf('--baseline-ref');
const ref = refIndex < 0 ? null : process.argv.splice(refIndex, 2)[1];
assert(refIndex < 0 || ref, '--baseline-ref needs a revision');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

async function main() {
    await compiler.readyPromise;
    const current = await compile(files);
    assert.deepEqual(current.warnings, []);
    assert(!/bounce.?pad/i.test(Object.values(files).join('\n')));
    const parsed = rules(current.result);
    const body = name => {
        const matches = parsed.filter(r => r.name === name);
        assert.equal(matches.length, 1, name);
        return matches[0].body;
    };
    const flight = body('JETPACK FLIGHT');
    const hud = body('JETPACK FUEL HUD');
    assert.match(flight, /Ongoing - Each Player;\nTeam 1;\nAll;/);
    // Check the actual compiled numeric comparisons, including zero/Null.
    for (const condition of [
        'Global.isGameplayActive == True', 'Is Alive(Event Player) == True',
        'Is Button Held(Event Player, Button(Jump)) == True',
        '(Event Player).actorTeamSlot17 > Null'
    ]) assert(flight.includes(condition), condition);
    assert(!/Altitude Of|Is On Ground|Is In Air/.test(flight));
    assert.match(flight, /actions \{\nWait\(0\.2(?:08)?, Abort When False\);\nSet Player Variable\(Event Player, powerUpJetpackIsFlying, True\);/);
    assert.match(flight, /Start Accelerating\(Event Player, Up, 10, 4, To World/);
    assert.match(flight, /Chase Player Variable At Rate\(Event Player, actorTeamSlot17, False, 40,/);
    // Every start predicate must also stop flight; this prevents stuck gravity,
    // acceleration or resource drain after release, death or game end.
    const stop = flight.match(/Wait Until\((.*), 999999999999\);/)[1];
    for (const predicate of ['Global.isGameplayActive', 'Is Alive(Event Player)',
        'Button(Jump)', 'actorTeamSlot17']) {
        assert(stop.includes(predicate), `Missing stop predicate: ${predicate}`);
    }
    assert(stop.startsWith('Not('));
    assert.match(flight, /Stop Chasing Player Variable\(Event Player, actorTeamSlot17\);\nStop Accelerating\(Event Player\);\nSet Gravity\(Event Player, 100\);\nSet Player Variable\(Event Player, powerUpJetpackIsFlying, False\);\nCall Subroutine\(applyScaledMoveSpeed\);\nDestroy Effect/);
    assert.equal((flight.match(/Create Effect\(/g) || []).length, 1);
    assert.match(flight, /Bad Aura, Color\(Purple\)/);
    assert(!/Create Beam|MOIRA|Chase Player Variable At Rate[^\n]*, 100,/.test(flight));
    assert.match(hud, /Create HUD Text\([^\n]*, Null, Custom String\("jetpack fuel: \{0\}[^"\n]*", Round To Integer\(\(Event Player\).actorTeamSlot17, Up\)/);
    assert.match(hud, /Left, 99, Null, Color\(White\)/);
    assert.match(hud, /Visible To and String/);
    assert.match(hud, /Wait Until\(Compare\(\(Event Player\).actorTeamSlot17, <=, Null\)/);
    assert.match(hud, /Destroy HUD Text\(Value In Array\(\(Event Player\).actorTeamSlot4, 81\)\)/);
    assert.match(body('powerUpUsage'), /Set Player Variable\(Event Player, actorTeamSlot17, Min\(200, Add\(\(Event Player\).actorTeamSlot17, 100\)\)\);/);
    assert.match(body('powerUpUsage'), /If\(Compare\(\(Event Player\).actorTeamSlot17, >=, 200\)\);\nSmall Message\(Event Player, Custom String\("Jetpack fuel is full"\)\);\nAbort;/);
    assert.match(body('applyScaledMoveSpeed'), /Add\(Multiply\(\(Event Player\).movementSpeedScale, 100\), Multiply\(30, \(Event Player\).powerUpJetpackIsFlying\)\)/);
    assert.equal(files['variables.opy'].match(/globalvar powerUpColorListConst = \[([^\]]+)\]/)[1].split(', ')[10], 'Color.PURPLE');

    let comparison = {};
    if (ref) {
        const beforeFiles = Object.fromEntries(Object.keys(files).map(name => [name,
            execFileSync('git', ['show', `${ref}:src/${name === 'main.opy' ? 'includes.opy' : name}`],
                {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
        const before = await compile(beforeFiles);
        assert.deepEqual(before.warnings, []);
        const changed = new Set(['bouncePad (80-89)', 'JETPACK FUEL HUD', 'JETPACK FLIGHT',
            'powerUpUsage', 'applyScaledMoveSpeed', 'POWER UP EFFECT/TEXT MANAGEMENT', 'EFFECT/TEXT (PERMANENT)']);
        assert.deepEqual(parsed.filter(r => !changed.has(r.name)),
            rules(before.result).filter(r => !changed.has(r.name)));
        const vars = source => (source.match(/^playervar /gm) || []).length;
        assert.equal(vars(files['variables.opy']), vars(beforeFiles['variables.opy']));
        comparison = {before: before.elements, delta: current.elements - before.elements,
            unchangedRules: parsed.filter(r => !changed.has(r.name)).length};
    }
    const log = console.log;
    let build;
    try {
        console.log = () => {};
        build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, current.elements);
    assert.deepEqual(rules(build.result), parsed);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    console.log(JSON.stringify({...comparison, elements: current.elements, warnings: 0,
        nativeGameplayVerified: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
