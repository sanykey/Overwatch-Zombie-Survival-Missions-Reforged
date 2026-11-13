#!mainFile "../main.opy"

# DASH input, charge recharge, smoke cleanup, and synchronous activation macro.
# Shared storage contracts remain in variables.opy; HUDs stay in their owners.
# Include after highrise.opy, which declares the shared useAugmentAirAction.

#!define DASH_COOLDOWN 14
#!define DASH_MAX_CHARGES 2
#!define DASH_PHASE_DURATION 1.7
#!define DASH_TAP_WINDOW 0.3
#!define DASH_IMPULSE 22
#21.25

# Dash samples movement on the second Jump press. This scratch vector is
# consumed by the impulse immediately; it has no waits or live captures.
#!define augmentDashDirection tmp0

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
        # cancel in Workshop's movement vector; zero input grants protection only.
        augmentDashDirection = vect(1 if augmentDashDirection.x > 0 else -1 if augmentDashDirection.x < 0 else 0, 0, 1 if augmentDashDirection.z > 0 else -1 if augmentDashDirection.z < 0 else 0)
        # Every successful dash immediately starts a fresh resist window,
        # including while already protected. Do not defer renewal to expiry.
        # 100% damage resist instead of the INVINCIBLE status: that status keys
        # the DoT-clearing rule, which must not purge infection DoT/burning.
        # The smoke entity gates the resist, so open the window first and let
        # the recompute pick the strongest active protection (0 beats the
        # Super Nano / ultimate 50; it still clears together with the aura).
        # Keep one aura for overlapping dashes; only its deadline changes.
        # augmentIsAirActionReady shares this entity slot: only HIGHRISE
        # may write that alias, including on failed/cooldown activations.
        if eventPlayer.augmentDashSmokeEntity == null:
            createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.augmentDashSmokeEntity = getLastCreatedEntity()
        eventPlayer.augmentDashSmokeDeadline = getTotalTimeElapsed() + DASH_PHASE_DURATION
        applyDamageReceivedModifier()
        # The window also nulls knockback received. Set Knockback Received
        # ignores scripted Apply Impulse pushes, which keep their own scaling.
        eventPlayer.setKnockbackReceived(0)
        # Zero movement input grants only the invulnerability: no impulse.
        # Otherwise a flat horizontal push: a downward pitch would fight the
        # floor when grounded and cancel the rising jump's momentum
        # (CANCEL_CONTRARY_MOTION), leaving an in-place dash without push.
        if augmentDashDirection != vect(0, 0, 0):
            eventPlayer.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle() + horizontalAngleOfDirection(augmentDashDirection), 0), DASH_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "[DASH] CHARGE RECHARGE":
    @Event eachPlayer
    @Team 1
    # Menu selection passes through Dash; never seed another augment's shared cooldown.
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.augmentDashCharges < DASH_MAX_CHARGES
    @Condition getTotalTimeElapsed() >= eventPlayer.augmentDashReadyAt

    # The timer runs from the first spend below full (2 -> 1); spending the last
    # charge keeps it, so a fully spent meter resumes without a new dash.
    eventPlayer.augmentDashCharges += 1
    if eventPlayer.augmentDashCharges < DASH_MAX_CHARGES:
        eventPlayer.augmentDashReadyAt = getTotalTimeElapsed() + DASH_COOLDOWN


rule "[DASH] DOUBLE TAP":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.isAlive() == true

    # Uniform press-release-press trigger on the ground and airborne: both gaps
    # use the Dash tap window. Holding past a timeout restarts the sequence, so
    # a held button cannot re-fire; the charges gate lives in the dash action.
    # After a dash, the triggering press is fully consumed: the sequence waits for
    # its release and restarts from scratch, so a third quick press is only the
    # FIRST press of the next pair and cannot spend a second charge by itself.
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), DASH_TAP_WINDOW)
    if not eventPlayer.isHoldingButton(Button.JUMP):
        waitUntil(eventPlayer.isHoldingButton(Button.JUMP), DASH_TAP_WINDOW)
        if eventPlayer.isHoldingButton(Button.JUMP):
            useAugmentAirAction()
            waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    # Selection can change while a press/release wait is pending.
    if ruleCondition:
        loop()


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
