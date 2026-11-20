#!mainFile "../../main.opy"

# Remove the debug.opy include from main.opy to disable all debug rules.
# main.opy enables playMoreEffects, raising the shared effect/beam/icon limit to 256.

# Diagnostics.
globalvar debugHud # ID of snky's diagnostics HUD, recreated after phase cleanup.

#!define DEBUG_BUTTON_INTERVAL 1
#!define DEBUG_BUTTON_PULSE min(0.064, DEBUG_BUTTON_INTERVAL / 4)
#!define DEBUG_BUTTON_HOLD 0.5
# Mask values in button order:
# 1 Interact, 2 Crouch, 4 Jump, 8 Melee, 16 Primary Fire, 32 Secondary Fire,
# 64 Ability 1, 128 Ability 2, 256 Ultimate, 512 Reload.
#!define DEBUG_BUTTONS [Button.INTERACT, Button.CROUCH, Button.JUMP, Button.MELEE, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.ULTIMATE, Button.RELOAD]
#!define DEBUG_BUTTON_NAMES "Interact,Crouch,Jump,Melee,Primary Fire,Secondary Fire,Ability 1,Ability 2,Ultimate,Reload".split(",")
#!define DEBUG_BUTTON_MASK_COUNT (2 ** len(DEBUG_BUTTONS) - 1)

globalvar debugButtonStep
globalvar debugButtonTargets
globalvar debugButtonChord


rule "[debug] snky buffs":
    @Event eachPlayer
    @Condition DEBUG
    @Condition "{0}".format(eventPlayer) == "snky"
    @Condition eventPlayer.hasSpawned()
    @Condition isGameplayActive

    # Reapply after respawns, hero changes and power-ups that overwrite healing dealt.
    # eventPlayer.setDamageDealt(1000)
    # eventPlayer.setHealingDealt(10000)
    # eventPlayer.setMaxHealth(10000)

    # Refuel during gameplay only: menu HUD cleanup runs before gameplay begins.
    # debug(wrestlerPullTarget)
    wait(3)
    eventPlayer.setKnockbackReceived(0)
    eventPlayer.setUltCharge(100)
    eventPlayer.powerUpJetpackFuel = 100
    eventPlayer.powerUpItemId = PowerUpItem.JETPACK
    # The stack slot belongs to other state when a different enhancement is selected.
    if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        eventPlayer.enhancementBulkStacks = 300
        applyBulkingSeasonStats()
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        eventPlayer.enhancementCapacitorEnergy = 1000

    # wait(0.5, Wait.ABORT_WHEN_FALSE)
    # if ruleCondition:
    #     loop()


rule "[debug] Team 1 unkillable during gameplay":
    @Event eachPlayer
    @Team 1
    @Condition DEBUG
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true

    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)
    waitUntil(isGameplayActive == false or eventPlayer.isDead() or eventPlayer.getTeam() != Team.1, Math.INFINITY)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


rule "[debug] Heal and cure Team 1":
    @Condition DEBUG
    @Condition isGameplayActive == true

    # These scratch values are assigned and consumed after the wait.
    #!define debugInfectedPlayers tmp0
    #!define debugInfectedIndex tmp1
    #!define debugInfectionDot tmp2

    wait(20, Wait.ABORT_WHEN_FALSE)
    debugInfectedPlayers = getPlayers(Team.1).filter(lambda player: player.isInfected or player.infectionLevel > 0)
    for debugInfectedIndex in range(len(debugInfectedPlayers)):
        debugInfectionDot = debugInfectedPlayers[debugInfectedIndex].infectionDamageOverTimeId
        if debugInfectionDot != null:
            stopDamageOverTime(debugInfectionDot)
    debugInfectedPlayers.infectionDamageOverTimeId = null
    debugInfectedPlayers.isInfected = false
    # Leave negative infection levels that represent vaccination in place.
    debugInfectedPlayers.filter(lambda player: player.infectionLevel > 0).infectionLevel = 0
    heal(getPlayers(Team.1), null, 700)
    loop()


rule "[debug] Resource usage and server load":
    @Condition DEBUG_SERVER_LOAD_UI
    # START GAME and WIN/LOSS CONDITIONS destroy all HUD texts. Recreate this one
    # after either phase changes, allowing their cleanup actions to finish first.
    wait(0.5)
    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and "{0}".format(player) == "snky"), "Texts: {0}/128 | Effects: {1}/256\nServer load: {2}{3}".format(getNumberOfTextIds(), getNumberOfEntityIds(), "{0} | Avg (2s): {1} | Peak (2s): {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), f"\nMap: {__getCurrentMap__()}\nMap grid: {len(mapGridList)}/900"), HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    debugHud = getLastCreatedText()
    # evalOnce captures the phase at HUD creation; the other operands keep updating.
    waitUntil(isPregameSetup != evalOnce(isPregameSetup) or isGameplayActive != evalOnce(isGameplayActive), Math.INFINITY)
    destroyHudText(debugHud)
    loop()


# Scratch values are assigned and consumed synchronously on one side of a wait.
#!define debugButtonMask tmp0
#!define debugButtonIndex tmp1
#!define debugButtonLogChord tmp2

macro debugButtonName(button):
    DEBUG_BUTTON_NAMES[DEBUG_BUTTONS.index(button)]

macro logDebugButtonPress(buttonNames):
    logToInspector(f"[debug input] {buttonNames}")


rule "[debug] Cycle non-host ability inputs":
    @Condition DEBUG
    @Condition isGameplayActive
    wait(1)

    while true:
        # Reserve every 16th step for standalone Interact between consecutive masks.
        for debugButtonStep in range(-5, DEBUG_BUTTON_MASK_COUNT + ceil(DEBUG_BUTTON_MASK_COUNT / 15)):
            debugButtonTargets = getPlayers(Team.1).filter(lambda player: player != hostPlayer and not player.isDummy())
            if debugButtonTargets == []:
                wait(DEBUG_BUTTON_INTERVAL)
                continue

            if debugButtonStep < -3:
                # Step -5 taps Crouch twice. Step -4 taps Jump twice.
                debugButtonChord = [Button.CROUCH if debugButtonStep == -5 else Button.JUMP]
            elif debugButtonStep == -1:
                # Hold Interact on its own past the power-up's 0.25-second threshold.
                debugButtonChord = [Button.INTERACT]
            elif debugButtonStep < 0:
                # Step -3 holds Melee. Step -2 holds Crouch and Interact together.
                debugButtonChord = [Button.MELEE] if debugButtonStep == -3 else [Button.CROUCH, Button.INTERACT]
            elif debugButtonStep % 16 == 0:
                # Tap Interact on its own.
                debugButtonChord = [Button.INTERACT]
            else:
                # Press the buttons whose values add up to the mask.
                # Mask 6 presses Crouch + Jump. Mask 129 presses Interact + Ability 2.
                debugButtonMask = debugButtonStep - floor(debugButtonStep / 16)
                debugButtonChord = DEBUG_BUTTONS.filter(lambda _, index: floor(debugButtonMask / 2 ** index) % 2 == 1)

            for debugButtonIndex in range(len(debugButtonChord)):
                debugButtonTargets.startForcingButton(debugButtonChord[debugButtonIndex])
            if DEBUG_ENABLE_INSPECTOR:
                debugButtonLogChord = debugButtonName(debugButtonChord[0])
                for debugButtonIndex in range(1, len(debugButtonChord)):
                    debugButtonLogChord = f"{debugButtonLogChord} + {debugButtonName(debugButtonChord[debugButtonIndex])}"
                if debugButtonStep >= -3 and debugButtonStep < 0:
                    debugButtonLogChord = f"{debugButtonLogChord} (hold {DEBUG_BUTTON_HOLD}s)"
                logDebugButtonPress(debugButtonLogChord)
            wait(DEBUG_BUTTON_HOLD if debugButtonStep >= -3 and debugButtonStep < 0 else DEBUG_BUTTON_PULSE)
            # Release the exact recipients and buttons from the press, including after a host change.
            for debugButtonIndex in range(len(debugButtonChord)):
                debugButtonTargets.stopForcingButton(debugButtonChord[debugButtonIndex])

            if debugButtonStep < -3:
                # Release briefly, then tap the same Crouch or Jump button again.
                wait(DEBUG_BUTTON_PULSE)
                debugButtonTargets = debugButtonTargets.filter(lambda player: player.getTeam() == Team.1 and player != hostPlayer)
                debugButtonTargets.startForcingButton(debugButtonChord[0])
                if DEBUG_ENABLE_INSPECTOR and debugButtonTargets != []:
                    logDebugButtonPress("Crouch (second tap)" if debugButtonStep == -5 else "Jump (second tap)")
                wait(DEBUG_BUTTON_PULSE)
                debugButtonTargets.stopForcingButton(debugButtonChord[0])
                wait(DEBUG_BUTTON_INTERVAL - 3 * DEBUG_BUTTON_PULSE)
            elif debugButtonStep < 0:
                wait(max(0.016, DEBUG_BUTTON_INTERVAL - DEBUG_BUTTON_HOLD))
            else:
                wait(DEBUG_BUTTON_INTERVAL - DEBUG_BUTTON_PULSE)
