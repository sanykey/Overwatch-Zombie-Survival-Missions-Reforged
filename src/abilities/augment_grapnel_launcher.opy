#!mainFile "../../main.opy"

macro augmentGrapnelCanMove = (
    eventPlayer.hasSpawned()
    and eventPlayer.isAlive()
    and not augmentMovementBlocked
)


rule "CROUCH + JUMP (GRAPNEL LAUNCHER)":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER)
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Cooldown is checked on the input edge; holding the chord through expiry
    # cannot auto-launch. A miss does not consume the cooldown.
    if getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt or augmentMovementBlocked:
        return
    # Zombies and allies are both valid anchors; the candidate closest in the
    # aim cone to the crosshair wins. The all-team query includes this player, so self must go.
    # botIsTeleporting shares its slot with Team 1 votes/Rescue paths; only
    # interpret that slot as a teleport flag on Team 2, including during travel.
    # Shared selection consumes scratch synchronously; persist/capture its result before waits.
    pullAimMode = PullAimMode.GRAPNEL
    selectPullAimTarget()
    eventPlayer.augmentGrapnelTarget = pullAimTarget
    if eventPlayer.augmentGrapnelTarget == null:
        return
    eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + AUGMENT_GRAPNEL_COOLDOWN
    eventPlayer.augmentGrapnelState = [eventPlayer.getHero(), 0]
    # Same white Grapple beam as the sentry turret. Its two endpoints reevaluate
    # body centers, retaining only this augment's player slots across the pull.
    createBeam(getAllPlayers(), Beam.GRAPPLE, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.augmentGrapnelState[1] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
    # Keep world/player collisions and attack inputs intact. Only an active pull
    # updates movement; every exit reaches cleanup, even after releasing the chord.
    # Teams are fixed for the match, so the locked target's team cannot change.
    while (
        isGameplayActive and augmentGrapnelCanMove
        and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0]
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
            # Only zombies take the impact damage, crowd control and blast.
            if eventPlayer.augmentGrapnelTarget.getTeam() == Team.2:
                # The hit handler can reuse tmp2 after the last read of the anchor.
                damageWithEnhancements(AUGMENT_GRAPNEL_DAMAGE, eventPlayer.augmentGrapnelTarget)
                if eventPlayer.augmentGrapnelTarget.isOnGround():
                    eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.STUNNED, AUGMENT_GRAPNEL_GROUND_STUN_DURATION)
                else:
                    eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, AUGMENT_GRAPNEL_AIR_KNOCKDOWN_DURATION)
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.augmentGrapnelTarget.getPosition() + Vector.UP, AUGMENT_IMPACT_SIZE)
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
    grapnelExitUpSpeed = 0
    grapnelCleanup:
    destroyEffect(eventPlayer.augmentGrapnelState[1])
    # Like Dash, subtract all current velocity to reach the desired velocity in one impulse.
    # Preserve movement after a hero swap, native crowd control, or attachment.
    if augmentGrapnelCanMove and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0]:
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
