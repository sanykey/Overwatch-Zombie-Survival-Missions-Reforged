#!mainFile "main.opy"

subroutine generateMapGrid

macro setAvailableObjectivesMacro():
    #Set objective type votes empty
    objectiveTypeVotes[0] = [null, true]
    #Set objective type votes empty
    objectiveTypeVotes[1] = [null, createWorkshopSettingBool("Available Objective Types", "Showdown", true)]
    #Set objective type votes empty
    objectiveTypeVotes[2] = [null, createWorkshopSettingBool("Available Objective Types", "Bosses", true, 1)]
    #Set objective type votes empty
    objectiveTypeVotes[5] = [null, createWorkshopSettingBool("Available Objective Types", "Kill Zone", true, 4)]
    #Set objective type votes empty
    objectiveTypeVotes[6] = [null, createWorkshopSettingBool("Available Objective Types", "Zombie Egg", true, 5)]
    #Set objective type votes empty
    objectiveTypeVotes[7] = [null, createWorkshopSettingBool("Available Objective Types", "Satellite Uplink", true, 6)]
    #Set objective type votes empty
    objectiveTypeVotes[9] = [null, createWorkshopSettingBool("Available Objective Types", "Mixed Objectives", true, 8)]
    #Mixed Objectives pool
    mixedObjectivesPool = [
        1 if createWorkshopSettingBool("Mixed Objectives Pool", "Standoff.", true, 1) else 0,
        2 if createWorkshopSettingBool("Mixed Objectives Pool", "Bosses.", true, 2) else 0,
        3 if createWorkshopSettingBool("Mixed Objectives Pool", "Biomorphing.", true, 3) else 0,
        4 if createWorkshopSettingBool("Mixed Objectives Pool", "Survivor Rescue.", true, 4) else 0,
        5 if createWorkshopSettingBool("Mixed Objectives Pool", "Kill Zone.", true, 5) else 0,
        6 if createWorkshopSettingBool("Mixed Objectives Pool", "Zombie Egg.", true, 6) else 0,
        7 if createWorkshopSettingBool("Mixed Objectives Pool", "Satellite Uplink.", true, 7) else 0,
    ]
    #Removed disabled objectives
    mixedObjectivesPool.remove(0)


macro enableEnhancementsMacro():
    enhancementOptions = [
        iconString(Icon.QUESTION_MARK),
        iconString(Icon.STOP),
        iconString(Icon.POISON),
        iconString(Icon.DIAMOND),
        iconString(Icon.SKULL),
        iconString(Icon.FIRE),
        iconString(Icon.PLUS),
        iconString(Icon.BOLT),
        iconString(Icon.SPIRAL),
        iconString(Icon.FLAG),
        iconString(Icon.HAPPY),
    ]


macro botHeroRandomizationMacro():
    currentBotHeroList = botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)
    if gameSmolderEvent:
        createDummy(Hero.WINSTON, Team.2, -1, vect(500, 500, 500))
    #Determines if count of current different zombie types is less than the maximum amount allowed
    elif len(currentBotHeroList) < (uniqueSkinCap - (getNumberOfSlots(Team.1) if getNumberOfPlayers(Team.1) <= getNumberOfSlots(Team.1) else getNumberOfPlayers(Team.1))):
        randVal = random.uniform(0, 100)
        botCurrentSpawnRate = 0
        botRespawnCount = -1
        while randVal > botCurrentSpawnRate or botRespawnCount < 0:
            botRespawnCount++
            botCurrentSpawnRate += botSpawnRates[botRespawnCount]
        createDummy(botHeros[botRespawnCount], Team.2, -1, vect(500, 500, 500))
    else:
        createDummy(sorted(botHeros, lambda _, i: botSpawnRates[i]).last(), Team.2, -1, vect(500, 500, 500))
    currentBotHeroList = []


macro enableMutationsMacro():
    availableMutations = [
        1 if createWorkshopSettingBool("Mutations", "Speed", true) else 0,
        2 if createWorkshopSettingBool("Mutations", "Size Growth", true, 1) else 0,
        3 if createWorkshopSettingBool("Mutations", "Size Reduction", true, 2) else 0,
        4 if createWorkshopSettingBool("Mutations", "Radioactive", true, 3) else 0,
        5 if createWorkshopSettingBool("Mutations", "Heavy", true, 4) else 0,
    ]
    availableMutations.remove(0)


macro enablePowerupsMacro():
    for I in range(13):
        availablePowerups[I] = I + 1

rule "PREGAME QUICK TIPS FOR PLAYERS":
    @Condition specialGameModeSetup == true
    
    wait(10, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Quick Tip: {0}".format(random.choice(["Hold [{0}] while voting to cycle backwards.".format(inputBindingString(Button.SECONDARY_FIRE)), "Hold [{0}] for 5 seconds to switch heroes while in game.".format(inputBindingString(Button.RELOAD)), "Hacked zombies cannot infect players.", "Overheal abilities protect players from infection."])))
    loop()


rule "SPAWN BOTS":
    @Condition gameStatus == true
    @Condition getAverageServerLoad() <= createWorkshopSettingInt("General", "Spawn Zombies When Server Load Average is Less Than", 180, 100, 255, 2)
    #@Condition getNumberOfPlayers(Team.2) < numberOfBots
    @Condition getNumberOfPlayers(Team.ALL) < 24
    @Condition (len(spawnTimes) > 0 and spawnTimes[0] <= 0 or len(spawnTimes) + getNumberOfPlayers(Team.2) < numberOfBots) == true
    
    botHeroRandomizationMacro()
    if len(spawnTimes) > 0 and spawnTimes[0] <= 0:
        del spawnTimes[0]
        wait(0.25)
    else:
        wait(3)
    if ruleCondition:
        loop()
    wait(sorted(spawnTimes).last(), Wait.RESTART_WHEN_TRUE)
    #Reset spawn times array if conditions are not met
    if len(spawnTimes) > 0:
        spawnTimes[0] = 0
    if ruleCondition:
        loop()


rule "SPAWN TIME CONTROL":
    @Condition (len(spawnTimes) > 0 or botSpawnPointTimers > 0) == true
    
    if len(spawnTimes) > 0:
        spawnTimes = sorted(spawnTimes.map(lambda x: x - 1))
    if len(botSpawnPointTimers) > 0:
        botSpawnPointTimers = botSpawnPointTimers.map(lambda x: max(0, x - 1))
    wait(1)
    if ruleCondition:
        loop()


rule "START GAME IF WAITING FOR PLAYERS":
    @Condition isWaitingForPlayers() == true
    
    disableGamemodeCompletion()
    disableScoring()
    disableAnnouncer()
    startGamemode()
    wait(1)
    if ruleCondition:
        loop()


rule "SKIP ASSEMBLING HEROES":
    @Condition (isAssemblingHeroes() or specialGameModeSetup and len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus)) == 0) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    voting = true
    enableEnhancementsMacro()
    #Set difficulty votes empty
    challengeVotes = [[null, true], [null, true], [null, createWorkshopSettingBool("Challenge Toggle", "Swarm Shootout", true, 1)], [null, createWorkshopSettingBool("Challenge Toggle", "Random Abilities", true, 2)], [null, createWorkshopSettingBool("Challenge Toggle", "Insanity", true, 3)], [null, createWorkshopSettingBool("Challenge Toggle", "Pandora's Box", true, 4)]]
    #Set zombie modes empty
    zombieVotes = [[null, true], [null, "All Zombies"], [null, createWorkshopSettingBool("Zombie Mode Toggle", "New Blood", true, 1)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "What'll it be?", true, 2)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Zombie Shuffle", true, 3)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Dinner Rush!", true, 4)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Ham N' Hammer!", true, 5)]]
    setAvailableObjectivesMacro()
    #Set/Reset to default 0
    difficultySetting = 0
    #Set/Reset to default 0
    zombieSetting = 0
    #Set/Reset to default 0
    objectiveTypeSetting = 0
    if isAssemblingHeroes():
        disableInspector()
        setMatchTime(0)
        specialGameModeSetup = true
        wait(0.25)
    if (specialGameMode == true or getCurrentGamemode() == Gamemode.FLASHPOINT) and isInSetup():
        setMatchTime(0)
        wait(0.25)
    setMatchTime(3599)
    waitUntil(len(getPlayers(Team.1).filter(lambda player: player.hasSpawned())) > 0 and len(mapGrid) > 0, 99999)
    setMatchTime(60)
    wait()
    chase1 = getMatchTime()
    chaseAtRate(chase1, 0, 1, ChaseRateReeval.NONE)
    disableAnnouncer()
    disableGamemodeCompletion()


rule "PREGAME SPAWN ROOM ROTATION":
    @Condition specialGameModeSetup == true
    #Does not apply if game mode is special gamemode
    @Condition specialGameMode != true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    createDummy(Hero.ANA, Team.2, -1, vect(0, 500, 0))
    attackSpawnRooms = []
    spawnRoomIndex = 0
    #Records spawn room locations
    while len(attackSpawnRooms) < (2 if getCurrentGamemode() == Gamemode.ASSAULT else 3):
        startForcingSpawn(Team.2, spawnRoomIndex)
        wait(0.25)
        getPlayers(Team.2).respawn()
        while not getPlayers(Team.2)[0].isInSpawnRoom():
            wait()
        attackSpawnRooms.append(getPlayers(Team.2)[0].getPosition())
        spawnRoomIndex++
    #Accounts for first attack spawn rooms generally being bigger than other spawn rooms
    attackSpawnRooms[0] += directionTowards(attackSpawnRooms[0], getObjectivePosition(0)) * 10
    wait(0.25)
    destroyAllDummies()
    #Rotates spawn rooms while waiting for game to start
    while specialGameModeSetup:
        spawnRoomIndex++
        if getCurrentGamemode() == Gamemode.ASSAULT and spawnRoomIndex > 1 or spawnRoomIndex > 2:
            spawnRoomIndex = 0
        #Open all spawn rooms
        startForcingSpawn(Team.ALL, spawnRoomIndex)
        wait(1)
    #Change active spawn room to a location
    activeAttackSpawnRoom = attackSpawnRooms[spawnRoomIndex]


rule "VARIABLE ASSIGNMENT":
    if getCurrentGamemode() == Gamemode.CTF:
        attackSpawnRooms = sorted(getSpawnPoints(Team.2), lambda x: distance(x, getFlagPosition(Team.2)))[0]
    elif getCurrentGamemode() == Gamemode.TDM:
    else:
        matchEndTime = 0.1
    #Determines if current game mode is base or arcade
    specialGameMode = true if getCurrentGamemode() in [Gamemode.TDM, Gamemode.CTF, Gamemode.PUSH, Gamemode.CONTROL] else false
    #Total amount of powerups
    availablePowerups = 11
    amountPerResource = 25
    #Initial extraction zone radius
    extractionZoneRad = 300
    objectiveResourcePositions = []
    votingEndTime = 30
    #Relative center of the map
    while walkCenter == null:
        wait(1)
        walkCenter = (nearestWalkablePosition(vect(999, 999, 999)) + nearestWalkablePosition(vect(-999, -999, -999))) / 2
        smallMessage(getAllPlayers(), "Map Grid is being made...")
    if getCurrentGamemode() == Gamemode.CONTROL:
        walkCenter = getObjectivePosition(getCurrentObjective())
    startRule(generateMapGrid, StartRuleBehavior.NOOP)
    #objectiveValue = 0  #Uninitialized Workshop variables already compare equal to 0 at match start.
    objectiveEntities = []
    botSpawnPoints = []
    waypoints = []
    botSpawnPointTimers = []
    bosses = []
    healthpackPositions = []
    #overtime = false  #Uninitialized Workshop variables already compare equal to false at match start.
    #gameStatus = false  #Uninitialized Workshop variables already compare equal to false at match start.
    users = []
    globalPlayerStats = []
    for I in range(12):
        globalPlayerStats.append(-1)
    objectivePositions = []
    objectiveTypes = []
    objectiveRad = 10
    reviveRadius = 5
    mustReviveTime = 60
    playersOnObjective = []
    losList = []
    botMaxTeleportRange = [20, 40]
    supplyDropStatus = true
    #supplyDropLanding = null  #Uninitialized Workshop variables already compare equal to null at match start.
    #supplyDropPosition = null  #Uninitialized Workshop variables already compare equal to null at match start.
    powerUpIDs = []
    powerUpPositions = []
    powerUpEffect = []
    powerUpText = []
    playerTargetList = []
    availableBosses = []
    spawnTimes = []
    customTelePositions = []
    losHeightCheck = 1.2
    enablePowerupsMacro()
    enableMutationsMacro()
    numberOfPowerUpsPerSupplyDrop = createWorkshopSettingInt("Power Ups", "Number of Powerups Per Supply Drop", 5, 1, 10, -1)
    uniqueSkinCap = createWorkshopSettingInt("General", "Maximum Number of Unique Hero Skins", 11, 1, 11)
    #objectiveComplete = false  #Uninitialized Workshop variables already compare equal to false at match start.
    numberOfBots = createWorkshopSettingInt("General", "Number of zombies", 6, 1, 23, 1)
    extractionSpeedUp = 2.5


rule "START GAME":
    @Condition specialGameModeSetup != false
    @Condition getMatchTime() <= 0.1
    @Condition len(getPlayers(Team.1).filter(lambda player: player.hasSpawned())) > 0
    
    if isInSetup():
        setMatchTime(0)
        wait(0.25)
    disableScoring()
    disableAnnouncer()
    pauseMatchTime()
    walkCenter = nearestWalkablePosition(walkCenter)
    specialGameModeSetup = false
    enableMusic()
    disableInspector()
    #enableInspector()
    destroyAllDummies()
    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllIcons()
    destroyAllInWorldTexts()
    wait(0.25)
    setMatchTime(startTime + matchEndTime)
    unpauseMatchTime()
    #Disabled survivor spawn room healing zone
    startForcingSpawn(Team.1, Color.BLUE)
    #Objective Description
    setObjectiveDescription(getAllPlayers(), objectiveDescription, HudReeval.VISIBILITY_AND_STRING)
    wait(5)
    disableMusic()


def generateMapGrid():
    @Name "generateMapGrid"
    
    mapGrid = []
    while len(mapGrid) < 900:
        testPos = nearestWalkablePosition((random.choice(mapGrid) if len(mapGrid) > 5 else walkCenter) + directionFromAngles(random.uniform(0, 360), random.uniform(-35, 35)) * random.uniform(10, 100))
        #Do not grid points inside spawn rooms on CTF maps
        if getCurrentGamemode() != Gamemode.CTF and getCurrentGamemode() != Gamemode.CLASH and getCurrentGamemode() != Gamemode.PUSH and getCurrentGamemode() != Gamemode.CONTROL and getCurrentGamemode() != Gamemode.FLASHPOINT or getSpawnPoints(Team.2).all(lambda x: distance(x.getPosition(), testPos) > 50) and getSpawnPoints(Team.1).all(lambda x: distance(x.getPosition(), testPos) > 40):
            if len(mapGrid) == 0 or mapGrid.all(lambda x: distance(x, testPos) > 2.5):
                mapGrid.append(testPos)
        if specialGameModeSetup and getMatchTime() + matchEndTime < 2:
            break
        wait()
    #0: Consecutive, 1: Minimum
    objectiveSpacing = [min(60, len(mapGrid) / 11), min(30, len(mapGrid) / 20)]
