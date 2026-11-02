#!mainFile "main.opy"

subroutine randomActions


rule "PLAYER MENU INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition startMenuSpacingAngle != 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    eventPlayer.enhancementId = Enhancement.NO_PREFERENCE
    if isVoting:
        #Slots 0-1 are unused; pregameState/isVoting hold the status. Votes remain in slots 2-4.
        eventPlayer.pregameVoteList = [0, 0, 0, 0]
        eventPlayer.pregameState = PregameState.SELECTING_HERO
        eventPlayer.isPregameVoting = false
    else:
        #Slots 0-1 are unused; pregameState/isVoting hold the status. Votes remain in slots 2-4.
        eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] = difficultySetting
        eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = zombieSetting
        eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = objectiveTypeSetting
    eventPlayer.pregamePosition = startCamPos + vect(0, -1.5, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + startMenuSpacingAngle + (eventPlayer.getSlot() * (startMenuSpacingAngle * -2 / (max(getNumberOfSlots(Team.1) - 1, 1)))), 0)) * START_CAM_DISTANCE)
    if not isSpecialGameMode:
        eventPlayer.pregamePosition = raycastHitPosition(eventPlayer.pregamePosition + vect(0, 3, 0), eventPlayer.pregamePosition, getAllPlayers(), getAllPlayers(), false)
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
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), Effect.LIGHT_SHAFT, Color.SKY_BLUE, eventPlayer.pregamePosition + vect(0, -10, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #In world hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), heroIcon(eventPlayer.getHero()) if eventPlayer.pregameState == PregameState.HERO_SELECTED else "?", eventPlayer.pregamePosition + offsetUpHalfConst, 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Selecting hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY and eventPlayer.isPregameVoting == false), "SELECTING HERO..." if eventPlayer.pregameState < PregameState.HERO_SELECTED else "Getting Ready...", eventPlayer.pregamePosition + vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    #Voting text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.isPregameVoting == true), "Voting...", eventPlayer.pregamePosition + (vect(0, 1.5 if eventPlayer.pregameState < PregameState.READY else -1, 0)), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE)
    #Name text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.pregameState < PregameState.READY), eventPlayer, eventPlayer.pregamePosition + vect(0, -1, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    #Enhancement icon
    createInWorldText(getAllPlayers(), enhancementOptionList[eventPlayer.enhancementId], eventPlayer.pregamePosition + vect(0, 2.25, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)


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
    eventPlayer.startCamera(startCamPos, startPos + vect(0, 1, 0))
    eventPlayer.startHealingOverTime(null, 5, 1000)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 99999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    #If current game mode is team deathmatch
    if isSpecialGameMode:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.pregamePosition, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
    else:
        eventPlayer.teleport(eventPlayer.pregamePosition)
    wait()
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
        if isVoting and (eventPlayer.pregameVoteList.slice(PlayerMenuStatusField.CHALLENGE_VOTE, 3).all(lambda x: x == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE)) or not isVoting and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
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
                startRule(randomActions)
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
                eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
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
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] + 1) % len(challengeVoteList)
        while not challengeVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] + 1) % len(challengeVoteList)
    else:
        eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] + len(challengeVoteList) - 1) % len(challengeVoteList)
        while not challengeVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.CHALLENGE_VOTE] + len(challengeVoteList) - 1) % len(challengeVoteList)


rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #Update player voting status
    eventPlayer.isPregameVoting = true
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] + 1) % len(zombieVoteList)
        while not zombieVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] + 1) % len(zombieVoteList)
    else:
        eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] + len(zombieVoteList) - 1) % len(zombieVoteList)
        while not zombieVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.ZOMBIE_MODE_VOTE] + len(zombieVoteList) - 1) % len(zombieVoteList)


rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #Update player voting status
    eventPlayer.isPregameVoting = true
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] + 1) % len(objectiveTypeVoteList)
        while not objectiveTypeVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] + 1) % len(objectiveTypeVoteList)
    else:
        eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] + len(objectiveTypeVoteList) - 1) % len(objectiveTypeVoteList)
        while not objectiveTypeVoteList[eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE]][1]:
            eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] = (eventPlayer.pregameVoteList[PlayerMenuStatusField.OBJECTIVE_TYPE_VOTE] + len(objectiveTypeVoteList) - 1) % len(objectiveTypeVoteList)


rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementId = (eventPlayer.enhancementId + 1) % len(enhancementOptionList)
        while not enhancementOptionList[eventPlayer.enhancementId]:
            eventPlayer.enhancementId = (eventPlayer.enhancementId + 1) % len(enhancementOptionList)
    else:
        eventPlayer.enhancementId = (eventPlayer.enhancementId + len(enhancementOptionList) - 1) % len(enhancementOptionList)
        while not enhancementOptionList[eventPlayer.enhancementId]:
            eventPlayer.enhancementId = (eventPlayer.enhancementId + len(enhancementOptionList) - 1) % len(enhancementOptionList)


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
    @Condition distance(eventPlayer.getPosition(), vect(eventPlayer.pregamePosition.x, eventPlayer.getPosition().y, eventPlayer.pregamePosition.z)) > 0.6
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    if not isSpecialGameMode:
        eventPlayer.teleport(eventPlayer.pregamePosition)
    else:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.pregamePosition, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
    if ruleCondition:
        loop()


def randomActions():
    @Name "randomActions"
    
    # tmp0: random emote direction 1-4, to choose one communication before the next wait.
    tmp0 = random.randint(1, 4)
    #Random emote
    if tmp0 <= 1:
        eventPlayer.communicate(Comms.EMOTE_UP)
    elif tmp0 <= 2:
        eventPlayer.communicate(Comms.EMOTE_DOWN)
    elif tmp0 <= 3:
        eventPlayer.communicate(Comms.EMOTE_LEFT)
    else:
        eventPlayer.communicate(Comms.EMOTE_RIGHT)
    wait(1)
    # tmp0: random voice-line direction 1-4, to choose one communication before the next wait.
    tmp0 = random.randint(1, 4)
    #Random voice line
    if tmp0 <= 1:
        eventPlayer.communicate(Comms.VOICE_LINE_UP)
    elif tmp0 <= 2:
        eventPlayer.communicate(Comms.VOICE_LINE_DOWN)
    elif tmp0 <= 3:
        eventPlayer.communicate(Comms.VOICE_LINE_LEFT)
    else:
        eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)
