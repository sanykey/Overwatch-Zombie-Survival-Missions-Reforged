#!mainFile "../main.opy"

# Combat HUD order on the left: roster (player slot), enhancement (97),
# augment (98), Jetpack fuel (99), carried powerup (100).
# Attachment status belongs to the enhancement and shares its sort order.

macro initializePlayerEnhancement():
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
            iconString(Icon.POISON),
            f"{ceil(eventPlayer.enhancementHybridCooldown)}s" if eventPlayer.enhancementHybridCooldown > 0 else f"Press [{inputBindingString(Button.MELEE)}] to deal {floor(eventPlayer.infectionLevel)}00 damage {iconString(Icon.CHECKMARK)}" if eventPlayer.infectionLevel >= 1 else "Build up infection",
            "Zombie Hybrid",
            HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.RED if eventPlayer.enhancementHybridCooldown > 0 else Color.GREEN if eventPlayer.infectionLevel >= 1 else Color.WHITE, HudReeval.STRING_AND_COLOR
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
                iconString(Icon.SKULL),
                "+60% critical damage | +20% vs bosses",
                "Brain Killer",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING
            )
            break
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            #Enhancement: Pyrotechnic
            hudText(
                eventPlayer,
                iconString(Icon.FIRE),
                "Ignites nearby targets",
                "Pyrotechnic",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING
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
                iconString(Icon.PLUS),
                "Infection Reduced: {0} lvls".format(eventPlayer.enhancementPlagueCureTotal),
                "Plague Doctor",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING
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
                EnhancementIcon.OVERCHARGE,
                f"Hold [{inputBindingString(Button.MELEE)}] to charge | Energy: {floor(eventPlayer.enhancementCapacitorEnergy)} | Charged: {floor(eventPlayer.enhancementCapacitorCharge)}",
                "Overcharge",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.YELLOW if eventPlayer.enhancementCapacitorCharge > 0 else Color.GREEN if eventPlayer.enhancementCapacitorEnergy >= 100 else Color.WHITE, HudReeval.STRING_AND_COLOR
            )
            break
        case Enhancement.BULKING_SEASON:
            eventPlayer.enhancementBulkStacks = 0
            hudText(
                eventPlayer,
                EnhancementIcon.BULKING_SEASON,
                f"Stacks: {eventPlayer.enhancementBulkStacks} | +{min(100, eventPlayer.enhancementBulkStacks * 0.5)}% Max Life | Size: {min(1.35, 1 + eventPlayer.enhancementBulkStacks * 0.005)}x",
                "Bulking Season",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING
            )
            break
        case Enhancement.DEAD_WEIGHT:
            # This shared slot must start as a player reference or null, never
            # a previous enhancement's number/array/color. Pickup sets its deadline.
            eventPlayer.enhancementHeldZombie = null
            hudText(
                eventPlayer, iconString(Icon.TRASHCAN),
                (f"{max(0, ceil(eventPlayer.enhancementHoldUntil - getTotalTimeElapsed()))}s | [{inputBindingString(Button.INTERACT)}] to throw" if eventPlayer.enhancementHeldZombie != null else f"Aim at a vulnerable zombie | [{inputBindingString(Button.INTERACT)}] to pick up"),
                "Dead Weight", HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING
            )
            break
        case Enhancement.BOLT_STRIKE:
            eventPlayer.enhancementBoltEnergy = 0
            eventPlayer.enhancementBoltBurst = 0
            hudText(
                eventPlayer, EnhancementIcon.BOLT_STRIKE,
                f"Energy: {floor(eventPlayer.enhancementBoltEnergy)}/350 | Hold [{inputBindingString(Button.MELEE)}] | Armed: {eventPlayer.enhancementBoltBurst != 0}",
                "Bolt Strike", HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.YELLOW if eventPlayer.enhancementBoltBurst != 0 else Color.GREEN if eventPlayer.enhancementBoltEnergy >= 350 else Color.WHITE, HudReeval.STRING_AND_COLOR
            )
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            #Enhancement: Born to Battle
            # enhancementBattleResetCharges: 0-2 earned ability resets; final blows add one and each reset consumes one.
            # enhancementBattleAbilityButton: selected ability button, retained through waits to reset its charge or cooldown.
            hudText(
                eventPlayer,
                EnhancementIcon.BORN_TO_BATTLE,
                f"{eventPlayer.enhancementBattleResetCharges}/2 resets {iconString(Icon.CHECKMARK) if eventPlayer.enhancementBattleResetCharges > 0 else ''}",
                "Born to Battle",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, [Color.WHITE, Color.LIME_GREEN, Color.GREEN][eventPlayer.enhancementBattleResetCharges], HudReeval.STRING_AND_COLOR
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
                iconString(Icon.SPIRAL),
                "{1} {0}".format(f"{ceil(eventPlayer.enhancementBatteryPlacementCooldown)}s" if eventPlayer.enhancementBatteryPlacementCooldown > 0 else iconString(Icon.CHECKMARK), "Hold [{0}]".format(inputBindingString(Button.MELEE)) if eventPlayer.enhancementBatteryPlacementCooldown <= 0 else []),
                "Charge Battery",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.RED if eventPlayer.enhancementBatteryPlacementCooldown > 0 else Color.GREEN, HudReeval.STRING_AND_COLOR
            )
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
            hudText(
                eventPlayer,
                iconString(Icon.FLAG),
                "Press [{0}] to dismount".format(inputBindingString(Button.CROUCH)) if eventPlayer.enhancementIsHitchhiking else "Press [{0}] to attach".format(inputBindingString(Button.CROUCH)) if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer, x) < 2 * x.sizeScale) else [],
                "Hitchhiker",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
            )
            #Shared Health Bar Rider
            hudSubheader(eventPlayer.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "Attached to {0} {1}".format(heroIcon(eventPlayer.enhancementHitchhikerCarrier.getHero()), eventPlayer.enhancementHitchhikerCarrier), HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
            #Shared Health Bar Runner
            hudSubheader(eventPlayer.enhancementHitchhikerCarrier.filter(lambda _: eventPlayer.enhancementIsHitchhiking), "{0} {1} is attached".format(heroIcon(eventPlayer.getHero()), eventPlayer), HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
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
            hudText(
                eventPlayer,
                iconString(Icon.HAPPY),
                f"{ceil(eventPlayer.enhancementPupCooldown)}s" if eventPlayer.enhancementPupCooldown > 0 else iconString(Icon.CHECKMARK),
                "P.U.P.",
                HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
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


macro initializePlayerAugment():
    if eventPlayer.augmentId == Augment.NO_PREFERENCE:
        # Menu non-selection and late-join zero state each receive one real
        # random choice. A nonzero ID preserves explicit and previously rolled choices.
        eventPlayer.augmentId = random.randint(Augment.KEVLAR, Augment.LEECH)
    if eventPlayer.augmentId == Augment.SCAVENGER:
        eventPlayer.augmentScavengerBackpack = []
    if eventPlayer.augmentId == Augment.LASER_BARRICADE:
        #Augment: Laser Barricade
        # augmentBarrierFacing: horizontal unit direction saved at placement, to reconstruct both push reference points.
        # augmentBarrierEdgeDirection: unit direction from corner 1 to corner 2, cached for zombie collision checks.
        # augmentBarrierPlacementCooldown: -1 while aiming; otherwise remaining placement cooldown in seconds (30 on placement), for checks and HUD.
        # augmentBarrierPosition: placed barrier center in world coordinates, for collision checks, push points and HP text.
        # augmentBarrierCorner1: first lower corner in world coordinates, for beams and collision geometry.
        # augmentBarrierCorner2: second lower corner in world coordinates, for beams and the along-barrier direction.
        # augmentBarrierHealth: current barrier health (10000 on placement), for blocking, damage, regeneration and HUD.
        hudText(
            eventPlayer,
            iconString(Icon.DIAMOND),
            "{2} {1} {0}".format(f"{eventPlayer.augmentBarrierPlacementCooldown}s" if eventPlayer.augmentBarrierPlacementCooldown > 0 else iconString(Icon.CHECKMARK), " {0}HP".format(ceil(eventPlayer.augmentBarrierHealth)) if eventPlayer.augmentBarrierHealth > 0 else [], f"Hold [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.INTERACT)}] to place a barricade" if eventPlayer.augmentBarrierPlacementCooldown <= 0 else []),
            "Laser Barricade",
            HudPosition.ACTUALLY_LEFT, 98, Color.WHITE, Color.WHITE, Color.RED if eventPlayer.augmentBarrierPlacementCooldown > 0 else Color.GREEN, HudReeval.VISIBILITY_STRING_AND_COLOR
        )
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
    else:
        # Read live owned state directly: no temporary may be captured by color reevaluation.
        # Passive/no-cooldown augments stay white; Scavenger shows occupied slots.
        # Match the roster: icon, small status/instructions, then the ability name.
        hudText(
            eventPlayer,
            AUGMENT_ICONS[eventPlayer.augmentId],
            "{1} | {0}".format(
                iconString(Icon.CHECKMARK) if getTotalTimeElapsed() >= eventPlayer.augmentMovementReadyAt else f"{ceil(eventPlayer.augmentMovementReadyAt - getTotalTimeElapsed())}s",
                f"Extended reach | [{inputBindingString(Button.MELEE)}] knockback" if eventPlayer.augmentId == Augment.LONG_REACH else f"[{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.JUMP)}]" if eventPlayer.augmentId == Augment.GRAPNEL_LAUNCHER else f"[{inputBindingString(Button.JUMP)}] in midair / double-tap" if eventPlayer.augmentId == Augment.DOUBLE_JUMP else f"[{inputBindingString(Button.JUMP)}] in midair"
            ) if eventPlayer.augmentId in [Augment.PHASE_DASH, Augment.DOUBLE_JUMP, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else (f"Hold [{inputBindingString(Button.CROUCH)}] + [{inputBindingString(Button.INTERACT)}] | {iconString(Icon.CHECKMARK)}" if eventPlayer.augmentApothecaryReady else "Use ultimate to charge teleport") if eventPlayer.augmentId == Augment.APOTHECARY else f"Backpack: {len(eventPlayer.augmentScavengerBackpack)}/2 | Crouch + Interact to store | Hold [{inputBindingString(Button.RELOAD)}] to drop all" if eventPlayer.augmentId == Augment.SCAVENGER else ["", "+75 armor", "", "", "Extended melee reach", "Double magazine capacity", "", "", "", "", "15% lifesteal | +50 health"][eventPlayer.augmentId],
            AUGMENT_NAMES[eventPlayer.augmentId],
            HudPosition.ACTUALLY_LEFT, 98, Color.WHITE, Color.WHITE,
            (Color.RED if getTotalTimeElapsed() < eventPlayer.augmentMovementReadyAt else Color.GREEN) if eventPlayer.augmentId in [Augment.PHASE_DASH, Augment.DOUBLE_JUMP, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else ([Color.WHITE, Color.GREEN, Color.YELLOW][len(eventPlayer.augmentScavengerBackpack)] if eventPlayer.augmentId == Augment.SCAVENGER else Color.WHITE),
            HudReeval.STRING_AND_COLOR
        )
    if eventPlayer.augmentId in [Augment.KEVLAR, Augment.LEECH]:
        # Share the native-health readiness gate; keep both pools recoverable.
        waitUntil(eventPlayer.initialMaxHealth > 0, Math.INFINITY)
        if eventPlayer.augmentId == Augment.KEVLAR:
            eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
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
