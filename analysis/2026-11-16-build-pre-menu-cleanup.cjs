// AW/AX distinguish live world objects near menu entry from previous creation.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AO-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const re=/^rule \("PLAYER SWITCHES HERO"\) \{[\s\S]*?^\}/m;
const original=input.match(re)[0];
const anchor='        Call Subroutine(excludeCurrentHeroFromSelection);';
assert.equal(original.split(anchor).length-1,1);
(async()=>{
 await compiler.readyPromise;
 for(const [mode,cleanup,suffix] of [['AW',true,'AW-clear-world-before-menu'],['AX',false,'AX-menu-pause-control']]){
    const extra=(cleanup?'        Destroy All Effects;\n        Destroy All Icons;\n        Destroy All In-World Text;\n':'')+
       '        Wait(0.25, Ignore Condition); // matched pre-menu diagnostic pause\n';
    const changed=original.replace(anchor,extra+anchor);
    let output=input.replace(re,()=>changed);
    assert.equal(output.replace(extra,''),input);
    await compiler.decompileAllRules(output,'en-US');
    const directives='#!debugElementCount\n';
    const aSrc=await compiler.decompileAllRules(original,'en-US',{declareUnknownNames:true});
    const bSrc=await compiler.decompileAllRules(changed,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US'),b=await compiler.compile(directives+bSrc,'en-US');
    const delta=b.nbElements-a.nbElements;assert.equal(delta,cleanup?5:2);
    const elements=prior.elements+delta;
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: AO + ${cleanup?'clear live world visuals, then':'only'} 0.25s pause before first gameplay menu.\nElement count: (total ${elements}), +${delta} from AO. Screen/debug HUD preserved.\n${cleanup?'Destructive visual diagnostic: world cues are removed for the entire match. Do not use for normal play.':'Matched timing control: no world object cleanup.'}\nDo not use optional abilities/items. Inspect first Reload of a fresh match.\n*/`);
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const report={mode,inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromAO:delta,
       cleanupWorldVisuals:cleanup,pauseSeconds:0.25,
       verification:'Only three world cleanup actions (AW) and matched wait (AW/AX) inserted after original 5-second hold, before hero exclusion. Removing insertion recovers AO. Full export parsed; paired block compile confirmed delta.',
       limitation:'No native test. AW removes global world cues for all players, but does not erase their ID slots or create history. Visual-ID-dependent branches may react or recreate objects during the wait. Screen HUD, native models, physical projectiles and mechanics remain. Runtime counts must be observed; failure after cleanup does not prove previous creation alone is causal.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
 }
 assert.equal(sha(fs.readFileSync(file('AO-restored-visuals-17-rule-fixes.ws.txt'),'utf8')),prior.outputSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
