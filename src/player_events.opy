#!mainFile "../main.opy"


rule "PLAYER DEALT FINAL BLOW":
    @Event playerDealtFinalBlow
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE:
        if eventPlayer.enhancementBattleResetCharges < 2:
            eventPlayer.enhancementBattleResetCharges += 1

    if currentObjectiveType != ObjectiveType.KILL_ZONE:
        return
    if playerTargetList.concat(victim).any(lambda x: distance(x, killZoneCenter) < objectiveRad) == true:
        if distance(eventPlayer, killZoneCenter) < objectiveRad or distance(victim, killZoneCenter) < objectiveRad:
            victim.botRespawnDelay = 2
            killZoneEliminationScore += ceil(victim.botBaseHealth / 280)
            if killZoneEliminationScore >= ELIMINATIONS_NEEDED_PER_OBJECTIVE:
                isObjectiveComplete = true
                #Give all bots a long respawn time
                getPlayers(Team.2).botRespawnDelay = 12
                botSpawnTimeList = botSpawnTimeList.map(lambda _: 12)
        #Adjust Kill Zone Positions
        killZoneCenter += 0.5 * directionTowards(killZoneCenter, victim)


rule "PLAYER EARNED ELIMINATION":
    @Event playerEarnedElimination
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        # One credit for a kill or damage participation; healing/buff assists do not count.
        eventPlayer.enhancementBulkStacks += 1
        applyBulkingSeasonStats()

    if eventPlayer.augmentId == Augment.SCAVENGER:
        if random.randint(1, 20) == 1:
            # One item roll per credited kill or damage participation. No waits or
            # calls while this scratch value is live; reserves never activate here.
            #!define scavengerLootItemId tmp0
            scavengerLootItemId = random.randint(1, 13)
            if len(eventPlayer.augmentScavengerBackpack) < 2:
                eventPlayer.augmentScavengerBackpack.append(scavengerLootItemId)
                smallMessage(eventPlayer, "Scavenger: powerup added to backpack")
            else:
                supplyPowerUpIdList.append(scavengerLootItemId)
                supplyPowerUpPositionList.append(nearestWalkablePosition(victim.getPosition()) + offsetUpQuarterConst)
