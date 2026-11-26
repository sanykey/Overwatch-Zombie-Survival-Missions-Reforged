#!mainFile "../../main.opy"

rule "BRUTE (REIN) SUPER SEISMIC SLAM":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.botTarget) < 1.5 * eventPlayer.sizeScale

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    # Bound the wait in case the forced button press fails to start the ultimate.
    waitUntil(eventPlayer.isUsingUltimate() or eventPlayer.isDead() or eventPlayer.botIsCrowdControlled, 1.5)
    if not eventPlayer.isUsingUltimate() or eventPlayer.isDead() or eventPlayer.botIsCrowdControlled:
        return
    # Snapshot the impact center after the ultimate starts. Effects and target filters consume it synchronously.
    #!define bruteSlamCenter tmp0
    bruteSlamCenter = worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, bruteSlamCenter, 20 * eventPlayer.sizeScale)
    (getLivingPlayers(Team.ALL).filter(lambda x: distance(eventPlayer, x) < 20 * eventPlayer.sizeScale and distance(bruteSlamCenter, x) > 1.5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.sizeScale)).applyImpulse(Vector.UP, 15 * eventPlayer.sizeScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, bruteSlamCenter, 3 * eventPlayer.sizeScale)
    (null.concat(getLivingPlayers(Team.2)).filter(lambda x: distance(x, bruteSlamCenter) < 1.5 * eventPlayer.sizeScale and not x.hasStatus(Status.KNOCKED_DOWN))).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2.5)
