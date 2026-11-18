// Find Wait Until(P, timeout) actions followed within a few lines by While(¬P).
// Run: node analysis/2026-11-18-thirty-seventh-wait-while-pairs.cjs
const fs = require('node:fs'), path = require('node:path');
const text = fs.readFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-baseline.ws.txt'), 'utf8');
const parts = text.split(/(?=^rule \()/m).filter(p => p.startsWith('rule ('));

for (const p of parts) {
  const name = p.match(/^rule \("(.*)"\)/)[1];
  const lines = p.split('\n');
  for (let i = 0; i < lines.length; i++) {
    if (!/Wait Until\(/.test(lines[i])) continue;
    for (let j = i + 1; j <= Math.min(i + 4, lines.length - 1); j++) {
      if (!/While\(/.test(lines[j])) continue;
      // only if no other Wait/If between
      const between = lines.slice(i + 1, j).filter(l => /\b(Wait Until|Wait\(|If|Else)/.test(l));
      if (between.length) break;
      console.log('[' + name + ']  els:', (/\/\/ *(\d+) elements/.exec(lines[i]) || [])[1], '+', (/\/\/ *(\d+) elements/.exec(lines[j]) || [])[1]);
      console.log('   WU: ' + lines[i].trim().slice(0, 230));
      console.log('   WL: ' + lines[j].trim().slice(0, 230));
      console.log();
      break;
    }
  }
}
