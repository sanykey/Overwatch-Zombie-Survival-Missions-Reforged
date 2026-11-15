// AU/AV split world creation by rule owner, retaining the successful screen HUD.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const base=fs.readFileSync(file('AP-screen-hud-only.ws.txt'),'utf8');
const full=fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8');
const ap=JSON.parse(fs.readFileSync(file('AP-validation.json'),'utf8'));
const aq=JSON.parse(fs.readFileSync(file('AQ-validation.json'),'utf8'));
assert.equal(sha(base),ap.outputSha256);assert.equal(sha(full),ap.fullSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const a=[...base.matchAll(re)],b=[...full.matchAll(re)];assert.equal(a.length,b.length);
const botRules=new Set(b.flatMap((r,i)=>{
 const event=r[0].match(/    event \{[\s\S]*?\n    \}/)?.[0]||'';
 return event.includes('\n        Team 2;')||r[1]==='botRespawnInitialization'?[i]:[];
}));
const differences=aq.restoredLines.map(d=>{
 const enabled=b[d.rule][0].split('\n')[d.line],disabled=a[d.rule][0].split('\n')[d.line];
 assert.notEqual(enabled,disabled);return {...d,kind:botRules.has(d.rule)?'bot':'other',enabled,disabled};
});
(async()=>{
 await compiler.readyPromise;
 for(const [mode,kind,suffix] of [['AU','other','AU-world-except-zombie-rules'],['AV','bot','AV-zombie-rule-world-only']]){
    const selected=differences.filter(d=>d.kind===kind);
    const lookup=new Map(selected.map(d=>[d.rule+':'+d.line,d.enabled]));let i=0;
    let output=base.replace(re,rule=>{
       const index=i++;return rule.split('\n').map((line,j)=>lookup.get(index+':'+j)??line).join('\n');
    });
    const rules=[...output.matchAll(re)];
    for(let j=0;j<a.length;j++){
       const expected=a[j][0].split('\n');selected.filter(d=>d.rule===j).forEach(d=>expected[d.line]=d.enabled);
       assert.equal(rules[j][0],expected.join('\n'));
       const cond=s=>s.match(/    conditions \{[\s\S]*?\n    \}/)?.[0];assert.equal(cond(rules[j][0]),cond(b[j][0]));
    }
    await compiler.decompileAllRules(output,'en-US');
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: screen HUD restored; world visuals enabled for ${kind==='bot'?'Team 2 rules and botRespawnInitialization':'all rules except Team 2 and botRespawnInitialization'}.\n17 fixes and original Pregame/debug unchanged; no AT spacing.\nShared helpers (e.g. explosionSequence) belong to the other group.\nNo element-saving claim; creation/ID/cleanup lines restored together from AO.\n*/`);
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const groupRules=[...new Set(selected.map(d=>d.rule))].map(i=>({index:i,name:b[i][1]}));
    const report={mode,inputSha256:sha(base),fullSha256:sha(full),outputSha256:sha(output),worldGroup:kind,
       restoredActions:selected.filter(d=>d.category==='action').length,restoredIdSaves:selected.filter(d=>d.category==='id-save').length,
       restoredRules:groupRules,
       verification:'Every output rule equals AP plus selected world visual/ID/cleanup lines from AO. All Conditions/17 fixes preserved. Full decompiler accepted both exports.',
       limitation:'No native game test. Bot group means explicit Team2 events plus botRespawnInitialization, not every effect a zombie might cause. Shared helpers and objectives are in other group. Screen HUD is enabled equally in both.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({...report,restoredRules:groupRules.length},null,2));
 }
 assert.equal(sha(fs.readFileSync(file('AP-screen-hud-only.ws.txt'),'utf8')),ap.outputSha256);
 assert.equal(sha(fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8')),ap.fullSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
