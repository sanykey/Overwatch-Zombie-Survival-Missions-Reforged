// Audit single-use subroutines and measure macro conversions with the installed OverPy compiler.
// Dry run: node analysis/measure-single-use-subroutines.cjs
// Apply:   node analysis/measure-single-use-subroutines.cjs --apply
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const apply = process.argv.includes('--apply');
const originals = Object.fromEntries(fs.readdirSync(src).filter(n => n.endsWith('.opy'))
    .map(n => [n, fs.readFileSync(path.join(src, n), 'utf8')]));
const files = Object.fromEntries(Object.entries(originals).map(([n, s]) => [n, s.replace(/\r\n/g, '\n')]));

// Preserve offsets while ignoring comments and quoted text when counting references.
function codeOnly(text) {
    return text.replace(/"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*'|#[^\n]*/g,
        value => value.replace(/[^\n]/g, ' '));
}

function definitions(snapshot) {
    return Object.entries(snapshot).flatMap(([file, text]) =>
        [...text.matchAll(/^def (\w+)\(\):[^\n]*\n(?:[ \t][^\n]*\n|\n)*/gm)]
            .map(m => ({ file, name: m[1], start: m.index, text: m[0] })));
}

function audit(snapshot) {
    const defs = definitions(snapshot);
    const code = Object.entries(snapshot).map(([file, text]) => ({ file, text: codeOnly(text) }));
    return Object.entries(snapshot).flatMap(([file, text]) =>
        [...text.matchAll(/^subroutine (\w+)[ \t]*$/gm)].map(m => {
            const name = m[1];
            const def = defs.find(d => d.name === name);
            assert(def, 'Missing definition: ' + name);
            const references = code.flatMap(({ file, text }) => text.split('\n').flatMap((line, i) => {
                if (/^(?:subroutine |def )/.test(line)) return [];
                return [...line.matchAll(new RegExp('\\b' + name + '\\b', 'g'))].map(ref => ({
                    file, line: i + 1, call: snapshot[file].split('\n')[i].trim(),
                    direct: /^\s*\(\s*\)/.test(line.slice(ref.index + name.length)),
                }));
            }));
            const body = codeOnly(def.text).split('\n').slice(1).join('\n');
            const reasons = [];
            if (references.length !== 1) reasons.push(references.length + ' references');
            if (references.some(r => !r.direct)) reasons.push('asynchronous startRule or non-call reference');
            if (/\breturn\b/.test(body)) reasons.push('early return would abort the caller');
            if (/\b(?:loop|abort|skip|skipIf)\s*\(|\bruleCondition\b|Wait\.(?:ABORT_WHEN_FALSE|RESTART_WHEN_TRUE)/.test(body)) {
                reasons.push('control flow depends on the enclosing rule');
            }
            if (/\bgoto\b|^\s*\w+:\s*$/m.test(body.replace(/^\s*(?:else|default):\s*$/gm, ''))) {
                reasons.push('labels or goto require separate review');
            }
            if (/^\s*@(?!(?:Name)\b)\w+/m.test(def.text)) reasons.push('subroutine rule annotations');
            return { name, file, references, reasons, eligible: reasons.length === 0 };
        }));
}

function convert(snapshot, name) {
    const def = definitions(snapshot).find(d => d.name === name);
    assert(def, name);
    const macro = def.text.replace(/^def \w+\(\):\n/, 'macro ' + name + 'Macro():\n')
        .replace(/^    @Name[^\n]*\n[ \t]*\n?/m, '')
        .trimEnd() + '\n\n\n';
    const next = { ...snapshot, [def.file]: snapshot[def.file].slice(0, def.start) + snapshot[def.file].slice(def.start + def.text.length) };
    for (const file of Object.keys(next)) {
        next[file] = next[file].replace(new RegExp('^subroutine ' + name + '[ \\t]*\\n', 'gm'), '')
            .replace(new RegExp('\\b' + name + '(?=\\s*\\()', 'g'), name + 'Macro');
    }
    const insertion = next[def.file].search(/^(?:rule |def |macro )/m);
    assert(insertion >= 0, 'No insertion point in ' + def.file);
    next[def.file] = next[def.file].slice(0, insertion) + macro + next[def.file].slice(insertion);
    assert.equal((Object.values(next).join('\n').match(new RegExp('\\b' + name + 'Macro\\(', 'g')) || []).length, 2);
    assert(!Object.values(next).some(text => new RegExp('\\b' + name + '\\b').test(codeOnly(text))), 'Old reference: ' + name);
    return next;
}

function source(snapshot) {
    return snapshot['includes.opy'].replace(/^#!include "([^"]+)".*$/gm, (line, name) =>
        snapshot[name] === undefined ? line : snapshot[name].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/^#!writeToOutputFile.*\n/gm, '');
}

async function main() {
    const extensions = path.join(process.env.USERPROFILE, '.vscode', 'extensions');
    const extension = fs.readdirSync(extensions).filter(n => n.startsWith('zezombye.overpy-'))
        .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }))[0];
    const compiler = require(path.join(extensions, extension, 'npm', 'overpy.js'));
    await compiler.readyPromise;
    async function compile(snapshot) {
        const saved = { log: console.log, warn: console.warn, error: console.error };
        try {
            console.log = console.warn = console.error = () => {};
            const result = await compiler.compile(source(snapshot), 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
            return { elements: result.nbElements, warnings: result.encounteredWarnings, result: result.result };
        } finally { Object.assign(console, saved); }
    }
    const inventory = audit(files);
    const report = {
        compiler: extension, applied: apply,
        method: 'Current working-tree baseline (including existing enablePowerupsMacro); cumulative compilation after each conversion. Asynchronous calls and rule-dependent control flow excluded. No in-game validation.',
        initialSourceSha256: Object.fromEntries(Object.entries(originals).map(([n, s]) => [n, crypto.createHash('sha256').update(s).digest('hex')])),
        inventory, results: [],
    };
    let snapshot = files;
    let result = await compile(snapshot);
    report.before = result.elements;
    report.warningsBefore = result.warnings;
    console.log(JSON.stringify({ before: result.elements, candidates: inventory.filter(r => r.eligible).map(r => r.name) }));
    for (const candidate of inventory.filter(r => r.eligible)) {
        const next = convert(snapshot, candidate.name);
        const compiled = await compile(next);
        assert.deepEqual(compiled.warnings, result.warnings, 'Warnings changed: ' + candidate.name);
        const row = { name: candidate.name, macro: candidate.name + 'Macro', file: candidate.file,
            before: result.elements, after: compiled.elements, saved: result.elements - compiled.elements };
        assert(row.saved > 0, 'No element saving: ' + candidate.name);
        report.results.push(row);
        console.log(JSON.stringify(row));
        snapshot = next;
        result = compiled;
    }
    assert.equal(audit(snapshot).filter(r => r.eligible).length, 0, 'Eligible subroutines remain');
    report.after = result.elements;
    report.saved = report.before - report.after;
    report.warningsAfter = result.warnings;
    assert.equal(report.saved, report.results.reduce((sum, row) => sum + row.saved, 0));
    if (apply) {
        for (const [file, text] of Object.entries(snapshot)) {
            const original = originals[file];
            if (text === files[file]) continue;
            assert.equal(fs.readFileSync(path.join(src, file), 'utf8'), original, 'Source changed during measurement: ' + file);
            const clean = text.trimEnd() + '\n';
            fs.writeFileSync(path.join(src, file), original.includes('\r\n') ? clean.replace(/\n/g, '\r\n') : clean);
        }
        // Compile real includes for the output so debug comments retain the source filenames.
        const diskResult = await compiler.compile(fs.readFileSync(path.join(src, 'includes.opy'), 'utf8')
            .replace(/^#!writeToOutputFile.*\r?\n/gm, ''), 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
        assert.equal(diskResult.nbElements, report.after);
        assert.deepEqual(diskResult.encounteredWarnings, result.warnings);
        fs.writeFileSync(path.join(src, 'main.ws.txt'), diskResult.result);
    }
    fs.writeFileSync(path.join(__dirname, 'single-use-subroutines-results.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({ applied: apply, converted: report.results.length, before: report.before, after: report.after, saved: report.saved, warnings: result.warnings.length }));
}
main().catch(error => { console.error(error); process.exitCode = 1; });
