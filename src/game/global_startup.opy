#!mainFile "../../main.opy"

subroutine generateMapGrid

macro setAvailableObjectivesMacro():
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.NO_PREFERENCE] = true
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.SHOWDOWN] = createWorkshopSettingBool("Available Objective Types", "Showdown", DEFAULT_OBJECTIVE_SHOWDOWN)
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.BOSSES] = createWorkshopSettingBool("Available Objective Types", "Bosses", DEFAULT_OBJECTIVE_BOSSES, 1)
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.KILL_ZONE] = createWorkshopSettingBool("Available Objective Types", "Kill Zone", DEFAULT_OBJECTIVE_KILL_ZONE, 4)
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.ZOMBIE_EGG] = createWorkshopSettingBool("Available Objective Types", "Zombie Egg", DEFAULT_OBJECTIVE_ZOMBIE_EGG, 5)
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.SATELLITE_UPLINK] = createWorkshopSettingBool("Available Objective Types", "Satellite Uplink", DEFAULT_OBJECTIVE_SATELLITE_UPLINK, 6)
    #Set objective type votes empty
    objectiveTypeVoteList[ObjectiveType.MIXED_OBJECTIVES] = createWorkshopSettingBool("Available Objective Types", "Mixed Objectives", DEFAULT_OBJECTIVE_MIXED_OBJECTIVES, 8)
    #Mixed Objectives pool
    # These objective IDs are consecutive (1-7), so each enabled setting uses its index plus one.
    mixedObjectiveTypeList = [
        createWorkshopSettingBool("Mixed Objectives Pool", "Standoff.", DEFAULT_MIXED_OBJECTIVE_STANDOFF, 1),
        createWorkshopSettingBool("Mixed Objectives Pool", "Bosses.", DEFAULT_MIXED_OBJECTIVE_BOSSES, 2),
        createWorkshopSettingBool("Mixed Objectives Pool", "Biomorphing.", DEFAULT_MIXED_OBJECTIVE_BIOMORPHING, 3),
        createWorkshopSettingBool("Mixed Objectives Pool", "Survivor Rescue.", DEFAULT_MIXED_OBJECTIVE_SURVIVOR_RESCUE, 4),
        createWorkshopSettingBool("Mixed Objectives Pool", "Kill Zone.", DEFAULT_MIXED_OBJECTIVE_KILL_ZONE, 5),
        createWorkshopSettingBool("Mixed Objectives Pool", "Zombie Egg.", DEFAULT_MIXED_OBJECTIVE_ZOMBIE_EGG, 6),
        createWorkshopSettingBool("Mixed Objectives Pool", "Satellite Uplink.", DEFAULT_MIXED_OBJECTIVE_SATELLITE_UPLINK, 7),
    ].map(lambda enabled, i: i + 1 if enabled else ObjectiveType.NO_PREFERENCE)
    #Removed disabled objectives
    mixedObjectiveTypeList.remove(ObjectiveType.NO_PREFERENCE)


macro enableEnhancementsMacro():
    enhancementOptionList = ENHANCEMENT_ICONS


macro isBotRespawnReady():
    botSpawnTimeList != [] and botSpawnTimeList[0] <= getTotalTimeElapsed()


macro botHeroRandomizationMacro():
    # Scratch values are consumed before the dummy is created.
    #!define botSpawnSelectedHero tmp0
    #!define botSpawnCumulativeWeight tmp1
    #!define botSpawnHeroIndex tmp2
    #!define botSpawnWeightRoll tmp3
    if isSmolderEventActive:
        botSpawnSelectedHero = Hero.WINSTON
    else:
        botSpawnSelectedHero = null
        # Use weighted selection while there is room for another zombie skin.
        if len(botHeroList.filter(lambda hero: getNumberOfHeroes(hero, Team.2))) < (UNIQUE_HERO_SKIN_CAP - max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))):
            botSpawnCumulativeWeight = 0
            botSpawnWeightRoll = random.uniform(0, NL_SPAWN_MODE_WEIGHT_TOTALS[zombieSetting])
            for botSpawnHeroIndex in range(ZOMBIE_SPAWN_HERO_COUNT):
                botSpawnCumulativeWeight += botSpawnRateList[botSpawnHeroIndex]
                # Skip leading zero weights even when the roll is zero.
                if botSpawnCumulativeWeight and botSpawnWeightRoll <= botSpawnCumulativeWeight:
                    botSpawnSelectedHero = botHeroList[botSpawnHeroIndex]
                    break
        # Reuse the skin-cap fallback if the search exhausts the weights.
        if botSpawnSelectedHero == null:
            botSpawnSelectedHero = sorted(botHeroList, lambda _, i: botSpawnRateList[i]).last()
    createDummy(botSpawnSelectedHero, Team.2, -1, dummyHoldingPositionConst)


macro enableMutationsMacro():
    # Mutation IDs are consecutive (1-5) and follow the setting order.
    availableMutationList = [
        createWorkshopSettingBool("Mutations", "Speed", DEFAULT_MUTATION_SPEED),
        createWorkshopSettingBool("Mutations", "Size Growth", DEFAULT_MUTATION_SIZE_GROWTH, 1),
        createWorkshopSettingBool("Mutations", "Size Reduction", DEFAULT_MUTATION_SIZE_REDUCTION, 2),
        createWorkshopSettingBool("Mutations", "Radioactive", DEFAULT_MUTATION_RADIOACTIVE, 3),
        createWorkshopSettingBool("Mutations", "Heavy", DEFAULT_MUTATION_HEAVY, 4),
    ].map(lambda enabled, i: i + 1 if enabled else 0)
    availableMutationList.remove(0)


rule "PREGAME QUICK TIPS FOR PLAYERS":
    @Condition isPregameSetup == true
    
    wait(10, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Quick Tip: {0}".format(random.choice([f"Hold [{inputBindingString(Button.SECONDARY_FIRE)}] while voting to cycle backwards.", "Hold [{0}] for 5 seconds to switch heroes while in game.".format(inputBindingString(Button.RELOAD)), "Hacked zombies cannot infect players.", "Overheal abilities protect players from infection.", f"Third-person camera: [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}] + [{inputBindingString(Button.RELOAD)}]."])))
    loop()


rule "SPAWN BOTS":
    @Condition isGameplayActive == true
    @Condition getAverageServerLoad() <= createWorkshopSettingInt("General", "Spawn Zombies When Server Load Average is Less Than", DEFAULT_ZOMBIE_SPAWN_SERVER_LOAD_LIMIT, 100, 255, 2)
    #@Condition getNumberOfPlayers(Team.2) < numberOfBots
    @Condition getNumberOfPlayers(Team.ALL) < 24
    @Condition (isBotRespawnReady() or len(botSpawnTimeList) + getNumberOfPlayers(Team.2) < numberOfBots) == true
    
    botHeroRandomizationMacro()
    if isBotRespawnReady():
        del botSpawnTimeList[0]
        wait(0.25)
    else:
        wait(3)
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
    challengeVoteList = [
        true, true,
        createWorkshopSettingBool("Challenge Toggle", "Swarm Shootout", DEFAULT_CHALLENGE_SWARM_SHOOTOUT, 1),
        createWorkshopSettingBool("Challenge Toggle", "Random Abilities", DEFAULT_CHALLENGE_RANDOM_ABILITIES, 2),
        createWorkshopSettingBool("Challenge Toggle", "Insanity", DEFAULT_CHALLENGE_INSANITY, 3),
        createWorkshopSettingBool("Challenge Toggle", "Pandora's Box", DEFAULT_CHALLENGE_PANDORAS_BOX, 4),
    ]
    #Set zombie modes empty
    zombieVoteList = [
        true, "All Zombies",
        createWorkshopSettingBool("Zombie Mode Toggle", "New Blood", DEFAULT_ZOMBIE_MODE_NEW_BLOOD, 1),
        createWorkshopSettingBool("Zombie Mode Toggle", "What'll it be?", DEFAULT_ZOMBIE_MODE_WHATLL_IT_BE, 2),
        createWorkshopSettingBool("Zombie Mode Toggle", "Zombie Shuffle", DEFAULT_ZOMBIE_MODE_ZOMBIE_SHUFFLE, 3),
        createWorkshopSettingBool("Zombie Mode Toggle", "Dinner Rush!", DEFAULT_ZOMBIE_MODE_DINNER_RUSH, 4),
        createWorkshopSettingBool("Zombie Mode Toggle", "Ham N' Hammer!", DEFAULT_ZOMBIE_MODE_HAM_N_HAMMER, 5),
    ]
    setAvailableObjectivesMacro()
    #Set/Reset to default 0
    difficultySetting = Difficulty.UNSET
    #Set/Reset to default 0
    zombieSetting = 0
    #Set/Reset to default 0
    objectiveTypeSetting = ObjectiveType.NO_PREFERENCE
    if isAssemblingHeroes():
        if not (DEBUG or DEBUG_ENABLE_INSPECTOR):
            disableInspector()
        setMatchTime(0)
        isPregameSetup = true
        wait(0.25)
    if (isSpecialGameMode == true or getCurrentGamemode() == Gamemode.FLASHPOINT) and isInSetup():
        setMatchTime(0)
        wait(0.25)
    setMatchTime(3599)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()) and mapGridList != [], Math.INFINITY)
    setMatchTime(PREGAME_VOTING_DURATION + PREGAME_PREPARATION_DURATION)
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
        advanceSpawnRoomIndex()
        #Open all spawn rooms
        startForcingSpawn(Team.ALL, spawnRoomIndex)
        wait(1)
    #Change active spawn room to a location
    activeAttackSpawnRoom = attackSpawnRooms[spawnRoomIndex]


rule "VARIABLE ASSIGNMENT":
    initializeImmutableVariables()
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
    botSpawnPointLoadUntilList = []
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
    refreshCurrentObjectivePosition()
    objectiveTypeList = []
    refreshCurrentObjectiveType()
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
    # Item placement divides by count - 1.
    supplyDropPowerUpCount = createWorkshopSettingInt("Power Ups", "Number of Powerups Per Supply Drop", DEFAULT_SUPPLY_DROP_POWER_UP_COUNT, 2, 10, -1)
    #isObjectiveComplete = false  #Uninitialized Workshop variables already compare equal to false at match start.
    numberOfBots = createWorkshopSettingInt("General", "Number of zombies", DEFAULT_ZOMBIE_COUNT, 1, 23, 1)
    isMeleeInfectionEnabled = createWorkshopSettingBool("Infection", "Melee Infection Enabled", DEFAULT_MELEE_INFECTION)


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
    matchStartReviveEndsAt = getTotalTimeElapsed() + MATCH_START_REVIVE_DURATION
    isPregameSetup = false
    enableMusic()
    if not (DEBUG or DEBUG_ENABLE_INSPECTOR):
        disableInspector()
    destroyAllDummies()
    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllIcons()
    destroyAllInWorldTexts()
    # Keep the pregame camera until PLAYER INITIALIZATION finishes placement and facing.
    # Its coordinates have independent storage, so publishing objective caches cannot move it.
    refreshCurrentObjectiveType()
    refreshCurrentObjectivePosition()
    # Enhancement icons no longer have live menu readers; restore the goal text's initial value.
    biomorphingGoalText = null
    # Preserve the color's original value before the first biogoal.
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
        #Keep grid points outside both spawn rooms on these five game modes.
        if not getCurrentGamemode() in [Gamemode.CTF, Gamemode.CLASH, Gamemode.PUSH, Gamemode.CONTROL, Gamemode.FLASHPOINT] or getSpawnPoints(Team.2).all(lambda x: distance(x.getPosition(), mapGridCandidatePosition) > 50) and getSpawnPoints(Team.1).all(lambda x: distance(x.getPosition(), mapGridCandidatePosition) > 40):
            # Is True For All also passes on an empty array, allowing the first point.
            if mapGridList.all(lambda x: distance(x, mapGridCandidatePosition) > 2.5):
                mapGridList.append(mapGridCandidatePosition)
        if isPregameSetup and getMatchTime() + matchEndTime < 2:
            break
        wait()
    #0: Consecutive, 1: Minimum
    objectiveSpacingList = [min(60, len(mapGridList) / 11), min(30, len(mapGridList) / 20)]
    if DEBUG_ENABLE_INSPECTOR:
        logToInspector(f"[map grid] Completed points={len(mapGridList)}")
