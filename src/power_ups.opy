#!mainFile "../main.opy"
subroutine finishPowerUpDrop



macro powerUpAssignmentMacro():
    #Names/colors follow item IDs 1-13; effect and text positions keep separate indices.
    # Item type ID, not an effect/text handle; refresh and consume it synchronously on each pass.
    # Only visibility reevaluates, so neither the initial color nor the label retains a scratch dependency.
    #!define groundPowerUpItemId tmp0
    groundPowerUpItemId = supplyPowerUpIdList[len(supplyPowerUpEffectIdList)]
    if groundPowerUpItemId >= 1 and groundPowerUpItemId <= 13:
        createEffect(getAllPlayers(), Effect.ORB, powerUpColorListConst[groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpEffectIdList)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), ["CURE", "Revive", "Force Field", "No Cooldowns", "Air Strike", "Beacon of Healing", "Vaccine", "Sentry Turret", "Cloaking Device", "Super Nano", "Bounce Pad", "Ultimate Charger", "Stun"][groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpTextIdList)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)


rule "POWER UP EFFECT/TEXT MANAGEMENT":
    @Condition isGameplayActive == true
    @Condition len(supplyPowerUpPositionList) > len(supplyPowerUpEffectIdList)
    
    powerUpAssignmentMacro()
    supplyPowerUpEffectIdList.append(getLastCreatedEntity())
    supplyPowerUpTextIdList.append(getLastCreatedText())
    if ruleCondition:
        loop()


rule "EFFECT/TEXT (PERMANENT)":
    @Condition isGameplayActive == true
    
    #One row per item ID (1-13); capture the index and the resolved color.
    # Capture each row's color directly from the immutable shared item palette.
    # powerUpHudItemIndex: zero-based item index, to choose the row's visibility, name, instructions and color.
    #!define powerUpHudItemIndex tmp0
    for powerUpHudItemIndex in range(13):
        hudText(
            getLivingPlayers(Team.1).filter(lambda player: player.powerUpItemId == evalOnce(powerUpHudItemIndex) + 1),
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
            ][evalOnce(powerUpHudItemIndex)],
            "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)),
            "{0} [{1}] {2}".format(
                "Look at a teammate and hold" if evalOnce(powerUpHudItemIndex) == 1 else "Hold",
                inputBindingString(Button.INTERACT),
                [
                    "to stop all damage over time and cure yourself",
                    "to revive them",
                    "to place a force field",
                    "to get fast cooldowns",
                    "to call in an air strike",
                    "to place a healing beacon and gain bonus healing",
                    "to increase your resistance to infection",
                    "to place a sentry turret",
                    "to become invisible to enemies",
                    "to increase your damage and speed",
                    "to place a bounce pad",
                    "to rapidly charge your ultimate",
                    "to stun nearby enemies"
                ][evalOnce(powerUpHudItemIndex)]
            ),
            HudPosition.LEFT,
            100,
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            HudReeval.VISIBILITY_AND_STRING
        )


rule "PLAYER DROPS POWER UP (MANUAL)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.powerUpItemId
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    supplyPowerUpIdList.append(eventPlayer.powerUpItemId)
    supplyPowerUpPositionList.append(eventPlayer.getPosition() + offsetUpQuarterConst if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()))
    wait()
    finishPowerUpDrop()


rule "PLAYER DROPS POWER UP (DEATH)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.powerUpItemId
    
    while not eventPlayer.isOnGround():
        wait(0.25)
    supplyPowerUpIdList.append(eventPlayer.powerUpItemId)
    supplyPowerUpPositionList.append(eventPlayer.getPosition() + offsetUpQuarterConst)
    wait()
    finishPowerUpDrop()


def finishPowerUpDrop():
    @Name "finishPowerUpDrop"

    eventPlayer.powerUpItemId = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
