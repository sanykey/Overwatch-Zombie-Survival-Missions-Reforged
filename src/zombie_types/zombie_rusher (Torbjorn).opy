#!mainFile "../../main.opy"

rule "RUSHER (TORB) SPEED MECHANICS":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition magnitude(eventPlayer.getThrottle())
    @Condition eventPlayer in bossStateList == false
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 45

    eventPlayer.applyImpulse(vect(0, 1, 3), 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.5)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 15

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    while not eventPlayer.isUsingAbility2():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.botIsCrowdControlled, Math.INFINITY)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        wait(0.25)
        if eventPlayer.isDead():
            return
    eventPlayer.addHealthPool(Health.ARMOR, 1000, false)
    eventPlayer.botRusherHealthPoolId = getLastCreatedHealthPool()
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    wait(1)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(directionFromAngles(evalOnce(random.uniform(0, 360)), evalOnce(random.uniform(-80, -87))), 0 if eventPlayer.botIsCrowdControlled else 144, Relativity.TO_PLAYER)
    while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.botIsCrowdControlled, Math.INFINITY)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.25)
    wait(1)
    while eventPlayer.isUsingUltimate():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.25)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    resumeBotFacingAndMovement()
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    removeHealthPool(eventPlayer.botRusherHealthPoolId)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero torbjorn
    @Condition eventAbility == Button.ULTIMATE
    @Condition not victim.isDotProtected

    victim.startDamageOverTime(attacker, 1, eventPlayer.botBiteDamage * 0.5)
    victim.setStatusEffect(attacker, Status.BURNING, 0.5)
    victim.damageOverTimeRemaining = max(victim.damageOverTimeRemaining, 0.5)
