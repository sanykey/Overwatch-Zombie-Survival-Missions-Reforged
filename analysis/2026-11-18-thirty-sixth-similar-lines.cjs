// Find adjacent similar action lines in compiled rules (loop-merge candidates).
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));

// Normalize a line: strip comments, numbers→#, whitespace.
function norm(l) {
  return l.replace(/\/\/.*$/, '').replace(/-?\d+\.?\d*/g, '#').replace(/\s+/g, '');
}
function similarity(a, b) { // Jaccard over 8-char shingles
  const set = s => { const out = new Set(); for (let i = 0; i <= s.length - 8; i++) out.add(s.slice(i, i + 8)); return out; };
  const sa = set(a), sb = set(b);
  let inter = 0;
  for (const x of sa) if (sb.has(x)) inter++;
  return inter / Math.max(1, sa.size + sb.size - inter);
}

const groups = [];
for (const part of parts) {
  const name = part.match(/^rule \("(.*)"\)/)[1];
  const lines = part.split('\n').filter(l => /\/\/\s*\d+ elements/.test(l));
  let i = 0;
  while (i < lines.length) {
    let j = i + 1;
    while (j < lines.length && similarity(norm(lines[i]), norm(lines[j])) >= 0.75) j++;
    if (j - i >= 2) {
      const els = lines.slice(i, j).map(l => Number(/\/\/\s*(\d+) elements/.exec(l)[1]));
      groups.push({ name, count: j - i, els, first: lines[i].trim().slice(0, 150) });
    }
    i = Math.max(i + 1, j === i + 1 ? i + 1 : j - 1);
  }
}
groups.sort((a, b) => (b.count - 1) * (b.els[0] || 0) - (a.count - 1) * (a.els[0] || 0));
for (const g of groups.slice(0, 40)) {
  console.log('=== ' + g.count + 'x  [' + g.name + ']  els: ' + g.els.join(','));
  console.log('    ' + g.first);
}
