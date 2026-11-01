#!mainFile "../main.opy"



macro biowasteOutputMacro():
    # tmp0: next queued biowaste type, returned synchronously to assign to the holder kept in tmp1.
    tmp0 = queuedBioType[0]
    del queuedBioType[0]
    if len(queuedBioType) == 0:
        queuedBioType = random.shuffle([0, 1, 2])


macro biowasteAssignmentMacro():
    # Synchronous inputs: tmp0 = type, tmp1 = position. No reevaluated arguments.
    biowasteTypes.append(tmp0)
    objectiveResourcePositions.append(tmp1)
    createEffect(getAllPlayers(), Effect.ORB, biowasteColorLookUp[tmp0], tmp1, 1, EffectReeval.NONE)
    biowasteEffects.append(getLastCreatedEntity())
    createInWorldText(getAllPlayers(), biowasteTextLookUp[tmp0], tmp1 + offsetUpThreeQuartersConst, 1, Clip.NONE, WorldTextReeval.NONE)
    biowasteString.append(getLastCreatedText())


rule "BIOMORPHING GOAL START":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.BIOMORPHING
    @Condition objectiveComplete == false
    @Condition goalCheck == true
    @Condition isGameplayActive == true
    
    #Destroy all biowaste
    for biowasteCount in range(len(biowasteEffects)):
        destroyEffect(biowasteEffects[biowasteCount])
        destroyInWorldText(biowasteString[biowasteCount])
        wait()
    queuedBioType = random.shuffle([0, 1, 2])
    deferredType = []
    deferredPositions = []
    biowasteTypes = []
    objectiveResourcePositions = []
    biowasteEffects = []
    biowasteString = []
    getAllPlayers().playerObjectiveResourceValue = 0
    getAllPlayers().biowasteType = null
    if objectiveCaptureValue != 0:
        goalColor = objectiveColor
        goalText = "Limit reached! The next goal is..."
    waitUntil(objectiveCaptureValue == 0, 3)
    if objectiveCaptureValue == 0 and queuedGoalType[0] == 3:
        del queuedGoalType[0]
        queuedGoalType.append(3)
        wait(0.15)
    if queuedGoalType[0] == 0:
        goalText = "Deposit a head for extra points"
        goalColor = Color.BLUE
    elif queuedGoalType[0] == 1:
        goalText = "Deposit an arm for extra points"
        goalColor = Color.TURQUOISE
    elif queuedGoalType[0] == 2:
        goalText = "Deposit a leg for extra points"
        goalColor = Color.SKY_BLUE
    else:
        goalText = "Hand over your blood."
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, objectivePositions[0], 200)
        goalColor = Color.RED
        getPlayers(Team.1).biowasteType = 3
        getPlayers(Team.1).playerObjectiveResourceValue = 9999
    goalCheck = false
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, goalColor, objectivePositions[0], 200)


rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.BIOMORPHING
    @Condition objectiveComplete == false
    @Condition (len(objectiveResourcePositions) + (len(getLivingPlayers(Team.ALL).filter(lambda player: player.playerObjectiveResourceValue > 0))) < 3 or objectiveCaptureValue >= 100) == true
    @Condition isGameplayActive == true
    @Condition (queuedGoalType[0] != 3 or objectiveCaptureValue >= 100) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if objectiveCaptureValue < 100:
        waitUntil(goalCheck == false, 99999)
        # tmp0: index of a zombie not holding a full resource, to choose the next resource carrier.
        tmp0 = getPlayers(Team.2).index((getPlayers(Team.2).filter(lambda player: player.playerObjectiveResourceValue != BIOMORPHING_RESOURCE_AMOUNT))[0])
        # tmp1: current zombie list, to resolve the carrier index in tmp0 to a player.
        tmp1 = getPlayers(Team.2)
        # tmp1: selected zombie, kept while biowasteOutputMacro replaces tmp0 with its resource type.
        tmp1 = tmp1[tmp0]
        tmp1.playerObjectiveResourceValue = BIOMORPHING_RESOURCE_AMOUNT
        biowasteOutputMacro()
        tmp1.biowasteType = tmp0
    else:
        # tmp0: reward-item index, to place four power-ups at 90-degree intervals around the objective.
        for tmp0 in range(4):
            powerUpIDs.append(random.randint(1, 13))
            powerUpPositions.append(objectivePositions[0] + directionFromAngles(90 * tmp0, 0))
        objectiveComplete = true
    if ruleCondition:
        loop()


rule "BIOWASTE IS PICKED UP":
    @Event eachPlayer
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.BIOMORPHING
    @Condition isGameplayActive == true
    @Condition objectiveComplete == false
    @Condition eventPlayer.playerObjectiveResourceValue <= 0
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition len(objectiveResourcePositions) > 0
    @Condition (objectiveResourcePositions.any(lambda x: distance(x, eventPlayer.getPosition()) < 2 or distance(x, eventPlayer.getEyePosition()) < 2)) == true
    @Condition (not eventPlayer.isDummy() or eventPlayer.getTeam() == Team.2) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    # tmp0: nearest dropped biowaste position, to identify the resource being picked up.
    tmp0 = sorted(objectiveResourcePositions, lambda x: distance(eventPlayer.getPosition(), x))[0]
    # tmp1: resource index shared by position, type and visual arrays, to pick up and remove the same orb.
    tmp1 = objectiveResourcePositions.index(tmp0)
    eventPlayer.biowasteType = biowasteTypes[tmp1]
    destroyEffect(biowasteEffects[tmp1])
    destroyInWorldText(biowasteString[tmp1])
    del biowasteTypes[tmp1]
    del objectiveResourcePositions[tmp1]
    del biowasteEffects[tmp1]
    del biowasteString[tmp1]
    eventPlayer.playerObjectiveResourceValue = BIOMORPHING_RESOURCE_AMOUNT
    smallMessage(eventPlayer, "  Go to the deposit area!")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 50)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer.getPosition(), 2)


rule "PLAYER DELIVERS RESOURCE VALUE":
    @Event eachPlayer
    @Team 1
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.BIOMORPHING
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.playerObjectiveResourceValue > 0
    @Condition eventPlayer.isAlive() == true
    @Condition distance(objectivePositions[0], eventPlayer.getPosition()) < objectiveRad
    @Condition eventPlayer.afk != true
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    wait(0.125)
    # tmp0: deposit-time divisor for ordinary biowaste, used to calculate this tick's progress.
    tmp0 = 8.9
    #Extra points if correct biowaste type
    if queuedGoalType[0] == eventPlayer.biowasteType:
        # tmp0: shorter deposit-time divisor for the requested resource, to award faster progress.
        tmp0 = 2.9
    #Damage player if resource is blood, damage more if above health.
    damage(eventPlayer, eventPlayer, (50.33 if eventPlayer.getHealth() > 200 else 10.33) if queuedGoalType[0] == 3 else 0)
    #(Amount per resource / dump time) x tick speed
    eventPlayer.playerObjectiveResourceValue -= BIOMORPHING_RESOURCE_AMOUNT / 3 * 0.125
    #(Amount per resource / dump time) x tick speed, if resource is blood then this will go slower x the number of players
    objectiveCaptureValue += (BIOMORPHING_RESOURCE_AMOUNT / (getNumberOfPlayers(Team.1) * 4.167 if queuedGoalType[0] == 3 else tmp0)) * 0.125
    if objectiveCaptureValue >= goalPost:
        del queuedGoalType[0]
        objectiveCaptureValue = goalPost
        goalCheck = true
        goalPost += 25
    if ruleCondition:
        loop()
    if eventPlayer.playerObjectiveResourceValue <= 0:
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 75)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.getPosition() + vect(0, 0.25, 0), 8)
        smallMessage(eventPlayer, "  Biowaste deposited!")
    playersOnObjective.remove(eventPlayer)


rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED":
    @Event playerDied
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.BIOMORPHING
    @Condition eventPlayer.playerObjectiveResourceValue >= BIOMORPHING_RESOURCE_AMOUNT
    @Condition queuedGoalType[0] != 3
    
    deferredType.append(eventPlayer.biowasteType)
    deferredPositions.append(nearestWalkablePosition(eventPlayer))
    eventPlayer.playerObjectiveResourceValue = 0
    eventPlayer.biowasteType = null


rule "BIOWASTE MANAGEMENT":
    @Condition len(deferredType) > 0
    
    while len(deferredType) > 0:
        # tmp0: first queued biowaste type, passed to biowasteAssignmentMacro to create the dropped orb.
        tmp0 = deferredType[0]
        # tmp1: matching queued drop position, passed to biowasteAssignmentMacro to place the orb.
        tmp1 = deferredPositions[0]
        biowasteAssignmentMacro()
        del deferredType[0]
        del deferredPositions[0]
        wait(0.15)
