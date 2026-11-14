const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const baseInput = '((eventPlayer.augmentId != Augment.APOTHECARY or not eventPlayer.isHoldingButton(Button.CROUCH)) and (eventPlayer.augmentId != Augment.LASER_BARRICADE or (not eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.augmentBarrierPlacementCooldown >= 0)))';
const valid = '([isGameplayActive, entityExists(carrier), carrier.isAlive(), not carrier.isAttached, carrier.getHero() == eventPlayer.wrestlerCarryHero, eventPlayer.isAlive(), not eventPlayer.botIsInitializing, not eventPlayer.botIsTeleporting, eventPlayer.botIsAttached, eventPlayer.hasStatus(Status.KNOCKED_DOWN)].all())';
const variants = {
    positiveCarryPredicate(f) {
        const line = f['enhancements.opy'].split('\n').find(l => l.startsWith('#!define livingProjectileInterrupted'));
        replace(f, 'enhancements.opy', line, '#!define livingProjectileValid(carrier) ' + valid);
        replace(f, 'enhancements.opy', 'or livingProjectileInterrupted(eventPlayer.wrestlerZombieCarrier)', 'or not livingProjectileValid(eventPlayer.wrestlerZombieCarrier)');
        replace(f, 'enhancements.opy', 'and not livingProjectileInterrupted(wrestlerCarrier)', 'and livingProjectileValid(wrestlerCarrier)');
    },
    simplerLateInputGuard(f) {
        // This handler is the sole caller of pickup. Successful pickup/throw returns
        // above the powerup wait, so it cannot start carrying during that wait.
        replace(f, 'supply_drops.opy', 'if isGameplayActive and INTERACT_AUGMENT_INPUT_ALLOWED:', 'if isGameplayActive and ' + baseInput + ':');
    },
    factoredInputPredicate(f) {
        replace(f, 'supply_drops.opy', baseInput, '(not ((eventPlayer.augmentId in [Augment.APOTHECARY, Augment.LASER_BARRICADE] and eventPlayer.isHoldingButton(Button.CROUCH)) or (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown < 0)))');
    },
    factoredAllInputPredicates(f) {
        assert(f['supply_drops.opy'].includes(baseInput));
        f['supply_drops.opy'] = f['supply_drops.opy'].replaceAll(baseInput, '(not ((eventPlayer.augmentId in [Augment.APOTHECARY, Augment.LASER_BARRICADE] and eventPlayer.isHoldingButton(Button.CROUCH)) or (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown < 0)))');
    },
    immediateThrowDamage(f) {
        replace(f, 'enhancements.opy', '        eventPlayer.wrestlerThrowDamageCredit = wrestlerCarrier\n        wait(WRESTLER_DAMAGE_DELAY, Wait.IGNORE_CONDITION)\n        damage(eventPlayer, eventPlayer.wrestlerThrowDamageCredit, WRESTLER_THROW_DAMAGE)', '        damage(eventPlayer, wrestlerCarrier, WRESTLER_THROW_DAMAGE)');
    },
    noCarryProtection(f) {
        replace(f, 'enhancements.opy', '    startDamageModification(eventPlayer, getAllPlayers(), 50)\n    livingProjectileCandidate.wrestlerProtectionId = getLastDamageModification()\n', '');
        replace(f, 'enhancements.opy', '    stopDamageModification(eventPlayer.wrestlerProtectionId)\n', '');
        replace(f, 'global_start_menu.opy', ' Take 50% less dmg while carrying.', '');
    },
    noCountdownHud(f) {
        replace(f, 'player_initialization.opy', 'f"[{inputBindingString(Button.INTERACT)}]: throw | {max(0, ceil(localPlayer.enhancementHoldUntil - getTotalTimeElapsed()))}s left"', 'f"[{inputBindingString(Button.INTERACT)}]: throw"');
    },
    staticHud(f) {
        const line = f['player_initialization.opy'].split('\n').find(l => l.includes(']: throw |'));
        replace(f, 'player_initialization.opy', line, '            f"[{inputBindingString(Button.INTERACT)}]: grab / throw | Hold limit: 5s",');
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    assert.deepEqual(before.warnings, []);
    const rows = [];
    const cases = [...Object.keys(variants).map(k => [k, [k]]),
        ['safeCombined', ['positiveCarryPredicate', 'simplerLateInputGuard']],
        ['safeWithFactoring', ['positiveCarryPredicate', 'simplerLateInputGuard', 'factoredInputPredicate']],
        ['safeAllFactored', ['positiveCarryPredicate', 'simplerLateInputGuard', 'factoredAllInputPredicates']],
        ['simplifiedCombined', ['positiveCarryPredicate', 'simplerLateInputGuard', 'immediateThrowDamage', 'noCarryProtection', 'staticHud']]];
    for (const [name, choices] of cases) {
        const candidate = {...files};
        choices.forEach(k => variants[k](candidate));
        const after = await compile(candidate);
        assert.deepEqual(after.warnings, []);
        rows.push({name, choices, elements: after.elements, saved: before.elements - after.elements});
    }
    const report = {compiler: 'OverPy 9.7.21', before: before.elements, variants: rows,
        limitations: 'Read-only compilation probes. Safe candidates require equivalence and lifetime review; feature cuts are proposals, not production changes.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-wrestler-optimization-probe.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
if (require.main === module) main().catch(error => {console.error(error);process.exitCode=1;});

module.exports = {variants};
