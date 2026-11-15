// N keeps M's five host creation calls, replacing their arguments with constants.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('M-no-text-reevaluation.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('M-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const ruleRe=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m;
const original=input.match(ruleRe)[0];
let count=0;
const changed=original.replace(/^        Create In-World Text\([^\r\n]*/gm,()=>{
    count++;
    return `        Create In-World Text(All Players(All Teams), Custom String("DIAG N ${count}"), Vector(0, ${count}, 0), 1, Do Not Clip, None, Color(White), Default Visibility);`;
});
assert.equal(count,5);
const strip=s=>s.replace(/^        Create In-World Text\([^\r\n]*/gm,'<text-action>');
assert.equal(strip(original),strip(changed));
let output=input.replace(ruleRe,()=>changed);
assert.equal(output.replace(ruleRe,()=>original),input);
(async()=>{
    await compiler.readyPromise;
    await compiler.decompileAllRules(output,'en-US');
    const directives='#!debugElementCount\n#!suppressWarnings w_dark_color\n';
    const beforeSource=await compiler.decompileAllRules(original,'en-US',{declareUnknownNames:true});
    const afterSource=await compiler.decompileAllRules(changed,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+beforeSource,'en-US');
    const b=await compiler.compile(directives+afterSource,'en-US');
    // Unchanged effect and host gate cost must survive recompilation identically.
    const masked=s=>s.slice(s.indexOf('rule (')).replace(/^\s*Create In-World Text\([^\r\n]*/gm,'<text-action>')
        .replace(/\/\*[\s\S]*?\*\//g,'').replace(/^\/\/\d+ elements\r?\n/gm,'');
    assert.equal(masked(a.result),masked(b.result));
    const delta=b.nbElements-a.nbElements,elements=prior.elements+delta;
    output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic N: M with five constant host world text definitions.\nElement count: (total ${elements}), delta from M ${delta}.\nTexts DIAG N 1..5 are at world origin, not over the host; absence from view is expected.\nMalevento, five standard lobby bots, host in Team 1: Shion then Crouch.\n*/`);
    fs.writeFileSync(file('N-constant-host-text.ws.txt'),output);
    const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromM:delta,
        verified:'Only five text-action argument lists replaced. Same creation count, same host guard, no reevaluation, original effects. Decompiler accepted output. Paired block compilation measured delta and verified identical non-text compiled content.',
        limitation:'No native game test. Texts located at world origin; not necessarily visible from menu. All Players is evaluated once at creation, other arguments are literals. Positive result may reflect changed expressions, placement, visibility or smaller code; not proof of a specific engine fault.'};
    fs.writeFileSync(file('N-validation.json'),JSON.stringify(report,null,2)+'\n');
    assert.equal(sha(fs.readFileSync(file('M-no-text-reevaluation.ws.txt'),'utf8')),prior.outputSha256);
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
