// AP/AQ hold AM's fixes constant and split AO's restored gameplay visuals.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const full=fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8');
const hidden=fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AO-validation.json'),'utf8'));
assert.equal(sha(full),prior.outputSha256);assert.equal(sha(hidden),prior.amSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const fullRules=[...full.matchAll(re)],hiddenRules=[...hidden.matchAll(re)];
assert.equal(fullRules.length,hiddenRules.length);
const differences=[];
for(let i=0;i<fullRules.length;i++){
 const a=fullRules[i][0].split('\n'),b=hiddenRules[i][0].split('\n');
 assert.equal(a.length,b.length,fullRules[i][1]);
 let lastTextKind=null;
 for(let j=0;j<a.length;j++){
    const line=a[j];
    if(/^\s*(Create HUD Text|Create Progress Bar HUD Text)\(/.test(line))lastTextKind='hud';
    if(/^\s*(Create In-World Text|Create Progress Bar In-World Text)\(/.test(line))lastTextKind='world';
    if(line===b[j])continue;
    let kind,category;
    if(/^\s*(Create HUD Text|Create Progress Bar HUD Text|Destroy HUD Text|Small Message|Big Message|Set Objective Description)\(/.test(line)){kind='hud';category='action';}
    else if(/^\s*(Create In-World Text|Create Progress Bar In-World Text|Create Effect|Create Beam Effect|Create Icon|Play Effect|Destroy In-World Text|Destroy Effect|Destroy Icon)\(/.test(line)){kind='world';category='action';}
    else if(/Last Text ID/.test(line)){assert(lastTextKind,'Cross-rule text ID needs review: '+line);kind=lastTextKind;category='id-save';}
    else if(/Last Created Entity/.test(line)){kind='world';category='id-save';}
    else throw Error('Unclassified difference: '+fullRules[i][1]+' '+line+' vs '+b[j]);
    if(category==='action')assert.equal(b[j],line.replace(/^(\s*)/,'$1disabled '));
    else assert.equal(b[j],line.replace(/Last Text ID|Last Created Entity/g,'Null'));
    differences.push({rule:i,line:j,kind,category,full:line,hidden:b[j]});
 }
}
const conditions=s=>[...s.matchAll(re)].map(m=>m[0].match(/    conditions \{[\s\S]*?\n    \}/)?.[0]||'');
assert.deepEqual(conditions(full),conditions(hidden));
(async()=>{
 await compiler.readyPromise;
 for(const [mode,kind,suffix] of [['AP','hud','AP-screen-hud-only'],['AQ','world','AQ-world-visuals-only']]){
    const lookup=new Map(differences.filter(d=>d.kind===kind).map(d=>[d.rule+':'+d.line,d]));
    let i=0;
    let out=hidden.replace(re,rule=>{
       const current=i++;
       return rule.split('\n').map((line,j)=>lookup.get(current+':'+j)?.full||line).join('\n');
    });
    assert.deepEqual(conditions(out),conditions(full));
    const outRules=[...out.matchAll(re)];
    for(const d of differences)assert.equal(outRules[d.rule][0].split('\n')[d.line],d.kind===kind?d.full:d.hidden);
    await compiler.decompileAllRules(out,'en-US');
    const selected=differences.filter(d=>d.kind===kind);
    out=out.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: AM + restored gameplay ${kind==='hud'?'screen HUD/messages':'world texts/effects/icons/beams'}.\nAll 17 AM fixes retained. Original Pregame and debug HUD unchanged.\nMatched creation, Last ID save and per-ID cleanup restored as a unit.\nNo element-saving claim: visual definitions are disabled/enabled for diagnosis.\n*/`);
    fs.writeFileSync(file(suffix+'.ws.txt'),out);
    const report={mode,fullSha256:sha(full),hiddenSha256:sha(hidden),outputSha256:sha(out),restoredGroup:kind,
       restoredActions:selected.filter(d=>d.category==='action').length,restoredIdSaves:selected.filter(d=>d.category==='id-save').length,
       restoredLines:selected.map(({full,hidden,...d})=>d),
       verification:'AM/AO differ only in reviewed visual actions and ID saves. Restored selected category with corresponding ID/cleanup, all Conditions identical across AM/AO/AP/AQ. Every changed line validated, full export parsed. Pregame/debug originally identical and retained.',
       limitation:'No native game test. Disabled visual-ID branches can behave differently. AP includes messages/objective description; AQ includes audio from Play Effect. Native hero visuals/physical entities remain in both. Does not identify CPU/network cause.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({...report,restoredLines:selected.length},null,2));
 }
 assert.equal(sha(fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8')),prior.amSha256);
 assert.equal(sha(fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8')),prior.outputSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
