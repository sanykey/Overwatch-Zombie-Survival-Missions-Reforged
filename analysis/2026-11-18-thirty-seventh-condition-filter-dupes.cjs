// Find rules where the actions contain First Of(Filtered Array(<list>, ...)) and the
// conditions contain Is True For Any/All over the SAME list (predicate duplication
// candidates). Run: node analysis/2026-11-18-thirty-seventh-condition-filter-dupes.cjs
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));

for (const p of parts) {
  const name = p.match(/^rule \("(.*)"\)/)[1];
  const actionsIdx = p.indexOf('actions {');
  const head = p.slice(0, actionsIdx);
  const body = p.slice(actionsIdx);
  const seen = new Set();
  for (const m of body.matchAll(/First Of\(Filtered Array\(([^,()]+(?:\([^()]*\))?)[,)]/g)) {
    const list = m[1].trim();
    if (seen.has(list)) continue;
    seen.add(list);
    for (const kind of ['Is True For Any', 'Is True For All']) {
      if (head.includes(kind + '(' + list + ',')) {
        console.log('DUPE  [' + name + ']  list=' + list + '  cond=' + kind);
      }
    }
  }
  // also: sorted-array selection duplicated in conditions is harder; skip.
}
