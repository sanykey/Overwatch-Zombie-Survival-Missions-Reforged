#!mainFile "main.opy"

subroutine determineChallenge
subroutine determineZombieMode
subroutine setZombieMode
subroutine determineObjectiveType
subroutine setObjectiveType


rule "============================================== GLOBAL START MENU ====================================================":
    @Disabled
    @Delimiter


rule "GLOBAL MENU INITIALIZATION":
    @Condition specialGameModeSetup == true
    @Condition len(mapGrid) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startCamDistance = 6.5
    if specialGameMode:
        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + vect(0, 15, 0)
        elif getCurrentGamemode() == Gamemode.CONTROL:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + vect(0, 100, 0)
        else:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 150 + vect(0, 30, 0)
        startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(horizontalAngleOfDirection(directionTowards(walkCenter, startPos)), 0) * startCamDistance
        wait()
        createDummy(Hero.REAPER, Team.2, -1, nearestWalkablePosition(startPos), Vector.FORWARD)
        wait()
        getPlayers(Team.2).setInvisibility(Invis.ALL)
        getPlayers(Team.2)[0].startForcingPosition(startPos + vect(0, 15, 0))
        getPlayers(Team.2).startFacing(Vector.FORWARD, 100000)
    else:
        while startPos == null:
            startPos = getObjectivePosition(random.randint(0, 2 if getCurrentGamemode() != Gamemode.ASSAULT else 1))
            if getCurrentGamemode() == Gamemode.CLASH:
                startPos = getSpawnPoints(Team.1)
                if __getCurrentMap__() == Map.THRONE_OF_ANUBIS:
                    startPos = vect(-0.27, 0.49, 83.6)
                    startCamPos = vect(-0.19, 2, 90.1)
                    goto lbl_0
            startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(random.uniform(0, 360), 0) * startCamDistance
            startCamPos = raycastHitPosition(startCamPos, startCamPos - vect(0, 5, 0), null, null, false) + vect(0, 1.5, 0)
            startPos = vect(startPos.x, startCamPos.y - 1.5, startPos.z)
            startPos = raycastHitPosition(startPos + vect(0, 0.4, 0), startPos - vect(0, 5, 0), null, null, false)
            startPos = raycastHitPosition(startCamPos - vect(0, 0.75, 0), startPos + vect(0, 0.75, 0), null, null, false) - vect(0, 0.75, 0)
            startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(horizontalAngleOfDirection(directionTowards(startPos, startCamPos)), 0) * startCamDistance
            #Line of Sight Checks for each player position
            for count1 in range(-26, 27, 2):
                if not isInLoS(startCamPos, startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + count1, 0)) * startCamDistance)) or not isInLoS(startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + count1, 0)) * startCamDistance), startCamPos):
                    startPos = null
                    break
            wait()
    lbl_0:
    startMenuSpacingAngle = 40
    #Start screen objective description
    setObjectiveDescription(getAllPlayers(), "Voting ends in {0}s".format(ceil(getMatchTime() - votingEndTime)) if voting else "Select your hero", HudReeval.VISIBILITY_AND_STRING)


rule "EFFECTS/TEXTS":
    #Pre game objective description and match timer
    hudSubtext(getAllPlayers(), "{0} | {1}s".format("Voting will end in {0}s".format(ceil(getMatchTime() - votingEndTime)) if voting else "Select your hero", ceil(getMatchTime())), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "Original Game Code: MPJFR" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Game Mode Creator: Mazattack#1183", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "This is a modified version: 786TW" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Modified by: KamenRider#11346", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Workshop.codes
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] < 2), "For information on changes: workshop.codes/786TW", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Voting options reminder
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 2), "Voting options are available in the top left corner of your screen" if voting else "Voting is complete. Difficulty is actively scaled by amount of players.", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA if voting else Color.PURPLE, SpecVisibility.NEVER)
    #Ready In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 1), "Ready [{0}]".format(inputBindingString(Button.JUMP)), localPlayer.startPos + vect(0, 1.92, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.NEVER)
    #Change Hero In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 1 and getMatchTime() > 2.5), "Change Hero [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, 1.8, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Cancel In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.playerMenuStatus[0] == 2 and getMatchTime() > 2.5), "Cancel [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, -0.6, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 49, 49), SpecVisibility.NEVER)
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 0), "Challenge: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)), HudPosition.LEFT, 0, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: None
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 1), "Challenge: None", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.YELLOW, null, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: Swarm Shootout
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 2), "Challenge: Swarm Shootout", "Zombies fire their guns!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote challenge text: Random Abilities
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 3), "Challenge: Random Abilities", "Non-boss zombies use abilities", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote Challenge text: Insanity
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 4), specialEffectsStrings if specialEffectsTiming else "Challenge: Insanity", "Faster, stronger, and deadlier", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.WHITE if specialEffectsTiming else Color.TURQUOISE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    #Vote Challenge text: Pandora's Box
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[2] == 5), specialEffectsStrings if specialEffectsTiming else "Challenge: Pandora's Box", "All challenges at Once!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting else [], HudPosition.LEFT, 0, Color.GRAY if specialEffectsTiming else Color.PURPLE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    #Vote zombie mode text: No preference
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 0), "Zombie Mode: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)), HudPosition.LEFT, 1, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: All Zombies
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 1), "Zombie Mode: All Zombies", "Normal game featuring all zombie types", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: New Blood
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 2), "Zombie Mode: New Blood", "The 13 most recent zombie types will spawn", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: What'll it be?
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 3), "Zombie Mode: What'll it be?", "All zombie types have equal spawn rates", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Zombie Shuffle!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 4), "Zombie Mode: Zombie Shuffle", "The zombie spawn rates twist and turn with wild abandon!", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Dinner Rush!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 5), "Zombie Mode: Dinner Rush!", "Only zombies with mobility abilities will spawn", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Vote zombie mode text: Ham N' Hammer!
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[3] == 6), "Zombie Mode: Ham N' Hammer!", "Only Reinhardt {0} and Wrecking Ball {1} zombies will spawn".format(heroIcon(Hero.REINHARDT), heroIcon(Hero.WRECKING_BALL)), "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting else [], HudPosition.LEFT, 1, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: No preference
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 0), "Objective Type: No Preference", null, "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)), HudPosition.LEFT, 2, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Showdown Only
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 1), "Objective Type: Showdown {0}".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)), "Players must contest a point against zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Boss Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 2), "Objective Type: Bosses {0}".format(iconString(Icon.WARNING)), "Spawns giant versions of zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Kill Zone Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 5), "Objective Type: Kill Zone {0}".format(iconString(Icon.RING_THICK) if ceil(getTotalTimeElapsed() * 1.25) % 2 == 0 else iconString(Icon.RING_THIN)), "Clear zombies from a designated area", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Zombie Egg Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 6), "Objective Type: Zombie Egg {0}".format(iconString(Icon.RADIOACTIVE)), "Survivors must destroy an object that is spawning zombies", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Satellite Uplink Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == 7), "Objective Type: Satellite Uplink {0}".format(iconString(Icon.MOON)), "Survivors must repair terminals to communicate with a satellite", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, rgb(12, 129, 132), rgb(12, 129, 132), rgb(12, 129, 132), HudReeval.VISIBILITY_AND_STRING)
    #Vote objective type text: Mixed Objectives
    hudText(getAllPlayers().filter(lambda player: player.playerMenuStatus[4] == len(objectiveTypeVotes) - 1), "Objective Type: Mixed Objectives {0}".format(iconString(Icon.SPIRAL)), "Randomly assigns all types of objectives", "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting else [], HudPosition.LEFT, 2, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: No Preference
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 0), "Enhancement: No Preference", null, "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.AQUA, Color.AQUA, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Kevlar
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 1), "Enhancement: Kevlar {0}".format(iconString(Icon.STOP)), "Survivor is equipped with armor that protects against infections", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, rgb(240, 129, 26), rgb(240, 129, 26), rgb(240, 129, 26), HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Zombie Hyrbid
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 2), "Enhancement: Zombie Hybrid {0}".format(iconString(Icon.POISON)), "Get infected faster, and convert it to explosive damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Laser Barricade
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 3), "Enhancement: Laser Barricade {0}".format(iconString(Icon.DIAMOND)), "Player can place a wall that blocks zombies", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Brain Killer
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 4), "Enhancement: Brain Killer {0}".format(iconString(Icon.SKULL)), "Critical hits do more damage", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Pyrotechnic
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 5), "Enhancement: Pyrotechnic {0}".format(iconString(Icon.FIRE)), "Dealing damage, within 15 meters, sets enemies on fire", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Plague Doctor
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 6), "Enhancement: Plague Doctor {0}".format(iconString(Icon.PLUS)), "Deal more healing to infected players while reducing their infection level", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Born to Battle
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 7), "Enhancement: Born to Battle {0}".format(iconString(Icon.BOLT)), "Dealing a final blow will give the player a cooldown reset on the next ability they use", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Charge Battery
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 8), "Enhancement: Charge Battery {0}".format(iconString(Icon.SPIRAL)), "Survivor can place a battery that gives ultimate charge", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, rgb(236, 206, 44), rgb(236, 206, 44), rgb(236, 206, 44), HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: Hitchhiker
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 9), "Enhancement: Hitchhiker {0}".format(iconString(Icon.FLAG)), "Survivor can attach to a teammate and fuse their health.", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Enhancement Selection: P.U.P.
    hudText(getAllPlayers().filter(lambda player: player.enhancementValues[0] == 10), "Enhancement: P.U.P. {0}".format(iconString(Icon.HAPPY)), "Survivor is equipped with an autonomous friendly droid", "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)), HudPosition.LEFT, 3, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)


rule "SPECIAL EFFECT CONTROLS":
    @Condition specialGameModeSetup == true
    
    if specialGameModeSetup:
        randVal = random.randint(1, 3)
        if randVal == 1:
            specialEffectsStrings = "alglChene oteV: KaMeNrldEr"
        elif randVal == 2:
            specialEffectsStrings = "You won't win"
        elif randVal == 3:
            specialEffectsStrings = "Don't even try it"
    specialEffectsTiming = true
    wait(random.uniform(0.063, 0.325), Wait.ABORT_WHEN_FALSE)
    specialEffectsTiming = false
    wait(random.uniform(0.325, 1.5), Wait.ABORT_WHEN_FALSE)
    loop()


rule "END VOTING":
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition getMatchTime() < votingEndTime
    @Condition len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[0] > 0)) > 0
    
    chase1 = votingEndTime
    startRule(determineZombieMode)
    #Waits until votes have been counted
    waitUntil(not voting, 99999)
    getPlayers(Team.1).playerMenuStatus[2] = challengeSetting
    getPlayers(Team.1).playerMenuStatus[3] = zombieSetting
    getPlayers(Team.1).playerMenuStatus[4] = objectiveTypeSetting
    bigMessage(getAllPlayers(), "Voting has ended!")
    startRule(setPrematchTimer)


rule "MUSIC/ANNOUNCER CONTROL":
    @Condition voting != true
    @Condition specialGameModeSetup == true
    
    if getMatchTime() < 20:
        enableMusic()
        enableAnnouncer()
        waitUntil(getMatchTime() > 20 or not specialGameModeSetup, 60)
    else:
        disableMusic()
        disableAnnouncer()
        waitUntil(getMatchTime() < 20 or not specialGameModeSetup, 60)
    if ruleCondition:
        loop()


def determineZombieMode():
    @Name "determineZombieMode"
    
    zombieSetting = 0
    for count1 in range(1, len(zombieVotes)):
        if zombieVotes[count1][1]:
            zombieVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[3] == count1))
        else:
            zombieVotes[count1] = -1
    for count1 in range(1, len(zombieVotes)):
        if zombieVotes[zombieSetting] < zombieVotes[count1]:
            zombieSetting = count1
        elif zombieVotes[zombieSetting] == zombieVotes[count1]:
            #Randomly pick mode to break tie
            if zombieSetting != 0 and random.randint(0, 1) == 0:
                zombieSetting = count1
    #If all players choose no preference, randomize
    if zombieSetting == 0:
        zombieSetting = 1
    startRule(determineChallenge)
    startRule(setZombieMode)


def setZombieMode():
    @Name "setZombieMode"
    
    #Bot available hero list
    botHeros = [Hero.REAPER, Hero.JUNKRAT, Hero.TORBJORN, Hero.ROADHOG, Hero.REINHARDT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.MAUGA, Hero.MERCY, Hero.WRECKING_BALL, Hero.MOIRA, Hero.PHARAH, Hero.SIGMA, Hero.JUNKER_QUEEN, Hero.ILLARI, Hero.HAZARD, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO]
    #Zombie types without a boss variation
    nonBossZombies = [Hero.JUNKRAT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.JUNKER_QUEEN, Hero.SYMMETRA, Hero.ANA, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.SIGMA, Hero.WRECKING_BALL]
    #All Zombies
    if zombieSetting == 1:
        #Bot respawn probablities
        botSpawnRates = numbersList.slice(NL_SPAWN_RATES_ALL_ZOMBIES_OFFSET, NL_SPAWN_RATES_ALL_ZOMBIES_LEN)
    #New Blood
    elif zombieSetting == 2:
        #Bot respawn probablities
        botSpawnRates = numbersList.slice(NL_SPAWN_RATES_NEW_BLOOD_OFFSET, NL_SPAWN_RATES_NEW_BLOOD_LEN)
    #What'll it be?
    elif zombieSetting == 3:
        #Bot respawn probablities
        botSpawnRates = []
        for I in range(19):
            botSpawnRates.append(5.263)
    #Zombie Shuffle
    elif zombieSetting == 4:
        #Bot respawn probablities
        botSpawnRates = numbersList.slice(NL_SPAWN_RATES_SHUFFLE_OFFSET, NL_SPAWN_RATES_SHUFFLE_LEN)
    #Dinner Rush!
    elif zombieSetting == 5:
        #Bot respawn probablities
        botSpawnRates = numbersList.slice(NL_SPAWN_RATES_DINNER_RUSH_OFFSET, NL_SPAWN_RATES_DINNER_RUSH_LEN)
    #Ham N' Hammer
    elif zombieSetting == 6:
        #Bot respawn probablities
        botSpawnRates = numbersList.slice(NL_SPAWN_RATES_HAM_N_HAMMER_OFFSET, NL_SPAWN_RATES_HAM_N_HAMMER_LEN)


def determineChallenge():
    @Name "determineChallenge"
    
    challengeSetting = 0
    for count1 in range(1, len(challengeVotes)):
        if challengeVotes[count1][1]:
            challengeVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[2] == count1))
        else:
            challengeVotes[count1] = -1
    averageChalllenge = 0
    for count1 in range(1, len(challengeVotes)):
        averageChalllenge += challengeVotes[count1] * count1
    averageChalllenge /= len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[2] > 0))
    for count1 in range(1, len(challengeVotes)):
        #If difficulty being compared has more votes than current difficulty
        if challengeVotes[challengeSetting] < challengeVotes[count1]:
            challengeSetting = count1
        elif challengeVotes[count1] > 0 and challengeVotes[challengeSetting] == challengeVotes[count1]:
            #Pick difficulty closest to the average difficulty vote
            if abs(challengeSetting - averageChalllenge) > abs(count1 - averageChalllenge):
                challengeSetting = count1
    #Default difficulty
    if challengeSetting == 0:
        challengeSetting = 1
    startRule(determineObjectiveType)
    startTime = 300


def determineObjectiveType():
    @Name "determineObjectiveType"
    
    objectiveTypeSetting = 0
    for count1 in range(1, len(objectiveTypeVotes)):
        if objectiveTypeVotes[count1][1]:
            objectiveTypeVotes[count1] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[4] == count1))
        else:
            objectiveTypeVotes[count1] = -1
    for count1 in range(1, len(objectiveTypeVotes)):
        if objectiveTypeVotes[objectiveTypeSetting] < objectiveTypeVotes[count1]:
            objectiveTypeSetting = count1
        elif objectiveTypeVotes[objectiveTypeSetting] == objectiveTypeVotes[count1]:
            #Pick random objective type to break tie
            if objectiveTypeSetting != 0 and random.randint(0, 1) == 0:
                objectiveTypeSetting = count1
    #If all players choose no preference, randomize
    if objectiveTypeSetting == 0:
        if objectiveTypeVotes.last() != -1:
            objectiveTypeSetting = len(objectiveTypeVotes) - 1
        else:
            while objectiveTypeSetting == 0 or objectiveTypeVotes[objectiveTypeSetting] == -1:
                objectiveTypeSetting = random.randint(1, len(objectiveTypeVotes) - 1)
    voting = false
    startRule(setObjectiveType)


def setObjectiveType():
    @Name "setObjectiveType"
    
    #Wait until game begins
    waitUntil(isGameInProgress() and not specialGameModeSetup, 99999)
    #Create objective positions
    while len(objectiveTypes) < createWorkshopSettingInt("General", "Number of Objectives", 5, 0, 100) + 1:
        if objectiveTypeSetting != len(objectiveTypeVotes) - 1:
            objectiveTypes.append(objectiveTypeSetting)
        else:
            #Mixed objective assignment
            objectiveTypes.append(random.choice(mixedObjectivesPool.exclude(objectiveTypes.filter(lambda _, i: i > len(objectiveTypes) - 1 - (len(mixedObjectivesPool) - 1)))))
        objectiveCount1 = 0
        while len(objectivePositions) < len(objectiveTypes):
            #Limits possible map grid points to set min and max range from last created objective position
            testPos = random.choice(mapGrid if len(objectivePositions) == 0 else mapGrid.filter(lambda x: distance(x, objectivePositions.last()) > objectiveSpacing[0] and distance(x, objectivePositions.last()) < min(100, objectiveSpacing[0] * 3)))
            testPos += Vector.UP
            wait()
            #Minimum objective spacing
            if len(objectivePositions) == 0 or objectivePositions.slice(len(objectivePositions) - 5, 5).all(lambda x: distance(testPos, x) > objectiveSpacing[1]):
                #Ensures bosses spawn with head room
                if objectiveTypes.last() != 2 or isInLoS(testPos + vect(0, 0, 0), testPos + vect(0, 10, 0)):
                    objectivePositions.append(testPos)
                    objectiveCount1 = 0
            objectiveCount1++
            #If Too many attempts
            if objectiveCount1 > 50:
                del objectivePositions[len(objectivePositions) - 1]
                del objectivePositions[len(objectivePositions) - 1]
                objectiveCount1 = 0
    #Last objective must be extraction objective
    objectiveTypes[len(objectiveTypes) - 1] = 1
    objectivesManagement()
    gameStatus = true
