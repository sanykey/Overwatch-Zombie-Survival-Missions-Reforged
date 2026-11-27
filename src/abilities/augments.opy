#!mainFile "../../main.opy"

#!include "augment_telekinesis.opy"
#!include "augment_highrise.opy"
#!include "augment_dash.opy"
#!include "augment_laser_barricade.opy"
#!include "augment_hitchhiker.opy"

macro augmentMovementBlocked = eventPlayer.isAttached or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled


rule "PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    eventPlayer.augmentId = (eventPlayer.augmentId + (Augment.HITCHHIKER if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 1)) % (Augment.HITCHHIKER + 1)


rule "CROUCH + INTERACT (LASER BARRICADE)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementCarryState == WrestlerCarryState.NONE) == true
    @Condition canPlaceLaserBarricade() == true

    placeLaserBarricadeAugmentMacro()


#!include "augment_kevlar.opy"


#!include "augment_grapnel_launcher.opy"


rule "DOUBLE TAP JUMP (DASH / HIGHRISE)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    # Keep the native UI phase/ID workaround after the button check.
    @Condition uiPhaseAndId(eventPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE])

    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), AUGMENT_JUMP_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.JUMP):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), AUGMENT_JUMP_TAP_WINDOW)
    if not ruleCondition:
        return

    if not augmentMovementBlocked:
        if eventPlayer.augmentId == Augment.DASH:
            useDashAirActionMacro()
        else:
            useHighriseAirActionMacro()
    # Consume the second press before accepting a fresh pair.
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)


rule "CROUCH + JUMP (AUGMENTS)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true

    if eventPlayer.augmentId == Augment.TELEKINESIS:
        useTelekinesisPushMacro()
    elif eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER and not augmentMovementBlocked:
        useGrapnelLauncherMacro()
    elif eventPlayer.augmentId == Augment.HITCHHIKER:
        toggleHitchhikerAttachment()


#!include "augment_ammo_pack.opy"
