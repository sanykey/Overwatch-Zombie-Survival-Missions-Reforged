// Compile both revisions and compare rendered menu values using a small, deliberately
// limited Workshop expression evaluator. This is not an Overwatch client simulation.
// Usage: node analysis/verify-start-menu-hud.cjs [baseline Git revision]
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const vm = require('node:vm');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const baselineRef = process.argv[2] || '2930c02';
const root = path.dirname(src);
const historical = name => execFileSync('git', ['show', `${baselineRef}:src/${name}`], {cwd:root}).toString('utf8').replace(/\r\n/g,'\n');

function splitArgs(text) {
    const result = [];
    let depth = 0, quoted = false, start = 0;
    for (let i = 0; i < text.length; i++) {
        const c = text[i];
        if (quoted && c === '\\') { i++; continue; }
        if (c === '"') quoted = !quoted;
        if (quoted) continue;
        if (c === '(') depth++;
        if (c === ')') depth--;
        if (c === ',' && depth === 0) { result.push(text.slice(start,i).trim()); start = i+1; }
    }
    if (text.trim()) result.push(text.slice(start).trim());
    assert.equal(depth,0);
    assert.equal(quoted,false);
    return result;
}
function parse(text) {
    if (text.startsWith('"')) return {literal:JSON.parse(text)};
    if (/^-?\d+(?:\.\d+)?$/.test(text)) return {literal:Number(text)};
    const property = text.match(/^\((.*)\)\.(\w+)$/);
    if (property) return {property:property[2], object:parse(property[1])};
    const call = text.match(/^([^()]+)\((.*)\)$/);
    if (call) return {name:call[1], args:splitArgs(call[2]).map(parse)};
    return {name:text};
}
const asNumber = value => Number(value ?? 0);
const equal = (a,b) => a === b || ([a,b].every(v => v == null || typeof v === 'boolean' || typeof v === 'number') && asNumber(a) === asNumber(b));
const asString = value => value == null ? '0' : typeof value === 'boolean' ? String(Number(value)) : String(value);
function evaluate(node, env) {
    if ('literal' in node) return node.literal;
    if (node.property) return evaluate(node.object,env)?.[node.property] ?? null;
    const {name} = node;
    const at = i => evaluate(node.args[i],env);
    if (name.startsWith('Global.')) {
        assert(name.slice(7) in env.globals, `Unknown global: ${name}`);
        return env.globals[name.slice(7)];
    }
    switch (name) {
        case 'Null': return null;
        case 'False': return false;
        case 'True': return true;
        case 'Empty Array': return [];
        case 'Local Player': return env.viewer;
        case 'Current Array Element': return env.element;
        case 'Total Time Elapsed': return env.time;
        case 'All Players': return env.players;
        case 'Array': return node.args.map(a => evaluate(a,env));
        case 'Array Slice': return at(0).slice(asNumber(at(1)),asNumber(at(1))+asNumber(at(2)));
        case 'First Of': { const v = at(0); return Array.isArray(v) ? v[0] ?? null : v; }
        case 'Value In Array': { const v = at(0), i = asNumber(at(1)); return Number.isInteger(i) ? v?.[i] ?? null : null; }
        case 'Array Contains': return at(0).some(v => equal(v,at(1)));
        case 'Filtered Array': return at(0).filter(element => evaluate(node.args[1],{...env,element}));
        case 'If-Then-Else': return at(0) ? at(1) : at(2);
        case 'Or': return Boolean(at(0) || at(1));
        case 'And': return Boolean(at(0) && at(1));
        case 'Not': return !at(0);
        case 'Compare': {
            const a = at(0), b = at(2), op = node.args[1].name;
            if (op === '==') return equal(a,b);
            if (op === '!=') return !equal(a,b);
            if (op === '<') return asNumber(a) < asNumber(b);
            if (op === '<=') return asNumber(a) <= asNumber(b);
            if (op === '>') return asNumber(a) > asNumber(b);
            if (op === '>=') return asNumber(a) >= asNumber(b);
            throw new Error(`Unsupported comparison: ${op}`);
        }
        case 'Multiply': return asNumber(at(0))*asNumber(at(1));
        case 'Modulo': return asNumber(at(0))%asNumber(at(1));
        case 'Round To Integer': assert.equal(node.args[1].name,'Up'); return Math.ceil(asNumber(at(0)));
        case 'String Split': return asString(at(0)).split(asString(at(1)));
        case 'Char In String': return asString(at(0)).charAt(asNumber(at(1)));
        case 'Custom String': return at(0).replace(/\{(\d)\}/g, (_,i) => asString(Number(i)+1 < node.args.length ? at(Number(i)+1) : null));
        case 'Color': case 'Custom Color': case 'Button': case 'Hero':
        case 'Input Binding String': case 'Hero Icon String': case 'Ability Icon String': case 'Icon String':
            return `${name}(${node.args.map(a => asString(evaluate(a,env))).join(',')})`;
        default:
            // Enum arguments and display flags are symbolic leaves; unknown functions fail.
            assert(!node.args, `Unsupported Workshop function: ${name}`);
            return name;
    }
}
function rules(output) {
    const matches = [...output.matchAll(/^rule \("([^"]+)"\) \{/gm)];
    return matches.map((m,i) => ({name:m[1], text:output.slice(m.index,matches[i+1]?.index ?? output.length).replace(/\n\/\/\d+ elements\s*$/, '')}));
}
function hudRows(rule) {
    return [...rule.text.matchAll(/^\s*Create HUD Text\((.*)\);.*$/gm)].map(m => splitArgs(m[1]).map(parse));
}
function palettes(output) {
    const globals = {};
    for (const m of output.matchAll(/Set Global Variable\((\w+), (.*)\);/g)) {
        if (/^color\w+Const$/.test(m[1]) || /^startMenu\w+Colors$/.test(m[1])) globals[m[1]] = evaluate(parse(m[2]),{globals});
    }
    return globals;
}
function rendered(rows,env) {
    const blank = v => v === '' || Array.isArray(v) && v.length === 0;
    return rows.filter(row => evaluate(row[0],env).includes(env.viewer)).map(row => {
        const values = row.slice(1,9).map(n => evaluate(n,env));
        // A literal Null HUD argument is omitted. Null returned by a lookup is a
        // numeric value and displays as "0"; do not normalize that regression away.
        for (let i = 0; i < 3; i++) {
            if (row[i+1].name === 'Null' || blank(values[i])) { values[i] = ''; values[i+5] = null; }
            else values[i] = asString(values[i]);
        }
        values[4] = asNumber(values[4]); // The size optimizer uses False/True for sort orders 0/1.
        return values;
    }).sort((a,b) => a[4]-b[4]);
}
async function main() {
    await compiler.readyPromise;
    const baseline = Object.fromEntries(Object.keys(files).map(name => [name,historical(name)]));
    const generator = fs.readFileSync(path.join(src,'create numbers.js'),'utf8').replace(/\r\n/g,'\n');
    const oldGenerated = vm.runInNewContext(historical('create numbers.js'));
    const newGenerated = vm.runInNewContext(generator);
    const generatedData = text => ({
        values:[...text.matchAll(/^\s*(-?\d+(?:\.\d+)?),/gm)].map(m => Number(m[1])),
        constants:Object.fromEntries([...text.matchAll(/#!define (NL_\w+) (\d+)/g)].map(m => [m[1],Number(m[2])]))
    });
    const oldNumbers = generatedData(oldGenerated), newNumbers = generatedData(newGenerated);
    assert.deepEqual(newNumbers.values.slice(0,oldNumbers.values.length),oldNumbers.values,'Existing numbers changed');
    for (const [name,value] of Object.entries(oldNumbers.constants)) assert.equal(newNumbers.constants[name],value,`Existing offset/length changed: ${name}`);
    assert.equal(newNumbers.constants.NL_MENU_VOTE_IDS_OFFSET,oldNumbers.values.length);
    assert.equal(newNumbers.constants.NL_MENU_VOTE_IDS_LEN,7);
    assert.deepEqual(newNumbers.values.slice(oldNumbers.values.length),[0,1,2,3,4,5,6]);
    // Compile historical numbers from the historical generator, rather than the
    // current on-disk JavaScript include resolved by the compiler.
    assert(baseline['compressed numbers.opy'].includes('    createNumbers()\n'));
    baseline['compressed numbers.opy'] = baseline['compressed numbers.opy'].replace('    createNumbers()\n',oldGenerated+'\n');
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings,[]);
    assert.deepEqual(after.warnings,[]);
    assert(after.elements < before.elements,'No element savings');
    const oldRules = rules(before.result), newRules = rules(after.result);
    assert.deepEqual(newRules.map(r => r.name),oldRules.map(r => r.name),'Rule lifecycle changed');
    // Only the palette initialization and the first EFFECTS/TEXTS rule may change.
    const menuIndex = oldRules.findIndex(r => r.name === 'EFFECTS/TEXTS');
    oldRules.forEach((r,i) => {
        if (i !== menuIndex && r.name !== 'Initialize global variables') assert.equal(newRules[i].text,r.text,`Unrelated rule changed: ${r.name}`);
    });
    const oldRows = hudRows(oldRules[menuIndex]), newRows = hudRows(newRules[menuIndex]);
    const withoutHud = text => text.split('\n').filter(line => !/^\s*(?:Create HUD Text\(|Set Global Variable\(startMenu(?:Zombie|Objective|Enhancement)Colors,|"|\/\/)/.test(line)).join('\n');
    assert.equal(withoutHud(newRules[menuIndex].text),withoutHud(oldRules[menuIndex].text),'Non-HUD menu actions changed');
    assert.equal(oldRows.length,34); // Three unchanged top/right HUDs and 31 menu variants.
    assert.equal(newRows.length,7);
    assert.deepEqual(newRows.slice(0,3),oldRows.slice(0,3));
    const original = oldRows.slice(3), current = newRows.slice(3);
    current.forEach(row => {
        assert.equal(row[9].name,'Visible To String and Color');
        assert.equal(row[10].name,'Default Visibility');
        assert(!JSON.stringify(row).includes('Evaluate Once'));
    });
    const baseGlobals = {...palettes(before.result),numbersList:oldNumbers.values};
    const nextGlobals = {...palettes(after.result),numbersList:newNumbers.values};
    let comparisons = 0;
    // Each category varies independently. All other viewers use different votes so a
    // shared/incorrect local selection is detectable. Include absent slots and invalid IDs.
    const cases = [[-1,0,1,2,3,4,5,6,99],[-1,0,1,2,3,4,5,6,7,99],[-1,0,1,2,3,4,5,6,7,8,9,10,99],[-1,0,1,2,3,4,5,6,7,8,9,10,11,99]];
    const makePlayer = (challenge,zombie,objective,enhancement) => ({playerMenuStatus:[0,0,challenge,zombie,objective],enhancementId:enhancement});
    for (const voting of [false,true]) for (const specialEffectsTiming of [false,true])
    for (const specialEffectsStrings of ['alglChene oteV: KaMeNrldEr',"You won't win","Don't even try it"])
    for (const time of [0,0.01,0.8,1.6,5.4]) for (const [category,ids] of cases.entries()) for (const id of ids) {
        const votes = [2,6,5,8]; votes[category] = id;
        const players = [makePlayer(...votes),makePlayer(5,1,9,10),makePlayer(0,0,0,0),{playerMenuStatus:[0,0,0,0],enhancementId:0}];
        // Compare values for different rosters; this does not simulate connection events.
        for (const roster of [players,players.slice(1)]) for (const viewer of roster) {
            const env = {players:roster,viewer,time};
            const globals = {voting,specialEffectsTiming,specialEffectsStrings};
            assert.deepEqual(rendered(current,{...env,globals:{...nextGlobals,...globals}}),rendered(original,{...env,globals:{...baseGlobals,...globals}}),`Mismatch: category ${category}, id ${id}, voting ${voting}, flash ${specialEffectsTiming}, time ${time}`);
            comparisons++;
        }
    }
    // Keep the normal per-file compilation output, including correct source locations.
    const main = files['main.opy'].replace(/^#!writeToOutputFile.*\n/gm,'');
    const log = console.log; let exported;
    try { console.log = () => {}; exported = await compiler.compile(main,'en-US',src.replace(/\\/g,'/')+'/', 'main.opy'); }
    finally { console.log = log; }
    assert.equal(exported.nbElements,after.elements);
    assert.deepEqual(exported.encounteredWarnings,[]);
    fs.writeFileSync(path.join(src,'main.ws.txt'),exported.result);
    const report = {
        baselineRef, compiler:'OverPy 9.7.20', baseline:before.elements, current:after.elements, saved:before.elements-after.elements,
        menuRule:{before:oldRows.length,after:newRows.length,menuObjectsBefore:original.length,menuObjectsAfter:current.length},
        renderedComparisons:comparisons, warnings:after.warnings,
        variables:{global:(Object.values(files).join('\n').match(/^globalvar /gm)||[]).length,player:(Object.values(files).join('\n').match(/^playervar /gm)||[]).length},
        numberData:{before:oldNumbers.values.length,after:newNumbers.values.length,menuVoteIdsOffset:newNumbers.constants.NL_MENU_VOTE_IDS_OFFSET,menuVoteIdsLength:newNumbers.constants.NL_MENU_VOTE_IDS_LEN,existingValuesAndOffsetsPreserved:true},
        sourceSha256:Object.fromEntries([...['global_start_menu.opy','variables.opy'].map(n => [n,files[n]]),['create numbers.js',generator]].map(([n,s]) => [n,crypto.createHash('sha256').update(s).digest('hex')])),
        limitations:'Expression comparison only; does not simulate the Overwatch renderer, reevaluation scheduling, key bindings, or spectator camera behavior. In-game validation is still required.'
    };
    fs.writeFileSync(path.join(__dirname,'start-menu-hud-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
}
main().catch(e => { console.error(e); process.exitCode=1; });
