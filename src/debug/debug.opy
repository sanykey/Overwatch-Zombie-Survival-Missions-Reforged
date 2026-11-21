#!mainFile "../../main.opy"

# Remove the debug.opy include from main.opy to disable all debug rules.
# main.opy enables playMoreEffects, raising the shared effect/beam/icon limit to 256.

# Diagnostics.
globalvar debugHud # ID of snky's diagnostics HUD, recreated after phase cleanup.

#!define DEBUG_BUTTON_INTERVAL 1
#!define DEBUG_BUTTON_PULSE min(0.064, DEBUG_BUTTON_INTERVAL / 4)
#!define DEBUG_BUTTON_HOLD 0.5
#!define DEBUG_BUTTON_PLACEMENT_HOLD (DEBUG_BUTTON_HOLD + 0.064)

# Rows contain the log label, hold duration, double-tap flag and buttons.
# A double-tap row contains one button. Damage, healing and proximity passives
# still rely on the hero, targets and combat events during the test.
macro DEBUG_BUTTON_CASES = [
    # Double Crouch arms Auspex Scan, Bolt Strike, Engineer armor and Overcharge.
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
    # Crouch + Jump activates Telekinesis push or Grapnel Launcher.
    ["Crouch + Jump", DEBUG_BUTTON_PULSE, false, Button.CROUCH, Button.JUMP],
    # Hold Jump to activate a fueled Jetpack while airborne.
    [f"Jump (hold {DEBUG_BUTTON_HOLD}s)", DEBUG_BUTTON_HOLD, false, Button.JUMP],
    # Reload exercises Ammo Pack. The hold also lets Scavenger drop its backpack.
    [f"Reload (hold {DEBUG_BUTTON_HOLD}s)", DEBUG_BUTTON_HOLD, false, Button.RELOAD],
]

globalvar debugButtonStep
globalvar debugButtonTargets
globalvar debugButtonCase

rule "[debug] init":
    @Condition DEBUG_ENABLE_INSPECTOR
    logToInspector(f"Map: {__getCurrentMap__()}")

rule "[debug] snky buffs":
    @Event eachPlayer
    @Condition DEBUG
    @Condition "{0}".format(eventPlayer) == "snky"
    @Condition eventPlayer.hasSpawned()
    @Condition isGameplayActive

    # Reapply after respawns, hero changes and power-ups that overwrite healing dealt.
    eventPlayer.setDamageDealt(1000)
    eventPlayer.setHealingDealt(10000)
    eventPlayer.setMaxHealth(10000)
    eventPlayer.invisibilityCount++

    # Refuel during gameplay only: menu HUD cleanup runs before gameplay begins.
    # debug(wrestlerPullTarget)
    wait(3)
    eventPlayer.setKnockbackReceived(0)
    eventPlayer.setUltCharge(100)
    # eventPlayer.powerUpJetpackFuel = 100
    # eventPlayer.powerUpItemId = PowerUpItem.JETPACK
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


rule "[debug] Automatically revive downed Team 1 players":
    @Event playerDied
    @Team 1
    @Condition DEBUG
    @Condition isGameplayActive == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer.isHeroSwitchRespawn == false
    @Condition eventPlayer.rescueTimeRemaining > 0

    # Let PLAYER GETS DOWNED reset the timer and recover the body first.
    # REVIVE PLAYER OR ADVANCE DEATH TIMER handles the resurrection and cleanup.
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.reviveTimeRemaining = 0


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

    if DEBUG_ENABLE_INSPECTOR:
        logToInspector(f"server load hud init (isPregameSetup: {isPregameSetup}, isGameplayActive: {isGameplayActive})")

    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and "{0}".format(player) == "snky"), "Texts: {0}/128 | Effects: {1}/256\nServer load: {2}{3}".format(getNumberOfTextIds(), getNumberOfEntityIds(), "{0} | Avg (2s): {1} | Peak (2s): {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), f"\nMap: {__getCurrentMap__()} | grid: {len(mapGridList)}/900"), HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    debugHud = getLastCreatedText()
    # evalOnce captures the phase at HUD creation; the other operands keep updating.
    waitUntil(isPregameSetup != evalOnce(isPregameSetup) or isGameplayActive != evalOnce(isGameplayActive), Math.INFINITY)
    destroyHudText(debugHud)
    loop()


rule "[debug] Log sustained server load":
    @Condition DEBUG_ENABLE_INSPECTOR
    @Condition getAverageServerLoad() >= 255

    logToInspector(f"[server load] Avg (2s) reached 255\nobjective={currentObjectiveType}\nzombies={getNumberOfPlayers(Team.2)}\nqueued={len(botSpawnTimeList)}\neffects={getNumberOfEntityIds()}\ntexts={getNumberOfTextIds()}")
    waitUntil(getAverageServerLoad() < 255, Math.INFINITY)
    logToInspector(f"[server load] Avg (2s) recovered to {getAverageServerLoad()}")


# The loop index is assigned and consumed synchronously on one side of a wait.
#!define debugButtonIndex tmp1
#!define debugButtonLabel debugButtonCase[0]
#!define debugButtonDuration debugButtonCase[1]
#!define debugButtonDoubleTap debugButtonCase[2]
#!define DEBUG_BUTTON_FIRST_INDEX 3

macro logDebugButtonPress(buttonNames):
    logToInspector(f"[debug input] {buttonNames}")


rule "[debug] Cycle non-host ability inputs":
    @Condition DEBUG
    @Condition isGameplayActive
    wait(1)

    while true:
        for debugButtonStep in range(len(DEBUG_BUTTON_CASES)):
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

            if debugButtonDoubleTap:
                # Release briefly, then tap the same Crouch or Jump button again.
                wait(DEBUG_BUTTON_PULSE)
                debugButtonTargets = debugButtonTargets.filter(lambda player: player.getTeam() == Team.1 and player != hostPlayer)
                debugButtonTargets.startForcingButton(debugButtonCase[DEBUG_BUTTON_FIRST_INDEX])
                if DEBUG_ENABLE_INSPECTOR and debugButtonTargets != []:
                    logDebugButtonPress(f"{debugButtonLabel}, second tap")
                wait(DEBUG_BUTTON_PULSE)
                debugButtonTargets.stopForcingButton(debugButtonCase[DEBUG_BUTTON_FIRST_INDEX])
                wait(DEBUG_BUTTON_INTERVAL - 3 * DEBUG_BUTTON_PULSE)
            else:
                wait(max(0.016, DEBUG_BUTTON_INTERVAL - debugButtonDuration))
