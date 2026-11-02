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

const writeReview = require('./render-player-variable-review.cjs');
if (require.main === module) main();
module.exports = {inventory, codeOnly};
