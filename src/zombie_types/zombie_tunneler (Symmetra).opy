#!mainFile "../../main.opy"

rule "TUNNELER (SYMMETRA) BUILDS PORTAL":
    @Event eachPlayer
    @Team 2
    @Hero symmetra
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 4 * eventPlayer.sizeScale
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 30 * eventPlayer.sizeScale
    @Condition eventPlayer.botTarget.isOnGround() == true

    eventPlayer.forceButtonPress(Button.ABILITY_2)
    abilityPlacement()
    wait(7)


rule "TUNNELER PORTAL LETS ZOMBIES THROUGH":
    @Event eachPlayer
    @Team 2
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 4 * eventPlayer.sizeScale
    @Condition eventPlayer in bossStateList == false
    @Condition isHeroBeingPlayed(Hero.SYMMETRA, Team.2) == true

    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.25)
