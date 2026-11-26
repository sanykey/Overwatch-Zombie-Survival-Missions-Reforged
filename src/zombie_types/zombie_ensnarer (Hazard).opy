#!mainFile "../../main.opy"

rule "ENSNARER (HAZARD) BLOCKS PLAYERS":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition (eventPlayer in bossStateList or not eventPlayer.botAbilityCooldown) == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20
    @Condition eventPlayer.botIsEnsnarerMeleeActive != true

    if eventPlayer in bossStateList:
        eventPlayer.disallowButton(Button.MELEE)
        eventPlayer.botIsFacingOverridden = true
        eventPlayer.botIsEnsnarerBlocking = true
        entityFloat()
        for eventPlayer.botEnsnarerTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
            eventPlayer.startFacing(directionTowards(eventPlayer, eventPlayer.botSpecialTargetList[eventPlayer.botEnsnarerTargetIndex]) + -0.3 * Vector.UP, 10000)
            eventPlayer.cancelPrimaryAction()
            wait(0.1)
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            wait(0.5)
            if eventPlayer.botIsCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
                break
        eventPlayer.botIsFacingOverridden = false
        restoreDefaultFacingMovement()
        eventPlayer.botIsEnsnarerBlocking = false
        eventPlayer.allowButton(Button.MELEE)
        wait(8)
    else:
        eventPlayer.startFacing(directionTowards(eventPlayer, eventPlayer.botTarget) + -0.3 * Vector.UP, 999)
        wait(0.25)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        eventPlayer.botAbilityCooldown += 7
        restoreDefaultFacingMovement()


rule "ENSNARER LUNGE":
    @Event eachPlayer
    @Team 2
    @Hero hazard
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 20 * eventPlayer.sizeScale
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 30
    @Condition eventPlayer.botTarget.getSpeed() >= 10
    @Condition eventPlayer.botIsEnsnarerMeleeActive != true
    @Condition eventPlayer.botIsEnsnarerBlocking != true

    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(1)
