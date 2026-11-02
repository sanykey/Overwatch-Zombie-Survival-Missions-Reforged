// Phase ownership for objective-head caches. These are persistent slots, never scratch.
const assert = require('node:assert/strict');
const edits = [
    ['variables.opy',
        'globalvar phaseSlot10  # Menu spacing/readiness (0 -> 40) -> Biomorphing goal color (goal rule/HUD/announcement).\n' +
        '# global_start_menu.opy guards its final angle write with isPregameSetup, including after scene-setup waits.\n' +
        '# START GAME restores null after menu cleanup, before the first Biomorphing HUD can read this slot.\n' +
        '#!define startMenuSpacingAngle phaseSlot10\n#!define biomorphingGoalColor phaseSlot10',
        'globalvar phaseSlot10  # Menu spacing/readiness (0 -> 40) -> current objective type.\n' +
        '# Menu values cannot match objective IDs 1-7; START GAME restores the empty queue head before generation.\n' +
        '# The final menu angle writer is phase-guarded, including after scene-setup waits.\n' +
        '#!define startMenuSpacingAngle phaseSlot10\n#!define currentObjectiveType phaseSlot10\n\n' +
        'globalvar phaseSlot11  # Menu scene aim position -> Biomorphing goal color.\n' +
        '# Scene writers abort after every wait when the menu ends; START GAME restores null after visual cleanup.\n' +
        '#!define startPos phaseSlot11\n#!define biomorphingGoalColor phaseSlot11\n\n' +
        'globalvar phaseSlot12  # Menu camera position -> current objective position, including moving eggs.\n' +
        '# START GAME stops cameras, removes menu visuals and restores the empty queue head before generation.\n' +
        '# Delayed menu readers/writers abort after waits before accessing the new role.\n' +
        '#!define startCamPos phaseSlot12\n#!define currentObjectivePosition phaseSlot12'],
    ['variables.opy',
        '# Pregame scene. Palettes, votes, enhancement icons and glitch state use phase aliases above.\n' +
        'globalvar startPos                       # Center/aim position of the pregame hero-selection scene.\n' +
        'globalvar startCamPos                    # Pregame camera position used to place players and world text.\n\n',
        '# Pregame scene coordinates use phase aliases above.\n\n'],
    ['variables.opy',
        'globalvar currentObjectiveType           # Mirrors objectiveTypeList[0], including an empty queue.\n' +
        'globalvar currentObjectivePosition       # Mirrors objectivePositionList[0]; egg damage also updates this cache.',
        '# currentObjectiveType/currentObjectivePosition use phaseSlot10/phaseSlot12 above.\n' +
        '# During the menu, type predicates still see a non-objective ID (0 or 40); after cleanup both mirror their queue heads.'],
    ['global_startup.opy', '    destroyAllInWorldTexts()\n',
        '    destroyAllInWorldTexts()\n' +
        '    # Retire all live camera readers before publishing mission values into menu storage.\n' +
        '    getPlayers(Team.1).stopCamera()\n' +
        '    currentObjectiveType = objectiveTypeList[0]\n' +
        '    currentObjectivePosition = objectivePositionList[0]\n'],
    ['global_startup.opy',
        "    # The menu angle writer is phase-guarded; preserve the color's original value before the first biogoal.",
        "    # Scene writers abort after the phase boundary; preserve the color's original value before the first biogoal."],
];
const guard = indent => `${indent}# Shared menu storage changes owners at START GAME.\n${indent}if not isPregameSetup:\n${indent}    return\n`;
const rules = [
    ['global_start_menu.opy', 'GLOBAL MENU INITIALIZATION', 3],
    ['player_start_menu.opy', 'PLAYER SELECTS/RESELECTS HERO', 1],
];
function changeBlock(source, name, fn) {
    const begin = source.indexOf(`rule "${name}":`);
    assert(begin >= 0, name);
    const next = source.indexOf('\n\nrule ', begin + 1);
    const end = next < 0 ? source.length : next;
    return source.slice(0, begin) + fn(source.slice(begin, end)) + source.slice(end);
}
function apply(sources) {
    const result = {...sources};
    for (const [file, before, after] of edits) {
        assert.equal(result[file].split(before).length - 1, 1, `${file}: missing/duplicate sharing anchor`);
        result[file] = result[file].replace(before, after);
    }
    for (const [file, name, expected] of rules) {
        result[file] = changeBlock(result[file], name, block => {
            let count = 0;
            // The player rule reads the camera position only after its first plain wait.
            block = block.replace(/^( *)wait\(\)\n/gm, (line, indent) => {
                if (file === 'player_start_menu.opy' && count >= 1) return line;
                count++;
                return line + guard(indent);
            });
            assert.equal(count, expected, `${name}: wait layout changed`);
            return block;
        });
    }
    return result;
}
function unshare(sources) {
    const result = {...sources};
    for (const [file, name, expected] of rules) {
        result[file] = changeBlock(result[file], name, block => {
            let count = 0;
            block = block.replace(/^( *)# Shared menu storage changes owners at START GAME\.\n\1if not isPregameSetup:\n\1    return\n/gm,
                () => {count++; return '';});
            assert.equal(count, expected, `${name}: missing phase guard`);
            return block;
        });
    }
    for (const [file, before, after] of [...edits].reverse()) {
        assert.equal(result[file].split(after).length - 1, 1, `${file}: sharing layout changed`);
        result[file] = result[file].replace(after, before);
    }
    return result;
}
function audit(sources) {
    assert.deepEqual(apply(unshare(sources)), sources, 'Unexpected sharing changes');
    const all = Object.values(sources).join('\n');
    const declarations = [...all.matchAll(/^globalvar (\w+)/gm)].map(m => m[1]);
    assert.equal(declarations.length, 99);
    for (const role of ['currentObjectiveType', 'currentObjectivePosition', 'startPos', 'startCamPos']) {
        assert(!declarations.includes(role), role + ' must use a phase alias');
    }
    const menu = sources['global_start_menu.opy'];
    assert.equal((all.match(/^ *startMenuSpacingAngle = .+$/gm) || []).length, 1);
    assert(menu.includes('    if isPregameSetup:\n        startMenuSpacingAngle = 40\n'));
    // All live menu-time type predicates must remain false for both old Null and the menu sentinel 40.
    const conditions = [...all.matchAll(/^ *\@Condition .*\bcurrentObjectiveType\b.*$/gm)].map(m => m[0]);
    for (const condition of conditions) {
        assert.match(condition, /currentObjectiveType (?:==|!=) ObjectiveType\.(?:SHOWDOWN|BOSSES|BIOMORPHING|SURVIVOR_RESCUE|KILL_ZONE|ZOMBIE_EGG|SATELLITE_UPLINK)$/);
    }
    const start = sources['global_startup.opy'].split('rule "START GAME":')[1];
    const boundary = start.indexOf('isPregameSetup = false');
    const cleanup = start.indexOf('destroyAllInWorldTexts()');
    const camera = start.indexOf('getPlayers(Team.1).stopCamera()');
    const first = start.indexOf('currentObjectiveType = objectiveTypeList[0]');
    const second = start.indexOf('currentObjectivePosition = objectivePositionList[0]');
    const color = start.indexOf('biomorphingGoalColor = null');
    assert(boundary >= 0 && boundary < cleanup && cleanup < camera && camera < first && first < second && second < color);
    assert(!/\b(?:wait|waitUntil|startRule)\(/.test(start.slice(boundary, color)));
    return {globals: 99, phaseGuards: 4, typeMenuSentinels: [0, 40],
        slots: {phaseSlot10: ['startMenuSpacingAngle', 'currentObjectiveType'],
            phaseSlot11: ['startPos', 'biomorphingGoalColor'],
            phaseSlot12: ['startCamPos', 'currentObjectivePosition']}};
}
const mapping = {startMenuSpacingAngle: 'phaseSlot10', currentObjectiveType: 'phaseSlot10',
    startPos: 'phaseSlot11', biomorphingGoalColor: 'phaseSlot11',
    startCamPos: 'phaseSlot12', currentObjectivePosition: 'phaseSlot12'};
function separateStorage(sources) {
    const result = {...sources};
    result['variables.opy'] = result['variables.opy']
        .replace(/^globalvar phaseSlot(?:10|11|12)\b[^\n]*\n/gm, '')
        .replace(/^#!define (\w+) phaseSlot(?:10|11|12)$/gm, (_, role) => {
            assert(role in mapping);
            return `globalvar ${role}`;
        });
    return result;
}
function compiledRules(workshop, map = {}) {
    return [...workshop.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => ({name,
        body: body.split('\n').filter(line => !/^\s*(?:"|\/\/)/.test(line))
            .map(line => line.replace(/;\s*\/\/.*$/, ';').trim()).filter(Boolean).join('\n')
            .replace(/\bGlobal\.(\w+)/g, (_, role) => 'Global.' + (map[role] ?? role))
            .replace(/\b((?:Set|Modify|For|Chase|Stop Chasing) Global Variable[^\n(]*\()(\w+)/g,
                (_, action, role) => action + (map[role] ?? role))}));
}
module.exports = {apply, unshare, audit, separateStorage, compiledRules, mapping};
