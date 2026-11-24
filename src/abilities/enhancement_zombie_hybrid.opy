#!mainFile "../../main.opy"


macro useZombieHybridExplosion():
    if eventPlayer.enhancementHybridCooldown > 0 or eventPlayer.infectionLevel < 1:
        return
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamageOverTimeId)
    eventPlayer.infectionLevel = 0
    eventPlayer.enhancementHybridCooldown = ZOMBIE_HYBRID_EXPLOSION_COOLDOWN
    while eventPlayer.enhancementHybridCooldown > 0:
        wait(1)
        eventPlayer.enhancementHybridCooldown += -1


macro initializeZombieHybridMacro():
    # enhancementHybridCooldown: remaining explosion cooldown in seconds (20 on use), for activation checks and HUD.
    startDamageModification(eventPlayer, getPlayers(Team.2), 90)
    eventPlayer.explosionScale = 1.25
    eventPlayer.explosionInnerColor = Color.GRAY
    eventPlayer.explosionOuterColor = Color.LIME_GREEN
