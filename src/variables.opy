#!mainFile "../main.opy"

#!define BOT_MAX_TELEPORT_RANGE 40
#!define AUGMENT_APOTHECARY_ULT_CHARGE 7
#!define BOSS_BASE_SIZE 2.5
#!define ZOMBIE_BASE_SIZE 1
#!define BIOMORPHING_RESOURCE_AMOUNT 25
#!define ELIMINATIONS_NEEDED_PER_OBJECTIVE 50
#!define LASER_BARRICADE_HEIGHT 2
#!define LASER_BARRICADE_WIDTH 5
# Engineer constants live here (not enhancements.opy): BOT DIES collects scrap
# before enhancements.opy is included.
#!define ENGINEER_SCRAP_MAX 500
#!define ENGINEER_SCRAP_PASSIVE_RATE 1
#!define ENGINEER_COLLECTION_RANGE 15
#!define ENGINEER_COLLECTION_REWARD 10
#!define ENGINEER_ASSIST_SCRAP 15
#!define ENGINEER_ARMOR_COST 50
#!define ENGINEER_ARMOR_STACK 50
#!define ENGINEER_ARMOR_MAX 100
#!define ENGINEER_ARMOR_HOLD_DURATION 2
#!define ENGINEER_TURRET_COST 200
#!define ENGINEER_BEAM_DURATION 1.4
#!define ENGINEER_TRANSFER_RANGE 15
#!define ENGINEER_TRANSFER_ANGLE 10
# Native offensive + defensive assist count; shared by Overcharge's earned-energy
# formula and Engineer's assist-scrap snapshot.
#!define earnedAssists(player) (player.getStatistic(Stat.OFFENSIVE_ASSISTS) + player.getStatistic(Stat.DEFENSIVE_ASSISTS))
#!define REVIVE_RADIUS 5
#!define START_CAM_DISTANCE 6.5
#!define START_TIME 300
#!define SUPER_NANO_DURATION 20
#!define POWERUP_JETPACK_FUEL_MAX 200
#!define VOTING_END_TIME 30
# Unique hero-skin budget shared by players and zombies.
#!define UNIQUE_HERO_SKIN_CAP 11

# Player-count thresholds for difficultySetting; zero is the pregame reset value.
# Keep the raw player count for scaling: 4 uses Expert stats, 6 uses Legendary stats.
# Insanity is controlled separately by challengeSetting.
enum Difficulty:
    UNSET = 0,
    NORMAL = 1,
    HARD = 2,
    EXPERT = 3,
    LEGENDARY = 5,

# Challenge IDs also index challengeVoteList and the pregame menu tables.
# Insanity and Pandora's Box share the Insanity stat tables (IDs >= INSANITY).
enum Challenge:
    NO_PREFERENCE = 0,
    NONE = 1,
    SWARM_SHOOTOUT = 2,
    RANDOM_ABILITIES = 3,
    INSANITY = 4,
    PANDORAS_BOX = 5,

# Enhancement IDs index enhancementOptionList and the start-menu tables.
# Zero means no preference; initialization randomly selects a real ID 1-13.
# Brain Killer remains the first explicit menu choice.
enum Enhancement:
    NO_PREFERENCE = 0,
    BRAIN_KILLER = 1,
    ZOMBIE_HYBRID = 2,
    PYROTECHNIC = 3,
    PLAGUE_DOCTOR = 4,
    BORN_TO_BATTLE = 5,
    CHARGE_BATTERY = 6,
    HITCHHIKER = 7,
    PUP = 8,
    OVERCHARGE = 9,
    BULKING_SEASON = 10,
    DEAD_WEIGHT = 11,
    BOLT_STRIKE = 12,
    ENGINEER = 13,

# Independent secondary enhancement slot. IDs index the augment name, icon and color tables.
enum Augment:
    NO_PREFERENCE = 0,
    KEVLAR = 1,
    DASH = 2,
    DOUBLE_JUMP = 3,
    LONG_REACH = 4,
    AMMO_PACK = 5,
    GRAPNEL_LAUNCHER = 6,
    LASER_BARRICADE = 7,
    APOTHECARY = 8,
    SCAVENGER = 9,
    LEECH = 10,

# Icon tables, indexed by their corresponding selection ID.
#!define ENHANCEMENT_ICONS enhancementIconListConst
#!define AUGMENT_ICONS augmentIconListConst
#!define AUGMENT_COLORS augmentColorListConst
# Augment name table, indexed by selection ID; melee-augment hero tables, checked by hero.
#!define AUGMENT_NAMES augmentNameListConst
#!define LONG_REACH_MELEE_WEAPON_HEROES augmentMeleeWeaponHeroListConst
#!define LONG_REACH_MELEE_BUTTON_WEAPON_HEROES augmentMeleeBtnHeroListConst

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

enum CameraMode:
    NORMAL = 0,
    PRECISE = 1,

# Fields of playerStatsList[user index] and reconnectRowSnapshot; full-row writes follow this order.
enum ReconnectField:
    STATUS = 0,
    RESCUE_TIME_REMAINING = 1,
    REVIVE_TIME_REMAINING = 2,
    REVIVE_DURATION = 3,
    POSITION = 4,

# Ordered saved statuses: >= DOWNED includes players awaiting revival and permanently dead players.
enum ReconnectStatus:
    ALIVE = 0,
    DOWNED = 1,
    DEAD = 2,

# Carried and ground item IDs; NONE is the empty active slot.
# Real IDs are contiguous CURE..STUN; display tables use ID - 1.
enum PowerUpItem:
    NONE = 0,
    CURE = 1,
    REVIVE = 2,
    FORCE_FIELD = 3,
    NO_COOLDOWNS = 4,
    AIR_STRIKE = 5,
    HEALING_BEACON = 6,
    VACCINE = 7,
    SENTRY_TURRET = 8,
    CLOAKING_DEVICE = 9,
    SUPER_NANO = 10,
    JETPACK = 11,
    ULTIMATE_CHARGER = 12,
    STUN = 13,

# Remaining sparse indices in powerUpEntityIdList; frequently used IDs have dedicated player variables below.
# Turret effect slots 50..54 stay contiguous for creation and cleanup loops.
enum PowerUpEntitySlot:
    FORCE_FIELD_HUD = 11,
    AIR_STRIKE_CLOUD = 31,
    HEAL_BEACON_RING = 41,
    HEAL_BEACON_HUD = 42,
    HEAL_BEACON_AURA = 43,
    SENTRY_TURRET_BODY = 50,
    SENTRY_TURRET_LEG_1 = 51,
    SENTRY_TURRET_LEG_2 = 52,
    SENTRY_TURRET_LEG_3 = 53,
    SENTRY_TURRET_BARREL = 54,
    SENTRY_TURRET_HUD = 55,
    CLOAKING_DEVICE_HUD = 61,
    SUPER_NANO_HUD = 71,
    SUPER_NANO_BAD_AURA = 72,
    SUPER_NANO_DAMAGE_DEALT_MODIFICATION = 73,
    SUPER_NANO_DAMAGE_RECEIVED_MODIFICATION = 74,
    JETPACK_FLIGHT_EFFECT = 82,

# Global variables

# Naming: booleans start with is; stable arrays end with List.
# Objective-type prefixes identify dedicated state; shared/polymorphic slots use neutral names.
# Use a role alias in each objective; neutral *Slot globals describe storage, not gameplay meaning.
# Shared names remain appropriate where the meaning is common (objectiveRad, objectiveColor, bossStateList).
# numbersList is owned by compressed numbers.opy; debugHud is owned by debug.opy.

# Shared scratch slots.
# Define a semantic #!define alias next to each use; access scratch through that alias.
# Finish scratch use before wait/waitUntil or async calls; use separate slots for simultaneous values.
# Synchronous helper arguments/results require an explicit, audited contract; other calls may overwrite scratch.
# Capture scratch references in reevaluated visuals with evalOnce, and document each assignment locally.
globalvar tmp0  # Synchronous scratch, including Rescue path index and Anran spawn source; assign before use, never retain across waits/async work.
globalvar tmp1  # Second synchronous scratch value, including bot teleport pivot, selectTarget candidates and barricade push geometry; never retain across waits/async work.
#!define botTeleportPivot tmp1
globalvar tmp2  # Third synchronous scratch value, including barricade's current target, mutation color captured with evalOnce for the outline, and the on-hit enhancements' health gate; no live reads across waits/async work.
globalvar tmp3  # Fourth synchronous scratch value, including barricade impulse vertical angle and the on-hit enhancements' victim; assigned and consumed within the same loop iteration, no reads across waits/async work.
# applyHitEnhancements inputs for Pyrotechnic, Overcharge and Bolt Strike.
# tmp2 is health before scripted Damage, then actual health removed in the macro.
# Native callers supply eventDamage directly; the handler accepts positive damage.
# Pyro/Overcharge preserve inputs; Bolt consumes tmp2/tmp3 for chain damage/targets.
# The handler preserves tmp0/tmp1; consume before waits/async calls.
#!define enhancementHitHealthBefore tmp2
#!define enhancementHitDamage tmp2
#!define enhancementHitVictim tmp3

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

globalvar phaseSlot6  # Extraction flight destination; WIN/LOSS CONDITIONS sets it before evacSurvivorList.
#!define extractionFlightDestination phaseSlot6

globalvar phaseSlot7  # Extraction flight speed (2/10/50); WIN/LOSS CONDITIONS initializes it before evacSurvivorList.
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

globalvar biomorphingGoalColor  # Initialized at START GAME, independently of the still-active pregame camera.
globalvar currentObjectivePosition  # Mirrors the objective queue head, including moving eggs.

# Shared immutable colors and positions.
# Use Vector directions directly for unit offsets; scaling adds a multiplication and scalar.
# Shared offsets below cache that expression once, saving elements across repeated uses.
globalvar offsetUpThreeQuartersConst = 0.75 * Vector.UP    # Vertical offset of 0.75 m for labels, icons and visibility checks. Source uses: 7 (excluding declaration).
globalvar offsetUpHalfConst = 0.5 * Vector.UP              # Vertical offset of 0.5 m for labels and effects. Source uses: 7 (excluding declaration).
globalvar losOffsetConst = 1.2 * Vector.UP                 # Vertical offset of 1.2 m used by line-of-sight checks. Source uses: 16 (excluding declaration).
globalvar dummyHoldingPositionConst = vect(500, 500, 500)  # Off-map holding position for newly created or reconfigured dummy bots. Source uses: 6 (excluding declaration).
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
globalvar challengeSetting      # Challenge ID, retained after pregame voting.
globalvar zombieSetting         # Selected zombie roster/spawn-rate mode, retained after pregame voting.
globalvar objectiveTypeSetting  # Selected objective mode or Mixed setting; differs from the current objective type.
globalvar matchEndTime          # Native-gamemode timer offset: zero or 0.1, used as the match-time floor.
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

# Cameras keep reevaluating these coordinates until each player's initialization finishes.
# Their lifetime overlaps mission initialization; do not share them with gameplay storage.
globalvar startPos                       # Center/aim position of the pregame hero-selection scene.
globalvar startCamPos                    # Pregame camera position used to place players and world text.

# Shared objective generation and runtime state.
globalvar objectivePositionList          # Queued objective positions; index zero is current, the final entry is extraction.
globalvar objectiveTypeList              # Queued objective types aligned with objectivePositionList.

# Keep these head caches synchronized immediately after every queue mutation, before waits/calls.
# objectiveValue remains the separate type snapshot published by the objective visuals.
# currentObjectiveType uses phaseSlot10 above; currentObjectivePosition has independent storage.
# During the menu, type predicates still see a non-objective ID (0 or 40); after cleanup both mirror their queue heads.
globalvar objectiveSpacingList           # Consecutive/minimum placement distances calculated from the map-grid size.
globalvar objectiveValue                 # Current type snapshot published when global objective visuals are refreshed.
globalvar objectiveProgressSlot          # Shared progress storage; generic reset in objectivesManagement, role-specific HUD/rules below.
#!define objectiveProgress objectiveProgressSlot
#!define showdownCapturePercent objectiveProgressSlot
#!define biomorphingCapturePercent objectiveProgressSlot
#!define killZoneEliminationScore objectiveProgressSlot
#!define satelliteTerminalProgressList objectiveProgressSlot
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

globalvar objectiveMotionSlot            # Rescue saved radius or Kill Zone center; subroutines/objectives/bots.
#!define rescueSavedRadius objectiveMotionSlot
#!define killZoneCenter objectiveMotionSlot

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
globalvar extractionSpeedUp            # Dome shrink speed (startup -> subroutines/extraction), starts at 2.5; separate from the late-written menu angle.
globalvar evacSurvivorList             # Snapshot of extracted players, also used to exclude survivors from finale kills.

# Supply drops and ground power-ups.
globalvar supplyDropLandingPosition  # Target ground position where the current supply drop will land.
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
globalvar healthpackPositionList  # Discovered health-pack positions for cure indicators and Apothecary's fallback teleport.
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

playervar invisibilityCount  # Stacking invisibility/untargetability counter; hero abilities and Cloaking Device increment/decrement it. Not a boolean.

playervar infectionDamageOverTimeId  # Active player infection damage-over-time ID; Zombie Hybrid stops this same damage instance.

playervar reconnectUserIndex  # Player name index into userNameList/playerStatsList for reconnect restoration.

playervar isAfk  # Player is treated as inactive/AFK and excluded from objectives or extraction counts.

playervar isHeroSwitchRespawn  # Player has switched heroes; prevents repeating first-spawn and enhancement initialization.

# Enhancements only (enhancement prefix; includes the Rescue Hitchhiker setup).
playervar enhancementId  # Selected Enhancement enum; pregame selection, runtime behavior and Rescue Hitchhiker initialization.

# Human Augment storage is independent of enhancements and power-ups.
# Team 2 Dead Weight roles are team-exclusive; no bot Augment owns these slots.
# Only the selected human augment owns them; selection is fixed once gameplay begins.
playervar augmentId  # Selected Augment enum; pregame Interact selection and gameplay effects.
playervar augmentState0
# Team 2 Dead Weight: carrier reference until release, including carrier disconnect.
# Humans use separate primary enhancement storage; no bot augment uses this slot.
#!define deadWeightZombieCarrier augmentState0
# Scavenger: up to two reserve item IDs, separate from the active powerup and primary enhancement.
# Retained through hero switches; death/manual drop clears it synchronously. Never activated.
#!define augmentScavengerBackpack augmentState0
# Apothecary: last pack pickup position, null until first pickup; zero vector is valid.
# Retained through death/hero switches; only this augment owns these slots.
#!define augmentApothecaryPosition augmentState0
# Boolean single teleport charge; refreshed on ultimate activation, spent on teleport.
# Retained through death/hero switches; HUD reevaluates it without a chase.
#!define augmentApothecaryReady augmentState1
# Laser Barricade placement facing direction; persists for collision checks.
#!define augmentBarrierFacing augmentState0
# Double Jump / Grapnel Launcher next allowed activation time; persists across landing and death, read by the HUD.
#!define augmentMovementReadyAt augmentState0
# Long Reach: next allowed Melee-button push; persists across death/hero changes.
# Only a press with eligible targets writes it; the augment HUD reads it live.
#!define augmentMeleePushReadyAt augmentState0
# Dash next charge recharge time; set when the meter first drops below full and
# advanced by each refill below max, read by the HUD countdown.
#!define augmentDashReadyAt augmentState0
# Double Jump next allowed activation time; only written on a successful extra jump.
#!define augmentJumpReadyAt augmentState0
# Ammo Pack cached [hero, weapon, doubled clip 0, doubled clip 1] entries; persists across respawns.
#!define augmentAmmoLoadoutList augmentState0

playervar augmentState1
# Dash smoke effect entity; retained across overlapping dashes, null after DASH
# SMOKE FADE removes it. Never write augmentIsAirActionReady for Dash: same slot.
#!define augmentDashSmokeEntity augmentState1
# Team 2 Dead Weight: carrier's 50% damage modifier, from pickup to synchronous
# release cleanup, before any throw-damage wait. Overwritten on each pickup.
# No bot Augment owns this slot; independent of all human powerup/augment state.
#!define deadWeightProtectionId augmentState1
# Laser Barricade unit edge direction; persists for collision checks.
#!define augmentBarrierEdgeDirection augmentState1
# Double Jump ONLY: armed after releasing Jump in midair; consumed once, cleared
# on landing/death. Writing this alias for Dash loses its live smoke entity.
#!define augmentIsAirActionReady augmentState1
# Ammo Pack current cached entry, retained through the hero/weapon/respawn wait.
#!define augmentAmmoLoadout augmentState1
# Long Reach hero snapshot; an interrupted attack cannot resume for a different hero.
#!define augmentMeleeHero augmentState1
# Long Reach target-loop index, after the windup's hero snapshot has been consumed; no waits or live captures.
#!define augmentMeleeTargetIndex augmentState1

playervar augmentState2
# Team 2 Dead Weight: carrier hero at pickup, retained until release. No human reader.
#!define deadWeightCarryHero augmentState2
# Laser Barricade: -2 reserves a Dead Weight press; -1 latches aiming until Interact release/death/cancel; 0 is ready,
# positive values are cooldown seconds. Owned by placement across waits; read by
# preview, HUD and power-up input exclusion. Clear the latch before every abort.
#!define augmentBarrierPlacementCooldown augmentState2
# Ammo Pack refill snapshot [clip 0 below native max, clip 1 below native max,
# was reloading, clip 0 ammo at reload start, clip 1 ammo at reload start].
# Null for supported native capacities. Otherwise initialized after loadout writes,
# updated only on native-full boundary / reload edges, and owned by this augment.
#!define augmentAmmoFallbackState augmentState2
# Long Reach's additional primary-weapon controller owns this profile across waits.
# D.Mon / Ramattra quick melee cancels the primary windup; other quick-melee users do not
# enter that controller. The helper does not modify this retained profile.
#!define augmentWeaponProfile augmentState2
# Dash's current charges; refilled by the recharge rule, spent only in the dash
# action. Reset to full on augment initialization (each non-hero-switch spawn).
#!define augmentDashCharges augmentState2
# Double Jump's last first-tap timestamp; zero means no pending tap. Only its
# Jump-press handler writes it; death clears it. The cooldown remains in state0.
#!define augmentJumpLastPressedAt augmentState2
# Grapnel Launcher alone owns a locked target (zombie or ally) and [launch
# hero, beam entity ID] across its pull waits. The live beam reads the target
# until it is destroyed; cleanup then clears both slots.
#!define augmentGrapnelTarget augmentState1
#!define augmentGrapnelState augmentState2

playervar augmentState3
# Team 2 Dead Weight: throw damage credit retained across the 0.75s wait.
# Pickup never writes this role; the inactive value is dead and needs no reset.
#!define deadWeightThrowDamageCredit augmentState3
# Laser Barricade center; retained across waits and reevaluated by live effects.
#!define augmentBarrierPosition augmentState3
# Double Jump: the +20% damage bonus was armed by an activation and lasts until
# the following landing. Cleared by the flight rule on landing/death; only the
# activation write and the flight rule own this slot.
#!define augmentJumpDamageActive augmentState3
# Dash smoke deadline; refreshed on every successful dash and read live by
# smoke cleanup. Invulnerability renews directly on activation; no other Dash use.
#!define augmentDashSmokeDeadline augmentState3

# Materialized DoT-gate state: while true, no zombie attack may start a NEW
# damage-over-time effect on this player (bite DoT, infection stacks, rocket/
# gas/boss burns, Bomber explosion). Already ticking DoTs, existing infection
# and direct hit damage are untouched. Written ONLY by
# applyDamageReceivedModifier, which every gate-state edge calls. Read by the
# bite, rocket, Molten Core, gas and explosion rules.
playervar isDotProtected
# Any active resist written by applyDamageReceivedModifier (Dash window,
# Super Nano or ultimate). Drives the health-HUD `*` marker.
playervar hasDamageResist

playervar enhancementHitchhikerPassenger  # Passenger attached to this carrier; null when absent. Infection rules also query it.

playervar enhancementCarrierPoolId  # Extra health-pool ID granted to a Hitchhiker carrier, retained for removal. Exported names must fit 32 characters.
#!define enhancementHitchhikerCarrierPoolId enhancementCarrierPoolId

# Engineer: an armor grant may target any Team 1 player, so target-side
# state cannot live in slots owned by the target's own enhancement or augment.
playervar scrapArmorAmount  # Modeled remaining scrap armor 0-80, topped up toward the cap by grants (at most one 40-armor pool per throw), decremented by damage events (scrap absorbs before the older Kevlar pool, so the decrement is exact). Cleared on death.

# Engineer: baseline of the native offensive + defensive assist count; assists
# earned above it pay scrap. Seeded on each spawn initialization like
# Overcharge's stat snapshot, resynced on every payout; native stats persist
# through death, so death clears nothing.
playervar engineerScrapAssistSnapshot

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

playervar isCrowdControlled  # Live boolean for both teams, set/reset by CROWD CONTROL STATUS. Excludes Rooted.
# The bot CC tracker itself and Team 1 consumers (Hitchhiker carriers, Dead Weight,
# Ana self Nano, augments) read this live flag; zombie behavior rules read the
# delayed flag below so a recent interruption still counts for up to 0.125s.
playervar botIsCrowdControlled  # Delayed Team 2 flag, lags CC exit by up to 0.125s. BOT STUN MANAGEMENT refreshes it; botRespawnInitialization resets it.

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
#!define augmentBarrierTargetList candidateTargetList

playervar sizeScale  # Current actor size multiplier, including mutations/abilities; shared by players, zombies, Rescue, item ranges and enhancements.

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

playervar actorLoopSlot  # Ensnarer melee loop index.
# Repeated Hazard boss ultimate index.
#!define botEnsnarerUltimateIndex actorLoopSlot

playervar abilityTargetList  # Zombie special-ability targets or common zombie/Hybrid explosion targets.
# Targets affected by zombie grabs, clouds, flight and slam abilities.
#!define botSpecialTargetList abilityTargetList
# Targets of explosionSequence, called by zombies and Team 1 Zombie Hybrid.
#!define explosionTargetList abilityTargetList

playervar movementSpeedScale  # Movement-speed multiplier used by zombie AI, players/Rescue, crowd control and supply items.

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

playervar actorTeamSlot2  # Boss return snapshot on Team 2 or carried item ID on Team 1.
# Boss eye-position snapshot written and cleared during return; currently not read.
#!define botReturnPosition actorTeamSlot2
# Active PowerUpItem ID; PowerUpItem.NONE means empty. Scavenger reserves never occupy this slot.
#!define powerUpItemId actorTeamSlot2

playervar actorTeamSlot3  # Team 2 teleport flag; Team 1 human challenge vote or Rescue dummy path. Menu writers are phase-guarded.
# Zombie is inside enterExitTeleport; spawn/target/ability consumers also read it.
#!define botIsTeleporting actorTeamSlot3
# Human challenge vote during pregame only; END VOTING aborts after the phase boundary.
#!define pregameChallengeVote actorTeamSlot3
# Recorded leader positions followed and trimmed by the Rescue NPC.
#!define rescuePathList actorTeamSlot3

playervar actorTeamSlot4  # Team 2: botLoopIndexSlot; Team 1: powerUpEntityIdList. Receivers, not rule teams, own the storage.
# Repeated Moira fade/attack index.
#!define botStalkerFadeIndex actorTeamSlot4
# Index into Ensnarer affected targets.
#!define botEnsnarerTargetIndex actorTeamSlot4
# Remaining sparse effect/HUD/damage-modification IDs owned by active items, indexed by PowerUpEntitySlot.
#!define powerUpEntityIdList actorTeamSlot4

# Frequently accessed item handles are kept directly on the owning player.
playervar powerUpForceFieldSphereId
playervar powerUpHealBeaconLightShaftId
playervar powerUpNoCooldownsHudId
playervar powerUpAirStrikeRingId
playervar powerUpCloakingDeviceSphereId
playervar powerUpSuperNanoGoodAuraId  # Super Nano good-aura entity; nonzero only while the power-up is active, and the flag the shared damage-intake recompute reads.
playervar powerUpJetpackIsFlying  # Dedicated boolean; also read by shared movement-speed updates on both teams.
playervar powerUpUltimateChargerHudId
playervar powerUpStunBeamId

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

playervar actorTeamSlot17  # Team 2: botMutationId; Team 1: powerUpJetpackFuel. Receivers own storage.
# Selected mutation ID; zero means no mutation.
#!define botMutationId actorTeamSlot17
# Jetpack fuel, 0..POWERUP_JETPACK_FUEL_MAX; chased only on Team 1 during flight; item 11 adds up to 100.
# Retained between flights/respawns and read by the fuel HUD; never use as scratch.
#!define powerUpJetpackFuel actorTeamSlot17

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

playervar actorTeamSlot21  # Team 2: botLastTarget; Team 1: pregame objective vote. Pregame readers/writers end before gameplay.
# Last visible/attacking target retained when zombie line of sight is lost.
#!define botLastTarget actorTeamSlot21
# Human objective vote during pregame only; distinct from the selected global objective mode.
#!define pregameObjectiveVote actorTeamSlot21

playervar actorTeamSlot22  # Boss gas positions on Team 2 or enhancement state on Team 1.
# Boss Behemoth active gas-cloud positions.
#!define botGasPositionList actorTeamSlot22
# Dead Weight: human-owned held zombie, retained for HUD and bot release.
# Exclusive primary enhancement, independent of all human Augments and bot state.
# Initialization writes null; pickup alone writes a player reference.
#!define enhancementHeldZombie actorTeamSlot22
# Zombie Hybrid explosion cooldown in seconds.
#!define enhancementHybridCooldown actorTeamSlot22
# Pyrotechnic hit queue; repeated targets determine fire damage.
#!define enhancementPyroHitList actorTeamSlot22
# Total infection levels cured by Plague Doctor.
#!define enhancementPlagueCureTotal actorTeamSlot22
# Bulking Season: retained stacks; each credited elimination (kill/damage participation) adds one; death halves it (rounded down).
# Exclusive primary enhancement, owned by this human; safe alongside all independent Augments.
#!define enhancementBulkStacks actorTeamSlot22
# Overcharge: unspent energy (native Healing Dealt 1:3, +10 per offensive/defensive assist), independent of an armed burst.
# Exclusive primary enhancement; its selected human owns the native-stat earnings,
# charge spending and persistent balance; never write it on an enemy target.
#!define enhancementCapacitorEnergy actorTeamSlot22
# Bolt Strike: actual chain health removed plus 0.3 per primary hero hit,
# capped at 350; retained on death.
# Exclusive primary enhancement on its attacking human; no Augment owns this slot.
#!define enhancementBoltEnergy actorTeamSlot22
# Born to Battle unspent ability resets (0-2); retained through ability waits and reevaluated by its HUD.
#!define enhancementBattleResetCharges actorTeamSlot22
# Placed Charge Battery position; zero clears it.
#!define enhancementBatteryPosition actorTeamSlot22
# Hitchhiker carrier; zero when detached.
#!define enhancementHitchhikerCarrier actorTeamSlot22
# P.U.P. mode color.
#!define enhancementPupColor actorTeamSlot22
# Engineer: scrap balance 0-300, earned from eliminations and the income
# rule, spent on armor grants and turret deployment. Survives death and hero
# switches; reset to 0 by START GAME, never per spawn.
#!define enhancementScrap actorTeamSlot22

playervar actorTeamSlot23  # Team 2: botGasRadiusList; Team 1: enhancementStateSlot2. Receivers, not rule teams, own the storage.
# Boss Behemoth gas-cloud radii, aligned with botGasPositionList.
#!define botGasRadiusList actorTeamSlot23
# Dead Weight: hold deadline; 0 requests a throw. Read only while a zombie is held.
# Pickup overwrites it; no chase, wait or human Augment owns this role.
#!define enhancementHoldUntil actorTeamSlot23
# Overcharge: energy spent on the armed/active burst, retained across damage events and HUD reevaluation.
#!define enhancementCapacitorCharge actorTeamSlot23
# Bulking Season: persistent size/pitch toggle on its human; false means stacked
# size (default), true means native size/pitch. Exclusive primary enhancement;
# no chase or asynchronous writer; retained across deaths and hero switches.
#!define enhancementBulkNormalSize actorTeamSlot23
# Born to Battle button whose charge/cooldown is reset.
#!define enhancementBattleAbilityButton actorTeamSlot23
# Battery remaining reuse cooldown.
#!define enhancementBatteryReuseCooldown actorTeamSlot23
# Extra health-pool ID on the Hitchhiker passenger.
#!define enhancementHitchhikerPassengerPoolId actorTeamSlot23
# P.U.P. attack beam is active.
#!define enhancementIsPupBeamActive actorTeamSlot23
# Engineer's transfer beam entity; null after BEAM FADE, death and
# disconnect cleanup. Beam state re-cleans on every non-hero-switch spawn.
#!define enhancementScrapBeamEntity actorTeamSlot23
# Bolt Strike's synchronous original-hit victim, owned by the attacking
# human only. No other Bolt state, Augment, wait/chase or HUD reads this slot.
#!define enhancementBoltVictim actorTeamSlot23

playervar actorTeamSlot24  # Team 2: botSpawnWaypoint; Team 1: enhancementStateSlot3. Receivers, not rule teams, own the storage.
# Movement waypoint associated with the accepted zombie spawn point.
#!define botSpawnWaypoint actorTeamSlot24
# Overcharge: absolute burst deadline; zero means armed but waiting for its first hit.
# Set once by the first hit, read by later hits, cleared with the charge on expiry/death.
#!define enhancementCapacitorDeadline actorTeamSlot24
# Bolt Strike: 0 inactive, -1 armed until the first eligible hit; consumed once.
# Exclusive primary enhancement; read across damage events/HUD, with no waits/chases.
#!define enhancementBoltBurst actorTeamSlot24
# Full battery reuse cooldown used for progress scaling (10 seconds).
#!define enhancementBatteryReuseDuration actorTeamSlot24
# Current P.U.P. enemy target; null while idle.
#!define enhancementPupTarget actorTeamSlot24
# Engineer's live beam endpoint; the reevaluating beam reads this slot
# until the beam is destroyed. Set synchronously before each beam (re)creation,
# cleared by BEAM FADE and spawn initialization.
#!define enhancementScrapBeamTarget actorTeamSlot24

playervar actorTeamSlot25  # Team 2: botCandidateTarget; Team 1: enhancementStateSlot4. Receivers, not rule teams, own the storage.
# First candidate that passed line of sight in selectTarget; null when none passed.
#!define botCandidateTarget actorTeamSlot25
# Overcharge: last credited native Healing Dealt / 3 + 10 * (offensive + defensive assists).
# Exclusive primary enhancement; retained across death/hero changes, no wait/chase/HUD ownership.
#!define enhancementCapacitorStatsSnapshot actorTeamSlot25
# Battery remaining placement cooldown.
#!define enhancementBatteryPlacementCooldown actorTeamSlot25
# P.U.P. freezing aura is visible.
#!define enhancementIsPupFreezeAuraActive actorTeamSlot25
# Engineer beam deadline; refreshed on every armor transfer and read live
# by BEAM FADE. No other Engineer use of this slot.
#!define enhancementScrapBeamDeadline actorTeamSlot25
# Bolt Strike's synchronous chain-target health snapshot. Owned by the attacking
# human; no other Bolt state, Augment, wait/chase or HUD reads this slot.
#!define enhancementBoltHealthBefore actorTeamSlot25

playervar actorTeamSlot26  # Teleport permission on Team 2 or first barrier corner on Team 1.
# Zombie initialization has enabled teleport processing.
#!define botIsTeleportAllowed actorTeamSlot26
# Barrier first lower corner.
#!define augmentBarrierCorner1 actorTeamSlot26

playervar actorTeamSlot27  # Team 2: Bolt Strike flash deadline; Team 1: second barrier corner.
# Next allowed Bolt Strike flash time on this zombie, shared across attackers.
# Default 0 permits its first flash; retained across respawns (at most 0.5s).
# Written only on a flash; no chase, waits or reevaluated visuals own this slot.
#!define botBoltFlashReadyAt actorTeamSlot27
# Barrier second lower corner.
#!define augmentBarrierCorner2 actorTeamSlot27

playervar actorTeamSlot28  # Team 2: Biomorphing resource icon IDs; Team 1 humans: camera mode.
# Zombie Biomorphing resource icon IDs; separate from the zombie visual-effect list.
#!define botResourceIconIdList actorTeamSlot28
# Human camera preference (0/1/2), retained across respawns and hero changes.
# Only Team 1 humans write/read this role; bot icon cleanup owns Team 2 receivers.
# Start Camera reevaluates player geometry, not this slot; no wait/chase owns it.
#!define cameraMode actorTeamSlot28

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

playervar menuTradeItemSlot  # Human zombie vote; legacy slot name. Gameplay trades use synchronous scratch.
#!define pregameZombieVote menuTradeItemSlot

# Chased variables

# Global chase storage.

globalvar objectiveRad                   # Current objective radius; also chased or temporarily expanded by some objective types.

globalvar satelliteLaserPosition         # Chased Satellite laser position; isolated from objective storage.

globalvar extractionZoneRad            # Shrinking extraction-dome radius; initialized to 300 and also checked by defeat rules.

globalvar menuFinaleMotionSlot         # Global hidden countdown (startup/menu/setPrematchTimer), then nukeMap projectile position.
# nukeMap stops the countdown chase before assigning a vector; the separate actorMotionSlot1 player storage has its own role aliases.
#!define pregameCountdown menuFinaleMotionSlot
#!define nukeProjectilePosition menuFinaleMotionSlot

globalvar supplyDropPosition         # Current supply-drop position, animated while it falls.

# Player chase storage.

playervar infectionLevel  # Player infection/vaccine level; negative values represent vaccination.

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

playervar damageOverTimeRemaining  # Tracked DoT duration, normally chased on zombies; one Rusher rule writes it on the victim. Preserve that receiver.

playervar botReturnTime  # Seconds without a boss target, chased to 15; isolated from snapshots and item IDs.

playervar actorTeamSlot12  # Team 2: botBossHealth; Team 1: powerUpStunBeamPosition. Receivers, not rule teams, own the storage.
# Virtual boss/egg health adjusted by damage events; -1 when not a boss.
#!define botBossHealth actorTeamSlot12
# Chased stun-chain beam endpoint retained across bounces/waits.
#!define powerUpStunBeamPosition actorTeamSlot12

playervar botAbilityCooldown  # Chased Hazard special-ability cooldown; isolated from gas lists and enhancement state.

playervar enhancementPupPosition  # Chased P.U.P. world position; isolated from teleport flags and barrier corners.

playervar botReigniteRisePosition  # Chased Anran emergence position, forced across the rise wait; independent of P.U.P. and barriers.

playervar enhancementPupCooldown  # Chased P.U.P. ability cooldown (1 or 2 seconds); independent of positions.

playervar augmentBarrierHealth  # Chased Laser Barricade health; placement, damage, regeneration and HUD; independent of icon IDs.

# Immutable Augment icons, indexed by selection ID and initialized once before UI rules.
# Shared by the pregame menu, world labels, personal HUD and roster throughout the match.
# Keep a dedicated slot: pregame storage is reused by objectives during gameplay.
enum AugmentIcon:
    NO_PREFERENCE = iconString(Icon.QUESTION_MARK),
    KEVLAR = "<TX C0000000004F73E>", # <TX C00000000004120>
    DASH = iconString(Icon.ARROW_RIGHT),
    DOUBLE_JUMP = iconString(Icon.ARROW_UP),
    LONG_REACH = abilityIconString(Hero.DOOMFIST, Button.SECONDARY_FIRE),
    AMMO_PACK = "<TX C0000000004F73A>",
    GRAPNEL_LAUNCHER = iconString(Icon.DIZZY),
    LASER_BARRICADE = iconString(Icon.DIAMOND),
    APOTHECARY = "<TX C0000000004F73B>",
    SCAVENGER = iconString(Icon.RECYCLE),
    LEECH = iconString(Icon.ASTERISK),

globalvar augmentIconListConst = [AugmentIcon.NO_PREFERENCE, AugmentIcon.KEVLAR, AugmentIcon.DASH, AugmentIcon.DOUBLE_JUMP, AugmentIcon.LONG_REACH, AugmentIcon.AMMO_PACK, AugmentIcon.GRAPNEL_LAUNCHER, AugmentIcon.LASER_BARRICADE, AugmentIcon.APOTHECARY, AugmentIcon.SCAVENGER, AugmentIcon.LEECH]

# Immutable Enhancement icons, indexed by selection ID; shared by pregame options and roster.
# Keep a dedicated slot: enhancementOptionList becomes Biomorphing text after menu cleanup.
enum EnhancementIcon:
    NO_PREFERENCE = iconString(Icon.QUESTION_MARK),
    BRAIN_KILLER = iconString(Icon.SKULL),
    ZOMBIE_HYBRID = iconString(Icon.POISON),
    PYROTECHNIC = iconString(Icon.FIRE),
    PLAGUE_DOCTOR = iconString(Icon.PLUS),
    BORN_TO_BATTLE = "<TX C000000000039D7>",
    CHARGE_BATTERY = iconString(Icon.SPIRAL),
    HITCHHIKER = iconString(Icon.FLAG),
    PUP = iconString(Icon.HAPPY),
    OVERCHARGE = iconString(Icon.MOON),
    BULKING_SEASON = "<TX C0000000002A9ED>",
    DEAD_WEIGHT = iconString(Icon.TRASHCAN),
    BOLT_STRIKE = iconString(Icon.BOLT),
    ENGINEER = "<TX C0000000005FA7F>",

globalvar enhancementIconListConst = [EnhancementIcon.NO_PREFERENCE, EnhancementIcon.BRAIN_KILLER, EnhancementIcon.ZOMBIE_HYBRID, EnhancementIcon.PYROTECHNIC, EnhancementIcon.PLAGUE_DOCTOR, EnhancementIcon.BORN_TO_BATTLE, EnhancementIcon.CHARGE_BATTERY, EnhancementIcon.HITCHHIKER, EnhancementIcon.PUP, EnhancementIcon.OVERCHARGE, EnhancementIcon.BULKING_SEASON, EnhancementIcon.DEAD_WEIGHT, EnhancementIcon.BOLT_STRIKE, EnhancementIcon.ENGINEER]

# Immutable palette shared by the pregame menu and gameplay HUD; indexed by Augment.
globalvar augmentColorListConst = [Color.AQUA, Color.LIGHT_GRAY, Color.YELLOW, Color.SKY_BLUE, Color.ORANGE, Color.WHITE, Color.TURQUOISE, Color.BLUE, Color.GREEN, Color.LIME_GREEN, Color.RED]

# Immutable augment names, indexed by selection ID; shared by the augment menu and combat HUD.
# Melee-augment hero tables; the extended list also provides the index for per-hero melee values.
# Initialized in VARIABLE ASSIGNMENT, not here: module-level initializers let the optimizer
# fold the string table back into its use sites and drop the assignment as dead code.
globalvar augmentNameListConst
globalvar augmentMeleeWeaponHeroListConst
globalvar augmentMeleeBtnHeroListConst
