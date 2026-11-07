# Overwatch Zombie Survival Missions Reforged

**English** | [Русский](Readme.ru.md)

A rework of the [Zombie Survival Missions (786TW)](https://workshop.codes/786TW) mod, written in [OverPy](https://github.com/Zezombye/overpy). Reforged is based on the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>).

The project aims to reduce the original mod's element count as much as possible to make room for new mechanics. The first stage focuses on technical optimization. Gameplay changes will be documented here as they are introduced.

The compiled code for the current mod version is available in [main.ws.txt](main.ws.txt). Copy its contents and import them into Overwatch Workshop.

The Reforged author's BattleTag is **snky#21990**.

## Versioning

The [zsmm-classic](https://github.com/sanykey/Overwatch-Zombie-Survival-Missions-Reforged/tree/zsmm-classic) branch will receive only optimizations and fixes for the classic [Zombie Survival Missions (786TW)](https://workshop.codes/786TW), preserving its original gameplay mechanics. The Overwatch Workshop import code for this version is **87EJP**.

The `main` branch is intended for further Reforged development, including new functionality.

## Enhancements and Augments

Choose one primary **Enhancement** with **Quick Melee** and one independent **Augment** with **Interact** before the match. Hold **Secondary Fire** while choosing to cycle backwards. During gameplay, Interact continues to pick up power-ups. Each unselected slot receives a random real option when gameplay starts, including for players joining an ongoing match: one of eleven Enhancements and one of eleven Augments. Explicit choices are preserved, and an assigned option is retained across later spawns. There are no Workshop settings for default selections.

Brain Killer is the first primary Enhancement in the voting list. Kevlar has moved from the primary slot to Augments and can now accompany any primary enhancement. Born to Battle stores up to two ability resets, earning one per final blow and spending one per reset.

Bolt Strike chains each hero hit to up to two random other living visible zombies within 10 meters of the original victim, dealing 25% of the hit damage, capped at 20 per target. Actual health removed by chain damage builds energy, capped at 200. At 200, hold Quick Melee to spend the bank and arm a strike. Releasing Melee preserves it. The next hero hit starts a 0.3-second window: every target hit during it receives a sky-to-target Tesla beam, 60 extra damage and a 2-second stun. Chain damage continues banking the next charge; neither scripted chains nor sky strikes retrigger or charge themselves. Death cancels the armed burst but preserves banked energy. Beams last up to 0.3 seconds and are replaced on the next hero hit; death, disconnect and game end clean them up without delaying damage processing. The sky beam is adapted from the local Lordy's ZSM (KT6ZY) snapshot; Beam Effects is required.

Overcharge stores 1 energy per 3 actual healing, including healing received from health packs, without a cap. Hold Melee to spend up to 250 energy and arm a fixed bonus; excess energy remains stored for later charges. Your next damaging hero attack or ability starts a 0.3-second window; every damage event during that window adds the same bonus, including each enemy hit by Ana's grenade. Releasing Melee does not cancel the armed charge. Healing continues to build a separate next charge; holding Melee rearms it after the current window ends. Death clears the armed charge but preserves unspent energy. Long Reach extended melee hits also trigger and receive this bonus within the same window. Turrets, air strikes, other Augments and the bonus damage itself do not trigger this effect.

Bulking Season grants one stack per credited elimination: a kill or damage participation. Healing and buff assists do not grant stacks. Each stack adds 0.5% native maximum health and 0.5% hero size, additively. Size caps at 1.35x at 70 stacks. Maximum health caps at 200% of base at 200 stacks; stacks continue accumulating beyond both caps. Death halves stacks, rounding down (5 becomes 2); surviving stacks remain after revival and hero switches. The HUD shows stacks, health bonus and size.

### Augments: player guide

Equip one Augment alongside any primary Enhancement. No Preference assigns a random Augment when gameplay starts. Controls use action names and follow your key bindings. **cd** means cooldown. Movement Augments cannot activate while rooted, stunned, asleep, frozen, knocked down or being carried.

| Augment | Controls and effect | Timing, limits and interactions |
|---|---|---|
| Kevlar | Passive: +75 recoverable armor, helping protect against infection. | Healing restores the armor. It does not grant immunity to infection. |
| Shock Landing | Release Jump after takeoff, then press again in midair. First landing: 40 damage to every visible zombie within 6m, including behind you, and an outward push. Movement input adds a dash; no input arms only the wave. | **cd: 13s from activation.** Invulnerability and passage through players last 0.5s even if you land early; a later landing still triggers the wave. Dash strength 25, 15° upward; adjacent inputs give a 45° diagonal. Wave strength 32, 6.5° upward, reduced by knockback resistance; radius scales with your size. Carried/knockback-immune zombies take damage without push; teleporting zombies are excluded. Environmental kills from the push count for you. Pyrotechnic adds a 3s burn on health loss within 15m. Death, hero change or game end cancels a pending wave. |
| Double Jump | Release Jump and press again in midair, or double-tap within 0.3s while grounded, including during abilities that prevent normal jumping. Upward jump strength: 14.4. The first damage event of at least 30 against a zombie in flight **or within 0.5s after landing** deals +50%. | **cd: 16s**, shared by both inputs; landing does not reset it. The threshold applies to one hit before the bonus. Weapons, abilities, powerups and periodic damage qualify; smaller hits, misses and friendly hits do not spend it. Leaving another ledge does not extend the landing window. If liftoff fails, the bonus expires after 0.5s. Death, hero change and game end clear it. |
| Long Reach | Passive: triples Quick Melee reach to 7.5m at normal size, plus supported melee weapons and Carnage. Hits all visible enemies in the strike area; reach scales with your size. Hold attacks to repeat swings. Reinhardt, Brigitte and Torbjörn also support the Quick Melee binding. | Supports Vendetta's sword, Reinhardt's hammer, Brigitte's flail, D.Mon's mech saber, Genji's Dragonblade, Ramattra's Nemesis punches, Torbjörn's equipped hammer and Junker Queen's Carnage. Inactive forms and ranged weapons do not qualify. Outer-range hits deal direct damage without native knockback, wounds, Inspire or perk effects. Pyrotechnic adds its 3s burn on health loss within 15m; armed Overcharge works too. Extended swings use fixed approximate timings rather than native combos or attack-speed bonuses; see below. |
| Ammo Pack | Passive: doubles ammo per full magazine, including a second ammo pool where applicable. Full refills restore the bonus. | Applies when combat starts; interrupted reloads grant no extra ammo. Some heroes keep their native HUD maximum despite receiving extra rounds: Widowmaker may show **70/35**, while Soldier: 76 shows **60/60**. |
| Grapnel Launcher | **Crouch + Jump** hooks the nearest visible zombie near your crosshair, 7–40m away, pulling you at 40m/s. Arrival: 35 damage; grounded targets are stunned for 0.5s, airborne targets knocked down for 3s. | **cd: 16s from launch.** Aim tolerance 8°; pull limit 1.5s. Releasing buttons does not cancel the pull; Quick Melee remains available. A miss costs no cd; an interrupted launch keeps its cd. Death, crowd control, hero change, losing the target/line of sight or reaching the travel limit ends the pull. Walls still block movement. Pyrotechnic adds a 3s burn on health loss within 15m. HUD shows readiness/cd. |
| Laser Barricade | Hold **Crouch + Interact** for at least 0.5s, aim at a surface within 30m, then release **Interact** to deploy. Crouch may be released while aiming. Wall: 5m wide, 2m tall, 10,000 HP; pushes zombies back. | **cd: 30s from placement.** Early release, death while aiming or invalid placement costs no cd. Blocking contact deals 10 damage and roots for 0.5s, costing the wall 2.5× the zombie's maximum HP. Already-rooted targets are pushed without another damage/HP charge until Rooted expires. Regenerates 500 HP/s after 3s without contact, or after 6s if depleted. A depleted wall stops blocking until recovery. New placement replaces your old wall at full HP. HUD shows HP/cd. |
| Apothecary | Health packs add healing equal to the pickup's healing, remove up to 1 existing infection even after time runs out, grant **+7 percentage points of ult charge** and **+50% movement speed for 5s**. | Further packs refresh speed without stacking; death ends the speed bonus. Infection cannot fall below 0; no vaccine is granted. Normal pack cleansing still applies where difficulty and match time permit it. You can pick up packs near full health: the Augment keeps you 1 HP below maximum to allow pickup. |
| Scavenger | Adds a **two-item backpack** beside the active powerup. **Crouch + Interact** stores an aimed ground item; **Interact** alone picks up/swaps the active item. Hold **Reload for 0.25s** to drop everything, even with an empty active slot. Death also drops everything. | Backpack items cannot activate or automatically move to the active slot: drop and pick them up normally to use them. A full backpack leaves aimed items on the ground. Each bot kill or damage participation in a bot elimination has a **5% chance** of one random powerup from all 13 types; healing/buff assists do not qualify. Loot goes to the backpack first, even with an empty active slot; if full, it drops near the dead zombie for anyone to collect. Dropped items are spaced 0.75m apart. HUD: 0/2–2/2. No lifesteal or bonus health. |
| Leech | Passive: **+50 recoverable health** and healing for **15% of damage dealt**. | Includes hero, primary Enhancement and powerup damage. Healing restores the extra health. No backpack or extra loot chance. |
| Dead Weight | Aim at a zombie within **4m** and press **Interact** to grab; press again to throw in your facing direction. Target must be stunned, asleep, frozen, knocked down or below **20% HP**; Rooted alone does not qualify. | **No cd.** Excludes bosses, minibosses, teleporting/already-carried targets; intervening players block pickup. You cannot grab while stunned, asleep, frozen, knocked down or being carried. Hold up to **5s**; target knockdown lasts up to **6s from pickup**. Throw strength **12.5**; after **0.75s**, the thrown zombie takes **50 damage** and knockdown ends. No splash/landing damage. Hold expiry, your death/disconnect/hero change, loss of target knockdown or game end drops it without throw damage. HUD shows hold time. While carrying, Interact throws instead of handling powerups. |

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
