#!mainFile "main.opy"


rule "PLAYER ENHANCEMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isDummy() != true
    @Condition eventPlayer.switchedHeroes == false
    
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        #Default Enhancement: Workshop Setting
        # No enhancementValue fields: resolve the default enhancement before initializing its state.
        eventPlayer.enhancementId = createWorkshopSettingEnum("Enhancements", "Default Enhancement", Enhancement.HITCHHIKER, ["No Enhancement", "Kevlar", "Zombie Hybrid", "Laser Barricade", "Brain Killer", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P."])
    #Kevlar
    if eventPlayer.enhancementId == Enhancement.KEVLAR:
        #Enhancement Selection: Kevlar
        # No enhancementValue fields are currently used; the future cleanup ID is documented below.
        hudHeader(eventPlayer, "Kevlar {0}".format(iconString(Icon.STOP)), HudPosition.LEFT, 99, colorKevlarConst, HudReeval.STRING)
        waitUntil(eventPlayer.initialMaxHealth != 0, 99999)
        eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
        # If enhancement switching is added after game start, retain the health pool ID to remove Kevlar armor when switching away.
        # eventPlayer.enhancementValue1 = getLastCreatedHealthPool()
    #Zombie Hybrid
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        #Enhancement: Zombie Hyrbid
        # enhancementValue1: remaining explosion cooldown in seconds (20 on use), for activation checks and HUD.
        hudText(eventPlayer, "Zombie Hybrid {0}".format(iconString(Icon.POISON) if eventPlayer.enhancementValue1 <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValue1))), null, "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLvl)) if eventPlayer.infectionLvl >= 1 and eventPlayer.enhancementValue1 <= 0 else [], HudPosition.LEFT, 99, Color.GRAY if eventPlayer.enhancementValue1 <= 0 else Color.RED, Color.GRAY, Color.GRAY if eventPlayer.enhancementValue1 <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionSize = 1.25
        eventPlayer.explosionColor1 = Color.GRAY
        eventPlayer.explosionColor2 = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLvl, 0, 0.015 if eventPlayer.infectionLvl > 0 else 0)
    #Laser Barricade
    switch eventPlayer.enhancementId:
        case Enhancement.LASER_BARRICADE:
            #Enhancement: Laser Barricade
            # enhancementValue1: horizontal unit direction saved at placement, to reconstruct both push reference points.
            # enhancementValue2: unit direction from corner 1 to corner 2, cached for zombie collision checks.
            # enhancementValue3: remaining placement cooldown in seconds (30 on placement), for placement checks and HUD.
            # enhancementValue4: placed barrier center in world coordinates, for collision checks, push points and HP text.
            # enhancementValue5: first lower corner in world coordinates, for beams and collision geometry.
            # enhancementValue6: second lower corner in world coordinates, for beams and the along-barrier direction.
            # enhancementValue7: current barrier health (10000 on placement), for blocking, damage, regeneration and HUD.
            hudText(eventPlayer, "Laser Barricade {0}{1}".format(iconString(Icon.DIAMOND), " {0}s".format(eventPlayer.enhancementValue3) if eventPlayer.enhancementValue3 > 0 else []), " {0}HP".format(ceil(eventPlayer.enhancementValue7)) if eventPlayer.enhancementValue7 > 0 else [], "Hold [{0}] to place a barricade".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValue3 <= 0 else [], HudPosition.LEFT, 99, Color.RED if eventPlayer.enhancementValue3 > 0 else Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Barricade placement visual
            createBeam(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValue3 <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade bottom
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue4 != null), Beam.BAD, eventPlayer.enhancementValue5, eventPlayer.enhancementValue6, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 1
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue7 > 0), Beam.BAD, eventPlayer.enhancementValue5 + vect(0, LASER_BARRICADE_HEIGHT, 0), eventPlayer.enhancementValue5, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 2
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue7 > 0), Beam.BAD, eventPlayer.enhancementValue6, eventPlayer.enhancementValue6 + vect(0, LASER_BARRICADE_HEIGHT, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade top
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue7 > 0), Beam.BAD, eventPlayer.enhancementValue6 + vect(0, LASER_BARRICADE_HEIGHT, 0), eventPlayer.enhancementValue5 + vect(0, LASER_BARRICADE_HEIGHT, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade health
            createInWorldText(getAllPlayers() if eventPlayer.enhancementValue7 > 0 else null, "{0}HP".format(ceil(eventPlayer.enhancementValue7)), eventPlayer.enhancementValue4 + vect(0, 1, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
            break
        #Brain Killer
        case Enhancement.BRAIN_KILLER:
            #Enhancement: Brain Killer
            # No enhancementValue fields: bonus damage is calculated directly from the damage event.
            hudHeader(eventPlayer, "Brain Killer {0}".format(iconString(Icon.SKULL)), HudPosition.LEFT, 99, Color.RED, HudReeval.STRING)
            break
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            #Enhancement: Pyrotechnic
            hudHeader(eventPlayer, "Pyrotechnic {0}".format(iconString(Icon.FIRE)), HudPosition.LEFT, 99, Color.ORANGE, HudReeval.STRING)
            # enhancementValue1: hit queue; repeated targets determine their damage per second when the queue is processed.
            eventPlayer.enhancementValue1 = []
            break
        #Plague Doctor
        case Enhancement.PLAGUE_DOCTOR:
            #Enhancement: Plague Doctor
            # enhancementValue1: accumulated infection levels removed, including cure bonuses, displayed in the HUD.
            hudText(eventPlayer, "Plague Doctor {0}".format(iconString(Icon.PLUS)), null, "Infection Reduced: {0} lvls".format(eventPlayer.enhancementValue1), HudPosition.LEFT, 99, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.STRING)
            #Plague doctor does 100 + x% more healing to infected players
            startHealingModification(getPlayers(Team.1).filter(lambda player: player.infected), eventPlayer, 150, HealingReeval.RECEIVERS_AND_HEALERS)
            eventPlayer.enhancementValue1 = 0
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            #Enhancement: Born to Battle
            # enhancementValue1: whether an earned ability reset is still available; cleared when the reset is consumed.
            # enhancementValue2: selected ability button, retained through waits to reset its charge or cooldown.
            hudText(eventPlayer, "Born to Battle {0}".format(iconString(Icon.BOLT)), null, iconString(Icon.CHECKMARK) if eventPlayer.enhancementValue1 else [], HudPosition.LEFT, 99, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.STRING)
            eventPlayer.enhancementValue1 = false
            break
        #Charge Battery
        case Enhancement.CHARGE_BATTERY:
            #Enhancement: Charge Battery
            # enhancementValue1: placed battery position in world coordinates, for effects and player proximity checks.
            # enhancementValue2: remaining battery reuse cooldown in seconds, for the progress bar and availability visuals.
            # enhancementValue3: full battery reuse cooldown in seconds (10), used to start the timer and scale progress.
            # enhancementValue4: remaining placement cooldown in seconds (20 on placement), for placement checks and HUD.
            hudText(eventPlayer, "Charge Battery {0}".format(iconString(Icon.SPIRAL) if eventPlayer.enhancementValue4 <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValue4))), null, "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValue4 <= 0 else [], HudPosition.LEFT, 99, colorChargeBatteryConst if eventPlayer.enhancementValue4 <= 0 else Color.RED, colorChargeBatteryConst, colorChargeBatteryConst if eventPlayer.enhancementValue4 <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
            #Battery placement visual
            createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValue4 <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, rgb(0, 255, 0, 204), worldVector(vect(0, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery ring
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue1 != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementValue1, 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery sphere
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue1 != 0 and eventPlayer.enhancementValue2 <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementValue1 + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Charge battery text
            createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValue1 != 0 and eventPlayer.enhancementValue2 <= 0 and distance(player.getPosition(), eventPlayer.enhancementValue1) < 6), "Charge Battery", eventPlayer.enhancementValue1 + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
            #Charge battery progress bar
            createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValue1 != 0 and eventPlayer.enhancementValue2 > 0 and distance(player.getPosition(), eventPlayer.enhancementValue1) < 6), 100 - eventPlayer.enhancementValue2 / eventPlayer.enhancementValue3 * 100, [], eventPlayer.enhancementValue1 + vect(0, 0.4, 0), 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)
            eventPlayer.enhancementValue3 = 10
            break
        #Hitchhiker
        case Enhancement.HITCHHIKER:
            #Enhancement Selection: Hitchhiker
            # enhancementValue1: carrier player reference, for attachment, shared health, assists and HUD; 0 when detached.
            # enhancementValue2: extra health pool ID on this passenger, retained to remove that pool when detaching.
            hudText(eventPlayer, "Hitchhiker {0}".format(iconString(Icon.FLAG)), null, "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.attached else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size) else [], HudPosition.LEFT, 99, Color.PURPLE, Color.PURPLE, Color.RED if eventPlayer.attached else Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Shared Health Bar Rider
            hudSubheader(eventPlayer.filter(lambda _: eventPlayer.attached), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementValue1.getHero()), eventPlayer.enhancementValue1), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            #Shared Health Bar Runner
            hudSubheader(eventPlayer.enhancementValue1.filter(lambda _: eventPlayer.attached), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            eventPlayer.enhancementValue1 = 0
            eventPlayer.enhancementValue1.startGrantingAssistFor(eventPlayer)
            break
        #P.U.P.
        case Enhancement.PUP:
            #Enhancement Selection: P.U.P.
            # enhancementValue1: current drone color, indicating its mode in the HUD, sphere and beam.
            # enhancementValue2: whether the attack beam is active; also controls its sound and pauses cooldown decay.
            # enhancementValue3: current enemy target, shared by movement, attack and target cleanup rules; null when idle.
            # enhancementValue4: whether the freezing aura effect is visible around the target.
            # enhancementValue5: chased drone position in world coordinates, for movement, effects and attack direction.
            # enhancementValue6: remaining ability cooldown in seconds (2 after freezing, 1 after laser), gating target selection.
            hudHeader(eventPlayer, "P.U.P. {0}".format(iconString(Icon.HAPPY)), HudPosition.LEFT, 99, Color.BLUE if eventPlayer.enhancementValue1 == Color.SKY_BLUE and eventPlayer.enhancementValue6 > 0 else eventPlayer.enhancementValue1, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Postion of P.U.P.
            eventPlayer.enhancementValue5 = eventPlayer.getPosition() + vect(0, 200, 0)
            #P.U.P. Default movment
            chaseAtRate(eventPlayer.enhancementValue5, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementValue5), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementValue5) - 1))
            eventPlayer.enhancementValue6 = 0
            #P.U.P. ability cooldown
            chaseAtRate(eventPlayer.enhancementValue6, 0, 0 if eventPlayer.enhancementValue2 else 1)
            #P.U.P. visual
            createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.enhancementValue1, eventPlayer.enhancementValue5, 0.25)
            #P.U.P. Beam
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue2 and eventPlayer.enhancementValue3 != null), Beam.GOOD, eventPlayer.enhancementValue5, eventPlayer.enhancementValue3, eventPlayer.enhancementValue1)
            #P.U.P using beam sound
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue2), Effect.BEACON_SOUND, Color.SKY_BLUE, eventPlayer.enhancementValue5, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Freeze aura
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValue4), Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.enhancementValue3, eventPlayer.enhancementValue3.size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Default color
            eventPlayer.enhancementValue1 = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValue2 = false
            #P.U.P. target null
            eventPlayer.enhancementValue3 = null
            #Freeze aura visibility
            eventPlayer.enhancementValue4 = false


rule "ZOMBIE HYBRID":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValue1 <= 0
    @Condition eventPlayer.infectionLvl >= 1
    
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamage)
    eventPlayer.infectionLvl = 0
    eventPlayer.enhancementValue1 = 20
    while eventPlayer.enhancementValue1 > 0:
        wait(1)
        eventPlayer.enhancementValue1 += -1


rule "LASER BARRICADE (PLACEMENT)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.LASER_BARRICADE
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValue3 <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    #Laser Barrier health
    eventPlayer.enhancementValue7 = 10000
    #Barrier center point
    eventPlayer.enhancementValue4 = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.enhancementValue5 = eventPlayer.enhancementValue4 + worldVector(vect(-0.5 * LASER_BARRICADE_WIDTH, 0, 0), eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.enhancementValue6 = eventPlayer.enhancementValue4 + worldVector(vect(0.5 * LASER_BARRICADE_WIDTH, 0, 0), eventPlayer, Transform.ROTATION)
    # Horizontal push direction captured at placement; reference points are center +/- this vector.
    eventPlayer.enhancementValue1 = directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    # Along-barrier direction, reused by collision checks.
    eventPlayer.enhancementValue2 = directionTowards(eventPlayer.enhancementValue5, eventPlayer.enhancementValue6)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.enhancementValue4, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.enhancementValue4, 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.enhancementValue3 = 30
    while eventPlayer.enhancementValue3 > 0:
        wait(1)
        eventPlayer.enhancementValue3 += -1


rule "LASER BARRICADE BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.LASER_BARRICADE
    #Barrier health is greater than 0
    @Condition eventPlayer.enhancementValue7 > 0
    #Horizontal distance check
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(eventPlayer.enhancementValue4, vect(player.getPosition().x, eventPlayer.enhancementValue4.getPosition().y, player.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) == true
    #If feet are below highest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getPosition().y < eventPlayer.enhancementValue4.y + LASER_BARRICADE_HEIGHT) == true
    #If eyes are above lowest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getEyePosition().y > eventPlayer.enhancementValue4.y) == true
    #Distance from wall
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(vect(player.getPosition().x, eventPlayer.enhancementValue5.y, player.getPosition().z), eventPlayer.enhancementValue5 + eventPlayer.enhancementValue2 * (min(LASER_BARRICADE_WIDTH, abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValue2, directionTowards(eventPlayer.enhancementValue5, vect(player.getPosition().x, eventPlayer.enhancementValue5.y, player.getPosition().z)))) * distance(eventPlayer.enhancementValue5, vect(player.getPosition().x, eventPlayer.enhancementValue5.y, player.getPosition().z)))))) < 1.5) == true
    
    stopChasing(eventPlayer.enhancementValue7)
    #Filter horizontal distance, feet height, eye height and distance from wall together.
    eventPlayer.potentialTargets = getLivingPlayers(Team.2).filter(lambda target: (distance(eventPlayer.enhancementValue4, vect(target.getPosition().x, eventPlayer.enhancementValue4.getPosition().y, target.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) and (target.getPosition().y < eventPlayer.enhancementValue4.y + LASER_BARRICADE_HEIGHT) and (target.getEyePosition().y > eventPlayer.enhancementValue4.y) and (distance(vect(target.getPosition().x, eventPlayer.enhancementValue5.y, target.getPosition().z), eventPlayer.enhancementValue5 + eventPlayer.enhancementValue2 * (min(LASER_BARRICADE_WIDTH, abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValue2, directionTowards(eventPlayer.enhancementValue5, vect(target.getPosition().x, eventPlayer.enhancementValue5.y, target.getPosition().z)))) * distance(eventPlayer.enhancementValue5, vect(target.getPosition().x, eventPlayer.enhancementValue5.y, target.getPosition().z)))))) < 1.5))
    # tmp1: both push reference points, reconstructed from saved geometry and consumed before wait.
    tmp1 = [eventPlayer.enhancementValue4 + eventPlayer.enhancementValue1, eventPlayer.enhancementValue4 + eventPlayer.enhancementValue1 * -1]
    # tmp0: barricade target index, to damage and push each zombie crossing the barrier.
    for tmp0 in range(len(eventPlayer.potentialTargets)):
        eventPlayer.botTarget = eventPlayer.potentialTargets[tmp0]
        if not eventPlayer.botTarget.hasStatus(Status.ROOTED):
            #Damage the barricade
            eventPlayer.enhancementValue7 -= eventPlayer.botTarget.getMaxHealth() * 2.5
            eventPlayer.botTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(eventPlayer.botTarget, eventPlayer, 10)
        if eventPlayer.botTarget.getThrottle() == vect(0, 0, 0):
            #If bot is not throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValue4, (sorted(tmp1, lambda x: distance(eventPlayer.botTarget.getPosition(), x)))[0])), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValue4.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValue4, (sorted(tmp1, lambda x: angleBetweenVectors(worldVector(eventPlayer.botTarget.getThrottle(), eventPlayer.botTarget, Transform.ROTATION), directionTowards(eventPlayer.enhancementValue4, x)))).last())), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValue4.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.enhancementValue7 > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.enhancementValue7 <= 0:
            eventPlayer.enhancementValue7 = 1
    chaseAtRate(eventPlayer.enhancementValue7, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()


rule "BRAIN KILLER EXTRA DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BRAIN_KILLER
    @Condition eventWasCriticalHit == true
    
    #Critical hits deal 50% more damage, 20% if vicitm is a boss
    damage(victim, eventPlayer, eventDamage * (0.2 if victim in bossStateList else 0.6))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, rgb(100, 14, 14), victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.size, 0.1 * victim.size)


rule "PYROTECHNIC SETS ENEMIES ON FIRE":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker.enhancementId == Enhancement.PYROTECHNIC
    @Condition victim != eventPlayer
    @Condition eventAbility != null
    @Condition distance(attacker.getPosition(), victim.getPosition()) < 15
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    attacker.enhancementValue1.append(victim)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PYROTECHNIC
    @Condition len(eventPlayer.enhancementValue1) > 0
    
    while len(eventPlayer.enhancementValue1) > 0:
        # tmp0: zombie to burn; consumed within this iteration before the cooldown wait.
        tmp0 = eventPlayer.enhancementValue1[0]
        if tmp0.isAlive():
            # tmp1: damage per second based on hits in the last cycle, used immediately.
            tmp1 = min(4 * (len(eventPlayer.enhancementValue1.filter(lambda x: x == tmp0))), 30)
            if tmp0 in bossStateList:
                # tmp1: halve this zombie's damage if it is a boss.
                tmp1 /= 2
            tmp0.startDamageOverTime(eventPlayer, 3, tmp1)
        eventPlayer.enhancementValue1.remove(tmp0)
    wait(0.5)
    if ruleCondition:
        loop()


rule "BORN TO BATTLE PLAYER EARNS ELIMINATION":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementValue1 != true
    
    eventPlayer.enhancementValue1 = true


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementValue1 == true
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementValue2 = Button.SECONDARY_FIRE
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.enhancementValue2 = Button.ABILITY_1
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.enhancementValue2 = Button.ABILITY_2
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.enhancementValue2 = Button.CROUCH
    elif eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.enhancementValue2 = Button.JUMP
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementValue2 == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValue2, 1)
            eventPlayer.enhancementValue1 = false
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementValue2 == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValue2, 1)
            eventPlayer.enhancementValue1 = false
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementValue2, eventPlayer.getAbilityCharge(eventPlayer.enhancementValue2) + 1)
    lbl_0:
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementValue2) > 0:
        eventPlayer.enhancementValue1 = false
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementValue2) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementValue2, 0)
        eventPlayer.enhancementValue1 = false


rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR
    
    if eventPlayer.infected:
        eventPlayer.infectionLvl -= eventHealing / 500
        eventPlayer.enhancementValue1 += eventHealing / 500
    if healee.infectionLvl >= 1 and healee.enhancementId != Enhancement.ZOMBIE_HYBRID:
        healee.infectionLvl -= eventHealing / 275
        eventPlayer.enhancementValue1 += eventHealing / 275
        if healee.infectionLvl < 1:
            healee.infectionLvl -= 0.5
            eventPlayer.enhancementValue1 += 0.5
            playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
            smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "CHARGE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValue4 <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    eventPlayer.enhancementValue1 = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementValue4 = 20
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementValue1, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementValue1, 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementValue2 = 0
    while eventPlayer.enhancementValue4 > 0:
        wait(1)
        eventPlayer.enhancementValue4 += -1


rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition eventPlayer.enhancementValue1 != 0
    @Condition (playerTargetList.any(lambda x: x.getUltCharge() < 100 and distance(x.getPosition(), eventPlayer.enhancementValue1) < 1.5 * x.size)) == true
    
    # tmp0: survivor using the battery, to play feedback and grant ultimate charge before cooldown waits.
    tmp0 = (getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(player.getPosition(), eventPlayer.enhancementValue1) < 1.5))[0]
    playEffect(tmp0, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, tmp0, 50)
    playEffect(tmp0, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementValue1, 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, tmp0, 1)
    tmp0.setUltCharge(tmp0.getUltCharge() + 15)
    eventPlayer.enhancementValue2 = eventPlayer.enhancementValue3
    while eventPlayer.enhancementValue2 > 0:
        wait(0.5)
        eventPlayer.enhancementValue2 += -0.5
    if ruleCondition:
        loop()


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.attached and (not eventPlayer.hasSpawned() or not eventPlayer.enhancementValue1.hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementValue1.isDead() or not entityExists(eventPlayer.enhancementValue1) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementValue1.hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer.getPosition(), eventPlayer.enhancementValue1.getPosition()) > 3 * eventPlayer.enhancementValue1.size))) == true
    @Condition eventPlayer.getHero() != Hero.MEI
    
    if not eventPlayer.attached and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size):
            #Select parent
            eventPlayer.enhancementValue1 = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.crowdControlled and distance(eventPlayer.getPosition(), x.getPosition()) < x.size * 2), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            # tmp0: attachment position in world space, converted and captured before any wait.
            tmp0 = eventPlayer.enhancementValue1.getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValue1.getPosition(), eventPlayer.getPosition())), 0) * eventPlayer.enhancementValue1.size + vect(0, eventPlayer.enhancementValue1.size, 0)
            # tmp0: convert the attachment position to the parent's local coordinates.
            tmp0 = localVector(tmp0, eventPlayer.enhancementValue1, Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if tmp0.z > 0:
                # tmp0: mirror a forward offset behind the parent.
                tmp0 *= vect(1, 1, -1)
            # tmp0: raise the final local offset before capturing it in attachTo.
            tmp0 += Vector.UP
            eventPlayer.attached = true
            eventPlayer.attachTo(eventPlayer.enhancementValue1, evalOnce(tmp0))
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementValue1.initialMaxHealth, true, false)
            eventPlayer.enhancementValue2 = getLastCreatedHealthPool()
            eventPlayer.enhancementValue1.hitchhikerPassenger = eventPlayer
    else:
        if entityExists(eventPlayer.enhancementValue1) and eventPlayer.hasSpawned() and distance(eventPlayer.getPosition(), eventPlayer.enhancementValue1.getPosition()) < 3 * eventPlayer.enhancementValue1.size:
            eventPlayer.teleport(eventPlayer.enhancementValue1.getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.enhancementValue1.hitchhikerPassenger = null
        eventPlayer.attached = false
        eventPlayer.enhancementValue1 = 0
        removeHealthPool(eventPlayer.enhancementValue2)
        wait(1.5)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hitchhikerPassenger != null
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.hitchhikerPassenger.initialMaxHealth, true, false)
    eventPlayer.hitchhikerCarrierHealthPool = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.hitchhikerPassenger), 99999)
    removeHealthPool(eventPlayer.hitchhikerCarrierHealthPool)


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValue1.isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.enhancementValue1.getNormalizedHealth()) > 0.01
    
    # tmp0: health to transfer this update; consumed by both setHealth actions before wait.
    tmp0 = (abs(eventPlayer.getHealth() * eventPlayer.enhancementValue1.getMaxHealth() - eventPlayer.enhancementValue1.getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.enhancementValue1.getMaxHealth())
    # tmp1: player with lower normalized health, receiving the transfer immediately.
    tmp1 = sorted(eventPlayer.concat(eventPlayer.enhancementValue1), lambda x: x.getNormalizedHealth())[0]
    # tmp2: other player, giving the transfer immediately; keep all three scratch values distinct.
    tmp2 = eventPlayer.concat(eventPlayer.enhancementValue1).exclude(tmp1)
    tmp1.setHealth(tmp1.getHealth() + tmp0)
    tmp2.setHealth(tmp2.getHealth() - tmp0)
    wait()
    if ruleCondition:
        loop()


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementValue6 <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementValue3 == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 10)) == true
    
    #Set P.U.P. target
    eventPlayer.enhancementValue3 = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    waitUntil(eventPlayer.enhancementValue3.isDead() or not entityExists(eventPlayer.enhancementValue3) or eventPlayer.enhancementValue3.teleporting, 99999)
    stopChasing(eventPlayer.enhancementValue5)
    eventPlayer.enhancementValue3 = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementValue5)
    #Default color
    eventPlayer.enhancementValue1 = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValue2 = false
    #P.U.P. target null
    eventPlayer.enhancementValue3 = null
    #Freeze aura visibility
    eventPlayer.enhancementValue4 = false
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    #P.U.P. Default movement
    chaseAtRate(eventPlayer.enhancementValue5, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementValue5), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementValue5) - 1))


rule "P.U.P. CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    @Condition eventPlayer.enhancementValue3 != null
    
    #P.U.P. attack movement
    chaseAtRate(eventPlayer.enhancementValue5, eventPlayer.enhancementValue3.getEyePosition() + directionTowards(eventPlayer.enhancementValue3.getEyePosition(), eventPlayer.enhancementValue5) * 2, (abs(distance(eventPlayer.enhancementValue3.getEyePosition(), eventPlayer.enhancementValue5) - 2)) * 1.5)
    #Default color
    eventPlayer.enhancementValue1 = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValue2 = false
    #Freeze aura visibility
    eventPlayer.enhancementValue4 = false
    waitUntil(distance(eventPlayer.enhancementValue5, eventPlayer.enhancementValue3.getEyePosition()) < 5 or eventPlayer.enhancementValue3 == null, 99999)
    #If target still exists
    if eventPlayer.enhancementValue3 != null:
        if distance(eventPlayer.getPosition(), eventPlayer.enhancementValue3.getPosition()) > 6:
            #P.U.P. color
            eventPlayer.enhancementValue1 = Color.WHITE
            #Beam visibility
            eventPlayer.enhancementValue2 = true
            #Freeze aura visibility
            eventPlayer.enhancementValue4 = true
            wait(0.25, Wait.ABORT_WHEN_FALSE)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, eventPlayer.enhancementValue3, 0.1)
            #Time to freeze dependent on max health of target
            wait(min(15, eventPlayer.enhancementValue3.getMaxHealth() / 300), Wait.ABORT_WHEN_FALSE)
            #Freeze cooldown
            eventPlayer.enhancementValue6 = 2
            eventPlayer.enhancementValue3.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            while not eventPlayer.enhancementValue3.hasStatus(Status.FROZEN):
                eventPlayer.enhancementValue3.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            #Freeze zombies around target for shorter time
            ((getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementValue3.getPosition(), player.getPosition()) < 3)).exclude(eventPlayer.enhancementValue3)).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            #P.U.P. color
            eventPlayer.enhancementValue1 = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValue2 = false
            #Freeze aura visibility
            eventPlayer.enhancementValue4 = false
        else:
            #P.U.P. color
            eventPlayer.enhancementValue1 = Color.RED
            #Beam visibility
            eventPlayer.enhancementValue2 = true
            eventPlayer.enhancementValue3.startDamageOverTime(eventPlayer, 3, 30)
            #Beam from P.U.P.
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementValue5, 0.25)
            #Beam hits P.U.P.'s target
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementValue3, 1)
            eventPlayer.enhancementValue3.setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementValue3.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValue5, eventPlayer.enhancementValue3.getPosition())), min(-20, verticalAngleOfDirection(directionTowards(eventPlayer.enhancementValue5, eventPlayer.enhancementValue3.getPosition())))), min(25, 4200 / eventPlayer.enhancementValue3.getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementValue3.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementValue6 = 1
            wait(3, Wait.ABORT_WHEN_FALSE)
            #P.U.P. color
            eventPlayer.enhancementValue1 = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValue2 = false
        stopChasing(eventPlayer.enhancementValue5)
        #P.U.P. target
        eventPlayer.enhancementValue3 = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
