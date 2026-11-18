// Cross-rule duplicate long expressions (subroutine-sharing candidates).
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));

// Split each rule into conditions vs actions; collect per-line call args (top-level commas) as candidates.
function splitTop(s) {
  const out = []; let depth = 0, quote = null, esc = false, start = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (quote) { if (esc) esc = false; else if (c === '\\') esc = true; else if (c === quote) quote = null; continue; }
    if (c === '"' || c === "'") { quote = c; continue; }
    if ('([{'.includes(c)) depth++;
    else if (')]}'.includes(c)) depth--;
    else if (c === ',' && !depth) { out.push(s.slice(start, i)); start = i + 1; }
  }
  out.push(s.slice(start));
  return out;
}

const counts = new Map();
for (const part of parts) {
  const name = part.match(/^rule \("(.*)"\)/)[1];
  const cm = part.match(/conditions \{([\s\S]*?)\n    \}/);
  const am = part.match(/actions \{([\s\S]*?)\n    \}/);
  const seen = new Set();
  for (const [section, body] of [['cond', cm && cm[1]], ['act', am && am[1]]]) {
    if (!body) continue;
    for (const line of body.split('\n')) {
      if (/^\s*(rule |#|\/\/)/.test(line) || !line.includes('(')) continue;
      for (const raw of splitTop(line.replace(/\/\/.*$/, '').replace(/;$/, ''))) {
        const e = raw.trim();
        if (e.length < 45) continue;
        if (/Current Array Element|Local Player|Current Array Index/.test(e)) continue;
        const key = section + '|' + e;
        if (seen.has(key)) continue;
        seen.add(key);
        const rec = counts.get(e) || { cond: 0, act: 0, rules: new Set() };
        rec[section]++; rec.rules.add(name);
        counts.set(e, rec);
      }
    }
  }
}
const rows = [...counts.entries()]
  .filter(([e, r]) => r.act >= 2 || (r.cond >= 1 && r.act >= 1))
  .map(([e, r]) => ({ e, ...r, rules: [...r.rules] }))
  .sort((a, b) => (b.act + b.cond) - (a.act + a.cond) || b.e.length - a.e.length);
console.log('cross-rule shared long exprs:', rows.length);
for (const r of rows.slice(0, 40)) {
  console.log('=== cond' + r.cond + ' act' + r.act + '  rules: ' + r.rules.slice(0, 5).join(' ; '));
  console.log('    ' + r.e.slice(0, 280));
}
