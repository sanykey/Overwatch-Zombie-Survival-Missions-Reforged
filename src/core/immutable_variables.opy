#!mainFile "../../main.opy"

# Immutable Augment icons, indexed by selection ID and initialized once before UI rules.
# Shared by the pregame menu, world labels, personal HUD and roster throughout the match.
# Keep a dedicated slot: pregame storage is reused by objectives during gameplay.
globalvar augmentIconListConst = [AugmentIcon.NO_PREFERENCE, AugmentIcon.KEVLAR, AugmentIcon.DASH, AugmentIcon.HIGHRISE, AugmentIcon.TELEKINESIS, AugmentIcon.AMMO_PACK, AugmentIcon.GRAPNEL_LAUNCHER, AugmentIcon.LASER_BARRICADE, AugmentIcon.SCAVENGER, AugmentIcon.SURVIVALIST]

# Immutable Enhancement icons, indexed by selection ID; shared by pregame options and roster.
# Keep a dedicated slot: enhancementOptionList becomes Biomorphing text after menu cleanup.
globalvar enhancementIconListConst = [EnhancementIcon.NO_PREFERENCE, EnhancementIcon.ZOMBIE_HYBRID, EnhancementIcon.BULKING_SEASON, EnhancementIcon.BRAIN_KILLER, EnhancementIcon.PYROTECHNIC, EnhancementIcon.BORN_TO_BATTLE, EnhancementIcon.CHARGE_BATTERY, EnhancementIcon.PUP, EnhancementIcon.WRESTLER, EnhancementIcon.BOLT_STRIKE, EnhancementIcon.ENGINEER, EnhancementIcon.PLAGUE_DOCTOR, EnhancementIcon.OVERCHARGE, EnhancementIcon.HITCHHIKER]

# Immutable palette shared by the pregame menu and gameplay HUD; indexed by Augment.
globalvar augmentColorListConst = [Color.AQUA, Color.LIGHT_GRAY, Color.YELLOW, Color.SKY_BLUE, Color.ORANGE, Color.WHITE, Color.TURQUOISE, Color.BLUE, Color.LIME_GREEN, Color.RED]

# Immutable augment names, indexed by selection ID; shared by the augment menu and combat HUD.
# Melee-augment hero tables; the extended list also provides the index for per-hero melee values.
# Initialized in VARIABLE ASSIGNMENT, not here: module-level initializers let the optimizer
# fold the string table back into its use sites and drop the assignment as dead code.
globalvar augmentNameListConst
globalvar augmentMeleeWeaponHeroListConst
globalvar augmentMeleeBtnHeroListConst
