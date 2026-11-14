// Compile an in-memory build with Wrestler completely removed, including its UI slot.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');

function removeWrestler(f) {
    const start = f['enhancements.opy'].indexOf('def useLivingProjectile():');
    const end = f['enhancements.opy'].indexOf('rule "ENGINEER SCRAP INCOME":', start);
    assert(start >= 0 && end > start);
    f['enhancements.opy'] = f['enhancements.opy'].slice(0, start) + f['enhancements.opy'].slice(end);
    f['enhancements.opy'] = f['enhancements.opy'].replace(/^#!define WRESTLER_.*\n/gm, '');
    replace(f, 'supply_drops.opy', 'subroutine useLivingProjectile\n', '');
    const inputStart = f['supply_drops.opy'].indexOf('    # Resolve zombie interaction once per press');
    const inputEnd = f['supply_drops.opy'].indexOf('    # Query aimed items only on interaction', inputStart);
    assert(inputStart >= 0 && inputEnd > inputStart);
    f['supply_drops.opy'] = f['supply_drops.opy'].slice(0, inputStart) + f['supply_drops.opy'].slice(inputEnd);
    if (f['supply_drops.opy'].includes('#!define INTERACT_AUGMENT_INPUT_RESERVED')) {
        const oldLine = f['supply_drops.opy'].split('\n').find(l => l.startsWith('#!define INTERACT_AUGMENT_INPUT_ALLOWED'));
        assert(oldLine.includes('Enhancement.WRESTLER'));
        replace(f, 'supply_drops.opy', oldLine, '#!define INTERACT_AUGMENT_INPUT_ALLOWED (not INTERACT_AUGMENT_INPUT_RESERVED)');
    } else replace(f, 'supply_drops.opy',
        '((eventPlayer.enhancementId == Enhancement.WRESTLER and eventPlayer.enhancementHeldZombie != null) or ((eventPlayer.augmentId != Augment.APOTHECARY or not eventPlayer.isHoldingButton(Button.CROUCH)) and (eventPlayer.augmentId != Augment.LASER_BARRICADE or (not eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.augmentBarrierPlacementCooldown >= 0))))',
        '((eventPlayer.augmentId != Augment.APOTHECARY or not eventPlayer.isHoldingButton(Button.CROUCH)) and (eventPlayer.augmentId != Augment.LASER_BARRICADE or (not eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.augmentBarrierPlacementCooldown >= 0)))');
    f['augments.opy'] = f['augments.opy'].replaceAll('    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementHeldZombie == null) == true\n', '');
    f['augments.opy'] = f['augments.opy'].replaceAll('    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementCarryState == WrestlerCarryState.NONE) == true\n', '');
    f['zombie_types.opy'] = f['zombie_types.opy'].replaceAll('    @Condition eventPlayer.wrestlerZombieCarrier == null\n', '');
    f['player_initialization.opy'] = f['player_initialization.opy'].replace(/        case Enhancement\.WRESTLER:\n[\s\S]*?            break\n/, '');
    const hudLine = f['player_initialization.opy'].split('\n').find(l => l.includes(']: throw'));
    assert(hudLine);
    replace(f, 'player_initialization.opy', hudLine + '\n', '');
    replace(f, 'player_initialization.opy', ', "Wrestler"', '');
    // Colors after Bulking Season: Wrestler, Bolt Strike, Engineer.
    replace(f, 'player_initialization.opy', '            Color.WHITE, Color.WHITE,\n            Color.WHITE,\n            # White below armor cost', '            Color.WHITE,\n            Color.WHITE,\n            # White below armor cost');
    replace(f, 'global_start_menu.opy', ', "Wrestler "', '');
    const description = f['global_start_menu.opy'].split('\n').find(l => l.includes('Grab zombies within 5m,'));
    assert(description);
    replace(f, 'global_start_menu.opy', description + '\n', '');
    replace(f, 'global_start_menu.opy', 'Color.LIME_GREEN, Color.SKY_BLUE, Color.YELLOW, Color.ROSE]', 'Color.LIME_GREEN, Color.YELLOW, Color.ROSE]');
    replace(f, 'variables.opy', '    WRESTLER = 11,\n    BOLT_STRIKE = 12,\n    ENGINEER = 13,', '    BOLT_STRIKE = 11,\n    ENGINEER = 12,');
    replace(f, 'variables.opy', '    WRESTLER = iconString(Icon.TRASHCAN),\n', '');
    replace(f, 'variables.opy', ', EnhancementIcon.WRESTLER', '');
    // Aliases compile to no elements; their underlying slots remain shared by other abilities.
    f['variables.opy'] = f['variables.opy'].replace(/^#!define (?:wrestler\w+|enhancementHeldZombie|enhancementHoldUntil|enhancementCarryState) .*\n/gm, '');
    f['variables.opy'] = f['variables.opy'].replace(/enum WrestlerCarryState:\n(?:    .*\n)+/, '');
    assert(!/WRESTLER|wrestler|enhancementHeldZombie|enhancementHoldUntil|enhancementCarryState|useLivingProjectile|livingProjectile|Wrestler/.test(Object.values(f).join('\n').replace(/^\s*#.*$/gm, '')));
}

function ruleCounts(result) {
    // Several rules share the name EFFECTS/TEXTS; aggregate rather than overwrite.
    const counts = {};
    for (const [,n,name] of result.matchAll(/^\/\/(\d+) elements\nrule \("([^"\n]+)"\)/gm)) counts[name] = (counts[name] || 0) + +n;
    return counts;
}

async function main() {
    await compiler.readyPromise;
    const original = {...files};
    const before = await compile(files);
    const candidate = {...files};
    removeWrestler(candidate);
    const after = await compile(candidate);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(files, original);
    const oldRules = ruleCounts(before.result), newRules = ruleCounts(after.result);
    const changedRules = [...new Set([...Object.keys(oldRules), ...Object.keys(newRules)])]
        .map(name => ({name, before: oldRules[name] || 0, withoutWrestler: newRules[name] || 0,
            cost: (oldRules[name] || 0) - (newRules[name] || 0)})).filter(r => r.cost);
    const total = before.elements - after.elements;
    const ruleCost = changedRules.reduce((sum, r) => sum + r.cost, 0);
    assert.equal(ruleCost, total);
    const table = result => [...result.matchAll(/^\s+\d+: (\w+)$/gm)].map(m => m[1]);
    const report = {
        compiler: 'OverPy 9.7.21', baselineElements: before.elements,
        withoutWrestlerElements: after.elements, wrestlerTotalElements: total,
        shareOfCurrentBuildPercent: +(total / before.elements * 100).toFixed(2),
        changedRules, ruleCost, outsideCountedRules: total - ruleCost,
        removedDeclarations: table(before.result).filter(n => !table(after.result).includes(n)),
        warnings: after.warnings,
        method: 'In-memory complete removal of pickup/release, Interact handling and its predicate exceptions, augment/Rider guards, spawn initialization, HUD subtitle/name/color entry, menu name/description/color entry and icon entry. Subsequent Enhancement IDs shift down by one. All shared storage and shared UI infrastructure remain. Sum of compiled rule deltas must equal total compiler delta.',
        limitations: 'Marginal compiled size of removing the full option, including compiler string packing and switch optimizations. No runtime-performance claim. Production source and main.ws.txt remain unchanged.'
    };
    fs.writeFileSync(path.join(__dirname, '2026-11-14-wrestler-full-cost.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {removeWrestler};
