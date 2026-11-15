#!mainFile "../main.opy"

# Keep a single compiled Condition: OverPy splits ordinary `and` / `== true`.
# Numeric 1 applies ONLY to the boolean conjunction result, never to raw slots.
# isGameplayActive is unset/0, false or true; ID predicates retain explicit ==.
# Do not move this gate into ongoing Actions: waits/loops depend on Conditions.
# See WORKSHOP_NATIVE_UI_CORRUPTION.md in the project root.
#!define uiPhaseAndId(idPredicate) ((isGameplayActive and (idPredicate)) == 1)
