#!mainFile "../../main.opy"

macro createStartMenuEnhancementHud():
    startMenuEnhancementColorList = numbersList.slice(NL_ENHANCEMENT_MENU_COLORS_OFFSET, NL_ENHANCEMENT_MENU_COLORS_LEN).map(lambda index: augmentColorListConst[index])
    hudText(
        getPlayers(Team.1),
        "Enhancement: {0}{1}".format(
            ENHANCEMENT_NAMES[localPlayer.enhancementId],
            f" {enhancementOptionList[localPlayer.enhancementId]}" if localPlayer.enhancementId > Enhancement.NO_PREFERENCE else ""
        ),
        [
            " ",
            f"Faster infection. Spend infection: {ZOMBIE_HYBRID_DAMAGE_PER_LEVEL} dmg/lvl explosion",
            f"On kill: +{compactHudNumber(BULKING_SEASON_HP_PER_STACK_PCT)}% max HP ({BULKING_SEASON_MAX_HP_MULTIPLIER}x max), +{compactHudNumber(BULKING_SEASON_SIZE_PER_STACK_PCT)}% size ({compactHudNumber(BULKING_SEASON_MAX_SIZE_MULTIPLIER)}x). Lose {BULKING_SEASON_DEATH_LOSS_PCT}% of stacks on death",
            f"Crits: +{BRAIN_KILLER_CRIT_BONUS_PCT}% dmg (+{BRAIN_KILLER_BOSS_CRIT_BONUS_PCT}% vs bosses)",
            f"Dmg within {PYROTECHNIC_IGNITE_RANGE}m ignites zombies ({PYROTECHNIC_BURN_DURATION}s)",
            f"Final blows store ability resets ({BORN_TO_BATTLE_MAX_RESETS} max), used next cast",
            f"Place battery (+{CHARGE_BATTERY_ULT_CHARGE_PCT}% ult on touch, {CHARGE_BATTERY_RECHARGE_DURATION}s recharge, {CHARGE_BATTERY_PLACEMENT_COOLDOWN}s CD). No Cooldowns ({CHARGE_BATTERY_NO_COOLDOWNS_DURATION}s) at ult start",
            f"Drone: ignite + knockdown (≤{PUP_IGNITE_RANGE}m from owner), area freeze (>{PUP_IGNITE_RANGE}m)",
            f"Grab CC’d zombies ({WRESTLER_CARRY_DMG_RESIST_PCT}% dmg resist while carrying). Throw ({WRESTLER_THROW_DAMAGE} dmg). Pull & knock down ({WRESTLER_PULL_DAMAGE} dmg, {WRESTLER_PULL_COOLDOWN}s CD)",
            f"Call lightning on aimed target: {BOLT_STRIKE_DAMAGE} dmg, {BOLT_STRIKE_SPLASH_DAMAGE} splash (<{BOLT_STRIKE_SPLASH_RADIUS}m), {BOLT_STRIKE_STUN_DURATION}s stun. {BOLT_STRIKE_COOLDOWN}s CD",
            f"Scrap: +{ENGINEER_COLLECTION_REWARD} when zombies die <{ENGINEER_COLLECTION_RANGE}m, +{ENGINEER_SCRAP_PASSIVE_RATE}/s. Craft team armor ({ENGINEER_ARMOR_MAX} armor/target) & freezing turrets",
            f"Scan {AUSPEX_RADIUS}m around aim point ({AUSPEX_SCAN_DURATION}s). Marked foes take +{AUSPEX_BONUS_DAMAGE * 100}% dmg (credited to you). {AUSPEX_COOLDOWN}s CD",
            f"+{PLAGUE_DOCTOR_HEAL_BONUS_PCT}% heal (+{compactHudNumber((100 + PLAGUE_DOCTOR_HEAL_BONUS_PCT) * PLAGUE_DOCTOR_INFECTED_HEAL_MULTIPLIER_PCT / 100 - 100)}% on infected). Healing reduces infection in you and allies",
            f"+{OVERCHARGE_HEAL_BONUS_PCT}% heal. Gain 1 energy/{OVERCHARGE_HEAL_ENERGY_DIVISOR} healing (incl. packs) +{OVERCHARGE_ENERGY_PER_ASSIST}/assist. Spend up to {OVERCHARGE_MAX_CHARGE} for bonus dmg/hit",
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
