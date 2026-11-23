#!mainFile "../../main.opy"

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
# Zero means no preference; initialization rolls a role-eligible real ID.
# Tank-only Hybrid/Bulking Season start the random range; support-only Plague Doctor/Overcharge end it.
# Hitchhiker is last in the menu and outside the random range.
# Keep every indexed menu/HUD/icon table in this same order.
enum Enhancement:
    NO_PREFERENCE = 0,
    ZOMBIE_HYBRID = 1,
    BULKING_SEASON = 2,
    BRAIN_KILLER = 3,
    PYROTECHNIC = 4,
    BORN_TO_BATTLE = 5,
    CHARGE_BATTERY = 6,
    PUP = 7,
    WRESTLER = 8,
    BOLT_STRIKE = 9,
    ENGINEER = 10,
    AUSPEX_SCAN = 11,
    PLAGUE_DOCTOR = 12,
    OVERCHARGE = 13,
    HITCHHIKER = 14,

# Wrestler holds until Knocked Down ends; manual throws request release.
enum WrestlerCarryState:
    NONE = 0,
    HOLDING = 1,
    THROW_REQUESTED = 2,

# Indices into selectPullAimTarget's range table; no persistent state.
enum PullAimMode:
    GRAPNEL = 0,
    WRESTLER_PULL = 1,
    WRESTLER_GRAB = 2,
    BOLT_STRIKE = 3,

# Independent secondary enhancement slot. IDs index the augment name, icon and color tables.
enum Augment:
    NO_PREFERENCE = 0,
    KEVLAR = 1,
    DASH = 2,
    HIGHRISE = 3,
    TELEKINESIS = 4,
    AMMO_PACK = 5,
    GRAPNEL_LAUNCHER = 6,
    LASER_BARRICADE = 7,
    SCAVENGER = 8,
    SURVIVALIST = 9,

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
    SENTRY_TURRET = 7,
    CLOAKING_DEVICE = 8,
    SUPER_NANO = 9,
    ULTIMATE_CHARGER = 10,
    STUN = 11,

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

enum AugmentIcon:
    NO_PREFERENCE = iconString(Icon.QUESTION_MARK),
    KEVLAR = "<TX C0000000004F73E>", # <TX C00000000004120>
    DASH = iconString(Icon.ARROW_RIGHT),
    HIGHRISE = iconString(Icon.ARROW_UP),
    TELEKINESIS = abilityIconString(Hero.DOOMFIST, Button.SECONDARY_FIRE),
    AMMO_PACK = "<TX C0000000004F73A>",
    GRAPNEL_LAUNCHER = iconString(Icon.DIZZY),
    LASER_BARRICADE = iconString(Icon.DIAMOND),
    SCAVENGER = iconString(Icon.RECYCLE),
    SURVIVALIST = iconString(Icon.ASTERISK),

enum EnhancementIcon:
    NO_PREFERENCE = iconString(Icon.QUESTION_MARK),
    ZOMBIE_HYBRID = iconString(Icon.POISON),
    BULKING_SEASON = "<TX C0000000002A9ED>",
    BRAIN_KILLER = iconString(Icon.SKULL),
    PYROTECHNIC = iconString(Icon.FIRE),
    BORN_TO_BATTLE = "<TX C000000000039D7>",
    CHARGE_BATTERY = iconString(Icon.SPIRAL),
    AUSPEX_SCAN = iconString(Icon.EYE),
    HITCHHIKER = iconString(Icon.FLAG),
    PUP = iconString(Icon.HAPPY),
    WRESTLER = iconString(Icon.TRASHCAN),
    BOLT_STRIKE = iconString(Icon.BOLT),
    ENGINEER = "<TX C0000000005FA7F>",
    PLAGUE_DOCTOR = iconString(Icon.PLUS),
    OVERCHARGE = iconString(Icon.MOON),
