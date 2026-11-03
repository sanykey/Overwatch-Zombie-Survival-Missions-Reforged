// Combine the measured positive candidates without changing gameplay sources.
// After implementation, reproduce this probe with --baseline-ref 6593219.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const sequence = require('./probe-seventh-elements-2026-11-03.cjs').variants;
const filter = require('./probe-eighth-elements-2026-11-03.cjs').variants;
const vote = require('./probe-ninth-elements-2026-11-03.cjs').variants;

const selected = [
    ...['challenge_step', 'zombie_step', 'objective_step', 'enhancement_step',
        'reconnect_lookup'].map(name => [name, vote[name]]),
    ...['shared_bot_override_start', 'shared_bot_throttle_restore',
        'shared_boss_completion', 'shared_powerup_drop_sound',
        'shared_wall_reenable_jump', 'shared_burn_root',
        'shared_battle_reset'].map(name => [name, sequence[name]]),
    ['redundant_exclude_in_push', filter.redundant_exclude_in_push],
];
const newHelpers = [
    'advanceChallengeVote', 'advanceZombieVote', 'advanceObjectiveVote',
    'advanceEnhancementChoice', 'resolveReconnectUserIndex',
    'beginBotOverride', 'restoreBotThrottle', 'completeBossObjective',
    'finishPowerUpDrop', 'reenableBotWallAndJump', 'applyBriefBurnAndRoot',
    'resetBattleAbilityCharge',
];
const existingScratchSafeHelpers = [
    'applyScaledMoveSpeed', 'refreshCurrentObjectivePosition',
    'refreshCurrentObjectiveType', 'faceCurrentThrottle',
    'excludeCurrentHeroFromSelection', 'applyBotKnockbackScale',
    'applyCurrentSizeScale', 'applyBotBossHealth',
];

function inlineSynchronousHelpersForAudit(workshop, compiledRules) {
    let expanded = workshop;
    for (const name of [...newHelpers, ...existingScratchSafeHelpers]) {
        const helper = compiledRules.find(rule => rule.name === name);
        assert(helper, `${name}: compiled helper missing`);
        const match = helper.body.match(/actions \{\n([\s\S]*?)\n\}/);
        assert(match, `${name}: helper actions missing`);
        assert(!/\bWait\(|Call Subroutine|\btmp[1-9]\d*\b/.test(match[1]),
            `${name}: helper must not yield, nest, or use other scratch slots`);
        if (name.startsWith('advance')) {
            assert(match[1].includes('Global.tmp0'));
            assert(!/(?:Set|Modify) Global Variable\(tmp0/.test(match[1]),
                `${name}: vote offset must be read-only`);
        }
        else assert(!/\btmp0\b/.test(match[1]), `${name}: unexpected tmp0`);
        const call = `Call Subroutine(${name});`;
        assert(expanded.includes(call), `${name}: no calls`);
        expanded = expanded.replaceAll(call, match[1]);
    }
    return expanded.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter|advanceChallengeVote|advanceZombieVote|advanceObjectiveVote|advanceEnhancementChoice)"\) \{[\s\S]*?^\}/gm, '');
}

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    const combined = {...files};
    for (const [, transform] of selected) transform(combined);
    const after = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const scratch = checkWorkshop(inlineSynchronousHelpersForAudit(after.result, newRules));
    console.log(JSON.stringify({baseline: before.elements, after: after.elements,
        saved: before.elements - after.elements, warnings: after.warnings.length,
        selected: selected.map(([name]) => name), oldRules: oldRules.length,
        newRules: newRules.length, scratchRules: scratch.length}));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {selected, newHelpers, inlineSynchronousHelpersForAudit};
