// AY restores all 27 cheap AH fixes on full V visuals, without later timing tests.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),old=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const v=fs.readFileSync(old('V-phase-safe-full-menu.ws.txt'),'utf8'),ah=fs.readFileSync(file('AH-compact-phase-id-no-gameplay-visuals.ws.txt'),'utf8');
const vr=JSON.parse(fs.readFileSync(old('V-validation.json'),'utf8')),hr=JSON.parse(fs.readFileSync(file('AH-validation.json'),'utf8')),gr=JSON.parse(fs.readFileSync(file('AE-AF-validation.json'),'utf8'));
assert.equal(sha(v),vr.outputSha256);assert.equal(sha(ah),hr.outputSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,cond=/    conditions \{[\s\S]*?\n    \}/;
const originals=[...v.matchAll(re)].map(m=>m[0]),fixed=[...ah.matchAll(re)].map(m=>m[0]);
const targets=new Map([...gr.changes.map(r=>({...r,kind:'event'})),...hr.groupedPairs.map(r=>({...r,kind:'ongoing'}))].map(r=>[r.index,r]));
assert.equal(targets.size,27);
const changes=[];let index=0;
let output=v.replace(re,(rule,name)=>{
 const i=index++,t=targets.get(i);if(!t)return rule;assert.equal(t.name,name);
 let after=rule.replace(cond,()=>fixed[i].match(cond)[0]);
 if(t.kind==='event'){
    const guard=fixed[i].match(/    actions \{\n(        If\([^\n]*\);\n)/)?.[1];assert(guard);
    const end='        End; // synchronous event guard\n';assert(fixed[i].includes(end));
    after=after.replace('    actions {\n','    actions {\n'+guard);
    assert(after.endsWith('    }\n}'));after=after.slice(0,-7)+end+'    }\n}';
    assert.equal(after.replace(guard,'').replace(end,'').replace(cond,()=>rule.match(cond)[0]),rule);
 }else assert.equal(after.slice(after.indexOf('    actions {')),rule.slice(rule.indexOf('    actions {')));
 changes.push({index:i,name,kind:t.kind,delta:t.delta,before:rule,after});return after;
});
assert.equal(changes.length,27);
const outRules=[...output.matchAll(re)].map(m=>m[0]);
outRules.forEach((r,i)=>{if(targets.has(i))assert.equal(r.match(cond)[0],fixed[i].match(cond)[0]);else assert.equal(r,originals[i]);});
const visual=s=>s.split('\n').filter(l=>/^\s*(?:Create HUD Text|Create In-World Text|Create Progress Bar|Create Effect|Create Beam Effect|Create Icon|Play Effect|Small Message|Big Message|Set Objective Description|Destroy HUD Text|Destroy In-World Text|Destroy Effect|Destroy Icon)\b/.test(l)||/Last Created Entity|Last Text ID/.test(l));
assert.deepEqual(visual(output),visual(v));
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_ow2_rule_condition_chase w_start_rule_crash w_cancel_contrary_motion w_lone_else\n';
 let delta=0;
 for(const r of changes){
    const aSrc=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true}),bSrc=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    assert.equal(b.nbElements-a.nbElements,r.delta);delta+=r.delta;
 }
 assert.equal(delta,152);const elements=vr.elements+delta;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AY: all full V visuals + all 27 cheap AH fixes.\nElement count: (total ${elements}); +${delta} from V, +87 from AO.\nOriginal gameplay timing/roster restoration retained, Pregame spacing retained.\nNo visual suppression or AW cleanup/AX pause. First Reload of each fresh match.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('AY-full-visuals-27-rule-fixes.ws.txt'),output);
 const report={vSha256:sha(v),ahSha256:sha(ah),outputSha256:sha(output),elements,deltaFromV:delta,deltaFromAO:87,
   changedRules:changes.map(({before,after,...r})=>r),
   verification:'Full original V visual actions, ID saves and cleanup match exactly. All 27 fixed Conditions match AH; 11 event guards wrap original V Actions, 16 ongoing Actions unchanged. All non-target rules unchanged. Full decompiler accepted export; paired compilation confirmed deltas.',
   limitation:'AH passed without gameplay visuals, not with them. AY requires native testing. No CPU improvement claim. Previous backward minimization was performed without gameplay visuals and is not evidence that restored fixes are redundant under full visuals.'};
 fs.writeFileSync(file('AY-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AH-compact-phase-id-no-gameplay-visuals.ws.txt'),'utf8')),hr.outputSha256);
 console.log(JSON.stringify({...report,changedRules:changes.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
