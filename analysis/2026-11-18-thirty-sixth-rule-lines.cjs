// Print exact compiled action lines of a rule matching a substring, with element counts.
const fs = require('node:fs'), path = require('node:path');
const ruleName = process.argv[2], needle = process.argv[3], ctx = Number(process.argv[4] || 0);
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));
let seen = -1;
const part = parts.find(p => { if (p.startsWith('rule ("' + ruleName + '")')) { seen++; return seen === Number(process.argv[5] || 0); } return false; });
if (!part) { console.log('rule not found'); process.exit(1); }
const lines = part.split('\n');
lines.forEach((l, i) => {
  if (needle && !l.includes(needle)) return;
  for (let j = Math.max(0, i - ctx); j <= Math.min(lines.length - 1, i + ctx); j++) {
    const t = lines[j].trim();
    console.log((j === i ? '> ' : '  ') + (t.length > 360 ? t.slice(0, 360) + ' …' : t));
  }
  console.log('  ---');
});
