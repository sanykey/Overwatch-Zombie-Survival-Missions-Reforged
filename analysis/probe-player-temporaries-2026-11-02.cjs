// Read-only source analysis and compilation probes. Does not change src/ or its Workshop export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {inventory, codeOnly} = require('./audit-player-variables.cjs');
const baselineRef = 'fddc95aa13042bb5cbdcfebe4295fef74a6ee151';
const playerSlotRenames = {aiLocationSlot: 'botTeleportPosition',
    botReigniteMotionSlot: 'botReigniteRisePosition', combatTargetSlot: 'botTarget'};

function baselineFiles() {
    return Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`],
            {cwd: path.resolve(__dirname, '..'), encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
}

const {checkWorkshop, args} = require('./verify-global-temporaries.cjs');

function replace(f, file, old, next) {
    assert(f[file].includes(old), file + ': missing expected source');
    f[file] = f[file].replace(old, next);
}
function scratchRole(f, file, receiver, alias, temporary) {
    const expression = new RegExp('\\b' + receiver + '\\.' + alias + '\\b', 'g');
    assert(expression.test(f[file]), alias);
    f[file] = f[file].replace(expression, temporary);
}
function rescueIndex(f) {
    scratchRole(f, 'objective_types/objective_type_survivor_rescue.opy', 'rescueSurvivor', 'rescuePathIndex', 'tmp0');
}
function reigniteSource(f) { scratchRole(f, 'zombie_types.opy', 'eventPlayer', 'botReigniteSource', 'tmp0'); }
function barrierTarget(f) { scratchRole(f, 'enhancements.opy', 'eventPlayer', 'enhancementBarrierTarget', 'tmp2'); }
function barrierList(f) { scratchRole(f, 'enhancements.opy', 'eventPlayer', 'enhancementBarrierTargetList', 'tmp2'); }
function botTargetCandidates(f, keepSnapshot = true) {
    scratchRole(f, 'subroutines.opy', 'eventPlayer', 'botPotentialTargetList', 'tmp1');
    if (keepSnapshot) replace(f, 'subroutines.opy',
        '    tmp1 = tmp1.filter(lambda x: not x.invisibilityCount)\n',
        '    tmp1 = tmp1.filter(lambda x: not x.invisibilityCount)\n    eventPlayer.botPotentialTargetList = tmp1\n');
}
function explosionTargets(f) { scratchRole(f, 'subroutines.opy', 'eventPlayer', 'explosionTargetList', 'tmp2'); }
function botVisualCleanup(f) { scratchRole(f, 'subroutines.opy', 'eventPlayer', 'visualCleanupIndex', 'tmp0'); }
function dropOutlineField(f) {
    assert(/^playervar botMutationOutlineColor\b/m.test(f['variables.opy']));
    f['variables.opy'] = f['variables.opy'].replace(/^playervar botMutationOutlineColor[^\n]*\n/m, '');
}
function capturedOutline(f) {
    dropOutlineField(f);
    // Enabled IDs are exactly a subset of 1..5 (asserted below). Make that exhaustive
    // in the CFG too, so the checker can prove that tmp2 is always initialized.
    replace(f, 'subroutines.opy', 'elif eventPlayer.botMutationId == 5:', 'else:');
    f['subroutines.opy'] = f['subroutines.opy'].replace(/^\s*eventPlayer\.botMutationOutlineColor = null\n/m, '\n');
    replace(f, 'subroutines.opy',
        'eventPlayer.startForcingOutlineFor(getAllPlayers(), true, eventPlayer.botMutationOutlineColor)',
        'eventPlayer.startForcingOutlineFor(getAllPlayers(), true, evalOnce(tmp2))');
    scratchRole(f, 'subroutines.opy', 'eventPlayer', 'botMutationOutlineColor', 'tmp2');
}
function derivedOutline(f) {
    dropOutlineField(f);
    f['subroutines.opy'] = f['subroutines.opy'].replace(/^\s*eventPlayer\.botMutationOutlineColor = [^\n]+\n/gm, '\n');
    replace(f, 'subroutines.opy', 'eventPlayer.botMutationOutlineColor',
        'evalOnce([null, Color.PURPLE, Color.VIOLET, Color.ROSE, Color.LIME_GREEN, Color.BLACK][eventPlayer.botMutationId])');
}
function applyConservativePackage(f) {
    rescueIndex(f); reigniteSource(f); barrierTarget(f); botTargetCandidates(f); capturedOutline(f);
    return f;
}

async function main() {
    const diskFiles = files;
    const sources = baselineFiles();
    // The dated probes always reproduce the reviewed revision, even after implementation.
    return probe(sources, diskFiles);
}

async function probe(files, diskFiles) {
    const {rules} = require('./verify-player-variables.cjs');
    const sourceCode = Object.values(files).flatMap(source => source.split('\n').map(codeOnly)).join('\n');
    const setup = files['global_startup.opy'].match(/availableMutationList = \[([\s\S]*?)\n    \]/);
    assert.deepEqual([...setup[1].matchAll(/^\s*(\d+) if createWorkshopSettingBool\(/gm)].map(m => Number(m[1])), [1, 2, 3, 4, 5]);
    assert(files['global_startup.opy'].includes('availableMutationList.remove(0)'));
    assert.equal([...sourceCode.matchAll(/\bavailableMutationList\b/g)].length, 5, 'Review all mutations of the available ID set');
    assert.equal([...sourceCode.matchAll(/\.botMutationId\s*=(?!=)/g)].length, 2, 'Review all mutation ID writes');
    await compiler.readyPromise;
    const baseline = await compile(files);
    const variables = inventory(files);
    const compiledRules = rules(baseline.result);
    const code = compiledRules.map(r => r.body.replace(/"(?:\\.|[^"\\])*"/g, '""')).join('\n');
    const forCounters = new Set();
    for (const match of code.matchAll(/For Player Variable\([^\n]+/g)) forCounters.add(args(match[0])[1]);
    const fields = variables.map(v => ({name: v.name, aliases: v.aliases,
        explicitCompiledReads: [...code.matchAll(new RegExp('\\.' + v.name + '\\b', 'g'))].length,
        implicitForCounterRead: forCounters.has(v.name),
        referenceLines: v.references.length,
        files: [...new Set(v.references.map(r => r.file))]}));
    const zeroExplicitReads = fields.filter(v => v.explicitCompiledReads === 0);
    assert.deepEqual(zeroExplicitReads.map(v => v.name), ['powerUpAirStrikeIndex']);
    assert(zeroExplicitReads.every(v => v.implicitForCounterRead));
    const aliasesWithoutExplicitSourceReads = variables.flatMap(v => v.aliases.flatMap(alias => {
        const references = v.references.filter(r => r.symbols.includes(alias));
        const remainingReads = references.filter(r => {
            const code = codeOnly(r.source)
                .replace(new RegExp('\\.' + alias + '\\b\\s*=(?!=)', 'g'), ' =')
                .replace(new RegExp('\\bfor ([^\\n]*?)\\.' + alias + '\\b\\s+in\\b', 'g'), 'for $1 in');
            return new RegExp('\\.' + alias + '\\b').test(code);
        });
        return remainingReads.length ? [] : [{name: alias, physicalSlot: v.name,
            implicitForCounter: references.some(r => new RegExp('\\bfor [^\\n]*\\.' + alias + '\\b\\s+in\\b').test(codeOnly(r.source))),
            references: references.map(r => ({file: r.file, line: r.line, block: r.block, source: r.source}))}];
    }));

    const variants = [
        ['rescue_path_index_to_tmp0', rescueIndex, 'safe-local-role'],
        ['reignite_source_to_tmp0', reigniteSource, 'safe-local-role'],
        ['barrier_target_to_tmp2', barrierTarget, 'safe-local-role'],
        ['barrier_list_to_tmp2', barrierList, 'safe-local-role-alternative'],
        ['bot_target_candidates_to_tmp1', botTargetCandidates, 'local-calculation; final player snapshot retained for reevaluated boss-distance visibility'],
        ['bot_target_candidates_to_tmp1_without_snapshot', f => botTargetCandidates(f, false), 'REJECTED-boss-distance-HUD-loses-persistent-candidates'],
        ['explosion_targets_to_tmp2', explosionTargets, 'local-role; other hero abilities keep physical list; review overlap on hero replacement'],
        ['bot_visual_cleanup_index_to_tmp0', botVisualCleanup, 'REJECTED-counter-live-across-wait'],
        ['outline_color_to_captured_tmp2', capturedOutline, 'candidate-with-mandatory-evalOnce'],
        ['outline_color_captured_lookup_from_mutation_id', derivedOutline, 'candidate-with-captured-derived-expression'],
        ['combined_three_local_roles_and_captured_outline', f => {
            rescueIndex(f); reigniteSource(f); barrierTarget(f); capturedOutline(f);
        }, 'combined-candidate'],
        ['combined_four_local_roles_and_captured_outline', applyConservativePackage, 'conservative-combined-candidate'],
        ['remove_bomber_primed_flag_writes', f => {
            f['zombie_types.opy'] = f['zombie_types.opy'].replace(/^\s*eventPlayer\.botIsBomberPrimed = (?:true|false)\n/gm, '\n');
        }, 'no-reader-in-Bomber-role; shared-hero-slot-lifetimes-require-review'],
        ['remove_downfallen_auxiliary_reset', f => {
            replace(f, 'zombie_types.opy', '    eventPlayer.botAuxiliaryState = null\n', '');
        }, 'unused-secondary-state-in-Sigma-role; keep-respawn-reset'],
        ['remove_boss_return_position_writes_size_only', f => {
            f['objective_types/objective_type_bosses.opy'] = f['objective_types/objective_type_bosses.opy']
                .replace(/^\s*eventPlayer\.botReturnPosition = [^\n]+\n/gm, '\n');
        }, 'REJECTED-as-unproven-concurrent-slot-lifetime']
    ];
    const probes = [];
    for (const [name, transform, assessment] of variants) {
        const f = {...files}; transform(f);
        const result = await compile(f);
        assert.deepEqual(result.warnings, []);
        let checked = [], lifetimeRejection = null;
        try { checked = checkWorkshop(result.result); }
        catch (error) {
            if (assessment !== 'REJECTED-counter-live-across-wait') throw error;
            assert.match(error.message, /tmp0 live across Wait\(/);
            lifetimeRejection = error.message;
        }
        assert.equal(lifetimeRejection !== null, assessment === 'REJECTED-counter-live-across-wait');
        if (name.includes('captured_outline') || name === 'outline_color_to_captured_tmp2') {
            const captures = [...result.result.matchAll(/Start Forcing Player Outlines\([^\n]*Global\.tmp2[^\n]*/g)];
            assert(captures.length > 0);
            for (const capture of captures) assert(args(capture[0])[3].includes('Evaluate Once(Global.tmp2)'), 'Outline scratch must be captured');
        }
        probes.push({name, assessment, elements: result.elements, delta: result.elements - baseline.elements,
            globals: (Object.values(f).join('\n').match(/^globalvar /gm) ?? []).length,
            playerVariables: (Object.values(f).join('\n').match(/^playervar /gm) ?? []).length,
            scratchRulesChecked: checked.length, lifetimeRejection, warnings: result.warnings,
            changedFiles: Object.keys(f).filter(file => f[file] !== files[file])});
        console.log(JSON.stringify(probes.at(-1)));
    }
    // The outline color is an exact function of mutation IDs 0..5, so it need not have its own field.
    for (const [id, color] of [[1, 'PURPLE'], [2, 'VIOLET'], [3, 'ROSE'], [4, 'LIME_GREEN'], [5, 'BLACK']]) {
        const branch = files['subroutines.opy'].match(new RegExp('(?:if|elif) eventPlayer.botMutationId == ' + id + ':([\\s\\S]*?)(?=\\n        (?:elif|#Mutation))'));
        assert(branch && branch[1].includes('eventPlayer.botMutationOutlineColor = Color.' + color), 'Mutation color table changed: ' + id);
    }
    assert(files['subroutines.opy'].includes('eventPlayer.stopForcingOutlineFor(getAllPlayers())'));
    for (const [file, original] of Object.entries(diskFiles)) {
        assert.equal(fs.readFileSync(path.join(__dirname, '../src', file), 'utf8').replace(/\r\n/g, '\n'), original, 'Source changed during read-only probes: ' + file);
    }
    const report = {
        date: '2026-11-02', baselineRef, baseline: {globals: 99, playerVariables: 108, elements: baseline.elements},
        method: 'Included source field inventory and compiled explicit reads, with implicit For Player Variable counter reads. Probes compile in memory and reuse scratch CFG/reevaluation checks. Outline capture checked separately. Alias names alone do not establish dead stores; all aliases and concurrent callers must be considered. No src files modified; no in-game run.',
        fields, zeroExplicitReads, aliasesWithoutExplicitSourceReads, probes,
        sha256: Object.fromEntries(Object.entries(files).map(([file, source]) => [file, crypto.createHash('sha256').update(source).digest('hex')]))
    };
    fs.writeFileSync(path.join(__dirname, 'player-variable-lifetimes-2026-11-02.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({globals: 99, playerVariables: 108, baselineElements: baseline.elements,
        zeroExplicitReads: zeroExplicitReads.map(v => v.name), unusedWholeFieldsFound: 0, probes: probes.length, sourceWritten: false}));
    console.log(JSON.stringify({aliasesWithoutExplicitSourceReads}));
}
module.exports = {baselineRef, baselineFiles, applyConservativePackage, playerSlotRenames};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
