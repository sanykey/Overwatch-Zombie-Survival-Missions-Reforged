#!mainFile "../../main.opy"

def applyHitEnhancements():
    @Name "applyHitEnhancements"

    # Scripted hit inputs: tmp3 is the target, tmp2 is actual health lost.
    # No waits/async calls; tmp0/tmp1 (Telekinesis targets/damage) survive.
    if enhancementHitDamage <= 0:
        return
    if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
        applyPyrotechnicHitMacro(enhancementHitVictim)
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        applyOverchargeHitMacro(enhancementHitVictim)


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
        if eventPlayer.enhancementBattleResetCharges < BORN_TO_BATTLE_MAX_RESETS:
            eventPlayer.enhancementBattleResetCharges += 1

    if currentObjectiveType != ObjectiveType.KILL_ZONE:
        return
    # Reuse the victim's zone check for scoring and moving the center. Both reads are synchronous.
    #!define killZoneVictimInside tmp0
    killZoneVictimInside = distance(victim, killZoneCenter) < objectiveRad
    if killZoneVictimInside or playerTargetList.any(lambda x: distance(x, killZoneCenter) < objectiveRad):
        if killZoneVictimInside or distance(eventPlayer, killZoneCenter) < objectiveRad:
            victim.botRespawnDelay = 2
            killZoneEliminationScore += ceil(victim.botBaseHealth / 280)
            if killZoneEliminationScore >= ELIMINATIONS_NEEDED_PER_OBJECTIVE:
                isObjectiveComplete = true
                #Give all bots a long respawn time
                getPlayers(Team.2).botRespawnDelay = 12
                botSpawnTimeList = botSpawnTimeList.map(lambda _: getTotalTimeElapsed() + 12)
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
        eventPlayer.enhancementBulkStacks = floor(eventPlayer.enhancementBulkStacks / (100 / (100 - BULKING_SEASON_DEATH_LOSS_PCT)))
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
            #Critical hits deal 50% more damage, 20% if vicitm is a boss
            damage(victim, eventPlayer, eventDamage * (BRAIN_KILLER_BOSS_CRIT_BONUS_PCT / 100 if victim in bossStateList else BRAIN_KILLER_CRIT_BONUS_PCT / 100))
            playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
    elif eventAbility != null:
        # Overcharge's bonus has no Event Ability.
        if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
            applyPyrotechnicHitMacro(victim)
        elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
            applyOverchargeHitMacro(victim)

    # Augments: Leech includes damage from the hero, primary enhancement and
    # scripted powerups. The HIGHRISE airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.SURVIVALIST:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * (SURVIVALIST_LIFESTEAL_PCT / 100))


rule "PLAYER PICKS UP HEALTH PACK":
    @Event playerReceivedHealing
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventWasHealthPack == true):
        eventPlayer.startHealingOverTime(null, 5, 20)
        creditOverchargeHealthPackMacro()
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
