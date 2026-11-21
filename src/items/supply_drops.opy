#!mainFile "../../main.opy"

subroutine findSupplyDropLandingPosition

#!define SUPPLY_DROP_SEARCH_LIMIT 12


rule "GENERATE SUPPLY DROPS":
    #Only activates if last supply drop has been opened
    @Condition isSupplyDropOpen == true
    #Waits for all objectives to be determined before activating
    @Condition isGameplayActive == true
    #Limited to 12 power ups on the ground at a time
    @Condition len(supplyPowerUpPositionList) < 12
    
    # Stop the next-drop delay early if gameplay ends.
    waitUntil(not isGameplayActive, 30)
    if not isGameplayActive:
        return
    supplyDropLandingPosition = null
    supplyDropPosition = null
    isSupplyDropOpen = false
    # The full generation delay is 120-150 seconds.
    waitUntil(not isGameplayActive, random.uniform(1.5, 2) * 60)
    findSupplyDropLandingPosition()
    if supplyDropLandingPosition == null:
        # Release the pending drop and let the next normal cycle try again.
        isSupplyDropOpen = true
        if ruleCondition:
            loop()
        return
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


def findSupplyDropLandingPosition():
    @Name "findSupplyDropLandingPosition"

    if not isGameplayActive or playerTargetList == []:
        return
    # Build the grid snapshot once. The closest player and candidate are
    # synchronous scratch, consumed before the next wait.
    #!define supplyDropClosestPlayer tmp0
    #!define supplyDropCandidatePosition tmp1
    supplyDropClosestPlayer = sorted(playerTargetList, lambda player: distance(player, currentObjectivePosition))[0]
    supplyDropSearchCandidates = random.shuffle(mapGridList.filter(lambda point: distance(supplyDropClosestPlayer, point) < 35 and distance(supplyDropClosestPlayer, point) > 20)).slice(0, SUPPLY_DROP_SEARCH_LIMIT)
    while isGameplayActive and playerTargetList != [] and supplyDropSearchCandidates != []:
        supplyDropCandidatePosition = supplyDropSearchCandidates[0]
        if playerTargetList.all(lambda player: distance(supplyDropCandidatePosition, player) > 20):
            # Players or the objective can move during the search. Recheck the
            # current anchor's range before grounding a point from the snapshot.
            supplyDropClosestPlayer = sorted(playerTargetList, lambda player: distance(player, currentObjectivePosition))[0]
            if distance(supplyDropClosestPlayer, supplyDropCandidatePosition) < 35:
                supplyDropLandingPosition = raycastHitPosition(supplyDropCandidatePosition + 2 * Vector.UP, supplyDropCandidatePosition + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)
                if supplyDropLandingPosition != null:
                    break
        del supplyDropSearchCandidates[0]
        wait(0.25)
    supplyDropSearchCandidates = []


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
