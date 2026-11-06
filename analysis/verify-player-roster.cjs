// Compile the portrait roster and verify that gameplay rules remain unchanged.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

async function main() {
    const baseline = {...files};
    for (const [key, file] of [['main.opy', 'includes.opy'], ['players_game_in_progress.opy', 'players_game_in_progress.opy'],
        ['enhancements.opy', 'enhancements.opy'], ['augments.opy', 'augments.opy']]) {
        baseline[key] = execFileSync('git', ['show', `HEAD:src/${file}`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const setup = newRules.shift();
    assert(setup.name.startsWith('OverPy <'));
    assert(setup.body.includes('Destroy All Dummy Bots;'));
    assert(!setup.body.includes('Wait('), 'Tag bootstrap must finish before normal startup');
    assert.equal(newRules.length, oldRules.length);
    let changed = 0;
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(newRules[i].name, oldRules[i].name);
        if (['PLAYER ENHANCEMENT INITIALIZATION', 'PLAYER AUGMENT INITIALIZATION'].includes(oldRules[i].name)) {
            const oldActions = oldRules[i].body.split('\n'), newActions = newRules[i].body.split('\n');
            assert.deepEqual(newActions.filter(line => !line.startsWith('Create HUD Text(')),
                oldActions.filter(line => !line.startsWith('Create HUD Text(')),
                'Only HUD arguments may change in ability initialization');
            const oldHuds = oldActions.filter(line => line.startsWith('Create HUD Text('));
            const newHuds = newActions.filter(line => line.startsWith('Create HUD Text('));
            assert.equal(newHuds.length, oldHuds.length, 'Keep one HUD for each ability and both attachment notices');
            assert(newHuds.every(hud => hud.includes('\u2003'.repeat(20))),
                'All personal ability cards and attachment notices must share the roster alignment');
            if (oldRules[i].name === 'PLAYER ENHANCEMENT INITIALIZATION') {
                assert.equal(newHuds.filter(hud => hud.startsWith('Create HUD Text(Event Player, Icon String(')).length, 9);
                for (const hint of ['Press [{0}] to deal {1}00 damage', 'Hold [{0}] to place a barricade',
                    'Infection Reduced: {0} lvls', 'Hold [{0}]', 'Press [{0}] to dismount', 'Press [{0}] to attach']) {
                    assert(newHuds.some(hud => hud.includes(hint)), hint);
                }
                for (let j = 0; j < oldHuds.length; j++) {
                    const dynamicRefs = oldHuds[j].match(/\(Event Player\)\.\w+/g) || [];
                    for (const ref of dynamicRefs) assert(newHuds[j].includes(ref), 'Lost ability state: ' + ref);
                }
            } else {
                assert(newHuds[0].includes('Input Binding String(Button(Jump))'));
                assert(newHuds[0].includes('Input Binding String(Button(Crouch))'));
                assert(newHuds[0].includes('Total Time Elapsed'));
                assert(newHuds[0].includes('Icon String(Checkmark)'));
            }
            changed++;
            continue;
        }
        if (oldRules[i].name !== 'EFFECTS/TEXTS' || !oldRules[i].body.includes('Infection Level:')) {
            assert.deepEqual(newRules[i], oldRules[i], `Gameplay changed: ${oldRules[i].name}`);
            continue;
        }
        const oldActions = oldRules[i].body.split('\n'), newActions = newRules[i].body.split('\n');
        const hud = newActions.find(line => line.startsWith('Create HUD Text('));
        assert(hud);
        assert.equal(newActions.filter(line => line.startsWith('Create HUD Text(')).length, 1);
        changed++;
        assert.deepEqual(newActions.filter(line => !line.startsWith('Create HUD Text(')),
            oldActions.filter(line => !line.startsWith('Create HUD Text(')));
        assert(hud.startsWith('Create HUD Text(Filtered Array(All Players(All Teams), And(Compare((Event Player).rescueTimeRemaining, >, Null), Not((Event Player).isAfk))),'));
        assert(hud.includes('\u2003'.repeat(20)),
            'Roster must use the same left alignment as the personal ability cards');
        for (const token of ['Hero Being Duplicated(Event Player)', 'Hero(Winston)', 'Slot Of(Event Player)',
            'Infection:', 'Vaccine:', 'Reviving:', 'Revive:', 'Normalized Health(Event Player)', 'DOWN',
            'Visible To String and Color', 'Global.__holygrail__']) assert(hud.includes(token), token);
        assert(!hud.includes('Custom String("Winston")'), 'Names must remain visible during Smolder');
        assert(hud.includes('Compare(Normalized Health(Event Player), >, 0.97)'));
        assert(hud.includes('Compare(Normalized Health(Event Player), >, 0.66)'));
        assert(hud.includes('Compare(Normalized Health(Event Player), >, 0.33)'));
        assert(hud.includes('Color(Orange), Color(Red)'));
    }
    assert.equal(changed, 3);
    // Export through the real root entry point, including relative includes.
    const saved = console.log;
    let exported;
    try {
        console.log = () => {};
        exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = saved; }
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), rules(after.result));
    fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    const report = {before: before.elements, after: after.elements, delta: after.elements - before.elements,
        unchangedRules: oldRules.length - changed, rosterHudActionsPerPlayer: 1, warnings: [],
        tagBootstrapElements: 43, rosterAlignmentSpacer: true, abilityAlignmentSpacer: true,
        abilityGameplayUnchanged: true, enhancementCards: 9, augmentCardsPerPlayer: 1,
        healthColorThresholds: [0.97, 0.66, 0.33, 0], deadColor: 'Red', inGameVisualCheck: 'pending'};
    fs.writeFileSync(path.join(__dirname, 'player-roster-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
