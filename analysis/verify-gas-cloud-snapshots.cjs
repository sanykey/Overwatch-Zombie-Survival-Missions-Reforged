// Verify per-cloud snapshots use the updated radius and never survive a yield.
// On success, rebuild src/main.ws.txt and save gas-cloud-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = 'dabbeda';
const ruleName = 'BEHEMOTH GAS STREAM (BOSS)';
const file = 'zombie_types.opy';
const positionField = files['variables.opy'].match(/^#!define botGasPositionList (\w+)/m)[1];
const radiusField = files['variables.opy'].match(/^#!define botGasRadiusList (\w+)/m)[1];
const positionExpression = `Value In Array((Event Player).${positionField}, Global.tmp0)`;
const radiusExpression = `Value In Array((Event Player).${radiusField}, Global.tmp0)`;
const positionSnapshot = `Set Global Variable(tmp1, ${positionExpression});`;
const radiusSnapshot = `Set Global Variable(tmp2, ${radiusExpression});`;
const radiusGrowth = `Modify Player Variable At Index(Event Player, ${radiusField}, Global.tmp0, Add, Multiply(0.2, (Event Player).sizeScale));`;

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing gas-cloud actions');
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditOrder(body) {
    for (const action of [positionSnapshot, radiusSnapshot, radiusGrowth])
        assert.equal(body.filter(a => a === action).length, 1, 'Unexpected gas snapshot/growth count');
    const loop = body.findIndex(a => a.startsWith('For Global Variable(tmp0,'));
    const growth = body.indexOf(radiusGrowth);
    const position = body.indexOf(positionSnapshot), radius = body.indexOf(radiusSnapshot);
    assert(loop >= 0 && growth > loop);
    assert.equal(position, growth + 1, 'Snapshots must follow radius growth inside the cloud loop');
    assert.equal(radius, position + 1, 'Read radius after its growth, alongside the current position');
    assert(body[radius + 1].includes('Filtered Array(Global.playerTargetList,') &&
        body[radius + 1].includes('Global.tmp1') && body[radius + 1].includes('Global.tmp2'),
        'Consume both snapshots immediately in the current cloud target filter');
}

async function main() {
    const baseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    assert(files[file].includes('#!define behemothGasCloudPosition tmp1'));
    assert(files[file].includes('#!define behemothGasCloudRadius tmp2'));
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements - after.elements, 8);
    const original = rules(before.result), current = rules(after.result);
    assert.equal(current.length, original.length);
    let changedRule;
    for (let i = 0; i < current.length; i++) {
        assert.equal(current[i].name, original[i].name);
        if (current[i].name !== ruleName) {assert.deepEqual(current[i], original[i]); continue;}
        assert(!/Global\.tmp[12]\b/.test(original[i].body), 'Unrelated scratch owners in original gas rule');
        assert.equal((current[i].body.match(/Global\.tmp1\b/g) || []).length, 3);
        assert.equal((current[i].body.match(/Global\.tmp2\b/g) || []).length, 2);
        auditOrder(actions(current[i]));
        const restored = current[i].body.split('\n')
            .filter(line => line !== positionSnapshot && line !== radiusSnapshot).join('\n')
            .replaceAll('Global.tmp1', positionExpression).replaceAll('Global.tmp2', radiusExpression);
        assert.equal(restored, original[i].body, 'Growth, targeting, damage or timing changed');
        changedRule = current[i];
    }
    assert(changedRule, 'Missing gas-cloud rule');
    const scratch = checkWorkshop(after.result);
    for (const boundary of ['Wait(1, Ignore Condition);', 'Start Rule(setDifficulty, Restart Rule);']) {
        const unsafe = after.result.replace(radiusSnapshot, radiusSnapshot + '\n        ' + boundary);
        assert.throws(() => checkWorkshop(unsafe), e => /live across/.test(e.message) &&
            /tmp1/.test(e.message) && /tmp2/.test(e.message), 'Audit must reject both snapshots across async work');
    }
    const early = actions(changedRule);
    early.splice(early.indexOf(radiusSnapshot), 1);
    early.splice(early.indexOf(radiusGrowth), 0, radiusSnapshot);
    assert.throws(() => auditOrder(early), /must follow|after its growth/);

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
    for (const [name, text] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), text, 'Concurrent source edit');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselineZombieSourceRef: baselineRef,
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        compiledRulesCompared: original.length, cachedPositionReads: 3, cachedRadiusReads: 2,
        postGrowthSnapshotChecked: true, snapshotsRefreshedPerCloud: true, visualEffectsUnchanged: true,
        growthTargetsDamageAndTickUnchanged: true, scratchRulesChecked: scratch.length, negativeAuditCases: 3,
        directIncludeBuildChecked: true, emittedWarnings: [], warningsSuppressedByMainSource: true,
        inGameValidated: false, runtimeBenchmarked: false,
        zombieSourceSha256: crypto.createHash('sha256').update(files[file]).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'gas-cloud-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
