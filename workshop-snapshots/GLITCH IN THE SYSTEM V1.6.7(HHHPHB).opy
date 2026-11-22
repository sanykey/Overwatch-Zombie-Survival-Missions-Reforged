settings {
    "main": {
        "description": "GLITCH IN THE ******* V1.6.7 - A visually stunning horror gamemode by Therister#1251. ==== My YouTube and Discord >bit.ly/therister< ==== Grandeur Hammers Discord >bit.ly/grandeurhammers< ==== Find at least 10 small, purple orbs carefully hidden throughout the map. Once 10 orbs are found, the exit will be unlocked. Find the exit and group up there with your team before time runs out. Ŧħḝṝế'ƨ ŋøƚћḭŉǥ ȅŀşє ȋņ ƫҺїṧ ǥǟмḛḿðđę.",
        "modeName": "GLITCH IN THE SYSTEM V1.6.7"
    },
    "lobby": {
        "mapRotation": "paused",
        "spectatorSlots": 6,
        "team1Slots": 4,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                {
                    "hollywood": [
                        "morning",
                        "972777519512068292",
                        "night"
                    ]
                }
            ]
        },
        "general": {
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "enableKillFeed": false,
            "respawnTime%": 0,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability1Cooldown%": 50
            },
            "ashe": {
                "ability1Cooldown%": 40
            },
            "brigitte": {
                "shieldBashCooldown%": 71
            },
            "cassidy": {
                "ability1Cooldown%": 30,
                "ability2Cooldown%": 50
            },
            "doomfist": {
                "ability1Cooldown%": 110,
                "secondaryFireCooldown%": 160
            },
            "echo": {
                "ability1Cooldown%": 70,
                "enableUlt": false
            },
            "genji": {
                "ability1Cooldown%": 60
            },
            "hanzo": {
                "ability3Cooldown%": 50,
                "ability3Distance%": 150
            },
            "junkrat": {
                "ability1Cooldown%": 60,
                "ability2Cooldown%": 50
            },
            "lucio": {
                "movementSpeed%": 70,
                "secondaryFireCooldown%": 150
            },
            "moira": {
                "ability1Cooldown%": 60
            },
            "pharah": {
                "ability2Cooldown%": 70,
                "passiveMaxTime%": 80,
                "passiveRechargeRate%": 80,
                "passiveVerticalSpeed%": 80
            },
            "reaper": {
                "ability2Cooldown%": 60,
                "ability1Cooldown%": 70
            },
            "sigma": {
                "ability2Cooldown%": 0,
                "ability2Kb%": 130,
                "enableSecondaryFire": false,
                "ultGen%": 200
            },
            "soldier": {
                "healingDealt%": 80,
                "secondaryFireKb%": 200,
                "movementSpeed%": 90
            },
            "sombra": {
                "combatUltGen%": 0,
                "passiveUltGen%": 0,
                "ultGen%": 10
            },
            "tracer": {
                "ability1Cooldown%": 250
            },
            "widowmaker": {
                "ability1Cooldown%": 15,
                "enableInfiniteUlt": true,
                "combatUltGen%": 0,
                "passiveUltGen%": 0,
                "ultGen%": 10
            },
            "winston": {
                "enableAbility2": false,
                "ability1Cooldown%": 60
            },
            "enabledHeroes": [
                "ashe",
                "brigitte",
                "cassidy",
                "dva",
                "doomfist",
                "echo",
                "genji",
                "hanzo",
                "junkrat",
                "pharah",
                "reaper",
                "sigma",
                "soldier",
                "winston"
            ]
        }
    }
}

#Global variables

globalvar i 0
globalvar unicode_chars 1
globalvar death_spot 2
globalvar game_over_spot 3
globalvar game_over_somb 4
globalvar dark_spot 5
globalvar T_char 6
globalvar U_char 7
globalvar R_char 8
globalvar N_char 9
globalvar I_char 10
globalvar G_char 11
globalvar O_char 12
globalvar F_char 13
globalvar H_char 14
globalvar E_char 15
globalvar L_char 16
globalvar S_char 17
globalvar jumpscare_somb 18
globalvar TURNING_OFF 19
globalvar THE_LIGHTS 20
globalvar jumpscare_victim 21
globalvar random_scare 22
globalvar no_entry 23
globalvar random_vector 24
globalvar i2 25
globalvar player_spawns 26
globalvar player_spawn_doors 27
globalvar orb_spawns_1 28
globalvar orb_spawns_2 29
globalvar orb_spawns_3 30
globalvar actual_orbs 31
globalvar actual_orbs_effect 32
globalvar orbs_collected 33
globalvar orb_spawns_4 34
globalvar exit_mode 35
globalvar more_doors 36
globalvar actual_exit 37
globalvar random_scary_text_index 38
globalvar random_scary_text_displace 39
globalvar random_scary_text_id 40
globalvar GLITCH 41
globalvar C_char 42
globalvar A_char 43
globalvar glitchy_obj 44
globalvar OBJECTIVE 45
globalvar FIND_THE_EXIT 46
globalvar spawn_victim_1 47
globalvar subtype_spawner 48
globalvar spawn_victim_2 50
globalvar spawn_victim_3 51
globalvar K_char 52
globalvar HACK 53
globalvar TOO_LATE 54
globalvar first_player_spawn 55
globalvar GLITCH_2 56
globalvar sound_fx 57
globalvar toolate 58
globalvar VERSION 59
globalvar HURRY_UP 60
globalvar tooltips 61
globalvar widow_spot 63
globalvar camera_shake_1 64
globalvar camera_shake_2 65
globalvar jumpscare_frequency 66
globalvar spawn_frequency 67
globalvar bot_lifetime 68
globalvar chance_of_crashing_singleplayer 69
globalvar chance_of_crashing_multiplayer 70
globalvar fog_distance 71
globalvar wwwww 72
globalvar orb_quantity 73
globalvar wallhacks 74
globalvar bot_1_spawner 76
globalvar bot_2_spawner 77
globalvar crash_stopper 78
globalvar lol 79
globalvar hudsaver 80
globalvar hudsaver2 81

#Player variables

playervar target 0
playervar target_pos_cache 1
playervar dest 2
playervar magnitude 3
playervar stuck_pos 4
playervar stuck_timer 5
playervar i 6
playervar voice 7
playervar exit_safe 8
playervar type 9
playervar spawned_in 10
playervar within_reach_of_orb 11
playervar scawy_fog 12
playervar lifespan 13
playervar begin_lifespan 14
playervar being_chased_by 15
playervar killer 17
playervar random_trans 18
playervar random_dir 19
playervar initialised 20
playervar random 21

#Subroutine names

subroutine translocate 0
subroutine kick 1

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "global init":
    disableInspector()
    jumpscare_frequency = createWorkshopSettingFloat("Visual/Audio Settings", "Hallucinations Frequency", 100, 20, 500)
    wallhacks = createWorkshopSettingBool("Visual/Audio Settings", "Enable Limited Wallhacks", true)
    spawn_frequency = createWorkshopSettingFloat("Difficulty Settings", "Glitch Spawn Frequency", 100, 20, 500)
    bot_lifetime = createWorkshopSettingFloat("Difficulty Settings", "Glitch Lifetime Duration", 100, 20, 500)
    chance_of_crashing_singleplayer = createWorkshopSettingFloat("Game Over", "Chance of Erasure (Singleplayer)", 33, 0, 100)
    chance_of_crashing_multiplayer = createWorkshopSettingFloat("Game Over", "Chance of Erasure (Multiplayer)", 33, 0, 100)
    fog_distance = createWorkshopSettingFloat("Visual/Audio Settings", "Fog Radius", 100, 20, 200)
    orb_quantity = createWorkshopSettingInt("Difficulty Settings", "Number of Orbs in the Map", 14, 14, 60)
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b", false))
    if __getCurrentMap__() == Map.HORIZON_LUNAR_COLONY:
        dark_spot = vect(4.909, 100, -91.24)
        death_spot = vect(-871.051, 210.709, -432.352)
        game_over_spot = vect(-872.289, 209.319, -430.449)
    elif __getCurrentMap__() == Map.HOLLYWOOD_HALLOWEEN:
        widow_spot = vect(-95.211, 53.057, 27.012)
        dark_spot = vect(87.133, 52.717, 79.035)
        death_spot = vect(-458.918, 95.393, -202.512)
        game_over_spot = vect(-457.233, 94.362, -203.993)
    disableAnnouncer()
    disableMusic()
    wait(0.25)
    if wwwww:
        return
    createDummy(Hero.SOMBRA, Team.2, 5, game_over_spot, directionTowards(game_over_spot, death_spot))
    game_over_somb = getLastCreatedEntity()
    game_over_somb.startForcingPosition(game_over_spot, false)
    game_over_somb.startFacing(directionTowards(game_over_somb.getEyePosition(), death_spot), 9000)
    for i in range(false, 3, true):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, game_over_somb.getEyePosition() + game_over_somb.getFacingDirection() * 0.2, 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.RED, game_over_somb.getEyePosition() + game_over_somb.getFacingDirection() * 0.3, 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.RED, game_over_somb.getEyePosition() + game_over_somb.getFacingDirection() * 0.4, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.RING, Color.RED, game_over_somb.getEyePosition() + game_over_somb.getFacingDirection() * 0.1, 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    game_over_somb.setMaxHealth(1)
    for i in range(false, 5, true):
        createEffect(getAllPlayers().filter(lambda player: player.hasStatus(Status.HACKED)), Effect.BAD_AURA_SOUND, Color.WHITE, death_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers().filter(lambda player: player.hasStatus(Status.HACKED)), Effect.BEACON_SOUND, Color.WHITE, death_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers().filter(lambda player: player.hasStatus(Status.HACKED)), Effect.PICKUP_SOUND, Color.WHITE, death_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createDummy(Hero.WIDOWMAKER, Team.1, 5, widow_spot, null)
    getLastCreatedEntity().disableHeroHud()
    getLastCreatedEntity().startCamera(dark_spot, dark_spot + Vector.FORWARD)
    getLastCreatedEntity().setInvisibility(Invis.ALL)
    getLastCreatedEntity().startForcingPosition(widow_spot, false)
    createInWorldText(getAllPlayers().filter(lambda player: player.hasStatus(Status.HACKED)), TURNING_OFF, worldVector(vect(-1, 1.2, false), game_over_somb, Transform.ROTATION_AND_TRANSLATION), 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    createInWorldText(getAllPlayers().filter(lambda player: player.hasStatus(Status.HACKED)), THE_LIGHTS, worldVector(vect(true, 0.9, false), game_over_somb, Transform.ROTATION_AND_TRANSLATION), 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    hudText(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and not glitchy_obj), "\u2003OBJECTIVE:\u2003", null, " \nFind the exit!\n" if exit_mode else " \nFind {0} purple {1}.\n".format(10 - orbs_collected, "orbs" if orbs_collected < 9 else "orb"), HudPosition.TOP, -0.1, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    hudText(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and glitchy_obj), "\u2003{0}:\u2003".format(OBJECTIVE), null, " \n{0}!\n".format(FIND_THE_EXIT), HudPosition.TOP, -0.1, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers().filter(lambda player: toolate or player.isDummy() or player.hasStatus(Status.HACKED) or random_scary_text_index != null), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers().filter(lambda player: distance(player.getPosition(), actual_exit) <= 2 and actual_exit != null and not toolate and not player.hasStatus(Status.HACKED) and not random_scary_text_index), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nAll players must be at the exit together.\nYou are currently immune.", HudPosition.TOP, 10, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))
    smallMessage(null, createWorkshopSettingBool("\u200b", "\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b\u200b", false))


rule "stuck reset status":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED)) == false
    
    eventPlayer.stuck_timer = null


rule "target acquired":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.target != ((sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) and not player.isDummy() and not player.exit_safe and not player.hasStatus(Status.HACKED)), lambda x: distance(eventPlayer, x)))[0])
    @Condition (getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) and not player.isDummy() and not player.exit_safe and not player.hasStatus(Status.HACKED))) != []
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.initialised == true
    
    eventPlayer.target = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) and not player.isDummy() and not player.exit_safe and not player.hasStatus(Status.HACKED)), lambda x: distance(eventPlayer, x)))[0]
    eventPlayer.target.being_chased_by = eventPlayer
    wait(0.05)
    chaseAtRate(eventPlayer.random_trans, 3, true)
    if ruleCondition:
        loop()
    if not eventPlayer.begin_lifespan:
        eventPlayer.begin_lifespan = true
        chaseAtRate(eventPlayer.lifespan, false, true)


rule "target chase":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.target != null
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition()) == true
    @Condition eventPlayer.dest != eventPlayer.target
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.initialised == true
    
    eventPlayer.magnitude = 1
    stopChasing(eventPlayer.dest)
    eventPlayer.dest = eventPlayer.target
    wait(0.1)
    if not ruleCondition:
        return
    if eventPlayer.dest != eventPlayer.target:
        loop()


rule "target behind cover":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.target != null
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition()) == false
    @Condition eventPlayer.type == 2
    
    eventPlayer.dest = eventPlayer.target.getEyePosition()
    eventPlayer.target_pos_cache = [eventPlayer.target.getEyePosition()]
    chaseAtRate(eventPlayer.dest, eventPlayer.target_pos_cache[0], 9999)
    wait(0.1)
    if not ruleCondition:
        return
    if distance(eventPlayer.dest, eventPlayer.target_pos_cache[0]) > 0.5:
        loop()


rule "target pos cache update":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.target != null
    @Condition isInLoS(eventPlayer.target_pos_cache.last(), eventPlayer.target.getPosition()) == false
    @Condition eventPlayer.type == 2
    
    eventPlayer.target_pos_cache.append(eventPlayer.target.getEyePosition())


rule "target pos cache clear":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.target != null
    @Condition isInLoS(eventPlayer.target_pos_cache[true], eventPlayer.getEyePosition()) == true
    @Condition len(eventPlayer.target_pos_cache) > 1
    @Condition eventPlayer.type == 2
    
    wait(0.1)
    __skipIf__(len(eventPlayer.target_pos_cache) == 1, true)
    goto loc+true
    #pass
    pass #return
    del eventPlayer.target_pos_cache[0]
    wait(0.1)
    __loopIfConditionIsTrue__()


rule "jump":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getSpeedInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)), 0)) < 3
    @Condition eventPlayer.magnitude == 1
    @Condition eventPlayer.type == 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED)) == false
    
    if eventPlayer.getAltitude() < true:
        eventPlayer.applyImpulse(Vector.UP, 8, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.forceButtonPress(Button.MELEE)
    wait(true)
    if ruleCondition:
        loop()


rule "manouvre corner":
    @Event eachPlayer
    @Hero sombra
    @Condition distance(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), raycastHitPosition(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)), 0), null, eventPlayer, true)) < 0.9
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.magnitude > 0.1
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED)) == false
    
    wait(true)
    if not ruleCondition:
        return
    if distance(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), raycastHitPosition(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)) + 40, 0)) * 2), null, eventPlayer, true)) < distance(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), raycastHitPosition(worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(Vector.UP * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)) - 40, 0)) * 2), null, eventPlayer, true)):
        eventPlayer.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest)) + -90, -10), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest)) + 90, -10), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if ruleCondition:
        loop()


rule "widow":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.getSlot() == 5
    @Condition wallhacks == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    if ruleCondition:
        loop()
    wait(0.25)
    eventPlayer.disableHeroHud()


rule "sombra init":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.startModifyingVoicelinePitch(eventPlayer.voice)
    eventPlayer.disableNameplatesFor(getAllPlayers())
    eventPlayer.startCamera(death_spot, death_spot + (directionFromAngles(horizontalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-1, 1), verticalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-1, 1))), 50)
    if eventPlayer.type == 2:
        #eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.RED)
        #
        #
        #
        #
        #
        #
        #
        #chase(eventPlayer.random_trans, 3, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.lifespan = random.uniform(45, 75) * bot_lifetime * 0.01
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.dest), eventPlayer.magnitude, Relativity.TO_WORLD)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest), 9000)
        eventPlayer.setMaxHealth(1000)
        eventPlayer.startHealingOverTime(eventPlayer, 9999, 20)
        eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
        for eventPlayer.i in range(false, 19, true):
            createInWorldText(getAllPlayers().filter(lambda player: distance(eventPlayer, player) < 20), random.choice(unicode_chars), raycastHitPosition(worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION) + directionFromAngles(random.uniform(0, 360), 0) * 1.5, worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer, null, false), random.uniform(1, 2), Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
            if exit_mode:
                createInWorldText(getAllPlayers().filter(lambda player: distance(eventPlayer, player) < 20), random.choice(unicode_chars), raycastHitPosition(worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION) + directionFromAngles(random.uniform(0, 360), 0) * 1.5, worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer, null, false), random.uniform(1, 2), Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
            else:
                createInWorldText(getAllPlayers().filter(lambda player: distance(eventPlayer, player) < 20), random.choice(unicode_chars), raycastHitPosition(worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION) + directionFromAngles(random.uniform(0, 360), 0) * 1.5, worldVector(Vector.UP * random.uniform(0, 1.5), eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer, null, false), random.uniform(1, 2), Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE)
        eventPlayer.random_trans = random.uniform(-8, -4) + min(4, orbs_collected * 0.5)
        eventPlayer.random_dir = worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION)
        eventPlayer.magnitude = null
        eventPlayer.dest = eventPlayer.getEyePosition() + worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION)
        chaseAtRate(eventPlayer.dest, eventPlayer.getEyePosition() + eventPlayer.random_dir, 9999)
        eventPlayer.initialised = true


rule "translocate up 1":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isDummy() == true
    @Condition verticalAngleOfDirection(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest)) < -30
    @Condition distance(eventPlayer, eventPlayer.dest) > 4
    @Condition eventPlayer.magnitude == 1
    
    eventPlayer.random_trans = random.uniform(-4, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, false)
    eventPlayer.magnitude = null
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest + Vector.UP * eventPlayer.getVerticalFacingAngle() * -0.1 + Vector.UP * distance(eventPlayer.getEyePosition(), eventPlayer.dest) * 0.1), 9000)
    wait(0.1)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.1)
    wait(max(0.5, distance(eventPlayer, eventPlayer.dest) / 23))
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.magnitude = 1
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest), 9000)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.INTERACT)


rule "truly stuck init":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getSpeedInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)), 0)) < 3
    @Condition eventPlayer.magnitude == 1
    @Condition (distance(eventPlayer, eventPlayer.stuck_pos) > 5 or not eventPlayer.stuck_pos) == true
    @Condition eventPlayer.target != null
    @Condition eventPlayer.type == 2
    
    eventPlayer.stuck_pos = eventPlayer.getEyePosition()
    eventPlayer.stuck_timer = null
    wait(0.1)
    chaseAtRate(eventPlayer.stuck_timer, 4, true)


rule "truly stuck timer off":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.magnitude == 1
    @Condition distance(eventPlayer, eventPlayer.stuck_pos) > 5
    @Condition eventPlayer.type == 2
    
    stopChasing(eventPlayer.stuck_timer)


rule "truly stuck success":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.magnitude == 1
    @Condition eventPlayer.stuck_timer >= 4
    @Condition eventPlayer.dest in getAllPlayers() == false
    @Condition eventPlayer.target != null
    @Condition eventPlayer.type == 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED)) == false
    
    eventPlayer.forceButtonPress(Button.INTERACT)
    if distance(eventPlayer.dest, eventPlayer.target.getEyePosition()) > 5:
        eventPlayer.teleport(eventPlayer.dest)
    else:
        eventPlayer.teleport(nearestWalkablePosition(raycastHitPosition(eventPlayer.dest, eventPlayer.dest + directionTowards(eventPlayer.target.getEyePosition(), eventPlayer.dest) * 6, null, eventPlayer, true) + directionTowards(eventPlayer.dest, eventPlayer.target.getEyePosition())))
    wait()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, eventPlayer.getEyePosition(), 5)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.PURPLE, eventPlayer.getEyePosition(), 200)
    eventPlayer.stuck_timer = null


rule "within range":
    @Event eachPlayer
    @Hero sombra
    @Condition distance(eventPlayer, eventPlayer.target) < 2
    @Condition eventPlayer.target != null
    @Condition eventPlayer.type == 2
    
    eventPlayer.magnitude = null
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(0)
    while distance(eventPlayer, eventPlayer.target) < 6 and isInLoS(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition()):
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, false)
        wait(0.1)
        if not eventPlayer.target:
            break
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(100)
    if eventPlayer.target != null:
        eventPlayer.magnitude = 1


rule "visible":
    @Event eachPlayer
    @Hero sombra
    @Condition (getPlayersInRadius(eventPlayer, fog_distance * 0.2, Team.1).filter(lambda player: not player.isDummy())) != []
    @Condition (getPlayersInRadius(eventPlayer, fog_distance * 0.2, Team.1).filter(lambda player: not player.isDummy()).all(lambda x: not isInLoS(eventPlayer.getEyePosition(), x.getEyePosition()))) == true
    @Condition eventPlayer.type == 2
    
    eventPlayer.setInvisibility(Invis.NONE)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.setInvisibility(Invis.ALL)


rule "death":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition toolate == false
    
    eventPlayer.disableMessages()
    eventPlayer.disableHeroHud()
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.RED, eventPlayer.getPosition(), 2)
    game_over_somb.setStatusEffect(getPlayers(Team.2).exclude(game_over_somb), Status.HACKED, 5)
    game_over_somb.setStatusEffect(null, Status.ASLEEP, 0.001)
    eventPlayer.teleport(vect(false, 10000, false))
    eventPlayer.startCamera(death_spot, death_spot + (directionFromAngles(horizontalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-3, 3), verticalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-3, 3))), 150)
    wait(4)
    if getNumberOfPlayers(Team.1) > 2:
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.communicate(Comms.NEED_HELP)
        wait(0.1)
        if toolate:
            return
        eventPlayer.teleport(vect(false, -10000, false))
        eventPlayer.stopCamera()
    else:
        pauseMatchTime()
        destroyAllHudTexts()
        wait()
        hudSubtext(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
        wait(true)
        game_over_somb.setUltCharge(100)
        getPlayers(Team.1).startCamera(death_spot, game_over_somb.getEyePosition(), 150)
        getPlayers(Team.1).clearStatusEffect(Status.HACKED)
        game_over_somb.forceButtonPress(Button.ULTIMATE)
        destroyAllInWorldTexts()
        wait(0.3)
        i = random.uniform(0, 100)
        if i < chance_of_crashing_singleplayer:
            while toolate < 9:
                kick()
                wait(false)
        else:
            wait(0.3)
            while toolate < 9:


rule "target loss":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition (eventPlayer.target.hasStatus(Status.HACKED) or eventPlayer.target.exit_safe or eventPlayer.target.isDead()) == true
    
    eventPlayer.random_dir = worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION)
    eventPlayer.target = null
    eventPlayer.magnitude = null
    eventPlayer.dest = eventPlayer.getEyePosition() + worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION)
    chaseAtRate(eventPlayer.dest, eventPlayer.getEyePosition() + eventPlayer.random_dir, 9999)
    eventPlayer.stuck_timer = null
    stopChasing(eventPlayer.stuck_timer)
    stopChasing(eventPlayer.random_trans)
    eventPlayer.random_trans = random.uniform(-8, -4) + min(4, orbs_collected * 0.5)
    if exit_mode:
        eventPlayer.lifespan = null


rule "scawy fog":
    @Event eachPlayer
    @Team 1
    @Condition exit_mode == false
    @Condition eventPlayer.isDummy() == false
    
    createEffect(eventPlayer if eventPlayer.isAlive() else [], Effect.BAD_AURA, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * fog_distance * 0.2, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scawy_fog.append(getLastCreatedEntity())
    createEffect(eventPlayer if eventPlayer.isAlive() else [], Effect.BAD_AURA, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * fog_distance * -0.2, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scawy_fog.append(getLastCreatedEntity())


def translocate():
    @Name "translocate"
    
    eventPlayer.random_trans = random.uniform(-4, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, false)
    eventPlayer.magnitude = null
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest + Vector.UP * eventPlayer.getVerticalFacingAngle() * -0.1 + Vector.UP * distance(eventPlayer.getEyePosition(), eventPlayer.dest) * 0.1), 9000)
    wait(0.1)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.1)
    wait(max(0.5, distance(eventPlayer, eventPlayer.dest) / 23))
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.magnitude = 1
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest), 9000)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.INTERACT)


rule "translocate up 2":
    @Event eachPlayer
    @Hero sombra
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.dest) == true
    @Condition isInLoS(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.dest, eventPlayer.dest + Vector.DOWN * 2, null, eventPlayer, true) + Vector.UP * 0.5) == false
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.magnitude == 1
    
    eventPlayer.random_trans = random.uniform(-4, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, false)
    eventPlayer.magnitude = null
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest + Vector.UP * eventPlayer.getVerticalFacingAngle() * -0.1 + Vector.UP * distance(eventPlayer.getEyePosition(), eventPlayer.dest) * 0.1), 9000)
    wait(0.1)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.1)
    wait(max(0.5, distance(eventPlayer, eventPlayer.dest) / 23))
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.magnitude = 1
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest), 9000)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.INTERACT)


rule "chars":
    unicode_chars = ["å\u2028", "ä\u2028", "Ÿ\u2028", "¾\u2028", "ß\u2028", "ë\u2028", "/\u2028", "Á\u2028", "8\u2028", "9\u2028", "1\u2028", "0\u2028", "3\u2028", "2\u2028", "4\u2028", "5\u2028", "6\u2028", "7\u2028", "8\u2028", "Ş\u2028", "Ø\u2028", "Ṃ\u2028", "Ƃ\u2028", "Я\u2028", "Ѧ\u2028", "Ώ\u2028", "æ\u2028", ">\u2028", "±\u2028", "#\u2028", "%\u2028", "@\u2028", "¿\u2028", "?\u2028", "«\u2028", "!\u2028", "¡\u2028", "Ž\u2028", "§\u2028", "£\u2028", "Ǯ\u2028", "&\u2028", "Σ\u2028", "ξ\u2028", "Ϡ\u2028", "Ϯ\u2028", "Ҵ\u2028", "※\u2028", "∀\u2028", "™\u2028", "‽\u2028", "▒\u2028", "■\u2028", "□\u2028", "א\u2028", "א\u2028", "א\u2028", "א\u2028", "א\u2028"]
    T_char = ["T", "Ţ", "Ť", "Ŧ", "Ƭ", "Ʈ", "Ҭ", "Ṫ", "Ṭ", "Ṯ", "Ṱ"]
    U_char = ["U", "Ũ", "Ū", "Ŭ", "Ů", "Ű", "Ų", "Ư", "Ʊ", "Ʋ", "ΰ", "Ự", "Ử", "Ữ"]
    R_char = ["R", "Ŕ", "Ŗ", "Ř", "Ʀ", "Ȑ", "Ȓ", "Я", "я", "Ṙ", "Ṛ", "Ṝ", "Ṟ", "Я"]
    N_char = ["N", "Ń", "Ņ", "Ň", "Ŋ", "Ɲ", "Й", "Ӥ", "Ṅ", "Ṇ", "Ṉ", "Ṋ"]
    I_char = ["I", "¡", "Ì", "Í", "Î", "Ï", "Ĩ", "Ī", "Ĭ", "Į", "İ", "Ǐ", "Ȉ", "Ȋ", "Ί", "Ϊ", "Ḭ", "Ỉ", "Ị", "┃"]
    G_char = ["G", "Ĝ", "Ğ", "Ġ", "Ģ", "Ɠ", "Ǥ", "Ǧ", "Ǵ", "Ḡ"]
    O_char = ["O", "0", "Ò", "Ó", "Ô", "Õ", "Ö", "Ø", "Ō", "Ŏ", "Ő", "Ơ", "Ǒ", "Ǭ", "Ǫ", "Ǿ", "Ό", "Θ", "Ω", "σ", "Ф", "Ӧ", "Ө", "Ӫ", "Ộ", "Ọ", "Ợ", "○", "〇", "●"]
    F_char = ["F", "Ƒ", "Ϝ", "Ғ", "ғ", "Ḟ", "℉"]
    H_char = ["H", "Ĥ", "Ħ", "Ή", "Ң", "Ҥ", "Ӈ", "Ḧ", "Ḣ", "Ḥ", "Ḩ", "Ḫ"]
    E_char = ["E", "3", "È", "Ê", "Ë", "É", "Ē", "Ĕ", "Ė", "Ę", "Ě", "Ȅ", "Ȇ", "Ǝ", "Ɛ", "Έ", "Ξ", "Ӗ", "Ḙ", "Ḛ", "Ḝ", "Ẹ", "Ệ", "∃"]
    L_char = ["L", "Ĺ", "Ļ", "Ľ", "Ŀ", "Ł", "Ḷ", "Ḹ", "Ḻ", "Ḽ", "乚"]
    S_char = ["S", "5", "Ś", "Ŝ", "Ş", "Š", "Ș", "Ƽ", "Ƨ", "Ṡ", "Ṣ", "Ṥ", "Ṧ", "Ṩ"]
    C_char = ["C", "Ć", "Ç", "Ĉ", "Ċ", "Č", "Ɔ", "Ƈ", "Ϛ", "Ҁ", "Ҫ", "Ḉ", "℃"]
    A_char = ["A", "@", "À", "Ã", "Ä", "Å", "Ā", "Ă", "Ą", "Ȁ", "Ά", "Λ", "Ѧ", "Ḁ", "Ạ", "Ậ", "Ặ"]
    K_char = ["K", "Ķ", "Ǩ", "Ƙ", "К", "Ќ", "Қ", "Ҝ", "Ҟ", "Ҡ", "Ӄ", "Ḱ", "Ḳ", "Ḵ"]


rule "char randomise":
    @Condition getAllPlayers().any(lambda player: player.hasStatus(Status.HACKED)) == true
    
    TURNING_OFF = "{0}{1}{2}".format(random.choice(T_char), random.choice(U_char), "{0}{1}{2}".format(random.choice(R_char), random.choice(N_char), "{0}{1}{2}".format(random.choice(I_char), random.choice(N_char), "{0}\u2028\n\n\u2003\u2003\u2003\u2003\u2003{1}{2}".format(random.choice(G_char), random.choice(O_char), "{0}{1}".format(random.choice(F_char), random.choice(F_char))))))
    THE_LIGHTS = "{0}{1}{2}".format(random.choice(T_char), random.choice(H_char), "{0}\u2028\n\n\u2003\u2003\u2003{1}{2}".format(random.choice(E_char), random.choice(L_char), "{0}{1}{2}".format(random.choice(I_char), random.choice(G_char), "{0}{1}{2}".format(random.choice(H_char), random.choice(T_char), random.choice(S_char)))))
    wait()
    if ruleCondition:
        loop()


rule "random scare":
    @Condition exit_mode != 2
    @Condition orbs_collected >= 1
    
    wait(random.uniform(2000 / jumpscare_frequency, 2000 / jumpscare_frequency + 10) - getNumberOfLivingPlayers(Team.1) * (300 / jumpscare_frequency), Wait.ABORT_WHEN_FALSE)
    random_scare = random.randint(false, true)
    createDummy(Hero.SOMBRA, Team.2, 4, vect(10000, 10000, false), null)
    jumpscare_somb = getLastCreatedEntity()
    wait(0.25)
    jumpscare_somb.forceButtonPress(Button.ABILITY_1)
    jumpscare_victim = random.choice(getLivingPlayers(Team.1).filter(lambda player: player.spawned_in and not player.isDummy() and not player.hasStatus(Status.HACKED)))
    if random_scare:
        #disableEnvironmentCollision(jumpscare_somb, false)
        jumpscare_somb.setDamageReceived(0)
        jumpscare_somb.startFacing(directionTowards(jumpscare_somb.getEyePosition(), jumpscare_victim.getEyePosition()), 9000)
        wait(true, Wait.ABORT_WHEN_FALSE)
        jumpscare_somb.teleport(worldVector(Vector.FORWARD * 3, jumpscare_victim, Transform.ROTATION_AND_TRANSLATION))
        jumpscare_somb.startThrottleInDirection(directionTowards(jumpscare_somb, jumpscare_victim), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        wait(0.75)
        destroyDummy(Team.2, jumpscare_somb.getSlot())
    else:
        jumpscare_somb.setInvisibility(Invis.ALL)
        jumpscare_somb.setStatusEffect(null, Status.PHASED_OUT, 9999)
        wait(true, Wait.ABORT_WHEN_FALSE)
        random_scare = random.uniform(120, 240)
        jumpscare_somb.attachTo(jumpscare_victim, directionFromAngles(jumpscare_victim.getHorizontalFacingAngle() + random_scare, 0))
        jumpscare_somb.forceButtonPress(Button.ABILITY_1)
        wait(1.5)
        destroyDummy(Team.2, jumpscare_somb.getSlot())
    if ruleCondition:
        loop()


rule "no entry":
    no_entry = [vect(38.547, 4.251, -56.45), vect(34.113, 3.248, -30.205)]
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, no_entry[0] + random.choice(random_vector), 12, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, no_entry[0] + random.choice(random_vector), 12, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, no_entry[0] + random.choice(random_vector), 12, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, no_entry[true] + random.choice(random_vector), 8.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, no_entry[true] + random.choice(random_vector), 8.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, no_entry[true] + random.choice(random_vector), 8.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "no entry 1":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition (distance(eventPlayer, no_entry[0]) < 12 or distance(eventPlayer, no_entry[true]) < 8.5) == true
    @Condition eventPlayer.spawned_in == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.teleport(vect(false, -10000, false))
    eventPlayer.disableHeroHud()


rule "no entry random vectors":
    for i in range(false, random.randint(10, 30), true):
        random_vector = []
        for i2 in range(false, 10, true):
            random_vector.append(directionFromAngles(random.uniform(0, 360), random.uniform(0, 360)) * random.uniform(0, 1))
        wait(0.03)
    wait(random.uniform(1, 5))
    loop()


rule "player spawns + doors":
    player_spawns = [vect(-12.627, 2.498, 87.331), vect(-62.665, 0.2, -5.278), vect(-24.189, 6.2, -47.605), vect(-0.034, 4.248, -143.526), vect(-30.986, 6.455, -171.724)]
    player_spawn_doors = [vect(-16.115, 5.252, -146.942), vect(-52.531, 5.248, -147.203), vect(-6.347, 4.248, -127.978), vect(5.594, 5.248, -129.978), vect(-16.961, 7.249, -63.416), vect(-10, 3.229, -51.678), vect(-53.622, 1.248, -12.577), vect(-48.484, 3.249, -3.913), vect(-14.64, 3.254, 73.683), vect(-9.763, 3.254, 73.683), vect(8.654, 1.5, 72.26), vect(-32.995, 1.498, 72.505)]
    more_doors = [vect(-37.483, 5.251, -148.959), vect(-8.288, 4.001, -44.021), vect(11.904, 4.001, -41.979), vect(-42.081, 1.252, 20.864), vect(-23.654, 3.249, 16.741), vect(-20.015, 6.512, 34.853), vect(-30.978, 4.511, 36.853), vect(18.993, 1.502, 46.147), vect(13.007, 7.499, 34.853)]


rule "exit spawn":
    @Event eachPlayer
    @Team 1
    @Condition player_spawn_doors.any(lambda x: distance(eventPlayer, x) < 3) == true
    @Condition eventPlayer.spawned_in == false
    
    eventPlayer.teleport(sorted(player_spawn_doors, lambda x: distance(eventPlayer, x))[0] + Vector.DOWN)
    eventPlayer.spawned_in = true
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)


rule "fake spawn rooms":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.teleport(random.choice(sorted(player_spawns, lambda x: distance(x, actual_exit)).slice(true, 6) if actual_exit else player_spawns))
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setFacing(directionFromAngles(random.uniform(0, 360), 0), Relativity.TO_WORLD)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.enableHeroHud()


rule "death":
    @Event playerDied
    @Team 1
    
    eventPlayer.stopCamera()
    eventPlayer.spawned_in = false
    wait(true)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer))
    eventPlayer.enableMessages()


rule "too late":
    @Condition getMatchTime() <= 1
    
    getDeadPlayers(Team.1).respawn()
    pauseMatchTime()
    wait(0.1)
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHud()
    wait(0.4)
    getPlayers(Team.1).setStatusEffect(game_over_somb, Status.FROZEN, 9999)
    destroyAllHudTexts()
    wait()
    hudSubtext(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    toolate = true
    sound_fx = 200
    for i in range(false, 5, true):
        createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.WHITE, death_spot, sound_fx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.WHITE, death_spot, sound_fx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.PICKUP_SOUND, Color.WHITE, death_spot, sound_fx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    game_over_somb.setUltCharge(100)
    getAllPlayers().clearStatusEffect(Status.HACKED)
    game_over_somb.setStatusEffect(null, Status.ASLEEP, 0.001)
    getPlayers(Team.1).teleport(vect(false, 10000, false))
    getPlayers(Team.1).startCamera(death_spot, death_spot + (directionFromAngles(horizontalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-3, 3), verticalAngleOfDirection(directionTowards(death_spot, game_over_somb.getEyePosition())) + random.uniform(-3, 3))), 150)
    createInWorldText(getAllPlayers(), TOO_LATE, game_over_somb, 4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    wait(4)
    game_over_somb.forceButtonPress(Button.ULTIMATE)
    destroyAllInWorldTexts()
    getPlayers(Team.1).startCamera(death_spot, game_over_somb.getEyePosition(), 150)
    sound_fx = null
    wait(0.3)
    i = random.uniform(0, 100)
    if i < (chance_of_crashing_singleplayer if getNumberOfLivingPlayers(Team.1) == 2 else chance_of_crashing_multiplayer):
        while toolate < 9:
            kick()
            wait(false)
    else:
        wait(0.3)
        while toolate < 7:
            i++
            actual_orbs_effect.append(orb_spawns_4)


rule "orb spawns":
    actual_orbs_effect = []
    orb_spawns_1 = [vect(10.99, -0.1, 59.02), vect(-22.24, 1.05, 72.7), vect(-52.48, 0.95, 56.57), vect(-23.31, -0.1, 51.27), vect(-4.75, 1.05, 65.337), vect(-19.564, 1.05, 65.38), vect(-5.9, -0.096, 46.703), vect(1.222, -0.096, 42.892), vect(-9.771, 1.695, 39.583), vect(5.882, 0.052, 48.293), vect(-15.867, 0.796, 42.063), vect(-33.022, 1.94, 40.175), vect(-17.539, 5.063, 36.852), vect(-3.758, 1.652, 23.003), vect(8.439, 2.046, 32.152), vect(6.849, 0.42, 38.279), vect(9.482, 0.05, 46.527), vect(21.92, 1.38, 45.5), vect(18.867, 0.05, 38.499), vect(31.44, 3.05, 39.412), vect(16.342, 6.05, 35.363), vect(10.97, 6.05, 41.871), vect(27.444, 6.983, 54.631), vect(21.448, 1.8, 22.821), vect(16.074, 1.8, 11.196), vect(11.702, 4.087, 10.057), vect(8.976, 2.696, 13.205), vect(-8.581, 1.52, 36.092), vect(0.676, 2.378, 19.719), vect(16.196, 3.003, 26.985), vect(-3.706, 2.143, 12.737)]
    orb_spawns_2 = [vect(-15.379, 3.453, 23.148), vect(-11.987, 3.264, 16.476), vect(-27.059, 1.973, 28.298), vect(-22.833, 2.064, 14.157), vect(-2.982, 1.84, -2.931), vect(-11.814, 1.8, -8.388), vect(-4.455, 1.8, 10.203), vect(-20.455, 1.808, -6.691), vect(-13.067, 1.8, -10.65), vect(-17.088, 2.791, -17.167), vect(-14.029, 6.054, -9.47), vect(-26.721, 1.8, -17.451), vect(-31.809, 13.618, -11.137), vect(-33.238, 1.8, -17.028), vect(-40.572, 1.8, -16.258), vect(-38.964, 1.8, -3.02), vect(-50.868, -0.2, -19.019), vect(-46.956, 0.085, 0.104), vect(-46.657, -0.346, 10.006), vect(-56.392, 1.086, 11.733), vect(-37.719, 0.102, 8.047), vect(-32.739, -0.2, 9.269), vect(-27.872, 8.758, 9.126), vect(-2.035, 4.289, 7.474), vect(6.284, 2.395, 0.585), vect(-29.88, 1.65, -3.84)]
    orb_spawns_3 = [vect(19.334, 3.085, -10.976), vect(3.744, 1.8, -30.924), vect(11.149, 4.662, -30.268), vect(18.331, 1.8, -41.891), vect(22.613, 1.672, -41.575), vect(32.531, 3.021, -41.079), vect(12.594, 2.699, -53.29), vect(5.428, 1.788, -52.361), vect(0.909, 1.654, -51.109), vect(-9.624, 1.811, -30.57), vect(1.057, 1.923, -26.385), vect(7.324, 7.582, -28.877), vect(1.992, 7.237, -22.839), vect(13.784, 1.794, -46.854), vect(9.85, 1.654, -70.253), vect(13.826, 1.654, -77.308), vect(22.112, 2.727, -71.077), vect(31.34, 1.908, -80.328), vect(23.48, 2.513, -81.66), vect(37.312, 1.654, -84.734), vect(31.96, 1.667, -91.317), vect(27.434, 4.163, -96.206), vect(6.565, 1.799, -84.305), vect(-17.614, 1.779, -73.288), vect(-18.498, 2.039, -67.028), vect(-16.67, 1.779, -61.005), vect(8.888, 4.895, -65.096), vect(1.096, 2.05, -63.176), vect(0.588, 2.694, -67.118), vect(0.75, 9.259, -54.177), vect(5.99, 11.06, -60.899), vect(6.986, 10.8, -35.588)]
    orb_spawns_4 = [vect(7.948, 3.8, -98.842), vect(12.351, 3.857, -113.485), vect(6.717, 3.8, -116.085), vect(-10.821, 2.8, -118.897), vect(-9.734, 2.126, -112.134), vect(-22.725, 1.8, -111.734), vect(-19.03, -0.198, -93.232), vect(-13.605, 2.752, -93.367), vect(-23.01, -0.207, -90.988), vect(-27.473, -0.207, -85.807), vect(-33.379, 0.194, -89.192), vect(-46.061, 2.631, -89.425), vect(-47.277, 1.8, -91.724), vect(-36.685, -0.207, -102.87), vect(-38.16, 3.952, -112.6), vect(-52.035, 3.849, -121.339), vect(0.44, 5.287, -105.195), vect(-2.233, 2.512, -112.542), vect(-47.366, 10.063, -104.432), vect(-41.319, 9.8, -105.726), vect(-52.757, 9.829, -113.31), vect(-22.608, 10.864, -108.478), vect(-17.36, 9.8, -116.998), vect(-14.089, 11.582, -104.435), vect(-14.89, 9.8, -114.49), vect(-30.98, 0.416, -99.442), vect(-31.57, 1.8, -140.171), vect(-27.782, 1.8, -133.617), vect(-26.441, 5.334, -140.072), vect(-15.587, 1.8, -131.465), vect(-13.433, 2.133, -135.018), vect(-37.934, 4.168, -144.136), vect(-26.608, 4.17, -146.383), vect(-49.933, 10.162, -125.362)]
    actual_orbs = random.shuffle(orb_spawns_1).slice(false, 3).concat(random.shuffle(orb_spawns_2).slice(false, 3).concat(random.shuffle(orb_spawns_3).slice(false, 5).concat(random.shuffle(orb_spawns_4).slice(false, 3))))
    actual_orbs.append(random.shuffle(orb_spawns_1.concat(orb_spawns_2).concat(orb_spawns_3).concat(orb_spawns_4).exclude(actual_orbs)).slice(false, orb_quantity - 14))
    wait(5)
    for i2 in range(false, len(actual_orbs), true):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.PURPLE, actual_orbs[i2], 0.1, EffectReeval.VISIBILITY)
        actual_orbs_effect.append(getLastCreatedEntity())
    #hudSubtext([player for player in getAllPlayers() if player.within_reach_of_orb != false and not player.isHoldingButton(Button.INTERACT) and not player.hasStatusEffect(Status.HACKED) and not random_scary_text_index], " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nHold F
    hudSubtext(getAllPlayers().filter(lambda player: player.within_reach_of_orb != false and player.isHoldingButton(Button.INTERACT) and not player.hasStatus(Status.HACKED) and not random_scary_text_index), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPicking up...", HudPosition.TOP, 10, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    hudsaver = getLastCreatedText()
    hudSubtext(getAllPlayers().filter(lambda player: player.within_reach_of_orb != false and not player.isHoldingButton(Button.INTERACT) and not player.hasStatus(Status.HACKED) and not random_scary_text_index), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nHold {0} ({1}) to pick up.".format(inputBindingString(Button.INTERACT), l"Interact"), HudPosition.TOP, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudsaver2 = getLastCreatedText()


rule "brig instant dash":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(0.1)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "brig no shield w/o bash":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    wait(0.25)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.cancelPrimaryAction()
    wait(5)
    eventPlayer.setSecondaryFireEnabled(true)


rule "within orb":
    @Event eachPlayer
    @Team 1
    @Condition (actual_orbs.any(lambda x: distance(x, eventPlayer.getEyePosition()) <= 3.5 and isInLoS(x, eventPlayer.getEyePosition()) and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x)) < atan2Deg(0.3, distance(eventPlayer.getEyePosition(), x)))) == true
    
    eventPlayer.within_reach_of_orb = sorted(actual_orbs, lambda x: distance(eventPlayer.getEyePosition(), x))[0]
    wait(0.1)
    if ruleCondition:
        loop()
    eventPlayer.within_reach_of_orb = false


rule "bot restart":
    hudText(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and not random_scary_text_index), "  {0} IN THE SYSTEM - V{1}  ".format(GLITCH_2, VERSION), " ", " ", HudPosition.RIGHT, -1, Color.PURPLE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and not random_scary_text_index), null, "", "A horror gamemode by Therister#1251", HudPosition.RIGHT, -0.9, Color.PURPLE, Color.WHITE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and not random_scary_text_index), "My YouTube/Discord - bit.ly/therister", HudPosition.RIGHT, -0.8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED) and not random_scary_text_index), "{0} Support GH - bit.ly/grandeurhammers".format(abilityIconString(Hero.TORBJORN, Button.ABILITY_2)), HudPosition.RIGHT, -0.7, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)


rule "pick up orb":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.within_reach_of_orb != false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition exit_mode == false
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    createDummy(Hero.SOMBRA, Team.2, 3, vect(false, 10000, 10000), null)
    getLastCreatedEntity().killer = eventPlayer
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.within_reach_of_orb, 200)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.within_reach_of_orb, 1)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 1)
    destroyEffect(actual_orbs_effect[actual_orbs.index(eventPlayer.within_reach_of_orb)])
    del actual_orbs_effect[actual_orbs.index(eventPlayer.within_reach_of_orb)]
    actual_orbs.remove(eventPlayer.within_reach_of_orb)
    orbs_collected++
    wait(0.05)
    if orbs_collected < 10:
        setMatchTime(getMatchTime() + (max(false, 100 - 20 * getNumberOfPlayers(Team.1))))
        bigMessage(getAllPlayers(), "{0} has collected an orb! {1} {2} left.".format(eventPlayer, 10 - orbs_collected, "orbs" if orbs_collected < 9 else "orb"))
    else:
        bigMessage(getAllPlayers(), "{0} has collected the final orb!".format(eventPlayer))
        exit_mode = true
        (getPlayersOnHero(Hero.SOMBRA, Team.2) if eventPlayer.type == 2 else []).lifespan = null


rule "exit mode init":
    @Condition exit_mode == true
    
    (getPlayersOnHero(Hero.SOMBRA, Team.2).filter(lambda player: player.type == 2)).lifespan = null
    setMatchTime(180)
    destroyInWorldText(random_scary_text_id)
    destroyHudText(hudsaver)
    destroyHudText(hudsaver2)
    createInWorldText(getLivingPlayers(Team.ALL).filter(lambda player: random_scary_text_index != null and not player.isDummy() and not player.hasStatus(Status.HACKED)), [null, "WHERE ARE YOU GOING\u2028", "EVERYTHING CAN BE {0}ED\u2028".format(HACK), "\u2028¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!¡{0}ED!".format(HACK), "DON'T LEAVE\u2028", "STAY WITH US\u2028", "THERE IS NO EXIT\u2028", "HERE I AM\u2028", abilityIconString(Hero.SOMBRA, Button.ULTIMATE)][random_scary_text_index], random_scary_text_displace, 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    while actual_orbs_effect != []:
        destroyEffect(actual_orbs_effect[0])
        del actual_orbs_effect[0]
    actual_orbs = vect(-10000, 10000, false)
    wait(4)
    bigMessage(getAllPlayers(), "The exit is unlocked! Find the exit door!")
    actual_exit = random.choice(player_spawn_doors.concat(more_doors))
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, actual_exit, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def kick():
    @Name "kick subr"
    
    smallMessage(getAllPlayers(), [])
    crash_stopper++
    if crash_stopper < 20:
        kick()
    else:
        crash_stopper = null


rule "exit":
    @Condition (getPlayers(Team.1).filter(lambda player: not player.isDummy()).all(lambda x: distance(x, actual_exit) <= 2)) == true
    @Condition actual_exit != null
    @Condition (getPlayers(Team.1).filter(lambda player: not player.isDummy())) != []
    
    destroyAllEffects()
    destroyAllInWorldTexts()
    destroyAllHudTexts()
    destroyAllDummies()
    getAllPlayers().teleport(vect(-29.288, 6.287, -165.114))
    getAllPlayers().setFacing(vect(0.243, -0.122, 0.962), Relativity.TO_WORLD)
    exit_mode = 2
    wait(0.1)
    declareTeamVictory(Team.1)


rule "scawy fog exit":
    @Event eachPlayer
    @Team 1
    @Condition exit_mode == true
    @Condition eventPlayer.isDummy() == false
    
    while eventPlayer.scawy_fog != []:
        destroyEffect(eventPlayer.scawy_fog[0])
        del eventPlayer.scawy_fog[0]
    wait()
    createEffect(eventPlayer if eventPlayer.isAlive() else [], Effect.BAD_AURA, Color.RED, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * fog_distance * 0.2, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scawy_fog.append(getLastCreatedEntity())
    createEffect(eventPlayer if eventPlayer.isAlive() else [], Effect.BAD_AURA, Color.RED, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * fog_distance * -0.2, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scawy_fog.append(getLastCreatedEntity())


rule "scary text":
    @Condition exit_mode == true
    @Condition toolate == false
    
    wait(random.uniform(10, 25) * (100 / jumpscare_frequency), Wait.ABORT_WHEN_FALSE)
    random_scary_text_displace = dark_spot + vect(random.uniform(-1, 1), random.uniform(-1, 1), 5)
    random_scary_text_index = random.randint(true, 8)
    (getLivingPlayers(Team.ALL).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED))).startCamera(dark_spot, dark_spot + (directionFromAngles(horizontalAngleOfDirection(Vector.FORWARD) + camera_shake_1, verticalAngleOfDirection(Vector.FORWARD) + camera_shake_2)), 150)
    wait(random.uniform(0.25, 0.6))
    (getLivingPlayers(Team.ALL).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED))).stopCamera()
    wait(0.1)
    random_scary_text_index = null
    if ruleCondition:
        loop()


rule "phase 3 init":
    @Condition orbs_collected >= 7
    
    createInWorldText(getLivingPlayers(Team.ALL).filter(lambda player: random_scary_text_index != null and not player.isDummy() and not player.hasStatus(Status.HACKED)), [null, "YOU'RE JUST A {0} IN THE SYSTEM\u2028".format(GLITCH), "INITIATING THE {0}".format(HACK), "EVERYTHING CAN BE {0}ED\u2028".format(HACK), "LOOKING FOR ME?\u2028", "BEEN HERE ALL ALONG\u2028", "MISS ME?\u2028", "HERE I AM\u2028", abilityIconString(Hero.SOMBRA, Button.ULTIMATE)][random_scary_text_index], random_scary_text_displace, 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    random_scary_text_id = getLastCreatedText()


rule "scary text phase 3":
    @Condition exit_mode == false
    @Condition orbs_collected >= 7
    @Condition toolate == false
    
    wait(random.uniform(2500 / jumpscare_frequency, 2500 / jumpscare_frequency + 10), Wait.ABORT_WHEN_FALSE)
    random_scary_text_displace = dark_spot + vect(random.uniform(-1, 1), random.uniform(-1, 1), 5)
    #random_scary_text_displace = worldVector(vect(random.uniform(-1, 1), random.uniform(-1, 1), 5), getPlayersInSlot(5, Team.1), Transform.ROTATION_AND_TRANSLATION)
    random_scary_text_index = random.randint(true, 8)
    (getLivingPlayers(Team.ALL).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED))).startCamera(dark_spot, dark_spot + (directionFromAngles(horizontalAngleOfDirection(Vector.FORWARD) + camera_shake_1, verticalAngleOfDirection(Vector.FORWARD) + camera_shake_2)), 50)
    #([player for player in getLivingPlayers(Team.ALL) if not player.isDummy() and not player.hasStatusEffect(Status.HACKED)]).setCamera(getPlayersInSlot(5, Team.1).getPosition(), getPlayersInSlot(5, Team.1).getPosition() + (angleToDirection(getPlayersInSlot(5,
    wait(random.uniform(0.25, 0.6))
    (getLivingPlayers(Team.ALL).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED))).stopCamera()
    wait(0.1)
    random_scary_text_index = null
    if ruleCondition:
        loop()


rule "glitch char randomise":
    @Condition orbs_collected >= 7
    @Condition random_scary_text_index == 1
    @Condition exit_mode == false
    
    GLITCH = "{0}{1}{2}".format(random.choice(G_char), random.choice(L_char), "{0}{1}{2}".format(random.choice(I_char), random.choice(T_char), "{0}{1}\u2028".format(random.choice(C_char), random.choice(H_char))))
    wait()
    if ruleCondition:
        loop()


rule "player init":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    getAllPlayers().disableNameplatesFor(getAllPlayers())
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.disableScoreboard()
    getAllPlayers().startForcingOutlineFor(getAllPlayers(), false, Color.WHITE)
    if eventPlayer.getTeam() == Team.1 and eventPlayer.getSlot() != 5:
        createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.isAlive() and player != eventPlayer and distance(eventPlayer, player) < 0.2 * fog_distance), eventPlayer, eventPlayer, true, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    if not exit_mode:
        eventPlayer.setRespawnTime(40)


rule "glitchy objective":
    @Condition exit_mode == true
    
    wait(random.uniform(0.25, 5))
    glitchy_obj = true
    wait(random.uniform(0.1, 1))
    glitchy_obj = false
    loop()


rule "glitchy objective text":
    @Condition glitchy_obj == true
    
    OBJECTIVE = "{0}{1}{2}".format(random.choice(["O", "O", random.choice(unicode_chars)]), random.choice(["B", "B", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["J", "J", random.choice(unicode_chars)]), random.choice(["E", "E", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["C", "C", random.choice(unicode_chars)]), random.choice(["T", "T", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["I", "I", random.choice(unicode_chars)]), random.choice(["V", "V", random.choice(unicode_chars)]), random.choice(["E", "E", random.choice(unicode_chars)])))))
    FIND_THE_EXIT = "{0}{1}{2}".format(random.choice(["F", "F", random.choice(unicode_chars)]), random.choice(["I", "I", random.choice(unicode_chars)]), "{0}{1} {2}".format(random.choice(["N", "N", random.choice(unicode_chars)]), random.choice(["D", "D", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["T", "T", random.choice(unicode_chars)]), random.choice(["H", "H", random.choice(unicode_chars)]), "{0} {1}{2}".format(random.choice(["E", "E", random.choice(unicode_chars)]), random.choice(["E", "E", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["X", "X", random.choice(unicode_chars)]), random.choice(["I", "I", random.choice(unicode_chars)]), random.choice(["T", "T", random.choice(unicode_chars)]))))))
    wait()
    if ruleCondition:
        loop()


rule "bot despawn":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.begin_lifespan == true
    @Condition eventPlayer.lifespan <= 0
    
    if eventPlayer.getSlot() == null:
        bot_1_spawner = 0.1 if exit_mode else random.uniform(80, 100)
        chaseAtRate(bot_1_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))
    elif eventPlayer.getSlot() == 1:
        bot_2_spawner = 0.1 if exit_mode else random.uniform(80, 100)
        chaseAtRate(bot_2_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))
    destroyDummy(Team.2, eventPlayer.getSlot())


rule "bot too idle":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.target == null
    
    wait(40, Wait.ABORT_WHEN_FALSE)
    #spawn_fail = true
    if eventPlayer.getSlot() == null:
        bot_1_spawner = 0.1
        chaseAtRate(bot_1_spawner, -1, true)
    elif eventPlayer.getSlot() == 1:
        bot_2_spawner = 0.1
        chaseAtRate(bot_2_spawner, -1, true)
    destroyDummy(Team.2, eventPlayer.getSlot())


rule "not chased":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.being_chased_by.target != eventPlayer
    
    eventPlayer.being_chased_by = null


rule "phase 1 bot spawn":
    #@Condition orbs_collected >= 2
    @Condition getPlayersInSlot(false, Team.2).getHero() != Hero.SOMBRA
    @Condition bot_1_spawner < 0
    
    #if not spawn_fail and not exit_mode:
    #
    #
    #
    #wait(((random.uniform(80, 100) - orbs_collected * 6) / (getNumberOfPlayers(Team.1) - 1)) * (100 / spawn_frequency), Wait.ABORT_WHEN_FALSE)
    #
    #
    #
    #else:
    #
    #
    #
    #spawn_fail = false
    #
    #
    #
    #__end__()
    if exit_mode:
        subtype_spawner = random.choice([random.randint(false, true), random.randint(false, true), random.randint(false, true), 2])
    else:
        subtype_spawner = random.randint(false, 2)
    if subtype_spawner < 2:
        spawn_victim_1 = random.choice(getLivingPlayers(Team.1).exclude(spawn_victim_2).exclude(spawn_victim_3).filter(lambda x: not x.isDummy() and x.spawned_in and not x.hasStatus(Status.HACKED)))
        wait(10, Wait.ABORT_WHEN_FALSE)
        bot_1_spawner = 0.1
        chaseAtRate(bot_1_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))
    else:
        createDummy(Hero.SOMBRA, Team.2, false, actual_exit if exit_mode else nearestWalkablePosition(random.choice(actual_orbs) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(3, 10)), null)
        getLastCreatedEntity().type = 2


rule "phase 1 bot spawn subtype 0":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_1 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 0
    
    createDummy(Hero.SOMBRA, Team.2, false, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    getLastCreatedEntity().setInvisibility(Invis.ALL)
    getLastCreatedEntity().type = 2
    spawn_victim_1 = null
    wait(false)
    #playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.PURPLE, getPlayersInSlot(0, Team.2).getEyePosition(), 200)
    if exit_mode:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, getPlayersInSlot(true, Team.2).getEyePosition(), 5)
    else:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, getPlayersInSlot(true, Team.2).getEyePosition(), 5)


rule "phase 1 bot spawn subtype 1":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_1 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 1
    
    createDummy(Hero.SOMBRA, Team.2, false, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    spawn_victim_1 = null
    getLastCreatedEntity().type = 2


rule "phase 2 bot spawn":
    #@Condition orbs_collected >= 6
    @Condition getPlayersInSlot(true, Team.2).getHero() != Hero.SOMBRA
    #@Condition getNumberOfPlayers(Team.1) > 3
    @Condition bot_2_spawner < 0
    
    #if not spawn_fail and not exit_mode:
    #
    #
    #
    #wait(((random.uniform(80, 100) - orbs_collected * 6) / (getNumberOfPlayers(Team.1) - 1)) * (100 / spawn_frequency), Wait.ABORT_WHEN_FALSE)
    #
    #
    #
    #else:
    #
    #
    #
    #spawn_fail = false
    #
    #
    #
    #__end__()
    if exit_mode:
        subtype_spawner = random.choice([random.randint(false, true), random.randint(false, true), random.randint(false, true), 2])
    else:
        subtype_spawner = random.randint(false, 2)
    if subtype_spawner < 2:
        spawn_victim_2 = random.choice(getLivingPlayers(Team.1).exclude(spawn_victim_1).exclude(spawn_victim_3).filter(lambda x: not x.isDummy() and x.spawned_in and not x.hasStatus(Status.HACKED)))
        wait(10, Wait.ABORT_WHEN_FALSE)
        bot_2_spawner = 0.1
        chaseAtRate(bot_2_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))
    else:
        createDummy(Hero.SOMBRA, Team.2, true, actual_exit if exit_mode else nearestWalkablePosition(random.choice(actual_orbs) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(3, 10)), null)
        getLastCreatedEntity().type = 2


rule "phase 2 bot spawn subtype 0":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_2 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 0
    
    createDummy(Hero.SOMBRA, Team.2, true, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    getLastCreatedEntity().setInvisibility(Invis.ALL)
    getLastCreatedEntity().type = 2
    spawn_victim_2 = null
    wait()
    #playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.PURPLE, getPlayersInSlot(1, Team.2).getEyePosition(), 200)
    if exit_mode:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, getPlayersInSlot(true, Team.2).getEyePosition(), 5)
    else:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, getPlayersInSlot(true, Team.2).getEyePosition(), 5)


rule "phase 2 bot spawn subtype 1":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_2 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 1
    
    createDummy(Hero.SOMBRA, Team.2, true, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    getLastCreatedEntity().type = 2
    spawn_victim_2 = null


rule "phase 3 bot spawn":
    @Condition getPlayersInSlot(2, Team.2).getHero() != Hero.SOMBRA
    @Condition exit_mode == true
    
    if exit_mode:
        subtype_spawner = random.choice([random.randint(false, true), random.randint(false, true), random.randint(false, true), 2])
    else:
        subtype_spawner = random.randint(false, 2)
    if subtype_spawner < 2:
        spawn_victim_3 = random.choice(getLivingPlayers(Team.1).filter(lambda player: not player.isDummy() and player.spawned_in and not player.hasStatus(Status.HACKED)))
        wait(10, Wait.ABORT_WHEN_FALSE)
        loop()
    else:
        createDummy(Hero.SOMBRA, Team.2, 2, actual_exit if exit_mode else nearestWalkablePosition(random.choice(actual_orbs) + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(3, 10)), null)
        getLastCreatedEntity().type = 2


rule "":
    @Event eachPlayer
    @Condition lol == 0
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.hasSpawned() == true
    
    wait(false)
    kick()
    if ruleCondition:
        loop()


rule "phase 3 bot spawn subtype 0":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_3 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 0
    
    createDummy(Hero.SOMBRA, Team.2, 2, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    getLastCreatedEntity().setInvisibility(Invis.ALL)
    getLastCreatedEntity().type = 2
    spawn_victim_3 = null
    wait()
    #playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.PURPLE, getPlayersInSlot(2, Team.2).getEyePosition(), 200)
    if exit_mode:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, getPlayersInSlot(true, Team.2).getEyePosition(), 5)
    else:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, getPlayersInSlot(true, Team.2).getEyePosition(), 5)


rule "phase 3 bot spawn subtype 1":
    @Event eachPlayer
    @Team 1
    @Condition spawn_victim_3 == eventPlayer
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 17, eventPlayer, Transform.ROTATION), null, eventPlayer, true)) > 16
    @Condition subtype_spawner == 1
    
    createDummy(Hero.SOMBRA, Team.2, 2, raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD * 16, eventPlayer, Transform.ROTATION), null, eventPlayer, true), null)
    getLastCreatedEntity().type = 2
    spawn_victim_3 = null


rule "hack char randomise":
    @Condition orbs_collected >= 7
    @Condition (random_scary_text_index == 2 or random_scary_text_index == 3) == true
    
    HACK = "{0}{1}{2}".format(random.choice(H_char), random.choice(A_char), "{0}{1}".format(random.choice(C_char), random.choice(K_char)))
    wait()
    if ruleCondition:
        loop()


rule "too late char randomise":
    @Condition getMatchTime() < 2
    
    TOO_LATE = "{0}{1}{2}".format(random.choice(T_char), random.choice(O_char), "{0} {1}{2}".format(random.choice(O_char), random.choice(L_char), "{0}{1}{2}".format(random.choice(A_char), random.choice(T_char), random.choice(E_char))))
    wait()
    if ruleCondition:
        loop()


rule "game \"start\"":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition first_player_spawn == false
    @Condition eventPlayer.isDummy() == false
    
    first_player_spawn = true
    setMatchTime(900)
    setObjectiveDescription(getAllPlayers(), "{0}".format(HURRY_UP if exit_mode else "Don't let the time run out."), HudReeval.VISIBILITY_AND_STRING)


rule "no ult charge":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.getUltCharge() > 1
    @Condition eventPlayer.getUltCharge() < 90
    
    eventPlayer.setUltCharge(false)


rule "glitch 2 char randomise":
    for i in range(false, random.randint(20, 60), true):
        VERSION = "{0}.{1}.{2}".format(random.randint(false, 9), random.randint(false, 9), random.randint(false, 9))
        GLITCH_2 = "{0}{1}{2}".format(random.choice(["G", "G", random.choice(unicode_chars)]), random.choice(["L", "L", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["I", "I", random.choice(unicode_chars)]), random.choice(["T", "T", random.choice(unicode_chars)]), "{0}{1}\u2028".format(random.choice(["C", "C", random.choice(unicode_chars)]), random.choice(["H", "H", random.choice(unicode_chars)]))))
        #GLITCH_2 = "{0}{1}{2}".format(random.choice(G_char), random.choice(L_char), "{0}{1}{2}".format(random.choice(I_char), random.choice(T_char), "{0}{1}".format(random.choice(C_char), random.choice(H_char))))
        wait()
    GLITCH_2 = "GLITCH"
    VERSION = "1.6.7"
    wait(random.uniform(5, 20))
    if ruleCondition:
        loop()


rule "hurry up char randomise":
    @Condition exit_mode == true
    
    HURRY_UP = "{0}{1}{2}".format(random.choice(["H", "H", "H", "H", random.choice(unicode_chars)]), random.choice(["U", "U", "U", "U", random.choice(unicode_chars)]), "{0}{1}{2}".format(random.choice(["R", "R", "R", "R", random.choice(unicode_chars)]), random.choice(["R", "R", "R", "R", random.choice(unicode_chars)]), "{0} {1}{2}\u2028".format(random.choice(["Y", "Y", "Y", "Y", random.choice(unicode_chars)]), random.choice(["U", "U", "U", "U", random.choice(unicode_chars)]), random.choice(["P", "P", "P", "P", random.choice(unicode_chars)]))))
    wait(0.03)
    if ruleCondition:
        loop()


rule "player init exit mode":
    @Event eachPlayer
    @Condition exit_mode == true
    
    eventPlayer.setRespawnTime(10)


rule "everyone is dead":
    @Condition getNumberOfLivingPlayers(Team.1) == 1
    @Condition len(getPlayers(Team.1).filter(lambda player: player.hasSpawned())) > 2
    @Condition wwwww == false
    
    setMatchTime(6)
    bigMessage(getAllPlayers(), "\u2028Everyone is dead.")
    getPlayers(Team.1).disableRespawn()
    getPlayers(Team.1).setInvisibility(Invis.ALL)


rule "":
    @Condition exit_mode == false
    @Condition toolate == false
    
    tooltips = random.randint(false, 3)
    wait(random.uniform(60, 90), Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED)), ["TIP: The orbs are very, very small.", "TIP: Some orbs are hidden inside destructibles.", "TIP: Some orbs may be hidden in high spots.", "TIP: Check every corner and crevice you can think of."][tooltips])
    wait(4, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: not player.isDummy() and not player.hasStatus(Status.HACKED)), ["Be sure to check little corners and small spaces.", "Try breaking some pumpkins, barrels or other objects.", "Don't just keep scanning the ground.", "Some hiding spots are very, very tricky."][tooltips])
    wait(0.25)
    if ruleCondition:
        loop()


rule "delete somb on death":
    @Event playerDied
    @Team 2
    @Hero sombra
    
    #spawn_fail = true
    if eventPlayer.getSlot() == null:
        bot_1_spawner = 0.1
        chaseAtRate(bot_1_spawner, -1, true)
    elif eventPlayer.getSlot() == 1:
        bot_2_spawner = 0.1
        chaseAtRate(bot_2_spawner, -1, true)
    destroyDummy(Team.2, eventPlayer.getSlot())


rule "echo short flight":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(0.7, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "stuck reset status":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED)) == true
    
    eventPlayer.stuck_timer = null


rule "orb elim":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.killer != null
    
    kill(eventPlayer, eventPlayer.killer)


rule "no ult charge widow":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.getUltCharge() > 1
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.setUltCharge(false)
    wait(0.25)
    if ruleCondition:
        loop()


rule "sombra random trans":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.random_trans >= 3
    @Condition (isInLoS(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition()) and distance(eventPlayer, eventPlayer.target) <= 8) == false
    @Condition eventPlayer.magnitude == 1
    
    eventPlayer.random_trans = random.uniform(-8, -4) + min(4, orbs_collected * 0.5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, false)
    eventPlayer.magnitude = null
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest + Vector.UP * eventPlayer.getVerticalFacingAngle() * -0.1 + Vector.UP * distance(eventPlayer.getEyePosition(), eventPlayer.dest) * 0.1), 9000)
    wait(0.1)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.1)
    wait(max(0.5, distance(eventPlayer, eventPlayer.dest) / 23))
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.magnitude = 1
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.dest), 9000)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.INTERACT)


rule "bot init":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.disableHeroHud()


rule "randomise voice":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    
    eventPlayer.voice = true + random.uniform(-0.05, 0.02) * orbs_collected
    wait(random.uniform(0.25 - 0.026 * orbs_collected, 0.25))
    loop()


rule "cam shake":
    @Condition random_scary_text_index != 0
    
    camera_shake_1 = random.uniform(-2, 2)
    camera_shake_2 = random.uniform(-2, 2)
    wait(0.033)
    if ruleCondition:
        loop()


rule "Rule 92":
    @Event eachPlayer
    @Condition wwwww == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    
    BX = abilityIconString(Hero.SOMBRA, Button.ULTIMATE)
    eventPlayer.startForcingPosition(vect(random.uniform(-1000, 1000), 1000, random.uniform(-1000, 1000)), false)
    eventPlayer.startForcingHero(Hero.REAPER)
    createInWorldText(getAllPlayers(), BX, dark_spot + Vector.FORWARD, 4, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)
    eventPlayer.disableHeroHud()
    eventPlayer.disableMessages()
    eventPlayer.disableGamemodeHud()
    hudSubtext(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.startCamera(dark_spot, dark_spot + Vector.FORWARD)
    wait(30)
    BX = "PLEASE DON'T GO\u2028"
    while toolate != Hero.SOMBRA:
        kick()
        wait(false)


rule "no hud":
    @Event eachPlayer
    @Team 1
    @Condition random_scary_text_index != 0
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.disableMessages()
    eventPlayer.disableHeroHud()
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.hasStatus(Status.HACKED) or toolate:
        return
    eventPlayer.enableHeroHud()
    eventPlayer.enableMessages()


rule "Rule 93":
    @Event eachPlayer
    @Condition wwwww == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.startForcingHero(Hero.SOMBRA)


rule "":
    @Event eachPlayer
    @Hero reaper
    @Condition wwwww == true
    
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 0.001)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.setFacing(Vector.UP, Relativity.TO_WORLD)
    eventPlayer.disableHeroHud()
    eventPlayer.disableMessages()
    eventPlayer.disableGamemodeHud()
    eventPlayer.startModifyingVoicelinePitch(random.uniform(0.5, 1))
    eventPlayer.communicate(Comms.SORRY)
    wait()
    loop()


rule "":
    @Condition wwwww == true
    @Condition getPlayers(Team.1).any(lambda player: player.hasSpawned()) == true
    
    for i in range(false, 6, true):
        createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.WHITE, dark_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.WHITE, dark_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.WHITE, dark_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.WHITE, dark_spot, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createDummy(Hero.SOMBRA, Team.1, 4, nearestWalkablePosition(vect(false, false, false)), null)
    createDummy(Hero.SOMBRA, Team.1, 5, nearestWalkablePosition(vect(false, false, false)), null)


rule "Rule 96":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isDummy() == true
    
    if random.randint(true, 3) == 3:
        eventPlayer.teleport(vect(false, -10000, false))
    eventPlayer.startModifyingVoicelinePitch(random.uniform(0.5, 1))
    wait()
    eventPlayer.respawn()
    eventPlayer.startModifyingVoicelinePitch(random.uniform(0.5, 1.5))
    wait()
    if random.randint(false, true) == null:
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, dark_spot, 200)
    else:
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, dark_spot, 200)
    eventPlayer.communicate(Comms.NEED_HELP)
    loop()


rule "Rule 98":
    wwwww = createWorkshopSettingBool("\u200b", "\u200cδdѤ(？-ӞàÆ☳ټ\udbef\udd94??벞\udac5\udf76ԧ읃թ!!M�;꾚⎫Ә??\udb2d\udffcየh#Ý!öůɀ±×£¶Ƀ!!Ã?iÌG%řØèŉ\ud83d\ude2aǢ☄☸ǎ!‽‽", false, 1)


rule "exit safety":
    @Event eachPlayer
    @Team 1
    @Condition distance(eventPlayer, actual_exit) <= 2
    @Condition exit_mode == true
    
    eventPlayer.exit_safe = true
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    while distance(eventPlayer, actual_exit) <= 2:
        wait()
    eventPlayer.exit_safe = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)


rule "somb random walk throttle":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.target == null
    
    eventPlayer.magnitude = null
    wait(random.uniform(1, 3), Wait.ABORT_WHEN_FALSE)
    if random.randint(true, 2) == 1:
        eventPlayer.random_dir = directionFromAngles(random.uniform(0, 360), 0)
    eventPlayer.magnitude = 0.6
    wait(random.uniform(1, 6), Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


rule "somb random walk turn around":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    @Condition eventPlayer.target == null
    @Condition distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3, null, eventPlayer, true)) < 2
    
    wait(0.5)
    if not ruleCondition:
        return
    eventPlayer.random_dir = directionFromAngles(horizontalAngleOfDirection(raycastHitNormal(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3, null, eventPlayer, true)) + random.uniform(-90, 90), 0)
    if ruleCondition:
        loop()


rule "somb random murmurs":
    @Event eachPlayer
    @Team 2
    @Hero sombra
    @Condition eventPlayer.type == 2
    
    wait(random.uniform(4, 7))
    eventPlayer.random = random.randint(false, 6)
    if eventPlayer.random == null:
        eventPlayer.communicate(Comms.HELLO)
    elif eventPlayer.random == 1:
        eventPlayer.communicate(Comms.GOODBYE)
    elif eventPlayer.random == 2:
        eventPlayer.communicate(Comms.SORRY)
    elif eventPlayer.random == 3:
        eventPlayer.communicate(Comms.THANKS)
    elif eventPlayer.random == 4:
        eventPlayer.communicate(Comms.YOURE_WELCOME)
    elif eventPlayer.random == 5:
        eventPlayer.communicate(Comms.YES)
    elif eventPlayer.random == 6:
        eventPlayer.communicate(Comms.NO)
    loop()


rule "somb random walk stuck":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getSpeedInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.dest)), 0)) < 3
    @Condition eventPlayer.magnitude == 0.6
    @Condition eventPlayer.type == 2
    
    wait(true, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.getAltitude() < true:
        eventPlayer.applyImpulse(Vector.UP, 8, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if ruleCondition:
        loop()


rule "hack persist":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    
    eventPlayer.setStatusEffect(null, Status.HACKED, 5)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true)
    wait(0.1)
    heal(eventPlayer, null, 0.001)
    wait(false)
    damage(eventPlayer, null, eventPlayer.getHealthOfType(Health.SHIELDS))
    wait(true)
    eventPlayer.removeAllHealthPools()


rule "soldier run slower":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setMoveSpeed(90)
    while eventPlayer.isUsingAbility1():
        wait(0.1)
    eventPlayer.setMoveSpeed(100)


rule "Rule 107":
    @Condition orbs_collected >= 2
    
    bot_1_spawner = random.uniform(80, 100)
    chaseAtRate(bot_1_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))


rule "Rule 108":
    @Condition orbs_collected >= 6
    @Condition getNumberOfPlayers(Team.1) > 3
    
    bot_2_spawner = random.uniform(80, 100)
    chaseAtRate(bot_2_spawner, -1, ((orbs_collected * 0.429 + 0.143) * (getNumberOfPlayers(Team.1) - true)) * (spawn_frequency / 100))


rule "Rule 113":
    @Event eachPlayer
    @Condition eventPlayer.being_chased_by != null
    
    while not (eventPlayer.isInViewAngle(eventPlayer.being_chased_by.getEyePosition(), 45) and isInLoS(eventPlayer.getEyePosition(), eventPlayer.being_chased_by.getEyePosition())):
        wait(false)
    if distance(eventPlayer, eventPlayer.being_chased_by) > 0.2 * fog_distance:
        return
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true)
    wait(0.1)
    heal(eventPlayer, null, 0.001)
    wait(false)
    damage(eventPlayer, null, eventPlayer.getHealthOfType(Health.SHIELDS))
    wait(true)
    eventPlayer.removeAllHealthPools()


rule "Rule 99":
    @Event eachPlayer
    @Condition getMatchTime() <= 1
    
    eventPlayer.disableHeroHud()
    wait(0.1)
    if ruleCondition:
        loop()


