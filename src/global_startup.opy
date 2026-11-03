#!mainFile "main.opy"

subroutine generateMapGrid

macro setAvailableObjectivesMacro():
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.NO_PREFERENCE] = [null, true]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.SHOWDOWN] = [null, createWorkshopSettingBool("Available Objective Types", "Showdown", true)]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.BOSSES] = [null, createWorkshopSettingBool("Available Objective Types", "Bosses", true, 1)]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.KILL_ZONE] = [null, createWorkshopSettingBool("Available Objective Types", "Kill Zone", true, 4)]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.ZOMBIE_EGG] = [null, createWorkshopSettingBool("Available Objective Types", "Zombie Egg", true, 5)]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.SATELLITE_UPLINK] = [null, createWorkshopSettingBool("Available Objective Types", "Satellite Uplink", true, 6)]
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.MIXED_OBJECTIVES] = [null, createWorkshopSettingBool("Available Objective Types", "Mixed Objectives", true, 8)]
    #Mixed Objectives pool
    # These objective IDs are consecutive (1-7), so each enabled setting uses its index plus one.
    mixedObjectiveTypeList = [
        createWorkshopSettingBool("Mixed Objectives Pool", "Standoff.", true, 1),
        createWorkshopSettingBool("Mixed Objectives Pool", "Bosses.", true, 2),
        createWorkshopSettingBool("Mixed Objectives Pool", "Biomorphing.", true, 3),
        createWorkshopSettingBool("Mixed Objectives Pool", "Survivor Rescue.", true, 4),
        createWorkshopSettingBool("Mixed Objectives Pool", "Kill Zone.", true, 5),
        createWorkshopSettingBool("Mixed Objectives Pool", "Zombie Egg.", true, 6),
        createWorkshopSettingBool("Mixed Objectives Pool", "Satellite Uplink.", true, 7),
    ].map(lambda enabled, i: i + 1 if enabled else ObjectiveType.NO_PREFERENCE)
    #Removed disabled objectives
    mixedObjectiveTypeList.remove(ObjectiveType.NO_PREFERENCE)


macro enableEnhancementsMacro():
    enhancementOptionList = [
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
    # spawnedBotHeroList: hero types already present among zombies, to check the unique-skin limit.
    #!define spawnedBotHeroList tmp0
    spawnedBotHeroList = botHeroList.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)
    if isSmolderEventActive:
        createDummy(Hero.WINSTON, Team.2, -1, dummyHoldingPositionConst)
    #Determines if count of current different zombie types is less than the maximum amount allowed
    elif len(spawnedBotHeroList) < (uniqueSkinCap - max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))):
        # botSpawnWeightRoll: random threshold for weighted hero selection; the hero list is no longer needed.
        #!define botSpawnWeightRoll tmp0
        botSpawnWeightRoll = random.uniform(0, 100)
        # botSpawnCumulativeWeight: cumulative spawn weight, compared with botSpawnWeightRoll to find the selected hero.
        #!define botSpawnCumulativeWeight tmp1
        botSpawnCumulativeWeight = 0
        # botSpawnHeroIndex: hero-table index, starting before the first entry so the loop visits index 0.
        #!define botSpawnHeroIndex tmp2
        botSpawnHeroIndex = -1
        while botSpawnWeightRoll > botSpawnCumulativeWeight or botSpawnHeroIndex < 0:
            # botSpawnHeroIndex: next hero-table index whose spawn weight must be included.
            botSpawnHeroIndex++
            # botSpawnCumulativeWeight: cumulative weight including this hero, to test whether botSpawnWeightRoll falls in its range.
            botSpawnCumulativeWeight += botSpawnRateList[botSpawnHeroIndex]
        createDummy(botHeroList[botSpawnHeroIndex], Team.2, -1, dummyHoldingPositionConst)
    else:
        createDummy(sorted(botHeroList, lambda _, i: botSpawnRateList[i]).last(), Team.2, -1, dummyHoldingPositionConst)


macro enableMutationsMacro():
    # Mutation IDs are consecutive (1-5) and follow the setting order.
    availableMutationList = [
        createWorkshopSettingBool("Mutations", "Speed", true),
        createWorkshopSettingBool("Mutations", "Size Growth", true, 1),
        createWorkshopSettingBool("Mutations", "Size Reduction", true, 2),
        createWorkshopSettingBool("Mutations", "Radioactive", true, 3),
        createWorkshopSettingBool("Mutations", "Heavy", true, 4),
    ].map(lambda enabled, i: i + 1 if enabled else 0)
    availableMutationList.remove(0)


rule "PREGAME QUICK TIPS FOR PLAYERS":
    @Condition isPregameSetup == true
    
    wait(10, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Quick Tip: {0}".format(random.choice(["Hold [{0}] while voting to cycle backwards.".format(inputBindingString(Button.SECONDARY_FIRE)), "Hold [{0}] for 5 seconds to switch heroes while in game.".format(inputBindingString(Button.RELOAD)), "Hacked zombies cannot infect players.", "Overheal abilities protect players from infection."])))
    loop()


rule "SPAWN BOTS":
    @Condition isGameplayActive == true
    @Condition getAverageServerLoad() <= createWorkshopSettingInt("General", "Spawn Zombies When Server Load Average is Less Than", 180, 100, 255, 2)
    #@Condition getNumberOfPlayers(Team.2) < numberOfBots
    @Condition getNumberOfPlayers(Team.ALL) < 24
    @Condition (len(botSpawnTimeList) > 0 and botSpawnTimeList[0] <= 0 or len(botSpawnTimeList) + getNumberOfPlayers(Team.2) < numberOfBots) == true
    
    botHeroRandomizationMacro()
    if len(botSpawnTimeList) > 0 and botSpawnTimeList[0] <= 0:
        del botSpawnTimeList[0]
        wait(0.25)
    else:
        wait(3)
    if ruleCondition:
        loop()
    wait(sorted(botSpawnTimeList).last(), Wait.RESTART_WHEN_TRUE)
    #Reset spawn times array if conditions are not met
    if len(botSpawnTimeList) > 0:
        botSpawnTimeList[0] = 0
    if ruleCondition:
        loop()


rule "SPAWN TIME CONTROL":
    @Condition (len(botSpawnTimeList) > 0 or botSpawnPointTimerList > 0) == true
    
    if len(botSpawnTimeList) > 0:
        botSpawnTimeList = sorted(botSpawnTimeList.map(lambda x: x - 1))
    if len(botSpawnPointTimerList) > 0:
        botSpawnPointTimerList = botSpawnPointTimerList.map(lambda x: max(0, x - 1))
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
    @Condition (isAssemblingHeroes() or isPregameSetup and not getPlayers(Team.1).any(lambda player: player.isPlayerActive)) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    isVoting = true
    enableEnhancementsMacro()
    #Set difficulty votes empty
    challengeVoteList = [true, true, createWorkshopSettingBool("Challenge Toggle", "Swarm Shootout", true, 1), createWorkshopSettingBool("Challenge Toggle", "Random Abilities", true, 2), createWorkshopSettingBool("Challenge Toggle", "Insanity", true, 3), createWorkshopSettingBool("Challenge Toggle", "Pandora's Box", true, 4)].map(lambda enabled: [null, enabled])
    #Set zombie modes empty
    zombieVoteList = [true, "All Zombies", createWorkshopSettingBool("Zombie Mode Toggle", "New Blood", true, 1), createWorkshopSettingBool("Zombie Mode Toggle", "What'll it be?", true, 2), createWorkshopSettingBool("Zombie Mode Toggle", "Zombie Shuffle", true, 3), createWorkshopSettingBool("Zombie Mode Toggle", "Dinner Rush!", true, 4), createWorkshopSettingBool("Zombie Mode Toggle", "Ham N' Hammer!", true, 5)].map(lambda enabled: [null, enabled])
    setAvailableObjectivesMacro()
    #Set/Reset to default 0
    difficultySetting = Difficulty.UNSET
    #Set/Reset to default 0
    zombieSetting = 0
    #Set/Reset to default 0
    objectiveTypeSetting = ObjectiveType.NO_PREFERENCE
    if isAssemblingHeroes():
        disableInspector()
        setMatchTime(0)
        isPregameSetup = true
        wait(0.25)
    if (isSpecialGameMode == true or getCurrentGamemode() == Gamemode.FLASHPOINT) and isInSetup():
        setMatchTime(0)
        wait(0.25)
    setMatchTime(3599)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()) and len(mapGridList) > 0, 99999)
    setMatchTime(60)
    wait()
    pregameCountdown = getMatchTime()
    chaseAtRate(pregameCountdown, 0, 1, ChaseRateReeval.NONE)
    disableAnnouncer()
    disableGamemodeCompletion()


rule "PREGAME SPAWN ROOM ROTATION":
    @Condition isPregameSetup == true
    #Does not apply if game mode is special gamemode
    @Condition isSpecialGameMode != true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    createDummy(Hero.ANA, Team.2, -1, 500 * Vector.UP)
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
    while isPregameSetup:
        spawnRoomIndex = (spawnRoomIndex + 1) % len(attackSpawnRooms)
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
    isSpecialGameMode = true if getCurrentGamemode() in [Gamemode.TDM, Gamemode.CTF, Gamemode.PUSH, Gamemode.CONTROL] else false
    #Initial extraction zone radius
    extractionZoneRad = 300
    extractionSpeedUp = 2.5
    objectivePositionsList = []
    #Relative center of the map
    while walkCenter == null:
        wait(1)
        walkCenter = (nearestWalkablePosition(vect(999, 999, 999)) + nearestWalkablePosition(vect(-999, -999, -999))) / 2
        smallMessage(getAllPlayers(), "Map Grid is being made...")
    if getCurrentGamemode() == Gamemode.CONTROL:
        walkCenter = getObjectivePosition(getCurrentObjective())
    startRule(generateMapGrid, StartRuleBehavior.NOOP)
    #objectiveValue = ObjectiveType.NO_PREFERENCE  #Uninitialized Workshop variables already compare equal to 0 at match start.
    objectiveEntityIdList = []
    botSpawnPointList = []
    botSpawnWaypointList = []
    botSpawnPointTimerList = []
    bossStateList = []
    healthpackPositionList = []
    #overtime = false  #Uninitialized Workshop variables already compare equal to false at match start.
    #isGameplayActive = false  #Uninitialized Workshop variables already compare equal to false at match start.
    userNameList = []
    playerStatsList = []
    # reconnectInitialSlotIndex: player-slot counter, to create 12 initial entries in playerStatsList.
    #!define reconnectInitialSlotIndex tmp0
    for reconnectInitialSlotIndex in range(12):
        playerStatsList.append(-1)
    objectivePositionList = []
    currentObjectivePosition = objectivePositionList[0]
    objectiveTypeList = []
    currentObjectiveType = objectiveTypeList[0]
    objectiveRad = 10
    mustReviveTime = 60
    objectivePlayerList = []
    isSupplyDropOpen = true
    #supplyDropLandingPosition = null  #Uninitialized Workshop variables already compare equal to null at match start.
    #supplyDropPosition = null  #Uninitialized Workshop variables already compare equal to null at match start.
    supplyPowerUpIdList = []
    supplyPowerUpPositionList = []
    supplyPowerUpEffectIdList = []
    supplyPowerUpTextIdList = []
    playerTargetList = []
    bossesAvailableHeroList = []
    botSpawnTimeList = []
    customTeleportPositionList = []
    enableMutationsMacro()
    supplyDropPowerUpCount = createWorkshopSettingInt("Power Ups", "Number of Powerups Per Supply Drop", 5, 1, 10, -1)
    uniqueSkinCap = createWorkshopSettingInt("General", "Maximum Number of Unique Hero Skins", 11, 1, 11)
    #isObjectiveComplete = false  #Uninitialized Workshop variables already compare equal to false at match start.
    numberOfBots = createWorkshopSettingInt("General", "Number of zombies", 6, 1, 23, 1)


rule "START GAME":
    @Condition isPregameSetup != false
    @Condition getMatchTime() <= 0.1
    @Condition getPlayers(Team.1).any(lambda player: player.hasSpawned())
    
    if isInSetup():
        setMatchTime(0)
        wait(0.25)
    disableScoring()
    disableAnnouncer()
    pauseMatchTime()
    walkCenter = nearestWalkablePosition(walkCenter)
    isPregameSetup = false
    enableMusic()
    disableInspector()
    #enableInspector()
    destroyAllDummies()
    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllIcons()
    destroyAllInWorldTexts()
    # Retire all live camera readers before publishing mission values into menu storage.
    getPlayers(Team.1).stopCamera()
    currentObjectiveType = objectiveTypeList[0]
    currentObjectivePosition = objectivePositionList[0]
    # Enhancement icons no longer have live menu readers; restore the goal text's initial value.
    biomorphingGoalText = null
    # Scene writers abort after the phase boundary; preserve the color's original value before the first biogoal.
    biomorphingGoalColor = null
    wait(0.25)
    setMatchTime(START_TIME + matchEndTime)
    unpauseMatchTime()
    #Disabled survivor spawn room healing zone
    startForcingSpawn(Team.1, Color.BLUE)
    #Objective Description
    setObjectiveDescription(getAllPlayers(), objectiveDescription, HudReeval.VISIBILITY_AND_STRING)
    wait(5)
    disableMusic()


def generateMapGrid():
    @Name "generateMapGrid"
    
    mapGridList = []
    while len(mapGridList) < 900:
        # mapGridCandidatePosition: candidate walkable grid point, to check spawn-room clearance and point spacing.
        #!define mapGridCandidatePosition tmp0
        mapGridCandidatePosition = nearestWalkablePosition((random.choice(mapGridList) if len(mapGridList) > 5 else walkCenter) + directionFromAngles(random.uniform(0, 360), random.uniform(-35, 35)) * random.uniform(10, 100))
        #Do not grid points inside spawn rooms on CTF maps
        if getCurrentGamemode() != Gamemode.CTF and getCurrentGamemode() != Gamemode.CLASH and getCurrentGamemode() != Gamemode.PUSH and getCurrentGamemode() != Gamemode.CONTROL and getCurrentGamemode() != Gamemode.FLASHPOINT or getSpawnPoints(Team.2).all(lambda x: distance(x.getPosition(), mapGridCandidatePosition) > 50) and getSpawnPoints(Team.1).all(lambda x: distance(x.getPosition(), mapGridCandidatePosition) > 40):
            if len(mapGridList) == 0 or mapGridList.all(lambda x: distance(x, mapGridCandidatePosition) > 2.5):
                mapGridList.append(mapGridCandidatePosition)
        if isPregameSetup and getMatchTime() + matchEndTime < 2:
            break
        wait()
    #0: Consecutive, 1: Minimum
    objectiveSpacingList = [min(60, len(mapGridList) / 11), min(30, len(mapGridList) / 20)]
