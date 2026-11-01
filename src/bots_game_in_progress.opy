#!mainFile "main.opy"

subroutine enterExitTeleport
subroutine teleportBots
subroutine successfulTeleportStatus
subroutine updateBotSpawnPoints
subroutine locateAveragePlayerLocation


macro botTeleportCenterMacro():
    #Standoff, Extraction, Biomorphing, Zombie Egg
    if CURRENT_OBJECTIVE_TYPE in [ObjectiveType.SHOWDOWN, ObjectiveType.BIOMORPHING, ObjectiveType.ZOMBIE_EGG]:
        eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositionList[0]))[0].getPosition()
    #Boss
    elif CURRENT_OBJECTIVE_TYPE == ObjectiveType.BOSSES:
        eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), bossStateList[0].getPosition()))[0].getPosition()
    #Survivor Rescue
    elif CURRENT_OBJECTIVE_TYPE == ObjectiveType.SURVIVOR_RESCUE:
        if survivorToRescue.botFollowTarget == null:
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), survivorToRescue.getPosition()))[0].getPosition()
        else:
            eventPlayer.averagePlayersPos = survivorToRescue.botFollowTarget.getPosition()
    #Killzone
    elif CURRENT_OBJECTIVE_TYPE == ObjectiveType.KILL_ZONE:
        #If players are in the killzone
        if len(playerTargetList.filter(lambda x: distance(x.getPosition(), objectiveChase1) < objectiveRad)) > 0:
            #Player closeset to the center of the killzone
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectiveChase1))[0].getPosition()
        else:
            #Average player positon
            locateAveragePlayerLocation()
    #Satellite Uplink
    elif CURRENT_OBJECTIVE_TYPE == ObjectiveType.SATELLITE_UPLINK:
        #Checks if any players are currently repairing terminals
        if len(objectivePlayerList) > 0:
            eventPlayer.averagePlayersPos = random.choice(objectivePlayerList).getPosition()
        else:
            #Closest player to sattelite firing position
            eventPlayer.averagePlayersPos = sorted(playerTargetList, lambda x: distance(x.getPosition(), objectivePositionList[0]))[0].getPosition()
    #Default
    else:
        locateAveragePlayerLocation()

rule "Fix bot health":
    @Event eachPlayer
    @Team 2
    @Condition isGameplayActive == true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.getHealth() > eventPlayer.health + 5
    @Condition eventPlayer in bossStateList == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.health)
    if ruleCondition:
        loop()

rule "BOT INITIALIZATION":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition isPregameSetup != true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(null, 99999, 9999)
    eventPlayer.reviveTimer = 0
    if len(customTeleportPositionList) > 0:
        eventPlayer.customTelePos = customTeleportPositionList[0]
        del customTeleportPositionList[0]
    else:
        eventPlayer.customTelePos = null
    eventPlayer.canTeleport = false
    #Damage over time duration
    chaseAtRate(eventPlayer.damageOverTimeDuration, -1, 0.95, ChaseRateReeval.NONE)
    #Bot target warning icon (flashing)
    createIcon(getAllPlayers() if eventPlayer in queuedGoalList else eventPlayer.botTarget.filter(lambda x: eventPlayer.isAlive() and not x.isInViewAngle(eventPlayer.getPosition(), 55)), eventPlayer, Icon.WARNING, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.RED if (((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer.getPosition(), localPlayer.getPosition()) > 10 else 8))) % 2) == 0) else Color.YELLOW)
    waitUntil(eventPlayer.hasSpawned(), 2)
    eventPlayer.setMaxHealth(30 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.HAZARD, Hero.ILLARI] else 1)
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.health - eventPlayer.initialMaxHealth), true)
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.health - 10000), true)
    eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)
    eventPlayer.setRespawnTime(30)
    if not eventPlayer in bossStateList:
        botRespawnInitialization()
    eventPlayer.canTeleport = true


rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING":
    @Event eachPlayer
    @Team 2
    @Condition isGameplayActive == true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition (eventPlayer.getThrottle() == vect(0, 0, 0) or eventPlayer.getHorizontalSpeed() < 1 * eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed) == true
    @Condition playerTargetList.all(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) > 2.1 * eventPlayer.size) == true
    
    if eventPlayer.botTarget != null:
        wait(random.uniform(7.5, 12.5), Wait.ABORT_WHEN_FALSE)
    else:
        wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(vect(0, -500, 0))
    if ruleCondition:
        loop()


rule "BOT DIES":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer in bossStateList == false
    
    if eventPlayer.botTempValue and eventPlayer.getHero() == Hero.ANRAN and not eventWasEnvironment:
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        eventPlayer.botTempValue = 0
        wait(random.randint(1, 4))
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        return
    if eventPlayer in queuedGoalList:
        # tmp0: random kill-bonus roll, to decide whether this zombie awards objective progress.
        tmp0 = random.randint(150, eventPlayer.health)
        if tmp0 > 175 or difficultySetting <= 3:
            objectiveCaptureValue += 10 if eventPlayer.health > 500 else eventPlayer.health * (0.04 if difficultySetting <= 2 else 0.035)
            smallMessage(getAllPlayers(), " {0}  Kill Bonus".format(iconString(Icon.PLUS)))
            #Miniboss kill bonus
            if eventPlayer in miniBossList:
                objectiveCaptureValue += 10
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, objectivePositionList[0], 100)
    wait(3 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.ANA] else 0)
    eventPlayer.botTarget = null
    eventPlayer.potentialTargets = []
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    if not eventWasEnvironment or attacker.getTeam() == Team.1:
        #Remove miniboss from zombie
        miniBossList[miniBossList.index(eventPlayer)] = 0
        eventPlayer.disableNameplatesFor(getAllPlayers())
        #Allow for custom revive times
        waitUntil(eventPlayer.reviveTimer > 0, 0.125)
        if eventPlayer.reviveTimer <= 0:
            eventPlayer.reviveTimer = 1 + ((getMatchTime() + matchEndTime) / 60)
        if len(botSpawnTimeList) < numberOfBots:
            botSpawnTimeList.append(eventPlayer.reviveTimer)
        if eventPlayer.customTelePos:
            customTeleportPositionList.append(eventPlayer.customTelePos)
        wait(1)
        waitUntil(eventPlayer.damageOverTimeDuration <= 0, 10)
        updateBotSpawnPoints()
        destroyDummy(Team.2, eventPlayer.getSlot())
        return
    elif eventWasEnvironment and distance(eventPlayer.getPosition(), vect(eventPlayer.telePos.x, eventPlayer.getPosition().y, eventPlayer.telePos.z)) < 10:
        eventPlayer.successfullyTeleported = false
    eventPlayer.teleporting = true
    eventPlayer.teleport(vect(500, 50, 500))
    wait(0.25)
    eventPlayer.resurrect()


rule "TELEPORT BOTS (GENERAL)":
    @Event eachPlayer
    @Team 2
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition getNumberOfLivingPlayers(Team.1) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    teleportBots()


rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.teleporting != true
    @Condition isGameplayActive == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.targeting != true
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition (playerTargetList.filter(lambda x: x.invisible).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))) == true
    
    if eventPlayer.successfullyTeleported:
        wait(5, Wait.ABORT_WHEN_FALSE)
    else:
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        wait(max(1, 10 - distance(eventPlayer.getPosition(), eventPlayer.averagePlayersPos) / 8), Wait.ABORT_WHEN_FALSE)
        if eventPlayer.successfullyTeleported:
            loop()
    teleportBots()
    loop()


rule "BOT STUN MANAGEMENT":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.STUNNED)) == true
    
    eventPlayer.crowdControlled = true
    wait(0.125)
    if ruleCondition:
        loop()
    eventPlayer.crowdControlled = false


rule "UPDATE SUCCESSFUL TELEPORT STATUS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.successfullyTeleported != true
    @Condition isPregameSetup != true
    @Condition eventPlayer in bossStateList == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if not eventPlayer.successfullyTeleported:
        eventPlayer.successfullyTeleported = true
    if distance(eventPlayer.telePos, eventPlayer.averagePlayersPos) < BOT_MAX_TELEPORT_RANGE:
        eventPlayer.waypoint = eventPlayer.getPosition()
        updateBotSpawnPoints()


rule "BOT TARGET VISIBLE":
    @Event eachPlayer
    @Team 2
    @Condition isPregameSetup != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.botTarget == null or playerTargetList.exclude(eventPlayer.botTarget).any(lambda x: not x.invisible and distance(x.getPosition(), eventPlayer.getPosition()) < 7.5)) == true
    @Condition (playerTargetList.any(lambda x: not x.invisible and distance(eventPlayer.getPosition(), x.getPosition()) < 150 and isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    startRule(selectTarget)
    wait(1)
    if ruleCondition:
        loop()


rule "BOT TAKES DAMAGE AND SWITCHES TARGETS":
    @Event playerTookDamage
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition (attacker != eventPlayer.botTarget or eventPlayer in miniBossList) == true
    @Condition eventPlayer.isAlive() == true
    @Condition attacker.getTeam() != victim.getTeam()
    
    startRule(selectTarget, StartRuleBehavior.NOOP)
    wait(2)


rule "DESELECT BOT TARGET":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.botTarget.invisible or not eventPlayer.botTarget in playerTargetList or not isInLoS(eventPlayer.botTarget.getEyePosition(), eventPlayer.getPosition() + losOffsetConst)) == true
    
    eventPlayer.botTarget = null
    if not eventPlayer.specialThrottling:
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.lastTarget.getPosition() + normalize(worldVector(eventPlayer.lastTarget.getThrottle(), eventPlayer.lastTarget, Transform.ROTATION)) * -2), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    if not eventPlayer.specialFacing:
        eventPlayer.startFacing(eventPlayer.getThrottle(), 0 if eventPlayer.crowdControlled else 100, Relativity.TO_PLAYER)
    wait(0.125, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "BOT WANDERS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.specialThrottling != true
    @Condition eventPlayer.specialFacing != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3.5
    @Condition isPregameSetup != true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) + random.uniform(90, 270), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    wait(1)
    if ruleCondition:
        loop()


rule "BOTS JUMP":
    @Event eachPlayer
    @Team 2
    @Condition isPregameSetup != true
    @Condition eventPlayer.specialThrottling == false
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isJumping() != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.isCrouching() == false
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) > 2) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "BOTS MOVE THROUGH SPAWN DOORS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.wallCollisionEnabled == true
    @Condition eventPlayer.canWallPhase == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    @Condition (eventPlayer.isOnGround() or eventPlayer in bossStateList and eventPlayer.getAltitude() < 10) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeed * 3
    #Makes sure bot is moving forward
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) >= 0
    @Condition isInLoS(eventPlayer.getPosition() + offsetUpThreeQuartersConst * eventPlayer.size, eventPlayer.getPosition() + offsetUpThreeQuartersConst * eventPlayer.size + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3 * eventPlayer.size) == true
    
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.wallCollisionEnabled = false
    if eventPlayer in bossStateList:
        wait(2, Wait.RESTART_WHEN_TRUE)
    else:
        wait(1)
    if ruleCondition:
        loop()
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    if not eventPlayer in bossStateList:
        wait(5)


rule "BOTS MELEE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.isMeleeing() != true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) < 3 * eventPlayer.size
    @Condition eventPlayer.botTarget.getHorizontalSpeed() < 15 * eventPlayer.botTarget.movementSpeed
    
    if eventPlayer.getHero() == Hero.HAZARD and not eventPlayer.botTempValue and not eventPlayer.abilityArray1 and eventPlayer in bossStateList:
        eventPlayer.botTempvalue2 = true
        eventPlayer.specialFacing = true
        eventPlayer.chase1 = -20
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + vect(eventPlayer.chase1, 0, 0)), 9999 if eventPlayer.chase1 == -20 else 100)
        chaseOverTime(eventPlayer.chase1, 25, 3)
        for eventPlayer.pBouncePadCount1 in range(5):
            eventPlayer.setUltCharge(100)
            wait()
            eventPlayer.clearStatusEffect(Status.HACKED)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.8)
            if eventPlayer.crowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
            waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        eventPlayer.specialFacing = false
        restoreDefaultFacingMovement()
        stopChasing(eventPlayer.chase1)
        eventPlayer.abilityArray1 += 10
        eventPlayer.botTempvalue2 = false
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.MELEE)
    if ruleCondition:
        loop()


rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)":
    @Event playerDealtDamage
    @Team 2
    @Condition eventAbility == Button.MELEE
    @Condition victim.getTeam() == Team.1
    
    victim.startDamageOverTime(eventPlayer, eventPlayer.biteDuration, eventPlayer.biteDamage)
    if eventPlayer.damageOverTimeDuration < eventPlayer.biteDuration:
        eventPlayer.damageOverTimeDuration = eventPlayer.biteDuration
    if createWorkshopSettingBool("Infection", "Melee Infection Enabled", true) and not eventPlayer.hasStatus(Status.HACKED) and not victim.isDummy() and (victim.getHealth() <= (victim.getMaxHealth() if victim.hitchhikerPassenger != null else victim.initialMaxHealth)):
        victim.infectionLvl += (2 if eventPlayer in bossStateList or eventPlayer in miniBossList or eventPlayer.mutationValue == 4 else 1) / ((3 if not victim.infected and victim.getHero() in [Hero.REINHARDT, Hero.HAZARD, Hero.VENDETTA, Hero.DMON] else 2) if victim.enhancementId != Enhancement.ZOMBIE_HYBRID else 1)
        if not victim.infected and victim.infectionLvl >= 1:
            victim.infected = true


rule "BOTS RECOIL FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 20
    @Condition eventPlayer.crowdControlled != true
    @Condition eventPlayer.attached != true
    @Condition attacker.getTeam() == Team.1
    @Condition victim.isAlive() == true
    @Condition eventDamage > 0.3 * eventPlayer.health
    
    if victim.isInAir() and eventWasCriticalHit:
        victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 3)
    else:
        victim.setStatusEffect(attacker, Status.STUNNED, 0.5)
    victim.applyImpulse(directionFromAngles(random.uniform(-20, 20) + horizontalAngleOfDirection(eventDirection), 0), eventDamage * 15 / victim.health * eventPlayer.knockbackRecieved, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


def enterExitTeleport():
    @Name "enterExitTeleport"
    
    if eventPlayer.teleporting:
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.setGravity(0)
    else:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.25)
        eventPlayer.setInvisibility(Invis.NONE)
        eventPlayer.setGravity(100)
        if eventPlayer.botTarget == null:
            if eventPlayer.telePos in botSpawnPointList:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), botSpawnWaypointList[botSpawnPointList.index(eventPlayer.telePos)]), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            else:
                eventPlayer.startThrottleInDirection(directionFromAngles(random.randint(-90, 90) + horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer.getPosition(), x.getPosition()))[0].getPosition())), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        elif eventPlayer.botTarget != null:
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


def teleportBots():
    @Name "teleportBots"
    
    if eventPlayer.getHero() == Hero.ANRAN and eventPlayer.isUsingUltimate():
        return
    eventPlayer.teleporting = true
    updateBotSpawnPoints()
    enterExitTeleport()
    eventPlayer.successfullyTeleported = false
    waitUntil(not eventPlayer.initializing and eventPlayer.canTeleport, 99999)
    if eventPlayer.customTelePos == null:
        while eventPlayer.teleporting:
            botTeleportCenterMacro()
            wait()
            eventPlayer.telePos = 0
            #Teleport with max distance constraint no view angle constraint
            while eventPlayer.telePos == 0 or playerTargetList.any(lambda x: distance(eventPlayer.telePos, x.getPosition()) < 15) or playerTargetList.all(lambda x: distance(eventPlayer.telePos, x.getPosition()) > BOT_MAX_TELEPORT_RANGE):
                # tmp0: saved spawn points within teleport range, to choose a nearby destination.
                tmp0 = botSpawnPointList.filter(lambda x: distance(x, eventPlayer.averagePlayersPos) < BOT_MAX_TELEPORT_RANGE)
                #Filter out spawn points on cooldown
                # tmp0: nearby spawn points whose cooldown permits use, to choose a ready destination.
                tmp0 = tmp0.filter(lambda x: botSpawnPointTimerList[botSpawnPointList.index(x)] < 15)
                #Bots utilize saved spawn points
                if len(botSpawnPointList) > 0 and len(tmp0) > 0:
                    eventPlayer.telePos = random.choice(tmp0)
                    botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.telePos)] += 5
                    break
                else:
                    eventPlayer.telePos = nearestWalkablePosition(eventPlayer.averagePlayersPos + directionFromAngles(random.uniform(0, 360), random.uniform(-20, 10)) * random.uniform(0, BOT_MAX_TELEPORT_RANGE))
                wait(0.25)
            if playerTargetList.all(lambda x: distance(eventPlayer.telePos, x.getPosition()) > 10) and playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.telePos, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.telePos + losOffsetConst)):
                eventPlayer.teleport(eventPlayer.telePos)
                eventPlayer.teleporting = false
            #Teleport was unsuccessful due to line of sight and view angle
            elif eventPlayer.telePos in botSpawnPointList:
                del botSpawnWaypointList[botSpawnPointList.index(eventPlayer.telePos)]
                del botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.telePos)]
                botSpawnPointList.remove(eventPlayer.telePos)
    else:
        eventPlayer.teleport(eventPlayer.customTelePos)
        eventPlayer.customTelePos = null
        eventPlayer.teleporting = false
    wait()
    enterExitTeleport()


def locateAveragePlayerLocation():
    @Name "locateAveragePlayerLocation"
    
    eventPlayer.averagePlayersPos = vect(0, 0, 0)
    if len(objectivePlayerList) == 0 and playerTargetList.any(lambda x: x.getThrottle() != vect(0, 0, 0)):
        # tmp0: moving-player index, then their count after the loop, to average their positions.
        for tmp0 in range(len(playerTargetList.filter(lambda x: x.getThrottle() != vect(0, 0, 0)))):
            eventPlayer.averagePlayersPos += ((playerTargetList.filter(lambda x: x.getThrottle() != vect(0, 0, 0)))[tmp0]).getPosition()
    else:
        # tmp0: player index, then the player count after the loop, to average all target positions.
        for tmp0 in range(len(playerTargetList)):
            eventPlayer.averagePlayersPos += playerTargetList[tmp0].getPosition()
    eventPlayer.averagePlayersPos /= tmp0


def successfulTeleportStatus():
    @Name "successfulTeleportStatus"
    
    #Max teleport distance adjustment
    if not eventPlayer.successfullyTeleported:
        eventPlayer.successfullyTeleported = true


def updateBotSpawnPoints():
    @Name "updateBotSpawnPoints"
    
    if eventPlayer.successfullyTeleported and eventPlayer.customTelePos == null and not eventPlayer.telePos in botSpawnPointList:
        botSpawnPointList.append(eventPlayer.telePos)
        botSpawnWaypointList.append(eventPlayer.waypoint)
        botSpawnPointTimerList.append(0)
    elif not eventPlayer.successfullyTeleported and eventPlayer.telePos in botSpawnPointList:
        del botSpawnWaypointList[botSpawnPointList.index(eventPlayer.telePos)]
        del botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.telePos)]
        botSpawnPointList.remove(eventPlayer.telePos)


rule "MINIBOSS MESSAGE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in miniBossList == true
    @Condition CURRENT_OBJECTIVE_TYPE != ObjectiveType.SHOWDOWN
    @Condition isGameplayActive == true
    @Condition eventPlayer.initializing != false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bigMessage(getAllPlayers(), "A Contestor approaches")

