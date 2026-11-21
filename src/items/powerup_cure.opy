#!mainFile "../../main.opy"


macro useCurePowerUp():
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 1)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
    if eventPlayer.isInfected:
        eventPlayer.isInfected = false
        eventPlayer.infectionLevel = 0
        smallMessage(eventPlayer, "You are cured!")
    else:
        eventPlayer.infectionLevel -= 1.5
        smallMessage(eventPlayer, "Your resistance to infection increased!")
    eventPlayer.startHealingOverTime(eventPlayer, 5, 20)
    playAquaPowerUpSound()
