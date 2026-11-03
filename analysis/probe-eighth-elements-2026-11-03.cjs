// Measure equivalent filter and quantifier rewrites in memory.
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const variants = {
    survivor_any_single_predicate(f) {
        replace(f, 'objective_types/objective_type_survivor_rescue.opy',
            'playerTargetList.filter(lambda x: x != rescueSurvivor and not x.invisibilityCount).any(lambda x: distance(rescueSurvivor.getPosition(), x.getPosition()) < objectiveRad)',
            'playerTargetList.any(lambda x: x != rescueSurvivor and not x.invisibilityCount and distance(rescueSurvivor.getPosition(), x.getPosition()) < objectiveRad)');
    },
    bot_invisible_all_single_predicate(f) {
        replace(f, 'bots_game_in_progress.opy',
            'playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.invisibilityCount or not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))');
    },
    bot_view_angle_all_single_predicate(f) {
        replace(f, 'bots_game_in_progress.opy',
            'playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))',
            'playerTargetList.all(lambda x: not x.isInViewAngle(eventPlayer.botTeleportPosition, 55) or not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))');
    },
    spawn_room_all_single_predicate(f) {
        replace(f, 'global_game_in_progress.opy',
            'getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x.getPosition(), attackSpawnRooms[spawnRoomIndex]) > 45)',
            'getPlayers(Team.1).all(lambda player: not player.hasSpawned() or distance(player.getPosition(), attackSpawnRooms[spawnRoomIndex]) > 45)');
    },
    revive_any_single_predicate(f) {
        replace(f, 'players_game_in_progress.opy',
            'playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(x.getPosition(), eventPlayer.getPosition()) < REVIVE_RADIUS)',
            'playerTargetList.exclude(eventPlayer).any(lambda x: not x.invisibilityCount and distance(x.getPosition(), eventPlayer.getPosition()) < REVIVE_RADIUS)');
        replace(f, 'players_game_in_progress.opy',
            'playerTargetList.exclude(eventPlayer).filter(lambda x: not x.invisibilityCount).any(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < REVIVE_RADIUS)',
            'playerTargetList.exclude(eventPlayer).any(lambda x: not x.invisibilityCount and distance(eventPlayer.getPosition(), x.getPosition()) < REVIVE_RADIUS)');
    },
    satellite_any_single_predicate(f) {
        replace(f, 'objective_types/objective_type_satellite_uplink.opy',
            'satelliteTerminalPositionList.filter(lambda _, i: satelliteTerminalProgressList[i] < 100).any(lambda x: distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)',
            'satelliteTerminalPositionList.any(lambda x, i: satelliteTerminalProgressList[i] < 100 and distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)');
    },
    redundant_exclude_in_push(f) {
        replace(f, 'zombie_types.opy',
            'getLivingPlayers(Team.ALL).exclude(eventPlayer).filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 20 * eventPlayer.sizeScale and distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition()) > 1.5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.sizeScale)',
            'getLivingPlayers(Team.ALL).filter(lambda x: distance(eventPlayer.getPosition(), x.getPosition()) < 20 * eventPlayer.sizeScale and distance(worldVector((3 * eventPlayer.sizeScale) * Vector.FORWARD, eventPlayer, Transform.ROTATION_AND_TRANSLATION), x.getPosition()) > 1.5 * eventPlayer.sizeScale and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and x != eventPlayer and abs(eventPlayer.getPosition().y - x.getPosition().y) < 2 * eventPlayer.sizeScale)');
    },
    stun_filter_exclusion(f) {
        replace(f, 'supply_drops.opy',
            'getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpStunOrigin.getPosition(), player.getPosition()) < 15 and not player.botIsTeleporting)).exclude(eventPlayer.powerUpStunTarget)',
            'getLivingPlayers(Team.2).filter(lambda player: distance(eventPlayer.powerUpStunOrigin.getPosition(), player.getPosition()) < 15 and not player.botIsTeleporting and player != eventPlayer.powerUpStunTarget))');
    },
    pup_filter_exclusion(f) {
        replace(f, 'enhancements.opy',
            '((getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementPupTarget.getPosition(), player.getPosition()) < 3)).exclude(eventPlayer.enhancementPupTarget))',
            '(getPlayers(Team.2).filter(lambda player: distance(eventPlayer.enhancementPupTarget.getPosition(), player.getPosition()) < 3 and player != eventPlayer.enhancementPupTarget))');
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const candidate = {...files};
        try {
            transform(candidate);
            const result = await compile(candidate);
            console.log(JSON.stringify({name, elements: result.elements,
                saved: before.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) {
            console.log(JSON.stringify({name, error: String(error.message).slice(0, 450)}));
        }
    }
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
