settings {
    "main": {
        "description": "The objective looses health when there are titans(rein) on it. Right Mouse to use grapple hook (surfaces or titans) and hit the napes of the titans for bonus damage. Human(genji) upgrades available at the objective Defend it at all costs! Difficulty options available in Workshop Settings. Attack On Titan PVE with Upgrades | v1.0.3 by WildByte#1143"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "assault": {
            "enabled": false,
            "captureSpeed%": 10
        },
        "tdm": {
            "enabledMaps": [
                "workshopExpanseNight"
            ],
            "gameLengthInMn": 5,
            "scoreToWin": 200
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillFeed": false,
            "enableRandomHeroes": true,
            "respawnTime%": 0,
            "spawnHealthPacks": "enabled"
        }
    },
    "heroes": {
        "team1": {
            "enabledHeroes": [
                "ashe",
                "bastion",
                "doomfist",
                "genji",
                "pharah"
            ]
        },
        "allTeams": {
            "ashe": {
                "ammoClipSize%": 25,
                "ability1Cooldown%": 50,
                "ability1EnemyKb%": 200,
                "ability1SelfKb%": 25,
                "enableAbility2": false,
                "health%": 500,
                "enableInfiniteAmmo": true,
                "combatUltGen%": 200
            },
            "bastion": {
                "enableSecondaryFire": false,
                "health%": 500,
                "enableInfiniteUlt": true,
                "movementSpeed%": 165,
                "enablePrimaryFire": false,
                "enableAbility1": false,
                "enableSpawningWithUlt": true
            },
            "brigitte": {
                "enableSecondaryFire": false,
                "health%": 500,
                "movementSpeed%": 145,
                "combatUltGen%": 200,
                "ability1Kb%": 200
            },
            "doomfist": {
                "health%": 500,
                "ultKb%": 200,
                "ability1Cooldown%": 75,
                "secondaryFireCooldown%": 75,
                "secondaryFireKb%": 200,
                "ability2Cooldown%": 75,
                "combatUltGen%": 200
            },
            "genji": {
                "ability2Cooldown%": 50,
                "health%": 10,
                "enableInfiniteUlt": true,
                "jumpVerticalSpeed%": 120,
                "movementSpeed%": 120,
                "enablePrimaryFire": false,
                "enableSecondaryFire": false,
                "enableSpawningWithUlt": true
            },
            "pharah": {
                "ammoClipSize%": 50,
                "ability2Kb%": 200,
                "health%": 10,
                "enablePassive": false,
                "ability1Acceleration%": 120,
                "ability1Cooldown%": 60,
                "jumpVerticalSpeed%": 120,
                "movementSpeed%": 120,
                "projectileSpeed%": 200,
                "primaryFireKb%": 50,
                "combatUltGen%": 20,
                "passiveUltGen%": 50,
                "ultGen%": 50
            },
            "reinhardt": {
                "enableSecondaryFire": false,
                "ability2Cooldown%": 50,
                "healingReceived%": 50,
                "health%": 500,
                "combatUltGen%": 200
            },
            "enabledHeroes": [
                "brigitte",
                "reinhardt"
            ]
        }
    },
    "workshop": {
        "Endless": true
    }
}

#Global variables

globalvar CANHOOKSHOT 0
globalvar TITANCOUNT 1
globalvar OBJECTIVE 2
globalvar TITANHEROES 3
globalvar POSNEG 4
globalvar TITANCAPMULT 5
globalvar SHOPS 6
globalvar DIFFICULTY 7
globalvar STREAK 8
globalvar ROUND 10
globalvar ENDLESS 11

#Player variables

playervar hitPlayer 0
playervar hit 1
playervar setupTrigger 2
playervar ropeEffect 3
playervar killStreak 4
playervar hasHUD 6
playervar healthBonus 7
playervar damageBonus 8
playervar shiftTimer 9
playervar shiftCharges 10
playervar antipersonnel 11
playervar signalCharges 12
playervar coin 13
playervar timerHud 14
playervar tempVector 15
playervar int_i 16
playervar titanTarget 17
playervar hitVector 18
playervar isPlayer 19
playervar gas 20

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "Gamemode Setup":
    disableMusic()
    getAllPlayers().disableDeathSpectateAllPlayers()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableScoring()
    setObjectiveDescription(getAllPlayers(), "Defend the Objective!", HudReeval.VISIBILITY_AND_STRING)
    createIcon(getAllPlayers(), OBJECTIVE, Icon.SPADE, IconReeval.VISIBILITY_AND_POSITION, Color.WHITE)


rule "General Setup (Inspector off, Hookshot Heroes, Setup vector arrays)":
    disableInspector()
    OBJECTIVE = vect(0, 0, 0)
    POSNEG = [1, -1]
    CANHOOKSHOT = [Hero.GENJI, Hero.PHARAH]
    for TITANCOUNT in range(getNumberOfPlayers(Team.2), 6):
        createDummy(Hero.REINHARDT, Team.2, TITANCOUNT, vect(random.choice(POSNEG) * random.randint(60, 100), 1, random.choice(POSNEG) * random.randint(60, 100)), null)
    TITANHEROES = [Hero.BRIGITTE, Hero.REINHARDT, Hero.ASHE, Hero.DOOMFIST, Hero.BASTION]
    createEffect(getAllPlayers(), Effect.RING, Color.WHITE, vect(0, 1, 0), 25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    SHOPS = [vect(10, 0, 0) + OBJECTIVE, vect(-10, 0, 0) + OBJECTIVE, vect(0, 0, 10) + OBJECTIVE, vect(0, 0, -10) + OBJECTIVE, vect(0, 0, 0), vect(5, 0, 5), vect(-5, 0, -5)]
    STREAK = [5, 10, 15, 20, 25]
    ROUND = 0
    ENDLESS = createWorkshopSettingBool("Game Modifiers", "Endless", false)


rule "Player Setup/Reset Actions (Scale, Healing)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.setupTrigger == true
    @Condition eventPlayer.isAlive() == true
    
    if eventPlayer.antipersonnel == false and eventPlayer.getTeam() == Team.1:
        eventPlayer.startForcingHero(Hero.GENJI)
    elif eventPlayer.getTeam() == Team.1:
        eventPlayer.startForcingHero(Hero.PHARAH)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setupTrigger = false
    if eventPlayer.getHero() == Hero.GENJI:
        eventPlayer.startScalingSize(0.3)
        smallMessage(eventPlayer, "Right click for Hookshot!")
        wait(1)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        eventPlayer.startModifyingVoicelinePitch(1.2)
    elif eventPlayer.getHero() == Hero.PHARAH:
        eventPlayer.setProjectileSpeed(200)
        eventPlayer.startScalingSize(0.3)
        smallMessage(eventPlayer, "Right click for Hookshot!")
        eventPlayer.startModifyingVoicelinePitch(1.2)
    else:
        eventPlayer.startHealingOverTime(eventPlayer, 9999, 5)
        eventPlayer.startScalingSize(3)
        eventPlayer.startModifyingVoicelinePitch(0.7)
    eventPlayer.isPlayer = false


rule "Player Hud Setup":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.hasHUD == false
    
    hudHeader(eventPlayer, l"{0} {1}".format("Health: ", l"{0}%".format(100 + eventPlayer.healthBonus)), HudPosition.LEFT, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("Damage: ", l"{0}%".format(100 + eventPlayer.damageBonus)), HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("TitanShift Charges: ", eventPlayer.shiftCharges), HudPosition.LEFT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("Smoke Signals: ", eventPlayer.signalCharges), HudPosition.LEFT, 0, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("Money: ", eventPlayer.coin), HudPosition.LEFT, 0, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("Round: ", ROUND), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, l"{0} {1}".format("Gas:", eventPlayer.gas), HudPosition.LEFT, 0, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(eventPlayer, "Right Mouse to grapple onto surfaces and titans!", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #MCB1F
    hudSubheader(eventPlayer, "Code: MCB1F", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.hasHUD = true
    eventPlayer.gas = 100


rule "Round Time Setup":
    @Condition isGameInProgress() == true
    
    setMatchTime(130)
    ROUND = 1
    getPlayers(Team.2).startHealingOverTime(null, 9999, 20)


rule "Hookshot Test":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.hit == false
    @Condition eventPlayer.getHero() in CANHOOKSHOT == true
    
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getPlayers(Team.2), eventPlayer, true)) <= 30:
        if raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getPlayers(Team.2), eventPlayer, true) == true:
            eventPlayer.hitPlayer = raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getPlayers(Team.2), eventPlayer, true)
            eventPlayer.isPlayer = true
            eventPlayer.hit = true
        elif raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true) == true:
            eventPlayer.hitVector = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, eventPlayer, eventPlayer, true)
            eventPlayer.isPlayer = false
            eventPlayer.hit = true


rule "Hookshot Actions":
    @Event eachPlayer
    @Condition eventPlayer.hit == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.getPosition() + vect(0, -0.4, 0), 1.5)
    if eventPlayer.getHero() == Hero.GENJI:
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer + vect(0.2, -0.05, 0), eventPlayer.hitVector.getPosition(), Color.WHITE, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.ropeEffect[0] = getLastCreatedEntity()
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer + vect(-0.2, -0.05, 0), eventPlayer.hitVector.getPosition(), Color.WHITE, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.ropeEffect[1] = getLastCreatedEntity()
    else:
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer, eventPlayer.hitVector.getPosition(), Color.WHITE, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.ropeEffect[0] = getLastCreatedEntity()
    eventPlayer.startAcceleration(directionTowards(eventPlayer, eventPlayer.hitVector.getPosition()), 150, 100 * (distance(eventPlayer, eventPlayer.hitVector.getPosition()) / 100), Relativity.TO_WORLD)


rule "Hookshot Dynamic Loop - Thank you NyaWalking for helping me get this working!":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isPlayer == true
    
    wait(0.05, Wait.ABORT_WHEN_FALSE)
    eventPlayer.hitVector = eventPlayer.hitPlayer + vect(0, 5, 0)
    if ruleCondition:
        loop()


rule "Hookshot End":
    @Event eachPlayer
    @Condition eventPlayer.hit == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    
    eventPlayer.hit = false
    eventPlayer.stopAcceleration()
    destroyEffect(eventPlayer.ropeEffect[0])
    destroyEffect(eventPlayer.ropeEffect[1])
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.hitPlayer = null
    eventPlayer.isPlayer = false


rule "Player Died Trigger":
    @Event playerDied
    @Team 1
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    destroyEffect(eventPlayer.ropeEffect[0])
    destroyEffect(eventPlayer.ropeEffect[1])
    eventPlayer.setupTrigger = true
    eventPlayer.ropeEffect = null
    eventPlayer.stopAcceleration()
    eventPlayer.teleport(OBJECTIVE + vect(random.choice(POSNEG) * random.randint(30, 50), 1, random.choice(POSNEG) * random.randint(30, 50)))
    eventPlayer.killStreak = 0
    eventPlayer.resurrect()


rule "New Join Trigger":
    @Event playerJoined
    
    eventPlayer.setupTrigger = true


rule "Initial Spawn Trigger":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.setupTrigger == false
    
    eventPlayer.setupTrigger = true


rule "Titan Died":
    @Event playerDied
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.teleport(OBJECTIVE + vect(random.choice(POSNEG) * random.randint(60, 100), 1, random.choice(POSNEG) * random.randint(60, 100)))
    eventPlayer.resurrect()
    eventPlayer.titanTarget = null


rule "Nape":
    @Event playerTookDamage
    @Team 2
    @Hero reinhardt
    @Condition distance(eventPlayer.getEyePosition(), attacker.getPosition()) <= 2
    
    damage(eventPlayer, attacker, 500)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, vect(0, 6, 0) + eventPlayer.getPosition(), 1)


rule "Create shop rings":
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, SHOPS[0], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, SHOPS[1], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.ORANGE, SHOPS[2], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, SHOPS[3], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, SHOPS[4], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.TURQUOISE, SHOPS[5], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.WHITE, SHOPS[6], 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Create text":
    createInWorldText(getAllPlayers(), "Buy Health Boost (50)", SHOPS[0], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    createInWorldText(getAllPlayers(), "Buy Damage Boost (50)", SHOPS[1], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    createInWorldText(getAllPlayers(), "Buy Smoke Signal (150) (Crouch + Melee to use)", SHOPS[2], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE)
    createInWorldText(getAllPlayers(), l"{0} {1}".format(heroIcon(Hero.PHARAH), "Buy Anti-Personnel Gear (10000)"), SHOPS[3], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    createInWorldText(getAllPlayers(), "Buy Titanshift (2000) (Crouch + Reload to use)", SHOPS[4], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    createInWorldText(getAllPlayers(), "Buy Gas (5)", SHOPS[5], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.TURQUOISE)
    createInWorldText(getAllPlayers(), "Heal Objective (1000)", SHOPS[6], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)


rule "Life Upgrade":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[0].x, eventPlayer.getPosition().y, SHOPS[0].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.healthBonus <= 1500
    @Condition eventPlayer.coin >= 50
    
    eventPlayer.coin += -50
    eventPlayer.healthBonus += 5
    eventPlayer.setMaxHealth(100 + eventPlayer.healthBonus)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, SHOPS[0], 4)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    heal(eventPlayer, null, eventPlayer.getMaxHealth())
    lbl_1:
    if ruleCondition:
        loop()


rule "Damage Upgrade":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[1].x, eventPlayer.getPosition().y, SHOPS[1].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.damageBonus <= 1500
    @Condition eventPlayer.coin >= 50
    
    eventPlayer.coin += -50
    eventPlayer.damageBonus += 5
    eventPlayer.setDamageDealt(100 + eventPlayer.damageBonus)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, SHOPS[1], 4)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "Buy Anti-Personnel Gear":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[3].x, eventPlayer.getPosition().y, SHOPS[3].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.antipersonnel == false
    @Condition eventPlayer.coin >= 10000
    
    eventPlayer.coin += -10000
    eventPlayer.startForcingHero(Hero.PHARAH)
    eventPlayer.antipersonnel = true
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.AQUA, SHOPS[3], 3)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "Buy Smoke Signal":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[2].x, eventPlayer.getPosition().y, SHOPS[2].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.signalCharges < 10
    @Condition eventPlayer.coin >= 150
    
    eventPlayer.coin += -150
    eventPlayer.signalCharges++
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, SHOPS[2], 3)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "Titanshift Charges":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[4].x, eventPlayer.getPosition().y, SHOPS[4].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.shiftCharges < 3
    @Condition eventPlayer.coin >= 2000
    
    eventPlayer.coin += -2000
    eventPlayer.shiftCharges++
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, SHOPS[4], 4)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "Buy Gas":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[5].x, eventPlayer.getPosition().y, SHOPS[5].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.gas < 100
    @Condition eventPlayer.coin >= 5
    
    eventPlayer.coin += -5
    eventPlayer.gas++
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.TURQUOISE, SHOPS[5], 3)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "Heal Objective":
    @Event eachPlayer
    @Condition distance(eventPlayer, vect(SHOPS[6].x, eventPlayer.getPosition().y, SHOPS[6].z)) <= 1.5
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition teamScore(Team.2) > 10
    @Condition eventPlayer.coin >= 1000
    
    eventPlayer.coin += -1000
    addToTeamScore(Team.2, -10)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, SHOPS[6], 3)
    if eventPlayer.isHoldingButton(Button.CROUCH) == true:
        goto lbl_0
    smallMessage(eventPlayer, l"{0} {1}".format(l"Upgrade", l"Bought"))
    lbl_0:
    if eventPlayer.isHoldingButton(Button.CROUCH) == false:
        goto lbl_1
    wait()
    if ruleCondition:
        loop()
    lbl_1:


rule "10Money / 2Sec":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.coin <= 2000
    
    eventPlayer.coin += 10
    wait(2)
    if ruleCondition:
        loop()


rule "Money on kill":
    @Event playerEarnedElimination
    @Team 1
    
    eventPlayer.coin += 200
    smallMessage(eventPlayer, "+200")


rule "Titanshift Start":
    @Event eachPlayer
    @Team 1
    #@Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.shiftCharges > 0
    @Condition eventPlayer.getHero() in CANHOOKSHOT == true
    
    eventPlayer.shiftCharges += -1
    eventPlayer.disallowButton(Button.RELOAD)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer, 7)
    wait(0.25)
    eventPlayer.startScalingSize(2)
    eventPlayer.startForcingHero(random.choice(TITANHEROES))
    eventPlayer.shiftTimer = 30
    chaseAtRate(eventPlayer.shiftTimer, 0, 1)
    hudHeader(eventPlayer, eventPlayer.shiftTimer, HudPosition.TOP, 0, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.timerHud = getLastCreatedText()
    eventPlayer.setDamageDealt(100 + eventPlayer.damageBonus * 2)
    if eventPlayer.getHero() == Hero.BASTION:
        wait(1)
        eventPlayer.forceButtonPress(Button.ULTIMATE)


rule "Titanshift End":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.shiftTimer <= 0
    @Condition eventPlayer.getHero() in TITANHEROES == true
    
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer, 15)
    stopChasing(eventPlayer.shiftTimer)
    wait(0.25)
    eventPlayer.startScalingSize(0.3)
    eventPlayer.shiftTimer = 30
    destroyHudText(eventPlayer.timerHud)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.setDamageDealt(100 + eventPlayer.damageBonus)
    if eventPlayer.antipersonnel == true:
        eventPlayer.startForcingHero(Hero.PHARAH)
    else:
        eventPlayer.startForcingHero(Hero.GENJI)
        wait(1)
        eventPlayer.forceButtonPress(Button.ULTIMATE)


rule "Smoke Signals":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.signalCharges > 0
    
    eventPlayer.signalCharges += -1
    eventPlayer.tempVector = raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)
    if eventPlayer.tempVector == null:
        eventPlayer.tempVector = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100, getAllPlayers(), eventPlayer, true)
    for eventPlayer.int_i in range(50):
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.tempVector + vect(0, eventPlayer.int_i, 0), 2)
    wait(1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.tempVector, 12)
    damage(getPlayersInRadius(eventPlayer.tempVector.getPosition(), 12, Team.2), eventPlayer, 400 + eventPlayer.damageBonus * 0.1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer.tempVector, 12)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)


rule "Gas dodge":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.gas > 0
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isJumping() == true
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    
    eventPlayer.gas += -1
    eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 12, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.getPosition() + vect(0, -2, 0), 0.5)


rule "Reset gasTime/jumpCount on ground":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.V != 0
    
    eventPlayer.V = 0
    eventPlayer.W = 0


rule "Titan AI - Target in range":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.titanTarget == null
    @Condition distance(eventPlayer, getClosestPlayer(eventPlayer, Team.1)) < 20
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.titanTarget = getClosestPlayer(eventPlayer, Team.1)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.titanTarget.getPosition()), 100)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.titanTarget.getPosition()), 1, Relativity.TO_WORLD)


rule "Titan AI - LOS firestrike":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.titanTarget.getPosition()) == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "Titan AI - Target in melee range":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition distance(eventPlayer, getClosestPlayer(eventPlayer, Team.1)) < 6
    @Condition eventPlayer.titanTarget != null
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(1)
    if ruleCondition:
        loop()


rule "Titan AI - Target out of range":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.titanTarget == null
    @Condition distance(eventPlayer, getClosestPlayer(eventPlayer, Team.1)) > 20
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.titanTarget = null
    eventPlayer.stopThrottleInDirection()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), OBJECTIVE.getPosition()), 100)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, OBJECTIVE), 1, Relativity.TO_WORLD)


rule "Titan AI - Move towards objective / charge if over round 2":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, OBJECTIVE) > 23
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.titanTarget == null
    
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, OBJECTIVE), 1, Relativity.TO_WORLD)
    if ROUND > 3:
        eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "Titan AI - Stop at objective":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, OBJECTIVE) <= 23
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.stopThrottleInDirection()


rule "Objective - Titan Claiming":
    @Condition len(getPlayersInRadius(OBJECTIVE, 23, Team.2)) > 0
    
    addToTeamScore(Team.2, len(getPlayersInRadius(OBJECTIVE, 23, Team.2)) * TITANCAPMULT)
    wait(4)
    if ruleCondition:
        loop()


rule "Workshop Settings - Difficulty":
    #@Condition isGameInProgress() == true
    
    DIFFICULTY = createWorkshopSettingInt("Difficulty", "Cadet 1 / Scout 2 / Ackerman 3", 2, 1, 3)
    if DIFFICULTY == 1:
        TITANCAPMULT = 0.5
        getPlayers(Team.2).setMoveSpeed(60)
    elif DIFFICULTY == 2:
        TITANCAPMULT = 1
        getPlayers(Team.2).setMoveSpeed(100)
    elif DIFFICULTY == 3:
        TITANCAPMULT = 2
        getPlayers(Team.2).setMoveSpeed(110)


rule "Player - Killstreak manager":
    @Event playerEarnedElimination
    @Team 1
    
    eventPlayer.killStreak++
    if eventPlayer.killStreak in STREAK == true:
        bigMessage(eventPlayer, "Streak Bonus! +750")
        eventPlayer.coin += 750


rule "Break between rounds":
    @Condition getMatchTime() <= 2 == true
    @Condition isGameInProgress() == true
    
    #Break Start
    playEffect(getPlayers(Team.1), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, getPlayers(Team.1), 60)
    kill(getPlayers(Team.2))
    wait(1)
    getPlayers(Team.2).setMaxHealth(500 + ROUND * 10)
    getPlayers(Team.2).setStatusEffect(null, Status.ASLEEP, 20)
    setMatchTime(140)
    bigMessage(getAllPlayers(), "Break time! 20 seconds!")
    setObjectiveDescription(getAllPlayers(), "Break time! Say hello!", HudReeval.VISIBILITY_AND_STRING)
    #Don't increase score at the start
    if ROUND == 0:
        goto lbl_0
    addToTeamScore(Team.1, 1)
    lbl_0:
    ROUND++
    #Scout win at the end of last round
    if ROUND > createWorkshopSettingInt("Game Modifiers", "Rounds", 5, 5, 30) and ENDLESS == false:
        declareTeamVictory(Team.1)
    wait(19)
    #Break End
    bigMessage(getAllPlayers(), "Break's over, scouts! Titans incoming!")
    setObjectiveDescription(getAllPlayers(), "Defend the Objective!", HudReeval.VISIBILITY_AND_STRING)
    playEffect(getPlayers(Team.1), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, getPlayers(Team.1), 60)


rule "Titans win if they cap objective":
    @Condition teamScore(Team.2) >= 200
    
    declareTeamVictory(Team.2)


rule "Gamemode Created by WildByte#1143. Feel free to build upon or modify the code. I only ask that you credit me for my work :)":
    @Disabled
    @Delimiter
    


