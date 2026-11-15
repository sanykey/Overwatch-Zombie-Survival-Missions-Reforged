// AO restores V's entire visuals while carrying only AM's 17 validated fixes.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),old=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const v=fs.readFileSync(old('V-phase-safe-full-menu.ws.txt'),'utf8');
const am=fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8');
const vReport=JSON.parse(fs.readFileSync(old('V-validation.json'),'utf8'));
const amReport=JSON.parse(fs.readFileSync(file('AM-validation.json'),'utf8'));
assert.equal(sha(v),vReport.outputSha256);assert.equal(sha(am),amReport.outputSha256);
const re=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const originals=[...v.matchAll(re)].map(m=>m[0]),fixed=[...am.matchAll(re)].map(m=>m[0]);
const targets=new Map(amReport.rankedRemaining.map(r=>[r.index,r]));
assert.equal(targets.size,17);
const conditionRe=/    conditions \{[\s\S]*?\n    \}/;
const changed=[];let index=0;
let output=v.replace(re,(rule,name)=>{
 const i=index++,target=targets.get(i);if(!target)return rule;
 assert.equal(name,target.name);
 const conditions=fixed[i].match(conditionRe)[0];
 let after=rule.replace(conditionRe,()=>conditions);
 if(name==='PLAYER PICKS UP HEALTH PACK'){
    assert(fixed[i].includes('        If(Event Was Health Pack);\n'));
    after=after.replace('    actions {\n','    actions {\n        If(Event Was Health Pack);\n');
    assert(after.endsWith('    }\n}'));
    after=after.slice(0,-7)+'        End; // synchronous event guard\n    }\n}';
    const restored=after.replace('        If(Event Was Health Pack);\n','').replace('        End; // synchronous event guard\n','')
      .replace(conditionRe,()=>rule.match(conditionRe)[0]);
    assert.equal(restored,rule);
 }else{
    assert.equal(after.slice(after.indexOf('    actions {')),rule.slice(rule.indexOf('    actions {')));
    assert(conditions.includes('And(Global.isGameplayActive, Compare('));
 }
 changed.push({index:i,name,delta:target.delta,before:rule,after});return after;
});
assert.equal(changed.length,17);
const afterRules=[...output.matchAll(re)].map(m=>m[0]);
assert.equal(afterRules.length,originals.length);
afterRules.forEach((r,i)=>{if(!targets.has(i))assert.equal(r,originals[i]);});
const visualLines=s=>s.split('\n').filter(l=>/^\s*(?:Create HUD Text|Create In-World Text|Create Progress Bar|Create Effect|Create Beam Effect|Create Icon|Play Effect|Small Message|Big Message|Set Objective Description|Destroy HUD Text|Destroy In-World Text|Destroy Effect|Destroy Icon)\b/.test(l));
assert.deepEqual(visualLines(output),visualLines(v));
const idLines=s=>s.split('\n').filter(l=>/Last Created Entity|Last Text ID/.test(l));
assert.deepEqual(idLines(output),idLines(v));
(async()=>{
 await compiler.readyPromise;await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_ow2_rule_condition_chase w_start_rule_crash w_cancel_contrary_motion w_lone_else\n';
 let delta=0;
 for(const r of changed){
    const aSrc=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSrc=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    assert.equal(b.nbElements-a.nbElements,r.delta);delta+=r.delta;
 }
 assert.equal(delta,65);
 const elements=vReport.elements+delta;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AO: full visuals from V + AM's 17 validated rule fixes.\nElement count: (total ${elements}); +${delta} from full-visual control V.\nAll visual creations, ID saves and cleanup restored from V.\nPregame spacing retained. Native test with full gameplay visuals still required.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),output);
 const report={vSha256:sha(v),amSha256:sha(am),outputSha256:sha(output),elements,deltaFromV:delta,changedRules:changed.map(({before,after,...r})=>r),
   verification:'All visual and Last-ID lines exactly match full V. All non-target rules unchanged. Sixteen Conditions blocks match AM; one synchronous event guard wraps original V healthpack Actions. Paired compilation of each block confirmed +65. Full decompiler accepted output.',
   limitation:'AM passed user tests without gameplay visuals. AO restores them and still needs native first-Reload testing. No source/main changes or commits.'};
 fs.writeFileSync(file('AO-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AM-rollback-no-gameplay-visuals.ws.txt'),'utf8')),amReport.outputSha256);
 console.log(JSON.stringify({...report,changedRules:changed.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
