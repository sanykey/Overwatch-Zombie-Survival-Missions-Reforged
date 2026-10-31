#!mainFile "main.opy"


rule "PLAYER ENHANCEMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition gameStatus == true
    @Condition eventPlayer.isDummy() != true
    @Condition eventPlayer.switchedHeroes == false
    
    if eventPlayer.enhancementValues[0] == 0:
        #Default Enhancement: Workshop Setting
        eventPlayer.enhancementValues[0] = createWorkshopSettingEnum("Enhancements", "Default Enhancement", 9, ["No Enhancement", "Kevlar", "Zombie Hybrid", "Laser Barricade", "Brain Killer", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P."])
    #Kevlar
    if eventPlayer.enhancementValues[0] == 1:
        #Enhancement Selection: Kevlar
        hudHeader(eventPlayer, "Kevlar {0}".format(iconString(Icon.STOP)), HudPosition.LEFT, 99, rgb(240, 129, 26), HudReeval.STRING)
        waitUntil(eventPlayer.initialMaxHealth != 0, 99999)
        eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
        eventPlayer.enhancementValues[1] = getLastCreatedHealthPool()
    #Zombie Hybrid
    if eventPlayer.enhancementValues[0] == 2:
        #Enhancement: Zombie Hyrbid
        hudText(eventPlayer, "Zombie Hybrid {0}".format(iconString(Icon.POISON) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLvl)) if eventPlayer.infectionLvl >= 1 and eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, Color.GRAY, Color.GRAY if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionSize = 1.25
        eventPlayer.explosionColor1 = Color.GRAY
        eventPlayer.explosionColor2 = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLvl, 0, 0.015 if eventPlayer.infectionLvl > 0 else 0)
    #Laser Barricade
    switch eventPlayer.enhancementValues[0]:
        case 3:
            #Enhancement: Laser Barricade
            hudText(eventPlayer, "Laser Barricade {0}{1}".format(iconString(Icon.DIAMOND), " {0}s".format(eventPlayer.enhancementValues[3]) if eventPlayer.enhancementValues[3] > 0 else []), " {0}HP".format(ceil(eventPlayer.enhancementChase1)) if eventPlayer.enhancementChase1 > 0 else [], "Hold [{0}] to place a barricade".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[3] <= 0 else [], HudPosition.LEFT, 99, Color.RED if eventPlayer.enhancementValues[3] > 0 else Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Barricade placement visual
            createBeam(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValues[3] <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * eventPlayer.enhancementValues[2], 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * eventPlayer.enhancementValues[2], 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade bottom
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[4] != null), Beam.BAD, eventPlayer.enhancementValues[5], eventPlayer.enhancementValues[6], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 1
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[5] + vect(0, eventPlayer.enhancementValues[1], 0), eventPlayer.enhancementValues[5], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade side 2
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[6], eventPlayer.enhancementValues[6] + vect(0, eventPlayer.enhancementValues[1], 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade top
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementChase1 > 0), Beam.BAD, eventPlayer.enhancementValues[6] + vect(0, eventPlayer.enhancementValues[1], 0), eventPlayer.enhancementValues[5] + vect(0, eventPlayer.enhancementValues[1], 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Barricade health
            createInWorldText(getAllPlayers() if eventPlayer.enhancementChase1 > 0 else null, "{0}HP".format(ceil(eventPlayer.enhancementChase1)), eventPlayer.enhancementValues[4] + vect(0, 1, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
            #Barrier height
            eventPlayer.enhancementValues[1] = 2
            #Barrier width
            eventPlayer.enhancementValues[2] = 5
            break
        #Brain Killer
        case 4:
            #Enhancement: Brain Killer
            hudHeader(eventPlayer, "Brain Killer {0}".format(iconString(Icon.SKULL)), HudPosition.LEFT, 99, Color.RED, HudReeval.STRING)
            break
        #Pyrotechnic
        case 5:
            #Enhancement: Pyrotechnic
            hudHeader(eventPlayer, "Pyrotechnic {0}".format(iconString(Icon.FIRE)), HudPosition.LEFT, 99, Color.ORANGE if eventPlayer.enhancementValues[1] else Color.RED, HudReeval.STRING_AND_COLOR)
            #Pyro Active
            eventPlayer.enhancementValues[1] = true
            #Special enhancement color
            eventPlayer.enhancementValues[2] = rgb(252, 78, 3)
            #Fire Fuel
            eventPlayer.enhancementChase1 = 100
            eventPlayer.enhancementChase2 = []
            break
        #Plague Doctor
        case 6:
            #Enhancement: Plague Doctor
            hudText(eventPlayer, "Plague Doctor {0}".format(iconString(Icon.PLUS)), null, "Infection Reduced: {0} lvls".format(eventPlayer.enhancementValues[1]), HudPosition.LEFT, 99, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.STRING)
            #Plague doctor does 100 + x% more healing to infected players
            startHealingModification(getPlayers(Team.1).filter(lambda player: player.infected), eventPlayer, 150, HealingReeval.RECEIVERS_AND_HEALERS)
            eventPlayer.enhancementValues[1] = 0
            break
        #Born to Battle
        case 7:
            #Enhancement: Born to Battle
            hudText(eventPlayer, "Born to Battle {0}".format(iconString(Icon.BOLT)), null, iconString(Icon.CHECKMARK) if eventPlayer.enhancementValues[1] else [], HudPosition.LEFT, 99, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.STRING)
            eventPlayer.enhancementValues[1] = false
            break
        #Charge Battery
        case 8:
            #Enhancement: Charge Battery
            hudText(eventPlayer, "Charge Battery {0}".format(iconString(Icon.SPIRAL) if eventPlayer.enhancementValues[4] <= 0 else "{0}s".format(ceil(eventPlayer.enhancementValues[4]))), null, "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementValues[4] <= 0 else [], HudPosition.LEFT, 99, rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, rgb(236, 206, 44), rgb(236, 206, 44) if eventPlayer.enhancementValues[4] <= 0 else Color.RED, HudReeval.STRING_AND_COLOR)
            #Battery placement visual
            createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementValues[4] <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, rgb(0, 255, 0, 204), worldVector(vect(0, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery ring
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[1] != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementValues[1], 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery sphere
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementValues[1] + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Charge battery text
            createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] <= 0 and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 6), "Charge Battery", eventPlayer.enhancementValues[1] + (vect(0, 0.5 + sin(getTotalTimeElapsed() * 1) * 0.15, 0)), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
            #Charge battery progress bar
            createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementValues[1] != 0 and eventPlayer.enhancementValues[2] > 0 and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 6), 100 - eventPlayer.enhancementValues[2] / eventPlayer.enhancementValues[3] * 100, [], eventPlayer.enhancementValues[1] + vect(0, 0.4, 0), 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)
            eventPlayer.enhancementValues[3] = 10
            break
        #Hitchhiker
        case 9:
            #Enhancement Selection: Hitchhiker
            hudText(eventPlayer, "Hitchhiker {0}".format(iconString(Icon.FLAG)), null, "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.attached else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size) else [], HudPosition.LEFT, 99, Color.PURPLE, Color.PURPLE, Color.RED if eventPlayer.attached else Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Shared Health Bar Rider
            hudSubheader(eventPlayer.filter(lambda _: eventPlayer.attached), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementValues[1].getHero()), eventPlayer.enhancementValues[1]), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            #Shared Health Bar Runner
            hudSubheader(eventPlayer.enhancementValues[1].filter(lambda _: eventPlayer.attached), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            eventPlayer.enhancementValues[1] = 0
            eventPlayer.enhancementValues[2] = 0
            eventPlayer.enhancementValues[1].startGrantingAssistFor(eventPlayer)
            break
        #P.U.P.
        case 10:
            #Enhancement Selection: P.U.P.
            hudHeader(eventPlayer, "P.U.P. {0}".format(iconString(Icon.HAPPY)), HudPosition.LEFT, 99, Color.BLUE if eventPlayer.enhancementValues[1] == Color.SKY_BLUE and eventPlayer.enhancementChase2 > 0 else eventPlayer.enhancementValues[1], HudReeval.VISIBILITY_STRING_AND_COLOR)
            #Postion of P.U.P.
            eventPlayer.enhancementChase1 = eventPlayer.getPosition() + vect(0, 200, 0)
            #P.U.P. Default movment
            chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1) - 1))
            eventPlayer.enhancementChase2 = 0
            #P.U.P. ability cooldown
            chaseAtRate(eventPlayer.enhancementChase2, 0, 0 if eventPlayer.enhancementValues[2] else 1)
            #P.U.P. visual
            createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.enhancementValues[1], eventPlayer.enhancementChase1, 0.25)
            #P.U.P. Beam
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[2] and eventPlayer.enhancementValues[3] != null), Beam.GOOD, eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3], eventPlayer.enhancementValues[1])
            #P.U.P using beam sound
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[2]), Effect.BEACON_SOUND, Color.SKY_BLUE, eventPlayer.enhancementChase1, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Freeze aura
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementValues[4]), Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.enhancementValues[3], eventPlayer.enhancementValues[3].size, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Default color
            eventPlayer.enhancementValues[1] = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValues[2] = false
            #P.U.P. target null
            eventPlayer.enhancementValues[3] = null
            #Freeze aura visibility
            eventPlayer.enhancementValues[4] = false
    eventPlayer.enhancementValues[11] = 0
    eventPlayer.enhancementValues[12] = false


rule "ZOMBIE HYBRID":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[4] <= 0
    @Condition eventPlayer.infectionLvl >= 1
    
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamage)
    eventPlayer.infectionLvl = 0
    eventPlayer.enhancementValues[4] = 20
    while eventPlayer.enhancementValues[4] > 0:
        wait(1)
        eventPlayer.enhancementValues[4] += -1


rule "LASER BARRICADE (PLACEMENT)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.enhancementValues[0] == 3
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[3] <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    #Laser Barrier health
    eventPlayer.enhancementChase1 = 10000
    #Barrier center point
    eventPlayer.enhancementValues[4] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.enhancementValues[5] = eventPlayer.enhancementValues[4] + worldVector(vect(-0.5 * eventPlayer.enhancementValues[2], 0, 0), eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.enhancementValues[6] = eventPlayer.enhancementValues[4] + worldVector(vect(0.5 * eventPlayer.enhancementValues[2], 0, 0), eventPlayer, Transform.ROTATION)
    #Reference point 1
    eventPlayer.enhancementValues[7] = eventPlayer.enhancementValues[4] + directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    #Reference point 2
    eventPlayer.enhancementValues[8] = eventPlayer.enhancementValues[4] + directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0) * -1
    #Reference direction
    eventPlayer.enhancementValues[9] = directionTowards(eventPlayer.enhancementValues[5], eventPlayer.enhancementValues[6])
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.enhancementValues[4], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.enhancementValues[4], 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.enhancementValues[3] = 30
    while eventPlayer.enhancementValues[3] > 0:
        wait(1)
        eventPlayer.enhancementValues[3] += -1


rule "LASER BARRICADE BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 3
    #Barrier health is greater than 0
    @Condition eventPlayer.enhancementChase1 > 0
    #Horizontal distance check
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(eventPlayer.enhancementValues[4], vect(player.getPosition().x, eventPlayer.enhancementValues[4].getPosition().y, player.getPosition().z)) < 0.5 * eventPlayer.enhancementValues[2]) == true
    #If feet are below highest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getPosition().y < eventPlayer.enhancementValues[4].y + eventPlayer.enhancementValues[1]) == true
    #If eyes are above lowest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getEyePosition().y > eventPlayer.enhancementValues[4].y) == true
    #Distance from wall
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z), eventPlayer.enhancementValues[5] + eventPlayer.enhancementValues[9] * (min(eventPlayer.enhancementValues[2], abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValues[9], directionTowards(eventPlayer.enhancementValues[5], vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z)))) * distance(eventPlayer.enhancementValues[5], vect(player.getPosition().x, eventPlayer.enhancementValues[5].y, player.getPosition().z)))))) < 1.5) == true
    
    stopChasing(eventPlayer.enhancementChase1)
    #Horizontal distance check
    eventPlayer.potentialTargets = getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementValues[4], vect(player.getPosition().x, eventPlayer.enhancementValues[4].getPosition().y, player.getPosition().z)) < 0.5 * eventPlayer.enhancementValues[2])
    #Filter feet height
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: x.getPosition().y < eventPlayer.enhancementValues[4].y + eventPlayer.enhancementValues[1])
    #Filter eye height
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: x.getEyePosition().y > eventPlayer.enhancementValues[4].y)
    #Filter distance from wall
    eventPlayer.potentialTargets = eventPlayer.potentialTargets.filter(lambda x: distance(vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z), eventPlayer.enhancementValues[5] + eventPlayer.enhancementValues[9] * (min(eventPlayer.enhancementValues[2], abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementValues[9], directionTowards(eventPlayer.enhancementValues[5], vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z)))) * distance(eventPlayer.enhancementValues[5], vect(x.getPosition().x, eventPlayer.enhancementValues[5].y, x.getPosition().z)))))) < 1.5)
    for eventPlayer.enhancementCount1 in range(len(eventPlayer.potentialTargets)):
        eventPlayer.botTarget = eventPlayer.potentialTargets[eventPlayer.enhancementCount1]
        if not eventPlayer.botTarget.hasStatus(Status.ROOTED):
            #Damage the barricade
            eventPlayer.enhancementChase1 -= eventPlayer.botTarget.getMaxHealth() * 2.5
            eventPlayer.botTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(eventPlayer.botTarget, eventPlayer, 10)
        if eventPlayer.botTarget.getThrottle() == vect(0, 0, 0):
            #If bot is not throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[4], (sorted(eventPlayer.enhancementValues.slice(7, 2), lambda x: distance(eventPlayer.botTarget.getPosition(), x)))[0])), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValues[4].y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            eventPlayer.botTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[4], (sorted(eventPlayer.enhancementValues.slice(7, 2), lambda x: angleBetweenVectors(worldVector(eventPlayer.botTarget.getThrottle(), eventPlayer.botTarget, Transform.ROTATION), directionTowards(eventPlayer.enhancementValues[4], x)))).last())), (-1 if eventPlayer.botTarget.getPosition().y > eventPlayer.enhancementValues[4].y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(eventPlayer.botTarget.getPosition(), eventPlayer.botTarget.getPosition() + vect(0, -1, 0), null, getAllPlayers(), false))))), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.enhancementChase1 > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.enhancementChase1 <= 0:
            eventPlayer.enhancementChase1 = 1
    chaseAtRate(eventPlayer.enhancementChase1, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()


rule "BRAIN KILLER EXTRA DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 4
    @Condition eventWasCriticalHit == true
    
    #Critical hits deal 50% more damage, 20% if vicitm is a boss
    damage(victim, eventPlayer, eventDamage * (0.2 if victim in bosses else 0.6))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, rgb(100, 14, 14), victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.size, 0.1 * victim.size)


rule "PYROTECHNIC SETS ENEMIES ON FIRE":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker.enhancementValues[0] == 5
    @Condition attacker.enhancementValues[1] == true
    @Condition victim != eventPlayer
    @Condition eventAbility != null
    @Condition distance(attacker.getPosition(), victim.getPosition()) < 15
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    attacker.enhancementChase2.append(victim)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 5
    @Condition len(eventPlayer.enhancementChase2) > 0
    
    while len(eventPlayer.enhancementChase2) > 0:
        #Zombie to burn
        eventPlayer.enhancementValues[3] = eventPlayer.enhancementChase2[0]
        if eventPlayer.enhancementValues[3].isAlive():
            #Amount of times zombie was hit in last cycle
            eventPlayer.enhancementValues[4] = min(4 * (len(eventPlayer.enhancementChase2.filter(lambda x: x == eventPlayer.enhancementValues[3]))), 30)
            if eventPlayer.enhancementValues[3] in bosses:
                eventPlayer.enhancementValues[4] /= 2
            eventPlayer.enhancementValues[3].startDamageOverTime(eventPlayer, 3, eventPlayer.enhancementValues[4])
        eventPlayer.enhancementChase2.remove(eventPlayer.enhancementValues[3])
    wait(0.5)
    if ruleCondition:
        loop()


rule "BORN TO BATTLE PLAYER EARNS ELIMINATION":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 7
    @Condition eventPlayer.enhancementValues[1] != true
    
    eventPlayer.enhancementValues[1] = true


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 7
    @Condition eventPlayer.enhancementValues[1] == true
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementValues[2] = Button.SECONDARY_FIRE
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.enhancementValues[2] = Button.ABILITY_1
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.enhancementValues[2] = Button.ABILITY_2
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.enhancementValues[2] = Button.CROUCH
    elif eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.enhancementValues[2] = Button.JUMP
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementValues[2] == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], 1)
            eventPlayer.enhancementValues[1] = false
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementValues[2] == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], 1)
            eventPlayer.enhancementValues[1] = false
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementValues[2], eventPlayer.getAbilityCharge(eventPlayer.enhancementValues[2]) + 1)
    lbl_0:
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementValues[2]) > 0:
        eventPlayer.enhancementValues[1] = false
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementValues[2]) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementValues[2], 0)
        eventPlayer.enhancementValues[1] = false


rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 6
    
    if eventPlayer.infected:
        eventPlayer.infectionLvl -= eventHealing / 500
        eventPlayer.enhancementValues[1] += eventHealing / 500
    if healee.infectionLvl >= 1 and healee.enhancementValues[0] != 2:
        healee.infectionLvl -= eventHealing / 275
        eventPlayer.enhancementValues[1] += eventHealing / 275
        if healee.infectionLvl < 1:
            healee.infectionLvl -= 0.5
            eventPlayer.enhancementValues[1] += 0.5
            playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
            smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "CHARGE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementValues[0] == 8
    @Condition gameStatus == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[4] <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), 99999)
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:
        return
    if eventPlayer.isDead():
        return
    eventPlayer.enhancementValues[1] = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementValues[4] = 20
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementValues[1], 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementValues[1], 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementValues[2] = 0
    while eventPlayer.enhancementValues[4] > 0:
        wait(1)
        eventPlayer.enhancementValues[4] += -1


rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.enhancementValues[0] == 8
    @Condition eventPlayer.enhancementValues[1] != 0
    @Condition (playerTargetList.any(lambda x: x.getUltCharge() < 100 and distance(x.getPosition(), eventPlayer.enhancementValues[1]) < 1.5 * x.size)) == true
    
    eventPlayer.interactEntity = (getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(player.getPosition(), eventPlayer.enhancementValues[1]) < 1.5))[0]
    playEffect(eventPlayer.interactEntity, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, eventPlayer.interactEntity, 50)
    playEffect(eventPlayer.interactEntity, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementValues[1], 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.interactEntity, 1)
    eventPlayer.interactEntity.setUltCharge(eventPlayer.interactEntity.getUltCharge() + 15)
    eventPlayer.enhancementValues[2] = eventPlayer.enhancementValues[3]
    while eventPlayer.enhancementValues[2] > 0:
        wait(0.5)
        eventPlayer.enhancementValues[2] += -0.5
    if ruleCondition:
        loop()


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 9
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.attached and (not eventPlayer.hasSpawned() or not eventPlayer.enhancementValues[1].hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementValues[1].isDead() or not entityExists(eventPlayer.enhancementValues[1]) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementValues[1].hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[1].getPosition()) > 3 * eventPlayer.enhancementValues[1].size))) == true
    @Condition eventPlayer.getHero() != Hero.MEI
    
    if not eventPlayer.attached and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.attached and distance(eventPlayer.getPosition(), x.getPosition()) < 2 * x.size):
            #Select parent
            eventPlayer.enhancementValues[1] = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.crowdControlled and distance(eventPlayer.getPosition(), x.getPosition()) < x.size * 2), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            #World Vector
            eventPlayer.enhancementValues[2] = eventPlayer.enhancementValues[1].getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementValues[1].getPosition(), eventPlayer.getPosition())), 0) * eventPlayer.enhancementValues[1].size + vect(0, eventPlayer.enhancementValues[1].size, 0)
            #Local vector conversion
            eventPlayer.enhancementValues[2] = localVector(eventPlayer.enhancementValues[2], eventPlayer.enhancementValues[1], Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if eventPlayer.enhancementValues[2].z > 0:
                eventPlayer.enhancementValues[2] *= vect(1, 1, -1)
            eventPlayer.enhancementValues[2] += Vector.UP
            eventPlayer.attached = true
            eventPlayer.attachTo(eventPlayer.enhancementValues[1], eventPlayer.enhancementValues[2])
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementValues[1].initialMaxHealth, true, false)
            eventPlayer.enhancementValues[6] = getLastCreatedHealthPool()
            eventPlayer.enhancementValues[1].enhancementValues[13] = eventPlayer
    else:
        if entityExists(eventPlayer.enhancementValues[1]) and eventPlayer.hasSpawned() and distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[1].getPosition()) < 3 * eventPlayer.enhancementValues[1].size:
            eventPlayer.teleport(eventPlayer.enhancementValues[1].getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.enhancementValues[1].enhancementValues[13] = null
        eventPlayer.attached = false
        eventPlayer.enhancementValues[1] = 0
        removeHealthPool(eventPlayer.enhancementValues[6])
        wait(1.5)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[13] != null
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementValues[13].initialMaxHealth, true, false)
    eventPlayer.enhancementValues[14] = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.enhancementValues[13]), 99999)
    removeHealthPool(eventPlayer.enhancementValues[14])


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 9
    @Condition eventPlayer.attached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementValues[1].isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.enhancementValues[1].getNormalizedHealth()) > 0.01
    
    eventPlayer.enhancementValues[3] = (abs(eventPlayer.getHealth() * eventPlayer.enhancementValues[1].getMaxHealth() - eventPlayer.enhancementValues[1].getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.enhancementValues[1].getMaxHealth())
    eventPlayer.enhancementValues[4] = sorted(eventPlayer.concat(eventPlayer.enhancementValues[1]), lambda x: x.getNormalizedHealth())[0]
    eventPlayer.enhancementValues[5] = eventPlayer.concat(eventPlayer.enhancementValues[1]).exclude(eventPlayer.enhancementValues[4])
    eventPlayer.enhancementValues[4].setHealth(eventPlayer.enhancementValues[4].getHealth() + eventPlayer.enhancementValues[3])
    eventPlayer.enhancementValues[5].setHealth(eventPlayer.enhancementValues[5].getHealth() - eventPlayer.enhancementValues[3])
    wait()
    if ruleCondition:
        loop()
    eventPlayer.enhancementValues[3] = 0


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 10
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementChase2 <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementValues[3] == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 10)) == true
    
    #Set P.U.P. target
    eventPlayer.enhancementValues[3] = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer.getPosition(), x.getPosition())))[0]
    waitUntil(eventPlayer.enhancementValues[3].isDead() or not entityExists(eventPlayer.enhancementValues[3]) or eventPlayer.enhancementValues[3].teleporting, 99999)
    stopChasing(eventPlayer.enhancementChase1)
    eventPlayer.enhancementValues[3] = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementChase1)
    #Default color
    eventPlayer.enhancementValues[1] = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValues[2] = false
    #P.U.P. target null
    eventPlayer.enhancementValues[3] = null
    #Freeze aura visibility
    eventPlayer.enhancementValues[4] = false
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    #P.U.P. Default movement
    chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementChase1) - 1))


rule "P.U.P. CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementValues[0] == 10
    @Condition eventPlayer.enhancementValues[3] != null
    
    #P.U.P. attack movement
    chaseAtRate(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getEyePosition() + directionTowards(eventPlayer.enhancementValues[3].getEyePosition(), eventPlayer.enhancementChase1) * 2, (abs(distance(eventPlayer.enhancementValues[3].getEyePosition(), eventPlayer.enhancementChase1) - 2)) * 1.5)
    #Default color
    eventPlayer.enhancementValues[1] = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementValues[2] = false
    #Freeze aura visibility
    eventPlayer.enhancementValues[4] = false
    waitUntil(distance(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getEyePosition()) < 5 or eventPlayer.enhancementValues[3] == null, 99999)
    #If target still exists
    if eventPlayer.enhancementValues[3] != null:
        if distance(eventPlayer.getPosition(), eventPlayer.enhancementValues[3].getPosition()) > 6:
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.WHITE
            #Beam visibility
            eventPlayer.enhancementValues[2] = true
            #Freeze aura visibility
            eventPlayer.enhancementValues[4] = true
            wait(0.25, Wait.ABORT_WHEN_FALSE)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, eventPlayer.enhancementValues[3], 0.1)
            #Time to freeze dependent on max health of target
            wait(min(15, eventPlayer.enhancementValues[3].getMaxHealth() / 300), Wait.ABORT_WHEN_FALSE)
            #Freeze cooldown
            eventPlayer.enhancementChase2 = 2
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            while not eventPlayer.enhancementValues[3].hasStatus(Status.FROZEN):
                eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            #Freeze zombies around target for shorter time
            ((getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementValues[3].getPosition(), player.getPosition()) < 3)).exclude(eventPlayer.enhancementValues[3])).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValues[2] = false
            #Freeze aura visibility
            eventPlayer.enhancementValues[4] = false
        else:
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.RED
            #Beam visibility
            eventPlayer.enhancementValues[2] = true
            eventPlayer.enhancementValues[3].startDamageOverTime(eventPlayer, 3, 30)
            #Beam from P.U.P.
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementChase1, 0.25)
            #Beam hits P.U.P.'s target
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementValues[3], 1)
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementValues[3].applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getPosition())), min(-20, verticalAngleOfDirection(directionTowards(eventPlayer.enhancementChase1, eventPlayer.enhancementValues[3].getPosition())))), min(25, 4200 / eventPlayer.enhancementValues[3].getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementValues[3].setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementChase2 = 1
            wait(3, Wait.ABORT_WHEN_FALSE)
            #P.U.P. color
            eventPlayer.enhancementValues[1] = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementValues[2] = false
        stopChasing(eventPlayer.enhancementChase1)
        #P.U.P. target
        eventPlayer.enhancementValues[3] = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
