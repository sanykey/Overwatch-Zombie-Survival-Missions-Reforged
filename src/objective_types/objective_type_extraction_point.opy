#!mainFile "../main.opy"

subroutine nukeMap


rule "PLAYERS IN EXTRACTION POINT CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition objectiveComplete == false
    @Condition isGameplayActive == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.SHOWDOWN
    @Condition len(objectivePositions) == 1
    @Condition objectivePositions[0].y - eventPlayer.getEyePosition().y < 2
    @Condition distance(eventPlayer.getPosition(), vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z)) < objectiveRad
    
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    extractionSpeedUp += 0.2 / len(playerTargetList)
    wait(0.5)
    if ruleCondition:
        loop()
    if isGameplayActive:
        playersOnObjective.remove(eventPlayer)


rule "EXTRACTION ZONE INFECTION INCREASE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition len(objectivePositions) == 1
    @Condition extractionZoneRad < 200
    @Condition distance(objectivePositions[0], eventPlayer.getPosition()) > extractionZoneRad
    @Condition eventPlayer in playersOnObjective == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.infectionLvl++
    if not eventPlayer.infected and eventPlayer.infectionLvl >= 1:
        eventPlayer.infected = true
    #Kick players out of the spawn room if dome is closing in.
    while eventPlayer.isInSpawnRoom():
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition() + directionTowards(eventPlayer.getPosition(), objectivePositions[0]) * 10))
        wait(0.125)
    loop()


# Animate successful extraction: lift survivors, gather them in a circle above the
# extraction point, then fly them away toward evacDestination. Changes to evacRate
# in WIN/LOSS CONDITIONS synchronize the movement phases.
rule "PLAYER EXTRACTION CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer in evacSurvivorList == true
    
    eventPlayer.chase2 = eventPlayer.getPosition()
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), evacRate)
    eventPlayer.startForcingPosition(eventPlayer.chase2)
    waitUntil(evacRate > 2, 99999)
    chaseOverTime(eventPlayer.chase2, objectivePositions[0] + vect(0, 50, 0) + directionFromAngles(360 / len(evacSurvivorList) * evacSurvivorList.index(eventPlayer), 0) * 3, 5)
    waitUntil(evacRate < 10, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), evacRate)
    eventPlayer.evacPos = eventPlayer.chase2 + directionTowards(objectivePositions[0], evacDestination) * 700
    waitUntil(evacRate > 2, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.evacPos, evacRate)


rule "WIN/LOSS CONDITIONS":
    @Condition objectiveComplete == false
    @Condition isGameplayActive == true
    @Condition (len(objectivePositions) == 1 and (len(playersOnObjective) == (len(getPlayers(Team.1).filter(lambda player: player.hasSpawned() and player.deathTimer > 0 and not player.afk)))) or (len(playerTargetList) == 0 or extractionZoneRad <= 0)) == true
    
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
    bigMessage(getPlayers(Team.1).filter(lambda player: playerTargetList > 0 and not player in playersOnObjective), "You were left behind!")
    getPlayers(Team.1).setStatusEffect(null, Status.ROOTED, 99999)
    getPlayers(Team.1).setStatusEffect(null, Status.PHASED_OUT, 99999)
    if len(playerTargetList) == 0 or playersOnObjective == []:
        getPlayers(Team.1).teleport(vect(0, 500, 0))
        getAllPlayers().setInvisibility(Invis.ALL)
        wait(0.25)
        getPlayers(Team.1).resurrect()
        getPlayers(Team.1).startCamera(mapGrid + ((directionFromAngles(localPlayer.getHorizontalFacingAngle() * -2 + getTotalTimeElapsed() * -7.5, -30)) * 200), mapGrid, 10)
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
        (getPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(objectivePositions[0], vect(player.getPosition().x, objectivePositions[0].y, player.getPosition().z)) < objectiveRad)).resurrect()
        getAllPlayers().enableKillFeed()
        wait()
        evacDestination = objectivePositions[0] + vect(0, 250, 0) + directionFromAngles(random.uniform(0, 360), 0) * 500
        evacRate = 2
        evacSurvivorList = playersOnObjective
        (getPlayers(Team.1).filter(lambda player: not evacSurvivorList[player])).clearStatusEffect(Status.ROOTED)
        wait(1)
        evacRate = 10
        wait(5)
        evacRate = 2
        wait(2)
        startRule(nukeMap, StartRuleBehavior.NOOP)
        evacRate = 50
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
    stopChasing(chase1)
    chase1 = mapGrid + directionFromAngles(random.randint(0, 359), random.uniform(-45, -60)) * 500
    wait()
    chaseOverTime(chase1, mapGrid, 5)
    while distance(chase1, mapGrid) > 1:
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.SKY_BLUE, chase1, 3)
        wait()
    for evacCount in range(400):
        kill(getPlayers(Team.1).filter(lambda player: not player in evacSurvivorList))
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, rgb(255, random.uniform(100, 255), 0), mapGrid + (directionFromAngles(random.uniform(0, 360), 0) * (random.randint(0, (evacCount / 20) ** 2 + 1))), (evacCount / 18) ** 2)
        wait()
