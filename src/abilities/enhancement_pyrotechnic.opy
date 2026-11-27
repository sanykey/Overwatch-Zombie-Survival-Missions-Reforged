#!mainFile "../../main.opy"


macro initializePyrotechnicMacro():
    eventPlayer.enhancementPyroHitList = []


macro applyPyrotechnicHitMacro(hitTarget):
    if distance(eventPlayer, hitTarget) < PYROTECHNIC_IGNITE_RANGE:
        hitTarget.setStatusEffect(eventPlayer, Status.BURNING, PYROTECHNIC_BURN_DURATION)
        # Count repeated hits in the damage rule to keep this event path cheap.
        eventPlayer.enhancementPyroHitList.append(hitTarget)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    # Keep the phase and enhancement ID in one Workshop Condition.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.PYROTECHNIC)
    # The slot can still be unset before the player's enhancement initializes.
    @Condition eventPlayer.enhancementPyroHitList != false

    #!define pyroBurnTarget tmp0
    #!define pyroBurnDamagePerSecond tmp1
    while eventPlayer.enhancementPyroHitList != []:
        pyroBurnTarget = eventPlayer.enhancementPyroHitList[0]
        if pyroBurnTarget.isAlive():
            pyroBurnDamagePerSecond = min(4 * len(eventPlayer.enhancementPyroHitList.filter(lambda x: x == pyroBurnTarget)), 30)
            if pyroBurnTarget in bossStateList:
                pyroBurnDamagePerSecond /= 2
            pyroBurnTarget.startDamageOverTime(eventPlayer, PYROTECHNIC_BURN_DURATION, pyroBurnDamagePerSecond)
        eventPlayer.enhancementPyroHitList.remove(pyroBurnTarget)
    wait(0.5)
    if ruleCondition:
        loop()
