#!mainFile "../main.opy"

# Remove the debug.opy include from main.opy to disable all debug rules.
# main.opy enables playMoreEffects, raising the shared effect/beam/icon limit to 256.

# Diagnostics.
globalvar debugHud # ID of snky's diagnostics HUD, recreated after phase cleanup.


# rule "[debug] snky buffs":
#     @Event eachPlayer
#     @Condition "{0}".format(eventPlayer) == "snky"
#     @Condition eventPlayer.hasSpawned()
#     @Condition isGameplayActive

#     # Reapply after respawns, hero changes and power-ups that overwrite healing dealt.
#     # eventPlayer.setDamageDealt(1000)
#     # eventPlayer.setHealingDealt(10000)
#     # eventPlayer.setMaxHealth(10000)
#     # Refuel during gameplay only: menu HUD cleanup runs before gameplay begins.
#     wait(5)
#     eventPlayer.powerUpJetpackFuel = 100
#     eventPlayer.powerUpItemId = PowerUpItem.JETPACK
#     # The stack slot belongs to other state when a different enhancement is selected.
#     if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
#         eventPlayer.enhancementBulkStacks = 300
#         applyBulkingSeasonStats()
#     elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
#         eventPlayer.enhancementCapacitorEnergy = 1000
#     elif eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
#         eventPlayer.enhancementBoltReadyAt = 0

#     # wait(0.5, Wait.ABORT_WHEN_FALSE)
#     # if ruleCondition:
#     #     loop()


rule "[debug] Resource usage and server load":
    # START GAME and WIN/LOSS CONDITIONS destroy all HUD texts. Recreate this one
    # after either phase changes, allowing their cleanup actions to finish first.
    wait(0.5)
    hudSubheader(getAllPlayers().filter(lambda player: not player.isDummy() and "{0}".format(player) == "snky"), "Texts: {0}/128 | Effects: {1}/256\nServer load: {2}{3}".format(getNumberOfTextIds(), getNumberOfEntityIds(), "{0} | Avg (2s): {1} | Peak (2s): {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), f"\nMap grid: {len(mapGridList)}/900"), HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    debugHud = getLastCreatedText()
    # evalOnce captures the phase at HUD creation; the other operands keep updating.
    waitUntil(isPregameSetup != evalOnce(isPregameSetup) or isGameplayActive != evalOnce(isGameplayActive), Math.INFINITY)
    destroyHudText(debugHud)
    loop()
