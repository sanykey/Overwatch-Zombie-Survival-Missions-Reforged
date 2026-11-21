#!mainFile "../../main.opy"

macro createStartMenuEnhancementHud():
    hudText(
        getPlayers(Team.1),
        "Enhancement: {0}{1}".format(
            [
                "No Preference", "Zombie Hybrid ", "Bulking Season ",
                "Brain Killer ", "Pyrotechnic ", "Born to Battle ",
                "Charge Battery ", "P.U.P. ", "Wrestler ",
                "Bolt Strike ", "Engineer ", "Plague Doctor ", "Overcharge ", "Hitchhiker "
            ][localPlayer.enhancementId],
            enhancementOptionList[localPlayer.enhancementId] if localPlayer.enhancementId > Enhancement.NO_PREFERENCE else ""
        ),
        [
            " ",
            f"Faster infection. Spend infection: {ZOMBIE_HYBRID_DAMAGE_PER_LEVEL} dmg/lvl explosion",
            f"On elimination: +{BULKING_SEASON_HP_PER_STACK_PCT}% max HP ({BULKING_SEASON_MAX_HP_MULTIPLIER}x max), +{BULKING_SEASON_SIZE_PER_STACK_PCT}% size ({BULKING_SEASON_MAX_SIZE_MULTIPLIER}x max). Lose {BULKING_SEASON_DEATH_LOSS_PCT}% of stacks on death",
            f"{100 + BRAIN_KILLER_CRIT_BONUS_PCT}% of crit dmg ({100 + BRAIN_KILLER_BOSS_CRIT_BONUS_PCT}% vs bosses)",
            f"Dmg in {PYROTECHNIC_IGNITE_RANGE}m ignites zombies ({PYROTECHNIC_BURN_DURATION}s)",
            f"Final blows store ability resets ({BORN_TO_BATTLE_MAX_RESETS} max), used next cast",
            f"Place battery (+{CHARGE_BATTERY_ULT_CHARGE_PCT}% ult on touch, {CHARGE_BATTERY_RECHARGE_DURATION}s recharge, {CHARGE_BATTERY_PLACEMENT_COOLDOWN}s CD). Ult resets ability CDs",
            f"Drone: ignite + knockdown (up to {PUP_IGNITE_RANGE}m from owner), area freeze beyond {PUP_IGNITE_RANGE}m",
            f"Grab disabled zombies ({WRESTLER_CARRY_DMG_RESIST_PCT}% dmg resist while carrying). Throw ({WRESTLER_THROW_DAMAGE} dmg). Pull and knock down in {WRESTLER_PULL_RANGE}m ({WRESTLER_PULL_DAMAGE} dmg, {WRESTLER_PULL_COOLDOWN}s CD)",
            f"Hits chain to {BOLT_STRIKE_CHAIN_TARGETS} zombies within {BOLT_STRIKE_RADIUS}m for {BOLT_STRIKE_CHAIN_DAMAGE_RATIO * 100}% dmg (max {BOLT_STRIKE_CHAIN_DAMAGE_MAX}).",
            f"Scrap: +{ENGINEER_COLLECTION_REWARD}/zombie death in {ENGINEER_COLLECTION_RANGE}m, +{ENGINEER_SCRAP_PASSIVE_RATE}/s. Craft team armor ({ENGINEER_ARMOR_MAX}/target) and freezing turrets",
            f"+{PLAGUE_DOCTOR_HEAL_BONUS_PCT}% heal (+{(100 + PLAGUE_DOCTOR_HEAL_BONUS_PCT) * PLAGUE_DOCTOR_INFECTED_HEAL_MULTIPLIER_PCT / 100 - 100}% on infected). Healing reduces infection in you and allies",
            f"+{OVERCHARGE_HEAL_BONUS_PCT}% heal. Gain 1 energy/{OVERCHARGE_HEAL_ENERGY_DIVISOR} healing (incl. packs) +{OVERCHARGE_ENERGY_PER_ASSIST}/assist. 2x Crouch: spend up to {OVERCHARGE_MAX_CHARGE} for bonus dmg/hit",
            "Ride nearby ally and share combined HP"
        ][localPlayer.enhancementId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)),
        HudPosition.ACTUALLY_LEFT,
        3,
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
