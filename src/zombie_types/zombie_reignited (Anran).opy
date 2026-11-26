#!mainFile "../../main.opy"

rule "REIGNITED (ANRAN) ABILITIES":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.isOnGround() and distance(eventPlayer, eventPlayer.botTarget) > 6 * eventPlayer.sizeScale and distance(eventPlayer, eventPlayer.botTarget) < 30 * eventPlayer.sizeScale and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20 or eventPlayer.isUsingUltimate()) == true

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), vect(eventPlayer.botTarget.getEyePosition().x, 10000, eventPlayer.botTarget.getEyePosition().z)), 10000)
    eventPlayer.startForcingButton(Button.CROUCH)
    wait(0.5)
    eventPlayer.stopForcingButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    if not eventPlayer.botIsCrowdControlled:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.5)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 10000)
        eventPlayer.cancelPrimaryAction()
        if not eventPlayer.botIsCrowdControlled and eventPlayer.botTarget != null:
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            # The impulse consumes this direction before any movement call or wait.
            #!define reignitedImpulseDirection tmp0
            reignitedImpulseDirection = directionTowards(eventPlayer, eventPlayer.botTarget)
            eventPlayer.applyImpulse(normalize(reignitedImpulseDirection + offsetUpQuarterConst), eventPlayer.sizeScale * (15 + 25 * abs(cosDeg(verticalAngleOfDirection(reignitedImpulseDirection)))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.botIsThrottleOverridden = false
            eventPlayer.botIsFacingOverridden = true
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            eventPlayer.forceButtonPress(Button.ABILITY_1)
    #wait(0.5)
    waitUntil(eventPlayer.isOnGround(), 1)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = true
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(4)
    loop()


rule "REIGNITED ULTIMATE ATTACK COUNTER":
    @Event playerTookDamage
    @Team 2
    @Hero anran
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventPlayer.botIsReigniteAttackUsed == false

    eventPlayer.botIsReigniteAttackUsed = true
    #Pre-explosion sound
    playReignitedWarningPair()
    eventPlayer.setStatusEffect(null, Status.BURNING, 5)
    wait(5)
    eventPlayer.botIsReigniteAttackUsed = false


rule "REIGNITED USES ULTIMATE NEAR PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isUsingUltimate() == true

    if eventPlayer.isOnGround() and getLivingPlayers(Team.1).any(lambda player: distance(eventPlayer, player) < 12):
        # Snapshot the emergence points once for every zombie using this ultimate window.
        # The open 2–7 m band has midpoint 4.5 m and half-width 2.5 m.
        eventPlayer.botReigniteSpawnPoints = mapGridList.filter(
            lambda point: abs(distance(eventPlayer, point) - 4.5) < 2.5
        )
    wait(0.25)
    eventPlayer.botReigniteSpawnPoints = []
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.addHealthPool(Health.ARMOR, 100, false, false)


rule "ZOMBIES SPAWN AT REIGNITED":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.isUsingUltimate() and eventPlayer.getHero() == Hero.ANRAN) != true
    @Condition eventPlayer in bossStateList != true
    @Condition eventPlayer in miniBossList != true
    @Condition getPlayersOnHero(Hero.ANRAN, Team.2).any(lambda player: player.botReigniteSpawnPoints != false)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botReigniteDestination == false

    # Each zombie rolls independently from the first Anran's nonempty snapshot.
    eventPlayer.botReigniteDestination = random.choice(getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botReigniteSpawnPoints != false)[0].botReigniteSpawnPoints)
    if eventPlayer.botReigniteDestination == null:
        return
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 0.5)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2)
    eventPlayer.setStatusEffect(null, Status.BURNING, 2.3)
    eventPlayer.botReigniteRisePosition = eventPlayer.botReigniteDestination - 2 * Vector.UP
    eventPlayer.startForcingPosition(eventPlayer.botReigniteRisePosition)
    chaseOverTime(eventPlayer.botReigniteRisePosition, eventPlayer.botReigniteDestination, 1.5)
    wait(2)
    eventPlayer.botReigniteDestination = false
    eventPlayer.stopForcingPosition()
