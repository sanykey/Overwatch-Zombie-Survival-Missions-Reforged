#!mainFile "main.opy"

#!define BOT_MAX_TELEPORT_RANGE 40

# Enhancement IDs also index enhancementOptions and the default-setting choices.
# Zero means no preference in the menu; initialization resolves the configured default.
# If that setting is "No Enhancement", zero leaves the player without an enhancement.
enum Enhancement:
    NO_PREFERENCE = 0,
    KEVLAR = 1,
    ZOMBIE_HYBRID = 2,
    LASER_BARRICADE = 3,
    BRAIN_KILLER = 4,
    PYROTECHNIC = 5,
    PLAGUE_DOCTOR = 6,
    BORN_TO_BATTLE = 7,
    CHARGE_BATTERY = 8,
    HITCHHIKER = 9,
    PUP = 10,

#Global variables

# Shared scratch slots: assign before use and finish using them before any yield
# (wait/waitUntil or an async call), including inside loops and called macros.
# Reevaluated HUD/effect arguments must capture scratch values with evalOnce.
# Use distinct slots for values that are live at the same time.
# Document every tmp assignment, update and loop counter locally: what it stores and why.
globalvar tmp0
globalvar tmp1
globalvar tmp2

# Shared immutable colors and offsets.
globalvar colorKevlarConst = rgb(240, 129, 26)
globalvar colorChargeBatteryConst = rgb(236, 206, 44)
globalvar colorSatelliteUplinkConst = rgb(12, 129, 132)
globalvar offsetUpThreeQuartersConst = vect(0, 0.75, 0)
globalvar offsetUpHalfConst = vect(0, 0.5, 0)
globalvar dummyHoldingPositionConst = vect(500, 500, 500)

globalvar objectiveEntitiesCount
globalvar objectivePositions
globalvar walkCenter
globalvar objectiveCaptureValue
globalvar startPos
globalvar count2
globalvar specialEffectsStrings
globalvar playersOnObjective
globalvar testPos
globalvar testPos2
globalvar objectiveTypes
globalvar objectiveRad
globalvar reviveRadius
globalvar botHeros
globalvar chase1
globalvar gameSmolderEvent
globalvar gameStatus
globalvar startTime
globalvar mustReviveTime
globalvar supplyDropLanding
globalvar supplyDropPosition
globalvar powerUpIDs
globalvar powerUpPositions
globalvar supplyDropStatus
globalvar powerUpText
globalvar powerUpEffect
globalvar startCamPos
globalvar botSpawnRates
globalvar startMenuSpacingAngle
globalvar startCamDistance
globalvar overtime
globalvar challengeVotes
globalvar difficultySetting
globalvar biteDamages
globalvar biteDurations
globalvar damageDealt
globalvar botHealthValues
globalvar throttleSpeeds
globalvar specialEffectsTiming
globalvar evacRate
globalvar evacuatingSurvivorList
globalvar evacDestination
globalvar zombieSetting
globalvar bosses
globalvar zombieVotes
globalvar globalPlayerStats
globalvar objectiveTypeVotes
globalvar objectiveTypeSetting
globalvar eliminationsNeededPerObjective
globalvar healthpackPositions
globalvar miniBoss
globalvar mapGrid
globalvar challengeSetting
globalvar attackSpawnRooms
globalvar activeAttackSpawnRoom
globalvar botSpawnPoints
globalvar objectiveValue
globalvar objectiveEntities
globalvar voting
globalvar votingEndTime
globalvar objectiveResourcePositions
globalvar amountPerResource
globalvar extractionZoneRad
globalvar specialGameModeSetup
globalvar availablePowerups
globalvar specialGameMode
globalvar objectiveSpacing
globalvar enhancementOptions
globalvar playerTargetList
globalvar losHeightCheck
globalvar survivorToRescue
globalvar nonBossZombies
globalvar availableMutations
globalvar numberOfPowerUpsPerSupplyDrop
globalvar objectiveDescription
globalvar mixedObjectivesPool
globalvar uniqueSkinCap
globalvar users
globalvar objectiveComplete
globalvar objectiveColor
globalvar objectiveCount1
globalvar objectiveChase1
globalvar spawnRoomIndex
globalvar matchEndTime
globalvar waypoints
globalvar availableBosses
globalvar spawnTimes
globalvar numberOfBots
globalvar customTelePositions
globalvar botSpawnPointTimers
globalvar extractionSpeedUp
globalvar queuedBioType
globalvar goalText
globalvar goalColor
globalvar goalPost
globalvar biowasteTypes
globalvar deferredType
globalvar goalCheck
globalvar queuedGoalType
globalvar deferredPositions
globalvar biowasteString
globalvar biowasteEffects
globalvar biowasteCount
globalvar biowasteColorLookUp
globalvar biowasteTextLookUp

#Player variables

playervar averagePlayersPos
playervar targeting
playervar mutationChase
playervar teleporting
playervar pForceFieldCount1
playervar pForceFieldCount2_bCount1
playervar botTarget
playervar botThrottleSpeed
playervar playerActiveStatus
playervar reviving
playervar reviveStartTime
playervar reviveTimer
playervar interactEntity
playervar infected
playervar biteDamage
playervar biteDuration
playervar randVal
playervar crowdControlled
playervar deathTimer
playervar infectionLvl
playervar currentPowerUp
playervar powerUpTradeValues
playervar powerUpEffects
playervar pNoCooldownsCount_bCount2
playervar pAirStrikeCount
playervar specialCooldown
playervar chase1
playervar chase2
playervar botFollowTarget
playervar botTempvalue2
playervar playerMenuStatus
playervar startPos
playervar successfullyTeleported
playervar biowasteType
playervar anranPortal
playervar evacPos
playervar canWallPhase
playervar pHealBeaconCount
playervar pSentryTurretCount
playervar initialMaxHealth
playervar botSpecialTarget
playervar attached
playervar telePos
playervar invisible
playervar pCloakingDeviceCount
playervar path
playervar potentialTargets
playervar pSuperNanoCount
playervar size
playervar bossHealth
playervar wallCollisionEnabled
playervar specialFacing
playervar specialThrottling
playervar botTempValue
playervar objectiveValue
playervar generalPlayerBotEntities
playervar entityCount
playervar botHero
playervar playerObjectiveResourceValue
playervar pBouncePadCount1
playervar infectionDamage
playervar enhancementValues
playervar botSpecialPotentialTargets
playervar movementSpeed
playervar mutationValue
playervar health
playervar damageOverTimeDuration
playervar pUltimateChargerCount
playervar enhancementChase1
playervar playerCollisionEnabled
playervar pStunCount
playervar enhancementChase2
playervar initializing
playervar userIndex
playervar knockbackRecieved
playervar pStunChase1
playervar customTelePos
playervar lastTarget
playervar abilityArray1
playervar abilityArray2
playervar waypoint
playervar testTarget
playervar canTeleport
playervar defaultOutlineColor
playervar explosionColor1
playervar explosionColor2
playervar afk
playervar explosionSize
playervar switchedHeroes
playervar anranPortalRise
playervar botResourceEntity

# Frequently accessed array fields use individual variables to reduce element count.
# enhancementValues retains slots 7+; playerMenuStatus retains votes in slots 2-4.
playervar enhancementId
playervar enhancementValue1
playervar enhancementValue2
playervar enhancementValue3
playervar enhancementValue4
playervar enhancementValue5
playervar enhancementValue6
playervar sentryTurretPosition
playervar stunTarget
playervar healBeaconPosition
playervar forceFieldPosition
playervar bouncePadPosition
playervar stunOrigin
playervar sentryTurretDirection
playervar airStrikePosition
playervar powerUpTradeIndex
playervar menuStage
playervar menuVoting
