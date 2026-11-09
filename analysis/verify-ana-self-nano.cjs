// Compile the real entry point, verify the added rule and compare existing rules
// with a build without self Nano. Run with --write to regenerate main.ws.txt.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');
const name = 'ANA SELF SUPER NANO';

async function main() {
    await compiler.readyPromise;
    const without = structuredClone(files);
    without['hero_tuning.opy'] = without['hero_tuning.opy'].replace(
        /rule "ANA SELF SUPER NANO":[\s\S]*?(?=\nrule )/, '');
    assert.notEqual(without['hero_tuning.opy'], files['hero_tuning.opy']);
    const baseline = await compile(without);
    const current = await compile(files);
    assert.deepEqual(baseline.warnings, []);
    assert.deepEqual(current.warnings, []);
    const parsed = rules(current.result);
    assert.deepEqual(parsed.filter(r => r.name !== name), rules(baseline.result),
        'Existing rule events, conditions and actions must stay unchanged');
    const added = parsed.filter(r => r.name === name);
    assert.equal(added.length, 1);
    const body = added[0].body;
    assert.match(body, /Ongoing - Each Player;\nTeam 1;\nAna;/);
    assert.match(body, /Is Button Held\(Event Player, Button\(Ultimate\)\) == True/);
    assert.match(body, /Ultimate Charge Percent\(Event Player\) >= 100/);
    assert.match(body, /Wait\(0\.128, Ignore Condition\)/);
    for (const status of ['Hacked', 'Stunned', 'Asleep', 'Frozen', 'Knocked Down']) {
        assert(body.includes(`Has Status(Event Player, ${status})`));
    }
    assert.match(body, /Players Within Radius\(Event Player, 41, Team 1, Surfaces\)/);
    assert.match(body, /Is In View Angle\(Event Player, Current Array Element, 10\)/);
    assert.match(body, /Set Ultimate Charge\(Event Player, (?:False|0)\);\nSet Ultimate Ability Enabled\(Event Player, False\);\nStart Rule\(superNano, Restart Rule\);/);
    assert.match(body, /Start Rule\(superNano, Restart Rule\);\nWait\((?:False|0|0\.016), Ignore Condition\);\nWait Until\(Or\(Is Dead\(Event Player\), Compare\([^\n]*powerUpSuperNanoGoodAuraId, ==, (?:0|Null)\)\), 20\);\nSet Ultimate Ability Enabled\(Event Player, True\);/);
    assert(!/powerUpItemId|Create Dummy|Loop\(/.test(body));
    const variables = text => text.match(/^variables \{[\s\S]*?^\}/m)[0];
    assert.equal(variables(current.result), variables(baseline.result));

    // Preserve source paths in the export by compiling from the root entry point.
    let build;
    const log = console.log;
    try {
        console.log = () => {};
        build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, current.elements);
    assert.deepEqual(rules(build.result), parsed);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    console.log(JSON.stringify({before: baseline.elements, after: current.elements,
        added: current.elements - baseline.elements, unchangedRules: parsed.length - 1,
        warnings: 0, nativeGameplayVerified: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
