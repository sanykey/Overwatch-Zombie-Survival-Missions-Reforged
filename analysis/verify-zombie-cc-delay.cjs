// Verify the zombie crowd-control delay selection: zombie behavior rules sample
// the delayed botIsCrowdControlled flag (refreshed by BOT STUN MANAGEMENT with a
// 0.125s polling window), so a recent interruption still counts after CC exits.
// The live isCrowdControlled flag stays on the tracker condition and Team 1
// consumers. Run with --write to regenerate main.ws.txt after src/ changes.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const read = name => fs.readFileSync(path.join(src, name), 'utf8');
const liveReads = text => (text.match(/(?<!bot)isCrowdControlled/g) || []).length;
const delayedReads = text => (text.match(/botIsCrowdControlled/g) || []).length;
const lines = (text, needle) => text.split(/\r?\n/).filter(line => line.includes(needle));

// Delayed flag on zombie reads.
const zombieTypes = read('zombie_types.opy');
assert.equal(liveReads(zombieTypes), 0, 'zombie_types.opy must not read the live flag');
assert.equal(delayedReads(zombieTypes), 49, 'Unexpected delayed-read count in zombie_types.opy');
const bots = read('bots_game_in_progress.opy');
assert.equal(delayedReads(bots), 9, 'Unexpected delayed-read count in bots_game_in_progress.opy');
const tracker = lines(bots, 'isCrowdControlled == true');
assert.deepEqual(tracker, ['    @Condition eventPlayer.isCrowdControlled == true'],
    'Only BOT STUN MANAGEMENT may condition on the live flag');
assert(lines(bots, 'botIsCrowdControlled = true').length === 1
    && lines(bots, 'botIsCrowdControlled = false').length === 1
    && lines(bots, 'wait(0.125)').length === 1, 'BOT STUN MANAGEMENT polling window must stay intact');
const subroutines = read('subroutines.opy');
assert.equal(liveReads(subroutines), 0, 'subroutines.opy must not read the live flag');
assert.equal(delayedReads(subroutines), 4, 'Unexpected delayed-read count in subroutines.opy');
assert(lines(subroutines, 'botIsCrowdControlled = false').length === 1,
    'botRespawnInitialization must reset the delayed flag');

// Live flag on the shared tracker and Team 1 consumers; they never use the delayed flag.
assert.equal(liveReads(read('player_events.opy')), 2, 'CROWD CONTROL STATUS must set/reset the live flag');
for (const [name, live, delayed] of [['augments.opy', 5, 0], ['enhancements.opy', 3, 1], ['hero_tuning.opy', 1, 0]]) {
    const text = read(name);
    assert.equal(liveReads(text), live, `Unexpected live-read count in ${name}`);
    assert.equal(delayedReads(text), delayed, `Unexpected delayed-read count in ${name}`);
}

// The rebuild must stay in sync with main.ws.txt: renames do not change element counts.
// Compile from the root entry point so the export keeps the (src/...) rule annotations.
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const rules = require('./verify-player-variables.cjs').rules;
async function main() {
    await compiler.readyPromise;
    const current = await compile(files);
    assert.deepEqual(current.warnings, []);
    const rootBase = root.replace(/\\/g, '/') + '/';
    const build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', rootBase, 'main.opy');
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, current.elements, 'Root and merged builds disagree on element count');
    assert.deepEqual(rules(build.result), rules(current.result), 'Root and merged builds disagree on rules');
    const exported = fs.readFileSync(path.join(root, 'main.ws.txt'), 'utf8').replace(/\r\n/g, '\n');
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    else {
        assert.equal(current.elements, Number(exported.match(/total (\d+)/)[1]),
            'Compiled element count drifted from main.ws.txt');
        assert.equal(build.result, exported, 'main.ws.txt is stale; rerun with --write after src/ changes');
    }
    console.log(JSON.stringify({elements: current.elements, warnings: 0,
        delayedReads: delayedReads(zombieTypes) + delayedReads(bots) + delayedReads(subroutines),
        liveReadsOnZombies: 0}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
