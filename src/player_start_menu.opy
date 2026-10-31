#!mainFile "main.opy"

subroutine randomActions


rule "PLAYER MENU INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition startMenuSpacingAngle != 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    eventPlayer.enhancementId = Enhancement.NO_PREFERENCE
    if voting:
        #Slots 0-1 are unused; menuStage/menuVoting hold the status. Votes remain in slots 2-4.
        eventPlayer.playerMenuStatus = [0, 0, 0, 0]
        eventPlayer.menuStage = 0
        eventPlayer.menuVoting = 0
    else:
        #Slots 0-1 are unused; menuStage/menuVoting hold the status. Votes remain in slots 2-4.
        eventPlayer.playerMenuStatus[2] = difficultySetting
        eventPlayer.playerMenuStatus[3] = zombieSetting
        eventPlayer.playerMenuStatus[4] = objectiveTypeSetting
    eventPlayer.startPos = startCamPos + vect(0, -1.5, 0) + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + startMenuSpacingAngle + (eventPlayer.getSlot() * (startMenuSpacingAngle * -2 / (max(getNumberOfSlots(Team.1) - 1, 1)))), 0)) * startCamDistance)
    if not specialGameMode:
        eventPlayer.startPos = raycastHitPosition(eventPlayer.startPos + vect(0, 3, 0), eventPlayer.startPos, getAllPlayers(), getAllPlayers(), false)
    enableDisableAbilities()


rule "EFFECTS/TEXT":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.playerActiveStatus == true
    
    if not specialGameMode:
        #Invis start ring
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.menuStage < 2), Effect.RING, Color.SKY_BLUE, eventPlayer.startPos, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        #Invis start light shaft
        createEffect(getAllPlayers().filter(lambda _: eventPlayer.menuStage < 2), Effect.LIGHT_SHAFT, Color.SKY_BLUE, eventPlayer.startPos + vect(0, -10, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #In world hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.menuStage < 2), heroIcon(eventPlayer.getHero()) if eventPlayer.menuStage == 1 else "?", eventPlayer.startPos + offsetUpHalfConst, 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Selecting hero text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.menuStage < 2 and eventPlayer.menuVoting == 0), "SELECTING HERO..." if eventPlayer.menuStage < 1 else "Getting Ready...", eventPlayer.startPos + vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
    #Voting text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.menuVoting == 1), "Voting...", eventPlayer.startPos + (vect(0, 1.5 if eventPlayer.menuStage < 2 else -1, 0)), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE)
    #Name text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.menuStage < 2), eventPlayer, eventPlayer.startPos + vect(0, -1, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA)
    #Enhancement icon
    createInWorldText(getAllPlayers(), enhancementOptions[eventPlayer.enhancementId], eventPlayer.startPos + vect(0, 2.25, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)


rule "PLAYER SELECTS/RESELECTS HERO":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition startMenuSpacingAngle != 0
    @Condition eventPlayer.menuStage == 0
    @Condition eventPlayer.hasSpawned() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startRule(setPrematchTimer)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startCamera(startCamPos, startPos + vect(0, 1, 0))
    eventPlayer.startHealingOverTime(null, 5, 1000)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 99999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    #If current game mode is team deathmatch
    if specialGameMode:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.startPos, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
    else:
        eventPlayer.teleport(eventPlayer.startPos)
    wait()
    #Set invisiblity status to 0 each time hero is selected/reselected
    eventPlayer.invisible = 0
    eventPlayer.setFacing(directionTowards(eventPlayer.startPos, vect(startCamPos.x, eventPlayer.startPos.y, startCamPos.z)), Relativity.TO_WORLD)
    wait()
    eventPlayer.menuStage = 1
    wait()
    if not eventPlayer.playerActiveStatus:
        smallMessage(eventPlayer, "Use the voting options in the top left corner of your screen to adjust the game settings")
        eventPlayer.playerActiveStatus = true
        wait(5, Wait.RESTART_WHEN_TRUE)
        #Force players that have not voted or selected an enhancement to lock in their hero
        if voting and (eventPlayer.playerMenuStatus.slice(2, 3).all(lambda x: x == 0 and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE)) or not voting and eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
            eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.menuStage > 0
    @Condition (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) == true
    @Condition eventPlayer.hasSpawned() == true
    
    #Player indicates they are ready
    if eventPlayer.isHoldingButton(Button.JUMP):
        if eventPlayer.menuStage < 2:
            eventPlayer.menuStage++
            if eventPlayer.menuStage == 2:
                startRule(setPrematchTimer)
                startRule(randomActions)
                eventPlayer.setInvisibility(Invis.NONE)
    #Not ready or change hero
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.setInvisibility(Invis.ALL)
        if eventPlayer.menuStage > 0:
            eventPlayer.menuStage += -1
            startRule(setPrematchTimer)
            if eventPlayer.menuStage == 0:
                #Update player voting status
                eventPlayer.menuVoting = 0
                eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
                waitUntil(not eventPlayer.hasSpawned(), 1)
                wait()
                eventPlayer.setAllowedHeroes(getAllHeroes())


rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #Update player voting status
    eventPlayer.menuVoting = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.playerMenuStatus[2] = (eventPlayer.playerMenuStatus[2] + 1) % len(challengeVotes)
        while not challengeVotes[eventPlayer.playerMenuStatus[2]][1]:
            eventPlayer.playerMenuStatus[2] = (eventPlayer.playerMenuStatus[2] + 1) % len(challengeVotes)
    else:
        eventPlayer.playerMenuStatus[2] = (eventPlayer.playerMenuStatus[2] + len(challengeVotes) - 1) % len(challengeVotes)
        while not challengeVotes[eventPlayer.playerMenuStatus[2]][1]:
            eventPlayer.playerMenuStatus[2] = (eventPlayer.playerMenuStatus[2] + len(challengeVotes) - 1) % len(challengeVotes)


rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #Update player voting status
    eventPlayer.menuVoting = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.playerMenuStatus[3] = (eventPlayer.playerMenuStatus[3] + 1) % len(zombieVotes)
        while not zombieVotes[eventPlayer.playerMenuStatus[3]][1]:
            eventPlayer.playerMenuStatus[3] = (eventPlayer.playerMenuStatus[3] + 1) % len(zombieVotes)
    else:
        eventPlayer.playerMenuStatus[3] = (eventPlayer.playerMenuStatus[3] + len(zombieVotes) - 1) % len(zombieVotes)
        while not zombieVotes[eventPlayer.playerMenuStatus[3]][1]:
            eventPlayer.playerMenuStatus[3] = (eventPlayer.playerMenuStatus[3] + len(zombieVotes) - 1) % len(zombieVotes)


rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)":
    @Event eachPlayer
    @Team 1
    @Condition voting == true
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #Update player voting status
    eventPlayer.menuVoting = 1
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.playerMenuStatus[4] = (eventPlayer.playerMenuStatus[4] + 1) % len(objectiveTypeVotes)
        while not objectiveTypeVotes[eventPlayer.playerMenuStatus[4]][1]:
            eventPlayer.playerMenuStatus[4] = (eventPlayer.playerMenuStatus[4] + 1) % len(objectiveTypeVotes)
    else:
        eventPlayer.playerMenuStatus[4] = (eventPlayer.playerMenuStatus[4] + len(objectiveTypeVotes) - 1) % len(objectiveTypeVotes)
        while not objectiveTypeVotes[eventPlayer.playerMenuStatus[4]][1]:
            eventPlayer.playerMenuStatus[4] = (eventPlayer.playerMenuStatus[4] + len(objectiveTypeVotes) - 1) % len(objectiveTypeVotes)


rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementId = (eventPlayer.enhancementId + 1) % len(enhancementOptions)
        while not enhancementOptions[eventPlayer.enhancementId]:
            eventPlayer.enhancementId = (eventPlayer.enhancementId + 1) % len(enhancementOptions)
    else:
        eventPlayer.enhancementId = (eventPlayer.enhancementId + len(enhancementOptions) - 1) % len(enhancementOptions)
        while not enhancementOptions[eventPlayer.enhancementId]:
            eventPlayer.enhancementId = (eventPlayer.enhancementId + len(enhancementOptions) - 1) % len(enhancementOptions)


rule "UPDATE PREGAME VOTING STATUS":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.menuVoting == 1
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    
    startRule(setPrematchTimer)
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.menuVoting = 0
    startRule(setPrematchTimer)


rule "PREVENT PLAYERS FROM LEAVING START EARLY":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.menuStage > 0
    @Condition distance(eventPlayer.getPosition(), vect(eventPlayer.startPos.x, eventPlayer.getPosition().y, eventPlayer.startPos.z)) > 0.6
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    if not specialGameMode:
        eventPlayer.teleport(eventPlayer.startPos)
    else:
        eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.startPos, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))
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
    elif tmp0 <= 4:
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
    elif tmp0 <= 4:
        eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)
