#!mainFile "../main.opy"
subroutine useLivingProjectile

subroutine playAquaPowerUpSound

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
        # supplyDropClosestPlayer: player closest to the objective, used as the center for choosing a supply-drop location.
        #!define supplyDropClosestPlayer tmp0
        supplyDropClosestPlayer = sorted(playerTargetList, lambda x: distance(x, currentObjectivePosition))[0]
        # supplyDropCandidatePosition: candidate drop position 20-35m from supplyDropClosestPlayer, to check clearance from all players.
        #!define supplyDropCandidatePosition tmp1
        supplyDropCandidatePosition = random.choice(mapGridList.filter(lambda x: distance(supplyDropClosestPlayer, x) < 35 and distance(supplyDropClosestPlayer, x) > 20))
        if playerTargetList.all(lambda x: distance(supplyDropCandidatePosition, x) > 20):
            #Sets supply drop location
            supplyDropLandingPosition = supplyDropCandidatePosition
            #Sets supply drop location to be placed on ground (in the case that a walkable position is underground for some reason)
            supplyDropLandingPosition = raycastHitPosition(supplyDropLandingPosition + 2 * Vector.UP, supplyDropLandingPosition + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)
        wait(0.25)
    supplyDropPosition = supplyDropLandingPosition + 200 * Vector.UP
    chaseOverTime(supplyDropPosition, supplyDropLandingPosition, 15)
    bigMessage(getPlayers(Team.1), "Supply drop incoming!")
    waitUntil(supplyDropPosition == supplyDropLandingPosition, Math.INFINITY)
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
    createInWorldText(getLivingPlayers(Team.1).filter(lambda player: supplyDropLandingPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) < 1 and not isSupplyDropOpen and distance(player, supplyDropLandingPosition) <= 6 and distance(supplyDropLandingPosition, player.getEyePosition() + player.getFacingDirection() * distance(player.getEyePosition(), supplyDropLandingPosition)) < 0.5), "[{0}]".format(inputBindingString(Button.INTERACT)), supplyDropPosition + Vector.UP, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    #Pick up power up text
    createInWorldText(localPlayer if supplyPowerUpPositionList.any(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer, x) <= 6) else null, "[{0}]".format(inputBindingString(Button.INTERACT)), offsetUpHalfConst + ((sorted(supplyPowerUpPositionList.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer, x) <= 6), lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x))))[0]), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    #Supply drop landing icon
    createIcon(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player, supplyDropPosition) > 5), supplyDropPosition + Vector.UP, Icon.PLUS, IconReeval.VISIBILITY_AND_POSITION, Color.AQUA)
    #Supply drop distance
    createInWorldText(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player, supplyDropPosition) > 5), "Supply Drop: {0}m".format(distance(localPlayer, supplyDropPosition)), supplyDropPosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.NEVER)


# Carried Dead Weight throws take priority over augment input reservations.
# Boolean predicate, reused after the powerup hold because these checks live in
# Actions and are no longer observed by Abort When False.
#!define INTERACT_AUGMENT_INPUT_ALLOWED ((eventPlayer.enhancementId == Enhancement.DEAD_WEIGHT and eventPlayer.enhancementHeldZombie != null) or ((eventPlayer.augmentId != Augment.APOTHECARY or not eventPlayer.isHoldingButton(Button.CROUCH)) and (eventPlayer.augmentId != Augment.LASER_BARRICADE or (not eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.augmentBarrierPlacementCooldown >= 0))))

rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false

    # Workshop workaround (map dependent): the gameplay Condition here reproduced
    # newer heroes disappearing when returning from voting to hero selection.
    # Keep the phase guard in Actions, before any raycast/pickup/throw; cause unknown.
    # Related cases:
    # - Apothecary: "APOTHECARY ALLOW HEALTH PACK PICKUP", src/augments.opy,
    #   reverted by ba8e70de7d4e282b2f90c8ae6c15f6d1d500a342; And did NOT help.
    # - Scavenger: "PLAYER DROPS POWER UP (MANUAL)", src/power_ups.opy,
    #   1079602bbdcf12d9e989d595c315949601fd184b; grouped And helped in user tests.
    # - Leech: "LEECH LIFESTEAL", src/augments.opy,
    #   de11b70848715973335c011e19821273504f5d3c; eligibility moved to Actions.
    # isGameplayActive only holds boolean/default zero.
    if not isGameplayActive:
        return

    # Reserve Crouch + Interact for Apothecary even without a teleport charge.
    # Barricade keeps the reservation until Interact release, even without Crouch.
    if not INTERACT_AUGMENT_INPUT_ALLOWED:
        return

    # Resolve zombie interaction once per press, before any item transaction.
    # The held reference survives a throw request until the bot finishes cleanup.
    if eventPlayer.enhancementId == Enhancement.DEAD_WEIGHT:
        useLivingProjectile()
        if eventPlayer.enhancementHeldZombie != null:
            # Reserve a ready barricade until this consumed press ends. Bot release
            # can clear the held reference before the placement rule runs.
            if eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown <= 0:
                eventPlayer.augmentBarrierPlacementCooldown = -2
                waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), Math.INFINITY)
                eventPlayer.augmentBarrierPlacementCooldown = 0
            return

    # Query aimed items only on interaction; reuse this scratch slot for the chosen
    # position below after sorting. No reader retains the candidate array across waits.
    #!define aimedPowerUpPositions tmp0
    aimedPowerUpPositions = supplyPowerUpPositionList.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer, x) <= 6)
    if distance(supplyDropLandingPosition, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), supplyDropLandingPosition)) < 0.5 and not isSupplyDropOpen and distance(eventPlayer, supplyDropLandingPosition) <= 6 and supplyDropLandingPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) < 1:
        isSupplyDropOpen = true
        playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, supplyDropPosition, 0.5)
        playEffect(getPlayers(Team.1), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, supplyDropPosition, 50)
        #Power ups per supply drop
        # supplyDropGeneratedItemIndex: item counter, to append the configured number of random power-up IDs.
        #!define supplyDropGeneratedItemIndex tmp0
        for supplyDropGeneratedItemIndex in range(supplyDropPowerUpCount):
            #Range of power ups
            supplyPowerUpIdList.append(random.randint(1, 13))
        #Spacing of power ups
        # supplyDropItemAngleOffset: item angle offset in degrees, to spread the opened supply drop's items toward the player.
        #!define supplyDropItemAngleOffset tmp0
        for supplyDropItemAngleOffset in range(-60, 61, 120 / (supplyDropPowerUpCount - 1)):
            supplyPowerUpPositionList.append(supplyDropLandingPosition + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(supplyDropLandingPosition, eventPlayer)) + supplyDropItemAngleOffset, 0)) * 2))
    elif len(aimedPowerUpPositions) > 0:
        if eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH) and len(eventPlayer.augmentScavengerBackpack) >= 2:
            return
        # Commit pickup and all four aligned ground lists without waits: another
        # player's pickup or a Reload drop must never observe a half-finished trade.
        # Synchronous scratch; no subroutine calls or reevaluated captures here.
        #!define pickedPowerUpPosition tmp0
        #!define pickedPowerUpIndex tmp1
        #!define tradedPowerUpItemId tmp2
        pickedPowerUpPosition = (sorted(aimedPowerUpPositions, lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x))))[0]
        pickedPowerUpIndex = supplyPowerUpPositionList.index(pickedPowerUpPosition)
        tradedPowerUpItemId = eventPlayer.powerUpItemId
        if eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.augmentScavengerBackpack.append(supplyPowerUpIdList[pickedPowerUpIndex])
            tradedPowerUpItemId = 0
        else:
            eventPlayer.powerUpItemId = supplyPowerUpIdList[pickedPowerUpIndex]
        destroyEffect(supplyPowerUpEffectIdList[pickedPowerUpIndex])
        destroyInWorldText(supplyPowerUpTextIdList[pickedPowerUpIndex])
        del supplyPowerUpIdList[pickedPowerUpIndex]
        del supplyPowerUpPositionList[pickedPowerUpIndex]
        del supplyPowerUpEffectIdList[pickedPowerUpIndex]
        del supplyPowerUpTextIdList[pickedPowerUpIndex]
        if tradedPowerUpItemId != 0:
            supplyPowerUpIdList.append(tradedPowerUpItemId)
            supplyPowerUpPositionList.append(pickedPowerUpPosition)
    elif eventPlayer.powerUpItemId:
        wait(0.25, Wait.ABORT_WHEN_FALSE)
        # Phase/input guards are in Actions, outside Abort When False checks.
        # Recheck to prevent activation after game end or a reserved input change.
        if isGameplayActive and INTERACT_AUGMENT_INPUT_ALLOWED:
            powerUpUsage()


def instantRevive():
    @Name "instantRevive (0-9)"
    
    eventPlayer.powerUpReviveTarget = (sorted(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer, player) <= REVIVE_RADIUS), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getPosition()))))[0]
    wait()
    eventPlayer.powerUpReviveTarget.setStatusEffect(null, Status.INVINCIBLE, 5)
    eventPlayer.powerUpReviveTarget.resurrect()
    waitUntil(eventPlayer.powerUpReviveTarget.isAlive(), 3)
    playAquaPowerUpSound()
    smallMessage([eventPlayer, eventPlayer.powerUpReviveTarget], "{0} {1}: \"I've got you. Now let's move!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))


def playerForceField():
    @Name "playerForceField (10-19)"
    
    eventPlayer.powerUpForceFieldPosition = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpForceFieldSphereId):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 7.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpForceFieldSphereId = getLastCreatedEntity()
        hudHeader(eventPlayer, "Force Field: {0}s".format(ceil(eventPlayer.powerUpForceFieldTimeRemaining)), HudPosition.RIGHT, 0.2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.FORCE_FIELD_HUD] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 50)
    #Force field duration
    for eventPlayer.powerUpForceFieldTimeRemaining in range(10, 0, -0.032):
        # forceFieldZombieIndex: zombie index, to apply the force-field impulse to each nearby living zombie.
        #!define forceFieldZombieIndex tmp0
        for forceFieldZombieIndex in range(getNumberOfLivingPlayers(Team.2)):
            if distance(getLivingPlayers(Team.2)[forceFieldZombieIndex], eventPlayer.powerUpForceFieldPosition) <= 7.5:
                getLivingPlayers(Team.2)[forceFieldZombieIndex].applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex]), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpForceFieldSphereId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.FORCE_FIELD_HUD])
    eventPlayer.powerUpForceFieldPosition = 0


def noCooldowns():
    @Name "noCooldowns (20-29)"
    
    playAquaPowerUpSound()
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer, 50)
    if eventPlayer.powerUpNoCooldownsHudId == 0:
        hudHeader(eventPlayer, "No Cooldowns: {0}s".format(ceil(eventPlayer.powerUpNoCooldownsTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpNoCooldownsHudId = getLastCreatedText()
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
    destroyHudText(eventPlayer.powerUpNoCooldownsHudId)
    eventPlayer.powerUpNoCooldownsHudId = 0


def airStrike():
    @Name "airStrike (30-39)"
    
    wait()
    smallMessage(getAllPlayers(), "{0} {1}: \"I've called in an air strike!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    #Air Strike Location
    eventPlayer.powerUpAirStrikePosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 40, null, getAllPlayers(), false)
    if eventPlayer.powerUpAirStrikeRingId == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer.powerUpAirStrikePosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpAirStrikeRingId = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, eventPlayer.powerUpAirStrikePosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.AIR_STRIKE_CLOUD] = getLastCreatedEntity()
    wait(2)
    #Count up to max radius. Number of explosions = Max radius / step size
    for eventPlayer.powerUpAirStrikeIndex in range(50):
        #Random position in ring
        # airStrikeRayStartPosition: candidate explosion position above the strike area, to raycast onto the ground.
        #!define airStrikeRayStartPosition tmp0
        airStrikeRayStartPosition = eventPlayer.powerUpAirStrikePosition + 5 * Vector.UP + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(0, 10)
        #Ray Cast downwards
        # airStrikeImpactPosition: ground impact position, shared by this explosion's effects and damage-radius check.
        #!define airStrikeImpactPosition tmp0
        airStrikeImpactPosition = raycastHitPosition(airStrikeRayStartPosition, airStrikeRayStartPosition + -25 * Vector.UP, null, getAllPlayers(), false)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, airStrikeImpactPosition, 2.5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, airStrikeImpactPosition, 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, airStrikeImpactPosition, 100)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, airStrikeImpactPosition, 100)
        # airStrikeAffectedZombieList: zombies inside this explosion's radius, to damage them and set their respawn timers.
        #!define airStrikeAffectedZombieList tmp1
        airStrikeAffectedZombieList = getPlayersInRadius(airStrikeImpactPosition, 5, Team.2)
        damage(airStrikeAffectedZombieList, eventPlayer, 150)
        airStrikeAffectedZombieList.botRespawnDelay = 10
        wait(0.125)
    destroyEffect(eventPlayer.powerUpAirStrikeRingId)
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.AIR_STRIKE_CLOUD])
    eventPlayer.powerUpAirStrikeRingId = 0


def healBeacon():
    @Name "beaconofHealing (40-49)"
    
    eventPlayer.powerUpHealBeaconPosition = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpHealBeaconLightShaftId):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + -2 * Vector.UP, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpHealBeaconLightShaftId = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_RING] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Beacon of Healing: {0}s".format(ceil(eventPlayer.powerUpHealBeaconTimeRemaining)), HudPosition.RIGHT, 0.2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_HUD] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer) * 0.9, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_AURA] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpHealBeaconPosition, 50)
    # Beacon adds 50 percentage points without replacing Plague Doctor's permanent +30%.
    eventPlayer.setHealingDealt(180 if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR else 150)
    #Heal Beacon duration
    for eventPlayer.powerUpHealBeaconTimeRemaining in range(30, 0, -1):
        wait(1)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + Vector.UP, 0.1)
        getPlayersInRadius(eventPlayer.powerUpHealBeaconPosition, 10, eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 2, 30)
    destroyEffect(eventPlayer.powerUpHealBeaconLightShaftId)
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_RING])
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_HUD])
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_AURA])
    eventPlayer.setHealingDealt(130 if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR else 100)
    eventPlayer.powerUpHealBeaconPosition = 0


def sentryTurret():
    @Name "sentryTurret (50-59)"
    
    eventPlayer.powerUpTurretPosition = eventPlayer.getPosition() + Vector.UP if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()) + Vector.UP
    if not entityExists(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_BODY]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.powerUpTurretPosition, 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_BODY] = getLastCreatedEntity()
        # turretLegVisualIndex: turret-leg index, to space three beams 120 degrees apart and store their effect IDs.
        #!define turretLegVisualIndex tmp0
        for turretLegVisualIndex in range(3):
            createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionFromAngles(evalOnce(turretLegVisualIndex) * 120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_LEG_1 + turretLegVisualIndex] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + (eventPlayer.powerUpTurretDirection * 0.5 if getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting) else eventPlayer.getFacingDirection() * 0.5), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_BARREL] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Sentry Turret: {0}s".format(ceil(eventPlayer.powerUpTurretTimeRemaining)), HudPosition.RIGHT, 0.2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_HUD] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition, 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpTurretPosition, 50)
    #Sentry Gun Duration
    for eventPlayer.powerUpTurretTimeRemaining in range(30, 0, -0.125):
        if getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting):
            eventPlayer.powerUpTurretDirection = directionTowards(eventPlayer.powerUpTurretPosition, sorted(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0].getPosition() + Vector.UP)
            # turretShotImpactPosition: turret shot's impact position with random spread, to place its explosion and damage ray.
            #!define turretShotImpactPosition tmp0
            turretShotImpactPosition = raycastHitPosition(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + ((directionFromAngles(random.uniform(-1, 1) + horizontalAngleOfDirection(eventPlayer.powerUpTurretDirection), random.uniform(-1, 1) + verticalAngleOfDirection(eventPlayer.powerUpTurretDirection))) * 100), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 25)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 0.1)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, turretShotImpactPosition, 0.1)
            damage(raycastHitPlayer(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionTowards(eventPlayer.powerUpTurretPosition, turretShotImpactPosition) * 100, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true), eventPlayer, 20)
        wait(0.125)
    # turretCleanupEffectIndex: turret-effect slot 50-54, to destroy the sphere, legs and barrel when the turret expires.
    #!define turretCleanupEffectIndex tmp0
    for turretCleanupEffectIndex in range(PowerUpEntitySlot.SENTRY_TURRET_BODY, PowerUpEntitySlot.SENTRY_TURRET_BARREL + 1):
        destroyEffect(eventPlayer.powerUpEntityIdList[turretCleanupEffectIndex])
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_HUD])
    eventPlayer.powerUpTurretPosition = 0


def cloakingDevice():
    @Name "cloakingDevice (60-69)"
    
    if eventPlayer.powerUpCloakingDeviceSphereId == 0:
        eventPlayer.movementSpeedScale *= 1.5
        applyScaledMoveSpeed()
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpCloakingDeviceSphereId = getLastCreatedEntity()
        hudText(eventPlayer, "Cloaking Device: {0}s".format(ceil(eventPlayer.powerUpCloakTimeRemaining)), null, "Cancel (Press [{0}] + [{1}])".format(inputBindingString(Button.CROUCH), inputBindingString(Button.INTERACT)) if eventPlayer.powerUpCloakTimeRemaining < 23 else [], HudPosition.RIGHT, 0.2, Color.BLUE, null, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.CLOAKING_DEVICE_HUD] = getLastCreatedText()
        eventPlayer.invisibilityCount++
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "Cloaking activated. You are now invisible.")
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95)
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
    destroyEffect(eventPlayer.powerUpCloakingDeviceSphereId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.CLOAKING_DEVICE_HUD])
    eventPlayer.powerUpCloakingDeviceSphereId = 0
    if not eventPlayer.invisibilityCount:
        smallMessage(eventPlayer, "You are now visible")
    eventPlayer.movementSpeedScale /= 1.5
    applyScaledMoveSpeed()


def superNano():
    @Name "superNano (70-79)"
    
    if eventPlayer.powerUpSuperNanoGoodAuraId == 0:
        eventPlayer.movementSpeedScale *= 1.5
        applyScaledMoveSpeed()
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.RED, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpSuperNanoGoodAuraId = getLastCreatedEntity()
        hudHeader(eventPlayer, "Super Nano: {0}s".format(ceil(eventPlayer.powerUpSuperNanoTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_HUD] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_BAD_AURA] = getLastCreatedEntity()
        startDamageModification(getPlayers(Team.2), eventPlayer, 200)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_DEALT_MODIFICATION] = getLastDamageModification()
        startDamageModification(eventPlayer, getAllPlayers(), 50)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION] = getLastDamageModification()
    heal(eventPlayer, null, 100)
    eventPlayer.setDamageReceived(50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    for eventPlayer.powerUpSuperNanoTimeRemaining in range(20, 0, -1):
        if eventPlayer.isDead():
            break
        wait(1)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpSuperNanoGoodAuraId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_HUD])
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_BAD_AURA])
    stopDamageModification(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_DEALT_MODIFICATION])
    stopDamageModification(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION])
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.powerUpSuperNanoGoodAuraId = 0
    eventPlayer.movementSpeedScale /= 1.5
    applyScaledMoveSpeed()


def bouncePad():
    @Name "bouncePad (80-89)"
    
    eventPlayer.powerUpBouncePadPosition = eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())
    if eventPlayer.powerUpBouncePadRingId == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpBouncePadRingId = getLastCreatedEntity()
        hudHeader(eventPlayer, "Bounce Pad: {0}s".format(ceil(eventPlayer.powerUpBouncePadTimeRemaining)), HudPosition.RIGHT, 0.2, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.BOUNCE_PAD_HUD] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.powerUpBouncePadPosition, 50)
    wait(1)
    #Bounce pad duration
    for eventPlayer.powerUpBouncePadTimeRemaining in range(60, 0, -0.125):
        if not (eventPlayer.powerUpBouncePadTimeRemaining % 0.25):
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.powerUpBouncePadPosition + 0.125 * Vector.UP, 4)
        #Determine which players are on the bounce pad
        # bouncePadSurvivorList: grounded survivors on this pad, to apply the bounce and play feedback for this tick.
        #!define bouncePadSurvivorList tmp0
        bouncePadSurvivorList = getLivingPlayers(Team.1).filter(lambda player: distance(eventPlayer.powerUpBouncePadPosition, player) < 2 and player.isOnGround())
        if bouncePadSurvivorList != []:
            bouncePadSurvivorList.applyImpulse(Vector.UP, 22, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            playEffect(bouncePadSurvivorList, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.powerUpBouncePadPosition, 50)
        wait(0.125)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpBouncePadRingId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.BOUNCE_PAD_HUD])
    eventPlayer.powerUpBouncePadRingId = 0


def ultimateCharger():
    @Name "ultimateCharger (90-99)"
    
    if eventPlayer.powerUpUltimateChargerHudId == 0:
        hudHeader(eventPlayer, "Ultimate Charger: {0}s".format(ceil(eventPlayer.powerUpUltimateTimeRemaining)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpUltimateChargerHudId = getLastCreatedText()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    #Bounce pad duration
    for eventPlayer.powerUpUltimateTimeRemaining in range(20, 0, -0.125):
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 2)
        wait(0.125)
    wait(0.25)
    destroyHudText(eventPlayer.powerUpUltimateChargerHudId)
    eventPlayer.powerUpUltimateChargerHudId = 0


def stun():
    @Name "stun (100-109)"
    
    if eventPlayer.powerUpStunBeamId == 0:
        #Stun beam effect
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunBeamPosition + ((directionTowards(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)) * (min(3, distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst)))), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpStunBeamId = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 30)
    #Stun beam lead
    eventPlayer.powerUpStunBeamPosition = eventPlayer.getPosition() + losOffsetConst
    #Stun origin player
    eventPlayer.powerUpStunOrigin = eventPlayer
    #Stun Target
    eventPlayer.powerUpStunTarget = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer, player) < 15 * eventPlayer.sizeScale), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
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
        eventPlayer.powerUpStunTarget = random.choice((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpStunOrigin, player) < 15 and not player.botIsTeleporting)).exclude(eventPlayer.powerUpStunTarget))
    stopChasing(eventPlayer.powerUpStunBeamPosition)
    destroyEffect(eventPlayer.powerUpStunBeamId)
    eventPlayer.powerUpStunBeamId = 0


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
            playAquaPowerUpSound()
            break
        #Instant Revive
        case 2:
            if not getDeadPlayers(Team.1).any(lambda player: distance(eventPlayer, player) <= REVIVE_RADIUS):
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
            playAquaPowerUpSound()
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
            if getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).any(lambda player: distance(eventPlayer, player) < 15 * eventPlayer.sizeScale and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45):
                startRule(stun)
            else:
                smallMessage(eventPlayer, "Aim at a nearby target")
                return
            break
    eventPlayer.powerUpItemId = 0


def playAquaPowerUpSound():
    @Name "playAquaPowerUpSound"

    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
