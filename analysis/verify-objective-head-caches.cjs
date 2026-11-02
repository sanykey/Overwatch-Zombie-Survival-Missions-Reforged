// Run: node analysis/verify-objective-head-caches.cjs
// Audits every queue mutation, reverses only the cache transformation, and compiles both versions.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const sharing = require('./objective-cache-slot-sharing.cjs');
const baselineRef = '45487b3345f57f7d76fd695f3f9627557d32fd83';
const pairs = {objectiveTypeList: 'currentObjectiveType', objectivePositionList: 'currentObjectivePosition'};

function audit(sources, allowPhaseReset = false) {
    const mutations = [], phaseResets = [], reads = {currentObjectiveType: 0, currentObjectivePosition: 0};
    for (const [file, source] of Object.entries(sources)) {
        const lines = source.split('\n');
        for (let i = 0; i < lines.length; i++) {
            const code = lines[i].split('#')[0];
            for (const [array, cache] of Object.entries(pairs)) {
                if (!code.includes(array) && !code.includes(cache)) continue;
                const refresh = code.trim() === `${cache} = ${array}[0]`;
                // Only direct assignments, indexed assignments/deletions and append mutate these queues.
                // Check the next physical line: moving publication past a wait/call/branch is unsafe.
                const mutation = code.match(new RegExp(`^(\\s*)(?:del )?${array}(?:\\s*=|\\.append\\(|\\[.*\\](?:\\s*\\+=|\\s*=|\\s*$))`));
                if (mutation) {
                    assert.equal(lines[i + 1], `${mutation[1]}${cache} = ${array}[0]`,
                        `${file}:${i + 1}: queue mutation must immediately refresh ${cache}`);
                    mutations.push({file, line: i + 1, code: code.trim(), cache});
                }
                if (code.includes(`${array}[0]`)) {
                    assert(refresh || mutation, `${file}:${i + 1}: uncached head read`);
                }
                if (refresh) {
                    const boundaryReset = allowPhaseReset && file === 'global_startup.opy' &&
                        i > lines.findIndex(line => line === 'rule "START GAME":');
                    if (boundaryReset) phaseResets.push({file, line: i + 1, cache});
                    assert(boundaryReset || mutations.some(m => m.file === file && m.line === i && m.cache === cache),
                        `${file}:${i + 1}: refresh without a queue mutation`);
                } else {
                    assert(!new RegExp(`^\\s*${cache}\\s*(?:[+*/-]?=|\\+\\+|--)`).test(code),
                        `${file}:${i + 1}: cache modified independently of its queue`);
                    if (!code.startsWith('globalvar ')) reads[cache] += code.split(cache).length - 1;
                }
            }
        }
    }
    assert.equal(mutations.length, 11, 'Review new mutation sites before updating the audit');
    assert.equal(phaseResets.length, allowPhaseReset ? 2 : 0);
    assert.deepEqual(reads, {currentObjectiveType: 46, currentObjectivePosition: 102});
    return {mutations, phaseResets, reads};
}

function reverse(sources) {
    return Object.fromEntries(Object.entries(sources).map(([file, source]) => {
        for (const [array, cache] of Object.entries(pairs)) {
            source = source.replace(new RegExp(`^globalvar ${cache}[^\\n]*\\n`, 'gm'), '')
                .replace(new RegExp(`^ *${cache} = ${array}\\[0\\]\\n`, 'gm'), '')
                .replace(new RegExp(`\\b${cache}\\b`, 'g'), `${array}[0]`);
        }
        return [file, source];
    }));
}

async function main() {
    const slotSharing = sharing.audit(files);
    const unshared = sharing.unshare(files);
    const checked = audit(files, true);
    audit(unshared);
    // Make sure the audit rejects stale caches in the moving objective, rollback, and advancement paths.
    for (const [file, needle] of [
        ['objective_types/objective_type_zombie_egg.opy', '    currentObjectivePosition = objectivePositionList[0]\n'],
        ['global_start_menu.opy', '                currentObjectivePosition = objectivePositionList[0]\n'],
        ['subroutines.opy', '        currentObjectiveType = objectiveTypeList[0]\n'],
    ]) {
        assert(unshared[file].includes(needle));
        const broken = {...unshared, [file]: unshared[file].replace(needle, '')};
        assert.throws(() => audit(broken), /queue mutation must immediately refresh/);
        const delayed = {...unshared, [file]: unshared[file].replace(needle, '    wait()\n' + needle)};
        assert.throws(() => audit(delayed), /queue mutation must immediately refresh/);
    }
    for (const file of ['global_start_menu.opy', 'player_start_menu.opy']) {
        const broken = {...files, [file]: files[file].replace(
            /^( *)# Shared menu storage changes owners at START GAME\.\n\1if not isPregameSetup:\n\1    return\n/m, '')};
        assert.throws(() => sharing.audit(broken), /missing phase guard/);
    }
    for (const line of ['    getPlayers(Team.1).stopCamera()\n',
        '    currentObjectivePosition = objectivePositionList[0]\n']) {
        const source = files['global_startup.opy'], index = source.lastIndexOf(line);
        assert(index >= 0);
        const broken = {...files, 'global_startup.opy': source.slice(0, index) + source.slice(index + line.length)};
        assert.throws(() => sharing.audit(broken), /sharing layout changed/);
    }
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {cwd: path.dirname(src), encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    // Compare source too: no altered reevaluation modes, guards, waits, or unrelated gameplay logic.
    const codeOnly = s => s.split('\n').map(l => l.split('#')[0].trimEnd()).filter(l => l.trim()).join('\n');
    const reconstructed = reverse(unshared);
    for (const file of Object.keys(files)) {
        assert.equal(codeOnly(reconstructed[file]), codeOnly(baseline[file]), `Unexpected source change: ${file}`);
    }
    await compiler.readyPromise;
    const before = await compile(baseline);
    const undone = await compile(reconstructed);
    const cached = await compile(unshared);
    const separate = await compile(sharing.separateStorage(files));
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(undone.warnings, []);
    assert.deepEqual(cached.warnings, []);
    assert.deepEqual(separate.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(undone.result, before.result, 'Reversed cache transformation changes compiled logic');
    const sharedRules = sharing.compiledRules(after.result);
    assert(sharedRules.length > 200);
    assert.deepEqual(sharedRules, sharing.compiledRules(separate.result, sharing.mapping),
        'Slot aliases changed compiled logic compared with separate guarded storage');
    assert(after.elements < before.elements);
    const source = Object.values(files).join('\n');
    const globals = [...source.matchAll(/^globalvar /gm)].length;
    const playerVariables = [...source.matchAll(/^playervar /gm)].length;
    assert(globals <= 128 && playerVariables <= 128);
    const scratch = checkWorkshop(after.result);
    // Verify the real include path as well, then update the importable Workshop artifact.
    const saved = console.log;
    let exported;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = saved; }
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    // The diagnostic header lists included filenames in the real build and main.opy in the flattened build.
    const withoutDiagnostics = s => s.replace(/^\/\* Element count:[\s\S]*?\*\//, '');
    assert.equal(withoutDiagnostics(exported.result), withoutDiagnostics(after.result));
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const report = {date: '2026-11-02', baselineRef,
        before: {elements: before.elements, globals: 99, playerVariables},
        unsharedCaches: {elements: cached.elements, globals: 101, playerVariables},
        after: {elements: after.elements, globals, playerVariables},
        savedElements: before.elements - after.elements, slotSharing,
        sharingElementCost: after.elements - cached.elements, ...checked,
        warnings: after.warnings, scratchRulesChecked: scratch.length, compiledRulesCompared: sharedRules.length,
        checks: ['All 11 queue mutations immediately refresh their head cache',
            'Missing/delayed egg, rollback and advancement publications are rejected',
            'Shared slot aliases, menu sentinels 0/40, four post-wait guards and synchronous camera/visual retirement checked',
            'Missing phase guards, camera retirement and cache publication are rejected',
            'All compiled rules match separate guarded storage after normalizing the six role aliases',
            'Reversing the cache transformation reproduces baseline sources and compiled output',
            'Direct include build matches the in-memory build', 'Compiled scratch lifetime audit'],
        limitations: 'Static validation and compilation only; no in-game scheduler/renderer test.'};
    fs.writeFileSync(path.join(__dirname, 'objective-head-caches-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({before: report.before, after: report.after,
        unsharedCaches: report.unsharedCaches, sharingElementCost: report.sharingElementCost,
        savedElements: report.savedElements, mutationSites: checked.mutations.length,
        reads: checked.reads, warnings: report.warnings, scratchRulesChecked: scratch.length}));
}
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
module.exports = {audit, reverse};
