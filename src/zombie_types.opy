#!mainFile "main.opy"

subroutine smolderBoost
subroutine spawnGasCloud
subroutine abilityThrowdown
subroutine entityFloat
subroutine explosionWarning


macro smolderEnragedMacro():
    eventPlayer.botSmolderState = 2
    stopChasing(eventPlayer.botSmolderAnger)
    eventPlayer.stopForcingButton(Button.CROUCH)
    smolderBoost()
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "BASIC (REAPER) SHADOW STEP (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reaper
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(1)
    while not eventPlayer.isUsingAbility2():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        waitUntil(eventPlayer.isUsingAbility2(), 0.5)
        if eventPlayer.isUsingAbility2():
            waitUntil(not eventPlayer.isUsingAbility2(), 2)
            break
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.25)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(vect(-1, 0, 0), 180, Relativity.TO_PLAYER)
    while eventPlayer.isUsingAbility1():
        entityFloat()
        # shadowStepFloatTargetIndex: floated-player index, to push each affected player upward during the shadow-step ability.
        #!define shadowStepFloatTargetIndex tmp0
        for shadowStepFloatTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
            eventPlayer.botAbilityTarget = eventPlayer.botSpecialTargetList[shadowStepFloatTargetIndex]
            if eventPlayer.botAbilityTarget.getPosition().y < eventPlayer.getPosition().y + 4 * eventPlayer.sizeScale:
                #Make target float up
                eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botAbilityTarget.getPosition(), eventPlayer.getPosition())), -50), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            else:
                #Push target straight up
                eventPlayer.botAbilityTarget.applyImpulse(vect(0, 1, 0), 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.032)
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "BOMBER (JUNKRAT) SELF DESTRUCT":
    @Event eachPlayer
    @Team 2
    @Hero junkrat
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.sizeScale
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsBomberPrimed = true
    explosionWarning()
    if ruleCondition:
        loop()


rule "RUSHER (TORB) SPEED MECHANICS":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition eventPlayer in bossStateList == false
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 45
    
    eventPlayer.applyImpulse(vect(0, 1, 3), 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.5)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    while not eventPlayer.isUsingAbility2():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.isCrowdControlled, 99999)
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
    eventPlayer.startFacing(directionFromAngles(evalOnce(random.uniform(0, 360)), evalOnce(random.uniform(-80, -87))), 0 if eventPlayer.isCrowdControlled else 144, Relativity.TO_PLAYER)
    while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.isCrowdControlled, 99999)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.25)
    wait(1)
    while eventPlayer.isUsingUltimate():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.25)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.botIsFacingOverridden = false
    eventPlayer.botIsThrottleOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
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
    
    victim.startDamageOverTime(attacker, 1, eventPlayer.botBiteDamage * 0.5)
    victim.setStatusEffect(attacker, Status.BURNING, 0.5)
    if victim.damageOverTimeRemaining < 0.5:
        victim.damageOverTimeRemaining = 0.5


rule "BEHEMOTH (ROAD) TOXIC CLOUD":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition (eventPlayer in bossStateList or eventPlayer.getNormalizedHealth() < 0.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityResource(Button.ABILITY_2, 100)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    eventPlayer.botGasCloudTimeRemaining = 1.5
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.5)
    chaseAtRate(eventPlayer.botGasCloudTimeRemaining, 0, 1, ChaseRateReeval.NONE)
    while eventPlayer.botGasCloudTimeRemaining > 0 and eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0:
        if eventPlayer in bossStateList:
            #Charge Ultimate For Boss Gas Attack
            eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)
            eventPlayer.setStatusEffect(eventPlayer, Status.ROOTED, 0.26)
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3)
        else:
            #Gas Attack
            (playerTargetList.filter(lambda x: isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer.getPosition(), x.getPosition()) < 10 * eventPlayer.sizeScale and x.getEyePosition().y - eventPlayer.getPosition().y > 0 and x.getPosition().y - eventPlayer.getPosition().y < 2 * eventPlayer.sizeScale)).startDamageOverTime(eventPlayer, 2.5, eventPlayer.botBiteDamage * 0.231)
            if eventPlayer.damageOverTimeRemaining < 2.5:
                eventPlayer.damageOverTimeRemaining = 2.5
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
        waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.25)
    #Cooldown
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3 if eventPlayer in bossStateList else 8)
    eventPlayer.botGasCloudTimeRemaining = 0
    stopChasing(eventPlayer.botGasCloudTimeRemaining)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    if eventPlayer in bossStateList and eventPlayer.getUltCharge() >= 100:
        eventPlayer.setUltCharge(0)
        eventPlayer.botIsThrottleOverridden = true
        eventPlayer.stopThrottleInDirection()
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 1500 if eventPlayer.botIsAttached else 0 if eventPlayer.isCrowdControlled or eventPlayer.botTarget == null else 100)
        wait(1)
        waitUntil(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition())) < 5, 5)
        eventPlayer.stopFacing()
        eventPlayer.setStatusEffect(null, Status.STUNNED, 1)
        waitUntil(not eventPlayer.isCrowdControlled, 2)
        eventPlayer.botGasProjectilePosition = eventPlayer.getEyePosition()
        eventPlayer.botGasAimPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.sizeScale, null, getAllPlayers(), false)
        #Launch Gas Projectile
        chaseAtRate(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition, 20 * eventPlayer.sizeScale / 3, ChaseRateReeval.NONE)
        eventPlayer.botIsFacingOverridden = false
        eventPlayer.botIsThrottleOverridden = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        #Gas Cloud Positions
        eventPlayer.botGasPositionList = []
        #Gas Cloud Areas of Effect
        eventPlayer.botGasRadiusList = []
        while distance(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition) > 0.1 and len(eventPlayer.botGasPositionList) < 3:
            spawnGasCloud()
            waitUntil(distance(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition) <= 0.1 or len(eventPlayer.botGasPositionList) >= 3, 0.9)
        #If projectile hits wall
        if len(eventPlayer.botGasPositionList) < 3:
            spawnGasCloud()
        stopChasing(eventPlayer.botGasProjectilePosition)
        eventPlayer.botGasProjectilePosition = null
        waitUntil(eventPlayer.isDead(), 3)
        wait(5)
        eventPlayer.botGasPositionList = []
        eventPlayer.botGasRadiusList = []
    if ruleCondition:
        loop()


rule "BEHEMOTH GAS STREAM (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition len(eventPlayer.botGasPositionList) > 0
    
    eventPlayer.botSpecialTargetList = []
    # behemothGasCloudIndex: gas-cloud index, to expand its radius and collect newly hit players.
    #!define behemothGasCloudIndex tmp0
    for behemothGasCloudIndex in range(len(eventPlayer.botGasPositionList)):
        if eventPlayer.botGasRadiusList[behemothGasCloudIndex] < 6 * eventPlayer.sizeScale:
            eventPlayer.botGasRadiusList[behemothGasCloudIndex] += 0.2 * eventPlayer.sizeScale
        eventPlayer.botSpecialTargetList.append(playerTargetList.filter(lambda x: not x in eventPlayer.botSpecialTargetList and distance(eventPlayer.botGasPositionList[behemothGasCloudIndex], vect(x.getEyePosition().x, eventPlayer.botGasPositionList[behemothGasCloudIndex].y, x.getEyePosition().z)) < eventPlayer.botGasRadiusList[behemothGasCloudIndex] and abs(eventPlayer.botGasPositionList[behemothGasCloudIndex].y - x.getEyePosition().y) < eventPlayer.botGasRadiusList[behemothGasCloudIndex] / 5))
    eventPlayer.botSpecialTargetList.startDamageOverTime(eventPlayer, 2.5, eventPlayer.botBiteDamage * 0.1)
    if eventPlayer.damageOverTimeRemaining < 2.5 and len(eventPlayer.botSpecialTargetList) > 0:
        eventPlayer.damageOverTimeRemaining = 2.5
    wait(0.25)
    if ruleCondition:
        loop()


rule "BRUTE (REIN) SUPER SEISMIC SLAM":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition distance(worldVector(vect(0, 0, 3 * eventPlayer.sizeScale), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget.getPosition()) < 1.5 * eventPlayer.sizeScale
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    while not eventPlayer.isUsingUltimate():
        wait(0.016, Wait.RESTART_WHEN_TRUE)
        if eventPlayer.isDead():
            return
        if eventPlayer.isCrowdControlled:
            return
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.sizeScale), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 20 * eventPlayer.sizeScale)
    (getLivingPlayers(Team.ALL).exclude(eventPlayer).filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 20 * eventPlayer.sizeScale and distance(worldVector(vect(0, 0, 3 * eventPlayer.sizeScale), eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition()) > 1.5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.sizeScale)).applyImpulse(vect(0, 1, 0), 15 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.sizeScale), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3 * eventPlayer.sizeScale)
    (null.concat(getLivingPlayers(Team.2)).filter(lambda x: distance(x.getPosition(), worldVector(vect(0, 0, 3 * eventPlayer.sizeScale), eventPlayer, Transform.ROTATION_AND_TRANSLATION)) < 1.5 * eventPlayer.sizeScale and not x.hasStatus(Status.KNOCKED_DOWN))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2.5)


rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 5 * eventPlayer.sizeScale
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.WINSTON, Hero.JUNKER_QUEEN] == true
    
    if eventPlayer.getHero() == Hero.WINSTON and not eventPlayer.isUsingUltimate():
        return
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.startForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)
    wait(0.25)
    if eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        wait(7.75)
    eventPlayer.setPrimaryFireEnabled(false)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)


rule "BRUTE KNOCKDOWN":
    @Event playerTookDamage
    @Team 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.getHero() == Hero.REINHARDT
    
    attacker.setUltCharge(attacker.getUltCharge() + 25)
    eventPlayer.applyImpulse(directionTowards(attacker.getPosition(), eventPlayer.getPosition()) + offsetUpQuarterConst, 15 * attacker.sizeScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    if eventPlayer.isCrowdControlCooldownActive == true:
        goto lbl_0
    eventPlayer.isCrowdControlCooldownActive = true
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    eventPlayer.setGravity(0)
    wait(0.35)
    eventPlayer.setGravity(100)
    wait(2)


rule "BRUTE FIRE STRIKE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) > 5 * eventPlayer.sizeScale
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    wait(1)
    if ruleCondition:
        loop()


rule "REIGNITED (ANRAN) ABILITIES":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.isOnGround() and eventPlayer.botTarget != null and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 6 * eventPlayer.sizeScale and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.sizeScale and abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20 or eventPlayer.isUsingUltimate()) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), vect(eventPlayer.botTarget.getEyePosition().x, 10000, eventPlayer.botTarget.getEyePosition().z)), 10000)
    eventPlayer.startForcingButton(Button.CROUCH)
    wait(0.5)
    eventPlayer.stopForcingButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    if not eventPlayer.isCrowdControlled:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.5)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 10000)
        eventPlayer.cancelPrimaryAction()
        if not eventPlayer.isCrowdControlled and eventPlayer.botTarget != null:
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            eventPlayer.applyImpulse(normalize(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + offsetUpQuarterConst), eventPlayer.sizeScale * (15 + 25 * abs(cosDeg(verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()))))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
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
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.sizeScale)
    eventPlayer.setStatusEffect(null, Status.BURNING, 5)
    wait(5)
    eventPlayer.botIsReigniteAttackUsed = false


rule "REIGNITED USES ULTIMATE NEAR PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isUsingUltimate() == true
    
    if eventPlayer.isOnGround() and getLivingPlayers(Team.1).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 12):
        eventPlayer.botIsReigniteActive = true
    wait(0.25)
    eventPlayer.botIsReigniteActive = false
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.addHealthPool(Health.ARMOR, 100, false, false)


rule "ZOMBIES SPAWN AT REIGNITED":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.isUsingUltimate() and eventPlayer.getHero() == Hero.ANRAN) != true
    @Condition eventPlayer in bossStateList != true
    @Condition eventPlayer in miniBossList != true
    @Condition len(getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botIsReigniteActive)) > null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botReigniteDestination == false
    
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 0.5)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2)
    eventPlayer.setStatusEffect(null, Status.BURNING, 2.3)
    # reigniteSpawnSource: active Anran used only by the immediate emergence-destination search.
    #!define reigniteSpawnSource tmp0
    reigniteSpawnSource = getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botIsReigniteActive)[0]
    eventPlayer.botReigniteDestination = random.choice(mapGridList.filter(lambda x: distance(reigniteSpawnSource.getPosition(), x) > 2 and distance(reigniteSpawnSource.getPosition(), x) < 7))
    eventPlayer.botReigniteRisePosition = eventPlayer.botReigniteDestination - vect(0, 2, 0)
    eventPlayer.startForcingPosition(eventPlayer.botReigniteRisePosition)
    chaseOverTime(eventPlayer.botReigniteRisePosition, eventPlayer.botReigniteDestination, 1.5)
    wait(2)
    eventPlayer.botReigniteDestination = false
    eventPlayer.stopForcingPosition()


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
    eventPlayer.attachTo(eventPlayer.botAbilityTarget, vect(0, 0, eventPlayer.botAbilityTarget.sizeScale))


rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botIsAttached == true
    @Condition eventPlayer.botAbilityTarget != null
    @Condition (eventPlayer.isCrowdControlled or eventPlayer.botAbilityTarget.invisibilityCount or eventPlayer.isDead() or eventPlayer.botAbilityTarget.isDead() or eventPlayer.botAbilityTarget.hasStatus(Status.PHASED_OUT) or eventPlayer.botAbilityTarget.hasStatus(Status.INVINCIBLE) or not entityExists(eventPlayer.botAbilityTarget)) == true
    
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
    @Condition (getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: not x.botIsTeleporting and x.getHero() != Hero.WIDOWMAKER and distance(eventPlayer.getPosition(), x.getPosition()) < 4 * eventPlayer.sizeScale)) == true
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) > 20 or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0 and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 7.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botAbilityTarget = (sorted(getLivingPlayers(Team.2).exclude(eventPlayer).filter(lambda x: not x.botIsTeleporting and x.getHero() != eventPlayer.getHero()), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    eventPlayer.attachTo(eventPlayer.botAbilityTarget, eventPlayer.botAbilityTarget.sizeScale * vect(random.uniform(-0.5, 0.5), 0.25, -0.75))
    eventPlayer.botIsAttached = true


rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botIsAttached == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botAbilityTarget.getTeam() == Team.2
    @Condition (eventPlayer.botIsTeleporting or eventPlayer.botAbilityTarget.botIsTeleporting or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 3 or eventPlayer.botTarget.isOnGround() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 10) == true
    
    eventPlayer.botAbilityTarget = null
    eventPlayer.botIsAttached = false
    eventPlayer.detach()


rule "RIDER USE GRAPPLING HOOK":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.botTarget.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5
    
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.botRiderGrapplePosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition(), null, eventPlayer, false)
    eventPlayer.stopFacing()
    waitUntil(not eventPlayer.isCrowdControlled, 2)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botRiderGrapplePosition), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    wait(0.25)
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 4 or distance(eventPlayer.getPosition(), eventPlayer.botRiderGrapplePosition) < 3.5, 3)
    if eventPlayer.isUsingAbility1():
        eventPlayer.startForcingButton(Button.JUMP)
        wait(0.25)
        eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
    wait(0.25)
    if ruleCondition:
        loop()


rule "CHARGER (MAUGA) CHARGE":
    @Event eachPlayer
    @Team 2
    @Hero mauga
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 5 or verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition())) > -35) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.botIsWallCollisionEnabled = true
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 1500 if eventPlayer.botIsAttached else 0 if eventPlayer.isCrowdControlled else 100)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.startThrottleInDirection(vect(0, 0, -1), 0.35, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Charger walk backwards duration
    for eventPlayer.botChargerWindupProgress in range(0, 1, 0.064):
        if eventPlayer.isCrowdControlled or eventPlayer.isDead():
            eventPlayer.botIsFacingOverridden = false
            eventPlayer.botIsThrottleOverridden = false
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            return
        wait(0.064)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() if eventPlayer.botChargerDestination == null else eventPlayer.botChargerDestination), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    #Charge End
    waitUntil(not eventPlayer.isUsingAbility1(), 2 if eventPlayer in bossStateList else 3.5)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.botIsFacingOverridden = false
    eventPlayer.botIsThrottleOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
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


rule "SLIMER (MERCY) TENTACLE GRAB":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTentacleTargetPosition == null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    wait(0.016 if eventPlayer.isUsingUltimate() else 0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botAbilityTarget = null
    eventPlayer.botTentaclePosition = eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.sizeScale if eventPlayer.isInAir() else eventPlayer.getEyePosition()
    eventPlayer.botTentacleTargetPosition = eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.sizeScale
    #Tentacle extends
    chaseAtRate(eventPlayer.botTentaclePosition, eventPlayer.botTentacleTargetPosition, 50)
    wait()
    while eventPlayer.isAlive() and not eventPlayer.isCrowdControlled and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTentacleTargetPosition, getLivingPlayers(Team.1), getAllPlayers(), true)) > distance(eventPlayer.getEyePosition(), eventPlayer.botTentaclePosition):
        if playerTargetList.any(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.botTentaclePosition, x.getEyePosition()) < 1 and isInLoS(eventPlayer.botTentaclePosition, x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)):
            eventPlayer.botAbilityTarget = (playerTargetList.filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.botTentaclePosition, x.getEyePosition()) < 1 and isInLoS(eventPlayer.botTentaclePosition, eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)))[0]
            eventPlayer.botTentacleTargetPosition = eventPlayer.botAbilityTarget.getEyePosition()
            break
        wait(0.032)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.botTentaclePosition, 0.25)
    #Tentacle retract
    chaseAtRate(eventPlayer.botTentaclePosition, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.sizeScale if eventPlayer.isInAir() else eventPlayer.getEyePosition(), 50)
    if eventPlayer.isAlive() and not eventPlayer.isCrowdControlled and eventPlayer.botAbilityTarget != null:
        #Knocks target down if facing away from Mercy
        if abs(angleDifference(eventPlayer.botAbilityTarget.getHorizontalFacingAngle(), horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botAbilityTarget.getPosition())))) < 75:
            eventPlayer.botAbilityTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 0.35)
        eventPlayer.botAbilityTarget.setGravity(0)
        eventPlayer.botAbilityTarget.applyImpulse(directionTowards(eventPlayer.botAbilityTarget.getEyePosition(), eventPlayer.getEyePosition()), eventPlayer.sizeScale * (15 if eventPlayer.botAbilityTarget.getMaxHealth() < 400 else 10), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.35)
        eventPlayer.botAbilityTarget.setGravity(100)
    while (distance(eventPlayer.botTentaclePosition, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.sizeScale if eventPlayer.isInAir() else eventPlayer.getEyePosition())) > 0.25:
        wait(0.25)
    eventPlayer.botTentacleTargetPosition = null
    stopChasing(eventPlayer.botTentaclePosition)
    #Lower cooldown for ulting boss if they do not hit a target
    if eventPlayer in bossStateList and eventPlayer.isUsingUltimate():
        wait(0.25)
    else:
        eventPlayer.botIsThrottleOverridden = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(2.25 if eventPlayer.botTarget.isInAir() else 4.5)
    if ruleCondition:
        loop()


rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero emre
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTentacleTargetPosition == null
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.botIsThrottleOverridden = true
    while not eventPlayer.isJumping():
        eventPlayer.botIsWallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        eventPlayer.forceButtonPress(Button.JUMP)
        waitUntil(eventPlayer.isJumping(), 1)
    eventPlayer.applyImpulse(vect(0, 1, 0), random.uniform(6, 10) * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    waitUntil(eventPlayer.getVelocity().y < 0, 3)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.BLACK, eventPlayer, 5 * eventPlayer.sizeScale)
    while eventPlayer.isUsingUltimate():
        eventPlayer.botIsThrottleOverridden = true
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.stopThrottleInDirection()
        while eventPlayer.botTarget != null and eventPlayer.isUsingUltimate() and not eventPlayer.isCrowdControlled:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1), 0 if eventPlayer.isCrowdControlled else 200)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
            #Altitude too low
            if eventPlayer.getAltitude() < 3:
                eventPlayer.botIsWallCollisionEnabled = true
                eventPlayer.enableEnvironmentCollision()
                eventPlayer.forceButtonPress(Button.JUMP)
            #Entities that will be floated
            entityFloat()
            # slimerFlightTargetIndex: floated-player index, to lift low targets and push higher targets away during flight.
            #!define slimerFlightTargetIndex tmp0
            for slimerFlightTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
                eventPlayer.botAbilityTarget = eventPlayer.botSpecialTargetList[slimerFlightTargetIndex]
                if eventPlayer.botAbilityTarget.getPosition().y < eventPlayer.getPosition().y:
                    #Make target float up
                    eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botAbilityTarget.getPosition(), eventPlayer.getPosition())), -75), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                else:
                    #Push target away
                    eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botAbilityTarget.getPosition())), -20), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            wait(0.032)
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(0.25)
    eventPlayer.botIsThrottleOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(10)
    if ruleCondition:
        loop()


rule "STRIKER (WRECKING BALL) PILE DRIVER":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.getAbilityCooldown(Button.CROUCH) <= 0
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.sizeScale
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (eventPlayer.getAltitude() > 3 or eventPlayer.isOnGround() and isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + vect(0, 3, 0))) == true
    
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
        eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, 10 * eventPlayer.sizeScale, 0)), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.25)
        waitUntil(eventPlayer.getVelocity().y <= 0, 3)
    eventPlayer.forceButtonPress(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isCrowdControlled, 5)
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
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), 0), 7.5 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "STALKER (MOIRA) FADE":
    @Event eachPlayer
    @Team 2
    @Hero moira
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsWallCollisionEnabled == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 45
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.disablePlayerCollision()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.isCrowdControlled or eventPlayer.isUsingUltimate() else 75 if eventPlayer.isUsingAbility1() else 1500)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    for eventPlayer.botStalkerFadeIndex in range(5 if eventPlayer in bossStateList else 3):
        eventPlayer.botIsWallPhaseAllowed = false
        eventPlayer.botIsWallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        #Final fade
        if eventPlayer.botStalkerFadeIndex >= 2 and not eventPlayer in bossStateList:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.isCrowdControlled else 100)
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botLastTarget.getPosition()), 0 if distance(eventPlayer.getPosition(), eventPlayer.botLastTarget.getPosition()) < 3 and eventPlayer.isUsingAbility1() else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
        eventPlayer.movementSpeedScale *= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.125)
        waitUntil(not eventPlayer.isUsingAbility1(), 2)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.movementSpeedScale /= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
        if eventPlayer.isDead() or eventPlayer.isCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
            break
        if eventPlayer in bossStateList:
            wait(0.125)
            eventPlayer.setUltCharge(100)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
            waitUntil(not eventPlayer.isUsingUltimate(), 1.3)
            eventPlayer.cancelPrimaryAction()
        else:
            eventPlayer.botIsWallPhaseAllowed = true
            wait(0.75)
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.botIsWallPhaseAllowed = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10 if eventPlayer in bossStateList else 5)


rule "STALKER KNOCKBACK BLAST (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero moira
    @Condition eventAbility == Button.ULTIMATE
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), -25), 10 * attacker.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        victim.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)


rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":
    @Event eachPlayer
    @Team 2
    @Hero pharah
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.isCrowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.botBlasterCharge = 0
    eventPlayer.setDamageReceived(50)
    #charge up attack
    chaseOverTime(eventPlayer.botBlasterCharge, 2, 1 if eventPlayer.botTarget.isInAir() else 2, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.botBlasterCharge >= 2, 99999)
    stopChasing(eventPlayer.botBlasterCharge)
    if eventPlayer.isDead():
        eventPlayer.setDamageReceived(100)
        eventPlayer.botBlasterCharge = 0
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        return
    else:
        #charge up attack
        chaseOverTime(eventPlayer.botBlasterCharge, 0, 0.25, ChaseTimeReeval.NONE)
    eventPlayer.setDamageReceived(100)
    waitUntil(eventPlayer.isDead() or eventPlayer.botBlasterCharge <= 0, 99999)
    if eventPlayer.isDead():
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        return
    if isInLoS(eventPlayer.getPosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)) and isInLoS(eventPlayer.botLastTarget.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)):
        waitUntil(not eventPlayer.isCrowdControlled, 99999)
        eventPlayer.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
        wait()
        waitUntil(eventPlayer.getVerticalSpeed() <= 0, 99999)
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
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "BLASTER ROCKET HITS TARGET":
    @Event playerDealtDamage
    @Team 2
    @Hero pharah
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ULTIMATE) == true
    
    if eventAbility == Button.ULTIMATE:
        victim.startDamageOverTime(eventPlayer, 2, eventPlayer.botBiteDamage * 0.5)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
        if eventPlayer.damageOverTimeRemaining < 2:
            eventPlayer.damageOverTimeRemaining = 2
    elif eventAbility == Button.PRIMARY_FIRE:
        victim.startDamageOverTime(eventPlayer, 1, eventPlayer.botBiteDamage)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 1)
        if eventPlayer.damageOverTimeRemaining < 1:
            eventPlayer.damageOverTimeRemaining = 1


rule "DOWNFALLEN (SIGMA) FIRES":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsDownfallenGrabbing != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 40
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5 * eventPlayer.sizeScale
    
    if not eventPlayer in bossStateList and eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) != true:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    if distance(eventPlayer, eventPlayer.botTarget) < 11 * eventPlayer.sizeScale and not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.1)
        eventPlayer.cancelPrimaryAction()
    wait(2)
    if ruleCondition:
        loop()


rule "DOWNFALLEN GRABS PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= ((2.5 if eventPlayer in bossStateList else 3) * eventPlayer.sizeScale)
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botIsDownfallenGrabbing != true
    @Condition eventPlayer.botTarget.isCrowdControlCooldownActive != true
    @Condition eventPlayer.botIsTeleportConfirmed == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.botAbilityTarget = eventPlayer.botTarget
    eventPlayer.botIsDownfallenGrabbing = true
    eventPlayer.botAbilityTarget.isCrowdControlCooldownActive = true
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setUltCharge(100)
    eventPlayer.botAbilityTarget.attachTo(eventPlayer, vect(0, 3 if eventPlayer in bossStateList else 0, 1))
    eventPlayer.botIsWallPhaseAllowed = false
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.botAbilityTarget.startFacing(directionTowards(eventPlayer.botAbilityTarget.getEyePosition(), vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y - 0.2, eventPlayer.getEyePosition().z)), 999)
    eventPlayer.applyImpulse(vect(0, 5, -3), 5 * eventPlayer.sizeScale, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    waitUntil(not eventPlayer.isUsingUltimate(), 1.25)
    eventPlayer.cancelPrimaryAction()
    if eventPlayer.isCrowdControlled or distance(eventPlayer.getEyePosition(), eventPlayer.botAbilityTarget.getEyePosition()) > 4 * eventPlayer.sizeScale or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead():
        eventPlayer.botAbilityTarget.stopFacing()
        eventPlayer.botAbilityTarget.detach()
    else:
        eventPlayer.forceButtonPress(Button.MELEE)
        eventPlayer.botAbilityTarget.detach()
        eventPlayer.botAbilityTarget.stopFacing()
        eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botAbilityTarget.getPosition())), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botAbilityTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 1.75)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.botAuxiliaryState = null
    eventPlayer.botIsThrottleOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.botIsWallPhaseAllowed = true
    wait(7)
    eventPlayer.botIsDownfallenGrabbing = false
    eventPlayer.botAbilityTarget = false


rule "DOWNFALLEN PULLS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.botTarget.applyImpulse(directionTowards(eventPlayer.botTarget.getEyePosition(), eventPlayer.getEyePosition()), 2, Relativity.TO_WORLD)
    if eventPlayer.botTarget == null or eventPlayer.isInViewAngle(eventPlayer.botTarget.getPosition(), 55) != true or eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) == true:
        eventPlayer.cancelPrimaryAction()
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5.9)


rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT":
    @Event eachPlayer
    @Team 2
    @Hero junkerQueen
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.sizeScale
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.sizeScale
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(20)
    loop()


rule "DAYTAKER (ILLARI) BURST":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 2.5 * eventPlayer.sizeScale) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.isCrowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.botDaytakerCharge = 0
    #charge up attack
    chaseOverTime(eventPlayer.botDaytakerCharge, 2, 2 if eventPlayer in bossStateList else 1, ChaseTimeReeval.NONE)
    #Gather zombies
    eventPlayer.botAbilityTarget = (sorted((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 2.5 * eventPlayer.sizeScale and ((player.getHero() != Hero.ILLARI and player != bossStateList) == true))).exclude(eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    if eventPlayer.botAbilityTarget in bossStateList == true:
        goto lbl_0
    eventPlayer.botAbilityTarget.isAttached = true
    eventPlayer.botAbilityTarget.attachTo(eventPlayer, vect(0, 0.65 * eventPlayer.sizeScale, 0.5 * eventPlayer.sizeScale))
    waitUntil(eventPlayer.isDead() or eventPlayer.botTarget == null or angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 10, 10)
    waitUntil(eventPlayer.isDead() or eventPlayer.isCrowdControlled == true or eventPlayer.botDaytakerCharge >= 2, 99999)
    #Finish charging
    stopChasing(eventPlayer.botDaytakerCharge)
    if eventPlayer.isCrowdControlled == true:
        lbl_0:
        stopChasing(eventPlayer.botDaytakerCharge)
        eventPlayer.botDaytakerCharge = 0
        eventPlayer.botAbilityTarget.detach()
        eventPlayer.botAbilityTarget.isAttached = false
        goto lbl_1
    #Abort
    if eventPlayer.isDead():
        eventPlayer.botDaytakerCharge = 0
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        eventPlayer.botAbilityTarget.isAttached = false
        return
    else:
        chaseOverTime(eventPlayer.botDaytakerCharge, 0, 0.35, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.botDaytakerCharge <= 0, 99999)
    #Abort
    if eventPlayer.isDead():
        eventPlayer.botIsThrottleOverridden = false
        eventPlayer.botIsFacingOverridden = false
        eventPlayer.botAbilityTarget.isAttached = false
        return
    waitUntil(not eventPlayer.isCrowdControlled, 99999)
    eventPlayer.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Eject zombies
    if eventPlayer.isAlive() and eventPlayer.botAbilityTarget.isAlive():
        eventPlayer.botAbilityTarget.detach()
        eventPlayer.botAbilityTarget.isAttached = false
        #Boss Collision
        if eventPlayer in bossStateList:
            eventPlayer.botIsWallPhaseAllowed = false
        eventPlayer.cancelPrimaryAction()
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.2)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.botAbilityTarget.getPosition(), 1.5 * eventPlayer.botAbilityTarget.sizeScale)
        if eventPlayer.botTarget != null:
            eventPlayer.botAbilityTarget.applyImpulse(directionTowards(eventPlayer.botAbilityTarget.getPosition(), eventPlayer.botTarget.getEyePosition() + vect(0, 3 * eventPlayer.botTarget.sizeScale, 0)), 20 + 9 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        else:
            eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), -35), 20 + 9 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.botAbilityTarget = null
    lbl_1:
    wait(0.1)
    #Cooldown
    waitUntil(eventPlayer.getVerticalSpeed() <= 0, 99999)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7 if 0 in bossStateList else 1 if eventPlayer.botTarget.isInAir() else 3)
    #Boss Collision
    if eventPlayer in bossStateList:
        eventPlayer.botIsWallPhaseAllowed = true
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    @Condition eventPlayer.isCrowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    illariUlt()
    wait(10)
    if ruleCondition:
        loop()


rule "TUNNELER (SYMMETRA) BUILDS PORTAL":
    @Event eachPlayer
    @Team 2
    @Hero symmetra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.sizeScale
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.sizeScale
    @Condition eventPlayer.botTarget.isOnGround() == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    abilityPlacement()
    wait(7)


rule "TUNNELER PORTAL LETS ZOMBIES THROUGH":
    @Event eachPlayer
    @Team 2
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.sizeScale
    @Condition eventPlayer in bossStateList == false
    @Condition isHeroBeingPlayed(Hero.SYMMETRA, Team.2) == true
    
    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.25)


rule "CADAVER (ANA) DETONATION":
    @Event eachPlayer
    @Team 2
    @Hero ana
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.sizeScale
    
    waitUntil(not eventPlayer.isMeleeing(), 99999)
    if not ruleCondition:
        return
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.VIOLET, eventPlayer, 0.5 * eventPlayer.sizeScale)
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    abilityThrowdown()
    wait(0.1)
    kill(eventPlayer)


rule "ENSNARER (HAZARD) BLOCKS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition (eventPlayer in bossStateList or not eventPlayer.botAbilityCooldown) == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition eventPlayer.botIsEnsnarerMeleeActive != true
    
    if eventPlayer in bossStateList:
        eventPlayer.disallowButton(Button.MELEE)
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.botIsEnsnarerBlocking = true
        entityFloat()
        for eventPlayer.botEnsnarerTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
            eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTargetList[eventPlayer.botEnsnarerTargetIndex].getPosition()) + vect(0, -0.3, 0), 10000)
            eventPlayer.cancelPrimaryAction()
            wait(0.1)
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            wait(0.5)
            if eventPlayer.isCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
        eventPlayer.botIsFacingOverridden = false
        restoreDefaultFacingMovement()
        eventPlayer.botIsEnsnarerBlocking = false
        eventPlayer.allowButton(Button.MELEE)
        wait(8)
    else:
        eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, -0.3, 0), 999)
        wait(0.25)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        eventPlayer.botAbilityCooldown += 7
        restoreDefaultFacingMovement()


rule "ENSNARER LUNGE":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 30
    @Condition eventPlayer.botTarget.getSpeed() >= 10
    @Condition eventPlayer.botIsEnsnarerMeleeActive != true
    @Condition eventPlayer.botIsEnsnarerBlocking != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(1)


rule "SMOLDER (WINSTON) SEES PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botSmolderState == 0
    @Condition (eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 9 * eventPlayer.sizeScale) == true
    @Condition eventPlayer in bossStateList != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.CROUCH)
    eventPlayer.movementSpeedScale *= 0.1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
    eventPlayer.botSmolderState = 1
    #Death timer
    chaseOverTime(eventPlayer.botSmolderAnger, 0, 6, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.botSmolderState == 2 or eventPlayer.botSmolderAnger <= 0, 99999)
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
    @Condition eventPlayer.isCrowdControlled != true
    
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
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.sizeScale
    
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
        if not eventPlayer.isCrowdControlled and not eventPlayer.hasStatus(Status.HACKED):
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
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 7.5 * eventPlayer.sizeScale)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.getPosition(), 100)
    eventPlayer.botSpecialTargetList = playerTargetList.concat(getLivingPlayers(Team.2)).exclude(eventPlayer).filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.getPosition(), x.getPosition()) < 7.5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getPosition() + losOffsetConst, x.getPosition() + losOffsetConst))
    (eventPlayer.botSpecialTargetList.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getPosition() + losOffsetConst, x.getPosition() + losOffsetConst, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 0.35)
    # smolderShockwaveTargetIndex: shockwave target index, to apply distance-scaled knockback to each affected player.
    #!define smolderShockwaveTargetIndex tmp0
    for smolderShockwaveTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
        eventPlayer.botAbilityTarget = eventPlayer.botSpecialTargetList[smolderShockwaveTargetIndex]
        eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botAbilityTarget.getPosition())), -25), (15 if distance(eventPlayer.getPosition(), eventPlayer.botAbilityTarget.getPosition()) < 5 * eventPlayer.sizeScale else 7.5) * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT":
    @Event eachPlayer
    @Condition isSmolderEventActive == true
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition (eventPlayer in bossStateList or eventPlayer.botSmolderState == 2) == true
    
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
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


rule "PROTECTOR (KIRIKO) USES CLEANSE":
    @Event eachPlayer
    @Team 2
    @Hero kiriko
    @Condition eventPlayer in miniBossList == true
    @Condition (getPlayersInRadius(eventPlayer, 5, Team.2, LosCheck.SURFACES_AND_ENEMY_BARRIERS).any(lambda player: player.isCrowdControlled or player.hasStatus(Status.HACKED) or player.getNormalizedHealth() < 0.5)) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    abilityThrowdown()
    wait(5)


rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE":
    @Event eachPlayer
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isUsingUltimate() == true
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(10)


rule "SUCCESSOR PUNCHES IN RETALIATION":
    @Event playerTookDamage
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(1)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.sizeScale
    @Condition eventPlayer in miniBossList == true
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.JUNKER_QUEEN, Hero.KIRIKO, Hero.DOOMFIST, Hero.HAZARD] == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 2.5)
    wait(0.4)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.stopFacing()
    eventPlayer.setUltCharge(100)
    if eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.botAbilityCooldown += 4
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE if eventPlayer.getHero() == Hero.JUNKER_QUEEN or eventPlayer.getHero() == Hero.KIRIKO else Button.ABILITY_1)
    eventPlayer.botIsFacingOverridden = false
    restoreDefaultFacingMovement()
    eventPlayer.applyImpulse(vect(0, 2.5 if eventPlayer.getHero() in [Hero.DOOMFIST, Hero.HAZARD] else 0, 0), 5 if eventPlayer.getHero() == Hero.HAZARD else 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isDead(), 15 if eventPlayer.getHero() == Hero.DOOMFIST else 30)
    eventPlayer.setUltCharge(0)


rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in miniBossList == true
    @Condition (distance(eventPlayer, currentObjectivePosition) <= objectiveRad or len(objectivePositionList) == 1 and eventPlayer.isOnObjective()) == true
    @Condition eventPlayer.getHero() in [Hero.DOOMFIST, Hero.WRECKING_BALL, Hero.MAUGA] == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setUltCharge(100)
    wait(0.15)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    if not eventPlayer.isUsingUltimate():
        loop()
    if eventPlayer.getHero() == Hero.MAUGA and eventPlayer.isUsingUltimate():
        eventPlayer.setMaxHealth(30)
        wait(1)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    if eventPlayer.getHero() == Hero.DOOMFIST and eventPlayer.isUsingUltimate():
        startRule(selectTarget, StartRuleBehavior.NOOP)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(false)
        waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(true)
    if eventPlayer.getHero() == Hero.MAUGA:
        waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.setMaxHealth(1)
    wait(30)


def abilityThrowdown():
    @Name "abilityThrowdown"
    
    if eventPlayer.hasStatus(Status.HACKED):
        return
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.startFacing(Vector.DOWN, 999)
    wait(0.3)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.allowButton(Button.MELEE)
    restoreDefaultFacingMovement()
    if eventPlayer.getHero() == Hero.HAZARD:
        wait(0.25)
        if eventPlayer.isCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
            return
        (getPlayersInRadius(eventPlayer, 2, Team.2, LosCheck.SURFACES).filter(lambda player: player != eventPlayer)).applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, distance(eventPlayer.botTarget, eventPlayer) * (2 / eventPlayer.sizeScale), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botAbilityCooldown += 2


def entityFloat():
    @Name "entityFloat"
    
    #Entities that will be floated
    eventPlayer.botSpecialTargetList = getLivingPlayers(Team.ALL).filter(lambda player: player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 12 * eventPlayer.sizeScale and isInLoS(player.getPosition() + losOffsetConst, eventPlayer.getPosition() + losOffsetConst, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))


def explosionWarning():
    @Name "explosionWarning"
    
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.sizeScale)
    eventPlayer.explosionScale = eventPlayer.sizeScale
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    wait(0.5)
    eventPlayer.botIsBomberPrimed = false
    if eventPlayer.isDead():
        return
    kill(eventPlayer, eventPlayer)
    explosionSequence()


def smolderBoost():
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1.5 * eventPlayer.sizeScale)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.sizeScale *= 1.5
    eventPlayer.startScalingSize(eventPlayer.sizeScale, false)
    eventPlayer.movementSpeedScale *= 9
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)


def spawnGasCloud():
    eventPlayer.botGasPositionList.append(eventPlayer.botGasProjectilePosition)
    eventPlayer.botGasRadiusList.append(0)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 0.4 * eventPlayer.sizeScale)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 75)
