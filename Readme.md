# Overwatch Zombie Survival Missions Reforged

**English** | [Русский](Readme.ru.md)

A rework of the [Zombie Survival Missions (786TW)](https://workshop.codes/786TW) mod, written in [OverPy](https://github.com/Zezombye/overpy). Reforged is based on the [ZSMM (786TW) snapshot from October 30, 2026](<workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).ow>).

The project aims to reduce the original mod's element count as much as possible to make room for new mechanics. The first stage focuses on technical optimization. Gameplay changes will be documented here as they are introduced.

The compiled code for the current mod version is available in [main.ws.txt](main.ws.txt). Copy its contents and import them into Overwatch Workshop.

The Reforged author's BattleTag is **snky#21990**.

## Versioning

The [zsmm-classic](https://github.com/sanykey/Overwatch-Zombie-Survival-Missions-Reforged/tree/zsmm-classic) branch will receive only optimizations and fixes for the classic [Zombie Survival Missions (786TW)](https://workshop.codes/786TW), preserving its original gameplay mechanics. The Overwatch Workshop import code for this version is **87EJP**.

The `main` branch is intended for further Reforged development, including new functionality.

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
