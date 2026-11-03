// Measure another set of candidates in memory without changing gameplay sources.
// After implementation, reproduce the original probes with --baseline-ref 7795862.
const assert = require('node:assert/strict');
const {files, compile, compiler, replace, editBlock} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');

function factorVote(f, title, field, options, enabled) {
    editBlock(f, 'player_start_menu.opy', `rule "${title}":`, block => {
        const offset = `${field}Offset`;
        const forward = `eventPlayer.${field} = (eventPlayer.${field} + 1) % len(${options})`;
        const backward = `eventPlayer.${field} = (eventPlayer.${field} + len(${options}) - 1) % len(${options})`;
        const condition = `while not ${options}[eventPlayer.${field}]${enabled}:`;
        const old = `    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):\n` +
            `        ${forward}\n        ${condition}\n            ${forward}\n` +
            `    else:\n        ${backward}\n        ${condition}\n            ${backward}`;
        assert(block.includes(old), `${title}: vote branches changed`);
        const next = `    #!define ${offset} tmp0\n` +
            `    ${offset} = 1 if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else len(${options}) - 1\n` +
            `    eventPlayer.${field} = (eventPlayer.${field} + ${offset}) % len(${options})\n` +
            `    ${condition}\n` +
            `        eventPlayer.${field} = (eventPlayer.${field} + ${offset}) % len(${options})`;
        return block.replace(old, next);
    });
}

function sharedCall(f, file, declarationAnchor, name, call, count) {
    assert.equal(f[file].split(call).length - 1, count, `${name}: call count`);
    assert(f[file].includes(declarationAnchor), `${name}: declaration anchor`);
    f[file] = f[file].replace(declarationAnchor,
        `${declarationAnchor}\nsubroutine ${name}`);
    f[file] = f[file].replaceAll(call, `${name}()`);
    f[file] += `\n\ndef ${name}():\n    @Name "${name}"\n\n    ${call}\n`;
}

const variants = {
    vote_challenge(f) {
        factorVote(f, 'PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)',
            'pregameChallengeVote', 'challengeVoteList', '[1]');
    },
    vote_zombie(f) {
        factorVote(f, 'PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)',
            'pregameZombieVote', 'zombieVoteList', '[1]');
    },
    vote_objective(f) {
        factorVote(f, 'PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)',
            'pregameObjectiveVote', 'objectiveTypeVoteList', '[1]');
    },
    vote_enhancement(f) {
        factorVote(f, 'PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)',
            'enhancementId', 'enhancementOptionList', '');
    },
    shared_bot_throttle(f) {
        sharedCall(f, 'zombie_types.opy', 'subroutine startBlasterDaytakerFacing',
            'startBotThrottleAtTarget',
            'eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)', 2);
    },
    shared_pregame_attach(f) {
        sharedCall(f, 'player_start_menu.opy', 'subroutine randomActions',
            'attachPlayerToPregameAnchor',
            'eventPlayer.attachTo(getPlayers(Team.2)[0], localVector(eventPlayer.pregamePosition, getPlayers(Team.2)[0], Transform.ROTATION_AND_TRANSLATION))', 2);
    },
    shared_extraction_chase(f) {
        sharedCall(f, 'objective_types/objective_type_extraction_point.opy',
            'subroutine nukeMap', 'startExtractionAscent',
            'chaseAtRate(eventPlayer.extractionFlightPosition, eventPlayer.extractionFlightPosition + 200 * Vector.UP, extractionFlightSpeed)', 2);
    },
    shared_reignited_warning_sound(f) {
        sharedCall(f, 'zombie_types.opy', 'subroutine startBlasterDaytakerFacing',
            'playReignitedWarningSound',
            'playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)', 3);
    },
    shared_reignited_warning_pair(f) {
        const file = 'zombie_types.opy';
        const pair = '    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)\n' +
            '    #Scaled\n' +
            '    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.sizeScale)';
        assert.equal(f[file].split(pair).length - 1, 2);
        f[file] = f[file].replace('subroutine startBlasterDaytakerFacing',
            'subroutine startBlasterDaytakerFacing\nsubroutine playReignitedWarningPair');
        f[file] = f[file].replaceAll(pair, '    playReignitedWarningPair()');
        f[file] += '\n\ndef playReignitedWarningPair():\n    @Name "playReignitedWarningPair"\n\n' + pair + '\n';
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
            const after = await compile(candidate);
            console.log(JSON.stringify({name, elements: after.elements,
                saved: before.elements - after.elements, warnings: after.warnings.length}));
        } catch (error) {
            console.log(JSON.stringify({name, error: String(error.message).slice(0, 400)}));
        }
    }
    const selected = Object.keys(variants).filter(name => name !== 'shared_reignited_warning_sound');
    const combined = {...files};
    for (const name of selected) variants[name](combined);
    const after = await compile(combined);
    const numberOccurrences = list => {
        const counts = new Map();
        return list.map(rule => {
            const occurrence = (counts.get(rule.name) || 0) + 1;
            counts.set(rule.name, occurrence);
            return {key: `${rule.name}#${occurrence}`, body: rule.body};
        });
    };
    const oldRules = numberOccurrences(rules(before.result));
    const newRules = numberOccurrences(rules(after.result));
    const oldBodies = new Map(oldRules.map(rule => [rule.key, rule.body]));
    const changedRules = newRules.filter(rule => oldBodies.get(rule.key) !== rule.body)
        .map(rule => rule.key);
    const withoutBotHelper = after.result.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(withoutBotHelper);
    console.log(JSON.stringify({name: 'combined', selected, elements: after.elements,
        saved: before.elements - after.elements, warnings: after.warnings.length,
        oldRules: oldRules.length, newRules: newRules.length, changedRules,
        scratchRulesCheckedExcludingBotHelper: scratch.length}));
}

if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
