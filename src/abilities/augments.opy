#!mainFile "../../main.opy"

macro augmentMovementBlocked = eventPlayer.isAttached or eventPlayer.hasStatus(Status.ROOTED) or eventPlayer.isCrowdControlled


rule "PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)":
    @Event eachPlayer
    @Team 1
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    eventPlayer.augmentId = (eventPlayer.augmentId + (Augment.SURVIVALIST if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 1)) % (Augment.SURVIVALIST + 1)


rule "CROUCH + INTERACT (LASER BARRICADE)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementCarryState == WrestlerCarryState.NONE) == true
    @Condition (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown == 0) == true

    placeLaserBarricadeAugmentMacro()


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
    if eventAbility in [null, Button.MELEE]:
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


rule "DOUBLE TAP JUMP (DASH / HIGHRISE)":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE])
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    # The rule starts on the first press. Time the release and second press separately.
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), AIR_ACTION_RELEASE_WINDOW)
    if eventPlayer.isHoldingButton(Button.JUMP):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), AIR_ACTION_SECOND_PRESS_WINDOW)
    if not ruleCondition:
        return

    # Recheck movement restrictions on the second press. Each action owns its cooldown.
    if not augmentMovementBlocked:
        if eventPlayer.augmentId == Augment.DASH:
            useDashAirActionMacro()
        else:
            useHighriseAirActionMacro()
    # Consume the second press before the rule can accept a new pair.
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)


#!include "augment_grapnel_launcher.opy"


rule "AMMO PACK MAGAZINES":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId == Augment.AMMO_PACK)
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
        eventPlayer.augmentAmmoLoadout = [eventPlayer.getHero(), eventPlayer.getCurrentWeapon(), eventPlayer.getMaxAmmo(0) * AMMO_PACK_CAPACITY_MULTIPLIER, eventPlayer.getMaxAmmo(1) * AMMO_PACK_CAPACITY_MULTIPLIER]
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
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId == Augment.AMMO_PACK)
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
    #!define augmentAmmoReloadFinished tmp2
    #!define augmentAmmoPreviousClipAmmo tmp3
    for augmentAmmoFallbackClipIndex in range(2):
        augmentAmmoNativeCapacity = eventPlayer.getMaxAmmo(augmentAmmoFallbackClipIndex)
        # Snapshot the ammo before reload for this clip's Widowmaker fallback.
        augmentAmmoPreviousClipAmmo = eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex + 3]
        # Recheck for each clip because Set Ammo on the preceding clip may change reload state.
        augmentAmmoReloadFinished = eventPlayer.augmentAmmoFallbackState[2] and not eventPlayer.isReloading()
        if augmentAmmoNativeCapacity > 0 and eventPlayer.augmentAmmoLoadout[augmentAmmoFallbackClipIndex + 2] > augmentAmmoNativeCapacity and (eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) == augmentAmmoNativeCapacity and (eventPlayer.augmentAmmoFallbackState[augmentAmmoFallbackClipIndex] or augmentAmmoReloadFinished) or eventPlayer.getHero() == Hero.WIDOWMAKER and augmentAmmoReloadFinished and eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) < augmentAmmoNativeCapacity and (eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) > augmentAmmoPreviousClipAmmo or augmentAmmoPreviousClipAmmo > augmentAmmoNativeCapacity)):
            # A refill rose from below native full, or a completed reload reset
            # an overfilled clip to native full. Descending through native full
            # while firing, and cancelled/partial reloads, must not grant ammo.
            # Widow can fire on the frame her reload finishes. Restore the bonus
            # while preserving those spent rounds (34/35 becomes 69/35).
            eventPlayer.setAmmo(augmentAmmoFallbackClipIndex, eventPlayer.getAmmo(augmentAmmoFallbackClipIndex) + eventPlayer.augmentAmmoLoadout[augmentAmmoFallbackClipIndex + 2] - augmentAmmoNativeCapacity)
    # Refresh the live flags and retain the pre-reload snapshots in slots 3 and 4.
    eventPlayer.augmentAmmoFallbackState[0] = eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0)
    eventPlayer.augmentAmmoFallbackState[1] = eventPlayer.getAmmo(1) < eventPlayer.getMaxAmmo(1)
    eventPlayer.augmentAmmoFallbackState[2] = eventPlayer.isReloading()
