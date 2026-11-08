#!mainFile "../main.opy"

settings {
    "main": {
        "description": "Community ZSM Discord: https://discord.gg/3BhYtNfwMj\r\n\r\nCreated by snky#21990",
        "modeName": "Zombie Survival Missions Experiments"
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
            "enabled": false
        },
        "ctf": {
            "enabledMaps": [
                "iliosLighthouse"
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
            "enabled": false
        },
        "control": {
            "enabled": false
        },
        "controlBalancedOverwatch": {
            "enabled": false
        },
        "elimination": {
            "enabled": false
        },
        "escort": {
            "enabled": false
        },
        "escortBalancedOverwatch": {
            "enabled": false
        },
        "flashpoint": {
            "enabled": false
        },
        "hybridBalancedOverwatch": {
            "enabled": false
        },
        "hybrid": {
            "enabled": false
        },
        "practiceRange": {
            "enabled": false
        },
        "pushBalancedOverwatch": {
            "enabled": false
        },
        "push": {
            "enabledMaps": [
                "colosseo"
            ],
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "skirmish": {
            "enabled": false
        },
        "tdm": {
            "enabledMaps": [
                "malevento",
                "necropolis",
                "blackForest"
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
        "Zombie Size": 1,
        "Number of Objectives": 3
    }
}
