#!mainFile "../../main.opy"

macro createStartMenuAugmentHud():
    # Like the primary enhancement HUD, this is created once and reevaluates per viewer.
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            " ",
            f"+{AUGMENT_KEVLAR_ARMOR} armor, {AUGMENT_KEVLAR_KNOCKBACK_RESIST}% knockback resistance. {AUGMENT_KEVLAR_RANGED_DMG_RESIST}% resistance to ranged and ability dmg.",
            f"Dash in your movement direction with {DASH_PHASE_DURATION}s invulnerability. Stores {DASH_MAX_CHARGES} charges; restores one every {DASH_COOLDOWN}s.",
            f"Launch upward and gain +{HIGHRISE_DAMAGE_BONUS}% dmg until landing/{HIGHRISE_DAMAGE_DURATION}s +{HIGHRISE_DAMAGE_GRACE_PERIOD}s. cd: {HIGHRISE_COOLDOWN}s.",
            f"Triple melee reach; weapon hits at extended range deal 75% dmg. Push zombies within {TELEKINESIS_MELEE_PUSH_RADIUS}m around you. Push cd: {TELEKINESIS_MELEE_PUSH_COOLDOWN}s.",
            "Double magazine capacity. Fully reloading restores the extra ammo.",
            f"Grapple to allies or zombies {AUGMENT_GRAPNEL_MIN_RANGE}–{AUGMENT_GRAPNEL_RANGE}m away. {AUGMENT_GRAPNEL_DAMAGE} dmg; stun grounded zombies or knock airborne ones down for 3s. cd: 16s.",
            f"Deploy a wall that blocks zombies. Hold Crouch + Interact to aim; release Interact to place. cd: {LASER_BARRICADE_AUGMENT_COOLDOWN}s.",
            f"Carry 2 extra powerups. Zombie deaths within {ENGINEER_COLLECTION_RANGE}m: {SCAVENGER_LOOT_CHANCE}% chance to gain a powerup. Loot fills your active slot, then backpack.",
            "Heal for 15% of dmg dealt. Gain 50 recoverable health."
        ][localPlayer.augmentId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.INTERACT)),
        HudPosition.ACTUALLY_LEFT, 4, AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
