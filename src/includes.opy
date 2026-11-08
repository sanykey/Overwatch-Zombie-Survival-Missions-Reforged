#!extension playMoreEffects
#!extension spawnMoreDummyBots

#!setupTags
#!optimizeForSize
#!optimizeForSizeAggressive
#!debugElementCount
#!writeToOutputFile
#!suppressWarnings w_cancel_contrary_motion w_closest_player w_dark_color w_ow2_rule_condition_chase w_start_rule_crash
# w_wait_until is safe for the bare boolean conditions in these rules:
# "SPAWN BOSS": botIsInitializing only receives true/false.
# "REVIVE PLAYER OR ADVANCE DEATH TIMER": isObjectiveComplete only receives true/false.
# Suppress globally because OverPy 9.7.20 leaks rule-level suppression into subsequent rules.
# Numeric waitUntil conditions must keep explicit comparisons; nonzero numbers do not satisfy Wait Until.
#!suppressWarnings w_wait_until

#!include "settings.opy"
#!include "rule_conditions.opy"
#!include "variables.opy"
#!include "compressed numbers.opy"
#!include "subroutines.opy"

#!include "global_startup.opy"
#!include "global_start_menu.opy"
#!include "player_start_menu.opy"
#!include "global_game_in_progress.opy"
#!include "objective_types/objective_type_extraction_point.opy"
#!include "objective_types/objective_type_showdown.opy"
#!include "objective_types/objective_type_bosses.opy"
#!include "objective_types/objective_type_biomorphing.opy"
#!include "objective_types/objective_type_survivor_rescue.opy"
#!include "objective_types/objective_type_kill_zone.opy"
#!include "objective_types/objective_type_zombie_egg.opy"
#!include "objective_types/objective_type_satellite_uplink.opy"
#!include "players_game_in_progress.opy"
#!include "hero_tuning.opy"
#!include "bots_game_in_progress.opy"
#!include "zombie_types.opy"
#!include "supply_drops.opy"
#!include "power_ups.opy"
#!include "enhancements.opy"
#!include "augments.opy"
##!include "debug.opy"
