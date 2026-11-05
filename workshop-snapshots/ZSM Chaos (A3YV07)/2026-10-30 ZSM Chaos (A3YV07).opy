settings {
    "main": {
        "description": "[Original Creator: Mazattack#1183]\r\n[Original Game Code: MPJFR]\r\n[Modified by: Kamenrider#11346]\r n [LemonGranted#3739]\nworkshop.codes/A3YV07\n\r\nA Zombie Survival Mission Mode but each hero has their own Mod . \r\n\nGet to the extraction point and watch the map get nuked. Don't leave anyone behind! \r\n\rZombie Survival Chaos Discord: https://discord.gg/HvXnBK3M",
        "modeName": "Zombie Survival Missions Chaos"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "spectatorSlots": 7,
        "team1Slots": 5,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "assault": {
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ctf": {
            "disabledMaps": [
                "busanSanctuaryLny",
                "lijiangControlCenterLny",
                "oasisCityCenter",
                "oasisGardens",
                "oasisUniversity"
            ],
            "enableHeroSwitching": false,
            "enableDropFlagOnDmg": true,
            "enablePerks": true,
            "flagCarrierAbilities": "all",
            "flagDroppedLockTime": 10,
            "flagPickupTime": 5,
            "flagReturnTime": 0,
            "flagScoreRespawnTime": 20,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        " Clash 6v6": {
            "enabled": false,
            "captureSpeed%": 45
        },
        "clash": {
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
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
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "controlBalancedOverwatch": {
            "enabled": false,
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "elimination": {
            "enabled": false,
            "Allow Hero Switching": "Disabled",
            "enableTiebreaker": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false
        },
        "escort": {
            "disabledMaps": [
                "grimsvotn"
            ],
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escortBalancedOverwatch": {
            "enabled": false,
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "flashpoint": {
            "disabledMaps": [
                "newJunkCity"
            ],
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "scoreToWin": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybrid": {
            "disabledMaps": [
                "eichenwalde",
                "kingsRow",
                "neonJunction",
                "paraiso"
            ],
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybridBalancedOverwatch": {
            "enabled": false,
            "enableHeroSwitching": false,
            "captureSpeed%": 10,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "practiceRange": {
            "enabled": false,
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "push": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "pushBalancedOverwatch": {
            "enabled": false,
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "skirmish": {
            "enabled": false,
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
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
            "enableHeroSwitching": false,
            "enablePerks": true,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        }
    },
    "heroes": {
        "team1": {
            "dva": {
                "secondaryFireRechargeRate%": 500,
                "ability2Cooldown%": 50
            },
            "genji": {
                "ultDuration%": 150
            },
            "hazard": {
                "ability2Kb%": 200,
                "secondaryFireMovementSpeedPenalty%": 25,
                "secondaryFireCost%": 25
            },
            "juno": {
                "ability1Cooldown%": 50,
                "ability1Duration%": 200,
                "movementGravity%": 35
            },
            "kiriko": {
                "combatUltGen%": 150
            },
            "ramattra": {
                "ability2Cooldown%": 50
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 30,
                "ability2Cooldown%": 50
            },
            "venture": {
                "secondaryFireCooldown%": 5
            },
            "wreckingBall": {
                "secondaryFireCooldown%": 0,
                "jumpVerticalSpeed%": 175
            },
            "zarya": {
                "ammoClipSize%": 200,
                "ability1Cooldown%": 75,
                "ability2Cooldown%": 75
            }
        },
        "team2": {
            "dva": {
                "secondaryFireRechargeRate%": 500
            },
            "hazard": {
                "ability2Cooldown%": 5
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 30
            },
            "roadhog": {
                "healingDealt%": 500
            },
            "wreckingBall": {
                "secondaryFireCooldown%": 0,
                "jumpVerticalSpeed%": 150
            },
            "general": {
                "abilityCooldown%": 0,
                "passiveHealthRegen": false
            }
        },
        "allTeams": {
            "bastion": {
                "secondaryFireCooldown%": 50
            },
            "brigitte": {
                "combatUltGen%": 150,
                "ability1Kb%": 150
            },
            "lifeweaver": {
                "primaryFireRange%": 200,
                "ability2Cooldown%": 50
            },
            "mercy": {
                "combatUltGen%": 1,
                "passiveUltGen%": 1,
                "ultGen%": 75
            },
            "reaper": {
                "combatUltGen%": 250
            },
            "sigma": {
                "secondaryFireCooldown%": 35
            },
            "soldier": {
                "healingDealt%": 500,
                "ultDuration%": 250
            },
            "wuyang": {
                "ability2Cooldown%": 75,
                "secondaryFireCost%": 50,
                "secondaryFireRechargeRate%": 150,
                "ability1Cooldown%": 25,
                "combatUltGen%": 200
            },
            "zenyatta": {
                "movementSpeed%": 120
            },
            "disabledHeroes": [
                "anran",
                "dmon",
                "doctrine",
                "domina",
                "emre",
                "jetpackCat",
                "mizuki",
                "shion",
                "sierra",
                "vendetta"
            ]
        }
    },
    "workshop": {
        "Boss Size": 3.5,
        "Chance to mutate percentage": 25,
        "Default Enhancement": [
            1
        ],
        "Maximum Number of Unique Hero Skins": 8,
        "Number of Objectives": 8,
        "Number of Powerups Per Supply Drop": 1,
        "Number of zombies": 8,
        "Spawn Zombies When Server Load Average is Less Than": 170,
        "Survivor Rescue": false,
        "Survivor Rescue.": false,
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
globalvar RamBOSSS 53
globalvar healthpackPositions 54
globalvar miniBoss 55
globalvar mapGrid 56
globalvar challengeSetting 57
globalvar attackSpawnRooms 58
globalvar activeAttackSpawnRoom 59
globalvar SojoRnPullLMao 60
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
playervar pNoCooldownsCount_bCount2 27
playervar specialCooldown 29
playervar chase1 30
playervar chase2 31
playervar botFollowTarget 32
playervar botTempvalue2 33
playervar playerMenuStatus 34
playervar startPos 35
playervar successfullyTeleported 36
playervar biowasteType 37
playervar evacPos 39
playervar canWallPhase 40
playervar initialMaxHealth 43
playervar botSpecialTarget 44
playervar attached 45
playervar telePos 46
playervar invisible 47
playervar potentialTargets 50
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
playervar enhancementChase1 73
playervar playerCollisionEnabled 74
playervar enhancementChase2 76
playervar initializing 77
playervar userIndex 78
playervar knockbackRecieved 79
playervar BubbleEffect 80
playervar BubbleYang 82
playervar Individualvar3 83
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
playervar RAMMATRACHAIN 100
playervar botResourceEntity 101
playervar IndividualVar 102
playervar DoomOverhealth 103
playervar IllarIGnite 104
playervar WoundedNHack 105
playervar DmgModNRamHP 106
playervar IndividualVar2 107
playervar WintonOvh 108
playervar ZaryaHP 109
playervar Text 110
playervar TextId 111
playervar Description2 112
playervar BAPimmoEffect 113
playervar BLINDAF 114
playervar Fhidetext 115

#Subroutine names

subroutine enterExitTeleport 0
subroutine teleportBots 1
subroutine nukeMap 2
subroutine randomActions 9
subroutine enableDisableAbilities 10
subroutine determineChallenge 11
subroutine setDifficulty 12
subroutine botRespawnInitialization 13
subroutine determineZombieMode 14
subroutine setZombieMode 15
subroutine bossReturn 18
subroutine determineObjectiveType 20
subroutine setObjectiveType 21
subroutine objectivesManagement 22
subroutine generateMapGrid 24
subroutine successfulTeleportStatus 25
subroutine updateBotSpawnPoints 26
subroutine globalObjectiveEntityManagement 27
subroutine playerObjectiveEntityManagement 28
subroutine botEntityManagement 29
subroutine botTeleportCenter 31
subroutine locateAveragePlayerLocation 32
subroutine enablePowerups 33
subroutine mutations 34
subroutine enableMutations 35
subroutine botHeroRandomization 37
subroutine enableEnhancements 38
subroutine teleportToClosestPlayer 39
subroutine setAvailableObjectives 40
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
subroutine ModDesc 57

#Activated extensions

#!extension beamEffects
#!extension buffStatusEffects
#!extension energyExplosionEffects
#!extension playMoreEffects
#!extension spawnMoreDummyBots
#!extension projectiles


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
    @Name "botHeroRandomization Spawn Rate"
    
    currentBotHeroList = botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)
    #Determines if count of current different zombie types is less than the maximum amount allowed
    if len(currentBotHeroList) < (uniqueSkinCap - (getNumberOfSlots(Team.1) if getNumberOfPlayers(Team.1) <= getNumberOfSlots(Team.1) else getNumberOfPlayers(Team.1))):
        #Trying Something
        #if len(currentBotHeroList) < uniqueSkinCap - getNumberOfPlayers(Team.1):
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
    zombieVotes = [[null, true], [null, "All Zombies"], [null, createWorkshopSettingBool("Zombie Mode Toggle", "New Blood", true, 1)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "What'll it be?", true, 2)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Zombie Shuffle", true, 3)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Dinner Rush!", true, 4)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Ham N' Hammer!", true, 5)], [null, createWorkshopSettingBool("Zombie Mode Toggle", "Whole Hog", true, 6)]]
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
    objectiveTypeVotes[1] = [null, createWorkshopSettingBool("Available Objective Types", "Standoff", true)]
    #Set objective type votes empty
    objectiveTypeVotes[2] = [null, createWorkshopSettingBool("Available Objective Types", "Bosses", true, 1)]
    #Set objective type votes empty
    objectiveTypeVotes[3] = [null, createWorkshopSettingBool("Available Objective Types", "Biomorphing", true, 2)]
    #Set objective type votes empty
    objectiveTypeVotes[4] = [null, createWorkshopSettingBool("Available Objective Types", "Survivor Rescue", true, 3)]
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
        #DEAFULT
        zombieSetting = 4
    startRule(determineChallenge)
    startRule(setZombieMode)


def setZombieMode():
    @Name "setZombieMode zombie variable"
    
    #Bot available hero list
    botHeros = [Hero.ZENYATTA, Hero.JUNKRAT, Hero.DVA, Hero.ROADHOG, Hero.REINHARDT, Hero.VENTURE, Hero.RAMATTRA, Hero.MAUGA, Hero.MERCY, Hero.WRECKING_BALL, Hero.MOIRA, Hero.PHARAH, Hero.SIGMA, Hero.JUNKER_QUEEN, Hero.ILLARI, Hero.HAZARD, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO]
    #Zombie types without a boss variation
    nonBossZombies = [Hero.JUNKRAT, Hero.VENTURE, Hero.WIDOWMAKER, Hero.JUNKER_QUEEN, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.SIGMA, Hero.ZENYATTA, Hero.WRECKING_BALL]
    #All Zombies
    if zombieSetting == 1:
        #Bot respawn probablities
        botSpawnRates = [11, 10, 5, 4, 3, 4, 4, 5, 6, 3, 5, 4, 4, 4, 4, 6, 4, 10, 4]
    #New Blood
    elif zombieSetting == 2:
        #Bot respawn probablities
        botSpawnRates = [null, null, null, null, null, 10, null, 10, 2, 2, 2, 3.9, 10, 10, 10, 10, 10.1, 10, 10]
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
        botSpawnRates = [null, 10, 15, null, null, 15, 15, 4, null, 3, 15, 5, null, 3, 10, null, 5]
    #Ham N' Hammer
    elif zombieSetting == 6:
        #Bot respawn probablities
        botSpawnRates = [null, null, null, null, 50, null, null, null, null, 50]
    #Whole Hog
    elif zombieSetting == 7:
        #Bot respawn probablities
        botSpawnRates = [null, 50, 50]


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
    @Name "setDifficulty Bot Setup"
    
    difficultySetting = len(getPlayers(Team.1).filter(lambda player: player.hasSpawned()))
    #Difficulty: Insanity
    if challengeSetting >= 4:
        #Bot Health Values
        botHealthValues = [300, 250, 700, 900, 1500, 220, 1000, 900, 250, 700, 200, 350, 350, 700, 350, 400, 275, 250, 1000]
        #Bot bite damage
        biteDamages = [48, 30, 45, 75, null, 20, 35, 51, 45, 50, 110, 80, 65, null, 30, 55, 35, 30, 30, 80, 80]
        #Bot bite durations
        biteDurations = [3, 3, 3, 3, null, 1.5, 4, 3, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
        #Bot throttle speeds
        throttleSpeeds = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        #Bot damage dealt
        damageDealt = [200, 300, 100, 150, 200, 180, 150, 90, 300, 175, 200, 150, 150, 190, 175, 125, 200, 240, 200, 180, 300]
    else:
        #Message does not play if server is not 70 seconds old, this is a bad fix but I'm struggling to find a simple one.
        if getTotalTimeElapsed() < 100:
            goto lbl_0
        smallMessage(getAllPlayers(), " Difficulty adjusted for player count, change affects new zombies. ")
        lbl_0:
        #Difficulty: 1 Player "Normal"
        if difficultySetting == 1:
            #Bot Health Values
            botHealthValues = [225, 170, 700, 900, 2000, 160, 1000, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 1000]
            #Bot bite damage
            biteDamages = [5, 2.5, 2, 20, 15, 3, 2, 7.5, 5, 10, 10, 30, 10, 15, 5, 5, 5, 2.5, 10, 10, 10]
            #Bot bite durations
            biteDurations = [1, 1, 1.5, 1.5, null, 0.5, 1.5, 1, 1, 0.5, 0, null, 1, null, 1, 1, 1, 1, 1, 1, 1]
            #Bot throttle speeds
            throttleSpeeds = [0.75, 0.8, 0.9, 0.5, 0.6, 0.7, 0.3, 0.65, 0.6, 0.55, 0.8, 0.55, 0.55, 0.65, 0.5, 0.55, 0.5, 0.8, 0.9, 0.6, 0.6]
            #Bot damage dealt
            damageDealt = [8.5, 7.5, 1, 1, 50, 25, 1, 25, 1, 50, 1, 75, 25, 50, 25, 8.5, 5, 7.5, 50, 50, 50]
        #Difficulty: 2 Player "Hard"
        elif difficultySetting == 2:
            #Bot Health Values
            botHealthValues = [225, 170, 700, 900, 2000, 160, 1000, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 1000]
            #Bot bite damage
            biteDamages = [15, 10, 12, 40, 30, 7, 2, 12, 15, 20, 15, 45, 20, 30, 7, 15, 7, 10, 10, 20, 20]
            #Bot bite durations
            biteDurations = [2.5, 2.5, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 2.5, 3, 2.5, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.85, 0.9, 1, 0.6, 0.7, 0.8, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.65, 0.6, 0.9, 1, 0.7, 0.7]
            #Bot damage dealt
            damageDealt = [67, 200, 50, 25, 90, 40, 25, 50, 25, 100, 25, 75, 50, 75, 50, 50, 50, 66, 75, 75, 75]
        #Difficulty: 5+ Player "Legendary"
        elif difficultySetting >= 5:
            #Bot Health Values
            botHealthValues = [300, 200, 1500, 900, 2000, 180, 1000, 800, 200, 750, 175, 300, 400, 750, 300, 350, 200, 200, 1100]
            #Bot bite damage
            biteDamages = [42, 22, 25, 55, 50, 20, 20, 40, 35, 25, 90, 70, 50, 50, 20, 40, 20, 22, 25, 40, 40]
            #Bot bite durations
            biteDurations = [3, 3, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.9, 0.95, 1, 0.75, 0.85, 0.9, 0.7, 0.8, 0.8, 0.75, 0.9, 0.65, 0.85, 0.8, 0.75, 0.9, 0.8, 0.95, 1, 0.9, 0.9]
            #Bot damage dealt
            damageDealt = [100, 150, 50, 100, 170, 100, 100, 80, 100, 175, 50, 100, 100, 140, 125, 90, 150, 125, 125, 150, 150]
        #Difficulty: 3-4 Player "Expert"
        else:
            #Bot Health Values
            botHealthValues = [225, 170, 1000, 900, 2000, 160, 1000, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 1000]
            #Bot bite damage
            biteDamages = [30, 15, 20, 50, 40, 15, 17.5, 30, 30, 20, 40, 60, 40, 40, 10, 40, 10, 15, 15, 20, 20]
            #Bot bite durations
            biteDurations = [3, 3, 3, 3, null, 1.5, 4, 2, 2, 2, 1, null, 2, null, 3, 3, 3, 3, 3, 3, 3]
            #Bot throttle speeds
            throttleSpeeds = [0.85, 0.9, 1, 0.6, 0.7, 0.8, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.85, 0.7, 0.9, 1, 0.7, 0.7]
            #Bot damage dealt
            damageDealt = [90, 300, 75, 50, 130, 75, 50, 50, 50, 150, 1, 75, 75, 90, 75, 85, 100, 125, 100, 100, 100]


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
            testPos += vect(0, 1, 0)
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
    enhancementOptions[2] = abilityIconString(Hero.REAPER, Button.ABILITY_1)
    enhancementOptions[3] = abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE)
    enhancementOptions[4] = iconString(Icon.SKULL)
    enhancementOptions[5] = iconString(Icon.FIRE)
    enhancementOptions[6] = iconString(Icon.PLUS)
    enhancementOptions[7] = iconString(Icon.BOLT)
    enhancementOptions[8] = abilityIconString(Hero.ILLARI, Button.ABILITY_1)
    enhancementOptions[9] = abilityIconString(Hero.ZENYATTA, Button.ULTIMATE)


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
        createDummy(Hero.REAPER, Team.2, -1, nearestWalkablePosition(startPos), vect(0, 0, 1))
        wait()
        getPlayers(Team.2).setInvisibility(Invis.ALL)
        getPlayers(Team.2)[0].startForcingPosition(startPos + vect(0, 15, 0))
        getPlayers(Team.2).startFacing(vect(0, 0, 1), 100000)
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
    hudSubtext(getAllPlayers(), "This is a modified version: A3YV07" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Modified by: LemonGranted#3739", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Workshop.codes
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] < 2), "For information on Changes, Join Discord, link on description", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
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
    #Vote zombie mode text: Whole Hog
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 7), "Zombie Mode: Whole Bombs", "Only Junkrat and Dva {0}{1} zombies will spawn ".format(heroIcon(Hero.DVA), heroIcon(Hero.JUNKRAT)), "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, rgb(164, 132, 108), rgb(164, 132, 108), rgb(164, 132, 108), HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: No preference
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 0), "Objective Type: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)), HudPosition.LEFT, 2, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Standoffs Only
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 1), "Objective Type: Standoff {0}".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)), "Players must contest a point against powerful zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Boss Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 2), "Objective Type: Bosses {0}".format(iconString(Icon.WARNING)), "Spawns giant versions of zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Biomorphing Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 3), "Objective Type: Biomorphing {0}".format(abilityIconString(Hero.ECHO, Button.ULTIMATE)), "Break down biowaste into useful powerups! What could go wrong?", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, rgb(135, 206, 250), Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Survivor Rescue Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 4), "Objective Type: Survivor Rescue {0}".format(iconString(Icon.HALO)), "Lead a survivor to an extraction site", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.VIOLET, Color.VIOLET, Color.VIOLET, HudReeval.VISIBILITY_AND_STRING)
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
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 2), "Enhancement: Zombie Hybrid {0}".format(abilityIconString(Hero.REAPER, Button.ABILITY_1)), "Get infected faster, and convert it to explosive damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Laser Barricade
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 3), "Enhancement: Laser Barricade {0}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE)), "Player can place a wall that blocks zombies", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Brain Killer
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 4), "Enhancement: Brain Killer {0}".format(iconString(Icon.SKULL)), "Critical hits do more damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Pyrotechnic
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 5), "Enhancement: Pyrotechnic {0}".format(iconString(Icon.FIRE)), "Dealing damage, within 15 meters, sets enemies on fire", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Plague Doctor
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 6), "Enhancement: Plague Doctor {0}".format(iconString(Icon.PLUS)), "Deal more healing to infected players while reducing their infection level", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Born to Battle
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 7), "Enhancement: Born to Battle {0}".format(iconString(Icon.BOLT)), "Dealing a final blow will give the player a cooldown reset on the next ability they use", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Charge Battery
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 8), "Enhancement: Charge Battery {0}".format(abilityIconString(Hero.ILLARI, Button.ABILITY_1)), "Survivor can place a battery that gives ultimate charge", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, rgb(236, 206, 44), rgb(236, 206, 44), rgb(236, 206, 44), HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Hitchhiker
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 9), "Enhancement: Hitchhiker {0}".format(abilityIconString(Hero.ZENYATTA, Button.ULTIMATE)), "Survivor can attach to a teammate and fuse their health.", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)


rule "SPECIAL EFFECT CONTROLS":
    @Condition specialGameModeSetup == true
    
    if specialGameModeSetup:
        randVal = random.randint(1, 5)
        if randVal == 1:
            specialEffectsStrings = "alglChene oteV: KaMeNrldEr"
        elif randVal == 2:
            specialEffectsStrings = "Phuwin Tangsakyuen..."
        elif randVal == 3:
            specialEffectsStrings = "You won't win"
        elif randVal == 4:
            specialEffectsStrings = "Don't even try it"
        elif randVal == 5:
            specialEffectsStrings = "Your funeral..."
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
    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA]:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "RANDOM ABILITIES":
    @Event eachPlayer
    @Team 2
    @Condition (challengeSetting == 3 or challengeSetting == 5) == true
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
        goalPost = 0
        goalCheck = false
        #Checks if current objective is standoff
        if objectiveTypes[0] == 1:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositions[0], objectiveRad * 2)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, objectivePositions[0], 200)
            bigMessage(getAllPlayers(), "Standoff Conquered!")
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
            objectiveDescription = "Hold your ground in the Standoff!"
            objectiveCaptureValue = 0
            objectiveRad = 10
            objectiveColor = Color.ORANGE
            goalCheck = 50 if challengeSetting > 1 else 33
            bigMessage(getAllPlayers(), "Proceed to the Standoff!")
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
            #Extraction point boundary 1
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction point boundary 2
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, 22, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction point boundary 3
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, 46, 0), objectiveRad, EffectReeval.VISIBILITY)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction zone dome
            createEffect(getLivingPlayers(Team.1).filter(lambda _: extractionZoneRad < 200), Effect.SPHERE, Color.LIME_GREEN, objectivePositions[0], extractionZoneRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
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
            #Objective boundary (Ring)
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, objectivePositions[0] + vect(0, -1, 0), objectiveRad, EffectReeval.VISIBILITY_AND_COLOR)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective boundary (Light Shaft)
            createEffect(playersOnObjective, Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -30, 0), objectiveRad, EffectReeval.VISIBILITY_AND_COLOR)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective beacon
            createEffect(getAllPlayers().filter(lambda _: len(playersOnObjective) > 0), Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -10, 0), objectiveRad / 20, EffectReeval.VISIBILITY_AND_COLOR)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective icon
            createIcon(getAllPlayers().exclude(playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedEntity())
            #Capture percentage text
            createInWorldText(playersOnObjective, "CAPTURE PERCENTAGE: {0}%".format(floor(objectiveCaptureValue)), objectivePositions[0] + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedText())
            #Capture percentage hud text
            hudText(getAllPlayers(), "Capture Percentage: {0}%".format(floor(objectiveCaptureValue)), "Objectives remaining: {0}".format(len(objectivePositions) - 1), len(playersOnObjective) if len(playersOnObjective) > 0 else [], HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
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


rule "============================================== OBJECTIVE TYPE: STANDOFF  ==============================================":
    @Disabled
    @Delimiter
    


rule "PLAYERS ON OBJECTIVE CONTROL":
    @Event eachPlayer
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition eventPlayer.invisible != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    #Objective Cylinder Height as Above
    @Condition abs(objectivePositions[0].y - eventPlayer.getPosition().y) < objectiveRad
    #Objective Cylinder Radius
    @Condition distance(vect(objectivePositions[0].x, eventPlayer.getPosition().y, objectivePositions[0].z), eventPlayer.getPosition()) < objectiveRad
    @Condition (eventPlayer in playersOnObjective or isInLoS(eventPlayer.getEyePosition(), objectivePositions[0] + (vect(0, max(0, eventPlayer.getEyePosition().y - objectivePositions[0].y), 0)) + directionTowards(objectivePositions[0], eventPlayer.getEyePosition()) * min(1, distance(eventPlayer.getEyePosition(), objectivePositions[0])))) == true
    
    if not eventPlayer in miniBoss and eventPlayer.getTeam() == Team.2:
        return
    if not eventPlayer in playersOnObjective:
        playersOnObjective.append(eventPlayer)
    wait(0.5)
    if ruleCondition:
        loop()
    playersOnObjective.remove(eventPlayer)


rule "MODIFY OBJECTIVE CAPTURE PERCENTAGE":
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(playersOnObjective) > 0
    @Condition objectiveComplete == false
    
    #Proceed to next objective
    if objectiveCaptureValue >= 100:
        objectiveComplete = true
        playersOnObjective = []
        return
    wait(1, Wait.RESTART_WHEN_TRUE)
    objectiveCaptureValue += (0.5 * len(playersOnObjective) * (2 if random.choice(miniBoss).botTarget != null else 1)) if len(playersOnObjective) <= 3 else 3.25 if random.choice(miniBoss).botTarget != null else 1.75
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    if objectiveCaptureValue >= goalPost:
        goalPost += goalCheck
    if ruleCondition:
        loop()


rule "MINIBOSS DECREASES CAPTURE PERCENTAGE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in miniBoss == true
    @Condition eventPlayer in playersOnObjective == true
    @Condition objectiveTypes[0] == 1
    @Condition len(objectivePositions) > 1
    @Condition len(playersOnObjective) > 0
    @Condition objectiveComplete == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    #decrease capture value
    if objectiveCaptureValue > goalPost - goalCheck:
        objectiveColor = Color.RED
        objectiveCaptureValue -= 0 if objectiveCaptureValue <= 0 else 0.5 + difficultySetting
        playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, objectivePositions[0], (0.05 * objectiveCaptureValue) ** 2)
    wait(0.5)
    if objectiveValue != 1:
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
    #eventPlayer.startForcingHero(Hero.REINHARDT)
    botRespawnInitialization()
    #Remove Current Boss Hero From Available Boss List
    availableBosses.remove(eventPlayer.getHero())
    #Boss throttle speed
    eventPlayer.botThrottleSpeed = 0.9 if eventPlayer.getHero() == Hero.REINHARDT else 0.65
    #Health pool size as boss
    eventPlayer.health = 15000
    eventPlayer.bossHealth = eventPlayer.health
    eventPlayer.size = createWorkshopSettingFloat("Zombies", "Boss Size", 2.5, 0, 20)
    eventPlayer.startScalingSize(eventPlayer.size, false)
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
    bosses[0] = random.choice(getLivingPlayers(Team.2).filter(lambda player: not player.teleporting and player.botTarget == null))
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
    
    objectivePositions[0] += directionTowards(victim, attacker) / 3.5
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
    hudText(getAllPlayers().filter(lambda _: eventPlayer.deathTimer > 0 and not eventPlayer.afk), "{0}{1}: {2}".format(eventPlayer, heroIcon(eventPlayer.getHero()), "{0}%".format(ceil(eventPlayer.getNormalizedHealth() * 100)) if eventPlayer.isAlive() else "DOWN"), "Revive: {0}s".format(ceil(eventPlayer.deathTimer)) if eventPlayer.isDead() and not eventPlayer.reviving else [], ("{1}Infection Level: {0}".format(floor(eventPlayer.infectionLvl), abilityIconString(Hero.REAPER, Button.ABILITY_1) if eventPlayer.enhancementValues[0] == 2 else [])) if eventPlayer.infectionLvl >= 1 else "Vaccine Level: {0}".format(abs(floor(eventPlayer.infectionLvl))) if eventPlayer.infectionLvl < 0 else "Reviving: {0}s".format(ceil(eventPlayer.reviveTimer)) if eventPlayer.reviving else [], HudPosition.LEFT, 0 if eventPlayer.getNormalizedHealth() > 0.97 else 1 / (eventPlayer.getNormalizedHealth() + 1), Color.BLUE if eventPlayer.getNormalizedHealth() > 0.97 else Color.GREEN if eventPlayer.getNormalizedHealth() > 0.66 else Color.YELLOW if eventPlayer.getNormalizedHealth() > 0.33 else Color.ORANGE if eventPlayer.getNormalizedHealth() > 0 else Color.RED, Color.RED, Color.LIME_GREEN if eventPlayer.infectionLvl >= 1 else Color.BLUE if eventPlayer.infectionLvl < 0 else Color.YELLOW)


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


rule "PLAYER SWITCHES HERO":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    destroyInWorldText(eventPlayer.TextId)
    destroyInWorldText(eventPlayer.Fhidetext)
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
    waitUntil(eventPlayer.isUsingUltimate() or [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.MELEE].any(lambda x: eventPlayer.isHoldingButton(x) and eventPlayer.getAbilityCooldown(x) == 0), 5)
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
    createIcon(eventPlayer.botTarget.filter(lambda x: eventPlayer.isAlive() and not x.isInViewAngle(eventPlayer.getPosition(), 55)), eventPlayer, Icon.WARNING, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.RED if (((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > 10 else 8))) % 2) == 0) else Color.YELLOW)
    waitUntil(eventPlayer.hasSpawned(), 2)
    eventPlayer.setMaxHealth(40 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.HAZARD, Hero.ILLARI] else 1)
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
    #LW Exception
    @Condition getPlayersOnHero(Hero.LIFEWEAVER, Team.1).IndividualVar2 == false
    
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
    
    wait(3 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.ANA] else 0)
    eventPlayer.botTarget = null
    eventPlayer.potentialTargets = []
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    if not eventWasEnvironment or attacker.getTeam() == Team.1:
        #Miniboss kill bonus
        if eventPlayer in miniBoss and objectiveTypes[0] == 1:
            playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, objectivePositions, 100)
            objectiveCaptureValue += 10
            wait(2)
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
        victim.infectionLvl += (2 if eventPlayer in bosses or eventPlayer in miniBoss or eventPlayer.mutationValue == 4 else 1) / ((3 if not victim.infected and victim.getHero() in [Hero.REINHARDT, Hero.HAZARD] else 2) if victim.enhancementValues[0] != 2 else 1)
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
    #Chance for a minboss on high difficulties without standoff
    if objectiveValue != 1 and difficultySetting >= 3 and eventPlayer in bosses == false and len(miniBoss.filter(lambda x: entityExists(x))) == 0:
        eventPlayer.randVal = random.randint(1, 199)
        if eventPlayer.randVal == 1:
            minibossMutation()
            wait(2)
    #Chance for a Standoff miniboss
    if objectiveValue == 1 and len(playersOnObjective) >= 1 and len(objectivePositions) != 1 and len(miniBoss.filter(lambda x: entityExists(x))) == 0:
        minibossMutation()
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
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingUltimate() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.GOOD_AURA, Color.YELLOW, eventPlayer.getPosition(), 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.WRECKING_BALL:
            #Ground strike location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue), Effect.RING, Color.TEAM_2, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + vect(0, -100, 0), getAllPlayers(), getAllPlayers(), false) if eventPlayer.botTempValue else evalOnce(vect(0, -100, 0)), 1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            eventPlayer.setMaxAmmo(0, 40)
        elif eventPlayer.getHero() == Hero.REAPER:
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
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isAlive() and eventPlayer.botTempValue <= 1), Effect.GOOD_AURA, Color.RED, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
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
        eventPlayer.setProjectileSpeed(20)
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
    eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.HAZARD]))
    if zombieSetting == 6:
        eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL]))
    elif zombieSetting == 7:
        eventPlayer.startForcingHero(Hero.ROADHOG)
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


rule "BEHEMOTH (ROAD) TOXIC CLOUD":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition (eventPlayer in bosses or eventPlayer.getNormalizedHealth() < 0.5) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 100)
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
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1 if eventPlayer in bosses else 8)
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


rule "BEHEMOTH HOOK (WHOLE HOG MODE)":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 30
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 18 * eventPlayer.size
    @Condition zombieSetting == 7
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.LIME_GREEN, eventPlayer, 2)
    eventPlayer.botSpecialTarget = 1
    waitUntil(eventPlayer.crowdControlled == true or eventPlayer.botSpecialTarget == 0, 0.75)
    (eventPlayer if eventPlayer.botSpecialTarget == 0 else null).setStatusEffect(null, Status.STUNNED, 0.5)
    if eventPlayer.crowdControlled == true or eventPlayer.botSpecialTarget == 0:
        goto lbl_0
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    getPlayersOnHero(Hero.ROADHOG, Team.2).setAbilityCooldown(Button.ABILITY_1, 2)
    lbl_0:
    eventPlayer.botSpecialTarget = 0
    wait(15)


rule "BEHEMOTH HOOK COUNTER (WHOLE HOG MODE)":
    @Event playerTookDamage
    @Team 2
    @Hero roadhog
    @Condition zombieSetting == 7
    @Condition eventPlayer.botSpecialTarget == 1
    
    eventPlayer.botSpecialTarget = 0


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


rule "SLICER (VENTURE) ABILITIES":
    @Event eachPlayer
    @Team 2
    @Hero venture
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isOnGround() == true
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 20
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 4 * eventPlayer.size
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    
    if eventPlayer.botTempValue == false:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        waitUntil(eventPlayer.isUsingAbility1(), 99999)
        eventPlayer.botTempValue = true
        eventPlayer.canWallPhase = false
        waitUntil(distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 4, 2)
        if not eventPlayer.isUsingAbility1():
            goto lbl_0
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        wait(1.5)
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.canWallPhase = true
    else:
        eventPlayer.startForcingButton(Button.CROUCH)
        eventPlayer.startFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, 100, 0), 999)
        wait(0.25)
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        eventPlayer.stopForcingButton(Button.CROUCH)
        restoreDefaultFacingMovement()
    if eventPlayer.botTarget != null and not eventPlayer.crowdControlled:
        eventPlayer.applyImpulse(normalize(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) + vect(0, 0.25, 0)), eventPlayer.size * (15 + 25 * abs(cosDeg(verticalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()))))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(3)
    lbl_0:
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
        wait(4.5)
    if ruleCondition:
        loop()


rule "SLIMER FLIGHT (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTempValue == null
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setPrimaryFireEnabled(true)
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
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer, 5 * eventPlayer.size)
    while eventPlayer.isUsingUltimate():
        eventPlayer.specialThrottling = true
        eventPlayer.specialFacing = true
        eventPlayer.stopThrottleInDirection()
        while eventPlayer.botTarget != null and eventPlayer.isUsingUltimate() and not eventPlayer.crowdControlled:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + evalOnce(directionFromAngles(random.uniform(0, 360), random.uniform(-90, 90))) * 1), 0 if eventPlayer.crowdControlled else 200)
            eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
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
    chaseOverTime(eventPlayer.chase1, 2, 2 if eventPlayer in bosses else 2, ChaseTimeReeval.NONE)
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
    if eventPlayer.crowdControlled or not eventPlayer in bosses and distance(eventPlayer, eventPlayer.botSpecialTarget) > 4 * eventPlayer.size or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.isDead():
        eventPlayer.botSpecialTarget.stopFacing()
        eventPlayer.botSpecialTarget.detach()
        goto lbl_0
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.botSpecialTarget.detach()
    eventPlayer.botSpecialTarget.stopFacing()
    eventPlayer.botSpecialTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botSpecialTarget.getPosition())), 25), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.botSpecialTarget.setStatusEffect(null, Status.KNOCKED_DOWN, 1.75)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    lbl_0:
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
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7 if 0 in bosses else 3)
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
    @Condition eventPlayer.getNormalizedHealth() < 0.8
    @Condition eventPlayer.crowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    illariUlt()
    wait(5)
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
            wait(0.2)
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


rule "SMOLDER TAKES DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Hero winston
    @Condition eventPlayer.botTempValue == 1
    @Condition eventPlayer.crowdControlled == false
    
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
    @Condition eventPlayer in playersOnObjective == true
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
        eventPlayer.enhancementValues[0] = createWorkshopSettingEnum("Enhancements", "Default Enhancement", 9, ["No Enhancement", "Kevlar", "Zombie Hybrid", "Laser Barricade", "Brain Killer", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker"])
    #Kevlar
    if eventPlayer.enhancementValues[0] == 1:
        #Enhancement Selection: Kevlar
        hudHeader(eventPlayer, "Kevlar {0}".format(iconString(Icon.STOP)), HudPosition.LEFT, 99, rgb(240, 129, 26), HudReeval.STRING)
        waitUntil(eventPlayer.initialMaxHealth != 0, 99999)
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.getMaxHealth() * 0.3, true, false)
        eventPlayer.enhancementValues[1] = getLastCreatedHealthPool()
    #Zombie Hybrid
    if eventPlayer.enhancementValues[0] == 2:
        #Enhancement: Zombie Hyrbid
        hudText(eventPlayer, "Zombie Hyrbid {0}".format(abilityIconString(Hero.REAPER, Button.ABILITY_1) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLvl)) if eventPlayer.infectionLvl >= 1 and eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, Color.GRAY, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
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
        hudText(eventPlayer, "Laser Barricade {0}{1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), " {0}s".format(eventPlayer.enhancementValues[3]) if eventPlayer.enhancementValues[3] > 0 else []), " {0}HP".format(ceil(eventPlayer.enhancementChase1)) if eventPlayer.enhancementChase1 > 0 else [], "Hold [{0}] to place a barricade".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[3] <= 0 else [], HudPosition.LEFT, 99, Color.RED if eventPlayer.enhancementValues[3] > 0 else Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_STRING_AND_COLOR)
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
        hudText(eventPlayer, "Charge Battery {0}".format(abilityIconString(Hero.ILLARI, Button.ABILITY_1) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, rgb(236, 206, 44), rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
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
        hudText(eventPlayer, "Hitchhiker {0}".format(abilityIconString(Hero.ZENYATTA, Button.ULTIMATE)), null, "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.attached else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size) else [], HudPosition.LEFT, 99, Color.PURPLE, Color.PURPLE, Color.RED if eventPlayer.attached else Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR)
        #Shared Health Bar Rider
        hudSubheader(eventPlayer.filter(lambda _: eventPlayer.attached), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementValues[1].getHero()), eventPlayer.enhancementValues[1]), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        #Shared Health Bar Runner
        hudSubheader(eventPlayer.enhancementValues[1].filter(lambda _: eventPlayer.attached), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.enhancementValues[1] = 0
        eventPlayer.enhancementValues[2] = 0
        eventPlayer.enhancementValues[1].startGrantingAssistFor(eventPlayer)
    eventPlayer.enhancementValues[11] = 0
    eventPlayer.enhancementValues[12] = false


rule "ZOMBIE HYRBID":
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
    eventPlayer.enhancementChase1 = 1000000
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
    chaseAtRate(eventPlayer.enhancementChase1, 1000000, 500, ChaseRateReeval.NONE)
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


rule "Pembatas":
    @Disabled
    @Delimiter
    


rule "ANA Nade":
    @Event playerReceivedHealing
    @Team 1
    @Condition healer == getPlayersOnHero(Hero.ANA, Team.1)
    @Condition eventAbility == Button.ABILITY_2
    
    eventPlayer.startHealingOverTime(getPlayersOnHero(Hero.ANA, Team.1), 5, eventPlayer.getMaxHealth() / 5)
    wait(5)


rule "Ana Took Damage":
    @Event playerTookDamage
    @Team 1
    @Hero ana
    @Condition eventAbility != null
    
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.getPosition(), 10)
    getPlayersInRadius(eventPlayer, 5, Team.2).setStatusEffect(eventPlayer, Status.ASLEEP, 5)
    eventPlayer.setMoveSpeed(200)
    eventPlayer.setJumpVerticalSpeed(200)
    eventPlayer.startHealingOverTime(eventPlayer, 3, 100)
    wait(3)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setJumpVerticalSpeed(100)
    wait(6)


rule "Ana Sleep CD":
    @Event playerDealtDamage
    @Team 1
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    
    waitUntil(not eventPlayer.isUsingAbility1(), 2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 5)
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)


rule "Ana Ult":
    @Event eachPlayer
    @Team 1
    @Hero ana
    @Condition eventPlayer.isUsingUltimate() == true
    
    getLivingPlayers(Team.1).setUltCharge(100)
    eventPlayer.setUltCharge(0)
    wait(1)
    if ruleCondition:
        loop()


rule "Ashe Multiple Shot":
    @Event playerDealtDamage
    @Team 1
    @Hero ashe
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    createProjectile(Projectile.GENJI_SHURIKEN, eventPlayer, victim.getEyePosition() + Vector.UP, Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 75, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 100, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)


rule "Ashe StunEye":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.ASHE, Team.1).isFiringSecondaryFire() == true
    @Condition raycastHitPlayer(getPlayersOnHero(Hero.ASHE, Team.1).getEyePosition(), getPlayersOnHero(Hero.ASHE, Team.1).getEyePosition() + getPlayersOnHero(Hero.ASHE, Team.1).getFacingDirection() * 60, getPlayers(Team.2), null, true) == eventPlayer
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.ASHE, Team.1), Status.ROOTED, 3)
    playEffect(getPlayers(Team.1), DynamicEffect.BAD_PICKUP_EFFECT, Color.ROSE, eventPlayer, 2)
    wait(6)


rule "Bastion Config No CD Nade":
    @Event eachPlayer
    @Team 1
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setMoveSpeed(300)
    wait(1)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setMoveSpeed(100)


rule "Bastion Config Knock":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.BASTION, Team.1), eventPlayer) <= 3
    @Condition isHeroBeingPlayed(Hero.BASTION, Team.1) == true
    @Condition getPlayersOnHero(Hero.BASTION, Team.1).isMoving() == true
    @Condition getPlayersOnHero(Hero.BASTION, Team.1).isUsingAbility1() == true
    @Condition eventPlayer in bosses != true
    
    eventPlayer.applyImpulse(directionTowards(getPlayersOnHero(Hero.BASTION, Team.1), eventPlayer.getEyePosition()), 10, Relativity.TO_WORLD)
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.BASTION, Team.1), Status.KNOCKED_DOWN, 1.5)


rule "Bastion Ult Field":
    @Event playerDealtDamage
    @Team 1
    @Hero bastion
    @Condition eventAbility == Button.ULTIMATE
    
    if eventPlayer.IndividualVar2 == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.CLOUD, Color.RED, eventPlayer.IndividualVar2.getPosition(), 13, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:
    eventPlayer.IndividualVar2 = victim.getPosition()
    wait(10, Wait.RESTART_WHEN_TRUE)
    eventPlayer.IndividualVar2 = false


rule "Bastion UltDrop":
    @Event eachPlayer
    @Team 1
    @Hero bastion
    @Condition eventPlayer.IndividualVar2 == true
    
    createProjectile(Projectile.BASTION_TACTICAL_GRENADE, eventPlayer, raycastHitPosition(eventPlayer.IndividualVar2, eventPlayer.IndividualVar2 + Vector.UP * 30, null, eventPlayer, true) + vect(random.randint(-10, 10), -1, random.randint(-10, 10)), Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 100, 1, 5, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 100, 2, 1)
    wait(0.1)
    if ruleCondition:
        loop()


rule "Brig Inspireproc":
    @Event playerDealtDamage
    @Team 1
    @Hero brigitte
    @Condition eventAbility != null
    
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), 40)
    eventPlayer.IndividualVar = true
    wait(0.5)
    eventPlayer.IndividualVar = false


rule "Brig Inspire Konkcback":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.BRIGITTE, Team.1).IndividualVar == true
    @Condition distance(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer) <= 20
    @Condition isInLoS(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer) == true
    
    eventPlayer.applyImpulse(directionTowards(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer.getEyePosition()), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "Brig Ability reseter":
    @Event eachPlayer
    @Team 1
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.getPlayerClosestToReticle(Team.1).setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.getPlayerClosestToReticle(Team.1).setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.getPlayerClosestToReticle(Team.1).setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.getPlayerClosestToReticle(Team.1).setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.getPlayerClosestToReticle(Team.1).setAbilityCharge(Button.ABILITY_2, 2)
    playEffect(eventPlayer.getPlayerClosestToReticle(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPlayerClosestToReticle(Team.1), 80)


rule "Brig Ult":
    @Event eachPlayer
    @Team 1
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    createEffect(getPlayers(Team.1), Effect.RING, Color.YELLOW, eventPlayer.getPosition(), 9, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IndividualVar2 = getLastCreatedEntity()
    eventPlayer.addHealthPool(Health.ARMOR, 350, true, false)
    eventPlayer.Individualvar3 = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    destroyEffect(eventPlayer.IndividualVar2)
    removeHealthPool(eventPlayer.Individualvar3)


rule "Brig Ult Effect":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.BRIGITTE, Team.1).isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer) <= 9
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.BRIGITTE, Team.1), Status.UNKILLABLE, 9999)
    waitUntil(not getPlayersOnHero(Hero.BRIGITTE, Team.1).isUsingUltimate() or distance(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer) > 9, 99999)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


rule "Brig Damage Convert":
    @Event playerTookDamage
    @Team 1
    @Condition getPlayersOnHero(Hero.BRIGITTE, Team.1).isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.BRIGITTE, Team.1), eventPlayer) <= 9
    
    heal(eventPlayer, getPlayersOnHero(Hero.BRIGITTE, Team.1), eventDamage * 1.75)


rule "Bap Doubleshot":
    @Event eachPlayer
    @Team 1
    @Hero baptiste
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    createProjectile(Projectile.BAPTISTE_BIOTIC_LAUNCHER, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 45, 1, 3, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, DynamicEffect.EXPLOSION_SOUND, 0, 60, 5, 0, 0, 20)
    createProjectile(Projectile.BAPTISTE_BIOTIC_LAUNCHER, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 45, 1, 3, DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 60, 5, 0, 0, 20)


rule "Bap Immo 4 all":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.BAPTISTE, Team.1).isUsingAbility2() == true
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.BAPTISTE, Team.1), Status.UNKILLABLE, 6)
    createEffect(getPlayers(Team.1), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.BAPimmoEffect = getLastCreatedEntity()
    wait(6)
    destroyEffect(eventPlayer.BAPimmoEffect)


rule "Cassidy Stacks":
    @Event playerDealtDamage
    @Team 1
    @Hero cassidy
    @Condition eventAbility != null
    
    if eventPlayer.IndividualVar == true:
        goto lbl_0
    hudHeader(eventPlayer, "{0}Stacks= {1}".format(iconString(Icon.SKULL), eventPlayer.IndividualVar), HudPosition.LEFT, 50, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    lbl_0:
    eventPlayer.IndividualVar += 0.25
    if eventWasCriticalHit == true:
        eventPlayer.IndividualVar += 0.25
    damage(victim, eventPlayer, eventPlayer.IndividualVar)


rule "Cassidy Ult":
    @Event eachPlayer
    @Team 1
    @Hero cassidy
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.getPlayersInViewAngle(Team.2, 70).setStatusEffect(null, Status.UNKILLABLE, 0.25)
    damage(eventPlayer.getPlayersInViewAngle(Team.2, 70), eventPlayer, eventPlayer.IndividualVar * 3)


rule "D.va Push Matrix":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.DVA, Team.1).isFiringSecondaryFire() == true
    @Condition distance(getPlayersOnHero(Hero.DVA, Team.1), eventPlayer) <= 12
    @Condition getPlayersOnHero(Hero.DVA, Team.1).isInViewAngle(eventPlayer, 15) == true
    
    eventPlayer.applyImpulse(directionTowards(getPlayersOnHero(Hero.DVA, Team.1), eventPlayer), 35, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.setEnvironmentalKillCreditor(getPlayersOnHero(Hero.DVA, Team.1))


rule "Dva Knock":
    @Event playerDealtDamage
    @Team 1
    @Hero dva
    @Condition eventAbility == Button.ABILITY_1
    
    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2)
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)


rule "Dva DemchUlt":
    @Event eachPlayer
    @Team 1
    @Hero dva
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.invisible++
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2)
    wait(2.9)
    eventPlayer.setDamageDealt(500)
    wait(0.5)
    eventPlayer.setDamageDealt(100)
    eventPlayer.invisible = 0


rule "Doom Armor":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.DOOMFIST, Team.1).isUsingAbility2() == true
    @Condition distance(getPlayersOnHero(Hero.DOOMFIST, Team.1), eventPlayer) <= 10
    @Condition eventPlayer.isAlive() == true
    
    wait(0.1)
    getPlayersOnHero(Hero.DOOMFIST, Team.1).setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.addHealthPool(Health.ARMOR, 250, true)
    eventPlayer.DoomOverhealth = getLastCreatedHealthPool()
    wait(2.5)
    removeHealthPool(eventPlayer.DoomOverhealth)


rule "Doom Knock":
    @Event playerDealtDamage
    @Team 1
    @Hero doomfist
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != null
    @Condition eventAbility != Button.MELEE
    
    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2)


rule "Echo CopyZise":
    @Event eachPlayer
    @Team 1
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    
    eventPlayer.setMoveSpeed(125)
    eventPlayer.startScalingSize(eventPlayer.getHealth() / 175)
    eventPlayer.setUltCharge(100)
    wait(14.5)
    eventPlayer.stopScalingSize()
    eventPlayer.setMoveSpeed(100)


rule "Echo  DMG":
    @Event playerDealtDamage
    @Team 1
    @Hero echo
    @Condition eventAbility != null
    @Condition victim in bosses != true
    
    damage(victim, eventPlayer, victim.getHealth() * 0.05)


rule "Freja ult":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition eventPlayer.isUsingUltimate() == true
    
    if eventPlayer.IndividualVar == false:
        eventPlayer.IndividualVar = 105
        eventPlayer.setDamageDealt(eventPlayer.IndividualVar)
        hudHeader(eventPlayer, "{0}Damage Dealt= {1}%".format(abilityIconString(Hero.FREJA, Button.ULTIMATE), eventPlayer.IndividualVar), HudPosition.LEFT, 50, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING)
    else:
        eventPlayer.IndividualVar += 5
        eventPlayer.setDamageDealt(eventPlayer.IndividualVar)


rule "Freja MultiBolt":
    @Event playerDealtDamage
    @Team 1
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    createHomingProjectile(Projectile.ORISA_FUSION_DRIVER, eventPlayer, null, directionTowards(eventPlayer.getEyePosition(), victim), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 45, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 125, 2, 0, victim)
    wait(0.1)
    createHomingProjectile(Projectile.ORISA_FUSION_DRIVER, eventPlayer, null, directionTowards(eventPlayer.getEyePosition(), victim), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 45, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 125, 2, 0, victim)
    wait(0.1)
    createHomingProjectile(Projectile.ORISA_FUSION_DRIVER, eventPlayer, null, directionTowards(eventPlayer.getEyePosition(), victim), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 45, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 125, 2, 0, victim)
    wait(0.1)


rule "Genji Inf Dash":
    @Event playerDealtDamage
    @Team 1
    @Hero genji
    @Condition eventAbility == Button.ABILITY_1
    
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 8)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.5)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "Genji ULT dmg":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(300)
    waitUntil(not eventPlayer.isUsingUltimate(), 12)
    eventPlayer.setDamageDealt(100)


rule "Genji Shurkens":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.getAmmo() > 0
    
    createProjectile(Projectile.GENJI_SHURIKEN, eventPlayer, eventPlayer.getEyePosition() + vect(random.uniform(-1, 1), random.uniform(-0.5, 0.5), 0), null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 50, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 75, 2, 3, 1)
    wait(0.05)
    createProjectile(Projectile.GENJI_SHURIKEN, eventPlayer, eventPlayer.getEyePosition() + vect(random.uniform(-1, 1), random.uniform(-0.5, 0.5), 0), null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 50, 2, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 75, 2, 3, 1)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() - 2)
    wait(0.05)
    if ruleCondition:
        loop()


rule "Hanzo Explode":
    @Event playerDealtDamage
    @Team 1
    @Hero hanzo
    @Condition eventAbility != null
    @Condition eventAbility != Button.MELEE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    
    damage(getPlayersInRadius(victim, 5, Team.2), eventPlayer, eventDamage)
    playEffect(getPlayers(Team.1), DynamicEffect.BAD_EXPLOSION, Color.AQUA, victim, 5)


rule "Hanzo TP":
    @Event eachPlayer
    @Team 1
    @Hero hanzo
    @Condition eventPlayer.getAbilityCooldown(Button.JUMP) == 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    createEffect(eventPlayer, Effect.GOOD_AURA, Color.GRAY, nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 25, null, eventPlayer, true)), 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IndividualVar = getLastCreatedEntity()
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    if eventPlayer.isHoldingButton(Button.JUMP) == true:
        eventPlayer.teleport(nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 25, null, eventPlayer, true)))
        eventPlayer.setAbilityCooldown(Button.JUMP, 5)
        destroyEffect(eventPlayer.IndividualVar)
    destroyEffect(eventPlayer.IndividualVar)


rule "Hazard Wall Up":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    if eventPlayer.IndividualVar2 == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.SPHERE, Color.PURPLE, eventPlayer.IndividualVar2, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)
    eventPlayer.IndividualVar2 = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, eventPlayer, true)
    wait(0.5)
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2), 5.5)
    eventPlayer.IndividualVar2 = vect(10000, 10000, 10000)


rule "Hazard wall":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.HAZARD, Team.1).IndividualVar2 == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.HAZARD, Team.1).IndividualVar2, eventPlayer) <= 10
    @Condition distance(getPlayersOnHero(Hero.HAZARD, Team.1).IndividualVar2, eventPlayer) > 3
    
    eventPlayer.applyImpulse(directionTowards(eventPlayer, getPlayersOnHero(Hero.HAZARD, Team.1).IndividualVar2), 20, Relativity.TO_WORLD)
    wait(0.3)
    if ruleCondition:
        loop()


rule "Hazard Jump":
    @Event playerDealtDamage
    @Team 1
    @Hero hazard
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.IndividualVar++
    if eventPlayer.IndividualVar >= 3:
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 200)
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
        eventPlayer.IndividualVar = 0
    wait(2, Wait.RESTART_WHEN_TRUE)
    eventPlayer.IndividualVar = 0


rule "Illari Charged Bomb":
    @Event playerTookDamage
    @Team 2
    @Condition attacker == getPlayersOnHero(Hero.ILLARI, Team.1)
    @Condition eventAbility != null
    @Condition eventPlayer.isAlive() == true
    
    if eventPlayer.IndividualVar > 0:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.GOOD_AURA, Color.ORANGE, eventPlayer.getEyePosition(), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IllarIGnite = getLastCreatedEntity()
    lbl_0:
    eventPlayer.IndividualVar++
    wait(0.5)


rule "Illari Ignite":
    @Event playerTookDamage
    @Team 2
    @Condition eventPlayer.IndividualVar > 0
    @Condition eventPlayer.isAlive() == true
    
    if eventPlayer.IndividualVar == 1:
        eventPlayer.IndividualVar++
    elif eventPlayer.IndividualVar > 1:
        destroyEffect(eventPlayer.IllarIGnite)
        damage(getPlayersInRadius(eventPlayer, 5, Team.2), attacker, getPlayersOnHero(Hero.ILLARI, Team.1).Individualvar3 * 4)
        playEffect(getPlayers(Team.1), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 5)
        eventPlayer.IndividualVar = 0


rule "Illari HealStack":
    @Event playerDealtHealing
    @Team 1
    @Hero illari
    
    eventPlayer.IndividualVar2 += eventHealing


rule "Illari Stack count":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition eventPlayer.IndividualVar2 >= 500
    
    if eventPlayer.Individualvar3 > 0:
        goto lbl_0
    hudHeader(eventPlayer, "{0}Stacks= {1}".format(iconString(Icon.HEART), eventPlayer.Individualvar3), HudPosition.LEFT, 50, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    lbl_0:
    eventPlayer.Individualvar3++
    eventPlayer.IndividualVar2 = 0
    eventPlayer.setHealingDealt(eventPlayer.Individualvar3 * 5 + 100)


rule "JunkerQueen BleeedManual":
    @Event playerTookDamage
    @Team 2
    @Condition attacker == getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1)
    @Condition eventDamage > 10
    
    eventPlayer.WoundedNHack++
    playEffect(getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer, 1)
    eventPlayer.startDamageOverTime(getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1), 3, 25)
    getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1).startHealingOverTime(getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1), 3, 25)
    wait(3, Wait.RESTART_WHEN_TRUE)
    eventPlayer.WoundedNHack = 0


rule "JunkerQueen WoundExplode":
    @Event playerTookDamage
    @Team 2
    @Condition eventPlayer.WoundedNHack >= 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != null
    @Condition eventDamage > 7
    @Condition eventAbility != Button.MELEE
    
    damage(getPlayersInRadius(eventPlayer, 4, Team.2), getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1), 50)
    playEffect(getPlayers(Team.1), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer, 4)
    eventPlayer.WoundedNHack = 0
    getPlayersOnHero(Hero.JUNKER_QUEEN, Team.1).setAbilityCooldown(Button.ABILITY_1, 0)


rule "Junkrat Mine":
    @Event playerDied
    @Team 2
    @Condition isHeroBeingPlayed(Hero.JUNKRAT, Team.1) == true
    
    createProjectile(Projectile.ROADHOG_SCRAP_BALL, getPlayersOnHero(Hero.JUNKRAT, Team.1), eventPlayer.getEyePosition(), Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 100, 1, 5, DynamicEffect.GOOD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 5, 0.5, 0, 3, 100)


rule "Junkrat UltPlode":
    @Event playerTookDamage
    @Team 2
    @Condition attacker == getPlayersOnHero(Hero.JUNKRAT, Team.1)
    @Condition eventAbility == Button.ULTIMATE
    
    damage(getPlayersInRadius(eventPlayer, 10, Team.2, LosCheck.SURFACES), getPlayersOnHero(Hero.JUNKRAT, Team.1), 300)
    playEffect(getPlayers(Team.1), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.WHITE, eventPlayer, 1)


rule "Junkrat Shoot":
    @Event eachPlayer
    @Team 1
    @Hero junkrat
    @Condition eventPlayer.isCrouching() == true
    
    eventPlayer.setProjectileSpeed(15)
    eventPlayer.setProjectileGravity(0)
    eventPlayer.setDamageDealt(300)
    waitUntil(not eventPlayer.isCrouching(), 99999)
    eventPlayer.setProjectileSpeed(200)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setDamageDealt(100)


rule "Junkrat Trap":
    @Event playerDealtDamage
    @Team 1
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2
    
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.ORANGE, victim.getPosition(), 20)
    wait(0.3)
    getPlayersInRadius(victim, 10, Team.2).teleport(victim)
    getPlayersInRadius(victim, 10, Team.2).setStatusEffect(eventPlayer, Status.ROOTED, 2)


rule "Juno JumpSpeed":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.JUNO, Team.1).isUsingAbility1() == true
    
    playEffect(getPlayers(Team.1), DynamicEffect.TRACER_RECALL_REAPPEAR, Color.WHITE, eventPlayer, 100)
    eventPlayer.setJumpVerticalSpeed(250)
    eventPlayer.setMoveSpeed(150)
    waitUntil(not getPlayersOnHero(Hero.JUNO, Team.1).isUsingAbility1(), 15)
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.setMoveSpeed(100)


rule "Juno Pulsar Dmg Vulenrable":
    @Event playerTookDamage
    @Team 2
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker == getPlayersOnHero(Hero.JUNO, Team.1)
    
    startDamageModification(eventPlayer, getPlayers(Team.1), 150)
    eventPlayer.DmgModNRamHP = getLastDamageModification()
    playEffect(getPlayers(Team.1), DynamicEffect.MOIRA_FADE_DISAPPEAR, Color.WHITE, eventPlayer, 5)
    wait(5)
    stopDamageModification(eventPlayer.DmgModNRamHP)
    playEffect(getPlayers(Team.1), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, Color.WHITE, eventPlayer, 5)


rule "Juno Pulsar Heal Invulnerable":
    @Event playerReceivedHealing
    @Team 1
    @Condition healer == getPlayersOnHero(Hero.JUNO, Team.1)
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.JUNO, Team.1), Status.INVINCIBLE, 1.5)
    wait(3)


rule "Kiriko Vaccine Suzu":
    @Event playerDealtHealing
    @Team 1
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    
    healee.infectionLvl -= 2


rule "Kiriko Vaccine Effect":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.infectionLvl < 0
    
    heal(eventPlayer, getPlayersOnHero(Hero.KIRIKO, Team.1), 100)
    if eventPlayer.infectionLvl < 0:
        eventPlayer.infectionLvl++
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.KIRIKO, Team.1), Status.INVINCIBLE, 0.5)
    playEffect(getPlayers(Team.1), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 2)
    wait(0.5)


rule "KirikoVaccine Swiftstep":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.KIRIKO, Team.1).isUsingAbility1() == true
    
    wait(0.5)
    if distance(getPlayersOnHero(Hero.KIRIKO, Team.1), eventPlayer) <= 7:
        eventPlayer.infectionLvl -= 3
        playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, getPlayersOnHero(Hero.KIRIKO, Team.1).getPosition(), 14)


rule "LiveWeaver Tree config":
    @Event eachPlayer
    @Team 1
    @Hero lifeweaver
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    createEffect(eventPlayer, Effect.SPHERE, Color.ROSE, nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, getAllPlayers(), eventPlayer, true)), 12, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IndividualVar = getLastCreatedEntity()
    waitUntil(eventPlayer.isDead() or eventPlayer.isUsingUltimate() or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    if eventPlayer.isUsingUltimate() == true:
        destroyEffect(eventPlayer.IndividualVar)
        eventPlayer.IndividualVar2 = nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, getAllPlayers(), eventPlayer, true))
        createEffect(getPlayers(Team.1), Effect.SPHERE, Color.ROSE, eventPlayer.IndividualVar2, 12, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.IndividualVar = getLastCreatedEntity()
        wait(15)
        destroyEffect(eventPlayer.IndividualVar)
        eventPlayer.IndividualVar2 = false
    else:
        destroyEffect(eventPlayer.IndividualVar)


rule "LifeWeaver Tree Effect":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.LIFEWEAVER, Team.1).IndividualVar2 == true
    @Condition distance(getPlayersOnHero(Hero.LIFEWEAVER, Team.1).IndividualVar2, eventPlayer) <= 12
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.LIFEWEAVER, Team.1), Status.ROOTED, 5)
    wait(4)
    if getPlayersOnHero(Hero.LIFEWEAVER, Team.1).IndividualVar2 == true:
        loop()


rule "LifeWeaver KnockBack":
    @Event playerDealtHealing
    @Team 1
    @Hero lifeweaver
    @Condition healee != eventPlayer
    
    createProjectile(Projectile.MOIRA_HEAL_ORB, eventPlayer, healee, Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 50, 1, 10, DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR, DynamicEffect.EXPLOSION_SOUND, 0.1, 10, 0.1, 10)
    wait(1)


rule "LifeWeaver PULL":
    @Event eachPlayer
    @Team 1
    @Hero lifeweaver
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.getPlayerClosestToReticle(Team.1).addHealthPool(Health.NORMAL, 500, false, false)


rule "Lucio Effect":
    @Event eachPlayer
    @Team 1
    @Hero lucio
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    playEffect(getPlayers(Team.1), DynamicEffect.LUCIO_SOUND_BARRIER_CAST, Color.WHITE, eventPlayer.getPosition(), 30)


rule "Lucio Ovrhlt":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.LUCIO, Team.1).isFiringSecondaryFire() == true
    @Condition distance(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) <= 30
    @Condition eventPlayer.isAlive() == true
    @Condition isInLoS(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) == true
    
    eventPlayer.addHealthPool(Health.NORMAL, 50, false, false)


rule "Lucio SpeedUp":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.LUCIO, Team.1).isUsingAbility1() == true
    @Condition distance(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) <= 12
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setMoveSpeed(150)
    waitUntil(distance(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) > 12 or not getPlayersOnHero(Hero.LUCIO, Team.1).isUsingAbility1(), 99999)
    eventPlayer.setMoveSpeed(100)


rule "Lucio Reduction":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.LUCIO, Team.1).isUsingAbility1() == false
    @Condition distance(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) <= 12
    @Condition eventPlayer.isAlive() == true
    @Condition isHeroBeingPlayed(Hero.LUCIO, Team.1) == true
    
    eventPlayer.setDamageReceived(50)
    waitUntil(distance(getPlayersOnHero(Hero.LUCIO, Team.1), eventPlayer) > 12 or getPlayersOnHero(Hero.LUCIO, Team.1).isUsingAbility1() or not entityExists(getPlayersOnHero(Hero.LUCIO, Team.1)), 99999)
    eventPlayer.setDamageReceived(100)


rule "Mauga Pickup":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.MAUGA, Team.1).isUsingAbility1() == true
    @Condition distance(getPlayersOnHero(Hero.MAUGA, Team.1), eventPlayer) <= 5
    
    eventPlayer.attachTo(getPlayersOnHero(Hero.MAUGA, Team.1), vect(0, 0, 2))
    wait(0.5)
    waitUntil(getPlayersOnHero(Hero.MAUGA, Team.1).isHoldingButton(Button.PRIMARY_FIRE) or getPlayersOnHero(Hero.MAUGA, Team.1).isHoldingButton(Button.ABILITY_1), 1)
    wait(0.5)
    eventPlayer.detach()
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer))


rule "Mauga Dash Invinvinvin":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 2)
    wait(1)
    if ruleCondition:
        loop()


rule "Mauga TP Ult":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.MAUGA, Team.1).isUsingUltimate() == true
    @Condition isInLoS(getPlayersOnHero(Hero.MAUGA, Team.1), eventDirection) == true
    @Condition distance(getPlayersOnHero(Hero.MAUGA, Team.1), eventPlayer) > 7
    
    wait(0.25)
    eventPlayer.teleport(getPlayersOnHero(Hero.MAUGA, Team.1))
    wait(8)


rule "Mei Freeze E":
    @Event eachPlayer
    @Team 1
    @Hero mei
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true:
        (getPlayersInRadius(nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, eventPlayer, true)), 10, Team.2)).setStatusEffect(eventPlayer, Status.FROZEN, 2)
        playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, eventPlayer, true)), 20)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)


rule "Mei Freeze 1":
    @Event eachPlayer
    @Team 1
    @Hero mei
    @Condition eventPlayer.isUsingAbility1() == true
    
    getPlayersInRadius(eventPlayer, 10, Team.2, LosCheck.SURFACES).setStatusEffect(eventPlayer, Status.FROZEN, 2)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, eventPlayer, 20)


rule "Mei Freeze":
    @Event playerDealtDamage
    @Team 1
    @Hero mei
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in bosses != true
    
    victim.setStatusEffect(eventPlayer, Status.FROZEN, 0.5)


rule "Mercy Bring Rez":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDead() == true
    @Condition getPlayersOnHero(Hero.MERCY, Team.1).isUsingAbility1() == true
    @Condition isInLoS(getPlayersOnHero(Hero.MERCY, Team.1), eventPlayer) == true
    
    eventPlayer.startAcceleration(directionTowards(eventPlayer, getPlayersOnHero(Hero.MERCY, Team.1)), 50, 50, Relativity.TO_WORLD)
    waitUntil(isInLoS(getPlayersOnHero(Hero.MERCY, Team.1), eventPlayer) == false or eventPlayer.isAlive() or getPlayersOnHero(Hero.MERCY, Team.1).isDead(), 99999)
    eventPlayer.stopAcceleration()


rule "Mercy Machinegun":
    @Event eachPlayer
    @Team 1
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.getCurrentWeapon() == 2
    
    createProjectile(Projectile.MERCY_CADUCEUS_BLASTER, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 20, 1.5, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 50, 3)
    wait(0.05)
    if ruleCondition:
        loop()


rule "Mercy Fly":
    @Event eachPlayer
    @Team 1
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate() == true
    
    waitUntil(not eventPlayer.isUsingUltimate(), 25)
    eventPlayer.setUltCharge(100)


rule "Moira ORB - and Grasp":
    @Event eachPlayer
    @Team 1
    @Hero moira
    @Condition (eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingUltimate()) == true
    
    if isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(Team.2)) == true:
        eventPlayer.getPlayerClosestToReticle(Team.2).startDamageOverTime(eventPlayer, 0.5, 60)
        playEffect(eventPlayer, DynamicEffect.MOIRA_FADE_DISAPPEAR, Color.WHITE, eventPlayer.getPlayerClosestToReticle(Team.2), 3)
    #Orb
    createProjectile(Projectile.MOIRA_DAMAGE_ORB, eventPlayer, vect(random.uniform(-1, 1), 1, 0), null, Relativity.TO_PLAYER, ModifyHealth.DAMAGE, Team.2, 50, 1, 2, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 20, 3, 2, 5)
    if eventPlayer.isUsingUltimate() == true:
        goto lbl_0
    wait(0.3)
    lbl_0:
    wait(0.2)
    if ruleCondition:
        loop()


rule "MOIRA ORB +":
    @Event eachPlayer
    @Team 1
    @Hero moira
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isUsingUltimate()) == true
    
    createHomingProjectile(Projectile.MOIRA_HEAL_ORB, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 65, 1, 5, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, DynamicEffect.BUFF_EXPLOSION_SOUND, 0, 20, 5, 0, null if eventPlayer.isUsingUltimate() else eventPlayer.getPlayerClosestToReticle(Team.1))
    if eventPlayer.isUsingUltimate() == true:
        goto lbl_0
    wait(0.5)
    lbl_0:
    wait(0.5)
    if ruleCondition:
        loop()


rule "Orisa Fortibuff":
    @Event eachPlayer
    @Team 1
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()) == true
    
    if eventPlayer.IndividualVar == 0:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.IndividualVar, true)
    eventPlayer.IndividualVar += 15
    heal(eventPlayer, null, 20)
    damage(getPlayersInRadius(eventPlayer, 10, Team.2, LosCheck.SURFACES), eventPlayer, eventPlayer.getMaxHealth() * 0.05)
    playEffect(getPlayers(Team.1), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 10)
    wait(1, Wait.RESTART_WHEN_TRUE)


rule "Orisa Ult":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.ORISA, Team.1).isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.startAcceleration(directionTowards(eventPlayer, getPlayersOnHero(Hero.ORISA, Team.1) + vect(0, 1, 0)), 100, 20, Relativity.TO_WORLD)
    getPlayersOnHero(Hero.ORISA, Team.1).setStatusEffect(null, Status.PHASED_OUT, 1)
    waitUntil(not getPlayersOnHero(Hero.ORISA, Team.1).isUsingUltimate(), 5)
    eventPlayer.stopAcceleration()
    getPlayersOnHero(Hero.ORISA, Team.1).setStatusEffect(null, Status.PHASED_OUT, 2)


rule "ORISA JAvelin dmg":
    @Event playerDealtDamage
    @Team 1
    @Hero orisa
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    if eventPlayer.IndividualVar == 0:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.IndividualVar, true)
    wait(0.5)
    eventPlayer.IndividualVar += 15
    damage(getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES), eventPlayer, eventPlayer.getMaxHealth() * 0.05)
    playEffect(getPlayers(Team.1), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, victim, 10)


rule "Pharah Roket":
    @Event playerDealtDamage
    @Team 1
    @Hero pharah
    @Condition isInLoS(eventPlayer, victim) == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventDamage >= 70
    
    createHomingProjectile(Projectile.PHARAH_ROCKET, eventPlayer, vect(-1, 1, 0), vect(0, 0, 1), Relativity.TO_PLAYER, ModifyHealth.DAMAGE, Team.2, 20, 1, 2, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 25, 2, 1, victim)
    createHomingProjectile(Projectile.PHARAH_ROCKET, eventPlayer, vect(1, 1, 0), vect(0, 0, 1), Relativity.TO_PLAYER, ModifyHealth.DAMAGE, Team.2, 20, 1, 2, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 25, 2, 1, victim)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.5)


rule "Pharah Ult":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isUsingUltimate() == true
    
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 1000, 1, 15, DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, DynamicEffect.BUFF_EXPLOSION_SOUND, 1, 5, 10, 15)


rule "Rammatra Nemesis":
    @Event eachPlayer
    @Team 1
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.addHealthPool(Health.NORMAL, 1000, false)
    eventPlayer.IndividualVar = getLastCreatedHealthPool()
    eventPlayer.startScalingSize(2 if eventPlayer.isUsingUltimate() else 1.5)
    wait(0.5)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.stopScalingSize()
    removeHealthPool(eventPlayer.IndividualVar)


rule "Rammatra Shield Stun":
    @Event eachPlayer
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == false
    
    createEffect(eventPlayer, Effect.RING, Color.PURPLE, nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, eventPlayer, true)), 4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IndividualVar2 = getLastCreatedEntity()
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    (getPlayersInRadius(nearestWalkablePosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, getPlayers(Team.2), eventPlayer, true)), 4, Team.2)).setStatusEffect(eventPlayer, Status.STUNNED, 5)
    destroyEffect(eventPlayer.IndividualVar2)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 13)


rule "Rammatra Hp Increase":
    @Event playerDealtDamage
    @Team 1
    @Hero ramattra
    @Condition eventAbility == Button.ABILITY_2
    
    if eventPlayer.DmgModNRamHP == true:
        goto lbl_0
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.DmgModNRamHP, true)
    eventPlayer.DmgModNRamHP = 10
    lbl_0:
    eventPlayer.DmgModNRamHP += 10
    wait(1)


rule "Reaper Noclip":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.setGravity(0)
    eventPlayer.startAcceleration(Vector.UP, 110 if eventPlayer.isHoldingButton(Button.JUMP) else 100, 50, Relativity.TO_WORLD)
    eventPlayer.startAcceleration(Vector.DOWN, 110 if eventPlayer.isHoldingButton(Button.CROUCH) else 100, 50, Relativity.TO_WORLD)
    waitUntil(not eventPlayer.isUsingAbility1(), 15)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.setGravity(100)
    eventPlayer.stopAcceleration()
    wait(0.5)


rule "Reaper Ult":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() >= 10
    @Condition (not eventPlayer.isUsingAbility1()) == true
    @Condition (not eventPlayer.isUsingAbility2()) == true
    
    eventPlayer.IndividualVar = eventPlayer.getUltCharge()
    chaseAtRate(eventPlayer.IndividualVar, 0, 35)
    eventPlayer.setUltCharge(100)
    eventPlayer.setMoveSpeed(300)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 1.5)
    while eventPlayer.IndividualVar > 0:
        eventPlayer.setUltCharge(eventPlayer.IndividualVar)
        wait(0.1)
    eventPlayer.setStatusEffect(null, Status.HACKED, 0.1)
    eventPlayer.setMoveSpeed(100)


rule "Reaper Fixed Ult":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.setUltCharge(99)


rule "Reinhardt MoveSpeed":
    @Event eachPlayer
    @Team 1
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.setMoveSpeed(200)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 999)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)


rule "Reinhard Stick":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.REINHARDT, Team.1).isFiringSecondaryFire() == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.REINHARDT, Team.1), eventPlayer) <= 4
    @Condition eventPlayer in bosses != true
    
    getPlayersOnHero(Hero.REINHARDT, Team.1).setUltCharge(getPlayersOnHero(Hero.REINHARDT, Team.1).getUltCharge() + 15)
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.REINHARDT, Team.1), Status.STUNNED, 0.5)
    eventPlayer.attachTo(getPlayersOnHero(Hero.REINHARDT, Team.1), vect(random.randint(-3, 3), random.randint(0, 3), 1.5))
    waitUntil(not getPlayersOnHero(Hero.REINHARDT, Team.1).isFiringSecondaryFire(), 99999)
    eventPlayer.detach()
    wait(0.5)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer))


rule "Reinhardt STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero reinhardt
    @Condition eventAbility != null
    @Condition eventAbility != Button.ULTIMATE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.5)


rule "RoadHog HoleConfig":
    @Event playerDealtDamage
    @Team 1
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    
    wait(1)
    if eventPlayer.IndividualVar == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.CLOUD, Color.LIME_GREEN, eventPlayer.IndividualVar, 5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getPlayers(Team.1), Effect.RING, Color.LIME_GREEN, eventPlayer.IndividualVar, 5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(getPlayers(Team.1), "{0}Hole!!{0}".format(iconString(Icon.WARNING)), eventPlayer.IndividualVar + Vector.UP, 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.LIME_GREEN)
    lbl_0:
    eventPlayer.IndividualVar = raycastHitPosition(eventPlayer.getPosition(), vect(0, -30, 0), null, eventPlayer, true)
    wait(10)
    eventPlayer.IndividualVar = vect(10000, 10000, 10000)


rule "Roadhog HoleEffet":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.ROADHOG, Team.1).IndividualVar == true
    @Condition distance(getPlayersOnHero(Hero.ROADHOG, Team.1).IndividualVar, eventPlayer) < 5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableEnvironmentCollision(true)
    if eventPlayer.getTeam() == Team.1:
        wait(0.5)
        eventPlayer.applyImpulse(Vector.UP, 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.setHealth(25)
        eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 3)
        eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1.5)
        wait(0.25)
        eventPlayer.enableEnvironmentCollision()
    else:
        eventPlayer.setEnvironmentalKillCreditor(getPlayersOnHero(Hero.ROADHOG, Team.1))
        wait(1)
        eventPlayer.enableEnvironmentCollision()
        getPlayersOnHero(Hero.ROADHOG, Team.1).setAbilityCooldown(Button.ABILITY_1, 0)


rule "RoadHog Flying":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.applyImpulse(Vector.UP, 3.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.enableEnvironmentCollision()


rule "Sigma Shield COnfig":
    @Event eachPlayer
    @Team 1
    @Hero sigma
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == false
    
    eventPlayer.IndividualVar = eventPlayer.getEyePosition()
    eventPlayer.IndividualVar2 = eventPlayer.getFacingDirection()


rule "Sigma Shiled Push":
    @Event eachPlayer
    @Team 1
    @Hero sigma
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.IndividualVar = eventPlayer.IndividualVar + eventPlayer.IndividualVar2 * 0.264
    getPlayersInRadius(eventPlayer.IndividualVar, 5, Team.2).applyImpulse(eventPlayer.IndividualVar2, 4, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    getPlayersInRadius(eventPlayer.IndividualVar, 25, Team.2).setEnvironmentalKillCreditor(eventPlayer)
    getPlayersInRadius(eventPlayer.IndividualVar, 7, Team.2).setStatusEffect(eventPlayer, Status.STUNNED, 1)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.IndividualVar, 14)


rule "Sigmazucckk":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.SIGMA, Team.1).isUsingAbility1() == true
    @Condition getPlayersOnHero(Hero.SIGMA, Team.1).isInViewAngle(eventPlayer, 75) == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(getPlayersOnHero(Hero.SIGMA, Team.1), eventPlayer) <= 5
    
    eventPlayer.teleport(nearestWalkablePosition(getFarthestPlayer(eventPlayer, Team.2)))
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.SIGMA, Team.1), Status.KNOCKED_DOWN, 2)
    wait(1)
    if ruleCondition:
        loop()


rule "Sigma Shoots":
    @Event eachPlayer
    @Team 1
    @Hero sigma
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    createProjectile(Projectile.SIGMA_HYPERSPHERE, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 15, 1, 3, DynamicEffect.SIGMA_HYPERSPHERE_IMPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 48, 0.5, 5, 5)
    wait(random.uniform(0.05, 0.15))
    if ruleCondition:
        loop()


rule "Sojourn PullPos":
    @Event playerDealtDamage
    @Team 1
    @Hero sojourn
    @Condition eventAbility == Button.ABILITY_2
    
    SojoRnPullLMao = victim.getPosition()
    wait(2)


rule "Sojourn PullStart":
    @Event playerTookDamage
    @Team 2
    @Condition attacker == getPlayersOnHero(Hero.SOJOURN, Team.1)
    @Condition eventAbility == Button.ABILITY_2
    
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), SojoRnPullLMao), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.startFacing(vect(random.choice([-1, 1]), 0, 0), 10000, Relativity.TO_PLAYER)
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    eventPlayer.stopFacing()


rule "Sojourn AutoLaser":
    @Event eachPlayer
    @Team 1
    @Hero sojourn
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isUsingUltimate()) == true
    
    wait(0.25 if eventPlayer.isUsingUltimate() else 0.5)
    eventPlayer.IndividualVar2 = true
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    createBeam(getPlayers(Team.1), Beam.GOOD, eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 50, null, eventPlayer, true), Color.WHITE, EffectReeval.VISIBILITY)
    eventPlayer.IndividualVar = getLastCreatedEntity()
    wait(0.1)
    eventPlayer.IndividualVar2 = false
    wait(0.4)
    destroyEffect(eventPlayer.IndividualVar)
    if ruleCondition:
        loop()


rule "Sojorn LaserDMg":
    @Event eachPlayer
    @Team 2
    @Condition isInLoS(getPlayersOnHero(Hero.SOJOURN, Team.1), eventPlayer) == true
    @Condition getPlayersOnHero(Hero.SOJOURN, Team.1).isInViewAngle(eventPlayer, 3) == true
    @Condition eventPlayer.isAlive() == true
    @Condition getPlayersOnHero(Hero.SOJOURN, Team.1).IndividualVar2 == true
    
    damage(eventPlayer, getPlayersOnHero(Hero.SOJOURN, Team.1), 90)


rule "Soldier MultiTarget":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.SOLDIER, Team.1).isFiringSecondaryFire() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isInLoS(getPlayersOnHero(Hero.SOLDIER, Team.1), eventPlayer) == true
    @Condition getPlayersOnHero(Hero.SOLDIER, Team.1).isInViewAngle(eventPlayer, 80) == true
    
    createHomingProjectile(Projectile.BAPTISTE_BIOTIC_LAUNCHER, getPlayersOnHero(Hero.SOLDIER, Team.1), getPlayersOnHero(Hero.SOLDIER, Team.1).getEyePosition(), directionTowards(getPlayersOnHero(Hero.SOLDIER, Team.1).getEyePosition(), eventPlayer), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 80, 1, 3, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 60, 2, 3, eventPlayer)


rule "Soldier ULT":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.SOLDIER, Team.1).isFiringPrimaryFire() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isInLoS(getPlayersOnHero(Hero.SOLDIER, Team.1), eventPlayer) == true
    @Condition getPlayersOnHero(Hero.SOLDIER, Team.1).isUsingUltimate() == true
    @Condition getPlayersOnHero(Hero.SOLDIER, Team.1).isInViewAngle(eventPlayer, 80) == true
    
    damage(eventPlayer, getPlayersOnHero(Hero.SOLDIER, Team.1), 20)
    wait(0.1)
    if ruleCondition:
        loop()


rule "Soldier Speed":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition gameStatus == true
    
    eventPlayer.setMoveSpeed(200)
    getPlayersInRadius(eventPlayer, 13, Team.1, LosCheck.SURFACES).setAmmo(0, 76)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 26)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 99999)
    eventPlayer.setMoveSpeed(100)


rule "Sombra Hack":
    @Event eachPlayer
    @Team 2
    @Condition isHeroBeingPlayed(Hero.SOMBRA, Team.1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    
    createEffect(getPlayers(Team.1), Effect.ECHO_CLONING, Color.WHITE, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 99999)
    destroyEffect(getLastCreatedEntity())
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "Sombra TP HACK":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    playEffect(getPlayers(Team.1), DynamicEffect.SOMBRA_EMP_EXPLOSION_EFFECT, Color.WHITE, eventPlayer.getPosition(), 15)
    getPlayersInRadius(eventPlayer, 15, Team.2, LosCheck.SURFACES).setStatusEffect(eventPlayer, Status.HACKED, 3)
    if eventPlayer.infectionLvl > 0:
        eventPlayer.infectionLvl = 0


rule "Sombra DPS":
    @Event playerDealtDamage
    @Team 1
    @Hero sombra
    @Condition eventAbility != null
    @Condition victim.hasStatus(Status.HACKED) == true
    
    victim.startDamageOverTime(eventPlayer, 2, 12)


rule "Sombra ULT":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.SOMBRA, Team.1).isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    
    damage(eventPlayer, getPlayersOnHero(Hero.SOMBRA, Team.1), eventPlayer.getHealth() - eventPlayer.getMaxHealth() / 2)
    eventPlayer.setStatusEffect(null, Status.HACKED, 5)


rule "Symmetra Proton":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition gameStatus == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    if eventPlayer.IndividualVar == true:
        goto lbl_0
    createProjectileEffect(getPlayers(Team.1), Projectile.SYMMETRA_PHOTON_PROJECTOR, getPlayers(Team.1), eventPlayer.IndividualVar, null, 0.1, ProjectileEffectReeval.VISIBILITY_POSITION_DIRECTION_AND_SIZE)
    lbl_0:
    eventPlayer.IndividualVar = eventPlayer.getEyePosition()
    eventPlayer.IndividualVar2 = eventPlayer.getFacingDirection()
    eventPlayer.Individualvar3 = 5
    chaseAtRate(eventPlayer.Individualvar3, 0, 1)
    #wait(3)


rule "Symetra Photon fLIGHT":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.Individualvar3 > 0
    
    eventPlayer.IndividualVar = eventPlayer.IndividualVar + eventPlayer.IndividualVar2 * 0.264
    wait()
    if ruleCondition:
        loop()
    eventPlayer.IndividualVar = vect(10000, 10000, 10000)


rule "Symmetra Photon Damage":
    @Event eachPlayer
    @Team 2
    @Condition isInLoS(getPlayersOnHero(Hero.SYMMETRA, Team.1).IndividualVar, eventPlayer) == true
    @Condition distance(getPlayersOnHero(Hero.SYMMETRA, Team.1).IndividualVar, eventPlayer) <= 10
    @Condition eventPlayer.isAlive() == true
    @Condition getPlayersOnHero(Hero.SYMMETRA, Team.1).Individualvar3 > 0
    
    createHomingProjectile(Projectile.SYMMETRA_PHOTON_PROJECTOR, getPlayersOnHero(Hero.SYMMETRA, Team.1), getPlayersOnHero(Hero.SYMMETRA, Team.1).IndividualVar, directionTowards(getPlayersOnHero(Hero.SYMMETRA, Team.1).IndividualVar, eventPlayer.getEyePosition()), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 50, 1.5, 0, DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR, DynamicEffect.EXPLOSION_SOUND, 0.03, 50, 2, 0, eventPlayer)
    wait(0.1 if getPlayersOnHero(Hero.SYMMETRA, Team.1).isUsingUltimate() else 0.25)
    if ruleCondition:
        loop()


rule "Torb Godzilla":
    @Event eachPlayer
    @Team 1
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    
    eventPlayer.startScalingSize(3, false)
    eventPlayer.setDamageDealt(200)
    eventPlayer.addHealthPool(Health.ARMOR, 250, true)
    eventPlayer.IndividualVar = getLastCreatedHealthPool()
    waitUntil(eventPlayer.getCurrentWeapon() == 1, 99999)
    eventPlayer.startScalingSize(1, false)
    eventPlayer.setDamageDealt(100)
    removeHealthPool(eventPlayer.IndividualVar)


rule "Torb The Engineer":
    @Event eachPlayer
    @Team 1
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    heal(getPlayersInRadius(eventPlayer, 5, Team.1).exclude(eventPlayer), eventPlayer, 100)
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, 10)


rule "Torb Burn":
    @Event playerDealtDamage
    @Team 1
    @Hero torbjorn
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.BURNING, 3)
    victim.startDamageOverTime(eventPlayer, 3, 50)


rule "Tracer Ultcharge":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 15)
    eventPlayer.setAmmo(0, 80)
    heal(eventPlayer, eventPlayer, 200)


rule "Tracer Explode":
    @Event playerDealtDamage
    @Team 1
    @Hero tracer
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10
    @Condition victim != eventPlayer
    
    wait(1)
    playEffect(getPlayers(Team.1), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.WHITE, victim, 10)
    damage(getPlayersInRadius(victim, 15, Team.2, LosCheck.SURFACES), eventPlayer, 350)


rule "Venture DIG":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.VENTURE, Team.1).isUsingAbility1() == true
    @Condition distance(getPlayersOnHero(Hero.VENTURE, Team.1), eventPlayer) <= 1.3
    @Condition eventPlayer in bosses != true
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.VENTURE, Team.1), Status.STUNNED, 0.1)
    eventPlayer.disableEnvironmentCollision(true)
    wait(1)
    eventPlayer.enableEnvironmentCollision()


rule "VENTURE EFFECT":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    destroyEffect(eventPlayer.IndividualVar)
    createEffect(getPlayers(Team.1), Effect.RING, Color.WHITE, eventPlayer.getPosition(), 1.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.IndividualVar = getLastCreatedEntity()
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    destroyEffect(eventPlayer.IndividualVar)


rule "Venture DASH Throught walls?":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.5)
    eventPlayer.disableEnvironmentCollision(false)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    wait(0.5)
    eventPlayer.enableEnvironmentCollision()


rule "Venture No CD":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAmmo() > 0
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 3)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() - 1)


rule "WIDOWMAKER grapling hook stick":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0, 0.5)
    if eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0:
        return
    if eventPlayer.getAltitude() < 1:
        return
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.01, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.invisible++
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), 12)
    eventPlayer.setGravity(100)
    eventPlayer.stopForcingThrottle()
    eventPlayer.invisible--


rule "WIDOWMAKER WALLHACKSSSSSSSSS":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    damage(eventPlayer.getPlayersInViewAngle(Team.2, 3), eventPlayer, eventPlayer.IndividualVar2)
    createBeam(getPlayers(Team.1), Beam.BAD, eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, Color.PURPLE, EffectReeval.VISIBILITY)
    eventPlayer.IndividualVar = getLastCreatedEntity()
    wait(0.5)
    destroyEffect(eventPlayer.IndividualVar)


rule "WIDOWMAKER Charge":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.IndividualVar2 = 0
    chaseAtRate(eventPlayer.IndividualVar2, 750, 750)
    waitUntil(eventPlayer.isFiringPrimaryFire() or not eventPlayer.isFiringSecondaryFire(), 50)
    wait(0.5)
    if ruleCondition:
        loop()


rule "WIDOWMAKER ULT Charge":
    @Event playerDealtDamage
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.IndividualVar2 == 500
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 20)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 35)


rule "Winton Barrier":
    @Event eachPlayer
    @Team 1
    @Hero winston
    @Condition eventPlayer.isUsingAbility2() == true
    
    if eventPlayer.IndividualVar == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.SPHERE, Color.SKY_BLUE, eventPlayer.IndividualVar, eventPlayer.IndividualVar2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:
    eventPlayer.IndividualVar = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + Vector.DOWN * 50, null, eventPlayer, true)
    eventPlayer.IndividualVar2 = 1
    chaseAtRate(eventPlayer.IndividualVar2, 7.5, 7.5)
    eventPlayer.startScalingBarriers(eventPlayer.IndividualVar2 / 5)
    wait(8)
    eventPlayer.IndividualVar = vect(10000, 10000, 10000)


rule "Winton Barrier Push":
    @Event eachPlayer
    @Team 2
    @Condition distance(getPlayersOnHero(Hero.WINSTON, Team.1).IndividualVar, eventPlayer) <= getPlayersOnHero(Hero.WINSTON, Team.1).IndividualVar2
    @Condition eventPlayer.isAlive() == true
    @Condition getPlayersOnHero(Hero.WINSTON, Team.1).IndividualVar == true
    
    eventPlayer.applyImpulse(directionTowards(getPlayersOnHero(Hero.WINSTON, Team.1).IndividualVar, eventPlayer), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1)
    if ruleCondition:
        loop()


rule "Winton Stun":
    @Event playerDealtDamage
    @Team 1
    @Hero winston
    @Condition victim.hasStatus(Status.STUNNED) == false
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition victim in bosses != true
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.1)
    heal(victim, null, eventDamage)


rule "Winton Primal":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.WINSTON, Team.1).isUsingUltimate() == true
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.getMaxHealth() / 2, true)
    eventPlayer.WintonOvh = getLastCreatedHealthPool()
    eventPlayer.startHealingOverTime(getPlayersOnHero(Hero.WINSTON, Team.1), 5, eventPlayer.getMaxHealth() / 5)
    waitUntil(not getPlayersOnHero(Hero.WINSTON, Team.1).isUsingUltimate(), 12)
    removeHealthPool(eventPlayer.WintonOvh)


rule "WreckingBallz Kncok":
    @Event playerDealtDamage
    @Team 1
    @Hero wreckingBall
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.MELEE
    @Condition eventAbility != null
    
    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1.5)
    eventPlayer.setAbilityCooldown(Button.CROUCH, eventPlayer.getAbilityCooldown(Button.CROUCH) - 1)


rule "WreckingBallz SPEED":
    @Event eachPlayer
    @Team 1
    @Hero wreckingBall
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setMoveSpeed(175)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setMoveSpeed(100)


rule "Wreckingball Phased":
    @Event eachPlayer
    @Team 1
    @Hero wreckingBall
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setKnockbackReceived(0)
    getPlayersInRadius(eventPlayer, 13, Team.2).setStatusEffect(eventPlayer, Status.STUNNED, 2.5)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer, 26)
    eventPlayer.disablePlayerCollision()
    eventPlayer.IndividualVar = true
    wait(0.1)
    eventPlayer.IndividualVar = false
    wait(6.9)
    eventPlayer.enablePlayerCollision()
    eventPlayer.setKnockbackReceived(100)


rule "WUYANG Bubble":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.BubbleYang == true
    @Condition eventPlayer.isAlive() == true
    
    createEffect(getPlayers(Team.1).exclude(eventPlayer), Effect.SPHERE, Color.SKY_BLUE, eventPlayer, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.BubbleEffect = getLastCreatedEntity()
    wait(1.5)
    destroyEffect(eventPlayer.BubbleEffect)
    getPlayersInRadius(eventPlayer, 5, Team.2).setStatusEffect(getPlayersOnHero(Hero.WUYANG, Team.1), Status.KNOCKED_DOWN, 2.5)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, eventPlayer, 5)
    eventPlayer.BubbleYang = false


rule "WUYANG Secondary":
    @Event eachPlayer
    @Team 1
    @Hero wuyang
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(Team.1)) <= 20
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(Team.1)) == true
    #@Condition eventPlayer.getPlayerClosestToReticle(Team.1).BubbleYang != true
    
    eventPlayer.getPlayerClosestToReticle(Team.1).BubbleYang = true


rule "WUYANG WAVE":
    @Event playerTookDamage
    @Team 2
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer in bosses != true
    @Condition attacker == getPlayersOnHero(Hero.WUYANG, Team.1)
    @Condition isHeroBeingPlayed(Hero.WUYANG, Team.1) == true
    
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.WUYANG, Team.1), Status.KNOCKED_DOWN, 1.5)
    eventPlayer.startFacing(vect(random.choice([-1, 1]), 0, 0), 10000, Relativity.TO_PLAYER)
    wait(3)
    eventPlayer.stopFacing()


rule "WUYANG ULT":
    @Event playerTookDamage
    @Team 2
    @Condition eventAbility == Button.ULTIMATE
    @Condition isHeroBeingPlayed(Hero.WUYANG, Team.1) == true
    @Condition attacker == getPlayersOnHero(Hero.WUYANG, Team.1)
    @Condition eventPlayer in bosses != true
    
    eventPlayer.size /= 4
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.setDamageDealt(0)
    eventPlayer.setMoveSpeed(50)


rule "Zarya HPBuffself":
    @Event eachPlayer
    @Team 1
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1() == true
    
    if eventPlayer.ZaryaHP == 0:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.ZaryaHP, true)
    eventPlayer.ZaryaHP += 25
    heal(eventPlayer, null, 100)
    createHomingProjectile(Projectile.ROADHOG_SCRAP, null, eventPlayer.getEyePosition() + Vector.UP, Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.1, 200, 1, 1, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 25, 1, 0, eventPlayer)


rule "Zarya HPBuffOther":
    @Event eachPlayer
    @Team 1
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2() == true
    
    createProjectile(Projectile.ZARYA_GRAVITON, eventPlayer, eventPlayer.getPlayerClosestToReticle(Team.1), Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 50, 1, 10, DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 100, 0.1, 25)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 1)


rule "Zarya BlackHole":
    @Event playerDealtDamage
    @Team 1
    @Hero zarya
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    createProjectile(Projectile.ZARYA_GRAVITON, eventPlayer, victim.getEyePosition() + vect(random.randint(-3, 3), 0, random.randint(-3, 3)), null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.2, 20, 1, 4, DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, DynamicEffect.BUFF_EXPLOSION_SOUND, 0.15, 0.1, 0.5, 5)


rule "Zenyatta Orb+":
    @Event eachPlayer
    @Team 1
    @Hero zenyatta
    @Condition eventPlayer.isUsingAbility1() == true
    
    if eventPlayer.IndividualVar == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.RING, Color.YELLOW, eventPlayer.IndividualVar, 5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:
    eventPlayer.IndividualVar = eventPlayer.getPlayerClosestToReticle(Team.1)


rule "Zenyatta orb+ Lifesteal":
    @Event playerDealtDamage
    @Team 1
    @Condition getPlayersOnHero(Hero.ZENYATTA, Team.1).IndividualVar == eventPlayer
    
    heal(eventPlayer, getPlayersOnHero(Hero.ZENYATTA, Team.1), eventDamage)


rule "Zenyatta Orb + Bubble":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.ZENYATTA, Team.1).IndividualVar == true
    @Condition distance(getPlayersOnHero(Hero.ZENYATTA, Team.1).IndividualVar, eventPlayer) <= 5
    
    eventPlayer.applyImpulse(directionTowards(getPlayersOnHero(Hero.ZENYATTA, Team.1).IndividualVar, eventPlayer), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1)
    if ruleCondition:
        loop()


rule "Zenyatta Discord":
    @Event eachPlayer
    @Team 1
    @Hero zenyatta
    @Condition eventPlayer.isUsingAbility2() == true
    
    if eventPlayer.IndividualVar2 == true:
        goto lbl_0
    createEffect(getPlayers(Team.1), Effect.BAD_AURA, Color.PURPLE, eventPlayer.IndividualVar2, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_0:
    eventPlayer.IndividualVar2 = eventPlayer.getPlayerClosestToReticle(Team.2)
    wait(7, Wait.RESTART_WHEN_TRUE)
    eventPlayer.IndividualVar2 = vect(10000, 10000, 10000)


rule "Zenyatta Discord Lifesteal":
    @Event playerTookDamage
    @Team 2
    @Condition getPlayersOnHero(Hero.ZENYATTA, Team.1).IndividualVar2 == eventPlayer
    @Condition eventPlayer.isAlive() == true
    
    heal(attacker, getPlayersOnHero(Hero.ZENYATTA, Team.1), eventDamage)


rule "Description Start":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.hasSpawned() == true
    
    wait(1)
    startRule(ModDesc)


def ModDesc():
    @Name "Text"
    
    #Desc
    createInWorldText(eventPlayer, "{0}".format(eventPlayer.Text), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1 + worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION) + worldVector(Vector.UP, eventPlayer, Transform.ROTATION) * 0, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    eventPlayer.TextId = getLastCreatedText()
    #F to hide
    createInWorldText(eventPlayer, "Hold Interact [F] to hide or show this:", eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1 + worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION) + worldVector(Vector.UP, eventPlayer, Transform.ROTATION) * 0.1, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW)
    eventPlayer.Fhidetext = getLastCreatedText()
    if eventPlayer.getHero() == Hero.ANA:
        eventPlayer.Text = "Taking dmg will grant heal, speed and jump , {0}Hit reduce all cd and +{1}%, {1} give inf ult for whole team for ult duration".format(abilityIconString(Hero.ANA, Button.ABILITY_1), abilityIconString(Hero.ANA, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.ASHE:
        eventPlayer.Text = "{0}ADS Immobilize Enemy; Dealing damage hit target 2x and reduce {1} CD".format(iconString(Icon.EYE), abilityIconString(Hero.ASHE, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.BAPTISTE:
        eventPlayer.Text = "{0}Gives Immortal to all Allies; Primary and Secondary shoots additional Biotic bullet that deal dmg and heal".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.BASTION:
        eventPlayer.Text = "{2} Knockback Enemy nearby, {1}While{2} reset CD and Increase Speed  ; {0} Leaves a bombing area for 10 seconds ".format(abilityIconString(Hero.BASTION, Button.ULTIMATE), abilityIconString(Hero.BASTION, Button.SECONDARY_FIRE), abilityIconString(Hero.BASTION, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.BRIGITTE:
        eventPlayer.Text = "{1}Inspire Knock Enemy Back{0}Reset all ability cooldown of target; {2} Player near Brig gain healing instead when taking dmg".format(abilityIconString(Hero.BRIGITTE, Button.ABILITY_2), iconString(Icon.PLUS), abilityIconString(Hero.BRIGITTE, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.CASSIDY:
        eventPlayer.Text = "Dealing damage will increase {0}stacks and deal additional {0}stack damage; Crit hit more{0} ;{2}Instantly Deal 3x Stack Damage ".format(iconString(Icon.SKULL), null, abilityIconString(Hero.CASSIDY, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.DVA:
        eventPlayer.Text = "{0} Push Enemies Away; {1} Knock Enemy and Gain {2}%; {2} After Ulting, Become Invisible to zombie short time ".format(abilityIconString(Hero.DVA, Button.SECONDARY_FIRE), abilityIconString(Hero.DVA, Button.ABILITY_1), abilityIconString(Hero.DVA, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.DOOMFIST:
        eventPlayer.Text = "Any Skill damage Knockdown enemies; {0}Gain temporary Armor to nearby Teamate".format(abilityIconString(Hero.DOOMFIST, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.ECHO:
        eventPlayer.Text = "Dealing Damage add 5% of enemy HP as additional Dmg; {0} Scale size with your current HP ".format(abilityIconString(Hero.ECHO, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.FREJA:
        eventPlayer.Text = "After Sticking bolt to enemy, Shoot 3 Arrow to the target ; {0} Increase your damage dealt everytime you Ult".format(abilityIconString(Hero.FREJA, Button.PRIMARY_FIRE))
    elif eventPlayer.getHero() == Hero.GENJI:
        eventPlayer.Text = "{0}Skill Hit will reset CD,gain ammo and Short Immune ;{2} Shoots Shurikens,spends ammo {1} Icrease Damage by A lot".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), abilityIconString(Hero.GENJI, Button.ULTIMATE), abilityIconString(Hero.GENJI, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.HANZO:
        eventPlayer.Text = "Damage hit will Explode; Hold Right-click then JUMP to TP to location (Uses Lunge CD)"
    elif eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.Text = "{0}Reset on hit, after 3 time hitting without landing, gain 25% UltCharge; {1} Enemy near wall will pullled towards Wall".format(abilityIconString(Hero.HAZARD, Button.ABILITY_1), abilityIconString(Hero.HAZARD, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.ILLARI:
        eventPlayer.Text = "Dealing damage mark enemy, marked enemy explode when taking damage; Every 500 heal increase {0}, {0} increase explode dmg n heal".format(iconString(Icon.HEART))
    elif eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        eventPlayer.Text = "Primary tirggers Bleed, When dealing ability damage to Bleed player, they Explode and reset {0}Cd".format(abilityIconString(Hero.JUNKER_QUEEN, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.JUNKRAT:
        eventPlayer.Text = "{0} Enemy Died drop Bomb; {1} Damage Explode the victim; {2} TP Nearby Enemy; Crouch to= (+)Dmg, (-)Projectile Speed".format(iconString(Icon.SPIRAL), abilityIconString(Hero.JUNKRAT, Button.ULTIMATE), abilityIconString(Hero.JUNKRAT, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.JUNO:
        eventPlayer.Text = "{0} Ally hits will gain Short Invulnerability while enemy hits will make them Vulnerable; {1} Give All Player Speed & Jump Boost".format(abilityIconString(Hero.JUNO, Button.SECONDARY_FIRE), abilityIconString(Hero.JUNO, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.KIRIKO:
        eventPlayer.Text = "{0}{1}Gives Vaccine(Player with Vaccine will gain short immunity when taking damage or reduce the infection)".format(abilityIconString(Hero.KIRIKO, Button.ABILITY_1), abilityIconString(Hero.KIRIKO, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.LIFEWEAVER:
        eventPlayer.Text = "Primary Heal Knockback Nearby Enemies; {0} Create a Safezone, Zombie cant Move in there; {1} GIves 500 Stackable Overhealth ".format(abilityIconString(Hero.LIFEWEAVER, Button.ULTIMATE), abilityIconString(Hero.LIFEWEAVER, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.LUCIO:
        eventPlayer.Text = "{0} Gives Nearby Ally 50 Stackable Overhealth ; {1} Speed boost increase Speed, Heal boost Reduce damage taken to nearby allies".format(abilityIconString(Hero.LUCIO, Button.SECONDARY_FIRE), abilityIconString(Hero.LUCIO, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.Text = "{0} Enemy will Stick to Mauga; {1} Tp Enemies in LOS to Cage and gain Immunity".format(abilityIconString(Hero.MAUGA, Button.ABILITY_1), abilityIconString(Hero.MAUGA, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.MEI:
        eventPlayer.Text = "Full CC Heroes here. {0}{1} Freeze Nearby Enemies; Secondary Hits Freeze Too!".format(abilityIconString(Hero.MEI, Button.ABILITY_1), abilityIconString(Hero.MEI, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.MERCY:
        eventPlayer.Text = "{0}Souls Fly to you; Dmg Boost Give ult Charge ,{1} will come with machine gun".format(abilityIconString(Hero.MERCY, Button.ABILITY_1), abilityIconString(Hero.MERCY, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.MOIRA:
        eventPlayer.Text = "{0} Have Infinite Range and Spawn Damage Orbs, {1} Spawns Homing Heal Orb, Ult Shoots alotta Balls".format(abilityIconString(Hero.MOIRA, Button.SECONDARY_FIRE), abilityIconString(Hero.MOIRA, Button.PRIMARY_FIRE))
    elif eventPlayer.getHero() == Hero.ORISA:
        eventPlayer.Text = "{0}{1}{2}Increase Armor by 15 and damage 5% of Orisa Hp to nearby enemies ; ULT Bring Enemies to You".format(abilityIconString(Hero.ORISA, Button.ABILITY_1), abilityIconString(Hero.ORISA, Button.ABILITY_2), abilityIconString(Hero.ORISA, Button.SECONDARY_FIRE))
    elif eventPlayer.getHero() == Hero.PHARAH:
        eventPlayer.Text = "Hitting Primary Fire Shoots 2 Homing Rockets and Reduce {1} CD; {0} After Ulting shoot A NUKE!! :o".format(abilityIconString(Hero.PHARAH, Button.ULTIMATE), abilityIconString(Hero.PHARAH, Button.PRIMARY_FIRE))
    elif eventPlayer.getHero() == Hero.RAMATTRA:
        eventPlayer.Text = "Shield Stun Enemies ; {0} and {1} Gain 1000 HP and increase size; {2} Dealing Damage gain 10 Armor".format(abilityIconString(Hero.RAMATTRA, Button.ABILITY_1), abilityIconString(Hero.RAMATTRA, Button.ULTIMATE), abilityIconString(Hero.RAMATTRA, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.REAPER:
        eventPlayer.Text = "{0}Can Fly and Go Through walls; {1}Can be Use even not Full minimum 10% and gain immune".format(abilityIconString(Hero.REAPER, Button.ABILITY_1), abilityIconString(Hero.REAPER, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.REINHARDT:
        eventPlayer.Text = "{0} Gain Immunity and stick zombies on shield ; Primary and {1} Stun Enemies".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), abilityIconString(Hero.REINHARDT, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.ROADHOG:
        eventPlayer.Text = "{0}Damage Will Create Hole that affect Everyone, killing anyone with this hole reset {0} CD; {1}Can Float A short time".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), abilityIconString(Hero.ROADHOG, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.SIGMA:
        eventPlayer.Text = "{0}Push Enemies and Stun them when u stop;{1} Enemy Close will got tp somewhere and knocked down; Primary shoots Alot".format(abilityIconString(Hero.SIGMA, Button.SECONDARY_FIRE), abilityIconString(Hero.SIGMA, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.SOJOURN:
        eventPlayer.Text = "Primary Fire Shoots Laser , Ult Laser Faster; {0} Make Enemy Spin and suck inside".format(abilityIconString(Hero.SOJOURN, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.SOLDIER:
        eventPlayer.Text = "{0} Holding SHIFT Increase your Speed and Grant nearby Allies 76 Ammo; {1} and {2} Target Everyone you see ".format(abilityIconString(Hero.SOLDIER, Button.ABILITY_1), abilityIconString(Hero.SOLDIER, Button.SECONDARY_FIRE), abilityIconString(Hero.SOLDIER, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.SOMBRA:
        eventPlayer.Text = "Hacked zom Disarmed , {1} Hack area after tp ; {0} Hack All and cut Half Zombie HP ; Deal Dmg to hacked zombie deal Stacking DPS".format(abilityIconString(Hero.SOMBRA, Button.ULTIMATE), abilityIconString(Hero.SOMBRA, Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.SYMMETRA:
        eventPlayer.Text = "Full Charge Secondary Summon Photon that Travel and Shoot Nearby Enemies, {0} Photon Shoot more often".format(abilityIconString(Hero.SYMMETRA, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.TORBJORN:
        eventPlayer.Text = "Holding Hammer Increase Size, Damage and Grant Armor. Hammer can Heal nearby allies. Dealing Damage Burn Enemies"
    elif eventPlayer.getHero() == Hero.TRACER:
        eventPlayer.Text = "{0}Increase Ult Charge by 15%,Heal and Refill Ammo; {1} Explode Twice".format(abilityIconString(Hero.TRACER, Button.ABILITY_1), abilityIconString(Hero.TRACER, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.VENTURE:
        eventPlayer.Text = "{0} Enemy Above Venture will fall; {1} Can go through walls, spent Ammo and Have no CD if you have ammo ".format(abilityIconString(Hero.VENTURE, Button.ABILITY_1), abilityIconString(Hero.VENTURE, Button.SECONDARY_FIRE))
    elif eventPlayer.getHero() == Hero.WIDOWMAKER:
        eventPlayer.Text = "{0}Stick to Walls and Gain Invisibility; Full Charge Hits Gain More Ult Charge; {1} Can Shoot Through Walls; ".format(abilityIconString(Hero.WIDOWMAKER, Button.ABILITY_1), abilityIconString(Hero.WIDOWMAKER, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.WINSTON:
        eventPlayer.Text = "Primary Electrocuted enemies but has no damage; {0} Prevent Enemies from Coming in; {1}Give allies 2x Hp of Allies and heal full".format(abilityIconString(Hero.WINSTON, Button.ABILITY_2), abilityIconString(Hero.WINSTON, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.WRECKING_BALL:
        eventPlayer.Text = "{0} Can go through Enemies and StunArea; Dealing damage Knock down Enemies and Reduce {1} Cd; Using grapple Increase Your Speed".format(abilityIconString(Hero.WRECKING_BALL, Button.ABILITY_2), abilityIconString(Hero.WRECKING_BALL, Button.CROUCH))
    elif eventPlayer.getHero() == Hero.WUYANG:
        eventPlayer.Text = "Secondary Give Mini Bubble that Explode and Knockdown Enemies; {1} Smallify Enemy, slow them and Cant deal damage;{0} SPIN".format(abilityIconString(Hero.WUYANG, Button.ABILITY_2), abilityIconString(Hero.WUYANG, Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.ZARYA:
        eventPlayer.Text = "{0}Self use Increase MaxHp and gain Resource;{0} Use on team Knock Back Nearby enemy and Gain 1 charge, Secondary Spawn Orb".format(abilityIconString(Hero.ZARYA, Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.ZENYATTA:
        eventPlayer.Text = "{0}Carrier Gain Lifesteal and personal space enemy cant get close; {1} Ally who deal dmg to discorded enemy Gain Hp equal DMg".format(abilityIconString(Hero.ZENYATTA, Button.ABILITY_1), abilityIconString(Hero.ZENYATTA, Button.ABILITY_2))
    wait(1)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == true, 99999)
    destroyInWorldText(eventPlayer.TextId)
    destroyInWorldText(eventPlayer.Fhidetext)
    wait(1)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == true, 99999)
    startRule(ModDesc)


rule "HOPPER (D.VA) JUMPS AROUND":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 15 * eventPlayer.size
    @Condition abs(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()))) < 15
    
    eventPlayer.setGravity(150)
    eventPlayer.movementSpeed *= 1.6
    eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeed)
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.lastTarget.getEyePosition()), 0 if eventPlayer.crowdControlled else 500 if eventPlayer.getHorizontalSpeed() < 3.5 * eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed else 60)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    #Hop amount
    for eventPlayer.pForceFieldCount2_bCount1 in range(8):
        eventPlayer.setJumpVerticalSpeed(110 + eventPlayer.pForceFieldCount2_bCount1 * 35)
        while eventPlayer.isAlive() and not eventPlayer.isInAir():
            waitUntil(not eventPlayer.crowdControlled, 99999)
            eventPlayer.forceButtonPress(Button.JUMP)
            wait()
        wait(0.5)
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isDead() or eventPlayer.isInAlternateForm() or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.crowdControlled, 99999)
        if eventPlayer.isDead() or eventPlayer.isInAlternateForm() or eventPlayer.hasStatus(Status.HACKED) or eventPlayer.crowdControlled:
            break
    eventPlayer.setGravity(100)
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.movementSpeed /= 1.6
    eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeed)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    wait(5)
    if ruleCondition:
        loop()


rule "HOPPER DIES TO ENVIRONMENT":
    @Event playerDied
    @Team 2
    @Hero dva
    @Condition eventWasEnvironment == true
    @Condition eventPlayer.botTempValue < 3
    
    #Indicate that remech is needed
    eventPlayer.botTempValue = 0


rule "HOPPER SPAWNS":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.botTempValue < 2
    
    #Indicate that D.Va may need to remech
    eventPlayer.botTempValue = 1
    #Boss only
    if eventPlayer in bosses:
        eventPlayer.setHealth(eventPlayer.bossHealth)
    if eventPlayer.isInAlternateForm():
        waitUntil(eventPlayer.isOnGround(), 99999)
        #Dva Invincible bug?
        eventPlayer.setDamageReceived(100)
        #Always remech
        while eventPlayer.isInAlternateForm():
            eventPlayer.setUltCharge(100)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.25)
        waitUntil(not eventPlayer.isUsingUltimate(), 3.1)
    eventPlayer.setDamageReceived(100)
    #D.Va is in mech
    eventPlayer.botTempValue = 2
    #Boss only
    if eventPlayer in bosses:
        eventPlayer.setHealth(eventPlayer.bossHealth)
    if ruleCondition:
        loop()


rule "HOPPER DEMECH INITIALIZATION":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.botTempValue == 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() == true
    
    #D.Va is in alternate form and does not need to remech
    eventPlayer.botTempValue = 3
    eventPlayer.movementSpeed *= 3
    eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeed)
    eventPlayer.disablePlayerCollision()
    eventPlayer.playerCollisionEnabled = false
    #Nightmare
    eventPlayer.health /= 2
    eventPlayer.size /= 1.25
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.applyImpulse(vect(0, 1, 0), 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    waitUntil(eventPlayer.isInAlternateForm(), 5)
    wait(0.25)
    if eventPlayer in bosses:
        eventPlayer.bossHealth = eventPlayer.health
        #Adjust recorded boss height
        bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())


rule "HOPPER DEMECH CONTROL":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer.botTempValue == 3
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isInAlternateForm() == true
    
    eventPlayer.specialFacing = true
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), 0 if eventPlayer.crowdControlled else 500 if eventPlayer.getHorizontalSpeed() < 3.5 * eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed else 100)
    eventPlayer.specialThrottling = true
    eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)
    waitUntil(eventPlayer.botTarget == null, 99999)
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)
    if ruleCondition:
        loop()


rule "Hooper BOMB":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.botTempValue > 1
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.25
    @Condition eventPlayer in bosses != true
    
    eventPlayer.setUltCharge(100)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(1)
    if ruleCondition:
        loop()


rule "Bomber Ult":
    @Event eachPlayer
    @Team 2
    @Hero junkrat
    @Condition eventPlayer.isAlive() == true
    @Condition zombieSetting == 7
    
    wait(1)
    eventPlayer.setUltCharge(100)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(random.randint(1, 7))
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(5)
    if ruleCondition:
        loop()


rule "Hopper BOSS":
    @Event eachPlayer
    @Team 2
    @Hero dva
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.01
    
    eventPlayer.setUltCharge(100)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    eventPlayer.startScalingSize(eventPlayer.size * 2)
    eventPlayer.botTempValue = 3
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "HOPPER BOMB SPIN":
    @Event playerTookDamage
    @Team 1
    @Condition eventAbility == Button.ULTIMATE
    @Condition attacker == getPlayersOnHero(Hero.DVA, Team.2)
    
    heal(eventPlayer, null, eventDamage / 2)
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.DVA, Team.2), Status.STUNNED, 0.5)
    eventPlayer.startFacing(vect(1, 0, 0), 10000, Relativity.TO_PLAYER)
    wait(1)
    eventPlayer.stopFacing()


rule "NANOMANCER (RAMATTRA) FIRES NANITE SWARM":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.botTempValue != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 25
    
    if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.specialThrottling = true
        eventPlayer.stopThrottleInDirection()
        eventPlayer.specialFacing = true
        eventPlayer.startFacing(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition() + vect(0, 1 * eventPlayer.botTarget.size, 0))) + 3 * (sinDeg(getTotalTimeElapsed() * 150)), verticalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition() + vect(0, 1 * eventPlayer.botTarget.size, 0)))), 0 if eventPlayer.crowdControlled else 200)
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setProjectileSpeed(10)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    waitUntil(eventPlayer.botTarget == null or eventPlayer.isUsingAbility1(), 1)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.damageOverTimeDuration = max(eventPlayer.damageOverTimeDuration, 10)
    eventPlayer.specialThrottling = false
    eventPlayer.specialFacing = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


rule "NANOMANCER TRANSFORMS":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 12 * eventPlayer.size
    @Condition eventPlayer in bosses != true
    
    waitUntil(eventPlayer.botTarget != null and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 5 * eventPlayer.size, 3)
    if eventPlayer.botTarget == null or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) >= 12 * eventPlayer.size:
        return
    eventPlayer.botTempValue = true
    #Non-bosses get increased health
    if not eventPlayer in bosses:
        eventPlayer.health *= 3
        eventPlayer.startHealingOverTime(null, 3, (eventPlayer.health - eventPlayer.getHealth()) / 3)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.damageDealt /= 1
    eventPlayer.setDamageDealt(eventPlayer.damageDealt * 100)
    while eventPlayer.botTarget != null and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 12 * eventPlayer.size:
        while not eventPlayer.isUsingAbility1():
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            waitUntil(eventPlayer.isUsingAbility1(), 0.25)
        waitUntil(not eventPlayer.isUsingAbility1(), 30)
        wait(0.125)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.damageDealt *= 1
    eventPlayer.setDamageDealt(eventPlayer.damageDealt * 100)
    if not eventPlayer in bosses:
        eventPlayer.health /= 6
    eventPlayer.botTempValue = false
    wait(6)
    if ruleCondition:
        loop()


rule "NANOMANCER PUNCHES IN NEMESIS FORM":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.botSpecialTarget != true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 8 * eventPlayer.size
    @Condition eventPlayer in bosses != true
    
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.6)
    if ruleCondition:
        loop()


rule "NANOMANCER BOSS":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.9
    
    eventPlayer.startHealingOverTime(eventPlayer, 10, 250)
    RamBOSSS = eventPlayer
    eventPlayer.setUltCharge(100)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getEyePosition(), 50)
    wait(3.5)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getEyePosition(), 50)
    wait(3.5)
    playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getEyePosition(), 50)
    if ruleCondition:
        loop()


rule "NANOMANCER BOSS Chain Effect":
    @Event eachPlayer
    @Team 1
    @Condition isInLoS(RamBOSSS, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS) == true
    @Condition RamBOSSS.isUsingUltimate() == true
    
    createBeam(getPlayers(Team.1), Beam.JUNKRAT_TRAP_CHAIN, RamBOSSS.getEyePosition(), eventPlayer, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.RAMMATRACHAIN = getLastCreatedEntity()
    waitUntil(not RamBOSSS.isUsingUltimate() or not isInLoS(RamBOSSS, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS), 99999)
    destroyEffect(eventPlayer.RAMMATRACHAIN)


rule "NANOMANCER PULL":
    @Event eachPlayer
    @Team 1
    @Condition distance(RamBOSSS, eventPlayer) >= 4
    @Condition isInLoS(RamBOSSS, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS) == true
    @Condition RamBOSSS.isUsingUltimate() == true
    
    eventPlayer.applyImpulse(directionTowards(eventPlayer, RamBOSSS.getEyePosition()), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
        loop()


rule "DAYTAKER Burst":
    @Event eachPlayer
    @Team 2
    @Hero illari
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.crowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(4)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    if ruleCondition:
        loop()


rule "DAYTAKER BURSTSpin":
    @Event playerTookDamage
    @Team 1
    @Condition getPlayersOnHero(Hero.ILLARI, Team.2) in bosses == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition attacker == getPlayersOnHero(Hero.ILLARI, Team.2)
    
    eventPlayer.startFacing(vect(1, 0, 0), 10000, Relativity.TO_PLAYER)
    wait(1)
    eventPlayer.stopFacing()


rule "STALKER Boss ORB":
    @Event eachPlayer
    @Team 2
    @Hero moira
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.crowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.5)
    if random.randint(1, 10) <= 3:
        loop()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)


rule "BLASTER FLYING":
    @Event eachPlayer
    @Team 2
    @Hero pharah
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.crowdControlled == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(2)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(2)
    if ruleCondition:
        loop()


rule "BEHEMOTH BLIDNING":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.ROADHOG, Team.2) in bosses == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(RamBOSSS, eventPlayer) <= 30
    @Condition RamBOSSS == true
    
    createEffect(eventPlayer, Effect.BAD_AURA, Color.LIME_GREEN, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 3, 30, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.BLINDAF = getLastCreatedEntity()
    #DPS cloud
    eventPlayer.startDamageOverTime(RamBOSSS, 5, 10)
    getAllPlayers().startForcingOutlineFor(eventPlayer, false, Color.WHITE)
    wait(5)
    destroyEffect(eventPlayer.BLINDAF)
    getAllPlayers().stopForcingOutlineFor(eventPlayer)
    wait(3)
    if ruleCondition:
        loop()


rule "BEHEMOTH CLOUD EFFECT":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.95
    
    RamBOSSS = eventPlayer
    waitUntil(eventPlayer.getHealth() <= 100, 99999)
    RamBOSSS = false


rule "PLAYER Initialize when changing hero":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition gameStatus == true
    
    eventPlayer.IndividualVar = 0
    eventPlayer.IndividualVar2 = 0
    eventPlayer.stopScalingSize()
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.Individualvar3 = 0


rule "IM A GOD":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Disabled
    
    eventPlayer.setDamageDealt(1000)
    eventPlayer.setDamageReceived(1)
    #bosses.startForcingHero(Hero.ROADHOG)


rule "Sombra HackHeal":
    @Event eachPlayer
    @Team 1
    @Condition getPlayersOnHero(Hero.SOMBRA, Team.1).isFiringSecondaryFire() == true
    @Condition getPlayersOnHero(Hero.SOMBRA, Team.1).getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition distance(getPlayersOnHero(Hero.SOMBRA, Team.1), eventPlayer) <= 15
    @Delimiter
    


