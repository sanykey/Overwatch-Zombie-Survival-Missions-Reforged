// Verify the ground item type ID is read once and consumed only by synchronous initial visual parameters.
// On success, rebuild src/main.ws.txt and save ground-powerup-id-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop, args} = require('./verify-global-temporaries.cjs');
const baselineRef = '4d2cbc6';
const file = 'power_ups.opy';
const ruleName = 'POWER UP EFFECT/TEXT MANAGEMENT';
const sourceExpression = 'supplyPowerUpIdList[len(supplyPowerUpEffectIdList)]';
const expression = 'Value In Array(Global.supplyPowerUpIdList, Count Of(Global.supplyPowerUpEffectIdList))';
const snapshot = `Set Global Variable(tmp0, ${expression});`;

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing ground visual actions');
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

async function main() {
    const source = files[file];
    const assignment = `    groundPowerUpItemId = ${sourceExpression}\n`;
    assert(source.includes('#!define groundPowerUpItemId tmp0'));
    assert.equal(source.split(assignment).length - 1, 1);
    const baseline = {...files, [file]: source.replace(/^ *#!define groundPowerUpItemId tmp0\n/m, '')
        .replace(assignment, '').replaceAll('groundPowerUpItemId', sourceExpression)};
    const historicalBaseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files), historical = await compile(historicalBaseline);
    for (const result of [before, after, historical]) assert.deepEqual(result.warnings, []);
    assert.equal(before.elements - after.elements, 10);
    const original = rules(before.result), current = rules(after.result);
    assert.deepEqual(original.find(r => r.name === ruleName), rules(historical.result).find(r => r.name === ruleName),
        'Reconstructed ground visual rule must retain its original implementation');
    assert.equal(current.length, original.length);
    let changedRule;
    for (let i = 0; i < current.length; i++) {
        assert.equal(current[i].name, original[i].name);
        if (current[i].name !== ruleName) {assert.deepEqual(current[i], original[i]); continue;}
        assert(!/Global\.tmp0\b/.test(original[i].body), 'Original visual rule has another scratch owner');
        assert.equal(current[i].body.split(snapshot).length - 1, 1);
        assert.equal((current[i].body.match(/Global\.tmp0\b/g) || []).length, 4);
        const restored = current[i].body.split('\n').filter(a => a !== snapshot).join('\n')
            .replaceAll('Global.tmp0', expression);
        assert.equal(restored, original[i].body, 'Item range, names/colors, positions, reevaluation or handle registration changed');
        changedRule = current[i];
    }
    assert(changedRule);
    const body = actions(changedRule);
    assert.equal(body[0], snapshot, 'Refresh the item ID at the start of every rule pass');
    assert(!body.some(a => /^(?:Wait(?: Until)?\(|Call Subroutine\(|Start Rule\()/.test(a)),
        'Ground visual creation must remain synchronous');
    const effectIndex = body.findIndex(a => a.startsWith('Create Effect('));
    assert(effectIndex > 0 && body[effectIndex + 1].startsWith('Create In-World Text('));
    const effect = args(body[effectIndex]), text = args(body[effectIndex + 1]);
    assert.equal(effect[0], 'All Players(All Teams)');
    assert.equal(text[0], 'All Players(All Teams)');
    assert.equal(effect[5], 'Visible To');
    assert.equal(text[5], 'Visible To');
    assert.equal(effect[3], 'Value In Array(Global.supplyPowerUpPositionList, Count Of(Global.supplyPowerUpEffectIdList))');
    assert.equal(text[2], 'Value In Array(Global.supplyPowerUpPositionList, Count Of(Global.supplyPowerUpTextIdList))');
    const scratch = checkWorkshop(after.result);
    for (const boundary of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);'])
        assert.throws(() => checkWorkshop(after.result.replace(snapshot, snapshot + '\n        ' + boundary)),
            e => /live across/.test(e.message) && /tmp0/.test(e.message));
    const liveColor = [...effect]; liveColor[5] = 'Visible To and Color';
    assert.throws(() => checkWorkshop(after.result.replace(body[effectIndex], `Create Effect(${liveColor.join(', ')});`)),
        /scratch escapes into reevaluated Color/);
    const liveString = [...text]; liveString[5] = 'Visible To and String';
    assert.throws(() => checkWorkshop(after.result.replace(body[effectIndex + 1], `Create In-World Text(${liveString.join(', ')});`)),
        /scratch escapes into reevaluated String/);

    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), current);
    for (const [name, value] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), value, 'Concurrent source edit');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselinePowerUpsRef: baselineRef,
        baselineMethod: 'Reverse only the item ID snapshot in current sources; also compare the uncached management rule with its historical implementation.',
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        compiledRulesCompared: original.length, cachedReads: 4, snapshotRefreshedEachPass: true,
        synchronousCreationChecked: true, initialColorsAndNamesPreserved: true, onlyVisibilityReevaluated: true,
        separatePositionIndicesPreserved: true, createdHandleRegistrationUnchanged: true,
        scratchRulesChecked: scratch.length, negativeAuditCases: 4, directIncludeBuildChecked: true,
        emittedWarnings: [], warningsSuppressedByMainSource: true, inGameValidated: false, runtimeBenchmarked: false,
        powerUpsSha256: crypto.createHash('sha256').update(source).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'ground-powerup-id-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
