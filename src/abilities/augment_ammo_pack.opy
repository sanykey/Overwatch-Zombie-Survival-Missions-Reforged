#!mainFile "../../main.opy"

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
