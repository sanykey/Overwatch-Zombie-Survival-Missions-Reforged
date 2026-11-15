// AB groups human-team predicates, retaining all Events and Actions from V.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const dir=__dirname,old=s=>path.join(dir,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(old('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(old('V-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
function predicate(line){
 const text=line.trim().replace(/;\s*\/\/.*$/,';').replace(/;$/,'');
 let depth=0,quote='';
 for(let i=0;i<text.length;i++){
   const c=text[i];
   if(quote){if(c==='\\')i++;else if(c===quote)quote='';continue;}
   if(c==='"'){quote=c;continue;}
   if(c==='('){depth++;continue;}if(c===')'){depth--;continue;}
   if(depth===0){const match=text.slice(i).match(/^ (==|!=|<=|>=|<|>) /);if(match){return `Compare(${text.slice(0,i)}, ${match[1]}, ${text.slice(i+match[0].length)})`;}}
 }
 throw Error('No outer comparison: '+text);
}
const changes=[];let index=0;
let output=input.replace(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,(rule,name)=>{
 const i=index++;
 if(!/event \{[\s\S]*?\n        Team 1;/.test(rule)||rule.includes('Global.isPregameSetup == True;'))return rule;
 return rule.replace(/    conditions \{([\s\S]*?)\n    \}/,(block,inner)=>{
   const lines=inner.split('\n');
   const active=lines.filter(l=>/^\s*[A-Za-z_(]/.test(l)&&!/^\s*disabled\b/.test(l));
   if(active.length<2)return block;
   assert(active.every(l=>l.includes(';')));
   const leaves=active.map(predicate);
   let expression=leaves.at(-1);
   for(let j=leaves.length-2;j>=0;j--)expression=`And(${leaves[j]}, ${expression})`;
   changes.push({index:i,name,before:active.length,after:1,predicates:leaves});
   const comments=lines.filter(l=>!active.includes(l)).join('\n');
   return '    conditions {'+comments+'\n        '+expression+' == True;\n    }';
 });
});
assert(changes.length>20);
const rules=s=>[...s.matchAll(/^rule \("[^"\n]+"\) \{[\s\S]*?^\}/gm)].map(m=>m[0]);
const before=rules(input),after=rules(output);
assert.equal(before.length,after.length);
const strip=s=>s.replace(/    conditions \{[\s\S]*?\n    \}/,'<conditions>');
before.forEach((r,i)=>assert.equal(strip(r),strip(after[i])));
function ast(s){const d=new compiler.OverPyDecompiler();d.currentLanguage='en-US';return d.decompileAllRulesToAst(s)[1];}
function expr(a){
 if(!a||typeof a!=='object')return a;
 if(!a.name)return a.numValue ?? a.strValue ?? a;
 // Flatten boolean conjunctions only; every leaf retains its comparison/type.
 if(a.name==='__and__')return ['and',...a.args.flatMap(x=>{const v=expr(x);return v[0]==='and'?v.slice(1):[v];})];
 if(a.name==='__equals__'&&a.args[0]?.type==='bool'&&a.args[1]?.name==='true')return expr(a.args[0]);
 return [a.name,...(a.args||[]).map(expr)];
}
const conj=xs=>['and',...xs.flatMap(x=>{const v=expr(x);return v[0]==='and'?v.slice(1):[v];})];
(async()=>{
 await compiler.readyPromise;
 const aAst=ast(input),bAst=ast(output);
 for(let i=0;i<aAst.length;i++)assert.deepEqual(conj(aAst[i].ruleAttributes.conditions||[]),conj(bAst[i].ruleAttributes.conditions||[]),'Predicate semantics '+i);
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_ow2_rule_condition_chase w_start_rule_crash w_cancel_contrary_motion w_closest_player\n';
 const aSource=await compiler.decompileAllRules(input,'en-US');
 const bSource=await compiler.decompileAllRules(output,'en-US');
 const a=await compiler.compile(directives+aSource,'en-US');
 const b=await compiler.compile(directives+bSource,'en-US');
 const compiledA=ast(a.result),compiledB=ast(b.result);
 for(let i=0;i<aAst.length;i++){
    assert.equal((compiledA[i].ruleAttributes.conditions||[]).length,(aAst[i].ruleAttributes.conditions||[]).length);
    assert.equal((compiledB[i].ruleAttributes.conditions||[]).length,(bAst[i].ruleAttributes.conditions||[]).length);
 }
 const delta=b.nbElements-a.nbElements,elements=prior.elements+delta;
 assert(elements<32768,'Element budget');
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AB: grouped Team 1 Conditions except Pregame-only rules.\nElement count: (total ${elements}), +${delta} from V. All Events/Actions unchanged.\nFull gameplay visuals restored. Test first Reload in a new match.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(path.join(dir,'2026-11-16-AB-team1-grouped-conditions.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),elements,deltaFromV:delta,
   conditionsBefore:aAst.reduce((s,r)=>s+(r.ruleAttributes.conditions||[]).length,0),conditionsAfter:bAst.reduce((s,r)=>s+(r.ruleAttributes.conditions||[]).length,0),changes,
   verification:'All Events/Actions and settings retained. AST conjunction comparison preserved every predicate. Disabled-optimization roundtrip preserved condition counts; paired compile measured element delta.',
   limitation:'Diagnostic only. Fewer condition entries do not prove reduced CPU. Grouping may affect engine bookkeeping/scheduling. Pregame-only and non-Team1 rules not grouped. No native game test.'};
 fs.writeFileSync(path.join(dir,'2026-11-16-AB-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(old('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,changes:changes.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
