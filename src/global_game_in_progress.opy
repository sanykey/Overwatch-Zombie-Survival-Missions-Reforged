#!mainFile "main.opy"


rule "EFFECTS/TEXTS":
    @Condition isGameInProgress() == true
    @Condition isPregameSetup != true
    
    wait(1)
    #Objective description and match timer
    hudSubtext(getAllPlayers(), "{0}{1}".format(objectiveDescription, (" | {0}".format("{0}s".format(getMatchTime()) if getMatchTime() <= 60 else "{0}:{2}{1}".format(floor(getMatchTime() / 60), floor(getMatchTime() % 60), 0 if floor(getMatchTime() % 60) < 10 else []))) if getMatchTime() > 0 + matchEndTime else []), HudPosition.TOP, -1, rgb(215, 215, 215), HudReeval.VISIBILITY_AND_STRING)
    #Infected Hud
    hudHeader(getAllPlayers().filter(lambda player: ((player.enhancementId != Enhancement.ZOMBIE_HYBRID and (healthpackPositionList == [] or player.getHealth() < floor(player.infectionLevel) ** 2 * 20)) and player.isInfected) and getMatchTime() > matchEndTime), "{0} Find a healthpack {0}".format(iconString(Icon.PLUS)), HudPosition.RIGHT, 0, (Color.RED if localPlayer.getHealth() < floor(localPlayer.infectionLevel) ** 2 * 10 else Color.LIME_GREEN) if ceil(getTotalTimeElapsed() * 2) % 2 == 0 else Color.WHITE, HudReeval.VISIBILITY_AND_COLOR)
    #Nearest Healthpack Distance
    createInWorldText(getPlayers(Team.1).filter(lambda player: player.enhancementId != Enhancement.ZOMBIE_HYBRID and healthpackPositionList != [] and player.isInfected and getMatchTime() > matchEndTime), "Cure: {0}m".format(distance(localPlayer, sorted(healthpackPositionList, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0])), sorted(healthpackPositionList, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN, SpecVisibility.NEVER)
    #Nearest health pack icon
    createIcon(getPlayers(Team.1).filter(lambda player: player.enhancementId != Enhancement.ZOMBIE_HYBRID and healthpackPositionList != [] and player.isInfected and getMatchTime() > matchEndTime), sorted(healthpackPositionList, lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x)))[0] + offsetUpThreeQuartersConst + offsetUpHalfConst, Icon.POISON, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN)
    hudSubtext(getAllPlayers(), "Modified version. workshop.codes/786tw", HudPosition.RIGHT, 0.1, Color.TEAM_1, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers().filter(lambda _: challengeSetting >= 2), "Challenge round!", HudPosition.RIGHT, 0.2, Color.TEAM_1, HudReeval.VISIBILITY_AND_STRING)


rule "ATTACK SPAWN ROOM CONTROL":
    @Condition isPregameSetup != true
    #Does not apply if game mode is special mode
    @Condition isSpecialGameMode != true
    @Condition playerTargetList.any(lambda x: distance(x, activeAttackSpawnRoom) < 45) == true
    
    spawnRoomIndex = (spawnRoomIndex + 1) % len(attackSpawnRooms)
    #Make sure players are clear of test spawn room before activating
    if getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x, attackSpawnRooms[spawnRoomIndex]) > 45):
        activeAttackSpawnRoom = attackSpawnRooms[spawnRoomIndex]
        startForcingSpawn(Team.2, spawnRoomIndex)
    wait(1)
    if ruleCondition:
        loop()


rule "PREVENT MATCH TIME FROM UNPAUSING":
    @Condition isGameplayActive == true
    @Condition getMatchTime() < matchEndTime
    
    pauseMatchTime()
    setMatchTime(matchEndTime)
    wait()
    if ruleCondition:
        loop()


rule "TRIGGER OVERTIME MUSIC":
    @Condition isGameplayActive == true
    @Condition isOvertimeActive == false
    @Condition getMatchTime() < matchEndTime + 3
    @Condition getLivingPlayers(Team.2).any(lambda player: player.botTarget == null and not player in bossStateList)
    
    enableMusic()
    if not isSpecialGameMode:
        isOvertimeActive = true
        ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bossStateList))[0]).teleport(getPayloadPosition() if getCurrentGamemode() == Gamemode.ESCORT else getObjectivePosition(0))


rule "ZOMBIE SHUFFLE":
    @Condition isGameplayActive == true
    @Condition zombieSetting == 4
    
    #Bot respawn probablities
    botSpawnRateList = random.shuffle(botSpawnRateList)
    bigMessage(getAllPlayers(), "The spawn rates have been shuffled!")
    #1 min 30 sec wait
    wait(90)
    if ruleCondition:
        loop()


rule "SWARM SHOOTOUT":
    @Event eachPlayer
    @Team 2
    @Condition (challengeSetting in [2, 5]) == true
    
    startDamageModification(getPlayers(Team.1), eventPlayer, 72)
    waitUntil(eventPlayer.botTarget != false, 99999)
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:
    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "RANDOM ABILITIES":
    @Event eachPlayer
    @Team 2
    @Condition (challengeSetting in [3, 5] or isSmolderEventActive) == true
    @Condition eventPlayer in bossStateList != true
    @Condition isPregameSetup == false
    
    wait(random.uniform(2, 8))
    if eventPlayer.getHero() in [Hero.MERCY]:
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
    else:
        eventPlayer.forceButtonPress(random.choice([Button.ABILITY_2, Button.ABILITY_1]))
        if eventPlayer.getHero() in [Hero.SYMMETRA] and eventPlayer.isUsingAbility2():
            abilityPlacement()
        elif eventPlayer.getHero() == Hero.JUNKRAT and eventPlayer.isUsingAbility1() or eventPlayer.getHero() == Hero.MOIRA and eventPlayer.isUsingAbility2():
            wait(1)
            eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        if ruleCondition:
            loop()


rule "PLAYER LEAVES THE GAME":
    @Event playerLeft
    @Condition (playerTargetList.any(lambda x: not entityExists(x)) or objectivePlayerList.any(lambda x: not entityExists(x))) == true
    
    playerTargetList = playerTargetList.filter(lambda x: entityExists(x))
    objectivePlayerList = objectivePlayerList.filter(lambda x: entityExists(x))
    wait(1, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()
    startRule(setDifficulty)


rule "OBJECTIVE COMPLETE":
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == true
    
    startRule(objectivesManagement)
    (getDeadPlayers(Team.1).filter(lambda player: player.rescueTimeRemaining < 50)).rescueTimeRemaining += 10
