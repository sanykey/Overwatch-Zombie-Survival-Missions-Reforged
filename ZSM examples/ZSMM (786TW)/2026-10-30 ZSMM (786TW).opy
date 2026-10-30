settings {
    "main": {
        "description": "[Original Creator: Mazattack#1183]\r\n[Original Game Code: MPJFR]\r\n[Modified by: Kamenrider#11346]\r\nworkshop.codes/786TW\r\n\r\nFight against an endless horde of zombies while completing various objectives. \r\nUse power-ups found in supply drops while you fight off the horde. \r\nGet to the extraction point and watch the map get nuked. Don't leave anyone behind! \r\n\r\nCommunity ZSM Discord: https://discord.gg/3BhYtNfwMj",
        "modeName": "Zombie Survival Missions Modded"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "spectatorSlots": 7,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "assault": {
            "captureSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ctf": {
            "disabledMaps": [
                "busanSanctuaryLny",
                "lijiangControlCenterLny",
                "lijiangGardenLny",
                "oasisCityCenter",
                "oasisGardens",
                "oasisUniversity"
            ],
            "enableDropFlagOnDmg": true,
            "enablePerks": true,
            "flagCarrierAbilities": "all",
            "flagDroppedLockTime": 10,
            "flagPickupTime": 5,
            "flagReturnTime": 0,
            "flagScoreRespawnTime": 20,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "clash": {
            "captureSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "control": {
            "enabledMaps": [
                {
                    "antarcticPeninsula": [
                        "morning"
                    ]
                },
                "oasis",
                "samoa"
            ],
            "captureSpeed%": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "controlBalancedOverwatch": {
            "enabled": false,
            "captureSpeed%": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "elimination": {
            "enabled": false,
            "enableTiebreaker": false
        },
        "escort": {
            "disabledMaps": [
                "watchpointGibraltar"
            ],
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escortBalancedOverwatch": {
            "enabled": false,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "flashpoint": {
            "captureSpeed%": 10,
            "scoreToWin": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybridBalancedOverwatch": {
            "enabled": false,
            "captureSpeed%": 10,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybrid": {
            "disabledMaps": [
                "eichenwalde",
                "kingsRow",
                "paraiso"
            ],
            "captureSpeed%": 10,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "practiceRange": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "pushBalancedOverwatch": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "push": {
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "skirmish": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "tdm": {
            "enabledMaps": [
                "blackForest",
                "blackForestWinter",
                "castillo",
                "chateauGuillard",
                "chateauGuillardHalloween",
                "ecopointAntarctica",
                "ecopointAntarcticaWinter",
                "kanezaka",
                "malevento",
                "necropolis",
                "petra"
            ],
            "enablePerks": true,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "heroLimit": "off",
            "enableKillCam": false
        }
    },
    "heroes": {
        "team2": {
            "general": {
                "abilityCooldown%": 0,
                "passiveHealthRegen": false
            }
        }
    },
    "workshop": {
        "Boss Size": 2.5,
        "Chance to mutate percentage": 25,
        "Default Enhancement": [
            1
        ],
        "Zombie Size": 1
    }
}

#Global variables

globalvar objectivePositions 0
globalvar walkCenter 1
globalvar objectiveCaptureValue 2
globalvar startPos 3
globalvar count1 4
globalvar count2 5
globalvar specialEffectsStrings 6
globalvar playersOnObjective 7
globalvar testPos 8
globalvar testPos2 9
globalvar objectiveTypes 10
globalvar objectiveRad 11
globalvar losList 12
globalvar reviveRadius 13
globalvar botHeros 14
globalvar chase1 15
globalvar gameSmolderEvent 16
globalvar gameStatus 18
globalvar startTime 19
globalvar mustReviveTime 20
globalvar supplyDropLanding 21
globalvar supplyDropPosition 22
globalvar powerUpIDs 23
globalvar powerUpPositions 24
globalvar supplyDropStatus 25
globalvar powerUpText 26
globalvar powerUpEffect 27
globalvar startCamPos 28
globalvar botSpawnRates 29
globalvar startMenuSpacingAngle 30
globalvar startCamDistance 31
globalvar overtime 32
globalvar challengeVotes 33
globalvar botMaxTeleportRange 34
globalvar difficultySetting 35
globalvar biteDamages 36
globalvar biteDurations 37
globalvar damageDealt 38
globalvar botHealthValues 39
globalvar throttleSpeeds 40
globalvar randVal 41
globalvar specialEffectsTiming 42
globalvar evacRate 43
globalvar evacuatingSurvivorList 44
globalvar evacDestination 45
globalvar zombieSetting 46
globalvar bosses 47
globalvar zombieVotes 48
globalvar globalPlayerStats 49
globalvar objectiveTypeVotes 50
globalvar objectiveTypeSetting 51
globalvar eliminationsNeededPerObjective 52
globalvar healthpackPositions 54
globalvar miniBoss 55
globalvar mapGrid 56
globalvar challengeSetting 57
globalvar attackSpawnRooms 58
globalvar activeAttackSpawnRoom 59
globalvar closestPlayerToObjective 60
globalvar botSpawnPoints 61
globalvar objectiveValue 62
globalvar objectiveEntities 63
globalvar objectiveEntityCount 64
globalvar voting 65
globalvar votingEndTime 66
globalvar objectiveResourcePositions 67
globalvar amountPerResource 68
globalvar extractionZoneRad 69
globalvar specialGameModeSetup 70
globalvar resourcePowerUpDropCount 71
globalvar availablePowerups 72
globalvar specialGameMode 73
globalvar objectiveSpacing 74
globalvar enhancementOptions 75
globalvar playerTargetList 76
globalvar losHeightCheck 77
globalvar survivorToRescue 78
globalvar nonBossZombies 79
globalvar availableMutations 80
globalvar numberOfPowerUpsPerSupplyDrop 81
globalvar objectiveDescription 82
globalvar mixedObjectivesPool 83
globalvar uniqueSkinCap 84
globalvar users 85
globalvar objectiveComplete 86
globalvar objectiveColor 87
globalvar objectiveCount1 88
globalvar objectiveChase1 89
globalvar spawnRoomIndex 90
globalvar averageChalllenge 91
globalvar matchEndTime 92
globalvar waypoints 93
globalvar availableBosses 94
globalvar spawnTimes 95
globalvar numberOfBots 96
globalvar customTelePositions 97
globalvar currentBotHeroList 98
globalvar botCurrentSpawnRate 99
globalvar botRespawnCount 100
globalvar botSpawnPointTimers 101
globalvar extractionSpeedUp 102
globalvar queuedBioType 103
globalvar goalText 104
globalvar goalColor 105
globalvar goalPost 106
globalvar biowasteTypes 109
globalvar deferredType 110
globalvar goalCheck 111
globalvar queuedGoalType 112
globalvar deferredPositions 113
globalvar biowasteString 114
globalvar biowasteEffects 115
globalvar biowasteOutput0 116
globalvar biowasteCount 117
globalvar biowasteColorLookUp 118
globalvar biowasteTextLookUp 119
globalvar biowasteLocal0 120
globalvar biowasteLocal1 121
globalvar biowasteInput0 122
globalvar biowasteInput1 123

#Player variables

playervar averagePlayersPos 0
playervar targeting 1
playervar mutationChase 3
playervar teleporting 4
playervar pPowerUpCount_bTeleCount 5
playervar pForceFieldCount1 6
playervar pForceFieldCount2_bCount1 7
playervar botTarget 9
playervar botThrottleSpeed 10
playervar playerActiveStatus 11
playervar reviving 12
playervar reviveStartTime 13
playervar reviveTimer 14
playervar interactEntity 15
playervar infected 16
playervar biteDamage 17
playervar biteDuration 18
playervar randVal 19
playervar crowdControlled 20
playervar deathTimer 21
playervar infectionLvl 22
playervar currentPowerUp 23
playervar powerUpTradeValues 24
playervar powerUpEffects 25
playervar powerUpUsePositionsAndInfo 26
playervar pNoCooldownsCount_bCount2 27
playervar pAirStrikeCount 28
playervar specialCooldown 29
playervar chase1 30
playervar chase2 31
playervar botFollowTarget 32
playervar botTempvalue2 33
playervar playerMenuStatus 34
playervar startPos 35
playervar successfullyTeleported 36
playervar biowasteType 37
playervar anranPortal 38
playervar evacPos 39
playervar canWallPhase 40
playervar pHealBeaconCount 41
playervar pSentryTurretCount 42
playervar initialMaxHealth 43
playervar botSpecialTarget 44
playervar attached 45
playervar telePos 46
playervar invisible 47
playervar pCloakingDeviceCount 48
playervar path 49
playervar potentialTargets 50
playervar pSuperNanoCount 51
playervar size 52
playervar bossHealth 53
playervar wallCollisionEnabled 54
playervar specialFacing 55
playervar specialThrottling 56
playervar filteredBotSpawnPointGrid 57
playervar botTempValue 58
playervar objectiveValue 59
playervar generalPlayerBotEntities 60
playervar entityCount 61
playervar botHero 62
playervar playerObjectiveResourceValue 63
playervar pBouncePadCount1 64
playervar infectionDamage 65
playervar enhancementValues 66
playervar botSpecialPotentialTargets 67
playervar movementSpeed 68
playervar mutationValue 69
playervar health 70
playervar damageOverTimeDuration 71
playervar pUltimateChargerCount 72
playervar enhancementChase1 73
playervar playerCollisionEnabled 74
playervar pStunCount 75
playervar enhancementChase2 76
playervar initializing 77
playervar userIndex 78
playervar knockbackRecieved 79
playervar detectionRadius1 80
playervar pBouncePadCount2 81
playervar bouncePadBouncer 82
playervar pStunChase1 83
playervar enhancementCount1 84
playervar customTelePos 85
playervar damageDealt 86
playervar lastTarget 87
playervar abilityArray1 88
playervar abilityArray2 89
playervar waypoint 90
playervar testTarget 91
playervar canTeleport 92
playervar defaultOutlineColor 93
playervar playerWasteValue 94
playervar explosionColor1 95
playervar explosionColor2 96
playervar afk 97
playervar explosionSize 98
playervar switchedHeroes 99
playervar anranPortalRise 100
playervar botResourceEntity 101

#Subroutine names

subroutine enterExitTeleport 0
subroutine teleportBots 1
subroutine nukeMap 2
subroutine powerUpAssignment 3
subroutine powerUpUsage 4
subroutine playerForceField 5
subroutine noCooldowns 6
subroutine airStrike 7
subroutine instantRevive 8
subroutine randomActions 9
subroutine enableDisableAbilities 10
subroutine determineChallenge 11
subroutine setDifficulty 12
subroutine botRespawnInitialization 13
subroutine determineZombieMode 14
subroutine setZombieMode 15
subroutine healBeacon 16
subroutine sentryTurret 17
subroutine bossReturn 18
subroutine cloakingDevice 19
subroutine determineObjectiveType 20
subroutine setObjectiveType 21
subroutine objectivesManagement 22
subroutine superNano 23
subroutine generateMapGrid 24
subroutine successfulTeleportStatus 25
subroutine updateBotSpawnPoints 26
subroutine globalObjectiveEntityManagement 27
subroutine playerObjectiveEntityManagement 28
subroutine botEntityManagement 29
subroutine bouncePad 30
subroutine botTeleportCenter 31
subroutine locateAveragePlayerLocation 32
subroutine enablePowerups 33
subroutine mutations 34
subroutine enableMutations 35
subroutine ultimateCharger 36
subroutine botHeroRandomization 37
subroutine enableEnhancements 38
subroutine teleportToClosestPlayer 39
subroutine setAvailableObjectives 40
subroutine stun 41
subroutine updateUsers 42
subroutine botStatManagement 43
subroutine fireSatellite 44
subroutine selectTarget 45
subroutine restoreDefaultFacingMovement 46
subroutine setPrematchTimer 47
subroutine explosionSequence 48
subroutine minibossMutation 49
subroutine abilityThrowdown 50
subroutine illariUlt 51
subroutine entityFloat 52
subroutine biowasteAssignment 53
subroutine biowasteOutput 54
subroutine abilityPlacement 55
subroutine explosionWarning 56
subroutine smolderEnraged 57

#Activated extensions

#!extension playMoreEffects
#!extension spawnMoreDummyBots


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "Fix bot health":
    @Event eachPlayer
    @Team 2
    @Condition gameStatus == true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.getHealth() > eventPlayer.health + 5
    @Condition eventPlayer in bosses == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.health)
    if ruleCondition:
        loop()


rule "============================================== GLOBAL STARTUP ====================================================":
    @Disabled
    @Delimiter
    


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
    
    botHeroRandomization()
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


def botHeroRandomization():
    @Name "botHeroRandomization"
    
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
    enableEnhancements()
    #Set difficulty votes empty
    challengeVotes = [[null, true], [null, true], [null, createWorkshopSettingBool("Challenge Toggle", "Swarm Shootout", true, 1)], [null, createWorkshopSettingBool("Challenge Toggle", "Random Abilities", true, 2)], [null, createWorkshopSettingBool("Challenge Toggle", "Insanity", true, 3)], [null, createWorkshopSettingBool("Challenge Toggle", "Pandora's Box", true, 4)]]
    #Set zombie modes empty
    zombieVotes = [[null, true], [null, "All Zombies"], [null, createWorkshopSettingBool("Zombie Mode Toggle", "New Blood", true, 1)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "What'll it be?", true, 2)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Zombie Shuffle", true, 3)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Dinner Rush!", true, 4)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Ham N' Hammer!", true, 5)]]
    setAvailableObjectives()
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
    waitUntil(len(getPlayers(Team.1).filter(lambda player: player.hasSpawned())) > 0 and len(mapGrid) > 0, 9999)
    setMatchTime(60)
    wait()
    chase1 = getMatchTime()
    chaseAtRate(chase1, 0, 1, ChaseRateReeval.NONE)
    disableAnnouncer()
    disableGamemodeCompletion()


def setAvailableObjectives():
    @Name "setAvailableObjectives"
    
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
    mixedObjectivesPool[0] = 1 if createWorkshopSettingBool("Mixed Objectives Pool", "Standoff.", true, 1) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[1] = 2 if createWorkshopSettingBool("Mixed Objectives Pool", "Bosses.", true, 2) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[2] = 3 if createWorkshopSettingBool("Mixed Objectives Pool", "Biomorphing.", true, 3) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[3] = 4 if createWorkshopSettingBool("Mixed Objectives Pool", "Survivor Rescue.", true, 4) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[4] = 5 if createWorkshopSettingBool("Mixed Objectives Pool", "Kill Zone.", true, 5) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[5] = 6 if createWorkshopSettingBool("Mixed Objectives Pool", "Zombie Egg.", true, 6) else 0
    #Mixed Objectives pool
    mixedObjectivesPool[6] = 7 if createWorkshopSettingBool("Mixed Objectives Pool", "Satellite Uplink.", true, 7) else 0
    #Removed disabled objectives
    mixedObjectivesPool.remove(0)


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
    objectiveValue = 0
    objectiveEntities = []
    botSpawnPoints = []
    waypoints = []
    botSpawnPointTimers = []
    bosses = []
    healthpackPositions = []
    overtime = false
    gameStatus = false
    users = []
    globalPlayerStats = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
    objectivePositions = []
    objectiveTypes = []
    objectiveRad = 10
    reviveRadius = 5
    mustReviveTime = 60
    playersOnObjective = []
    losList = []
    botMaxTeleportRange = [20, 40]
    supplyDropStatus = true
    supplyDropLanding = null
    supplyDropPosition = null
    powerUpIDs = []
    powerUpPositions = []
    powerUpEffect = []
    powerUpText = []
    playerTargetList = []
    availableBosses = []
    spawnTimes = []
    customTelePositions = []
    losHeightCheck = 1.2
    enablePowerups()
    enableMutations()
    numberOfPowerUpsPerSupplyDrop = createWorkshopSettingInt("Power Ups", "Number of Powerups Per Supply Drop", 5, 1, 10, -1)
    uniqueSkinCap = createWorkshopSettingInt("General", "Maximum Number of Unique Hero Skins", 11, 1, 11)
    objectiveComplete = false
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


def determineZombieMode():
    @Name "determineZombieMode"
    
    zombieSetting = 0
    for count1 in range(1, len(zombieVotes)):
        if zombieVotes[count1][1]:
            zombieVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[3] == count1))
        else:
            zombieVotes[count1] = -1
    for count1 in range(1, len(zombieVotes)):
        if zombieVotes[zombieSetting] < zombieVotes[count1]:
            zombieSetting = count1
        elif zombieVotes[zombieSetting] == zombieVotes[count1]:
            #Randomly pick mode to break tie
            if zombieSetting != 0 and random.randint(0, 1) == 0:
                zombieSetting = count1
    #If all players choose no preference, randomize
    if zombieSetting == 0:
        zombieSetting = 1
    startRule(determineChallenge)
    startRule(setZombieMode)


def setZombieMode():
    @Name "setZombieMode"
    
    #Bot available hero list
    botHeros = [Hero.REAPER, Hero.JUNKRAT, Hero.TORBJORN, Hero.ROADHOG, Hero.REINHARDT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.MAUGA, Hero.MERCY, Hero.WRECKING_BALL, Hero.MOIRA, Hero.PHARAH, Hero.SIGMA, Hero.JUNKER_QUEEN, Hero.ILLARI, Hero.HAZARD, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO]
    #Zombie types without a boss variation
    nonBossZombies = [Hero.JUNKRAT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.JUNKER_QUEEN, Hero.SYMMETRA, Hero.ANA, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.SIGMA, Hero.WRECKING_BALL]
    #All Zombies
    if zombieSetting == 1:
        #Bot respawn probablities
        botSpawnRates = [11, 10, 5, 4, 3, 5, 4, 4, 6, 3, 5, 6, 3, 4, 4, 6, 4, 9, 4]
    #New Blood
    elif zombieSetting == 2:
        #Bot respawn probablities
        botSpawnRates = [null, null, null, null, null, 10.1, null, 10, 2, 2, 2, 3.9, 10, 10, 10, 10, 10, 10, 10]
    #What'll it be?
    elif zombieSetting == 3:
        #Bot respawn probablities
        botSpawnRates = [5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263, 5.263]
    #Zombie Shuffle
    elif zombieSetting == 4:
        #Bot respawn probablities
        botSpawnRates = [50, 25, 15, 10, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
    #Dinner Rush!
    elif zombieSetting == 5:
        #Bot respawn probablities
        botSpawnRates = [null, null, 15, null, null, 16, 15, 4, null, 3, 15, 9, null, 3, 10, null, 10]
    #Ham N' Hammer
    elif zombieSetting == 6:
        #Bot respawn probablities
        botSpawnRates = [null, null, null, null, 50, null, null, null, null, 50]


def determineChallenge():
    @Name "determineChallenge"
    
    challengeSetting = 0
    for count1 in range(1, len(challengeVotes)):
        if challengeVotes[count1][1]:
            challengeVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[2] == count1))
        else:
            challengeVotes[count1] = -1
    averageChalllenge = 0
    for count1 in range(1, len(challengeVotes)):
        averageChalllenge += challengeVotes[count1] * count1
    averageChalllenge /= len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[2] > 0))
    for count1 in range(1, len(challengeVotes)):
        #If difficulty being compared has more votes than current difficulty
        if challengeVotes[challengeSetting] < challengeVotes[count1]:
            challengeSetting = count1
        elif challengeVotes[count1] > 0 and challengeVotes[challengeSetting] == challengeVotes[count1]:
            #Pick difficulty closest to the average difficulty vote
            if abs(challengeSetting - averageChalllenge) > abs(count1 - averageChalllenge):
                challengeSetting = count1
    #Default difficulty
    if challengeSetting == 0:
        challengeSetting = 1
    startRule(determineObjectiveType)
    startTime = 300


def setDifficulty():
    @Name "setDifficulty"
    
    difficultySetting = len(getPlayers(Team.1).filter(lambda player: player.hasSpawned()))
    #Difficulty: Insanity
    if challengeSetting >= 4:
        #Bot Health Values
        botHealthValues = [300, 250, 200, 900, 1500, 220, 250, 900, 250, 700, 200, 350, 350, 700, 350, 400, 275, 250, 1000]
        #Bot bite damage
        biteDamages = [48, 30, 45, 75, null, 20, 35, 51, 45, 50, 110, 80, 65, null, 30, 55, 35, 30, 30, 80, 80]
        #Bot bite durations
        biteDurations = [3, 3, 3, 3, null, 1.5, 4, 3, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
        #Bot throttle speeds
        throttleSpeeds = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        #Bot damage dealt
        damageDealt = [200, 300, 175, 150, 200, 100, 150, 90, 300, 175, 200, 150, 150, 190, 175, 125, 200, 240, 200, 180, 300]
    else:
        #Message does not play if server is not 70 seconds old, this is a bad fix but I'm struggling to find a simple one.
        if getTotalTimeElapsed() < 100:
            goto lbl_0
        smallMessage(getAllPlayers(), " Difficulty adjusted for player count, change affects new zombies. ")
        lbl_0:
        #Difficulty: 1 Player "Normal"
        if difficultySetting == 1:
            #Bot Health Values
            botHealthValues = [225, 170, 125, 900, 2000, 160, 140, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 500]
            #Bot bite damage
            biteDamages = [5, 2.5, 2, 20, 15, 3, 2, 7.5, 5, 10, 10, 30, 10, 15, 5, 5, 5, 2.5, 10, 10, 10]
            #Bot bite durations
            biteDurations = [1, 1, 1.5, 1.5, null, 0.5, 1.5, 1, 1, 0.5, 0, null, 1, null, 1, 1, 1, 1, 1, 1, 1]
            #Bot throttle speeds
            throttleSpeeds = [0.75, 0.8, 0.9, 0.5, 0.6, 0.6, 0.3, 0.65, 0.6, 0.55, 0.8, 0.55, 0.55, 0.65, 0.5, 0.55, 0.5, 0.8, 0.9, 0.6, 0.6]
            #Bot damage dealt
            damageDealt = [8.5, 7.5, 1, 1, 50, 8, 1, 25, 1, 50, 1, 75, 25, 50, 25, 8.5, 5, 7.5, 50, 50, 50]
        #Difficulty: 2 Player "Hard"
        elif difficultySetting == 2:
            #Bot Health Values
            botHealthValues = [225, 170, 125, 900, 2000, 160, 140, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 750]
            #Bot bite damage
            biteDamages = [15, 10, 12, 40, 30, 5, 2, 12, 15, 20, 15, 45, 20, 30, 7, 15, 7, 10, 10, 20, 20]
            #Bot bite durations
            biteDurations = [2.5, 2.5, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 2.5, 3, 2.5, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.85, 0.9, 1, 0.6, 0.7, 0.6, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.65, 0.6, 0.9, 1, 0.7, 0.7]
            #Bot damage dealt
            damageDealt = [67, 66, 25, 25, 90, 12, 25, 50, 25, 100, 25, 75, 50, 75, 50, 50, 50, 66, 75, 75, 75]
        #Difficulty: 5+ Player "Legendary"
        elif difficultySetting >= 5:
            #Bot Health Values
            botHealthValues = [300, 200, 125, 900, 2000, 180, 150, 800, 200, 750, 175, 300, 400, 750, 300, 350, 200, 200, 1100]
            #Bot bite damage
            biteDamages = [42, 22, 25, 55, 50, 20, 20, 40, 35, 25, 90, 70, 50, 50, 20, 40, 20, 22, 25, 40, 40]
            #Bot bite durations
            biteDurations = [3, 3, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.9, 0.95, 1, 0.75, 0.85, 0.8, 0.7, 0.8, 0.8, 0.75, 0.9, 0.65, 0.85, 0.8, 0.75, 0.9, 0.8, 0.95, 1, 0.9, 0.9]
            #Bot damage dealt
            damageDealt = [100, 150, 100, 100, 170, 75, 100, 80, 100, 175, 50, 100, 100, 140, 125, 90, 150, 125, 125, 150, 150]
        #Difficulty: 3-4 Player "Expert"
        else:
            #Bot Health Values
            botHealthValues = [225, 170, 125, 900, 2000, 160, 140, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 1000]
            #Bot bite damage
            biteDamages = [30, 15, 20, 50, 40, 15, 17.5, 30, 30, 20, 40, 60, 40, 40, 10, 40, 10, 15, 15, 20, 20]
            #Bot bite durations
            biteDurations = [3, 3, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.85, 0.9, 1, 0.6, 0.7, 0.7, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.85, 0.7, 0.9, 1, 0.7, 0.7]
            #Bot damage dealt
            damageDealt = [90, 125, 50, 50, 130, 40, 50, 50, 50, 150, 1, 75, 75, 90, 75, 85, 100, 125, 100, 100, 100]


def determineObjectiveType():
    @Name "determineObjectiveType"
    
    objectiveTypeSetting = 0
    for count1 in range(1, len(objectiveTypeVotes)):
        if objectiveTypeVotes[count1][1]:
            objectiveTypeVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[4] == count1))
        else:
            objectiveTypeVotes[count1] = -1
    for count1 in range(1, len(objectiveTypeVotes)):
        if objectiveTypeVotes[objectiveTypeSetting] < objectiveTypeVotes[count1]:
            objectiveTypeSetting = count1
        elif objectiveTypeVotes[objectiveTypeSetting] == objectiveTypeVotes[count1]:
            #Pick random objective type to break tie
            if objectiveTypeSetting != 0 and random.randint(0, 1) == 0:
                objectiveTypeSetting = count1
    #If all players choose no preference, randomize
    if objectiveTypeSetting == 0:
        if objectiveTypeVotes.last() != -1:
            objectiveTypeSetting = len(objectiveTypeVotes) - 1
        else:
            while objectiveTypeSetting == 0 or objectiveTypeVotes[objectiveTypeSetting] == -1:
                objectiveTypeSetting = random.randint(1, len(objectiveTypeVotes) - 1)
    voting = false
    startRule(setObjectiveType)


def setObjectiveType():
    @Name "setObjectiveType"
    
    #Wait until game begins
    waitUntil(isGameInProgress() and not specialGameModeSetup, 99999)
    #Create objective positions
    while len(objectiveTypes) < createWorkshopSettingInt("General", "Number of Objectives", 5, 0, 100) + 1:
        if objectiveTypeSetting != len(objectiveTypeVotes) - 1:
            objectiveTypes.append(objectiveTypeSetting)
        else:
            #Mixed objective assignment
            objectiveTypes.append(random.choice(mixedObjectivesPool.exclude(objectiveTypes.filter(lambda _, i: i > len(objectiveTypes) - 1 - (len(mixedObjectivesPool) - 1)))))
        objectiveCount1 = 0
        while len(objectivePositions) < len(objectiveTypes):
            #Limits possible map grid points to set min and max range from last created objective position
            testPos = random.choice(mapGrid if len(objectivePositions) == 0 else mapGrid.filter(lambda x: distance(x, objectivePositions.last()) > objectiveSpacing[0] and distance(x, objectivePositions.last()) < min(100, objectiveSpacing[0] * 3)))
            testPos += Vector.UP
            wait()
            #Minimum objective spacing
            if len(objectivePositions) == 0 or objectivePositions.slice(len(objectivePositions) - 5, 5).all(lambda x: distance(testPos, x) > objectiveSpacing[1]):
                #Ensures bosses spawn with head room
                if objectiveTypes.last() != 2 or isInLoS(testPos + vect(0, 0, 0), testPos + vect(0, 10, 0)):
                    objectivePositions.append(testPos)
                    objectiveCount1 = 0
            objectiveCount1++
            #If Too many attempts
            if objectiveCount1 > 50:
                del objectivePositions[len(objectivePositions) - 1]
                del objectivePositions[len(objectivePositions) - 1]
                objectiveCount1 = 0
    #Last objective must be extraction objective
    objectiveTypes[len(objectiveTypes) - 1] = 1
    objectivesManagement()
    gameStatus = true


def enableEnhancements():
    @Name "enableEnhancements"
    
    enhancementOptions = []
    enhancementOptions[0] = iconString(Icon.QUESTION_MARK)
    enhancementOptions[1] = iconString(Icon.STOP)
    enhancementOptions[2] = iconString(Icon.POISON)
    enhancementOptions[3] = iconString(Icon.DIAMOND)
    enhancementOptions[4] = iconString(Icon.SKULL)
    enhancementOptions[5] = iconString(Icon.FIRE)
    enhancementOptions[6] = iconString(Icon.PLUS)
    enhancementOptions[7] = iconString(Icon.BOLT)
    enhancementOptions[8] = iconString(Icon.SPIRAL)
    enhancementOptions[9] = iconString(Icon.FLAG)
    enhancementOptions[10] = iconString(Icon.HAPPY)


rule "============================================== GLOBAL START MENU ====================================================":
    @Disabled
    @Delimiter
    


rule "GLOBAL MENU INITIALIZATION":
    @Condition specialGameModeSetup == true
    @Condition len(mapGrid) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startCamDistance = 6.5
    if specialGameMode:
        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + vect(0, 15, 0)
        elif getCurrentGamemode() == Gamemode.CONTROL:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + vect(0, 100, 0)
        else:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 150 + vect(0, 30, 0)
        startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(horizontalAngleOfDirection(directionTowards(walkCenter, startPos)), 0) * startCamDistance
        wait()
        createDummy(Hero.REAPER, Team.2, -1, nearestWalkablePosition(startPos), Vector.FORWARD)
        wait()
        getPlayers(Team.2).setInvisibility(Invis.ALL)
        getPlayers(Team.2)[0].startForcingPosition(startPos + vect(0, 15, 0))
        getPlayers(Team.2).startFacing(Vector.FORWARD, 100000)
    else:
        while startPos == null:
            startPos = getObjectivePosition(random.randint(0, 2 if getCurrentGamemode() != Gamemode.ASSAULT else 1))
            if getCurrentGamemode() == Gamemode.CLASH:
                startPos = getSpawnPoints(Team.1)
                if __getCurrentMap__() == Map.THRONE_OF_ANUBIS:
                    startPos = vect(-0.27, 0.49, 83.6)
                    startCamPos = vect(-0.19, 2, 90.1)
                    goto lbl_0
            startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(random.uniform(0, 360), 0) * startCamDistance
            startCamPos = raycastHitPosition(startCamPos, startCamPos - vect(0, 5, 0), null, null, false) + vect(0, 1.5, 0)
            startPos = vect(startPos.x, startCamPos.y - 1.5, startPos.z)
            startPos = raycastHitPosition(startPos + vect(0, 0.4, 0), startPos - vect(0, 5, 0), null, null, false)
            startPos = raycastHitPosition(startCamPos - vect(0, 0.75, 0), startPos + vect(0, 0.75, 0), null, null, false) - vect(0, 0.75, 0)
            startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(horizontalAngleOfDirection(directionTowards(startPos, startCamPos)), 0) * startCamDistance
            #Line of Sight Checks for each player position
            for count1 in range(-26, 27, 2):
                if not isInLoS(startCamPos, startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + count1, 0)) * startCamDistance)) or not isInLoS(startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + count1, 0)) * startCamDistance), startCamPos):
                    startPos = null
                    break
            wait()
    lbl_0:
    startMenuSpacingAngle = 40
    #Start screen objective description
    setObjectiveDescription(getAllPlayers(), "Voting ends in {0}s".format(ceil(getMatchTime() - votingEndTime)) if voting else "Select your hero", HudReeval.VISIBILITY_AND_STRING)


rule "EFFECTS/TEXTS":
    #Pre game objective description and match timer
    hudSubtext(getAllPlayers(), "{0} | {1}s".format("Voting will end in {0}s".format(ceil(getMatchTime() - votingEndTime)) if voting else "Select your hero", ceil(getMatchTime())), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "Original Game Code: MPJFR" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Game Mode Creator: Mazattack#1183", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "This is a modified version: 786TW" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Modified by: KamenRider#11346", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Workshop.codes
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] < 2), "For information on changes: workshop.codes/786TW", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Voting options reminder
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 2), "Voting options are available in the top left corner of your screen" if voting else "Voting is complete. Difficulty is actively scaled by amount of players.", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA if voting else Color.PURPLE, SpecVisibility.NEVER)
    #Ready In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 1), "Ready [{0}]".format(inputBindingString(Button.JUMP)), localPlayer.startPos + vect(0, 1.92, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.NEVER)
    #Change Hero In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 1 and getMatchTime() > 2.5), "Change Hero [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, 1.8, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Cancel In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 2 and getMatchTime() > 2.5), "Cancel [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, -0.6, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 49, 49), SpecVisibility.NEVER)
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 0), "Challenge: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)), HudPosition.LEFT, 0, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: None
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 1), "Challenge: None", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.YELLOW, null, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: Swarm Shootout
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 2), "Challenge: Swarm Shootout", "Zombies fire their guns!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: Random Abilities
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 3), "Challenge: Random Abilities", "Non-boss zombies use abilities", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote Challenge text: Insanity
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 4), specialEffectsStrings if specialEffectsTiming else "Challenge: Insanity", "Faster, stronger, and deadlier", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.WHITE if specialEffectsTiming else Color.TURQUOISE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    #Vote Challenge text: Pandora's Box
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 5), specialEffectsStrings if specialEffectsTiming else "Challenge: Pandora's Box", "All challenges at Once!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.GRAY if specialEffectsTiming else Color.PURPLE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    #Vote zombie mode text: No preference
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 0), "Zombie Mode: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)), HudPosition.LEFT, 1, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: All Zombies
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 1), "Zombie Mode: All Zombies", "Normal game featuring all zombie types", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: New Blood
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 2), "Zombie Mode: New Blood", "The 13 most recent zombie types will spawn", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: What'll it be?
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 3), "Zombie Mode: What'll it be?", "All zombie types have equal spawn rates", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Zombie Shuffle!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 4), "Zombie Mode: Zombie Shuffle", "The zombie spawn rates twist and turn with wild abandon!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Dinner Rush!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 5), "Zombie Mode: Dinner Rush!", "Only zombies with mobility abilities will spawn", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Ham N' Hammer!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 6), "Zombie Mode: Ham N' Hammer!", "Only Reinhardt {0} and Wrecking Ball {1} zombies will spawn".format(heroIcon(Hero.REINHARDT), heroIcon(Hero.WRECKING_BALL)), "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: No preference
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 0), "Objective Type: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)), HudPosition.LEFT, 2, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Showdown Only
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 1), "Objective Type: Showdown {0}".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)), "Players must contest a point against zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Boss Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 2), "Objective Type: Bosses {0}".format(iconString(Icon.WARNING)), "Spawns giant versions of zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Kill Zone Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 5), "Objective Type: Kill Zone {0}".format(iconString(Icon.RING_THICK) if ceil(getTotalTimeElapsed() * 1.25) % 2 == 0 else iconString(Icon.RING_THIN)), "Clear zombies from a designated area", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Zombie Egg Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 6), "Objective Type: Zombie Egg {0}".format(iconString(Icon.RADIOACTIVE)), "Survivors must destroy an object that is spawning zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Satellite Uplink Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 7), "Objective Type: Satellite Uplink {0}".format(iconString(Icon.MOON)), "Survivors must repair terminals to communicate with a satellite", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, rgb(12, 129, 132), rgb(12, 129, 132), rgb(12, 129, 132), HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Mixed Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == len(objectiveTypeVotes) - 1), "Objective Type: Mixed Objectives {0}".format(iconString(Icon.SPIRAL)), "Randomly assigns all types of objectives", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: No Preference
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 0), "Enhancement: No Preference", null, "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Kevlar
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 1), "Enhancement: Kevlar {0}".format(iconString(Icon.STOP)), "Survivor is equipped with armor that protects against infections", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, rgb(240, 129, 26), rgb(240, 129, 26), rgb(240, 129, 26), HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Zombie Hyrbid
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 2), "Enhancement: Zombie Hybrid {0}".format(iconString(Icon.POISON)), "Get infected faster, and convert it to explosive damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Laser Barricade
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 3), "Enhancement: Laser Barricade {0}".format(iconString(Icon.DIAMOND)), "Player can place a wall that blocks zombies", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Brain Killer
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 4), "Enhancement: Brain Killer {0}".format(iconString(Icon.SKULL)), "Critical hits do more damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Pyrotechnic
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 5), "Enhancement: Pyrotechnic {0}".format(iconString(Icon.FIRE)), "Dealing damage, within 15 meters, sets enemies on fire", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Plague Doctor
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 6), "Enhancement: Plague Doctor {0}".format(iconString(Icon.PLUS)), "Deal more healing to infected players while reducing their infection level", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Born to Battle
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 7), "Enhancement: Born to Battle {0}".format(iconString(Icon.BOLT)), "Dealing a final blow will give the player a cooldown reset on the next ability they use", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Charge Battery
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 8), "Enhancement: Charge Battery {0}".format(iconString(Icon.SPIRAL)), "Survivor can place a battery that gives ultimate charge", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, rgb(236, 206, 44), rgb(236, 206, 44), rgb(236, 206, 44), HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Hitchhiker
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 9), "Enhancement: Hitchhiker {0}".format(iconString(Icon.FLAG)), "Survivor can attach to a teammate and fuse their health.", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: P.U.P.
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 10), "Enhancement: P.U.P. {0}".format(iconString(Icon.HAPPY)), "Survivor is equipped with an autonomous friendly droid", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)


rule "SPECIAL EFFECT CONTROLS":
    @Condition specialGameModeSetup == true
    
    if specialGameModeSetup:
        randVal = random.randint(1, 3)
        if randVal == 1:
            specialEffectsStrings = "alglChene oteV: KaMeNrldEr"
        elif randVal == 2:
            specialEffectsStrings = "You won't win"
        elif randVal == 3:
            specialEffectsStrings = "Don't even try it"
    specialEffectsTiming = true
    wait(random.uniform(0.063, 0.325), Wait.ABORT_WHEN_FALSE)
    specialEffectsTiming = false
    wait(random.uniform(0.325, 1.5), Wait.ABORT_WHEN_FALSE)
    loop()


rule "END VOTING":
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition getMatchTime() < votingEndTime
    @Condition len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[0] > 0)) > 0
    
    chase1 = votingEndTime
    startRule(determineZombieMode)
    #Waits until votes have been counted
    waitUntil(not voting, 99999)
    getPlayers(Team.1).playerMenuStatus[2] = challengeSetting
    getPlayers(Team.1).playerMenuStatus[3] = zombieSetting
    getPlayers(Team.1).playerMenuStatus[4] = objectiveTypeSetting
    bigMessage(getAllPlayers(), "Voting has ended!")
    startRule(setPrematchTimer)


def setPrematchTimer():
    @Name "setPrematchTimer"
    
    #Cancel if hidden timer has not been set
    if not chase1:
        return
    #Voting in progress
    if voting:
        #Event player is voting
        if eventPlayer.playerMenuStatus[1] == 1:
            #Set match time to hidden timer
            setMatchTime(chase1)
        #Event Player is not voting
        else:
            #All players are finished voting
            if getMatchTime() > 5 + votingEndTime and ((len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[1] == 0 and player.playerMenuStatus[0] > 0))) == getNumberOfPlayers(Team.1)):
                setMatchTime(5 + votingEndTime)
            elif getMatchTime() > 20 + votingEndTime and ((len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[1] == 0 and player.playerMenuStatus[0] > 0))) == len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus))):
                setMatchTime(20 + votingEndTime)
    #Voting complete
    else:
        #Event Player deselects hero
        if eventPlayer.playerMenuStatus[0] < 2:
            setMatchTime(chase1)
        else:
            if getMatchTime() > 10 and len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[0] == 2)) == getNumberOfPlayers(Team.1):
                setMatchTime(15)
                wait()
                setMatchTime(10)
            elif getMatchTime() > 20 and len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[0] == 2)) == len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus)):
                setMatchTime(20)


rule "MUSIC/ANNOUNCER CONTROL":
    @Condition voting != true
    @Condition specialGameModeSetup == true
    
    if getMatchTime() < 20:
        enableMusic()
        enableAnnouncer()
        waitUntil(getMatchTime() > 20 or not specialGameModeSetup, 60)
    else:
        disableMusic()
        disableAnnouncer()
        waitUntil(getMatchTime() < 20 or not specialGameModeSetup, 60)
    if ruleCondition:
        loop()


rule "============================================== PLAYER START MENU ====================================================":
    @Disabled
    @Delimiter
    


rule "PLAYER MENU INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition startMenuSpacingAngle != 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    eventPlayer.enhancementValues[0] = 0
    if voting:
        #0) Hero Selection Status, 1) Voting Status, 2) Difficulty Vote, 3) Zombie Vote, 4) Objective Type Vote
        eventPlayer.playerMenuStatus = [0, 0, 0, 0]
    else:
        #0) Hero Selection Status, 1) Voting Status, 2) Difficulty Vote, 3) Zombie Vote, 4) Objective Type Vote
        eventPlayer.playerMenuStatus[2] = difficultySetting
        eventPlayer.playerMenuStatus[3] = zombieSetting
        eventPlayer.playerMenuStatus[4] = objectiveTypeSetting
    eventPlayer.startPos = startCamPos + vect(0, -1.5, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + startMenuSpacingAngle + (eventPlayer.getSlot() * (startMenuSpacingAngle * -2 / (max(getNumberOfSlots(Team.1) - 1, 1)))), 0)) * startCamDistance)
    if not specialGameMode:
        eventPlayer.startPos = raycastHitPosition(eventPlayer.startPos + vect(0, 3, 0), eventPlayer.startPos, getAllPlayers(), getAllPlayers(), false)
    enableDisableAbilities()


rule "EFFECTS/TEXT":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.playerActiveStatus == true
    
    if not specialGameMode:
        #Invis start ring
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[0] < 2), Effect.RING, Color.SKY_BLUE, eventPlayer.startPos, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        #Invis start light shaft
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[0] < 2), Effect.LIGHT_SHAFT, Color.SKY_BLUE, eventPlayer.startPos + vect(0, -10, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #In world hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[0] < 2), heroIcon(eventPlayer.getHero()) if eventPlayer.playerMenuStatus[0] == 1 else "?", eventPlayer.startPos + vect(0, 0.5, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Selecting hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[0] < 2 and eventPlayer.playerMenuStatus[1] == 0), "SELECTING HERO..." if eventPlayer.playerMenuStatus[0] < 1 else "Getting Ready...", eventPlayer.startPos + vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    #Voting text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[1] == 1), "Voting...", eventPlayer.startPos + (vect(0, 1.5 if eventPlayer.playerMenuStatus[0] < 2 else -1, 0)), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE)
    #Name text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.playerMenuStatus[0] < 2), eventPlayer, eventPlayer.startPos + vect(0, -1, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    #Enhancement icon
    createInWorldText(getAllPlayers(), enhancementOptions[eventPlayer.enhancementValues[0]], eventPlayer.startPos + vect(0, 2.25, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)


rule "PLAYER SELECTS/RESELECTS HERO":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition startMenuSpacingAngle != 0
    @Condition eventPlayer.playerMenuStatus[0] == 0
    @Condition eventPlayer.hasSpawned() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startRule(setPrematchTimer)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startCamera(startCamPos, startPos + vect(0, 1, 0))
    eventPlayer.startHealingOverTime(null, 5, 1000)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    #If current game mode is team deathmatch
    if specialGameMode:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.startPos, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
    else:
        eventPlayer.teleport(eventPlayer.startPos)
    wait()
    #Set invisiblity status to 0 each time hero is selected/reselected
    eventPlayer.invisible = 0
    eventPlayer.setFacing(directionTowards(eventPlayer.startPos, vect(startCamPos.x, eventPlayer.startPos.y, startCamPos.z)), Relativity.TO_WORLD)
    wait()
    eventPlayer.playerMenuStatus[0] = 1
    wait()
    if not eventPlayer.playerActiveStatus:
        smallMessage(eventPlayer, "Use the voting options in the top left corner of your screen to adjust the game settings")
        eventPlayer.playerActiveStatus = true
        wait(5, Wait.RESTART_WHEN_TRUE)
        #Force players that have not voted or selected an enhancement to lock in their hero
        if voting and (eventPlayer.playerMenuStatus.slice(2, 3).all(lambda x: x == 0 and eventPlayer.enhancementValues[0] == 0)) or not voting and eventPlayer.enhancementValues[0] == 0:
            eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.playerMenuStatus[0] > 0
    @Condition (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) == true
    @Condition eventPlayer.hasSpawned() == true
    
    #Player indicates they are ready
    if eventPlayer.isHoldingButton(Button.JUMP):
        if eventPlayer.playerMenuStatus[0] < 2:
            eventPlayer.playerMenuStatus[0]++
            if eventPlayer.playerMenuStatus[0] == 2:
                startRule(setPrematchTimer)
                startRule(randomActions)
                eventPlayer.setInvisibility(Invis.NONE)
    #Not ready or change hero
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.setInvisibility(Invis.ALL)
        if eventPlayer.playerMenuStatus[0] > 0:
            eventPlayer.playerMenuStatus[0] += -1
            startRule(setPrematchTimer)
            if eventPlayer.playerMenuStatus[0] == 0:
                #Update player voting status
                eventPlayer.playerMenuStatus[1] = 0
                eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
                waitUntil(not eventPlayer.hasSpawned(), 1)
                wait()
                eventPlayer.setAllowedHeroes(getAllHeroes())


rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #Update player voting status
    eventPlayer.playerMenuStatus[1] = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.playerMenuStatus[2] < len(challengeVotes) - 1:
            eventPlayer.playerMenuStatus[2]++
        else:
            eventPlayer.playerMenuStatus[2] = 0
        while not challengeVotes[eventPlayer.playerMenuStatus[2]][1]:
            if eventPlayer.playerMenuStatus[2] < len(challengeVotes) - 1:
                eventPlayer.playerMenuStatus[2]++
            else:
                eventPlayer.playerMenuStatus[2] = 0
    else:
        if eventPlayer.playerMenuStatus[2] > 0:
            eventPlayer.playerMenuStatus[2] += -1
        else:
            eventPlayer.playerMenuStatus[2] = len(challengeVotes) - 1
        while not challengeVotes[eventPlayer.playerMenuStatus[2]][1]:
            if eventPlayer.playerMenuStatus[2] > 0:
                eventPlayer.playerMenuStatus[2] += -1
            else:
                eventPlayer.playerMenuStatus[2] = len(challengeVotes) - 1


rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #Update player voting status
    eventPlayer.playerMenuStatus[1] = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.playerMenuStatus[3] < len(zombieVotes) - 1:
            eventPlayer.playerMenuStatus[3]++
        else:
            eventPlayer.playerMenuStatus[3] = 0
        while not zombieVotes[eventPlayer.playerMenuStatus[3]][1]:
            if eventPlayer.playerMenuStatus[3] < len(zombieVotes) - 1:
                eventPlayer.playerMenuStatus[3]++
            else:
                eventPlayer.playerMenuStatus[3] = 0
    else:
        if eventPlayer.playerMenuStatus[3] > 0:
            eventPlayer.playerMenuStatus[3] += -1
        else:
            eventPlayer.playerMenuStatus[3] = len(zombieVotes) - 1
        while not zombieVotes[eventPlayer.playerMenuStatus[3]][1]:
            if eventPlayer.playerMenuStatus[3] > 0:
                eventPlayer.playerMenuStatus[3] += -1
            else:
                eventPlayer.playerMenuStatus[3] = len(zombieVotes) - 1


rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #Update player voting status
    eventPlayer.playerMenuStatus[1] = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.playerMenuStatus[4] < len(objectiveTypeVotes) - 1:
            eventPlayer.playerMenuStatus[4]++
        else:
            eventPlayer.playerMenuStatus[4] = 0
        while not objectiveTypeVotes[eventPlayer.playerMenuStatus[4]][1]:
            if eventPlayer.playerMenuStatus[4] < len(objectiveTypeVotes) - 1:
                eventPlayer.playerMenuStatus[4]++
            else:
                eventPlayer.playerMenuStatus[4] = 0
    else:
        if eventPlayer.playerMenuStatus[4] > 0:
            eventPlayer.playerMenuStatus[4] += -1
        else:
            eventPlayer.playerMenuStatus[4] = len(objectiveTypeVotes) - 1
        while not objectiveTypeVotes[eventPlayer.playerMenuStatus[4]][1]:
            if eventPlayer.playerMenuStatus[4] > 0:
                eventPlayer.playerMenuStatus[4] += -1
            else:
                eventPlayer.playerMenuStatus[4] = len(objectiveTypeVotes) - 1


rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.enhancementValues[0] < len(enhancementOptions) - 1:
            eventPlayer.enhancementValues[0]++
        else:
            eventPlayer.enhancementValues[0] = 0
        while not enhancementOptions[eventPlayer.enhancementValues[0]]:
            if eventPlayer.enhancementValues[0] < len(enhancementOptions) - 1:
                eventPlayer.enhancementValues[0]++
            else:
                eventPlayer.enhancementValues[0] = 0
    else:
        if eventPlayer.enhancementValues[0] > 0:
            eventPlayer.enhancementValues[0] += -1
        else:
            eventPlayer.enhancementValues[0] = len(enhancementOptions) - 1
        while not enhancementOptions[eventPlayer.enhancementValues[0]]:
            if eventPlayer.enhancementValues[0] > 0:
                eventPlayer.enhancementValues[0] += -1
            else:
                eventPlayer.enhancementValues[0] = len(enhancementOptions) - 1


rule "UPDATE PREGAME VOTING STATUS":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.playerMenuStatus[1] == 1
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    
    startRule(setPrematchTimer)
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.playerMenuStatus[1] = 0
    startRule(setPrematchTimer)


rule "PREVENT PLAYERS FROM LEAVING START EARLY":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.playerMenuStatus[0] > 0
    @Condition distance(eventPlayer.getPosition(), vect(eventPlayer.startPos.x, eventPlayer.getPosition().y, eventPlayer.startPos.z)) > 0.6
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    if not specialGameMode:
        eventPlayer.teleport(eventPlayer.startPos)
    else:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.startPos, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
    if ruleCondition:
        loop()


def randomActions():
    @Name "randomActions"
    
    eventPlayer.randVal = random.randint(1, 4)
    #Random emote
    if eventPlayer.randVal <= 1:
        eventPlayer.communicate(Comms.EMOTE_UP)
    elif eventPlayer.randVal <= 2:
        eventPlayer.communicate(Comms.EMOTE_DOWN)
    elif eventPlayer.randVal <= 3:
        eventPlayer.communicate(Comms.EMOTE_LEFT)
    elif eventPlayer.randVal <= 4:
        eventPlayer.communicate(Comms.EMOTE_RIGHT)
    wait(1)
    eventPlayer.randVal = random.randint(1, 4)
    #Random voice line
    if eventPlayer.randVal <= 1:
        eventPlayer.communicate(Comms.VOICE_LINE_UP)
    elif eventPlayer.randVal <= 2:
        eventPlayer.communicate(Comms.VOICE_LINE_DOWN)
    elif eventPlayer.randVal <= 3:
        eventPlayer.communicate(Comms.VOICE_LINE_LEFT)
    elif eventPlayer.randVal <= 4:
        eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)


def enableDisableAbilities():
    @Name "enableDisableAbilities"
    
    if specialGameModeSetup:
        eventPlayer.disableHeroHud()
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.setSecondaryFireEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setAbility2Enabled(false)
        eventPlayer.setUltEnabled(false)
        eventPlayer.setMeleeEnabled(false)
    else:
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setMeleeEnabled(true)
        eventPlayer.enableHeroHud()


rule "============================================== GLOBAL GAME IN PROGRESS ====================================================":
    @Disabled
    @Delimiter
    


rule "EFFECTS/TEXTS":
    @Condition isGameInProgress() == true
    @Condition specialGameModeSetup != true
    
    wait(1)
    #Objective description and match timer
    hudSubtext(getAllPlayers(), "{0}{1}".format(objectiveDescription, (" | {0}".format("{0}s".format(getMatchTime()) if getMatchTime() <= 60 else "{0}:{2}{1}".format(floor(getMatchTime() / 60), floor(getMatchTime() % 60), 0 if floor(getMatchTime() % 60) < 10 else []))) if getMatchTime() > 0 + matchEndTime else []), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Infected Hud
    hudHeader(getAllPlayers().filter(lambda player: ((player.enhancementValues[0] != 2 and (len(healthpackPositions) == 0 or player.getHealth() < floor(player.infectionLvl) ** 2 * 20)) and player.infected) and getMatchTime() > matchEndTime), "{0} Find a healthpack {0}".format(iconString(Icon.PLUS)), HudPosition.RIGHT, 0, (Color.RED if localPlayer.getHealth() < floor(localPlayer.infectionLvl) ** 2 * 10 else Color.LIME_GREEN) if ceil(getTotalTimeElapsed() * 2) % 2 == 0 else Color.WHITE, HudReeval.VISIBILITY_AND_COLOR)
    #Nearest Healthpack Distance
    createInWorldText(getPlayers(Team.1).filter(lambda player: player.enhancementValues[0] != 2 and len(healthpackPositions) > 0 and player.infected and getMatchTime() > matchEndTime), "Cure: {0}m".format(distance(localPlayer.getPosition(), sorted(healthpackPositions, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0])), sorted(healthpackPositions, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN, SpecVisibility.NEVER)
    #Nearest health pack icon
    createIcon(getPlayers(Team.1).filter(lambda player: player.enhancementValues[0] != 2 and len(healthpackPositions) > 0 and player.infected and getMatchTime() > matchEndTime), sorted(healthpackPositions, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0] + vect(0, 0.75, 0) + vect(0, 0.5, 0), Icon.POISON, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN)
    hudSubtext(getAllPlayers(), "Modified version. workshop.codes/786tw", HudPosition.RIGHT, 0.1, Color.TEAM_1, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers().filter(lambda _: challengeSetting >= 2), "Challenge round!", HudPosition.RIGHT, 0.2, Color.TEAM_1, HudReeval.VISIBILITY_AND_STRING)


rule "PLAYER EXTRACTION CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer in evacuatingSurvivorList == true
    
    eventPlayer.chase2 = eventPlayer.getPosition()
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), evacRate)
    eventPlayer.startForcingPosition(eventPlayer.chase2)
    waitUntil(evacRate > 2, 99999)
    chaseOverTime(eventPlayer.chase2, objectivePositions[0] + vect(0, 50, 0) + directionFromAngles(360 / len(evacuatingSurvivorList) * evacuatingSurvivorList.index(eventPlayer), 0) * 3, 5)
    waitUntil(evacRate < 10, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.chase2 + vect(0, 200, 0), evacRate)
    eventPlayer.evacPos = eventPlayer.chase2 + directionTowards(objectivePositions[0], evacDestination) * 700
    waitUntil(evacRate > 2, 99999)
    chaseAtRate(eventPlayer.chase2, eventPlayer.evacPos, evacRate)


rule "ATTACK SPAWN ROOM CONTROL":
    @Condition specialGameModeSetup != true
    #Does not apply if game mode is special mode
    @Condition specialGameMode != true
    @Condition playerTargetList.any(lambda x: distance(x.getPosition(), activeAttackSpawnRoom) < 45) == true
    
    spawnRoomIndex++
    if spawnRoomIndex >= len(attackSpawnRooms):
        spawnRoomIndex = 0
    #Make sure players are clear of test spawn room before activating
    if getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x.getPosition(), attackSpawnRooms[spawnRoomIndex]) > 45):
        activeAttackSpawnRoom = attackSpawnRooms[spawnRoomIndex]
        startForcingSpawn(Team.2, spawnRoomIndex)
    wait(1)
    if ruleCondition:
        loop()


rule "PREVENT MATCH TIME FROM UNPAUSING":
    @Condition gameStatus == true
    @Condition getMatchTime() < matchEndTime
    
    pauseMatchTime()
    setMatchTime(matchEndTime)
    wait()
    if ruleCondition:
        loop()


rule "TRIGGER OVERTIME MUSIC":
    @Condition gameStatus == true
    @Condition overtime == false
    @Condition getMatchTime() < matchEndTime + 3
    @Condition (len(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bosses))) > 0
    
    enableMusic()
    if not specialGameMode:
        overtime = true
        if getCurrentGamemode() == Gamemode.ESCORT:
            ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bosses))[0]).teleport(getPayloadPosition())
        else:
            ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bosses))[0]).teleport(getObjectivePosition(0))


rule "ZOMBIE SHUFFLE":
    @Condition gameStatus == true
    @Condition zombieSetting == 4
    
    #Bot respawn probablities
    botSpawnRates = random.shuffle(botSpawnRates)
    bigMessage(getAllPlayers(), "The spawn rates have been shuffled!")
    #1 min 30 sec wait
    wait(90)
    if ruleCondition:
        loop()


rule "SWARM SHOOTOUT":
    @Event eachPlayer
    @Team 2
    @Condition (challengeSetting == 2 or challengeSetting == 5) == true
    
    startDamageModification(getPlayers(Team.1), eventPlayer, 72)
    waitUntil(eventPlayer.botTarget != false, 99999)
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:
    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "RANDOM ABILITIES":
    @Event eachPlayer
    @Team 2
    @Condition (challengeSetting == 3 or challengeSetting == 5 or gameSmolderEvent) == true
    @Condition eventPlayer in bosses != true
    @Condition specialGameModeSetup == false
    
    wait(random.uniform(2, 8))
    if eventPlayer.getHero() in [Hero.MERCY]:
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
    else:
        eventPlayer.forceButtonPress(random.choice([Button.ABILITY_2, Button.ABILITY_1]))
        if eventPlayer.getHero() in [Hero.SYMMETRA] and eventPlayer.isUsingAbility2():
            abilityPlacement()
        elif eventPlayer.getHero() == Hero.JUNKRAT and eventPlayer.isUsingAbility1() or eventPlayer.getHero() == Hero.MOIRA and eventPlayer.isUsingAbility2():
            wait(1)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        if ruleCondition:
            loop()


rule "PLAYER LEAVES THE GAME":
    @Event playerLeft
    @Condition (playerTargetList.any(lambda x: not entityExists(x)) or playersOnObjective.any(lambda x: not entityExists(x))) == true
    
    playerTargetList.remove(playerTargetList.filter(lambda x: not entityExists(x)))
    playersOnObjective.remove(playersOnObjective.filter(lambda x: not entityExists(x)))
    wait(1, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()
    startRule(setDifficulty)


rule "INFECTION DOME DAMAGE":
    @Event eachPlayer
    @Team 1
    @Hero jetpackCat
    @Disabled
    @Delimiter
    


rule "OBJECTIVE COMPLETE":
    @Condition gameStatus == true
    @Condition objectiveComplete == true
    
    startRule(objectivesManagement)
    (getDeadPlayers(Team.1).filter(lambda player: player.deathTimer < 50)).deathTimer += 10


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
    for count2 in range(400):
        kill(getPlayers(Team.1).filter(lambda player: not player in evacuatingSurvivorList))
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, rgb(255, random.uniform(100, 255), 0), mapGrid + (directionFromAngles(random.uniform(0, 360), 0) * (random.randint(0, (count2 / 20) ** 2 + 1))), (count2 / 18) ** 2)
        wait()


def objectivesManagement():
    @Name "objectivesManagement"
    
    if gameStatus:
        playersOnObjective = []
        objectiveCaptureValue = 0
        gameSmolderEvent = false
        goalPost = 0
        goalCheck = false
        #Checks if current objective is showdown
        if objectiveTypes[0] == 1:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositions[0], objectiveRad * 2)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, objectivePositions[0], 200)
            bigMessage(getAllPlayers(), "Showdown Conquered!")
        #Checks if current objective is bosses
        elif objectiveTypes[0] == 2:
            bigMessage(getAllPlayers(), "Giant zombie eliminated!")
        #Checks if current objective is biomorphing
        elif objectiveTypes[0] == 3:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, objectivePositions[0], objectiveRad)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ROSE, objectivePositions[0], 200)
            bigMessage(getAllPlayers(), "Biomorphing completed!")
        #Checks if current objective is survivor rescue
        elif objectiveTypes[0] == 4:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.VIOLET, objectivePositions[0], objectiveRad)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.VIOLET, objectivePositions[0], 200)
            bigMessage(getAllPlayers(), "The survivors have been rescued!")
        #Checks if current objective is kill zone
        elif objectiveTypes[0] == 5:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, objectiveChase1, 200)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, objectiveChase1, objectiveRad * 2)
            bigMessage(getAllPlayers(), "The kill zone has been cleared!")
        #Checks if current objective is Zombie Egg
        elif objectiveTypes[0] == 6:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, objectivePositions[0], 200)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], objectiveRad * 2)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], 3)
            bigMessage(getAllPlayers(), "The egg has been destroyed!")
        #Checks if current objective is Satellite Uplink
        elif objectiveTypes[0] == 7:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, objectivePositions[0], 200)
            bigMessage(getAllPlayers(), "Firing sequence complete!")
        wait()
        del objectivePositions[0]
        del objectiveTypes[0]
        bosses = []
        survivorToRescue = null
    wait(0.25)
    if len(objectivePositions) == 1:
        playersOnObjective = []
        objectiveDescription = "Proceed to the extraction point"
        #Shrink extraction zone radius down to size of extraction point
        chaseAtRate(extractionZoneRad, 0, extractionSpeedUp)
        objectiveRad = 10
        bigMessage(getAllPlayers(), "Get to the extraction point!")
    else:
        if objectiveTypes[0] == 1:
            objectiveDescription = "Keep zombies away in the Showdown!"
            objectiveCaptureValue = 0
            chaseAtRate(objectiveRad, max(5, objectiveCaptureValue / 4), 1)
            objectiveColor = Color.ORANGE
            bigMessage(getAllPlayers(), "Proceed to the Showdown!")
            goalPost = 25
            queuedGoalType = []
        elif objectiveTypes[0] == 2:
            objectiveDescription = "Eliminate the boss"
            bigMessage(getAllPlayers(), "Eliminate the giant zombie!")
        elif objectiveTypes[0] == 3:
            objectiveDescription = "Convert biowaste into powerups!"
            objectiveCaptureValue = 0
            objectiveResourcePositions = []
            getAllPlayers().playerObjectiveResourceValue = 0
            objectiveColor = rgb(135, 206, 250)
            objectiveRad = 3.5
            bigMessage(getAllPlayers(), "Find the indicated material and deposit it!")
            biowasteColorLookUp = [Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE, Color.RED]
            biowasteTextLookUp = ["Head", "Arm", "Leg"]
            queuedGoalType = random.shuffle([0, 1, 2, 3])
            goalCheck = true
            goalPost = 25
        elif objectiveTypes[0] == 4:
            objectiveDescription = "Rescue survivors"
            survivorToRescue = null
            objectiveRad = 10
            objectiveChase1 = objectiveRad
            bigMessage(getAllPlayers(), "Locate survivors and bring them to the extraction site!")
        elif objectiveTypes[0] == 5:
            objectiveDescription = "Clear the kill zone"
            objectiveRad = 20
            eliminationsNeededPerObjective = 50
            objectiveChase1 = objectivePositions[0]
            bigMessage(getAllPlayers(), "Get to the kill zone and clear zombies!")
            objectiveCaptureValue = 0
        elif objectiveTypes[0] == 6:
            objectiveDescription = "Destroy the egg"
            objectiveRad = 0
            bigMessage(getAllPlayers(), "Destroy the zombie egg!")
        elif objectiveTypes[0] == 7:
            objectiveDescription = "Repair satellite control terminals"
            objectiveRad = 3
            objectiveColor = rgb(28, 169, 201)
            objectiveResourcePositions = []
            objectiveCaptureValue = [0, 0, 0]
            #Initial terminal spacing
            testPos2 = 50
            bigMessage(getAllPlayers(), "Repair the satellite control terminals!")
    #Updates global objective entities
    globalObjectiveEntityManagement()
    objectiveComplete = false


def globalObjectiveEntityManagement():
    @Name "globalObjectiveEntityManagement"
    
    objectiveValue = objectiveTypes[0]
    #Destroy all current objective effects and texts
    for objectiveEntityCount in range(len(objectiveEntities)):
        destroyProgressBarHud(objectiveEntities[objectiveEntityCount])
        destroyProgressBarInWorldText(objectiveEntities[objectiveEntityCount])
        destroyEffect(objectiveEntities[objectiveEntityCount])
        destroyHudText(objectiveEntities[objectiveEntityCount])
        destroyIcon(objectiveEntities[objectiveEntityCount])
        destroyInWorldText(objectiveEntities[objectiveEntityCount])
        wait()
    objectiveEntities = []
    #Capture Point/Extraction Point
    if objectiveValue == 1:
        #Extraction Point
        if len(objectivePositions) == 1:
            #Extraction distance
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "Distance: {0}m".format(distance(objectivePositions[0], vect(localPlayer.getPosition().x, objectivePositions[0].y, localPlayer.getPosition().z) if objectivePositions[0].y - localPlayer.getEyePosition().y < 2 else localPlayer.getPosition())), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.SKY_BLUE, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())
            #Extraction zone dome
            createEffect(getLivingPlayers(Team.1).filter(lambda _: extractionZoneRad < 200), Effect.SPHERE, Color.LIME_GREEN, objectivePositions[0], extractionZoneRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction point boundary 1
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction point boundary 2
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, 22, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction point boundary 3
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, 46, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction icon
            createIcon(getAllPlayers().exclude(playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.SKY_BLUE)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction text
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "GET TO THE EXTRACTION POINT", objectivePositions[0] + vect(0, 5, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
            objectiveEntities.append(getLastCreatedText())
        #Standoff
        else:
            #Objective distance
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectivePositions[0])), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())
            #Zone Ring
            createEffect(localPlayer.filter(lambda _: localPlayer.getPosition().y > objectivePositions[0].y + 4), Effect.RING, objectiveColor, objectivePositions[0], objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Zone Ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, vect(objectivePositions[0].x, localPlayer.getPosition().y, objectivePositions[0].z), objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective boundary (Light Shaft)
            createEffect(playersOnObjective, Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -30, 0), objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective beacon
            createEffect(getAllPlayers().filter(lambda _: len(playersOnObjective) > 0), Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -10, 0), objectiveRad / 20)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective icon
            createIcon(getAllPlayers().exclude(playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedEntity())
            #Capture percentage text
            createInWorldText(playersOnObjective, "CAPTURE PERCENTAGE: {0}%".format(floor(objectiveCaptureValue)), objectivePositions[0] + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedText())
            #Capture percentage hud text
            hudText(getAllPlayers(), "Capture Percentage: {0}%".format(floor(objectiveCaptureValue)), "Objectives remaining: {0}".format(len(objectivePositions) - 1), "{0} {2}".format("Allies: {0}".format(len(playersOnObjective)) if len(playersOnObjective) > 0 else [], null, "Foes: {0}".format(len(queuedGoalType)) if len(queuedGoalType) > 0 else []), HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            objectiveEntities.append(getLastCreatedText())
    #Bosses
    elif objectiveValue == 2:
        #Boss health progress bar
        progressBarHud(getAllPlayers().filter(lambda _: len(bosses) > 0), bosses[0].getNormalizedHealth() * 100, "Boss Health {0}".format(heroIcon(bosses[0].getHero())), HudPosition.TOP, 2, Color.RED, Color.RED)
        objectiveEntities.append(getLastCreatedText())
        #Objectives remaining hud text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1) if objectiveTypeSetting != 3 else "Giant Zombies Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Boss icon
        createIcon(getAllPlayers(), bosses[0].getEyePosition() + Vector.UP if len(bosses) > 0 else objectivePositions[0], Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.RED)
        objectiveEntities.append(getLastCreatedEntity())
        #Boss Distance
        createInWorldText(getAllPlayers().filter(lambda player: len(bosses) == 0 or not player in bosses[0].potentialTargets), "Distance: {0}m".format(distance(localPlayer.getPosition(), bosses[0].getPosition()) if len(bosses) > 0 else distance(localPlayer.getPosition(), objectivePositions[0])), bosses[0].getPosition() if len(bosses) > 0 else objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
    #Biomoprhing
    elif objectiveValue == 3:
        #Global progress bar
        hudText(getAllPlayers(), "{0} | {1}%".format(goalText, floor(objectiveCaptureValue)), "Objectives remaining: {0}".format(len(objectivePositions) - 1), null, HudPosition.TOP, 1, goalColor, objectiveColor, null, HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntities.append(getLastCreatedText())
        #Collection type text
        hudSubheader(localPlayer.filter(lambda _: localPlayer.playerObjectiveResourceValue > 0), "Turn in your health at the deposit area" if queuedGoalType[0] == 3 else "You have a zombie {0}".format(biowasteTextLookUp[localPlayer.biowasteType]), HudPosition.TOP, 2, biowasteColorLookUp[localPlayer.biowasteType], HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntities.append(getLastCreatedText())
        #Collection site icon
        createIcon(getPlayers(Team.1).filter(lambda player: player.playerObjectiveResourceValue > 0 and not player in playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, objectiveColor)
        objectiveEntities.append(getLastCreatedEntity())
        #Collection site ring
        createEffect(getPlayers(Team.1), Effect.RING, Color.WHITE, objectivePositions[0] + vect(0, -1, 0), objectiveRad, EffectReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedEntity())
        #Biowaste deposit site boundary (Light Shaft)
        createEffect(playersOnObjective, Effect.LIGHT_SHAFT, biowasteColorLookUp[localPlayer.biowasteType], objectivePositions[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_AND_COLOR)
        objectiveEntities.append(getLastCreatedEntity())
        #Depositing resources progress bar
        createProgressBarInWorldText(localPlayer.filter(lambda x: x in playersOnObjective), ceil(localPlayer.getNormalizedHealth() * 100) if queuedGoalType[0] == 3 else localPlayer.playerObjectiveResourceValue / amountPerResource * 100, "Depositing Biowaste...", updateEveryFrame(localPlayer.getEyePosition() + (directionFromAngles(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) + 15))) if localPlayer in playersOnObjective else evalOnce(localPlayer.getPosition()), 1, Clip.NONE, biowasteColorLookUp[localPlayer.biowasteType], Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Collection site distance (or closest resource distance)
        createInWorldText(localPlayer.filter(lambda x: not x in playersOnObjective and (localPlayer.playerObjectiveResourceValue > 0 or len(objectiveResourcePositions) > 0)), "Distance: {0}m".format(distance(objectivePositions[0] if localPlayer.playerObjectiveResourceValue > 0 else sorted(objectiveResourcePositions, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], localPlayer.getPosition())), objectivePositions[0] if localPlayer.playerObjectiveResourceValue > 0 else sorted(objectiveResourcePositions, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
    #Survivor Rescue
    elif objectiveValue == 4:
        #Extraction site light shaft 2
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.VIOLET, objectivePositions[0] + vect(0, -2, 0), 5, EffectReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedEntity())
        #Objectives remaining text
        hudSubheader(getPlayers(Team.1), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.VIOLET, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), survivorToRescue[0].getPosition()) < objectiveRad and distance(player.getPosition(), objectivePositions[0]) > 5), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.VIOLET)
        objectiveEntities.append(getLastCreatedEntity())
    #Killzone
    elif objectiveValue == 5:
        #Kill Zone Progress Bar
        progressBarHud(getAllPlayers(), objectiveCaptureValue / eliminationsNeededPerObjective * 100, "Kill Zone Elimination Progress", HudPosition.TOP, 2, Color.RED, Color.RED, ProgressHudReeval.VISIBILITY_AND_VALUES)
        objectiveEntities.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectiveChase1) - objectiveRad), objectiveChase1, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), objectiveChase1 + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.RED)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone Sphere
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), Effect.SPHERE, Color.GRAY, objectiveChase1, objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone Ring
        createEffect(getAllPlayers(), Effect.RING, Color.RED, vect(objectiveChase1.x, localPlayer.getPosition().y, objectiveChase1.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - objectiveChase1.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone light shaft
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) < objectiveRad), Effect.LIGHT_SHAFT, Color.RED, vect(objectiveChase1.x, localPlayer.getPosition().y + -29, objectiveChase1.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - objectiveChase1.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
    #Zombie Egg
    elif objectiveValue == 6:
        #Zombie Egg Progress Bar
        progressBarHud(getAllPlayers().filter(lambda _: bosses[0] != null), bosses[0].getNormalizedHealth() * 100, "Zombie Egg Health", HudPosition.TOP, 2, Color.LIME_GREEN, Color.LIME_GREEN)
        objectiveEntities.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.LIME_GREEN, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers(), "Destroy: {0}m".format(distance(localPlayer.getPosition(), objectivePositions[0])), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.LIME_GREEN, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers(), objectivePositions[0] + vect(0, 1, 0), Icon.RADIOACTIVE, IconReeval.VISIBILITY_AND_POSITION, Color.LIME_GREEN)
        objectiveEntities.append(getLastCreatedEntity())
        #Egg visual
        createEffect(getAllPlayers().filter(lambda _: bosses[0] != null), Effect.SPHERE, Color.LIME_GREEN, objectivePositions[0], 2.5 + abs(0.5 * (sin(0.5 * getTotalTimeElapsed()))), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Egg toxic gas visual (stationary)
        createEffect(getAllPlayers(), Effect.CLOUD, Color.LIME_GREEN, objectivePositions[0] + vect(0, -1, 0), 25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
    #Satellite Uplink
    elif objectiveValue == 7:
        #Capture percentage hud text
        hudText(getAllPlayers(), "{0}% | {1}% | {2}%".format(floor(objectiveCaptureValue[0]), floor(objectiveCaptureValue[1]), floor(objectiveCaptureValue[2])), "Objectives remaining: {0}".format(len(objectivePositions) - 1), [], HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_AND_STRING)
        objectiveEntities.append(getLastCreatedText())
        #Fixing terminal light shaft
        createEffect(playersOnObjective, Effect.LIGHT_SHAFT, objectiveColor, sorted(objectiveResourcePositions, lambda x: distance(localPlayer.getPosition(), x))[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Current terminal repair percentage
        createInWorldText(playersOnObjective, "{0}%".format(floor(objectiveCaptureValue[objectiveResourcePositions.index(sorted(objectiveResourcePositions, lambda x: distance(localPlayer.getPosition(), x))[0])])), updateEveryFrame(localPlayer.getEyePosition() + ((directionFromAngles(localPlayer.getHorizontalFacingAngle(), localPlayer.getVerticalFacingAngle() + 15)) * 200)), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor)
        objectiveEntities.append(getLastCreatedText())
        #Terminal effects
        for objectiveEntityCount in range(len(objectiveCaptureValue)):
            #Terminal icon
            createIcon(getPlayers(Team.1).filter(lambda player: distance(player.getPosition(), objectiveResourcePositions[evalOnce(objectiveEntityCount)]) > objectiveRad and objectiveCaptureValue[evalOnce(objectiveEntityCount)] < 100), objectiveResourcePositions[evalOnce(objectiveEntityCount)] + vect(0, 1, 0), Icon.BOLT, IconReeval.VISIBILITY_AND_POSITION, objectiveColor)
            objectiveEntities.append(getLastCreatedEntity())
            #Terminal repair area ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, objectiveResourcePositions[evalOnce(objectiveEntityCount)], objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            #Terminal "screen" light shaft
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, objectiveColor, objectiveResourcePositions[evalOnce(objectiveEntityCount)] + directionTowards(objectiveResourcePositions[evalOnce(objectiveEntityCount)], objectivePositions[0]) * objectiveRad * 0.8 + vect(0, -1.5, 0), 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective distance
            createInWorldText(getAllPlayers().filter(lambda player: objectiveCaptureValue[evalOnce(objectiveEntityCount)] < 100 and distance(player.getPosition(), objectiveResourcePositions[evalOnce(objectiveEntityCount)]) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectiveResourcePositions[evalOnce(objectiveEntityCount)])), objectiveResourcePositions[evalOnce(objectiveEntityCount)], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())


rule "============================================== OBJECTIVE TYPE: EXTRACTION POINT =============================================":
    @Disabled
    @Delimiter
    


rule "PLAYERS IN EXTRACTION POINT CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition objectiveComplete == false
    @Condition gameStatus == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) == 1
    @Condition objectivePositions[0].y - eventPlayer.getEyePosition().y < 2
    @Condition distance(eventPlayer.getPosition(), vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z)) < objectiveRad
    
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    extractionSpeedUp += 0.2 / len(playerTargetList)
    wait(0.5)
    if ruleCondition:
        loop()
    if gameStatus:
        playersOnObjective.remove(eventPlayer)


rule "EXTRACTION ZONE INFECTION INCREASE":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
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


rule "WIN/LOSS CONDITIONS":
    @Condition objectiveComplete == false
    @Condition gameStatus == true
    @Condition (len(objectivePositions) == 1 and (len(playersOnObjective) == (len(getPlayers(Team.1).filter(lambda player: player.hasSpawned() and player.deathTimer > 0 and not player.afk)))) or (len(playerTargetList) == 0 or extractionZoneRad <= 0)) == true
    
    if (len(playerTargetList) == 0 or playerTargetList == []) and getPlayersOnHero(Hero.ANRAN, Team.1).any(lambda player: player.getUltCharge() == 100):
        wait(5.5, Wait.ABORT_WHEN_FALSE)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    gameStatus = false
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
    getPlayers(Team.1).setStatusEffect(null, Status.ROOTED, 9999)
    getPlayers(Team.1).setStatusEffect(null, Status.PHASED_OUT, 9999)
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
        evacuatingSurvivorList = playersOnObjective
        (getPlayers(Team.1).filter(lambda player: not evacuatingSurvivorList[player])).clearStatusEffect(Status.ROOTED)
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


rule "============================================== OBJECTIVE TYPE: SHOWDOWN  ==============================================":
    @Disabled
    @Delimiter
    


rule "PLAYERS ON OBJECTIVE CONTROL":
    @Event eachPlayer
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    #Objective Cylinder Height As Above, So Below
    @Condition abs(objectivePositions[0].y - eventPlayer.getPosition().y) < 12
    #Objective Cylinder Radius
    @Condition distance(vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z), eventPlayer.getPosition()) < objectiveRad
    
    if eventPlayer.isDummy():
        if not eventPlayer in queuedGoalType:
            queuedGoalType.append(eventPlayer)
    else:
        if not eventPlayer in playersOnObjective:
            playersOnObjective.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    playersOnObjective.remove(eventPlayer)
    queuedGoalType.remove(eventPlayer)


rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE":
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(playersOnObjective) > 0
    @Condition objectiveComplete == false
    
    #Proceed to next objective
    if objectiveCaptureValue >= 100:
        stopChasing(objectiveRad)
        objectiveComplete = true
        queuedGoalType = []
        playersOnObjective = []
        return
    wait(1, Wait.RESTART_WHEN_TRUE)
    if not ruleCondition:
        return
    objectiveCaptureValue += len(playersOnObjective) + 0.25 if len(playersOnObjective) <= 3 else 3.25
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    if objectiveCaptureValue >= goalPost:
        goalPost += 25
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositions[0], objectiveRad * 2)
        if goalPost >= 100:
            goto lbl_0
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, objectivePositions[0], 100)
        smallMessage(getAllPlayers(), "  {0} Checkpoint Reached".format(iconString(Icon.FLAG)))
        lbl_0:
    if ruleCondition:
        loop()


rule "DECREASES CAPTURE PERCENTAGE":
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(queuedGoalType) > 0
    @Condition objectiveComplete == false
    @Condition objectiveCaptureValue > goalPost - 25
    
    wait(1, Wait.RESTART_WHEN_TRUE)
    if objectiveTypes[0] != 1:
        return
    if len(objectivePositions) <= 1:
        return
    objectiveCaptureValue -= (3 if len(queuedGoalType) > 3 else len(queuedGoalType)) if difficultySetting == 1 else len(queuedGoalType) + difficultySetting * 0.75
    playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, null, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    objectiveColor = Color.RED
    wait(0.5)
    if objectiveTypes[0] != 1:
        return
    if len(objectivePositions) <= 1:
        return
    objectiveColor = Color.ORANGE
    if ruleCondition:
        loop()


rule "============================================== OBJECTIVE TYPE: BOSSES ==================================================":
    @Disabled
    @Delimiter
    


rule "SPAWN BOSS":
    @Condition objectiveTypes[0] == 2
    @Condition objectiveComplete == false
    @Condition len(bosses.filter(lambda x: entityExists(x))) == 0
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.hasSpawned() and not player.teleporting and player.botTarget == null)) == true
    #Keeps amount of different bots within the max limit.
    @Condition len(botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)) < (uniqueSkinCap - (getNumberOfSlots(Team.1) if getNumberOfPlayers(Team.1) <= getNumberOfSlots(Team.1) else getNumberOfPlayers(Team.1)))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bosses[0] = (getLivingPlayers(Team.2).filter(lambda player: player.hasSpawned() and not miniBoss[player] and not player.teleporting and player.botTarget == null))[0]
    bosses.teleport(vect(500, 500, 500))
    waitUntil(bosses[0].initializing, 3)
    waitUntil(not bosses[0].initializing, 5)
    bosses.teleport(objectivePositions[0])
    while bosses.any(lambda x: x.isDead()):
        bosses.resurrect()
        waitUntil(bosses[0].isAlive(), 0.25)
    if not entityExists(bosses[0]):
        loop()
    if ruleCondition:
        loop()


rule "BOT BECOMES BOSS":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition objectiveComplete == false
    @Condition eventPlayer in bosses == true
    
    miniBoss.remove(eventPlayer)
    if eventPlayer.attached:
        eventPlayer.attached = false
        eventPlayer.detach()
    eventPlayer.setInvisibility(Invis.NONE)
    if len(availableBosses) == 0:
        if zombieSetting == 4:
            availableBosses = botHeros
        else:
            availableBosses = botHeros.filter(lambda _, i: botSpawnRates[i] > 0)
        if len(availableBosses) > len(nonBossZombies):
            availableBosses.remove(nonBossZombies)
    eventPlayer.disableNameplatesFor(getAllPlayers())
    eventPlayer.stopForcingName()
    eventPlayer.startForcingHero(random.choice(availableBosses))
    #Force a specific boss (FOR TESTING)
    #eventPlayer.startForcingHero(Hero.MERCY)
    botRespawnInitialization()
    #Remove Current Boss Hero From Available Boss List
    availableBosses.remove(eventPlayer.getHero())
    #Boss throttle speed
    eventPlayer.botThrottleSpeed = 0.9 if eventPlayer.getHero() == Hero.REINHARDT else 0.65
    #Health pool size as boss
    eventPlayer.health = 15000
    eventPlayer.bossHealth = eventPlayer.health
    eventPlayer.size = createWorkshopSettingFloat("Zombies", "Boss Size", 2.5, 0, 20)
    eventPlayer.startScalingSize(eventPlayer.size + 1 if eventPlayer.getHero() == Hero.EMRE else eventPlayer.size, false)
    #Scale zombie voice lines with size
    eventPlayer.startModifyingVoicelinePitch(0.5 + (1 / (eventPlayer.size + 1)), false)
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.potentialTargets = []
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setKnockbackReceived(50)
    eventPlayer.setHealingReceived(0)
    waitUntil(eventPlayer.isOnGround(), 1)
    bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
    waitUntil(eventPlayer.botTarget == null, 1)
    wait(0.25)
    waitUntil(eventPlayer.botTarget != null or eventPlayer.getHealth() < eventPlayer.health, 9999)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
    wait(1)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true


rule "BOSS STUCK":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.canWallPhase == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrouching() == false
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.getEyePosition()) < bosses[1] - 0.25
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.disableEnvironmentCollision(false)
    wait(3)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    if ruleCondition:
        loop()


rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 1000
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == true
    
    eventPlayer.bossHealth = eventPlayer.getHealth() + eventDamage - 1000
    eventPlayer.setHealth(eventPlayer.bossHealth)


rule "BOSS DIES (ALL BOSS OBJECTIVES)":
    @Event playerDied
    @Team 2
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer in bosses == true
    
    if eventWasEnvironment:
        eventPlayer.stopAllDamageOverTime()
        if attacker.getTeam() == getOppositeTeam(eventPlayer.getTeam()):
            eventPlayer.bossHealth = eventDamage - 200
        else:
            eventPlayer.bossHealth = eventDamage
        if eventPlayer.bossHealth > 0:
            while eventPlayer.isDead():
                if eventPlayer.getPosition().y - nearestWalkablePosition(eventPlayer.getPosition()).y < -50:
                    #Teleport boss if they fall very far below the map
                    bossReturn()
                else:
                    #17.532 is acceleration due to gravity constant
                    eventPlayer.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), getClosestPlayer(eventPlayer, Team.1).getPosition())), -75), max(1, sqrt(2 * 17.532 * (eventPlayer.lastTarget.getPosition().y + 3 - eventPlayer.getPosition().y))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                wait()
                eventPlayer.resurrect()
                waitUntil(eventPlayer.isAlive(), 0.25)
            eventPlayer.setHealth(eventPlayer.bossHealth)
            if eventPlayer.botTarget == null:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            #Illari punishes with ultimate
            if eventPlayer.getHero() == Hero.ILLARI and attacker.getTeam() == Team.1:
                illariUlt()
        else:
            objectiveComplete = true
            bosses[bosses.index(eventPlayer)] = 0
            eventPlayer.reviveTimer = 10
            goto lbl_0
    #Resurrects player if event damage was greater than 1000 and their health still is higher than 0hp.
    elif eventDamage - 1000 > 0:
        eventPlayer.bossHealth = eventDamage - 1000
        eventPlayer.resurrect()
        waitUntil(eventPlayer.isAlive(), 5)
        eventPlayer.setHealth(eventPlayer.bossHealth)
    else:
        objectiveComplete = true
        bosses[bosses.index(eventPlayer)] = 0
        eventPlayer.reviveTimer = 10
        (getPlayersOnHero(Hero.WINSTON, Team.2) if eventPlayer.getHero() == Hero.WINSTON else []).setStatusEffect(null, Status.KNOCKED_DOWN, 12)
        lbl_0:
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "BOSS TAKES KNOCKBACK":
    @Event playerReceivedKnockback
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition eventPlayer.wallCollisionEnabled == false
    @Condition eventPlayer in bosses == true
    
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true


rule "BOSS TELEPORT TO TARGET IF NOT USED":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) != true
    
    chaseAtRate(eventPlayer.mutationChase, 15, 1)
    waitUntil(eventPlayer.mutationChase >= 14 or eventPlayer.botTarget != null, 99999)
    if eventPlayer.mutationChase >= 14 and eventPlayer.botTarget == null:
        bossReturn()
    stopChasing(eventPlayer.mutationChase)
    eventPlayer.mutationChase = 0
    waitUntil(eventPlayer.botTarget == null, 99999)
    wait(0.16)
    loop()


def bossReturn():
    @Name "bossReturn"
    
    stopChasing(eventPlayer.mutationChase)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.mutationChase = eventPlayer.getEyePosition()
    eventPlayer.specialCooldown = eventPlayer.lastTarget if eventPlayer.lastTarget != null else getClosestPlayer(eventPlayer, Team.1)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer))
    wait(0.1)
    eventPlayer.teleport(Vector.UP + (random.choice(mapGrid.filter(lambda x: isInLoS(x, eventPlayer.averagePlayersPos.getEyePosition()) and distance(x, eventPlayer.specialCooldown.getPosition()) > 5 and distance(x, eventPlayer.specialCooldown) < 20))))
    wait()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLACK, eventPlayer, 3)
    eventPlayer.mutationChase = 0
    eventPlayer.specialCooldown = null


rule "== THANK YOU FLOURFLO AND HUNTYCRAFT <3 ===== OBJECTIVE TYPE: BIOMORPHING =======================================":
    @Disabled
    @Delimiter
    


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


rule "============================================== OBJECTIVE TYPE: SURVIVOR RESCUE =================================================":
    @Disabled
    @Delimiter
    


rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE":
    @Condition objectiveTypes[0] == 4
    @Condition gameStatus == true
    @Condition objectiveComplete == false
    @Condition (survivorToRescue == null or not entityExists(survivorToRescue)) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if survivorToRescue == null:
        testPos = null
        testPos2 = 115
        while testPos == null:
            testPos = random.choice(mapGrid.filter(lambda x: distance(x, objectivePositions[0]) > testPos2 and distance(x, objectivePositions[0]) < 120))
            testPos2 -= 5
            wait()
        createDummy(random.choice(getAllHeroes().filter(lambda x: getNumberOfHeroes(x, Team.1) <= 0)), Team.1, 20, testPos)
        survivorToRescue = getLastCreatedEntity()
    else:
        survivorToRescue = null
        objectiveComplete = true
    wait(1)
    if ruleCondition:
        loop()


rule "INITIALIZE SURVIVOR TO BE RESCUED":
    @Event eachPlayer
    @Team 1
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue == eventPlayer
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.detectionRadius1 = 5
    survivorToRescue.path = []
    survivorToRescue.startPos = survivorToRescue.getPosition()
    survivorToRescue.botTempValue = false
    eventPlayer.botFollowTarget = null
    eventPlayer.movementSpeed = 1
    eventPlayer.enhancementValues[0] = 9
    eventPlayer.enhancementValues[1] = 0
    eventPlayer.enhancementValues[2] = false
    survivorToRescue.setStatusEffect(null, Status.UNKILLABLE, 9999)
    survivorToRescue.setHealingReceived(110)
    #Objective/Survivor distance
    createInWorldText(getAllPlayers().filter(lambda _: not eventPlayer.botTempValue and distance(localPlayer.getPosition(), objectivePositions[0]) > 5), "Distance: {0}m".format(distance(localPlayer.getPosition(), eventPlayer.getPosition() if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > objectiveRad else objectivePositions[0])), eventPlayer.getPosition() if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > objectiveRad else objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.VIOLET, SpecVisibility.NEVER)
    #Survivor rescue progress bar
    progressBarHud(getAllPlayers(), 100 if eventPlayer.botTempValue else ((distance(vect(objectivePositions[0].x, eventPlayer.startPos.y, objectivePositions[0].z), eventPlayer.startPos) - distance(eventPlayer.getPosition(), vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z))) / distance(vect(objectivePositions[0].x, eventPlayer.startPos.y, objectivePositions[0].z), eventPlayer.startPos)) * 100, "Survivor Rescue Progress", HudPosition.TOP, 2, Color.VIOLET, Color.VIOLET, ProgressHudReeval.VISIBILITY_AND_VALUES)
    #Survivor icon
    createInWorldText(getAllPlayers(), eventPlayer.botTempvalue2 if eventPlayer.botTempvalue2 else eventPlayer.randVal, eventPlayer, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    eventPlayer.randVal = iconString(Icon.HALO)
    #Survivor activation ring
    createEffect(getAllPlayers(), Effect.RING, Color.VIOLET if eventPlayer.botFollowTarget != null else Color.RED, eventPlayer, objectiveRad)
    #Zombie slowing ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.getNormalizedHealth() < 1), Effect.BAD_AURA, Color.PURPLE, eventPlayer, 1)
    for eventPlayer.entityCount in range(10):
        #Path Markers
        createEffect(getAllPlayers().filter(lambda _: len(eventPlayer.path) > evalOnce(eventPlayer.entityCount * 3)), Effect.RING, Color.VIOLET, eventPlayer.path[evalOnce(eventPlayer.entityCount) * 3], 0.2)
    eventPlayer.startFacing(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botFollowTarget.getEyePosition())), 80 if eventPlayer.botFollowTarget == null else verticalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botFollowTarget.getEyePosition()))), 100)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), (eventPlayer.path.filter(lambda x: distance(eventPlayer.getPosition(), x) < 2)).last() if eventPlayer.path.any(lambda x: distance(eventPlayer.getPosition(), x) < 2) else eventPlayer.botFollowTarget.getPosition()), 0 if eventPlayer.botFollowTarget == null or distance(eventPlayer.getPosition(), eventPlayer.botFollowTarget.getPosition()) < 1.5 else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "SURVIVOR TO BE RESCUED DIES":
    @Event playerDied
    @Team 1
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue == eventPlayer
    
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.getPosition()))
    eventPlayer.resurrect()
    wait(0.25)
    if eventPlayer.isDead():
        loop()


rule "SURVIVOR FOLLOW TARGET":
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue.botTempValue == false
    @Condition survivorToRescue.hasSpawned() == true
    @Condition survivorToRescue.getHealth() > 1
    @Condition (playerTargetList.filter(lambda x: x != survivorToRescue and not x.invisible).any(lambda x: distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad)) == true
    @Condition distance(survivorToRescue.getPosition(), objectivePositions[0]) >= 5
    
    survivorToRescue.clearStatusEffect(Status.PHASED_OUT)
    survivorToRescue.randVal = iconString(Icon.SAD)
    survivorToRescue.botThrottleSpeed = survivorToRescue.getNormalizedHealth() * 0.7
    survivorToRescue.potentialTargets = playerTargetList.filter(lambda x: x != survivorToRescue and not x.invisible and distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad)
    if survivorToRescue.botFollowTarget == null or not survivorToRescue.botFollowTarget in survivorToRescue.potentialTargets:
        survivorToRescue.botFollowTarget = (sorted(playerTargetList.filter(lambda x: distance(survivorToRescue.getPosition(), x.getPosition()) < objectiveRad), lambda x: distance(x.getPosition(), objectivePositions[0])))[0]
    if not survivorToRescue in playerTargetList:
        #Add surivor to player target list
        playerTargetList.append(survivorToRescue)
        objectiveRad = 30
    wait(0.25)
    if ruleCondition:
        loop()
    #Remove survivor from player target list
    playerTargetList.remove(survivorToRescue)
    #Reset objective radius
    objectiveRad = objectiveChase1
    survivorToRescue.botFollowTarget = null
    survivorToRescue.potentialTargets = []
    if survivorToRescue.getHealth() <= 1:
        survivorToRescue.randVal = iconString(Icon.DIZZY)
        survivorToRescue.setStatusEffect(null, Status.KNOCKED_DOWN, 9999)
        survivorToRescue.setStatusEffect(null, Status.PHASED_OUT, 9999)
        waitUntil(survivorToRescue.getNormalizedHealth() > 0.75, 20)
        survivorToRescue.clearStatusEffect(Status.KNOCKED_DOWN)
        if ruleCondition:
            loop()


rule "CREATE PATH":
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue.botFollowTarget != null
    @Condition survivorToRescue.botThrottleSpeed > 0
    @Condition survivorToRescue.botFollowTarget.getAltitude() <= 1.5
    @Condition (len(survivorToRescue.path) == 0 or distance(survivorToRescue.botFollowTarget.getPosition(), survivorToRescue.path.last()) > 1) == true
    
    survivorToRescue.path.append(survivorToRescue.botFollowTarget.getPosition())
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "DELETE PATH":
    @Condition objectiveTypes[0] == 4
    @Condition (survivorToRescue.path.any(lambda x: distance(survivorToRescue.getPosition(), vect(x.x, survivorToRescue.getPosition().y, x.z)) < 0.25 and abs(survivorToRescue.getPosition().y - x.y) < 2)) == true
    
    survivorToRescue.telePos = survivorToRescue.path.index(sorted(survivorToRescue.path, lambda x: distance(survivorToRescue.getPosition(), x))[0])
    survivorToRescue.path.remove(survivorToRescue.path.filter(lambda _, i: i <= survivorToRescue.telePos))
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "SURVIVOR FOLLOW TARGET LETS GO":
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue.botFollowTarget != null
    @Condition survivorToRescue.botFollowTarget.isCommunicating(Comms.GOODBYE) == true
    
    survivorToRescue.botFollowTarget = null


rule "PLAYER SAYS GROUP UP TO SURVIVOR":
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue.botFollowTarget != null
    @Condition (survivorToRescue.potentialTargets.any(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), survivorToRescue.getPosition()) < 12)) == true
    
    survivorToRescue.botFollowTarget = (sorted(survivorToRescue.potentialTargets.filter(lambda x: x.isCommunicating(Comms.GROUP_UP) and distance(x.getPosition(), survivorToRescue.getPosition()) < 12), lambda x: distance(x.getPosition(), survivorToRescue.getPosition())))[0]
    survivorToRescue.botTempvalue2 = "{0} {1}".format(heroIcon(survivorToRescue.botFollowTarget.getHero()), iconString(Icon.QUESTION_MARK))
    survivorToRescue.path = []
    wait(3)
    survivorToRescue.botTempvalue2 = null


rule "SURVIVOR JUMP":
    @Condition objectiveTypes[0] == 4
    @Condition survivorToRescue.isOnGround() == true
    @Condition survivorToRescue.getThrottle() != vect(0, 0, 0)
    @Condition survivorToRescue.getHorizontalSpeed() < survivorToRescue.botThrottleSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    survivorToRescue.forceButtonPress(Button.JUMP)
    loop()


rule "SURVIVOR REACHES EXTRACTION SITE":
    @Condition objectiveTypes[0] == 4
    @Condition objectiveComplete == false
    @Condition survivorToRescue.hasSpawned() == true
    @Condition distance(survivorToRescue.getPosition(), objectivePositions[0]) < 5
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, survivorToRescue, 200)
    survivorToRescue.randVal = random.choice([iconString(Icon.HAPPY), iconString(Icon.HEART)])
    survivorToRescue.startThrottleInDirection(directionTowards(survivorToRescue.getPosition(), objectivePositions[0]), 0.75 if distance(survivorToRescue.getPosition(), objectivePositions[0]) > 1 else 0, Relativity.TO_WORLD)
    survivorToRescue.startFacing(vect(0, 1, 0), 100)
    wait(1)
    survivorToRescue.botTempValue = true
    survivorToRescue.path = []
    survivorToRescue.chase1 = survivorToRescue.getPosition()
    wait()
    survivorToRescue.startForcingPosition(survivorToRescue.chase1)
    wait(0.5)
    chaseAtRate(survivorToRescue.chase1, survivorToRescue.getPosition() + vect(0, 100, 0), 3, ChaseRateReeval.NONE)
    wait(2)
    chaseAtRate(survivorToRescue.chase1, survivorToRescue.getPosition() + vect(0, 100, 0), 10, ChaseRateReeval.NONE)
    wait(3)
    destroyDummy(Team.1, survivorToRescue.getSlot())


rule "============================================== OBJECTIVE TYPE: KILL ZONE ===================================================":
    @Disabled
    @Delimiter
    


rule "MODIFY KILL ZONE SCORE":
    @Event playerDealtFinalBlow
    @Condition objectiveTypes[0] == 5
    @Condition playerTargetList.concat(victim).any(lambda x: distance(x.getPosition(), objectiveChase1) < objectiveRad) == true
    
    if distance(eventPlayer.getPosition(), objectiveChase1) < objectiveRad or distance(victim.getPosition(), objectiveChase1) < objectiveRad:
        victim.reviveTimer = 2
        objectiveCaptureValue += ceil(victim.health / 280)
        if objectiveCaptureValue >= eliminationsNeededPerObjective:
            objectiveComplete = true
            #Give all bots a long respawn time
            getPlayers(Team.2).reviveTimer = 12
            spawnTimes = spawnTimes.map(lambda _: 12)
    #Adjust Kill Zone Positions
    objectiveChase1 += 0.5 * directionTowards(objectiveChase1, victim.getPosition())


rule "============================================== OBJECTIVE TYPE: ZOMBIE EGG ===================================================":
    @Disabled
    @Delimiter
    


rule "ASSIGN ZOMBIE TO BECOME EGG":
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete == false
    @Condition entityExists(bosses[0]) == false
    @Condition (getLivingPlayers(Team.2).any(lambda player: not player.teleporting and player.botTarget == null)) == true
    @Condition len(botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)) < uniqueSkinCap - max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bosses[0] = random.choice(getLivingPlayers(Team.2).filter(lambda player: not player.teleporting and not player.attached and player.botTarget == null))
    if ruleCondition:
        loop()


rule "BOT BECOMES ZOMBIE EGG":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete == false
    @Condition bosses[0] == eventPlayer
    
    eventPlayer.teleport(vect(500, 500, 500))
    while eventPlayer.isDead():
        eventPlayer.resurrect()
        waitUntil(eventPlayer.isAlive(), 1)
    bosses[0].startForcingHero(Hero.WRECKING_BALL)
    botRespawnInitialization()
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.startForcingName("Egg")
    eventPlayer.specialThrottling = true
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startForcingPosition(objectivePositions[0] + vect(0, -2.5, 0))
    eventPlayer.startModifyingVoicelinePitch(0.5, false)
    eventPlayer.health = 15000
    eventPlayer.bossHealth = eventPlayer.health
    eventPlayer.size = 2.5
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    waitUntil(eventPlayer.wallCollisionEnabled == true, 5)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.setHealingReceived(0)
    while not objectiveComplete:
        bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
        if not eventPlayer.isUsingAbility1() and eventPlayer.isAlive():
            eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.25)
        waitUntil(objectiveComplete or not eventPlayer.isUsingAbility1(), 99999)


rule "BOTS TELEPORT TO THE EGG":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete != true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.successfullyTeleported != true
    @Condition eventPlayer.isAlive() == true
    @Condition entityExists(bosses[0]) == true
    @Condition eventPlayer in bosses != true
    @Condition playerTargetList.any(lambda x: distance(objectivePositions[0], x.getPosition()) < 40) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.successfullyTeleported = true
    eventPlayer.customTelePos = vect(500, 500, 500)
    eventPlayer.telePos = objectivePositions[0]
    eventPlayer.averagePlayersPos = eventPlayer.telePos
    eventPlayer.reviveTimer = 1
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], 7)
    eventPlayer.teleport(eventPlayer.telePos)


rule "EGG SWITCHES THE POSITION FOR YOU":
    @Event playerDealtDamage
    @Team 1
    @Condition objectiveTypes[0] == 6
    @Condition bosses[0] == victim
    
    objectivePositions[0] += directionTowards(victim, attacker) / (3.5 if attacker.isOnGround() else 9)
    #Small stop for high ticks of damage
    wait(0.049)


rule "============================================== OBJECTIVE TYPE: SATELLITE UPLINK ==============================================":
    @Disabled
    @Delimiter
    


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
        fireSatellite()
        objectiveComplete = true
    wait(0.5)
    if ruleCondition:
        loop()


def fireSatellite():
    @Name "fireSatellite"
    
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


rule "============================================== PLAYERS GAME IN PROGRESS ====================================================":
    @Disabled
    @Delimiter
    


rule "PLAYER INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.invisible = false
    eventPlayer.movementSpeed = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    eventPlayer.attached = false
    eventPlayer.afk = false
    if eventPlayer.switchedHeroes == true:
        return
    eventPlayer.disableMessages()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    startRule(setDifficulty)
    eventPlayer.reviving = false
    eventPlayer.disableRespawn()
    wait()
    eventPlayer.infected = false
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.reviveStartTime = 5
    eventPlayer.reviveTimer = eventPlayer.reviveStartTime
    eventPlayer.deathTimer = mustReviveTime
    eventPlayer.infectionLvl = 0
    enableDisableAbilities()
    eventPlayer.size = 1
    if eventPlayer.playerMenuStatus[0] == 0:
        if not "{0}".format(eventPlayer) in users:
            updateUsers()
            teleportToClosestPlayer()
            eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 10)
            eventPlayer.playerActiveStatus = true
        else:
            #Index of user in user array
            eventPlayer.userIndex = users.index("{0}".format(eventPlayer))
            eventPlayer.deathTimer = globalPlayerStats[eventPlayer.userIndex][1]
            eventPlayer.reviveTimer = globalPlayerStats[eventPlayer.userIndex][2]
            eventPlayer.reviveStartTime = globalPlayerStats[eventPlayer.userIndex][3]
            if globalPlayerStats[eventPlayer.userIndex][0] == 0:
                teleportToClosestPlayer()
                eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 10)
                eventPlayer.playerActiveStatus = true
            elif globalPlayerStats[eventPlayer.userIndex][0] >= 1:
                eventPlayer.teleport(globalPlayerStats[eventPlayer.userIndex][4])
                while eventPlayer.isAlive():
                    kill(eventPlayer)
                    wait(0.5)
                eventPlayer.playerActiveStatus = true
                if globalPlayerStats[eventPlayer.userIndex][0] == 2:
                    eventPlayer.deathTimer = 0.5
    else:
        waitUntil(len(objectivePositions) >= 1, 5)
        if specialGameMode:
            wait()
            eventPlayer.teleport(random.choice(mapGrid.filter(lambda x: distance(x, walkCenter) < 15)))
            wait()
        eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), objectivePositions[0]), Relativity.TO_WORLD)
        eventPlayer.playerActiveStatus = true
        eventPlayer.cancelPrimaryAction()
        eventPlayer.clearStatusEffect(Status.INVINCIBLE)
        updateUsers()
    eventPlayer.stopCamera()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setInvisibility(Invis.NONE)


rule "EFFECTS/TEXTS":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.switchedHeroes == false
    
    wait(0.25)
    #Infected aura
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.infected), Effect.BAD_AURA, Color.BLACK if eventPlayer.enhancementValues[0] == 2 else Color.LIME_GREEN, eventPlayer, 0.1 if localPlayer == eventPlayer else 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Need revive text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.isDead() and eventPlayer.deathTimer > 0), "Reviving: {0}s".format(ceil(eventPlayer.reviveTimer)) if eventPlayer.reviving else "Revive: {0}s".format(ceil(eventPlayer.deathTimer)), eventPlayer.getPosition() + vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.YELLOW if eventPlayer.reviving else Color.RED)
    #Reviving ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.reviving), Effect.RING, Color.YELLOW, eventPlayer.getPosition(), reviveRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Health Hud text
    hudText(getAllPlayers().filter(lambda _: eventPlayer.deathTimer > 0 and not eventPlayer.afk), "{0}{1}: {2}".format("Winston" if gameSmolderEvent else eventPlayer, heroIcon(Hero.WINSTON) if gameSmolderEvent else heroIcon(eventPlayer.getHero()), "{0}%".format(ceil(eventPlayer.getNormalizedHealth() * 100)) if eventPlayer.isAlive() else "DOWN"), "Revive: {0}s".format(ceil(eventPlayer.deathTimer)) if eventPlayer.isDead() and not eventPlayer.reviving else [], ("{1}Infection Level: {0}".format(floor(eventPlayer.infectionLvl), iconString(Icon.POISON) if eventPlayer.enhancementValues[0] == 2 else [])) if eventPlayer.infectionLvl >= 1 else "Vaccine Level: {0}".format(abs(floor(eventPlayer.infectionLvl))) if eventPlayer.infectionLvl < 0 else "Reviving: {0}s".format(ceil(eventPlayer.reviveTimer)) if eventPlayer.reviving else [], HudPosition.LEFT, 0 if eventPlayer.getNormalizedHealth() > 0.97 else 1 / (eventPlayer.getNormalizedHealth() + 1), Color.BLUE if eventPlayer.getNormalizedHealth() > 0.97 else Color.GREEN if eventPlayer.getNormalizedHealth() > 0.66 else Color.YELLOW if eventPlayer.getNormalizedHealth() > 0.33 else Color.ORANGE if eventPlayer.getNormalizedHealth() > 0 else Color.RED, Color.RED, Color.LIME_GREEN if eventPlayer.infectionLvl >= 1 else Color.BLUE if eventPlayer.infectionLvl < 0 else Color.YELLOW)


rule "PLAYER GETS DOWNED":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.isDummy() == false
    
    wait(0.16)
    eventPlayer.reviveTimer = eventPlayer.reviveStartTime / (2 if challengeSetting == 2 else 1)
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.infectionLvl = 0
    eventPlayer.infected = false
    (getPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer)).botTarget = null
    (getAllPlayers().filter(lambda player: eventPlayer in player.potentialTargets)).potentialTargets.remove(eventPlayer)
    if eventWasEnvironment:
        if attacker.getHero() == Hero.REINHARDT and eventAbility == Button.ABILITY_1:
            teleportToClosestPlayer()
        else:
            eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))


rule "REVIVE PLAYER OR ADVANCE DEATH TIMER":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDead() == true
    @Condition gameStatus == true
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.deathTimer > 0
    @Condition eventPlayer.isDummy() == false
    
    #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
    globalPlayerStats[eventPlayer.userIndex] = [1, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]
    waitUntil(not eventPlayer.reviving and playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisible).any(lambda x: distance(x.getPosition(), eventPlayer.getPosition()) < reviveRadius), 0.5)
    if playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisible).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < reviveRadius):
        eventPlayer.reviving = true
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), reviveRadius * 2)
        eventPlayer.reviveTimer += -0.5
        if eventPlayer.deathTimer < 70:
            eventPlayer.deathTimer += 0.5
    else:
        eventPlayer.reviving = false
        #If dome will pass player before their death timer runs out, set the death timer to how long it will take for the dome to reach them
        if len(objectivePositions) == 1 and extractionZoneRad - distance(eventPlayer.getPosition(), objectivePositions[0]) < eventPlayer.deathTimer:
            eventPlayer.deathTimer = (extractionZoneRad - distance(eventPlayer.getPosition(), objectivePositions[0])) / 2.5
        else:
            eventPlayer.deathTimer += -0.5
        #Player is dead outside of extraction zone
        if len(objectivePositions) == 1 and distance(objectivePositions[0], eventPlayer.getPosition()) > extractionZoneRad:
            eventPlayer.deathTimer = 0
        #Player's body falls off of map
        if eventPlayer.getPosition().y - nearestWalkablePosition(eventPlayer.getPosition()).y < -0.1:
            eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))
    if eventPlayer.reviveTimer <= 0:
        eventPlayer.reviveStartTime++
        eventPlayer.reviveTimer = eventPlayer.reviveStartTime
        eventPlayer.resurrect()
        eventPlayer.reviving = false
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 5)
        waitUntil(eventPlayer.isAlive(), 2)
    elif eventPlayer.deathTimer <= 0:
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [2, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, vect(0, -100, 0)]
        bigMessage(getAllPlayers().exclude(eventPlayer), "{0} {1} died!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        if mustReviveTime == 60 and len(objectivePositions) != 1:
            bigMessage(getAllPlayers().exclude(eventPlayer), "Save {0} by finishing the objective!".format(eventPlayer))
        mustReviveTime -= 0 if mustReviveTime <= 30 else 10
        eventPlayer.teleport(vect(0, -100, 0))
        eventPlayer.setInvisibility(Invis.ALL)
        waitUntil(objectiveComplete, 99999)
        eventPlayer.resurrect()
        teleportToClosestPlayer()
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.setInvisibility(Invis.NONE)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
    if ruleCondition:
        loop()
    eventPlayer.reviving = false
    if eventPlayer.isAlive():
        eventPlayer.deathTimer = mustReviveTime
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [0, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]


rule "PLAYER PICKS UP HEALTH PACK":
    @Event playerReceivedHealing
    @Team 1
    @Condition eventWasHealthPack == true
    
    eventPlayer.startHealingOverTime(null, 5, 20)
    if difficultySetting < 3 or getMatchTime() > matchEndTime:
        #Update known health pack positions
        if healthpackPositions.all(lambda x: distance(x, eventPlayer.getPosition()) > 5):
            healthpackPositions.append(eventPlayer.getPosition())
        eventPlayer.stopAllDamageOverTime()
        eventPlayer.clearStatusEffect(Status.BURNING)
        if eventPlayer.infectionLvl > 0:
            eventPlayer.infected = false
            eventPlayer.infectionLvl = 0
    elif eventPlayer.infected:
        smallMessage(eventPlayer, "Match time has reached 0. Health packs no longer cure infection.")


rule "PLAYER CLEARS DAMAGE OVER TIME":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition (eventPlayer.hasStatus(Status.PHASED_OUT) or eventPlayer.hasStatus(Status.INVINCIBLE)) == true
    
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.clearStatusEffect(Status.BURNING)
    wait(0.25)
    if ruleCondition:
        loop()


rule "PLAYER INFECTION DAMAGE MANAGEMENT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.infected == true
    
    if eventPlayer.infectionLvl < 1:
        eventPlayer.infected = false
    eventPlayer.startDamageOverTime(null, 1, (floor(eventPlayer.infectionLvl) if eventPlayer.enhancementValues[0] != 2 else eventPlayer.infectionLvl / 2) ** 2)
    if eventPlayer.enhancementValues[0] == 2:
        eventPlayer.infectionDamage = getLastDamageOverTimeId()
    wait(1)
    if ruleCondition:
        loop()


rule "PLAYER AFK":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup != true
    @Condition createWorkshopSettingBool("General", "Allow players to go AFK", true, 3) == true
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition eventPlayer in playersOnObjective != true
    @Condition eventPlayer.isCommunicatingVoiceline() == false
    
    if not eventPlayer.afk:
        wait(45, Wait.ABORT_WHEN_FALSE)
        smallMessage(getAllPlayers().filter(lambda _: eventPlayer.isAlive()), "{0} {1} is afk".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.afk = true
        eventPlayer.setInvisibility(Invis.ALL)
        playerTargetList.remove(eventPlayer)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    else:
        wait(1)
    if ruleCondition:
        loop()
    if eventPlayer.afk:
        eventPlayer.afk = false
        eventPlayer.setInvisibility(Invis.NONE)
        smallMessage(getAllPlayers(), "{0} {1} is back!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)


rule "PLAYER SWITCHES HERO":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.detach()
    waitUntil(not eventPlayer.hasSpawned(), 1)
    wait()
    eventPlayer.setAllowedHeroes(getAllHeroes())
    eventPlayer.switchedHeroes = true


rule "PLAYER AUTOMATIC RELOAD":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() == 0
    @Condition eventPlayer.getMaxAmmo() != 0
    @Condition eventPlayer.getHero() != Hero.ILLARI
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    smallMessage(eventPlayer, "Weapon reloaded")


rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE":
    @Event eachPlayer
    @Condition gameStatus == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.objectiveValue != objectiveValue or len(objectivePositions) == 1) == true
    
    playerObjectiveEntityManagement()


rule "PLAYER TARGET (ADD)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.afk != true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in playerTargetList == false
    @Condition eventPlayer.isDummy() == false
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    playerTargetList.append(eventPlayer)
    if ruleCondition:
        loop()


rule "PLAYER TARGET (REMOVE)":
    @Event eachPlayer
    @Team 1
    @Condition (eventPlayer.isDead() or not eventPlayer.hasSpawned()) == true
    @Condition eventPlayer in playerTargetList == true
    @Condition eventPlayer.isDummy() == false
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    playerTargetList.remove(eventPlayer)
    if ruleCondition:
        loop()


def playerObjectiveEntityManagement():
    @Name "playerObjectiveEntityMangement"
    
    if eventPlayer.objectiveValue != objectiveValue or len(objectivePositions) == 1:
        eventPlayer.objectiveValue = objectiveTypes[0]
        if eventPlayer.getTeam() == Team.1:
            #Destroy all current objective effects and texts
            for eventPlayer.entityCount in range(len(eventPlayer.generalPlayerBotEntities)):
                destroyIcon(eventPlayer.generalPlayerBotEntities[eventPlayer.entityCount])
                wait()
            eventPlayer.generalPlayerBotEntities = []
        else:
            #Destroy all current objective effects and texts
            for eventPlayer.entityCount in range(len(eventPlayer.botResourceEntity)):
                destroyIcon(eventPlayer.botResourceEntity[eventPlayer.entityCount])
                wait()
            eventPlayer.botResourceEntity = []
        if eventPlayer.objectiveValue == 3:
            #Player carrying resources icon
            createIcon(getAllPlayers().filter(lambda player: eventPlayer.isAlive() and player != eventPlayer and eventPlayer.playerObjectiveResourceValue > 0), eventPlayer, Icon.RECYCLE, IconReeval.VISIBILITY_POSITION_AND_COLOR, biowasteColorLookUp[eventPlayer.biowasteType] if eventPlayer.getTeam() == Team.1 else Color.WHITE)
            if eventPlayer.getTeam() == Team.1:
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            else:
                eventPlayer.botResourceEntity.append(getLastCreatedEntity())


def teleportToClosestPlayer():
    @Name "teleportToClosestPlayer"
    
    eventPlayer.teleport(nearestWalkablePosition(sorted(playerTargetList.exclude(eventPlayer), lambda x: distance(x.getPosition(), objectivePositions[0]))[0].getPosition()))


def updateUsers():
    @Name "updateUsers"
    
    if not "{0}".format(eventPlayer) in users:
        #Add event player to users list
        users.append("{0}".format(eventPlayer))
        #Index of user in user array
        eventPlayer.userIndex = users.index("{0}".format(eventPlayer))
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [0, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]


rule "============================================== HERO TUNING ====================================================":
    @Disabled
    @Delimiter
    


rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.specialCooldown == true
    
    wait(8)
    eventPlayer.stopFacing()
    eventPlayer.specialCooldown = false
    if ruleCondition:
        loop()


rule "SOMBRA USES TRANSLOCATOR":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.invisible++
    waitUntil(eventPlayer.isUsingUltimate() or [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.MELEE].any(lambda x: eventPlayer.isHoldingButton(x) and eventPlayer.getAbilityCooldown(x) == 0), 6.5)
    eventPlayer.invisible--


rule "DOOMFIST INVIS WHILE ULTING":
    @Event eachPlayer
    @Team 1
    @Hero doomfist
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.invisible--


rule "MOIRA & VENTURE INVIS WHILE USING SKILL":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getHero() in [Hero.MOIRA, Hero.VENTURE] == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.invisible--


rule "TRACER INVIS WHILE RECALLING":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.invisible--


rule "CASSIDY GRENADE HACK":
    @Event playerDealtDamage
    @Team 1
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.hasStatus(Status.HACKED) == false
    @Condition victim != attacker
    
    victim.setStatusEffect(attacker, Status.HACKED, 1)


rule "============================================== BOTS GAME IN PROGRESS ====================================================":
    @Disabled
    @Delimiter
    


rule "BOT INITIALIZATION":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition specialGameModeSetup != true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(null, 9999, 9999)
    eventPlayer.reviveTimer = 0
    if len(customTelePositions) > 0:
        eventPlayer.customTelePos = customTelePositions[0]
        del customTelePositions[0]
    else:
        eventPlayer.customTelePos = null
    eventPlayer.canTeleport = false
    #Damage over time duration
    chaseAtRate(eventPlayer.damageOverTimeDuration, -1, 0.95, ChaseRateReeval.NONE)
    #Bot target warning icon (flashing)
    createIcon(getAllPlayers() if eventPlayer in queuedGoalType else eventPlayer.botTarget.filter(lambda x: eventPlayer.isAlive() and not x.isInViewAngle(eventPlayer.getPosition(), 55)), eventPlayer, Icon.WARNING, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.RED if (((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > 10 else 8))) % 2) == 0) else Color.YELLOW)
    waitUntil(eventPlayer.hasSpawned(), 2)
    eventPlayer.setMaxHealth(30 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.HAZARD, Hero.ILLARI] else 1)
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.health - eventPlayer.initialMaxHealth), true)
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.health - 10000), true)
    eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)
    eventPlayer.setRespawnTime(30)
    if not eventPlayer in bosses:
        botRespawnInitialization()
    eventPlayer.canTeleport = true


rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING":
    @Event eachPlayer
    @Team 2
    @Condition gameStatus == true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == false
    @Condition (eventPlayer.getThrottle() == vect(0, 0, 0) or eventPlayer.getHorizontalSpeed() < 1 * eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed) == true
    @Condition playerTargetList.all(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) > 2.1 * eventPlayer.size) == true
    
    if eventPlayer.botTarget != null:
        wait(random.uniform(7.5, 12.5), Wait.ABORT_WHEN_FALSE)
    else:
        wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(vect(0, -500, 0))
    if ruleCondition:
        loop()


rule "BOT DIES":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer in bosses == false
    
    if eventPlayer.botTempValue and eventPlayer.getHero() == Hero.ANRAN and not eventWasEnvironment:
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        eventPlayer.botTempValue = 0
        wait(random.randint(1, 4))
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        return
    if eventPlayer in queuedGoalType:
        eventPlayer.randVal = random.randint(150, eventPlayer.health)
        if eventPlayer.randVal > 175 or difficultySetting <= 3:
            objectiveCaptureValue += 10 if eventPlayer.health > 500 else eventPlayer.health * (0.04 if difficultySetting <= 2 else 0.035)
            smallMessage(getAllPlayers(), " {0}  Kill Bonus".format(iconString(Icon.PLUS)))
            #Miniboss kill bonus
            if eventPlayer in miniBoss:
                objectiveCaptureValue += 10
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, objectivePositions[0], 100)
    wait(3 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.ANA] else 0)
    eventPlayer.botTarget = null
    eventPlayer.potentialTargets = []
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    if not eventWasEnvironment or attacker.getTeam() == Team.1:
        #Remove miniboss from zombie
        miniBoss[miniBoss.index(eventPlayer)] = 0
        eventPlayer.disableNameplatesFor(getAllPlayers())
        #Allow for custom revive times
        waitUntil(eventPlayer.reviveTimer > 0, 0.125)
        if eventPlayer.reviveTimer <= 0:
            eventPlayer.reviveTimer = 1 + ((getMatchTime() + matchEndTime) / 60)
        if len(spawnTimes) < numberOfBots:
            spawnTimes.append(eventPlayer.reviveTimer)
        if eventPlayer.customTelePos:
            customTelePositions.append(eventPlayer.customTelePos)
        wait(1)
        waitUntil(eventPlayer.damageOverTimeDuration <= 0, 10)
        updateBotSpawnPoints()
        destroyDummy(Team.2, eventPlayer.getSlot())
        return
    elif eventWasEnvironment and distance(eventPlayer.getPosition(), vect(eventPlayer.telePos.x, eventPlayer.getPosition().y, eventPlayer.telePos.z)) < 10:
        eventPlayer.successfullyTeleported = false
    eventPlayer.teleporting = true
    eventPlayer.teleport(vect(500, 50, 500))
    wait(0.25)
    eventPlayer.resurrect()


rule "TELEPORT BOTS (GENERAL)":
    @Event eachPlayer
    @Team 2
    @Condition gameStatus == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == false
    @Condition getNumberOfLivingPlayers(Team.1) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    teleportBots()


rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.teleporting != true
    @Condition gameStatus == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.targeting != true
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == false
    @Condition (playerTargetList.filter(lambda x: x.invisible).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + vect(0, losHeightCheck, 0)))) == true
    
    if eventPlayer.successfullyTeleported:
        wait(5, Wait.ABORT_WHEN_FALSE)
    else:
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        wait(max(1, 10 - distance(eventPlayer.getPosition(), eventPlayer.averagePlayersPos) / 8), Wait.ABORT_WHEN_FALSE)
        if eventPlayer.successfullyTeleported:
            loop()
    teleportBots()
    loop()


rule "BOT STUN MANAGEMENT":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.STUNNED)) == true
    
    eventPlayer.crowdControlled = true
    wait(0.125)
    if ruleCondition:
        loop()
    eventPlayer.crowdControlled = false


rule "UPDATE SUCCESSFUL TELEPORT STATUS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.successfullyTeleported != true
    @Condition specialGameModeSetup != true
    @Condition eventPlayer in bosses == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if not eventPlayer.successfullyTeleported:
        eventPlayer.successfullyTeleported = true
    if distance(eventPlayer.telePos, eventPlayer.averagePlayersPos) < botMaxTeleportRange[1]:
        eventPlayer.waypoint = eventPlayer.getPosition()
        updateBotSpawnPoints()


rule "BOT TARGET VISIBLE":
    @Event eachPlayer
    @Team 2
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.botTarget == null or playerTargetList.exclude(eventPlayer.botTarget).any(lambda x: not x.invisible and distance(x.getPosition(), eventPlayer.getPosition()) < 7.5)) == true
    @Condition (playerTargetList.any(lambda x: not x.invisible and distance(eventPlayer.getPosition(), x.getPosition()) < 150 and isInLoS(x.getEyePosition(), eventPlayer.getPosition() + vect(0, losHeightCheck, 0)))) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startRule(selectTarget)
    wait(1)
    if ruleCondition:
        loop()


rule "BOT TAKES DAMAGE AND SWITCHES TARGETS":
    @Event playerTookDamage
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition (attacker != eventPlayer.botTarget or eventPlayer in miniBoss) == true
    @Condition eventPlayer.isAlive() == true
    @Condition attacker.getTeam() != victim.getTeam()
    
    startRule(selectTarget, StartRuleBehavior.NOOP)
    wait(2)


def selectTarget():
    @Name "selectTarget"
    
    eventPlayer.targeting = true
    #Set potential targets empty
    eventPlayer.potentialTargets = []
    #Miniboss prioritizes players on objective
    if eventPlayer in miniBoss:
        eventPlayer.potentialTargets.append(playersOnObjective.filter(lambda x: not x.isDummy()))
    #Prioitize dummy bots
    eventPlayer.potentialTargets.append(playerTargetList.filter(lambda x: x.isDummy()))
    #For projectile firing heroes
    if not eventPlayer in bosses and eventPlayer.getHero() == Hero.PHARAH:
        #Players in Air
        eventPlayer.potentialTargets.append(playerTargetList.filter(lambda x: distance(x.getPosition(), nearestWalkablePosition(x.getPosition())) > 5))
    #Add players who are below bot to target list
    eventPlayer.potentialTargets.append(sorted(playerTargetList.exclude(eventPlayer.potentialTargets).filter(lambda x: x.getPosition().y - eventPlayer.getPosition().y < 2.5), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Add remaining players
    eventPlayer.potentialTargets.append(sorted(playerTargetList.exclude(eventPlayer.potentialTargets), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Remove invisible players
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: not x.invisible)
    for eventPlayer.pPowerUpCount_bTeleCount in range(len(eventPlayer.potentialTargets)):
        eventPlayer.testTarget = eventPlayer.potentialTargets[eventPlayer.pPowerUpCount_bTeleCount]
        if isInLoS(eventPlayer.testTarget.getEyePosition(), eventPlayer.getPosition() + vect(0, losHeightCheck, 0)):
            break
        #wait()
    if eventPlayer.isAlive():
        eventPlayer.botTarget = eventPlayer.testTarget
        eventPlayer.lastTarget = eventPlayer.botTarget
        startRule(restoreDefaultFacingMovement)
    eventPlayer.targeting = false


def restoreDefaultFacingMovement():
    @Name "restoreDefaultFacingMovement"
    
    if eventPlayer.botTarget != null:
        if not eventPlayer.specialFacing:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled else 100)
        if not eventPlayer.specialThrottling:
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed if distance(eventPlayer.getPosition(), vect(eventPlayer.botTarget.getPosition().x, eventPlayer.getPosition().y, eventPlayer.botTarget.getPosition().z)) > 2 * min(1, eventPlayer.size) else 0, Relativity.TO_WORLD)
    else:
        eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)


rule "DESELECT BOT TARGET":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.botTarget.invisible or not eventPlayer.botTarget in playerTargetList or not isInLoS(eventPlayer.botTarget.getEyePosition(), eventPlayer.getPosition() + vect(0, losHeightCheck, 0))) == true
    
    eventPlayer.botTarget = null
    if not eventPlayer.specialThrottling:
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition() + normalize(worldVector(eventPlayer.lastTarget.getThrottle(), eventPlayer.lastTarget, Transform.ROTATION)) * -2), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    if not eventPlayer.specialFacing:
        eventPlayer.startFacing(eventPlayer.getThrottle(), 0 if eventPlayer.crowdControlled else 100, Relativity.TO_PLAYER)
    wait(0.125, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "BOT WANDERS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.specialFacing != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3.5
    @Condition specialGameModeSetup != true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) + random.uniform(90, 270), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    wait(1)
    if ruleCondition:
        loop()


rule "BOTS JUMP":
    @Event eachPlayer
    @Team 2
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.specialThrottling == false
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isJumping() != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.isCrouching() == false
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 2) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "BOTS MOVE THROUGH SPAWN DOORS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.canWallPhase == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition (eventPlayer.isOnGround() or eventPlayer in bosses and eventPlayer.getAltitude() < 10) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3
    #Makes sure bot is moving forward
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) >= 0
    @Condition isInLoS(eventPlayer.getPosition() + vect(0, 0.75, 0) * eventPlayer.size, eventPlayer.getPosition() + vect(0, 0.75, 0) * eventPlayer.size + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3 * eventPlayer.size) == true
    
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.wallCollisionEnabled = false
    if eventPlayer in bosses:
        wait(2, Wait.RESTART_WHEN_TRUE)
    else:
        wait(1)
    if ruleCondition:
        loop()
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    if not eventPlayer in bosses:
        wait(5)


rule "BOTS MELEE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isMeleeing() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 3 * eventPlayer.size
    @Condition eventPlayer.botTarget.getHorizontalSpeed() < 15 * eventPlayer.botTarget.movementSpeed
    
    if eventPlayer.getHero() == Hero.HAZARD and not eventPlayer.botTempValue and not eventPlayer.abilityArray1 and eventPlayer in bosses:
        eventPlayer.botTempvalue2 = true
        eventPlayer.specialFacing = true
        eventPlayer.chase1 = -20
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + vect(eventPlayer.chase1, 0, 0)), 9999 if eventPlayer.chase1 == -20 else 100)
        chaseOverTime(eventPlayer.chase1, 25, 3)
        for eventPlayer.pBouncePadCount1 in range(5):
            eventPlayer.setUltCharge(100)
            wait()
            eventPlayer.clearStatusEffect(Status.HACKED)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.8)
            if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
            waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.specialFacing = false
        restoreDefaultFacingMovement()
        stopChasing(eventPlayer.chase1)
        eventPlayer.abilityArray1 += 10
        eventPlayer.botTempvalue2 = false
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.MELEE)
    if ruleCondition:
        loop()


rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)":
    @Event playerDealtDamage
    @Team 2
    @Condition eventAbility == Button.MELEE
    @Condition victim.getTeam() == Team.1
    
    victim.startDamageOverTime(eventPlayer, eventPlayer.biteDuration, eventPlayer.biteDamage)
    if eventPlayer.damageOverTimeDuration < eventPlayer.biteDuration:
        eventPlayer.damageOverTimeDuration = eventPlayer.biteDuration
    if createWorkshopSettingBool("Infection", "Melee Infection Enabled", true) and not eventPlayer.hasStatus(Status.HACKED) and not victim.isDummy() and (victim.getHealth() <= (victim.getMaxHealth() if victim.enhancementValues[13] != null else victim.initialMaxHealth)):
        victim.infectionLvl += (2 if eventPlayer in bosses or eventPlayer in miniBoss or eventPlayer.mutationValue == 4 else 1) / ((3 if not victim.infected and victim.getHero() in [Hero.REINHARDT, Hero.HAZARD, Hero.VENDETTA, Hero.DMON] else 2) if victim.enhancementValues[0] != 2 else 1)
        if not victim.infected and victim.infectionLvl >= 1:
            victim.infected = true


rule "BOTS RECOIL FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 20
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.attached != true
    @Condition attacker.getTeam() == Team.1
    @Condition victim.isAlive() == true
    @Condition eventDamage > 0.3 * eventPlayer.health
    
    if victim.isInAir() and eventWasCriticalHit:
        victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 3)
    else:
        victim.setStatusEffect(attacker, Status.STUNNED, 0.5)
    victim.applyImpulse(directionFromAngles(random.uniform(-20, 20) + horizontalAngleOfDirection(eventDirection), 0), eventDamage * 15 / victim.health * eventPlayer.knockbackRecieved, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


def enterExitTeleport():
    @Name "enterExitTeleport"
    
    if eventPlayer.teleporting:
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.setGravity(0)
    else:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.25)
        eventPlayer.setInvisibility(Invis.NONE)
        eventPlayer.setGravity(100)
        if eventPlayer.botTarget == null:
            if eventPlayer.telePos in botSpawnPoints:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), waypoints[botSpawnPoints.index(eventPlayer.telePos)]), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            else:
                eventPlayer.startThrottleInDirection(directionFromAngles(random.randint(-90, 90) + horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer.getPosition(), x.getPosition()))[0].getPosition())), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        elif eventPlayer.botTarget != null:
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


def teleportBots():
    @Name "teleportBots"
    
    if eventPlayer.getHero() == Hero.ANRAN and eventPlayer.isUsingUltimate():
        return
    eventPlayer.teleporting = true
    updateBotSpawnPoints()
    enterExitTeleport()
    eventPlayer.successfullyTeleported = false
    waitUntil(not eventPlayer.initializing and eventPlayer.canTeleport, 99999)
    if eventPlayer.customTelePos == null:
        while eventPlayer.teleporting:
            botTeleportCenter()
            wait()
            eventPlayer.telePos = 0
            #Teleport with max distance constraint no view angle constraint
            while eventPlayer.telePos == 0 or playerTargetList.any(lambda x: distance(eventPlayer.telePos, x.getPosition()) < 15) or playerTargetList.all(lambda x: distance(eventPlayer.telePos, x.getPosition()) > botMaxTeleportRange[1]):
                eventPlayer.filteredBotSpawnPointGrid = botSpawnPoints.filter(lambda x: distance(x, eventPlayer.averagePlayersPos) < botMaxTeleportRange[1])
                #Filter out spawn points on cooldown
                eventPlayer.filteredBotSpawnPointGrid = eventPlayer.filteredBotSpawnPointGrid.filter(lambda x: botSpawnPointTimers[botSpawnPoints.index(x)] < 15)
                #Bots utilize saved spawn points
                if len(botSpawnPoints) > 0 and len(eventPlayer.filteredBotSpawnPointGrid) > 0:
                    eventPlayer.telePos = random.choice(eventPlayer.filteredBotSpawnPointGrid)
                    botSpawnPointTimers[botSpawnPoints.index(eventPlayer.telePos)] += 5
                    break
                else:
                    eventPlayer.telePos = nearestWalkablePosition(eventPlayer.averagePlayersPos + directionFromAngles(random.uniform(0, 360), random.uniform(-20, 10)) * random.uniform(0, botMaxTeleportRange[1]))
                wait(0.25)
            if playerTargetList.all(lambda x: distance(eventPlayer.telePos, x.getPosition()) > 10) and playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.telePos, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.telePos + vect(0, losHeightCheck, 0))):
                eventPlayer.teleport(eventPlayer.telePos)
                eventPlayer.teleporting = false
            #Teleport was unsuccessful due to line of sight and view angle
            elif eventPlayer.telePos in botSpawnPoints:
                del waypoints[botSpawnPoints.index(eventPlayer.telePos)]
                del botSpawnPointTimers[botSpawnPoints.index(eventPlayer.telePos)]
                botSpawnPoints.remove(eventPlayer.telePos)
    else:
        eventPlayer.teleport(eventPlayer.customTelePos)
        eventPlayer.customTelePos = null
        eventPlayer.teleporting = false
    wait()
    enterExitTeleport()


def botTeleportCenter():
    @Name "botTeleportCenter"
    
    #Standoff, Extraction, Biomorphing, Zombie Egg
    if objectiveTypes[0] in [1, 3, 6]:
        eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositions[0]))[0].getPosition()
    #Boss
    elif objectiveTypes[0] == 2:
        eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), bosses[0].getPosition()))[0].getPosition()
    #Survivor Rescue
    elif objectiveTypes[0] == 4:
        if survivorToRescue.botFollowTarget == null:
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), survivorToRescue.getPosition()))[0].getPosition()
        else:
            eventPlayer.averagePlayersPos = survivorToRescue.botFollowTarget.getPosition()
    #Killzone
    elif objectiveTypes[0] == 5:
        #If players are in the killzone
        if len(playerTargetList.filter(lambda x: distance(x.getPosition(), objectiveChase1) < objectiveRad)) > 0:
            #Player closeset to the center of the killzone
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectiveChase1))[0].getPosition()
        else:
            #Average player positon
            locateAveragePlayerLocation()
    #Satellite Uplink
    elif objectiveTypes[0] == 7:
        #Checks if any players are currently repairing terminals
        if len(playersOnObjective) > 0:
            eventPlayer.averagePlayersPos = random.choice(playersOnObjective).getPosition()
        else:
            #Closest player to sattelite firing position
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositions[0]))[0].getPosition()
    #Default
    else:
        locateAveragePlayerLocation()


def locateAveragePlayerLocation():
    @Name "locateAveragePlayerLocation"
    
    eventPlayer.averagePlayersPos = vect(0, 0, 0)
    if len(playersOnObjective) == 0 and playerTargetList.any(lambda x: x.getThrottle() != vect(0, 0, 0)):
        for eventPlayer.pPowerUpCount_bTeleCount in range(len(playerTargetList.filter(lambda x: x.getThrottle() != vect(0, 0, 0)))):
            eventPlayer.averagePlayersPos += ((playerTargetList.filter(lambda x: x.getThrottle() != vect(0, 0, 0)))[eventPlayer.pPowerUpCount_bTeleCount]).getPosition()
    else:
        for eventPlayer.pPowerUpCount_bTeleCount in range(len(playerTargetList)):
            eventPlayer.averagePlayersPos += playerTargetList[eventPlayer.pPowerUpCount_bTeleCount].getPosition()
    eventPlayer.averagePlayersPos /= eventPlayer.pPowerUpCount_bTeleCount


def successfulTeleportStatus():
    @Name "successfulTeleportStatus"
    
    #Max teleport distance adjustment
    if not eventPlayer.successfullyTeleported:
        eventPlayer.successfullyTeleported = true


def updateBotSpawnPoints():
    @Name "updateBotSpawnPoints"
    
    if eventPlayer.successfullyTeleported and eventPlayer.customTelePos == null and not eventPlayer.telePos in botSpawnPoints:
        botSpawnPoints.append(eventPlayer.telePos)
        waypoints.append(eventPlayer.waypoint)
        botSpawnPointTimers.append(0)
    elif not eventPlayer.successfullyTeleported and eventPlayer.telePos in botSpawnPoints:
        del waypoints[botSpawnPoints.index(eventPlayer.telePos)]
        del botSpawnPointTimers[botSpawnPoints.index(eventPlayer.telePos)]
        botSpawnPoints.remove(eventPlayer.telePos)


def botRespawnInitialization():
    @Name "botRespawnInitialization"
    
    eventPlayer.initializing = true
    if eventPlayer in bosses:
        eventPlayer.disableNameplatesFor(getAllPlayers())
        eventPlayer.health = 0
        eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    else:
        eventPlayer.enableNameplatesFor(getAllPlayers())
        eventPlayer.size = createWorkshopSettingFloat("Zombies", "Zombie Size", 1, 0, 20)
        eventPlayer.health = botHealthValues[botHeros.index(eventPlayer.getHero())]
        #Scale zombie voice lines with size
        eventPlayer.startModifyingVoicelinePitch(0.5 + (1 / (eventPlayer.size + 1)) + 0.25 * (sinDeg(getTotalTimeElapsed() * evalOnce(random.uniform(360, 720)))))
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.playerCollisionEnabled = true
    eventPlayer.canWallPhase = true
    eventPlayer.attached = false
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    eventPlayer.canWallPhase = true
    eventPlayer.crowdControlled = false
    eventPlayer.botTempValue = null
    eventPlayer.botTempvalue2 = null
    eventPlayer.botSpecialTarget = null
    eventPlayer.targeting = false
    eventPlayer.bossHealth = -1
    #Chance for a minboss on high difficulties
    if difficultySetting >= 3 and eventPlayer in bosses == false and len(miniBoss.filter(lambda x: entityExists(x))) == 0:
        eventPlayer.randVal = random.randint(1, 27 if objectiveTypes[0] == 1 else 189)
        if eventPlayer.randVal == 1:
            minibossMutation()
            wait(2)
    botStatManagement()
    if eventPlayer in miniBoss == true:
        goto lbl_0
    mutations()
    lbl_0:
    eventPlayer.startScalingSize(eventPlayer.size, false)
    botEntityManagement()
    waitUntil(eventPlayer.getHealth() >= eventPlayer.health, 5)
    eventPlayer.stopAllHealingOverTime()
    eventPlayer.setHealth(eventPlayer.health)
    eventPlayer.initializing = false


def botEntityManagement():
    @Name "botEntityManagement"
    
    if eventPlayer.botHero != eventPlayer.getHero() or eventPlayer in bosses:
        eventPlayer.botHero = eventPlayer.getHero()
        #Destroy all current hero effects and texts
        for eventPlayer.entityCount in range(len(eventPlayer.generalPlayerBotEntities)):
            destroyEffect(eventPlayer.generalPlayerBotEntities[eventPlayer.entityCount])
            wait()
        eventPlayer.explosionColor1 = Color.YELLOW
        eventPlayer.explosionColor2 = Color.ORANGE
        eventPlayer.generalPlayerBotEntities = []
        if eventPlayer.getHero() == Hero.ROADHOG:
            eventPlayer.setHealingReceived(30)
            if eventPlayer in bosses:
                #Gas Projectile 1
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 != null), Effect.BAD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.4 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Gas Projectile 2
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 != null), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.2 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Gas Clouds
                for eventPlayer.entityCount in range(3):
                    #Cloud Effect
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.abilityArray1[evalOnce(eventPlayer.entityCount)] != null), Effect.CLOUD, Color.LIME_GREEN, eventPlayer.abilityArray1[evalOnce(eventPlayer.entityCount)], eventPlayer.abilityArray2[evalOnce(eventPlayer.entityCount)] + 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                    #Cloud Effect ring
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.abilityArray1[evalOnce(eventPlayer.entityCount)] != null), Effect.RING, Color.LIME_GREEN, eventPlayer.abilityArray1[evalOnce(eventPlayer.entityCount)], eventPlayer.abilityArray2[evalOnce(eventPlayer.entityCount)] + 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            else:
                #Roadhog toxic cloud
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase2 > 0), Effect.CLOUD, Color.LIME_GREEN, eventPlayer, 10 * eventPlayer.size + 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.MERCY:
            #Mercy tentacle
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Beam.BAD, eventPlayer.getEyePosition() + vect(0, 0.5, 0) * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition(), eventPlayer.chase1, Color.LIME_GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Tentacle sound effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer.chase1, 400, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Tentacle end visual effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bosses:
                #Ultimate lift aura
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingUltimate() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.GOOD_AURA, Color.BLACK, eventPlayer.getPosition(), 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                eventPlayer.startForcingHero(Hero.EMRE)
        elif eventPlayer.getHero() == Hero.WRECKING_BALL:
            #Ground strike location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue), Effect.RING, Color.TEAM_2, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + vect(0, -100, 0), getAllPlayers(), getAllPlayers(), false) if eventPlayer.botTempValue else evalOnce(vect(0, -100, 0)), 1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            eventPlayer.setMaxAmmo(0, 40)
        elif eventPlayer.getHero() == Hero.REAPER:
            if eventPlayer in miniBoss:
                eventPlayer.startForcingHero(Hero.JETPACK_CAT)
                eventPlayer.setMoveSpeed(90 * eventPlayer.movementSpeed)
                eventPlayer.disableEnvironmentCollision(false)
            #Boss Only
            if eventPlayer in bosses:
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingAbility1() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.BAD_AURA, Color.GRAY, eventPlayer.getPosition(), 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.WHITE, eventPlayer, 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.PHARAH:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 > 0), Effect.GOOD_AURA, Color.BLUE, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.SIGMA:
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.TURQUOISE, eventPlayer.botTarget.getEyePosition(), 4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.ILLARI:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 > 0), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.WINSTON:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isAlive() and not eventPlayer in bosses and eventPlayer.botTempValue <= 1), Effect.GOOD_AURA, Color.RED, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bosses:
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: gameSmolderEvent), Effect.BAD_AURA, Color.BLACK, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 30, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: gameSmolderEvent), Effect.BAD_AURA, Color.RED, localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * (33 + evalOnce(random.uniform(-0.5, 0.5)))), 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.DOOMFIST:
            #Meteor strike/Seismic Slam location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1()), Effect.RING, Color.ORANGE, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + vect(0, -100, 0), getAllPlayers(), getAllPlayers(), false) if eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1() else evalOnce(vect(0, -100, 0)), 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())


def botStatManagement():
    @Name "botStatManagement"
    
    eventPlayer.biteDamage = biteDamages[botHeros.index(eventPlayer.getHero())]
    #Re-calibrate bite damage
    eventPlayer.biteDamage *= 100 / damageDealt[botHeros.index(eventPlayer.getHero())]
    eventPlayer.biteDuration = biteDurations[botHeros.index(eventPlayer.getHero())]
    #Range from 0 to 1 in terms of throttle
    eventPlayer.botThrottleSpeed = throttleSpeeds[botHeros.index(eventPlayer.getHero())]
    eventPlayer.damageDealt = damageDealt[botHeros.index(eventPlayer.getHero())] / 100
    eventPlayer.setDamageDealt(eventPlayer.damageDealt * 100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.movementSpeed = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100 + ((len(getDeadPlayers(Team.1).filter(lambda player: player.deathTimer <= 0))) * 3))
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.knockbackRecieved = 1
    eventPlayer.setKnockbackReceived(100)
    if eventPlayer.getHero() == Hero.REINHARDT:
        eventPlayer.knockbackRecieved = 0.7
        eventPlayer.setKnockbackReceived(100 * eventPlayer.knockbackRecieved)
    elif eventPlayer.getHero() == Hero.MERCY:
        eventPlayer.setProjectileSpeed(75 if eventPlayer in bosses else 20)
    elif eventPlayer.getHero() == Hero.ILLARI:
        eventPlayer.setKnockbackDealt(25)
    elif eventPlayer.getHero() == Hero.WINSTON:
        eventPlayer.size *= 0.7
        eventPlayer.chase1 = 2
        eventPlayer.startScalingBarriers(eventPlayer.size)
    elif eventPlayer.getHero() == Hero.ANA or eventPlayer.getHero() == Hero.KIRIKO:
        eventPlayer.setProjectileGravity(500)
    elif eventPlayer.getHero() == Hero.SIGMA:
        eventPlayer.setProjectileSpeed(100 * eventPlayer.size * 0.5)
        eventPlayer.setPrimaryFireEnabled(true)
    elif eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.setKnockbackDealt(120)
    elif eventPlayer.getHero() == Hero.HAZARD:
        chaseAtRate(eventPlayer.abilityArray1, 0, 1)
    elif eventPlayer.getHero() == Hero.ANRAN:
        eventPlayer.setKnockbackDealt(150)


def enableMutations():
    @Name "enableMutations"
    
    availableMutations[0] = 1 if createWorkshopSettingBool("Mutations", "Speed", true) else -1
    availableMutations[1] = 2 if createWorkshopSettingBool("Mutations", "Size Growth", true, 1) else -1
    availableMutations[2] = 3 if createWorkshopSettingBool("Mutations", "Size Reduction", true, 2) else -1
    availableMutations[3] = 4 if createWorkshopSettingBool("Mutations", "Radioactive", true, 3) else -1
    availableMutations[4] = 5 if createWorkshopSettingBool("Mutations", "Heavy", true, 4) else -1
    availableMutations.remove(-1)


def mutations():
    @Name "mutations"
    
    #Zombies have a chance to mutate. Bosses cannot mutate
    if len(availableMutations) > 0 and not eventPlayer in bosses and (random.uniform(0, 100) < (100 if challengeSetting == 3 or challengeSetting == 5 else createWorkshopSettingFloat("Mutations", "Chance to mutate percentage", 25, 0, 100))):
        eventPlayer.mutationValue = random.choice(availableMutations)
        #Speed
        if eventPlayer.mutationValue == 1:
            eventPlayer.movementSpeed *= 1.5
            eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
            eventPlayer.defaultOutlineColor = Color.PURPLE
            eventPlayer.startForcingName("SPEED")
        #Size Growth
        elif eventPlayer.mutationValue == 2:
            eventPlayer.size *= 1.5
            eventPlayer.health *= eventPlayer.size
            eventPlayer.defaultOutlineColor = Color.VIOLET
            eventPlayer.startForcingName("XL")
        #Size Reduction
        elif eventPlayer.mutationValue == 3:
            eventPlayer.size *= 0.6
            eventPlayer.health *= eventPlayer.size
            eventPlayer.defaultOutlineColor = Color.ROSE
            eventPlayer.startForcingName("XS")
        #Radioactive
        elif eventPlayer.mutationValue == 4:
            eventPlayer.biteDuration *= 1.5
            eventPlayer.defaultOutlineColor = Color.LIME_GREEN
            eventPlayer.startForcingName("Radioactive")
        #Heavy
        elif eventPlayer.mutationValue == 5:
            eventPlayer.knockbackRecieved *= 0.5
            eventPlayer.setKnockbackReceived(100 * eventPlayer.knockbackRecieved)
            #Scale move speed
            eventPlayer.movementSpeed *= eventPlayer.knockbackRecieved
            eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeed)
            #Scale health
            eventPlayer.health /= eventPlayer.knockbackRecieved
            eventPlayer.defaultOutlineColor = Color.BLACK
            eventPlayer.startForcingName("Heavy")
        #Mutation outline for players
        eventPlayer.startForcingOutlineFor(getAllPlayers(), true, eventPlayer.defaultOutlineColor)
    else:
        eventPlayer.mutationValue = 0
        eventPlayer.defaultOutlineColor = null
        #Default ouline for players
        eventPlayer.stopForcingOutlineFor(getAllPlayers())
        eventPlayer.stopForcingName()


def minibossMutation():
    @Name "minibossMutation"
    
    miniBoss.append(eventPlayer)
    eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.HAZARD, Hero.REAPER]))
    if zombieSetting == 6:
        eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL]))
    eventPlayer.health = 2500
    eventPlayer.size *= 1.55
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE)
    eventPlayer.startForcingName("Contestor")
    #Skull Icon
    createIcon(getAllPlayers().filter(lambda _: eventPlayer.initializing == false and eventPlayer in bosses == false), eventPlayer.getEyePosition() + Vector.UP, Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.ORANGE)
    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())


rule "MINIBOSS MESSAGE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in miniBoss == true
    @Condition objectiveTypes[0] != 1
    @Condition gameStatus == true
    @Condition eventPlayer.initializing != false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bigMessage(getAllPlayers(), "A Contestor approaches")


def abilityPlacement():
    @Name "abilityPlacement"
    
    wait(0.5)
    if eventPlayer.crowdControlled == true:
        return
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 1.6)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == true, 1)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) == true:
        wait(1)
        eventPlayer.forceButtonPress(Button.INTERACT)
    else:
        eventPlayer.cancelPrimaryAction()


def abilityThrowdown():
    @Name "abilityThrowdown"
    
    if eventPlayer.hasStatus(Status.HACKED):
        return
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.startFacing(Vector.DOWN, 999)
    wait(0.3)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.allowButton(Button.MELEE)
    restoreDefaultFacingMovement()
    if eventPlayer.getHero() == Hero.HAZARD:
        wait(0.25)
        if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
            return
        (getPlayersInRadius(eventPlayer, 2, Team.2, LosCheck.SURFACES).filter(lambda player: player != eventPlayer)).applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, distance(eventPlayer.botTarget, eventPlayer) * (2 / eventPlayer.size), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.abilityArray1 += 2


def entityFloat():
    @Name "entityFloat"
    
    #Entities that will be floated
    eventPlayer.botSpecialPotentialTargets = getLivingPlayers(Team.ALL).filter(lambda player: player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 12 * eventPlayer.size and isInLoS(player.getPosition() + vect(0, losHeightCheck, 0), eventPlayer.getPosition() + vect(0, losHeightCheck, 0), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))


def explosionWarning():
    @Name "explosionWarning"
    
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.explosionSize = eventPlayer.size
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    wait(0.5)
    eventPlayer.botTempValue = false
    if eventPlayer.isDead():
        return
    kill(eventPlayer, eventPlayer)
    explosionSequence()


def explosionSequence():
    @Name "explosionSequence"
    
    eventPlayer.botSpecialPotentialTargets = getPlayers(Team.2) if not eventPlayer.isDummy() else getAllPlayers().filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < eventPlayer.explosionSize * 6 and (isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) if eventPlayer.isDummy() else true))
    #Scaled
    damage(eventPlayer.botSpecialPotentialTargets, eventPlayer, eventPlayer.biteDamage * 2.5 if eventPlayer.isDummy() else eventPlayer.infectionLvl * 100)
    if eventPlayer.isDummy():
        #Scaled
        damage(eventPlayer.botSpecialPotentialTargets.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 3 * eventPlayer.size), eventPlayer, eventPlayer.biteDamage * 5)
        #Scaled
        eventPlayer.botSpecialPotentialTargets.setStatusEffect(eventPlayer, Status.BURNING, 3)
        #Not scaled damage
        eventPlayer.botSpecialPotentialTargets.startDamageOverTime(eventPlayer, 3, eventPlayer.biteDamage * 2)
        if eventPlayer.damageOverTimeDuration < 3:
            eventPlayer.damageOverTimeDuration = 3
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionColor2, eventPlayer.getPosition(), 6 * eventPlayer.explosionSize)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionColor1, eventPlayer.getPosition(), 3 * eventPlayer.explosionSize)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionSize)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionSize)
    wait(0.25)


rule "============================================== ZOMBIE TYPES ====================================================":
    @Disabled
    @Delimiter
    


rule "BASIC (REAPER) SHADOW STEP (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reaper
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(1)
    while not eventPlayer.isUsingAbility2():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        waitUntil(eventPlayer.isUsingAbility2(), 0.5)
        if eventPlayer.isUsingAbility2():
            waitUntil(not eventPlayer.isUsingAbility2(), 2)
            break
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.25)
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(vect(-1, 0, 0), 180, Relativity.TO_PLAYER)
    while eventPlayer.isUsingAbility1():
        entityFloat()
        for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.botSpecialPotentialTargets)):
            eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[eventPlayer.pForceFieldCount2_bCount1]
            if eventPlayer.botSpecialTarget.getPosition().y < eventPlayer.getPosition().y + 4 * eventPlayer.size:
                #Make target float up
                eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.getPosition())), -50), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            else:
                #Push target straight up
                eventPlayer.botSpecialTarget.applyImpulse(vect(0, 1, 0), 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.032)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "BOMBER (JUNKRAT) SELF DESTRUCT":
    @Event eachPlayer
    @Team 2
    @Hero junkrat
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botTempValue = true
    explosionWarning()
    if ruleCondition:
        loop()


rule "RUSHER (TORB) SPEED MECHANICS":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition eventPlayer in bosses == false
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 45
    
    eventPlayer.applyImpulse(vect(0, 1, 3), 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.5)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    while not eventPlayer.isUsingAbility2():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.crowdControlled, 9999)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        wait(0.25)
        if eventPlayer.isDead():
            return
    eventPlayer.addHealthPool(Health.ARMOR, 1000, false)
    eventPlayer.botTempValue = getLastCreatedHealthPool()
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    wait(1)
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionFromAngles(evalOnce(random.uniform(0, 360)), evalOnce(random.uniform(-80, -87))), 0 if eventPlayer.crowdControlled else 144, Relativity.TO_PLAYER)
    while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
        waitUntil(not eventPlayer.isMeleeing() and not eventPlayer.crowdControlled, 9999)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.25)
    wait(1)
    while eventPlayer.isUsingUltimate():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.25)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    removeHealthPool(eventPlayer.botTempValue)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    if ruleCondition:
        loop()


rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero torbjorn
    @Condition eventAbility == Button.ULTIMATE
    
    victim.startDamageOverTime(attacker, 1, eventPlayer.biteDamage * 0.5)
    victim.setStatusEffect(attacker, Status.BURNING, 0.5)
    if victim.damageOverTimeDuration < 0.5:
        victim.damageOverTimeDuration = 0.5


rule "BEHEMOTH (ROAD) TOXIC CLOUD":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition (eventPlayer in bosses or eventPlayer.getNormalizedHealth() < 0.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityResource(Button.ABILITY_2, 100)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    eventPlayer.chase2 = 1.5
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.5)
    chaseAtRate(eventPlayer.chase2, 0, 1, ChaseRateReeval.NONE)
    while eventPlayer.chase2 > 0 and eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0:
        if eventPlayer in bosses:
            #Charge Ultimate For Boss Gas Attack
            eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)
            eventPlayer.setStatusEffect(eventPlayer, Status.ROOTED, 0.26)
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3)
        else:
            #Gas Attack
            (playerTargetList.filter(lambda x: isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer.getPosition(), x.getPosition()) < 10 * eventPlayer.size and x.getEyePosition().y - eventPlayer.getPosition().y > 0 and x.getPosition().y - eventPlayer.getPosition().y < 2 * eventPlayer.size)).startDamageOverTime(eventPlayer, 2.5, eventPlayer.biteDamage * 0.231)
            if eventPlayer.damageOverTimeDuration < 2.5:
                eventPlayer.damageOverTimeDuration = 2.5
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
        waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.25)
    #Cooldown
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3 if eventPlayer in bosses else 8)
    eventPlayer.chase2 = 0
    stopChasing(eventPlayer.chase2)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    if eventPlayer in bosses and eventPlayer.getUltCharge() >= 100:
        eventPlayer.setUltCharge(0)
        eventPlayer.specialThrottling = true
        eventPlayer.stopThrottleInDirection()
        eventPlayer.specialFacing = true
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled or eventPlayer.botTarget == null else 100)
        wait(1)
        waitUntil(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition())) < 5, 5)
        eventPlayer.stopFacing()
        eventPlayer.setStatusEffect(null, Status.STUNNED, 1)
        waitUntil(not eventPlayer.crowdControlled, 2)
        eventPlayer.chase1 = eventPlayer.getEyePosition()
        eventPlayer.botTempValue = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.size, null, getAllPlayers(), false)
        #Launch Gas Projectile
        chaseAtRate(eventPlayer.chase1, eventPlayer.botTempValue, 20 * eventPlayer.size / 3, ChaseRateReeval.NONE)
        eventPlayer.specialFacing = false
        eventPlayer.specialThrottling = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        #Gas Cloud Positions
        eventPlayer.abilityArray1 = []
        #Gas Cloud Areas of Effect
        eventPlayer.abilityArray2 = []
        while distance(eventPlayer.chase1, eventPlayer.botTempValue) > 0.1 and len(eventPlayer.abilityArray1) < 3:
            eventPlayer.abilityArray1.append(eventPlayer.chase1)
            eventPlayer.abilityArray2.append(0)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.chase1, 0.4 * eventPlayer.size)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.chase1, 75)
            waitUntil(distance(eventPlayer.chase1, eventPlayer.botTempValue) <= 0.1 or len(eventPlayer.abilityArray1) >= 3, 0.9)
        #If projectile hits wall
        if len(eventPlayer.abilityArray1) < 3:
            eventPlayer.abilityArray1.append(eventPlayer.chase1)
            eventPlayer.abilityArray2.append(0)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.chase1, 0.4 * eventPlayer.size)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.chase1, 75)
        stopChasing(eventPlayer.chase1)
        eventPlayer.chase1 = null
        waitUntil(eventPlayer.isDead(), 3)
        wait(5)
        eventPlayer.abilityArray1 = []
        eventPlayer.abilityArray2 = []
    if ruleCondition:
        loop()


rule "BEHEMOTH GAS STREAM (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition len(eventPlayer.abilityArray1) > 0
    
    eventPlayer.botSpecialPotentialTargets = []
    for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.abilityArray1)):
        if eventPlayer.abilityArray2[eventPlayer.pForceFieldCount2_bCount1] < 6 * eventPlayer.size:
            eventPlayer.abilityArray2[eventPlayer.pForceFieldCount2_bCount1] += 0.2 * eventPlayer.size
        eventPlayer.botSpecialPotentialTargets.append(playerTargetList.filter(lambda x: not x in eventPlayer.botSpecialPotentialTargets and distance(eventPlayer.abilityArray1[eventPlayer.pForceFieldCount2_bCount1], vect(x.getEyePosition().x, eventPlayer.abilityArray1[eventPlayer.pForceFieldCount2_bCount1].y, x.getEyePosition().z)) < eventPlayer.abilityArray2[eventPlayer.pForceFieldCount2_bCount1] and abs(eventPlayer.abilityArray1[eventPlayer.pForceFieldCount2_bCount1].y - x.getEyePosition().y) < eventPlayer.abilityArray2[eventPlayer.pForceFieldCount2_bCount1] / 5))
    eventPlayer.botSpecialPotentialTargets.startDamageOverTime(eventPlayer, 2.5, eventPlayer.biteDamage * 0.1)
    if eventPlayer.damageOverTimeDuration < 2.5 and len(eventPlayer.botSpecialPotentialTargets) > 0:
        eventPlayer.damageOverTimeDuration = 2.5
    wait(0.25)
    if ruleCondition:
        loop()


rule "BRUTE (REIN) SUPER SEISMIC SLAM":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition distance(worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget.getPosition()) < 1.5 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    while not eventPlayer.isUsingUltimate():
        wait(0.016, Wait.RESTART_WHEN_TRUE)
        if eventPlayer.isDead():
            return
        if eventPlayer.crowdControlled:
            return
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 20 * eventPlayer.size)
    (getLivingPlayers(Team.ALL).exclude(eventPlayer).filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 20 * eventPlayer.size and distance(worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition()) > 1.5 * eventPlayer.size and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.size)).applyImpulse(vect(0, 1, 0), 15 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3 * eventPlayer.size)
    (null.concat(getLivingPlayers(Team.2)).filter(lambda x: distance(x.getPosition(), worldVector(vect(0, 0, 3 * eventPlayer.size), eventPlayer, Transform.ROTATION_AND_TRANSLATION)) < 1.5 * eventPlayer.size and not x.hasStatus(Status.KNOCKED_DOWN))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2.5)


rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 5 * eventPlayer.size
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.WINSTON, Hero.JUNKER_QUEEN] == true
    
    if eventPlayer.getHero() == Hero.WINSTON and not eventPlayer.isUsingUltimate():
        return
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.startForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)
    wait(0.25)
    if eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        wait(7.75)
    eventPlayer.setPrimaryFireEnabled(false)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)


rule "BRUTE KNOCKDOWN":
    @Event playerTookDamage
    @Team 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.getHero() == Hero.REINHARDT
    
    attacker.setUltCharge(attacker.getUltCharge() + 25)
    eventPlayer.applyImpulse(directionTowards(attacker.getPosition(), eventPlayer.getPosition()) + vect(0, 0.25, 0), 15 * attacker.size, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    if eventPlayer.specialCooldown == true:
        goto lbl_0
    eventPlayer.specialCooldown = true
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    eventPlayer.setGravity(0)
    wait(0.35)
    eventPlayer.setGravity(100)
    wait(2)


rule "BRUTE FIRE STRIKE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) > 5 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    wait(1)
    if ruleCondition:
        loop()


rule "REIGNITED (ANRAN) ABILITIES":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == false
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.isOnGround() and eventPlayer.botTarget != null and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 6 * eventPlayer.size and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size and abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20 or eventPlayer.isUsingUltimate()) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.specialFacing = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.canWallPhase = false
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), vect(eventPlayer.botTarget.getEyePosition().x, 10000, eventPlayer.botTarget.getEyePosition().z)), 10000)
    eventPlayer.startForcingButton(Button.CROUCH)
    wait(0.5)
    eventPlayer.stopForcingButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    if not eventPlayer.crowdControlled:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.5)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 10000)
        eventPlayer.cancelPrimaryAction()
        if not eventPlayer.crowdControlled and eventPlayer.botTarget != null:
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            eventPlayer.applyImpulse(normalize(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, 0.25, 0)), eventPlayer.size * (15 + 25 * abs(cosDeg(verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()))))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.specialThrottling = false
            eventPlayer.specialFacing = true
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            eventPlayer.forceButtonPress(Button.ABILITY_1)
    #wait(0.5)
    waitUntil(eventPlayer.isOnGround(), 1)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = true
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(4)
    loop()


rule "REIGNITED ULTIMATE ATTACK COUNTER":
    @Event playerTookDamage
    @Team 2
    @Hero anran
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventPlayer.botTempValue == false
    
    eventPlayer.botTempValue = true
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.setStatusEffect(null, Status.BURNING, 5)
    wait(5)
    eventPlayer.botTempValue = false


rule "REIGNITED USES ULTIMATE NEAR PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero anran
    @Condition eventPlayer.isUsingUltimate() == true
    
    if eventPlayer.isOnGround() and getLivingPlayers(Team.1).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 12):
        eventPlayer.botTempvalue2 = true
    wait(0.25)
    eventPlayer.botTempvalue2 = false
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.addHealthPool(Health.ARMOR, 100, false, false)


rule "ZOMBIES SPAWN AT REIGNITED":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.isUsingUltimate() and eventPlayer.getHero() == Hero.ANRAN) != true
    @Condition eventPlayer in bosses != true
    @Condition eventPlayer in miniBoss != true
    @Condition len(getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botTempvalue2)) > null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.anranPortal == false
    
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 0.5)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2)
    eventPlayer.setStatusEffect(null, Status.BURNING, 2.3)
    eventPlayer.anranPortalRise = getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botTempvalue2)[0]
    eventPlayer.anranPortal = random.choice(mapGrid.filter(lambda x: distance(eventPlayer.anranPortalRise.getPosition(), x) > 2 and distance(eventPlayer.anranPortalRise.getPosition(), x) < 7))
    eventPlayer.anranPortalRise = eventPlayer.anranPortal - vect(0, 2, 0)
    eventPlayer.startForcingPosition(eventPlayer.anranPortalRise)
    chaseOverTime(eventPlayer.anranPortalRise, eventPlayer.anranPortal, 1.5)
    wait(2)
    eventPlayer.anranPortal = false
    eventPlayer.stopForcingPosition()


rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS":
    @Event playerDealtDamage
    @Team 2
    @Hero widowmaker
    @Condition eventAbility == Button.MELEE
    @Condition victim == eventPlayer.botTarget
    @Condition eventPlayer.attached != true
    @Condition eventPlayer in bosses == false
    
    eventPlayer.attached = true
    eventPlayer.botSpecialTarget = victim
    eventPlayer.attachTo(eventPlayer.botSpecialTarget, vect(0, 0, eventPlayer.botSpecialTarget.size))


rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.botSpecialTarget != null
    @Condition (eventPlayer.crowdControlled or eventPlayer.botSpecialTarget.invisible or eventPlayer.isDead() or eventPlayer.botSpecialTarget.isDead() or eventPlayer.botSpecialTarget.hasStatus(Status.PHASED_OUT) or eventPlayer.botSpecialTarget.hasStatus(Status.INVINCIBLE) or not entityExists(eventPlayer.botSpecialTarget)) == true
    
    eventPlayer.botSpecialTarget = null
    eventPlayer.attached = false
    eventPlayer.detach()


rule "RIDER ATTACH TO TEAMMATES":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.isAlive() == true
    #If any valid teammates are within range
    @Condition (getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: not x.teleporting and x.getHero() != Hero.WIDOWMAKER and distance(eventPlayer.getPosition(), x.getPosition()) < 4 * eventPlayer.size)) == true
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget) > 20 or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0 and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 7.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botSpecialTarget = (sorted(getLivingPlayers(Team.2).exclude(eventPlayer).filter(lambda x: not x.teleporting and x.getHero() != eventPlayer.getHero()), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    eventPlayer.attachTo(eventPlayer.botSpecialTarget, eventPlayer.botSpecialTarget.size * vect(random.uniform(-0.5, 0.5), 0.25, -0.75))
    eventPlayer.attached = true


rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botSpecialTarget.getTeam() == Team.2
    @Condition (eventPlayer.teleporting or eventPlayer.botSpecialTarget.teleporting or distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 3 or eventPlayer.botTarget.isOnGround() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 10) == true
    
    eventPlayer.botSpecialTarget = null
    eventPlayer.attached = false
    eventPlayer.detach()


rule "RIDER USE GRAPPLING HOOK":
    @Event eachPlayer
    @Team 2
    @Hero widowmaker
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.botTarget.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5
    
    eventPlayer.specialFacing = true
    eventPlayer.botTempValue = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition(), null, eventPlayer, false)
    eventPlayer.stopFacing()
    waitUntil(not eventPlayer.crowdControlled, 2)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTempValue), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    wait(0.25)
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 4 or distance(eventPlayer.getPosition(), eventPlayer.botTempValue) < 3.5, 3)
    if eventPlayer.isUsingAbility1():
        eventPlayer.startForcingButton(Button.JUMP)
        wait(0.25)
        eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
    wait(0.25)
    if ruleCondition:
        loop()


rule "CHARGER (MAUGA) CHARGE":
    @Event eachPlayer
    @Team 2
    @Hero mauga
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 5 or verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition())) > -35) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.canWallPhase = false
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled else 100)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(vect(0, 0, -1), 0.35, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Charger walk backwards duration
    for eventPlayer.pNoCooldownsCount_bCount2 in range(0, 1, 0.064):
        if eventPlayer.crowdControlled or eventPlayer.isDead():
            eventPlayer.specialFacing = false
            eventPlayer.specialThrottling = false
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
            return
        wait(0.064)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() if eventPlayer.botTempValue == null else eventPlayer.botTempValue), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    #Charge End
    waitUntil(not eventPlayer.isUsingAbility1(), 2 if eventPlayer in bosses else 3.5)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4 if eventPlayer in bosses else 6)


rule "CHARGER KNOCKBACK":
    @Event playerDealtDamage
    @Team 2
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    #Damage players
    damage(victim, eventPlayer, eventPlayer.biteDamage * 0.75)
    if not eventPlayer.isUsingAbility1():
        return
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)


rule "SLIMER (MERCY) TENTACLE GRAB":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    
    wait(0.016 if eventPlayer.isUsingUltimate() else 0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botSpecialTarget = null
    eventPlayer.chase1 = eventPlayer.getEyePosition() + vect(0, 0.5, 0) * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition()
    eventPlayer.botTempValue = eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.size
    #Tentacle extends
    chaseAtRate(eventPlayer.chase1, eventPlayer.botTempValue, 50)
    wait()
    while eventPlayer.isAlive() and not eventPlayer.crowdControlled and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.botTempValue, getLivingPlayers(Team.1), getAllPlayers(), true)) > distance(eventPlayer.getEyePosition(), eventPlayer.chase1):
        if playerTargetList.any(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.chase1, x.getEyePosition()) < 1 and isInLoS(eventPlayer.chase1, x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)):
            eventPlayer.botSpecialTarget = (playerTargetList.filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.chase1, x.getEyePosition()) < 1 and isInLoS(eventPlayer.chase1, eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)))[0]
            eventPlayer.botTempValue = eventPlayer.botSpecialTarget.getEyePosition()
            break
        wait(0.032)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.chase1, 0.25)
    #Tentacle retract
    chaseAtRate(eventPlayer.chase1, eventPlayer.getEyePosition() + vect(0, 0.5, 0) * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition(), 50)
    if eventPlayer.isAlive() and not eventPlayer.crowdControlled and eventPlayer.botSpecialTarget != null:
        #Knocks target down if facing away from Mercy
        if abs(angleDifference(eventPlayer.botSpecialTarget.getHorizontalFacingAngle(), horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())))) < 75:
            eventPlayer.botSpecialTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 0.35)
        eventPlayer.botSpecialTarget.setGravity(0)
        eventPlayer.botSpecialTarget.applyImpulse(directionTowards(eventPlayer.botSpecialTarget.getEyePosition(), eventPlayer.getEyePosition()), eventPlayer.size * (15 if eventPlayer.botSpecialTarget.getMaxHealth() < 400 else 10), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.35)
        eventPlayer.botSpecialTarget.setGravity(100)
    while (distance(eventPlayer.chase1, eventPlayer.getEyePosition() + vect(0, 0.5, 0) * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition())) > 0.25:
        wait(0.25)
    eventPlayer.botTempValue = null
    stopChasing(eventPlayer.chase1)
    #Lower cooldown for ulting boss if they do not hit a target
    if eventPlayer in bosses and eventPlayer.isUsingUltimate():
        wait(0.25)
    else:
        eventPlayer.specialThrottling = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(2.25 if eventPlayer.botTarget.isInAir() else 4.5)
    if ruleCondition:
        loop()


rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero emre
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == null
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.specialThrottling = true
    while not eventPlayer.isJumping():
        eventPlayer.wallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        eventPlayer.forceButtonPress(Button.JUMP)
        waitUntil(eventPlayer.isJumping(), 1)
    eventPlayer.applyImpulse(vect(0, 1, 0), random.uniform(6, 10) * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    waitUntil(eventPlayer.getVelocity().y < 0, 3)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.BLACK, eventPlayer, 5 * eventPlayer.size)
    while eventPlayer.isUsingUltimate():
        eventPlayer.specialThrottling = true
        eventPlayer.specialFacing = true
        eventPlayer.stopThrottleInDirection()
        while eventPlayer.botTarget != null and eventPlayer.isUsingUltimate() and not eventPlayer.crowdControlled:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1), 0 if eventPlayer.crowdControlled else 200)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
            #Altitude too low
            if eventPlayer.getAltitude() < 3:
                eventPlayer.wallCollisionEnabled = true
                eventPlayer.enableEnvironmentCollision()
                eventPlayer.forceButtonPress(Button.JUMP)
            #Entities that will be floated
            entityFloat()
            for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.botSpecialPotentialTargets)):
                eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[eventPlayer.pForceFieldCount2_bCount1]
                if eventPlayer.botSpecialTarget.getPosition().y < eventPlayer.getPosition().y:
                    #Make target float up
                    eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.getPosition())), -75), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                else:
                    #Push target away
                    eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), -20), 0.75, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            wait(0.032)
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
        wait(0.25)
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(10)
    if ruleCondition:
        loop()


rule "STRIKER (WRECKING BALL) PILE DRIVER":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.getAbilityCooldown(Button.CROUCH) <= 0
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 35
    @Condition (eventPlayer.getAltitude() > 3 or eventPlayer.isOnGround() and isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + vect(0, 3, 0))) == true
    
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 1)
    eventPlayer.botTempValue = true
    eventPlayer.canWallPhase = false
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.enableEnvironmentCollision()
    if eventPlayer.isOnGround():
        while not eventPlayer.isJumping():
            eventPlayer.forceButtonPress(Button.JUMP)
            waitUntil(eventPlayer.isJumping(), 1)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 4 * eventPlayer.size)
        eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, 10 * eventPlayer.size, 0)), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.25)
        waitUntil(eventPlayer.getVelocity().y <= 0, 3)
    eventPlayer.forceButtonPress(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.crowdControlled, 5)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 3)
    eventPlayer.botTempValue = null
    eventPlayer.canWallPhase = true


rule "STRIKER CANCEL BALL FORM":
    @Event eachPlayer
    @Team 2
    @Hero wreckingBall
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.specialThrottling == false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    if ruleCondition:
        loop()


rule "STRIKER NORMAL PILE DRIVER":
    @Event playerDealtKnockback
    @Team 2
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    @Condition eventPlayer in bosses != true
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), 0), 7.5 * eventPlayer.size, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "STALKER (MOIRA) FADE":
    @Event eachPlayer
    @Team 2
    @Hero moira
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 45
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialFacing = true
    eventPlayer.playerCollisionEnabled = false
    eventPlayer.disablePlayerCollision()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isUsingUltimate() else 75 if eventPlayer.isUsingAbility1() else 1500)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    for eventPlayer.pForceFieldCount2_bCount1 in range(5 if eventPlayer in bosses else 3):
        eventPlayer.canWallPhase = false
        eventPlayer.wallCollisionEnabled = true
        eventPlayer.enableEnvironmentCollision()
        #Final fade
        if eventPlayer.pForceFieldCount2_bCount1 >= 2 and not eventPlayer in bosses:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled else 100)
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()), 0 if distance(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()) < 3 and eventPlayer.isUsingAbility1() else eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
        eventPlayer.movementSpeed *= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.125)
        waitUntil(not eventPlayer.isUsingAbility1(), 2)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.movementSpeed /= 2
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        if eventPlayer.isDead() or eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
            break
        if eventPlayer in bosses:
            wait(0.125)
            eventPlayer.setUltCharge(100)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
            waitUntil(not eventPlayer.isUsingUltimate(), 1.3)
            eventPlayer.cancelPrimaryAction()
        else:
            eventPlayer.canWallPhase = true
            wait(0.75)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.playerCollisionEnabled = true
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10 if eventPlayer in bosses else 5)


rule "STALKER KNOCKBACK BLAST (BOSS)":
    @Event playerDealtDamage
    @Team 2
    @Hero moira
    @Condition eventAbility == Button.ULTIMATE
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(attacker.getPosition(), victim.getPosition())), -25), 10 * attacker.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        victim.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)


rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES":
    @Event eachPlayer
    @Team 2
    @Hero pharah
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.chase1 = 0
    eventPlayer.setDamageReceived(50)
    #charge up attack
    chaseOverTime(eventPlayer.chase1, 2, 1 if eventPlayer.botTarget.isInAir() else 2, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 >= 2, 99999)
    stopChasing(eventPlayer.chase1)
    if eventPlayer.isDead():
        eventPlayer.setDamageReceived(100)
        eventPlayer.chase1 = 0
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        return
    else:
        #charge up attack
        chaseOverTime(eventPlayer.chase1, 0, 0.25, ChaseTimeReeval.NONE)
    eventPlayer.setDamageReceived(100)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 <= 0, 99999)
    if eventPlayer.isDead():
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        return
    if isInLoS(eventPlayer.getPosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)) and isInLoS(eventPlayer.lastTarget.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(0, 11, 5), eventPlayer, Transform.ROTATION)):
        waitUntil(not eventPlayer.crowdControlled, 9999)
        eventPlayer.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
        wait()
        waitUntil(eventPlayer.getVerticalSpeed() <= 0, 99999)
        eventPlayer.stopThrottleInDirection()
        #Cooldown after flying
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        #Cooldown after staying on ground
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1)
    if eventPlayer in bosses:
        while not eventPlayer.isUsingUltimate() and eventPlayer.isAlive():
            eventPlayer.setUltCharge(100)
            eventPlayer.setProjectileSpeed(35)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.25)
        waitUntil(not eventPlayer.isUsingUltimate(), 5)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4)
    else:
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.5)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "BLASTER ROCKET HITS TARGET":
    @Event playerDealtDamage
    @Team 2
    @Hero pharah
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ULTIMATE) == true
    
    if eventAbility == Button.ULTIMATE:
        victim.startDamageOverTime(eventPlayer, 2, eventPlayer.biteDamage * 0.5)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
        if eventPlayer.damageOverTimeDuration < 2:
            eventPlayer.damageOverTimeDuration = 2
    elif eventAbility == Button.PRIMARY_FIRE:
        victim.startDamageOverTime(eventPlayer, 1, eventPlayer.biteDamage)
        victim.setStatusEffect(eventPlayer, Status.BURNING, 1)
        if eventPlayer.damageOverTimeDuration < 1:
            eventPlayer.damageOverTimeDuration = 1


rule "DOWNFALLEN (SIGMA) FIRES":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.botTempValue != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 40
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 5 * eventPlayer.size
    
    if not eventPlayer in bosses and eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) != true:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    if distance(eventPlayer, eventPlayer.botTarget) < 11 * eventPlayer.size and not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait(0.1)
        eventPlayer.cancelPrimaryAction()
    wait(2)
    if ruleCondition:
        loop()


rule "DOWNFALLEN GRABS PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= ((2.5 if eventPlayer in bosses else 3) * eventPlayer.size)
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer.botTempValue != true
    @Condition eventPlayer.botTarget.specialCooldown != true
    @Condition eventPlayer.successfullyTeleported == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.botSpecialTarget = eventPlayer.botTarget
    eventPlayer.botTempValue = true
    eventPlayer.botSpecialTarget.specialCooldown = true
    eventPlayer.specialThrottling = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setUltCharge(100)
    eventPlayer.botSpecialTarget.attachTo(eventPlayer, vect(0, 3 if eventPlayer in bosses else 0, 1))
    eventPlayer.canWallPhase = false
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.botSpecialTarget.startFacing(directionTowards(eventPlayer.botSpecialTarget.getEyePosition(), vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y - 0.2, eventPlayer.getEyePosition().z)), 999)
    eventPlayer.applyImpulse(vect(0, 5, -3), 5 * eventPlayer.size, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    waitUntil(not eventPlayer.isUsingUltimate(), 1.25)
    eventPlayer.cancelPrimaryAction()
    if eventPlayer.crowdControlled or distance(eventPlayer.getEyePosition(), eventPlayer.botSpecialTarget.getEyePosition()) > 4 * eventPlayer.size or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead():
        eventPlayer.botSpecialTarget.stopFacing()
        eventPlayer.botSpecialTarget.detach()
    else:
        eventPlayer.forceButtonPress(Button.MELEE)
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.stopFacing()
        eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botSpecialTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 1.75)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.botTempvalue2 = null
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.canWallPhase = true
    wait(7)
    eventPlayer.botTempValue = false
    eventPlayer.botSpecialTarget = false


rule "DOWNFALLEN PULLS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.botTarget.applyImpulse(directionTowards(eventPlayer.botTarget.getEyePosition(), eventPlayer.getEyePosition()), 2, Relativity.TO_WORLD)
    if eventPlayer.botTarget == null or eventPlayer.isInViewAngle(eventPlayer.botTarget.getPosition(), 55) != true or eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) == true:
        eventPlayer.cancelPrimaryAction()
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5.9)


rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT":
    @Event eachPlayer
    @Team 2
    @Hero junkerQueen
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(20)
    loop()


rule "DAYTAKER (ILLARI) BURST":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition getLivingPlayers(Team.2).exclude(eventPlayer).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 2.5 * eventPlayer.size) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.specialThrottling = true
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)
    eventPlayer.chase1 = 0
    #charge up attack
    chaseOverTime(eventPlayer.chase1, 2, 2 if eventPlayer in bosses else 1, ChaseTimeReeval.NONE)
    #Gather zombies
    eventPlayer.botSpecialTarget = (sorted((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 2.5 * eventPlayer.size and ((player.getHero() != Hero.ILLARI and player != bosses) == true))).exclude(eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    if eventPlayer.botSpecialTarget in bosses == true:
        goto lbl_0
    eventPlayer.botSpecialTarget.attached = true
    eventPlayer.botSpecialTarget.attachTo(eventPlayer, vect(0, 0.65 * eventPlayer.size, 0.5 * eventPlayer.size))
    waitUntil(eventPlayer.isDead() or eventPlayer.botTarget == null or angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 10, 10)
    waitUntil(eventPlayer.isDead() or eventPlayer.crowdControlled == true or eventPlayer.chase1 >= 2, 99999)
    #Finish charging
    stopChasing(eventPlayer.chase1)
    if eventPlayer.crowdControlled == true:
        lbl_0:
        stopChasing(eventPlayer.chase1)
        eventPlayer.chase1 = 0
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.attached = false
        goto lbl_1
    #Abort
    if eventPlayer.isDead():
        eventPlayer.chase1 = 0
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        eventPlayer.botSpecialTarget.attached = false
        return
    else:
        chaseOverTime(eventPlayer.chase1, 0, 0.35, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.isDead() or eventPlayer.chase1 <= 0, 99999)
    #Abort
    if eventPlayer.isDead():
        eventPlayer.specialThrottling = false
        eventPlayer.specialFacing = false
        eventPlayer.botSpecialTarget.attached = false
        return
    waitUntil(not eventPlayer.crowdControlled, 9999)
    eventPlayer.startThrottleInDirection(vect(0, 0, 1), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    #Eject zombies
    if eventPlayer.isAlive() and eventPlayer.botSpecialTarget.isAlive():
        eventPlayer.botSpecialTarget.detach()
        eventPlayer.botSpecialTarget.attached = false
        #Boss Collision
        if eventPlayer in bosses:
            eventPlayer.canWallPhase = false
        eventPlayer.cancelPrimaryAction()
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.2)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.botSpecialTarget.getPosition(), 1.5 * eventPlayer.botSpecialTarget.size)
        if eventPlayer.botTarget != null:
            eventPlayer.botSpecialTarget.applyImpulse(directionTowards(eventPlayer.botSpecialTarget.getPosition(), eventPlayer.botTarget.getEyePosition() + vect(0, 3 * eventPlayer.botTarget.size, 0)), 20 + 9 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        else:
            eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), -35), 20 + 9 * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.botSpecialTarget = null
    lbl_1:
    wait(0.1)
    #Cooldown
    waitUntil(eventPlayer.getVerticalSpeed() <= 0, 99999)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7 if 0 in bosses else 1 if eventPlayer.botTarget.isInAir() else 3)
    #Boss Collision
    if eventPlayer in bosses:
        eventPlayer.canWallPhase = true
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    @Condition eventPlayer.crowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    illariUlt()
    wait(10)
    if ruleCondition:
        loop()


def illariUlt():
    @Name "DAYTAKER'S REVENGE (BOSS)"
    
    eventPlayer.botSpecialTarget.detach()
    eventPlayer.botSpecialTarget.attached = false
    eventPlayer.botSpecialTarget = null
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    eventPlayer.setUltCharge(100)
    wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.movementSpeed /= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    wait(1.5)
    if eventPlayer.isDead():
        return
    if eventPlayer == eventPlayer.hasStatus(Status.HACKED):
        goto lbl_0
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    lbl_0:
    waitUntil(eventPlayer.isUsingUltimate(), false)
    eventPlayer.movementSpeed *= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


rule "TUNNELER (SYMMETRA) BUILDS PORTAL":
    @Event eachPlayer
    @Team 2
    @Hero symmetra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    @Condition eventPlayer.botTarget.isOnGround() == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    abilityPlacement()
    wait(7)


rule "TUNNELER PORTAL LETS ZOMBIES THROUGH":
    @Event eachPlayer
    @Team 2
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition eventPlayer in bosses == false
    @Condition isHeroBeingPlayed(Hero.SYMMETRA, Team.2) == true
    
    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.25)


rule "CADAVER (ANA) DETONATION":
    @Event eachPlayer
    @Team 2
    @Hero ana
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    #Scaled
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 2.75 * eventPlayer.size
    
    waitUntil(not eventPlayer.isMeleeing(), 99999)
    if not ruleCondition:
        return
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.VIOLET, eventPlayer, 0.5 * eventPlayer.size)
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
    abilityThrowdown()
    wait(0.1)
    kill(eventPlayer)


rule "ENSNARER (HAZARD) BLOCKS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition (eventPlayer in bosses or not eventPlayer.abilityArray1) == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition eventPlayer.botTempvalue2 != true
    
    if eventPlayer in bosses:
        eventPlayer.disallowButton(Button.MELEE)
        eventPlayer.specialFacing = true
        eventPlayer.botTempValue = true
        entityFloat()
        for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.botSpecialPotentialTargets)):
            eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialPotentialTargets[eventPlayer.pForceFieldCount2_bCount1].getPosition()) + vect(0, -0.3, 0), 10000)
            eventPlayer.cancelPrimaryAction()
            wait(0.1)
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            wait(0.5)
            if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
        eventPlayer.specialFacing = false
        restoreDefaultFacingMovement()
        eventPlayer.botTempValue = false
        eventPlayer.allowButton(Button.MELEE)
        wait(8)
    else:
        eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, -0.3, 0), 999)
        wait(0.25)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        eventPlayer.abilityArray1 += 7
        restoreDefaultFacingMovement()


rule "ENSNARER LUNGE":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 30
    @Condition eventPlayer.botTarget.getSpeed() >= 10
    @Condition eventPlayer.botTempvalue2 != true
    @Condition eventPlayer.botTempValue != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(1)


rule "SMOLDER (WINSTON) SEES PLAYER":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == 0
    @Condition (eventPlayer.botTarget.isInViewAngle(eventPlayer.getPosition(), 55) or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 9 * eventPlayer.size) == true
    @Condition eventPlayer in bosses != true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.CROUCH)
    eventPlayer.movementSpeed *= 0.1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    eventPlayer.botTempValue = 1
    #Death timer
    chaseOverTime(eventPlayer.chase1, 0, 6, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.botTempValue == 2 or eventPlayer.chase1 <= 0, 99999)
    if eventPlayer.botTempValue == 2:
        return
    stopChasing(eventPlayer.chase1)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, eventPlayer, 50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer, 1.5 * eventPlayer.size)
    wait(0.25)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    kill(eventPlayer)


rule "SMOLDER ACTIVATES FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Hero winston
    @Condition eventPlayer in bosses != true
    @Condition eventPlayer.botTempValue == 1
    @Condition eventPlayer.crowdControlled != true
    
    eventPlayer.botTempValue = 2
    stopChasing(eventPlayer.chase1)
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), attacker.getEyePosition()), 9999)
    eventPlayer.lastTarget = attacker
    eventPlayer.botTarget = attacker
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1.5 * eventPlayer.size)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.size *= 1.5
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.movementSpeed *= 9
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    wait(0.25)
    restoreDefaultFacingMovement()
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "SMOLDER BOSS SLAM":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTempValue == 0
    @Condition gameSmolderEvent != true
    @Condition eventPlayer.lastTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.5)
    eventPlayer.startFacing(eventPlayer.getFacingDirection() + Vector.UP, 300)
    wait(0.6)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 0.25)
    if eventPlayer.isUsingAbility1() == true:
        restoreDefaultFacingMovement()
        eventPlayer.botTempValue = 1
        eventPlayer.enableEnvironmentCollision()
        waitUntil(not eventPlayer.isUsingAbility1(), 1)
        if not eventPlayer.crowdControlled and not eventPlayer.hasStatus(Status.HACKED):
            eventPlayer.applyImpulse(Vector.DOWN, 4, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            waitUntil(eventPlayer.isOnGround(), 2)
    wait(0.25)
    eventPlayer.botTempValue = 0
    wait(4)


rule "SMOLDER SUPER SLAM":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTempValue != 0
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 7.5 * eventPlayer.size)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.getPosition(), 100)
    eventPlayer.botSpecialPotentialTargets = playerTargetList.concat(getLivingPlayers(Team.2)).exclude(eventPlayer).filter(lambda x: not x.hasStatus(Status.PHASED_OUT) and distance(eventPlayer.getPosition(), x.getPosition()) < 7.5 * eventPlayer.size and isInLoS(eventPlayer.getPosition() + vect(0, losHeightCheck, 0), x.getPosition() + vect(0, losHeightCheck, 0)))
    (eventPlayer.botSpecialPotentialTargets.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 5 * eventPlayer.size and isInLoS(eventPlayer.getPosition() + vect(0, losHeightCheck, 0), x.getPosition() + vect(0, losHeightCheck, 0), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 0.35)
    for eventPlayer.pForceFieldCount2_bCount1 in range(len(eventPlayer.botSpecialPotentialTargets)):
        eventPlayer.botSpecialTarget = eventPlayer.botSpecialPotentialTargets[eventPlayer.pForceFieldCount2_bCount1]
        eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), -25), (15 if distance(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition()) < 5 * eventPlayer.size else 7.5) * eventPlayer.size, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT":
    @Event eachPlayer
    @Condition gameSmolderEvent == true
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition (eventPlayer in bosses or eventPlayer.botTempValue == 2) == true
    
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(0.5)
    if ruleCondition:
        loop()


rule "SMOLDER BOSS EVENT STARTS":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.botTarget != null
    
    wait(4)
    gameSmolderEvent = false
    (getPlayers(Team.2).filter(lambda player: player.getHero() == Hero.WINSTON)).setUltCharge(100)
    while not eventPlayer.isUsingUltimate():
        eventPlayer.clearStatusEffect(Status.HACKED)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(0.5)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    gameSmolderEvent = true
    kill(getPlayers(Team.2).filter(lambda player: player.getHero() != Hero.WINSTON), eventPlayer)
    wait(25)
    gameSmolderEvent = false
    wait(16)
    if ruleCondition:
        loop()


rule "SMOLDER ACTIVATED FROM BOSS EVENT":
    @Event eachPlayer
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTempValue == 1
    @Condition gameSmolderEvent == true
    @Condition eventPlayer in bosses != true
    
    smolderEnraged()


def smolderEnraged():
    @Name "smolderEnraged"
    
    eventPlayer.botTempValue = 2
    stopChasing(eventPlayer.chase1)
    eventPlayer.stopForcingButton(Button.CROUCH)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1.5 * eventPlayer.size)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.size *= 1.5
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.movementSpeed *= 9
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    wait(5)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "PROTECTOR (KIRIKO) USES CLEANSE":
    @Event eachPlayer
    @Team 2
    @Hero kiriko
    @Condition eventPlayer in miniBoss == true
    @Condition (getPlayersInRadius(eventPlayer, 5, Team.2, LosCheck.SURFACES_AND_ENEMY_BARRIERS).any(lambda player: player.crowdControlled or player.hasStatus(Status.HACKED) or player.getNormalizedHealth() < 0.5)) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    abilityThrowdown()
    wait(5)


rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE":
    @Event eachPlayer
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isUsingUltimate() == true
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(10)


rule "SUCCESSOR PUNCHES IN RETALIATION":
    @Event playerTookDamage
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(1)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 30 * eventPlayer.size
    @Condition eventPlayer in miniBoss == true
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.JUNKER_QUEEN, Hero.KIRIKO, Hero.DOOMFIST, Hero.HAZARD] == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 2.5)
    wait(0.4)
    eventPlayer.specialFacing = true
    eventPlayer.stopFacing()
    eventPlayer.setUltCharge(100)
    if eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.abilityArray1 += 4
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE if eventPlayer.getHero() == Hero.JUNKER_QUEEN or eventPlayer.getHero() == Hero.KIRIKO else Button.ABILITY_1)
    eventPlayer.specialFacing = false
    restoreDefaultFacingMovement()
    eventPlayer.applyImpulse(vect(0, 2.5 if eventPlayer.getHero() in [Hero.DOOMFIST, Hero.HAZARD] else 0, 0), 5 if eventPlayer.getHero() == Hero.HAZARD else 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isDead(), 15 if eventPlayer.getHero() == Hero.DOOMFIST else 30)
    eventPlayer.setUltCharge(0)


rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in miniBoss == true
    @Condition (distance(eventPlayer, objectivePositions[0]) <= objectiveRad or len(objectivePositions) == 1 and eventPlayer.isOnObjective()) == true
    @Condition eventPlayer.getHero() in [Hero.DOOMFIST, Hero.WRECKING_BALL, Hero.MAUGA] == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setUltCharge(100)
    wait(0.15)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    if not eventPlayer.isUsingUltimate():
        loop()
    if eventPlayer.getHero() == Hero.MAUGA and eventPlayer.isUsingUltimate():
        eventPlayer.setMaxHealth(30)
        wait(1)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    if eventPlayer.getHero() == Hero.DOOMFIST and eventPlayer.isUsingUltimate():
        startRule(selectTarget, StartRuleBehavior.NOOP)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(false)
        waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(true)
    if eventPlayer.getHero() == Hero.MAUGA:
        waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.setMaxHealth(1)
    wait(30)


rule "============================================== SUPPLY DROPS ====================================================":
    @Disabled
    @Delimiter
    


rule "GENERATE SUPPLY DROPS":
    #Only activates if last supply drop has been opened
    @Condition supplyDropStatus == true
    #Waits for all objectives to be determined before activating
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    #Limited to 12 power ups on the ground at a time
    @Condition len(powerUpPositions) < 12
    
    #Standard 30 second wait
    wait(30)
    supplyDropLanding = null
    supplyDropPosition = null
    supplyDropStatus = false
    #Wait standard minimum 30 seconds + a random 30 to 90 extra seconds. Total resulting wait time is 2 to 2.5 minutes.
    wait(random.uniform(1.5, 2) * 60)
    while supplyDropLanding == null:
        #Find the closest player to the objective
        closestPlayerToObjective = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositions[0]))[0]
        testPos = random.choice(mapGrid.filter(lambda x: distance(closestPlayerToObjective.getPosition(), x) < 35 and distance(closestPlayerToObjective.getPosition(), x) > 20))
        if playerTargetList.all(lambda x: distance(testPos, x.getPosition()) > 20):
            #Sets supply drop location
            supplyDropLanding = testPos
            #Sets supply drop location to be placed on ground (in the case that a walkable position is underground for some reason)
            supplyDropLanding = raycastHitPosition(supplyDropLanding + vect(0, 2, 0), supplyDropLanding + vect(0, 0, 0), getAllPlayers(), getAllPlayers(), false)
        wait(0.25)
    supplyDropPosition = supplyDropLanding + vect(0, 200, 0)
    chaseOverTime(supplyDropPosition, supplyDropLanding, 15)
    bigMessage(getPlayers(Team.1), "Supply drop incoming!")
    waitUntil(supplyDropPosition == supplyDropLanding, 99999)
    stopChasing(supplyDropPosition)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, supplyDropLanding, 4)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, supplyDropLanding, 50)
    wait(10, Wait.RESTART_WHEN_TRUE)
    if len(powerUpPositions) < 12:
        loop()


rule "EFFECT/TEXT (GLOBAL)":
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    
    #Closed supply drop orb
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and not supplyDropStatus), Effect.ORB, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Falling supply drop aura
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and supplyDropPosition != null and distance(supplyDropLanding, supplyDropPosition) > 1), Effect.BAD_AURA, Color.AQUA, supplyDropPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop sphere
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null and supplyDropStatus), Effect.SPHERE, Color.AQUA, supplyDropPosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Supply drop landing ring
    createEffect(getAllPlayers().filter(lambda _: supplyDropLanding != null), Effect.RING, Color.AQUA, supplyDropLanding, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Open supply drop text
    createInWorldText(getLivingPlayers(Team.1).filter(lambda player: supplyDropLanding != null and distance(supplyDropLanding, supplyDropPosition) < 1 and not supplyDropStatus and distance(player.getPosition(), supplyDropLanding) <= 6 and distance(supplyDropLanding, player.getEyePosition() + player.getFacingDirection() * distance(player.getEyePosition(), supplyDropLanding)) < 0.5), "[{0}]".format(inputBindingString(Button.INTERACT)), supplyDropPosition + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    #Pick up power up text
    createInWorldText(localPlayer if len(powerUpPositions.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6)) else null, "[{0}]".format(inputBindingString(Button.INTERACT)), vect(0, 0.5, 0) + ((sorted(powerUpPositions.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x))))[0]), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    #Supply drop landing icon
    createIcon(getAllPlayers().filter(lambda player: supplyDropLanding != null and distance(player.getPosition(), supplyDropPosition) > 5), supplyDropPosition + vect(0, 1, 0), Icon.PLUS, IconReeval.VISIBILITY_AND_POSITION, Color.AQUA)
    #Supply drop distance
    createInWorldText(getAllPlayers().filter(lambda player: supplyDropLanding != null and distance(player.getPosition(), supplyDropPosition) > 5), "Supply Drop: {0}m".format(distance(localPlayer.getPosition(), supplyDropPosition)), supplyDropPosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.NEVER)


rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition gameStatus == true
    @Condition eventPlayer.isDummy() == false
    
    if distance(supplyDropLanding, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), supplyDropLanding)) < 0.5 and not supplyDropStatus and distance(eventPlayer.getPosition(), supplyDropLanding) <= 6 and supplyDropLanding != null and distance(supplyDropLanding, supplyDropPosition) < 1:
        supplyDropStatus = true
        playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, supplyDropPosition, 0.5)
        playEffect(getPlayers(Team.1), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, supplyDropPosition, 50)
        #Power ups per supply drop
        for count1 in range(numberOfPowerUpsPerSupplyDrop):
            #Range of power ups
            powerUpIDs.append(random.choice(availablePowerups))
        #Spacing of power ups
        for eventPlayer.pPowerUpCount_bTeleCount in range(-60, 61, 120 / (numberOfPowerUpsPerSupplyDrop - 1)):
            powerUpPositions.append(supplyDropLanding + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(supplyDropLanding, eventPlayer.getPosition())) + eventPlayer.pPowerUpCount_bTeleCount, 0)) * 2))
    elif len(powerUpPositions) > 0 and ((len(powerUpPositions.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6))) > 0):
        #Power up effect position
        eventPlayer.powerUpTradeValues[0] = (sorted(powerUpPositions.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer.getPosition(), x) <= 6), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x))))[0]
        #Current power up (or 0 if no current power up)
        eventPlayer.powerUpTradeValues[2] = eventPlayer.currentPowerUp
        wait()
        #Index of position of current power up being aquired
        eventPlayer.powerUpTradeValues[1] = powerUpPositions.index(eventPlayer.powerUpTradeValues[0])
        wait()
        #Pick up power up
        eventPlayer.currentPowerUp = powerUpIDs[eventPlayer.powerUpTradeValues[1]]
        destroyEffect(powerUpEffect[eventPlayer.powerUpTradeValues[1]])
        destroyInWorldText(powerUpText[eventPlayer.powerUpTradeValues[1]])
        wait()
        del powerUpIDs[eventPlayer.powerUpTradeValues[1]]
        del powerUpPositions[eventPlayer.powerUpTradeValues[1]]
        del powerUpEffect[eventPlayer.powerUpTradeValues[1]]
        del powerUpText[eventPlayer.powerUpTradeValues[1]]
        wait()
        #Trade power ups. Ignore if no power up is currently held.
        if eventPlayer.powerUpTradeValues[2] != 0:
            powerUpIDs.append(eventPlayer.powerUpTradeValues[2])
            powerUpPositions.append(eventPlayer.powerUpTradeValues[0])
    elif eventPlayer.currentPowerUp != 0:
        wait(0.25, Wait.ABORT_WHEN_FALSE)
        powerUpUsage()


rule "============================================== POWER UPS ====================================================":
    @Disabled
    @Delimiter
    


rule "POWER UP EFFECT/TEXT MANAGEMENT":
    @Condition gameStatus == true
    @Condition len(powerUpPositions) > len(powerUpEffect)
    @Condition len(availablePowerups) > 0
    
    powerUpAssignment()
    powerUpEffect.append(getLastCreatedEntity())
    powerUpText.append(getLastCreatedText())
    if ruleCondition:
        loop()


rule "EFFECT/TEXT (PERMANENT)":
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    
    #Cure hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 1), "CURE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to stop all damage over time and cure yourself".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Revive hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 2), "REVIVE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Look at a teammate and hold [{0}] to revive them".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Force field hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 3), "Force Field", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a force field".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #No cooldowns hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 4), "No Cooldowns", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to get fast cooldowns".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Air strike hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 5), "Air Strike", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to call in an air strike".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Heal beacon hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 6), "Beacon of Healing", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a healing beacon and gain bonus healing".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Vaccine hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 7), "VACCINE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to increase your resistance to infection".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Sentry turret hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 8), "Sentry Turret", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a sentry turret".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Cloaking Device hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 9), "Cloaking Device", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to become invisible to enemies".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Super Nano hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 10), "Super Nano", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to increase your damage and speed".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Bounce Pad hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 11), "Bounce Pad", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a bounce pad".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Ultimate Charger hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 12), "Ultimate Charger", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to rapidly charge your ultimate".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Stun hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 13), "Stun", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to stun nearby enemies".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "PLAYER DROPS POWER UP (MANUAL)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition gameStatus == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.currentPowerUp != 0
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0) if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)


rule "PLAYER DROPS POWER UP (DEATH)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.currentPowerUp != 0
    
    while not eventPlayer.isOnGround():
        wait(0.25)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)


def instantRevive():
    @Name "instantRevive (0-9)"
    
    eventPlayer.interactEntity = (sorted(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= reviveRadius), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getPosition()))))[0]
    wait()
    eventPlayer.interactEntity.setStatusEffect(null, Status.INVINCIBLE, 5)
    eventPlayer.interactEntity.resurrect()
    waitUntil(eventPlayer.interactEntity.isAlive(), 3)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    smallMessage([eventPlayer, eventPlayer.interactEntity], "{0} {1}: \"I've got you. Now let's move!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))


def playerForceField():
    @Name "playerForceField (10-19)"
    
    eventPlayer.powerUpUsePositionsAndInfo[10] = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEffects[10]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 7.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[10] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Force Field: {0}s".format(ceil(eventPlayer.pForceFieldCount1)), HudPosition.RIGHT, 0.2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[11] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[10], 50)
    #Force field duration
    for eventPlayer.pForceFieldCount1 in range(10, 0, -0.032):
        for eventPlayer.pForceFieldCount2_bCount1 in range(getNumberOfLivingPlayers(Team.2)):
            if distance(getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1], eventPlayer.powerUpUsePositionsAndInfo[10]) <= 7.5:
                getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1].applyImpulse(directionTowards(eventPlayer.powerUpUsePositionsAndInfo[10], getLivingPlayers(Team.2)[eventPlayer.pForceFieldCount2_bCount1].getPosition()), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpEffects[10])
    destroyHudText(eventPlayer.powerUpEffects[11])
    eventPlayer.powerUpUsePositionsAndInfo[10] = 0


def noCooldowns():
    @Name "noCooldowns (20-29)"
    
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer, 50)
    if eventPlayer.powerUpEffects[20] == 0:
        hudHeader(eventPlayer, "No Cooldowns: {0}s".format(ceil(eventPlayer.pNoCooldownsCount_bCount2)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[20] = getLastCreatedText()
    #No cooldown powerup duration
    for eventPlayer.pNoCooldownsCount_bCount2 in range(15, 0, -0.032):
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.INTERACT, 0)
        eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
        eventPlayer.setAbilityCooldown(Button.JUMP, 0)
        eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
        if eventPlayer.getHero() == Hero.REAPER:
            goto lbl_0
        eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
        lbl_0:
        eventPlayer.setAbilityCharge(Button.SECONDARY_FIRE, 2)
        eventPlayer.setAbilityCooldown(Button.RELOAD, 0)
        wait(0.032)
    destroyHudText(eventPlayer.powerUpEffects[20])
    eventPlayer.powerUpEffects[20] = 0


def airStrike():
    @Name "airStrike (30-39)"
    
    wait()
    smallMessage(getAllPlayers(), "{0} {1}: \"I've called in an air strike!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    #Air Strike Location
    eventPlayer.powerUpUsePositionsAndInfo[30] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 40, null, getAllPlayers(), false)
    eventPlayer.pAirStrikeCount = 0
    if eventPlayer.powerUpEffects[30] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer.powerUpUsePositionsAndInfo[30], 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[30] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, eventPlayer.powerUpUsePositionsAndInfo[30], 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[31] = getLastCreatedEntity()
    wait(2)
    #Count up to max radius. Number of explosions = Max radius / step size
    for eventPlayer.pAirStrikeCount in range(50):
        #Random position in ring
        eventPlayer.powerUpUsePositionsAndInfo[31] = eventPlayer.powerUpUsePositionsAndInfo[30] + vect(0, 5, 0) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(0, 10)
        #Ray Cast downwards
        eventPlayer.powerUpUsePositionsAndInfo[31] = raycastHitPosition(eventPlayer.powerUpUsePositionsAndInfo[31], eventPlayer.powerUpUsePositionsAndInfo[31] + vect(0, -25, 0), null, getAllPlayers(), false)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 2.5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 100)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[31], 100)
        eventPlayer.powerUpUsePositionsAndInfo[32] = getPlayers(Team.2).filter(lambda player: distance(player.getPosition(), eventPlayer.powerUpUsePositionsAndInfo[31]) < 5)
        damage(eventPlayer.powerUpUsePositionsAndInfo[32], eventPlayer, 150)
        eventPlayer.powerUpUsePositionsAndInfo[32].reviveTimer = 10
        wait(0.125)
    destroyEffect(eventPlayer.powerUpEffects[30])
    destroyEffect(eventPlayer.powerUpEffects[31])
    eventPlayer.powerUpEffects[30] = 0


def healBeacon():
    @Name "beaconofHealing (40-49)"
    
    eventPlayer.powerUpUsePositionsAndInfo[40] = eventPlayer.getPosition()
    if not entityExists(eventPlayer.powerUpEffects[40]):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40] + vect(0, -2, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[40] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40], 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[41] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Beacon of Healing: {0}s".format(ceil(eventPlayer.pHealBeaconCount)), HudPosition.RIGHT, 0.2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[42] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.9, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[43] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40], 10)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[40], 50)
    eventPlayer.setHealingDealt(150)
    #Heal Beacon duration
    for eventPlayer.pHealBeaconCount in range(30, 0, -1):
        wait(1)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpUsePositionsAndInfo[40] + vect(0, 1, 0), 0.1)
        getPlayersInRadius(eventPlayer.powerUpUsePositionsAndInfo[40], 10, eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 2, 30)
    destroyEffect(eventPlayer.powerUpEffects[40])
    destroyEffect(eventPlayer.powerUpEffects[41])
    destroyHudText(eventPlayer.powerUpEffects[42])
    destroyEffect(eventPlayer.powerUpEffects[43])
    eventPlayer.setHealingDealt(100)
    eventPlayer.powerUpUsePositionsAndInfo[40] = 0


def sentryTurret():
    @Name "sentryTurret (50-59)"
    
    eventPlayer.powerUpUsePositionsAndInfo[50] = eventPlayer.getPosition() + Vector.UP if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()) + Vector.UP
    if not entityExists(eventPlayer.powerUpEffects[50]):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50], 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[50] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionFromAngles(0, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[51] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionFromAngles(120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[52] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionFromAngles(240, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[53] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + (eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5 if len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player) and not player.teleporting)) else eventPlayer.getFacingDirection() * 0.5), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[54] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Sentry Turret: {0}s".format(ceil(eventPlayer.pSentryTurretCount)), HudPosition.RIGHT, 0.2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[55] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50], 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpUsePositionsAndInfo[50], 50)
    #Sentry Gun Duration
    for eventPlayer.pSentryTurretCount in range(30, 0, -0.125):
        if (len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player) and not player.teleporting))) > 0:
            eventPlayer.powerUpUsePositionsAndInfo[51] = directionTowards(eventPlayer.powerUpUsePositionsAndInfo[50], sorted(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpUsePositionsAndInfo[50], player)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0].getPosition() + vect(0, 1, 0))
            eventPlayer.powerUpUsePositionsAndInfo[52] = raycastHitPosition(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + ((directionFromAngles(random.uniform(-1, 1) + horizontalAngleOfDirection(eventPlayer.powerUpUsePositionsAndInfo[51]), random.uniform(-1, 1) + verticalAngleOfDirection(eventPlayer.powerUpUsePositionsAndInfo[51]))) * 100), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50] + eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5, 25)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[50] + eventPlayer.powerUpUsePositionsAndInfo[51] * 0.5, 0.1)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpUsePositionsAndInfo[52], 0.1)
            damage(raycastHitPlayer(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[50] + directionTowards(eventPlayer.powerUpUsePositionsAndInfo[50], eventPlayer.powerUpUsePositionsAndInfo[52]) * 100, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true), eventPlayer, 20)
        wait(0.125)
    destroyEffect(eventPlayer.powerUpEffects[50])
    destroyEffect(eventPlayer.powerUpEffects[51])
    destroyEffect(eventPlayer.powerUpEffects[52])
    destroyEffect(eventPlayer.powerUpEffects[53])
    destroyEffect(eventPlayer.powerUpEffects[54])
    destroyHudText(eventPlayer.powerUpEffects[55])
    eventPlayer.powerUpUsePositionsAndInfo[50] = 0


def cloakingDevice():
    @Name "cloakingDevice (60-69)"
    
    if eventPlayer.powerUpEffects[60] == 0:
        eventPlayer.movementSpeed *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[60] = getLastCreatedEntity()
        hudText(eventPlayer, "Cloaking Device: {0}s".format(ceil(eventPlayer.pCloakingDeviceCount)), null, "Cancel (Press [{0}] + [{1}])".format(inputBindingString(Button.CROUCH), inputBindingString(Button.INTERACT)) if eventPlayer.pCloakingDeviceCount < 23 else [], HudPosition.RIGHT, 0.2, Color.BLUE, null, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[61] = getLastCreatedText()
        eventPlayer.invisible++
    if not eventPlayer.invisible:
        smallMessage(eventPlayer, "Cloaking activated. You are now invisible.")
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.getPosition(), 50)
    #Cloaking Duration
    for eventPlayer.pCloakingDeviceCount in range(25, 0, -1):
        if eventPlayer.pCloakingDeviceCount < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT):
            smallMessage(eventPlayer, "Cloaking deactivated")
            break
        if eventPlayer.isDead():
            break
        waitUntil(eventPlayer.pCloakingDeviceCount < 23 and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT), 1)
    eventPlayer.invisible--
    destroyEffect(eventPlayer.powerUpEffects[60])
    destroyHudText(eventPlayer.powerUpEffects[61])
    eventPlayer.powerUpEffects[60] = 0
    if not eventPlayer.invisible:
        smallMessage(eventPlayer, "You are now visible")
    eventPlayer.movementSpeed /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


def superNano():
    @Name "superNano (70-79)"
    
    if eventPlayer.powerUpEffects[70] == 0:
        eventPlayer.movementSpeed *= 1.5
        eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.RED, eventPlayer, distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[70] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Super Nano: {0}s".format(ceil(eventPlayer.pSuperNanoCount)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[71] = getLastCreatedText()
        createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[72] = getLastCreatedEntity()
        startDamageModification(getPlayers(Team.2), eventPlayer, 200)
        eventPlayer.powerUpEffects[73] = getLastDamageModification()
        startDamageModification(eventPlayer, getAllPlayers(), 50)
        eventPlayer.powerUpEffects[74] = getLastDamageModification()
    heal(eventPlayer, null, 100)
    eventPlayer.setDamageReceived(50)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.getPosition(), distance(eventPlayer.getEyePosition(), eventPlayer.getPosition()) * 0.95)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    for eventPlayer.pSuperNanoCount in range(20, 0, -1):
        if eventPlayer.isDead():
            break
        wait(1)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEffects[70])
    destroyHudText(eventPlayer.powerUpEffects[71])
    destroyEffect(eventPlayer.powerUpEffects[72])
    stopDamageModification(eventPlayer.powerUpEffects[73])
    stopDamageModification(eventPlayer.powerUpEffects[74])
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.powerUpEffects[70] = 0
    eventPlayer.movementSpeed /= 1.5
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)


def bouncePad():
    @Name "bouncePad (80-89)"
    
    eventPlayer.powerUpUsePositionsAndInfo[80] = eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())
    if eventPlayer.powerUpEffects[80] == 0:
        createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[80] = getLastCreatedEntity()
        hudHeader(eventPlayer, "Bounce Pad: {0}s".format(ceil(eventPlayer.pBouncePadCount1)), HudPosition.RIGHT, 0.2, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[81] = getLastCreatedText()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80], 50)
    wait(1)
    #Bounce pad duration
    for eventPlayer.pBouncePadCount1 in range(60, 0, -0.125):
        if eventPlayer.pBouncePadCount1 % 0.25 == 0:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.powerUpUsePositionsAndInfo[80] + vect(0, 0.125, 0), 4)
        #Determine which players are on the bounce pad
        eventPlayer.powerUpUsePositionsAndInfo[81] = getLivingPlayers(Team.1).filter(lambda player: distance(eventPlayer.powerUpUsePositionsAndInfo[80], player.getPosition()) < 2 and player.isOnGround())
        if len(eventPlayer.powerUpUsePositionsAndInfo[81]) > 0:
            #For each bouncer
            for eventPlayer.pBouncePadCount2 in range(len(eventPlayer.powerUpUsePositionsAndInfo[81])):
                #Current bouncer
                eventPlayer.bouncePadBouncer = eventPlayer.powerUpUsePositionsAndInfo[81][eventPlayer.pBouncePadCount2]
                eventPlayer.bouncePadBouncer.applyImpulse(vect(0, 1, 0), 22, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            playEffect(eventPlayer.powerUpUsePositionsAndInfo[81], DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[80], 50)
        wait(0.125)
    wait(0.25)
    destroyEffect(eventPlayer.powerUpEffects[80])
    destroyHudText(eventPlayer.powerUpEffects[81])
    eventPlayer.powerUpEffects[80] = 0


def ultimateCharger():
    @Name "ultimateCharger (90-99)"
    
    if eventPlayer.powerUpEffects[90] == 0:
        hudHeader(eventPlayer, "Ultimate Charger: {0}s".format(ceil(eventPlayer.pUltimateChargerCount)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.powerUpEffects[90] = getLastCreatedText()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    #Bounce pad duration
    for eventPlayer.pUltimateChargerCount in range(20, 0, -0.125):
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 2)
        wait(0.125)
    wait(0.25)
    destroyHudText(eventPlayer.powerUpEffects[90])
    eventPlayer.powerUpEffects[90] = 0


def stun():
    @Name "stun (100-109)"
    
    if eventPlayer.powerUpEffects[100] == 0:
        #Stun beam effect
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer.pStunChase1, eventPlayer.pStunChase1 + ((directionTowards(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[100].getPosition() + vect(0, losHeightCheck, 0))) * (min(3, distance(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[100].getPosition() + vect(0, losHeightCheck, 0))))), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEffects[100] = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 30)
    #Stun beam lead
    eventPlayer.pStunChase1 = eventPlayer.getPosition() + vect(0, losHeightCheck, 0)
    #Stun origin player
    eventPlayer.powerUpUsePositionsAndInfo[100] = eventPlayer
    #Stun Target
    eventPlayer.powerUpUsePositionsAndInfo[101] = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.size), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
    chaseAtRate(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition() + vect(0, losHeightCheck, 0), 50)
    #Number of bounces
    for eventPlayer.pStunCount in range(50, 0, -1):
        if eventPlayer.powerUpUsePositionsAndInfo[101] == null:
            if eventPlayer.pStunCount > 13 and not eventPlayer.powerUpUsePositionsAndInfo[100] in bosses:
                eventPlayer.powerUpUsePositionsAndInfo[100].setStatusEffect(eventPlayer, Status.STUNNED, eventPlayer.pStunCount / 8.3)
            break
        waitUntil(distance(eventPlayer.pStunChase1, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition() + vect(0, losHeightCheck, 0)) < 0.1, 3)
        eventPlayer.powerUpUsePositionsAndInfo[101].setStatusEffect(eventPlayer, Status.STUNNED, 0.5 if eventPlayer.powerUpUsePositionsAndInfo[101] in bosses else 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[101], 0.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.powerUpUsePositionsAndInfo[101].getPosition(), 50)
        wait()
        #Previous target is new origin
        eventPlayer.powerUpUsePositionsAndInfo[100] = eventPlayer.powerUpUsePositionsAndInfo[101]
        #Set next target
        eventPlayer.powerUpUsePositionsAndInfo[101] = random.choice((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpUsePositionsAndInfo[100].getPosition(), player.getPosition()) < 15 and not player.teleporting)).exclude(eventPlayer.powerUpUsePositionsAndInfo[101]))
    stopChasing(eventPlayer.pStunChase1)
    destroyEffect(eventPlayer.powerUpEffects[100])
    eventPlayer.powerUpEffects[100] = 0


def powerUpAssignment():
    @Name "powerUpAssignment"
    
    #Cure
    if powerUpIDs[len(powerUpEffect)] == 1:
        createEffect(getAllPlayers(), Effect.ORB, Color.GREEN, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "CURE", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Instant Revive
    elif powerUpIDs[len(powerUpEffect)] == 2:
        createEffect(getAllPlayers(), Effect.ORB, Color.YELLOW, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Revive", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Force Field
    elif powerUpIDs[len(powerUpEffect)] == 3:
        createEffect(getAllPlayers(), Effect.ORB, Color.BLUE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Force Field", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #No Cooldowns
    elif powerUpIDs[len(powerUpEffect)] == 4:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "No Cooldowns", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Air Strike
    elif powerUpIDs[len(powerUpEffect)] == 5:
        createEffect(getAllPlayers(), Effect.ORB, Color.ORANGE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Air Strike", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Beacon of Healing
    elif powerUpIDs[len(powerUpEffect)] == 6:
        createEffect(getAllPlayers(), Effect.ORB, Color.YELLOW, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Beacon of Healing", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Vaccine
    elif powerUpIDs[len(powerUpEffect)] == 7:
        createEffect(getAllPlayers(), Effect.ORB, Color.GREEN, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Vaccine", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Sentry Turret
    elif powerUpIDs[len(powerUpEffect)] == 8:
        createEffect(getAllPlayers(), Effect.ORB, Color.ORANGE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Sentry Turret", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Cloaking Device
    elif powerUpIDs[len(powerUpEffect)] == 9:
        createEffect(getAllPlayers(), Effect.ORB, Color.BLUE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Cloaking Device", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Super Nano
    elif powerUpIDs[len(powerUpEffect)] == 10:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Super Nano", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Bounce pad
    elif powerUpIDs[len(powerUpEffect)] == 11:
        createEffect(getAllPlayers(), Effect.ORB, Color.PURPLE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Bounce Pad", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Ultimate Charger
    elif powerUpIDs[len(powerUpEffect)] == 12:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Ultimate Charger", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Stun
    elif powerUpIDs[len(powerUpEffect)] == 13:
        createEffect(getAllPlayers(), Effect.ORB, Color.WHITE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Stun", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)


def powerUpUsage():
    @Name "powerUpUsage"
    
    #Cure
    if eventPlayer.currentPowerUp == 1:
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 1)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
        if eventPlayer.infectionLvl > 0:
            eventPlayer.infected = false
            eventPlayer.infectionLvl = 0
        eventPlayer.startHealingOverTime(eventPlayer, 5, 20)
        smallMessage(eventPlayer, "You are cured!")
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
    #Instant Revive
    elif eventPlayer.currentPowerUp == 2:
        if len(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) <= reviveRadius)) == 0:
            return
        startRule(instantRevive)
    #Force Field
    elif eventPlayer.currentPowerUp == 3:
        startRule(playerForceField)
    #No Cooldowns
    elif eventPlayer.currentPowerUp == 4:
        startRule(noCooldowns)
    #Air Strike
    elif eventPlayer.currentPowerUp == 5:
        if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 41, null, getAllPlayers(), false)) > 40:
            smallMessage(eventPlayer, "Aim at a surface to call in an aistrike")
            return
        startRule(airStrike)
    #Beacon of Healing
    elif eventPlayer.currentPowerUp == 6:
        startRule(healBeacon)
    #Vaccine
    elif eventPlayer.currentPowerUp == 7:
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, eventPlayer, 6)
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)
        smallMessage(eventPlayer, "Your infection is reduced!")
        getPlayersInRadius(eventPlayer, 3, Team.1, LosCheck.SURFACES).infectionLvl -= 1.5
    #Sentry Turret
    elif eventPlayer.currentPowerUp == 8:
        startRule(sentryTurret)
    #Cloaking Device
    elif eventPlayer.currentPowerUp == 9:
        startRule(cloakingDevice)
    #Super Nano
    elif eventPlayer.currentPowerUp == 10:
        startRule(superNano)
    #Bounce Pad
    elif eventPlayer.currentPowerUp == 11:
        startRule(bouncePad)
    #Ultimate Charger
    elif eventPlayer.currentPowerUp == 12:
        startRule(ultimateCharger)
    #Stun
    elif eventPlayer.currentPowerUp == 13:
        #Check if their are targets nearby and in view angle
        if getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).any(lambda player: distance(eventPlayer.getPosition(), player.getPosition()) < 15 * eventPlayer.size and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45):
            startRule(stun)
        else:
            smallMessage(eventPlayer, "Aim at a nearby target")
            return
    eventPlayer.currentPowerUp = 0


def enablePowerups():
    @Name "enablePowerups"
    
    availablePowerups[0] = 1
    availablePowerups[1] = 2
    availablePowerups[2] = 3
    availablePowerups[3] = 4
    availablePowerups[4] = 5
    availablePowerups[5] = 6
    availablePowerups[6] = 7
    availablePowerups[7] = 8
    availablePowerups[8] = 9
    availablePowerups[9] = 10
    availablePowerups[10] = 11
    availablePowerups[11] = 12
    availablePowerups[12] = 13


rule "============================================== ENHANCEMENTS ====================================================":
    @Disabled
    @Delimiter
    


rule "PLAYER ENHANCEMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition gameStatus == true
    @Condition eventPlayer.isDummy() != true
    @Condition eventPlayer.switchedHeroes == false
    
    if eventPlayer.enhancementValues[0] == 0:
        #Default Enhancement: Workshop Setting
        eventPlayer.enhancementValues[0] = createWorkshopSettingEnum("Enhancements", "Default Enhancement", 9, ["No Enhancement", "Kevlar", "Zombie Hybrid", "Laser Barricade", "Brain Killer", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P."])
    #Kevlar
    if eventPlayer.enhancementValues[0] == 1:
        #Enhancement Selection: Kevlar
        hudHeader(eventPlayer, "Kevlar {0}".format(iconString(Icon.STOP)), HudPosition.LEFT, 99, rgb(240, 129, 26), HudReeval.STRING)
        waitUntil(eventPlayer.initialMaxHealth != 0, 99999)
        eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
        eventPlayer.enhancementValues[1] = getLastCreatedHealthPool()
    #Zombie Hybrid
    if eventPlayer.enhancementValues[0] == 2:
        #Enhancement: Zombie Hyrbid
        hudText(eventPlayer, "Zombie Hybrid {0}".format(iconString(Icon.POISON) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLvl)) if eventPlayer.infectionLvl >= 1 and eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, Color.GRAY, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionSize = 1.25
        eventPlayer.explosionColor1 = Color.GRAY
        eventPlayer.explosionColor2 = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLvl, 0, 0.015 if eventPlayer.infectionLvl > 0 else 0)
    #Laser Barricade
    if eventPlayer.enhancementValues[0] == 3:
        #Enhancement: Laser Barricade
        hudText(eventPlayer, "Laser Barricade {0}{1}".format(iconString(Icon.DIAMOND), " {0}s".format(eventPlayer.enhancementValues[3]) if eventPlayer.enhancementValues[3] > 0 else []), " {0}HP".format(ceil(eventPlayer.enhancementChase1)) if eventPlayer.enhancementChase1 > 0 else [], "Hold [{0}] to place a barricade".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[3] <= 0 else [], HudPosition.LEFT, 99, Color.RED if eventPlayer.enhancementValues[3] > 0 else Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_STRING_AND_COLOR)
        #Barricade placement visual
        createBeam(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValues[3] <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * eventPlayer.enhancementValues[2], 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * eventPlayer.enhancementValues[2], 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade bottom
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[4] != null), Beam.BAD, eventPlayer.enhancementValues[5], eventPlayer.enhancementValues[6], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade side 1
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[5] + vect(0, eventPlayer.enhancementValues[1], 0), eventPlayer.enhancementValues[5], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade side 2
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[6], eventPlayer.enhancementValues[6] + vect(0, eventPlayer.enhancementValues[1], 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade top
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[6] + vect(0, eventPlayer.enhancementValues[1], 0), eventPlayer.enhancementValues[5] + vect(0, eventPlayer.enhancementValues[1], 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade health
        createInWorldText(getAllPlayers() if eventPlayer.enhancementChase1 > 0 else null, "{0}HP".format(ceil(eventPlayer.enhancementChase1)), eventPlayer.enhancementValues[4] + vect(0, 1, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
        #Barrier height
        eventPlayer.enhancementValues[1] = 2
        #Barrier width
        eventPlayer.enhancementValues[2] = 5
    #Brain Killer
    elif eventPlayer.enhancementValues[0] == 4:
        #Enhancement: Brain Killer
        hudHeader(eventPlayer, "Brain Killer {0}".format(iconString(Icon.SKULL)), HudPosition.LEFT, 99, Color.RED, HudReeval.STRING)
    #Pyrotechnic
    elif eventPlayer.enhancementValues[0] == 5:
        #Enhancement: Pyrotechnic
        hudHeader(eventPlayer, "Pyrotechnic {0}".format(iconString(Icon.FIRE)), HudPosition.LEFT, 99, Color.ORANGE if eventPlayer.enhancementValues[1] else Color.RED, HudReeval.STRING_AND_COLOR)
        #Pyro Active
        eventPlayer.enhancementValues[1] = true
        #Special enhancement color
        eventPlayer.enhancementValues[2] = rgb(252, 78, 3)
        #Fire Fuel
        eventPlayer.enhancementChase1 = 100
        eventPlayer.enhancementChase2 = []
    #Plague Doctor
    elif eventPlayer.enhancementValues[0] == 6:
        #Enhancement: Plague Doctor
        hudText(eventPlayer, "Plague Doctor {0}".format(iconString(Icon.PLUS)), null, "Infection Reduced: {0} lvls".format(eventPlayer.enhancementValues[1]), HudPosition.LEFT, 99, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.STRING)
        #Plague doctor does 100 + x% more healing to infected players
        startHealingModification(getPlayers(Team.1).filter(lambda player: player.infected), eventPlayer, 150, HealingReeval.RECEIVERS_AND_HEALERS)
        eventPlayer.enhancementValues[1] = 0
    #Born to Battle
    elif eventPlayer.enhancementValues[0] == 7:
        #Enhancement: Born to Battle
        hudText(eventPlayer, "Born to Battle {0}".format(iconString(Icon.BOLT)), null, iconString(Icon.CHECKMARK) if eventPlayer.enhancementValues[1] else [], HudPosition.LEFT, 99, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.STRING)
        eventPlayer.enhancementValues[1] = false
    #Charge Battery
    elif eventPlayer.enhancementValues[0] == 8:
        #Enhancement: Charge Battery
        hudText(eventPlayer, "Charge Battery {0}".format(iconString(Icon.SPIRAL) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, rgb(236, 206, 44), rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
        #Battery placement visual
        createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValues[4] <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, rgb(0, 255, 0, 204), worldVector(vect(0, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Battery ring
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[1] != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementValues[1], 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Battery sphere
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementValues[1] + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Charge battery text
        createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] <= 0 and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 6), "Charge Battery", eventPlayer.enhancementValues[1] + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
        #Charge battery progress bar
        createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] > 0 and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 6), 100 - eventPlayer.enhancementValues[2] / eventPlayer.enhancementValues[3] * 100, [], eventPlayer.enhancementValues[1] + vect(0, 0.4, 0), 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)
        eventPlayer.enhancementValues[3] = 10
    #Hitchhiker
    elif eventPlayer.enhancementValues[0] == 9:
        #Enhancement Selection: Hitchhiker
        hudText(eventPlayer, "Hitchhiker {0}".format(iconString(Icon.FLAG)), null, "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.attached else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size) else [], HudPosition.LEFT, 99, Color.PURPLE, Color.PURPLE, Color.RED if eventPlayer.attached else Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR)
        #Shared Health Bar Rider
        hudSubheader(eventPlayer.filter(lambda _: eventPlayer.attached), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementValues[1].getHero()), eventPlayer.enhancementValues[1]), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        #Shared Health Bar Runner
        hudSubheader(eventPlayer.enhancementValues[1].filter(lambda _: eventPlayer.attached), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.enhancementValues[1] = 0
        eventPlayer.enhancementValues[2] = 0
        eventPlayer.enhancementValues[1].startGrantingAssistFor(eventPlayer)
    #P.U.P.
    elif eventPlayer.enhancementValues[0] == 10:
        #Enhancement Selection: P.U.P.
        hudHeader(eventPlayer, "P.U.P. {0}".format(iconString(Icon.HAPPY)), HudPosition.LEFT, 99, Color.BLUE if eventPlayer.enhancementValues[1] == Color.SKY_BLUE and eventPlayer.enhancementChase2 > 0 else eventPlayer.enhancementValues[1], HudReeval.VISIBILITY_STRING_AND_COLOR)
        #Postion of P.U.P.
        eventPlayer.enhancementChase1 = eventPlayer.getPosition() + vect(0, 200, 0)
        #P.U.P. Default movment
        chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1) - 1))
        eventPlayer.enhancementChase2 = 0
        #P.U.P. ability cooldown
        chaseAtRate(eventPlayer.enhancementChase2, 0, 0 if eventPlayer.enhancementValues[2] else 1)
        #P.U.P. visual
        createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.enhancementValues[1], eventPlayer.enhancementChase1, 0.25)
        #P.U.P. Beam
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[2] and eventPlayer.enhancementValues[3] != null), Beam.GOOD, eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3], eventPlayer.enhancementValues[1])
        #P.U.P using beam sound
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[2]), Effect.BEACON_SOUND, Color.SKY_BLUE, eventPlayer.enhancementChase1, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Freeze aura
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[4]), Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.enhancementValues[3], eventPlayer.enhancementValues[3].size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Default color
        eventPlayer.enhancementValues[1] = Color.SKY_BLUE
        #Beam visibility
        eventPlayer.enhancementValues[2] = false
        #P.U.P. target null
        eventPlayer.enhancementValues[3] = null
        #Freeze aura visibility
        eventPlayer.enhancementValues[4] = false
    eventPlayer.enhancementValues[11] = 0
    eventPlayer.enhancementValues[12] = false


rule "ZOMBIE HYBRID":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[4] <= 0
    @Condition eventPlayer.infectionLvl >= 1
    
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamage)
    eventPlayer.infectionLvl = 0
    eventPlayer.enhancementValues[4] = 20
    while eventPlayer.enhancementValues[4] > 0:
        wait(1)
        eventPlayer.enhancementValues[4] += -1


rule "LASER BARRICADE (PLACEMENT)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.enhancementValues[0] == 3
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[3] <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 9999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    #Laser Barrier health
    eventPlayer.enhancementChase1 = 10000
    #Barrier center point
    eventPlayer.enhancementValues[4] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.enhancementValues[5] = eventPlayer.enhancementValues[4] + worldVector(vect(-0.5 * eventPlayer.enhancementValues[2], 0, 0), eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.enhancementValues[6] = eventPlayer.enhancementValues[4] + worldVector(vect(0.5 * eventPlayer.enhancementValues[2], 0, 0), eventPlayer, Transform.ROTATION)
    #Reference point 1
    eventPlayer.enhancementValues[7] = eventPlayer.enhancementValues[4] + directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    #Reference point 2
    eventPlayer.enhancementValues[8] = eventPlayer.enhancementValues[4] + directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0) * -1
    #Reference direction
    eventPlayer.enhancementValues[9] = directionTowards(eventPlayer.enhancementValues[5], eventPlayer.enhancementValues[6])
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.enhancementValues[4], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.enhancementValues[4], 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.enhancementValues[3] = 30
    while eventPlayer.enhancementValues[3] > 0:
        wait(1)
        eventPlayer.enhancementValues[3] += -1


rule "LASER BARRICADE BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 3
    #Barrier health is greater than 0
    @Condition eventPlayer.enhancementChase1 > 0
    #Horizontal distance check
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(eventPlayer.enhancementValues[4], vect(player.getPosition().x, eventPlayer.enhancementValues[4].getPosition().y, player.getPosition().z)) < 0.5 * eventPlayer.enhancementValues[2]) == true
    #If feet are below highest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getPosition().y < eventPlayer.enhancementValues[4].y + eventPlayer.enhancementValues[1]) == true
    #If eyes are above lowest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getEyePosition().y > eventPlayer.enhancementValues[4].y) == true
    #Distance from wall
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z), eventPlayer.enhancementValues[5] + eventPlayer.enhancementValues[9] * (min(eventPlayer.enhancementValues[2], abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValues[9], directionTowards(eventPlayer.enhancementValues[5], vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z)))) * distance(eventPlayer.enhancementValues[5], vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z)))))) < 1.5) == true
    
    stopChasing(eventPlayer.enhancementChase1)
    #Horizontal distance check
    eventPlayer.potentialTargets = getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementValues[4], vect(player.getPosition().x, eventPlayer.enhancementValues[4].getPosition().y, player.getPosition().z)) < 0.5 * eventPlayer.enhancementValues[2])
    #Filter feet height
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: x.getPosition().y < eventPlayer.enhancementValues[4].y + eventPlayer.enhancementValues[1])
    #Filter eye height
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: x.getEyePosition().y > eventPlayer.enhancementValues[4].y)
    #Filter distance from wall
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: distance(vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z), eventPlayer.enhancementValues[5] + eventPlayer.enhancementValues[9] * (min(eventPlayer.enhancementValues[2], abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValues[9], directionTowards(eventPlayer.enhancementValues[5], vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z)))) * distance(eventPlayer.enhancementValues[5], vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z)))))) < 1.5)
    for eventPlayer.enhancementCount1 in range(len(eventPlayer.potentialTargets)):
        eventPlayer.botTarget = eventPlayer.potentialTargets[eventPlayer.enhancementCount1]
        if not eventPlayer.botTarget.hasStatus(Status.ROOTED):
            #Damage the barricade
            eventPlayer.enhancementChase1 -= eventPlayer.botTarget.getMaxHealth() * 2.5
            eventPlayer.botTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(eventPlayer.botTarget, eventPlayer, 10)
        if eventPlayer.botTarget.getThrottle() == vect(0, 0, 0):
            #If bot is not throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[4], (sorted(eventPlayer.enhancementValues.filter(lambda _, i: i >= 7 and i <= 8), lambda x: distance(eventPlayer.botTarget.getPosition(), x)))[0])), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValues[4].y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[4], (sorted(eventPlayer.enhancementValues.filter(lambda _, i: i >= 7 and i <= 8), lambda x: angleBetweenVectors(worldVector(eventPlayer.botTarget.getThrottle(), eventPlayer.botTarget, Transform.ROTATION), directionTowards(eventPlayer.enhancementValues[4], x)))).last())), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValues[4].y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.enhancementChase1 > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.enhancementChase1 <= 0:
            eventPlayer.enhancementChase1 = 1
    chaseAtRate(eventPlayer.enhancementChase1, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()


rule "BRAIN KILLER EXTRA DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 4
    @Condition eventWasCriticalHit == true
    
    #Critical hits deal 50% more damage, 20% if vicitm is a boss
    damage(victim, eventPlayer, eventDamage * (0.2 if victim in bosses else 0.6))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, rgb(100, 14, 14), victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.size, 0.1 * victim.size)


rule "PYROTECHNIC SETS ENEMIES ON FIRE":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker.enhancementValues[0] == 5
    @Condition attacker.enhancementValues[1] == true
    @Condition victim != eventPlayer
    @Condition eventAbility != null
    @Condition distance(attacker.getPosition(), victim.getPosition()) < 15
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    attacker.enhancementChase2.append(victim)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 5
    @Condition len(eventPlayer.enhancementChase2) > 0
    
    while len(eventPlayer.enhancementChase2) > 0:
        #Zombie to burn
        eventPlayer.enhancementValues[3] = eventPlayer.enhancementChase2[0]
        if eventPlayer.enhancementValues[3].isAlive():
            #Amount of times zombie was hit in last cycle
            eventPlayer.enhancementValues[4] = min(4 * (len(eventPlayer.enhancementChase2.filter(lambda x: x == eventPlayer.enhancementValues[3]))), 30)
            if eventPlayer.enhancementValues[3] in bosses:
                eventPlayer.enhancementValues[4] /= 2
            eventPlayer.enhancementValues[3].startDamageOverTime(eventPlayer, 3, eventPlayer.enhancementValues[4])
        eventPlayer.enhancementChase2.remove(eventPlayer.enhancementValues[3])
    wait(0.5)
    if ruleCondition:
        loop()


rule "BORN TO BATTLE PLAYER EARNS ELIMINATION":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 7
    @Condition eventPlayer.enhancementValues[1] != true
    
    eventPlayer.enhancementValues[1] = true


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 7
    @Condition eventPlayer.enhancementValues[1] == true
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementValues[2] = Button.SECONDARY_FIRE
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.enhancementValues[2] = Button.ABILITY_1
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.enhancementValues[2] = Button.ABILITY_2
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.enhancementValues[2] = Button.CROUCH
    elif eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.enhancementValues[2] = Button.JUMP
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementValues[2] == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], 1)
            eventPlayer.enhancementValues[1] = false
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementValues[2] == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], 1)
            eventPlayer.enhancementValues[1] = false
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], eventPlayer.getAbilityCharge(eventPlayer.enhancementValues[2]) + 1)
    lbl_0:
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementValues[2]) > 0:
        eventPlayer.enhancementValues[1] = false
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementValues[2]) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementValues[2], 0)
        eventPlayer.enhancementValues[1] = false


rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 6
    
    if eventPlayer.infected:
        eventPlayer.infectionLvl -= eventHealing / 500
        eventPlayer.enhancementValues[1] += eventHealing / 500
    if healee.infectionLvl >= 1 and healee.enhancementValues[0] != 2:
        healee.infectionLvl -= eventHealing / 275
        eventPlayer.enhancementValues[1] += eventHealing / 275
        if healee.infectionLvl < 1:
            healee.infectionLvl -= 0.5
            eventPlayer.enhancementValues[1] += 0.5
            playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
            smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "CHARGE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementValues[0] == 8
    @Condition gameStatus == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[4] <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 9999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    eventPlayer.enhancementValues[1] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementValues[4] = 20
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementValues[1], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementValues[1], 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementValues[2] = 0
    while eventPlayer.enhancementValues[4] > 0:
        wait(1)
        eventPlayer.enhancementValues[4] += -1


rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.enhancementValues[0] == 8
    @Condition eventPlayer.enhancementValues[1] != 0
    @Condition (playerTargetList.any(lambda x: x.getUltCharge() < 100 and distance(x.getPosition(), eventPlayer.enhancementValues[1]) < 1.5 * x.size)) == true
    
    eventPlayer.interactEntity = (getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 1.5))[0]
    playEffect(eventPlayer.interactEntity, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, eventPlayer.interactEntity, 50)
    playEffect(eventPlayer.interactEntity, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementValues[1], 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.interactEntity, 1)
    eventPlayer.interactEntity.setUltCharge(eventPlayer.interactEntity.getUltCharge() + 15)
    eventPlayer.enhancementValues[2] = eventPlayer.enhancementValues[3]
    while eventPlayer.enhancementValues[2] > 0:
        wait(0.5)
        eventPlayer.enhancementValues[2] += -0.5
    if ruleCondition:
        loop()


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 9
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.attached and (not eventPlayer.hasSpawned() or not eventPlayer.enhancementValues[1].hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementValues[1].isDead() or not entityExists(eventPlayer.enhancementValues[1]) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementValues[1].hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[1].getPosition()) > 3 * eventPlayer.enhancementValues[1].size))) == true
    @Condition eventPlayer.getHero() != Hero.MEI
    
    if not eventPlayer.attached and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size):
            #Select parent
            eventPlayer.enhancementValues[1] = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.crowdControlled and distance(eventPlayer.getPosition(), x.getPosition()) < x.size * 2), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            #World Vector
            eventPlayer.enhancementValues[2] = eventPlayer.enhancementValues[1].getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[1].getPosition(), eventPlayer.getPosition())), 0) * eventPlayer.enhancementValues[1].size + vect(0, eventPlayer.enhancementValues[1].size, 0)
            #Local vector conversion
            eventPlayer.enhancementValues[2] = localVector(eventPlayer.enhancementValues[2], eventPlayer.enhancementValues[1], Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if eventPlayer.enhancementValues[2].z > 0:
                eventPlayer.enhancementValues[2] *= vect(1, 1, -1)
            eventPlayer.enhancementValues[2] += Vector.UP
            eventPlayer.attached = true
            eventPlayer.attachTo(eventPlayer.enhancementValues[1], eventPlayer.enhancementValues[2])
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementValues[1].initialMaxHealth, true, false)
            eventPlayer.enhancementValues[6] = getLastCreatedHealthPool()
            eventPlayer.enhancementValues[1].enhancementValues[13] = eventPlayer
    else:
        if entityExists(eventPlayer.enhancementValues[1]) and eventPlayer.hasSpawned() and distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[1].getPosition()) < 3 * eventPlayer.enhancementValues[1].size:
            eventPlayer.teleport(eventPlayer.enhancementValues[1].getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.enhancementValues[1].enhancementValues[13] = null
        eventPlayer.attached = false
        eventPlayer.enhancementValues[1] = 0
        removeHealthPool(eventPlayer.enhancementValues[6])
        wait(1.5)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[13] != null
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementValues[13].initialMaxHealth, true, false)
    eventPlayer.enhancementValues[14] = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.enhancementValues[13]), 99999)
    removeHealthPool(eventPlayer.enhancementValues[14])


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 9
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[1].isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.enhancementValues[1].getNormalizedHealth()) > 0.01
    
    eventPlayer.enhancementValues[3] = (abs(eventPlayer.getHealth() * eventPlayer.enhancementValues[1].getMaxHealth() - eventPlayer.enhancementValues[1].getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.enhancementValues[1].getMaxHealth())
    eventPlayer.enhancementValues[4] = sorted(eventPlayer.concat(eventPlayer.enhancementValues[1]), lambda x: x.getNormalizedHealth())[0]
    eventPlayer.enhancementValues[5] = eventPlayer.concat(eventPlayer.enhancementValues[1]).exclude(eventPlayer.enhancementValues[4])
    eventPlayer.enhancementValues[4].setHealth(eventPlayer.enhancementValues[4].getHealth() + eventPlayer.enhancementValues[3])
    eventPlayer.enhancementValues[5].setHealth(eventPlayer.enhancementValues[5].getHealth() - eventPlayer.enhancementValues[3])
    wait()
    if ruleCondition:
        loop()
    eventPlayer.enhancementValues[3] = 0


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 10
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementChase2 <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementValues[3] == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 10)) == true
    
    #Set P.U.P. target
    eventPlayer.enhancementValues[3] = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    waitUntil(eventPlayer.enhancementValues[3].isDead() or not entityExists(eventPlayer.enhancementValues[3]) or eventPlayer.enhancementValues[3].teleporting, 99999)
    stopChasing(eventPlayer.enhancementChase1)
    eventPlayer.enhancementValues[3] = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementChase1)
    #Default color
    eventPlayer.enhancementValues[1] = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValues[2] = false
    #P.U.P. target null
    eventPlayer.enhancementValues[3] = null
    #Freeze aura visibility
    eventPlayer.enhancementValues[4] = false
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    #P.U.P. Default movement
    chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1) - 1))


rule "P.U.P. CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 10
    @Condition eventPlayer.enhancementValues[3] != null
    
    #P.U.P. attack movement
    chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getEyePosition() + directionTowards(eventPlayer.enhancementValues[3].getEyePosition(), eventPlayer.enhancementChase1) * 2, (abs(distance(eventPlayer.enhancementValues[3].getEyePosition(), eventPlayer.enhancementChase1) - 2)) * 1.5)
    #Default color
    eventPlayer.enhancementValues[1] = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValues[2] = false
    #Freeze aura visibility
    eventPlayer.enhancementValues[4] = false
    waitUntil(distance(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getEyePosition()) < 5 or eventPlayer.enhancementValues[3] == null, 99999)
    #If target still exists
    if eventPlayer.enhancementValues[3] != null:
        if distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[3].getPosition()) > 6:
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.WHITE
            #Beam visibility
            eventPlayer.enhancementValues[2] = true
            #Freeze aura visibility
            eventPlayer.enhancementValues[4] = true
            wait(0.25, Wait.ABORT_WHEN_FALSE)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, eventPlayer.enhancementValues[3], 0.1)
            #Time to freeze dependent on max health of target
            wait(min(15, eventPlayer.enhancementValues[3].getMaxHealth() / 300), Wait.ABORT_WHEN_FALSE)
            #Freeze cooldown
            eventPlayer.enhancementChase2 = 2
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            while not eventPlayer.enhancementValues[3].hasStatus(Status.FROZEN):
                eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            #Freeze zombies around target for shorter time
            ((getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementValues[3].getPosition(), player.getPosition()) < 3)).exclude(eventPlayer.enhancementValues[3])).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValues[2] = false
            #Freeze aura visibility
            eventPlayer.enhancementValues[4] = false
        else:
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.RED
            #Beam visibility
            eventPlayer.enhancementValues[2] = true
            eventPlayer.enhancementValues[3].startDamageOverTime(eventPlayer, 3, 30)
            #Beam from P.U.P.
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementChase1, 0.25)
            #Beam hits P.U.P.'s target
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementValues[3], 1)
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementValues[3].applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getPosition())), min(-20, verticalAngleOfDirection(directionTowards(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getPosition())))), min(25, 4200 / eventPlayer.enhancementValues[3].getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementChase2 = 1
            wait(3, Wait.ABORT_WHEN_FALSE)
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValues[2] = false
        stopChasing(eventPlayer.enhancementChase1)
        #P.U.P. target
        eventPlayer.enhancementValues[3] = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


