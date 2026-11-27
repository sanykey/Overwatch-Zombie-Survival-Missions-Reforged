#!mainFile "../../main.opy"

macro createStartMenuAugmentHud():
    hudText(
        getPlayers(Team.1),
        f"Augment: {AUGMENT_NAMES[localPlayer.augmentId]} {AUGMENT_ICONS[localPlayer.augmentId] if localPlayer.augmentId != Augment.NO_PREFERENCE else ''}",
        [
            " ",
            f"+{AUGMENT_KEVLAR_ARMOR} armor, +{AUGMENT_KEVLAR_KNOCKBACK_RESIST}% knockback resist. +{AUGMENT_KEVLAR_RANGED_DMG_RESIST}% ranged/ability dmg resist",
            f"Dash in move direction ({compactHudNumber(DASH_PHASE_DURATION)}s invuln). {DASH_MAX_CHARGES} charges, {DASH_COOLDOWN}s/charge",
            f"Launch up. +{HIGHRISE_DAMAGE_BONUS}% dmg until landing ({HIGHRISE_DAMAGE_DURATION}s max, +{compactHudNumber(HIGHRISE_DAMAGE_GRACE_PERIOD)}s grace). {HIGHRISE_COOLDOWN}s CD",
            f"{TELEKINESIS_WEAPON_REACH_MULTIPLIER}x melee reach ({100 - TELEKINESIS_EXTENDED_WEAPON_DAMAGE_PCT}% less dmg at extended range). Push zombies in aim cone ({TELEKINESIS_MELEE_PUSH_RANGE}m, {ZOMBIE_CONE_PUSH_DAMAGE} dmg). {TELEKINESIS_MELEE_PUSH_COOLDOWN}s CD",
            f"{AMMO_PACK_CAPACITY_MULTIPLIER}x mag size. Reload or ult to refill",
            f"Grapple ally/foe ({AUGMENT_GRAPNEL_MIN_RANGE}–{AUGMENT_GRAPNEL_RANGE}m). Arrival pushes zombies in {AUGMENT_GRAPNEL_PUSH_RADIUS}m ({AUGMENT_GRAPNEL_PUSH_DAMAGE} dmg). Direct hit: {AUGMENT_GRAPNEL_DAMAGE} dmg, stun ({compactHudNumber(AUGMENT_GRAPNEL_GROUND_STUN_DURATION)}s) or air knockdown ({AUGMENT_GRAPNEL_AIR_KNOCKDOWN_DURATION}s). Hold Jump to launch up. {AUGMENT_GRAPNEL_COOLDOWN}s CD",
            f"Deploy zombie-blocking wall. {LASER_BARRICADE_AUGMENT_COOLDOWN}s CD",
            f"+{SCAVENGER_BACKPACK_CAPACITY} powerup slots. Zombie deaths in {ENGINEER_COLLECTION_RANGE}m: {SCAVENGER_LOOT_CHANCE}% chance for powerup (fills active slot, then bag)",
            f"{SURVIVALIST_LIFESTEAL_PCT}% lifesteal. +{SURVIVALIST_BONUS_HP} recoverable HP",
            "Ride nearby ally and share combined HP"
        ][localPlayer.augmentId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.INTERACT)),
        HudPosition.ACTUALLY_LEFT, 4, AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId], AUGMENT_COLORS[localPlayer.augmentId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
