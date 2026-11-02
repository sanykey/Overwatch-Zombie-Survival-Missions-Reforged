// Compile proposals in memory; never write src/ or the Workshop export.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler, src, replace, editBlock} = require('./measure-further-optimizations.cjs');
function everywhere(f, before, after) {
    let count = 0;
    for (const name of Object.keys(f)) {
        count += f[name].split(before).length - 1;
        f[name] = f[name].replaceAll(before, after);
    }
    assert(count > 0, before);
    return count;
}
function entityFields(f, hotOnly = false) {
    const uses = {};
    for (const [name,s] of Object.entries(f)) if (name !== 'variables.opy')
        for (const m of s.matchAll(/\.powerUpEntityIdList\[PowerUpEntitySlot\.(\w+)\]/g))
            uses[m[1]] = (uses[m[1]] || 0) + 1;
    const names = Object.keys(uses).filter(n => !/^SENTRY_TURRET_(BODY|LEG_\d|BARREL)$/.test(n) && (!hotOnly || uses[n] >= 4));
    names.forEach((n,i) => {
        const field = 'probeItemEntity' + i;
        everywhere(f, `.powerUpEntityIdList[PowerUpEntitySlot.${n}]`, '.' + field);
        f['variables.opy'] += `\nplayervar ${field}\n`;
    });
    return {fields: names, addedPlayerSlots: names.length, retainedTurretLoop: true};
}
const variants = {
    entity_fields: f => entityFields(f),
    hot_entity_fields: f => entityFields(f, true),
    item_hud_format(f) {
        const s = f['power_ups.opy'];
        const start = s.indexOf('            [\n                "Hold [{0}] to stop');
        assert(start >= 0);
        const marker = '            ][evalOnce(powerUpHudItemIndex)],';
        const end = s.indexOf(marker, start) + marker.length;
        const block = s.slice(start, end);
        const templates = [...block.matchAll(/"([^"\n]*)"/g)].map(m => m[1]);
        assert.equal(templates.length, 13);
        const suffixes = templates.map(t => t.slice(t.indexOf('] ') + 2));
        for (const binding of ['F', 'Mouse 4', 'Interact'])
            assert.deepEqual(templates.map(t => t.replace('{0}', binding)), suffixes.map((t,i) =>
                `${i === 1 ? 'Look at a teammate and hold' : 'Hold'} [${binding}] ${t}`));
        replace(f, 'power_ups.opy', block,
            '            "{0} [{1}] {2}".format("Look at a teammate and hold" if evalOnce(powerUpHudItemIndex) == 1 else "Hold", inputBindingString(Button.INTERACT), [\n' +
            suffixes.map(t => '                ' + JSON.stringify(t)).join(',\n') + '\n            ][evalOnce(powerUpHudItemIndex)]),');
        return {exactTextCasesChecked: 39, hudObjects: 13};
    },
    bounce_pad_batch(f) {
        const s = f['supply_drops.opy'];
        const start = s.indexOf('            #For each bouncer');
        const end = s.indexOf('            playEffect(bouncePadSurvivorList', start);
        assert(start >= 0 && end > start);
        replace(f, 'supply_drops.opy', s.slice(start, end),
            '            bouncePadSurvivorList.applyImpulse(Vector.UP, 22, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)\n');
        return {waitsRemoved: 0, commonDirectionAndStrength: true};
    },
    objective_cleanup_id(f) {
        editBlock(f, 'subroutines.opy', 'macro globalObjectiveEntityManagementMacro():', b => {
            const expr = 'objectiveEntityIdList[objectiveVisualCleanupIndex]';
            assert.equal(b.split(expr).length - 1, 6);
            b = b.replaceAll(expr, 'probeCleanupId');
            return b.replace('    for objectiveVisualCleanupIndex in range(len(objectiveEntityIdList)):\n',
                '    #!define probeCleanupId tmp0\n    for objectiveVisualCleanupIndex in range(len(objectiveEntityIdList)):\n        probeCleanupId = ' + expr + '\n');
        });
        return {scratch: 'tmp0', readsBeforeWait: 6};
    },
    average_target_loop(f) {
        editBlock(f, 'bots_game_in_progress.opy', 'def locateAveragePlayerLocation():', b => {
            const start = b.indexOf('    if len(objectivePlayerList)');
            assert(start >= 0);
            return b.slice(0, start) +
                '    #!define probeAverageTargets tmp1\n' +
                '    #!define averageTargetPositionIndex tmp0\n' +
                '    if len(objectivePlayerList) == 0 and playerTargetList.any(lambda x: x.getThrottle() != vect(0, 0, 0)):\n' +
                '        probeAverageTargets = playerTargetList.filter(lambda x: x.getThrottle() != vect(0, 0, 0))\n' +
                '    else:\n        probeAverageTargets = playerTargetList\n' +
                '    for averageTargetPositionIndex in range(len(probeAverageTargets)):\n' +
                '        eventPlayer.botTeleportCenter += probeAverageTargets[averageTargetPositionIndex].getPosition()\n' +
                '    eventPlayer.botTeleportCenter /= averageTargetPositionIndex\n\n\n';
        });
        return {scratch: 'tmp1', waitsInBlock: 0, sameAccumulationOrder: true};
    },
    satellite_repair_count(f) {
        editBlock(f, 'objective_types/objective_type_satellite_uplink.opy', 'rule "PLAYERS REPAIR TERMINALS":', b => {
            const predicate = 'lambda x: distance(satelliteTerminalPositionList[satelliteRepairTerminalIndex], x.getPosition()) < objectiveRad';
            b = b.replace('    for satelliteRepairTerminalIndex', '    #!define probeRepairCount tmp1\n    for satelliteRepairTerminalIndex');
            const line = `            if objectivePlayerList.any(${predicate}):`;
            assert(b.includes(line));
            return b.replace(line, `            probeRepairCount = len(objectivePlayerList.filter(${predicate}))\n            if probeRepairCount > 0:`)
                .replace(`len(objectivePlayerList.filter(${predicate})) > 1`, 'probeRepairCount > 1');
        });
        return {scratch: 'tmp1', countPerTerminal: 1, waitsBeforeCountConsumption: 0};
    },
    ground_item_lookup(f) {
        editBlock(f, 'power_ups.opy', 'macro powerUpAssignmentMacro():', b => {
            const expr = 'supplyPowerUpIdList[len(supplyPowerUpEffectIdList)]';
            assert.equal(b.split(expr).length - 1, 4);
            b = b.replaceAll(expr, 'probeGroundItemId');
            return b.replace('    if probeGroundItemId', '    #!define probeGroundItemId tmp0\n    probeGroundItemId = ' + expr + '\n    if probeGroundItemId');
        });
        return {scratch: 'tmp0', waitsInBlock: 0, originalPositionIndicesPreserved: true};
    },
};
async function main() {
    const exportBefore = fs.readFileSync(path.join(src, 'main.ws.txt'));
    await compiler.readyPromise;
    const baseline = await compile(files);
    const count = f => {
        const all = Object.values(f).join('\n');
        return {globalVariables: (all.match(/^globalvar /gm) || []).length,
            playerVariables: (all.match(/^playervar /gm) || []).length};
    };
    const report = {baselineRef: require('node:child_process').execFileSync('git', ['rev-parse', 'HEAD'], {encoding:'utf8'}).trim(),
        baseline: {elements: baseline.elements, ...count(files)}, srcChanged: false,
        inGameValidated: false, runtimeBenchmarked: false, candidates: [], combinations: [],
        sourceSha256: Object.fromEntries(Object.entries(files).map(([n,s]) => [n, crypto.createHash('sha256').update(s).digest('hex')]))};
    console.log(JSON.stringify({baseline: report.baseline}));
    for (const [name, transform] of Object.entries(variants)) {
        const f = {...files};
        try {
            const detail = transform(f), r = await compile(f);
            const row = {name, elements: r.elements, saved: baseline.elements-r.elements, ...count(f), detail, emittedWarnings: r.warnings.length};
            report.candidates.push(row); console.log(JSON.stringify(row));
        } catch (e) {report.candidates.push({name,error:e.message}); console.log(name, e.message);}
    }
    for (const fieldVariant of [null, 'entity_fields', 'hot_entity_fields']) {
        const choices = [fieldVariant, 'item_hud_format', 'bounce_pad_batch', 'objective_cleanup_id', 'average_target_loop', 'satellite_repair_count', 'ground_item_lookup'].filter(Boolean);
        const f = {...files};
        for (const choice of choices) variants[choice](f);
        const r = await compile(f);
        const row = {choices, elements:r.elements, saved:baseline.elements-r.elements, ...count(f)};
        report.combinations.push(row);console.log(JSON.stringify(row));
    }
    for (const [name,s] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src,name),'utf8').replace(/\r\n/g,'\n'),s, 'src changed: '+name);
    assert.deepEqual(fs.readFileSync(path.join(src, 'main.ws.txt')), exportBefore, 'Workshop export changed');
    fs.writeFileSync(path.join(__dirname,'additional-elements-probes-2026-11-02.json'), JSON.stringify(report,null,2)+'\n');
}
module.exports = {variants};
if (require.main === module) main().catch(e => {console.error(e);process.exitCode=1;});
