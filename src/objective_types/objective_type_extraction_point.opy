#!mainFile "../main.opy"

subroutine nukeMap


rule "PLAYERS IN EXTRACTION POINT CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition isObjectiveComplete == false
    @Condition isGameplayActive == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition currentObjectiveType == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositionList) == 1
    @Condition currentObjectivePosition.y - eventPlayer.getEyePosition().y < 2
    @Condition distance(eventPlayer.getPosition(), vect(currentObjectivePosition.x, eventPlayer.getPosition().y, currentObjectivePosition.z)) < objectiveRad
    
    if not eventPlayer in objectivePlayerList:
        objectivePlayerList.append(eventPlayer)
    extractionSpeedUp += 0.2 / len(playerTargetList)
    wait(0.5)
    if ruleCondition:
        loop()
    if isGameplayActive:
        objectivePlayerList.remove(eventPlayer)


rule "EXTRACTION ZONE INFECTION INCREASE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition len(objectivePositionList) == 1
    @Condition extractionZoneRad < 200
    @Condition distance(currentObjectivePosition, eventPlayer.getPosition()) > extractionZoneRad
    @Condition eventPlayer in objectivePlayerList == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.infectionLevel++
    if not eventPlayer.isInfected and eventPlayer.infectionLevel >= 1:
        eventPlayer.isInfected = true
    #Kick players out of the spawn room if dome is closing in.
    while eventPlayer.isInSpawnRoom():
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition() + directionTowards(eventPlayer.getPosition(), currentObjectivePosition) * 10))
        wait(0.125)
    loop()


# Animate successful extraction: lift survivors, gather them in a circle above the
# extraction point, then fly them away toward extractionFlightDestination. Changes to extractionFlightSpeed
# in WIN/LOSS CONDITIONS synchronize the movement phases.
rule "PLAYER EXTRACTION CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer in evacSurvivorList == true
    
    eventPlayer.extractionFlightPosition = eventPlayer.getPosition()
    chaseAtRate(eventPlayer.extractionFlightPosition, eventPlayer.extractionFlightPosition + 200 * Vector.UP, extractionFlightSpeed)
    eventPlayer.startForcingPosition(eventPlayer.extractionFlightPosition)
    waitUntil(extractionFlightSpeed > 2, 99999)
    chaseOverTime(eventPlayer.extractionFlightPosition, currentObjectivePosition + 50 * Vector.UP + directionFromAngles(360 / len(evacSurvivorList) * evacSurvivorList.index(eventPlayer), 0) * 3, 5)
    waitUntil(extractionFlightSpeed < 10, 99999)
    chaseAtRate(eventPlayer.extractionFlightPosition, eventPlayer.extractionFlightPosition + 200 * Vector.UP, extractionFlightSpeed)
    eventPlayer.extractionDestination = eventPlayer.extractionFlightPosition + directionTowards(currentObjectivePosition, extractionFlightDestination) * 700
    waitUntil(extractionFlightSpeed > 2, 99999)
    chaseAtRate(eventPlayer.extractionFlightPosition, eventPlayer.extractionDestination, extractionFlightSpeed)


rule "WIN/LOSS CONDITIONS":
    @Condition isObjectiveComplete == false
    @Condition isGameplayActive == true
    @Condition (len(objectivePositionList) == 1 and (len(objectivePlayerList) == (len(getPlayers(Team.1).filter(lambda player: player.hasSpawned() and player.rescueTimeRemaining > 0 and not player.isAfk)))) or (len(playerTargetList) == 0 or extractionZoneRad <= 0)) == true
    
    if (len(playerTargetList) == 0 or playerTargetList == []) and getPlayersOnHero(Hero.ANRAN, Team.1).any(lambda player: player.getUltCharge() == 100):
        wait(5.5, Wait.ABORT_WHEN_FALSE)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    isGameplayActive = false
    enableAnnouncer()
    getAllPlayers().disableNameplatesFor(getAllPlayers())
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableKillFeed()
    getAllPlayers().disableHeroHud()
    getAllPlayers().startForcingOutlineFor(getAllPlayers(), false, Color.WHITE)
    destroyAllEffects()
    destroyAllIcons()
    destroyAllInWorldTexts()
    destroyAllProgressBarHuds()
    destroyAllProgressBarInWorldTexts()
    destroyAllHudTexts()
    bigMessage(getPlayers(Team.1).filter(lambda player: playerTargetList > 0 and not player in objectivePlayerList), "You were left behind!")
    getPlayers(Team.1).setStatusEffect(null, Status.ROOTED, 99999)
    getPlayers(Team.1).setStatusEffect(null, Status.PHASED_OUT, 99999)
    if len(playerTargetList) == 0 or objectivePlayerList == []:
        getPlayers(Team.1).teleport(500 * Vector.UP)
        getAllPlayers().setInvisibility(Invis.ALL)
        wait(0.25)
        getPlayers(Team.1).resurrect()
        getPlayers(Team.1).startCamera(mapGridList + ((directionFromAngles(localPlayer.getHorizontalFacingAngle() * -2 + getTotalTimeElapsed() * -7.5, -30)) * 200), mapGridList, 10)
        startRule(nukeMap, StartRuleBehavior.NOOP)
        wait(8)
        declareTeamVictory(Team.2)
        setTeamScore(Team.2, 9)
        # Original author: Flashpoint needs multiple round-victory declarations to force the victory screen.
        # Keep all five calls; the loop replaces repeated actions to reduce the Workshop element count.
        #!define lossRoundVictoryIndex tmp0
        for lossRoundVictoryIndex in range(5):
            declareRoundVictory(Team.2)
    else:
        (getPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(currentObjectivePosition, vect(player.getPosition().x, currentObjectivePosition.y, player.getPosition().z)) < objectiveRad)).resurrect()
        getAllPlayers().enableKillFeed()
        wait()
        extractionFlightDestination = currentObjectivePosition + 250 * Vector.UP + directionFromAngles(random.uniform(0, 360), 0) * 500
        extractionFlightSpeed = 2
        evacSurvivorList = objectivePlayerList
        (getPlayers(Team.1).filter(lambda player: not evacSurvivorList[player])).clearStatusEffect(Status.ROOTED)
        wait(1)
        extractionFlightSpeed = 10
        wait(5)
        extractionFlightSpeed = 2
        wait(2)
        startRule(nukeMap, StartRuleBehavior.NOOP)
        extractionFlightSpeed = 50
        wait(8)
        declareTeamVictory(Team.1)
        setTeamScore(Team.1, 9)
        # Original author: Flashpoint needs multiple round-victory declarations to force the victory screen.
        # Keep all five calls; the loop replaces repeated actions to reduce the Workshop element count.
        #!define winRoundVictoryIndex tmp0
        for winRoundVictoryIndex in range(5):
            declareRoundVictory(Team.1)
    getAllPlayers().enableHeroHud()
    getAllPlayers().enableGamemodeHud()


def nukeMap():
    @Name "nukeMap"
    
    setMatchTime(60)
    unpauseMatchTime()
    # Release the countdown chase before handing its storage to the finale projectile.
    stopChasing(pregameCountdown)
    nukeProjectilePosition = mapGridList + directionFromAngles(random.randint(0, 359), random.uniform(-45, -60)) * 500
    wait()
    chaseOverTime(nukeProjectilePosition, mapGridList, 5)
    while distance(nukeProjectilePosition, mapGridList) > 1:
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.SKY_BLUE, nukeProjectilePosition, 3)
        wait()
    for finaleExplosionIndex in range(400):
        kill(getPlayers(Team.1).filter(lambda player: not player in evacSurvivorList))
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, rgb(255, random.uniform(100, 255), 0), mapGridList + (directionFromAngles(random.uniform(0, 360), 0) * (random.randint(0, (finaleExplosionIndex / 20) ** 2 + 1))), (finaleExplosionIndex / 18) ** 2)
        wait()
