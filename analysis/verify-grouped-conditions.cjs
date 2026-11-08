// Protect the native Workshop workaround and compare it with the same source
// compiled without the outer optimizer barrier. Does not emulate the client UI.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');

function number(ast) {
    if (ast.name === '__number__') return ast.args[0].numValue;
    if (ast.name === '__negate__') { const value = number(ast.args[0]); return value === undefined ? undefined : -value; }
}
function boolean(ast) {
    if (ast.name === 'true' || number(ast) === 1) return true;
    if (ast.name === 'false' || ast.name === 'null' || number(ast) === 0) return false;
}
function conjunction(values) {
    return ['and', ...values.flatMap(value => value[0] === 'and' ? value.slice(1) : [value])];
}
function negate(value) {
    if (value[0] === 'not') return value[1];
    if (value[0] === 'or') return conjunction(value.slice(1).map(negate));
    if (value[0] === 'and') return ['or', ...value.slice(1).map(negate)];
    return ['not', value];
}
function expression(ast, comparisonOperand = false) {
    const n = number(ast);
    if (n !== undefined) return ['number', n];
    // Workshop Null and numeric 0 are interchangeable comparison operands;
    // False is deliberately distinct for arrays/vectors/untyped variables.
    if (comparisonOperand && ast.name === 'null') return ['number', 0];
    const equal = ast.name === '__equals__', different = ast.name === '__inequals__';
    if ((equal || different) && ast.args[0].type === 'bool' && boolean(ast.args[1]) !== undefined) {
        const value = expression(ast.args[0]);
        return equal === boolean(ast.args[1]) ? value : negate(value);
    }
    if (ast.name === '__and__') return conjunction(ast.args.map(arg => expression(arg)));
    if (ast.name === '__or__') return ['or', ...ast.args.map(arg => expression(arg)).flatMap(value => value[0] === 'or' ? value.slice(1) : [value])];
    if (ast.name === '__not__') return ast.args[0].type === 'bool' ? negate(expression(ast.args[0])) :
        ['__equals__', expression(ast.args[0]), ['false']];
    const comparison = ['__equals__', '__inequals__', '__lessThan__', '__lessThanOrEquals__', '__greaterThan__', '__greaterThanOrEquals__'].includes(ast.name);
    return [ast.name, ...ast.args.map(arg => expression(arg, comparison))];
}
function parse(text) {
    const d = new compiler.OverPyDecompiler(); d.currentLanguage = 'en-US';
    return d.decompileAllRulesToAst(text)[1];
}
function compare(before, after) {
    const old = parse(before), now = parse(after);
    assert.equal(now.length, old.length);
    const oldText = rules(before), newText = rules(after);
    let conditions = 0;
    for (let i = 0; i < now.length; i++) {
        const name = now[i].ruleAttributes.name;
        assert.equal(name, old[i].ruleAttributes.name);
        const a = old[i].ruleAttributes.conditions ?? [], b = now[i].ruleAttributes.conditions ?? [];
        assert(b.length <= 1, `Separate Conditions reappeared: ${name}`);
        conditions += b.length;
        assert.deepEqual(conjunction(b.map(arg => expression(arg))), conjunction(a.map(arg => expression(arg))), `Condition meaning changed: ${name}`);
        assert.equal(newText[i].body.split('actions {')[0].replace(/conditions \{[\s\S]*?\}\n?/, ''),
            oldText[i].body.split('actions {')[0].replace(/conditions \{[\s\S]*?\}\n?/, ''), `Event changed: ${name}`);
        assert.equal(newText[i].body.split('actions {')[1], oldText[i].body.split('actions {')[1], `Actions changed: ${name}`);
    }
    return {rules: now.length, conditions};
}
async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []); assert(build.elements < 32768);
    const controlFiles = {...files};
    const macro = '#!define groupedConditions(predicate) ((predicate) == 1)';
    assert(controlFiles['rule_conditions.opy'].includes(macro));
    controlFiles['rule_conditions.opy'] = controlFiles['rule_conditions.opy'].replace(macro,
        '#!define groupedConditions(predicate) (predicate)');
    const control = await compile(controlFiles); assert.deepEqual(control.warnings, []);
    const result = compare(control.result, build.result);
    const controlConditions = parse(control.result).reduce((n,r) => n + (r.ruleAttributes.conditions?.length ?? 0), 0);
    assert(controlConditions > result.conditions, 'Control must exercise OverPy condition splitting');
    assert.equal(build.result.match(/^variables \{[\s\S]*?^\}/m)[0], control.result.match(/^variables \{[\s\S]*?^\}/m)[0]);
    assert.equal(build.result.match(/^settings\s*\{[\s\S]*?^\}/m)[0], control.result.match(/^settings\s*\{[\s\S]*?^\}/m)[0]);
    let baselineRef;
    const refIndex = process.argv.indexOf('--compare-ref');
    if (refIndex >= 0) {
        baselineRef = process.argv[refIndex + 1]; assert(baselineRef && !baselineRef.startsWith('--'));
        const baseline = execFileSync('git', ['show', baselineRef + ':main.ws.txt'],
            {cwd: path.dirname(src), encoding: 'utf8', maxBuffer: 16 * 1024 * 1024}).replace(/\r\n/g, '\n');
        compare(baseline, build.result);
        for (const field of ['settings', 'variables', 'subroutines']) {
            const pattern = new RegExp('^' + field + '\\s*\\{[\\s\\S]*?^\\}', 'm');
            assert.equal(build.result.match(pattern)[0], baseline.match(pattern)[0], field);
        }
    }
    // The barrier must resist normal optimization in a small independent fixture.
    // Explicit comparisons distinguish empty arrays / zero vectors from numeric 0.
    const fixture = '#!optimizeForSize\n' + macro + '\nglobalvar probe\nrule "guard":\n    @Event eachPlayer\n    @Condition groupedConditions((probe != 0) and (probe != false) and eventPlayer.isAlive())\n    eventPlayer.setHealth(100)\n';
    const fixtureBuild = await compiler.compile(fixture, 'en-US');
    const fixtureConditions = parse(fixtureBuild.result)[0].ruleAttributes.conditions;
    assert.equal(fixtureConditions.length, 1);
    const guard = expression(fixtureConditions[0]);
    assert(JSON.stringify(guard).includes('["__inequals__",["__globalVar__",["probe"]],["number",0]]'));
    assert(JSON.stringify(guard).includes('["__inequals__",["__globalVar__",["probe"]],["false"]]'));
    if (process.argv.includes('--export')) {
        const root = path.dirname(src);
        const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'), 'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        assert.deepEqual(exported.encounteredWarnings, []); assert.equal(exported.nbElements, build.elements);
        assert.deepEqual(rules(exported.result), rules(build.result));
        fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({...result, elements: build.elements, controlConditions, warnings: 0, baselineRef,
        checks: ['Single native Condition per rule', 'Equivalent boolean conjunctions with exact nonboolean comparisons',
            'All events/actions unchanged', 'Variables and maps unchanged', 'Numeric zero and False remain distinct',
            'Ordinary root entry point reproduces the fix'], exported: process.argv.includes('--export')}, null, 2));
}
module.exports = {expression, conjunction, compare};
if (require.main === module) main().catch(e => {console.error(e);process.exitCode=1;});
