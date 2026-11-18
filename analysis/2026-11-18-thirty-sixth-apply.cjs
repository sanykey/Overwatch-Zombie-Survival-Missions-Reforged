// Apply the two verified candidates to the working tree and compile the real build.
// Run: node analysis/2026-11-18-thirty-sixth-apply.cjs
const fs = require('node:fs'), path = require('node:path'), assert = require('node:assert/strict');
const { compile } = require('./2026-11-18-thirty-fifth-element-candidates.cjs');
const { nestedPredicates } = require('./2026-11-18-workshop-predicate-nesting.cjs');
const root = path.resolve(__dirname, '..'); process.chdir(root);

function readTree() {
  const files = {};
  const walk = dir => {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith('.opy')) files[path.relative('src', p).replace(/\\/g, '/')] = fs.readFileSync(p, 'utf8').replace(/\r\n/g, '\n');
    }
  };
  walk('src');
  files.__numbersGenerator = fs.readFileSync('tools/create numbers.js', 'utf8').replace(/\r\n/g, '\n');
  return files;
}
function writeTree(f) {
  for (const [name, text] of Object.entries(f)) {
    if (name === '__numbersGenerator') continue;
    fs.writeFileSync(path.join('src', name), text);
  }
}

const lineStart = (t, i) => t.lastIndexOf('\n', i) + 1;
function switchToIfChain(text, key) {
  const lines = text.split('\n');
  const out = [];
  let first = true;
  let caseIndent = null, bodyIndent = null, baseIndent = null;
  for (const line of lines) {
    if (baseIndent === null && line.trim()) baseIndent = line.length - line.trimStart().length;
    if (new RegExp('^\\s*switch ' + key + ':\\s*$').test(line)) { continue; }
    if (caseIndent === null) {
      const m = /^(\s+)case /.exec(line);
      if (m) { caseIndent = m[1].length; bodyIndent = caseIndent + 4; }
      else { out.push(line); continue; }
    }
    const caseMatch = new RegExp('^(\\s{' + caseIndent + '})case ([^:]+):\\s*$').exec(line);
    if (caseMatch) {
      out.push(' '.repeat(caseIndent - 4) + (first ? 'if ' : 'elif ') + key + ' == ' + caseMatch[2] + ':');
      first = false;
      continue;
    }
    if (new RegExp('^\\s{' + bodyIndent + '}break\\s*$').test(line)) continue;
    const indent = line.length - line.trimStart().length;
    if (indent > baseIndent && line.startsWith('    ')) out.push(line.slice(4));
    else out.push(line);
  }
  return out.join('\n');
}

async function main() {
  const f = readTree();
  const before = await compile({ ...f });
  assert.equal(before.nbElements, 29766, 'working tree must match the pinned baseline');
  assert(before.encounteredWarnings.length === 0);

  // 1. spawn metadata direct index (game/global_start_menu.opy, setZombieMode)
  for (const kind of ['OFFSETS', 'LENGTHS']) {
    const old = `numbersList.slice(NL_SPAWN_MODE_${kind}_OFFSET, NL_SPAWN_MODE_${kind}_LEN)[zombieSetting - 1]`;
    assert(f['game/global_start_menu.opy'].includes(old), old);
    f['game/global_start_menu.opy'] = f['game/global_start_menu.opy'].replace(old, `numbersList[(NL_SPAWN_MODE_${kind}_OFFSET - 1) + zombieSetting]`);
  }

  // 2. objectivesManagement switches -> if/elif chains (core/subroutines.opy)
  const sub = f['core/subroutines.opy'];
  const raw2 = sub.indexOf('switch currentObjectiveType:', sub.indexOf('#Checks if current objective is showdown') + 400);
  assert(raw2 > 0);
  const a2 = lineStart(sub, raw2);
  const end2 = sub.indexOf('\n    #Updates global objective entities', a2) + 1;
  f['core/subroutines.opy'] = sub.slice(0, a2) + switchToIfChain(sub.slice(a2, end2), 'currentObjectiveType') + sub.slice(end2);
  const a1 = lineStart(f['core/subroutines.opy'], f['core/subroutines.opy'].indexOf('switch currentObjectiveType:'));
  const end1 = f['core/subroutines.opy'].indexOf('\n        # Objective IDs 1..7 are contiguous', a1) + 1;
  f['core/subroutines.opy'] = f['core/subroutines.opy'].slice(0, a1) + switchToIfChain(f['core/subroutines.opy'].slice(a1, end1), 'currentObjectiveType') + f['core/subroutines.opy'].slice(end1);
  assert(!f['core/subroutines.opy'].includes('switch currentObjectiveType:'));

  const after = await compile({ ...f });
  assert.equal(after.nbElements, 29748);
  assert.deepEqual(after.encounteredWarnings, []);
  assert.deepEqual(nestedPredicates(after.result), []);
  writeTree(f);
  fs.writeFileSync('main.ws.txt', after.result);
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-sixth-element-implementation.json'),
    JSON.stringify({ baseline: before.nbElements, implemented: after.nbElements, saved: before.nbElements - after.nbElements, warnings: after.encounteredWarnings, changedSources: ['src/game/global_start_menu.opy', 'src/core/subroutines.opy'] }, null, 2) + '\n');
  console.log('implemented:', after.nbElements, 'saved:', before.nbElements - after.nbElements, 'warnings:', after.encounteredWarnings.length);
}
main().catch(e => { console.error(e); process.exitCode = 1; });
