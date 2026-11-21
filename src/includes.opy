#!define DEBUG false
#!define DEBUG_ENABLE_INSPECTOR false
## Sample bot targeting and spawn teleport activity only with Inspector enabled.
#!define DEBUG_BOT_AI_LOGS false
#!define DEBUG_BOT_AI_LOGS_ACTIVE (DEBUG_ENABLE_INSPECTOR and DEBUG_BOT_AI_LOGS)
#!define DEBUG_SERVER_LOAD_UI false
#!define VERSION "2.0-d"

#!include "settings/settings_defaults.opy"
#!include "core/directives.opy"
#!include "core/constants.opy"
#!include "core/compressed numbers.opy"
#!include "core/enums.opy"
#!include "core/immutable_variables.opy"
#!include "core/variables.opy"
#!include "core/ui_workarounds.opy"

# Uncomment to override lobby settings and custom player ability cooldowns for performance testing.
##!include "settings/settings_perf_test.opy"

# Uncomment at most one map pool override, then save the root main.opy.
##!include "settings/ui_test_map_pool.opy"
##!include "settings/debug_map_pool.opy"

#!include "game/subroutines.opy"
#!include "game/global_startup.opy"
#!include "start_menu/start_menu_enhancements_hud.opy"
#!include "start_menu/start_menu_augments_hud.opy"
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
#!include "abilities/enhancement_charge_battery.opy"
#!include "abilities/enhancement_auspex_scan.opy"
#!include "abilities/enhancements.opy"
#!include "abilities/augment_telekinesis.opy"
#!include "abilities/augment_highrise.opy"
#!include "abilities/augment_dash.opy"
#!include "abilities/augment_laser_barricade.opy"
#!include "abilities/augments.opy"
#!include "abilities/player_initialization.opy"
#!include "abilities/player_events.opy"
#!include "debug/debug.opy"

# Keep this last so OverPy 9.7.21 resolves other includes before expanding the settings aliases.
#!include "settings/settings.opy"
