// Keep N's action definitions; vary only Workshop action-enabled flags.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('N-constant-host-text.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('N-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m;
const baselineRule=input.match(ruleRe)[0];
const variants=[['O',0],['P',1],['Q',3],['R',4]];
const requested=process.argv[2];
assert(!requested || variants.some(([mode])=>mode===requested),'Use O, P, Q or R');
(async()=>{
 await compiler.readyPromise;
 for(const [mode,active] of variants.filter(([mode])=>!requested || mode===requested)){
    let count=0;
    const rule=baselineRule.replace(/^        Create In-World Text\([^\r\n]*/gm,line=>{
        count++;
        return count<=active ? line : line.replace('Create In-World Text','disabled Create In-World Text');
    });
    assert.equal(count,5);
    assert.equal(rule.replaceAll('disabled Create In-World Text','Create In-World Text'),baselineRule);
    let output=input.replace(ruleRe,()=>rule);
    assert.equal(output.replace(ruleRe,()=>baselineRule),input);
    await compiler.decompileAllRules(output,'en-US');
    const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
    const source=await compiler.decompileAllRules(rule,'en-US',{declareUnknownNames:true});
    const compiled=await compiler.compile(directives+source,'en-US');
    // OverPy drops disabled actions on recompilation. Verify the active count,
    // but deliver the original Workshop definitions with disabled flags intact.
    const enabled=(compiled.result.match(/^\s*Create In-World Text\(/gm)||[]).length;
    assert.equal(enabled,active);
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: N with ${active} enabled and ${5-active} disabled host text actions.\nAll five definitions retained; no claim of compiled element savings.\nMalevento, same five standard lobby bots, host Team 1: Shion then Crouch.\n*/`);
    const suffix=mode+'-active-'+active+'-host-text';
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const report={mode,activeHostTextCalls:active,disabledHostTextCalls:5-active,inputSha256:sha(input),outputSha256:sha(output),
      verified:'Only disabled flags of selected actions changed. Original definitions/order, host guard, effects, Conditions/settings preserved. Decompiler accepted output; block recompilation contains expected active text count (disabled actions dropped by OverPy).',
      limitation:'No native game test. Disabled actions remain in export; engine internal storage may differ. Does not establish a global text quota. No whole-export element-saving claim.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report));
 }
 assert.equal(sha(fs.readFileSync(file('N-constant-host-text.ws.txt'),'utf8')),prior.outputSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
