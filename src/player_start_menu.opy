#!mainFile "../main.opy"

subroutine advanceMenuChoice

subroutine attachPlayerToPregameAnchor

# Synchronous menu helper contract: caller sets the current index and enabled/icon
# array, then copies the returned index to its own player field. No waits, async
# calls, nested helpers or reevaluated captures may occur while these slots are live.
#!define menuChoiceIndex tmp0
#!define menuChoiceOptions tmp1


rule "PLAYER MENU INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition startMenuSpacingAngle != 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    eventPlayer.enhancementId = Enhancement.NO_PREFERENCE
    eventPlayer.augmentId = Augment.NO_PREFERENCE
    if isVoting:
        # Reset each vote before any menu reader; these slots have distinct gameplay owners.
        eventPlayer.pregameChallengeVote = Challenge.NO_PREFERENCE
        eventPlayer.pregameZombieVote = 0
        eventPlayer.pregameObjectiveVote = 0
        eventPlayer.pregameState = PregameState.SELECTING_HERO
        eventPlayer.isPregameVoting = false
    else:
        # A late menu entrant sees the selected modes; all three votes remain separate fields.
        eventPlayer.pregameChallengeVote = difficultySetting
        eventPlayer.pregameZombieVote = zombieSetting
        eventPlayer.pregameObjectiveVote = objectiveTypeSetting
    eventPlayer.pregamePosition = startCamPos + -1.5 * Vector.UP + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + startMenuSpacingAngle + (eventPlayer.getSlot() * (startMenuSpacingAngle * -2 / (max(getNumberOfSlots(Team.1) - 1, 1)))), 0)) * START_CAM_DISTANCE)
    if not isSpecialGameMode:
        eventPlayer.pregamePosition = raycastHitPosition(eventPlayer.pregamePosition + 3 * Vector.UP, eventPlayer.pregamePosition, getAllPlayers(), getAllPlayers(), false)
    enableDisableAbilities()


rule "EFFECTS/TEXT":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.isPlayerActive == true
    
    if not isSpecialGameMode:
        #Invis start ring
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), Effect.RING, Color.SKY_BLUE, eventPlayer.pregamePosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        #Invis start light shaft
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), Effect.LIGHT_SHAFT, Color.SKY_BLUE, eventPlayer.pregamePosition + -10 * Vector.UP, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #In world hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), heroIcon(eventPlayer.getHero()) if eventPlayer.pregameState == PregameState.HERO_SELECTED else "?", eventPlayer.pregamePosition + offsetUpHalfConst, 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Selecting hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY and eventPlayer.isPregameVoting == false), "SELECTING HERO..." if eventPlayer.pregameState < PregameState.HERO_SELECTED else "Getting Ready...", eventPlayer.pregamePosition + offsetUpOneAndHalfConst, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    #Voting text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.isPregameVoting == true), "Voting...", eventPlayer.pregamePosition + ((1.5 if eventPlayer.pregameState < PregameState.READY else -1) * Vector.UP), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE)
    #Name text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), eventPlayer, eventPlayer.pregamePosition + Vector.DOWN, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    # Enhancement and Augment share one line above the player.
    createInWorldText(getAllPlayers(), f"{ENHANCEMENT_ICONS[eventPlayer.enhancementId]} {AUGMENT_ICONS[eventPlayer.augmentId]}", eventPlayer.pregamePosition + 2.25 * Vector.UP, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)


rule "PLAYER SELECTS/RESELECTS HERO":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition startMenuSpacingAngle != 0
    @Condition eventPlayer.pregameState == PregameState.SELECTING_HERO
    @Condition eventPlayer.hasSpawned() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startRule(setPrematchTimer)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startCamera(startCamPos, startPos + Vector.UP)
    eventPlayer.startHealingOverTime(null, 5, 1000)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, Math.INFINITY)
    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    #If current game mode is team deathmatch
    if isSpecialGameMode:
        attachPlayerToPregameAnchor()
    else:
        eventPlayer.teleport(eventPlayer.pregamePosition)
    wait()
    # Shared menu storage changes owners at START GAME.
    if not isPregameSetup:
        return
    #Set invisiblity status to 0 each time hero is selected/reselected
    eventPlayer.invisibilityCount = 0
    eventPlayer.setFacing(directionTowards(eventPlayer.pregamePosition, vect(startCamPos.x, eventPlayer.pregamePosition.y, startCamPos.z)), Relativity.TO_WORLD)
    wait()
    eventPlayer.pregameState = PregameState.HERO_SELECTED
    wait()
    if not eventPlayer.isPlayerActive:
        smallMessage(eventPlayer, "Use the voting options in the top left corner of your screen to adjust the game settings")
        eventPlayer.isPlayerActive = true
        wait(5, Wait.RESTART_WHEN_TRUE)
        #Force players that have not voted or selected an enhancement to lock in their hero
        if not isPregameSetup:
            return
        if eventPlayer.augmentId == Augment.NO_PREFERENCE and (isVoting and (not eventPlayer.pregameChallengeVote and not eventPlayer.pregameZombieVote and not eventPlayer.pregameObjectiveVote and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE) or not isVoting and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE):
            eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.pregameState > PregameState.SELECTING_HERO
    @Condition (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) == true
    @Condition eventPlayer.hasSpawned() == true
    
    #Player indicates they are ready
    if eventPlayer.isHoldingButton(Button.JUMP):
        if eventPlayer.pregameState < PregameState.READY:
            eventPlayer.pregameState++
            if eventPlayer.pregameState == PregameState.READY:
                startRule(setPrematchTimer)
                eventPlayer.setInvisibility(Invis.NONE)
    #Not ready or change hero
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.setInvisibility(Invis.ALL)
        if eventPlayer.pregameState > PregameState.SELECTING_HERO:
            eventPlayer.pregameState += -1
            startRule(setPrematchTimer)
            if eventPlayer.pregameState == PregameState.SELECTING_HERO:
                #Update player voting status
                eventPlayer.isPregameVoting = false
                excludeCurrentHeroFromSelection()
                waitUntil(not eventPlayer.hasSpawned(), 1)
                wait()
                eventPlayer.setAllowedHeroes(getAllHeroes())


rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #Update player voting status
    eventPlayer.isPregameVoting = true
    # Scratch is consumed by advanceMenuChoice and copied back before any yield.
    menuChoiceIndex = eventPlayer.pregameChallengeVote
    menuChoiceOptions = challengeVoteList.map(lambda option: option[1])
    advanceMenuChoice()
    eventPlayer.pregameChallengeVote = menuChoiceIndex


rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #Update player voting status
    eventPlayer.isPregameVoting = true
    menuChoiceIndex = eventPlayer.pregameZombieVote
    menuChoiceOptions = zombieVoteList.map(lambda option: option[1])
    advanceMenuChoice()
    eventPlayer.pregameZombieVote = menuChoiceIndex


rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #Update player voting status
    eventPlayer.isPregameVoting = true
    menuChoiceIndex = eventPlayer.pregameObjectiveVote
    menuChoiceOptions = objectiveTypeVoteList.map(lambda option: option[1])
    advanceMenuChoice()
    eventPlayer.pregameObjectiveVote = menuChoiceIndex


rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    menuChoiceIndex = eventPlayer.enhancementId
    menuChoiceOptions = enhancementOptionList
    advanceMenuChoice()
    eventPlayer.enhancementId = menuChoiceIndex


rule "UPDATE PREGAME VOTING STATUS":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.isPregameVoting == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    
    startRule(setPrematchTimer)
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.isPregameVoting = false
    startRule(setPrematchTimer)


rule "PREVENT PLAYERS FROM LEAVING START EARLY":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.pregameState > PregameState.SELECTING_HERO
    @Condition distance(eventPlayer, vect(eventPlayer.pregamePosition.x, eventPlayer.getPosition().y, eventPlayer.pregamePosition.z)) > 0.6
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    if not isSpecialGameMode:
        eventPlayer.teleport(eventPlayer.pregamePosition)
    else:
        attachPlayerToPregameAnchor()
    if ruleCondition:
        loop()


def attachPlayerToPregameAnchor():
    @Name "attachPlayerToPregameAnchor"

    eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.pregamePosition, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))


def advanceMenuChoice():
    @Name "advanceMenuChoice"

    while true:
        menuChoiceIndex = (menuChoiceIndex + (len(menuChoiceOptions) - 1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 1)) % len(menuChoiceOptions)
        if menuChoiceOptions[menuChoiceIndex]:
            break
