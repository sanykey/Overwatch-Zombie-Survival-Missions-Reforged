#!mainFile "../../main.opy"


macro useWrestlerPull():
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


def useWrestlerGrabOrThrow():
    @Name "useWrestlerGrabOrThrow"

    if eventPlayer.enhancementCarryState != WrestlerCarryState.NONE:
        eventPlayer.enhancementCarryState = WrestlerCarryState.THROW_REQUESTED
        return
    # Check only on pickup input, before target selection; throwing stays available.
    if getTotalTimeElapsed() < eventPlayer.enhancementGrabReadyAt or eventPlayer.isAttached or eventPlayer.isCrowdControlled:
        return
    # Body-center cone (90 degrees), LOS and crosshair priority, limited to 5m.
    # The shared grab mode requires bot CC, including for bosses/minibosses.
    # Synchronous tmp0 result: committed to both actors before any yield.
    #!define wrestlerGrabTarget tmp0
    pullAimMode = PullAimMode.WRESTLER_GRAB
    selectPullAimTarget()
    if wrestlerGrabTarget == null:
        return
    eventPlayer.enhancementCarryState = WrestlerCarryState.HOLDING
    wrestlerGrabTarget.wrestlerCarryHero = eventPlayer.getHero()
    if eventPlayer.getHero() == Hero.JETPACK_CAT:
        # Frenetic Flight uses secondary fire.
        eventPlayer.setSecondaryFireEnabled(false)
    wrestlerGrabTarget.wrestlerZombieCarrier = eventPlayer
    # Independent of Super Nano's damage-received settings; bot owns cleanup.
    startDamageModification(eventPlayer, getAllPlayers(), 100 - WRESTLER_CARRY_DMG_RESIST_PCT)
    wrestlerGrabTarget.wrestlerProtectionId = getLastDamageModification()
    wrestlerGrabTarget.botIsAttached = true
    # Knockdown owns the carry lifetime; expiration or early removal releases.
    # Throw damage clears it explicitly after the existing damage delay.
    # Bosses/minibosses have a shorter carry window; ordinary zombies keep 4s.
    wrestlerGrabTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1 if wrestlerGrabTarget in bossStateList or wrestlerGrabTarget in miniBossList else WRESTLER_KNOCKDOWN_DURATION)
    # Attachment offsets are local; use eye height to follow hero size changes.
    wrestlerGrabTarget.attachTo(eventPlayer, localVector(eventPlayer.getEyePosition(), eventPlayer, Transform.ROTATION_AND_TRANSLATION) + vect(0, 0.6, 1))


# All entries are booleans/default zero; negate this predicate for interruptions.
# Keeping positive checks avoids repeated Not values in the compiled array.
macro isWrestlerCarryValid(carrier):
    [
        isGameplayActive,
        entityExists(carrier),
        carrier.isAlive(),
        not carrier.isCrowdControlled,
        not carrier.isAttached,
        carrier.getHero() == eventPlayer.wrestlerCarryHero,
        eventPlayer.isAlive(),
        not eventPlayer.botIsInitializing,
        not eventPlayer.botIsTeleporting,
        eventPlayer.botIsAttached,
        eventPlayer.hasStatus(Status.KNOCKED_DOWN)
    ].all()

rule "WRESTLER GRAB RELEASE":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.wrestlerZombieCarrier != null
    @Condition (eventPlayer.wrestlerZombieCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not isWrestlerCarryValid(eventPlayer.wrestlerZombieCarrier)) == true

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
    wrestlerShouldThrow = wrestlerCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED and isWrestlerCarryValid(wrestlerCarrier)
    eventPlayer.detach()
    eventPlayer.botIsAttached = false
    stopDamageModification(eventPlayer.wrestlerProtectionId)
    if entityExists(wrestlerCarrier):
        wrestlerCarrier.setSecondaryFireEnabled(true)
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
        # The wave reads the retained carrier and reuses the release scratch before the wait.
        conePushRange = WRESTLER_THROW_PUSH_RANGE
        pushZombiesInAimCone()
        wait(WRESTLER_DAMAGE_DELAY, Wait.IGNORE_CONDITION)
        damage(eventPlayer, eventPlayer.wrestlerThrowDamageCredit, WRESTLER_THROW_DAMAGE)
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    # A pickup/release request made during the short damage wait is handled next.
    if ruleCondition:
        loop()


macro initializeWrestlerMacro():
    # Shared enhancement storage starts in the numeric idle state.
    eventPlayer.enhancementCarryState = WrestlerCarryState.NONE
