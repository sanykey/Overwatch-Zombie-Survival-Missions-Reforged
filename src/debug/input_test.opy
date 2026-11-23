#!mainFile "../../main.opy"

#!define DEBUG_BUTTON_INTERVAL 1
#!define DEBUG_BUTTON_PULSE min(0.064, DEBUG_BUTTON_INTERVAL / 4)
#!define DEBUG_BUTTON_HOLD 0.5
#!define DEBUG_BUTTON_PLACEMENT_HOLD (DEBUG_BUTTON_HOLD + 0.064)

# Rows contain the log label, hold duration, double-tap flag and buttons.
# A double-tap row contains one button. Damage, healing and proximity passives
# still rely on the hero, targets and combat events during the test.
macro DEBUG_BUTTON_CASES = [
    # Double Crouch arms Overcharge, grants Engineer armor or triggers Bolt Strike.
    ["Crouch (double tap)", DEBUG_BUTTON_PULSE, true, Button.CROUCH],
    # Double Jump activates Dash or Highrise.
    ["Jump (double tap)", DEBUG_BUTTON_PULSE, true, Button.JUMP],
    # Melee covers Zombie Hybrid, Bulking Season, Wrestler pull, Engineer turret
    # and Charge Battery placement. Keep the button down past the 0.5s windup.
    [f"Melee (hold {DEBUG_BUTTON_PLACEMENT_HOLD}s)", DEBUG_BUTTON_PLACEMENT_HOLD, false, Button.MELEE],
    # Crouch + Interact places Laser Barricade on release or operates Scavenger's backpack.
    [f"Crouch + Interact (hold {DEBUG_BUTTON_PLACEMENT_HOLD}s)", DEBUG_BUTTON_PLACEMENT_HOLD, false, Button.CROUCH, Button.INTERACT],
    # Interact on its own uses a carried power-up when held.
    [f"Interact (hold {DEBUG_BUTTON_HOLD}s)", DEBUG_BUTTON_HOLD, false, Button.INTERACT],
    # Tap Interact to open, pick up, grab or throw.
    ["Interact", DEBUG_BUTTON_PULSE, false, Button.INTERACT],
    # Crouch also exercises Hitchhiker's attach and detach input.
    [f"Crouch (hold {DEBUG_BUTTON_PLACEMENT_HOLD}s)", DEBUG_BUTTON_PLACEMENT_HOLD, false, Button.CROUCH],
    # Crouch + Jump activates Telekinesis push or Grapnel Launcher.
    ["Crouch + Jump", DEBUG_BUTTON_PULSE, false, Button.CROUCH, Button.JUMP],
    # Reload exercises Ammo Pack. The hold also lets Scavenger drop its backpack.
    [f"Reload (hold {DEBUG_BUTTON_HOLD}s)", DEBUG_BUTTON_HOLD, false, Button.RELOAD],
]

globalvar debugButtonStep
globalvar debugButtonTargets
globalvar debugButtonCase


# The loop index is assigned and consumed synchronously on one side of a wait.
#!define debugButtonIndex tmp1
#!define debugButtonLabel debugButtonCase[0]
#!define debugButtonDuration debugButtonCase[1]
#!define debugButtonDoubleTap debugButtonCase[2]
#!define DEBUG_BUTTON_FIRST_INDEX 3

macro logDebugButtonPress(buttonNames):
    logToInspector(f"[debug input] {buttonNames}")


rule "[debug] Cycle non-host ability inputs":
    @Condition DEBUG_INPUT_TEST
    @Condition isGameplayActive == true
    wait(1)

    while isGameplayActive:
        for debugButtonStep in range(len(DEBUG_BUTTON_CASES)):
            if not isGameplayActive:
                return
            debugButtonTargets = getPlayers(Team.1).filter(lambda player: player != hostPlayer and not player.isDummy())
            if debugButtonTargets == []:
                wait(DEBUG_BUTTON_INTERVAL)
                continue

            debugButtonCase = DEBUG_BUTTON_CASES[debugButtonStep]
            for debugButtonIndex in range(DEBUG_BUTTON_FIRST_INDEX, len(debugButtonCase)):
                debugButtonTargets.startForcingButton(debugButtonCase[debugButtonIndex])
            if DEBUG_ENABLE_INSPECTOR:
                logDebugButtonPress(debugButtonLabel)
            wait(debugButtonDuration)
            # Release the exact recipients and buttons from the press, including after a host change.
            for debugButtonIndex in range(DEBUG_BUTTON_FIRST_INDEX, len(debugButtonCase)):
                debugButtonTargets.stopForcingButton(debugButtonCase[debugButtonIndex])

            if debugButtonDoubleTap and isGameplayActive:
                # Release briefly, then tap the same Crouch or Jump button again.
                wait(DEBUG_BUTTON_PULSE)
                if not isGameplayActive:
                    return
                debugButtonTargets = debugButtonTargets.filter(lambda player: player.getTeam() == Team.1 and player != hostPlayer)
                debugButtonTargets.startForcingButton(debugButtonCase[DEBUG_BUTTON_FIRST_INDEX])
                if DEBUG_ENABLE_INSPECTOR and debugButtonTargets != []:
                    logDebugButtonPress(f"{debugButtonLabel}, second tap")
                wait(DEBUG_BUTTON_PULSE)
                debugButtonTargets.stopForcingButton(debugButtonCase[DEBUG_BUTTON_FIRST_INDEX])
                wait(DEBUG_BUTTON_INTERVAL - 3 * DEBUG_BUTTON_PULSE)
            else:
                wait(max(0.016, DEBUG_BUTTON_INTERVAL - debugButtonDuration))
