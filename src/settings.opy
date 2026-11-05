#!mainFile "../main.opy"

settings {
    "main": {
        "description": "[Original Creator: Mazattack#1183]\r\n[Original Game Code: MPJFR]\r\n[Modified by: Kamenrider#11346]\r\nworkshop.codes/786TW\r\n\r\nFight against an endless horde of zombies while completing various objectives. \r\nUse power-ups found in supply drops while you fight off the horde. \r\nGet to the extraction point and watch the map get nuked. Don't leave anyone behind! \r\n\r\nCommunity ZSM Discord: https://discord.gg/3BhYtNfwMj\r\n\r\nOptimized version 87EJP (d8efbdc) by snky#21990",
        "modeName": "Zombie Survival Missions Modded"
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
        "Boss Size": 2.5,
        "Chance to mutate percentage": 25,
        "Default Enhancement": [
            1
        ],
        "Zombie Size": 1
    }
}
