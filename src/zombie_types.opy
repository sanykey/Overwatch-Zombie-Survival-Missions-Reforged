#!mainFile "main.opy"

subroutine smolderBoost
subroutine spawnGasCloud
subroutine abilityThrowdown
subroutine entityFloat
subroutine explosionWarning


macro smolderEnragedMacro():
    eventPlayer.botTempValue = 2
    stopChasing(eventPlayer.chase1)
    eventPlayer.stopForcingButton(Button.CROUCH)
    smolderBoost()
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "BASIC (REAPER) SHADOW STEP (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reaper
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
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
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(vect(-1, 0, 0), 180, Relativity.TO_PLAYER)
    while eventPlayer.isUsingAbility1():
        entityFloat()
        # tmp0: floated-player index, to push each affected player upward during the shadow-step ability.
        for tmp0 in range(len(eventPlayer.botSpecialPotentialTargets)):
            eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[tmp0]
            if eventPlayer.botSpecialTarget.getPosition().y < eventPlayer.getPosition().y + 4 * eventPlayer.size:
                #Make target float up
                eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.getPosition())), -50), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            else:
                #Push target straight up
                eventPlayer.botSpecialTarget.applyImpulse(vect(0, 1, 0), 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.032)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "BOMBER (JUNKRAT) SELF DESTRUCT":
    @Event eachPlayer
    @Team 2
    @Hero junkrat
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botTempValue = true
    explosionWarning()
    if ruleCondition:
        loop()


rule "RUSHER (TORB) SPEED MECHANICS":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
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
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    while not eventPlayer.isUsingAbility2():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.crowdControlled, 99999)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        wait(0.25)
        if eventPlayer.isDead():
            return
    eventPlayer.addHealthPool(Health.ARMOR, 1000, false)
    eventPlayer.botTempValue = getLastCreatedHealthPool()
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    wait(1)
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionFromAngles(evalOnce(random.uniform(0, 360)), evalOnce(random.uniform(-80, -87))), 0 if eventPlayer.crowdControlled else 144, Relativity.TO_PLAYER)
    while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.crowdControlled, 99999)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.25)
    wait(1)
    while eventPlayer.isUsingUltimate():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.25)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    removeHealthPool(eventPlayer.botTempValue)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero torbjorn
    @Condition eventAbility == Button.ULTIMATE
    
    victim.startDamageOverTime(attacker, 1, eventPlayer.biteDamage * 0.5)
    victim.setStatusEffect(attacker, Status.BURNING, 0.5)
    if victim.damageOverTimeDuration < 0.5:
        victim.damageOverTimeDuration = 0.5


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
    eventPlayer.chase2 = 1.5
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.5)
    chaseAtRate(eventPlayer.chase2, 0, 1, ChaseRateReeval.NONE)
    while eventPlayer.chase2 > 0 and eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0:
        if eventPlayer in bossStateList:
            #Charge Ultimate For Boss Gas Attack
            eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)
            eventPlayer.setStatusEffect(eventPlayer, Status.ROOTED, 0.26)
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3)
        else:
            #Gas Attack
            (playerTargetList.filter(lambda x: isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer.getPosition(), x.getPosition()) < 10 * eventPlayer.size and x.getEyePosition().y - eventPlayer.getPosition().y > 0 and x.getPosition().y - eventPlayer.getPosition().y < 2 * eventPlayer.size)).startDamageOverTime(eventPlayer, 2.5, eventPlayer.biteDamage * 0.231)
            if eventPlayer.damageOverTimeDuration < 2.5:
                eventPlayer.damageOverTimeDuration = 2.5
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
        waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.25)
    #Cooldown
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3 if eventPlayer in bossStateList else 8)
    eventPlayer.chase2 = 0
    stopChasing(eventPlayer.chase2)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    if eventPlayer in bossStateList and eventPlayer.getUltCharge() >= 100:
        eventPlayer.setUltCharge(0)
        eventPlayer.specialThrottling = true
        eventPlayer.stopThrottleInDirection()
        eventPlayer.specialFacing = true
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled or eventPlayer.botTarget == null else 100)
        wait(1)
        waitUntil(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition())) < 5, 5)
        eventPlayer.stopFacing()
        eventPlayer.setStatusEffect(null, Status.STUNNED, 1)
        waitUntil(not eventPlayer.crowdControlled, 2)
        eventPlayer.chase1 = eventPlayer.getEyePosition()
        eventPlayer.botTempValue = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.size, null, getAllPlayers(), false)
        #Launch Gas Projectile
        chaseAtRate(eventPlayer.chase1, eventPlayer.botTempValue, 20 * eventPlayer.size / 3, ChaseRateReeval.NONE)
        eventPlayer.specialFacing = false
        eventPlayer.specialThrottling = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        #Gas Cloud Positions
        eventPlayer.abilityArray1 = []
        #Gas Cloud Areas of Effect
        eventPlayer.abilityArray2 = []
        while distance(eventPlayer.chase1, eventPlayer.botTempValue) > 0.1 and len(eventPlayer.abilityArray1) < 3:
            spawnGasCloud()
            waitUntil(distance(eventPlayer.chase1, eventPlayer.botTempValue) <= 0.1 or len(eventPlayer.abilityArray1) >= 3, 0.9)
        #If projectile hits wall
        if len(eventPlayer.abilityArray1) < 3:
            spawnGasCloud()
        stopChasing(eventPlayer.chase1)
        eventPlayer.chase1 = null
        waitUntil(eventPlayer.isDead(), 3)
        wait(5)
        eventPlayer.abilityArray1 = []
        eventPlayer.abilityArray2 = []
    if ruleCondition:
        loop()


rule "BEHEMOTH GAS STREAM (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition len(eventPlayer.abilityArray1) > 0
    
    eventPlayer.botSpecialPotentialTargets = []
    # tmp0: gas-cloud index, to expand its radius and collect newly hit players.
    for tmp0 in range(len(eventPlayer.abilityArray1)):
        if eventPlayer.abilityArray2[tmp0] < 6 * eventPlayer.size:
            eventPlayer.abilityArray2[tmp0] += 0.2 * eventPlayer.size
        eventPlayer.botSpecialPotentialTargets.append(playerTargetList.filter(lambda x: not x in eventPlayer.botSpecialPotentialTargets and distance(eventPlayer.abilityArray1[tmp0], vect(x.getEyePosition().x, eventPlayer.abilityArray1[tmp0].y, x.getEyePosition().z)) < eventPlayer.abilityArray2[tmp0] and abs(eventPlayer.abilityArray1[tmp0].y - x.getEyePosition().y) < eventPlayer.abilityArray2[tmp0] / 5))
    eventPlayer.botSpecialPotentialTargets.startDamageOverTime(eventPlayer, 2.5, eventPlayer.biteDamage * 0.1)
    if eventPlayer.damageOverTimeDuration < 2.5 and len(eventPlayer.botSpecialPotentialTargets) > 0:
        eventPlayer.damageOverTimeDuration = 2.5
    wait(0.25)
    if ruleCondition:
        loop()


rule "BRUTE (REIN) SUPER SEISMIC SLAM":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition distance(worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget.getPosition()) < 1.5 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    while not eventPlayer.isUsingUltimate():
        wait(0.016, Wait.RESTART_WHEN_TRUE)
        if eventPlayer.isDead():
            return
        if eventPlayer.crowdControlled:
            return
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 20 * eventPlayer.size)
    (getLivingPlayers(Team.ALL).exclude(eventPlayer).filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 20 * eventPlayer.size and distance(worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition()) > 1.5 * eventPlayer.size and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.size)).applyImpulse(vect(0, 1, 0), 15 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3 * eventPlayer.size)
    (null.concat(getLivingPlayers(Team.2)).filter(lambda x: distance(x.getPosition(), worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION)) < 1.5 * eventPlayer.size and not x.hasStatus(Status.KNOCKED_DOWN))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2.5)


rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 5 * eventPlayer.size
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
    eventPlayer.applyImpulse(directionTowards(attacker.getPosition(), eventPlayer.getPosition()) + vect(0, 0.25, 0), 15 * attacker.size, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    if eventPlayer.specialCooldown == true:
        goto lbl_0
    eventPlayer.specialCooldown = true
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
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) > 5 * eventPlayer.size
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
    @Condition (eventPlayer.isOnGround() and eventPlayer.botTarget != null and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 6 * eventPlayer.size and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size and abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20 or eventPlayer.isUsingUltimate()) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.specialFacing = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.canWallPhase = false
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), vect(eventPlayer.botTarget.getEyePosition().x, 10000, eventPlayer.botTarget.getEyePosition().z)), 10000)
    eventPlayer.startForcingButton(Button.CROUCH)
    wait(0.5)
    eventPlayer.stopForcingButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    if not eventPlayer.crowdControlled:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.5)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 10000)
        eventPlayer.cancelPrimaryAction()
        if not eventPlayer.crowdControlled and eventPlayer.botTarget != null:
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            eventPlayer.applyImpulse(normalize(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, 0.25, 0)), eventPlayer.size * (15 + 25 * abs(cosDeg(verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()))))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.specialThrottling = false
            eventPlayer.specialFacing = true
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            eventPlayer.forceButtonPress(Button.ABILITY_1)
    #wait(0.5)
    waitUntil(eventPlayer.isOnGround(), 1)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = true
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(4)
    loop()


rule "REIGNITED ULTIMATE ATTACK COUNTER":
    @Event playerTookDamage
    @Team 2
    @Hero anran
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventPlayer.botTempValue == false
    
    eventPlayer.botTempValue = true
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.setStatusEffect(null, Status.BURNING, 5)
    wait(5)
    eventPlayer.botTempValue = false


rule "REIGNITED USES ULTIMATE NEAR PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isUsingUltimate() == true
    
    if eventPlayer.isOnGround() and getLivingPlayers(Team.1).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 12):
        eventPlayer.botTempvalue2 = true
    wait(0.25)
    eventPlayer.botTempvalue2 = false
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.addHealthPool(Health.ARMOR, 100, false, false)


rule "ZOMBIES SPAWN AT REIGNITED":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.isUsingUltimate() and eventPlayer.getHero() == Hero.ANRAN) != true
    @Condition eventPlayer in bossStateList != true
    @Condition eventPlayer in miniBossList != true
    @Condition len(getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botTempvalue2)) > null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.anranPortal == false
    
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 0.5)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2)
    eventPlayer.setStatusEffect(null, Status.BURNING, 2.3)
    eventPlayer.anranPortalRise = getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botTempvalue2)[0]
    eventPlayer.anranPortal = random.choice(mapGridList.filter(lambda x: distance(eventPlayer.anranPortalRise.getPosition(), x) > 2 and distance(eventPlayer.anranPortalRise.getPosition(), x) < 7))
    eventPlayer.anranPortalRise = eventPlayer.anranPortal - vect(0, 2, 0)
    eventPlayer.startForcingPosition(eventPlayer.anranPortalRise)
    chaseOverTime(eventPlayer.anranPortalRise, eventPlayer.anranPortal, 1.5)
    wait(2)
    eventPlayer.anranPortal = false
    eventPlayer.stopForcingPosition()


rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS":
    @Event playerDealtDamage
    @Team 2
    @Hero widowmaker
    @Condition eventAbility == Button.MELEE
    @Condition victim == eventPlayer.botTarget
    @Condition eventPlayer.attached != true
    @Condition eventPlayer in bossStateList == false
    
    eventPlayer.attached = true
    eventPlayer.botSpecialTarget = victim
    eventPlayer.attachTo(eventPlayer.botSpecialTarget, vect(0, 0, eventPlayer.botSpecialTarget.size))


rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.botSpecialTarget != null
    @Condition (eventPlayer.crowdControlled or eventPlayer.botSpecialTarget.invisible or eventPlayer.isDead() or eventPlayer.botSpecialTarget.isDead() or eventPlayer.botSpecialTarget.hasStatus(Status.PHASED_OUT) or eventPlayer.botSpecialTarget.hasStatus(Status.INVINCIBLE) or not entityExists(eventPlayer.botSpecialTarget)) == true
    
    eventPlayer.botSpecialTarget = null
    eventPlayer.attached = false
    eventPlayer.detach()


rule "RIDER ATTACH TO TEAMMATES":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.isAlive() == true
    #If any valid teammates are within range
    @Condition (getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: not x.teleporting and x.getHero() != Hero.WIDOWMAKER and distance(eventPlayer.getPosition(), x.getPosition()) < 4 * eventPlayer.size)) == true
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) > 20 or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0 and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 7.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botSpecialTarget = (sorted(getLivingPlayers(Team.2).exclude(eventPlayer).filter(lambda x: not x.teleporting and x.getHero() != eventPlayer.getHero()), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    eventPlayer.attachTo(eventPlayer.botSpecialTarget, eventPlayer.botSpecialTarget.size * vect(random.uniform(-0.5, 0.5), 0.25, -0.75))
    eventPlayer.attached = true


rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botSpecialTarget.getTeam() == Team.2
    @Condition (eventPlayer.teleporting or eventPlayer.botSpecialTarget.teleporting or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 3 or eventPlayer.botTarget.isOnGround() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 10) == true
    
    eventPlayer.botSpecialTarget = null
    eventPlayer.attached = false
    eventPlayer.detach()


rule "RIDER USE GRAPPLING HOOK":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.botTarget.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5
    
    eventPlayer.specialFacing = true
    eventPlayer.botTempValue = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition(), null, eventPlayer, false)
    eventPlayer.stopFacing()
    waitUntil(not eventPlayer.crowdControlled, 2)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTempValue), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    wait(0.25)
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 4 or distance(eventPlayer.getPosition(), eventPlayer.botTempValue) < 3.5, 3)
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
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 5 or verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition())) > -35) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.canWallPhase = false
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled else 100)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(vect(0, 0, -1), 0.35, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Charger walk backwards duration
    for eventPlayer.pNoCooldownsCount_bCount2 in range(0, 1, 0.064):
        if eventPlayer.crowdControlled or eventPlayer.isDead():
            eventPlayer.specialFacing = false
            eventPlayer.specialThrottling = false
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            return
        wait(0.064)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() if eventPlayer.botTempValue == null else eventPlayer.botTempValue), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    #Charge End
    waitUntil(not eventPlayer.isUsingAbility1(), 2 if eventPlayer in bossStateList else 3.5)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4 if eventPlayer in bossStateList else 6)


rule "CHARGER KNOCKBACK":
    @Event playerDealtDamage
    @Team 2
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    #Damage players
    damage(victim, eventPlayer, eventPlayer.biteDamage * 0.75)
    if not eventPlayer.isUsingAbility1():
        return
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)


rule "SLIMER (MERCY) TENTACLE GRAB":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    wait(0.016 if eventPlayer.isUsingUltimate() else 0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botSpecialTarget = null
    eventPlayer.chase1 = eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition()
    eventPlayer.botTempValue = eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.size
    #Tentacle extends
    chaseAtRate(eventPlayer.chase1, eventPlayer.botTempValue, 50)
    wait()
    while eventPlayer.isAlive() and not eventPlayer.crowdControlled and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTempValue, getLivingPlayers(Team.1), getAllPlayers(), true)) > distance(eventPlayer.getEyePosition(), eventPlayer.chase1):
        if playerTargetList.any(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.chase1, x.getEyePosition()) < 1 and isInLoS(eventPlayer.chase1, x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)):
            eventPlayer.botSpecialTarget = (playerTargetList.filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.chase1, x.getEyePosition()) < 1 and isInLoS(eventPlayer.chase1, eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)))[0]
            eventPlayer.botTempValue = eventPlayer.botSpecialTarget.getEyePosition()
            break
        wait(0.032)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.chase1, 0.25)
    #Tentacle retract
    chaseAtRate(eventPlayer.chase1, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition(), 50)
    if eventPlayer.isAlive() and not eventPlayer.crowdControlled and eventPlayer.botSpecialTarget != null:
        #Knocks target down if facing away from Mercy
        if abs(angleDifference(eventPlayer.botSpecialTarget.getHorizontalFacingAngle(), horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())))) < 75:
            eventPlayer.botSpecialTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 0.35)
        eventPlayer.botSpecialTarget.setGravity(0)
        eventPlayer.botSpecialTarget.applyImpulse(directionTowards(eventPlayer.botSpecialTarget.getEyePosition(), eventPlayer.getEyePosition()), eventPlayer.size * (15 if eventPlayer.botSpecialTarget.getMaxHealth() < 400 else 10), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.35)
        eventPlayer.botSpecialTarget.setGravity(100)
    while (distance(eventPlayer.chase1, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition())) > 0.25:
        wait(0.25)
    eventPlayer.botTempValue = null
    stopChasing(eventPlayer.chase1)
    #Lower cooldown for ulting boss if they do not hit a target
    if eventPlayer in bossStateList and eventPlayer.isUsingUltimate():
        wait(0.25)
    else:
        eventPlayer.specialThrottling = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(2.25 if eventPlayer.botTarget.isInAir() else 4.5)
    if ruleCondition:
        loop()


rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero emre
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == null
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.specialThrottling = true
    while not eventPlayer.isJumping():
        eventPlayer.wallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        eventPlayer.forceButtonPress(Button.JUMP)
        waitUntil(eventPlayer.isJumping(), 1)
    eventPlayer.applyImpulse(vect(0, 1, 0), random.uniform(6, 10) * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    waitUntil(eventPlayer.getVelocity().y < 0, 3)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.BLACK, eventPlayer, 5 * eventPlayer.size)
    while eventPlayer.isUsingUltimate():
        eventPlayer.specialThrottling = true
        eventPlayer.specialFacing = true
        eventPlayer.stopThrottleInDirection()
        while eventPlayer.botTarget != null and eventPlayer.isUsingUltimate() and not eventPlayer.crowdControlled:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1), 0 if eventPlayer.crowdControlled else 200)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
            #Altitude too low
            if eventPlayer.getAltitude() < 3:
                eventPlayer.wallCollisionEnabled = true
                eventPlayer.enableEnvironmentCollision()
                eventPlayer.forceButtonPress(Button.JUMP)
            #Entities that will be floated
            entityFloat()
            # tmp0: floated-player index, to lift low targets and push higher targets away during flight.
            for tmp0 in range(len(eventPlayer.botSpecialPotentialTargets)):
                eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[tmp0]
                if eventPlayer.botSpecialTarget.getPosition().y < eventPlayer.getPosition().y:
                    #Make target float up
                    eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.getPosition())), -75), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                else:
                    #Push target away
                    eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), -20), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            wait(0.032)
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(0.25)
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(10)
    if ruleCondition:
        loop()


rule "STRIKER (WRECKING BALL) PILE DRIVER":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.getAbilityCooldown(Button.CROUCH) <= 0
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (eventPlayer.getAltitude() > 3 or eventPlayer.isOnGround() and isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + vect(0, 3, 0))) == true
    
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.botTempValue = true
    eventPlayer.canWallPhase = false
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.enableEnvironmentCollision()
    if eventPlayer.isOnGround():
        while not eventPlayer.isJumping():
            eventPlayer.forceButtonPress(Button.JUMP)
            waitUntil(eventPlayer.isJumping(), 1)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 4 * eventPlayer.size)
        eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, 10 * eventPlayer.size, 0)), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.25)
        waitUntil(eventPlayer.getVelocity().y <= 0, 3)
    eventPlayer.forceButtonPress(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.crowdControlled, 5)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 3)
    eventPlayer.botTempValue = null
    eventPlayer.canWallPhase = true


rule "STRIKER CANCEL BALL FORM":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.specialThrottling == false
    
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
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), 0), 7.5 * eventPlayer.size, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "STALKER (MOIRA) FADE":
    @Event eachPlayer
    @Team 2
    @Hero moira
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 45
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialFacing = true
    eventPlayer.disablePlayerCollision()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isUsingUltimate() else 75 if eventPlayer.isUsingAbility1() else 1500)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    for eventPlayer.pForceFieldCount2_bCount1 in range(5 if eventPlayer in bossStateList else 3):
        eventPlayer.canWallPhase = false
        eventPlayer.wallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        #Final fade
        if eventPlayer.pForceFieldCount2_bCount1 >= 2 and not eventPlayer in bossStateList:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled else 100)
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()), 0 if distance(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()) < 3 and eventPlayer.isUsingAbility1() else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
        eventPlayer.movementSpeed *= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.125)
        waitUntil(not eventPlayer.isUsingAbility1(), 2)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.movementSpeed /= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        if eventPlayer.isDead() or eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
            break
        if eventPlayer in bossStateList:
            wait(0.125)
            eventPlayer.setUltCharge(100)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
            waitUntil(not eventPlayer.isUsingUltimate(), 1.3)
            eventPlayer.cancelPrimaryAction()
        else:
            eventPlayer.canWallPhase = true
            wait(0.75)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10 if eventPlayer in bossStateList else 5)


rule "STALKER KNOCKBACK BLAST (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero moira
    @Condition eventAbility == Button.ULTIMATE
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), -25), 10 * attacker.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        victim.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)


rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":
    @Event eachPlayer
    @Team 2
    @Hero pharah
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.chase1 = 0
    eventPlayer.setDamageReceived(50)
    #charge up attack
    chaseOverTime(eventPlayer.chase1, 2, 1 if eventPlayer.botTarget.isInAir() else 2, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 >= 2, 99999)
    stopChasing(eventPlayer.chase1)
    if eventPlayer.isDead():
        eventPlayer.setDamageReceived(100)
        eventPlayer.chase1 = 0
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        return
    else:
        #charge up attack
        chaseOverTime(eventPlayer.chase1, 0, 0.25, ChaseTimeReeval.NONE)
    eventPlayer.setDamageReceived(100)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 <= 0, 99999)
    if eventPlayer.isDead():
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        return
    if isInLoS(eventPlayer.getPosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)) and isInLoS(eventPlayer.lastTarget.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)):
        waitUntil(not eventPlayer.crowdControlled, 99999)
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
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "BLASTER ROCKET HITS TARGET":
    @Event playerDealtDamage
    @Team 2
    @Hero pharah
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ULTIMATE) == true
    
    if eventAbility == Button.ULTIMATE:
        victim.startDamageOverTime(eventPlayer, 2, eventPlayer.biteDamage * 0.5)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
        if eventPlayer.damageOverTimeDuration < 2:
            eventPlayer.damageOverTimeDuration = 2
    elif eventAbility == Button.PRIMARY_FIRE:
        victim.startDamageOverTime(eventPlayer, 1, eventPlayer.biteDamage)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 1)
        if eventPlayer.damageOverTimeDuration < 1:
            eventPlayer.damageOverTimeDuration = 1


rule "DOWNFALLEN (SIGMA) FIRES":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.botTempValue != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 40
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5 * eventPlayer.size
    
    if not eventPlayer in bossStateList and eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) != true:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    if distance(eventPlayer, eventPlayer.botTarget) < 11 * eventPlayer.size and not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
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
    @Condition eventPlayer.crowdControlled != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= ((2.5 if eventPlayer in bossStateList else 3) * eventPlayer.size)
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botTempValue != true
    @Condition eventPlayer.botTarget.specialCooldown != true
    @Condition eventPlayer.successfullyTeleported == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.botSpecialTarget = eventPlayer.botTarget
    eventPlayer.botTempValue = true
    eventPlayer.botSpecialTarget.specialCooldown = true
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setUltCharge(100)
    eventPlayer.botSpecialTarget.attachTo(eventPlayer, vect(0, 3 if eventPlayer in bossStateList else 0, 1))
    eventPlayer.canWallPhase = false
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.botSpecialTarget.startFacing(directionTowards(eventPlayer.botSpecialTarget.getEyePosition(), vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y - 0.2, eventPlayer.getEyePosition().z)), 999)
    eventPlayer.applyImpulse(vect(0, 5, -3), 5 * eventPlayer.size, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    waitUntil(not eventPlayer.isUsingUltimate(), 1.25)
    eventPlayer.cancelPrimaryAction()
    if eventPlayer.crowdControlled or distance(eventPlayer.getEyePosition(), eventPlayer.botSpecialTarget.getEyePosition()) > 4 * eventPlayer.size or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead():
        eventPlayer.botSpecialTarget.stopFacing()
        eventPlayer.botSpecialTarget.detach()
    else:
        eventPlayer.forceButtonPress(Button.MELEE)
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.stopFacing()
        eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botSpecialTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 1.75)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.botTempvalue2 = null
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    wait(7)
    eventPlayer.botTempValue = false
    eventPlayer.botSpecialTarget = false


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
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(20)
    loop()


rule "DAYTAKER (ILLARI) BURST":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 2.5 * eventPlayer.size) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.chase1 = 0
    #charge up attack
    chaseOverTime(eventPlayer.chase1, 2, 2 if eventPlayer in bossStateList else 1, ChaseTimeReeval.NONE)
    #Gather zombies
    eventPlayer.botSpecialTarget = (sorted((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 2.5 * eventPlayer.size and ((player.getHero() != Hero.ILLARI and player != bossStateList) == true))).exclude(eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    if eventPlayer.botSpecialTarget in bossStateList == true:
        goto lbl_0
    eventPlayer.botSpecialTarget.attached = true
    eventPlayer.botSpecialTarget.attachTo(eventPlayer, vect(0, 0.65 * eventPlayer.size, 0.5 * eventPlayer.size))
    waitUntil(eventPlayer.isDead() or eventPlayer.botTarget == null or angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 10, 10)
    waitUntil(eventPlayer.isDead() or eventPlayer.crowdControlled == true or eventPlayer.chase1 >= 2, 99999)
    #Finish charging
    stopChasing(eventPlayer.chase1)
    if eventPlayer.crowdControlled == true:
        lbl_0:
        stopChasing(eventPlayer.chase1)
        eventPlayer.chase1 = 0
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.attached = false
        goto lbl_1
    #Abort
    if eventPlayer.isDead():
        eventPlayer.chase1 = 0
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        eventPlayer.botSpecialTarget.attached = false
        return
    else:
        chaseOverTime(eventPlayer.chase1, 0, 0.35, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 <= 0, 99999)
    #Abort
    if eventPlayer.isDead():
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        eventPlayer.botSpecialTarget.attached = false
        return
    waitUntil(not eventPlayer.crowdControlled, 99999)
    eventPlayer.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Eject zombies
    if eventPlayer.isAlive() and eventPlayer.botSpecialTarget.isAlive():
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.attached = false
        #Boss Collision
        if eventPlayer in bossStateList:
            eventPlayer.canWallPhase = false
        eventPlayer.cancelPrimaryAction()
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.2)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.botSpecialTarget.getPosition(), 1.5 * eventPlayer.botSpecialTarget.size)
        if eventPlayer.botTarget != null:
            eventPlayer.botSpecialTarget.applyImpulse(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.botTarget.getEyePosition() + vect(0, 3 * eventPlayer.botTarget.size, 0)), 20 + 9 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        else:
            eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), -35), 20 + 9 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.botSpecialTarget = null
    lbl_1:
    wait(0.1)
    #Cooldown
    waitUntil(eventPlayer.getVerticalSpeed() <= 0, 99999)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7 if 0 in bossStateList else 1 if eventPlayer.botTarget.isInAir() else 3)
    #Boss Collision
    if eventPlayer in bossStateList:
        eventPlayer.canWallPhase = true
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    @Condition eventPlayer.crowdControlled == false
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
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    @Condition eventPlayer.botTarget.isOnGround() == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    abilityPlacement()
    wait(7)


rule "TUNNELER PORTAL LETS ZOMBIES THROUGH":
    @Event eachPlayer
    @Team 2
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition eventPlayer in bossStateList == false
    @Condition isHeroBeingPlayed(Hero.SYMMETRA, Team.2) == true
    
    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.25)


rule "CADAVER (ANA) DETONATION":
    @Event eachPlayer
    @Team 2
    @Hero ana
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.size
    
    waitUntil(not eventPlayer.isMeleeing(), 99999)
    if not ruleCondition:
        return
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.VIOLET, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    abilityThrowdown()
    wait(0.1)
    kill(eventPlayer)


rule "ENSNARER (HAZARD) BLOCKS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition (eventPlayer in bossStateList or not eventPlayer.abilityArray1) == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition eventPlayer.botTempvalue2 != true
    
    if eventPlayer in bossStateList:
        eventPlayer.disallowButton(Button.MELEE)
        eventPlayer.specialFacing = true
        eventPlayer.botTempValue = true
        entityFloat()
        for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.botSpecialPotentialTargets)):
            eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialPotentialTargets[eventPlayer.pForceFieldCount2_bCount1].getPosition()) + vect(0, -0.3, 0), 10000)
            eventPlayer.cancelPrimaryAction()
            wait(0.1)
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            wait(0.5)
            if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
        eventPlayer.specialFacing = false
        restoreDefaultFacingMovement()
        eventPlayer.botTempValue = false
        eventPlayer.allowButton(Button.MELEE)
        wait(8)
    else:
        eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, -0.3, 0), 999)
        wait(0.25)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        eventPlayer.abilityArray1 += 7
        restoreDefaultFacingMovement()


rule "ENSNARER LUNGE":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 30
    @Condition eventPlayer.botTarget.getSpeed() >= 10
    @Condition eventPlayer.botTempvalue2 != true
    @Condition eventPlayer.botTempValue != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(1)


rule "SMOLDER (WINSTON) SEES PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == 0
    @Condition (eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 9 * eventPlayer.size) == true
    @Condition eventPlayer in bossStateList != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.CROUCH)
    eventPlayer.movementSpeed *= 0.1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    eventPlayer.botTempValue = 1
    #Death timer
    chaseOverTime(eventPlayer.chase1, 0, 6, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.botTempValue == 2 or eventPlayer.chase1 <= 0, 99999)
    if eventPlayer.botTempValue == 2:
        return
    stopChasing(eventPlayer.chase1)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer, 1.5 * eventPlayer.size)
    wait(0.25)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    kill(eventPlayer)


rule "SMOLDER ACTIVATES FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Hero winston
    @Condition eventPlayer in bossStateList != true
    @Condition eventPlayer.botTempValue == 1
    @Condition eventPlayer.crowdControlled != true
    
    eventPlayer.botTempValue = 2
    stopChasing(eventPlayer.chase1)
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), attacker.getEyePosition()), 9999)
    eventPlayer.lastTarget = attacker
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
    @Condition eventPlayer.botTempValue == 0
    @Condition isSmolderEventActive != true
    @Condition eventPlayer.lastTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.5)
    eventPlayer.startFacing(eventPlayer.getFacingDirection() + Vector.UP, 300)
    wait(0.6)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 0.25)
    if eventPlayer.isUsingAbility1() == true:
        restoreDefaultFacingMovement()
        eventPlayer.botTempValue = 1
        eventPlayer.enableEnvironmentCollision()
        waitUntil(not eventPlayer.isUsingAbility1(), 1)
        if not eventPlayer.crowdControlled and not eventPlayer.hasStatus(Status.HACKED):
            eventPlayer.applyImpulse(Vector.DOWN, 4, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            waitUntil(eventPlayer.isOnGround(), 2)
    wait(0.25)
    eventPlayer.botTempValue = 0
    wait(4)


rule "SMOLDER SUPER SLAM":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTempValue != 0
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bossStateList == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 7.5 * eventPlayer.size)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.getPosition(), 100)
    eventPlayer.botSpecialPotentialTargets = playerTargetList.concat(getLivingPlayers(Team.2)).exclude(eventPlayer).filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.getPosition(), x.getPosition()) < 7.5 * eventPlayer.size and isInLoS(eventPlayer.getPosition() + losOffsetConst, x.getPosition() + losOffsetConst))
    (eventPlayer.botSpecialPotentialTargets.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 5 * eventPlayer.size and isInLoS(eventPlayer.getPosition() + losOffsetConst, x.getPosition() + losOffsetConst, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 0.35)
    # tmp0: shockwave target index, to apply distance-scaled knockback to each affected player.
    for tmp0 in range(len(eventPlayer.botSpecialPotentialTargets)):
        eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[tmp0]
        eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), -25), (15 if distance(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition()) < 5 * eventPlayer.size else 7.5) * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT":
    @Event eachPlayer
    @Condition isSmolderEventActive == true
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition (eventPlayer in bossStateList or eventPlayer.botTempValue == 2) == true
    
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
    @Condition eventPlayer.botTempValue == 1
    @Condition isSmolderEventActive == true
    @Condition eventPlayer in bossStateList != true
    
    smolderEnragedMacro()


rule "PROTECTOR (KIRIKO) USES CLEANSE":
    @Event eachPlayer
    @Team 2
    @Hero kiriko
    @Condition eventPlayer in miniBossList == true
    @Condition (getPlayersInRadius(eventPlayer, 5, Team.2, LosCheck.SURFACES_AND_ENEMY_BARRIERS).any(lambda player: player.crowdControlled or player.hasStatus(Status.HACKED) or player.getNormalizedHealth() < 0.5)) == true
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
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    @Condition eventPlayer in miniBossList == true
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.JUNKER_QUEEN, Hero.KIRIKO, Hero.DOOMFIST, Hero.HAZARD] == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 2.5)
    wait(0.4)
    eventPlayer.specialFacing = true
    eventPlayer.stopFacing()
    eventPlayer.setUltCharge(100)
    if eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.abilityArray1 += 4
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE if eventPlayer.getHero() == Hero.JUNKER_QUEEN or eventPlayer.getHero() == Hero.KIRIKO else Button.ABILITY_1)
    eventPlayer.specialFacing = false
    restoreDefaultFacingMovement()
    eventPlayer.applyImpulse(vect(0, 2.5 if eventPlayer.getHero() in [Hero.DOOMFIST, Hero.HAZARD] else 0, 0), 5 if eventPlayer.getHero() == Hero.HAZARD else 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isDead(), 15 if eventPlayer.getHero() == Hero.DOOMFIST else 30)
    eventPlayer.setUltCharge(0)


rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in miniBossList == true
    @Condition (distance(eventPlayer, objectivePositionList[0]) <= objectiveRad or len(objectivePositionList) == 1 and eventPlayer.isOnObjective()) == true
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
        if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
            return
        (getPlayersInRadius(eventPlayer, 2, Team.2, LosCheck.SURFACES).filter(lambda player: player != eventPlayer)).applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, distance(eventPlayer.botTarget, eventPlayer) * (2 / eventPlayer.size), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.abilityArray1 += 2


def entityFloat():
    @Name "entityFloat"
    
    #Entities that will be floated
    eventPlayer.botSpecialPotentialTargets = getLivingPlayers(Team.ALL).filter(lambda player: player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 12 * eventPlayer.size and isInLoS(player.getPosition() + losOffsetConst, eventPlayer.getPosition() + losOffsetConst, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))


def explosionWarning():
    @Name "explosionWarning"
    
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.explosionSize = eventPlayer.size
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    wait(0.5)
    eventPlayer.botTempValue = false
    if eventPlayer.isDead():
        return
    kill(eventPlayer, eventPlayer)
    explosionSequence()


def smolderBoost():
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1.5 * eventPlayer.size)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.size *= 1.5
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.movementSpeed *= 9
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


def spawnGasCloud():
    eventPlayer.abilityArray1.append(eventPlayer.chase1)
    eventPlayer.abilityArray2.append(0)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.chase1, 0.4 * eventPlayer.size)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.chase1, 75)
