# Overwatch Zombie Survival Missions Reforged

**English** | [Русский](Readme.ru.md)

A rework of the [Zombie Survival Missions (786TW)](https://workshop.codes/786TW) mod, written in [OverPy](https://github.com/Zezombye/overpy). Reforged is based on the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>).

The project aims to reduce the original mod's element count as much as possible to make room for new mechanics. The first stage focuses on technical optimization. Gameplay changes will be documented here as they are introduced.

The compiled code for the current mod version is available in [main.ws.txt](main.ws.txt). Copy its contents and import them into Overwatch Workshop.

The Reforged author's BattleTag is **snky#21990**.

## Versioning

The [zsmm-classic](https://github.com/sanykey/Overwatch-Zombie-Survival-Missions-Reforged/tree/zsmm-classic) branch will receive only optimizations and fixes for the classic [Zombie Survival Missions (786TW)](https://workshop.codes/786TW), preserving its original gameplay mechanics. The Overwatch Workshop import code for this version is **87EJP**.

The `main` branch is intended for further Reforged development, including new functionality.

## Hero changes

- **Ana:** pressing Ultimate with at least 100 charge and without an ally target sets ultimate charge to zero and applies the existing 20-second Super Nano effect directly to Ana, including its healing and refresh behavior. The carried power-up is preserved. After allowing the effect to initialize, the self-cast rule waits for death or effect cleanup, with a 20-second timeout. Ultimate use is disabled during this wait and enabled afterward; pickup refreshes do not extend this timeout. A 0.128-second grace period gives native ally Nano priority; self-casting is blocked while incapacitated or using another ability.
- **Brigitte:** Shield Bash damage stuns the target for 0.8 seconds, including outside Rally.
- **Cassidy:** Flashbang damage stuns the target for 0.8 seconds instead of applying Hack. Each hit applies or refreshes the stun, including against hacked targets.
- **Reinhardt:** damage dealt while Barrier Field is active stuns the target for 0.8 seconds, supporting Shield Slam. Any damage source qualifies while the shield is active.
- **Sierra:** hitting an enemy with Tracking Shot applies Hack for 3 seconds, matching the mark's base duration. This timer is independent of early mark cancellation/removal; another Tracking Shot hit refreshes Hack.
- **Soldier: 76:** deals 50% more damage while Tactical Visor is active. The bonus multiplies damage alongside Super Nano and other damage boosts; Super Nano's 2× damage becomes 3× during Tactical Visor. The bonus ends when Tactical Visor ends or the player changes heroes.

Ana's ally check uses the donor mod's approximate 41m radius, 10-degree view angle and surface line of sight to protect pending target confirmation. It does not read the native selected target. Native testing is still required with confirmation on/off and different Nano targeting sensitivities, including allies near the angle/range boundary or behind cover, quick taps, crowd control, and refreshing an active Super Nano. Compile and check unchanged existing rules with `node analysis/verify-ana-self-nano.cjs`; add `--write` to regenerate the export. The feature adds 73 compiled elements (29,896 → 29,969), with no new variables or subroutines. The compact boolean-array guard saves elements versus chained `or`; it builds a small temporary array once per attempt.

## Zombie changes

**Carrion (Jetpack Cat)** is a regular zombie ported from the ZSMM-remixed snapshot, with its difficulty stats and ability sequence. At 4–15m times its size, it presses Ability 1, has a 40% chance to charge and use its ultimate (followed by Primary Fire), then holds Secondary Fire for 2s. Other regular zombies with a target farther than 4m times their size press Interact while a cat is present to request transport. These sequences rearm when their conditions become false, as in Remix.

Carrion has approximately 2.91% spawn weight in All Zombies (equal to Reinhardt), 20% in New Blood, and 5% in What'll it be?; the other eligible heroes retain their relative weights. It has no boss variation. Validate tables and compile with `node analysis/verify-carrion.cjs`; add `--write` to regenerate `main.ws.txt`. Native gameplay still needs verification.

## Enhancements and Augments

Choose one primary **Enhancement** with **Quick Melee** and one independent **Augment** with **Interact** before the match. Hold **Secondary Fire** while choosing to cycle backwards. During gameplay, Interact handles powerups and Dead Weight. Each unselected slot receives a random real option when gameplay starts, including for players joining an ongoing match: one of twelve Enhancements and one of ten Augments. Explicit choices are preserved, and an assigned option is retained across later spawns. There are no Workshop settings for default selections.

Brain Killer is the first primary Enhancement in the voting list. Kevlar has moved from the primary slot to Augments and can now accompany any primary enhancement. Born to Battle stores up to two ability resets, earning one per final blow and spending one per reset.

The Apothecary rule for health-pack pickup at full health remains deferred. This version uses standard beams without the Beam Effects extension. The [feature-port audit](analysis/feature-port-audit.json) records the earlier rebuild before Bolt Strike was restored; see the [Bolt Strike validation](analysis/bolt-strike-validation.json) for the restoration.

Bolt Strike chains each damaging hero hit to up to two random other living zombies visible from the original victim within 10m. Each chain deals 25% of the hit, capped at 15 damage. Actual chain health removed builds energy, plus 0.3 per hit on the original victim even without chain targets, capped at 350. At 350, hold Quick Melee to spend the bank and arm a burst. Releasing Melee preserves it. The next hero hit consumes the burst once, dealing 60 damage and stunning living zombies visible within 10m of the original victim for 2s. Warning-phase Smolders are excluded from chains and the burst. Chains and primary hits keep banking the next charge; scripted damage does not grant primary-hit credit or trigger further chains or bursts. Death cancels the armed burst but preserves banked energy. No lightning beams are created; ordinary chain-hit flashes remain. Bolt Strike is appended as Enhancement ID 12, preserving Dead Weight's ID 11.

Overcharge stores 1 energy per 1 actual healing, including health received from health packs, without a cap. Each offensive or defensive assist adds 10 energy, including posthumous assists; assists recorded before initialization grant no energy. Each pack is counted once even when the game attributes its healing to you; Apothecary's supplemental healing grants no extra pack credit. Hold Melee to spend up to 100 energy and arm a fixed bonus; excess energy remains stored for later charges. Your next damaging hero attack or ability starts a 0.3-second window; every damage event during that window adds the same bonus, including each enemy hit by Ana's grenade. Long Reach's extended hits can start this window and receive its bonus without extending it. Releasing Melee does not cancel the armed charge. Healing continues to build a separate next charge; holding Melee rearms it after the current window ends. Death clears the armed charge but preserves unspent energy. Turrets, air strikes, other Augments and the bonus damage itself do not trigger this effect.

Bulking Season grants one stack per credited elimination: a kill or damage participation. Healing and buff assists do not grant stacks. Each stack adds 0.5% native maximum health and 0.5% hero size, additively. Size caps at 1.35x at 70 stacks. Maximum health caps at 200% of base at 200 stacks; stacks continue accumulating beyond both caps. Death halves stacks, rounding down (5 becomes 2); surviving stacks remain after revival and hero switches. The HUD shows stacks, health bonus and size.

Dead Weight is a primary Enhancement compatible with any Augment. Aim within 5m and press Interact to grab a living zombie (including bosses and minibosses) below 20% health or affected by Stunned, Asleep, Frozen or Knocked Down. Rooted or Hacked alone does not qualify; intervening players block pickup. Initializing, teleporting and already-attached targets cannot be grabbed. While holding a zombie, the carrier takes 50% less damage; this protection stacks with Super Nano and ends on every release. You cannot grab while attached, stunned, asleep, frozen or knocked down. The target is held for up to 5s and knocked down for 6s from pickup. Press Interact again to throw along your facing direction with strength 12.5; after 0.75s it takes 50 damage and knockdown ends. There is no cooldown, splash or landing damage. Timeout, carrier death/disconnect/hero change/attachment, target death/initialization/teleport/loss of knockdown or game end releases it without throw damage. Carrying and throwing take priority over powerups and Laser Barricade; a throwing press never starts barricade placement. The HUD shows the remaining hold time.

### Augments: player guide

Equip one Augment alongside any primary Enhancement. No Preference assigns a random Augment when gameplay starts. Controls use action names and follow your key bindings. **cd** means cooldown. Movement Augments cannot activate while rooted, stunned, asleep, frozen, knocked down or being carried.

| Augment | Controls and effect | Timing, limits and interactions |
|---|---|---|
| Kevlar | Passive: +75 recoverable armor, helping protect against infection. | Healing restores the armor. It does not grant immunity to infection. |
| Shock Landing | Release Jump after takeoff, then press again in midair. First landing: 40 damage to every visible zombie within 6m, including behind you, and an outward push. Movement input adds a dash; no input arms only the wave. | **cd: 13s from activation.** Invulnerability and passage through players last 0.5s even if you land early; a later landing still triggers the wave. Dash strength 25, 15° upward; adjacent inputs give a 45° diagonal. Wave strength 32, 6.5° upward, reduced by knockback resistance; radius scales with your size. Carried/knockback-immune zombies take damage without push; teleporting zombies are excluded. Environmental kills from the push count for you. Pyrotechnic adds a 3s burn on health loss within 15m. Death, hero change or game end cancels a pending wave. |
| Double Jump | Release Jump and press again in midair, or double-tap within 0.3s while grounded, including during abilities that prevent normal jumping. Upward jump strength: 14.4. The first damage event of at least 30 against a zombie in flight **or within 0.5s after landing** deals +50%. | **cd: 16s**, shared by both inputs; landing does not reset it. The threshold applies to one hit before the bonus. Weapons, abilities, powerups and periodic damage qualify; smaller hits, misses and self hits do not spend it. Leaving another ledge does not extend the landing window. If liftoff fails, the bonus expires after 0.5s. Death, hero change and game end clear it. |
| Long Reach | Passive: triples Quick Melee reach to 7.5m at normal size, plus supported melee weapons and Carnage. Hits all visible enemies in the strike area; reach scales with your size. Hold attacks to repeat swings. Reinhardt, Brigitte and Torbjörn also support the Quick Melee binding. | Supports Vendetta's sword, Reinhardt's hammer, Brigitte's flail, D.Mon's mech saber, Genji's Dragonblade, Ramattra's Nemesis punches, Torbjörn's equipped hammer and Junker Queen's Carnage. Inactive forms and ranged weapons do not qualify. Outer-range hits deal direct damage without native knockback, wounds, Inspire or perk effects. Pyrotechnic adds its 3s burn on health loss within 15m; armed Overcharge works too. Extended swings use fixed approximate timings rather than native combos or attack-speed bonuses; see below. |
| Ammo Pack | Passive: doubles ammo per full magazine, including a second ammo pool where applicable. Full refills restore the bonus. | Applies when combat starts; interrupted reloads grant no extra ammo. Some heroes keep their native HUD maximum despite receiving extra rounds: Widowmaker may show **70/35**, while Soldier: 76 shows **60/60**. |
| Grapnel Launcher | **Crouch + Jump** hooks the nearest visible zombie near your crosshair, 7–40m away, pulling you at 40m/s. Arrival: 35 damage; grounded targets are stunned for 0.5s, airborne targets knocked down for 3s. | **cd: 16s from launch.** Aim tolerance 8°; pull limit 1.5s. Releasing buttons does not cancel the pull; Quick Melee remains available. A miss costs no cd; an interrupted launch keeps its cd. Death, crowd control, hero change, losing the target/line of sight or reaching the travel limit ends the pull. Walls still block movement. Pyrotechnic adds a 3s burn on health loss within 15m. HUD shows readiness/cd. |
| Laser Barricade | Hold **Crouch + Interact** for at least 0.5s, aim at a surface within 30m, then release **Interact** to deploy. Crouch may be released while aiming. Wall: 5m wide, 2m tall, 10,000 HP; pushes zombies back. | **cd: 30s from placement.** Early release, death while aiming or invalid placement costs no cd. Blocking contact deals 10 damage and roots for 0.5s, costing the wall 2.5× the zombie's maximum HP. Already-rooted targets are pushed without another damage/HP charge until Rooted expires. Regenerates 500 HP/s after 3s without contact, or after 6s if depleted. A depleted wall stops blocking until recovery. New placement replaces your old wall at full HP. HUD shows HP/cd. |
| Apothecary | Health packs add healing equal to the pickup's healing, remove up to 1 existing infection even after time runs out (except with Zombie Hybrid), grant **+5 percentage points of ult charge** and save the pickup position. Using an ultimate grants **one teleport charge**; hold **Crouch + Interact for 0.2s** to return to the latest pickup. | Charge does not stack. Death and hero switches preserve the point and charge. The HUD shows the button hint and a checkmark only when charged. Departure flashes with the Bolt Strike effect at triple size. Infection cannot fall below 0; no vaccine is granted. Normal pack cleansing still applies where difficulty and match time permit it. |
| Scavenger | Adds a **two-item backpack** beside the active powerup. **Crouch + Interact** stores an aimed ground item; **Interact** alone picks up/swaps the active item. Hold **Reload for 0.25s** to drop everything, even with an empty active slot. Death also drops everything. | Backpack items cannot activate or automatically move to the active slot: drop and pick them up normally to use them. A full backpack leaves aimed items on the ground. Each bot kill or damage participation in a bot elimination has a **5% chance** of one random powerup from all 13 types; healing/buff assists do not qualify. Loot goes to the backpack first, even with an empty active slot; if full, it drops near the dead zombie for anyone to collect. Dropped items are spaced 0.75m apart. HUD: 0/2–2/2. No lifesteal or bonus health. |
| Leech | Passive: **+50 recoverable health** and healing for **15% of damage dealt**. | Lifesteal includes hero, primary Enhancement and powerup damage. Credited environmental bot kills heal for 15% of remaining health; boss falls heal for 15% of scripted health loss (200 damage, capped by remaining health). Healing restores the extra health. No backpack or extra loot chance. |

Long Reach also pushes zombies on a Melee-button press, independently of damage events. It selects visible living zombies within 10m (scaled by player size) and 30° of the crosshair; teleporting, attached and knockback-immune zombies are excluded. Strength is 25, with a 15° upward angle and cancellation of contrary motion, scaled by each zombie's knockback resistance. A press with eligible targets starts a 9s cooldown; an empty press does not spend it. Holding Melee does not automatically repeat the push when cooldown expires. This also works for Brigitte and Reinhardt, whose Melee binding uses their weapon attack; primary fire alone does not trigger it. Extended reach and damage remain active during cooldown. The combat name is green when ready and red during cooldown; the HUD shows readiness/time remaining.

Long Reach's extended hits use the ranges, damage and timings below, at normal player size. Windup starts before the added hit; recovery is the pause before the next held swing's windup. A committed Vendetta swing completes after releasing attack, but blocking, abilities, crowd control, death or hero change can cancel its windup.

| Attack | Extended reach | Extended hit damage | Windup | Recovery |
|---|---:|---:|---:|---|
| Quick Melee | 7.5m | 40; Zenyatta 60; Venture 70 | 0.15s | Once per melee attack |
| Vendetta sword | 12.9m | 45 | 0.15s | 0.45s (0.6s per swing) |
| Reinhardt hammer | 12m | 100 | 0.4s | 0.56s |
| Brigitte flail | 18m | 45 | 0.2s | 0.4s |
| D.Mon mech saber | 12m | 60 | 0.2s | 0.456s |
| Genji Dragonblade | 15m | 100 | 0.15s | About 0.459s |
| Ramattra Nemesis punches | 30m | 65 | 0.15s | 0.45s |
| Torbjörn hammer | 7.5m | 70 | 0.35s | 0.35s |
| Junker Queen Carnage | 15m | 90 | 0.75s | Once per cast |

## Using the mod code

Compile the source into Workshop code using [OverPy](https://github.com/Zezombye/overpy). Its repository also provides documentation for the language. The compilation entry point is `main.opy` in the project root. The easiest way is to use the OverPy extension for Visual Studio Code.

1. Install Visual Studio Code and the OverPy extension by following the [installation instructions](https://github.com/Zezombye/overpy#installation).
2. Open the project folder in VS Code, then open the root `main.opy` file.
3. Save `main.opy` (`Ctrl+S`). The extension starts compilation; on success, the compiled code is copied to the clipboard and written to `main.ws.txt` in the project root.
4. In Overwatch, create a custom game, open its settings, and import the compiled code from the clipboard.

After changing the source, save the root `main.opy` again to compile the updated mod.

### Passive regeneration issue

Passive health regeneration for the zombie team is disabled under **Settings → Heroes → General → Team 2**. However, importing the source code into Workshop resets this setting, apparently due to a Workshop bug. **Manually disable passive regeneration for Team 2 after every code import**, before sharing the mod's short code.

### Workshop hero-selection UI corruption

During pregame voting, selecting a hero and then returning to the native hero-selection screen with Crouch can make some heroes disappear entirely, often starting with newer heroes. Reproduction is intermittent and depends on the map. The user also observed extra white UI buttons and unavailable emotes on the original development branch. Opening and closing the lobby restores the missing hero list, but requiring this from every player is not a usable fix. Earlier diagnostics showed that the script restored the allowed-hero list even when the UI lost heroes.

The problem can appear or disappear after changing rule Conditions unrelated to hero availability, including in rules whose Actions do not run during voting. The root cause remains unknown; high Server Load, a memory leak and a specific engine resource limit have not been established.

**A tested workaround is to combine separate Conditions into a single nested `And` expression.** For example:

```csharp
conditions {
    And(Compare(Global.isGameplayActive, ==, True), Compare(Is Alive(Event Player), ==, True)) == True;
}
```

Diagnostic **29a**, based on build 28 (`e23f73d2ac3af65bba98d509f08625eb493b23e3`), reduced condition entries from **850 to 212**, retaining all 305 rule events and action lists. The user reported several runs without the defect, while the matching control still failed intermittently. Both exports used Malevento, Necropolis, Black Forest, Ilios Lighthouse and Colosseo. These results concern hero selection; the white-button and emote symptoms have not been separately verified as fixed. A local `And` change helped Scavenger but did not help the deferred `APOTHECARY ALLOW HEALTH PACK PICKUP` rule in `src/augments.opy`, reverted by `ba8e70de7d4e282b2f90c8ae6c15f6d1d500a342`.

**Mode-wide grouping is currently reverted because of its element cost.** Restore functionality first, then investigate a more targeted fix. The experimental versions had the following costs:

| Export | Elements | Increase over build 28 |
|---|---:|---:|
| Build 28 control | 29,238 | — |
| Diagnostic 29a | 32,347 | +3,109 |
| Source-integrated prototype | 31,619 | +2,381 (8.1%) |

The complete source-integrated prototype is preserved at tag **`experiment-hero-selection-grouped-conditions`**, commit `cb2c552`. It retained the original events/actions, variables and map settings and passed static checks and scripted gameplay regression tests. It was not separately verified in game; user-confirmed successful native runs refer to diagnostic 29a. To inspect its compiler workaround: `git show experiment-hero-selection-grouped-conditions:src/rule_conditions.opy`. Its regression check is also available at that tag in `analysis/verify-grouped-conditions.cjs`; neither file is present in the current source tree.

**OverPy 9.7.20 can split `and` back into separate Conditions.** The tagged prototype protected the conjunction by comparing its boolean result with numeric `1`, keeping other optimizations enabled. Comparing with `true` instead lets the optimizer remove the wrapper and split the conjunction. This technique applies only to a boolean result; preserve each predicate's explicit comparison, especially `Null`/zero versus `False`. Fewer Conditions do not prove lower CPU load: nested `And` may evaluate more inputs.

Preserve the earlier local Scavenger workaround in `src/power_ups.opy` and action-body guards for Leech in `src/augments.opy` and Interact in `src/supply_drops.opy`. Moving Conditions into Actions can change ongoing-rule triggering, `Abort When False` and loops; adding waits to event handlers can drop events. For future fixes, inspect generated Workshop code, measure element cost and repeat native tests on affected maps against a matching control. One successful attempt does not establish that an intermittent defect is gone.

## Optimization results

Measured on November 4, 2026 for the Reforged working tree based on commit `d8efbdc`.

| Metric | Maximum | ZSMM | Reforged | Savings |
|---|---:|---:|---:|---:|
| Elements | 32,768 | 32,264 | **25,250** | **7,014 (21.74%)** |
| `globalvar` | 128 | 120 | **105** | **15 (12.50%)** |
| `playervar` | 128 | 100 | **90** | **10 (10.00%)** |
| `subroutine` | 128 | 58 | **81** | None: increased by 23 (39.66%) |

Reforged has **7,518 elements**, **23 globalvar slots**, **38 playervar slots**, and **47 subroutine slots** available. Additional subroutines help reduce duplicated code.

## Known issues and optimization proposals

The [code review report](CODE_REVIEW_REPORT.md) provides supporting evidence, validation status, and recommendations for each finding. The documented defects and risks are inherited from the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>). The proposed optimizations also concern constructs already present in that version.

### Fixed:

- [R11 — "Doomfist never releases the simulated block button"](CODE_REVIEW_REPORT.md#r11).
- [R16 — "Bot selects a target behind a wall or a stale target"](CODE_REVIEW_REPORT.md#r16).
- [R18 — "Charge Battery selects an ineligible recipient"](CODE_REVIEW_REPORT.md#r18).

## Resources

The [workshop-snapshots](workshop-snapshots/) directory contains exports of ZSMM and other mods, along with their OverPy decompilations. These snapshots are used for comparison and as reference material.

The [analysis](analysis/) directory contains reports, validation results, and technical notes to help AI models and coding agents work on the project and understand earlier decisions.
