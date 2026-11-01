// Compare menu membership expressions in memory. Does not modify src/ or its export.
// Usage: node analysis/measure-menu-membership.cjs
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const groups = [
    {field:'player.playerMenuStatus[PlayerMenuStatusField.CHALLENGE_VOTE]', list:'[0, 1, 2, 3, 4, 5]', max:5, table:'challengeVotes'},
    {field:'player.playerMenuStatus[PlayerMenuStatusField.ZOMBIE_MODE_VOTE]', list:'[0, 1, 2, 3, 4, 5, 6]', max:6, table:'zombieVotes'}
];
const generator = fs.readFileSync(path.join(src,'create numbers.js'),'utf8');
const generated = vm.runInNewContext(generator);
const existingOffset = generated.match(/#!define NL_MENU_VOTE_IDS_OFFSET (\d+)/);
const offset = existingOffset ? Number(existingOffset[1]) : [...generated.matchAll(/^\s*-?\d+(?:\.\d+)?,/gm)].length;
assert(offset > 0);
// Restore literal filters in memory so these probes also work after implementation.
const literalFiles = {...files};
for (const g of groups) {
    const literal = `${g.field} in ${g.list}`;
    const length = g.max === 5 ? 'NL_MENU_VOTE_IDS_LEN - 1' : 'NL_MENU_VOTE_IDS_LEN';
    const slice = `${g.field} in numbersList.slice(NL_MENU_VOTE_IDS_OFFSET, ${length})`;
    if (!literalFiles['global_start_menu.opy'].includes(literal)) {
        assert(literalFiles['global_start_menu.opy'].includes(slice));
        literalFiles['global_start_menu.opy'] = literalFiles['global_start_menu.opy'].replace(slice,literal);
    }
}
const variants = [
    {name:'baseline', expression:g => `${g.field} in ${g.list}`, equivalence:'Exact original membership.'},
    {name:'bounds', expression:g => `${g.field} >= 0 and ${g.field} <= ${g.max}`, equivalence:'Equivalent only for integer IDs; admits fractional values.'},
    {name:'bounds_integer', expression:g => `${g.field} >= 0 and ${g.field} <= ${g.max} and floor(${g.field}) == ${g.field}`, equivalence:'Exact for numeric IDs, including fractions and negative values.'},
    {name:'centered_bound', expression:g => `abs(${g.field} - ${g.max/2}) <= ${g.max/2}`, equivalence:'Equivalent only for integer IDs; admits fractional values.'},
    {name:'compressed_inline', expression:g => `${g.field} in compressed(${g.list})`, expectedError:'Cannot nest .filter() or .map()', equivalence:'Exact original membership if compilation were supported.'},
    {name:'compressed_precomputed', expression:g => `${g.field} in probeMenuVoteIds.slice(0, ${g.max+1})`, equivalence:'Exact; includes initialization and decompression cost plus one new global variable.',
        prepare(f) { f['variables.opy'] += '\nglobalvar probeMenuVoteIds = compressed([0, 1, 2, 3, 4, 5, 6])\n'; }},
    {name:'shared_compressed_slice', expression:g => `${g.field} in numbersList.slice(${offset}, ${g.max+1})`, equivalence:'Exact; reuses the existing 0..6 group or appends it if not yet implemented.',
        prepare(f) {
            if (existingOffset) return;
            assert(f['compressed numbers.opy'].includes('    createNumbers()\n'));
            f['compressed numbers.opy'] = f['compressed numbers.opy'].replace('    createNumbers()\n','    createNumbers()\n    0, 1, 2, 3, 4, 5, 6\n');
        }},
    {name:'mapped_vote_indices', expression:g => `${g.field} in ${g.table}.map(lambda _, i: i)`, expectedError:'Cannot nest .filter() or .map()', equivalence:'Equivalent while vote table lengths remain 6 and 7 and tables are initialized.'},
    {name:'upper_bound_only', expression:g => `${g.field} <= ${g.max}`, equivalence:'Requires nonnegative integer IDs; admits negative values and fractions.'},
    {name:'no_vote_filters', equivalence:'Requires every player to have an ID in the original allowed set; removes invalid-ID protection.',
        prepare(f) {
            for (const g of groups) {
                const old = `getAllPlayers().filter(lambda player: ${g.field} in ${g.list})`;
                assert(f['global_start_menu.opy'].includes(old));
                f['global_start_menu.opy'] = f['global_start_menu.opy'].replace(old,'getAllPlayers()');
            }
        }}
];
async function main() {
    await compiler.readyPromise;
    const results = [];
    for (const variant of variants) {
        const f = {...literalFiles};
        variant.prepare?.(f);
        if (variant.expression) for (const g of groups) {
            const original = `${g.field} in ${g.list}`;
            assert(f['global_start_menu.opy'].includes(original));
            f['global_start_menu.opy'] = f['global_start_menu.opy'].replace(original,variant.expression(g));
        }
        try {
            const r = await compile(f);
            const menu = r.result.slice(r.result.indexOf('rule ("EFFECTS/TEXTS")'));
            const rows = [...menu.matchAll(/^\s*Create HUD Text\(.*; \/\/ (\d+) elements$/gm)].slice(0,7).map(m => Number(m[1]));
            const row = {name:variant.name,elements:r.elements,saved:results.length ? results[0].elements-r.elements : 0,
                challengeHudElements:rows[3],zombieHudElements:rows[4],warnings:r.warnings,
                equivalence:variant.equivalence};
            if (variant.expression) row.expressions = groups.map(variant.expression);
            results.push(row);
            console.log(JSON.stringify(row));
        } catch (error) {
            results.push({name:variant.name,error:error.message,expected:Boolean(variant.expectedError && error.message.includes(variant.expectedError))});
            console.log(JSON.stringify(results.at(-1)));
        }
    }
    assert(results.every(r => !r.error || r.expected),'Unexpected compilation failure');
    for (const [name,content] of Object.entries(files)) assert.equal(fs.readFileSync(path.join(src,name),'utf8').replace(/\r\n/g,'\n'),content,'Source changed during measurement');
    const report = {
        compiler:'OverPy 9.7.20', method:'Full project variants compiled independently in memory with current optimization directives; baseline restores the two literal filters. Existing numeric data is retained. src/ unchanged.',
        appendedSequenceOffset:offset,
        sourceSha256:Object.fromEntries([...Object.entries(files),['create numbers.js',generator]].map(([name,s]) => [name,crypto.createHash('sha256').update(s).digest('hex')])),
        results
    };
    fs.writeFileSync(path.join(__dirname,'menu-membership-results.json'),JSON.stringify(report,null,2)+'\n');
}
main().catch(e => { console.error(e); process.exitCode=1; });
