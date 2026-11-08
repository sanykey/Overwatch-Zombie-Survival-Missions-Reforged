// Check compiled charge transitions and pin all existing ability branches/waits.
// --export also rebuilds main.ws.txt through the real include entry point.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const root = path.dirname(src);
const baselineRef = '5da8300';
const chargeSlot = files['variables.opy'].match(/^#!define enhancementBattleResetCharges (\w+)$/m)[1];
const charge = `(Event Player).${chargeSlot}`;
const setCharge = `Set Player Variable(Event Player, ${chargeSlot}, False);`;
const spendCharge = `Modify Player Variable(Event Player, ${chargeSlot}, Subtract, True);`;
const earnName = 'BORN TO BATTLE PLAYER EARNS ELIMINATION';
// OverPy inserts a soft hyphen in "BLOW" in emitted rule names.
const finalBlowName = 'PLAYER DEALT FINAL B\u00adLOW';
const useName = 'BORN TO BATTLE PLAYER USES ABILITY CHARGE';
const description = 'Final blows grant a cooldown reset on the next ability use, storing up to 2 charges';
const hudLine = body => body.split('\n').find(line => line.startsWith('Create HUD Text(Event Player,') && line.includes('Custom String("Born to Battle")'));

// Evaluate actual emitted numeric/HUD values, including OverPy's True/Null constants.
function value(expr, count) {
    if (expr === charge) return count;
    if (expr === 'True') return 1;
    if (expr === 'False' || expr === 'Null') return 0;
    if (expr === 'Empty Array') return [];
    if (/^\d+$/.test(expr)) return Number(expr);
    if (expr.startsWith('"')) return JSON.parse(expr);
    const a = args(expr), v = i => value(a[i], count);
    switch (expr.slice(0, expr.indexOf('('))) {
        case 'Array': return a.map(item => value(item, count));
        case 'Value In Array': return v(0)[v(1)];
        case 'Char In String': return v(0)[v(1)] ?? '';
        case 'Icon String': assert.equal(a[0], 'Checkmark'); return '✓';
        case 'Custom String': return v(0).replace(/\{(\d+)\}/g, (_, i) => v(Number(i) + 1));
        default: throw new Error('Unsupported expression: ' + expr);
    }
}

function modify(action, count) {
    assert(action.startsWith('Modify Player Variable('), action);
    const a = args(action);
    assert.equal(a[0], 'Event Player');
    assert.equal(a[1], chargeSlot);
    assert(['Add', 'Subtract'].includes(a[2]));
    return count + (a[2] === 'Add' ? 1 : -1) * value(a[3], count);
}

async function main() {
    await compiler.readyPromise;
    // Read a complete historical tree so subsequent modules/enums do not leak
    // into the old compilation. Scope comparisons to Born to Battle itself.
    const baseline = {};
    const paths = execFileSync('git', ['ls-tree', '-r', '--name-only', baselineRef, '--', 'src'],
        {cwd: root, encoding: 'utf8'}).trim().split('\n').filter(file => file.endsWith('.opy'));
    for (const file of paths) {
        const name = file === 'src/includes.opy' ? 'main.opy' : file.slice(4);
        baseline[name] = execFileSync('git', ['show', `${baselineRef}:${file}`],
            {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const current = new Map(newRules.map(rule => [rule.name, rule.body]));
    const enhancementId = files['variables.opy'].match(/^\s+BORN_TO_BATTLE = (\d+),$/m)[1];
    const abilityRules = oldRules.filter(rule => [earnName, useName, 'resetBattleAbilityCharge'].includes(rule.name));
    assert.equal(abilityRules.length, 3);
    for (const rule of abilityRules) {
        // Kevlar's move to Augments compacted the primary enhancement IDs.
        let expected = rule.body.replace('(Event Player).enhancementId == 7;',
            `(Event Player).enhancementId == ${enhancementId};`);
        if (rule.name === earnName) {
            // Earning moved into the shared Team 1 final-blow handler. The nested
            // charge-cap check compiles to Skip If; it must skip only the increment.
            assert(!current.has(earnName));
            assert(current.get(finalBlowName).startsWith([
                'event {', 'Player Dealt Final Blow;', 'Team 1;', 'All;', '}', 'actions {',
                `If(Compare((Event Player).enhancementId, ==, ${enhancementId}));`,
                `Skip If(Compare(${charge}, >=, 2), True);`,
                `Modify Player Variable(Event Player, ${chargeSlot}, Add, True);`,
                'End;', 'Abort If('
            ].join('\n')));
            continue;
        } else if (rule.name === useName) {
            expected = expected.replace(`${charge} == True;`, `${charge} > Null;`)
                .replaceAll(setCharge, spendCharge);
        } else if (rule.name === 'resetBattleAbilityCharge') {
            expected = expected.replace(setCharge, spendCharge);
        }
        assert.equal(current.get(rule.name), expected, 'Unexpected change in ' + rule.name);
    }
    assert(newRules.some(rule => rule.body.includes(description)));
    const init = current.get('PLAYER ENHANCEMENT INITIALIZATION');
    assert(init.includes(hudLine(init) + '\n' + `Set Player Variable(Event Player, ${chargeSlot}, Null);`));
    const earn = current.get(finalBlowName);
    assert(earn.includes(`Skip If(Compare(${charge}, >=, 2), True);`));
    assert(current.get(useName).includes(`${charge} > Null;`));
    const earnAction = earn.split('\n').find(line => line.startsWith('Modify Player Variable('));
    const spendActions = [useName, 'resetBattleAbilityCharge'].flatMap(name =>
        current.get(name).split('\n').filter(line => line.startsWith('Modify Player Variable(')));
    assert.equal(spendActions.length, 3, 'Charge, cooldown and special hero branches must each spend one');
    const hud = args(hudLine(current.get('PLAYER ENHANCEMENT INITIALIZATION')))[2];
    for (const count of [0, 1, 2]) {
        assert.equal(value(hud, count).trim(), `${count}/2 resets`);
        // Only final-blow events below the cap run the earned-charge action.
        assert.equal(count < 2 ? modify(earnAction, count) : count, [1, 2, 2][count]);
        for (const spend of spendActions) {
            if (count > 0) assert.equal(modify(spend, count), count - 1);
        }
    }
    // A final blow during an existing ability wait must survive the later reset.
    for (const spend of spendActions) assert.equal(modify(spend, modify(earnAction, 1)), 1);
    if (process.argv.includes('--export')) {
        const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        assert.equal(exported.nbElements, after.elements);
        assert.deepEqual(exported.encounteredWarnings, []);
        assert.deepEqual(rules(exported.result), newRules);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({elements: after.elements, warnings: after.warnings.length,
        abilityRulesChecked: abilityRules.length, chargeSpendingBranches: spendActions.length,
        exported: process.argv.includes('--export'),
        limitation: 'Compiled transitions and preserved branches checked; no in-game scheduler emulation.'}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
