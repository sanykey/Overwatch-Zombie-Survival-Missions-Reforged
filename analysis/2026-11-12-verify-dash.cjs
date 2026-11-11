// Compile with the installed OverPy and test the emitted DASH state transitions.
// Run: node analysis/2026-11-12-verify-dash.cjs
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const root = path.resolve(__dirname, '..');

// Small evaluator for the emitted actions used by these rules, including actual
// Skip If offsets and nested branches. Unsupported operations fail the check.
function args(text) {
    const result = []; let start = 0, depth = 0;
    for (let i = 0; i < text.length; i++) {
        if (text[i] === '(') depth++;
        if (text[i] === ')') depth--;
        if (text[i] === ',' && !depth) {result.push(text.slice(start, i).trim()); start = i + 1;}
    }
    return result.concat(text.slice(start).trim());
}
function state() {
    return {time: 10, player: {augmentId: 2, augmentState0: 0, augmentState1: 0,
        augmentState2: 2, augmentState3: 0}, global: {}, effects: new Set(), next: 100,
        statusUntil: 0, alive: true, impulses: 0, throttle: [0, 0, 1]};
}
function value(text, s) {
    text = text.trim();
    if (/^-?\d+(\.\d+)?$/.test(text)) return Number(text);
    if (text === 'Null' || text === 'False') return 0;
    if (text === 'True') return 1;
    if (text === 'Total Time Elapsed') return s.time;
    if (text === 'Last Created Entity') return s.last;
    if (text === 'Left') return [1, 0, 0];
    if (text === 'Right') return [-1, 0, 0];
    if (text === 'Up') return [0, 1, 0];
    const field = text.match(/^(?:\(Event Player\)\.|Global\.)(\w+)$/);
    if (field) return (text.startsWith('Global.') ? s.global : s.player)[field[1]] ?? 0;
    const call = text.match(/^([\w -]+)\((.*)\)$/);
    assert(call, 'Unsupported value: ' + text);
    const a = args(call[2]);
    const v = i => value(a[i], s);
    switch (call[1]) {
        case 'Compare': {
            const l = v(0), r = v(2), equal = Array.isArray(l) || Array.isArray(r)
                ? JSON.stringify(l) === JSON.stringify(r) : Number(l) === Number(r);
            return {'==': equal, '!=': !equal, '>': l > r, '<': l < r, '>=': l >= r}[a[1]];
        }
        case 'Or': return v(0) || v(1);
        case 'And': return v(0) && v(1);
        case 'Not': return !v(0);
        case 'Has Status': return a[1] === 'Invincible' && s.time < s.statusUntil;
        case 'Is Alive': return Number(s.alive);
        case 'Throttle Of': return s.throttle;
        case 'Vector': return a.map((_, i) => v(i));
        case 'X Component Of': return v(0)[0];
        case 'Z Component Of': return v(0)[2];
        case 'If-Then-Else': return v(0) ? v(1) : v(2);
        case 'Add': return Array.isArray(v(0)) ? v(0).map((n, i) => n + v(1)[i]) : v(0) + v(1);
        case 'Subtract': return v(0) - v(1);
        default: throw Error('Unsupported function: ' + call[1]);
    }
}
function run(rule, s, checkConditions = false) {
    if (checkConditions) {
        const conditions = rule.body.match(/conditions \{\n([\s\S]*?)\n\}/)[1].split('\n');
        if (!conditions.every(line => {
            const [, l, op, r] = line.match(/^(.*?) (==|!=|>=|<) (.*);$/);
            return value(`Compare(${l}, ${op}, ${r})`, s);
        })) return;
    }
    const lines = rule.body.match(/actions \{\n([\s\S]*?)\n\}/)[1].split('\n');
    function endOf(start, acceptElse) {
        let depth = 0;
        for (let i = start + 1; i < lines.length; i++) {
            if (lines[i].startsWith('If(')) depth++;
            if (lines[i] === 'End;' && depth-- === 0) return i;
            if (acceptElse && lines[i] === 'Else;' && depth === 0) return i;
        }
        // Workshop permits a trailing If without End; OverPy omits it for size.
        return lines.length;
    }
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        if (line === 'End;') continue;
        if (line === 'Else;' || line.startsWith('Else If(')) {i = endOf(i, false); continue;}
        const [, fn, inside] = line.match(/^([\w ]+)\((.*)\);$/) || [];
        assert(fn, 'Unsupported action: ' + line);
        const a = args(inside), v = n => value(a[n], s);
        switch (fn) {
            case 'If': if (!v(0)) i = endOf(i, true); break;
            case 'Skip If': if (v(0)) i += v(1); break;
            case 'Set Player Variable': s.player[a[1]] = v(2); break;
            case 'Modify Player Variable': assert.equal(a[2], 'Add'); s.player[a[1]] += v(3); break;
            case 'Set Global Variable': s.global[a[0]] = v(1); break;
            // Deliberately model Set Status as replacing a duration: correctness
            // must not depend on undocumented stacking/maximum-duration behavior.
            case 'Set Status': s.statusUntil = s.time + v(3); break;
            case 'Create Effect': s.last = s.next++; s.effects.add(s.last); break;
            case 'Destroy Effect': s.effects.delete(v(0)); break;
            case 'Apply Impulse': s.impulses++; break;
            default: throw Error('Unsupported action: ' + fn);
        }
    }
}

async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const name of ['augments.opy', 'variables.opy']) baseline[name] = execFileSync('git',
        ['show', 'a08da83:src/' + name], {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n');
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const existing = newRules;
    const changed = existing.filter((rule, i) => {
        assert.equal(rule.name, oldRules[i].name);
        return rule.body !== oldRules[i].body;
    });
    assert.deepEqual(changed.map(r => r.name).sort(),
        ['DASH SMOKE FADE', 'useAugmentAirAction'].sort());
    assert.equal(newRules.length, oldRules.length);
    assert(!newRules.some(r => r.name === 'DASH EXTEND INVULNERABILITY'));
    const get = name => newRules.find(r => r.name === name);
    const activate = (s, old = false) => run((old ? oldRules : newRules).find(r => r.name === 'useAugmentAirAction'), s);
    const tick = s => {
        run(get('DASH SMOKE FADE'), s, true);
    };
    const broken = state(); activate(broken, true); broken.time += 0.4; activate(broken, true);
    assert.equal(broken.effects.size, 2, 'Reproduce the original leaked aura from compiled actions');
    let scenarios = 0;
    for (const delay of [0.1, 0.4, 0.7, 1.49, 1.5, 1.51, 2]) {
        for (const cleanupFirst of [true, false]) {
            const s = state(); activate(s);
            assert.equal(s.effects.size, 1);
            const first = s.player.augmentState1;
            s.time += delay;
            if (cleanupFirst) tick(s);
            activate(s);
            assert.equal(s.statusUntil, s.time + 1.5, 'Renew immediately on every activation, without a cleanup tick');
            tick(s);
            assert.equal(s.effects.size, 1, 'At most one aura, including at expiry');
            if (delay < 1.5) assert.equal(s.player.augmentState1, first, 'Reuse overlapping aura');
            assert.equal(s.player.augmentState2, 0);
            assert.equal(s.player.augmentState0, 25, 'Second spend must preserve recharge timer');
            const protectedUntil = s.statusUntil;
            activate(s); assert.equal(s.effects.size, 1, 'Empty charges must preserve live handle');
            assert.equal(s.statusUntil, protectedUntil, 'No renewal without a successful activation');
            for (; s.time < 11.5 + delay; s.time += 0.01) {
                tick(s);
                assert(s.statusUntil > s.time, 'Protection lasts through the refreshed window');
            }
            tick(s);
            assert.equal(s.effects.size, 0);
            assert.equal(s.player.augmentState1, 0);
            s.time += 15; s.player.augmentState2 = 2; activate(s);
            assert.equal(s.effects.size, 1, 'Cleanup rearms after recharge');
            s.time += 1.5; tick(s); assert.equal(s.effects.size, 0);
            scenarios++;
        }
    }
    for (const duration of [0.8, 5, 10, 99999]) {
        const s = state(); s.statusUntil = 10 + duration; activate(s);
        assert.equal(s.statusUntil, 11.5, 'Always issue a fresh 1.5s status, even with existing protection');
        s.time = 10.8; tick(s);
        assert.equal(s.statusUntil, 11.5);
        s.time = 11.5; tick(s);
        assert.equal(s.effects.size, 0);
        assert.equal(s.statusUntil, 11.5, 'Smoke cleanup must not modify status');
        scenarios++;
    }
    for (const field of ['isCrowdControlled', 'isAttached']) {
        const s = state(); activate(s); const handle = s.player.augmentState1;
        s.player[field] = 1; activate(s);
        assert.equal(s.player.augmentState1, handle);
        assert.equal(s.player.augmentState2, 1);
        scenarios++;
    }
    const jump = state(); jump.player.augmentId = 3; jump.player.augmentState1 = 1;
    activate(jump); assert.equal(jump.player.augmentState1, 0); assert.equal(jump.impulses, 1);
    jump.player.augmentState1 = 1; activate(jump);
    assert.equal(jump.player.augmentState1, 0); assert.equal(jump.impulses, 1);
    const dead = state(); activate(dead); dead.alive = false; dead.time += 1.5; tick(dead);
    assert.equal(dead.effects.size, 0, 'Death must not strand smoke cleanup');
    const stationary = state(); stationary.throttle = [0, 0, 0]; activate(stationary);
    assert.equal(stationary.impulses, 0, 'No movement input grants protection only');
    assert.equal(stationary.statusUntil, 11.5);
    const charged = state(); activate(charged); charged.time += 0.4; activate(charged);
    charged.time = 25; run(get('DASH CHARGE RECHARGE'), charged, true);
    assert.equal(charged.player.augmentState2, 1);
    assert.equal(charged.player.augmentState0, 40);
    charged.time = 40; run(get('DASH CHARGE RECHARGE'), charged, true);
    assert.equal(charged.player.augmentState2, 2);
    // Independent state for two players; the only global scratch is consumed
    // synchronously before return and is never used by smoke/status cleanup.
    const players = [state(), state()]; players[1].time += 0.5;
    players.forEach(s => activate(s));
    players[0].time = 11.5; tick(players[0]);
    assert.equal(players[0].effects.size, 0); assert.equal(players[1].effects.size, 1);
    const declarations = after.result.match(/variables \{([\s\S]*?)\n\}/)[1];
    assert.equal(declarations, before.result.match(/variables \{([\s\S]*?)\n\}/)[1], 'No new variable slots');
    for (const match of declarations.matchAll(/^\s*\d+: (\w+)/gm)) assert(match[1].length <= 31);
    assert(after.elements < before.elements, 'The fix must reduce compiled element count');
    const report = {date: '2026-11-12', baseline: 'a08da83', beforeElements: before.elements,
        afterElements: after.elements, savedElements: before.elements - after.elements,
        warnings: after.warnings, changedRules: changed.map(r => r.name),
        unchangedCompiledRules: existing.length - changed.length,
        modeledScenarios: scenarios + 5, originalLeakReproduced: true,
        method: 'Execute emitted actions in a limited evaluator; compare all other compiled rules. No in-game run or performance profiling.'};
    fs.writeFileSync(path.join(__dirname, '2026-11-12-dash-validation.json'), JSON.stringify(report, null, 2) + '\n');
    fs.writeFileSync(path.join(root, 'main.ws.txt'), after.result);
    console.log(JSON.stringify(report, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
