// Exercise the compiled timer actions; this does not emulate the game's scheduler or timer chase.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

const baselineRef = '28a18a1';
const actions = rule => rule.body.split('actions {\n')[1].replace(/\n}$/, '').split('\n');
const parsed = new Map();
function expression(text) {
    if (parsed.has(text)) return parsed.get(text);
    const call = text.match(/^([\w ]+)\((.*)\)$/);
    let result = text;
    if (call) {
        const args = [];
        let depth = 0, start = 0;
        for (let i = 0; i < call[2].length; i++) {
            if (call[2][i] === '(') depth++;
            if (call[2][i] === ')') depth--;
            if (call[2][i] === ',' && depth === 0) {
                args.push(expression(call[2].slice(start, i).trim()));
                start = i + 1;
            }
        }
        args.push(expression(call[2].slice(start).trim()));
        result = {name: call[1], args};
    }
    parsed.set(text, result);
    return result;
}

function evaluate(node, state, element) {
    if (typeof node === 'string') {
        if (/^\d+(?:\.\d+)?$/.test(node)) return Number(node);
        if (node === 'True') return true;
        if (node === 'False') return false;
        if (node === 'Null') return 0;
        if (node === 'Match Time') return state.time;
        if (node === 'Global.menuFinaleMotionSlot') return state.hidden;
        if (node === 'Global.isVoting') return state.voting;
        const field = node.match(/^\((Event Player|Current Array Element)\)\.(\w+)$/);
        if (field) {
            const owner = field[1] === 'Event Player' ? state.player : element;
            assert(owner, `Unexpected player access: ${node}`);
            return owner[field[2]];
        }
        throw new Error(`Unsupported value: ${node}`);
    }
    const arg = i => evaluate(node.args[i], state, element);
    switch (node.name) {
        case 'All Players': return state.players;
        case 'Not': return !arg(0);
        case 'And': return arg(0) && arg(1);
        case 'Compare': {
            const left = arg(0), right = arg(2);
            switch (node.args[1]) {
                case '==': return left === right;
                case '>': return left > right;
                case '<': return left < right;
                default: throw new Error(`Unsupported comparison: ${node.args[1]}`);
            }
        }
        case 'Count Of': return arg(0).length;
        case 'Filtered Array': return arg(0).filter(player => evaluate(node.args[1], state, player));
        case 'Is True For All': return arg(0).every(player => evaluate(node.args[1], state, player));
        default: throw new Error(`Unsupported expression: ${node.name}`);
    }
}

function execute(lines, state, compiled) {
    const branches = [];
    const active = () => branches.every(branch => branch.active);
    for (const line of lines) {
        if (line === 'Else;') {
            const branch = branches.at(-1);
            branch.active = branch.parent && !branch.taken;
            branch.taken = true;
        } else if (line === 'End;') {
            assert(branches.pop());
        } else {
            const action = expression(line.replace(/;$/, ''));
            if (action.name === 'If') {
                const parent = active();
                const selected = parent && !!evaluate(action.args[0], state);
                branches.push({parent, active: selected, taken: selected});
            } else if (action.name === 'Else If') {
                const branch = branches.at(-1);
                branch.active = branch.parent && !branch.taken && !!evaluate(action.args[0], state);
                branch.taken ||= branch.active;
            } else if (active()) {
                switch (action.name) {
                    case 'Abort If': if (evaluate(action.args[0], state)) return; break;
                    case 'Set Match Time':
                        state.time = evaluate(action.args[0], state);
                        state.writes.push(state.time);
                        break;
                    case 'Wait': state.waits++; break;
                    case 'Call Subroutine': execute(compiled.get(action.args[0]), state, compiled); break;
                    default: throw new Error(`Unsupported action: ${line}`);
                }
            }
        }
    }
    // OverPy can omit trailing End actions at the end of a rule.
}

function run(lines, compiled, players, options = {}) {
    const state = {players, player: players.at(-1), hidden: 30, voting: false,
        time: 30, writes: [], waits: 0, ...options};
    execute(lines, state, compiled);
    return {time: state.time, writes: state.writes, waits: state.waits};
}

async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const file of ['global_start_menu.opy', 'subroutines.opy']) {
        baseline[file] = execFileSync('git', ['show', `${baselineRef}:src/${file}`],
            {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const oldByName = new Map(oldRules.map(rule => [rule.name, rule]));
    assert.equal(newRules.length, oldRules.length + 1);
    assert.deepEqual(newRules.filter(rule => !oldByName.has(rule.name)).map(rule => rule.name),
        ['shortenPrematchTimer']);
    const existingRules = newRules.filter(rule => oldByName.has(rule.name));
    assert.deepEqual(existingRules.map(rule => rule.name), oldRules.map(rule => rule.name));
    const changed = oldRules.filter((rule, i) => rule.body !== existingRules[i].body).map(rule => rule.name);
    assert.deepEqual(changed.sort(), ['END VOTING', 'setPrematchTimer']);
    const oldCompiled = new Map(oldRules.map(rule => [rule.name, actions(rule)]));
    const newCompiled = new Map(newRules.map(rule => [rule.name, actions(rule)]));
    const oldTimer = oldCompiled.get('setPrematchTimer'), newTimer = newCompiled.get('setPrematchTimer');
    const commonStart = oldTimer.findIndex(line => line.startsWith('If(And(Compare(Match Time, >, 10),'));
    assert(commonStart >= 0);
    const shortening = newCompiled.get('shortenPrematchTimer');
    assert.deepEqual(shortening, oldTimer.slice(commonStart, -2), 'Preserve existing readiness actions and wait');
    assert(!shortening.join('\n').includes('Event Player'), 'Global call must not read an event player');
    assert.deepEqual(newTimer, [...oldTimer.slice(0, commonStart),
        'Call Subroutine(shortenPrematchTimer);', ...oldTimer.slice(-2)]);

    const oldEnd = oldCompiled.get('END VOTING'), newEnd = newCompiled.get('END VOTING');
    assert.deepEqual(newEnd, [...oldEnd, 'Call Subroutine(shortenPrematchTimer);']);
    const endStart = oldEnd.lastIndexOf('If(Global.menuFinaleMotionSlot);');
    assert(endStart >= 0);
    const beforeEnd = oldEnd.slice(endStart), afterEnd = newEnd.slice(endStart);
    const player = (pregameState, isPlayerActive = true, isPregameVoting = false) =>
        ({pregameState, isPlayerActive, isPregameVoting});
    const ready = [player(2), player(2)];
    assert.deepEqual(run(beforeEnd, oldCompiled, ready, {player: null}).writes, [30], 'Reproduce reported bug');
    assert.deepEqual(run(afterEnd, newCompiled, ready, {player: null}),
        {time: 10, writes: [30, 15, 10], waits: 1});
    assert.deepEqual(run(afterEnd, newCompiled, [player(2), player(0, false)], {player: null}).writes,
        [30, 20], 'Only active players ready');
    assert.deepEqual(run(afterEnd, newCompiled, [player(2), player(1)], {player: null}).writes,
        [30], 'Active player not ready');
    assert.deepEqual(run(afterEnd, newCompiled, ready, {hidden: 0, player: null}).writes, []);

    let scenarios = 0;
    function check(players) {
        for (const time of [0, 9, 10, 15, 20, 21, 30, 36, 51, 60]) {
            for (const hidden of [0, 30]) for (const voting of [false, true]) {
                for (const isPregameVoting of [false, true]) {
                    players.at(-1).isPregameVoting = isPregameVoting;
                    const options = {time, hidden, voting};
                    assert.deepEqual(run(newTimer, newCompiled, players, options),
                        run(oldTimer, oldCompiled, players, options), JSON.stringify({players, options}));
                    scenarios++;
                }
            }
        }
    }
    function rosters(players, remaining) {
        if (!remaining) return check(players);
        for (const state of [0, 1, 2]) for (const active of [false, true])
            rosters([...players, player(state, active)], remaining - 1);
    }
    for (let count = 1; count <= 3; count++) rosters([], count);

    // Compile the real root entry point too, then update the importable Workshop artifact.
    const root = path.dirname(src);
    const included = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
        'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    assert.equal(included.nbElements, after.elements);
    assert.deepEqual(included.encounteredWarnings, []);
    assert.deepEqual(rules(included.result), newRules);
    fs.writeFileSync(path.join(root, 'main.ws.txt'), included.result);
    console.log(JSON.stringify({baselineRef, before: before.elements, after: after.elements,
        elementDelta: after.elements - before.elements, changedRules: changed,
        addedSubroutine: 'shortenPrematchTimer', playerTimerScenarios: scenarios,
        warnings: after.warnings, inGameValidated: false}, null, 2));
}

main().catch(error => {console.error(error); process.exitCode = 1;});
