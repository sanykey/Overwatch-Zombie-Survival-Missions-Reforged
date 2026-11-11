#!mainFile "../main.opy"


rule "CROWD CONTROL STATUS":
    @Event eachPlayer
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.STUNNED)) == true

    eventPlayer.isCrowdControlled = true
    waitUntil(not ruleCondition, Math.INFINITY)
    eventPlayer.isCrowdControlled = false


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
        if random.randint(1, 100) <= 7:
            # One item roll per credited kill or damage participation. No waits or
            # calls while this scratch value is live; reserves never activate here.
            #!define scavengerLootItemId tmp0
            scavengerLootItemId = random.randint(1, 13)
            # An empty active slot takes the loot directly; only overflow goes to the backpack.
            if eventPlayer.powerUpItemId == 0:
                eventPlayer.powerUpItemId = scavengerLootItemId
                smallMessage(eventPlayer, "Scavenger: powerup equipped")
            elif len(eventPlayer.augmentScavengerBackpack) < 2:
                eventPlayer.augmentScavengerBackpack.append(scavengerLootItemId)
                smallMessage(eventPlayer, "Scavenger: powerup added to backpack")
            else:
                supplyPowerUpIdList.append(scavengerLootItemId)
                supplyPowerUpPositionList.append(nearestWalkablePosition(victim.getPosition()) + offsetUpQuarterConst)


rule "PLAYER DIED":
    @Event playerDied
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
        eventPlayer.enhancementBoltBurst = 0
    elif eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        eventPlayer.enhancementBulkStacks = floor(eventPlayer.enhancementBulkStacks / 2)
        applyBulkingSeasonStats()

    if eventPlayer.augmentId == Augment.DOUBLE_JUMP:
        eventPlayer.augmentJumpLastPressedAt = 0


rule "PLAYER DEALT HEALING":
    @Event playerDealtHealing
    @Team 1

    if eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR:
        if eventPlayer.isInfected:
            eventPlayer.infectionLevel -= eventHealing / 500
            eventPlayer.enhancementPlagueCureTotal += eventHealing / 500
        if healee.infectionLevel >= 1 and healee.enhancementId != Enhancement.ZOMBIE_HYBRID:
            healee.infectionLevel -= eventHealing / 275
            eventPlayer.enhancementPlagueCureTotal += eventHealing / 275
            if healee.infectionLevel < 1:
                healee.infectionLevel -= 0.5
                eventPlayer.enhancementPlagueCureTotal += 0.5
                playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
                smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))


rule "PLAYER DEALT DAMAGE":
    @Event playerDealtDamage
    @Team 1

    if eventPlayer.enhancementId == Enhancement.BRAIN_KILLER:
        if eventWasCriticalHit == true:
            #Critical hits deal 50% more damage, 20% if vicitm is a boss
            damage(victim, eventPlayer, eventDamage * (0.2 if victim in bossStateList else 0.6))
            playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
    elif eventAbility != null:
        if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
            if victim != eventPlayer and distance(attacker, victim) < 15:
                victim.setStatusEffect(attacker, Status.BURNING, 3)
                attacker.enhancementPyroHitList.append(victim)
        elif eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
            if isGameplayActive and victim.getTeam() == Team.2 and eventDamage > 0:
                # One fixed primary-hit credit, even when no chain targets exist.
                # Scripted chain/discharge damage has no Event Ability and cannot recurse.
                eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + 0.3)
                # Synchronous scratch, consumed before this event ends: no waits, async
                # calls or reevaluated effects. No persistent lightning IDs need cleanup.
                #!define boltChainTargets tmp0
                #!define boltHealthBefore tmp1
                #!define boltIndex tmp2
                # Leave warning-phase Smolders untouched by both chains and the charged discharge.
                boltChainTargets = random.shuffle(getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive() and (player.getHero() != Hero.WINSTON or player.botSmolderState != 1)).exclude(victim)).slice(0, 2)
                for boltIndex in range(len(boltChainTargets)):
                    boltHealthBefore = boltChainTargets[boltIndex].getHealth()
                    damage(boltChainTargets[boltIndex], eventPlayer, min(15, eventDamage * 0.25))
                    # Bank only actual health removed, including immunity/reduction/overkill.
                    eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + max(0, boltHealthBefore - boltChainTargets[boltIndex].getHealth()))
                    # Per-target gate shared by every attacker. Suppressed flashes never
                    # extend the deadline or throttle damage/energy; no polling or waits.
                    if getTotalTimeElapsed() >= boltChainTargets[boltIndex].botBoltFlashReadyAt:
                        boltChainTargets[boltIndex].botBoltFlashReadyAt = getTotalTimeElapsed() + 0.5
                        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[boltIndex], 0.375)
                if eventPlayer.enhancementBoltBurst == -1:
                    # Consume before applying damage. The chain list is no longer live;
                    # reuse its synchronous slot for this one-shot area discharge.
                    #!define boltDischargeTargets tmp0
                    eventPlayer.enhancementBoltBurst = 0
                    boltDischargeTargets = getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive() and (player.getHero() != Hero.WINSTON or player.botSmolderState != 1))
                    boltDischargeTargets.setStatusEffect(eventPlayer, Status.STUNNED, 2)
                    damage(boltDischargeTargets, eventPlayer, 60)
        elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
            if eventPlayer.enhancementCapacitorCharge > 0 and eventDamage > 0 and victim != eventPlayer:
                if eventPlayer.enhancementCapacitorDeadline == 0:
                    eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
                if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                    damage(victim, eventPlayer, eventPlayer.enhancementCapacitorCharge)

    # Augments: Leech includes damage from the hero, primary enhancement and
    # scripted powerups. The Double Jump airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.LEECH:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * 0.15)
