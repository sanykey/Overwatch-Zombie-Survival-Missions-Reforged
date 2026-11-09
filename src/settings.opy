#!mainFile "../main.opy"

settings {
    "main": {
        "description": "Crouch + Jump + Reload: Normal / Precise / Smooth camera.\r\n\r\nCommunity ZSM Discord: https://discord.gg/3BhYtNfwMj\r\n\r\nCreated by snky#21990",
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
            "captureSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ctf": {
            "disabledMaps": [
                "busanSanctuaryLny",
                "lijiangControlCenterLny",
                "lijiangGardenLny",
                "oasisCityCenter",
                "oasisGardens",
                "oasisUniversity"
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
            "captureSpeed%": 10,
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
            "disabledMaps": [
                "watchpointGibraltar"
            ],
            "payloadSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escortBalancedOverwatch": {
            "enabled": false
        },
        "flashpoint": {
            "captureSpeed%": 10,
            "scoreToWin": 10,
            "scoringSpeed%": 10,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybridBalancedOverwatch": {
            "enabled": false
        },
        "hybrid": {
            "disabledMaps": [
                "eichenwalde",
                "kingsRow",
                "paraiso"
            ],
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
            "tankPassiveHealthBonus": "alwaysEnabled",
            "ts1PushSpeedModifier%": 10,
            "ts1WalkSpeedModifier%": 10
        },
        "skirmish": {
            "enabled": false
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
