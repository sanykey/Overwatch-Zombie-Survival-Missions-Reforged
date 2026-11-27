#!mainFile "../../main.opy"


macro spendBornToBattleReset():
    # Only a full reserve leaves one reset after spending.
    eventPlayer.enhancementBattleResetCharges = floor(eventPlayer.enhancementBattleResetCharges / BORN_TO_BATTLE_MAX_RESETS)


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementBattleResetCharges >= 1
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true

    # Retain button priority and fall back to the previous choice if all buttons were released.
    eventPlayer.enhancementBattleAbilityButton = (
        [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP]
        .filter(lambda button: eventPlayer.isHoldingButton(button))
        .concat(eventPlayer.enhancementBattleAbilityButton)
    )[0]
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            resetBattleAbilityCharge()
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            resetBattleAbilityCharge()
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton) + 1)
    lbl_0:
    if not eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):
        if eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) <= 0.5:
            return
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)
    spendBornToBattleReset()


def resetBattleAbilityCharge():
    @Name "resetBattleAbilityCharge"

    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, 1)
    spendBornToBattleReset()


macro initializeBornToBattleMacro():
    #Enhancement: Born to Battle
    # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
    eventPlayer.enhancementBattleResetCharges = 0


macro creditBornToBattleFinalBlowMacro():
    eventPlayer.enhancementBattleResetCharges = (
        1 if eventPlayer.enhancementBattleResetCharges < 1 else
        min(BORN_TO_BATTLE_MAX_RESETS, eventPlayer.enhancementBattleResetCharges + BORN_TO_BATTLE_SECOND_RESET_PER_FINAL_BLOW)
    )
