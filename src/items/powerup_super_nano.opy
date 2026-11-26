#!mainFile "../../main.opy"


def activateSuperNano():
    @Name "activateSuperNano"

    if eventPlayer.powerUpSuperNanoEndsAt == 0:
        eventPlayer.movementSpeedScale *= 1.5
        applyScaledMoveSpeed()
        createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, PLAYER_BUFF_AURA_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpSuperNanoAuraId = getLastCreatedEntity()
        hudHeader(eventPlayer, "Super Nano: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpSuperNanoEndsAt)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_HUD] = getLastCreatedText()
        startDamageModification(getPlayers(Team.2), eventPlayer, 200)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_DEALT_MODIFICATION] = getLastDamageModification()
        startDamageModification(eventPlayer, getAllPlayers(), 50)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION] = getLastDamageModification()
    eventPlayer.powerUpSuperNanoEndsAt = getTotalTimeElapsed() + SUPER_NANO_DURATION
    heal(eventPlayer, null, 100)
    # The aura handle above gates this resist in the shared recompute, which
    # keeps an active Dash window at 0 instead of overwriting it.
    applyDamageReceivedModifier()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    startRule(superNano, StartRuleBehavior.NOOP)


def superNano():
    @Name "superNano (70-79)"

    while true:
        while getTotalTimeElapsed() < eventPlayer.powerUpSuperNanoEndsAt and eventPlayer.isAlive():
            wait(1)
        if eventPlayer.isDead():
            # Expire on death but keep ownership of the modifiers until cleanup.
            eventPlayer.powerUpSuperNanoEndsAt = getTotalTimeElapsed()
        wait(0.25)
        # A refresh during the cleanup delay keeps the same modifiers and HUD.
        if getTotalTimeElapsed() >= eventPlayer.powerUpSuperNanoEndsAt:
            break
    destroyEffect(eventPlayer.powerUpSuperNanoAuraId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_HUD])
    stopDamageModification(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_DEALT_MODIFICATION])
    stopDamageModification(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION])
    eventPlayer.setMoveSpeed(100)
    eventPlayer.powerUpSuperNanoAuraId = 0
    # Clearing the handle first lets the recompute keep an active Dash window.
    applyDamageReceivedModifier()
    eventPlayer.movementSpeedScale /= 1.5
    applyScaledMoveSpeed()
    eventPlayer.powerUpSuperNanoEndsAt = 0
