#!mainFile "../../main.opy"

subroutine removeBotSpawnPoint
subroutine enterExitTeleport
subroutine teleportBots
subroutine updateBotSpawnPoints
subroutine locateAveragePlayerLocation
subroutine setClosestPlayerTeleportCenter

# Synchronous cache scratch. removeBotSpawnPoint reads a valid row index.
#!define botSpawnCacheIndex tmp0
#!define botSpawnCacheSecond tmp1


macro collectNearbyZombieLoot():
    # Called synchronously from BOT DIES: victim is the dead zombie bot. Pays
    # every living Engineer/Scavenger within the same range, regardless of kill
    # credit. No waits or nested calls; tmp0-3 expire before bot-handler reuse.
    #!define zombieLootCollectors tmp0
    #!define zombieLootCollector tmp1
    #!define zombieLootCollectorIndex tmp2
    zombieLootCollectors = getLivingPlayers(Team.1).filter(lambda player: (player.enhancementId == Enhancement.ENGINEER or player.augmentId == Augment.SCAVENGER) and distance(player, victim) < ENGINEER_COLLECTION_RANGE)
    for zombieLootCollectorIndex in range(len(zombieLootCollectors)):
        zombieLootCollector = zombieLootCollectors[zombieLootCollectorIndex]
        if zombieLootCollector.enhancementId == Enhancement.ENGINEER:
            zombieLootCollector.enhancementScrap = min(ENGINEER_SCRAP_MAX, zombieLootCollector.enhancementScrap + ENGINEER_COLLECTION_REWARD)
        # Enhancement and augment can coexist: an Engineer/Scavenger gets both.
        collectScavengerLoot(zombieLootCollector)


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
    if eventPlayer.botBaseHealth > 10000:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.botBaseHealth - 10000, true)
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
    @Condition eventPlayer.botIsCrowdControlled != true
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
    
    # Environmental deaths do not grant normal damage-event lifesteal.
    # Heal the credited survivor before any death-handler waits.
    if eventWasEnvironment and attacker.getTeam() == Team.1:
        applySurvivalistLifesteal(attacker, eventDamage)
    # Engineer/Scavenger collection: synchronous, before any death-handler waits.
    collectNearbyZombieLoot()

    if eventPlayer.botIsReigniteAttackUsed and eventPlayer.getHero() == Hero.ANRAN and not eventWasEnvironment:
        useChargedUltimate()
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
        miniBossList.remove(eventPlayer)
        retireDeadBot()
        return
    elif eventWasEnvironment and magnitude((eventPlayer.getPosition() - eventPlayer.botTeleportPosition) * horizontalMaskConst) < 10:
        eventPlayer.botIsTeleportConfirmed = false
    eventPlayer.botIsTeleporting = true
    eventPlayer.teleport(vect(500, 50, 500))
    wait(0.25)
    eventPlayer.resurrect()


def retireDeadBot():
    @Name "retireDeadBot"

    eventPlayer.disableNameplatesFor(getAllPlayers())
    # Allow for custom revive times.
    waitUntil(eventPlayer.botRespawnDelay > 0, 0.125)
    if not eventPlayer.botRespawnDelay:
        eventPlayer.botRespawnDelay = 1 + ((getMatchTime() + matchEndTime) / 60)
    if len(botSpawnTimeList) < numberOfBots:
        # Keep the earliest deadline at the head. Only enqueueing can reorder the queue.
        botSpawnTimeList = sorted(botSpawnTimeList.concat(getTotalTimeElapsed() + eventPlayer.botRespawnDelay))
    if eventPlayer.botCustomTeleportPosition:
        customTeleportPositionList.append(eventPlayer.botCustomTeleportPosition)
    wait(1)
    waitUntil(eventPlayer.damageOverTimeRemaining <= 0, 10)
    updateBotSpawnPoints()
    destroyDummy(Team.2, eventPlayer.getSlot())


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
    @Condition eventPlayer.isCrowdControlled == true
    
    # Preserve the bot flag's polling window and restore it after bot initialization.
    eventPlayer.botIsCrowdControlled = true
    wait(0.125)
    if ruleCondition:
        loop()
    eventPlayer.botIsCrowdControlled = false


rule "UPDATE SUCCESSFUL TELEPORT STATUS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.botIsTeleportConfirmed != true
    @Condition isPregameSetup != true
    @Condition eventPlayer in bossStateList == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
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
    @Condition playerTargetList != []
    @Condition (eventPlayer.botTarget == null or playerTargetList.exclude(eventPlayer.botTarget).any(lambda x: not x.invisibilityCount and distance(x, eventPlayer) < 7.5)) == true

    # Stagger visibility probes across bots. Consume the lists before the next wait.
    wait(random.uniform(0.125, 0.25), Wait.ABORT_WHEN_FALSE)
    botTargetProbeCandidates = playerTargetList.filter(lambda player: not player.invisibilityCount and distance(eventPlayer, player) < 150)
    botTargetProbeVisible = botTargetProbeCandidates.filter(lambda player: isInLoS(player.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))
    if botTargetProbeVisible != []:
        selectBotTarget()
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
    @Condition (eventPlayer.botTarget.invisibilityCount or not eventPlayer.botTarget in playerTargetList) == true
    
    deselectBotTarget()
    wait(0.125, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "CHECK BOT TARGET LINE OF SIGHT":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botIsTeleporting != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null

    # Stagger the probes and check the current target after the wait.
    wait(random.uniform(0.125, 0.25), Wait.ABORT_WHEN_FALSE)
    if not isInLoS(eventPlayer.botTarget.getEyePosition(), eventPlayer.getPosition() + losOffsetConst):
        deselectBotTarget()
    if ruleCondition:
        loop()


rule "BOT WANDERS":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget == null
    @Condition eventPlayer.botIsThrottleOverridden != true
    @Condition eventPlayer.botIsFacingOverridden != true
    @Condition eventPlayer.botIsCrowdControlled != true
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
    @Condition eventPlayer.botIsCrowdControlled != true
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
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition magnitude(eventPlayer.getThrottle())
    @Condition (eventPlayer.isOnGround() or eventPlayer in bossStateList and eventPlayer.getAltitude() < 10) == true
    # Check both bounds using one sample of speed along the throttle direction.
    @Condition [eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION))].any(lambda speed: (
        speed >= 0 and speed < eventPlayer.botThrottleSpeed * eventPlayer.movementSpeedScale * 3
    )) == true
    # Use one origin for both ends of the LoS check.
    @Condition [eventPlayer.getPosition() + offsetUpThreeQuartersConst * eventPlayer.sizeScale].any(lambda origin: isInLoS(
        origin,
        origin + normalize(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)) * 3 * eventPlayer.sizeScale
    )) == true
    
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
    @Condition eventPlayer.botIsCrowdControlled != true
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
            if eventPlayer.botIsCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
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
    @Condition not victim.isDotProtected

    # While the victim is ulting or inside the Dash protection window, the bite
    # applies nothing: no new damage-over-time and no infection stacks.
    # Already ticking DoTs and existing infection levels run their course; the
    # direct bite hit is untouched.
    victim.startDamageOverTime(eventPlayer, eventPlayer.botBiteDuration, eventPlayer.botBiteDamage)
    if eventPlayer.damageOverTimeRemaining < eventPlayer.botBiteDuration:
        eventPlayer.damageOverTimeRemaining = eventPlayer.botBiteDuration
    # Bulk stacks raise the infection threshold with native max health; only overheal above it protects.
    # Keep initialMaxHealth native for Hitchhiker pools and Nemesis detection.
    if isMeleeInfectionEnabled and not eventPlayer.hasStatus(Status.HACKED) and not victim.isDummy() and (victim.enhancementId == Enhancement.ZOMBIE_HYBRID or victim.getHealth() <= (victim.getMaxHealth() if victim.hitchhikerPassenger != null else victim.initialMaxHealth * (min(BULKING_SEASON_MAX_HP_MULTIPLIER, 1 + victim.enhancementBulkStacks * (BULKING_SEASON_HP_PER_STACK_PCT / 100)) if victim.enhancementId == Enhancement.BULKING_SEASON else 1))):
        victim.infectionLevel += (2 if eventPlayer in bossStateList or eventPlayer in miniBossList or eventPlayer.botMutationId == 4 else 1) / ((3 if not victim.isInfected and victim.getHero() in [Hero.REINHARDT, Hero.HAZARD, Hero.VENDETTA, Hero.DMON] else 2) if victim.enhancementId != Enhancement.ZOMBIE_HYBRID else 1)
        if not victim.isInfected and victim.infectionLevel >= 1:
            victim.isInfected = true


rule "BOTS RECOIL FROM DAMAGE":
    @Event playerTookDamage
    @Team 2
    @Condition eventDamage > 20
    @Condition eventPlayer.botIsCrowdControlled != true
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
            # Use the same synchronous lookup for the cache hit and its waypoint.
            #!define teleportExitSpawnIndex tmp0
            teleportExitSpawnIndex = botSpawnPointList.index(eventPlayer.botTeleportPosition)
            if teleportExitSpawnIndex != -1:
                eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, botSpawnWaypointList[teleportExitSpawnIndex]), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
            else:
                eventPlayer.startThrottleInDirection(directionFromAngles(random.randint(-90, 90) + horizontalAngleOfDirection(directionTowards(eventPlayer, sorted(getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned()), lambda x: distance(eventPlayer, x))[0])), 0), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        else:
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
                if DEBUG_BOT_AI_LOGS_ACTIVE:
                    debugBotTeleportAttempts++
                    if playerTargetList == []:
                        debugBotTeleportNoTargets++
                # Use the original position index for the aligned deadline, with one cache pass.
                #!define teleportCandidateSpawnPointList tmp0
                #!define botSpawnCacheReuseCutoff tmp2
                botSpawnCacheSecond = floor(getTotalTimeElapsed())
                botSpawnCacheReuseCutoff = botSpawnCacheSecond + BOT_SPAWN_POINT_REUSE_THRESHOLD
                teleportCandidateSpawnPointList = botSpawnPointList.filter(lambda point, index: (
                    distance(point, eventPlayer.botTeleportCenter) < BOT_MAX_TELEPORT_RANGE
                    and botSpawnPointLoadUntilList[index] < botSpawnCacheReuseCutoff
                ))
                if teleportCandidateSpawnPointList != []:
                    eventPlayer.botTeleportPosition = random.choice(teleportCandidateSpawnPointList)
                    botSpawnCacheIndex = botSpawnPointList.index(eventPlayer.botTeleportPosition)
                    botSpawnPointLoadUntilList[botSpawnCacheIndex] = max(botSpawnPointLoadUntilList[botSpawnCacheIndex], botSpawnCacheSecond) + BOT_SPAWN_POINT_USE_PENALTY
                    if DEBUG_BOT_AI_LOGS_ACTIVE:
                        debugBotTeleportCacheHits++
                    break
                else:
                    eventPlayer.botTeleportPosition = nearestWalkablePosition(eventPlayer.botTeleportCenter + directionFromAngles(random.uniform(0, 360), random.uniform(-20, 10)) * random.uniform(0, BOT_MAX_TELEPORT_RANGE))
                wait(0.25)
            if playerTargetList.all(lambda x: distance(eventPlayer.botTeleportPosition, x) > 10) and playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst)):
                eventPlayer.teleport(eventPlayer.botTeleportPosition)
                eventPlayer.botIsTeleporting = false
                if DEBUG_BOT_AI_LOGS_ACTIVE:
                    debugBotTeleportSuccesses++
            else:
                botSpawnCacheIndex = botSpawnPointList.index(eventPlayer.botTeleportPosition)
                if botSpawnCacheIndex >= 0:
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
    averageTargetPlayerList = playerTargetList.filter(lambda player: magnitude(player.getThrottle())) if objectivePlayerList == [] else playerTargetList
    if averageTargetPlayerList == []:
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


def updateBotSpawnPoints():
    @Name "updateBotSpawnPoints"
    
    if eventPlayer.botIsTeleportConfirmed and eventPlayer.botCustomTeleportPosition == null and not eventPlayer.botTeleportPosition in botSpawnPointList:
        if len(botSpawnPointList) >= BOT_SPAWN_POINT_CACHE_LIMIT:
            # Prefer the oldest unpenalized point. If every point is busy, evict index 0.
            botSpawnCacheSecond = floor(getTotalTimeElapsed())
            botSpawnCacheIndex = max(0, botSpawnPointLoadUntilList.map(lambda deadline: deadline <= botSpawnCacheSecond).index(true))
            removeBotSpawnPoint()
        botSpawnPointList.append(eventPlayer.botTeleportPosition)
        botSpawnWaypointList.append(eventPlayer.botSpawnWaypoint)
        botSpawnPointLoadUntilList.append(0)
    elif not eventPlayer.botIsTeleportConfirmed:
        botSpawnCacheIndex = botSpawnPointList.index(eventPlayer.botTeleportPosition)
        if botSpawnCacheIndex >= 0:
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
    # The caller supplies the same index for all three arrays. No waits.
    del botSpawnWaypointList[botSpawnCacheIndex]
    del botSpawnPointLoadUntilList[botSpawnCacheIndex]
    del botSpawnPointList[botSpawnCacheIndex]
