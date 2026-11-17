const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root=path.resolve(__dirname,'..');
process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function rules(s) {
    const counts={};
    return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
        const name=x.match(/^rule \("(.*)"\)/)[1];
        const id=counts[name]=(counts[name]||0)+1;
        return [name+' #'+id,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
    }));
}
(async()=>{
    await compiler.readyPromise;
    const r=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
    assert.equal(r.nbElements,30350);
    assert.deepEqual(r.encounteredWarnings,[]);
    const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-probe-combined_recommended.ws.txt'),'utf8')
        .replaceAll('Subroutine optDeselectBotTarget','deselectBotTarget').replaceAll('optDeselectBotTarget','deselectBotTarget'));
    const actual=rules(r.result);
    assert(Object.keys(actual).length>100);
    assert.deepEqual(actual,expected,'Compiled rules must match the audited candidate, excluding annotations and the production subroutine name');
    const before=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-probe-baseline.ws.txt'),'utf8'));
    const changedRules=[...new Set([...Object.keys(before),...Object.keys(actual)])].filter(n=>before[n]!==actual[n]);
    fs.writeFileSync('main.ws.txt',r.result);
    const report={compiler:ext,baseline:30412,elements:r.nbElements,saved:30412-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,changedRules,inGameValidation:false};
    fs.writeFileSync(path.join(__dirname,'2026-11-17-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
