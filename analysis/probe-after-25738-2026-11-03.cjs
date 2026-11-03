// Compile further element-count candidates in memory; leave src/ unchanged.
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const {candidates: earlier} = require('./probe-current-opportunities-2026-11-03.cjs');
const {rules} = require('./verify-player-variables.cjs');

const variants = {
    challenge_detail_palette_slot(f) {
        const file = 'global_start_menu.opy';
        const key = '    #Challenge\n    hudText(';
        assert(f[file].includes(key));
        f[file] = f[file].replace(key,
            '    #Challenge\n    startMenuChallengeDetailColorList = [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE]\n    hudText(');
        replace(f, file,
            '[Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote]',
            'null if localPlayer.pregameChallengeVote == 1 else startMenuChallengeDetailColorList[localPlayer.pregameChallengeVote]');
        replace(f, file,
            '[Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote]',
            'startMenuChallengeDetailColorList[localPlayer.pregameChallengeVote]');
        f['variables.opy'] += '\nglobalvar startMenuChallengeDetailColorList\n';
    },
    challenge_detail_palette_inline(f) {
        replace(f, 'global_start_menu.opy',
            '[Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote]',
            'null if localPlayer.pregameChallengeVote == 1 else [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote]');
    },
    zero_vector_builtin(f) {
        let count = 0;
        for (const file of Object.keys(f)) {
            count += f[file].split('vect(0, 0, 0)').length - 1;
            f[file] = f[file].replaceAll('vect(0, 0, 0)', 'Vector.ZERO');
        }
        assert(count >= 10, `${count} occurrences`);
    },
    random_actions_switch(f) {
        const file = 'player_start_menu.opy';
        for (const [prefix, names] of [
            ['pregameEmoteDirection', ['EMOTE_UP', 'EMOTE_DOWN', 'EMOTE_LEFT', 'EMOTE_RIGHT']],
            ['pregameVoiceLineDirection', ['VOICE_LINE_UP', 'VOICE_LINE_DOWN', 'VOICE_LINE_LEFT', 'VOICE_LINE_RIGHT']],
        ]) {
            const old = `    if ${prefix} <= 1:
        eventPlayer.communicate(Comms.${names[0]})
    elif ${prefix} <= 2:
        eventPlayer.communicate(Comms.${names[1]})
    elif ${prefix} <= 3:
        eventPlayer.communicate(Comms.${names[2]})
    else:
        eventPlayer.communicate(Comms.${names[3]})`;
            const next = `    switch ${prefix}:
        case 1:
            eventPlayer.communicate(Comms.${names[0]})
            break
        case 2:
            eventPlayer.communicate(Comms.${names[1]})
            break
        case 3:
            eventPlayer.communicate(Comms.${names[2]})
            break
        case 4:
            eventPlayer.communicate(Comms.${names[3]})
            break`;
            replace(f, file, old, next);
        }
    },
    supply_pickup_any(f) { earlier.supply_pickup_any(f); },
    daytaker_shared_abort(f) { earlier.daytaker_shared_abort(f); },
    survivor_progress_single_denominator(f) { earlier.survivor_progress_single_denominator(f); },
    distance_bot_target_players(f) {
        let count = 0;
        for (const file of Object.keys(f)) {
            const old = 'distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition())';
            count += f[file].split(old).length - 1;
            f[file] = f[file].replaceAll(old, 'distance(eventPlayer, eventPlayer.botTarget)');
        }
        assert(count >= 20, `${count} distances found`);
    },
    distance_event_and_lambda_players(f) {
        let count = 0;
        for (const file of Object.keys(f)) {
            const old = 'distance(eventPlayer.getPosition(), x.getPosition())';
            count += f[file].split(old).length - 1;
            f[file] = f[file].replaceAll(old, 'distance(eventPlayer, x)');
        }
        assert(count >= 15, `${count} distances found`);
    },
    distance_two_player_positions(f) {
        const expression = /distance\(([A-Za-z][A-Za-z0-9_.]*)\.getPosition\(\),\s*([A-Za-z][A-Za-z0-9_.]*)\.getPosition\(\)\)/g;
        let count = 0;
        for (const file of Object.keys(f)) f[file] = f[file].replace(expression, (_, a, b) => {
            count++;
            return `distance(${a}, ${b})`;
        });
        assert(count >= 65, `${count} two-player distances found`);
    },
    distance_known_player_first(f) {
        let count = 0;
        for (const file of Object.keys(f)) f[file] = f[file].replace(
            /distance\((eventPlayer|localPlayer|player)\.getPosition\(\),/g,
            (_, name) => {count++; return `distance(${name},`;});
        assert(count >= 40, `${count} player-first distances found`);
    },
    direction_two_player_positions(f) {
        const expression = /directionTowards\(([A-Za-z][A-Za-z0-9_.]*)\.getPosition\(\),\s*([A-Za-z][A-Za-z0-9_.]*)\.getPosition\(\)\)/g;
        let count = 0;
        for (const file of Object.keys(f)) f[file] = f[file].replace(expression, (_, a, b) => {
            count++;
            return `directionTowards(${a}, ${b})`;
        });
        assert(count >= 15, `${count} two-player directions found`);
    },
};

async function main() {
    await compiler.readyPromise;
    const before = await compile(files);
    console.log(JSON.stringify({baseline: before.elements, warnings: before.warnings.length}));
    for (const [name, transform] of Object.entries(variants)) {
        const f = {...files};
        try {
            transform(f);
            const after = await compile(f);
            console.log(JSON.stringify({name, elements: after.elements,
                saved: before.elements - after.elements, warnings: after.warnings.length}));
        } catch (error) { console.log(JSON.stringify({name, error: error.message})); }
    }
    const selected = ['distance_two_player_positions', 'distance_known_player_first',
        'direction_two_player_positions'];
    const combined = {...files};
    for (const name of selected) variants[name](combined);
    const after = await compile(combined);
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.equal(oldRules.length, newRules.length);
    const changedRules = newRules.filter((rule, index) =>
        oldRules[index].body !== rule.body).map(rule => rule.name);
    console.log(JSON.stringify({name: 'position_coercion_combined', selected,
        elements: after.elements, saved: before.elements - after.elements,
        warnings: after.warnings.length, rulesCompared: oldRules.length,
        changedRuleCount: changedRules.length, changedRules}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
