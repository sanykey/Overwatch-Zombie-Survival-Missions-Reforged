#!mainFile "../main.opy"

settings {
    "main": {
        "description": "Fight against an endless horde of zombies while completing various objectives.\r\nUse power-ups found in supply drops while you fight off the horde.\r\nGet to the extraction point and watch the map get nuked. Don't leave anyone behind!\r\n\r\nMod Creator: snky#21990\r\n\r\nBased on:\r\n[ZSM Mod: workshop.codes/786TW]\r\n[ZSM Creator: Kamenrider#11346]\r\n\r\n[Original Mod Code: MPJFR]\r\n[Original Mod Creator: Mazattack#1183]\r\n\r\nCommunity ZSM Discord: https://discord.gg/3BhYtNfwMj",
        "modeName": "Zombie Survival Missions Re."
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "team1Slots": 6,
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
        "Number of zombies": 7
    }
}
