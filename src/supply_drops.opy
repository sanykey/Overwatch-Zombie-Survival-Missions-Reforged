#!mainFile "main.opy"

subroutine powerUpUsage
subroutine playerForceField
subroutine noCooldowns
subroutine airStrike
subroutine instantRevive
subroutine healBeacon
subroutine sentryTurret
subroutine cloakingDevice
subroutine superNano
subroutine bouncePad
subroutine ultimateCharger
subroutine stun


rule "GENERATE SUPPLY DROPS":
    #Only activates if last supply drop has been opened
    @Condition supplyDropStatus == true
    #Waits for all objectives to be determined before activating
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    #Limited to 12 power ups on the ground at a time
    @Condition len(powerUpPositions) < 12
    
    #Standard 30 second wait
    wait(30)
    supplyDropLanding = null
    supplyDropPosition = null
    supplyDropStatus = false
    #Wait standard minimum 30 seconds + a random 30 to 90 extra seconds. Total resulting wait time is 2 to 2.5 minutes.
    wait(random.uniform(1.5, 2) * 60)
    while supplyDropLanding == null:
        #Find the closest player to the objective
        closestPlayerToObjective = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositions[0]))[0]
        testPos = random.choice(mapGrid.filter(lambda x: distance(closestPlayerToObjective.getPosition(), x) < 35 and distance(closestPlayerToObjective.getPosition(), x) > 20))
        if playerTargetList.all(lambda x: distance(testPos, x.getPosition()) > 20):
            #Sets supply drop location
            supplyDropLanding = testPos
            #Sets supply drop location to be placed on ground (in the case that a walkable position is underground for some reason)
            supplyDropLanding = raycastHitPosition(supplyDropLanding + vect(0, 2, 0), supplyDropLanding + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)
        wait(0.25)
    supplyDropPosition = supplyDropLanding + vect(0, 200, 0)
    chaseOverTime(supplyDropPosition, supplyDropLanding, 15)
    bigMessage(getPlayers(Team.1), "Supply drop incoming!")
    waitUntil(supplyDropPosition == supplyDropLanding, 99999)
    stopChasing(supplyDropPosition)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, supplyDropLanding, 4)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, supplyDropLanding, 50)
    wait(10, Wait.RESTART_WHEN_TRUE)
    if len(powerUpPositions) < 12:
        loop()


rule "EFFECT/TEXT (GLOBAL)":
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    
    #Closed supply drop orb
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and not supplyDropStatus), Effect.ORB, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Falling supply drop aura
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and supplyDropPosition != null and distance(supplyDropLanding, supplyDropPosition) > 1), Effect.BAD_AURA, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop sphere
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and supplyDropStatus), Effect.SPHERE, Color.AQUA, supplyDropPosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Supply drop landing ring
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null), Effect.RING, Color.AQUA, supplyDropLanding, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop text
    createInWorldText(getLivingPlayers(Team.1).filter(lambda player: supplyDropLanding != null and distance(supplyDropLanding, supplyDropPosition) < 1 and not supplyDropStatus and distance(player.getPosition(), supplyDropLanding) <= 6 and distance(supplyDropLanding, player.getEyePosition() + player.getFacingDirection() * distance(player.getEyePosition(), supplyDropLanding)) < 0.5), "[{0}]".format(inputBindingString(Button.INTERACT)), supplyDropPosition + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    #Pick up power up text
    createInWorldText(localPlayer if len(powerUpPositions.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6)) else null, "[{0}]".format(inputBindingString(Button.INTERACT)), vect(0, 0.5, 0) + ((sorted(powerUpPositions.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x))))[0]), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    #Supply drop landing icon
    createIcon(getAllPlayers().filter(lambda player: supplyDropLanding != null and distance(player.getPosition(), supplyDropPosition) > 5), supplyDropPosition + vect(0, 1, 0), Icon.PLUS, IconReeval.VISIBILITY_AND_POSITION, Color.AQUA)
    #Supply drop distance
    createInWorldText(getAllPlayers().filter(lambda player: supplyDropLanding != null and distance(player.getPosition(), supplyDropPosition) > 5), "Supply Drop: {0}m".format(distance(localPlayer.getPosition(), supplyDropPosition)), supplyDropPosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.NEVER)


rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition gameStatus == true
    @Condition eventPlayer.isDummy() == false
    
    if distance(supplyDropLanding, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), supplyDropLanding)) < 0.5 and not supplyDropStatus and distance(eventPlayer.getPosition(), supplyDropLanding) <= 6 and supplyDropLanding != null and distance(supplyDropLanding, supplyDropPosition) < 1:
        supplyDropStatus = true
        playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, supplyDropPosition, 0.5)
        playEffect(getPlayers(Team.1), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, supplyDropPosition, 50)
        #Power ups per supply drop
        for count1 in range(numberOfPowerUpsPerSupplyDrop):
            #Range of power ups
            powerUpIDs.append(random.choice(availablePowerups))
        #Spacing of power ups
        for eventPlayer.pPowerUpCount_bTeleCount in range(-60, 61, 120 / (numberOfPowerUpsPerSupplyDrop - 1)):
            powerUpPositions.append(supplyDropLanding + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(supplyDropLanding, eventPlayer.getPosition())) + eventPlayer.pPowerUpCount_bTeleCount, 0)) * 2))
    elif len(powerUpPositions) > 0 and ((len(powerUpPositions.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6))) > 0):
        #Power up effect position
        eventPlayer.powerUpTradeValues[0] = (sorted(powerUpPositions.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x))))[0]
        #Current power up (or 0 if no current power up)
        eventPlayer.powerUpTradeValues[2] = eventPlayer.currentPowerUp
        wait()
        #Index of position of current power up being aquired
        eventPlayer.powerUpTradeValues[1] = powerUpPositions.index(eventPlayer.powerUpTradeValues[0])
        wait()
        #Pick up power up
        eventPlayer.currentPowerUp = powerUpIDs[eventPlayer.powerUpTradeValues[1]]
        destroyEffect(powerUpEffect[eventPlayer.powerUpTradeValues[1]])
        destroyInWorldText(powerUpText[eventPlayer.powerUpTradeValues[1]])
        wait()
        del powerUpIDs[eventPlayer.powerUpTradeValues[1]]
        del powerUpPositions[eventPlayer.powerUpTradeValues[1]]
        del powerUpEffect[eventPlayer.powerUpTradeValues[1]]
        del powerUpText[eventPlayer.powerUpTradeValues[1]]
        wait()
        #Trade power ups. Ignore if no power up is currently held.
        if eventPlayer.powerUpTradeValues[2] != 0:
            powerUpIDs.append(eventPlayer.powerUpTradeValues[2])
            powerUpPositions.append(eventPlayer.powerUpTradeValues[0])
    elif eventPlayer.currentPowerUp != 0:
        wait(0.25, Wait.ABORT_WHEN_FALSE)
        powerUpUsage()


def instantRevive():
    @Name "instantRevive (0-9)"
    
    eventPlayer.interactEntity = (sorted(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= reviveRadius), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getPosition()))))[0]
    wait()
    eventPlayer.interactEntity.setStatusEffect(null, Status.INVINCIBLE, 5)
    eventPlayer.interactEntity.resurrect()
    waitUntil(eventPlayer.interactEntity.isAlive(), 3)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    smallMessage([eventPlayer, eventPlayer.interactEntity], "{0} {1}: \"I've got you. Now let's move!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))


def playerForceField():
    @Name "playerForceField (10-19)"
    
    eventPlayer.powerUpUsePositionsAndInfo[10] = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEffects[10]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 7.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[10] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Force Field: {0}s".format(ceil(eventPlayer.pForceFieldCount1)), HudPosition.RIGHT, 0.2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[11] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 50)
    #Force field duration
    for eventPlayer.pForceFieldCount1 in range(10, 0, -0.032):
        for eventPlayer.pForceFieldCount2_bCount1 in range(getNumberOfLivingPlayers(Team.2)):
            if distance(getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1], eventPlayer.powerUpUsePositionsAndInfo[10]) <= 7.5:
                getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1].applyImpulse(directionTowards(eventPlayer.powerUpUsePositionsAndInfo[10], getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1].getPosition()), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpEffects[10])
    destroyHudText(eventPlayer.powerUpEffects[11])
    eventPlayer.powerUpUsePositionsAndInfo[10] = 0


def noCooldowns():
    @Name "noCooldowns (20-29)"
    
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer, 50)
    if eventPlayer.powerUpEffects[20] == 0:
        hudHeader(eventPlayer, "No Cooldowns: {0}s".format(ceil(eventPlayer.pNoCooldownsCount_bCount2)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[20] = getLastCreatedText()
    #No cooldown powerup duration
    for eventPlayer.pNoCooldownsCount_bCount2 in range(15, 0, -0.032):
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.INTERACT, 0)
        eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
        eventPlayer.setAbilityCooldown(Button.JUMP, 0)
        eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
        if eventPlayer.getHero() == Hero.REAPER:
            goto lbl_0
        eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
        lbl_0:
        eventPlayer.setAbilityCharge(Button.SECONDARY_FIRE, 2)
        eventPlayer.setAbilityCooldown(Button.RELOAD, 0)
        wait(0.032)
    destroyHudText(eventPlayer.powerUpEffects[20])
    eventPlayer.powerUpEffects[20] = 0


def airStrike():
    @Name "airStrike (30-39)"
    
    wait()
    smallMessage(getAllPlayers(), "{0} {1}: \"I've called in an air strike!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    #Air Strike Location
    eventPlayer.powerUpUsePositionsAndInfo[30] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 40, null, getAllPlayers(), false)
    eventPlayer.pAirStrikeCount = 0
    if eventPlayer.powerUpEffects[30] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer.powerUpUsePositionsAndInfo[30], 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[30] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, eventPlayer.powerUpUsePositionsAndInfo[30], 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[31] = getLastCreatedEntity()
    wait(2)
    #Count up to max radius. Number of explosions = Max radius / step size
    for eventPlayer.pAirStrikeCount in range(50):
        #Random position in ring
        eventPlayer.powerUpUsePositionsAndInfo[31] = eventPlayer.powerUpUsePositionsAndInfo[30] + vect(0, 5, 0) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(0, 10)
        #Ray Cast downwards
        eventPlayer.powerUpUsePositionsAndInfo[31] = raycastHitPosition(eventPlayer.powerUpUsePositionsAndInfo[31], eventPlayer.powerUpUsePositionsAndInfo[31] + vect(0, -25, 0), null, getAllPlayers(), false)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 2.5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 100)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 100)
        eventPlayer.powerUpUsePositionsAndInfo[32] = getPlayers(Team.2).filter(lambda player: distance(player.getPosition(), eventPlayer.powerUpUsePositionsAndInfo[31]) < 5)
        damage(eventPlayer.powerUpUsePositionsAndInfo[32], eventPlayer, 150)
        eventPlayer.powerUpUsePositionsAndInfo[32].reviveTimer = 10
        wait(0.125)
    destroyEffect(eventPlayer.powerUpEffects[30])
    destroyEffect(eventPlayer.powerUpEffects[31])
    eventPlayer.powerUpEffects[30] = 0


def healBeacon():
    @Name "beaconofHealing (40-49)"
    
    eventPlayer.powerUpUsePositionsAndInfo[40] = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEffects[40]):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40] + vect(0, -2, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[40] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40], 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[41] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Beacon of Healing: {0}s".format(ceil(eventPlayer.pHealBeaconCount)), HudPosition.RIGHT, 0.2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[42] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.9, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[43] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40], 10)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[40], 50)
    eventPlayer.setHealingDealt(150)
    #Heal Beacon duration
    for eventPlayer.pHealBeaconCount in range(30, 0, -1):
        wait(1)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40] + vect(0, 1, 0), 0.1)
        getPlayersInRadius(eventPlayer.powerUpUsePositionsAndInfo[40], 10, eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 2, 30)
    destroyEffect(eventPlayer.powerUpEffects[40])
    destroyEffect(eventPlayer.powerUpEffects[41])
    destroyHudText(eventPlayer.powerUpEffects[42])
    destroyEffect(eventPlayer.powerUpEffects[43])
    eventPlayer.setHealingDealt(100)
    eventPlayer.powerUpUsePositionsAndInfo[40] = 0


def sentryTurret():
    @Name "sentryTurret (50-59)"
    
    eventPlayer.powerUpUsePositionsAndInfo[50] = eventPlayer.getPosition() + Vector.UP if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()) + Vector.UP
    if not entityExists(eventPlayer.powerUpEffects[50]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50], 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[50] = getLastCreatedEntity()
        for I in range(3):
            createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionFromAngles(evalOnce(I) * 120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.powerUpEffects[51 + I] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + (eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5 if len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player) and not player.teleporting)) else eventPlayer.getFacingDirection() * 0.5), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[54] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Sentry Turret: {0}s".format(ceil(eventPlayer.pSentryTurretCount)), HudPosition.RIGHT, 0.2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[55] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50], 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[50], 50)
    #Sentry Gun Duration
    for eventPlayer.pSentryTurretCount in range(30, 0, -0.125):
        if (len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player) and not player.teleporting))) > 0:
            eventPlayer.powerUpUsePositionsAndInfo[51] = directionTowards(eventPlayer.powerUpUsePositionsAndInfo[50], sorted(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0].getPosition() + vect(0, 1, 0))
            eventPlayer.powerUpUsePositionsAndInfo[52] = raycastHitPosition(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + ((directionFromAngles(random.uniform(-1, 1) + horizontalAngleOfDirection(eventPlayer.powerUpUsePositionsAndInfo[51]), random.uniform(-1, 1) + verticalAngleOfDirection(eventPlayer.powerUpUsePositionsAndInfo[51]))) * 100), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50] + eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5, 25)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50] + eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5, 0.1)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[52], 0.1)
            damage(raycastHitPlayer(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionTowards(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[52]) * 100, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true), eventPlayer, 20)
        wait(0.125)
    destroyEffect(eventPlayer.powerUpEffects[50])
    destroyEffect(eventPlayer.powerUpEffects[51])
    destroyEffect(eventPlayer.powerUpEffects[52])
    destroyEffect(eventPlayer.powerUpEffects[53])
    destroyEffect(eventPlayer.powerUpEffects[54])
    destroyHudText(eventPlayer.powerUpEffects[55])
    eventPlayer.powerUpUsePositionsAndInfo[50] = 0


def cloakingDevice():
    @Name "cloakingDevice (60-69)"
    
    if eventPlayer.powerUpEffects[60] == 0:
        eventPlayer.movementSpeed *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[60] = getLastCreatedEntity()
        hudText(eventPlayer, "Cloaking Device: {0}s".format(ceil(eventPlayer.pCloakingDeviceCount)), null, "Cancel (Press [{0}] + [{1}])".format(inputBindingString(Button.CROUCH), inputBindingString(Button.INTERACT)) if eventPlayer.pCloakingDeviceCount < 23 else [], HudPosition.RIGHT, 0.2, Color.BLUE, null, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[61] = getLastCreatedText()
        eventPlayer.invisible++
    if not eventPlayer.invisible:
        smallMessage(eventPlayer, "Cloaking activated. You are now invisible.")
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.getPosition(), 50)
    #Cloaking Duration
    for eventPlayer.pCloakingDeviceCount in range(25, 0, -1):
        if eventPlayer.pCloakingDeviceCount < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT):
            smallMessage(eventPlayer, "Cloaking deactivated")
            break
        if eventPlayer.isDead():
            break
        waitUntil(eventPlayer.pCloakingDeviceCount < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT), 1)
    eventPlayer.invisible--
    destroyEffect(eventPlayer.powerUpEffects[60])
    destroyHudText(eventPlayer.powerUpEffects[61])
    eventPlayer.powerUpEffects[60] = 0
    if not eventPlayer.invisible:
        smallMessage(eventPlayer, "You are now visible")
    eventPlayer.movementSpeed /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


def superNano():
    @Name "superNano (70-79)"
    
    if eventPlayer.powerUpEffects[70] == 0:
        eventPlayer.movementSpeed *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.RED, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[70] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Super Nano: {0}s".format(ceil(eventPlayer.pSuperNanoCount)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[71] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[72] = getLastCreatedEntity()
        startDamageModification(getPlayers(Team.2), eventPlayer, 200)
        eventPlayer.powerUpEffects[73] = getLastDamageModification()
        startDamageModification(eventPlayer, getAllPlayers(), 50)
        eventPlayer.powerUpEffects[74] = getLastDamageModification()
    heal(eventPlayer, null, 100)
    eventPlayer.setDamageReceived(50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    for eventPlayer.pSuperNanoCount in range(20, 0, -1):
        if eventPlayer.isDead():
            break
        wait(1)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEffects[70])
    destroyHudText(eventPlayer.powerUpEffects[71])
    destroyEffect(eventPlayer.powerUpEffects[72])
    stopDamageModification(eventPlayer.powerUpEffects[73])
    stopDamageModification(eventPlayer.powerUpEffects[74])
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.powerUpEffects[70] = 0
    eventPlayer.movementSpeed /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


def bouncePad():
    @Name "bouncePad (80-89)"
    
    eventPlayer.powerUpUsePositionsAndInfo[80] = eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())
    if eventPlayer.powerUpEffects[80] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[80] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Bounce Pad: {0}s".format(ceil(eventPlayer.pBouncePadCount1)), HudPosition.RIGHT, 0.2, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[81] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 50)
    wait(1)
    #Bounce pad duration
    for eventPlayer.pBouncePadCount1 in range(60, 0, -0.125):
        if eventPlayer.pBouncePadCount1 % 0.25 == 0:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80] + vect(0, 0.125, 0), 4)
        #Determine which players are on the bounce pad
        eventPlayer.powerUpUsePositionsAndInfo[81] = getLivingPlayers(Team.1).filter(lambda player: distance(eventPlayer.powerUpUsePositionsAndInfo[80], player.getPosition()) < 2 and player.isOnGround())
        if len(eventPlayer.powerUpUsePositionsAndInfo[81]) > 0:
            #For each bouncer
            for eventPlayer.pBouncePadCount2 in range(len(eventPlayer.powerUpUsePositionsAndInfo[81])):
                #Current bouncer
                eventPlayer.bouncePadBouncer = eventPlayer.powerUpUsePositionsAndInfo[81][eventPlayer.pBouncePadCount2]
                eventPlayer.bouncePadBouncer.applyImpulse(vect(0, 1, 0), 22, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            playEffect(eventPlayer.powerUpUsePositionsAndInfo[81], DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[80], 50)
        wait(0.125)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEffects[80])
    destroyHudText(eventPlayer.powerUpEffects[81])
    eventPlayer.powerUpEffects[80] = 0


def ultimateCharger():
    @Name "ultimateCharger (90-99)"
    
    if eventPlayer.powerUpEffects[90] == 0:
        hudHeader(eventPlayer, "Ultimate Charger: {0}s".format(ceil(eventPlayer.pUltimateChargerCount)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[90] = getLastCreatedText()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    #Bounce pad duration
    for eventPlayer.pUltimateChargerCount in range(20, 0, -0.125):
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 2)
        wait(0.125)
    wait(0.25)
    destroyHudText(eventPlayer.powerUpEffects[90])
    eventPlayer.powerUpEffects[90] = 0


def stun():
    @Name "stun (100-109)"
    
    if eventPlayer.powerUpEffects[100] == 0:
        #Stun beam effect
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer.pStunChase1, eventPlayer.pStunChase1 + ((directionTowards(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[100].getPosition() + vect(0, losHeightCheck, 0))) * (min(3, distance(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[100].getPosition() + vect(0, losHeightCheck, 0))))), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[100] = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 30)
    #Stun beam lead
    eventPlayer.pStunChase1 = eventPlayer.getPosition() + vect(0, losHeightCheck, 0)
    #Stun origin player
    eventPlayer.powerUpUsePositionsAndInfo[100] = eventPlayer
    #Stun Target
    eventPlayer.powerUpUsePositionsAndInfo[101] = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.size), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
    chaseAtRate(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition() + vect(0, losHeightCheck, 0), 50)
    #Number of bounces
    for eventPlayer.pStunCount in range(50, 0, -1):
        if eventPlayer.powerUpUsePositionsAndInfo[101] == null:
            if eventPlayer.pStunCount > 13 and not eventPlayer.powerUpUsePositionsAndInfo[100] in bosses:
                eventPlayer.powerUpUsePositionsAndInfo[100].setStatusEffect(eventPlayer, Status.STUNNED, eventPlayer.pStunCount / 8.3)
            break
        waitUntil(distance(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition() + vect(0, losHeightCheck, 0)) < 0.1, 3)
        eventPlayer.powerUpUsePositionsAndInfo[101].setStatusEffect(eventPlayer, Status.STUNNED, 0.5 if eventPlayer.powerUpUsePositionsAndInfo[101] in bosses else 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[101], 0.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition(), 50)
        wait()
        #Previous target is new origin
        eventPlayer.powerUpUsePositionsAndInfo[100] = eventPlayer.powerUpUsePositionsAndInfo[101]
        #Set next target
        eventPlayer.powerUpUsePositionsAndInfo[101] = random.choice((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpUsePositionsAndInfo[100].getPosition(), player.getPosition()) < 15 and not player.teleporting)).exclude(eventPlayer.powerUpUsePositionsAndInfo[101]))
    stopChasing(eventPlayer.pStunChase1)
    destroyEffect(eventPlayer.powerUpEffects[100])
    eventPlayer.powerUpEffects[100] = 0


def powerUpUsage():
    @Name "powerUpUsage"
    
    #Cure
    if eventPlayer.currentPowerUp == 1:
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 1)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
        if eventPlayer.infectionLvl > 0:
            eventPlayer.infected = false
            eventPlayer.infectionLvl = 0
        eventPlayer.startHealingOverTime(eventPlayer, 5, 20)
        smallMessage(eventPlayer, "You are cured!")
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    #Instant Revive
    elif eventPlayer.currentPowerUp == 2:
        if len(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= reviveRadius)) == 0:
            return
        startRule(instantRevive)
    #Force Field
    elif eventPlayer.currentPowerUp == 3:
        startRule(playerForceField)
    #No Cooldowns
    elif eventPlayer.currentPowerUp == 4:
        startRule(noCooldowns)
    #Air Strike
    elif eventPlayer.currentPowerUp == 5:
        if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 41, null, getAllPlayers(), false)) > 40:
            smallMessage(eventPlayer, "Aim at a surface to call in an aistrike")
            return
        startRule(airStrike)
    #Beacon of Healing
    elif eventPlayer.currentPowerUp == 6:
        startRule(healBeacon)
    #Vaccine
    elif eventPlayer.currentPowerUp == 7:
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, eventPlayer, 6)
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
        smallMessage(eventPlayer, "Your infection is reduced!")
        getPlayersInRadius(eventPlayer, 3, Team.1, LosCheck.SURFACES).infectionLvl -= 1.5
    #Sentry Turret
    elif eventPlayer.currentPowerUp == 8:
        startRule(sentryTurret)
    #Cloaking Device
    elif eventPlayer.currentPowerUp == 9:
        startRule(cloakingDevice)
    #Super Nano
    elif eventPlayer.currentPowerUp == 10:
        startRule(superNano)
    #Bounce Pad
    elif eventPlayer.currentPowerUp == 11:
        startRule(bouncePad)
    #Ultimate Charger
    elif eventPlayer.currentPowerUp == 12:
        startRule(ultimateCharger)
    #Stun
    elif eventPlayer.currentPowerUp == 13:
        #Check if their are targets nearby and in view angle
        if getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.size and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45):
            startRule(stun)
        else:
            smallMessage(eventPlayer, "Aim at a nearby target")
            return
    eventPlayer.currentPowerUp = 0
