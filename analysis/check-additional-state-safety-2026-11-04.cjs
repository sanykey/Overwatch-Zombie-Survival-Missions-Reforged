// Compile-only evidence and bounded state models. Never runs the game or changes src/.
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

function rule(result, name) {
    const start = result.indexOf(`rule ("${name}")`);
    assert(start >= 0, name);
    const end = result.indexOf('\n}\n', start);
    assert(end > start);
    return result.slice(start, end + 3);
}

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    const names = ['HITCHHIKER ATTACH/DETATCH', 'HITCHHIKER PARENT RECIEVES HEALTH POOL',
        'SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE', 'daytakerAbortReset',
        "DAYTAKER'S REVENGE (BOSS)", 'SLIMER (MERCY) TENTACLE GRAB', 'REVIVE PLAYER OR ADVANCE DEATH TIMER'];
    const compiled = Object.fromEntries(names.map(name => [name, rule(build.result, name)]));

    const hitchSource = files['enhancements.opy'].split('rule "HITCHHIKER ATTACH/DETATCH":')[1]
        .split('rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":')[0];
    assert(hitchSource.includes('any(lambda x: not x.isAttached'));
    const selectedSource = hitchSource.split('eventPlayer.enhancementHitchhikerCarrier = ')[1].split('\n')[0];
    assert(!selectedSource.includes('isAttached'));
    assert(!selectedSource.includes('enhancementHitchhikerPassenger'));
    assert(hitchSource.includes('eventPlayer.enhancementHitchhikerCarrier.enhancementHitchhikerPassenger = null'));
    const carrier = {passenger: null};
    const passengerP = {carrier, attached: true};
    carrier.passenger = passengerP;
    const passengerQ = {carrier, attached: true};
    carrier.passenger = passengerQ;
    const afterSecondAttach = carrier.passenger === passengerQ;
    // Old passenger exits and unconditionally clears the common owner's pointer.
    carrier.passenger = null;
    passengerP.attached = false;
    assert(passengerQ.attached && carrier.passenger === null);
    const graph = new Map([['B', 'A'], ['A', 'B']]);
    const cycleFromA = graph.get(graph.get('A')) === 'A';
    assert(cycleFromA);

    const heldBlock = compiled['SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE'];
    assert(heldBlock.includes('Start Holding Button(Event Player, Button(Ability 2))'));
    assert(!heldBlock.includes('Stop Holding Button'));
    assert(heldBlock.includes('Wait(10'));
    const abort = compiled.daytakerAbortReset;
    assert(!abort.includes('Detach Players('));
    const abortState = {physicallyAttachedTo: 'Illari', attachmentFlag: true};
    abortState.attachmentFlag = false;
    assert(abortState.physicallyAttachedTo && !abortState.attachmentFlag);

    const ultimate = compiled["DAYTAKER'S REVENGE (BOSS)"];
    assert(ultimate.includes('Compare(Event Player, ==, Has Status(Event Player, Hacked))'));
    const ultSource = files['subroutines.opy'].split('def illariUlt():')[1].split('def applyScaledMoveSpeed():')[0];
    const lowerSpeed = ultSource.indexOf('movementSpeedScale /= 3');
    const earlyReturn = ultSource.indexOf('return', lowerSpeed);
    const restoreSpeed = ultSource.indexOf('movementSpeedScale *= 3');
    assert(lowerSpeed >= 0 && earlyReturn > lowerSpeed && earlyReturn < restoreSpeed);

    const slime = files['zombie_types.opy'].split('rule "SLIMER (MERCY) TENTACLE GRAB":')[1]
        .split('rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":')[0];
    assert(slime.includes('isInLoS(eventPlayer.botTentaclePosition, x.getEyePosition()'));
    assert(slime.includes('isInLoS(eventPlayer.botTentaclePosition, eventPlayer.getEyePosition()'));
    const tentacleCandidates = [{id: 'A', visibleFromTentacle: false}, {id: 'B', visibleFromTentacle: true}];
    const hasValidTarget = tentacleCandidates.some(p => p.visibleFromTentacle);
    const casterVisibleFromTentacle = true;
    const actualTarget = tentacleCandidates.filter(() => casterVisibleFromTentacle)[0];
    assert(hasValidTarget && !actualTarget.visibleFromTentacle);

    assert(files['players_game_in_progress.opy'].includes('(extractionZoneRad - distance(eventPlayer, currentObjectivePosition)) / 2.5'));
    assert(files['objective_types/objective_type_extraction_point.opy'].includes('extractionSpeedUp += 0.2 / len(playerTargetList)'));
    const domeExamples = [{margin: 15, rescueTime: 10, speed: 5}, {margin: 5, rescueTime: 10, speed: 5}].map(p => ({
        ...p,
        sourceTimer: p.margin < p.rescueTime ? p.margin / 2.5 : p.rescueTime - 0.5,
        estimatedSecondsUntilDome: p.margin / p.speed,
    }));
    assert.equal(domeExamples[0].sourceTimer, 9.5);
    assert.equal(domeExamples[0].estimatedSecondsUntilDome, 3);
    assert.equal(domeExamples[1].sourceTimer, 2);
    assert.equal(domeExamples[1].estimatedSecondsUntilDome, 1);

    console.log(JSON.stringify({
        date: '2026-11-04',
        sourceSha256: Object.fromEntries(Object.entries(files).map(([name, source]) =>
            [name, crypto.createHash('sha256').update(source).digest('hex')])),
        baseline: {elements: build.elements, warningsWithExistingSuppressions: build.warnings.length},
        hitchhiker: {secondPassengerOverwritesOwner: afterSecondAttach,
            afterFirstPassengerExits: {ownerPointer: carrier.passenger, secondPassengerAttached: passengerQ.attached},
            attemptedAttachmentGraphCanContainCycle: cycleFromA,
            limitation: 'Graph model; actual engine handling of cyclic attachment is untested.'},
        doomfist: {startHoldingBlock: true, stopHoldingInRule: false, waitSeconds: 10},
        daytakerAbort: abortState,
        illariUltimate: {comparesPlayerToBoolean: true, deathReturnBeforeSpeedRestoration: true, resultingSpeedScaleFromOne: 1 / 3},
        tentacle: {hasValidTarget, selectedId: actualTarget.id, selectedTargetVisible: actualTarget.visibleFromTentacle},
        domeExamples,
        compiledRules: compiled,
        limitation: 'Source/compilation checks and bounded counterexamples only. No in-game attachment, damage, death, timer, or crash reproduction.',
    }, null, 2));
}

main().catch(error => { console.error(error); process.exitCode = 1; });
