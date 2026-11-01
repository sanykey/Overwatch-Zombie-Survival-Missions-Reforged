#!mainFile "main.opy"

#!define BOT_MAX_TELEPORT_RANGE 40
#!define BIOMORPHING_RESOURCE_AMOUNT 25
#!define CURRENT_OBJECTIVE_TYPE objectiveTypeList[0]
#!define ELIMINATIONS_NEEDED_PER_OBJECTIVE 50
#!define LASER_BARRICADE_HEIGHT 2
#!define LASER_BARRICADE_WIDTH 5
#!define REVIVE_RADIUS 5
#!define START_CAM_DISTANCE 6.5
#!define START_TIME 300
#!define VOTING_END_TIME 30

# Enhancement IDs also index enhancementOptionList and the default-setting choices.
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

# Objective IDs also index objectiveTypeVoteList and identify entries in objectiveTypeList.
# Biomorphing and Survivor Rescue are only selectable through the mixed pool.
# Keep the existing IDs; 8 is unused and Mixed Objectives is a voting option only.
enum ObjectiveType:
    NO_PREFERENCE = 0,
    SHOWDOWN = 1,
    BOSSES = 2,
    BIOMORPHING = 3,
    SURVIVOR_RESCUE = 4,
    KILL_ZONE = 5,
    ZOMBIE_EGG = 6,
    SATELLITE_UPLINK = 7,
    MIXED_OBJECTIVES = 9,

# Vote indices in playerMenuStatus; slots 0-1 are unused after extracting pregameState/isVoting.
enum PlayerMenuStatusField:
    CHALLENGE_VOTE = 2,
    ZOMBIE_MODE_VOTE = 3,
    OBJECTIVE_TYPE_VOTE = 4,

# Ordered states for pregame hero selection and readiness; jump/crouch move one step at a time.
enum PregameState:
    SELECTING_HERO = 0,
    HERO_SELECTED = 1,
    READY = 2,

# Global variables

# Naming: booleans start with is; stable arrays end with List.
# Objective-type prefixes identify dedicated state; shared/polymorphic slots use neutral names.
# numbersList is owned by compressed numbers.opy; debugHud is owned by debug.opy.

# Shared scratch slots.
# Finish scratch use before wait/waitUntil or async calls; use separate slots for simultaneous values.
# Capture scratch references in reevaluated visuals with evalOnce, and document each assignment locally.
globalvar tmp0  # Synchronous scratch: number, position, player or list; assign before use and do not retain across waits.
globalvar tmp1  # Second simultaneously live scratch value; may hold a scalar, player, vector or list.
globalvar tmp2  # Third simultaneously live scratch value; may hold a scalar, player, vector or list.

# Shared immutable colors and positions.
globalvar offsetUpThreeQuartersConst = vect(0, 0.75, 0)    # Vertical offset of 0.75 m for labels, icons and visibility checks.
globalvar offsetUpHalfConst = vect(0, 0.5, 0)              # Vertical offset of 0.5 m for labels and effects.
globalvar losOffsetConst = vect(0, 1.2, 0)                 # Vertical offset of 1.2 m used by line-of-sight checks.
globalvar colorChargeBatteryConst = rgb(236, 206, 44)      # Shared Charge Battery color used by the menu and enhancement visuals.
globalvar dummyHoldingPositionConst = vect(500, 500, 500)  # Off-map holding position for newly created or reconfigured dummy bots.
globalvar colorKevlarConst = rgb(240, 129, 26)             # Shared Kevlar color used by the menu and enhancement visuals.

# Match state and configuration.
globalvar isPregameSetup        # Pregame hero selection/voting is active; cleared by START GAME before gameplay activation.
globalvar isSpecialGameMode     # TDM, CTF, PUSH or CONTROL uses alternate menu/spawn handling.
globalvar isGameplayActive      # Objectives are generated and combat is active; cleared when the match outcome is decided.
globalvar isOvertimeActive      # Prevents repeated overtime activation and zombie relocation on standard modes.
globalvar isVoting              # Global pregame vote is open; separate from each player's isVoting field.
globalvar difficultySetting     # Cached player-count difficulty used to select zombie stats and scaling.
globalvar challengeSetting      # Selected Challenge option, retained after pregame voting.
globalvar zombieSetting         # Selected zombie roster/spawn-rate mode, retained after pregame voting.
globalvar objectiveTypeSetting  # Selected objective mode or Mixed setting; differs from the current objective type.
globalvar matchEndTime          # Native-gamemode timer offset: zero or 0.1, used as the match-time floor.
globalvar uniqueSkinCap         # Configured maximum number of different hero skins shared by players and zombies.
globalvar numberOfBots          # Configured zombie population target, including queued replacements.

# Pregame scene, palettes and voting.
globalvar startPos                       # Center/aim position of the pregame hero-selection scene.
globalvar startCamPos                    # Pregame camera position used to place players and world text.
globalvar startMenuSpacingAngle          # Hero-scene spacing angle; zero also means menu initialization is not finished.
globalvar startMenuZombieColorList       # Pregame Zombie Mode HUD colors indexed by option ID.
globalvar startMenuObjectiveColorList    # Pregame Objective Type HUD colors indexed by raw objective ID.
globalvar startMenuEnhancementColorList  # Pregame Enhancement HUD colors indexed by enhancement ID.
globalvar challengeVoteList              # Challenge availability/count entries, indexed by vote option.
globalvar zombieVoteList                 # Zombie-mode availability/count entries, indexed by vote option.
globalvar objectiveTypeVoteList          # Objective-type availability/count entries, indexed by raw objective ID.
globalvar enhancementOptionList          # Enhancement icons/availability used by pregame selection and world text.
globalvar pregameGlitchText              # Random distorted Challenge text shown during the pregame flashing effect.
globalvar isPregameGlitchActive          # Enables the pregame Challenge text/color flash.

# Map grid and spawn-position caches.
globalvar walkCenter                  # Walkable map center used for grid generation, the menu and player teleportation.
globalvar mapGridList                 # Cached walkable map positions used by objectives, teleports, supplies and the finale.
globalvar attackSpawnRooms            # Standard modes: list of spawn-room positions; the unused CTF fallback stores one position.
globalvar activeAttackSpawnRoom       # Currently activated spawn-room position; may differ from the room being tested.
globalvar spawnRoomIndex              # Room index during pregame recording/rotation and in-match safe-room selection.
globalvar botSpawnPointList           # Cached successful zombie spawn/teleport positions.
globalvar botSpawnPointTimerList      # Per-spawn-point cooldown/load values, indexed with botSpawnPointList.
globalvar botSpawnWaypointList        # Movement waypoint associated with each cached botSpawnPointList entry.
globalvar customTeleportPositionList  # Special teleport positions transferred from dying bots to replacement bots.
globalvar botSpawnTimeList            # Remaining delays for queued zombie replacements, decremented once per second.

# Shared objective generation and runtime state.
globalvar objectivePositionList          # Queued objective positions; index zero is current, the final entry is extraction.
globalvar objectiveTypeList              # Queued objective types aligned with objectivePositionList.
globalvar objectiveSpacingList           # Consecutive/minimum placement distances calculated from the map-grid size.
globalvar mixedObjectiveTypeList         # Allowed Mixed objective types used while building the mission queue.
globalvar objectiveValue                 # Current type snapshot published when global objective visuals are refreshed.
globalvar objectiveCaptureValue          # Numeric progress/kill score, or a list of three terminal percentages in Satellite Uplink.
globalvar objectiveRad                   # Current objective radius; also chased or temporarily expanded by some objective types.
globalvar objectiveDescription           # Current task description displayed by the global match HUD.
globalvar objectiveColor                 # Shared objective visual color, including Showdown progress-loss flashes.
globalvar isObjectiveComplete            # Requests objective advancement and coordinates objective/player recovery rules.
globalvar objectivePlayerList            # Players currently capturing, repairing, depositing resources or extracting.
globalvar objectiveEntityIdList          # Global objective effect/text/icon/progress-bar IDs retained for cleanup.
globalvar objectiveEntitiesCount         # Index of the yielding global objective-visual cleanup loop.
globalvar objectiveResourcePositionList  # Dropped-resource positions in Biomorphing or terminal positions in Satellite Uplink.
globalvar testPos                        # Candidate position retained across waits during mission placement or survivor spawning.
globalvar testPos2                       # Minimum survivor-spawn distance or minimum spacing between satellite terminals.
globalvar objectiveCount1                # Mission-placement attempt count, then remaining satellite firing-loop steps.
globalvar objectiveChase1                # Saved Rescue radius (number), Kill Zone center (vector), or Satellite laser position (vector).
globalvar goalPost                       # Next 25-percent progress checkpoint shared by Showdown and Biomorphing.
globalvar queuedGoalList                 # Showdown: contesting zombies; Biomorphing: queued resource-goal IDs.
globalvar survivorToRescue               # Rescue NPC or current zombie target followed by the Satellite laser.

# Player roster, reconnect state and revival.
globalvar playerTargetList        # Active zombie targets; can temporarily include the NPC being rescued.
globalvar userNameList            # Recorded player names used to restore state when a user rejoins.
globalvar playerStatsList         # Per-user death status, timers and last position, indexed with userNameList.
globalvar healthpackPositionList  # Discovered health-pack positions used by infection-cure indicators.
globalvar mustReviveTime          # Allowed rescue time; starts at 60 and decreases after permanent player deaths.

# Shared zombie stats, mutations and boss state.
globalvar botHeroList            # Zombie hero order used to index spawn weights and all per-hero stat tables.
globalvar botSpawnRateList       # Per-hero spawn weights; Zombie Shuffle can reorder them during gameplay.
globalvar botBiteDamageList      # Per-hero bite damage selected for the current difficulty.
globalvar botBiteDurationList    # Per-hero bite damage-over-time durations selected for the current difficulty.
globalvar botDamageDealtList     # Per-hero damage percentages, also used to calibrate bite damage.
globalvar botHealthList          # Per-hero maximum health values selected for the current difficulty.
globalvar botThrottleSpeedList   # Per-hero movement throttle values selected for the current difficulty.
globalvar availableMutationList  # Enabled mutation IDs configured through Workshop settings.
globalvar miniBossList           # Current miniboss membership, independent of the large objective boss/egg.
globalvar bossStateList          # Shared Bosses/Zombie Egg state: boss player at index 0, head-height measurement at index 1.
globalvar isSmolderEventActive   # Global Winston/Smolder phase affecting spawns, abilities, effects and player HUD.

# Bosses objective: hero rotation.
globalvar bossesAvailableHeroList  # Bosses-only hero rotation; retained between Bosses objectives until the pool is exhausted.
globalvar bossesExcludedHeroList   # Hero types excluded from the Bosses objective hero pool when enough alternatives exist.

# Biomorphing objective: goals, resources and deferred drops.
globalvar biomorphingQueuedTypeList        # Shuffled resource types 0/1/2 assigned to successive zombie resource carriers.
globalvar biomorphingGoalText              # Current requested-material/blood message displayed by the Biomorphing HUD.
globalvar biomorphingGoalColor             # Current Biomorphing goal color used by its HUD and announcements.
globalvar isBiomorphingGoalPending         # Requests Biomorphing resource cleanup and initialization of the next resource goal.
globalvar biomorphingResourceTypeList      # Types of dropped resources, indexed with the shared resource-position list.
globalvar biomorphingDeferredTypeList      # Queued resource types awaiting orb creation after their holders die.
globalvar biomorphingDeferredPositionList  # World positions aligned with biomorphingDeferredTypeList.
globalvar biomorphingResourceTextIdList    # World-text IDs for dropped resources, retained until pickup or goal cleanup.
globalvar biomorphingResourceEffectIdList  # Effect IDs for dropped resource orbs, retained until pickup or goal cleanup.
globalvar biomorphingCleanupIndex          # Index retained across waits while old resource effects and labels are destroyed.
globalvar biomorphingResourceColorList     # Colors indexed by resource type, including the blood goal.
globalvar biomorphingResourceNameList      # Resource names indexed by ordinary resource type: head, arm and leg.

# Extraction and shared match-ending visuals.
globalvar extractionZoneRad            # Shrinking extraction-dome radius; initialized to 300 and also checked by defeat rules.
globalvar extractionSpeedUp            # Dome shrink speed, initially 2.5 and increased by players at extraction.
globalvar extractionFlightSpeed        # Successful extraction flight-stage speed, switched between 2, 10 and 50.
globalvar extractionFlightDestination  # Random shared destination used by the successful extraction flight.
globalvar evacSurvivorList             # Snapshot of extracted players, also used to exclude survivors from finale kills.
globalvar evacCount                    # Counter for 400 finale explosions, used on both victory and defeat.
globalvar chase1                       # Pregame hidden timer (number), then the finale projectile position (vector).

# Supply drops and ground power-ups.
globalvar supplyDropLandingPosition  # Target ground position where the current supply drop will land.
globalvar supplyDropPosition         # Current supply-drop position, animated while it falls.
globalvar isSupplyDropOpen           # Drop is open, or no drop has spawned yet; allows generation of the next drop.
globalvar supplyDropPowerUpCount     # Configured number of power-ups spawned when a supply drop is opened.
globalvar supplyPowerUpIdList        # Item type IDs of ground power-ups from supplies, player drops and Biomorphing rewards.
globalvar supplyPowerUpPositionList  # Ground power-up positions indexed by the same item list.
globalvar supplyPowerUpTextIdList    # World-text IDs for removing item labels on pickup or exchange.
globalvar supplyPowerUpEffectIdList  # Effect IDs for removing item orbs on pickup or exchange.

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

playervar botSpecialPotentialTargets
playervar movementSpeed
playervar mutationValue
playervar health
playervar damageOverTimeDuration
playervar pUltimateChargerCount
playervar pStunCount
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


# enhancements:
playervar enhancementId
playervar enhancementValue1
playervar enhancementValue2
playervar enhancementValue3
playervar enhancementValue4
playervar enhancementValue5
playervar enhancementValue6
playervar enhancementValue7 # Used only by Laser Barricade: current barrier health.
playervar hitchhikerPassenger # Hitchhiker passenger attached to this player; null when no passenger is attached.
playervar hitchhikerCarrierHealthPool # ID of the extra health pool granted to this carrier by a Hitchhiker passenger.


# power_ups:
playervar sentryTurretPosition
playervar stunTarget
playervar healBeaconPosition
playervar forceFieldPosition
playervar bouncePadPosition
playervar stunOrigin
playervar sentryTurretDirection
playervar airStrikePosition
playervar powerUpTradeIndex


# Current PregameState; zero is also the default for players joining after the pregame menu.
playervar pregameState
playervar isVoting
