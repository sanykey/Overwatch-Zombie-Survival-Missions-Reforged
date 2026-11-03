// Probe repeated vote-step actions and reconnect lookup in memory.
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');

function voteStep(f, name, field, offset, list) {
    const file = 'player_start_menu.opy';
    const action = `eventPlayer.${field} = (eventPlayer.${field} + ${offset}) % len(${list})`;
    assert.equal(f[file].split(action).length - 1, 2);
    f[file] = f[file].replace('subroutine randomActions',
        `subroutine ${name}\nsubroutine randomActions`);
    f[file] = f[file].replaceAll(action, `${name}()`);
    f[file] += `\n\ndef ${name}():\n    @Name "${name}"\n\n    ${action}\n`;
}
const variants = {
    challenge_step(f) {
        voteStep(f, 'advanceChallengeVote', 'pregameChallengeVote',
            'pregameChallengeVoteOffset', 'challengeVoteList');
    },
    zombie_step(f) {
        voteStep(f, 'advanceZombieVote', 'pregameZombieVote',
            'pregameZombieVoteOffset', 'zombieVoteList');
    },
    objective_step(f) {
        voteStep(f, 'advanceObjectiveVote', 'pregameObjectiveVote',
            'pregameObjectiveVoteOffset', 'objectiveTypeVoteList');
    },
    enhancement_step(f) {
        voteStep(f, 'advanceEnhancementChoice', 'enhancementId',
            'enhancementIdOffset', 'enhancementOptionList');
    },
    reconnect_lookup(f) {
        const action = 'eventPlayer.reconnectUserIndex = userNameList.index("{0}".format(eventPlayer))';
        assert.equal(f['players_game_in_progress.opy'].split(action).length - 1, 2);
        f['subroutines.opy'] = f['subroutines.opy'].replace('subroutine enableDisableAbilities',
            'subroutine resolveReconnectUserIndex\nsubroutine enableDisableAbilities');
        f['players_game_in_progress.opy'] = f['players_game_in_progress.opy']
            .replaceAll(action, 'resolveReconnectUserIndex()');
        f['subroutines.opy'] += '\n\ndef resolveReconnectUserIndex():\n' +
            '    @Name "resolveReconnectUserIndex"\n\n    ' + action + '\n';
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
    const combined = {...files};
    for (const transform of Object.values(variants)) transform(combined);
    const after = await compile(combined);
    const compiledRules = rules(after.result);
    let auditOutput = after.result;
    for (const helper of ['advanceChallengeVote', 'advanceZombieVote',
        'advanceObjectiveVote', 'advanceEnhancementChoice', 'resolveReconnectUserIndex',
        'applyScaledMoveSpeed', 'refreshCurrentObjectivePosition',
        'refreshCurrentObjectiveType', 'faceCurrentThrottle',
        'excludeCurrentHeroFromSelection', 'applyBotKnockbackScale',
        'applyCurrentSizeScale', 'applyBotBossHealth']) {
        const body = compiledRules.find(rule => rule.name === helper).body;
        const match = body.match(/actions \{\n([^\n]+)\n\}/);
        assert(match, `${helper}: expected one action`);
        assert(!/\bWait\(|Call Subroutine|Set Global Variable\(tmp0/.test(match[1]),
            `${helper}: must not yield, call another rule, or overwrite tmp0`);
        if (helper.startsWith('advance')) assert(match[1].includes('Global.tmp0'));
        auditOutput = auditOutput.replaceAll(`Call Subroutine(${helper});`, match[1]);
    }
    const withoutBotHelper = auditOutput.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter|advanceChallengeVote|advanceZombieVote|advanceObjectiveVote|advanceEnhancementChoice)"\) \{[\s\S]*?^\}/gm, '');
    const scratchRules = checkWorkshop(withoutBotHelper).length;
    console.log(JSON.stringify({name: 'combined', elements: after.elements,
        saved: before.elements - after.elements, warnings: after.warnings.length,
        oldRules: rules(before.result).length, newRules: compiledRules.length, scratchRules}));
}
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
module.exports = {variants};
