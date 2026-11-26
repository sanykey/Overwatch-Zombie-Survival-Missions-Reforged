#!mainFile "../../main.opy"

rule "STRIKER (WRECKING BALL) PILE DRIVER":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition not eventPlayer.getAbilityCooldown(Button.CROUCH)
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 15 * eventPlayer.sizeScale
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 35
    @Condition (eventPlayer.getAltitude() > 3 or eventPlayer.isOnGround() and isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 3 * Vector.UP)) == true

    wait(0.125, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.botIsStrikerStrikeActive = true
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.botIsWallCollisionEnabled = true
    eventPlayer.enableEnvironmentCollision()
    if eventPlayer.isOnGround():
        while not eventPlayer.isJumping():
            eventPlayer.forceButtonPress(Button.JUMP)
            waitUntil(eventPlayer.isJumping(), 1)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 4 * eventPlayer.sizeScale)
        eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.botTarget.getPosition() + (10 * eventPlayer.sizeScale) * Vector.UP), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.25)
        waitUntil(eventPlayer.getVelocity().y <= 0, 3)
    eventPlayer.forceButtonPress(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.botIsCrowdControlled, 5)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 3)
    eventPlayer.botIsStrikerStrikeActive = null
    eventPlayer.botIsWallPhaseAllowed = true


rule "STRIKER CANCEL BALL FORM":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.botIsThrottleOverridden == false

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    if ruleCondition:
        loop()


rule "STRIKER NORMAL PILE DRIVER":
    @Event playerDealtKnockback
    @Team 2
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    @Condition eventPlayer in bossStateList != true

    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker, victim)), 0), 7.5 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
