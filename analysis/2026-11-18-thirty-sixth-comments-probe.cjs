// Probe: do source # comments compile into element-costing Workshop comment actions?
const fs = require('node:fs'), path = require('node:path'), assert = require('node:assert/strict');
const { compile, rules, files, nestedPredicates: np } = (() => {
  const m = require('./2026-11-18-thirty-fifth-element-candidates.cjs');
  return { compile: m.compile, rules: m.rules, files: m.files, nestedPredicates: require('./2026-11-18-workshop-predicate-nesting.cjs').nestedPredicates };
})();
const root = path.resolve(__dirname, '..'); process.chdir(root);

function stripComments(f) {
  const next = {};
  for (const [name, text] of Object.entries(f)) {
    next[name] = text.split('\n').filter(l => !/^\s*#(?!!)/.test(l)).join('\n');
  }
  return next;
}

async function main() {
  const baseline = await compile(files);
  assert.equal(baseline.nbElements, 29766);
  const stripped = stripComments(files);
  const r = await compile(stripped);
  console.log('baseline:', baseline.nbElements);
  console.log('comments stripped:', r.nbElements, 'saved:', baseline.nbElements - r.nbElements);
  console.log('warnings:', r.encounteredWarnings.length);
  const before = rules(baseline.result), after = rules(r.result);
  const changed = Object.keys(before).filter(n => before[n] !== after[n]);
  console.log('changed rules after stripping string actions from comparison:', changed.length);
  // compare with string/comment actions removed from both sides
  const stripStrings = s => s.replace(/^\s*"[^"]*"\s*;?\s*$/gm, '').replace(/\s+/g, ' ').trim();
  const b2 = {}, a2 = {};
  let diff2 = 0;
  for (const k of Object.keys(before)) { b2[k] = stripStrings(before[k]); a2[k] = stripStrings(after[k]); if (b2[k] !== a2[k]) diff2++; }
  console.log('rules differing after removing comment actions from both:', diff2);
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-sixth-comments-probe.json'), JSON.stringify({ baseline: baseline.nbElements, stripped: r.nbElements, saved: baseline.nbElements - r.nbElements }, null, 2) + '\n');
}
main().catch(e => { console.error(e); process.exitCode = 1; });
