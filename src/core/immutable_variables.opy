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

# Immutable Augment icons, indexed by selection ID and initialized once before UI rules.
# Shared by the pregame menu, world labels, personal HUD and roster throughout the match.
# Keep a dedicated slot: pregame storage is reused by objectives during gameplay.

globalvar augmentIconListConst = [AugmentIcon.NO_PREFERENCE, AugmentIcon.KEVLAR, AugmentIcon.DASH, AugmentIcon.HIGHRISE, AugmentIcon.TELEKINESIS, AugmentIcon.AMMO_PACK, AugmentIcon.GRAPNEL_LAUNCHER, AugmentIcon.LASER_BARRICADE, AugmentIcon.SCAVENGER, AugmentIcon.SURVIVALIST]

# Immutable Enhancement icons, indexed by selection ID; shared by pregame options and roster.
# Keep a dedicated slot: enhancementOptionList becomes Biomorphing text after menu cleanup.

globalvar enhancementIconListConst = [EnhancementIcon.NO_PREFERENCE, EnhancementIcon.ZOMBIE_HYBRID, EnhancementIcon.BULKING_SEASON, EnhancementIcon.BRAIN_KILLER, EnhancementIcon.PYROTECHNIC, EnhancementIcon.BORN_TO_BATTLE, EnhancementIcon.CHARGE_BATTERY, EnhancementIcon.PUP, EnhancementIcon.WRESTLER, EnhancementIcon.BOLT_STRIKE, EnhancementIcon.ENGINEER, EnhancementIcon.AUSPEX_SCAN, EnhancementIcon.PLAGUE_DOCTOR, EnhancementIcon.OVERCHARGE, EnhancementIcon.HITCHHIKER]

# Shared immutable palette: indices 0..9 are the Augment colors in selection order.
# Tail 10..14: Green, Purple, Gray, Rose, Null; used to reconstruct the other palettes.
globalvar augmentColorListConst = [Color.AQUA, Color.LIGHT_GRAY, Color.YELLOW, Color.SKY_BLUE, Color.ORANGE, Color.WHITE, Color.TURQUOISE, Color.BLUE, Color.LIME_GREEN, Color.RED, Color.GREEN, Color.PURPLE, Color.GRAY, Color.ROSE, null]

# Initialize after the shared palette; all original item colors and order are retained.
globalvar powerUpColorListConst = numbersList.slice(NL_POWERUP_COLORS_OFFSET, NL_POWERUP_COLORS_LEN).map(lambda index: augmentColorListConst[index])

# Immutable enhancement and augment names, indexed by selection ID and shared by both HUDs.
# Initialized in VARIABLE ASSIGNMENT, not here: module-level initializers let the optimizer
# fold the string table back into its use sites and drop the assignment as dead code.
globalvar enhancementNameListConst
globalvar augmentNameListConst

# Melee-augment hero tables; the extended list also provides the index for per-hero melee values.
globalvar augmentMeleeWeaponHeroListConst
globalvar augmentMeleeBtnHeroListConst

# Componentwise projection onto XZ; immutable, shared by geometry and live HUDs.
globalvar horizontalMaskConst = vect(1, 0, 1)
