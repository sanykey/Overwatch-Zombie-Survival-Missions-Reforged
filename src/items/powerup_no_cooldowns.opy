#!mainFile "../../main.opy"


macro useNoCooldownsPowerUp():
    noCooldownsDuration = 15
    noCooldowns()


def noCooldowns():
    @Name "noCooldowns"

    # Consume the duration before any other call. A pickup refreshes the running timer.
    eventPlayer.noCooldownsEndTime = getTotalTimeElapsed() + noCooldownsDuration
    playAquaPowerUpSound()
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.RED, eventPlayer, 50)


rule "NO COOLDOWNS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.noCooldownsEndTime > 0

    # Own one HUD and reset loop per player, including after a pickup refresh.
    hudHeader(eventPlayer, f"No Cooldowns: {ceil(eventPlayer.noCooldownsEndTime - getTotalTimeElapsed())}s", HudPosition.RIGHT, 0.2, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.powerUpNoCooldownsHudId = getLastCreatedText()
    while eventPlayer.noCooldownsEndTime > getTotalTimeElapsed():
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.INTERACT, 0)
        eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
        eventPlayer.setAbilityCooldown(Button.JUMP, 0)
        eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
        if eventPlayer.getHero() != Hero.REAPER:
            eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
        eventPlayer.setAbilityCharge(Button.SECONDARY_FIRE, 2)
        eventPlayer.setAbilityCooldown(Button.RELOAD, 0)
        wait(0.096)
    destroyHudText(eventPlayer.powerUpNoCooldownsHudId)
    eventPlayer.noCooldownsEndTime = 0
