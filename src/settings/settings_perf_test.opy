#!mainFile "../../main.opy"

#!allowMacroRedeclaration
#!define MAP_POOL_CTF "enabled": false,

#!define SETTINGS_TEAM1_SLOTS 7
#!define SETTINGS_TEAM1_HEROES {"general": {"damageDealt%": 50}}
#!define SETTINGS_WORKSHOP PERF_WORKSHOP_SETTINGS
#!define PREGAME_VOTING_DURATION 5
#!define PREGAME_PREPARATION_DURATION 5

# Leave Biomorphing as the only objective in the mixed pool.
macro PERF_WORKSHOP_SETTINGS = {
    "Bosses.": false,
    "Chance to mutate percentage": 25,
    "Kill Zone.": false,
    "Number of Objectives": 5,
    "Number of zombies": 12,
    "Satellite Uplink.": false,
    "Standoff.": false,
    "Survivor Rescue.": false,
    "Zombie Egg.": false
}

# Cooldowns for abilities available in this build.
#!define ZOMBIE_HYBRID_EXPLOSION_COOLDOWN 1
#!define CHARGE_BATTERY_PLACEMENT_COOLDOWN 1
#!define CHARGE_BATTERY_RECHARGE_DURATION 1
#!define WRESTLER_PULL_COOLDOWN 1
#!define DASH_COOLDOWN 1
#!define HIGHRISE_COOLDOWN 1
#!define TELEKINESIS_MELEE_PUSH_COOLDOWN 1
#!define AUGMENT_GRAPNEL_COOLDOWN 1
#!define LASER_BARRICADE_AUGMENT_COOLDOWN 1

#!define SATELLITE_REPAIR_SPEED_MULTIPLIER 20
