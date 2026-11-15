// First backwards step from the user-validated AH; AE supplies original rules.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('AH-compact-phase-id-no-gameplay-visuals.ws.txt'),'utf8');
const baseline=fs.readFileSync(file('AE-gameplay-no-visuals-control.ws.txt'),'utf8');
const ah=JSON.parse(fs.readFileSync(file('AH-validation.json'),'utf8'));
const ag=JSON.parse(fs.readFileSync(file('AE-AF-validation.json'),'utf8'));
assert.equal(sha(input),ah.outputSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const originals=[...baseline.matchAll(re)].map(m=>({name:m[1],text:m[0]}));
const ranked=[...ag.changes,...ah.groupedPairs].sort((a,b)=>b.delta-a.delta||a.index-b.index);
const selected=ranked.slice(0,2);
assert.deepEqual(selected.map(r=>r.name),['KEVLAR RANGED DAMAGE COMPENSATION','BRIGITTE SHIELD BASH STUN']);
const targets=new Map(selected.map(r=>[r.index,r]));
const changed=[];let index=0;
let output=input.replace(re,(rule,name)=>{
 const i=index++;if(!targets.has(i))return rule;
 assert.equal(name,targets.get(i).name);assert.equal(originals[i].name,name);
 changed.push({index:i,name,before:rule,after:originals[i].text,saved:targets.get(i).delta});
 return originals[i].text;
});
assert.equal(changed.length,2);
const after=[...output.matchAll(re)].map(m=>m[0]);
const before=[...input.matchAll(re)].map(m=>m[0]);
assert.equal(after.length,before.length);
after.forEach((rule,i)=>assert.equal(rule,targets.has(i)?originals[i].text:before[i]));
assert.equal(output.slice(0,output.indexOf('rule (')),input.slice(0,input.indexOf('rule (')));
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_lone_else\n';
 for(const r of changed){
    const aSource=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSource=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSource,'en-US'),b=await compiler.compile(directives+bSource,'en-US');
    assert.equal(a.nbElements-b.nbElements,r.saved);
 }
 const saved=selected.reduce((n,r)=>n+r.delta,0),remaining=ah.deltaFromAE-saved;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AI: AH with original AE rules restored for Kevlar compensation and Brigitte shield bash.\nGuard/grouping overhead now +${remaining} elements relative to AE; saved ${saved} from AH.\nGameplay visuals remain disabled; Pregame/debug unchanged. First Reload in a new match only.\n*/`);
 fs.writeFileSync(file('AI-revert-two-costliest-no-gameplay-visuals.ws.txt'),output);
 const report={inputSha256:sha(input),baselineSha256:sha(baseline),outputSha256:sha(output),
    restored:selected.map(({index,name,delta})=>({index,name,savedElements:delta})),savedFromAH:saved,deltaFromAE:remaining,
    modifiedRulesRemaining:ranked.length-2,rankedRemaining:ranked.slice(2).map(({index,name,delta})=>({index,name,delta})),
    verification:'Exactly two selected rules restored byte-for-byte from AE. All other rules/settings unchanged from AH. Full decompiler accepted output; paired block compilation confirmed 26 saved elements.',
    limitation:'No native game test. AH is the last user-confirmed successful checkpoint. If AI regresses, restore these changes before further backwards steps; random bots require repeated fresh matches.'};
 fs.writeFileSync(file('AI-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AH-compact-phase-id-no-gameplay-visuals.ws.txt'),'utf8')),ah.outputSha256);
 console.log(JSON.stringify({...report,rankedRemaining:report.rankedRemaining.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
