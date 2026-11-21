#!mainFile "../../main.opy"

# Remove the debug.opy include from main.opy to disable all debug rules.
# main.opy enables playMoreEffects, raising the shared effect/beam/icon limit to 256.

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
    debug(wrestlerPullTarget)
    wait(5)
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


rule "[debug] Resource usage and server load":
    @Condition SERVER_LOAD_UI
    # START GAME and WIN/LOSS CONDITIONS destroy all HUD texts. Recreate this one
    # after either phase changes, allowing their cleanup actions to finish first.
    wait(0.5)
    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and "{0}".format(player) == "snky"), "Texts: {0}/128 | Effects: {1}/256\nServer load: {2}{3}".format(getNumberOfTextIds(), getNumberOfEntityIds(), "{0} | Avg (2s): {1} | Peak (2s): {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), f"\nMap: {__getCurrentMap__()}\nMap grid: {len(mapGridList)}/900"), HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    debugHud = getLastCreatedText()
    # evalOnce captures the phase at HUD creation; the other operands keep updating.
    waitUntil(isPregameSetup != evalOnce(isPregameSetup) or isGameplayActive != evalOnce(isGameplayActive), Math.INFINITY)
    destroyHudText(debugHud)
    loop()


rule "[debug] init":
    @Condition DEBUG_ENABLE_INSPECTOR
    logToInspector(f"Map: {__getCurrentMap__()}")


rule "[debug] Log match completion":
    @Condition DEBUG_ENABLE_INSPECTOR
    @Condition isMatchComplete() == true

    logToInspector("[match] Match completed")


rule "[debug] Log sustained server load":
    @Condition DEBUG_ENABLE_INSPECTOR
    @Condition getAverageServerLoad() >= 255

    logToInspector(f"[server load] Avg (2s) reached 255\nobjective={currentObjectiveType}\nzombies={getNumberOfPlayers(Team.2)}\nqueued={len(botSpawnTimeList)}\neffects={getNumberOfEntityIds()}\ntexts={getNumberOfTextIds()}")
    waitUntil(getAverageServerLoad() < 255, Math.INFINITY)
    logToInspector(f"[server load] Avg (2s) recovered to {getAverageServerLoad()}")


rule "[debug] Log bot AI activity":
    @Condition DEBUG_BOT_AI_LOGS_ACTIVE
    @Condition isGameplayActive == true

    debugBotTargetScans = 0
    debugBotTargetMisses = 0
    debugBotTeleportAttempts = 0
    debugBotTeleportSuccesses = 0
    debugBotTeleportNoTargets = 0
    wait(1, Wait.ABORT_WHEN_FALSE)
    # Sample how many bots are still teleporting with no targets at log time.
    # teleNoTargets above counts search iterations over the whole interval.
    #!define debugBotTeleportNoTargetBots (len(getPlayers(Team.2).filter(lambda zombie: zombie.botIsTeleporting)) if playerTargetList == [] else 0)
    logToInspector(f"[bot AI] zombies={getNumberOfPlayers(Team.2)} avg={getAverageServerLoad()} peak={getPeakServerLoad()} scans={debugBotTargetScans} misses={debugBotTargetMisses} teleSearch={debugBotTeleportAttempts} teleOk={debugBotTeleportSuccesses} teleNoTargets={debugBotTeleportNoTargets} teleNoTargetBots={debugBotTeleportNoTargetBots}")
    loop()
