#!mainFile "../main.opy"
subroutine resetBattleAbilityCharge

subroutine checkEnhancementPlacement
subroutine startPupDefaultChase
subroutine applyBulkingSeasonStats

#!define DEAD_WEIGHT_RANGE 4
#!define DEAD_WEIGHT_DURATION 5
#!define DEAD_WEIGHT_KNOCKDOWN_DURATION 6
#!define DEAD_WEIGHT_THROW_SPEED 12.5
#!define DEAD_WEIGHT_THROW_DAMAGE 50
#!define DEAD_WEIGHT_DAMAGE_DELAY 0.75

#!define overchargeAssistTotal(player) (player.getStatistic(Stat.OFFENSIVE_ASSISTS) + player.getStatistic(Stat.DEFENSIVE_ASSISTS))

rule "ZOMBIE HYBRID":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementHybridCooldown <= 0
    @Condition eventPlayer.infectionLevel >= 1
    
    explosionSequence()
    stopDamageOverTime(eventPlayer.infectionDamageOverTimeId)
    eventPlayer.infectionLevel = 0
    eventPlayer.enhancementHybridCooldown = 20
    while eventPlayer.enhancementHybridCooldown > 0:
        wait(1)
        eventPlayer.enhancementHybridCooldown += -1


# Synchronous helper output; consume immediately before any wait or asynchronous work.
#!define isEnhancementPlacementInvalid tmp0

rule "BRAIN KILLER EXTRA DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BRAIN_KILLER
    @Condition eventWasCriticalHit == true
    
    #Critical hits deal 50% more damage, 20% if vicitm is a boss
    damage(victim, eventPlayer, eventDamage * (0.2 if victim in bossStateList else 0.6))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, rgb(100, 14, 14), victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)


rule "PYROTECHNIC SETS ENEMIES ON FIRE":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker.enhancementId == Enhancement.PYROTECHNIC
    @Condition victim != eventPlayer
    @Condition eventAbility != null
    @Condition distance(attacker, victim) < 15
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    attacker.enhancementPyroHitList.append(victim)


rule "PYROTECHNIC APPLIES DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PYROTECHNIC
    @Condition eventPlayer.enhancementPyroHitList != []
    
    while eventPlayer.enhancementPyroHitList != []:
        # pyroBurnTarget: zombie to burn; consumed within this iteration before the cooldown wait.
        #!define pyroBurnTarget tmp0
        pyroBurnTarget = eventPlayer.enhancementPyroHitList[0]
        if pyroBurnTarget.isAlive():
            # pyroBurnDamagePerSecond: damage per second based on hits in the last cycle, used immediately.
            #!define pyroBurnDamagePerSecond tmp1
            pyroBurnDamagePerSecond = min(4 * (len(eventPlayer.enhancementPyroHitList.filter(lambda x: x == pyroBurnTarget))), 30)
            if pyroBurnTarget in bossStateList:
                # pyroBurnDamagePerSecond: halve this zombie's damage if it is a boss.
                pyroBurnDamagePerSecond /= 2
            pyroBurnTarget.startDamageOverTime(eventPlayer, 3, pyroBurnDamagePerSecond)
        eventPlayer.enhancementPyroHitList.remove(pyroBurnTarget)
    wait(0.5)
    if ruleCondition:
        loop()


# BORN TO BATTLE PLAYER EARNS ELIMINATION moved to "PLAYER DEALT FINAL BLOW" in player_events.opy.


rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementBattleResetCharges > 0
    @Condition [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].any(lambda x: eventPlayer.isHoldingButton(x)) == true
    
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.enhancementBattleAbilityButton = Button.SECONDARY_FIRE
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.enhancementBattleAbilityButton = Button.ABILITY_1
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.enhancementBattleAbilityButton = Button.ABILITY_2
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.enhancementBattleAbilityButton = Button.CROUCH
    elif eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.enhancementBattleAbilityButton = Button.JUMP
    #Temp rein fix ability 2
    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2:
        waitUntil(eventPlayer.isUsingAbility2(), 0.016)
        if not eventPlayer.isUsingAbility2():
            resetBattleAbilityCharge()
        return
    #Temp zarya fix ability 1
    if eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_1:
        waitUntil(eventPlayer.isUsingAbility1(), 0.016)
        if not eventPlayer.isUsingAbility1():
            resetBattleAbilityCharge()
        return
    if eventPlayer.getHero() == Hero.REAPER:
        goto lbl_0
    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton) + 1)
    lbl_0:
    #If the ability charge increased
    if eventPlayer.getAbilityCharge(eventPlayer.enhancementBattleAbilityButton):
        eventPlayer.enhancementBattleResetCharges -= 1
    #Else if ability is on cooldown
    elif eventPlayer.getAbilityCooldown(eventPlayer.enhancementBattleAbilityButton) > 0.5:
        eventPlayer.setAbilityCooldown(eventPlayer.enhancementBattleAbilityButton, 0)
        eventPlayer.enhancementBattleResetCharges -= 1


rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PLAGUE_DOCTOR
    
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


# BULKING SEASON EARNS STACKS moved to "PLAYER EARNED ELIMINATION" in player_events.opy.


rule "BULKING SEASON LOSES STACKS ON DEATH":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BULKING_SEASON

    eventPlayer.enhancementBulkStacks = floor(eventPlayer.enhancementBulkStacks / 2)
    applyBulkingSeasonStats()


def applyBulkingSeasonStats():
    @Name "applyBulkingSeasonStats"

    # Additive percentages from the native hero baseline; never compound live max health.
    eventPlayer.setMaxHealth(min(200, 100 + eventPlayer.enhancementBulkStacks * 0.5))
    eventPlayer.sizeScale = min(1.35, 1 + eventPlayer.enhancementBulkStacks * 0.005)
    applyCurrentSizeScale()


rule "BOLT STRIKE DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventAbility != null
    @Condition victim.getTeam() == Team.2
    @Condition eventDamage > 0

    # Keep eligibility in Actions, like Leech, to avoid adding its known UI-bug
    # pattern to Conditions. Scripted Damage has no Event Ability: no recursion.
    if isGameplayActive and eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
        # Synchronous scratch, consumed before this event ends: no waits, async
        # calls or reevaluated effects. No persistent lightning IDs need cleanup.
        #!define boltChainTargets tmp0
        #!define boltHealthBefore tmp1
        #!define boltIndex tmp2
        boltChainTargets = random.shuffle(getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive()).exclude(victim)).slice(0, 2)
        for boltIndex in range(len(boltChainTargets)):
            boltHealthBefore = boltChainTargets[boltIndex].getHealth()
            damage(boltChainTargets[boltIndex], eventPlayer, min(20, eventDamage * 0.25))
            # Bank only actual health removed, including immunity/reduction/overkill.
            eventPlayer.enhancementBoltEnergy = min(200, eventPlayer.enhancementBoltEnergy + max(0, boltHealthBefore - boltChainTargets[boltIndex].getHealth()))
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[boltIndex], 1.5)
        if eventPlayer.enhancementBoltBurst == -1:
            eventPlayer.enhancementBoltBurst = getTotalTimeElapsed() + 0.3
        if eventPlayer.enhancementBoltBurst > getTotalTimeElapsed():
            victim.setStatusEffect(eventPlayer, Status.STUNNED, 2)
            damage(victim, eventPlayer, 60)


rule "BOLT STRIKE ARMS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.BOLT_STRIKE
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementBoltEnergy >= 200
    @Condition eventPlayer.enhancementBoltBurst == 0

    eventPlayer.enhancementBoltEnergy = 0
    eventPlayer.enhancementBoltBurst = -1


rule "BOLT STRIKE CLEARS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BOLT_STRIKE
    @Condition eventPlayer.enhancementBoltBurst != 0
    @Condition (not isGameplayActive or not eventPlayer.isAlive() or eventPlayer.enhancementBoltBurst > 0 and getTotalTimeElapsed() >= eventPlayer.enhancementBoltBurst) == true

    # Death/game end cancels the burst; unspent energy stays in the bank.
    eventPlayer.enhancementBoltBurst = 0


rule "OVERCHARGE STORES HEALING":
    @Event playerDealtHealing
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE

    eventPlayer.enhancementCapacitorEnergy += eventHealing / 3


rule "OVERCHARGE STORES ASSISTS":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition overchargeAssistTotal(eventPlayer) != eventPlayer.enhancementCapacitorAssistSnapshot

    # No assist event exists. Only Overcharge players observe the two native counters.
    # Synchronous scratch: consumed before any wait/call/HUD reevaluation can reuse tmp0.
    #!define overchargeCurrentAssists tmp0
    overchargeCurrentAssists = overchargeAssistTotal(eventPlayer)
    eventPlayer.enhancementCapacitorEnergy += max(0, overchargeCurrentAssists - eventPlayer.enhancementCapacitorAssistSnapshot) * 10
    # Resync on a stat reset too, without subtracting energy or paying twice.
    eventPlayer.enhancementCapacitorAssistSnapshot = overchargeCurrentAssists


rule "OVERCHARGE ARMS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementCapacitorEnergy > 0
    @Condition eventPlayer.enhancementCapacitorCharge == 0

    # Transfer at most 100; retain the remainder in the uncapped bank.
    # Continued healing cannot change this burst's fixed damage.
    eventPlayer.enhancementCapacitorCharge = min(eventPlayer.enhancementCapacitorEnergy, 100)
    eventPlayer.enhancementCapacitorEnergy -= eventPlayer.enhancementCapacitorCharge


rule "OVERCHARGE CLEARS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.enhancementCapacitorCharge > 0
    @Condition (not isGameplayActive or not eventPlayer.isAlive() or eventPlayer.enhancementCapacitorDeadline > 0 and getTotalTimeElapsed() >= eventPlayer.enhancementCapacitorDeadline) == true

    eventPlayer.enhancementCapacitorCharge = 0
    eventPlayer.enhancementCapacitorDeadline = 0


rule "OVERCHARGE BONUS DAMAGE":
    @Event playerDealtDamage
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.enhancementCapacitorCharge > 0
    @Condition eventDamage > 0
    @Condition victim.getTeam() == Team.2
    # Workshop Damage has no Event Ability; never amplify this rule's own bonus.
    @Condition eventAbility != null

    if eventPlayer.enhancementCapacitorDeadline == 0:
        eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
    if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
        damage(victim, eventPlayer, eventPlayer.enhancementCapacitorCharge)


rule "CHARGE BATTERY":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementBatteryPlacementCooldown <= 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isDead(), Math.INFINITY)
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    eventPlayer.enhancementBatteryPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Charge Battery cooldown
    eventPlayer.enhancementBatteryPlacementCooldown = 20
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 50)
    smallMessage(eventPlayer, "  Battery placed!")
    eventPlayer.enhancementBatteryReuseCooldown = 0
    while eventPlayer.enhancementBatteryPlacementCooldown > 0:
        wait(1)
        eventPlayer.enhancementBatteryPlacementCooldown += -1


# Share eligibility between activation and selection; playerTargetList can briefly retain dead/unspawned players.
#!define isBatteryChargeEligible(player) player.hasSpawned() and player.isAlive() and player.getUltCharge() < 100 and distance(player, eventPlayer.enhancementBatteryPosition) < 1.5 * player.sizeScale

rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.CHARGE_BATTERY
    @Condition eventPlayer.enhancementBatteryPosition
    @Condition playerTargetList.any(lambda player: isBatteryChargeEligible(player)) == true
    
    # batteryChargeRecipient: survivor using the battery, to play feedback and grant ultimate charge before cooldown waits.
    #!define batteryChargeRecipient tmp0
    batteryChargeRecipient = (playerTargetList.filter(lambda player: isBatteryChargeEligible(player)))[0]
    # Recheck at action time: no feedback, charge or cooldown if eligibility changed since activation.
    if batteryChargeRecipient == null:
        return
    playEffect(batteryChargeRecipient, DynamicEffect.BUFF_IMPACT_SOUND, Color.YELLOW, batteryChargeRecipient, 50)
    playEffect(batteryChargeRecipient, DynamicEffect.GOOD_EXPLOSION, Color.GRAY, eventPlayer.enhancementBatteryPosition, 3)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, batteryChargeRecipient, 1)
    batteryChargeRecipient.setUltCharge(batteryChargeRecipient.getUltCharge() + 15)
    eventPlayer.enhancementBatteryReuseCooldown = eventPlayer.enhancementBatteryReuseDuration
    while eventPlayer.enhancementBatteryReuseCooldown > 0:
        wait(0.5)
        eventPlayer.enhancementBatteryReuseCooldown += -0.5
    if ruleCondition:
        loop()


def checkEnhancementPlacement():
    # Synchronous output only: no waits, asynchronous work or nested calls before the caller reads tmp0.
    # Keep the 31 m validation ray separate from each caller's 30 m placement ray and its player filters.
    # The caller must return on rejection; returning here alone would not cancel placement.
    isEnhancementPlacementInvalid = distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30 or eventPlayer.isDead()


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.enhancementIsHitchhiking and (not eventPlayer.hasSpawned() or not eventPlayer.enhancementHitchhikerCarrier.hasSpawned() or eventPlayer.isDead() or eventPlayer.enhancementHitchhikerCarrier.isDead() or not entityExists(eventPlayer.enhancementHitchhikerCarrier) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.enhancementHitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer, eventPlayer.enhancementHitchhikerCarrier) > 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale))) == true
    @Condition eventPlayer.getHero() != Hero.MEI
    
    if not eventPlayer.enhancementIsHitchhiking and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer, x) < 2 * x.sizeScale):
            #Select parent
            eventPlayer.enhancementHitchhikerCarrier = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.isCrowdControlled and distance(eventPlayer, x) < x.sizeScale * 2), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            # hitchhikerWorldAttachmentPosition: attachment position in world space, converted and captured before any wait.
            #!define hitchhikerWorldAttachmentPosition tmp0
            hitchhikerWorldAttachmentPosition = eventPlayer.enhancementHitchhikerCarrier.getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementHitchhikerCarrier, eventPlayer)), 0) * eventPlayer.enhancementHitchhikerCarrier.sizeScale + eventPlayer.enhancementHitchhikerCarrier.sizeScale * Vector.UP
            # hitchhikerLocalAttachmentOffset: convert the attachment position to the parent's local coordinates.
            #!define hitchhikerLocalAttachmentOffset tmp0
            hitchhikerLocalAttachmentOffset = localVector(hitchhikerWorldAttachmentPosition, eventPlayer.enhancementHitchhikerCarrier, Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if hitchhikerLocalAttachmentOffset.z > 0:
                # hitchhikerLocalAttachmentOffset: mirror a forward offset behind the parent.
                hitchhikerLocalAttachmentOffset *= vect(1, 1, -1)
            # hitchhikerLocalAttachmentOffset: raise the final local offset before capturing it in attachTo.
            hitchhikerLocalAttachmentOffset += Vector.UP
            eventPlayer.enhancementIsHitchhiking = true
            eventPlayer.attachTo(eventPlayer.enhancementHitchhikerCarrier, evalOnce(hitchhikerLocalAttachmentOffset))
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementHitchhikerCarrier.initialMaxHealth, true, false)
            eventPlayer.enhancementHitchhikerPassengerPoolId = getLastCreatedHealthPool()
            eventPlayer.enhancementHitchhikerCarrier.enhancementHitchhikerPassenger = eventPlayer
    else:
        if entityExists(eventPlayer.enhancementHitchhikerCarrier) and eventPlayer.hasSpawned() and distance(eventPlayer, eventPlayer.enhancementHitchhikerCarrier) < 3 * eventPlayer.enhancementHitchhikerCarrier.sizeScale:
            eventPlayer.teleport(eventPlayer.enhancementHitchhikerCarrier.getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.enhancementHitchhikerCarrier.enhancementHitchhikerPassenger = null
        eventPlayer.enhancementIsHitchhiking = false
        eventPlayer.enhancementHitchhikerCarrier = 0
        removeHealthPool(eventPlayer.enhancementHitchhikerPassengerPoolId)
        wait(1.5)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementHitchhikerPassenger != null
    
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.enhancementHitchhikerPassenger.initialMaxHealth, true, false)
    eventPlayer.enhancementHitchhikerCarrierPoolId = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.enhancementHitchhikerPassenger), Math.INFINITY)
    removeHealthPool(eventPlayer.enhancementHitchhikerCarrierPoolId)


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition eventPlayer.enhancementIsHitchhiking == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.enhancementHitchhikerCarrier.isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.enhancementHitchhikerCarrier.getNormalizedHealth()) > 0.01
    
    # hitchhikerHealthTransferAmount: health to transfer this update; consumed by both setHealth actions before wait.
    #!define hitchhikerHealthTransferAmount tmp0
    hitchhikerHealthTransferAmount = (abs(eventPlayer.getHealth() * eventPlayer.enhancementHitchhikerCarrier.getMaxHealth() - eventPlayer.enhancementHitchhikerCarrier.getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.enhancementHitchhikerCarrier.getMaxHealth())
    # hitchhikerHealthRecipient: player with lower normalized health, receiving the transfer immediately.
    #!define hitchhikerHealthRecipient tmp1
    hitchhikerHealthRecipient = sorted(eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier), lambda x: x.getNormalizedHealth())[0]
    # hitchhikerHealthDonor: other player, giving the transfer immediately; keep all three scratch values distinct.
    #!define hitchhikerHealthDonor tmp2
    hitchhikerHealthDonor = eventPlayer.concat(eventPlayer.enhancementHitchhikerCarrier).exclude(hitchhikerHealthRecipient)
    hitchhikerHealthRecipient.setHealth(hitchhikerHealthRecipient.getHealth() + hitchhikerHealthTransferAmount)
    hitchhikerHealthDonor.setHealth(hitchhikerHealthDonor.getHealth() - hitchhikerHealthTransferAmount)
    wait()
    if ruleCondition:
        loop()


rule "P.U.P. TARGET":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    #Cooldown is at 0s
    @Condition eventPlayer.enhancementPupCooldown <= 0
    #P.U.P. target
    @Condition eventPlayer.enhancementPupTarget == null
    @Condition (getLivingPlayers(Team.2).any(lambda player: player.botTarget == eventPlayer and distance(eventPlayer, player) < 10)) == true
    
    #Set P.U.P. target
    eventPlayer.enhancementPupTarget = (sorted(getLivingPlayers(Team.2).filter(lambda player: player.botTarget == eventPlayer), lambda x: distance(eventPlayer, x)))[0]
    waitUntil(eventPlayer.enhancementPupTarget.isDead() or not entityExists(eventPlayer.enhancementPupTarget) or eventPlayer.enhancementPupTarget.botIsTeleporting, Math.INFINITY)
    stopChasing(eventPlayer.enhancementPupPosition)
    eventPlayer.enhancementPupTarget = null
    wait()
    if ruleCondition:
        loop()
    stopChasing(eventPlayer.enhancementPupPosition)
    #Default color
    eventPlayer.enhancementPupColor = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementIsPupBeamActive = false
    #P.U.P. target null
    eventPlayer.enhancementPupTarget = null
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    #P.U.P. Default movement
    startPupDefaultChase()


rule "P.U.P. CONTROL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.PUP
    @Condition eventPlayer.enhancementPupTarget != null
    
    #P.U.P. attack movement
    chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getEyePosition() + directionTowards(eventPlayer.enhancementPupTarget.getEyePosition(), eventPlayer.enhancementPupPosition) * 2, (abs(distance(eventPlayer.enhancementPupTarget.getEyePosition(), eventPlayer.enhancementPupPosition) - 2)) * 1.5)
    #Default color
    eventPlayer.enhancementPupColor = Color.SKY_BLUE
    #Beam visibility
    eventPlayer.enhancementIsPupBeamActive = false
    #Freeze aura visibility
    eventPlayer.enhancementIsPupFreezeAuraActive = false
    waitUntil(distance(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget.getEyePosition()) < 5 or eventPlayer.enhancementPupTarget == null, Math.INFINITY)
    #If target still exists
    if eventPlayer.enhancementPupTarget != null:
        if distance(eventPlayer, eventPlayer.enhancementPupTarget) > 6:
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.WHITE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = true
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = true
            wait(0.25, Wait.ABORT_WHEN_FALSE)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.SKY_BLUE, eventPlayer.enhancementPupTarget, 0.1)
            #Time to freeze dependent on max health of target
            wait(min(15, eventPlayer.enhancementPupTarget.getMaxHealth() / 300), Wait.ABORT_WHEN_FALSE)
            #Freeze cooldown
            eventPlayer.enhancementPupCooldown = 2
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
            while not eventPlayer.enhancementPupTarget.hasStatus(Status.FROZEN):
                eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
                wait(0.25, Wait.ABORT_WHEN_FALSE)
            #Freeze zombies around target for shorter time
            ((getPlayersInRadius(eventPlayer.enhancementPupTarget, 3, Team.2)).exclude(eventPlayer.enhancementPupTarget)).setStatusEffect(eventPlayer, Status.FROZEN, 0.75)
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = false
        else:
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.RED
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = true
            eventPlayer.enhancementPupTarget.startDamageOverTime(eventPlayer, 3, 30)
            #Beam from P.U.P.
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementPupPosition, 0.25)
            #Beam hits P.U.P.'s target
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.enhancementPupTarget, 1)
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.BURNING, 3)
            eventPlayer.enhancementPupTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget)), min(-20, verticalAngleOfDirection(directionTowards(eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget)))), min(25, 4200 / eventPlayer.enhancementPupTarget.getMaxHealth()), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.enhancementPupTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1)
            #Laser cooldown
            eventPlayer.enhancementPupCooldown = 1
            wait(3, Wait.ABORT_WHEN_FALSE)
            #P.U.P. color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
        stopChasing(eventPlayer.enhancementPupPosition)
        #P.U.P. target
        eventPlayer.enhancementPupTarget = null
        wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


def startPupDefaultChase():
    @Name "startPupDefaultChase"

    chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition) - 1))


def resetBattleAbilityCharge():
    @Name "resetBattleAbilityCharge"

    eventPlayer.setAbilityCharge(eventPlayer.enhancementBattleAbilityButton, 1)
    eventPlayer.enhancementBattleResetCharges -= 1


def useLivingProjectile():
    @Name "useLivingProjectile"

    if eventPlayer.enhancementHeldZombie != null:
        eventPlayer.enhancementHoldUntil = 0
        return
    if [eventPlayer.isAttached, eventPlayer.hasStatus(Status.STUNNED), eventPlayer.hasStatus(Status.ASLEEP), eventPlayer.hasStatus(Status.FROZEN), eventPlayer.hasStatus(Status.KNOCKED_DOWN)].any():
        return
    # One raycast per press, against all players so intervening actors block pickup.
    # Synchronous scratch only: the candidate is committed to both actors before returning.
    #!define livingProjectileCandidate tmp0
    livingProjectileCandidate = raycastHitPlayer(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * DEAD_WEIGHT_RANGE, getAllPlayers(), eventPlayer, false)
    if livingProjectileCandidate == null:
        return
    if [livingProjectileCandidate.getTeam() != Team.2, not livingProjectileCandidate.isDummy(), not livingProjectileCandidate.isAlive(), livingProjectileCandidate in bossStateList.concat(miniBossList), livingProjectileCandidate.botIsInitializing, livingProjectileCandidate.botIsTeleporting, livingProjectileCandidate.botIsAttached].any():
        return
    # Inspect native statuses directly: the cached bot CC flag can lag by 0.125s.
    # Rooted alone never qualifies; Rooted plus low health or another CC still does.
    if not (livingProjectileCandidate.getNormalizedHealth() < 0.2 or livingProjectileCandidate.hasStatus(Status.STUNNED) or livingProjectileCandidate.hasStatus(Status.ASLEEP) or livingProjectileCandidate.hasStatus(Status.FROZEN) or livingProjectileCandidate.hasStatus(Status.KNOCKED_DOWN)):
        return
    eventPlayer.enhancementHeldZombie = livingProjectileCandidate
    eventPlayer.enhancementHoldUntil = getTotalTimeElapsed() + DEAD_WEIGHT_DURATION
    livingProjectileCandidate.deadWeightCarryHero = eventPlayer.getHero()
    livingProjectileCandidate.deadWeightZombieCarrier = eventPlayer
    livingProjectileCandidate.botIsAttached = true
    # Knockdown begins at pickup and outlasts the hold limit by one second.
    # Clearing it early interrupts the carry; throw damage clears it explicitly.
    livingProjectileCandidate.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, DEAD_WEIGHT_KNOCKDOWN_DURATION)
    livingProjectileCandidate.attachTo(eventPlayer, vect(0, 1.5, 1))


#!define livingProjectileInterrupted(carrier) ([not isGameplayActive, not entityExists(carrier), not carrier.isAlive(), carrier.isAttached, carrier.getHero() != eventPlayer.deadWeightCarryHero, not eventPlayer.isAlive(), eventPlayer.botIsInitializing, eventPlayer.botIsTeleporting, not eventPlayer.botIsAttached, not eventPlayer.hasStatus(Status.KNOCKED_DOWN)].any())

rule "LIVING PROJECTILE RELEASE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.deadWeightZombieCarrier != null
    @Condition (eventPlayer.deadWeightZombieCarrier.enhancementHoldUntil <= getTotalTimeElapsed() or livingProjectileInterrupted(eventPlayer.deadWeightZombieCarrier)) == true

    # Release and cleanup are synchronous; only throw damage waits below.
    # Bot-owned cleanup survives carrier departure.
    # A second press requests release by setting the carrier's deadline to zero.
    # Synchronous carrier snapshot, used only through release cleanup below.
    # No wait, async call or live HUD/effect captures this global scratch alias.
    #!define deadWeightCarrier tmp0
    deadWeightCarrier = eventPlayer.deadWeightZombieCarrier
    # Boolean snapshot, consumed by the branch before its damage wait.
    # No later action reads this scratch slot after yielding.
    #!define deadWeightShouldThrow tmp1
    deadWeightShouldThrow = deadWeightCarrier.enhancementHoldUntil == 0 and not livingProjectileInterrupted(deadWeightCarrier)
    eventPlayer.detach()
    eventPlayer.botIsAttached = false
    deadWeightCarrier.enhancementHeldZombie = null
    eventPlayer.deadWeightZombieCarrier = null
    if deadWeightShouldThrow:
        eventPlayer.applyImpulse(deadWeightCarrier.getFacingDirection(), DEAD_WEIGHT_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.deadWeightThrowDamageCredit = deadWeightCarrier
        wait(DEAD_WEIGHT_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.deadWeightThrowDamageCredit, DEAD_WEIGHT_THROW_DAMAGE)
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    # A pickup/release request made during the short damage wait is handled next.
    if ruleCondition:
        loop()
