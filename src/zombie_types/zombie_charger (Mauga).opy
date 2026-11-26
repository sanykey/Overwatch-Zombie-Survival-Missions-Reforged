#!mainFile "../../main.opy"

rule "CHARGER (MAUGA) CHARGE":
    @Event eachPlayer
    @Team 2
    @Hero mauga
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.isOnGround() == true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition magnitude(eventPlayer.getThrottle())
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 35
    @Condition (distance(eventPlayer, eventPlayer.botTarget) < 5 or verticalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botTarget)) > -35) == true

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.botIsWallCollisionEnabled = true
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 1500 if eventPlayer.botIsAttached else 0 if eventPlayer.botIsCrowdControlled else 100)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.startThrottleInDirection(Vector.BACKWARD, 0.35, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    # Keep the nominal windup of 16 * 0.064s and use the delayed crowd-control flag.
    waitUntil(eventPlayer.botIsCrowdControlled or eventPlayer.isDead(), 1.024)
    if eventPlayer.botIsCrowdControlled or eventPlayer.isDead():
        resumeBotFacingAndMovement()
        return
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.botTarget if eventPlayer.botChargerDestination == null else eventPlayer.botChargerDestination), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    eventPlayer.botIsFacingOverridden = true
    faceCurrentThrottle()
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    #Charge End
    waitUntil(not eventPlayer.isUsingAbility1(), 2 if eventPlayer in bossStateList else 3.5)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setMoveSpeed(100)
    resumeBotFacingAndMovement()
    eventPlayer.botIsWallPhaseAllowed = true
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4 if eventPlayer in bossStateList else 6)


rule "CHARGER KNOCKBACK":
    @Event playerDealtDamage
    @Team 2
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1

    #Damage players
    damage(victim, eventPlayer, eventPlayer.botBiteDamage * 0.75)
    if not eventPlayer.isUsingAbility1():
        return
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
