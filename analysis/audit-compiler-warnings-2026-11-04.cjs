// Compile with original includes; preserve source locations and never write Workshop output.
// --write saves audit evidence only under analysis/.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const extdir = path.join(process.env.USERPROFILE, '.vscode', 'extensions');
const extension = fs.readdirSync(extdir).filter(n => n.startsWith('zezombye.overpy-'))
    .sort((a, b) => b.localeCompare(a, undefined, {numeric: true}))[0];
assert(extension, 'OverPy extension was not found');
const compiler = require(path.join(extdir, extension, 'npm', 'overpy.js'));
const read = name => fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n');
const four = ['w_start_rule_crash', 'w_ow2_rule_condition_chase', 'w_cancel_contrary_motion', 'w_closest_player'];
const sourceFiles = {};
function walk(dir, prefix = '') {
    for (const entry of fs.readdirSync(dir, {withFileTypes: true})) {
        const name = prefix + entry.name;
        if (entry.isDirectory()) walk(path.join(dir, entry.name), name + '/');
        else if (/\.(opy|js)$/.test(name)) sourceFiles[name] = read(name);
    }
}
walk(src);

async function compile(main) {
    const saved = {log: console.log, warn: console.warn, error: console.error};
    try {
        console.log = console.warn = console.error = () => {};
        return await compiler.compile(main.replace(/^#!writeToOutputFile.*$/gm, ''), 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { Object.assign(console, saved); }
}

function blockAt(file, line) {
    const before = sourceFiles[file].split('\n').slice(0, line).join('\n');
    const matches = [...before.matchAll(/^(rule|def|macro) (.+):\s*$/gm)];
    return matches.at(-1)?.[0].trim() || '(top level)';
}
function targetRule(result, target) {
    const all = Object.values(sourceFiles).join('\n');
    const escaped = target.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const name = all.match(new RegExp('^def ' + escaped + '\\(\\):\\n\\s+@Name "([^"\\n]+)"', 'm'))?.[1] || target;
    const start = result.indexOf('rule ("' + name + '")');
    assert(start >= 0, target);
    const end = result.indexOf('\n}\n', start);
    return {name, code: result.slice(start, end + 3)};
}

const startRatings = [
    ['Низкая', 'Прямой риск не установлен: собственных ожиданий нет; диагностика транзитивна'],
    ['Низкая', 'Прямой риск не установлен: собственных ожиданий нет; диагностика транзитивна'],
    ['Низкая', 'Прямой риск не установлен: собственных ожиданий нет; диагностика транзитивна'],
    ['Средняя', 'Условный: повтор предматчевой инициализации при ожидающем глобальном исполнителе'],
    ['Низкая', 'Новый путь обычно без ожидания; возможен перезапуск старого короткого ожидания'],
    ['Средняя', 'Условный, короткое окно: wait() в переходе таймера 15 -> 10'],
    ['Высокая', 'Доступный повтор в wait(1); накопительный риск при серии перезапусков'],
    ['Средняя', 'Условный: отмена может прервать короткий wait предыдущей готовности'],
    ['Средняя', 'На границе конца голосования; в обычной ветке собственного ожидания нет'],
    ['Средняя', 'Короткий wait цели при готовности; пауза 2 с принадлежит вызывающему правилу'],
    ['Низкая при штатной работе', 'Штатный повтор не найден; нужен дополнительный повторный вход в переход'],
    ['Средняя', 'Есть при перекрытии операции воскрешения; окно обычно короче таймаута 3 с'],
    ...Array.from({length: 10}, () => ['Высокая', 'Доступен повтор тем же игроком в длительном ожидании; накопительный риск']),
];

const chaseRatings = {
    'objective_types/objective_type_extraction_point.opy:16': ['Корректно: фиксированный радиус', 'В эвакуации objectiveRad = 10; Showdown останавливает его chase при завершении. Не дефект.'],
    'objective_types/objective_type_extraction_point.opy:34': ['Промежуточный порог; проверить', '300 -> 0 пересекает 200 до конца chase. Возможна задержка включения заражения снаружи.'],
    'objective_types/objective_type_extraction_point.opy:35': ['Промежуточная граница; проверить', 'Радиус пересекает расстояние до неподвижного игрока до нуля. Не объявлять воспроизведённой ошибкой без игры.'],
    'objective_types/objective_type_extraction_point.opy:72': ['Корректно: конечное значение', 'Поражение при extractionZoneRad <= 0 проверяет назначение chase, равное 0. Не дефект.'],
    'objective_types/objective_type_showdown.opy:14': ['Промежуточная граница; проверить', 'Радиус пересекает расстояние до игрока/бота. Конец отдельного шага chase может дать нужную переоценку.'],
    'objective_types/objective_type_biomorphing.opy:147': ['Корректно: другой жизненный цикл', 'Для Biomorphing radius = 3.5, активного Showdown chase нет. Не дефект.'],
    'objective_types/objective_type_survivor_rescue.opy:83': ['Корректно: прямые присваивания', 'Rescue использует значения 10/30 и восстановление присваиванием. Не дефект chase.'],
    'objective_types/objective_type_kill_zone.opy:7': ['Корректно: фиксированное значение и событие', 'Kill Zone использует radius = 20; проверка выполняется при final blow. Не дефект chase.'],
    'objective_types/objective_type_satellite_uplink.opy:113': ['Корректно: фиксированный радиус', 'Satellite использует radius = 3. Активный Showdown chase не должен переживать нормальный переход. Не дефект.'],
    'zombie_types.opy:1129': ['Корректно: конечное значение', 'Hazard ждёт botAbilityCooldown == 0, назначение chase тоже 0. У босса дополнительная ветка разрешает действие независимо.'],
    'zombie_types.opy:1390': ['Промежуточная граница только на Showdown; проверить', 'Для остальных типов радиус фиксирован; на Showdown достижение конца шага может устранить задержку.'],
    'enhancements.opy:171': ['Корректно: исключающиеся роли', 'Условие относится к Zombie Hybrid; chase infectionLevel запущен в ветке else для остальных улучшений. Не дефект.'],
    'enhancements.opy:271': ['Корректно: порог обеспечен присваиванием', 'Перед регенерацией из 0 устанавливается HP = 1; > 0 уже истинно. При контакте chase останавливается. Дожидаться 10000 для входа не требуется.'],
    'enhancements.opy:534': ['Корректно: конечное значение', 'P.U.P. проверяет cooldown <= 0 при назначении 0. Временная скорость 0 при луче намеренна. Не дефект.'],
};

async function main() {
    await compiler.readyPromise;
    const originalMain = read('main.opy');
    const baseline = await compile(originalMain);
    const counters = {w_start_rule_crash: 0, w_ow2_rule_condition_chase: 0, w_cancel_contrary_motion: 0, w_closest_player: 0};
    const ids = {w_start_rule_crash: 'SR', w_ow2_rule_condition_chase: 'CH', w_cancel_contrary_motion: 'IM', w_closest_player: 'CL'};
    const diagnostics = baseline.encounteredWarnings.map(w => {
        const type = w.message.match(/\((w_[^)]+)\)/)?.[1];
        assert(type && Object.hasOwn(counters, type), w.message);
        const number = ++counters[type];
        const leaf = [...w.fileStack].reverse().find(f => f.path?.replace(/\\/g, '/').startsWith(src.replace(/\\/g, '/') + '/'));
        assert(leaf, w.message);
        const file = path.relative(src, leaf.path).replace(/\\/g, '/');
        const result = {id: ids[type] + String(number).padStart(2, '0'), type, file, line: leaf.startLine,
            col: leaf.startCol, owner: blockAt(file, leaf.startLine), sourceLine: sourceFiles[file].split('\n')[leaf.startLine - 1],
            message: w.message, fileStack: w.fileStack};
        if (type === 'w_start_rule_crash') {
            result.target = w.message.match(/subroutine (\w+)/)[1];
            const compiled = targetRule(baseline.result, result.target);
            result.targetRule = compiled.name;
            result.directWaitActions = compiled.code.split('\n').filter(l => /\bWait(?: Until)?\(/.test(l)).map(l => l.trim());
            [result.severity, result.crashRisk] = startRatings[number - 1];
        } else if (type === 'w_ow2_rule_condition_chase') {
            const key = file + ':' + leaf.startLine;
            assert(chaseRatings[key], 'Re-audit moved chase warning: ' + key);
            result.variable = w.message.match(/variable '([^']+)'/)[1];
            [result.verdict, result.reason] = chaseRatings[key];
            result.defectRegistered = false;
            result.severity = result.verdict.startsWith('Корректно') ? 'Не дефект' : 'Под наблюдением; средняя при воспроизведении';
            result.crashRisk = 'Прямой механизм падения не обнаружен';
        } else {
            result.severity = 'Низкая; изменение физики требует проверки';
            result.crashRisk = 'Прямой механизм падения не обнаружен';
            result.fix = 'Миграция на CANCEL_CONTRARY_MOTION_XYZ после сравнения траекторий; режим XYZ не эквивалентен старому XZ/Y';
        }
        return result;
    });
    assert.deepEqual(counters, {w_start_rule_crash: 22, w_ow2_rule_condition_chase: 14, w_cancel_contrary_motion: 20, w_closest_player: 0});
    assert(diagnostics.filter(d => /^SR0[123]$/.test(d.id)).every(d => d.directWaitActions.length === 0));
    // Adding suppressions back in memory must not change compiled actions/conditions.
    const suppressed = await compile(originalMain.replace('#!suppressWarnings w_dark_color', '#!suppressWarnings w_dark_color ' + four.join(' ')));
    assert.equal(suppressed.result, baseline.result);
    assert.equal(suppressed.encounteredWarnings.length, 0);
    // Migration probe only: compile copied sources with the current enum, no src/ writes.
    let replacements = 0;
    const flattenedMigration = originalMain.replace(/^#!include "([^"]+)".*$/gm, (_, name) =>
        sourceFiles[name].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/\bImpulse\.CANCEL_CONTRARY_MOTION\b/g, () => {
            replacements++;
            return 'Impulse.CANCEL_CONTRARY_MOTION_XYZ';
        });
    assert.equal(replacements, 20);
    const migration = await compile(flattenedMigration);
    assert(!migration.encounteredWarnings.some(w => w.message.includes('(w_cancel_contrary_motion)')));
    assert.equal(migration.nbElements, baseline.nbElements);
    const report = {date: '2026-11-04', extension, elements: baseline.nbElements,
        ruleCount: (baseline.result.match(/^rule \(/gm) || []).length,
        sourceSha256: Object.fromEntries(Object.entries(sourceFiles).map(([f, s]) => [f, crypto.createHash('sha256').update(s).digest('hex')])),
        counts: counters, suppressedVariant: {warnings: 0, sameWorkshop: true},
        impulseMigrationProbe: {replacements, elements: migration.nbElements,
            remainingWarnings: migration.encounteredWarnings.length, legacyWarnings: 0,
            limitation: 'Compilation only; XYZ physics is not behaviorally equivalent to the legacy mode.'}, diagnostics,
        chaseSummary: {accepted: diagnostics.filter(d => d.type === 'w_ow2_rule_condition_chase' && d.verdict.startsWith('Корректно')).length,
            monitoringOnly: diagnostics.filter(d => d.type === 'w_ow2_rule_condition_chase' && !d.verdict.startsWith('Корректно')).length,
            inGameFailuresReproduced: 0},
        limitation: 'Original-include compilation and static reachability audit only. No in-game crash, chase failure, or impulse migration was reproduced.'};
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(__dirname, 'compiler-warning-audit-2026-11-04.json'), JSON.stringify(report, null, 2) + '\n', 'utf8');
    console.log(JSON.stringify({elements: report.elements, rules: report.ruleCount, warnings: diagnostics.length, counts: counters,
        chase: report.chaseSummary, noWarningsWhenSuppressed: true, sameWorkshopWhenSuppressed: true}, null, 2));
    if (process.argv.includes('--list')) diagnostics.forEach(d => console.log([d.id, d.type, d.file + ':' + d.line, d.owner].join(' | ')));
}
main().catch(error => { console.error(error); process.exitCode = 1; });
