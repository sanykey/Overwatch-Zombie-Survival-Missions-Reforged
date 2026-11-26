#!mainFile "../../main.opy"

rule "DAYTAKER (ILLARI) BURST":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    @Condition getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: distance(eventPlayer, x) < 2.5 * eventPlayer.sizeScale) == true

    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.botIsFacingOverridden = true
    startBlasterDaytakerFacing()
    eventPlayer.botDaytakerCharge = 0
    #charge up attack
    chaseOverTime(eventPlayer.botDaytakerCharge, 2, 2 if eventPlayer in bossStateList else 1, ChaseTimeReeval.NONE)
    #Gather zombies
    eventPlayer.botAbilityTarget = (sorted((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer, player) < 2.5 * eventPlayer.sizeScale and ((player.getHero() != Hero.ILLARI and player != bossStateList) == true))).exclude(eventPlayer), lambda x: distance(eventPlayer, x)))[0]
    if eventPlayer.botAbilityTarget in bossStateList == true:
        goto lbl_0
    eventPlayer.botAbilityTarget.isAttached = true
    eventPlayer.botAbilityTarget.attachTo(eventPlayer, vect(0, 0.65 * eventPlayer.sizeScale, 0.5 * eventPlayer.sizeScale))
    waitUntil(eventPlayer.isDead() or eventPlayer.botTarget == null or angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 10, 10)
    # Use the same delayed flag for waking and classifying the interruption.
    waitUntil(eventPlayer.isDead() or eventPlayer.botIsCrowdControlled == true or eventPlayer.botDaytakerCharge >= 2, Math.INFINITY)
    #Finish charging
    stopChasing(eventPlayer.botDaytakerCharge)
    if eventPlayer.botIsCrowdControlled == true:
        lbl_0:
        stopChasing(eventPlayer.botDaytakerCharge)
        eventPlayer.botDaytakerCharge = 0
        detachAbilityTarget()
        eventPlayer.botAbilityTarget.isAttached = false
        goto lbl_1
    #Abort
    if eventPlayer.isDead():
        eventPlayer.botDaytakerCharge = 0
        daytakerAbortReset()
        return
    else:
        chaseOverTime(eventPlayer.botDaytakerCharge, 0, 0.35, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or not eventPlayer.botDaytakerCharge, Math.INFINITY)
    #Abort
    if eventPlayer.isDead():
        daytakerAbortReset()
        return
    waitUntil(not eventPlayer.botIsCrowdControlled, Math.INFINITY)
    eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Eject zombies
    if eventPlayer.isAlive() and eventPlayer.botAbilityTarget.isAlive():
        detachAbilityTarget()
        eventPlayer.botAbilityTarget.isAttached = false
        #Boss Collision
        if eventPlayer in bossStateList:
            eventPlayer.botIsWallPhaseAllowed = false
        eventPlayer.cancelPrimaryAction()
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.2)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.botAbilityTarget.getPosition(), 1.5 * eventPlayer.botAbilityTarget.sizeScale)
        if eventPlayer.botTarget != null:
            eventPlayer.botAbilityTarget.applyImpulse(directionTowards(eventPlayer.botAbilityTarget, eventPlayer.botTarget.getEyePosition() + (3 * eventPlayer.botTarget.sizeScale) * Vector.UP), 20 + 9 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        else:
            eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), -35), 20 + 9 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.botAbilityTarget = null
    lbl_1:
    wait(0.1)
    #Cooldown
    waitUntil(eventPlayer.getVerticalSpeed() <= 0, Math.INFINITY)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7 if 0 in bossStateList else 1 if eventPlayer.botTarget.isInAir() else 3)
    #Boss Collision
    if eventPlayer in bossStateList:
        eventPlayer.botIsWallPhaseAllowed = true
    resumeBotMovementAndFacing()
    startBotThrottleAtTarget()


rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    @Condition eventPlayer.botIsCrowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false

    illariUlt()
    wait(10)
    if ruleCondition:
        loop()

def daytakerAbortReset():
    @Name "daytakerAbortReset"

    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    eventPlayer.botAbilityTarget.isAttached = false
