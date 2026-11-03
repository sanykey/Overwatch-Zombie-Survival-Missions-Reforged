// Read-only source probes for newly identified element-count candidates.
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const candidates = {
    blaster_rocket_shared_duration(f) {
        const file = 'zombie_types.opy';
        const start = f[file].indexOf('rule "BLASTER ROCKET HITS TARGET":');
        const end = f[file].indexOf('\n\nrule ', start + 1);
        assert(start >= 0 && end > start);
        const block = f[file].slice(start, end);
        const old = `    if eventAbility == Button.ULTIMATE:
        victim.startDamageOverTime(eventPlayer, 2, eventPlayer.botBiteDamage * 0.5)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
        if eventPlayer.damageOverTimeRemaining < 2:
            eventPlayer.damageOverTimeRemaining = 2
    elif eventAbility == Button.PRIMARY_FIRE:
        victim.startDamageOverTime(eventPlayer, 1, eventPlayer.botBiteDamage)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 1)
        if eventPlayer.damageOverTimeRemaining < 1:
            eventPlayer.damageOverTimeRemaining = 1`;
        assert(block.includes(old));
        const next = `    #!define blasterRocketBurnDuration tmp0
    blasterRocketBurnDuration = 2 if eventAbility == Button.ULTIMATE else 1
    victim.startDamageOverTime(eventPlayer, blasterRocketBurnDuration, eventPlayer.botBiteDamage * (0.5 if eventAbility == Button.ULTIMATE else 1))
    victim.setStatusEffect(eventPlayer, Status.BURNING, blasterRocketBurnDuration)
    if eventPlayer.damageOverTimeRemaining < blasterRocketBurnDuration:
        eventPlayer.damageOverTimeRemaining = blasterRocketBurnDuration`;
        f[file] = f[file].slice(0, start) + block.replace(old, next) + f[file].slice(end);
    },
    supply_pickup_any(f) {
        replace(f, 'supply_drops.opy',
            'len(supplyPowerUpPositionList.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6))',
            'supplyPowerUpPositionList.any(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6)');
    },
    blaster_rocket_inline_duration(f) {
        const file = 'zombie_types.opy';
        const start = f[file].indexOf('rule "BLASTER ROCKET HITS TARGET":');
        const end = f[file].indexOf('\n\nrule ', start + 1);
        assert(start >= 0 && end > start);
        const block = f[file].slice(start, end);
        const old = `    if eventAbility == Button.ULTIMATE:
        victim.startDamageOverTime(eventPlayer, 2, eventPlayer.botBiteDamage * 0.5)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
        if eventPlayer.damageOverTimeRemaining < 2:
            eventPlayer.damageOverTimeRemaining = 2
    elif eventAbility == Button.PRIMARY_FIRE:
        victim.startDamageOverTime(eventPlayer, 1, eventPlayer.botBiteDamage)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 1)
        if eventPlayer.damageOverTimeRemaining < 1:
            eventPlayer.damageOverTimeRemaining = 1`;
        const duration = '2 if eventAbility == Button.ULTIMATE else 1';
        const next = `    victim.startDamageOverTime(eventPlayer, ${duration}, eventPlayer.botBiteDamage * (0.5 if eventAbility == Button.ULTIMATE else 1))
    victim.setStatusEffect(eventPlayer, Status.BURNING, ${duration})
    if eventPlayer.damageOverTimeRemaining < (${duration}):
        eventPlayer.damageOverTimeRemaining = ${duration}`;
        assert(block.includes(old));
        f[file] = f[file].slice(0, start) + block.replace(old, next) + f[file].slice(end);
    },
    objective_completion_effects(f) {
        const file = 'subroutines.opy';
        const start = f[file].indexOf('        #Checks if current objective is showdown\n');
        const end = f[file].indexOf('        # Objective IDs 1..7 are contiguous;', start);
        assert(start >= 0 && end > start);
        f[file] = f[file].slice(0, start) + `        if currentObjectiveType in [ObjectiveType.SHOWDOWN, ObjectiveType.BIOMORPHING, ObjectiveType.SURVIVOR_RESCUE]:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE if currentObjectiveType == ObjectiveType.SHOWDOWN else Color.GREEN if currentObjectiveType == ObjectiveType.BIOMORPHING else Color.VIOLET, currentObjectivePosition, objectiveRad * 2 if currentObjectiveType == ObjectiveType.SHOWDOWN else objectiveRad)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE if currentObjectiveType == ObjectiveType.SHOWDOWN else Color.ROSE if currentObjectiveType == ObjectiveType.BIOMORPHING else Color.VIOLET, currentObjectivePosition, 200)
        elif currentObjectiveType in [ObjectiveType.KILL_ZONE, ObjectiveType.ZOMBIE_EGG]:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED if currentObjectiveType == ObjectiveType.KILL_ZONE else Color.LIME_GREEN, killZoneCenter if currentObjectiveType == ObjectiveType.KILL_ZONE else currentObjectivePosition, 200)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED if currentObjectiveType == ObjectiveType.KILL_ZONE else Color.LIME_GREEN, killZoneCenter if currentObjectiveType == ObjectiveType.KILL_ZONE else currentObjectivePosition, objectiveRad * 2)
            if currentObjectiveType == ObjectiveType.ZOMBIE_EGG:
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, currentObjectivePosition, 3)
        elif currentObjectiveType == ObjectiveType.SATELLITE_UPLINK:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, currentObjectivePosition, 200)
` + f[file].slice(end);
    },
    daytaker_shared_abort(f) {
        const file = 'zombie_types.opy';
        const old = `        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        eventPlayer.botAbilityTarget.isAttached = false
        return`;
        assert.equal(f[file].split(old).length - 1, 2);
        f[file] = f[file].replace('subroutine applyBriefBurnAndRoot', 'subroutine daytakerAbortReset\nsubroutine applyBriefBurnAndRoot')
            .replaceAll(old, '        daytakerAbortReset()\n        return') +
            `\n\ndef daytakerAbortReset():
    @Name "daytakerAbortReset"

    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    eventPlayer.botAbilityTarget.isAttached = false
`;
    },
    blaster_daytaker_shared_override_reset(f) {
        const file = 'zombie_types.opy';
        const pair = '        eventPlayer.botIsThrottleOverridden = false\n        eventPlayer.botIsFacingOverridden = false\n';
        const source = f[file];
        const blasterStart = source.indexOf('rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":');
        const daytakerEnd = source.indexOf('rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":');
        assert(blasterStart >= 0 && daytakerEnd > blasterStart);
        const region = source.slice(blasterStart, daytakerEnd);
        assert.equal(region.split(pair).length - 1, 4);
        f[file] = source.replace('subroutine applyBriefBurnAndRoot',
            'subroutine clearBlasterDaytakerOverride\nsubroutine applyBriefBurnAndRoot');
        const nextStart = f[file].indexOf('rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":');
        const nextEnd = f[file].indexOf('rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":');
        f[file] = f[file].slice(0, nextStart) +
            f[file].slice(nextStart, nextEnd).replaceAll(pair, '        clearBlasterDaytakerOverride()\n') +
            f[file].slice(nextEnd) +
            `\n\ndef clearBlasterDaytakerOverride():
    @Name "clearBlasterDaytakerOverride"

    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
`;
    },
    rider_shared_detach(f) {
        const file = 'zombie_types.opy';
        const old = '    eventPlayer.botAbilityTarget = null\n    eventPlayer.botIsAttached = false\n    eventPlayer.detach()';
        assert.equal(f[file].split(old).length - 1, 2);
        f[file] = f[file].replace('subroutine applyBriefBurnAndRoot',
            'subroutine detachRider\nsubroutine applyBriefBurnAndRoot')
            .replaceAll(old, '    detachRider()') +
            `\n\ndef detachRider():
    @Name "detachRider"

    eventPlayer.botAbilityTarget = null
    eventPlayer.botIsAttached = false
    eventPlayer.detach()
`;
    },
    anran_shared_restore(f) {
        const file = 'zombie_types.opy';
        const old = '            eventPlayer.botIsThrottleOverridden = false\n            eventPlayer.botIsFacingOverridden = true\n            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)';
        const old2 = old.replace(/^ {8}/gm, '');
        assert(f[file].includes(old) && f[file].includes(old2));
        f[file] = f[file].replace('subroutine applyBriefBurnAndRoot',
            'subroutine restoreAnranThrottle\nsubroutine applyBriefBurnAndRoot')
            .replace(old, '            restoreAnranThrottle()')
            .replace(old2, '    restoreAnranThrottle()') +
            `\n\ndef restoreAnranThrottle():
    @Name "restoreAnranThrottle"

    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = true
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
`;
    },
    downfallen_eye_offset(f) {
        replace(f, 'zombie_types.opy',
            'vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y - 0.2, eventPlayer.getEyePosition().z)',
            'eventPlayer.getEyePosition() - 0.2 * Vector.UP');
    },
    survivor_progress_single_denominator(f) {
        const file = 'objective_types/objective_type_survivor_rescue.opy';
        const a = 'distance(vect(currentObjectivePosition.x, eventPlayer.rescueStartPosition.y, currentObjectivePosition.z), eventPlayer.rescueStartPosition)';
        const b = 'distance(eventPlayer.getPosition(), vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z))';
        replace(f, file, `((${a} - ${b}) / ${a}) * 100`, `100 * (1 - ${b} / ${a})`);
    },
    survivor_progress_cached_denominator(f) {
        const file = 'objective_types/objective_type_survivor_rescue.opy';
        const a = 'distance(vect(currentObjectivePosition.x, eventPlayer.rescueStartPosition.y, currentObjectivePosition.z), eventPlayer.rescueStartPosition)';
        assert(f[file].includes('    rescueSurvivor.rescueStartPosition = rescueSurvivor.getPosition()'));
        f[file] = f[file].replace('    rescueSurvivor.rescueStartPosition = rescueSurvivor.getPosition()',
            `    rescueSurvivor.rescueStartPosition = rescueSurvivor.getPosition()\n    rescueSurvivor.rescueOriginalDistance = ${a.replaceAll('eventPlayer', 'rescueSurvivor')}`);
        assert.equal(f[file].split(a).length - 1, 2);
        f[file] = f[file].replaceAll(a, 'eventPlayer.rescueOriginalDistance');
        f['variables.opy'] += '\nplayervar rescueOriginalDistance\n';
    },
    bot_invisibility_all(f) {
        replace(f, 'bots_game_in_progress.opy',
            'playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.invisibilityCount or not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))');
    },
    bot_teleport_view_all(f) {
        replace(f, 'bots_game_in_progress.opy',
            'playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.isInViewAngle(eventPlayer.botTeleportPosition, 55) or not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))');
    },
    downfallen_detach_before_branch(f) {
        const file = 'zombie_types.opy';
        const start = f[file].indexOf('rule "DOWNFALLEN GRABS PLAYER":');
        const end = f[file].indexOf('\n\nrule ', start + 1);
        assert(start >= 0 && end > start);
        const block = f[file].slice(start, end);
        const old = `    if eventPlayer.isCrowdControlled or distance(eventPlayer.getEyePosition(), eventPlayer.botAbilityTarget.getEyePosition()) > 4 * eventPlayer.sizeScale or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead():
        eventPlayer.botAbilityTarget.stopFacing()
        eventPlayer.botAbilityTarget.detach()
    else:
        eventPlayer.forceButtonPress(Button.MELEE)
        eventPlayer.botAbilityTarget.detach()
        eventPlayer.botAbilityTarget.stopFacing()`;
        const next = `    #!define downfallenGrabBroken tmp0
    downfallenGrabBroken = eventPlayer.isCrowdControlled or distance(eventPlayer.getEyePosition(), eventPlayer.botAbilityTarget.getEyePosition()) > 4 * eventPlayer.sizeScale or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead()
    eventPlayer.botAbilityTarget.stopFacing()
    if not downfallenGrabBroken:
        eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.botAbilityTarget.detach()
    if not downfallenGrabBroken:`;
        assert(block.includes(old));
        f[file] = f[file].slice(0, start) + block.replace(old, next) + f[file].slice(end);
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(candidates)) {
        const f = {...files};
        try {
            transform(f);
            const result = await compile(f);
            console.log(JSON.stringify({name, elements: result.elements,
                saved: before.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) { console.log(JSON.stringify({name, error: error.message})); }
    }
    for (const [name, selected] of [
        ['conservative_combined', ['blaster_rocket_shared_duration', 'supply_pickup_any',
            'daytaker_shared_abort', 'downfallen_eye_offset']],
        ['with_progress_formula', ['blaster_rocket_shared_duration', 'supply_pickup_any',
            'daytaker_shared_abort', 'downfallen_eye_offset', 'survivor_progress_single_denominator']],
    ]) {
        const f = {...files};
        for (const candidate of selected) candidates[candidate](f);
        const result = await compile(f);
        const priorRules = rules(before.result), nextRules = rules(result.result);
        const keyRules = rows => {
            const seen = new Map();
            return new Map(rows.map(rule => {
                const occurrence = seen.get(rule.name) || 0;
                seen.set(rule.name, occurrence + 1);
                return [`${rule.name}#${occurrence}`, rule.body];
            }));
        };
        const priorByKey = keyRules(priorRules);
        const changedRules = [...keyRules(nextRules)].filter(([key, body]) =>
            priorByKey.get(key) !== body).map(([key]) => key);
        console.log(JSON.stringify({name, selected, elements: result.elements,
            saved: before.elements - result.elements, warnings: result.warnings.length,
            priorRuleCount: priorRules.length, nextRuleCount: nextRules.length, changedRules}));
    }
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {candidates};
