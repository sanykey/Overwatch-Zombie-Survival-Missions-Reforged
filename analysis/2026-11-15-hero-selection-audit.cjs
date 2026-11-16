// Read-only source audit. Writes only its JSON report beside this script.
const fs = require('node:fs');
const path = require('node:path');
const cp = require('node:child_process');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const version = 'zezombye.overpy-9.7.21';
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions', version, 'npm/overpy.js'));
const sha = text => crypto.createHash('sha256').update(text).digest('hex');
function stats(text) {
    const rules = [...text.matchAll(/^rule\s*\("([^"\n]+)"\)\s*\{([\s\S]*?)^\}/gm)];
    const events = {};
    const largest = [];
    let conditions = 0;
    for (const [, name, body] of rules) {
        const event = body.match(/event\s*\{\s*([^;]+);/)?.[1].trim();
        assert(event, name);
        const block = body.match(/conditions\s*\{([\s\S]*?)\n\s*\}/)?.[1] || '';
        // Quoted Workshop comments may themselves contain semicolons.
        const entries = block.split('\n').map(line => line.trim()).filter(line => /^(?!disabled\b)[A-Za-z_(].*;/.test(line)).length;
        conditions += entries;
        events[event] ??= {rules: 0, conditions: 0};
        events[event].rules++;
        events[event].conditions += entries;
        largest.push({name, event, conditions: entries});
    }
    return {sha256: sha(text), rules: rules.length, conditions, events,
        largestConditionLists: largest.sort((a,b) => b.conditions - a.conditions).slice(0, 12),
        allowedHeroActions: text.split('\n').filter(l => /(?:Set Player Allowed Heroes|Reset Player Hero Availability)\(/.test(l)).map(l => l.trim())};
}
function inline(file) {
    return fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n')
        .replace(/^#!mainFile .*\n/gm, '')
        .replace(/^#!writeToOutputFile.*\n/gm, '')
        .replace(/^#!include "([^"]+)".*$/gm, (_, name) => inline(path.resolve(path.dirname(file), name)));
}
(async () => {
    await compiler.readyPromise;
    const input = inline(require('./source-layout.cjs').sourcePath('includes.opy'));
    const result = await compiler.compile(input, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
    assert.deepEqual(result.encounteredWarnings, []);
    const report = {date: '2026-11-15', compiler: version,
        limitation: 'Static compilation only; no native UI reproduction, timing, memory or CPU measurements.',
        current: {sourceSha256: sha(input), elements: result.nbElements, warnings: result.encounteredWarnings, ...stats(result.result)},
        historicalExports: {}, compilerProbes: {}};
    for (const ref of ['f84a148b89c400ae3a6ececa6ae1e81e91bb859c', '30bddc91ecd0465f0b2bb2824d37ea00ccf40a91', 'e23f73d2ac3af65bba98d509f08625eb493b23e3', 'experiment-hero-selection-grouped-conditions']) {
        const text = cp.execFileSync('git', ['show', ref + ':main.ws.txt'], {cwd: root, encoding: 'utf8', maxBuffer: 16 * 1024 * 1024});
        report.historicalExports[ref] = stats(text);
    }
    const predicates = {
        separate: '    @Condition phase == true\n    @Condition eventPlayer.isAlive() == true',
        andTrue: '    @Condition (phase == true and eventPlayer.isAlive() == true) == true',
        andOne: '    @Condition ((phase == true) and (eventPlayer.isAlive() == true)) == 1'
    };
    for (const [name, predicate] of Object.entries(predicates)) {
        const probe = await compiler.compile('#!optimizeForSize\n#!optimizeForSizeAggressive\n#!debugElementCount\nglobalvar phase\nrule "probe":\n    @Event eachPlayer\n' + predicate + '\n    smallMessage(eventPlayer, "probe")\n', 'en-US');
        report.compilerProbes[name] = {elements: probe.nbElements, ...stats(probe.result), workshop: probe.result};
    }
    assert.equal(report.compilerProbes.separate.conditions, 2);
    assert.equal(report.compilerProbes.andTrue.conditions, 2);
    assert.equal(report.compilerProbes.andOne.conditions, 1);
    fs.writeFileSync(path.join(__dirname, '2026-11-15-hero-selection-audit.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({current: report.current, historical: Object.fromEntries(Object.entries(report.historicalExports).map(([ref,s]) => [ref, {rules:s.rules, conditions:s.conditions, events:s.events}])), probes: Object.fromEntries(Object.entries(report.compilerProbes).map(([name,s]) => [name,{elements:s.elements,conditions:s.conditions}]))}, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
