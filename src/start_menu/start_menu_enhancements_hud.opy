#!mainFile "../../main.opy"

macro createStartMenuEnhancementHud():
    hudText(
        getPlayers(Team.1),
        "Enhancement: {0}{1}".format(
            ENHANCEMENT_NAMES[localPlayer.enhancementId],
            f" {enhancementOptionList[localPlayer.enhancementId]}" if localPlayer.enhancementId > Enhancement.NO_PREFERENCE else ""
        ),
        [
            " ",
            f"Faster infection. Spend infection: {ZOMBIE_HYBRID_DAMAGE_PER_LEVEL} dmg/lvl explosion",
            f"On elimination: +{compactHudNumber(BULKING_SEASON_HP_PER_STACK_PCT)}% max HP ({compactHudNumber(BULKING_SEASON_MAX_HP_MULTIPLIER)}x max), +{compactHudNumber(BULKING_SEASON_SIZE_PER_STACK_PCT)}% size ({compactHudNumber(BULKING_SEASON_MAX_SIZE_MULTIPLIER)}x max). Lose {BULKING_SEASON_DEATH_LOSS_PCT}% of stacks on death",
            f"+{BRAIN_KILLER_CRIT_BONUS_PCT}% crit dmg (+{BRAIN_KILLER_BOSS_CRIT_BONUS_PCT}% vs bosses)",
            f"Dmg in {PYROTECHNIC_IGNITE_RANGE}m ignites zombies ({PYROTECHNIC_BURN_DURATION}s)",
            f"Final blow grants 1 ability reset. {ceil(1 / BORN_TO_BATTLE_SECOND_RESET_PER_FINAL_BLOW)} more for 2nd. Spending clears partial progress",
            f"Place battery (+{CHARGE_BATTERY_ULT_CHARGE_PCT}% ult on touch, {CHARGE_BATTERY_RECHARGE_DURATION}s recharge, {CHARGE_BATTERY_PLACEMENT_COOLDOWN}s CD). No Cooldowns ({CHARGE_BATTERY_NO_COOLDOWNS_DURATION}s) at ult start",
            f"Drone: ignite + knockdown (≤{PUP_IGNITE_RANGE}m from owner), area freeze (>{PUP_IGNITE_RANGE}m)",
            f"Grab CC’d zombies. Throw ({WRESTLER_THROW_DAMAGE} dmg): push ahead in {WRESTLER_THROW_PUSH_RANGE}m ({ZOMBIE_CONE_PUSH_DAMAGE} dmg). Pull & knock down ({WRESTLER_PULL_DAMAGE} dmg, {WRESTLER_PULL_COOLDOWN}s CD)",
            f"Call lightning on aimed target: {BOLT_STRIKE_DAMAGE} dmg, {BOLT_STRIKE_SPLASH_DAMAGE} splash in {BOLT_STRIKE_SPLASH_RADIUS}m, stun ({compactHudNumber(BOLT_STRIKE_STUN_DURATION)}s). {BOLT_STRIKE_COOLDOWN}s CD",
            f"Scrap: +{ENGINEER_COLLECTION_REWARD}/zombie death in {ENGINEER_COLLECTION_RANGE}m, +{ENGINEER_SCRAP_PASSIVE_RATE}/s. Craft team armor ({ENGINEER_ARMOR_MAX} max/target, +{ENGINEER_ARMOR_ALLY_ULT_PCT}% ult/ally grant) & freezing turrets",
            f"Hack & amplify dmg taken ({AUSPEX_MARK_DURATION}s): +{AUSPEX_BONUS_DAMAGE * 100}% (+{AUSPEX_BOSS_BONUS_DAMAGE * 100}% objective bosses & Egg). {AUSPEX_RADIUS}m pulse through walls. +{compactHudNumber(AUSPEX_ULT_PCT_PER_BONUS_DAMAGE)}% ult/ally bonus dmg. {AUSPEX_COOLDOWN}s CD",
            f"+{PLAGUE_DOCTOR_HEAL_BONUS_PCT}% heal (+{compactHudNumber((100 + PLAGUE_DOCTOR_HEAL_BONUS_PCT) * PLAGUE_DOCTOR_INFECTED_HEAL_MULTIPLIER_PCT / 100 - 100)}% on infected). Healing reduces infection in caster and allies",
            f"+{OVERCHARGE_HEAL_BONUS_PCT}% heal. Gain 1 energy/{OVERCHARGE_HEAL_ENERGY_DIVISOR} healing (incl. packs) +{OVERCHARGE_ENERGY_PER_ASSIST}/assist. Spend up to {OVERCHARGE_MAX_CHARGE} for bonus dmg/hit"
        ][localPlayer.enhancementId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)),
        HudPosition.ACTUALLY_LEFT,
        3,
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
