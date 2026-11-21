#!mainFile "../../main.opy"


def deploySentryTurret():
    @Name "deploySentryTurret"

    # Both the Engineer and the item move the same turret and refresh its expiry.
    eventPlayer.powerUpTurretPosition = (eventPlayer.getPosition() if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())) + Vector.UP
    eventPlayer.powerUpTurretDirection = null
    eventPlayer.powerUpTurretEndsAt = getTotalTimeElapsed() + 30
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition, 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpTurretPosition, 50)
    startRule(sentryTurret, StartRuleBehavior.NOOP)


def sentryTurret():
    @Name "sentryTurret (50-59)"

    createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.powerUpTurretPosition, 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_BODY] = getLastCreatedEntity()
    # turretLegVisualIndex: turret-leg index, to space three beams 120 degrees apart and store their effect IDs.
    #!define turretLegVisualIndex tmp0
    for turretLegVisualIndex in range(3):
        createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionFromAngles(evalOnce(turretLegVisualIndex) * 120, 60) * 1.5, Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_LEG_1 + turretLegVisualIndex] = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.GRAPPLE, eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + ((eventPlayer.powerUpTurretDirection if eventPlayer.powerUpTurretDirection != null else eventPlayer.getFacingDirection()) * 0.5), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_BARREL] = getLastCreatedEntity()
    hudHeader(eventPlayer, "Sentry Turret: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpTurretEndsAt)), HudPosition.RIGHT, 0.2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_HUD] = getLastCreatedText()
    while getTotalTimeElapsed() < eventPlayer.powerUpTurretEndsAt:
        # One visible-target snapshot per shot check, consumed before tmp0 becomes the impact.
        # Keep teleporting targets in the aim list; only the firing gate excludes them.
        #!define turretVisibleTargets tmp0
        turretVisibleTargets = getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player))
        if turretVisibleTargets.any(lambda player: not player.botIsTeleporting):
            eventPlayer.powerUpTurretDirection = directionTowards(eventPlayer.powerUpTurretPosition, sorted(turretVisibleTargets, lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0].getPosition() + Vector.UP)
            # turretShotImpactPosition: turret shot's impact position with random spread, to place its explosion and damage ray.
            #!define turretShotImpactPosition tmp0
            turretShotImpactPosition = raycastHitPosition(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + ((directionFromAngles(random.uniform(-1, 1) + horizontalAngleOfDirection(eventPlayer.powerUpTurretDirection), random.uniform(-1, 1) + verticalAngleOfDirection(eventPlayer.powerUpTurretDirection))) * 100), getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 25)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.powerUpTurretPosition + eventPlayer.powerUpTurretDirection * 0.5, 0.1)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, turretShotImpactPosition, 0.1)
            # The impact position has no live reevaluation readers. Reuse tmp0 for
            # the hit player after the raycast consumes it; freeze and damage finish
            # before the wait, with no nested calls or asynchronous scratch reads.
            #!define turretShotVictim tmp0
            turretShotVictim = raycastHitPlayer(eventPlayer.powerUpTurretPosition, eventPlayer.powerUpTurretPosition + directionTowards(eventPlayer.powerUpTurretPosition, turretShotImpactPosition) * 100, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true)
            # Bobby the Snowman (QZD5F): one of 21 rolls freezes for 2 seconds before damage.
            if eventPlayer.enhancementId == Enhancement.ENGINEER and random.randint(0, 20) == 0:
                turretShotVictim.setStatusEffect(eventPlayer, Status.FROZEN, 2)
            damage(turretShotVictim, eventPlayer, 20)
        else:
            eventPlayer.powerUpTurretDirection = null
        wait(0.125)
    # turretCleanupEffectIndex: turret-effect slot 50-54, to destroy the sphere, legs and barrel when the turret expires.
    #!define turretCleanupEffectIndex tmp0
    for turretCleanupEffectIndex in range(PowerUpEntitySlot.SENTRY_TURRET_BODY, PowerUpEntitySlot.SENTRY_TURRET_BARREL + 1):
        destroyEffect(eventPlayer.powerUpEntityIdList[turretCleanupEffectIndex])
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.SENTRY_TURRET_HUD])
    eventPlayer.powerUpTurretPosition = 0
