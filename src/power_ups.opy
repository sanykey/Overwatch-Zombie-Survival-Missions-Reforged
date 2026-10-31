#!mainFile "main.opy"



macro powerUpAssignmentMacro():
    #Names/colors follow item IDs 1-13; effect and text positions keep separate indices.
    if powerUpIDs[len(powerUpEffect)] >= 1 and powerUpIDs[len(powerUpEffect)] <= 13:
        createEffect(getAllPlayers(), Effect.ORB, [Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE][powerUpIDs[len(powerUpEffect)] - 1], powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), ["CURE", "Revive", "Force Field", "No Cooldowns", "Air Strike", "Beacon of Healing", "Vaccine", "Sentry Turret", "Cloaking Device", "Super Nano", "Bounce Pad", "Ultimate Charger", "Stun"][powerUpIDs[len(powerUpEffect)] - 1], powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)


rule "POWER UP EFFECT/TEXT MANAGEMENT":
    @Condition isGameplayActive == true
    @Condition len(powerUpPositions) > len(powerUpEffect)
    @Condition len(availablePowerups) > 0
    
    powerUpAssignmentMacro()
    powerUpEffect.append(getLastCreatedEntity())
    powerUpText.append(getLastCreatedText())
    if ruleCondition:
        loop()


rule "EFFECT/TEXT (PERMANENT)":
    @Condition isGameplayActive == true
    @Condition len(availablePowerups) > 0
    
    #One row per item ID (1-13); capture the index and the resolved color.
    # tmp1: colors indexed by item ID minus 1, to give each power-up HUD row its item color.
    tmp1 = [Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE]
    # tmp0: zero-based item index, to choose the row's visibility, name, instructions and color.
    for tmp0 in range(13):
        hudText(
            getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == evalOnce(tmp0) + 1),
            [
                "CURE",
                "REVIVE",
                "Force Field",
                "No Cooldowns",
                "Air Strike",
                "Beacon of Healing",
                "VACCINE",
                "Sentry Turret",
                "Cloaking Device",
                "Super Nano",
                "Bounce Pad",
                "Ultimate Charger",
                "Stun"
            ][evalOnce(tmp0)],
            "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)),
            [
                "Hold [{0}] to stop all damage over time and cure yourself".format(inputBindingString(Button.INTERACT)),
                "Look at a teammate and hold [{0}] to revive them".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to place a force field".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to get fast cooldowns".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to call in an air strike".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to place a healing beacon and gain bonus healing".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to increase your resistance to infection".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to place a sentry turret".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to become invisible to enemies".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to increase your damage and speed".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to place a bounce pad".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to rapidly charge your ultimate".format(inputBindingString(Button.INTERACT)),
                "Hold [{0}] to stun nearby enemies".format(inputBindingString(Button.INTERACT))
            ][evalOnce(tmp0)],
            HudPosition.LEFT,
            100,
            evalOnce(tmp1[tmp0]),
            evalOnce(tmp1[tmp0]),
            evalOnce(tmp1[tmp0]),
            HudReeval.VISIBILITY_AND_STRING
        )


rule "PLAYER DROPS POWER UP (MANUAL)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.currentPowerUp != 0
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0) if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)


rule "PLAYER DROPS POWER UP (DEATH)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.currentPowerUp != 0
    
    while not eventPlayer.isOnGround():
        wait(0.25)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
