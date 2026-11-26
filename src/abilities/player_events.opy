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


def applyDamageReceivedModifier():
    @Name "applyDamageReceivedModifier"
    # The only Team 1 Set Damage Received writers are the Dash protection
    # window, the Super Nano power-up and the ultimate resist. Every state
    # edge calls this recompute; the strongest (lowest) intake wins and the
    # resists never stack. SWARM SHOOTOUT lowers intake through Start Damage
    # Modification, which multiplies on top and stays outside this recompute.
    # Synchronous tmp3 scratch. Dash activation retains its direction in tmp0.
    #!define isDashResistActive tmp3
    isDashResistActive = eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null
    # Cache the DoT gate for the bite, rocket, Molten Core, gas and explosion rules.
    eventPlayer.isDotProtected = eventPlayer.isUsingUltimate() or isDashResistActive
    # After Dash is handled, isDotProtected reflects the ultimate state.
    eventPlayer.setDamageReceived(0 if isDashResistActive else 50 if eventPlayer.powerUpSuperNanoAuraId != 0 else 65 if eventPlayer.isDotProtected else 100)


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
        creditBornToBattleFinalBlowMacro()

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
        creditBulkingSeasonEliminationMacro()


rule "PLAYER DIED":
    @Event playerDied
    @Team 1
    if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        applyBulkingSeasonDeathMacro()
    elif eventPlayer.enhancementId == Enhancement.ENGINEER and eventPlayer.enhancementScrapBeamEntity != null:
        clearEngineerBeamOnDeathMacro()

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
        applyPlagueDoctorHealingMacro()


rule "PLAYER DEALT DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition victim != attacker
    @Condition eventDamage > 0

    # Augments: Leech includes damage from the hero, primary enhancement and
    # scripted powerups. The HIGHRISE airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.SURVIVALIST:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * (SURVIVALIST_LIFESTEAL_PCT / 100))

    if victim.botAuspexExpiry > getTotalTimeElapsed() and eventPlayer != victim.botAuspexOwner and entityExists(victim.botAuspexOwner):
        # Credit this hit before Brain Killer's extra damage can kill the victim.
        # Subtract the damage the hit would have dealt without Auspex.
        victim.botAuspexOwner.setUltCharge(victim.botAuspexOwner.getUltCharge()
            + (eventDamage - eventDamage / (1 + victim.botAuspexBonus)) * AUSPEX_ULT_PCT_PER_BONUS_DAMAGE)

    if eventPlayer.enhancementId == Enhancement.BRAIN_KILLER and eventWasCriticalHit == true:
        applyBrainKillerCritMacro()

    # Scripted Damage has no Event Ability, keeping both bonuses from triggering themselves.
    if eventAbility == null:
        return

    if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
        applyPyrotechnicHitMacro(victim)
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        applyOverchargeHitMacro(victim)


rule "AUSPEX MARK CLEARS ON DEATH":
    @Event playerDied
    @Team 2
    @Condition eventPlayer.botAuspexExpiry > 0

    eventPlayer.botBlasterResistPct = 0
    clearAuspexMark()


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
