// Find synchronous (non-live-reevaluating) actions whose own text repeats a
// non-trivial sub-expression 3+ times — CSE candidates extractable to tmp.
// Run: node analysis/2026-11-18-thirty-seventh-sync-cse.cjs
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));

for (const p of parts) {
  const name = p.match(/^rule \("(.*)"\)/)[1];
  const lines = p.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const l = lines[i];
    const em = /\/\/ *(\d+) elements/.exec(l);
    if (!em || Number(em[1]) < 12) continue;
    // live-reevaluating creations keep per-frame semantics; skip them
    if (/Create (HUD|In-World|Icon|Effect|Beam|Progress Bar)/.test(l)) continue;
    // collect candidate sub-expressions: function calls with args, >= 14 chars
    const subs = {};
    for (const m of l.matchAll(/([A-Z][A-Za-z ]{2,})\(([^()]*(?:\([^()]*\)[^()]*)*)\)/g)) {
      const e = m[0];
      if (e.length >= 14 && !/^(Compare|And|Or|Not|If-Then-Else|Add|Subtract|Multiply|Divide|Min|Max|True|False|Null|Empty Array|Round|Append|Remove|Value In Array|Custom String|Global|Event Player|Local Player|Current Array Element|First Of|Count Of)$/.test(m[1])) {
        (subs[e] = subs[e] || 0) + 1 ? subs[e]++ : 0;
      }
    }
    const hits = Object.entries(subs).filter(([, n]) => n >= 3);
    if (hits.length) {
      console.log('[' + name + '] line ' + (i + 1) + '  ' + em[1] + ' els');
      for (const [e, n] of hits) console.log('   x' + n + '  ' + e.slice(0, 160));
    }
  }
}
