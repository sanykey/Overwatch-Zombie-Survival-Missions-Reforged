// Rule-level element budget from the compiled baseline comments.
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));
const rows = [];
for (const p of parts) {
  const name = p.match(/^rule \("(.*)"\)/)[1];
  const actions = p.match(/actions \{([\s\S]*?)\n    \}/);
  let total = 0, statements = {};
  if (actions) {
    for (const line of actions[1].split('\n')) {
      const m = /\/\/\s*(\d+) elements/.exec(line);
      if (m) total += Number(m[1]);
      const sm = /^\s{8}([A-Z][A-Za-z ]+?)\(/.exec(line);
      if (sm) statements[sm[1]] = (statements[sm[1]] || 0) + 1;
    }
  }
  const head = /conditions \{([\s\S]*?)\n    \}/;
  let condEls = 0;
  const cm = p.match(/conditions \{([\s\S]*?)\n    \}/);
  if (cm) for (const line of cm[1].split('\n')) { const m = /\/\/\s*(\d+) elements/.exec(line); if (m) condEls += Number(m[1]); }
  rows.push({ name, total, condEls, statements });
}
rows.sort((a, b) => b.total - a.total);
let sum = 0;
for (const r of rows) sum += r.total + r.condEls;
console.log('actions+conditions elements across rules:', sum);
for (const r of rows.slice(0, 30)) {
  const top = Object.entries(r.statements).sort((a, b) => b[1] - a[1]).slice(0, 6).map(([k, v]) => k + 'x' + v).join(' ');
  console.log(String(r.total + r.condEls).padStart(6) + '  ' + r.name.slice(0, 55).padEnd(55) + ' ' + top);
}
