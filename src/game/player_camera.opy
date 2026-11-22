#!mainFile "../../main.opy"

#!define CAMERA_HOTKEY f"[{inputBindingString(Button.RELOAD)}] + [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]"

def applyPlayerCamera():
    @Name "APPLY PLAYER CAMERA"

    if eventPlayer.cameraMode == CameraMode.PRECISE:
        # ZSMM-remixed: preserve both nested wall rays and the fast tracking speed.
        # Reuse the origin within each live camera reevaluation.
        #!define CAMERA_ORIGIN (eventPlayer + Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5 * eventPlayer.sizeScale))
        eventPlayer.startCamera(
            [CAMERA_ORIGIN].map(lambda origin: raycastHitPosition(
                origin,
                raycastHitPosition(origin, origin + eventPlayer.getFacingDirection() * (-3 * eventPlayer.sizeScale), null, eventPlayer, true),
                null, eventPlayer, true
            ))[0],
            eventPlayer + eventPlayer.getFacingDirection() * 100,
            100
        )
    else:
        eventPlayer.stopCamera()


# Freja's Take Aim needs the secondary-fire input even before she fires a bolt.
macro isAimingWithScope():
    eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) if eventPlayer.getHero() == Hero.FREJA else eventPlayer.isFiringSecondaryFire()


rule "DISABLE PLAYER CAMERA WHILE AIMING":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.cameraMode == CameraMode.PRECISE
    @Condition eventPlayer.getHero() in [Hero.ANA, Hero.ASHE, Hero.WIDOWMAKER, Hero.EMRE, Hero.FREJA]
    @Condition isAimingWithScope() == true

    eventPlayer.stopCamera()
    waitUntil(not isAimingWithScope() or eventPlayer.cameraMode != CameraMode.PRECISE, Math.INFINITY)
    if isGameplayActive:
        applyPlayerCamera()


rule "CYCLE PLAYER CAMERA":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Ongoing rule retriggers only after a condition becomes false and true again.
    eventPlayer.cameraMode = (eventPlayer.cameraMode + 1) % 2
    applyPlayerCamera()
