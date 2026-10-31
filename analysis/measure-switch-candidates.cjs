// Compare each switch conversion against the last accepted version, in memory.
// Run with --apply to save only conversions that reduce the Workshop element count.
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
const indent = line => line.match(/^ */)[0].length;
const significant = line => line.trim() && !line.trimStart().startsWith('#');

function condition(text) {
    const member = text.match(/^(.+?) in \[([^\[\]]+)\]$/);
    if (member) return { selector: member[1], values: member[2].split(',').map(v => v.trim()) };
    const parts = text.split(' or ').map(p => p.match(/^(.+?) == (.+)$/));
    if (parts.some(p => !p) || parts.some(p => p[1] !== parts[0][1])) return null;
    const values = parts.map(p => p[2]);
    if (!values.every(v => /^(?:-?\d+(?:\.\d+)?|(?:Hero|Gamemode|Button|Team|Status)\.\w+|null|true|false)$/.test(v))) return null;
    return { selector: parts[0][1], values };
}

function findCandidates(file, text) {
    const lines = text.split('\n');
    const offsets = []; let offset = 0;
    for (const line of lines) { offsets.push(offset); offset += line.length + 1; }
    const candidates = [];
    for (let i = 0; i < lines.length; i++) {
        const first = lines[i].trim().match(/^if (.+):$/);
        if (!first) continue;
        const n = indent(lines[i]);
        const branches = []; let h = i;
        while (true) {
            const header = lines[h].trim().match(/^(if|elif) (.+):$|^(else):$/);
            if (!header) break;
            let end = h + 1;
            while (end < lines.length && (!significant(lines[end]) || indent(lines[end]) > n)) end++;
            let bodyEnd = end;
            while (bodyEnd > h + 1 && (!lines[bodyEnd - 1].trim() ||
                (lines[bodyEnd - 1].trimStart().startsWith('#') && indent(lines[bodyEnd - 1]) <= n))) bodyEnd--;
            let lead = h;
            while (lead > (branches.at(-1)?.bodyEnd ?? i) && !significant(lines[lead - 1])) lead--;
            branches.push({ header: h, lead, bodyEnd, end, test: header[2] ? condition(header[2]) : null, isDefault: !!header[3] });
            if (end < lines.length && indent(lines[end]) === n && /^(elif .+|else):$/.test(lines[end].trim())) h = end;
            else break;
        }
        if (branches.length < 2 || branches.some(b => !b.isDefault && !b.test)) continue;
        const selector = branches[0].test.selector;
        if (branches.some(b => b.test && b.test.selector !== selector)) continue;
        if (!/^(?:\w+(?:\.\w+)*(?:\[\d+\])?|eventPlayer\.getHero\(\)|getCurrentGamemode\(\))$/.test(selector)) continue;
        const values = branches.flatMap(b => b.test?.values ?? []);
        if (new Set(values).size !== values.length) continue;
        const end = branches.at(-1).bodyEnd;
        const original = lines.slice(i, end).join('\n');
        // Introducing a switch must not capture an existing loop break/continue.
        if (/^\s*(?:break|continue)\s*$/m.test(original)) continue;
        const pad = ' '.repeat(n);
        const output = [`${pad}switch ${selector}:`];
        for (const [branchIndex, b] of branches.entries()) {
            if (b.header !== i) output.push(...lines.slice(b.lead, b.header).map(l => l.trim() ? '    ' + l : l));
            const cases = b.test?.values ?? ['default'];
            for (let j = 0; j < cases.length; j++) {
                output.push(`${pad}    ${b.isDefault ? 'default' : 'case ' + cases[j]}:`);
                if (j < cases.length - 1) output.push(`${pad}        pass`);
            }
            const body = lines.slice(b.header + 1, b.bodyEnd);
            output.push(...body.map(l => l.trim() ? '    ' + l : l));
            if (!body.some(significant)) output.push(`${pad}        pass`);
            // The last branch already reaches the end of the switch.
            if (branchIndex < branches.length - 1) output.push(`${pad}        break`);
        }
        const owner = lines.slice(0, i).reverse().find(l => /^(?:def |rule )/.test(l));
        candidates.push({ file, line: i + 1, owner, selector, cases: values.length,
            start: offsets[i], original, replacement: output.join('\n') });
    }
    return candidates.sort((a, b) => b.start - a.start);
}

function source(snapshot) {
    return snapshot['main.opy'].replace(/^#!include "([^"]+)".*$/gm, (line, name) =>
        snapshot[name] === undefined ? line : snapshot[name].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/^#!writeToOutputFile.*\n/gm, '');
}

async function main() {
    const extensions = path.join(process.env.USERPROFILE, '.vscode', 'extensions');
    const extension = fs.readdirSync(extensions).filter(n => n.startsWith('zezombye.overpy-'))
        .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }))[0];
    const compilerPath = path.join(extensions, extension, 'npm', 'overpy.js');
    const compiler = require(compilerPath); await compiler.readyPromise;
    async function compile(snapshot) {
        const saved = { log: console.log, warn: console.warn, error: console.error };
        let r;
        try {
            console.log = console.warn = console.error = () => {};
            r = await compiler.compile(source(snapshot), 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
        } finally { Object.assign(console, saved); }
        const rules = Object.fromEntries([...r.result.slice(0, r.result.indexOf('*/'))
            .matchAll(/^\s*(\d+): rule "(.*)" \(/gm)].map(m => [m[2], +m[1]]));
        return { elements: r.nbElements, warnings: r.encounteredWarnings.length, rules };
    }
    const report = {
        compiler: extension, applied: apply,
        method: 'Each candidate compiled separately against the last accepted snapshot; only strict element reductions retained. No gameplay validation.',
        initialSourceSha256: Object.fromEntries(Object.entries(originals).map(([n, s]) => [n, crypto.createHash('sha256').update(s).digest('hex')])),
        results: [],
    };
    let baseline = await compile(files);
    report.before = baseline.elements;
    const candidates = Object.entries(files).flatMap(([name, text]) => findCandidates(name, text));
    console.log(JSON.stringify({ baseline: baseline.elements, candidates: candidates.length }));
    for (const initialCandidate of candidates) {
        // A previously accepted nested conversion changes its parent's body.
        const candidate = findCandidates(initialCandidate.file, files[initialCandidate.file])
            .find(c => c.start === initialCandidate.start && c.selector === initialCandidate.selector);
        assert(candidate, 'Candidate no longer found at ' + initialCandidate.file + ':' + initialCandidate.line);
        const { file, start, original, replacement, ...info } = candidate;
        assert.equal(files[file].slice(start, start + original.length), original);
        const snapshot = { ...files, [file]: files[file].slice(0, start) + replacement + files[file].slice(start + original.length) };
        const row = { file, ...info, before: baseline.elements };
        try {
            const result = await compile(snapshot);
            Object.assign(row, { after: result.elements, saved: baseline.elements - result.elements,
                warnings: result.warnings, kept: result.elements < baseline.elements && result.warnings <= baseline.warnings,
                changedRules: [...new Set([...Object.keys(baseline.rules), ...Object.keys(result.rules)])]
                    .filter(n => baseline.rules[n] !== result.rules[n])
                    .map(n => ({ name: n, before: baseline.rules[n], after: result.rules[n] })) });
            if (row.kept) { files[file] = snapshot[file]; baseline = result; }
        } catch (e) { Object.assign(row, { error: e.message, kept: false }); }
        report.results.push(row);
        console.log(JSON.stringify(row));
    }
    report.after = baseline.elements;
    report.saved = report.before - report.after;
    if (apply) {
        for (const [name, text] of Object.entries(files)) {
            const original = originals[name];
            if (text === original.replace(/\r\n/g, '\n')) continue;
            assert.equal(fs.readFileSync(path.join(src, name), 'utf8'), original, 'Source changed during measurement: ' + name);
            fs.writeFileSync(path.join(src, name), original.includes('\r\n') ? text.replace(/\n/g, '\r\n') : text);
        }
    }
    fs.writeFileSync(path.join(__dirname, 'switch-optimization-results.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({ before: report.before, after: report.after, saved: report.saved, kept: report.results.filter(r => r.kept).length }));
}
main().catch(e => { console.error(e); process.exitCode = 1; });
