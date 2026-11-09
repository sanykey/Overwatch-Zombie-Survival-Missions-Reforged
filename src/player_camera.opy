#!mainFile "../main.opy"

#!define CAMERA_HOTKEY f"[{inputBindingString(Button.RELOAD)}] + [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]"

def applyPlayerCamera():
    @Name "APPLY PLAYER CAMERA"

    if eventPlayer.cameraMode == CameraMode.PRECISE:
        # ZSMM-remixed: preserve both nested wall rays and the fast tracking speed.
        # Expression alias only: position must keep reevaluating, never capture a scratch slot.
        #!define CAMERA_ORIGIN (eventPlayer + Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5))
        eventPlayer.startCamera(raycastHitPosition(CAMERA_ORIGIN, raycastHitPosition(CAMERA_ORIGIN, CAMERA_ORIGIN + eventPlayer.getFacingDirection() * -3, null, eventPlayer, true), null, eventPlayer, true), eventPlayer + eventPlayer.getFacingDirection() * 100, 100)
    elif eventPlayer.cameraMode == CameraMode.SMOOTH:
        # OW2ZombieAndAbilities FAR: inline VL_CAMERA_FAR instead of importing its vector table.
        # Omitted blend speed intentionally uses the donor's Start Camera default.
        eventPlayer.startCamera(eventPlayer + worldVector(vect(-0.3, 1, -0.5), eventPlayer, Transform.ROTATION) + Vector.UP * 1.45 + eventPlayer.getFacingDirection() * -1.9, eventPlayer + eventPlayer.getFacingDirection() * 60)
    else:
        eventPlayer.stopCamera()


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
    eventPlayer.cameraMode = (eventPlayer.cameraMode + 1) % 3
    applyPlayerCamera()
    smallMessage(eventPlayer, f"Camera: {['Normal', 'Precise', 'Smooth'][eventPlayer.cameraMode]} | Switch: {CAMERA_HOTKEY}")
