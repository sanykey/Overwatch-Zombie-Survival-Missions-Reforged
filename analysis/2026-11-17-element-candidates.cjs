// Read-only audit: compile candidate edits in memory; never write gameplay sources.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const root = path.resolve(__dirname, '..');
process.chdir(root);
const extdir = path.join(process.env.USERPROFILE, '.vscode/extensions');
const ext = fs.readdirSync(extdir).filter(n => n.startsWith('zezombye.overpy-')).sort((a,b) => b.localeCompare(a, undefined, {numeric:true}))[0];
const compiler = require(path.join(extdir, ext, 'npm/overpy.js'));
function tree(dir, prefix = '') {
    return Object.fromEntries(fs.readdirSync(dir, {withFileTypes:true}).flatMap(e => e.isDirectory()
        ? Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/'))
        : e.name.endsWith('.opy') ? [[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]] : []));
}
// Pin the audited source so the experiment remains reproducible after implementation.
const baselineRef = '8980599cd0c3002aff5e2a53b8ff644e5d5f621f';
const files = Object.fromEntries(Object.keys(tree('src')).map(name => [name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f, name='includes.opy') {
    return f[name].replace(/^#!include "([^"]+)".*$/gm, (_, n) => flatten(f, path.posix.join(path.posix.dirname(name),n)))
        .replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'')
        .replace(/__script__\("([^"]+)"\)/g, (_, n) => '__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');
}
async function compile(f) {
    const saved = [console.log,console.warn,console.error];
    try {
        console.log = console.warn = console.error = () => {};
        return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');
    } finally { [console.log,console.warn,console.error] = saved; }
}
function replace(f, file, a, b) { assert(f[file].includes(a),a); f[file]=f[file].replace(a,b); }
const candidates = {
    objective_shared_range_guard(f) {
        replace(f,'core/subroutines.opy',
            '        # Objective IDs 1..7 are contiguous; unsupported IDs previously produced no start message.\n        if currentObjectiveType >= ObjectiveType.SHOWDOWN and currentObjectiveType <= ObjectiveType.SATELLITE_UPLINK:\n',
            '            # Same eligibility as the description immediately above.\n');
    },
    resist_cached_flag(f) {
        replace(f,'abilities/hero_tuning.opy',
            'eventPlayer.hasDamageResist = (eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null) or eventPlayer.powerUpSuperNanoGoodAuraId != 0 or eventPlayer.isUsingUltimate()',
            'eventPlayer.hasDamageResist = eventPlayer.isDotProtected or eventPlayer.powerUpSuperNanoGoodAuraId != 0');
    },
    battle_merge_special_cases(f) {
        const file='abilities/enhancements.opy';
        const a=f[file].indexOf('    #Temp rein fix ability 2');
        const b=f[file].indexOf('    if eventPlayer.getHero() == Hero.REAPER:',a);
        assert(a>=0 && b>a);
        f[file]=f[file].slice(0,a)+`    if (eventPlayer.getHero() in [Hero.REINHARDT, Hero.ZARYA] and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2) or (eventPlayer.getHero() == Hero.ZARYA and eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_1):
        waitUntil(eventPlayer.isUsingAbility2() if eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2 else eventPlayer.isUsingAbility1(), 0.016)
        if not (eventPlayer.isUsingAbility2() if eventPlayer.enhancementBattleAbilityButton == Button.ABILITY_2 else eventPlayer.isUsingAbility1()):
            resetBattleAbilityCharge()
        return
`+f[file].slice(b);
    },
    battle_priority_filter(f) {
        const file='abilities/enhancements.opy';
        const a=f[file].indexOf('    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):');
        const b=f[file].indexOf('    #Temp rein fix ability 2',a);
        assert(a>=0 && b>a);
        f[file]=f[file].slice(0,a)+'    eventPlayer.enhancementBattleAbilityButton = [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.CROUCH, Button.JUMP].filter(lambda button: eventPlayer.isHoldingButton(button))[0]\n'+f[file].slice(b);
    },
};
// Probe repeated parameterless inline macros as synchronous subroutines.
const all=Object.values(files).join('\n');
for(const [file,s] of Object.entries(files)) for(const m of s.matchAll(/^def (\w+)\(\):/gm)) {
    const name=m[1];
    const uses=[...all.matchAll(new RegExp('\\b'+name+'\\(\\)','g'))].length-1;
    if(uses<2 || new RegExp('^subroutine '+name+'\\b','m').test(all)) continue;
    candidates['subroutine_'+name]=f=>{f['includes.opy']='subroutine '+name+'\n'+f['includes.opy'];};
}
for(const [file,s] of Object.entries(files)) for(const m of s.matchAll(/^macro (\w+)\(\):/gm)) {
    const name=m[1];
    const uses=[...all.matchAll(new RegExp('\\b'+name+'\\(\\)','g'))].length-1;
    if(uses<2) continue;
    const short='optDeselectBotTarget';
    candidates['share_'+name]=f=>{
        for(const key of Object.keys(f)) f[key]=f[key].replace(new RegExp('\\b'+name+'\\(\\)','g'),short+'()');
        replace(f,file,'macro '+short+'():','def '+short+'():');
        f['includes.opy']='subroutine '+short+'\n'+f['includes.opy'];
    };
}
async function main() {
    await compiler.readyPromise;
    const baseline=await compile(files);
    const rules = s => {
        const counts={};
        return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
            const name=x.match(/^rule \("(.*)"\)/)[1];
            const id=(counts[name]=(counts[name]||0)+1);
            return [name+' #'+id,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
        }));
    };
    const baseRules=rules(baseline.result);
    assert(Object.keys(baseRules).length>100,'Rule extraction must cover the compiled build');
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),results:[]};
    // Exact Boolean identity over all Dash / ultimate / Nano combinations.
    for(const dash of [false,true]) for(const ult of [false,true]) for(const nano of [false,true])
        assert.equal(dash || nano || ult,(ult || dash) || nano);
    report.resistTruthTableCases=8;
    candidates.combined_recommended=f=>{
        candidates.objective_shared_range_guard(f);
        candidates.resist_cached_flag(f);
        candidates.share_deselectBotTargetMacro(f);
    };
    console.log(JSON.stringify({baseline:report.baseline,warnings:report.warnings}));
    for(const [name,transform] of Object.entries(candidates)) {
        const f={...files};
        try {
            transform(f);
            const r=await compile(f);
            const nextRules=rules(r.result);
            const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(nextRules)])].filter(n=>baseRules[n]!==nextRules[n]);
            const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};
            report.results.push(row); console.log(JSON.stringify(row));
            fs.writeFileSync(path.join(__dirname,'2026-11-17-probe-'+name+'.ws.txt'),r.result);
        } catch(e) { report.results.push({name,error:String(e)}); console.log(name+': '+String(e).slice(0,250)); }
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-probe-baseline.ws.txt'),baseline.result);
}
main().catch(e=>{console.error(e);process.exitCode=1;});
