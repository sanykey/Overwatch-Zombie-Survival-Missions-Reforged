#!mainFile "../../main.opy"

# Only the six regression maps. Ilios Lighthouse is a separate TDM arena;
# enabling Ilios in Control would also include its other stages.
# These macros insert settings dictionary entries, including the trailing comma.
#!define MAP_POOL_ASSAULT "enabled": false,
#!define MAP_POOL_CTF "enabled": false,
#!define MAP_POOL_CLASH "enabled": false,
#!define MAP_POOL_CONTROL "enabled": false,
#!define MAP_POOL_ESCORT "enabledMaps": ["shambaliMonastery"],
#!define MAP_POOL_FLASHPOINT "enabled": false,
#!define MAP_POOL_HYBRID "enabled": false,
#!define MAP_POOL_PUSH "enabledMaps": ["colosseo"],
#!define MAP_POOL_TDM "enabledMaps": ["malevento", "necropolis", "blackForest", "iliosLighthouse"],
