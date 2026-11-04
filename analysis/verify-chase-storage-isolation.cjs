// Check that chase storage is isolated without changing compiled actions or conditions.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const baselineRef = 'dbeb3d6';
const isolated = {
    satelliteLaserPosition: ['globalvar', 'objectiveMotionSlot'],
    botReturnTime: ['playervar', 'actorTeamSlot2'],
    botAbilityCooldown: ['playervar', 'actorTeamSlot22'],
    enhancementPupPosition: ['playervar', 'actorTeamSlot26'],
    botReigniteRisePosition: ['playervar', 'actorTeamSlot27'],
    enhancementPupCooldown: ['playervar', 'actorTeamSlot27'],
    enhancementBarrierHealth: ['playervar', 'actorTeamSlot28'],
};

function checkIsolation(sources) {
    const declarations = sources['variables.opy'];
    const aliases = Object.fromEntries([...declarations.matchAll(/^#!define (\w+) (\w+)\s*$/gm)]
        .map(match => [match[1], match[2]]));
    for (const [name, [kind, oldSlot]] of Object.entries(isolated)) {
        assert(new RegExp(`^${kind} ${name}\\b`, 'm').test(declarations),
            `${name} must own a separate ${kind} slot`);
        assert(!Object.hasOwn(aliases, name), `${name} must not alias shared storage`);
        assert(!Object.values(aliases).includes(name), `${name} must not have other role aliases`);
        const resolve = symbol => aliases[symbol] ? resolve(aliases[symbol]) : symbol;
        const code = Object.values(sources).join('\n').replace(/#.*$/gm, '');
        const targets = [...code.matchAll(/\bchase(?:AtRate|OverTime)\((?:\w+\.)?(\w+),/g)]
            .map(match => resolve(match[1]));
        assert(targets.includes(name), `${name} must still be a chase target`);
        assert(!targets.includes(oldSlot), `${oldSlot} must no longer be chased`);
    }
}

function counts(sources) {
    return Object.fromEntries(['globalvar', 'playervar'].map(kind => [kind,
        [...sources['variables.opy'].matchAll(new RegExp(`^${kind} (\\w+)`, 'gm'))].length]));
}

function warningCounts(warnings) {
    const result = {};
    for (const warning of warnings) {
        assert(warning.message.includes('(w_ow2_rule_condition_chase)'), warning.message);
        const name = warning.message.match(/variable '([^']+)'/)[1];
        result[name] = (result[name] || 0) + 1;
    }
    return result;
}

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    // Preserve the user's existing removal of the chase-warning suppression.
    baseline['main.opy'] = files['main.opy'];
    for (const file of Object.keys(files)) if (file !== 'variables.opy')
        assert.equal(files[file], baseline[file], `Unexpected gameplay source change: ${file}`);
    checkIsolation(files);
    const unsafe = {...files, 'variables.opy': files['variables.opy']
        .replace(/^playervar botReturnTime.*$/m, '#!define botReturnTime actorTeamSlot2')};
    assert.throws(() => checkIsolation(unsafe), /botReturnTime must own/);

    const before = await compile(baseline);
    const after = await compile(files);
    const renamed = after.result.replace(/\b\w+\b/g, name => isolated[name]?.[1] || name);
    const oldRules = rules(before.result), newRules = rules(renamed);
    assert.equal(oldRules.length, 268);
    assert.deepEqual(newRules, oldRules, 'Compiled conditions/actions changed beyond storage names');
    assert.equal(before.elements, 25241);
    assert.equal(after.elements, before.elements);
    const oldCounts = counts(baseline), newCounts = counts(files);
    assert.equal(newCounts.globalvar, oldCounts.globalvar + 1);
    assert.equal(newCounts.playervar, oldCounts.playervar + 6);
    for (const kind of ['globalvar', 'playervar']) {
        const names = [...files['variables.opy'].matchAll(new RegExp(`^${kind} (\\w+)`, 'gm'))]
            .map(match => match[1]);
        assert.equal(new Set(names).size, names.length, `Duplicate ${kind}`);
        assert(names.length <= 128, `${kind} slot limit exceeded`);
        assert(names.every(name => name.length <= 32), `${kind} name too long`);
    }
    assert.equal(before.warnings.length, 34);
    assert.equal(after.warnings.length, 14);
    const remaining = warningCounts(after.warnings);
    assert.deepEqual(remaining, {objectiveRad: 7, extractionZoneRad: 3, botAbilityCooldown: 1,
        infectionLevel: 1, enhancementBarrierHealth: 1, enhancementPupCooldown: 1});

    let included;
    const saved = {log: console.log, warn: console.warn, error: console.error};
    try {
        console.log = console.warn = console.error = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {Object.assign(console, saved);}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(rules(included.result), rules(after.result));
    assert.deepEqual(warningCounts(included.encounteredWarnings), remaining);
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    const report = {date: '2026-11-04', baselineRef, isolated,
        before: {elements: before.elements, variables: oldCounts, warnings: before.warnings.length},
        after: {elements: after.elements, variables: newCounts, warnings: after.warnings.length},
        remainingWarnings: remaining, compiledRulesCompared: oldRules.length,
        directIncludeBuild: true, workshopExportRebuilt: true, inGameValidated: false};
    fs.writeFileSync(path.join(__dirname, 'chase-storage-isolation-validation.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
