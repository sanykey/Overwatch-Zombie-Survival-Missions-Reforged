// Run the compiled selection actions with controlled visibility; no Overwatch runtime required.
// --export also refreshes the root Workshop export after all checks pass.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const root = path.resolve(__dirname, '..');
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const fields = Object.fromEntries(['botTarget', 'botLastTarget', 'botCandidateTarget', 'botIsSelectingTarget',
    'botIsThrottleOverridden', 'botIsFacingOverridden'].map(name => [name, slot(name)]));

// Interpret only the emitted control flow and selection expressions. Movement actions are
// recorded, not simulated. Unknown instructions fail so compiler changes cannot pass silently.
function execute(actions, state) {
    const value = expr => {
        if (expr === 'Null') return null;
        if (expr === 'True') return true;
        if (expr === 'False') return false;
        if (/^-?\d+$/.test(expr)) return Number(expr);
        if (expr === 'Event Player') return state.player;
        if (expr === 'Current Array Element') return state.element;
        if (expr.startsWith('Global.')) return state.globals[expr.slice(7)];
        const field = expr.match(/^\((Event Player|Current Array Element)\)\.(\w+)$/);
        if (field) return value(field[1])[field[2]];
        const name = expr.slice(0, expr.indexOf('(')), a = args(expr);
        switch (name) {
            case 'Count Of': return value(a[0]).length;
            case 'Value In Array': return value(a[0])[Number(value(a[1]))];
            case 'Filtered Array': return value(a[0]).filter(item => {
                state.element = item;
                return value(a[1]);
            });
            case 'Not': return !value(a[0]);
            case 'Compare':
                assert.equal(a[1], '!=');
                return value(a[0]) !== value(a[2]);
            case 'Is Alive': return state.alive;
            case 'Eye Position': return value(a[0]);
            case 'Position Of': return 0;
            case 'Add': return 0;
            case 'Is In Line of Sight': {
                const candidate = value(a[0]);
                state.checked.push(candidate.id);
                return candidate.visible;
            }
            default: throw new Error('Unsupported expression: ' + expr);
        }
    };
    function run(start, end) {
        for (let i = start; i < end; i++) {
            const action = actions[i], name = action.split('(')[0], a = action.includes('(') ? args(action) : [];
            if (name === 'If' || name === 'For Global Variable') {
                let depth = 1, close = i + 1;
                const branches = [i];
                for (; close < end; close++) {
                    if (/^(If|For Global Variable)\(/.test(actions[close])) depth++;
                    if (actions[close] === 'End;') depth--;
                    if (!depth) break;
                    if (depth === 1 && /^Else If\(/.test(actions[close])) branches.push(close);
                }
                assert(close < end, 'Unclosed control flow');
                if (name === 'For Global Variable') {
                    for (state.globals[a[0]] = Number(value(a[1]));
                        state.globals[a[0]] < Number(value(a[2])); state.globals[a[0]] += Number(value(a[3]))) {
                        if (run(i + 1, close) === 'break') break;
                    }
                } else {
                    for (let b = 0; b < branches.length; b++) {
                        if (!value(args(actions[branches[b]])[0])) continue;
                        if (run(branches[b] + 1, branches[b + 1] ?? close) === 'break') return 'break';
                        break;
                    }
                }
                i = close;
            } else if (name === 'Set Player Variable') {
                state.player[a[1]] = value(a[2]);
            } else if (name === 'Set Global Variable') {
                state.globals[a[0]] = value(a[1]);
            } else if (name === 'Skip If') {
                if (value(a[0])) i += Number(value(a[1]));
            } else if (action === 'Break;') {
                return 'break';
            } else if (['Start Rule', 'Start Throttle In Direction', 'Start Facing'].includes(name)) {
                state.calls.push(name);
            } else {
                throw new Error('Unsupported action: ' + action);
            }
        }
    }
    run(0, actions.length);
}

async function main() {
    await compiler.readyPromise;
    // Use the real entry point so the export retains source paths in compiler comments.
    const saved = {log: console.log, warn: console.warn, error: console.error};
    let result;
    try {
        console.log = console.warn = console.error = () => {};
        result = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { Object.assign(console, saved); }
    const build = {result: result.result, elements: result.nbElements, warnings: result.encounteredWarnings};
    assert.deepEqual(build.warnings, []);
    const compiled = rules(build.result);
    const selection = compiled.find(r => r.name === 'selectTarget').body.split('actions {\n')[1]
        .replace(/\n\}$/, '').split('\n');
    const filter = selection.findIndex(a => a.startsWith('Set Global Variable(tmp1, Filtered Array('));
    assert(filter >= 0, 'Missing invisibility filter');
    const actions = selection.slice(filter);
    assert(!actions.some(a => /^(Wait|Call Subroutine|While)\(/.test(a)), 'Selection must not yield');
    const old = {id: 'old', visible: false}, a = {id: 'A', visible: false}, b = {id: 'B', visible: false};
    const visibleA = {...a, visible: true}, visibleB = {...b, visible: true};
    const cases = [
        {name: 'both behind walls', candidates: [a, b], expected: null, checked: ['A', 'B']},
        {name: 'empty list with stale candidate', candidates: [], expected: null, checked: []},
        {name: 'all invisible', candidates: [{...visibleA, invisibilityCount: 1}], expected: null, checked: []},
        {name: 'second candidate visible', candidates: [a, visibleB], expected: visibleB, checked: ['A', 'B']},
        {name: 'first visible preserves priority', candidates: [visibleA, visibleB], expected: visibleA, checked: ['A']},
        {name: 'invisible priority candidate skipped', candidates: [{...visibleA, invisibilityCount: 1}, visibleB], expected: visibleB, checked: ['B']},
        {name: 'dead bot cannot acquire', candidates: [visibleA], expected: old, alive: false, checked: ['A']},
        {name: 'dead bot cannot change movement', candidates: [], expected: old, alive: false, checked: []},
        {name: 'already searching without a target', candidates: [], initial: null, expected: null, checked: []},
    ];
    let runs = 0;
    for (const test of cases) for (const throttleOverride of [false, true]) for (const facingOverride of [false, true]) {
        const initial = Object.hasOwn(test, 'initial') ? test.initial : old;
        const state = {
            alive: test.alive ?? true, checked: [], calls: [], globals: {tmp1: test.candidates},
            player: {[fields.botTarget]: initial, [fields.botLastTarget]: old, [fields.botCandidateTarget]: old,
                [fields.botIsSelectingTarget]: true, [fields.botIsThrottleOverridden]: throttleOverride,
                [fields.botIsFacingOverridden]: facingOverride},
        };
        execute(actions, state);
        assert.equal(state.player[fields.botTarget], test.expected, test.name);
        assert.deepEqual(state.checked, test.checked, test.name);
        const acquired = state.alive && test.expected !== null && test.expected !== old;
        assert.equal(state.player[fields.botLastTarget], acquired ? test.expected : old, test.name);
        assert.equal(state.player[fields.botCandidateTarget], test.candidates.find(c => !c.invisibilityCount && c.visible) ?? null, test.name);
        assert.equal(state.player[fields.botIsSelectingTarget], false, test.name);
        assert.deepEqual(state.calls, acquired ? ['Start Rule'] : state.alive && initial !== null
            ? [...(!throttleOverride ? ['Start Throttle In Direction'] : []), ...(!facingOverride ? ['Start Facing'] : [])] : [], test.name);
        runs++;
    }

    // Macro extraction must leave the existing deselection rule and every other rule unchanged.
    const baselineFiles = {...files};
    for (const file of ['subroutines.opy', 'bots_game_in_progress.opy']) {
        baselineFiles[file] = execFileSync('git', ['show', 'HEAD:src/' + file], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const baseline = await compile(baselineFiles);
    assert.deepEqual(compiled.filter(r => r.name !== 'selectTarget'), rules(baseline.result).filter(r => r.name !== 'selectTarget'));
    if (process.argv.includes('--export')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    console.log(JSON.stringify({scenariosPassed: runs, elements: build.elements, warnings: build.warnings.length,
        unchangedOtherRules: compiled.length - 1, exported: process.argv.includes('--export'),
        limitation: 'Executes compiled selection control flow with mocked line of sight; movement and in-game visibility need an Overwatch check.'}, null, 2));
}
main().catch(error => { console.error(error); process.exitCode = 1; });
