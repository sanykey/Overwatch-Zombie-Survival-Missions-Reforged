// Thirty-sixth element candidates: read-only measurements against the committed baseline (42c78b9, 29766).
// Run: node analysis/2026-11-18-thirty-sixth-element-candidates.cjs
const fs = require('node:fs'), path = require('node:path'), assert = require('node:assert/strict');
const { compile, rules, menuHudCalls, splitArgs, files, nestedPredicates: np } = (() => {
  const m = require('./2026-11-18-thirty-fifth-element-candidates.cjs');
  return { compile: m.compile, rules: m.rules, menuHudCalls: m.menuHudCalls, splitArgs: m.splitArgs, files: m.files, nestedPredicates: require('./2026-11-18-workshop-predicate-nesting.cjs').nestedPredicates };
})();
const root = path.resolve(__dirname, '..'); process.chdir(root);

function region(f, file, start, end, fn) {
  const i = f[file].indexOf(start), j = f[file].indexOf(end, i + start.length);
  assert(i >= 0 && j > i, start);
  f[file] = f[file].slice(0, i) + fn(f[file].slice(i, j)) + f[file].slice(j);
}
function replaceOnce(f, file, a, b) { assert(f[file].includes(a), a); f[file] = f[file].replace(a, b); }

const candidates = {
  // Known −8 from the thirty-fifth batch.
  spawn_metadata_direct_index(f) {
    const file = 'game/global_start_menu.opy';
    for (const kind of ['OFFSETS', 'LENGTHS']) {
      const old = `numbersList.slice(NL_SPAWN_MODE_${kind}_OFFSET, NL_SPAWN_MODE_${kind}_LEN)[zombieSetting - 1]`;
      assert(f[file].includes(old));
      f[file] = f[file].replace(old, `numbersList[(NL_SPAWN_MODE_${kind}_OFFSET - 1) + zombieSetting]`);
    }
  },

  // Four start-menu HUD cards in one loop. Fixes the thirty-fifth attempt: the
  // previous replacement emitted a trailing comma after the last argument, which
  // OverPy parses as an empty 11th argument ("Content is empty" error).
  menu_hud_loop(f) {
    const file = 'game/global_start_menu.opy', calls = menuHudCalls(f[file]);
    assert.equal(calls.length, 4);
    assert(calls.every(c => c.args.length === 10));
    for (const i of [0, 4, 9]) assert(calls.every(c => c.args[i] === calls[0].args[i]));
    const old = f[file].slice(calls[0].start, calls.at(-1).end);
    const assignments = old.split('\n').filter(s => /^    startMenu\w+ColorList = /.test(s));
    assert.equal(assignments.length, 3);
    const args = calls[0].args.map((value, i) =>
      [1, 2, 3, 6, 7, 8].includes(i)
        ? '[\n' + calls.map(c => '            ' + c.args[i].replace(/\n/g, '\n            ') + ',').join('\n') + '\n        ][evalOnce(menuHudCategoryIndex)]'
        : i === 5 ? 'evalOnce(menuHudCategoryIndex)' : value);
    const body = args.map((a, i) => '            ' + a + (i < args.length - 1 ? ',' : '')).join('\n');
    const replacement = assignments.join('\n')
      + '\n    # Four viewer-driven cards; freeze only category identity, keep all content live.\n'
      + '    #!define menuHudCategoryIndex tmp0\n'
      + '    for menuHudCategoryIndex in range(4):\n'
      + '        hudText(\n' + body + '\n        )\n';
    f[file] = f[file].slice(0, calls[0].start) + replacement + f[file].slice(calls.at(-1).end);
  },
};

// Convert a source switch over currentObjectiveType into an if/elif chain.
// The compiled Skip dispatch (Value In Array + 1 + Index Of Array Value) costs ~35
// elements; six linear comparisons cost ~4 each. Case bodies never assign
// currentObjectiveType, so re-reading it per elif is equivalent to the single
// switch read; there is no fallthrough in either form (all arms end with break).
const lineStart = (t, i) => t.lastIndexOf('\n', i) + 1; // index of the line start containing offset i

function switchToIfChain(text, key) {
  const lines = text.split('\n');
  const out = [];
  let first = true;
  let caseIndent = null, bodyIndent = null, baseIndent = null;
  for (const line of lines) {
    if (baseIndent === null && line.trim()) baseIndent = line.length - line.trimStart().length;
    if (new RegExp('^\\s*switch ' + key + ':\\s*$').test(line)) { continue; }
    if (caseIndent === null) {
      const m = /^(\s+)case /.exec(line);
      if (m) { caseIndent = m[1].length; bodyIndent = caseIndent + 4; }
      else { out.push(line); continue; }
    }
    const caseRe = new RegExp('^(\\s{' + caseIndent + '})case ([^:]+):\\s*$');
    const caseMatch = caseRe.exec(line);
    if (caseMatch) {
      const pad = ' '.repeat(caseIndent - 4);
      out.push(pad + (first ? 'if ' : 'elif ') + key + ' == ' + caseMatch[2] + ':');
      first = false;
      continue;
    }
    if (new RegExp('^\\s{' + bodyIndent + '}break\\s*$').test(line)) continue;
    const indent = line.length - line.trimStart().length;
    if (indent > baseIndent && line.startsWith('    ')) out.push(line.slice(4)); // shift only switch-owned lines
    else out.push(line);
  }
  return out.join('\n');
}

function regionBounds(text, startMarker, endMarker) {
  const i = text.indexOf(startMarker);
  assert(i >= 0, startMarker);
  const j = text.indexOf(endMarker, i);
  assert(j > i, endMarker);
  return [i, j];
}

// Both objectivesManagement switches become if/elif chains.
candidates.objective_switches_to_if_chain = f => {
  const file = 'core/subroutines.opy';
  const lineStart = (t, i) => t.lastIndexOf('\n', i) + 1; // include the switch line's own indent
  // Second switch first: setup switch ends at the global-entity comment.
  const raw2 = f[file].indexOf('switch currentObjectiveType:', f[file].indexOf('#Checks if current objective is showdown') + 400);
  assert(raw2 > 0);
  const a2 = lineStart(f[file], raw2);
  const end2 = f[file].indexOf('\n    #Updates global objective entities', a2) + 1;
  f[file] = f[file].slice(0, a2) + switchToIfChain(f[file].slice(a2, end2), 'currentObjectiveType') + f[file].slice(end2);
  // First switch: completion switch ends at the contiguous-ID comment.
  const a1 = lineStart(f[file], f[file].indexOf('switch currentObjectiveType:'));
  const end1 = f[file].indexOf('\n        # Objective IDs 1..7 are contiguous', a1) + 1;
  f[file] = f[file].slice(0, a1) + switchToIfChain(f[file].slice(a1, end1), 'currentObjectiveType') + f[file].slice(end1);
  assert(!f[file].includes('switch currentObjectiveType:'));
};

candidates.combined = f => { candidates.spawn_metadata_direct_index(f); candidates.objective_switches_to_if_chain(f); };

async function main() {
  const baseline = await compile(files);
  assert.equal(baseline.nbElements, 29766);
  const before = rules(baseline.result);
  const report = { baselineRef: '42c78b9fc6f14e4c93442cb2f11a529df4612ae1', baseline: baseline.nbElements, results: [], inGameValidation: false, serverLoadMeasured: false };
  for (const [name, fn] of Object.entries(candidates)) {
    const f = { ...files }; fn(f);
    const r = await compile(f), after = rules(r.result);
    assert.deepEqual(Object.keys(before), Object.keys(after));
    assert.deepEqual(np(r.result), []);
    const row = { name, elements: r.nbElements, saved: baseline.nbElements - r.nbElements, warnings: r.encounteredWarnings, changedRules: Object.keys(before).filter(n => before[n] !== after[n]) };
    report.results.push(row);
    console.log(row);
    fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-sixth-' + name + '.ws.txt'), r.result);
  }
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-sixth-element-candidates.json'), JSON.stringify(report, null, 2) + '\n');
}
module.exports = { candidates, files, compile, rules };
if (require.main === module) main().catch(e => { console.error(e); process.exitCode = 1; });
