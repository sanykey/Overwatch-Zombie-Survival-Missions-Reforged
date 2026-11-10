// Measures candidate element-count optimizations for the experiments-rebuild branch.
// Baseline 2026-11-10 before implementation: 29,975 elements, 0 warnings (OverPy 9.7.21).
// Measured results, each compiled separately from that baseline:
//   C1 strip "@Condition ... == true" (342 occurrences)      => 29,972 (-3): not worth it,
//      the compiler counts literal comparisons in conditions as nearly free.
//   C4 hoist AUGMENT_NAMES and both melee hero lists into
//      runtime global constants (6 use sites, +3 globalvar)   => measured -27 at the pre-C5
//      baseline. IMPLEMENTED 2026-11-10 with rule-based initialization in VARIABLE ASSIGNMENT:
//      actual delta -34 (29,963 -> 29,929). Module-level `globalvar x = [...]` initializers
//      let #!optimizeForSizeAggressive fold the string table back into its use sites and drop
//      the assignment as dead code, so the initializers must stay inside the rule.
//   C5 merge the 7 setup bigMessage calls in objectivesManagement
//      into one indexed call with the existing ID range guard => 29,963 (-12).
//      IMPLEMENTED 2026-11-10; the transform now reports "already implemented".
//   Combined C1+C4+C5                                        => 29,933 (-42), 0 warnings.
// The live baseline after the C5/C4 implementations is 29,929; skips a candidate when
// its source pattern is no longer present. Read-only with respect to src/.
const fs = require('fs');
const path = require('path');
const assert = require('assert');

const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const extdir = path.join(process.env.USERPROFILE, '.vscode/extensions');
const ext = fs.readdirSync(extdir).filter(n => n.startsWith('zezombye.overpy-'))
    .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }))[0];
const compiler = require(path.join(extdir, ext, 'npm', 'overpy.js'));

function readTree(dir, prefix = '') {
    return Object.fromEntries(fs.readdirSync(dir, { withFileTypes: true }).flatMap(e => {
        const name = prefix + e.name;
        return e.isDirectory() ? Object.entries(readTree(path.join(dir, e.name), name + '/')) :
            e.name.endsWith('.opy') ? [[name, fs.readFileSync(path.join(dir, e.name), 'utf8').replace(/\r\n/g, '\n')]] : [];
    }));
}

function source(f) {
    return f['includes.opy'].replace(/^#!include "([^"]+)".*$/gm, (line, n) =>
        n.startsWith('vas/') ? line : f[n].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/^#!writeToOutputFile.*\n/gm, '');
}

async function compileQ(f) {
    const saved = [console.log, console.warn, console.error];
    console.log = console.warn = console.error = () => {};
    try {
        const r = await compiler.compile(source(f), 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
        return { elements: r.nbElements, warnings: r.encounteredWarnings };
    } finally { [console.log, console.warn, console.error] = saved; }
}

function clone(f) { return Object.fromEntries(Object.entries(f).map(([k, v]) => [k, v])); }

// C1/C2: strip trailing "== true" from @Condition lines
function stripCondTrue(f, onlyMethodCalls) {
    const out = clone(f);
    const re = onlyMethodCalls
        ? /^(\s*@Condition\b.*\))\s*==\s*true\s*$/gm
        : /^(\s*@Condition\b.*)\s*==\s*true\s*$/gm;
    let n = 0;
    for (const [name, text] of Object.entries(out)) {
        out[name] = text.replace(re, (m, keep) => { n++; return keep; });
    }
    return { files: out, count: n };
}

// C4: hoist AUGMENT_NAMES + melee hero lists into runtime globals (icons/colors already hoisted).
// Returns null when the candidate is already implemented in the source.
function hoistAugmentTables(f) {
    const out = clone(f);
    const names = ['AUGMENT_NAMES', 'AUGMENT_MELEE_WEAPON_HEROES', 'AUGMENT_MELEE_BUTTON_WEAPON_HEROES'];
    const globals = { AUGMENT_NAMES: 'augmentNameListConst', AUGMENT_MELEE_WEAPON_HEROES: 'augmentMeleeWeaponHeroListConst', AUGMENT_MELEE_BUTTON_WEAPON_HEROES: 'augmentMeleeButtonWeaponHeroListConst' };
    if (!out['augments.opy'].includes('#!define AUGMENT_NAMES [')) return null;
    let uses = 0;
    const ordered = ['AUGMENT_MELEE_BUTTON_WEAPON_HEROES', 'AUGMENT_MELEE_WEAPON_HEROES', 'AUGMENT_NAMES'];
    for (const [name, text] of Object.entries(out)) {
        const lines = text.split('\n').map(line => {
            if (line.startsWith('#!define')) return line;
            let next = line;
            for (const n of ordered) {
                next = next.replace(new RegExp(n), () => { uses++; return globals[n]; });
            }
            return next;
        });
        out[name] = lines.join('\n');
    }
    assert(uses >= 5, 'expected uses, got ' + uses);
    out['variables.opy'] = out['variables.opy'].replace(/^globalvar /m, m =>
        names.map(n => 'globalvar ' + globals[n]).join('\n') + '\n' + m);
    // Pull literal arrays from the defines in augments.opy and assign them in VARIABLE ASSIGNMENT
    const literals = names.map(n => {
        const m = out['augments.opy'].match(new RegExp('#!define ' + n + ' (\\[.*?\\])\\n'));
        assert(m, 'define not found: ' + n);
        return `    ${globals[n]} = ${m[1]}`;
    }).join('\n') + '\n';
    const anchor = 'rule "VARIABLE ASSIGNMENT":';
    assert(out['global_startup.opy'].includes(anchor));
    out['global_startup.opy'] = out['global_startup.opy'].replace(anchor, anchor + '\n' + literals);
    return { files: out, count: uses };
}

// C5: objectivesManagement setup bigMessage array
// Returns null when the candidate is already implemented in the source.
function bigMessageArray(f) {
    const out = clone(f);
    const messages = [
        'Proceed to the Showdown!', 'Eliminate the giant zombie!', 'Find the indicated material and deposit it!',
        'Locate survivors and bring them to the extraction site!', 'Get to the kill zone and clear zombies!',
        'Destroy the zombie egg!', 'Repair the satellite control terminals!',
    ];
    if (!out['subroutines.opy'].includes(`                bigMessage(getAllPlayers(), "${messages[0]}")\n`)) return null;
    for (const m of messages) {
        const line = `                bigMessage(getAllPlayers(), "${m}")\n`;
        assert(out['subroutines.opy'].includes(line), 'missing: ' + m);
        out['subroutines.opy'] = out['subroutines.opy'].replace(line, '');
    }
    const anchor = '        switch currentObjectiveType:\n            case ObjectiveType.SHOWDOWN:\n                showdownCapturePercent = 0';
    assert(out['subroutines.opy'].includes(anchor));
    const block = '        if currentObjectiveType >= ObjectiveType.SHOWDOWN and currentObjectiveType <= ObjectiveType.SATELLITE_UPLINK:\n' +
        '            bigMessage(getAllPlayers(), [' + messages.map(m => `"${m}"`).join(', ') + '][currentObjectiveType - 1])\n';
    out['subroutines.opy'] = out['subroutines.opy'].replace(anchor, block + anchor);
    return { files: out };
}

async function main() {
    await compiler.readyPromise;
    const base = readTree(src);
    const baseline = await compileQ(base);
    console.log('baseline:', baseline.elements, 'elements,', baseline.warnings.length, 'warnings');

    const variants = [];
    {
        const r1 = stripCondTrue(base, false);
        variants.push(['C1 strip @Condition "== true" (all ' + r1.count + ')', r1.files]);
        const r4 = hoistAugmentTables(base);
        variants.push(['C4 hoist augment name/hero tables' + (r4 ? ' (' + r4.count + ' uses)' : ' (already implemented)'), r4 && r4.files]);
        const c5 = bigMessageArray(base);
        variants.push(['C5 setup bigMessage array', c5 && c5.files]);
        let rc = stripCondTrue(base, false).files;
        const r4c = hoistAugmentTables(rc);
        if (r4c) rc = r4c.files;
        const c5c = bigMessageArray(rc);
        if (c5c) rc = c5c.files;
        variants.push(['combined C1' + (r4c ? '+C4' : '') + (c5c ? '+C5' : '') + ' (unimplemented candidates only)', rc]);
    }
    for (const [label, files] of variants) {
        if (!files) { console.log(`${label} => skipped: already implemented`); continue; }
        const r = await compileQ(files);
        console.log(`${label} => ${r.elements} (delta ${r.elements - baseline.elements}), warnings ${r.warnings.length}`);
        for (const w of r.warnings.slice(0, 3)) console.log('    warn:', String(w.message || w).slice(0, 160));
    }
}
main().catch(e => { console.error(e); process.exit(1); });
