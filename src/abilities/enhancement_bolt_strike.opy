#!mainFile "../../main.opy"


macro useBoltStrike():
    if getTotalTimeElapsed() < eventPlayer.enhancementBoltReadyAt:
        return

    # The shared selector returns the living zombie closest to the crosshair.
    # All scratch is consumed before the beam's unconditional cleanup wait.
    #!define boltStrikeTarget tmp0
    #!define boltStrikeSplashTargets tmp1
    pullAimMode = PullAimMode.BOLT_STRIKE
    selectPullAimTarget()
    if boltStrikeTarget == null:
        return
    eventPlayer.enhancementBoltReadyAt = getTotalTimeElapsed() + BOLT_STRIKE_COOLDOWN

    # Snapshot the splash before the primary can die, and both beam endpoints
    # before damage or cleanup. Player collision does not block the splash.
    boltStrikeSplashTargets = getPlayersInRadius(boltStrikeTarget, BOLT_STRIKE_SPLASH_RADIUS, Team.2, LosCheck.SURFACES).filter(lambda target: target != boltStrikeTarget and target.isAlive() and target.isDummy() and not target.botIsTeleporting and not target.botIsInitializing)
    # Capture the audience for the static beam and both immediate effects before damage.
    #!define boltStrikeAudience tmp2
    boltStrikeAudience = getAllPlayers()
    createBeam(boltStrikeAudience, Beam.GOOD, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(boltStrikeTarget), Color.SKY_BLUE, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    playEffect(boltStrikeAudience, DynamicEffect.RING_EXPLOSION, Color.YELLOW, boltStrikeTarget, BOLT_STRIKE_WAVE_RADIUS)
    # Play the cue near the caster so a distant target does not muffle it.
    playEffect(boltStrikeAudience, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 100)
    boltStrikeSplashTargets.concat(boltStrikeTarget).setStatusEffect(eventPlayer, Status.STUNNED, BOLT_STRIKE_STUN_DURATION)
    damage(boltStrikeTarget, eventPlayer, BOLT_STRIKE_DAMAGE)
    damage(boltStrikeSplashTargets, eventPlayer, BOLT_STRIKE_SPLASH_DAMAGE)

    wait(BOLT_STRIKE_BEAM_DURATION, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null
