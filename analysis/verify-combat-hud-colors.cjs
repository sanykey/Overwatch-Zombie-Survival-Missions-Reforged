// Check emitted HUD colors at state boundaries and preserve gameplay actions.
// This does not simulate native HUD rendering or reevaluation scheduling.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function args(text) {
    let depth = 0, quoted = false, start = 0;
    const result = [];
    for (let i = 0; i < text.length; i++) {
        const c = text[i];
        if (quoted && c === '\\') { i++; continue; }
        if (c === '"') quoted = !quoted;
        if (quoted) continue;
        if (c === '(') depth++;
        if (c === ')') depth--;
        if (c === ',' && depth === 0) { result.push(text.slice(start, i).trim()); start = i + 1; }
    }
    result.push(text.slice(start).trim());
    return result;
}
function evaluate(text, player) {
    const property = text.match(/^\(Event Player\)\.(\w+)$/);
    if (property) return player[property[1]] ?? 0;
    if (text === 'Total Time Elapsed') return 100;
    if (text === 'Null' || text === 'False') return 0;
    if (text === 'True') return 1;
    if (text === 'Empty Array') return [];
    if (/^-?\d+(\.\d+)?$/.test(text)) return Number(text);
    const call = text.match(/^([^()]+)\((.*)\)$/);
    assert(call, text);
    const a = args(call[2]), at = i => evaluate(a[i], player);
    switch (call[1]) {
        case 'Color': return a[0];
        case 'Icon String': return `Icon(${a[0]})`;
        case 'Button': return a[0];
        case 'Input Binding String': return at(0);
        case 'Round To Integer': return a[1] === 'Up' ? Math.ceil(at(0)) : Math.floor(at(0));
        case 'Custom String': return JSON.parse(a[0]).replace(/\{(\d+)\}/g, (_, i) => at(Number(i) + 1));
        case 'Char In String': return String(at(0)).charAt(at(1));
        case 'If-Then-Else': return at(0) ? at(1) : at(2);
        case 'Array': return a.map((_, i) => at(i));
        case 'Count Of': return at(0).length;
        case 'Value In Array': return at(0)[at(1)];
        case 'Array Contains': return at(0).includes(at(1));
        case 'Compare': {
            const x = at(0), y = at(2);
            switch (a[1]) {
                case '>': return x > y;
                case '>=': return x >= y;
                case '<': return x < y;
                case '==': return x === y;
                case '!=': return x !== y;
            }
        }
    }
    throw Error(text);
}
async function main() {
    await compiler.readyPromise;
    const original = execFileSync('git', ['show', 'HEAD:src/player_initialization.opy'], {cwd: path.dirname(src), encoding: 'utf8'}).replace(/\r\n/g, '\n');
    const before = await compile({...files, 'player_initialization.opy': original});
    const after = await compile(files);
    assert.deepEqual(after.warnings, []);
    const clean = build => rules(build.result).map(r => ({...r, body: r.body
        .split('\n').filter(l => !l.includes('Create HUD Text(') && !l.startsWith('Set Global Variable(tmp0, Value In Array(Global.augmentColorListConst,')).join('\n')}));
    assert.deepEqual(clean(after), clean(before), 'Only HUD actions and the obsolete color scratch assignment may change');
    const init = rules(after.result).find(r => r.name === 'PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION');
    const rows = [...init.body.matchAll(/Create HUD Text\((.*)\);/g)].map(m => args(m[1]));
    assert.equal(rows.length, 16);
    for (const row of rows) {
        if (row[1] === 'Null') { assert.equal(row[7], 'Color(White)'); continue; }
        assert.equal(row[7], 'Color(White)');
        assert.equal(row[6], 'Color(White)');
        if (row[8] !== 'Color(White)') assert(row[9].includes('Color'), 'Dynamic ability names must reevaluate colors');
    }
    const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
    let cases = 0;
    function check(name, values, color) {
        const row = name === 'Augment' ? rows.at(-1) : rows.find(r => r[3] === `Custom String("${name}")`);
        assert(row, name);
        const player = Object.fromEntries(Object.entries(values).map(([k, v]) => [k === 'augmentId' || k === 'infectionLevel' ? k : slot(k), v]));
        assert.equal(evaluate(row[8], player), color, `${name}: ${JSON.stringify(values)}`);
        cases++;
    }
    for (const [name, energy, armed, threshold] of [
        ['Bolt Strike', 'enhancementBoltEnergy', 'enhancementBoltBurst', 350],
        ['Overcharge', 'enhancementCapacitorEnergy', 'enhancementCapacitorCharge', 100]
    ]) {
        for (const value of [0, threshold - 0.01, threshold, threshold + 1]) {
            check(name, {[energy]: value, [armed]: 0}, value >= threshold ? 'Green' : 'White');
            check(name, {[energy]: value, [armed]: name === 'Bolt Strike' ? -1 : 1}, 'Yellow');
        }
    }
    for (const [name, cooldown] of [['Charge Battery', 'enhancementBatteryPlacementCooldown'], ['Laser Barricade', 'augmentBarrierPlacementCooldown']]) {
        for (const t of [-1, 0, 0.01, 20]) check(name, {[cooldown]: t}, t > 0 ? 'Red' : 'Green');
    }
    const hybrid = rows.find(r => r[3] === 'Custom String("Zombie Hybrid")');
    for (const infectionLevel of [0, 0.99, 1, 3]) for (const t of [0, 0.01, 20]) {
        check('Zombie Hybrid', {infectionLevel, enhancementHybridCooldown: t}, t > 0 ? 'Red' : infectionLevel >= 1 ? 'Green' : 'White');
        const status = evaluate(hybrid[2], {infectionLevel, [slot('enhancementHybridCooldown')]: t}).trim();
        assert.equal(status.includes('Icon(Checkmark)'), t <= 0 && infectionLevel >= 1);
        if (t > 0) assert.equal(status, `${Math.ceil(t)}s`);
        else if (infectionLevel < 1) assert.equal(status, 'Build up infection');
        else assert(status.includes(`Press [Melee] to deal ${Math.floor(infectionLevel)}00 damage`));
    }
    for (const augmentId of [2, 3, 4, 6]) for (const t of [0, 99.99, 100, 100.01, 116]) {
        check('Augment', {augmentId, augmentMovementReadyAt: t}, t > 100 ? 'Red' : 'Green');
    }
    for (const augmentId of [1, 5, 8, 10]) check('Augment', {augmentId}, 'White');
    for (let n = 0; n <= 2; n++) check('Augment', {augmentId: 9, augmentScavengerBackpack: Array(n).fill(1)}, ['White', 'Green', 'Yellow'][n]);
    const battle = rows.find(r => r[3] === 'Custom String("Born to Battle")');
    for (let n = 0; n <= 2; n++) {
        check('Born to Battle', {enhancementBattleResetCharges: n}, ['White', 'Lime Green', 'Green'][n]);
        const status = evaluate(battle[2], {[slot('enhancementBattleResetCharges')]: n});
        assert(status.includes(`${n}/2 resets`));
        assert.equal(status.includes('Icon(Checkmark)'), n > 0, 'Checkmark requires at least one reset');
    }
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(src, '..', 'main.ws.txt'), after.result);
    console.log(JSON.stringify({before: before.elements, after: after.elements, saved: before.elements - after.elements, colorCases: cases, gameplayActionsUnchanged: true, warnings: after.warnings}, null, 2));
}
main().catch(e => { console.error(e); process.exitCode = 1; });
