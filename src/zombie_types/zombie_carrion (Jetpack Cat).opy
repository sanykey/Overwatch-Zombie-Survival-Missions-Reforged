#!mainFile "../../main.opy"

rule "CARRION (JETPACK CAT) ABILITIES":
    @Event eachPlayer
    @Team 2
    @Hero jetpackCat
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 4 * eventPlayer.sizeScale
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 15 * eventPlayer.sizeScale

    # ZSMM-remixed's one-shot sequence; rearm only after the range conditions become false.
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    if random.randint(1, 10) > 6:
        eventPlayer.setUltCharge(100)
        wait(0.5)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(1)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(2)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "CARRION (JETPACK CAT) TRANSPORT":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer in bossStateList == false
    @Condition isHeroBeingPlayed(Hero.JETPACK_CAT, Team.2) == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) > 4 * eventPlayer.sizeScale

    # Teammates request transport, not just the cat. Preserve the source's one-shot input.
    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.25)
