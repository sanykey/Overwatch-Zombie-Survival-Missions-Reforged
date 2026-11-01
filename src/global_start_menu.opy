#!mainFile "main.opy"

subroutine determineChallenge
subroutine determineZombieMode
subroutine setZombieMode
subroutine determineObjectiveType
subroutine setObjectiveType

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
            startPos = raycastHitPosition(startCamPos - offsetUpThreeQuartersConst, startPos + offsetUpThreeQuartersConst, null, null, false) - offsetUpThreeQuartersConst
            startCamPos = startPos + vect(0, 1.5, 0) + directionFromAngles(horizontalAngleOfDirection(directionTowards(startPos, startCamPos)), 0) * startCamDistance
            #Line of Sight Checks for each player position
            # tmp0: horizontal angle offset in degrees, to test visibility of each menu position.
            for tmp0 in range(-26, 27, 2):
                if not isInLoS(startCamPos, startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + tmp0, 0)) * startCamDistance)) or not isInLoS(startCamPos + vect(0, -0.75, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + tmp0, 0)) * startCamDistance), startCamPos):
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
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState < PregameState.READY), "For information on changes: workshop.codes/786TW", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Voting options reminder
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.READY), "Voting options are available in the top left corner of your screen" if voting else "Voting is complete. Difficulty is actively scaled by amount of players.", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA if voting else Color.PURPLE, SpecVisibility.NEVER)
    #Ready In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.HERO_SELECTED), "Ready [{0}]".format(inputBindingString(Button.JUMP)), localPlayer.startPos + vect(0, 1.92, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.NEVER)
    #Change Hero In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.HERO_SELECTED and getMatchTime() > 2.5), "Change Hero [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, 1.8, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Cancel In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.READY and getMatchTime() > 2.5), "Cancel [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.startPos + vect(0, -0.6, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 49, 49), SpecVisibility.NEVER)
    #One reevaluated HUD per category; localPlayer selects the viewer's current option.
    #Do not capture vote indices or dynamic text/colors with evalOnce.
    #Empty descriptions must be strings: null selected from an array displays as 0.
    #Both vote filters share the 0-6 sequence; Challenge excludes the final entry.
    #Challenge
    hudText(
        getAllPlayers().filter(lambda player: player.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE] in numbersList.slice(NL_MENU_VOTE_IDS_OFFSET, NL_MENU_VOTE_IDS_LEN - 1)),
        [
            "Challenge: No Preference",
            "Challenge: None",
            "Challenge: Swarm Shootout",
            "Challenge: Random Abilities",
            specialEffectsStrings if specialEffectsTiming else "Challenge: Insanity",
            specialEffectsStrings if specialEffectsTiming else "Challenge: Pandora's Box"
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]],
        [
            "",
            "",
            "Zombies fire their guns!",
            "Non-boss zombies use abilities",
            "Faster, stronger, and deadlier",
            "All challenges at Once!"
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if voting or localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE] == 0 else [],
        HudPosition.LEFT,
        0,
        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE if specialEffectsTiming else Color.TURQUOISE, Color.GRAY if specialEffectsTiming else Color.PURPLE][localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]],
        [Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]],
        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Zombie Mode
    startMenuZombieColors = [Color.AQUA, Color.ORANGE, Color.RED, Color.PURPLE, Color.LIME_GREEN, Color.BLUE, Color.GRAY]
    hudText(
        getAllPlayers().filter(lambda player: player.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] in numbersList.slice(NL_MENU_VOTE_IDS_OFFSET, NL_MENU_VOTE_IDS_LEN)),
        [
            "Zombie Mode: No Preference",
            "Zombie Mode: All Zombies",
            "Zombie Mode: New Blood",
            "Zombie Mode: What'll it be?",
            "Zombie Mode: Zombie Shuffle",
            "Zombie Mode: Dinner Rush!",
            "Zombie Mode: Ham N' Hammer!"
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]],
        [
            "",
            "Normal game featuring all zombie types",
            "The 13 most recent zombie types will spawn",
            "All zombie types have equal spawn rates",
            "The zombie spawn rates twist and turn with wild abandon!",
            "Only zombies with mobility abilities will spawn",
            "Only Reinhardt {0} and Wrecking Ball {1} zombies will spawn".format(heroIcon(Hero.REINHARDT), heroIcon(Hero.WRECKING_BALL))
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if voting or localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] == 0 else [],
        HudPosition.LEFT,
        1,
        startMenuZombieColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]],
        startMenuZombieColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]],
        startMenuZombieColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Objective Type: arrays use raw IDs; 3, 4 and 8 have no standalone menu row.
    startMenuObjectiveColors = [Color.AQUA, Color.ORANGE, Color.RED, null, null, Color.RED, Color.LIME_GREEN, colorSatelliteUplinkConst, null, Color.PURPLE]
    hudText(
        getAllPlayers().filter(lambda player: player.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] in [ObjectiveType.NO_PREFERENCE, ObjectiveType.SHOWDOWN, ObjectiveType.BOSSES, ObjectiveType.KILL_ZONE, ObjectiveType.ZOMBIE_EGG, ObjectiveType.SATELLITE_UPLINK, ObjectiveType.MIXED_OBJECTIVES]),
        [
            "Objective Type: No Preference",
            "Objective Type: Showdown {0}".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)),
            "Objective Type: Bosses {0}".format(iconString(Icon.WARNING)),
            null,
            null,
            "Objective Type: Kill Zone {0}".format(iconString(Icon.RING_THICK) if ceil(getTotalTimeElapsed() * 1.25) % 2 == 0 else iconString(Icon.RING_THIN)),
            "Objective Type: Zombie Egg {0}".format(iconString(Icon.RADIOACTIVE)),
            "Objective Type: Satellite Uplink {0}".format(iconString(Icon.MOON)),
            null,
            "Objective Type: Mixed Objectives {0}".format(iconString(Icon.SPIRAL))
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]],
        [
            "",
            "Players must contest a point against zombies",
            "Spawns giant versions of zombies",
            null,
            null,
            "Clear zombies from a designated area",
            "Survivors must destroy an object that is spawning zombies",
            "Survivors must repair terminals to communicate with a satellite",
            null,
            "Randomly assigns all types of objectives"
        ][localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if voting or localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] == 0 else [],
        HudPosition.LEFT,
        2,
        startMenuObjectiveColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]],
        startMenuObjectiveColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]],
        startMenuObjectiveColors[localPlayer.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Enhancement
    startMenuEnhancementColors = [Color.AQUA, colorKevlarConst, Color.GRAY, Color.BLUE, Color.RED, Color.ORANGE, Color.GREEN, Color.GRAY, colorChargeBatteryConst, Color.PURPLE, Color.BLUE]
    hudText(
        getAllPlayers().filter(lambda player: player.enhancementId in [Enhancement.NO_PREFERENCE, Enhancement.KEVLAR, Enhancement.ZOMBIE_HYBRID, Enhancement.LASER_BARRICADE, Enhancement.BRAIN_KILLER, Enhancement.PYROTECHNIC, Enhancement.PLAGUE_DOCTOR, Enhancement.BORN_TO_BATTLE, Enhancement.CHARGE_BATTERY, Enhancement.HITCHHIKER, Enhancement.PUP]),
        [
            "Enhancement: No Preference",
            "Enhancement: Kevlar {0}".format(iconString(Icon.STOP)),
            "Enhancement: Zombie Hybrid {0}".format(iconString(Icon.POISON)),
            "Enhancement: Laser Barricade {0}".format(iconString(Icon.DIAMOND)),
            "Enhancement: Brain Killer {0}".format(iconString(Icon.SKULL)),
            "Enhancement: Pyrotechnic {0}".format(iconString(Icon.FIRE)),
            "Enhancement: Plague Doctor {0}".format(iconString(Icon.PLUS)),
            "Enhancement: Born to Battle {0}".format(iconString(Icon.BOLT)),
            "Enhancement: Charge Battery {0}".format(iconString(Icon.SPIRAL)),
            "Enhancement: Hitchhiker {0}".format(iconString(Icon.FLAG)),
            "Enhancement: P.U.P. {0}".format(iconString(Icon.HAPPY))
        ][localPlayer.enhancementId],
        [
            "",
            "Survivor is equipped with armor that protects against infections",
            "Get infected faster, and convert it to explosive damage",
            "Player can place a wall that blocks zombies",
            "Critical hits do more damage",
            "Dealing damage, within 15 meters, sets enemies on fire",
            "Deal more healing to infected players while reducing their infection level",
            "Dealing a final blow will give the player a cooldown reset on the next ability they use",
            "Survivor can place a battery that gives ultimate charge",
            "Survivor can attach to a teammate and fuse their health.",
            "Survivor is equipped with an autonomous friendly droid"
        ][localPlayer.enhancementId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)),
        HudPosition.LEFT,
        3,
        startMenuEnhancementColors[localPlayer.enhancementId],
        startMenuEnhancementColors[localPlayer.enhancementId],
        startMenuEnhancementColors[localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )


rule "SPECIAL EFFECT CONTROLS":
    @Condition specialGameModeSetup == true
    
    if specialGameModeSetup:
        # tmp0: random message choice 1-3, to select the special-effect text for this flash.
        tmp0 = random.randint(1, 3)
        if tmp0 == 1:
            specialEffectsStrings = "alglChene oteV: KaMeNrldEr"
        elif tmp0 == 2:
            specialEffectsStrings = "You won't win"
        elif tmp0 == 3:
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
    @Condition len(getPlayers(Team.1).filter(lambda player: player.pregameState > PregameState.SELECTING_HERO)) > 0
    
    chase1 = votingEndTime
    startRule(determineZombieMode)
    #Waits until votes have been counted
    waitUntil(not voting, 99999)
    getPlayers(Team.1).playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE] = challengeSetting
    getPlayers(Team.1).playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = zombieSetting
    getPlayers(Team.1).playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = objectiveTypeSetting
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
    # tmp0: zombie-mode vote index, to count active players voting for each enabled mode.
    for tmp0 in range(1, len(zombieVotes)):
        if zombieVotes[tmp0][1]:
            zombieVotes[tmp0] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] == tmp0))
        else:
            zombieVotes[tmp0] = -1
    # tmp0: candidate zombie-mode index, to select the winner and resolve tied vote counts.
    for tmp0 in range(1, len(zombieVotes)):
        if zombieVotes[zombieSetting] < zombieVotes[tmp0]:
            zombieSetting = tmp0
        elif zombieVotes[zombieSetting] == zombieVotes[tmp0]:
            #Randomly pick mode to break tie
            if zombieSetting != 0 and random.randint(0, 1) == 0:
                zombieSetting = tmp0
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
        # tmp0: hero-entry counter, to append 19 equal spawn weights for this zombie mode.
        for tmp0 in range(19):
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
    # tmp0: challenge vote index, to count active players voting for each enabled difficulty.
    for tmp0 in range(1, len(challengeVotes)):
        if challengeVotes[tmp0][1]:
            challengeVotes[tmp0] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE] == tmp0))
        else:
            challengeVotes[tmp0] = -1
    # tmp1: sum of difficulty levels weighted by votes, to calculate the average difficulty vote.
    tmp1 = 0
    # tmp0: difficulty index, to include each difficulty's weighted votes in tmp1.
    for tmp0 in range(1, len(challengeVotes)):
        # tmp1: running weighted sum including this difficulty, for the average used to break ties.
        tmp1 += challengeVotes[tmp0] * tmp0
    # tmp1: average difficulty vote, to choose the closer difficulty when vote counts tie.
    tmp1 /= len(getPlayers(Team.1).filter(lambda player: player.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE] > 0))
    # tmp0: candidate difficulty index, to choose the winner using votes and distance from tmp1.
    for tmp0 in range(1, len(challengeVotes)):
        #If difficulty being compared has more votes than current difficulty
        if challengeVotes[challengeSetting] < challengeVotes[tmp0]:
            challengeSetting = tmp0
        elif challengeVotes[tmp0] > 0 and challengeVotes[challengeSetting] == challengeVotes[tmp0]:
            #Pick difficulty closest to the average difficulty vote
            if abs(challengeSetting - tmp1) > abs(tmp0 - tmp1):
                challengeSetting = tmp0
    #Default difficulty
    if challengeSetting == 0:
        challengeSetting = 1
    startRule(determineObjectiveType)
    startTime = 300


def determineObjectiveType():
    @Name "determineObjectiveType"
    
    objectiveTypeSetting = ObjectiveType.NO_PREFERENCE
    # tmp0: objective-type vote index, to count active players voting for each enabled objective type.
    for tmp0 in range(ObjectiveType.SHOWDOWN, len(objectiveTypeVotes)):
        if objectiveTypeVotes[tmp0][1]:
            objectiveTypeVotes[tmp0] = len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus and player.playerMenuStatus[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] == tmp0))
        else:
            objectiveTypeVotes[tmp0] = -1
    # tmp0: candidate objective-type index, to select the winner and resolve tied vote counts.
    for tmp0 in range(ObjectiveType.SHOWDOWN, len(objectiveTypeVotes)):
        if objectiveTypeVotes[objectiveTypeSetting] < objectiveTypeVotes[tmp0]:
            objectiveTypeSetting = tmp0
        elif objectiveTypeVotes[objectiveTypeSetting] == objectiveTypeVotes[tmp0]:
            #Pick random objective type to break tie
            if objectiveTypeSetting != ObjectiveType.NO_PREFERENCE and random.randint(0, 1) == 0:
                objectiveTypeSetting = tmp0
    #If all players choose no preference, randomize
    if objectiveTypeSetting == ObjectiveType.NO_PREFERENCE:
        if objectiveTypeVotes[ObjectiveType.MIXED_OBJECTIVES] != -1:
            objectiveTypeSetting = ObjectiveType.MIXED_OBJECTIVES
        else:
            while objectiveTypeSetting == ObjectiveType.NO_PREFERENCE or objectiveTypeVotes[objectiveTypeSetting] == -1:
                objectiveTypeSetting = random.randint(ObjectiveType.SHOWDOWN, len(objectiveTypeVotes) - 1)
    voting = false
    startRule(setObjectiveType)


def setObjectiveType():
    @Name "setObjectiveType"
    
    #Wait until game begins
    waitUntil(isGameInProgress() and not specialGameModeSetup, 99999)
    #Create objective positions
    while len(objectiveTypes) < createWorkshopSettingInt("General", "Number of Objectives", 5, 0, 100) + 1:
        if objectiveTypeSetting != ObjectiveType.MIXED_OBJECTIVES:
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
                if objectiveTypes.last() != ObjectiveType.BOSSES or isInLoS(testPos + vect(0, 0, 0), testPos + vect(0, 10, 0)):
                    objectivePositions.append(testPos)
                    objectiveCount1 = 0
            objectiveCount1++
            #If Too many attempts
            if objectiveCount1 > 50:
                del objectivePositions[len(objectivePositions) - 1]
                del objectivePositions[len(objectivePositions) - 1]
                objectiveCount1 = 0
    #Last objective must be extraction objective
    objectiveTypes[len(objectiveTypes) - 1] = ObjectiveType.SHOWDOWN
    objectivesManagement()
    isGameplayActive = true
