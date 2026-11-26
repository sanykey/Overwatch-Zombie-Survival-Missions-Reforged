#!mainFile "../../main.opy"

macro smolderEnragedMacro():
    eventPlayer.botSmolderState = 2
    stopChasing(eventPlayer.botSmolderAnger)
    eventPlayer.stopForcingButton(Button.CROUCH)
    smolderBoost()
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)

rule "SMOLDER (WINSTON) SEES PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botSmolderState == 0
    @Condition (eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) or distance(eventPlayer, eventPlayer.botTarget) < 9 * eventPlayer.sizeScale) == true
    @Condition eventPlayer in bossStateList != true

    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.CROUCH)
    eventPlayer.movementSpeedScale *= 0.1
    applyScaledMoveSpeed()
    eventPlayer.botSmolderState = 1
    #Death timer
    chaseOverTime(eventPlayer.botSmolderAnger, 0, 6, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.botSmolderState == 2 or not eventPlayer.botSmolderAnger, Math.INFINITY)
    if eventPlayer.botSmolderState == 2:
        return
    stopChasing(eventPlayer.botSmolderAnger)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer, 1.5 * eventPlayer.sizeScale)
    wait(0.25)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    kill(eventPlayer)


rule "SMOLDER ACTIVATES FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Hero winston
    @Condition eventPlayer in bossStateList != true
    @Condition eventPlayer.botSmolderState == 1
    @Condition eventPlayer.botIsCrowdControlled != true

    eventPlayer.botSmolderState = 2
    stopChasing(eventPlayer.botSmolderAnger)
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), attacker.getEyePosition()), 9999)
    eventPlayer.botLastTarget = attacker
    eventPlayer.botTarget = attacker
    smolderBoost()
    wait(0.25)
    restoreDefaultFacingMovement()
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "SMOLDER BOSS SLAM":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botSmolderState == 0
    @Condition isSmolderEventActive != true
    @Condition eventPlayer.botLastTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 15 * eventPlayer.sizeScale

    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.5)
    eventPlayer.startFacing(eventPlayer.getFacingDirection() + Vector.UP, 300)
    wait(0.6)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 0.25)
    if eventPlayer.isUsingAbility1() == true:
        restoreDefaultFacingMovement()
        eventPlayer.botSmolderState = 1
        eventPlayer.enableEnvironmentCollision()
        waitUntil(not eventPlayer.isUsingAbility1(), 1)
        if not eventPlayer.botIsCrowdControlled and not eventPlayer.hasStatus(Status.HACKED):
            eventPlayer.applyImpulse(Vector.DOWN, 4, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            waitUntil(eventPlayer.isOnGround(), 2)
    wait(0.25)
    eventPlayer.botSmolderState = 0
    wait(4)


rule "SMOLDER SUPER SLAM":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botSmolderState != 0
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.isUsingAbility1() == true

    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 7.5 * eventPlayer.sizeScale)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.getPosition(), 100)
    # Share Winston's LoS origin across both synchronous target filters.
    #!define smolderShockwaveLoSOrigin tmp1
    smolderShockwaveLoSOrigin = eventPlayer.getPosition() + losOffsetConst
    eventPlayer.botSpecialTargetList = playerTargetList.concat(getLivingPlayers(Team.2)).exclude(eventPlayer).filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer, x) < 7.5 * eventPlayer.sizeScale and isInLoS(smolderShockwaveLoSOrigin, x.getPosition() + losOffsetConst))
    (eventPlayer.botSpecialTargetList.filter(lambda x: distance(eventPlayer, x) < 5 * eventPlayer.sizeScale and isInLoS(smolderShockwaveLoSOrigin, x.getPosition() + losOffsetConst, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 0.35)
    # smolderShockwaveTargetIndex: shockwave target index, to apply distance-scaled knockback to each affected player.
    #!define smolderShockwaveTargetIndex tmp0
    for smolderShockwaveTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
        selectIndexedAbilityTarget()
        eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botAbilityTarget)), -25), (15 if distance(eventPlayer, eventPlayer.botAbilityTarget) < 5 * eventPlayer.sizeScale else 7.5) * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT":
    @Event eachPlayer
    @Condition isSmolderEventActive == true
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition (eventPlayer in bossStateList or eventPlayer.botSmolderState == 2) == true

    useChargedUltimate()
    wait(0.5)
    if ruleCondition:
        loop()


rule "SMOLDER BOSS EVENT STARTS":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.botTarget != null

    wait(4)
    isSmolderEventActive = false
    (getPlayers(Team.2).filter(lambda player: player.getHero() == Hero.WINSTON)).setUltCharge(100)
    while not eventPlayer.isUsingUltimate():
        eventPlayer.clearStatusEffect(Status.HACKED)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.5)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    isSmolderEventActive = true
    kill(getPlayers(Team.2).filter(lambda player: player.getHero() != Hero.WINSTON), eventPlayer)
    wait(25)
    isSmolderEventActive = false
    wait(16)
    if ruleCondition:
        loop()


rule "SMOLDER ACTIVATED FROM BOSS EVENT":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botSmolderState == 1
    @Condition isSmolderEventActive == true
    @Condition eventPlayer in bossStateList != true

    smolderEnragedMacro()

def smolderBoost():
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1.5 * eventPlayer.sizeScale)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    useChargedUltimate()
    eventPlayer.sizeScale *= 1.5
    applyCurrentSizeScale()
    eventPlayer.movementSpeedScale *= 9
    applyScaledMoveSpeed()
