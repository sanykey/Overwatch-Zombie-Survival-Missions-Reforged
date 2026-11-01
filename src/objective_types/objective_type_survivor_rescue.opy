#!mainFile "../main.opy"


rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == false
    @Condition (survivorToRescue == null or not entityExists(survivorToRescue)) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if survivorToRescue == null:
        testPos = null
        testPos2 = 115
        while testPos == null:
            testPos = random.choice(mapGridList.filter(lambda x: distance(x, objectivePositionList[0]) > testPos2 and distance(x, objectivePositionList[0]) < 120))
            testPos2 -= 5
            wait()
        createDummy(random.choice(getAllHeroes().filter(lambda x: getNumberOfHeroes(x, Team.1) <= 0)), Team.1, 20, testPos)
        survivorToRescue = getLastCreatedEntity()
    else:
        survivorToRescue = null
        isObjectiveComplete = true
    wait(1)
    if ruleCondition:
        loop()


rule "INITIALIZE SURVIVOR TO BE RESCUED":
    @Event eachPlayer
    @Team 1
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue == eventPlayer
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    survivorToRescue.path = []
    survivorToRescue.startPos = survivorToRescue.getPosition()
    survivorToRescue.botTempValue = false
    eventPlayer.botFollowTarget = null
    eventPlayer.movementSpeed = 1
    eventPlayer.enhancementId = Enhancement.HITCHHIKER
    eventPlayer.enhancementValue1 = 0
    eventPlayer.enhancementValue2 = false
    survivorToRescue.setStatusEffect(null, Status.UNKILLABLE, 99999)
    survivorToRescue.setHealingReceived(110)
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
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue == eventPlayer
    
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition()))
    eventPlayer.resurrect()
    wait(0.25)
    if eventPlayer.isDead():
        loop()


rule "SURVIVOR FOLLOW TARGET":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue.botTempValue == false
    @Condition survivorToRescue.hasSpawned() == true
    @Condition survivorToRescue.getHealth() > 1
    @Condition (playerTargetList.filter(lambda x: x != survivorToRescue and not x.invisible).any(lambda x: distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad)) == true
    @Condition distance(survivorToRescue.getPosition(), objectivePositionList[0]) >= 5
    
    survivorToRescue.clearStatusEffect(Status.PHASED_OUT)
    survivorToRescue.randVal = iconString(Icon.SAD)
    survivorToRescue.botThrottleSpeed = survivorToRescue.getNormalizedHealth() * 0.7
    survivorToRescue.potentialTargets = playerTargetList.filter(lambda x: x != survivorToRescue and not x.invisible and distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad)
    if survivorToRescue.botFollowTarget == null or not survivorToRescue.botFollowTarget in survivorToRescue.potentialTargets:
        survivorToRescue.botFollowTarget = (sorted(playerTargetList.filter(lambda x: distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad), lambda x: distance(x.getPosition(), objectivePositionList[0])))[0]
    if not survivorToRescue in playerTargetList:
        #Add surivor to player target list
        playerTargetList.append(survivorToRescue)
        objectiveRad = 30
    wait(0.25)
    if ruleCondition:
        loop()
    #Remove survivor from player target list
    playerTargetList.remove(survivorToRescue)
    #Reset objective radius
    objectiveRad = objectiveChase1
    survivorToRescue.botFollowTarget = null
    survivorToRescue.potentialTargets = []
    if survivorToRescue.getHealth() <= 1:
        survivorToRescue.randVal = iconString(Icon.DIZZY)
        survivorToRescue.setStatusEffect(null, Status.KNOCKED_DOWN, 99999)
        survivorToRescue.setStatusEffect(null, Status.PHASED_OUT, 99999)
        waitUntil(survivorToRescue.getNormalizedHealth() > 0.75, 20)
        survivorToRescue.clearStatusEffect(Status.KNOCKED_DOWN)
        if ruleCondition:
            loop()


rule "CREATE PATH":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue.botFollowTarget != null
    @Condition survivorToRescue.botThrottleSpeed > 0
    @Condition survivorToRescue.botFollowTarget.getAltitude() <= 1.5
    @Condition (len(survivorToRescue.path) == 0 or distance(survivorToRescue.botFollowTarget.getPosition(), survivorToRescue.path.last()) > 1) == true
    
    survivorToRescue.path.append(survivorToRescue.botFollowTarget.getPosition())
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "DELETE PATH":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition (survivorToRescue.path.any(lambda x: distance(survivorToRescue.getPosition(), vect(x.x, survivorToRescue.getPosition().y, x.z)) < 0.25 and abs(survivorToRescue.getPosition().y - x.y) < 2)) == true
    
    survivorToRescue.telePos = survivorToRescue.path.index(sorted(survivorToRescue.path, lambda x: distance(survivorToRescue.getPosition(), x))[0])
    survivorToRescue.path.remove(survivorToRescue.path.filter(lambda _, i: i <= survivorToRescue.telePos))
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "SURVIVOR FOLLOW TARGET LETS GO":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue.botFollowTarget != null
    @Condition survivorToRescue.botFollowTarget.isCommunicating(Comms.GOODBYE) == true
    
    survivorToRescue.botFollowTarget = null


rule "PLAYER SAYS GROUP UP TO SURVIVOR":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue.botFollowTarget != null
    @Condition (survivorToRescue.potentialTargets.any(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), survivorToRescue.getPosition()) < 12)) == true
    
    survivorToRescue.botFollowTarget = (sorted(survivorToRescue.potentialTargets.filter(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), survivorToRescue.getPosition()) < 12), lambda x: distance(x.getPosition(), survivorToRescue.getPosition())))[0]
    survivorToRescue.botTempvalue2 = "{0} {1}".format(heroIcon(survivorToRescue.botFollowTarget.getHero()), iconString(Icon.QUESTION_MARK))
    survivorToRescue.path = []
    wait(3)
    survivorToRescue.botTempvalue2 = null


rule "SURVIVOR JUMP":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition survivorToRescue.isOnGround() == true
    @Condition survivorToRescue.getThrottle() != vect(0, 0, 0)
    @Condition survivorToRescue.getHorizontalSpeed() < survivorToRescue.botThrottleSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    survivorToRescue.forceButtonPress(Button.JUMP)
    loop()


rule "SURVIVOR REACHES EXTRACTION SITE":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE
    @Condition isObjectiveComplete == false
    @Condition survivorToRescue.hasSpawned() == true
    @Condition distance(survivorToRescue.getPosition(), objectivePositionList[0]) < 5
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, survivorToRescue, 200)
    survivorToRescue.randVal = random.choice([iconString(Icon.HAPPY), iconString(Icon.HEART)])
    survivorToRescue.startThrottleInDirection(directionTowards(survivorToRescue.getPosition(), objectivePositionList[0]), 0.75 if distance(survivorToRescue.getPosition(), objectivePositionList[0]) > 1 else 0, Relativity.TO_WORLD)
    survivorToRescue.startFacing(vect(0, 1, 0), 100)
    wait(1)
    survivorToRescue.botTempValue = true
    survivorToRescue.path = []
    survivorToRescue.chase1 = survivorToRescue.getPosition()
    wait()
    survivorToRescue.startForcingPosition(survivorToRescue.chase1)
    wait(0.5)
    chaseAtRate(survivorToRescue.chase1, survivorToRescue.getPosition() + vect(0, 100, 0), 3, ChaseRateReeval.NONE)
    wait(2)
    chaseAtRate(survivorToRescue.chase1, survivorToRescue.getPosition() + vect(0, 100, 0), 10, ChaseRateReeval.NONE)
    wait(3)
    destroyDummy(Team.1, survivorToRescue.getSlot())
