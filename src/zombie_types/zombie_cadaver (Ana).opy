#!mainFile "../../main.opy"

rule "CADAVER (ANA) DETONATION":
    @Event eachPlayer
    @Team 2
    @Hero ana
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false
    #Scaled
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= 2.75 * eventPlayer.sizeScale

    waitUntil(not eventPlayer.isMeleeing(), Math.INFINITY)
    if not ruleCondition:
        return
    #Pre-explosion sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.VIOLET, eventPlayer, 0.5 * eventPlayer.sizeScale)
    applyBriefBurnAndRoot()
    abilityThrowdown()
    wait(0.1)
    kill(eventPlayer)
