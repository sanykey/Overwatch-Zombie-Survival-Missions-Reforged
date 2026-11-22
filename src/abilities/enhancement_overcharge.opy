#!mainFile "../../main.opy"

subroutine refreshOverchargeEnergy


macro overchargeEarnedEnergyTotal(player):
    (
        player.getStatistic(Stat.HEALING_DEALT) / OVERCHARGE_HEAL_ENERGY_DIVISOR
        + OVERCHARGE_ENERGY_PER_ASSIST * earnedAssists(player)
    )


macro initializeOverchargeMacro():
    eventPlayer.setHealingDealt(100 + OVERCHARGE_HEAL_BONUS_PCT)
    eventPlayer.enhancementCapacitorEnergy = 0
    eventPlayer.enhancementCapacitorCharge = 0
    eventPlayer.enhancementCapacitorDeadline = 0
    # Start from existing match stats so earlier healing and assists grant no energy.
    eventPlayer.enhancementCapacitorStatsSnapshot = overchargeEarnedEnergyTotal(eventPlayer)


macro applyOverchargeHitMacro(hitTarget):
    if eventPlayer.enhancementCapacitorCharge > 0:
        if eventPlayer.enhancementCapacitorDeadline == 0:
            eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
        if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
            damage(hitTarget, eventPlayer, eventPlayer.enhancementCapacitorCharge)


macro creditOverchargeHealthPackMacro():
    if isGameplayActive and eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        eventPlayer.enhancementCapacitorEnergy += eventHealing / OVERCHARGE_HEAL_ENERGY_DIVISOR


rule "OVERCHARGE ARM ON DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.enhancementCapacitorCharge == 0

    # Require a release and a second press within the tap windows.
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), OVERCHARGE_ARM_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), OVERCHARGE_ARM_TAP_WINDOW)
    if not ruleCondition:
        return

    # Spend from the current balance even between background samples.
    refreshOverchargeEnergy()
    if eventPlayer.enhancementCapacitorEnergy <= 0:
        return
    eventPlayer.enhancementCapacitorCharge = min(eventPlayer.enhancementCapacitorEnergy, OVERCHARGE_MAX_CHARGE)
    eventPlayer.enhancementCapacitorEnergy -= eventPlayer.enhancementCapacitorCharge


rule "OVERCHARGE STORES HEALING AND ASSISTS":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.OVERCHARGE)

    wait(OVERCHARGE_ENERGY_REFRESH_INTERVAL, Wait.ABORT_WHEN_FALSE)
    refreshOverchargeEnergy()
    loop()


def refreshOverchargeEnergy():
    @Name "refreshOverchargeEnergy"

    # Sample native Healing Dealt and assists together. tmp0 is synchronous scratch.
    #!define overchargeCurrentEarnedEnergy tmp0
    overchargeCurrentEarnedEnergy = overchargeEarnedEnergyTotal(eventPlayer)
    if overchargeCurrentEarnedEnergy != eventPlayer.enhancementCapacitorStatsSnapshot:
        eventPlayer.enhancementCapacitorEnergy += max(
            0, overchargeCurrentEarnedEnergy - eventPlayer.enhancementCapacitorStatsSnapshot
        )
        # A stat reset establishes a new baseline without reducing the balance.
        eventPlayer.enhancementCapacitorStatsSnapshot = overchargeCurrentEarnedEnergy


rule "OVERCHARGE CLEARS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementCapacitorCharge > 0
    @Condition (eventPlayer.isDead() or eventPlayer.enhancementCapacitorDeadline > 0 and getTotalTimeElapsed() >= eventPlayer.enhancementCapacitorDeadline) == true

    if eventPlayer.enhancementId != Enhancement.OVERCHARGE:
        return

    eventPlayer.enhancementCapacitorCharge = 0
    eventPlayer.enhancementCapacitorDeadline = 0
