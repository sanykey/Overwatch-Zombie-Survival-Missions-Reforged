// Compile both revisions, verify unrelated rules and native include output.
// --write regenerates main.ws.txt. No game-runtime claims are made here.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');
const baselineRef = 'e6f89b6d6ef3070b9071e171cb253a9917cef0b3';

async function main() {
    await compiler.readyPromise;
    const baselineFiles = Object.fromEntries(Object.keys(files).map(name => [name,
        execFileSync('git', ['show', `${baselineRef}:src/${name === 'main.opy' ? 'includes.opy' : name}`], {cwd: root})
            .toString('utf8').replace(/\r\n/g, '\n')]));
    const before = await compile(baselineFiles);
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const additions = new Set(['WRESTLER PULL', 'WRESTLER PULL DISCONNECT CLEANUP']);
    const actualChanges = [];
    for (let i = 0; i < oldRules.length; i++) {
        const old = oldRules[i];
        const next = newRules.filter(r => r.name === old.name);
        // Duplicate names retain their original order.
        const ordinal = oldRules.slice(0, i).filter(r => r.name === old.name).length;
        assert(next[ordinal], `Missing rule ${old.name}`);
        if (next[ordinal].body !== old.body) actualChanges.push(old.name);
    }
    // Only menu text and enhancement HUD may change among existing rules.
    assert.equal(actualChanges.length, 2, JSON.stringify(actualChanges));
    assert(actualChanges.includes('ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)'));
    assert(actualChanges.includes('EFFECTS/TEXTS'));
    assert.equal(newRules.length, oldRules.length + additions.size);
    for (const r of newRules) assert(oldRules.some(old => old.name === r.name) || additions.has(r.name));
    const pull = newRules.find(r => r.name === 'WRESTLER PULL').body;
    fs.writeFileSync(path.join(__dirname, '2026-11-15-wrestler-pull-rule.ws.txt'), pull + '\n');
    assert(pull.includes('Wait(0.25, Abort When False);'));
    assert(pull.includes('Wait(0.2, Ignore Condition);'));
    assert(pull.includes('Bad Beam'));
    assert(pull.includes('Color(Purple)'));
    assert(pull.includes('None);'));
    // OverPy packs numeric 1 as True in this numeric-duration argument.
    assert(pull.includes('Knocked Down, True);'));
    assert(pull.includes('Total Time Elapsed, 16'));
    assert(pull.includes('Cancel Contrary Motion'));
    assert(pull.includes('Is Dummy Bot'));
    assert(pull.includes('Is In Line of Sight'));
    assert(pull.includes('<=, 25)'));
    assert(pull.includes('0.5), 35)'));
    assert(pull.includes('Surfaces)'));
    assert(!/Chase|Loop|augmentGrapnelTarget|augmentMovementReadyAt/.test(pull));
    const create = pull.indexOf('Create Beam Effect('), impulse = pull.indexOf('Apply Impulse(');
    const wait = pull.indexOf('Wait(0.2, Ignore Condition);');
    assert(create > 0 && impulse > create && wait > impulse);
    assert(!pull.slice(wait).includes('Global.tmp0'), 'Scratch must die before wait');
    assert(!pull.slice(create, impulse).includes('Position and Radius'), 'Beam must snapshot scratch');
    assert(pull.indexOf('Compare(Global.tmp0, ==, Null)') < pull.indexOf('Total Time Elapsed, 16'), 'Miss must not spend cooldown');
    const disconnect = newRules.find(r => r.name === 'WRESTLER PULL DISCONNECT CLEANUP').body;
    assert(disconnect.includes('Player Left Match;'));
    assert(disconnect.includes('Destroy Effect((Event Player).actorTeamSlot24);'));
    const vars = source => [...source.matchAll(/^(?:player|global)var (\w+)/gm)].map(m => m[1]);
    assert.deepEqual(vars(files['variables.opy']), vars(baselineFiles['variables.opy']));
    assert(vars(files['variables.opy']).every(name => name.length <= 31));
    let build;
    const log = console.log;
    try {
        console.log = () => {};
        build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, after.elements);
    assert.deepEqual(rules(build.result), newRules);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    const ruleCosts = [...after.result.matchAll(/^\/\/(\d+) elements\nrule \("([^"\n]+)"\)/gm)]
        .filter(m => additions.has(m[2])).map(m => ({name: m[2], elements: +m[1]}));
    const report = {baselineRef, beforeElements: before.elements, afterElements: after.elements,
        addedElements: after.elements - before.elements, ruleCosts, changedExistingRules: actualChanges,
        unchangedRules: oldRules.length - actualChanges.length, newVariableSlots: 0,
        warnings: after.warnings, nativeIncludesMatch: true,
        runtimeValidation: 'Not run; verify aim/LOS/range boundaries, boss knockback, cooldown/hold, cleanup, and Augment coexistence in Overwatch.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-wrestler-pull-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
