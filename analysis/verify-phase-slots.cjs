// Compare compiled rules against the revision before phase-slot sharing, then export Workshop.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const baselineRef = '1a313866755d0a00e6cc8bfcbfc323904c5ff02f';
const pairs = [
    ['startMenuZombieColorList', 'objectiveEntitiesCount'],
    ['startMenuObjectiveColorList', 'objectiveCount1'],
    ['startMenuEnhancementColorList', 'testPos2'],
    ['challengeVoteList', 'biomorphingResourceNameList'],
    ['objectiveTypeVoteList', 'biomorphingResourceColorList'],
    ['zombieVoteList', 'biomorphingQueuedTypeList'],
    ['pregameGlitchText', 'extractionFlightDestination'],
    ['isPregameGlitchActive', 'extractionFlightSpeed'],
    ['mixedObjectiveTypeList', 'evacCount'],
    ['enhancementOptionList', 'biomorphingGoalText'],
    ['startMenuSpacingAngle', 'biomorphingGoalColor']
];
// Historical names belong only to the comparison baseline, never to the current objective code.
const mapping = {
    ...Object.fromEntries(pairs.flatMap((names, i) => names.map(name => [name, 'phaseSlot' + i]))),
    testPos: 'objectivePlacementSlot', objectiveChase1: 'objectiveMotionSlot',
    goalPost: 'objectiveCheckpointSlot', queuedGoalList: 'objectiveQueueSlot',
    survivorToRescue: 'objectiveActorSlot', objectiveResourcePositionList: 'objectivePositionsSlot',
    objectiveCaptureValue: 'objectiveProgressSlot', chase1: 'menuFinaleMotionSlot'
};

function rules(workshop, map = {}) {
    return [...workshop.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => ({
        name,
        body: body.split('\n').filter(line => !/^\s*(?:"|\/\/)/.test(line))
            .map(line => line.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n')
            // Global reads and global-action targets only; player.chase1 and bare player-action fields are separate.
            .replace(/\bGlobal\.(\w+)/g, (_, word) => 'Global.' + (map[word] ?? word))
            .replace(/\b((?:Set|Modify|For|Chase|Stop Chasing) Global Variable[^\n(]*\()(\w+)/g,
                (_, action, word) => action + (map[word] ?? word))
    }));
}

async function main() {
    const baselineFiles = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
    await compiler.readyPromise;
    const before = await compile(baselineFiles);
    const after = await compile(files);
    assert.deepEqual(after.warnings, []);
    assert.equal(before.elements, 27213);
    assert.equal(after.elements, before.elements + 5);
    const globals = Object.values(files).join('\n').match(/^globalvar /gm).length;
    assert.equal(globals, 99);
    const declarations = new Set([...files['variables.opy'].matchAll(/^globalvar (\w+)/gm)].map(m => m[1]));
    const currentAliases = [...files['variables.opy'].matchAll(/^#!define (\w+) (\w+)$/gm)]
        .filter(m => declarations.has(m[2])).map(m => ({name: m[1], slot: m[2]}));
    assert(currentAliases.length > 40);
    for (const {name} of currentAliases) assert(!declarations.has(name), name);
    assert(currentAliases.some(a => a.name === 'rescueMinSpawnDistance' && a.slot === 'phaseSlot2'));
    assert(currentAliases.some(a => a.name === 'satelliteMinTerminalSpacing' && a.slot === 'phaseSlot2'));

    const oldRules = rules(before.result, mapping), newRules = rules(after.result);
    assert(oldRules.length > 200, 'No compiled rules parsed');
    assert.equal(newRules.length, oldRules.length);
    let resets = 0, guardedWrites = 0;
    newRules.forEach((rule, i) => {
        assert.equal(rule.name, oldRules[i].name);
        let body = rule.body;
        if (rule.name === 'START GAME') {
            const cleanup = body.indexOf('Destroy All In-World Text;');
            for (const slot of ['phaseSlot9', 'phaseSlot10']) {
                const reset = `Set Global Variable(${slot}, Null);\n`;
                const count = body.split(reset).length - 1;
                assert.equal(count, 1);
                resets += count;
                assert(cleanup >= 0 && cleanup < body.indexOf(reset));
                const phaseEnd = body.indexOf('Set Global Variable(isPregameSetup, False);');
                assert(phaseEnd >= 0 && phaseEnd < cleanup);
                assert(!body.slice(phaseEnd, body.indexOf(reset)).includes('\nWait('));
                body = body.replace(reset, '');
            }
        }
        if (rule.name === 'GLOBAL MENU INITIALIZATION') {
            const guarded = 'If(Global.isPregameSetup);\nSet Global Variable(phaseSlot10, 40);\nEnd;';
            guardedWrites = body.split(guarded).length - 1;
            assert.equal(guardedWrites, 1);
            body = body.replace(guarded, 'Set Global Variable(phaseSlot10, 40);');
        }
        assert.equal(body, oldRules[i].body, 'Unexpected event/condition/action change: ' + rule.name);
    });
    assert.equal(resets, 2);
    assert.equal(guardedWrites, 1);

    // Preserve zero as the menu readiness sentinel and the early extraction-speed initialization.
    assert.match(files['global_startup.opy'], /extractionSpeedUp = 2\.5/);
    assert.match(files['variables.opy'], /^globalvar phaseSlot10\s+#/m);
    assert(!/^globalvar phaseSlot10\s*=/m.test(files['variables.opy']), 'Menu readiness must start at zero');
    const generation = files['global_start_menu.opy'].split('def setObjectiveType():')[1];
    assert(generation.indexOf('waitUntil(isGameInProgress() and not isPregameSetup') < generation.indexOf('missionPlacementAttemptCount = 0'));
    assert(generation.lastIndexOf('mixedObjectiveTypeList') < generation.indexOf('isGameplayActive = true'));

    // Export through normal includes as well, retaining useful per-file compiler diagnostics.
    const mainSource = files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, '');
    const saved = console.log;
    let exported;
    try {
        console.log = () => {};
        exported = await compiler.compile(mainSource, 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = saved; }
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), newRules);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const report = {
        date: '2026-11-02', baselineRef,
        before: {globals: 110, elements: before.elements},
        after: {globals, elements: after.elements},
        sharedSlots: [...new Set(currentAliases.map(a => a.slot))].map(slot => ({slot,
            roles: currentAliases.filter(a => a.slot === slot).map(a => a.name)})),
        legacyVariableMapping: mapping,
        compiledRulesCompared: newRules.length,
        actionChanges: [
            'START GAME: restore biomorphingGoalText and biomorphingGoalColor to null after deleting pregame texts.',
            'GLOBAL MENU INITIALIZATION: write the spacing angle only while isPregameSetup is true, preventing a resumed menu writer from overwriting the Biomorphing goal color.'
        ],
        warnings: after.warnings,
        sha256: Object.fromEntries(Object.entries(files).map(([file, source]) => [file,
            crypto.createHash('sha256').update(source).digest('hex')])),
        limitations: 'Static source review and complete compiled-rule comparison. Does not simulate Workshop scheduling, renderer reevaluation, joins or combat. In-game transitions still require validation.'
    };
    fs.writeFileSync(path.join(__dirname, 'phase-slots-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({before: report.before, after: report.after,
        compiledRulesCompared: report.compiledRulesCompared, warnings: report.warnings}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
