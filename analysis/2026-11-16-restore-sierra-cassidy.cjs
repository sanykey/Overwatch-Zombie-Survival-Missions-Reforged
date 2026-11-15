const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('AZ-full-visuals-rollback.ws.txt'),'utf8');
const donor=fs.readFileSync(file('AY-full-visuals-27-rule-fixes.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AZ-validation.json'),'utf8'));
const source=JSON.parse(fs.readFileSync(file('AY-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);assert.equal(sha(donor),source.outputSha256);
const names=new Set(['SIERRA TRACKING SHOT HACK','CASSIDY FLASHBANG STUN']);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const donorRules=[...donor.matchAll(re)].map(m=>({name:m[1],text:m[0]}));
const changes=[];let index=0;
let output=input.replace(re,(rule,name)=>{
 const i=index++;if(!names.has(name))return rule;
 assert.equal(donorRules[i].name,name);assert.notEqual(rule,donorRules[i].text);
 const info=source.changedRules.find(r=>r.index===i);assert.equal(info.delta,8);
 changes.push({...info,before:rule,after:donorRules[i].text});return donorRules[i].text;
});
assert.equal(changes.length,2);
const a=[...input.matchAll(re)],b=[...output.matchAll(re)];assert.equal(a.length,b.length);
b.forEach((r,i)=>assert.equal(r[0],names.has(r[1])?donorRules[i].text:a[i][0]));
assert.equal(output.slice(0,output.indexOf('rule (')),input.slice(0,input.indexOf('rule (')));
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_lone_else\n';
 for(const r of changes){
    const aSource=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true}),bSource=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSource,'en-US'),b=await compiler.compile(directives+bSource,'en-US');
    assert.equal(b.nbElements-a.nbElements,8);
 }
 const elements=prior.elements+16,deltaFromV=prior.deltaFromV+16;
 const rankedRemaining=[...prior.rankedRemaining,...changes.map(({before,after,...r})=>r)].sort((a,b)=>b.delta-a.delta||a.index-b.index);
 assert.equal(rankedRemaining.length,25);
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic BA: AZ with Sierra Tracking Shot and Cassidy Flashbang guards restored from AY.\nElement count: (total ${elements}); +${deltaFromV} from V. 25 rule fixes remain.\nKevlar and Brigitte retain original V form. All visuals enabled.\n*/`);
 fs.writeFileSync(file('BA-full-visuals-rollback.ws.txt'),output);
 const report={inputFile:'2026-11-16-AZ-full-visuals-rollback.ws.txt',inputSha256:sha(input),vSha256:prior.vSha256,donorSha256:sha(donor),outputSha256:sha(output),
    reinstated:changes.map(({index,name,delta})=>({index,name,addedElements:delta})),elements,deltaFromV,modifiedRulesRemaining:25,rankedRemaining,
    verification:'Only Sierra/Cassidy rules replaced with exact AY blocks. All other rules/settings identical to AZ. Full decompilation and paired block compilation confirm +16 elements. Full visuals retained.',
    limitation:'No native game test. AY remains the confirmed full-visual checkpoint. AZ outcome not explicitly reported.'};
 fs.writeFileSync(file('BA-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AZ-full-visuals-rollback.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,rankedRemaining:rankedRemaining.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
