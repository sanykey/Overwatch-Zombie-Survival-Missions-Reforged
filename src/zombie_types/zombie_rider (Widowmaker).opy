#!mainFile "../../main.opy"

rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS":
    @Event playerDealtDamage
    @Team 2
    @Hero widowmaker
    @Condition eventAbility == Button.MELEE
    @Condition victim == eventPlayer.botTarget
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer in bossStateList == false

    eventPlayer.botIsAttached = true
    eventPlayer.botAbilityTarget = victim
    eventPlayer.attachTo(eventPlayer.botAbilityTarget, eventPlayer.botAbilityTarget.sizeScale * Vector.FORWARD)


rule "RIDER DETACH":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.wrestlerZombieCarrier == null
    @Hero widowmaker
    @Condition eventPlayer.botIsAttached == true
    # Keep target validity local to its original branch; teammate detachment also
    # requires a combat target and a Team 2 attachment. Neither branch waits.
    @Condition ((eventPlayer.botAbilityTarget != null and (eventPlayer.botIsCrowdControlled or eventPlayer.botAbilityTarget.invisibilityCount or eventPlayer.isDead() or eventPlayer.botAbilityTarget.isDead() or eventPlayer.botAbilityTarget.hasStatus(Status.PHASED_OUT) or eventPlayer.botAbilityTarget.hasStatus(Status.INVINCIBLE) or not entityExists(eventPlayer.botAbilityTarget)) == true) or (eventPlayer.botTarget != null and eventPlayer.botAbilityTarget.getTeam() == Team.2 and (eventPlayer.botIsTeleporting or eventPlayer.botAbilityTarget.botIsTeleporting or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) < 3 or eventPlayer.botTarget.isOnGround() and not eventPlayer.getAbilityCooldown(Button.ABILITY_1) and distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) < 10) == true)) == true

    eventPlayer.botAbilityTarget = null
    eventPlayer.botIsAttached = false
    eventPlayer.detach()


rule "RIDER ATTACH TO TEAMMATES":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.isAlive() == true
    #If any valid teammates are within range
    @Condition (getLivingPlayers(Team.2).any(lambda x: not x.botIsTeleporting and x.getHero() != Hero.WIDOWMAKER and distance(eventPlayer, x) < 4 * eventPlayer.sizeScale)) == true
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) > 20 or eventPlayer.getAbilityCooldown(Button.ABILITY_1) and distance(eventPlayer, eventPlayer.botTarget) > 7.5) == true

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botAbilityTarget = (sorted(getLivingPlayers(Team.2).filter(lambda x: not x.botIsTeleporting and x.getHero() != eventPlayer.getHero()), lambda x: distance(eventPlayer, x)))[0]
    eventPlayer.attachTo(eventPlayer.botAbilityTarget, eventPlayer.botAbilityTarget.sizeScale * vect(random.uniform(-0.5, 0.5), 0.25, -0.75))
    eventPlayer.botIsAttached = true


rule "RIDER USE GRAPPLING HOOK":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.botTarget.isOnGround() == true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) < 20
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 5

    eventPlayer.botIsFacingOverridden = true
    eventPlayer.botRiderGrapplePosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition(), null, eventPlayer, false)
    eventPlayer.stopFacing()
    waitUntil(not eventPlayer.botIsCrowdControlled, 2)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botRiderGrapplePosition), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    wait(0.25)
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(eventPlayer, eventPlayer.botTarget) < 4 or distance(eventPlayer, eventPlayer.botRiderGrapplePosition) < 3.5, 3)
    if eventPlayer.isUsingAbility1():
        eventPlayer.startForcingButton(Button.JUMP)
        wait(0.25)
        eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
    wait(0.25)
    if ruleCondition:
        loop()
