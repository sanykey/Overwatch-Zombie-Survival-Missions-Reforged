#!mainFile "main.opy"

subroutine playerObjectiveEntityManagement
subroutine teleportToClosestPlayer
subroutine updateUsers


rule "PLAYER INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.invisible = false
    eventPlayer.movementSpeed = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    eventPlayer.attached = false
    eventPlayer.afk = false
    if eventPlayer.switchedHeroes == true:
        return
    eventPlayer.disableMessages()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableGamemodeHud()
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    startRule(setDifficulty)
    eventPlayer.reviving = false
    eventPlayer.disableRespawn()
    wait()
    eventPlayer.infected = false
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.reviveStartTime = 5
    eventPlayer.reviveTimer = eventPlayer.reviveStartTime
    eventPlayer.deathTimer = mustReviveTime
    eventPlayer.infectionLvl = 0
    enableDisableAbilities()
    eventPlayer.size = 1
    if eventPlayer.playerMenuStatus[0] == 0:
        if not "{0}".format(eventPlayer) in users:
            updateUsers()
            teleportToClosestPlayer()
            eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 10)
            eventPlayer.playerActiveStatus = true
        else:
            #Index of user in user array
            eventPlayer.userIndex = users.index("{0}".format(eventPlayer))
            eventPlayer.deathTimer = globalPlayerStats[eventPlayer.userIndex][1]
            eventPlayer.reviveTimer = globalPlayerStats[eventPlayer.userIndex][2]
            eventPlayer.reviveStartTime = globalPlayerStats[eventPlayer.userIndex][3]
            if globalPlayerStats[eventPlayer.userIndex][0] == 0:
                teleportToClosestPlayer()
                eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 10)
                eventPlayer.playerActiveStatus = true
            elif globalPlayerStats[eventPlayer.userIndex][0] >= 1:
                eventPlayer.teleport(globalPlayerStats[eventPlayer.userIndex][4])
                while eventPlayer.isAlive():
                    kill(eventPlayer)
                    wait(0.5)
                eventPlayer.playerActiveStatus = true
                if globalPlayerStats[eventPlayer.userIndex][0] == 2:
                    eventPlayer.deathTimer = 0.5
    else:
        waitUntil(len(objectivePositions) >= 1, 5)
        if specialGameMode:
            wait()
            eventPlayer.teleport(random.choice(mapGrid.filter(lambda x: distance(x, walkCenter) < 15)))
            wait()
        eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), objectivePositions[0]), Relativity.TO_WORLD)
        eventPlayer.playerActiveStatus = true
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
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition specialGameModeSetup != true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.switchedHeroes == false
    
    wait(0.25)
    #Infected aura
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.infected), Effect.BAD_AURA, Color.BLACK if eventPlayer.enhancementValues[0] == 2 else Color.LIME_GREEN, eventPlayer, 0.1 if localPlayer == eventPlayer else 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Need revive text
    createInWorldText(getAllPlayers().filter(lambda _: eventPlayer.isDead() and eventPlayer.deathTimer > 0), "Reviving: {0}s".format(ceil(eventPlayer.reviveTimer)) if eventPlayer.reviving else "Revive: {0}s".format(ceil(eventPlayer.deathTimer)), eventPlayer.getPosition() + vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.YELLOW if eventPlayer.reviving else Color.RED)
    #Reviving ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.reviving), Effect.RING, Color.YELLOW, eventPlayer.getPosition(), reviveRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Health Hud text
    hudText(getAllPlayers().filter(lambda _: eventPlayer.deathTimer > 0 and not eventPlayer.afk), "{0}{1}: {2}".format("Winston" if gameSmolderEvent else eventPlayer, heroIcon(Hero.WINSTON) if gameSmolderEvent else heroIcon(eventPlayer.getHero()), "{0}%".format(ceil(eventPlayer.getNormalizedHealth() * 100)) if eventPlayer.isAlive() else "DOWN"), "Revive: {0}s".format(ceil(eventPlayer.deathTimer)) if eventPlayer.isDead() and not eventPlayer.reviving else [], ("{1}Infection Level: {0}".format(floor(eventPlayer.infectionLvl), iconString(Icon.POISON) if eventPlayer.enhancementValues[0] == 2 else [])) if eventPlayer.infectionLvl >= 1 else "Vaccine Level: {0}".format(abs(floor(eventPlayer.infectionLvl))) if eventPlayer.infectionLvl < 0 else "Reviving: {0}s".format(ceil(eventPlayer.reviveTimer)) if eventPlayer.reviving else [], HudPosition.LEFT, 0 if eventPlayer.getNormalizedHealth() > 0.97 else 1 / (eventPlayer.getNormalizedHealth() + 1), Color.BLUE if eventPlayer.getNormalizedHealth() > 0.97 else Color.GREEN if eventPlayer.getNormalizedHealth() > 0.66 else Color.YELLOW if eventPlayer.getNormalizedHealth() > 0.33 else Color.ORANGE if eventPlayer.getNormalizedHealth() > 0 else Color.RED, Color.RED, Color.LIME_GREEN if eventPlayer.infectionLvl >= 1 else Color.BLUE if eventPlayer.infectionLvl < 0 else Color.YELLOW)


rule "PLAYER GETS DOWNED":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.isDummy() == false
    
    wait(0.16)
    eventPlayer.reviveTimer = eventPlayer.reviveStartTime / (2 if challengeSetting == 2 else 1)
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.infectionLvl = 0
    eventPlayer.infected = false
    (getPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer)).botTarget = null
    (getAllPlayers().filter(lambda player: eventPlayer in player.potentialTargets)).potentialTargets.remove(eventPlayer)
    if eventWasEnvironment:
        if attacker.getHero() == Hero.REINHARDT and eventAbility == Button.ABILITY_1:
            teleportToClosestPlayer()
        else:
            eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))


rule "REVIVE PLAYER OR ADVANCE DEATH TIMER":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDead() == true
    @Condition gameStatus == true
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.deathTimer > 0
    @Condition eventPlayer.isDummy() == false
    
    #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
    globalPlayerStats[eventPlayer.userIndex] = [1, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]
    waitUntil(not eventPlayer.reviving and playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisible).any(lambda x: distance(x.getPosition(), eventPlayer.getPosition()) < reviveRadius), 0.5)
    if playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisible).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < reviveRadius):
        eventPlayer.reviving = true
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), reviveRadius * 2)
        eventPlayer.reviveTimer += -0.5
        if eventPlayer.deathTimer < 70:
            eventPlayer.deathTimer += 0.5
    else:
        eventPlayer.reviving = false
        #If dome will pass player before their death timer runs out, set the death timer to how long it will take for the dome to reach them
        if len(objectivePositions) == 1 and extractionZoneRad - distance(eventPlayer.getPosition(), objectivePositions[0]) < eventPlayer.deathTimer:
            eventPlayer.deathTimer = (extractionZoneRad - distance(eventPlayer.getPosition(), objectivePositions[0])) / 2.5
        else:
            eventPlayer.deathTimer += -0.5
        #Player is dead outside of extraction zone
        if len(objectivePositions) == 1 and distance(objectivePositions[0], eventPlayer.getPosition()) > extractionZoneRad:
            eventPlayer.deathTimer = 0
        #Player's body falls off of map
        if eventPlayer.getPosition().y - nearestWalkablePosition(eventPlayer.getPosition()).y < -0.1:
            eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))
    if eventPlayer.reviveTimer <= 0:
        eventPlayer.reviveStartTime++
        eventPlayer.reviveTimer = eventPlayer.reviveStartTime
        eventPlayer.resurrect()
        eventPlayer.reviving = false
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 5)
        waitUntil(eventPlayer.isAlive(), 2)
    elif eventPlayer.deathTimer <= 0:
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [2, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, vect(0, -100, 0)]
        bigMessage(getAllPlayers().exclude(eventPlayer), "{0} {1} died!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        if mustReviveTime == 60 and len(objectivePositions) != 1:
            bigMessage(getAllPlayers().exclude(eventPlayer), "Save {0} by finishing the objective!".format(eventPlayer))
        mustReviveTime -= 0 if mustReviveTime <= 30 else 10
        eventPlayer.teleport(vect(0, -100, 0))
        eventPlayer.setInvisibility(Invis.ALL)
        waitUntil(objectiveComplete, 99999)
        eventPlayer.resurrect()
        teleportToClosestPlayer()
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.setInvisibility(Invis.NONE)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
    if ruleCondition:
        loop()
    eventPlayer.reviving = false
    if eventPlayer.isAlive():
        eventPlayer.deathTimer = mustReviveTime
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [0, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]


rule "PLAYER PICKS UP HEALTH PACK":
    @Event playerReceivedHealing
    @Team 1
    @Condition eventWasHealthPack == true
    
    eventPlayer.startHealingOverTime(null, 5, 20)
    if difficultySetting < 3 or getMatchTime() > matchEndTime:
        #Update known health pack positions
        if healthpackPositions.all(lambda x: distance(x, eventPlayer.getPosition()) > 5):
            healthpackPositions.append(eventPlayer.getPosition())
        eventPlayer.stopAllDamageOverTime()
        eventPlayer.clearStatusEffect(Status.BURNING)
        if eventPlayer.infectionLvl > 0:
            eventPlayer.infected = false
            eventPlayer.infectionLvl = 0
    elif eventPlayer.infected:
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
    @Condition eventPlayer.infected == true
    
    if eventPlayer.infectionLvl < 1:
        eventPlayer.infected = false
    eventPlayer.startDamageOverTime(null, 1, (floor(eventPlayer.infectionLvl) if eventPlayer.enhancementValues[0] != 2 else eventPlayer.infectionLvl / 2) ** 2)
    if eventPlayer.enhancementValues[0] == 2:
        eventPlayer.infectionDamage = getLastDamageOverTimeId()
    wait(1)
    if ruleCondition:
        loop()


rule "PLAYER AFK":
    @Event eachPlayer
    @Team 1
    @Condition specialGameModeSetup != true
    @Condition createWorkshopSettingBool("General", "Allow players to go AFK", true, 3) == true
    @Condition eventPlayer.playerActiveStatus == true
    @Condition eventPlayer.attached != true
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition eventPlayer in playersOnObjective != true
    @Condition eventPlayer.isCommunicatingVoiceline() == false
    
    if not eventPlayer.afk:
        wait(45, Wait.ABORT_WHEN_FALSE)
        smallMessage(getAllPlayers().filter(lambda _: eventPlayer.isAlive()), "{0} {1} is afk".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        waitUntil(eventPlayer.isAlive(), 99999)
        eventPlayer.afk = true
        eventPlayer.setInvisibility(Invis.ALL)
        playerTargetList.remove(eventPlayer)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
    else:
        wait(1)
    if ruleCondition:
        loop()
    if eventPlayer.afk:
        eventPlayer.afk = false
        eventPlayer.setInvisibility(Invis.NONE)
        smallMessage(getAllPlayers(), "{0} {1} is back!".format(eventPlayer, heroIcon(eventPlayer.getHero())))
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)


rule "PLAYER SWITCHES HERO":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    eventPlayer.detach()
    waitUntil(not eventPlayer.hasSpawned(), 1)
    wait()
    eventPlayer.setAllowedHeroes(getAllHeroes())
    eventPlayer.switchedHeroes = true


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
    @Condition gameStatus == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.objectiveValue != objectiveValue or len(objectivePositions) == 1) == true
    
    playerObjectiveEntityManagement()


rule "PLAYER TARGET (ADD)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.afk != true
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


def playerObjectiveEntityManagement():
    @Name "playerObjectiveEntityMangement"
    
    if eventPlayer.objectiveValue != objectiveValue or len(objectivePositions) == 1:
        eventPlayer.objectiveValue = objectiveTypes[0]
        if eventPlayer.getTeam() == Team.1:
            #Destroy all current objective effects and texts
            for eventPlayer.entityCount in range(len(eventPlayer.generalPlayerBotEntities)):
                destroyIcon(eventPlayer.generalPlayerBotEntities[eventPlayer.entityCount])
                wait()
            eventPlayer.generalPlayerBotEntities = []
        else:
            #Destroy all current objective effects and texts
            for eventPlayer.entityCount in range(len(eventPlayer.botResourceEntity)):
                destroyIcon(eventPlayer.botResourceEntity[eventPlayer.entityCount])
                wait()
            eventPlayer.botResourceEntity = []
        if eventPlayer.objectiveValue == 3:
            #Player carrying resources icon
            createIcon(getAllPlayers().filter(lambda player: eventPlayer.isAlive() and player != eventPlayer and eventPlayer.playerObjectiveResourceValue > 0), eventPlayer, Icon.RECYCLE, IconReeval.VISIBILITY_POSITION_AND_COLOR, biowasteColorLookUp[eventPlayer.biowasteType] if eventPlayer.getTeam() == Team.1 else Color.WHITE)
            if eventPlayer.getTeam() == Team.1:
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            else:
                eventPlayer.botResourceEntity.append(getLastCreatedEntity())


def teleportToClosestPlayer():
    @Name "teleportToClosestPlayer"
    
    eventPlayer.teleport(nearestWalkablePosition(sorted(playerTargetList.exclude(eventPlayer), lambda x: distance(x.getPosition(), objectivePositions[0]))[0].getPosition()))


def updateUsers():
    @Name "updateUsers"
    
    if not "{0}".format(eventPlayer) in users:
        #Add event player to users list
        users.append("{0}".format(eventPlayer))
        #Index of user in user array
        eventPlayer.userIndex = users.index("{0}".format(eventPlayer))
        #0) Downed/Dead status, 1) Death timer, 2) Revive timer, 3) Revive start time, 4) Downed position
        globalPlayerStats[eventPlayer.userIndex] = [0, eventPlayer.deathTimer, eventPlayer.reviveTimer, eventPlayer.reviveStartTime, eventPlayer.getPosition()]
