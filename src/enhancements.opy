#!mainFile "main.opy"
subroutine resetBattleAbilityCharge

subroutine checkEnhancementPlacement
subroutine startPupDefaultChase

rule "PLAYER ENHANCEMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isDummy() != true
    @Condition eventPlayer.isHeroSwitchRespawn == false
    
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        #Default Enhancement: Workshop Setting
        # No enhancement state slots: resolve the default enhancement before initializing its state.
        eventPlayer.enhancementId = createWorkshopSettingEnum("Enhancements", "Default Enhancement", Enhancement.HITCHHIKER, ["No Enhancement", "Kevlar", "Zombie Hybrid", "Laser Barricade", "Brain Killer", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P."])
    #Kevlar
    if eventPlayer.enhancementId == Enhancement.KEVLAR:
        #Enhancement Selection: Kevlar
        # No enhancement state slots are currently used; the future cleanup ID is documented below.
        hudHeader(eventPlayer, "Kevlar {0}".format(iconString(Icon.STOP)), HudPosition.LEFT, 99, colorKevlarConst, HudReeval.STRING)
        waitUntil(eventPlayer.initialMaxHealth != 0, 99999)
        eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
        # If enhancement switching is added after game start, retain the health pool ID to remove Kevlar armor when switching away.
        # Future Kevlar switching would need to retain getLastCreatedHealthPool().
    #Zombie Hybrid
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        #Enhancement: Zombie Hyrbid
        # enhancementHybridCooldown: remaining explosion cooldown in seconds (20 on use), for activation checks and HUD.
        hudText(eventPlayer, "Zombie Hybrid {0}".format(iconString(Icon.POISON) if eventPlayer.enhancementHybridCooldown <= 0 else "{0}s".format(ceil(eventPlayer.enhancementHybridCooldown))), null, "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLevel)) if eventPlayer.infectionLevel >= 1 and eventPlayer.enhancementHybridCooldown <= 0 else [], HudPosition.LEFT, 99, Color.GRAY if eventPlayer.enhancementHybridCooldown <= 0 else Color.RED, Color.GRAY, Color.GRAY if eventPlayer.enhancementHybridCooldown <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionScale = 1.25
        eventPlayer.explosionInnerColor = Color.GRAY
        eventPlayer.explosionOuterColor = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLevel, 0, 0.015 if eventPlayer.infectionLevel > 0 else 0)
    #Laser Barricade
    switch eventPlayer.enhancementId:
        case Enhancement.LASER_BARRICADE:
            #Enhancement: Laser Barricade
            # enhancementBarrierFacing: horizontal unit direction saved at placement, to reconstruct both push reference points.
            # enhancementBarrierEdgeDirection: unit direction from corner 1 to corner 2, cached for zombie collision checks.
            # enhancementBarrierPlacementCooldown: remaining placement cooldown in seconds (30 on placement), for placement checks and HUD.
            # enhancementBarrierPosition: placed barrier center in world coordinates, for collision checks, push points and HP text.
            # enhancementBarrierCorner1: first lower corner in world coordinates, for beams and collision geometry.
            # enhancementBarrierCorner2: second lower corner in world coordinates, for beams and the along-barrier direction.
            # enhancementBarrierHealth: current barrier health (10000 on placement), for blocking, damage, regeneration and HUD.
            hudText(eventPlayer, "Laser Barricade {0}{1}".format(iconString(Icon.DIAMOND), " {0}s".format(eventPlayer.enhancementBarrierPlacementCooldown) if eventPlayer.enhancementBarrierPlacementCooldown > 0 else []), " {0}HP".format(ceil(eventPlayer.enhancementBarrierHealth)) if eventPlayer.enhancementBarrierHealth > 0 else [], "Hold [{0}] to place a barricade".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementBarrierPlacementCooldown <= 0 else [], HudPosition.LEFT, 99, Color.RED if eventPlayer.enhancementBarrierPlacementCooldown > 0 else Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Barricade placement visual
            createBeam(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementBarrierPlacementCooldown <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade bottom
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementBarrierPosition != null), Beam.BAD, eventPlayer.enhancementBarrierCorner1, eventPlayer.enhancementBarrierCorner2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 1
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementBarrierHealth > 0), Beam.BAD, eventPlayer.enhancementBarrierCorner1 + LASER_BARRICADE_HEIGHT * Vector.UP, eventPlayer.enhancementBarrierCorner1, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 2
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementBarrierHealth > 0), Beam.BAD, eventPlayer.enhancementBarrierCorner2, eventPlayer.enhancementBarrierCorner2 + LASER_BARRICADE_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade top
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementBarrierHealth > 0), Beam.BAD, eventPlayer.enhancementBarrierCorner2 + LASER_BARRICADE_HEIGHT * Vector.UP, eventPlayer.enhancementBarrierCorner1 + LASER_BARRICADE_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade health
            createInWorldText(getAllPlayers() if eventPlayer.enhancementBarrierHealth > 0 else null, "{0}HP".format(ceil(eventPlayer.enhancementBarrierHealth)), eventPlayer.enhancementBarrierPosition + Vector.UP, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
            break
        #Brain Killer
        case Enhancement.BRAIN_KILLER:
            #Enhancement: Brain Killer
            # No enhancement state slots: bonus damage is calculated directly from the damage event.
            hudHeader(eventPlayer, "Brain Killer {0}".format(iconString(Icon.SKULL)), HudPosition.LEFT, 99, Color.RED, HudReeval.STRING)
            break
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            #Enhancement: Pyrotechnic
            hudHeader(eventPlayer, "Pyrotechnic {0}".format(iconString(Icon.FIRE)), HudPosition.LEFT, 99, Color.ORANGE, HudReeval.STRING)
            # enhancementPyroHitList: hit queue; repeated targets determine their damage per second when the queue is processed.
            eventPlayer.enhancementPyroHitList = []
            break
        #Plague Doctor
        case Enhancement.PLAGUE_DOCTOR:
            #Enhancement: Plague Doctor
            # enhancementPlagueCureTotal: accumulated infection levels removed, including cure bonuses, displayed in the HUD.
            hudText(eventPlayer, "Plague Doctor {0}".format(iconString(Icon.PLUS)), null, "Infection Reduced: {0} lvls".format(eventPlayer.enhancementPlagueCureTotal), HudPosition.LEFT, 99, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.STRING)
            #Plague doctor does 100 + x% more healing to infected players
            startHealingModification(getPlayers(Team.1).filter(lambda player: player.isInfected), eventPlayer, 150, HealingReeval.RECEIVERS_AND_HEALERS)
            eventPlayer.enhancementPlagueCureTotal = 0
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            #Enhancement: Born to Battle
            # enhancementIsBattleResetReady: whether an earned ability reset is still available; cleared when the reset is consumed.
            # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
            hudText(eventPlayer, "Born to Battle {0}".format(iconString(Icon.BOLT)), null, iconString(Icon.CHECKMARK) if eventPlayer.enhancementIsBattleResetReady else [], HudPosition.LEFT, 99, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.STRING)
            eventPlayer.enhancementIsBattleResetReady = false
            break
        #Charge Battery
        case Enhancement.CHARGE_BATTERY:
            #Enhancement: Charge Battery
            # enhancementBatteryPosition: placed battery position in world coordinates, for effects and player proximity checks.
            # enhancementBatteryReuseCooldown: remaining battery reuse cooldown in seconds, for the progress bar and availability visuals.
            # enhancementBatteryReuseDuration: full battery reuse cooldown in seconds (10), used to start the timer and scale progress.
            # enhancementBatteryPlacementCooldown: remaining placement cooldown in seconds (20 on placement), for placement checks and HUD.
            hudText(eventPlayer, "Charge Battery {0}".format(iconString(Icon.SPIRAL) if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else "{0}s".format(ceil(eventPlayer.enhancementBatteryPlacementCooldown))), null, "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else [], HudPosition.LEFT, 99, colorChargeBatteryConst if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else Color.RED, colorChargeBatteryConst, colorChargeBatteryConst if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
            #Battery placement visual
            createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementBatteryPlacementCooldown <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, rgb(0, 255, 0, 204), worldVector(0.1 * Vector.UP, eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery ring
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery sphere
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Charge battery text
            createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0 and distance(player.getPosition(), eventPlayer.enhancementBatteryPosition) < 6), "Charge Battery", eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
            #Charge battery progress bar
            createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown > 0 and distance(player.getPosition(), eventPlayer.enhancementBatteryPosition) < 6), 100 - eventPlayer.enhancementBatteryReuseCooldown / eventPlayer.enhancementBatteryReuseDuration * 100, [], eventPlayer.enhancementBatteryPosition + 0.4 * Vector.UP, 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)
            eventPlayer.enhancementBatteryReuseDuration = 10
            break
        #Hitchhiker
        case Enhancement.HITCHHIKER:
            #Enhancement Selection: Hitchhiker
            # enhancementHitchhikerCarrier: carrier player reference, for attachment, shared health, assists and HUD; 0 when detached.
            # enhancementHitchhikerPassengerPoolId: extra health pool ID on this passenger, retained to remove that pool when detaching.
            hudText(eventPlayer, "Hitchhiker {0}".format(iconString(Icon.FLAG)), null, "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.enhancementIsHitchhiking else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.sizeScale) else [], HudPosition.LEFT, 99, Color.PURPLE, Color.PURPLE, Color.RED if eventPlayer.enhancementIsHitchhiking else Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Shared Health Bar Rider
            hudSubheader(eventPlayer.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementHitchhikerCarrier.getHero()), eventPlayer.enhancementHitchhikerCarrier), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            #Shared Health Bar Runner
            hudSubheader(eventPlayer.enhancementHitchhikerCarrier.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            eventPlayer.enhancementHitchhikerCarrier = 0
            eventPlayer.enhancementHitchhikerCarrier.startGrantingAssistFor(eventPlayer)
            break
        #P.U.P.
        case Enhancement.PUP:
            #Enhancement Selection: P.U.P.
            # enhancementPupColor: current drone color, indicating its mode in the HUD, sphere and beam.
            # enhancementIsPupBeamActive: whether the attack beam is active; also controls its sound and pauses cooldown decay.
            # enhancementPupTarget: current enemy target, shared by movement, attack and target cleanup rules; null when idle.
            # enhancementIsPupFreezeAuraActive: whether the freezing aura effect is visible around the target.
            # enhancementPupPosition: chased drone position in world coordinates, for movement, effects and attack direction.
            # enhancementPupCooldown: remaining ability cooldown in seconds (2 after freezing, 1 after laser), gating target selection.
            hudHeader(eventPlayer, "P.U.P. {0}".format(iconString(Icon.HAPPY)), HudPosition.LEFT, 99, Color.BLUE if eventPlayer.enhancementPupColor == Color.SKY_BLUE and eventPlayer.enhancementPupCooldown > 0 else eventPlayer.enhancementPupColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Postion of P.U.P.
            eventPlayer.enhancementPupPosition = eventPlayer.getPosition() + 200 * Vector.UP
            #P.U.P. Default movment
            startPupDefaultChase()
            eventPlayer.enhancementPupCooldown = 0
            #P.U.P. ability cooldown
            chaseAtRate(eventPlayer.enhancementPupCooldown, 0, 0 if eventPlayer.enhancementIsPupBeamActive else 1)
            #P.U.P. visual
            createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.enhancementPupColor, eventPlayer.enhancementPupPosition, 0.25)
            #P.U.P. Beam
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupBeamActive and eventPlayer.enhancementPupTarget != null), Beam.GOOD, eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget, eventPlayer.enhancementPupColor)
            #P.U.P using beam sound
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupBeamActive), Effect.BEACON_SOUND, Color.SKY_BLUE, eventPlayer.enhancementPupPosition, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Freeze aura
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupFreezeAuraActive), Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.enhancementPupTarget, eventPlayer.enhancementPupTarget.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Default color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
            #P.U.P. target null
            eventPlayer.enhancementPupTarget = null
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = false


rule "ZOMBIE HYBRID":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementHybridCooldown <= 0
    @Condition eventPlayer.infectionLevel >= 1
    
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamageOverTimeId)
    eventPlayer.infectionLevel = 0
    eventPlayer.enhancementHybridCooldown = 20
    while eventPlayer.enhancementHybridCooldown > 0:
        wait(1)
        eventPlayer.enhancementHybridCooldown += -1


# Synchronous helper output; consume immediately before any wait or asynchronous work.
#!define isEnhancementPlacementInvalid tmp0

rule "LASER BARRICADE (PLACEMENT)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.LASER_BARRICADE
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementBarrierPlacementCooldown <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    #Laser Barrier health
    eventPlayer.enhancementBarrierHealth = 10000
    #Barrier center point
    eventPlayer.enhancementBarrierPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.enhancementBarrierCorner1 = eventPlayer.enhancementBarrierPosition + worldVector((-0.5 * LASER_BARRICADE_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.enhancementBarrierCorner2 = eventPlayer.enhancementBarrierPosition + worldVector((0.5 * LASER_BARRICADE_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    # Horizontal push direction captured at placement; reference points are center +/- this vector.
    eventPlayer.enhancementBarrierFacing = directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    # Along-barrier direction, reused by collision checks.
    eventPlayer.enhancementBarrierEdgeDirection = directionTowards(eventPlayer.enhancementBarrierCorner1, eventPlayer.enhancementBarrierCorner2)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.enhancementBarrierPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.enhancementBarrierPosition, 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.enhancementBarrierPlacementCooldown = 30
    while eventPlayer.enhancementBarrierPlacementCooldown > 0:
        wait(1)
        eventPlayer.enhancementBarrierPlacementCooldown += -1


rule "LASER BARRICADE BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.LASER_BARRICADE
    #Barrier health is greater than 0
    @Condition eventPlayer.enhancementBarrierHealth > 0
    #Horizontal distance check
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(eventPlayer.enhancementBarrierPosition, vect(player.getPosition().x, eventPlayer.enhancementBarrierPosition.getPosition().y, player.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) == true
    #If feet are below highest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getPosition().y < eventPlayer.enhancementBarrierPosition.y + LASER_BARRICADE_HEIGHT) == true
    #If eyes are above lowest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getEyePosition().y > eventPlayer.enhancementBarrierPosition.y) == true
    #Distance from wall
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(vect(player.getPosition().x, eventPlayer.enhancementBarrierCorner1.y, player.getPosition().z), eventPlayer.enhancementBarrierCorner1 + eventPlayer.enhancementBarrierEdgeDirection * (min(LASER_BARRICADE_WIDTH, abs(dotProduct(eventPlayer.enhancementBarrierEdgeDirection, vect(player.getPosition().x, eventPlayer.enhancementBarrierCorner1.y, player.getPosition().z) - eventPlayer.enhancementBarrierCorner1))))) < 1.5) == true
    
    stopChasing(eventPlayer.enhancementBarrierHealth)
    #Filter horizontal distance, feet height, eye height and distance from wall together.
    eventPlayer.enhancementBarrierTargetList = getLivingPlayers(Team.2).filter(lambda target: (distance(eventPlayer.enhancementBarrierPosition, vect(target.getPosition().x, eventPlayer.enhancementBarrierPosition.getPosition().y, target.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) and (target.getPosition().y < eventPlayer.enhancementBarrierPosition.y + LASER_BARRICADE_HEIGHT) and (target.getEyePosition().y > eventPlayer.enhancementBarrierPosition.y) and (distance(vect(target.getPosition().x, eventPlayer.enhancementBarrierCorner1.y, target.getPosition().z), eventPlayer.enhancementBarrierCorner1 + eventPlayer.enhancementBarrierEdgeDirection * (min(LASER_BARRICADE_WIDTH, abs(dotProduct(eventPlayer.enhancementBarrierEdgeDirection, vect(target.getPosition().x, eventPlayer.enhancementBarrierCorner1.y, target.getPosition().z) - eventPlayer.enhancementBarrierCorner1))))) < 1.5))
    # barrierPushReferencePointList: both push reference points, reconstructed from saved geometry and consumed before wait.
    #!define barrierPushReferencePointList tmp1
    barrierPushReferencePointList = [eventPlayer.enhancementBarrierPosition + eventPlayer.enhancementBarrierFacing, eventPlayer.enhancementBarrierPosition + eventPlayer.enhancementBarrierFacing * -1]
    # barrierCollisionTargetIndex: barricade target index, to damage and push each zombie crossing the barrier.
    #!define barrierCollisionTargetIndex tmp0
    for barrierCollisionTargetIndex in range(len(eventPlayer.enhancementBarrierTargetList)):
        # barrierCollisionTarget: current zombie, consumed by this iteration's damage/push actions before wait.
        #!define barrierCollisionTarget tmp2
        barrierCollisionTarget = eventPlayer.enhancementBarrierTargetList[barrierCollisionTargetIndex]
        if not barrierCollisionTarget.hasStatus(Status.ROOTED):
            #Damage the barricade
            eventPlayer.enhancementBarrierHealth -= barrierCollisionTarget.getMaxHealth() * 2.5
            barrierCollisionTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(barrierCollisionTarget, eventPlayer, 10)
        if barrierCollisionTarget.getThrottle() == vect(0, 0, 0):
            #If bot is not throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: distance(barrierCollisionTarget.getPosition(), x)))[0])), (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.enhancementBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.enhancementBarrierPosition, x)))).last())), (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.enhancementBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.enhancementBarrierHealth > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.enhancementBarrierHealth <= 0:
            eventPlayer.enhancementBarrierHealth = 1
    chaseAtRate(eventPlayer.enhancementBarrierHealth, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()


rule "BRAIN KILLER EXTRA DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BRAIN_KILLER
    @Condition eventWasCriticalHit == true
    
    #Critical hits deal 50% more damage, 20% if vicitm is a boss
    damage(victim, eventPlayer, eventDamage * (0.2 if victim in bossStateList else 0.6))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, rgb(100, 14, 14), victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)


rule "PYROTECHNIC SETS ENEMIES ON FIRE":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker.enhancementId == Enhancement.PYROTECHNIC
    @Condition victim != eventPlayer
    @Condition eventAbility != null
    @Condition distance(attacker.getPosition(), victim.getPosition()) < 15
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    attacker.enhancementPyroHitList.append(victim)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PYROTECHNIC
    @Condition len(eventPlayer.enhancementPyroHitList) > 0
    
    while len(eventPlayer.enhancementPyroHitList) > 0:
        # pyroBurnTarget: zombie to burn; consumed within this iteration before the cooldown wait.
        #!define pyroBurnTarget tmp0
        pyroBurnTarget = eventPlayer.enhancementPyroHitList[0]
        if pyroBurnTarget.isAlive():
            # pyroBurnDamagePerSecond: damage per second based on hits in the last cycle, used immediately.
            #!define pyroBurnDamagePerSecond tmp1
            pyroBurnDamagePerSecond = min(4 * (len(eventPlayer.enhancementPyroHitList.filter(lambda x: x == pyroBurnTarget))), 30)
            if pyroBurnTarget in bossStateList:
                # pyroBurnDamagePerSecond: halve this zombie's damage if it is a boss.
                pyroBurnDamagePerSecond /= 2
            pyroBurnTarget.startDamageOverTime(eventPlayer, 3, pyroBurnDamagePerSecond)
        eventPlayer.enhancementPyroHitList.remove(pyroBurnTarget)
    wait(0.5)
    if ruleCondition:
        loop()


rule "BORN TO BATTLE PLAYER EARNS ELIMINATION":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementIsBattleResetReady != true
    
    eventPlayer.enhancementIsBattleResetReady = true


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementIsBattleResetReady == true
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementBattleAbilityButton = Button.SECONDARY_FIRE
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.enhancementBattleAbilityButton = Button.ABILITY_1
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.enhancementBattleAbilityButton = Button.ABILITY_2
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.enhancementBattleAbilityButton = Button.CROUCH
    elif eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.enhancementBattleAbilityButton = Button.JUMP
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            resetBattleAbilityCharge()
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            resetBattleAbilityCharge()
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton) + 1)
    lbl_0:
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton) > 0:
        eventPlayer.enhancementIsBattleResetReady = false
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)
        eventPlayer.enhancementIsBattleResetReady = false


rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR
    
    if eventPlayer.isInfected:
        eventPlayer.infectionLevel -= eventHealing / 500
        eventPlayer.enhancementPlagueCureTotal += eventHealing / 500
    if healee.infectionLevel >= 1 and healee.enhancementId != Enhancement.ZOMBIE_HYBRID:
        healee.infectionLevel -= eventHealing / 275
        eventPlayer.enhancementPlagueCureTotal += eventHealing / 275
        if healee.infectionLevel < 1:
            healee.infectionLevel -= 0.5
            eventPlayer.enhancementPlagueCureTotal += 0.5
            playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
            smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "CHARGE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementBatteryPlacementCooldown <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    eventPlayer.enhancementBatteryPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementBatteryPlacementCooldown = 20
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementBatteryReuseCooldown = 0
    while eventPlayer.enhancementBatteryPlacementCooldown > 0:
        wait(1)
        eventPlayer.enhancementBatteryPlacementCooldown += -1


rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition eventPlayer.enhancementBatteryPosition != 0
    @Condition (playerTargetList.any(lambda x: x.getUltCharge() < 100 and distance(x.getPosition(), eventPlayer.enhancementBatteryPosition) < 1.5 * x.sizeScale)) == true
    
    # batteryChargeRecipient: survivor using the battery, to play feedback and grant ultimate charge before cooldown waits.
    #!define batteryChargeRecipient tmp0
    batteryChargeRecipient = (getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(player.getPosition(), eventPlayer.enhancementBatteryPosition) < 1.5))[0]
    playEffect(batteryChargeRecipient, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, batteryChargeRecipient, 50)
    playEffect(batteryChargeRecipient, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementBatteryPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, batteryChargeRecipient, 1)
    batteryChargeRecipient.setUltCharge(batteryChargeRecipient.getUltCharge() + 15)
    eventPlayer.enhancementBatteryReuseCooldown = eventPlayer.enhancementBatteryReuseDuration
    while eventPlayer.enhancementBatteryReuseCooldown > 0:
        wait(0.5)
        eventPlayer.enhancementBatteryReuseCooldown += -0.5
    if ruleCondition:
        loop()


def checkEnhancementPlacement():
    # Synchronous output only: no waits, asynchronous work or nested calls before the caller reads tmp0.
    # Keep the 31 m validation ray separate from each caller's 30 m placement ray and its player filters.
    # The caller must return on rejection; returning here alone would not cancel placement.
    isEnhancementPlacementInvalid = distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30 or eventPlayer.isDead()


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.enhancementIsHitchhiking and (not eventPlayer.hasSpawned() or not eventPlayer.enhancementHitchhikerCarrier.hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementHitchhikerCarrier.isDead() or not entityExists(eventPlayer.enhancementHitchhikerCarrier) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementHitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer.getPosition(), eventPlayer.enhancementHitchhikerCarrier.getPosition()) > 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale))) == true
    @Condition eventPlayer.getHero() != Hero.MEI
    
    if not eventPlayer.enhancementIsHitchhiking and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.sizeScale):
            #Select parent
            eventPlayer.enhancementHitchhikerCarrier = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.isCrowdControlled and distance(eventPlayer.getPosition(), x.getPosition()) < x.sizeScale * 2), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            # hitchhikerWorldAttachmentPosition: attachment position in world space, converted and captured before any wait.
            #!define hitchhikerWorldAttachmentPosition tmp0
            hitchhikerWorldAttachmentPosition = eventPlayer.enhancementHitchhikerCarrier.getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementHitchhikerCarrier.getPosition(), eventPlayer.getPosition())), 0) * eventPlayer.enhancementHitchhikerCarrier.sizeScale + eventPlayer.enhancementHitchhikerCarrier.sizeScale * Vector.UP
            # hitchhikerLocalAttachmentOffset: convert the attachment position to the parent's local coordinates.
            #!define hitchhikerLocalAttachmentOffset tmp0
            hitchhikerLocalAttachmentOffset = localVector(hitchhikerWorldAttachmentPosition, eventPlayer.enhancementHitchhikerCarrier, Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if hitchhikerLocalAttachmentOffset.z > 0:
                # hitchhikerLocalAttachmentOffset: mirror a forward offset behind the parent.
                hitchhikerLocalAttachmentOffset *= vect(1, 1, -1)
            # hitchhikerLocalAttachmentOffset: raise the final local offset before capturing it in attachTo.
            hitchhikerLocalAttachmentOffset += Vector.UP
            eventPlayer.enhancementIsHitchhiking = true
            eventPlayer.attachTo(eventPlayer.enhancementHitchhikerCarrier, evalOnce(hitchhikerLocalAttachmentOffset))
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementHitchhikerCarrier.initialMaxHealth, true, false)
            eventPlayer.enhancementHitchhikerPassengerPoolId = getLastCreatedHealthPool()
            eventPlayer.enhancementHitchhikerCarrier.enhancementHitchhikerPassenger = eventPlayer
    else:
        if entityExists(eventPlayer.enhancementHitchhikerCarrier) and eventPlayer.hasSpawned() and distance(eventPlayer.getPosition(), eventPlayer.enhancementHitchhikerCarrier.getPosition()) < 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale:
            eventPlayer.teleport(eventPlayer.enhancementHitchhikerCarrier.getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.enhancementHitchhikerCarrier.enhancementHitchhikerPassenger = null
        eventPlayer.enhancementIsHitchhiking = false
        eventPlayer.enhancementHitchhikerCarrier = 0
        removeHealthPool(eventPlayer.enhancementHitchhikerPassengerPoolId)
        wait(1.5)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementHitchhikerPassenger != null
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementHitchhikerPassenger.initialMaxHealth, true, false)
    eventPlayer.enhancementHitchhikerCarrierPoolId = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.enhancementHitchhikerPassenger), 99999)
    removeHealthPool(eventPlayer.enhancementHitchhikerCarrierPoolId)


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition eventPlayer.enhancementIsHitchhiking == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementHitchhikerCarrier.isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.enhancementHitchhikerCarrier.getNormalizedHealth()) > 0.01
    
    # hitchhikerHealthTransferAmount: health to transfer this update; consumed by both setHealth actions before wait.
    #!define hitchhikerHealthTransferAmount tmp0
    hitchhikerHealthTransferAmount = (abs(eventPlayer.getHealth() * eventPlayer.enhancementHitchhikerCarrier.getMaxHealth() - eventPlayer.enhancementHitchhikerCarrier.getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.enhancementHitchhikerCarrier.getMaxHealth())
    # hitchhikerHealthRecipient: player with lower normalized health, receiving the transfer immediately.
    #!define hitchhikerHealthRecipient tmp1
    hitchhikerHealthRecipient = sorted(eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier), lambda x: x.getNormalizedHealth())[0]
    # hitchhikerHealthDonor: other player, giving the transfer immediately; keep all three scratch values distinct.
    #!define hitchhikerHealthDonor tmp2
    hitchhikerHealthDonor = eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier).exclude(hitchhikerHealthRecipient)
    hitchhikerHealthRecipient.setHealth(hitchhikerHealthRecipient.getHealth() + hitchhikerHealthTransferAmount)
    hitchhikerHealthDonor.setHealth(hitchhikerHealthDonor.getHealth() - hitchhikerHealthTransferAmount)
    wait()
    if ruleCondition:
        loop()


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementPupCooldown <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementPupTarget == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 10)) == true
    
    #Set P.U.P. target
    eventPlayer.enhancementPupTarget = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    waitUntil(eventPlayer.enhancementPupTarget.isDead() or not entityExists(eventPlayer.enhancementPupTarget) or eventPlayer.enhancementPupTarget.botIsTeleporting, 99999)
    stopChasing(eventPlayer.enhancementPupPosition)
    eventPlayer.enhancementPupTarget = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementPupPosition)
    #Default color
    eventPlayer.enhancementPupColor = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementIsPupBeamActive = false
    #P.U.P. target null
    eventPlayer.enhancementPupTarget = null
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    #P.U.P. Default movement
    startPupDefaultChase()


rule "P.U.P. CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    @Condition eventPlayer.enhancementPupTarget != null
    
    #P.U.P. attack movement
    chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getEyePosition() + directionTowards(eventPlayer.enhancementPupTarget.getEyePosition(), eventPlayer.enhancementPupPosition) * 2, (abs(distance(eventPlayer.enhancementPupTarget.getEyePosition(), eventPlayer.enhancementPupPosition) - 2)) * 1.5)
    #Default color
    eventPlayer.enhancementPupColor = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementIsPupBeamActive = false
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
    waitUntil(distance(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getEyePosition()) < 5 or eventPlayer.enhancementPupTarget == null, 99999)
    #If target still exists
    if eventPlayer.enhancementPupTarget != null:
        if distance(eventPlayer.getPosition(), eventPlayer.enhancementPupTarget.getPosition()) > 6:
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.WHITE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = true
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = true
            wait(0.25, Wait.ABORT_WHEN_FALSE)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, eventPlayer.enhancementPupTarget, 0.1)
            #Time to freeze dependent on max health of target
            wait(min(15, eventPlayer.enhancementPupTarget.getMaxHealth() / 300), Wait.ABORT_WHEN_FALSE)
            #Freeze cooldown
            eventPlayer.enhancementPupCooldown = 2
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            while not eventPlayer.enhancementPupTarget.hasStatus(Status.FROZEN):
                eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            #Freeze zombies around target for shorter time
            ((getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementPupTarget.getPosition(), player.getPosition()) < 3)).exclude(eventPlayer.enhancementPupTarget)).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = false
        else:
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.RED
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = true
            eventPlayer.enhancementPupTarget.startDamageOverTime(eventPlayer, 3, 30)
            #Beam from P.U.P.
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementPupPosition, 0.25)
            #Beam hits P.U.P.'s target
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementPupTarget, 1)
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementPupTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getPosition())), min(-20, verticalAngleOfDirection(directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getPosition())))), min(25, 4200 / eventPlayer.enhancementPupTarget.getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementPupCooldown = 1
            wait(3, Wait.ABORT_WHEN_FALSE)
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
        stopChasing(eventPlayer.enhancementPupPosition)
        #P.U.P. target
        eventPlayer.enhancementPupTarget = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


def startPupDefaultChase():
    @Name "startPupDefaultChase"

    chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition) - 1))


def resetBattleAbilityCharge():
    @Name "resetBattleAbilityCharge"

    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, 1)
    eventPlayer.enhancementIsBattleResetReady = false
