#!mainFile "../../main.opy"

rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero emre
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTentacleTargetPosition == null
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 15

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.botIsThrottleOverridden = true
    while not eventPlayer.isJumping():
        reenableBotWallAndJump()
        waitUntil(eventPlayer.isJumping(), 1)
    eventPlayer.applyImpulse(Vector.UP, random.uniform(6, 10) * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    waitUntil(eventPlayer.getVelocity().y < 0, 3)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.BLACK, eventPlayer, 5 * eventPlayer.sizeScale)
    while eventPlayer.isUsingUltimate():
        eventPlayer.botIsThrottleOverridden = true
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.stopThrottleInDirection()
        while eventPlayer.botTarget != null and eventPlayer.isUsingUltimate() and not eventPlayer.botIsCrowdControlled:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1), 0 if eventPlayer.botIsCrowdControlled else 200)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
            #Altitude too low
            if eventPlayer.getAltitude() < 3:
                reenableBotWallAndJump()
            #Entities that will be floated
            entityFloat()
            # slimerFlightTargetIndex: floated-player index, to lift low targets and push higher targets away during flight.
            #!define slimerFlightTargetIndex tmp0
            for slimerFlightTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
                selectIndexedAbilityTarget()
                if eventPlayer.botAbilityTarget.getPosition().y < eventPlayer.getPosition().y:
                    #Make target float up
                    eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botAbilityTarget, eventPlayer)), -75), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                else:
                    #Push target away
                    eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)), -20), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            wait(0.032)
        resumeBotMovementAndFacing()
        wait(0.25)
    restoreBotThrottle()
    wait(10)
    if ruleCondition:
        loop()

def reenableBotWallAndJump():
    @Name "reenableBotWallAndJump"

    eventPlayer.botIsWallCollisionEnabled = true
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.forceButtonPress(Button.JUMP)
