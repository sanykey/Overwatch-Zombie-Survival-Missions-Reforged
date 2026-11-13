#!mainFile "../main.opy"

def enqueuePyroBurn():
    @Name "enqueuePyroBurn"

    # One shared Pyrotechnic enqueue for native and scripted hits. Inputs:
    # enhancementHitVictim (tmp3) and enhancementHitHealthBefore (tmp2), the victim's health
    # before the scripted hit; null skips the health gate for native-event hits,
    # which are always real. Script hits have no Event Ability, so enqueueing
    # here cannot recurse through PLAYER DEALT DAMAGE. The 15m range is enforced
    # for every caller; current scripted call sites are all well inside it.
    # Both slots are consumed synchronously; no scratch value is written.
    if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:
        if enhancementHitVictim != eventPlayer and distance(eventPlayer, enhancementHitVictim) < 15 and (enhancementHitHealthBefore == null or enhancementHitVictim.getHealth() < enhancementHitHealthBefore):
            enhancementHitVictim.setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementPyroHitList.append(enhancementHitVictim)


def applyOvercharge():
    @Name "applyOvercharge"

    # Shares the original-hit snapshot with enqueuePyroBurn. Native callers
    # supply null only for positive event damage; scripted callers require
    # actual health loss. No waits or scratch writes; bonus Damage has no
    # Event Ability and cannot reenter native on-hit enhancement handling.
    if eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        if eventPlayer.enhancementCapacitorCharge > 0 and enhancementHitVictim != eventPlayer and (enhancementHitHealthBefore == null or enhancementHitVictim.getHealth() < enhancementHitHealthBefore):
            if eventPlayer.enhancementCapacitorDeadline == 0:
                eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
            if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                damage(enhancementHitVictim, eventPlayer, eventPlayer.enhancementCapacitorCharge)


def applyBoltStrike():
    @Name "applyBoltStrike"

    # Native callers supply null + boltNativeDamage (tmp0); scripted callers
    # supply health before the primary hit. Only actual health loss triggers.
    # No waits/async calls: tmp0/tmp1 (Long Reach list/damage) survive. The hit
    # inputs are dead after this check/calculation: reuse tmp2 for chain damage
    # and tmp3 for chain/discharge targets after saving the center on the attacker.
    # The two attacker-owned enhancement slots are otherwise unused by Bolt.
    if eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
        if enhancementHitVictim.getTeam() == Team.2 and (enhancementHitHealthBefore == null or enhancementHitVictim.getHealth() < enhancementHitHealthBefore):
            #!define boltChainDamage tmp2
            boltChainDamage = min(15, (boltNativeDamage if enhancementHitHealthBefore == null else enhancementHitHealthBefore - enhancementHitVictim.getHealth()) * 0.25)
            #!define boltChainTargets tmp3
            eventPlayer.enhancementBoltVictim = enhancementHitVictim
            eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + 0.3)
            # Leave warning-phase Smolders untouched. Consume at most two list
            # entries instead of keeping a third enhancement slot for an index.
            boltChainTargets = random.shuffle(getPlayersInRadius(eventPlayer.enhancementBoltVictim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive() and (player.getHero() != Hero.WINSTON or player.botSmolderState != 1)).exclude(eventPlayer.enhancementBoltVictim)).slice(0, 2)
            while boltChainTargets != []:
                eventPlayer.enhancementBoltHealthBefore = boltChainTargets[0].getHealth()
                # Direct Damage has no Event Ability; never call the on-hit macro
                # for chains or discharge, so neither can recurse or earn hit credit.
                damage(boltChainTargets[0], eventPlayer, boltChainDamage)
                eventPlayer.enhancementBoltEnergy = min(350, eventPlayer.enhancementBoltEnergy + max(0, eventPlayer.enhancementBoltHealthBefore - boltChainTargets[0].getHealth()))
                # Visual throttle is per target and never throttles damage/energy.
                if getTotalTimeElapsed() >= boltChainTargets[0].botBoltFlashReadyAt:
                    boltChainTargets[0].botBoltFlashReadyAt = getTotalTimeElapsed() + 0.5
                    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[0], 0.375)
                boltChainTargets = boltChainTargets.slice(1)
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

    if eventPlayer.augmentId == Augment.DOUBLE_JUMP:
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

    if eventAbility != null:
        enhancementHitHealthBefore = null
        enhancementHitVictim = victim
        if eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
            # Native-only input; enqueuePyroBurn returns without scratch writes
            # for Bolt. applyBoltStrike consumes it synchronously, before Damage.
            boltNativeDamage = eventDamage
        enqueuePyroBurn()
        applyBoltStrike()
        applyOvercharge()

    # Augments: Leech includes damage from the hero, primary enhancement and
    # scripted powerups. The Double Jump airborne bonus is a Set Damage Dealt
    # multiplier, so it stacks with every source already applied above.
    if eventPlayer.augmentId == Augment.LEECH:
        # Include damage from the hero, primary enhancement and scripted powerups.
        heal(eventPlayer, eventPlayer, eventDamage * 0.15)
