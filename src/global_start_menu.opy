#!mainFile "main.opy"

subroutine determineChallenge
subroutine determineZombieMode
subroutine setZombieMode
subroutine determineObjectiveType
subroutine setObjectiveType
subroutine selectVoteWinner

rule "GLOBAL MENU INITIALIZATION":
    @Condition isPregameSetup == true
    @Condition mapGridList != []
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if isSpecialGameMode:
        # These values are consumed before the next wait; mode selection keeps the original three positions.
        #!define menuRadius tmp1
        #!define menuHeight tmp2
        if getCurrentGamemode() in [Gamemode.CTF, Gamemode.PUSH]:
            menuRadius = 300
            menuHeight = 15
        elif getCurrentGamemode() == Gamemode.CONTROL:
            menuRadius = 300
            menuHeight = 100
        else:
            menuRadius = 150
            menuHeight = 30
        startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * menuRadius + menuHeight * Vector.UP
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
                # Both sight checks use the same point in this iteration, before any wait.
                #!define menuVisibilityPoint tmp1
                menuVisibilityPoint = startCamPos + -0.75 * Vector.UP + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + menuVisibilityAngleOffset, 0)) * START_CAM_DISTANCE)
                if not isInLoS(startCamPos, menuVisibilityPoint) or not isInLoS(menuVisibilityPoint, startCamPos):
                    startPos = null
                    break
            wait()
            # Shared menu storage changes owners at START GAME.
            if not isPregameSetup:
                return
    lbl_0:
    # Scene setup can resume after START GAME; the angle slot then belongs to the objective type cache.
    if isPregameSetup:
        startMenuSpacingAngle = 40
    #Start screen objective description
    setObjectiveDescription(getAllPlayers(), "Voting ends in {0}s".format(ceil(getMatchTime() - VOTING_END_TIME)) if isVoting else "Select your hero", HudReeval.VISIBILITY_AND_STRING)


rule "EFFECTS/TEXTS":
    #Pre game objective description and match timer
    hudSubtext(getAllPlayers(), "{0} | {1}s".format("Voting will end in {0}s".format(ceil(getMatchTime() - VOTING_END_TIME)) if isVoting else "Select your hero", ceil(getMatchTime())), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "Original Game Code: MPJFR" if not (ceil(getTotalTimeElapsed() * 0.2) % 2) else "Game Mode Creator: Mazattack#1183", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #Creator/Game Code Promo
    hudSubtext(getAllPlayers(), "This is a modified version: 786TW" if not (ceil(getTotalTimeElapsed() * 0.2) % 2) else "Modified by: KamenRider#11346", HudPosition.RIGHT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
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
    #Team 1 vote IDs are initialized to valid menu entries before players use the menu.
    #Challenge
    hudText(
        getPlayers(Team.1),
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
        getPlayers(Team.1),
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
        getPlayers(Team.1),
        [
            "Objective Type: No Preference",
            "Objective Type: Showdown {0}".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)),
            "Objective Type: Bosses {0}".format(iconString(Icon.WARNING)),
            null,
            null,
            "Objective Type: Kill Zone {0}".format(iconString(Icon.RING_THICK) if not (ceil(getTotalTimeElapsed() * 1.25) % 2) else iconString(Icon.RING_THIN)),
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
        getPlayers(Team.1),
        "Enhancement: {0}{1}".format(
            [
                "No Preference", "Kevlar ", "Zombie Hybrid ", "Laser Barricade ",
                "Brain Killer ", "Pyrotechnic ", "Plague Doctor ", "Born to Battle ",
                "Charge Battery ", "Hitchhiker ", "P.U.P. "
            ][localPlayer.enhancementId],
            enhancementOptionList[localPlayer.enhancementId] if localPlayer.enhancementId > Enhancement.NO_PREFERENCE else ""
        ),
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
    
    pregameGlitchText = ["alglChene oteV: KaMeNrldEr", "You won't win", "Don't even try it"][random.randint(1, 3) - 1]
    isPregameGlitchActive = true
    wait(random.uniform(0.063, 0.325), Wait.ABORT_WHEN_FALSE)
    isPregameGlitchActive = false
    wait(random.uniform(0.325, 1.5), Wait.ABORT_WHEN_FALSE)
    loop()


rule "END VOTING":
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition getMatchTime() < VOTING_END_TIME
    @Condition getPlayers(Team.1).any(lambda player: player.pregameState > PregameState.SELECTING_HERO)
    
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


# Synchronous helper inputs/result; consume them before any wait or asynchronous startRule.
#!define voteWinnerCounts tmp1
#!define voteWinnerResult tmp2
#!define voteWinnerIndex tmp0

def determineZombieMode():
    @Name "determineZombieMode"
    
    zombieSetting = 0
    # zombieModeVoteIndex: zombie-mode vote index, to count active players voting for each enabled mode.
    #!define zombieModeVoteIndex tmp0
    for zombieModeVoteIndex in range(1, len(zombieVoteList)):
        zombieVoteList[zombieModeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameZombieVote == zombieModeVoteIndex)) if zombieVoteList[zombieModeVoteIndex][1] else -1
    voteWinnerCounts = zombieVoteList
    voteWinnerResult = zombieSetting
    selectVoteWinner()
    zombieSetting = voteWinnerResult
    #If all players choose no preference, randomize
    if not zombieSetting:
        zombieSetting = 1
    startRule(determineChallenge)
    startRule(setZombieMode)


def setZombieMode():
    @Name "setZombieMode"
    
    #Bot available hero list
    botHeroList = [Hero.REAPER, Hero.JUNKRAT, Hero.TORBJORN, Hero.ROADHOG, Hero.REINHARDT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.MAUGA, Hero.MERCY, Hero.WRECKING_BALL, Hero.MOIRA, Hero.PHARAH, Hero.SIGMA, Hero.JUNKER_QUEEN, Hero.ILLARI, Hero.HAZARD, Hero.SYMMETRA, Hero.ANA, Hero.WINSTON, Hero.DOOMFIST, Hero.KIRIKO]
    #Zombie types without a boss variation
    bossesExcludedHeroList = [Hero.JUNKRAT, Hero.ANRAN, Hero.WIDOWMAKER, Hero.JUNKER_QUEEN, Hero.SYMMETRA, Hero.ANA, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.SIGMA, Hero.WRECKING_BALL]
    #What'll it be?
    if zombieSetting == 3:
        #Bot respawn probablities
        botSpawnRateList = []
        # equalSpawnWeightHeroIndex: hero-entry counter, to append 19 equal spawn weights for this zombie mode.
        #!define equalSpawnWeightHeroIndex tmp0
        for equalSpawnWeightHeroIndex in range(19):
            botSpawnRateList.append(5.263)
    elif zombieSetting in [1, 2, 4, 5, 6]:
        # Mode 3 has no compressed table. Other mode offsets and lengths retain their original order.
        botSpawnRateList = numbersList.slice([NL_SPAWN_RATES_ALL_ZOMBIES_OFFSET, NL_SPAWN_RATES_NEW_BLOOD_OFFSET, 0, NL_SPAWN_RATES_SHUFFLE_OFFSET, NL_SPAWN_RATES_DINNER_RUSH_OFFSET, NL_SPAWN_RATES_HAM_N_HAMMER_OFFSET][zombieSetting - 1], [NL_SPAWN_RATES_ALL_ZOMBIES_LEN, NL_SPAWN_RATES_NEW_BLOOD_LEN, 0, NL_SPAWN_RATES_SHUFFLE_LEN, NL_SPAWN_RATES_DINNER_RUSH_LEN, NL_SPAWN_RATES_HAM_N_HAMMER_LEN][zombieSetting - 1])


def determineChallenge():
    @Name "determineChallenge"
    
    challengeSetting = 0
    # challengeVoteIndex: challenge vote index, to count active players voting for each enabled difficulty.
    #!define challengeVoteIndex tmp0
    for challengeVoteIndex in range(1, len(challengeVoteList)):
        challengeVoteList[challengeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameChallengeVote == challengeVoteIndex)) if challengeVoteList[challengeVoteIndex][1] else -1
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
    if not challengeSetting:
        challengeSetting = 1
    startRule(determineObjectiveType)


def determineObjectiveType():
    @Name "determineObjectiveType"
    
    objectiveTypeSetting = ObjectiveType.NO_PREFERENCE
    # objectiveTypeVoteIndex: objective-type vote index, to count active players voting for each enabled objective type.
    #!define objectiveTypeVoteIndex tmp0
    for objectiveTypeVoteIndex in range(ObjectiveType.SHOWDOWN, len(objectiveTypeVoteList)):
        objectiveTypeVoteList[objectiveTypeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameObjectiveVote == objectiveTypeVoteIndex)) if objectiveTypeVoteList[objectiveTypeVoteIndex][1] else -1
    voteWinnerCounts = objectiveTypeVoteList
    voteWinnerResult = objectiveTypeSetting
    selectVoteWinner()
    objectiveTypeSetting = voteWinnerResult
    #If all players choose no preference, randomize
    if objectiveTypeSetting == ObjectiveType.NO_PREFERENCE:
        if objectiveTypeVoteList[ObjectiveType.MIXED_OBJECTIVES] != -1:
            objectiveTypeSetting = ObjectiveType.MIXED_OBJECTIVES
        else:
            while objectiveTypeSetting == ObjectiveType.NO_PREFERENCE or objectiveTypeVoteList[objectiveTypeSetting] == -1:
                objectiveTypeSetting = random.randint(ObjectiveType.SHOWDOWN, len(objectiveTypeVoteList) - 1)
    isVoting = false
    startRule(setObjectiveType)


def selectVoteWinner():
    # Synchronous only: no waits, asynchronous work, nested calls or reevaluated readers of tmp0..2.
    # Keep the original traversal and sequential coin flips; a uniform pick among tied options differs.
    # Callers publish the result immediately, then handle their own no-preference defaults.
    for voteWinnerIndex in range(1, len(voteWinnerCounts)):
        if voteWinnerCounts[voteWinnerResult] < voteWinnerCounts[voteWinnerIndex]:
            voteWinnerResult = voteWinnerIndex
        elif voteWinnerCounts[voteWinnerResult] == voteWinnerCounts[voteWinnerIndex]:
            if voteWinnerResult and not random.randint(0, 1):
                voteWinnerResult = voteWinnerIndex


def setObjectiveType():
    @Name "setObjectiveType"
    
    #Wait until game begins
    waitUntil(isGameInProgress() and not isPregameSetup, 99999)
    #Create objective positions
    while len(objectiveTypeList) < createWorkshopSettingInt("General", "Number of Objectives", 5, 0, 100) + 1:
        if objectiveTypeSetting != ObjectiveType.MIXED_OBJECTIVES:
            objectiveTypeList.append(objectiveTypeSetting)
        else:
            #Mixed objective assignment
            objectiveTypeList.append(random.choice(mixedObjectiveTypeList.exclude(objectiveTypeList.filter(lambda _, i: i > len(objectiveTypeList) - 1 - (len(mixedObjectiveTypeList) - 1)))))
        refreshCurrentObjectiveType()
        missionPlacementAttemptCount = 0
        while len(objectivePositionList) < len(objectiveTypeList):
            #Limits possible map grid points to set min and max range from last created objective position
            missionCandidatePosition = random.choice(mapGridList if objectivePositionList == [] else mapGridList.filter(lambda x: distance(x, objectivePositionList.last()) > objectiveSpacingList[0] and distance(x, objectivePositionList.last()) < min(100, objectiveSpacingList[0] * 3)))
            missionCandidatePosition += Vector.UP
            wait()
            #Minimum objective spacing
            if objectivePositionList == [] or objectivePositionList.slice(len(objectivePositionList) - 5, 5).all(lambda x: distance(missionCandidatePosition, x) > objectiveSpacingList[1]):
                #Ensures bosses spawn with head room
                if objectiveTypeList.last() != ObjectiveType.BOSSES or isInLoS(missionCandidatePosition + vect(0, 0, 0), missionCandidatePosition + 10 * Vector.UP):
                    objectivePositionList.append(missionCandidatePosition)
                    refreshCurrentObjectivePosition()
                    missionPlacementAttemptCount = 0
            missionPlacementAttemptCount++
            #If Too many attempts
            if missionPlacementAttemptCount > 50:
                # Preserve both removals and refresh the head after each one.
                #!define missionRollbackIndex tmp0
                for missionRollbackIndex in range(2):
                    del objectivePositionList[len(objectivePositionList) - 1]
                    refreshCurrentObjectivePosition()
                missionPlacementAttemptCount = 0
    #Last objective must be extraction objective
    objectiveTypeList[len(objectiveTypeList) - 1] = ObjectiveType.SHOWDOWN
    refreshCurrentObjectiveType()
    objectivesManagement()
    isGameplayActive = true
