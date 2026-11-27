#!mainFile "../../main.opy"

#!define BUILD_DATE() __script__("../tools/build_date.js")

# General
#!define DEFAULT_OBJECTIVE_COUNT 5
#!define DEFAULT_ZOMBIE_COUNT 7
#!define DEFAULT_ZOMBIE_SPAWN_SERVER_LOAD_LIMIT 200
#!define DEFAULT_ALLOW_AFK true

# Power Ups
#!define DEFAULT_SUPPLY_DROP_POWER_UP_COUNT 6

# Infection
#!define DEFAULT_MELEE_INFECTION true

# Available Objective Types
#!define DEFAULT_OBJECTIVE_SHOWDOWN true
#!define DEFAULT_OBJECTIVE_BOSSES true
#!define DEFAULT_OBJECTIVE_KILL_ZONE true
#!define DEFAULT_OBJECTIVE_ZOMBIE_EGG true
#!define DEFAULT_OBJECTIVE_SATELLITE_UPLINK true
#!define DEFAULT_OBJECTIVE_MIXED_OBJECTIVES true

# Mixed Objectives Pool
#!define DEFAULT_MIXED_OBJECTIVE_STANDOFF true
#!define DEFAULT_MIXED_OBJECTIVE_BOSSES true
#!define DEFAULT_MIXED_OBJECTIVE_BIOMORPHING true
#!define DEFAULT_MIXED_OBJECTIVE_SURVIVOR_RESCUE true
#!define DEFAULT_MIXED_OBJECTIVE_KILL_ZONE true
#!define DEFAULT_MIXED_OBJECTIVE_ZOMBIE_EGG true
#!define DEFAULT_MIXED_OBJECTIVE_SATELLITE_UPLINK true

# Mutations
#!define DEFAULT_MUTATION_SPEED true
#!define DEFAULT_MUTATION_SIZE_GROWTH true
#!define DEFAULT_MUTATION_SIZE_REDUCTION true
#!define DEFAULT_MUTATION_RADIOACTIVE true
#!define DEFAULT_MUTATION_HEAVY true

# Challenge Toggle
#!define DEFAULT_CHALLENGE_SWARM_SHOOTOUT true
#!define DEFAULT_CHALLENGE_RANDOM_ABILITIES true
#!define DEFAULT_CHALLENGE_INSANITY true
#!define DEFAULT_CHALLENGE_PANDORAS_BOX true

# Zombie Mode Toggle
#!define DEFAULT_ZOMBIE_MODE_NEW_BLOOD true
#!define DEFAULT_ZOMBIE_MODE_WHATLL_IT_BE true
#!define DEFAULT_ZOMBIE_MODE_ZOMBIE_SHUFFLE true
#!define DEFAULT_ZOMBIE_MODE_DINNER_RUSH true
#!define DEFAULT_ZOMBIE_MODE_HAM_N_HAMMER true

macro STANDARD_TEAM1_HERO_SETTINGS = {
    # Tanks
    "dmon": {"damageDealt%": 88},
    "domina": {"damageDealt%": 88},
    "doomfist": {"damageDealt%": 88},
    "dva": {"damageDealt%": 88},
    "hazard": {"damageDealt%": 88},
    "junkerQueen": {"damageDealt%": 88},
    "mauga": {"damageDealt%": 88},
    "orisa": {"damageDealt%": 88},
    "ramattra": {"damageDealt%": 88},
    "reinhardt": {"damageDealt%": 88},
    "roadhog": {"damageDealt%": 88},
    "sigma": {"damageDealt%": 88},
    "winston": {"damageDealt%": 88},
    "wreckingBall": {"damageDealt%": 88},
    # Particle Barrier: 12s to 11s. Projected Barrier: 9s to 8s.
    "zarya": {"damageDealt%": 88, "ability1Cooldown%": 91.67, "ability2Cooldown%": 88.89},
    # Damage
    "anran": {"damageDealt%": 94},
    "ashe": {"damageDealt%": 94},
    "bastion": {"damageDealt%": 94},
    "cassidy": {"damageDealt%": 94},
    "echo": {"damageDealt%": 94},
    "emre": {"damageDealt%": 94},
    "freja": {"damageDealt%": 94},
    "genji": {"damageDealt%": 94},
    "hanzo": {"damageDealt%": 94},
    "junkrat": {"damageDealt%": 94},
    "mei": {"damageDealt%": 94},
    "pharah": {"damageDealt%": 94},
    "reaper": {"damageDealt%": 94},
    "shion": {"damageDealt%": 94},
    "sierra": {"damageDealt%": 94},
    "sojourn": {"damageDealt%": 94},
    "soldier": {"damageDealt%": 94},
    "symmetra": {"damageDealt%": 94},
    "torbjorn": {"damageDealt%": 94},
    "tracer": {"damageDealt%": 94},
    "vendetta": {"damageDealt%": 94},
    "venture": {"damageDealt%": 94},
    "widowmaker": {"damageDealt%": 94}
}

macro STANDARD_WORKSHOP_SETTINGS = {
    # General
    "Number of Objectives": DEFAULT_OBJECTIVE_COUNT,
    "Number of zombies": DEFAULT_ZOMBIE_COUNT,

    # # Power Ups
    # "Number of Powerups Per Supply Drop": DEFAULT_SUPPLY_DROP_POWER_UP_COUNT,
    # # OverPy appends U+0001 to the emitted Workshop setting name in the AFK condition.
    # "Allow players to go AFK\u0001": DEFAULT_ALLOW_AFK,
    # "Spawn Zombies When Server Load Average is Less Than": DEFAULT_ZOMBIE_SPAWN_SERVER_LOAD_LIMIT,
    # # Infection
    # "Melee Infection Enabled": DEFAULT_MELEE_INFECTION,
    # # Available Objective Types
    # "Showdown": DEFAULT_OBJECTIVE_SHOWDOWN,
    # "Bosses": DEFAULT_OBJECTIVE_BOSSES,
    # "Kill Zone": DEFAULT_OBJECTIVE_KILL_ZONE,
    # "Zombie Egg": DEFAULT_OBJECTIVE_ZOMBIE_EGG,
    # "Satellite Uplink": DEFAULT_OBJECTIVE_SATELLITE_UPLINK,
    # "Mixed Objectives": DEFAULT_OBJECTIVE_MIXED_OBJECTIVES,
    # # Mixed Objectives Pool
    # "Standoff.": DEFAULT_MIXED_OBJECTIVE_STANDOFF,
    # "Bosses.": DEFAULT_MIXED_OBJECTIVE_BOSSES,
    # "Biomorphing.": DEFAULT_MIXED_OBJECTIVE_BIOMORPHING,
    # "Survivor Rescue.": DEFAULT_MIXED_OBJECTIVE_SURVIVOR_RESCUE,
    # "Kill Zone.": DEFAULT_MIXED_OBJECTIVE_KILL_ZONE,
    # "Zombie Egg.": DEFAULT_MIXED_OBJECTIVE_ZOMBIE_EGG,
    # "Satellite Uplink.": DEFAULT_MIXED_OBJECTIVE_SATELLITE_UPLINK,
    # # Mutations
    # "Chance to mutate percentage": 25,
    # "Speed": DEFAULT_MUTATION_SPEED,
    # "Size Growth": DEFAULT_MUTATION_SIZE_GROWTH,
    # "Size Reduction": DEFAULT_MUTATION_SIZE_REDUCTION,
    # "Radioactive": DEFAULT_MUTATION_RADIOACTIVE,
    # "Heavy": DEFAULT_MUTATION_HEAVY,
    # # Challenge Toggle
    # "Swarm Shootout": DEFAULT_CHALLENGE_SWARM_SHOOTOUT,
    # "Random Abilities": DEFAULT_CHALLENGE_RANDOM_ABILITIES,
    # "Insanity": DEFAULT_CHALLENGE_INSANITY,
    # "Pandora's Box": DEFAULT_CHALLENGE_PANDORAS_BOX,
    # # Zombie Mode Toggle
    # "New Blood": DEFAULT_ZOMBIE_MODE_NEW_BLOOD,
    # "What'll it be?": DEFAULT_ZOMBIE_MODE_WHATLL_IT_BE,
    # "Zombie Shuffle": DEFAULT_ZOMBIE_MODE_ZOMBIE_SHUFFLE,
    # "Dinner Rush!": DEFAULT_ZOMBIE_MODE_DINNER_RUSH,
    # "Ham N' Hammer!": DEFAULT_ZOMBIE_MODE_HAM_N_HAMMER
}

settings {
    "main": {
        "description": f"Fight against an endless horde of zombies while completing various objectives.\r\nGet to the extraction point and watch the map get nuked. Don't leave anyone behind!\r\n\r\nver: {VERSION} ({BUILD_DATE()})\r\nMod Creator: snky#21990\r\n\r\nBased on:\r\n[ZSM Mod: workshop.codes/786TW]\r\n[ZSM Creator: Kamenrider#11346]\r\n\r\n[Original Mod Code: MPJFR]\r\n[Original Mod Creator: Mazattack#1183]\r\n\r\nCommunity ZSM Discord: https://discord.gg/3BhYtNfwMj",
        "modeName": "Zombie Survival Missions Re."
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "team1Slots": SETTINGS_TEAM1_SLOTS,
        "spectatorSlots": 7,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "assault": {
            MAP_POOL_ASSAULT
            "captureSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ctf": {
            MAP_POOL_CTF
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
            MAP_POOL_CLASH
            "captureSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "control": {
            MAP_POOL_CONTROL
            "captureSpeed%": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "controlBalancedOverwatch": {
            "enabled": false
        },
        "elimination": {
            "enabled": false
        },
        "escort": {
            MAP_POOL_ESCORT
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escortBalancedOverwatch": {
            "enabled": false
        },
        "flashpoint": {
            MAP_POOL_FLASHPOINT
            "captureSpeed%": 10,
            "scoreToWin": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybridBalancedOverwatch": {
            "enabled": false
        },
        "hybrid": {
            MAP_POOL_HYBRID
            "captureSpeed%": 10,
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "practiceRange": {
            "enabled": false
        },
        "pushBalancedOverwatch": {
            "enabled": false
        },
        "push": {
            MAP_POOL_PUSH
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "skirmish": {
            "enabled": false
        },
        "tdm": {
            MAP_POOL_TDM
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
        "team1": SETTINGS_TEAM1_HEROES,
        "team2": {
            "general": {
                "abilityCooldown%": 0,
                "passiveHealthRegen": false
            }
        }
    },
    "workshop": SETTINGS_WORKSHOP
}
