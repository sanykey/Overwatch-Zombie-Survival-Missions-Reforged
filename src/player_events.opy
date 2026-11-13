#!mainFile "../main.opy"

def applyHitEnhancements():
    @Name "applyHitEnhancements"

    # Shared synchronous hit inputs: tmp3 is the victim, tmp2 is actual damage.
    # Native callers supply eventDamage; the scripted macro supplies health lost.
    # No waits/async calls; tmp0/tmp1 (Long Reach targets/damage) survive.
    # Only Bolt consumes tmp2/tmp3 for chain damage/targets; its two attacker-owned
    # enhancement slots remain independent of every Augment. Secondary Damage is
    # direct, without Event Ability, and cannot reenter this handler.
    if enhancementHitDamage <= 0:
        return
    if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
        if enhancementHitVictim != eventPlayer and distance(eventPlayer, enhancementHitVictim) < 15:
            enhancementHitVictim.setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementPyroHitList.append(enhancementHitVictim)
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        if eventPlayer.enhancementCapacitorCharge > 0 and enhancementHitVictim != eventPlayer:
            if eventPlayer.enhancementCapacitorDeadline == 0:
                eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
            if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                damage(enhancementHitVictim, eventPlayer, eventPlayer.enhancementCapacitorCharge)
    elif eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
        #!define boltChainDamage tmp2
        boltChainDamage = min(15, enhancementHitDamage * 0.25)
        #!define boltChainTargets tmp3
        eventPlayer.enhancementBoltVictim = enhancementHitVictim
        eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + 0.3)
        # Leave warning-phase Smolders untouched. Consume at most two list
        # entries instead of keeping a third enhancement slot for an index.
        boltChainTargets = random.shuffle(getPlayersInRadius(eventPlayer.enhancementBoltVictim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive() and (player.getHero() != Hero.WINSTON or player.botSmolderState != 1)).exclude(eventPlayer.enhancementBoltVictim)).slice(0, 2)
        while boltChainTargets != []:
            # Per-zombie deadline merges near-simultaneous splash hit events.
            # Keep it below a 0.05s rapid-fire interval; rejected chains do not
            # extend the deadline or earn damage energy. No polling or waits.
            if getTotalTimeElapsed() >= boltChainTargets[0].botBoltDamageReadyAt:
                boltChainTargets[0].botBoltDamageReadyAt = getTotalTimeElapsed() + 0.032
                eventPlayer.enhancementBoltHealthBefore = boltChainTargets[0].getHealth()
                # Direct Damage has no Event Ability; never call the on-hit macro
                # for chains or discharge, so neither can recurse or earn hit credit.
                damage(boltChainTargets[0], eventPlayer, boltChainDamage)
                eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + max(0, eventPlayer.enhancementBoltHealthBefore - boltChainTargets[0].getHealth()))
                # Independent visual throttle; primary hit credit is unchanged.
                if getTotalTimeElapsed() >= boltChainTargets[0].botBoltFlashReadyAt:
                    boltChainTargets[0].botBoltFlashReadyAt = getTotalTimeElapsed() + 0.5
                    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[0], 0.375)
            del boltChainTargets[0]
        if eventPlayer.enhancementBoltBurst == -1:
            # Consume before damage. The chain list is dead; reuse its slot.
            eventPlayer.enhancementBoltBurst = 0
            boltChainTargets = getPlayersInRadius(eventPlayer.enhancementBoltVictim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive() and (player.getHero() != Hero.WINSTON or player.botSmolderState != 1))
            boltChainTargets.setStatusEffect(eventPlayer, Status.STUNNED, 2)
            damage(boltChainTargets, eventPlayer, 60)


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
            scavengerLootItemId = random.randint(PowerUpItem.CURE, PowerUpItem.STUN)
            # An empty active slot takes the loot directly; only overflow goes to the backpack.
            if eventPlayer.powerUpItemId == PowerUpItem.NONE:
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
    elif eventPlayer.enhancementId == Enhancement.ENGINEER and eventPlayer.enhancementScrapBeamEntity != null:
        # Scrap itself survives death; only the transfer beam is torn down.
        destroyEffect(eventPlayer.enhancementScrapBeamEntity)
        eventPlayer.enhancementScrapBeamEntity = null

    if eventPlayer.augmentId == Augment.HIGHRISE:
        eventPlayer.augmentJumpLastPressedAt = 0
    if eventPlayer.augmentId == Augment.DASH:
        # A death inside the resist window must not carry the 0% damage intake
        # or the knockback immunity into the next life before the deadline passes.
        if eventPlayer.augmentDashSmokeEntity != null:
            destroyEffect(eventPlayer.augmentDashSmokeEntity)
            eventPlayer.augmentDashSmokeEntity = null
            eventPlayer.setKnockbackReceived(100)
    # Death ends the ultimate resist with the ultimate itself, and Super Nano
    # cleans up on its own thread (~1.25s, always before any respawn), so the
    # recompute restores the normal intake for the next life.
    applyDamageReceivedModifier()
    # Health pools vanish with death, so any player's scrap-armor stacks must
    # go with them, whatever their enhancement or augment.
    if eventPlayer.scrapArmorAmount > 0:
        eventPlayer.scrapArmorAmount = 0


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
    @Condition victim != attacker
    @Condition eventDamage > 0

    if eventPlayer.enhancementId == Enhancement.BRAIN_KILLER:
        if eventWasCriticalHit == true:
            #Critical hits deal 50% more damage, 20% if vicitm is a boss
            damage(victim, eventPlayer, eventDamage * (0.2 if victim in bossStateList else 0.6))
            playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
    elif eventAbility != null:
        enhancementHitDamage = eventDamage
        enhancementHitVictim = victim
        applyHitEnhancements()

    # Augments: Leech includes damage from the hero, primary enhancement and
    # scripted powerups. The HIGHRISE airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.LEECH:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * 0.15)
