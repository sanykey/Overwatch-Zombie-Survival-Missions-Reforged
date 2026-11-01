#!mainFile "../main.opy"


rule "PLAYERS ON OBJECTIVE CONTROL":
    @Event eachPlayer
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositionList) > 1
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    #Objective Cylinder Height As Above, So Below
    @Condition abs(objectivePositionList[0].y - eventPlayer.getPosition().y) < 12
    #Objective Cylinder Radius
    @Condition distance(vect(objectivePositionList[0].x, eventPlayer.getPosition().y, objectivePositionList[0].z), eventPlayer.getPosition()) < objectiveRad
    
    if eventPlayer.isDummy():
        if not eventPlayer in queuedGoalList:
            queuedGoalList.append(eventPlayer)
    else:
        if not eventPlayer in objectivePlayerList:
            objectivePlayerList.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    objectivePlayerList.remove(eventPlayer)
    queuedGoalList.remove(eventPlayer)


rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositionList) > 1
    @Condition len(objectivePlayerList) > 0
    @Condition isObjectiveComplete == false
    
    #Proceed to next objective
    if objectiveCaptureValue >= 100:
        stopChasing(objectiveRad)
        isObjectiveComplete = true
        queuedGoalList = []
        objectivePlayerList = []
        return
    wait(1, Wait.RESTART_WHEN_TRUE)
    if not ruleCondition:
        return
    objectiveCaptureValue += len(objectivePlayerList) + 0.25 if len(objectivePlayerList) <= 3 else 3.25
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, objectivePositionList[0], (0.05 * objectiveCaptureValue) ** 2)
    if objectiveCaptureValue >= goalPost:
        goalPost += 25
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositionList[0], objectiveRad * 2)
        if goalPost >= 100:
            goto lbl_0
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, objectivePositionList[0], 100)
        smallMessage(getAllPlayers(), "  {0} Checkpoint Reached".format(iconString(Icon.FLAG)))
        lbl_0:
    if ruleCondition:
        loop()


rule "DECREASES CAPTURE PERCENTAGE":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositionList) > 1
    @Condition len(queuedGoalList) > 0
    @Condition isObjectiveComplete == false
    @Condition objectiveCaptureValue > goalPost - 25
    
    wait(1, Wait.RESTART_WHEN_TRUE)
    if CURRENT_OBJECTIVE_TYPE != ObjectiveType.SHOWDOWN:
        return
    if len(objectivePositionList) <= 1:
        return
    objectiveCaptureValue -= (3 if len(queuedGoalList) > 3 else len(queuedGoalList)) if difficultySetting == 1 else len(queuedGoalList) + difficultySetting * 0.75
    playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, null, objectivePositionList[0], (0.05 * objectiveCaptureValue) ** 2)
    objectiveColor = Color.RED
    wait(0.5)
    if CURRENT_OBJECTIVE_TYPE != ObjectiveType.SHOWDOWN:
        return
    if len(objectivePositionList) <= 1:
        return
    objectiveColor = Color.ORANGE
    if ruleCondition:
        loop()
