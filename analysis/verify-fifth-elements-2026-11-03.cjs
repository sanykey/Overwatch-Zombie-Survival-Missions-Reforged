// Validate the implemented reductions against the preceding commit and rebuild Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {variants} = require('./probe-fifth-elements-2026-11-03.cjs');
const baselineRef = '7795862';

const selected = [
    'vote_challenge', 'vote_zombie', 'vote_objective', 'vote_enhancement',
    'shared_bot_throttle', 'shared_pregame_attach', 'shared_extraction_chase',
    'shared_reignited_warning_pair',
];

function checkVoteTransitions() {
    let checked = 0;
    for (let length = 1; length <= 11; length++)
        for (let enabledMask = 1; enabledMask < (1 << length); enabledMask++)
            for (let start = 0; start < length; start++)
                for (const backwards of [false, true]) {
                    const enabled = index => Boolean(enabledMask & (1 << index));
                    let original = start;
                    do {
                        original = backwards ? (original + length - 1) % length :
                            (original + 1) % length;
                    } while (!enabled(original));
                    const offset = backwards ? length - 1 : 1;
                    let optimized = start;
                    do { optimized = (optimized + offset) % length; }
                    while (!enabled(optimized));
                    assert.equal(optimized, original,
                        `Vote transition: ${length}, ${enabledMask}, ${start}, ${backwards}`);
                    checked++;
                }
    return checked;
}

async function main() {
    const voteTransitionsChecked = checkVoteTransitions();
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `${baselineRef}:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const expectedFiles = {...baseline};
    for (const name of selected) variants[name](expectedFiles);
    for (const [file, contents] of Object.entries(expectedFiles))
        assert.equal(files[file], contents, `Source differs from measured variant: ${file}`);

    // compile() temporarily suppresses compiler logging, so run sequentially.
    const before = await compile(baseline);
    const expected = await compile(expectedFiles);
    const after = await compile(files);
    assert.equal(before.elements, 26067);
    assert.equal(expected.elements, 25925);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(rules(after.result), rules(expected.result),
        'Implemented Workshop actions differ from measured variants');

    // The unchanged bot pivot pair has its separately audited tmp1 handoff.
    const withoutBotHelper = after.result.replace(
        /^rule \("(?:teleportBots|setClosestPlayerTeleportCenter)"\) \{[\s\S]*?^\}/gm, '');
    const scratch = checkWorkshop(withoutBotHelper);
    let included;
    const savedLog = console.log;
    try {
        console.log = () => {};
        included = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = savedLog;}
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), rules(after.result));
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    const report = {date: '2026-11-03', baselineRef, before: before.elements, after: after.elements,
        saved: before.elements - after.elements,
        rulesCompared: rules(after.result).length,
        voteTransitionsChecked,
        scratchRulesCheckedExcludingExistingBotHelper: scratch.length,
        directIncludeBuild: true, emittedWarnings: 0, inGameValidated: false};
    fs.writeFileSync(path.join(__dirname, 'fifth-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
