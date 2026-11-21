#!mainFile "../../main.opy"


# Publish placement and expiry before requesting the worker.
# An active worker continues from its current wait.
macro useForceFieldPowerUp():
    eventPlayer.powerUpForceFieldPosition = eventPlayer.getPosition()
    eventPlayer.powerUpForceFieldEndsAt = getTotalTimeElapsed() + 10
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 50)
    startRule(playerForceField, StartRuleBehavior.NOOP)


def playerForceField():
    @Name "playerForceField (10-19)"

    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, eventPlayer.powerUpForceFieldPosition, 7.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpForceFieldSphereId = getLastCreatedEntity()
    hudHeader(eventPlayer, "Force Field: {0}s".format(powerUpSecondsRemaining(eventPlayer.powerUpForceFieldEndsAt)), HudPosition.RIGHT, 0.2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.FORCE_FIELD_HUD] = getLastCreatedText()
    while getTotalTimeElapsed() < eventPlayer.powerUpForceFieldEndsAt:
        # Snapshot nearby living zombies once per tick. All scratch reads finish before the wait.
        #!define forceFieldZombies tmp2
        #!define forceFieldZombieIndex tmp0
        #!define forceFieldZombie tmp1
        forceFieldZombies = getLivingPlayers(Team.2).filter(lambda zombie: distance(zombie, eventPlayer.powerUpForceFieldPosition) <= 7.5)
        for forceFieldZombieIndex in range(len(forceFieldZombies)):
            forceFieldZombie = forceFieldZombies[forceFieldZombieIndex]
            forceFieldZombie.applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, forceFieldZombie), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpForceFieldSphereId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.FORCE_FIELD_HUD])
    eventPlayer.powerUpForceFieldPosition = 0
