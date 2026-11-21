#!mainFile "../../main.opy"


#!define CLOAKING_DEVICE_DURATION 25
#!define CLOAKING_DEVICE_CANCEL_DELAY 3


macro cloakingCancelDelayElapsed():
    getTotalTimeElapsed() >= eventPlayer.powerUpCloakEndsAt - (CLOAKING_DEVICE_DURATION - CLOAKING_DEVICE_CANCEL_DELAY)


macro canCancelCloakingDevice():
    cloakingCancelDelayElapsed() and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT)


def activateCloakingDevice():
    @Name "activateCloakingDevice"

    if eventPlayer.powerUpCloakEndsAt == 0:
        eventPlayer.movementSpeedScale *= 1.5
        applyScaledMoveSpeed()
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpCloakingDeviceSphereId = getLastCreatedEntity()
        hudText(eventPlayer, "Cloaking Device: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpCloakEndsAt)), null, "Cancel (Press [{0}] + [{1}])".format(inputBindingString(Button.CROUCH), inputBindingString(Button.INTERACT)) if cloakingCancelDelayElapsed() else [], HudPosition.RIGHT, 0.2, Color.BLUE, null, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.CLOAKING_DEVICE_HUD] = getLastCreatedText()
        eventPlayer.invisibilityCount++
    eventPlayer.powerUpCloakEndsAt = getTotalTimeElapsed() + CLOAKING_DEVICE_DURATION
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "Cloaking activated. You are now invisible.")
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.getPosition(), 50)
    startRule(cloakingDevice, StartRuleBehavior.NOOP)


def cloakingDevice():
    @Name "cloakingDevice (60-69)"

    while getTotalTimeElapsed() < eventPlayer.powerUpCloakEndsAt and eventPlayer.isAlive():
        if canCancelCloakingDevice():
            smallMessage(eventPlayer, "Cloaking deactivated")
            break
        waitUntil(canCancelCloakingDevice(), 1)
    eventPlayer.invisibilityCount--
    destroyEffect(eventPlayer.powerUpCloakingDeviceSphereId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.CLOAKING_DEVICE_HUD])
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "You are now visible")
    eventPlayer.movementSpeedScale /= 1.5
    applyScaledMoveSpeed()
    eventPlayer.powerUpCloakEndsAt = 0
