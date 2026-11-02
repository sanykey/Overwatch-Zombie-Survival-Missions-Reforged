const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
module.exports = function writeReview(report) {
    const layout = require('./player-slot-sharing.cjs');
    const validation = JSON.parse(fs.readFileSync(path.join(__dirname, 'player-slot-sharing-validation.json'), 'utf8'));
    const byName = new Map(report.variables.map(v => [v.name, v]));
    assert.deepEqual([...byName.keys()].sort(), layout.variables.map(v => v.name).sort());
    const rows = ['# Переменные игрока — ' + report.date, '',
        `**${report.playerVariables} физических playervar, 99 globalvar, ${validation.after.elements} элементов.** ` +
        `Освобождены 33 слота относительно 107 полей ревизии \`${layout.baselineRef}\`; ${validation.aliases} смысловых алиасов.`, '',
        '29 полей Team 2 совмещены с предметами и состояниями улучшений Team 1. ' +
        'Голоса, данные обмена предметами и путь Rescue NPC используют один слот; ' +
        'позиция меню, начало пути NPC и направление финального полёта — другой. ' +
        'Тип биоресурса и настроение NPC совмещены с защитой поздних записей после смены задания.', '',
        '[Обоснование безопасности и сценарии игрового прогона](player-slot-sharing-review-2026-11-02.md). ' +
        '[Полный индекс обращений](player-variable-references-2026-11-02.md). ' +
        '[Результат проверок](player-slot-sharing-validation.json).', '',
        'Получатель поля определяет владельца, а не команда правила. ' +
        'Состояние позднего входа, общие эффекты и поля с чтением исходного нуля сохранены отдельно.', ''];
    for (const [group, title] of Object.entries(layout.groups)) {
        const members = layout.variables.filter(v => v.group === group);
        if (!members.length) continue;
        rows.push('## ' + title, '', '| Слот | Тип | Назначение и роли |', '| --- | --- | --- |');
        for (const v of members) {
            assert(byName.get(v.name).references.length > 0, 'Unreferenced slot: ' + v.name);
            const roles = v.aliases.map(a => `\`${a.name}\` (${a.type})`).join('; ');
            rows.push(`| \`${v.name}\` | ${v.type} | ${v.description}${roles ? ' Роли: ' + roles : ''} |`);
        }
        rows.push('');
    }
    rows.push('## Проверки', '',
        '`node analysis/verify-player-variables.cjs` проверяет все 231 скомпилированное правило, ' +
        'слоты и алиасы, граф вызовов получателей eventPlayer и время жизни scratch; выполняет обычную сборку через include. ' +
        '`node analysis/verify-phase-slots.cjs` сохраняет цепочку сравнения прежних globalvar. ' +
        '`node analysis/audit-player-variables.cjs` обновляет этот документ и индекс.', '',
        'Все проверки статические. Игровой прогон не выполнялся. Для обновления импортируйте полный скрипт.', '');
    fs.writeFileSync(path.join(__dirname, 'player-variables-review-2026-11-02.md'), rows.join('\n'));
};
