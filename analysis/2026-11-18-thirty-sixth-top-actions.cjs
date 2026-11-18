// Top costliest individual compiled actions across all rules.
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));
const rows = [];
for (const part of parts) {
  const name = part.match(/^rule \("(.*)"\)/)[1];
  for (const l of part.split('\n')) {
    const m = /\/\/\s*(\d+) elements/.exec(l);
    if (!m) continue;
    const t = l.trim();
    if (t.startsWith('//')) continue; // rule total comments
    rows.push({ n: Number(m[1]), name, l: t });
  }
}
rows.sort((a, b) => b.n - a.n);
console.log('actions with element comments:', rows.length);
for (const r of rows.slice(0, 40)) {
  console.log(String(r.n).padStart(4) + '  [' + r.name.slice(0, 40) + ']');
  console.log('     ' + r.l.slice(0, 340));
}
