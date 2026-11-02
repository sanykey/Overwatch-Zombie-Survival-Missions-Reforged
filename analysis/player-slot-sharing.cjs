// Storage ownership, reviewed against e83b831. Names in gameplay remain role aliases.
const assert = require('node:assert/strict');
const historical = require('./player-variable-layout.cjs');
const baselineRef = 'e83b831b2e182e0e6bc7fff6e0dad80946e556e8';
const team2 = historical.variables.filter(v => v.group === 'bots' &&
    !['botBiteDamage', 'botBaseHealth'].includes(v.name)).map(v => v.name);
const team1 = historical.variables.filter(v => v.group === 'powerups').map(v => v.name).concat([
    'enhancementStateSlot1', 'enhancementStateSlot2', 'enhancementStateSlot3',
    'enhancementStateSlot4', 'enhancementPositionSlot', 'enhancementStateSlot6', 'enhancementBarrierHealth'
]);
assert.equal(team2.length, 29);
assert.equal(team1.length, team2.length);
const sets = team2.map((bot, i) => ({name: 'actorTeamSlot' + i, members: [bot, team1[i]],
    description: 'Team 2: ' + bot + '; Team 1: ' + team1[i] + '. Receivers, not rule teams, own the storage.'}));
// First join phases/actor kinds, then join their resulting storage with Team 2.
sets.find(s => s.members.includes('powerUpTradeDataList')).members.push('pregameVoteList', 'rescuePathList');
sets.find(s => s.members.includes('powerUpTradeDataList')).description =
    'Team 2 teleport flag; Team 1 human votes -> item trade data, or Rescue dummy path. Late vote writers are phase-guarded; trade indices 0 and 2 are assigned before reading.';
sets.push({name: 'team1PositionSlot', members: ['team1PositionSlot', 'extractionDestination'],
    description: 'Pregame position -> final extraction destination on humans; Rescue NPC path origin on its own actor. No chase owns this slot.'});
sets.push({name: 'objectiveActorKindSlot', members: ['biomorphingResourceType', 'rescueMoodIcon'],
    description: 'Biomorphing resource type on both teams, or Rescue NPC mood. Goal writers recheck the objective after waits; Rescue completes only after its dummy is destroyed.'});
const mapping = Object.fromEntries(sets.flatMap(s => s.members.map(m => [m, s.name])));
const consumed = new Set(sets.flatMap(s => s.members));
const variables = historical.variables.filter(v => !consumed.has(v.name)).concat(sets.map(s => ({
    old: s.members.join(' / '), name: s.name, group: 'shared', type: 'mixed', description: s.description,
    aliases: s.members.flatMap(name => {
        const v = historical.variables.find(v => v.name === name);
        assert(v, name);
        return v.aliases.length ? v.aliases : [{name: v.name, type: v.type, description: v.description}];
    })
})));
assert.equal(variables.length, 74);

function declarations() {
    const lines = ['# Player variables', '',
        '# Gameplay uses role aliases; neutral slots describe storage.',
        '# Team-exclusive sharing is per receiver: never write a bot role on Team 1 or a player role on Team 2.',
        '# Votes -> trade data on humans; Rescue path lives on a separate Team 1 dummy.',
        '# END VOTING aborts after the phase boundary; all pregame visuals are destroyed before runtime.',
        '# Keep pregameState for late joins, botBaseHealth for unscoped Kill Zone reads,',
        '# and botBiteDamage for the shared explosion helper. Keep default-only reads on both teams separate.', ''];
    for (const [group, title] of Object.entries(historical.groups)) {
        lines.push('# ' + title + '.');
        for (const v of variables.filter(v => v.group === group)) {
            lines.push('playervar ' + v.name + '  # ' + v.description);
            for (const a of v.aliases) lines.push('# ' + a.description, '#!define ' + a.name + ' ' + v.name);
            lines.push('');
        }
    }
    return lines.join('\n');
}

function guardMenu(f) {
    const file = 'global_start_menu.opy';
    const old = '    waitUntil(not isVoting, 99999)\n';
    assert(f[file].includes(old), 'Missing END VOTING handoff');
    f[file] = f[file].replace(old,
        '    waitUntil(not isVoting or not isPregameSetup, 99999)\n' +
        '    # Votes share runtime trade/path storage; a resumed menu writer must not touch it.\n' +
        '    if not isPregameSetup:\n        return\n');
    const playerFile = 'player_start_menu.opy';
    const condition = '        if isVoting and (eventPlayer.pregameVoteList.slice';
    assert(f[playerFile].includes(condition));
    // The five-second hint wait may resume after the menu has gone away.
    f[playerFile] = f[playerFile].replace(condition,
        '        if not isPregameSetup:\n            return\n' + condition);
    return f;
}

function guardObjective(f) {
    const file = 'objective_types/objective_type_biomorphing.opy';
    const guard = '    # The resource-type slot belongs to the Rescue NPC after an objective transition.\n' +
        '    if objectiveTypeList[0] != ObjectiveType.BIOMORPHING:\n        return\n';
    const ruleStart = f[file].indexOf('rule "BIOMORPHING GOAL START":\n');
    assert(ruleStart >= 0);
    const prefix = f[file].slice(0, ruleStart);
    const nextRule = f[file].indexOf('\nrule ', ruleStart + 1);
    assert(nextRule > ruleStart);
    let rule = f[file].slice(ruleStart, nextRule);
    const suffix = f[file].slice(nextRule);
    for (const anchor of ['\n    biomorphingQueuedTypeList = random.shuffle([0, 1, 2])\n',
        '\n    if biomorphingGoalQueueList[0] == 0:\n']) {
        assert(rule.includes(anchor));
        rule = rule.replace(anchor, '\n' + guard + anchor.slice(1));
    }
    f[file] = prefix + rule + suffix;
    return f;
}

function apply(f) {
    guardMenu(f);
    guardObjective(f);
    f['variables.opy'] = f['variables.opy'].split('# Player variables\n')[0] + declarations();
    return f;
}
module.exports = {baselineRef, sets, mapping, variables, groups: historical.groups, declarations, guardMenu, guardObjective, apply};
