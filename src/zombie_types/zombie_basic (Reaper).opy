#!mainFile "../../main.opy"

rule "BASIC (REAPER) SHADOW STEP (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reaper
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botIsCrowdControlled != true
    @Condition eventPlayer in bossStateList == true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(1)
    while not eventPlayer.isUsingAbility2():
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        waitUntil(eventPlayer.isUsingAbility2(), 0.5)
        if eventPlayer.isUsingAbility2():
            waitUntil(not eventPlayer.isUsingAbility2(), 2)
            break
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.25)
    beginBotOverride()
    eventPlayer.startFacing(Vector.RIGHT, 180, Relativity.TO_PLAYER)
    while eventPlayer.isUsingAbility1():
        entityFloat()
        # shadowStepFloatTargetIndex: floated-player index, to push each affected player upward during the shadow-step ability.
        #!define shadowStepFloatTargetIndex tmp0
        for shadowStepFloatTargetIndex in range(len(eventPlayer.botSpecialTargetList)):
            selectIndexedAbilityTarget()
            if eventPlayer.botAbilityTarget.getPosition().y < eventPlayer.getPosition().y + 4 * eventPlayer.sizeScale:
                #Make target float up
                eventPlayer.botAbilityTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.botAbilityTarget, eventPlayer)), -50), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            else:
                #Push target straight up
                eventPlayer.botAbilityTarget.applyImpulse(Vector.UP, 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.032)
    resumeBotMovementAndFacing()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
