// Measure repeated action sequences in memory; do not edit gameplay sources.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');

const escapeRegex = text => text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
function shareSequence(f, file, name, lines, occurrences) {
    const source = f[file];
    const regex = new RegExp('^([ \\t]*)' + lines.map(escapeRegex).join('\\n\\1'), 'gm');
    let count = 0;
    let changed = source.replace(regex, (_, indent) => {
        count++;
        return indent + name + '()';
    });
    assert.equal(count, occurrences, `${name}: occurrence count`);
    const header = changed.match(/^#!mainFile [^\n]+/);
    assert(header, `${name}: main file directive`);
    changed = changed.replace(header[0], `${header[0]}\nsubroutine ${name}`);
    changed += `\n\ndef ${name}():\n    @Name "${name}"\n\n` +
        lines.map(line => `    ${line}`).join('\n') + '\n';
    f[file] = changed;
}

const variants = {
    shared_bot_override_start(f) {
        shareSequence(f, 'zombie_types.opy', 'beginBotOverride', [
            'eventPlayer.botIsThrottleOverridden = true',
            'eventPlayer.stopThrottleInDirection()',
            'eventPlayer.botIsFacingOverridden = true',
        ], 3);
    },
    shared_bot_throttle_restore(f) {
        shareSequence(f, 'zombie_types.opy', 'restoreBotThrottle', [
            'eventPlayer.botIsThrottleOverridden = false',
            'startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)',
        ], 4);
    },
    shared_bot_facing_restore(f) {
        shareSequence(f, 'zombie_types.opy', 'restoreBotThrottleWithFacingOverride', [
            'eventPlayer.botIsThrottleOverridden = false',
            'eventPlayer.botIsFacingOverridden = true',
            'startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)',
        ], 2);
    },
    shared_boss_completion(f) {
        shareSequence(f, 'objective_types/objective_type_bosses.opy', 'completeBossObjective', [
            'isObjectiveComplete = true',
            'bossesStateList[bossesStateList.index(eventPlayer)] = 0',
            'eventPlayer.botRespawnDelay = 10',
        ], 2);
    },
    shared_powerup_drop_sound(f) {
        shareSequence(f, 'power_ups.opy', 'finishPowerUpDrop', [
            'eventPlayer.powerUpItemId = 0',
            'playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)',
        ], 2);
    },
    shared_wall_reenable_jump(f) {
        shareSequence(f, 'zombie_types.opy', 'reenableBotWallAndJump', [
            'eventPlayer.botIsWallCollisionEnabled = true',
            'eventPlayer.enableEnvironmentCollision()',
            'eventPlayer.forceButtonPress(Button.JUMP)',
        ], 2);
    },
    shared_burn_root(f) {
        shareSequence(f, 'zombie_types.opy', 'applyBriefBurnAndRoot', [
            'eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)',
            'eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)',
        ], 2);
    },
    shared_battle_reset(f) {
        shareSequence(f, 'enhancements.opy', 'resetBattleAbilityCharge', [
            'eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, 1)',
            'eventPlayer.enhancementIsBattleResetReady = false',
        ], 2);
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const candidate = {...files};
        try {
            transform(candidate);
            const result = await compile(candidate);
            console.log(JSON.stringify({name, elements: result.elements,
                saved: before.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) {
            console.log(JSON.stringify({name, error: String(error.message).slice(0, 450)}));
        }
    }
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
