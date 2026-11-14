#!mainFile "../main.opy"

# HIGHRISE input, flight bonus lifetime, and synchronous activation macro.
# Shared storage contracts remain in variables.opy; HUDs stay in their owners.

# Shared with Dash; declared here before the HIGHRISE input rules.
subroutine useAugmentAirAction

#!define HIGHRISE_JUMP_IMPULSE 16
#!define HIGHRISE_TAP_WINDOW 0.3
#!define HIGHRISE_COOLDOWN 14

macro useHighriseAirActionMacro():
    eventPlayer.augmentIsAirActionReady = false
    if getTotalTimeElapsed() >= eventPlayer.augmentMovementReadyAt:
        eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + HIGHRISE_COOLDOWN
        eventPlayer.applyImpulse(Vector.UP, HIGHRISE_JUMP_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        # Arm the airborne damage bonus; the flight rule keeps it active
        # until this impulse's liftoff ends in a landing.
        eventPlayer.augmentJumpDamageActive = true


rule "[HIGHRISE] RECHARGE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.HIGHRISE
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == false

    # Arm once per airborne interval, only after the takeoff button is released.
    # This avoids spending the extra jump on the game's first airborne input tick.
    eventPlayer.augmentIsAirActionReady = false
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    if eventPlayer.isAlive() and not eventPlayer.isOnGround():
        eventPlayer.augmentIsAirActionReady = true
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.augmentIsAirActionReady = false
    if ruleCondition:
        loop()


rule "[HIGHRISE] AIR ACTION INPUT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.HIGHRISE
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.augmentIsAirActionReady == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    useAugmentAirAction()


rule "[HIGHRISE] DOUBLE TAP":
    @Event eachPlayer
    @Team 1
    # The menu's Jump confirmation must not leave a timestamp in another augment's cooldown.
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.HIGHRISE
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Only press edges update the timestamp. A blocked native jump can leave the
    # player grounded; its second press still launches without cancelling abilities.
    if eventPlayer.augmentJumpLastPressedAt > 0 and getTotalTimeElapsed() - eventPlayer.augmentJumpLastPressedAt <= HIGHRISE_TAP_WINDOW:
        eventPlayer.augmentJumpLastPressedAt = 0
        if eventPlayer.isOnGround() or eventPlayer.augmentIsAirActionReady:
            useAugmentAirAction()
    else:
        eventPlayer.augmentJumpLastPressedAt = getTotalTimeElapsed()


rule "[HIGHRISE] AIRBORNE DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.HIGHRISE
    @Condition eventPlayer.augmentJumpDamageActive == true
    @Condition eventPlayer.isAlive() == true

    # Armed on activation. A grounded activation still lifts off from its own
    # impulse, so hold for that liftoff first; the bonus then lasts to landing.
    # Death breaks out of both waits and clears it.
    waitUntil(eventPlayer.isOnGround() == false or not eventPlayer.isAlive(), Math.INFINITY)
    applyDamageDealtModifier()
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.augmentJumpDamageActive = false
    applyDamageDealtModifier()
