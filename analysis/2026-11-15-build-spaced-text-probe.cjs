// T spaces R's four active literal text creations; no scratch crosses the waits.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('R-active-4-host-text.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('R-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m;
let count=0;
const wait='        Wait(0.25, Ignore Condition); // diagnostic spacing\n';
let output=input.replace(ruleRe,rule=>rule.replace(/^        Create In-World Text\([^\r\n]*\r?\n/gm,line=>{
    count++;
    assert(line.includes('Custom String("DIAG N '));
    return (count>1?wait:'')+line;
}));
assert.equal(count,4);
assert.equal(output.split(wait).join(''),input);
(async()=>{
    await compiler.readyPromise;
    await compiler.decompileAllRules(output,'en-US');
    const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
    const sourceA=await compiler.decompileAllRules(input.match(ruleRe)[0],'en-US',{declareUnknownNames:true});
    const sourceB=await compiler.decompileAllRules(output.match(ruleRe)[0],'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+sourceA,'en-US');
    const b=await compiler.compile(directives+sourceB,'en-US');
    assert.equal(b.nbElements-a.nbElements,6);
    const suffix='T-spaced-4-host-text';
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic T: R with 0.25 s between four active text creation calls (0.75 s total).\nAdds 6 compiled elements for three Wait actions; retains fifth disabled text.\nWait at least 2 seconds after Shion appears before Crouch; also apply that timing to control R.\nMalevento, same five standard lobby bots, host Team 1.\n*/`);
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const report={inputSha256:sha(input),outputSha256:sha(output),deltaFromR:6,activeHostTextCalls:4,totalSpacingSeconds:0.75,
        verified:'Only three Wait(0.25, Ignore Condition) actions added between active constant text calls; removing them recovers R. Decompiler accepted output; paired block compilation measured +6 elements.',
        lifetimeReview:'No shared scratch or dynamic player/global expressions in these text arguments. Original host guard runs before spacing. Ignore Condition prevents releasing the hero/phase conditions from silently dropping remaining creations.',
        limitation:'Diagnostic only; waits change scheduling and can outlive pregame if tester starts gameplay too soon. No native game test. Four texts should be present before evaluating the outcome. Early startup spike not ruled out by later Server Load Peak.'};
    fs.writeFileSync(file('T-validation.json'),JSON.stringify(report,null,2)+'\n');
    assert.equal(sha(fs.readFileSync(file('R-active-4-host-text.ws.txt'),'utf8')),prior.outputSha256);
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
