#!mainFile "../../main.opy"

def applyHitEnhancements():
    @Name "applyHitEnhancements"

    # Shared synchronous hit inputs: tmp3 is the victim, tmp2 is actual damage.
    # Native callers supply eventDamage; the scripted macro supplies health lost.
    # No waits/async calls; tmp0/tmp1 (Telekinesis targets/damage) survive.
    # Overcharge's bonus Damage has no Event Ability and cannot reenter this handler.
    if enhancementHitDamage <= 0:
        return
    if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
        if enhancementHitVictim != eventPlayer and distance(eventPlayer, enhancementHitVictim) < PYROTECHNIC_IGNITE_RANGE:
            enhancementHitVictim.setStatusEffect(eventPlayer, Status.BURNING, PYROTECHNIC_BURN_DURATION)
            eventPlayer.enhancementPyroHitList.append(enhancementHitVictim)
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        if eventPlayer.enhancementCapacitorCharge > 0 and enhancementHitVictim != eventPlayer:
            if eventPlayer.enhancementCapacitorDeadline == 0:
                eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
            if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                damage(enhancementHitVictim, eventPlayer, eventPlayer.enhancementCapacitorCharge)


rule "CROWD CONTROL STATUS":
    @Event eachPlayer
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.STUNNED)) == true

    eventPlayer.isCrowdControlled = true
    waitUntil(not ruleCondition, Math.INFINITY)
    eventPlayer.isCrowdControlled = false


rule "PLAYER DEALT FINAL BLOW":
    @Event playerDealtFinalBlow
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE:
        # Numeric reset counter: comparisons contribute exactly 0 or 1.
        eventPlayer.enhancementBattleResetCharges += eventPlayer.enhancementBattleResetCharges < BORN_TO_BATTLE_MAX_RESETS

    if currentObjectiveType != ObjectiveType.KILL_ZONE:
        return
    if playerTargetList.concat(victim).any(lambda x: distance(x, killZoneCenter) < objectiveRad) == true:
        if distance(eventPlayer, killZoneCenter) < objectiveRad or distance(victim, killZoneCenter) < objectiveRad:
            victim.botRespawnDelay = 2
            killZoneEliminationScore += ceil(victim.botBaseHealth / 280)
            if killZoneEliminationScore >= ELIMINATIONS_NEEDED_PER_OBJECTIVE:
                isObjectiveComplete = true
                #Give all bots a long respawn time
                delayZombieRespawns()
        #Adjust Kill Zone Positions
        killZoneCenter += 0.5 * directionTowards(killZoneCenter, victim)


rule "PLAYER EARNED ELIMINATION":
    @Event playerEarnedElimination
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        # One credit for a kill or damage participation; healing/buff assists do not count.
        eventPlayer.enhancementBulkStacks += 1
        applyBulkingSeasonStats()


rule "PLAYER DIED":
    @Event playerDied
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        eventPlayer.enhancementBulkStacks = floor(eventPlayer.enhancementBulkStacks * (1 - BULKING_SEASON_DEATH_LOSS_PCT / 100))
        applyBulkingSeasonStats()
    elif eventPlayer.enhancementId == Enhancement.ENGINEER and eventPlayer.enhancementScrapBeamEntity != null:
        # Scrap itself survives death; only the transfer beam is torn down.
        destroyEffect(eventPlayer.enhancementScrapBeamEntity)
        eventPlayer.enhancementScrapBeamEntity = null

    if eventPlayer.augmentId == Augment.DASH:
        # A death inside the resist window must not carry the 0% damage intake
        # or the knockback immunity into the next life before the deadline passes.
        if eventPlayer.augmentDashSmokeEntity != null:
            destroyEffect(eventPlayer.augmentDashSmokeEntity)
            eventPlayer.augmentDashSmokeEntity = null
            eventPlayer.setKnockbackReceived(100)
    # Death ends the ultimate resist with the ultimate itself, and Super Nano
    # cleans up on its own thread (~1.25s, always before any respawn), so the
    # recompute restores the normal intake for the next life.
    applyDamageReceivedModifier()
    # Health pools vanish with death, so any player's scrap-armor stacks must
    # go with them, whatever their enhancement or augment.
    if eventPlayer.scrapArmorAmount > 0:
        eventPlayer.scrapArmorAmount = 0


rule "PLAYER DEALT HEALING":
    @Event playerDealtHealing
    @Team 1

    if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR:
        if eventPlayer.isInfected:
            eventPlayer.infectionLevel -= eventHealing / 500
            eventPlayer.enhancementPlagueCureTotal += eventHealing / 500
        if healee.infectionLevel >= 1 and healee.enhancementId != Enhancement.ZOMBIE_HYBRID:
            healee.infectionLevel -= eventHealing / 275
            eventPlayer.enhancementPlagueCureTotal += eventHealing / 275
            if healee.infectionLevel < 1:
                healee.infectionLevel -= 0.5
                eventPlayer.enhancementPlagueCureTotal += 0.5
                playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
                smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "PLAYER DEALT DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition victim != attacker
    @Condition eventDamage > 0

    if eventPlayer.enhancementId == Enhancement.BRAIN_KILLER:
        if eventWasCriticalHit == true:
            damage(victim, eventPlayer, eventDamage * (BRAIN_KILLER_BOSS_CRIT_BONUS_PCT / 100 if victim in bossStateList else BRAIN_KILLER_CRIT_BONUS_PCT / 100))
            playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
    elif eventAbility != null:
        enhancementHitDamage = eventDamage
        enhancementHitVictim = victim
        applyHitEnhancements()

    # Augments: Survivalist includes damage from the hero, primary enhancement and
    # scripted powerups. The HIGHRISE airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.SURVIVALIST:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * 0.15)


rule "PLAYER PICKS UP HEALTH PACK":
    @Event playerReceivedHealing
    @Team 1

    # Event eligibility stays synchronous; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventWasHealthPack == true):
        eventPlayer.startHealingOverTime(null, 5, 20)
        if isGameplayActive and eventPlayer.enhancementId == Enhancement.OVERCHARGE:
            # Credit the actual pack healing.
            eventPlayer.enhancementCapacitorEnergy += eventHealing / OVERCHARGE_HEAL_ENERGY_DIVISOR
        # Keep discovered packs for the normal cure indicators.
        if healthpackPositionList.all(lambda x: distance(x, eventPlayer) > 5):
            healthpackPositionList.append(eventPlayer.getPosition())
        if healthpacksCureNormally:
            eventPlayer.stopAllDamageOverTime()
            eventPlayer.clearStatusEffect(Status.BURNING)
            if eventPlayer.infectionLevel > 0:
                eventPlayer.isInfected = false
                eventPlayer.infectionLevel = 0
        elif eventPlayer.isInfected:
            smallMessage(eventPlayer, "Health packs no longer cure infection.")
