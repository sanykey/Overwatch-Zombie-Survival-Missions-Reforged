#!mainFile "../main.opy"

subroutine removeBotSpawnPoint
subroutine enterExitTeleport
subroutine teleportBots
subroutine successfulTeleportStatus
subroutine updateBotSpawnPoints
subroutine locateAveragePlayerLocation
subroutine setClosestPlayerTeleportCenter


macro botTeleportCenterMacro():
    #Standoff, Extraction, Biomorphing, Zombie Egg
    if currentObjectiveType in [ObjectiveType.SHOWDOWN, ObjectiveType.BIOMORPHING, ObjectiveType.ZOMBIE_EGG]:
        botTeleportPivot = currentObjectivePosition
        setClosestPlayerTeleportCenter()
    #Boss
    elif currentObjectiveType == ObjectiveType.BOSSES:
        botTeleportPivot = bossStateList[0].getPosition()
        setClosestPlayerTeleportCenter()
    #Survivor Rescue
    elif currentObjectiveType == ObjectiveType.SURVIVOR_RESCUE:
        if rescueSurvivor.rescueLeader == null:
            botTeleportPivot = rescueSurvivor.getPosition()
            setClosestPlayerTeleportCenter()
        else:
            eventPlayer.botTeleportCenter = rescueSurvivor.rescueLeader.getPosition()
    #Killzone
    elif currentObjectiveType == ObjectiveType.KILL_ZONE:
        #If players are in the killzone
        if playerTargetList.any(lambda x: distance(x, killZoneCenter) < objectiveRad):
            #Player closeset to the center of the killzone
            botTeleportPivot = killZoneCenter
            setClosestPlayerTeleportCenter()
        else:
            #Average player positon
            locateAveragePlayerLocation()
    #Satellite Uplink
    elif currentObjectiveType == ObjectiveType.SATELLITE_UPLINK:
        #Checks if any players are currently repairing terminals
        if objectivePlayerList != []:
            eventPlayer.botTeleportCenter = random.choice(objectivePlayerList).getPosition()
        else:
            #Closest player to sattelite firing position
            botTeleportPivot = currentObjectivePosition
            setClosestPlayerTeleportCenter()
    #Default
    else:
        locateAveragePlayerLocation()

rule "Fix bot health":
    @Event eachPlayer
    @Team 2
    @Condition isGameplayActive == true
    @Condition eventPlayer.botIsInitializing != true
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.getHealth() > eventPlayer.botBaseHealth + 5
    @Condition eventPlayer in bossStateList == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.botBaseHealth)
    if ruleCondition:
        loop()

rule "BOT INITIALIZATION":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition isPregameSetup != true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(null, Math.INFINITY, 9999)
    eventPlayer.botRespawnDelay = 0
    if customTeleportPositionList != []:
        eventPlayer.botCustomTeleportPosition = customTeleportPositionList[0]
        del customTeleportPositionList[0]
    else:
        eventPlayer.botCustomTeleportPosition = null
    eventPlayer.botIsTeleportAllowed = false
    #Damage over time duration
    chaseAtRate(eventPlayer.damageOverTimeRemaining, -1, 0.95, ChaseRateReeval.NONE)
    #Bot target warning icon (flashing)
    createIcon(getAllPlayers() if eventPlayer in showdownContestingZombieList else eventPlayer.botTarget.filter(lambda x: eventPlayer.isAlive() and not x.isInViewAngle(eventPlayer.getPosition(), 55)), eventPlayer, Icon.WARNING, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.RED if (not (((ceil(getTotalTimeElapsed() * (4 if distance(eventPlayer, localPlayer) > 10 else 8))) % 2))) else Color.YELLOW)
    waitUntil(eventPlayer.hasSpawned(), 2)
    eventPlayer.setMaxHealth(30 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.HAZARD, Hero.ILLARI] else 1)
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.botBaseHealth - eventPlayer.initialMaxHealth), true)
    #Bot Health Pool
    eventPlayer.addHealthPool(Health.NORMAL, max(0, eventPlayer.botBaseHealth - 10000), true)
    faceCurrentThrottle()
    eventPlayer.setRespawnTime(30)
    if not eventPlayer in bossStateList:
        botRespawnInitialization()
    eventPlayer.botIsTeleportAllowed = true


rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING":
    @Event eachPlayer
    @Team 2
    @Condition isGameplayActive == true
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition (not magnitude(eventPlayer.getThrottle()) or eventPlayer.getHorizontalSpeed() < 1 * eventPlayer.botThrottleSpeed * eventPlayer.movementSpeedScale) == true
    @Condition playerTargetList.all(lambda x: distance(eventPlayer, x) > 2.1 * eventPlayer.sizeScale) == true
    
    if eventPlayer.botTarget != null:
        wait(random.uniform(7.5, 12.5), Wait.ABORT_WHEN_FALSE)
    else:
        wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(-500 * Vector.UP)
    if ruleCondition:
        loop()


rule "BOT DIES":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer in bossStateList == false
    
    if eventPlayer.botIsReigniteAttackUsed and eventPlayer.getHero() == Hero.ANRAN and not eventWasEnvironment:
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        eventPlayer.botIsReigniteAttackUsed = 0
        wait(random.randint(1, 4))
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        return
    if eventPlayer in showdownContestingZombieList:
        if random.randint(150, eventPlayer.botBaseHealth) > 175 or difficultySetting <= Difficulty.EXPERT:
            showdownCapturePercent += 10 if eventPlayer.botBaseHealth > 500 else eventPlayer.botBaseHealth * (0.04 if difficultySetting <= Difficulty.HARD else 0.035)
            smallMessage(getAllPlayers(), " {0}  Kill Bonus".format(iconString(Icon.PLUS)))
            #Miniboss kill bonus
            if eventPlayer in miniBossList:
                showdownCapturePercent += 10
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, currentObjectivePosition, 100)
    wait(3 if eventPlayer.getHero() in [Hero.SYMMETRA, Hero.ANA] else 0)
    eventPlayer.botTarget = null
    eventPlayer.botPotentialTargetList = []
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopFacing()
    if not eventWasEnvironment or attacker.getTeam() == Team.1:
        #Remove miniboss from zombie
        miniBossList[miniBossList.index(eventPlayer)] = 0
        eventPlayer.disableNameplatesFor(getAllPlayers())
        #Allow for custom revive times
        waitUntil(eventPlayer.botRespawnDelay > 0, 0.125)
        if not eventPlayer.botRespawnDelay:
            eventPlayer.botRespawnDelay = 1 + ((getMatchTime() + matchEndTime) / 60)
        if len(botSpawnTimeList) < numberOfBots:
            botSpawnTimeList.append(eventPlayer.botRespawnDelay)
        if eventPlayer.botCustomTeleportPosition:
            customTeleportPositionList.append(eventPlayer.botCustomTeleportPosition)
        wait(1)
        waitUntil(eventPlayer.damageOverTimeRemaining <= 0, 10)
        updateBotSpawnPoints()
        destroyDummy(Team.2, eventPlayer.getSlot())
        return
    elif eventWasEnvironment and distance(eventPlayer, vect(eventPlayer.botTeleportPosition.x, eventPlayer.getPosition().y, eventPlayer.botTeleportPosition.z)) < 10:
        eventPlayer.botIsTeleportConfirmed = false
    eventPlayer.botIsTeleporting = true
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
    @Condition eventPlayer.botIsTeleporting != true
    @Condition isGameplayActive == true
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.botIsSelectingTarget != true
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in bossStateList == false
    @Condition (playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))) == true
    
    if eventPlayer.botIsTeleportConfirmed:
        wait(5, Wait.ABORT_WHEN_FALSE)
    else:
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        wait(max(1, 10 - distance(eventPlayer, eventPlayer.botTeleportCenter) / 8), Wait.ABORT_WHEN_FALSE)
        if eventPlayer.botIsTeleportConfirmed:
            loop()
    teleportBots()
    loop()


rule "BOT STUN MANAGEMENT":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.STUNNED)) == true
    
    eventPlayer.isCrowdControlled = true
    wait(0.125)
    if ruleCondition:
        loop()
    eventPlayer.isCrowdControlled = false


rule "UPDATE SUCCESSFUL TELEPORT STATUS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botIsTeleportConfirmed != true
    @Condition isPregameSetup != true
    @Condition eventPlayer in bossStateList == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if not eventPlayer.botIsTeleportConfirmed:
        eventPlayer.botIsTeleportConfirmed = true
    if distance(eventPlayer.botTeleportPosition, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE:
        eventPlayer.botSpawnWaypoint = eventPlayer.getPosition()
        updateBotSpawnPoints()


rule "BOT TARGET VISIBLE":
    @Event eachPlayer
    @Team 2
    @Condition isPregameSetup != true
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botIsInitializing != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.botTarget == null or playerTargetList.exclude(eventPlayer.botTarget).any(lambda x: not x.invisibilityCount and distance(x, eventPlayer) < 7.5)) == true
    @Condition (playerTargetList.any(lambda x: not x.invisibilityCount and distance(eventPlayer, x) < 150 and isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))) == true
    
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
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botTarget != null
    @Condition (eventPlayer.botTarget.invisibilityCount or not eventPlayer.botTarget in playerTargetList or not isInLoS(eventPlayer.botTarget.getEyePosition(), eventPlayer.getPosition() + losOffsetConst)) == true
    
    eventPlayer.botTarget = null
    if not eventPlayer.botIsThrottleOverridden:
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.botLastTarget.getPosition() + normalize(worldVector(eventPlayer.botLastTarget.getThrottle(), eventPlayer.botLastTarget, Transform.ROTATION)) * -2), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    if not eventPlayer.botIsFacingOverridden:
        eventPlayer.startFacing(eventPlayer.getThrottle(), 0 if eventPlayer.isCrowdControlled else 100, Relativity.TO_PLAYER)
    wait(0.125, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "BOT WANDERS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.botIsFacingOverridden != true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeedScale * 3.5
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
    @Condition eventPlayer.botIsThrottleOverridden == false
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isJumping() != true
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.isCrouching() == false
    @Condition (eventPlayer.botTarget == null or distance(eventPlayer, eventPlayer.botTarget) > 2) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getHorizontalSpeed() < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeedScale * 3.5
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.JUMP)
    if ruleCondition:
        loop()


rule "BOTS MOVE THROUGH SPAWN DOORS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsWallCollisionEnabled == true
    @Condition eventPlayer.botIsWallPhaseAllowed == true
    @Condition eventPlayer.botIsAttached != true
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition magnitude(eventPlayer.getThrottle())
    @Condition (eventPlayer.isOnGround() or eventPlayer in bossStateList and eventPlayer.getAltitude() < 10) == true
    #Allows if bot bumps into something
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeedScale * 3
    #Makes sure bot is moving forward
    @Condition eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) >= 0
    @Condition isInLoS(eventPlayer.getPosition() + offsetUpThreeQuartersConst * eventPlayer.sizeScale, eventPlayer.getPosition() + offsetUpThreeQuartersConst * eventPlayer.sizeScale + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3 * eventPlayer.sizeScale) == true
    
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.botIsWallCollisionEnabled = false
    if eventPlayer in bossStateList:
        wait(2, Wait.RESTART_WHEN_TRUE)
    else:
        wait(1)
    if ruleCondition:
        loop()
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.botIsWallCollisionEnabled = true
    if not eventPlayer in bossStateList:
        wait(5)


rule "BOTS MELEE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.isMeleeing() != true
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 3 * eventPlayer.sizeScale
    @Condition eventPlayer.botTarget.getHorizontalSpeed() < 15 * eventPlayer.botTarget.movementSpeedScale
    
    if eventPlayer.getHero() == Hero.HAZARD and not eventPlayer.botIsEnsnarerBlocking and not eventPlayer.botAbilityCooldown and eventPlayer in bossStateList:
        eventPlayer.botIsEnsnarerMeleeActive = true
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.botEnsnarerMeleeAngle = -20
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + eventPlayer.botEnsnarerMeleeAngle * Vector.LEFT), 9999 if eventPlayer.botEnsnarerMeleeAngle == -20 else 100)
        chaseOverTime(eventPlayer.botEnsnarerMeleeAngle, 25, 3)
        for eventPlayer.botEnsnarerUltimateIndex in range(5):
            eventPlayer.setUltCharge(100)
            wait()
            eventPlayer.clearStatusEffect(Status.HACKED)
            eventPlayer.forceButtonPress(Button.ULTIMATE)
            wait(0.8)
            if eventPlayer.isCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
            waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
        eventPlayer.botIsFacingOverridden = false
        restoreDefaultFacingMovement()
        stopChasing(eventPlayer.botEnsnarerMeleeAngle)
        eventPlayer.botAbilityCooldown += 10
        eventPlayer.botIsEnsnarerMeleeActive = false
    wait(0.125, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.MELEE)
    if ruleCondition:
        loop()


rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)":
    @Event playerDealtDamage
    @Team 2
    @Condition eventAbility == Button.MELEE
    @Condition victim.getTeam() == Team.1
    
    victim.startDamageOverTime(eventPlayer, eventPlayer.botBiteDuration, eventPlayer.botBiteDamage)
    if eventPlayer.damageOverTimeRemaining < eventPlayer.botBiteDuration:
        eventPlayer.damageOverTimeRemaining = eventPlayer.botBiteDuration
    if createWorkshopSettingBool("Infection", "Melee Infection Enabled", true) and not eventPlayer.hasStatus(Status.HACKED) and not victim.isDummy() and (victim.getHealth() <= (victim.getMaxHealth() if victim.enhancementHitchhikerPassenger != null else victim.initialMaxHealth)):
        victim.infectionLevel += (2 if eventPlayer in bossStateList or eventPlayer in miniBossList or eventPlayer.botMutationId == 4 else 1) / ((3 if not victim.isInfected and victim.getHero() in [Hero.REINHARDT, Hero.HAZARD, Hero.VENDETTA, Hero.DMON] else 2) if victim.enhancementId != Enhancement.ZOMBIE_HYBRID else 1)
        if not victim.isInfected and victim.infectionLevel >= 1:
            victim.isInfected = true


rule "BOTS RECOIL FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 20
    @Condition eventPlayer.isCrowdControlled != true
    @Condition eventPlayer.botIsAttached != true
    @Condition attacker.getTeam() == Team.1
    @Condition victim.isAlive() == true
    @Condition eventDamage > 0.3 * eventPlayer.botBaseHealth
    
    if victim.isInAir() and eventWasCriticalHit:
        victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 3)
    else:
        victim.setStatusEffect(attacker, Status.STUNNED, 0.5)
    victim.applyImpulse(directionFromAngles(random.uniform(-20, 20) + horizontalAngleOfDirection(eventDirection), 0), eventDamage * 15 / victim.botBaseHealth * eventPlayer.botKnockbackScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


def enterExitTeleport():
    @Name "enterExitTeleport"
    
    if eventPlayer.botIsTeleporting:
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.stopThrottleInDirection()
        eventPlayer.setGravity(0)
    else:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.25)
        eventPlayer.setInvisibility(Invis.NONE)
        eventPlayer.setGravity(100)
        if eventPlayer.botTarget == null:
            if eventPlayer.botTeleportPosition in botSpawnPointList:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, botSpawnWaypointList[botSpawnPointList.index(eventPlayer.botTeleportPosition)]), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            else:
                eventPlayer.startThrottleInDirection(directionFromAngles(random.randint(-90, 90) + horizontalAngleOfDirection(directionTowards(eventPlayer, sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer, x))[0])), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        elif eventPlayer.botTarget != null:
            startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


def teleportBots():
    @Name "teleportBots"
    
    if eventPlayer.getHero() == Hero.ANRAN and eventPlayer.isUsingUltimate():
        return
    eventPlayer.botIsTeleporting = true
    updateBotSpawnPoints()
    enterExitTeleport()
    eventPlayer.botIsTeleportConfirmed = false
    waitUntil(not eventPlayer.botIsInitializing and eventPlayer.botIsTeleportAllowed, Math.INFINITY)
    if eventPlayer.botCustomTeleportPosition == null:
        while eventPlayer.botIsTeleporting:
            botTeleportCenterMacro()
            # Pre-existing edge case: targets may disappear during this wait or later search waits.
            # The search has no empty-target guard and may continue using a stale or zero center.
            # The shared average loop preserves this behavior; guard the search separately when fixing it.
            wait()
            eventPlayer.botTeleportPosition = 0
            #Teleport with max distance constraint no view angle constraint
            while eventPlayer.botTeleportPosition == 0 or playerTargetList.any(lambda x: distance(eventPlayer.botTeleportPosition, x) < 15) or playerTargetList.all(lambda x: distance(eventPlayer.botTeleportPosition, x) > BOT_MAX_TELEPORT_RANGE):
                # teleportCandidateSpawnPointList: saved spawn points within teleport range, to choose a nearby destination.
                #!define teleportCandidateSpawnPointList tmp0
                teleportCandidateSpawnPointList = botSpawnPointList.filter(lambda x: distance(x, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE)
                #Filter out spawn points on cooldown
                # teleportCandidateSpawnPointList: nearby spawn points whose cooldown permits use, to choose a ready destination.
                teleportCandidateSpawnPointList = teleportCandidateSpawnPointList.filter(lambda x: botSpawnPointTimerList[botSpawnPointList.index(x)] < 15)
                #Bots utilize saved spawn points
                if botSpawnPointList != [] and teleportCandidateSpawnPointList != []:
                    eventPlayer.botTeleportPosition = random.choice(teleportCandidateSpawnPointList)
                    botSpawnPointTimerList[botSpawnPointList.index(eventPlayer.botTeleportPosition)] += 5
                    break
                else:
                    eventPlayer.botTeleportPosition = nearestWalkablePosition(eventPlayer.botTeleportCenter + directionFromAngles(random.uniform(0, 360), random.uniform(-20, 10)) * random.uniform(0, BOT_MAX_TELEPORT_RANGE))
                wait(0.25)
            if playerTargetList.all(lambda x: distance(eventPlayer.botTeleportPosition, x) > 10) and playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst)):
                eventPlayer.teleport(eventPlayer.botTeleportPosition)
                eventPlayer.botIsTeleporting = false
            #Teleport was unsuccessful due to line of sight and view angle
            elif eventPlayer.botTeleportPosition in botSpawnPointList:
                removeBotSpawnPoint()
    else:
        eventPlayer.teleport(eventPlayer.botCustomTeleportPosition)
        eventPlayer.botCustomTeleportPosition = null
        eventPlayer.botIsTeleporting = false
    wait()
    enterExitTeleport()


def locateAveragePlayerLocation():
    @Name "locateAveragePlayerLocation"
    
    eventPlayer.botTeleportCenter = vect(0, 0, 0)
    # Snapshot the selected players once; consume the list synchronously before any wait or call.
    #!define averageTargetPlayerList tmp1
    if objectivePlayerList == [] and playerTargetList.any(lambda x: magnitude(x.getThrottle())):
        averageTargetPlayerList = playerTargetList.filter(lambda x: magnitude(x.getThrottle()))
    else:
        averageTargetPlayerList = playerTargetList
    # Preserve player order and the original loop counter as the divisor, including an empty list.
    #!define averageTargetPositionIndex tmp0
    for averageTargetPositionIndex in range(len(averageTargetPlayerList)):
        eventPlayer.botTeleportCenter += averageTargetPlayerList[averageTargetPositionIndex].getPosition()
    # Pre-existing empty-list behavior: the divisor is 0, and Workshop Divide returns 0, producing a zero center.
    # An early return here alone would not stop the caller's teleport search; this needs a separate fix.
    eventPlayer.botTeleportCenter /= averageTargetPositionIndex


def setClosestPlayerTeleportCenter():
    @Name "setClosestPlayerTeleportCenter"

    # Synchronous input handoff: callers assign botTeleportPivot immediately before this call.
    eventPlayer.botTeleportCenter = sorted(playerTargetList, lambda x: distance(x, botTeleportPivot))[0].getPosition()


def successfulTeleportStatus():
    @Name "successfulTeleportStatus"
    
    #Max teleport distance adjustment
    if not eventPlayer.botIsTeleportConfirmed:
        eventPlayer.botIsTeleportConfirmed = true


def updateBotSpawnPoints():
    @Name "updateBotSpawnPoints"
    
    if eventPlayer.botIsTeleportConfirmed and eventPlayer.botCustomTeleportPosition == null and not eventPlayer.botTeleportPosition in botSpawnPointList:
        botSpawnPointList.append(eventPlayer.botTeleportPosition)
        botSpawnWaypointList.append(eventPlayer.botSpawnWaypoint)
        botSpawnPointTimerList.append(0)
    elif not eventPlayer.botIsTeleportConfirmed and eventPlayer.botTeleportPosition in botSpawnPointList:
        removeBotSpawnPoint()


rule "MINIBOSS MESSAGE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer in miniBossList == true
    @Condition currentObjectiveType != ObjectiveType.SHOWDOWN
    @Condition isGameplayActive == true
    @Condition eventPlayer.botIsInitializing != false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    bigMessage(getAllPlayers(), "A Contestor approaches")



def removeBotSpawnPoint():
    # Synchronous: retain the original deletion order so parallel arrays stay aligned.
    #!define removedBotSpawnPointIndex tmp0
    removedBotSpawnPointIndex = botSpawnPointList.index(eventPlayer.botTeleportPosition)
    del botSpawnWaypointList[removedBotSpawnPointIndex]
    del botSpawnPointTimerList[removedBotSpawnPointIndex]
    botSpawnPointList.remove(eventPlayer.botTeleportPosition)
