# Overwatch Zombie Survival Missions Reforged

**English** | [Русский](Readme.ru.md)

A rework of the [Zombie Survival Missions (786TW)](https://workshop.codes/786TW) mod, written in [OverPy](https://github.com/Zezombye/overpy). Reforged is based on the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>).

The project aims to reduce the original mod's element count as much as possible to make room for new mechanics. The first stage focuses on technical optimization. Gameplay changes will be documented here as they are introduced.

The compiled code for the current mod version is available in [main.ws.txt](main.ws.txt). Copy its contents and import them into Overwatch Workshop.

The Reforged author's BattleTag is **snky#21990**.

## Versioning

The [zsmm-classic](https://github.com/sanykey/Overwatch-Zombie-Survival-Missions-Reforged/tree/zsmm-classic) branch will receive only optimizations and fixes for the classic [Zombie Survival Missions (786TW)](https://workshop.codes/786TW), preserving its original gameplay mechanics. The Overwatch Workshop import code for this version is **87EJP**.

The `main` branch is intended for further Reforged development, including new functionality.

## Downed players

Completing any mission objective adds the full current rescue time limit (`mustReviveTime`, 60 seconds initially, decreasing to a minimum of 30 after permanent deaths) to every downed player's remaining rescue time, provided it is still above zero. The bonus is additive: 12 seconds remaining with a 60-second limit becomes 72 seconds, without a cap. This replaces the previous 10-second bonus for timers below 50 seconds. Permanently dead players still respawn on objective completion. The extraction dome can still shorten the rescue timer.

## Hero changes

Team 1 tanks deal 90% damage, damage heroes deal 95%, and supports use the native 100% setting.

While a player is using their ultimate or inside the Dash augment's protection window, zombie attacks cannot start new damage-over-time effects on them: the bite's damage-over-time and infection stacks, the Blaster (Pharah) rocket burns, Roadhog and Behemoth gas clouds, the Rusher boss's Molten Core burns and the Bomber (Junkrat) explosion burns all skip protected victims. Already ticking damage-over-time, existing infection and direct hit damage are unaffected. Infection outside the extraction zone is unaffected. The Dash protection window also grants full knockback immunity, ending together with the window.

While a player is using their ultimate, they take 50% damage. The resist does not stack with the Super Nano power-up's similar resist: the strongest active protection wins, so the Dash augment's protection window still overrides both with its full immunity. The SWARM SHOOTOUT challenge damage modification and Super Nano's own damage modification multiply with this resist as before. The resist ends with the ultimate, death or hero change.

- **Brigitte:** Shield Bash damage stuns the target for 0.8 seconds, including outside Rally.
- **Cassidy:** Flashbang damage stuns the target for 0.8 seconds instead of applying Hack. Each hit applies or refreshes the stun, including against hacked targets.
- **Reinhardt:** damage dealt while Barrier Field is active stuns the target for 0.8 seconds, supporting Shield Slam. Any damage source qualifies while the shield is active.
- **Soldier: 76:** deals 50% more damage while Tactical Visor is active. The bonus multiplies damage alongside Super Nano and other damage boosts; Super Nano's 2× damage becomes 3× during Tactical Visor. The bonus ends when Tactical Visor ends or the player changes heroes.

## Zombie changes

**Carrion (Jetpack Cat)** is a regular zombie ported from the ZSMM-remixed snapshot, with its difficulty stats and ability sequence. At 4–15m times its size, it presses Ability 1, has a 40% chance to charge and use its ultimate (followed by Primary Fire), then holds Secondary Fire for 2s. Other regular zombies with a target farther than 4m times their size press Interact while a cat is present to request transport. These sequences rearm when their conditions become false, as in Remix.

Carrion has approximately 2.91% spawn weight in All Zombies (equal to Reinhardt), 20% in New Blood, and 5% in What'll it be?; the other eligible heroes retain their relative weights. It has no boss variation. Native gameplay still needs verification.

## Cure powerup

Cure clears active infection. If the player is uninfected, Cure lowers their infection level by 1.5, building resistance to future bites.

## Jetpack powerup

Item 11 is now **Jetpack**, retaining its purple pickup orb. Use it with Interact to add 100 fuel, up to a maximum of 200. At 200 fuel, using the item leaves it in the inventory. Fuel does not regenerate automatically, and unused fuel survives death. Hold Jump continuously for 0.125 seconds to fly, including from the ground (releasing Jump cancels the wait without spending fuel): zero gravity, upward acceleration 10 with maximum speed 4, and an additive 30 percentage point movement-speed bonus, as in Brigitte's Jetpack in `workshop-snapshots/Jazzy's New Abilities.opy`. Consumption matches the original rate: 40 fuel/s (2.5 seconds of thrust per item, 5 seconds per full 200-fuel tank).

The white subheader `jetpack fuel: <number>` sits above the carried powerup HUD and disappears at zero fuel; there is no bar. A small standard purple Bad Aura at the feet appears only during thrust. The donor's visual effects and automatic recharge are omitted. The former Bounce Pad mechanics, state aliases and subroutine are removed.

The final replacement adds 35 compiled elements (29,969 → 30,004), excluding debug rules, with no extra variable slots and one fewer subroutine. Fuel uses a chase instead of the old pad's repeating radius checks and impulses; the shared speed helper now calculates the additive flight bonus. Native testing is still required: release/repress Jump, landing, emptying/refilling the tank during flight, death/respawn, HUD ordering, the standard effect, and overlapping Cloaking Device/Super Nano speed bonuses.

For debugging, `[debug] snky buffs` grants snky 100 fuel and a Jetpack item after a 5-second wait when its gameplay/spawn conditions become true; it does not loop. `debug.opy` is currently included. Pharah and Jetpack Cat cannot refuel using the item; rejected uses preserve it.

## Enhancements and Augments

Choose one primary **Enhancement** with **Quick Melee** and one independent **Augment** with **Interact** before the match. Hold **Secondary Fire** while choosing to cycle backwards. During gameplay, Interact handles powerups and Wrestler. Each unselected slot receives a random real option when gameplay starts, including for players joining an ongoing match: one of twelve Enhancements eligible by role and one of nine Augments. Hitchhiker is the final option in the manual selection menu and is excluded from the random roll. Explicit choices are preserved, and an assigned option is retained across later spawns. There are no Workshop settings for default selections.

Born to Battle stores up to two ability resets. A final blow adds one charge and an ability reset consumes one.

Plague Doctor (`Enhancement.PLAGUE_DOCTOR`) grants **+40% outgoing healing**, with another **×1.25 to infected players**: **175% of normal healing** in total. Beacon of Healing raises outgoing healing to 190%, or **237.5% against infected players**, then restores the permanent 140% when it ends.

Every `PLAYER DEALT HEALING` event applies the following infection reductions in order, using `eventHealing` (actual healing received after modifiers and the maximum-health cap):

1. If the doctor is infected (`isInfected`), reduce their own infection by `eventHealing / 500`, even when healing an uninfected ally.
2. If the recipient still has infection level **≥1** and is not Zombie Hybrid, reduce their infection by `eventHealing / 275`. Reductions are fractional and happen on every healing event, without waiting to accumulate 275 or 500 healing.
3. If the second reduction takes the recipient below level 1, remove another **0.5 level**, show a cure effect and display a cure message. Infection below 1 ends the infected state through the infection rule. These subtractions are not clamped to zero; negative infection represents vaccination.

The **Infection Reduced** HUD counter sums both reductions and the 0.5 cure bonuses. For example, 550 actual healing removes 2 levels from an eligible infected ally and 1.1 from an infected doctor, before any cure bonus.

**Synergy with Survivalist (formerly Leech, `Augment.SURVIVALIST`):** its `heal(eventPlayer, eventPlayer, eventDamage * 0.15)` credits the doctor as both healer and recipient, triggering one `PLAYER DEALT HEALING` event. Both independent checks above can therefore reduce the same player's infection. The second check uses the level **after the first reduction**: if the first already takes it below 1, the second reduction, 0.5 bonus and cure message are skipped. With enough missing health and no other modifiers, lifesteal restores **21% of damage dealt** while uninfected, or **26.25% while infected** (`0.15 × 1.4 × 1.25`). Only actual restored HP contributes to cleansing; unused healing at full health does not provide extra cleansing. Implementation: [healing and Leech handlers](src/abilities/player_events.opy), [healing bonuses](src/abilities/player_initialization.opy), [Beacon of Healing](src/items/supply_drops.opy).

Zombie Hybrid gains infection stacks from zombie melee hits even with temporary health or armor above its normal health threshold. The other infection restrictions still apply, including ultimate and Dash protection, hacked attackers, and the Melee Infection Enabled setting.

This version uses standard beams without the Beam Effects extension.

Double-tap Crouch (0.3s per step) to strike the visible zombie closest to the crosshair within 45m. Bolt Strike deals 200 damage to the primary target and 75 damage to each other visible living zombie within 10m of it. All affected zombies are stunned for 1.5s. A brief lightning beam marks the hit, and a yellow wave spreads 12.5m from the primary target. A successful strike starts a 20s cooldown that persists through death and hero switches. The HUD shows the time remaining and turns green when ready.

Overcharge increases healing dealt by 15%. Beacon of Healing adds 50 percentage points, for 165% healing dealt while active, and restores 115% when it ends. Overcharge stores 1 energy per 3 points added to the native Healing Dealt statistic, without a cap. Health-pack pickups also grant 1 energy per 3 HP actually restored to the player. Each offensive or defensive assist adds 10 energy, including posthumous assists. Healing and assists recorded before initialization grant no energy. Double-tap Crouch (release and press again within 0.3s per step) to spend up to 100 energy and arm a fixed bonus; excess energy remains stored for later charges. Your next damaging hero attack or ability starts a 0.3-second window; every damage event during that window adds the same bonus, including each enemy hit by Ana's grenade. Telekinesis's extended hits can start this window and receive its bonus without extending it. Releasing Crouch does not cancel the armed charge. Healing continues to build a separate next charge; another double-tap of Crouch rearms it after the current window ends. Death clears the armed charge but preserves unspent energy. Turrets, air strikes, other Augments and the bonus damage itself do not trigger this effect.

Bulking Season grants one stack per credited elimination: a kill or damage participation. Healing and buff assists do not grant stacks. Each stack adds 0.5% native maximum health and 0.75% hero size additively. Voice pitch decreases linearly from 1 to 0.5 over 200 stacks (1/400 per stack). Size caps at 2.5x at 200 stacks. Stacks continue accumulating beyond these caps. Hold Melee for 0.5 seconds to toggle between stacked size/pitch (enabled by default) and native size/pitch; release and hold again to switch back. The toggle preserves stacks and the health bonus, and persists through deaths and hero switches. Maximum health caps at 200% of base at 200 stacks; stacks continue accumulating beyond that cap. Death halves stacks, rounding down (5 becomes 2); surviving stacks remain after revival and hero switches. The HUD shows stacks, health bonus and current size.

Press **Interact** to grab a crowd-controlled zombie within 5m. The 90° cone, body-center line of sight and crosshair priority select the target. Ordinary zombies stay knocked down for up to 4s, and bosses and minibosses for up to 1s. The carrier takes 50% less damage while holding. Press Interact again to throw at strength 12.5 for 100 damage after 0.75s. Every release starts a 1.5s grab cooldown. The carry ends when knockdown expires, either participant becomes invalid, or gameplay ends.

Hold **Melee** for 0.25s to target the visible zombie closest to the crosshair within 20m and a 35° cone. A purple beam lasts 0.2s. The target takes 75 damage and is knocked down for 2s, including bosses and minibosses. Only ordinary zombies are pulled, with strength that scales with distance. A successful pull starts a 16s cooldown.

Engineer earns **scrap**: **+10** per zombie bot that dies within 15m and **+1/s** passively while alive, capped at 500. Nearby miniboss deaths and environmental kills count for every Engineer in range. Scrap survives death and hero switches and resets at the start of each match. Late joiners start at 0. Boss-objective deaths do not yield scrap.

Double-tap **Crouch** to craft **75 armor**. Release within 0.3s of the first press, then press again within 0.3s. The visible ally closest to the crosshair within 15m and a 60° cone receives armor for **35 scrap**. If no ally is in range and in view, self armor costs **70 scrap**. Engineer armor is capped at **200 per target**. The transfer beam lasts 0.7s.

Hold **Quick Melee** for **0.25s** with Crouch released to deploy a turret for **350 scrap**. Engineer turrets have a 1/21 chance per hit to freeze the target for 2s. The scrap text is white below 35, sky blue up to 349 and green when the turret is affordable. Engineer has Enhancement ID 10.

### Augments: player guide

Equip one Augment alongside any primary Enhancement. No Preference assigns a random Augment when gameplay starts. Controls use action names and follow your key bindings. **cd** means cooldown. Movement Augments cannot activate while rooted, stunned, asleep, frozen, knocked down or being carried.

| Augment | Controls and effect | Timing, limits and interactions |
|---|---|---|
| Kevlar | Passive: +75 recoverable armor, helping protect against infection. | Healing restores the armor. It does not grant immunity to infection. |
| Dash | Double-tap Jump on the ground or in midair. Each input gap can be up to 0.3s. Dash travels horizontally at strength 22 in your movement direction. | Two charges regenerate one at a time every 14s. Each dash grants 1.7s of damage and native knockback immunity. A dash without directional input grants the protection. |
| Double Jump | Release Jump after takeoff, then press it again in midair. You can also double-tap Jump while grounded. Jump strength is 16. | 14s cooldown. Deal +40% damage until landing or 7s, plus a 0.1s grace period. |
| Telekinesis | Passive: triples Quick Melee reach to 7.5m at normal size, plus supported melee weapons and Carnage. Hits all visible enemies in the strike area; reach scales with your size. Hold attacks to repeat swings. Reinhardt, Brigitte and Torbjörn also support the Quick Melee binding. | Supports Vendetta's sword, Reinhardt's hammer, Brigitte's flail, D.Mon's mech saber, Genji's Dragonblade, Ramattra's Nemesis punches, Torbjörn's equipped hammer and Junker Queen's Carnage. Inactive forms and ranged weapons do not qualify. Outer-range hits deal direct damage without native knockback, wounds, Inspire or perk effects. Pyrotechnic adds its 3s burn on health loss within 15m; armed Overcharge works too. Extended swings use fixed approximate timings rather than native combos or attack-speed bonuses; see below. |
| Ammo Pack | Passive: doubles ammo per full magazine, including a second ammo pool where applicable. Full refills restore the bonus. | Applies when combat starts; interrupted reloads grant no extra ammo. Some heroes keep their native HUD maximum despite receiving extra rounds: Widowmaker may show **70/35**, while Soldier: 76 shows **60/60**. |
| Grapnel Launcher | **Crouch + Jump** hooks the nearest visible player near your crosshair — zombie or ally — 7–45m away, pulling you at 40m/s. Arrival: zombies take 75 damage and are stunned for 0.5s when grounded or knocked down for 3s when airborne; allies are never harmed. | **cd: 16s from launch.** Aim cone 35°; pull limit 1.5s. Releasing buttons does not cancel the pull; Quick Melee remains available. A miss costs no cd; an interrupted launch keeps its cd. Death, crowd control, hero change, losing the target/line of sight or reaching the travel limit ends the pull. Walls still block movement. Pyrotechnic adds a 3s burn on health loss within 15m. HUD shows readiness/cd. |
| Laser Barricade | Hold **Crouch + Interact** for at least 0.5s, aim at a surface within 30m, then release **Interact** to deploy. Crouch may be released while aiming. Wall: 5m wide, 2m tall, 10,000 HP; pushes zombies back. | **cd: 25s from placement.** Early release, death while aiming or invalid placement costs no cd. Blocking contact deals 10 damage and roots for 0.5s, costing the wall 2.5× the zombie's maximum HP. Already-rooted targets are pushed without another damage/HP charge until Rooted expires. Regenerates 500 HP/s after 3s without contact, or after 6s if depleted. A depleted wall stops blocking until recovery. New placement replaces your old wall at full HP. HUD shows HP/cd. |
| Scavenger | Adds a **two-item backpack** beside the active powerup. **Crouch + Interact** stores an aimed ground item; **Interact** alone picks up/swaps the active item. Hold **Reload for 0.25s** to drop everything, even with an empty active slot. Death also drops everything. | Backpack items cannot activate or automatically move to the active slot: drop and pick them up normally to use them. A full backpack leaves aimed items on the ground. Each bot kill or damage participation in a bot elimination has a **5% chance** of one random powerup from all 12 types; healing/buff assists do not qualify. Loot goes to the backpack first, even with an empty active slot; if full, it drops near the dead zombie for anyone to collect. Dropped items are spaced 0.75m apart. HUD: 0/2–2/2. No lifesteal or bonus health. |
| Survivalist (formerly Leech) | Passive: **+50 recoverable health** and healing for **15% of damage dealt**. | Lifesteal includes hero, primary Enhancement and powerup damage. Credited environmental bot kills heal for 15% of remaining health; boss falls heal for 15% of scripted health loss (200 damage, capped by remaining health). Healing restores the extra health. No backpack or extra loot chance. |

**Crouch + Jump** pushes eligible visible zombies within a fixed 10m radius. Teleporting, attached and knockback-immune zombies, bosses and minibosses are excluded. Strength is 25 at a 15° upward angle, scaled by the target’s knockback modifier. A press that finds a target starts the 15s cooldown.

Telekinesis's extended hits use the ranges, damage and timings below, at normal player size. Windup starts before the added hit; recovery is the pause before the next held swing's windup. A committed Vendetta swing completes after releasing attack, but blocking, abilities, crowd control, death or hero change can cancel its windup.

| Attack | Extended reach | Extended hit damage | Windup | Recovery |
|---|---:|---:|---:|---|
| Quick Melee | 7.5m | 40; Zenyatta 60; Venture 70 | 0.15s | Once per melee attack |
| Vendetta sword | 12.9m | 33.75 | 0.15s | 0.45s (0.6s per swing) |
| Reinhardt hammer | 12m | 75 | 0.4s | 0.56s |
| Brigitte flail | 18m | 33.75 | 0.2s | 0.4s |
| D.Mon mech saber | 12m | 45 | 0.2s | 0.456s |
| Genji Dragonblade | 15m | 75 | 0.15s | About 0.459s |
| Ramattra Nemesis punches | 30m | 48.75 | 0.15s | 0.45s |
| Torbjörn hammer | 7.5m | 52.5 | 0.35s | 0.35s |
| Junker Queen Carnage | 13.5m | 78.75 | 0.75s | Once per cast |

## Using the mod code

Compile the source into Workshop code using [OverPy](https://github.com/Zezombye/overpy). Its repository also provides documentation for the language. The compilation entry point is `main.opy` in the project root. The easiest way is to use the OverPy extension for Visual Studio Code.

1. Install Visual Studio Code and the OverPy extension by following the [installation instructions](https://github.com/Zezombye/overpy#installation).
2. Open the project folder in VS Code, then open the root `main.opy` file.
3. Save `main.opy` (`Ctrl+S`). The extension starts compilation; on success, the compiled code is copied to the clipboard and written to `main.ws.txt` in the project root.
4. In Overwatch, create a custom game, open its settings, and import the compiled code from the clipboard.

After changing the source, save the root `main.opy` again to compile the updated mod.

### Switching map pools

Select exactly one pool near the top of [src/includes.opy](src/includes.opy), then rebuild the root `main.opy`.

- `settings/standard_map_pool.opy` uses the standard rotation and is enabled by default.
- `settings/ui_test_map_pool.opy` includes Shambali Monastery, Colosseo, Malevento, Necropolis, Black Forest and Ilios Lighthouse.
- `settings/debug_map_pool.opy` limits the rotation to Rialto.

### Script Load diagnostics

The six-map UI test pool and the `SERVER_LOAD_UI` resource HUD are enabled in `src/includes.opy`. Set `DEBUG_ENABLE_INSPECTOR` to `true` to record match events and sustained load. Add `DEBUG_BOT_AI_LOGS` for per-second target and teleport counts. `DEBUG_INPUT_TEST` cycles inputs for non-host human players. `DEBUG_TEAM1_SURVIVAL` enables Team 1 protection, healing and recovery.

The optional `settings/settings_perf_test.opy` include overrides the lobby slots, player damage, zombie limit, objective pool, pregame timing and cooldowns. For a matched A/B comparison, use the same map, mode, zombie limit, damage settings, Team 1 roster, live participant count and any bot protection in both builds. Keep the diagnostic flags and profile settings matched as well.

### Passive regeneration issue

Passive health regeneration for the zombie team is disabled under **Settings → Heroes → General → Team 2**. However, importing the source code into Workshop resets this setting, apparently due to a Workshop bug. **Manually disable passive regeneration for Team 2 after every code import**, before sharing the mod's short code.

### Workshop hero-selection UI corruption

During pregame voting, selecting a hero and then returning to the native hero-selection screen with Crouch can make some heroes disappear entirely, often starting with newer heroes. Reproduction is intermittent and depends on the map. The user also observed extra white UI buttons and unavailable emotes on the original development branch. Opening and closing the lobby restores the missing hero list, but requiring this from every player is not a usable fix. Earlier diagnostics showed that the script restored the allowed-hero list even when the UI lost heroes.

The problem can appear or disappear after changing rule Conditions unrelated to hero availability, including in rules whose Actions do not run during voting. The root cause remains unknown; high Server Load, a memory leak and a specific engine resource limit have not been established.

**Current source workaround:** space the five pregame world texts by 0.25 seconds with phase cancellation; retain phase/ID pairs in one compiled Condition in 15 ongoing rules; move eligibility checks into synchronous Actions in seven event handlers. All gameplay HUD/effects are enabled. The user accepted the full-visual reference build; source integration was compared with it and compiled without warnings. Reference build: **30,428 elements**, +8 for Pregame and +133 for gameplay, with no new rules or global/player variables. The internal engine cause remains unknown. The standalone [diagnosis and repair guide](docs/WORKSHOP_NATIVE_UI_CORRUPTION.md) includes the complete findings, exact rule list, compiler caveats, validation limits and a transferable investigation procedure.

**An earlier tested workaround was to combine separate Conditions into a single nested `And` expression.** For example:

```csharp
conditions {
    And(Compare(Global.isGameplayActive, ==, True), Compare(Is Alive(Event Player), ==, True)) == True;
}
```

Diagnostic **29a**, based on build 28 (`e23f73d2ac3af65bba98d509f08625eb493b23e3`), reduced condition entries from **850 to 212**, retaining all 305 rule events and action lists. The user reported several runs without the defect, while the matching control still failed intermittently. Both exports used Malevento, Necropolis, Black Forest, Ilios Lighthouse and Colosseo. These results concern hero selection; the white-button and emote symptoms have not been separately verified as fixed. A local `And` change helped Scavenger.

**Mode-wide grouping is currently reverted because of its element cost.** Restore functionality first, then investigate a more targeted fix. The experimental versions had the following costs:

| Export | Elements | Increase over build 28 |
|---|---:|---:|
| Build 28 control | 29,238 | — |
| Diagnostic 29a | 32,347 | +3,109 |
| Source-integrated prototype | 31,619 | +2,381 (8.1%) |

The complete source-integrated prototype is preserved at tag **`experiment-hero-selection-grouped-conditions`**, commit `cb2c552`. It retained the original events/actions, variables and map settings and passed static checks and scripted gameplay regression tests. It was not separately verified in game; user-confirmed successful native runs refer to diagnostic 29a. To inspect its compiler workaround: `git show experiment-hero-selection-grouped-conditions:src/rule_conditions.opy`. The regression check is also available at that tag.

**OverPy 9.7.20 can split `and` back into separate Conditions.** The tagged prototype protected the conjunction by comparing its boolean result with numeric `1`, keeping other optimizations enabled. Comparing with `true` instead lets the optimizer remove the wrapper and split the conjunction. This technique applies only to a boolean result; preserve each predicate's explicit comparison, especially `Null`/zero versus `False`. Fewer Conditions do not prove lower CPU load: nested `And` may evaluate more inputs.

Preserve the earlier local Scavenger workaround in `src/items/power_ups.opy` and action-body guards for Survivalist (formerly Leech) in `src/abilities/augments.opy` and Interact in `src/items/supply_drops.opy`. Moving Conditions into Actions can change ongoing-rule triggering, `Abort When False` and loops; adding waits to event handlers can drop events. For future fixes, inspect generated Workshop code, measure element cost and repeat native tests on affected maps against a matching control. One successful attempt does not establish that an intermittent defect is gone.

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

The [code review report](docs/CODE_REVIEW_REPORT.md) provides supporting evidence, validation status, and recommendations for each finding. The documented defects and risks are inherited from the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>). The proposed optimizations also concern constructs already present in that version.

### Fixed:

- [R10 — Hitchhiker passenger ownership and carrier selection](docs/CODE_REVIEW_REPORT.md#r10). Each player can belong to at most one carrier–passenger pair. The carrier's slot becomes free after its extra health pool is removed, including when the passenger disconnects.
- [R11 — "Doomfist never releases the simulated block button"](docs/CODE_REVIEW_REPORT.md#r11).
- [R16 — "Bot selects a target behind a wall or a stale target"](docs/CODE_REVIEW_REPORT.md#r16).
- [R18 — "Charge Battery selects an ineligible recipient"](docs/CODE_REVIEW_REPORT.md#r18).
- [R33 — Hitchhiker health balancing](docs/CODE_REVIEW_REPORT.md#r33) uses a single sorted pair of players.

## Resources

The [workshop-snapshots](workshop-snapshots/) directory contains exports of ZSMM and other mods, along with their OverPy decompilations. These snapshots are used for comparison and as reference material.

Historical reports and validation results are available in Git at `381a252`.
