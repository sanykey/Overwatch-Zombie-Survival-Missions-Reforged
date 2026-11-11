// Measures flattening the pregame vote lists: the [null, enabled] pair wrapper is
// written on initialization and only ever read via index [1]; after voting, elements
// are overwritten wholesale with vote counts. Storing the raw enabled values removes
// three Mapped Array initializers (SKIP ASSEMBLING HEROES / setAvailableObjectivesMacro)
// and three .map(lambda option: option[1]) copies in the player menu rules.
// Read-only with respect to src/.
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

// Flattens the three vote lists:
//   challengeVoteList / zombieVoteList: drop ".map(lambda enabled: [null, enabled])".
//   objectiveTypeVoteList: "[null, <expr>]" -> "<expr>" (7 entries).
//   consumers: "<list>[i][1]" -> "<list>[i]" (global_start_menu x3),
//     "<list>.map(lambda option: option[1])" -> direct reference (player_start_menu x3).
function flattenVoteLists(f) {
    const out = clone(f);
    let edits = 0;
    const sub = (file, from, to) => {
        assert(out[file].includes(from), file + ': pattern not found: ' + from.slice(0, 80));
        out[file] = out[file].replace(from, () => { edits++; return to; });
    };
    for (const m of out['global_startup.opy'].matchAll(/\]\.map\(lambda enabled: \[null, enabled\]\)/g)) edits++;
    out['global_startup.opy'] = out['global_startup.opy'].replace(/\]\.map\(lambda enabled: \[null, enabled\]\)/g, ']');
    assert(edits === 2, 'expected 2 challenge/zombie map wrappers, got ' + edits);
    for (const setting of ['Showdown', 'Bosses', 'Kill Zone', 'Zombie Egg', 'Satellite Uplink', 'Mixed Objectives']) {
        const re = new RegExp('\\[null, (createWorkshopSettingBool\\("Available Objective Types", "' + setting + '"[^)]*\\))\\]');
        assert(re.test(out['global_startup.opy']), 'objectiveTypeVoteList entry not found: ' + setting);
        out['global_startup.opy'] = out['global_startup.opy'].replace(re, (_, e) => { edits++; return e; });
    }
    sub('global_startup.opy', 'objectiveTypeVoteList[ObjectiveType.NO_PREFERENCE] = [null, true]',
        'objectiveTypeVoteList[ObjectiveType.NO_PREFERENCE] = true');
    sub('global_start_menu.opy', 'if zombieVoteList[zombieModeVoteIndex][1] else -1', 'if zombieVoteList[zombieModeVoteIndex] else -1');
    sub('global_start_menu.opy', 'if challengeVoteList[challengeVoteIndex][1] else -1', 'if challengeVoteList[challengeVoteIndex] else -1');
    sub('global_start_menu.opy', 'if objectiveTypeVoteList[objectiveTypeVoteIndex][1] else -1', 'if objectiveTypeVoteList[objectiveTypeVoteIndex] else -1');
    sub('player_start_menu.opy', 'menuChoiceOptions = challengeVoteList.map(lambda option: option[1])', 'menuChoiceOptions = challengeVoteList');
    sub('player_start_menu.opy', 'menuChoiceOptions = zombieVoteList.map(lambda option: option[1])', 'menuChoiceOptions = zombieVoteList');
    sub('player_start_menu.opy', 'menuChoiceOptions = objectiveTypeVoteList.map(lambda option: option[1])', 'menuChoiceOptions = objectiveTypeVoteList');
    return { files: out, edits };
}

async function main() {
    await compiler.readyPromise;
    const base = readTree(src);
    const baseline = await compileQ(base);
    console.log('baseline:', baseline.elements, 'elements,', baseline.warnings.length, 'warnings');

    const r = flattenVoteLists(base);
    const compiled = await compileQ(r.files);
    console.log(`flatten vote lists (${r.edits} edits) => ${compiled.elements} (delta ${compiled.elements - baseline.elements}), warnings ${compiled.warnings.length}`);
    for (const w of compiled.warnings.slice(0, 5)) console.log('    warn:', String(w.message || w).slice(0, 200));
}
main().catch(e => { console.error(e); process.exit(1); });
