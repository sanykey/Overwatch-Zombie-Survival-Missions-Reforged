// Costliest element-commented lines of a rule (by rule-name prefix).
const fs = require('node:fs'), path = require('node:path');
const prefix = process.argv[2], n = Number(process.argv[3] || 12);
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));
const part = parts.find(p => p.startsWith('rule ("' + prefix));
if (!part) { console.log('rule not found'); process.exit(1); }
const rows = [];
for (const l of part.split('\n')) {
  const m = /\/\/\s*(\d+) elements/.exec(l);
  const t = l.trim();
  if (m && !t.startsWith('//')) rows.push({ n: Number(m[1]), t });
}
rows.sort((a, b) => b.n - a.n);
for (const r of rows.slice(0, n)) console.log(String(r.n).padStart(4) + '  ' + r.t.slice(0, 240));
