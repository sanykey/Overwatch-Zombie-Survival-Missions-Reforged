// Inventory and optional size probes. Compiles variants in memory; never writes src/.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

const included = ['main.opy', ...[...files['main.opy'].matchAll(/^#!include "([^"]+)"/gm)].map(m => m[1])];

// Blank quoted strings and ordinary comments, keeping columns intact. Define bodies
// remain visible because their global references become code after macro expansion.
function codeOnly(line) {
    return line.replace(/"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|#(?!\!define\b).*$/g,
        s => ' '.repeat(s.length));
}

function inventory() {
    const variables = [];
    for (const file of included) {
        files[file].split('\n').forEach((line, i) => {
            const m = codeOnly(line).match(/^globalvar\s+(\w+)/);
            if (m) variables.push({name: m[1], declaration: {file, line: i + 1}, references: []});
        });
    }
    assert.equal(new Set(variables.map(v => v.name)).size, variables.length);
    for (const file of included) {
        let block = 'module';
        const lines = files[file].split('\n');
        lines.forEach((line, i) => {
            const m = line.match(/^(?:rule |def |macro )(.+)/);
            if (m) block = line.trim().replace(/:$/, '');
            const code = codeOnly(line);
            if (/^(?:globalvar|playervar)\b/.test(code)) return;
            for (const variable of variables) {
                const re = new RegExp('(?<![.\\w])' + variable.name + '\\b', 'g');
                const hits = [...code.matchAll(re)];
                if (!hits.length) continue;
                const name = variable.name;
                const direct = new RegExp('^\\s*' + name + '(?:\\[[^\\n]*?\\])*\\s*(?:[+*/%-]?=(?!=)|\\+\\+|--)');
                const mutate = new RegExp('^\\s*' + name + '\\.(?:append|remove)\\(');
                const loop = new RegExp('^\\s*for\\s+' + name + '\\s+in\\b');
                const del = new RegExp('^\\s*del\\s+' + name + '\\[');
                variable.references.push({file, line: i + 1, block,
                    kind: direct.test(code) || mutate.test(code) || loop.test(code) || del.test(code)
                        ? 'write-or-read/write' : 'read-or-action-argument',
                    occurrences: hits.length, source: line.trim()});
            }
        });
    }
    return variables;
}

function rename(f, mapping) {
    for (const file of Object.keys(f)) {
        // Remove aliases' declarations before replacing identifiers. Ignore fields
        // on players and text literals, including identical player/global names.
        f[file] = f[file].split('\n').filter(line => {
            const m = line.match(/^globalvar\s+(\w+)/);
            return !m || !Object.hasOwn(mapping, m[1]);
        }).map(line => {
            const code = codeOnly(line);
            return line.replace(/\b\w+\b/g, (word, index) =>
                Object.hasOwn(mapping, word) && code.slice(index, index + word.length) === word &&
                !/[.\w]/.test(code[index - 1] ?? '') ? mapping[word] : word);
        }).join('\n');
    }
}

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(files);
    const variables = inventory();
    const report = {
        date: '2026-11-01', elements: baseline.elements, globals: variables.length,
        warnings: baseline.warnings,
        method: 'Included OverPy sources only; strings, comments, declarations and player fields excluded from references. Write classification is syntactic, not semantic dataflow. Macro bodies are indexed once, not per expansion. Compiled references are counted separately. No game runtime or performance measurement.',
        sha256: Object.fromEntries(included.map(file => [file,
            crypto.createHash('sha256').update(files[file]).digest('hex')])),
        variables: variables.map(v => ({...v,
            compiledOccurrences: [...baseline.result.matchAll(new RegExp('\\bGlobal\\.' + v.name + '\\b', 'g'))].length,
            referenceLines: v.references.length,
            occurrences: v.references.reduce((n, r) => n + r.occurrences, 0)}))
    };
    fs.writeFileSync(path.join(__dirname, 'global-variable-usage-2026-11-01.json'), JSON.stringify(report, null, 2) + '\n');
    const references = ['# Все обращения к глобальным переменным, 2026-11-01', '',
        'Сгенерировано `node analysis/audit-global-variables.cjs`. Только файлы, подключённые из `main.opy`.', '',
        'В строках исключены комментарии, текстовые литералы, объявления и одноимённые поля игрока. Макросы учтены один раз в исходнике; ссылки на глобальные переменные в `#!define` сохранены. Инициализаторы констант находятся по ссылке на объявление. Полные тексты строк доступны в JSON.', '',
        'Количество ссылок в скомпилированном Workshop учитывает раскрытие макросов и оптимизации. Само по себе оно не показывает частоту исполнения или время жизни.', ''];
    for (const v of report.variables) {
        references.push('## ' + v.name, '',
            `Объявление: [${v.declaration.file}:${v.declaration.line}](../src/${v.declaration.file.replaceAll(' ', '%20')}#L${v.declaration.line}). Строк обращений: ${v.referenceLines}; упоминаний: ${v.occurrences}; чтений вида Global в скомпилированном коде: ${v.compiledOccurrences}.`, '');
        const groups = new Map();
        for (const r of v.references) {
            const key = r.file + ' — ' + r.block;
            if (!groups.has(key)) groups.set(key, []);
            groups.get(key).push(r);
        }
        for (const [key, refs] of groups) references.push(`- ${key}: ` + refs.map(r =>
            `[${r.line}](../src/${r.file.replaceAll(' ', '%20')}#L${r.line})`).join(', ') + '.');
        references.push('');
    }
    fs.writeFileSync(path.join(__dirname, 'global-variable-references-2026-11-01.md'), references.join('\n'));
    console.log(JSON.stringify({elements: baseline.elements, globals: variables.length, warnings: baseline.warnings}));
    for (const v of process.argv.includes('--quiet') ? [] : report.variables) {
        const locations = [...new Set(v.references.map(r => r.file.replace('objective_types/objective_type_', 'OT/')))];
        console.log(`${v.name}: ${v.referenceLines} lines, ${v.occurrences} mentions, ${v.compiledOccurrences} compiled; ${locations.join(', ')}`);
    }
    if (process.argv.includes('--probes')) await probes(baseline);
}

async function probes(baseline) {
    const numeric = {reviveRadius: '5', startTime: '300', startCamDistance: '6.5', eliminationsNeededPerObjective: '50'};
    const literals = {
        offsetUpThreeQuartersConst: 'vect(0, 0.75, 0)', offsetUpHalfConst: 'vect(0, 0.5, 0)',
        losOffsetConst: 'vect(0, 1.2, 0)', colorChargeBatteryConst: 'rgb(236, 206, 44)',
        dummyHoldingPositionConst: 'vect(500, 500, 500)', colorKevlarConst: 'rgb(240, 129, 26)'
    };
    const paletteAliases = {startMenuZombieColors: 'objectiveEntitiesCount',
        startMenuObjectiveColors: 'objectiveCount1', startMenuEnhancementColors: 'testPos2'};
    const otherAliases = {specialEffectsStrings: 'evacDestination', specialEffectsTiming: 'evacRate',
        zombieVotes: 'queuedBioType', challengeVotes: 'biowasteTextLookUp', objectiveTypeVotes: 'biowasteColorLookUp'};
    function constants(f, values) {
        for (const [name, value] of Object.entries(values)) {
            for (const file of Object.keys(f)) f[file] = f[file].replace(new RegExp('^    ' + name + ' = [^\\n]+\\n', 'gm'), '');
            const symbol = 'AUDIT_' + name.toUpperCase();
            rename(f, {[name]: symbol});
            f['variables.opy'] += '\n#!define ' + symbol + ' ' + value + '\n';
        }
    }
    function moveExtractionSpeed(f) {
        const init = '    extractionSpeedUp = 2.5\n';
        assert(f['global_startup.opy'].includes(init));
        f['global_startup.opy'] = f['global_startup.opy'].replace(init, '');
        const destroy = '    destroyAllInWorldTexts()\n';
        assert(f['global_startup.opy'].includes(destroy));
        f['global_startup.opy'] = f['global_startup.opy'].replace(destroy, destroy + init);
        rename(f, {startMenuSpacingAngle: 'extractionSpeedUp'});
    }
    const variants = [
        ...Object.entries(numeric).map(([name, value]) => ['constant_' + name, f => constants(f, {[name]: value})]),
        ['four_numeric_constants', f => constants(f, numeric)],
        ...Object.entries(literals).map(([name, value]) => ['inline_' + name, f => constants(f, {[name]: value})]),
        ['inline_six_colors_vectors', f => constants(f, literals)],
        ['reuse_three_menu_palettes', f => rename(f, paletteAliases)],
        ['reuse_five_other_menu_slots', f => rename(f, otherAliases)],
        ['reuse_mixed_pool_for_final_counter', f => rename(f, {mixedObjectivesPool: 'evacCount'})],
        ['reuse_spacing_after_moving_extraction_init', moveExtractionSpeed],
        ['reuse_enhancement_options_with_goal_text_reset', f => {
            rename(f, {enhancementOptions: 'goalText'});
            f['global_startup.opy'] = f['global_startup.opy'].replace('    destroyAllInWorldTexts()\n', '    destroyAllInWorldTexts()\n    goalText = null\n');
        }],
        ['combined_four_constants_eight_aliases', f => {constants(f, numeric); rename(f, {...paletteAliases, ...otherAliases});}],
        ['combined_four_constants_ten_aliases', f => {
            constants(f, numeric);
            rename(f, {...paletteAliases, ...otherAliases, enhancementOptions: 'goalText'});
            f['global_startup.opy'] = f['global_startup.opy'].replace('    destroyAllInWorldTexts()\n', '    destroyAllInWorldTexts()\n    goalText = null\n');
            moveExtractionSpeed(f);
        }],
        ['combined_four_constants_nine_aliases', f => {
            constants(f, numeric);
            rename(f, {...paletteAliases, ...otherAliases, mixedObjectivesPool: 'evacCount'});
        }],
        ['combined_four_constants_eleven_aliases', f => {
            constants(f, numeric);
            rename(f, {...paletteAliases, ...otherAliases, mixedObjectivesPool: 'evacCount', enhancementOptions: 'goalText'});
            f['global_startup.opy'] = f['global_startup.opy'].replace('    destroyAllInWorldTexts()\n', '    destroyAllInWorldTexts()\n    goalText = null\n');
            moveExtractionSpeed(f);
        }]
    ];
    const results = [];
    for (const [name, transform] of variants) {
        const f = {...files};
        transform(f);
        const result = await compile(f);
        results.push({name, elements: result.elements, delta: result.elements - baseline.elements,
            globals: [...Object.values(f).join('\n').matchAll(/^globalvar /gm)].length,
            warnings: result.warnings, changedFiles: Object.keys(f).filter(file => f[file] !== files[file])});
        console.log(JSON.stringify(results.at(-1)));
    }
    fs.writeFileSync(path.join(__dirname, 'global-variable-probes-2026-11-01.json'), JSON.stringify({baseline: baseline.elements, results}, null, 2) + '\n');
}

if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
