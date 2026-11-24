#!mainFile "../../main.opy"

# Immutable Augment icons, indexed by selection ID and initialized once before UI rules.
# Shared by the pregame menu, world labels, personal HUD and roster throughout the match.
# Keep a dedicated slot: pregame storage is reused by objectives during gameplay.
globalvar augmentIconListConst

# Immutable Enhancement icons, indexed by selection ID; shared by pregame options and roster.
# Keep a dedicated slot: enhancementOptionList becomes Biomorphing text after menu cleanup.
globalvar enhancementIconListConst

# Immutable names indexed by selection ID and shared by the pregame and combat HUDs.
globalvar enhancementNameListConst
globalvar augmentNameListConst
globalvar challengeNameListConst
globalvar zombieModeNameListConst

# Melee-augment hero tables; the extended list also provides the index for per-hero melee values.
globalvar augmentMeleeWeaponHeroListConst
globalvar augmentMeleeBtnHeroListConst

# Componentwise mask for horizontal distances and offsets.
globalvar horizontalMaskConst

macro initializeImmutableVariables():
    augmentIconListConst = [AugmentIcon.NO_PREFERENCE, AugmentIcon.KEVLAR, AugmentIcon.DASH, AugmentIcon.HIGHRISE, AugmentIcon.TELEKINESIS, AugmentIcon.AMMO_PACK, AugmentIcon.GRAPNEL_LAUNCHER, AugmentIcon.LASER_BARRICADE, AugmentIcon.SCAVENGER, AugmentIcon.SURVIVALIST]
    enhancementIconListConst = [EnhancementIcon.NO_PREFERENCE, EnhancementIcon.ZOMBIE_HYBRID, EnhancementIcon.BULKING_SEASON, EnhancementIcon.BRAIN_KILLER, EnhancementIcon.PYROTECHNIC, EnhancementIcon.BORN_TO_BATTLE, EnhancementIcon.CHARGE_BATTERY, EnhancementIcon.PUP, EnhancementIcon.WRESTLER, EnhancementIcon.BOLT_STRIKE, EnhancementIcon.ENGINEER, EnhancementIcon.AUSPEX_SCAN, EnhancementIcon.PLAGUE_DOCTOR, EnhancementIcon.OVERCHARGE, EnhancementIcon.HITCHHIKER]
    horizontalMaskConst = vect(1, 0, 1)
    enhancementNameListConst = [
        "No Preference", "Zombie Hybrid", "Bulking Season", "Brain Killer", "Pyrotechnic",
        "Born to Battle", "Charge Battery", "P.U.P.", "Wrestler", "Bolt Strike",
        "Engineer", "Auspex Scan", "Plague Doctor", "Overcharge", "Hitchhiker"
    ]
    augmentNameListConst = ["No Preference", "Kevlar", "Dash", "Highrise", "Telekinesis", "Ammo Pack", "Grapnel Launcher", "Laser Barricade", "Scavenger", "Survivalist"]
    challengeNameListConst = ["No Preference", "None", "Swarm Shootout", "Random Abilities", "Insanity", "Pandora's Box"]
    zombieModeNameListConst = ["No Preference", "All Zombies", "New Blood", "What'll it be?", "Zombie Shuffle", "Dinner Rush!", "Ham N' Hammer!"]
    augmentMeleeWeaponHeroListConst = [Hero.REINHARDT, Hero.BRIGITTE, Hero.DMON, Hero.GENJI, Hero.RAMATTRA, Hero.TORBJORN, Hero.VENDETTA]
    augmentMeleeBtnHeroListConst = [Hero.REINHARDT, Hero.BRIGITTE, Hero.TORBJORN]
