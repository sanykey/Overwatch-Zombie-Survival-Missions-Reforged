// Compare all compiled events/conditions/actions after the one-to-one player-field rename.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const layout = require('./player-variable-layout.cjs');
const root = path.resolve(__dirname, '..');

function normalizePlayerNames(text, mapping) {
    // Dot fields belong to players, except the explicitly qualified Global.* namespace.
    text = text.replace(/\.(\w+)/g, (match, name, offset, source) =>
        /\bGlobal$/.test(source.slice(0, offset)) ? match : '.' + (mapping[name] ?? name));
    // Set/Modify/For/Chase player-variable actions take a bare field name as argument 2.
    // Parse argument 1 with balanced parentheses so nested arrays, commas and strings are safe.
    const edits = [];
    const action = /\b(?:Set|Modify|For|Chase|Stop Chasing) Player Variable[^\n(]*\(/g;
    for (const match of text.matchAll(action)) {
        let i = match.index + match[0].length, depth = 0, quoted = false;
        for (; i < text.length; i++) {
            const c = text[i];
            if (quoted && c === '\\') { i++; continue; }
            if (c === '"') quoted = !quoted;
            if (quoted) continue;
            if (c === '(') depth++;
            if (c === ')') depth--;
            if (c === ',' && depth === 0) break;
        }
        assert(i < text.length, 'Missing player-field argument');
        const field = text.slice(i + 1).match(/^(\s*)(\w+)/);
        assert(field, text.slice(i, i + 100));
        if (Object.hasOwn(mapping, field[2])) edits.push({start: i + 1 + field[1].length,
            end: i + 1 + field[0].length, value: mapping[field[2]]});
    }
    for (const edit of edits.reverse()) text = text.slice(0, edit.start) + edit.value + text.slice(edit.end);
    return text;
}

function rules(result, mapping = {}) {
    return [...result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => ({name,
        body: normalizePlayerNames(body.split('\n').filter(line => !/^\s*(?:"|\/\/)/.test(line))
            .map(line => line.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n'), mapping)}));
}

function compare(before, after) {
    const mapping = Object.fromEntries(layout.variables.map(v => [v.old, v.name]));
    const oldRules = rules(before.result, mapping), newRules = rules(after.result);
    assert(oldRules.length > 200, 'Compiled rules were not parsed');
    assert.equal(newRules.length, oldRules.length);
    for (let i = 0; i < newRules.length; i++) assert.deepEqual(newRules[i], oldRules[i], 'Rule changed: ' + newRules[i].name);
    assert.equal(after.elements, before.elements);
    assert.deepEqual(after.warnings, []);
    return {mapping, compiledRulesCompared: newRules.length};
}

function checkLayout(files) {
    const source = Object.values(files).join('\n');
    const declarations = [...source.matchAll(/^playervar (\w+)/gm)].map(m => m[1]);
    assert.deepEqual(declarations.sort(), layout.variables.map(v => v.name).sort());
    assert.equal(declarations.length, 108);
    assert.equal((source.match(/^globalvar /gm) ?? []).length, 99);
    const names = layout.variables.flatMap(v => [v.name, ...v.aliases.map(a => a.name)]);
    assert.equal(new Set(names).size, names.length, 'Player role names must be unique');
    for (const v of layout.variables) {
        assert(new RegExp('^playervar ' + v.name + '\\s+#\\s*\\S', 'm').test(files['variables.opy']),
            'Missing variable comment: ' + v.name);
        assert(Object.hasOwn(layout.groups, v.group), v.group);
        const prefix = {bots: 'bot', enhancements: 'enhancement', powerups: 'powerUp'}[v.group];
        if (prefix) assert(v.name.startsWith(prefix), 'Owner prefix: ' + v.name);
        for (const role of [v, ...v.aliases]) {
            if (role.type === 'array') assert(role.name.endsWith('List'), role.name);
            if (role.type === 'bool') assert(/^(?:is[A-Z]|(?:bot|enhancement|rescue)Is[A-Z])/.test(role.name), role.name);
        }
        for (const alias of v.aliases) assert(files['variables.opy'].includes(`#!define ${alias.name} ${v.name}\n`), alias.name);
    }
}

async function main() {
    const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${layout.baselineRef}:src/${file}`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    checkLayout(files);
    const {inventory, codeOnly} = require('./audit-player-variables.cjs');
    const indexed = new Map(inventory().map(v => [v.name, v]));
    const allowed = new Set(layout.variables.flatMap(v => [v.name, ...v.aliases.map(a => a.name)]));
    for (const v of layout.variables) {
        for (const alias of v.aliases) assert(indexed.get(v.name).references.some(r => r.symbols.includes(alias.name)),
            'Unused role alias: ' + alias.name);
        if (allowed.has(v.old)) continue;
        const legacy = new RegExp('\\.' + v.old + '\\b');
        for (const [file, source] of Object.entries(files)) {
            assert(!source.split('\n').some(line => legacy.test(codeOnly(line))), 'Legacy field remains: ' + file + ' / ' + v.old);
        }
    }
    const comparison = compare(before, after);
    assert.equal(after.elements, 27218);
    const mainSource = files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, '');
    const log = console.log; let exported;
    try {console.log = () => {}; exported = await compiler.compile(mainSource, 'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'main.opy');}
    finally {console.log = log;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), rules(after.result));
    fs.writeFileSync(path.join(root, 'src/main.ws.txt'), exported.result);
    const report = {date: '2026-11-02', baselineRef: layout.baselineRef,
        globals: 99, playerVariables: 108, elements: after.elements, warnings: after.warnings,
        compiledRulesCompared: comparison.compiledRulesCompared,
        groups: Object.fromEntries(Object.keys(layout.groups).map(g => [g, layout.variables.filter(v => v.group === g).length])),
        mapping: comparison.mapping,
        aliases: layout.variables.flatMap(v => v.aliases.map(a => ({name: a.name, slot: v.name, type: a.type}))),
        sha256: Object.fromEntries(Object.entries(files).map(([file, source]) => [file, crypto.createHash('sha256').update(source).digest('hex')])),
        limitations: 'Full compiled-rule comparison confirms unchanged events, conditions, actions, expression trees and chase/reevaluation arguments after player-name substitution. Declaration order/physical slot numbers may change; import the complete script. No live-match migration or in-game renderer/scheduler test.'};
    fs.writeFileSync(path.join(__dirname, 'player-variable-validation-2026-11-02.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({globals: 99, playerVariables: 108, elements: after.elements,
        compiledRulesCompared: report.compiledRulesCompared, roleAliases: report.aliases.length, warnings: report.warnings}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {normalizePlayerNames, rules, compare, checkLayout};
