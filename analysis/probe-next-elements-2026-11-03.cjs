// Measure additional source-only variants against the current committed build.
const assert = require('node:assert/strict');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, replace, editBlock, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '89a6192';
const baselineFiles = {...files};
for (const file of ['global_start_menu.opy', 'bots_game_in_progress.opy', 'variables.opy'])
    baselineFiles[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');

const variants = {
    menu_los_point(f) {
        const point = 'startCamPos + -0.75 * Vector.UP + ((directionFromAngles(horizontalAngleOfDirection(directionTowards(startCamPos, startPos)) + menuVisibilityAngleOffset, 0)) * START_CAM_DISTANCE)';
        replace(f, 'global_start_menu.opy',
            `                if not isInLoS(startCamPos, ${point}) or not isInLoS(${point}, startCamPos):`,
            `                #!define menuVisibilityPoint tmp1\n                menuVisibilityPoint = ${point}\n                if not isInLoS(startCamPos, menuVisibilityPoint) or not isInLoS(menuVisibilityPoint, startCamPos):`);
    },
    special_menu_formula(f) {
        replace(f, 'global_start_menu.opy',
            '        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 15 * Vector.UP\n' +
            '        elif getCurrentGamemode() == Gamemode.CONTROL:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 100 * Vector.UP\n' +
            '        else:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 150 + 30 * Vector.UP',
            '        startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * (300 if getCurrentGamemode() in [Gamemode.CTF, Gamemode.PUSH, Gamemode.CONTROL] else 150) + (15 if getCurrentGamemode() in [Gamemode.CTF, Gamemode.PUSH] else 100 if getCurrentGamemode() == Gamemode.CONTROL else 30) * Vector.UP');
    },
    special_menu_values(f) {
        replace(f, 'global_start_menu.opy',
            '        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 15 * Vector.UP\n' +
            '        elif getCurrentGamemode() == Gamemode.CONTROL:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 300 + 100 * Vector.UP\n' +
            '        else:\n' +
            '            startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * 150 + 30 * Vector.UP',
            '        #!define menuRadius tmp1\n        #!define menuHeight tmp2\n' +
            '        if getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH:\n' +
            '            menuRadius = 300\n            menuHeight = 15\n' +
            '        elif getCurrentGamemode() == Gamemode.CONTROL:\n' +
            '            menuRadius = 300\n            menuHeight = 100\n' +
            '        else:\n' +
            '            menuRadius = 150\n            menuHeight = 30\n' +
            '        startPos = walkCenter + directionFromAngles(random.uniform(0, 360), 0) * menuRadius + menuHeight * Vector.UP');
    },
    objective_type_cache_once(f) {
        editBlock(f, 'global_start_menu.opy', 'def setObjectiveType():', block => {
            const line = '            currentObjectiveType = objectiveTypeList[0]\n';
            assert.equal(block.split(line).length - 1, 2);
            return block.replaceAll(line, '').replace('        missionPlacementAttemptCount = 0\n',
                '        currentObjectiveType = objectiveTypeList[0]\n        missionPlacementAttemptCount = 0\n');
        });
    },
    scalar_zero_vectors(f) {
        replace(f, 'global_start_menu.opy', 'missionCandidatePosition + vect(0, 0, 0), missionCandidatePosition + 10 * Vector.UP',
            'missionCandidatePosition, missionCandidatePosition + 10 * Vector.UP');
        replace(f, 'supply_drops.opy', 'supplyDropLandingPosition + vect(0, 0, 0), getAllPlayers()',
            'supplyDropLandingPosition, getAllPlayers()');
    },
    zombie_mode_slice_table(f) {
        editBlock(f, 'global_start_menu.opy', 'def setZombieMode():', block => {
            const start = block.indexOf('    #All Zombies\n');
            const end = block.indexOf('\n\n', block.indexOf('NL_SPAWN_RATES_HAM_N_HAMMER_LEN)', start));
            assert(start >= 0 && end > start);
            const replacement = '    if zombieSetting == 3:\n' +
                '        botSpawnRateList = []\n' +
                '        #!define equalSpawnWeightHeroIndex tmp0\n' +
                '        for equalSpawnWeightHeroIndex in range(19):\n' +
                '            botSpawnRateList.append(5.263)\n' +
                '    elif zombieSetting in [1, 2, 4, 5, 6]:\n' +
                '        botSpawnRateList = numbersList.slice([NL_SPAWN_RATES_ALL_ZOMBIES_OFFSET, NL_SPAWN_RATES_NEW_BLOOD_OFFSET, 0, NL_SPAWN_RATES_SHUFFLE_OFFSET, NL_SPAWN_RATES_DINNER_RUSH_OFFSET, NL_SPAWN_RATES_HAM_N_HAMMER_OFFSET][zombieSetting - 1], [NL_SPAWN_RATES_ALL_ZOMBIES_LEN, NL_SPAWN_RATES_NEW_BLOOD_LEN, 0, NL_SPAWN_RATES_SHUFFLE_LEN, NL_SPAWN_RATES_DINNER_RUSH_LEN, NL_SPAWN_RATES_HAM_N_HAMMER_LEN][zombieSetting - 1])';
            return block.slice(0, start) + replacement + block.slice(end);
        });
    },
    bot_nearest_helper(f) {
        f['bots_game_in_progress.opy'] = f['bots_game_in_progress.opy'].replace('subroutine locateAveragePlayerLocation\n',
            'subroutine locateAveragePlayerLocation\nsubroutine setClosestPlayerTeleportCenter\n');
        const cases = [
            'currentObjectivePosition', 'bossStateList[0].getPosition()',
            'rescueSurvivor.getPosition()', 'killZoneCenter',
        ];
        let changed = 0;
        for (const pivot of cases) {
            const expression = `eventPlayer.botTeleportCenter = sorted(playerTargetList, lambda x: distance(x.getPosition(), ${pivot}))[0].getPosition()`;
            f['bots_game_in_progress.opy'] = f['bots_game_in_progress.opy'].split('\n').map(line => {
                if (line.trim() !== expression) return line;
                changed++;
                const indent = line.match(/^ */)[0];
                return `${indent}botTeleportPivot = ${pivot}\n${indent}setClosestPlayerTeleportCenter()`;
            }).join('\n');
        }
        assert.equal(changed, 5);
        f['bots_game_in_progress.opy'] += '\n\ndef setClosestPlayerTeleportCenter():\n' +
            '    @Name "setClosestPlayerTeleportCenter"\n\n' +
            '    eventPlayer.botTeleportCenter = sorted(playerTargetList, lambda x: distance(x.getPosition(), botTeleportPivot))[0].getPosition()\n';
        f['variables.opy'] += '\n#!define botTeleportPivot tmp1\n';
    },
    bot_nearest_player_field(f) {
        variants.bot_nearest_helper(f);
        f['bots_game_in_progress.opy'] = f['bots_game_in_progress.opy'].replaceAll('botTeleportPivot', 'eventPlayer.botTeleportCenter');
        f['variables.opy'] = f['variables.opy'].replace('\n#!define botTeleportPivot tmp1\n', '');
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(baselineFiles);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const f = {...baselineFiles};
        try {
            transform(f);
            const result = await compile(f);
            console.log(JSON.stringify({name, elements: result.elements, saved: before.elements - result.elements,
                warnings: result.warnings.length}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const menuOnly = {...baselineFiles};
    for (const name of ['menu_los_point', 'special_menu_values', 'objective_type_cache_once',
        'zombie_mode_slice_table']) variants[name](menuOnly);
    const menuBuild = await compile(menuOnly);
    const scratch = checkWorkshop(menuBuild.result);
    console.log(JSON.stringify({name: 'menu_only_scratch_audit', elements: menuBuild.elements,
        saved: before.elements - menuBuild.elements, auditedRules: scratch.length}));
    const selected = ['menu_los_point', 'special_menu_values', 'objective_type_cache_once',
        'zombie_mode_slice_table', 'bot_nearest_helper'];
    const combined = {...baselineFiles};
    for (const name of selected) variants[name](combined);
    const result = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(result.result);
    const helper = newRules.find(row => row.name === 'setClosestPlayerTeleportCenter');
    assert(helper && !/Wait\(|Start Rule\(/.test(helper.body));
    const withoutHelper = newRules.filter(row => row !== helper);
    assert.equal(oldRules.length, withoutHelper.length);
    const changedRules = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(oldRules[i].name, withoutHelper[i].name);
        if (oldRules[i].body !== withoutHelper[i].body) changedRules.push(oldRules[i].name);
    }
    console.log(JSON.stringify({name: 'selected_combined', variants: selected, elements: result.elements,
        saved: before.elements - result.elements, warnings: result.warnings.length,
        oldRulesCompared: oldRules.length, changedRules}));
}
module.exports = {variants, baselineFiles};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
