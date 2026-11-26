#!mainFile "../../main.opy"

rule "BRUTE KNOCKDOWN":
    @Event playerTookDamage
    @Team 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.getHero() == Hero.REINHARDT

    attacker.setUltCharge(attacker.getUltCharge() + 25)
    eventPlayer.applyImpulse(directionTowards(attacker, eventPlayer) + offsetUpQuarterConst, 15 * attacker.sizeScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    if eventPlayer.isCrowdControlCooldownActive == true:
        goto lbl_0
    eventPlayer.isCrowdControlCooldownActive = true
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    eventPlayer.setGravity(0)
    wait(0.35)
    eventPlayer.setGravity(100)
    wait(2)


rule "BRUTE FIRE STRIKE (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer in bossStateList == true
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) > 5 * eventPlayer.sizeScale
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    wait(1)
    if ruleCondition:
        loop()
