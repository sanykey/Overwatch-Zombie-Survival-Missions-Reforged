#!mainFile "main.opy"

#!define BOT_MAX_TELEPORT_RANGE 40
#!define BIOMORPHING_RESOURCE_AMOUNT 25
#!define ELIMINATIONS_NEEDED_PER_OBJECTIVE 50
#!define LASER_BARRICADE_HEIGHT 2
#!define LASER_BARRICADE_WIDTH 5
#!define REVIVE_RADIUS 5
#!define START_CAM_DISTANCE 6.5
#!define START_TIME 300
#!define VOTING_END_TIME 30

# Player-count thresholds for difficultySetting; zero is the pregame reset value.
# Keep the raw player count for scaling: 4 uses Expert stats, 6 uses Legendary stats.
# Insanity is controlled separately by challengeSetting.
enum Difficulty:
    UNSET = 0,
    NORMAL = 1,
    HARD = 2,
    EXPERT = 3,
    LEGENDARY = 5,

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

# Ordered states for pregame hero selection and readiness; jump/crouch move one step at a time.
enum PregameState:
    SELECTING_HERO = 0,
    HERO_SELECTED = 1,
    READY = 2,

# Sparse indices in powerUpEntityIdList; values identify storage slots, not item IDs.
# Turret effect slots 50..54 stay contiguous for creation and cleanup loops.
enum PowerUpEntitySlot:
    FORCE_FIELD_SPHERE = 10,
    FORCE_FIELD_HUD = 11,
    NO_COOLDOWNS_HUD = 20,
    AIR_STRIKE_RING = 30,
    AIR_STRIKE_CLOUD = 31,
    HEAL_BEACON_LIGHT_SHAFT = 40,
    HEAL_BEACON_RING = 41,
    HEAL_BEACON_HUD = 42,
    HEAL_BEACON_AURA = 43,
    SENTRY_TURRET_BODY = 50,
    SENTRY_TURRET_LEG_1 = 51,
    SENTRY_TURRET_LEG_2 = 52,
    SENTRY_TURRET_LEG_3 = 53,
    SENTRY_TURRET_BARREL = 54,
    SENTRY_TURRET_HUD = 55,
    CLOAKING_DEVICE_SPHERE = 60,
    CLOAKING_DEVICE_HUD = 61,
    SUPER_NANO_GOOD_AURA = 70,
    SUPER_NANO_HUD = 71,
    SUPER_NANO_BAD_AURA = 72,
    SUPER_NANO_DAMAGE_DEALT_MODIFICATION = 73,
    SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION = 74,
    BOUNCE_PAD_RING = 80,
    BOUNCE_PAD_HUD = 81,
    ULTIMATE_CHARGER_HUD = 90,
    STUN_BEAM = 100,

# Global variables

# Naming: booleans start with is; stable arrays end with List.
# Objective-type prefixes identify dedicated state; shared/polymorphic slots use neutral names.
# Use a role alias in each objective; neutral *Slot globals describe storage, not gameplay meaning.
# Shared names remain appropriate where the meaning is common (objectiveRad, objectiveColor, bossStateList).
# numbersList is owned by compressed numbers.opy; debugHud is owned by debug.opy.

# Shared scratch slots.
# Define a semantic #!define alias next to each use; access scratch through that alias.
# Finish scratch use before wait/waitUntil or async calls; use separate slots for simultaneous values.
# Capture scratch references in reevaluated visuals with evalOnce, and document each assignment locally.
globalvar tmp0  # Synchronous scratch, including Rescue path index and Anran spawn source; assign before use, never retain across waits/calls.
globalvar tmp1  # Second synchronous scratch value, including selectTarget candidates and barricade push geometry; never retain across waits/calls.
globalvar tmp2  # Third synchronous scratch value, including barricade's current target and mutation color captured with evalOnce for the outline.

# Phase-owned storage, NOT scratch: values may survive waits and reevaluation.
# START GAME removes all pregame HUD/world text before mission generation can resume.
# Never restart menu/voting writers after this boundary; initialize each new role before reading it.
globalvar phaseSlot0  # Menu zombie palette -> objective-visual cleanup index; global_start_menu.opy -> subroutines.opy.
#!define startMenuZombieColorList phaseSlot0
#!define objectiveVisualCleanupIndex phaseSlot0

globalvar phaseSlot1  # Menu objective palette -> placement attempts / Biomorphing cleanup / Satellite firing counter.
# Owners: global_start_menu.opy, then objective_type_biomorphing.opy / objective_type_satellite_uplink.opy.
#!define startMenuObjectiveColorList phaseSlot1
#!define missionPlacementAttemptCount phaseSlot1
#!define biomorphingCleanupIndex phaseSlot1
#!define satelliteFiringStepsRemaining phaseSlot1

globalvar phaseSlot2  # Menu enhancement palette -> Rescue spawn distance / Satellite terminal spacing (115 / 50 before use).
# Owners: global_start_menu.opy -> subroutines.opy and objective_type_survivor_rescue.opy / objective_type_satellite_uplink.opy.
#!define startMenuEnhancementColorList phaseSlot2
#!define rescueMinSpawnDistance phaseSlot2
#!define satelliteMinTerminalSpacing phaseSlot2

globalvar phaseSlot3  # Challenge votes (startup/global/player menu) -> Biomorphing names (subroutines, Biomorphing HUD/drops).
#!define challengeVoteList phaseSlot3
#!define biomorphingResourceNameList phaseSlot3

globalvar phaseSlot4  # Objective votes (startup/global/player menu) -> Biomorphing colors (subroutines, drops/player icons).
#!define objectiveTypeVoteList phaseSlot4
#!define biomorphingResourceColorList phaseSlot4

globalvar phaseSlot5  # Zombie votes (startup/global/player menu) -> resource-type queue, initialized by BIOMORPHING GOAL START.
#!define zombieVoteList phaseSlot5
#!define biomorphingQueuedTypeList phaseSlot5

globalvar phaseSlot6  # Menu glitch text -> extraction flight destination; WIN/LOSS CONDITIONS sets it before evacSurvivorList.
#!define pregameGlitchText phaseSlot6
#!define extractionFlightDestination phaseSlot6

globalvar phaseSlot7  # Menu glitch flag -> extraction flight speed (2/10/50); menu waits abort when isPregameSetup is cleared.
#!define isPregameGlitchActive phaseSlot7
#!define extractionFlightSpeed phaseSlot7

globalvar phaseSlot8  # Mixed objective pool (startup/generation) -> nukeMap explosion counter, on victory or defeat AFTER generation.
#!define mixedObjectiveTypeList phaseSlot8
#!define finaleExplosionIndex phaseSlot8

globalvar phaseSlot9  # Menu enhancement icons -> Biomorphing goal text (goal rule/HUD); START GAME restores null after menu cleanup.
#!define enhancementOptionList phaseSlot9
#!define biomorphingGoalText phaseSlot9

globalvar phaseSlot10  # Menu spacing/readiness (0 -> 40) -> current objective type.
# Menu values cannot match objective IDs 1-7; START GAME restores the empty queue head before generation.
# The final menu angle writer is phase-guarded, including after scene-setup waits.
#!define startMenuSpacingAngle phaseSlot10
#!define currentObjectiveType phaseSlot10

globalvar phaseSlot11  # Menu scene aim position -> Biomorphing goal color.
# Scene writers abort after every wait when the menu ends; START GAME restores null after visual cleanup.
#!define startPos phaseSlot11
#!define biomorphingGoalColor phaseSlot11

globalvar phaseSlot12  # Menu camera position -> current objective position, including moving eggs.
# START GAME stops cameras, removes menu visuals and restores the empty queue head before generation.
# Delayed menu readers/writers abort after waits before accessing the new role.
#!define startCamPos phaseSlot12
#!define currentObjectivePosition phaseSlot12

# Shared immutable colors and positions.
# Use Vector directions directly for unit offsets; scaling adds a multiplication and scalar.
# Shared offsets below cache that expression once, saving elements across repeated uses.
globalvar offsetUpThreeQuartersConst = 0.75 * Vector.UP    # Vertical offset of 0.75 m for labels, icons and visibility checks. Source uses: 7 (excluding declaration).
globalvar offsetUpHalfConst = 0.5 * Vector.UP              # Vertical offset of 0.5 m for labels and effects. Source uses: 7 (excluding declaration).
globalvar losOffsetConst = 1.2 * Vector.UP                 # Vertical offset of 1.2 m used by line-of-sight checks. Source uses: 16 (excluding declaration).
globalvar colorChargeBatteryConst = rgb(236, 206, 44)    # Shared Charge Battery color used by the menu and enhancement visuals. Source uses: 4 (excluding declaration).
globalvar dummyHoldingPositionConst = vect(500, 500, 500)  # Off-map holding position for newly created or reconfigured dummy bots. Source uses: 6 (excluding declaration).
globalvar colorKevlarConst = rgb(240, 129, 26)           # Shared Kevlar color used by the menu and enhancement visuals. Source uses: 2 (excluding declaration).
globalvar offsetDownHundredConst = -100 * Vector.UP       # Downward offset of 100 m for raycasts, hidden effects and dead-player storage. Source uses: 7 (excluding declaration).
globalvar offsetUpOneAndHalfConst = 1.5 * Vector.UP       # Vertical offset of 1.5 m for the pregame camera and player labels. Source uses: 6 (excluding declaration).
globalvar offsetUpQuarterConst = 0.25 * Vector.UP         # Vertical offset of 0.25 m for impulses, power-up drops and effects. Source uses: 5 (excluding declaration).

# Immutable palette indexed by item ID minus one; shared by ground items and their HUD.
globalvar powerUpColorListConst = [Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE]

# Match state and configuration.
globalvar isPregameSetup        # Pregame hero selection/voting is active; cleared by START GAME before gameplay activation.
globalvar isSpecialGameMode     # TDM, CTF, PUSH or CONTROL uses alternate menu/spawn handling.
globalvar isGameplayActive      # Objectives are generated and combat is active; cleared when the match outcome is decided.
globalvar isOvertimeActive      # Prevents repeated overtime activation and zombie relocation on standard modes.
globalvar isVoting              # Global pregame vote is open; separate from each player's isPregameVoting field.
globalvar difficultySetting     # Cached player count; compared with Difficulty thresholds and used directly for scaling.
globalvar challengeSetting      # Selected Challenge option, retained after pregame voting.
globalvar zombieSetting         # Selected zombie roster/spawn-rate mode, retained after pregame voting.
globalvar objectiveTypeSetting  # Selected objective mode or Mixed setting; differs from the current objective type.
globalvar matchEndTime          # Native-gamemode timer offset: zero or 0.1, used as the match-time floor.
globalvar uniqueSkinCap         # Configured maximum number of different hero skins shared by players and zombies.
globalvar numberOfBots          # Configured zombie population target, including queued replacements.

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

# Pregame scene coordinates use phase aliases above.

# Shared objective generation and runtime state.
globalvar objectivePositionList          # Queued objective positions; index zero is current, the final entry is extraction.
globalvar objectiveTypeList              # Queued objective types aligned with objectivePositionList.

# Keep these head caches synchronized immediately after every queue mutation, before waits/calls.
# objectiveValue remains the separate type snapshot published by the objective visuals.
# currentObjectiveType/currentObjectivePosition use phaseSlot10/phaseSlot12 above.
# During the menu, type predicates still see a non-objective ID (0 or 40); after cleanup both mirror their queue heads.
globalvar objectiveSpacingList           # Consecutive/minimum placement distances calculated from the map-grid size.
globalvar objectiveValue                 # Current type snapshot published when global objective visuals are refreshed.
globalvar objectiveProgressSlot          # Shared progress storage; generic reset in objectivesManagement, role-specific HUD/rules below.
#!define objectiveProgress objectiveProgressSlot
#!define showdownCapturePercent objectiveProgressSlot
#!define biomorphingCapturePercent objectiveProgressSlot
#!define killZoneEliminationScore objectiveProgressSlot
#!define satelliteTerminalProgressList objectiveProgressSlot
globalvar objectiveRad                   # Current objective radius; also chased or temporarily expanded by some objective types.
globalvar objectiveDescription           # Current task description displayed by the global match HUD.
globalvar objectiveColor                 # Shared objective visual color, including Showdown progress-loss flashes.
globalvar isObjectiveComplete            # Requests objective advancement and coordinates objective/player recovery rules.
globalvar objectivePlayerList            # Players currently capturing, repairing, depositing resources or extracting.
globalvar objectiveEntityIdList          # Global objective effect/text/icon/progress-bar IDs retained for cleanup.
globalvar objectivePositionsSlot         # World-position list; startup reset, then Biomorphing drops or Satellite terminals (subroutines/objectives).
#!define objectivePositionsList objectivePositionsSlot
#!define biomorphingResourcePositionList objectivePositionsSlot
#!define satelliteTerminalPositionList objectivePositionsSlot

globalvar objectivePlacementSlot         # Candidate vector held across waits: mission placement (global menu), then Rescue NPC spawning.
#!define missionCandidatePosition objectivePlacementSlot
#!define rescueCandidatePosition objectivePlacementSlot

globalvar objectiveMotionSlot            # Rescue saved radius, Kill Zone center, or chased Satellite laser position; subroutines/objectives/bots.
#!define rescueSavedRadius objectiveMotionSlot
#!define killZoneCenter objectiveMotionSlot
#!define satelliteLaserPosition objectiveMotionSlot

globalvar objectiveCheckpointSlot        # Generic reset, then next 25-percent checkpoint in Showdown or Biomorphing (subroutines/objectives).
#!define objectiveNextCheckpoint objectiveCheckpointSlot
#!define showdownNextCheckpoint objectiveCheckpointSlot
#!define biomorphingNextCheckpoint objectiveCheckpointSlot

globalvar objectiveQueueSlot             # Showdown contesting-zombie list (also bots/HUD), or Biomorphing resource-goal queue.
#!define showdownContestingZombieList objectiveQueueSlot
#!define biomorphingGoalQueueList objectiveQueueSlot

globalvar objectiveActorSlot             # Generic transition reset, then Rescue NPC or Satellite laser target; subroutines/objectives/bots.
#!define objectiveActor objectiveActorSlot
#!define rescueSurvivor objectiveActorSlot
#!define satelliteLaserTarget objectiveActorSlot

# Biomorphing objective: goals, resources and deferred drops.
globalvar isBiomorphingGoalPending         # Requests Biomorphing resource cleanup and initialization of the next resource goal.
globalvar biomorphingResourceTypeList      # Types of dropped resources, indexed with the shared resource-position list.
globalvar biomorphingDeferredTypeList      # Queued resource types awaiting orb creation after their holders die.
globalvar biomorphingDeferredPositionList  # World positions aligned with biomorphingDeferredTypeList.
globalvar biomorphingResourceTextIdList    # World-text IDs for dropped resources, retained until pickup or goal cleanup.
globalvar biomorphingResourceEffectIdList  # Effect IDs for dropped resource orbs, retained until pickup or goal cleanup.

# Extraction and shared match-ending visuals.
globalvar extractionZoneRad            # Shrinking extraction-dome radius; initialized to 300 and also checked by defeat rules.
globalvar extractionSpeedUp            # Dome shrink speed (startup -> subroutines/extraction), starts at 2.5; separate from the late-written menu angle.
globalvar evacSurvivorList             # Snapshot of extracted players, also used to exclude survivors from finale kills.
globalvar menuFinaleMotionSlot         # Global hidden countdown (startup/menu/setPrematchTimer), then nukeMap projectile position.
# nukeMap stops the countdown chase before assigning a vector; the separate actorMotionSlot1 player storage has its own role aliases.
#!define pregameCountdown menuFinaleMotionSlot
#!define nukeProjectilePosition menuFinaleMotionSlot

# Supply drops and ground power-ups.
globalvar supplyDropLandingPosition  # Target ground position where the current supply drop will land.
globalvar supplyDropPosition         # Current supply-drop position, animated while it falls.
globalvar isSupplyDropOpen           # Drop is open, or no drop has spawned yet; allows generation of the next drop.
globalvar supplyDropPowerUpCount     # Configured number of power-ups spawned when a supply drop is opened.
globalvar supplyPowerUpIdList        # Item type IDs of ground power-ups from supplies, player drops and Biomorphing rewards.
globalvar supplyPowerUpPositionList  # Ground power-up positions indexed by the same item list.
globalvar supplyPowerUpTextIdList    # World-text IDs for removing item labels on pickup or exchange.
globalvar supplyPowerUpEffectIdList  # Effect IDs for removing item orbs on pickup or exchange.

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
#!define bossesStateList bossStateList
#!define zombieEggStateList bossStateList
globalvar isSmolderEventActive   # Global Winston/Smolder phase affecting spawns, abilities, effects and player HUD.

# Bosses objective: hero rotation.
globalvar bossesAvailableHeroList  # Bosses-only hero rotation; retained between Bosses objectives until the pool is exhausted.
globalvar bossesExcludedHeroList   # Hero types excluded from the Bosses objective hero pool when enough alternatives exist.

# Player variables

# Gameplay uses role aliases; neutral slots describe storage.
# Team-exclusive sharing is per receiver: never write a bot role on Team 1 or a player role on Team 2.
# Three vote fields -> trade position, trade index and previous item on humans.
# Rescue path lives on a separate Team 1 dummy; trade fields must survive waits.
# END VOTING aborts after the phase boundary; all pregame visuals are destroyed before runtime.
# Keep pregameState for late joins, botBaseHealth for unscoped Kill Zone reads,
# and botBiteDamage for the shared explosion helper. Keep default-only reads on both teams separate.

# Team 2 zombies: AI, abilities, bosses and bot visuals.
playervar botBiteDamage  # Difficulty/hero-scaled zombie bite damage, also used by zombie abilities and explosions.

playervar botBaseHealth  # Configured zombie maximum health, including mutations/boss overrides and recoil thresholds.

# Team 1 players/allied actors: survival, infection and reconnect state.
playervar isPlayerActive  # Player has completed initial menu activation; used by voting, roster and downed-player rules.

playervar isReviving  # Nearby allies are currently advancing this player's revive progress.

playervar reviveDuration  # Required revive duration; restored from reconnect data and increased after revives.

playervar isInfected  # Player infection has activated; infection rules, cures and Zombie Hybrid read this flag.

playervar rescueTimeRemaining  # Time left to rescue a downed player; reconnect cache and extraction dome may adjust it.

playervar infectionLevel  # Player infection/vaccine level; negative values represent vaccination.

playervar invisibilityCount  # Stacking invisibility/untargetability counter; hero abilities and Cloaking Device increment/decrement it. Not a boolean.

playervar infectionDamageOverTimeId  # Active player infection damage-over-time ID; Zombie Hybrid stops this same damage instance.

playervar reconnectUserIndex  # Player name index into userNameList/playerStatsList for reconnect restoration.

playervar isAfk  # Player is treated as inactive/AFK and excluded from objectives or extraction counts.

playervar isHeroSwitchRespawn  # Player has switched heroes; prevents repeating first-spawn and enhancement initialization.

# Enhancements only (enhancement prefix; includes the Rescue Hitchhiker setup).
playervar enhancementId  # Selected Enhancement enum; pregame selection, runtime behavior and Rescue Hitchhiker initialization.

playervar enhancementHitchhikerPassenger  # Passenger attached to this carrier; null when absent. Infection rules also query it.

playervar enhancementCarrierPoolId  # Extra health-pool ID granted to a Hitchhiker carrier, retained for removal. Exported names must fit 32 characters.
#!define enhancementHitchhikerCarrierPoolId enhancementCarrierPoolId

# Supply power-ups only (powerUp prefix).
# Team 1 pregame selection and voting.
playervar pregameState  # PregameState hero-selection/readiness state; zero is also the late-join default.

playervar isPregameVoting  # This Team 1 player is adjusting votes; separate from global isVoting.

# Team 1 Survivor Rescue NPC.
playervar rescueLeader  # Team 1 player followed by the Rescue NPC; bot teleport logic reads the NPC's field.

# Biomorphing carriers on both teams.
playervar biomorphingResourceAmount  # Biowaste amount carried by either team; Team 1 deposits it and blood uses sentinel 9999.

# Explosion presentation shared by zombies and Zombie Hybrid.
playervar explosionInnerColor  # Inner explosion color shared by ordinary zombies and Zombie Hybrid.

playervar explosionOuterColor  # Outer explosion color shared by ordinary zombies and Zombie Hybrid.

playervar explosionScale  # Explosion radius/sound multiplier; zombie warning setup and Hybrid initialization assign it.

# Both teams or multiple systems: shared stats, visuals and role-owned storage.
playervar aiThrottleSpeedSlot  # Zombie movement throttle or Team 1 Rescue follow throttle; subroutines, bots and Rescue.
# Zombie per-hero/boss throttle in the range 0..1.
#!define botThrottleSpeed aiThrottleSpeedSlot
# Rescue follow throttle scaled by NPC health.
#!define rescueThrottleSpeed aiThrottleSpeedSlot

playervar recoveryTimeSlot  # Existing Team 1 revive countdown / Team 2 replacement delay; no additional slot sharing.
# Remaining time until a downed Team 1 player is revived.
#!define reviveTimeRemaining recoveryTimeSlot
# Delay assigned to the next zombie replacement; bosses, objectives and air strike may change it.
#!define botRespawnDelay recoveryTimeSlot

playervar isCrowdControlled  # Set/reset on zombies by stun management; also queried on Team 1 Hitchhiker carriers (default false).

playervar actorCountdownSlot  # Existing Team 1 item countdown / Team 2 Charger windup progression.
# No Cooldowns remaining seconds (15 down to 0).
#!define powerUpNoCooldownsTimeRemaining actorCountdownSlot
# Mauga charge windup progression from 0 to 1.
#!define botChargerWindupProgress actorCountdownSlot

playervar controlStateSlot  # Player crowd-control immunity flag or zombie boss return target; hero_tuning/zombie abilities/Bosses.
# Team 1 immunity window after Brute/Downfallen control.
#!define isCrowdControlCooldownActive controlStateSlot
# Boss return target retained across the return animation.
#!define botReturnTarget controlStateSlot

playervar actorMotionSlot1  # Existing per-hero numeric/vector chase or Rescue extraction position; no change to chase lifetime.
# Behemoth traveling gas projectile position.
#!define botGasProjectilePosition actorMotionSlot1
# Slimer chased tentacle endpoint.
#!define botTentaclePosition actorMotionSlot1
# Pharah rocket charging progression.
#!define botBlasterCharge actorMotionSlot1
# Illari burst charging progression.
#!define botDaytakerCharge actorMotionSlot1
# Winston anger/enrage progression; initialized to 2.
#!define botSmolderAnger actorMotionSlot1
# Hazard boss melee aiming offset, chased from -20 to 25.
#!define botEnsnarerMeleeAngle actorMotionSlot1
# Rescue NPC flight position chased upward after reaching extraction.
#!define rescueExtractionPosition actorMotionSlot1

playervar actorMotionSlot2  # Team 2 toxic-cloud duration or Team 1 extraction flight position.
# Normal Behemoth toxic-cloud duration.
#!define botGasCloudTimeRemaining actorMotionSlot2
# Player position chased through the extraction flight stages.
#!define extractionFlightPosition actorMotionSlot2

playervar actorAbilitySlot2  # Existing zombie secondary state or temporary Rescue follow message.
# Common reset/secondary zombie state.
#!define botAuxiliaryState actorAbilitySlot2
# Temporary follower-selection message above the Rescue NPC.
#!define rescueFollowMessage actorAbilitySlot2
# Anran resurrection pulse is active; spawning zombies query this flag.
#!define botIsReigniteActive actorAbilitySlot2
# Hazard boss melee sequence is in progress.
#!define botIsEnsnarerMeleeActive actorAbilitySlot2

playervar initialMaxHealth  # Cached native/player maximum health before custom scaling; used by infection and Hitchhiker health pools.

playervar isAttached  # Actor is attached to a host; zombie attachment and Team 1 Hitchhiker share the same meaning.
# Zombie is attached to another actor.
#!define botIsAttached isAttached
# Hitchhiker passenger is attached; shared Team 1 carrier queries use isAttached.
#!define enhancementIsHitchhiking isAttached

playervar candidateTargetList  # Boss target-visibility snapshot, Rescue leader candidates or barricade collision targets; downed-player cleanup removes invalid candidates.
# Final selectTarget candidate snapshot, retained for reevaluated boss-distance-text visibility; cleared on bot death/boss initialization.
#!define botPotentialTargetList candidateTargetList
# Team 1 Rescue NPC leader candidates, retained for GROUP UP handling.
#!define rescuePotentialLeaderList candidateTargetList
# Zombies crossing the player's barricade, processed synchronously.
#!define enhancementBarrierTargetList candidateTargetList

playervar sizeScale  # Actor size multiplier; shared by players, zombies, Rescue, item ranges and enhancements.

playervar actorAbilitySlot1  # Existing per-zombie ability state or Team 1 Rescue extraction flag.
# Generic state reset in botRespawnInitialization.
#!define botAbilityState actorAbilitySlot1
# Rescue NPC has reached extraction and started its flight.
#!define rescueIsExtracting actorAbilitySlot1
# Bomber self-destruct has been armed.
#!define botIsBomberPrimed actorAbilitySlot1
# Temporary Rusher boss health-pool ID.
#!define botRusherHealthPoolId actorAbilitySlot1
# Behemoth gas projectile destination.
#!define botGasAimPosition actorAbilitySlot1
# Anran ultimate attack has been consumed.
#!define botIsReigniteAttackUsed actorAbilitySlot1
# Widowmaker grapple hit position.
#!define botRiderGrapplePosition actorAbilitySlot1
# Optional saved Mauga charge destination.
#!define botChargerDestination actorAbilitySlot1
# Slimer tentacle destination or null while idle.
#!define botTentacleTargetPosition actorAbilitySlot1
# Wrecking Ball special pile-driver sequence is active; null clears it.
#!define botIsStrikerStrikeActive actorAbilitySlot1
# Sigma grab sequence is active.
#!define botIsDownfallenGrabbing actorAbilitySlot1
# Hazard blocking sequence is active.
#!define botIsEnsnarerBlocking actorAbilitySlot1
# Winston enrage/slam state 0, 1 or 2; intentionally not a boolean.
#!define botSmolderState actorAbilitySlot1

playervar objectiveTypeSnapshot  # Last objective type whose per-actor visuals were initialized; used on both teams.

playervar visualEntityIdList  # Zombie effects or Team 1 objective icons retained for yielding cleanup.
# Per-zombie effects created by bot entity management/mutations.
#!define botVisualEntityIdList visualEntityIdList
# Team 1 objective icons removed by player objective visual management.
#!define playerObjectiveIconIdList visualEntityIdList

playervar visualCleanupIndex  # Per-actor effect/icon cleanup index; the loops yield and cannot use global scratch.

playervar actorLoopSlot  # Existing Ensnarer melee loop index / Bounce Pad duration.
# Repeated Hazard boss ultimate index.
#!define botEnsnarerUltimateIndex actorLoopSlot
# Remaining Bounce Pad seconds.
#!define powerUpBouncePadTimeRemaining actorLoopSlot

playervar abilityTargetList  # Zombie special-ability targets or common zombie/Hybrid explosion targets.
# Targets affected by zombie grabs, clouds, flight and slam abilities.
#!define botSpecialTargetList abilityTargetList
# Targets of explosionSequence, called by zombies and Team 1 Zombie Hybrid.
#!define explosionTargetList abilityTargetList

playervar movementSpeedScale  # Movement-speed multiplier used by zombie AI, players/Rescue, crowd control and supply items.

playervar damageOverTimeRemaining  # Tracked DoT duration, normally chased on zombies; one Rusher rule writes it on the victim. Preserve that receiver.

playervar actorTeamSlot0  # Team 2: botTeleportCenter; Team 1: powerUpForceFieldTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie teleport/search center; bot teleport rules, Egg and boss return.
#!define botTeleportCenter actorTeamSlot0
# Remaining Force Field seconds; yielding loop and item HUD in supply_drops.
#!define powerUpForceFieldTimeRemaining actorTeamSlot0

playervar actorTeamSlot1  # Team 2: botIsSelectingTarget; Team 1: powerUpReviveTarget. Receivers, not rule teams, own the storage.
# selectTarget is running; blocks competing zombie target/teleport work.
#!define botIsSelectingTarget actorTeamSlot1
# Dead Team 1 target retained across instantRevive waits.
#!define powerUpReviveTarget actorTeamSlot1

playervar actorTeamSlot2  # Team 2: botReturnMotionSlot; Team 1: powerUpItemId. Receivers, not rule teams, own the storage.
# Seconds without a target before boss return (chased to 15).
#!define botReturnTime actorTeamSlot2
# Boss eye-position snapshot written and cleared during return; currently not read.
#!define botReturnPosition actorTeamSlot2
# Currently carried supply item ID; zero means no item.
#!define powerUpItemId actorTeamSlot2

playervar actorTeamSlot3  # Team 2 teleport flag; Team 1 human challenge vote -> trade position, or Rescue dummy path. Menu writers are phase-guarded; trade position is assigned before reading.
# Zombie is inside enterExitTeleport; spawn/target/ability consumers also read it.
#!define botIsTeleporting actorTeamSlot3
# Aimed ground-item position; retained across all waits in the exchange.
#!define powerUpTradePosition actorTeamSlot3
# Human challenge vote during pregame only; END VOTING aborts after the phase boundary.
#!define pregameChallengeVote actorTeamSlot3
# Recorded leader positions followed and trimmed by the Rescue NPC.
#!define rescuePathList actorTeamSlot3

playervar actorTeamSlot4  # Team 2: botLoopIndexSlot; Team 1: powerUpEntityIdList. Receivers, not rule teams, own the storage.
# Repeated Moira fade/attack index.
#!define botStalkerFadeIndex actorTeamSlot4
# Index into Ensnarer affected targets.
#!define botEnsnarerTargetIndex actorTeamSlot4
# Sparse effect/HUD/damage-modification IDs owned by active items, indexed by PowerUpEntitySlot.
#!define powerUpEntityIdList actorTeamSlot4

playervar actorTeamSlot5  # Team 2: botTarget; Team 1: powerUpAirStrikeIndex. Receivers, not rule teams, own the storage.
# Zombie AI combat target; subroutines, bot abilities and objectives; cleared when its Team 1 target is downed.
#!define botTarget actorTeamSlot5
# Index of 50 air-strike impacts; retained across waits.
#!define powerUpAirStrikeIndex actorTeamSlot5

playervar actorTeamSlot6  # Team 2: botBiteDuration; Team 1: powerUpHealBeaconTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie melee damage-over-time duration, including mutation overrides.
#!define botBiteDuration actorTeamSlot6
# Remaining healing-beacon seconds; loop and HUD.
#!define powerUpHealBeaconTimeRemaining actorTeamSlot6

playervar actorTeamSlot7  # Team 2: botIsTeleportConfirmed; Team 1: powerUpTurretTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie teleport/spawn position has been accepted and may be added to the spawn cache.
#!define botIsTeleportConfirmed actorTeamSlot7
# Remaining sentry-turret seconds; loop and HUD.
#!define powerUpTurretTimeRemaining actorTeamSlot7

playervar actorTeamSlot8  # Team 2: botReigniteDestination; Team 1: powerUpCloakTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie emergence destination near Anran; false clears the position after the rise.
#!define botReigniteDestination actorTeamSlot8
# Remaining cloak seconds and early-cancel threshold.
#!define powerUpCloakTimeRemaining actorTeamSlot8

playervar actorTeamSlot9  # Team 2: botIsWallPhaseAllowed; Team 1: powerUpSuperNanoTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie may pass spawn doors; special abilities temporarily disable this permission.
#!define botIsWallPhaseAllowed actorTeamSlot9
# Remaining Super Nano seconds; yielding loop and HUD.
#!define powerUpSuperNanoTimeRemaining actorTeamSlot9

playervar actorTeamSlot10  # Team 2: botAbilityTarget; Team 1: powerUpUltimateTimeRemaining. Receivers, not rule teams, own the storage.
# Zombie special-ability target: teleport/grab host, flight target or affected player.
#!define botAbilityTarget actorTeamSlot10
# Remaining Ultimate Charger seconds; loop and HUD.
#!define powerUpUltimateTimeRemaining actorTeamSlot10

playervar actorTeamSlot11  # Team 2: botTeleportPosition; Team 1: powerUpStunBouncesRemaining. Receivers, not rule teams, own the storage.
# Zombie teleport candidate/accepted position; bot teleport rules, Egg and spawn-cache updates; zero clears it.
#!define botTeleportPosition actorTeamSlot11
# Remaining stun-chain steps, also scaling the terminal stun duration.
#!define powerUpStunBouncesRemaining actorTeamSlot11

playervar actorTeamSlot12  # Team 2: botBossHealth; Team 1: powerUpStunBeamPosition. Receivers, not rule teams, own the storage.
# Virtual boss/egg health adjusted by damage events; -1 when not a boss.
#!define botBossHealth actorTeamSlot12
# Chased stun-chain beam endpoint retained across bounces/waits.
#!define powerUpStunBeamPosition actorTeamSlot12

playervar actorTeamSlot13  # Team 2: botIsWallCollisionEnabled; Team 1: powerUpTurretPosition. Receivers, not rule teams, own the storage.
# Cached zombie environment-collision state, restored by abilities and spawn-door handling.
#!define botIsWallCollisionEnabled actorTeamSlot13
# Placed sentry-turret position; zero clears it.
#!define powerUpTurretPosition actorTeamSlot13

playervar actorTeamSlot14  # Team 2: botIsFacingOverridden; Team 1: powerUpStunTarget. Receivers, not rule teams, own the storage.
# Special zombie ability controls facing instead of normal target tracking.
#!define botIsFacingOverridden actorTeamSlot14
# Next zombie hit by the active stun chain.
#!define powerUpStunTarget actorTeamSlot14

playervar actorTeamSlot15  # Team 2: botIsThrottleOverridden; Team 1: powerUpHealBeaconPosition. Receivers, not rule teams, own the storage.
# Special zombie ability controls movement instead of the normal AI throttle.
#!define botIsThrottleOverridden actorTeamSlot15
# Placed healing-beacon position; zero clears it.
#!define powerUpHealBeaconPosition actorTeamSlot15

playervar actorTeamSlot16  # Team 2: botConfiguredHero; Team 1: powerUpForceFieldPosition. Receivers, not rule teams, own the storage.
# Last zombie hero for which bot entity/stat initialization was performed.
#!define botConfiguredHero actorTeamSlot16
# Placed Force Field position; zero clears it.
#!define powerUpForceFieldPosition actorTeamSlot16

playervar actorTeamSlot17  # Team 2: botMutationId; Team 1: powerUpBouncePadPosition. Receivers, not rule teams, own the storage.
# Selected mutation ID; zero means no mutation.
#!define botMutationId actorTeamSlot17
# Placed Bounce Pad ground position.
#!define powerUpBouncePadPosition actorTeamSlot17

playervar actorTeamSlot18  # Team 2: botIsInitializing; Team 1: powerUpStunOrigin. Receivers, not rule teams, own the storage.
# Zombie respawn/stat initialization is in progress; spawn/teleport/objective rules wait for it.
#!define botIsInitializing actorTeamSlot18
# Current beam origin in the stun chain: wearer first, then previous target.
#!define powerUpStunOrigin actorTeamSlot18

playervar actorTeamSlot19  # Team 2: botKnockbackScale; Team 1: powerUpTurretDirection. Receivers, not rule teams, own the storage.
# Zombie knockback-received multiplier, including Brute/mutation adjustments.
#!define botKnockbackScale actorTeamSlot19
# Current sentry firing direction, captured by turret visuals and raycasts.
#!define powerUpTurretDirection actorTeamSlot19

playervar actorTeamSlot20  # Team 2: botCustomTeleportPosition; Team 1: powerUpAirStrikePosition. Receivers, not rule teams, own the storage.
# Special zombie replacement position carried from customTeleportPositionList; null when unused.
#!define botCustomTeleportPosition actorTeamSlot20
# Ground center of the active air-strike area.
#!define powerUpAirStrikePosition actorTeamSlot20

playervar actorTeamSlot21  # Team 2: botLastTarget; Team 1: objective vote -> trade index. Exchange assigns its index before reading it; pregame readers/writers end before gameplay.
# Last visible/attacking target retained when zombie line of sight is lost.
#!define botLastTarget actorTeamSlot21
# Index of the aimed ground item in the global supply item arrays.
#!define powerUpTradeIndex actorTeamSlot21
# Human objective vote during pregame only; distinct from the selected global objective mode.
#!define pregameObjectiveVote actorTeamSlot21

playervar actorTeamSlot22  # Team 2: botAbilityStateSlot; Team 1: enhancementStateSlot1. Receivers, not rule teams, own the storage.
# Remaining shared zombie special-ability cooldown.
#!define botAbilityCooldown actorTeamSlot22
# Boss Behemoth active gas-cloud positions.
#!define botGasPositionList actorTeamSlot22
# Zombie Hybrid explosion cooldown in seconds.
#!define enhancementHybridCooldown actorTeamSlot22
# Barrier placement facing direction.
#!define enhancementBarrierFacing actorTeamSlot22
# Pyrotechnic hit queue; repeated targets determine fire damage.
#!define enhancementPyroHitList actorTeamSlot22
# Total infection levels cured by Plague Doctor.
#!define enhancementPlagueCureTotal actorTeamSlot22
# Born to Battle has an unspent ability reset.
#!define enhancementIsBattleResetReady actorTeamSlot22
# Placed Charge Battery position; zero clears it.
#!define enhancementBatteryPosition actorTeamSlot22
# Hitchhiker carrier; zero when detached.
#!define enhancementHitchhikerCarrier actorTeamSlot22
# P.U.P. mode color.
#!define enhancementPupColor actorTeamSlot22

playervar actorTeamSlot23  # Team 2: botGasRadiusList; Team 1: enhancementStateSlot2. Receivers, not rule teams, own the storage.
# Boss Behemoth gas-cloud radii, aligned with botGasPositionList.
#!define botGasRadiusList actorTeamSlot23
# Direction from the first barrier corner toward the second.
#!define enhancementBarrierEdgeDirection actorTeamSlot23
# Born to Battle button whose charge/cooldown is reset.
#!define enhancementBattleAbilityButton actorTeamSlot23
# Battery remaining reuse cooldown.
#!define enhancementBatteryReuseCooldown actorTeamSlot23
# Extra health-pool ID on the Hitchhiker passenger.
#!define enhancementHitchhikerPassengerPoolId actorTeamSlot23
# P.U.P. attack beam is active.
#!define enhancementIsPupBeamActive actorTeamSlot23

playervar actorTeamSlot24  # Team 2: botSpawnWaypoint; Team 1: enhancementStateSlot3. Receivers, not rule teams, own the storage.
# Movement waypoint associated with the accepted zombie spawn point.
#!define botSpawnWaypoint actorTeamSlot24
# Barrier remaining placement cooldown.
#!define enhancementBarrierPlacementCooldown actorTeamSlot24
# Full battery reuse cooldown used for progress scaling (10 seconds).
#!define enhancementBatteryReuseDuration actorTeamSlot24
# Current P.U.P. enemy target; null while idle.
#!define enhancementPupTarget actorTeamSlot24

playervar actorTeamSlot25  # Team 2: botCandidateTarget; Team 1: enhancementStateSlot4. Receivers, not rule teams, own the storage.
# Candidate zombie target under line-of-sight testing in selectTarget.
#!define botCandidateTarget actorTeamSlot25
# Placed barrier center.
#!define enhancementBarrierPosition actorTeamSlot25
# Battery remaining placement cooldown.
#!define enhancementBatteryPlacementCooldown actorTeamSlot25
# P.U.P. freezing aura is visible.
#!define enhancementIsPupFreezeAuraActive actorTeamSlot25

playervar actorTeamSlot26  # Team 2: botIsTeleportAllowed; Team 1: enhancementPositionSlot. Receivers, not rule teams, own the storage.
# Zombie initialization has enabled teleport processing.
#!define botIsTeleportAllowed actorTeamSlot26
# Barrier first lower corner.
#!define enhancementBarrierCorner1 actorTeamSlot26
# Chased P.U.P. world position.
#!define enhancementPupPosition actorTeamSlot26

playervar actorTeamSlot27  # Team 2: botReigniteRisePosition; Team 1: enhancementStateSlot6. Receivers, not rule teams, own the storage.
# Zombie emergence position chased upward near Anran; zombie_types forces this position across the rise wait.
#!define botReigniteRisePosition actorTeamSlot27
# Barrier second lower corner.
#!define enhancementBarrierCorner2 actorTeamSlot27
# P.U.P. remaining ability cooldown (1 or 2 seconds).
#!define enhancementPupCooldown actorTeamSlot27

playervar actorTeamSlot28  # Team 2: botResourceIconIdList; Team 1: enhancementBarrierHealth. Receivers, not rule teams, own the storage.
# Zombie Biomorphing resource icon IDs; separate from the zombie visual-effect list.
#!define botResourceIconIdList actorTeamSlot28
# Laser Barricade health; placement, collision damage, regeneration and HUD.
#!define enhancementBarrierHealth actorTeamSlot28

playervar team1PositionSlot  # Pregame position -> final extraction destination on humans; Rescue NPC path origin on its own actor. No chase owns this slot.
# Per-player position in the pregame hero-selection scene.
#!define pregamePosition team1PositionSlot
# Rescue NPC spawn/path origin used by its progress HUD.
#!define rescueStartPosition team1PositionSlot
# Per-player final flight destination, calculated from the shared extraction direction.
#!define extractionDestination team1PositionSlot

playervar objectiveActorKindSlot  # Biomorphing resource type on both teams, or Rescue NPC mood. Goal writers recheck the objective after waits; Rescue completes only after its dummy is destroyed.
# Material type carried by a player or zombie; null when empty and 3 for the blood goal.
#!define biomorphingResourceType objectiveActorKindSlot
# Rescue NPC mood/status icon: halo, sad, dizzy or extraction celebration.
#!define rescueMoodIcon objectiveActorKindSlot

playervar menuTradeItemSlot  # Human zombie vote -> previous carried item ID. No chase owns this slot; exchange assigns it before its first wait/read.
#!define pregameZombieVote menuTradeItemSlot
#!define powerUpTradePreviousItemId menuTradeItemSlot
