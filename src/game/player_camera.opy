#!mainFile "../../main.opy"

macro cameraHotkeyText():
    f"[{inputBindingString(Button.RELOAD)}] + [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]"

# Freja's Take Aim needs the secondary-fire input even before she fires a bolt.
macro isAimingWithScope():
    eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) if eventPlayer.getHero() == Hero.FREJA else eventPlayer.isFiringSecondaryFire()


# String conversion preserves the Workshop distinction between idle 0 and an active emote.
macro shouldPausePlayerCamera():
    f"{eventPlayer.isCommunicatingEmote()}" != "0" or (
        eventPlayer.isUsingUltimate() and eventPlayer.getHero() in [Hero.BASTION, Hero.JUNKRAT, Hero.DOOMFIST]
    ) or (
        eventPlayer.getHero() in [Hero.ANA, Hero.ASHE, Hero.WIDOWMAKER, Hero.EMRE, Hero.FREJA] and isAimingWithScope()
    )


rule "UPDATE THIRD-PERSON CAMERA":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.cameraMode != CameraMode.NORMAL
    @Condition (eventPlayer.cameraMode == CameraMode.THIRD_PERSON) == shouldPausePlayerCamera()

    # Among enabled modes, only act when the current view disagrees with the pause condition.
    if eventPlayer.cameraMode == CameraMode.THIRD_PERSON:
        eventPlayer.cameraMode = CameraMode.THIRD_PERSON_PAUSED
        eventPlayer.stopCamera()
    else:
        eventPlayer.cameraMode = CameraMode.THIRD_PERSON
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

    # Recheck after the next tick in case inputs change before the condition ever reads false.
    wait()
    if ruleCondition:
        loop()


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
    if eventPlayer.cameraMode == CameraMode.NORMAL:
        eventPlayer.cameraMode = CameraMode.THIRD_PERSON_PAUSED
    else:
        eventPlayer.cameraMode = CameraMode.NORMAL
        eventPlayer.stopCamera()
