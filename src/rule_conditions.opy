#!mainFile "../main.opy"

# Workshop UI workaround: separate Conditions can make heroes disappear when
# returning from voting to hero selection. Grouping all rule predicates helped
# in user tests (diagnostic 29a); the engine cause is unknown. See
# Readme.md#workshop-hero-selection-ui-corruption.
#
# The argument must be a boolean conjunction, with explicit comparisons for
# untyped/numeric/vector values. Compare that boolean result with numeric 1:
# OverPy 9.7.20 folds `== true` away and splits the resulting `and` into separate
# Conditions, but keeps `== 1`. Workshop treats true as 1 here. This comparison
# applies only to the boolean result, never as a replacement for a value's
# original comparison with 0, Null or False. Keep action optimizations enabled.
#!define groupedConditions(predicate) ((predicate) == 1)
