// Static counterexamples and compiled evidence. Does not execute Overwatch or modify src/.
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

const distance = (a, b) => Math.hypot(...a.map((v, i) => v - b[i]));
const nearest = (items, origin) => [...items].sort((a, b) => distance(a.position, origin) - distance(b.position, origin))[0];

function compiledRule(result, name) {
    const start = result.indexOf(`rule ("${name}")`);
    assert(start >= 0, name);
    const end = result.indexOf('\n}\n', start);
    assert(end > start);
    return result.slice(start, end + 3);
}

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    const evidence = {};

    assert(files['subroutines.opy'].includes('eventPlayer.botTarget = eventPlayer.botCandidateTarget'));
    const selectSource = files['subroutines.opy'].split('def selectTarget():')[1].split('def restoreDefaultFacingMovement():')[0];
    assert(!selectSource.includes('botCandidateTarget = null'));
    // The loop writes the candidate before testing visibility; the target is published afterwards.
    const select = (previous, candidates) => {
        let candidate = previous;
        for (const item of candidates) {
            candidate = item.id;
            if (item.visible) break;
        }
        return candidate;
    };
    evidence.botSelection = {
        noVisibleCandidate: select('previous', [{id: 'A', visible: false}, {id: 'B', visible: false}]),
        emptyCandidates: select('previous', []),
        expectedForVisibleOnlySelection: null,
    };
    assert.equal(evidence.botSelection.noVisibleCandidate, 'B');
    assert.equal(evidence.botSelection.emptyCandidates, 'previous');

    assert(files['enhancements.opy'].includes('batteryChargeRecipient = (getLivingPlayers(Team.1).filter(lambda player: player.hasSpawned() and distance(player, eventPlayer.enhancementBatteryPosition) < 1.5))[0]'));
    const center = [0, 0, 0];
    const batteryPlayers = [
        {id: 'full', position: [0.5, 0, 0], charge: 100, size: 1},
        {id: 'needsCharge', position: [1, 0, 0], charge: 50, size: 1},
    ];
    const batteryGate = items => items.some(p => p.charge < 100 && distance(p.position, center) < 1.5 * p.size);
    const batteryRecipient = items => items.filter(p => distance(p.position, center) < 1.5)[0]?.id ?? null;
    const scaled = [{id: 'large', position: [2, 0, 0], charge: 50, size: 2}];
    evidence.battery = {
        fullChargeFirst: {gate: batteryGate(batteryPlayers), selected: batteryRecipient(batteryPlayers)},
        scaledRecipient: {gate: batteryGate(scaled), selected: batteryRecipient(scaled)},
    };
    assert.deepEqual(evidence.battery.fullChargeFirst, {gate: true, selected: 'full'});
    assert.deepEqual(evidence.battery.scaledRecipient, {gate: true, selected: null});

    const rescueFile = files['objective_types/objective_type_survivor_rescue.opy'];
    assert(rescueFile.includes('sorted(playerTargetList.filter(lambda x: distance(rescueSurvivor, x) < objectiveRad)'));
    assert(rescueFile.includes('playerTargetList.append(rescueSurvivor)'));
    const objective = [100, 0, 0];
    const npc = {id: 'npc', position: [0, 0, 0], invisible: false};
    const human = {id: 'human', position: [-1, 0, 0], invisible: false};
    const rescuePlayers = [human, npc];
    const eligible = rescuePlayers.filter(p => p.id !== npc.id && !p.invisible && distance(p.position, npc.position) < 30);
    const actual = nearest(rescuePlayers.filter(p => distance(p.position, npc.position) < 30), objective);
    evidence.rescue = {eligible: eligible.map(p => p.id), selected: actual.id};
    assert.deepEqual(evidence.rescue, {eligible: ['human'], selected: 'npc'});

    assert(files['objective_types/objective_type_biomorphing.opy'].includes('biowastePickupPosition = sorted(biomorphingResourcePositionList, lambda x: distance(eventPlayer, x))[0]'));
    const feet = [0, 0, 0];
    const eye = [0, 1.6, 0];
    const resources = [{id: 'upperLedge', position: [0, 3.5, 0]}, {id: 'outsideRadius', position: [2.1, 0, 0]}];
    const reachable = resources.filter(p => distance(p.position, feet) < 2 || distance(p.position, eye) < 2);
    const selected = nearest(resources, feet);
    evidence.biowaste = {
        reachable: reachable.map(p => p.id), selected: selected.id,
        distances: resources.map(p => ({id: p.id, feet: distance(p.position, feet), eyes: distance(p.position, eye)})),
    };
    assert.deepEqual(evidence.biowaste.reachable, ['upperLedge']);
    assert.equal(evidence.biowaste.selected, 'outsideRadius');

    const boss = compiledRule(build.result, 'SPAWN BOSS');
    const finale = compiledRule(build.result, 'WIN/LOSS CONDITIONS');
    assert(boss.includes('Not(Value In Array(Global.miniBossList, Current Array Element))'));
    assert(finale.includes('Not(Value In Array(Global.evacSurvivorList, Current Array Element))'));
    evidence.playerIndexInsteadOfMembership = {
        boss: boss.split('\n').filter(line => line.includes('Not(Value In Array(Global.miniBossList')),
        extraction: finale.split('\n').filter(line => line.includes('Not(Value In Array(Global.evacSurvivorList')),
    };

    const names = ['selectTarget', 'BOT TAKES DAMAGE AND SWITCHES TARGETS', 'SURVIVOR FOLLOW TARGET', 'CHARGE BATTERY (USAGE AND COOLDOWNS)', 'BIOWASTE IS PICKED UP', 'SPAWN BOSS', 'WIN/LOSS CONDITIONS'];
    console.log(JSON.stringify({
        elements: build.elements,
        warningsWithExistingSuppressions: build.warnings.length,
        sourceSha256: Object.fromEntries(Object.entries(files).map(([name, source]) =>
            [name, crypto.createHash('sha256').update(source).digest('hex')])),
        evidence,
        compiledRules: Object.fromEntries(names.map(name => [name, compiledRule(build.result, name)])),
        limitation: 'Static counterexamples assume the listed entities and positions. They are not in-game reproductions or runtime performance measurements.',
    }, null, 2));
}

main().catch(error => { console.error(error); process.exitCode = 1; });
