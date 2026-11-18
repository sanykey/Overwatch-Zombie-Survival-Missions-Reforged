// Scan compiled baseline for duplicated call expressions per rule (tmp-sharing candidates).
// Single-pass: each call occurrence counted exactly once; recurses into arguments.
// Usage: node analysis/2026-11-18-thirty-sixth-duplicate-scan.cjs [baseline.ws.txt] [minWeight]
const fs = require('node:fs'), path = require('node:path');
const file = process.argv[2] || path.join(__dirname, '2026-11-18-thirty-fifth-baseline.ws.txt');
const minWeight = Number(process.argv[3] || 4);
const text = fs.readFileSync(file, 'utf8');

const rules = [];
for (const part of text.split(/(?=^rule \()/m)) {
  if (!part.startsWith('rule (')) continue;
  rules.push({ name: part.match(/^rule \("(.*)"\)/)[1], part });
}

// Statement lead-ins whose own node is control flow; record their arguments instead of the statement.
const statements = new Set(['If', 'Else If', 'While', 'For Global Variable', 'For Player Variable',
  'Wait', 'Wait Until', 'Loop If', 'Loop If Condition Is True', 'Press Button', 'Set Player Variable',
  'Set Global Variable', 'Modify Player Variable', 'Modify Global Variable', 'Skip', 'Start Rule',
  'Small Message', 'Big Message', 'Create HUD Text', 'Create In-World Text', 'Create Effect',
  'Create Beam Effect', 'Create Icon', 'Create Progress Bar HUD Text', 'Create Progress Bar In-World Text',
  'Start Camera', 'Start Damage Over Time', 'Start Heal Over Time', 'Start Throttle In Direction',
  'Start Facing', 'Start Accelerating In Direction', 'Start Forcing Modifier', 'Start Modifying Hero Voice Lines',
  'Apply Impulse', 'Damage', 'Heal', 'Teleport', 'Set Facing', 'Play Effect', 'Emit Sound', 'Preload Hero',
  'Abort', 'Return', 'Break', 'Terminate Match', 'Load Hero', 'Respawn', 'Set Ultimate Charge', 'Chase',
  'Stop Chasing', 'Stop Facing', 'Stop Throttle', 'Stop Accelerating', 'Stop Forcing Modifier', 'Stop Status Effect',
  'Set Player Allowed Hero', 'Add Hero Property', 'Remove Hero Property', 'Override Hero Settings']);

function elementWeight(e) {
  const calls = (e.match(/[A-Za-z][A-Za-z0-9 ]*\(/g) || []).length;
  const lits = (e.match(/(^|[^A-Za-z0-9_.])(-?\d+\.?\d*|Null|True|False|Empty Array)/g) || []).length;
  return calls + lits;
}

function scan(source, addExpr) {
  let i = 0, guard = 0;
  const n = source.length;
  function skipString(j) { // j at quote
    const q = source[j]; j++;
    while (j < n) { if (source[j] === '\\') { j += 2; continue; } if (source[j] === q) return j + 1; j++; }
    return j;
  }
  function callAt(j) { // j at '(' after ident; returns index after matching ')'
    let depth = 0;
    while (j < n) {
      const c = source[j];
      if (c === '"' || c === "'") { j = skipString(j); continue; }
      if (c === '(') depth++;
      else if (c === ')') { depth--; if (!depth) return j + 1; }
      j++;
    }
    return -1;
  }
  function identAt(j) { // returns [ident, nextIndex] or null; must start at a name boundary
    if (j > 0 && /[A-Za-z0-9_]/.test(source[j - 1])) return null;
    if (j > 1 && source[j - 1] === ' ' && /[A-Za-z0-9_]/.test(source[j - 2])) return null; // mid multi-word name
    const m = /^([A-Za-z][A-Za-z0-9 ]*)\(/.exec(source.slice(j, j + 80));
    if (!m) return null;
    return [m[1].trim(), j + m[0].length];
  }
  function walk(from, to) {
    let j = from;
    while (j < to && guard++ < 200000) {
      const c = source[j];
      if (c === '"' || c === "'") { j = skipString(j); continue; }
      const id = identAt(j);
      if (!id) { j++; continue; }
      const [name, openParen] = id;
      const end = callAt(openParen);
      if (end < 0) { j = openParen; continue; }
      const full = source.slice(j, end);
      const isStatement = statements.has(name) && j === from;
      if (!isStatement) {
        if (full.length >= 12) addExpr(full);
      }
      walk(openParen + 1, end - 1); // recurse into arguments
      j = end;
    }
  }
  walk(0, n);
}

const results = [];
for (const { name, part } of rules) {
  // Only actions, not conditions block? Conditions matter too but shareability differs; tag context.
  const condEnd = part.search(/^\s{4}(?!@)/m); // first non-@ indented line = actions start (approx)
  const perRule = new Map();
  const add = ctx => e => {
    const rec = perRule.get(e) || { n: 0, ctx: new Set() };
    rec.n++; rec.ctx.add(ctx); perRule.set(e, rec);
  };
  const lines = part.split('\n');
  let inActions = false;
  for (const line of lines) {
    if (/^rule /.test(line) || /^"/.test(line.trim()) && /^\s*"/.test(line) === false) continue;
    if (/^\s*@/.test(line)) { continue; }
    if (!/^\s{4,}/.test(line)) continue;
    scan(line.replace(/\/\/.*$/, '').replace(/;$/, ''), add('act'));
  }
  const uncachable = process.argv[4] !== 'all';
  for (const [e, rec] of perRule) {
    if (rec.n >= 2) {
      if (uncachable && /Current Array Element|Local Player|Current Array Index/.test(e)) continue;
      const w = (rec.n - 1) * elementWeight(e);
      if (w >= minWeight) results.push({ name, e, n: rec.n, w });
    }
  }
}
results.sort((a, b) => b.w - a.w);
console.log('candidate duplicated expressions:', results.length);
for (const r of results.slice(0, 120)) {
  console.log('--- w' + r.w + ' x' + r.n + '  [' + r.name + ']');
  console.log('    ' + r.e.slice(0, 300));
}
