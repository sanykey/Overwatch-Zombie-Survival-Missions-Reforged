#!mainFile "../main.opy"

subroutine nukeMap


rule "PLAYERS IN EXTRACTION POINT CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition isObjectiveComplete == false
    @Condition isGameplayActive == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition objectiveTypeList[0] == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositionList) == 1
    @Condition objectivePositionList[0].y - eventPlayer.getEyePosition().y < 2
    @Condition distance(eventPlayer.getPosition(), vect(objectivePositionList[0].x, eventPlayer.getPosition().y, objectivePositionList[0].z)) < objectiveRad
    
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
    @Condition distance(objectivePositionList[0], eventPlayer.getPosition()) > extractionZoneRad
    @Condition eventPlayer in objectivePlayerList == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.infectionLvl++
    if not eventPlayer.infected and eventPlayer.infectionLvl >= 1:
        eventPlayer.infected = true
    #Kick players out of the spawn room if dome is closing in.
    while eventPlayer.isInSpawnRoom():
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition() + directionTowards(eventPlayer.getPosition(), objectivePositionList[0]) * 10))
        wait(0.125)
    loop()


# Animate successful extraction: lift survivors, gather them in a circle above the
# extraction point, then fly them away toward extractionFlightDestination. Changes to extractionFlightSpeed
# in WIN/LOSS CONDITIONS synchronize the movement phases.
rule "PLAYER EXTRACTION CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer in evacSurvivorList == true
    
    eventPlayer.chase2 = eventPlayer.getPosition()
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), extractionFlightSpeed)
    eventPlayer.startForcingPosition(eventPlayer.chase2)
    waitUntil(extractionFlightSpeed > 2, 99999)
    chaseOverTime(eventPlayer.chase2, objectivePositionList[0] + vect(0, 50, 0) + directionFromAngles(360 / len(evacSurvivorList) * evacSurvivorList.index(eventPlayer), 0) * 3, 5)
    waitUntil(extractionFlightSpeed < 10, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), extractionFlightSpeed)
    eventPlayer.evacPos = eventPlayer.chase2 + directionTowards(objectivePositionList[0], extractionFlightDestination) * 700
    waitUntil(extractionFlightSpeed > 2, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.evacPos, extractionFlightSpeed)


rule "WIN/LOSS CONDITIONS":
    @Condition isObjectiveComplete == false
    @Condition isGameplayActive == true
    @Condition (len(objectivePositionList) == 1 and (len(objectivePlayerList) == (len(getPlayers(Team.1).filter(lambda player: player.hasSpawned() and player.deathTimer > 0 and not player.afk)))) or (len(playerTargetList) == 0 or extractionZoneRad <= 0)) == true
    
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
        getPlayers(Team.1).teleport(vect(0, 500, 0))
        getAllPlayers().setInvisibility(Invis.ALL)
        wait(0.25)
        getPlayers(Team.1).resurrect()
        getPlayers(Team.1).startCamera(mapGridList + ((directionFromAngles(localPlayer.getHorizontalFacingAngle() * -2 + getTotalTimeElapsed() * -7.5, -30)) * 200), mapGridList, 10)
        startRule(nukeMap, StartRuleBehavior.NOOP)
        wait(8)
        declareTeamVictory(Team.2)
        setTeamScore(Team.2, 9)
        declareRoundVictory(Team.2)
        declareRoundVictory(Team.2)
        declareRoundVictory(Team.2)
        declareRoundVictory(Team.2)
        declareRoundVictory(Team.2)
    else:
        (getPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(objectivePositionList[0], vect(player.getPosition().x, objectivePositionList[0].y, player.getPosition().z)) < objectiveRad)).resurrect()
        getAllPlayers().enableKillFeed()
        wait()
        extractionFlightDestination = objectivePositionList[0] + vect(0, 250, 0) + directionFromAngles(random.uniform(0, 360), 0) * 500
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
        declareRoundVictory(Team.1)
        declareRoundVictory(Team.1)
        declareRoundVictory(Team.1)
        declareRoundVictory(Team.1)
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
