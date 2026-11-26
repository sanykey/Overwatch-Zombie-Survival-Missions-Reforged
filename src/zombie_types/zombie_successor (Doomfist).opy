#!mainFile "../../main.opy"

rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE":
    @Event eachPlayer
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isUsingUltimate()

    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isDead(), 10)
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "SUCCESSOR PUNCHES IN RETALIATION":
    @Event playerTookDamage
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(1)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
