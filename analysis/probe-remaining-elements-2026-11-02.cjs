// Read-only for src/: compile isolated candidates in memory, then a combined build.
// Run: node analysis/probe-remaining-elements-2026-11-02.cjs
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files: loadedFiles, compile, compiler, src} = require('./measure-further-optimizations.cjs');
// Keep the original proposal reproducible after some candidates have been implemented.
const refIndex = process.argv.indexOf('--baseline-ref');
const baselineRef = refIndex < 0 ? '20881df2c6e284fe7b3da06e1d57655a8c372d25' : process.argv[refIndex + 1];
const files = Object.fromEntries(Object.keys(loadedFiles).map(file => [file,
    execFileSync('git', ['show', `${baselineRef}:src/${file}`], {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')]));

function replace(f, file, before, after) {
    assert(f[file].includes(before), `${file}: missing ${before.slice(0, 90)}`);
    f[file] = f[file].replace(before, after);
}
function replaceEverywhere(f, before, after) {
    let count = 0;
    for (const file of Object.keys(f)) {
        count += f[file].split(before).length - 1;
        f[file] = f[file].replaceAll(before, after);
    }
    assert(count > 0, before);
    return count;
}
function extract(f, file, body, name, expected) {
    const lines = f[file].split('\n');
    const wanted = body.split('\n');
    let count = 0;
    for (let i = 0; i < lines.length; i++) {
        const indent = lines[i].match(/^ */)[0];
        if (wanted.every((s, j) => lines[i + j] === indent + s)) {
            lines.splice(i, wanted.length, indent + name + '()');
            count++;
        }
    }
    assert.equal(count, expected, name);
    f[file] = lines.join('\n') + `\n\ndef ${name}():\n` + wanted.map(s => '    ' + s).join('\n') + '\n';
    f[file] = f[file].replace(/^(subroutine \w+)/m, 'subroutine ' + name + '\n$1');
    return count;
}

const variants = {
    item_entity_fields(f) {
        const all = Object.values(f).join('\n');
        const indices = [...new Set([...all.matchAll(/\.powerUpEntityIdList\[(\d+)\]/g)].map(m => +m[1]))]
            .filter(i => i < 50 || i > 54).sort((a, b) => a - b);
        // The only computed accesses are the turret's creation and cleanup loops.
        assert.deepEqual([...all.matchAll(/\.powerUpEntityIdList\[([^\]]+)\]/g)]
            .map(m => m[1]).filter(s => !/^\d+$/.test(s)),
            ['51 + turretLegVisualIndex', 'turretCleanupEffectIndex']);
        assert(all.includes('for turretLegVisualIndex in range(3):'));
        assert(all.includes('for turretCleanupEffectIndex in range(50, 55):'));
        for (const index of indices) {
            const name = 'probeItemEntity' + index;
            replaceEverywhere(f, `.powerUpEntityIdList[${index}]`, '.' + name);
            f['variables.opy'] += `\nplayervar ${name}\n`;
        }
        return {indices, addedPlayerSlots: indices.length, retainedIndexedSlots: '50..54'};
    },
    vote_fields(f) {
        const pairs = [
            ['CHALLENGE_VOTE', 'probeChallengeVote'],
            ['ZOMBIE_MODE_VOTE', 'probeZombieVote'],
            ['OBJECTIVE_TYPE_VOTE', 'probeObjectiveVote'],
        ];
        for (const [index, field] of pairs)
            replaceEverywhere(f, `.pregameVoteList[PlayerMenuStatusField.${index}]`, '.' + field);
        replace(f, 'player_start_menu.opy', '        eventPlayer.pregameVoteList = [0, 0, 0, 0]',
            pairs.map(([, field]) => `        eventPlayer.${field} = 0`).join('\n'));
        replace(f, 'player_start_menu.opy',
            'eventPlayer.pregameVoteList.slice(PlayerMenuStatusField.CHALLENGE_VOTE, 3).all(lambda x: x == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE)',
            'eventPlayer.probeChallengeVote == 0 and eventPlayer.probeZombieVote == 0 and eventPlayer.probeObjectiveVote == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE');
        replace(f, 'variables.opy', '#!define pregameVoteList actorTeamSlot3',
            '#!define probeChallengeVote actorTeamSlot3\nplayervar probeZombieVote\nplayervar probeObjectiveVote');
        assert(!Object.values(f).some(s => /\.pregameVoteList\b/.test(s)));
        return {addedPlayerSlots: 2, reusedSlot: 'actorTeamSlot3 (challenge vote)'};
    },
    trade_fields(f) {
        replaceEverywhere(f, '.powerUpTradeDataList[0]', '.probeTradePosition');
        replaceEverywhere(f, '.powerUpTradeDataList[2]', '.probeTradePreviousItem');
        replace(f, 'variables.opy', '#!define powerUpTradeDataList actorTeamSlot3',
            '#!define probeTradePosition actorTeamSlot3\nplayervar probeTradePreviousItem');
        assert(!Object.values(f).some(s => /\.powerUpTradeDataList\b/.test(s)));
        return {addedPlayerSlots: 1, reusedSlot: 'actorTeamSlot3 (trade position, after voting)'};
    },
    item_hud_format(f) {
        const s = f['power_ups.opy'];
        const start = s.indexOf('            [\n                "Hold [{0}] to stop');
        assert(start >= 0);
        const endMarker = '            ][evalOnce(powerUpHudItemIndex)],';
        const end = s.indexOf(endMarker, start) + endMarker.length;
        const block = s.slice(start, end);
        assert.equal((block.match(/\.format\(inputBindingString\(Button.INTERACT\)\)/g) || []).length, 13);
        const templates = [...block.matchAll(/"([^"\n]*)"/g)].map(m => m[1]);
        const suffixes = templates.map(t => t.slice(t.indexOf('] ') + 2));
        for (const binding of ['F', 'Mouse 4', 'Interact']) {
            assert.deepEqual(templates.map(t => t.replace('{0}', binding)), suffixes.map((suffix, i) =>
                `${i === 1 ? 'Look at a teammate and hold' : 'Hold'} [${binding}] ${suffix}`));
        }
        // OverPy requires a literal .format receiver, so factor the common parts
        // into one literal and retain each exact suffix in the lookup table.
        const next = '            "{0} [{1}] {2}".format("Look at a teammate and hold" if evalOnce(powerUpHudItemIndex) == 1 else "Hold", inputBindingString(Button.INTERACT), [\n' +
            suffixes.map(s => '                ' + JSON.stringify(s)).join(',\n') +
            '\n            ][evalOnce(powerUpHudItemIndex)]),';
        replace(f, 'power_ups.opy', block, next);
        return {formatsBefore: 13, formatsAfter: 1};
    },
    ai_reset_blocks(f) {
        const counts = [];
        for (const [name, first, second, expected] of [
            ['probeRestoreMovementA', 'botIsThrottleOverridden', 'botIsFacingOverridden', 5],
            ['probeRestoreMovementB', 'botIsFacingOverridden', 'botIsThrottleOverridden', 4],
        ]) counts.push(extract(f, 'zombie_types.opy',
            `eventPlayer.${first} = false\neventPlayer.${second} = false\nstartRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)`, name, expected));
        return {occurrences: counts, newSubroutines: 2, waitsInExtractedBlocks: 0};
    },
    spawn_cleanup(f) {
        return {occurrences: extract(f, 'bots_game_in_progress.opy',
            'del botSpawnWaypointList[botSpawnPointList.index(eventPlayer.botTeleportPosition)]\n' +
            'del botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.botTeleportPosition)]\n' +
            'botSpawnPointList.remove(eventPlayer.botTeleportPosition)', 'probeRemoveSpawnPoint', 2),
            newSubroutines: 1, waitsInExtractedBlocks: 0};
    },
    shared_item_palette(f) {
        const array = '[Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE]';
        assert.equal(replaceEverywhere(f, array, 'probeItemColorList'), 2);
        f['variables.opy'] += '\nglobalvar probeItemColorList = ' + array + '\n';
        return {addedGlobalSlots: 1};
    },
};

async function main() {
    const diskBefore = Object.fromEntries(Object.keys(files).map(file =>
        [file, fs.readFileSync(path.join(src, file), 'utf8')]));
    await compiler.readyPromise;
    const baseline = await compile(files);
    const count = f => {
        const s = Object.values(f).join('\n');
        return {globalVariables: (s.match(/^globalvar /gm) || []).length,
            playerVariables: (s.match(/^playervar /gm) || []).length};
    };
    const report = {date: '2026-11-02', compiler: 'OverPy 9.7.20', baselineRef,
        baseline: {elements: baseline.elements, ...count(files)},
        srcChanged: false, inGameValidated: false, runtimeBenchmarked: false,
        warningsSuppressedByMainSource: true,
        sourceSha256: Object.fromEntries(Object.entries(files).map(([n,s]) => [n, crypto.createHash('sha256').update(s).digest('hex')])),
        candidates: []};
    console.log(JSON.stringify(report.baseline));
    for (const [name, transform] of Object.entries(variants)) {
        const f = {...files};
        try {
            const detail = transform(f);
            const r = await compile(f);
            const row = {name, elements: r.elements, saved: baseline.elements - r.elements,
                ...count(f), detail, emittedWarnings: r.warnings.length};
            report.candidates.push(row);
            console.log(JSON.stringify(row));
        } catch (error) {
            const row = {name, error: String(error.stack || error)};
            report.candidates.push(row);
            console.log(JSON.stringify(row));
        }
    }
    const combined = {...files};
    for (const transform of Object.values(variants)) transform(combined);
    const result = await compile(combined);
    assert.deepEqual(result.warnings, []);
    report.combined = {elements: result.elements, saved: baseline.elements - result.elements, ...count(combined)};
    assert(report.combined.globalVariables <= 128 && report.combined.playerVariables <= 128);
    for (const [file, original] of Object.entries(diskBefore))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8'), original);
    console.log(JSON.stringify({combined: report.combined}));
    fs.writeFileSync(path.join(__dirname, 'remaining-elements-probes-2026-11-02.json'), JSON.stringify(report, null, 2) + '\n');
}
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
module.exports = {variants};
