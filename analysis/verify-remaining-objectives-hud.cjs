// Verify the Kill Zone/Zombie Egg HUD helper preserves initial colors, dynamic visibility and ID cleanup.
// On success, rebuild src/main.ws.txt and save remaining-objectives-hud-validation-2026-11-03.json.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src, editBlock} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {checkWorkshop} = require('./verify-global-temporaries.cjs');
const baselineRef = '3a212d6';
const call = 'Call Subroutine(createRemainingObjectivesHud);';
const colors = ['Color(Red)', 'Color(Lime Green)'];
const hudAction = 'Create HUD Text(All Players(All Teams), Null, Custom String("Objectives Remaining: {0}", Subtract(Count Of(Global.objectivePositionList), True)), Null, Top, True, Null, Global.tmp2, Null, Visible To, Default Visibility);';
const registerId = 'Modify Global Variable(objectiveEntityIdList, Append To Array, Last Text ID);';

function actions(rule) {
    const text = rule.body.split('actions {\n')[1];
    assert(text, 'Missing HUD-helper actions');
    return text.replace(/\n\}$/, '').split('\n').filter(Boolean);
}

function auditHelper(body) {
    assert.equal(body.length, 2, 'HUD helper must remain two synchronous actions with immediate ID registration');
    assert.equal(body[0], hudAction, 'HUD parameters or initial-color reevaluation contract changed');
    assert.equal(body[1], registerId, 'HUD ID must be registered immediately after its creation');
}

function auditCaller(body) {
    const positions = body.flatMap((a, i) => a === call ? [i] : []);
    assert.equal(positions.length, 2, 'Expected exactly two shared HUD calls');
    positions.forEach((i, n) => assert.equal(body[i - 1], `Set Global Variable(tmp2, ${colors[n]});`,
        'Assign the original initial color immediately before the synchronous HUD call'));
}

function prepareScratchAudit(output) {
    const compiled = rules(output);
    const helper = compiled.find(r => r.body.includes('\ncreateRemainingObjectivesHud;\n'));
    assert(helper, 'Missing shared HUD helper');
    auditHelper(actions(helper));
    assert(!/Start Rule\(createRemainingObjectivesHud,/.test(output), 'HUD helper must never start asynchronously');
    assert.equal((output.match(/Call Subroutine\(createRemainingObjectivesHud\)/g) || []).length, 2);
    const caller = compiled.filter(r => r.name === 'objectivesManagement');
    assert.equal(caller.length, 1);
    auditCaller(actions(caller[0]));
    let removed = 0, summarized = 0;
    const result = output.replace(/^rule \("((?:\\.|[^"\\])*)"\) \{\n([\s\S]*?)^\}/gm, (rule, name, body) => {
        if (/^\s*createRemainingObjectivesHud;$/m.test(body)) {removed++; return '';}
        return rule.replace(/^( *)Call Subroutine\(createRemainingObjectivesHud\);[^\n]*$/gm, (line, indent) => {
            summarized++;
            // The audited ID append neither reads/writes scratch nor yields. Summarize scratch input
            // consumption with the create action only, preserving parent action counts and skip offsets.
            return indent + hudAction;
        });
    });
    assert.equal(removed, 1);
    assert.equal(summarized, 2);
    return result;
}

async function main() {
    const file = 'subroutines.opy';
    const historicalBaseline = {...files, [file]: execFileSync('git', ['show', `${baselineRef}:src/${file}`],
        {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n')};
    // Reverse only HUD extraction, retaining unrelated changes such as the cleanup ID snapshot.
    const baseline = {...files};
    assert(baseline[file].includes('subroutine createRemainingObjectivesHud\n'));
    baseline[file] = baseline[file].replace('subroutine createRemainingObjectivesHud\n', '')
        .replace(/^#!define remainingObjectivesHudColor tmp2\n/m, '');
    editBlock(baseline, file, 'def createRemainingObjectivesHud():', () => '');
    for (const color of ['RED', 'LIME_GREEN']) {
        const handoff = `        remainingObjectivesHudColor = Color.${color}\n        createRemainingObjectivesHud()`;
        assert.equal(baseline[file].split(handoff).length - 1, 1);
        baseline[file] = baseline[file].replace(handoff,
            `        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.${color}, HudReeval.VISIBILITY)\n        objectiveEntityIdList.append(getLastCreatedText())`);
    }
    await compiler.readyPromise;
    const before = await compile(baseline), after = await compile(files);
    const historical = await compile(historicalBaseline);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.deepEqual(historical.warnings, []);
    assert.equal(before.elements - after.elements, 6);
    const original = rules(before.result), updated = rules(after.result);
    const historicalCaller = rules(historical.result).find(r => r.name === 'objectivesManagement');
    for (const color of colors)
        assert(historicalCaller.body.includes(hudAction.replace('Global.tmp2', color) + '\n' + registerId),
            'HUD reference must still match the original creation and ID registration');
    const helper = updated.find(r => r.body.includes('\ncreateRemainingObjectivesHud;\n'));
    assert(helper, 'Missing shared HUD helper');
    auditHelper(actions(helper));
    const originalsInOrder = updated.filter(r => r !== helper);
    assert.equal(originalsInOrder.length, original.length);
    let restoredCalls = 0;
    for (let i = 0; i < original.length; i++) {
        const current = originalsInOrder[i];
        assert.equal(current.name, original[i].name);
        if (current.name !== 'objectivesManagement') {assert.deepEqual(current, original[i]); continue;}
        auditCaller(actions(current));
        let restored = current.body;
        for (const color of colors) {
            const handoff = `Set Global Variable(tmp2, ${color});\n` + call;
            assert.equal(restored.split(handoff).length - 1, 1);
            restored = restored.replace(handoff, hudAction.replace('Global.tmp2', color) + '\n' + registerId);
            restoredCalls++;
        }
        assert.equal(restored, original[i].body, 'HUD text/colors, visibility, creation order or cleanup registration changed');
    }
    assert.equal(restoredCalls, 2);
    const expanded = prepareScratchAudit(after.result);
    const scratch = checkWorkshop(expanded);
    assert.deepEqual(checkWorkshop(after.result), scratch, 'Generic audit must validate the same HUD contract');
    assert.throws(() => auditHelper([...actions(helper), 'Wait(1, Ignore Condition);']), /two synchronous/);
    assert.throws(() => auditHelper([hudAction.replace(', Visible To,', ', Visible To and Color,'), registerId]),
        /reevaluation contract/);
    assert.throws(() => auditHelper([hudAction]), /ID registration/);
    assert.throws(() => checkWorkshop(after.result.replace(call, 'Wait(1, Ignore Condition);\n        ' + call)),
        /immediately before/);

    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', src.replace(/\\/g, '/') + '/', 'main.opy');
    } finally {console.log = saved;}
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result), updated);
    for (const [name, text] of Object.entries(files))
        assert.equal(fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n'), text, 'Concurrent source edit');
    fs.writeFileSync(path.join(src, 'main.ws.txt'), exported.result);
    const all = Object.values(files).join('\n');
    const report = {date: '2026-11-03', compiler: 'OverPy 9.7.20', baselineSubroutinesRef: baselineRef,
        baselineMethod: 'Reverse only shared HUD extraction in current sources; additionally check both HUD actions against the historical implementation.',
        before: before.elements, after: after.elements, saved: before.elements - after.elements,
        globalVariables: (all.match(/^globalvar /gm) || []).length, playerVariables: (all.match(/^playervar /gm) || []).length,
        originalCompiledRulesCompared: original.length, synchronousHelperCalls: 2, helperContainsAsyncWork: false,
        initialColorsPreserved: true, colorReevaluated: false, dynamicRecipientsPreserved: true,
        textSortOrderAndPlacementPreserved: true, immediateIdRegistrationPreserved: true,
        creationOrderAndCleanupPreserved: true, scratchRulesChecked: scratch.length, negativeAuditCases: 4,
        scratchMethod: 'Validate the exact two-action helper and initial-color handoffs; summarize its scratch input consumption with the HUD creation action, retaining parent action counts and skip offsets.',
        directIncludeBuildChecked: true, emittedWarnings: [], warningsSuppressedByMainSource: true,
        inGameValidated: false, runtimeBenchmarked: false,
        subroutinesSha256: crypto.createHash('sha256').update(files[file]).digest('hex')};
    fs.writeFileSync(path.join(__dirname, 'remaining-objectives-hud-validation-2026-11-03.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report));
}

module.exports = {prepareScratchAudit};
if (require.main === module) main().catch(e => {console.error(e); process.exitCode = 1;});
