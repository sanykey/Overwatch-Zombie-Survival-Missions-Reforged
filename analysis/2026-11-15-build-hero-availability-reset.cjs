// Z tests the native reset action, independently of Y's timing change.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('V-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("PLAYER SWITCHES HERO"\) \{[\s\S]*?^\}/m;
const original=input.match(ruleRe)[0];
const old='Set Player Allowed Heroes(Event Player, All Heroes);';
const replacement='Reset Player Hero Availability(Event Player);';
assert.equal(original.split(old).length-1,1);
const changed=original.replace(old,replacement);
let output=input.replace(ruleRe,()=>changed);
assert.equal(output.replace(ruleRe,()=>original),input);
// The frozen export must not contain explicit enabled/disabled hero roster lists.
const settings=input.slice(input.indexOf('settings'),input.indexOf('variables'));
assert(!/enabled heroes|disabled heroes/i.test(settings));
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const aSource=await compiler.decompileAllRules(original,'en-US',{declareUnknownNames:true});
 const bSource=await compiler.decompileAllRules(changed,'en-US',{declareUnknownNames:true});
 const a=await compiler.compile('#!debugElementCount\n'+aSource,'en-US');
 const b=await compiler.compile('#!debugElementCount\n'+bSource,'en-US');
 const delta=b.nbElements-a.nbElements;
 assert.equal(delta,0);
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic Z: V with Reset Player Hero Availability on gameplay return.\nElement count: (total ${prior.elements}), unchanged from V.\nNo explicit hero roster restrictions in supplied settings; do not add any for this test.\nMalevento, 5 ordinary lobby bots, Shion, Engineer + Laser Barricade. First Reload only.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('Z-gameplay-reset-availability.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements:prior.elements,deltaFromV:delta,
   verified:'Only gameplay roster restoration action changed from Set Player Allowed Heroes(All Heroes) to Reset Player Hero Availability. Original minimum wait and all other actions retained. Supplied settings have no explicit enabled/disabled hero lists. Decompiler and paired compilation passed.',
   limitation:'Reset follows lobby hero availability, unlike explicit All Heroes. Do not add lobby hero restrictions. Does not reset every native UI state. No native game test. No change to Pregame restoration or gameplay mechanics.'};
 fs.writeFileSync(file('Z-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
