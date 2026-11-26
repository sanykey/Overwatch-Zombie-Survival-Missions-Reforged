#!mainFile "../../main.opy"

#!define SLIMER_TENTACLE_STEP 0.032
#!define SLIMER_TENTACLE_RETURN_STEP 0.25
#!define SLIMER_TENTACLE_RETURN_CHECKS 8


rule "SLIMER (MERCY) TENTACLE GRAB":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTentacleTargetPosition == null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20

    wait(0.016 if eventPlayer.isUsingUltimate() else 0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botAbilityTarget = null
    eventPlayer.botTentaclePosition = slimerTentacleOrigin()
    eventPlayer.botTentacleTargetPosition = eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.sizeScale
    #Tentacle extends
    chaseAtRate(eventPlayer.botTentaclePosition, eventPlayer.botTentacleTargetPosition, 50)
    wait()
    while eventPlayer.isAlive() and not eventPlayer.botIsCrowdControlled:
        # Snapshot the eye position for this step's raycast and both distances.
        #!define slimerRayOrigin tmp1
        slimerRayOrigin = eventPlayer.getEyePosition()
        if distance(slimerRayOrigin, raycastHitPosition(slimerRayOrigin, eventPlayer.botTentacleTargetPosition, getLivingPlayers(Team.1), getAllPlayers(), true)) <= distance(slimerRayOrigin, eventPlayer.botTentaclePosition):
            break
        # Select and grab the same player. Scratch expires before the next wait.
        #!define slimerTentacleCandidate tmp0
        slimerTentacleCandidate = playerTargetList.filter(lambda target: (
            not target.hasStatus(Status.PHASED_OUT)
            and distance(eventPlayer.botTentaclePosition, target.getEyePosition()) < 1
            and isInLoS(eventPlayer.botTentaclePosition, target.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
        ))[0]
        if slimerTentacleCandidate != null:
            eventPlayer.botAbilityTarget = slimerTentacleCandidate
            eventPlayer.botTentacleTargetPosition = slimerTentacleCandidate.getEyePosition()
            break
        wait(SLIMER_TENTACLE_STEP)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.botTentaclePosition, 0.25)
    #Tentacle retract
    chaseAtRate(eventPlayer.botTentaclePosition, slimerTentacleOrigin(), 50)
    if eventPlayer.isAlive() and not eventPlayer.botIsCrowdControlled and eventPlayer.botAbilityTarget != null:
        #Knocks target down if facing away from Mercy
        if abs(angleDifference(eventPlayer.botAbilityTarget.getHorizontalFacingAngle(), horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)))) < 75:
            eventPlayer.botAbilityTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 0.35)
        eventPlayer.botAbilityTarget.setGravity(0)
        eventPlayer.botAbilityTarget.applyImpulse(directionTowards(eventPlayer.botAbilityTarget.getEyePosition(), eventPlayer.getEyePosition()), eventPlayer.sizeScale * (15 if eventPlayer.botAbilityTarget.getMaxHealth() < 400 else 10), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.35)
        eventPlayer.botAbilityTarget.setGravity(100)
    # Keep the existing poll interval and leave the retract loop within two seconds.
    for eventPlayer.slimerTentacleReturnCheckIndex in range(SLIMER_TENTACLE_RETURN_CHECKS):
        if distance(eventPlayer.botTentaclePosition, slimerTentacleOrigin()) <= 0.25:
            break
        wait(SLIMER_TENTACLE_RETURN_STEP)
    eventPlayer.botTentacleTargetPosition = null
    stopChasing(eventPlayer.botTentaclePosition)
    #Lower cooldown for ulting boss if they do not hit a target
    if eventPlayer in bossStateList and eventPlayer.isUsingUltimate():
        if eventPlayer.slimerTentacleReturnCheckIndex >= SLIMER_TENTACLE_RETURN_CHECKS:
            restoreBotThrottle()
        wait(0.25)
    else:
        restoreBotThrottle()
        wait(2.25 if eventPlayer.botTarget.isInAir() else 4.5)
    if ruleCondition:
        loop()
