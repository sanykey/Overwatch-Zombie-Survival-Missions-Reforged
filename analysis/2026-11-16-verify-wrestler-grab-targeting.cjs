// Compile and exercise the actual Workshop target selector. --write updates main.ws.txt.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {start, scenario} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');
const baselineRef = '7f0987a';
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const bot = (id, x, z, flags = {}) => ({id, position: [x, 0, z], eyePosition: [x, 0, z],
    alive: true, dummy: true, team: 2, visible: true, isCrowdControlled: true, ...flags});

function select(compiled, mode, targets, options = {}) {
    const state = scenario(0, {targets, ...options});
    state.player.team = 1;
    state.player.eyePosition = [0, 0, 0];
    state.globals.tmp1 = mode;
    state.globals.bossStateList = options.bosses ?? [];
    state.globals.miniBossList = options.minibosses ?? [];
    const task = start(compiled.get('selectPullAimTarget'), state, compiled);
    assert(task.done(), 'Target selection must not yield');
    return state.globals.tmp0?.id ?? null;
}

async function main() {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const name of ['variables.opy', 'subroutines.opy', 'augments.opy', 'enhancements.opy']) {
        baseline[name] = execFileSync('git', ['show', `${baselineRef}:src/${name}`],
            {cwd: root, encoding: 'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const changed = new Set(['selectPullAimTarget', 'useLivingProjectile', 'GRAPNEL LAUNCHER', 'WRESTLER PULL']);
    assert.deepEqual(newRules.filter(r => !changed.has(r.name)), oldRules.filter(r => !changed.has(r.name)));
    const variables = text => text.match(/^variables \{[\s\S]*?^\}/m)[0];
    assert.equal(variables(before.result), variables(after.result));
    const oldCompiled = new Map(oldRules.map(r => [r.name, r]));
    const current = new Map(newRules.map(r => [r.name, r]));
    let grabCases = 0, regressionCases = 0;
    const check = (targets, expected, options) => {
        assert.equal(select(current, 2, targets, options), expected);
        grabCases++;
    };
    check([], null);
    check([bot('edge', 0, 5)], 'edge');
    check([bot('too far', 0, 5.001)], null);
    check([bot('near', 0, 0.1)], 'near');
    check([bot('off aim', 1, 3), bot('center', 0, 5)], 'center');
    check([bot('outside cone', 4, 2)], null);
    for (const degrees of [49.99, 50.01]) {
        const radians = degrees * Math.PI / 180;
        const target = bot('angle boundary', 4 * Math.sin(radians), 4 * Math.cos(radians));
        check([target], degrees < 50 ? target.id : null);
        for (const mode of [0, 1]) {
            assert.equal(select(current, mode, [target]), select(oldCompiled, !!mode, [target]));
            regressionCases++;
        }
    }
    check([bot('blocked', 0, 3)], null, {lineOfSight: false});
    for (const flags of [{team: 1}, {dummy: false}, {alive: false}, {visible: false},
        {[slot('botIsInitializing')]: true}, {[slot('botIsTeleporting')]: true},
        {[slot('botIsAttached')]: true}, {isCrowdControlled: false, botIsCrowdControlled: false}]) {
        check([bot('invalid', 0, 3, flags), bot('fallback', 1, 4)], 'fallback');
    }
    for (const list of ['bosses', 'minibosses']) {
        const excluded = bot('boss', 0, 3);
        check([excluded, bot('fallback', 1, 4)], 'fallback', {[list]: [excluded]});
    }
    check([bot('grace', 0, 3, {isCrowdControlled: false, botIsCrowdControlled: true})], 'grace');
    check([bot('live', 0, 3, {isCrowdControlled: true, botIsCrowdControlled: false})], 'live');
    for (const mode of [0, 1]) {
        for (const distance of [0, 6, 6.01, 6.99, 7, 19.99, 20, 20.01, 44.99, 45, 45.01]) {
            for (const flags of [{}, {team: 1}, {dummy: false}, {alive: false},
                {[slot('botIsInitializing')]: true}, {[slot('botIsTeleporting')]: true},
                {[slot('botIsAttached')]: true}, {isCrowdControlled: false, botIsCrowdControlled: false}]) {
                const targets = [bot('candidate', 0, distance, flags)];
                assert.equal(select(current, mode, targets), select(oldCompiled, !!mode, targets));
                regressionCases++;
            }
        }
        const boss = bot('allowed for pull', 0, 10, {isCrowdControlled: false, botIsCrowdControlled: false});
        assert.equal(select(current, mode, [boss], {bosses: [boss]}), 'allowed for pull');
        regressionCases++;
    }
    const grab = current.get('useLivingProjectile').body;
    assert(!grab.includes('Ray Cast'));
    assert(grab.includes('Set Global Variable(tmp1, 2);\nCall Subroutine(selectPullAimTarget);'));
    assert(!/Wait\(|Loop\(/.test(grab));
    let build;
    const log = console.log;
    try {
        console.log = () => {};
        build = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    assert.equal(build.nbElements, after.elements);
    assert.deepEqual(rules(build.result), newRules);
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    console.log(JSON.stringify({baselineRef, before: before.elements, after: after.elements,
        delta: after.elements - before.elements, grabCases, regressionCases, warnings: 0,
        newVariables: 0, nativeGameplayVerified: false}, null, 2));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
