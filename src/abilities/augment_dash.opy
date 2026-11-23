#!mainFile "../../main.opy"

# Dash charge recharge, smoke cleanup, and synchronous activation. Jump input lives in augments.opy.

#21.25

# Dash samples movement on the second Jump press. Reuse the same scratch for
# the velocity correction. Both values are consumed before any wait.
#!define augmentDashDirection tmp0
#!define augmentDashVelocityDelta tmp0

macro useDashAirActionMacro():
    if eventPlayer.augmentDashCharges > 0:
        # The recharge timer starts when the meter first drops below full;
        # spending the last charge leaves the pending timer untouched.
        if eventPlayer.augmentDashCharges == DASH_MAX_CHARGES:
            eventPlayer.augmentDashReadyAt = getTotalTimeElapsed() + DASH_COOLDOWN
        eventPlayer.augmentDashCharges += -1
        augmentDashDirection = eventPlayer.getThrottle()
        # Reduce each axis to -1/0/1: adjacent inputs always make a 45-degree
        # diagonal, independent of their relative strength. Opposite inputs
        # cancel in Workshop's movement vector.
        augmentDashDirection = vect(
            (augmentDashDirection.x > 0) - (augmentDashDirection.x < 0),
            0,
            (augmentDashDirection.z > 0) - (augmentDashDirection.z < 0)
        )
        # Every successful dash immediately starts a fresh resist window,
        # including while already protected. Do not defer renewal to expiry.
        # 100% damage resist instead of the INVINCIBLE status: that status keys
        # the DoT-clearing rule, which must not purge infection DoT/burning.
        # The smoke entity gates the resist, so open the window first and let
        # the recompute pick the strongest active protection. Dash takes
        # priority over Super Nano and the ultimate until the aura clears.
        # Keep one aura for overlapping dashes; only its deadline changes.
        if eventPlayer.augmentDashSmokeEntity == null:
            createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.augmentDashSmokeEntity = getLastCreatedEntity()
        eventPlayer.augmentDashSmokeDeadline = getTotalTimeElapsed() + DASH_PHASE_DURATION
        applyDamageReceivedModifier()
        # The window also nulls knockback received. Set Knockback Received
        # ignores scripted Apply Impulse pushes, which keep their own scaling.
        eventPlayer.setKnockbackReceived(0)
        # A zero throttle vector compares equal to False and opens only the
        # protection window. Otherwise subtract current velocity to cancel
        # falling and prevent repeated dashes from stacking speed.
        if augmentDashDirection != false:
            augmentDashVelocityDelta = directionFromAngles(eventPlayer.getHorizontalFacingAngle() + horizontalAngleOfDirection(augmentDashDirection), DASH_LAUNCH_PITCH) * DASH_LAUNCH_SPEED - eventPlayer.getVelocity()
            eventPlayer.applyImpulse(augmentDashVelocityDelta, magnitude(augmentDashVelocityDelta), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "[DASH] CHARGE RECHARGE":
    @Event eachPlayer
    @Team 1
    # Menu selection passes through Dash; never seed another augment's shared cooldown.
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId == Augment.DASH)
    @Condition eventPlayer.augmentDashCharges < DASH_MAX_CHARGES
    @Condition getTotalTimeElapsed() >= eventPlayer.augmentDashReadyAt

    # The timer runs from the first spend below full (2 -> 1); spending the last
    # charge keeps it, so a fully spent meter resumes without a new dash.
    eventPlayer.augmentDashCharges += 1
    if eventPlayer.augmentDashCharges < DASH_MAX_CHARGES:
        eventPlayer.augmentDashReadyAt = getTotalTimeElapsed() + DASH_COOLDOWN


rule "[DASH] SMOKE FADE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.augmentDashSmokeEntity != null
    @Condition getTotalTimeElapsed() >= eventPlayer.augmentDashSmokeDeadline

    # No waits: cleanup and activation cannot retain a stale entity/deadline.
    # Clearing the handle also rearms this rule for the next window.
    destroyEffect(eventPlayer.augmentDashSmokeEntity)
    eventPlayer.augmentDashSmokeEntity = null
    # Recompute intake exactly with the aura's removal: a Super Nano or
    # ultimate resist active underneath must survive the dash window.
    applyDamageReceivedModifier()
    # Dash and Kevlar are mutually exclusive; Dash restores normal knockback.
    eventPlayer.setKnockbackReceived(100)
