// Backwards minimization while retaining the full visual environment.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const from=process.argv[2]||'AY',to=process.argv[3]||'AZ',count=Number(process.argv[4]||4);
assert(/^[A-Z]{2}$/.test(from)&&/^[A-Z]{2}$/.test(to)&&from!==to&&Number.isInteger(count)&&count>0);
const inputFile=file(from==='AY'?'AY-full-visuals-27-rule-fixes.ws.txt':from+'-full-visuals-rollback.ws.txt');
const outputFile=file(to+'-full-visuals-rollback.ws.txt');assert(!fs.existsSync(outputFile));
const input=fs.readFileSync(inputFile,'utf8'),prior=JSON.parse(fs.readFileSync(file(from+'-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const baseline=fs.readFileSync(path.join(__dirname,'2026-11-15-pregame-text-V-phase-safe-full-menu.ws.txt'),'utf8');
assert.equal(sha(baseline),prior.vSha256);
const ranked=[...(prior.rankedRemaining||prior.changedRules)].sort((a,b)=>b.delta-a.delta||a.index-b.index);
assert(ranked.length>=count);const selected=ranked.slice(0,count),targets=new Map(selected.map(r=>[r.index,r]));
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const originals=[...baseline.matchAll(re)].map(m=>({name:m[1],text:m[0]}));
let index=0;const changes=[];
let output=input.replace(re,(rule,name)=>{
 const i=index++,t=targets.get(i);if(!t)return rule;
 assert.equal(name,t.name);assert.equal(originals[i].name,name);assert.notEqual(rule,originals[i].text);
 changes.push({...t,before:rule,after:originals[i].text});return originals[i].text;
});
assert.equal(changes.length,count);
const before=[...input.matchAll(re)],after=[...output.matchAll(re)];assert.equal(before.length,after.length);
after.forEach((r,i)=>assert.equal(r[0],targets.has(i)?originals[i].text:before[i][0]));
assert.equal(output.slice(0,output.indexOf('rule (')),input.slice(0,input.indexOf('rule (')));
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_lone_else\n';
 for(const r of changes){
    const aSrc=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true}),bSrc=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    assert.equal(a.nbElements-b.nbElements,r.delta);
 }
 const saved=selected.reduce((n,r)=>n+r.delta,0),deltaFromV=prior.deltaFromV-saved,elements=prior.elements-saved;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${to}: full visuals; restore ${count} costliest remaining rule changes from ${from} to original V.\nElement count: (total ${elements}); +${deltaFromV} from V; saved ${saved} from ${from}.\nFull visual code and Pregame spacing retained. First Reload of fresh match.\n*/`);
 fs.writeFileSync(outputFile,output);
 const report={inputFile:path.basename(inputFile),inputSha256:sha(input),vSha256:sha(baseline),outputSha256:sha(output),
   restored:selected.map(({index,name,delta})=>({index,name,savedElements:delta})),savedFromPrevious:saved,elements,deltaFromV,
   modifiedRulesRemaining:ranked.length-count,rankedRemaining:ranked.slice(count),
   verification:'Only selected rules restored exactly from full V; every other rule and settings unchanged from previous checkpoint. Full decompilation and paired compilation passed. All visuals remain enabled.',
   limitation:`No native game test. ${from} is the last user-confirmed successful full-visual checkpoint; restore it if this backwards step regresses.`};
 fs.writeFileSync(file(to+'-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(inputFile,'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,rankedRemaining:report.rankedRemaining.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
