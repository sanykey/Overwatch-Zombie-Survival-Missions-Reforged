// Exercise the emitted Workshop conditions/actions, including the synthetic damage event.
// --export also updates main.ws.txt with the real entry point's source locations.
const fs = require('node:fs');
const assert = require('node:assert/strict');
const {compiler, compile, files} = require('./measure-further-optimizations.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const slots = Object.fromEntries(['Energy', 'Charge', 'Deadline', 'AssistSnapshot'].map(name => [name,
    files['variables.opy'].match(new RegExp('^#!define enhancementCapacitor' + name + ' (\\w+)$', 'm'))[1]]));
const compare = (left, op, right) => {
    switch (op) {
        case '==': return left === right;
        case '!=': return left !== right;
        case '>': return left > right;
        case '>=': return left >= right;
        case '<': return left < right;
        default: throw new Error('Unsupported comparison: ' + op);
    }
};
function value(text, state, event) {
    const constants = {'True': 1, 'False': 0, 'Null': 0, 'Team 2': 2};
    if (Object.hasOwn(constants, text)) return constants[text];
    if (/^-?\d+(\.\d+)?$/.test(text)) return Number(text);
    if (text.startsWith('(Event Player).')) return state[text.slice(15)] ?? 0;
    if (text === 'Global.isGameplayActive') return state.gameplay;
    if (text.startsWith('Global.')) return state.globals?.[text.slice(7)] ?? 0;
    if (text === 'Event Healing') return event.healing ?? 0;
    if (text === 'Event Damage') return event.damage ?? 0;
    if (text === 'Event Ability') return event.ability ?? 0;
    if (text === 'Total Time Elapsed') return state.time;
    if (text === 'Is Alive(Event Player)') return state.alive;
    if (text === 'Is Dead(Event Player)') return 1 - state.alive;
    if (text === 'Is Button Held(Event Player, Button(Melee))') return state.held;
    if (text === 'Is Button Held(Event Player, Button(Interact))') return state.interact ?? 0;
    if (text === 'Team Of(Victim)') return event.team ?? 2;
    const a = args(text), v = i => value(a[i], state, event);
    switch (text.slice(0, text.indexOf('('))) {
        case 'Divide': return v(0) / v(1);
        case 'Add': return v(0) + v(1);
        case 'Subtract': return v(0) - v(1);
        case 'Multiply': return v(0) * v(1);
        case 'Min': return Math.min(v(0), v(1));
        case 'Max': return Math.max(v(0), v(1));
        case 'Player Stat':
            assert.equal(a[0], 'Event Player');
            assert(['Offensive Assists', 'Defensive Assists'].includes(a[1]));
            return state.stats?.[a[1]] ?? 0;
        case 'Not': return Number(!v(0));
        case 'Or': return Number(Boolean(v(0) || v(1)));
        case 'And': return Number(Boolean(v(0) && v(1)));
        case 'Compare': return Number(compare(v(0), a[1], v(2)));
        default: throw new Error('Unsupported value: ' + text);
    }
}
function extract(result, name) {
    const start = result.indexOf('rule ("OVERCHARGE ' + name + '")');
    assert(start >= 0, name);
    const body = result.slice(start, result.indexOf('\n}\n', start));
    const lines = section => body.match(new RegExp(section + ' \\{([\\s\\S]*?)\\n    \\}'))[1]
        .split('\n').map(line => line.trim().replace(/;.*$/, ''))
        .filter(line => line && !line.startsWith('//') && !line.startsWith('"'));
    return {conditions: lines('conditions'), actions: lines('actions')};
}
function execute(rule, state, event = {}) {
    if (!rule.conditions.every(line => {
        const match = line.match(/^(.*) (==|!=|>=|>|<) (.*)$/);
        assert(match, line);
        return compare(value(match[1], state, event), match[2], value(match[3], state, event));
    })) return false;
    for (let pc = 0; pc < rule.actions.length; pc++) {
        const action = rule.actions[pc], a = args(action);
        const v = i => value(a[i], state, event);
        switch (action.slice(0, action.indexOf('('))) {
            case 'Set Global Variable': (state.globals ??= {})[a[0]] = v(1); break;
            case 'Set Player Variable': state[a[1]] = v(2); break;
            case 'Modify Player Variable':
                assert(['Add', 'Subtract'].includes(a[2]));
                state[a[1]] = (state[a[1]] ?? 0) + v(3) * (a[2] === 'Add' ? 1 : -1);
                break;
            case 'Skip If': if (v(0)) pc += v(1); break;
            case 'If': if (!v(0)) return true; break;
            case 'Damage':
                state.hits.push({target: event.target, amount: v(2)});
                // Bonus Damage has no Event Ability and must not reenter this rule.
                assert.equal(execute(rule, state, {...event, ability: 0, damage: v(2)}), false);
                break;
            default: throw new Error('Unsupported action: ' + action);
        }
    }
    return true;
}
async function main() {
    await compiler.readyPromise;
    const built = await compile(files);
    assert.deepEqual(built.warnings, []);
    const rule = Object.fromEntries(['STORES HEALING', 'STORES ASSISTS', 'ARMS CHARGE', 'CLEARS CHARGE', 'BONUS DAMAGE'].map(name => [name, extract(built.result, name)]));
    const fresh = () => ({enhancementId: 9, gameplay: 1, alive: 1, held: 0, time: 10, hits: []});
    // The engine exposes offensive/defensive assist stats, not an assist event.
    assert.match(built.result, /rule \("OVERCHARGE STORES ASSISTS"\) \{\s*event \{\s*Ongoing - Each Player;\s*Team 1;/);
    const assists = fresh();
    assists.stats = {'Offensive Assists': 3, 'Defensive Assists': 4};
    const baseline = built.result.split('\n').find(line =>
        line.includes(`Set Player Variable(Event Player, ${slots.AssistSnapshot}, Add(Player Stat(`));
    assert(baseline, 'Initialize the snapshot from existing match stats, not zero');
    execute({conditions: [], actions: [baseline.trim().replace(/;.*$/, '')]}, assists);
    assert.equal(assists[slots.AssistSnapshot], 7);
    assert.equal(execute(rule['STORES ASSISTS'], assists), false, 'No retroactive credit');
    assists.stats['Offensive Assists']++;
    assert(execute(rule['STORES ASSISTS'], assists));
    assert.equal(assists[slots.Energy], 10);
    assert.equal(execute(rule['STORES ASSISTS'], assists), false, 'Do not pay twice');
    assists.stats['Defensive Assists'] += 3;
    execute(rule['STORES ASSISTS'], assists);
    assert.equal(assists[slots.Energy], 40, 'Credit the entire batch');
    assists.held = 1;
    execute(rule['ARMS CHARGE'], assists);
    assert.equal(assists[slots.Charge], 40, 'Assist energy can arm a partial burst');
    assists.stats['Offensive Assists']++;
    assists.stats['Defensive Assists']++;
    execute(rule['STORES ASSISTS'], assists);
    assert.equal(assists[slots.Energy], 20, 'Both counters fund the next burst');
    assert.equal(assists[slots.Charge], 40, 'Armed damage stays fixed');
    assists.alive = 0;
    execute(rule['CLEARS CHARGE'], assists);
    assists.stats['Defensive Assists']++;
    execute(rule['STORES ASSISTS'], assists);
    assert.equal(assists[slots.Energy], 30, 'Posthumous assists count too');
    assists.stats['Offensive Assists'] = assists.stats['Defensive Assists'] = 0;
    execute(rule['STORES ASSISTS'], assists);
    assert.equal(assists[slots.Energy], 30, 'A stat reset cannot remove energy');
    assert.equal(assists[slots.AssistSnapshot], 0);
    assists.stats['Defensive Assists'] = 12;
    execute(rule['STORES ASSISTS'], assists);
    assists.alive = 1;
    execute(rule['ARMS CHARGE'], assists);
    assert.equal(assists[slots.Charge], 100);
    assert.equal(assists[slots.Energy], 50, 'Assist energy obeys the same 100 cap');
    for (const override of [{gameplay: 0}, {enhancementId: 4}]) {
        const blocked = {...fresh(), ...override, stats: {'Offensive Assists': 1}};
        assert.equal(execute(rule['STORES ASSISTS'], blocked), false);
        assert.equal(blocked[slots.Energy] ?? 0, 0);
    }
    assert.equal(execute(rule['STORES ASSISTS'], fresh()), false, 'Player isolation');
    const state = fresh(), run = (name, event) => execute(rule[name], state, event);
    const hit = (time, target, ability = 1, damage = 90, team = 2) => {
        state.time = time;
        return run('BONUS DAMAGE', {target, ability, damage, team});
    };
    run('STORES HEALING', {healing: 300});
    assert.equal(state[slots.Energy], 100);
    assert.equal(run('ARMS CHARGE'), false);
    state.interact = 1;
    assert.equal(run('ARMS CHARGE'), false, 'Interact no longer arms the charge');
    state.held = 1;
    run('ARMS CHARGE');
    assert.equal(state[slots.Charge], 100);
    assert.equal(state[slots.Energy], 0);
    state.held = 0;
    // An armed charge has no timeout before the first qualifying hit.
    state.time = 100;
    assert.equal(run('CLEARS CHARGE'), false);
    assert.equal(hit(100, 'turret', 0), false);
    assert.equal(hit(100, 'friendly', 1, 90, 1), false);
    assert.equal(hit(100, 'blocked', 1, 0), false);
    assert.equal(state[slots.Deadline] ?? 0, 0);
    hit(100, 'nade A');
    hit(100, 'nade B');
    hit(100.296, 'nade C');
    assert.equal(state[slots.Deadline], 100.3);
    assert.deepEqual(state.hits.map(x => x.amount), [100, 100, 100]);
    run('STORES HEALING', {healing: 300});
    state.held = 1;
    assert.equal(run('ARMS CHARGE'), false);
    assert.equal(state[slots.Charge], 100);
    hit(100.3, 'too late');
    assert.equal(state.hits.length, 3);
    run('CLEARS CHARGE');
    run('ARMS CHARGE');
    assert.equal(state[slots.Charge], 100);
    assert.equal(state[slots.Deadline], 0);
    hit(101, 'next burst');
    assert.equal(state.hits.at(-1).amount, 100);
    run('STORES HEALING', {healing: 2.25});
    assert.equal(state[slots.Energy], 0.75);
    state.alive = 0;
    run('CLEARS CHARGE');
    assert.equal(state[slots.Charge], 0);
    assert.equal(state[slots.Energy], 0.75);
    assert.equal(run('ARMS CHARGE'), false);
    const other = fresh();
    execute(rule['STORES HEALING'], other, {healing: 30});
    assert.equal(other[slots.Energy], 10);
    assert.equal(state[slots.Energy], 0.75);
    other.enhancementId = 4;
    assert.equal(execute(rule['STORES HEALING'], other, {healing: 100}), false);
    const overflow = fresh();
    overflow.held = 1;
    execute(rule['STORES HEALING'], overflow, {healing: 750002.25});
    assert.equal(overflow[slots.Energy], 250000.75, 'Bank remains uncapped');
    execute(rule['ARMS CHARGE'], overflow);
    assert.equal(overflow[slots.Charge], 100);
    assert.equal(overflow[slots.Energy], 249900.75, 'Only the armed energy is spent');
    execute(rule['BONUS DAMAGE'], overflow, {ability: 1, damage: 90, target: 'capped burst'});
    assert.equal(overflow.hits.at(-1).amount, 100);
    overflow.time += 1;
    execute(rule['CLEARS CHARGE'], overflow);
    execute(rule['ARMS CHARGE'], overflow);
    assert.equal(overflow[slots.Charge], 100);
    assert.equal(overflow[slots.Energy], 249800.75, 'Remainder funds subsequent bursts');
    assert(/Set Player Variable\(Event Player, enhancementId, Random Integer\((?:True|1), 11\)\)/.test(built.result));
    assert(built.result.includes('Overcharge'));
    if (process.argv.includes('--export')) {
        const exported = await compiler.compile(fs.readFileSync('main.opy', 'utf8'), 'en-US', process.cwd().replace(/\\/g, '/') + '/', 'main.opy');
        assert.equal(exported.nbElements, built.elements);
        assert.deepEqual(exported.encounteredWarnings, []);
        fs.writeFileSync('main.ws.txt', exported.result);
    }
    console.log(JSON.stringify({elements: built.elements, warnings: built.warnings, scenarios: 'offensive/defensive assists, batches, no retroactive/duplicate credit, stat reset, posthumous assists, assist-funded 100 cap, gameplay/enhancement/player isolation, healing conversion, Melee activation, Interact ignored, delayed first hit, Ana AoE, exact expiry, independent next charge, fractional energy, death, recursion and source filtering'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
