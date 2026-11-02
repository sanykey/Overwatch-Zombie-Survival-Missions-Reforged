#!mainFile "../main.opy"


rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == false
    @Condition (rescueSurvivor == null or not entityExists(rescueSurvivor)) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if rescueSurvivor == null:
        rescueCandidatePosition = null
        rescueMinSpawnDistance = 115
        while rescueCandidatePosition == null:
            rescueCandidatePosition = random.choice(mapGridList.filter(lambda x: distance(x, objectivePositionList[0]) > rescueMinSpawnDistance and distance(x, objectivePositionList[0]) < 120))
            rescueMinSpawnDistance -= 5
            wait()
        createDummy(random.choice(getAllHeroes().filter(lambda x: getNumberOfHeroes(x, Team.1) <= 0)), Team.1, 20, rescueCandidatePosition)
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
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor == eventPlayer
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    rescueSurvivor.path = []
    rescueSurvivor.startPos = rescueSurvivor.getPosition()
    rescueSurvivor.botTempValue = false
    eventPlayer.botFollowTarget = null
    eventPlayer.movementSpeed = 1
    eventPlayer.enhancementId = Enhancement.HITCHHIKER
    eventPlayer.enhancementValue1 = 0
    eventPlayer.enhancementValue2 = false
    rescueSurvivor.setStatusEffect(null, Status.UNKILLABLE, 99999)
    rescueSurvivor.setHealingReceived(110)
    #Objective/Survivor distance
    createInWorldText(getAllPlayers().filter(lambda _: not eventPlayer.botTempValue and distance(localPlayer.getPosition(), objectivePositionList[0]) > 5), "Distance: {0}m".format(distance(localPlayer.getPosition(), eventPlayer.getPosition() if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > objectiveRad else objectivePositionList[0])), eventPlayer.getPosition() if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > objectiveRad else objectivePositionList[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.VIOLET, SpecVisibility.NEVER)
    #Survivor rescue progress bar
    progressBarHud(getAllPlayers(), 100 if eventPlayer.botTempValue else ((distance(vect(objectivePositionList[0].x, eventPlayer.startPos.y, objectivePositionList[0].z), eventPlayer.startPos) - distance(eventPlayer.getPosition(), vect(objectivePositionList[0].x, eventPlayer.getPosition().y, objectivePositionList[0].z))) / distance(vect(objectivePositionList[0].x, eventPlayer.startPos.y, objectivePositionList[0].z), eventPlayer.startPos)) * 100, "Survivor Rescue Progress", HudPosition.TOP, 2, Color.VIOLET, Color.VIOLET, ProgressHudReeval.VISIBILITY_AND_VALUES)
    #Survivor icon
    createInWorldText(getAllPlayers(), eventPlayer.botTempvalue2 if eventPlayer.botTempvalue2 else eventPlayer.randVal, eventPlayer, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    eventPlayer.randVal = iconString(Icon.HALO)
    #Survivor activation ring
    createEffect(getAllPlayers(), Effect.RING, Color.VIOLET if eventPlayer.botFollowTarget != null else Color.RED, eventPlayer, objectiveRad)
    #Zombie slowing ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.getNormalizedHealth() < 1), Effect.BAD_AURA, Color.PURPLE, eventPlayer, 1)
    # tmp0: survivor path-marker index, to create rings every three path points using evalOnce.
    for tmp0 in range(10):
        #Path Markers
        createEffect(getAllPlayers().filter(lambda _: len(eventPlayer.path) > evalOnce(tmp0 * 3)), Effect.RING, Color.VIOLET, eventPlayer.path[evalOnce(tmp0) * 3], 0.2)
    eventPlayer.startFacing(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botFollowTarget.getEyePosition())), 80 if eventPlayer.botFollowTarget == null else verticalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botFollowTarget.getEyePosition()))), 100)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), (eventPlayer.path.filter(lambda x: distance(eventPlayer.getPosition(), x) < 2)).last() if eventPlayer.path.any(lambda x: distance(eventPlayer.getPosition(), x) < 2) else eventPlayer.botFollowTarget.getPosition()), 0 if eventPlayer.botFollowTarget == null or distance(eventPlayer.getPosition(), eventPlayer.botFollowTarget.getPosition()) < 1.5 else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "SURVIVOR TO BE RESCUED DIES":
    @Event playerDied
    @Team 1
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor == eventPlayer
    
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition()))
    eventPlayer.resurrect()
    wait(0.25)
    if eventPlayer.isDead():
        loop()


rule "SURVIVOR FOLLOW TARGET":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.botTempValue == false
    @Condition rescueSurvivor.hasSpawned() == true
    @Condition rescueSurvivor.getHealth() > 1
    @Condition (playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisible).any(lambda x: distance(rescueSurvivor.getPosition(), x.getPosition()) < objectiveRad)) == true
    @Condition distance(rescueSurvivor.getPosition(), objectivePositionList[0]) >= 5
    
    rescueSurvivor.clearStatusEffect(Status.PHASED_OUT)
    rescueSurvivor.randVal = iconString(Icon.SAD)
    rescueSurvivor.botThrottleSpeed = rescueSurvivor.getNormalizedHealth() * 0.7
    rescueSurvivor.potentialTargets = playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisible and distance(rescueSurvivor.getPosition(), x.getPosition()) < objectiveRad)
    if rescueSurvivor.botFollowTarget == null or not rescueSurvivor.botFollowTarget in rescueSurvivor.potentialTargets:
        rescueSurvivor.botFollowTarget = (sorted(playerTargetList.filter(lambda x: distance(rescueSurvivor.getPosition(), x.getPosition()) < objectiveRad), lambda x: distance(x.getPosition(), objectivePositionList[0])))[0]
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
    rescueSurvivor.botFollowTarget = null
    rescueSurvivor.potentialTargets = []
    if rescueSurvivor.getHealth() <= 1:
        rescueSurvivor.randVal = iconString(Icon.DIZZY)
        rescueSurvivor.setStatusEffect(null, Status.KNOCKED_DOWN, 99999)
        rescueSurvivor.setStatusEffect(null, Status.PHASED_OUT, 99999)
        waitUntil(rescueSurvivor.getNormalizedHealth() > 0.75, 20)
        rescueSurvivor.clearStatusEffect(Status.KNOCKED_DOWN)
        if ruleCondition:
            loop()


rule "CREATE PATH":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.botFollowTarget != null
    @Condition rescueSurvivor.botThrottleSpeed > 0
    @Condition rescueSurvivor.botFollowTarget.getAltitude() <= 1.5
    @Condition (len(rescueSurvivor.path) == 0 or distance(rescueSurvivor.botFollowTarget.getPosition(), rescueSurvivor.path.last()) > 1) == true
    
    rescueSurvivor.path.append(rescueSurvivor.botFollowTarget.getPosition())
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "DELETE PATH":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition (rescueSurvivor.path.any(lambda x: distance(rescueSurvivor.getPosition(), vect(x.x, rescueSurvivor.getPosition().y, x.z)) < 0.25 and abs(rescueSurvivor.getPosition().y - x.y) < 2)) == true
    
    rescueSurvivor.telePos = rescueSurvivor.path.index(sorted(rescueSurvivor.path, lambda x: distance(rescueSurvivor.getPosition(), x))[0])
    rescueSurvivor.path.remove(rescueSurvivor.path.filter(lambda _, i: i <= rescueSurvivor.telePos))
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "SURVIVOR FOLLOW TARGET LETS GO":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.botFollowTarget != null
    @Condition rescueSurvivor.botFollowTarget.isCommunicating(Comms.GOODBYE) == true
    
    rescueSurvivor.botFollowTarget = null


rule "PLAYER SAYS GROUP UP TO SURVIVOR":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.botFollowTarget != null
    @Condition (rescueSurvivor.potentialTargets.any(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), rescueSurvivor.getPosition()) < 12)) == true
    
    rescueSurvivor.botFollowTarget = (sorted(rescueSurvivor.potentialTargets.filter(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), rescueSurvivor.getPosition()) < 12), lambda x: distance(x.getPosition(), rescueSurvivor.getPosition())))[0]
    rescueSurvivor.botTempvalue2 = "{0} {1}".format(heroIcon(rescueSurvivor.botFollowTarget.getHero()), iconString(Icon.QUESTION_MARK))
    rescueSurvivor.path = []
    wait(3)
    rescueSurvivor.botTempvalue2 = null


rule "SURVIVOR JUMP":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition rescueSurvivor.isOnGround() == true
    @Condition rescueSurvivor.getThrottle() != vect(0, 0, 0)
    @Condition rescueSurvivor.getHorizontalSpeed() < rescueSurvivor.botThrottleSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    rescueSurvivor.forceButtonPress(Button.JUMP)
    loop()


rule "SURVIVOR REACHES EXTRACTION SITE":
    @Condition objectiveTypeList[0] == ObjectiveType.SURVIVOR_RESCUE
    @Condition isObjectiveComplete == false
    @Condition rescueSurvivor.hasSpawned() == true
    @Condition distance(rescueSurvivor.getPosition(), objectivePositionList[0]) < 5
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, rescueSurvivor, 200)
    rescueSurvivor.randVal = random.choice([iconString(Icon.HAPPY), iconString(Icon.HEART)])
    rescueSurvivor.startThrottleInDirection(directionTowards(rescueSurvivor.getPosition(), objectivePositionList[0]), 0.75 if distance(rescueSurvivor.getPosition(), objectivePositionList[0]) > 1 else 0, Relativity.TO_WORLD)
    rescueSurvivor.startFacing(vect(0, 1, 0), 100)
    wait(1)
    rescueSurvivor.botTempValue = true
    rescueSurvivor.path = []
    rescueSurvivor.chase1 = rescueSurvivor.getPosition()
    wait()
    rescueSurvivor.startForcingPosition(rescueSurvivor.chase1)
    wait(0.5)
    chaseAtRate(rescueSurvivor.chase1, rescueSurvivor.getPosition() + vect(0, 100, 0), 3, ChaseRateReeval.NONE)
    wait(2)
    chaseAtRate(rescueSurvivor.chase1, rescueSurvivor.getPosition() + vect(0, 100, 0), 10, ChaseRateReeval.NONE)
    wait(3)
    destroyDummy(Team.1, rescueSurvivor.getSlot())
