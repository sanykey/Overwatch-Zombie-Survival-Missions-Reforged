#!mainFile "../main.opy"

# Combat HUD order on the left: roster (player slot), enhancement (97),
# augment (98), Jetpack fuel (99), carried powerup (100).
# Attachment status belongs to the enhancement and shares its sort order.

rule "ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)":
    @Condition isGameplayActive == true
    # One table-driven call replaces the thirteen per-enhancement HUD cases; the
    # subtitle and color entries hold the same conditional expressions, which
    # reevaluate per viewer exactly as the previous per-player calls did.
    hudText(
        # Only the zero ID gates visibility: dummies and unspawned players keep
        # NO_PREFERENCE because initializePlayerEnhancement never runs for them.
        getPlayers(Team.1),
        ENHANCEMENT_ICONS[localPlayer.enhancementId],
        [
            "",
            "+60% critical damage | +20% vs bosses",
            f"Press [{inputBindingString(Button.MELEE)}] to deal {floor(localPlayer.infectionLevel)}00 damage {iconString(Icon.CHECKMARK)}" if localPlayer.infectionLevel >= 1 else "Build up infection",
            "Ignites nearby targets",
            "Infection Reduced: {0} lvls".format(localPlayer.enhancementPlagueCureTotal),
            f"{localPlayer.enhancementBattleResetCharges}/2 resets {iconString(Icon.CHECKMARK) if localPlayer.enhancementBattleResetCharges > 0 else ''}",
            "{1} {0}".format(f"{ceil(localPlayer.enhancementBatteryPlacementCooldown)}s" if localPlayer.enhancementBatteryPlacementCooldown > 0 else iconString(Icon.CHECKMARK), "Hold [{0}]".format(inputBindingString(Button.MELEE)) if localPlayer.enhancementBatteryPlacementCooldown <= 0 else ""),
            "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if localPlayer.enhancementIsHitchhiking else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(localPlayer).any(lambda x: not x.isAttached and distance(localPlayer, x) < 2 * x.sizeScale) else "",
            f"{ceil(localPlayer.enhancementPupCooldown)}s" if localPlayer.enhancementPupCooldown > 0 else iconString(Icon.CHECKMARK),
            f"Hold [{inputBindingString(Button.MELEE)}] to charge | Energy: {floor(localPlayer.enhancementCapacitorEnergy)} | Charged: {floor(localPlayer.enhancementCapacitorCharge)}",
            f"Stacks: {localPlayer.enhancementBulkStacks} | +{min(100, localPlayer.enhancementBulkStacks * 0.5)}% Max Life | Size: {localPlayer.sizeScale}x | Hold [{inputBindingString(Button.MELEE)}] to toggle size",
            f"{max(0, ceil(localPlayer.enhancementHoldUntil - getTotalTimeElapsed()))}s | [{inputBindingString(Button.INTERACT)}] to throw" if localPlayer.enhancementHeldZombie != null else f"Aim at a vulnerable zombie | [{inputBindingString(Button.INTERACT)}] to pick up",
            # Armed replaces the charge hint: arming zeroes energy and requires burst == 0, so the states are exclusive.
            "{1}{0}".format(" | Armed" if localPlayer.enhancementBoltBurst != 0 else " | Hold [{0}] to charge next attack".format(inputBindingString(Button.MELEE)) if localPlayer.enhancementBoltEnergy >= 350 else "", f"Energy: {floor(localPlayer.enhancementBoltEnergy)}/350"),
            f"Scrap: {floor(localPlayer.enhancementScrap)}/{ENGINEER_SCRAP_MAX} | Hold [{inputBindingString(Button.CROUCH)}] ({ENGINEER_ARMOR_HOLD_DURATION}s): {ENGINEER_ARMOR_STACK} armor ({ENGINEER_ARMOR_COST}) | Hold [{inputBindingString(Button.MELEE)}]: turret ({ENGINEER_TURRET_COST})"
        ][localPlayer.enhancementId],
        [" ", "Brain Killer", "Zombie Hybrid", "Pyrotechnic", "Plague Doctor", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P.", "Overcharge", "Bulking Season", "Wrestler", "Bolt Strike", "Engineer"][localPlayer.enhancementId],
        HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE,
        [
            Color.WHITE, Color.WHITE,
            Color.RED if localPlayer.enhancementHybridCooldown > 0 else Color.GREEN if localPlayer.infectionLevel >= 1 else Color.WHITE,
            Color.WHITE, Color.WHITE,
            [Color.WHITE, Color.LIME_GREEN, Color.GREEN][localPlayer.enhancementBattleResetCharges],
            Color.RED if localPlayer.enhancementBatteryPlacementCooldown > 0 else Color.GREEN,
            Color.WHITE, Color.WHITE,
            Color.YELLOW if localPlayer.enhancementCapacitorCharge > 0 else Color.GREEN if localPlayer.enhancementCapacitorEnergy >= 100 else Color.WHITE,
            Color.WHITE, Color.WHITE,
            Color.YELLOW if localPlayer.enhancementBoltBurst != 0 else Color.GREEN if localPlayer.enhancementBoltEnergy >= 350 else Color.WHITE,
            # Engineer's name reads gray until the scrap balance covers the cost
            # of one armor throw, then green.
            Color.GRAY if localPlayer.enhancementScrap < ENGINEER_ARMOR_COST else Color.GREEN
        ][localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )

    # One table-driven call replaces the per-player generic and Laser Barricade
    # HUD cases; subtitle/color expressions reevaluate per viewer exactly as the
    # previous per-player calls did. Read live owned state directly: no temporary
    # may be captured by color reevaluation.
    hudText(
        # Only the zero ID gates visibility: dummies and unspawned players keep
        # NO_PREFERENCE because initializePlayerAugment never runs for them.
        getPlayers(Team.1),
        AUGMENT_ICONS[localPlayer.augmentId],
        "{2} {1} {0}".format(f"{localPlayer.augmentBarrierPlacementCooldown}s" if localPlayer.augmentBarrierPlacementCooldown > 0 else iconString(Icon.CHECKMARK), " {0}HP".format(ceil(localPlayer.augmentBarrierHealth)) if localPlayer.augmentBarrierHealth > 0 else [], f"Hold [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.INTERACT)}] to place a barricade" if localPlayer.augmentBarrierPlacementCooldown <= 0 else []) if localPlayer.augmentId == Augment.LASER_BARRICADE else "{1} | {0}".format(
            (iconString(Icon.CHECKMARK) if localPlayer.augmentDashCharges == AUGMENT_DASH_MAX_CHARGES else f"{ceil(localPlayer.augmentDashReadyAt - getTotalTimeElapsed())}s {iconString(Icon.CHECKMARK)}" if localPlayer.augmentDashCharges > 0 else f"{ceil(localPlayer.augmentDashReadyAt - getTotalTimeElapsed())}s") if localPlayer.augmentId == Augment.DASH else (iconString(Icon.CHECKMARK) if getTotalTimeElapsed() >= localPlayer.augmentMovementReadyAt else f"{ceil(localPlayer.augmentMovementReadyAt - getTotalTimeElapsed())}s"),
            f"Extended reach | [{inputBindingString(Button.MELEE)}] knockback" if localPlayer.augmentId == Augment.LONG_REACH else f"[{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]" if localPlayer.augmentId == Augment.GRAPNEL_LAUNCHER else f"[{inputBindingString(Button.JUMP)}] in midair / double-tap | +20% dmg until landing" if localPlayer.augmentId == Augment.HIGHRISE else f"{localPlayer.augmentDashCharges}/2 | double-tap [{inputBindingString(Button.JUMP)}]"
        ) if localPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else (f"Hold [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.INTERACT)}] | {iconString(Icon.CHECKMARK)}" if localPlayer.augmentApothecaryReady and (localPlayer.augmentApothecaryPosition != null or healthpackPositionList != []) else "Use ultimate to charge teleport") if localPlayer.augmentId == Augment.APOTHECARY else f"Backpack: {len(localPlayer.augmentScavengerBackpack)}/2 | Crouch + Interact to store/swap | Hold [{inputBindingString(Button.RELOAD)}] to drop all" if localPlayer.augmentId == Augment.SCAVENGER else [" ", "+75 armor | incoming ranged/ability dmg −50%", " ", " ", "Extended melee reach", "Double magazine capacity", " ", " ", " ", " ", "15% lifesteal | +50 health"][localPlayer.augmentId],
        AUGMENT_NAMES[localPlayer.augmentId],
        HudPosition.ACTUALLY_LEFT, 98, Color.WHITE, Color.WHITE,
        (Color.RED if localPlayer.augmentBarrierPlacementCooldown > 0 else Color.GREEN) if localPlayer.augmentId == Augment.LASER_BARRICADE else ((Color.RED if localPlayer.augmentDashCharges == 0 else Color.GREEN) if localPlayer.augmentId == Augment.DASH else (Color.RED if getTotalTimeElapsed() < localPlayer.augmentMovementReadyAt else Color.GREEN)) if localPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else ([Color.WHITE, Color.GREEN, Color.YELLOW][len(localPlayer.augmentScavengerBackpack)] if localPlayer.augmentId == Augment.SCAVENGER else Color.WHITE),
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )

    # One persistent fuel HUD for all viewers; sort 99 stays above item HUD (100).
    hudSubheader(
        localPlayer if localPlayer.powerUpJetpackFuel > 0 else null,
        f"jetpack fuel: {ceil(localPlayer.powerUpJetpackFuel)}/{POWERUP_JETPACK_FUEL_MAX}",
        HudPosition.ACTUALLY_LEFT, 99, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )

    # Attachment status subheaders: one persistent call each for the passenger
    # and the carrier, reevaluated per viewer; the carrier-side text reads the
    # passenger back-reference instead of scanning for it.
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.enhancementIsHitchhiking),
        "Attached to {0} {1}".format(heroIcon(localPlayer.enhancementHitchhikerCarrier.getHero()), localPlayer.enhancementHitchhikerCarrier),
        HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.enhancementHitchhikerPassenger != null and player.enhancementHitchhikerPassenger.enhancementIsHitchhiking),
        "{0} {1} is attached".format(heroIcon(localPlayer.enhancementHitchhikerPassenger.getHero()), localPlayer.enhancementHitchhikerPassenger),
        HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )


macro initializePlayerEnhancement():
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        # No preference and late-join zero state receive one real choice before
        # its state is initialized. Retain the selected ID across later spawns.
        eventPlayer.enhancementId = random.randint(Enhancement.BRAIN_KILLER, Enhancement.ENGINEER)
    #Zombie Hybrid
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        # enhancementHybridCooldown: remaining explosion cooldown in seconds (20 on use), for activation checks and HUD.
        startDamageModification(eventPlayer, getPlayers(Team.2), 90)
        eventPlayer.explosionScale = 1.25
        eventPlayer.explosionInnerColor = Color.GRAY
        eventPlayer.explosionOuterColor = Color.LIME_GREEN
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLevel, 0, 0.015 if eventPlayer.infectionLevel > 0 else 0)
    switch eventPlayer.enhancementId:
        case Enhancement.BRAIN_KILLER:
            # No enhancement state slots: bonus damage is calculated directly from the damage event.
            # HUD lives in ENHANCEMENT HUD (PERMANENT TABLE).
            break
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            # enhancementPyroHitList: hit queue; repeated targets determine their damage per second when the queue is processed.
            eventPlayer.enhancementPyroHitList = []
            break
        #Plague Doctor
        case Enhancement.PLAGUE_DOCTOR:
            # enhancementPlagueCureTotal: accumulated infection levels removed, including cure bonuses, displayed in the HUD.
            # Permanent +30% healing; infected targets receive another x1.25 (x1.625 total).
            eventPlayer.setHealingDealt(130)
            startHealingModification(getPlayers(Team.1).filter(lambda player: player.isInfected), eventPlayer, 125, HealingReeval.RECEIVERS_AND_HEALERS)
            eventPlayer.enhancementPlagueCureTotal = 0
            break
        case Enhancement.OVERCHARGE:
            eventPlayer.enhancementCapacitorEnergy = 0
            eventPlayer.enhancementCapacitorCharge = 0
            eventPlayer.enhancementCapacitorDeadline = 0
            # Baseline existing match stats; do not pay for healing/assists before selection/join.
            eventPlayer.enhancementCapacitorStatsSnapshot = overchargeEarnedEnergyTotal(eventPlayer)
            break
        case Enhancement.BULKING_SEASON:
            eventPlayer.enhancementBulkStacks = 0
            eventPlayer.enhancementBulkNormalSize = false
            break
        case Enhancement.DEAD_WEIGHT:
            # This shared slot must start as a player reference or null, never
            # a previous enhancement's number/array/color. Pickup sets its deadline.
            eventPlayer.enhancementHeldZombie = null
            break
        case Enhancement.BOLT_STRIKE:
            eventPlayer.enhancementBoltEnergy = 0
            eventPlayer.enhancementBoltBurst = 0
            break
        #Engineer
        case Enhancement.ENGINEER:
            # Scrap storage stays untouched here: it starts at zero, survives
            # death and hero switches, and is swept per match by START GAME.
            # Only beam state is re-cleaned; death cleanup already destroyed it.
            # Baseline existing match assists; do not pay for pre-selection ones.
            eventPlayer.enhancementScrapBeamEntity = null
            eventPlayer.enhancementScrapBeamTarget = null
            eventPlayer.engineerScrapAssistSnapshot = earnedAssists(eventPlayer)
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            #Enhancement: Born to Battle
            # enhancementBattleResetCharges: 0-2 earned ability resets; final blows add one and each reset consumes one.
            # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
            eventPlayer.enhancementBattleResetCharges = 0
            break
        #Charge Battery
        case Enhancement.CHARGE_BATTERY:
            #Enhancement: Charge Battery
            # enhancementBatteryPosition: placed battery position in world coordinates, for effects and player proximity checks.
            # enhancementBatteryReuseCooldown: remaining battery reuse cooldown in seconds, for the progress bar and availability visuals.
            # enhancementBatteryReuseDuration: full battery reuse cooldown in seconds (10), used to start the timer and scale progress.
            # enhancementBatteryPlacementCooldown: remaining placement cooldown in seconds (20 on placement), for placement checks and HUD.
            #Battery placement visual
            createEffect(eventPlayer.filter(lambda _: eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.enhancementBatteryPlacementCooldown <= 0 and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Effect.RING, Color.GREEN, worldVector(0.1 * Vector.UP, eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), 0.45, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
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
            # Shared-health subheaders live in ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES).
            eventPlayer.enhancementHitchhikerCarrier = 0
            eventPlayer.enhancementHitchhikerCarrier.startGrantingAssistFor(eventPlayer)
            break
        #P.U.P.
        case Enhancement.PUP:
            #Enhancement Selection: P.U.P.
            # enhancementPupColor: current drone color, indicating its mode in the sphere and beam.
            # enhancementIsPupBeamActive: whether the attack beam is active; also controls its sound and pauses cooldown decay.
            # enhancementPupTarget: current enemy target, shared by movement, attack and target cleanup rules; null when idle.
            # enhancementIsPupFreezeAuraActive: whether the freezing aura effect is visible around the target.
            # enhancementPupPosition: chased drone position in world coordinates, for movement, effects and attack direction.
            # enhancementPupCooldown: remaining ability cooldown in seconds (2 after freezing, 1 after laser), gating target selection.
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

macro initializePlayerAugment():
    if eventPlayer.augmentId == Augment.NO_PREFERENCE:
        # Menu non-selection and late-join zero state each receive one real
        # random choice. A nonzero ID preserves explicit and previously rolled choices.
        eventPlayer.augmentId = random.randint(Augment.KEVLAR, Augment.LEECH)
    if eventPlayer.augmentId == Augment.SCAVENGER:
        eventPlayer.augmentScavengerBackpack = []
    if eventPlayer.augmentId == Augment.DASH:
        eventPlayer.augmentDashCharges = AUGMENT_DASH_MAX_CHARGES
    if eventPlayer.augmentId == Augment.LASER_BARRICADE:
        #Augment: Laser Barricade
        # augmentBarrierFacing: horizontal unit direction saved at placement, to reconstruct both push reference points.
        # augmentBarrierEdgeDirection: unit direction from corner 1 to corner 2, cached for zombie collision checks.
        # augmentBarrierPlacementCooldown: -1 while aiming; otherwise remaining placement cooldown in seconds (30 on placement), for checks and HUD.
        # augmentBarrierPosition: placed barrier center in world coordinates, for collision checks, push points and HP text.
        # augmentBarrierCorner1: first lower corner in world coordinates, for beams and collision geometry.
        # augmentBarrierCorner2: second lower corner in world coordinates, for beams and the along-barrier direction.
        # augmentBarrierHealth: current barrier health (10000 on placement), for blocking, damage, regeneration and HUD.
        # HUD lives in AUGMENT HUD (PERMANENT TABLE).
        #Barricade placement visual
        createBeam(eventPlayer.filter(lambda _: eventPlayer.augmentBarrierPlacementCooldown == -1 and eventPlayer.isHoldingButton(Button.INTERACT) and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * LASER_BARRICADE_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade bottom
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierPosition != null), Beam.BAD, eventPlayer.augmentBarrierCorner1, eventPlayer.augmentBarrierCorner2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade side 1
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner1 + LASER_BARRICADE_HEIGHT * Vector.UP, eventPlayer.augmentBarrierCorner1, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade side 2
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner2, eventPlayer.augmentBarrierCorner2 + LASER_BARRICADE_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade top
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner2 + LASER_BARRICADE_HEIGHT * Vector.UP, eventPlayer.augmentBarrierCorner1 + LASER_BARRICADE_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Barricade health
        createInWorldText(getAllPlayers() if eventPlayer.augmentBarrierHealth > 0 else null, "{0}HP".format(ceil(eventPlayer.augmentBarrierHealth)), eventPlayer.augmentBarrierPosition + Vector.UP, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)
    # HUD lives in AUGMENT HUD (PERMANENT TABLE).
    if eventPlayer.augmentId in [Augment.KEVLAR, Augment.LEECH]:
        # Share the native-health readiness gate; keep both pools recoverable.
        waitUntil(eventPlayer.initialMaxHealth > 0, Math.INFINITY)
        if eventPlayer.augmentId == Augment.KEVLAR:
            eventPlayer.addHealthPool(Health.ARMOR, AUGMENT_KEVLAR_ARMOR, true, false)
        else:
            eventPlayer.addHealthPool(Health.NORMAL, 50, true, false)


rule "PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameplayActive == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isHeroSwitchRespawn == false

    # Initialize the enhancement before the augment's health-readiness wait.
    initializePlayerEnhancement()
    initializePlayerAugment()
