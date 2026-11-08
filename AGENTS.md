# Project Instructions

## Implementation and Optimization Priorities

Preserve correctness and existing gameplay behavior except where the task explicitly calls for changes. When implementing features or adapting code from other mods, choose solutions according to these priorities, in descending order:

1. Reduce the element count of the compiled Workshop code; eliminate duplication and redundant actions and conditions.
2. Avoid unnecessary calculations, needlessly frequent checks, and expensive operations in loops; perform work only when needed.
3. Avoid unnecessary global and player variables; reuse existing variables where safe, and do not store values that are not needed.

Measure element savings in the compiled output rather than by counting OverPy source lines. A lower element count alone does not prove faster execution; explain significant tradeoffs between these priorities in your final report.

Adapt borrowed code to the project's architecture and review it for these optimizations instead of copying it unchanged.

## Overwatch Workshop / OverPy Specifics

- When formatting text, prefer f-strings such as `f"text {value}"` over `"text {}".format(value)`, provided this does not increase the compiled Workshop element count or make the code more complex at the point of use.
- Comparing a value with zero is not equivalent to checking its truthiness. In Workshop, an empty array and a zero vector are not equal to `0` or `Null`, but are equal to `False`. Therefore, `X != 0` is true for these values, while `X != False` is false. In OverPy, these values are written as `[]`, `vect(0, 0, 0)`, `null`, and `false`. See the [Workshop comparison tables](https://workshop.codes/wiki/articles/comparisons-and-truth).
- In OverPy 9.7.20, `@Condition X` for an untyped variable compiles to a comparison against `False` using the not-equal operator. When changing conditions, inspect the generated Workshop code; do not replace an explicit comparison with a shorthand check without verifying equivalence for all valid types and values.
- When reusing variables, account for value lifetimes, which player owns each player variable, waits, asynchronous calls, `chase`, and HUD/effect reevaluation. Follow the contracts and comments in `src/variables.opy`; use meaningful `#!define` aliases for shared temporary slots and document their purpose near each use.

## Workshop Hero-Selection UI Bug

Read [the documented symptoms, workaround and validation limits](Readme.md#workshop-hero-selection-ui-corruption) before changing rule Conditions or investigating disappearing heroes, white UI buttons or unavailable emotes.

- Diagnostic build 29a combined separate Conditions into one nested `And` per rule: 850 entries became 212, with all 305 events/action lists preserved. The user reported several successful runs while the matching control still failed intermittently. The root cause is unknown; do not present Server Load or a memory leak as established.
- Preserve Scavenger's working combined Conditions and the existing action-body guards for Leech and Interact. When applying this workaround, preserve every comparison and operand order, including `Null`/zero versus `False`; do not replace comparisons with truthiness checks.
- For multiple predicates, use one `@Condition groupedConditions(...)` annotation. The macro in `src/rule_conditions.opy` compares a boolean conjunction with numeric `1`, preventing OverPy 9.7.20 from splitting it into separate Conditions while keeping other optimizations enabled. Do not replace its `== 1` with `== true`, or pass an untyped/numeric value without an explicit comparison. Inspect the emitted Workshop code; source syntax alone does not prove that grouping survived.
- Measure the element cost and retain gameplay semantics, including ongoing-rule triggering, `Abort When False` and loops. Do not add waits or move Conditions into Actions indiscriminately. Build 29a increased elements from 29,238 to 32,347; fewer condition entries do not prove lower CPU load.
- The normal source build now integrates this workaround: 212 Conditions in 305 rules, 31,619 elements, with the original events/actions and map settings retained. Run `node analysis/verify-grouped-conditions.cjs` after changing Conditions; add `--export` to verify the ordinary root entry point and regenerate `main.ws.txt`. Validate changes in game on affected maps against a matching control; one successful attempt is insufficient. User-confirmed successful runs refer to diagnostic 29a; the white-button and emote symptoms have not been separately verified as fixed.

## Commit Messages

If the task includes creating a commit, choose a prefix based on the purpose of the change:

- `fix: ` — a bug fix.
- `perf: ` — a reduction in element count, game resource usage, or execution time.
- `refactor: ` — refactoring unrelated to bug fixes or the optimizations listed above.
- `feat: ` — new functionality.
- `docs: ` — documentation changes.
- `test: ` — added or updated checks.
- `chore: ` — other project maintenance changes.

For other cases, choose an appropriate prefix yourself, using the repository's history as a guide.
