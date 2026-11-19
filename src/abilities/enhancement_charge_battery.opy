#!mainFile "../../main.opy"

# Charge Battery behavior and initialization.
# Shared IDs and icon tables live in core/enums.opy and core/immutable_variables.opy.
# Shared storage contracts remain in core/variables.opy.
# noCooldowns and checkEnhancementPlacement are shared with other systems.

macro initializeChargeBatteryMacro():
    #Enhancement: Charge Battery
    # enhancementBatteryPosition: placed battery position in world coordinates, for effects and player proximity checks.
    # enhancementBatteryReuseCooldown: remaining battery reuse cooldown in seconds, for the progress bar and availability visuals.
    # enhancementBatteryPlacementCooldown: remaining placement cooldown in seconds, for placement checks and HUD.
    #Battery placement visual
    createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementBatteryPlacementCooldown <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, Color.GREEN, worldVector(0.1 * Vector.UP, eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Battery ring
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Battery sphere
    createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Charge battery text
    createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0 and distance(player, eventPlayer.enhancementBatteryPosition) < 6), "Charge Battery", eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    #Charge battery progress bar
    createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown > 0 and distance(player, eventPlayer.enhancementBatteryPosition) < 6), 100 - eventPlayer.enhancementBatteryReuseCooldown * (100 / CHARGE_BATTERY_RECHARGE_DURATION), [], eventPlayer.enhancementBatteryPosition + 0.4 * Vector.UP, 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)


rule "[CHARGE_BATTERY] NO COOLDOWNS ON ULTIMATE":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY)
    @Condition eventPlayer.isUsingUltimate() == true

    # Keep the active-timer check in Actions so expiry cannot trigger a window mid-ult.
    if eventPlayer.noCooldownsEndTime <= getTotalTimeElapsed():
        # Synchronous duration argument, consumed by noCooldowns().
        noCooldownsDuration = CHARGE_BATTERY_NO_COOLDOWNS_DURATION
        noCooldowns()


rule "[CHARGE_BATTERY] PLACE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementBatteryPlacementCooldown <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    # Synchronous feedback color; consumed by both Play Effects before the next wait.
    placementWindupColor = Color.YELLOW
    playPlacementWindupFeedback()
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), Math.INFINITY)
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    eventPlayer.enhancementBatteryPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementBatteryPlacementCooldown = CHARGE_BATTERY_PLACEMENT_COOLDOWN
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementBatteryReuseCooldown = 0
    while eventPlayer.enhancementBatteryPlacementCooldown > 0:
        wait(1)
        eventPlayer.enhancementBatteryPlacementCooldown += -1


# Share eligibility between activation and selection; playerTargetList can briefly retain dead/unspawned players.
#!define isBatteryChargeEligible(player) player.hasSpawned() and player.isAlive() and player.getUltCharge() < 100 and distance(player, eventPlayer.enhancementBatteryPosition) < 1.5 * player.sizeScale

rule "[CHARGE_BATTERY] USAGE AND COOLDOWNS":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY)
    @Condition eventPlayer.enhancementBatteryPosition
    @Condition playerTargetList.any(lambda player: isBatteryChargeEligible(player)) == true
    
    # batteryChargeRecipient: survivor using the battery, to play feedback and grant ultimate charge before cooldown waits.
    #!define batteryChargeRecipient tmp0
    batteryChargeRecipient = (playerTargetList.filter(lambda player: isBatteryChargeEligible(player)))[0]
    # Recheck at action time: no feedback, charge or cooldown if eligibility changed since activation.
    if batteryChargeRecipient == null:
        return
    playEffect(batteryChargeRecipient, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, batteryChargeRecipient, 50)
    playEffect(batteryChargeRecipient, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementBatteryPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, batteryChargeRecipient, 1)
    batteryChargeRecipient.setUltCharge(batteryChargeRecipient.getUltCharge() + CHARGE_BATTERY_ULT_CHARGE_PCT)
    eventPlayer.enhancementBatteryReuseCooldown = CHARGE_BATTERY_RECHARGE_DURATION
    while eventPlayer.enhancementBatteryReuseCooldown > 0:
        wait(0.5)
        eventPlayer.enhancementBatteryReuseCooldown += -0.5
    if ruleCondition:
        loop()


