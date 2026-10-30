#!mainFile "main.opy"

subroutine bossReturn 18


rule "============================================== OBJECTIVE TYPE: BOSSES ==================================================":
    @Disabled
    @Delimiter


rule "SPAWN BOSS":
    @Condition objectiveTypes[0] == 2
    @Condition objectiveComplete == false
    @Condition len(bosses.filter(lambda x: entityExists(x))) == 0
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.hasSpawned() and not player.teleporting and player.botTarget == null)) == true
    #Keeps amount of different bots within the max limit.
    @Condition len(botHeros.filter(lambda x: getNumberOfHeroes(x, Team.2) > 0)) < (uniqueSkinCap - (getNumberOfSlots(Team.1) if getNumberOfPlayers(Team.1) <= getNumberOfSlots(Team.1) else getNumberOfPlayers(Team.1)))
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bosses[0] = (getLivingPlayers(Team.2).filter(lambda player: player.hasSpawned() and not miniBoss[player] and not player.teleporting and player.botTarget == null))[0]
    bosses.teleport(vect(500, 500, 500))
    waitUntil(bosses[0].initializing, 3)
    waitUntil(not bosses[0].initializing, 5)
    bosses.teleport(objectivePositions[0])
    while bosses.any(lambda x: x.isDead()):
        bosses.resurrect()
        waitUntil(bosses[0].isAlive(), 0.25)
    if not entityExists(bosses[0]):
        loop()
    if ruleCondition:
        loop()


rule "BOT BECOMES BOSS":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition objectiveComplete == false
    @Condition eventPlayer in bosses == true
    
    miniBoss.remove(eventPlayer)
    if eventPlayer.attached:
        eventPlayer.attached = false
        eventPlayer.detach()
    eventPlayer.setInvisibility(Invis.NONE)
    if len(availableBosses) == 0:
        if zombieSetting == 4:
            availableBosses = botHeros
        else:
            availableBosses = botHeros.filter(lambda _, i: botSpawnRates[i] > 0)
        if len(availableBosses) > len(nonBossZombies):
            availableBosses.remove(nonBossZombies)
    eventPlayer.disableNameplatesFor(getAllPlayers())
    eventPlayer.stopForcingName()
    eventPlayer.startForcingHero(random.choice(availableBosses))
    #Force a specific boss (FOR TESTING)
    #eventPlayer.startForcingHero(Hero.MERCY)
    botRespawnInitialization()
    #Remove Current Boss Hero From Available Boss List
    availableBosses.remove(eventPlayer.getHero())
    #Boss throttle speed
    eventPlayer.botThrottleSpeed = 0.9 if eventPlayer.getHero() == Hero.REINHARDT else 0.65
    #Health pool size as boss
    eventPlayer.health = 15000
    eventPlayer.bossHealth = eventPlayer.health
    eventPlayer.size = createWorkshopSettingFloat("Zombies", "Boss Size", 2.5, 0, 20)
    eventPlayer.startScalingSize(eventPlayer.size + 1 if eventPlayer.getHero() == Hero.EMRE else eventPlayer.size, false)
    #Scale zombie voice lines with size
    eventPlayer.startModifyingVoicelinePitch(0.5 + (1 / (eventPlayer.size + 1)), false)
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.potentialTargets = []
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setKnockbackReceived(50)
    eventPlayer.setHealingReceived(0)
    waitUntil(eventPlayer.isOnGround(), 1)
    bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
    waitUntil(eventPlayer.botTarget == null, 1)
    wait(0.25)
    waitUntil(eventPlayer.botTarget != null or eventPlayer.getHealth() < eventPlayer.health, 9999)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    bosses[1] = distance(eventPlayer.getPosition(), eventPlayer.getEyePosition())
    wait(1)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true


rule "BOSS STUCK":
    @Event eachPlayer
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.canWallPhase == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrouching() == false
    @Condition eventPlayer in bosses == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.getEyePosition()) < bosses[1] - 0.25
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wallCollisionEnabled = false
    eventPlayer.disableEnvironmentCollision(false)
    wait(3)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    if ruleCondition:
        loop()


rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 1000
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bosses == true
    
    eventPlayer.bossHealth = eventPlayer.getHealth() + eventDamage - 1000
    eventPlayer.setHealth(eventPlayer.bossHealth)


rule "BOSS DIES (ALL BOSS OBJECTIVES)":
    @Event playerDied
    @Team 2
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer in bosses == true
    
    if eventWasEnvironment:
        eventPlayer.stopAllDamageOverTime()
        if attacker.getTeam() == getOppositeTeam(eventPlayer.getTeam()):
            eventPlayer.bossHealth = eventDamage - 200
        else:
            eventPlayer.bossHealth = eventDamage
        if eventPlayer.bossHealth > 0:
            while eventPlayer.isDead():
                if eventPlayer.getPosition().y - nearestWalkablePosition(eventPlayer.getPosition()).y < -50:
                    #Teleport boss if they fall very far below the map
                    bossReturn()
                else:
                    #17.532 is acceleration due to gravity constant
                    eventPlayer.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), getClosestPlayer(eventPlayer, Team.1).getPosition())), -75), max(1, sqrt(2 * 17.532 * (eventPlayer.lastTarget.getPosition().y + 3 - eventPlayer.getPosition().y))), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                wait()
                eventPlayer.resurrect()
                waitUntil(eventPlayer.isAlive(), 0.25)
            eventPlayer.setHealth(eventPlayer.bossHealth)
            if eventPlayer.botTarget == null:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            #Illari punishes with ultimate
            if eventPlayer.getHero() == Hero.ILLARI and attacker.getTeam() == Team.1:
                illariUlt()
        else:
            objectiveComplete = true
            bosses[bosses.index(eventPlayer)] = 0
            eventPlayer.reviveTimer = 10
            goto lbl_0
    #Resurrects player if event damage was greater than 1000 and their health still is higher than 0hp.
    elif eventDamage - 1000 > 0:
        eventPlayer.bossHealth = eventDamage - 1000
        eventPlayer.resurrect()
        waitUntil(eventPlayer.isAlive(), 5)
        eventPlayer.setHealth(eventPlayer.bossHealth)
    else:
        objectiveComplete = true
        bosses[bosses.index(eventPlayer)] = 0
        eventPlayer.reviveTimer = 10
        (getPlayersOnHero(Hero.WINSTON, Team.2) if eventPlayer.getHero() == Hero.WINSTON else []).setStatusEffect(null, Status.KNOCKED_DOWN, 12)
        lbl_0:
    wait(0.25, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "BOSS TAKES KNOCKBACK":
    @Event playerReceivedKnockback
    @Team 2
    @Condition objectiveTypes[0] == 2
    @Condition eventPlayer.wallCollisionEnabled == false
    @Condition eventPlayer in bosses == true
    
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true


rule "BOSS TELEPORT TO TARGET IF NOT USED":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in bosses == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) != true
    
    chaseAtRate(eventPlayer.mutationChase, 15, 1)
    waitUntil(eventPlayer.mutationChase >= 14 or eventPlayer.botTarget != null, 99999)
    if eventPlayer.mutationChase >= 14 and eventPlayer.botTarget == null:
        bossReturn()
    stopChasing(eventPlayer.mutationChase)
    eventPlayer.mutationChase = 0
    waitUntil(eventPlayer.botTarget == null, 99999)
    wait(0.16)
    loop()


def bossReturn():
    @Name "bossReturn"
    
    stopChasing(eventPlayer.mutationChase)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.mutationChase = eventPlayer.getEyePosition()
    eventPlayer.specialCooldown = eventPlayer.lastTarget if eventPlayer.lastTarget != null else getClosestPlayer(eventPlayer, Team.1)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer))
    wait(0.1)
    eventPlayer.teleport(Vector.UP + (random.choice(mapGrid.filter(lambda x: isInLoS(x, eventPlayer.averagePlayersPos.getEyePosition()) and distance(x, eventPlayer.specialCooldown.getPosition()) > 5 and distance(x, eventPlayer.specialCooldown) < 20))))
    wait()
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLACK, eventPlayer, 3)
    eventPlayer.mutationChase = 0
    eventPlayer.specialCooldown = null
