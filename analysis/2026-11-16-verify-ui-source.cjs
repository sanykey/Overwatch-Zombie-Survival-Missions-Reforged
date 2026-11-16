const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),src=path.join(root,'src');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const manifest=JSON.parse(fs.readFileSync(path.join(__dirname,'2026-11-16-BA-validation.json'),'utf8'));
const expected=fs.readFileSync(path.join(__dirname,'2026-11-16-BA-full-visuals-rollback.ws.txt'),'utf8');
assert.equal(crypto.createHash('sha256').update(expected).digest('hex'),manifest.outputSha256);
function inline(f){return fs.readFileSync(f,'utf8').replace(/\r\n/g,'\n').replace(/^#!mainFile .*\n/gm,'').replace(/^#!writeToOutputFile.*\n/gm,'').replace(/^#!include "([^"]+)".*$/gm,(_,n)=>inline(path.resolve(path.dirname(f),n)));}
const rules=s=>[...s.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(m=>({name:m[1],text:m[0],body:m[2]}));
const normalize=s=>s.replace(/\/\*[\s\S]*?\*\//g,'').split('\n').filter(l=>!/^\s*(?:\/\/|")/.test(l)).map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(Boolean).join('\n');
(async()=>{
 await compiler.readyPromise;
 const input=inline(require('./source-layout.cjs').sourcePath('includes.opy'));
 const result=await compiler.compile(input,'en-US',src.replace(/\\/g,'/')+'/', 'includes.opy');
 const a=rules(expected),b=rules(result.result);assert.equal(a.length,b.length);
 const differences=[];
 for(let i=0;i<a.length;i++)if(normalize(a[i].text)!==normalize(b[i].text))differences.push({index:i,name:a[i].name,before:normalize(a[i].text),after:normalize(b[i].text)});
 fs.writeFileSync(path.join(__dirname,'2026-11-16-ui-source-candidate.ws.txt'),result.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-16-ui-source-differences.json'),JSON.stringify(differences,null,2)+'\n');
 assert.deepEqual(result.encounteredWarnings,[]);
 const targets=new Map(manifest.rankedRemaining.map(r=>[r.index,r]));
 const stripEmptyConditions=s=>s.replace(/    conditions \{\s*\}\n?/g,'');
 const stableDate=s=>s.replace(/last updated: \d{4}-\d{2}-\d{2}/g,'last updated: <build-date>');
 for(let i=0;i<a.length;i++){
    assert.equal(a[i].name,b[i].name);
    let expectedRule=a[i].text;
    const t=targets.get(i);
    if(t?.kind==='ongoing'){
       const before=expectedRule;
       // Compiler barrier changes only a comparison on the bool And result.
       expectedRule=expectedRule.replace(/^(\s*And\(Global\.isGameplayActive, Compare\([^\n]*\)) == True;/m,'$1 == 1;');
       assert.notEqual(expectedRule,before);
    }
    if(t?.kind==='event'){
       const before=expectedRule;
       // OverPy omits a redundant final End at end of the action list. Do not
       // remove arbitrary internal End/Else/Skip instructions.
       expectedRule=expectedRule.replace(/        End;[^\n]*\n(?=    \}\n\}$)/,'');
       assert.notEqual(expectedRule,before);
    }
    assert.equal(normalize(stableDate(stripEmptyConditions(expectedRule))),normalize(stableDate(stripEmptyConditions(b[i].text))),'Rule differs beyond approved lowering: '+a[i].name);
 }
 for(const kind of ['settings','variables','subroutines']){
    const re=new RegExp('^'+kind+'\\s*\\{[\\s\\S]*?^\\}','m');
    assert.equal(expected.match(re)?.[0],result.result.match(re)?.[0],kind);
 }
 const d=new compiler.OverPyDecompiler();d.currentLanguage='en-US';const ast=d.decompileAllRulesToAst(result.result)[1];
 const oldD=new compiler.OverPyDecompiler();oldD.currentLanguage='en-US';const oldAst=oldD.decompileAllRulesToAst(expected)[1];
 const conditionsCount=xs=>xs.reduce((n,r)=>n+(r.ruleAttributes.conditions||[]).length,0);
 assert.equal(conditionsCount(ast),conditionsCount(oldAst));
 for(const [i,t] of targets){
    const conditions=ast[i].ruleAttributes.conditions||[];
    if(t.kind==='ongoing')assert(b[i].text.includes('And(Global.isGameplayActive, Compare(')&&b[i].text.includes(' == 1;'));
    else assert.equal(conditions.length,0);
 }
 assert.equal(result.nbElements,30428);
 const nameLimit=31;
 const variables=[...result.result.matchAll(/^\s+\d+: ([A-Za-z_][A-Za-z_0-9]*)$/gm)].map(m=>m[1]);
 assert(variables.every(n=>n.length<=nameLimit));
 const pregame=b.find(r=>r.name==='EFFECTS/TEXT'&&r.body.includes('Global.isPregameSetup == True;'));
 assert.equal((pregame.text.match(/Wait\(0.25, Abort When False\)/g)||[]).length,4);
 const report={compiler:'OverPy 9.7.21',elements:result.nbElements,warnings:result.encounteredWarnings,rules:ast.length,conditions:conditionsCount(ast),referenceElements:manifest.elements,
    sourceDeltaFromBA:result.nbElements-manifest.elements,sourceDeltaFromV:result.nbElements-30295,sourceDeltaFromOriginal:result.nbElements-30287,
    groupedOngoingRules:16,eventGuardRules:9,pregameSpacingWaits:4,
    verified:'Every rule compared with user-confirmed BA. Only bool And result ==True to ==1, one trailing implicit End per guarded event, omitted empty Conditions and build-date text differ. All settings/variables/subroutines identical, condition-entry counts identical, full visuals/ID handling included in comparison.',
    loweringCost:'16 numeric-one optimizer barriers add 16 elements; 9 omitted redundant End actions save 9: net +7 from raw BA.',
    exports:['main.ws.txt','src/includes.ws.txt'],sha256:crypto.createHash('sha256').update(result.result).digest('hex'),
    limitation:'BA passed native user tests. Source integration is structurally/semantically compared with BA; exact emitted bool comparison/implicit-End encoding differs as documented. Fresh source-built native import still merits confirmation; no CPU benchmark.'};
 for(const name of report.exports)fs.writeFileSync(path.join(root,name),result.result);
 fs.writeFileSync(path.join(__dirname,'2026-11-16-ui-source-validation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
