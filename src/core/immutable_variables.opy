#!mainFile "../../main.opy"

# Shared immutable colors and positions.
# Use Vector directions directly for unit offsets; scaling adds a multiplication and scalar.
# Shared offsets below cache that expression once, saving elements across repeated uses.
globalvar offsetUpThreeQuartersConst = 0.75 * Vector.UP    # Vertical offset of 0.75 m for labels, icons and visibility checks. Source uses: 7 (excluding declaration).
globalvar offsetUpHalfConst = 0.5 * Vector.UP              # Vertical offset of 0.5 m for labels and effects. Source uses: 7 (excluding declaration).
globalvar losOffsetConst = 1.2 * Vector.UP                 # Vertical offset of 1.2 m used by line-of-sight checks. Source uses: 16 (excluding declaration).
globalvar dummyHoldingPositionConst = vect(500, 500, 500)  # Off-map holding position for newly created or reconfigured dummy bots. Source uses: 6 (excluding declaration).
globalvar offsetDownHundredConst = -100 * Vector.UP       # Downward offset of 100 m for raycasts, hidden effects and dead-player storage. Source uses: 7 (excluding declaration).
globalvar offsetUpOneAndHalfConst = 1.5 * Vector.UP       # Vertical offset of 1.5 m for the pregame camera and player labels. Source uses: 6 (excluding declaration).
globalvar offsetUpQuarterConst = 0.25 * Vector.UP         # Vertical offset of 0.25 m for impulses, power-up drops and effects. Source uses: 5 (excluding declaration).

# Immutable palette indexed by item ID minus one; shared by ground items and their HUD.
globalvar powerUpColorListConst = [Color.GREEN, Color.YELLOW, Color.BLUE, Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.ORANGE, Color.BLUE, Color.RED, Color.PURPLE, Color.RED, Color.WHITE]

# Immutable Augment icons, indexed by selection ID and initialized once before UI rules.
# Shared by the pregame menu, world labels, personal HUD and roster throughout the match.
# Keep a dedicated slot: pregame storage is reused by objectives during gameplay.

globalvar augmentIconListConst = [AugmentIcon.NO_PREFERENCE, AugmentIcon.KEVLAR, AugmentIcon.DASH, AugmentIcon.HIGHRISE, AugmentIcon.LONG_REACH, AugmentIcon.AMMO_PACK, AugmentIcon.GRAPNEL_LAUNCHER, AugmentIcon.LASER_BARRICADE, AugmentIcon.APOTHECARY, AugmentIcon.SCAVENGER, AugmentIcon.LEECH]

# Immutable Enhancement icons, indexed by selection ID; shared by pregame options and roster.
# Keep a dedicated slot: enhancementOptionList becomes Biomorphing text after menu cleanup.

globalvar enhancementIconListConst = [EnhancementIcon.NO_PREFERENCE, EnhancementIcon.ZOMBIE_HYBRID, EnhancementIcon.BULKING_SEASON, EnhancementIcon.BRAIN_KILLER, EnhancementIcon.PYROTECHNIC, EnhancementIcon.BORN_TO_BATTLE, EnhancementIcon.CHARGE_BATTERY, EnhancementIcon.PUP, EnhancementIcon.WRESTLER, EnhancementIcon.BOLT_STRIKE, EnhancementIcon.ENGINEER, EnhancementIcon.PLAGUE_DOCTOR, EnhancementIcon.OVERCHARGE, EnhancementIcon.HITCHHIKER]

# Immutable palette shared by the pregame menu and gameplay HUD; indexed by Augment.
globalvar augmentColorListConst = [Color.AQUA, Color.LIGHT_GRAY, Color.YELLOW, Color.SKY_BLUE, Color.ORANGE, Color.WHITE, Color.TURQUOISE, Color.BLUE, Color.GREEN, Color.LIME_GREEN, Color.RED]

# Immutable augment names, indexed by selection ID; shared by the augment menu and combat HUD.
# Melee-augment hero tables; the extended list also provides the index for per-hero melee values.
# Initialized in VARIABLE ASSIGNMENT, not here: module-level initializers let the optimizer
# fold the string table back into its use sites and drop the assignment as dead code.
globalvar augmentNameListConst
globalvar augmentMeleeWeaponHeroListConst
globalvar augmentMeleeBtnHeroListConst

# Componentwise projection onto XZ; immutable, shared by geometry and live HUDs.
globalvar horizontalMaskConst = vect(1, 0, 1)
