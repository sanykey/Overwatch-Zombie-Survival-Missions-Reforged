// Compare all compiled rules with the reviewed temporary-variable package applied to its Git baseline.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const layout = require('./player-variable-layout.cjs');
const changes = require('./probe-player-temporaries-2026-11-02.cjs');
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

function compare(before, after, mapping = changes.playerSlotRenames) {
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
    assert.equal(declarations.length, 107);
    assert.equal((source.match(/^globalvar /gm) ?? []).length, 99);
    const names = layout.variables.flatMap(v => [v.name, ...v.aliases.map(a => a.name)]);
    assert.equal(new Set(names).size, names.length, 'Player role names must be unique');
    for (const v of layout.variables) {
        assert(v.aliases.length !== 1, 'Use the remaining role name as the physical variable: ' + v.name);
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
    const baseline = changes.baselineFiles();
    await compiler.readyPromise;
    const before = await compile(baseline);
    const expected = await compile(changes.applyConservativePackage({...baseline}));
    const after = await compile(files);
    assert.equal(before.elements, 27218);
    assert.equal(after.elements, before.elements - 30);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    checkLayout(files);
    const {inventory, codeOnly} = require('./audit-player-variables.cjs');
    const indexed = new Map(inventory().map(v => [v.name, v]));
    const allowed = new Set(layout.variables.flatMap(v => [v.name, ...v.aliases.map(a => a.name)]));
    for (const v of layout.variables) {
        assert.deepEqual([...indexed.get(v.name).aliases].sort(), v.aliases.map(a => a.name).sort(),
            'Source role aliases differ from the reviewed layout: ' + v.name);
        for (const alias of v.aliases) assert(indexed.get(v.name).references.some(r => r.symbols.includes(alias.name)),
            'Unused role alias: ' + alias.name);
        if (allowed.has(v.old)) continue;
        const legacy = new RegExp('\\.' + v.old + '\\b');
        for (const [file, source] of Object.entries(files)) {
            assert(!source.split('\n').some(line => legacy.test(codeOnly(line))), 'Legacy field remains: ' + file + ' / ' + v.old);
        }
    }
    for (const removed of ['botMutationOutlineColor', 'rescuePathIndex', 'botReigniteSource',
        'enhancementBarrierTarget', 'currentCombatTarget', 'aiLocationSlot', 'botReigniteMotionSlot', 'combatTargetSlot']) {
        const token = new RegExp('\\b' + removed + '\\b');
        for (const [file, source] of Object.entries(files)) assert(!source.split('\n').some(line => token.test(codeOnly(line))),
            'Obsolete player role remains: ' + file + ' / ' + removed);
    }
    const comparison = compare(expected, after);
    assert.equal(after.elements, 27188);
    const mainSource = files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, '');
    const log = console.log; let exported;
    try {console.log = () => {}; exported = await compiler.compile(mainSource, 'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'main.opy');}
    finally {console.log = log;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), rules(after.result));
    fs.writeFileSync(path.join(root, 'src/main.ws.txt'), exported.result);
    const report = {date: '2026-11-02', baselineRef: changes.baselineRef,
        originalRenameBaselineRef: layout.baselineRef,
        before: {globals: 99, playerVariables: 108, elements: before.elements},
        globals: 99, playerVariables: 107, elements: after.elements, warnings: after.warnings,
        appliedPackage: ['rescuePathIndex -> tmp0', 'botReigniteSource -> tmp0',
            'enhancementBarrierTarget -> tmp2', 'botPotentialTargetList calculations -> tmp1, final per-player snapshot retained for boss-distance visibility',
            'botMutationOutlineColor -> tmp2 captured with evalOnce; final mutation branch is exhaustive'],
        correctedProposal: 'The original -32 estimate omitted the reevaluated boss distance-text reader. Keeping its final per-bot candidate snapshot costs 2 elements; actual saving is 30.',
        compiledRulesCompared: comparison.compiledRulesCompared,
        groups: Object.fromEntries(Object.keys(layout.groups).map(g => [g, layout.variables.filter(v => v.group === g).length])),
        mapping: Object.fromEntries(layout.variables.map(v => [v.old, v.name])),
        physicalSlotRenames: comparison.mapping,
        aliases: layout.variables.flatMap(v => v.aliases.map(a => ({name: a.name, slot: v.name, type: a.type}))),
        sha256: Object.fromEntries(Object.entries(files).map(([file, source]) => [file, crypto.createHash('sha256').update(source).digest('hex')])),
        limitations: 'All compiled rules match the explicitly reviewed source transformation of the Git baseline after physical-slot renames. The final bot target-candidate snapshot remains persistent for reevaluated boss text. Scratch liveness and visual capture are checked separately. Declaration indices change; import the complete script. No in-game scheduler/renderer test.'};
    fs.writeFileSync(path.join(__dirname, 'player-variable-validation-2026-11-02.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({globals: 99, playerVariables: 107, elements: after.elements,
        compiledRulesCompared: report.compiledRulesCompared, roleAliases: report.aliases.length, warnings: report.warnings}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {normalizePlayerNames, rules, compare, checkLayout};
