#!mainFile "../../main.opy"

#!define createNumbers() __script__("../tools/create numbers.js")

# Shared compressed numeric tables.
globalvar numbersList = compressed([ # Shared compressed numeric lookup data for stat tables and spawn weights.
    createNumbers()
])

# Fixed Ammo Pack roster in the same order as the compressed magazine table.
globalvar ammoPackHeroListConst = AMMO_PACK_HEROES

# The shared palette starts with the Augment colors in ID order.
globalvar augmentColorListConst = SHARED_COLOR_PALETTE

macro decodeColorPalette(offset, length):
    numbersList.slice(offset, length).map(lambda index: augmentColorListConst[index])

# Immutable palette indexed by item ID minus one; shared by ground items and their HUD.
globalvar powerUpColorListConst = decodeColorPalette(NL_POWERUP_COLORS_OFFSET, NL_POWERUP_COLORS_LEN)
