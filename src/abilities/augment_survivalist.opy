#!mainFile "../../main.opy"

macro initializeSurvivalistAugment():
    eventPlayer.addHealthPool(Health.NORMAL, SURVIVALIST_BONUS_HP, true, false)


macro applySurvivalistLifesteal(player, damageAmount):
    if player.augmentId == Augment.SURVIVALIST:
        heal(player, player, damageAmount * (SURVIVALIST_LIFESTEAL_PCT / 100))
