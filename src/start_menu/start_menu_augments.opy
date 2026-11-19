#!mainFile "../../main.opy"

macro createStartMenuAugmentHud():
    # Like the primary enhancement HUD, this is created once and reevaluates per viewer.
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            " ",
            f"+{AUGMENT_KEVLAR_ARMOR} armor, +{AUGMENT_KEVLAR_KNOCKBACK_RESIST}% knockback resist. +{AUGMENT_KEVLAR_RANGED_DMG_RESIST}% ranged/ability dmg resist",
            f"Dash in move direction ({DASH_PHASE_DURATION}s invuln). {DASH_MAX_CHARGES} charges, {DASH_COOLDOWN}s/charge",
            f"Launch up. +{HIGHRISE_DAMAGE_BONUS}% dmg until landing ({HIGHRISE_DAMAGE_DURATION}s max; +{compactHudNumber(HIGHRISE_DAMAGE_GRACE_PERIOD)}s grace). {HIGHRISE_COOLDOWN}s CD",
            f"3x melee reach (75% dmg at extended range). Push zombies in {TELEKINESIS_MELEE_PUSH_RADIUS}m. {TELEKINESIS_MELEE_PUSH_COOLDOWN}s CD",
            "2x mag size. Full reload restores extra ammo",
            f"Grapple allies/foes ({AUGMENT_GRAPNEL_MIN_RANGE}–{AUGMENT_GRAPNEL_RANGE}m). Foes: {AUGMENT_GRAPNEL_DAMAGE} dmg, ground stun (0.5s) or air knockdown (3s). {AUGMENT_GRAPNEL_COOLDOWN}s CD",
            f"Deploy zombie-blocking wall. {LASER_BARRICADE_AUGMENT_COOLDOWN}s CD",
            f"+2 powerup slots. When zombies die <{ENGINEER_COLLECTION_RANGE}m: {SCAVENGER_LOOT_CHANCE}% chance for powerup (fills active slot, then bag)",
            "15% lifesteal. +50 recoverable HP"
        ][localPlayer.augmentId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.INTERACT)),
        HudPosition.ACTUALLY_LEFT, 4, AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
