#!mainFile "main.opy"


rule "ASSIGN ZOMBIE TO BECOME EGG":
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete == false
    @Condition entityExists(bosses[0]) == false
    @Condition (getLivingPlayers(Team.2).any(lambda player: not player.teleporting and player.botTarget == null)) == true
    @Condition len(botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)) < uniqueSkinCap - max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bosses[0] = random.choice(getLivingPlayers(Team.2).filter(lambda player: not player.teleporting and not player.attached and player.botTarget == null))
    if ruleCondition:
        loop()


rule "BOT BECOMES ZOMBIE EGG":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete == false
    @Condition bosses[0] == eventPlayer
    
    eventPlayer.teleport(vect(500, 500, 500))
    while eventPlayer.isDead():
        eventPlayer.resurrect()
        waitUntil(eventPlayer.isAlive(), 1)
    bosses[0].startForcingHero(Hero.WRECKING_BALL)
    botRespawnInitialization()
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.startForcingName("Egg")
    eventPlayer.specialThrottling = true
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.startForcingPosition(objectivePositions[0] + vect(0, -2.5, 0))
    eventPlayer.startModifyingVoicelinePitch(0.5, false)
    eventPlayer.health = 15000
    eventPlayer.bossHealth = eventPlayer.health
    eventPlayer.size = 2.5
    eventPlayer.startScalingSize(eventPlayer.size, false)
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    waitUntil(eventPlayer.wallCollisionEnabled == true, 5)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.setHealingReceived(0)
    while not objectiveComplete:
        bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
        if not eventPlayer.isUsingAbility1() and eventPlayer.isAlive():
            eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.25)
        waitUntil(objectiveComplete or not eventPlayer.isUsingAbility1(), 99999)


rule "BOTS TELEPORT TO THE EGG":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 6
    @Condition objectiveComplete != true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.successfullyTeleported != true
    @Condition eventPlayer.isAlive() == true
    @Condition entityExists(bosses[0]) == true
    @Condition eventPlayer in bosses != true
    @Condition playerTargetList.any(lambda x: distance(objectivePositions[0], x.getPosition()) < 40) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.successfullyTeleported = true
    eventPlayer.customTelePos = vect(500, 500, 500)
    eventPlayer.telePos = objectivePositions[0]
    eventPlayer.averagePlayersPos = eventPlayer.telePos
    eventPlayer.reviveTimer = 1
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], 7)
    eventPlayer.teleport(eventPlayer.telePos)


rule "EGG SWITCHES THE POSITION FOR YOU":
    @Event playerDealtDamage
    @Team 1
    @Condition objectiveTypes[0] == 6
    @Condition bosses[0] == victim
    
    objectivePositions[0] += directionTowards(victim, attacker) / (3.5 if attacker.isOnGround() else 9)
    #Small stop for high ticks of damage
    wait(0.049)
