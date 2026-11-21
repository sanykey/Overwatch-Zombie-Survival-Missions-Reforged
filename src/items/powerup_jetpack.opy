#!mainFile "../../main.opy"


# Refuel by 100 up to the cap, including during an active flight chase.
macro useJetpackPowerUp():
    if eventPlayer.getHero() in [Hero.JETPACK_CAT, Hero.PHARAH]:
        smallMessage(eventPlayer, "Your hero cannot use Jetpack")
        return
    if eventPlayer.powerUpJetpackFuel >= POWERUP_JETPACK_FUEL_MAX:
        smallMessage(eventPlayer, "Jetpack fuel is full")
        return
    eventPlayer.powerUpJetpackFuel = min(POWERUP_JETPACK_FUEL_MAX, eventPlayer.powerUpJetpackFuel + 100)
    playAquaPowerUpSound()


rule "JETPACK FLIGHT":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.powerUpJetpackFuel > 0

    # Require a continuous Jump hold before thrust or fuel consumption begins.
    wait(JETPACK_ACTIVATION_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.powerUpJetpackIsFlying = true
    eventPlayer.setGravity(0)
    applyScaledMoveSpeed()
    eventPlayer.startAcceleration(Vector.UP, 10, 4, Relativity.TO_WORLD)
    chaseAtRate(eventPlayer.powerUpJetpackFuel, 0, 40)
    # Single standard effect at the feet, replacing both donor hero-specific beams.
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.PURPLE, eventPlayer.getPosition() + 0.3 * Vector.UP, 0.35, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.JETPACK_FLIGHT_EFFECT] = getLastCreatedEntity()
    waitUntil(not ruleCondition, Math.INFINITY)
    stopChasing(eventPlayer.powerUpJetpackFuel)
    eventPlayer.stopAcceleration()
    eventPlayer.setGravity(100)
    eventPlayer.powerUpJetpackIsFlying = false
    applyScaledMoveSpeed()
    destroyEffect(eventPlayer.powerUpEntityIdList[PowerUpEntitySlot.JETPACK_FLIGHT_EFFECT])
