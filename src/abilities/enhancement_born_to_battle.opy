#!mainFile "../../main.opy"


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementBattleResetCharges > 0
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
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):
        eventPlayer.enhancementBattleResetCharges -= 1
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)
        eventPlayer.enhancementBattleResetCharges -= 1


def resetBattleAbilityCharge():
    @Name "resetBattleAbilityCharge"

    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, 1)
    eventPlayer.enhancementBattleResetCharges -= 1


macro initializeBornToBattleMacro():
    #Enhancement: Born to Battle
    # enhancementBattleResetCharges: 0-2 earned ability resets; final blows add one and each reset consumes one.
    # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
    eventPlayer.enhancementBattleResetCharges = 0


macro creditBornToBattleFinalBlowMacro():
    if eventPlayer.enhancementBattleResetCharges < BORN_TO_BATTLE_MAX_RESETS:
        eventPlayer.enhancementBattleResetCharges += 1
