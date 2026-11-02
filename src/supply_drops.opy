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
    @Condition isSupplyDropOpen == true
    #Waits for all objectives to be determined before activating
    @Condition isGameplayActive == true
    #Limited to 12 power ups on the ground at a time
    @Condition len(supplyPowerUpPositionList) < 12
    
    #Standard 30 second wait
    wait(30)
    supplyDropLandingPosition = null
    supplyDropPosition = null
    isSupplyDropOpen = false
    #Wait standard minimum 30 seconds + a random 30 to 90 extra seconds. Total resulting wait time is 2 to 2.5 minutes.
    wait(random.uniform(1.5, 2) * 60)
    while supplyDropLandingPosition == null:
        #Find the closest player to the objective
        # tmp0: player closest to the objective, used as the center for choosing a supply-drop location.
        tmp0 = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositionList[0]))[0]
        # tmp1: candidate drop position 20-35m from tmp0, to check clearance from all players.
        tmp1 = random.choice(mapGridList.filter(lambda x: distance(tmp0.getPosition(), x) < 35 and distance(tmp0.getPosition(), x) > 20))
        if playerTargetList.all(lambda x: distance(tmp1, x.getPosition()) > 20):
            #Sets supply drop location
            supplyDropLandingPosition = tmp1
            #Sets supply drop location to be placed on ground (in the case that a walkable position is underground for some reason)
            supplyDropLandingPosition = raycastHitPosition(supplyDropLandingPosition + vect(0, 2, 0), supplyDropLandingPosition + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)
        wait(0.25)
    supplyDropPosition = supplyDropLandingPosition + vect(0, 200, 0)
    chaseOverTime(supplyDropPosition, supplyDropLandingPosition, 15)
    bigMessage(getPlayers(Team.1), "Supply drop incoming!")
    waitUntil(supplyDropPosition == supplyDropLandingPosition, 99999)
    stopChasing(supplyDropPosition)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, supplyDropLandingPosition, 4)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, supplyDropLandingPosition, 50)
    wait(10, Wait.RESTART_WHEN_TRUE)
    if len(supplyPowerUpPositionList) < 12:
        loop()


rule "EFFECT/TEXT (GLOBAL)":
    @Condition isGameplayActive == true
    
    #Closed supply drop orb
    createEffect(getAllPlayers().filter(lambda _: supplyDropLandingPosition != null and not isSupplyDropOpen), Effect.ORB, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Falling supply drop aura
    createEffect(getAllPlayers().filter(lambda _: supplyDropLandingPosition != null and supplyDropPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) > 1), Effect.BAD_AURA, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop sphere
    createEffect(getAllPlayers().filter(lambda _: supplyDropLandingPosition != null and isSupplyDropOpen), Effect.SPHERE, Color.AQUA, supplyDropPosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Supply drop landing ring
    createEffect(getAllPlayers().filter(lambda _: supplyDropLandingPosition != null), Effect.RING, Color.AQUA, supplyDropLandingPosition, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop text
    createInWorldText(getLivingPlayers(Team.1).filter(lambda player: supplyDropLandingPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) < 1 and not isSupplyDropOpen and distance(player.getPosition(), supplyDropLandingPosition) <= 6 and distance(supplyDropLandingPosition, player.getEyePosition() + player.getFacingDirection() * distance(player.getEyePosition(), supplyDropLandingPosition)) < 0.5), "[{0}]".format(inputBindingString(Button.INTERACT)), supplyDropPosition + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    #Pick up power up text
    createInWorldText(localPlayer if len(supplyPowerUpPositionList.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6)) else null, "[{0}]".format(inputBindingString(Button.INTERACT)), offsetUpHalfConst + ((sorted(supplyPowerUpPositionList.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x))))[0]), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    #Supply drop landing icon
    createIcon(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player.getPosition(), supplyDropPosition) > 5), supplyDropPosition + vect(0, 1, 0), Icon.PLUS, IconReeval.VISIBILITY_AND_POSITION, Color.AQUA)
    #Supply drop distance
    createInWorldText(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player.getPosition(), supplyDropPosition) > 5), "Supply Drop: {0}m".format(distance(localPlayer.getPosition(), supplyDropPosition)), supplyDropPosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.NEVER)


rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isDummy() == false
    
    if distance(supplyDropLandingPosition, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), supplyDropLandingPosition)) < 0.5 and not isSupplyDropOpen and distance(eventPlayer.getPosition(), supplyDropLandingPosition) <= 6 and supplyDropLandingPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) < 1:
        isSupplyDropOpen = true
        playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, supplyDropPosition, 0.5)
        playEffect(getPlayers(Team.1), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, supplyDropPosition, 50)
        #Power ups per supply drop
        # tmp0: item counter, to append the configured number of random power-up IDs.
        for tmp0 in range(supplyDropPowerUpCount):
            #Range of power ups
            supplyPowerUpIdList.append(random.randint(1, 13))
        #Spacing of power ups
        # tmp0: item angle offset in degrees, to spread the opened supply drop's items toward the player.
        for tmp0 in range(-60, 61, 120 / (supplyDropPowerUpCount - 1)):
            supplyPowerUpPositionList.append(supplyDropLandingPosition + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(supplyDropLandingPosition, eventPlayer.getPosition())) + tmp0, 0)) * 2))
    elif len(supplyPowerUpPositionList) > 0 and ((len(supplyPowerUpPositionList.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6))) > 0):
        #Power up effect position
        eventPlayer.powerUpTradeDataList[0] = (sorted(supplyPowerUpPositionList.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x))))[0]
        #Current power up (or 0 if no current power up)
        eventPlayer.powerUpTradeDataList[2] = eventPlayer.powerUpItemId
        wait()
        #Index of position of current power up being aquired
        eventPlayer.powerUpTradeIndex = supplyPowerUpPositionList.index(eventPlayer.powerUpTradeDataList[0])
        wait()
        #Pick up power up
        eventPlayer.powerUpItemId = supplyPowerUpIdList[eventPlayer.powerUpTradeIndex]
        destroyEffect(supplyPowerUpEffectIdList[eventPlayer.powerUpTradeIndex])
        destroyInWorldText(supplyPowerUpTextIdList[eventPlayer.powerUpTradeIndex])
        wait()
        del supplyPowerUpIdList[eventPlayer.powerUpTradeIndex]
        del supplyPowerUpPositionList[eventPlayer.powerUpTradeIndex]
        del supplyPowerUpEffectIdList[eventPlayer.powerUpTradeIndex]
        del supplyPowerUpTextIdList[eventPlayer.powerUpTradeIndex]
        wait()
        #Trade power ups. Ignore if no power up is currently held.
        if eventPlayer.powerUpTradeDataList[2] != 0:
            supplyPowerUpIdList.append(eventPlayer.powerUpTradeDataList[2])
            supplyPowerUpPositionList.append(eventPlayer.powerUpTradeDataList[0])
    elif eventPlayer.powerUpItemId != 0:
        wait(0.25, Wait.ABORT_WHEN_FALSE)
        powerUpUsage()


def instantRevive():
    @Name "instantRevive (0-9)"
    
    eventPlayer.powerUpReviveTarget = (sorted(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= REVIVE_RADIUS), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getPosition()))))[0]
    wait()
    eventPlayer.powerUpReviveTarget.setStatusEffect(null, Status.INVINCIBLE, 5)
    eventPlayer.powerUpReviveTarget.resurrect()
    waitUntil(eventPlayer.powerUpReviveTarget.isAlive(), 3)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    smallMessage([eventPlayer, eventPlayer.powerUpReviveTarget], "{0} {1}: \"I've got you. Now let's move!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))


def playerForceField():
    @Name "playerForceField (10-19)"
    
    eventPlayer.powerUpForceFieldPosition = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEntityIdList[10]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 7.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[10] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Force Field: {0}s".format(ceil(eventPlayer.powerUpForceFieldTimeRemaining)), HudPosition.RIGHT, 0.2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[11] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 50)
    #Force field duration
    for eventPlayer.powerUpForceFieldTimeRemaining in range(10, 0, -0.032):
        # tmp0: zombie index, to apply the force-field impulse to each nearby living zombie.
        for tmp0 in range(getNumberOfLivingPlayers(Team.2)):
            if distance(getLivingPlayers(Team.2)[tmp0], eventPlayer.powerUpForceFieldPosition) <= 7.5:
                getLivingPlayers(Team.2)[tmp0].applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[tmp0].getPosition()), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpEntityIdList[10])
    destroyHudText(eventPlayer.powerUpEntityIdList[11])
    eventPlayer.powerUpForceFieldPosition = 0


def noCooldowns():
    @Name "noCooldowns (20-29)"
    
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer, 50)
    if eventPlayer.powerUpEntityIdList[20] == 0:
        hudHeader(eventPlayer, "No Cooldowns: {0}s".format(ceil(eventPlayer.powerUpNoCooldownsTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[20] = getLastCreatedText()
    #No cooldown powerup duration
    for eventPlayer.powerUpNoCooldownsTimeRemaining in range(15, 0, -0.032):
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
    destroyHudText(eventPlayer.powerUpEntityIdList[20])
    eventPlayer.powerUpEntityIdList[20] = 0


def airStrike():
    @Name "airStrike (30-39)"
    
    wait()
    smallMessage(getAllPlayers(), "{0} {1}: \"I've called in an air strike!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    #Air Strike Location
    eventPlayer.powerUpAirStrikePosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 40, null, getAllPlayers(), false)
    if eventPlayer.powerUpEntityIdList[30] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer.powerUpAirStrikePosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[30] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, eventPlayer.powerUpAirStrikePosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[31] = getLastCreatedEntity()
    wait(2)
    #Count up to max radius. Number of explosions = Max radius / step size
    for eventPlayer.powerUpAirStrikeIndex in range(50):
        #Random position in ring
        # tmp0: candidate explosion position above the strike area, to raycast onto the ground.
        tmp0 = eventPlayer.powerUpAirStrikePosition + vect(0, 5, 0) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(0, 10)
        #Ray Cast downwards
        # tmp0: ground impact position, shared by this explosion's effects and damage-radius check.
        tmp0 = raycastHitPosition(tmp0, tmp0 + vect(0, -25, 0), null, getAllPlayers(), false)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, tmp0, 2.5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, tmp0, 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, tmp0, 100)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, tmp0, 100)
        # tmp1: zombies inside this explosion's radius, to damage them and set their respawn timers.
        tmp1 = getPlayers(Team.2).filter(lambda player: distance(player.getPosition(), tmp0) < 5)
        damage(tmp1, eventPlayer, 150)
        tmp1.botRespawnDelay = 10
        wait(0.125)
    destroyEffect(eventPlayer.powerUpEntityIdList[30])
    destroyEffect(eventPlayer.powerUpEntityIdList[31])
    eventPlayer.powerUpEntityIdList[30] = 0


def healBeacon():
    @Name "beaconofHealing (40-49)"
    
    eventPlayer.powerUpHealBeaconPosition = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEntityIdList[40]):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + vect(0, -2, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[40] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[41] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Beacon of Healing: {0}s".format(ceil(eventPlayer.powerUpHealBeaconTimeRemaining)), HudPosition.RIGHT, 0.2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[42] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.9, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[43] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpHealBeaconPosition, 50)
    eventPlayer.setHealingDealt(150)
    #Heal Beacon duration
    for eventPlayer.powerUpHealBeaconTimeRemaining in range(30, 0, -1):
        wait(1)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + vect(0, 1, 0), 0.1)
        getPlayersInRadius(eventPlayer.powerUpHealBeaconPosition, 10, eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 2, 30)
    destroyEffect(eventPlayer.powerUpEntityIdList[40])
    destroyEffect(eventPlayer.powerUpEntityIdList[41])
    destroyHudText(eventPlayer.powerUpEntityIdList[42])
    destroyEffect(eventPlayer.powerUpEntityIdList[43])
    eventPlayer.setHealingDealt(100)
    eventPlayer.powerUpHealBeaconPosition = 0


def sentryTurret():
    @Name "sentryTurret (50-59)"
    
    eventPlayer.powerUpTurretPosition = eventPlayer.getPosition() + Vector.UP if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()) + Vector.UP
    if not entityExists(eventPlayer.powerUpEntityIdList[50]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.powerUpTurretPosition, 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[50] = getLastCreatedEntity()
        # tmp0: turret-leg index, to space three beams 120 degrees apart and store their effect IDs.
        for tmp0 in range(3):
            createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionFromAngles(evalOnce(tmp0) * 120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.powerUpEntityIdList[51 + tmp0] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + (eventPlayer.powerUpTurretDirection * 0.5 if len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting)) else eventPlayer.getFacingDirection() * 0.5), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[54] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Sentry Turret: {0}s".format(ceil(eventPlayer.powerUpTurretTimeRemaining)), HudPosition.RIGHT, 0.2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[55] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition, 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpTurretPosition, 50)
    #Sentry Gun Duration
    for eventPlayer.powerUpTurretTimeRemaining in range(30, 0, -0.125):
        if (len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting))) > 0:
            eventPlayer.powerUpTurretDirection = directionTowards(eventPlayer.powerUpTurretPosition, sorted(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0].getPosition() + vect(0, 1, 0))
            # tmp0: turret shot's impact position with random spread, to place its explosion and damage ray.
            tmp0 = raycastHitPosition(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + ((directionFromAngles(random.uniform(-1, 1) + horizontalAngleOfDirection(eventPlayer.powerUpTurretDirection), random.uniform(-1, 1) + verticalAngleOfDirection(eventPlayer.powerUpTurretDirection))) * 100), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 25)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 0.1)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, tmp0, 0.1)
            damage(raycastHitPlayer(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionTowards(eventPlayer.powerUpTurretPosition, tmp0) * 100, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true), eventPlayer, 20)
        wait(0.125)
    # tmp0: turret-effect slot 50-54, to destroy the sphere, legs and barrel when the turret expires.
    for tmp0 in range(50, 55):
        destroyEffect(eventPlayer.powerUpEntityIdList[tmp0])
    destroyHudText(eventPlayer.powerUpEntityIdList[55])
    eventPlayer.powerUpTurretPosition = 0


def cloakingDevice():
    @Name "cloakingDevice (60-69)"
    
    if eventPlayer.powerUpEntityIdList[60] == 0:
        eventPlayer.movementSpeedScale *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[60] = getLastCreatedEntity()
        hudText(eventPlayer, "Cloaking Device: {0}s".format(ceil(eventPlayer.powerUpCloakTimeRemaining)), null, "Cancel (Press [{0}] + [{1}])".format(inputBindingString(Button.CROUCH), inputBindingString(Button.INTERACT)) if eventPlayer.powerUpCloakTimeRemaining < 23 else [], HudPosition.RIGHT, 0.2, Color.BLUE, null, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[61] = getLastCreatedText()
        eventPlayer.invisibilityCount++
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "Cloaking activated. You are now invisible.")
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.getPosition(), 50)
    #Cloaking Duration
    for eventPlayer.powerUpCloakTimeRemaining in range(25, 0, -1):
        if eventPlayer.powerUpCloakTimeRemaining < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT):
            smallMessage(eventPlayer, "Cloaking deactivated")
            break
        if eventPlayer.isDead():
            break
        waitUntil(eventPlayer.powerUpCloakTimeRemaining < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT), 1)
    eventPlayer.invisibilityCount--
    destroyEffect(eventPlayer.powerUpEntityIdList[60])
    destroyHudText(eventPlayer.powerUpEntityIdList[61])
    eventPlayer.powerUpEntityIdList[60] = 0
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "You are now visible")
    eventPlayer.movementSpeedScale /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)


def superNano():
    @Name "superNano (70-79)"
    
    if eventPlayer.powerUpEntityIdList[70] == 0:
        eventPlayer.movementSpeedScale *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.RED, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[70] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Super Nano: {0}s".format(ceil(eventPlayer.powerUpSuperNanoTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[71] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[72] = getLastCreatedEntity()
        startDamageModification(getPlayers(Team.2), eventPlayer, 200)
        eventPlayer.powerUpEntityIdList[73] = getLastDamageModification()
        startDamageModification(eventPlayer, getAllPlayers(), 50)
        eventPlayer.powerUpEntityIdList[74] = getLastDamageModification()
    heal(eventPlayer, null, 100)
    eventPlayer.setDamageReceived(50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    for eventPlayer.powerUpSuperNanoTimeRemaining in range(20, 0, -1):
        if eventPlayer.isDead():
            break
        wait(1)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEntityIdList[70])
    destroyHudText(eventPlayer.powerUpEntityIdList[71])
    destroyEffect(eventPlayer.powerUpEntityIdList[72])
    stopDamageModification(eventPlayer.powerUpEntityIdList[73])
    stopDamageModification(eventPlayer.powerUpEntityIdList[74])
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.powerUpEntityIdList[70] = 0
    eventPlayer.movementSpeedScale /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)


def bouncePad():
    @Name "bouncePad (80-89)"
    
    eventPlayer.powerUpBouncePadPosition = eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())
    if eventPlayer.powerUpEntityIdList[80] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[80] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Bounce Pad: {0}s".format(ceil(eventPlayer.powerUpBouncePadTimeRemaining)), HudPosition.RIGHT, 0.2, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[81] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 50)
    wait(1)
    #Bounce pad duration
    for eventPlayer.powerUpBouncePadTimeRemaining in range(60, 0, -0.125):
        if eventPlayer.powerUpBouncePadTimeRemaining % 0.25 == 0:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.powerUpBouncePadPosition + vect(0, 0.125, 0), 4)
        #Determine which players are on the bounce pad
        # tmp0: grounded survivors on this pad, to apply the bounce and play feedback for this tick.
        tmp0 = getLivingPlayers(Team.1).filter(lambda player: distance(eventPlayer.powerUpBouncePadPosition, player.getPosition()) < 2 and player.isOnGround())
        if len(tmp0) > 0:
            #For each bouncer
            # tmp1: index into the survivor list in tmp0, to process every player on this pad.
            for tmp1 in range(len(tmp0)):
                #Current bouncer
                # tmp2: current survivor from tmp0, to apply this tick's upward impulse.
                tmp2 = tmp0[tmp1]
                tmp2.applyImpulse(vect(0, 1, 0), 22, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            playEffect(tmp0, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.powerUpBouncePadPosition, 50)
        wait(0.125)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEntityIdList[80])
    destroyHudText(eventPlayer.powerUpEntityIdList[81])
    eventPlayer.powerUpEntityIdList[80] = 0


def ultimateCharger():
    @Name "ultimateCharger (90-99)"
    
    if eventPlayer.powerUpEntityIdList[90] == 0:
        hudHeader(eventPlayer, "Ultimate Charger: {0}s".format(ceil(eventPlayer.powerUpUltimateTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[90] = getLastCreatedText()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    #Bounce pad duration
    for eventPlayer.powerUpUltimateTimeRemaining in range(20, 0, -0.125):
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 2)
        wait(0.125)
    wait(0.25)
    destroyHudText(eventPlayer.powerUpEntityIdList[90])
    eventPlayer.powerUpEntityIdList[90] = 0


def stun():
    @Name "stun (100-109)"
    
    if eventPlayer.powerUpEntityIdList[100] == 0:
        #Stun beam effect
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunBeamPosition + ((directionTowards(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)) * (min(3, distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)))), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[100] = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 30)
    #Stun beam lead
    eventPlayer.powerUpStunBeamPosition = eventPlayer.getPosition() + losOffsetConst
    #Stun origin player
    eventPlayer.powerUpStunOrigin = eventPlayer
    #Stun Target
    eventPlayer.powerUpStunTarget = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.sizeScale), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
    chaseAtRate(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunTarget.getPosition() + losOffsetConst, 50)
    #Number of bounces
    for eventPlayer.powerUpStunBouncesRemaining in range(50, 0, -1):
        if eventPlayer.powerUpStunTarget == null:
            if eventPlayer.powerUpStunBouncesRemaining > 13 and not eventPlayer.powerUpStunOrigin in bossStateList:
                eventPlayer.powerUpStunOrigin.setStatusEffect(eventPlayer, Status.STUNNED, eventPlayer.powerUpStunBouncesRemaining / 8.3)
            break
        waitUntil(distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunTarget.getPosition() + losOffsetConst) < 0.1, 3)
        eventPlayer.powerUpStunTarget.setStatusEffect(eventPlayer, Status.STUNNED, 0.5 if eventPlayer.powerUpStunTarget in bossStateList else 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.powerUpStunTarget, 0.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.powerUpStunTarget.getPosition(), 50)
        wait()
        #Previous target is new origin
        eventPlayer.powerUpStunOrigin = eventPlayer.powerUpStunTarget
        #Set next target
        eventPlayer.powerUpStunTarget = random.choice((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpStunOrigin.getPosition(), player.getPosition()) < 15 and not player.botIsTeleporting)).exclude(eventPlayer.powerUpStunTarget))
    stopChasing(eventPlayer.powerUpStunBeamPosition)
    destroyEffect(eventPlayer.powerUpEntityIdList[100])
    eventPlayer.powerUpEntityIdList[100] = 0


def powerUpUsage():
    @Name "powerUpUsage"
    
    switch eventPlayer.powerUpItemId:
        #Cure
        case 1:
            playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 1)
            eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
            if eventPlayer.infectionLevel > 0:
                eventPlayer.isInfected = false
                eventPlayer.infectionLevel = 0
            eventPlayer.startHealingOverTime(eventPlayer, 5, 20)
            smallMessage(eventPlayer, "You are cured!")
            playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
            break
        #Instant Revive
        case 2:
            if len(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= REVIVE_RADIUS)) == 0:
                return
            startRule(instantRevive)
            break
        #Force Field
        case 3:
            startRule(playerForceField)
            break
        #No Cooldowns
        case 4:
            startRule(noCooldowns)
            break
        #Air Strike
        case 5:
            if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 41, null, getAllPlayers(), false)) > 40:
                smallMessage(eventPlayer, "Aim at a surface to call in an aistrike")
                return
            startRule(airStrike)
            break
        #Beacon of Healing
        case 6:
            startRule(healBeacon)
            break
        #Vaccine
        case 7:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, eventPlayer, 6)
            playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
            smallMessage(eventPlayer, "Your infection is reduced!")
            getPlayersInRadius(eventPlayer, 3, Team.1, LosCheck.SURFACES).infectionLevel -= 1.5
            break
        #Sentry Turret
        case 8:
            startRule(sentryTurret)
            break
        #Cloaking Device
        case 9:
            startRule(cloakingDevice)
            break
        #Super Nano
        case 10:
            startRule(superNano)
            break
        #Bounce Pad
        case 11:
            startRule(bouncePad)
            break
        #Ultimate Charger
        case 12:
            startRule(ultimateCharger)
            break
        #Stun
        case 13:
            #Check if their are targets nearby and in view angle
            if getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.sizeScale and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45):
                startRule(stun)
            else:
                smallMessage(eventPlayer, "Aim at a nearby target")
                return
            break
    eventPlayer.powerUpItemId = 0
