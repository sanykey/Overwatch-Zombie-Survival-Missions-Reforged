const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('J-host-text-only.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('J-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/gm;
const norm=s=>s.replace(/\/\*[\s\S]*?\*\//g,'').replace(/;\s*\/\/[^\n]*/g,';').trim();
function firstArgEnd(line){
    const start=line.indexOf('(')+1;let depth=0,quote='';
    for(let i=start;i<line.length;i++){
        const c=line[i];
        if(quote){if(c==='\\')i++;else if(c===quote)quote='';}
        else if(c==='"'||c==="'")quote=c;
        else if('(['.includes(c))depth++;
        else if(')]'.includes(c))depth--;
        else if(c===','&&depth===0)return {start,end:i};
    }throw Error('No first argument');
}
(async()=>{
 await compiler.readyPromise;
 for(const mode of ['K','L']){
    let count=0,removed=0;
    let output=input.replace(ruleRe,rule=>{
        if(mode==='K')return rule.replace(/^\s*Create Effect\([^\r\n]*; \/\/ (\d+) elements?\r?\n/gm,(line,cost)=>{count++;removed+=Number(cost);return '';});
        return rule.replace(/^\s*Create In-World Text\([^\r\n]*; \/\/ \d+ elements?/gm,line=>{
            const {start,end}=firstArgEnd(line);count++;
            return line.slice(0,start)+'Null'+line.slice(end).replace(/; \/\/ \d+ elements?$/,';');
        });
    });
    assert.equal(count,mode==='K'?2:5);
    const originalRules=[...input.matchAll(/^rule \("[^"\n]+"\) \{[\s\S]*?^\}/gm)];
    const newRules=[...output.matchAll(/^rule \("[^"\n]+"\) \{[\s\S]*?^\}/gm)];
    assert.equal(originalRules.length,newRules.length);
    for(let i=0;i<originalRules.length;i++)if(i!==48)assert.equal(originalRules[i][0],newRules[i][0]);
    assert.equal(input.slice(input.indexOf('settings'),input.indexOf('rule (')),output.slice(output.indexOf('settings'),output.indexOf('rule (')));
    await compiler.decompileAllRules(output,'en-US');
    // Measure the compiled delta separately; the delivered artifact preserves
    // frozen J's rule structure and is not replaced with the recompiled version.
    const decompBefore=await compiler.decompileAllRules(originalRules[48][0],'en-US',{declareUnknownNames:true});
    const decompAfter=await compiler.decompileAllRules(newRules[48][0],'en-US',{declareUnknownNames:true});
    const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
    const before=await compiler.compile(directives+decompBefore,'en-US');
    const after=await compiler.compile(directives+decompAfter,'en-US');
    // Recompiling K also optimizes away the now-empty If/Else/End (5 elements).
    // The delivered K keeps that structure, so subtract only removed actions.
    const delta=mode==='K' ? -removed : after.nbElements-before.nbElements;
    const elements=prior.elements+delta;
    const description=mode==='K'?'J without player Pregame Ring/Light Shaft effects':'J with Null visibility for five host world texts; creation retained';
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${mode}: ${description}.\nElement count: (total ${elements}); delta from J ${delta}.\nMalevento, same five standard bots, host in Team 1 selects Shion then Crouch.\n*/`);
    const suffix=mode==='K'?'K-no-pregame-effects':'L-invisible-host-text';
    fs.writeFileSync(file(suffix+'.ws.txt'),output);
    const report={mode,description,inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromJ:delta,
      verification:'Only rule index 48 changed. All other rules and settings identical. OverPy decompiler accepted variant. K delta uses removed compiled action annotations; L delta measured by compiling original/changed visual rule separately.',
      limitation:'No native game test. K retains empty effect branches. L keeps text creation but changes visibility dependencies and may change client evaluation/rendering; success would not prove rendering alone is responsible.'};
    fs.writeFileSync(file(mode+'-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report));
 }
 assert.equal(sha(fs.readFileSync(file('J-host-text-only.ws.txt'),'utf8')),prior.outputSha256);
})().catch(e=>{console.error(e);process.exitCode=1;});
