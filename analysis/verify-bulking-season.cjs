// Exercise emitted Workshop elimination/death actions.
const assert = require('node:assert/strict');
const {compiler, compile, files} = require('./measure-further-optimizations.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const stack = files['variables.opy'].match(/^#!define enhancementBulkStacks (\w+)$/m)[1];
const normal = files['variables.opy'].match(/^#!define enhancementBulkNormalSize (\w+)$/m)[1];
function value(text, state) {
    if (['True', 'False', 'Null'].includes(text)) return text === 'True' ? 1 : 0;
    if (/^-?\d+(\.\d+)?$/.test(text)) return Number(text);
    if (text.startsWith('(Event Player).')) return state[text.slice(15)] ?? 0;
    if (text.startsWith('Global.')) return state[text.slice(7)] ?? 0;
    const a = args(text), v = i => value(a[i], state);
    switch (text.slice(0, text.indexOf('('))) {
        case 'Compare':
            assert(['==', '!='].includes(a[1]));
            return a[1] === '==' ? v(0) === v(2) : v(0) !== v(2);
        case 'Add': return v(0) + v(1);
        case 'Subtract': return v(0) - v(1);
        case 'Multiply': return v(0) * v(1);
        case 'Divide': return v(0) / v(1);
        case 'Min': return Math.min(v(0), v(1));
        case 'Max': return Math.max(v(0), v(1));
        case 'Not': return !v(0);
        case 'If-Then-Else': return v(0) ? v(1) : v(2);
        case 'Is Alive': return Number(state.alive ?? true);
        case 'Is Button Held': assert.equal(a[1], 'Button(Melee)'); return Number(state.melee ?? true);
        case 'Round To Integer': assert.equal(a[1], 'Down'); return Math.floor(v(0));
        default: throw new Error('Unsupported expression: ' + text);
    }
}
function rules(text) {
    return Object.fromEntries([...text.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([, name, body]) => {
        const section = key => (body.match(new RegExp(key + ' \\{([\\s\\S]*?)\\n    \\}'))?.[1] ?? '')
            .split('\n').map(line => line.trim().replace(/;.*$/, ''))
            .filter(line => line && !line.startsWith('"') && !line.startsWith('//'));
        return [name, {conditions: section('conditions'), actions: section('actions')}];
    }));
}
function execute(all, name, state) {
    assert(all[name], name);
    if (!all[name].conditions.every(line => {
        const m = line.match(/^(.*) (==|!=) (.*)$/);
        assert(m, line);
        const equal = value(m[1], state) === value(m[3], state);
        return m[2] === '==' ? equal : !equal;
    })) return false;
    const branches = [];
    const active = () => branches.every(b => b.active);
    for (let i = 0; i < all[name].actions.length; i++) {
        const action = all[name].actions[i];
        const a = action.includes('(') ? args(action) : [], v = i => value(a[i], state);
        if (action.startsWith('If(')) {
            const take = active() && !!v(0);
            branches.push({active: take, taken: take});
            continue;
        }
        if (action.startsWith('Else If(') || action === 'Else') {
            const branch = branches.pop();
            const take = active() && !branch.taken && (action === 'Else' || !!v(0));
            branches.push({active: take, taken: branch.taken || take});
            continue;
        }
        if (action === 'End') {branches.pop(); continue;}
        if (!active()) continue;
        switch (action.slice(0, action.indexOf('('))) {
            case 'Wait':
                assert.equal(a[1], 'Abort When False');
                if ((state.holdSeconds ?? Infinity) < v(0)) return false;
                break;
            case 'Set Global Variable': state[a[0]] = v(1); break;
            case 'Set Player Variable': state[a[1]] = v(2); break;
            case 'Modify Player Variable':
                assert.equal(a[2], 'Add'); state[a[1]] += v(3); break;
            case 'Set Max Health': state.maxHealthPercent = v(1); break;
            case 'Start Scaling Player':
                assert.equal(v(2), 0, 'Size must not reevaluate every frame');
                state.engineSize = v(1); break;
            case 'Start Modifying Hero Voice Lines':
                assert.equal(v(2), 0, 'Pitch must not reevaluate every frame');
                state.pitch = v(1); break;
            case 'Call Subroutine': execute(all, a[0], state); break;
            default: throw new Error('Unsupported action: ' + action);
        }
    }
    return true;
}
async function main() {
    await compiler.readyPromise;
    const built = await compile(files);
    assert.deepEqual(built.warnings, []);
    const all = rules(built.result), earn = 'PLAYER EARNED ELIMINATION', die = 'PLAYER DIED';
    const toggle = 'BULKING SEASON TOGGLES SIZE';
    assert(built.result.match(/rule \("PLAYER EARNED ELIMINATION"\) \{\s*event \{\s*Player Earned Elimination;\s*Team 1;/));
    assert(!JSON.stringify(all[earn]).includes('Player Stat('), 'Bulking Season does not poll assist stats');
    assert(!files['variables.opy'].includes('enhancementBulkCreditSnapshot'));
    const state = {enhancementId: 10, isGameplayActive: 1, [stack]: 0, sizeScale: 1};
    execute(all, earn, state);
    assert.equal(state[stack], 1);
    assert.equal(state.maxHealthPercent, 100.5);
    assert.equal(state.sizeScale, 1.0075);
    assert.equal(state.engineSize, state.sizeScale);
    assert(Math.abs(state.pitch - (1 - 1 / 400)) < 1e-12);
    for (let i = 1; i < 70; i++) execute(all, earn, state);
    assert.equal(state[stack], 70);
    assert.equal(state.sizeScale, 1.525);
    assert.equal(state.maxHealthPercent, 135);
    for (let i = 70; i < 140; i++) execute(all, earn, state);
    assert.equal(state[stack], 140);
    assert(Math.abs(state.sizeScale - 2.05) < 1e-12);
    assert(Math.abs(state.pitch - (1 - 140 / 400)) < 1e-12);
    assert.equal(state.maxHealthPercent, 170, 'Health continues beyond the former size cap');
    execute(all, die, state);
    assert.equal(state[stack], 70);
    assert.equal(state.sizeScale, 1.525);
    assert.equal(state.maxHealthPercent, 135);
    execute(all, die, state);
    assert.equal(state[stack], 35);
    assert.equal(state.sizeScale, 1.2625);
    execute(all, die, state);
    assert.equal(state[stack], 17);
    assert.equal(state.maxHealthPercent, 108.5);
    assert.equal(state.sizeScale, 1.1275);
    state[stack] = 5;
    execute(all, die, state);
    assert.equal(state[stack], 2, 'Five stacks halve to two');
    execute(all, die, state);
    execute(all, die, state);
    assert.equal(state[stack], 0);
    assert.equal(state.maxHealthPercent, 100);
    assert.equal(state.engineSize, 1);
    state.enhancementId = 9;
    const otherEnhancement = {...state};
    execute(all, earn, state);
    assert.deepEqual(state, otherEnhancement, 'Other enhancements retain their shared storage');
    execute(all, die, state);
    assert.deepEqual(state, otherEnhancement, 'Other enhancements are unchanged on death');
    const capped = {enhancementId: 10, isGameplayActive: 1, [stack]: 199, sizeScale: 1.35};
    execute(all, earn, capped);
    assert.equal(capped[stack], 200);
    assert.equal(capped.maxHealthPercent, 200, 'Health reaches its cap at 200 stacks');
    execute(all, earn, capped);
    assert.equal(capped[stack], 201);
    assert.equal(capped.maxHealthPercent, 200, 'Stacks continue accumulating beyond the health cap');
    capped[stack] = 400;
    execute(all, die, capped);
    assert.equal(capped[stack], 200);
    assert.equal(capped.maxHealthPercent, 200);
    execute(all, die, capped);
    assert.equal(capped[stack], 100);
    assert.equal(capped.maxHealthPercent, 150, 'Death lowers health once stacks fall below the cap');
    assert(files['players_game_in_progress.opy'].includes('eventPlayer.initialMaxHealth /= min(2, 1 + eventPlayer.enhancementBulkStacks * 0.005)'));
    assert(files['player_initialization.opy'].includes('@Condition eventPlayer.isHeroSwitchRespawn == false'));
    assert(built.result.includes('Random Integer(True, 12)'));
    assert(built.result.includes('Bulking Season'));
    // Native size does not spend stacks or disable health bonuses. Deaths and
    // eliminations update pitch/size only in the stacked mode.
    const modes = {enhancementId: 10, isGameplayActive: 1, [stack]: 400, sizeScale: 3};
    execute(all, 'applyBulkingSeasonStats', modes);
    assert.equal(modes.engineSize, 2.5);
    assert.equal(modes.pitch, 0.5);
    for (const stacks of [0, 1, 99, 100, 101, 150, 199, 200, 201, 300]) {
        const boundary = {enhancementId: 10, [stack]: stacks};
        execute(all, 'applyBulkingSeasonStats', boundary);
        assert.equal(boundary.engineSize, Math.min(2.5, 1 + stacks * 0.0075));
        assert(Math.abs(boundary.pitch - Math.max(0.5, 1 - stacks / 400)) < 1e-12);
    }
    const beforeTap = {...modes};
    modes.holdSeconds = 0.49;
    assert.equal(execute(all, toggle, modes), false);
    delete modes.holdSeconds;
    assert.deepEqual(modes, beforeTap, 'Short taps do not toggle');
    modes.holdSeconds = 0.5;
    execute(all, toggle, modes);
    assert.equal(modes[normal], true);
    assert.equal(modes.engineSize, 1);
    assert.equal(modes.pitch, 1);
    assert.equal(modes[stack], 400);
    assert.equal(modes.maxHealthPercent, 200);
    execute(all, earn, modes);
    assert.equal(modes[stack], 401);
    assert.equal(modes.engineSize, 1);
    assert.equal(modes.pitch, 1);
    execute(all, die, modes);
    assert.equal(modes[stack], 200);
    assert.equal(modes[normal], true);
    assert.equal(modes.engineSize, 1);
    assert.equal(modes.pitch, 1);
    execute(all, toggle, modes);
    assert.equal(modes[normal], false);
    assert.equal(modes.engineSize, 2.5);
    assert.equal(modes.pitch, 0.5);
    for (const block of [{alive: false}, {isGameplayActive: 0}, {enhancementId: 9}, {melee: false}]) {
        const blocked = {...modes, ...block}, snapshot = {...blocked};
        assert.equal(execute(all, toggle, blocked), false);
        assert.deepEqual(blocked, snapshot);
    }
    assert(!all[toggle].actions.some(a => /Loop|Wait Until/.test(a)), 'One toggle per hold, no repeating loop');
    assert(files['player_initialization.opy'].includes('eventPlayer.enhancementBulkNormalSize = false'));
    console.log(JSON.stringify({elements: built.elements, warnings: built.warnings, scenarios: 'elimination event, no assist-stat polling, 2.5x size cap at 200 stacks, linearly decreasing pitch with 0.5x floor at 200 stacks, 200% health cap, repeated/odd deaths, enhancement isolation, short tap, toggle both ways, native mode stacks/deaths, activation gates'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
