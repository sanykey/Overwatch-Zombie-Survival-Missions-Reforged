# Project Instructions

## Implementation and Optimization Priorities

Preserve correctness and existing gameplay behavior except where the task explicitly calls for changes. When implementing features or adapting code from other mods, choose solutions according to these priorities, in descending order:

1. Reduce the element count of the compiled Workshop code; eliminate duplication and redundant actions and conditions.
2. Avoid unnecessary calculations, needlessly frequent checks, and expensive operations in loops; perform work only when needed.
3. Avoid unnecessary global and player variables; reuse existing variables where safe, and do not store values that are not needed.

Measure element savings in the compiled output rather than by counting OverPy source lines. A lower element count alone does not prove faster execution; explain significant tradeoffs between these priorities in your final report.

Adapt borrowed code to the project's architecture and review it for these optimizations instead of copying it unchanged.

## Analysis Directory

Everything in `analysis/` (reports, temporary scripts, validation results) belongs there. When a file name includes a date, put the date in the prefix (for example, `2026-11-10-element-optimization-ideas.md`), not the suffix. Existing files with date suffixes keep their names; update them only together with every reference to them (script `writeFileSync` targets, `require` paths and markdown links).

## Overwatch Workshop / OverPy Specifics

- When formatting text, prefer f-strings such as `f"text {value}"` over `"text {}".format(value)`, provided this does not increase the compiled Workshop element count or make the code more complex at the point of use.
- Define new predicates (reusable expressions that return a boolean) with OverPy's `macro` syntax. When migrating an existing predicate from `#!define`, inspect the compiled Workshop Conditions, especially for native UI workarounds.
- Comparing a value with zero is not equivalent to checking its truthiness. In Workshop, an empty array and a zero vector are not equal to `0` or `Null`, but are equal to `False`. Therefore, `X != 0` is true for these values, while `X != False` is false. In OverPy, these values are written as `[]`, `vect(0, 0, 0)`, `null`, and `false`. See the [Workshop comparison tables](https://workshop.codes/wiki/articles/comparisons-and-truth).
- In OverPy 9.7.20, `@Condition X` for an untyped variable compiles to a comparison against `False` using the not-equal operator. When changing conditions, inspect the generated Workshop code; do not replace an explicit comparison with a shorthand check without verifying equivalence for all valid types and values.
- Compiled global and player variable names must not exceed 31 characters; the Workshop rejects longer names at import with "variable is too long" (a 37-character name fails, 31-character names import fine; 32 is often cited but unverified). `#!define` macro aliases are not compiled and are exempt. When a declaration would exceed the limit, shorten the compiled name (e.g. abbreviate a middle word) and keep the descriptive alias in `src/core/variables.opy`.
- When reusing variables, account for value lifetimes, which player owns each player variable, waits, asynchronous calls, `chase`, and HUD/effect reevaluation. Follow the contracts and comments in `src/core/variables.opy`; use meaningful `#!define` aliases for shared temporary slots and document their purpose near each use.

- Successful OverPy compilation does not establish Workshop import compatibility. Inspect expanded macros before nesting array predicates: `livingProjectileValid()` already uses `all()`, and wrapping it in `any()` produced `Is True For Any(... Is True For All(...))`, rejected by the game with "Cannot nest more than 1 level for some of the values in this script." Keep this predicate outside another collection predicate. Passing several arrays as chained inputs to one predicate is fine; only predicates nested inside other predicates hit the limit.

## Hero Ability HUD Text

Use these abbreviations and formats in English HUD descriptions of hero abilities.

| Full wording | HUD wording |
| --- | --- |
| `damage` | `dmg` |
| `Cooldown: 20s` | `20s CD` |
| `Critical hits` | `Crits` |
| `Double-tap []` | `2x []` |
| `per` | `/` |
| `within 15m` | `in 15m` |
| `resistance` | `resist` |
| `invulnerability` | `invuln` |
| `for 3s` | `(3s)` |

Use telegraphic style. Drop articles (`a`, `the`), pronouns (`your`, `you`, `them`), and linking phrases (`that grants`, `while attached`) while keeping any conditions needed to understand the ability. Use direct verbs and place durations in parentheses. For example, shorten `sets them on fire for 3s` to `burn for 3s`, then apply the duration format to get `ignite (3s)`.

## Workshop Native UI Diagnostics

For disappearing native hero portraits or related Workshop UI corruption, start with
[docs/WORKSHOP_NATIVE_UI_CORRUPTION.md](docs/WORKSHOP_NATIVE_UI_CORRUPTION.md). The source macro
`uiPhaseAndId`, selected event-body guards and Pregame creation spacing are intentional
workarounds. Check the compiled Conditions and first menu opening in fresh matches;
results from builds with disabled visuals do not establish a fix with full visuals.

## Commit Messages

Never commit changes to git unless the user explicitly asks for it. Only create a commit when the user directly requests one.

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
