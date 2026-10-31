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
    miniBoss.append(eventPlayer)
    eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN, Hero.DOOMFIST, Hero.KIRIKO, Hero.MAUGA, Hero.HAZARD, Hero.REAPER]))
    if zombieSetting == 6:
        eventPlayer.startForcingHero(random.choice([Hero.REINHARDT, Hero.WRECKING_BALL]))
    eventPlayer.health = 2500
    eventPlayer.size *= 1.55
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE)
    eventPlayer.startForcingName("Contestor")
    #Skull Icon
    createIcon(getAllPlayers().filter(lambda _: eventPlayer.initializing == false and eventPlayer in bosses == false), eventPlayer.getEyePosition() + Vector.UP, Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.ORANGE)
    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())


macro botStatManagementMacro():
    # tmp0: current bot hero's table index, to look up bite, movement and damage settings without repeating the hero search.
    tmp0 = botHeros.index(eventPlayer.getHero())
    eventPlayer.biteDamage = biteDamages[tmp0]
    #Re-calibrate bite damage
    eventPlayer.biteDamage *= 100 / damageDealt[tmp0]
    eventPlayer.biteDuration = biteDurations[tmp0]
    #Range from 0 to 1 in terms of throttle
    eventPlayer.botThrottleSpeed = throttleSpeeds[tmp0]
    # tmp0: normalized damage multiplier; the hero index is no longer needed after this lookup.
    tmp0 = damageDealt[tmp0] / 100
    eventPlayer.setDamageDealt(tmp0 * 100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.movementSpeed = 1
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100 + ((len(getDeadPlayers(Team.1).filter(lambda player: player.deathTimer <= 0))) * 3))
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.knockbackRecieved = 1
    eventPlayer.setKnockbackReceived(100)
    if eventPlayer.getHero() == Hero.REINHARDT:
        eventPlayer.knockbackRecieved = 0.7
        eventPlayer.setKnockbackReceived(100 * eventPlayer.knockbackRecieved)
    elif eventPlayer.getHero() == Hero.MERCY:
        eventPlayer.setProjectileSpeed(75 if eventPlayer in bosses else 20)
    elif eventPlayer.getHero() == Hero.ILLARI:
        eventPlayer.setKnockbackDealt(25)
    elif eventPlayer.getHero() == Hero.WINSTON:
        eventPlayer.size *= 0.7
        eventPlayer.chase1 = 2
        eventPlayer.startScalingBarriers(eventPlayer.size)
    elif eventPlayer.getHero() == Hero.ANA or eventPlayer.getHero() == Hero.KIRIKO:
        eventPlayer.setProjectileGravity(500)
    elif eventPlayer.getHero() == Hero.SIGMA:
        eventPlayer.setProjectileSpeed(100 * eventPlayer.size * 0.5)
        eventPlayer.setPrimaryFireEnabled(true)
    elif eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.setKnockbackDealt(120)
    elif eventPlayer.getHero() == Hero.HAZARD:
        chaseAtRate(eventPlayer.abilityArray1, 0, 1)
    elif eventPlayer.getHero() == Hero.ANRAN:
        eventPlayer.setKnockbackDealt(150)


macro mutationsMacro():
    #Zombies have a chance to mutate. Bosses cannot mutate
    if len(availableMutations) > 0 and not eventPlayer in bosses and (random.uniform(0, 100) < (100 if challengeSetting == 3 or challengeSetting == 5 else createWorkshopSettingFloat("Mutations", "Chance to mutate percentage", 25, 0, 100))):
        eventPlayer.mutationValue = random.choice(availableMutations)
        #Speed
        if eventPlayer.mutationValue == 1:
            eventPlayer.movementSpeed *= 1.5
            eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
            eventPlayer.defaultOutlineColor = Color.PURPLE
            eventPlayer.startForcingName("SPEED")
        #Size Growth
        elif eventPlayer.mutationValue == 2:
            eventPlayer.size *= 1.5
            eventPlayer.health *= eventPlayer.size
            eventPlayer.defaultOutlineColor = Color.VIOLET
            eventPlayer.startForcingName("XL")
        #Size Reduction
        elif eventPlayer.mutationValue == 3:
            eventPlayer.size *= 0.6
            eventPlayer.health *= eventPlayer.size
            eventPlayer.defaultOutlineColor = Color.ROSE
            eventPlayer.startForcingName("XS")
        #Radioactive
        elif eventPlayer.mutationValue == 4:
            eventPlayer.biteDuration *= 1.5
            eventPlayer.defaultOutlineColor = Color.LIME_GREEN
            eventPlayer.startForcingName("Radioactive")
        #Heavy
        elif eventPlayer.mutationValue == 5:
            eventPlayer.knockbackRecieved *= 0.5
            eventPlayer.setKnockbackReceived(100 * eventPlayer.knockbackRecieved)
            #Scale move speed
            eventPlayer.movementSpeed *= eventPlayer.knockbackRecieved
            eventPlayer.setMoveSpeed(100 * eventPlayer.movementSpeed)
            #Scale health
            eventPlayer.health /= eventPlayer.knockbackRecieved
            eventPlayer.defaultOutlineColor = Color.BLACK
            eventPlayer.startForcingName("Heavy")
        #Mutation outline for players
        eventPlayer.startForcingOutlineFor(getAllPlayers(), true, eventPlayer.defaultOutlineColor)
    else:
        eventPlayer.mutationValue = 0
        eventPlayer.defaultOutlineColor = null
        #Default ouline for players
        eventPlayer.stopForcingOutlineFor(getAllPlayers())
        eventPlayer.stopForcingName()


macro botEntityManagementMacro():
    if eventPlayer.botHero != eventPlayer.getHero() or eventPlayer in bosses:
        eventPlayer.botHero = eventPlayer.getHero()
        #Destroy all current hero effects and texts
        for eventPlayer.entityCount in range(len(eventPlayer.generalPlayerBotEntities)):
            destroyEffect(eventPlayer.generalPlayerBotEntities[eventPlayer.entityCount])
            wait()
        eventPlayer.explosionColor1 = Color.YELLOW
        eventPlayer.explosionColor2 = Color.ORANGE
        eventPlayer.generalPlayerBotEntities = []
        if eventPlayer.getHero() == Hero.ROADHOG:
            eventPlayer.setHealingReceived(30)
            if eventPlayer in bosses:
                #Gas Projectile 1
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 != null), Effect.BAD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.4 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Gas Projectile 2
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 != null), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.2 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Gas Clouds
                # tmp0: gas-cloud visual index, to create each cloud and ring with a captured array index.
                for tmp0 in range(3):
                    #Cloud Effect
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.abilityArray1[evalOnce(tmp0)] != null), Effect.CLOUD, Color.LIME_GREEN, eventPlayer.abilityArray1[evalOnce(tmp0)], eventPlayer.abilityArray2[evalOnce(tmp0)] + 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                    #Cloud Effect ring
                    createEffect(getAllPlayers().filter(lambda _: eventPlayer.abilityArray1[evalOnce(tmp0)] != null), Effect.RING, Color.LIME_GREEN, eventPlayer.abilityArray1[evalOnce(tmp0)], eventPlayer.abilityArray2[evalOnce(tmp0)] + 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            else:
                #Roadhog toxic cloud
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase2 > 0), Effect.CLOUD, Color.LIME_GREEN, eventPlayer, 10 * eventPlayer.size + 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.MERCY:
            #Mercy tentacle
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Beam.BAD, eventPlayer.getEyePosition() + offsetUpHalfConst * eventPlayer.size if eventPlayer.isInAir() else eventPlayer.getEyePosition(), eventPlayer.chase1, Color.LIME_GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Tentacle sound effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer.chase1, 400, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Tentacle end visual effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue != 0), Effect.GOOD_AURA, Color.LIME_GREEN, eventPlayer.chase1, 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bosses:
                #Ultimate lift aura
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingUltimate() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.GOOD_AURA, Color.BLACK, eventPlayer.getPosition(), 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                eventPlayer.startForcingHero(Hero.EMRE)
        elif eventPlayer.getHero() == Hero.WRECKING_BALL:
            #Ground strike location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.botTempValue), Effect.RING, Color.TEAM_2, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + vect(0, -100, 0), getAllPlayers(), getAllPlayers(), false) if eventPlayer.botTempValue else evalOnce(vect(0, -100, 0)), 1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            eventPlayer.setMaxAmmo(0, 40)
        elif eventPlayer.getHero() == Hero.REAPER:
            if eventPlayer in miniBoss:
                eventPlayer.startForcingHero(Hero.JETPACK_CAT)
                eventPlayer.setMoveSpeed(90 * eventPlayer.movementSpeed)
                eventPlayer.disableEnvironmentCollision(false)
            #Boss Only
            if eventPlayer in bosses:
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda player: eventPlayer.isUsingAbility1() and player.isInViewAngle(eventPlayer.getPosition(), 60)), Effect.BAD_AURA, Color.GRAY, eventPlayer.getPosition(), 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Using Wraith Form
                createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.WHITE, eventPlayer, 12 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.PHARAH:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 > 0), Effect.GOOD_AURA, Color.BLUE, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.SIGMA:
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingAbility1()), Effect.CLOUD, Color.TURQUOISE, eventPlayer.botTarget.getEyePosition(), 4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.ILLARI:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.chase1 > 0), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.WINSTON:
            #Charging attack effect
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isAlive() and not eventPlayer in bosses and eventPlayer.botTempValue <= 1), Effect.GOOD_AURA, Color.RED, eventPlayer, eventPlayer.chase1 * eventPlayer.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
            #Boss only
            if eventPlayer in bosses:
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: gameSmolderEvent), Effect.BAD_AURA, Color.BLACK, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 30, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
                #Darkness visual
                createEffect(getAllPlayers().filter(lambda _: gameSmolderEvent), Effect.BAD_AURA, Color.RED, localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * (33 + evalOnce(random.uniform(-0.5, 0.5)))), 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())
        elif eventPlayer.getHero() == Hero.DOOMFIST:
            #Meteor strike/Seismic Slam location
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1()), Effect.RING, Color.ORANGE, raycastHitPosition(eventPlayer.getPosition(), eventPlayer.getPosition() + vect(0, -100, 0), getAllPlayers(), getAllPlayers(), false) if eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1() else evalOnce(vect(0, -100, 0)), 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.generalPlayerBotEntities.append(getLastCreatedEntity())


macro globalObjectiveEntityManagementMacro():
    objectiveValue = objectiveTypes[0]
    #Destroy all current objective effects and texts
    for objectiveEntitiesCount in range(len(objectiveEntities)):
        destroyProgressBarHud(objectiveEntities[objectiveEntitiesCount])
        destroyProgressBarInWorldText(objectiveEntities[objectiveEntitiesCount])
        destroyEffect(objectiveEntities[objectiveEntitiesCount])
        destroyHudText(objectiveEntities[objectiveEntitiesCount])
        destroyIcon(objectiveEntities[objectiveEntitiesCount])
        destroyInWorldText(objectiveEntities[objectiveEntitiesCount])
        wait()
    objectiveEntities = []
    #Capture Point/Extraction Point
    if objectiveValue == 1:
        #Extraction Point
        if len(objectivePositions) == 1:
            #Extraction distance
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "Distance: {0}m".format(distance(objectivePositions[0], vect(localPlayer.getPosition().x, objectivePositions[0].y, localPlayer.getPosition().z) if objectivePositions[0].y - localPlayer.getEyePosition().y < 2 else localPlayer.getPosition())), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.SKY_BLUE, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())
            #Extraction zone dome
            createEffect(getLivingPlayers(Team.1).filter(lambda _: extractionZoneRad < 200), Effect.SPHERE, Color.LIME_GREEN, objectivePositions[0], extractionZoneRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            # tmp0: extraction light-shaft layer index, to select heights -2, 22 and 46.
            for tmp0 in range(3):
                createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, objectivePositions[0] + vect(0, [-2, 22, 46][tmp0], 0), objectiveRad, EffectReeval.VISIBILITY)
                objectiveEntities.append(getLastCreatedEntity())
            #Extraction icon
            createIcon(getAllPlayers().exclude(playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.SKY_BLUE)
            objectiveEntities.append(getLastCreatedEntity())
            #Extraction text
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "GET TO THE EXTRACTION POINT", objectivePositions[0] + vect(0, 5, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE)
            objectiveEntities.append(getLastCreatedText())
        #Standoff
        else:
            #Objective distance
            createInWorldText(getAllPlayers().exclude(playersOnObjective), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectivePositions[0])), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())
            #Zone Ring
            createEffect(localPlayer.filter(lambda _: localPlayer.getPosition().y > objectivePositions[0].y + 4), Effect.RING, objectiveColor, objectivePositions[0], objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Zone Ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, vect(objectivePositions[0].x, localPlayer.getPosition().y, objectivePositions[0].z), objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective boundary (Light Shaft)
            createEffect(playersOnObjective, Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -30, 0), objectiveRad)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective beacon
            createEffect(getAllPlayers().filter(lambda _: len(playersOnObjective) > 0), Effect.LIGHT_SHAFT, objectiveColor, objectivePositions[0] + vect(0, -10, 0), objectiveRad / 20)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective icon
            createIcon(getAllPlayers().exclude(playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedEntity())
            #Capture percentage text
            createInWorldText(playersOnObjective, "CAPTURE PERCENTAGE: {0}%".format(floor(objectiveCaptureValue)), objectivePositions[0] + vect(0, 1, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, objectiveColor)
            objectiveEntities.append(getLastCreatedText())
            #Capture percentage hud text
            hudText(getAllPlayers(), "Capture Percentage: {0}%".format(floor(objectiveCaptureValue)), "Objectives remaining: {0}".format(len(objectivePositions) - 1), "{0} {2}".format("Allies: {0}".format(len(playersOnObjective)) if len(playersOnObjective) > 0 else [], null, "Foes: {0}".format(len(queuedGoalType)) if len(queuedGoalType) > 0 else []), HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            objectiveEntities.append(getLastCreatedText())
    #Bosses
    elif objectiveValue == 2:
        #Boss health progress bar
        progressBarHud(getAllPlayers().filter(lambda _: len(bosses) > 0), bosses[0].getNormalizedHealth() * 100, "Boss Health {0}".format(heroIcon(bosses[0].getHero())), HudPosition.TOP, 2, Color.RED, Color.RED)
        objectiveEntities.append(getLastCreatedText())
        #Objectives remaining hud text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1) if objectiveTypeSetting != 3 else "Giant Zombies Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Boss icon
        createIcon(getAllPlayers(), bosses[0].getEyePosition() + Vector.UP if len(bosses) > 0 else objectivePositions[0], Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.RED)
        objectiveEntities.append(getLastCreatedEntity())
        #Boss Distance
        createInWorldText(getAllPlayers().filter(lambda player: len(bosses) == 0 or not player in bosses[0].potentialTargets), "Distance: {0}m".format(distance(localPlayer.getPosition(), bosses[0].getPosition()) if len(bosses) > 0 else distance(localPlayer.getPosition(), objectivePositions[0])), bosses[0].getPosition() if len(bosses) > 0 else objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
    #Biomoprhing
    elif objectiveValue == 3:
        #Global progress bar
        hudText(getAllPlayers(), "{0} | {1}%".format(goalText, floor(objectiveCaptureValue)), "Objectives remaining: {0}".format(len(objectivePositions) - 1), null, HudPosition.TOP, 1, goalColor, objectiveColor, null, HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntities.append(getLastCreatedText())
        #Collection type text
        hudSubheader(localPlayer.filter(lambda _: localPlayer.playerObjectiveResourceValue > 0), "Turn in your health at the deposit area" if queuedGoalType[0] == 3 else "You have a zombie {0}".format(biowasteTextLookUp[localPlayer.biowasteType]), HudPosition.TOP, 2, biowasteColorLookUp[localPlayer.biowasteType], HudReeval.VISIBILITY_STRING_AND_COLOR)
        objectiveEntities.append(getLastCreatedText())
        #Collection site icon
        createIcon(getPlayers(Team.1).filter(lambda player: player.playerObjectiveResourceValue > 0 and not player in playersOnObjective), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, objectiveColor)
        objectiveEntities.append(getLastCreatedEntity())
        #Collection site ring
        createEffect(getPlayers(Team.1), Effect.RING, Color.WHITE, objectivePositions[0] + vect(0, -1, 0), objectiveRad, EffectReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedEntity())
        #Biowaste deposit site boundary (Light Shaft)
        createEffect(playersOnObjective, Effect.LIGHT_SHAFT, biowasteColorLookUp[localPlayer.biowasteType], objectivePositions[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_AND_COLOR)
        objectiveEntities.append(getLastCreatedEntity())
        #Depositing resources progress bar
        createProgressBarInWorldText(localPlayer.filter(lambda x: x in playersOnObjective), ceil(localPlayer.getNormalizedHealth() * 100) if queuedGoalType[0] == 3 else localPlayer.playerObjectiveResourceValue / amountPerResource * 100, "Depositing Biowaste...", updateEveryFrame(localPlayer.getEyePosition() + (directionFromAngles(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) + 15))) if localPlayer in playersOnObjective else evalOnce(localPlayer.getPosition()), 1, Clip.NONE, biowasteColorLookUp[localPlayer.biowasteType], Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Collection site distance (or closest resource distance)
        createInWorldText(localPlayer.filter(lambda x: not x in playersOnObjective and (localPlayer.playerObjectiveResourceValue > 0 or len(objectiveResourcePositions) > 0)), "Distance: {0}m".format(distance(objectivePositions[0] if localPlayer.playerObjectiveResourceValue > 0 else sorted(objectiveResourcePositions, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], localPlayer.getPosition())), objectivePositions[0] if localPlayer.playerObjectiveResourceValue > 0 else sorted(objectiveResourcePositions, lambda x: angleBetweenVectors(directionTowards(localPlayer.getEyePosition(), x), localPlayer.getFacingDirection()))[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
    #Survivor Rescue
    elif objectiveValue == 4:
        #Extraction site light shaft 2
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.VIOLET, objectivePositions[0] + vect(0, -2, 0), 5, EffectReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedEntity())
        #Objectives remaining text
        hudSubheader(getPlayers(Team.1), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.VIOLET, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), survivorToRescue[0].getPosition()) < objectiveRad and distance(player.getPosition(), objectivePositions[0]) > 5), objectivePositions[0] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.VIOLET)
        objectiveEntities.append(getLastCreatedEntity())
    #Killzone
    elif objectiveValue == 5:
        #Kill Zone Progress Bar
        progressBarHud(getAllPlayers(), objectiveCaptureValue / eliminationsNeededPerObjective * 100, "Kill Zone Elimination Progress", HudPosition.TOP, 2, Color.RED, Color.RED, ProgressHudReeval.VISIBILITY_AND_VALUES)
        objectiveEntities.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.RED, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectiveChase1) - objectiveRad), objectiveChase1, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), objectiveChase1 + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.RED)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone Sphere
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) > objectiveRad), Effect.SPHERE, Color.GRAY, objectiveChase1, objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone Ring
        createEffect(getAllPlayers(), Effect.RING, Color.RED, vect(objectiveChase1.x, localPlayer.getPosition().y, objectiveChase1.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - objectiveChase1.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Kill Zone light shaft
        createEffect(getAllPlayers().filter(lambda player: distance(player.getPosition(), objectiveChase1) < objectiveRad), Effect.LIGHT_SHAFT, Color.RED, vect(objectiveChase1.x, localPlayer.getPosition().y + -29, objectiveChase1.z), sqrt(objectiveRad ** 2 - ((abs(localPlayer.getPosition().y - objectiveChase1.y)) ** 2)), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
    #Zombie Egg
    elif objectiveValue == 6:
        #Zombie Egg Progress Bar
        progressBarHud(getAllPlayers().filter(lambda _: bosses[0] != null), bosses[0].getNormalizedHealth() * 100, "Zombie Egg Health", HudPosition.TOP, 2, Color.LIME_GREEN, Color.LIME_GREEN)
        objectiveEntities.append(getLastCreatedText())
        #Objectives Remaining Hud Text
        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositions) - 1), HudPosition.TOP, 1, Color.LIME_GREEN, HudReeval.VISIBILITY)
        objectiveEntities.append(getLastCreatedText())
        #Objective distance
        createInWorldText(getAllPlayers(), "Destroy: {0}m".format(distance(localPlayer.getPosition(), objectivePositions[0])), objectivePositions[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.LIME_GREEN, SpecVisibility.NEVER)
        objectiveEntities.append(getLastCreatedText())
        #Objective icon
        createIcon(getAllPlayers(), objectivePositions[0] + vect(0, 1, 0), Icon.RADIOACTIVE, IconReeval.VISIBILITY_AND_POSITION, Color.LIME_GREEN)
        objectiveEntities.append(getLastCreatedEntity())
        #Egg visual
        createEffect(getAllPlayers().filter(lambda _: bosses[0] != null), Effect.SPHERE, Color.LIME_GREEN, objectivePositions[0], 2.5 + abs(0.5 * (sin(0.5 * getTotalTimeElapsed()))), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Egg toxic gas visual (stationary)
        createEffect(getAllPlayers(), Effect.CLOUD, Color.LIME_GREEN, objectivePositions[0] + vect(0, -1, 0), 25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
    #Satellite Uplink
    elif objectiveValue == 7:
        #Capture percentage hud text
        hudText(getAllPlayers(), "{0}% | {1}% | {2}%".format(floor(objectiveCaptureValue[0]), floor(objectiveCaptureValue[1]), floor(objectiveCaptureValue[2])), "Objectives remaining: {0}".format(len(objectivePositions) - 1), [], HudPosition.TOP, 1, objectiveColor, objectiveColor, objectiveColor, HudReeval.VISIBILITY_AND_STRING)
        objectiveEntities.append(getLastCreatedText())
        #Fixing terminal light shaft
        createEffect(playersOnObjective, Effect.LIGHT_SHAFT, objectiveColor, sorted(objectiveResourcePositions, lambda x: distance(localPlayer.getPosition(), x))[0] + vect(0, -2, 0), objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        objectiveEntities.append(getLastCreatedEntity())
        #Current terminal repair percentage
        createInWorldText(playersOnObjective, "{0}%".format(floor(objectiveCaptureValue[objectiveResourcePositions.index(sorted(objectiveResourcePositions, lambda x: distance(localPlayer.getPosition(), x))[0])])), updateEveryFrame(localPlayer.getEyePosition() + ((directionFromAngles(localPlayer.getHorizontalFacingAngle(), localPlayer.getVerticalFacingAngle() + 15)) * 200)), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor)
        objectiveEntities.append(getLastCreatedText())
        #Terminal effects
        # tmp0: terminal index, to create its icon, repair ring, screen and distance text.
        for tmp0 in range(len(objectiveCaptureValue)):
            #Terminal icon
            createIcon(getPlayers(Team.1).filter(lambda player: distance(player.getPosition(), objectiveResourcePositions[evalOnce(tmp0)]) > objectiveRad and objectiveCaptureValue[evalOnce(tmp0)] < 100), objectiveResourcePositions[evalOnce(tmp0)] + vect(0, 1, 0), Icon.BOLT, IconReeval.VISIBILITY_AND_POSITION, objectiveColor)
            objectiveEntities.append(getLastCreatedEntity())
            #Terminal repair area ring
            createEffect(getAllPlayers(), Effect.RING, objectiveColor, objectiveResourcePositions[evalOnce(tmp0)], objectiveRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            #Terminal "screen" light shaft
            createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, objectiveColor, objectiveResourcePositions[evalOnce(tmp0)] + directionTowards(objectiveResourcePositions[evalOnce(tmp0)], objectivePositions[0]) * objectiveRad * 0.8 + vect(0, -1.5, 0), 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            objectiveEntities.append(getLastCreatedEntity())
            #Objective distance
            createInWorldText(getAllPlayers().filter(lambda player: objectiveCaptureValue[evalOnce(tmp0)] < 100 and distance(player.getPosition(), objectiveResourcePositions[evalOnce(tmp0)]) > objectiveRad), "Distance: {0}m".format(distance(localPlayer.getPosition(), objectiveResourcePositions[evalOnce(tmp0)])), objectiveResourcePositions[evalOnce(tmp0)], 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, objectiveColor, SpecVisibility.NEVER)
            objectiveEntities.append(getLastCreatedText())


def setDifficulty():
    @Name "setDifficulty"

    difficultySetting = len(getPlayers(Team.1).filter(lambda player: player.hasSpawned()))
    #Difficulty: Insanity
    if challengeSetting >= 4:
        #Bot Health Values
        botHealthValues = numbersList.slice(NL_BOT_HEALTH_INSANITY_OFFSET, NL_BOT_HEALTH_INSANITY_LEN)
        #Bot bite damage
        biteDamages = numbersList.slice(NL_BITE_DAMAGE_INSANITY_OFFSET, NL_BITE_DAMAGE_INSANITY_LEN)
        #Bot bite durations
        biteDurations = numbersList.slice(NL_BITE_DURATIONS_INSANITY_OFFSET, NL_BITE_DURATIONS_INSANITY_LEN)
        #Bot throttle speeds
        throttleSpeeds = []
        # tmp0: hero-entry counter, to fill all 21 Insanity throttle speeds with 1.
        for tmp0 in range(21):
            throttleSpeeds.append(1)
        #Bot damage dealt
        damageDealt = numbersList.slice(NL_DAMAGE_DEALT_INSANITY_OFFSET, NL_DAMAGE_DEALT_INSANITY_LEN)
    else:
        #Message does not play if server is not 70 seconds old, this is a bad fix but I'm struggling to find a simple one.
        if getTotalTimeElapsed() < 100:
            goto lbl_0
        smallMessage(getAllPlayers(), " Difficulty adjusted for player count, change affects new zombies. ")
        lbl_0:
        #Shared HP for 1-4 players; only Winston (index 18) changes below.
        botHealthValues = numbersList.slice(NL_BOT_HEALTH_BASE_OFFSET, NL_BOT_HEALTH_BASE_LEN)
        #Shared bite durations for 3+ players; 1 and 2 players override them.
        biteDurations = numbersList.slice(NL_BITE_DURATIONS_BASE_OFFSET, NL_BITE_DURATIONS_BASE_LEN)
        #Difficulty: 1 Player "Normal"
        if difficultySetting == 1:
            #Bot bite damage
            biteDamages = numbersList.slice(NL_BITE_DAMAGE_NORMAL_OFFSET, NL_BITE_DAMAGE_NORMAL_LEN)
            #Bot bite durations
            biteDurations = numbersList.slice(NL_BITE_DURATIONS_NORMAL_OFFSET, NL_BITE_DURATIONS_NORMAL_LEN)
            #Bot throttle speeds
            throttleSpeeds = numbersList.slice(NL_THROTTLE_SPEEDS_NORMAL_OFFSET, NL_THROTTLE_SPEEDS_NORMAL_LEN)
            #Bot damage dealt
            damageDealt = numbersList.slice(NL_DAMAGE_DEALT_NORMAL_OFFSET, NL_DAMAGE_DEALT_NORMAL_LEN)
        #Difficulty: 2 Player "Hard"
        elif difficultySetting == 2:
            #Bot Health Values
            botHealthValues[18] = 750
            #Bot bite damage
            biteDamages = numbersList.slice(NL_BITE_DAMAGE_HARD_OFFSET, NL_BITE_DAMAGE_HARD_LEN)
            #Bot bite durations
            biteDurations = numbersList.slice(NL_BITE_DURATIONS_HARD_OFFSET, NL_BITE_DURATIONS_HARD_LEN)
            #Bot throttle speeds
            throttleSpeeds = numbersList.slice(NL_THROTTLE_SPEEDS_HARD_OFFSET, NL_THROTTLE_SPEEDS_HARD_LEN)
            #Bot damage dealt
            damageDealt = numbersList.slice(NL_DAMAGE_DEALT_HARD_OFFSET, NL_DAMAGE_DEALT_HARD_LEN)
        #Difficulty: 5+ Player "Legendary"
        elif difficultySetting >= 5:
            #Bot Health Values
            botHealthValues = numbersList.slice(NL_BOT_HEALTH_LEGENDARY_OFFSET, NL_BOT_HEALTH_LEGENDARY_LEN)
            #Bot bite damage
            biteDamages = numbersList.slice(NL_BITE_DAMAGE_LEGENDARY_OFFSET, NL_BITE_DAMAGE_LEGENDARY_LEN)
            #Bot throttle speeds
            throttleSpeeds = numbersList.slice(NL_THROTTLE_SPEEDS_LEGENDARY_OFFSET, NL_THROTTLE_SPEEDS_LEGENDARY_LEN)
            #Bot damage dealt
            damageDealt = numbersList.slice(NL_DAMAGE_DEALT_LEGENDARY_OFFSET, NL_DAMAGE_DEALT_LEGENDARY_LEN)
        #Difficulty: 3-4 Player "Expert"
        else:
            #Bot Health Values
            botHealthValues[18] = 1000
            #Bot bite damage
            biteDamages = numbersList.slice(NL_BITE_DAMAGE_EXPERT_OFFSET, NL_BITE_DAMAGE_EXPERT_LEN)
            #Bot throttle speeds
            throttleSpeeds = numbersList.slice(NL_THROTTLE_SPEEDS_EXPERT_OFFSET, NL_THROTTLE_SPEEDS_EXPERT_LEN)
            #Bot damage dealt
            damageDealt = numbersList.slice(NL_DAMAGE_DEALT_EXPERT_OFFSET, NL_DAMAGE_DEALT_EXPERT_LEN)


def setPrematchTimer():
    @Name "setPrematchTimer"

    #Cancel if hidden timer has not been set
    if not chase1:
        return
    #Voting in progress
    if voting:
        #Event player is voting
        if eventPlayer.isVoting == true:
            #Set match time to hidden timer
            setMatchTime(chase1)
        #Event Player is not voting
        else:
            #All players are finished voting
            if getMatchTime() > 5 + votingEndTime and ((len(getPlayers(Team.1).filter(lambda player: player.isVoting == false and player.pregameState > PregameState.SELECTING_HERO))) == getNumberOfPlayers(Team.1)):
                setMatchTime(5 + votingEndTime)
            elif getMatchTime() > 20 + votingEndTime and ((len(getPlayers(Team.1).filter(lambda player: player.isVoting == false and player.pregameState > PregameState.SELECTING_HERO))) == len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus))):
                setMatchTime(20 + votingEndTime)
    #Voting complete
    else:
        #Event Player deselects hero
        if eventPlayer.pregameState < PregameState.READY:
            setMatchTime(chase1)
        else:
            if getMatchTime() > 10 and len(getPlayers(Team.1).filter(lambda player: player.pregameState == PregameState.READY)) == getNumberOfPlayers(Team.1):
                setMatchTime(15)
                wait()
                setMatchTime(10)
            elif getMatchTime() > 20 and len(getPlayers(Team.1).filter(lambda player: player.pregameState == PregameState.READY)) == len(getPlayers(Team.1).filter(lambda player: player.playerActiveStatus)):
                setMatchTime(20)


def enableDisableAbilities():
    @Name "enableDisableAbilities"

    if specialGameModeSetup:
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

    if gameStatus:
        playersOnObjective = []
        objectiveCaptureValue = 0
        gameSmolderEvent = false
        goalPost = 0
        goalCheck = false
        #Checks if current objective is showdown
        switch objectiveTypes[0]:
            case 1:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, objectivePositions[0], objectiveRad * 2)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, objectivePositions[0], 200)
                bigMessage(getAllPlayers(), "Showdown Conquered!")
                break
            #Checks if current objective is bosses
            case 2:
                bigMessage(getAllPlayers(), "Giant zombie eliminated!")
                break
            #Checks if current objective is biomorphing
            case 3:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, objectivePositions[0], objectiveRad)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ROSE, objectivePositions[0], 200)
                bigMessage(getAllPlayers(), "Biomorphing completed!")
                break
            #Checks if current objective is survivor rescue
            case 4:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.VIOLET, objectivePositions[0], objectiveRad)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.VIOLET, objectivePositions[0], 200)
                bigMessage(getAllPlayers(), "The survivors have been rescued!")
                break
            #Checks if current objective is kill zone
            case 5:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, objectiveChase1, 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, objectiveChase1, objectiveRad * 2)
                bigMessage(getAllPlayers(), "The kill zone has been cleared!")
                break
            #Checks if current objective is Zombie Egg
            case 6:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, objectivePositions[0], 200)
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], objectiveRad * 2)
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, objectivePositions[0], 3)
                bigMessage(getAllPlayers(), "The egg has been destroyed!")
                break
            #Checks if current objective is Satellite Uplink
            case 7:
                playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, objectivePositions[0], 200)
                bigMessage(getAllPlayers(), "Firing sequence complete!")
        wait()
        del objectivePositions[0]
        del objectiveTypes[0]
        bosses = []
        survivorToRescue = null
    wait(0.25)
    if len(objectivePositions) == 1:
        playersOnObjective = []
        objectiveDescription = "Proceed to the extraction point"
        #Shrink extraction zone radius down to size of extraction point
        chaseAtRate(extractionZoneRad, 0, extractionSpeedUp)
        objectiveRad = 10
        bigMessage(getAllPlayers(), "Get to the extraction point!")
    else:
        switch objectiveTypes[0]:
            case 1:
                objectiveDescription = "Keep zombies away in the Showdown!"
                objectiveCaptureValue = 0
                chaseAtRate(objectiveRad, max(5, objectiveCaptureValue / 4), 1)
                objectiveColor = Color.ORANGE
                bigMessage(getAllPlayers(), "Proceed to the Showdown!")
                goalPost = 25
                queuedGoalType = []
                break
            case 2:
                objectiveDescription = "Eliminate the boss"
                bigMessage(getAllPlayers(), "Eliminate the giant zombie!")
                break
            case 3:
                objectiveDescription = "Convert biowaste into powerups!"
                objectiveCaptureValue = 0
                objectiveResourcePositions = []
                getAllPlayers().playerObjectiveResourceValue = 0
                objectiveColor = rgb(135, 206, 250)
                objectiveRad = 3.5
                bigMessage(getAllPlayers(), "Find the indicated material and deposit it!")
                biowasteColorLookUp = [Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE, Color.RED]
                biowasteTextLookUp = ["Head", "Arm", "Leg"]
                queuedGoalType = random.shuffle([0, 1, 2, 3])
                goalCheck = true
                goalPost = 25
                break
            case 4:
                objectiveDescription = "Rescue survivors"
                survivorToRescue = null
                objectiveRad = 10
                objectiveChase1 = objectiveRad
                bigMessage(getAllPlayers(), "Locate survivors and bring them to the extraction site!")
                break
            case 5:
                objectiveDescription = "Clear the kill zone"
                objectiveRad = 20
                eliminationsNeededPerObjective = 50
                objectiveChase1 = objectivePositions[0]
                bigMessage(getAllPlayers(), "Get to the kill zone and clear zombies!")
                objectiveCaptureValue = 0
                break
            case 6:
                objectiveDescription = "Destroy the egg"
                objectiveRad = 0
                bigMessage(getAllPlayers(), "Destroy the zombie egg!")
                break
            case 7:
                objectiveDescription = "Repair satellite control terminals"
                objectiveRad = 3
                objectiveColor = rgb(28, 169, 201)
                objectiveResourcePositions = []
                objectiveCaptureValue = [0, 0, 0]
                #Initial terminal spacing
                testPos2 = 50
                bigMessage(getAllPlayers(), "Repair the satellite control terminals!")
    #Updates global objective entities
    globalObjectiveEntityManagementMacro()
    objectiveComplete = false


def selectTarget():
    @Name "selectTarget"
    
    eventPlayer.targeting = true
    #Set potential targets empty
    eventPlayer.potentialTargets = []
    #Miniboss prioritizes players on objective
    if eventPlayer in miniBoss:
        eventPlayer.potentialTargets.append(playersOnObjective.filter(lambda x: not x.isDummy()))
    #Prioitize dummy bots
    eventPlayer.potentialTargets.append(playerTargetList.filter(lambda x: x.isDummy()))
    #For projectile firing heroes
    if not eventPlayer in bosses and eventPlayer.getHero() == Hero.PHARAH:
        #Players in Air
        eventPlayer.potentialTargets.append(playerTargetList.filter(lambda x: distance(x.getPosition(), nearestWalkablePosition(x.getPosition())) > 5))
    #Add players who are below bot to target list
    eventPlayer.potentialTargets.append(sorted(playerTargetList.exclude(eventPlayer.potentialTargets).filter(lambda x: x.getPosition().y - eventPlayer.getPosition().y < 2.5), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Add remaining players
    eventPlayer.potentialTargets.append(sorted(playerTargetList.exclude(eventPlayer.potentialTargets), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))
    #Remove invisible players
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: not x.invisible)
    # tmp0: candidate-target index, to select the first target visible to this bot.
    for tmp0 in range(len(eventPlayer.potentialTargets)):
        eventPlayer.testTarget = eventPlayer.potentialTargets[tmp0]
        if isInLoS(eventPlayer.testTarget.getEyePosition(), eventPlayer.getPosition() + vect(0, losHeightCheck, 0)):
            break
        #wait()
    if eventPlayer.isAlive():
        eventPlayer.botTarget = eventPlayer.testTarget
        eventPlayer.lastTarget = eventPlayer.botTarget
        startRule(restoreDefaultFacingMovement)
    eventPlayer.targeting = false


def restoreDefaultFacingMovement():
    @Name "restoreDefaultFacingMovement"
    
    if eventPlayer.botTarget != null:
        if not eventPlayer.specialFacing:
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), 1500 if eventPlayer.attached else 0 if eventPlayer.crowdControlled else 100)
        if not eventPlayer.specialThrottling:
            eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed if distance(eventPlayer.getPosition(), vect(eventPlayer.botTarget.getPosition().x, eventPlayer.getPosition().y, eventPlayer.botTarget.getPosition().z)) > 2 * min(1, eventPlayer.size) else 0, Relativity.TO_WORLD)
    else:
        eventPlayer.startThrottleInDirection(eventPlayer.getFacingDirection(), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
        eventPlayer.startFacing(eventPlayer.getThrottle(), 100, Relativity.TO_PLAYER)


def botRespawnInitialization():
    @Name "botRespawnInitialization"
    
    eventPlayer.initializing = true
    if eventPlayer in bosses:
        eventPlayer.disableNameplatesFor(getAllPlayers())
        eventPlayer.health = 0
        eventPlayer.initialMaxHealth = eventPlayer.getMaxHealth()
    else:
        eventPlayer.enableNameplatesFor(getAllPlayers())
        eventPlayer.size = createWorkshopSettingFloat("Zombies", "Zombie Size", 1, 0, 20)
        eventPlayer.health = botHealthValues[botHeros.index(eventPlayer.getHero())]
        #Scale zombie voice lines with size
        eventPlayer.startModifyingVoicelinePitch(0.5 + (1 / (eventPlayer.size + 1)) + 0.25 * (sinDeg(getTotalTimeElapsed() * evalOnce(random.uniform(360, 720)))))
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.wallCollisionEnabled = true
    eventPlayer.enablePlayerCollision()
    eventPlayer.attached = false
    eventPlayer.specialFacing = false
    eventPlayer.specialThrottling = false
    eventPlayer.canWallPhase = true
    eventPlayer.crowdControlled = false
    eventPlayer.botTempValue = null
    eventPlayer.botTempvalue2 = null
    eventPlayer.botSpecialTarget = null
    eventPlayer.targeting = false
    eventPlayer.bossHealth = -1
    #Chance for a minboss on high difficulties
    if difficultySetting >= 3 and eventPlayer in bosses == false and len(miniBoss.filter(lambda x: entityExists(x))) == 0:
        # tmp0: miniboss promotion roll, consumed before the possible initialization wait.
        tmp0 = random.randint(1, 27 if objectiveTypes[0] == 1 else 189)
        if tmp0 == 1:
            minibossMutationMacro()
            wait(2)
    botStatManagementMacro()
    if eventPlayer in miniBoss == true:
        goto lbl_0
    mutationsMacro()
    lbl_0:
    eventPlayer.startScalingSize(eventPlayer.size, false)
    botEntityManagementMacro()
    waitUntil(eventPlayer.getHealth() >= eventPlayer.health, 5)
    eventPlayer.stopAllHealingOverTime()
    eventPlayer.setHealth(eventPlayer.health)
    eventPlayer.initializing = false


def abilityPlacement():
    @Name "abilityPlacement"
    
    wait(0.5)
    if eventPlayer.crowdControlled == true:
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
    
    eventPlayer.botSpecialPotentialTargets = getPlayers(Team.2) if not eventPlayer.isDummy() else getAllPlayers().filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < eventPlayer.explosionSize * 6 and (isInLoS(x.getEyePosition(), eventPlayer.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) if eventPlayer.isDummy() else true))
    #Scaled
    damage(eventPlayer.botSpecialPotentialTargets, eventPlayer, eventPlayer.biteDamage * 2.5 if eventPlayer.isDummy() else eventPlayer.infectionLvl * 100)
    if eventPlayer.isDummy():
        #Scaled
        damage(eventPlayer.botSpecialPotentialTargets.filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 3 * eventPlayer.size), eventPlayer, eventPlayer.biteDamage * 5)
        #Scaled
        eventPlayer.botSpecialPotentialTargets.setStatusEffect(eventPlayer, Status.BURNING, 3)
        #Not scaled damage
        eventPlayer.botSpecialPotentialTargets.startDamageOverTime(eventPlayer, 3, eventPlayer.biteDamage * 2)
        if eventPlayer.damageOverTimeDuration < 3:
            eventPlayer.damageOverTimeDuration = 3
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionColor2, eventPlayer.getPosition(), 6 * eventPlayer.explosionSize)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.explosionColor1, eventPlayer.getPosition(), 3 * eventPlayer.explosionSize)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionSize)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 150 * eventPlayer.explosionSize)
    wait(0.25)


def illariUlt():
    @Name "DAYTAKER'S REVENGE (BOSS)"
    
    eventPlayer.botSpecialTarget.detach()
    eventPlayer.botSpecialTarget.attached = false
    eventPlayer.botSpecialTarget = null
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    eventPlayer.setUltCharge(100)
    wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.movementSpeed /= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
    wait(1.5)
    if eventPlayer.isDead():
        return
    if eventPlayer == eventPlayer.hasStatus(Status.HACKED):
        goto lbl_0
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    lbl_0:
    waitUntil(eventPlayer.isUsingUltimate(), false)
    eventPlayer.movementSpeed *= 3
    eventPlayer.setMoveSpeed(eventPlayer.movementSpeed * 100)
