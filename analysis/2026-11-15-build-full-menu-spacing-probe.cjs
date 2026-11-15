// U restores frozen A's complete menu and spaces only player world texts.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('A-control.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('validation.json'),'utf8'));
assert.equal(sha(input),prior.controlSha256);
const ruleRe=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m;
let count=0;
const wait='        Wait(0.25, Ignore Condition); // diagnostic full-menu spacing\n';
let output=input.replace(ruleRe,rule=>rule.replace(/^        Create In-World Text\([^\r\n]*\r?\n/gm,line=>{
    count++;
    return (count>1?wait:'')+line;
}));
assert.equal(count,5);
assert.equal(output.split(wait).join(''),input);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
 const sourceA=await compiler.decompileAllRules(input.match(ruleRe)[0],'en-US',{declareUnknownNames:true});
 const sourceB=await compiler.decompileAllRules(output.match(ruleRe)[0],'en-US',{declareUnknownNames:true});
 const a=await compiler.compile(directives+sourceA,'en-US');
 const b=await compiler.compile(directives+sourceB,'en-US');
 assert.equal(b.nbElements-a.nbElements,8);
 const elements=prior.controlElements+8;
 // Remove stale compiler cost summary while retaining all executable content.
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic U: full frozen A menu, 0.25 s between five per-player world text calls.\nElement count: (total ${elements}), +8 from A.\nMalevento, same five standard lobby bots, Shion then wait 2 seconds before Crouch.\nDiagnostic only: phase-end cancellation still requires production review.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('U-full-menu-spaced.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromA:8,spacingSeconds:0.25,totalPerPlayerSpacingSeconds:1,
  verified:'Only four Wait(0.25, Ignore Condition) actions added between player Pregame world text creations. Removing waits recovers frozen A before comment/header cleanup. All HUD, world text expressions, effects, settings, Conditions and rules retained. Decompiler accepted output; paired block compilation measured +8 elements.',
  lifetimeReview:'No shared scratch retained across waits in this block. Event Player retains owning player; dynamic text expressions still reevaluate as in A. All players can execute this block independently; global arrays and phase-owned aliases can change at START GAME.',
  limitation:'Diagnostic only; do not treat as production fix. Ignore Condition may create late texts after phase cleanup if pregame ends during spacing; production integration must cancel remaining creation safely. Concurrent players may still produce bursts. Wait 2 seconds after hero appears before return, use same timing in A. No native game test.'};
 fs.writeFileSync(file('U-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('A-control.ws.txt'),'utf8')),prior.controlSha256);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
