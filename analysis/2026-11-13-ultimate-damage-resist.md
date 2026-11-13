# Ultimate damage resist (50% intake while using ultimate)

Date: 2026-11-13. Branch: experiments-rebuild. Baseline total: 30 169 → 30 225 (+56 elements).

## Design

One shared recompute subroutine `applyDamageReceivedModifier()` (src/hero_tuning.opy) is the only
Team 1 `Set Damage Received` writer (bot rules keep their own writes). It picks the strongest
active protection — the values never stack:

| State | Flag read | Intake |
|---|---|---|
| Dash protection window | `augmentId == Augment.DASH and augmentDashSmokeEntity != null` | 0 (emitted as `Null`, which behaves as 0) |
| Super Nano power-up active | `powerUpSuperNanoGoodAuraId != 0` | 50 |
| Using ultimate (non-mech hero) | `isUsingUltimate()` and hero not D.Mon/D.Va | 50 |
| None | — | 100 |

Every state edge calls the recompute: the new rule `PLAYER ULTIMATE DAMAGE RESIST`
(src/hero_tuning.opy, start + waitUntil-end), Dash activation in `useAugmentAirAction()`
(open the smoke window first, then recompute), `DASH SMOKE FADE`, `PLAYER DIED` (unconditional,
after the Dash-guarded smoke cleanup), `superNano()` start and cleanup (the cleanup clears
`powerUpSuperNanoGoodAuraId` before recomputing).

## Decisions

- **Mech heroes (D.Mon AND D.Va) are excluded from the ultimate term**, in both the rule
  conditions and the recompute. The in-game 2026-11-11 test proved Is Using Ultimate sticks true
  from Self-Destruct through pilot form and Call Mech for D.Mon (see memory
  `is-in-alternate-form-dva`); D.Va is the same native mechanic and IS reachable — players get
  `setAllowedHeroes(getAllHeroes())` in both the pregame menu and hero switching
  (player_start_menu.opy:137, players_game_in_progress.opy:345). OverPy 9.7.21's hero data
  confirms D.Mon and D.Va are distinct hero entries (D.Mon: Power Barrier/Limit Break,
  assembleMech settings). A plain gate would give a pilot/mech D.Va or D.Mon a permanent 50%
  resist after their first Self-Destruct.
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

## Verification

`node analysis/2026-11-13-verify-ult-resist.cjs` compiles the tree via the /tmp/overpy-check CLI
(the shared measure-further-optimizations.cjs helper currently crashes with the bundled 9.7.21
API) and asserts: single subroutine, 7 call sites, rule conditions (Is Using Ultimate == True,
Hero != D.Mon, Hero != D.Va), call-site ordering in all five writers, exactly 4 remaining
bot-side literal writes, and a truth table evaluated against the real compiled If-Then-Else
(dash beats nano/ult; nano and ult do not stack; stuck-true D.Mon and D.Va get nothing but keep
the nano/dash resists).

## In-game tests still pending

- Resist appears on ult start and disappears on end/death/hero change for several heroes.
- Dash during ult: 0% window, back to 50% on fade; nano + dash and nano + ult combinations.
- D.Va and D.Mon: no resist in pilot or mech from the stuck-true flag.
- SWARM SHOOTOUT: zombies deal 0.72 × 0.5 = 36% to an ulting player.
- Match restart after dying mid-ult: verify whether intake resets without a START GAME sweep.
