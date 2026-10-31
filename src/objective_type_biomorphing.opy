#!mainFile "main.opy"

subroutine biowasteAssignment
subroutine biowasteOutput


rule "BIOMORPHING GOAL START":
    @Condition objectiveTypes[0] == 3
    @Condition objectiveComplete == false
    @Condition goalCheck == true
    @Condition gameStatus == true
    
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
    @Condition objectiveTypes[0] == 3
    @Condition objectiveComplete == false
    @Condition (len(objectiveResourcePositions) + (len(getLivingPlayers(Team.ALL).filter(lambda player: player.playerObjectiveResourceValue > 0))) < 3 or objectiveCaptureValue >= 100) == true
    @Condition gameStatus == true
    @Condition (queuedGoalType[0] != 3 or objectiveCaptureValue >= 100) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if objectiveCaptureValue < 100:
        waitUntil(goalCheck == false, 99999)
        biowasteLocal0 = getPlayers(Team.2).index((getPlayers(Team.2).filter(lambda player: player.playerObjectiveResourceValue != amountPerResource))[0])
        biowasteLocal1 = getPlayers(Team.2)
        biowasteLocal1 = biowasteLocal1[biowasteLocal0]
        biowasteLocal1.playerObjectiveResourceValue = amountPerResource
        biowasteOutput()
        biowasteLocal1.biowasteType = biowasteOutput0
    else:
        if len(availablePowerups) > 0:
            for resourcePowerUpDropCount in range(4):
                powerUpIDs.append(random.choice(availablePowerups))
                powerUpPositions.append(objectivePositions[0] + directionFromAngles(90 * resourcePowerUpDropCount, 0))
        objectiveComplete = true
    if ruleCondition:
        loop()


rule "BIOWASTE IS PICKED UP":
    @Event eachPlayer
    @Condition objectiveTypes[0] == 3
    @Condition gameStatus == true
    @Condition objectiveComplete == false
    @Condition eventPlayer.playerObjectiveResourceValue <= 0
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition len(objectiveResourcePositions) > 0
    @Condition (objectiveResourcePositions.any(lambda x: distance(x, eventPlayer.getPosition()) < 2 or distance(x, eventPlayer.getEyePosition()) < 2)) == true
    @Condition (not eventPlayer.isDummy() or eventPlayer.getTeam() == Team.2) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    biowasteLocal0 = sorted(objectiveResourcePositions, lambda x: distance(eventPlayer.getPosition(), x))[0]
    biowasteLocal1 = objectiveResourcePositions.index(biowasteLocal0)
    eventPlayer.biowasteType = biowasteTypes[biowasteLocal1]
    destroyEffect(biowasteEffects[biowasteLocal1])
    destroyInWorldText(biowasteString[biowasteLocal1])
    del biowasteTypes[biowasteLocal1]
    del objectiveResourcePositions[biowasteLocal1]
    del biowasteEffects[biowasteLocal1]
    del biowasteString[biowasteLocal1]
    eventPlayer.playerObjectiveResourceValue = amountPerResource
    smallMessage(eventPlayer, "  Go to the deposit area!")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 50)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer.getPosition(), 2)


rule "PLAYER DELIVERS RESOURCE VALUE":
    @Event eachPlayer
    @Team 1
    @Condition objectiveTypes[0] == 3
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.playerObjectiveResourceValue > 0
    @Condition eventPlayer.isAlive() == true
    @Condition distance(objectivePositions[0], eventPlayer.getPosition()) < objectiveRad
    @Condition eventPlayer.afk != true
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    wait(0.125)
    eventPlayer.playerWasteValue = 8.9
    #Extra points if correct biowaste type
    if queuedGoalType[0] == eventPlayer.biowasteType:
        eventPlayer.playerWasteValue = 2.9
    #Damage player if resource is blood, damage more if above health.
    damage(eventPlayer, eventPlayer, (50.33 if eventPlayer.getHealth() > 200 else 10.33) if queuedGoalType[0] == 3 else 0)
    #(Amount per resource / dump time) x tick speed
    eventPlayer.playerObjectiveResourceValue -= amountPerResource / 3 * 0.125
    #(Amount per resource / dump time) x tick speed, if resource is blood then this will go slower x the number of players
    objectiveCaptureValue += (amountPerResource / (getNumberOfPlayers(Team.1) * 4.167 if queuedGoalType[0] == 3 else eventPlayer.playerWasteValue)) * 0.125
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


def biowasteAssignment():
    @Name "biowasteAssignment"
    
    biowasteTypes.append(biowasteInput0)
    objectiveResourcePositions.append(biowasteInput1)
    createEffect(getAllPlayers(), Effect.ORB, biowasteColorLookUp[biowasteInput0], biowasteInput1, 1, EffectReeval.NONE)
    biowasteEffects.append(getLastCreatedEntity())
    createInWorldText(getAllPlayers(), biowasteTextLookUp[biowasteInput0], biowasteInput1 + vect(0, 0.75, 0), 1, Clip.NONE, WorldTextReeval.NONE)
    biowasteString.append(getLastCreatedText())


def biowasteOutput():
    @Name "biowasteOutput"
    
    biowasteOutput0 = queuedBioType[0]
    del queuedBioType[0]
    if len(queuedBioType) == 0:
        queuedBioType = random.shuffle([0, 1, 2])


rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED":
    @Event playerDied
    @Condition objectiveTypes[0] == 3
    @Condition eventPlayer.playerObjectiveResourceValue >= amountPerResource
    @Condition queuedGoalType[0] != 3
    
    deferredType.append(eventPlayer.biowasteType)
    deferredPositions.append(nearestWalkablePosition(eventPlayer))
    eventPlayer.playerObjectiveResourceValue = 0
    eventPlayer.biowasteType = null


rule "BIOWASTE MANAGEMENT":
    @Condition len(deferredType) > 0
    
    while len(deferredType) > 0:
        biowasteInput0 = deferredType[0]
        biowasteInput1 = deferredPositions[0]
        biowasteAssignment()
        del deferredType[0]
        del deferredPositions[0]
        wait(0.15)
