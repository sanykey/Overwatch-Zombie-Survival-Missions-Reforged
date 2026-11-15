// AH builds on AG: group only adjacent phase/ID pairs in ongoing Team1 rules.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-16-'+s),sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('AG-event-guards-no-gameplay-visuals.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('AE-AF-validation.json'),'utf8'));
// Phase is unset(0/Null), false or true throughout this frozen build. This
// contract permits a direct boolean operand; do not generalize it to ID slots.
const phaseWrites=[...input.matchAll(/^\s*(?:Set Global Variable\(isGameplayActive, ([^;]+)\);|(?:Modify Global Variable|Chase Global Variable[^\n]*)\(isGameplayActive,[^\n]*)/gm)];
assert(phaseWrites.length>=2);
for(const m of phaseWrites)assert(['True','False','Null'].includes(m[1]),m[0]);
const changes=[];let index=0;
const ruleRe=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
let output=input.replace(ruleRe,(rule,name)=>{
 const i=index++;
 if(!rule.includes('Ongoing - Each Player;')||!rule.includes('\n        Team 1;'))return rule;
 const block=rule.match(/    conditions \{([\s\S]*?)\n    \}/);if(!block)return rule;
 const lines=block[1].split('\n'),active=lines.map((line,j)=>({line,j})).filter(({line})=>/^\s*[A-Za-z_(]/.test(line)&&!/^\s*disabled\b/.test(line));
 for(let k=0;k<active.length-1;k++){
    const phase=active[k],id=active[k+1];
    if(!/^\s*Global\.isGameplayActive == True;/.test(phase.line))continue;
    const m=id.line.match(/^\s*(\(Event Player\)\.(enhancementId|augmentId)) == ([^;]+);/);if(!m)continue;
    const combined=`        And(Global.isGameplayActive, Compare(${m[1]}, ==, ${m[3]})) == True;`;
    const newLines=lines.map((l,j)=>j===phase.j?combined:j===id.j?'':l);
    const newBlock='    conditions {'+newLines.join('\n')+'\n    }';
    const after=rule.replace(block[0],newBlock);
    assert.equal(rule.slice(rule.indexOf('    actions {')),after.slice(after.indexOf('    actions {')));
    changes.push({index:i,name,id:m[1],value:m[3],before:rule,after});return after;
 }return rule;
});
assert(changes.length>5);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_ow2_rule_condition_chase w_start_rule_crash w_cancel_contrary_motion w_lone_else\n';
 let delta=0;
 for(const r of changes){
    const aSource=await compiler.decompileAllRules(r.before,'en-US',{declareUnknownNames:true});
    const bSource=await compiler.decompileAllRules(r.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSource,'en-US');const b=await compiler.compile(directives+bSource,'en-US');
    r.delta=b.nbElements-a.nbElements;delta+=r.delta;
 }
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AH: AG + adjacent phase/ID pairs grouped in ongoing Team1 Conditions.\nAdds ${delta} compiled elements from AG; ${prior.AG.deltaFromAE+delta} from no-visuals AE.\nGameplay Workshop visuals remain disabled; original Pregame/debug retained.\nNo Actions/Events/waits/loops changed from AG.\n*/`);
 fs.writeFileSync(file('AH-compact-phase-id-no-gameplay-visuals.ws.txt'),output);
 const report={inputSha256:sha(input),outputSha256:sha(output),deltaFromAG:delta,deltaFromAE:prior.AG.deltaFromAE+delta,
   groupedPairs:changes.map(({before,after,...r})=>r),
   verification:'Grouped only two adjacent predicates; no reordering of other Conditions, no Actions/Events changes. Phase writes audited to True/False/Null, initial zero allowed. ID equality retains explicit numeric/Null operand. Full decompilation and per-rule paired compilation passed.',
   limitation:'No native game test or CPU improvement claim. Phase bool shorthand relies on current assignment contract. Rule triggering, Abort When False and ruleCondition remain governed by the same full conjunction; grouping can still affect engine bookkeeping.'};
 fs.writeFileSync(file('AH-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('AG-event-guards-no-gameplay-visuals.ws.txt'),'utf8')),sha(input));
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
