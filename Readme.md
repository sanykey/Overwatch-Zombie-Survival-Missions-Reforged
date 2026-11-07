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

Choose one primary **Enhancement** with **Quick Melee** and one independent **Augment** with **Interact** before the match. Hold **Secondary Fire** while choosing to cycle backwards. During gameplay, Interact continues to pick up power-ups. Each unselected slot receives a random real option when gameplay starts, including for players joining an ongoing match: one of ten Enhancements and one of eight Augments. Explicit choices are preserved, and an assigned option is retained across later spawns. There are no Workshop settings for default selections.

Brain Killer is the first primary Enhancement in the voting list. Kevlar has moved from the primary slot to Augments and can now accompany any primary enhancement. Born to Battle stores up to two ability resets, earning one per final blow and spending one per reset.

Overcharge stores 1 energy per 3 actual healing, including health received from health packs, without a cap. Each offensive or defensive assist adds 10 energy, including posthumous assists; assists recorded before initialization grant no energy. Each pack is counted once even when the game attributes its healing to you; Apothecary's supplemental healing grants no extra pack credit. Hold Melee to spend up to 100 energy and arm a fixed bonus; excess energy remains stored for later charges. Your next damaging hero attack or ability starts a 0.3-second window; every damage event during that window adds the same bonus, including each enemy hit by Ana's grenade. Long Reach's extended hits can start this window and receive its bonus without extending it. Releasing Melee does not cancel the armed charge. Healing continues to build a separate next charge; holding Melee rearms it after the current window ends. Death clears the armed charge but preserves unspent energy. Turrets, air strikes, other Augments and the bonus damage itself do not trigger this effect.

Bulking Season grants one stack per credited elimination: a kill or damage participation. Healing and buff assists do not grant stacks. Each stack adds 0.5% native maximum health and 0.5% hero size, additively. Size caps at 1.35x at 70 stacks. Maximum health caps at 200% of base at 200 stacks; stacks continue accumulating beyond both caps. Death halves stacks, rounding down (5 becomes 2); surviving stacks remain after revival and hero switches. The HUD shows stacks, health bonus and size.

| Augment | Effect |
|---|---|
| Kevlar | Adds 75 armor, helping protect against infection. |
| Shock Landing | Release Jump after takeoff, then press Jump again in midair to arm a shockwave on first landing, with invulnerability and player collisions disabled for 0.5 seconds; 13-second cooldown. Movement at the second press adds a dash 15° upward: adjacent inputs give a 45° diagonal. No input or cancelled opposite inputs arm the wave without adding a movement impulse. |
| Double Jump | Press Jump again after releasing it in midair, or double-tap Jump within 0.3 seconds while grounded (including during abilities that prevent native jumping). Both methods share a 16-second cooldown; impulse 14.4. The first enemy hit dealing at least 30 damage during this flight or within 0.5 seconds after landing receives +50% damage. Landing does not reset the cooldown. |
| Long Reach | Triples Quick Melee reach to 7.5 meters at normal size; triples supported melee weapons and Carnage reach. Hits all enemies in the strike area. |
| Ammo Pack | Doubles the ammo available per full magazine, including the second ammunition clip where applicable. |
| Scavenger | Adds two reserve powerup slots beside the active item. Crouch + Interact stores an aimed ground item; Interact alone picks up or swaps the active item. Hold Reload for 0.25s, or die, to drop active and reserve items. Reserves never activate or move to the active slot automatically: drop and pick them up to use them. A full backpack leaves aimed items on the ground. Each bot kill or damage participation in its elimination has a 5% chance of a random powerup from all 13 types; loot enters the backpack first, or drops near the bot when full. Dropped items are spaced 0.75m apart. |
| Apothecary | Health packs add healing equal to the pickup healing event and grant +7 percentage points of ultimate charge and +50% move speed for 5 seconds. Further pickups refresh the speed bonus without stacking it. Remove up to 1 existing infection, down to 0, even after the timer expires. No vaccine is granted. |
| Grapnel Launcher | Crouch + Jump locks the nearest aimed zombie 7–40 meters away, pulls you to it and deals 35 damage on arrival. Grounded targets are stunned for 0.5 seconds; airborne targets are knocked down for 3 seconds. Ground state is checked on arrival. Cooldown: 16 seconds. |

Shock Landing's wave queries once at the first landing position after activation, independently of the 0.5-second phase timer: a 6-meter radius at normal player size, impulse 32 at 6.5° upward, scaled by each zombie's knockback resistance. The upward angle is halved from 13° for less lift and a strong horizontal push. It deals 40 damage to every living visible zombie in range, including behind the player, and assigns environmental kill credit to pushed targets. Attached and knockback-immune zombies take damage but are not pushed; teleporting zombies are excluded. With Pyrotechnic selected, each target that loses health within its normal 15-meter limit burns for 3 seconds through the existing burn queue; invulnerable targets do not ignite. An early landing does not shorten the phase; if still airborne when the phase ends, the wave waits for landing. Death, changing heroes or ending gameplay suppresses the wave while still restoring player collisions.

Double Jump's bonus is spent by the first damage event of at least 30 against a zombie, including native weapons/abilities and script or periodic damage. The threshold applies to that single event before the bonus. It adds half that event's damage through the same supplemental-damage pattern as Brain Killer and consumes the bonus before applying it, preventing recursion. Smaller hits, misses and friendly hits do not spend it. The first landing starts the final 0.5-second window; walking off another ledge does not extend it. Death, changing heroes and game end clear it. If a native ability prevents liftoff, the initial bonus window expires after 0.5 seconds instead of remaining armed indefinitely.

Grapnel Launcher uses the sentry turret's white Grapple beam, attached to both body centers. Its 8-degree aim tolerance selects a visible, living zombie once on activation; the cable and pull then follow that target. Pull speed is 40 m/s, with a 1.5-second travel limit. Launch plays a sound; arrival creates the same orange impact as Long Reach, with size 0.4 (increased from 0.3). Death, crowd control, changing heroes, a blocked path or losing the target removes the cable. A miss consumes no cooldown; a launched hook retains its cooldown if interrupted. Releasing Crouch/Jump does not cancel the pull, and Quick Melee remains available for combos. The HUD shows a checkmark when ready, or remaining cooldown seconds.

Ammo Pack applies after combat begins. On heroes whose native maximum cannot be changed, such as Widowmaker, a full refill restores the doubled stock; the native HUD can still show **70/35**. Cancelling a reload does not grant extra ammo. Heroes with working capacity changes, such as Soldier: 76, keep the normal **60/60** display. See the [known Workshop ammo limitations](https://workshop.codes/wiki/articles/ow2-workshop-changesbugs).

Holding Vendetta's primary attack repeats Long Reach on a fixed **0.6-second** timer. The first hit has a **0.15 s** windup; recovery before the next windup is **0.45 s**. A short click still completes one hit after release; blocking, abilities, crowd control, death or changing heroes cancel the windup. This timer approximates the attack sequence; it does not follow native combo timing or attack-speed bonuses.

The tripled melee attacks are Vendetta's sword, Reinhardt's hammer, Brigitte's flail, D.Mon's mech saber, Genji's Dragonblade, Ramattra's Nemesis punches, Torbjörn's equipped hammer, and Junker Queen's Carnage. Melee weapons repeat while held, including the Melee binding for Reinhardt, Brigitte and Torbjörn; Carnage extends once per cast. Ranged weapons and inactive forms do not trigger these attacks. The added weapon controllers also use approximate swing timers.

The extended area adds direct damage outside native reach; it does not reproduce melee weapons' native knockback, wounds, Inspire or perk effects. **Pyrotechnic** explicitly works with Long Reach and Grapnel Launcher: every target which loses health from an extended melee hit or the hook's arrival damage within its normal 15-meter limit enters the existing burn queue. Invulnerable targets do not ignite, and burn damage cannot trigger itself.

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
