// Fresh baseline compile of the working tree (d9a07b0 expected at 29748).
// Run: node analysis/2026-11-18-thirty-seventh-baseline.cjs
const fs = require('node:fs'), path = require('node:path');
const { compile, rules } = require('./2026-11-18-thirty-fifth-element-candidates.cjs');
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

async function main() {
  const r = await compile(readTree());
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-baseline.ws.txt'), r.result);
  console.log('elements:', r.nbElements, 'warnings:', JSON.stringify(r.encounteredWarnings));
  console.log('rules:', Object.keys(rules(r.result)).length, 'nestedPredicates:', nestedPredicates(r.result).length);
}
module.exports = { readTree, compile, rules, nestedPredicates };
if (require.main === module) main().catch(e => { console.error(e); process.exitCode = 1; });
