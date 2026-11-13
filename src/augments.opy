#!mainFile "../main.opy"

subroutine extendAugmentMelee
subroutine useAugmentAirAction

#!define AUGMENT_KEVLAR_ARMOR 75
#!define AUGMENT_KEVLAR_RANGED_DMG_RESIST 50
#!define AUGMENT_DASH_COOLDOWN 14
#!define AUGMENT_DASH_MAX_CHARGES 2
#!define AUGMENT_DASH_PHASE_DURATION 1.7
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
#!define AUGMENT_GRAPNEL_RANGE 40
#!define AUGMENT_GRAPNEL_MIN_RANGE 7
#!define AUGMENT_GRAPNEL_SPEED 40
#!define AUGMENT_GRAPNEL_COOLDOWN 16
#!define AUGMENT_GRAPNEL_TIMEOUT 1.5
#!define augmentGrapnelCenter(player) ((player.getPosition() + player.getEyePosition()) * 0.5)
#!define AUGMENT_GRAPNEL_MOVEMENT_BLOCKED (eventPlayer.isAttached or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled)
#!define AUGMENT_GRAPNEL_CAN_MOVE (eventPlayer.hasSpawned() and eventPlayer.isAlive() and not AUGMENT_GRAPNEL_MOVEMENT_BLOCKED)

# Only synchronous melee query inputs use global scratch storage. Callers set
# these AFTER their windup wait; the helper consumes them without yielding or HUD capture.
# Native radius; every attack uses the same reach multiplier and 30-degree cone.
#!define augmentMeleeRadius tmp0
# The helper snapshots targets once, then deals damage per player without yielding.
# The radius is dead after the query, so both roles share the slot.
#!define augmentMeleeTargets tmp0
#!define augmentMeleeDamage tmp1
# Dash samples movement on the second Jump press. This scratch vector is
# consumed by the impulse immediately; it has no waits or live captures.
#!define augmentDashDirection tmp0


macro extendAugmentMeleeMacro(radius, damage):
    # Set synchronous scratch inputs after the caller's windup; no waits.
    augmentMeleeRadius = radius
    augmentMeleeDamage = damage
    extendAugmentMelee()


rule "AUGMENT MENU":
    # Like the primary enhancement HUD, this is created once and reevaluates per viewer.
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            "",
            f"Gain {AUGMENT_KEVLAR_ARMOR} armor. Incoming ranged and ability damage reduced by {AUGMENT_KEVLAR_RANGED_DMG_RESIST}%",
            f"Double-tap Jump: dash; movement input steers. {AUGMENT_DASH_MAX_CHARGES} charges, one restores every {AUGMENT_DASH_COOLDOWN}s. {AUGMENT_DASH_PHASE_DURATION}s invulnerability on activation",
            "Jump in midair / double-tap Jump. +20% damage from activation until you land. cd: 16s",
            "Triple Quick Melee, melee weapon, Dragonblade and Carnage reach. Press Melee to push visible zombies ahead within 10m; cd: 9s only with targets",
            "Carry twice the ammo per full magazine; full reloads restore the bonus",
            "Crouch + Jump: grapple 7-40m; enemies hit for 35 damage; stun grounded 0.5s / knock airborne down 3s; allies unharmed. cd: 16s",
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

    eventPlayer.augmentId = (eventPlayer.augmentId + (Augment.LEECH if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 1)) % (Augment.LEECH + 1)


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

    # Keep both buttons held for 0.25 seconds, matching Bolt Strike and
    # Overcharge; interruption preserves the charge.
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.augmentId != Augment.APOTHECARY:
        return

    eventPlayer.augmentApothecaryReady = false
    # Play Effect snapshots departure before Teleport; no scratch or effect entity.
    # Bolt Strike's 1.5 flash scaled by three.
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 4.5)
    # Choose only when teleporting; keep the saved point reserved for actual pickups.
    eventPlayer.teleport(eventPlayer.augmentApothecaryPosition if eventPlayer.augmentApothecaryPosition != null else random.choice(healthpackPositionList))


rule "DASH CHARGE RECHARGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.augmentDashCharges < AUGMENT_DASH_MAX_CHARGES
    @Condition getTotalTimeElapsed() >= eventPlayer.augmentDashReadyAt

    # The timer runs from the first spend below full (2 -> 1); spending the last
    # charge keeps it, so a fully spent meter resumes without a new dash.
    eventPlayer.augmentDashCharges += 1
    if eventPlayer.augmentDashCharges < AUGMENT_DASH_MAX_CHARGES:
        eventPlayer.augmentDashReadyAt = getTotalTimeElapsed() + AUGMENT_DASH_COOLDOWN


rule "DOUBLE JUMP RECHARGE":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.isAlive() == true
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


rule "DOUBLE JUMP AIR ACTION INPUT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.augmentIsAirActionReady == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    useAugmentAirAction()


rule "DOUBLE JUMP DOUBLE TAP":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Only press edges update the timestamp. A blocked native jump can leave the
    # player grounded; its second press still launches without cancelling abilities.
    if eventPlayer.augmentJumpLastPressedAt > 0 and getTotalTimeElapsed() - eventPlayer.augmentJumpLastPressedAt <= AUGMENT_JUMP_TAP_WINDOW:
        eventPlayer.augmentJumpLastPressedAt = 0
        if eventPlayer.isOnGround() or eventPlayer.augmentIsAirActionReady:
            useAugmentAirAction()
    else:
        eventPlayer.augmentJumpLastPressedAt = getTotalTimeElapsed()


rule "DASH DOUBLE TAP":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.isAlive() == true

    # Uniform press-release-press trigger on the ground and airborne: both gaps
    # use the shared tap window. Holding past a timeout restarts the sequence, so
    # a held button cannot re-fire; the charges gate lives in the dash action.
    # After a dash, the triggering press is fully consumed: the sequence waits for
    # its release and restarts from scratch, so a third quick press is only the
    # FIRST press of the next pair and cannot spend a second charge by itself.
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), AUGMENT_JUMP_TAP_WINDOW)
    if not eventPlayer.isHoldingButton(Button.JUMP):
        waitUntil(eventPlayer.isHoldingButton(Button.JUMP), AUGMENT_JUMP_TAP_WINDOW)
        if eventPlayer.isHoldingButton(Button.JUMP):
            useAugmentAirAction()
            waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    # Selection can change while a press/release wait is pending.
    if ruleCondition:
        loop()


rule "DASH SMOKE FADE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DASH
    @Condition eventPlayer.augmentDashSmokeEntity != null
    @Condition getTotalTimeElapsed() >= eventPlayer.augmentDashSmokeDeadline

    # No waits: cleanup and activation cannot retain a stale entity/deadline.
    # Clearing the handle also rearms this rule for the next window.
    destroyEffect(eventPlayer.augmentDashSmokeEntity)
    eventPlayer.augmentDashSmokeEntity = null
    # Recompute intake exactly with the aura's removal: a Super Nano or
    # ultimate resist active underneath must survive the dash window.
    applyDamageReceivedModifier()
    # Knockback immunity has no underlying source to fall back to.
    eventPlayer.setKnockbackReceived(100)


rule "KEVLAR RANGED DAMAGE COMPENSATION":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.augmentId == Augment.KEVLAR
    @Condition eventPlayer.isAlive() == true
    @Condition eventDamage > 0
    @Condition attacker != null
    @Condition attacker.getTeam() == Team.2

    # Refund half of the damage actually taken instead of a Set Damage Received
    # resist, so melee hits stay full-damage without proximity guesswork.
    # Scripted damage() has no ability (boss specials, DoT) and stays untouched.
    # Quick melee, zombie bites included, registers as Button.MELEE.
    if eventAbility == null or eventAbility == Button.MELEE:
        return

    # Native melee weapons pierce the compensation: they read as full damage
    # while their swing state is still active at the moment of impact.
    if attacker.getHero() == Hero.REINHARDT:
        if attacker.isFiringPrimaryFire():
            return
    elif attacker.getHero() == Hero.JUNKER_QUEEN:
        if attacker.isFiringSecondaryFire():
            return
    # elif attacker.getHero() == Hero.BRIGITTE:
    #     if attacker.isFiringPrimaryFire() or attacker.isMeleeing():
    #         return
    # elif attacker.getHero() == Hero.VENDETTA:
    #     if attacker.isFiringPrimaryFire():
    #         return
    # elif attacker.getHero() == Hero.TORBJORN:
    #     if attacker.getCurrentWeapon() == 2 and (attacker.isFiringPrimaryFire() or attacker.isMeleeing()):
    #         return

    heal(eventPlayer, null, eventDamage * (1 - AUGMENT_KEVLAR_RANGED_DMG_RESIST / 100))


rule "DOUBLE JUMP AIRBORNE DAMAGE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.DOUBLE_JUMP
    @Condition eventPlayer.augmentJumpDamageActive == true
    @Condition eventPlayer.isAlive() == true

    # Armed on activation. A grounded activation still lifts off from its own
    # impulse, so hold for that liftoff first; the bonus then lasts to landing.
    # Death breaks out of both waits and clears it.
    waitUntil(eventPlayer.isOnGround() == false or not eventPlayer.isAlive(), Math.INFINITY)
    applyDamageDealtModifier()
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.augmentJumpDamageActive = false
    applyDamageDealtModifier()


def useAugmentAirAction():
    @Name "useAugmentAirAction"

    # Competing handlers cannot produce two impulses for one input: Dash is only
    # called from the tap sequence, Double Jump checks its cooldown timestamp on
    # this press (expiry alone must not trigger).
    if not (eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled) and not eventPlayer.isAttached:
        if eventPlayer.augmentId == Augment.DASH:
            if eventPlayer.augmentDashCharges > 0:
                # The recharge timer starts when the meter first drops below full;
                # spending the last charge leaves the pending timer untouched.
                if eventPlayer.augmentDashCharges == AUGMENT_DASH_MAX_CHARGES:
                    eventPlayer.augmentDashReadyAt = getTotalTimeElapsed() + AUGMENT_DASH_COOLDOWN
                eventPlayer.augmentDashCharges += -1
                augmentDashDirection = eventPlayer.getThrottle()
                # Reduce each axis to -1/0/1: adjacent inputs always make a 45-degree
                # diagonal, independent of their relative strength. Opposite inputs
                # cancel in Workshop's movement vector; zero input grants protection only.
                augmentDashDirection = vect(1 if augmentDashDirection.x > 0 else -1 if augmentDashDirection.x < 0 else 0, 0, 1 if augmentDashDirection.z > 0 else -1 if augmentDashDirection.z < 0 else 0)
                # Every successful dash immediately starts a fresh 1.5s resist,
                # including while already protected. Do not defer renewal to expiry.
                # 100% damage resist instead of the INVINCIBLE status: that status keys
                # the DoT-clearing rule, which must not purge infection DoT/burning.
                # The smoke entity gates the resist, so open the window first and let
                # the recompute pick the strongest active protection (0 beats the
                # Super Nano / ultimate 50; it still clears together with the aura).
                # Keep one aura for overlapping dashes; only its deadline changes.
                # augmentIsAirActionReady shares this entity slot: only Double Jump
                # may write that alias, including on failed/cooldown activations.
                if eventPlayer.augmentDashSmokeEntity == null:
                    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, eventPlayer, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
                    eventPlayer.augmentDashSmokeEntity = getLastCreatedEntity()
                eventPlayer.augmentDashSmokeDeadline = getTotalTimeElapsed() + AUGMENT_DASH_PHASE_DURATION
                applyDamageReceivedModifier()
                # The window also nulls knockback received. Set Knockback Received
                # ignores scripted Apply Impulse pushes, which keep their own scaling.
                eventPlayer.setKnockbackReceived(0)
                # Zero movement input grants only the invulnerability: no impulse.
                # Otherwise a flat horizontal push: a downward pitch would fight the
                # floor when grounded and cancel the rising jump's momentum
                # (CANCEL_CONTRARY_MOTION), leaving an in-place dash without push.
                if augmentDashDirection != vect(0, 0, 0):
                    eventPlayer.applyImpulse(directionFromAngles(eventPlayer.getHorizontalFacingAngle() + horizontalAngleOfDirection(augmentDashDirection), 0), 21.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        elif eventPlayer.augmentId == Augment.DOUBLE_JUMP:
            eventPlayer.augmentIsAirActionReady = false
            if getTotalTimeElapsed() >= eventPlayer.augmentMovementReadyAt:
                eventPlayer.augmentMovementReadyAt = getTotalTimeElapsed() + 16
                eventPlayer.applyImpulse(Vector.UP, AUGMENT_JUMP_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
                # Arm the airborne damage bonus; the flight rule keeps it active
                # until this impulse's liftoff ends in a landing.
                eventPlayer.augmentJumpDamageActive = true


rule "GRAPNEL LAUNCHER":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # Cooldown is checked on the input edge; holding the chord through expiry
    # cannot auto-launch. A miss does not consume the cooldown.
    if getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt or AUGMENT_GRAPNEL_MOVEMENT_BLOCKED:
        return
    # Zombies and allies are both valid anchors; the closest candidate in the
    # aim cone wins. The all-team query includes this player, so self must go.
    eventPlayer.augmentGrapnelTarget = sorted(getPlayersInRadius(eventPlayer.getEyePosition(), AUGMENT_GRAPNEL_RANGE + 2, Team.ALL, LosCheck.SURFACES).filter(lambda target: target != eventPlayer and target.isAlive() and not target.botIsTeleporting and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(target)) >= AUGMENT_GRAPNEL_MIN_RANGE and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(target)) <= AUGMENT_GRAPNEL_RANGE and eventPlayer.isInViewAngle(augmentGrapnelCenter(target), 8) and isInLoS(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(target))), lambda target: distance(eventPlayer, target))[0]
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
    # Teams are fixed for the match, so the locked target's team cannot change.
    while isGameplayActive and AUGMENT_GRAPNEL_CAN_MOVE and eventPlayer.getHero() == eventPlayer.augmentGrapnelState[0] and eventPlayer.augmentGrapnelTarget.isAlive() and not eventPlayer.augmentGrapnelTarget.botIsTeleporting and isInLoS(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)) and getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt - (AUGMENT_GRAPNEL_COOLDOWN - AUGMENT_GRAPNEL_TIMEOUT):
        if distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(eventPlayer.augmentGrapnelTarget)) <= 1.5 * eventPlayer.sizeScale + 0.5 * eventPlayer.augmentGrapnelTarget.sizeScale:
            # Allies are harmless anchors: the pull simply ends there. Only
            # zombies take the impact damage, burn, crowd control and blast.
            if eventPlayer.augmentGrapnelTarget.getTeam() == Team.2:
                # Pull velocity scratch is dead on contact. Read health synchronously;
                # no scratch value survives a wait or is captured by the cable.
                damageWithEnhancements(35, eventPlayer.augmentGrapnelTarget)
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
    if eventPlayer.isCrowdControlled:
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
    extendAugmentMeleeMacro(AUGMENT_MELEE_RADIUS, 60 if eventPlayer.getHero() == Hero.ZENYATTA else 70 if eventPlayer.getHero() == Hero.VENTURE else 40)


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
    @Condition eventPlayer.isCrowdControlled == false

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
    extendAugmentMeleeMacro(AUGMENT_VENDETTA_RADIUS, 45)
    # Native primary-fire state can remain true through a held attack series.
    # Recovery is mandatory even on release, death or crowd control: clicks and
    # condition edges cannot restart this rule early after a successful swing.
    # Scratch query values are consumed before this wait and rebuilt on every hit.
    wait(AUGMENT_VENDETTA_INTERVAL - AUGMENT_VENDETTA_WINDUP, Wait.IGNORE_CONDITION)
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
    @Condition eventPlayer.isCrowdControlled == false

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
    # The numeric rows live in create numbers.js, in the same hero-list order.
    # Keep the hero snapshot in the retained player slot across both waits.
    eventPlayer.augmentWeaponProfile = [eventPlayer.getHero()].concat(numbersList.slice(NL_LONG_REACH_PROFILE_OFFSET + AUGMENT_MELEE_WEAPON_HEROES.index(eventPlayer.getHero()) * 4, 4))
    wait(eventPlayer.augmentWeaponProfile[3], Wait.ABORT_WHEN_FALSE)
    if eventPlayer.getHero() != eventPlayer.augmentWeaponProfile[0]:
        return
    extendAugmentMeleeMacro(eventPlayer.augmentWeaponProfile[1], eventPlayer.augmentWeaponProfile[2])
    # Do not let releasing either attack binding shorten recovery. Ignore rule
    # condition changes until it expires, then validate the actor at the loop gate.
    # compressed() rounds to three decimals; retain Genji's exact recovery here.
    wait(0.7 / 1.15 - 0.15 if eventPlayer.augmentWeaponProfile[0] == Hero.GENJI else eventPlayer.augmentWeaponProfile[4], Wait.IGNORE_CONDITION)
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
    extendAugmentMeleeMacro(5, 90)


def extendAugmentMelee():
    @Name "extendAugmentMelee"

    # Scale the scalar scratch once before the query, rather than per candidate.
    augmentMeleeRadius *= eventPlayer.sizeScale
    augmentMeleeTargets = getPlayersInRadius(eventPlayer.getEyePosition(), augmentMeleeRadius * AUGMENT_WEAPON_REACH_MULTIPLIER + 2, Team.2, LosCheck.SURFACES).filter(lambda target: target.isAlive() and distance(eventPlayer, target) > augmentMeleeRadius and distance(eventPlayer, target) <= augmentMeleeRadius * AUGMENT_WEAPON_REACH_MULTIPLIER and eventPlayer.isInViewAngle(target.getEyePosition(), 30))
    # The caller's hero snapshot is no longer read after the windup; reuse its
    # owner-only slot as a synchronous index. Each Damage receives one player.
    for eventPlayer.augmentMeleeTargetIndex in range(len(augmentMeleeTargets)):
        # Shared on-hit helpers preserve the target list (tmp0) and damage (tmp1).
        damageWithEnhancements(augmentMeleeDamage, augmentMeleeTargets[eventPlayer.augmentMeleeTargetIndex])
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
    #Blocked zombie: horizontal band, feet below wall top, eyes above wall base and distance from
    #the wall, all checked on the same zombie (separate gates could be satisfied by four different zombies).
    @Condition getLivingPlayers(Team.2).any(lambda player: (distance(eventPlayer.augmentBarrierPosition, vect(player.getPosition().x, eventPlayer.augmentBarrierPosition.getPosition().y, player.getPosition().z)) < 0.5 * LASER_BARRICADE_WIDTH) and (player.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_HEIGHT) and (player.getEyePosition().y > eventPlayer.augmentBarrierPosition.y) and (distance(vect(player.getPosition().x, eventPlayer.augmentBarrierCorner1.y, player.getPosition().z), eventPlayer.augmentBarrierCorner1 + eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, vect(player.getPosition().x, eventPlayer.augmentBarrierCorner1.y, player.getPosition().z) - eventPlayer.augmentBarrierCorner1))))) < 1.5)) == true

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
        # barrierImpulseVertical: shared vertical angle component of both impulse directions.
        #!define barrierImpulseVertical tmp3
        barrierImpulseVertical = (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.augmentBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))
        if not magnitude(barrierCollisionTarget.getThrottle()):
            #If bot is not throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: distance(barrierCollisionTarget, x)))[0])), barrierImpulseVertical), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.augmentBarrierPosition, x)))).last())), barrierImpulseVertical), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
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
