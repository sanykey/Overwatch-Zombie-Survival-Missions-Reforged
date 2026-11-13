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