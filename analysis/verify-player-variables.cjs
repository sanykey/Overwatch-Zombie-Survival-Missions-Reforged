// Shared compiled-name comparison helpers and the current player-storage verification entry point.
const assert = require('node:assert/strict');
const changes = require('./probe-player-temporaries-2026-11-02.cjs');

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
    return require('./verify-player-slot-sharing.cjs').checkLayout(files);
}

async function main() {
    return require('./verify-remaining-elements.cjs').main();
}
module.exports = {normalizePlayerNames, rules, compare, checkLayout};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
