#!mainFile "../../main.opy"


rule "PLAYERS ON OBJECTIVE CONTROL":
    @Event eachPlayer
    @Condition groupedConditions(((((currentObjectiveType == ObjectiveType.SHOWDOWN) and (len(objectivePositionList) > 1)) and ((eventPlayer.invisibilityCount != true) and (eventPlayer.isAlive() == true))) and (((eventPlayer.hasSpawned() == true) and (abs(currentObjectivePosition.y - eventPlayer.getPosition().y) < 12)) and (distance(vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z), eventPlayer.getPosition()) < objectiveRad))))
    #Objective Cylinder Height As Above, So Below
    #Objective Cylinder Radius
    
    if eventPlayer.isDummy():
        if not eventPlayer in showdownContestingZombieList:
            showdownContestingZombieList.append(eventPlayer)
    else:
        if not eventPlayer in objectivePlayerList:
            objectivePlayerList.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    objectivePlayerList.remove(eventPlayer)
    showdownContestingZombieList.remove(eventPlayer)


rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE":
    @Condition groupedConditions((((currentObjectiveType == ObjectiveType.SHOWDOWN) and (len(objectivePositionList) > 1)) and ((objectivePlayerList != []) and (isObjectiveComplete == false))))
    
    #Proceed to next objective
    if showdownCapturePercent >= 100:
        stopChasing(objectiveRad)
        isObjectiveComplete = true
        showdownContestingZombieList = []
        objectivePlayerList = []
        return
    wait(1, Wait.RESTART_WHEN_TRUE)
    if not ruleCondition:
        return
    showdownCapturePercent += min(len(objectivePlayerList), 3) + 0.25
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, currentObjectivePosition, (0.05 * showdownCapturePercent) ** 2)
    if showdownCapturePercent >= showdownNextCheckpoint:
        showdownNextCheckpoint += 25
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, currentObjectivePosition, objectiveRad * 2)
        if showdownNextCheckpoint >= 100:
            goto lbl_0
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, currentObjectivePosition, 100)
        smallMessage(getAllPlayers(), "  {0} Checkpoint Reached".format(iconString(Icon.FLAG)))
        lbl_0:
    if ruleCondition:
        loop()


rule "DECREASES CAPTURE PERCENTAGE":
    @Condition groupedConditions(((((currentObjectiveType == ObjectiveType.SHOWDOWN) and (len(objectivePositionList) > 1)) and (showdownContestingZombieList != [])) and ((isObjectiveComplete == false) and (showdownCapturePercent > showdownNextCheckpoint - 25))))
    
    wait(1, Wait.RESTART_WHEN_TRUE)
    if currentObjectiveType != ObjectiveType.SHOWDOWN:
        return
    if len(objectivePositionList) <= 1:
        return
    showdownCapturePercent -= min(3, len(showdownContestingZombieList)) if difficultySetting == Difficulty.NORMAL else len(showdownContestingZombieList) + difficultySetting * 0.75
    playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, null, currentObjectivePosition, (0.05 * showdownCapturePercent) ** 2)
    objectiveColor = Color.RED
    wait(0.5)
    if currentObjectiveType != ObjectiveType.SHOWDOWN:
        return
    if len(objectivePositionList) <= 1:
        return
    objectiveColor = Color.ORANGE
    if ruleCondition:
        loop()
