// Local semantic names for the three synchronous global scratch slots.
// Directives are intentionally next to their first use, including inside rules/macros.
const assert = require('node:assert/strict');
const specs = [];
const add = (file, header, names, changes = []) => specs.push({file, header, names, changes});
add('bots_game_in_progress.opy', 'rule "BOT DIES":', {tmp0: 'botKillBonusRoll'});
add('bots_game_in_progress.opy', 'def teleportBots():', {tmp0: 'teleportCandidateSpawnPointList'});
add('bots_game_in_progress.opy', 'def locateAveragePlayerLocation():', {tmp0: 'averageTargetPositionIndex'});
add('enhancements.opy', 'rule "LASER BARRICADE BLOCKS ZOMBIES":',
    {tmp0: 'barrierCollisionTargetIndex', tmp1: 'barrierPushReferencePointList', tmp2: 'barrierCollisionTarget'});
add('enhancements.opy', 'rule "PYROTECHNIC APPLIES DAMAGE":', {tmp0: 'pyroBurnTarget', tmp1: 'pyroBurnDamagePerSecond'});
add('enhancements.opy', 'rule "CHARGE BATTERY (USAGE AND COOLDOWNS)":', {tmp0: 'batteryChargeRecipient'});
add('enhancements.opy', 'rule "HITCHHIKER ATTACH/DETATCH":', {tmp0: 'hitchhikerWorldAttachmentPosition'},
    [['# tmp0: convert the attachment position', 'tmp0', 'hitchhikerLocalAttachmentOffset']]);
add('enhancements.opy', 'rule "HITCHHIKER LIFEBONDS":',
    {tmp0: 'hitchhikerHealthTransferAmount', tmp1: 'hitchhikerHealthRecipient', tmp2: 'hitchhikerHealthDonor'});
add('global_startup.opy', 'macro botHeroRandomizationMacro():',
    {tmp0: 'spawnedBotHeroList', tmp1: 'botSpawnCumulativeWeight', tmp2: 'botSpawnHeroIndex'},
    [['# tmp0: random threshold', 'tmp0', 'botSpawnWeightRoll']]);
add('global_startup.opy', 'rule "VARIABLE ASSIGNMENT":', {tmp0: 'reconnectInitialSlotIndex'});
add('global_startup.opy', 'def generateMapGrid():', {tmp0: 'mapGridCandidatePosition'});
add('global_start_menu.opy', 'rule "GLOBAL MENU INITIALIZATION":', {tmp0: 'menuVisibilityAngleOffset'});
add('global_start_menu.opy', 'rule "SPECIAL EFFECT CONTROLS":', {tmp0: 'menuGlitchMessageChoice'});
add('global_start_menu.opy', 'def determineZombieMode():', {tmp0: 'zombieModeVoteIndex'});
add('global_start_menu.opy', 'def setZombieMode():', {tmp0: 'equalSpawnWeightHeroIndex'});
add('global_start_menu.opy', 'def determineChallenge():', {tmp0: 'challengeVoteIndex', tmp1: 'challengeWeightedVoteSum'},
    [['# tmp1: average difficulty vote', 'tmp1', 'challengeAverageVote']]);
add('global_start_menu.opy', 'def determineObjectiveType():', {tmp0: 'objectiveTypeVoteIndex'});
add('objective_types/objective_type_biomorphing.opy', 'macro biowasteOutputMacro():', {tmp0: 'biowasteOutputType'});
add('objective_types/objective_type_biomorphing.opy', 'macro biowasteAssignmentMacro():',
    {tmp0: 'biowasteOrbType', tmp1: 'biowasteOrbPosition'});
add('objective_types/objective_type_biomorphing.opy', 'rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS":',
    {tmp0: 'biowasteCarrierIndex', tmp1: 'biowasteCarrierCandidateList'}, [
        ['# tmp1: selected zombie', 'tmp1', 'biowasteCarrier'],
        ['        biowasteOutputMacro()', 'tmp0', 'biowasteAssignedType'],
        ['# tmp0: reward-item index', 'tmp0', 'biomorphingRewardItemIndex']
    ]);
add('objective_types/objective_type_biomorphing.opy', 'rule "BIOWASTE IS PICKED UP":',
    {tmp0: 'biowastePickupPosition', tmp1: 'biowastePickupIndex'});
add('objective_types/objective_type_biomorphing.opy', 'rule "PLAYER DELIVERS RESOURCE VALUE":', {tmp0: 'biowasteDepositTimeDivisor'});
add('objective_types/objective_type_biomorphing.opy', 'rule "BIOWASTE MANAGEMENT":',
    {tmp0: 'deferredBiowasteType', tmp1: 'deferredBiowastePosition'});
add('objective_types/objective_type_satellite_uplink.opy', 'macro fireSatelliteMacro():',
    {tmp0: 'satelliteFiringTerminalIndex'}, [
        ['# tmp0: laser light-shaft layer', 'tmp0', 'satelliteLaserShaftLayerIndex'],
        ['# tmp0: laser impact position', 'tmp0', 'satelliteLaserImpactPosition']
    ]);
add('objective_types/objective_type_satellite_uplink.opy', 'rule "SET UP TERMINAL POSITIONS":',
    {tmp0: 'satelliteTerminalCandidatePositionList', tmp1: 'satelliteSpacingTerminalIndex'});
add('objective_types/objective_type_satellite_uplink.opy', 'rule "PLAYERS REPAIR TERMINALS":', {tmp0: 'satelliteRepairTerminalIndex'});
add('objective_types/objective_type_survivor_rescue.opy', 'rule "INITIALIZE SURVIVOR TO BE RESCUED":', {tmp0: 'rescuePathMarkerIndex'});
add('objective_types/objective_type_survivor_rescue.opy', 'rule "DELETE PATH":', {tmp0: 'rescueReachedPathIndex'});
add('player_start_menu.opy', 'def randomActions():', {tmp0: 'pregameEmoteDirection'},
    [['# tmp0: random voice-line direction', 'tmp0', 'pregameVoiceLineDirection']]);
add('power_ups.opy', 'rule "EFFECT/TEXT (PERMANENT)":', {tmp0: 'powerUpHudItemIndex', tmp1: 'powerUpHudColorList'});
add('subroutines.opy', 'macro botStatManagementMacro():', {tmp0: 'botStatHeroIndex'},
    [['# tmp0: normalized damage multiplier', 'tmp0', 'botStatDamageScale']]);
add('subroutines.opy', 'macro mutationsMacro():', {tmp2: 'botMutationOutlineColor'});
add('subroutines.opy', 'macro botEntityManagementMacro():', {tmp0: 'botGasVisualIndex'});
add('subroutines.opy', 'macro globalObjectiveEntityManagementMacro():', {tmp0: 'extractionLightShaftLayerIndex'},
    [['# tmp0: terminal index', 'tmp0', 'satelliteTerminalVisualIndex']]);
add('subroutines.opy', 'def setDifficulty():', {tmp0: 'insanityThrottleHeroIndex'});
add('subroutines.opy', 'def selectTarget():', {tmp0: 'botSelectionCandidateIndex', tmp1: 'botSelectionCandidateList'});
add('subroutines.opy', 'def botRespawnInitialization():', {tmp0: 'minibossPromotionRoll'});
add('supply_drops.opy', 'rule "GENERATE SUPPLY DROPS":',
    {tmp0: 'supplyDropClosestPlayer', tmp1: 'supplyDropCandidatePosition'});
add('supply_drops.opy', 'rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)":',
    {tmp0: 'supplyDropGeneratedItemIndex'}, [['# tmp0: item angle offset', 'tmp0', 'supplyDropItemAngleOffset']]);
add('supply_drops.opy', 'def playerForceField():', {tmp0: 'forceFieldZombieIndex'});
add('supply_drops.opy', 'def airStrike():', {tmp0: 'airStrikeRayStartPosition', tmp1: 'airStrikeAffectedZombieList'},
    [['# tmp0: ground impact position', 'tmp0', 'airStrikeImpactPosition']]);
add('supply_drops.opy', 'def sentryTurret():', {tmp0: 'turretLegVisualIndex'}, [
    ['# tmp0: turret shot', 'tmp0', 'turretShotImpactPosition'],
    ['# tmp0: turret-effect slot', 'tmp0', 'turretCleanupEffectIndex']
]);
add('supply_drops.opy', 'def bouncePad():',
    {tmp0: 'bouncePadSurvivorList', tmp1: 'bouncePadSurvivorIndex', tmp2: 'bouncePadSurvivor'});
add('zombie_types.opy', 'rule "BASIC (REAPER) SHADOW STEP (BOSS)":', {tmp0: 'shadowStepFloatTargetIndex'});
add('zombie_types.opy', 'rule "BEHEMOTH GAS STREAM (BOSS)":', {tmp0: 'behemothGasCloudIndex'});
add('zombie_types.opy', 'rule "ZOMBIES SPAWN AT REIGNITED":', {tmp0: 'reigniteSpawnSource'});
add('zombie_types.opy', 'rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)":', {tmp0: 'slimerFlightTargetIndex'});
add('zombie_types.opy', 'rule "SMOLDER SUPER SLAM":', {tmp0: 'smolderShockwaveTargetIndex'});

const aliases = Object.fromEntries(specs.flatMap(s => [
    ...Object.entries(s.names).map(([slot,name]) => [name,slot]), ...s.changes.map(([,slot,name]) => [name,slot])
]));
function transformBlock(body, spec) {
    const names = {...spec.names}, defined = new Set(), changed = new Set();
    let previous = null;
    const replace = (text, mapping) => text.replace(/\btmp[012]\b/g, slot => mapping[slot] ?? slot);
    return body.split('\n').map(line => {
        for (const [i,[anchor,slot,name]] of spec.changes.entries()) if (line.includes(anchor)) {
            assert(!changed.has(i), 'Ambiguous scratch-role transition: ' + anchor);
            changed.add(i);
            previous = {...names};
            names[slot] = name;
        }
        if (/^\s*#/.test(line)) return replace(line,names);
        let transformed = replace(line,names);
        // At a type/role handoff, keep the previous role name on the assignment RHS.
        const assignment = line.match(/^(\s*tmp[012] = )(.*)$/);
        if (assignment && previous) transformed = replace(assignment[1],names) + replace(assignment[2],previous);
        if (/\btmp[012]\b/.test(line)) previous = null;
        const used = [...transformed.matchAll(/\b[A-Za-z_]\w*\b/g)].map(m => m[0])
            .filter(name => Object.hasOwn(aliases,name) && !defined.has(name));
        const indent = line.match(/^\s*/)[0];
        const directives = [...new Set(used)].map(name => {
            defined.add(name);
            return `${indent}#!define ${name} ${aliases[name]}`;
        });
        return [...directives,transformed].join('\n');
    }).join('\n');
}
function apply(f) {
    for (const spec of specs) {
        const source = f[spec.file], start = source.indexOf(spec.header+'\n');
        assert(start >= 0, 'Missing scratch owner: ' + spec.header);
        const next = source.slice(start+spec.header.length).search(/\n(?:rule |def |macro )/);
        const end = next < 0 ? source.length : start+spec.header.length+next+1;
        const body = source.slice(start,end);
        f[spec.file] = source.slice(0,start) + transformBlock(body,spec) + source.slice(end);
    }
    f['objective_types/objective_type_biomorphing.opy'] = f['objective_types/objective_type_biomorphing.opy']
        .replace('returned synchronously to assign to the holder kept in tmp1.',
            'returned synchronously to assign to the selected holder.');
    f['variables.opy'] = f['variables.opy'].replace('# Shared scratch slots.\n',
        '# Shared scratch slots.\n# Define a semantic #!define alias next to each use; access scratch through that alias.\n');
    return f;
}
function check(f) {
    const found = [];
    for (const [file,source] of Object.entries(f)) {
        const declared = new Set();
        for (const line of source.split('\n')) {
            const directive = line.match(/^\s*#!define (\w+) (tmp[012])\s*$/);
            if (directive) {
                assert(!declared.has(directive[1]), 'Duplicate scratch alias: ' + directive[1]);
                declared.add(directive[1]);
                found.push([directive[1],directive[2]]);
                continue;
            }
            if (/^\s*#|^globalvar tmp[012]\b/.test(line)) continue;
            const code = line.replace(/"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|#.*$/g,'');
            assert(!/\btmp[012]\b/.test(code), 'Bare scratch slot in ' + file + ': ' + line.trim());
            for (const token of code.match(/\b\w+\b/g) ?? []) if (Object.hasOwn(aliases,token))
                assert(declared.has(token), 'Scratch alias used before its local directive: ' + token);
        }
    }
    assert.deepEqual(found.sort(),Object.entries(aliases).sort());
    return {aliases:found.length,blocks:specs.length};
}
module.exports = {specs,aliases,apply,check};
