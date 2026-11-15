// W: preserve verified Pregame V and space startup gameplay visual creations.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('V-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const wait='        Wait(0.25, Ignore Condition); // diagnostic gameplay visual spacing\n';
const changed=[];
let index=0;
let output=input.replace(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,(rule,name)=>{
 const i=index++;
 const permanent=name==='ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)';
 const gameplay=name==='EFFECTS/TEXTS' && rule.includes('Is Game In Progress == True;') && rule.includes('Global.isPregameSetup != True;');
 if(!permanent&&!gameplay)return rule;
 assert(!/Last Text ID|Last Created Entity|Loop;|Call Subroutine|Start Rule/.test(rule),'Lifetime review required');
 let calls=0;
 const result=rule.replace(/^        (?:Create HUD Text|Create In-World Text|Create Effect|Create Icon)\([^\r\n]*\r?\n/gm,line=>{
   calls++; return (calls>1?wait:'')+line;
 });
 changed.push({index:i,name,calls,waits:calls-1,before:rule,after:result});
 return result;
});
assert.equal(changed.length,3);
assert.deepEqual(changed.map(r=>r.calls),[6,4,5]);
assert.equal(output.split(wait).join(''),input);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
 for(const r of changed){
    const aSource=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSource=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSource,'en-US');
    const b=await compiler.compile(directives+bSource,'en-US');
    assert.equal(b.nbElements-a.nbElements,r.waits*2);
 }
 const waits=changed.reduce((n,r)=>n+r.waits,0),elements=prior.elements+waits*2;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic W: verified Pregame V plus spaced gameplay startup visuals.\nElement count: (total ${elements}); +${waits*2} from V, ${waits} added waits.\nGameplay test: wait 10 seconds after combat starts, then hold Reload.\nDiagnostic only: gameplay/win cleanup cancellation is not implemented.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('W-gameplay-visual-spacing.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromV:waits*2,
   changedRules:changed.map(({index,name,calls,waits})=>({index,name,calls,waits})),
   verification:'Removing only the added waits recovers V. Pregame source workaround preserved. Full export parsed; paired block compilations confirm 2 elements per added wait.',
   lifetimeReview:'Only creation-only visual blocks changed; no Last Text ID/Last Created Entity captures, loops/subroutines or stored scratch across added waits. Existing first waits, Conditions, Expressions and gameplay mechanics retained.',
   limitation:'Diagnostic export only. Labels may appear up to 1.25 seconds later within a block; per-player instances can still create simultaneous bursts. Ignore Condition can create late visuals after match-end cleanup. Objective/subroutine/supply-drop/dynamic feature visuals not spaced. No native game test; does not prove runtime-load or network cause.'};
 fs.writeFileSync(file('W-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
