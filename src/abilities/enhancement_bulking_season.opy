#!mainFile "../../main.opy"


def applyBulkingSeasonStats():
    @Name "applyBulkingSeasonStats"

    # Additive percentages from the native hero baseline; never compound live max health.
    eventPlayer.setMaxHealth(min(BULKING_SEASON_MAX_HP_MULTIPLIER * 100, 100 + eventPlayer.enhancementBulkStacks * BULKING_SEASON_HP_PER_STACK_PCT))
    eventPlayer.sizeScale = 1 if eventPlayer.enhancementBulkNormalSize else min(BULKING_SEASON_MAX_SIZE_MULTIPLIER, 1 + eventPlayer.enhancementBulkStacks * (BULKING_SEASON_SIZE_PER_STACK_PCT / 100))
    applyCurrentSizeScale()
    # Map capped size 1..2.5 linearly to pitch 1..0.5 (200 stacks).
    # Reuse the current size so native-size mode also restores native pitch.
    eventPlayer.startModifyingVoicelinePitch((4 - eventPlayer.sizeScale) / 3, false)


macro toggleBulkingSeasonSize():
    eventPlayer.enhancementBulkNormalSize = not eventPlayer.enhancementBulkNormalSize
    applyBulkingSeasonStats()


macro initializeBulkingSeasonMacro():
    eventPlayer.enhancementBulkStacks = 0
    eventPlayer.enhancementBulkNormalSize = false


macro creditBulkingSeasonEliminationMacro():
    # One credit for a kill or damage participation; healing/buff assists do not count.
    eventPlayer.enhancementBulkStacks += 1
    applyBulkingSeasonStats()


macro applyBulkingSeasonDeathMacro():
    eventPlayer.enhancementBulkStacks = floor(eventPlayer.enhancementBulkStacks * ((100 - BULKING_SEASON_DEATH_LOSS_PCT) / 100))
    applyBulkingSeasonStats()
