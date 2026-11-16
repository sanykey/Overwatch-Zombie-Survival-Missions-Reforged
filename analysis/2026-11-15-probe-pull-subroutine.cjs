const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const baselineRef = '4bae601';
const baseline = {...files};
const changed = ['variables.opy', 'subroutines.opy', 'augments.opy', 'enhancements.opy'];
for (const file of changed) baseline[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
    {encoding: 'utf8'}).replace(/\r\n/g, '\n');

function candidate(cache) {
    const next = {...baseline};
    next['variables.opy'] += '\n# Synchronous selectPullAimTarget contract: tmp0 candidates -> selected player;\n'
        + '# tmp1 maximum range; tmp2/tmp3 overwritten for cached geometry. No waits,\n'
        + '# async calls or reevaluated visuals may retain these scratch values.\n'
        + '#!define pullAimCandidates tmp0\n#!define pullAimTarget tmp0\n#!define pullAimRange tmp1\n'
        + '#!define pullAimEyePosition tmp2\n#!define pullAimOrigin tmp3\n';
    const origin = cache ? 'pullAimOrigin' : 'augmentGrapnelCenter(eventPlayer)';
    const eye = cache ? 'pullAimEyePosition' : 'eventPlayer.getEyePosition()';
    const helper = '\n\ndef selectPullAimTarget():\n    @Name "selectPullAimTarget"\n\n'
        + (cache ? '    pullAimEyePosition = eventPlayer.getEyePosition()\n    pullAimOrigin = (eventPlayer.getPosition() + pullAimEyePosition) * 0.5\n' : '')
        + `    pullAimTarget = sorted(pullAimCandidates.filter(lambda target: distance(${origin}, augmentGrapnelCenter(target)) <= pullAimRange and eventPlayer.isInViewAngle(augmentGrapnelCenter(target), 35) and isInLoS(${origin}, augmentGrapnelCenter(target))), lambda target: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(${eye}, augmentGrapnelCenter(target))))[0]\n`;
    next['subroutines.opy'] = next['subroutines.opy'].replace('subroutine applyHitEnhancements',
        'subroutine selectPullAimTarget\nsubroutine applyHitEnhancements') + helper;
    for (const [file, target, range] of [['augments.opy', 'eventPlayer.augmentGrapnelTarget', 'AUGMENT_GRAPNEL_RANGE'],
        ['enhancements.opy', 'wrestlerPullTarget', 'WRESTLER_PULL_RANGE']]) {
        const line = next[file].split('\n').find(line => line.startsWith(`    ${target} = sorted(getPlayersInRadius(`));
        assert(line);
        const query = line.slice(line.indexOf('getPlayersInRadius('), line.indexOf(` and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(target)) <= ${range}`)) + ')';
        next[file] = next[file].replace(line, `    # Shared selection consumes scratch synchronously; persist/capture its result before waits.\n    pullAimRange = ${range}\n    pullAimCandidates = ${query}\n    selectPullAimTarget()`
            + (target.startsWith('eventPlayer.') ? `\n    ${target} = pullAimTarget` : ''));
    }
    return next;
}

function unifiedCandidate() {
    const next = candidate(true);
    for (const name of ['AUGMENT_GRAPNEL_RANGE', 'AUGMENT_GRAPNEL_MIN_RANGE']) {
        const definition = next['augments.opy'].match(new RegExp(`^#!define ${name} .*\\n`, 'm'))[0];
        next['augments.opy'] = next['augments.opy'].replace(definition, '');
        const anchor = '#!define augmentGrapnelCenter(player) ((player.getPosition() + player.getEyePosition()) * 0.5)';
        next['variables.opy'] = next['variables.opy'].replace(anchor, anchor + '\n' + definition.trimEnd());
    }
    next['variables.opy'] = next['variables.opy'].replace('#!define pullAimRange tmp1',
        '#!define pullAimIsWrestler tmp1\n#!define pullAimRange tmp2')
        .replace('#!define pullAimEyePosition tmp2', '#!define pullAimEyePosition tmp1');
    next['variables.opy'] = next['variables.opy'].replace(
        '# Synchronous selectPullAimTarget contract: tmp0 candidates -> selected player;\n# tmp1 maximum range; tmp2/tmp3 overwritten for cached geometry. No waits,\n# async calls or reevaluated visuals may retain these scratch values.',
        '# Synchronous selectPullAimTarget contract: tmp1 inputs Wrestler mode;\n# tmp0 returns the selected player (or Null), tmp2/tmp3 are clobbered.\n# tmp1 becomes the eye position only after mode-dependent filtering finishes.\n# The helper has no waits or nested calls. Consume/copy the result before waits;\n# reevaluated visuals must use persistent storage or snapshot the result.');
    const contractStart = next['variables.opy'].indexOf('\n# Synchronous selectPullAimTarget contract:');
    const contract = next['variables.opy'].slice(contractStart);
    next['variables.opy'] = next['variables.opy'].slice(0, contractStart).replace(
        '# Phase-owned storage, NOT scratch:', contract + '\n# Phase-owned storage, NOT scratch:');
    const start = next['subroutines.opy'].indexOf('\n\ndef selectPullAimTarget():');
    next['subroutines.opy'] = next['subroutines.opy'].slice(0, start) + `

def selectPullAimTarget():
    @Name "selectPullAimTarget"

    pullAimRange = WRESTLER_PULL_RANGE if pullAimIsWrestler else AUGMENT_GRAPNEL_RANGE
    pullAimCandidates = getPlayersInRadius(eventPlayer.getEyePosition(), pullAimRange + 2, Team.2 if pullAimIsWrestler else Team.ALL, LosCheck.SURFACES).filter(lambda target: target.isAlive() and (target.getTeam() == Team.1 or not target.botIsTeleporting) and (target.isDummy() and not target.botIsInitializing and not target.botIsAttached if pullAimIsWrestler else target != eventPlayer and distance(augmentGrapnelCenter(eventPlayer), augmentGrapnelCenter(target)) >= AUGMENT_GRAPNEL_MIN_RANGE))
    # Mode is dead after candidate filtering; reuse its slot for the eye position.
    pullAimEyePosition = eventPlayer.getEyePosition()
    pullAimOrigin = (eventPlayer.getPosition() + pullAimEyePosition) * 0.5
    pullAimTarget = sorted(pullAimCandidates.filter(lambda target: distance(pullAimOrigin, augmentGrapnelCenter(target)) <= pullAimRange and eventPlayer.isInViewAngle(augmentGrapnelCenter(target), 35) and isInLoS(pullAimOrigin, augmentGrapnelCenter(target))), lambda target: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(pullAimEyePosition, augmentGrapnelCenter(target))))[0]
`;
    for (const [file, range, mode] of [['augments.opy', 'AUGMENT_GRAPNEL_RANGE', 'false'],
        ['enhancements.opy', 'WRESTLER_PULL_RANGE', 'true']]) {
        const lines = next[file].split('\n');
        const start = lines.findIndex(line => line === `    pullAimRange = ${range}`);
        assert(start >= 0);
        lines.splice(start, 2, `    pullAimIsWrestler = ${mode}`);
        next[file] = lines.join('\n');
    }
    return next;
}

async function main() {
    await compiler.readyPromise;
    const before = await compile(baseline);
    const probes = [];
    let best;
    for (const cache of [false, true, 'unified']) {
        const next = cache === 'unified' ? unifiedCandidate() : candidate(cache), build = await compile(next);
        assert.deepEqual(build.warnings, []);
        probes.push({cache, elements: build.elements, delta: build.elements - before.elements});
        if (!best || build.elements < best.build.elements) best = {next, build, cache};
    }
    const report = {baselineRef, beforeElements: before.elements, probes, selectedCache: best.cache};
    fs.writeFileSync(path.join(__dirname, '2026-11-15-pull-subroutine-measurements.json'), JSON.stringify(report, null, 2) + '\n');
    if (process.argv.includes('--apply')) {
        assert(best.build.elements < before.elements);
        for (const file of changed) fs.writeFileSync(require('./source-layout.cjs').sourcePath(file), best.next[file]);
    }
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
