const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..');process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function rules(s) {
    const counts={};
    return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
        const name=x.match(/^rule \("(.*)"\)/)[1],id=counts[name]=(counts[name]||0)+1;
        return [name+' #'+id,x.replace(/^\s*"[^\n]*"\s*$/gm,'').replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
    }));
}
(async()=>{
    await compiler.readyPromise;
    const r=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
    assert.equal(r.nbElements,30250);
    assert.deepEqual(r.encounteredWarnings,[]);
    const expected=rules(fs.readFileSync(path.join(__dirname,'2026-11-17-fourth-probe-combined_recommended.ws.txt'),'utf8'));
    const actual=rules(r.result);
    assert(Object.keys(actual).length>100);
    assert.deepEqual(actual,expected,'Compiled rules must match the audited candidate, excluding annotations');
    const baseline=fs.readFileSync(path.join(__dirname,'2026-11-17-fourth-probe-baseline.ws.txt'),'utf8');
    const before=rules(baseline);
    const changedRules=[...new Set([...Object.keys(before),...Object.keys(actual)])].filter(n=>before[n]!==actual[n]);
    const audit=JSON.parse(fs.readFileSync(path.join(__dirname,'2026-11-17-fourth-element-candidates.json'),'utf8'));
    assert.deepEqual(changedRules.sort(),audit.results.find(x=>x.name==='combined_recommended').changedRules.sort());
    const variables=s=>s.match(/^variables \{[\s\S]*?^\}/m)[0];
    assert.equal(variables(r.result),variables(baseline),'Compiled global/player declarations must remain unchanged');
    fs.writeFileSync('main.ws.txt',r.result);
    const report={compiler:ext,baseline:30287,elements:r.nbElements,saved:30287-r.nbElements,warnings:r.encounteredWarnings,compiledRulesMatchAuditedCandidate:true,variableDeclarationsUnchanged:true,changedRules,inGameValidation:false};
    fs.writeFileSync(path.join(__dirname,'2026-11-17-fourth-element-implementation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
