// Compile further candidates in memory against the 26,188-element source; do not edit src/.
const assert = require('node:assert/strict');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, replace, editBlock, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '4035f37';
const baselineFiles = {...files};
for (const file of ['global_startup.opy', 'global_game_in_progress.opy',
    'objective_types/objective_type_extraction_point.opy', 'global_start_menu.opy',
    'subroutines.opy', 'zombie_types.opy'])
    baselineFiles[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');

const variants = {
    bot_stat_hero_snapshot(f) {
        editBlock(f, 'subroutines.opy', 'macro botStatManagementMacro():', block => {
            const start = block.indexOf('    if eventPlayer.getHero() == Hero.REINHARDT:');
            const end = block.indexOf('\n\n', start);
            assert(start > 0 && end > start);
            const tail = block.slice(start, end);
            const uses = tail.split('eventPlayer.getHero()').length - 1;
            assert(uses >= 9);
            return block.slice(0, start) + '    #!define botStatHero tmp0\n' +
                '    botStatHero = eventPlayer.getHero()\n' +
                tail.replaceAll('eventPlayer.getHero()', 'botStatHero') + block.slice(end);
        });
    },
    bot_entity_hero_snapshot(f) {
        editBlock(f, 'subroutines.opy', 'macro botEntityManagementMacro():', block => {
            const start = block.indexOf('        if eventPlayer.getHero() == Hero.ROADHOG:');
            const end = block.lastIndexOf('\n\n');
            assert(start > 0 && end > start);
            const tail = block.slice(start, end);
            const uses = tail.split('eventPlayer.getHero()').length - 1;
            assert(uses >= 8);
            return block.slice(0, start) + '        #!define botEntityHero tmp1\n' +
                '        botEntityHero = eventPlayer.getHero()\n' +
                tail.replaceAll('eventPlayer.getHero()', 'botEntityHero') + block.slice(end);
        });
    },
    satellite_progress_snapshot(f) {
        editBlock(f, 'objective_types/objective_type_satellite_uplink.opy', 'rule "PLAYERS REPAIR TERMINALS":', block => {
            const first = block.indexOf('        if satelliteTerminalProgressList[satelliteRepairTerminalIndex] < 100:');
            const end = block.indexOf('    #All terminals repaired', first);
            assert(first >= 0 && end > first);
            const old = block.slice(first, end);
            const progress = 'satelliteTerminalProgressList[satelliteRepairTerminalIndex]';
            assert.equal(old.split(progress).length - 1, 5);
            const next = '        #!define satelliteRepairProgress tmp2\n' +
                `        satelliteRepairProgress = ${progress}\n` +
                old.replaceAll(progress, 'satelliteRepairProgress').replace(
                    '                #If terminal is repaired\n',
                    `                ${progress} = satelliteRepairProgress\n                #If terminal is repaired\n`)
                    .replace('                    satelliteRepairProgress = 100\n',
                        `                    ${progress} = 100\n`);
            return block.slice(0, first) + next + block.slice(end);
        });
    },
    winloss_empty_check(f) {
        replace(f, 'objective_types/objective_type_extraction_point.opy',
            'if (len(playerTargetList) == 0 or playerTargetList == []) and',
            'if len(playerTargetList) == 0 and');
    },
    explosion_sound_radius(f) {
        editBlock(f, 'subroutines.opy', 'def explosionSequence():', block => {
            const radius = '150 * eventPlayer.explosionScale';
            assert.equal(block.split(radius).length - 1, 2);
            return block.replace('    #Scaled\n    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND',
                `    #!define explosionSoundRadius tmp1\n    explosionSoundRadius = ${radius}\n    #Scaled\n    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND`)
                .replaceAll(`, ${radius})`, ', explosionSoundRadius)');
        });
    },
    mission_rollback_loop(f) {
        const file = 'global_start_menu.opy';
        const pair = '                del objectivePositionList[len(objectivePositionList) - 1]\n' +
            '                currentObjectivePosition = objectivePositionList[0]\n';
        assert(f[file].includes(pair + pair));
        f[file] = f[file].replace(pair + pair,
            '                #!define missionRollbackIndex tmp0\n' +
            '                for missionRollbackIndex in range(2):\n' +
            '    ' + pair.replace(/\n$/,'').replace('\n', '\n    ') + '\n');
    },
    grid_gamemode_membership(f) {
        replace(f, 'global_startup.opy',
            'getCurrentGamemode() != Gamemode.CTF and getCurrentGamemode() != Gamemode.CLASH and getCurrentGamemode() != Gamemode.PUSH and getCurrentGamemode() != Gamemode.CONTROL and getCurrentGamemode() != Gamemode.FLASHPOINT',
            'not getCurrentGamemode() in [Gamemode.CTF, Gamemode.CLASH, Gamemode.PUSH, Gamemode.CONTROL, Gamemode.FLASHPOINT]');
    },
    mutation_challenge_membership(f) {
        replace(f, 'subroutines.opy', 'challengeSetting == 3 or challengeSetting == 5 else',
            'challengeSetting in [3, 5] else');
    },
    bot_support_hero_membership(f) {
        replace(f, 'subroutines.opy',
            'eventPlayer.getHero() == Hero.ANA or eventPlayer.getHero() == Hero.KIRIKO',
            'eventPlayer.getHero() in [Hero.ANA, Hero.KIRIKO]');
    },
    menu_two_mode_membership(f) {
        replace(f, 'global_start_menu.opy',
            'getCurrentGamemode() == Gamemode.CTF or getCurrentGamemode() == Gamemode.PUSH',
            'getCurrentGamemode() in [Gamemode.CTF, Gamemode.PUSH]');
    },
    satellite_terminal_single_predicate(f) {
        replace(f, 'objective_types/objective_type_satellite_uplink.opy',
            'satelliteTerminalPositionList.filter(lambda _, i: satelliteTerminalProgressList[i] < 100).any(lambda x: distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)',
            'satelliteTerminalPositionList.any(lambda x, i: satelliteTerminalProgressList[i] < 100 and distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)');
    },
    revive_single_predicate(f) {
        replace(f, 'players_game_in_progress.opy',
            'playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(x.getPosition(), eventPlayer.getPosition()) < REVIVE_RADIUS)',
            'playerTargetList.exclude(eventPlayer).any(lambda x: not x.invisibilityCount and distance(x.getPosition(), eventPlayer.getPosition()) < REVIVE_RADIUS)');
        replace(f, 'players_game_in_progress.opy',
            'playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < REVIVE_RADIUS)',
            'playerTargetList.exclude(eventPlayer).any(lambda x: not x.invisibilityCount and distance(eventPlayer.getPosition(), x.getPosition()) < REVIVE_RADIUS)');
    },
    miniboss_ult_hero_membership(f) {
        replace(f, 'zombie_types.opy',
            'eventPlayer.getHero() == Hero.JUNKER_QUEEN or eventPlayer.getHero() == Hero.KIRIKO else',
            'eventPlayer.getHero() in [Hero.JUNKER_QUEEN, Hero.KIRIKO] else');
    },
    challenge_rule_membership(f) {
        replace(f, 'global_game_in_progress.opy',
            '(challengeSetting == 2 or challengeSetting == 5) == true',
            '(challengeSetting in [2, 5]) == true');
        replace(f, 'global_game_in_progress.opy',
            '(challengeSetting == 3 or challengeSetting == 5 or isSmolderEventActive) == true',
            '(challengeSetting in [3, 5] or isSmolderEventActive) == true');
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(baselineFiles);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const variant = {...baselineFiles};
        try {
            transform(variant);
            const result = await compile(variant);
            console.log(JSON.stringify({name, elements: result.elements,
                saved: before.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) {console.log(JSON.stringify({name, error: error.message}));}
    }
    const selected = ['winloss_empty_check', 'explosion_sound_radius', 'mission_rollback_loop',
        'grid_gamemode_membership', 'mutation_challenge_membership', 'bot_support_hero_membership',
        'menu_two_mode_membership', 'miniboss_ult_hero_membership', 'challenge_rule_membership'];
    const combined = {...baselineFiles};
    for (const name of selected) variants[name](combined);
    const after = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, newRules.length);
    const changedRules = [];
    for (let i = 0; i < oldRules.length; i++) {
        assert.equal(oldRules[i].name, newRules[i].name);
        if (oldRules[i].body !== newRules[i].body) changedRules.push(oldRules[i].name);
    }
    // The existing bot pivot helper has a separately audited tmp1 handoff;
    // exclude that unchanged pair from this generic intra-rule scratch audit.
    const withoutBotHelper = after.result.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(withoutBotHelper);
    console.log(JSON.stringify({name: 'selected_combined', variants: selected,
        elements: after.elements, saved: before.elements - after.elements, warnings: after.warnings.length,
        oldRulesCompared: oldRules.length, changedRules, scratchRulesCheckedExcludingBotHelper: scratch.length}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants, baselineFiles};
