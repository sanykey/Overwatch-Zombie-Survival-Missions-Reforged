// Verifies the five selected optimizations, storage ownership and the real include build.
// Run: node analysis/verify-remaining-elements.cjs
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {inventory} = require('./audit-player-variables.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '20881df2c6e284fe7b3da06e1d57655a8c372d25';
const palette = '[Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE]';
const voteRoles = {
    pregameChallengeVote: 'CHALLENGE_VOTE',
    pregameZombieVote: 'ZOMBIE_MODE_VOTE',
    pregameObjectiveVote: 'OBJECTIVE_TYPE_VOTE',
};
const storage = {
    pregameChallengeVote: 'actorTeamSlot3',
    powerUpTradePosition: 'actorTeamSlot3',
    pregameObjectiveVote: 'actorTeamSlot21',
    pregameZombieVote: 'menuTradeItemSlot',
    powerUpTradePreviousItemId: 'menuTradeItemSlot',
};
const helpers = {
    removeBotSpawnPoint: {file: 'bots_game_in_progress.opy', calls: 2, body: [
        'del botSpawnWaypointList[botSpawnPointList.index(eventPlayer.botTeleportPosition)]',
        'del botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.botTeleportPosition)]',
        'botSpawnPointList.remove(eventPlayer.botTeleportPosition)',
    ]},
    resumeBotMovementAndFacing: {file: 'zombie_types.opy', calls: 5, body: [
        'eventPlayer.botIsThrottleOverridden = false',
        'eventPlayer.botIsFacingOverridden = false',
        'startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)',
    ]},
    resumeBotFacingAndMovement: {file: 'zombie_types.opy', calls: 4, body: [
        'eventPlayer.botIsFacingOverridden = false',
        'eventPlayer.botIsThrottleOverridden = false',
        'startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)',
    ]},
};

function codeOnly(s) {
    return s.replace(/"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|#[^\n]*/g,
        match => match.startsWith('#') && !match.startsWith('#!') ? '' : match)
        .split('\n').map(l => l.trimEnd()).filter(l => l.trim()).join('\n');
}
// Match the explicit Vector spelling used by src/ without relaxing other source checks.
// Keep the scalar first, as in OverPy's optimizeForSize lowering of axial vectors.
function explicitAxisVectors(source) {
    const edits = [];
    for (const match of source.matchAll(/\bvect\(/g)) {
        const args = [];
        let depth = 0, part = match.index + match[0].length, end;
        for (let i = part; i < source.length; i++) {
            const c = source[i];
            if (c === ')' && depth === 0) {
                args.push(source.slice(part, i).trim());
                end = i + 1;
                break;
            }
            if ('([{'.includes(c)) depth++;
            if (')]}'.includes(c)) depth--;
            if (c === ',' && depth === 0) {
                args.push(source.slice(part, i).trim());
                part = i + 1;
            }
        }
        if (args.length !== 3) continue;
        const axes = args.map((v, i) => v !== '0' ? i : -1).filter(i => i >= 0);
        if (axes.length !== 1) continue;
        const axis = axes[0], scalar = args[axis];
        const positive = ['LEFT', 'UP', 'FORWARD'][axis];
        const negative = ['RIGHT', 'DOWN', 'BACKWARD'][axis];
        const value = scalar === '1' ? 'Vector.' + positive : scalar === '-1' ? 'Vector.' + negative
            : (/^-?\d+(?:\.\d+)?$|^[\w.]+$/.test(scalar) ? scalar : '(' + scalar + ')') + ' * Vector.' + positive;
        edits.push({start: match.index, end, value});
    }
    for (const edit of edits.reverse()) source = source.slice(0, edit.start) + edit.value + source.slice(edit.end);
    return source;
}
function replace(f, file, before, after) {
    assert(f[file].includes(before), `${file}: missing ${before.slice(0, 80)}`);
    f[file] = f[file].replace(before, after);
}
function block(source, header) {
    const start = source.indexOf(header + '\n');
    assert(start >= 0, header);
    const tail = source.slice(start + header.length + 1);
    const end = tail.search(/^(?:rule |def |macro )/m);
    return tail.slice(0, end < 0 ? undefined : end);
}

// Reconstruct the pre-change source, including original array accesses and inlined
// action blocks. Equality pins unrelated gameplay, waits, UI and reevaluation flags.
function reverse(f, baseline) {
    f = {...f};
    // Enum names must lower to the original numeric indices, including turret bounds.
    const enumBody = f['variables.opy'].match(/^enum PowerUpEntitySlot:\n((?:[ \t].*\n|\n)*)/m)?.[1];
    assert(enumBody, 'Missing PowerUpEntitySlot enum');
    const slots = Object.fromEntries([...enumBody.matchAll(/^    (\w+) = (\d+),/gm)].map(m => [m[1], m[2]]));
    for (const file of Object.keys(f)) f[file] = f[file].replace(/\bPowerUpEntitySlot\.(\w+)/g, (_, name) => {
        assert(Object.hasOwn(slots, name), 'Unknown entity slot: ' + name);
        return slots[name];
    });
    replace(f, 'supply_drops.opy', 'for turretCleanupEffectIndex in range(50, 54 + 1):',
        'for turretCleanupEffectIndex in range(50, 55):');
    for (const [name, h] of Object.entries(helpers)) {
        const head = `def ${name}():`;
        const body = block(f[h.file], head);
        assert.equal(codeOnly(body), h.body.map(l => '    ' + l).join('\n'), name + ': helper body changed');
        replace(f, h.file, head + '\n' + body, '');
        replace(f, h.file, `subroutine ${name}\n`, '');
        let calls = 0;
        f[h.file] = f[h.file].replace(new RegExp(`^( *)${name}\\(\\)$`, 'gm'), (_, indent) => {
            calls++;
            return h.body.map(line => indent + line).join('\n');
        });
        assert.equal(calls, h.calls, name + ': call count changed');
        assert(!Object.values(f).some(s => new RegExp('\\b' + name + '\\b').test(s)), name);
    }
    replace(f, 'player_start_menu.opy',
        '        eventPlayer.pregameChallengeVote = 0\n        eventPlayer.pregameZombieVote = 0\n        eventPlayer.pregameObjectiveVote = 0',
        '        eventPlayer.pregameVoteList = [0, 0, 0, 0]');
    replace(f, 'player_start_menu.opy',
        'eventPlayer.pregameChallengeVote == 0 and eventPlayer.pregameZombieVote == 0 and eventPlayer.pregameObjectiveVote == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE',
        'eventPlayer.pregameVoteList.slice(PlayerMenuStatusField.CHALLENGE_VOTE, 3).all(lambda x: x == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE)');
    for (const file of Object.keys(f)) {
        for (const [role, index] of Object.entries(voteRoles))
            f[file] = f[file].replaceAll('.' + role, `.pregameVoteList[PlayerMenuStatusField.${index}]`);
        f[file] = f[file].replaceAll('.powerUpTradePosition', '.powerUpTradeDataList[0]')
            .replaceAll('.powerUpTradePreviousItemId', '.powerUpTradeDataList[2]');
    }
    // Restore the old scratch-backed HUD palette; the new palette is immutable.
    f['power_ups.opy'] = f['power_ups.opy'].replaceAll(
        'evalOnce(powerUpColorListConst[powerUpHudItemIndex])', 'evalOnce(powerUpHudColorList[powerUpHudItemIndex])');
    replace(f, 'power_ups.opy', '    #!define powerUpHudItemIndex tmp0',
        '    #!define powerUpHudColorList tmp1\n    powerUpHudColorList = ' + palette + '\n    #!define powerUpHudItemIndex tmp0');
    f['power_ups.opy'] = f['power_ups.opy'].replaceAll('powerUpColorListConst', palette);
    f['variables.opy'] = baseline['variables.opy'];
    for (const file of Object.keys(f)) assert.equal(explicitAxisVectors(codeOnly(f[file])),
        explicitAxisVectors(codeOnly(baseline[file])), 'Unrelated source change: ' + file);
    return f;
}

function auditStorage(f) {
    const all = Object.values(f).join('\n');
    assert(!/\b(?:pregameVoteList|PlayerMenuStatusField|powerUpTradeDataList)\b/.test(all));
    const vars = inventory(f);
    assert.equal(vars.length, 75);
    assert.equal((all.match(/^globalvar /gm) || []).length, 103);
    for (const [role, physical] of Object.entries(storage)) {
        const owner = vars.find(v => v.name === physical);
        assert(owner?.aliases.includes(role), role + ': unexpected storage');
        assert(owner.references.some(r => r.symbols.includes(role)), role + ': unused');
    }
    const field = role => vars.find(v => v.name === role || v.aliases.includes(role)).name;
    assert.equal(new Set(['powerUpTradePosition', 'powerUpTradeIndex', 'powerUpTradePreviousItemId'].map(field)).size, 3,
        'Trade fields must coexist across waits');
    assert.equal(new Set(Object.keys(voteRoles).map(field)).size, 3, 'Votes must be independent');
    assert(!/\.(?:actorTeamSlot3|actorTeamSlot21|menuTradeItemSlot)\b/.test(all), 'Gameplay must use role aliases');
    assert(!/\b(?:setTeam|swapTeam)\(/.test(all), 'Team changes require a new ownership audit');
    assert(!/chase\w*\(eventPlayer\.(?:pregame\w*Vote|powerUpTrade\w*)/.test(all), 'Chases cannot own vote/trade storage');

    const endVoting = block(f['global_start_menu.opy'], 'rule "END VOTING":');
    assert(endVoting.includes('waitUntil(not isVoting or not isPregameSetup, 99999)\n    # Votes share runtime trade/path storage; a resumed menu writer must not touch it.\n    if not isPregameSetup:\n        return\n    getPlayers(Team.1).pregameChallengeVote ='),
        'END VOTING must guard late writes after its wait');
    const menuInit = block(f['player_start_menu.opy'], 'rule "PLAYER MENU INITIALIZATION":');
    assert(menuInit.includes('@Team 1') && menuInit.includes('@Condition isPregameSetup == true'));
    assert(menuInit.includes('wait(0.016, Wait.ABORT_WHEN_FALSE)'));
    const controls = [
        'PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)',
        'PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)',
        'PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)',
    ];
    for (const title of controls) {
        const b = block(f['player_start_menu.opy'], `rule "${title}":`);
        assert(b.includes('@Team 1') && b.includes('@Condition isPregameSetup == true'));
        assert(!/\b(?:wait|waitUntil)\(/.test(codeOnly(b)), 'Vote controls must finish synchronously');
    }
    for (const name of ['determineZombieMode', 'determineChallenge', 'determineObjectiveType']) {
        const b = block(f['global_start_menu.opy'], `def ${name}():`);
        assert(!/\b(?:wait|waitUntil)\(/.test(codeOnly(b)), 'Vote-counting helpers must not retain reads across waits');
    }
    const start = block(f['global_startup.opy'], 'rule "START GAME":');
    assert(start.indexOf('isPregameSetup = false') < start.indexOf('destroyAllHudTexts()'));
    assert(start.includes('destroyAllHudTexts()') && start.includes('destroyAllInWorldTexts()'));

    const trade = block(f['supply_drops.opy'], 'rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":');
    assert(trade.includes('@Team 1') && trade.includes('@Condition isGameplayActive == true') && trade.includes('@Condition eventPlayer.isDummy() == false'));
    for (const role of ['powerUpTradePosition', 'powerUpTradeIndex', 'powerUpTradePreviousItemId']) {
        const refs = vars.find(v => v.name === field(role)).references.filter(r => r.symbols.includes(role));
        assert(refs.every(r => r.file === 'supply_drops.opy' && r.source.includes('eventPlayer.' + role)));
        assert(refs.every(r => r.block.startsWith('rule "PLAYER INTERACT')));
        assert(refs[0].source.startsWith('eventPlayer.' + role + ' = '), role + ': read before initialization');
    }
    assert(all.includes('globalvar powerUpColorListConst = ' + palette));
    assert.equal((all.match(/\bpowerUpColorListConst\b/g) || []).length, 5);
    assert(!/\bpowerUpColorListConst(?:\[[^\n]*\])?\s*(?:\+=|-=|\*\/=)|\bpowerUpColorListConst\.(?:append|remove)\(/.test(all));
    return {playerVariables: vars.length, globalVariables: 103, storage};
}

function separateStorage(f) {
    f = {...f};
    const mapping = {};
    for (const [role, physical] of Object.entries(storage)) {
        const name = 'separate_' + role;
        replace(f, 'variables.opy', `#!define ${role} ${physical}`, `playervar ${name}\n#!define ${role} ${name}`);
        mapping[name] = physical;
    }
    return {files: f, mapping};
}

function checkReadyPredicate() {
    let cases = 0;
    // Reachable reset state has four zero entries; voting can extend it to five.
    for (let challenge = 0; challenge <= 5; challenge++)
    for (let zombie = 0; zombie <= 6; zombie++)
    for (let objective = 0; objective <= 9; objective++)
    for (let enhancement = 0; enhancement <= 10; enhancement++)
    for (const voting of [false, true]) {
        const previous = voting && [challenge, zombie, objective].every(x => x === 0 && enhancement === 0) || !voting && enhancement === 0;
        const current = voting && challenge === 0 && zombie === 0 && objective === 0 && enhancement === 0 || !voting && enhancement === 0;
        assert.equal(current, previous);
        cases++;
    }
    for (let enhancement = 0; enhancement <= 10; enhancement++) {
        assert.equal([0, 0, 0, 0].slice(2, 5).every(x => x === 0 && enhancement === 0), enhancement === 0);
        cases++;
    }
    return cases;
}

// OverPy accepts names that the game's importer rejects. Check exported names,
// not role aliases or enum members, which never appear as Workshop identifiers.
function checkImportNames(output) {
    const maxLength = 32;
    const declarations = output.match(/^variables \{\n([\s\S]*?)^\}/m)?.[1];
    assert(declarations, 'Missing exported variable declarations');
    const counts = {global: 0, player: 0, subroutine: 0};
    let kind;
    function check(type, slot, name) {
        assert(name.length <= maxLength,
            `${type} variable/subroutine ${slot}: ${name} has ${name.length} characters (maximum ${maxLength})`);
        counts[type]++;
    }
    for (const line of declarations.split('\n')) {
        const section = line.match(/^    (global|player):$/);
        if (section) kind = section[1];
        const entry = line.match(/^        (\d+): (\S+)$/);
        if (entry) {
            assert(kind, 'Variable entry outside a section');
            check(kind, entry[1], entry[2]);
        }
    }
    assert(counts.global > 0 && counts.player > 0, 'No exported variable names checked');
    const subroutines = output.match(/^subroutines \{\n([\s\S]*?)^\}/m)?.[1] ?? '';
    for (const entry of subroutines.matchAll(/^    (\d+): (\S+)$/gm)) check('subroutine', entry[1], entry[2]);
    return {...counts, maxLength};
}

async function main() {
    const root = path.dirname(src);
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
    const layout = auditStorage(files);
    const reconstructed = reverse(files, baseline);
    const readyPredicateCases = checkReadyPredicate();
    // The audit must reject both a colliding trade slot and an unguarded late writer.
    assert.throws(() => auditStorage({...files, 'variables.opy': files['variables.opy'].replace(
        '#!define powerUpTradePreviousItemId menuTradeItemSlot', '#!define powerUpTradePreviousItemId actorTeamSlot21')}));
    const oldGuard = '    if not isPregameSetup:\n        return\n    getPlayers(Team.1).pregameChallengeVote';
    assert.throws(() => auditStorage({...files, 'global_start_menu.opy': files['global_start_menu.opy'].replace(oldGuard,
        '    getPlayers(Team.1).pregameChallengeVote')}), /guard late writes/);
    await compiler.readyPromise;
    const before = await compile(baseline);
    const undone = await compile(reconstructed);
    const after = await compile(files);
    const separate = separateStorage(files);
    const independent = await compile(separate.files);
    for (const result of [before, undone, after, independent]) assert.deepEqual(result.warnings, []);
    assert.deepEqual(rules(undone.result), rules(before.result), 'Reconstruction changes original compiled logic');
    const currentRules = rules(after.result);
    assert.deepEqual(rules(independent.result, separate.mapping), currentRules,
        'Shared storage changes compiled logic relative to independent fields');
    assert.equal(before.elements, 27102);
    assert.equal(after.elements, 26902);
    assert.equal(currentRules.length, rules(before.result).length + 3);
    const importNames = checkImportNames(after.result);
    // Reproduce the reported slot-15 import error and prove the repair only
    // changes its exported name, not any of the compiled rules or the budget.
    const previousNaming = {...files, 'variables.opy': files['variables.opy']
        .replace('playervar enhancementCarrierPoolId ', 'playervar enhancementHitchhikerCarrierPoolId ')
        .replace(/^#!define enhancementHitchhikerCarrierPoolId enhancementCarrierPoolId\n/m, '')};
    assert.notEqual(previousNaming['variables.opy'], files['variables.opy']);
    const previous = await compile(previousNaming);
    assert.throws(() => checkImportNames(previous.result), /player variable\/subroutine 15: .*34 characters/);
    assert.equal(previous.elements, after.elements);
    assert.deepEqual(rules(previous.result, {enhancementHitchhikerCarrierPoolId: 'enhancementCarrierPoolId'}), currentRules,
        'Import-name repair must only rename the carrier pool storage');
    const scratch = checkWorkshop(after.result);
    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), currentRules);
    assert.deepEqual(checkImportNames(exported.result), importNames);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const report = {baselineRef, compiler: 'OverPy 9.7.20',
        before: {elements: before.elements, globalVariables: 102, playerVariables: 74},
        after: {elements: after.elements, globalVariables: layout.globalVariables, playerVariables: layout.playerVariables},
        savedElements: before.elements - after.elements, storage,
        sourceReconstructionChecked: true, compiledRulesCompared: currentRules.length,
        readyPredicateCases, scratchRulesChecked: scratch.length,
        independentStorageCompared: true, negativeAuditCases: 3, directIncludeBuildChecked: true,
        importNames, carrierPoolRenameOnlyCompared: true,
        emittedWarnings: after.warnings, warningsSuppressedByMainSource: true,
        sourceSha256: Object.fromEntries(Object.entries(files).map(([file, source]) =>
            [file, crypto.createHash('sha256').update(source).digest('hex')])),
        inGameValidated: false, runtimeBenchmarked: false};
    fs.writeFileSync(path.join(__dirname, 'remaining-elements-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({before: report.before, after: report.after, savedElements: report.savedElements,
        compiledRulesCompared: report.compiledRulesCompared, readyPredicateCases, scratchRulesChecked: scratch.length}));
    return report;
}
module.exports = {main, auditStorage, reverse, separateStorage, checkImportNames};
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
