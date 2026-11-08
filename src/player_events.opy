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
        eventPlayer.augmentJumpBonusState = null


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
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        # Event Ability can be Null for hero self-healing (including Inspire).
        # Credit actual healing without filtering it by ability attribution.
        eventPlayer.enhancementCapacitorEnergy += eventHealing


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
                # Synchronous scratch, consumed before this event ends: no waits, async
                # calls or reevaluated effects. No persistent lightning IDs need cleanup.
                #!define boltChainTargets tmp0
                #!define boltHealthBefore tmp1
                #!define boltIndex tmp2
                boltChainTargets = random.shuffle(getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive()).exclude(victim)).slice(0, 2)
                for boltIndex in range(len(boltChainTargets)):
                    boltHealthBefore = boltChainTargets[boltIndex].getHealth()
                    damage(boltChainTargets[boltIndex], eventPlayer, min(15, eventDamage * 0.25))
                    # Bank only actual health removed, including immunity/reduction/overkill.
                    eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + max(0, boltHealthBefore - boltChainTargets[boltIndex].getHealth()))
                    # Per-target gate shared by every attacker. Suppressed flashes never
                    # extend the deadline or throttle damage/energy; no polling or waits.
                    if getTotalTimeElapsed() >= boltChainTargets[boltIndex].botBoltFlashReadyAt:
                        boltChainTargets[boltIndex].botBoltFlashReadyAt = getTotalTimeElapsed() + 0.2
                        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[boltIndex], 0.75)
                if eventPlayer.enhancementBoltBurst == -1:
                    # Consume before applying damage. The chain list is no longer live;
                    # reuse its synchronous slot for this one-shot area discharge.
                    #!define boltDischargeTargets tmp0
                    eventPlayer.enhancementBoltBurst = 0
                    boltDischargeTargets = getPlayersInRadius(victim, 5, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive())
                    boltDischargeTargets.setStatusEffect(eventPlayer, Status.STUNNED, 2)
                    damage(boltDischargeTargets, eventPlayer, 60)
        elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
            if eventPlayer.enhancementCapacitorCharge > 0 and eventDamage > 0 and victim != eventPlayer:
                if eventPlayer.enhancementCapacitorDeadline == 0:
                    eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
                if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                    damage(victim, eventPlayer, eventPlayer.enhancementCapacitorCharge)

    # Independent Augment: retain its bonus alongside any primary enhancement.
    if eventPlayer.augmentId == Augment.DOUBLE_JUMP:
        if eventPlayer.isAlive() == true and eventPlayer.augmentJumpBonusState != null and eventPlayer.getHero() == eventPlayer.augmentJumpBonusState[1] and getTotalTimeElapsed() < abs(eventPlayer.augmentJumpBonusState[0]) and eventDamage >= 30 and victim != eventPlayer:
            # Match Brain Killer's event-damage bonus pattern. Only hits of 30+ spend it;
            # consume before Damage so supplemental damage cannot recurse.
            eventPlayer.augmentJumpBonusState = null
            damage(victim, eventPlayer, eventDamage * 0.5)
    elif eventPlayer.augmentId == Augment.LEECH:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * 0.15)
