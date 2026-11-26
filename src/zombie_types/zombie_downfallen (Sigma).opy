#!mainFile "../../main.opy"

rule "DOWNFALLEN (SIGMA) FIRES":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.botIsDownfallenGrabbing != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 40
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 5 * eventPlayer.sizeScale

    if not eventPlayer in bossStateList and eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) != true:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    if distance(eventPlayer, eventPlayer.botTarget) < 11 * eventPlayer.sizeScale and not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.1)
        if not eventPlayer.botIsDownfallenGrabbing:
            eventPlayer.cancelPrimaryAction()
    wait(2)
    if ruleCondition:
        loop()


macro isDownfallenGrabInterrupted = eventPlayer.isDead() or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.botIsCrowdControlled or eventPlayerHasHardCrowdControl


rule "DOWNFALLEN GRABS PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= ((2.5 if eventPlayer in bossStateList else 3) * eventPlayer.sizeScale)
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botIsDownfallenGrabbing != true
    @Condition eventPlayer.botTarget.isCrowdControlCooldownActive != true
    @Condition eventPlayer.botIsTeleportConfirmed == true

    eventPlayer.cancelPrimaryAction()
    eventPlayer.botAbilityTarget = eventPlayer.botTarget
    eventPlayer.botIsDownfallenGrabbing = true
    eventPlayer.botAbilityTarget.isCrowdControlCooldownActive = true
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setUltCharge(100)
    eventPlayer.botAbilityTarget.attachTo(eventPlayer, vect(0, 3 if eventPlayer in bossStateList else 0, 1))
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.botAbilityTarget.startFacing(directionTowards(eventPlayer.botAbilityTarget.getEyePosition(), eventPlayer.getEyePosition() - 0.2 * Vector.UP), 999)
    eventPlayer.applyImpulse(vect(0, 5, -3), 5 * eventPlayer.sizeScale, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    # The scripted throw stays interruptible even if the native ultimate has not started yet or ends early.
    waitUntil(isDownfallenGrabInterrupted, 1.25)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.botAbilityTarget.stopFacing()
    if isDownfallenGrabInterrupted or distance(eventPlayer.getEyePosition(), eventPlayer.botAbilityTarget.getEyePosition()) > 4 * eventPlayer.sizeScale:
        detachAbilityTarget()
    else:
        eventPlayer.forceButtonPress(Button.MELEE)
        detachAbilityTarget()
        eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botAbilityTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 1.75)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.botAuxiliaryState = null
    restoreBotThrottle()
    eventPlayer.botIsWallPhaseAllowed = true
    wait(7)
    eventPlayer.botIsDownfallenGrabbing = false
    eventPlayer.botAbilityTarget = false


rule "DOWNFALLEN PULLS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.botTarget.applyImpulse(directionTowards(eventPlayer.botTarget.getEyePosition(), eventPlayer.getEyePosition()), 2, Relativity.TO_WORLD)
    if eventPlayer.botTarget == null or eventPlayer.isInViewAngle(eventPlayer.botTarget.getPosition(), 55) != true or eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) == true:
        eventPlayer.cancelPrimaryAction()
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5.9)
