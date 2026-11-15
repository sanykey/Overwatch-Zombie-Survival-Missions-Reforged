// Split failing AQ into world texts versus entities/playback on stable AM.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const hidden=fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8');
const world=fs.readFileSync(file('AQ-world-visuals-only.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AQ-validation.json'),'utf8'));
assert.equal(sha(hidden),prior.hiddenSha256);assert.equal(sha(world),prior.outputSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const a=[...hidden.matchAll(re)],b=[...world.matchAll(re)];
assert.equal(a.length,b.length);
const differences=prior.restoredLines.map(d=>{
 const line=b[d.rule][0].split('\n')[d.line],original=a[d.rule][0].split('\n')[d.line];
 assert.notEqual(line,original);
 let kind;
 if(d.category==='id-save'){
    if(line.includes('Last Text ID'))kind='text';
    else {assert(line.includes('Last Created Entity'));kind='effect';}
 }else{
    assert(d.category==='action');
    kind=/^\s*(Create In-World Text|Create Progress Bar In-World Text|Destroy In-World Text)\(/.test(line)?'text':'effect';
    if(kind==='effect')assert(/^\s*(Create Effect|Create Beam Effect|Create Icon|Play Effect|Destroy Effect|Destroy Icon)\(/.test(line));
 }
 return {...d,kind,enabled:line,disabled:original};
});
(async()=>{
 await compiler.readyPromise;
 for(const [mode,kind,suffix] of [['AR','text','AR-world-texts-only'],['AS','effect','AS-world-effects-only']]){
    const selected=differences.filter(d=>d.kind===kind);
    const lookup=new Map(selected.map(d=>[d.rule+':'+d.line,d.enabled]));
    let i=0;
    let output=hidden.replace(re,rule=>{
       const index=i++;return rule.split('\n').map((line,j)=>lookup.get(index+':'+j)??line).join('\n');
    });
    const result=[...output.matchAll(re)];
    for(let j=0;j<a.length;j++){
       assert.equal(a[j][0].match(/    conditions \{[\s\S]*?\n    \}/)?.[0],result[j][0].match(/    conditions \{[\s\S]*?\n    \}/)?.[0]);
       const expected=a[j][0].split('\n');
       selected.filter(d=>d.rule===j).forEach(d=>expected[d.line]=d.enabled);
       assert.equal(result[j][0],expected.join('\n'));
    }
    await compiler.decompileAllRules(output,'en-US');
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: AM + gameplay world ${kind==='text'?'texts/progress bars':'effects/icons/beams/Play Effect'}.\nScreen gameplay HUD remains disabled, as in AQ; Pregame/debug retained.\nAll 17 AM fixes unchanged; matched ID saves and cleanup restored.\nNo compiled-element-saving claim; diagnostic enable/disable only.\n*/`);
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const report={mode,amSha256:sha(hidden),aqSha256:sha(world),outputSha256:sha(output),restoredGroup:kind,
       restoredActions:selected.filter(d=>d.category==='action').length,restoredIdSaves:selected.filter(d=>d.category==='id-save').length,
       restoredLines:selected.map(({enabled,disabled,...d})=>d),
       verification:'Conditions and all 17 fixes identical to AM/AQ. Every rule equals AM plus only reviewed AQ lines of selected category. ID saves and per-ID cleanup restored with matching object type. Full export parsed by OverPy.',
       limitation:'No native test. Visual-ID-driven branches may differ between enabled/disabled groups; native physical entities remain. AS includes visual and audio Play Effect calls. Counts describe source actions, not simultaneous objects.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({...report,restoredLines:selected.length},null,2));
 }
 assert.equal(sha(fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8')),prior.hiddenSha256);
 assert.equal(sha(fs.readFileSync(file('AQ-world-visuals-only.ws.txt'),'utf8')),prior.outputSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
