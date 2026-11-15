// M differs from frozen J only in the five text Reevaluation options.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('J-host-text-only.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('J-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
let count=0;
let output=input.replace(/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/gm,rule=>rule.replace(/^        Create In-World Text\([^\r\n]*/gm,line=>{
    assert.equal((line.match(/, Visible To Position and String, /g)||[]).length,1);
    count++;
    return line.replace(', Visible To Position and String, ', ', None, ');
}));
assert.equal(count,5);
assert.equal(output.replace(/^        Create In-World Text\([^\r\n]*/gm,line=>line.replace(', None, ', ', Visible To Position and String, ')),input);
(async()=>{
    await compiler.readyPromise;
    await compiler.decompileAllRules(output,'en-US');
    const getRule=s=>s.match(/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m)[0];
    const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
    const beforeSource=await compiler.decompileAllRules(getRule(input),'en-US',{declareUnknownNames:true});
    const afterSource=await compiler.decompileAllRules(getRule(output),'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+beforeSource,'en-US');
    const b=await compiler.compile(directives+afterSource,'en-US');
    assert.equal(a.nbElements,b.nbElements);
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic M: J with None Reevaluation on five host world texts.\nElement count: (total ${prior.elements}), same as J.\nMalevento, five standard lobby bots, host in Team 1: Shion then Crouch.\nText visibility, content and positions are captured at creation; stale labels are expected.\n*/`);
    fs.writeFileSync(file('M-no-text-reevaluation.ws.txt'),output);
    const report={inputSha256:sha(input),outputSha256:sha(output),elements:prior.elements,deltaFromJ:0,
        verified:'Exactly five Reevaluation arguments changed from Visible To Position and String to None. All other executable content identical. Decompiler accepted output; paired block compilation confirms equal element count.',
        limitation:'Diagnostic only. Text visibility, positions and strings may become stale. Hidden-at-creation texts can stay hidden. Effects remain original. No native game test. Retains creation-time expressions and allocated text objects; does not isolate every internal engine operation.'};
    fs.writeFileSync(file('M-validation.json'),JSON.stringify(report,null,2)+'\n');
    assert.equal(sha(fs.readFileSync(file('J-host-text-only.ws.txt'),'utf8')),prior.outputSha256);
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
