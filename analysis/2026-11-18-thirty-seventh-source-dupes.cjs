// Find repeated multi-line source patterns (windows of 3+ lines) across src/*.opy.
// Run: node analysis/2026-11-18-thirty-seventh-source-dupes.cjs
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

// normalize: strip comments, trim, keep content
const lines = [];
for (const [name, text] of Object.entries(files)) {
  text.split('\n').forEach((l, i) => {
    const t = l.replace(/#(?!!define).*$/, '').trim();
    if (t) lines.push({ f: name, n: i + 1, t });
  });
}

const K = 3; // window size
const windows = {};
for (let i = 0; i + K <= lines.length; i++) {
  // skip windows crossing file boundaries
  if (lines.slice(i, i + K).some((l, j) => j > 0 && (l.f !== lines[i + j - 1].f || l.n !== lines[i + j - 1].n + 1))) continue;
  const key = lines.slice(i, i + K).map(l => l.t).join('\n');
  if (/^(elif|else|\)|\]|,)/.test(lines[i].t)) continue;
  (windows[key] = windows[key] || []).push({ f: lines[i].f, n: lines[i].n });
}

const groups = Object.entries(windows).filter(([, v]) => v.length >= 3).sort((a, b) => b[1].length - a[1].length);
console.log('repeated 3-line windows (>=3 occurrences):', groups.length);
for (const [key, locs] of groups.slice(0, 25)) {
  console.log('\n=== x' + locs.length + '  ' + locs.slice(0, 4).map(l => l.f + ':' + l.n).join('  '));
  console.log(key.split('\n').map(l => '   ' + l).join('\n').slice(0, 400));
}
