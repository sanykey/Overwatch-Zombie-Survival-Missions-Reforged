#!mainFile "../../main.opy"


macro useAirStrikePowerUp():
    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 41, null, getAllPlayers(), false)) > 40:
        smallMessage(eventPlayer, "Aim at a surface to call in an aistrike")
        return
    eventPlayer.activePowerUpIds.append(PowerUpItem.AIR_STRIKE)
    startRule(airStrike, StartRuleBehavior.NOOP)


def airStrike():
    @Name "airStrike (30-39)"

    wait()
    smallMessage(getAllPlayers(), "{0} {1}: \"I've called in an air strike!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    #Air Strike Location
    eventPlayer.powerUpAirStrikePosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 40, null, getAllPlayers(), false)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer.powerUpAirStrikePosition, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpAirStrikeRingId = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, eventPlayer.powerUpAirStrikePosition, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.AIR_STRIKE_CLOUD] = getLastCreatedEntity()
    wait(2)
    #Count up to max radius. Number of explosions = Max radius / step size
    for eventPlayer.powerUpAirStrikeIndex in range(50):
        #Random position in ring
        # airStrikeRayStartPosition: candidate explosion position above the strike area, to raycast onto the ground.
        #!define airStrikeRayStartPosition tmp0
        airStrikeRayStartPosition = eventPlayer.powerUpAirStrikePosition + 5 * Vector.UP + directionFromAngles(random.uniform(0, 360), 0) * random.uniform(0, 10)
        #Ray Cast downwards
        # airStrikeImpactPosition: ground impact position, shared by this explosion's effects and damage-radius check.
        #!define airStrikeImpactPosition tmp0
        airStrikeImpactPosition = raycastHitPosition(airStrikeRayStartPosition, airStrikeRayStartPosition + -25 * Vector.UP, null, getAllPlayers(), false)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, airStrikeImpactPosition, 2.5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, airStrikeImpactPosition, 5)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, airStrikeImpactPosition, 100)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.ORANGE, airStrikeImpactPosition, 100)
        # airStrikeAffectedZombieList: zombies inside this explosion's radius, to damage them and set their respawn timers.
        #!define airStrikeAffectedZombieList tmp1
        airStrikeAffectedZombieList = getPlayersInRadius(airStrikeImpactPosition, 5, Team.2)
        damage(airStrikeAffectedZombieList, eventPlayer, 150)
        airStrikeAffectedZombieList.botRespawnDelay = 10
        wait(0.125)
    destroyEffect(eventPlayer.powerUpAirStrikeRingId)
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.AIR_STRIKE_CLOUD])
    eventPlayer.activePowerUpIds.remove(PowerUpItem.AIR_STRIKE)
