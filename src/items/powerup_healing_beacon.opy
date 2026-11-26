#!mainFile "../../main.opy"


macro useHealingBeaconPowerUp():
    eventPlayer.powerUpHealBeaconPosition = eventPlayer.getPosition()
    eventPlayer.powerUpHealBeaconEndsAt = getTotalTimeElapsed() + 30
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpHealBeaconPosition, 50)
    # Beacon adds 50 percentage points to permanent Plague Doctor / Overcharge bonuses.
    eventPlayer.setHealingDealt(150 + PLAGUE_DOCTOR_HEAL_BONUS_PCT if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR else 150 + OVERCHARGE_HEAL_BONUS_PCT if eventPlayer.enhancementId == Enhancement.OVERCHARGE else 150)
    startRule(healBeacon, StartRuleBehavior.NOOP)


def healBeacon():
    @Name "beaconofHealing (40-49)"

    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + -2 * Vector.UP, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpHealBeaconLightShaftId = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_RING] = getLastCreatedEntity()
    hudHeader(eventPlayer, "Beacon of Healing: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpHealBeaconEndsAt)), HudPosition.RIGHT, 0.2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_HUD] = getLastCreatedText()
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.YELLOW, eventPlayer, PLAYER_BUFF_AURA_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_AURA] = getLastCreatedEntity()
    while getTotalTimeElapsed() < eventPlayer.powerUpHealBeaconEndsAt:
        wait(1)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.powerUpHealBeaconPosition + Vector.UP, 0.1)
        getPlayersInRadius(eventPlayer.powerUpHealBeaconPosition, 10, eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 2, 30)
    destroyEffect(eventPlayer.powerUpHealBeaconLightShaftId)
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_RING])
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_HUD])
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.HEAL_BEACON_AURA])
    eventPlayer.setHealingDealt(100 + PLAGUE_DOCTOR_HEAL_BONUS_PCT if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR else 100 + OVERCHARGE_HEAL_BONUS_PCT if eventPlayer.enhancementId == Enhancement.OVERCHARGE else 100)
    eventPlayer.powerUpHealBeaconPosition = 0
