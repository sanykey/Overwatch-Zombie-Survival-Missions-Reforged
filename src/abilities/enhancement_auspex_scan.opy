#!mainFile "../../main.opy"

#!define auspexMarkOwner(bot) bot.botAuspexMark[0]
#!define auspexMarkExpiry(bot) bot.botAuspexMark[1]

rule "[AUSPEX SCAN] PLACE ON DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.AUSPEX_SCAN)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition getTotalTimeElapsed() >= eventPlayer.auspexReadyAt

    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), AUSPEX_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), AUSPEX_TAP_WINDOW)
    if not ruleCondition:
        return

    # Sample the second press. Cast beyond the range so the miss endpoint fails the range check.
    # The visuals snapshot the hit. Pulse scratch is consumed before beam cleanup waits.
    #!define auspexPlacementHit tmp0
    #!define auspexPulseTime tmp0
    #!define auspexPulseTargets tmp1
    auspexPlacementHit = raycastHitPosition(
        eventPlayer.getEyePosition(),
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (AUSPEX_RANGE + 1),
        getLivingPlayers(Team.2), null, false
    )
    if distance(eventPlayer.getEyePosition(), auspexPlacementHit) > AUSPEX_RANGE:
        return

    createBeam(getPlayers(Team.1), Beam.BAD, eventPlayer, auspexPlacementHit, AUSPEX_COLOR, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, AUSPEX_COLOR, auspexPlacementHit, AUSPEX_RADIUS * 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, auspexPlacementHit, 50)
    auspexPulseTargets = getPlayersInRadius(auspexPlacementHit, AUSPEX_RADIUS, Team.2, LosCheck.OFF).filter(lambda zombie: zombie.isAlive())
    auspexPulseTime = getTotalTimeElapsed()
    eventPlayer.auspexReadyAt = auspexPulseTime + AUSPEX_COOLDOWN

    (auspexPulseTargets.filter(lambda zombie: zombie.isDummy())).botAuspexMark = [
        eventPlayer, auspexPulseTime + AUSPEX_MARK_DURATION
    ]
    # The Bosses objective shares its state slot with the Zombie Egg objective.
    auspexPulseTargets.exclude(bossesStateList[0] if currentObjectiveType == ObjectiveType.BOSSES else null).setStatusEffect(
        eventPlayer, Status.HACKED, AUSPEX_MARK_DURATION)

    wait(BOLT_STRIKE_BEAM_DURATION, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null


rule "[AUSPEX SCAN] CREDIT BONUS DAMAGE":
    @Event playerTookDamage
    @Team 2

    # Event eligibility stays in Actions for the native hero-menu workaround.
    if not isGameplayActive or auspexMarkExpiry(eventPlayer) <= getTotalTimeElapsed():
        return
    if attacker.getTeam() != Team.1 or eventDamage <= 0 or not eventPlayer.isAlive():
        return
    # Separate windows per attacker allow overlapping hits on the same zombie.
    # Workshop Damage() has no Event Ability, so native hits bypass the guard.
    if eventAbility == null and getTotalTimeElapsed() < eventPlayer.botAuspexBonusUntil[attacker.getSlot()]:
        return

    # Both scratch values are consumed synchronously before damage can emit another event.
    #!define auspexChargeOwner tmp0
    #!define auspexBonusDamage tmp1
    auspexChargeOwner = auspexMarkOwner(eventPlayer)
    if not entityExists(auspexChargeOwner):
        return
    auspexBonusDamage = eventDamage * (AUSPEX_BOSS_BONUS_DAMAGE if eventPlayer in bossStateList or eventPlayer in miniBossList else AUSPEX_BONUS_DAMAGE)
    if attacker != auspexChargeOwner:
        auspexChargeOwner.setUltCharge(auspexChargeOwner.getUltCharge() + auspexBonusDamage * AUSPEX_ULT_PCT_PER_BONUS_DAMAGE)
    eventPlayer.botAuspexBonusUntil[attacker.getSlot()] = getTotalTimeElapsed() + 0.032
    damage(eventPlayer, attacker, auspexBonusDamage)
