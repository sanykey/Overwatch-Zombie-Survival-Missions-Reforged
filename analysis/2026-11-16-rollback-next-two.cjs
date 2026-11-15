// Continue backwards from a user-confirmed checkpoint, restoring original AE rules.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const from=process.argv[2]||'AI',to=process.argv[3]||'AJ';
assert(/^[A-Z]{2}$/.test(from)&&/^[A-Z]{2}$/.test(to)&&from!==to);
const inputFile=file(from==='AI'?'AI-revert-two-costliest-no-gameplay-visuals.ws.txt':from+'-rollback-no-gameplay-visuals.ws.txt');
const outputFile=file(to+'-rollback-no-gameplay-visuals.ws.txt');
assert(!fs.existsSync(outputFile),'Do not overwrite an existing trial');
const input=fs.readFileSync(inputFile,'utf8'),prior=JSON.parse(fs.readFileSync(file(from+'-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const baseline=fs.readFileSync(file('AE-gameplay-no-visuals-control.ws.txt'),'utf8');
assert.equal(sha(baseline),prior.baselineSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const originals=[...baseline.matchAll(re)].map(m=>({name:m[1],text:m[0]}));
const selected=prior.rankedRemaining.slice(0,2);assert.equal(selected.length,2);
const targets=new Map(selected.map(r=>[r.index,r]));
const changed=[];let index=0;
let output=input.replace(re,(rule,name)=>{
 const i=index++;if(!targets.has(i))return rule;
 assert.equal(name,targets.get(i).name);assert.equal(name,originals[i].name);
 assert.notEqual(rule,originals[i].text);
 changed.push({index:i,name,before:rule,after:originals[i].text,saved:targets.get(i).delta});
 return originals[i].text;
});
assert.equal(changed.length,2);
const before=[...input.matchAll(re)].map(m=>m[0]),after=[...output.matchAll(re)].map(m=>m[0]);
assert.equal(before.length,after.length);
after.forEach((r,i)=>assert.equal(r,targets.has(i)?originals[i].text:before[i]));
assert.equal(output.slice(0,output.indexOf('rule (')),input.slice(0,input.indexOf('rule (')));
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_lone_else\n';
 for(const r of changed){
    const aSrc=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSrc=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    assert.equal(a.nbElements-b.nbElements,r.saved);
 }
 const saved=selected.reduce((n,r)=>n+r.delta,0),remaining=prior.deltaFromAE-saved;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${to}: backwards step from ${from}; restore two costliest remaining rules from AE.\nRemaining overhead +${remaining} from AE; saved ${saved} compiled elements from ${from}.\nGameplay visuals remain disabled. Pregame/debug and every other rule unchanged.\n*/`);
 fs.writeFileSync(outputFile,output);
 const report={inputFile:path.basename(inputFile),inputSha256:sha(input),baselineSha256:sha(baseline),outputSha256:sha(output),
   restored:selected.map(({index,name,delta})=>({index,name,savedElements:delta})),savedFromPrevious:saved,deltaFromAE:remaining,
   modifiedRulesRemaining:prior.modifiedRulesRemaining-2,rankedRemaining:prior.rankedRemaining.slice(2),
   verification:'Exactly two AE rule blocks restored; all other executable content/settings identical to previous checkpoint. Full decompiler accepted output; paired block compilation confirmed savings.',
   limitation:`No native game test. ${from} is the last user-confirmed successful checkpoint; return to it if this backwards step regresses.`};
 fs.writeFileSync(file(to+'-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(inputFile,'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,rankedRemaining:report.rankedRemaining.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
