#!mainFile "../../main.opy"

#!define BUILD_DATE() __script__("../../tools/build_date.js")

# Standard map rotation. Each macro inserts a settings entry with its trailing comma.
#!define DEFAULT_MAP_POOL_ASSAULT "enabled": true,
#!define DEFAULT_MAP_POOL_CTF "disabledMaps": ["busanSanctuaryLny", "lijiangControlCenterLny", "lijiangGardenLny", "oasisCityCenter", "oasisGardens", "oasisUniversity"],
#!define DEFAULT_MAP_POOL_CLASH "enabled": true,
#!define DEFAULT_MAP_POOL_CONTROL "enabledMaps": [{"antarcticPeninsula": ["morning"]}, "oasis", "samoa"],
#!define DEFAULT_MAP_POOL_ESCORT "disabledMaps": ["watchpointGibraltar"],
#!define DEFAULT_MAP_POOL_FLASHPOINT "enabled": true,
#!define DEFAULT_MAP_POOL_HYBRID "disabledMaps": ["eichenwalde", "kingsRow", "paraiso"],
#!define DEFAULT_MAP_POOL_PUSH "enabled": true,
#!define DEFAULT_MAP_POOL_TDM "enabledMaps": ["blackForest", "blackForestWinter", "castillo", "chateauGuillard", "chateauGuillardHalloween", "ecopointAntarctica", "ecopointAntarcticaWinter", "kanezaka", "malevento", "necropolis", "petra"],

macro STANDARD_TEAM1_HERO_SETTINGS = {
    # Tanks
    "dmon": {"damageDealt%": 90},
    "domina": {"damageDealt%": 90},
    "doomfist": {"damageDealt%": 90},
    "dva": {"damageDealt%": 90},
    "hazard": {"damageDealt%": 90},
    "junkerQueen": {"damageDealt%": 90},
    "mauga": {"damageDealt%": 90},
    "orisa": {"damageDealt%": 90},
    "ramattra": {"damageDealt%": 90},
    "reinhardt": {"damageDealt%": 90},
    "roadhog": {"damageDealt%": 90},
    "sigma": {"damageDealt%": 90},
    "winston": {"damageDealt%": 90},
    "wreckingBall": {"damageDealt%": 90},
    "zarya": {"damageDealt%": 90},
    # Damage
    "anran": {"damageDealt%": 95},
    "ashe": {"damageDealt%": 95},
    "bastion": {"damageDealt%": 95},
    "cassidy": {"damageDealt%": 95},
    "echo": {"damageDealt%": 95},
    "emre": {"damageDealt%": 95},
    "freja": {"damageDealt%": 95},
    "genji": {"damageDealt%": 95},
    "hanzo": {"damageDealt%": 95},
    "junkrat": {"damageDealt%": 95},
    "mei": {"damageDealt%": 95},
    "pharah": {"damageDealt%": 95},
    "reaper": {"damageDealt%": 95},
    "shion": {"damageDealt%": 95},
    "sierra": {"damageDealt%": 95},
    "sojourn": {"damageDealt%": 95},
    "soldier": {"damageDealt%": 95},
    "symmetra": {"damageDealt%": 95},
    "torbjorn": {"damageDealt%": 95},
    "tracer": {"damageDealt%": 95},
    "vendetta": {"damageDealt%": 95},
    "venture": {"damageDealt%": 95},
    "widowmaker": {"damageDealt%": 95}
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
    "workshop": {
        "Chance to mutate percentage": 25,
        "Number of Objectives": 5,
        "Number of zombies": SETTINGS_ZOMBIE_COUNT
    }
}
