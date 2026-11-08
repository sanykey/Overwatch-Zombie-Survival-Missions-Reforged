// Final port audit against the pinned original branch, with explicit exclusions.
// Read-only unless --report is given; does not replace gameplay regression suites.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const cp = require('node:child_process');
const crypto = require('node:crypto');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const reference = '9640f50049f7cce3e4e78265a9c80a7f71f03191';
const git = (...args) => cp.execFileSync('git',args,{encoding:'utf8',maxBuffer:16*1024*1024});
function replace(tree, file, from, to) {
    assert(tree[file].includes(from), `Missing reference fragment in ${file}: ${from}`);
    tree[file] = tree[file].replace(from,to);
}
function removeRules(tree, file, prefix, expected) {
    let removed = 0;
    tree[file] = tree[file].replace(/^(?:rule "[^"\n]+":|def \w+\([^\n]*\):)\n[\s\S]*?(?=^(?:rule |def |macro )|(?![\s\S]))/gm, block => {
        if (!prefix.test(block.split('\n')[0])) return block;
        removed++; return '';
    });
    assert.equal(removed,expected,file);
}
function referenceSources() {
    const tree = {};
    for (const name of git('ls-tree','-r','--name-only',reference,'--','src').trim().split('\n').filter(n=>n.endsWith('.opy'))) {
        const relative = name.slice(4);
        tree[relative === 'includes.opy' ? 'main.opy' : relative] = git('show', reference+':'+name).replace(/\r\n/g,'\n');
    }
    replace(tree,'main.opy','#!extension beamEffects\n','');
    removeRules(tree,'augments.opy',/^rule "APOTHECARY ALLOW HEALTH PACK PICKUP"/,1);
    removeRules(tree,'enhancements.opy',/^(?:rule "BOLT STRIKE |def clearBoltEffects\()/,6);
    replace(tree,'enhancements.opy','subroutine clearBoltEffects\n','');
    const init = /        case Enhancement\.BOLT_STRIKE:\n[\s\S]*?(?=^        case )/m;
    assert(init.test(tree['enhancements.opy'])); tree['enhancements.opy'] = tree['enhancements.opy'].replace(init,'');
    replace(tree,'variables.opy','    BOLT_STRIKE = 11,\n','');
    replace(tree,'variables.opy','    DEAD_WEIGHT = 12,','    DEAD_WEIGHT = 11,');
    replace(tree,'variables.opy','    BOLT_STRIKE = iconString(Icon.BOLT),\n','');
    replace(tree,'variables.opy','    EnhancementIcon.BOLT_STRIKE,\n','');
    replace(tree,'global_start_menu.opy','"Bolt Strike ", ','');
    replace(tree,'global_start_menu.opy','Color.LIME_GREEN, Color.YELLOW, Color.PURPLE]','Color.LIME_GREEN, Color.PURPLE]');
    const text = /^            "Chain to 2 visible zombies[^\n]*\n/m;
    assert(text.test(tree['global_start_menu.opy'])); tree['global_start_menu.opy'] = tree['global_start_menu.opy'].replace(text,'');
    return tree;
}
const acceptedDifferences = {
    'Initialize global variables': 'Same immutable icon caches declared later; initialization order and compression differ.',
    'EFFECTS/TEXTS': 'Equivalent Enhancement selection IDs; retain explicit health-pack mention in Overcharge help.',
    'PLAYER PICKS UP HEALTH PACK': 'Boolean/default-zero phase guard uses the smaller equivalent expression.',
    'PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)': 'Preserve action-level phase guard and post-wait recheck for the known Workshop UI bug.',
    'PLAYER DROPS POWER UP (MANUAL)': 'Preserve the locally tested Scavenger gameplay/alive And workaround.',
    'PLAYER ENHANCEMENT INITIALIZATION': 'Direct fixed HUD icons avoid cache lookups; equivalent Bulking Season/Dead Weight case order.',
    'AUGMENT MENU': 'Concise accurate voting help; retain Double Jump post-landing window and two Scavenger slots.',
    'PLAYER AUGMENT INITIALIZATION': 'Single synchronous HUD-color lookup and shared Kevlar/Leech health-readiness gate; fixed Laser icon.',
    'LEECH LIFESTEAL': 'Preserve action-level eligibility guard for the known Workshop UI bug.',
    'RIDER DETACH WHEN DEAD OR TARGET IS DEAD': 'Check Dead Weight ownership before the remaining bot predicates.',
    'RIDER DETATCH FROM TEAMMATES WHILE ALIVE': 'Check Dead Weight ownership before the remaining bot predicates.'
};
async function main() {
    await compiler.readyPromise;
    const original = await compile(referenceSources()), rebuilt = await compile(files);
    assert.deepEqual(original.warnings,[]);assert.deepEqual(rebuilt.warnings,[]);
    const old = rules(original.result), now = rules(rebuilt.result);
    assert.equal(old.length,305);assert.equal(now.length,305);
    const differences = [];
    now.forEach((rule,index) => {
        assert.equal(rule.name,old[index].name,`Rule at index ${index}`);
        if (rule.body === old[index].body) return;
        assert(Object.hasOwn(acceptedDifferences,rule.name),`Unclassified difference: ${rule.name}`);
        differences.push({rule:rule.name,index,reason:acceptedDifferences[rule.name]});
    });
    const settings = text => text.match(/^settings\s*\{[\s\S]*?^\}/m)[0];
    assert.equal(settings(rebuilt.result),settings(original.result));
    const exported = fs.readFileSync('main.ws.txt','utf8').replace(/\r\n/g,'\n');
    assert.deepEqual(rules(exported),now,'Committed export must match the current source');
    assert.equal(settings(exported),settings(rebuilt.result));
    assert(exported.startsWith('/* Element count: (total '+rebuilt.elements+')'));
    const all = Object.values(files).join('\n');
    assert(!/^#!extension beamEffects$/m.test(all));
    assert(!/Enhancement\.BOLT_STRIKE|enhancementBolt|clearBoltEffects|rule "BOLT STRIKE|rule "APOTHECARY ALLOW HEALTH PACK PICKUP"/.test(all));
    assert(!all.includes('groupedConditions('),'Mode-wide workaround must remain reverted');
    assert(!now.some(r=>r.name.includes('BOLT STRIKE') || r.name === 'APOTHECARY ALLOW HEALTH PACK PICKUP'));
    const enumBlock = files['variables.opy'].match(/enum Enhancement:([\s\S]*?)\n\n/)[1];
    assert(enumBlock.includes('DEAD_WEIGHT = 11'));assert(!enumBlock.includes('BOLT'));
    assert(now.find(r=>r.name==='LEECH LIFESTEAL').body.includes('If('));
    assert(!now.find(r=>r.name==='LEECH LIFESTEAL').body.includes('conditions {'));
    assert(now.find(r=>r.name==='PLAYER DROPS POWER UP (MANUAL)').body.includes('And(Global.isGameplayActive, Is Alive(Event Player))'));
    assert(now.find(r=>r.name.startsWith('PLAYER INTERACT (')).body.includes('Abort If(Not(Global.isGameplayActive));'));
    const report = {reference,rebuiltCodeRef:git('rev-parse','HEAD').trim(),elements:rebuilt.elements,
        referenceWithoutExcludedFeaturesElements:original.elements,rules:now.length,warnings:0,
        exactRules:now.length-differences.length,intentionalRuleDifferences:differences,
        exportSha256LF:crypto.createHash('sha256').update(exported).digest('hex'),
        excluded:['Bolt Strike rules, initialization, menu entries, IDs and effect cleanup',
            'beamEffects extension and custom Tesla beams','APOTHECARY ALLOW HEALTH PACK PICKUP',
            'Reverted mode-wide Conditions grouping'],
        sourceOnlyDifferences:['Comments and formatting','Equivalent immutable icon declarations and enum aliases',
            'Existing optimizations retained instead of copying larger expressions',
            'Reference-only Jazzy snapshot and investigation scripts are not needed for runtime feature parity'],
        gameplayVerification:'Run verify-augments, verify-scavenger, verify-leech, verify-living-projectile, verify-healing-capacitor and verify-bulking-season separately.',
        nativeStatus:'User authorized finishing without waiting for in-game debugging; native UI stability is not asserted.'};
    if (process.argv.includes('--report')) fs.writeFileSync('analysis/feature-port-audit.json',JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
}
main().catch(e=>{console.error(e);process.exitCode=1;});
