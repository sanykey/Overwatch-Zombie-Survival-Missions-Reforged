#!mainFile "../../main.opy"


macro useUltimateChargerPowerUp():
    eventPlayer.powerUpUltimateEndsAt = getTotalTimeElapsed() + 20
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.RED, eventPlayer.getPosition(), 50)
    startRule(ultimateCharger, StartRuleBehavior.NOOP)


def ultimateCharger():
    @Name "ultimateCharger (90-99)"

    hudHeader(eventPlayer, "Ultimate Charger: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpUltimateEndsAt)), HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.powerUpUltimateChargerHudId = getLastCreatedText()
    while true:
        while getTotalTimeElapsed() < eventPlayer.powerUpUltimateEndsAt:
            eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 2)
            wait(0.125)
        wait(0.25)
        if getTotalTimeElapsed() >= eventPlayer.powerUpUltimateEndsAt:
            break
    destroyHudText(eventPlayer.powerUpUltimateChargerHudId)
