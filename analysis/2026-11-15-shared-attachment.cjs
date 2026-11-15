// Compile candidates in memory; only --apply writes the chosen source and export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');
const refIndex = process.argv.indexOf('--source-ref');
const sourceRef = refIndex < 0 ? null : process.argv[refIndex + 1];
if (refIndex >= 0) {
    assert(sourceRef, '--source-ref needs a Git revision');
    for (const name of Object.keys(files)) files[name] = execFileSync('git',
        ['show', `${sourceRef}:src/${name === 'main.opy' ? 'includes.opy' : name}`],
        {cwd: root}).toString('utf8').replace(/\r\n/g, '\n');
}

function sharedAttach(f) {
    const sites = [
        ['enhancements.opy', 'livingProjectileCandidate', 'eventPlayer', 'vect(0, 1.5, 1)'],
        ['zombie_types.opy', 'eventPlayer.botAbilityTarget', 'eventPlayer', 'vect(0, 3 if eventPlayer in bossStateList else 0, 1)'],
        ['zombie_types.opy', 'eventPlayer.botAbilityTarget', 'eventPlayer', 'vect(0, 0.65 * eventPlayer.sizeScale, 0.5 * eventPlayer.sizeScale)'],
        ['enhancements.opy', 'eventPlayer', 'eventPlayer.enhancementHitchhikerCarrier', 'evalOnce(hitchhikerLocalAttachmentOffset)'],
    ];
    for (const [file, target, carrier, offset] of sites) {
        const indent = target === 'eventPlayer' ? '            ' : '    ';
        // Capture offset first: Hitchhiker's offset and Wrestler's target alias tmp0.
        replace(f, file, `${indent}${target}.attachTo(${carrier}, ${offset})`,
            `${indent}tmp2 = ${offset.replace('evalOnce(hitchhikerLocalAttachmentOffset)', 'hitchhikerLocalAttachmentOffset')}\n${indent}tmp1 = ${carrier}\n${indent}tmp0 = ${target}\n${indent}attachActor()`);
    }
    f['subroutines.opy'] = 'subroutine attachActor\n' + f['subroutines.opy'];
    f['subroutines.opy'] += '\n\ndef attachActor():\n    tmp0.attachTo(tmp1, evalOnce(tmp2))\n';
}

function sharedTargetDetach(f) {
    let count = 0;
    for (const file of ['zombie_types.opy', 'subroutines.opy']) {
        f[file] = f[file].replace(/^( *)eventPlayer\.botAbilityTarget\.detach\(\)$/gm, (_, indent) => {
            count++;
            return indent + 'detachAbilityTarget()';
        });
    }
    assert.equal(count, 5);
    f['subroutines.opy'] = f['subroutines.opy'].replace('#!mainFile "../main.opy"\n', '#!mainFile "../main.opy"\nsubroutine detachAbilityTarget\n');
    f['subroutines.opy'] += '\n\ndef detachAbilityTarget():\n    @Name "detachAbilityTarget"\n    # Synchronous; reads the caller-owned target without changing it or yielding.\n    eventPlayer.botAbilityTarget.detach()\n';
}

function sharedAllDetach(f) {
    let count = 0;
    for (const file of ['zombie_types.opy', 'subroutines.opy', 'enhancements.opy']) {
        f[file] = f[file].replace(/^( *)(eventPlayer(?:\.botAbilityTarget)?)\.detach\(\)$/gm, (_, indent, actor) => {
            count++;
            return `${indent}tmp2 = ${actor}\n${indent}detachActor()`;
        });
    }
    assert(count >= 7);
    f['subroutines.opy'] = 'subroutine detachActor\n' + f['subroutines.opy'];
    f['subroutines.opy'] += '\n\ndef detachActor():\n    tmp2.detach()\n';
}

function sigmaStopFacing(f) {
    const line = '        eventPlayer.botAbilityTarget.stopFacing()\n';
    const start = f['zombie_types.opy'].indexOf('rule "DOWNFALLEN GRABS PLAYER":');
    const end = f['zombie_types.opy'].indexOf('\nrule ', start + 1);
    const block = f['zombie_types.opy'].slice(start, end);
    assert.equal(block.split(line).length - 1, 2);
    const next = block.replaceAll(line, '').replace('    # A recent interruption',
        '    # Facing ends on both interruption and throw, without a wait in between.\n    eventPlayer.botAbilityTarget.stopFacing()\n    # A recent interruption');
    f['zombie_types.opy'] = f['zombie_types.opy'].slice(0, start) + next + f['zombie_types.opy'].slice(end);
}

(async () => {
    await compiler.readyPromise;
    const before = await compile(files);
    assert.deepEqual(before.warnings, []);
    const variants = [];
    for (const [name, transforms] of [
        // A size-only lower bound: captures offsets instead of preserving the
        // live size-dependent Sigma/Illari offsets. Never apply this candidate.
        ['shared-attachment-four-mechanics-snapshot-only', [sharedAttach]],
        ['shared-detach-all-actors', [sharedAllDetach]],
        ['shared-sigma-illari-detach', [sharedTargetDetach]],
        ['shared-sigma-illari-detach-and-facing', [sharedTargetDetach, sigmaStopFacing]],
    ]) {
        const candidate = {...files};
        transforms.forEach(fn => fn(candidate));
        const after = await compile(candidate);
        assert.deepEqual(after.warnings, []);
        variants.push({name, elements: after.elements, delta: after.elements - before.elements});
    }
    const selected = {...files};
    sharedTargetDetach(selected);
    sigmaStopFacing(selected);
    const after = await compile(selected);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const existingRules = newRules.filter(r => r.name !== 'detachAbilityTarget');
    const changedRules = existingRules.filter((r, i) => {
        assert.equal(r.name, oldRules[i].name);
        return r.body !== oldRules[i].body;
    }).map(r => r.name);
    assert.deepEqual(changedRules, ["DAYTAKER'S REVENGE (BOSS)", 'DOWNFALLEN GRABS PLAYER', 'DAYTAKER (ILLARI) BURST']);
    // All Wrestler and Hitchhiker rules, including protection/damage, remain identical.
    assert.equal(newRules.length, oldRules.length + 1);
    assert(after.elements < before.elements);
    const report = {baselineRef: sourceRef ?? execFileSync('git', ['rev-parse', 'HEAD'], {cwd: root}).toString().trim(),
        beforeElements: before.elements, afterElements: after.elements,
        savedElements: before.elements - after.elements, variants, changedRules,
        addedRules: ['detachAbilityTarget'], unchangedRules: oldRules.length - changedRules.length,
        warnings: after.warnings, newVariables: 0,
        runtime: 'Not measured in Overwatch. Shared detach adds one synchronous subroutine call per release; no waits, polling, parameter copies, or new persistent storage. Wrestler and Hitchhiker rules are byte-identical after normalization.'};
    if (process.argv.includes('--apply')) {
        for (const name of Object.keys(selected)) if (selected[name] !== files[name]) {
            fs.writeFileSync(path.join(root, 'src', name), selected[name].replace(/\n/g, '\r\n'));
        }
        const native = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        assert.deepEqual(native.encounteredWarnings, []);
        assert.equal(native.nbElements, after.elements);
        assert.deepEqual(rules(native.result), newRules);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), native.result);
        report.nativeIncludesMatch = true;
    }
    fs.writeFileSync(path.join(__dirname, '2026-11-15-shared-attachment.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(error => {console.error(error); process.exitCode = 1;});
