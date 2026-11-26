#!mainFile "../../main.opy"

rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":
    @Event eachPlayer
    @Team 2
    @Hero pharah
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)

    beginBotOverride()
    startBlasterDaytakerFacing()
    eventPlayer.botBlasterCharge = 0
    eventPlayer.botBlasterResistPct = 50
    refreshBotDamageReceived()
    #charge up attack
    chaseOverTime(eventPlayer.botBlasterCharge, 2, 1 if eventPlayer.botTarget.isInAir() else 2, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.botBlasterCharge >= 2, Math.INFINITY)
    stopChasing(eventPlayer.botBlasterCharge)
    eventPlayer.botBlasterResistPct = 0
    refreshBotDamageReceived()
    if eventPlayer.isDead():
        eventPlayer.botBlasterCharge = 0
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        return
    chaseOverTime(eventPlayer.botBlasterCharge, 0, 0.25, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or not eventPlayer.botBlasterCharge, Math.INFINITY)
    if eventPlayer.isDead():
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        return
    # Both sight checks use the same point before the next wait.
    #!define blasterLaunchPoint tmp0
    blasterLaunchPoint = eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)
    if isInLoS(eventPlayer.getPosition(), blasterLaunchPoint) and isInLoS(eventPlayer.botLastTarget.getEyePosition(), blasterLaunchPoint):
        waitUntil(not eventPlayer.botIsCrowdControlled, Math.INFINITY)
        eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
        wait()
        waitUntil(eventPlayer.getVerticalSpeed() <= 0, Math.INFINITY)
        eventPlayer.stopThrottleInDirection()
        #Cooldown after flying
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        #Cooldown after staying on ground
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1)
    if eventPlayer in bossStateList:
        while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
            eventPlayer.setUltCharge(100)
            eventPlayer.setProjectileSpeed(35)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.25)
        waitUntil(not eventPlayer.isUsingUltimate(), 5)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4)
    else:
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.5)
    resumeBotMovementAndFacing()
    startBotThrottleAtTarget()


rule "BLASTER ROCKET HITS TARGET":
    @Event playerDealtDamage
    @Team 2
    @Hero pharah
    @Condition (eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]) == true
    @Condition not victim.isDotProtected

    #!define blasterRocketBurnDuration tmp0
    blasterRocketBurnDuration = 2 if eventAbility == Button.ULTIMATE else 1
    victim.startDamageOverTime(eventPlayer, blasterRocketBurnDuration, eventPlayer.botBiteDamage * (0.5 if eventAbility == Button.ULTIMATE else 1))
    victim.setStatusEffect(eventPlayer, Status.BURNING, blasterRocketBurnDuration)
    eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, blasterRocketBurnDuration)
