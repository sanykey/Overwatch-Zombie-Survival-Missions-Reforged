// Compile candidate reductions in memory; do not write src/ or its Workshop export.
const assert = require('node:assert/strict');
const {files, compile, compiler, replace, editBlock} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');

const variants = {
    showdown_capture_min(f) {
        replace(f, 'objective_types/objective_type_showdown.opy',
            'showdownCapturePercent += len(objectivePlayerList) + 0.25 if len(objectivePlayerList) <= 3 else 3.25',
            'showdownCapturePercent += min(len(objectivePlayerList), 3) + 0.25');
    },
    showdown_decay_min(f) {
        replace(f, 'objective_types/objective_type_showdown.opy',
            '(3 if len(showdownContestingZombieList) > 3 else len(showdownContestingZombieList))',
            'min(3, len(showdownContestingZombieList))');
    },
    common_bot_creation(f) {
        editBlock(f, 'global_startup.opy', 'macro botHeroRandomizationMacro():', block => {
            const oldStart = block.indexOf('    if isSmolderEventActive:');
            const oldEnd = block.indexOf('\n\n', oldStart);
            assert(oldStart > 0 && oldEnd > oldStart);
            let selected = block.slice(oldStart, oldEnd);
            assert.equal(selected.split('createDummy(').length - 1, 3);
            selected = selected.replace('createDummy(Hero.WINSTON, Team.2, -1, dummyHoldingPositionConst)',
                    'botSpawnSelectedHero = Hero.WINSTON')
                .replace('createDummy(botHeroList[botSpawnHeroIndex], Team.2, -1, dummyHoldingPositionConst)',
                    'botSpawnSelectedHero = botHeroList[botSpawnHeroIndex]')
                .replace('createDummy(sorted(botHeroList, lambda _, i: botSpawnRateList[i]).last(), Team.2, -1, dummyHoldingPositionConst)',
                    'botSpawnSelectedHero = sorted(botHeroList, lambda _, i: botSpawnRateList[i]).last()');
            return block.slice(0, oldStart) + '    #!define botSpawnSelectedHero tmp0\n' + selected +
                '\n    createDummy(botSpawnSelectedHero, Team.2, -1, dummyHoldingPositionConst)' + block.slice(oldEnd);
        });
    },
    spawn_point_index_snapshot(f) {
        editBlock(f, 'bots_game_in_progress.opy', 'def removeBotSpawnPoint():', block => {
            const old = 'botSpawnPointList.index(eventPlayer.botTeleportPosition)';
            assert.equal(block.split(old).length - 1, 2);
            return block.replace('    del botSpawnWaypointList[',
                '    #!define removedBotSpawnPointIndex tmp0\n' +
                `    removedBotSpawnPointIndex = ${old}\n` +
                '    del botSpawnWaypointList[').replaceAll(old, 'removedBotSpawnPointIndex')
                .replace('removedBotSpawnPointIndex = removedBotSpawnPointIndex', `removedBotSpawnPointIndex = ${old}`);
        });
    },
    satellite_chase_helper(f) {
        const file = 'objective_types/objective_type_satellite_uplink.opy';
        const call = 'chaseAtRate(satelliteLaserPosition, satelliteLaserTarget.getPosition(), 7.5 if getLivingPlayers(Team.2).any(lambda player: not player.botIsTeleporting) else 0)';
        assert.equal(f[file].split(call).length - 1, 2);
        f[file] = f[file].replace('#!mainFile "../main.opy"',
            '#!mainFile "../main.opy"\n\nsubroutine chaseSatelliteTarget');
        f[file] = f[file].replaceAll(call, 'chaseSatelliteTarget()');
        f[file] += '\n\ndef chaseSatelliteTarget():\n    @Name "chaseSatelliteTarget"\n\n    ' + call + '\n';
    },
    shared_blaster_daytaker_facing(f) {
        const file = 'zombie_types.opy';
        const call = 'eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.isCrowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)';
        assert.equal(f[file].split(call).length - 1, 2);
        f[file] = f[file].replace('#!mainFile "main.opy"',
            '#!mainFile "main.opy"\n\nsubroutine startBlasterDaytakerFacing');
        f[file] = f[file].replaceAll(call, 'startBlasterDaytakerFacing()');
        f[file] += '\n\ndef startBlasterDaytakerFacing():\n    @Name "startBlasterDaytakerFacing"\n\n    ' + call + '\n';
    },
    shared_pup_default_chase(f) {
        const file = 'enhancements.opy';
        const call = 'chaseAtRate(eventPlayer.enhancementPupPosition, eventPlayer.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition), abs(distance(eventPlayer.getEyePosition(), eventPlayer.enhancementPupPosition) - 1))';
        assert.equal(f[file].split(call).length - 1, 2);
        f[file] = f[file].replace('subroutine checkEnhancementPlacement',
            'subroutine checkEnhancementPlacement\nsubroutine startPupDefaultChase');
        f[file] = f[file].replaceAll(call, 'startPupDefaultChase()');
        f[file] += '\n\ndef startPupDefaultChase():\n    @Name "startPupDefaultChase"\n\n    ' + call + '\n';
    },
    shared_aqua_powerup_sound(f) {
        const file = 'supply_drops.opy';
        const call = 'playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.AQUA, eventPlayer.getPosition(), 50)';
        assert.equal(f[file].split(call).length - 1, 4);
        f[file] = f[file].replace('subroutine powerUpUsage',
            'subroutine playAquaPowerUpSound\nsubroutine powerUpUsage');
        f[file] = f[file].replaceAll(call, 'playAquaPowerUpSound()');
        f[file] += '\n\ndef playAquaPowerUpSound():\n    @Name "playAquaPowerUpSound"\n\n    ' + call + '\n';
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const variant = {...files};
        try {
            transform(variant);
            const result = await compile(variant);
            console.log(JSON.stringify({name, elements: result.elements,
                saved: before.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) {console.log(JSON.stringify({name, error: String(error.message).slice(0, 500)}));}
    }
    const combined = {...files};
    for (const transform of Object.values(variants)) transform(combined);
    const after = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const numberOccurrences = list => {
        const counts = new Map();
        return list.map(rule => {
            const occurrence = (counts.get(rule.name) || 0) + 1;
            counts.set(rule.name, occurrence);
            return {key: `${rule.name}#${occurrence}`, body: rule.body};
        });
    };
    const oldByName = new Map(numberOccurrences(oldRules).map(rule => [rule.key, rule.body]));
    const changedRules = numberOccurrences(newRules).filter(rule => oldByName.get(rule.key) !== rule.body).map(rule => rule.key);
    const withoutBotHelper = after.result.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(withoutBotHelper);
    console.log(JSON.stringify({name: 'all_combined', elements: after.elements,
        saved: before.elements - after.elements, warnings: after.warnings.length,
        oldRulesCompared: oldRules.length, newRules: newRules.length,
        changedRules, scratchRulesCheckedExcludingBotHelper: scratch.length}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
