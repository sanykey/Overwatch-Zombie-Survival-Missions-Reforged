// Y changes only the gameplay roster-restoration delay in frozen V.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('V-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("PLAYER SWITCHES HERO"\) \{[\s\S]*?^\}/m;
const original=input.match(ruleRe)[0];
assert.equal((original.match(/Wait\(False, Ignore Condition\);/g)||[]).length,1);
assert(original.includes('Wait Until(Not(Has Spawned(Event Player)), 1);'));
const changed=original.replace('Wait(False, Ignore Condition); // 1 element','Wait(0.5, Ignore Condition); // 2 elements');
assert.notEqual(changed,original);
let output=input.replace(ruleRe,()=>changed);
assert.equal(output.replace(ruleRe,()=>original),input);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n';
 const aSource=await compiler.decompileAllRules(original,'en-US',{declareUnknownNames:true});
 const bSource=await compiler.decompileAllRules(changed,'en-US',{declareUnknownNames:true});
 const a=await compiler.compile(directives+aSource,'en-US');
 const b=await compiler.compile(directives+bSource,'en-US');
 const delta=b.nbElements-a.nbElements;
 assert.equal(delta,1);
 const elements=prior.elements+delta;
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic Y: V with 0.5 second gameplay delay before restoring All Heroes.\nElement count: (total ${elements}), +${delta} from V. All gameplay visuals restored to V.\nDo not select a hero immediately: wait 2 seconds after the first Reload menu opens before inspecting it.\nMalevento, 5 ordinary lobby bots, Shion, Engineer + Laser Barricade.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('Y-gameplay-roster-delay.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromV:delta,
   verified:'Only one Wait duration in PLAYER SWITCHES HERO changed, from False (minimum wait) to 0.5 seconds, immediately after Wait Until(Not Has Spawned) and before Set Player Allowed Heroes. Full decompilation and paired block compilation passed.',
   limitation:'Diagnostic only. Current hero is excluded for longer; roster and isHeroSwitchRespawn flag restore later. Tester must wait 2 seconds before choosing. Does not test/reset client internal state directly. No native game test; original Wait Until timeout retained.'};
 fs.writeFileSync(file('Y-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
