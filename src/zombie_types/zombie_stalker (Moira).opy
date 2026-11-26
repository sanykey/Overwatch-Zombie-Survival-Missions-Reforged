#!mainFile "../../main.opy"

rule "STALKER (MOIRA) FADE":
    @Event eachPlayer
    @Team 2
    @Hero moira
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.botIsWallCollisionEnabled == true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 45

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.disablePlayerCollision()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.botIsCrowdControlled or eventPlayer.isUsingUltimate() else 75 if eventPlayer.isUsingAbility1() else 1500)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    for eventPlayer.botStalkerFadeIndex in range(5 if eventPlayer in bossStateList else 3):
        eventPlayer.botIsWallPhaseAllowed = false
        eventPlayer.botIsWallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        #Final fade
        if eventPlayer.botStalkerFadeIndex >= 2 and not eventPlayer in bossStateList:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.botIsCrowdControlled else 100)
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.botLastTarget), 0 if distance(eventPlayer, eventPlayer.botLastTarget) < 3 and eventPlayer.isUsingAbility1() else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
        eventPlayer.movementSpeedScale *= 2
        applyScaledMoveSpeed()
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.125)
        waitUntil(not eventPlayer.isUsingAbility1(), 2)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.movementSpeedScale /= 2
        applyScaledMoveSpeed()
        if eventPlayer.isDead() or eventPlayer.botIsCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
            break
        if eventPlayer in bossStateList:
            wait(0.125)
            useChargedUltimate()
            eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
            waitUntil(not eventPlayer.isUsingUltimate(), 1.3)
            eventPlayer.cancelPrimaryAction()
        else:
            eventPlayer.botIsWallPhaseAllowed = true
            wait(0.75)
    resumeBotMovementAndFacing()
    eventPlayer.botIsWallPhaseAllowed = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10 if eventPlayer in bossStateList else 5)


rule "STALKER KNOCKBACK BLAST (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero moira
    @Condition eventAbility == Button.ULTIMATE

    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker, victim)), -25), 10 * attacker.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        victim.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)
