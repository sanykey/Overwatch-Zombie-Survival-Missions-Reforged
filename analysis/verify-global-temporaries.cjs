// Compile current sources, then check scratch-variable lifetimes in Workshop actions.
// Macros are already expanded. Calls are conservative boundaries except explicitly audited synchronous helpers.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

function args(text) {
    const result = [];
    let start = text.indexOf('(') + 1, depth = 0, quoted = false;
    for (let i = start; i < text.length; i++) {
        const c = text[i];
        if (c === '\\' && quoted) { i++; continue; }
        if (c === '"') quoted = !quoted;
        if (quoted) continue;
        if (c === '(') depth++;
        if (c === ',' && depth === 0 || c === ')' && depth === 0) {
            result.push(text.slice(start, i).trim());
            start = i + 1;
            if (c === ')') return result;
        }
        if (c === ')') depth--;
    }
    throw new Error('Unclosed action: ' + text);
}
function integer(text) {
    if (['Null', 'False'].includes(text)) return 0;
    if (text === 'True') return 1;
    assert(/^\d+$/.test(text), 'Unsupported skip destination: ' + text);
    return Number(text);
}
function skipCounts(expr) {
    return expr.startsWith('Value In Array(Array(')
        ? args(args(expr)[0]).map(integer) : [integer(expr)];
}

function checkReevaluation(name, action) {
    const signatures = {
        'Create HUD Text': [9, {0: 'Visible To', 1: 'String', 2: 'String', 3: 'String', 5: 'Sort Order', 6: 'Color', 7: 'Color', 8: 'Color'}],
        'Create Effect': [5, {0: 'Visible To', 2: 'Color', 3: 'Position', 4: 'Radius'}],
        'Create Beam Effect': [5, {0: 'Visible To', 2: 'Position', 3: 'Position', 4: 'Color'}],
        'Create Icon': [3, {0: 'Visible To', 1: 'Position', 4: 'Color'}],
        'Create In-World Text': [5, {0: 'Visible To', 1: 'String', 2: 'Position', 6: 'Color'}],
        // Outlines have no reevaluation selector; require capture of any scratch argument.
        'Start Forcing Player Outlines': [null, {0: 'Players', 1: 'Visible To', 2: 'Visibility', 3: 'Color'}]
    };
    const signature = signatures[action.slice(0, action.indexOf('('))];
    if (!signature) return 0;
    const values = args(action), [modeIndex, fields] = signature;
    for (const [index, flag] of Object.entries(fields)) {
        if (modeIndex !== null && !values[modeIndex].includes(flag)) continue;
        let value = values[index].replace(/"(?:\\.|[^"\\])*"/g, '""');
        // Remove complete Evaluate Once expressions, including nested calls.
        let begin;
        while ((begin = value.indexOf('Evaluate Once(')) >= 0) {
            let end = begin + 'Evaluate Once('.length, depth = 1;
            while (depth) {
                assert(end < value.length, 'Unclosed Evaluate Once');
                if (value[end] === '(') depth++;
                if (value[end] === ')') depth--;
                end++;
            }
            value = value.slice(0, begin) + 'Null' + value.slice(end);
        }
        assert(!/\bGlobal\.tmp\d+\b/.test(value), `${name}: scratch escapes into reevaluated ${flag}`);
    }
    return 1;
}

function checkRule(name, actions) {
    const stack = [], owner = new Map(), loops = new Map();
    const loopForAction = [];
    for (let i = 0; i < actions.length || stack.length; i++) {
        // optimizeForSize omits trailing End actions; Workshop closes them implicitly.
        if (i === actions.length) actions.push('End;');
        loopForAction[i] = [...stack].reverse().find(g => g.kind === 'loop');
        const a = actions[i];
        if (/^(?:If|While|For Global Variable|For Player Variable)\(/.test(a)) {
            const g = {kind: a.startsWith('If(') ? 'if' : 'loop', start: i, branches: [i]};
            stack.push(g); owner.set(i, g);
        } else if (/^Else(?: If\(|;)/.test(a)) {
            const g = stack.at(-1);
            assert(g?.kind === 'if', name + ': unmatched Else');
            g.branches.push(i); owner.set(i, g);
        } else if (a === 'End;') {
            const g = stack.pop();
            assert(g, name + ': unmatched End');
            g.end = i;
            if (g.kind === 'loop') loops.set(i, g);
        }
    }
    const n = actions.length;
    assert.equal(stack.length, 0, name + ': unclosed structured action');
    function fallthrough(i) {
        while (i < n && /^Else(?: If\(|;)/.test(actions[i])) i = owner.get(i).end + 1;
        return i;
    }
    const nodes = actions.map((a, i) => {
        // Ignore string contents when looking for actual variable references.
        const code = a.replace(/"(?:\\.|[^"\\])*"/g, '""');
        const use = new Set([...code.matchAll(/\bGlobal\.(tmp\d+)\b/g)].map(m => m[1]));
        const def = new Set();
        const write = code.match(/^(Set Global Variable|Modify Global Variable|For Global Variable)\((tmp\d+),/);
        if (write) {
            def.add(write[2]);
            if (write[1] === 'Modify Global Variable') use.add(write[2]);
        }
        let next = [fallthrough(i + 1)];
        if (owner.has(i)) {
            const g = owner.get(i);
            if (g.kind === 'loop') next = [fallthrough(i + 1), fallthrough(g.end + 1)];
            else if (a !== 'Else;') {
                const branch = g.branches[g.branches.indexOf(i) + 1];
                next = [fallthrough(i + 1), branch ?? fallthrough(g.end + 1)];
            }
        }
        if (loops.has(i)) {
            const g = loops.get(i);
            next = [g.start];
            const counter = actions[g.start].match(/^For Global Variable\((tmp\d+),/);
            if (counter) use.add(counter[1]); // Increment reads the counter at End.
        }
        if (/^(?:Break|Continue);/.test(a)) {
            const g = loopForAction[i];
            assert(g, name + ': loop control without loop');
            next = [a === 'Break;' ? fallthrough(g.end + 1) : g.end];
        }
        if (/^Skip(?: If)?\(/.test(a)) {
            const counts = skipCounts(args(a).at(-1));
            next = counts.map(c => i + c + 1);
            if (a.startsWith('Skip If(')) next.push(fallthrough(i + 1));
        }
        if (/^Loop(?: If|;)/.test(a)) next = a === 'Loop;' ? [0] : [0, fallthrough(i + 1)];
        if (a === 'Abort;') next = [];
        next.forEach(j => assert(j >= 0 && j <= n, name + ': action jumps outside rule'));
        return {use, def, next, live: new Set()};
    });
    let changed;
    do {
        changed = false;
        for (let i = n - 1; i >= 0; i--) {
            const node = nodes[i], live = new Set(node.use);
            for (const j of node.next) for (const v of nodes[j]?.live ?? []) {
                if (!node.def.has(v)) live.add(v);
            }
            if (live.size !== node.live.size || [...live].some(v => !node.live.has(v))) {
                node.live = live; changed = true;
            }
        }
    } while (changed);
    assert.equal(nodes[0]?.live.size ?? 0, 0, name + ': scratch read before assignment');
    let boundaries = 0, visualActions = 0;
    actions.forEach((a, i) => {
        if (/\bGlobal\.tmp\d+\b/.test(a)) visualActions += checkReevaluation(name, a);
        if (!/^(?:Wait(?: Until)?\(|Call Subroutine\(|Start Rule\()/.test(a)) return;
        boundaries++;
        const live = new Set(nodes[i].next.flatMap(j => [...(nodes[j]?.live ?? [])]));
        assert.equal(live.size, 0, `${name}: ${[...live]} live across ${a}`);
        assert.equal(nodes[i].use.size, 0, name + ': scratch referenced by asynchronous action');
    });
    return {name, controlFlowNodes: n, boundaries, visualActions};
}

function checkWorkshop(output) {
    // Validate no-yield contracts and exact input/call/result handoffs before inlining audited helpers.
    // All other subroutine calls remain conservative scratch boundaries.
    if (/^\s*selectVoteWinner;$/m.test(output))
        output = require('./verify-vote-winner.cjs').prepareScratchAudit(output);
    if (/^\s*checkEnhancementPlacement;$/m.test(output))
        output = require('./verify-enhancement-placement.cjs').prepareScratchAudit(output);
    const results = [];
    for (const m of output.matchAll(/^rule \("((?:\\.|[^"\\])*)"\) \{\n([\s\S]*?)^\}/gm)) {
        const [, name, body] = m;
        if (!/\btmp\d+\b/.test(body)) continue;
        const [before, actionText] = body.split('    actions {\n');
        assert(!/\bGlobal\.tmp\d+\b/.test(before), name + ': scratch used in event/conditions');
        const actions = actionText.split('\n').map(l => l.trim())
            .filter(l => l && !/^(?:"|\/\/|\})/.test(l))
            .map(l => l.replace(/;\s*\/\/.*$/, ';'));
        results.push(checkRule(name, actions));
    }
    assert(results.length > 0, 'No scratch rules found');
    return results;
}

async function main() {
    // Ensure the analysis rejects a yielding loop and a read without an assignment.
    assert.throws(() => checkRule('unsafe loop', [
        'For Global Variable(tmp0, 0, 3, 1);', 'Wait(1, Ignore Condition);', 'End;'
    ]), /live across/);
    assert.throws(() => checkRule('undefined input', ['Small Message(All Players(All Teams), Global.tmp0);']), /before assignment/);
    assert.throws(() => checkReevaluation('uncaptured position',
        'Create Icon(All Players(All Teams), Global.tmp0, Bolt, Visible To and Position, Null, True);'), /scratch escapes/);
    assert.throws(() => checkReevaluation('uncaptured outline color',
        'Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Global.tmp2, Default);'), /scratch escapes/);
    assert.equal(checkReevaluation('captured outline color',
        'Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Evaluate Once(Global.tmp2), Default);'), 1);
    await compiler.readyPromise;
    const compiled = await compile(files);
    const rules = checkWorkshop(compiled.result);
    const source = Object.values(files).join('\n');
    const report = {
        elements: compiled.elements,
        globals: [...source.matchAll(/^globalvar /gm)].length,
        playerVariables: [...source.matchAll(/^playervar /gm)].length,
        warnings: compiled.warnings,
        method: 'Backward scratch liveness in compiled Workshop control flow, including expanded macros, branches, loops, skips and implicit trailing Ends. Calls are conservative boundaries unless an explicit synchronous helper contract is validated before inlining. Reevaluated HUD/effect/icon fields are checked for uncaptured scratch references. No in-game validation.',
        rules
    };
    fs.writeFileSync(path.join(__dirname, 'global-temporaries-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({elements: report.elements, globals: report.globals,
        playerVariables: report.playerVariables, warnings: report.warnings,
        scratchRulesChecked: rules.length, boundariesChecked: rules.reduce((s, r) => s + r.boundaries, 0),
        visualActionsChecked: rules.reduce((s, r) => s + r.visualActions, 0)}));
}
if (require.main === module) main().catch(e => { console.error(e); process.exitCode = 1; });
module.exports = {checkWorkshop, args};
