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
    if (text === 'Has Spawned(Event Player)') return state.spawned ?? 1;
    if (text === 'Is Dummy Bot(Event Player)') return state.dummy ?? 0;
    if (text === 'Is Button Held(Event Player, Button(Melee))') return state.held;
    if (text === 'Is Button Held(Event Player, Button(Interact))') return state.interact ?? 0;
    if (text === 'Team Of(Victim)') return event.team ?? 2;
    const a = args(text), v = i => value(a[i], state, event);
    switch (text.slice(0, text.indexOf('('))) {
        case 'Divide': return v(0) / v(1);
        case 'Add': return v(0) + v(1);
        case 'Subtract': return v(0) - v(1);
        case 'Multiply': return v(0) * v(1);
        case 'Max': return Math.max(v(0), v(1));
        case 'Min': return Math.min(v(0), v(1));
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
function extract(result, name, prefix = 'OVERCHARGE ') {
    const start = result.indexOf('rule ("' + prefix + name + '")');
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
    const state = fresh(), run = (name, event) => execute(rule[name], state, event);
    const hit = (time, target, ability = 1, damage = 90, team = 2) => {
        state.time = time;
        return run('BONUS DAMAGE', {target, ability, damage, team});
    };
    run('STORES HEALING', {healing: 750});
    assert.equal(state[slots.Energy], 250);
    assert.equal(run('ARMS CHARGE'), false);
    state.interact = 1;
    assert.equal(run('ARMS CHARGE'), false, 'Interact no longer arms the charge');
    state.held = 1;
    run('ARMS CHARGE');
    assert.equal(state[slots.Charge], 100);
    assert.equal(state[slots.Energy], 150);
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
    assert.equal(state[slots.Energy], 250, 'Healing during the burst builds the next bank');
    hit(100.3, 'too late');
    assert.equal(state.hits.length, 3);
    run('CLEARS CHARGE');
    run('ARMS CHARGE');
    assert.equal(state[slots.Charge], 100);
    assert.equal(state[slots.Deadline], 0);
    hit(101, 'next burst');
    assert.equal(state.hits.at(-1).amount, 100);
    run('STORES HEALING', {healing: 2.25});
    assert.equal(state[slots.Energy], 150.75);
    state.alive = 0;
    run('CLEARS CHARGE');
    assert.equal(state[slots.Charge], 0);
    assert.equal(state[slots.Energy], 150.75);
    assert.equal(run('ARMS CHARGE'), false);
    const other = fresh();
    execute(rule['STORES HEALING'], other, {healing: 30});
    assert.equal(other[slots.Energy], 10);
    assert.equal(state[slots.Energy], 150.75);
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
    for (const energy of [0, 0.75, 99.75, 100, 100.25, 250, 250000.75]) {
        const boundary = {...fresh(), held: 1, [slots.Energy]: energy};
        assert.equal(execute(rule['ARMS CHARGE'], boundary), energy > 0);
        assert.equal(boundary[slots.Charge] ?? 0, Math.min(energy, 100));
        assert.equal(boundary[slots.Energy], Math.max(energy - 100, 0), 'The cap preserves all unspent energy');
    }
    // Execute the emitted Overcharge initialization actions with the original
    // first-spawn guards; the surrounding switch is pinned by the compiled diff.
    const init = extract(built.result, 'PLAYER ENHANCEMENT INITIALIZATION', '');
    const snapshotIndex = init.actions.findIndex(action => action.startsWith(
        `Set Player Variable(Event Player, ${slots.AssistSnapshot}, Add(Player Stat(`));
    assert(snapshotIndex >= 3, 'Snapshot must be initialized with the Overcharge burst state');
    const overchargeInit = {...init, actions: init.actions.slice(snapshotIndex - 3, snapshotIndex + 1)};
    for (const [index, name] of ['Energy', 'Charge', 'Deadline'].entries())
        assert(overchargeInit.actions[index].startsWith(`Set Player Variable(Event Player, ${slots[name]}, Null)`));
    let assistCases = 0;
    for (const offensive of [0, 4]) for (const defensive of [0, 7]) {
        const assisted = {...fresh(), stats: {'Offensive Assists': offensive, 'Defensive Assists': defensive}};
        assert(execute(overchargeInit, assisted));
        assert.equal(assisted[slots.AssistSnapshot], offensive + defensive);
        assert.equal(assisted[slots.Energy], 0, 'Existing assists at first spawn or late join grant no energy');
        assert.equal(execute(rule['STORES ASSISTS'], assisted), false);
        for (const [offensiveGain, defensiveGain] of [[1, 0], [0, 1], [2, 3]]) {
            assisted.stats['Offensive Assists'] += offensiveGain;
            assisted.stats['Defensive Assists'] += defensiveGain;
            const before = assisted[slots.Energy];
            assert(execute(rule['STORES ASSISTS'], assisted));
            assert.equal(assisted[slots.Energy], before + (offensiveGain + defensiveGain) * 10);
            assert.equal(execute(rule['STORES ASSISTS'], assisted), false, 'No second payment for unchanged counters');
            assistCases++;
        }
        assisted[slots.Charge] = 75;
        assisted[slots.Deadline] = assisted.time + 0.3;
        assisted.isHeroSwitchRespawn = 1;
        assisted.stats['Defensive Assists']++;
        assert.equal(execute(overchargeInit, assisted), false, 'Hero changes preserve the assist baseline');
        execute(rule['STORES ASSISTS'], assisted);
        assert.equal(assisted[slots.Energy], 80, 'Hero change retains earned energy');
        assert.equal(assisted[slots.Charge], 75, 'Assist energy cannot change the armed bonus');
        assert.equal(assisted[slots.Deadline], assisted.time + 0.3);
        assisted.alive = 0;
        execute(rule['CLEARS CHARGE'], assisted);
        assisted.stats['Offensive Assists']++;
        execute(rule['STORES ASSISTS'], assisted);
        assert.equal(assisted[slots.Energy], 90, 'Posthumous assists still grant energy');
        assisted.alive = 1;
        assert.equal(execute(rule['STORES ASSISTS'], assisted), false, 'Revival does not repay assists');
        assisted.stats = {'Offensive Assists': 0, 'Defensive Assists': 0};
        execute(rule['STORES ASSISTS'], assisted);
        assert.equal(assisted[slots.AssistSnapshot], 0);
        assert.equal(assisted[slots.Energy], 90, 'Stat resets never subtract energy');
        assisted.stats['Defensive Assists'] = 1;
        execute(rule['STORES ASSISTS'], assisted);
        assert.equal(assisted[slots.Energy], 100, 'A new assist after a reset grants one credit');
        assert.equal(execute(rule['STORES ASSISTS'], assisted), false);
        assistCases += 4;
    }
    for (const gameplay of [0, 1]) for (const enhancementId of [1, 9, 10]) {
        const gated = {...fresh(), gameplay, enhancementId, [slots.Energy]: 0.75,
            [slots.AssistSnapshot]: 0, stats: {'Offensive Assists': 1}};
        const eligible = gameplay === 1 && enhancementId === 9;
        assert.equal(execute(rule['STORES ASSISTS'], gated), eligible);
        assert.equal(gated[slots.Energy], eligible ? 10.75 : 0.75);
        assert.equal(gated[slots.AssistSnapshot], eligible ? 1 : 0);
        assistCases++;
    }
    assert(built.result.includes('Hold Melee: spend up to 100 for bonus damage'));
    assert(/Set Player Variable\(Event Player, enhancementId, Random Integer\((?:True|1), 10\)\)/.test(built.result));
    assert(built.result.includes('Overcharge'));
    if (process.argv.includes('--export')) {
        const exported = await compiler.compile(fs.readFileSync('main.opy', 'utf8'), 'en-US', process.cwd().replace(/\\/g, '/') + '/', 'main.opy');
        assert.equal(exported.nbElements, built.elements);
        assert.deepEqual(exported.encounteredWarnings, []);
        fs.writeFileSync('main.ws.txt', exported.result);
    }
    console.log(JSON.stringify({elements: built.elements, warnings: built.warnings, assistCases, scenarios: 'healing conversion, Melee activation, Interact ignored, delayed first hit, Ana AoE, exact expiry, independent next charge, fractional energy, death, player isolation, recursion and source filtering; offensive/defensive assists, existing-stat baseline, batched gains, no duplicate credit, stat resets, hero changes, posthumous credit and gameplay/enhancement gates'}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
