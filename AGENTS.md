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

## Commit Messages

Always write commit messages in English, even if the user provides the proposed commit message in another language. Translate the intended meaning into English.

If the task includes creating a commit, choose a prefix based on the purpose of the change:

- `fix: ` — a bug fix.
- `perf: ` — a reduction in element count, game resource usage, or execution time.
- `refactor: ` — refactoring unrelated to bug fixes or the optimizations listed above.
- `feat: ` — new functionality.
- `docs: ` — documentation changes.
- `test: ` — added or updated checks.
- `chore: ` — other project maintenance changes.

For other cases, choose an appropriate prefix yourself, using the repository's history as a guide.
