#!mainFile "../../main.opy"


rule "ASSIGN ZOMBIE TO BECOME EGG":
    @Condition groupedConditions(((((currentObjectiveType == ObjectiveType.ZOMBIE_EGG) and (isObjectiveComplete == false)) and (entityExists(zombieEggStateList[0]) == false)) and (((getLivingPlayers(Team.2).any(lambda player: not player.botIsTeleporting and player.botTarget == null)) == true) and (len(botHeroList.filter(lambda x: getNumberOfHeroes(x, Team.2))) < uniqueSkinCap - max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))))))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    zombieEggStateList[0] = random.choice(getLivingPlayers(Team.2).filter(lambda player: not player.botIsTeleporting and not player.isAttached and player.botTarget == null))
    if ruleCondition:
        loop()


rule "BOT BECOMES ZOMBIE EGG":
    @Event eachPlayer
    @Team 2
    @Condition groupedConditions((((currentObjectiveType == ObjectiveType.ZOMBIE_EGG) and (isObjectiveComplete == false)) and (zombieEggStateList[0] == eventPlayer)))
    
    eventPlayer.teleport(dummyHoldingPositionConst)
    while eventPlayer.isDead():
        eventPlayer.resurrect()
        waitUntil(eventPlayer.isAlive(), 1)
    zombieEggStateList[0].startForcingHero(Hero.WRECKING_BALL)
    botRespawnInitialization()
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.startForcingName("Egg")
    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startForcingPosition(currentObjectivePosition + -2.5 * Vector.UP)
    eventPlayer.startModifyingVoicelinePitch(0.5, false)
    eventPlayer.botBaseHealth = 15000
    eventPlayer.botBossHealth = eventPlayer.botBaseHealth
    eventPlayer.sizeScale = 2.5
    applyCurrentSizeScale()
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    waitUntil(eventPlayer.botIsWallCollisionEnabled == true, 5)
    eventPlayer.botIsWallCollisionEnabled = false
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.setHealingReceived(0)
    while not isObjectiveComplete:
        zombieEggStateList[1] = distance(eventPlayer, eventPlayer.getEyePosition())
        if not eventPlayer.isUsingAbility1() and eventPlayer.isAlive():
            eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.25)
        waitUntil(isObjectiveComplete or not eventPlayer.isUsingAbility1(), Math.INFINITY)


rule "BOTS TELEPORT TO THE EGG":
    @Event eachPlayer
    @Team 2
    @Condition groupedConditions((((((currentObjectiveType == ObjectiveType.ZOMBIE_EGG) and (isObjectiveComplete != true)) and (eventPlayer.botIsInitializing != true)) and ((eventPlayer.botIsTeleporting != true) and (eventPlayer.botIsTeleportConfirmed != true))) and (((eventPlayer.isAlive() == true) and (entityExists(zombieEggStateList[0]) == true)) and ((eventPlayer in zombieEggStateList != true) and (playerTargetList.any(lambda x: distance(currentObjectivePosition, x) < 40) == true)))))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsTeleportConfirmed = true
    eventPlayer.botCustomTeleportPosition = dummyHoldingPositionConst
    eventPlayer.botTeleportPosition = currentObjectivePosition
    eventPlayer.botTeleportCenter = eventPlayer.botTeleportPosition
    eventPlayer.botRespawnDelay = 1
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, currentObjectivePosition, 7)
    eventPlayer.teleport(eventPlayer.botTeleportPosition)


rule "EGG SWITCHES THE POSITION FOR YOU":
    @Event playerDealtDamage
    @Team 1
    @Condition groupedConditions(((currentObjectiveType == ObjectiveType.ZOMBIE_EGG) and (zombieEggStateList[0] == victim)))
    
    objectivePositionList[0] += directionTowards(victim, attacker) / (3.5 if attacker.isOnGround() else 9)
    refreshCurrentObjectivePosition()
    #Small stop for high ticks of damage
    wait(0.049)
