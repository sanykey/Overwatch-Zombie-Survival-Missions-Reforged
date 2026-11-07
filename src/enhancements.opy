#!mainFile "../main.opy"

subroutine resetBattleAbilityCharge

subroutine checkEnhancementPlacement
subroutine startPupDefaultChase
subroutine applyBulkingSeasonStats
subroutine clearBoltEffects

#!define overchargeAssistTotal(player) (player.getStatistic(Stat.OFFENSIVE_ASSISTS) + player.getStatistic(Stat.DEFENSIVE_ASSISTS))

rule "PLAYER ENHANCEMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isDummy() != true
    @Condition eventPlayer.isHeroSwitchRespawn == false
    
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        # No preference and late-join zero state receive one real choice before
        # its state is initialized. Retain the selected ID across later spawns.
        eventPlayer.enhancementId = random.randint(Enhancement.BRAIN_KILLER, Enhancement.BOLT_STRIKE)
    #Zombie Hybrid
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        #Enhancement: Zombie Hyrbid
        # enhancementHybridCooldown: remaining explosion cooldown in seconds (20 on use), for activation checks and HUD.
        hudText(
            eventPlayer,
            ENHANCEMENT_ICONS[eventPlayer.enhancementId],
            "{1} {0}".format(f"{ceil(eventPlayer.enhancementHybridCooldown)}s" if eventPlayer.enhancementHybridCooldown > 0 else iconString(Icon.CHECKMARK), "Press [{0}] to deal {1}00 damage".format(inputBindingString(Button.MELEE), floor(eventPlayer.infectionLevel)) if eventPlayer.infectionLevel >= 1 and eventPlayer.enhancementHybridCooldown <= 0 else []),
            "Zombie Hybrid",
            HudPosition.ACTUALLY_LEFT, 99, Color.GRAY if eventPlayer.enhancementHybridCooldown <= 0 else Color.RED, Color.GRAY if eventPlayer.enhancementHybridCooldown <= 0 else Color.RED, Color.GRAY if eventPlayer.enhancementHybridCooldown <= 0 else Color.RED, HudReeval.STRING_AND_COLOR
        )
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionScale = 1.25
        eventPlayer.explosionInnerColor = Color.GRAY
        eventPlayer.explosionOuterColor = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLevel, 0, 0.015 if eventPlayer.infectionLevel > 0 else 0)
    switch eventPlayer.enhancementId:
        #Brain Killer
        case Enhancement.BRAIN_KILLER:
            #Enhancement: Brain Killer
            # No enhancement state slots: bonus damage is calculated directly from the damage event.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                "Bonus critical damage",
                "Brain Killer",
                HudPosition.ACTUALLY_LEFT, 99, Color.RED, Color.RED, Color.RED, HudReeval.STRING
            )
            break
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            #Enhancement: Pyrotechnic
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                "Ignites nearby targets",
                "Pyrotechnic",
                HudPosition.ACTUALLY_LEFT, 99, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.STRING
            )
            # enhancementPyroHitList: hit queue; repeated targets determine their damage per second when the queue is processed.
            eventPlayer.enhancementPyroHitList = []
            break
        #Plague Doctor
        case Enhancement.PLAGUE_DOCTOR:
            #Enhancement: Plague Doctor
            # enhancementPlagueCureTotal: accumulated infection levels removed, including cure bonuses, displayed in the HUD.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                "Infection Reduced: {0} lvls".format(eventPlayer.enhancementPlagueCureTotal),
                "Plague Doctor",
                HudPosition.ACTUALLY_LEFT, 99, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.STRING
            )
            # Permanent +30% healing; infected targets receive another x1.25 (x1.625 total).
            eventPlayer.setHealingDealt(130)
            startHealingModification(getPlayers(Team.1).filter(lambda player: player.isInfected), eventPlayer, 125, HealingReeval.RECEIVERS_AND_HEALERS)
            eventPlayer.enhancementPlagueCureTotal = 0
            break
        case Enhancement.OVERCHARGE:
            eventPlayer.enhancementCapacitorEnergy = 0
            eventPlayer.enhancementCapacitorCharge = 0
            eventPlayer.enhancementCapacitorDeadline = 0
            # Baseline existing match stats; do not pay for assists before selection/join.
            eventPlayer.enhancementCapacitorAssistSnapshot = overchargeAssistTotal(eventPlayer)
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                f"Hold [{inputBindingString(Button.MELEE)}] to charge | Energy: {floor(eventPlayer.enhancementCapacitorEnergy)} | Charged: {floor(eventPlayer.enhancementCapacitorCharge)}",
                "Overcharge",
                HudPosition.ACTUALLY_LEFT, 99, Color.TURQUOISE, Color.TURQUOISE, Color.TURQUOISE, HudReeval.STRING
            )
            break
        case Enhancement.BOLT_STRIKE:
            eventPlayer.enhancementBoltEnergy = 0
            eventPlayer.enhancementBoltBurst = 0
            eventPlayer.enhancementBoltChainEffect = []
            hudText(eventPlayer, ENHANCEMENT_ICONS[eventPlayer.enhancementId], f"2 targets | 25%, max 20 | Energy: {floor(eventPlayer.enhancementBoltEnergy)}/200 | Hold [{inputBindingString(Button.MELEE)}] | Armed: {eventPlayer.enhancementBoltBurst != 0}", "Bolt Strike", HudPosition.ACTUALLY_LEFT, 99, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.STRING)
            break
        case Enhancement.BULKING_SEASON:
            eventPlayer.enhancementBulkStacks = 0
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                f"Stacks: {eventPlayer.enhancementBulkStacks} | +{min(100, eventPlayer.enhancementBulkStacks * 0.5)}% Max Life | Size: {min(1.35, 1 + eventPlayer.enhancementBulkStacks * 0.005)}x",
                "Bulking Season",
                HudPosition.ACTUALLY_LEFT, 99, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, HudReeval.STRING
            )
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            #Enhancement: Born to Battle
            # enhancementBattleResetCharges: 0-2 earned ability resets; final blows add one and each reset consumes one.
            # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                f"{eventPlayer.enhancementBattleResetCharges}/2 resets",
                "Born to Battle",
                HudPosition.ACTUALLY_LEFT, 99, Color.GRAY, Color.GRAY, Color.GRAY, HudReeval.STRING
            )
            eventPlayer.enhancementBattleResetCharges = 0
            break
        #Charge Battery
        case Enhancement.CHARGE_BATTERY:
            #Enhancement: Charge Battery
            # enhancementBatteryPosition: placed battery position in world coordinates, for effects and player proximity checks.
            # enhancementBatteryReuseCooldown: remaining battery reuse cooldown in seconds, for the progress bar and availability visuals.
            # enhancementBatteryReuseDuration: full battery reuse cooldown in seconds (10), used to start the timer and scale progress.
            # enhancementBatteryPlacementCooldown: remaining placement cooldown in seconds (20 on placement), for placement checks and HUD.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                "{1} {0}".format(f"{ceil(eventPlayer.enhancementBatteryPlacementCooldown)}s" if eventPlayer.enhancementBatteryPlacementCooldown > 0 else iconString(Icon.CHECKMARK), "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else []),
                "Charge Battery",
                HudPosition.ACTUALLY_LEFT, 99, Color.WHITE if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else Color.RED, Color.WHITE if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else Color.RED, Color.WHITE if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else Color.RED, HudReeval.STRING_AND_COLOR
            )
            #Battery placement visual
            createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementBatteryPlacementCooldown <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, rgb(0, 255, 0, 204), worldVector(0.1 * Vector.UP, eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery ring
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0), Effect.RING, Color.YELLOW, eventPlayer.enhancementBatteryPosition, 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Battery sphere
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0), Effect.ORB, Color.GRAY, eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Charge battery text
            createInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown <= 0 and distance(player, eventPlayer.enhancementBatteryPosition) < 6), "Charge Battery", eventPlayer.enhancementBatteryPosition + ((0.5 + sin(getTotalTimeElapsed() * 1) * 0.15) * Vector.UP), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
            #Charge battery progress bar
            createProgressBarInWorldText(getAllPlayers().filter(lambda player: eventPlayer.enhancementBatteryPosition != 0 and eventPlayer.enhancementBatteryReuseCooldown > 0 and distance(player, eventPlayer.enhancementBatteryPosition) < 6), 100 - eventPlayer.enhancementBatteryReuseCooldown / eventPlayer.enhancementBatteryReuseDuration * 100, [], eventPlayer.enhancementBatteryPosition + 0.4 * Vector.UP, 0.5, Clip.SURFACES, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_AND_VALUES)
            eventPlayer.enhancementBatteryReuseDuration = 10
            break
        #Hitchhiker
        case Enhancement.HITCHHIKER:
            #Enhancement Selection: Hitchhiker
            # enhancementHitchhikerCarrier: carrier player reference, for attachment, shared health, assists and HUD; 0 when detached.
            # enhancementHitchhikerPassengerPoolId: extra health pool ID on this passenger, retained to remove that pool when detaching.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.enhancementIsHitchhiking else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer, x) < 2 * x.sizeScale) else [],
                "Hitchhiker",
                HudPosition.ACTUALLY_LEFT, 99, Color.PURPLE, Color.RED if eventPlayer.enhancementIsHitchhiking else Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_STRING_AND_COLOR
            )
            #Shared Health Bar Rider
            hudSubheader(eventPlayer.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementHitchhikerCarrier.getHero()), eventPlayer.enhancementHitchhikerCarrier), HudPosition.ACTUALLY_LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            #Shared Health Bar Runner
            hudSubheader(eventPlayer.enhancementHitchhikerCarrier.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.ACTUALLY_LEFT, 100, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
            eventPlayer.enhancementHitchhikerCarrier = 0
            eventPlayer.enhancementHitchhikerCarrier.startGrantingAssistFor(eventPlayer)
            break
        #P.U.P.
        case Enhancement.PUP:
            #Enhancement Selection: P.U.P.
            # enhancementPupColor: current drone color, indicating its mode in the HUD, sphere and beam.
            # enhancementIsPupBeamActive: whether the attack beam is active; also controls its sound and pauses cooldown decay.
            # enhancementPupTarget: current enemy target, shared by movement, attack and target cleanup rules; null when idle.
            # enhancementIsPupFreezeAuraActive: whether the freezing aura effect is visible around the target.
            # enhancementPupPosition: chased drone position in world coordinates, for movement, effects and attack direction.
            # enhancementPupCooldown: remaining ability cooldown in seconds (2 after freezing, 1 after laser), gating target selection.
            hudText(
                eventPlayer,
                ENHANCEMENT_ICONS[eventPlayer.enhancementId],
                f"{ceil(eventPlayer.enhancementPupCooldown)}s" if eventPlayer.enhancementPupCooldown > 0 else iconString(Icon.CHECKMARK),
                "P.U.P.",
                HudPosition.ACTUALLY_LEFT, 99, Color.BLUE if eventPlayer.enhancementPupColor == Color.SKY_BLUE and eventPlayer.enhancementPupCooldown > 0 else eventPlayer.enhancementPupColor, Color.BLUE if eventPlayer.enhancementPupColor == Color.SKY_BLUE and eventPlayer.enhancementPupCooldown > 0 else eventPlayer.enhancementPupColor, Color.BLUE if eventPlayer.enhancementPupColor == Color.SKY_BLUE and eventPlayer.enhancementPupCooldown > 0 else eventPlayer.enhancementPupColor, HudReeval.VISIBILITY_STRING_AND_COLOR
            )
            #Postion of P.U.P.
            eventPlayer.enhancementPupPosition = eventPlayer.getPosition() + 200 * Vector.UP
            #P.U.P. Default movment
            startPupDefaultChase()
            eventPlayer.enhancementPupCooldown = 0
            #P.U.P. ability cooldown
            chaseAtRate(eventPlayer.enhancementPupCooldown, 0, 0 if eventPlayer.enhancementIsPupBeamActive else 1)
            #P.U.P. visual
            createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.enhancementPupColor, eventPlayer.enhancementPupPosition, 0.25)
            #P.U.P. Beam
            createBeam(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupBeamActive and eventPlayer.enhancementPupTarget != null), Beam.GOOD, eventPlayer.enhancementPupPosition, eventPlayer.enhancementPupTarget, eventPlayer.enhancementPupColor)
            #P.U.P using beam sound
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupBeamActive), Effect.BEACON_SOUND, Color.SKY_BLUE, eventPlayer.enhancementPupPosition, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Freeze aura
            createEffect(getAllPlayers().filter(lambda _: eventPlayer.enhancementIsPupFreezeAuraActive), Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.enhancementPupTarget, eventPlayer.enhancementPupTarget.sizeScale, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            #Default color
            eventPlayer.enhancementPupColor = Color.SKY_BLUE
            #Beam visibility
            eventPlayer.enhancementIsPupBeamActive = false
            #P.U.P. target null
            eventPlayer.enhancementPupTarget = null
            #Freeze aura visibility
            eventPlayer.enhancementIsPupFreezeAuraActive = false


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


rule "BORN TO BATTLE PLAYER EARNS ELIMINATION":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BORN_TO_BATTLE
    @Condition eventPlayer.enhancementBattleResetCharges < 2
    
    eventPlayer.enhancementBattleResetCharges += 1


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


rule "BULKING SEASON EARNS STACKS":
    @Event playerEarnedElimination
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.BULKING_SEASON

    # One credit for a kill or damage participation; healing/buff assists do not count.
    eventPlayer.enhancementBulkStacks += 1
    applyBulkingSeasonStats()


rule "BULKING SEASON LOSES STACKS ON DEATH":
    @Event playerDied
    @Team 1
    @Condition isGameplayActive == true
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
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.BOLT_STRIKE
    @Condition eventAbility != null
    @Condition victim.getTeam() == Team.2
    @Condition eventDamage > 0

    # All scratch is synchronous: no waits, async calls or effect reevaluation.
    # Cleanup finishes before target scratch is assigned (it also uses tmp2).
    clearBoltEffects()
    #!define boltChainTargets tmp0
    #!define boltHealthBefore tmp1
    #!define boltIndex tmp2
    boltChainTargets = random.shuffle(getPlayersInRadius(victim, 10, Team.2, LosCheck.SURFACES).filter(lambda player: player.isAlive()).exclude(victim)).slice(0, 2)
    for boltIndex in range(len(boltChainTargets)):
        boltHealthBefore = boltChainTargets[boltIndex].getHealth()
        damage(boltChainTargets[boltIndex], eventPlayer, min(20, eventDamage * 0.25))
        # Only actual health removed: respects immunity, reduction and overkill.
        eventPlayer.enhancementBoltEnergy = min(200, eventPlayer.enhancementBoltEnergy + max(0, boltHealthBefore - boltChainTargets[boltIndex].getHealth()))
        createBeam(getAllPlayers(), Beam.WINSTON_TESLA_CANNON, victim.getPosition() + vect(0, 0.7, 0), boltChainTargets[boltIndex].getPosition() + vect(0, 0.7, 0), Color.YELLOW, EffectReeval.NONE)
        eventPlayer.enhancementBoltChainEffect.append(getLastCreatedEntity())
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, boltChainTargets[boltIndex], 0.5)
    if eventPlayer.enhancementBoltBurst == -1:
        eventPlayer.enhancementBoltBurst = getTotalTimeElapsed() + 0.3
    if eventPlayer.enhancementBoltBurst > getTotalTimeElapsed():
        # Lordy's sky-to-victim Tesla beam; frozen endpoints and shared cleanup.
        createBeam(getAllPlayers(), Beam.WINSTON_TESLA_CANNON, victim.getPosition() + vect(0, 20, 0), victim.getPosition(), Color.YELLOW, EffectReeval.NONE)
        eventPlayer.enhancementBoltChainEffect.append(getLastCreatedEntity())
        victim.setStatusEffect(eventPlayer, Status.STUNNED, 2)
        damage(victim, eventPlayer, 60)
    eventPlayer.enhancementBoltEffectDeadline = getTotalTimeElapsed() + 0.3


def clearBoltEffects():
    @Name "clearBoltEffects"

    # Synchronous cleanup index; never called inside the chain target loop.
    #!define boltEffectIndex tmp2
    for boltEffectIndex in range(len(eventPlayer.enhancementBoltChainEffect)):
        destroyEffect(eventPlayer.enhancementBoltChainEffect[boltEffectIndex])
    eventPlayer.enhancementBoltChainEffect = []


rule "BOLT STRIKE CHAIN EFFECT EXPIRES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BOLT_STRIKE
    @Condition eventPlayer.enhancementBoltChainEffect != []
    @Condition (getTotalTimeElapsed() >= eventPlayer.enhancementBoltEffectDeadline or not isGameplayActive or not eventPlayer.isAlive()) == true

    clearBoltEffects()


rule "BOLT STRIKE DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.BOLT_STRIKE

    clearBoltEffects()


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

    # Death cancels the armed burst; unspent energy remains in the bank.
    eventPlayer.enhancementBoltBurst = 0


rule "OVERCHARGE STORES HEALING":
    @Event playerDealtHealing
    @Team 1
    @Condition isGameplayActive == true
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
    @Condition isGameplayActive == true
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.enhancementCapacitorCharge > 0
    @Condition eventDamage > 0
    @Condition victim.getTeam() == Team.2
    # Workshop Damage has no Event Ability; never amplify this rule's own bonus.
    # Long Reach applies the same burst directly after confirming its actual hit.
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
