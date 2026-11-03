// Compile additional Workshop element reductions in memory; do not edit gameplay sources.
// After implementation, reproduce the original probes with --baseline-ref 05e3ba5.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');

function sharedAction(f, name, action, occurrences) {
    const hits = Object.values(f).reduce((count, content) =>
        count + content.split(action).length - 1, 0);
    assert.equal(hits, occurrences, `${name}: expected occurrence count`);
    const file = 'subroutines.opy';
    f[file] = f[file].replace('subroutine enableDisableAbilities',
        `subroutine ${name}\nsubroutine enableDisableAbilities`);
    for (const path of Object.keys(f)) f[path] = f[path].replaceAll(action, `${name}()`);
    f[file] += `\n\ndef ${name}():\n    @Name "${name}"\n\n    ${action}\n`;
}

const variants = {
    shared_bot_visual_entity(f) {
        sharedAction(f, 'storeBotVisualEntity',
            'eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())', 20);
    },
    shared_objective_entity(f) {
        sharedAction(f, 'storeObjectiveEntity',
            'objectiveEntityIdList.append(getLastCreatedEntity())', 30);
    },
    shared_objective_text(f) {
        sharedAction(f, 'storeObjectiveText',
            'objectiveEntityIdList.append(getLastCreatedText())', 22);
    },
    shared_move_speed(f) {
        sharedAction(f, 'applyScaledMoveSpeed',
            'eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)', 12);
    },
    shared_objective_position_refresh(f) {
        sharedAction(f, 'refreshCurrentObjectivePosition',
            'currentObjectivePosition = objectivePositionList[0]', 6);
    },
    shared_objective_type_refresh(f) {
        sharedAction(f, 'refreshCurrentObjectiveType',
            'currentObjectiveType = objectiveTypeList[0]', 5);
    },
    shared_restore_facing_rule(f) {
        sharedAction(f, 'requestRestoreFacingMovement',
            'startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)', 9);
    },
    shared_throttle_facing(f) {
        sharedAction(f, 'faceCurrentThrottle',
            'eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)', 3);
    },
    shared_allowed_heroes(f) {
        sharedAction(f, 'excludeCurrentHeroFromSelection',
            'eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))', 2);
    },
    shared_knockback_scale(f) {
        sharedAction(f, 'applyBotKnockbackScale',
            'eventPlayer.setKnockbackReceived(100 * eventPlayer.botKnockbackScale)', 2);
    },
    shared_size_scale(f) {
        sharedAction(f, 'applyCurrentSizeScale',
            'eventPlayer.startScalingSize(eventPlayer.sizeScale, false)', 3);
    },
    shared_boss_health(f) {
        sharedAction(f, 'applyBotBossHealth',
            'eventPlayer.setHealth(eventPlayer.botBossHealth)', 3);
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
            const after = await compile(candidate);
            console.log(JSON.stringify({name, elements: after.elements,
                saved: before.elements - after.elements, warnings: after.warnings.length}));
        } catch (error) {
            console.log(JSON.stringify({name, error: String(error.message).slice(0, 450)}));
        }
    }
    const selected = ['shared_move_speed', 'shared_objective_position_refresh',
        'shared_objective_type_refresh', 'shared_throttle_facing',
        'shared_allowed_heroes', 'shared_knockback_scale',
        'shared_size_scale', 'shared_boss_health'];
    const combined = {...files};
    for (const name of selected) variants[name](combined);
    const after = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const numberOccurrences = list => {
        const counts = new Map();
        return list.map(rule => {
            const occurrence = (counts.get(rule.name) || 0) + 1;
            counts.set(rule.name, occurrence);
            return {key: `${rule.name}#${occurrence}`, body: rule.body};
        });
    };
    const oldBodies = new Map(numberOccurrences(oldRules).map(rule => [rule.key, rule.body]));
    const changedRules = numberOccurrences(newRules).filter(rule =>
        oldBodies.get(rule.key) !== rule.body).map(rule => rule.key);
    // Each selected helper is exactly one synchronous action and touches no tmp slot.
    // Inline that action only for the conservative scratch liveness audit.
    let auditOutput = after.result;
    for (const helper of ['applyScaledMoveSpeed', 'refreshCurrentObjectivePosition',
        'refreshCurrentObjectiveType', 'faceCurrentThrottle',
        'excludeCurrentHeroFromSelection', 'applyBotKnockbackScale',
        'applyCurrentSizeScale', 'applyBotBossHealth']) {
        const body = newRules.find(rule => rule.name === helper).body;
        const match = body.match(/actions \{\n([^\n]+)\n\}/);
        assert(match, `${helper}: expected a one-action helper`);
        assert(!/\btmp\d+\b|\bWait\(|Call Subroutine/.test(match[1]),
            `${helper}: helper must not yield or touch scratch`);
        auditOutput = auditOutput.replaceAll(`Call Subroutine(${helper});`, match[1]);
    }
    const withoutBotHelper = auditOutput.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratchRules = checkWorkshop(withoutBotHelper).length;
    console.log(JSON.stringify({name: 'combined', selected, elements: after.elements,
        saved: before.elements - after.elements, warnings: after.warnings.length,
        oldRules: oldRules.length, newRules: newRules.length, changedRules, scratchRules}));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
