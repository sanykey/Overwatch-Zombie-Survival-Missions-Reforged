#!mainFile "../main.opy"

subroutine extendAugmentMelee
subroutine useAugmentAirAction

#!define AUGMENT_NAMES ["No Preference", "Kevlar", "Shock Landing", "Double Jump", "Long Reach", "Ammo Pack", "Grapnel Launcher", "Laser Barricade", "Apothecary", "Scavenger", "Survivalist"]
#!define AUGMENT_DASH_PHASE_DURATION 0.5
#!define AUGMENT_DASH_COOLDOWN 13
#!define AUGMENT_DASH_WAVE_RADIUS 6
#!define AUGMENT_DASH_WAVE_IMPULSE 32
#!define AUGMENT_JUMP_IMPULSE 14.4
#!define AUGMENT_JUMP_TAP_WINDOW 0.3
#!define AUGMENT_MELEE_RADIUS 2.5
#!define AUGMENT_MELEE_PUSH_COOLDOWN 9
#!define AUGMENT_MELEE_PUSH_IMPULSE 25
#!define AUGMENT_MELEE_PUSH_RADIUS 10
#!define AUGMENT_WEAPON_REACH_MULTIPLIER 3
#!define AUGMENT_VENDETTA_RADIUS 4.3
#!define AUGMENT_VENDETTA_WINDUP 0.15
#!define AUGMENT_VENDETTA_INTERVAL 0.6
#!define AUGMENT_IMPACT_SIZE 0.4
#!define AUGMENT_MELEE_WEAPON_HEROES [Hero.REINHARDT, Hero.BRIGITTE, Hero.DMON, Hero.GENJI, Hero.RAMATTRA, Hero.TORBJORN]
#!define AUGMENT_MELEE_BUTTON_WEAPON_HEROES [Hero.REINHARDT, Hero.BRIGITTE, Hero.TORBJORN]
#!define AUGMENT_GRAPNEL_RANGE 40
#!define AUGMENT_GRAPNEL_MIN_RANGE 7
#!define AUGMENT_GRAPNEL_SPEED 40
#!define AUGMENT_GRAPNEL_COOLDOWN 16
#!define AUGMENT_GRAPNEL_TIMEOUT 1.5
#!define augmentGrapnelCenter(player) ((player.getPosition() + player.getEyePosition()) * 0.5)
#!define AUGMENT_GRAPNEL_MOVEMENT_BLOCKED (eventPlayer.isAttached or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.KNOCKED_DOWN))
#!define AUGMENT_GRAPNEL_CAN_MOVE (eventPlayer.hasSpawned() and eventPlayer.isAlive() and not AUGMENT_GRAPNEL_MOVEMENT_BLOCKED)

# Only synchronous melee query inputs use global scratch storage. Callers set
# these AFTER their windup wait; the helper consumes them without yielding or HUD capture.
# [native radius, augmented radius, view angle].
#!define augmentMeleeBounds tmp0
# Native radius is dead after the query; reuse that array entry for health.
#!define augmentMeleeHealthBeforeDamage augmentMeleeBounds[0]
#!define augmentMeleeDamage tmp1
# The helper snapshots targets once, then deals damage per player without yielding.
#!define augmentMeleeTargets tmp2
# Shock Landing samples movement on the second Jump press. This scratch vector is
# consumed by the impulse before the collision-cleanup wait; it has no live captures.
#!define augmentDashDirection tmp0


rule "AUGMENT MENU":
    # Like the primary enhancement HUD, this is created once and reevaluates per viewer.
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            "",
            "Gain 75 armor that helps protect against infection",
            "Press Jump again in midair: landing shockwave deals 40 damage and pushes nearby zombies; movement input adds a dash. Phased and invulnerable for 0.5s. cd: 13s",
            "Jump in midair / double-tap Jump. First hit of 30+ damage in flight or within 0.5s after landing: +50%. cd: 16s",
            "Triple Quick Melee, melee weapon, Dragonblade and Carnage reach. Press Melee to push visible zombies ahead within 10m; cd: 9s only with targets",
            "Carry twice the ammo per full magazine; full reloads restore the bonus",
            "Crouch + Jump: grapple 7-40m; hit for 35 damage; stun grounded targets for 0.5s or knock airborne targets down for 3s. cd: 16s",
            "Hold Crouch + Interact to aim a zombie-blocking wall; release Interact to deploy. cd: 30s",
            f"Health packs: 2x healing, -1 infection, +{AUGMENT_APOTHECARY_ULT_CHARGE}% ult. Ultimate grants 1 teleport (hold Crouch + Interact) to the last pack used, or a random known pack if none used",
            "Crouch + Interact: stash (2 slots). Interact: active slot. Hold Reload: drop all. Bot eliminations: 5% loot, backpack first",
            "15% lifesteal, +50 recoverable health"
        ][localPlayer.augmentId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.INTERACT)),
        HudPosition.ACTUALLY_LEFT, 4, AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )


rule "PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    eventPlayer.augmentId = (eventPlayer.augmentId + 1) % (Augment.LEECH + 1)


rule "APOTHECARY ULTIMATE RECHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isUsingUltimate() == true

    if eventPlayer.augmentId != Augment.APOTHECARY:
        return

    # Activation edge only: spending during a lasting ultimate cannot recharge it.
    eventPlayer.augmentApothecaryReady = true


rule "APOTHECARY TELEPORT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentApothecaryReady == true
    @Condition (eventPlayer.augmentApothecaryPosition != null or healthpackPositionList != []) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.enhancementId != Enhancement.DEAD_WEIGHT or eventPlayer.enhancementHeldZombie == null) == true

    # Keep both buttons held for 0.2 seconds; interruption preserves the charge.
    wait(0.2, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.augmentId != Augment.APOTHECARY:
        return

    eventPlayer.augmentApothecaryReady = false
    # Play Effect snapshots departure before Teleport; no scratch or effect entity.
    # Bolt Strike's 1.5 flash scaled by three.
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 4.5)
    # Choose only when teleporting; keep the saved point reserved for actual pickups.
    eventPlayer.teleport(eventPlayer.augmentApothecaryPosition if eventPlayer.augmentApothecaryPosition != null else random.choice(healthpackPositionList))


rule "AUGMENT AIR ACTION RECHARGE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId in [Augment.PHASE_DASH, Augment.DOUBLE_JUMP]
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isOnGround() == false

    # Arm once per airborne interval, only after the takeoff button is released.
    # This avoids spending the extra jump on the game's first airborne input tick.
    eventPlayer.augmentIsAirActionReady = false
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    if eventPlayer.isAlive() and not eventPlayer.isOnGround():
        eventPlayer.augmentIsAirActionReady = true
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.augmentIsAirActionReady = false
    if ruleCondition:
        loop()


rule "AUGMENT AIR ACTION INPUT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId in [Augment.PHASE_DASH, Augment.DOUBLE_JUMP]
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.augmentIsAirActionReady == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    useAugmentAirAction()


rule "DOUBLE JUMP DOUBLE TAP":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Only press edges update the timestamp. A blocked native jump can leave the
    # player grounded; its second press still launches without cancelling abilities.
    if eventPlayer.augmentJumpLastPressedAt > 0 and getTotalTimeElapsed() - eventPlayer.augmentJumpLastPressedAt <= AUGMENT_JUMP_TAP_WINDOW:
        eventPlayer.augmentJumpLastPressedAt = 0
        if eventPlayer.isOnGround() or eventPlayer.augmentIsAirActionReady:
            useAugmentAirAction()
    else:
        eventPlayer.augmentJumpLastPressedAt = getTotalTimeElapsed()


rule "DOUBLE JUMP BONUS ENTER FLIGHT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.augmentJumpBonusState != null
    @Condition eventPlayer.augmentJumpBonusState[0] > 0
    @Condition eventPlayer.augmentJumpBonusState[0] != Math.INFINITY
    @Condition eventPlayer.isOnGround() == false

    # Positive deadline is the initial launch grace; only the first flight may
    # extend it indefinitely. Negative deadlines mean the landing window began.
    eventPlayer.augmentJumpBonusState[0] = Math.INFINITY


rule "DOUBLE JUMP BONUS LANDING WINDOW":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.augmentJumpBonusState != null
    @Condition eventPlayer.augmentJumpBonusState[0] == Math.INFINITY
    @Condition eventPlayer.isOnGround() == true

    eventPlayer.augmentJumpBonusState[0] = -(getTotalTimeElapsed() + 0.5)


rule "DOUBLE JUMP BONUS EXPIRES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.augmentJumpBonusState != null
    @Condition (not isGameplayActive or not eventPlayer.isAlive() or eventPlayer.getHero() != eventPlayer.augmentJumpBonusState[1] or getTotalTimeElapsed() >= abs(eventPlayer.augmentJumpBonusState[0])) == true

    eventPlayer.augmentJumpBonusState = null


def useAugmentAirAction():
    @Name "useAugmentAirAction"

    # Check the timestamp on this press; expiry alone must not trigger a held Jump.
    # Double Jump has no waits, so competing airborne / double-tap handlers share
    # one atomic cooldown gate and cannot produce two impulses for the same press.
    if getTotalTimeElapsed() >= eventPlayer.augmentMovementReadyAt and not (eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.hasStatus(Status.STUNNED) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN) or eventPlayer.hasStatus(Status.KNOCKED_DOWN)) and not eventPlayer.isAttached:
        eventPlayer.augmentIsAirActionReady = false
        if eventPlayer.augmentId == Augment.PHASE_DASH:
            eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + AUGMENT_DASH_COOLDOWN
            # Pending landing hero survives the phase and subsequent flight;
            # scratch direction is consumed before the phase-cleanup wait.
            eventPlayer.augmentDashHero = eventPlayer.getHero()
            augmentDashDirection = eventPlayer.getThrottle()
            # Reduce each axis to -1/0/1: adjacent inputs always make a 45-degree
            # diagonal, independent of their relative strength. Opposite inputs
            # cancel in Workshop's movement vector; zero input arms only the wave.
            augmentDashDirection = vect(1 if augmentDashDirection.x > 0 else -1 if augmentDashDirection.x < 0 else 0, 0, 1 if augmentDashDirection.z > 0 else -1 if augmentDashDirection.z < 0 else 0)
            # Preserve longer protection already granted by revival or late joining.
            if not eventPlayer.hasStatus(Status.INVINCIBLE):
                eventPlayer.setStatusEffect(null, Status.INVINCIBLE, AUGMENT_DASH_PHASE_DURATION)
            eventPlayer.disablePlayerCollision()
            if augmentDashDirection != vect(0, 0, 0):
                eventPlayer.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle() + horizontalAngleOfDirection(augmentDashDirection), -15), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
            # Readiness is already spent; cleanup must also survive landing/death/hero changes.
            wait(AUGMENT_DASH_PHASE_DURATION, Wait.IGNORE_CONDITION)
            eventPlayer.enablePlayerCollision()
        else:
            eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + 16
            eventPlayer.applyImpulse(Vector.UP, AUGMENT_JUMP_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
            # Initial grace also expires if a native ability prevents liftoff.
            # Once airborne, its first landing starts the final 0.5-second window.
            eventPlayer.augmentJumpBonusState = [getTotalTimeElapsed() + 0.5, eventPlayer.getHero()]


rule "PHASE DASH LANDING WAVE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.PHASE_DASH
    @Condition eventPlayer.augmentDashHero != null
    @Condition (eventPlayer.isOnGround() or not isGameplayActive or not eventPlayer.isAlive() or eventPlayer.getHero() != eventPlayer.augmentDashHero) == true

    # First landing consumes the wave independently of the phase-cleanup timer.
    # Death, hero change and game end clear it without emitting a wave.
    if isGameplayActive and eventPlayer.isAlive() and eventPlayer.getHero() == eventPlayer.augmentDashHero:
        # Query once at the landing position. All scratch slots are synchronous;
        # no target list, index or health snapshot survives another wait.
        #!define augmentDashWaveTargets tmp0
        #!define augmentDashWaveTargetIndex tmp1
        # Actual health loss gates Pyrotechnic, as in the other scripted attacks.
        #!define augmentDashHealthBeforeDamage tmp2
        augmentDashWaveTargets = getPlayersInRadius(eventPlayer.getEyePosition(), AUGMENT_DASH_WAVE_RADIUS * eventPlayer.sizeScale + 2, Team.2, LosCheck.SURFACES).filter(lambda zombie: zombie.isAlive() and not zombie.botIsTeleporting and distance(eventPlayer, zombie) <= AUGMENT_DASH_WAVE_RADIUS * eventPlayer.sizeScale)
        # Keep the 32-strength push, halving the former 13-degree upward angle.
        for augmentDashWaveTargetIndex in range(len(augmentDashWaveTargets)):
            if not augmentDashWaveTargets[augmentDashWaveTargetIndex].botIsAttached and augmentDashWaveTargets[augmentDashWaveTargetIndex].botKnockbackScale > 0:
                augmentDashWaveTargets[augmentDashWaveTargetIndex].applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, augmentDashWaveTargets[augmentDashWaveTargetIndex])), -6.5), AUGMENT_DASH_WAVE_IMPULSE * augmentDashWaveTargets[augmentDashWaveTargetIndex].botKnockbackScale, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                augmentDashWaveTargets[augmentDashWaveTargetIndex].setEnvironmentalKillCreditor(eventPlayer)
            # Push before damage so lethal hits keep the existing impulse/kill credit.
            augmentDashHealthBeforeDamage = augmentDashWaveTargets[augmentDashWaveTargetIndex].getHealth()
            damage(augmentDashWaveTargets[augmentDashWaveTargetIndex], eventPlayer, 40)
            # Script damage has no Event Ability: enqueue only real hits, keeping
            # the existing burn stacking/cap and preventing periodic-damage recursion.
            if eventPlayer.enhancementId == Enhancement.PYROTECHNIC and augmentDashWaveTargets[augmentDashWaveTargetIndex].getHealth() < augmentDashHealthBeforeDamage and distance(eventPlayer, augmentDashWaveTargets[augmentDashWaveTargetIndex]) < 15:
                augmentDashWaveTargets[augmentDashWaveTargetIndex].setStatusEffect(eventPlayer, Status.BURNING, 3)
                eventPlayer.enhancementPyroHitList.append(augmentDashWaveTargets[augmentDashWaveTargetIndex])
    eventPlayer.augmentDashHero = null


rule "GRAPNEL LAUNCHER":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Cooldown is checked on the input edge; holding the chord through expiry
    # cannot auto-launch. A miss does not consume the cooldown.
    if getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt or AUGMENT_GRAPNEL_MOVEMENT_BLOCKED:
        return
    eventPlayer.augmentGrapnelTarget = sorted(getPlayersInRadius(eventPlayer.getEyePosition(), AUGMENT_GRAPNEL_RANGE + 2, Team.2, LosCheck.SURFACES).filter(lambda zombie: zombie.isAlive() and not zombie.botIsTeleporting and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(zombie)) >= AUGMENT_GRAPNEL_MIN_RANGE and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(zombie)) <= AUGMENT_GRAPNEL_RANGE and eventPlayer.isInViewAngle(augmentGrapnelCenter(zombie), 8) and isInLoS(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(zombie))), lambda zombie: distance(eventPlayer, zombie))[0]
    if eventPlayer.augmentGrapnelTarget == null:
        return
    eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + AUGMENT_GRAPNEL_COOLDOWN
    eventPlayer.augmentGrapnelState = [eventPlayer.getHero(), 0]
    # Same white Grapple beam as the sentry turret. Its two endpoints reevaluate
    # body centers, retaining only this augment's player slots across the pull.
    createBeam(getAllPlayers(), Beam.GRAPPLE, augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget), Color.WHITE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.augmentGrapnelState[1] = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)
    # Keep world/player collisions and attack inputs intact. Only an active pull
    # updates movement; every exit reaches cleanup, even after releasing the chord.
    while isGameplayActive and AUGMENT_GRAPNEL_CAN_MOVE and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0] and eventPlayer.augmentGrapnelTarget.isAlive() and eventPlayer.augmentGrapnelTarget.getTeam() == Team.2 and not eventPlayer.augmentGrapnelTarget.botIsTeleporting and isInLoS(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)) and getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt - (AUGMENT_GRAPNEL_COOLDOWN - AUGMENT_GRAPNEL_TIMEOUT):
        if distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)) <= 1.5 * eventPlayer.sizeScale + 0.5 * eventPlayer.augmentGrapnelTarget.sizeScale:
            # Pull velocity scratch is dead on contact. Read health synchronously;
            # no scratch value survives a wait or is captured by the cable.
            #!define augmentGrapnelHealthBeforeDamage tmp0
            augmentGrapnelHealthBeforeDamage = eventPlayer.augmentGrapnelTarget.getHealth()
            damage(eventPlayer.augmentGrapnelTarget, eventPlayer, 35)
            # Script hits have no Event Ability. Like Long Reach, feed actual
            # Pyrotechnic hits to the existing burn worker without enabling DoT recursion.
            if eventPlayer.enhancementId == Enhancement.PYROTECHNIC and eventPlayer.augmentGrapnelTarget.getHealth() < augmentGrapnelHealthBeforeDamage and distance(eventPlayer, eventPlayer.augmentGrapnelTarget) < 15:
                eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.BURNING, 3)
                eventPlayer.enhancementPyroHitList.append(eventPlayer.augmentGrapnelTarget)
            if eventPlayer.augmentGrapnelTarget.isOnGround():
                eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.STUNNED, 0.5)
            else:
                eventPlayer.augmentGrapnelTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 3)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.augmentGrapnelTarget.getPosition() + Vector.UP, AUGMENT_IMPACT_SIZE)
            break
        # Synchronous scratch: correct current velocity to the desired velocity,
        # rather than stacking 40-speed impulses every frame. Consumed before wait.
        #!define augmentGrapnelVelocityDelta tmp0
        augmentGrapnelVelocityDelta = directionTowards(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)) * AUGMENT_GRAPNEL_SPEED - eventPlayer.getVelocity()
        eventPlayer.applyImpulse(augmentGrapnelVelocityDelta, magnitude(augmentGrapnelVelocityDelta), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait(0.05, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.augmentGrapnelState[1])
    # Stop the pull on arrival/wall/timeout, but preserve a new hero's movement,
    # native crowd-control knockback, and movement controlled by a carrier.
    if AUGMENT_GRAPNEL_CAN_MOVE and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0]:
        eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, magnitude(eventPlayer.getVelocity()), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.augmentGrapnelTarget = null
    eventPlayer.augmentGrapnelState = null


rule "GRAPNEL LAUNCHER DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1
    @Condition eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER
    @Condition eventPlayer.augmentGrapnelState != null

    # Follow the project's supplied playerLeft cleanup pattern: consume the
    # departing player's effect ID synchronously in the departure event.
    destroyEffect(eventPlayer.augmentGrapnelState[1])


rule "LONG REACH MELEE PUSH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true

    # Button edge only: readiness/phase in Actions prevent a held press from
    # automatically firing on cooldown expiry or when a target enters range.
    if not isGameplayActive or eventPlayer.augmentId != Augment.LONG_REACH or getTotalTimeElapsed() < eventPlayer.augmentMeleePushReadyAt:
        return
    if [eventPlayer.hasStatus(Status.STUNNED), eventPlayer.hasStatus(Status.ASLEEP), eventPlayer.hasStatus(Status.FROZEN), eventPlayer.hasStatus(Status.KNOCKED_DOWN)].any():
        return
    # One synchronous spatial query per ready press, independent of native or
    # scripted damage attribution. Existing global scratch is dead before return;
    # no waits, damage, asynchronous calls or HUD/effect captures use these roles.
    #!define augmentPushTargets tmp0
    #!define augmentPushTargetIndex tmp1
    #!define augmentPushTarget tmp2
    augmentPushTargets = getPlayersInRadius(eventPlayer, AUGMENT_MELEE_PUSH_RADIUS * eventPlayer.sizeScale, Team.2, LosCheck.SURFACES).filter(lambda zombie: zombie.isAlive() and not zombie.botIsTeleporting and not zombie.botIsAttached and zombie.botKnockbackScale > 0 and eventPlayer.isInViewAngle(zombie.getEyePosition(), 30))
    if augmentPushTargets == []:
        return
    eventPlayer.augmentMeleePushReadyAt = getTotalTimeElapsed() + AUGMENT_MELEE_PUSH_COOLDOWN
    for augmentPushTargetIndex in range(len(augmentPushTargets)):
        augmentPushTarget = augmentPushTargets[augmentPushTargetIndex]
        augmentPushTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, augmentPushTarget)), -15), AUGMENT_MELEE_PUSH_IMPULSE * augmentPushTarget.botKnockbackScale, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        augmentPushTarget.setEnvironmentalKillCreditor(eventPlayer)


rule "LONG REACH QUICK MELEE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isMeleeing() == true
    @Condition eventPlayer.getHero() not in [Hero.REINHARDT, Hero.BRIGITTE]
    @Condition (eventPlayer.getHero() != Hero.TORBJORN or eventPlayer.getCurrentWeapon() != 2) == true
    @Condition (eventPlayer.getHero() != Hero.VENDETTA or not eventPlayer.isFiringPrimaryFire()) == true
    @Condition (eventPlayer.getHero() != Hero.JUNKER_QUEEN or not eventPlayer.isUsingAbility2()) == true
    @Condition eventPlayer.isUsingUltimate() == false

    if eventPlayer.augmentId != Augment.LONG_REACH:
        return

    eventPlayer.augmentMeleeHero = eventPlayer.getHero()
    wait(0.15, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.getHero() != eventPlayer.augmentMeleeHero:
        return
    augmentMeleeBounds = [AUGMENT_MELEE_RADIUS, AUGMENT_MELEE_RADIUS * AUGMENT_WEAPON_REACH_MULTIPLIER, 30]
    augmentMeleeDamage = 60 if eventPlayer.getHero() == Hero.ZENYATTA else 70 if eventPlayer.getHero() == Hero.VENTURE else 40
    extendAugmentMelee()


rule "LONG REACH VENDETTA SWORD":
    @Event eachPlayer
    @Team 1
    @Hero vendetta
    # These conditions cancel a committed swing; releasing primary fire does not.
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.hasStatus(Status.STUNNED) == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == false

    if not isGameplayActive or eventPlayer.augmentId != Augment.LONG_REACH:
        return

    # Trigger and windup have separate lifetimes: a short click commits one hit,
    # while held input keeps using the configured repeat timer.
    # The idle wait only watches input; validate the actor before committing a hit.
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isFiringPrimaryFire(), Math.INFINITY)
    if not ruleCondition:
        return
    # Adapted from the supplied Vendetta implementation: extend only the outer
    # annulus, retain windup/LoS/cone checks, and leave energy/other abilities alone.
    wait(AUGMENT_VENDETTA_WINDUP, Wait.ABORT_WHEN_FALSE)
    augmentMeleeBounds = [AUGMENT_VENDETTA_RADIUS, AUGMENT_VENDETTA_RADIUS * AUGMENT_WEAPON_REACH_MULTIPLIER, 30]
    augmentMeleeDamage = 45
    extendAugmentMelee()
    # Native primary-fire state can remain true through a held attack series.
    # Release rearms the next click; after recovery, the loop gate rechecks the actor.
    # Scratch query values are consumed before this wait and rebuilt on every hit.
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), AUGMENT_VENDETTA_INTERVAL - AUGMENT_VENDETTA_WINDUP)
    if ruleCondition:
        loop()


rule "LONG REACH MELEE WEAPONS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHero() in AUGMENT_MELEE_WEAPON_HEROES
    @Condition (eventPlayer.getHero() != Hero.GENJI or eventPlayer.isUsingUltimate()) == true
    @Condition (eventPlayer.getHero() != Hero.DMON or not eventPlayer.isInAlternateForm()) == true
    @Condition (eventPlayer.getHero() not in [Hero.DMON, Hero.RAMATTRA] or not eventPlayer.isMeleeing()) == true
    @Condition (eventPlayer.getHero() != Hero.TORBJORN or eventPlayer.getCurrentWeapon() == 2) == true
    # Nemesis does not reliably report Is Using Ability 1 / Is In Alternate Form.
    # Its extra armor exceeds 40% of the spawn health in all standard queues.
    # Use the spawn snapshot so health scaling works and Hitchhiker's live health
    # pools cannot turn an active Nemesis back into a staff attack here.
    @Condition (eventPlayer.getHero() != Hero.RAMATTRA or eventPlayer.getMaxHealthOfType(Health.ARMOR) > eventPlayer.initialMaxHealth * 0.4) == true
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition (eventPlayer.getHero() == Hero.RAMATTRA or not eventPlayer.isUsingAbility1()) == true
    @Condition (eventPlayer.getHero() == Hero.TORBJORN or not eventPlayer.isUsingAbility2()) == true
    @Condition (not eventPlayer.isUsingUltimate() or eventPlayer.getHero() in [Hero.GENJI, Hero.BRIGITTE, Hero.RAMATTRA]) == true
    @Condition eventPlayer.hasStatus(Status.STUNNED) == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == false

    if eventPlayer.augmentId != Augment.LONG_REACH:
        return

    waitUntil((eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.getHero() in AUGMENT_MELEE_BUTTON_WEAPON_HEROES and eventPlayer.isHoldingButton(Button.MELEE)) and (eventPlayer.isFiringPrimaryFire() or eventPlayer.getHero() in AUGMENT_MELEE_BUTTON_WEAPON_HEROES and eventPlayer.isMeleeing()), Math.INFINITY)
    if not ruleCondition:
        return
    # Build the profile after idle input, so a hero switch during the idle wait
    # cannot retain a previous hero's windup. One owner-only profile survives
    # the hit/recovery waits: [hero, native range, direct
    # damage, windup, recovery]. All extended attacks use a 30-degree view angle.
    # Like Vendetta, held swings use an
    # approximate cadence rather than polling or depending on a native hit target.
    # Genji's blade cadence includes the October swing-speed increase.
    # Timers do not copy native combo/perk effects.
    eventPlayer.augmentWeaponProfile = [
        [Hero.REINHARDT, 4, 100, 0.4, 0.56],
        [Hero.BRIGITTE, 6, 45, 0.2, 0.4],
        [Hero.DMON, 4, 60, 0.2, 0.456],
        [Hero.GENJI, 5, 100, 0.15, 0.7 / 1.15 - 0.15],
        [Hero.RAMATTRA, 10, 65, 0.15, 0.45],
        [Hero.TORBJORN, 2.5, 70, 0.35, 0.35]
    ][AUGMENT_MELEE_WEAPON_HEROES.index(eventPlayer.getHero())]
    wait(eventPlayer.augmentWeaponProfile[3], Wait.ABORT_WHEN_FALSE)
    if eventPlayer.getHero() != eventPlayer.augmentWeaponProfile[0]:
        return
    augmentMeleeBounds = [eventPlayer.augmentWeaponProfile[1], eventPlayer.augmentWeaponProfile[1] * AUGMENT_WEAPON_REACH_MULTIPLIER, 30]
    augmentMeleeDamage = eventPlayer.augmentWeaponProfile[2]
    extendAugmentMelee()
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not (eventPlayer.getHero() in AUGMENT_MELEE_BUTTON_WEAPON_HEROES and eventPlayer.isHoldingButton(Button.MELEE)), eventPlayer.augmentWeaponProfile[4])
    if ruleCondition:
        loop()


rule "LONG REACH CARNAGE":
    @Event eachPlayer
    @Team 1
    @Hero junkerQueen
    # @Condition isGameplayActive == true
    # @Condition eventPlayer.augmentId == Augment.LONG_REACH
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true

    if eventPlayer.augmentId != Augment.LONG_REACH:
        return

    # Carnage is a committed ability, not a repeating primary-fire timer.
    wait(0.75, Wait.ABORT_WHEN_FALSE)
    augmentMeleeBounds = [5, 5 * AUGMENT_WEAPON_REACH_MULTIPLIER, 30]
    augmentMeleeDamage = 90
    extendAugmentMelee()


def extendAugmentMelee():
    @Name "extendAugmentMelee"

    augmentMeleeTargets = getPlayersInRadius(eventPlayer.getEyePosition(), augmentMeleeBounds[1] * eventPlayer.sizeScale + 2, Team.2, LosCheck.SURFACES).filter(lambda target: target.isAlive() and distance(eventPlayer, target) > augmentMeleeBounds[0] * eventPlayer.sizeScale and distance(eventPlayer, target) <= augmentMeleeBounds[1] * eventPlayer.sizeScale and eventPlayer.isInViewAngle(target.getEyePosition(), augmentMeleeBounds[2]))
    # The caller's hero snapshot is no longer read after the windup; reuse its
    # owner-only slot as a synchronous index. Each Damage receives one player.
    for eventPlayer.augmentMeleeTargetIndex in range(len(augmentMeleeTargets)):
        # Reuse the dead native-radius entry, preserving the other query metadata.
        augmentMeleeHealthBeforeDamage = augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex].getHealth()
        damage(augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex], eventPlayer, augmentMeleeDamage)
        # Script Damage has no Event Ability, so the native-hit Pyrotechnic rule
        # deliberately ignores it. Queue only hits which actually removed health;
        # the existing burn worker keeps its stacking/cap/boss behavior and cannot recurse.
        if augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex].getHealth() < augmentMeleeHealthBeforeDamage:
            if eventPlayer.enhancementId == Enhancement.PYROTECHNIC and distance(eventPlayer, augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex]) < 15:
                augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex].setStatusEffect(eventPlayer, Status.BURNING, 3)
                eventPlayer.enhancementPyroHitList.append(augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex])
            elif eventPlayer.enhancementId == Enhancement.OVERCHARGE and eventPlayer.enhancementCapacitorCharge > 0:
                # Extended hits have no Event Ability; apply the armed bonus here.
                # The native-event rule excludes scripted damage, preventing recursion.
                if eventPlayer.enhancementCapacitorDeadline == 0:
                    eventPlayer.enhancementCapacitorDeadline = getTotalTimeElapsed() + 0.3
                if getTotalTimeElapsed() < eventPlayer.enhancementCapacitorDeadline:
                    damage(augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex], eventPlayer, eventPlayer.enhancementCapacitorCharge)
    if augmentMeleeTargets != []:
        # One impact per swing, on the nearest hit target. Rounded from 0.3 to 0.4
        # (about one third larger); Grapnel Launcher uses the same impact size.
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, sorted(augmentMeleeTargets, lambda target: distance(eventPlayer, target))[0].getPosition() + Vector.UP, AUGMENT_IMPACT_SIZE)


rule "AMMO PACK MAGAZINES":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.AMMO_PACK
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false

    # Cache once per hero/weapon, so respawns and returning to an earlier loadout
    # cannot repeatedly double an already enlarged magazine. No polling loop.
    # Disarm the previous loadout's refill snapshot during the initialization wait.
    eventPlayer.augmentAmmoFallbackState = null
    if not eventPlayer.augmentAmmoLoadoutList:
        eventPlayer.augmentAmmoLoadoutList = []
    eventPlayer.augmentAmmoLoadout = eventPlayer.augmentAmmoLoadoutList.filter(lambda loadout: loadout[0] == eventPlayer.getHero() and loadout[1] == eventPlayer.getCurrentWeapon())[0]
    if eventPlayer.augmentAmmoLoadout == null:
        eventPlayer.augmentAmmoLoadout = [eventPlayer.getHero(), eventPlayer.getCurrentWeapon(), eventPlayer.getMaxAmmo(0) * 2, eventPlayer.getMaxAmmo(1) * 2]
        # Workshop Append To Array concatenates arrays; wrap the row to retain nesting.
        eventPlayer.augmentAmmoLoadoutList.append([eventPlayer.augmentAmmoLoadout])
    # Only write real magazines with a readable, positive capacity. In particular,
    # a single-magazine weapon must not receive a zero write to the unused clip 1.
    # Scratch inputs live only through this synchronous loop, not the wait below.
    #!define augmentAmmoClipIndex tmp0
    #!define augmentAmmoTargetCapacity tmp1
    #!define augmentAmmoNewRounds tmp2
    for augmentAmmoClipIndex in range(2):
        augmentAmmoTargetCapacity = eventPlayer.augmentAmmoLoadout[augmentAmmoClipIndex + 2]
        if augmentAmmoTargetCapacity > 0:
            # Preserve spent ammo when revisiting a loadout; no free reload on weapon swaps.
            augmentAmmoNewRounds = eventPlayer.getAmmo(augmentAmmoClipIndex) + max(0, augmentAmmoTargetCapacity - eventPlayer.getMaxAmmo(augmentAmmoClipIndex))
            # Freeze the persistent capacity action's inputs before the loop or
            # other rules reuse these global scratch slots (including after reloads).
            eventPlayer.setMaxAmmo(evalOnce(augmentAmmoClipIndex), evalOnce(augmentAmmoTargetCapacity))
            eventPlayer.setAmmo(augmentAmmoClipIndex, augmentAmmoNewRounds)
    # Give the engine a frame before priming the refill fallback. Cached player
    # state survives this wait; no global scratch value is retained across it.
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.augmentAmmoFallbackState = [eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1), eventPlayer.isReloading(), eventPlayer.getAmmo(0), eventPlayer.getAmmo(1)] if (eventPlayer.augmentAmmoLoadout[2] > eventPlayer.getMaxAmmo(0) and eventPlayer.getMaxAmmo(0) > 0 or eventPlayer.augmentAmmoLoadout[3] > eventPlayer.getMaxAmmo(1) and eventPlayer.getMaxAmmo(1) > 0) else null
    waitUntil(eventPlayer.getHero() != eventPlayer.augmentAmmoLoadout[0] or eventPlayer.getCurrentWeapon() != eventPlayer.augmentAmmoLoadout[1] or not eventPlayer.hasSpawned() or not eventPlayer.isAlive(), Math.INFINITY)
    if ruleCondition:
        loop()


rule "AMMO PACK REFILL FALLBACK":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.AMMO_PACK
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.getHero() == eventPlayer.augmentAmmoLoadout[0]
    @Condition eventPlayer.getCurrentWeapon() == eventPlayer.augmentAmmoLoadout[1]
    @Condition eventPlayer.augmentAmmoFallbackState != null
    @Condition ((eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0)) != eventPlayer.augmentAmmoFallbackState[0] or (eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1)) != eventPlayer.augmentAmmoFallbackState[1] or eventPlayer.isReloading() != eventPlayer.augmentAmmoFallbackState[2]) == true

    # Some heroes (including Widowmaker) accept Set Ammo but ignore Set Max Ammo.
    # Watch only the native-full boundary and reload edges, not every fired round.
    if eventPlayer.isReloading() and not eventPlayer.augmentAmmoFallbackState[2]:
        eventPlayer.augmentAmmoFallbackState[3] = eventPlayer.getAmmo(0)
        eventPlayer.augmentAmmoFallbackState[4] = eventPlayer.getAmmo(1)
    # These temporary inputs are synchronous; the handler has no waits/captures.
    #!define augmentAmmoFallbackClipIndex tmp0
    #!define augmentAmmoNativeCapacity tmp1
    for augmentAmmoFallbackClipIndex in range(2):
        augmentAmmoNativeCapacity = eventPlayer.getMaxAmmo(augmentAmmoFallbackClipIndex)
        if augmentAmmoNativeCapacity > 0 and eventPlayer.augmentAmmoLoadout[augmentAmmoFallbackClipIndex + 2] > augmentAmmoNativeCapacity and (eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) == augmentAmmoNativeCapacity and (eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex] or eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()) or eventPlayer.getHero() == Hero.WIDOWMAKER and eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading() and eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) < augmentAmmoNativeCapacity and (eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) > eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3] or eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3] > augmentAmmoNativeCapacity)):
            # A refill rose from below native full, or a completed reload reset
            # an overfilled clip to native full. Descending through native full
            # while firing, and cancelled/partial reloads, must not grant ammo.
            # Widow can fire on the frame her reload finishes. Restore the bonus
            # while preserving those spent rounds (34/35 becomes 69/35).
            eventPlayer.setAmmo(augmentAmmoFallbackClipIndex, eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) + eventPlayer.augmentAmmoLoadout[augmentAmmoFallbackClipIndex + 2] - augmentAmmoNativeCapacity)
    eventPlayer.augmentAmmoFallbackState = [eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1), eventPlayer.isReloading(), eventPlayer.augmentAmmoFallbackState[3], eventPlayer.augmentAmmoFallbackState[4]]


rule "LASER BARRICADE (PLACEMENT)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.LASER_BARRICADE
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.augmentBarrierPlacementCooldown == 0
    @Condition (eventPlayer.enhancementId != Enhancement.DEAD_WEIGHT or eventPlayer.enhancementHeldZombie == null) == true

    # -1 latches aiming; Interact may reserve -2 for a consumed Dead Weight press.
    # Clear the placement latch on every exit before starting the normal cooldown.
    eventPlayer.augmentBarrierPlacementCooldown = -1
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), 0.5)
    if not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead():
        eventPlayer.augmentBarrierPlacementCooldown = 0
        return
    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.BLUE, eventPlayer.getEyePosition() + ((directionFromAngles(eventPlayer.getHorizontalFacingAngle() + random.uniform(-5, 5), eventPlayer.getVerticalFacingAngle() + random.uniform(-5, 5))) * 1.5), 0.1)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.getPosition(), 75)
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), Math.INFINITY)
    eventPlayer.augmentBarrierPlacementCooldown = 0
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    #Laser Barrier health
    eventPlayer.augmentBarrierHealth = 10000
    #Barrier center point
    eventPlayer.augmentBarrierPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.augmentBarrierCorner1 = eventPlayer.augmentBarrierPosition + worldVector((-0.5 * LASER_BARRICADE_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.augmentBarrierCorner2 = eventPlayer.augmentBarrierPosition + worldVector((0.5 * LASER_BARRICADE_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    # Horizontal push direction captured at placement; reference points are center +/- this vector.
    eventPlayer.augmentBarrierFacing = directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    # Along-barrier direction, reused by collision checks.
    eventPlayer.augmentBarrierEdgeDirection = directionTowards(eventPlayer.augmentBarrierCorner1, eventPlayer.augmentBarrierCorner2)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.augmentBarrierPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.augmentBarrierPosition, 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.augmentBarrierPlacementCooldown = 25
    while eventPlayer.augmentBarrierPlacementCooldown > 0:
        wait(1)
        eventPlayer.augmentBarrierPlacementCooldown += -1


rule "LASER BARRICADE BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.LASER_BARRICADE
    #Barrier health is greater than 0
    @Condition eventPlayer.augmentBarrierHealth > 0
    #Horizontal distance check
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(eventPlayer.augmentBarrierPosition, vect(player.getPosition().x, eventPlayer.augmentBarrierPosition.getPosition().y, player.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) == true
    #If feet are below highest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_HEIGHT) == true
    #If eyes are above lowest point of wall
    @Condition getLivingPlayers(Team.2).any(lambda player: player.getEyePosition().y > eventPlayer.augmentBarrierPosition.y) == true
    #Distance from wall
    @Condition getLivingPlayers(Team.2).any(lambda player: distance(vect(player.getPosition().x, eventPlayer.augmentBarrierCorner1.y, player.getPosition().z), eventPlayer.augmentBarrierCorner1 + eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, vect(player.getPosition().x, eventPlayer.augmentBarrierCorner1.y, player.getPosition().z) - eventPlayer.augmentBarrierCorner1))))) < 1.5) == true

    stopChasing(eventPlayer.augmentBarrierHealth)
    #Filter horizontal distance, feet height, eye height and distance from wall together.
    eventPlayer.augmentBarrierTargetList = getLivingPlayers(Team.2).filter(lambda target: (distance(eventPlayer.augmentBarrierPosition, vect(target.getPosition().x, eventPlayer.augmentBarrierPosition.getPosition().y, target.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) and (target.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_HEIGHT) and (target.getEyePosition().y > eventPlayer.augmentBarrierPosition.y) and (distance(vect(target.getPosition().x, eventPlayer.augmentBarrierCorner1.y, target.getPosition().z), eventPlayer.augmentBarrierCorner1 + eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, vect(target.getPosition().x, eventPlayer.augmentBarrierCorner1.y, target.getPosition().z) - eventPlayer.augmentBarrierCorner1))))) < 1.5))
    # barrierPushReferencePointList: both push reference points, reconstructed from saved geometry and consumed before wait.
    #!define barrierPushReferencePointList tmp1
    barrierPushReferencePointList = [eventPlayer.augmentBarrierPosition + eventPlayer.augmentBarrierFacing, eventPlayer.augmentBarrierPosition + eventPlayer.augmentBarrierFacing * -1]
    # barrierCollisionTargetIndex: barricade target index, to damage and push each zombie crossing the barrier.
    #!define barrierCollisionTargetIndex tmp0
    for barrierCollisionTargetIndex in range(len(eventPlayer.augmentBarrierTargetList)):
        # barrierCollisionTarget: current zombie, consumed by this iteration's damage/push actions before wait.
        #!define barrierCollisionTarget tmp2
        barrierCollisionTarget = eventPlayer.augmentBarrierTargetList[barrierCollisionTargetIndex]
        if not barrierCollisionTarget.hasStatus(Status.ROOTED):
            #Damage the barricade
            eventPlayer.augmentBarrierHealth -= barrierCollisionTarget.getMaxHealth() * 2.5
            barrierCollisionTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            damage(barrierCollisionTarget, eventPlayer, 10)
        if not magnitude(barrierCollisionTarget.getThrottle()):
            #If bot is not throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: distance(barrierCollisionTarget, x)))[0])), (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.augmentBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.augmentBarrierPosition, x)))).last())), (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.augmentBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.augmentBarrierHealth > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.augmentBarrierHealth <= 0:
            eventPlayer.augmentBarrierHealth = 1
    chaseAtRate(eventPlayer.augmentBarrierHealth, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()

# SCAVENGER BOT LOOT moved to "PLAYER EARNED ELIMINATION" in player_events.opy.
