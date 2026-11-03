// Compile possible reductions against the current source without editing src/.
const assert = require('node:assert/strict');
const {files, compile, compiler, replace} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const variants = {
    condition_unwrap_all(f) {
        let count = 0;
        for (const file of Object.keys(f)) f[file] = f[file].replace(
            /^(\s*@Condition )\((.*)\) == true$/gm, (_, prefix, condition) => {
                count++;
                return prefix + condition;
            });
        assert(count > 20, `Only ${count} conditions found`);
    },
    condition_unwrap_zombie(f) {
        let count = 0;
        f['zombie_types.opy'] = f['zombie_types.opy'].replace(
            /^(\s*@Condition )\((.*)\) == true$/gm, (_, prefix, condition) => {
                count++;
                return prefix + condition;
            });
        assert(count > 5, `Only ${count} conditions found`);
    },
    spawn_wait_max(f) {
        replace(f, 'global_startup.opy',
            'wait(sorted(botSpawnTimeList).last(), Wait.RESTART_WHEN_TRUE)',
            'wait(max(botSpawnTimeList), Wait.RESTART_WHEN_TRUE)');
    },
    bot_stat_constant_speed(f) {
        replace(f, 'subroutines.opy',
            'eventPlayer.setMoveSpeed(eventPlayer.movementSpeedScale * 100 + ((len(getDeadPlayers(Team.1).filter(lambda player: player.rescueTimeRemaining <= 0))) * 3))',
            'eventPlayer.setMoveSpeed(100 + ((len(getDeadPlayers(Team.1).filter(lambda player: player.rescueTimeRemaining <= 0))) * 3))');
    },
    bot_stat_direct_damage(f) {
        replace(f, 'subroutines.opy',
            '    # botStatDamageScale: normalized damage multiplier; the hero index is no longer needed after this lookup.\n    #!define botStatDamageScale tmp0\n    botStatDamageScale = botDamageDealtList[botStatHeroIndex] / 100\n    eventPlayer.setDamageDealt(botStatDamageScale * 100)',
            '    eventPlayer.setDamageDealt(botDamageDealtList[botStatHeroIndex])');
    },
    bot_stat_inline_damage_roundtrip(f) {
        replace(f, 'subroutines.opy',
            '    # botStatDamageScale: normalized damage multiplier; the hero index is no longer needed after this lookup.\n    #!define botStatDamageScale tmp0\n    botStatDamageScale = botDamageDealtList[botStatHeroIndex] / 100\n    eventPlayer.setDamageDealt(botStatDamageScale * 100)',
            '    eventPlayer.setDamageDealt(botDamageDealtList[botStatHeroIndex] / 100 * 100)');
    },
    bot_stat_inline_bite_calibration(f) {
        replace(f, 'subroutines.opy',
            '    eventPlayer.botBiteDamage = botBiteDamageList[botStatHeroIndex]\n    #Re-calibrate bite damage\n    eventPlayer.botBiteDamage *= 100 / botDamageDealtList[botStatHeroIndex]',
            '    #Re-calibrate bite damage\n    eventPlayer.botBiteDamage = botBiteDamageList[botStatHeroIndex] * (100 / botDamageDealtList[botStatHeroIndex])');
    },
    inline_miniboss_roll(f) {
        replace(f, 'subroutines.opy',
            '        # minibossPromotionRoll: miniboss promotion roll, consumed before the possible initialization wait.\n        #!define minibossPromotionRoll tmp0\n        minibossPromotionRoll = random.randint(1, 27 if currentObjectiveType == ObjectiveType.SHOWDOWN else 189)\n        if minibossPromotionRoll == 1:',
            '        if random.randint(1, 27 if currentObjectiveType == ObjectiveType.SHOWDOWN else 189) == 1:');
    },
    skip_assembly_condition(f) {
        replace(f, 'global_startup.opy',
            '@Condition (isAssemblingHeroes() or isPregameSetup and not getPlayers(Team.1).any(lambda player: player.isPlayerActive)) == true',
            '@Condition isAssemblingHeroes() or isPregameSetup and not getPlayers(Team.1).any(lambda player: player.isPlayerActive)');
    },
    bot_kill_bonus_inline_roll(f) {
        replace(f, 'bots_game_in_progress.opy',
            '        # botKillBonusRoll: random kill-bonus roll, to decide whether this zombie awards objective progress.\n        #!define botKillBonusRoll tmp0\n        botKillBonusRoll = random.randint(150, eventPlayer.botBaseHealth)\n        if botKillBonusRoll > 175 or difficultySetting <= Difficulty.EXPERT:',
            '        if random.randint(150, eventPlayer.botBaseHealth) > 175 or difficultySetting <= Difficulty.EXPERT:');
    },
    menu_glitch_lookup(f) {
        const file = 'global_start_menu.opy';
        const old = `        # menuGlitchMessageChoice: random message choice 1-3, to select the special-effect text for this flash.
        #!define menuGlitchMessageChoice tmp0
        menuGlitchMessageChoice = random.randint(1, 3)
        if menuGlitchMessageChoice == 1:
            pregameGlitchText = "alglChene oteV: KaMeNrldEr"
        elif menuGlitchMessageChoice == 2:
            pregameGlitchText = "You won't win"
        elif menuGlitchMessageChoice == 3:
            pregameGlitchText = "Don't even try it"`;
        replace(f, file, old,
            `        pregameGlitchText = ["alglChene oteV: KaMeNrldEr", "You won't win", "Don't even try it"][random.randint(1, 3) - 1]`);
    },
    menu_glitch_remove_redundant_if(f) {
        const file = 'global_start_menu.opy';
        const start = f[file].indexOf('rule "SPECIAL EFFECT CONTROLS":');
        const end = f[file].indexOf('\n\nrule ', start + 1);
        assert(start >= 0 && end > start);
        const block = f[file].slice(start, end);
        const at = block.indexOf('    if isPregameSetup:\n');
        const stop = block.indexOf('    isPregameGlitchActive = true', at);
        assert(at >= 0 && stop > at);
        f[file] = f[file].slice(0, start) + block.slice(0, at) +
            block.slice(at + '    if isPregameSetup:\n'.length, stop).replace(/^    /gm, '') +
            block.slice(stop) + f[file].slice(end);
    },
    random_actions_lookup(f) {
        const file = 'player_start_menu.opy';
        const start = f[file].indexOf('def randomActions():');
        const end = f[file].indexOf('\n\ndef ', start + 1);
        assert(start >= 0 && end > start);
        const block = f[file].slice(start, end);
        const emote = `    # pregameEmoteDirection: random emote direction 1-4, to choose one communication before the next wait.
    #!define pregameEmoteDirection tmp0
    pregameEmoteDirection = random.randint(1, 4)
    #Random emote
    if pregameEmoteDirection <= 1:
        eventPlayer.communicate(Comms.EMOTE_UP)
    elif pregameEmoteDirection <= 2:
        eventPlayer.communicate(Comms.EMOTE_DOWN)
    elif pregameEmoteDirection <= 3:
        eventPlayer.communicate(Comms.EMOTE_LEFT)
    else:
        eventPlayer.communicate(Comms.EMOTE_RIGHT)`;
        const voice = `    # pregameVoiceLineDirection: random voice-line direction 1-4, to choose one communication before the next wait.
    #!define pregameVoiceLineDirection tmp0
    pregameVoiceLineDirection = random.randint(1, 4)
    #Random voice line
    if pregameVoiceLineDirection <= 1:
        eventPlayer.communicate(Comms.VOICE_LINE_UP)
    elif pregameVoiceLineDirection <= 2:
        eventPlayer.communicate(Comms.VOICE_LINE_DOWN)
    elif pregameVoiceLineDirection <= 3:
        eventPlayer.communicate(Comms.VOICE_LINE_LEFT)
    else:
        eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)`;
        assert(block.includes(emote) && block.includes(voice));
        const next = block.replace(emote,
            '    eventPlayer.communicate([Comms.EMOTE_UP, Comms.EMOTE_DOWN, Comms.EMOTE_LEFT, Comms.EMOTE_RIGHT][random.randint(1, 4) - 1])')
            .replace(voice,
            '    eventPlayer.communicate([Comms.VOICE_LINE_UP, Comms.VOICE_LINE_DOWN, Comms.VOICE_LINE_LEFT, Comms.VOICE_LINE_RIGHT][random.randint(1, 4) - 1])');
        f[file] = f[file].slice(0, start) + next + f[file].slice(end);
    },
    random_actions_ternary(f) {
        const file = 'player_start_menu.opy';
        const emote = `    #Random emote
    if pregameEmoteDirection <= 1:
        eventPlayer.communicate(Comms.EMOTE_UP)
    elif pregameEmoteDirection <= 2:
        eventPlayer.communicate(Comms.EMOTE_DOWN)
    elif pregameEmoteDirection <= 3:
        eventPlayer.communicate(Comms.EMOTE_LEFT)
    else:
        eventPlayer.communicate(Comms.EMOTE_RIGHT)`;
        const voice = `    #Random voice line
    if pregameVoiceLineDirection <= 1:
        eventPlayer.communicate(Comms.VOICE_LINE_UP)
    elif pregameVoiceLineDirection <= 2:
        eventPlayer.communicate(Comms.VOICE_LINE_DOWN)
    elif pregameVoiceLineDirection <= 3:
        eventPlayer.communicate(Comms.VOICE_LINE_LEFT)
    else:
        eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)`;
        replace(f, file, emote,
            '    eventPlayer.communicate(Comms.EMOTE_UP if pregameEmoteDirection <= 1 else Comms.EMOTE_DOWN if pregameEmoteDirection <= 2 else Comms.EMOTE_LEFT if pregameEmoteDirection <= 3 else Comms.EMOTE_RIGHT)');
        replace(f, file, voice,
            '    eventPlayer.communicate(Comms.VOICE_LINE_UP if pregameVoiceLineDirection <= 1 else Comms.VOICE_LINE_DOWN if pregameVoiceLineDirection <= 2 else Comms.VOICE_LINE_LEFT if pregameVoiceLineDirection <= 3 else Comms.VOICE_LINE_RIGHT)');
    },
    menu_glitch_both(f) {
        variants.menu_glitch_lookup(f);
        variants.menu_glitch_remove_redundant_if(f);
    },
    biomorphing_goal_lookup(f) {
        const file = 'objective_types/objective_type_biomorphing.opy';
        const old = `    if biomorphingGoalQueueList[0] == 0:
        biomorphingGoalText = "Deposit a head for extra points"
        biomorphingGoalColor = Color.BLUE
    elif biomorphingGoalQueueList[0] == 1:
        biomorphingGoalText = "Deposit an arm for extra points"
        biomorphingGoalColor = Color.TURQUOISE
    elif biomorphingGoalQueueList[0] == 2:
        biomorphingGoalText = "Deposit a leg for extra points"
        biomorphingGoalColor = Color.SKY_BLUE
    else:`;
        const next = `    if biomorphingGoalQueueList[0] in [0, 1, 2]:
        biomorphingGoalText = ["Deposit a head for extra points", "Deposit an arm for extra points", "Deposit a leg for extra points"][biomorphingGoalQueueList[0]]
        biomorphingGoalColor = [Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE][biomorphingGoalQueueList[0]]
    else:`;
        replace(f, file, old, next);
    },
    biomorphing_goal_existing_color(f) {
        variants.biomorphing_goal_lookup(f);
        replace(f, 'objective_types/objective_type_biomorphing.opy',
            '[Color.BLUE, Color.TURQUOISE, Color.SKY_BLUE][biomorphingGoalQueueList[0]]',
            'biomorphingResourceColorList[biomorphingGoalQueueList[0]]');
    },
    biomorphing_goal_full_lookup(f) {
        const file = 'objective_types/objective_type_biomorphing.opy';
        const start = f[file].indexOf('    if biomorphingGoalQueueList[0] == 0:');
        const end = f[file].indexOf('    isBiomorphingGoalPending = false', start);
        assert(start >= 0 && end > start);
        f[file] = f[file].slice(0, start) +
            `    biomorphingGoalText = ["Deposit a head for extra points", "Deposit an arm for extra points", "Deposit a leg for extra points", "Hand over your blood."][biomorphingGoalQueueList[0]]
    biomorphingGoalColor = biomorphingResourceColorList[biomorphingGoalQueueList[0]]
    if biomorphingGoalQueueList[0] == 3:
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, currentObjectivePosition, 200)
        getPlayers(Team.1).biomorphingResourceType = 3
        getPlayers(Team.1).biomorphingResourceAmount = 9999
` + f[file].slice(end);
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
    const combinations = [
        ['conservative', ['menu_glitch_both', 'biomorphing_goal_existing_color',
            'bot_stat_constant_speed', 'bot_stat_inline_damage_roundtrip',
            'inline_miniboss_roll', 'bot_kill_bonus_inline_roll']],
        ['direct_damage', ['menu_glitch_both', 'biomorphing_goal_existing_color',
            'bot_stat_constant_speed', 'bot_stat_direct_damage',
            'inline_miniboss_roll', 'bot_kill_bonus_inline_roll']],
    ];
    for (const [name, selected] of combinations) {
        const f = {...files};
        for (const variant of selected) variants[variant](f);
        const after = await compile(f);
        const oldRules = rules(before.result), newRules = rules(after.result);
        assert.equal(oldRules.length, newRules.length);
        const changedRules = newRules.filter((rule, index) =>
            oldRules[index].body !== rule.body).map(rule => rule.name);
        console.log(JSON.stringify({name, selected, elements: after.elements,
            saved: before.elements - after.elements, warnings: after.warnings.length,
            rulesCompared: oldRules.length, changedRules}));
    }
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
