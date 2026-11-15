// Build a matched control and a diagnostic export; never edit gameplay sources.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const prefix = '2026-11-15-pregame-text-';
const sha = value => crypto.createHash('sha256').update(value).digest('hex');
const targeted = new Set(['global_start_menu.opy', 'player_start_menu.opy', 'augments.opy']);
const replacements = [];
function parseCall(text, open) {
    let depth = 0, quote = '', start = open + 1;
    const args = [];
    for (let i = open + 1; i < text.length; i++) {
        const ch = text[i];
        if (quote) {
            if (ch === '\\') i++;
            else if (ch === quote) quote = '';
        } else if (ch === '"' || ch === "'") quote = ch;
        else if ('([{'.includes(ch)) depth++;
        else if (ch === ')' && depth === 0) {
            args.push(text.slice(start, i).trim());
            return {args, end: i + 1};
        } else if (')]}'.includes(ch)) depth--;
        else if (ch === ',' && depth === 0) {
            args.push(text.slice(start, i).trim()); start = i + 1;
        }
    }
    throw new Error('Unclosed call');
}
function simplify(text, file) {
    const re = /^(    )(hudText|hudSubtext|hudSubheader|createInWorldText)\(/gm;
    let out = '', cursor = 0;
    for (let match; (match = re.exec(text));) {
        const open = re.lastIndex - 1;
        const {args, end} = parseCall(text, open);
        const name = match[2];
        const id = replacements.length + 1;
        if (name === 'hudText') {
            assert(args.length >= 10);
            args[1] = JSON.stringify('DIAG menu ' + id);
            args[2] = '"Static description"'; args[3] = '"Static hint"';
            args[6] = args[7] = args[8] = 'Color.WHITE';
        } else if (name === 'createInWorldText') {
            assert(args.length >= 6);
            args[1] = JSON.stringify('DIAG world ' + id);
            args[6] = 'Color.WHITE';
        } else {
            assert(args.length >= 6);
            args[1] = JSON.stringify('DIAG text ' + id);
            args[4] = 'Color.WHITE';
        }
        replacements.push({file, function: name, label: id});
        out += text.slice(cursor, match.index) + '    ' + name + '(' + args.join(', ') + ')';
        cursor = end; re.lastIndex = end;
    }
    return out + text.slice(cursor);
}
function inline(file, variant) {
    let text = fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n');
    if (variant && targeted.has(path.basename(file))) text = simplify(text, path.basename(file));
    return text.replace(/^#!mainFile .*\n/gm, '').replace(/^#!writeToOutputFile.*\n/gm, '')
        .replace(/^#!include "([^"]+)".*$/gm, (_, name) => inline(path.resolve(path.dirname(file), name), variant));
}
function normalize(text) {
    return text.replace(/\/\*[\s\S]*?\*\//g, '').split('\n')
        .filter(line => !/^\s*\/\//.test(line))
        .map(line => line.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
}
// Mask only text/color arguments. Equality afterward proves settings, rule
// order, Events, Conditions, all other actions and other HUD arguments match.
function maskVisualArgs(text) {
    const re = /\b(Create HUD Text|Create In-World Text)\(/g;
    let out = '', cursor = 0;
    for (let match; (match = re.exec(text));) {
        const {args, end} = parseCall(text, re.lastIndex - 1);
        const indices = match[1] === 'Create HUD Text' ? [1,2,3,6,7,8] : [1,6];
        for (const index of indices) args[index] = '<visual>';
        out += text.slice(cursor, match.index) + match[1] + '(' + args.join(', ') + ')';
        cursor = end; re.lastIndex = end;
    }
    return normalize(out + text.slice(cursor));
}
(async () => {
    await compiler.readyPromise;
    const originalExport = fs.readFileSync(path.join(root, 'main.ws.txt'), 'utf8');
    const testedExport = fs.readFileSync(path.join(src, 'includes.ws.txt'), 'utf8');
    const input = inline(path.join(src, 'includes.opy'), false);
    const control = await compiler.compile(input, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    const changedInput = inline(path.join(src, 'includes.opy'), true);
    const variant = await compiler.compile(changedInput, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(control.encounteredWarnings, []);
    assert.deepEqual(variant.encounteredWarnings, []);
    assert.equal(replacements.length, 17);
    assert.equal(maskVisualArgs(control.result), maskVisualArgs(variant.result));
    const rules = text => [...text.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(m => ({name: m[1], text: m[0]}));
    const before = rules(control.result), after = rules(variant.result);
    assert.equal(before.length, after.length);
    const changedRules = before.flatMap((r,i) => normalize(r.text) === normalize(after[i].text) ? [] : [{index:i, name:r.name}]);
    assert.deepEqual(changedRules.map(r => r.name), ['EFFECTS/TEXTS', 'EFFECTS/TEXT', 'AUGMENT MENU']);
    const report = {compiler:'OverPy 9.7.21', sourceSha256:sha(input),
        testedExport:'src/includes.ws.txt', testedExportSha256:sha(testedExport),
        controlMatchesTestedExport: normalize(testedExport) === normalize(control.result),
        controlMatchesMainExport: normalize(originalExport) === normalize(control.result),
        originalExportSha256:sha(originalExport), controlSha256:sha(control.result), probeSha256:sha(variant.result),
        controlElements:control.nbElements, probeElements:variant.nbElements, delta:variant.nbElements-control.nbElements,
        changedRules, changedVisualCalls:replacements,
        verified:'Only text/color arguments differ in 3 pregame visual rules. All other normalized compiled content is identical.',
        limitation:'Diagnostic only: static labels hide vote/selection feedback. No native game test. Reduced code size is an additional confound; improvement would not prove a CPU or network mechanism.'};
    fs.writeFileSync(path.join(__dirname,prefix+'A-control.ws.txt'),control.result);
    fs.writeFileSync(path.join(__dirname,prefix+'B-static.ws.txt'),variant.result);
    // Preserve the already present export separately if sources have moved on.
    if (!report.controlMatchesMainExport) fs.writeFileSync(path.join(__dirname,prefix+'original-main.ws.txt'), originalExport);
    fs.writeFileSync(path.join(__dirname,prefix+'tested-includes.ws.txt'),testedExport);
    if (!report.controlMatchesTestedExport) {
        const a = normalize(testedExport).split('\n'), b = normalize(control.result).split('\n');
        const index = a.findIndex((line,i) => line !== b[i]);
        report.firstTestedDifference = {line:index+1, tested:a.slice(index,index+4), current:b.slice(index,index+4)};
    }
    fs.writeFileSync(path.join(__dirname,prefix+'validation.json'),JSON.stringify(report,null,2)+'\n');
    assert.equal(fs.readFileSync(path.join(root, 'main.ws.txt'), 'utf8'), originalExport);
    console.log(JSON.stringify(report,null,2));
})().catch(error => {console.error(error);process.exitCode=1;});
