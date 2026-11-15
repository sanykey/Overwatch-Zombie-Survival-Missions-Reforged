// AT repeats W's initialization-spacing test on AO's 17-rule fixed basis.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AO-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const wait='        Wait(0.25, Ignore Condition); // diagnostic fixed-gameplay spacing\n';
const changed=[];let index=0;
let output=input.replace(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,(rule,name)=>{
 const i=index++;
 const permanent=name==='ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)';
 const gameplay=name==='EFFECTS/TEXTS'&&rule.includes('Is Game In Progress == True;')&&rule.includes('Global.isPregameSetup != True;');
 if(!permanent&&!gameplay)return rule;
 assert(!/Last Text ID|Last Created Entity|Loop;|Call Subroutine|Start Rule/.test(rule));
 let count=0;
 const after=rule.replace(/^        (?:Create HUD Text|Create In-World Text|Create Effect|Create Icon)\([^\r\n]*\r?\n/gm,line=>{
    count++;return (count>1?wait:'')+line;
 });
 changed.push({index:i,name,calls:count,waits:count-1,before:rule,after});return after;
});
assert.deepEqual(changed.map(r=>r.calls),[6,4,5]);
assert.equal(output.split(wait).join(''),input);
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
 for(const r of changed){
    const aSrc=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSrc=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    assert.equal(b.nbElements-a.nbElements,r.waits*2);
 }
 const delta=changed.reduce((s,r)=>s+r.waits*2,0),elements=prior.elements+delta;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AT: full AO visuals and 17 fixes, startup visual calls spaced 0.25s.\nElement count: (total ${elements}); +${delta} from AO, +${prior.deltaFromV+delta} from V.\nTest first Reload 10 seconds after gameplay begins. No gameplay mechanic waits changed.\nDiagnostic only: pending creations can outlive match-end cleanup.\n*/`);
 fs.writeFileSync(file('AT-full-visuals-spaced-startup.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromAO:delta,deltaFromV:prior.deltaFromV+delta,
   changedRules:changed.map(({before,after,...r})=>r),
   verification:'Removing only 12 waits recovers AO. All Conditions and 17 fixes unchanged; all visuals retained. Full decompiler accepted output; paired block compilation confirmed +24 elements.',
   lifetimeReview:'Selected blocks have only visual creations and no ID captures, loops, subroutine calls or stored shared scratch. Other blocks, damage/healing actions and Create/ID-save pairs unmodified.',
   limitation:'Diagnostic only. Existing delays/visual parameters retained, panels finish up to 1.25 seconds later. Other players/blocks and objective/ability visuals may still create simultaneous bursts. Ignore Condition not yet protected against match-end cleanup. No native game test.'};
 fs.writeFileSync(file('AT-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
