// Compile fresh candidate edits in memory. Never update game sources or the Workshop export.
const assert = require('node:assert/strict');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, replace, src} = require('./measure-further-optimizations.cjs');
const baselineRef = 'ebacea2';
const baselineFiles = {...files};
for (const file of ['global_game_in_progress.opy', 'global_startup.opy',
    'players_game_in_progress.opy', 'zombie_types.opy', 'supply_drops.opy'])
    baselineFiles[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');

const variants = {
    overtime_destination(f) {
        replace(f, 'global_game_in_progress.opy',
            '        if getCurrentGamemode() == Gamemode.ESCORT:\n            ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bossStateList))[0]).teleport(getPayloadPosition())\n        else:\n            ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bossStateList))[0]).teleport(getObjectivePosition(0))',
            '        ((getLivingPlayers(Team.2).filter(lambda player: player.botTarget == null and not player in bossStateList))[0]).teleport(getPayloadPosition() if getCurrentGamemode() == Gamemode.ESCORT else getObjectivePosition(0))');
    },
    swarm_buttons(f) {
        replace(f, 'global_game_in_progress.opy',
            '    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:\n        eventPlayer.allowButton(Button.SECONDARY_FIRE)\n        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)\n    else:\n        eventPlayer.allowButton(Button.PRIMARY_FIRE)\n        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)',
            '    if eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:\n        eventPlayer.allowButton(Button.SECONDARY_FIRE)\n        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)\n    elif eventPlayer.getHero() not in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n        eventPlayer.allowButton(Button.PRIMARY_FIRE)\n        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)');
    },
    spawn_room_wrap(f) {
        replace(f, 'global_game_in_progress.opy',
            '    spawnRoomIndex++\n    if spawnRoomIndex >= len(attackSpawnRooms):\n        spawnRoomIndex = 0',
            '    spawnRoomIndex = (spawnRoomIndex + 1) % len(attackSpawnRooms)');
    },
    reignite_any(f) {
        replace(f, 'zombie_types.opy',
            '@Condition len(getPlayersOnHero(Hero.ANRAN, Team.2).filter(lambda player: player.botIsReigniteActive)) > null',
            '@Condition getPlayersOnHero(Hero.ANRAN, Team.2).any(lambda player: player.botIsReigniteActive)');
    },
    turret_any(f) {
        replace(f, 'supply_drops.opy',
            'len(getLivingPlayers(Team.2).filter(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting))',
            'getLivingPlayers(Team.2).any(lambda player: isInLoS(eventPlayer.powerUpTurretPosition, player) and not player.botIsTeleporting)');
    },
    downed_teleport_helper(f) {
        const file = 'players_game_in_progress.opy';
        const action = 'eventPlayer.teleport(nearestWalkablePosition(nearestWalkablePosition(eventPlayer.getPosition()) + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.getPosition(), nearestWalkablePosition(eventPlayer.getPosition()))), 0) * 2))';
        assert.equal(f[file].split(action).length - 1, 2);
        f[file] = 'subroutine teleportDownedPlayerToWalkable\n' + f[file].replaceAll(action, 'teleportDownedPlayerToWalkable()') + '\n\ndef teleportDownedPlayerToWalkable():\n    ' + action + '\n';
    },
    pregame_spawn_wrap(f) {
        replace(f, 'global_startup.opy',
            '        spawnRoomIndex++\n        if getCurrentGamemode() == Gamemode.ASSAULT and spawnRoomIndex > 1 or spawnRoomIndex > 2:\n            spawnRoomIndex = 0',
            '        spawnRoomIndex = (spawnRoomIndex + 1) % len(attackSpawnRooms)');
    },
    swarm_button_value(f) {
        replace(f, 'global_game_in_progress.opy',
            '    if eventPlayer.getHero() in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n    elif eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN]:\n        eventPlayer.allowButton(Button.SECONDARY_FIRE)\n        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)\n    else:\n        eventPlayer.allowButton(Button.PRIMARY_FIRE)\n        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)',
            '    if eventPlayer.getHero() not in [Hero.REINHARDT, Hero.PHARAH, Hero.SIGMA, Hero.WINSTON]:\n        eventPlayer.allowButton(Button.SECONDARY_FIRE if eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN] else Button.PRIMARY_FIRE)\n        eventPlayer.startForcingButton(Button.SECONDARY_FIRE if eventPlayer.getHero() in [Hero.TORBJORN, Hero.MOIRA, Hero.SYMMETRA, Hero.KIRIKO, Hero.MAUGA, Hero.ANRAN] else Button.PRIMARY_FIRE)');
    },
    healthpack_visibility_shared(f) {
        const file = 'global_game_in_progress.opy';
        const old = 'getPlayers(Team.1).filter(lambda player: player.enhancementId != Enhancement.ZOMBIE_HYBRID and len(healthpackPositionList) > 0 and player.isInfected and getMatchTime() > matchEndTime)';
        assert.equal(f[file].split(old).length - 1, 2);
        // A textual macro avoids new state and preserves live visibility reevaluation.
        f['variables.opy'] += '\n#!define visibleCurePlayers getPlayers(Team.1).filter(lambda player: player.enhancementId != Enhancement.ZOMBIE_HYBRID and len(healthpackPositionList) > 0 and player.isInfected and getMatchTime() > matchEndTime)\n';
        f[file] = f[file].replaceAll(old, 'visibleCurePlayers');
    },
};

async function main() {
    await compiler.readyPromise;
    const baseline = await compile(baselineFiles);
    console.log(JSON.stringify({baseline: baseline.elements, warnings: baseline.warnings.length}));
    for (const [name, change] of Object.entries(variants)) {
        const f = {...baselineFiles};
        try {
            change(f);
            const result = await compile(f);
            console.log(JSON.stringify({name, elements: result.elements, saved: baseline.elements - result.elements, warnings: result.warnings.length}));
        } catch (error) {
            console.log(JSON.stringify({name, error: error.message}));
        }
    }
    const selected = ['overtime_destination', 'downed_teleport_helper', 'pregame_spawn_wrap', 'spawn_room_wrap', 'reignite_any', 'turret_any'];
    const combined = {...baselineFiles};
    for (const name of selected) variants[name](combined);
    const result = await compile(combined);
    console.log(JSON.stringify({name: 'selected_combined', variants: selected, elements: result.elements,
        saved: baseline.elements - result.elements, warnings: result.warnings.length}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
