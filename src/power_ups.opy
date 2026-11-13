#!mainFile "../main.opy"
subroutine finishPowerUpDrop
subroutine dropCarriedPowerUps



macro powerUpAssignmentMacro():
    #Names/colors follow item IDs 1-13; effect and text positions keep separate indices.
    # Item type ID, not an effect/text handle; refresh and consume it synchronously on each pass.
    # Only visibility reevaluates, so neither the initial color nor the label retains a scratch dependency.
    #!define groundPowerUpItemId tmp0
    groundPowerUpItemId = supplyPowerUpIdList[len(supplyPowerUpEffectIdList)]
    if groundPowerUpItemId >= PowerUpItem.CURE and groundPowerUpItemId <= PowerUpItem.STUN:
        createEffect(getAllPlayers(), Effect.ORB, powerUpColorListConst[groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpEffectIdList)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), ["CURE", "Revive", "Force Field", "No Cooldowns", "Air Strike", "Beacon of Healing", "Vaccine", "Sentry Turret", "Cloaking Device", "Super Nano", "Jetpack", "Ultimate Charger", "Stun"][groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpTextIdList)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)


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
    for powerUpHudItemIndex in range(PowerUpItem.STUN):
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
                "Jetpack",
                "Ultimate Charger",
                "Stun"
            ][evalOnce(powerUpHudItemIndex)],
            "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)),
            "{0} [{1}] {2}".format(
                "Look at a teammate and hold" if evalOnce(powerUpHudItemIndex) == PowerUpItem.REVIVE - 1 else "Hold",
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
                    "to refuel your jetpack; hold Jump in the air to fly",
                    "to rapidly charge your ultimate",
                    "to stun nearby enemies"
                ][evalOnce(powerUpHudItemIndex)]
            ),
            HudPosition.ACTUALLY_LEFT,
            100,
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            evalOnce(powerUpColorListConst[powerUpHudItemIndex]),
            HudReeval.VISIBILITY_AND_STRING
        )


# Workshop workaround: separate gameplay/alive conditions here can make newer
# heroes disappear when returning to hero selection during voting (map dependent).
# Grouping them with And prevented reproduction in user tests; the cause is unknown.
# The same workaround did NOT help "APOTHECARY ALLOW HEALTH PACK PICKUP" in
# src/augments.opy, reverted by ba8e70de7d4e282b2f90c8ae6c15f6d1d500a342.
# OverPy 9.7.20 splits And conditions; disable optimization only for this rule.
# Explicit Null operands below preserve the existing compiled inventory comparisons.
#!disableOptimizations
rule "PLAYER DROPS POWER UP (MANUAL)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition (isGameplayActive and eventPlayer.isAlive()) == true
    @Condition (eventPlayer.powerUpItemId != null or (eventPlayer.augmentId == Augment.SCAVENGER and len(eventPlayer.augmentScavengerBackpack) > null)) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    dropCarriedPowerUps()

#!enableOptimizations

rule "PLAYER DROPS POWER UP (DEATH)":
    @Event playerDied
    @Team 1
    @Condition (eventPlayer.powerUpItemId != PowerUpItem.NONE or (eventPlayer.augmentId == Augment.SCAVENGER and len(eventPlayer.augmentScavengerBackpack) > 0)) == true
    
    # Reserve slots must be emptied before respawn initialization; use a walkable
    # drop position immediately for Scavenger instead of waiting for the corpse.
    if eventPlayer.augmentId != Augment.SCAVENGER:
        while not eventPlayer.isOnGround():
            wait(0.25)
    dropCarriedPowerUps()


def dropCarriedPowerUps():
    @Name "dropCarriedPowerUps"

    # Snapshot all carried IDs and the drop center, then publish and clear them in
    # one execution. All writes are synchronous; no waits in this helper.
    #!define droppedPowerUpIds tmp0
    #!define droppedPowerUpPosition tmp1
    droppedPowerUpIds = [eventPlayer.powerUpItemId] if eventPlayer.powerUpItemId != PowerUpItem.NONE else []
    if eventPlayer.augmentId == Augment.SCAVENGER:
        droppedPowerUpIds = droppedPowerUpIds.concat(eventPlayer.augmentScavengerBackpack)
        eventPlayer.augmentScavengerBackpack = []
    droppedPowerUpPosition = eventPlayer.getPosition() + offsetUpQuarterConst if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition())
    supplyPowerUpIdList = supplyPowerUpIdList.concat(droppedPowerUpIds)
    # Spread the items so each can be aimed at independently.
    supplyPowerUpPositionList = supplyPowerUpPositionList.concat(droppedPowerUpIds.map(lambda _, index: droppedPowerUpPosition + index * 0.75 * Vector.RIGHT))
    finishPowerUpDrop()


def finishPowerUpDrop():
    @Name "finishPowerUpDrop"

    eventPlayer.powerUpItemId = PowerUpItem.NONE
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
