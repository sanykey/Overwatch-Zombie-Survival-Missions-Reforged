settings {
    "main": {
        "description": "New Abilities by Jazzy v1.0.1 #WMYB0\n6-player FFA with 29 reworked heroes!",
        "modeName": "New Abilities"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "ffaSlots": 6
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "blackForest",
                "chateauGuillard",
                "kanezaka",
                "malevento"
            ]
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "respawnTime%": 100,
            "scoreToWin": 100
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability2Cooldown%": 57,
                "ability1Cooldown%": 43
            },
            "ashe": {
                "ability2Cooldown%": 83
            },
            "brigitte": {
                "ability2Cooldown%": 80,
                "shieldBashCooldown%": 80
            },
            "doomfist": {
                "secondaryFireCooldown%": 125
            },
            "genji": {
                "ultDuration%": 167
            },
            "kiriko": {
                "ability2Cooldown%": 71,
                "ability1Cooldown%": 171
            },
            "lifeweaver": {
                "secondaryFireCooldown%": 67,
                "ability1Cooldown%": 60,
                "ability1Health%": 60,
                "weaponsEnabled": "thornVolley"
            },
            "lucio": {
                "passiveHealthRegen": true
            },
            "moira": {
                "primaryFireMaximumTime%": 500,
                "ability1Cooldown%": 133
            },
            "orisa": {
                "ability1Cooldown%": 6
            },
            "reaper": {
                "ability1Cooldown%": 13
            },
            "roadhog": {
                "Take a Breather Maximum Time": "150%"
            },
            "sigma": {
                "ability2Cooldown%": 140,
                "health%": 36,
                "ability1Cooldown%": 83
            },
            "sojourn": {
                "ability2Cooldown%": 40
            },
            "symmetra": {
                "ultGen%": 120
            },
            "vendetta": {
                "combatUltGen%": 0,
                "passiveUltGen%": 0,
                "ultGen%": 10
            },
            "winston": {
                "ability1Cooldown%": 140
            },
            "wreckingBall": {
                "enableInfiniteAmmo": true
            },
            "disabledHeroes": [
                "anran",
                "baptiste",
                "dmon",
                "doctrine",
                "domina",
                "emre",
                "freja",
                "hanzo",
                "jetpackCat",
                "junkerQueen",
                "junkrat",
                "mauga",
                "mei",
                "mercy",
                "mizuki",
                "pharah",
                "ramattra",
                "reinhardt",
                "shion",
                "sierra",
                "sombra",
                "torbjorn",
                "tracer",
                "widowmaker",
                "wuyang"
            ],
            "general": {
                "enableSpawningWithUlt": false,
                "ultGen%": 200
            }
        }
    }
}

#Global variables

globalvar i 0
globalvar j 1
globalvar heroes 2
globalvar heroTips 4
globalvar mapData 5
globalvar cassShop 6
globalvar flashCam 7
globalvar toxinCam 8
globalvar soldierMenu 9
globalvar porkChops 10
globalvar __holygrail___ 127

#Player variables

playervar i 0
playervar j 1
playervar init 2
playervar heroSwitch 3
playervar heroInfo 4
playervar ui 5
playervar showUi 6
playervar showHud 7
playervar isConsole 8
playervar effects 9
playervar iwtProgressBars 10
playervar inWorldTexts 11
playervar icons 12
playervar moveSpeed 13
playervar hitPoints 14
playervar damageMods 15
playervar healingMods 16
playervar damageFixer 17
playervar canGlide 18
playervar flight 19
playervar flightKnockback 20
playervar asheBurn 21
playervar ballBurn 22
playervar thirdPersonCam 23
playervar blindedFlashTimer 24
playervar blindedToxinTimer 25
playervar ability1Array 26
playervar ability1Chase 27
playervar ability1Target 28
playervar ability2Chase 29
playervar ability2Array 30
playervar ability3Chase 31
playervar hasTargetAbility 32
playervar untargetablePlayers 33
playervar targetAbility 34
playervar ultArray 35
playervar isUlting 36
playervar ultChase1 37
playervar ultTarget 38
playervar ultEffects 39
playervar scale 40
playervar dummyBot 41
playervar owner 42
playervar mimicOwner 43
playervar creditOwner 44
playervar hazardMarked 45
playervar isRidingOrisa 46
playervar fallDamage 47
playervar isChained 48
playervar inCassShop 49
playervar cassShopToSelect 50
playervar cassShopCanSelect 51
playervar inSoldierMenu 52
playervar soldierMenuCanSelect 53
playervar soldierMenuToSelect 54

#Subroutine names

subroutine AddCustomHP 0
subroutine RemoveCustomHP 1
subroutine DisableAbilities 2
subroutine EnableAbilties 3
subroutine ResetStats 4
subroutine DestroyFX 5
subroutine ResetHero 6
subroutine CreateMimic 7
subroutine EnterCassShop 8
subroutine SoldierMenuCompleteSelection 9
subroutine SoldierMenuStartSelection 10
subroutine Spark 11

#Activated extensions

#!extension kineticExplosionEffects
#!extension energyExplosionEffects
#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension explosionSounds
#!extension beamEffects
#!extension projectiles
#!extension beamSounds
#!extension playMoreEffects
#!extension spawnMoreDummyBots


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "<fg00FFFFFF>OverPy <\ztx> / <\zfg> setup code</fg>":
    #By Zezombye
    createDummy(getAllHeroes(), Team.1 if getNumberOfSlots(Team.1) else Team.2 if getNumberOfSlots(Team.2) else true, false, null, null)
    #More info: https://workshop.codes/wiki/articles/tx-reference-sheet
    getLastCreatedEntity().startForcingName("______________________________________________________________________________________________________________________________〼")
    __holygrail___ = getLastCreatedEntity()[0].split([])
    getLastCreatedEntity().startForcingName("______________________________________________________________________________________________________________________________ࡀ")
    __holygrail___ = "______________________________________________________________________________________________________________________________〼".replace(__holygrail___, getLastCreatedEntity()[0]).substring(126, true)
    destroyAllDummies()


rule "Check if player is using controller or keyboard":
    @Event playerJoined
    
    #Based on Client -> Server data transfer PoC by Zezombye
    waitUntil(eventPlayer.hasSpawned(), 999999995904)
    eventPlayer.isConsole = ceil(eventPlayer.getHorizontalFacingAngle())
    eventPlayer.startFacing(directionFromAngles(eventPlayer.isConsole + true, 0) if [Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.INTERACT, Button.JUMP, Button.MELEE, Button.PRIMARY_FIRE, Button.RELOAD, Button.SECONDARY_FIRE, Button.ULTIMATE].any(lambda x: inputBindingString(x)[0] and strContains("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&~\"#'{([-|`_\\^@)]=}^$%*,?.;/:>²ÉÈÇÀÙ+¤^ßÜÖÄÑ¡´¿ÒÌСЛП↓←→↑스아좌왼숫우오위空回退大下左暂右上；，向數", inputBindingString(x).charAt(0))) else directionFromAngles(eventPlayer.isConsole - true, 0), 999999)
    #Because of precision errors, we round to the hundredth.
    waitUntil(round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 in [eventPlayer.isConsole + true, eventPlayer.isConsole - true], 3)
    if round(eventPlayer.getHorizontalFacingAngle() * 100) / 100 == eventPlayer.isConsole + true:
        eventPlayer.isConsole = false
    else:
        eventPlayer.isConsole = true
    eventPlayer.stopFacing()


rule "Initialize Player Variables and Effects":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.moveSpeed[false] = 100
    eventPlayer.ui = []
    eventPlayer.showUi = true
    eventPlayer.effects = []
    eventPlayer.iwtProgressBars = []
    eventPlayer.inWorldTexts = []
    eventPlayer.icons = []
    eventPlayer.damageMods = []
    eventPlayer.healingMods = []
    eventPlayer.showHud = true
    eventPlayer.hasTargetAbility = false
    #enabled, inputs, fall speed, hor. movement buff
    eventPlayer.canGlide = [false, [], null, null]
    #enabled, move speed
    eventPlayer.flight = [false, 5.5]
    eventPlayer.blindedFlashTimer = null
    eventPlayer.blindedToxinTimer = null
    chaseAtRate(eventPlayer.blindedFlashTimer, false, true)
    chaseAtRate(eventPlayer.blindedToxinTimer, false, true)
    eventPlayer.hazardMarked = [null, null]
    createEffect(getAllPlayers() if eventPlayer.hazardMarked[0] > getTotalTimeElapsed() else null, Effect.ZENYATTA_ORB_OF_DISCORD_TARGET, Color.TEAM_1, eventPlayer, true)
    eventPlayer.fallDamage = null
    eventPlayer.thirdPersonCam = false
    createInWorldText(eventPlayer if eventPlayer.isAlive() and eventPlayer.hasTargetAbility[0] and entityExists(eventPlayer.targetAbility) else null, "\u3164  ︿\n〈\u3164\u3164〉\n\u3164  ﹀", updateEveryFrame(eventPlayer.targetAbility.getPosition() + 3 * Vector.UP / max(3, distance(eventPlayer, eventPlayer.targetAbility))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA)


rule "Initialize Global Variables and Effects":
    if true:
        disableInspector()
    heroes = [Hero.DVA, Hero.DOOMFIST, Hero.HAZARD, Hero.ORISA, Hero.ROADHOG, Hero.SIGMA, Hero.WINSTON, Hero.WRECKING_BALL, Hero.ZARYA, Hero.ASHE, Hero.BASTION, Hero.CASSIDY, Hero.ECHO, Hero.GENJI, Hero.REAPER, Hero.SOJOURN, Hero.SOLDIER, Hero.SYMMETRA, Hero.VENDETTA, Hero.VENTURE, Hero.ANA, Hero.BRIGITTE, Hero.ILLARI, Hero.JUNO, Hero.KIRIKO, Hero.LIFEWEAVER, Hero.LUCIO, Hero.MOIRA, Hero.ZENYATTA]
    #"You gain a double jump each time you wall ride."
    #],
    #[
    #"Cycle your melee cooldowns to maximize your output.",
    #"Earth and water are defensive elements, while fire is offensive.",
    #"Ambiental power changes your base speed in air and earth."
    #]
    #]
    porkChops = [[null, null, null, null, null, null], [null, null, null, null, null, null], [null, null, null, null, null, null]]
    flashCam[false] = vect(false, -100, 100)
    flashCam[true] = vect(false, -100.6, 100)
    toxinCam[false] = vect(false, -100, 150)
    createEffect(getAllPlayers(), Effect.ORB, Color.WHITE, flashCam[true], 20)
    createEffect(getAllPlayers(), Effect.ORB, Color.ORANGE, flashCam[true], 19)
    toxinCam[true] = vect(false, -110, 150)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.VIOLET, toxinCam[true], 20)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.SKY_BLUE, toxinCam[true], 20)
    mapData = [[Map.MALEVENTO, Map.EICHENWALDE, Map.CHATEAU_GUILLARD, Map.KANEZAKA, Map.BLACK_FOREST, Map.ILIOS_WELL, Map.HOLLYWOOD, Map.WORKSHOP_CHAMBER], "\u0010\u0003\u0013\u0003\u0009\u00030\u008a\u0003\u001b\u0002\u0009\u00030\u0009\u0005\u0097\u0003\u0009\u00030\u008e\u0002\u009c\u0002\u0009\u00030\u000e\u0003\u000e\u0003\u0015\u00030\u0001\u0001\u0099\u0002\u0009\u00030\u0011\u0003_\u0002\u0009\u00030\u0009\u0003\u0009\u0003]\u0002".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(x.last().strIndex(x[0].charAt(0)) + 100 * x.last().strIndex(x[0].charAt(1)), x.last().strIndex(x[0].charAt(4)) + 100 * x.last().strIndex(x[0].charAt(5)), x.last().strIndex(x[0].charAt(2)) + 100 * x.last().strIndex(x[0].charAt(3))) - vect(208, 208, 208)), "\rQ\u0003!\u0005\u0003\r!\u00030\u0081`\u0003\u001e:\u0002\r'\u00030>\u000c\u0005\r!\u0004\r(\u000302¡\u0002}\u0015\u0003\u0080%\u00030\u008c#\u0003\u0009$\u0003)+\u00030\u0001\u0001\u0001]\u0017\u0003\r \u00030\u0001&\u0003\u0016\u009f\u0002\u0094 \u00030\r\u001f\u0003\r\u001f\u0003\r\u001f\u0003".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(0.01 * x.last().strIndex(x[0].charAt(0)) + x.last().strIndex(x[0].charAt(1)) + 100 * x.last().strIndex(x[0].charAt(2)), 0.01 * x.last().strIndex(x[0].charAt(6)) + x.last().strIndex(x[0].charAt(7)) + 100 * x.last().strIndex(x[0].charAt(8)), 0.01 * x.last().strIndex(x[0].charAt(3)) + x.last().strIndex(x[0].charAt(4)) + 100 * x.last().strIndex(x[0].charAt(5))) - vect(230.12, 230.12, 230.12)), "\u0015\u0003\u0003\u0001\u0017\u0004\u000b\u009d\u00020\u008b\u009b\u0002\u0092\u001b\u0003\u0092\u000e\u00030\u0001;\u0005\u0001)\u0004\u0001\u0010\u00030\u0087\u008c\u0002\u0083~\u0003\u008d\u001a\u00030\u0083\u0089\u0002\u00012\u0004\u001f\u0010\u00030\u0001\u0001\u0001\u0001\u0005\u0002\u001f\u0093\u00020\u0001\u0097\u0002:\u0007\u0004\u0011\u000f\u00030\u0001\u000b\u0003\u0001\u000b\u0003\u0001\u000b\u0004".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(0.01 * x.last().strIndex(x[0].charAt(0)) + x.last().strIndex(x[0].charAt(1)) + 100 * x.last().strIndex(x[0].charAt(2)), 0.01 * x.last().strIndex(x[0].charAt(6)) + x.last().strIndex(x[0].charAt(7)) + 100 * x.last().strIndex(x[0].charAt(8)), 0.01 * x.last().strIndex(x[0].charAt(3)) + x.last().strIndex(x[0].charAt(4)) + 100 * x.last().strIndex(x[0].charAt(5))) - vect(210, 210, 210))]
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, mapData[2][mapData[0].index(__getCurrentMap__())], 2.15)
    createInWorldText(null if localPlayer.inCassShop or localPlayer.inSoldierMenu else localPlayer, "Upgrade Shop (Cassidy Only)", mapData[2][mapData[0].index(__getCurrentMap__())] + 1.5 * Vector.UP, 1.5, Clip.SURFACES)
    hudSubtext(localPlayer if localPlayer.init[true] and not localPlayer.inCassShop and not localPlayer.inSoldierMenu else null, "{0}Crouch + Interact to {1} Hero Info\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003{2}".format("{0} {1}:\n-------------------------------\n{2}".format(heroIcon(localPlayer.getHero()), localPlayer.getHero(), "{0} {1}\n{2}".format(localPlayer.heroInfo[0][0], localPlayer.heroInfo[true][0], "{0}\n-------------------------------\n{1} {2}".format(localPlayer.heroInfo[2][0], localPlayer.heroInfo[0][true], "{0}\n{1}\n-------------------------------\n{2}".format(localPlayer.heroInfo[true][true], localPlayer.heroInfo[2][true], "{0} {1}\n{2}\n-------------------------------\n".format(localPlayer.heroInfo[0][2], localPlayer.heroInfo[true][2], localPlayer.heroInfo[2][2]))))) if localPlayer.showHud else "", "Hide" if localPlayer.showHud else "Show", "\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003"), HudPosition.LEFT, false)
    hudSubtext(localPlayer if localPlayer.init[true] and not localPlayer.inCassShop and not localPlayer.inSoldierMenu and localPlayer.showHud else null, "New Abilities By Jazzy #WMYB0\n", HudPosition.RIGHT, false)
    createInWorldText(localPlayer if localPlayer.isAlive() and localPlayer.showUi and not localPlayer.thirdPersonCam else null, "Move speed: {0}".format(max(false, localPlayer.moveSpeed[0])), updateEveryFrame(localPlayer.getEyePosition() + (100 * ((((-3.18 / (1.241 if localPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION)) + ((-1.13 / (1.241 if localPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90)))) + 3 * localPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE if localPlayer.moveSpeed[0] == 100 else Color.LIME_GREEN if localPlayer.moveSpeed[0] > 100 else Color.RED)
    createInWorldText(localPlayer if localPlayer.isAlive() and localPlayer.showUi and not localPlayer.thirdPersonCam else null, "{0} Fall damage {1}".format(heroIcon(Hero.SIGMA), "Active {0}txC00000000017Ef8>".format(__holygrail___) if isHeroBeingPlayed(Hero.SIGMA, Team.ALL) else "Inactive"), updateEveryFrame(localPlayer.getEyePosition() + (100 * ((((-3.02 / (1.241 if localPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION)) + ((-1.23 / (1.241 if localPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90)))) + 3 * localPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.BLUE if isHeroBeingPlayed(Hero.SIGMA, Team.ALL) else Color.GRAY)
    waitUntil(isGameInProgress(), 999999995904)
    pauseMatchTime()


rule "Show/Hide HUD":
    @Event eachPlayer
    @Condition eventPlayer.init[true] != false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.showHud = not eventPlayer.showHud


rule "Death Messages":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    @Disabled
    
    waitUntil(eventPlayer.isAlive(), 999999995904)
    if eventPlayer.init[0] == eventPlayer.getHero():
        if round(getTotalTimeElapsed()) % 2:
            smallMessage(eventPlayer, "Tip: {0}".format(heroTips[heroes.index(eventPlayer.getHero())][random.randint(false, 2)]))


def AddCustomHP():
    @Name "Subroutine AddCustomHP"
    
    #eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.hitPoints[1], true, true)
    #if eventPlayer.hitPoints[2]:
    #eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.hitPoints[2], true, true)
    #heal(eventPlayer, null, eventPlayer.getMaxHealth())
    eventPlayer.setMaxHealth(0)
    if eventPlayer.hitPoints[0]:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.hitPoints[0] - evalOnce(eventPlayer.getHealth()), true)
    if eventPlayer.hitPoints[true]:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.hitPoints[true], true)
    if eventPlayer.hitPoints[2]:
        eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.hitPoints[2], true)


def RemoveCustomHP():
    @Name "Subroutine RemoveCustomHP"
    
    eventPlayer.removeAllHealthPools()
    wait(false)
    eventPlayer.setMaxHealth(100.001)
    wait(false)
    eventPlayer.setMaxHealth(100)
    eventPlayer.startHealingOverTime(null, 1, 9999)


def DisableAbilities():
    @Name "Subroutine DisableAbilities"
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    eventPlayer.setReloadEnabled(false)


def EnableAbilties():
    @Name "Subroutine EnableAbilities"
    
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setReloadEnabled(true)


def ResetStats():
    @Name "Subroutine ResetStats"
    
    eventPlayer.damageFixer[false] = 1
    eventPlayer.setDamageDealt(100 * eventPlayer.damageFixer[0])
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.moveSpeed[false] = 100
    eventPlayer.setMoveSpeed(eventPlayer.moveSpeed[0])
    eventPlayer.stopScalingSize()
    eventPlayer.canGlide[false] = false
    eventPlayer.flight[false] = false
    stopChasing(eventPlayer.ability1Chase)
    stopChasing(eventPlayer.ability2Chase)
    stopChasing(eventPlayer.ultChase1)
    stopChasing(eventPlayer.scale)
    eventPlayer.ability1Array = []
    eventPlayer.hasTargetAbility[false] = false
    eventPlayer.untargetablePlayers = [null, null, null, null, null, null]
    eventPlayer.isUlting = false


def DestroyFX():
    @Name "DestroyFX"
    
    destroyEffect(eventPlayer.effects)
    eventPlayer.effects = []
    while eventPlayer.inWorldTexts != []:
        destroyInWorldText(eventPlayer.inWorldTexts[0])
        del eventPlayer.inWorldTexts[false]
    while eventPlayer.iwtProgressBars != []:
        destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[0])
        del eventPlayer.iwtProgressBars[false]
    while eventPlayer.icons != []:
        destroyInWorldText(eventPlayer.icons[0])
        del eventPlayer.icons[false]
    while eventPlayer.damageMods != []:
        stopDamageModification(eventPlayer.damageMods[0])
        del eventPlayer.damageMods[false]
    while eventPlayer.healingMods != []:
        stopHealingModification(eventPlayer.healingMods[0])
        del eventPlayer.healingMods[false]


def ResetHero():
    @Name "Subroutine ResetHero"
    
    RemoveCustomHP()
    DisableAbilities()
    EnableAbilties()
    ResetStats()
    DestroyFX()


rule "Assemble Heroes Time":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(5)


rule "Host Restart Game":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    bigMessage(getAllPlayers(), "RESTARTING GAME IN 10s!")
    waitUntil(not (eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.isHoldingButton(Button.ABILITY_1)), 10)
    if eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.isHoldingButton(Button.ABILITY_1):
        restartMatch()
    else:
        bigMessage(getAllPlayers(), "Restart canceled")


rule "Detect Hero Switch":
    @Event eachPlayer
    @Condition eventPlayer.heroSwitch[0] != eventPlayer.getHero()
    
    eventPlayer.heroSwitch[true] = true
    wait(false)
    if eventPlayer.heroSwitch[0] != Hero.VENDETTA:
        eventPlayer.setUltCharge(eventPlayer.heroSwitch[2])
    eventPlayer.heroSwitch[false] = eventPlayer.getHero()
    eventPlayer.heroSwitch[true] = false


rule "Upon Hero Switch":
    @Event eachPlayer
    @Condition eventPlayer.heroSwitch[true] == true
    @Condition eventPlayer.isDummy() == false
    
    waitUntil(eventPlayer.hasSpawned(), 999999995904)
    waitUntil(not eventPlayer.heroSwitch[true], 999999995904)
    ResetHero()
    eventPlayer.init[false] = eventPlayer.getHero()
    eventPlayer.init[true] = true


rule "Detect Ult Charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() != eventPlayer.heroSwitch[2]
    @Condition eventPlayer.heroSwitch[true] == false
    
    wait(false, Wait.ABORT_WHEN_FALSE)
    eventPlayer.heroSwitch[2] = eventPlayer.getUltCharge()
    wait(false)
    if ruleCondition:
        loop()


rule "Update Move Speed":
    @Event eachPlayer
    @Condition eventPlayer.moveSpeed[0] != eventPlayer.moveSpeed[true]
    
    eventPlayer.setMoveSpeed(eventPlayer.moveSpeed[0])
    eventPlayer.moveSpeed[true] = eventPlayer.moveSpeed[0]
    wait(false)
    if ruleCondition:
        loop()


rule "Prevent Ult Charge While Ulting":
    @Event eachPlayer
    @Condition eventPlayer.isUlting != false
    @Condition eventPlayer.getUltCharge() != false
    
    eventPlayer.setUltCharge(false)
    wait(false)
    if ruleCondition:
        loop()


rule "Glide Module":
    @Event eachPlayer
    @Condition eventPlayer.canGlide[0] != false
    @Condition eventPlayer.canGlide[true].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    @Condition eventPlayer.getVelocity().y < -0.15
    @Condition eventPlayer.getAltitude() > 0.1
    @Condition eventPlayer.flight[0] == false
    @Condition ([eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isChained) == false
    
    eventPlayer.setGravity(false)
    eventPlayer.moveSpeed[false] += eventPlayer.canGlide[3]
    eventPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD)
    eventPlayer.canGlide[4] = true
    while eventPlayer.canGlide[0] and eventPlayer.canGlide[true].any(lambda x: eventPlayer.isHoldingButton(x)) and eventPlayer.getVelocity().y < -0.15 and eventPlayer.getAltitude() > 0.1 and not eventPlayer.flight[0] and (not ([eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isChained)):
        eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.canGlide[2], Relativity.TO_WORLD)
        wait(false)
    eventPlayer.setGravity(100)
    eventPlayer.moveSpeed[false] -= eventPlayer.canGlide[3]
    eventPlayer.canGlide[4] = false


rule "Flash Blind":
    @Event eachPlayer
    @Condition eventPlayer.blindedFlashTimer > null
    @Condition eventPlayer.thirdPersonCam == false
    
    bigMessage(eventPlayer, "Flashed!")
    eventPlayer.startCamera(flashCam[0], flashCam[true])
    waitUntil(eventPlayer.blindedFlashTimer == null, 999999995904)
    if not eventPlayer.blindedToxinTimer:
        eventPlayer.stopCamera()


rule "Toxin Blind":
    @Event eachPlayer
    @Condition eventPlayer.blindedToxinTimer > null
    @Condition eventPlayer.thirdPersonCam == false
    
    bigMessage(eventPlayer, "Blinded!")
    eventPlayer.startCamera(toxinCam[0], toxinCam[true])
    waitUntil(eventPlayer.blindedFlashTimer == null, 999999995904)
    if not eventPlayer.blindedFlashTimer:
        eventPlayer.stopCamera()


rule "Set Ability Target":
    @Event eachPlayer
    @Condition eventPlayer.hasTargetAbility[0] != false
    @Condition eventPlayer.targetAbility != ((sorted(getAllPlayers().filter(lambda player: player.isAlive() and player != eventPlayer and eventPlayer.isInViewAngle(player, 35) and eventPlayer.untargetablePlayers[player.getSlot()] <= getTotalTimeElapsed() and not player.isDummy() and player.hasSpawned() and distance(player, eventPlayer) < eventPlayer.hasTargetAbility[true] and isInLoS(player.getEyePosition(), eventPlayer.getEyePosition()) and not player.hasStatus(Status.PHASED_OUT)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x))))[0])
    
    if entityExists((sorted(getAllPlayers().filter(lambda player: player.isAlive() and player != eventPlayer and eventPlayer.isInViewAngle(player, 35) and eventPlayer.untargetablePlayers[player.getSlot()] <= getTotalTimeElapsed() and not player.isDummy() and player.hasSpawned() and distance(player, eventPlayer) < eventPlayer.hasTargetAbility[true] and isInLoS(player.getEyePosition(), eventPlayer.getEyePosition()) and not player.hasStatus(Status.PHASED_OUT)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x))))[0]):
        eventPlayer.targetAbility = (sorted(getAllPlayers().filter(lambda player: player.isAlive() and player != eventPlayer and eventPlayer.isInViewAngle(player, 35) and eventPlayer.untargetablePlayers[player.getSlot()] <= getTotalTimeElapsed() and not player.isDummy() and player.hasSpawned() and distance(player, eventPlayer) < eventPlayer.hasTargetAbility[true] and isInLoS(player.getEyePosition(), eventPlayer.getEyePosition()) and not player.hasStatus(Status.PHASED_OUT)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x))))[0]
    else:
        eventPlayer.targetAbility = null
    wait(false)
    if ruleCondition:
        loop()


rule "Flight Mechanic":
    @Event eachPlayer
    @Condition eventPlayer.flight[0] != false
    @Condition eventPlayer.isChained == false
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setGravity(false)
    eventPlayer.setMoveSpeed(false)
    while eventPlayer.flight[0] and eventPlayer.isAlive() and not eventPlayer.isChained:
        if ((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT)) != Vector.LEFT + Vector.RIGHT:
            if eventPlayer.flightKnockback < 0.4:
                eventPlayer.applyImpulse(eventPlayer.getVelocity() - ((dotProduct(eventPlayer.getVelocity(), normalize((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT)))) * (normalize((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT)))), (magnitude(eventPlayer.getVelocity() - ((dotProduct(eventPlayer.getVelocity(), normalize((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT)))) * (normalize((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT)))))) * -0.4, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.applyImpulse((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT), max((min(((5.5 if eventPlayer.flight[true] == null else eventPlayer.flight[true]) * 1.2) - (eventPlayer.getSpeedInDirection((eventPlayer.getThrottle().x * -1 * normalize(crossProduct(eventPlayer.getFacingDirection(), Vector.UP)) + eventPlayer.getThrottle().z * eventPlayer.getFacingDirection() + (Vector.UP if eventPlayer.isHoldingButton(Button.JUMP) else Vector.LEFT + Vector.RIGHT)) + (Vector.DOWN if eventPlayer.isHoldingButton(Button.CROUCH) else Vector.LEFT + Vector.RIGHT))), (5.5 if eventPlayer.flight[true] == null else eventPlayer.flight[true]) * 2.4)) * (0.18 if eventPlayer.flightKnockback < 0.4 else 0.08), false), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            if not eventPlayer.flightKnockback:
                #Come to a halt relatively slowly
                eventPlayer.applyImpulse(eventPlayer.getVelocity(), (min(eventPlayer.getSpeed() * 0.035 + 0.06, eventPlayer.getSpeed())) * -1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(false)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    wait(false)


rule "Flight Knockback Interruption":
    @Event playerReceivedKnockback
    
    eventPlayer.flightKnockback = 0.7
    chaseAtRate(eventPlayer.flightKnockback, false, true, ChaseRateReeval.NONE)


rule "Dummy Init and Destroy":
    @Event eachPlayer
    @Condition entityExists(eventPlayer.owner) == true
    
    startDamageModification(eventPlayer.owner, eventPlayer, 0)
    eventPlayer.damageMods[true] = getLastDamageModification()
    startDamageModification(getAllPlayers(), eventPlayer if eventPlayer.creditOwner else null, 1)
    eventPlayer.damageMods[false] = getLastDamageModification()
    startHealingModification(getAllPlayers(), eventPlayer if eventPlayer.creditOwner else null, 1)
    eventPlayer.healingMods[false] = getLastHealingModification()
    waitUntil(not entityExists(eventPlayer.owner), 999999995904)
    stopDamageModification(eventPlayer.damageMods[0])
    stopDamageModification(eventPlayer.damageMods[true])
    stopHealingModification(eventPlayer.healingMods[0])
    destroyDummy(Team.ALL, eventPlayer.getSlot())


rule "Credit Owner for Damage":
    @Event playerDealtDamage
    @Condition eventPlayer.creditOwner != false
    
    heal(victim, null, eventDamage)
    damage(victim, eventPlayer.owner, eventDamage * 100)


rule "Credit Owner for Heal":
    @Event playerDealtHealing
    @Condition eventPlayer.creditOwner != false
    
    damage(healee, null, eventHealing)
    heal(healee, eventPlayer.owner, eventHealing * 100)


def CreateMimic():
    @Name "Subroutine CreateMimic"
    
    createDummy(eventPlayer.getHero(), Team.ALL, eventPlayer.getSlot() + 6, eventPlayer.getPosition(), null)
    eventPlayer.dummyBot = getLastCreatedEntity()
    eventPlayer.dummyBot.owner = eventPlayer
    eventPlayer.dummyBot.mimicOwner = true
    wait(0.25)
    eventPlayer.dummyBot.startFacing(updateEveryFrame(directionTowards(eventPlayer.dummyBot.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 70, getAllPlayers(), [eventPlayer, eventPlayer.dummyBot], true))), 999999995904)


rule "Mimic Mirror Movement":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    
    eventPlayer.startThrottleInDirection(eventPlayer.owner.getThrottle(), magnitude(eventPlayer.owner.getThrottle()), Relativity.TO_PLAYER)


rule "Mimic Mirror Ability 1":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.ABILITY_1)), 999999995904)
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "Mimic Mirror Ability 2":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.ABILITY_2) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.ABILITY_2)), 999999995904)
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "Mimic Mirror Primary Fire":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.PRIMARY_FIRE)), 999999995904)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "Mimic Mirror Secondary Fire":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.SECONDARY_FIRE)), 999999995904)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "Mimic Mirror Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.ULTIMATE) == true
    
    eventPlayer.startForcingButton(Button.ULTIMATE)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.ULTIMATE)), 999999995904)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


rule "Mimic Mirror Jump":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.JUMP)), 999999995904)
    eventPlayer.stopForcingButton(Button.JUMP)


rule "Mimic Mirror Crouch":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.startForcingButton(Button.CROUCH)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.CROUCH)), 999999995904)
    eventPlayer.stopForcingButton(Button.CROUCH)


rule "Mimic Mirror Melee":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.startForcingButton(Button.MELEE)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.MELEE)), 999999995904)
    eventPlayer.stopForcingButton(Button.MELEE)


rule "Mimic Mirror Reload":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.RELOAD) == true
    
    eventPlayer.startForcingButton(Button.RELOAD)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.RELOAD)), 999999995904)
    eventPlayer.stopForcingButton(Button.RELOAD)


rule "Mimic Mirror Interact":
    @Event eachPlayer
    @Condition eventPlayer.mimicOwner != false
    @Condition eventPlayer.owner.isHoldingButton(Button.INTERACT) == true
    
    eventPlayer.startForcingButton(Button.INTERACT)
    waitUntil(not (eventPlayer.mimicOwner and eventPlayer.owner.isHoldingButton(Button.INTERACT)), 999999995904)
    eventPlayer.stopForcingButton(Button.INTERACT)


rule "--- DOOMFIST ---":
    @Delimiter
    


rule "Doomfist Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.DOOMFIST
    
    #stones obtained
    eventPlayer.ability1Array[false] = [false, false, false, false, false]
    #color for each stone
    eventPlayer.ability1Array[true] = [rgb(240, 66, 70), rgb(255, 204, 57), rgb(138, 199, 64), rgb(25, 130, 197), rgb(107, 77, 149), Color.RED, Color.ORANGE, Color.LIME_GREEN, Color.SKY_BLUE, Color.VIOLET, "{0}fgF0424BFF>".format(__holygrail___), "{0}fgFFCC39FF>".format(__holygrail___), "{0}fg8AC740FF>".format(__holygrail___), "{0}fg1982C5FF>".format(__holygrail___), "{0}fg6b4D95FF>".format(__holygrail___)]
    eventPlayer.setMaxHealth(79.733)
    eventPlayer.startScalingSize(1.15)
    eventPlayer.addHealthPool(Health.NORMAL, 51 if eventPlayer.ability1Array[0][0] else 1, true)
    startDamageModification(eventPlayer if eventPlayer.ability1Array[0].all() else null, getAllPlayers(), 80)
    eventPlayer.damageMods.append(getLastDamageModification())
    startDamageModification(getAllPlayers(), eventPlayer if eventPlayer.ability1Array[0].all() else null, 120)
    eventPlayer.damageMods.append(getLastDamageModification())
    createEffect(getAllPlayers() if eventPlayer.ability1Array[0].all() else null, Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createInWorldText(eventPlayer if eventPlayer.isUsingAbility1() or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 5.7 else null, "{0}: {1}{2}".format(abilityIconString(Hero.DOOMFIST, Button.ABILITY_1), ceil(eventPlayer.scale + 40) if eventPlayer.ability1Array[0][3] else eventPlayer.scale, " dmg" if eventPlayer.ability1Array[0][3] else "s"), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, eventPlayer.ability1Array[true][3])
    for i in range(0, 5, true):
        createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "■" if eventPlayer.ability1Array[0][evalOnce(i)] else "□", updateEveryFrame(eventPlayer.getEyePosition() + (100 * (((((-0.3 + 0.15 * evalOnce(i)) / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.7 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE if eventPlayer.ability1Array[0].all() else eventPlayer.ability1Array[true][evalOnce(i)])
        eventPlayer.inWorldTexts.append(getLastCreatedText())
        createEffect(getAllPlayers() if eventPlayer.ability1Array[0][evalOnce(i)] and not eventPlayer.isUsingUltimate() else null, Effect.GOOD_AURA, Color.WHITE if eventPlayer.ability1Array[0].all() else eventPlayer.ability1Array[true][5 + evalOnce(i)], updateEveryFrame(eventPlayer.getEyePosition() + (vect(2 * (cosDeg(125 * getTotalTimeElapsed() + 72 * evalOnce(i))), 0.8 * (sinDeg(125 * getTotalTimeElapsed() + 360 - 72 * evalOnce(i))) + 0.75, 2 * (sinDeg(125 * getTotalTimeElapsed() + 72 * evalOnce(i)))))), 0.15)
        eventPlayer.effects[i + true] = getLastCreatedEntity()
    eventPlayer.heroInfo = ["Role: The Chosen One\nOnly one player can be doomfist at any time; it's you.\n-------------------------------\nPassive: Power Ge{0}".format("ms0Power Gems: Obtention0Power Gems: Effects").split(null[0]), ["{0}txC00000000028FCD>".format(__holygrail___), "{0}txC0000000000F4C2>".format(__holygrail___), "{0}txC00000000032723>".format(__holygrail___)], "Collect precious gems that increase your power.\nBecome all-powerful* when possessing all 5.(1.00, 0.00, 0.00)- Red & Purple: {0}".format("Located at random places on the map\n- Yellow: Block 350 damage without dying\n- Green: Steal it from its carrier by meleeing t{0}".format("hem\n- Blue: Land a seismic slam with over 1.35s of airtime(1.00, 0.00, 0.00)- Red: increase max HP and constantly heal\n- Yell{0}".format("ow: Gain armor after blocking\n- Green: move faster and increase cooldown rate\n- Blue: Slam goes farther and deals more damage{0}".format("\n- Purple: Gain omnidirectional punch\n\n*All Powerful: deal 20% more damage and take 20% less damage")))).split(Vector.LEFT[0])]


rule "There Can Only Be One":
    @Event eachPlayer
    @Condition isHeroBeingPlayed(Hero.DOOMFIST, Team.ALL) == true
    @Condition eventPlayer.getHero() != Hero.DOOMFIST
    
    eventPlayer.setAllowedHeroes(heroes.exclude(Hero.DOOMFIST))
    waitUntil(not isHeroBeingPlayed(Hero.DOOMFIST, Team.ALL), 999999995904)
    eventPlayer.setAllowedHeroes(heroes.concat(Hero.DOOMFIST))


rule "Upon Spawn":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHero() == Hero.DOOMFIST
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    destroyEffect(eventPlayer.effects[6])
    destroyEffect(eventPlayer.effects[7])
    eventPlayer.ability1Array[2] = (random.choice(getSpawnPoints(Team.ALL).filter(lambda x: distance(x, eventPlayer) > 20))).getPosition()
    eventPlayer.ability1Array[3] = (random.choice(getSpawnPoints(Team.ALL).filter(lambda x: distance(x, eventPlayer) > 20 and distance(x, eventPlayer.ability1Array[2]) > 20))).getPosition()
    createEffect(eventPlayer, Effect.GOOD_AURA, Color.RED, eventPlayer.ability1Array[2] + (Vector.UP * (0.7 + (0.2 * (sinDeg(evalOnce(random.randint(false, 360)) + 180 * getTotalTimeElapsed()))))), 0.5)
    eventPlayer.effects[6] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.GOOD_AURA, Color.VIOLET, eventPlayer.ability1Array[3] + (Vector.UP * (0.7 + (0.2 * (sinDeg(evalOnce(random.randint(false, 360)) + 180 * getTotalTimeElapsed()))))), 0.5)
    eventPlayer.effects[7] = getLastCreatedEntity()
    eventPlayer.ability1Array[4] = null
    eventPlayer.moveSpeed[false] -= 15 * eventPlayer.ability1Array[0][2]
    eventPlayer.ability1Array[5] = null
    eventPlayer.ability1Array[6] = null
    stopHealingOverTime(eventPlayer.ability1Array[7])
    removeHealthPool(eventPlayer.ability1Array[8])
    destroyIcon(eventPlayer.icons[0])
    destroyEffect(eventPlayer.ability1Array[9])
    eventPlayer.ability1Array[false] = [false, false, false, false, false]


rule "Health/Force Stone - Collect Ground Stones":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.hasSpawned() == true
    @Condition [eventPlayer.ability1Array[2], eventPlayer.ability1Array[3]].any(lambda x: distance(x, eventPlayer) <= 1.2) == true
    @Condition [eventPlayer.ability1Array[2], eventPlayer.ability1Array[3]].all(lambda x: x != null) == true
    
    if distance(eventPlayer, eventPlayer.ability1Array[2]) <= 1.2 and not eventPlayer.ability1Array[0][0]:
        eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, false).concat([true]).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        destroyEffect(eventPlayer.effects[6])
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer.ability1Array[2], 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
        wait(false)
        heal(eventPlayer, eventPlayer, 500)
        bigMessage(getAllPlayers(), "{0}: {1} got the {2}".format(heroIcon(Hero.DOOMFIST), eventPlayer, "{0}Health{1}/fg> stone!".format(eventPlayer.ability1Array[true][10], __holygrail___)))
    elif distance(eventPlayer, eventPlayer.ability1Array[3]) <= 1.2 and not eventPlayer.ability1Array[0][4]:
        eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, 4).concat([true]).concat(eventPlayer.ability1Array[0].slice(4 + true, 999999995904))
        destroyEffect(eventPlayer.effects[7])
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.VIOLET, eventPlayer.ability1Array[3], 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
        wait(false)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, false)
        bigMessage(getAllPlayers(), "{0}: {1} got the {2}".format(heroIcon(Hero.DOOMFIST), eventPlayer, "{0}Force{1}/fg> stone!".format(eventPlayer.ability1Array[true][14], __holygrail___)))


rule "Health Stone - Heal":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.ability1Array[0][0] != false
    
    eventPlayer.startHealingOverTime(eventPlayer, 999999995904, 15)
    eventPlayer.ability1Array[7] = getLastHealingOverTimeId()
    waitUntil(eventPlayer.isDead() or not eventPlayer.ability1Array[0][0], 999999995904)
    stopHealingOverTime(eventPlayer.ability1Array[7])


rule "Defense Stone - Track Damage":
    @Event playerTookDamage
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.ability1Array[0][true] == false
    @Condition eventPlayer.isInViewAngle(attacker, 50) == true
    
    eventPlayer.ability1Array[5] += eventDamage * 4
    if eventPlayer.ability1Array[5] >= 350:
        eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, true).concat([true]).concat(eventPlayer.ability1Array[0].slice(true + true, 999999995904))
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getPosition(), 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
        wait(false)
        bigMessage(getAllPlayers(), "{0}: {1} got the {2}".format(heroIcon(Hero.DOOMFIST), eventPlayer, "{0}Defense{1}/fg> stone!".format(eventPlayer.ability1Array[true][11], __holygrail___)))


rule "Defense Stone - Grant Armor":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.ability1Array[0][true] != false
    
    eventPlayer.moveSpeed[false] += 50
    waitUntil(not eventPlayer.isUsingAbility2(), 2.5)
    eventPlayer.moveSpeed[false] -= 50
    eventPlayer.addHealthPool(Health.ARMOR, 75, true)
    eventPlayer.ability1Array[8] = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.getAbilityCooldown(Button.ABILITY_2), 5)
    removeHealthPool(eventPlayer.ability1Array[8])


rule "Time Stone - Set Owner":
    @Event eachPlayer
    @Hero doomfist
    @Condition (not entityExists(eventPlayer.ability1Array[4]) or eventPlayer.ability1Array[4].isDead()) == true
    @Condition (len(getAllPlayers().filter(lambda player: player.hasSpawned() and player.isAlive() and not player.isDummy() and player != eventPlayer))) != false
    @Condition eventPlayer.ability1Array[0][2] == false
    
    eventPlayer.ability1Array[4] = random.choice(getAllPlayers().filter(lambda player: player.hasSpawned() and player.isAlive() and not player.isDummy() and player != eventPlayer))
    createIcon(eventPlayer if entityExists(eventPlayer.ability1Array[4]) else null, updateEveryFrame(eventPlayer.ability1Array[4].getEyePosition() + worldVector(vect(false, -0.2, 0.2), eventPlayer.ability1Array[4], Transform.ROTATION)), Icon.DIAMOND, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.LIME_GREEN)
    eventPlayer.icons[false] = getLastCreatedEntity()
    createEffect(eventPlayer if entityExists(eventPlayer.ability1Array[4]) else null, Effect.GOOD_AURA, Color.LIME_GREEN, updateEveryFrame(eventPlayer.ability1Array[4].getEyePosition() + worldVector(vect(false, 0.4, 0.2), eventPlayer.ability1Array[4], Transform.ROTATION)), 0.1)
    eventPlayer.ability1Array[9] = getLastCreatedEntity()
    wait(0.5)
    if ruleCondition:
        loop()
    smallMessage(eventPlayer, "{0} has the {1}time{2}/fg> stone. Melee them to steal it!".format(eventPlayer.ability1Array[4], eventPlayer.ability1Array[true][12], __holygrail___))


rule "Time Stone - Steal":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.MELEE
    @Condition victim == eventPlayer.ability1Array[4]
    
    damage(victim, eventPlayer, 60)
    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1.5)
    setSlowMotion(50)
    eventPlayer.moveSpeed[false] += 15
    eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, 2).concat([true]).concat(eventPlayer.ability1Array[0].slice(2 + true, 999999995904))
    eventPlayer.ability1Array[4] = null
    destroyIcon(eventPlayer.icons[0])
    destroyEffect(eventPlayer.ability1Array[9])
    bigMessage(getAllPlayers(), "{0}: {1} got the {2}".format(heroIcon(Hero.DOOMFIST), eventPlayer, "{0}Time{1}/fg> stone!".format(eventPlayer.ability1Array[true][12], __holygrail___)))
    wait(0.5)
    setSlowMotion(100)


rule "Time Stone - Speed Cooldowns":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.ability1Array[0][2] != false
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 0.1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 0.1)
    wait(0.25)
    if ruleCondition:
        loop()


rule "Blue Stone - Seismic Slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(false)
    if not eventPlayer.ability1Array[0][3]:
        eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, eventPlayer.getSpeed() / 3, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.scale = null
        chaseAtRate(eventPlayer.scale, 1.35, true)
    elif eventPlayer.ability1Array[0][3]:
        eventPlayer.scale = 10
        chaseAtRate(eventPlayer.scale, 135, eventPlayer.scale)
    waitUntil(eventPlayer.isOnGround(), 999999995904)
    stopChasing(eventPlayer.scale)


rule "Blue Stone - Collect/Damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1
    
    if not eventPlayer.ability1Array[0][3]:
        if eventPlayer.scale >= 1.35:
            eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, 3).concat([true]).concat(eventPlayer.ability1Array[0].slice(3 + true, 999999995904))
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
            playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.BLUE, eventPlayer.getPosition(), 1.5)
            playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
            bigMessage(getAllPlayers(), "{0}: {1} got the {2}".format(heroIcon(Hero.DOOMFIST), eventPlayer, "{0}Blue{1}/fg> stone!".format(eventPlayer.ability1Array[true][13], __holygrail___)))
            wait(true)
    elif eventPlayer.ability1Array[0][3]:
        damage(victim, eventPlayer, max(false, eventPlayer.scale - 40))


rule "Force Stone - Omni Punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ability1Array[0][4] != false
    
    eventPlayer.ability1Chase = 6.3
    chaseOverTime(eventPlayer.ability1Chase, 19.7, true, ChaseTimeReeval.NONE)
    waitUntil(not (eventPlayer.isFiringSecondaryFire() and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)), 1.6)
    stopChasing(eventPlayer.ability1Chase)
    eventPlayer.ability1Array[10] = eventPlayer.ability1Chase
    if eventPlayer.isFiringSecondaryFire() and not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.ability1Chase = eventPlayer.getPosition()
        eventPlayer.ability1Array[11] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 19.7, null, eventPlayer, false)
        eventPlayer.startForcingPosition(updateEveryFrame(eventPlayer.ability1Chase))
        chaseAtRate(eventPlayer.ability1Chase, eventPlayer.ability1Array[11], eventPlayer.ability1Array[10] * 2)
        waitUntil(not eventPlayer.isFiringSecondaryFire() or distance(eventPlayer, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.ability1Array[11], null, eventPlayer, false)) < 2, eventPlayer.ability1Array[10] / 39.4)
    eventPlayer.stopForcingPosition()
    stopChasing(eventPlayer.ability1Chase)
    if not eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.8 * eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "All Stones":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.ability1Array[0].all() == true
    
    wait(true, Wait.ABORT_WHEN_FALSE)
    bigMessage(getAllPlayers(), "{0}: {1} has become all-powerful!".format(heroIcon(Hero.DOOMFIST), eventPlayer))


rule "--- D.VA ---":
    @Delimiter
    


rule "DVa Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.DVA
    
    eventPlayer.startScalingSize(1 if eventPlayer.isInAlternateForm() else 0.82)
    eventPlayer.setMaxHealth(46.15)
    eventPlayer.addHealthPool(Health.NORMAL, 94.23 if eventPlayer.isInAlternateForm() else 21.15, true)
    eventPlayer.canGlide = [true, [Button.JUMP, Button.ABILITY_1], 2.5, 30]
    eventPlayer.ability1Chase = eventPlayer.getPosition()
    chaseAtRate(eventPlayer.ability1Chase, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + Vector.DOWN * eventPlayer.getAltitude(), null, eventPlayer, false), 999999995904)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.heroInfo = ["Primary Fire: Focused Fire0Boosters: Passive Activation0Secondary Fire: Supply Drop".split(null[0]), ["{0}txC00000000001315>".format(__holygrail___), "{0}txC00000000004EA2>".format(__holygrail___), "{0}txC000000000039DD>".format(__holygrail___)], "Every third shot fires a volley of explosive pellets.\nThe accuracy of this shot increases with altitude.0Hold Ability 1 or ju{0}".format("mp in air to glide.\nDoing this slows the cooldown rate of boosters.\nGain a double jump as well.0Drop a supply drop that heals{0}".format(" depending on your altitude when you used it.")).split(null[0])]


rule "Dva boom shot":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.ability1Array[true] = min(30 / max(eventPlayer.getAltitude(), 0.5), 10 if eventPlayer.isUsingAbility1() else 30)
    for i in range(0, 11, true):
        eventPlayer.ability1Array[false] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-1 * eventPlayer.ability1Array[true], eventPlayer.ability1Array[true]), eventPlayer.getVerticalFacingAngle() + random.uniform(-1 * eventPlayer.ability1Array[true], eventPlayer.ability1Array[true]))) * 100), getAllPlayers(), eventPlayer, true)
        playEffect(eventPlayer, DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION, Color.TEAM_1, eventPlayer.ability1Array[0], 1)
        playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION, null, eventPlayer.ability1Array[0], 1)
        playEffect(getAllPlayers(), DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION_SOUND, Color.TEAM_1, eventPlayer.ability1Array[0], 80)
        damage(getPlayersInRadius(eventPlayer.ability1Array[0], 1.5, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned()), eventPlayer, 6)
    wait(0.45)
    if ruleCondition:
        loop()


rule "Slow Boosters Cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition abs(eventPlayer.getVelocity().y + 2.5) <= 0.15
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != false
    
    wait(false, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) + 0.008)
    loop()


rule "Double Jump":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.isInAir() == true
    
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), 999999995904)
    if eventPlayer.isOnGround():
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), 999999995904)
    if eventPlayer.isOnGround():
        return
    eventPlayer.applyImpulse(Vector.UP, 6.5, Relativity.TO_WORLD)


rule "Supply Drop":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == false
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.ability2Array[false] = eventPlayer.getAltitude()
    eventPlayer.ability2Array[true] = eventPlayer.getPosition() + Vector.DOWN * eventPlayer.getAltitude()
    eventPlayer.ability2Array[2] = min(4, eventPlayer.ability2Array[0] / 7)
    createProjectile(Projectile.ORISA_FUSION_DRIVER, eventPlayer, eventPlayer.getPosition() + Vector.DOWN, Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.ALL, 0, 1, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0.3, 20, 999999995904)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 8 + eventPlayer.ability2Array[0] / 20)
    wait(eventPlayer.ability2Array[0] / 20)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.GREEN, eventPlayer.ability2Array[true], eventPlayer.ability2Array[2])
    playEffect(getAllPlayers(), DynamicEffect.BAPTISTE_BIOTIC_LAUNCHER_EXPLOSION_SOUND, null, eventPlayer.ability2Array[true], 100)
    createEffect(eventPlayer, Effect.GOOD_AURA, Color.GREEN, eventPlayer.ability2Array[true] + (Vector.UP * (0.2 + max(0.5, eventPlayer.ability2Array[2]) + 0.5 * sin(getTotalTimeElapsed()))), max(0.5, eventPlayer.ability2Array[2]))
    eventPlayer.effects.append(getLastCreatedEntity())
    createEffect(getAllPlayers().exclude(eventPlayer), Effect.GOOD_AURA, Color.ORANGE, eventPlayer.ability2Array[true] + (Vector.UP * (0.2 + max(0.5, eventPlayer.ability2Array[2]) + 0.5 * sin(getTotalTimeElapsed()))), max(0.5, eventPlayer.ability2Array[2]))
    eventPlayer.effects.append(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ROSE, eventPlayer.ability2Array[true] + (Vector.UP * (0.2 + max(0.5, eventPlayer.ability2Array[2]) + 0.5 * sin(getTotalTimeElapsed()))), max(0.375, 0.75 * eventPlayer.ability2Array[2]))
    eventPlayer.effects.append(getLastCreatedEntity())
    createInWorldText(eventPlayer, "+{0} HP".format(floor(25 + 7.5 * eventPlayer.ability2Array[0])), eventPlayer.ability2Array[true] + (Vector.UP * (0.2 + max(0.5, eventPlayer.ability2Array[2]) + 0.5 * sin(getTotalTimeElapsed()))), 1.6, Clip.SURFACES)
    eventPlayer.inWorldTexts[false] = getLastCreatedText()
    waitUntil(eventPlayer.getHealth() < eventPlayer.getMaxHealth() and distance(eventPlayer, eventPlayer.ability2Array[true]) < eventPlayer.ability2Array[2] + true, 8)
    destroyEffect(eventPlayer.effects)
    destroyInWorldText(eventPlayer.inWorldTexts[0])
    if eventPlayer.getHealth() < eventPlayer.getMaxHealth() and distance(eventPlayer, eventPlayer.ability2Array[true]) < eventPlayer.ability2Array[2] + true:
        heal(eventPlayer, null, 25 + 7.5 * eventPlayer.ability2Array[0])
        playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, null, eventPlayer.getPosition(), 100)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ROSE, eventPlayer.getEyePosition(), eventPlayer.ability2Array[2] - 0.2)
        playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer.getEyePosition(), eventPlayer.ability2Array[2])
        playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getEyePosition(), eventPlayer.ability2Array[2])


rule "--- HAZARD ---":
    @Delimiter
    


rule "Hazard Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.HAZARD
    
    eventPlayer.ability1Array = [null, null]
    stopChasing(eventPlayer.scale)
    eventPlayer.scale = null
    eventPlayer.ability1Chase = null
    chaseAtRate(eventPlayer.ability1Chase, false, true)
    eventPlayer.ability2Chase = null
    chaseAtRate(eventPlayer.ability2Chase, false, true)
    eventPlayer.setMaxHealth(54.545)
    #eventPlayer.addHealthPool(Health.NORMAL, 50, true)
    eventPlayer.addHealthPool(Health.ARMOR, 2.273, true)
    startHealingModification(eventPlayer, eventPlayer, 100 + eventPlayer.scale)
    eventPlayer.healingMods.append(getLastHealingModification())
    eventPlayer.isUlting = false
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.heroInfo = ["Passive: Adrenaline0Ability 1: Violent Slam0Ultimate: Toxic Impact".split(null[0]), ["{0}txC0000000003FE37>".format(__holygrail___), "{0}txC00000000017EF8>".format(__holygrail___), "{0}txC00000000001315>".format(__holygrail___)], "Movement and passive regeneration speed increase as health decreases.0Use primary fire during leap to slam at a selected area{0}".format(" with high speed.0Violent slam, quick melee, and jagged wall mark enemies.\nMarked enemies take poison damage and instantly di{0}".format("e when below 15% HP.\nKilling a marked enemy resets leap cooldown and the ult duration.")).split(null[0])]


rule "Track Leap":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != false
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(false)
    waitUntil(not (eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.MELEE)) or eventPlayer.isDead() or [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or not eventPlayer.isInAir() or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.ability1Chase != Vector.LEFT + Vector.RIGHT or not eventPlayer.getAbilityCooldown(Button.ABILITY_1), 4)
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead() or [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or not eventPlayer.isInAir() or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.ability1Chase != Vector.LEFT + Vector.RIGHT or not eventPlayer.getAbilityCooldown(Button.ABILITY_1), 4)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.ability1Array[false] = 1
    else:
        eventPlayer.ability1Array[false] = 2
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) == null, 999999995904)
    eventPlayer.allowButton(Button.ABILITY_1)


rule "Leap Slam":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != false
    
    eventPlayer.setGravity(60)
    eventPlayer.moveSpeed[false] += 50
    eventPlayer.ability1Array[false] = null
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - 3 * eventPlayer.getFacingDirection() + worldVector(vect(-0.9, 0.9, false), eventPlayer, Transform.ROTATION), null, getAllPlayers(), false)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100))
    eventPlayer.ability1Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability1Chase, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 50, null, eventPlayer, false) if not isInLoS(eventPlayer, eventPlayer.getEyePosition() + 50 * eventPlayer.getFacingDirection()) and (raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 50, null, eventPlayer, false)).y > 0.5 else Vector.LEFT + Vector.RIGHT, 999999995904)
    createEffect(eventPlayer if eventPlayer.ability1Chase else null, Effect.RING, Color.VIOLET, eventPlayer.ability1Chase, 5 if eventPlayer.isUlting else 3)
    eventPlayer.ability1Array[true] = getLastCreatedEntity()
    if eventPlayer.ultArray[0] > null:
        bigMessage(getAllPlayers(), "{0}: {1}fg721FA3FF>AGAIN!".format(heroIcon(Hero.HAZARD), __holygrail___))
    waitUntil(eventPlayer.ability1Array[0] > null, 999999995904)
    if eventPlayer.ability1Array[0] == 1:
        if eventPlayer.ability1Chase:
            stopChasing(eventPlayer.ability1Chase)
            eventPlayer.setGravity(false)
            eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.01, Relativity.TO_WORLD)
            while distance(eventPlayer, eventPlayer.ability1Chase) > 2 and eventPlayer.getAbilityCooldown(Button.ABILITY_1):
                if [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isChained:
                    break
                eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.ability1Chase), 50 * eventPlayer.moveSpeed / 100, Relativity.TO_WORLD)
                wait(false)
    destroyEffect(eventPlayer.ability1Array[true])
    eventPlayer.setGravity(100)
    eventPlayer.moveSpeed[false] -= 50
    eventPlayer.stopCamera()
    if eventPlayer.ability1Array[0] == 1:
        if eventPlayer.isUlting:
            (((getPlayersInRadius(eventPlayer.getPosition(), 7, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)).hazardMarked)[false] = [getTotalTimeElapsed() + 5, eventPlayer]
            eventPlayer.ultArray[false]++
        createProjectile(Projectile.ROADHOG_SCRAP, eventPlayer, eventPlayer.getPosition(), Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, (80 * (100 + eventPlayer.scale)) / 100, 0.5, 5 if eventPlayer.isUlting else 3, DynamicEffect.WINSTON_JUMP_PACK_LANDING, DynamicEffect.WINSTON_JUMP_PACK_LANDING_SOUND, 0, 999999995904, 0, (12 * (100 + eventPlayer.scale)) / 100, 0, 999999995904)
        if not eventPlayer.isUlting:
            waitUntil(eventPlayer.isJumping(), 0.2)
            if not eventPlayer.isJumping():
                return
            eventPlayer.moveSpeed[false] += 50
            waitUntil(eventPlayer.isOnGround(), 999999995904)
            eventPlayer.moveSpeed[false] -= 50


rule "Adrenaline Increase Speed":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.scale == null
    
    while eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.moveSpeed[false] -= eventPlayer.scale
        eventPlayer.scale = round(min(50, 50 * (true - max(eventPlayer.getHealth(), 50) / eventPlayer.getMaxHealth())))
        eventPlayer.moveSpeed[false] += eventPlayer.scale
        wait(0.25)


rule "Passive Regen":
    @Event playerTookDamage
    @Hero hazard
    
    stopHealingOverTime(eventPlayer.ability2Array[0])
    eventPlayer.ability2Array[true] = (6 * (50 - eventPlayer.scale)) / 50
    wait(eventPlayer.ability2Array[true], Wait.RESTART_WHEN_TRUE)
    eventPlayer.startHealingOverTime(eventPlayer, 6 - eventPlayer.ability2Array[true], (true + eventPlayer.scale / 100) * (10 + 0.05 * eventPlayer.getMaxHealth()))
    eventPlayer.ability2Array[false] = getLastHealingOverTimeId()


rule "Kill When Marked and Below 15% HP":
    @Event playerTookDamage
    @Condition eventPlayer.hazardMarked[0] > getTotalTimeElapsed()
    
    if eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.15:
        kill(eventPlayer, eventPlayer.hazardMarked[true])
        eventPlayer.hazardMarked[false] = null
        eventPlayer.hazardMarked[true].ultChase1 = 100
        eventPlayer.hazardMarked[true].setAbilityCooldown(Button.ABILITY_1, false)


rule "Toxic Impact":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    eventPlayer.moveSpeed[false] += 35
    eventPlayer.isUlting = true
    eventPlayer.ultArray[false] = null
    bigMessage(getAllPlayers(), "{0}: ARMED AND {1}fg721FA3FF>TOXIC{1}/fg>!".format(heroIcon(Hero.HAZARD), __holygrail___))
    eventPlayer.ultChase1 = 100
    chaseAtRate(eventPlayer.ultChase1, false, 12.5)
    createProgressBarInWorldText(eventPlayer, eventPlayer.ultChase1, "TOXIC IMPACT", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, Color.VIOLET)
    eventPlayer.iwtProgressBars[false] = getLastCreatedText()
    if eventPlayer.ability1Array[0] != null:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
    waitUntil(eventPlayer.isDead() or eventPlayer.ultChase1 == null, 999999995904)
    eventPlayer.moveSpeed[false] -= 35
    eventPlayer.isUlting = false
    destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[0])
    (getAllPlayers().filter(lambda player: player.hazardMarked[true] == eventPlayer)).hazardMarked = [null, null]
    smallMessage(eventPlayer, "{0} slam{1}!".format(eventPlayer.ultArray[0] + true, "s" if eventPlayer.ultArray[0] != null else ""))
    wait(false)
    eventPlayer.ultArray[false] = null


rule "Melee Mark":
    @Event playerDealtDamage
    @Hero hazard
    @Condition eventAbility in [Button.MELEE, Button.ABILITY_1, Button.ABILITY_2] == true
    @Condition eventPlayer.isUlting != false
    
    victim.hazardMarked = [max(victim.hazardMarked[0], getTotalTimeElapsed() + 3), eventPlayer]


rule "Mark Poison Damage":
    @Event eachPlayer
    @Condition eventPlayer.hazardMarked[0] > getTotalTimeElapsed()
    
    eventPlayer.startDamageOverTime(eventPlayer.hazardMarked[true], eventPlayer.hazardMarked[0] - getTotalTimeElapsed(), 20)
    eventPlayer.hazardMarked[2] = getLastDamageOverTimeId()
    waitUntil(not eventPlayer.hazardMarked[0] > getTotalTimeElapsed(), 999999995904)
    stopDamageOverTime(eventPlayer.hazardMarked[2])


rule "--- ORISA ---":
    @Delimiter
    


rule "Orisa Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ORISA
    
    #patience meter
    eventPlayer.ability1Chase = 100
    eventPlayer.ability2Chase = vect(240, 117, 160)
    #2.26 * eventPlayer.ability1Chase + 73)
    #if eventPlayer.ability1Chase < 50 else
    #vect(
    #-0.14 * eventPlayer.ability1Chase + 230,
    #-1.38 * eventPlayer.ability1Chase + 255,
    #-0.52 * eventPlayer.ability1Chase + 212
    #), Math.INFINITY)
    #is passive
    eventPlayer.ability1Array[false] = true
    eventPlayer.hasTargetAbility[false] = true
    eventPlayer.hasTargetAbility[true] = 25
    startDamageModification(eventPlayer if eventPlayer.ability1Array[0] else null, getAllPlayers(), 1)
    eventPlayer.damageMods.append(getLastDamageModification())
    startDamageModification(eventPlayer, eventPlayer.ability1Target if eventPlayer.ability1Target.isRidingOrisa[0] else null, 0)
    eventPlayer.damageMods.append(getLastDamageModification())
    startDamageModification(getAllPlayers(), eventPlayer.ability1Target if eventPlayer.ability1Target.isRidingOrisa[0] else null, 125)
    eventPlayer.damageMods.append(getLastDamageModification())
    startDamageModification((getPlayersInRadius(eventPlayer, 8, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer), getAllPlayers(), 75 if eventPlayer.ability1Array[0] else 150)
    eventPlayer.damageMods.append(getLastDamageModification())
    #createEffect(getAllPlayers() if eventPlayer.isAlive() else null,
    #Effect.RING, Color.ROSE if eventPlayer.ability1Array[0] else Color.RED, updateEveryFrame(eventPlayer.getPosition()), 8)
    #eventPlayer.effects[0] = getLastCreatedEntity()
    createProgressBarInWorldText(eventPlayer, eventPlayer.ability1Chase, "P A T I E N C E" if eventPlayer.ability1Array[0] else "F U R Y", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, rgb(240, 117, 160) if eventPlayer.ability1Array[0] else rgb(255, 64, 64))
    eventPlayer.iwtProgressBars.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() and eventPlayer.hasTargetAbility[0] and eventPlayer.ability1Array[0] and entityExists(eventPlayer.targetAbility) else null, "{0} Request Mount".format(inputBindingString(Button.PRIMARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.targetAbility.getPosition() + (Vector.UP * (1.5 + 3 / max(3, distance(eventPlayer, eventPlayer.targetAbility))))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setMaxHealth(16.67)
    eventPlayer.addHealthPool(Health.NORMAL, 100, true)
    eventPlayer.addHealthPool(Health.ARMOR, 170.43, true)
    eventPlayer.heroInfo = ["Passive 1: Chill or Kill0Primary Fire: Mount0Ability 1: Lunge / Trample".split(null[0]), ["{0}txC00000000049435>".format(__holygrail___), "{0}txC000000000144A6>".format(__holygrail___), "{0}txC0000000000130B>".format(__holygrail___)], ["Start off in chill mode, where you take no damage.\nWhen you get attacked enough times, switch to kill mode.\n-----------------{0}".format("--------------\nPassive 2: Vibe emission {0}txC00000000003E7A>\nPlayers around you take more or less damage depending on your mode".format(__holygrail___)), "While in chill mode, primary fire sends a mount request.\nOther players can ride you and increase your mobility.", "Chill Mode: Lunge forward for mobility.\nKill mode: Home towards a targeted enemy, then damage and stun them."]]


rule "On Death":
    @Event playerDied
    @Hero orisa
    
    stopChasing(eventPlayer.ability1Chase)
    eventPlayer.ability1Chase = 100


rule "Force Hello":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.ability1Array[0] != false
    
    eventPlayer.communicate(Comms.HELLO)


rule "Request -/ Mount":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.ability1Array[0] != false
    @Condition eventPlayer.isAlive() == true
    @Condition entityExists(eventPlayer.targetAbility) == true
    
    eventPlayer.ability1Target = eventPlayer.targetAbility
    bigMessage(eventPlayer, "Mount Request Sent to {0}".format(eventPlayer.ability1Target))
    bigMessage(eventPlayer.ability1Target, "{0}: {1} has requested that you ride them.".format(heroIcon(Hero.ORISA), eventPlayer))
    wait(true)
    bigMessage(eventPlayer.ability1Target, "Crouch within 5m of {0} to mount them.".format(eventPlayer))
    waitUntil(eventPlayer.ability1Target.isHoldingButton(Button.CROUCH) and distance(eventPlayer, eventPlayer.ability1Target) < 5, 10)
    if eventPlayer.isDead():
        eventPlayer.ability1Target = null
        return
    if not (eventPlayer.ability1Target.isHoldingButton(Button.CROUCH) and distance(eventPlayer, eventPlayer.ability1Target) < 5):
        bigMessage(eventPlayer, "Mount request declined")
        eventPlayer.ability1Target = null
        return
    eventPlayer.ability1Target.attachTo(eventPlayer, vect(false, 1.75, -1.25))
    eventPlayer.ability1Target.isRidingOrisa[false] = true
    eventPlayer.ability1Target.isRidingOrisa[true] = eventPlayer
    eventPlayer.ability1Target.setStatusEffect(null, Status.ROOTED, 99999)
    smallMessage(eventPlayer, "{0} has mounted you.".format(eventPlayer.ability1Target))
    smallMessage(eventPlayer, "Hold crouch to get them off.")
    smallMessage(eventPlayer.ability1Target, "Hold jump to dismount")
    eventPlayer.hasTargetAbility[false] = false
    eventPlayer.moveSpeed[false] += 75
    eventPlayer.setJumpVerticalSpeed(200)
    waitUntil(not [eventPlayer.isAlive(), eventPlayer.ability1Target.isAlive(), eventPlayer.ability1Target.isRidingOrisa[0], eventPlayer.ability1Array[0]].all(), 999999995904)
    smallMessage(eventPlayer, "{0} stopped riding you".format(eventPlayer.ability1Target))
    smallMessage(eventPlayer.ability1Target, "stopped riding {0}".format(eventPlayer))
    eventPlayer.ability1Target.detach()
    eventPlayer.ability1Target.isRidingOrisa[false] = false
    eventPlayer.ability1Target.isRidingOrisa[true] = null
    eventPlayer.ability1Target.clearStatusEffect(Status.ROOTED)
    eventPlayer.hasTargetAbility[false] = true
    eventPlayer.ability1Target = null
    eventPlayer.moveSpeed[false] -= 75
    eventPlayer.setJumpVerticalSpeed(100)


rule "Force Dismount":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.ability1Array[0] != false
    @Condition entityExists(eventPlayer.ability1Target) == true
    @Condition eventPlayer.ability1Target.isRidingOrisa[true] == eventPlayer
    @Condition eventPlayer.isCrouching() == true
    
    smallMessage(eventPlayer, "Forcing {0} to dismount".format(eventPlayer.ability1Target))
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), 1.5)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.ability1Target.isRidingOrisa[false] = false


rule "Dismount Orisa":
    @Event eachPlayer
    @Condition eventPlayer.isRidingOrisa[0] != false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    smallMessage(eventPlayer, "Dismounting {0}".format(eventPlayer.isRidingOrisa[true]))
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 1.5)
    if eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.isRidingOrisa[false] = false
        return
    smallMessage(eventPlayer, "Dismount Canceled")


rule "Get Score From Rider Kills":
    @Event playerDealtFinalBlow
    @Condition eventPlayer.isRidingOrisa[0] != false
    
    eventPlayer.isRidingOrisa[true].addToScore(true)


rule "Lose / Regain Patience":
    @Event playerTookDamage
    @Hero orisa
    @Condition eventPlayer.ability1Array[0] != false
    
    stopChasing(eventPlayer.ability1Chase)
    heal(eventPlayer, null, eventDamage)
    eventPlayer.ability1Chase -= eventDamage * 0.33 * 100
    wait(8, Wait.RESTART_WHEN_TRUE)
    chaseAtRate(eventPlayer.ability1Chase, 100, 25)


rule "Snap":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.ability1Chase <= null
    @Condition eventPlayer.isAlive() == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.ability1Array[false] = false
    eventPlayer.setDamageDealt(200)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    createEffect(getAllPlayers(), Effect.WINSTON_PRIMAL_RAGE, Color.TEAM_1, eventPlayer, true)
    eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].slice(false, false).concat([getLastCreatedEntity()]).concat(eventPlayer.ability1Array[true].slice(0 + true, 999999995904))
    bigMessage(getAllPlayers(), "{0}: {1} HAS SNAPPED".format(heroIcon(Hero.ORISA), eventPlayer))
    waitUntil(not (eventPlayer.ability1Chase <= null and eventPlayer.isAlive()), 999999995904)
    eventPlayer.ability1Array[false] = true
    destroyEffect(eventPlayer.ability1Array[true])
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageDealt(100)


rule "Stampede":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    createEffect(getAllPlayers(), Effect.LUCIO_SOUND_BARRIER_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.ability2Array[false] = eventPlayer.ability2Array[0].slice(false, false).concat([getLastCreatedEntity()]).concat(eventPlayer.ability2Array[0].slice(0 + true, 999999995904))
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.ability2Array[false] = eventPlayer.ability2Array[0].slice(false, true).concat([getLastCreatedEntity()]).concat(eventPlayer.ability2Array[0].slice(true + true, 999999995904))
    if eventPlayer.ability1Array[0] or not entityExists(eventPlayer.targetAbility):
        eventPlayer.forceButtonPress(Button.MELEE)
        eventPlayer.forceButtonPress(Button.JUMP)
        eventPlayer.ability3Chase = 1
        chaseOverTime(eventPlayer.ability3Chase, false, 0.5)
        while eventPlayer.ability3Chase:
            eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD)
            eventPlayer.applyImpulse(Vector.FORWARD, 10, Relativity.TO_PLAYER)
            wait(0.05)
        stopChasing(eventPlayer.ability3Chase)
    elif not eventPlayer.ability1Array[0]:
        eventPlayer.ability3Chase = eventPlayer.targetAbility
        while distance(eventPlayer, eventPlayer.ability3Chase) > 2:
            eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.ability3Chase), 30, Relativity.TO_WORLD)
            wait(0.05)
        eventPlayer.forceButtonPress(Button.MELEE)
        damage(eventPlayer.ability3Chase, eventPlayer, 50)
        eventPlayer.ability3Chase.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2)
    destroyEffect(eventPlayer.ability2Array[0])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, true)


rule "Punishment":
    @Event playerDealtFinalBlow
    @Hero orisa
    @Condition eventPlayer.ability1Array[0] != false
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 9)
    wait(true)
    bigMessage(eventPlayer, "God: Why did you kill {0} unprovoked?".format(victim))
    wait(3)
    bigMessage(eventPlayer, "You are supposed to bring peace to this world.")
    wait(2)
    bigMessage(eventPlayer, "Now think about what you've done.")
    eventPlayer.moveSpeed[false] -= 70
    wait(4)
    createBeam(getAllPlayers(), Beam.OMNIC_SLICER, eventPlayer.getPosition(), eventPlayer.getPosition() + 100 * Vector.UP, Color.TEAM_1)
    eventPlayer.effects[true] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, null, eventPlayer.getPosition(), 1)
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION_SOUND, null, eventPlayer.getPosition(), 100)
    kill(eventPlayer)
    eventPlayer.moveSpeed[false] += 70
    wait(0.5)
    bigMessage(getAllPlayers(), "{0} has been smitten.".format(eventPlayer))
    destroyEffect(eventPlayer.effects[true])


rule "--- ROADHOG ---":
    @Delimiter
    


rule "Roadhog Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ROADHOG
    
    eventPlayer.ability1Array[false] = null
    eventPlayer.setMaxHealth(39900 / eventPlayer.getMaxHealth())
    eventPlayer.addHealthPool(Health.NORMAL, true + 50 * eventPlayer.ability1Array[0], true)
    eventPlayer.startScalingSize(0.88 + 0.08 * eventPlayer.ability1Array[0])
    eventPlayer.ability1Array[true] = false
    createInWorldText(eventPlayer if eventPlayer.getAltitude() >= 5 else null, "{0}txC00000000017Ef8>: [CROUCH]".format(__holygrail___), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.5 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createEffect(getAllPlayers() if eventPlayer.isAlive() and eventPlayer.getVelocity().y <= -12 else null, Effect.RING, Color.RED, updateEveryFrame(raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + -1000 * Vector.UP, getAllPlayers(), eventPlayer, false)), 10)
    eventPlayer.effects.append(getLastCreatedEntity())
    createInWorldText(getAllPlayers() if eventPlayer.isAlive() and eventPlayer.getVelocity().y <= -12 else null, "{0}txC0000000001F944> INCOMING {0}txC0000000001F944>".format(__holygrail___), updateEveryFrame(raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + -1000 * Vector.UP, getAllPlayers(), eventPlayer, false) + 2 * Vector.UP), 4, Clip.SURFACES)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Ability 1: Hook Cling0Passive 1: Gluttony0Passive 2: Heavyweight".split(null[0]), ["{0}txC00000000001313>".format(__holygrail___), "{0}txC00000000003382>".format(__holygrail___), "{0}txC00000000017Ef8>".format(__holygrail___)], "Chain hook is a grappling hook that pulls you to its destination.\nAfter grappling, hold jump to slow your fall for up to 3s.0{0}".format("Enemies drop pork chops upon death.\nEating a pork chop increases your max Hp, size, and weight0When landing with a lot of for{0}".format("ce, cause a shockwave that stuns and damages everyone.\nThis becomes more effective the heavier you are.\nCrouch while airborne{0}".format(" to accelerate your fall."))).split(null[0])]


rule "Cancel Hook if Landed":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    
    eventPlayer.cancelPrimaryAction()


rule "Hook Cling Effect":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1() == true
    
    #Check 6 directions to make sure hook hit no one
    wait(0.128)
    eventPlayer.ability2Array[false] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (20 + 1.6 * eventPlayer.ability1Array[0])), null, eventPlayer, true)
    if isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (17.6 + 1.6 * eventPlayer.ability1Array[0])), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and not entityExists(raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (20 + 1.6 * eventPlayer.ability1Array[0])), getAllPlayers(), eventPlayer, false)):
        return
    eventPlayer.ability2Array[true] = distance(eventPlayer.getEyePosition(), eventPlayer.ability2Array[0])
    eventPlayer.ability2Array[2] = directionTowards(eventPlayer.getEyePosition(), eventPlayer.ability2Array[0])
    wait(eventPlayer.ability2Array[true] / 62)
    eventPlayer.ability2Chase = null
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.ability2Array[true], 30)
    while eventPlayer.isAlive() and not [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() and eventPlayer.ability2Chase < eventPlayer.ability2Array[true]:
        eventPlayer.applyImpulse(eventPlayer.ability2Array[2], 30, Relativity.TO_WORLD)
        wait(0.05)
    stopChasing(eventPlayer.ability2Chase)
    eventPlayer.moveSpeed[false] += 50
    eventPlayer.canGlide = [true, [Button.JUMP, Button.SECONDARY_FIRE], 1.75, null]
    waitUntil(eventPlayer.isDead() or eventPlayer.isOnGround(), 3)
    eventPlayer.canGlide[false] = false
    waitUntil(eventPlayer.isDead() or eventPlayer.isOnGround(), 999999995904)
    eventPlayer.moveSpeed[false] -= 50


rule "Heavyweight":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.getVelocity().y <= -14
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAltitude() > 0.5
    
    eventPlayer.ability1Array[true] = true
    waitUntil(not (eventPlayer.isInAir() and eventPlayer.getVelocity().y <= -14 and eventPlayer.isAlive() and eventPlayer.getAltitude() > 0.5), 999999995904)
    eventPlayer.ability1Array[true] = false
    if eventPlayer.getAltitude() < 0.5:
        eventPlayer.ability1Array[2] = (getPlayersInRadius(eventPlayer.getPosition(), 10, Team.ALL, LosCheck.SURFACES_AND_ALL_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, null, eventPlayer.getPosition(), 1)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, null, eventPlayer.getPosition(), 1)
        playEffect(getAllPlayers(), DynamicEffect.WRECKING_BALL_PILEDRIVER_IMPACT_SOUND, null, eventPlayer.getPosition(), 1)
        eventPlayer.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, true)
        damage(eventPlayer, eventPlayer, 25 + 25 * eventPlayer.ability1Array[0])
        for i in range(0, len(eventPlayer.ability1Array[2]), true):
            damage(eventPlayer.ability1Array[2][i], eventPlayer, 25 + 10 * eventPlayer.ability1Array[0])
            eventPlayer.ability1Array[2][i].setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2.5 + 0.05 * eventPlayer.ability1Array[0])
            eventPlayer.ability1Array[2][i].applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.ability1Array[2][i].getPosition()), 12, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Drop and Eat Pork Chop / Rest Stacks":
    @Event playerDied
    @Condition isHeroBeingPlayed(Hero.ROADHOG, Team.ALL) == true
    @Condition eventPlayer.isDummy() == false
    
    if eventPlayer.getHero() == Hero.ROADHOG:
        eventPlayer.ability1Array[false] = null
    porkChops[false] = porkChops[0].slice(false, eventPlayer.getSlot()).concat([eventPlayer.getPosition()]).concat(porkChops[0].slice(eventPlayer.getSlot() + true, 999999995904))
    createEffect(getPlayersOnHero(Hero.ROADHOG, Team.ALL), Effect.GOOD_AURA, Color.RED, evalOnce(eventPlayer.getPosition()) + (Vector.UP * (0.7 + (0.2 * (sinDeg(evalOnce(random.randint(false, 360)) + 180 * getTotalTimeElapsed()))))), 0.4)
    porkChops[true] = (porkChops[true].slice(false, eventPlayer.getSlot()).concat([porkChops[true][eventPlayer.getSlot()].slice(false, false).concat([getLastCreatedEntity()]).concat(porkChops[true][eventPlayer.getSlot()].slice(0 + true, 999999995904))])).concat(porkChops[true].slice(eventPlayer.getSlot() + true, 999999995904))
    createInWorldText(getPlayersOnHero(Hero.ROADHOG, Team.ALL).filter(lambda player: distance(player, evalOnce(eventPlayer.getPosition())) < 4), "Crouch to Consume", evalOnce(eventPlayer.getPosition()) + 1.7 * Vector.UP, 2.5)
    porkChops[true] = (porkChops[true].slice(false, eventPlayer.getSlot()).concat([porkChops[true][eventPlayer.getSlot()].slice(false, true).concat([getLastCreatedText()]).concat(porkChops[true][eventPlayer.getSlot()].slice(true + true, 999999995904))])).concat(porkChops[true].slice(eventPlayer.getSlot() + true, 999999995904))
    waitUntil(getPlayersOnHero(Hero.ROADHOG, Team.ALL).any(lambda player: player.isCrouching() and distance(player, porkChops[0][eventPlayer.getSlot()]) < 4) or eventPlayer.isAlive(), 10)
    destroyEffect(porkChops[true][eventPlayer.getSlot()][0])
    destroyInWorldText(porkChops[true][eventPlayer.getSlot()][true])
    if eventPlayer.isAlive():
        return
    else:
        porkChops[2] = (porkChops[2].slice(false, eventPlayer.getSlot()).concat([(getPlayersOnHero(Hero.ROADHOG, Team.ALL).filter(lambda player: player.isCrouching() and distance(player, porkChops[0][eventPlayer.getSlot()]) < 4))[0]])).concat(porkChops[2].slice(eventPlayer.getSlot() + true, 999999995904))
        porkChops[2][eventPlayer.getSlot()].ability1Array[false]++
        wait(false)
        heal(porkChops[2][eventPlayer.getSlot()], null, 50)
        porkChops[2][eventPlayer.getSlot()].setAbilityResource(Button.ABILITY_2, 100)


rule "Slam to Ground":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.getAltitude() >= 5
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    while eventPlayer.getAltitude() >= 5 and eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.applyImpulse(Vector.DOWN, 25, Relativity.TO_WORLD)
        wait(false)


rule "--- SIGMA ---":
    @Delimiter
    


rule "Sigma Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.SIGMA
    
    eventPlayer.ability1Array = []
    eventPlayer.flight = [true, 6.05]
    eventPlayer.startScalingSize(0.92)
    eventPlayer.startScalingBarriers(1.11)
    eventPlayer.addHealthPool(Health.NORMAL, 28.58, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 101.8, true)
    eventPlayer.heroInfo = ["Passive 1: Complete Gravitational Control0Passive 2: G-Force0Ability 1: Kinetic Vortex".split(null[0]), ["{0}txC0000000001E304>".format(__holygrail___), "{0}txC00000000017EF8>".format(__holygrail___), "{0}txC000000000039DA>".format(__holygrail___)], "Gain permanent free-flight.0Enemies take fall damage that scales with height;\nthis damage reduces your cooldowns.0Pull the en{0}".format("emies in your sight towards you.").split(null[0])]


rule "One Orb":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.cancelPrimaryAction()


rule "Kinetic Suck":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isUsingAbility1() == true
    
    createBeam(getAllPlayers(), Beam.TORBJORN_TURRET_SIGHT, eventPlayer.getEyePosition() + (5 * (directionFromAngles(eventPlayer.getHorizontalFacingAngle() + 10 * (cosDeg(180 * getTotalTimeElapsed())), eventPlayer.getVerticalFacingAngle() + 10 * (sinDeg(180 * getTotalTimeElapsed()))))), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + (50 * (directionFromAngles(eventPlayer.getHorizontalFacingAngle() + 10 * (cosDeg(180 * getTotalTimeElapsed())), eventPlayer.getVerticalFacingAngle() + 10 * (sinDeg(180 * getTotalTimeElapsed()))))), null, eventPlayer, false), Color.TEAM_1)
    eventPlayer.ability1Array[false] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.TORBJORN_TURRET_SIGHT, eventPlayer.getEyePosition() + (5 * (directionFromAngles(eventPlayer.getHorizontalFacingAngle() + (10 * (cosDeg(180 * getTotalTimeElapsed() + 180))), eventPlayer.getVerticalFacingAngle() + (10 * (sinDeg(180 * getTotalTimeElapsed() + 180)))))), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + (50 * (directionFromAngles(eventPlayer.getHorizontalFacingAngle() + (10 * (cosDeg(180 * getTotalTimeElapsed() + 180))), eventPlayer.getVerticalFacingAngle() + (10 * (sinDeg(180 * getTotalTimeElapsed() + 180)))))), null, eventPlayer, false), Color.TEAM_1)
    eventPlayer.ability1Array[true] = getLastCreatedEntity()
    eventPlayer.flight[true] = 18.15
    eventPlayer.ability1Array[2] = getTotalTimeElapsed() + 0.25
    while eventPlayer.isUsingAbility1():
        if eventPlayer.flight[true] == 18.15 and getTotalTimeElapsed() >= eventPlayer.ability1Array[2]:
            eventPlayer.flight[true] = 8.47
        eventPlayer.ability1Target = getAllPlayers().filter(lambda player: player != eventPlayer and player.isAlive() and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, player)) < 10 and isInLoS(eventPlayer, player) and distance(player, eventPlayer) > 5 and distance(player, eventPlayer) <= 50)
        for i in range(0, len(eventPlayer.ability1Target), true):
            eventPlayer.ability1Target[i].applyImpulse(directionTowards(eventPlayer.ability1Target[i].getPosition(), eventPlayer.getPosition()), 0.9, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.ability1Target[i].setEnvironmentalKillCreditor(eventPlayer)
        wait(false)
    destroyEffect(eventPlayer.ability1Array[0])
    destroyEffect(eventPlayer.ability1Array[true])
    eventPlayer.flight[true] = 6.05
    if eventPlayer.getMaxHealth() < 350:
        damage(eventPlayer, null, eventPlayer.getMaxHealth() - 350)


rule "Set Fall Damage Variable":
    @Event eachPlayer
    @Condition eventPlayer.getAltitude() > eventPlayer.fallDamage
    @Condition eventPlayer.getAltitude() >= 7
    @Condition isHeroBeingPlayed(Hero.SIGMA, Team.ALL) == true
    @Condition eventPlayer.getHero() != Hero.SIGMA
    @Condition (eventPlayer.getHero() == Hero.SOLDIER and not eventPlayer.ability1Array[0][0]) == false
    
    eventPlayer.fallDamage = eventPlayer.getAltitude()
    wait(0.1)
    if ruleCondition:
        loop()


rule "Take Fall Damage":
    @Event eachPlayer
    @Condition eventPlayer.getAltitude() < 0.5
    @Condition eventPlayer.fallDamage != false
    
    if eventPlayer.getVelocity().y <= -8:
        for i in range(0, getNumberOfHeroes(Hero.SIGMA, Team.ALL), true):
            damage(eventPlayer, getPlayersOnHero(Hero.SIGMA, Team.ALL)[i], 6 * eventPlayer.fallDamage / getNumberOfHeroes(Hero.SIGMA, Team.ALL))
            getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].setAbilityCooldown(Button.ABILITY_1, getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].getAbilityCooldown(Button.ABILITY_1) - eventPlayer.fallDamage / 7)
            getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].setAbilityCooldown(Button.ABILITY_2, getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].getAbilityCooldown(Button.ABILITY_2) - eventPlayer.fallDamage / 7)
            getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].setAbilityCooldown(Button.SECONDARY_FIRE, getPlayersOnHero(Hero.SIGMA, Team.ALL)[i].getAbilityCooldown(Button.SECONDARY_FIRE) - eventPlayer.fallDamage / 7)
    eventPlayer.fallDamage = null


rule "--- WINSTON ---":
    @Delimiter
    


rule "Winston Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.WINSTON
    
    eventPlayer.startScalingBarriers(0.8)
    eventPlayer.startScalingSize(0.9)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setMaxHealth(46.15)
    eventPlayer.addHealthPool(Health.NORMAL, 98.07, true)
    eventPlayer.addHealthPool(Health.ARMOR, 7.69, true)
    eventPlayer.ability1Array[false] = false
    eventPlayer.ability1Chase = null
    eventPlayer.ability2Chase = null
    eventPlayer.ability3Chase = null
    chaseAtRate(eventPlayer.ability1Chase, false, 16.67)
    chaseAtRate(eventPlayer.ability2Chase, false, true)
    chaseAtRate(eventPlayer.ability3Chase, false, true)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC0000000000E613>: {1}".format(__holygrail___, "{0}".format(eventPlayer.ability2Chase).substring(0, 2 + strLen("{0}".format(floor(eventPlayer.ability2Chase)))) if eventPlayer.ability2Chase else "Ready"), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(145, 187, 209))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createProgressBarInWorldText(eventPlayer if eventPlayer.isAlive() and eventPlayer.ability1Chase else null, eventPlayer.ability1Chase, "RΟCKET RIDE", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.8 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, Color.ORANGE)
    eventPlayer.iwtProgressBars.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Ability 1: Rocket Ride0Melee: Knockout0Ability 2: Heal Field".split(null[0]), ["{0}txC0000000000130A>".format(__holygrail___), "{0}txC0000000000E613>".format(__holygrail___), "{0}txC000000000039DD>".format(__holygrail___)], "Ride a rocket that accelerates you forward.\nJump or crouch to dismount the rocket and launch it forward.0Melee damage does mo{0}".format("re damage and knocks out enemies.\nDuring Rocket ride:\n- Knockout has a greatly reduced cooldown.\n- Grant a burst of movement.{0}".format("\n- Extend rocket ride duration by 1.5s.\n- Cause an additional explosion that damages enemies.0Barrier projector heals all pla{0}".format("yers inside (including enemies)."))).split(null[0])]


rule "Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    eventPlayer.setGravity(false)
    #eventPlayer.moveSpeed[0] += 191
    #eventPlayer.startAcceleration(eventPlayer.getFacingDirection(), 16, 16, Relativity.TO_WORLD)
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - 3 * eventPlayer.getFacingDirection() + worldVector(vect(-0.8, 0.3, false), eventPlayer, Transform.ROTATION), null, getAllPlayers(), false)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100))
    createProjectileEffect(getAllPlayers(), Projectile.PHARAH_ROCKET, eventPlayer, updateEveryFrame(eventPlayer.getPosition() + 0.3 * Vector.UP), updateEveryFrame(eventPlayer.getFacingDirection()), 0.15)
    eventPlayer.effects[false] = getLastCreatedEntity()
    eventPlayer.ability1Chase = 100
    eventPlayer.ability1Array[true] = null
    while eventPlayer.ability1Chase > null and eventPlayer.isAlive():
        eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 2.4 if eventPlayer.ability3Chase else 0.45, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        if [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP):
            createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, eventPlayer.getPosition(), eventPlayer.getFacingDirection(), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, 100, 1, 3.5, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION_SOUND, 0.1, 26, 3, 8)
            eventPlayer.applyImpulse(Vector.UP, 7, Relativity.TO_WORLD)
            break
        wait(false)
    eventPlayer.ability1Chase = null
    eventPlayer.setGravity(100)
    destroyEffect(eventPlayer.effects[0])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2 if eventPlayer.isUsingUltimate() else 7)
    eventPlayer.stopCamera()


rule "Knockout":
    @Event playerDealtDamage
    @Hero winston
    @Condition (eventPlayer.isUsingUltimate() or eventAbility == Button.MELEE) == true
    @Condition victim.isAlive() == true
    
    if eventPlayer.ability2Chase and eventPlayer.ability1Chase:
        eventPlayer.ability2Chase = null
    if not eventPlayer.ability2Chase:
        damage(victim, eventPlayer, 40 / eventPlayer.ability1Array[true] if eventPlayer.ability1Chase else 20)
        victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2 / (eventPlayer.ability1Array[true] * 0.33 + true) if eventPlayer.ability1Chase else 1.75)
        eventPlayer.ability3Chase = 0.4 + 0.2 * eventPlayer.ability1Array[true]
        eventPlayer.ability2Chase = 1 if eventPlayer.ability1Chase else 10
        if eventPlayer.ability1Chase:
            eventPlayer.ability1Array[true]++
            eventPlayer.ability1Chase += 25
            playEffect(getAllPlayers(), DynamicEffect.PHARAH_BARRAGE_EXPLOSION, Color.TEAM_1, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2, 1)
            playEffect(getAllPlayers(), DynamicEffect.PHARAH_BARRAGE_EXPLOSION_SOUND, Color.TEAM_1, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2, 100)


rule "Heal Shield":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingAbility2() == true
    
    wait(0.13)
    eventPlayer.ability1Array[2] = raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + Vector.DOWN * eventPlayer.getAltitude(), null, eventPlayer, false)
    eventPlayer.ability1Array[3] = eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)
    eventPlayer.ability1Array[4] = getTotalTimeElapsed() + 8
    while eventPlayer.ability1Array[4] > getTotalTimeElapsed() and eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED) - eventPlayer.ability1Array[3] < 300:
        heal(getPlayersInRadius(eventPlayer.ability1Array[2], 4, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned()), eventPlayer, 5)
        playEffect(getAllPlayers(), DynamicEffect.HEAL_TARGET_ACTIVE, Color.TEAM_1, eventPlayer.ability1Array[2] + random.uniform(-4, 4) * directionFromAngles(random.randint(false, 360), 0), 1)
        wait(0.14)


rule "--- WRECKING BALL ---":
    @Delimiter
    


rule "Ball Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.WRECKING_BALL
    
    eventPlayer.ability1Array[false] = null
    eventPlayer.setMaxHealth(1)
    eventPlayer.addHealthPool(Health.NORMAL, 168.75, true)
    eventPlayer.addHealthPool(Health.ARMOR, 200, true)
    eventPlayer.startScalingSize(0.88)
    eventPlayer.ability1Target = []
    createBeam(getAllPlayers() if eventPlayer.isFiringPrimaryFire() else null, Beam.MOIRA_COALESCENCE, updateEveryFrame(eventPlayer.getFacingDirection() + eventPlayer.getEyePosition() + worldVector(-0.65 * Vector.LEFT, eventPlayer, Transform.ROTATION) - (0.33 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))), raycastHitPosition(eventPlayer.getEyePosition(), updateEveryFrame(eventPlayer.getEyePosition() + worldVector(-0.65 * Vector.LEFT, eventPlayer, Transform.ROTATION) - (0.33 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + eventPlayer.getFacingDirection() * 16, null, getAllPlayers(), false))
    eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers() if eventPlayer.isFiringPrimaryFire() else null, Beam.MOIRA_COALESCENCE, updateEveryFrame(eventPlayer.getFacingDirection() + eventPlayer.getEyePosition() + worldVector(0.65 * Vector.LEFT, eventPlayer, Transform.ROTATION) - (0.33 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))), raycastHitPosition(eventPlayer.getFacingDirection() + eventPlayer.getEyePosition(), updateEveryFrame(eventPlayer.getEyePosition() + worldVector(0.65 * Vector.LEFT, eventPlayer, Transform.ROTATION) - (0.33 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + eventPlayer.getFacingDirection() * 16, null, getAllPlayers(), false))
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.heroInfo = ["Primary Fire: Flamethrower0Passive: Fireball0Ultimate: Inferno".split(null[0]), ["{0}txC0000000001F92F>".format(__holygrail___), "{0}txC00000000017EF9>".format(__holygrail___), "{0}txC000000000402CD>".format(__holygrail___)], "Dual flamethrowers that light enemies in a short range ablaze.0As long as an enemy is burning, gain an increasing speed boost{0}".format(" and reduced cooldowns.0Burn everyone nearby. The timer pauses as long as at least one enemy is on fire.\nThe closest enemy is{0}".format(" revealed to you.")).split(null[0])]


rule "Set Flamethrower Targets":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    if eventPlayer.ability1Target != (getAllPlayers().filter(lambda player: player.isAlive() and distance(player, eventPlayer) < 16 and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, player)) < 16 and isInLoS(eventPlayer, player) and player != eventPlayer and not player.isDummy())):
        eventPlayer.ability1Target = getAllPlayers().filter(lambda player: player.isAlive() and distance(player, eventPlayer) < 16 and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, player)) < 16 and isInLoS(eventPlayer, player) and player != eventPlayer and not player.isDummy())
    eventPlayer.ability1Target.ballBurn[false] = getTotalTimeElapsed() + 3
    damage(eventPlayer.ability1Target, eventPlayer, 12.5)
    wait(0.25)
    if ruleCondition:
        loop()


rule "Dealt Damage":
    @Event playerDealtDamage
    @Hero wreckingBall
    
    if eventAbility[0]:
        if distance(eventPlayer, victim) < 16:
            victim.ballBurn[false] = getTotalTimeElapsed() + 2
        heal(victim, null, eventDamage)
        return
    if victim.hasStatus(Status.BURNING):
        if eventPlayer.moveSpeed[0] < 250:
            eventPlayer.moveSpeed[false]++
            eventPlayer.ability1Array[false]++
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.05)
        eventPlayer.setAbilityCooldown(Button.CROUCH, eventPlayer.getAbilityCooldown(Button.CROUCH) - 0.05)


rule "Reset Speed if None Burning":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition (getAllPlayers().all(lambda player: not player.hasStatus(Status.BURNING))) == true
    
    eventPlayer.moveSpeed[false] -= eventPlayer.ability1Array[0]
    eventPlayer.ability1Array[false] = null


rule "Ball Burn":
    @Event eachPlayer
    @Condition eventPlayer.ballBurn[0] > getTotalTimeElapsed()
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 99999)
    for i in range(0, 6, true):
        if getAllPlayers()[i].getHero() == Hero.WRECKING_BALL:
            eventPlayer.startDamageOverTime(getAllPlayers()[i], 99999, 25 / getNumberOfHeroes(Hero.WRECKING_BALL, Team.ALL))
            eventPlayer.ballBurn[true] = eventPlayer.ballBurn[true].slice(false, i).concat([getLastDamageOverTimeId()]).concat(eventPlayer.ballBurn[true].slice(i + true, 999999995904))
    waitUntil(eventPlayer.ballBurn[0] <= getTotalTimeElapsed(), 999999995904)
    if eventPlayer.asheBurn[0] <= getTotalTimeElapsed():
        eventPlayer.clearStatusEffect(Status.BURNING)
        for i in range(0, 6, true):
            stopDamageOverTime(eventPlayer.ballBurn[true][i])


rule "Inferno":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.01)
    eventPlayer.setStatusEffect(eventPlayer, Status.BURNING, 9999)
    bigMessage(getAllPlayers(), "{0}: {1}fgd66813FF>Inferno{1}/fg> initiated!".format(heroIcon(Hero.WRECKING_BALL), __holygrail___))
    eventPlayer.isUlting = true
    eventPlayer.ultChase1 = 4
    eventPlayer.moveSpeed[false] += 25
    chaseAtRate(eventPlayer.ultChase1, false, null if getAllPlayers().any(lambda player: player.ballBurn[0] > getTotalTimeElapsed()) else 1)
    createInWorldText(eventPlayer, "{0}txC000000000402CD>: {1}".format(__holygrail___, "{0}".format(eventPlayer.ultChase1).substring(0, 2 + strLen("{0}".format(floor(eventPlayer.ultChase1))))), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.3 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE)
    eventPlayer.ultEffects[false] = getLastCreatedText()
    createEffect(getAllPlayers().exclude(eventPlayer), Effect.ECHO_CLONING, Color.TEAM_2, eventPlayer, true)
    eventPlayer.ultEffects[true] = eventPlayer.ultEffects[true].slice(false, false).concat([getLastCreatedEntity()]).concat(eventPlayer.ultEffects[true].slice(0 + true, 999999995904))
    createEffect(getAllPlayers(), Effect.RING, Color.RED, updateEveryFrame(eventPlayer.getPosition()), 6.2)
    eventPlayer.ultEffects[true] = eventPlayer.ultEffects[true].slice(false, true).concat([getLastCreatedEntity()]).concat(eventPlayer.ultEffects[true].slice(true + true, 999999995904))
    createEffect(getAllPlayers(), Effect.RING, Color.ORANGE, updateEveryFrame(eventPlayer.getPosition()), 6.1)
    eventPlayer.ultEffects[true] = eventPlayer.ultEffects[true].slice(false, 2).concat([getLastCreatedEntity()]).concat(eventPlayer.ultEffects[true].slice(2 + true, 999999995904))
    createEffect(getAllPlayers(), Effect.RING, Color.ORANGE, updateEveryFrame(eventPlayer.getPosition()), 6)
    eventPlayer.ultEffects[true] = eventPlayer.ultEffects[true].slice(false, 3).concat([getLastCreatedEntity()]).concat(eventPlayer.ultEffects[true].slice(3 + true, 999999995904))
    createIcon(eventPlayer if entityExists((sorted(getAllPlayers().filter(lambda player: player != eventPlayer and player.isAlive() and not player.isDummy()), lambda x: distance(x, eventPlayer)))[0]) else null, ((sorted(getAllPlayers().filter(lambda player: player != eventPlayer and player.isAlive() and not player.isDummy()), lambda x: distance(x, eventPlayer)))[0]).getEyePosition(), Icon.EYE, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.ORANGE)
    eventPlayer.ultEffects[2] = getLastCreatedEntity()
    while eventPlayer.ultChase1 and eventPlayer.isAlive():
        playEffect(getAllPlayers(), DynamicEffect.BAPTISTE_BIOTIC_LAUNCHER_EXPLOSION, Color.TEAM_2, eventPlayer, 1)
        playEffect(getAllPlayers(), DynamicEffect.BAPTISTE_BIOTIC_LAUNCHER_EXPLOSION_SOUND, Color.TEAM_2, eventPlayer, 100)
        playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT, Color.TEAM_2, eventPlayer, 1)
        playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, Color.TEAM_2, eventPlayer, 100)
        for i in range(0, 4, true):
            if not eventPlayer.ultChase1 or eventPlayer.isDead():
                break
            (((getPlayersInRadius(eventPlayer, 6, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)).ballBurn)[false] = getTotalTimeElapsed() + 3
            damage((getPlayersInRadius(eventPlayer, 6, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer), eventPlayer, 25)
            ((getPlayersInRadius(eventPlayer, 6, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)).startDamageOverTime(eventPlayer, 0.25, 75)
            wait(0.25)
    destroyInWorldText(eventPlayer.ultEffects[0])
    destroyEffect(eventPlayer.ultEffects[true])
    destroyIcon(eventPlayer.ultEffects[2])
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.moveSpeed[false] -= 25
    eventPlayer.isUlting = false
    stopChasing(eventPlayer.ultChase1)


rule "--- ZARYA ---":
    @Delimiter
    


rule "Zarya Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ZARYA
    
    eventPlayer.hasTargetAbility[false] = true
    eventPlayer.hasTargetAbility[true] = 150
    eventPlayer.startScalingSize(0.86)
    eventPlayer.startScalingBarriers(1.3)
    eventPlayer.setMaxHealth(57.14)
    eventPlayer.addHealthPool(Health.SHIELDS, 46.428, true)
    eventPlayer.ability1Chase = null
    eventPlayer.ability2Chase = null
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC00000000002698>: {1}".format(__holygrail___, "ready" if eventPlayer.ability1Array[0] < getTotalTimeElapsed() + true else ("{0}".format(max(false, eventPlayer.ability1Array[0] - getTotalTimeElapsed() - true))).substring(0, 2 + (strLen("{0}".format(floor(max(false, eventPlayer.ability1Array[0] - getTotalTimeElapsed() - true))))))), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(231, 130, 184))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC0000000000E613>: {1}".format(__holygrail___, "ready" if eventPlayer.ability2Array[2] < getTotalTimeElapsed() + true else ("{0}".format(max(false, eventPlayer.ability2Array[2] - getTotalTimeElapsed() - true))).substring(0, 2 + (strLen("{0}".format(floor(max(false, eventPlayer.ability2Array[2] - getTotalTimeElapsed() - true))))))), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.05 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(16, 99, 224))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive: Enhanced Targeting0Ability 2: Cable Row0Melee: Extracted Instability".split(null[0]), ["{0}txC00000000049433>".format(__holygrail___), "{0}txC00000000002698>".format(__holygrail___), "{0}txC0000000000E613>".format(__holygrail___)], "While any ability is active, Particle Cannon's primary fire produces\nan additional beam that locks onto enemies but deals red{0}".format("uced damage.0Use ability 2 on an enemy to pull yourself towards them.\nHold jump afterward to glide.0Meleeing an enemy creates{0}".format(" an unstable vortex that accelerates their movement and damages them.")).split(null[0])]


rule "Death Grip":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition entityExists(eventPlayer.targetAbility) == true
    @Condition eventPlayer.ability1Array[0] < getTotalTimeElapsed()
    
    eventPlayer.ability1Target = eventPlayer.targetAbility
    eventPlayer.ability1Chase = eventPlayer.getPosition()
    chaseOverTime(eventPlayer.ability1Chase, eventPlayer.ability1Target.getPosition(), min(distance(eventPlayer, eventPlayer.ability1Target) / 30, 2))
    #eventPlayer.hasTargetAbility[0] = false
    createBeam(getAllPlayers(), Beam.WINSTON_TESLA_CANNON, eventPlayer, eventPlayer.ability1Target)
    eventPlayer.ability1Array[true] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ROSE, eventPlayer.ability1Target, 3)
    eventPlayer.ability1Array[2] = getLastCreatedEntity()
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.startForcingPosition(eventPlayer.ability1Chase)
    waitUntil(distance(eventPlayer, eventPlayer.ability1Target) < 2.5 or [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any(), 999999995904)
    destroyEffect(eventPlayer.ability1Array[true])
    destroyEffect(eventPlayer.ability1Array[2])
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.stopForcingPosition()
    stopChasing(eventPlayer.ability1Chase)
    eventPlayer.ability1Chase = null
    eventPlayer.ability1Array[false] = getTotalTimeElapsed() + 4
    eventPlayer.startHealingOverTime(eventPlayer, 3, 16.67)
    eventPlayer.canGlide = [true, [Button.JUMP, Button.PRIMARY_FIRE], 0.5, 30]
    wait(4)
    eventPlayer.canGlide[false] = false


rule "Melee":
    @Event playerDealtDamage
    @Hero zarya
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.ability2Array[2] < getTotalTimeElapsed()
    
    eventPlayer.ability2Array[false] = victim.getPosition() + 0.75 * vectorTowards(victim.getPosition(), victim.getEyePosition())
    eventPlayer.ability2Chase = null
    chaseAtRate(eventPlayer.ability2Chase, 0.25, 0.25 - eventPlayer.ability2Chase)
    victim.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD)
    createProjectileEffect(getAllPlayers(), Projectile.ZARYA_GRAVITON, getAllPlayers(), eventPlayer.ability2Array[0], null, eventPlayer.ability2Chase)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, eventPlayer.ability2Array[0], 32 * eventPlayer.ability2Chase)
    eventPlayer.effects[true] = getLastCreatedEntity()
    while eventPlayer.ability2Chase < 0.245:
        eventPlayer.ability2Array[true] = (getPlayersInRadius(eventPlayer.ability2Array[0], 32 * eventPlayer.ability2Chase, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)
        eventPlayer.ability2Array[true].setEnvironmentalKillCreditor(eventPlayer)
        for i in range(0, len(eventPlayer.ability2Array[true]), true):
            if distance(eventPlayer.ability2Array[true][i], eventPlayer.ability2Array[0]) > 0.5:
                eventPlayer.ability2Array[true][i].applyImpulse(directionTowards(eventPlayer.ability2Array[true][i], eventPlayer.ability2Array[0]), 0.85 * distance(eventPlayer.ability2Array[true][i], eventPlayer.ability2Array[0]), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                damage(eventPlayer.ability2Array[true][i], eventPlayer, eventPlayer.ability2Array[true][i].getMaxHealth() * 0.05 * 0.016)
        wait(false)
    eventPlayer.ability2Array[2] = getTotalTimeElapsed() + 10
    stopChasing(eventPlayer.ability2Chase)
    eventPlayer.ability2Chase = null
    destroyEffect(eventPlayer.effects)


rule "Autolock":
    @Event eachPlayer
    @Hero zarya
    @Condition (eventPlayer.canGlide[0] or eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1() or eventPlayer.ability2Chase) == true
    
    createBeam(eventPlayer if eventPlayer.isFiringPrimaryFire() and entityExists(eventPlayer.targetAbility) and distance(eventPlayer, eventPlayer.targetAbility) < 15 else null, Beam.ZARYA_PARTICLE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) * 0.24 + normalize(crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * 0.22, eventPlayer.targetAbility, Color.TEAM_1)
    eventPlayer.ability2Array[3] = getLastCreatedEntity()
    createBeam(getAllPlayers().exclude(eventPlayer) if eventPlayer.isFiringPrimaryFire() and entityExists(eventPlayer.targetAbility) and distance(eventPlayer, eventPlayer.targetAbility) < 15 else null, Beam.ZARYA_PARTICLE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) * 0.24 + normalize(crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * 0.22, eventPlayer.targetAbility, Color.TEAM_2)
    eventPlayer.ability2Array[4] = getLastCreatedEntity()
    while (eventPlayer.canGlide[0] or eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1() or eventPlayer.ability2Chase) and distance(eventPlayer, eventPlayer.targetAbility) < 15:
        if eventPlayer.isFiringPrimaryFire():
            damage(eventPlayer.targetAbility, eventPlayer, 2.85)
        wait(0.1)
    destroyEffect(eventPlayer.ability2Array[3])
    destroyEffect(eventPlayer.ability2Array[4])


rule "--- ASHE ---":
    @Delimiter
    


rule "Ashe Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ASHE
    
    eventPlayer.hasTargetAbility[false] = true
    eventPlayer.hasTargetAbility[true] = 30
    eventPlayer.ability2Array[false] = null
    eventPlayer.ability2Array[true] = null
    eventPlayer.ability2Array[2] = null
    eventPlayer.scale = null
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC00000000004122>: +{1}%".format(__holygrail___, eventPlayer.ability2Array[2]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.5 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(105, 105, 105))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    startDamageModification(getAllPlayers(), eventPlayer, 100 + eventPlayer.ability2Array[2])
    eventPlayer.damageMods.append(getLastDamageModification())
    eventPlayer.heroInfo = ["Passive: The Adder0Ability 2: Ball & Chain0Ultimate: Wall of Ash".split(null[0]), ["{0}txC00000000004122>".format(__holygrail___), "{0}txC0000000002D71E>".format(__holygrail___), "{0}txC00000000004E6B>".format(__holygrail___)], "Landing scoped shots with the viper\nincreases your damage by 2%, or 5% against airborne targets.\nMissing two shots in a row r{0}".format("esets this bonus.0Tether an enemy to a chain, pinning them to the ground \nand restricting their movement.0Erect a giant wall {0}".format("of fire that burns any enemy inside it.")).split(null[0])]


rule "On Shot / Death":
    @Event eachPlayer
    @Hero ashe
    @Condition (eventPlayer.isFiringPrimaryFire() and eventPlayer.isFiringSecondaryFire() or eventPlayer.isDead()) == true
    
    if eventPlayer.isDead():
        eventPlayer.ability2Array[false] = null
        eventPlayer.ability2Array[true] = null
        eventPlayer.ability2Array[2] = null
        return
    eventPlayer.ability2Array[false]++
    if eventPlayer.ability2Array[0] == eventPlayer.ability2Array[true] + 2:
        if eventPlayer.ability1Array[2] > null:
            smallMessage(eventPlayer, "{0}: Damn..".format(heroIcon(Hero.ASHE)))
        eventPlayer.ability2Array[false] = null
        eventPlayer.ability2Array[true] = null
        eventPlayer.ability2Array[2] = null


rule "On Hit":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.ability2Array[true]++
    eventPlayer.ability2Array[2] += 5 if victim.isInAir() else 2
    wait(false)
    if eventPlayer.ability2Array[0] > eventPlayer.ability2Array[true]:
        eventPlayer.ability2Array[true]++


rule "Ball & Chain":
    @Event eachPlayer
    @Hero ashe
    @Condition entityExists(eventPlayer.targetAbility) == true
    @Condition eventPlayer.targetAbility.isChained == false
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    
    eventPlayer.ability1Target = eventPlayer.targetAbility
    eventPlayer.hasTargetAbility[false] = false
    eventPlayer.ability1Array[false] = raycastHitPosition(eventPlayer.ability1Target.getPosition() + Vector.UP, eventPlayer.ability1Target.getPosition() + -1000 * Vector.UP, null, getAllPlayers(), false)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, eventPlayer.ability1Array[0], 0.3)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.RING, Color.BLACK, eventPlayer.ability1Array[0], 3)
    eventPlayer.effects[true] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.JUNKRAT_TRAP_CHAIN, eventPlayer.ability1Array[0], eventPlayer.ability1Target.getPosition())
    eventPlayer.effects[2] = getLastCreatedEntity()
    eventPlayer.ability1Chase = 4
    chaseAtRate(eventPlayer.ability1Chase, false, true)
    bigMessage([eventPlayer, eventPlayer.ability1Target], "Chained!")
    while eventPlayer.ability1Chase > null:
        waitUntil(distance(eventPlayer.ability1Target, eventPlayer.ability1Array[0]) >= 3 or eventPlayer.ability1Chase == null, 999999995904)
        eventPlayer.ability1Target.setEnvironmentalKillCreditor(eventPlayer)
        eventPlayer.ability1Target.startForcingThrottle(false, 0.3, false, 0.3, false, 0.3)
        eventPlayer.ability1Target.startAcceleration(directionTowards(eventPlayer.ability1Target, eventPlayer.ability1Array[0]), 50, 7 * distance(eventPlayer.ability1Target, eventPlayer.ability1Array[0]), Relativity.TO_WORLD)
        eventPlayer.ability1Target.isChained = true
        eventPlayer.ability1Target.moveSpeed[false] -= 40
        waitUntil(distance(eventPlayer.ability1Target, eventPlayer.ability1Array[0]) < 3 or eventPlayer.ability1Chase == null, 999999995904)
        eventPlayer.ability1Target.isChained = false
        eventPlayer.ability1Target.stopForcingThrottle()
        eventPlayer.ability1Target.stopAcceleration()
        eventPlayer.ability1Target.moveSpeed[false] += 40
        wait(false)
    destroyEffect(eventPlayer.effects[0])
    destroyEffect(eventPlayer.effects[true])
    destroyEffect(eventPlayer.effects[2])
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    waitUntil(not eventPlayer.getAbilityCooldown(Button.ABILITY_2), 999999995904)
    eventPlayer.hasTargetAbility[false] = true


rule "Wall of Ash":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.isUlting = true
    bigMessage(getAllPlayers(), "{0}: Watch 'em {1}fgd66813FF>Burn!{1}/fg>".format(heroIcon(Hero.ASHE), __holygrail___))
    eventPlayer.ultChase1 = null
    eventPlayer.ultArray = [eventPlayer.getPosition(), [eventPlayer.getPosition()]]
    destroyEffect(eventPlayer.ultEffects[0])
    eventPlayer.ultEffects[false] = []
    eventPlayer.setAimSpeed(70)
    eventPlayer.moveSpeed[false] -= 50
    if eventPlayer.ability1Chase:
        eventPlayer.ability1Chase += 4
    for eventPlayer.i in range(0, 20, true):
        eventPlayer.ultArray[true].append(raycastHitPosition(eventPlayer.ultArray[0], eventPlayer.ultArray[0] + -15 * Vector.UP, null, getAllPlayers(), false))
        eventPlayer.ultArray[false] += worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION) * 1.5
        createBeam(getAllPlayers(), Beam.MOIRA_COALESCENCE, evalOnce(eventPlayer.ultArray[true].last()), evalOnce(eventPlayer.ultArray[true].last()) + (Vector.UP * (eventPlayer.ultChase1 / 20 * (evalOnce(eventPlayer.ultArray[true][0].y - eventPlayer.ultArray[true].last().y)) + eventPlayer.ultChase1)))
        eventPlayer.ultEffects[false].append(getLastCreatedEntity())
        playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT, null, eventPlayer.ultArray[true].last(), 1)
        playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, null, eventPlayer.ultArray[true].last(), 50)
        wait(0.025)
    eventPlayer.setAimSpeed(100)
    eventPlayer.moveSpeed[false] += 50
    chaseOverTime(eventPlayer.ultChase1, 20, 0.75)
    wait(0.5)
    eventPlayer.ultChase1 = 20
    stopChasing(eventPlayer.ultChase1)
    eventPlayer.scale = 1
    chaseOverTime(eventPlayer.scale, false, 8)
    createProgressBarInWorldText(eventPlayer, eventPlayer.scale * 100, "Wall of Ash", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, rgb(72 * (true - eventPlayer.scale) + 178, 184 * (true - eventPlayer.scale) + 34, 60 * (true - eventPlayer.scale) + 4))
    eventPlayer.ultEffects[true] = getLastCreatedText()
    waitUntil(eventPlayer.scale == null, 8)
    stopChasing(eventPlayer.scale)
    destroyProgressBarInWorldText(eventPlayer.ultEffects[true])
    destroyEffect(eventPlayer.ultEffects[0])
    eventPlayer.isUlting = false
    eventPlayer.ultArray = [null, null]


rule "Wall Set Fire":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.scale != false
    
    if not eventPlayer.ultArray[0]:
        return
    for i in range(0, 20, true):
        ((getAllPlayers().filter(lambda player: player != eventPlayer and player.isAlive() and not player.hasStatus(Status.PHASED_OUT) and distance(vect(player.getPosition().x, false, player.getPosition().z), vect(eventPlayer.ultArray[true][i].x, false, eventPlayer.ultArray[true][i].z)) < 3)).asheBurn)[false] = getTotalTimeElapsed() + 1.5
        if not i % 5:
            playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, null, eventPlayer.ultArray[true][i], 50)
    wait(0.2)
    if ruleCondition:
        loop()


rule "Ashe Burn":
    @Event eachPlayer
    @Condition eventPlayer.asheBurn[0] > getTotalTimeElapsed()
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 99999)
    for i in range(0, 6, true):
        if getAllPlayers()[i].getHero() == Hero.ASHE:
            eventPlayer.startDamageOverTime(getAllPlayers()[i], 99999, 135 / getNumberOfHeroes(Hero.ASHE, Team.ALL))
            eventPlayer.asheBurn[true] = eventPlayer.asheBurn[true].slice(false, i).concat([getLastDamageOverTimeId()]).concat(eventPlayer.asheBurn[true].slice(i + true, 999999995904))
    waitUntil(eventPlayer.asheBurn[0] <= getTotalTimeElapsed(), 999999995904)
    if eventPlayer.ballBurn[0] <= getTotalTimeElapsed():
        eventPlayer.clearStatusEffect(Status.BURNING)
        for i in range(0, 6, true):
            stopDamageOverTime(eventPlayer.asheBurn[true][i])


rule "--- BASTION ---":
    @Delimiter
    


rule "Bastion Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.BASTION
    
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, updateEveryFrame(eventPlayer.ability1Chase), 0.25)
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.ability1Array[2] = "^v^"
    createInWorldText(getAllPlayers(), eventPlayer.ability1Array[2], updateEveryFrame(eventPlayer.ability1Chase), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.ability1Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability1Chase, eventPlayer.getEyePosition() + (vect(3.5 * (cosDeg(125 * getTotalTimeElapsed())), 0.75 + 0.8 * (sinDeg(125 * getTotalTimeElapsed())), 3.5 * (sinDeg(125 * getTotalTimeElapsed())))), 999999995904)
    eventPlayer.setMaxHealth(75)
    eventPlayer.addHealthPool(Health.NORMAL, 12.45, true)
    eventPlayer.heroInfo = ["Passive 1: Penetrative Rounds0Passive 2: Best Buds0Ability 1: Helicopter".split(null[0]), ["{0}txC0000000001BD59>".format(__holygrail___), "{0}txC00000000028FCC>".format(__holygrail___), "{0}txC00000000033256>".format(__holygrail___)], "In recon mode, your last 10 bullets explode on impact.\uec51Your bird friend, Ganymede, flies around you and damages any enemy who{0}".format(" attacks you.\nWalking to ganymede makes him come back to you early.\uec51Gain limited flight while in sentry mode.").split("\uec51")]


rule "Ganymede":
    @Event playerTookDamage
    @Hero bastion
    @Condition attacker != eventPlayer
    
    eventPlayer.ability1Array[2] = ">v<"
    stopChasing(eventPlayer.ability1Chase)
    chaseOverTime(eventPlayer.ability1Chase, attacker.getEyePosition(), 0.75)
    wait(0.75)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, Color.TEAM_1, eventPlayer.ability1Chase, 1)
    damage(attacker, eventPlayer, 50)
    attacker.setStatusEffect(eventPlayer, Status.STUNNED, 0.65)
    smallMessage(attacker, "Ganymede attacked you!")
    smallMessage(eventPlayer, "Ganymede attacked {0}!".format(attacker))
    stopChasing(eventPlayer.ability1Chase)
    chaseOverTime(eventPlayer.ability1Chase, eventPlayer.ability1Chase + vect(random.uniform(-1.5, 1.5), random.uniform(-1.2, -0.5), random.uniform(-1.5, 1.5)), 0.5, ChaseTimeReeval.NONE)
    wait(0.5)
    stopChasing(eventPlayer.ability1Chase)
    chaseAtRate(eventPlayer.ability1Chase, eventPlayer.ability1Chase + (Vector.UP if sin(2 * getTotalTimeElapsed()) <= null else Vector.DOWN), 0.5)
    waitUntil(eventPlayer.isDead() or distance(eventPlayer.getPosition(), eventPlayer.ability1Chase) < 3, 11.5)
    if eventPlayer.isAlive():
        smallMessage(eventPlayer, "{0}: Beep Boop! (Ganymede, come back!)".format(heroIcon(Hero.BASTION)))
        eventPlayer.communicate(Comms.VOICE_LINE_UP)
    eventPlayer.ability1Array[2] = "ovo"
    stopChasing(eventPlayer.ability1Chase)
    chaseOverTime(eventPlayer.ability1Chase, updateEveryFrame(eventPlayer.getEyePosition() + (vect(3.5 * (cosDeg(125 * getTotalTimeElapsed())), 0.75 + 0.8 * (sinDeg(125 * getTotalTimeElapsed())), 3.5 * (sinDeg(125 * getTotalTimeElapsed()))))), 1.25)
    wait(1.25)
    eventPlayer.ability1Array[2] = "^v^"
    stopChasing(eventPlayer.ability1Chase)
    chaseAtRate(eventPlayer.ability1Chase, updateEveryFrame(eventPlayer.getEyePosition() + (vect(3.5 * (cosDeg(125 * getTotalTimeElapsed())), 0.75 + 0.8 * (sinDeg(125 * getTotalTimeElapsed())), 3.5 * (sinDeg(125 * getTotalTimeElapsed()))))), 999999995904)


rule "Penetrative Rounds":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.getAmmo(false) < 10
    
    eventPlayer.ability1Array[false] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 102, getAllPlayers(), eventPlayer, true)
    playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION, Color.TEAM_1, eventPlayer.ability1Array[0], 1)
    playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION_SOUND, Color.TEAM_1, eventPlayer.ability1Array[0], 1)
    eventPlayer.ability1Array[true] = getPlayersInRadius(eventPlayer.ability1Array[0], 3, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())
    for i in range(0, len(eventPlayer.ability1Array[true]), true):
        damage(eventPlayer.ability1Array[true][i], eventPlayer, 15)
        eventPlayer.ability1Array[true][i].applyImpulse(directionTowards(eventPlayer.ability1Array[0], eventPlayer.ability1Array[true][i].getPosition()), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
        loop()


rule "Helicopter VFX":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(true)
    eventPlayer.moveSpeed[false] += 50
    eventPlayer.scale = 1
    eventPlayer.ability2Chase = 100
    eventPlayer.setJumpVerticalSpeed(0)
    createBeam(getAllPlayers(), Beam.GRAPPLE, updateEveryFrame(eventPlayer.getEyePosition() + (vect(1.5 * (cosDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed())), 0.6, 1.5 * (sinDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed()))))), updateEveryFrame(eventPlayer.getEyePosition() + (vect(1.5 * (cosDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 180)), 0.6, 1.5 * (sinDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 180))))))
    eventPlayer.effects[true] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.GRAPPLE, updateEveryFrame(eventPlayer.getEyePosition() + (vect(1.5 * (cosDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 90)), 0.6, 1.5 * (sinDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 90))))), updateEveryFrame(eventPlayer.getEyePosition() + (vect(1.5 * (cosDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 270)), 0.6, 1.5 * (sinDeg(((eventPlayer.getVerticalSpeed() + true) * 1200) * getTotalTimeElapsed() + 270))))))
    eventPlayer.effects[2] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.BRIGITTE_FLAIL_CHAIN, updateEveryFrame(eventPlayer.getEyePosition()), updateEveryFrame(eventPlayer.getEyePosition()) + 0.6 * Vector.UP)
    eventPlayer.effects[3] = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Helicopter Fuel: {0}%".format(round(eventPlayer.ability2Chase)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.42 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(-294 * eventPlayer.scale + 384, -110 * eventPlayer.scale + 267, 8 * eventPlayer.scale + 60) if eventPlayer.scale > 0.5 else rgb(2 * eventPlayer.scale + 235, 296 * eventPlayer.scale + 64, 24 * eventPlayer.scale + 52))
    eventPlayer.inWorldTexts[true] = getLastCreatedText()
    createInWorldText(eventPlayer, "\n{0}".format("□□□□□0■□□□□0■■□□□0■■■□□0■■■■□0■■■■■".split(null[0])[ceil(eventPlayer.scale * 5)]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.5 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(-294 * eventPlayer.scale + 384, -110 * eventPlayer.scale + 267, 8 * eventPlayer.scale + 60) if eventPlayer.scale > 0.5 else rgb(2 * eventPlayer.scale + 235, 296 * eventPlayer.scale + 64, 24 * eventPlayer.scale + 52))
    eventPlayer.inWorldTexts[2] = getLastCreatedText()
    waitUntil(not eventPlayer.isUsingAbility1(), 5.5)
    eventPlayer.moveSpeed[false] -= 50
    eventPlayer.setJumpVerticalSpeed(100)
    destroyEffect(eventPlayer.effects[true])
    destroyEffect(eventPlayer.effects[2])
    destroyEffect(eventPlayer.effects[3])
    destroyInWorldText(eventPlayer.inWorldTexts[true])
    destroyInWorldText(eventPlayer.inWorldTexts[2])


rule "Helicopter Flight":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    @Condition eventPlayer.ability2Chase > null
    
    eventPlayer.setGravity(false)
    eventPlayer.startAcceleration(Vector.UP, 6, 3, Relativity.TO_WORLD)
    chaseAtRate(eventPlayer.scale, false, 0.25)
    chaseAtRate(eventPlayer.ability2Chase, false, 25)
    waitUntil(not ((eventPlayer.isUsingAbility1() and (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))) and eventPlayer.ability2Chase > null), 999999995904)
    eventPlayer.setGravity(100)
    eventPlayer.stopAcceleration()
    stopChasing(eventPlayer.scale)
    stopChasing(eventPlayer.ability2Chase)


rule "--- CASSIDY ---":
    @Delimiter
    


rule "Initialize Cassidy Shop":
    #Button Positions
    cassShop[false] = "\u0019!\u00120\r!\u00120\u0001!\u00120\u0019!\u000b0\r!\u000b0\u0001!\u000b0\u0019!\u00050\u0001!\u00050\r!\u0005".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(x.last().strIndex(x[0].charAt(0)), x.last().strIndex(x[0].charAt(2)), x.last().strIndex(x[0].charAt(1))) - vect(12, 12, 12))
    #Item Names
    cassShop[2] = "Damage Dealt0Max Health0Move Speed0Cooldown Reduction0Min. Ult Charge (Permanent)0Gold Production (Permanent)".split(null[0])
    #Item Prefixes
    cassShop[3] = "+0+0+0-00+".split(null[0])
    #Item Suffixes
    cassShop[4] = "%00%0s0%0%".split(null[0])
    cassShop[5] = mapData[3][mapData[0].index(__getCurrentMap__())]


rule "Create Shop Text":
    for i in range(0, 3, true):
        createEffect(localPlayer if localPlayer.inCassShop else null, Effect.SPHERE, Color.BLACK, cassShop[5], 0.2)
    for i in range(0, 6, true):
        #Black square
        createInWorldText(localPlayer if localPlayer.inCassShop else null, "{0}TX C0000000000000B>".format(__holygrail___), cassShop[5] + cassShop[0][evalOnce(i)], 4)
        #Stat
        createInWorldText(localPlayer if localPlayer.inCassShop else null, "{0}{1}{2}".format(cassShop[3][evalOnce(i)], localPlayer.ability1Array[0][evalOnce(i) + true], cassShop[4][evalOnce(i)]), 0.2 * Vector.UP + cassShop[5] + cassShop[0][evalOnce(i)], 2)
        createInWorldText(localPlayer if localPlayer.inCassShop else null, cassShop[2][evalOnce(i)], 1.7 * Vector.UP + cassShop[5] + cassShop[0][evalOnce(i)], 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.LIME_GREEN if localPlayer.cassShopCanSelect and localPlayer.cassShopToSelect == evalOnce(i) else Color.WHITE)
        createInWorldText(localPlayer if localPlayer.inCassShop else null, "Cost: ${0}".format(localPlayer.ability1Array[true][evalOnce(i)]), -1.4 * Vector.UP + cassShop[5] + cassShop[0][evalOnce(i)], 1.7, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.LIME_GREEN if localPlayer.cassShopCanSelect and localPlayer.cassShopToSelect == evalOnce(i) else Color.WHITE)
    createInWorldText(localPlayer if localPlayer.inCassShop else null, "Gold: ${0}".format(localPlayer.ability1Array[0][0]), cassShop[5] + cassShop[0][6], 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(235, 180, 52))
    createInWorldText(localPlayer if localPlayer.inCassShop else null, "{0}txC0000000001F943> Sell all".format(__holygrail___), cassShop[5] + cassShop[0][8], 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE if localPlayer.cassShopCanSelect and localPlayer.cassShopToSelect == 8 else Color.SKY_BLUE)
    createInWorldText(localPlayer if localPlayer.inCassShop else null, "Exit", cassShop[5] + cassShop[0][7], 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.RED)
    #Cursor
    createInWorldText(localPlayer if localPlayer.inCassShop else null, "{0}txc0000000002dd21>".format(__holygrail___), updateEveryFrame(cassShop[5] + localPlayer.getFacingDirection()), 2.2)


rule "Cassidy Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.CASSIDY
    
    eventPlayer.ability1Array[false] = [eventPlayer.ability1Array[0][0], null, null, null, null, eventPlayer.ability1Array[0][5], eventPlayer.ability1Array[0][6], null]
    #Shop prices
    eventPlayer.ability1Array[true] = [150, 50, 100, 100, 150, 150]
    #Inflation rates
    eventPlayer.ability1Array[2] = [30, 15, 25, 15, 25, 50]
    createInWorldText(eventPlayer if eventPlayer.isAlive() and not eventPlayer.inCassShop else null, "Gold: ${0}".format(floor(eventPlayer.ability1Array[0][0])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(235, 180, 52))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    startDamageModification(getAllPlayers(), eventPlayer, 100 + eventPlayer.ability1Array[0][true])
    eventPlayer.damageMods.append(getLastDamageModification())
    eventPlayer.setMaxHealth((100 * (evalOnce(eventPlayer.getMaxHealth()) - true)) / evalOnce(eventPlayer.getMaxHealth()))
    eventPlayer.addHealthPool(Health.NORMAL, true + eventPlayer.ability1Array[0][2], true)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.heroInfo = ["Passive: Upgrade Shop0Melee: Pickpocket0Ultimate: Gold Rush".split(null[0]), ["{0}txC00000000011E06>".format(__holygrail___), "{0}txC0000000000E613>".format(__holygrail___), "{0}txC0000000003AE1E>".format(__holygrail___)], "Earn Gold by damaging enemies.\nUse the upgrade shop to buy powerups.(1.00, 0.00, 0.00)Quick melee has a 50% chance to steal g{0}".format("old and ammo from the victim(1.00, 0.00, 0.00)Gain increased and automatic gold production for a short time").split(Vector.LEFT[0])]


rule "On Death":
    @Event playerDied
    @Hero cassidy
    
    eventPlayer.moveSpeed[false] -= eventPlayer.ability1Array[0][3]
    eventPlayer.ability1Array[false] = [eventPlayer.ability1Array[0][0], null, null, null, null, eventPlayer.ability1Array[0][5], eventPlayer.ability1Array[0][6], null]
    eventPlayer.ability1Array[true] = [150, 50, 100, 100, eventPlayer.ability1Array[true][4], eventPlayer.ability1Array[true][5]]


def EnterCassShop():
    @Name "Subroutine EnterCassShop"
    
    eventPlayer.inCassShop = true
    eventPlayer.thirdPersonCam = true
    eventPlayer.disableHeroHud()
    eventPlayer.startCamera(cassShop[5], cassShop[5] + Vector.FORWARD)
    eventPlayer.disableHeroHud()
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
    eventPlayer.setFacing(Vector.FORWARD, Relativity.TO_WORLD)
    DisableAbilities()
    smallMessage(getAllPlayers(), "{0} entered the shop".format(eventPlayer))
    while eventPlayer.inCassShop:
        eventPlayer.cassShopCanSelect = cassShop[0].any(lambda x: distance(cassShop[5] + (eventPlayer.getFacingDirection() * (distance(cassShop[5], cassShop[5] + x))), cassShop[5] + x) < 2.2)
        eventPlayer.cassShopToSelect = cassShop[0].index((sorted(cassShop[0], lambda x: distance(cassShop[5] + (eventPlayer.getFacingDirection() * (distance(cassShop[5], cassShop[5] + x))), cassShop[5] + x)))[0])
        if abs(eventPlayer.getVerticalFacingAngle()) > 35:
            eventPlayer.setFacing(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 35 if eventPlayer.getVerticalFacingAngle() > null else -35), Relativity.TO_WORLD)
        wait(0.25)
    eventPlayer.stopCamera()
    eventPlayer.thirdPersonCam = false
    eventPlayer.enableHeroHud()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.setInvisibility(Invis.NONE)
    wait(false)
    EnableAbilties()
    eventPlayer.disallowButton(Button.ULTIMATE)
    smallMessage(eventPlayer, "Enter again in 3s")
    wait(3)


rule "Shop Selection":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.inCassShop != false
    @Condition eventPlayer.cassShopCanSelect != false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    if eventPlayer.ability1Array[true][eventPlayer.cassShopToSelect] == "(Maxed Out)":
        smallMessage(eventPlayer, "Upgrade Maxed out!")
        return
    if eventPlayer.ability1Array[0][0] < eventPlayer.ability1Array[true][eventPlayer.cassShopToSelect]:
        smallMessage(eventPlayer, "Cannot Afford Upgrade")
        return
    #Deduct money from account
    eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] - eventPlayer.ability1Array[true][eventPlayer.cassShopToSelect]])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
    #Increase price by inflation rate
    eventPlayer.ability1Array[true] = (eventPlayer.ability1Array[true].slice(false, eventPlayer.cassShopToSelect).concat([eventPlayer.ability1Array[true][eventPlayer.cassShopToSelect] + eventPlayer.ability1Array[2][eventPlayer.cassShopToSelect]])).concat(eventPlayer.ability1Array[true].slice(eventPlayer.cassShopToSelect + true, 999999995904))
    if true:
        goto loc+[38, null, 2, 5, 11, 16, 21, 26, 28][true + [null, 1, 2, 3, 4, 5, 7, 8].index(eventPlayer.cassShopToSelect)]
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, true).concat([eventPlayer.ability1Array[0][true] + 2.5])).concat(eventPlayer.ability1Array[0].slice(true + true, 999999995904))
    else:
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 2).concat([eventPlayer.ability1Array[0][2] + 5])).concat(eventPlayer.ability1Array[0].slice(2 + true, 999999995904))
        heal(eventPlayer, null, 5)
    else:
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 3).concat([eventPlayer.ability1Array[0][3] + 2.5])).concat(eventPlayer.ability1Array[0].slice(3 + true, 999999995904))
        eventPlayer.moveSpeed[false] += 2.5
        if eventPlayer.ability1Array[0][3] == 65:
            eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].slice(false, 2).concat("(Maxed Out)".split(null[0])).concat(eventPlayer.ability1Array[true].slice(2 + true, 999999995904))
    else:
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 4).concat([eventPlayer.ability1Array[0][4] + 0.25])).concat(eventPlayer.ability1Array[0].slice(4 + true, 999999995904))
        if eventPlayer.ability1Array[0][4] == 12:
            eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].slice(false, 3).concat("(Maxed Out)".split(null[0])).concat(eventPlayer.ability1Array[true].slice(3 + true, 999999995904))
    else:
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 5).concat([eventPlayer.ability1Array[0][5] + true])).concat(eventPlayer.ability1Array[0].slice(5 + true, 999999995904))
        if eventPlayer.ability1Array[0][5] == 50:
            eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].slice(false, 4).concat("(Maxed Out)".split(null[0])).concat(eventPlayer.ability1Array[true].slice(4 + true, 999999995904))
    else:
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 6).concat([eventPlayer.ability1Array[0][6] + true])).concat(eventPlayer.ability1Array[0].slice(6 + true, 999999995904))
        if eventPlayer.ability1Array[0][6] == 100:
            eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].slice(false, 5).concat("(Maxed Out)".split(null[0])).concat(eventPlayer.ability1Array[true].slice(5 + true, 999999995904))
    else:
        eventPlayer.inCassShop = false
    else:
        smallMessage(eventPlayer, "All purchases sold")
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][true] / 6 * (150 + eventPlayer.ability1Array[true][0] - eventPlayer.ability1Array[2][0]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][2] / 10 * (50 + eventPlayer.ability1Array[true][true] - eventPlayer.ability1Array[2][true]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][3] / 10 * (100 + eventPlayer.ability1Array[true][2] - eventPlayer.ability1Array[2][2]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][4] / 0.5 * (100 + eventPlayer.ability1Array[true][3] - eventPlayer.ability1Array[2][3]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][5] / 2 * (200 + eventPlayer.ability1Array[true][4] - eventPlayer.ability1Array[2][4]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (eventPlayer.ability1Array[0][6] / 2 * (200 + eventPlayer.ability1Array[true][5] - eventPlayer.ability1Array[2][5]))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[true] = [150, 50, 100, 100, 200, 200]
        eventPlayer.moveSpeed[false] -= eventPlayer.ability1Array[0][3]
        eventPlayer.ability1Array[false] = [eventPlayer.ability1Array[0][0], null, null, null, null, null, null, null]
    wait(0.25)
    __loopIfConditionIsTrue__()
    #pass
    pass #return
    #pass
    pass #return


rule "Tri\zgger Shop Enter":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, mapData[2][mapData[0].index(__getCurrentMap__())]) < 2
    
    EnterCassShop()


rule "Generate Gold + Pickpocket":
    @Event playerDealtDamage
    @Hero cassidy
    
    if victim.isDead():
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (round((200 * (3 if eventPlayer.isUlting else 1)) * (true + eventPlayer.ability1Array[0][6] / 100)))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (round((50 * eventPlayer.ability1Array[0][7] * (3 if eventPlayer.isUlting else 1)) * (true + eventPlayer.ability1Array[0][6] / 100)))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, 7).concat([eventPlayer.ability1Array[0][7] + true])).concat(eventPlayer.ability1Array[0].slice(7 + true, 999999995904))
    eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + ((eventDamage * (true + eventPlayer.ability1Array[0][6] / 100)) * (2 if eventPlayer.isUlting else 1))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
    #pickpocket
    eventPlayer.ability1Array[3] = random.randint(false, true)
    if eventAbility == Button.MELEE and eventPlayer.ability1Array[3]:
        damage(victim, eventPlayer, eventDamage)
        eventPlayer.setAmmo(false, 12)
        victim.setAmmo(false, false)
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (150 * (3 if eventPlayer.isUlting else 1))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, Color.TEAM_1, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 1)
        if victim.getHero() == Hero.CASSIDY:
            victim.ability1Array[false] = (victim.ability1Array[0].slice(false, false).concat([victim.ability1Array[0][0] - (150 * (3 if eventPlayer.isUlting else 1))])).concat(victim.ability1Array[0].slice(0 + true, 999999995904))
    eventPlayer.ability1Array[false] = eventPlayer.ability1Array[0].slice(false, false).concat([round(eventPlayer.ability1Array[0][0])]).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))


rule "Cooldown Reduction":
    @Event eachPlayer
    @Hero cassidy
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 5.9 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 11.9) == true
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 5.9:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - eventPlayer.ability1Array[0][4])
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 5.9:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - eventPlayer.ability1Array[0][4])


rule "Min. Ult Charge":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.getUltCharge() < eventPlayer.ability1Array[0][5]
    @Condition eventPlayer.isUlting == false
    
    eventPlayer.setUltCharge(eventPlayer.ability1Array[0][5])
    wait(0.1)
    if ruleCondition:
        loop()


rule "Gold Rush":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.isUlting = true
    eventPlayer.ultChase1 = 100
    chaseOverTime(eventPlayer.ultChase1, false, 12.5)
    eventPlayer.setUltCharge(false)
    bigMessage(getAllPlayers(), "{0}: {1}fgEBB434FF>Eureka!{1}/fg>".format(heroIcon(Hero.CASSIDY), __holygrail___))
    createProgressBarInWorldText(eventPlayer if eventPlayer.isAlive() and not eventPlayer.inCassShop else null, eventPlayer.ultChase1, "Gold Rush", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, rgb(235, 180, 52))
    eventPlayer.ultEffects[false] = getLastCreatedText()
    while eventPlayer.ultChase1 > null and eventPlayer.isAlive():
        eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (30 * (true + eventPlayer.ability1Array[0][6] / 100))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
        playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.TEAM_1, eventPlayer, 1)
        wait(0.25)
    eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, false).concat([eventPlayer.ability1Array[0][0] + (30 * (true + eventPlayer.ability1Array[0][6] / 100))])).concat(eventPlayer.ability1Array[0].slice(0 + true, 999999995904))
    eventPlayer.isUlting = false
    stopChasing(eventPlayer.ultChase1)
    destroyProgressBarInWorldText(eventPlayer.ultEffects[0])


rule "--- ECHO ---":
    @Delimiter
    


rule "Echo Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ECHO
    
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.ability1Array = [1, false]
    createEffect(getAllPlayers() if eventPlayer.isUlting or eventPlayer.isAlive() and not eventPlayer.ability1Array[0] % 2 else null, Effect.ECHO_CLONING, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers() if eventPlayer.isAlive() and not eventPlayer.ability1Array[0] % 2 else null, Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[true] = getLastCreatedEntity()
    startDamageModification(eventPlayer, getAllPlayers(), 100 if eventPlayer.ability1Array[0] % 2 else 0.001)
    eventPlayer.damageMods.append(getLastDamageModification())
    eventPlayer.heroInfo = ["Primary Fire: Trientatetrashot0Ability 1: Photodisplacement0Ultimate: Photic Splicing".split(null[0]), ["{0}txC00000000028FCD>".format(__holygrail___), "{0}txC0000000001E2D9>".format(__holygrail___), "{0}txC00000000028FCB>".format(__holygrail___)], "Every third shot fires a fourth projectile that explodes.0During flight, become holographic,\nonly taking damage from every ot{0}".format("her instance.0Gain a clone beside you that mirrors your actions.\nReactivate to swap positions with it.").split(null[0])]


rule "Tetra-Shot":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.getAmmo(false) % 3 == false
    
    createProjectile(Projectile.ECHO_STICKY_BOMB, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, 25, 1, 2, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, 0, 75, 2)


rule "Photodisplacement Initiation":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.ability1Array[true] = true
    eventPlayer.ability1Array[false] = null
    waitUntil(eventPlayer.isDead() or not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.ability1Array[true] = false
    eventPlayer.ability1Array[false] = 1


rule "Photodisplacement Effect":
    @Event playerTookDamage
    @Hero echo
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.ability1Array[true] != false
    
    if not eventPlayer.ability1Array[0] % 2:
        heal(eventPlayer, null, eventDamage)
    eventPlayer.ability1Array[false]++
    if eventPlayer.isDead():
        eventPlayer.ability1Array[false] = null


rule "Photic Splicing":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isUlting == false
    
    bigMessage(getAllPlayers(), "{0}: {1}fg55b3edFF>Photic Splicing{1}/fg> complete!".format(heroIcon(Hero.WRECKING_BALL), __holygrail___))
    eventPlayer.isUlting = true
    eventPlayer.ultArray[false] = -2
    eventPlayer.ultArray[true] = false
    eventPlayer.ultChase1 = 100
    chaseOverTime(eventPlayer.ultChase1, false, 30)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, false)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, false)
    eventPlayer.setAmmo(false, 12)
    createProgressBarInWorldText(eventPlayer, eventPlayer.ultChase1, "PHOTIC SPLICING", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, Color.SKY_BLUE)
    eventPlayer.iwtProgressBars[false] = getLastCreatedText()
    CreateMimic()
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - 3 * eventPlayer.getFacingDirection() + worldVector(0.25 * Vector.LEFT * eventPlayer.ultArray[0], eventPlayer, Transform.ROTATION), null, getAllPlayers(), false)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 70))
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, localPlayer.getTeam(), eventPlayer.dummyBot, true)
    eventPlayer.effects[2] = getLastCreatedEntity()
    eventPlayer.dummyBot.attachTo(eventPlayer, eventPlayer.ultArray[0] * Vector.LEFT)
    eventPlayer.dummyBot.creditOwner = true
    eventPlayer.dummyBot.startForcingName("{0}".format(eventPlayer))
    #eventPlayer.dummyBot.isUlting = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ULTIMATE), 1)
    eventPlayer.ultArray[true] = true
    waitUntil(eventPlayer.isDead() or eventPlayer.dummyBot.isDead() or eventPlayer.ultChase1 == null, 30)
    destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[0])
    destroyEffect(eventPlayer.effects[2])
    eventPlayer.dummyBot.owner = null
    eventPlayer.stopCamera()
    eventPlayer.isUlting = false


rule "Swap With Twin":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isUlting != false
    @Condition eventPlayer.ultArray[true] != false
    
    eventPlayer.teleport(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.dummyBot.getPosition(), null, getAllPlayers(), false))
    eventPlayer.ultArray[false] *= -1
    eventPlayer.dummyBot.attachTo(eventPlayer, eventPlayer.ultArray[0] * Vector.LEFT)


rule "--- GENJI ---":
    @Delimiter
    


rule "Genji Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.GENJI
    
    eventPlayer.ability1Array[true] = []
    #dragon circle range, speed, segments, segment angles
    eventPlayer.ability2Array[false] = [5, 60]
    eventPlayer.ability2Array[true] = [null, null]
    eventPlayer.isUlting = false
    eventPlayer.ability2Array[true] = eventPlayer.ability2Array[true].slice(false, true).concat([null]).concat(eventPlayer.ability2Array[true].slice(true + true, 999999995904))
    eventPlayer.setMaxHealth(90)
    eventPlayer.setDamageDealt(88.88)
    createProjectileEffect(getAllPlayers() if eventPlayer.isAlive() else null, Projectile.LUCIO_SONIC_AMPLIFIER, getAllPlayers(), eventPlayer.ability2Chase, eventPlayer.ability3Chase, 0.1)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers() if eventPlayer.isAlive() else null, Projectile.ORISA_FUSION_DRIVER, getAllPlayers(), eventPlayer.ability2Chase, eventPlayer.ability3Chase, 0.1)
    eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers() if eventPlayer.isAlive() else null, Beam.GRAPPLE, eventPlayer.ability2Chase + (1.31 * (directionFromAngles(-16 + horizontalAngleOfDirection(eventPlayer.ability3Chase), -4 + verticalAngleOfDirection(eventPlayer.ability3Chase)))), eventPlayer.ability2Chase + (1.39 * (directionFromAngles(-16 + horizontalAngleOfDirection(eventPlayer.ability3Chase), -4 + verticalAngleOfDirection(eventPlayer.ability3Chase)))))
    eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers() if eventPlayer.isAlive() else null, Beam.GRAPPLE, eventPlayer.ability2Chase + (1.31 * (directionFromAngles(16 + horizontalAngleOfDirection(eventPlayer.ability3Chase), -4 + verticalAngleOfDirection(eventPlayer.ability3Chase)))), eventPlayer.ability2Chase + (1.39 * (directionFromAngles(16 + horizontalAngleOfDirection(eventPlayer.ability3Chase), -4 + verticalAngleOfDirection(eventPlayer.ability3Chase)))))
    eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers() if eventPlayer.isAlive() else null, Beam.TORBJORN_TURRET_SIGHT, eventPlayer.ability2Chase + normalize(eventPlayer.ability3Chase) * 1.8, eventPlayer.ability2Chase + normalize(eventPlayer.ability3Chase) * 2.1)
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.ability2Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.getEyePosition() + vect(eventPlayer.ability2Array[0][0] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), 0.25 * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][0] * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()))), 999999995904)
    eventPlayer.ability3Chase = Vector.LEFT + Vector.RIGHT
    chaseAtRate(eventPlayer.ability3Chase, vect(-1 * eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()))), 999999995904)
    eventPlayer.heroInfo = ["Passive: Dragon's Aid0Ability 1: Green Vortex0Ultimate: Dragon's Reach".split(null[0]), ["{0}txC00000000004E93>".format(__holygrail___), "{0}txC000000000039DA>".format(__holygrail___), "{0}txC000000000012F7>".format(__holygrail___)], "Your spirit dragon flies around you.\nWhen you land every shuriken in a shot, it attacks the victim,\nslowing and damaging them{0}".format(". This damage heals you as well.0At the end of swift strike, pull nearby enemies and ones damaged by it to your crosshair.0Gr{0}".format("een Vortex has infinite range, and your dragon deals massive damage to nearby enemies.")).split(null[0])]


rule "Dragon's Aid Reset Stacks":
    @Event eachPlayer
    @Hero genji
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    eventPlayer.ability2Array[true] = eventPlayer.ability2Array[true].slice(false, false).concat([null]).concat(eventPlayer.ability2Array[true].slice(0 + true, 999999995904))


rule "Dragon's Aid Effect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isUlting == false
    @Condition eventPlayer.ability2Array[true][0] >= 3
    
    stopChasing(eventPlayer.ability2Chase)
    chaseOverTime(eventPlayer.ability2Chase, eventPlayer.ability2Array[true][true].getEyePosition(), 0.5)
    stopChasing(eventPlayer.ability3Chase)
    chaseAtRate(eventPlayer.ability3Chase, directionTowards(eventPlayer.ability2Chase, eventPlayer.ability2Array[true][true].getEyePosition()), 999999995904)
    smallMessage(eventPlayer, "The dragon ravages {0} ({1})".format(eventPlayer.ability2Array[true][true], eventPlayer.ability2Array[true][true].getHero()))
    smallMessage(eventPlayer.ability2Array[true][true], "The dragon ravages your spirit.")
    wait(0.5)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.GREEN, eventPlayer.ability2Array[true][true].getEyePosition(), 0.7)
    eventPlayer.ability2Array[true][true].startDamageOverTime(eventPlayer, 4, 12.5)
    eventPlayer.startHealingOverTime(eventPlayer, 4, 6.75)
    eventPlayer.ability2Array[true][true].moveSpeed[false] -= 30
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.ability2Array[true][true].getPosition() + vect(2 * (cosDeg(270 * getTotalTimeElapsed())), 0.5, 2 * (sinDeg(270 * getTotalTimeElapsed()))), 999999995904)
    chaseAtRate(eventPlayer.ability3Chase, vect(-540 * (sinDeg(270 * getTotalTimeElapsed())), false, 540 * (cosDeg(270 * getTotalTimeElapsed()))), 999999995904)
    wait(4)
    eventPlayer.ability2Array[true][true].moveSpeed[false] += 30
    smallMessage(eventPlayer.ability2Array[true][true], "The Dragon is satisfied with you.")
    stopChasing(eventPlayer.ability2Chase)
    stopChasing(eventPlayer.ability3Chase)
    chaseOverTime(eventPlayer.ability2Chase, eventPlayer.getEyePosition() + (vect(7 * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), 0.25 + sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()), 7 * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())))), true)
    eventPlayer.ability3Chase = directionTowards(eventPlayer.ability2Chase, eventPlayer.getEyePosition() + (vect(7 * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), 0.25 + sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()), 7 * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())))))
    chaseOverTime(eventPlayer.ability3Chase, vect(-1 * eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()))), true)
    wait(true)
    smallMessage(eventPlayer, "The Dragon is Satisfied.")
    eventPlayer.ability2Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.getEyePosition() + (vect(7 * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), 0.25 + sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()), 7 * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())))), 999999995904)
    eventPlayer.ability3Chase = Vector.LEFT + Vector.RIGHT
    chaseAtRate(eventPlayer.ability3Chase, vect(-1 * eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (sinDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed())), eventPlayer.ability2Array[0][true] * eventPlayer.ability2Array[0][0] * (cosDeg(eventPlayer.ability2Array[0][true] * getTotalTimeElapsed()))), 999999995904)
    eventPlayer.ability2Array[true] = eventPlayer.ability2Array[true].slice(false, true).concat([null]).concat(eventPlayer.ability2Array[true].slice(true + true, 999999995904))


rule "Hit Counter + Green Vortex Add Target":
    @Event playerDealtDamage
    @Hero genji
    
    if eventAbility == Button.ABILITY_1 and victim.isAlive():
        eventPlayer.ability1Array[true].append(victim)
    if eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE:
        if eventPlayer.ability2Array[true][true] == null:
            eventPlayer.ability2Array[true] = (eventPlayer.ability2Array[true].slice(false, false).concat([eventPlayer.ability2Array[true][0] + true])).concat(eventPlayer.ability2Array[true].slice(0 + true, 999999995904))
        if eventPlayer.ability2Array[true][0] >= 3:
            eventPlayer.ability2Array[true] = eventPlayer.ability2Array[true].slice(false, true).concat([victim]).concat(eventPlayer.ability2Array[true].slice(true + true, 999999995904))


rule "Green Vortex Pull":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(0.32, Wait.ABORT_WHEN_FALSE)
    eventPlayer.ability1Array[false] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 3, null, eventPlayer, false)
    eventPlayer.ability1Array[true].append(getAllPlayers().filter(lambda player: ((player.isAlive() and not player.isDummy() and (distance(player, eventPlayer.ability1Array[0]) < (100 if eventPlayer.isUlting else 8))) and isInLoS(eventPlayer.ability1Array[0], player)) and player != eventPlayer))
    eventPlayer.ability1Array[true] = eventPlayer.ability1Array[true].filter(lambda x, i_: eventPlayer.ability1Array[true].index(x) == i_)
    eventPlayer.ability1Chase = 1
    chaseOverTime(eventPlayer.ability1Chase, 0.01, 0.45)
    eventPlayer.disablePlayerCollision()
    eventPlayer.ability1Array[true].setEnvironmentalKillCreditor(eventPlayer)
    eventPlayer.ability1Array[true].setStatusEffect(eventPlayer, Status.ROOTED, 0.45)
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION, Color.TEAM_1, eventPlayer.ability1Array[0], 1)
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION_SOUND, Color.TEAM_1, eventPlayer.ability1Array[0], 100)
    for i in range(0, len(eventPlayer.ability1Array[true]), true):
        createBeam(getAllPlayers(), Beam.ORISA_HALT_TENDRIL, eventPlayer.ability1Array[0], eventPlayer.ability1Array[true][evalOnce(i)].getPosition() + Vector.UP, Color.TEAM_1)
        eventPlayer.ability1Array[2] = eventPlayer.ability1Array[2].slice(false, i).concat([getLastCreatedEntity()]).concat(eventPlayer.ability1Array[2].slice(i + true, 999999995904))
        eventPlayer.ability1Array[true][i].startForcingPosition(eventPlayer.ability1Array[0] + Vector.DOWN + evalOnce(vectorTowards(eventPlayer.ability1Array[0], eventPlayer.ability1Array[true][i].getPosition())) * eventPlayer.ability1Chase)
    wait(0.45)
    destroyEffect(eventPlayer.ability1Array[2])
    stopChasing(eventPlayer.ability1Chase)
    eventPlayer.enablePlayerCollision()
    for i in range(0, len(eventPlayer.ability1Array[true]), true):
        eventPlayer.ability1Array[true][i].stopForcingPosition()
        eventPlayer.ability1Array[true][i].applyImpulse(eventPlayer.ability1Array[true][i].getVelocity(), -0.001, Relativity.TO_WORLD)
    eventPlayer.ability1Array[true] = []


rule "Dragon's Reach":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.isUlting = true
    eventPlayer.ability2Array[false] = [7, 720]
    while eventPlayer.isUsingUltimate():
        wait(0.1)
        damage((getPlayersInRadius(eventPlayer, 7, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer), eventPlayer, 5)
        heal(eventPlayer, eventPlayer, 2.5)
    eventPlayer.isUlting = false
    eventPlayer.ability2Array[false] = [5, 60]


rule "--- REAPER ---":
    @Delimiter
    


rule "Reaper Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.REAPER
    
    eventPlayer.ability1Chase = 100
    eventPlayer.ability1Array[false] = false
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setMaxHealth(75)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC00000000003FCF> Soul meter: {1}%".format(__holygrail___, floor(eventPlayer.ability1Chase)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.42 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(124, 62, 82))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}".format("□□□□□□□□0■□□□□□□□0■■□□□□□□0■■■□□□□□0■■■■□□□□0■■■■■□□□0■■■■■■□□0■■■■■■■□0■■■■■■■■".split(null[0])[floor(eventPlayer.ability1Chase / 12.5)]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.55 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.125, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(124, 62, 82))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive: The Reaping0Ability 2: Displacement0Secondary Fire: Self-Sacrifice".split(null[0]), ["{0}txC00000000003FCF>".format(__holygrail___), "{0}txC0000000000F76A>".format(__holygrail___), "{0}txc0000000002be58>".format(__holygrail___)], "Dealing damage generates soul, the resource for your abilities.0Project yourself into a ball of smoke, then teleport to it.\nT{0}".format("he ball can travel through all surfaces.\nWhile charging, your body remains vulnerable.0Hold Secondary fire to damage yourself{0}".format(" but gain soul.")).split(null[0])]


rule "Add Soul":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility[0] != false
    
    eventPlayer.ability1Chase += 100 * eventDamage / victim.getMaxHealth()
    eventPlayer.ability1Chase = min(100, eventPlayer.ability1Chase)


rule "Respawn Refill Soul":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.ability1Chase = 100


rule "Wraith Start":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    @Condition eventPlayer.ability1Chase > null
    @Condition eventPlayer.ability1Array[0] == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.ability1Array[false] = true
    chaseAtRate(eventPlayer.ability1Chase, false, 25)


rule "Wraith End":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.ability1Array[0] == true
    
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.ability1Chase == null or not eventPlayer.isHoldingButton(Button.ABILITY_1), 4)
    eventPlayer.ability1Array[false] = false
    eventPlayer.cancelPrimaryAction()
    stopChasing(eventPlayer.ability1Chase)
    if eventPlayer.ability1Chase <= null:
        eventPlayer.setAbility1Enabled(false)
        waitUntil(eventPlayer.ability1Chase > null, 999999995904)
        eventPlayer.setAbility1Enabled(true)


rule "Wraith Effect":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.ability1Array[0] != false
    
    eventPlayer.ability1Array[true] = eventPlayer.getAmmo(false)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.1)
    waitUntil([eventPlayer.ability1Array == null, not eventPlayer.isUsingAbility1(), not eventPlayer.isHoldingButton(Button.ABILITY_1), eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)].any(), 4)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAmmo(false, eventPlayer.ability1Array[true])
    if ruleCondition:
        loop()
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, true)


rule "Displacement":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.ability1Array[0] == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    if eventPlayer.ability1Chase < 10:
        smallMessage(eventPlayer, "Insufficient Soul (Minimum 10 requirement)")
        wait(0.5)
        return
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.moveSpeed[false] -= 100
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    eventPlayer.ability2Chase = Vector.LEFT + Vector.RIGHT
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.ability2Chase + eventPlayer.getFacingDirection(), 5 + magnitude(eventPlayer.ability2Chase))
    chaseAtRate(eventPlayer.ability1Chase, false, 7.5 + 1.5 * magnitude(eventPlayer.ability2Chase))
    eventPlayer.startCamera(eventPlayer.getEyePosition() + eventPlayer.ability2Chase, eventPlayer.getEyePosition() + eventPlayer.ability2Chase + eventPlayer.getFacingDirection())
    eventPlayer.thirdPersonCam = true
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.RED, eventPlayer.getEyePosition() + eventPlayer.ability2Chase, 0.3)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLACK, eventPlayer.getEyePosition() + eventPlayer.ability2Chase, 0.5)
    eventPlayer.effects[true] = getLastCreatedEntity()
    wait(0.25)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.ability1Chase < 2, 12)
    eventPlayer.moveSpeed[false] += 100
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    if eventPlayer.ability1Chase < 2:
        eventPlayer.ability1Chase = null
    stopChasing(eventPlayer.ability1Chase)
    stopChasing(eventPlayer.ability2Chase)
    eventPlayer.stopCamera()
    eventPlayer.thirdPersonCam = false
    eventPlayer.stopForcingPosition()
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.ability2Chase)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, null, eventPlayer.getPosition(), 1)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR_SOUND, null, eventPlayer.getPosition(), 100)
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT, null, eventPlayer.getPosition(), 1)
    destroyEffect(eventPlayer.effects[0])
    destroyEffect(eventPlayer.effects[true])
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection() + normalize(eventPlayer.ability2Chase), magnitude(eventPlayer.ability2Chase) / 2, Relativity.TO_WORLD)
    eventPlayer.disableEnvironmentCollision(false)
    waitUntil(eventPlayer.getAltitude() < 1 or eventPlayer.isDead(), 999999995904)
    eventPlayer.enableEnvironmentCollision()


rule "Self Harm":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHealth() > 25
    @Condition eventPlayer.ability1Chase < 100
    @Condition eventPlayer.ability1Array[0] == false
    
    eventPlayer.startDamageOverTime(eventPlayer, 99999, 50)
    eventPlayer.ability1Array[2] = getLastDamageOverTimeId()
    while eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and eventPlayer.getHealth() > 25 and eventPlayer.ability1Chase < 100 and not eventPlayer.ability1Array[0]:
        wait(0.14)
        eventPlayer.ability1Chase += 3.571
        eventPlayer.ability1Chase = min(100, eventPlayer.ability1Chase)
    stopDamageOverTime(eventPlayer.ability1Array[2])
    if eventPlayer.getHealth() < 25:
        heal(eventPlayer, null, 25 - eventPlayer.getHealth())


rule "--- SOJOURN ---":
    @Delimiter
    


rule "Sojourn Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.SOJOURN
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    createEffect(getAllPlayers() if eventPlayer.ability1Array[true] > getTotalTimeElapsed() else null, Effect.MERCY_DAMAGE_BOOSTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[false] = getLastCreatedEntity()
    eventPlayer.ability1Array = [[], null, false]
    eventPlayer.heroInfo = ["Passive: Cyberadrenaline0Ability 2: Energy Barricade0Ultimate: Pulse Cannon".split(null[0]), ["{0}txC00000000014ADF>".format(__holygrail___), "{0}txC0000000000133D>".format(__holygrail___), "{0}txC00000000029D99>".format(__holygrail___)], "When taking damage, gain speed and faster cooldown rates.0Deploy a barricade that blocks enemy movement.\nEnemies that touch t{0}".format("he barricade take damage and are stunned.0Wield a heavy energy cannon that damages through walls,\nand gain sporadic vision on{0}".format(" enemies.")).split(null[0])]


rule "Activate Cyberadrenaline":
    @Event playerTookDamage
    @Hero sojourn
    
    eventPlayer.ability1Array[true] = getTotalTimeElapsed() + 3
    eventPlayer.ability1Array[2] = true


rule "Cyberadrenaline Effect":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.ability1Array[true] > getTotalTimeElapsed()
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.ability1Array[2] != false
    @Condition eventPlayer.init[0] == Hero.SOJOURN
    
    eventPlayer.moveSpeed[false] += 30
    while eventPlayer.ability1Array[true] > getTotalTimeElapsed() and eventPlayer.isAlive() and eventPlayer.ability1Array[2] and eventPlayer.init[0] == Hero.SOJOURN:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 0.125)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 0.125)
        waitUntil(eventPlayer.ability1Array[true] <= getTotalTimeElapsed(), 0.125)
    eventPlayer.moveSpeed[false] -= 30


rule "Place Barricade":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    createInWorldText(eventPlayer, "Place  {0}  |".format(inputBindingString(Button.PRIMARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((-0.7 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.2)
    eventPlayer.inWorldTexts[false] = getLastCreatedText()
    createInWorldText(eventPlayer, "|  {0}  Cancel".format(inputBindingString(Button.SECONDARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.73 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.2)
    eventPlayer.inWorldTexts[true] = getLastCreatedText()
    eventPlayer.ability1Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability1Chase, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, eventPlayer, false) if raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, eventPlayer, false) != eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15 and (raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, eventPlayer, false)).y >= 0.2 else raycastHitPosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, eventPlayer, false), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, eventPlayer, false) + -1000 * Vector.UP, null, eventPlayer, false), 999999995904)
    eventPlayer.ability2Chase = eventPlayer.ability1Chase
    eventPlayer.ability3Chase = eventPlayer.ability1Chase
    eventPlayer.ability2Array[7] = 6 * Vector.LEFT
    chaseAtRate(eventPlayer.ability2Chase, raycastHitPosition(eventPlayer.ability1Chase + 0.2 * Vector.UP, eventPlayer.ability1Chase + (worldVector(eventPlayer.ability2Array[7] + 0.2 * Vector.UP, eventPlayer, Transform.ROTATION)), null, eventPlayer, false), 999999995904)
    chaseAtRate(eventPlayer.ability3Chase, raycastHitPosition(eventPlayer.ability1Chase + 0.2 * Vector.UP, eventPlayer.ability1Chase + (worldVector(-1 * eventPlayer.ability2Array[7] + 0.2 * Vector.UP, eventPlayer, Transform.ROTATION)), null, eventPlayer, false), 999999995904)
    createBeam(eventPlayer, Beam.GRAPPLE, eventPlayer.ability2Chase, eventPlayer.ability3Chase)
    eventPlayer.effects[true] = getLastCreatedEntity()
    wait(0.5)
    while not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isDead()):
        waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isDead(), 999999995904)
        if eventPlayer.isHoldingButton(Button.ABILITY_2):
            eventPlayer.ability2Array[7] = vect(eventPlayer.ability2Array[7].z, false, eventPlayer.ability2Array[7].x)
            waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isDead(), 999999995904)
    destroyInWorldText(eventPlayer.inWorldTexts[0])
    destroyInWorldText(eventPlayer.inWorldTexts[true])
    destroyEffect(eventPlayer.effects[true])
    stopChasing(eventPlayer.ability1Chase)
    stopChasing(eventPlayer.ability2Chase)
    stopChasing(eventPlayer.ability3Chase)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 6)
        smallMessage(eventPlayer, "Barricade Constructed")
        eventPlayer.ability2Array[false] = eventPlayer.ability1Chase
        eventPlayer.ability2Array[true] = eventPlayer.ability2Chase
        eventPlayer.ability2Array[2] = eventPlayer.ability3Chase
        for i in range(1, 3, true):
            createBeam(getAllPlayers(), Beam.GRAPPLE, evalOnce(eventPlayer.ability2Array[i] + -0.2 * Vector.UP), evalOnce(eventPlayer.ability2Array[i] + 1.8 * Vector.UP))
            eventPlayer.effects[true + i] = getLastCreatedEntity()
        for i in range(0, 4, true):
            if i % 2:
                createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, evalOnce(eventPlayer.ability2Array[true] + (Vector.UP * (0.6 + 0.4 * i))), evalOnce(eventPlayer.ability2Array[2] + (Vector.UP * (0.6 + 0.4 * i))), Color.TEAM_1)
            else:
                createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, evalOnce(eventPlayer.ability2Array[2] + (Vector.UP * (0.6 + 0.4 * i))), evalOnce(eventPlayer.ability2Array[true] + (Vector.UP * (0.6 + 0.4 * i))), Color.TEAM_1)
            eventPlayer.effects[4 + i] = getLastCreatedEntity()
        wait(0.5)
        if not eventPlayer.isUlting:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
        waitUntil(eventPlayer.isDead() or eventPlayer.isHoldingButton(Button.ABILITY_2), 999999995904)
        smallMessage(eventPlayer, "Barricade Destroyed")
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) + true)
        for i in range(1, 8, true):
            destroyEffect(eventPlayer.effects[i])
        eventPlayer.ability2Array[false] = null
        eventPlayer.ability2Array[true] = null
        eventPlayer.ability2Array[2] = null
    else:
        wait(0.5)
        if not eventPlayer.isUlting:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)


rule "Barricade Hitbox":
    @Event eachPlayer
    @Hero sojourn
    @Condition [eventPlayer.ability2Array[0], eventPlayer.ability2Array[true], eventPlayer.ability2Array[2]].all() == true
    
    eventPlayer.ability2Array[3] = (getPlayersInRadius(eventPlayer.ability2Array[0], max(distance(eventPlayer.ability2Array[0], eventPlayer.ability2Array[true]), distance(eventPlayer.ability2Array[0], eventPlayer.ability2Array[2])) / 2, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)
    eventPlayer.ability2Array[4] = (getPlayersInRadius(eventPlayer.ability2Array[true], max(1.5, distance(eventPlayer.ability2Array[0], eventPlayer.ability2Array[true]) / 2), Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)
    eventPlayer.ability2Array[5] = (getPlayersInRadius(eventPlayer.ability2Array[2], max(1.5, distance(eventPlayer.ability2Array[0], eventPlayer.ability2Array[2]) / 2), Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer)
    for eventPlayer.i in range(3, 6, true):
        if len(eventPlayer.ability2Array[eventPlayer.i]):
            for eventPlayer.j in range(0, len(eventPlayer.ability2Array[eventPlayer.i]), true):
                eventPlayer.ability2Array[6] = eventPlayer.ability2Array[eventPlayer.i][eventPlayer.j]
                if not eventPlayer.ability2Array[eventPlayer.i][eventPlayer.j].hasStatus(Status.PHASED_OUT):
                    playEffect(getAllPlayers(), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR, Color.TEAM_1, eventPlayer.ability2Array[6].getEyePosition(), 1)
                    eventPlayer.ability2Array[6].setStatusEffect(eventPlayer, Status.STUNNED, 0.5)
                    damage(eventPlayer.ability2Array[6], eventPlayer, 25)
                    eventPlayer.ability2Array[6].applyImpulse(directionTowards(eventPlayer.ability2Array[eventPlayer.i - 3] + Vector.UP, eventPlayer.ability2Array[6]) + Vector.UP, 10, Relativity.TO_WORLD)
    wait(0.1)
    if ruleCondition:
        loop()


rule "Pulse Cannon Initiation":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(not eventPlayer.isReloading(), 999999995904)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setReloadEnabled(false)
    eventPlayer.setDamageReceived(150)
    eventPlayer.isUlting = true
    eventPlayer.ultTarget = []
    bigMessage(getAllPlayers(), "{0}: {1}fg1fc0cfFF>Pulse Cannon{1}/fg> activated!".format(heroIcon(Hero.SOJOURN), __holygrail___))
    createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.isAlive() and player.showHud and not player.inCassShop and not player.inSoldierMenu), "{0}\n﹀".format(heroIcon(Hero.SOJOURN)), updateEveryFrame(evalOnce(eventPlayer).getEyePosition() + 0.2 * Vector.UP), 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA)
    eventPlayer.inWorldTexts[9] = getLastCreatedText()
    for i in range(0, 6, true):
        if getPlayersInSlot(i, Team.ALL) != eventPlayer:
            eventPlayer.ultTarget[i] = getPlayersInSlot(i, Team.ALL)
            createInWorldText(eventPlayer if entityExists(evalOnce(eventPlayer.ultTarget[i])) and floor(eventPlayer.getAmmo(false)) % 8 in [1, 2, 3] else null, "{0}\n﹀".format(heroIcon(evalOnce(eventPlayer.ultTarget[i]).getHero())), updateEveryFrame(evalOnce(eventPlayer.ultTarget[i]).getEyePosition() + 0.2 * Vector.UP + directionTowards(eventPlayer, evalOnce(eventPlayer.ultTarget[i])) * 500 * evalOnce(eventPlayer.ultTarget[i]).isDead()), 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA if evalOnce(eventPlayer.ultTarget[i]).isAlive() else Color.GRAY)
            eventPlayer.inWorldTexts[2 + i] = getLastCreatedText()
    for eventPlayer.i in range(0, 5, true):
        createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + (worldVector(Vector.RIGHT * (0.2 + (0.12 * (cosDeg(720 * getTotalTimeElapsed() + 72 * evalOnce(eventPlayer.i))))), eventPlayer, Transform.ROTATION)) + (normalize(crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * (0.18 + (0.12 * (sinDeg(720 * getTotalTimeElapsed() + 72 * evalOnce(eventPlayer.i))))))), eventPlayer.getEyePosition() + 1000 * eventPlayer.getFacingDirection(), Color.TEAM_1)
        eventPlayer.effects[8 + eventPlayer.i] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.OMNIC_SLICER_BEAM_SOUND, null, eventPlayer.getEyePosition(), 60)
    eventPlayer.effects[13] = getLastCreatedEntity()
    waitUntil(eventPlayer.getAmmo(false) == null or eventPlayer.isDead(), 999999995904)
    eventPlayer.isUlting = false
    for eventPlayer.i in range(8, 14, true):
        destroyEffect(eventPlayer.effects[eventPlayer.i])
    for eventPlayer.i in range(2, 9, true):
        destroyInWorldText(eventPlayer.inWorldTexts[eventPlayer.i])
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.setDamageReceived(100)


rule "Pulse Cannon Damage":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isUlting != false
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setAmmo(false, 45)
    eventPlayer.moveSpeed[false] -= 80
    while eventPlayer.isUlting and eventPlayer.isAlive():
        eventPlayer.ultTarget = getAllPlayers().exclude(eventPlayer).filter(lambda x: angleBetweenVectors(directionTowards(eventPlayer.getEyePosition(), x.getPosition() + 0.5 * vectorTowards(x.getPosition(), x.getEyePosition())), eventPlayer.getFacingDirection()) < (atan2Deg(0.25 + 0.5 * distance(x.getEyePosition(), x.getPosition()), distance(eventPlayer.getEyePosition(), x.getPosition() + 0.5 * vectorTowards(x.getPosition(), x.getEyePosition())))) * 0.65 and not x.hasStatus(Status.PHASED_OUT) and x.isAlive() and x != eventPlayer)
        for eventPlayer.i in range(0, len(eventPlayer.ultTarget), true):
            damage(eventPlayer.ultTarget[eventPlayer.i], eventPlayer, 15 + (7 * (eventPlayer.ultTarget[eventPlayer.i].getHealthOfType(Health.ARMOR) == true)))
        playEffect(getAllPlayers(), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR_SOUND, null, eventPlayer.getEyePosition(), 100)
        #for eventPlayer.i in range(len(eventPlayer.ultTarget)):
        eventPlayer.setAmmo(false, eventPlayer.getAmmo(false) - 0.675)
        wait(0.15)
    eventPlayer.moveSpeed[false] += 40
    wait(0.65)
    eventPlayer.moveSpeed[false] += 40


rule "--- SOLDIER: 76 ---":
    @Delimiter
    


rule "Initialize Soldier Menu":
    #Button Positions
    soldierMenu[false] = "\u0088\u0016\u009c\rQ\u00020\u0088\u0016\u009c\r\u0010\u00020\u0088\u0016\u009c\r\u00880\u009c\u0015\u009c\rQ\u00020\u009c\u0015\u009c\r\u0010\u00020\u009c\u0015\u009c\r\u00880\u0010\u0015\u009c\rQ\u00020\u0010\u0015\u009c\r\u0010\u00020\u0010\u0015\u009c\r\u00880\u0088\u0016\u009c\r\u00010\u009c\u0015\u009c\r$0\u0010\u0015\u009c\r\u0001".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(0.1 * x.last().strIndex(x[0].charAt(0)) + 10 * x.last().strIndex(x[0].charAt(1)), 0.1 * x.last().strIndex(x[0].charAt(4)) + 10 * x.last().strIndex(x[0].charAt(5)), 0.1 * x.last().strIndex(x[0].charAt(2)) + 10 * x.last().strIndex(x[0].charAt(3))) - vect(109.5, 109.5, 109.5))
    #Camera Position
    soldierMenu[true] = vect(100, -100, false)
    #Item Categories
    soldierMenu[2] = "Perks0Tacticals0Scorestreaks".split(null[0])
    #Item Names
    soldierMenu[3] = "Lightweight0Hardline0Juggernaut0Flashbang0Stim Shot0Tac. Insertion0Care Package0Orbital Laser0Glide Missiles".split(null[0])
    #Item Icons
    soldierMenu[4] = ["{0}txC00000000032726>".format(__holygrail___), "{0}txC0000000004F73C>".format(__holygrail___), "{0}txC0000000003FE38>".format(__holygrail___), "{0}txC00000000002694>".format(__holygrail___), "{0}txC00000000009B38>".format(__holygrail___), "{0}txC00000000009F9A>".format(__holygrail___), "{0}txC00000000032723>".format(__holygrail___), "{0}txC00000000049441>".format(__holygrail___), "{0}txC000000000013EB>".format(__holygrail___)]
    #Item Descriptions
    soldierMenu[5] = "Move 10% faster when not shooting and sprint 20% faster.\nDo not take fall damage from sigma.\uec51Respawn with 30% of your previou{0}".format("s score, up to 500.\nGenerate 15% more score from damage.\uec51Run 25% slower, but take 65% less damage while sprinting.\nGain 50 mo{0}".format("re permanent HP.\uec51Fire a projectile that blinds and burns enemies it hits.\nReplaces helix rockets.\uec51Heal and gain a decaying sp{0}".format("eed boost.\nReplaces biotic field.\uec51Place a beacon that you will respawn at when you die.\nReplaces biotic field.\uec51Call in a pack{0}".format("age that gives you a random buff for 15s.\nCost: 350\uec51Summon a giant laser that damages enemies and slowly moves forward.\nCost:{0}".format(" 600\uec51Guide 4 lethal missles that damage, burn, and stun enemies.\nCost: 850"))))).split("\uec51")


rule "Create Menu Text":
    createEffect(localPlayer if localPlayer.inSoldierMenu else null, Effect.ORB, Color.BLACK, soldierMenu[true] + 0.7 * Vector.FORWARD, 100)
    #Highlight effect
    createInWorldText(localPlayer if localPlayer.inSoldierMenu and localPlayer.soldierMenuCanSelect and localPlayer.soldierMenuToSelect < 6 else null, "{0}fgFFFFFF60>{0}TX C00000000021660>".format(__holygrail___), soldierMenu[0][localPlayer.soldierMenuToSelect], 4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Description first line
    createInWorldText(localPlayer if localPlayer.inSoldierMenu and localPlayer.soldierMenuCanSelect and localPlayer.soldierMenuToSelect < 9 else null, soldierMenu[5][localPlayer.soldierMenuToSelect].split("\n")[0], soldierMenu[0][10], 2.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Description second line
    createInWorldText(localPlayer if localPlayer.inSoldierMenu and localPlayer.soldierMenuCanSelect and localPlayer.soldierMenuToSelect < 9 else null, soldierMenu[5][localPlayer.soldierMenuToSelect].split("\n")[true], soldierMenu[0][10] + Vector.DOWN, 2.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Enter Button
    #createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "{}{}{}".format(
    #"<TX C0000000000000B>","<TX C0000000000000B>","<TX C0000000000000B>"),
    #soldierMenu[0][9], 4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "Join Game", soldierMenu[0][9] + 0.15 * Vector.UP, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE if localPlayer.soldierMenuToSelect != 9 else Color.BLUE)
    createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "Switch Heroes", soldierMenu[0][11] + 0.15 * Vector.UP, 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE if localPlayer.soldierMenuToSelect != 11 else Color.BLUE)
    #createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "Select four items",
    #soldierMenu[0][14], 2.8, Clip.NONE)
    for i in range(0, 9, true):
        #Black square
        #createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "<TX C0000000000000B>",
        #soldierMenu[0][evalOnce(i)], 4)
        if not i % 3:
            #Top line
            createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "{0}TX C0000000004ED4C>".format(__holygrail___), soldierMenu[0][evalOnce(i)] + 2.5 * Vector.UP, 0.6)
            #Category names
            createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, soldierMenu[2][evalOnce(i / 3)] if evalOnce(i) != 9 else localPlayer.getHero(), soldierMenu[0][evalOnce(i)] + 3 * Vector.UP, 1.8)
            if i != 6:
                #Selected items
                createInWorldText(localPlayer if localPlayer.inSoldierMenu and (localPlayer.ability1Array[0][evalOnce(i / 3)])[0] else null, "{0}fgFFFFFF80>{0}TX C0000000000B666>".format(__holygrail___), soldierMenu[0][evalOnce(i) + (localPlayer.ability1Array[0][evalOnce(i / 3)])[true]], 4)
        if i >= 6:
            #Selected items
            createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, "{0}fgFFFFFF80>{0}TX C0000000000B666>".format(__holygrail___), soldierMenu[0][evalOnce(i)], 4)
        #icon
        createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, soldierMenu[4][evalOnce(i)], soldierMenu[0][evalOnce(i)], 2.9)
        #name
        createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, soldierMenu[3][evalOnce(i)], soldierMenu[0][evalOnce(i)] + -1.4 * Vector.UP, 1.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.BLUE if (localPlayer.ability1Array[0][floor(evalOnce(i) / 3)])[0] and (localPlayer.ability1Array[0][floor(evalOnce(i) / 3)])[true] == evalOnce(i) % 3 else Color.WHITE if evalOnce(i) < 6 else Color.BLUE)
    #Cursor
    createInWorldText(localPlayer if localPlayer.inSoldierMenu else null, inputBindingString(Button.PRIMARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))]) if localPlayer.soldierMenuCanSelect and localPlayer.soldierMenuToSelect < 6 else "{0}txc0000000002dd21>".format(__holygrail___), updateEveryFrame(soldierMenu[true] + localPlayer.getFacingDirection()), 1.8 if localPlayer.soldierMenuCanSelect else 2.2)


def SoldierMenuCompleteSelection():
    @Name "Subroutine SoldierMenuCompleteSelection"
    
    wait(0.1)
    waitUntil([entityExists(eventPlayer), eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), eventPlayer.soldierMenuCanSelect].all(), 999999995904)
    waitUntil([eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), not entityExists(eventPlayer), not eventPlayer.soldierMenuCanSelect].any(), 999999995904)
    if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        loop()
    if eventPlayer.soldierMenuToSelect == 9:
        if [eventPlayer.ability1Array[0][0][0], eventPlayer.ability1Array[0][true][0]].all():
            startRule(EnableAbilties)
            eventPlayer.inSoldierMenu = false
            eventPlayer.ability1Array[false] = [eventPlayer.ability1Array[0][0][true], eventPlayer.ability1Array[0][true][true]]
        else:
            smallMessage(eventPlayer, "Select a perk and tactical before entering the game!")
    elif eventPlayer.soldierMenuToSelect == 11:
        eventPlayer.inSoldierMenu = false
        eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(Hero.SOLDIER))
        eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(Hero.SOLDIER))
    else:
        eventPlayer.ability1Array[false] = ((eventPlayer.ability1Array[0].slice(false, floor(eventPlayer.soldierMenuToSelect / 3))).concat([(((eventPlayer.ability1Array[0][floor(eventPlayer.soldierMenuToSelect / 3)]).slice(false, false)).concat([true])).concat((eventPlayer.ability1Array[0][floor(eventPlayer.soldierMenuToSelect / 3)]).slice(0 + true, 999999995904))])).concat(eventPlayer.ability1Array[0].slice(floor(eventPlayer.soldierMenuToSelect / 3) + true, 999999995904))
        eventPlayer.ability1Array[false] = ((eventPlayer.ability1Array[0].slice(false, floor(eventPlayer.soldierMenuToSelect / 3))).concat([(((eventPlayer.ability1Array[0][floor(eventPlayer.soldierMenuToSelect / 3)]).slice(false, true)).concat([eventPlayer.soldierMenuToSelect % 3])).concat((eventPlayer.ability1Array[0][floor(eventPlayer.soldierMenuToSelect / 3)]).slice(true + true, 999999995904))])).concat(eventPlayer.ability1Array[0].slice(floor(eventPlayer.soldierMenuToSelect / 3) + true, 999999995904))
    if eventPlayer.inSoldierMenu:
        loop()


def SoldierMenuStartSelection():
    @Name "Subroutine SoldierMenuStartSelection"
    
    eventPlayer.inSoldierMenu = true
    eventPlayer.thirdPersonCam = true
    eventPlayer.startCamera(soldierMenu[true], soldierMenu[true] + Vector.FORWARD)
    eventPlayer.disableHeroHud()
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
    eventPlayer.setFacing(Vector.FORWARD, Relativity.TO_WORLD)
    startRule(DisableAbilities)
    startRule(SoldierMenuCompleteSelection)
    eventPlayer.ability1Array[false] = [[false, null], [false, null]]
    while eventPlayer.inSoldierMenu:
        eventPlayer.soldierMenuCanSelect = soldierMenu[0].any(lambda x: distance(soldierMenu[true] + eventPlayer.getFacingDirection() * distance(soldierMenu[true], x), x) < 2.2)
        eventPlayer.soldierMenuToSelect = soldierMenu[0].index((sorted(soldierMenu[0], lambda x: distance(soldierMenu[true] + eventPlayer.getFacingDirection() * distance(soldierMenu[true], x), x)))[0])
        if abs(eventPlayer.getVerticalFacingAngle()) > 35:
            eventPlayer.setFacing(directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 35 if eventPlayer.getVerticalFacingAngle() > null else -35), Relativity.TO_WORLD)
        wait(0.1)
    eventPlayer.stopCamera()
    eventPlayer.thirdPersonCam = false
    eventPlayer.enableHeroHud()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.setInvisibility(Invis.NONE)


rule "Enter Menu":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.SOLDIER
    
    eventPlayer.inSoldierMenu = true
    SoldierMenuStartSelection()


rule "Upon Exit Menu":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.inSoldierMenu == false
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.heroInfo = [["Role: Black Op {0}txC0000000003A4DF>\nInstead of abilities, have a perk, tactical, and scorestreak.\n--------------------------{1}".format(__holygrail___, "-----\nPerk: {0}".format(soldierMenu[3][eventPlayer.ability1Array[0][0]])), "Tactical: {0}".format(soldierMenu[3][3 + eventPlayer.ability1Array[0][true]]), "Ultimate*: Scorestreaks"], [soldierMenu[4][eventPlayer.ability1Array[0][0]], soldierMenu[4][3 + eventPlayer.ability1Array[0][true]], "{0}txC00000000032723>".format(__holygrail___)], [soldierMenu[5][eventPlayer.ability1Array[0][0]], soldierMenu[5][3 + eventPlayer.ability1Array[0][true]], "Care Package: Call in a package that gives you a random buff for 15s - Cost: 350\nOrbital Laser: Summon a giant laser that dam{0}".format("ages enemies and slowly moves forward - Cost: 600\nGlide Missiles: Guide 3 lethal missles that damage, burn, and stun enemies {0}".format("- Cost: 850\n\n*Automatically chooses the most expensive useable scorestreak"))]]
    createInWorldText(eventPlayer if eventPlayer.isAlive() and not eventPlayer.thirdPersonCam else null, "Score: {0}".format(eventPlayer.ability1Array[true]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.5 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.6)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.disallowButton(Button.ULTIMATE)
    if eventPlayer.ability1Array[0][0] == null:
        eventPlayer.moveSpeed[false] += 10
    if eventPlayer.ability1Array[0][0] == 2:
        eventPlayer.setMaxHealth(120)
        heal(eventPlayer, null, 100)
        startDamageModification(eventPlayer if eventPlayer.isUsingAbility1() else null, getAllPlayers(), 35)
        eventPlayer.damageMods.append(getLastDamageModification())
    if eventPlayer.ability1Array[0][true] == null:
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.disallowButton(Button.ABILITY_2)


rule "Upon Spawn":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.inSoldierMenu == false
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    #Set score to 30% if hardline
    if eventPlayer.ability1Array[0][0] == 1:
        eventPlayer.ability1Array[true] = round(min(eventPlayer.ability1Array[true] * 0.3, 500))
    else:
        eventPlayer.ability1Array[true] = null
    #Score helper
    eventPlayer.ability1Array[2] = null
    #killstreak
    eventPlayer.ability1Array[3] = null


rule "Generate Score":
    @Event playerDealtDamage
    @Hero soldier
    
    if not (eventPlayer.isUlting and not eventAbility[0]):
        eventPlayer.ability1Array[2] += eventDamage * (1.15 if eventPlayer.ability1Array[0][0] == 1 else 1)
    if eventPlayer.ability1Array[2] >= 40:
        #reduce helper by 40 and increase score by 10
        eventPlayer.ability1Array[2] = floor(eventPlayer.ability1Array[2] - 40)
        eventPlayer.ability1Array[true] += 10
    if victim.isDead():
        eventPlayer.ability1Array[3]++
        eventPlayer.ability1Array[true] += 50 * (min(1.5 * eventPlayer.ability1Array[3], 10))


rule "Sprint and Primary Speed Changes":
    @Event eachPlayer
    @Hero soldier
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isFiringPrimaryFire()) == true
    @Condition eventPlayer.ability1Array[0][0] in [null, 2] == true
    
    if not eventPlayer.ability1Array[0][0]:
        if eventPlayer.isFiringPrimaryFire():
            eventPlayer.moveSpeed[false] -= 10
            waitUntil(not eventPlayer.isFiringPrimaryFire(), 999999995904)
            eventPlayer.moveSpeed[false] += 10
        else:
            eventPlayer.moveSpeed[false] += 10
            waitUntil(not eventPlayer.isUsingAbility1(), 999999995904)
            eventPlayer.moveSpeed[false] -= 10
    else:
        eventPlayer.moveSpeed[false] -= 25
        waitUntil(not eventPlayer.isUsingAbility1(), 999999995904)
        eventPlayer.moveSpeed[false] += 25


rule "-- TACTICALS --":
    @Delimiter
    


rule "Stim Shot":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.ability1Array[0][true] == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    
    heal(eventPlayer, eventPlayer, 50)
    eventPlayer.startHealingOverTime(eventPlayer, 2, 25)
    playEffect(getAllPlayers(), DynamicEffect.WIDOWMAKER_VENOM_MINE_EXPLOSION_SOUND, null, eventPlayer.getEyePosition(), 100)
    createEffect(getAllPlayers(), Effect.WINSTON_PRIMAL_RAGE, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[false] = getLastCreatedEntity()
    eventPlayer.moveSpeed[false] += 50
    for eventPlayer.i in range(0, 10, true):
        eventPlayer.moveSpeed[false] -= 5
        wait(0.2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 15)
    destroyEffect(eventPlayer.effects[0])


rule "Tac. Insertion":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.ability1Array[0][true] == 2
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    
    eventPlayer.ability2Array[false] = eventPlayer.getPosition()
    eventPlayer.ability2Array[true] = eventPlayer.getFacingDirection()
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, eventPlayer.ability2Array[0], 0.125)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.ORISA_HALT_TENDRIL, eventPlayer.ability2Array[0], eventPlayer.ability2Array[0] + 1.5 * Vector.UP)
    eventPlayer.effects[true] = getLastCreatedEntity()
    smallMessage(eventPlayer, "Tactical Insertion Placed")
    waitUntil(eventPlayer.isDead() or not entityExists(eventPlayer), 999999995904)
    eventPlayer.resurrect()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.ability2Array[0], 1)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.VIOLET, eventPlayer.ability2Array[0], 0.5)
    destroyEffect(eventPlayer.effects[0])
    destroyEffect(eventPlayer.effects[true])
    if eventPlayer.getHero() == Hero.SOLDIER:
        eventPlayer.teleport(eventPlayer.ability2Array[0])
        eventPlayer.setFacing(eventPlayer.ability2Array[true], Relativity.TO_WORLD)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 25)


rule "Flashbang":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.ability1Array[0][true] == [null]
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == false
    
    eventPlayer.forceButtonPress(Button.MELEE)
    createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, vect(false, true, true), directionFromAngles(0, max(-89, eventPlayer.getVerticalFacingAngle() - 45)), Relativity.TO_PLAYER, ModifyHealth.DAMAGE, Team.ALL, 60, 0.7, 3, DynamicEffect.CASSIDY_FLASHBANG_EXPLOSION, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION_SOUND, 0, 20, 0.5, 10, 1, 50)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 7)
    while eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE):
        wait(0.5)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE))


rule "Flashbang Blind and Burn":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventPlayer.ability1Array[0][true] == [null]
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != false
    @Condition eventAbility[0] == false
    @Condition eventDamage >= 40
    @Condition eventDamage <= 72
    
    victim.blindedFlashTimer += 1.5
    victim.setStatusEffect(eventPlayer, Status.BURNING, 2)
    victim.startDamageOverTime(eventPlayer, 1.5, 13.5)
    wait(1.5)


rule "-- SCORESTREAKS --":
    @Delimiter
    


rule "Glide Missiles":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.ability1Array[true] >= 850
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isUlting == false
    
    eventPlayer.ability1Array[true] -= 850
    eventPlayer.ultEffects[2] = []
    eventPlayer.isUlting = true
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setJumpEnabled(false)
    bigMessage(getAllPlayers(), "GLIDE MISSILES INBOUND")
    for eventPlayer.i in range(0, 4, true):
        if eventPlayer.isDead():
            break
        eventPlayer.ultArray[false] = mapData[true][mapData[0].index(__getCurrentMap__())] + 100 * Vector.UP
        eventPlayer.ultArray[true] = eventPlayer.getFacingDirection()
        eventPlayer.ultArray[2] = Vector.LEFT + Vector.RIGHT
        eventPlayer.setFacing(eventPlayer.getFacingDirection() + -10 * Vector.UP, Relativity.TO_WORLD)
        eventPlayer.ultChase1 = eventPlayer.ultArray[0] + Vector.DOWN
        createDummy(Hero.WRECKING_BALL, Team.ALL, eventPlayer.getSlot() + 6, eventPlayer.ultChase1, null)
        eventPlayer.dummyBot = getLastCreatedEntity()
        eventPlayer.dummyBot.owner = eventPlayer
        eventPlayer.dummyBot.startForcingPosition(eventPlayer.ultChase1)
        eventPlayer.dummyBot.startForcingName("{0}'s Missile".format(eventPlayer))
        eventPlayer.dummyBot.setInvisibility(Invis.ALL)
        eventPlayer.dummyBot.setStatusEffect(null, Status.PHASED_OUT, 99999)
        createProjectileEffect(getAllPlayers().exclude(eventPlayer) if entityExists(eventPlayer.dummyBot) else null, Projectile.PHARAH_ROCKET, null, eventPlayer.dummyBot.getPosition(), eventPlayer.getFacingDirection(), 0.8)
        eventPlayer.ultEffects[3] = getLastCreatedEntity()
        createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "◇", eventPlayer.getPosition(), 2.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN)
        eventPlayer.ultEffects[true].append(getLastCreatedText())
        for j in range(0, 6, true):
            eventPlayer.ultArray[3] = getPlayersInSlot(j, Team.ALL)
            if eventPlayer.ultArray[3] != eventPlayer:
                createInWorldText(eventPlayer if eventPlayer.isAlive() and evalOnce(eventPlayer.ultArray[3]).isAlive() and entityExists(evalOnce(eventPlayer.ultArray[3])) else null, "◇", evalOnce(eventPlayer.ultArray[3]).getPosition(), 2.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.RED if isInLoS(eventPlayer.ultChase1, evalOnce(eventPlayer.ultArray[3])) else Color.GRAY)
                eventPlayer.ultEffects[true].append(getLastCreatedText())
        chaseAtRate(eventPlayer.ultChase1, raycastHitPosition(eventPlayer.ultChase1, eventPlayer.ultChase1 + (eventPlayer.getFacingDirection() if eventPlayer.getFacingDirection().y < -0.5 else worldVector(vect(false, -0.5, 0.86), eventPlayer, Transform.ROTATION)), getAllPlayers(), eventPlayer, false), 20 * (0.5 + getTotalTimeElapsed() - evalOnce(getTotalTimeElapsed())))
        eventPlayer.startCamera((eventPlayer.ultChase1 - (eventPlayer.getFacingDirection() if eventPlayer.getFacingDirection().y < -0.5 else worldVector(vect(false, -0.5, 0.86), eventPlayer, Transform.ROTATION))) + eventPlayer.ultArray[2], eventPlayer.ultChase1 + eventPlayer.ultArray[2], 20)
        eventPlayer.thirdPersonCam = true
        wait(0.5)
        waitUntil(eventPlayer.ultChase1 == raycastHitPosition(eventPlayer.ultChase1, eventPlayer.ultChase1 + eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true) or not isInLoS(eventPlayer.dummyBot.getPosition(), eventPlayer.dummyBot.getPosition() + -2 * Vector.UP) and eventPlayer.dummyBot.getAltitude() < 2, 3)
        stopChasing(eventPlayer.ultChase1)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, null, eventPlayer.ultChase1, 1)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, null, eventPlayer.ultChase1, 100)
        playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION, null, eventPlayer.ultChase1, 1)
        playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION_SOUND, null, eventPlayer.ultChase1, 100)
        eventPlayer.dummyBot.owner = null
        for j in range(0, len(eventPlayer.ultEffects[true]), true):
            destroyInWorldText(eventPlayer.ultEffects[true][j])
        eventPlayer.ultArray[4] = getPlayersInRadius(eventPlayer.ultChase1, 8, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned()).filter(lambda x: not x.isDummy())
        damage(eventPlayer.ultArray[4], eventPlayer, 135)
        eventPlayer.ultArray[4].startDamageOverTime(eventPlayer, 3, 35)
        eventPlayer.ultArray[4].setStatusEffect(eventPlayer, Status.BURNING, 3)
        wait(0.25)
        eventPlayer.stopCamera()
    destroyEffect(eventPlayer.ultEffects[3])
    eventPlayer.setFacing(eventPlayer.ultArray[true], Relativity.TO_WORLD)
    eventPlayer.thirdPersonCam = false
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    wait(3)
    for i in range(0, len(eventPlayer.ultEffects[2]), true):
        destroyEffect(eventPlayer.ultEffects[2][i])
    eventPlayer.isUlting = false


rule "Glide Missiles Smoke/Camera Shake":
    @Event eachPlayer
    @Hero soldier
    @Condition entityExists(eventPlayer.dummyBot) == true
    @Condition eventPlayer.dummyBot.getHero() == Hero.WRECKING_BALL
    @Condition eventPlayer.isAlive() == true
    
    if len(eventPlayer.ultEffects[2]) < 16:
        createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, null, evalOnce(eventPlayer.ultChase1), true)
        eventPlayer.ultEffects[2].append(getLastCreatedEntity())
    for j in range(0, 16, true):
        wait(0.05)
        eventPlayer.ultArray[2] = vect(random.uniform(-1, 1), random.uniform(-0.25, 0.25), random.uniform(-1, 1))
        if eventPlayer.isDead():
            smallMessage(eventPlayer, "Connection Lost")
    wait(0.1)
    if ruleCondition:
        loop()


rule "Orbital Laser":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.ability1Array[true] >= 600
    @Condition eventPlayer.ability1Array[true] < 850
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isUlting == false
    
    eventPlayer.ability1Array[true] -= 600
    eventPlayer.isUlting = true
    bigMessage(getAllPlayers(), "Orbital Laser Inbound!")
    eventPlayer.ultArray[false] = worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION)
    eventPlayer.ultChase1 = eventPlayer.getPosition() + 2 * Vector.UP + eventPlayer.ultArray[0] * 5
    eventPlayer.ultArray[2] = []
    chaseAtRate(eventPlayer.ultChase1, eventPlayer.ultChase1 + eventPlayer.ultArray, 2.5 if len(eventPlayer.ultArray[2]) else 8)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, raycastHitPosition(eventPlayer.ultChase1, eventPlayer.ultChase1 + -30 * Vector.UP, null, eventPlayer, false), 4)
    eventPlayer.ultEffects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, raycastHitPosition(eventPlayer.ultChase1, eventPlayer.ultChase1 + -30 * Vector.UP, null, eventPlayer, false), 4)
    eventPlayer.ultEffects[true] = getLastCreatedEntity()
    eventPlayer.ultArray[true] = getTotalTimeElapsed() + 5
    while getTotalTimeElapsed() < eventPlayer.ultArray[true]:
        eventPlayer.ultArray[2] = getAllPlayers().exclude(eventPlayer).filter(lambda x: x.isAlive() and distance(vect(x.getPosition().x, false, x.getPosition().z), vect(eventPlayer.ultChase1.x, false, eventPlayer.ultChase1.z)) <= 4)
        damage(eventPlayer.ultArray[2], eventPlayer, 17.857)
        eventPlayer.ultArray[2].startDamageOverTime(eventPlayer, 1, 14.286)
        eventPlayer.ultArray[2].setStatusEffect(eventPlayer, Status.BURNING, true)
        wait(0.143)
    destroyEffect(eventPlayer.ultEffects)
    eventPlayer.isUlting = false


rule "Care Package":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.ability1Array[true] >= 350
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isUlting == false
    
    eventPlayer.ability1Array[true] -= 350
    eventPlayer.isUlting = true
    bigMessage(eventPlayer, "Care Package incoming")
    wait(2)
    eventPlayer.ultArray[false] = random.randint(false, 4)
    eventPlayer.ultArray[true] = ["+30% {0}fgF0424BFF>Damage Dealt".format(__holygrail___), "+50 {0}fgFFCC39FF>Armor".format(__holygrail___), "+200% {0}fg8AC740FF>Jump Height".format(__holygrail___), "{0}fg1982C5FF>Infinite Ammo".format(__holygrail___), "{0}fg6b4D95FF>Periodic invisibility".format(__holygrail___)][eventPlayer.ultArray[0]]
    bigMessage(eventPlayer, "Buff: {0}".format(eventPlayer.ultArray[true]))
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, [Color.RED, Color.ORANGE, Color.GREEN, Color.BLUE, Color.VIOLET][eventPlayer.ultArray[0]], eventPlayer.getPosition(), 1)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer.getPosition(), 100)
    if true:
        goto loc+[26, null, 4, 9, 13, 17][true + [null, 1, 2, 3, 4].index(eventPlayer.ultArray[0])]
        eventPlayer.setDamageDealt(130)
        wait(10)
        eventPlayer.setDamageDealt(100)
    else:
        eventPlayer.addHealthPool(Health.ARMOR, 50, true)
        eventPlayer.ultArray[2] = getLastCreatedHealthPool()
        wait(10)
        removeHealthPool(eventPlayer.ultArray[2])
    else:
        eventPlayer.setJumpVerticalSpeed(300)
        wait(10)
        eventPlayer.setJumpVerticalSpeed(100)
    else:
        eventPlayer.setAmmo(false, 9999)
        wait(10)
        eventPlayer.setAmmo(false, 30)
    else:
        for eventPlayer.i in range(0, 10, true):
            eventPlayer.setInvisibility(Invis.ALL)
            eventPlayer.disableHeroHud()
            wait(0.25)
            eventPlayer.setInvisibility(Invis.NONE)
            eventPlayer.enableHeroHud()
            wait(0.75)
    else:
    smallMessage(eventPlayer, "Buff worn off")
    eventPlayer.isUlting = false


rule "Enable/Disable Ult for Scorestreak":
    @Event eachPlayer
    @Hero soldier
    @Condition (eventPlayer.ability1Array[true] < 350 or eventPlayer.isUlting) == true
    @Condition eventPlayer.inSoldierMenu == false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltEnabled(false)
    waitUntil(not ((eventPlayer.ability1Array[true] < 350 or eventPlayer.isUlting) and not eventPlayer.inSoldierMenu), 999999995904)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    smallMessage(eventPlayer, "Scorestreaks available")


rule "--- SYMMETRA ---":
    @Delimiter
    


rule "Symmetra Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.SYMMETRA
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.hasTargetAbility = [true, 30]
    createEffect(getAllPlayers() if eventPlayer.ability1Array[3] else null, Effect.ECHO_CLONING, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[14] = getLastCreatedEntity()
    createEffect(getAllPlayers() if eventPlayer.ability1Array[3] else null, Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects[15] = getLastCreatedEntity()
    eventPlayer.heroInfo = ["Ability 1: Hardlight Essence0Ability 2: Holographic Film0Utimate: Photoglobe".split(null[0]), ["{0}txC0000000001E2E2>".format(__holygrail___), "{0}txC00000000028FCB>".format(__holygrail___), "{0}txC0000000003C732>".format(__holygrail___)], "Extract the essence of a targeted enemy.\nDamaging this essence damages the enemy.0After teleporting, gain increased mobility {0}".format("and invincibiity until you take damage.0Place an indestructible sentry that damages enemies.\nThe turret's shots chain between{0}".format(" enemies and stun enemies in its inner range.\nIt can target enemies' hard light essence.")).split(null[0])]


rule "Holographic Film":
    @Event eachPlayer
    @Hero symmetra
    #@Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != false
    
    while eventPlayer.getAbilityCooldown(Button.ABILITY_2):
        eventPlayer.ability1Array[true] = eventPlayer.getPosition()
        wait(0.05)
        if distance(eventPlayer.getPosition(), eventPlayer.ability1Array[true]) > 5:
            eventPlayer.ability1Chase = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 3, null, eventPlayer, false)
            startDamageModification(eventPlayer, getAllPlayers(), 0.01)
            eventPlayer.damageMods[false] = getLastDamageModification()
            eventPlayer.ability1Array[2] = eventPlayer.getHealth()
            eventPlayer.ability1Array[3] = true
            eventPlayer.moveSpeed[false] += 25
            eventPlayer.setJumpVerticalSpeed(125)
            wait(eventPlayer.getAbilityCooldown(Button.ABILITY_2))
            if eventPlayer.ability1Array[3]:
                eventPlayer.ability1Array[3] = false
                stopDamageModification(eventPlayer.damageMods[0])
                eventPlayer.moveSpeed[false] -= 25
                eventPlayer.setJumpVerticalSpeed(100)


rule "Remove Holographic Film":
    @Event playerTookDamage
    @Hero symmetra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != false
    @Condition eventPlayer.ability1Array[3] != false
    
    eventPlayer.ability1Array[3] = false
    stopDamageModification(eventPlayer.damageMods[0])
    eventPlayer.moveSpeed[false] -= 25
    eventPlayer.setJumpVerticalSpeed(100)


rule "Extracted Essence":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition entityExists(eventPlayer.targetAbility) == true
    
    #debug([eventPlayer.getSlot(), eventPlayer.dummyBot.getSlot()])
    eventPlayer.ability1Target = eventPlayer.targetAbility
    eventPlayer.ability1Array[false] = eventPlayer.ability1Target.getPosition() + 0.5 * vectorTowards(eventPlayer.ability1Target.getPosition(), eventPlayer.ability1Target.getEyePosition())
    eventPlayer.ability1Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability1Chase, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.45, null, eventPlayer, false), 999999995904)
    eventPlayer.ability2Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability2Chase, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.ability1Chase - eventPlayer.getFacingDirection() * distance(eventPlayer.ability1Chase, eventPlayer.ability1Array[0]) * (cosDeg(acosDeg(dotProduct(vectorTowards(eventPlayer.ability1Target, eventPlayer.ability1Chase), eventPlayer.getFacingDirection()) / magnitude(vectorTowards(eventPlayer.ability1Target, eventPlayer.ability1Chase))))), null, eventPlayer, false), 999999995904)
    eventPlayer.scale = null
    eventPlayer.ability1Array[2] = distance(eventPlayer, eventPlayer.ability1Target) / 45
    chaseOverTime(eventPlayer.scale, true, eventPlayer.ability1Array[2])
    createProjectileEffect(getAllPlayers(), Projectile.SYMMETRA_PHOTON_PROJECTOR, eventPlayer, ((true - eventPlayer.scale) ** 2) * eventPlayer.ability1Array[0] + (((2 * (true - eventPlayer.scale)) * eventPlayer.scale) * eventPlayer.ability2Chase) + eventPlayer.scale ** 2 * eventPlayer.ability1Chase if entityExists(eventPlayer.dummyBot) else vect(500, 500, 500), vect(sin(2 * getTotalTimeElapsed()), sin(0.5 * getTotalTimeElapsed()), cos(2 * getTotalTimeElapsed())), 0.04)
    eventPlayer.effects[false] = getLastCreatedEntity()
    #createEffect(eventPlayer, Effect.SPHERE, Color.AQUA, eventPlayer.ability1Chase, 0.3)
    eventPlayer.hasTargetAbility[false] = false
    createDummy(Hero.WRECKING_BALL, Team.ALL, eventPlayer.getSlot() + 6, eventPlayer.ability1Chase, null)
    eventPlayer.dummyBot = getLastCreatedEntity()
    eventPlayer.dummyBot.owner = eventPlayer
    eventPlayer.dummyBot.startForcingName("{0}'s essence".format(eventPlayer.ability1Target))
    eventPlayer.dummyBot.startScalingSize(0.3)
    eventPlayer.dummyBot.setStatusEffect(null, Status.PHASED_OUT, eventPlayer.ability1Array[2])
    eventPlayer.dummyBot.setStatusEffect(null, Status.UNKILLABLE, 999999995904)
    eventPlayer.dummyBot.startForcingPosition(eventPlayer.ability1Chase + Vector.DOWN * eventPlayer.ability1Array[2])
    eventPlayer.dummyBot.setMaxHealth(1)
    eventPlayer.dummyBot.addHealthPool(Health.SHIELDS, 400 - evalOnce(eventPlayer.dummyBot.getMaxHealth()), true)
    eventPlayer.dummyBot.setInvisibility(Invis.ALL)
    eventPlayer.forceButtonPress(Button.MELEE)
    wait(eventPlayer.ability1Array[2])
    eventPlayer.dummyBot.forceButtonPress(Button.SECONDARY_FIRE)
    stopChasing(eventPlayer.ability1Chase)
    stopChasing(eventPlayer.ability2Chase)
    eventPlayer.ability1Array[true] = ((true - eventPlayer.scale) ** 2) * eventPlayer.ability1Array[0] + (((2 * (true - eventPlayer.scale)) * eventPlayer.scale) * eventPlayer.ability2Chase) + eventPlayer.scale ** 2 * eventPlayer.ability1Chase
    waitUntil(eventPlayer.ability1Target.isDead() or not entityExists(eventPlayer.dummyBot), 4)
    playEffect(eventPlayer, DynamicEffect.TRACER_RECALL_REAPPEAR, Color.TEAM_1, eventPlayer.ability1Chase, 1)
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.TRACER_RECALL_REAPPEAR, Color.TEAM_2, eventPlayer.ability1Chase, 1)
    playEffect(getAllPlayers(), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR_SOUND, null, eventPlayer.ability1Chase, 100)
    eventPlayer.untargetablePlayers[eventPlayer.ability1Target.getSlot()] = getTotalTimeElapsed() + 10
    destroyEffect(eventPlayer.effects[0])
    eventPlayer.dummyBot.owner = null
    eventPlayer.dummyBot = null
    eventPlayer.hasTargetAbility[false] = true


rule "Essence Deal Damage":
    @Event playerTookDamage
    @Condition eventPlayer.owner.getHero() == Hero.SYMMETRA
    
    damage(eventPlayer.owner.ability1Target, eventPlayer.owner, 0.2 * eventDamage)
    if eventPlayer.getHealth() == 1:
        damage(eventPlayer.owner.ability1Target, eventPlayer.owner, 50)
        eventPlayer.owner = null


rule "Photoglobe":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    createInWorldText(eventPlayer, "Place  {0}  |".format(inputBindingString(Button.PRIMARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((-0.83 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.2)
    eventPlayer.inWorldTexts[false] = getLastCreatedText()
    createInWorldText(eventPlayer, "|  {0}  Cancel".format(inputBindingString(Button.SECONDARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.86 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.2)
    eventPlayer.inWorldTexts[true] = getLastCreatedText()
    eventPlayer.ability3Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability3Chase, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, null, eventPlayer, false) if raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, null, eventPlayer, false) != eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10 and (raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, null, eventPlayer, false)).y >= 0.2 else raycastHitPosition(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, null, eventPlayer, false), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, null, eventPlayer, false) + -1000 * Vector.UP, null, eventPlayer, false), 999999995904)
    createEffect(eventPlayer, Effect.SPHERE, Color.GRAY, eventPlayer.ability3Chase + 3 * Vector.UP, true)
    eventPlayer.effects[true] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.RING, Color.GRAY, eventPlayer.ability3Chase, 6)
    eventPlayer.effects[2] = getLastCreatedEntity()
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isDead(), 999999995904)
    destroyInWorldText(eventPlayer.inWorldTexts[0])
    destroyInWorldText(eventPlayer.inWorldTexts[true])
    destroyEffect(eventPlayer.effects[true])
    destroyEffect(eventPlayer.effects[2])
    stopChasing(eventPlayer.ability3Chase)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
        createEffect(getAllPlayers().exclude(eventPlayer), Effect.ECHO_CLONING, Color.TEAM_2, eventPlayer.ability3Chase + 2 * Vector.UP, true)
        eventPlayer.effects[true] = getLastCreatedEntity()
        createEffect(getAllPlayers().exclude(eventPlayer), Effect.WRECKING_BALL_ADAPTIVE_SHIELD_TARGET, Color.TEAM_2, eventPlayer.ability3Chase + 2 * Vector.UP, true)
        eventPlayer.effects[2] = getLastCreatedEntity()
        createEffect(eventPlayer, Effect.ECHO_CLONING, Color.TEAM_1, eventPlayer.ability3Chase + 2 * Vector.UP, true)
        eventPlayer.effects[3] = getLastCreatedEntity()
        createEffect(eventPlayer, Effect.WRECKING_BALL_ADAPTIVE_SHIELD_TARGET, Color.TEAM_1, eventPlayer.ability3Chase + 2 * Vector.UP, true)
        eventPlayer.effects[4] = getLastCreatedEntity()
        createEffect(getAllPlayers().exclude(eventPlayer), Effect.RING, Color.RED, eventPlayer.ability3Chase, 6)
        eventPlayer.effects[5] = getLastCreatedEntity()
        createEffect(eventPlayer, Effect.RING, Color.BLUE, eventPlayer.ability3Chase, 6)
        eventPlayer.effects[6] = getLastCreatedEntity()
        createEffect(getAllPlayers(), Effect.ZARYA_PARTICLE_BEAM_SOUND, null, eventPlayer.ability3Chase, 80)
        eventPlayer.effects[7] = getLastCreatedEntity()
        createProgressBarInWorldText(getAllPlayers().exclude(eventPlayer), eventPlayer.ultChase1, "{0}'s PHOTOGLOBE".format(eventPlayer), eventPlayer.ability3Chase + 3 * Vector.UP, 1, Clip.SURFACES, Color.RED)
        eventPlayer.iwtProgressBars[false] = getLastCreatedText()
        createProgressBarInWorldText(eventPlayer, eventPlayer.ultChase1, "{0}'s PHOTOGLOBE".format(eventPlayer), eventPlayer.ability3Chase + 3 * Vector.UP, 1, Clip.SURFACES, Color.BLUE)
        eventPlayer.iwtProgressBars[true] = getLastCreatedText()
        eventPlayer.isUlting = true
        eventPlayer.ultChase1 = 100
        chaseOverTime(eventPlayer.ultChase1, false, 20)
        bigMessage(getAllPlayers(), "{0}: {1}fg91BBD1FF>Photoglobe{1}/fg> Constructed!".format(heroIcon(Hero.SYMMETRA), __holygrail___))
        #debug([eventPlayer, eventPlayer.ability2Array[0], eventPlayer.ability2Array[1], eventPlayer.ability2Array[2]])
        while eventPlayer.ultChase1:
            while eventPlayer.ultChase1 and not entityExists(eventPlayer.ability2Array[0]):
                eventPlayer.ability2Array[false] = (sorted(getAllPlayers().filter(lambda player: isInLoS(player, eventPlayer.ability3Chase + 2 * Vector.UP) and player.isAlive() and not player.inCassShop and not player.inSoldierMenu and player != eventPlayer and (player == eventPlayer.dummyBot or not player.isDummy())), lambda x: distance(x, eventPlayer.ability3Chase)))[0]
                waitUntil(eventPlayer.isDead(), 0.2)
            eventPlayer.ability2Array[true] = (sorted(getAllPlayers().exclude(eventPlayer.ability2Array[0]).filter(lambda x: isInLoS(x, eventPlayer.ability2Array[0]) and distance(x, eventPlayer.ability2Array[0]) < 100 and x.isAlive() and not x.inCassShop and not x.inSoldierMenu and x != eventPlayer and (x == eventPlayer.dummyBot or not x.isDummy())), lambda x: distance(x, eventPlayer.ability2Array[0])))[0]
            eventPlayer.ability2Array[2] = (sorted(getAllPlayers().exclude([eventPlayer.ability2Array[true]]).filter(lambda x: isInLoS(x, eventPlayer.ability2Array[true]) and distance(x, eventPlayer.ability2Array[true]) < 100 and x.isAlive() and not x.inCassShop and not x.inSoldierMenu and x != eventPlayer and (x == eventPlayer.dummyBot or not x.isDummy())), lambda x: distance(x, eventPlayer.ability2Array[true])))[0]
            eventPlayer.ability2Array[3] = [eventPlayer.ability3Chase + 2 * Vector.UP, eventPlayer.ability2Array[0], eventPlayer.ability2Array[true], eventPlayer.ability2Array[2]]
            for eventPlayer.i in range(1, 4, true):
                if entityExists(eventPlayer.ability2Array[3][eventPlayer.i]):
                    eventPlayer.ultChase1 = max(eventPlayer.ultChase1 - 5, false)
                    createBeam(eventPlayer, Beam.WINSTON_TESLA_CANNON, eventPlayer.ability2Array[3][eventPlayer.i - true], eventPlayer.ability2Array[3][eventPlayer.i].getEyePosition(), Color.TEAM_1)
                    eventPlayer.effects[7 + eventPlayer.i] = getLastCreatedEntity()
                    createBeam(getAllPlayers().exclude(eventPlayer), Beam.WINSTON_TESLA_CANNON, eventPlayer.ability2Array[3][eventPlayer.i - true], eventPlayer.ability2Array[3][eventPlayer.i].getEyePosition(), Color.TEAM_2)
                    eventPlayer.effects[10 + eventPlayer.i] = getLastCreatedEntity()
                    playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, Color.TEAM_1, eventPlayer.ability2Array[3][eventPlayer.i], 1)
                    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, Color.TEAM_2, eventPlayer.ability2Array[3][eventPlayer.i], 1)
                    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR_SOUND, Color.TEAM_2, eventPlayer.ability2Array[3][eventPlayer.i], 100)
                    #100 at <=6, 50 at 50
                    damage(eventPlayer.ability2Array[3][eventPlayer.i], eventPlayer, (106.81 - (1.13 * (max(6, min(50, distance(eventPlayer.ability2Array[3][eventPlayer.i - true], eventPlayer.ability2Array[3][eventPlayer.i])))))) / eventPlayer.i ** 0.5)
                    #smallMessage(eventPlayer,
                    #(106.81 -1.13 * max(6, min(50, distance(eventPlayer.ability2Array[3][eventPlayer.i - 1], eventPlayer.ability2Array[3][eventPlayer.i]))))
                    #/ eventPlayer.i ** 0.5)
                    if distance(eventPlayer.ability2Array[3][eventPlayer.i], eventPlayer.ability3Chase) <= 6:
                        eventPlayer.ability2Array[3][eventPlayer.i].setStatusEffect(eventPlayer, Status.STUNNED, 0.5)
                    waitUntil(eventPlayer.isDead(), 0.2)
                else:
                    break
            for i in range(7, 14, true):
                destroyEffect(eventPlayer.effects[i])
            eventPlayer.ability2Array = [null, null, null]
            waitUntil(eventPlayer.isDead(), 0.4)
        playEffect(eventPlayer, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Color.TEAM_1, eventPlayer.ability3Chase + 2 * Vector.UP, 1)
        playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Color.TEAM_2, eventPlayer.ability3Chase + 2 * Vector.UP, 1)
        for i in range(1, 13, true):
            destroyEffect(eventPlayer.effects[i])
        destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[0])
        destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[true])
        eventPlayer.isUlting = false
    else:
        wait(0.5)
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)


rule "--- VEDETTA ---":
    @Delimiter
    


rule "Vendetta Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.VENDETTA
    
    eventPlayer.setMaxHealth(60)
    eventPlayer.addHealthPool(Health.NORMAL, 60, true)
    eventPlayer.setUltCharge(100)
    eventPlayer.ability1Array[true] = 5
    createInWorldText(eventPlayer if eventPlayer.isAlive() and not eventPlayer.isUsingAbility1() else null, "{0}txC00000000011E07> Leaps Left: {1}".format(__holygrail___, eventPlayer.ability1Array[true]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.02 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 31, 89, 125))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() and not eventPlayer.isUsingAbility1() else null, "{0}".format("□□□□□0■□□□□0■■□□□0■■■□□0■■■■□0■■■■■".split(null[0])[floor(eventPlayer.ability1Array[true])]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.15 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.125, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 31, 89, 125))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Ultimate: Incessant Strike0Passive 1: Wolf's Leap0Passive 2: Warrior's Sustenance".split(null[0]), [abilityIconString(Hero.VENDETTA, Button.ULTIMATE), "{0}txC00000000011E07>".format(__holygrail___), "{0}txC000000000039DD>".format(__holygrail___)], "Sundering Strike has a 12 second cooldown,\nbut it can't be charged past stage 1.(1.00, 0.00, 0.00)Gain 5 leaps that reset whe{0}".format("n you use an ability.(1.00, 0.00, 0.00)Blade damage heals you and causes 10% bleed damage").split(Vector.LEFT[0])]


rule "Air Jump":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    waitUntil(not (eventPlayer.isInAir() and not eventPlayer.isHoldingButton(Button.JUMP) and not [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any()), 999999995904)
    if eventPlayer.isInAir():
        if not eventPlayer.ability1Array[true]:
            return
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer.getPosition(), 1)
        eventPlayer.applyImpulse(Vector.UP, 6, Relativity.TO_WORLD)
        if eventPlayer.getThrottle()[0]:
            eventPlayer.applyImpulse(eventPlayer.getThrottle(), 3, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.moveSpeed[false] += 5
        eventPlayer.ability1Array[true]--


rule "Abilities Reset Jumps":
    @Event eachPlayer
    @Hero vendetta
    @Condition (eventPlayer.isOnGround() or eventPlayer.isUsingAbility2() or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 9.9) == true
    
    eventPlayer.moveSpeed[false] -= 5 * (5 - eventPlayer.ability1Array[true])
    eventPlayer.ability1Array[true] = 5


rule "Bleed and Heal":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility[0] != false
    
    victim.startDamageOverTime(eventPlayer, 2, eventDamage * 0.05)
    heal(eventPlayer, eventPlayer, 25)


rule "12 Second Ult":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.getUltCharge() < 100
    @Condition eventPlayer.getHero() == Hero.VENDETTA
    
    eventPlayer.ability1Array[false] = getTotalTimeElapsed()
    while not eventPlayer.isUsingUltimate() and eventPlayer.getUltCharge() < 100 and eventPlayer.getHero() == Hero.VENDETTA:
        eventPlayer.setUltCharge((100 * (getTotalTimeElapsed() - eventPlayer.ability1Array[0])) / 12)
        wait(0.125)


rule "Max Charge Ult":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.isUsingUltimate() == true
    
    bigMessage(getAllPlayers(), "{0}: Arriva la {1} {2}fgff1f6280>Punizione!{2}/fg>".format(heroIcon(Hero.VENDETTA), abilityIconString(Hero.VENDETTA, Button.ULTIMATE), __holygrail___))
    eventPlayer.setDamageReceived(50)
    wait(0.376)
    waitUntil(not eventPlayer.isUsingUltimate(), 0.9)
    if eventPlayer.isUsingUltimate():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.68)
    eventPlayer.setDamageReceived(100)


rule "--- VENTURE ---":
    @Delimiter
    


rule "Venture Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.VENTURE
    
    eventPlayer.setMaxHealth(50)
    eventPlayer.addHealthPool(Health.NORMAL, 100, true)
    eventPlayer.ability1Array[false] = 2
    eventPlayer.ability1Array[true] = null
    startDamageModification(eventPlayer, getAllPlayers().filter(lambda player: distance(player, eventPlayer) > 16), 30)
    eventPlayer.damageMods.append(getLastDamageModification())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0} Next charge in: {1}s".format(abilityIconString(Hero.VENTURE, Button.SECONDARY_FIRE), ceil(eventPlayer.ability1Chase)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.6 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.25 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(121, 97, 78))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "□□0■□0■■".split(null[0])[eventPlayer.ability1Array[0]], updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.89 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.14 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(121, 97, 78))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Secondary Fire: Enhanced Drill0Ability 1: Shockwave0Passive: Expedited Expedition".split(null[0]), [abilityIconString(Hero.VENTURE, Button.SECONDARY_FIRE), "{0}txC0000000000F445>".format(__holygrail___), "{0}txC00000000001310>".format(__holygrail___)], "Drill dash has 2 charges, and using burrow restores both.\nDrilling an enemy into a surface stuns and damages them.0Landing fr{0}".format("om a high place during burrow causes a shockwave\nthat damages and slows enemies.0Dealing damage with clobber greatly reduces {0}".format("cooldowns")).split(null[0])]


rule "Burrow Reset Drill Charges":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(0.688, Wait.ABORT_WHEN_FALSE)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999995904)
    if eventPlayer.isUsingAbility1():
        eventPlayer.ability1Array[false] = 2
        eventPlayer.ability1Chase = null


rule "Burrow Shockwave":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getAltitude() >= 3
    
    waitUntil(eventPlayer.isOnGround(), 999999995904)
    eventPlayer.ability1Array[3] = eventPlayer.getPosition()
    setSlowMotion(70)
    if eventPlayer.isUsingAbility1():
        for eventPlayer.i in range(0, 8, true):
            for eventPlayer.j in range(0, true + ((36 * (8 - eventPlayer.i)) / 8), true):
                playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_LEAP, null, eventPlayer.getPosition() + (eventPlayer.i * 2.5 * (directionFromAngles((360 / (true + ((36 * (8 - eventPlayer.i)) / 8))) * eventPlayer.j, 0))), 1)
            eventPlayer.ability1Array[4] = getAllPlayers().filter(lambda player: distance(eventPlayer.getPosition(), player) < 2.5 * eventPlayer.i + 2.5 and distance(eventPlayer.getPosition(), player) > 2.5 * eventPlayer.i - 2.5 and player != eventPlayer and not player.hasStatus(Status.PHASED_OUT) and not player.hasStatus(Status.ROOTED))
            eventPlayer.ability1Array[4].applyImpulse(Vector.UP, 8.5, Relativity.TO_WORLD)
            eventPlayer.ability1Array[4].setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(eventPlayer.ability1Array[4], eventPlayer, 60)
            wait((0.18 * (8 - eventPlayer.i)) / 8)
    setSlowMotion(100)


rule "Drill Recharge":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.ability1Array[0] < 2
    
    while eventPlayer.ability1Array[0] < 2:
        eventPlayer.ability1Chase = 8
        chaseAtRate(eventPlayer.ability1Chase, false, true)
        waitUntil(eventPlayer.ability1Chase == null, eventPlayer.ability1Chase)
        if eventPlayer.ability1Array[0] != 2:
            eventPlayer.ability1Array[false] = min(2, eventPlayer.ability1Array[0] + true)


rule "Drill Use Charge":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    if eventPlayer.ability1Array[0] != null:
        eventPlayer.ability1Array[false]--
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.5)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.89)
    if not eventPlayer.ability1Array[0]:
        eventPlayer.setSecondaryFireEnabled(false)
        waitUntil(eventPlayer.ability1Array[0] > null, 999999995904)
        eventPlayer.setSecondaryFireEnabled(true)


rule "Drill Extra Knockback":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setKnockbackDealt(150)
    #while ruleCondition:
    #if isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2):
    #eventPlayer.applyImpulse(eventPlayer.getVelocity(), 26.67, Relativity.TO_WORLD,
    #Impulse.CANCEL_CONTRARY_MOTION)
    #wait()
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 999999995904)
    #eventPlayer.applyImpulse(eventPlayer.getVelocity(), eventPlayer.getSpeed() * 0.5, Relativity.TO_WORLD,
    #Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setKnockbackDealt(100)


rule "Drill Wall Stun":
    @Event playerDealtKnockback
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.getHero() == Hero.VENTURE
    
    waitUntil(not isInLoS(victim.getPosition() + 0.5 * vectorTowards(victim.getPosition(), victim.getEyePosition()), victim.getPosition() + 0.5 * vectorTowards(victim.getPosition(), victim.getEyePosition()) + eventDirection * 1.5), 1)
    if not isInLoS(victim.getPosition() + 0.5 * vectorTowards(victim.getPosition(), victim.getEyePosition()), victim.getPosition() + 0.5 * vectorTowards(victim.getPosition(), victim.getEyePosition()) + eventDirection * 1.5):
        victim.applyImpulse(Vector.UP, 0.01, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        damage(victim, eventPlayer, 30)
        victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, true)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, Color.TEAM_1, victim.getPosition() + 0.5 * vectorTowards(victim.getPosition(), victim.getEyePosition()), 1)
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.TEAM_1, victim.getEyePosition(), 100)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 1)


rule "Expedited Expedition":
    @Event playerDealtDamage
    @Hero venture
    @Condition eventAbility == Button.MELEE
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - eventDamage / 35)
    eventPlayer.ability1Chase = max(false, eventPlayer.ability1Chase - eventDamage / 35)


rule "--- ANA ---":
    @Delimiter
    


rule "Ana Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ANA
    
    eventPlayer.ability1Array = []
    eventPlayer.scale = null
    eventPlayer.setMaxHealth(60)
    eventPlayer.addHealthPool(Health.SHIELDS, 150, true)
    eventPlayer.canGlide = [true, [Button.JUMP, Button.ABILITY_2, Button.SECONDARY_FIRE], 2.5, 30]
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    createInWorldText(eventPlayer if eventPlayer.isAlive() and distance(eventPlayer, sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)), lambda x: distance(eventPlayer, x))[0]) < 4.5 and not eventPlayer.ability1Array[0] and entityExists(sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)), lambda x: distance(eventPlayer, x))[0]) else null, "Crouch to pick up", sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)))[0], 2)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "ult usable" if eventPlayer.ability1Array[0] else "ult not usable", updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.LIME_GREEN if eventPlayer.ability1Array[0] else Color.RED)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.ability1Array[0] else null, "{0}: {1}s".format(abilityIconString(Hero.WINSTON, Button.ABILITY_1), ceil(eventPlayer.scale)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.25)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.ability1Array[0] else null, "{0}: throw {1}".format(inputBindingString(Button.PRIMARY_FIRE).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))]), eventPlayer.ability1Target), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.3 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Ability 1: Free Throw0Ability 2: Hops0Utimate: Slam Dunk".split(null[0]), ["{0}txC0000000000130B>".format(__holygrail___), "{0}txC0000000001E304>".format(__holygrail___), "{0}txC00000000017Ef8>".format(__holygrail___)], "Crouch to pick up a sleeping enemy, who you can throw.0Place a single-use jump pad for vertical movement.\nWhen anyone uses th{0}".format("e jump pad, heal and gain a speed boost.\nAdditionally, hold jump to glide.0Slam a carried enemy into the ground, causing\nAn e{0}".format("xplosion that instakills any enemy hit.")).split(null[0])]


rule "Instasleep Scope":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setProjectileSpeed(500)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 999999995904)
    wait(0.2)
    eventPlayer.setProjectileSpeed(100)


rule "Pick Up Enemy":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isCrouching() == true
    @Condition distance(eventPlayer, sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)), lambda x: distance(eventPlayer, x))[0]) < 4.5
    @Condition entityExists(sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)), lambda x: distance(eventPlayer, x))[0]) == true
    @Condition eventPlayer.scale == null
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.ability1Target[false] = sorted(getAllPlayers().exclude(eventPlayer).filter(lambda x: x.hasStatus(Status.ASLEEP)), lambda x: distance(eventPlayer, x))[0]
    if eventPlayer.ability1Target[0].getHero() in getTankHeroes():
        eventPlayer.ability1Target[0].setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 5)
    else:
        eventPlayer.ability1Target[0].setStatusEffect(eventPlayer, Status.ASLEEP, 5)
    eventPlayer.scale = 5
    chaseAtRate(eventPlayer.scale, false, true)
    eventPlayer.ability1Array[false] = true
    eventPlayer.ability1Target[0].attachTo(eventPlayer, 1.5 * Vector.UP)
    eventPlayer.moveSpeed[false] += 25
    waitUntil(not ([eventPlayer.isAlive(), not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), eventPlayer.scale > null, eventPlayer.ability1Target[0].hasStatus(Status.ASLEEP) or eventPlayer.ability1Target[0].hasStatus(Status.KNOCKED_DOWN)].all()), 5)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    stopChasing(eventPlayer.scale)
    eventPlayer.scale = null
    eventPlayer.ability1Array[false] = false
    eventPlayer.ability1Target[0].detach()
    eventPlayer.moveSpeed[false] -= 25
    if eventPlayer.isAlive() and (eventPlayer.ability1Target[0].hasStatus(Status.ASLEEP) or eventPlayer.ability1Target[0].hasStatus(Status.KNOCKED_DOWN)):
        eventPlayer.ability1Target[0].applyImpulse(eventPlayer.getFacingDirection(), 25, Relativity.TO_WORLD)


rule "Slam Dunk":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.ability1Array[0] != false
    
    eventPlayer.disablePlayerCollision()
    eventPlayer.scale = 10
    eventPlayer.ability1Target[0].setStatusEffect(eventPlayer, Status.ASLEEP, 10)
    eventPlayer.applyImpulse(Vector.UP, 20, Relativity.TO_WORLD)
    eventPlayer.canGlide = [true, [Button.JUMP], 2, 25]
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.ability1Target[0].isOnGround(), 999999995904)
    eventPlayer.stopForcingButton(Button.JUMP)
    bigMessage(getAllPlayers(), "{0}: {1}".format(heroIcon(Hero.ANA), random.choice("Skadoosh!0Boom Shakalaka!0The juice is loose.".split(null[0]))))
    waitUntil(eventPlayer.ability1Target[0].getAltitude() <= 0.1, 999999995904)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, Color.TEAM_1, eventPlayer.ability1Target[0], 1)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, Color.TEAM_1, eventPlayer.ability1Target[0], 100)
    kill((getPlayersInRadius(eventPlayer.ability1Target[0], 15, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned()).filter(lambda x: not x.hasStatus(Status.PHASED_OUT))).exclude(eventPlayer), eventPlayer)
    eventPlayer.setUltCharge(false)
    eventPlayer.enablePlayerCollision()


rule "Jump Pad":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    @Condition eventPlayer.isOnGround() == true
    
    if eventPlayer.ability1Array[2]:
        destroyEffect(eventPlayer.effects)
    eventPlayer.ability1Array[true] = eventPlayer.getPosition() + worldVector(0.8 * Vector.FORWARD, eventPlayer, Transform.ROTATION)
    createEffect(getAllPlayers(), Effect.RING, Color.LIME_GREEN, eventPlayer.ability1Array[true], 0.75)
    eventPlayer.effects[false] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.LUCIO_SOUND_BARRIER_PROTECTED, Color.TEAM_1, eventPlayer.ability1Array[true], 0.75)
    eventPlayer.effects[true] = getLastCreatedEntity()
    wait(0.2)
    eventPlayer.ability1Array[2] = true
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)


rule "Tri\zgger Jump Pad":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.ability1Array[2] != false
    @Condition eventPlayer.ability1Array[true] != false
    @Condition distance(eventPlayer.ability1Array[true], sorted(getLivingPlayers(Team.ALL).filter(lambda player: player.hasSpawned()), lambda x: distance(x, eventPlayer.ability1Array[true]))[0]) < 0.8
    
    sorted(getLivingPlayers(Team.ALL).filter(lambda player: player.hasSpawned()), lambda x: distance(x, eventPlayer.ability1Array[true]))[0].applyImpulse(Vector.UP, 20, Relativity.TO_WORLD)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, null, eventPlayer.ability1Array[true], 100)
    destroyEffect(eventPlayer.effects)
    eventPlayer.ability1Array[2] = false
    eventPlayer.ability1Array[true] = null
    eventPlayer.startHealingOverTime(eventPlayer, 2, 50)
    eventPlayer.moveSpeed[false] += 50
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) < 2:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 2)
    wait(2)
    eventPlayer.moveSpeed[false] -= 50


rule "--- BRIGITTE ---":
    @Delimiter
    


rule "Brigitte Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.BRIGITTE
    
    eventPlayer.ability1Array = [null, [vect(0.65, -0.4, 0.6), vect(-0.65, -0.4, 0.6), vect(0.65, -1.2, 0.6), vect(-0.65, -1.2, 0.6), vect(0.65, 0.4, 0.6), vect(-0.65, 0.4, 0.6)], null, 3, false]
    eventPlayer.ability3Chase = 100
    stopChasing(eventPlayer.ability3Chase)
    eventPlayer.setHealingReceived(50)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC00000000004EA2> Jetpack Fuel: {1}%".format(__holygrail___, floor(eventPlayer.ability3Chase)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.77 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(173, 90, 95))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}".format("□□□□□□□□0■□□□□□□□0■■□□□□□□0■■■□□□□□0■■■■□□□□0■■■■■□□□0■■■■■■□□0■■■■■■■□0■■■■■■■■".split(null[0])[floor(eventPlayer.ability3Chase / 12.5)]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.9 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2.125, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(173, 90, 95))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive: Jetpack0Ability 1: Whip Hook0Secondary Fire: Rocket Shield".split(null[0]), ["{0}txC00000000004EA2>".format(__holygrail___), "{0}txC00000000003381>".format(__holygrail___), "{0}txC00000000003FD1>".format(__holygrail___)], "Equip a jetpack that grants you limited flight.0Whip shot pulls enemies to you.0Shield Bash has 3 charges.\nWhen shield bashin{0}".format("g, attach a rocket to your shield, up to 6.\nEach rocket increases your shield bash speed and explodes upon impact.\nWhen bashi{0}".format("ng with 6 rockets, launch them all forward with x3 explosion damage.")).split(null[0])]


rule "Whip Hook":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_1
    
    eventPlayer.ability2Array[false] = eventPlayer.getPosition() + worldVector(0.5 * Vector.FORWARD, eventPlayer, Transform.ROTATION)
    eventPlayer.ability2Array[true] = directionTowards(victim.getPosition(), eventPlayer.ability2Array[0])
    eventPlayer.ability1Chase = victim.getPosition()
    chaseAtRate(eventPlayer.ability1Chase, eventPlayer.ability2Array[0], 30)
    while eventPlayer.ability1Chase != eventPlayer.ability2Array[0] and distance(victim, eventPlayer) > 1:
        victim.setStatusEffect(eventPlayer, Status.ROOTED, 0.1)
        victim.applyImpulse(eventPlayer.ability2Array[true], 30, Relativity.TO_WORLD)
        wait(false)
    victim.applyImpulse(victim.getVelocity(), -0.01, Relativity.TO_WORLD)


rule "On Death / Add- / Launch Rockets":
    @Event eachPlayer
    @Hero brigitte
    @Condition (eventPlayer.isDead() or eventPlayer.isFiringPrimaryFire() and eventPlayer.isFiringSecondaryFire()) == true
    
    if eventPlayer.isDead():
        for i in range(0, eventPlayer.ability1Array[0], true):
            destroyEffect(eventPlayer.effects[i])
        eventPlayer.ability1Array[false] = null
        eventPlayer.ability1Array[3] = 3
        return
    eventPlayer.setAbilityCharge(Button.ABILITY_2, eventPlayer.getAbilityCharge(Button.ABILITY_2) - true)
    eventPlayer.ability1Array[3] = eventPlayer.getAbilityCharge(Button.ABILITY_2)
    eventPlayer.ability1Array[2] = eventPlayer.ability1Array[0] + true
    eventPlayer.moveSpeed[false] += 10 * eventPlayer.ability1Array[2]
    if eventPlayer.ability1Array[0] < 6:
        createProjectileEffect(getAllPlayers() if eventPlayer.isFiringSecondaryFire() else null, Projectile.PHARAH_ROCKET, getAllPlayers(), updateEveryFrame(eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][evalOnce(eventPlayer.ability1Array[0])], eventPlayer, Transform.ROTATION)), updateEveryFrame(eventPlayer.getFacingDirection()))
        eventPlayer.effects[eventPlayer.ability1Array[0]] = getLastCreatedEntity()
        eventPlayer.ability1Array[false]++
    else:
        for i in range(0, eventPlayer.ability1Array[0], true):
            destroyEffect(eventPlayer.effects[i])
            createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][i], eventPlayer, Transform.ROTATION), eventPlayer.getFacingDirection(), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, 45, 0.8, 3, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION_SOUND, 0, 80, 1.5)
        eventPlayer.ability1Array[false] = null
    waitUntil(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > null, 999999995904)
    eventPlayer.moveSpeed[false] -= 10 * eventPlayer.ability1Array[2]
    if eventPlayer.getAbilityCharge(Button.ABILITY_2):
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, false)
    else:
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.ability2Chase)


rule "Track Repair Pack Cooldown":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getAbilityCharge(Button.ABILITY_2) < 3
    
    eventPlayer.ability2Chase = 4
    chaseAtRate(eventPlayer.ability2Chase, false, true)
    wait(eventPlayer.ability2Chase)
    stopChasing(eventPlayer.ability2Chase)
    if ruleCondition:
        loop()


rule "Shield Bash Impact":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    #wait(0.19, Wait.ABORT_WHEN_FALSE)
    for i in range(0, eventPlayer.ability1Array[0], true):
        destroyEffect(eventPlayer.effects[i])
        playEffect(eventPlayer, DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION, Color.TEAM_1, eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][i], eventPlayer, Transform.ROTATION), 1)
        playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION, Color.TEAM_2, eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][i], eventPlayer, Transform.ROTATION), 1)
        playEffect(getAllPlayers(), DynamicEffect.PHARAH_ROCKET_LAUNCHER_EXPLOSION_SOUND, Color.TEAM_2, eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][i], eventPlayer, Transform.ROTATION), 80)
        damage((getPlayersInRadius(eventPlayer.getEyePosition() + worldVector(eventPlayer.ability1Array[true][i], eventPlayer, Transform.ROTATION), 3.5, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer), eventPlayer, 15)
    eventPlayer.ability1Array[false] = null
    if eventPlayer.getAbilityCharge(Button.ABILITY_2) == 3 or eventPlayer.getAbilityCharge(Button.ABILITY_2) > eventPlayer.ability1Array[3]:
        eventPlayer.setAbilityCharge(Button.ABILITY_2, eventPlayer.getAbilityCharge(Button.ABILITY_2) - true)
        eventPlayer.ability1Array[3] = eventPlayer.getAbilityCharge(Button.ABILITY_2)


rule "Jetpack Effect":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.ability3Chase > null
    @Condition eventPlayer.getAltitude() > 0.6
    
    createBeam(getAllPlayers(), Beam.MOIRA_COALESCENCE, eventPlayer.getPosition() + worldVector(vect(-0.3, 0.3, -0.3), eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + worldVector(vect(-0.3, -0.6, -0.4), eventPlayer, Transform.ROTATION))
    eventPlayer.effects[6] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.MOIRA_COALESCENCE, eventPlayer.getPosition() + worldVector(vect(0.3, 0.3, -0.3), eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + worldVector(vect(0.3, -0.6, -0.4), eventPlayer, Transform.ROTATION))
    eventPlayer.effects[7] = getLastCreatedEntity()
    eventPlayer.setGravity(false)
    eventPlayer.moveSpeed[false] += 30
    eventPlayer.startAcceleration(Vector.UP, 10, 4, Relativity.TO_WORLD)
    stopChasing(eventPlayer.ability3Chase)
    chaseAtRate(eventPlayer.ability3Chase, false, 40)
    eventPlayer.ability1Array[4] = true
    waitUntil(not (eventPlayer.isAlive() and eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.ability3Chase > null and eventPlayer.getAltitude() > 0.6), 999999995904)
    eventPlayer.setGravity(100)
    eventPlayer.moveSpeed[false] -= 30
    eventPlayer.stopAcceleration()
    stopChasing(eventPlayer.ability3Chase)
    eventPlayer.ability1Array[4] = false
    destroyEffect(eventPlayer.effects[6])
    destroyEffect(eventPlayer.effects[7])


rule "Jetpack Recharge":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.ability1Array[4] == false
    @Condition eventPlayer.ability3Chase < 100
    
    waitUntil(not (not eventPlayer.ability1Array[4] and eventPlayer.ability3Chase < 100), 1)
    if not eventPlayer.ability1Array[4] and eventPlayer.ability3Chase < 100:
        chaseAtRate(eventPlayer.ability3Chase, 100, 25)
        waitUntil(not (not eventPlayer.ability1Array[4] and eventPlayer.ability3Chase < 100), 999999995904)


rule "--- ILLARI ---":
    @Delimiter
    


rule "Illari Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ILLARI
    
    eventPlayer.ability1Array = [[], null, null]
    eventPlayer.scale = 10
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.canGlide = [true, [Button.SECONDARY_FIRE, Button.JUMP, Button.ABILITY_2, Button.ABILITY_1], 3, 50]
    createProjectileEffect(getAllPlayers() if eventPlayer.canGlide[4] else null, Projectile.MERCY_CADUCEUS_BLASTER, getAllPlayers(), updateEveryFrame(eventPlayer.getPosition() + 0.3 * Vector.UP), null, 0.2)
    eventPlayer.effects.append(getLastCreatedEntity())
    for i in range(0, 3, true):
        #createInWorldText(eventPlayer if eventPlayer.ability1Array[0][evalOnce(i)] else null, iconString(Icon.FIRE), eventPlayer.ability1Array[0][evalOnce(i)],
        #2.5)
        createEffect(getAllPlayers() if eventPlayer.ability1Array[0][evalOnce(i)] else null, Effect.TORBJORN_OVERLOADING, Color.TEAM_2, eventPlayer.ability1Array[0][evalOnce(i)], true)
        eventPlayer.effects.append(getLastCreatedEntity())
        createProjectileEffect(getAllPlayers() if eventPlayer.ability1Array[0][evalOnce(i)] else null, Projectile.BASTION_TACTICAL_GRENADE, null, eventPlayer.ability1Array[0][evalOnce(i)] + -0.23 * Vector.UP, Vector.DOWN)
        eventPlayer.effects.append(getLastCreatedEntity())
    createInWorldText(eventPlayer if sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] else null, "﹀", Vector.UP * (1.2 + 0.5 * (sin(3 * getTotalTimeElapsed()))) + sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0], 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] else null, inputBindingString(Button.ABILITY_1).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))]), Vector.UP * (0.8 + 0.5 * (sin(3 * getTotalTimeElapsed()))) + sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0], 1.5)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createEffect(eventPlayer if sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] else null, Effect.WRECKING_BALL_PILEDRIVER_FIRE, Color.TEAM_1, sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0], true)
    eventPlayer.effects.append(getLastCreatedEntity())
    #0, -1.1, 2,
    #rgb(235, 180, 52))
    #eventPlayer.inWorldTexts.append(getLastCreatedText())
    #startDamageModification(getAllPlayers(), eventPlayer, 100 + 5 * len(eventPlayer.ability1Array[0]))
    #eventPlayer.damageMods.append(getLastDamageModification())
    eventPlayer.heroInfo = ["Passive: Sun rider0Ability 1: Solar Rift0Ability 2: Micronova".split(null[0]), ["{0}txC000000000402CD>".format(__holygrail___), "{0}txC00000000047DD2>".format(__holygrail___), "{0}txC0000000000130A>".format(__holygrail___)], "Hold jump to glide.\nDamaging enemies while gliding burns them\nand decreases your cooldowns.0Meleeing the ground creates a sol{0}".format("ar rift, up to 3.\nUsing outburst teleports you to a selected rift.0Send out a projectile that knocks up and burns enemies.\nHi{0}".format("tting yourself boosts you upwards (Hold jump to go higher).")).split(null[0])]


rule "Create Rift":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isMeleeing() == true
    
    waitUntil(not isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5) and (raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5, null, eventPlayer, false)).y >= 0.86, 1)
    if isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5):
        return
    eventPlayer.ability1Array[false].append(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5, null, eventPlayer, false))
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT, Color.TEAM_1, eventPlayer.ability1Array[0].last(), 1)
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, Color.TEAM_2, eventPlayer.ability1Array[0].last(), 100)
    while len(eventPlayer.ability1Array[0]) > 3:
        del eventPlayer.ability1Array[false][false]
        wait(false)
    wait(2)


rule "TP to Rift":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != false
    @Condition sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] != false
    
    eventPlayer.teleport(sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0])
    wait(false)
    eventPlayer.ability1Array[false].remove(sorted(eventPlayer.ability1Array[0], lambda x: distance(eventPlayer, x))[0])
    waitUntil(not eventPlayer.getAbilityCooldown(Button.ABILITY_1), 999999995904)


rule "Enable/disable Outburst":
    @Event eachPlayer
    @Hero illari
    @Condition sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] != false
    @Condition eventPlayer.getHero() == Hero.ILLARI
    
    eventPlayer.setAbility1Enabled(true)
    waitUntil(not (sorted(eventPlayer.ability1Array[0], lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x)))[0] and eventPlayer.getHero() == Hero.ILLARI), 999999995904)
    eventPlayer.setAbility1Enabled(false)


rule "Micronova":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 7)
    eventPlayer.ability1Array[true] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)
    eventPlayer.ability1Array[2] = (raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)).y >= 0.86
    eventPlayer.ability1Chase = eventPlayer.getEyePosition()
    chaseAtRate(eventPlayer.ability1Chase, eventPlayer.ability1Array[true], 35)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ORANGE, eventPlayer.ability1Chase, 0.3)
    eventPlayer.effects[12] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ORANGE, eventPlayer.ability1Chase, 0.4)
    eventPlayer.effects[13] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SMOKE_SOUND, Color.ORANGE, eventPlayer.ability1Chase, 100)
    eventPlayer.effects[14] = getLastCreatedEntity()
    wait((distance(eventPlayer.getEyePosition(), evalOnce(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)))) / 35)
    eventPlayer.ability1Target = getPlayersInRadius(eventPlayer.ability1Chase, 6, Team.ALL, LosCheck.SURFACES_AND_ALL_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned()).filter(lambda x: not x.hasStatus(Status.PHASED_OUT))
    for i in range(0, len(eventPlayer.ability1Target), true):
        if eventPlayer.ability1Target[i] == eventPlayer:
            eventPlayer.applyImpulse(Vector.UP, 15 + (5 * (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.JUMP))), Relativity.TO_WORLD)
        else:
            eventPlayer.ability1Target[i].applyImpulse(Vector.UP, 12, Relativity.TO_WORLD)
            eventPlayer.ability1Target[i].startDamageOverTime(eventPlayer, 2.5, 20)
            eventPlayer.ability1Target[i].setStatusEffect(eventPlayer, Status.BURNING, 2.5)
            eventPlayer.ability1Target[i].setStatusEffect(eventPlayer, Status.ROOTED, 1.5)
    playEffect(getAllPlayers(), DynamicEffect.BAPTISTE_BIOTIC_LAUNCHER_EXPLOSION, Color.TEAM_2, eventPlayer.ability1Chase, 1)
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, Color.TEAM_1, eventPlayer.ability1Chase, 100)
    #if eventPlayer.ability1Array[2]:
    #eventPlayer.ability1Array[0].append(eventPlayer.ability1Array[1])
    destroyEffect(eventPlayer.effects[12])
    destroyEffect(eventPlayer.effects[13])
    destroyEffect(eventPlayer.effects[14])


rule "Cleanse Root if Grounded":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.BURNING) == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.clearStatusEffect(Status.ROOTED)


rule "Sun Rider Burn":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventPlayer.canGlide[4] != false
    @Condition eventAbility in [Button.ULTIMATE, null] == false
    
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, null, victim.getEyePosition(), 100)
    playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT, null, victim.getEyePosition(), 1)
    victim.setStatusEffect(eventPlayer, Status.BURNING, 0.75)
    victim.startDamageOverTime(eventPlayer, 0.75, 40 + 40 * eventWasCriticalHit)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - true - eventWasCriticalHit)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - true - eventWasCriticalHit)
    wait(0.6)


rule "--- JUNO ---":
    @Delimiter
    


rule "Juno Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.JUNO
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    #horizontal angle, vertical angle, magnitude
    eventPlayer.ability1Array[false] = "\u0001\u001f\u0003\u001a<\u0001\u001b^0\u0001\u001f\u0003(<\u0001*\u0002\u00050\u0001\u001f\u0003*<\u0001\u001c\u0093\u00040\u0001\u001f\u0003\u0083<\u0001\u0083\u008e\u00040\u0001\u001f\u0003\u0084<\u0001)\u009c\u00040\u0001\u001f\u0003:<\u0001\u0085¡\u00040\u0001\u001f\u0003:<\u0001.?0\u0001\u001f\u0003\u001a<\u0001&~0\u0001\u0092\u0002\u001a<\u0001\u0015\u0095\u00030\u0001\u0083\u0002'<\u0001\u0015\u0086\u00030\u0001_\u0002\u001a<\u0001\n^\u00030\u0001~\u0003\u001a<\u0001\u0015\u0095\u00030\u0001\u008d\u0003'<\u0001\u0015\u0086{0}".format("\u00030\u0001\u0097\u0003\u001a<\u0001\n^\u00030\u0001\u0083\u0001\u001a<\u0001\u0001\u001f0\u0001\u0083\u0001\u001c<\u0001\u0001\u001f0\u0001\u001f\u0001\u001a<\u0001\u0001\u001f0\u0001\u001f\u0001\u001c<\u0001\u0001\u001f0\u0001\u0001\u0002\u001a<\u0001\u0001Q0\u0001\u0001\u0001\u001a<\u0001\u0001Q").split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(0.01 * x.last().strIndex(x[0].charAt(0)) + x.last().strIndex(x[0].charAt(1)) + 100 * x.last().strIndex(x[0].charAt(2)), 0.01 * x.last().strIndex(x[0].charAt(6)) + x.last().strIndex(x[0].charAt(7)) + 100 * x.last().strIndex(x[0].charAt(8)), 0.01 * x.last().strIndex(x[0].charAt(3)) + x.last().strIndex(x[0].charAt(4)) + 100 * x.last().strIndex(x[0].charAt(5))) - vect(50, 50, 50))
    eventPlayer.ability1Array[true] = eventPlayer.getFacingDirection() * 2
    eventPlayer.ability1Array[2] = false
    eventPlayer.ability1Array[3] = 1
    eventPlayer.ability1Array[4] = null
    eventPlayer.ability1Array[5] = [null, 350]
    eventPlayer.ability1Chase = eventPlayer.getPosition()
    eventPlayer.ability2Chase = null
    startDamageModification(getAllPlayers().filter(lambda player: player.getEyePosition().y < eventPlayer.getPosition().y), eventPlayer if eventPlayer.ability1Array[3] >= 9 else null, 110)
    eventPlayer.damageMods[false] = getLastDamageModification()
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.ability1Array[9], true)
    createProgressBarInWorldText(eventPlayer if eventPlayer.isAlive() else null, 100 * eventPlayer.ability1Array[4] / eventPlayer.ability1Array[5][eventPlayer.ability1Array[3]], "Level {0}: {1} / {2} XP".format(eventPlayer.ability1Array[3], eventPlayer.ability1Array[4], eventPlayer.ability1Array[5][eventPlayer.ability1Array[3]]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, Color.YELLOW)
    eventPlayer.iwtProgressBars.append(getLastCreatedText())
    chaseAtRate(eventPlayer.ability1Chase, updateEveryFrame(eventPlayer.getPosition() + eventPlayer.ability1Array[true] + (Vector.UP * (1.2 + 0.8 * sin(getTotalTimeElapsed())))), max(3, distance(eventPlayer.ability1Chase, eventPlayer)))
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.getHorizontalFacingAngle() if entityExists(raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)) or angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.ability1Chase)) > 25 else horizontalAngleOfDirection(directionTowards(eventPlayer.ability1Chase, eventPlayer.getEyePosition())), 360)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, eventPlayer.ability1Chase, 0.25)
    eventPlayer.effects[false] = getLastCreatedEntity()
    for i in range(0, 20, true):
        if i < 13:
            if not i in [7, 10]:
                createBeam(getAllPlayers(), Beam.MERCY_HEAL, eventPlayer.ability1Chase + (eventPlayer.ability1Array[0][evalOnce(i)].z * (directionFromAngles(eventPlayer.ability2Chase + eventPlayer.ability1Array[0][evalOnce(i)].x, eventPlayer.ability1Array[0][evalOnce(i)].y))), eventPlayer.ability1Chase + (((eventPlayer.ability1Array[0][evalOnce(i + true)]).z) * (directionFromAngles(eventPlayer.ability2Chase + ((eventPlayer.ability1Array[0][evalOnce(i + true)]).x), (eventPlayer.ability1Array[0][evalOnce(i + true)]).y))), Color.YELLOW)
        elif 13 < i and i < 17:
            if not i in [13, 15]:
                createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.ability1Chase + (eventPlayer.ability1Array[0][evalOnce(i)].z * (directionFromAngles(eventPlayer.ability2Chase + eventPlayer.ability1Array[0][evalOnce(i)].x, eventPlayer.ability1Array[0][evalOnce(i)].y))), eventPlayer.ability1Chase + (((eventPlayer.ability1Array[0][evalOnce(i + true)]).z) * (directionFromAngles(eventPlayer.ability2Chase + ((eventPlayer.ability1Array[0][evalOnce(i + true)]).x), (eventPlayer.ability1Array[0][evalOnce(i + true)]).y))))
        elif i in [18, 19]:
            createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, eventPlayer.ability1Chase + (eventPlayer.ability1Array[0][evalOnce(i)].z * (directionFromAngles(eventPlayer.ability2Chase + eventPlayer.ability1Array[0][evalOnce(i)].x, eventPlayer.ability1Array[0][evalOnce(i)].y))), 0.07)
        eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.heroInfo = ["Role: Monster Trainer0Passive: Pilakchu's Power0Passive: EXPERIENCE".split(null[0]), ["{0}txC00000000032720>".format(__holygrail___), "{0}txC0000000001F927>".format(__holygrail___), ""], ["Train your martian pet Pilakchu to help you in combat!", "\n{0}txC0000000003AE1D> Level 1: Pilakchu follows you around but doesn't attack\n\nReset to the nearest checkpoint (starred) lev{1}".format(__holygrail___, "el upon death\nPress interact to cycle through level details"), "Dealing damage generates XP that levels up Pilakchu "]]
    eventPlayer.ability1Array[6] = "* Level 1: Pilakchu follows you around but doesn't attack\uec51* Level 2 - Spark: Pilakchu fires spark at the end of each shot\uec51* L{0}".format("evel 3 - Bolt Strike (Secondary Fire): Summon lightning at a targeted enemy's position\uec51Level 4: Bolt Strike's cast time and c{0}".format("ooldown reduced by 35%\uec51* Level 5: Spark slows enemies by 35% for 0.35 seconds\uec51Level 6 - Static: +25 HP; 4% chance to stun an {0}".format("enemy when taking damage\uec51* Level 7: Pilakchu fires two sparks per shot\uec51Level 8: Bolt Strike stuns enemies for 0.7s\uec51* Level 9 {0}".format("- Rising Voltage: Gain free flight permanently; deal 10% more to enemies below you\uec51* Level 10: Pilakchu's spark auto-locks on{0}".format("to enemies\uec51Level 11+: Gain 25 HP and 10% pilakchu damage with each level"))))).split("\uec51")
    eventPlayer.ability1Array[7] = eventPlayer.ability1Array[6][0]
    eventPlayer.ability1Array[8] = [1, 2, 3, 5, 7, 9, 10]
    eventPlayer.ability1Array[9] = 25


rule "Cycle Hero Info":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.showHud != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isCrouching() == false
    
    eventPlayer.ability1Array[7] = eventPlayer.ability1Array[6][(eventPlayer.ability1Array[6].index(eventPlayer.ability1Array[7]) + true) % len(eventPlayer.ability1Array[6])]
    eventPlayer.heroInfo[2] = eventPlayer.heroInfo[2].slice(false, true).concat(["\n{0}\n\nReset to the nearest checkpoint (Starred) level upon death\nPress interact to cycle through level details".format(eventPlayer.ability1Array[7])]).concat(eventPlayer.heroInfo[2].slice(true + true, 999999995904))


rule "Speed Ring During Flight":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.flight[true] += 2.8
    wait(4)
    eventPlayer.flight[true] -= 2.8


rule "Change Pilakchu Stray Location":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.ability1Array[true] = directionFromAngles(random.randint(true, 360), 0) * random.uniform(1.5, 3)
    wait(10)
    if eventPlayer.isAlive() and eventPlayer.getHero() == Hero.JUNO:
        loop()


rule "Dealt Damage / Level Up":
    @Event playerDealtDamage
    @Hero juno
    
    eventPlayer.ability1Array[4] += round(eventDamage)
    if eventPlayer.ability1Array[4] >= eventPlayer.ability1Array[5][eventPlayer.ability1Array[3]]:
        eventPlayer.ability1Array[4] -= eventPlayer.ability1Array[5][eventPlayer.ability1Array[3]]
        eventPlayer.ability1Array[3]++
        eventPlayer.heroInfo[2] = (eventPlayer.heroInfo[2].slice(false, true).concat(["\n{0}\n\nReset to the nearest checkpoint (Starred) level upon death\nPress interact to cycle through level details\n".format(eventPlayer.ability1Array[6][min(10, eventPlayer.ability1Array[3] - true)])])).concat(eventPlayer.heroInfo[2].slice(true + true, 999999995904))
        eventPlayer.ability1Array[5] = (eventPlayer.ability1Array[5].slice(false, eventPlayer.ability1Array[3]).concat([350 + (175 * (eventPlayer.ability1Array[3] - true))])).concat(eventPlayer.ability1Array[5].slice(eventPlayer.ability1Array[3] + true, 999999995904))
        bigMessage(eventPlayer, "{0}FGFFFF00FF>Level Up!".format(__holygrail___))
        if true:
            goto loc+[9, null, 3, 7][true + [3, 6, 9].index(eventPlayer.ability1Array[3])]
            eventPlayer.hasTargetAbility = [true, 30]
            eventPlayer.setSecondaryFireEnabled(true)
        else:
            eventPlayer.ability1Array[9] += 25
            wait(false)
            heal(eventPlayer, eventPlayer, 25)
        else:
            eventPlayer.flight = [true, 7.15]
        else:
        if eventPlayer.ability1Array[3] > 10:
            eventPlayer.ability1Array[9] += 25
            wait(false)
            heal(eventPlayer, eventPlayer, 25)


rule "On Death":
    @Event playerDied
    @Hero juno
    
    eventPlayer.ability1Array[9] -= max(25, 25 * (max(false, eventPlayer.ability1Array[3] - 10)) + (25 * (eventPlayer.ability1Array[3] >= 3)))
    eventPlayer.ability1Array[3] = (sorted(eventPlayer.ability1Array[8].filter(lambda x: x <= eventPlayer.ability1Array[3]))).last()
    eventPlayer.heroInfo[2] = (eventPlayer.heroInfo[2].slice(false, true).concat(["\n{0}\n\nReset to the nearest checkpoint (Starred) level upon death\nPress interact to cycle through level details".format(eventPlayer.ability1Array[6][min(10, eventPlayer.ability1Array[3] - true)])])).concat(eventPlayer.heroInfo[2].slice(true + true, 999999995904))
    if eventPlayer.ability1Array[3] < 3:
        eventPlayer.hasTargetAbility = false
    if eventPlayer.ability1Array[3] < 9:
        eventPlayer.flight[false] = false


rule "Bolt Strike":
    @Event eachPlayer
    @Hero juno
    @Condition entityExists(eventPlayer.targetAbility) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == false
    
    eventPlayer.ability1Target = eventPlayer.targetAbility
    eventPlayer.ability2Array[2] = eventPlayer.ability1Target.getPosition()
    eventPlayer.ability2Array[3] = raycastHitPosition(eventPlayer.ability2Array[2], eventPlayer.ability2Array[2] + 8 * Vector.UP, null, getAllPlayers(), false)
    createEffect(getAllPlayers(), Effect.CLOUD, Color.GRAY, eventPlayer.ability2Array[3], 4)
    eventPlayer.effects[31] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.CLOUD, Color.GRAY, eventPlayer.ability2Array[3] + Vector.UP, 2)
    eventPlayer.effects[32] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.CLOUD, Color.GRAY, eventPlayer.ability2Array[3] + Vector.DOWN, 2)
    eventPlayer.effects[33] = getLastCreatedEntity()
    eventPlayer.ability3Chase = 5.5
    chaseOverTime(eventPlayer.ability3Chase, false, 1 if eventPlayer.ability1Array[3] >= 3 else 1.4)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.ability2Array[2], updateEveryFrame(5.5 - eventPlayer.ability3Chase))
    eventPlayer.effects[34] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.RING, Color.WHITE, eventPlayer.ability2Array[2], updateEveryFrame(5.5 - eventPlayer.ability3Chase + 0.02))
    eventPlayer.effects[35] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.WIDOWMAKER_VENOM_MINE_EXPLOSION_SOUND, null, eventPlayer.ability2Array[2], 100)
    waitUntil(eventPlayer.ability3Chase == null, 1)
    createBeam(getAllPlayers(), Beam.MERCY_HEAL, eventPlayer.ability2Array[3] + vect(0.086, false, 0.05), eventPlayer.ability2Array[2] + vect(0.086, false, 0.05), Color.TEAM_1)
    eventPlayer.effects[36] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.MERCY_HEAL, eventPlayer.ability2Array[3] + vect(-0.086, false, 0.05), eventPlayer.ability2Array[2] + vect(-0.086, false, 0.05), Color.TEAM_1)
    eventPlayer.effects[37] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.MERCY_HEAL, eventPlayer.ability2Array[3] + -0.1 * Vector.FORWARD, eventPlayer.ability2Array[2] + -0.1 * Vector.FORWARD, Color.TEAM_1)
    eventPlayer.effects[38] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.YELLOW, eventPlayer.ability2Array[2], 6)
    playEffect(getAllPlayers(), DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION_SOUND, null, eventPlayer.ability2Array[2], 100)
    damage(getPlayersInRadius(eventPlayer.ability2Array[2], 5.5, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned()), eventPlayer, 55 * (max(true, true + (0.1 * (eventPlayer.ability1Array[3] - 10)))))
    if eventPlayer.ability1Array[3] >= 8:
        (getPlayersInRadius(eventPlayer.ability2Array[2], 5.5, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())).setStatusEffect(eventPlayer, Status.STUNNED, 0.7)
    wait(0.4)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 6.5 if eventPlayer.ability1Array[3] >= 4 else 10)
    for i in range(31, 39, true):
        destroyEffect(eventPlayer.effects[i])


def Spark():
    @Name "Subroutine Spark"
    
    if eventPlayer.ability1Array[3] >= 10 and entityExists(eventPlayer.targetAbility):
        eventPlayer.ability2Array[false] = eventPlayer.targetAbility
        eventPlayer.ability2Array[true] = eventPlayer.targetAbility.getPosition() + 0.5 * vectorTowards(eventPlayer.targetAbility.getPosition(), eventPlayer.targetAbility.getEyePosition())
    else:
        eventPlayer.ability2Array[false] = raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getLivingPlayers(Team.ALL), eventPlayer, true)
        eventPlayer.ability2Array[true] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getLivingPlayers(Team.ALL), eventPlayer, true)
    eventPlayer.ability2Chase = eventPlayer.getHorizontalFacingAngle()
    createBeam(getAllPlayers(), Beam.MERCY_HEAL, eventPlayer.ability1Chase, eventPlayer.ability2Array[true], Color.TEAM_1)
    eventPlayer.effects[30] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.YELLOW, eventPlayer.ability2Array[true], 1)
    playEffect(getAllPlayers(), DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION_SOUND, null, eventPlayer.ability2Array[true], 100)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, null, eventPlayer.ability1Chase, 70)
    damage(getPlayersInRadius(eventPlayer.ability2Array[true], 1, Team.ALL).filter(lambda player: player.isAlive() and player.hasSpawned()), eventPlayer, 25 * (max(true, true + (0.1 * (eventPlayer.ability1Array[3] - 10)))))
    if eventPlayer.ability1Array[3] >= 5:
        eventPlayer.ability2Array[0].moveSpeed[false] -= 35
    wait(0.2)
    destroyEffect(eventPlayer.effects[30])
    wait(0.15)
    if eventPlayer.ability1Array[3] >= 5:
        eventPlayer.ability2Array[0].moveSpeed[false] += 35


rule "Activate Spark":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    if eventPlayer.ability1Array[3] >= 7:
        Spark()
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 999999995904)
    if eventPlayer.ability1Array[3] >= 2:
        Spark()


rule "Static":
    @Event playerTookDamage
    @Hero juno
    @Condition eventPlayer.ability1Array[3] >= 6
    
    eventPlayer.ability2Array[4] = random.randint(false, 24)
    if not eventPlayer.ability2Array[4]:
        attacker.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
        smallMessage(eventPlayer, "{0} was shocked by static electricity!".format(attacker))
        smallMessage(attacker, "You were shocked by static electricity!")


rule "--- KIRIKO ---":
    @Delimiter
    


rule "Kiriko Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.KIRIKO
    
    stopChasing(eventPlayer.scale)
    eventPlayer.scale = null
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setDamageDealt(85)
    eventPlayer.heroInfo = ["Passive: Parkour Master0Secondary Fire: Critical Strike0Ability 1: Kiriko's Bike".split(null[0]), ["{0}txC00000000032723>".format(__holygrail___), "{0}txC00000000029CE7>".format(__holygrail___), "{0}txC00000000032726>".format(__holygrail___)], "Press jump while airborne to perform a lunge;\nGain the ability to glide after climbing a wall.0Critical hits stun and knock b{0}".format("ack enemies.0Equip a bike that makes you significantly faster.\nWhile airborne, do tricks on it.").split(null[0])]


rule "Parkour Master":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isInAir() == true
    
    waitUntil(not (eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isInAir()), 999999995904)
    if eventPlayer.isOnGround():
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or not eventPlayer.isInAir(), 999999995904)
    if not eventPlayer.isInAir():
        return
    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 10 if eventPlayer.getThrottle()[0] else null, Relativity.TO_PLAYER)


rule "Wall Climb + Glide":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isOnWall() == true
    
    eventPlayer.moveSpeed[false] += 50
    waitUntil(eventPlayer.isInAir(), 999999995904)
    eventPlayer.moveSpeed[false] -= 50
    eventPlayer.canGlide = [true, [Button.JUMP, Button.PRIMARY_FIRE], 2, 75]
    waitUntil(eventPlayer.isOnGround(), 999999995904)
    eventPlayer.canGlide = false


rule "Critical Strike":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition eventWasCriticalHit == true
    
    victim.applyImpulse(directionTowards(eventPlayer.getPosition(), victim.getEyePosition()), 20, Relativity.TO_WORLD)
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.5)


rule "Kiriko's Bike":
    @Event eachPlayer
    @Hero kiriko
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.ability1Array[false] = "\u0096\u0001(\u0001^\u00020\u0096\u0001]\u0002\u0082\u00020\u0096\u0001\u0001\u0001\u0008\u00020\u0096\u0001]\u0002\u0008\u00020^\u0001\u008c\u0002\u0096\u00020\u0014\u0002\u008c\u0002\u0096\u00020\u0014\u0001\u008c\u0002\u0096\u00020^\u0002\u008c\u0002\u0096\u0002".split(null[0]).map(lambda x: [x, "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\n\u000b\u000c\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./2:;<=>?@Q[\\]^_`q|}~\u007f\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f¡"]).map(lambda x: vect(0.01 * x.last().strIndex(x[0].charAt(0)) + x.last().strIndex(x[0].charAt(1)), 0.01 * x.last().strIndex(x[0].charAt(4)) + x.last().strIndex(x[0].charAt(5)), 0.01 * x.last().strIndex(x[0].charAt(2)) + x.last().strIndex(x[0].charAt(3))) - vect(0.89, 0.89, 0.89))
    eventPlayer.scale = 8
    chaseAtRate(eventPlayer.scale, false, true)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}: {1}s".format(abilityIconString(Hero.KIRIKO, Button.ABILITY_1), "{0}".format(eventPlayer.scale).substring(0, 2 + strLen("{0}".format(floor(eventPlayer.scale))))), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0.6 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA)
    eventPlayer.inWorldTexts[false] = getLastCreatedText()
    eventPlayer.moveSpeed[false] += 100
    eventPlayer.addHealthPool(Health.ARMOR, 75, true)
    eventPlayer.ability1Array[true] = getLastCreatedHealthPool()
    for i in range(0, 8, true):
        if i <= 1:
            createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][evalOnce(i)], eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + (worldVector(eventPlayer.ability1Array[0][evalOnce(i + true)], eventPlayer, Transform.ROTATION)), Color.TEAM_1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.effects.append(getLastCreatedEntity())
        elif i in [4, 5]:
            createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][evalOnce(i)], eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][true], eventPlayer, Transform.ROTATION), Color.TEAM_1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.effects.append(getLastCreatedEntity())
            createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][evalOnce(i)], eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + (worldVector(eventPlayer.ability1Array[0][evalOnce(i + 2)], eventPlayer, Transform.ROTATION)), null, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][true], eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][3], eventPlayer, Transform.ROTATION), Color.TEAM_1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.effects.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.SYMMETRA_PROJECTOR, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][2], eventPlayer, Transform.ROTATION), eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][0], eventPlayer, Transform.ROTATION), Color.TEAM_1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.effects.append(getLastCreatedEntity())
    for i in range(0, 5, true):
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][2], eventPlayer, Transform.ROTATION) + (0.48 * (worldVector(vect(false, sinDeg(getTotalTimeElapsed() * 720 + 72 * evalOnce(i)), cosDeg(getTotalTimeElapsed() * 720 + 72 * evalOnce(i))), eventPlayer, Transform.ROTATION))), eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][2], eventPlayer, Transform.ROTATION) + (0.48 * (worldVector(vect(false, sinDeg(getTotalTimeElapsed() * 720 + (72 * (evalOnce(i + true)))), cosDeg(getTotalTimeElapsed() * 720 + (72 * (evalOnce(i + true))))), eventPlayer, Transform.ROTATION))), null, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.effects.append(getLastCreatedEntity())
    for i in range(0, 5, true):
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][3], eventPlayer, Transform.ROTATION) + (0.48 * (worldVector(vect(false, sinDeg(getTotalTimeElapsed() * 720 + 72 * evalOnce(i)), cosDeg(getTotalTimeElapsed() * 720 + 72 * evalOnce(i))), eventPlayer, Transform.ROTATION))), eventPlayer.getPosition() + worldVector(eventPlayer.ability1Array[0][3], eventPlayer, Transform.ROTATION) + (0.48 * (worldVector(vect(false, sinDeg(getTotalTimeElapsed() * 720 + (72 * (evalOnce(i + true)))), cosDeg(getTotalTimeElapsed() * 720 + (72 * (evalOnce(i + true))))), eventPlayer, Transform.ROTATION))), null, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.effects.append(getLastCreatedEntity())
    while eventPlayer.getHealthOfType(Health.ARMOR) and eventPlayer.scale:
        #eventPlayer.applyImpulse(Vector.UP, 1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        #elif eventPlayer.getAltitude() > 0.4:
        #eventPlayer.applyImpulse(Vector.DOWN, 0.2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        if not eventPlayer.getThrottle()[0]:
            eventPlayer.applyImpulse(-1 * vect(eventPlayer.getVelocity().x, false, eventPlayer.getVelocity().z), eventPlayer.getSpeed() * 0.05, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(false)
    if not eventPlayer.getHealthOfType(Health.ARMOR):
        smallMessage(eventPlayer, "Your bike broke!")
    eventPlayer.scale = null
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 12)
    stopChasing(eventPlayer.scale)
    eventPlayer.moveSpeed[false] -= 100
    destroyInWorldText(eventPlayer.inWorldTexts[0])
    destroyEffect(eventPlayer.effects)
    removeHealthPool(eventPlayer.ability1Array[true])


rule "Spin Bike":
    @Event eachPlayer
    @Condition eventPlayer.getHero() == Hero.KIRIKO
    @Condition eventPlayer.getAltitude() >= 1.5
    @Condition eventPlayer.scale > null
    
    smallMessage(eventPlayer, "Do a trick!")
    while eventPlayer.getHero() == Hero.KIRIKO and eventPlayer.getAltitude() >= 1.5 and eventPlayer.scale > null:
        for eventPlayer.i in range(0, 15, true):
            if eventPlayer.getHero() != Hero.KIRIKO:
                return
            for eventPlayer.j in range(0, 8, true):
                eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0].slice(false, eventPlayer.j).concat([vect(eventPlayer.ability1Array[0][eventPlayer.j].x * 0.914 - eventPlayer.ability1Array[0][eventPlayer.j].z * -0.407, eventPlayer.ability1Array[0][eventPlayer.j].y, eventPlayer.ability1Array[0][eventPlayer.j].x * -0.407 + eventPlayer.ability1Array[0][eventPlayer.j].z * 0.914)])).concat(eventPlayer.ability1Array[0].slice(eventPlayer.j + true, 999999995904))
            wait(0.023)


rule "--- LIFEWEAVER ---":
    @Delimiter
    


rule "Lifeweaver Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.LIFEWEAVER
    
    eventPlayer.hitPoints = [200]
    AddCustomHP()
    eventPlayer.canGlide = [true, [Button.JUMP, Button.PRIMARY_FIRE], 1.75, 50]
    eventPlayer.disallowButton(Button.ULTIMATE)
    startDamageModification(getAllPlayers(), eventPlayer, 100 * (eventPlayer.scale + true))
    eventPlayer.damageMods.append(getLastDamageModification())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}: {1}{2}".format(abilityIconString(Hero.BAPTISTE, Button.CROUCH), eventPlayer.scale + true, ".00" if eventPlayer.scale == round(eventPlayer.scale) else ""), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-1 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(-4 * eventPlayer.scale + 236, -78 * eventPlayer.scale + 233, 189))
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive 1: Petal Wings0Passive 2: Phototropism0Ultimate: Superbloom".split(null[0]), ["{0}txC00000000011E07>".format(__holygrail___), "{0}txC0000000001E304>".format(__holygrail___), "{0}txC0000000003C65C>".format(__holygrail___)], "Gain the ability to glide while airborne.0Damage and projectile speed scale with altitude.0Gain free-flight while charging bi{0}".format("olight energy,\nthen unleash it to do massive damage.").split(null[0])]


rule "Scale Scale With Altitude":
    @Event eachPlayer
    @Hero lifeweaver
    
    eventPlayer.scale = min(2.25, max(true, (eventPlayer.getAltitude() + 1.75) / 6)) - true
    eventPlayer.setProjectileSpeed(100 * (eventPlayer.scale + true))
    wait(0.25)
    loop()


rule "Superbloom":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() - 3 * eventPlayer.getFacingDirection() + worldVector(-0.5 * Vector.LEFT, eventPlayer, Transform.ROTATION), null, getAllPlayers(), false)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100))
    eventPlayer.thirdPersonCam = true
    eventPlayer.isUlting = true
    eventPlayer.flight = [true, 7.7]
    eventPlayer.ability1Array = []
    eventPlayer.ability1Chase = 1
    eventPlayer.forceButtonPress(Button.JUMP)
    bigMessage(getAllPlayers(), "{0}{1}fgE0708CFF>: Pure...{1}/fg>".format(heroIcon(Hero.LIFEWEAVER), __holygrail___))
    for eventPlayer.i in range(0, 40, true):
        if [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isDead():
            break
        if eventPlayer.i >= 15 and eventPlayer.i < 35:
            eventPlayer.flight[true] -= 0.175
        if eventPlayer.i % 8 == null:
            eventPlayer.ability1Array.append(vect(random.uniform(-2, 2), random.uniform(-1, 2), random.uniform(-1.5, 2)))
            createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ROSE, updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.ability1Chase ** 2 * worldVector(evalOnce(eventPlayer.ability1Array.last()), eventPlayer, Transform.ROTATION)), random.uniform(0.25, 0.35))
            eventPlayer.effects.append(getLastCreatedEntity())
            createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.ability1Chase ** 2 * worldVector(evalOnce(eventPlayer.ability1Array.last()), eventPlayer, Transform.ROTATION)), 0.25)
            eventPlayer.effects.append(getLastCreatedEntity())
            playEffect(getAllPlayers(), DynamicEffect.WIDOWMAKER_VENOM_MINE_EXPLOSION_SOUND, null, eventPlayer.getEyePosition() + worldVector(evalOnce(eventPlayer.ability1Array.last()), eventPlayer, Transform.ROTATION), 100)
            playEffect(getAllPlayers(), DynamicEffect.REINHARDT_FIRE_STRIKE_TARGET_IMPACT_SOUND, null, eventPlayer.getEyePosition() + worldVector(evalOnce(eventPlayer.ability1Array.last()), eventPlayer, Transform.ROTATION), 60)
        if eventPlayer.i == 25:
            bigMessage(getAllPlayers(), "{0}{1}fgE0708CFF>: BIOLIGHT!{1}/fg>".format(heroIcon(Hero.LIFEWEAVER), __holygrail___))
        if eventPlayer.i == 37:
            chaseOverTime(eventPlayer.ability1Chase, false, 0.3)
            eventPlayer.forceButtonPress(Button.JUMP)
        if [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any():
            break
        wait(0.1)
    destroyEffect(eventPlayer.effects)
    stopChasing(eventPlayer.ability1Chase)
    eventPlayer.effects = []
    eventPlayer.flight[false] = false
    eventPlayer.stopCamera()
    eventPlayer.thirdPersonCam = false
    eventPlayer.isUlting = false
    if [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() or eventPlayer.isDead():
        eventPlayer.setUltCharge(50)
        smallMessage(eventPlayer, "Better Luck Next Time")
        return
    for i in range(0, 3, true):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, updateEveryFrame(eventPlayer.getPosition()), updateEveryFrame(20 * eventPlayer.ability1Chase))
        eventPlayer.effects.append(getLastCreatedEntity())
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ROSE, updateEveryFrame(eventPlayer.getPosition()), updateEveryFrame(20 * eventPlayer.ability1Chase))
        eventPlayer.effects.append(getLastCreatedEntity())
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION_SOUND, null, eventPlayer.getEyePosition(), 100)
    eventPlayer.setAmmo(true, false)
    chaseOverTime(eventPlayer.ability1Chase, true, 0.3)
    damage((getPlayersInRadius(eventPlayer, 20, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).filter(lambda player: player.isAlive() and player.hasSpawned())).exclude(eventPlayer), eventPlayer, 350)
    eventPlayer.setUltCharge(false)
    wait(0.3)
    destroyEffect(eventPlayer.effects)
    stopChasing(eventPlayer.ability1Chase)


rule "--- LUCIO ---":
    @Delimiter
    


rule "Lucio Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.LUCIO
    
    eventPlayer.ability1Array = []
    eventPlayer.ability2Array[true] = null
    eventPlayer.ability2Chase = null
    eventPlayer.setMaxHealth(88.888)
    for i in range(1, 17, true):
        createBeam(getAllPlayers().exclude(eventPlayer) if eventPlayer.ability1Array[evalOnce(i)] else null, Beam.ORISA_HALT_TENDRIL, eventPlayer.ability1Array[evalOnce(i - true)], eventPlayer.ability1Array[evalOnce(i)], Color.TEAM_2)
        eventPlayer.effects.append(getLastCreatedEntity())
        createBeam(eventPlayer if eventPlayer.ability1Array[evalOnce(i)] else null, Beam.ORISA_HALT_TENDRIL, eventPlayer.ability1Array[evalOnce(i - true)], eventPlayer.ability1Array[evalOnce(i)], Color.TEAM_1)
        eventPlayer.effects.append(getLastCreatedEntity())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC0000000004B96C>: {1}".format(__holygrail___, "{0}".format(eventPlayer.ability2Chase).substring(0, 2 + strLen("{0}".format(floor(eventPlayer.ability2Chase)))) if eventPlayer.ability2Chase else "Ready"), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.4 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.YELLOW)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC00000000003C5E>: {1}%".format(__holygrail___, eventPlayer.ability2Array[true]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.8 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive 1: Supersonic0Ability 1: Rewind0Passive 2: Accelerando Tenuto".split(null[0]), ["{0}txC0000000004E11B>".format(__holygrail___), "{0}txC0000000004B96C>".format(__holygrail___), "{0}txC00000000003C5E>".format(__holygrail___)], "Gain enhanced movement and a double jump.\nLeave a trail behind you that damages enemies.0Backtrack on your trail and heal you{0}".format("rself depending on the distance traveled.0Each elimination increases your move speed until you die.").split(null[0])]


rule "On Respawn":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.ability1Array = []
    eventPlayer.ability2Chase = null
    eventPlayer.moveSpeed[false] -= eventPlayer.ability2Array[true]
    eventPlayer.ability2Array[true] = null


rule "On Kill":
    @Event playerEarnedElimination
    @Hero lucio
    
    if eventPlayer.ability2Array[true] < 200:
        eventPlayer.ability2Array[true] += 5
        eventPlayer.moveSpeed[false] += 5


rule "Set Trail Points":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getHero() == Hero.LUCIO
    
    if eventPlayer.isUsingAbility1():
        eventPlayer.ability1Array.append(eventPlayer.getPosition() + 0.5 * Vector.UP)
    if len(eventPlayer.ability1Array) > 17:
        del eventPlayer.ability1Array[false]
    for i in range(1, 17, true):
        if eventPlayer.ability1Array[i]:
            damage(raycastHitPlayer(eventPlayer.ability1Array[i - true], eventPlayer.ability1Array[i], getAllPlayers(), eventPlayer, false), eventPlayer, 25)
    wait(true / min(max(4, eventPlayer.getSpeed()), 12))
    if ruleCondition:
        loop()


rule "Double Jump":
    @Event eachPlayer
    @Hero lucio
    @Condition (eventPlayer.isOnGround() or eventPlayer.isOnWall()) == false
    
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround() or eventPlayer.isOnWall(), 999999995904)
    if eventPlayer.isOnGround() or eventPlayer.isOnWall():
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround() or eventPlayer.isOnWall(), 999999995904)
    if eventPlayer.isOnGround() or eventPlayer.isOnWall():
        return
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 1.75, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, 5.5, Relativity.TO_WORLD)


rule "Rewind":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility1() == false
    
    createEffect(getAllPlayers(), Effect.LUCIO_SOUND_BARRIER_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.ability2Array[false] = eventPlayer.ability2Array[0].slice(false, false).concat([getLastCreatedEntity()]).concat(eventPlayer.ability2Array[0].slice(0 + true, 999999995904))
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.ability2Array[false] = eventPlayer.ability2Array[0].slice(false, true).concat([getLastCreatedEntity()]).concat(eventPlayer.ability2Array[0].slice(true + true, 999999995904))
    stopChasing(eventPlayer.ability2Chase)
    eventPlayer.ability1Chase = len(eventPlayer.ability1Array) - true
    chaseAtRate(eventPlayer.ability1Chase, false, 20)
    eventPlayer.startHealingOverTime(eventPlayer, (len(eventPlayer.ability1Array) - true) / 20, 75)
    eventPlayer.startForcingPosition(eventPlayer.ability1Array[ceil(eventPlayer.ability1Chase)] + ((ceil(eventPlayer.ability1Chase) - eventPlayer.ability1Chase) * (vectorTowards(eventPlayer.ability1Array[ceil(eventPlayer.ability1Chase)], eventPlayer.ability1Array[ceil(eventPlayer.ability1Chase - true)]))))
    waitUntil(eventPlayer.ability1Chase < 0.5 or eventPlayer.isUsingAbility1() or eventPlayer.isDead(), 999999995904)
    if not eventPlayer.isUsingAbility1():
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    destroyEffect(eventPlayer.ability2Array[0])
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.stopForcingPosition()
    eventPlayer.ability1Array = []
    eventPlayer.ability2Chase = 5
    chaseAtRate(eventPlayer.ability2Chase, false, true)
    wait(eventPlayer.ability2Chase)
    eventPlayer.setAbility1Enabled(true)


rule "--- MOIRA ---":
    @Delimiter
    


rule "Moira Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.MOIRA
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_2)
    startDamageModification(getAllPlayers(), eventPlayer, 76.9)
    eventPlayer.damageMods.append(getLastDamageModification())
    startDamageModification(eventPlayer.ability1Target, eventPlayer, 35)
    eventPlayer.damageMods.append(getLastDamageModification())
    eventPlayer.heroInfo = ["Passive: Transmogrification0Ability 1: Possession0Ability 2: Necrotic Orb".split(null[0]), ["{0}txC00000000001306>".format(__holygrail___), "{0}txC00000000011DBD>".format(__holygrail___), "{0}txC00000000003FCF>".format(__holygrail___)], "When the biotoc resource is full and you die,\nRevive as a ball of smoke.\nUse fade to reincarnate.0Fading into an enemy lets y{0}".format("ou possess them\nand gain partial control of their body.0Launch an orb that damages and slows enemies.").split(null[0])]


rule "Throw Necrotic Orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == false
    @Condition eventPlayer.isAlive() == true
    @Condition [eventPlayer.isChained, eventPlayer.hasStatus(Status.KNOCKED_DOWN), eventPlayer.hasStatus(Status.STUNNED)].any() == false
    
    eventPlayer.forceButtonPress(Button.MELEE)
    createProjectile(Projectile.MOIRA_DAMAGE_ORB, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, 65, 1, 3, DynamicEffect.MOIRA_FADE_REAPPEAR, DynamicEffect.MOIRA_FADE_REAPPEAR_SOUND, 0, 45, 0.5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)


rule "Necrotic Orb Slow":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 7.4
    
    victim.startDamageOverTime(eventPlayer, 1, 65)
    victim.moveSpeed[false] -= 35
    wait(1.25)
    victim.moveSpeed[false] += 35


rule "Possession":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.hasTargetAbility = [true, 2]
    waitUntil(entityExists(eventPlayer.targetAbility) or not eventPlayer.isUsingAbility1(), 0.742)
    eventPlayer.ability1Target = eventPlayer.targetAbility
    eventPlayer.hasTargetAbility[false] = false
    if not entityExists(eventPlayer.targetAbility):
        return
    eventPlayer.ability1Target.owner = eventPlayer
    eventPlayer.ability1Target.mimicOwner = true
    eventPlayer.ability1Target.creditOwner = true
    eventPlayer.ability1Target.moveSpeed[false] += 20
    eventPlayer.ability1Array[false] = null
    createEffect(getAllPlayers(), Effect.REAPER_WRAITH_FORM, Color.TEAM_1, eventPlayer.ability1Target, false)
    eventPlayer.effects[false] = getLastCreatedEntity()
    bigMessage([eventPlayer.ability1Target, eventPlayer], "{0}{1}fg765DBDFF>Possessed!".format(heroIcon(Hero.MOIRA), __holygrail___))
    eventPlayer.ability1Target.startFacing(updateEveryFrame(eventPlayer.getFacingDirection()), 999999995904)
    eventPlayer.setFacing(eventPlayer.ability1Target.getFacingDirection(), Relativity.TO_WORLD)
    eventPlayer.attachTo(eventPlayer.ability1Target, -0.25 * Vector.FORWARD)
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.ability1Target.getEyePosition(), eventPlayer.ability1Target.getEyePosition() - 3 * eventPlayer.ability1Target.getFacingDirection() + worldVector(vect(-0.5, 0.2, false), eventPlayer.ability1Target, Transform.ROTATION), null, getAllPlayers(), false)), updateEveryFrame(eventPlayer.ability1Target.getEyePosition() + eventPlayer.ability1Target.getFacingDirection() * 100))
    eventPlayer.thirdPersonCam = true
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 5)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.heroInfo = eventPlayer.ability1Target.heroInfo
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ULTIMATE)
    while (eventPlayer.isAlive() or eventPlayer.ability1Target.isAlive()) and eventPlayer.ability1Array[0] < 4:
        eventPlayer.ability1Target.setEnvironmentalKillCreditor(eventPlayer)
        waitUntil(not ((eventPlayer.isAlive() or eventPlayer.ability1Target.isAlive()) and eventPlayer.ability1Array[0] < 4), 0.5)
        eventPlayer.ability1Array[false] += 0.5
    eventPlayer.ability1Target.owner = null
    eventPlayer.ability1Target.mimicOwner = false
    eventPlayer.ability1Target.creditOwner = false
    eventPlayer.ability1Target.moveSpeed[false] -= 20
    eventPlayer.ability1Target.stopFacing()
    eventPlayer.ability1Target.stopThrottleInDirection()
    eventPlayer.ability1Target = null
    eventPlayer.targetAbility = null
    eventPlayer.detach()
    eventPlayer.stopCamera()
    eventPlayer.thirdPersonCam = false
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 6)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.TEAM_1, eventPlayer.getPosition(), 1)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR_SOUND, Color.TEAM_1, eventPlayer.getPosition(), 100)
    destroyEffect(eventPlayer.effects[0])
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.2)
    eventPlayer.applyImpulse(eventPlayer.getThrottle() + 0.33 * eventPlayer.isHoldingButton(Button.JUMP) * Vector.UP, 15, Relativity.TO_PLAYER)
    eventPlayer.heroInfo = ["Passive: Transmogrification0Ability 1: Possession0Ability 2: Necrotic Orb".split(null[0]), ["{0}txC00000000001306>".format(__holygrail___), "{0}txC00000000011DBD>".format(__holygrail___), "{0}txC00000000003FCF>".format(__holygrail___)], "When the biotoc resource is full and you die,\nRevive as a ball of smoke.\nUse fade to reincarnate.0Fading into an enemy lets y{0}".format("ou possess them\nand gain partial control of their body.0Launch an orb that damages and slows enemies.").split(null[0])]


rule "Possession Self Damage":
    @Event playerDealtFinalBlow
    @Hero moira
    @Condition victim == eventPlayer.ability1Target
    @Condition eventWasEnvironment == true
    
    eventPlayer.addToScore(true)


rule "Transmogrification":
    @Event playerDied
    @Hero moira
    @Condition eventPlayer.getAbilityResource(Button.PRIMARY_FIRE) == 100
    
    waitUntil(not entityExists(eventPlayer.ability1Target), 999999995904)
    if eventWasEnvironment:
        eventPlayer.teleport(eventPlayer.getPosition() + 5 * Vector.UP)
    eventPlayer.resurrect()
    if eventWasEnvironment:
        eventPlayer.teleport(eventPlayer.getPosition() + 5 * Vector.UP)
    eventPlayer.flight = [true, 5.5]
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, false)
    eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * -2, null, eventPlayer, false)), updateEveryFrame(eventPlayer.getEyePosition()))
    eventPlayer.ability1Chase = 100
    chaseOverTime(eventPlayer.ability1Chase, false, 10)
    createProgressBarInWorldText(eventPlayer, eventPlayer.ability1Chase, "TRANSMOGRIFICATION - {0}".format(inputBindingString(Button.ABILITY_1).map(lambda x: "{0}(0.00, 1.00, 0.00)[{0}](0.00, 1.00, 0.00)[SHIFT](0.00, 1.00, 0.00)[CTRL](0.00, 1.00, 0.00)[ALT]".format(x).split(Vector.UP[0])[strLen("\\{0}{0}{0}{0}{0}{0}{0}".format(x)) % 7 == 1 and abs("\uec470\uec470LSHIFT0LCONTROL0LALT".split(null[0]).index(x))])), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.85 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1, Clip.NONE, Color.VIOLET)
    eventPlayer.iwtProgressBars[false] = getLastCreatedText()
    eventPlayer.ability1Array[true] = null
    eventPlayer.disablePlayerCollision()
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.MELEE)
    wait(false)
    while eventPlayer.isAlive() and eventPlayer.ability1Array[true] < 10 and not eventPlayer.isUsingAbility2():
        playEffect(eventPlayer, DynamicEffect.MOIRA_FADE_REAPPEAR, Color.TEAM_1, eventPlayer.getEyePosition(), 1)
        playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.TEAM_2, eventPlayer.getEyePosition(), 1)
        playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR_SOUND, Color.TEAM_1, eventPlayer.getEyePosition(), 70)
        waitUntil(eventPlayer.isUsingAbility1(), 0.2)
        eventPlayer.ability1Array[true] += 0.2
    destroyProgressBarInWorldText(eventPlayer.iwtProgressBars[0])
    eventPlayer.flight[false] = false
    eventPlayer.stopCamera()
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), 10, Relativity.TO_WORLD)
    if not eventPlayer.isUsingAbility1():
        kill(eventPlayer)
    eventPlayer.enablePlayerCollision()
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.setAbilityResource(Button.PRIMARY_FIRE, false)


rule "--- ZENYATTA ---":
    @Delimiter
    


rule "Zenyatta Init":
    @Event eachPlayer
    @Condition eventPlayer.init[0] == Hero.ZENYATTA
    
    eventPlayer.setMaxHealth(0)
    eventPlayer.addHealthPool(Health.NORMAL, 147.5, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.ui[false] = [rgb(244, 241, 222), rgb(198, 77, 12), rgb(118, 84, 56), rgb(13, 141, 192)]
    eventPlayer.ui[true] = ["{0}txC00000000011E07>".format(__holygrail___), "{0}txC000000000402CD>".format(__holygrail___), "{0}txC0000000004A038>".format(__holygrail___), "{0}txC0000000000ABAD>".format(__holygrail___)]
    eventPlayer.ui[2] = [vect(false, -0.35, 2.6), vect(-0.12, -0.35, 2), vect(false, -0.37, 2.6), vect(0.12, -0.35, 2)]
    eventPlayer.ui[3] = " ■0 ■0 _0 ■".split(null[0])
    eventPlayer.ability1Array[false] = null
    eventPlayer.ability1Array[true] = [null, null, null, null]
    eventPlayer.ability2Array[false] = true
    #eventPlayer.ability1Array[2] = 0
    #eventPlayer.ability1Chase = 0
    chaseAtRate(eventPlayer.ability2Chase, eventPlayer.getPosition() + (vect(2 * (cosDeg(360 * getTotalTimeElapsed())), 1.5 * (true + sin(getTotalTimeElapsed())), 2 * (sinDeg(360 * getTotalTimeElapsed())))), 999999995904)
    chaseAtRate(eventPlayer.ability3Chase, eventPlayer.getPosition() + (vect(2 * (cosDeg(360 * getTotalTimeElapsed() + 180)), 1.5 * (true + sin(getTotalTimeElapsed())), 2 * (sinDeg(360 * getTotalTimeElapsed() + 180)))), 999999995904)
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, " {0}".format(eventPlayer.ui[true][eventPlayer.ability1Array[0]]), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.2 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.6)
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    createInWorldText(eventPlayer if eventPlayer.isAlive() else null, "{0}txC0000000004813D>: {1}".format(__holygrail___, "ready" if eventPlayer.ability1Array[true][eventPlayer.ability1Array[0]] < getTotalTimeElapsed() + true else ("{0}".format(max(false, eventPlayer.ability1Array[true][eventPlayer.ability1Array[0]] - getTotalTimeElapsed() - true))).substring(0, 2 + (strLen("{0}".format(floor(max(false, eventPlayer.ability1Array[true][eventPlayer.ability1Array[0]] - getTotalTimeElapsed() - true))))))), updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((0 / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((-0.55 / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), 1.8, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, eventPlayer.ui[0][eventPlayer.ability1Array[0]])
    eventPlayer.inWorldTexts.append(getLastCreatedText())
    #0.35, -0.55, 1.8,
    #eventPlayer.ui[0][eventPlayer.ability1Array[0]])
    #eventPlayer.inWorldTexts.append(getLastCreatedText())
    for i in range(0, 4, true):
        createInWorldText(eventPlayer if eventPlayer.isAlive() else null, eventPlayer.ui[3][evalOnce(i)], updateEveryFrame(eventPlayer.getEyePosition() + (100 * ((((eventPlayer.ui[2][evalOnce(i)].x / (1.241 if eventPlayer.isConsole else 1)) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION)) + ((eventPlayer.ui[2][evalOnce(i)].y / (1.241 if eventPlayer.isConsole else 1)) * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90)))) + 3 * eventPlayer.getFacingDirection()))), eventPlayer.ui[2][evalOnce(i)].z, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, eventPlayer.ui[0][(eventPlayer.ability1Array[0] + evalOnce(i)) % 4])
        eventPlayer.inWorldTexts.append(getLastCreatedText())
    eventPlayer.heroInfo = ["Passive: Avatar State0Passive: Ambiental Power0Melee: Elemental Kick".split(null[0]), ["{0}txC00000000049435>".format(__holygrail___), "{0}txC00000000032721>".format(__holygrail___), "{0}txC0000000004813D>".format(__holygrail___)], "Use ability 1 and 2 to cycle between four elements,\nair, fire, earth, and water, that alter your abilities.0Gain a buff that {0}".format("changes depending on your current element:\n - Air: Move faster, jump higher, and become able to glide.\n - Fire: Dealing damag{0}".format("e sets enemies on fire.\n - Earth: Move slower but take significantly less damage\n - Water: Gain a constant heal over time eff{0}".format("ect0Your melee has a different effect depending on your current element:\n - Air: Meleeing a surface launches you away from it{0}".format(".\n - Fire: Meleeing shoots out three fireballs that explode.\n - Earth: Meleeing the ground will damage, slow, and knock an en{0}".format("emy in your sight upward.\n - Water: Create a spray of projectiles that explode and heal.\nEach effect has a separate cooldown."))))).split(null[0])]


rule "Upon Death":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isDead() == true
    
    eventPlayer.ability1Array[false] = null
    eventPlayer.ability1Array[true] = [null, null, null, null]
    eventPlayer.ability1Array[2] = null


rule "Switch Elements Left":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0] + true) % 4


rule "Switch Elements Right":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    eventPlayer.ability1Array[false] = (eventPlayer.ability1Array[0] + 3) % 4


rule "Elemental Kick":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isMeleeing() == true
    
    if eventPlayer.ability1Array[true][eventPlayer.ability1Array[0]] > getTotalTimeElapsed():
        return
    if true:
        goto loc+[29, null, 4, 9, 24][true + [null, 1, 2, 3].index(eventPlayer.ability1Array[0])]
        __abortIf__(isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5))
        eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), -20, Relativity.TO_WORLD)
        eventPlayer.ability1Array[true] = (eventPlayer.ability1Array[true].slice(false, false).concat([getTotalTimeElapsed() + 10])).concat(eventPlayer.ability1Array[true].slice(0 + true, 999999995904))
    else:
        for i in range(-2, 4, 2):
            createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), directionFromAngles(eventPlayer.getHorizontalFacingAngle() + i, eventPlayer.getVerticalFacingAngle()), Relativity.TO_WORLD, ModifyHealth.DAMAGE, Team.ALL, 35, 0.7, 2, DynamicEffect.PHARAH_BARRAGE_EXPLOSION, DynamicEffect.PHARAH_BARRAGE_EXPLOSION_SOUND, 0, 40, 3)
        eventPlayer.ability1Array[true] = (eventPlayer.ability1Array[true].slice(false, true).concat([getTotalTimeElapsed() + 10])).concat(eventPlayer.ability1Array[true].slice(true + true, 999999995904))
    else:
        __abortIf__(eventPlayer.getVerticalFacingAngle() < 12.5)
        eventPlayer.ability1Target[false] = (sorted(getPlayersInRadius(eventPlayer, 15, Team.ALL, LosCheck.SURFACES).filter(lambda player: player.isAlive() and player.hasSpawned()).filter(lambda x: x.getAltitude() < 1 and x != eventPlayer and eventPlayer.isInViewAngle(x, 80)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer, x))))[0]
        if entityExists(eventPlayer.ability1Target[0]):
            playEffect(getAllPlayers(), DynamicEffect.SIGMA_ACCRETION_IMPACT, null, eventPlayer.ability1Target[0].getPosition(), 1)
            playEffect(getAllPlayers(), DynamicEffect.SIGMA_ACCRETION_IMPACT_SOUND, null, eventPlayer.ability1Target[0].getPosition(), 100)
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, null, eventPlayer.ability1Target[0], 1)
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_LEAP, null, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.5, null, eventPlayer, false), 1)
            damage(eventPlayer.ability1Target[0], eventPlayer, 60)
            eventPlayer.ability1Target[0].applyImpulse(Vector.UP, 14, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.ability1Target[0].moveSpeed[false] -= 50
            wait(true)
            eventPlayer.ability1Target[0].moveSpeed += 50
            eventPlayer.ability1Array[true] = (eventPlayer.ability1Array[true].slice(false, 2).concat([getTotalTimeElapsed() + 10])).concat(eventPlayer.ability1Array[true].slice(2 + true, 999999995904))
    else:
        for i in range(-60, 80, 20):
            createProjectile(Projectile.ECHO_STICKY_BOMB, null, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2, null, eventPlayer, false), directionFromAngles(eventPlayer.getHorizontalFacingAngle() + evalOnce(i), max(-89, eventPlayer.getVerticalFacingAngle() - 30)), Relativity.TO_WORLD, ModifyHealth.HEAL, Team.ALL, 15, 0.7, 3, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, 0, 10, 1.5, 0, 0, 60)
        eventPlayer.ability1Array[true] = (eventPlayer.ability1Array[true].slice(false, 3).concat([getTotalTimeElapsed() + 10])).concat(eventPlayer.ability1Array[true].slice(3 + true, 999999995904))
    else:


rule "Circmambience Air":
    @Event eachPlayer
    @Hero zenyatta
    #@Condition eventPlayer.ability1Chase > 0
    @Condition eventPlayer.ability2Array[0] != false
    @Condition eventPlayer.ability1Array[0] % 4 == null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.init[0] != false
    
    destroyEffect(eventPlayer.effects)
    eventPlayer.effects = []
    wait(false)
    for i in range(0, 3, true):
        createEffect(getAllPlayers() if eventPlayer.isAlive() else null, Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer.getEyePosition(), true)
        eventPlayer.effects.append(getLastCreatedEntity())
    createEffect(getAllPlayers() if eventPlayer.isAlive() else null, Effect.GOOD_AURA, Color.WHITE, eventPlayer.ability2Chase, 0.2)
    eventPlayer.effects.append(getLastCreatedEntity())
    createEffect(getAllPlayers() if eventPlayer.isAlive() else null, Effect.GOOD_AURA, Color.WHITE, eventPlayer.ability3Chase, 0.2)
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.moveSpeed[false] += 20
    eventPlayer.setJumpVerticalSpeed(175)
    eventPlayer.canGlide = [true, [Button.JUMP, Button.SECONDARY_FIRE], 2, 30]
    waitUntil(not (eventPlayer.ability2Array[0] and eventPlayer.ability1Array[0] % 4 == null and eventPlayer.isAlive() and eventPlayer.init[0]), 999999995904)
    destroyEffect(eventPlayer.effects)
    eventPlayer.moveSpeed[false] -= 20
    eventPlayer.canGlide[false] = false
    eventPlayer.setJumpVerticalSpeed(100)


rule "Circmambience Fire":
    @Event eachPlayer
    @Hero zenyatta
    #@Condition eventPlayer.ability1Chase > 0
    @Condition eventPlayer.ability2Array[0] != false
    @Condition eventPlayer.ability1Array[0] == 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.init[0] != false
    
    destroyEffect(eventPlayer.effects)
    eventPlayer.effects = []
    wait(false)
    createEffect(getAllPlayers(), Effect.ASHE_DYNAMITE_BURNING_PARTICLE, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.MERCY_CADUCEUS_BLASTER, eventPlayer, eventPlayer.ability2Chase, null, 0.05)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.MERCY_CADUCEUS_BLASTER, eventPlayer, eventPlayer.ability3Chase, null, 0.05)
    eventPlayer.effects.append(getLastCreatedEntity())
    waitUntil(not (eventPlayer.ability2Array[0] and eventPlayer.ability1Array[0] == 1 and eventPlayer.isAlive() and eventPlayer.init[0]), 999999995904)
    destroyEffect(eventPlayer.effects)


rule "Circmambience Earth":
    @Event eachPlayer
    @Hero zenyatta
    #@Condition eventPlayer.ability1Chase > 0
    @Condition eventPlayer.ability2Array[0] != false
    @Condition eventPlayer.ability1Array[0] == 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.init[0] != false
    
    destroyEffect(eventPlayer.effects)
    eventPlayer.effects = []
    wait(false)
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.ROADHOG_SCRAP_BALL, eventPlayer, eventPlayer.ability2Chase, null)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.ROADHOG_SCRAP_BALL, eventPlayer, eventPlayer.ability3Chase, null)
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.setDamageReceived(60)
    eventPlayer.moveSpeed[false] -= 20
    waitUntil(not (eventPlayer.ability2Array[0] and eventPlayer.ability1Array[0] == 2 and eventPlayer.isAlive() and eventPlayer.init[0]), 999999995904)
    eventPlayer.setDamageReceived(100)
    eventPlayer.moveSpeed[false] += 20
    destroyEffect(eventPlayer.effects)


rule "Circmambience Water":
    @Event eachPlayer
    @Hero zenyatta
    #@Condition eventPlayer.ability1Chase > 0
    @Condition eventPlayer.ability2Array[0] != false
    @Condition eventPlayer.ability1Array[0] == 3
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.init[0] != false
    
    wait(false)
    destroyEffect(eventPlayer.effects)
    eventPlayer.effects = []
    createEffect(getAllPlayers(), Effect.WRECKING_BALL_ADAPTIVE_SHIELD_TARGET, Color.TEAM_1, eventPlayer, true)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.ECHO_STICKY_BOMB, getAllPlayers(), eventPlayer.ability2Chase, null)
    eventPlayer.effects.append(getLastCreatedEntity())
    createProjectileEffect(getAllPlayers(), Projectile.ECHO_STICKY_BOMB, getAllPlayers(), eventPlayer.ability3Chase, null)
    eventPlayer.effects.append(getLastCreatedEntity())
    eventPlayer.startHealingOverTime(eventPlayer, 99999, 30)
    eventPlayer.ability2Array[false] = getLastHealingOverTimeId()
    waitUntil(not (eventPlayer.ability2Array[0] and eventPlayer.ability1Array[0] == 3 and eventPlayer.isAlive() and eventPlayer.init[0]), 999999995904)
    stopHealingOverTime(eventPlayer.ability2Array[0])
    destroyEffect(eventPlayer.effects)


rule "Set Burn":
    @Event playerDealtDamage
    @Hero zenyatta
    #@Condition eventPlayer.ability1Chase > 0
    @Condition eventPlayer.ability1Array[0] == 1
    @Condition (eventAbility[0] or eventDamage > 10) == true
    
    victim.setStatusEffect(eventPlayer, Status.BURNING, 1.5)
    victim.startDamageOverTime(eventPlayer, 1.5, eventDamage * 0.2)


