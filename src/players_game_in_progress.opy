#!mainFile "main.opy"

subroutine teleportToClosestPlayer
subroutine teleportDownedPlayerToWalkable
subroutine updateUsers
subroutine saveAlivePlayerState


macro playerObjectiveEntityManagementMacro():
    if eventPlayer.objectiveTypeSnapshot != objectiveValue or len(objectivePositionList) == 1:
        eventPlayer.objectiveTypeSnapshot = currentObjectiveType
        if eventPlayer.getTeam() == Team.1:
            #Destroy all current objective effects and texts
            for eventPlayer.visualCleanupIndex in range(len(eventPlayer.playerObjectiveIconIdList)):
                destroyIcon(eventPlayer.playerObjectiveIconIdList[eventPlayer.visualCleanupIndex])
                wait()
            eventPlayer.playerObjectiveIconIdList = []
        else:
            #Destroy all current objective effects and texts
            for eventPlayer.visualCleanupIndex in range(len(eventPlayer.botResourceIconIdList)):
                destroyIcon(eventPlayer.botResourceIconIdList[eventPlayer.visualCleanupIndex])
                wait()
            eventPlayer.botResourceIconIdList = []
        if eventPlayer.objectiveTypeSnapshot == ObjectiveType.BIOMORPHING:
            #Player carrying resources icon
            createIcon(getAllPlayers().filter(lambda player: eventPlayer.isAlive() and player != eventPlayer and eventPlayer.biomorphingResourceAmount > 0), eventPlayer, Icon.RECYCLE, IconReeval.VISIBILITY_POSITION_AND_COLOR, biomorphingResourceColorList[eventPlayer.biomorphingResourceType] if eventPlayer.getTeam() == Team.1 else Color.WHITE)
            if eventPlayer.getTeam() == Team.1:
                eventPlayer.playerObjectiveIconIdList.append(getLastCreatedEntity())
            else:
                eventPlayer.botResourceIconIdList.append(getLastCreatedEntity())


rule "PLAYER INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition isPregameSetup != true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.invisibilityCount = false
    eventPlayer.movementSpeedScale = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
    eventPlayer.isAttached = false
    eventPlayer.isAfk = false
    if eventPlayer.isHeroSwitchRespawn == true:
        return
    eventPlayer.disableMessages()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    startRule(setDifficulty)
    eventPlayer.isReviving = false
    eventPlayer.disableRespawn()
    wait()
    eventPlayer.isInfected = false
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.reviveDuration = 5
    eventPlayer.reviveTimeRemaining = eventPlayer.reviveDuration
    eventPlayer.rescueTimeRemaining = mustReviveTime
    eventPlayer.infectionLevel = 0
    enableDisableAbilities()
    eventPlayer.sizeScale = 1
    if eventPlayer.pregameState == PregameState.SELECTING_HERO:
        if not "{0}".format(eventPlayer) in userNameList:
            updateUsers()
            teleportToClosestPlayer()
            eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 10)
            eventPlayer.isPlayerActive = true
        else:
            #Index of user in user array
            eventPlayer.reconnectUserIndex = userNameList.index("{0}".format(eventPlayer))
            # Read-only snapshot for this synchronous segment; do not retain it across kill()/wait().
            #!define reconnectRowSnapshot tmp0
            reconnectRowSnapshot = playerStatsList[eventPlayer.reconnectUserIndex]
            eventPlayer.rescueTimeRemaining = reconnectRowSnapshot[ReconnectField.RESCUE_TIME_REMAINING]
            eventPlayer.reviveTimeRemaining = reconnectRowSnapshot[ReconnectField.REVIVE_TIME_REMAINING]
            eventPlayer.reviveDuration = reconnectRowSnapshot[ReconnectField.REVIVE_DURATION]
            if reconnectRowSnapshot[ReconnectField.STATUS] == ReconnectStatus.ALIVE:
                teleportToClosestPlayer()
                eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 10)
                eventPlayer.isPlayerActive = true
            elif reconnectRowSnapshot[ReconnectField.STATUS] >= ReconnectStatus.DOWNED:
                eventPlayer.teleport(reconnectRowSnapshot[ReconnectField.POSITION])
                while eventPlayer.isAlive():
                    kill(eventPlayer)
                    wait(0.5)
                eventPlayer.isPlayerActive = true
                # Death handlers may update saved state during the wait; read the current status again.
                if playerStatsList[eventPlayer.reconnectUserIndex][ReconnectField.STATUS] == ReconnectStatus.DEAD:
                    eventPlayer.rescueTimeRemaining = 0.5
    else:
        waitUntil(len(objectivePositionList) >= 1, 5)
        if isSpecialGameMode:
            wait()
            eventPlayer.teleport(random.choice(mapGridList.filter(lambda x: distance(x, walkCenter) < 15)))
            wait()
        eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), currentObjectivePosition), Relativity.TO_WORLD)
        eventPlayer.isPlayerActive = true
        eventPlayer.cancelPrimaryAction()
        eventPlayer.clearStatusEffect(Status.INVINCIBLE)
        updateUsers()
    eventPlayer.stopCamera()
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setInvisibility(Invis.NONE)


rule "EFFECTS/TEXTS":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition isPregameSetup != true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isHeroSwitchRespawn == false
    
    wait(0.25)
    #Infected aura
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.isInfected), Effect.BAD_AURA, Color.BLACK if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID else Color.LIME_GREEN, eventPlayer, 0.1 if localPlayer == eventPlayer else 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Need revive text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.isDead() and eventPlayer.rescueTimeRemaining > 0), "Reviving: {0}s".format(ceil(eventPlayer.reviveTimeRemaining)) if eventPlayer.isReviving else "Revive: {0}s".format(ceil(eventPlayer.rescueTimeRemaining)), eventPlayer.getPosition() + offsetUpOneAndHalfConst, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.YELLOW if eventPlayer.isReviving else Color.RED)
    #Reviving ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.isReviving), Effect.RING, Color.YELLOW, eventPlayer.getPosition(), REVIVE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Health Hud text
    hudText(getAllPlayers().filter(lambda _: eventPlayer.rescueTimeRemaining > 0 and not eventPlayer.isAfk), "{0}{1}: {2}".format("Winston" if isSmolderEventActive else eventPlayer, heroIcon(Hero.WINSTON) if isSmolderEventActive else heroIcon(eventPlayer.getHero()), "{0}%".format(ceil(eventPlayer.getNormalizedHealth() * 100)) if eventPlayer.isAlive() else "DOWN"), "Revive: {0}s".format(ceil(eventPlayer.rescueTimeRemaining)) if eventPlayer.isDead() and not eventPlayer.isReviving else [], ("{1}Infection Level: {0}".format(floor(eventPlayer.infectionLevel), iconString(Icon.POISON) if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID else [])) if eventPlayer.infectionLevel >= 1 else "Vaccine Level: {0}".format(abs(floor(eventPlayer.infectionLevel))) if eventPlayer.infectionLevel < 0 else "Reviving: {0}s".format(ceil(eventPlayer.reviveTimeRemaining)) if eventPlayer.isReviving else [], HudPosition.LEFT, 0 if eventPlayer.getNormalizedHealth() > 0.97 else 1 / (eventPlayer.getNormalizedHealth() + 1), Color.BLUE if eventPlayer.getNormalizedHealth() > 0.97 else Color.GREEN if eventPlayer.getNormalizedHealth() > 0.66 else Color.YELLOW if eventPlayer.getNormalizedHealth() > 0.33 else Color.ORANGE if eventPlayer.getNormalizedHealth() > 0 else Color.RED, Color.RED, Color.LIME_GREEN if eventPlayer.infectionLevel >= 1 else Color.BLUE if eventPlayer.infectionLevel < 0 else Color.YELLOW)


rule "PLAYER GETS DOWNED":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.isDummy() == false
    
    wait(0.16)
    eventPlayer.reviveTimeRemaining = eventPlayer.reviveDuration / (2 if challengeSetting == 2 else 1)
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.infectionLevel = 0
    eventPlayer.isInfected = false
    (getPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer)).botTarget = null
    (getAllPlayers().filter(lambda player: eventPlayer in player.candidateTargetList)).candidateTargetList.remove(eventPlayer)
    if eventWasEnvironment:
        if attacker.getHero() == Hero.REINHARDT and eventAbility == Button.ABILITY_1:
            teleportToClosestPlayer()
        else:
            teleportDownedPlayerToWalkable()


rule "REVIVE PLAYER OR ADVANCE DEATH TIMER":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDead() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.rescueTimeRemaining > 0
    @Condition eventPlayer.isDummy() == false
    
    # Save row in ReconnectField order.
    playerStatsList[eventPlayer.reconnectUserIndex] = [ReconnectStatus.DOWNED, eventPlayer.rescueTimeRemaining, eventPlayer.reviveTimeRemaining, eventPlayer.reviveDuration, eventPlayer.getPosition()]
    waitUntil(not eventPlayer.isReviving and playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(x.getPosition(), eventPlayer.getPosition()) < REVIVE_RADIUS), 0.5)
    if playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < REVIVE_RADIUS):
        eventPlayer.isReviving = true
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), REVIVE_RADIUS * 2)
        eventPlayer.reviveTimeRemaining += -0.5
        if eventPlayer.rescueTimeRemaining < 70:
            eventPlayer.rescueTimeRemaining += 0.5
    else:
        eventPlayer.isReviving = false
        #If dome will pass player before their death timer runs out, set the death timer to how long it will take for the dome to reach them
        if len(objectivePositionList) == 1 and extractionZoneRad - distance(eventPlayer.getPosition(), currentObjectivePosition) < eventPlayer.rescueTimeRemaining:
            eventPlayer.rescueTimeRemaining = (extractionZoneRad - distance(eventPlayer.getPosition(), currentObjectivePosition)) / 2.5
        else:
            eventPlayer.rescueTimeRemaining += -0.5
        #Player is dead outside of extraction zone
        if len(objectivePositionList) == 1 and distance(currentObjectivePosition, eventPlayer.getPosition()) > extractionZoneRad:
            eventPlayer.rescueTimeRemaining = 0
        #Player's body falls off of map
        if eventPlayer.getPosition().y - nearestWalkablePosition(eventPlayer.getPosition()).y < -0.1:
            teleportDownedPlayerToWalkable()
    if eventPlayer.reviveTimeRemaining <= 0:
        eventPlayer.reviveDuration++
        eventPlayer.reviveTimeRemaining = eventPlayer.reviveDuration
        eventPlayer.resurrect()
        eventPlayer.isReviving = false
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 5)
        waitUntil(eventPlayer.isAlive(), 2)
    elif eventPlayer.rescueTimeRemaining <= 0:
        # Save row in ReconnectField order.
        playerStatsList[eventPlayer.reconnectUserIndex] = [ReconnectStatus.DEAD, eventPlayer.rescueTimeRemaining, eventPlayer.reviveTimeRemaining, eventPlayer.reviveDuration, offsetDownHundredConst]
        bigMessage(getAllPlayers().exclude(eventPlayer), "{0} {1} died!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        if mustReviveTime == 60 and len(objectivePositionList) != 1:
            bigMessage(getAllPlayers().exclude(eventPlayer), "Save {0} by finishing the objective!".format(eventPlayer))
        mustReviveTime -= 0 if mustReviveTime <= 30 else 10
        eventPlayer.teleport(offsetDownHundredConst)
        eventPlayer.setInvisibility(Invis.ALL)
        waitUntil(isObjectiveComplete, 99999)
        eventPlayer.resurrect()
        teleportToClosestPlayer()
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.setInvisibility(Invis.NONE)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
    if ruleCondition:
        loop()
    eventPlayer.isReviving = false
    if eventPlayer.isAlive():
        eventPlayer.rescueTimeRemaining = mustReviveTime
        saveAlivePlayerState()


rule "PLAYER PICKS UP HEALTH PACK":
    @Event playerReceivedHealing
    @Team 1
    @Condition eventWasHealthPack == true
    
    eventPlayer.startHealingOverTime(null, 5, 20)
    if difficultySetting < Difficulty.EXPERT or getMatchTime() > matchEndTime:
        #Update known health pack positions
        if healthpackPositionList.all(lambda x: distance(x, eventPlayer.getPosition()) > 5):
            healthpackPositionList.append(eventPlayer.getPosition())
        eventPlayer.stopAllDamageOverTime()
        eventPlayer.clearStatusEffect(Status.BURNING)
        if eventPlayer.infectionLevel > 0:
            eventPlayer.isInfected = false
            eventPlayer.infectionLevel = 0
    elif eventPlayer.isInfected:
        smallMessage(eventPlayer, "Match time has reached 0. Health packs no longer cure infection.")


rule "PLAYER CLEARS DAMAGE OVER TIME":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition (eventPlayer.hasStatus(Status.PHASED_OUT) or eventPlayer.hasStatus(Status.INVINCIBLE)) == true
    
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.clearStatusEffect(Status.BURNING)
    wait(0.25)
    if ruleCondition:
        loop()


rule "PLAYER INFECTION DAMAGE MANAGEMENT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isInfected == true
    
    if eventPlayer.infectionLevel < 1:
        eventPlayer.isInfected = false
    eventPlayer.startDamageOverTime(null, 1, (floor(eventPlayer.infectionLevel) if eventPlayer.enhancementId != Enhancement.ZOMBIE_HYBRID else eventPlayer.infectionLevel / 2) ** 2)
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        eventPlayer.infectionDamageOverTimeId = getLastDamageOverTimeId()
    wait(1)
    if ruleCondition:
        loop()


rule "PLAYER AFK":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup != true
    @Condition createWorkshopSettingBool("General", "Allow players to go AFK", true, 3) == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.isAttached != true
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition eventPlayer in objectivePlayerList != true
    @Condition eventPlayer.isCommunicatingVoiceline() == false
    
    if not eventPlayer.isAfk:
        wait(45, Wait.ABORT_WHEN_FALSE)
        smallMessage(getAllPlayers().filter(lambda _: eventPlayer.isAlive()), "{0} {1} is afk".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.isAfk = true
        eventPlayer.setInvisibility(Invis.ALL)
        playerTargetList.remove(eventPlayer)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
    else:
        wait(1)
    if ruleCondition:
        loop()
    if eventPlayer.isAfk:
        eventPlayer.isAfk = false
        eventPlayer.setInvisibility(Invis.NONE)
        smallMessage(getAllPlayers(), "{0} {1} is back!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)


rule "PLAYER SWITCHES HERO":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.detach()
    waitUntil(not eventPlayer.hasSpawned(), 1)
    wait()
    eventPlayer.setAllowedHeroes(getAllHeroes())
    eventPlayer.isHeroSwitchRespawn = true


rule "PLAYER AUTOMATIC RELOAD":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() == 0
    @Condition eventPlayer.getMaxAmmo() != 0
    @Condition eventPlayer.getHero() != Hero.ILLARI
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    smallMessage(eventPlayer, "Weapon reloaded")


rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE":
    @Event eachPlayer
    @Condition isGameplayActive == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.objectiveTypeSnapshot != objectiveValue or len(objectivePositionList) == 1) == true
    
    playerObjectiveEntityManagementMacro()


rule "PLAYER TARGET (ADD)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAfk != true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in playerTargetList == false
    @Condition eventPlayer.isDummy() == false
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    playerTargetList.append(eventPlayer)
    if ruleCondition:
        loop()


rule "PLAYER TARGET (REMOVE)":
    @Event eachPlayer
    @Team 1
    @Condition (eventPlayer.isDead() or not eventPlayer.hasSpawned()) == true
    @Condition eventPlayer in playerTargetList == true
    @Condition eventPlayer.isDummy() == false
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    playerTargetList.remove(eventPlayer)
    if ruleCondition:
        loop()


def teleportToClosestPlayer():
    @Name "teleportToClosestPlayer"
    
    eventPlayer.teleport(nearestWalkablePosition(sorted(playerTargetList.exclude(eventPlayer), lambda x: distance(x.getPosition(), currentObjectivePosition))[0].getPosition()))


def teleportDownedPlayerToWalkable():
    @Name "teleportDownedPlayerToWalkable"

    # Both downed-player paths use the same synchronous recovery teleport.
    eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))


def updateUsers():
    @Name "updateUsers"
    
    if not "{0}".format(eventPlayer) in userNameList:
        #Add event player to users list
        userNameList.append("{0}".format(eventPlayer))
        #Index of user in user array
        eventPlayer.reconnectUserIndex = userNameList.index("{0}".format(eventPlayer))
        saveAlivePlayerState()


def saveAlivePlayerState():
    # Synchronous record write using the caller's eventPlayer and reconnectUserIndex; no scratch or waits.
    # Callers keep their original lifecycle checks and timer/index initialization before this call.
    # Save row in ReconnectField order.
    playerStatsList[eventPlayer.reconnectUserIndex] = [ReconnectStatus.ALIVE, eventPlayer.rescueTimeRemaining, eventPlayer.reviveTimeRemaining, eventPlayer.reviveDuration, eventPlayer.getPosition()]
