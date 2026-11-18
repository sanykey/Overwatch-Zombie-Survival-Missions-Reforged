// Top costliest annotated actions per named rule (or across all rules when no args).
// Run: node analysis/2026-11-18-thirty-seventh-top-actions.cjs ["rule substring" [count]]
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));
const want = process.argv[2] || null;
const count = Number(process.argv[3] || 12);
for (const p of parts) {
  const name = p.match(/^rule \("(.*)"\)/)[1];
  if (want && !name.includes(want)) continue;
  const rows = [];
  for (const l of p.split('\n')) {
    const m = /\/\/ *(\d+) elements/.exec(l);
    if (m && !l.trim().startsWith('//')) rows.push({ n: +m[1], l: l.trim() });
  }
  rows.sort((a, b) => b.n - a.n);
  console.log('=== ' + name + ' === (' + rows.length + ' annotated actions)');
  for (const r of rows.slice(0, count)) console.log(String(r.n).padStart(4), ' ', r.l.slice(0, 220));
  console.log();
}
