const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const artifact = suffix => path.join(__dirname, `2026-11-14-enhancement-role-${suffix}.json`);
const read = file => fs.readFileSync(require('./source-layout.cjs').sourcePath(file), 'utf8');
// Split table entries without splitting nested calls, arrays, or string literals.
function table(source, start) {
  const begin = source.indexOf('[', start);
  let depth = 0, quote = '', entry = begin + 1;
  const entries = [];
  for (let i = begin; i < source.length; i++) {
    const c = source[i];
    if (quote) {
      if (c === '\\') i++;
      else if (c === quote) quote = '';
      continue;
    }
    if (c === '"' || c === "'") { quote = c; continue; }
    if ('[({'.includes(c)) depth++;
    else if ('])}'.includes(c)) {
      if (--depth === 0) {
        entries.push(source.slice(entry, i).trim());
        return {begin, end: i + 1, entries};
      }
    } else if (c === ',' && depth === 1) {
      entries.push(source.slice(entry, i).trim());
      entry = i + 1;
    }
  }
  throw new Error('Unclosed table');
}
function tables() {
  const hud = read('player_initialization.opy');
  const menu = read('global_start_menu.opy');
  const vars = read('variables.opy');
  const subtitle = table(hud, hud.indexOf('ENHANCEMENT_ICONS[localPlayer.enhancementId]') + 'ENHANCEMENT_ICONS[localPlayer.enhancementId]'.length);
  const name = table(hud, subtitle.end + '[localPlayer.enhancementId]'.length);
  const color = table(hud, hud.indexOf('HudPosition.ACTUALLY_LEFT, 97'));
  const menuColor = table(menu, menu.indexOf('startMenuEnhancementColorList ='));
  const menuName = table(menu, menuColor.end);
  const description = table(menu, menu.indexOf('else ""', menuName.end));
  const icons = table(vars, vars.indexOf('globalvar enhancementIconListConst ='));
  return {subtitle, name, color, menuColor, menuName, description, icons};
}
async function compile() {
  const result = await compiler.compile(read('includes.opy').replace(/^#!writeToOutputFile.*$/gm, ''),
    'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
  assert.deepEqual(result.encounteredWarnings, []);
  return result;
}
async function main() {
  await compiler.readyPromise;
  if (process.argv.includes('--baseline')) {
    const source = read('player_initialization.opy');
    const original = await compile();
    const savedTables = tables();
    const assignment = 'random.randint(Enhancement.BRAIN_KILLER, Enhancement.ENGINEER)';
    assert(source.includes(assignment));
    let filtered;
    try {
      fs.writeFileSync(path.join(root, 'src/abilities/player_initialization.opy'), source.replace(assignment,
        'random.choice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].filter(lambda enhancement: (enhancement not in [Enhancement.ZOMBIE_HYBRID, Enhancement.BULKING_SEASON] or eventPlayer.getHero() in getTankHeroes()) and (enhancement not in [Enhancement.PLAGUE_DOCTOR, Enhancement.OVERCHARGE] or eventPlayer.getHero() in getSupportHeroes())))'));
      filtered = await compile();
    } finally {
      fs.writeFileSync(path.join(root, 'src/abilities/player_initialization.opy'), source);
    }
    const baseline = {elements: original.nbElements, filteredElements: filtered.nbElements, tables: savedTables};
    fs.writeFileSync(artifact('before'), JSON.stringify(baseline, null, 2) + '\n');
    console.log(JSON.stringify({elements: baseline.elements, filteredElements: baseline.filteredElements}));
    return;
  }
  const before = JSON.parse(fs.readFileSync(artifact('before'), 'utf8'));
  const order = [0, 2, 10, 1, 3, 5, 6, 7, 8, 11, 12, 13, 4, 9];
  const afterTables = tables();
  for (const key of Object.keys(afterTables))
    assert.deepEqual(afterTables[key].entries, order.map(i => before.tables[key].entries[i]), key);
  const enumBlock = read('variables.opy').match(/enum Enhancement:\n([\s\S]*?)\n\n/)[1];
  const ids = Object.fromEntries([...enumBlock.matchAll(/(\w+) = (\d+)/g)].map(([, key, id]) => [key, Number(id)]));
  assert.deepEqual(Object.values(ids), Array.from({length: 14}, (_, i) => i));
  assert.equal(ids.NO_PREFERENCE, 0);
  assert.equal(ids.ZOMBIE_HYBRID, 1);
  assert.equal(ids.BULKING_SEASON, 2);
  assert.equal(ids.BRAIN_KILLER, 3);
  assert.equal(ids.PLAGUE_DOCTOR, 12);
  assert.equal(ids.OVERCHARGE, 13);
  let roleCases = 0;
  for (const role of ['tank', 'damage', 'support']) {
    const low = role === 'tank' ? ids.ZOMBIE_HYBRID : ids.BRAIN_KILLER;
    const high = role === 'support' ? ids.OVERCHARGE : ids.ENGINEER;
    const pool = Array.from({length: high - low + 1}, (_, i) => i + low);
    const expected = Object.values(ids).filter(id => id !== 0 &&
      (![ids.ZOMBIE_HYBRID, ids.BULKING_SEASON].includes(id) || role === 'tank') &&
      (![ids.PLAGUE_DOCTOR, ids.OVERCHARGE].includes(id) || role === 'support'));
    assert.deepEqual(pool, expected, role);
    roleCases += pool.length;
  }
  const compiled = await compile();
  const initialization = compiled.result.match(/rule \("PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION"\) \{[\s\S]*?^\}/m)[0];
  assert(initialization.includes('All Tank Heroes'));
  assert(initialization.includes('All Support Heroes'));
  const roll = initialization.split('\n').find(line => line.includes('Random Integer'));
  assert(roll.includes('All Tank Heroes') && roll.includes('All Support Heroes'));
  assert(!roll.includes('Filtered Array'));
  assert(roll.includes('Array Contains(All Tank Heroes, Hero Of(Event Player)), 1, 3)'));
  assert(initialization.includes('Skip If(Compare((Event Player).enhancementId, !=, Null), True);'));
  const report = {compiler: 'OverPy 9.7.21', beforeElements: before.elements,
    afterElements: compiled.nbElements,
    addedElements: compiled.nbElements - before.elements,
    reorderedTables: Object.keys(afterTables), rolePoolChoicesChecked: roleCases,
    warnings: compiled.encounteredWarnings,
    limitations: 'Compiled output and exhaustive role pool checks; no in-game validation.'};
  fs.writeFileSync(path.join(root, 'main.ws.txt'), compiled.result);
  fs.writeFileSync(artifact('after'), JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify(report, null, 2));
}
module.exports = {table, tables};
if (require.main === module) main().catch(error => { console.error(error); process.exitCode = 1; });
