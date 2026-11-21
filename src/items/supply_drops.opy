#!mainFile "../../main.opy"


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
    if DEBUG_ENABLE_INSPECTOR:
        logToInspector(f"[supply drop] Starting descent to {supplyDropLandingPosition}")
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
    #Supply drop landing icon
    createIcon(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player, supplyDropPosition) > 5), supplyDropPosition + Vector.UP, Icon.PLUS, IconReeval.VISIBILITY_AND_POSITION, Color.AQUA)
    #Supply drop distance
    createInWorldText(getAllPlayers().filter(lambda player: supplyDropLandingPosition != null and distance(player, supplyDropPosition) > 5), "Supply Drop: {0}m".format(distance(localPlayer, supplyDropPosition)), supplyDropPosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.NEVER)


macro canOpenSupplyDrop():
    distance(supplyDropLandingPosition, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), supplyDropLandingPosition)) < 0.5 and not isSupplyDropOpen and distance(eventPlayer, supplyDropLandingPosition) <= 6 and supplyDropLandingPosition != null and distance(supplyDropLandingPosition, supplyDropPosition) < 1


macro openSupplyDrop():
    isSupplyDropOpen = true
    playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, supplyDropPosition, 0.5)
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, supplyDropPosition, 50)
    #Power ups per supply drop
    # supplyDropGeneratedItemIndex: item counter, to append the configured number of random power-up IDs.
    #!define supplyDropGeneratedItemIndex tmp0
    for supplyDropGeneratedItemIndex in range(supplyDropPowerUpCount):
        #Range of power ups
        supplyPowerUpIdList.append(random.randint(PowerUpItem.CURE, PowerUpItem.STUN))
    #Spacing of power ups
    # supplyDropItemAngleOffset: item angle offset in degrees, to spread the opened supply drop's items toward the player.
    #!define supplyDropItemAngleOffset tmp0
    for supplyDropItemAngleOffset in range(-60, 61, 120 / (supplyDropPowerUpCount - 1)):
        supplyPowerUpPositionList.append(supplyDropLandingPosition + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(supplyDropLandingPosition, eventPlayer)) + supplyDropItemAngleOffset, 0)) * 2))
