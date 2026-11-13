// Compile the working tree and verify the ultimate damage resist recompute:
// structure, call-site ordering and the strongest-resist-wins truth table.
// Run: node analysis/2026-11-13-verify-ult-resist.cjs
// The shared measure-further-optimizations.cjs helper currently crashes with
// the bundled 9.7.21 API, so this script shells out to the /tmp CLI install
// (see memory overpy-cli-compilation) instead of requiring it.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const root = path.resolve(__dirname, '..');
const overpyDir = path.join(process.env.LOCALAPPDATA, 'Temp', 'overpy-check');

(async () => {
const outFile = path.join(root, 'analysis', '2026-11-13-verify-ult-resist.tmp.ws.txt');
execFileSync('node', [path.join(overpyDir, 'node_modules/overpy/cli.js'), 'compile',
    '-i', path.join(root, 'main.opy'), '-o', outFile, '--root', root], {stdio: 'pipe'});
const out = fs.readFileSync(outFile, 'utf8');
fs.unlinkSync(outFile);
const r = {elements: Number(out.match(/\/\* Element count: \(total (\d+)\)/)[1])};

// One subroutine, one rule, and the expected compiled formula.
const sub = out.match(/rule \("applyDamageReceivedModifier"\) \{[\s\S]*?\n\}/);
assert(sub, 'applyDamageReceivedModifier subroutine missing');
assert((out.match(/rule \("applyDamageReceivedModifier"\)/g) || []).length === 1, 'subroutine declared more than once');
assert((out.match(/Call Subroutine\(applyDamageReceivedModifier\)/g) || []).length === 7, 'expected 7 call sites: rule x2, dash activate/fade, player died, nano start/end');

const rule = out.match(/rule \("PLAYER ULTIMATE DAMAGE RESIST"\) \{[\s\S]*?\n\}/);
assert(rule, 'PLAYER ULTIMATE DAMAGE RESIST rule missing');
assert(rule[0].includes('Is Using Ultimate(Event Player) == True'), 'rule must key on Is Using Ultimate');
assert(rule[0].includes('Hero Of(Event Player) != Hero(D.Mon)'), 'rule must exclude D.Mon');
assert(rule[0].includes('Hero Of(Event Player) != Hero(D.Va)'), 'rule must exclude D.Va');
assert(rule[0].includes('Wait Until(Not(Is Using Ultimate(Event Player)), '), 'rule must wait for the ult to end');
assert(rule[0].indexOf('Call Subroutine') < rule[0].indexOf('Wait Until'), 'recompute must run on the start edge');
assert(rule[0].lastIndexOf('Call Subroutine') > rule[0].indexOf('Wait Until'), 'recompute must run on the end edge');

// Call-site ordering inside the writers.
const dashAct = out.slice(out.indexOf('Set Player Variable(Event Player, augmentState3, Add(Total Time Elapsed, 1.7))'),
    out.indexOf('Apply Impulse(Event Player, Direction From Angles(Add(Horizontal Facing Angle Of(Event Player), Horizontal Angle From Direction(Global.tmp0))'));
assert(dashAct.includes('Call Subroutine(applyDamageReceivedModifier)'), 'dash activation must open the smoke window before recomputing');

const fade = out.match(/rule \("DASH SMOKE FADE"\) \{[\s\S]*?\n\}/)[0];
assert(fade.indexOf('Set Player Variable(Event Player, augmentState1, Null)') < fade.indexOf('Call Subroutine(applyDamageReceivedModifier)'), 'fade must clear the handle before recomputing');

const died = out.match(/rule \("PLAYER DIED"\) \{[\s\S]*?\n\}/)[0];
const diedCall = died.indexOf('Call Subroutine(applyDamageReceivedModifier)');
assert(diedCall > died.indexOf('Set Player Variable(Event Player, augmentState1, Null)'), 'PLAYER DIED must clear the dash smoke first');
assert(diedCall < died.indexOf('If(Compare((Event Player).scrapArmorAmount'), 'PLAYER DIED recompute must stay unconditional (outside the Dash block)');

const nano = out.slice(out.indexOf('rule ("superNano (70-79)")'), out.indexOf('rule ("JETPACK FUEL HUD")'));
assert(nano.indexOf('Call Subroutine(applyDamageReceivedModifier)') > nano.indexOf('Heal(Event Player, Null, 100)'), 'nano start must set the aura handle first');
assert(nano.indexOf('Set Player Variable(Event Player, powerUpSuperNanoGoodAuraId, Null)') < nano.lastIndexOf('Call Subroutine(applyDamageReceivedModifier)'), 'nano cleanup must clear the handle before recomputing');
assert(!nano.includes('Set Damage Received(Event Player, 50)'), 'nano must not write a direct 50 intake anymore');

// No stray direct writers left for Team 1 players; bot writes stay (Pharah
// charge/dead/restore plus the botStatManagementMacro reset).
const stray = [...out.matchAll(/Set Damage Received\(Event Player, (?:0|50|100)\)/g)].map(m => m.index);
assert(stray.length === 4, `expected only the 4 bot-side writes (Pharah charge/dead/restore + bot stat reset), got ${stray.length}`);

// Truth table evaluated against the REAL compiled If-Then-Else formula.
const formula = sub[0].match(/Set Damage Received\(Event Player, (.*)\);/)[1];
function args(text) {
    const result = []; let start = 0, depth = 0;
    for (let i = 0; i < text.length; i++) {
        if (text[i] === '(') depth++;
        if (text[i] === ')') depth--;
        if (text[i] === ',' && !depth) {result.push(text.slice(start, i).trim()); start = i + 1;}
    }
    return result.concat(text.slice(start).trim());
}
function value(text, s) {
    text = text.trim();
    if (text === 'Null') return 0;
    if (/^\d+$/.test(text)) return Number(text);
    const field = text.match(/^\(Event Player\)\.(\w+)$/);
    if (field) return s[field[1]];
    const call = text.match(/^([\w -]+)\((.*)\)$/);
    assert(call, 'Unsupported value: ' + text);
    const a = args(call[2]);
    const v = i => value(a[i], s);
    switch (call[1]) {
        case 'Compare': {
            const l = v(0), rr = v(2);
            // Workshop falsey group: zero, Null, unset variables all compare equal.
            return a[1] === '==' ? l === rr : l !== rr;
        }
        case 'Or': return v(0) || v(1);
        case 'And': return v(0) && v(1);
        case 'If-Then-Else': return v(0) ? v(1) : v(2);
        case 'Is Using Ultimate': return s.ult;
        case 'Hero Of': return s.hero;
        case 'Hero': return a[0];
        default: assert.fail('Unsupported call: ' + call[1]);
    }
}
// The engine renders the dash's 0 intake as Null, which behaves as 0 intake
// (zero == Null per workshop.codes comparisons-and-truth).
function intake({dash = false, nano = false, ult = false, mech = null}) {
    return value(formula, {
        augmentId: dash ? 2 : 0,
        augmentState1: dash ? 101 : 0,
        powerUpSuperNanoGoodAuraId: nano ? 102 : 0,
        ult: ult ? 1 : 0,
        hero: mech ?? 'Soldier',
    });
}
assert(intake({}) === 100, 'plain player takes full damage');
assert(intake({ult: true}) === 50, 'ult gives 50 intake');
assert(intake({ult: true, mech: 'D.Mon'}) === 100, 'stuck-true D.Mon gets no ult resist');
assert(intake({ult: true, mech: 'D.Va'}) === 100, 'stuck-true D.Va gets no ult resist');
assert(intake({nano: true}) === 50, 'nano keeps its 50 intake');
assert(intake({nano: true, ult: true}) === 50, 'nano and ult must not stack');
assert(intake({dash: true}) === 0, 'dash window stays strongest');
assert(intake({dash: true, nano: true}) === 0, 'dash beats nano');
assert(intake({dash: true, nano: true, ult: true}) === 0, 'dash beats nano and ult');
assert(intake({nano: true, mech: 'D.Mon'}) === 50, 'D.Mon keeps the nano resist');
assert(intake({dash: true, mech: 'D.Mon'}) === 0, 'D.Mon keeps the dash resist');
assert(intake({nano: true, mech: 'D.Va'}) === 50, 'D.Va keeps the nano resist');
assert(intake({dash: true, mech: 'D.Va'}) === 0, 'D.Va keeps the dash resist');

console.log(`OK: structure and truth table verified, total ${r.elements} elements`);
})();
