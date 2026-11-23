#!mainFile "../../main.opy"


rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == false
    @Condition (rescueSurvivor == null or not entityExists(rescueSurvivor)) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if rescueSurvivor == null:
        # Cache distances by grid index. Both scratch slots are consumed before any wait.
        #!define rescueSpawnDistances tmp0
        #!define rescueNearbySpawnDistances tmp1
        rescueSpawnDistances = mapGridList.map(lambda point: distance(point, currentObjectivePosition))
        rescueNearbySpawnDistances = sorted(rescueSpawnDistances.filter(lambda spawnDistance: spawnDistance < 120))
        if rescueNearbySpawnDistances == []:
            # Use the existing objective completion path when no spawn is possible.
            isObjectiveComplete = true
            return

        # The farthest eligible point identifies the first nonempty band in the old
        # search (115–120 m, then 110–120 m, and so on). Keep both bounds strict.
        #!define rescueFarthestSpawnDistance tmp1
        rescueFarthestSpawnDistance = rescueNearbySpawnDistances.last()
        rescueMinSpawnDistance = floor(rescueFarthestSpawnDistance / 5) * 5
        if rescueFarthestSpawnDistance <= rescueMinSpawnDistance:
            rescueMinSpawnDistance -= 5
        rescueCandidatePosition = random.choice(mapGridList.filter(lambda _, i: (
            rescueSpawnDistances[i] > rescueMinSpawnDistance and rescueSpawnDistances[i] < 120
        )))
        createDummy(random.choice(getAllHeroes().filter(lambda x: not getNumberOfHeroes(x, Team.1))), Team.1, 20, rescueCandidatePosition)
        rescueSurvivor = getLastCreatedEntity()
    else:
        rescueSurvivor = null
        isObjectiveComplete = true
    wait(1)
    if ruleCondition:
        loop()


rule "INITIALIZE SURVIVOR TO BE RESCUED":
    @Event eachPlayer
    @Team 1
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor == eventPlayer
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    rescueSurvivor.rescuePathList = []
    rescueSurvivor.rescueStartPosition = rescueSurvivor.getPosition()
    rescueSurvivor.rescueIsExtracting = false
    eventPlayer.rescueLeader = null
    eventPlayer.movementSpeedScale = 1
    eventPlayer.enhancementId = Enhancement.HITCHHIKER
    eventPlayer.hitchhikerCarrier = 0
    eventPlayer.hitchhikerPassengerPoolId = false
    rescueSurvivor.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)
    rescueSurvivor.setHealingReceived(110)
    #Objective/Survivor distance
    createInWorldText(getAllPlayers().filter(lambda _: not eventPlayer.rescueIsExtracting and distance(localPlayer, currentObjectivePosition) > 5), "Distance: {0}m".format(distance(localPlayer, eventPlayer if distance(eventPlayer, localPlayer) > objectiveRad else currentObjectivePosition)), eventPlayer.getPosition() if distance(eventPlayer, localPlayer) > objectiveRad else currentObjectivePosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.VIOLET, SpecVisibility.NEVER)
    # Reuse the starting distance within each live progress update.
    progressBarHud(
        getAllPlayers(),
        100 if eventPlayer.rescueIsExtracting else [magnitude(
            (currentObjectivePosition - eventPlayer.rescueStartPosition) * horizontalMaskConst
        )].map(lambda startDistance: (
            (startDistance - magnitude((currentObjectivePosition - eventPlayer.getPosition()) * horizontalMaskConst))
            / startDistance * 100
        ))[0],
        "Survivor Rescue Progress", HudPosition.TOP, 2, Color.VIOLET, Color.VIOLET,
        ProgressHudReeval.VISIBILITY_AND_VALUES
    )
    #Survivor icon
    createInWorldText(getAllPlayers(), eventPlayer.rescueFollowMessage if eventPlayer.rescueFollowMessage else eventPlayer.rescueMoodIcon, eventPlayer, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    eventPlayer.rescueMoodIcon = iconString(Icon.HALO)
    #Survivor activation ring
    createEffect(getAllPlayers(), Effect.RING, Color.VIOLET if eventPlayer.rescueLeader != null else Color.RED, eventPlayer, objectiveRad)
    #Zombie slowing ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.getNormalizedHealth() < 1), Effect.BAD_AURA, Color.PURPLE, eventPlayer, 1)
    # rescuePathMarkerIndex: survivor path-marker index, to create rings every three path points using evalOnce.
    #!define rescuePathMarkerIndex tmp0
    for rescuePathMarkerIndex in range(10):
        #Path Markers
        createEffect(getAllPlayers().filter(lambda _: len(eventPlayer.rescuePathList) > evalOnce(rescuePathMarkerIndex * 3)), Effect.RING, Color.VIOLET, eventPlayer.rescuePathList[evalOnce(rescuePathMarkerIndex) * 3], 0.2)
    eventPlayer.startFacing(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.rescueLeader.getEyePosition())), 80 if eventPlayer.rescueLeader == null else verticalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.rescueLeader.getEyePosition()))), 100)
    # Prepend the leader as a fallback so one live filter selects the last nearby point.
    eventPlayer.startThrottleInDirection(
        directionTowards(eventPlayer, [eventPlayer.rescueLeader].concat(eventPlayer.rescuePathList.filter(lambda point: distance(eventPlayer, point) < 2)).last()),
        0 if eventPlayer.rescueLeader == null or distance(eventPlayer, eventPlayer.rescueLeader) < 1.5 else eventPlayer.rescueThrottleSpeed,
        Relativity.TO_WORLD
    )


rule "SURVIVOR TO BE RESCUED DIES":
    @Event playerDied
    @Team 1
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor == eventPlayer
    
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition()))
    eventPlayer.resurrect()
    wait(0.25)
    if eventPlayer.isDead():
        loop()


rule "SURVIVOR FOLLOW TARGET":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.rescueIsExtracting == false
    @Condition rescueSurvivor.hasSpawned() == true
    @Condition rescueSurvivor.getHealth() > 1
    @Condition playerTargetList.any(lambda player: (
        player != rescueSurvivor
        and not player.invisibilityCount
        and distance(rescueSurvivor, player) < objectiveRad
    )) == true
    @Condition distance(rescueSurvivor, currentObjectivePosition) >= 5
    
    rescueSurvivor.clearStatusEffect(Status.PHASED_OUT)
    rescueSurvivor.rescueMoodIcon = iconString(Icon.SAD)
    rescueSurvivor.rescueThrottleSpeed = rescueSurvivor.getNormalizedHealth() * 0.7
    rescueSurvivor.rescuePotentialLeaderList = playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisibilityCount and distance(rescueSurvivor, x) < objectiveRad)
    if rescueSurvivor.rescueLeader == null or not rescueSurvivor.rescueLeader in rescueSurvivor.rescuePotentialLeaderList:
        rescueSurvivor.rescueLeader = (sorted(playerTargetList.filter(lambda x: distance(rescueSurvivor, x) < objectiveRad), lambda x: distance(x, currentObjectivePosition)))[0]
    if not rescueSurvivor in playerTargetList:
        #Add surivor to player target list
        playerTargetList.append(rescueSurvivor)
        objectiveRad = 30
    wait(0.25)
    if ruleCondition:
        loop()
    #Remove survivor from player target list
    playerTargetList.remove(rescueSurvivor)
    #Reset objective radius
    objectiveRad = rescueSavedRadius
    rescueSurvivor.rescueLeader = null
    rescueSurvivor.rescuePotentialLeaderList = []
    if rescueSurvivor.getHealth() <= 1:
        rescueSurvivor.rescueMoodIcon = iconString(Icon.DIZZY)
        rescueSurvivor.setStatusEffect(null, Status.KNOCKED_DOWN, Math.INFINITY)
        rescueSurvivor.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
        waitUntil(rescueSurvivor.getNormalizedHealth() > 0.75, 20)
        rescueSurvivor.clearStatusEffect(Status.KNOCKED_DOWN)
        if ruleCondition:
            loop()


rule "CREATE PATH":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.rescueLeader != null
    @Condition rescueSurvivor.rescueThrottleSpeed > 0
    @Condition rescueSurvivor.rescueLeader.getAltitude() <= 1.5
    @Condition (rescueSurvivor.rescuePathList == [] or distance(rescueSurvivor.rescueLeader, rescueSurvivor.rescuePathList.last()) > 1) == true
    
    rescueSurvivor.rescuePathList.append(rescueSurvivor.rescueLeader.getPosition())
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "DELETE PATH":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition (rescueSurvivor.rescuePathList.any(lambda point: magnitude((rescueSurvivor.getPosition() - point) * horizontalMaskConst) < 0.25 and abs(rescueSurvivor.getPosition().y - point.y) < 2)) == true
    
    # rescueReachedPathIndex: reached path index, consumed by the immediate path trim.
    #!define rescueReachedPathIndex tmp0
    rescueReachedPathIndex = rescueSurvivor.rescuePathList.index(sorted(rescueSurvivor.rescuePathList, lambda x: distance(rescueSurvivor, x))[0])
    rescueSurvivor.rescuePathList.remove(rescueSurvivor.rescuePathList.filter(lambda _, i: i <= rescueReachedPathIndex))
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "SURVIVOR FOLLOW TARGET LETS GO":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.rescueLeader != null
    @Condition rescueSurvivor.rescueLeader.isCommunicating(Comms.GOODBYE) == true
    
    rescueSurvivor.rescueLeader = null


rule "PLAYER SAYS GROUP UP TO SURVIVOR":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.rescueLeader != null
    @Condition (rescueSurvivor.rescuePotentialLeaderList.any(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x, rescueSurvivor) < 12)) == true
    
    rescueSurvivor.rescueLeader = (sorted(rescueSurvivor.rescuePotentialLeaderList.filter(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x, rescueSurvivor) < 12), lambda x: distance(x, rescueSurvivor)))[0]
    rescueSurvivor.rescueFollowMessage = "{0} {1}".format(heroIcon(rescueSurvivor.rescueLeader.getHero()), iconString(Icon.QUESTION_MARK))
    rescueSurvivor.rescuePathList = []
    wait(3)
    rescueSurvivor.rescueFollowMessage = null


rule "SURVIVOR JUMP":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.isOnGround() == true
    @Condition magnitude(rescueSurvivor.getThrottle())
    @Condition rescueSurvivor.getHorizontalSpeed() < rescueSurvivor.rescueThrottleSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    rescueSurvivor.forceButtonPress(Button.JUMP)
    loop()


rule "SURVIVOR REACHES EXTRACTION SITE":
    @Condition currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE
    @Condition isObjectiveComplete == false
    @Condition rescueSurvivor.hasSpawned() == true
    @Condition distance(rescueSurvivor, currentObjectivePosition) < 5
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, rescueSurvivor, 200)
    rescueSurvivor.rescueMoodIcon = random.choice([iconString(Icon.HAPPY), iconString(Icon.HEART)])
    rescueSurvivor.startThrottleInDirection(directionTowards(rescueSurvivor, currentObjectivePosition), 0.75 if distance(rescueSurvivor, currentObjectivePosition) > 1 else 0, Relativity.TO_WORLD)
    rescueSurvivor.startFacing(Vector.UP, 100)
    wait(1)
    rescueSurvivor.rescueIsExtracting = true
    rescueSurvivor.rescuePathList = []
    rescueSurvivor.rescueExtractionPosition = rescueSurvivor.getPosition()
    wait()
    rescueSurvivor.startForcingPosition(rescueSurvivor.rescueExtractionPosition)
    wait(0.5)
    chaseAtRate(rescueSurvivor.rescueExtractionPosition, rescueSurvivor.getPosition() + 100 * Vector.UP, 3, ChaseRateReeval.NONE)
    wait(2)
    chaseAtRate(rescueSurvivor.rescueExtractionPosition, rescueSurvivor.getPosition() + 100 * Vector.UP, 10, ChaseRateReeval.NONE)
    wait(3)
    destroyDummy(Team.1, rescueSurvivor.getSlot())
