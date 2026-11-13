const fs = require('node:fs');
const {files: currentFiles, compile, compiler} = require('./measure-further-optimizations.cjs');
// Reconstruct the pre-optimization input contract in memory so these probes
// remain reproducible after applying the winning variant to production sources.
function baselineSources(input) {
    const f = {...input};
    if (f['player_events.opy'].includes('enhancementHitHealthBefore == null')) return f;
    f['subroutines.opy'] = f['subroutines.opy'].replace('    enhancementHitDamage -= enhancementHitVictim.getHealth()\n', '');
    let s = f['player_events.opy'];
    const guard = '    if enhancementHitDamage <= 0:\n        return\n';
    const start = s.indexOf(guard), end = s.indexOf('\n\n\nrule "CROWD CONTROL STATUS":', start);
    if (start < 0 || end < 0) throw Error('Missing optimized handler');
    const body = s.slice(start + guard.length, end).split('\n').map(l => l ? '    ' + l : l).join('\n');
    s = s.slice(0, start) + '    if enhancementHitHealthBefore == null or enhancementHitVictim.getHealth() < enhancementHitHealthBefore:\n' + body + s.slice(end);
    s = s.replace('min(15, enhancementHitDamage * 0.25)',
        'min(15, (boltNativeDamage if enhancementHitHealthBefore == null else enhancementHitHealthBefore - enhancementHitVictim.getHealth()) * 0.25)')
        .replace('del boltChainTargets[0]', 'boltChainTargets = boltChainTargets.slice(1)')
        .replace('        enhancementHitDamage = eventDamage', '        enhancementHitHealthBefore = null')
        .replace('        enhancementHitVictim = victim\n',
            '        enhancementHitVictim = victim\n        if eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:\n            boltNativeDamage = eventDamage\n');
    f['player_events.opy'] = s;
    f['variables.opy'] += '\n#!define boltNativeDamage tmp0\n';
    return f;
}
const files = baselineSources(currentFiles);
function uniform(f) {
    if (!f['player_events.opy'].includes('enhancementHitHealthBefore == null')) return;
    f['subroutines.opy'] = f['subroutines.opy'].replace('    applyHitEnhancements()\n',
        '    enhancementHitDamage -= enhancementHitVictim.getHealth()\n    applyHitEnhancements()\n');
    f['player_events.opy'] = f['player_events.opy']
        .replace('enhancementHitHealthBefore == null or enhancementHitVictim.getHealth() < enhancementHitHealthBefore', 'enhancementHitDamage > 0')
        .replace('(boltNativeDamage if enhancementHitHealthBefore == null else enhancementHitHealthBefore - enhancementHitVictim.getHealth())', 'enhancementHitDamage')
        .replace('        enhancementHitHealthBefore = null', '        enhancementHitDamage = eventDamage')
        .replace(/        if eventPlayer\.enhancementId == Enhancement\.BOLT_STRIKE:\n(?:            #.*\n)*            boltNativeDamage = eventDamage\n/, '');
    if (!f['variables.opy'].includes('#!define enhancementHitDamage tmp2')) f['variables.opy'] += '\n#!define enhancementHitDamage tmp2\n';
}
function removeFirst(f) {
    f['player_events.opy'] = f['player_events.opy'].replace('boltChainTargets = boltChainTargets.slice(1)',
        'boltChainTargets.remove(boltChainTargets[0])');
}
function deleteFirst(f) {
    f['player_events.opy'] = f['player_events.opy'].replace('boltChainTargets = boltChainTargets.slice(1)', 'del boltChainTargets[0]');
}
function flatten(f) {
    const s = f['player_events.opy'];
    const from = s.indexOf('        if eventPlayer.enhancementId == Enhancement.PYROTECHNIC:');
    const to = s.indexOf('        elif eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:', from);
    if (from < 0 || to < 0) return;
    let block = s.slice(from, to)
        .replace('Enhancement.PYROTECHNIC:\n            if enhancementHitVictim', 'Enhancement.PYROTECHNIC and enhancementHitVictim')
        .replace('Enhancement.OVERCHARGE:\n            if eventPlayer', 'Enhancement.OVERCHARGE and eventPlayer');
    block = block.split('\n').map(l => l.startsWith('                ') ? l.slice(4) : l).join('\n');
    f['player_events.opy'] = s.slice(0, from) + block + s.slice(to);
}
function earlyReturn(f) {
    let s = f['player_events.opy'];
    const start = s.indexOf('    if enhancementHitDamage > 0:');
    const end = s.indexOf('\n\n\nrule "CROWD CONTROL STATUS":', start);
    if (start < 0 || end < 0) return;
    const body = s.slice(start, end).split('\n').slice(1).map(l => l.startsWith('    ') ? l.slice(4) : l).join('\n');
    f['player_events.opy'] = s.slice(0, start) + '    if enhancementHitDamage <= 0:\n        return\n' + body + s.slice(end);
}
const variants = {
    uniform: [uniform], removeFirst: [removeFirst], deleteFirst: [deleteFirst], flatten: [flatten],
    uniformRemove: [uniform, removeFirst], uniformDelete: [uniform, deleteFirst],
    uniformFlatten: [uniform, flatten], uniformEarly: [uniform, earlyReturn],
    uniformDeleteEarly: [uniform, deleteFirst, earlyReturn],
    combined: [uniform, removeFirst, flatten, earlyReturn]
};
if (require.main === module) (async () => {
    await compiler.readyPromise;
    const baseline = await compile(files);
    if (process.argv.includes('--snapshot')) fs.writeFileSync('analysis/2026-11-13-hit-optimization-before.json', JSON.stringify(baseline));
    console.log(JSON.stringify({variant: 'baseline', elements: baseline.elements, warnings: baseline.warnings.length}));
    for (const [name, steps] of Object.entries(variants)) {
        const candidate = {...files}; steps.forEach(fn => fn(candidate));
        const build = await compile(candidate);
        console.log(JSON.stringify({variant: name, elements: build.elements, saved: baseline.elements - build.elements, warnings: build.warnings.length}));
    }
})().catch(e => {console.error(e); process.exitCode = 1;});
module.exports = {uniform, removeFirst, deleteFirst, flatten, earlyReturn};
