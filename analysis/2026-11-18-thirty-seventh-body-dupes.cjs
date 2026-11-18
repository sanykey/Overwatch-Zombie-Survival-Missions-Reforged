// Find repeated 4-line source windows (>=2 occurrences) ignoring rule headers
// (@Event/@Team/@Hero/@Condition/wait-loop idioms).
// Run: node analysis/2026-11-18-thirty-seventh-body-dupes.cjs
const fs = require('node:fs'), path = require('node:path');
const root = path.resolve(__dirname, '..');
const files = {};
const walk = dir => {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p);
    else if (e.name.endsWith('.opy')) files[path.relative(path.join(root, 'src'), p).replace(/\\/g, '/')] = fs.readFileSync(p, 'utf8').replace(/\r\n/g, '\n');
  }
};
walk(path.join(root, 'src'));
const lines = [];
for (const [name, text] of Object.entries(files)) {
  text.split('\n').forEach((l, i) => {
    const t = l.replace(/#(?!!define).*$/, '').trim();
    if (t) lines.push({ f: name, n: i + 1, t });
  });
}
const skip = l => /^(@|wait\(|if ruleCondition:|loop\(\)|else|elif|\)|\]|#|")/.test(l.t) || /^playEffect|waitUntil/.test(l.t);
const K = 4;
const windows = {};
for (let i = 0; i + K <= lines.length; i++) {
  const w = lines.slice(i, i + K);
  if (w.some((l, j) => j > 0 && (l.f !== w[j - 1].f || l.n !== w[j - 1].n + 1))) continue;
  if (w.some(skip)) continue;
  const key = w.map(l => l.t).join('\n');
  (windows[key] = windows[key] || []).push({ f: w[0].f, n: w[0].n });
}
const groups = Object.entries(windows).filter(([, v]) => v.length >= 2).sort((a, b) => b[1].length - a[1].length);
console.log('repeated 4-line body windows (>=2):', groups.length);
for (const [key, locs] of groups.slice(0, 18)) {
  console.log('\n=== x' + locs.length + '  ' + locs.map(l => l.f + ':' + l.n).join('  '));
  console.log(key.split('\n').map(l => '   ' + l).join('\n').slice(0, 500));
}
