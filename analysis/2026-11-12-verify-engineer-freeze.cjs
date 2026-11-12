// Compile the working tree and compare with the same sources without turret freeze.
// Run with --write to regenerate main.ws.txt from the real root entry point.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');
const turretName = 'sentryTurret (50-59)';

async function main() {
    await compiler.readyPromise;
    const without = {...files};
    const shot = files['supply_drops.opy'].match(/            # The impact position[\s\S]*?            damage\(turretShotVictim, eventPlayer, 20\)/)[0];
    const ray = shot.match(/turretShotVictim = (raycastHitPlayer\([^\n]+\))/)[1];
    without['supply_drops.opy'] = without['supply_drops.opy'].replace(shot,
        `            damage(${ray}, eventPlayer, 20)`);
    const baseline = await compile(without);
    const current = await compile(files);
    assert.deepEqual(baseline.warnings, []);
    assert.deepEqual(current.warnings, []);
    const before = rules(baseline.result), after = rules(current.result);
    // The menu no longer mentions the freeze, so stripping the freeze block may
    // only change the turret rule.
    const changed = before.filter((r, i) => r.body !== after[i].body);
    assert.equal(changed.length, 1, 'Only the turret rule may change');
    assert.equal(changed[0].name, turretName);
    const body = after.find(r => r.name === turretName).body;
    const hit = body.match(/^Set Global Variable\(tmp0, (Ray Cast Hit Player\([^\n]+\))\);$/m)[1];
    const added = body.match(/^Set Global Variable\(tmp0, Ray Cast Hit Player[^\n]+\n[\s\S]*?Damage\(Global.tmp0, Event Player, 20\);/m)[0];
    assert.equal(body.replace(added, `Damage(${hit}, Event Player, 20);`),
        before.find(r => r.name === turretName).body,
        'Targeting, raycast, spread, damage, duration, visuals and cleanup stay identical');
    assert.match(added, /If\(And\(Compare\(\(Event Player\).enhancementId, ==, 13\), Compare\(Random Integer\(False, 20\), ==, Null\)\)\);/);
    assert.match(added, /Set Status\(Global.tmp0, Event Player, Frozen, 2\);\nPlay Effect\(All Players\(All Teams\), Ring Explosion, Color\(White\), Add\(\(Event Player\).actorTeamSlot13, Down\), 4\);\nPlay Effect\(All Players\(All Teams\), Buff Impact Sound, Color\(White\), \(Event Player\).actorTeamSlot13, 50\);\nEnd;\nDamage/);
    assert(!/Wait|Call Subroutine|Start Rule/.test(added), 'Scratch must finish before yielding or calls');
    const variables = s => s.match(/^variables \{[\s\S]*?^\}/m)[0];
    assert.equal(variables(current.result), variables(baseline.result));
    assert.match(files['enhancements.opy'], /eventPlayer.enhancementScrap -= ENGINEER_TURRET_COST\n    startRule\(sentryTurret\)/);
    assert.match(files['supply_drops.opy'], /#Sentry Turret\n[\s\S]*?startRule\(sentryTurret\)/);
    const donor = fs.readFileSync(path.join(root, 'workshop-snapshots/ZSMM-remixed (QZD5F)/2026-10-30 ZSMM-remixed (QZD5F).opy'), 'utf8');
    assert.match(donor, /tempWinter2 = random.randint\(0, 20\)/);
    assert.match(donor, /if not eventPlayer.tempWinter2:\s+eventPlayer.tempWinter.setStatusEffect\(eventPlayer, Status.FROZEN, 2\)/);
    // Compare with repeating the raycast in freeze and damage instead of caching it.
    const repeated = {...files};
    repeated['supply_drops.opy'] = repeated['supply_drops.opy']
        .replace(`            turretShotVictim = ${ray}\n`, '')
        .replace('turretShotVictim.setStatusEffect', `${ray}.setStatusEffect`)
        .replace('damage(turretShotVictim,', `damage(${ray},`);
    const repeatedBuild = await compile(repeated);
    assert.deepEqual(repeatedBuild.warnings, []);
    let build;
    const log = console.log;
    try {
        console.log = () => {};
        build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, current.elements);
    assert.deepEqual(rules(build.result), after);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    const report = {before: baseline.elements, after: current.elements,
        added: current.elements - baseline.elements,
        savedVsRepeatedRaycast: repeatedBuild.elements - current.elements,
        addedVariables: 0, warnings: 0, nativeGameplayVerified: false};
    fs.writeFileSync(path.join(__dirname, '2026-11-12-engineer-freeze-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}
main().catch(e => {console.error(e); process.exitCode = 1;});
