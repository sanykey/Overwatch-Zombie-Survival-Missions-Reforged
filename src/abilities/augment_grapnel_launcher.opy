#!mainFile "../../main.opy"

subroutine checkGrapnelCaster

# Synchronous result, consumed by the next pull or cleanup guard.
#!define grapnelCasterCanMove tmp3

def checkGrapnelCaster():
    grapnelCasterCanMove = (
        eventPlayer.hasSpawned()
        and eventPlayer.isAlive()
        and not augmentMovementBlocked
        and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0]
    )


macro useGrapnelLauncherMacro():
    # Cooldown is checked on the input edge; holding the chord through expiry
    # cannot auto-launch. A miss does not consume the cooldown.
    if not eventPlayer.hasSpawned() or getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt:
        return
    # Zombies and allies are both valid anchors; the candidate closest in the
    # aim cone to the crosshair wins.
    # botIsTeleporting shares its slot with Team 1 votes/Rescue paths; only
    # interpret that slot as a teleport flag on Team 2, including during travel.
    # Shared selection consumes scratch synchronously; persist/capture its result before waits.
    pullAimMode = PullAimMode.GRAPNEL
    selectPullAimTarget()
    if pullAimTarget == null:
        return
    eventPlayer.augmentGrapnelTarget = pullAimTarget
    eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + AUGMENT_GRAPNEL_COOLDOWN
    # Same white Grapple beam as the sentry turret. Its two endpoints reevaluate
    # body centers, retaining only this augment's player slots across the pull.
    createBeam(getAllPlayers(), Beam.GRAPPLE, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.augmentGrapnelState = [eventPlayer.getHero(), getLastCreatedEntity()]
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
    # Keep world/player collisions and attack inputs intact. Only an active pull
    # updates movement; every exit reaches cleanup, even after releasing the chord.
    # Teams are fixed for the match, so the locked target's team cannot change.
    checkGrapnelCaster()
    while (
        isGameplayActive and grapnelCasterCanMove
        and eventPlayer.augmentGrapnelTarget.isAlive()
        and (eventPlayer.augmentGrapnelTarget.getTeam() == Team.1 or not eventPlayer.augmentGrapnelTarget.botIsTeleporting)
        and getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt - (AUGMENT_GRAPNEL_COOLDOWN - AUGMENT_GRAPNEL_TIMEOUT)
    ):
        # These endpoints are used only in this iteration, before damage or a wait.
        #!define grapnelPullOrigin tmp1
        #!define grapnelPullAnchor tmp2
        grapnelPullOrigin = augmentGrapnelCenter(eventPlayer)
        grapnelPullAnchor = augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)
        if not isInLoS(grapnelPullOrigin, grapnelPullAnchor):
            break
        if distance(grapnelPullOrigin, grapnelPullAnchor) <= 1.5 * eventPlayer.sizeScale + 0.5 * eventPlayer.augmentGrapnelTarget.sizeScale:
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, grapnelPullAnchor, AUGMENT_GRAPNEL_PUSH_RADIUS)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 100)
            # The impact uses the same tmp3 as damageWithEnhancements; its handler preserves the victim.
            #!define grapnelImpactTarget tmp3
            grapnelImpactTarget = eventPlayer.augmentGrapnelTarget
            # Pull endpoints are consumed. Reuse scratch for the wave before the direct hit.
            #!define grapnelPushTargets tmp0
            #!define grapnelPushTargetIndex tmp1
            #!define grapnelPushTarget tmp2
            # Push surrounding zombies; the anchor retains its separate impact behavior.
            grapnelPushTargets = getPlayersInRadius(grapnelImpactTarget, AUGMENT_GRAPNEL_PUSH_RADIUS, Team.2, LosCheck.SURFACES).exclude(bossStateList.concat(grapnelImpactTarget)).filter(lambda zombie: zombie.isAlive() and not zombie.botIsTeleporting and not zombie.botIsAttached and zombie.botKnockbackScale > 0)
            for grapnelPushTargetIndex in range(len(grapnelPushTargets)):
                grapnelPushTarget = grapnelPushTargets[grapnelPushTargetIndex]
                grapnelPushTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(grapnelImpactTarget, grapnelPushTarget)), -15), AUGMENT_GRAPNEL_PUSH_IMPULSE * grapnelPushTarget.botKnockbackScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                grapnelPushTarget.setEnvironmentalKillCreditor(eventPlayer)
            # A direct hit on a zombie applies impact damage and crowd control.
            if grapnelImpactTarget.getTeam() == Team.2:
                damageWithEnhancements(AUGMENT_GRAPNEL_DAMAGE, grapnelImpactTarget)
                if grapnelImpactTarget.isOnGround():
                    grapnelImpactTarget.setStatusEffect(eventPlayer, Status.STUNNED, AUGMENT_GRAPNEL_GROUND_STUN_DURATION)
                else:
                    grapnelImpactTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, AUGMENT_GRAPNEL_AIR_KNOCKDOWN_DURATION)
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, grapnelImpactTarget.getPosition() + Vector.UP, AUGMENT_IMPACT_SIZE)
            # The synchronous hit helper preserves the wave list and loop index in tmp0/tmp1.
            for grapnelPushTargetIndex in range(len(grapnelPushTargets)):
                damageWithEnhancements(AUGMENT_GRAPNEL_PUSH_DAMAGE, grapnelPushTargets[grapnelPushTargetIndex])
            # Scratch is set after impact handling and read without a wait.
            #!define grapnelExitUpSpeed tmp0
            grapnelExitUpSpeed = AUGMENT_GRAPNEL_JUMP_IMPULSE if eventPlayer.isHoldingButton(Button.JUMP) else 0
            goto grapnelCleanup
        # Synchronous scratch: correct current velocity to the desired velocity,
        # rather than stacking 40-speed impulses every frame. Consumed before wait.
        #!define augmentGrapnelVelocityDelta tmp0
        augmentGrapnelVelocityDelta = directionTowards(grapnelPullOrigin, grapnelPullAnchor) * AUGMENT_GRAPNEL_SPEED - eventPlayer.getVelocity()
        eventPlayer.applyImpulse(augmentGrapnelVelocityDelta, magnitude(augmentGrapnelVelocityDelta), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.05, Wait.IGNORE_CONDITION)
        checkGrapnelCaster()
    grapnelExitUpSpeed = 0
    grapnelCleanup:
    destroyEffect(eventPlayer.augmentGrapnelState[1])
    # Like Dash, subtract all current velocity to reach the desired velocity in one impulse.
    # Preserve movement after a hero swap, native crowd control, or attachment.
    checkGrapnelCaster()
    if grapnelCasterCanMove:
        augmentGrapnelVelocityDelta = vect(0, grapnelExitUpSpeed, 0) - eventPlayer.getVelocity()
        eventPlayer.applyImpulse(augmentGrapnelVelocityDelta, magnitude(augmentGrapnelVelocityDelta), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.augmentGrapnelTarget = null
    eventPlayer.augmentGrapnelState = null


rule "GRAPNEL LAUNCHER DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER) and (eventPlayer.augmentGrapnelState != null):
        # Follow the project's supplied playerLeft cleanup pattern: consume the
        # departing player's effect ID synchronously in the departure event.
        destroyEffect(eventPlayer.augmentGrapnelState[1])
