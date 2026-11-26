#!mainFile "../../main.opy"

macro useAuspexScan():
    if getTotalTimeElapsed() < eventPlayer.enhancementAuspexReadyAt:
        return

    # Cast beyond the range so the miss endpoint fails the range check.
    # Snapshot the visuals and consume pulse scratch before the beam cleanup wait.
    #!define auspexPlacementHit tmp0
    #!define auspexPulseTargets tmp1
    #!define auspexMarkTargets tmp2
    auspexPlacementHit = raycastHitPosition(
        eventPlayer.getEyePosition(),
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (AUSPEX_RANGE + 1),
        getLivingPlayers(Team.2), null, false
    )
    if distance(eventPlayer.getEyePosition(), auspexPlacementHit) > AUSPEX_RANGE:
        return

    eventPlayer.enhancementAuspexReadyAt = getTotalTimeElapsed() + AUSPEX_COOLDOWN
    createBeam(getPlayers(Team.1), Beam.BAD, eventPlayer, auspexPlacementHit, AUSPEX_COLOR, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, AUSPEX_COLOR, auspexPlacementHit, AUSPEX_RADIUS * 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, auspexPlacementHit, 50)

    auspexPulseTargets = getPlayersInRadius(auspexPlacementHit, AUSPEX_RADIUS, Team.2, LosCheck.OFF).filter(lambda zombie: zombie.isAlive())
    auspexMarkTargets = auspexPulseTargets.filter(lambda zombie: zombie.isDummy())
    auspexMarkTargets.botAuspexOwner = eventPlayer
    auspexMarkTargets.botAuspexExpiry = getTotalTimeElapsed() + AUSPEX_MARK_DURATION
    # Read the boss handle only in the Bosses objective; Zombie Egg reuses its slot.
    auspexPulseTargets.exclude(bossesStateList[0] if currentObjectiveType == ObjectiveType.BOSSES else null).setStatusEffect(
        eventPlayer, Status.HACKED, AUSPEX_MARK_DURATION)

    wait(0.5, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null


def clearAuspexMark():
    eventPlayer.botAuspexExpiry = 0
    eventPlayer.botAuspexBonusFraction = 0
    refreshBotDamageReceived()


rule "AUSPEX MARK LIFETIME":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botAuspexExpiry > 0

    # The marked bot applies the modifier when this rule starts.
    eventPlayer.botAuspexBonusFraction = auspexBonusFractionFor(eventPlayer)
    refreshBotDamageReceived()

    # Rescans extend the deadline. Death clears it and aborts the wait.
    while eventPlayer.botAuspexExpiry > getTotalTimeElapsed():
        wait(eventPlayer.botAuspexExpiry - getTotalTimeElapsed(), Wait.ABORT_WHEN_FALSE)
    clearAuspexMark()
