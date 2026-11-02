#!mainFile "main.opy"

# Shared subroutines used by multiple sections (including their dependencies).

subroutine enableDisableAbilities
subroutine setDifficulty
subroutine botRespawnInitialization
subroutine objectivesManagement
subroutine selectTarget
subroutine restoreDefaultFacingMovement
subroutine setPrematchTimer
subroutine explosionSequence
subroutine illariUlt
subroutine abilityPlacement


macro minibossMutationMacro():
    miniBossList.append(eventPlayer)
    eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.HAZARD, Hero.REAPER]))
    if zombieSetting == 6:
        eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL]))
    eventPlayer.botBaseHealth = 2500
    eventPlayer.sizeScale *= 1.55
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE)
    eventPlayer.startForcingName("Contestor")
    #Skull Icon
    createIcon(getAllPlayers().filter(lambda _: eventPlayer.botIsInitializing == false and eventPlayer in bossStateList == false), eventPlayer.getEyePosition() + Vector.UP, Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.ORANGE)
    eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())


macro botStatManagementMacro():
    # botStatHeroIndex: current bot hero's table index, to look up bite, movement and damage settings without repeating the hero search.
    #!define botStatHeroIndex tmp0
    botStatHeroIndex = botHeroList.index(eventPlayer.getHero())
    eventPlayer.botBiteDamage = botBiteDamageList[botStatHeroIndex]
    #Re-calibrate bite damage
    eventPlayer.botBiteDamage *= 100 / botDamageDealtList[botStatHeroIndex]
    eventPlayer.botBiteDuration = botBiteDurationList[botStatHeroIndex]
    #Range from 0 to 1 in terms of throttle
    eventPlayer.botThrottleSpeed = botThrottleSpeedList[botStatHeroIndex]
    # botStatDamageScale: normalized damage multiplier; the hero index is no longer needed after this lookup.
    #!define botStatDamageScale tmp0
    botStatDamageScale = botDamageDealtList[botStatHeroIndex] / 100
    eventPlayer.setDamageDealt(botStatDamageScale * 100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.movementSpeedScale = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100 + ((len(getDeadPlayers(Team.1).filter(lambda player: player.rescueTimeRemaining <= 0))) * 3))
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.botKnockbackScale = 1
    eventPlayer.setKnockbackReceived(100)
    if eventPlayer.getHero() == Hero.REINHARDT:
        eventPlayer.botKnockbackScale = 0.7
        eventPlayer.setKnockbackReceived(100 * eventPlayer.botKnockbackScale)
    elif eventPlayer.getHero() == Hero.MERCY:
        eventPlayer.setProjectileSpeed(75 if eventPlayer in bossStateList else 20)
    elif eventPlayer.getHero() == Hero.ILLARI:
        eventPlayer.setKnockbackDealt(25)
    elif eventPlayer.getHero() == Hero.WINSTON:
        eventPlayer.sizeScale *= 0.7
        eventPlayer.botSmolderAnger = 2
        eventPlayer.startScalingBarriers(eventPlayer.sizeScale)
    elif eventPlayer.getHero() == Hero.ANA or eventPlayer.getHero() == Hero.KIRIKO:
        eventPlayer.setProjectileGravity(500)
    elif eventPlayer.getHero() == Hero.SIGMA:
        eventPlayer.setProjectileSpeed(100 * eventPlayer.sizeScale * 0.5)
        eventPlayer.setPrimaryFireEnabled(true)
    elif eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.setKnockbackDealt(120)
    elif eventPlayer.getHero() == Hero.HAZARD:
        chaseAtRate(eventPlayer.botAbilityCooldown, 0, 1)
    elif eventPlayer.getHero() == Hero.ANRAN:
        eventPlayer.setKnockbackDealt(150)


macro mutationsMacro():
    #Zombies have a chance to mutate. Bosses cannot mutate
    if len(availableMutationList) > 0 and not eventPlayer in bossStateList and (random.uniform(0, 100) < (100 if challengeSetting == 3 or challengeSetting == 5 else createWorkshopSettingFloat("Mutations", "Chance to mutate percentage", 25, 0, 100))):
        eventPlayer.botMutationId = random.choice(availableMutationList)
        # botMutationOutlineColor: outline color; every enabled mutation assigns it before the capture below.
        #Speed
        if eventPlayer.botMutationId == 1:
            eventPlayer.movementSpeedScale *= 1.5
            eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
            #!define botMutationOutlineColor tmp2
            botMutationOutlineColor = Color.PURPLE
            eventPlayer.startForcingName("SPEED")
        #Size Growth
        elif eventPlayer.botMutationId == 2:
            eventPlayer.sizeScale *= 1.5
            eventPlayer.botBaseHealth *= eventPlayer.sizeScale
            botMutationOutlineColor = Color.VIOLET
            eventPlayer.startForcingName("XL")
        #Size Reduction
        elif eventPlayer.botMutationId == 3:
            eventPlayer.sizeScale *= 0.6
            eventPlayer.botBaseHealth *= eventPlayer.sizeScale
            botMutationOutlineColor = Color.ROSE
            eventPlayer.startForcingName("XS")
        #Radioactive
        elif eventPlayer.botMutationId == 4:
            eventPlayer.botBiteDuration *= 1.5
            botMutationOutlineColor = Color.LIME_GREEN
            eventPlayer.startForcingName("Radioactive")
        #Heavy: enabled mutation IDs are 1..5, so the remaining case is 5.
        else:
            eventPlayer.botKnockbackScale *= 0.5
            eventPlayer.setKnockbackReceived(100 * eventPlayer.botKnockbackScale)
            #Scale move speed
            eventPlayer.movementSpeedScale *= eventPlayer.botKnockbackScale
            eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeedScale)
            #Scale health
            eventPlayer.botBaseHealth /= eventPlayer.botKnockbackScale
            botMutationOutlineColor = Color.BLACK
            eventPlayer.startForcingName("Heavy")
        #Capture the color so later scratch writes cannot change this persistent outline.
        eventPlayer.startForcingOutlineFor(getAllPlayers(), true, evalOnce(botMutationOutlineColor))
    else:
        eventPlayer.botMutationId = 0

        #Default ouline for players
        eventPlayer.stopForcingOutlineFor(getAllPlayers())
        eventPlayer.stopForcingName()


macro botEntityManagementMacro():
    if eventPlayer.botConfiguredHero != eventPlayer.getHero() or eventPlayer in bossStateList:
        eventPlayer.botConfiguredHero = eventPlayer.getHero()
        #Destroy all current hero effects and texts
        for eventPlayer.visualCleanupIndex in range(len(eventPlayer.botVisualEntityIdList)):
            destroyEffect(eventPlayer.botVisualEntityIdList[eventPlayer.visualCleanupIndex])
            wait()
        eventPlayer.explosionInnerColor = Color.YELLOW
        eventPlayer.explosionOuterColor = Color.ORANGE
        eventPlayer.botVisualEntityIdList = []
        if eventPlayer.getHero() == Hero.ROADHOG:
            eventPlayer.setHealingReceived(30)
            if eventPlayer in bossStateList:
                #Gas Projectile 1
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.botGasProjectilePosition != null), Effect.BAD_AURA, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 0.4 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                #Gas Projectile 2
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.botGasProjectilePosition != null), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 0.2 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                #Gas Clouds
                # botGasVisualIndex: gas-cloud visual index, to create each cloud and ring with a captured array index.
                #!define botGasVisualIndex tmp0
                for botGasVisualIndex in range(3):
                    #Cloud Effect
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.botGasPositionList[evalOnce(botGasVisualIndex)] != null), Effect.CLOUD, Color.LIME_GREEN, eventPlayer.botGasPositionList[evalOnce(botGasVisualIndex)], eventPlayer.botGasRadiusList[evalOnce(botGasVisualIndex)] + 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                    #Cloud Effect ring
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.botGasPositionList[evalOnce(botGasVisualIndex)] != null), Effect.RING, Color.LIME_GREEN, eventPlayer.botGasPositionList[evalOnce(botGasVisualIndex)], eventPlayer.botGasRadiusList[evalOnce(botGasVisualIndex)] + 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            else:
                #Roadhog toxic cloud
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.botGasCloudTimeRemaining > 0), Effect.CLOUD, Color.LIME_GREEN, eventPlayer, 10 * eventPlayer.sizeScale + 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.MERCY:
            #Mercy tentacle
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.botTentacleTargetPosition != 0), Beam.BAD, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.sizeScale if eventPlayer.isInAir() else eventPlayer.getEyePosition(), eventPlayer.botTentaclePosition, Color.LIME_GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            #Tentacle sound effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTentacleTargetPosition != 0), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer.botTentaclePosition, 400, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            #Tentacle end visual effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTentacleTargetPosition != 0), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.botTentaclePosition, 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bossStateList:
                #Ultimate lift aura
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingUltimate() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.GOOD_AURA, Color.BLACK, eventPlayer.getPosition(), 12 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                eventPlayer.startForcingHero(Hero.EMRE)
        elif eventPlayer.getHero() == Hero.WRECKING_BALL:
            #Ground strike location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botIsStrikerStrikeActive), Effect.RING, Color.TEAM_2, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + offsetDownHundredConst, getAllPlayers(), getAllPlayers(), false) if eventPlayer.botIsStrikerStrikeActive else evalOnce(offsetDownHundredConst), 1 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            eventPlayer.setMaxAmmo(0, 40)
        elif eventPlayer.getHero() == Hero.REAPER:
            if eventPlayer in miniBossList:
                eventPlayer.startForcingHero(Hero.JETPACK_CAT)
                eventPlayer.setMoveSpeed(90 * eventPlayer.movementSpeedScale)
                eventPlayer.disableEnvironmentCollision(false)
            #Boss Only
            if eventPlayer in bossStateList:
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingAbility1() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.BAD_AURA, Color.GRAY, eventPlayer.getPosition(), 12 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.WHITE, eventPlayer, 12 * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.PHARAH:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botBlasterCharge > 0), Effect.GOOD_AURA, Color.BLUE, eventPlayer, eventPlayer.botBlasterCharge * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.SIGMA:
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.TURQUOISE, eventPlayer.botTarget.getEyePosition(), 4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.ILLARI:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botDaytakerCharge > 0), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, eventPlayer.botDaytakerCharge * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.WINSTON:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isAlive() and not eventPlayer in bossStateList and eventPlayer.botSmolderState <= 1), Effect.GOOD_AURA, Color.RED, eventPlayer, eventPlayer.botSmolderAnger * eventPlayer.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bossStateList:
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: isSmolderEventActive), Effect.BAD_AURA, Color.BLACK, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 30, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: isSmolderEventActive), Effect.BAD_AURA, Color.RED, localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * (33 + evalOnce(random.uniform(-0.5, 0.5)))), 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.DOOMFIST:
            #Meteor strike/Seismic Slam location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1()), Effect.RING, Color.ORANGE, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + offsetDownHundredConst, getAllPlayers(), getAllPlayers(), false) if eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1() else evalOnce(offsetDownHundredConst), 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.botVisualEntityIdList.append(getLastCreatedEntity())


macro globalObjectiveEntityManagementMacro():
    objectiveValue = currentObjectiveType
    #Destroy all current objective effects and texts
    for objectiveVisualCleanupIndex in range(len(objectiveEntityIdList)):
        destroyProgressBarHud(objectiveEntityIdList[objectiveVisualCleanupIndex])
        destroyProgressBarInWorldText(objectiveEntityIdList[objectiveVisualCleanupIndex])
        destroyEffect(objectiveEntityIdList[objectiveVisualCleanupIndex])
        destroyHudText(objectiveEntityIdList[objectiveVisualCleanupIndex])
        destroyIcon(objectiveEntityIdList[objectiveVisualCleanupIndex])
        destroyInWorldText(objectiveEntityIdList[objectiveVisualCleanupIndex])
        wait()
    objectiveEntityIdList = []
    #Capture Point/Extraction Point
    if objectiveValue == ObjectiveType.SHOWDOWN:
        #Extraction Point
        if len(objectivePositionList) == 1:
            #Extraction distance
            createInWorldText(getAllPlayers().exclude(objectivePlayerList), "Distance: {0}m".format(distance(currentObjectivePosition, vect(localPlayer.getPosition().x, currentObjectivePosition.y, localPlayer.getPosition().z) if currentObjectivePosition.y - localPlayer.getEyePosition().y < 2 else localPlayer.getPosition())), currentObjectivePosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.SKY_BLUE, SpecVisibility.NEVER)
            objectiveEntityIdList.append(getLastCreatedText())
            #Extraction zone dome
            createEffect(getLivingPlayers(Team.1).filter(lambda _: extractionZoneRad < 200), Effect.SPHERE, Color.LIME_GREEN, currentObjectivePosition, extractionZoneRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntityIdList.append(getLastCreatedEntity())
            # extractionLightShaftLayerIndex: extraction light-shaft layer index, to select heights -2, 22 and 46.
            #!define extractionLightShaftLayerIndex tmp0
            for extractionLightShaftLayerIndex in range(3):
                createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, currentObjectivePosition + vect(0, [-2, 22, 46][extractionLightShaftLayerIndex], 0), objectiveRad, EffectReeval.VISIBILITY)
                objectiveEntityIdList.append(getLastCreatedEntity())
            #Extraction icon
            createIcon(getAllPlayers().exclude(objectivePlayerList), currentObjectivePosition + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.SKY_BLUE)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Extraction text
            createInWorldText(getAllPlayers().exclude(objectivePlayerList), "GET TO THE EXTRACTION POINT", currentObjectivePosition + vect(0, 5, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
            objectiveEntityIdList.append(getLastCreatedText())
        #Standoff
        else:
            #Objective distance
            createInWorldText(getAllPlayers().exclude(objectivePlayerList), "Distance: {0}m".format(distance(localPlayer.getPosition(), currentObjectivePosition)), currentObjectivePosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor, SpecVisibility.NEVER)
            objectiveEntityIdList.append(getLastCreatedText())
            #Zone Ring
            createEffect(localPlayer.filter(lambda _: localPlayer.getPosition().y > currentObjectivePosition.y + 4), Effect.RING, objectiveColor, currentObjectivePosition, objectiveRad)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Zone Ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, vect(currentObjectivePosition.x, localPlayer.getPosition().y, currentObjectivePosition.z), objectiveRad)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Objective boundary (Light Shaft)
            createEffect(objectivePlayerList, Effect.LIGHT_SHAFT, objectiveColor, currentObjectivePosition + vect(0, -30, 0), objectiveRad)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Objective beacon
            createEffect(getAllPlayers().filter(lambda _: len(objectivePlayerList) > 0), Effect.LIGHT_SHAFT, objectiveColor, currentObjectivePosition + vect(0, -10, 0), objectiveRad / 20)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Objective icon
            createIcon(getAllPlayers().exclude(objectivePlayerList), currentObjectivePosition + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_COLOR, objectiveColor)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Capture percentage text
            createInWorldText(objectivePlayerList, "CAPTURE PERCENTAGE: {0}%".format(floor(showdownCapturePercent)), currentObjectivePosition + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor)
            objectiveEntityIdList.append(getLastCreatedText())
            #Capture percentage hud text
            hudText(getAllPlayers(), "Capture Percentage: {0}%".format(floor(showdownCapturePercent)), "Objectives remaining: {0}".format(len(objectivePositionList) - 1), "{0} {2}".format("Allies: {0}".format(len(objectivePlayerList)) if len(objectivePlayerList) > 0 else [], null, "Foes: {0}".format(len(showdownContestingZombieList)) if len(showdownContestingZombieList) > 0 else []), HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            objectiveEntityIdList.append(getLastCreatedText())
    #Bosses
    elif objectiveValue == ObjectiveType.BOSSES:
        #Boss health progress bar
        progressBarHud(getAllPlayers().filter(lambda _: len(bossesStateList) > 0), bossesStateList[0].getNormalizedHealth() * 100, "Boss Health {0}".format(heroIcon(bossesStateList[0].getHero())), HudPosition.TOP, 2, Color.RED, Color.RED)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objectives remaining hud text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1) if objectiveTypeSetting != ObjectiveType.BIOMORPHING else "Giant Zombies Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedText())
        #Boss icon
        createIcon(getAllPlayers(), bossesStateList[0].getEyePosition() + Vector.UP if len(bossesStateList) > 0 else currentObjectivePosition, Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.RED)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Boss Distance
        createInWorldText(getAllPlayers().filter(lambda player: len(bossesStateList) == 0 or not player in bossesStateList[0].botPotentialTargetList), "Distance: {0}m".format(distance(localPlayer.getPosition(), bossesStateList[0].getPosition()) if len(bossesStateList) > 0 else distance(localPlayer.getPosition(), currentObjectivePosition)), bossesStateList[0].getPosition() if len(bossesStateList) > 0 else currentObjectivePosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntityIdList.append(getLastCreatedText())
    #Biomoprhing
    elif objectiveValue == ObjectiveType.BIOMORPHING:
        #Global progress bar
        hudText(getAllPlayers(), "{0} | {1}%".format(biomorphingGoalText, floor(biomorphingCapturePercent)), "Objectives remaining: {0}".format(len(objectivePositionList) - 1), null, HudPosition.TOP, 1, biomorphingGoalColor, objectiveColor, null, HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntityIdList.append(getLastCreatedText())
        #Collection type text
        hudSubheader(localPlayer.filter(lambda _: localPlayer.biomorphingResourceAmount > 0), "Turn in your health at the deposit area" if biomorphingGoalQueueList[0] == 3 else "You have a zombie {0}".format(biomorphingResourceNameList[localPlayer.biomorphingResourceType]), HudPosition.TOP, 2, biomorphingResourceColorList[localPlayer.biomorphingResourceType], HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntityIdList.append(getLastCreatedText())
        #Collection site icon
        createIcon(getPlayers(Team.1).filter(lambda player: player.biomorphingResourceAmount > 0 and not player in objectivePlayerList), currentObjectivePosition + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, objectiveColor)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Collection site ring
        createEffect(getPlayers(Team.1), Effect.RING, Color.WHITE, currentObjectivePosition + vect(0, -1, 0), objectiveRad, EffectReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Biowaste deposit site boundary (Light Shaft)
        createEffect(objectivePlayerList, Effect.LIGHT_SHAFT, biomorphingResourceColorList[localPlayer.biomorphingResourceType], currentObjectivePosition + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_AND_COLOR)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Depositing resources progress bar
        createProgressBarInWorldText(localPlayer.filter(lambda x: x in objectivePlayerList), ceil(localPlayer.getNormalizedHealth() * 100) if biomorphingGoalQueueList[0] == 3 else localPlayer.biomorphingResourceAmount / BIOMORPHING_RESOURCE_AMOUNT * 100, "Depositing Biowaste...", updateEveryFrame(localPlayer.getEyePosition() + (directionFromAngles(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) + 15))) if localPlayer in objectivePlayerList else evalOnce(localPlayer.getPosition()), 1, Clip.NONE, biomorphingResourceColorList[localPlayer.biomorphingResourceType], Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.NEVER)
        objectiveEntityIdList.append(getLastCreatedText())
        #Collection site distance (or closest resource distance)
        createInWorldText(localPlayer.filter(lambda x: not x in objectivePlayerList and (localPlayer.biomorphingResourceAmount > 0 or len(biomorphingResourcePositionList) > 0)), "Distance: {0}m".format(distance(currentObjectivePosition if localPlayer.biomorphingResourceAmount > 0 else sorted(biomorphingResourcePositionList, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], localPlayer.getPosition())), currentObjectivePosition if localPlayer.biomorphingResourceAmount > 0 else sorted(biomorphingResourcePositionList, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.NEVER)
        objectiveEntityIdList.append(getLastCreatedText())
    #Survivor Rescue
    elif objectiveValue == ObjectiveType.SURVIVOR_RESCUE:
        #Extraction site light shaft 2
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.VIOLET, currentObjectivePosition + vect(0, -2, 0), 5, EffectReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Objectives remaining text
        hudSubheader(getPlayers(Team.1), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.VIOLET, HudReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), rescueSurvivor[0].getPosition()) < objectiveRad and distance(player.getPosition(), currentObjectivePosition) > 5), currentObjectivePosition + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.VIOLET)
        objectiveEntityIdList.append(getLastCreatedEntity())
    #Killzone
    elif objectiveValue == ObjectiveType.KILL_ZONE:
        #Kill Zone Progress Bar
        progressBarHud(getAllPlayers(), killZoneEliminationScore / ELIMINATIONS_NEEDED_PER_OBJECTIVE * 100, "Kill Zone Elimination Progress", HudPosition.TOP, 2, Color.RED, Color.RED, ProgressHudReeval.VISIBILITY_AND_VALUES)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers().filter(lambda player: distance(player.getPosition(), killZoneCenter) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), killZoneCenter) - objectiveRad), killZoneCenter, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), killZoneCenter) > objectiveRad), killZoneCenter + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.RED)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Kill Zone Sphere
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), killZoneCenter) > objectiveRad), Effect.SPHERE, Color.GRAY, killZoneCenter, objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Kill Zone Ring
        createEffect(getAllPlayers(), Effect.RING, Color.RED, vect(killZoneCenter.x, localPlayer.getPosition().y, killZoneCenter.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - killZoneCenter.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Kill Zone light shaft
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), killZoneCenter) < objectiveRad), Effect.LIGHT_SHAFT, Color.RED, vect(killZoneCenter.x, localPlayer.getPosition().y + -29, killZoneCenter.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - killZoneCenter.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
    #Zombie Egg
    elif objectiveValue == ObjectiveType.ZOMBIE_EGG:
        #Zombie Egg Progress Bar
        progressBarHud(getAllPlayers().filter(lambda _: zombieEggStateList[0] != null), zombieEggStateList[0].getNormalizedHealth() * 100, "Zombie Egg Health", HudPosition.TOP, 2, Color.LIME_GREEN, Color.LIME_GREEN)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.LIME_GREEN, HudReeval.VISIBILITY)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers(), "Destroy: {0}m".format(distance(localPlayer.getPosition(), currentObjectivePosition)), currentObjectivePosition, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.LIME_GREEN, SpecVisibility.NEVER)
        objectiveEntityIdList.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers(), currentObjectivePosition + vect(0, 1, 0), Icon.RADIOACTIVE, IconReeval.VISIBILITY_AND_POSITION, Color.LIME_GREEN)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Egg visual
        createEffect(getAllPlayers().filter(lambda _: zombieEggStateList[0] != null), Effect.SPHERE, Color.LIME_GREEN, currentObjectivePosition, 2.5 + abs(0.5 * (sin(0.5 * getTotalTimeElapsed()))), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Egg toxic gas visual (stationary)
        createEffect(getAllPlayers(), Effect.CLOUD, Color.LIME_GREEN, currentObjectivePosition + vect(0, -1, 0), 25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
    #Satellite Uplink
    elif objectiveValue == ObjectiveType.SATELLITE_UPLINK:
        #Capture percentage hud text
        hudText(getAllPlayers(), "{0}% | {1}% | {2}%".format(floor(satelliteTerminalProgressList[0]), floor(satelliteTerminalProgressList[1]), floor(satelliteTerminalProgressList[2])), "Objectives remaining: {0}".format(len(objectivePositionList) - 1), [], HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_AND_STRING)
        objectiveEntityIdList.append(getLastCreatedText())
        #Fixing terminal light shaft
        createEffect(objectivePlayerList, Effect.LIGHT_SHAFT, objectiveColor, sorted(satelliteTerminalPositionList, lambda x: distance(localPlayer.getPosition(), x))[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntityIdList.append(getLastCreatedEntity())
        #Current terminal repair percentage
        createInWorldText(objectivePlayerList, "{0}%".format(floor(satelliteTerminalProgressList[satelliteTerminalPositionList.index(sorted(satelliteTerminalPositionList, lambda x: distance(localPlayer.getPosition(), x))[0])])), updateEveryFrame(localPlayer.getEyePosition() + ((directionFromAngles(localPlayer.getHorizontalFacingAngle(), localPlayer.getVerticalFacingAngle() + 15)) * 200)), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor)
        objectiveEntityIdList.append(getLastCreatedText())
        #Terminal effects
        # satelliteTerminalVisualIndex: terminal index, to create its icon, repair ring, screen and distance text.
        #!define satelliteTerminalVisualIndex tmp0
        for satelliteTerminalVisualIndex in range(len(satelliteTerminalProgressList)):
            #Terminal icon
            createIcon(getPlayers(Team.1).filter(lambda player: distance(player.getPosition(), satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)]) > objectiveRad and satelliteTerminalProgressList[evalOnce(satelliteTerminalVisualIndex)] < 100), satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)] + vect(0, 1, 0), Icon.BOLT, IconReeval.VISIBILITY_AND_POSITION, objectiveColor)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Terminal repair area ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)], objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Terminal "screen" light shaft
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, objectiveColor, satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)] + directionTowards(satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)], currentObjectivePosition) * objectiveRad * 0.8 + vect(0, -1.5, 0), 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntityIdList.append(getLastCreatedEntity())
            #Objective distance
            createInWorldText(getAllPlayers().filter(lambda player: satelliteTerminalProgressList[evalOnce(satelliteTerminalVisualIndex)] < 100 and distance(player.getPosition(), satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)]) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)])), satelliteTerminalPositionList[evalOnce(satelliteTerminalVisualIndex)], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor, SpecVisibility.NEVER)
            objectiveEntityIdList.append(getLastCreatedText())


def setDifficulty():
    @Name "setDifficulty"

    difficultySetting = len(getPlayers(Team.1).filter(lambda player: player.hasSpawned()))
    #Difficulty: Insanity
    if challengeSetting >= 4:
        #Bot Health Values
        botHealthList = numbersList.slice(NL_BOT_HEALTH_INSANITY_OFFSET, NL_BOT_HEALTH_INSANITY_LEN)
        #Bot bite damage
        botBiteDamageList = numbersList.slice(NL_BITE_DAMAGE_INSANITY_OFFSET, NL_BITE_DAMAGE_INSANITY_LEN)
        #Bot bite durations
        botBiteDurationList = numbersList.slice(NL_BITE_DURATIONS_INSANITY_OFFSET, NL_BITE_DURATIONS_INSANITY_LEN)
        #Bot throttle speeds
        botThrottleSpeedList = []
        # insanityThrottleHeroIndex: hero-entry counter, to fill all 21 Insanity throttle speeds with 1.
        #!define insanityThrottleHeroIndex tmp0
        for insanityThrottleHeroIndex in range(21):
            botThrottleSpeedList.append(1)
        #Bot damage dealt
        botDamageDealtList = numbersList.slice(NL_DAMAGE_DEALT_INSANITY_OFFSET, NL_DAMAGE_DEALT_INSANITY_LEN)
    else:
        #Message does not play if server is not 70 seconds old, this is a bad fix but I'm struggling to find a simple one.
        if getTotalTimeElapsed() < 100:
            goto lbl_0
        smallMessage(getAllPlayers(), " Difficulty adjusted for player count, change affects new zombies. ")
        lbl_0:
        #Shared HP for 1-4 players; only Winston (index 18) changes below.
        botHealthList = numbersList.slice(NL_BOT_HEALTH_BASE_OFFSET, NL_BOT_HEALTH_BASE_LEN)
        #Shared bite durations for 3+ players; 1 and 2 players override them.
        botBiteDurationList = numbersList.slice(NL_BITE_DURATIONS_BASE_OFFSET, NL_BITE_DURATIONS_BASE_LEN)
        #Difficulty: 1 Player "Normal"
        if difficultySetting == Difficulty.NORMAL:
            #Bot bite damage
            botBiteDamageList = numbersList.slice(NL_BITE_DAMAGE_NORMAL_OFFSET, NL_BITE_DAMAGE_NORMAL_LEN)
            #Bot bite durations
            botBiteDurationList = numbersList.slice(NL_BITE_DURATIONS_NORMAL_OFFSET, NL_BITE_DURATIONS_NORMAL_LEN)
            #Bot throttle speeds
            botThrottleSpeedList = numbersList.slice(NL_THROTTLE_SPEEDS_NORMAL_OFFSET, NL_THROTTLE_SPEEDS_NORMAL_LEN)
            #Bot damage dealt
            botDamageDealtList = numbersList.slice(NL_DAMAGE_DEALT_NORMAL_OFFSET, NL_DAMAGE_DEALT_NORMAL_LEN)
        #Difficulty: 2 Player "Hard"
        elif difficultySetting == Difficulty.HARD:
            #Bot Health Values
            botHealthList[18] = 750
            #Bot bite damage
            botBiteDamageList = numbersList.slice(NL_BITE_DAMAGE_HARD_OFFSET, NL_BITE_DAMAGE_HARD_LEN)
            #Bot bite durations
            botBiteDurationList = numbersList.slice(NL_BITE_DURATIONS_HARD_OFFSET, NL_BITE_DURATIONS_HARD_LEN)
            #Bot throttle speeds
            botThrottleSpeedList = numbersList.slice(NL_THROTTLE_SPEEDS_HARD_OFFSET, NL_THROTTLE_SPEEDS_HARD_LEN)
            #Bot damage dealt
            botDamageDealtList = numbersList.slice(NL_DAMAGE_DEALT_HARD_OFFSET, NL_DAMAGE_DEALT_HARD_LEN)
        #Difficulty: 5+ Player "Legendary"
        elif difficultySetting >= Difficulty.LEGENDARY:
            #Bot Health Values
            botHealthList = numbersList.slice(NL_BOT_HEALTH_LEGENDARY_OFFSET, NL_BOT_HEALTH_LEGENDARY_LEN)
            #Bot bite damage
            botBiteDamageList = numbersList.slice(NL_BITE_DAMAGE_LEGENDARY_OFFSET, NL_BITE_DAMAGE_LEGENDARY_LEN)
            #Bot throttle speeds
            botThrottleSpeedList = numbersList.slice(NL_THROTTLE_SPEEDS_LEGENDARY_OFFSET, NL_THROTTLE_SPEEDS_LEGENDARY_LEN)
            #Bot damage dealt
            botDamageDealtList = numbersList.slice(NL_DAMAGE_DEALT_LEGENDARY_OFFSET, NL_DAMAGE_DEALT_LEGENDARY_LEN)
        #Difficulty: 3-4 Player "Expert"
        else:
            #Bot Health Values
            botHealthList[18] = 1000
            #Bot bite damage
            botBiteDamageList = numbersList.slice(NL_BITE_DAMAGE_EXPERT_OFFSET, NL_BITE_DAMAGE_EXPERT_LEN)
            #Bot throttle speeds
            botThrottleSpeedList = numbersList.slice(NL_THROTTLE_SPEEDS_EXPERT_OFFSET, NL_THROTTLE_SPEEDS_EXPERT_LEN)
            #Bot damage dealt
            botDamageDealtList = numbersList.slice(NL_DAMAGE_DEALT_EXPERT_OFFSET, NL_DAMAGE_DEALT_EXPERT_LEN)


def setPrematchTimer():
    @Name "setPrematchTimer"

    #Cancel if hidden timer has not been set
    if not pregameCountdown:
        return
    #Voting in progress
    if isVoting:
        #Event player is voting
        if eventPlayer.isPregameVoting == true:
            #Set match time to hidden timer
            setMatchTime(pregameCountdown)
        #Event Player is not voting
        else:
            #All players are finished voting
            if getMatchTime() > 5 + VOTING_END_TIME and ((len(getPlayers(Team.1).filter(lambda player: player.isPregameVoting == false and player.pregameState > PregameState.SELECTING_HERO))) == getNumberOfPlayers(Team.1)):
                setMatchTime(5 + VOTING_END_TIME)
            elif getMatchTime() > 20 + VOTING_END_TIME and ((len(getPlayers(Team.1).filter(lambda player: player.isPregameVoting == false and player.pregameState > PregameState.SELECTING_HERO))) == len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive))):
                setMatchTime(20 + VOTING_END_TIME)
    #Voting complete
    else:
        #Event Player deselects hero
        if eventPlayer.pregameState < PregameState.READY:
            setMatchTime(pregameCountdown)
        else:
            if getMatchTime() > 10 and len(getPlayers(Team.1).filter(lambda player: player.pregameState == PregameState.READY)) == getNumberOfPlayers(Team.1):
                setMatchTime(15)
                wait()
                setMatchTime(10)
            elif getMatchTime() > 20 and len(getPlayers(Team.1).filter(lambda player: player.pregameState == PregameState.READY)) == len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive)):
                setMatchTime(20)


def enableDisableAbilities():
    @Name "enableDisableAbilities"

    if isPregameSetup:
        eventPlayer.disableHeroHud()
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.setSecondaryFireEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setAbility2Enabled(false)
        eventPlayer.setUltEnabled(false)
        eventPlayer.setMeleeEnabled(false)
    else:
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setMeleeEnabled(true)
        eventPlayer.enableHeroHud()


def objectivesManagement():
    @Name "objectivesManagement"

    if isGameplayActive:
        objectivePlayerList = []
        objectiveProgress = 0
        isSmolderEventActive = false
        objectiveNextCheckpoint = 0
        isBiomorphingGoalPending = false
        #Checks if current objective is showdown
        switch currentObjectiveType:
            case ObjectiveType.SHOWDOWN:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, currentObjectivePosition, objectiveRad * 2)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, currentObjectivePosition, 200)
                bigMessage(getAllPlayers(), "Showdown Conquered!")
                break
            #Checks if current objective is bosses
            case ObjectiveType.BOSSES:
                bigMessage(getAllPlayers(), "Giant zombie eliminated!")
                break
            #Checks if current objective is biomorphing
            case ObjectiveType.BIOMORPHING:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, currentObjectivePosition, objectiveRad)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ROSE, currentObjectivePosition, 200)
                bigMessage(getAllPlayers(), "Biomorphing completed!")
                break
            #Checks if current objective is survivor rescue
            case ObjectiveType.SURVIVOR_RESCUE:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.VIOLET, currentObjectivePosition, objectiveRad)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.VIOLET, currentObjectivePosition, 200)
                bigMessage(getAllPlayers(), "The survivors have been rescued!")
                break
            #Checks if current objective is kill zone
            case ObjectiveType.KILL_ZONE:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, killZoneCenter, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, killZoneCenter, objectiveRad * 2)
                bigMessage(getAllPlayers(), "The kill zone has been cleared!")
                break
            #Checks if current objective is Zombie Egg
            case ObjectiveType.ZOMBIE_EGG:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, currentObjectivePosition, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, currentObjectivePosition, objectiveRad * 2)
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, currentObjectivePosition, 3)
                bigMessage(getAllPlayers(), "The egg has been destroyed!")
                break
            #Checks if current objective is Satellite Uplink
            case ObjectiveType.SATELLITE_UPLINK:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, currentObjectivePosition, 200)
                bigMessage(getAllPlayers(), "Firing sequence complete!")
        wait()
        del objectivePositionList[0]
        currentObjectivePosition = objectivePositionList[0]
        del objectiveTypeList[0]
        currentObjectiveType = objectiveTypeList[0]
        bossStateList = []
        satelliteLaserTarget = null
    wait(0.25)
    if len(objectivePositionList) == 1:
        objectivePlayerList = []
        objectiveDescription = "Proceed to the extraction point"
        #Shrink extraction zone radius down to size of extraction point
        chaseAtRate(extractionZoneRad, 0, extractionSpeedUp)
        objectiveRad = 10
        bigMessage(getAllPlayers(), "Get to the extraction point!")
    else:
        switch currentObjectiveType:
            case ObjectiveType.SHOWDOWN:
                objectiveDescription = "Keep zombies away in the Showdown!"
                showdownCapturePercent = 0
                chaseAtRate(objectiveRad, max(5, showdownCapturePercent / 4), 1)
                objectiveColor = Color.ORANGE
                bigMessage(getAllPlayers(), "Proceed to the Showdown!")
                showdownNextCheckpoint = 25
                showdownContestingZombieList = []
                break
            case ObjectiveType.BOSSES:
                objectiveDescription = "Eliminate the boss"
                bigMessage(getAllPlayers(), "Eliminate the giant zombie!")
                break
            case ObjectiveType.BIOMORPHING:
                objectiveDescription = "Convert biowaste into powerups!"
                biomorphingCapturePercent = 0
                biomorphingResourcePositionList = []
                getAllPlayers().biomorphingResourceAmount = 0
                objectiveColor = rgb(135, 206, 250)
                objectiveRad = 3.5
                bigMessage(getAllPlayers(), "Find the indicated material and deposit it!")
                biomorphingResourceColorList = [Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE, Color.RED]
                biomorphingResourceNameList = ["Head", "Arm", "Leg"]
                biomorphingGoalQueueList = random.shuffle([0, 1, 2, 3])
                isBiomorphingGoalPending = true
                biomorphingNextCheckpoint = 25
                break
            case ObjectiveType.SURVIVOR_RESCUE:
                objectiveDescription = "Rescue survivors"
                rescueSurvivor = null
                objectiveRad = 10
                rescueSavedRadius = objectiveRad
                bigMessage(getAllPlayers(), "Locate survivors and bring them to the extraction site!")
                break
            case ObjectiveType.KILL_ZONE:
                objectiveDescription = "Clear the kill zone"
                objectiveRad = 20
                killZoneCenter = currentObjectivePosition
                bigMessage(getAllPlayers(), "Get to the kill zone and clear zombies!")
                killZoneEliminationScore = 0
                break
            case ObjectiveType.ZOMBIE_EGG:
                objectiveDescription = "Destroy the egg"
                objectiveRad = 0
                bigMessage(getAllPlayers(), "Destroy the zombie egg!")
                break
            case ObjectiveType.SATELLITE_UPLINK:
                objectiveDescription = "Repair satellite control terminals"
                objectiveRad = 3
                objectiveColor = rgb(28, 169, 201)
                satelliteTerminalPositionList = []
                satelliteTerminalProgressList = [0, 0, 0]
                #Initial terminal spacing
                satelliteMinTerminalSpacing = 50
                bigMessage(getAllPlayers(), "Repair the satellite control terminals!")
    #Updates global objective entities
    globalObjectiveEntityManagementMacro()
    isObjectiveComplete = false


def selectTarget():
    @Name "selectTarget"
    
    eventPlayer.botIsSelectingTarget = true
    # botSelectionCandidateList: per-call target calculations; preserve the final snapshot below for the boss distance text.
    #!define botSelectionCandidateList tmp1
    botSelectionCandidateList = []
    #Miniboss prioritizes players on objective
    if eventPlayer in miniBossList:
        botSelectionCandidateList.append(objectivePlayerList.filter(lambda x: not x.isDummy()))
    #Prioitize dummy bots
    botSelectionCandidateList.append(playerTargetList.filter(lambda x: x.isDummy()))
    #For projectile firing heroes
    if not eventPlayer in bossStateList and eventPlayer.getHero() == Hero.PHARAH:
        #Players in Air
        botSelectionCandidateList.append(playerTargetList.filter(lambda x: distance(x.getPosition(), nearestWalkablePosition(x.getPosition())) > 5))
    #Add players who are below bot to target list
    botSelectionCandidateList.append(sorted(playerTargetList.exclude(botSelectionCandidateList).filter(lambda x: x.getPosition().y - eventPlayer.getPosition().y < 2.5), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Add remaining players
    botSelectionCandidateList.append(sorted(playerTargetList.exclude(botSelectionCandidateList), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Remove invisible players
    botSelectionCandidateList = botSelectionCandidateList.filter(lambda x: not x.invisibilityCount)
    #The reevaluated boss distance-text visibility reads this per-bot snapshot after this call returns.
    eventPlayer.botPotentialTargetList = botSelectionCandidateList
    # botSelectionCandidateIndex: candidate-target index, to select the first target visible to this bot.
    #!define botSelectionCandidateIndex tmp0
    for botSelectionCandidateIndex in range(len(botSelectionCandidateList)):
        eventPlayer.botCandidateTarget = botSelectionCandidateList[botSelectionCandidateIndex]
        if isInLoS(eventPlayer.botCandidateTarget.getEyePosition(), eventPlayer.getPosition() + losOffsetConst):
            break
        #wait()
    if eventPlayer.isAlive():
        eventPlayer.botTarget = eventPlayer.botCandidateTarget
        eventPlayer.botLastTarget = eventPlayer.botTarget
        startRule(restoreDefaultFacingMovement)
    eventPlayer.botIsSelectingTarget = false


def restoreDefaultFacingMovement():
    @Name "restoreDefaultFacingMovement"
    
    if eventPlayer.botTarget != null:
        if not eventPlayer.botIsFacingOverridden:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), 1500 if eventPlayer.botIsAttached else 0 if eventPlayer.isCrowdControlled else 100)
        if not eventPlayer.botIsThrottleOverridden:
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed if distance(eventPlayer.getPosition(), vect(eventPlayer.botTarget.getPosition().x, eventPlayer.getPosition().y, eventPlayer.botTarget.getPosition().z)) > 2 * min(1, eventPlayer.sizeScale) else 0, Relativity.TO_WORLD)
    else:
        eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)


def botRespawnInitialization():
    @Name "botRespawnInitialization"
    
    eventPlayer.botIsInitializing = true
    if eventPlayer in bossStateList:
        eventPlayer.disableNameplatesFor(getAllPlayers())
        eventPlayer.botBaseHealth = 0
        eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    else:
        eventPlayer.enableNameplatesFor(getAllPlayers())
        eventPlayer.sizeScale = createWorkshopSettingFloat("Zombies", "Zombie Size", 1, 0, 20)
        eventPlayer.botBaseHealth = botHealthList[botHeroList.index(eventPlayer.getHero())]
        #Scale zombie voice lines with size
        eventPlayer.startModifyingVoicelinePitch(0.5 + (1 / (eventPlayer.sizeScale + 1)) + 0.25 * (sinDeg(getTotalTimeElapsed() * evalOnce(random.uniform(360, 720)))))
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.botIsWallCollisionEnabled = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.botIsAttached = false
    eventPlayer.botIsFacingOverridden = false
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsWallPhaseAllowed = true
    eventPlayer.isCrowdControlled = false
    eventPlayer.botAbilityState = null
    eventPlayer.botAuxiliaryState = null
    eventPlayer.botAbilityTarget = null
    eventPlayer.botIsSelectingTarget = false
    eventPlayer.botBossHealth = -1
    #Chance for a minboss on high difficulties
    if difficultySetting >= Difficulty.EXPERT and eventPlayer in bossStateList == false and len(miniBossList.filter(lambda x: entityExists(x))) == 0:
        # minibossPromotionRoll: miniboss promotion roll, consumed before the possible initialization wait.
        #!define minibossPromotionRoll tmp0
        minibossPromotionRoll = random.randint(1, 27 if currentObjectiveType == ObjectiveType.SHOWDOWN else 189)
        if minibossPromotionRoll == 1:
            minibossMutationMacro()
            wait(2)
    botStatManagementMacro()
    if eventPlayer in miniBossList == true:
        goto lbl_0
    mutationsMacro()
    lbl_0:
    eventPlayer.startScalingSize(eventPlayer.sizeScale, false)
    botEntityManagementMacro()
    waitUntil(eventPlayer.getHealth() >= eventPlayer.botBaseHealth, 5)
    eventPlayer.stopAllHealingOverTime()
    eventPlayer.setHealth(eventPlayer.botBaseHealth)
    eventPlayer.botIsInitializing = false


def abilityPlacement():
    @Name "abilityPlacement"
    
    wait(0.5)
    if eventPlayer.isCrowdControlled == true:
        return
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 1.6)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == true, 1)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) == true:
        wait(1)
        eventPlayer.forceButtonPress(Button.INTERACT)
    else:
        eventPlayer.cancelPrimaryAction()


def explosionSequence():
    @Name "explosionSequence"
    
    eventPlayer.explosionTargetList = getPlayers(Team.2) if not eventPlayer.isDummy() else getAllPlayers().filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < eventPlayer.explosionScale * 6 and (isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) if eventPlayer.isDummy() else true))
    #Scaled
    damage(eventPlayer.explosionTargetList, eventPlayer, eventPlayer.botBiteDamage * 2.5 if eventPlayer.isDummy() else eventPlayer.infectionLevel * 100)
    if eventPlayer.isDummy():
        #Scaled
        damage(eventPlayer.explosionTargetList.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 3 * eventPlayer.sizeScale), eventPlayer, eventPlayer.botBiteDamage * 5)
        #Scaled
        eventPlayer.explosionTargetList.setStatusEffect(eventPlayer, Status.BURNING, 3)
        #Not scaled damage
        eventPlayer.explosionTargetList.startDamageOverTime(eventPlayer, 3, eventPlayer.botBiteDamage * 2)
        if eventPlayer.damageOverTimeRemaining < 3:
            eventPlayer.damageOverTimeRemaining = 3
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionOuterColor, eventPlayer.getPosition(), 6 * eventPlayer.explosionScale)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionInnerColor, eventPlayer.getPosition(), 3 * eventPlayer.explosionScale)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionScale)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionScale)
    wait(0.25)


def illariUlt():
    @Name "DAYTAKER'S REVENGE (BOSS)"
    
    eventPlayer.botAbilityTarget.detach()
    eventPlayer.botAbilityTarget.isAttached = false
    eventPlayer.botAbilityTarget = null
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    eventPlayer.setUltCharge(100)
    wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.movementSpeedScale /= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
    wait(1.5)
    if eventPlayer.isDead():
        return
    if eventPlayer == eventPlayer.hasStatus(Status.HACKED):
        goto lbl_0
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    lbl_0:
    waitUntil(eventPlayer.isUsingUltimate(), false)
    eventPlayer.movementSpeedScale *= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100)
