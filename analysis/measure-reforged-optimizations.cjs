// Analysis only: builds candidate variants in memory, never writes src/.
// Historical experiments: menu_hud failed gameplay validation; the direct-ID loop also hid the entire group.
// All global_start_menu.opy changes were reverted; further edits are deferred until a new user request.
// powerup_hud was reported working by the user. Compilation alone is not gameplay validation.
// After implementation: node analysis/measure-reforged-optimizations.cjs --baseline-ref ec11473 [path/to/overpy.js]
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const args = process.argv.slice(2);
const refIndex = args.indexOf('--baseline-ref');
const baselineRef = refIndex < 0 ? null : args.splice(refIndex, 2)[1];
if (refIndex >= 0 && !baselineRef) throw new Error('--baseline-ref requires a Git revision');
const readSource = name => baselineRef
    ? execFileSync('git', ['show', `${baselineRef}:src/${name}`], { cwd: root })
    : fs.readFileSync(path.join(src, name));
const files = Object.fromEntries(fs.readdirSync(src).filter(f => f.endsWith('.opy'))
    .map(f => [f, readSource(f).toString('utf8').replace(/\r\n/g, '\n')]));
function compilerPath() {
    if (args[0]) return path.resolve(args[0]);
    const dir = path.join(process.env.USERPROFILE, '.vscode/extensions');
    const name = fs.readdirSync(dir).filter(n => n.startsWith('zezombye.overpy-'))
        .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }))[0];
    return path.join(dir, name, 'npm/overpy.js');
}
function flatten(f) {
    return f['main.opy'].replace(/^#!include "([^"]+)".*$/gm, (_, name) => f[name].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/^#!writeToOutputFile.*\n/gm, '');
}
function editBlock(f, file, start, transform) {
    const text = f[file], i = text.indexOf(start);
    assert(i >= 0, start);
    const tail = text.slice(i), next = tail.slice(1).search(/\n(?:rule |def )/);
    const end = next < 0 ? text.length : i + next + 2;
    f[file] = text.slice(0, i) + transform(text.slice(i, end)) + text.slice(end);
}
function splitArgs(text) {
    const args = []; let depth = 0, quote = '', last = 0;
    for (let i = 0; i < text.length; i++) {
        const c = text[i];
        if (quote) { if (c === '\\') i++; else if (c === quote) quote = ''; }
        else if (c === '"' || c === "'") quote = c;
        else if ('([{'.includes(c)) depth++;
        else if (')]}'.includes(c)) depth--;
        else if (c === ',' && !depth) { args.push(text.slice(last, i).trim()); last = i + 1; }
    }
    args.push(text.slice(last).trim()); return args;
}
function select(values, index) {
    return values.every(v => v === values[0]) ? values[0] : `[${values.join(', ')}][${index}]`;
}
const variants = {
    delimiters(f) {
        for (const name of Object.keys(f)) f[name] = f[name].replace(/^rule "[^"\n]+":\n(?:    @[^\n]*\n)+/gm, block => block.includes('@Delimiter\n') ? '' : block);
    },
    aggressive(f) { f['main.opy'] = '#!optimizeForSizeAggressive\n' + f['main.opy']; },
    powerup_assignment(f) {
        editBlock(f, 'power_ups.opy', 'def powerUpAssignment():', b => {
            const colors = [...b.matchAll(/Effect\.ORB, (Color\.\w+),/g)].map(m => m[1]);
            const names = [...b.matchAll(/createInWorldText\(getAllPlayers\(\), ("[^"]+"),/g)].map(m => m[1]);
            assert.equal(colors.length, 13); assert.equal(names.length, 13);
            const index = 'powerUpIDs[len(powerUpEffect)] - 1';
            return `def powerUpAssignment():\n    @Name "powerUpAssignment"\n    if powerUpIDs[len(powerUpEffect)] >= 1 and powerUpIDs[len(powerUpEffect)] <= 13:\n        createEffect(getAllPlayers(), Effect.ORB, [${colors.join(', ')}][${index}], powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)\n        createInWorldText(getAllPlayers(), [${names.join(', ')}][${index}], powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)\n\n\n`;
        });
    },
    powerup_hud(f) {
        f['variables.opy'] += '\nglobalvar optPowerupHudIndex\nglobalvar optPowerupHudColors\n';
        editBlock(f, 'power_ups.opy', 'rule "EFFECT/TEXT (PERMANENT)":', b => {
            const lines = b.split('\n').filter(l => l.trimStart().startsWith('hudText('));
            assert.equal(lines.length, 13);
            const args = lines.map(l => splitArgs(l.trim().slice(8, -1)));
            const merged = args[0].map((_, i) => select(args.map(a => a[i]), 'evalOnce(optPowerupHudIndex)'));
            merged[0] = 'getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == evalOnce(optPowerupHudIndex) + 1)';
            const colors = args.map(a => { assert(a[6] === a[7] && a[7] === a[8]); return a[6]; });
            merged[6] = merged[7] = merged[8] = 'optPowerupHudColors[evalOnce(optPowerupHudIndex)]';
            return b.slice(0, b.indexOf('    #Cure hud text')) + `    optPowerupHudColors = [${colors.join(', ')}]\n    for optPowerupHudIndex in range(13):\n        hudText(${merged.join(', ')})\n\n\n`;
        });
    },
    menu_hud(f) {
        f['variables.opy'] += '\nglobalvar optMenuHudIndex\n';
        editBlock(f, 'global_start_menu.opy', 'rule "EFFECTS/TEXTS":', b => {
            const rows = b.split('\n').filter(l => l.trimStart().startsWith('hudText(')).map(l => splitArgs(l.trim().slice(8, -1)));
            assert.equal(rows.length, 31);
            const groups = [rows.slice(0, 6), rows.slice(6, 13), rows.slice(13, 20), rows.slice(20)];
            let body = '';
            for (const [groupIndex, group] of groups.entries()) {
                const merged = group[0].map((_, i) => select(group.map(a => a[i]), 'evalOnce(optMenuHudIndex)'));
                const values = group.map(a => a[0].match(/ == (.*)\)$/)[1]);
                const lhs = group[0][0].match(/^(.+) == /)[1];
                merged[0] = `${lhs} == ${select(values, 'evalOnce(optMenuHudIndex)')})`;
                if (groupIndex < 3) {
                    assert(group.slice(1).every(a => a[3] === group[0][3] + ' if voting else []'));
                    merged[3] = `${group[0][3]} if voting or evalOnce(optMenuHudIndex) == 0 else []`;
                }
                if (groupIndex > 0) {
                    const colors = group.map(a => { assert(a[6] === a[7] && a[7] === a[8]); return a[6]; });
                    const variable = `optMenuHudColors${groupIndex}`;
                    f['variables.opy'] += `\nglobalvar ${variable}\n`;
                    body += `    ${variable} = [${colors.join(', ')}]\n`;
                    merged[6] = merged[7] = merged[8] = `${variable}[evalOnce(optMenuHudIndex)]`;
                }
                // Only the first group has changing colors. Other flags stay verbatim.
                merged[9] = group.some(a => a[9] === 'HudReeval.VISIBILITY_STRING_AND_COLOR') ? 'HudReeval.VISIBILITY_STRING_AND_COLOR' : group[0][9];
                body += `    for optMenuHudIndex in range(${group.length}):\n        hudText(${merged.join(', ')})\n`;
            }
            return b.slice(0, b.indexOf('    hudText(')) + body + '\n\n';
        });
    },
    difficulty_dedup(f) {
        editBlock(f, 'subroutines.opy', 'def setDifficulty():', b => {
            const arrays = [...b.matchAll(/^( +)botHealthValues = (\[[^\n]+\])/gm)];
            assert.equal(arrays.length, 5);
            const common = arrays[1][2];
            b = b.replace('        #Difficulty: 1 Player "Normal"', `        botHealthValues = ${common}\n        #Difficulty: 1 Player "Normal"`);
            b = b.replace(`            botHealthValues = ${common}\n`, '');
            b = b.replace(`            botHealthValues = ${arrays[2][2]}`, '            botHealthValues[18] = 750');
            b = b.replace(`            botHealthValues = ${arrays[4][2]}`, '            botHealthValues[18] = 1000');
            const durations = [...b.matchAll(/^ +biteDurations = (\[[^\n]+\])/gm)];
            assert.equal(durations[3][1], durations[4][1]);
            b = b.replace('        #Difficulty: 1 Player "Normal"', `        biteDurations = ${durations[3][1]}\n        #Difficulty: 1 Player "Normal"`);
            b = b.replaceAll(`            biteDurations = ${durations[3][1]}\n`, '');
            return b;
        });
    },
    vote_modulo(f) {
        for (const [field, table] of [['playerMenuStatus[2]', 'challengeVotes'], ['playerMenuStatus[3]', 'zombieVotes'], ['playerMenuStatus[4]', 'objectiveTypeVotes'], ['enhancementValues[0]', 'enhancementOptions']]) {
            const fieldRE = field.replace(/[\[\]]/g, '\\$&');
            for (const reverse of [false, true]) {
                const pattern = reverse
                    ? `( +)if eventPlayer\\.${fieldRE} > 0:\\n\\1    eventPlayer\\.${fieldRE} \\+= -1\\n\\1else:\\n\\1    eventPlayer\\.${fieldRE} = len\\(${table}\\) - 1`
                    : `( +)if eventPlayer\\.${fieldRE} < len\\(${table}\\) - 1:\\n\\1    eventPlayer\\.${fieldRE}\\+\\+\\n\\1else:\\n\\1    eventPlayer\\.${fieldRE} = 0`;
                const re = new RegExp(pattern, 'g');
                assert.equal([...f['player_start_menu.opy'].matchAll(re)].length, 2);
                f['player_start_menu.opy'] = f['player_start_menu.opy'].replace(re, (_, indent) => `${indent}eventPlayer.${field} = (eventPlayer.${field} + ${reverse ? `len(${table}) - 1` : '1'}) % len(${table})`);
            }
        }
    },
    barricade_slice(f) {
        const old = 'eventPlayer.enhancementValues.filter(lambda _, i: i >= 7 and i <= 8)';
        assert.equal(f['enhancements.opy'].split(old).length - 1, 2);
        f['enhancements.opy'] = f['enhancements.opy'].replaceAll(old, 'eventPlayer.enhancementValues.slice(7, 2)');
    },
    extraction_columns(f) {
        editBlock(f, 'subroutines.opy', 'def globalObjectiveEntityManagement():', b => {
            const start = b.indexOf('            #Extraction point boundary 1');
            const end = b.indexOf('            #Extraction icon', start);
            assert(start > 0 && end > start);
            return b.slice(0, start) + '            for objectiveEntityCount in range(3):\n                createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, [-2, 22, 46][objectiveEntityCount], 0), objectiveRad, EffectReeval.VISIBILITY)\n                objectiveEntities.append(getLastCreatedEntity())\n' + b.slice(end);
        });
    },
    turret_legs(f) {
        f['variables.opy'] += '\nplayervar optTurretLeg\n';
        editBlock(f, 'supply_drops.opy', 'def sentryTurret():', b => {
            const start = b.indexOf('        createBeam(getAllPlayers(), Beam.GRAPPLE');
            const end = b.indexOf('        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + (');
            assert(start > 0 && end > start);
            return b.slice(0, start) + '        for eventPlayer.optTurretLeg in range(3):\n            createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionFromAngles(evalOnce(eventPlayer.optTurretLeg) * 120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)\n            eventPlayer.powerUpEffects[51 + eventPlayer.optTurretLeg] = getLastCreatedEntity()\n' + b.slice(end);
        });
    },
};
async function main() {
    const cp = compilerPath(), compiler = require(cp); await compiler.readyPromise;
    const output = {
        compilerVersion: JSON.parse(fs.readFileSync(path.join(path.dirname(cp), 'package.json'), 'utf8')).version,
        compilerPath: cp,
        baselineRef,
        method: 'Candidates compiled separately from baseline, in memory. No gameplay validation. Sources in src/ are not modified.',
        knownGameplayRegressions: { menu_hud: 'All vote rows visible in game; direct-ID loop for Zombie Mode then hid the entire group. All global_start_menu.opy changes reverted on user request. Historical compilation counts do not establish gameplay equivalence.' },
        deferredVariants: ['menu_hud'],
        userReportedWorkingVariants: ['powerup_hud'],
        warningsSuppressedByMainSource: true,
        sourceSha256: Object.fromEntries(Object.keys(files).map(n => [n, crypto.createHash('sha256').update(readSource(n)).digest('hex')])),
        results: [],
    };
    const configs = [['baseline', []], ...Object.keys(variants).map(k => [k, [k]]), ['combined', Object.keys(variants).filter(k => k !== 'aggressive')], ['combined_aggressive', Object.keys(variants)]];
    for (const [name, choices] of configs) {
        const f = { ...files }; for (const choice of choices) variants[choice](f);
        const saved = { log: console.log, warn: console.warn, error: console.error };
        let result;
        try {
            console.log = console.warn = console.error = () => {};
            const r = await compiler.compile(flatten(f), 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
            const rules = [...r.result.slice(0, r.result.indexOf('*/')).matchAll(/^\s*(\d+): rule "(.*)" \(/gm)].map(m => ({ name: m[2], elements: +m[1] }));
            result = { name, choices, elements: r.nbElements, saved: output.results.length ? output.results[0].elements - r.nbElements : 0, warnings: r.encounteredWarnings.length, rules };
        } catch (e) { result = { name, error: e.message }; }
        finally { Object.assign(console, saved); }
        output.results.push(result);
        console.log(JSON.stringify({ ...result, rules: undefined }));
    }
    if (!baselineRef) assert.equal(output.results[0].elements, Number(fs.readFileSync(path.join(src, 'main.ws.txt'), 'utf8').match(/total (\d+)/)[1]), 'Baseline differs from current debug header');
    assert(output.results.every(r => Number.isInteger(r.elements)), 'Some candidates did not compile');
    const groupRules = rules => rules.reduce((o, r) => { o[r.name] = (o[r.name] || 0) + r.elements; return o; }, {});
    const baseline = groupRules(output.results[0].rules);
    for (const r of output.results.slice(1)) {
        if (!r.rules) continue;
        const after = groupRules(r.rules);
        r.changedRules = [...new Set([...Object.keys(baseline), ...Object.keys(after)])].map(name => ({name, before: baseline[name] || 0, after: after[name] || 0})).filter(x => x.before !== x.after);
        delete r.rules;
    }
    output.comparisonWithSameSizeDirective = [];
    for (const [name, folder] of [['ZSMM', 'ZSMM (786TW)'], ['Remix', 'ZSMM-remixed (QZD5F)'], ['Lordy', "Lordy's ZSM (KT6ZY)"], ['Chaos', 'ZSM Chaos (A3YV07)']]) {
        const dir = path.join(root, 'ZSM examples', folder);
        const filename = fs.readdirSync(dir).find(f => f.endsWith('.opy'));
        const source = fs.readFileSync(path.join(dir, filename), 'utf8').replace(/^#!optimizeStrict.*$/gm, '#!optimizeForSize');
        const saved = { log: console.log, warn: console.warn, error: console.error };
        try {
            console.log = console.warn = console.error = () => {};
            const r = await compiler.compile(source, 'en-US', dir.replace(/\\/g, '/') + '/', filename);
            output.comparisonWithSameSizeDirective.push({name, elements: r.nbElements, warnings: r.encounteredWarnings.length});
        } finally { Object.assign(console, saved); }
    }
    console.log(JSON.stringify(output.comparisonWithSameSizeDirective));
    fs.writeFileSync(path.join(__dirname, 'Reforged-optimization-probes.json'), JSON.stringify(output, null, 2) + '\n');
}
main().catch(e => { console.error(e); process.exitCode = 1; });
