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
        # forceFieldZombieIndex: zombie index, to apply the force-field impulse to each nearby living zombie.
        #!define forceFieldZombieIndex tmp0
        for forceFieldZombieIndex in range(getNumberOfLivingPlayers(Team.2)):
            if distance(getLivingPlayers(Team.2)[forceFieldZombieIndex], eventPlayer.powerUpForceFieldPosition) <= 7.5:
                getLivingPlayers(Team.2)[forceFieldZombieIndex].applyImpulse(directionTowards(eventPlayer.powerUpForceFieldPosition, getLivingPlayers(Team.2)[forceFieldZombieIndex]), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait(0.032)
    destroyEffect(eventPlayer.powerUpForceFieldSphereId)
    destroyHudText(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.FORCE_FIELD_HUD])
    eventPlayer.powerUpForceFieldPosition = 0
