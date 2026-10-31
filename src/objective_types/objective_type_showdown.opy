#!mainFile "../main.opy"


rule "PLAYERS ON OBJECTIVE CONTROL":
    @Event eachPlayer
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    #Objective Cylinder Height As Above, So Below
    @Condition abs(objectivePositions[0].y - eventPlayer.getPosition().y) < 12
    #Objective Cylinder Radius
    @Condition distance(vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z), eventPlayer.getPosition()) < objectiveRad
    
    if eventPlayer.isDummy():
        if not eventPlayer in queuedGoalType:
            queuedGoalType.append(eventPlayer)
    else:
        if not eventPlayer in playersOnObjective:
            playersOnObjective.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    playersOnObjective.remove(eventPlayer)
    queuedGoalType.remove(eventPlayer)


rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE":
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(playersOnObjective) > 0
    @Condition objectiveComplete == false
    
    #Proceed to next objective
    if objectiveCaptureValue >= 100:
        stopChasing(objectiveRad)
        objectiveComplete = true
        queuedGoalType = []
        playersOnObjective = []
        return
    wait(1, Wait.RESTART_WHEN_TRUE)
    if not ruleCondition:
        return
    objectiveCaptureValue += len(playersOnObjective) + 0.25 if len(playersOnObjective) <= 3 else 3.25
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    if objectiveCaptureValue >= goalPost:
        goalPost += 25
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositions[0], objectiveRad * 2)
        if goalPost >= 100:
            goto lbl_0
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, objectivePositions[0], 100)
        smallMessage(getAllPlayers(), "  {0} Checkpoint Reached".format(iconString(Icon.FLAG)))
        lbl_0:
    if ruleCondition:
        loop()


rule "DECREASES CAPTURE PERCENTAGE":
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(queuedGoalType) > 0
    @Condition objectiveComplete == false
    @Condition objectiveCaptureValue > goalPost - 25
    
    wait(1, Wait.RESTART_WHEN_TRUE)
    if objectiveTypes[0] != 1:
        return
    if len(objectivePositions) <= 1:
        return
    objectiveCaptureValue -= (3 if len(queuedGoalType) > 3 else len(queuedGoalType)) if difficultySetting == 1 else len(queuedGoalType) + difficultySetting * 0.75
    playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, null, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    objectiveColor = Color.RED
    wait(0.5)
    if objectiveTypes[0] != 1:
        return
    if len(objectivePositions) <= 1:
        return
    objectiveColor = Color.ORANGE
    if ruleCondition:
        loop()
