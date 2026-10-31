#!mainFile "main.opy"



macro fireSatelliteMacro():
    wait(1)
    smallMessage(getAllPlayers(), "Connecting to satellite...")
    wait(2)
    smallMessage(getAllPlayers(), "Connection established!")
    objectiveChase1 = objectivePositions[0]
    #Terminal connection beams
    for objectiveCount1 in range(len(objectiveResourcePositions)):
        createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0), objectiveResourcePositions[evalOnce(objectiveCount1)] + vect(0, 0, 0), objectiveColor, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
    wait(1)
    smallMessage(getAllPlayers(), "Preparing to fire...")
    wait(0.5)
    bigMessage(getAllPlayers(), "Stand clear of the laser")
    #Warning icon
    createIcon(getAllPlayers(), objectiveChase1 + vect(0, 1, 0), Icon.WARNING, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE)
    objectiveEntities.append(getLastCreatedEntity())
    #Laser distance
    createInWorldText(getAllPlayers(), "Danger: {0}m".format(distance(objectiveChase1, localPlayer.getPosition())), objectiveChase1, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    objectiveEntities.append(getLastCreatedText())
    #Laser center beam
    createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * 1, objectiveChase1 + vect(0, -700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * 1, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    objectiveEntities.append(getLastCreatedEntity())
    #Laser center beam
    createBeam(getAllPlayers(), Beam.BAD, objectiveChase1 + vect(0, 700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * -1, objectiveChase1 + vect(0, -700, 0) + directionFromAngles(getTotalTimeElapsed() * 360, 0) * -1, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    objectiveEntities.append(getLastCreatedEntity())
    #Sattellite firing light shafts
    for objectiveCount1 in range(-1, 5):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.AQUA, objectiveChase1 + (vect(0, -15 + 20 * evalOnce(objectiveCount1), 0)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
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
        testPos2 = raycastHitPosition(objectiveChase1 + vect(0, 2, 0), objectiveChase1 + vect(0, -100, 0), getAllPlayers(), getAllPlayers().filter(lambda player: player.isOnGround()), false) + vect(0, 0.1, 0)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, testPos2, 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.SKY_BLUE, testPos2, 200)
        #Damage Zombies
        damage(getPlayers(Team.2).filter(lambda player: distance(player.getPosition(), testPos2) < 5), null, 500)
        #Damage Players
        damage(getPlayers(Team.1).filter(lambda player: distance(player.getPosition(), testPos2) < 5), null, 70)
        if objectiveCount1 > 5:
            #Give all bots quick respawn time
            getPlayers(Team.2).reviveTimer = 1
        else:
            #Give all bots a long respawn time
            getPlayers(Team.2).reviveTimer = 12
            spawnTimes = spawnTimes.map(lambda _: 12)
    stopChasing(objectiveChase1)


rule "SET UP TERMINAL POSITIONS":
    @Condition objectiveTypes[0] == 7
    @Condition gameStatus == true
    @Condition objectiveComplete == false
    @Condition (len(objectiveCaptureValue) != len(objectiveResourcePositions) or objectiveResourcePositions.any(lambda x: x.x == null)) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    testPos = mapGrid.filter(lambda x: distance(x, objectivePositions[0]) > 10 and distance(x, objectivePositions[0]) < 50)
    if len(objectiveResourcePositions) == 0:
        objectiveResourcePositions.append(random.choice(testPos))
    else:
        for objectiveCount1 in range(len(objectiveResourcePositions)):
            #Terminals must be at least x meters apart
            testPos.remove(testPos.filter(lambda x: distance(x, objectiveResourcePositions[objectiveCount1]) < testPos2))
        if len(testPos) > 0:
            #Successfully find new terminal location
            objectiveResourcePositions.append(random.choice(testPos))
        else:
            #Could not find new terminal location. Remove previous
            del objectiveResourcePositions[len(objectiveResourcePositions) - 1]
            testPos2 -= 5
    if len(objectiveResourcePositions) > 3:
        objectiveResourcePositions = []
        objectiveCaptureValue = [0, 0, 0]
    if ruleCondition:
        loop()


rule "PLAYERS AT TERMINALS CONTROLS":
    @Event eachPlayer
    @Team 1
    @Condition objectiveTypes[0] == 7
    @Condition objectiveComplete == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.invisible != true
    @Condition (objectiveResourcePositions.filter(lambda _, i: objectiveCaptureValue[i] < 100).any(lambda x: distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)) == true
    
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    playersOnObjective.remove(eventPlayer)


rule "PLAYERS REPAIR TERMINALS":
    @Condition objectiveTypes[0] == 7
    @Condition objectiveComplete == false
    @Condition len(playersOnObjective) > 0
    
    #Check each terminal
    for objectiveCount1 in range(len(objectiveResourcePositions)):
        if objectiveCaptureValue[objectiveCount1] < 100:
            if playersOnObjective.any(lambda x: distance(objectiveResourcePositions[objectiveCount1], x.getPosition()) < objectiveRad):
                if len(playersOnObjective.filter(lambda x: distance(objectiveResourcePositions[objectiveCount1], x.getPosition()) < objectiveRad)) > 1:
                    #2 or more players on the terminal
                    objectiveCaptureValue[objectiveCount1] += 0.4
                #Base Repair Speed
                objectiveCaptureValue[objectiveCount1] += 1.1
                #If terminal is repaired
                if objectiveCaptureValue[objectiveCount1] >= 100:
                    objectiveCaptureValue[objectiveCount1] = 100
                    bigMessage(getAllPlayers(), "A terminal is back online!")
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, objectiveColor, objectiveResourcePositions[objectiveCount1], objectiveRad * 2)
                    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, objectiveColor, objectiveResourcePositions[objectiveCount1], 100)
    #All terminals repaired
    if objectiveCaptureValue.all(lambda x: x >= 100):
        wait(1)
        bigMessage(getAllPlayers(), "All terminals are back online!")
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, objectiveColor, objectivePositions[0], 200)
        fireSatelliteMacro()
        objectiveComplete = true
    wait(0.5)
    if ruleCondition:
        loop()
