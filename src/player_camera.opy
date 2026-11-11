#!mainFile "../main.opy"

#!define CAMERA_HOTKEY f"[{inputBindingString(Button.RELOAD)}] + [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]"

def applyPlayerCamera():
    @Name "APPLY PLAYER CAMERA"

    if eventPlayer.cameraMode == CameraMode.PRECISE:
        # ZSMM-remixed: preserve both nested wall rays and the fast tracking speed.
        # Expression alias only: position must keep reevaluating, never capture a scratch slot.
        #!define CAMERA_ORIGIN (eventPlayer + Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5))
        eventPlayer.startCamera(raycastHitPosition(CAMERA_ORIGIN, raycastHitPosition(CAMERA_ORIGIN, CAMERA_ORIGIN + eventPlayer.getFacingDirection() * -3, null, eventPlayer, true), null, eventPlayer, true), eventPlayer + eventPlayer.getFacingDirection() * 100, 100)
    else:
        eventPlayer.stopCamera()


# Scoped aiming (Ana, Ashe, Widowmaker, Emre) needs the native zoom camera:
# stop the 3D camera while secondary fire is held, then restore the current mode.
rule "DISABLE PLAYER CAMERA WHILE AIMING":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.cameraMode == CameraMode.PRECISE
    @Condition eventPlayer.getHero() in [Hero.ANA, Hero.ASHE, Hero.WIDOWMAKER, Hero.EMRE]
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.stopCamera()
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, Math.INFINITY)
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
    smallMessage(eventPlayer, f"Camera: {['Normal', 'Precise'][eventPlayer.cameraMode]} | Switch: {CAMERA_HOTKEY}")
