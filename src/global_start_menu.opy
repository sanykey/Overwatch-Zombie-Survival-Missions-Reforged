#!mainFile "main.opy"

subroutine determineChallenge
subroutine determineZombieMode
subroutine setZombieMode
subroutine determineObjectiveType
subroutine setObjectiveType

rule "GLOBAL MENU INITIALIZATION":
    @Condition isPregameSetup == true
    @Condition len(mapGridList) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if isSpecialGameMode:
        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 15 * Vector.UP
        elif getCurrentGamemode() == Gamemode.CONTROL:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 100 * Vector.UP
        else:
            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 150 + 30 * Vector.UP
        startCamPos = startPos + offsetUpOneAndHalfConst + directionFromAngles(horizontalAngleOfDirection(directionTowards(walkCenter, startPos)), 0) * START_CAM_DISTANCE
        wait()
        # Shared menu storage changes owners at START GAME.
        if not isPregameSetup:
            return
        createDummy(Hero.REAPER, Team.2, -1, nearestWalkablePosition(startPos), Vector.FORWARD)
        wait()
        # Shared menu storage changes owners at START GAME.
        if not isPregameSetup:
            return
        getPlayers(Team.2).setInvisibility(Invis.ALL)
        getPlayers(Team.2)[0].startForcingPosition(startPos + 15 * Vector.UP)
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
            startCamPos = startPos + offsetUpOneAndHalfConst + directionFromAngles(random.uniform(0, 360), 0) * START_CAM_DISTANCE
            startCamPos = raycastHitPosition(startCamPos, startCamPos - 5 * Vector.UP, null, null, false) + offsetUpOneAndHalfConst
            startPos = vect(startPos.x, startCamPos.y - 1.5, startPos.z)
            startPos = raycastHitPosition(startPos + 0.4 * Vector.UP, startPos - 5 * Vector.UP, null, null, false)
            startPos = raycastHitPosition(startCamPos - offsetUpThreeQuartersConst, startPos + offsetUpThreeQuartersConst, null, null, false) - offsetUpThreeQuartersConst
            startCamPos = startPos + offsetUpOneAndHalfConst + directionFromAngles(horizontalAngleOfDirection(directionTowards(startPos, startCamPos)), 0) * START_CAM_DISTANCE
            #Line of Sight Checks for each player position
            # menuVisibilityAngleOffset: horizontal angle offset in degrees, to test visibility of each menu position.
            #!define menuVisibilityAngleOffset tmp0
            for menuVisibilityAngleOffset in range(-26, 27, 2):
                if not isInLoS(startCamPos, startCamPos + -0.75 * Vector.UP + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + menuVisibilityAngleOffset, 0)) * START_CAM_DISTANCE)) or not isInLoS(startCamPos + -0.75 * Vector.UP + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + menuVisibilityAngleOffset, 0)) * START_CAM_DISTANCE), startCamPos):
                    startPos = null
                    break
            wait()
            # Shared menu storage changes owners at START GAME.
            if not isPregameSetup:
                return
    lbl_0:
    # Scene setup can resume after START GAME; the slot then belongs to the Biomorphing color.
    if isPregameSetup:
        startMenuSpacingAngle = 40
    #Start screen objective description
    setObjectiveDescription(getAllPlayers(), "Voting ends in {0}s".format(ceil(getMatchTime() - VOTING_END_TIME)) if isVoting else "Select your hero", HudReeval.VISIBILITY_AND_STRING)


rule "EFFECTS/TEXTS":
    #Pre game objective description and match timer
    hudSubtext(getAllPlayers(), "{0} | {1}s".format("Voting will end in {0}s".format(ceil(getMatchTime() - VOTING_END_TIME)) if isVoting else "Select your hero", ceil(getMatchTime())), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "Original Game Code: MPJFR" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Game Mode Creator: Mazattack#1183", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "This is a modified version: 786TW" if ceil(getTotalTimeElapsed() * 0.2) % 2 == 0 else "Modified by: KamenRider#11346", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Workshop.codes
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState < PregameState.READY), "For information on changes: workshop.codes/786TW", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Voting options reminder
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.READY), "Voting options are available in the top left corner of your screen" if isVoting else "Voting is complete. Difficulty is actively scaled by amount of players.", startCamPos + directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)), 30), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.AQUA if isVoting else Color.PURPLE, SpecVisibility.NEVER)
    #Ready In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.HERO_SELECTED), "Ready [{0}]".format(inputBindingString(Button.JUMP)), localPlayer.pregamePosition + 1.92 * Vector.UP, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.NEVER)
    #Change Hero In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.HERO_SELECTED and getMatchTime() > 2.5), "Change Hero [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.pregamePosition + 1.8 * Vector.UP, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.NEVER)
    #Cancel In World Text
    createInWorldText(getAllPlayers().filter(lambda player: player.pregameState == PregameState.READY and getMatchTime() > 2.5), "Cancel [{0}]".format(inputBindingString(Button.CROUCH)), localPlayer.pregamePosition + -0.6 * Vector.UP, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(255, 49, 49), SpecVisibility.NEVER)
    #One reevaluated HUD per category; localPlayer selects the viewer's current option.
    #Do not capture vote indices or dynamic text/colors with evalOnce.
    #Empty descriptions must be strings: null selected from an array displays as 0.
    #Both vote filters share the 0-6 sequence; Challenge excludes the final entry.
    #Challenge
    hudText(
        getAllPlayers().filter(lambda player: player.pregameChallengeVote in numbersList.slice(NL_MENU_VOTE_IDS_OFFSET, NL_MENU_VOTE_IDS_LEN - 1)),
        [
            "Challenge: No Preference",
            "Challenge: None",
            "Challenge: Swarm Shootout",
            "Challenge: Random Abilities",
            pregameGlitchText if isPregameGlitchActive else "Challenge: Insanity",
            pregameGlitchText if isPregameGlitchActive else "Challenge: Pandora's Box"
        ][localPlayer.pregameChallengeVote],
        [
            "",
            "",
            "Zombies fire their guns!",
            "Non-boss zombies use abilities",
            "Faster, stronger, and deadlier",
            "All challenges at Once!"
        ][localPlayer.pregameChallengeVote],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ULTIMATE)) if isVoting or localPlayer.pregameChallengeVote == 0 else [],
        HudPosition.LEFT,
        0,
        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE if isPregameGlitchActive else Color.TURQUOISE, Color.GRAY if isPregameGlitchActive else Color.PURPLE][localPlayer.pregameChallengeVote],
        [Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote],
        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Zombie Mode
    startMenuZombieColorList = [Color.AQUA, Color.ORANGE, Color.RED, Color.PURPLE, Color.LIME_GREEN, Color.BLUE, Color.GRAY]
    hudText(
        getAllPlayers().filter(lambda player: player.pregameZombieVote in numbersList.slice(NL_MENU_VOTE_IDS_OFFSET, NL_MENU_VOTE_IDS_LEN)),
        [
            "Zombie Mode: No Preference",
            "Zombie Mode: All Zombies",
            "Zombie Mode: New Blood",
            "Zombie Mode: What'll it be?",
            "Zombie Mode: Zombie Shuffle",
            "Zombie Mode: Dinner Rush!",
            "Zombie Mode: Ham N' Hammer!"
        ][localPlayer.pregameZombieVote],
        [
            "",
            "Normal game featuring all zombie types",
            "The 13 most recent zombie types will spawn",
            "All zombie types have equal spawn rates",
            "The zombie spawn rates twist and turn with wild abandon!",
            "Only zombies with mobility abilities will spawn",
            "Only Reinhardt {0} and Wrecking Ball {1} zombies will spawn".format(heroIcon(Hero.REINHARDT), heroIcon(Hero.WRECKING_BALL))
        ][localPlayer.pregameZombieVote],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_1)) if isVoting or localPlayer.pregameZombieVote == 0 else [],
        HudPosition.LEFT,
        1,
        startMenuZombieColorList[localPlayer.pregameZombieVote],
        startMenuZombieColorList[localPlayer.pregameZombieVote],
        startMenuZombieColorList[localPlayer.pregameZombieVote],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Objective Type: arrays use raw IDs; 3, 4 and 8 have no standalone menu row.
    startMenuObjectiveColorList = [Color.AQUA, Color.ORANGE, Color.RED, null, null, Color.RED, Color.LIME_GREEN, rgb(12, 129, 132), null, Color.PURPLE]
    hudText(
        getAllPlayers().filter(lambda player: player.pregameObjectiveVote in [ObjectiveType.NO_PREFERENCE, ObjectiveType.SHOWDOWN, ObjectiveType.BOSSES, ObjectiveType.KILL_ZONE, ObjectiveType.ZOMBIE_EGG, ObjectiveType.SATELLITE_UPLINK, ObjectiveType.MIXED_OBJECTIVES]),
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
        ][localPlayer.pregameObjectiveVote],
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
        ][localPlayer.pregameObjectiveVote],
        "Change Vote (Press [{0}])".format(inputBindingString(Button.ABILITY_2)) if isVoting or localPlayer.pregameObjectiveVote == 0 else [],
        HudPosition.LEFT,
        2,
        startMenuObjectiveColorList[localPlayer.pregameObjectiveVote],
        startMenuObjectiveColorList[localPlayer.pregameObjectiveVote],
        startMenuObjectiveColorList[localPlayer.pregameObjectiveVote],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
    #Enhancement
    startMenuEnhancementColorList = [Color.AQUA, colorKevlarConst, Color.GRAY, Color.BLUE, Color.RED, Color.ORANGE, Color.GREEN, Color.GRAY, colorChargeBatteryConst, Color.PURPLE, Color.BLUE]
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
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )


rule "SPECIAL EFFECT CONTROLS":
    @Condition isPregameSetup == true
    
    if isPregameSetup:
        # menuGlitchMessageChoice: random message choice 1-3, to select the special-effect text for this flash.
        #!define menuGlitchMessageChoice tmp0
        menuGlitchMessageChoice = random.randint(1, 3)
        if menuGlitchMessageChoice == 1:
            pregameGlitchText = "alglChene oteV: KaMeNrldEr"
        elif menuGlitchMessageChoice == 2:
            pregameGlitchText = "You won't win"
        elif menuGlitchMessageChoice == 3:
            pregameGlitchText = "Don't even try it"
    isPregameGlitchActive = true
    wait(random.uniform(0.063, 0.325), Wait.ABORT_WHEN_FALSE)
    isPregameGlitchActive = false
    wait(random.uniform(0.325, 1.5), Wait.ABORT_WHEN_FALSE)
    loop()


rule "END VOTING":
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition getMatchTime() < VOTING_END_TIME
    @Condition len(getPlayers(Team.1).filter(lambda player: player.pregameState > PregameState.SELECTING_HERO)) > 0
    
    pregameCountdown = VOTING_END_TIME
    startRule(determineZombieMode)
    #Waits until votes have been counted
    waitUntil(not isVoting or not isPregameSetup, 99999)
    # Votes share runtime trade/path storage; a resumed menu writer must not touch it.
    if not isPregameSetup:
        return
    getPlayers(Team.1).pregameChallengeVote = challengeSetting
    getPlayers(Team.1).pregameZombieVote = zombieSetting
    getPlayers(Team.1).pregameObjectiveVote = objectiveTypeSetting
    bigMessage(getAllPlayers(), "Voting has ended!")
    startRule(setPrematchTimer)


rule "MUSIC/ANNOUNCER CONTROL":
    @Condition isVoting != true
    @Condition isPregameSetup == true
    
    if getMatchTime() < 20:
        enableMusic()
        enableAnnouncer()
        waitUntil(getMatchTime() > 20 or not isPregameSetup, 60)
    else:
        disableMusic()
        disableAnnouncer()
        waitUntil(getMatchTime() < 20 or not isPregameSetup, 60)
    if ruleCondition:
        loop()


def determineZombieMode():
    @Name "determineZombieMode"
    
    zombieSetting = 0
    # zombieModeVoteIndex: zombie-mode vote index, to count active players voting for each enabled mode.
    #!define zombieModeVoteIndex tmp0
    for zombieModeVoteIndex in range(1, len(zombieVoteList)):
        if zombieVoteList[zombieModeVoteIndex][1]:
            zombieVoteList[zombieModeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameZombieVote == zombieModeVoteIndex))
        else:
            zombieVoteList[zombieModeVoteIndex] = -1
    # zombieModeVoteIndex: candidate zombie-mode index, to select the winner and resolve tied vote counts.
    for zombieModeVoteIndex in range(1, len(zombieVoteList)):
        if zombieVoteList[zombieSetting] < zombieVoteList[zombieModeVoteIndex]:
            zombieSetting = zombieModeVoteIndex
        elif zombieVoteList[zombieSetting] == zombieVoteList[zombieModeVoteIndex]:
            #Randomly pick mode to break tie
            if zombieSetting != 0 and random.randint(0, 1) == 0:
                zombieSetting = zombieModeVoteIndex
    #If all players choose no preference, randomize
    if zombieSetting == 0:
        zombieSetting = 1
    startRule(determineChallenge)
    startRule(setZombieMode)


def setZombieMode():
    @Name "setZombieMode"
    
    #Bot available hero list
    botHeroList = [Hero.REAPER, Hero.JUNKRAT, Hero.TORBJORN, Hero.ROADHOG, Hero.REINHARDT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.MAUGA, Hero.MERCY, Hero.WRECKING_BALL, Hero.MOIRA, Hero.PHARAH, Hero.SIGMA, Hero.JUNKER_QUEEN, Hero.ILLARI, Hero.HAZARD, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO]
    #Zombie types without a boss variation
    bossesExcludedHeroList = [Hero.JUNKRAT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.JUNKER_QUEEN, Hero.SYMMETRA, Hero.ANA, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.SIGMA, Hero.WRECKING_BALL]
    #All Zombies
    if zombieSetting == 1:
        #Bot respawn probablities
        botSpawnRateList = numbersList.slice(NL_SPAWN_RATES_ALL_ZOMBIES_OFFSET, NL_SPAWN_RATES_ALL_ZOMBIES_LEN)
    #New Blood
    elif zombieSetting == 2:
        #Bot respawn probablities
        botSpawnRateList = numbersList.slice(NL_SPAWN_RATES_NEW_BLOOD_OFFSET, NL_SPAWN_RATES_NEW_BLOOD_LEN)
    #What'll it be?
    elif zombieSetting == 3:
        #Bot respawn probablities
        botSpawnRateList = []
        # equalSpawnWeightHeroIndex: hero-entry counter, to append 19 equal spawn weights for this zombie mode.
        #!define equalSpawnWeightHeroIndex tmp0
        for equalSpawnWeightHeroIndex in range(19):
            botSpawnRateList.append(5.263)
    #Zombie Shuffle
    elif zombieSetting == 4:
        #Bot respawn probablities
        botSpawnRateList = numbersList.slice(NL_SPAWN_RATES_SHUFFLE_OFFSET, NL_SPAWN_RATES_SHUFFLE_LEN)
    #Dinner Rush!
    elif zombieSetting == 5:
        #Bot respawn probablities
        botSpawnRateList = numbersList.slice(NL_SPAWN_RATES_DINNER_RUSH_OFFSET, NL_SPAWN_RATES_DINNER_RUSH_LEN)
    #Ham N' Hammer
    elif zombieSetting == 6:
        #Bot respawn probablities
        botSpawnRateList = numbersList.slice(NL_SPAWN_RATES_HAM_N_HAMMER_OFFSET, NL_SPAWN_RATES_HAM_N_HAMMER_LEN)


def determineChallenge():
    @Name "determineChallenge"
    
    challengeSetting = 0
    # challengeVoteIndex: challenge vote index, to count active players voting for each enabled difficulty.
    #!define challengeVoteIndex tmp0
    for challengeVoteIndex in range(1, len(challengeVoteList)):
        if challengeVoteList[challengeVoteIndex][1]:
            challengeVoteList[challengeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameChallengeVote == challengeVoteIndex))
        else:
            challengeVoteList[challengeVoteIndex] = -1
    # challengeWeightedVoteSum: sum of difficulty levels weighted by votes, to calculate the average difficulty vote.
    #!define challengeWeightedVoteSum tmp1
    challengeWeightedVoteSum = 0
    # challengeVoteIndex: difficulty index, to include each difficulty's weighted votes in challengeWeightedVoteSum.
    for challengeVoteIndex in range(1, len(challengeVoteList)):
        # challengeWeightedVoteSum: running weighted sum including this difficulty, for the average used to break ties.
        challengeWeightedVoteSum += challengeVoteList[challengeVoteIndex] * challengeVoteIndex
    # challengeAverageVote: average difficulty vote, to choose the closer difficulty when vote counts tie.
    #!define challengeAverageVote tmp1
    challengeAverageVote /= len(getPlayers(Team.1).filter(lambda player: player.pregameChallengeVote > 0))
    # challengeVoteIndex: candidate difficulty index, to choose the winner using votes and distance from challengeAverageVote.
    for challengeVoteIndex in range(1, len(challengeVoteList)):
        #If difficulty being compared has more votes than current difficulty
        if challengeVoteList[challengeSetting] < challengeVoteList[challengeVoteIndex]:
            challengeSetting = challengeVoteIndex
        elif challengeVoteList[challengeVoteIndex] > 0 and challengeVoteList[challengeSetting] == challengeVoteList[challengeVoteIndex]:
            #Pick difficulty closest to the average difficulty vote
            if abs(challengeSetting - challengeAverageVote) > abs(challengeVoteIndex - challengeAverageVote):
                challengeSetting = challengeVoteIndex
    #Default difficulty
    if challengeSetting == 0:
        challengeSetting = 1
    startRule(determineObjectiveType)


def determineObjectiveType():
    @Name "determineObjectiveType"
    
    objectiveTypeSetting = ObjectiveType.NO_PREFERENCE
    # objectiveTypeVoteIndex: objective-type vote index, to count active players voting for each enabled objective type.
    #!define objectiveTypeVoteIndex tmp0
    for objectiveTypeVoteIndex in range(ObjectiveType.SHOWDOWN, len(objectiveTypeVoteList)):
        if objectiveTypeVoteList[objectiveTypeVoteIndex][1]:
            objectiveTypeVoteList[objectiveTypeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameObjectiveVote == objectiveTypeVoteIndex))
        else:
            objectiveTypeVoteList[objectiveTypeVoteIndex] = -1
    # objectiveTypeVoteIndex: candidate objective-type index, to select the winner and resolve tied vote counts.
    for objectiveTypeVoteIndex in range(ObjectiveType.SHOWDOWN, len(objectiveTypeVoteList)):
        if objectiveTypeVoteList[objectiveTypeSetting] < objectiveTypeVoteList[objectiveTypeVoteIndex]:
            objectiveTypeSetting = objectiveTypeVoteIndex
        elif objectiveTypeVoteList[objectiveTypeSetting] == objectiveTypeVoteList[objectiveTypeVoteIndex]:
            #Pick random objective type to break tie
            if objectiveTypeSetting != ObjectiveType.NO_PREFERENCE and random.randint(0, 1) == 0:
                objectiveTypeSetting = objectiveTypeVoteIndex
    #If all players choose no preference, randomize
    if objectiveTypeSetting == ObjectiveType.NO_PREFERENCE:
        if objectiveTypeVoteList[ObjectiveType.MIXED_OBJECTIVES] != -1:
            objectiveTypeSetting = ObjectiveType.MIXED_OBJECTIVES
        else:
            while objectiveTypeSetting == ObjectiveType.NO_PREFERENCE or objectiveTypeVoteList[objectiveTypeSetting] == -1:
                objectiveTypeSetting = random.randint(ObjectiveType.SHOWDOWN, len(objectiveTypeVoteList) - 1)
    isVoting = false
    startRule(setObjectiveType)


def setObjectiveType():
    @Name "setObjectiveType"
    
    #Wait until game begins
    waitUntil(isGameInProgress() and not isPregameSetup, 99999)
    #Create objective positions
    while len(objectiveTypeList) < createWorkshopSettingInt("General", "Number of Objectives", 5, 0, 100) + 1:
        if objectiveTypeSetting != ObjectiveType.MIXED_OBJECTIVES:
            objectiveTypeList.append(objectiveTypeSetting)
            currentObjectiveType = objectiveTypeList[0]
        else:
            #Mixed objective assignment
            objectiveTypeList.append(random.choice(mixedObjectiveTypeList.exclude(objectiveTypeList.filter(lambda _, i: i > len(objectiveTypeList) - 1 - (len(mixedObjectiveTypeList) - 1)))))
            currentObjectiveType = objectiveTypeList[0]
        missionPlacementAttemptCount = 0
        while len(objectivePositionList) < len(objectiveTypeList):
            #Limits possible map grid points to set min and max range from last created objective position
            missionCandidatePosition = random.choice(mapGridList if len(objectivePositionList) == 0 else mapGridList.filter(lambda x: distance(x, objectivePositionList.last()) > objectiveSpacingList[0] and distance(x, objectivePositionList.last()) < min(100, objectiveSpacingList[0] * 3)))
            missionCandidatePosition += Vector.UP
            wait()
            #Minimum objective spacing
            if len(objectivePositionList) == 0 or objectivePositionList.slice(len(objectivePositionList) - 5, 5).all(lambda x: distance(missionCandidatePosition, x) > objectiveSpacingList[1]):
                #Ensures bosses spawn with head room
                if objectiveTypeList.last() != ObjectiveType.BOSSES or isInLoS(missionCandidatePosition + vect(0, 0, 0), missionCandidatePosition + 10 * Vector.UP):
                    objectivePositionList.append(missionCandidatePosition)
                    currentObjectivePosition = objectivePositionList[0]
                    missionPlacementAttemptCount = 0
            missionPlacementAttemptCount++
            #If Too many attempts
            if missionPlacementAttemptCount > 50:
                del objectivePositionList[len(objectivePositionList) - 1]
                currentObjectivePosition = objectivePositionList[0]
                del objectivePositionList[len(objectivePositionList) - 1]
                currentObjectivePosition = objectivePositionList[0]
                missionPlacementAttemptCount = 0
    #Last objective must be extraction objective
    objectiveTypeList[len(objectiveTypeList) - 1] = ObjectiveType.SHOWDOWN
    currentObjectiveType = objectiveTypeList[0]
    objectivesManagement()
    isGameplayActive = true
