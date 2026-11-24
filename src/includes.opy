#!mainFile "../main.opy"

#!define VERSION "2.0"

#!define DEBUG_ENABLE_INSPECTOR false
#!define SERVER_LOAD_UI false
#!define DEBUG false
#!define DEBUG_MEGA_STATS false
#!define DEBUG_BOT_AI_LOGS false
#!define DEBUG_BOT_AI_LOGS_ACTIVE (DEBUG_ENABLE_INSPECTOR and DEBUG_BOT_AI_LOGS)
#!define DEBUG_INPUT_TEST false
#!define DEBUG_TEAM1_SURVIVAL false

#!include "core/directives.opy"
#!include "core/constants.opy"
#!include "core/variables.opy"
#!include "core/ui_workarounds.opy"
#!include "core/compressed numbers.opy"
#!include "settings/settings_defaults.opy"

# Uncomment one include to override the default map pool.
##!include "settings/lobby_bots_map_pool.opy"
##!include "settings/ui_test_map_pool.opy"
##!include "settings/debug_map_pool.opy"

# Optional load-test settings. Keep off for the standard build.
##!include "settings/settings_perf_test.opy"

#!include "settings/settings.opy"
#!include "debug/variables.opy"
#!include "game/subroutines.opy"
#!include "game/global_startup.opy"
#!include "start_menu/global_start_menu.opy"
#!include "start_menu/player_start_menu.opy"
#!include "game/player_camera.opy"
#!include "game/global_game_in_progress.opy"
#!include "objective_types/objective_type_extraction_point.opy"
#!include "objective_types/objective_type_showdown.opy"
#!include "objective_types/objective_type_bosses.opy"
#!include "objective_types/objective_type_biomorphing.opy"
#!include "objective_types/objective_type_survivor_rescue.opy"
#!include "objective_types/objective_type_zombie_egg.opy"
#!include "objective_types/objective_type_satellite_uplink.opy"
#!include "game/players_game_in_progress.opy"
#!include "abilities/hero_tuning.opy"
#!include "game/bots_game_in_progress.opy"
#!include "game/zombie_types.opy"
#!include "items/supply_drops.opy"
#!include "items/power_ups.opy"
#!include "abilities/enhancements.opy"
#!include "abilities/augment_telekinesis.opy"
#!include "abilities/augment_highrise.opy"
#!include "abilities/augment_dash.opy"
#!include "abilities/augment_laser_barricade.opy"
#!include "abilities/augments.opy"
#!include "abilities/abilities_initialization.opy"
#!include "abilities/player_events.opy"
#!include "debug/debug.opy"
