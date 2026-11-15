// Derive C/D/E from frozen A. D/E leave the user-tested A/B/C exports untouched.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const prefix = '2026-11-15-pregame-text-';
const file = suffix => path.join(__dirname, prefix + suffix);
const sha = s => crypto.createHash('sha256').update(s).digest('hex');
const mode = process.argv[2] || 'C';
const configs = {
    C: {suffix:'C-no-text', remove:['Create HUD Text','Create In-World Text'], expected:17, description:'No selected Pregame texts'},
    D: {suffix:'D-hud-only', remove:['Create In-World Text'], expected:10, description:'Restore selected Pregame HUD; omit selected world texts'},
    E: {suffix:'E-world-only', remove:['Create HUD Text'], expected:7, description:'Restore selected Pregame world texts; omit selected HUD'},
    F: {suffix:'F-global-world-only', remove:['Create HUD Text'], worldRule:48, expected:12, description:'Global Pregame world texts only; no selected HUD or per-player world texts'},
    G: {suffix:'G-player-world-only', remove:['Create HUD Text'], worldRule:38, expected:12, description:'Per-player Pregame world texts only; no selected HUD or global world texts'},
    H: {suffix:'H-player-hero-status', remove:['Create HUD Text'], worldRule:38, keepPlayer:[1,2], expected:15, description:'Player hero icon and selection status only'},
    I: {suffix:'I-player-vote-name-icons', remove:['Create HUD Text'], worldRule:38, keepPlayer:[3,4,5], expected:14, description:'Player Voting, name and Enhancement/Augment icons only'}
};
assert(configs[mode], 'Use C, D, E, F or G');
const config = configs[mode];
const shouldRemove = (action, index, ordinal) => config.remove.includes(action) || (action === 'Create In-World Text' && (index === config.worldRule || (index === 48 && config.keepPlayer && !config.keepPlayer.includes(ordinal))));
const frozen = ['A-control','B-static','C-no-text','D-hud-only','E-world-only','F-global-world-only','G-player-world-only'].filter(s => !s.startsWith(mode+'-'))
    .map(s => [s, sha(fs.readFileSync(file(s+'.ws.txt'),'utf8'))]);
const originalC = mode === 'C' ? null : fs.readFileSync(file('C-no-text.ws.txt'), 'utf8');
const control = fs.readFileSync(file('A-control.ws.txt'), 'utf8');
const prior = JSON.parse(fs.readFileSync(file('validation.json'), 'utf8'));
assert.equal(sha(control), prior.controlSha256, 'Frozen control changed');
const targets = new Map(prior.changedRules.map(r => [r.index, r.name]));
const deleted = [];
let ruleIndex = 0;
let body = control.replace(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm, (whole, name) => {
    const index = ruleIndex++;
    if (!targets.has(index)) return whole;
    assert.equal(name, targets.get(index));
    assert(!/Last Text ID|Destroy HUD Text|Destroy In-World Text/.test(whole), 'Text ID lifetime needs a separate review');
    // Compiler emits one action per physical line. Never remove a control-flow
    // instruction or any effect; these three blocks contain unguarded text calls.
    let worldOrdinal = 0;
    return whole.replace(/^([ \t]*)(Create HUD Text|Create In-World Text)\([^\r\n]*; \/\/ (\d+) elements?\r?\n/gm,
        (line, indent, action, cost) => {
            if (action === 'Create In-World Text') worldOrdinal++;
            if (!shouldRemove(action, index, worldOrdinal)) return line;
            deleted.push({ruleIndex:index, rule:name, action, worldOrdinal:action === 'Create In-World Text' ? worldOrdinal : undefined, elements:Number(cost)});
            return '';
        }).replace(/^[ \t]*"[^\r\n]*"\r?\n/gm, ''); // Workshop comments only.
});
assert.equal(deleted.length, config.expected);
assert.equal(deleted.filter(d => d.action === 'Create HUD Text').length, config.remove.includes('Create HUD Text') ? 7 : 0);
assert.equal(deleted.filter(d => d.action === 'Create In-World Text').length, config.keepPlayer ? 10-config.keepPlayer.length : config.worldRule !== undefined ? 5 : config.remove.includes('Create In-World Text') ? 10 : 0);
const removedElements = deleted.reduce((sum,d) => sum + d.elements, 0);
const totalElements = prior.controlElements - removedElements;
// Avoid retaining the old compiler's per-rule and total cost annotations.
body = body.replace(/^\/\*[\s\S]*?\*\//, `/* Diagnostic ${mode}: ${config.description}.\nElement count: (total ${totalElements}); derived from frozen A by removing ${removedElements} compiled elements.\nMalevento + 5 standard lobby bots in the same teams: select Shion, then Crouch. No Enhancement/Augment selection.\n*/`)
    .replace(/^\/\/\d+ elements\r?\n/gm, '');
function normalize(text) {
    return text.replace(/\/\*[\s\S]*?\*\//g, '').split('\n')
        .filter(l => !/^\s*(?:\/\/|")/.test(l))
        .map(l => l.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n');
}
const beforeRules = [...control.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)];
const afterRules = [...body.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)];
assert.equal(beforeRules.length, afterRules.length);
for (let i = 0; i < beforeRules.length; i++) {
    let expected = beforeRules[i][0];
    let worldOrdinal = 0;
    if (targets.has(i)) expected = expected.replace(/^[ \t]*(Create HUD Text|Create In-World Text)\([^\r\n]*; \/\/ \d+ elements?\r?\n/gm,
        (line, action) => {
            if (action === 'Create In-World Text') worldOrdinal++;
            return shouldRemove(action, i, worldOrdinal) ? '' : line;
        });
    assert.equal(normalize(afterRules[i][0]), normalize(expected), `Unexpected rule change: ${i}`);
}
const controlPrefix = control.slice(0, control.indexOf('rule ('));
const variantPrefix = body.slice(0, body.indexOf('rule ('));
assert.equal(normalize(controlPrefix), normalize(variantPrefix), 'Settings or declarations changed');
(async () => {
    await compiler.readyPromise;
    // Parse both exports, including C's intentionally empty AUGMENT MENU action
    // list, without recompiling and optimizing the frozen control's structure.
    await compiler.decompileAllRules(control, 'en-US');
    await compiler.decompileAllRules(body, 'en-US');
    fs.writeFileSync(file(config.suffix + '.ws.txt'), body);
    const report = {input:'2026-11-15-pregame-text-A-control.ws.txt', inputSha256:sha(control), outputSha256:sha(body),
        controlElements:prior.controlElements, probeElements:totalElements, delta:-removedElements,
        countMethod:'Subtract compiler-annotated costs of removed actions from frozen compiled total; no source-line estimate.',
        mode, description:config.description,
        rules:beforeRules.length, changedRules:prior.changedRules.filter(r => deleted.some(d => d.ruleIndex === r.index)), deleted,
        verification:`OverPy 9.7.21 decompiler accepted both exports. Every rule compared: only ${deleted.length} selected text-creation actions and comments removed. Settings/declarations unchanged. No native game test.`,
        scenario:'Malevento, 5 standard lobby bots in the same teams, Shion, no Enhancement/Augment selection, Crouch back to hero selection.',
        limitation:'Selected Pregame objects absent; diagnostic only. Effects, objective description and debug HUD remain. Removing creation also reduces code size and action work; a positive result does not identify an engine/network mechanism.'};
    fs.writeFileSync(file(mode + '-validation.json'), JSON.stringify(report,null,2)+'\n');
    assert.equal(sha(fs.readFileSync(file('A-control.ws.txt'),'utf8')), prior.controlSha256);
    assert.equal(sha(fs.readFileSync(file('B-static.ws.txt'),'utf8')), prior.probeSha256);
    if (originalC !== null) assert.equal(fs.readFileSync(file('C-no-text.ws.txt'),'utf8'), originalC);
    for (const [suffix, hash] of frozen) assert.equal(sha(fs.readFileSync(file(suffix+'.ws.txt'),'utf8')),hash);
    console.log(JSON.stringify({...report, deleted:deleted.length},null,2));
})().catch(error => {console.error(error);process.exitCode=1;});
