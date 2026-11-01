#!mainFile "../main.opy"



macro fireSatelliteMacro():
    wait(1)
    smallMessage(getAllPlayers(), "Connecting to satellite...")
    wait(2)
    smallMessage(getAllPlayers(), "Connection established!")
    objectiveChase1 = objectivePositionList[0]
    #Terminal connection beams
    # tmp0: terminal index, to connect each terminal to the satellite laser with a beam.
    for tmp0 in range(len(objectiveResourcePositionList)):
        createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0), objectiveResourcePositionList[evalOnce(tmp0)] + vect(0, 0, 0), objectiveColor, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
    wait(1)
    smallMessage(getAllPlayers(), "Preparing to fire...")
    wait(0.5)
    bigMessage(getAllPlayers(), "Stand clear of the laser")
    #Warning icon
    createIcon(getAllPlayers(), objectiveChase1 + vect(0, 1, 0), Icon.WARNING, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE)
    objectiveEntityIdList.append(getLastCreatedEntity())
    #Laser distance
    createInWorldText(getAllPlayers(), "Danger: {0}m".format(distance(objectiveChase1, localPlayer.getPosition())), objectiveChase1, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    objectiveEntityIdList.append(getLastCreatedText())
    #Laser center beam
    createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * 1, objectiveChase1 + vect(0, -700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * 1, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    objectiveEntityIdList.append(getLastCreatedEntity())
    #Laser center beam
    createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * -1, objectiveChase1 + vect(0, -700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * -1, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    objectiveEntityIdList.append(getLastCreatedEntity())
    #Sattellite firing light shafts
    # tmp0: laser light-shaft layer index, to place six shafts at heights -35 through 65.
    for tmp0 in range(-1, 5):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.AQUA, objectiveChase1 + (vect(0, -15 + 20 * evalOnce(tmp0), 0)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
    wait(5)
    smallMessage(getAllPlayers(), "Firing sequence commenced")
    #Chase closest living zombie
    chaseAtRate(objectiveChase1, survivorToRescue.getPosition(), 7.5 if getLivingPlayers(Team.2).any(lambda player: not player.teleporting) else 0)
    #Fire satellite
    for objectiveCount1 in range(40, 0, -1):
        stopChasing(objectiveChase1)
        survivorToRescue = (sorted(getLivingPlayers(Team.2).filter(lambda player: not player.teleporting), lambda x: distance(x.getPosition(), objectiveChase1)))[0]
        if survivorToRescue != null:
            #Chase closest living zombie
            chaseAtRate(objectiveChase1, survivorToRescue.getPosition(), 7.5 if getLivingPlayers(Team.2).any(lambda player: not player.teleporting) else 0)
        wait(0.5)
        # tmp0: laser impact position on the ground, shared by explosion visuals and both damage checks.
        tmp0 = raycastHitPosition(objectiveChase1 + vect(0, 2, 0), objectiveChase1 + vect(0, -100, 0), getAllPlayers(), getAllPlayers().filter(lambda player: player.isOnGround()), false) + vect(0, 0.1, 0)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, tmp0, 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.SKY_BLUE, tmp0, 200)
        #Damage Zombies
        damage(getPlayers(Team.2).filter(lambda player: distance(player.getPosition(), tmp0) < 5), null, 500)
        #Damage Players
        damage(getPlayers(Team.1).filter(lambda player: distance(player.getPosition(), tmp0) < 5), null, 70)
        if objectiveCount1 > 5:
            #Give all bots quick respawn time
            getPlayers(Team.2).reviveTimer = 1
        else:
            #Give all bots a long respawn time
            getPlayers(Team.2).reviveTimer = 12
            botSpawnTimeList = botSpawnTimeList.map(lambda _: 12)
    stopChasing(objectiveChase1)


rule "SET UP TERMINAL POSITIONS":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SATELLITE_UPLINK
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == false
    @Condition (len(objectiveCaptureValue) != len(objectiveResourcePositionList) or objectiveResourcePositionList.any(lambda x: x.x == null)) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    # tmp0: grid points 10-50m from the objective, to choose a terminal location with sufficient spacing.
    tmp0 = mapGridList.filter(lambda x: distance(x, objectivePositionList[0]) > 10 and distance(x, objectivePositionList[0]) < 50)
    if len(objectiveResourcePositionList) == 0:
        objectiveResourcePositionList.append(random.choice(tmp0))
    else:
        # tmp1: existing terminal index, to exclude nearby candidate locations from tmp0.
        for tmp1 in range(len(objectiveResourcePositionList)):
            #Terminals must be at least x meters apart
            # tmp0: remaining candidate positions after excluding points too close to terminal tmp1.
            tmp0.remove(tmp0.filter(lambda x: distance(x, objectiveResourcePositionList[tmp1]) < testPos2))
        if len(tmp0) > 0:
            #Successfully find new terminal location
            objectiveResourcePositionList.append(random.choice(tmp0))
        else:
            #Could not find new terminal location. Remove previous
            del objectiveResourcePositionList[len(objectiveResourcePositionList) - 1]
            testPos2 -= 5
    if len(objectiveResourcePositionList) > 3:
        objectiveResourcePositionList = []
        objectiveCaptureValue = [0, 0, 0]
    if ruleCondition:
        loop()


rule "PLAYERS AT TERMINALS CONTROLS":
    @Event eachPlayer
    @Team 1
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SATELLITE_UPLINK
    @Condition isObjectiveComplete == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.invisible != true
    @Condition (objectiveResourcePositionList.filter(lambda _, i: objectiveCaptureValue[i] < 100).any(lambda x: distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)) == true
    
    if not eventPlayer in objectivePlayerList:
        objectivePlayerList.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    objectivePlayerList.remove(eventPlayer)


rule "PLAYERS REPAIR TERMINALS":
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SATELLITE_UPLINK
    @Condition isObjectiveComplete == false
    @Condition len(objectivePlayerList) > 0
    
    #Check each terminal
    # tmp0: terminal index, to update its repair progress and announce its completion.
    for tmp0 in range(len(objectiveResourcePositionList)):
        if objectiveCaptureValue[tmp0] < 100:
            if objectivePlayerList.any(lambda x: distance(objectiveResourcePositionList[tmp0], x.getPosition()) < objectiveRad):
                if len(objectivePlayerList.filter(lambda x: distance(objectiveResourcePositionList[tmp0], x.getPosition()) < objectiveRad)) > 1:
                    #2 or more players on the terminal
                    objectiveCaptureValue[tmp0] += 0.4
                #Base Repair Speed
                objectiveCaptureValue[tmp0] += 1.1
                #If terminal is repaired
                if objectiveCaptureValue[tmp0] >= 100:
                    objectiveCaptureValue[tmp0] = 100
                    bigMessage(getAllPlayers(), "A terminal is back online!")
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, objectiveColor, objectiveResourcePositionList[tmp0], objectiveRad * 2)
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, objectiveColor, objectiveResourcePositionList[tmp0], 100)
    #All terminals repaired
    if objectiveCaptureValue.all(lambda x: x >= 100):
        wait(1)
        bigMessage(getAllPlayers(), "All terminals are back online!")
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, objectiveColor, objectivePositionList[0], 200)
        fireSatelliteMacro()
        isObjectiveComplete = true
    wait(0.5)
    if ruleCondition:
        loop()
