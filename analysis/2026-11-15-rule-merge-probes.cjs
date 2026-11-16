// Read-only experiments: compile variants in memory; never write gameplay sources or exports.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const extensions = path.join(process.env.USERPROFILE, '.vscode/extensions');
const version = fs.readdirSync(extensions).filter(n => n.startsWith('zezombye.overpy-')).sort((a,b) => b.localeCompare(a, undefined, {numeric:true}))[0];
const compiler = require(path.join(extensions, version, 'npm/overpy.js'));
function tree(dir, prefix='') {
    return Object.fromEntries(fs.readdirSync(dir, {withFileTypes:true}).flatMap(e => e.isDirectory()
        ? Object.entries(tree(path.join(dir,e.name), prefix+e.name+'/'))
        : e.name.endsWith('.opy') ? [[prefix+e.name, fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]] : []));
}
const baseline = require('./source-layout.cjs').readLegacyTree();
let touchedNames = new Set();
function get(f, file, name) {
    touchedNames.add(name);
    const text = f[file];
    const start = text.indexOf('rule "'+name+'":\n');
    assert(start >= 0, name);
    const tail = text.slice(start);
    const next = tail.slice(1).search(/^(?:rule |def |macro |#!)/m);
    const full = next < 0 ? tail : tail.slice(0, next+1);
    const lines = full.split('\n');
    const conditions = lines.filter(l => /^    @Condition /.test(l)).map(l => l.slice(15));
    const last = lines.reduce((n,l,i) => /^    @/.test(l) ? i : n, 0);
    return {full, conditions, body:lines.slice(last+1).join('\n').trimEnd().replace(/^\n+/, '')};
}
function remove(f,file,name) {const r=get(f,file,name); f[file]=f[file].replace(r.full,''); return r;}
function indent(body) {return body.split('\n').map(l => l ? '    '+l : l).join('\n');}
function ultimate(f) {
    if (!f['apothecary.opy'].includes('rule "[APOTHECARY AUGMENT] ULTIMATE RECHARGE":')) return;
    const r=remove(f,'apothecary.opy','[APOTHECARY AUGMENT] ULTIMATE RECHARGE');
    const file='hero_tuning.opy', name='PLAYER ULTIMATE DAMAGE RESIST';
    const old=get(f,file,name);
    // Keep the exact ultimate edge. Never put Apothecary work after the lasting wait.
    const prefix='    if eventPlayer.augmentId == Augment.APOTHECARY and eventPlayer.getHero() not in [Hero.DVA, Hero.DMON]:\n        eventPlayer.augmentApothecaryReady = true\n';
    f[file]=f[file].replace(old.full,old.full.replace(old.body,prefix+old.body));
}
function rider(f) {
    if (!f['zombie_types.opy'].includes('rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD":')) return;
    const file='zombie_types.opy';
    const a=remove(f,file,'RIDER DETACH WHEN DEAD OR TARGET IS DEAD');
    const b=remove(f,file,'RIDER DETATCH FROM TEAMMATES WHILE ALIVE');
    assert.equal(a.body,b.body);
    const common=a.conditions.filter(c => b.conditions.includes(c));
    const rest=r => r.conditions.filter(c => !common.includes(c)).map(c=>'('+c+')').join(' and ');
    f[file]+='\nrule "[PROBE] RIDER DETACH":\n    @Event eachPlayer\n    @Team 2\n    @Hero widowmaker\n'+common.map(c=>'    @Condition '+c+'\n').join('')+'    @Condition (('+rest(a)+') or ('+rest(b)+')) == true\n\n'+a.body+'\n';
}
function melee(f) {
    const refs=[['enhancements.opy','ZOMBIE HYBRID','Enhancement.ZOMBIE_HYBRID'],['enhancements.opy','BULKING SEASON TOGGLES SIZE','Enhancement.BULKING_SEASON'],['charge_battery.opy','[CHARGE_BATTERY] PLACE BATTERY','Enhancement.CHARGE_BATTERY']];
    const rules=refs.map(([file,name,id])=>({...remove(f,file,name),id}));
    const common=rules[0].conditions.filter(c=>rules.every(r=>r.conditions.includes(c)));
    const rest=r=>r.conditions.filter(c=>!common.includes(c)).map(c=>'('+c+')').join(' and ');
    f['enhancements.opy']+='\nrule "[PROBE] ENHANCEMENT MELEE":\n    @Event eachPlayer\n    @Team 1\n'+common.map(c=>'    @Condition '+c+'\n').join('')+'    @Condition ('+rules.map(r=>'('+rest(r)+')').join(' or ')+') == true\n\n'+rules.map((r,i)=>'    '+(i?'elif':'if')+' eventPlayer.enhancementId == '+r.id+':\n'+indent(r.body)).join('\n')+'\n';
}
function disconnect(f) {
    const refs=[['enhancements.opy','WRESTLER PULL DISCONNECT CLEANUP'],['enhancements.opy','ENGINEER BEAM DISCONNECT CLEANUP'],['apothecary.opy','[APOTHECARY AUGMENT] CURE ICON DISCONNECT CLEANUP'],['augments.opy','GRAPNEL LAUNCHER DISCONNECT CLEANUP']];
    const rules=refs.map(([file,name])=>remove(f,file,name));
    f['player_events.opy']+='\nrule "[PROBE] PLAYER LEFT EFFECT CLEANUP":\n    @Event playerLeft\n    @Team 1\n\n'+rules.map(r=>'    if '+r.conditions.map(c=>'('+c+')').join(' and ')+':\n'+indent(r.body)).join('\n')+'\n';
}
function heroDamage(f) {
    const names=['SIERRA TRACKING SHOT HACK','REINHARDT SHIELD SLAM STUN','BRIGITTE SHIELD BASH STUN','CASSIDY FLASHBANG STUN'];
    const heroes=['Hero.SIERRA','Hero.REINHARDT','Hero.BRIGITTE','Hero.CASSIDY'];
    const rules=names.map(name=>remove(f,'hero_tuning.opy',name));
    f['hero_tuning.opy']+='\nrule "[PROBE] HERO ON HIT STATUS":\n    @Event playerDealtDamage\n    @Team 1\n\n'+rules.map((r,i)=>'    '+(i?'elif':'if')+' eventPlayer.getHero() == '+heroes[i]+':\n        if '+r.conditions.map(c=>'('+c+')').join(' and ')+':\n'+indent(indent(r.body))).join('\n')+'\n';
}
function source(f) {
    return f['includes.opy'].replace(/^#!include "([^"]+)".*$/gm, (_,n)=>f[n].replace(/^#!mainFile .*\n/gm,''))
        .replace(/^#!writeToOutputFile.*\n/gm,'');
}
async function compile(f) {
    const r=await compiler.compile(source(f),'en-US',src.replace(/\\/g,'/')+'/', 'includes.opy');
    const rules=[...r.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body])=>({name,body}));
    const fingerprints=rules.map(r=>({name:r.name,hash:crypto.createHash('sha256').update(r.body.split('\n').filter(l=>!/^\s*(?:"|\/\/)/.test(l)).map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(Boolean).join('\n')).digest('hex')}));
    return {fingerprints,elements:r.nbElements, rules:rules.length, eachPlayerRules:rules.filter(r=>r.body.includes('Ongoing - Each Player;')).length,
        events:rules.reduce((o,r)=>{const event=r.body.match(/event \{\s*([^;]+);/); if(event)o[event[1]]=(o[event[1]]||0)+1; return o;},{}), warnings:r.encounteredWarnings};
}
(async()=>{
    await compiler.readyPromise;
    const {fingerprints:beforeFingerprints,...before}=await compile(baseline);
    // Check that flattening includes has exactly the same size as the normal entry point.
    const normal=await compiler.compile(fs.readFileSync(path.join(src,'includes.opy'),'utf8').replace(/^#!writeToOutputFile.*\n/gm,''),'en-US',src.replace(/\\/g,'/')+'/', 'includes.opy');
    assert.equal(normal.nbElements,before.elements);
    const variants={ultimate,rider,melee,disconnect,heroDamage,combined:f=>{ultimate(f);rider(f);melee(f);disconnect(f);heroDamage(f);}};
    const results={};
    for(const [name,transform] of Object.entries(variants)) {
        touchedNames=new Set();
        const f={...baseline}; transform(f);
        if (JSON.stringify(f) === JSON.stringify(baseline)) {
            results[name]={status:'already implemented'};
            console.log(name, JSON.stringify(results[name]));
            continue;
        }
        const {fingerprints,...after}=await compile(f);
        const unaffected=rs=>rs.filter(r=>!touchedNames.has(r.name)&&!r.name.startsWith('[PROBE]')).map(r=>JSON.stringify(r)).sort();
        assert.deepEqual(unaffected(fingerprints),unaffected(beforeFingerprints));
        results[name]={...after,unchangedCompiledRules:unaffected(fingerprints).length,elementDelta:after.elements-before.elements,ruleDelta:after.rules-before.rules,eachPlayerRuleDelta:after.eachPlayerRules-before.eachPlayerRules};
        console.log(name,JSON.stringify(results[name]));
    }
    // Assert source tree was never modified by a compiler directive or experiment.
    assert.deepEqual(require('./source-layout.cjs').readLegacyTree(),baseline);
    const report={compiler:version,sourceHash:crypto.createHash('sha256').update(JSON.stringify(baseline)).digest('hex'),before,results,
        limitations:'Compiler experiments only. No runtime timing, UI reproduction, or in-game gameplay equivalence test. Melee merge assumes enhancementId is stable during an active ability, as in normal gameplay.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-15-rule-merge-probes.json'),JSON.stringify(report,null,2)+'\n');
    console.log('baseline',JSON.stringify(before));
})().catch(e=>{console.error(e);process.exitCode=1;});
