// X disables the visual creations examined by W; uses frozen V, not W waits.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('V-validation.json'),'utf8'));
const w=JSON.parse(fs.readFileSync(file('W-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
assert.equal(w.inputSha256,prior.outputSha256);
const targets=new Map(w.changedRules.map(r=>[r.index,r]));
const changes=[];
let index=0;
let output=input.replace(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,(rule,name)=>{
 const i=index++,target=targets.get(i);
 if(!target)return rule;
 assert.equal(name,target.name);
 assert(!/Last Text ID|Last Created Entity|Loop;|Call Subroutine|Start Rule/.test(rule));
 let count=0;
 const changed=rule.replace(/^        (Create HUD Text|Create In-World Text|Create Effect|Create Icon)\([^\r\n]*/gm,line=>{
    count++;return line.replace(/^        /,'        disabled ');
 });
 assert.equal(count,target.calls);
 changes.push({index:i,name,disabledCreationCalls:count,rule:changed});
 return changed;
});
assert.equal(changes.length,3);
assert.equal(changes.reduce((n,r)=>n+r.disabledCreationCalls,0),15);
assert.equal(output.replace(/^        disabled (Create HUD Text|Create In-World Text|Create Effect|Create Icon)\(/gm,'        $1('),input);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 for(const r of changes){
    const source=await compiler.decompileAllRules(r.rule,'en-US',{declareUnknownNames:true});
    const result=await compiler.compile('#!debugElementCount\n#!suppressWarnings w_dark_color\n'+source,'en-US');
    assert(!/^\s*(?:Create HUD Text|Create In-World Text|Create Effect|Create Icon)\(/m.test(result.result));
 }
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic X: V with creation actions in three gameplay visual blocks disabled.\n15 definitions retained but disabled; no element-saving claim.\nPregame workaround preserved. Gameplay HUD, infection/revive hints partly absent.\nFirst Reload only: Malevento, 5 ordinary lobby bots, Shion, Engineer + Laser Barricade.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('X-disabled-gameplay-startup-visuals.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),
   changedRules:changes.map(({rule,...r})=>r),
   verified:'Only disabled flags on 15 visual creation definitions added. Removing flags recovers frozen V before diagnostic comment cleanup. Conditions/settings/mechanics/Pregame preserved. Decompiler accepted export; each changed block recompiles without active creation actions.',
   limitation:'Diagnostic only: partial combat HUD, revive/infection cues and personal status panels absent. Objective/powerup/ability visuals and objective description/debug HUD remain. No native game test; no element optimization claimed.'};
 fs.writeFileSync(file('X-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
