#!mainFile "../../main.opy"

rule "BOMBER (JUNKRAT) SELF DESTRUCT":
    @Event eachPlayer
    @Team 2
    @Hero junkrat
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    #Scaled
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= 2.75 * eventPlayer.sizeScale

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.botIsBomberPrimed = true
    explosionWarning()
    if ruleCondition:
        loop()

def explosionWarning():
    @Name "explosionWarning"

    #Pre-explosion sound
    playReignitedWarningPair()
    eventPlayer.explosionScale = eventPlayer.sizeScale
    applyBriefBurnAndRoot()
    wait(0.5)
    eventPlayer.botIsBomberPrimed = false
    if eventPlayer.isDead():
        return
    kill(eventPlayer, eventPlayer)
    explosionSequence()
