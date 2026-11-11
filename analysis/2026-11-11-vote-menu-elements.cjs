// Measures pregame voting-menu element candidates (read-only w.r.t. src/):
//   C1: merge the three vote-control rules (ULTIMATE / ABILITY 1 / ABILITY 2) into one rule.
//       The shared conditions (isVoting, isPregameSetup, hasSpawned) are duplicated per rule today.
//   C2: hoist the duplicated Challenge HUD color tables into variables (zombie/objective/enhancement
//       HUDs already do this via startMenuZombieColorList etc.).
//   C3: merge the weighted-sum loop of determineChallenge into the vote-counting loop.
const fs = require('fs');
const path = require('path');
const assert = require('assert');

const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const extdir = path.join(process.env.USERPROFILE, '.vscode/extensions');
const ext = fs.readdirSync(extdir).filter(n => n.startsWith('zezombye.overpy-'))
    .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }))[0];
const compiler = require(path.join(extdir, ext, 'npm', 'overpy.js'));

function readTree(dir, prefix = '') {
    return Object.fromEntries(fs.readdirSync(dir, { withFileTypes: true }).flatMap(e => {
        const name = prefix + e.name;
        return e.isDirectory() ? Object.entries(readTree(path.join(dir, e.name), name + '/')) :
            e.name.endsWith('.opy') ? [[name, fs.readFileSync(path.join(dir, e.name), 'utf8').replace(/\r\n/g, '\n')]] : [];
    }));
}

function source(f) {
    return f['includes.opy'].replace(/^#!include "([^"]+)".*$/gm, (line, n) =>
        n.startsWith('vas/') ? line : f[n].replace(/^#!mainFile .*\n/gm, ''))
        .replace(/^#!writeToOutputFile.*\n/gm, '');
}

async function compileQ(f) {
    const saved = [console.log, console.warn, console.error];
    console.log = console.warn = console.error = () => {};
    try {
        const r = await compiler.compile(source(f), 'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
        return { elements: r.nbElements, warnings: r.encounteredWarnings };
    } finally { [console.log, console.warn, console.error] = saved; }
}

function clone(f) { return Object.fromEntries(Object.entries(f).map(([k, v]) => [k, v])); }

function sub(out, file, from, to) {
    assert(out[file].includes(from), file + ': pattern not found: ' + from.slice(0, 100));
    out[file] = out[file].replace(from, () => to);
}

// C1: one rule with the shared conditions; per-button dispatch moves into the body.
// Sequential ifs (not elif) keep the both-buttons-held behavior of two separate rules.
function mergeVoteRules(f) {
    const out = clone(f);
    const file = 'player_start_menu.opy';
    const rule1 = out[file].indexOf('rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)":');
    const rule3end = out[file].indexOf('rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)":');
    assert(rule1 >= 0 && rule3end > rule1);
    const replacement =
`rule "PLAYER MENU CONTROLS (ULTIMATE/ABILITY 1/ABILITY 2, MODE VOTES)":
    @Event eachPlayer
    @Team 1
    @Condition isVoting == true
    @Condition isPregameSetup == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.ABILITY_2)) == true

    #Update player voting status
    eventPlayer.isPregameVoting = true
    # Scratch is consumed by advanceMenuChoice and copied back before any yield.
    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        menuChoiceIndex = eventPlayer.pregameChallengeVote
        menuChoiceOptions = challengeVoteList
        advanceMenuChoice()
        eventPlayer.pregameChallengeVote = menuChoiceIndex
    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        menuChoiceIndex = eventPlayer.pregameZombieVote
        menuChoiceOptions = zombieVoteList
        advanceMenuChoice()
        eventPlayer.pregameZombieVote = menuChoiceIndex
    if eventPlayer.isHoldingButton(Button.ABILITY_2):
        menuChoiceIndex = eventPlayer.pregameObjectiveVote
        menuChoiceOptions = objectiveTypeVoteList
        advanceMenuChoice()
        eventPlayer.pregameObjectiveVote = menuChoiceIndex


`;
    out[file] = out[file].slice(0, rule1) + replacement + out[file].slice(rule3end);
    return out;
}

// C2: hoist duplicated Challenge HUD color tables into variables, like the other HUDs.
function hoistChallengeColors(f) {
    const out = clone(f);
    const file = 'global_start_menu.opy';
    sub(out, file, '    #Challenge\n    hudText(', '    #Challenge\n    startMenuChallengeColorList = [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.TURQUOISE, Color.PURPLE]\n    startMenuChallengeTextColorList = [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE]\n    hudText(');
    sub(out, file, '        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.TURQUOISE, Color.PURPLE][localPlayer.pregameChallengeVote],\n        [Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote],\n        [Color.AQUA, Color.YELLOW, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote],',
        '        startMenuChallengeColorList[localPlayer.pregameChallengeVote],\n        [Color.AQUA, null, Color.LIME_GREEN, Color.ORANGE, Color.WHITE, Color.WHITE][localPlayer.pregameChallengeVote],\n        startMenuChallengeTextColorList[localPlayer.pregameChallengeVote],');
    return out;
}

// C3: fold the weighted-sum accumulation into the vote-counting loop of determineChallenge.
function mergeChallengeLoops(f) {
    const out = clone(f);
    const file = 'global_start_menu.opy';
    sub(out, file,
`    for challengeVoteIndex in range(Challenge.NONE, len(challengeVoteList)):
        challengeVoteList[challengeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameChallengeVote == challengeVoteIndex)) if challengeVoteList[challengeVoteIndex] else -1
    # challengeWeightedVoteSum: sum of challenge IDs weighted by votes, to calculate the average challenge vote.
    #!define challengeWeightedVoteSum tmp1
    challengeWeightedVoteSum = 0
    # challengeVoteIndex: challenge index, to include each challenge's weighted votes in challengeWeightedVoteSum.
    for challengeVoteIndex in range(Challenge.NONE, len(challengeVoteList)):
        # challengeWeightedVoteSum: running weighted sum including this challenge, for the average used to break ties.
        challengeWeightedVoteSum += challengeVoteList[challengeVoteIndex] * challengeVoteIndex`,
`    # challengeWeightedVoteSum: sum of challenge IDs weighted by votes, to calculate the average challenge vote.
    #!define challengeWeightedVoteSum tmp1
    challengeWeightedVoteSum = 0
    for challengeVoteIndex in range(Challenge.NONE, len(challengeVoteList)):
        challengeVoteList[challengeVoteIndex] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.pregameChallengeVote == challengeVoteIndex)) if challengeVoteList[challengeVoteIndex] else -1
        # Running weighted sum including this challenge, for the average used to break ties.
        challengeWeightedVoteSum += challengeVoteList[challengeVoteIndex] * challengeVoteIndex`);
    return out;
}

async function main() {
    await compiler.readyPromise;
    const base = readTree(src);
    const baseline = await compileQ(base);
    console.log('baseline:', baseline.elements, 'elements,', baseline.warnings.length, 'warnings');

    const candidates = [
        ['C1 merge 3 vote-control rules', mergeVoteRules],
        // C2 dropped: the three Challenge color tables are not duplicates (differ at index 1),
        // so hoisting saves nothing.
        ['C3 merge challenge counting+weighted-sum loops', mergeChallengeLoops],
    ];
    for (const [name, fn] of candidates) {
        const c = await compileQ(fn(base));
        console.log(`${name} => ${c.elements} (delta ${c.elements - baseline.elements}), warnings ${c.warnings.length}`);
        for (const w of c.warnings.slice(0, 5)) console.log('    warn:', String(w.message || w).slice(0, 200));
    }

    // Combined
    let f = mergeVoteRules(base);
    // f = hoistChallengeColors(f); // dropped
    f = mergeChallengeLoops(f);
    const all = await compileQ(f);
    console.log(`all combined => ${all.elements} (delta ${all.elements - baseline.elements}), warnings ${all.warnings.length}`);
}
main().catch(e => { console.error(e); process.exit(1); });
