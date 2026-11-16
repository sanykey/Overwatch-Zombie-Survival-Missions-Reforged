#!mainFile "../main.opy"

# Combat HUD order on the left: roster (player slot), enhancement (97),
# augment (98), attachment status (98.5), Jetpack fuel (99), carried powerup (100).

# Long Reach's augmentMeleePushReadyAt aliases augmentMovementReadyAt's slot;
# the shared movement HUD reads the selected augment's deadline directly.

rule "ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)":
    @Condition isGameplayActive == true
    # One table-driven call replaces the thirteen per-enhancement HUD cases; the
    # subtitle and color entries hold the same conditional expressions, which
    # reevaluate per viewer exactly as the previous per-player calls did.
    hudText(
        # Hide when the viewer has no enhancement state (including zeroed POTG
        # state). Visibility reevaluates alongside the viewer's strings/colors.
        localPlayer if localPlayer.enhancementId != Enhancement.NO_PREFERENCE else null,
        ENHANCEMENT_ICONS[localPlayer.enhancementId],
        [
            " ",
            f"Explosion: {ceil(localPlayer.enhancementHybridCooldown)}s" if localPlayer.enhancementHybridCooldown > 0 else f"[{inputBindingString(Button.MELEE)}]: explode for {floor(localPlayer.infectionLevel * 100)} dmg" if localPlayer.infectionLevel >= 1 else "Build infection",
            f"Stacks: {localPlayer.enhancementBulkStacks} | +{min(100, localPlayer.enhancementBulkStacks * 0.5)}% HP | Size: {round(localPlayer.sizeScale * 100) / 100}x | Hold [{inputBindingString(Button.MELEE)}]: toggle size",
            "Critical dmg: +60% | Bosses: +20%",
            "Hits within 15m ignite zombies",
            f"Ability resets: {localPlayer.enhancementBattleResetCharges}/2",
            f"Placement: {ceil(localPlayer.enhancementBatteryPlacementCooldown)}s" if localPlayer.enhancementBatteryPlacementCooldown > 0 else f"Hold [{inputBindingString(Button.MELEE)}]: place battery {iconString(Icon.CHECKMARK)}",
            f"[{inputBindingString(Button.CROUCH)}]: detach" if localPlayer.enhancementIsHitchhiking else f"[{inputBindingString(Button.CROUCH)}]: attach near ally",
            "Attacking" if localPlayer.enhancementIsPupBeamActive == true else f"Drone ready {iconString(Icon.CHECKMARK)}",
            "{1} | {0}".format(f"Pull: {ceil(localPlayer.enhancementPullReadyAt - getTotalTimeElapsed())}s" if getTotalTimeElapsed() < localPlayer.enhancementPullReadyAt else f"Pull: hold [{inputBindingString(Button.MELEE)}] {iconString(Icon.CHECKMARK)}", f"Throw: [{inputBindingString(Button.INTERACT)}]" if localPlayer.enhancementCarryState != WrestlerCarryState.NONE else f"Grab: [{inputBindingString(Button.INTERACT)}]"),
            "Hits chain to nearby zombies",
            f"Scrap {floor(localPlayer.enhancementScrap)}/{ENGINEER_SCRAP_MAX} | Hold [{inputBindingString(Button.CROUCH)}] {ENGINEER_ARMOR_HOLD_DURATION}s: armor +{ENGINEER_ARMOR_STACK} (ally {ENGINEER_ARMOR_ALLY_COST}/self {ENGINEER_ARMOR_SELF_COST}) | Hold [{inputBindingString(Button.MELEE)}]: turret ({ENGINEER_TURRET_COST})",
            f"Infection removed: {round(localPlayer.enhancementPlagueCureTotal)}",
            "{0} | {1}".format(f"Energy: {floor(localPlayer.enhancementCapacitorEnergy)}", f"Armed: +{floor(localPlayer.enhancementCapacitorCharge)} dmg/hit" if localPlayer.enhancementCapacitorCharge > 0 else f"Double-tap [{inputBindingString(Button.CROUCH)}]: arm")
        ][localPlayer.enhancementId],
        [" ", "Zombie Hybrid", "Bulking Season", "Brain Killer", "Pyrotechnic", "Born to Battle", "Charge Battery", "Hitchhiker", "P.U.P.", "Wrestler", "Bolt Strike", "Engineer", "Plague Doctor", "Overcharge"][localPlayer.enhancementId],
        HudPosition.ACTUALLY_LEFT, 97, Color.WHITE, Color.WHITE,
        [
            Color.WHITE,
            Color.RED if localPlayer.enhancementHybridCooldown > 0 else Color.GREEN if localPlayer.infectionLevel >= 1 else Color.WHITE,
            Color.WHITE,
            Color.WHITE,
            Color.WHITE,
            [Color.WHITE, Color.SKY_BLUE, Color.GREEN][localPlayer.enhancementBattleResetCharges],
            Color.RED if localPlayer.enhancementBatteryPlacementCooldown > 0 else Color.GREEN,
            Color.WHITE,
            Color.RED if localPlayer.enhancementIsPupBeamActive == true else Color.WHITE,
            Color.RED if getTotalTimeElapsed() < localPlayer.enhancementPullReadyAt else Color.GREEN,
            Color.WHITE,
            # White below ally armor cost; sky blue when ally armor is affordable; green
            # when scrap also covers a turret. Keep thresholds tied to costs.
            Color.WHITE if localPlayer.enhancementScrap < ENGINEER_ARMOR_ALLY_COST else Color.SKY_BLUE if localPlayer.enhancementScrap < ENGINEER_TURRET_COST else Color.GREEN,
            Color.WHITE,
            Color.YELLOW if localPlayer.enhancementCapacitorCharge > 0 else Color.GREEN if localPlayer.enhancementCapacitorEnergy >= 100 else Color.SKY_BLUE if localPlayer.enhancementCapacitorEnergy >= 50 else Color.WHITE
        ][localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )

    # One table-driven call replaces the per-player generic and Laser Barricade
    # HUD cases; subtitle/color expressions reevaluate per viewer exactly as the
    # previous per-player calls did. Read live owned state directly: no temporary
    # may be captured by color reevaluation.
    hudText(
        # Gate on the same viewer-owned ID that selects the HUD contents.
        localPlayer if localPlayer.augmentId != Augment.NO_PREFERENCE else null,
        AUGMENT_ICONS[localPlayer.augmentId],
        "{0}{1}".format(f"Hold [{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.INTERACT)}]: aim; release [{inputBindingString(Button.INTERACT)}]: place | " if localPlayer.augmentBarrierPlacementCooldown <= 0 else "", "{0}{1}".format(f"{ceil(localPlayer.augmentBarrierHealth)} HP | " if localPlayer.augmentBarrierHealth > 0 else "", f"{localPlayer.augmentBarrierPlacementCooldown}s" if localPlayer.augmentBarrierPlacementCooldown > 0 else iconString(Icon.CHECKMARK))) if localPlayer.augmentId == Augment.LASER_BARRICADE else "{1} | {0}".format(
            (iconString(Icon.CHECKMARK) if localPlayer.augmentDashCharges == DASH_MAX_CHARGES else f"{ceil(localPlayer.augmentDashReadyAt - getTotalTimeElapsed())}s {iconString(Icon.CHECKMARK)}" if localPlayer.augmentDashCharges > 0 else f"{ceil(localPlayer.augmentDashReadyAt - getTotalTimeElapsed())}s") if localPlayer.augmentId == Augment.DASH else (iconString(Icon.CHECKMARK) if getTotalTimeElapsed() >= localPlayer.augmentMovementReadyAt else f"{ceil(localPlayer.augmentMovementReadyAt - getTotalTimeElapsed())}s"),
            f"3x melee reach | [{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.JUMP)}]: push" if localPlayer.augmentId == Augment.LONG_REACH else f"[{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.JUMP)}]: grapple | {AUGMENT_GRAPNEL_MIN_RANGE}-{AUGMENT_GRAPNEL_RANGE}m" if localPlayer.augmentId == Augment.GRAPNEL_LAUNCHER else f"[{inputBindingString(Button.JUMP)}] midair / double-tap" if localPlayer.augmentId == Augment.HIGHRISE else f"Dash: {localPlayer.augmentDashCharges}/2 | Double-tap [{inputBindingString(Button.JUMP)}]"
        ) if localPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else (f"[{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.JUMP)}]: teleport {iconString(Icon.CHECKMARK)}" if localPlayer.augmentApothecaryReady and (localPlayer.augmentApothecaryPosition != null or healthpackPositionList != []) else "No known health packs" if localPlayer.augmentApothecaryReady else "Deal ultimate dmg to charge teleport" if localPlayer.getHero() in [Hero.DVA, Hero.DMON] else "Use ultimate to charge teleport") if localPlayer.augmentId == Augment.APOTHECARY else f"Backpack: {len(localPlayer.augmentScavengerBackpack)}/2 | [{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.INTERACT)}]: store/swap | Hold [{inputBindingString(Button.RELOAD)}]: drop all" if localPlayer.augmentId == Augment.SCAVENGER else [" ", "+75 armor | 50% ranged/ability dmg resist", " ", " ", " ", "2x magazine | Fully reload to refill", " ", " ", " ", " ", "15% lifesteal | +50 health"][localPlayer.augmentId],
        AUGMENT_NAMES[localPlayer.augmentId],
        HudPosition.ACTUALLY_LEFT, 98, Color.WHITE, Color.WHITE,
        (Color.RED if localPlayer.augmentBarrierPlacementCooldown > 0 else Color.GREEN) if localPlayer.augmentId == Augment.LASER_BARRICADE else ([Color.RED, Color.SKY_BLUE, Color.GREEN][localPlayer.augmentDashCharges] if localPlayer.augmentId == Augment.DASH else (Color.RED if getTotalTimeElapsed() < localPlayer.augmentMovementReadyAt else Color.GREEN)) if localPlayer.augmentId in [Augment.DASH, Augment.HIGHRISE, Augment.LONG_REACH, Augment.GRAPNEL_LAUNCHER] else ([Color.WHITE, Color.SKY_BLUE, Color.GREEN][len(localPlayer.augmentScavengerBackpack)] if localPlayer.augmentId == Augment.SCAVENGER else Color.GREEN if localPlayer.augmentId == Augment.APOTHECARY and localPlayer.augmentApothecaryReady == true else Color.WHITE),
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
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.enhancementHitchhikerPassenger != null and player.enhancementHitchhikerPassenger.enhancementIsHitchhiking),
        "{0} {1} is attached".format(heroIcon(localPlayer.enhancementHitchhikerPassenger.getHero()), localPlayer.enhancementHitchhikerPassenger),
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )


macro initializePlayerEnhancement():
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        # No preference and late-join zero state roll once for the current hero.
        # Contiguous IDs exclude Hybrid/Bulking Season for non-tanks and the final two support
        # enhancements for non-supports. Explicit choices and later spawns retain the ID.
        eventPlayer.enhancementId = random.randint(
            Enhancement.ZOMBIE_HYBRID if eventPlayer.getHero() in getTankHeroes() else Enhancement.BRAIN_KILLER,
            Enhancement.OVERCHARGE if eventPlayer.getHero() in getSupportHeroes() else Enhancement.ENGINEER
        )
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
            eventPlayer.setHealingDealt(115)
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
        case Enhancement.WRESTLER:
            # Shared enhancement storage starts in the numeric idle state.
            eventPlayer.enhancementCarryState = WrestlerCarryState.NONE
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
            initializeChargeBatteryMacro()
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
        eventPlayer.augmentDashCharges = DASH_MAX_CHARGES
    if eventPlayer.augmentId == Augment.LASER_BARRICADE:
        initializeLaserBarricadeAugmentMacro()
    # HUD lives in AUGMENT HUD (PERMANENT TABLE).
    if eventPlayer.augmentId in [Augment.KEVLAR, Augment.LEECH]:
        # Share the native-health readiness gate; keep both pools recoverable.
        waitUntil(eventPlayer.initialMaxHealth > 0, Math.INFINITY)
        if eventPlayer.augmentId == Augment.KEVLAR:
            # Reapply on each life. Dash is a different augment, so its temporary
            # knockback immunity and cleanup never overwrite a Kevlar player's resist.
            eventPlayer.setKnockbackReceived(100 - AUGMENT_KEVLAR_KNOCKBACK_RESIST)
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
