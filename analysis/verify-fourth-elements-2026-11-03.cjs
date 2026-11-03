// Compare the implemented reductions with the measured source transforms and rebuild Workshop output.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const {variants} = require('./probe-fourth-elements-2026-11-03.cjs');

function indexedRules(output) {
    const counts = new Map();
    return rules(output).map(rule => {
        const occurrence = (counts.get(rule.name) || 0) + 1;
        counts.set(rule.name, occurrence);
        return {name: `${rule.name}#${occurrence}`, body: rule.body};
    }).sort((a, b) => a.name.localeCompare(b.name));
}

async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(file => [file,
        execFileSync('git', ['show', `HEAD:src/${file}`], {encoding: 'utf8'})
            .replace(/\r\n/g, '\n')]));
    const measured = {...baseline};
    for (const transform of Object.values(variants)) transform(measured);
    // compile() temporarily suppresses compiler logging, so run these sequentially.
    const before = await compile(baseline);
    const expected = await compile(measured);
    const after = await compile(files);
    assert.equal(before.elements, 26139);
    assert.equal(expected.elements, 26067);
    assert.equal(after.elements, expected.elements);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(indexedRules(after.result), indexedRules(expected.result),
        'Implemented Workshop actions differ from measured variants');

    // The unchanged teleport pivot pair has a separately audited synchronous tmp1 handoff.
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
    assert.deepEqual(indexedRules(included.result), indexedRules(after.result));
    for (const [file, contents] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, file), 'utf8').replace(/\r\n/g, '\n'), contents,
            `Source changed during validation: ${file}`);
    fs.writeFileSync(path.join(src, 'main.ws.txt'), included.result);
    const report = {date: '2026-11-03', before: before.elements, after: after.elements,
        saved: before.elements - after.elements,
        rulesCompared: indexedRules(after.result).length,
        scratchRulesCheckedExcludingExistingBotHelper: scratch.length,
        directIncludeBuild: true, emittedWarnings: 0, inGameValidated: false};
    fs.writeFileSync(path.join(__dirname, 'fourth-elements-validation-2026-11-03.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
