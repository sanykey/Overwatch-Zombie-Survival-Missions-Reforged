// Source inventory of player fields. Team/condition metadata is evidence, not an ownership proof:
// a Team 1 rule can write a field on a Team 2 target (and vice versa).
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {files} = require('./measure-further-optimizations.cjs');
const included = ['main.opy', ...[...files['main.opy'].matchAll(/^#!include "([^"]+)"/gm)].map(m => m[1])];
const date = '2026-11-02';

function codeOnly(line) {
    return line.replace(/"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|#(?!\!define\b).*$/g, value => ' '.repeat(value.length));
}

function inventory(sourceFiles = files) {
    const sourceIncludes = ['main.opy', ...[...sourceFiles['main.opy'].matchAll(/^#!include "([^"]+)"/gm)].map(m => m[1])];
    const variables = sourceIncludes.flatMap(file => sourceFiles[file].split('\n').flatMap((line, i) => {
        const m = line.match(/^playervar (\w+)/);
        return m ? [{name: m[1], declaration: {file, line: i + 1}, aliases: [], references: []}] : [];
    }));
    assert.equal(new Set(variables.map(v => v.name)).size, variables.length);
    const aliases = Object.fromEntries(sourceIncludes.flatMap(file =>
        [...sourceFiles[file].matchAll(/^#!define (\w+) (\w+)\s*$/gm)].map(m => [m[1], m[2]])));
    function resolve(name, seen = new Set()) {
        assert(!seen.has(name), 'Cyclic alias: ' + name);
        seen.add(name);
        return Object.hasOwn(aliases, name) ? resolve(aliases[name], seen) : name;
    }
    for (const variable of variables) variable.aliases = Object.keys(aliases).filter(name => resolve(name) === variable.name);
    for (const file of sourceIncludes) {
        let block = 'module', event = null, team = null, conditions = [];
        for (const [i, source] of sourceFiles[file].split('\n').entries()) {
            if (/^(?:rule |def |macro )/.test(source)) {
                block = source.trim().replace(/:$/, ''); event = team = null; conditions = [];
            }
            if (/^\s*@Event /.test(source)) event = source.trim().slice(7);
            if (/^\s*@Team /.test(source)) team = source.trim().slice(6);
            if (/^\s*@Condition /.test(source)) conditions.push(source.trim().slice(11));
            const code = codeOnly(source);
            if (/^(?:playervar|globalvar|#!define)\b/.test(code)) continue;
            for (const variable of variables) {
                const names = '(?:' + [variable.name, ...variable.aliases].join('|') + ')';
                const hits = [...code.matchAll(new RegExp('\\.(' + names + ')\\b', 'g'))];
                if (!hits.length) continue;
                const write = new RegExp('\\.' + names + '(?:\\[[^\\n]*?\\])*\\s*(?:[+*/%-]?=(?!=)|\\+\\+|--)|\\.' + names + '\\.(?:append|remove)\\(|^\\s*(?:for|del) .*\\.' + names + '\\b');
                variable.references.push({file, line: i + 1, block, event, team, conditions: [...conditions],
                    symbols: [...new Set(hits.map(m => m[1]))], occurrences: hits.length,
                    kind: write.test(code) ? 'write-or-read/write' : 'read-or-action-argument', source: source.trim()});
            }
        }
    }
    return variables;
}

function main() {
    const variables = inventory();
    const report = {date, playerVariables: variables.length,
        method: 'Included OverPy sources. Comments/literals/declarations excluded; field aliases resolve to physical slots. Rule team identifies the event owner, not necessarily the receiver of each field. Ownership and types require manual review. No runtime scheduling simulation.',
        sha256: Object.fromEntries(included.map(file => [file, crypto.createHash('sha256').update(files[file]).digest('hex')])),
        variables: variables.map(v => ({...v, referenceLines: v.references.length,
            occurrences: v.references.reduce((sum, r) => sum + r.occurrences, 0)}))};
    fs.writeFileSync(path.join(__dirname, 'player-variable-usage-2026-11-02.json'), JSON.stringify(report, null, 2) + '\n');
    const lines = ['# Обращения к переменным игрока — ' + date, '',
        'Сгенерировано `node analysis/audit-player-variables.cjs`. Команда правила не доказывает команду получателя поля: учитывайте выражение слева от точки и вызовы подпрограмм. Алиасы собраны в физические слоты.', ''];
    for (const v of variables) {
        lines.push('## ' + v.name, '', `Объявление: [variables.opy:${v.declaration.line}](../src/${v.declaration.file}#L${v.declaration.line}).`, '');
        if (v.aliases.length) lines.push('Алиасы: ' + v.aliases.map(a => '`' + a + '`').join(', ') + '.', '');
        const groups = new Map();
        for (const r of v.references) {
            const key = r.file + ' — ' + r.block + (r.team ? ' (event Team ' + r.team + ')' : '');
            if (!groups.has(key)) groups.set(key, []);
            groups.get(key).push(r);
        }
        for (const [key, refs] of groups) lines.push('- ' + key + ': ' + refs.map(r => `[${r.line}](../src/${r.file.replaceAll(' ', '%20')}#L${r.line})`).join(', ') + '.');
        lines.push('');
    }
    fs.writeFileSync(path.join(__dirname, 'player-variable-references-2026-11-02.md'), lines.join('\n'));
    writeReview(report);
    console.log(JSON.stringify({playerVariables: variables.length, fieldReferenceLines: variables.reduce((n, v) => n + v.references.length, 0)}));
}

function writeReview(report) {
    const layout = require('./player-variable-layout.cjs');
    const byName = new Map(report.variables.map(v => [v.name, v]));
    assert.deepEqual([...byName.keys()].sort(), layout.variables.map(v => v.name).sort());
    const titles = {bots: 'Только зомби Team 2', team1: 'Только Team 1: игроки и союзные акторы',
        enhancements: 'Только функционал enhancements', powerups: 'Только функционал supply power-ups',
        pregame: 'Team 1: меню и голосование', rescue: 'Team 1: NPC Survivor Rescue',
        biomorphing: 'Biomorphing: носители ресурсов обеих команд', explosions: 'Общие взрывы зомби и Zombie Hybrid',
        shared: 'Общие состояния и слоты нескольких функционалов'};
    const types = {bool: 'Булево', number: 'Число', vector: 'Вектор', array: 'Массив', mixed: 'Смешанный',
        player: 'Игрок/null', string: 'Строка', hero: 'Герой', color: 'Цвет', icon: 'Иконка', button: 'Кнопка'};
    const aliasCount = layout.variables.reduce((n, v) => n + v.aliases.length, 0);
    const rows = ['# Порядок и имена переменных игрока — ' + date, '',
        '**107 физических playervar, 99 globalvar, 27 188 элементов.** После организации имён внедрён ' +
        '[консервативный перенос локальных вычислений](player-variable-lifetimes-2026-11-02.md): −1 слот и −30 элементов. ' +
        'Объявления сгруппированы; ' + aliasCount + ' смысловых алиаса `#!define` раскрываются в существующие слоты. ' +
        'База первоначального переименования — `' + layout.baselineRef + '`; ' +
        'пакет временных значений сравнивается с `fddc95aa13042bb5cbdcfebe4295fef74a6ee151`.', '',
        'Комментарии к каждому физическому полю и каждой роли находятся в `src/variables.opy`. ' +
        '[Индекс обращений](player-variable-references-2026-11-02.md) содержит файлы, правила и строки, ' +
        '[JSON](player-variable-usage-2026-11-02.json) — полные выражения, команды правил и условия. ' +
        '[Проверка](player-variable-validation-2026-11-02.json) хранит сопоставление имён и хеши исходников.', '',
        '## Принципы группировки', '',
        '- Команда правила относится к владельцу события, а не обязательно к получателю поля. ' +
        'Проверены `eventPlayer`, `victim`, `attacker`, поля целей и коллекций, вызовы подпрограмм и Rescue NPC.',
        '- `bot` означает поле зомби Team 2. Функциональные группы enhancements/power-ups имеют собственные префиксы; ' +
        'они остаются в этих группах даже при чтении из файла другой системы. Остальные поля только Team 1 разделены на выживание, меню и Rescue.',
        '- Булевы роли используют `is...` или `botIs...` / `enhancementIs...` / `rescueIs...`; массивы заканчиваются на `List`. ' +
        'Сбросы постоянных ссылок и векторов сохранены. Числовые счётчики не превращены в булевы. ' +
        'Временный цвет мутации захватывается контуром через `evalOnce`.',
        '- Разные назначения одного слота имеют отдельные алиасы. Одинаковый смысл в разных потребителях ' +
        'сохраняет общее имя: например, `initialMaxHealth`, `sizeScale`, `movementSpeedScale`, `isCrowdControlled`. ' +
        'Слоты с единственной оставшейся ролью переименованы в её имя; одиночных алиасов нет.',
        '- Новое совместное хранение не добавлялось. Порядок физических индексов мог измениться: импортировать следует полный скрипт.', '',
        '## Важные случаи', '',
        '- Цель Laser Barricade перенесена в `tmp2`; оставшаяся цель AI и её очистка используют физический `botTarget`. ' +
        'Бывшие `aiLocationSlot` и `botReigniteMotionSlot` стали физическими `botTeleportPosition` и `botReigniteRisePosition`.',
        '- В `selectTarget` кандидаты вычисляются в `tmp1`, но итог сохраняется в `botPotentialTargetList`: ' +
        'его читает переоцениваемый текст расстояния до босса. Физический `candidateTargetList` сохраняет также роли Rescue и Barricade.',
        '- Старый `botFollowTarget` принадлежит NPC Team 1: теперь это `rescueLeader`. ' +
        'Старый `botThrottleSpeed` хранится в `aiThrottleSpeedSlot` с ролями `botThrottleSpeed` / `rescueThrottleSpeed`.',
        '- `specialCooldown` содержал флаг Team 1 и ссылку на цель босса. Теперь это `controlStateSlot`: ' +
        '`isCrowdControlCooldownActive` / `botReturnTarget`.',
        '- `invisible` является счётчиком: способности и Cloaking Device делают `++`/`--`. ' +
        'Новое имя `invisibilityCount` сохраняет числовую семантику.',
        '- `abilityArray1` не всегда массив: `botAbilityStateSlot` имеет роли `botAbilityCooldown` и `botGasPositionList`. ' +
        '`abilityArray2` всегда используется как массив радиусов: `botGasRadiusList`.',
        '- Старые `chase1`/`chase2`, `botTempValue`/`botTempvalue2`, `telePos`, счётчики смешанных предметов/зомби ' +
        'сохранили физические слоты, но получили имена для конкретных способностей, Rescue и эвакуации.',
        '- Поля `enhancementValue1..6` представлены хранилищами `enhancement*Slot` с ролями каждого улучшения. ' +
        '`enhancementValue7` принадлежит только баррикаде и переименован в `enhancementBarrierHealth`.',
        '- `isCrowdControlled` читается и на потенциальном носителе Hitchhiker в Team 1, хотя записи состояния делает AI Team 2. ' +
        '`damageOverTimeRemaining` также оставлен общим: одна ветка Rusher пишет его на `victim`. ' +
        'Эти существующие получатели и ограничения не исправлялись при переименовании.',
        '- Глобальные `isVoting`, `startPos`, `objectiveValue` сохранены отдельно от бывших одноимённых полей игрока. ' +
        'Проверка компиляции различает пространство `Global.*`, свойства игрока и аргументы player-variable действий.', '',
        '## Состав групп', '', '| Группа | Физических полей |', '| --- | ---: |'];
    for (const [group, title] of Object.entries(titles)) rows.push('| ' + title + ' | ' + layout.variables.filter(v => v.group === group).length + ' |');
    rows.push('', '## Полный список', '');
    for (const [group, title] of Object.entries(titles)) {
        rows.push('### ' + title, '', '| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |', '| --- | --- | --- | --- |');
        for (const v of layout.variables.filter(v => v.group === group)) {
            const ref = byName.get(v.name);
            let purpose = v.description;
            if (v.aliases.length) purpose += ' Роли: ' + v.aliases.map(a => '`' + a.name + '` (' + types[a.type] + ')').join('; ') + '.';
            rows.push(`| [\`${v.name}\`](player-variable-references-2026-11-02.md#${v.name.toLowerCase()}) | \`${v.old}\` | ${types[v.type]} | ${purpose} |`);
            assert(ref.references.length > 0, 'Unreferenced physical slot: ' + v.name);
        }
        rows.push('');
    }
    rows.push('## Проверки и ограничения', '',
        '`node analysis/verify-player-variables.cjs` сравнивает все 231 правила с явно заданным пакетом ' +
        'преобразований исходной ревизии после нормализации оставшихся физических имён: ' +
        'события, условия, действия, выражения, аргументы переоценки и chase. ' +
        'Обычная сборка через `#!include` также проверена, локальный `src/main.ws.txt` обновлён. ' +
        'Предупреждений нет при сохранённых подавлениях проекта.', '',
        '`node analysis/audit-player-variables.cjs` пересоздаёт этот документ и индекс из ' +
        'проверенной классификации `analysis/player-variable-layout.cjs` и текущих исходников. ' +
        'Классификация владения не выводится автоматически из `@Team`.', '',
        'Проверка в игре не проводилась. Сравнение исключает изменения скомпилированной логики вне согласованного пакета, ' +
        'но не моделирует планирование движка или перенос состояния уже идущего матча.', '');
    fs.writeFileSync(path.join(__dirname, 'player-variables-review-2026-11-02.md'), rows.join('\n'));
}
if (require.main === module) main();
module.exports = {inventory, codeOnly};
