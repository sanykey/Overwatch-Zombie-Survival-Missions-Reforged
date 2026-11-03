// Compile the fix, constrain its scope, and compare placement/release with the known-good transition.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {compiledRules} = require('./objective-cache-slot-sharing.cjs');

const beforeRef = '9363ec1cb74c7f5363f3e57746c426585a533dce';
const workingRef = '45487b3345f57f7d76fd695f3f9627557d32fd83';
const readGit = (ref, file) => execFileSync('git', ['show', `${ref}:src/${file}`],
    {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');
const block = (source, name) => {
    const begin = source.indexOf(`rule "${name}":`);
    assert(begin >= 0, name);
    const next = source.indexOf('\n\nrule ', begin + 1);
    return source.slice(begin, next < 0 ? source.length : next);
};
const codeOnly = source => source.split('\n').map(line => line.split('#')[0].trimEnd())
    .filter(line => line.trim()).join('\n');

function checkTransition(sources) {
    const variables = sources['variables.opy'];
    // Both the camera position AND aim are reevaluated until each player releases the camera.
    // Independent declarations prohibit reintroducing either unsafe phase alias.
    for (const name of ['startPos', 'startCamPos', 'biomorphingGoalColor', 'currentObjectivePosition']) {
        assert.match(variables, new RegExp(`^globalvar ${name}\\b`, 'm'), `${name}: independent storage required`);
        assert(!new RegExp(`^#!define ${name}\\b`, 'm').test(variables), `${name}: unsafe alias`);
    }
    const start = block(sources['global_startup.opy'], 'START GAME');
    assert(!start.includes('.stopCamera()'), 'START GAME must not release cameras before player placement');
    assert(!/\b(?:startPos|startCamPos)\s*=/.test(codeOnly(start)), 'Mission startup must preserve camera coordinates');
    const player = block(sources['players_game_in_progress.opy'], 'PLAYER INITIALIZATION');
    const original = block(readGit(workingRef, 'players_game_in_progress.opy'), 'PLAYER INITIALIZATION');
    const suffix = source => codeOnly(source.slice(source.indexOf('        waitUntil(')))
        .replaceAll('currentObjectivePosition', 'objectivePositionList[0]');
    assert.deepEqual(suffix(player), suffix(original), 'Initial placement, waits, facing and camera release must match known-good behavior');
    assert.equal((Object.values(sources).join('\n').match(/\.stopCamera\(\)/g) || []).length, 1,
        'Camera release must belong to PLAYER INITIALIZATION only');
    assert(sources['player_start_menu.opy'].includes('eventPlayer.startCamera(startCamPos, startPos + Vector.UP)'));
}

async function main() {
    checkTransition(files);
    for (const [name, slot] of [['startPos', 'biomorphingGoalColor'], ['startCamPos', 'currentObjectivePosition']]) {
        const broken = {...files, 'variables.opy': files['variables.opy']
            .replace(new RegExp(`^globalvar ${name}[^\\n]*`, 'm'), `#!define ${name} ${slot}`)};
        assert.throws(() => checkTransition(broken), /independent storage required/);
    }
    const earlyRelease = {...files, 'global_startup.opy': files['global_startup.opy']
        .replace('    destroyAllInWorldTexts()\n', '    destroyAllInWorldTexts()\n    getPlayers(Team.1).stopCamera()\n')};
    assert.throws(() => checkTransition(earlyRelease), /must not release cameras/);

    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file, readGit(beforeRef, file)]));
    const before = await compile(baseline);
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = compiledRules(before.result);
    // Normalize storage names only; changed ownership is checked separately above.
    const newRules = compiledRules(after.result, {startPos: 'phaseSlot11', biomorphingGoalColor: 'phaseSlot11',
        startCamPos: 'phaseSlot12', currentObjectivePosition: 'phaseSlot12'});
    assert.equal(newRules.length, oldRules.length);
    const changedRules = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(newRules[i].name, oldRules[i].name);
        if (newRules[i].body !== oldRules[i].body) changedRules.push(newRules[i].name);
    }
    assert.deepEqual(changedRules, ['START GAME']);
    const oldStart = oldRules.find(rule => rule.name === 'START GAME').body;
    const newStart = newRules.find(rule => rule.name === 'START GAME').body;
    assert.equal(newStart, oldStart.replace('Stop Camera(All Players(Team 1));\n', ''),
        'Only early camera release may change START GAME actions');

    const savedLog = console.log;
    let included;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(compiledRules(included.result), compiledRules(after.result));
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents);
    const count = (sources, type) => (Object.values(sources).join('\n').match(new RegExp(`^${type} `, 'gm')) || []).length;
    const report = {date: '2026-11-04', beforeRef, workingRef,
        before: {elements: before.elements, globals: count(baseline, 'globalvar'), players: count(baseline, 'playervar')},
        after: {elements: after.elements, globals: count(files, 'globalvar'), players: count(files, 'playervar')},
        rulesCompared: oldRules.length, changedRulesAfterStorageNormalization: changedRules,
        warnings: after.warnings, directIncludeBuild: true,
        checks: ['Both camera vectors have storage independent of mission data',
            'START GAME preserves the camera until per-player initialization completes',
            'Initial placement/release sequence matches 45487b3 for both special and ordinary modes',
            'Rejected both unsafe aliases and early global camera release',
            'Other compiled actions match 9363ec1 after storage-name normalization'],
        limitations: 'Static validation and compilation; in-game camera rendering/scheduler not tested.'};
    assert(report.after.globals <= 128 && report.after.players <= 128);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    fs.writeFileSync(path.join(__dirname, 'pregame-camera-transition-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
