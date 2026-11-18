// Probe: hoist the thrice-computed "Scavenger + Crouch held" pair in
// PLAYER INTERACT into one synchronous tmp3 flag.
// Run: node analysis/2026-11-18-thirty-seventh-scav-crouch-flag.cjs
const fs = require('node:fs'), path = require('node:path'), assert = require('node:assert/strict');
const { readTree, compile, rules, nestedPredicates } = require('./2026-11-18-thirty-seventh-baseline.cjs');
const root = path.resolve(__dirname, '..'); process.chdir(root);

const FILE = 'items/supply_drops.opy';
const PAIR = 'eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH)';

async function main() {
  const files = readTree();
  const before = await compile(files);
  assert.equal(before.nbElements, 29748, 'baseline');
  const src = files[FILE];
  assert.equal(src.split(PAIR).length - 1, 3, 'expected exactly 3 pair occurrences');

  const f = { ...files };
  let s = f[FILE];
  // 1. replace the three pair occurrences FIRST (the inserted assignment below
  //    keeps the full expression; replacing it too would create a self-assignment)
  s = s.split(PAIR).join('isScavengerCrouchHeld');
  // 2. insert flag assignment after the aimed-items scratch assignment
  const anchor = 'aimedPowerUpPositions = supplyPowerUpPositionList.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer, x) <= 6)\n';
  assert(s.includes(anchor));
  s = s.replace(anchor, anchor +
    '    # Synchronous scratch: written before the interaction chain and read at the\n' +
    '    # three Scavenger branches below; no waits or subroutine calls in between.\n' +
    '    #!define isScavengerCrouchHeld tmp3\n' +
    '    isScavengerCrouchHeld = ' + PAIR + '\n');
  f[FILE] = s;

  const after = await compile(f);
  const beforeRules = rules(before.result), afterRules = rules(after.result);
  assert.deepEqual(Object.keys(beforeRules), Object.keys(afterRules));
  const changed = Object.keys(beforeRules).filter(n => beforeRules[n] !== afterRules[n]);
  const report = {
    baseline: before.nbElements, probe: after.nbElements,
    saved: before.nbElements - after.nbElements,
    warnings: after.encounteredWarnings,
    nestedPredicates: nestedPredicates(after.result),
    changedRules: changed,
  };
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-scav-crouch-flag.ws.txt'), after.result);
  fs.writeFileSync(path.join(__dirname, '2026-11-18-thirty-seventh-scav-crouch-flag.json'), JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify(report, null, 2));
}
main().catch(e => { console.error(e); process.exitCode = 1; });
