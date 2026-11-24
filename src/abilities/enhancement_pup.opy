#!mainFile "../../main.opy"


def resetPupColorAndBeam():
    @Name "resetPupColorAndBeam"

    eventPlayer.enhancementPupColor = Color.SKY_BLUE
    eventPlayer.enhancementIsPupBeamActive = false


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementPupCooldown <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementPupTarget == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer, player) < 10)) == true

    #Set P.U.P. target
    eventPlayer.enhancementPupTarget = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer, x)))[0]
    waitUntil(eventPlayer.enhancementPupTarget.isDead() or not entityExists(eventPlayer.enhancementPupTarget) or eventPlayer.enhancementPupTarget.botIsTeleporting, Math.INFINITY)
    stopChasing(eventPlayer.enhancementPupPosition)
    eventPlayer.enhancementPupTarget = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementPupPosition)
    resetPupColorAndBeam()
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
    resetPupColorAndBeam()
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
    waitUntil(distance(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getEyePosition()) < 5 or eventPlayer.enhancementPupTarget == null, Math.INFINITY)
    #If target still exists
    if eventPlayer.enhancementPupTarget != null:
        if distance(eventPlayer, eventPlayer.enhancementPupTarget) > PUP_IGNITE_RANGE:
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
            eventPlayer.enhancementPupCooldown = PUP_FREEZE_COOLDOWN
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            # A target that never accepts Frozen must still release the drone.
            for eventPlayer.enhancementPupFreezeRetryIndex in range(PUP_FREEZE_MAX_RETRIES):
                if eventPlayer.enhancementPupTarget.hasStatus(Status.FROZEN):
                    break
                eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            if eventPlayer.enhancementPupTarget.hasStatus(Status.FROZEN):
                # Freeze nearby zombies only after the primary target is frozen.
                getPlayersInRadius(eventPlayer.enhancementPupTarget, 3, Team.2).exclude(eventPlayer.enhancementPupTarget).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            resetPupColorAndBeam()
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
            # Synchronous direction shared by the horizontal and vertical angles.
            #!define pupImpulseDirection tmp0
            pupImpulseDirection = directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget)
            eventPlayer.enhancementPupTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(pupImpulseDirection), min(-20, verticalAngleOfDirection(pupImpulseDirection))), min(25, 4200 / eventPlayer.enhancementPupTarget.getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementPupCooldown = PUP_LASER_COOLDOWN
            wait(3, Wait.ABORT_WHEN_FALSE)
            resetPupColorAndBeam()
        stopChasing(eventPlayer.enhancementPupPosition)
        #P.U.P. target
        eventPlayer.enhancementPupTarget = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


def startPupDefaultChase():
    @Name "startPupDefaultChase"

    chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition) - 1))


macro initializePupMacro():
    #Enhancement Selection: P.U.P.
    # enhancementPupColor: current drone color, indicating its mode in the sphere and beam.
    # enhancementIsPupBeamActive: whether the attack beam is active; also controls its sound and pauses cooldown decay.
    # enhancementPupTarget: current enemy target, shared by movement, attack and target cleanup rules; null when idle.
    # enhancementIsPupFreezeAuraActive: whether the freezing aura effect is visible around the target.
    # enhancementPupPosition: chased drone position in world coordinates, for movement, effects and attack direction.
    # enhancementPupCooldown: remaining ability cooldown in seconds (2 after freezing, 1 after laser), gating target selection.
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
    resetPupColorAndBeam()
    #P.U.P. target null
    eventPlayer.enhancementPupTarget = null
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
