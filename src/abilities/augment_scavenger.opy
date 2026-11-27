#!mainFile "../../main.opy"

macro initializeScavengerAugment():
    eventPlayer.augmentScavengerBackpack = []


macro scavengerCrouchHeld():
    eventPlayer.augmentId == Augment.SCAVENGER and eventPlayer.isHoldingButton(Button.CROUCH)


macro scavengerBackpackFull():
    len(eventPlayer.augmentScavengerBackpack) >= SCAVENGER_BACKPACK_CAPACITY


macro stashScavengerPowerUp(itemId):
    eventPlayer.augmentScavengerBackpack.append(itemId)


macro cycleScavengerBackpack():
    # Crouch + Interact with nothing to store swaps the first reserve with the
    # active slot. Reuses the aimed-items scratch from PLAYER INTERACT.
    #!define scavCycleItemId tmp0
    scavCycleItemId = eventPlayer.powerUpItemId
    if len(eventPlayer.augmentScavengerBackpack) > 0:
        eventPlayer.powerUpItemId = eventPlayer.augmentScavengerBackpack[0]
        del eventPlayer.augmentScavengerBackpack[0]
        if scavCycleItemId != PowerUpItem.NONE:
            eventPlayer.augmentScavengerBackpack.append(scavCycleItemId)
    elif scavCycleItemId != PowerUpItem.NONE:
        eventPlayer.augmentScavengerBackpack.append(scavCycleItemId)
        eventPlayer.powerUpItemId = PowerUpItem.NONE


macro appendDroppedScavengerPowerUps(carriedIds):
    if eventPlayer.augmentId == Augment.SCAVENGER:
        carriedIds = carriedIds.concat(eventPlayer.augmentScavengerBackpack)
        eventPlayer.augmentScavengerBackpack = []


macro collectScavengerLoot(collector):
    # BOT DIES owns tmp0-2 during the shared Engineer/Scavenger scan.
    #!define scavengerLootItemId tmp3
    if collector.augmentId == Augment.SCAVENGER:
        if random.randint(1, 100) <= SCAVENGER_LOOT_CHANCE:
            scavengerLootItemId = random.randint(PowerUpItem.CURE, PowerUpItem.STUN)
            # An empty active slot takes the loot; reserves never activate here.
            if collector.powerUpItemId == PowerUpItem.NONE:
                collector.powerUpItemId = scavengerLootItemId
                smallMessage(collector, "Scavenger: powerup equipped")
            elif len(collector.augmentScavengerBackpack) < SCAVENGER_BACKPACK_CAPACITY:
                collector.augmentScavengerBackpack.append(scavengerLootItemId)
                smallMessage(collector, "Scavenger: powerup added to backpack")
            else:
                supplyPowerUpIdList.append(scavengerLootItemId)
                supplyPowerUpPositionList.append(nearestWalkablePosition(victim.getPosition()) + offsetUpQuarterConst)
