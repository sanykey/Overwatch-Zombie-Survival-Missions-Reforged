# Ultimate damage resist (50% intake while using ultimate) and bite DoT gate

Date: 2026-11-13. Branch: experiments-rebuild. Baseline total: 30 169 → 30 321 (+152 elements:
+56 resist recompute, +96 DoT gate after flag materialization minus the removed mech-hero checks,
+37 the second materialized flag and the HUD `*` marker).

## Design

One shared recompute subroutine `applyDamageReceivedModifier()` (src/hero_tuning.opy) is the only
Team 1 `Set Damage Received` writer (bot rules keep their own writes). It picks the strongest
active protection — the values never stack:

| State | Flag read | Intake |
|---|---|---|
| Dash protection window | `augmentId == Augment.DASH and augmentDashSmokeEntity != null` | 0 (emitted as `Null`, which behaves as 0) |
| Super Nano power-up active | `powerUpSuperNanoGoodAuraId != 0` | 50 |
| Using ultimate | `isUsingUltimate()` | 50 |
| None | — | 100 |

Every state edge calls the recompute: the new rule `PLAYER ULTIMATE DAMAGE RESIST`
(src/hero_tuning.opy, start + waitUntil-end), Dash activation in `useAugmentAirAction()`
(open the smoke window first, then recompute), `DASH SMOKE FADE`, `PLAYER DIED` (unconditional,
after the Dash-guarded smoke cleanup), `superNano()` start and cleanup (the cleanup clears
`powerUpSuperNanoGoodAuraId` before recomputing).

## Decisions

- **Mech-hero exclusions REMOVED (2026-11-13, user decision).** The first implementation excluded
  D.Mon/D.Va from the ultimate term (rule conditions + recompute + DoT flag), based on the
  2026-11-11 in-game observation that Is Using Ultimate sticks true from Self-Destruct through
  pilot form and Call Mech (memory `is-in-alternate-form-dva`). The user could not reproduce that
  behavior and asked for the checks to be removed; as a live diagnostic, the health-HUD now shows
  a `*` right after the health percentage while any resist from
  `applyDamageReceivedModifier` is active (playervar `hasDamageResist`, also written by the
  recompute). If a D.Va/D.Mon pilot or mech permanently shows `*` after one Self-Destruct, the
  stuck-true behavior is confirmed and the exclusions should come back.
- **SWARM SHOOTOUT stacking** stays untouched: it lowers intake via Start Damage Modification
  (72%), which multiplies on top of Set Damage Received. Super Nano already relies on this
  (50% intake + 50% modification at once).
- **Side fixes**: `DASH SMOKE FADE` used to force intake back to 100 even while Super Nano was
  active (the nano resist was lost for the rest of its duration after any dash); the recompute
  preserves it. Nano cleanup likewise no longer breaks an active Dash window.
- **No cross-match sweep**: an initial `getPlayers(Team.1).setDamageReceived(100)` in START GAME
  was removed from the working tree during review; intake therefore persists across matches
  unless the engine resets it. Cover restart-after-ult in the in-game tests.
- **OverPy Null folding**: in a value context OverPy renders the literal 0 as `Null`
  (`Set Damage Received(Event Player, Null)` inside the If-Then-Else). The engine treats Null as 0
  here (zero == Null per workshop.codes comparisons-and-truth), and the existing code already
  compares/writes `powerUpSuperNanoGoodAuraId` through the same folding.

## DoT gate (second change, same day, then extended)

All zombie-applied DoT sources are now gated on the shared materialized flag
`isDotProtected` (written by `applyDamageReceivedModifier`): while the victim is ulting
or inside the Dash protection window, no NEW damage-over-time effect starts
on them. Already ticking DoTs, existing infection levels and direct hit damage are untouched.

| Source | Rule / site | Gate form |
|---|---|---|
| Bite DoT + infection stacks | BOTS INFLICT DAMAGE OVER TIME (bots_game_in_progress.opy) | one negated rule condition (replaced the two draft conditions — cheaper) |
| Blaster (Pharah) rocket burns | BLASTER ROCKET HITS TARGET (zombie_types.opy) | rule condition |
| Rusher (Torb) boss Molten Core burns | RUSHER MOLTEN CORE BURNS PLAYERS (zombie_types.opy) | rule condition |
| Roadhog gas attack (regular, <50% hp) | BEHEMOTH (ROAD) TOXIC CLOUD (zombie_types.opy) | gate first in the target filter lambda |
| Behemoth (boss Roadhog) toxic cloud ticks | BEHEMOTH GAS STREAM (BOSS) (zombie_types.opy) | gate in the append filter lambda |
| Bomber (Junkrat) explosion burn + DoT | explosionSequence isDummy branch (subroutines.opy) | burn/DoT targets filtered via tmp0 with a Team 2 carve-out (bots keep burning); the closer direct blast damage stays ungated |

**Cost note (first draft → flag materialization).** The first draft inlined the predicate at all
six sites (+201, total 30 426): Workshop has no functions, so `blocksNewDot` — Is Using Ultimate,
two mech-hero comparisons and the Dash-window check — duplicated per site, plus heavy Filtered
Array lambdas. Final design materializes the state instead: `applyDamageReceivedModifier` (which
every gate-state edge already calls) writes the playervar `isDotProtected` (+32+1), and all six
sites read the 3-element flag (−195). Net for the whole gate: +33, total 30 284. The flag has the
same edge coverage as the intake recompute (ultimate start/end, Dash activation/fade, death, Nano
start/cleanup — the Nano edges rewrite it with an unchanged value) and no read latency, since it
is set synchronously at the same edges.

Not gated: Pyrotechnic burn (players burning zombies), boss self-burn visuals (Bomber/Reignited
pre-explosion self-ignition), Zombie Hybrid explosion (its targets are zombies).

Side fix kept from the first draft: the old inner infection check
`not victim.isUsingUltimate()` was removed — it made stuck-true D.Mon/D.Va permanently unable to
gain infection stacks after their first Self-Destruct; with the gate they take bites normally
(the removal now also covers the user's position that the stuck-true behavior is unconfirmed).

## Verification

`node analysis/2026-11-13-verify-ult-resist.cjs` compiles the tree via the /tmp/overpy-check CLI
(the shared measure-further-optimizations.cjs helper currently crashes with the bundled 9.7.21
API) and asserts: single subroutine, 7 call sites, the rule keys on Is Using Ultimate with NO
mech-hero conditions (user removed them), both materialized flags (isDotProtected, hasDamageResist)
written by the recompute, call-site ordering in all five writers, exactly 4 remaining bot-side
literal writes, all six DoT gate sites (bite, Molten Core, rockets, gas, cloud stream, explosion
with the Team 2 carve-out — plus the inner bite ult check removed), the HUD `*` marker after the
health percentage, and a truth table evaluated against the real compiled If-Then-Else (dash beats
nano/ult; nano and ult do not stack).

## In-game tests still pending

- Resist appears on ult start and disappears on end/death/hero change for several heroes.
- Dash during ult: 0% window, back to 50% on fade; nano + dash and nano + ult combinations.
- D.Va and D.Mon diagnostic: cast Self-Destruct, stay in pilot, Call Mech and watch the HUD `*`.
  A persistent `*` outside a genuine ult confirms the stuck-true Is Using Ultimate (the removed
  mech-hero exclusions must then be restored); a `*` only during the actual ult confirms the
  removal was safe.
- Bite DoT gate: bites during ult/Dash window apply no DoT and no infection stacks; existing
  DoT/infection keeps ticking.
- Full DoT gate: Pharah rockets, both Roadhog gas clouds, boss Molten Core and Bomber explosions
  start no new burn/DoT on protected players (direct damage still lands, resist still halves it);
  Team 2 bots still burn from Bomber explosions.
- SWARM SHOOTOUT: zombies deal 0.72 × 0.5 = 36% to an ulting player.
- Match restart after dying mid-ult: verify whether intake resets without a START GAME sweep.
