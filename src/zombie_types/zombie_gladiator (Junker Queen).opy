#!mainFile "../../main.opy"

rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT":
    @Event eachPlayer
    @Team 2
    @Hero junkerQueen
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 4 * eventPlayer.sizeScale
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 30 * eventPlayer.sizeScale

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(20)
    loop()
