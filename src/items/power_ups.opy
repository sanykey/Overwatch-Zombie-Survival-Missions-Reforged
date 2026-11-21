#!mainFile "../../main.opy"
subroutine useLivingProjectile

subroutine playAquaPowerUpSound

subroutine powerUpUsage
subroutine playerForceField
subroutine airStrike
subroutine instantRevive
subroutine healBeacon
subroutine deploySentryTurret
subroutine sentryTurret
subroutine cloakingDevice
subroutine superNano
subroutine ultimateCharger
subroutine stun

# Render the shared expiry without writing a countdown on every worker tick.
macro powerUpSecondsRemaining(deadline):
    max(0, ceil(deadline - getTotalTimeElapsed()))


rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false

    if not isGameplayActive:
        return

    # Zombie and item interactions may share the same press.
    if eventPlayer.enhancementId == Enhancement.WRESTLER:
        useLivingProjectile()

    # Query aimed items only on interaction; reuse this scratch slot for the chosen
    # position below after sorting. No reader retains the candidate array across waits.
    #!define aimedPowerUpPositions tmp0
    aimedPowerUpPositions = supplyPowerUpPositionList.filter(lambda x: distance(x, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x)) < 0.5 and distance(eventPlayer, x) <= 6)

    if canOpenSupplyDrop():
        openSupplyDrop()

    elif len(aimedPowerUpPositions) > 0 and not (eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH) and len(eventPlayer.augmentScavengerBackpack) >= SCAVENGER_BACKPACK_CAPACITY):
        # Commit pickup and all four aligned ground lists without waits: another
        # player's pickup or a Reload drop must never observe a half-finished trade.
        # Synchronous scratch; no subroutine calls or reevaluated captures here.
        #!define pickedPowerUpPosition tmp0
        #!define pickedPowerUpIndex tmp1
        #!define tradedPowerUpItemId tmp2
        pickedPowerUpPosition = (sorted(aimedPowerUpPositions, lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x))))[0]
        pickedPowerUpIndex = supplyPowerUpPositionList.index(pickedPowerUpPosition)
        tradedPowerUpItemId = eventPlayer.powerUpItemId
        if eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.augmentScavengerBackpack.append(supplyPowerUpIdList[pickedPowerUpIndex])
            tradedPowerUpItemId = PowerUpItem.NONE
        else:
            eventPlayer.powerUpItemId = supplyPowerUpIdList[pickedPowerUpIndex]
        destroyEffect(supplyPowerUpEffectIdList[pickedPowerUpIndex])
        destroyInWorldText(supplyPowerUpTextIdList[pickedPowerUpIndex])
        del supplyPowerUpIdList[pickedPowerUpIndex]
        del supplyPowerUpPositionList[pickedPowerUpIndex]
        del supplyPowerUpEffectIdList[pickedPowerUpIndex]
        del supplyPowerUpTextIdList[pickedPowerUpIndex]
        if tradedPowerUpItemId != PowerUpItem.NONE:
            supplyPowerUpIdList.append(tradedPowerUpItemId)
            supplyPowerUpPositionList.append(pickedPowerUpPosition)

    # Scavenger backpack cycling: Crouch + Interact with nothing to store swaps
    # the first reserve with the active slot; an empty backpack stows the active
    # item, an empty slot pulls the first reserve. Reuses the aimed-items scratch.
    #!define scavCycleItemId tmp0
    elif eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH):
        scavCycleItemId = eventPlayer.powerUpItemId
        if len(eventPlayer.augmentScavengerBackpack) > 0:
            eventPlayer.powerUpItemId = eventPlayer.augmentScavengerBackpack[0]
            del eventPlayer.augmentScavengerBackpack[0]
            if scavCycleItemId != PowerUpItem.NONE:
                eventPlayer.augmentScavengerBackpack.append(scavCycleItemId)
        elif scavCycleItemId != PowerUpItem.NONE:
            eventPlayer.augmentScavengerBackpack.append(scavCycleItemId)
            eventPlayer.powerUpItemId = PowerUpItem.NONE

    elif eventPlayer.powerUpItemId:
        # Any Crouch during the hold cancels use, regardless of abilities. Ending
        # this invocation on interruption consumes the press even after Crouch is
        # released; no latch variable or polling loop is needed.
        waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) or not ruleCondition, 0.25)
        if not ruleCondition:
            return
        # Gameplay is guarded in Actions, so recheck it after the wait as well.
        if isGameplayActive and not eventPlayer.isHoldingButton(Button.CROUCH):
            powerUpUsage()


#!include "powerup_cure.opy"
#!include "powerup_revive.opy"
#!include "powerup_force_field.opy"
#!include "powerup_no_cooldowns.opy"
#!include "powerup_air_strike.opy"
#!include "powerup_healing_beacon.opy"
#!include "powerup_sentry_turret.opy"
#!include "powerup_cloaking_device.opy"
#!include "powerup_super_nano.opy"
#!include "powerup_jetpack.opy"
#!include "powerup_ultimate_charger.opy"
#!include "powerup_stun.opy"


def powerUpUsage():
    @Name "powerUpUsage"

    if eventPlayer.powerUpItemId in eventPlayer.activePowerUpIds:
        smallMessage(eventPlayer, "This power-up is already active")
        return

    switch eventPlayer.powerUpItemId:
        case PowerUpItem.CURE:
            useCurePowerUp()
            break
        case PowerUpItem.REVIVE:
            useRevivePowerUp()
            break
        case PowerUpItem.FORCE_FIELD:
            useForceFieldPowerUp()
            break
        case PowerUpItem.NO_COOLDOWNS:
            useNoCooldownsPowerUp()
            break
        case PowerUpItem.AIR_STRIKE:
            useAirStrikePowerUp()
            break
        case PowerUpItem.HEALING_BEACON:
            useHealingBeaconPowerUp()
            break
        case PowerUpItem.SENTRY_TURRET:
            deploySentryTurret()
            break
        case PowerUpItem.CLOAKING_DEVICE:
            activateCloakingDevice()
            break
        case PowerUpItem.SUPER_NANO:
            activateSuperNano()
            break
        case PowerUpItem.JETPACK:
            useJetpackPowerUp()
            break
        case PowerUpItem.ULTIMATE_CHARGER:
            useUltimateChargerPowerUp()
            break
        case PowerUpItem.STUN:
            useStunPowerUp()
            break
    if DEBUG_ENABLE_INSPECTOR:
        logToInspector(f"[powerup] {eventPlayer} activated ID {eventPlayer.powerUpItemId}")
    eventPlayer.powerUpItemId = PowerUpItem.NONE


def playAquaPowerUpSound():
    @Name "playAquaPowerUpSound"

    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)


subroutine finishPowerUpDrop
subroutine dropCarriedPowerUps


macro powerUpAssignmentMacro():
    # Names and colors follow item IDs. Effect and text positions have separate indices.
    # Item type ID, not an effect/text handle; refresh and consume it synchronously on each pass.
    # Only visibility reevaluates, so neither the initial color nor the label retains a scratch dependency.
    #!define groundPowerUpItemId tmp0
    groundPowerUpItemId = supplyPowerUpIdList[len(supplyPowerUpEffectIdList)]
    if groundPowerUpItemId >= PowerUpItem.CURE and groundPowerUpItemId <= PowerUpItem.STUN:
        createEffect(getAllPlayers(), Effect.ORB, powerUpColorListConst[groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpEffectIdList)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), ["CURE", "Revive", "Force Field", "No Cooldowns", "Air Strike", "Beacon of Healing", "Sentry Turret", "Cloaking Device", "Super Nano", "Jetpack", "Ultimate Charger", "Stun"][groundPowerUpItemId - 1], supplyPowerUpPositionList[len(supplyPowerUpTextIdList)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)


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

    # Show the Interact prompt on the aimed ground powerup.
    createInWorldText(localPlayer if supplyPowerUpPositionList.any(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer, x) <= 6) else null, "[{0}]".format(inputBindingString(Button.INTERACT)), offsetUpHalfConst + ((sorted(supplyPowerUpPositionList.filter(lambda x: distance(x, localPlayer.getEyePosition() + localPlayer.getFacingDirection() * distance(localPlayer.getEyePosition(), x)) < 0.5 and distance(localPlayer, x) <= 6), lambda x: angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), x))))[0]), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN)
    
    # One row per item ID. Capture the index and the resolved color.
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
                    "to stop dmg over time and cure infection or vaccinate",
                    "to revive them",
                    "to place a force field",
                    "to get fast cooldowns",
                    "to call in an air strike",
                    "to place a healing beacon and gain bonus healing",
                    "to place a sentry turret",
                    "to become invisible to enemies",
                    "to increase your dmg and speed",
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
