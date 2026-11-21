#!mainFile "../../main.opy"
subroutine resetBattleAbilityCharge

subroutine startPupDefaultChase
subroutine applyBulkingSeasonStats


#!define overchargeEarnedEnergyTotal(player) (player.getStatistic(Stat.HEALING_DEALT) / OVERCHARGE_HEAL_ENERGY_DIVISOR + OVERCHARGE_ENERGY_PER_ASSIST * earnedAssists(player))

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
    eventPlayer.enhancementHybridCooldown = ZOMBIE_HYBRID_EXPLOSION_COOLDOWN
    while eventPlayer.enhancementHybridCooldown > 0:
        wait(1)
        eventPlayer.enhancementHybridCooldown += -1


#!include "enhancement_pyrotechnic.opy"


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


# BULKING SEASON EARNS STACKS moved to "PLAYER EARNED ELIMINATION" in player_events.opy.


def applyBulkingSeasonStats():
    @Name "applyBulkingSeasonStats"

    # Additive percentages from the native hero baseline; never compound live max health.
    eventPlayer.setMaxHealth(min(BULKING_SEASON_MAX_HP_MULTIPLIER * 100, 100 + eventPlayer.enhancementBulkStacks * BULKING_SEASON_HP_PER_STACK_PCT))
    eventPlayer.sizeScale = 1 if eventPlayer.enhancementBulkNormalSize else min(BULKING_SEASON_MAX_SIZE_MULTIPLIER, 1 + eventPlayer.enhancementBulkStacks * (BULKING_SEASON_SIZE_PER_STACK_PCT / 100))
    applyCurrentSizeScale()
    # Map capped size 1..2.5 linearly to pitch 1..0.5 (200 stacks).
    # Reuse the current size so native-size mode also restores native pitch.
    eventPlayer.startModifyingVoicelinePitch((4 - eventPlayer.sizeScale) / 3, false)


rule "BULKING SEASON TOGGLES SIZE":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.BULKING_SEASON)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true

    # One toggle per hold; releasing before 0.5s cancels it. No repeating loop.
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.enhancementBulkNormalSize = not eventPlayer.enhancementBulkNormalSize
    applyBulkingSeasonStats()


rule "OVERCHARGE ARM ON DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.enhancementId == Enhancement.OVERCHARGE
    @Condition eventPlayer.enhancementCapacitorEnergy > 0
    @Condition eventPlayer.enhancementCapacitorCharge == 0

    # Press-release-press: each gap is bounded by OVERCHARGE_ARM_TAP_WINDOW.
    # Holding cannot arm a charge.
    # No shared scratch survives these waits. Recheck all eligibility on the
    # second press, including life, selection, readiness and an already armed charge.
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), OVERCHARGE_ARM_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), OVERCHARGE_ARM_TAP_WINDOW)
    if not ruleCondition:
        return
    # Transfer at most 100; retain the remainder in the uncapped bank.
    # Continued healing cannot change this burst's fixed damage.
    eventPlayer.enhancementCapacitorCharge = min(eventPlayer.enhancementCapacitorEnergy, OVERCHARGE_MAX_CHARGE)
    eventPlayer.enhancementCapacitorEnergy -= eventPlayer.enhancementCapacitorCharge


rule "OVERCHARGE STORES HEALING AND ASSISTS":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.OVERCHARGE)
    @Condition overchargeEarnedEnergyTotal(eventPlayer) != eventPlayer.enhancementCapacitorStatsSnapshot

    # Native Healing Dealt is the only healing source; event healing can include passive regeneration.
    # Combine healing and weighted assists so one existing snapshot covers all earned energy.
    # Synchronous scratch: consumed before any wait/call/HUD reevaluation can reuse tmp0.
    #!define overchargeCurrentEarnedEnergy tmp0
    overchargeCurrentEarnedEnergy = overchargeEarnedEnergyTotal(eventPlayer)
    eventPlayer.enhancementCapacitorEnergy += max(0, overchargeCurrentEarnedEnergy - eventPlayer.enhancementCapacitorStatsSnapshot)
    # Resync on a stat reset too, without subtracting energy or paying twice.
    eventPlayer.enhancementCapacitorStatsSnapshot = overchargeCurrentEarnedEnergy


rule "OVERCHARGE CLEARS CHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementCapacitorCharge > 0
    @Condition (eventPlayer.isDead() or eventPlayer.enhancementCapacitorDeadline > 0 and getTotalTimeElapsed() >= eventPlayer.enhancementCapacitorDeadline) == true

    if eventPlayer.enhancementId != Enhancement.OVERCHARGE:
        return

    eventPlayer.enhancementCapacitorCharge = 0
    eventPlayer.enhancementCapacitorDeadline = 0


rule "BOLT STRIKE ON DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.BOLT_STRIKE)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    # Check the first press so holding Crouch through expiry cannot start a tap.
    if getTotalTimeElapsed() < eventPlayer.enhancementBoltReadyAt:
        return
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), BOLT_STRIKE_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), BOLT_STRIKE_TAP_WINDOW)
    if not ruleCondition:
        return

    # The shared selector returns the living zombie closest to the crosshair.
    # All scratch is consumed before the beam's unconditional cleanup wait.
    #!define boltStrikeTarget tmp0
    #!define boltStrikeSplashTargets tmp1
    pullAimMode = PullAimMode.BOLT_STRIKE
    selectPullAimTarget()
    if boltStrikeTarget == null:
        return
    eventPlayer.enhancementBoltReadyAt = getTotalTimeElapsed() + BOLT_STRIKE_COOLDOWN

    # Snapshot the splash before the primary can die, and both beam endpoints
    # before damage or cleanup. Player collision does not block the splash.
    boltStrikeSplashTargets = getPlayersInRadius(boltStrikeTarget, BOLT_STRIKE_SPLASH_RADIUS, Team.2, LosCheck.SURFACES).filter(lambda target: target != boltStrikeTarget and target.isAlive() and target.isDummy() and not target.botIsTeleporting and not target.botIsInitializing)
    createBeam(getAllPlayers(), Beam.GOOD, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(boltStrikeTarget), Color.SKY_BLUE, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, boltStrikeTarget, BOLT_STRIKE_WAVE_RADIUS)
    # Play the cue near the caster so a distant target does not muffle it.
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 100)
    boltStrikeSplashTargets.concat(boltStrikeTarget).setStatusEffect(eventPlayer, Status.STUNNED, BOLT_STRIKE_STUN_DURATION)
    damage(boltStrikeTarget, eventPlayer, BOLT_STRIKE_DAMAGE)
    damage(boltStrikeSplashTargets, eventPlayer, BOLT_STRIKE_SPLASH_DAMAGE)

    wait(BOLT_STRIKE_BEAM_DURATION, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null


def checkEnhancementPlacement():
    # Synchronous output only: no waits, asynchronous work or nested calls before the caller reads tmp0.
    # Keep the 31 m validation ray separate from each caller's 30 m placement ray and its player filters.
    # The caller must return on rejection; returning here alone would not cancel placement.
    isEnhancementPlacementInvalid = distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30 or eventPlayer.isDead()


#!include "enhancement_hitchhiker.opy"


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
        if distance(eventPlayer, eventPlayer.enhancementPupTarget) > PUP_IGNITE_RANGE:
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
            eventPlayer.enhancementPupCooldown = PUP_FREEZE_COOLDOWN
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
            eventPlayer.enhancementPupCooldown = PUP_LASER_COOLDOWN
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


rule "WRESTLER PULL":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.WRESTLER)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true

    # Same hold as Engineer's turret. Check cooldown on this input edge: holding through
    # expiry cannot auto-cast, and an invalid target never spends the cooldown.
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if getTotalTimeElapsed() < eventPlayer.enhancementPullReadyAt or eventPlayer.isAttached or eventPlayer.isCrowdControlled:
        return
    # Grapnel's body-center cone, surface LOS and crosshair-angle priority;
    # only living, available Team 2 dummies are eligible. No minimum distance.
    # selectPullAimTarget returns tmp0. NONE snapshots both beam endpoints; every target
    # read finishes before the wait. No Augment-owned storage is touched.
    #!define wrestlerPullTarget tmp0
    # Shared selection consumes scratch synchronously; persist/capture its result before waits.
    pullAimMode = PullAimMode.WRESTLER_PULL
    selectPullAimTarget()
    if wrestlerPullTarget == null:
        return
    eventPlayer.enhancementPullReadyAt = getTotalTimeElapsed() + WRESTLER_PULL_COOLDOWN
    # Slimer's Bad Beam, recolored purple, appears at full length immediately.
    createBeam(getAllPlayers(), Beam.BAD, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(wrestlerPullTarget), Color.PURPLE, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    wrestlerPullTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, WRESTLER_PULL_KNOCKDOWN)
    damage(wrestlerPullTarget, eventPlayer, WRESTLER_PULL_DAMAGE)
    # Bosses and minibosses take damage and knockdown without the impulse.
    if wrestlerPullTarget not in bossStateList and wrestlerPullTarget not in miniBossList:
        # Strength scales with distance, approaching zero at contact.
        # Keep the pull's horizontal bearing with a fixed 15-degree upward pitch.
        wrestlerPullTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(wrestlerPullTarget, eventPlayer)), -15), distance(wrestlerPullTarget, eventPlayer) * WRESTLER_PULL_FORCE_MULTIPLIER, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    # Always clean up, including release, death, hero change or end of gameplay.
    wait(WRESTLER_PULL_BEAM_DURATION, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null


rule "ENHANCEMENT ATTACK BEAM DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if eventPlayer.enhancementId in [Enhancement.WRESTLER, Enhancement.BOLT_STRIKE] and eventPlayer.enhancementAttackBeamEntity != null:
        destroyEffect(eventPlayer.enhancementAttackBeamEntity)


def useLivingProjectile():
    @Name "useLivingProjectile"

    if eventPlayer.enhancementCarryState != WrestlerCarryState.NONE:
        eventPlayer.enhancementCarryState = WrestlerCarryState.THROW_REQUESTED
        return
    # Check only on pickup input, before target selection; throwing stays available.
    if getTotalTimeElapsed() < eventPlayer.enhancementGrabReadyAt or eventPlayer.isAttached or eventPlayer.isCrowdControlled:
        return
    # Body-center cone (90 degrees), LOS and crosshair priority, limited to 5m.
    # The shared grab mode requires bot CC, including for bosses/minibosses.
    # Synchronous tmp0 result: committed to both actors before any yield.
    #!define livingProjectileCandidate tmp0
    pullAimMode = PullAimMode.WRESTLER_GRAB
    selectPullAimTarget()
    if livingProjectileCandidate == null:
        return
    eventPlayer.enhancementCarryState = WrestlerCarryState.HOLDING
    livingProjectileCandidate.wrestlerCarryHero = eventPlayer.getHero()
    livingProjectileCandidate.wrestlerZombieCarrier = eventPlayer
    # Independent of Super Nano's damage-received settings; bot owns cleanup.
    startDamageModification(eventPlayer, getAllPlayers(), 100 - WRESTLER_CARRY_DMG_RESIST_PCT)
    livingProjectileCandidate.wrestlerProtectionId = getLastDamageModification()
    livingProjectileCandidate.botIsAttached = true
    # Knockdown owns the carry lifetime; expiration or early removal releases.
    # Throw damage clears it explicitly after the existing damage delay.
    # Bosses/minibosses have a shorter carry window; ordinary zombies keep 4s.
    livingProjectileCandidate.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1 if livingProjectileCandidate in bossStateList or livingProjectileCandidate in miniBossList else WRESTLER_KNOCKDOWN_DURATION)
    # Attachment offsets are local; use eye height to follow hero size changes.
    livingProjectileCandidate.attachTo(eventPlayer, localVector(eventPlayer.getEyePosition(), eventPlayer, Transform.ROTATION_AND_TRANSLATION) + vect(0, 0.6, 1))


# All entries are booleans/default zero; negate this predicate for interruptions.
# Keeping positive checks avoids repeated Not values in the compiled array.
#!define livingProjectileValid(carrier) ([isGameplayActive, entityExists(carrier), carrier.isAlive(), not carrier.isCrowdControlled, not carrier.isAttached, carrier.getHero() == eventPlayer.wrestlerCarryHero, eventPlayer.isAlive(), not eventPlayer.botIsInitializing, not eventPlayer.botIsTeleporting, eventPlayer.botIsAttached, eventPlayer.hasStatus(Status.KNOCKED_DOWN)].all())

rule "LIVING PROJECTILE RELEASE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.wrestlerZombieCarrier != null
    @Condition (eventPlayer.wrestlerZombieCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not livingProjectileValid(eventPlayer.wrestlerZombieCarrier)) == true

    # Release and cleanup are synchronous; only throw damage waits below.
    # Bot-owned cleanup survives carrier departure.
    # A second press sets THROW_REQUESTED; knockdown expiry releases without a throw.
    # Synchronous carrier snapshot, used only through release cleanup below.
    # No wait, async call or live HUD/effect captures this global scratch alias.
    #!define wrestlerCarrier tmp0
    wrestlerCarrier = eventPlayer.wrestlerZombieCarrier
    # Boolean snapshot, consumed by the branch before its damage wait.
    # No later action reads this scratch slot after yielding.
    #!define wrestlerShouldThrow tmp1
    wrestlerShouldThrow = wrestlerCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED and livingProjectileValid(wrestlerCarrier)
    eventPlayer.detach()
    eventPlayer.botIsAttached = false
    stopDamageModification(eventPlayer.wrestlerProtectionId)
    wrestlerCarrier.enhancementCarryState = WrestlerCarryState.NONE
    # Every release starts the silent pickup cooldown, including interrupted holds.
    wrestlerCarrier.enhancementGrabReadyAt = getTotalTimeElapsed() + WRESTLER_GRAB_COOLDOWN
    eventPlayer.wrestlerZombieCarrier = null
    # Death/CC drops the zombie immediately, without throw damage or delay.
    if wrestlerCarrier.isDead() or wrestlerCarrier.isCrowdControlled:
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    if wrestlerShouldThrow:
        eventPlayer.applyImpulse(wrestlerCarrier.getFacingDirection(), WRESTLER_THROW_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.wrestlerThrowDamageCredit = wrestlerCarrier
        wait(WRESTLER_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.wrestlerThrowDamageCredit, WRESTLER_THROW_DAMAGE)
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    # A pickup/release request made during the short damage wait is handled next.
    if ruleCondition:
        loop()


rule "ENGINEER SCRAP INCOME":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.ENGINEER)
    @Condition eventPlayer.isAlive() == true

    eventPlayer.enhancementScrap = min(ENGINEER_SCRAP_MAX, eventPlayer.enhancementScrap + ENGINEER_SCRAP_PASSIVE_RATE)
    wait(1)
    if ruleCondition:
        loop()


rule "ENGINEER ARMOR TRANSFER":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.ENGINEER)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    # Match Overcharge's press-release-press sequence without retaining scratch.
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), ENGINEER_ARMOR_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), ENGINEER_ARMOR_TAP_WINDOW)
    if not ruleCondition:
        return
    # The target resolves on the second press: the visible ally closest to the crosshair
    # in the wide aim cone (within 15m) receives armor, otherwise it goes to self.
    # The candidate slot is reused for cost after the target pick. No waits below.
    #!define scrapTransferCandidates tmp0
    #!define scrapArmorGrantTarget tmp1
    scrapTransferCandidates = sorted(getPlayersInRadius(eventPlayer, ENGINEER_TRANSFER_RANGE, Team.1, LosCheck.SURFACES).filter(lambda ally: ally != eventPlayer and ally.isAlive() and eventPlayer.isInViewAngle(ally.getEyePosition(), ENGINEER_TRANSFER_ANGLE)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))
    if scrapTransferCandidates != []:
        # Aiming at an ally: the action is ally-directed and never falls back to
        # self. Engineer armor caps at ENGINEER_ARMOR_MAX per target across every Engineer
        # donor; a grant is refused only at the full cap.
        scrapArmorGrantTarget = scrapTransferCandidates[0]
        if scrapArmorGrantTarget.scrapArmorAmount >= ENGINEER_ARMOR_MAX:
            smallMessage(eventPlayer, "Ally armor is full")
            return
    elif eventPlayer.scrapArmorAmount < ENGINEER_ARMOR_MAX:
        # No ally targeted and room below the cap: self-armor without a beam.
        scrapArmorGrantTarget = eventPlayer
    else:
        return
    # Candidate array is dead after target selection; reuse tmp0 for the cost.
    # Synchronous through payment, with no waits or reevaluated readers.
    #!define scrapArmorGrantCost tmp0
    scrapArmorGrantCost = ENGINEER_ARMOR_SELF_COST if scrapArmorGrantTarget == eventPlayer else ENGINEER_ARMOR_ALLY_COST
    if eventPlayer.enhancementScrap < scrapArmorGrantCost:
        smallMessage(eventPlayer, "Not enough scrap")
        return
    eventPlayer.enhancementScrap -= scrapArmorGrantCost
    # Non-recoverable, fixed pool: healing never restores scrap armor. One
    # throw adds at most ENGINEER_ARMOR_STACK armor and tops the target up to the cap;
    # the wasted remainder of a partial refill is the thrower's loss.
    scrapArmorGrantTarget.addHealthPool(Health.ARMOR, min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount), false, false)
    scrapArmorGrantTarget.scrapArmorAmount = min(ENGINEER_ARMOR_MAX, scrapArmorGrantTarget.scrapArmorAmount + ENGINEER_ARMOR_STACK)
    # Received-armor feedback: the transfer-beam-colored ring plus the turret
    # freeze sound, on the grant target (self or ally). One-shot; no scratch or
    # entity to clean up. The message quotes the full stack constant, so a
    # partial top-up near the cap still announces ENGINEER_ARMOR_STACK armor;
    # an ally transfer names the donor, self-armor stays nameless.
    smallMessage(scrapArmorGrantTarget, f"+{ENGINEER_ARMOR_STACK} armor" if scrapArmorGrantTarget == eventPlayer else f"+{ENGINEER_ARMOR_STACK} armor from {eventPlayer}")
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, scrapArmorGrantTarget, 4)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, scrapArmorGrantTarget, ENGINEER_TRANSFER_RANGE)
    # Self-armor creates no beam. A transfer moves the single beam to the new
    # ally and resets its ENGINEER_BEAM_DURATION lifetime; the endpoint must be a stable player
    # variable, never scratch, because the reevaluating beam reads it every frame.
    if scrapArmorGrantTarget != eventPlayer:
        eventPlayer.enhancementScrapBeamTarget = scrapArmorGrantTarget
        if eventPlayer.enhancementScrapBeamEntity != null:
            destroyEffect(eventPlayer.enhancementScrapBeamEntity)
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer, eventPlayer.enhancementScrapBeamTarget, Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.enhancementScrapBeamEntity = getLastCreatedEntity()
        eventPlayer.enhancementScrapBeamDeadline = getTotalTimeElapsed() + ENGINEER_BEAM_DURATION


rule "ENGINEER TURRET DEPLOY":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.ENGINEER)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false

    # Crouch is reserved for armor. The 0.25s Melee hold matches inventory
    # powerups. Guards run only after a confirmed hold, so taps stay silent.
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.enhancementScrap < ENGINEER_TURRET_COST:
        smallMessage(eventPlayer, "Not enough scrap")
        return
    eventPlayer.enhancementScrap -= ENGINEER_TURRET_COST
    deploySentryTurret()


rule "ENGINEER BEAM FADE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.ENGINEER
    @Condition eventPlayer.enhancementScrapBeamEntity != null
    @Condition getTotalTimeElapsed() >= eventPlayer.enhancementScrapBeamDeadline

    destroyEffect(eventPlayer.enhancementScrapBeamEntity)
    eventPlayer.enhancementScrapBeamEntity = null
    eventPlayer.enhancementScrapBeamTarget = null


rule "ENGINEER BEAM DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.enhancementId == Enhancement.ENGINEER) and (eventPlayer.enhancementScrapBeamEntity != null):
        # Follow the project's supplied playerLeft cleanup pattern: consume the
        # departing player's effect ID synchronously in the departure event.
        destroyEffect(eventPlayer.enhancementScrapBeamEntity)


rule "ENGINEER SCRAP ARMOR DEPLETION":
    @Event playerTookDamage
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.scrapArmorAmount > 0) and (eventDamage > 0):
        # Damage order on armored targets: scrap stacks absorb first, the older
        # recoverable Kevlar pool last. Subtracting the full hit capped at the
        # modeled remainder is therefore exact: overflow into Kevlar and health
        # never touches this mirror, and healing cannot refill the non-recoverable
        # pools.
        eventPlayer.scrapArmorAmount = max(0, eventPlayer.scrapArmorAmount - eventDamage)
