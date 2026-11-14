#!mainFile "../main.opy"

#!define AUGMENT_KEVLAR_ARMOR 75
#!define AUGMENT_KEVLAR_RANGED_DMG_RESIST 50
#!define AUGMENT_KEVLAR_KNOCKBACK_RESIST 50
#!define AUGMENT_GRAPNEL_RANGE 40
#!define AUGMENT_GRAPNEL_MIN_RANGE 7
#!define AUGMENT_GRAPNEL_SPEED 40
#!define AUGMENT_GRAPNEL_COOLDOWN 16
#!define AUGMENT_GRAPNEL_TIMEOUT 1.5
#!define augmentGrapnelCenter(player) ((player.getPosition() + player.getEyePosition()) * 0.5)
#!define AUGMENT_GRAPNEL_MOVEMENT_BLOCKED (eventPlayer.isAttached or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled)
#!define AUGMENT_GRAPNEL_CAN_MOVE (eventPlayer.hasSpawned() and eventPlayer.isAlive() and not AUGMENT_GRAPNEL_MOVEMENT_BLOCKED)


rule "AUGMENT MENU":
    # Like the primary enhancement HUD, this is created once and reevaluates per viewer.
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            " ",
            f"+{AUGMENT_KEVLAR_ARMOR} armor, {AUGMENT_KEVLAR_KNOCKBACK_RESIST}% knockback resistance. {AUGMENT_KEVLAR_RANGED_DMG_RESIST}% resistance to ranged and ability dmg.",
            f"Dash in your movement direction with {DASH_PHASE_DURATION}s invulnerability. Stores {DASH_MAX_CHARGES} charges; restores one every {DASH_COOLDOWN}s.",
            "Launch upward and gain +20% dmg until landing. Activate with Jump in midair or a double-tap. cd: 16s.",
            "Triple melee reach; weapon hits at extended range deal 75% dmg. Push visible zombies ahead within 10m. Push cd: 9s.",
            "Double magazine capacity. Fully reloading restores the extra ammo.",
            "Grapple to allies or zombies 7–40m away. 35 dmg; stun grounded zombies or knock airborne ones down for 3s. cd: 16s.",
            f"Deploy a wall that blocks zombies. Hold Crouch + Interact to aim; release Interact to place. cd: {LASER_BARRICADE_COOLDOWN}s.",
            f"Packs: 2x healing, -1 infection, +{AUGMENT_APOTHECARY_ULT_CHARGE}% ult. Ult grants a teleport to your last used pack.",
            "Carry 2 extra powerups. Eliminations: 7% chance to gain a powerup. Loot fills your active slot, then backpack.",
            "Heal for 15% of dmg dealt. Gain 50 recoverable health."
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

    if eventPlayer.augmentId != Augment.APOTHECARY or eventPlayer.getHero() in [Hero.DVA, Hero.DMON]:
        return

    # D.Va/D.Mon recharge on ultimate damage in PLAYER DEALT DAMAGE instead.
    # Other heroes use the activation edge, not the lasting ultimate state.
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

    # Keep both buttons held for 0.25 seconds; interruption preserves the charge.
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.augmentId != Augment.APOTHECARY:
        return

    eventPlayer.augmentApothecaryReady = false
    # Play Effect snapshots departure before Teleport; no scratch or effect entity.
    # Bolt Strike's 1.5 flash scaled by three.
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 4.5)
    # Choose only when teleporting; keep the saved point reserved for actual pickups.
    eventPlayer.teleport(eventPlayer.augmentApothecaryPosition if eventPlayer.augmentApothecaryPosition != null else random.choice(healthpackPositionList))


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


def useAugmentAirAction():
    @Name "useAugmentAirAction"

    # Competing handlers cannot produce two impulses for one input: Dash is only
    # called from the tap sequence, HIGHRISE checks its cooldown timestamp on
    # this press (expiry alone must not trigger).
    if not (eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled) and not eventPlayer.isAttached:
        if eventPlayer.augmentId == Augment.DASH:
            useDashAirActionMacro()
        elif eventPlayer.augmentId == Augment.HIGHRISE:
            useHighriseAirActionMacro()


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
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.augmentGrapnelTarget.getPosition() + Vector.UP, LONG_REACH_IMPACT_SIZE)
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
    eventPlayer.augmentBarrierPlacementCooldown = LASER_BARRICADE_COOLDOWN
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
