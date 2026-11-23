#!mainFile "../../main.opy"


macro useStunPowerUp():
    #Check if their are targets nearby and in view angle
    if getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).any(lambda player: distance(eventPlayer, player) < 15 * eventPlayer.sizeScale and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45):
        eventPlayer.activePowerUpIds.append(PowerUpItem.STUN)
        startRule(stun, StartRuleBehavior.NOOP)
    else:
        smallMessage(eventPlayer, "Aim at a nearby target")
        return


def stun():
    @Name "stun (100-109)"

    # Reuse the origin within each live evaluation of the beam endpoint.
    createBeam(
        getAllPlayers(), Beam.BAD, eventPlayer.powerUpStunBeamPosition,
        [eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst].map(lambda origin: (
            eventPlayer.powerUpStunBeamPosition
            + directionTowards(eventPlayer.powerUpStunBeamPosition, origin) * min(3, distance(eventPlayer.powerUpStunBeamPosition, origin))
        ))[0],
        Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )
    eventPlayer.powerUpStunBeamId = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 30)
    #Stun beam lead
    eventPlayer.powerUpStunBeamPosition = eventPlayer.getPosition() + losOffsetConst
    #Stun origin player
    eventPlayer.powerUpStunOrigin = eventPlayer
    #Stun Target
    eventPlayer.powerUpStunTarget = (sorted(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer, player) < 15 * eventPlayer.sizeScale), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
    chaseAtRate(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunTarget.getPosition() + losOffsetConst, 50)
    #Number of bounces
    for eventPlayer.powerUpStunBouncesRemaining in range(50, 0, -1):
        if eventPlayer.powerUpStunTarget == null:
            if eventPlayer.powerUpStunBouncesRemaining > 13 and not eventPlayer.powerUpStunOrigin in bossStateList:
                eventPlayer.powerUpStunOrigin.setStatusEffect(eventPlayer, Status.STUNNED, eventPlayer.powerUpStunBouncesRemaining / 8.3)
            break
        waitUntil(distance(eventPlayer.powerUpStunBeamPosition, eventPlayer.powerUpStunTarget.getPosition() + losOffsetConst) < 0.1, 3)
        eventPlayer.powerUpStunTarget.setStatusEffect(eventPlayer, Status.STUNNED, 0.5 if eventPlayer.powerUpStunTarget in bossStateList else 1.5)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.powerUpStunTarget, 0.5)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.powerUpStunTarget.getPosition(), 50)
        wait()
        #Previous target is new origin
        eventPlayer.powerUpStunOrigin = eventPlayer.powerUpStunTarget
        #Set next target
        eventPlayer.powerUpStunTarget = random.choice((getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpStunOrigin, player) < 15 and not player.botIsTeleporting)).exclude(eventPlayer.powerUpStunTarget))
    stopChasing(eventPlayer.powerUpStunBeamPosition)
    destroyEffect(eventPlayer.powerUpStunBeamId)
    eventPlayer.activePowerUpIds.remove(PowerUpItem.STUN)
