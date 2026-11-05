// Execute the compiled battery eligibility/activation with controlled players.
// --export refreshes main.ws.txt only after all checks pass. No Overwatch runtime required.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args, checkWorkshop} = require('./verify-global-temporaries.cjs');
const root = path.resolve(__dirname, '..');
const baselineRef = '8716c5a';
const ruleName = 'CHARGE BATTERY (USAGE AND COOLDOWNS)';
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const position = slot('enhancementBatteryPosition');
const cooldown = slot('enhancementBatteryReuseCooldown');
const duration = slot('enhancementBatteryReuseDuration');
const actions = rule => rule.body.split('actions {\n')[1].replace(/\n\}$/, '').split('\n');
const conditions = rule => rule.body.split('conditions {\n')[1].split('\n}')[0].split('\n');

function evaluate(expr, state, element) {
    if (expr === 'Null') return null;
    if (expr === 'True') return true;
    if (expr === 'False') return false;
    if (/^-?\d+(?:\.\d+)?$/.test(expr)) return Number(expr);
    if (expr === 'Event Player') return state.owner;
    if (expr === 'Current Array Element') return element;
    if (expr.startsWith('Global.')) return state.globals[expr.slice(7)];
    const field = expr.match(/^\((Event Player|Current Array Element)\)\.(\w+)$/);
    if (field) return evaluate(field[1], state, element)[field[2]];
    const name = expr.slice(0, expr.indexOf('(')), a = args(expr);
    const value = index => evaluate(a[index], state, element);
    switch (name) {
        case 'First Of': return value(0)[0] ?? null;
        case 'All Living Players':
            assert.equal(a[0], 'Team 1');
            return state.living.filter(player => player.alive);
        case 'Filtered Array': return value(0).filter(player => evaluate(a[1], state, player));
        case 'Is True For Any': return value(0).some(player => evaluate(a[1], state, player));
        case 'And': return value(0) && value(1);
        case 'Has Spawned': return value(0).spawned;
        case 'Is Alive': return value(0).alive;
        case 'Ultimate Charge Percent': return value(0).ult;
        case 'Distance Between': {
            const point = p => Array.isArray(p) ? p : p.position;
            const from = point(value(0)), to = point(value(1));
            return Math.hypot(...from.map((v, i) => v - to[i]));
        }
        case 'Multiply': return value(0) * value(1);
        case 'Add': return value(0) + value(1);
        case 'Compare':
            if (a[1] === '==') return value(0) === value(2);
            if (a[1] === '<') return value(0) < value(2);
            throw new Error('Unsupported comparison: ' + expr);
        default: throw new Error('Unsupported expression: ' + expr);
    }
}

// Stop at the cooldown loop: its complete compiled tail is compared with the baseline below.
function activate(body, state) {
    for (const action of body) {
        const name = action.slice(0, action.indexOf('(')), a = args(action);
        if (name === 'Set Global Variable') {
            assert.equal(a[0], 'tmp0');
            state.globals[a[0]] = evaluate(a[1], state);
        } else if (name === 'Abort If') {
            if (evaluate(a[0], state)) return;
        } else if (name === 'Play Effect') {
            state.effects.push(action);
        } else if (name === 'Set Ultimate Charge') {
            const player = evaluate(a[0], state);
            state.charges.push({id: player.id, amount: evaluate(a[1], state) - player.ult});
        } else if (name === 'Set Player Variable') {
            assert.equal(a[1], cooldown);
            state.owner[a[1]] = evaluate(a[2], state);
        } else if (name === 'While') {
            return;
        } else {
            throw new Error('Unsupported action: ' + action);
        }
    }
}

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    const before = await compile({...files, 'enhancements.opy': execFileSync('git',
        ['show', baselineRef + ':src/enhancements.opy'], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n')});
    assert.deepEqual(build.warnings, []);
    assert.deepEqual(before.warnings, []);
    const compiled = rules(build.result), baseline = rules(before.result);
    assert.deepEqual(compiled.filter(r => r.name !== ruleName), baseline.filter(r => r.name !== ruleName));
    const rule = compiled.find(r => r.name === ruleName), oldRule = baseline.find(r => r.name === ruleName);
    const body = actions(rule), oldBody = actions(oldRule);
    assert.deepEqual(conditions(rule).slice(0, -1), conditions(oldRule).slice(0, -1));
    assert(conditions(rule).includes(`(Event Player).${position} != False;`), 'Preserve the placement truthiness check');
    assert.equal(body[1], 'Abort If(Compare(Global.tmp0, ==, Null));');
    assert.deepEqual(body.slice(2), oldBody.slice(1), 'Feedback, charge amount and cooldown flow must stay unchanged');
    const selection = args(args(body[0])[1])[0]; // First Of(Filtered Array(...)) -> Filtered Array(...)
    const [source, predicate] = args(selection);
    assert.equal(source, 'Global.playerTargetList');
    const eligibility = conditions(rule).at(-1).replace(/ == True;$/, '');
    assert.equal(eligibility, `Is True For Any(${source}, ${predicate})`, 'Activation and selection must share eligibility');
    const rawRule = [...build.result.matchAll(/^rule \("((?:\\.|[^"\\])*)"\) \{\n[\s\S]*?^\}/gm)]
        .find(match => match[1] === ruleName)[0];
    const scratch = checkWorkshop(rawRule);

    const player = (id, ult = 50, distance = 1, sizeScale = 1, extra = {}) =>
        ({id, ult, position: [distance, 0, 0], sizeScale, alive: true, spawned: true, ...extra});
    const cases = [
        {name: 'full player first', targets: [player('full', 100, 0.5), player('eligible')], recipient: 'eligible'},
        {name: 'large player beyond 1.5 m', targets: [player('large', 50, 2, 2)], recipient: 'large'},
        {name: 'small player outside scaled radius', targets: [player('small', 50, 1, 0.5)]},
        {name: 'exact scaled boundary excluded', targets: [player('boundary', 50, 3, 2)]},
        {name: 'inside scaled boundary', targets: [player('inside', 50, 2.99, 2)], recipient: 'inside'},
        {name: 'empty target list', targets: []},
        {name: 'only full player', targets: [player('full', 100)]},
        {name: 'first eligible preserves list order', targets: [player('first', 90), player('second', 10, 0.1)], recipient: 'first'},
        {name: 'dead player retained in target list', targets: [player('dead', 50, 0.5, 1, {alive: false}), player('alive')], recipient: 'alive'},
        {name: 'unspawned player retained in target list', targets: [player('unspawned', 50, 0.5, 1, {spawned: false})]},
        {name: 'no charge despite nearby living outsiders', targets: []},
        {name: 'zero ultimate charge', targets: [player('empty', 0)], recipient: 'empty'},
        {name: 'target leaves after activation', targets: [player('gone')], atAction: []},
        {name: 'target becomes fully charged after activation', targets: [player('changed')], atAction: [player('changed', 100)]},
        {name: 'target dies after activation', targets: [player('changed')], atAction: [player('changed', 50, 1, 1, {alive: false})]},
        {name: 'next eligible replaces stale recipient', targets: [player('changed'), player('next')],
            atAction: [player('changed', 100), player('next')], recipient: 'next'},
    ];
    for (const test of cases) {
        const state = {owner: {[position]: [0, 0, 0], [cooldown]: 0, [duration]: 10},
            globals: {playerTargetList: test.targets, tmp0: player('stale')}, effects: [], charges: []};
        // Deliberately provide living players outside the target list; selection must ignore them.
        state.living = [...test.targets, player('outsider', 0, 0.1)];
        assert.equal(evaluate(eligibility, state), Boolean(test.recipient || test.atAction), test.name);
        if (test.atAction) state.globals.playerTargetList = test.atAction;
        activate(body, state); // Also exercise the defensive abort when no condition would activate the rule.
        assert.deepEqual(state.charges, test.recipient ? [{id: test.recipient, amount: 15}] : [], test.name);
        assert.equal(state.effects.length, test.recipient ? 3 : 0, test.name);
        assert.equal(state.owner[cooldown], test.recipient ? 10 : 0, test.name);
    }
    // Reproduce both R18 counterexamples using the baseline's compiled selection expression.
    const oldSelection = args(oldBody[0])[1];
    for (const test of cases.slice(0, 2)) {
        const state = {owner: {[position]: [0, 0, 0]}, globals: {playerTargetList: test.targets}, living: test.targets};
        assert.equal(evaluate(oldSelection, state)?.id ?? null, test.name === 'full player first' ? 'full' : null);
    }

    if (process.argv.includes('--export')) {
        const saved = {log: console.log, warn: console.warn, error: console.error};
        let exported;
        try {
            console.log = console.warn = console.error = () => {};
            exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
                'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        } finally {Object.assign(console, saved);}
        assert.equal(exported.nbElements, build.elements);
        assert.deepEqual(exported.encounteredWarnings, []);
        assert.deepEqual(rules(exported.result), compiled);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({scenariosPassed: cases.length, baselineRef, before: before.elements,
        after: build.elements, delta: build.elements - before.elements, warnings: build.warnings.length,
        unchangedOtherRules: compiled.length - 1, scratchRulesChecked: scratch.length,
        exported: process.argv.includes('--export'),
        limitation: 'Compiled eligibility/activation checked with mocked players; in-game verification remains necessary.'}, null, 2));
}
main().catch(error => { console.error(error); process.exitCode = 1; });
