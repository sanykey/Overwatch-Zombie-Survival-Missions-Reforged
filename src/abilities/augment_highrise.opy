#!mainFile "../../main.opy"

# HIGHRISE flight bonus lifetime and synchronous activation macro. The shared
# double-tap input rule lives in augments.opy; storage contracts remain in
# variables.opy; HUDs stay in their owners.

#!define HIGHRISE_JUMP_IMPULSE 16
#!define HIGHRISE_COOLDOWN 14

macro useHighriseAirActionMacro():
    if getTotalTimeElapsed() >= eventPlayer.augmentMovementReadyAt:
        eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + HIGHRISE_COOLDOWN
        eventPlayer.applyImpulse(Vector.UP, HIGHRISE_JUMP_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        # Arm the airborne damage bonus; the flight rule keeps it active
        # until landing or the flight timeout, then grants the grace period.
        eventPlayer.augmentJumpDamageActive = true


rule "[HIGHRISE] AIRBORNE DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.HIGHRISE
    @Condition eventPlayer.augmentJumpDamageActive == true
    @Condition eventPlayer.isAlive() == true

    # Armed on activation. A grounded activation still lifts off from its own
    # impulse, so hold for that liftoff first. Landing/death or the duration
    # timeout ends the flight window; keep the bonus for the grace period.
    waitUntil(eventPlayer.isOnGround() == false or not eventPlayer.isAlive(), Math.INFINITY)
    applyDamageDealtModifier()
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isAlive(), HIGHRISE_DAMAGE_DURATION)
    wait(HIGHRISE_DAMAGE_GRACE_PERIOD)
    eventPlayer.augmentJumpDamageActive = false
    applyDamageDealtModifier()
