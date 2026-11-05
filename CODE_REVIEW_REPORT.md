# Consolidated register of defects, risks, and optimizations

**English** | [Russian version](CODE_REVIEW_REPORT.ru.md)

Date: **November 4, 2026**. Project: **Overwatch Zombie Survival Missions Reforged**.
Analysis baseline: `5ccb8f09a66ee4c5fd4bb07f56c5528d9f975f7a` and the inspected working tree.

**Audit baseline:** the build sizes, included files, and warning counts below refer to this audit's baseline. Following the release documentation work, current measurements and build configuration are published in [README](Readme.md) and [project-metrics.json](analysis/project-metrics.json). This register preserves the evidence and classification of findings; its figures do not replace recompiling the current code.

The register contains **38 finding groups, R01–R38**. A group may contain several related defects or minor improvements; this is not a count of reproduced bugs or crashes.

**All defects, risks, and optimization candidates described here are inherited from the original ZSMM (786TW).**

By default, defects and proposed changes have status **“not fixed / not implemented”**; subsequent fixes are marked in the register and detailed findings. R08 is now a diagnostic analysis: valid terminal and inactive chase checks are not treated as defects. Game code and the Workshop export were not changed during the original audit. Prototypes were compiled in memory. The main audit covers active source under `src/`. The original ZSMM specified by the user was additionally checked to establish provenance; results appear below and with each finding.

<a id="original-provenance"></a>

## Provenance: original ZSMM and Reforged changes

The comparison baseline is specifically [ZSMM (786TW), snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1>), as specified by the user. “Inherited” means that this snapshot already contains the mechanism behind the defect, risk, or redundant work described. Entry conditions, waits, state writes, and cleanup were compared, accounting for renaming and extracted macros. Matching subroutine names alone were not accepted as evidence. For a risk not yet reproduced in-game, this establishes the construct's origin, not a historical server crash.

| Provenance | Report groups | Comparison result |
|---|---|---|
| **Inherited: 37 groups** | R01–R07, R09–R38 | The mechanism described already existed in the original. For optimization candidates, this is pre-existing redundant work, not necessarily a bug. |
| **Diagnostic group: 1** | R08 | The inspected constructs have counterparts in the original; 10 valid chase cases are not defects, and four remain under observation. |

**No newly introduced issues were established among the findings reviewed.** Debug rules in `src/debug.opy` are excluded from the defect and optimization register: the project owner has decided they will not be included in the final mod. This conclusion is limited to the contents of this report; the comparison is not an exhaustive search for every possible project regression.

**Key points for attribution:**

- **R07 is a pre-existing risk, including shared storage.** In the original, `biowasteAssignment` writes to `objectiveResourcePositions`, as do Satellite terminals: [original:2588](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2588>), [original:2957](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2957>). The queue handler already lacks an objective-change check: [original:2616](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2616>). Attributing this finding to the new slot sharing would be incorrect.
- **R12 is a pre-existing missing detach.** Extracting `daytakerAbortReset` did not introduce the defect: both earlier abort branches already reset the flag and returned without physically detaching: [original:5464](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5464>), [original:5473](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5473>).
- **R16 is a pre-existing selection of the last candidate.** The former `testTarget` corresponds to the current `botCandidateTarget`; assigning before LoS validation and publishing after the loop are already present at [original:3761](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3761>) and [original:3766](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3766>).
- **Start Rule:** all **22** current sites have an earlier call with default RESTART behavior. Each SR01–SR22 entry links to the original call and target. Severity and conditional risk are preserved; SR01–SR03 are not described as independent crash cases.
- **Impulse:** all **20** legacy impulses are inherited. **Chase:** all **14** currently diagnosed sites were matched to earlier conditions/assignments, without treating valid checks as bugs. This does not claim that the historical compiler version emitted exactly the same message list.

The original itself [globally suppressed all four warning types discussed here](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1>). Therefore, messages appearing after suppressions are removed do not date the introduction of defects. A decrease in warnings after variable renaming also does not prove that a mechanic has been fixed.

Line-level evidence for all 38 groups, 22 SR, 14 CH, and 20 IM entries: [comparison data](analysis/original-provenance-2026-11-04.json), [check of references to original constructs](analysis/audit-original-provenance-2026-11-04.cjs). Normalized SHA-256 of the original: `5cdf980510c70b7ab7be5648a3cf392bba1ff6071a24b52772826b0091e49571` (UTF-8, CRLF → LF). The original mod and game code were not changed during this comparison.

## Categories and evidence

Category describes the nature of a finding; priority determines the order of verification and fixes. High priority does not mean a proven server crash. An optimization candidate may be correct code that does redundant work.

| Symbol | What is established | What it does not prove |
|---|---|---|
| **C** | Source structure and, where stated, compiled-rule structure | Reproduction of the symptom in-game |
| **M** | A bounded numerical example or event-order model | Reachability of that exact schedule or geometry in a match |
| **R** | A statically visible risk requiring an in-game scenario | A guaranteed crash or failure in every engine version |
| **O** | An optimization candidate based on repeated work and array sizes | Measured reductions in CPU, Server Load, or traffic, or an FPS increase |

Overwatch was not run. Server crashes, resource exhaustion, and attachment physics were not reproduced. No performance measurements were taken. Workshop semantics differ from Python/JavaScript: an empty array or division by zero should not by itself be described as an exception from those languages; subsequent execution, forward progress, and proper mechanic termination matter.

## Baseline build and verification results

Compiler: installed **OverPy 9.7.20**. Current build: **25,305 elements, 268 rules, 56 warnings**: 22 Start Rule, 14 chase, 20 legacy impulse, 0 Closest Player. The user removed four suppressions; w_dark_color and the documented w_wait_until remain. Restoring the four suppressions in memory produces 0 messages and byte-identical Workshop code. [Full audit of every message](#compiler-warnings).

| Independent prototype against the baseline | Elements | Change | Verified result |
|---|---:|---:|---|
| R23: distance filtering before visibility when returning a boss | 25,307 | +2 | Compiler preserves two passes |
| R28: snapshot of living zombies for Force Field | 25,305 | 0 | Three list-retrieval nodes replaced by one snapshot assignment |
| R36: seven simple visibility filters replaced by conditional selection | 25,312 | +7 | Conditional list selection preserved in Workshop code |

The prototype table refers to the earlier stage with suppressions, when these prototypes compiled without warnings. The current main build without four suppressions emits 56 messages; a combined build of the prototypes was not checked. Element-count changes are not performance measurements. Iteration and action counts below are calculated from source, without accounting for execution delays or early termination.

For the one-item setting, the diagnostic substitution in R03 preserved a zero-step loop. The scripts also checked bounded counterexamples for pickup, target selection, passenger ownership, and old-effect completion. Details and limits of the evidence appear with each finding.

<a id="registry"></a>

## Register and priorities

Fixed defects are struck through and marked with the fix date. Verification results and in-game verification status are recorded in the detailed finding linked by its ID.

| ID | Finding | Category | Priority | Evidence |
|---|---|---|---|---|
| [R01](#r01) | Restarting a waiting subroutine | Stability, lifecycle | High | C + R |
| [R02](#r02) | Insufficient total spawn weight | Loops, settings | High | C + M; engine behavior: R |
| [R03](#r03) | Zero loop step with one item per crate | Loops, settings | High | C + M; engine behavior: R |
| [R04](#r04) | All objective types disabled or Mixed Pool empty | Loops, settings | High | C + M |
| [R05](#r05) | Player race during item pickup | Shared data, items | High | C + M |
| [R06](#r06) | Old effect modifies a player's new spawn state | Lifecycle, player state | High | C + M; scheduling: R |
| [R07](#r07) | Previous objective's queue writes into the next objective's slot | Lifecycle, shared slots | Medium | C + R |
| [R08](#r08) | Chase audit: valid checks excluded from defects | Diagnostics | 10 valid; 4 under observation | C; no in-game failures reproduced |
| [R09](#r09) | Outer loop not bounded by an individual wait's timeout | Lifecycle, waits | Medium | C + R |
| [R10](#r10) | Hitchhiker: passenger ownership and carrier selection | Logic, attachment | High | C + M; physics: R |
| [R11](#r11) | Doomfist never releases the simulated block button | Lifecycle, controls | Medium | C |
| [R12](#r12) | Illari abort path does not detach | Lifecycle, attachment | High | C; physics: R |
| [R13](#r13) | Incorrect Illari hack check and speed restoration | Logic, lifecycle | Medium/high | C + M; scheduling: R |
| [R14](#r14) | Mercy tentacle uses inconsistent visibility checks | Logic, target selection | Medium | C + M |
| [R15](#r15) | Inconsistent units and speed in the dome rescue timer | Logic, timers | Medium | C + M |
| ~~[R16](#r16)~~ | ~~Bot selects a target behind a wall or a stale target~~ — **fixed 2026-11-05** | Logic, target selection | ~~High~~ | C + M |
| [R17](#r17) | Escorted NPC selects itself | Logic, escort | High | C + M |
| ~~[R18](#r18)~~ | ~~Charge Battery selects an ineligible recipient~~ — **fixed 2026-11-05** | Logic, recipient selection | ~~High~~ | C + M |
| [R19](#r19) | Biomorphing selects a resource outside the allowed radius | Logic, pickup | Medium | C + M |
| [R20](#r20) | Player used as an index instead of a membership test | Logic, value types | High | C; coercion: R |
| [R21](#r21) | Repeated bot target-search and visibility calculations | Performance, bots | High | O |
| [R22](#r22) | Repeated turret target scans | Performance, consumables | High | O |
| [R23](#r23) | Spatial filtering before visibility when returning a boss | Performance, geometry | Medium; localized change | O; prototype: C |
| [R24](#r24) | Repeated Laser Barricade geometry | Performance, collisions | High with crowds | O |
| [R25](#r25) | Repeated sorting and raycasts in visual expressions | Performance, HUD | Medium; check clients | O |
| [R26](#r26) | Teleport-point search and absence of targets | Performance, cancellation | Medium | O + R |
| [R27](#r27) | Repeated map-grid processing and terminal placement | Performance, setup | Low | O |
| [R28](#r28) | Living-zombie list snapshot for Force Field | Performance, consumables | Medium; localized change | O; prototype: C |
| [R29](#r29) | Repeated Pyrotechnic hit-queue scans | Performance, damage events | Medium | O |
| [R30](#r30) | Frequent cooldown and charge writes in No Cooldowns | Performance, controls | Medium; check responsiveness | O |
| [R31](#r31) | Escorted NPC path growth | Performance, navigation | High as path grows | O |
| [R32](#r32) | Decorative Bounce Pad and Air Strike effects | Performance, visualization | Medium; check clients | O |
| [R33](#r33) | Hitchhiker and timer sorting | Performance, minor overhead | Low | O |
| [R34](#r34) | Miniboss list grows through empty entries | Resources, long matches | High for long matches | C; load: O |
| [R35](#r35) | Ground items and the shared visual-object budget | Resources, long matches | High for long matches | C; exhaustion: R |
| [R36](#r36) | Visibility filters with a condition shared by all viewers | Performance, visibility | Low/medium | O; prototype: C |
| [R37](#r37) | Unbounded supply-drop point search | Loops, cancellation, performance | Medium | C + R |
| [R38](#r38) | Migration of 20 legacy impulses | Physics compatibility | Low; no direct crash risk found | C; verify physics |

## Detailed findings

<a id="r01"></a>
<a id="s01"></a>
<a id="p17"></a>

### R01. Restarting a waiting subroutine

**Category:** Stability, lifecycle. **Priority:** High. **Evidence:** C + R.

Repeated startRule calls with default RESTART behavior and waiting targets already existed. All 22 current cases are matched individually below; extracting powerUpUsage into another file did not introduce this risk mechanism. Source: [original:1329](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1329>), [original:1516](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1516>), [original:6503](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6503>), [original:6138](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6138>).

Locations: [supply_drops.opy:472](src/supply_drops.opy#L472), [player_start_menu.opy:120](src/player_start_menu.opy#L120), [includes.opy:8](src/includes.opy#L8).

In `powerUpUsage`, all 11 asynchronous consumable calls compile to `Start Rule(..., Restart Rule)`. Long-running effects contain waits. A player can obtain and use the same consumable before the previous effect finishes. Another entry path is `randomActions` when repeatedly toggling readiness: that subroutine contains `wait(1)`.

The OverPy author documents server crashes caused by accumulated restarts of subroutines with unfinished waits, including under relatively low load. Applicability to the current game client needs verification. [OverPy documentation](https://github.com/Zezombye/overpy/blob/master/README.md#w_start_rule_crash).

Established: restart policies, waits, reachable reactivation paths, and 22 warnings now visible after removing suppression. Not established: whether this mode has already accumulated enough restarts to crash. The first three warnings for `determineZombieMode`, `determineChallenge`, and `determineObjectiveType` are conservative: waits are inherited through dependencies; these three subroutines have no waits of their own.

Fix direction: one effect executor with separate extension/transfer requests; an explicit restart policy, unified termination, and release of modifiers/objects. Do not mechanically replace every call with `NOOP`: `powerUpUsage` consumes the item after launch, so ignoring activation can lose the item. For `randomActions`, a separate prohibition on restarting is simpler and does not require a consumable-extension contract.

<a id="r02"></a>
<a id="s02"></a>

### R02. Insufficient total spawn weight

**Category:** Loops, settings. **Priority:** High. **Evidence:** C + M; engine behavior: R.

The original already used the same 19 weights of 5.263, selection over 0–100, and an accumulation loop without an index bound. The 99.997 sum and dangerous range tail are inherited. Source: [original:518](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L518>), [original:521](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L521>), [original:811](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L811>).

Locations: [global_startup.opy:62](src/global_startup.opy#L62), [global_startup.opy:70](src/global_startup.opy#L70), [global_start_menu.opy:309](src/global_start_menu.opy#L309).

Mode `What'll it be?` creates 19 weights of 5.263. Their sum is **99.997**, but `random.uniform(0, 100)` selects a threshold up to 100. The loop increments the index while the accumulated sum is below the threshold; there is no `index < len(botSpawnRateList)` check. The compiled loop body contains no `Wait`.

At a threshold such as **99.999**, all 19 intended entries are exhausted while the exit condition remains false. The search moves beyond the table. If subsequent reads do not increase the sum, progress stops and the loop becomes unbounded. This is a candidate for execution stalling/server overload; out-of-bounds reads and the server's response were not tested here. The probability of selecting such a threshold was not calculated: game RNG and arithmetic discretization were not measured.

Other spawn tables found in `create numbers.js` sum to 100; their shorter length alone does not prove the same bug. An index limit is nevertheless required for any set of weights.

Fix direction: calculate the positive sum of actually eligible weights, choose a threshold relative to it, always bound the index, and provide a result for a zero/invalid sum. Adding a single `wait()` does not fix the missing result and may expose a shared-temporary conflict.

<a id="r03"></a>
<a id="s03"></a>

### R03. Zero loop step with one item per crate

**Category:** Loops, settings. **Priority:** High. **Evidence:** C + M; engine behavior: R.

The setting already permitted one item, while placement already divided 120 by count − 1. The dangerous step value was not introduced by optimization. Source: [original:714](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L714>), [original:6000](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6000>).

Locations: [global_startup.opy:270](src/global_startup.opy#L270), [supply_drops.opy:102](src/supply_drops.opy#L102).

Setting `Number of Powerups Per Supply Drop` allows **1**. Position placement uses:

```python
range(-60, 61, 120 / (supplyDropPowerUpCount - 1))
```

With a value of 1, the denominator is zero. Substituting this value into a diagnostic source copy compiles to `For Global Variable(tmp0, -60, 61, False)`, a step of **0**, without warnings. The body contains no wait; it appends positions to an array.

Established: an allowed setting, division by zero, and a zero step in the compiler specialization. Not checked: whether the current game engine loops indefinitely, interrupts, or otherwise handles this `For`. Therefore, a guaranteed crash is not asserted. If the zero step is retained and the body executes, lack of progress and array growth are possible.

Fix direction: use a separate position without division for one item; more robustly, iterate an integer index `0..count-1` and calculate the angle inside, handling `count == 1` separately. Ensure exactly one position per item ID.

<a id="r04"></a>
<a id="s04"></a>

### R04. All objective types disabled or Mixed Pool empty

**Category:** Loops, settings. **Priority:** High. **Evidence:** C + M.

Unbounded selection of an allowed objective and selection from Mixed Pool without a nonempty check already existed in the original. Source: [original:947](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L947>), [original:964](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L964>).

Locations: [global_startup.opy:5](src/global_startup.opy#L5), [global_start_menu.opy:367](src/global_start_menu.opy#L367), [global_start_menu.opy:400](src/global_start_menu.opy#L400).

If all available objective types, including Mixed Objectives, are disabled, the fallback in `determineObjectiveType` randomly tries only forbidden IDs. The loop has no wait and no prevalidated nonempty list of allowed choices. For this input state, the exit condition cannot become true. The compiler preserves `While` without `Wait`.

A separate combination: Mixed Objectives is enabled, but all seven Mixed Pool options are disabled. The pool is empty, yet generation calls `random.choice` without a nonempty check. For a positive intermediate-objective count, there is no valid type required for normal mission progression. The exact engine result of an empty choice was not checked.

Fix direction: validate settings before starting, checking the ordinary and mixed pools separately. Select from a prepared nonempty array of allowed IDs, with an explicit safe fallback or a clear settings-conflict message. Also check zero intermediate objectives, where only extraction is needed.

<a id="r05"></a>
<a id="s05"></a>

### R05. Player race during item pickup

**Category:** Shared data, items. **Priority:** High. **Evidence:** C + M.

Pickup already separated position selection, index lookup, item grant, and shared-array removal with waits. The cross-player race is inherited. Source: [original:6004](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6004>), [original:6007](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6007>), [original:6009](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6009>), [original:6015](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6015>), [original:6016](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6016>).

Location: [supply_drops.opy:106](src/supply_drops.opy#L106).

The handler saves a position, waits, calculates an index into a shared array, waits again, grants the item and destroys visuals, waits again, and only then removes entries from four arrays. Another player can execute the same steps between these actions.

Counterexample of a permitted interleaving: A and B are on the ground. Two players save index 0 and both read A before removal. Each receives A. The first then removes row 0 containing A; the second uses the same index to remove B, which has shifted into that row. A is granted twice and B is lost. Another interleaving reads a shifted item instead of the selected one. A disappearing selected position can yield an unhandled negative index.

This is a logical race over shared data even if engine rules run sequentially between waits. It does not require concurrent memory writes at thread level. A server crash does not follow from this scenario alone; the established risk is incorrect grants and data removal.

Fix direction: recheck that the item exists and read/grant/remove all related entries in one segment without `wait()` or waiting calls. Keep sound and delayed feedback after the data change. With multiple identical positions, a stable item ID is preferable; an index must not survive a wait without revalidation.

<a id="r06"></a>
<a id="s06"></a>

### R06. Old effect modifies a player's new spawn state

**Category:** Lifecycle, player state. **Priority:** High. **Evidence:** C + M; scheduling: R.

Initialization already reset invisibility/speed, while old Cloaking Device and Super Nano instances subsequently decremented the counter/divided speed. Renaming variables did not create this lifecycle conflict. Source: [original:3095](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3095>), [original:3096](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3096>), [original:6296](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6296>), [original:6302](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6302>), [original:6339](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6339>).

Locations: [players_game_in_progress.opy:42](src/players_game_in_progress.opy#L42), [supply_drops.opy:305](src/supply_drops.opy#L305), [supply_drops.opy:325](src/supply_drops.opy#L325), [hero_tuning.opy:22](src/hero_tuning.opy#L22).

During initialization after spawn, `invisibilityCount` is reset to 0 and `movementSpeedScale` to 1, before the early return on `isHeroSwitchRespawn`. Existing Cloaking Device and hero abilities later perform their paired decrements; Cloaking Device and Super Nano divide the speed multiplier.

If an old effect survives a hero change or quick resurrection, the following sequence is possible:

```text
Cloaking Device: count = 1, speed = 1.5
new initialization: count = 0, speed = 1
old Cloaking Device completes: count = -1, speed = 1 / 1.5
```

A negative counter remains nonzero, so bot predicates `not x.invisibilityCount` reject that player as a visible target. The speed multiplier falls below its baseline. This is a numerical counterexample for the specified event order; hero-change/resurrection scheduling was not reproduced in-game.

Fix direction: track life/hero generations and modifier ownership. An old completion operation must not undo the new generation's state. Recalculate speed from active sources rather than only multiplying/dividing a shared total. Clamping the counter at zero is useful as a check, but alone does not preserve correctness of overlapping effects.

<a id="r07"></a>
<a id="s07"></a>

### R07. Previous objective's queue writes into the next objective's slot

**Category:** Lifecycle, shared slots. **Priority:** Medium. **Evidence:** C + R.

Even the shared Biomorphing-resource/Satellite-terminal list existed in the original as objectiveResourcePositions. The old queue handler also failed to cancel on objective changes. The new objectivePositionsSlot aliases did not create this risk; reachability of a late write still requires in-game verification. Source: [original:229](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L229>), [original:2588](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2588>), [original:2619](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2619>), [original:2625](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2625>), [original:2957](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2957>).

Locations: [objective_type_biomorphing.opy:193](src/objective_types/objective_type_biomorphing.opy#L193), [variables.opy:247](src/variables.opy#L247), [subroutines.opy:660](src/subroutines.opy#L660).

`BIOWASTE MANAGEMENT` only checks that the queue is nonempty and continues its loop with `wait(0.15)`, without checking the objective type, `isGameplayActive`, or objective generation. The resource-creation macro appends positions to `biomorphingResourcePositionList`. This is the same physical `objectivePositionsSlot` used by Satellite Uplink for its terminal list. In the original, both roles likewise shared one `objectiveResourcePositions`; the new aliases preserve that existing sharing.

If a handler with remaining queue entries resumes after the slot is transferred to the next objective, an old resource can enter the terminal list. Extra resource objects from the old objective are also possible before the new list is reset. Unlike this handler, `BIOMORPHING GOAL START` already checks the type after waits; the absence of such checks in the queue needs separate attention.

Shared storage and a missing validity check are established. The necessary queue size and reachability of late resumption in a real match were not reproduced, so this is a risk to the ownership contract, not a claim of guaranteed Satellite Uplink corruption.

Fix direction: stop or clear the queue when the objective ends and check the objective generation after every wait. Type alone is insufficient for Biomorphing → Biomorphing: objective instances must be distinguishable. Do not release shared slots while old executors can still write to them.

<a id="r08"></a>
<a id="s08"></a>

### R08. Chase audit: valid terminal checks are not defects

**Category:** Rule-condition diagnostics. **Status:** no confirmed chase defect established. **Crash risk:** no direct mechanism found.

The inspected chase constructs and conditions have counterparts in the original. This establishes code provenance, not incorrectness: 10 valid cases are not defects, and four remain under observation. Source: [original:1784](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1784>), [original:1791](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1791>), [original:4263](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4263>), [original:6684](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6684>).

The current 14 warnings were examined by phase, chase owner, and checked value. **10 sites are accepted as valid**: terminal Hazard/P.U.P. cooldowns, zero damage radius, fixed radii of other objectives, mutually exclusive Zombie Hybrid chase, and the barricade-health threshold guaranteed by direct assignment.

Four messages concern intermediate boundaries: two dome conditions and two uses of the Showdown radius. They remain under diagnostic observation rather than being registered as proven failures. For Showdown, individual chase steps ending may cause expected reevaluation. Without an in-game counterexample, changing the algorithm solely to silence a warning is unnecessary.

Severity, concrete scenarios, and proposals for all 14 messages appear in [the CH01–CH14 section](#warning-chase). The earlier blanket classification of all chased variables as potential high-priority defects is withdrawn. No in-game reproduction was performed in this audit.

<a id="r09"></a>
<a id="s10"></a>

### R09. Outer loop not bounded by an individual wait's timeout

**Category:** Lifecycle, waits. **Priority:** Medium. **Evidence:** C + R.

Repeated boss/NPC resurrection and waiting for a dropped item to land already lacked an overall deadline. Replacing individual durations with Math.INFINITY is not the root cause of the outer repetition. Source: [original:2246](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2246>), [original:2248](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2248>), [original:2357](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2357>), [original:2366](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2366>), [original:2703](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2703>), [original:6101](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6101>).

Locations: [zombie_types.opy:652](src/zombie_types.opy#L652), [power_ups.opy:102](src/power_ups.opy#L102).

There are waits for a dead player to land, repeated jump attempts, and waits for ability states. A timeout on one `waitUntil` does not bound an outer `while`: it may start new waits forever. An overall time/attempt limit is needed, with exits for actor death/destruction, hero changes, and match end.

Loops containing pauses do not automatically imply an immediate server crash. The risk is a stuck actor or mechanic and incomplete state restoration. Do not add an early `return` while leaving altered physics, held buttons, or flags without cleanup.

Teleport search and supply-drop search are covered separately in R26 and R37. Empty-selection errors appear in R16–R20. These related manifestations need their own input validation and termination checks.

<a id="r10"></a>
<a id="s11"></a>

### R10. Hitchhiker: passenger ownership and carrier selection

**Category:** Logic, attachment. **Priority:** High. **Evidence:** C + M; physics: R.

Carrier-admission and selection filters already differed in the original; the single passenger reference and unconditional cleanup could overwrite another player's association. Source: [original:6990](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6990>), [original:6992](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6992>), [original:7006](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7006>), [original:7013](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7013>).

Locations: [enhancements.opy:458](src/enhancements.opy#L458), [enhancements.opy:460](src/enhancements.opy#L460), [enhancements.opy:478](src/enhancements.opy#L478), [enhancements.opy:485](src/enhancements.opy#L485).

A carrier stores one reference, `enhancementHitchhikerPassenger`, but selection does not check whether it is occupied. Passenger Q can therefore select carrier C while P is already attached to C. C's reference is overwritten from P to Q. P then exits and writes `C.enhancementHitchhikerPassenger = null` without checking ownership, although Q remains attached. The carrier's extra-health handler reads this shared reference and may end its health pool at the wrong time.

A second mismatch: the carrier-existence check excludes `isAttached`, while the actual selection filter excludes only `isCrowdControlled`. These sets differ. If another eligible player exists, an already attached player can be selected. For example, B is attached to A; A looks at B, and a nearby free C permits entry into the branch. The filter can select B and attempt to attach A to B, forming A → B → A. The engine's actual response was not checked; no crash is asserted. Even an operation rejected by the engine can damage state: the flag is set before `attachTo`.

The reverse case: only one free, crowd-controlled player is nearby. The existence check accepts them, but the selection filter excludes them, after which execution continues with an empty result.

Different predicates, a missing occupancy check, and unconditional reference clearing are established. `enhancementIsHitchhiking` and `isAttached` really are aliases: the issue is not a missing flag assignment, but inconsistent filters and ownership.

Fix direction: one carrier list checking availability, occupancy, and absence of cycles; revalidate the selected entity before changing state. On exit, clear the carrier reference only if it points to the exiting passenger. Bind extra health pools to a specific association rather than an ownerless mutable pointer.

<a id="r11"></a>
<a id="s12"></a>

### R11. Doomfist never releases the simulated block button

**Category:** Lifecycle, controls. **Priority:** Medium. **Evidence:** C.

Holding Doomfist's block without a paired release already existed in the original rule. Source: [original:5842](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5842>), [original:5843](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5843>).

Location: [zombie_types.opy:1334](src/zombie_types.opy#L1334).

`SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE` executes `startForcingButton(Button.ABILITY_2)` and `wait(10)`. The rule then ends without `stopForcingButton(Button.ABILITY_2)`. The pause limits the rule's wait, not the duration of simulated button holding.

The installed compiler's function description explicitly specifies holding until the corresponding stop action. The compiled rule contains `Start Holding Button` but no `Stop Holding Button`. Ability 2 stops found in other rules concern Roadhog and Junker Queen; no normal cleanup for this Doomfist hold was found. General bot initialization stops Crouch and Primary Fire, not Ability 2.

The risk is continued holding or repeated block activation after the original condition disappears, interfering with the counterattack and later abilities. This is a button-control lifecycle bug; no server-crash mechanism has been established from it.

Fix direction: explicitly stop holding on expiry, target change/loss, death, or hero change. Check early termination of the target's ultimate and recovery of the block cooldown.

<a id="r12"></a>
<a id="s13"></a>

### R12. Illari abort path does not detach

**Category:** Lifecycle, attachment. **Priority:** High. **Evidence:** C; physics: R.

Both abort branches already reset the attached flag and returned without detaching. The current daytakerAbortReset extracts earlier assignments; the missing detach was not introduced by extracting the helper. Source: [original:5451](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5451>), [original:5468](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5468>), [original:5469](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5469>), [original:5477](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5477>), [original:5478](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5478>).

Locations: [zombie_types.opy:1003](src/zombie_types.opy#L1003), [zombie_types.opy:1019](src/zombie_types.opy#L1019), [zombie_types.opy:1539](src/zombie_types.opy#L1539).

During Burst, Illari sets `isAttached = true` on the carried zombie and calls `attachTo`. When Illari dies, two paths call `daytakerAbortReset()`. That subroutine only resets Illari's two flags and `botAbilityTarget.isAttached = false`; it never calls `detach()`. The successful branch and another cancellation branch call it explicitly.

Workshop's physical attachment and a custom flag are separate operations. Resetting the flag is not a `Detach Players` action; compilation confirms this. A living carried zombie may therefore appear free to AI while the physical association remains until another action or the engine removes it when deleting the parent. Its lifetime after death/removal was not measured in-game.

Fix direction: a shared release procedure for the specific carried actor, including `detach()`, flag reset, and reference clearing. Call it on every exit, retaining the current entity until the next wait. Test Illari's death during both charge stages with a passenger that survives her.

<a id="r13"></a>
<a id="s14"></a>

### R13. Incorrect Illari hack check and speed restoration

**Category:** Logic, lifecycle. **Priority:** Medium/high. **Evidence:** C + M; scheduling: R.

Both comparing an entity with the Boolean hasStatus result and returning after death before restoring speed already existed. Source: [original:5537](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5537>), [original:5539](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5539>), [original:5541](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5541>), [original:5542](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5542>), [original:5547](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5547>).

Locations: [subroutines.opy:822](src/subroutines.opy#L822), [subroutines.opy:825](src/subroutines.opy#L825), [subroutines.opy:827](src/subroutines.opy#L827).

First: `if eventPlayer == eventPlayer.hasStatus(Status.HACKED)` compares a player entity with a Boolean. The compiler preserves `Compare(Event Player, ==, Has Status(...))`, not a status test. Exact engine coercion was not reproduced here; the expression does not directly test `hasStatus`. If the intent is to skip a shot while hacked, express that explicitly.

Second: speed is divided by 3 before a wait, then the death check performs `return`, while the restoring multiplication is below it. The subroutine itself does not restore speed on this exit. Numerical example without an external reset: multiplier 1 → 1/3, followed by death and early return. If the same actor is resurrected without speed reinitialization, the reduced value persists. The exact death/resurrection order was not reproduced in-game.

Fix direction: correct the hack predicate and remove the slowdown owned by this operation on every exit. Restoration must account for actor generation and other speed modifiers, as in [R06](#r06); simply assigning 100% can overwrite another active effect.

<a id="r14"></a>
<a id="s15"></a>

### R14. Mercy tentacle uses inconsistent visibility checks

**Category:** Logic, target selection. **Priority:** Medium. **Evidence:** C + M.

The Mercy tentacle's candidate-visibility test and actual filter already used different ray endpoints. Source: [original:5034](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5034>), [original:5035](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5035>).

Locations: [zombie_types.opy:606](src/zombie_types.opy#L606), [zombie_types.opy:607](src/zombie_types.opy#L607).

The victim-existence check uses `isInLoS(tentaclePosition, x.getEyePosition())`. Actual selection uses a different predicate, `isInLoS(tentaclePosition, eventPlayer.getEyePosition())`. The second point is Mercy's own eyes, not the candidate's.

Counterexample: A is behind a thin obstruction and B is unobstructed within tentacle range; A appears first in the list. Mercy is visible from the tentacle position. B makes the existence check pass. The actual-selection filter also accepts A because it checks the line to Mercy, identical for every candidate. A is selected despite failing the original eligibility check.

The difference between expressions is confirmed in source and compilation. Specific map geometry and the resulting victim movement remain untested.

Fix direction: one eligibility predicate, one list of victims passing it, and selection from that list. Test thin-wall boundaries, barriers, and several nearby players. This may also eliminate a repeated pass, but load savings have not been measured.

<a id="r15"></a>
<a id="s16"></a>

### R15. Inconsistent units and speed in the dome rescue timer

**Category:** Logic, timers. **Priority:** Medium. **Evidence:** C + M.

Comparing meters with seconds, dividing by a fixed 2.5, and accelerating the dome already coexisted in the original. Source: [original:2045](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2045>), [original:3220](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3220>), [original:3221](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3221>).

Locations: [players_game_in_progress.opy:172](src/players_game_in_progress.opy#L172), [objective_type_extraction_point.opy:20](src/objective_types/objective_type_extraction_point.opy#L20), [subroutines.opy:609](src/subroutines.opy#L609).

The rescue rule compares distance `extractionZoneRad - distance(...)` in meters with `rescueTimeRemaining` in seconds. When capping the timer, it divides distance by a fixed 2.5. The dome moves at `extractionSpeedUp`, which increases while players are at extraction.

Two numerical examples at a current speed of 5 m/s:

| Distance margin to dome | Timer before processing | Current branch result | Estimated time to dome |
|---|---:|---:|---:|
| 15 m | 10 s | 9.5 s, because `15 < 10` is false | 3 s |
| 5 m | 10 s | 2 s from division by 2.5 | 1 s |

A later check of actually being outside the dome still exists: this discrepancy does not prove that rescue can continue indefinitely outside it. The risk is an inaccurate timer and inconsistent rescue-time logic. With further dome acceleration, even calculation from current speed is only an estimate and must be updated.

Fix direction: convert distance to seconds using the current positive speed, compare times, and retain the actual position check relative to the dome. Separately test zero speed, the radius boundary, and acceleration during rescue.

<a id="r16"></a>
<a id="b01"></a>

### R16. Bot selects a target behind a wall or a stale target

**Category:** Logic, target selection. **Priority:** High. **Evidence:** C + M.

**Fixed November 5, 2026:** `selectTarget` initializes its search result to `null` and stores a candidate only after a successful line-of-sight check. An unsuccessful search clears the current target through the shared `DESELECT BOT TARGET` logic, preserving the last known target and respecting movement/facing overrides. [Verification](analysis/verify-bot-target-selection.cjs) executes the compiled logic in 36 scenarios with controlled visibility; the OverPy build has no warnings. In-game verification is still pending. The original finding is retained below.

The former testTarget was already assigned before visibility validation and published after the loop without a success flag/candidate reset. This is the same defect despite the new botCandidateTarget name. Source: [original:3761](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3761>), [original:3762](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3762>), [original:3766](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3766>).

Location: [subroutines.opy:696](src/subroutines.opy#L696).

The loop first assigns `botCandidateTarget`, then checks visibility and exits on success. After the loop, `botTarget = botCandidateTarget` executes with only the `eventPlayer.isAlive()` check. There is no separate successful-visibility flag, and `botCandidateTarget` is not cleared before the loop.

Consequences visible in the code:

- If candidates A and B are both behind walls, iteration ends at B and publishes B as the target.
- If the list is empty after invisible players are excluded, the loop never assigns a candidate and the variable's old value is used.

The path is reachable beyond `BOT TARGET VISIBLE`: [bots_game_in_progress.opy:255](src/bots_game_in_progress.opy#L255) starts selection on damage without requiring a currently visible target. Damage can arrive late or from a source without current direct visibility. Subsequently, `DESELECT BOT TARGET` may immediately clear the selected target, causing extra movement/facing transitions. Their frequency was not measured.

Fix direction: a separate search result initialized to `null`, assigned only after a successful check. Explicitly choose a no-eligible-target policy: clear the target or retain a prevalidated current target. Clearing `botCandidateTarget` before the loop alone does not fix selecting the last invisible candidate.

<a id="r17"></a>
<a id="b02"></a>

### R17. Escorted NPC selects itself

**Category:** Logic, escort. **Priority:** High. **Evidence:** C + M.

The NPC already prepared the correct candidate list but selected a leader from another list containing itself. Source: [original:2718](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2718>), [original:2720](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2720>), [original:2723](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2723>).

Locations: [objective_type_survivor_rescue.opy:88](src/objective_types/objective_type_survivor_rescue.opy#L88), [objective_type_survivor_rescue.opy:91](src/objective_types/objective_type_survivor_rescue.opy#L91).

`rescuePotentialLeaderList` correctly excludes the NPC itself and invisible players. When changing leaders, however, the entire `playerTargetList` is sorted again after filtering only by distance. The NPC is added to it on line 94 when escort begins. Actual selection therefore ignores two restrictions in the prepared candidate list.

Counterexample: the NPC is at `(0,0,0)`, the objective at `(100,0,0)`, and a living visible player is nearby but behind the NPC at `(-1,0,0)`. After losing the previous leader, this player satisfies the escort condition. Sorting by objective distance gives the NPC 100 and the player 101, so the NPC selects itself.

Its leader reference becomes a self-reference. The next update again finds that this leader is absent from `rescuePotentialLeaderList` and repeats selection. Movement separately stops when distance to the leader is below 1.5, so this choice can halt the escort. Test after a leader change/disconnection while another player remains behind the NPC.

Fix direction: select the leader from `rescuePotentialLeaderList`, preserving the current preference for proximity to the objective. Handle an empty candidate list explicitly.

<a id="r18"></a>
<a id="b03"></a>

### R18. Charge Battery selects an ineligible recipient

**Category:** Logic, recipient selection. **Priority:** High. **Evidence:** C + M.

**Fixed November 5, 2026:** activation and first-recipient selection use `playerTargetList` and the shared `isBatteryChargeEligible` predicate: the player is alive, has spawned, has less than 100% ultimate charge, and is strictly inside radius `1.5 * sizeScale`. If no eligible player remains when actions execute, the rule aborts before feedback, charge, or cooldown. The existing `tmp0` is used only before the first wait; no variables were added. The [check](analysis/verify-charge-battery.cjs) executes compiled logic in 16 scenarios, reproduces both original counterexamples, and verifies that the other 267 rules are unchanged. OverPy 9.7.20 compiles without warnings; `main.ws.txt` is updated: **25,306 → 25,330 elements (+24)** for consistent eligibility checks and the empty-result guard. The activation condition retains `Is True For Any` without building an intermediate filtered array; runtime speed was not measured. In-game verification remains pending. The original finding is preserved below.

Battery eligibility already checked ultimate charge and scale, while recipient selection lost those restrictions and used a different player source. Source: [original:6967](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6967>), [original:6969](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6969>).

Locations: [enhancements.opy:426](src/enhancements.opy#L426), [enhancements.opy:430](src/enhancements.opy#L430).

The condition searches `playerTargetList` for a player with ultimate charge below 100% within radius `1.5 * sizeScale`. The recipient, however, is selected from all living Team 1 players using only `hasSpawned()` and a radius of 1.5. The ultimate restriction, original target set, and radius scaling are lost.

Two static counterexamples:

- The living-player list starts with a player at 100% ultimate charge, distance 0.5, followed by a player at 50%, distance 1. The second player makes the condition true, but the fully charged first player receives the charge. The battery then enters cooldown.
- A player has `sizeScale = 2`, 50% ultimate charge, and distance 2 from the battery. They pass the condition with radius 3 but not the recipient filter with radius 1.5. With nobody else nearby, the recipient list is empty; there is no useful recipient, but the body continues its actions and starts cooldown.

Fix direction: one shared eligible-recipient list with consistent source, radius, and ultimate restriction. Apply charge and start cooldown only for a nonempty result.

<a id="r19"></a>
<a id="b04"></a>

### R19. Biomorphing selects a resource outside the allowed radius

**Category:** Logic, pickup. **Priority:** Medium. **Evidence:** C + M.

The feet-or-eyes proximity condition and subsequent sorting of the whole list by feet distance alone already differed. Source: [original:2527](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2527>), [original:2531](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2531>).

Locations: [objective_type_biomorphing.opy:117](src/objective_types/objective_type_biomorphing.opy#L117), [objective_type_biomorphing.opy:123](src/objective_types/objective_type_biomorphing.opy#L123).

Pickup is allowed when at least one resource is within 2 m of the feet **or eyes**. The nearest resource to the feet is then selected from the whole array, without filtering by the allowed radius.

Geometric counterexample:

| Object | Position | Distance to feet `(0,0,0)` | Distance to eyes `(0,1.6,0)` | Accepted by condition |
|---|---|---:|---:|---|
| Resource A on a ledge | `(0,3.5,0)` | 3.5 | 1.9 | Yes |
| Resource B to the side | `(2.1,0,0)` | 2.1 | ≈2.64 | No |

A makes the condition true, but sorting by feet distance selects B. B is removed from all arrays and granted to the player. This geometry is a numerical example, not a verified location on a specific map. Look for similar scenarios on ledges and stairs.

Fix direction: first filter resources using the same radius condition, then select the closest eligible resource. Retain one index for synchronous removal from all four arrays.

<a id="r20"></a>
<a id="b05"></a>

### R20. Player used as an index instead of a membership test

**Category:** Logic, value types. **Priority:** High. **Evidence:** C; coercion: R.

Both filters already indexed lists with a player entity. For extraction, the old list name was evacuatingSurvivorList; the current name is evacSurvivorList. Source: [original:2241](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2241>), [original:2120](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2120>).

Locations: [objective_type_bosses.opy:16](src/objective_types/objective_type_bosses.opy#L16), [objective_type_extraction_point.opy:115](src/objective_types/objective_type_extraction_point.opy#L115).

The filters use `not miniBossList[player]` and `not evacSurvivorList[player]`. This is indexing, not testing that a player is absent from a list. Compilation confirms both expressions as `Not(Value In Array(..., Current Array Element))`, where `Current Array Element` is a player entity. They do not become `Array Contains`.

The first filter presumably intends to exclude minibosses from objective-boss candidates; the second intends to remove `ROOTED` from players left outside extraction. Exact engine coercion from a player entity to an index was not checked, so no specific erroneous set of selected players is asserted.

Fix direction: if membership is intended, use `player not in ...`. For the boss, also align the launch condition with the actual candidate filter: the current available-bot check does not exclude minibosses. After fixing the filter, that condition may still be true while the resulting list is empty.

The related accumulation of empty miniboss entries is covered in R34.

<a id="r21"></a>
<a id="p01"></a>

### R21. Repeated bot target-search and visibility calculations

**Category:** Performance, bots. **Priority:** High. **Evidence:** O.

Optimization candidate: expensive visibility conditions and repeated scans/sorts in selectTarget already existed. Current load estimates are not measurements of the original. Source: [original:3718](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3718>), [original:3755](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3755>), [original:3757](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3757>), [original:3762](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3762>).

Locations: [bots_game_in_progress.opy:235](src/bots_game_in_progress.opy#L235), [bots_game_in_progress.opy:266](src/bots_game_in_progress.opy#L266), [subroutines.opy:670](src/subroutines.opy#L670).

`BOT TARGET VISIBLE` scans `playerTargetList` with distances and `isInLoS` directly in rule conditions. `selectTarget()` then rebuilds lists, performs two sorts, and checks candidate visibility. A separate `DESELECT BOT TARGET` rule checks current-target visibility again. The population setting permits up to 23 zombies.

`wait(1)` inside `BOT TARGET VISIBLE` limits repeated body execution but does not move the expensive expression out of `conditions`. This wait alone does not mean visibility is checked exactly once per second.

Candidate: move new-target search into a controlled loop with cheap entry conditions; first build eligible candidates, then check visibility. Prototype a 0.1–0.25-second interval, staggering bot updates over time. Treat current-target loss separately: increasing its interval changes response speed to walls and invisibility.

Preserve priorities for minibosses, dummy targets, Pharah, and players below the bot, plus `botPotentialTargetList`, which the boss HUD reads. Reducing repeated checks is more promising than separately replacing two sorts of a small player array.

<a id="r22"></a>
<a id="p02"></a>

### R22. Repeated turret target scans

**Category:** Performance, consumables. **Priority:** High. **Evidence:** O.

Optimization candidate: the turret already repeated visibility checks in its visual expression, target-existence test, and target sorting. Source: [original:6248](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6248>), [original:6255](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6255>), [original:6256](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6256>), [original:6257](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6257>).

Location: [supply_drops.opy:264](src/supply_drops.opy#L264).

During its 30-second lifetime, the loop steps every 0.125 seconds: **240 iterations**, nominally 8 per second excluding execution time. Each iteration runs `.any(isInLoS...)`; if true, the following `.filter(isInLoS...)` scans living zombies again, then sorts the result. The reevaluated barrel expression at line 276 performs another independent visibility scan.

Candidate: obtain visible zombies once per iteration and reuse the list for existence checks and aiming. Keep a separate eligible-target flag for the effect. Target selection could also run separately from firing, preserving shots every 0.125 seconds.

Caveat: the current `.any()` excludes teleporting bots, but aiming's `.filter()` does not. Merging the predicates changes behavior. To preserve behavior, the list must contain all visible bots and the flag must apply `not botIsTeleporting` separately. Replacing two shot raycasts with one requires separate hit/obstacle analysis; do not propose it automatically.

<a id="r23"></a>
<a id="p03"></a>

### R23. Spatial filtering before visibility when returning a boss

**Category:** Performance, geometry. **Priority:** Medium; localized change. **Evidence:** O; prototype: C.

Optimization candidate: LoS already preceded spatial filtering in bossReturn. Fixing another getClosestPlayer in this mechanic did not remove these costs. Source: [original:2432](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2432>).

Location: [objective_type_bosses.opy:211](src/objective_types/objective_type_bosses.opy#L211).

`bossReturn()` filters the entire `mapGridList` with a predicate containing `isInLoS` and a 5–20 m distance restriction. The generator aims for up to **900 points**. Compiled code uses one `Filtered Array` with nested `And`.

Candidate: first select points satisfying `5 < distance < 20` in a separate assignment, then check visibility only for those points. This explicitly restricts the expensive pass to spatial candidates; reordering parts of a single `and` does not establish that structure. If there are `k` such points, the second filter receives `k` points rather than all `N` grid points. Neither `k` nor the actual engine evaluation count was measured here.

A prototype was checked **in memory only**: the compiler preserved two separate passes; build **25,305 → 25,307 (+2 elements)**. No extra variables are needed: the same synchronous `tmp0` is used, with no wait between passes. Under an ordinary world state, candidate order/set and random point selection are preserved; this does not replace in-game testing.

This operation is relatively infrequent, so its contribution to average load may be lower than target search. Prioritize peaks when several bosses return.

<a id="r24"></a>
<a id="p04"></a>

### R24. Repeated Laser Barricade geometry

**Category:** Performance, collisions. **Priority:** High with crowds. **Evidence:** O.

Optimization candidate: repeated barricade geometry passes, sorting, and raycasts already existed. Source: [original:6771](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6771>), [original:6777](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6777>), [original:6781](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6781>), [original:6800](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6800>).

Location: [enhancements.opy:223](src/enhancements.opy#L223).

Conditions contain four independent `.any()` checks over living zombies; one computes distance to a segment. The body then recomputes the full geometric filter. The loop ends with `wait()` without an explicit interval. Each affected zombie also causes a surface-normal raycast and a sort of two anchor points. Work increases with multiple barricades.

Candidate: move collision detection into a controlled pass, reuse geometry within that pass, and replace sorting two points with a direct comparison. Consider less frequent collision checks only while preserving balance.

Do not simply merge four `.any()` checks into one: each can currently be satisfied by different zombies. This affects body entry and stopping/starting health regeneration. Do not simply increase `wait()`: impulse frequency and zombie retention would change even if barricade damage is limited by `ROOTED`. The current code already replaces trigonometry with `dotProduct`; do not propose that change again.

<a id="r25"></a>
<a id="p05"></a>

### R25. Repeated sorting and raycasts in visual expressions

**Category:** Performance, HUD. **Priority:** Medium; check clients. **Evidence:** O.

Optimization candidate: repeated view-angle HUD sorting and barricade-preview rays existed in the original. Source: [original:1566](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1566>), [original:1943](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1943>), [original:6606](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6606>).

Locations: [global_game_in_progress.opy:14](src/global_game_in_progress.opy#L14), [subroutines.opy:332](src/subroutines.opy#L332), [supply_drops.opy:74](src/supply_drops.opy#L74), [enhancements.opy:54](src/enhancements.opy#L54).

Health-pack selection by viewing angle is repeated three times across text, text position, and icon. Biomorphing resource selection is repeated in text and position. The pickup hint separately checks for an eligible item and repeats geometry during filtering/sorting. The barricade preview contains two identical raycasts for beam endpoints plus a separate range-check raycast.

Compilation confirms that two health-pack sorts inside one `Create In-World Text` remain separate expressions: they cannot be assumed to compute automatically only once. Visual-object parameters determine reevaluation; running the creation rule once does not mean these expressions are evaluated once.

Candidate: store the selected position/target separately for each player and update as needed at a bounded rate. Use a separate hit-position cache for the shared beam-preview point. Check visual smoothness, target switching while turning the camera, and cache clearing on item disappearance, death, and phase changes.

Do not replace view-angle selection with nearest-distance selection: that is different logic. Do not write individual results to one shared global variable or use shared `tmp*` temporaries in reevaluated HUD. The added server update loop creates load itself; compare it with the original first, especially for short lists.

<a id="r26"></a>
<a id="p06"></a>

### R26. Teleport-point search and absence of targets

**Category:** Performance, cancellation. **Priority:** Medium. **Evidence:** O + R.

Repeated point index lookups and a teleport-search loop without explicit cancellation when targets are absent already existed. Source: [original:3979](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3979>), [original:3982](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3982>), [original:3986](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3986>).

Location: [bots_game_in_progress.opy:445](src/bots_game_in_progress.opy#L445).

Point search repeats spawn-list filters and `botSpawnPointList.index(x)` for each candidate, then repeats `index` for the selected position. For a large list, these are repeated searches of the same array. Many bots can search simultaneously.

Candidate: build a list of eligible indices, check position/timer through one index, and retain the selected index only until the next wait. Do not preserve indices across `wait`: another bot may remove a point. Bound attempts per pass and, when `playerTargetList` is absent, pause searching until a target appears while restoring state correctly.

That guard also avoids redundant work with an empty target list. This is a known edge case already noted in source comments. A naive `return` is dangerous: the bot may remain invisible, without gravity, and marked as teleporting.

<a id="r27"></a>
<a id="p07"></a>

### R27. Repeated map-grid processing and terminal placement

**Category:** Performance, setup. **Priority:** Low. **Evidence:** O.

Optimization candidate: grid generation checking the accumulated array and repeated base filtering for terminals already existed. Source: [original:757](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L757>), [original:761](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L761>), [original:2948](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2948>).

Locations: [global_startup.opy:315](src/global_startup.opy#L315), [objective_type_satellite_uplink.opy:72](src/objective_types/objective_type_satellite_uplink.opy#L72).

The generator compares new points with the entire accumulated array. For 900 successful additions without rejections, the sum of pre-insertion array sizes is **404,550**: potential comparisons for full scans, not a measured actual-call count. Rejected candidates add attempts. Each terminal-placement retry filters the grid again by the unchanged distance to the current objective.

Terminal candidate: precompute base points 10–50 m away, then repeatedly filter only that list by terminal spacing. More complex spatial partitioning of the generator is justified only by confirmed setup load. These sites are not continuous costs during ordinary combat.

<a id="r28"></a>
<a id="p08"></a>

### R28. Living-zombie list snapshot for Force Field

**Category:** Performance, consumables. **Priority:** Medium; localized change. **Evidence:** O; prototype: C.

Optimization candidate: Force Field already fetched living bots repeatedly within each short step. Source: [original:6134](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6134>), [original:6136](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6136>), [original:6137](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6137>).

Location: [supply_drops.opy:156](src/supply_drops.opy#L156).

Force Field loops for 10 seconds at 0.032-second steps, approximately 313 iterations. Within the zombie scan, `getLivingPlayers(Team.2)[index]` occurs three times: for distance, impulse recipient, and direction. With a large population, the inner body may execute several thousand times, although the field only affects nearby zombies.

Candidate: obtain living zombies once at the start of each outer iteration and use the snapshot for length/indexing. If needed, separately test prefiltering nearby actors using the existing distance predicate. Preserve impulse frequency.

The snapshot prototype passed compilation: **25,305 → 25,305**, with no new variables. In the compiled rule, three `All Living Players(Team 2)` occurrences become one snapshot assignment before the inner loop. This counts expression nodes, not measured engine evaluations. `tmp1` is consumed before the next `wait`; the scan has no subroutines or waits. The prototype is in the static-check script.

<a id="r29"></a>
<a id="p09"></a>

### R29. Repeated Pyrotechnic hit-queue scans

**Category:** Performance, damage events. **Priority:** Medium. **Evidence:** O.

Optimization candidate: the Pyrotechnic queue already stored repeated references and was refiltered for each victim. Source: [original:6837](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6837>), [original:6851](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6851>), [original:6855](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6855>).

Location: [enhancements.opy:287](src/enhancements.opy#L287).

Every eligible hit appends its victim to `enhancementPyroHitList`, including duplicates. The handler takes the first target, filters the remaining queue to count repetitions, and removes it from the queue. These are repeated hit-list scans per unique victim; with many distinct victims, work can grow quadratically with queue size. In practice, population bounds the unique-victim count.

Candidate: aggregate hit counts per victim, storing unique victims and counters rather than repeated references. For the current `min(4 * count, 30)` formula, distinguishing 0–7 and “8 or more” is sufficient. Smaller queues are promising for rapid-fire and area attacks, but finding a counter on every hit also costs time: compare both approaches under load.

Preserve batch processing, the 0.5-second pause, half damage to bosses, and separate attacker context. Using one global victim counter or a separate DoT per bullet changes the mechanic. Associate data with player entities; slot indices are not permanent identities after bot recreation.

<a id="r30"></a>
<a id="p10"></a>

### R30. Frequent cooldown and charge writes in No Cooldowns

**Category:** Performance, controls. **Priority:** Medium; check responsiveness. **Evidence:** O.

Optimization candidate: the same frequent cooldown and charge resets already ran in the original. Source: [original:6153](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6153>), [original:6154](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6154>), [original:6167](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6167>).

Location: [supply_drops.opy:177](src/supply_drops.opy#L177).

Every 0.032 seconds, the rule resets eight cooldowns and sets three charge values (two for Reaper). Over a full 15 seconds, that is approximately 469 iterations and **5,159 write-action executions** for the ordinary branch. This is arithmetic from source, excluding interruption/restart and actual execution time.

Candidate: prototype updates only for buttons applicable to the hero and charges/cooldowns actually spent. Retain the original handling for buttons that cannot reliably be matched to a hero. Conditional reads cost time too: adding `if cooldown > 0` before every write without measurement may be counterproductive. Do not automatically increase the interval: that changes responsiveness. Hero changes during the effect require updating the button list.

<a id="r31"></a>
<a id="p11"></a>

### R31. Escorted NPC path growth

**Category:** Performance, navigation. **Priority:** High as path grows. **Evidence:** O.

The NPC path already grew without an explicit bound, was rescanned for movement, and sorted to find the closest point. Source: [original:2691](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2691>), [original:2751](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2751>), [original:2761](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2761>).

Locations: [objective_type_survivor_rescue.opy:62](src/objective_types/objective_type_survivor_rescue.opy#L62), [objective_type_survivor_rescue.opy:114](src/objective_types/objective_type_survivor_rescue.opy#L114), [objective_type_survivor_rescue.opy:127](src/objective_types/objective_type_survivor_rescue.opy#L127).

The path grows as the leader moves, with no explicit length bound. If the leader continues while the NPC falls behind or gets stuck, the list can grow. The movement expression contains `.any(...)` and repeated `.filter(...).last()` over the same path; removing the traversed section also sorts the entire path for one closest point, then finds its index.

Candidate: find the closest point's index in one linear scan, retaining the first minimum on ties; reuse steering calculations and remove points known to have been traversed. Bounding or simplifying the path requires navigation testing: old points cannot simply be discarded in a way that cuts route corners.

Naively replacing removal with `slice` needs separate proof: the original `remove(filter(...))` removes by value, so repeated points can also remove matching entries beyond the selected index. In the previous audit, `slice` also failed to save elements; this does not rule out other algorithmic changes.

<a id="r32"></a>
<a id="p12"></a>

### R32. Decorative Bounce Pad and Air Strike effects

**Category:** Performance, visualization. **Priority:** Medium; check clients. **Evidence:** O.

Optimization candidate: Air Strike already created four dynamic effects over 50 steps, and Bounce Pad a ring every 0.25 seconds of activity. Source: [original:6188](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6188>), [original:6193](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6193>), [original:6196](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6196>), [original:6356](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6356>), [original:6357](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6357>).

Locations: [supply_drops.opy:385](src/supply_drops.opy#L385), [supply_drops.opy:211](src/supply_drops.opy#L211).

Bounce Pad checks players 480 times over 60 seconds and separately sends all players a decorative ring every 0.25 seconds, approximately 240 effect launches per activation. Air Strike makes 50 explosions with four `playEffect` calls each for all players: 200 visual/audio-effect calls.

Client-load/traffic candidate: reduce decorative-ring frequency or restrict distant cosmetic effects to selected viewers. Preserve jump checks, radii, and damage at their original frequency. This deliberately changes visual detail; fewer calls do not prove lower Server Load, and viewer filtering adds computations. Check FPS and perception of danger warnings.

<a id="r33"></a>
<a id="p13"></a>

### R33. Hitchhiker and timer sorting

**Category:** Performance, minor overhead. **Priority:** Low. **Evidence:** O.

Optimization candidates: timer sorting and sorting two Hitchhiker participants already existed in the original. Source: [original:534](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L534>), [original:7042](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7042>), [original:7043](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7043>).

- [enhancements.opy:518](src/enhancements.opy#L518): Hitchhiker sorts two players, then builds another array through `concat().exclude()`. Recipient/donor selection can use a direct normalized-health comparison. The benefit alone is small; preserve the health-transfer formula.
- [global_startup.opy:128](src/global_startup.opy#L128): respawn timers are sorted every second after subtracting the same one unit. If ordering is maintained at every queue mutation, re-sorting can be removed. First check every insertion, forced change, and negative value; the array is small, so priority is low.

<a id="r34"></a>
<a id="p14"></a>
<a id="s09"></a>

### R34. Miniboss list grows through empty entries

**Category:** Resources, long matches. **Priority:** High for long matches. **Evidence:** C; load: O.

Appending minibosses and replacing entries with zero rather than deleting them already existed; array growth is inherited. Source: [original:3622](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L3622>), [original:4332](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4332>).

Locations: [subroutines.opy:28](src/subroutines.opy#L28), [bots_game_in_progress.opy:150](src/bots_game_in_progress.opy#L150), [subroutines.opy:751](src/subroutines.opy#L751).

Creating a miniboss performs `miniBossList.append(eventPlayer)`, while the normal death branch replaces the entry with zero. This branch neither removes zeros nor reuses them on the next creation. Thus “create miniboss — kill it — create another” grows the array while the living-miniboss count stays constant. Separate removal when converting one into an objective boss does not clear zeros from normal deaths.

The list is read in many bot-rule conditions, damage handlers, target selection, and `.any(entityExists)` checks. More empty entries increase operation input sizes. This candidate is particularly useful for long matches and requires no gameplay-content reduction.

Candidate: remove dead entities or reuse/compact empty entries before appending. First check all readers: [objective_type_bosses.opy:16](src/objective_types/objective_type_bosses.opy#L16) contains suspicious indexed `miniBossList[player]` access instead of ordinary membership testing. Changing the representation without analyzing this site is not proven safe. All other readers found use membership or `.any()`, not a meaningful fixed position for a particular miniboss.

The shared object budget and failed-creation consequences are covered in R35. List growth alone does not prove budget exhaustion or server termination.

<a id="r35"></a>
<a id="p15"></a>

### R35. Ground items and the shared visual-object budget

**Category:** Resources, long matches. **Priority:** High for long matches. **Evidence:** C; exhaustion: R.

The limit of 12 already applied only to the generator; Biomorphing rewards and drops added items outside it. The original also enabled playMoreEffects: the increased visual-object budget is not a new Reforged difference and does not provide a global item limit. Source: [original:5930](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5930>), [original:2510](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2510>), [original:6090](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6090>), [original:6104](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6104>), [original:451](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L451>).

Locations: [supply_drops.opy:24](src/supply_drops.opy#L24), [supply_drops.opy:96](src/supply_drops.opy#L96), [power_ups.opy:90](src/power_ups.opy#L90), [objective_type_biomorphing.opy:100](src/objective_types/objective_type_biomorphing.opy#L100).

The comment “Limited to 12 power ups” refers to the supply-generation entry condition. It does not bound every addition: manual drops, death drops, and four Biomorphing rewards add items separately. Even opening a crate adds the entire batch without capping it to available places. Waits occur between checking generation entry and opening the crate.

Consequently, 12 is not a guaranteed upper bound for `supplyPowerUpPositionList`. Every item gets an effect and label; hint/pickup logic scans and sorts the list. Removal was found on pickup; these paths have no automatic lifetime or global surplus cleanup. More items also consume the shared text/effect budget.

Candidate: one ground-item registration function used by all sources. It can enforce a global budget and, if appropriate to the intended mechanic, lifetimes or removal of old items. Do not simply skip appending a position: parallel type-ID, position, and visual-object arrays must remain consistent, and a dropped item must not silently disappear. This changes resource policy and needs alignment with game design during implementation.

Budget exhaustion can break visual-object creation and degrade the mode. It has not been established that reaching these limits necessarily terminates the server. Observe counters, array lengths, and failed object creation. Stored IDs and cleanup must correspond to objects actually created.

Fix direction: compact lists, centralize item accounting, and control effect termination. For turrets, barricades, and force fields, also measure peaks during simultaneous operation. Spawn limits based on average load neither bound existing effects' costs nor protect against [R01](#r01).

<a id="r36"></a>
<a id="p16"></a>

### R36. Visibility filters with a condition shared by all viewers

**Category:** Performance, visibility. **Priority:** Low/medium. **Evidence:** O; prototype: C.

Optimization candidate: viewer filters whose condition does not depend on the lambda parameter already existed. The count of 50 refers to the current tree, not a recount of the historical file. Source: [original:5966](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5966>), [original:6593](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6593>), [original:6600](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6600>).

Locations: [players_game_in_progress.opy:122](src/players_game_in_progress.opy#L122), [players_game_in_progress.opy:126](src/players_game_in_progress.opy#L126), [subroutines.opy:149](src/subroutines.opy#L149), [subroutines.opy:170](src/subroutines.opy#L170).

Source contains 50 expressions of the form `getAllPlayers().filter(lambda _: ...)` that do not use the viewer parameter. Example: `getAllPlayers().filter(lambda _: eventPlayer.isReviving)`. For an unchanged state, the result is either the whole list or an empty list; per-player filtering is unnecessary.

For Boolean conditions, test replacement with `getAllPlayers() if condition else []`, preserving visibility reevaluation. Conditions with `evalOnce`, numeric values, or `localPlayer` need individual analysis rather than bulk text replacement.

Seven simple replacements for infection/resurrection, the gas projectile, and the tentacle were checked: **25,305 → 25,312 (+7)**, without warnings under the earlier suppressions. Compilation preserves conditional list selection instead of filtering. This may reduce reevaluation work but does not save elements; actual engine speed was not measured. The prototype is included in the static-check script and is not implemented.

<a id="r37"></a>
<a id="p18"></a>

### R37. Unbounded supply-drop point search

**Category:** Loops, cancellation, performance. **Priority:** Medium. **Evidence:** C + R.

The supply-drop loop already searched without an overall attempt limit or in-loop checks of the phase/target availability. Source: [original:5939](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5939>), [original:5941](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5941>), [original:5948](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5948>).

Location: [supply_drops.opy:34](src/supply_drops.opy#L34).

The loop continues until it finds a valid position, filtering the map grid each time without checking `isGameplayActive` or target availability inside. A 0.25-second pause already exists, so this is not a tight wait-free loop. But without a valid point, searching may continue consuming resources without a result, including after the match phase changes.

Candidate: a bounded attempt batch, repeated phase/player checks, and a defined recovery path when candidates are empty. Do not place a crate at an arbitrary zero position simply to terminate the loop. For normally successful searches, this is less important than bot logic and Force Field.

<a id="r38"></a>

### R38. Migrating the legacy impulse mode

**Category:** Physics compatibility. **Priority:** Low. **Evidence:** 20 compiler messages and a successful XYZ prototype. **Crash risk:** no direct mechanism found.

All 20 current sites have corresponding legacy impulses in the original. This is inherited physics-compatibility work, not 20 newly proven defects. IM01 changes target selection and guards existence, but the impulse mode itself is unchanged. Source: [original:2363](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2363>), [original:6137](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6137>), [original:7137](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7137>).

The old `CANCEL_CONTRARY_MOTION` and new `CANCEL_CONTRARY_MOTION_XYZ` handle horizontal and vertical velocities differently. Successful replacement compilation does not prove equivalent trajectories. All 20 sites, individual checks, and proposals are collected in [IM01–IM20](#warning-impulse). Source was not changed; this is compatibility work, not a new Start Rule crash.

## Order of fixes and measurements

1. **Loop bounds and settings — R02–R04.** Every input state needs a finite result or controlled cancellation. Check zero/empty sets and minimum settings.
2. **Restarts and shared items — R01, R05.** Define consumable extension and cleanup, prevent restarting a waiting `randomActions`, and make item read/grant/removal indivisible between waits.
3. **State ownership and paired cleanup — R06–R15.** Account for player/objective generations, old executor termination, passenger associations, button release, detachment, and speed restoration. For R08, check the four intermediate conditions first; do not change valid terminal chase checks. Verify timer units.
4. **Selection correctness — R16–R20.** Align prepared candidates with actual selection, handle empty results, and replace incorrect indexing with membership tests where membership is intended.
5. **Long-match resources — R34–R35.** Remove accumulating empty entries, define a global item budget, and handle visual-object creation failure correctly. Coordinate the miniboss representation change with R20.
6. **Localized optimizations — R23 and R28, then R22.** Check boss spatial filtering, Force Field's list snapshot, and turret target reuse.
7. **Frequent costs — R21, R24–R32, R36–R37.** Compare target search, collisions, HUD, and special mechanics in-game. Address R33 after major costs. Preserve responsiveness, damage/impulse frequency, and target-selection semantics.

[debug.opy](src/debug.opy#L25) contains `Server Load`, `Average`, `Peak`, and text/effect counters; the display is available to a player named `snky`. In the current configuration, the HUD shows budgets of **128 texts** and **256 effects/beams/icons**; `playMoreEffects` is enabled.

For performance, compare identical maps/settings with 6 and 23 zombies. Separate scenarios: simultaneous turrets, a crowd at a barricade, boss return, many Pyrotechnic hits, a lagging NPC with a long path, and a long match with item drops/minibosses. Repeat runs because of randomness, recording average load, peaks, array lengths, and object counts; for visuals, FPS and hint latency.

For stability, start with bounded diagnostics on a separate mode copy: finite iteration limits and logs of indices/sums/generations, followed by in-game recovery checks. Test owner death/disconnection, hero changes, repeated item use, and phase transitions. Early exits must not leave invisibility, disabled gravity, attachment, or held buttons without proper termination.

## Reproducing static checks

From the project root:

```powershell
node analysis/probe-runtime-performance-2026-11-04.cjs
node analysis/check-gameplay-selection-2026-11-04.cjs
node analysis/check-runtime-safety-2026-11-04.cjs
node analysis/check-additional-state-safety-2026-11-04.cjs
node analysis/audit-original-provenance-2026-11-04.cjs
```

| Script | Checks |
|---|---|
| [probe-runtime-performance](analysis/probe-runtime-performance-2026-11-04.cjs) | Baseline build and the three R23, R28, R36 prototypes |
| [check-gameplay-selection](analysis/check-gameplay-selection-2026-11-04.cjs) | Selection counterexamples and compiled R16–R20 expressions |
| [check-runtime-safety](analysis/check-runtime-safety-2026-11-04.cjs) | Hidden warnings, loops, one-item setting, pickup/invisibility-reset models |
| [check-additional-state-safety](analysis/check-additional-state-safety-2026-11-04.cjs) | Passenger ownership, paired operations, tentacle, and dome timer R10–R15 |

`audit-original-provenance` checks line-level provenance evidence for every R/SR/CH/IM entry against the original without compiling the mod. To update the evidence file: `node analysis/audit-original-provenance-2026-11-04.cjs --write`.

The scripts print JSON with source hashes and compiled rules. They do not write `src/` or the Workshop export, run Overwatch, or execute dangerous infinite models. Passing does not prove a speedup, in-game reachability of every state, or absence of other defects.


<a id="compiler-warnings"></a>

## Full warning audit of the current compilation

Checked after the user removed four suppressions from `main.opy`. These are **warnings**; the build succeeds: **25,305 elements, 268 rules**. Diagnostics use the original `#!include`, so links point to actual files and lines. `#!writeToOutputFile` was removed only from the in-memory string; game source and export were not written.

| Category | Messages | Audit result | Direct crash risk |
|---|---:|---|---|
| `w_start_rule_crash` | 22 | All SR01–SR22 calls analyzed below; danger depends on an actual restart during Wait | Known cumulative mechanism for overlapping restarts; not all 22 sites are dangerous on normal paths |
| `w_ow2_rule_condition_chase` | 14 | 10 explained as valid; 4 intermediate conditions remain under observation; no newly proven chase defects registered | No direct crash mechanism found |
| `w_cancel_contrary_motion` | 20 | All IM01–IM20 sites listed with migration checks; the legacy mode is not equivalent to XYZ | No direct crash mechanism found |
| `w_closest_player` | 0 | Active code uses two `getRealClosestPlayer` calls with existence checks | No new defect in this category |

These are **56 messages**, not 56 independent defects. Reenabling suppressions in memory removes all 56 while producing byte-identical Workshop code. List, hashes, and original messages: [JSON audit](analysis/compiler-warning-audit-2026-11-04.json). These scenarios were not executed in-game.

### How severity and risk were assessed

**Severity** assesses the need to fix a reachable path. **Crash risk** identifies a specific mechanism and its trigger conditions. High severity for a long effect does not mean that one repeated use necessarily terminates the server. Short windows and conservative diagnostics are identified separately.

<a id="warning-start-rule"></a>

### Start Rule: the defect and common reproduction conditions

In the current code, `startRule(name)` means `StartRuleBehavior.RESTART`. If the target is already running in **the same player or global-entity context**, this cancels the old execution and starts again. The same effect on two different players is not by itself such a restart.

The primary report cited by the OverPy author links repeated restarts with **remaining wait time** to accumulation ending in internal stack overflow. This describes an observed engine defect, not a conclusion that a particular effect exceeds its CPU budget. This audit does not inspect engine internals; the threshold and crash reproduction on the current client remain untested. [Documentation by the OverPy author](https://github.com/Zezombye/overpy/blob/master/README.md#w_start_rule_crash).

The dangerous case requires all of the following: an executed waiting path, an unfinished target Wait, and another RESTART of that same target/context. Repeating after completion does not meet these conditions. A short safe two-activation run checks restart/cancellation of old execution; it neither proves a crash nor establishes the required repetition count.

The compiler propagates `hasWaitFunction` transitively through calls, including asynchronous child launches. SR01–SR03 therefore report descendant Waits although their compiled targets have no Waits of their own. A child's `NOOP` policy alone may not remove the parent's inherited warning. Verification source: installed `npm/overpy.js`, processing of `hasWaitFunction`, and the warning near line 70314.

For the timer, note another distinction: different players have separate `setPrematchTimer` executions but write one global match timer. One player's `NOOP` does not order other players' writes. Prefer a single recalculation owner with requests and state revalidation before a delayed write.

### Summary of all 22 Start Rule calls

| ID | Location | Target | Own Wait actions in target | Severity | Crash risk |
|---|---|---|---:|---|---|
| [SR01](#sr01) | [global_start_menu.opy:246](src/global_start_menu.opy#L246) | `determineZombieMode` | 0 | Low | No direct risk established: no own waits; diagnostic is transitive |
| [SR02](#sr02) | [global_start_menu.opy:297](src/global_start_menu.opy#L297) | `determineChallenge` | 0 | Low | No direct risk established: no own waits; diagnostic is transitive |
| [SR03](#sr03) | [global_start_menu.opy:351](src/global_start_menu.opy#L351) | `determineObjectiveType` | 0 | Low | No direct risk established: no own waits; diagnostic is transitive |
| [SR04](#sr04) | [global_start_menu.opy:374](src/global_start_menu.opy#L374) | `setObjectiveType` | 2 | Medium | Conditional: repeated pregame initialization while a global executor waits |
| [SR05](#sr05) | [player_start_menu.opy:72](src/player_start_menu.opy#L72) | `setPrematchTimer` | 1 | Low | Hero-selection branch is normally wait-free; may restart an earlier short wait |
| [SR06](#sr06) | [player_start_menu.opy:119](src/player_start_menu.opy#L119) | `setPrematchTimer` | 1 | Medium | Conditional, short window: wait() in the timer transition 15 -> 10 |
| [SR07](#sr07) | [player_start_menu.opy:120](src/player_start_menu.opy#L120) | `randomActions` | 1 | High | Reachable repetition in wait(1); cumulative risk across repeated restarts |
| [SR08](#sr08) | [player_start_menu.opy:127](src/player_start_menu.opy#L127) | `setPrematchTimer` | 1 | Medium | Conditional: cancellation may interrupt the previous readiness request's short wait |
| [SR09](#sr09) | [player_start_menu.opy:211](src/player_start_menu.opy#L211) | `setPrematchTimer` | 1 | Medium | At the voting-end boundary; ordinary branch has no own wait |
| [SR10](#sr10) | [player_start_menu.opy:214](src/player_start_menu.opy#L214) | `setPrematchTimer` | 1 | Medium | Short target wait when ready; the caller owns the 2 s pause |
| [SR11](#sr11) | [global_game_in_progress.opy:127](src/global_game_in_progress.opy#L127) | `objectivesManagement` | 3 | Low in normal operation | No normal repetition found; requires extra reentry into the transition |
| [SR12](#sr12) | [supply_drops.opy:472](src/supply_drops.opy#L472) | `instantRevive` | 2 | Medium | Present when resurrection operations overlap; window usually shorter than the 3 s timeout |
| [SR13](#sr13) | [supply_drops.opy:476](src/supply_drops.opy#L476) | `playerForceField` | 1 | High | Same player can repeat during a long wait; cumulative risk |
| [SR14](#sr14) | [supply_drops.opy:480](src/supply_drops.opy#L480) | `noCooldowns` | 1 | High | Same player can repeat during a long wait; cumulative risk |
| [SR15](#sr15) | [supply_drops.opy:487](src/supply_drops.opy#L487) | `airStrike` | 3 | High | Same player can repeat during a long wait; cumulative risk |
| [SR16](#sr16) | [supply_drops.opy:491](src/supply_drops.opy#L491) | `healBeacon` | 1 | High | Same player can repeat during a long wait; cumulative risk |
| [SR17](#sr17) | [supply_drops.opy:502](src/supply_drops.opy#L502) | `sentryTurret` | 1 | High | Same player can repeat during a long wait; cumulative risk |
| [SR18](#sr18) | [supply_drops.opy:506](src/supply_drops.opy#L506) | `cloakingDevice` | 1 | High | Same player can repeat during a long wait; cumulative risk |
| [SR19](#sr19) | [supply_drops.opy:510](src/supply_drops.opy#L510) | `superNano` | 2 | High | Same player can repeat during a long wait; cumulative risk |
| [SR20](#sr20) | [supply_drops.opy:514](src/supply_drops.opy#L514) | `bouncePad` | 3 | High | Same player can repeat during a long wait; cumulative risk |
| [SR21](#sr21) | [supply_drops.opy:518](src/supply_drops.opy#L518) | `ultimateCharger` | 2 | High | Same player can repeat during a long wait; cumulative risk |
| [SR22](#sr22) | [supply_drops.opy:524](src/supply_drops.opy#L524) | `stun` | 2 | High | Same player can repeat during a long wait; cumulative risk |

### Common consumable-test procedure SR12–SR22

1. Prepare **two items of the same type for one player**: duplicates can come from one crate, Biomorphing rewards, or dropping/trading. Different owners do not substitute for this scenario.
2. Use the first item, release Interact, pick up the second, and hold Interact again for 0.25 s before the first effect ends. For short windows, confirm in logs that the old subroutine was still waiting.
3. Record target reentry, position/timer updates, and the old sequence failing to complete. Then check normal cleanup, death/hero changes, and use by another player.

Holding Interact without a second item does not create arbitrary launches: accepted activation clears the inventory. `NOOP` does not queue a request or prevent consumption in `powerUpUsage:529`. Rejection must happen before consumption and before modifying the old effect's parameters. Implement extension/relocation by updating one executor's request, and independent uses through a queue. Replacing every `startRule` with a normal synchronous call would delay consumption and the Interact handler for the entire effect, so it is not a universal fix.

### Detailed scenarios for each Start Rule

<a id="sr01"></a>

#### SR01. `END VOTING` ⇢ `determineZombieMode`

**Severity:** Low. **Server-crash risk:** No direct risk established: no own waits; diagnostic is transitive.

The same **startRule(determineZombieMode)** call without **NOOP** existed at [original:1164](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1164>); its former target is [original:770](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L770>). The earlier target also has no own waits; waiting-descendant risk is considered separately. The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Own Waits: 0. Do not treat this as an independent crash reproduction; check that the entire chain does not restart and inspect SR04.

**Code:** [END VOTING rule](src/global_start_menu.opy#L239), [call:246](src/global_start_menu.opy#L246), [subroutine:282](src/global_start_menu.opy#L282).

**Chain:** `END VOTING ⇢ determineZombieMode → selectVoteWinner`; then two asynchronous branches: `⇢ determineChallenge ⇢ determineObjectiveType ⇢ setObjectiveType` and `⇢ setZombieMode`.

**In-game scenario:** pregame voting ends after at least one player selects a hero. Readiness-based countdown acceleration can bring this point forward.

**Waits and consequences:** no own `wait`/`waitUntil`, including in the compiled subroutine. Diagnostics are inherited from descendants. No direct scenario accumulating restarts of a waiting `determineZombieMode` was found. On chain reentry, the main risks concern [SR04](#sr04) and repeated mutation of settings tables.

**Proposed fix:** Explicit `NOOP` can document the policy of not restarting an active tally. It does not prevent relaunching an already completed chain: pregame-initialization state must be controlled for that. A normal call is acceptable only after checking the two child branches' order and `tmp0..2` usage; this audit does not justify bulk replacement of asynchronous calls.

**Fix verification:** normal/accelerated voting, ties, no preference, and repopulating an empty pregame session; selected modes and zombie-spawn tables must match previous behavior.

<a id="sr02"></a>

#### SR02. `determineZombieMode` ⇢ `determineChallenge`

**Severity:** Low. **Server-crash risk:** No direct risk established: no own waits; diagnostic is transitive.

The same **startRule(determineChallenge)** call without **NOOP** existed at [original:789](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L789>); its former target is [original:826](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L826>). The earlier target also has no own waits; waiting-descendant risk is considered separately. The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Own Waits: 0. Descendant policies are analyzed separately. One warning does not prove a waiting context for this subroutine.

**Code:** [calling subroutine](src/global_start_menu.opy#L282), [call:297](src/global_start_menu.opy#L297), [determineChallenge:321](src/global_start_menu.opy#L321); original rule: [END VOTING](src/global_start_menu.opy#L239).

**Chain:** `END VOTING ⇢ determineZombieMode ⇢ determineChallenge ⇢ determineObjectiveType ⇢ setObjectiveType`.

**In-game scenario:** the same voting end; challenge selection depends on Ultimate-button votes and the automatic default when votes are absent.

**Waits and consequences:** challenge tallying is wait-free. `hasWaitFunction` comes from `setObjectiveType` through `determineObjectiveType`. No independent dangerous waiting execution was found here. An actual repetition may retally already transformed vote tables; this is a separate repeated-initialization risk, not a proven `w_start_rule_crash` manifestation.

**Proposed fix:** `NOOP` instead of implicit `RESTART` can protect an active launch, but the main fix is one controlled tally cycle and safe [SR04](#sr04) launch. If tallying uses normal calls, preserve the challenge-selection formula and publish results before starting the generator.

**Fix verification:** different difficulty votes, ties, missing votes, and disabled options; voting result and completion timing must not change.

<a id="sr03"></a>

#### SR03. `determineChallenge` ⇢ `determineObjectiveType`

**Severity:** Low. **Server-crash risk:** No direct risk established: no own waits; diagnostic is transitive.

The same **startRule(determineObjectiveType)** call without **NOOP** existed at [original:850](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L850>); its former target is [original:926](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L926>). The earlier target also has no own waits; waiting-descendant risk is considered separately. The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Own Waits: 0. R04's forbidden-objective selection loop is a separate issue, not this Start Rule defect.

**Code:** [determineChallenge](src/global_start_menu.opy#L321), [call:351](src/global_start_menu.opy#L351), [determineObjectiveType:354](src/global_start_menu.opy#L354); original rule: [END VOTING](src/global_start_menu.opy#L239).

**Chain:** `END VOTING ⇢ determineZombieMode ⇢ determineChallenge ⇢ determineObjectiveType → selectVoteWinner`, then `⇢ setObjectiveType`.

**In-game scenario:** objective-type voting via Ability 2 ends. Without preferences, Mixed is selected if available; otherwise a random available type is used.

**Waits and consequences:** neither tallying nor the random-selection loop contains `Wait` in compiled code. The message is conservative and comes from asynchronous dependency `setObjectiveType`. This call alone does not prove a dangerous restart during a wait.

**Proposed fix:** Explicit `NOOP` can express launch policy, but [SR04](#sr04) is more important. Do not remove `while` to silence the warning: the wait flag comes from the child subroutine. If all options are disabled, selection warrants a separate settings audit, but that is a different issue.

**Fix verification:** Mixed enabled/disabled, one available type, tied votes; verify a single `isVoting = false` and objective-generation launch.

<a id="sr04"></a>

#### SR04. `determineObjectiveType` ⇢ `setObjectiveType`

**Severity:** Medium. **Server-crash risk:** Conditional: repeated pregame initialization while a global executor waits.

The same **startRule(setObjectiveType)** call without **NOOP** existed at [original:950](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L950>); its former target is [original:953](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L953>). Waits already existed in that target: [original:957](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L957>), [original:970](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L970>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Wait for setObjectiveType before START GAME and, if the lobby preserves the pregame session after everyone leaves, trigger another preparation/voting cycle. Record a second entry before the first ends. Fast normal voting alone does not reproduce repetition.

**Code:** [call:374](src/global_start_menu.opy#L374), [setObjectiveType:389](src/global_start_menu.opy#L389), [start wait:393](src/global_start_menu.opy#L393), [position-selection wait:407](src/global_start_menu.opy#L407), [objectivesManagement:552](src/subroutines.opy#L552).

**Chain:** the entire `END VOTING` chain above, then `setObjectiveType → objectivesManagement → globalObjectiveEntityManagementMacro`.

**In-game scenario:** after vote tallying, the generator waits for game start. Team readiness/cancellation changes that wait's duration. Repeating voting after an empty pregame session is a possible relaunch path requiring in-game verification.

**Waits and consequences:** `waitUntil(..., 99999)` may last for the rest of pregame; later there are repeated position-generation `wait()` waits and first-objective setup waits. Another global `RESTART` during this period matches the dangerous pattern. Once generation starts, restarting may also leave partially filled lists and interrupt setup: the subroutine's beginning does not fully roll back state.

**Proposed fix:** Despite long waits, the normal launch is one-off. Use `startRule(setObjectiveType, StartRuleBehavior.NOOP)` if the policy is one generator per match. For repeated preparation, explicitly define whether to retain the generator with new settings or fully cancel/reinitialize it; `NOOP` alone cannot provide those semantics. Do not make the entire chain synchronous through `END VOTING`: waiting for start would delay its remaining code, including the message and timer assignment.

**Fix verification:** long preparation after voting, readiness/cancellation, empty session and reentry, Mixed and many objectives. The generator must finish once, type/position lists must correspond, and `isGameplayActive` must enable.

<a id="sr05"></a>

#### SR05. Hero selection/reselection ⇢ `setPrematchTimer`

**Severity:** Low. **Server-crash risk:** Hero-selection branch is normally wait-free; may restart an earlier short wait.

The same **startRule(setPrematchTimer)** call without **NOOP** existed at [original:1286](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1286>); its former target is [original:1174](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1174>). Waits already existed in that target: [original:1201](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1201>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** A new call during SELECTING_HERO is normally synchronous. Dangerous overlap is possible only if the same player previously left setPrematchTimer in its short wait; there is no separate long wait here.

**Code:** [PLAYER SELECTS/RESELECTS HERO:63](src/player_start_menu.opy#L63), [call:72](src/player_start_menu.opy#L72), [setPrematchTimer](src/subroutines.opy#L498).

**Chain:** `hero selection/respawn → PLAYER SELECTS/RESELECTS HERO ⇢ setPrematchTimer`.

**In-game scenario:** a Team 1 player spawns during pregame in `SELECTING_HERO`; the menu is already placed. This covers initial selection or returning through Crouch. The same rule automatically presses Jump after 5 seconds for a player with no preference, but that goes through [SR06](#sr06)/[SR07](#sr07), not a repetition of line 72.

**Waits and consequences:** under these entry conditions, the player is not ready, so after voting the timer-restoration branch runs without `wait`; before voting ends there are no waits either. This path normally creates no dangerous wait of its own. The call could theoretically interrupt another still-running execution launched elsewhere for the same player; the short window needs testing.

**Proposed fix:** Include this in centralized timer recalculation. Simply replacing it with `NOOP` may lose an important countdown restoration on hero change while old execution is active. If the current structure remains, revalidate state before the delayed write of 10.

**Fix verification:** first hero selection, Crouch before `SELECTING_HERO`, reselection, and late entry before match start; an old readiness request must not leave the countdown shortened.

<a id="sr06"></a>

#### SR06. Jump readiness confirmation ⇢ `setPrematchTimer`

**Severity:** Medium. **Server-crash risk:** Conditional, short window: wait() in the timer transition 15 -> 10.

The same **startRule(setPrematchTimer)** call without **NOOP** existed at [original:1328](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1328>); its former target is [original:1174](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1174>). Waits already existed in that target: [original:1201](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1201>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** After voting ends, the last player's READY starts 15 -> wait() -> 10. A restart must hit exactly that short wait in the same context; merely waiting 15 seconds does not reproduce the defect.

**Code:** [PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY):106](src/player_start_menu.opy#L106), [call:119](src/player_start_menu.opy#L119), [timer waiting branch:523](src/subroutines.opy#L523).

**Chain:** `Jump → pregameState becomes READY ⇢ setPrematchTimer`; then [SR07](#sr07) and `⇢ randomActions` launch independently.

**In-game scenario:** a player confirms readiness; a forced Jump from hero selection can take the same path. After voting, the last ready player shortens the shared timer.

**Waits and consequences:** no wait before voting ends. Afterward, `15 → wait() → 10` is possible. Readiness cancellation or another timer call for the same player during this short wait can restart execution. Repeatedly hitting this window is less likely than with one-second effects; treating every Jump press as dangerous would be incorrect. A race with another player's state change is also possible.

**Proposed fix:** One timer handler revalidating phase/readiness and processing new requests. `NOOP` without a recalculation mechanism may lose an update. If delay is necessary, store a request/state version and cancel a stale write of 10 by returning normally.

**Fix verification:** the last player presses Jump, then they or another player immediately cancel readiness; compare visible and hidden timers and check against premature start.

<a id="sr07"></a>

#### SR07. Jump readiness confirmation ⇢ `randomActions`

**Severity:** High. **Server-crash risk:** Reachable repetition in wait(1); cumulative risk across repeated restarts.

The same **startRule(randomActions)** call without **NOOP** existed at [original:1329](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1329>); its former target is [original:1503](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1503>). Waits already existed in that target: [original:1516](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1516>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Jump, release both buttons, Crouch, release both, Jump; the second READY must occur less than 1 s after the first. The randomActions entry log should appear twice before the first pause ends. One sequence demonstrates wait cancellation, not a guaranteed crash.

**Code:** [menu rule:106](src/player_start_menu.opy#L106), [call:120](src/player_start_menu.opy#L120), [randomActions:234](src/player_start_menu.opy#L234), [wait(1):249](src/player_start_menu.opy#L249).

**Chain:** `Jump → READY ⇢ randomActions → random emote → wait(1) → random voice line`.

**In-game scenario:** a player presses Jump to ready, Crouch to cancel, then Jump again within a second. This is available before the match starts; continuously holding one button is insufficient—a new transition to READY is required.

**Waits and consequences:** an explicit `wait(1)` means the same player's repeated readiness can genuinely interrupt a wait. Repeated toggling creates cumulative server risk. Visible effect: the first emote repeats, while the previous launch's delayed voice line never executes. There is also no post-wait readiness/phase check: the line may play after readiness cancellation or game start.

**Proposed fix:** This is a simple reachable scenario without finding a second item. Use `NOOP` for the cosmetic sequence. After waiting, check `isPregameSetup` and `pregameState == READY`; if the line must reflect the latest confirmation, update a request handled by one executor without `RESTART`.

**Fix verification:** repeated `Jump → Crouch → Jump` at intervals < 1 second; separately test match start between emote and voice line. Restarts must not create new waits.

<a id="sr08"></a>

#### SR08. Crouch: cancel readiness/change hero ⇢ `setPrematchTimer`

**Severity:** Medium. **Server-crash risk:** Conditional: cancellation may interrupt the previous readiness request's short wait.

The same **startRule(setPrematchTimer)** call without **NOOP** existed at [original:1336](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1336>); its former target is [original:1174](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1174>). Waits already existed in that target: [original:1201](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1201>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Cancel READY for the same player while their previous setPrematchTimer still waits between 15 and 10. The window is short; another player's simultaneous readiness belongs to a different execution entity.

**Code:** [menu rule:106](src/player_start_menu.opy#L106), [Crouch-branch call:127](src/player_start_menu.opy#L127), [setPrematchTimer](src/subroutines.opy#L498).

**Chain:** `Crouch → decrease pregameState ⇢ setPrematchTimer`; transitioning to `SELECTING_HERO` then starts hero changing, followed potentially by [SR05](#sr05).

**In-game scenario:** READY becomes HERO_SELECTED, or HERO_SELECTED becomes SELECTING_HERO. This should normally restore a longer countdown.

**Waits and consequences:** after decreasing state, the caller is not ready, so the new launch does not itself enter the waiting branch. It can, however, restart a short wait left by [SR06](#sr06) for the same player. This can trigger the bug. Simply ignoring cancellation through `NOOP` is also logically unsafe: the old execution may write 10 after readiness has been canceled.

**Proposed fix:** Process cancellation through the shared timer design; canceling readiness must invalidate the old delayed request and reliably account for the new state. `NOOP` at line 127 alone is insufficient.

**Fix verification:** Crouch immediately after the last player becomes ready, then reselect a hero; the match must not start from a stale shortened timer.

<a id="sr09"></a>

#### SR09. Releasing voting buttons ⇢ first `setPrematchTimer`

**Severity:** Medium. **Server-crash risk:** At the voting-end boundary; ordinary branch has no own wait.

The same **startRule(setPrematchTimer)** call without **NOOP** existed at [original:1480](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1480>); its former target is [original:1174](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1174>). Waits already existed in that target: [original:1201](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1201>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Release voting buttons at the isVoting true -> false boundary with everyone READY, then call the timer again for the same player. The ordinary isVoting == true branch does not wait.

**Code:** [UPDATE PREGAME VOTING STATUS:202](src/player_start_menu.opy#L202), [call:211](src/player_start_menu.opy#L211); sources of `isPregameVoting = true`: [Ultimate](src/player_start_menu.opy#L137), [Ability 1](src/player_start_menu.opy#L154), [Ability 2](src/player_start_menu.opy#L171).

**Chain:** `button vote → isPregameVoting = true → release all three buttons → UPDATE PREGAME VOTING STATUS ⇢ setPrematchTimer → wait(2)`; then [SR10](#sr10). Melee selects Enhancement and does not itself set this flag.

**In-game scenario:** a player stops voting; initial recalculation still sees `isPregameVoting == true` and normally restores voting time from the hidden timer.

**Waits and consequences:** while `isVoting == true`, the target does not wait. The rule itself has no `isVoting == true` condition, so an old player flag may remain true at the voting-end boundary; if everyone is ready, the waiting branch is possible. Other rules calling for that same player can then overlap the short `wait`.

**Proposed fix:** Include this in the shared timer fix; its independent contribution is normally low. Preserve the distinction between “buttons released but still considered voting” and “2 seconds elapsed.” Do not substitute a normal call without analysis: a waiting target would delay the start of the local two-second wait.

**Fix verification:** short/frequent vote changes, holding/releasing buttons around 30 seconds, and voting end overlapping READY/readiness cancellation.

<a id="sr10"></a>

#### SR10. Two-second interval completes ⇢ second `setPrematchTimer`

**Severity:** Medium. **Server-crash risk:** Short target wait when ready; the caller owns the 2 s pause.

The same **startRule(setPrematchTimer)** call without **NOOP** existed at [original:1483](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1483>); its former target is [original:1174](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1174>). Waits already existed in that target: [original:1201](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1201>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** End voting during the local 2 s preceding the second call, then overlap the target's short pause with another call for the same player. Calls at 211/214, separated by 2 s, normally do not restart each other.

**Code:** [UPDATE PREGAME VOTING STATUS](src/player_start_menu.opy#L202), [wait:212](src/player_start_menu.opy#L212), [call:214](src/player_start_menu.opy#L214), [setPrematchTimer](src/subroutines.opy#L498).

**Chain:** path [SR09](#sr09) → `wait(2, Wait.ABORT_WHEN_FALSE) → isPregameVoting = false ⇢ setPrematchTimer`.

**In-game scenario:** all three voting buttons remain released for 2 consecutive seconds. Pressing again violates the rule condition and interrupts the wait. After successful waiting, the timer is recalculated for a player who has finished voting.

**Waits and consequences:** before voting ends, the target is wait-free. If voting ends during those 2 seconds and everyone is ready, it may enter `15 → wait → 10`. Calls 211/214 themselves are 2 seconds apart and normally do not overlap; danger comes from other same-player calls near the second site. The caller, not `setPrematchTimer`, owns the two-second wait.

**Proposed fix:** Include this in unified recalculation; preserve the two-second end-of-voting detection and guarantee the final update is processed. The timer handler must check phase before a delayed write.

**Fix verification:** stop voting 1–2 seconds before its end; then everyone is ready or one player cancels readiness. Check that resumed voting interrupts the wait.

<a id="sr11"></a>

#### SR11. `OBJECTIVE COMPLETE` ⇢ `objectivesManagement`

**Severity:** Low in normal operation. **Server-crash risk:** No normal repetition found; requires extra reentry into the transition.

The same **startRule(objectivesManagement)** call without **NOOP** existed at [original:1710](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1710>); its former target is [original:1732](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1732>). Waits already existed there: [original:1774](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1774>), [original:1779](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1779>). The assessment concerns current reachability, not a reproduced original crash. The current compiled target's additional third Wait is in the inlined visual-object macro; the original already had that wait in called `globalObjectiveEntityManagement` at [original:1855](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1855>). The own-Wait count differs because an earlier subroutine was inlined.

**Reproduction control:** No normal human-triggered double-launch scenario was found: isObjectiveComplete remains true until the transition finishes. Testing protection requires explicitly introducing a second entry during transition; do not describe it as an existing normal double transition.

**Code:** [OBJECTIVE COMPLETE:123](src/global_game_in_progress.opy#L123), [call:127](src/global_game_in_progress.opy#L127), [objectivesManagement:552](src/subroutines.opy#L552), [entity macro:234](src/subroutines.opy#L234).

**Chain:** `objective reaches completion condition → isObjectiveComplete = true → OBJECTIVE COMPLETE ⇢ objectivesManagement → globalObjectiveEntityManagementMacro`. After launching the subroutine, the rule also adds rescue time for some dead players. A second, normal call exists: `setObjectiveType → objectivesManagement` during initial setup, before `isGameplayActive = true`.

**In-game completion sources:**

- Hold Showdown to the required percentage: [INCREASE OBJECTIVE CAPTURE PERCENTAGE](src/objective_types/objective_type_showdown.opy#L29).
- Kill a boss/object registered in the boss list, including relevant Egg targets: [BOSS DIES (ALL BOSS OBJECTIVES)](src/objective_types/objective_type_bosses.opy#L119) → [completeBossObjective](src/objective_types/objective_type_bosses.opy#L221).
- Finish Biomorphing processing: [ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS](src/objective_types/objective_type_biomorphing.opy#L74).
- Deliver the survivor and subsequently complete Rescue: [SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE](src/objective_types/objective_type_survivor_rescue.opy#L4).
- Score kills in Kill Zone: [MODIFY KILL ZONE SCORE](src/objective_types/objective_type_kill_zone.opy#L4).
- Repair all terminals: [PLAYERS REPAIR TERMINALS](src/objective_types/objective_type_satellite_uplink.opy#L123).

**Waits and consequences:** transition includes `wait()` before removing the first objective, `wait(0.25)`, and old-visual cleanup waits. Restarting can interrupt cleanup; repeating the beginning may remove another objective, reset progress, and desynchronize effects/lists. These are conditional consequences of actual reentry, not an observed normal double removal.

**Reachability:** normal risk is relatively low. `isObjectiveComplete` resets to `false` at the end, after waiting operations. The rule has no `loop()`; keeping `true` does not launch it every frame. Initial calling occurs with `isGameplayActive` disabled. The audit found no reliable normal path to frequent overlapping global launches.

**Proposed fix:** Because progress corruption could be serious, explicit `NOOP` matches a “one transition in progress” policy. For stronger protection, add transition state and an already-processed objective ID; remove list heads once. Preserve asynchrony relative to rescue-time bonuses or separately verify the changed order.

**Fix verification:** every objective type, the final objective before extraction, several nearly simultaneous boss deaths/score updates. Each completion removes exactly one position/type, HUD/description match the next objective, and dead-player bonuses are granted once.

<a id="sr12"></a>

#### SR12. Revive, ID 2 ⇢ `instantRevive`

**Severity:** Medium. **Server-crash risk:** Present when resurrection operations overlap; window usually shorter than the 3 s timeout.

The same **startRule(instantRevive)** call without **NOOP** existed at [original:6500](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6500>); its former target is [original:6110](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6110>). Waits already existed in that target: [original:6114](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6114>), [original:6117](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6117>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** The window is unfinished resurrection confirmation, not necessarily 3 s. With rapid successful resurrection, a manual repeat may occur after completion and will not confirm the danger.

**Code:** [Interact rule](src/supply_drops.opy#L81), [case 2 call:472](src/supply_drops.opy#L472), [instantRevive:132 / Workshop rule `instantRevive (0-9)`](src/supply_drops.opy#L132).

**Chain:** `pick up Revive → Interact → powerUpUsage → check dead players within 5 m ⇢ instantRevive → select target by facing direction → wait() → INVINCIBLE and resurrect → waitUntil(isAlive, 3) → sound/message`.

**In-game scenario:** use near a dead ally, then obtain a second Revive and use it while the first still awaits completion. If the first ally is already alive, another dead ally must be in range for a second launch; otherwise the dispatcher returns without consumption.

**Waits and consequences:** a short `wait()` and resurrection-confirmation wait with a 3-second timeout. This is not a mandatory three-second duration: successful resurrection usually ends it earlier. With overlap, restarting matches the dangerous pattern; the first operation's final message may be lost and `powerUpReviveTarget` changes. Restarting does not undo an already executed `resurrect()`.

**Proposed fix:** Given the usually short window, the simplest solution is to reject repeats until completion while preserving the item and launching with `NOOP`. For multiple rapid resurrections, queue targets with existence/death checks before processing, without replacing an unfinished operation's target.

**Fix verification:** two dead allies and two Revive items; repeat at operation start and with slow confirmation. Rejection preserves the second item and the intended target is resurrected.

<a id="sr13"></a>

#### SR13. Force Field, ID 3 ⇢ `playerForceField`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(playerForceField)** call without **NOOP** existed at [original:6503](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6503>); its former target is [original:6122](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6122>). Waits already existed in that target: [original:6138](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6138>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Force Fields for one owner; repeat within 10 s while the field repels zombies or waits in wait(0.032). Check center relocation and timer refresh.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:476](src/supply_drops.opy#L476), [playerForceField:144 / rule `playerForceField (10-19)`](src/supply_drops.opy#L144).

**Chain:** `Force Field → Interact → powerUpUsage(case 3) ⇢ playerForceField → owner position → create sphere/HUD if needed → repulsion loop → cleanup`.

**In-game scenario:** the player places a field and picks up a second Force Field during its lifetime. Reuse currently writes a new position and restarts duration; with entities already present, this effectively relocates/refreshes the existing field.

**Waits and consequences:** approximately 10 seconds, with `wait(0.032)` at every step. The dangerous restart window is large relative to pressing/pickup time. Old cleanup is interrupted, but this does not guarantee a leak: the new launch reuses existing entities and may clean them later. Relocation and extended repulsion are additional gameplay effects that must not be disabled without choosing a policy.

**Proposed fix:** Retain one field loop; accepted repeated items separately update `powerUpForceFieldPosition` and expiry. Create sphere/HUD only on initial activation and remove them on final expiration. If relocation/refresh is unwanted, reject before consumption and use `NOOP`.

**Fix verification:** second field at a new position mid-effect and near expiry; one sphere/HUD, repulsion at the current position, no restart of the old instance.

<a id="sr14"></a>

#### SR14. No Cooldowns, ID 4 ⇢ `noCooldowns`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(noCooldowns)** call without **NOOP** existed at [original:6506](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6506>); its former target is [original:6144](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6144>). Waits already existed in that target: [original:6168](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6168>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two No Cooldowns items; apply the second before 15 s expire, during a wait(0.032). Check that one executor accepts the new expiry.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:480](src/supply_drops.opy#L480), [noCooldowns:168 / rule `noCooldowns (20-29)`](src/supply_drops.opy#L168).

**Chain:** `No Cooldowns → Interact → powerUpUsage(case 4) ⇢ noCooldowns → sound/HUD → cooldown-reset/charge-restoration loop → remove HUD`.

**In-game scenario:** activate the buff, then use another item as the same player within approximately 15 seconds. Current code restarts the countdown; two players using their own items are not this same scenario.

**Waits and consequences:** the loop uses `wait(0.032)`. A repeat can hit the wait and accumulate dangerous restarts. The HUD has an ID guard, so repetition does not necessarily create another HUD. Renewed execution continues the bonus with a new duration; an incorrect fix may lose the second buff or leave the HUD after effect end.

**Proposed fix:** One executor with an updatable expiry; repeats either reset full duration or add time according to policy. Move time management from restarting `for` into checked state. Use `NOOP` only together with request acceptance/rejection before consumption.

**Fix verification:** repeat mid-effect and immediately before completion; actual cooldowns/charges and HUD continue to the agreed expiry, then the HUD is removed.

<a id="sr15"></a>

#### SR15. Air Strike, ID 5 ⇢ `airStrike`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(airStrike)** call without **NOOP** existed at [original:6512](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6512>); its former target is [original:6173](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6173>). Waits already existed in that target: [original:6176](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6176>), [original:6186](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6186>), [original:6200](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6200>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Air Strikes; apply the second during the first 2 s of preparation or between explosions in wait(0.125). This interrupts the old bombardment and starts preparation again.

**Code:** [Interact rule](src/supply_drops.opy#L81), [surface check:484](src/supply_drops.opy#L484), [call:487](src/supply_drops.opy#L487), [airStrike:197 / rule `airStrike (30-39)`](src/supply_drops.opy#L197).

**Chain:** `Air Strike → Interact → powerUpUsage(case 5) → surface check within 40 m ⇢ airStrike → wait() → select strike point → markers → wait(2) → 50 explosions with wait(0.125) → cleanup`.

**In-game scenario:** aim at an eligible surface, activate the strike, then obtain/use a second Air Strike before the first ends. Aiming beyond the allowed range makes the dispatcher show a message and preserve the item.

**Waits and consequences:** approximately 8.25 seconds plus the initial minimal `wait()`. A repeat during two-second preparation cancels the old wait; during bombardment, it interrupts remaining explosions, moves the point, and restarts the countdown. This changes the already paid-for first strike in addition to cumulative server risk. Marker creation has ID guards; a persistent leak on every repeat is not proven.

**Proposed fix:** For independent strikes, prefer rejection until completion with the second item preserved, or a queue of independent requests. If intentional point replacement is wanted, use a request to one executor with explicit old-phase termination, without `RESTART`. Queue each accepted strike's point rather than one mutable shared aim point.

**Fix verification:** repeat during the first 2 seconds and after initial explosions; check point, explosion count/completion, consumption, and ring/cloud removal under the chosen policy.

<a id="sr16"></a>

#### SR16. Beacon of Healing, ID 6 ⇢ `healBeacon`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(healBeacon)** call without **NOOP** existed at [original:6515](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6515>); its former target is [original:6206](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6206>). Waits already existed in that target: [original:6224](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6224>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Beacons of Healing; apply the second within 30 s during wait(1). Check the new position/duration and exactly-once healing-dealt restoration.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:491](src/supply_drops.opy#L491), [healBeacon:235 / rule `beaconofHealing (40-49)`](src/supply_drops.opy#L235).

**Chain:** `Beacon → Interact → powerUpUsage(case 6) ⇢ healBeacon → position → entities/HUD/aura if needed → setHealingDealt(150) → 30 healing steps → cleanup and setHealingDealt(100)`.

**In-game scenario:** the same player reuses a beacon within approximately 30 seconds. Position changes to the owner's current position and the timer restarts; existing entities use the updated position.

**Waits and consequences:** every step includes `wait(1)`, so repetition can easily hit a wait. Restarting skips the old execution's completion, including restoring outgoing healing to 100; the new launch usually performs cleanup later. Extending the refreshed bonus may be intended behavior. Interruption without correct new completion leaves HUD/entities and an altered healing parameter.

**Proposed fix:** One beacon handler with separately updatable position and expiry. Initialize and finally restore healing once per uninterrupted active period; do not destroy the old beacon mid-extension after accepting it. Rejection must preserve the player's item.

**Fix verification:** repeat at a new position with players in old/new healing zones; correct healing duration and restoration of `Healing Dealt` after final completion.

<a id="sr17"></a>

#### SR17. Sentry Turret, ID 8 ⇢ `sentryTurret`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(sentryTurret)** call without **NOOP** existed at [original:6524](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6524>); its former target is [original:6235](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6235>). Waits already existed in that target: [original:6263](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6263>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Sentry Turrets; repeat within 30 s between shots during wait(0.125). Check position, expiry, and a single effect/HUD set.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:502](src/supply_drops.opy#L502), [sentryTurret:264 / rule `sentryTurret (50-59)`](src/supply_drops.opy#L264).

**Chain:** `Turret → Interact → powerUpUsage(case 8) ⇢ sentryTurret → ground-adjusted position → body/legs/barrel/HUD → target selection and firing → cleanup`.

**In-game scenario:** place a turret, then obtain/use another within approximately 30 seconds. This currently moves the existing turret and restarts its lifetime; it does not necessarily create two turrets.

**Waits and consequences:** `wait(0.125)` in the firing loop. Reuse can restart a waiting instance and accumulate server risk. The old pass never reaches entity removal; the new one reuses the created set and can remove it later. An incorrect fix may lose relocation/extension, leave turret parts, or duplicate HUDs.

**Proposed fix:** If retaining one turret per player, use one loop and update position/expiry on an accepted repeat. Multiple independent turrets require separate instances with their own positions/IDs; the current single-player fields are insufficient. Minimal option: reject placement until completion without consuming the item.

**Fix verification:** repeat near a new target group and at expiry; one consistent turret, correct aim/damage, and removal of every part/HUD.

<a id="sr18"></a>

#### SR18. Cloaking Device, ID 9 ⇢ `cloakingDevice`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(cloakingDevice)** call without **NOOP** existed at [original:6527](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6527>); its former target is [original:6273](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6273>). Waits already existed in that target: [original:6295](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6295>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Cloaking Devices; repeat before 25 s expire during waitUntil(..., 1). Then test manual cancellation and death: remove invisibility-count and speed contributions exactly once.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:506](src/supply_drops.opy#L506), [cloakingDevice:302 / rule `cloakingDevice (60-69)`](src/supply_drops.opy#L302).

**Chain:** `Cloaking → Interact → powerUpUsage(case 9) ⇢ cloakingDevice → initial speed/sphere/HUD/invisibilityCount setup → loop up to 25 seconds → final invisibilityCount decrement, cleanup, restore speed multiplier`.

**In-game scenario:** reuse during cloaking. A separate normal completion path is Crouch + Interact after the first seconds; death also ends the loop. Do not use the cancellation combination simultaneously when testing the repeated item.

**Waits and consequences:** `waitUntil(cancellation combination, 1)` at loop steps; a repeat can interrupt an unfinished wait. Paired speed and `invisibilityCount` changes matter. The current `powerUpCloakingDeviceSphereId == 0` check normally prevents repeated speed multiplication/counter increments when merely refreshing an active effect: indefinite stacking is not established. Interrupted or incorrectly rewritten cleanup can nevertheless upset the balance.

**Proposed fix:** One handler with expiry extension/refresh; first initialization and final rollback must each occur once. Explicitly decide whether reuse refreshes the protective interval before cancellation is allowed. Combine expiry, death, and manual cancellation into one cleanup path. Do not treat the sphere ID as a universal lifecycle-state substitute without checking the completion phase.

**Fix verification:** repeat, manual cancellation, death, and other sources modifying `invisibilityCount`/speed; after effect end, counter/multiplier retain other mechanics' contributions and HUD/sphere are removed.

<a id="sr19"></a>

#### SR19. Super Nano, ID 10 ⇢ `superNano`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(superNano)** call without **NOOP** existed at [original:6530](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6530>); its former target is [original:6306](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6306>). Waits already existed in that target: [original:6329](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6329>), [original:6330](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6330>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Super Nanos; repeat before 20 s expire during wait(1), then separately in the final 0.25 s before cleanup. Check healing, damage modifiers, speed, and effect existence.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:510](src/supply_drops.opy#L510), [superNano:335 / rule `superNano (70-79)`](src/supply_drops.opy#L335).

**Chain:** `Super Nano → Interact → powerUpUsage(case 10) ⇢ superNano → initial speed/aura/HUD/damage-modifier setup → healing and incoming-damage reduction → loop → wait(0.25) → cleanup and parameter rollback`.

**In-game scenario:** repeat before the approximately 20-second effect ends, or use a new item near death/final cleanup. A second item currently refreshes time and repeats immediate healing.

**Waits and consequences:** `wait(1)` in the loop plus `wait(0.25)` before cleanup. A dangerous restart is possible at both sites. Modifier creation and speed multiplication are guarded by `powerUpSuperNanoGoodAuraId == 0`, so each repeat need not stack another set. Old final rollback is interrupted; the new launch usually completes it, but an incorrect rewrite can leave bonuses/modifiers or restore speed incorrectly.

**Proposed fix:** Separate one-time initialization, updatable expiry, immediate healing on reuse, and one final cleanup. An accepted extension request must not restart the executor. The final 0.25 seconds need an explicit policy: continue the effect or reject without consumption; do not accept an extension only to delete it immediately.

**Fix verification:** repeat mid-effect, just before expiry, during the final delay, and after death; check healing, damage dealt/received, speed, HUD/auras, and modifier removal.

<a id="sr20"></a>

#### SR20. Bounce Pad, ID 11 ⇢ `bouncePad`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(bouncePad)** call without **NOOP** existed at [original:6533](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6533>); its former target is [original:6343](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6343>). Waits already existed in that target: [original:6354](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6354>), [original:6368](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6368>), [original:6369](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6369>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Bounce Pads; repeat within approximately 61 s, including the initial wait(1), loop wait(0.125), and final wait(0.25). Check relocation and that old cleanup does not remove the newly accepted effect.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:514](src/supply_drops.opy#L514), [bouncePad:372 / rule `bouncePad (80-89)`](src/supply_drops.opy#L372).

**Chain:** `Bounce Pad → Interact → powerUpUsage(case 11) ⇢ bouncePad → pad position and ring/HUD → wait(1) → launch loop → wait(0.25) → cleanup`.

**In-game scenario:** the same player places another pad before the old one disappears. The shared position changes and duration restarts; other survivors can use the owner's pad without relaunching that owner's subroutine.

**Waits and consequences:** initial second, approximately 60 seconds looping with `wait(0.125)`, and final 0.25 seconds. This is one of the widest reuse windows. Restarting during operation creates cumulative risk and repeats the startup delay, temporarily interrupting launches. A nonzero ID causes ring/HUD reuse, so inevitable duplication is not established.

**Proposed fix:** One pad handler with position/expiry updated by separate requests. Preserve or explicitly reconsider the startup second on relocation. If multiple pads are forbidden, reject before consumption; if allowed, use independent object records rather than overwriting the owner's sole position.

**Fix verification:** reuse during startup delay, under players, and during final cleanup; check the new position, preserved items, and correct ring/HUD removal.

<a id="sr21"></a>

#### SR21. Ultimate Charger, ID 12 ⇢ `ultimateCharger`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(ultimateCharger)** call without **NOOP** existed at [original:6536](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6536>); its former target is [original:6375](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6375>). Waits already existed in that target: [original:6385](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6385>), [original:6386](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6386>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Ultimate Chargers; repeat within 20 s during wait(0.125), then separately during final wait(0.25). Already granted ultimate charge remains; check refreshed expiry and a single charging rate.

**Code:** [Interact rule](src/supply_drops.opy#L81), [call:518](src/supply_drops.opy#L518), [ultimateCharger:402 / rule `ultimateCharger (90-99)`](src/supply_drops.opy#L402).

**Chain:** `Ultimate Charger → Interact → powerUpUsage(case 12) ⇢ ultimateCharger → HUD/sound → add 2 charge every 0.125 seconds → wait(0.25) → remove HUD`.

**In-game scenario:** the player uses another charger within approximately 20 seconds; reuse currently restarts duration. Using Ultimate itself does not relaunch this subroutine.

**Waits and consequences:** `wait(0.125)` at steps and final `wait(0.25)`. A second item can interrupt the wait. Charge already granted remains; the issue is restart, refreshed duration, and HUD cleanup, not rollback of past charge. A nonzero HUD ID limits repeated interface creation.

**Proposed fix:** One charging loop with updatable expiry; choose full-duration refresh or added time. Refresh must not create another charging loop, which would double the effective rate. Rejection/`NOOP` must preserve the second item.

**Fix verification:** reuse, use immediately after Ultimate, reaching full charge, and final 0.25 seconds; no multiple parallel charging loops, and timely HUD removal.

<a id="sr22"></a>

#### SR22. Stun, ID 13 ⇢ `stun`

**Severity:** High. **Server-crash risk:** Same player can repeat during a long wait; cumulative risk.

The same **startRule(stun)** call without **NOOP** existed at [original:6541](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6541>); its former target is [original:6391](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6391>). Waits already existed in that target: [original:6412](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6412>), [original:6416](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6416>). The assessment above concerns current scenario reachability and does not imply a reproduced crash in the original.

**Reproduction control:** Two Stuns and several living zombies; use the second during waitUntil(beam arrival, 3) or the inter-target wait(). Check origin/target, remaining hops, and beam/chase cleanup.

**Code:** [Interact rule](src/supply_drops.opy#L81), [target check:523](src/supply_drops.opy#L523), [call:524](src/supply_drops.opy#L524), [stun:418 / rule `stun (100-109)`](src/supply_drops.opy#L418).

**Chain:** `Stun → Interact → powerUpUsage(case 13) → living target within 15 * sizeScale and angle < 45° ⇢ stun → beam/initial target → up to 50 hops → stopChasing and remove beam`.

**In-game scenario:** use amid a zombie group; another Stun from the same owner before the chain ends. Without an eligible activation target, the dispatcher shows a message and preserves the item. A stunned enemy is not the initiator of repeated `startRule`.

**Waits and consequences:** hops include `waitUntil(beam arrival, 3)` and `wait()`; actual duration depends on targets/movement. The chain ends early without a next target. 50 × 3 seconds is only a rough upper bound on summed timeouts, not normal duration. Restarting cuts the old chain, changes shared `origin`/`target`/beam position, and resets the counter; unfinished `chase` and the old beam need coordinated cleanup. Already applied stuns are not canceled immediately.

**Proposed fix:** Minimal option: remain busy until full chain completion, preserve the second item on rejection, and use `NOOP`. Repeated chains require queued requests with independent inputs. “Extend expiry” is not equivalent to another Stun: define new-hop count and starting target. Recheck target existence after waits; clean beam movement/entity through one path on every exit.

**Fix verification:** second Stun in a dense group, disappearance/death of the current target during a wait, and no next target. Items/chain counts match the chosen policy; no old beam or active `chase` after completion.

<a id="warning-chase"></a>

### Chase: all 14 messages analyzed without treating valid sites as defects

The compiler flags a condition read if it finds a chase of that variable anywhere. It does not prove the chase is active for the same player and phase. Documentation distinguishes intermediate values from chase destination/stopping. Terminal cooldowns, zero damage radius, and nonoverlapping roles below are therefore accepted as valid from the code structure. [Description of condition behavior](https://github.com/Zezombye/overpy/blob/master/README.md#w_ow2_rule_condition_chase).

**Result: 10 messages are not defects. Four intermediate conditions are checked separately but are likewise not declared proven failures without in-game reproduction.** The claim that “all 14 break the mechanic” is withdrawn; valid terminal checks need no rewrite just to silence messages. This audit did not run the game, so “valid” means no code-level defect found and consistency with terminal state, not an invented successful gameplay test.

| ID | Location / variable | Verdict and reason | Severity / crash risk | Proposal | Provenance |
|---|---|---|---|---|---|
| CH01 | [objective_types/objective_type_extraction_point.opy:16](src/objective_types/objective_type_extraction_point.opy#L16) / `objectiveRad` | Valid: fixed radius. During extraction, objectiveRad = 10; Showdown stops its chase on completion. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2041](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2041>), [original:1785](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1785>). Not a defect. |
| CH02 | [objective_types/objective_type_extraction_point.opy:34](src/objective_types/objective_type_extraction_point.opy#L34) / `extractionZoneRad` | Intermediate threshold; verify. 300 -> 0 crosses 200 before chase ends. Infection outside may start late. | Under observation; medium if reproduced; no direct crash risk found | Reproduce the scenario below first. If confirmed, use controlled polling/published state rather than intermediate-chase dependence. | Inherited condition: [original:2059](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2059>), [original:1784](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1784>). Risk in an older construct; no in-game failure established. |
| CH03 | [objective_types/objective_type_extraction_point.opy:35](src/objective_types/objective_type_extraction_point.opy#L35) / `extractionZoneRad` | Intermediate boundary; verify. Radius crosses the distance to a stationary player before reaching zero. Do not claim reproduction without running the game. | Under observation; medium if reproduced; no direct crash risk found | Reproduce the scenario below first. If confirmed, use controlled polling/published state rather than intermediate-chase dependence. | Inherited condition: [original:2060](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2060>), [original:1784](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1784>). Risk in an older construct; no in-game failure established. |
| CH04 | [objective_types/objective_type_extraction_point.opy:72](src/objective_types/objective_type_extraction_point.opy#L72) / `extractionZoneRad` | Valid: terminal value. Defeat at extractionZoneRad <= 0 checks the chase destination of 0. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2077](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2077>), [original:1784](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1784>). Not a defect. |
| CH05 | [objective_types/objective_type_showdown.opy:14](src/objective_types/objective_type_showdown.opy#L14) / `objectiveRad` | Intermediate boundary; verify. Radius crosses player/bot distance. Completion of individual chase steps may provide the required reevaluation. | Under observation; medium if reproduced; no direct crash risk found | Reproduce the scenario below first. If confirmed, use controlled polling/published state rather than intermediate-chase dependence. | Inherited condition: [original:2156](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2156>), [original:1791](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1791>). Risk in an older construct; no in-game failure established. |
| CH06 | [objective_types/objective_type_biomorphing.opy:147](src/objective_types/objective_type_biomorphing.opy#L147) / `objectiveRad` | Valid: different lifecycle. Biomorphing uses radius = 3.5, with no active Showdown chase. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2553](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2553>), [original:1805](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1805>). Not a defect. |
| CH07 | [objective_types/objective_type_survivor_rescue.opy:83](src/objective_types/objective_type_survivor_rescue.opy#L83) / `objectiveRad` | Valid: direct assignments. Rescue uses values 10/30 and restores through assignment. Not a chase defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2712](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2712>), [original:2724](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2724>). Not a defect. |
| CH08 | [objective_types/objective_type_kill_zone.opy:7](src/objective_types/objective_type_kill_zone.opy#L7) / `objectiveRad` | Valid: fixed value and event. Kill Zone uses radius = 20; the check runs on final blow. Not a chase defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2832](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2832>), [original:1820](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1820>). Not a defect. |
| CH09 | [objective_types/objective_type_satellite_uplink.opy:113](src/objective_types/objective_type_satellite_uplink.opy#L113) / `objectiveRad` | Valid: fixed radius. Satellite uses radius = 3. Active Showdown chase should not survive a normal transition. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:2977](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2977>), [original:1831](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1831>). Not a defect. |
| CH10 | [zombie_types.opy:1129](src/zombie_types.opy#L1129) / `botAbilityCooldown` | Valid: terminal value. Hazard waits for botAbilityCooldown == 0, and chase also targets 0. An extra boss branch independently permits the action. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:5607](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5607>), [original:4263](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4263>). Not a defect. |
| CH11 | [zombie_types.opy:1390](src/zombie_types.opy#L1390) / `objectiveRad` | Intermediate boundary only during Showdown; verify. Other types use fixed radii; chase-step completion in Showdown may remove the delay. | Under observation; medium if reproduced; no direct crash risk found | Reproduce the scenario below first. If confirmed, use controlled polling/published state rather than intermediate-chase dependence. | Inherited condition: [original:5891](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5891>), [original:1791](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L1791>). Risk in an older construct; no in-game failure established. |
| CH12 | [enhancements.opy:171](src/enhancements.opy#L171) / `infectionLevel` | Valid: mutually exclusive roles. The condition concerns Zombie Hybrid; infectionLevel chase runs in the else branch for other enhancements. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:6712](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6712>), [original:6600](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6600>). Not a defect. |
| CH13 | [enhancements.opy:271](src/enhancements.opy#L271) / `enhancementBarrierHealth` | Valid: assignment guarantees the threshold. Before regeneration from 0, HP is set to 1; > 0 is already true. Contact stops chase. Entry does not require waiting for 10000. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:6769](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6769>), [original:6810](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6810>), [original:6811](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6811>). Not a defect. |
| CH14 | [enhancements.opy:534](src/enhancements.opy#L534) / `enhancementPupCooldown` | Valid: terminal value. P.U.P. checks cooldown <= 0 with destination 0. Temporary rate 0 while beaming is intentional. Not a defect. | Not a defect; no direct crash risk found | Retain the algorithm. Document local diagnostics if needed; do not restore global suppression. | Inherited condition: [original:7057](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7057>), [original:6684](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6684>). Not a defect. |

**CH02–CH03, the dome: the most significant intermediate-value check.** It shrinks from 300 to 0, but infection should begin earlier: after the 200 threshold and when radius crosses player distance. Control: keep a living player stationary outside extraction; log radius and `infectionLevel`, marking passage through 200 and body distance. Infection should increase once outside, allowing for the normal 1 s wait. Repeat with a moving player. If a stationary player triggers a response only at 0/stopping, a defect is then reproduced. This would be medium/high severity for extraction mechanics; it does not explain a process crash. Fix with cheap regular boundary checks inside the body, guarded by active extraction, or a separately published radius; preserve infection period and spawn-room exit handling. Retain CH04 `radius <= 0` as a terminal check.

**CH05 and CH11, changing Showdown radius: observation only for now.** Place a stationary participant at the boundary so radius changes alone add/remove them; log radius, destination, list membership/miniboss-ultimate timing. Showdown's destination is `max(5, progress / 4)`, chase rate 1; individual step completion triggers reevaluation, so the warning does not prove a missed entry. Test expansion on capture and shrinking on lost progress. If there is no unwanted delay, this is valid: do not file a defect. If reproduced, poll zone membership consistently without changing capture speed; do not “fix” other objectives' fixed radii.

**Why CH13 does not require full regeneration.** From zero health, the barricade is directly assigned 1 HP before chasing to 10000. Condition `> 0` is already true before growth; zombie contact stops chase in the body. The check does not depend on detecting an intermediate crossing of 0. Distinguish the rule's own `loop` reentry/contact events from a single trigger driven only by growing HP.

<a id="warning-impulse"></a>

### Cancel Contrary Motion: all 20 sites and safe migration

`CANCEL_CONTRARY_MOTION` is deprecated in the installed compiler. Its description treats horizontal XZ and vertical Y motion separately; `CANCEL_CONTRARY_MOTION_XYZ` treats them together. Replacement therefore does not guarantee the same trajectory. The warning does not indicate a leak, overflow, or server crash. Migration severity is low for all 20 messages; check physics separately for each mechanic.

**Only an in-memory copy** was checked: 20 XYZ replacements compile successfully, retain **25,305** elements, reduce this warning category to **0**, and leave **36** other messages. Files under `src/` were not changed. This verifies the new enum is accepted, not motion equivalence.

| ID | Location | Owner | Severity / crash risk | Proposal and check | Provenance |
|---|---|---|---|---|---|
| IM01 | [objective_types/objective_type_bosses.opy:142](src/objective_types/objective_type_bosses.opy#L142) | `rule "BOSS DIES (ALL BOSS OBJECTIVES)"` | Low; no direct crash risk found | Boss return: falling down with the target above/below; check height and horizontal approach to the target. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:2363](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L2363>). Target selection was refined; the legacy mode is unchanged. |
| IM02 | [zombie_types.opy:274](src/zombie_types.opy#L274) | `rule "BRUTE (REIN) SUPER SEISMIC SLAM"` | Low; no direct crash risk found | Reinhardt: group launch; compare players running sideways and falling. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:4698](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4698>). |
| IM03 | [zombie_types.opy:358](src/zombie_types.opy#L358) | `rule "REIGNITED (ANRAN) ABILITIES"` | Low; no direct crash risk found | Anran: vertical impulse before movement; preserve lateral momentum and height. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:4782](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4782>). |
| IM04 | [zombie_types.opy:364](src/zombie_types.opy#L364) | `rule "REIGNITED (ANRAN) ABILITIES"` | Low; no direct crash risk found | Anran: angled dash toward the target; compare opposing motion and platform edges. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:4788](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4788>). |
| IM05 | [zombie_types.opy:619](src/zombie_types.opy#L619) | `rule "SLIMER (MERCY) TENTACLE GRAB"` | Low; no direct crash risk found | Mercy: victim pull; check motion perpendicular to the pull and gravity restoration. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5047](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5047>). |
| IM06 | [zombie_types.opy:655](src/zombie_types.opy#L655) | `rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)"` | Low; no direct crash risk found | Emre: takeoff; check lateral velocity before the vertical impulse. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5086](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5086>). |
| IM07 | [zombie_types.opy:716](src/zombie_types.opy#L716) | `rule "STRIKER (WRECKING BALL) PILE DRIVER"` | Low; no direct crash risk found | Wrecking Ball: launch toward a point above the target; check the angled trajectory. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5150](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5150>). |
| IM08 | [zombie_types.opy:805](src/zombie_types.opy#L805) | `rule "STALKER KNOCKBACK BLAST (BOSS)"` | Low; no direct crash risk found | Moira: knockback with lift; compare a running and a falling victim. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5243](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5243>). |
| IM09 | [zombie_types.opy:930](src/zombie_types.opy#L930) | `rule "DOWNFALLEN GRABS PLAYER"` | Low; no direct crash risk found | Sigma: self-recoil backward/upward in local coordinates; check orientation. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5376](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5376>). |
| IM10 | [zombie_types.opy:940](src/zombie_types.opy#L940) | `rule "DOWNFALLEN GRABS PLAYER"` | Low; no direct crash risk found | Sigma: throw the captured target; check distance, height, and opposing velocity. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5386](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5386>). |
| IM11 | [zombie_types.opy:1042](src/zombie_types.opy#L1042) | `rule "DAYTAKER (ILLARI) BURST"` | Low; no direct crash risk found | Illari: throw a zombie toward the active target; check the arc accounting for target elevation. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5493](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5493>). |
| IM12 | [zombie_types.opy:1044](src/zombie_types.opy#L1044) | `rule "DAYTAKER (ILLARI) BURST"` | Low; no direct crash risk found | Illari: throw without an active target; check facing-based direction and original range. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5495](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5495>). |
| IM13 | [zombie_types.opy:1245](src/zombie_types.opy#L1245) | `rule "SMOLDER BOSS SLAM"` | Low; no direct crash risk found | Winston: accelerated landing; check preservation of horizontal movement. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5730](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5730>). |
| IM14 | [zombie_types.opy:1271](src/zombie_types.opy#L1271) | `rule "SMOLDER SUPER SLAM"` | Low; no direct crash risk found | Winston: group shockwave; check near/far force and perpendicular motion. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:5754](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L5754>). |
| IM15 | [zombie_types.opy:1431](src/zombie_types.opy#L1431) | `def abilityThrowdown()` | Low; no direct crash risk found | Hazard abilityThrowdown: launch nearby actors; check targets' lateral momentum. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:4388](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4388>). |
| IM16 | [zombie_types.opy:1432](src/zombie_types.opy#L1432) | `def abilityThrowdown()` | Low; no direct crash risk found | Hazard abilityThrowdown: self-jump; compare velocity and height. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:4389](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L4389>). |
| IM17 | [supply_drops.opy:161](src/supply_drops.opy#L161) | `def playerForceField()` | Low; no direct crash risk found | Force Field: continuous repulsion; check running inward, along the boundary, and jumping. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:6137](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6137>). |
| IM18 | [supply_drops.opy:393](src/supply_drops.opy#L393) | `def bouncePad()` | Low; no direct crash risk found | Bounce Pad: vertical jump; check for changes in lateral velocity. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:6366](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6366>). |
| IM19 | [enhancements.opy:260](src/enhancements.opy#L260) | `rule "LASER BARRICADE BLOCKS ZOMBIES"` | Low; no direct crash risk found | Laser Barricade: reflect a moving zombie; check both directions and floor slopes. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:6800](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L6800>). |
| IM20 | [enhancements.opy:614](src/enhancements.opy#L614) | `rule "P.U.P. CONTROL"` | Low; no direct crash risk found | P.U.P.: beam knockback of the target; compare horizontal motion and falling. If expected motion is preserved, adopt XYZ; otherwise tune direction/strength or explicitly retain the justified legacy mode. | Inherited: [original:7137](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy#L7137>). |

For every IM scenario, compare the original mode and XYZ on the ground, airborne, with lateral/opposing velocity, and near walls/platform edges. Pay particular attention to continuous Force Field/barricade behavior: small per-impulse differences repeat many times. Do not change `INCORPORATE_CONTRARY_MOTION` alongside these sites: it is a different policy and not the subject of these 20 messages.

### Reproducing the complete list and verification limits

```powershell
node analysis/audit-compiler-warnings-2026-11-04.cjs --write --list
```

The script saves [JSON with 56 messages](analysis/compiler-warning-audit-2026-11-04.json), original include stacks, rule owners, severity/risk, and source hashes. It verifies no own Waits in SR01–SR03, byte-identical Workshop output when suppressions are restored in memory, and successful compilation of 20 impulse replacements. Writes are limited to `analysis/`; dangerous restarts and game loops are not executed.

Recommended order: SR07; then SR18–SR19 and other long consumables with an explicit reuse contract; jointly fix five timer sites; protect repeated pregame initialization and transitions. Test CH02–CH03 before changing the algorithm; handle CH05/CH11 according to observed behavior. Do not turn terminal/inactive chase checks into defects. Migrate IM01–IM20 as separate physics-verified work without attributing Start Rule crashes to them.


## Sources and materials

Intermediate materials are retained to verify calculations and the provenance of observations.

- [Original performance audit](analysis/runtime-performance-review-2026-11-04.md).
- [Original target-selection counterexamples](analysis/gameplay-selection-review-2026-11-04.md).
- [Earlier detailed Start Rule warning audit](analysis/start-rule-crash-report-2026-11-04.md). Its statement about removed suppression refers to its source state. Following the user's latest change, four suppressions were removed; this report analyzes the complete current list of 56 messages.

Links to documentation by the OverPy author accompany the relevant findings. They describe engine observations; the current game client and the specific crash threshold for this mode were not tested.

Additional materials for the current diagnostics: [full-audit script](analysis/audit-compiler-warnings-2026-11-04.cjs), [56 original messages and classification](analysis/compiler-warning-audit-2026-11-04.json).

Original-comparison materials: [ZSMM (786TW) snapshot](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy>), [line-level provenance evidence](analysis/original-provenance-2026-11-04.json), [verification script](analysis/audit-original-provenance-2026-11-04.cjs).
