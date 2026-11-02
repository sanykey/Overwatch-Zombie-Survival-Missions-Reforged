const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const sharing = require('./player-slot-sharing.cjs');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {inventory, codeOnly} = require('./audit-player-variables.cjs');
const root = path.resolve(__dirname, '..');

function baselineFiles() {
    return Object.fromEntries(Object.keys(files).map(file => [file, execFileSync('git',
        ['show', `${sharing.baselineRef}:src/${file}`], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')]));
}

function checkLayout(f) {
    const actual = inventory(f);
    assert.equal(actual.length, 74);
    assert.equal((Object.values(f).join('\n').match(/^globalvar /gm) || []).length, 99);
    assert.deepEqual(actual.map(v => v.name).sort(), sharing.variables.map(v => v.name).sort());
    for (const v of sharing.variables) {
        const found = actual.find(a => a.name === v.name);
        assert.deepEqual(found.aliases.sort(), v.aliases.map(a => a.name).sort(), v.name);
        for (const a of v.aliases) assert(found.references.some(r => r.symbols.includes(a.name)), 'Unused alias: ' + a.name);
        if (sharing.sets.some(s => s.name === v.name)) assert(!found.references.some(r => r.symbols.includes(v.name)),
            'Gameplay must use a role alias: ' + v.name);
    }
    assert(!/\b(?:setTeam|swapTeam)\(/.test(Object.values(f).map(codeOnly).join('\n')),
        'Team changes require a new ownership audit');
    return actual;
}

function blocks(f) {
    const result = [];
    for (const [file, source] of Object.entries(f)) {
        const headers = [...source.matchAll(/^(rule "([^"]+)"|(?:def|macro) (\w+)\([^\n]*):/gm)];
        for (let i = 0; i < headers.length; i++) {
            const h = headers[i], body = source.slice(h.index, headers[i+1]?.index ?? source.length);
            const team = body.match(/^    @Team ([12])/m)?.[1];
            result.push({file, name: h[3] || h[2], isRule: !!h[2],
                body: body.split('\n').map(codeOnly).join('\n'),
                owners: new Set(h[2] ? /@Event /.test(body) ? team ? [team] : ['1','2'] : ['global'] : [])});
        }
    }
    const helpers = result.filter(b => !b.isRule);
    let changed;
    do {
        changed = false;
        for (const b of result) for (const h of helpers) {
            if (!new RegExp('(?:\\b' + h.name + '\\(|\\bstartRule\\(' + h.name + '[,)])').test(b.body)) continue;
            for (const owner of b.owners) if (!h.owners.has(owner)) { h.owners.add(owner); changed = true; }
        }
    } while (changed);
    return result;
}

// The call graph audits eventPlayer receivers independently of the rule's file name.
// Non-event receivers are recorded for manual review; compiled-rule equality pins them.
function auditOwners(f) {
    const allBlocks = blocks(f), vars = inventory(f), reviewed = [];
    for (const set of sharing.sets.filter(s => s.name.startsWith('actorTeamSlot'))) {
        for (const [index, name] of set.members.slice(0,2).entries()) {
            const variable = vars.find(v => v.name === name);
            const owner = index === 0 ? '2' : '1';
            const roles = [variable.name, ...variable.aliases];
            for (const r of variable.references) {
                const blockName = r.block.match(/^(?:def|macro) (\w+)/)?.[1] || r.block.match(/^rule "([^"]+)"/)?.[1];
                const block = allBlocks.find(b => b.file === r.file && b.name === blockName);
                assert(block, r.block);
                const direct = roles.some(role => new RegExp('\\beventPlayer\\.' + role + '\\b').test(codeOnly(r.source)));
                const owners = [...block.owners].sort();
                // The objective icon helper explicitly branches on the receiver's team.
                const branch = name === 'botResourceIconIdList' && block.name === 'playerObjectiveEntityManagementMacro';
                const unreachable = direct && !block.isRule && owners.length === 0;
                if (direct && !branch && !unreachable) assert.deepEqual(owners, [owner], name + ' receiver in ' + r.file + ':' + r.line);
                if (unreachable) reviewed.push({role: name, owner, file: r.file, line: r.line,
                    source: r.source, evidence: 'Helper has no event-root caller in the source call graph'});
                if (!direct || branch) reviewed.push({role: name, owner, file: r.file, line: r.line,
                    source: r.source, evidence: branch ? 'else of eventPlayer.getTeam() == Team.1' : 'explicit target/collection receiver; reviewed with rule conditions'});
            }
        }
    }
    return {eventReceiverCallGraphChecked: true, targetReceivers: reviewed};
}

async function main() {
    const baseline = baselineFiles();
    await compiler.readyPromise;
    const before = await compile(baseline);
    const guardedFiles = sharing.guardObjective(sharing.guardMenu({...baseline}));
    const bioFile = 'objective_types/objective_type_biomorphing.opy';
    const bioRule = 'rule "BIOMORPHING GOAL START":';
    const beforeGoal = baseline[bioFile].indexOf(bioRule);
    const afterGoal = guardedFiles[bioFile].indexOf(bioRule);
    assert.equal(guardedFiles[bioFile].slice(0,afterGoal),baseline[bioFile].slice(0,beforeGoal),
        'Objective guards must not change the synchronous biowaste helper macros');
    const expected = await compile(guardedFiles);
    const after = await compile(files);
    assert.equal(before.elements, 27188);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(expected.warnings, []);
    assert.deepEqual(after.warnings, []);
    assert.equal(after.elements, expected.elements);
    const oldRules = rules(expected.result, sharing.mapping), currentRules = rules(after.result);
    assert(oldRules.length > 200);
    assert.deepEqual(currentRules, oldRules, 'Logic changed outside the reviewed menu/objective guards / storage mapping');
    const indexed = checkLayout(files);
    const ownership = auditOwners(baseline);
    const unsafeReceiver = {...baseline, 'subroutines.opy': baseline['subroutines.opy'].replace(
        'eventPlayer.botIsSelectingTarget = true', 'eventPlayer.powerUpTurretPosition = 1')};
    assert.throws(() => auditOwners(unsafeReceiver), /powerUpTurretPosition receiver/,
        'The ownership audit must reject Team 2 writing a Team 1 role');
    // Complete source reconstruction also catches declarations/aliases outside compiled rules.
    const scratchAliases = require('./scratch-role-aliases.cjs');
    const scratchRoleAliases = scratchAliases.check(files);
    const transformed = scratchAliases.apply(sharing.apply({...baseline}));
    for (const file of Object.keys(files)) assert.equal(files[file], transformed[file], 'Unexpected source edit: ' + file);
    const scratch = require('./verify-global-temporaries.cjs').checkWorkshop(after.result);
    let exported;
    const saved = console.log;
    try {
        console.log = () => {};
        exported = await compiler.compile(files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm, ''),
            'en-US', path.join(root,'src').replace(/\\/g,'/')+'/', 'main.opy');
    } finally { console.log = saved; }
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.equal(exported.nbElements, after.elements);
    assert.deepEqual(rules(exported.result), currentRules);
    fs.writeFileSync(path.join(root,'src/main.ws.txt'), exported.result);
    const report = {date: '2026-11-02', baselineRef: sharing.baselineRef,
        before: {playerVariables: 107, globals: 99, elements: before.elements},
        after: {playerVariables: indexed.length, globals: 99, elements: after.elements},
        savedPlayerSlots: 33, aliases: indexed.reduce((n,v) => n+v.aliases.length,0),
        compiledRulesCompared: currentRules.length, scratchRulesChecked: scratch.length,
        scratchRoleAliases,
        warnings: after.warnings, storage: sharing.sets, mapping: sharing.mapping, ownership,
        sourceSha256: Object.fromEntries(Object.entries(files).map(([file,source]) =>
            [file,crypto.createHash('sha256').update(source).digest('hex')])),
        limitations: 'Static source ownership review, call graph, compiled rule equivalence and scratch lifetime checks. No in-game scheduler/renderer test. Import the complete script, not isolated rules.'};
    fs.writeFileSync(path.join(__dirname,'player-slot-sharing-validation.json'), JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'player-variable-validation-2026-11-02.json'), JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({before:report.before,after:report.after,savedPlayerSlots:33,
        aliases:report.aliases,compiledRulesCompared:report.compiledRulesCompared,scratchRulesChecked:scratch.length,warnings:[]}));
    return report;
}
if (require.main === module) main().catch(e => {console.error(e);process.exitCode=1;});
module.exports = {main, baselineFiles, checkLayout, auditOwners};
