// AE/AF preserve original Pregame/debug; only gameplay visuals are suppressed.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const f=s=>path.join(__dirname,'2026-11-16-'+s),old=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const v=fs.readFileSync(old('V-phase-safe-full-menu.ws.txt'),'utf8');
const ac=fs.readFileSync(f('AC-no-gameplay-hud-control.ws.txt'),'utf8');
const oldReport=JSON.parse(fs.readFileSync(f('AC-AD-validation.json'),'utf8'));
assert.equal(sha(v),oldReport.inputSha256);
const regex=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const originalRules=[...v.matchAll(regex)].map(m=>m[0]);
let index=0;const restored=[];
const base=ac.replace(regex,(rule,name)=>{
 const i=index++,original=originalRules[i];
 if([38,48,304].includes(i)||original.includes('Global.isPregameSetup == True;')||name==='[debug] Resource usage and server load'){
    restored.push({index:i,name});return original;
 }return rule;
});
function predicate(line){
 const s=line.trim().replace(/;\s*\/\/.*$/,';').replace(/;$/,'');let depth=0,q=false;
 for(let i=0;i<s.length;i++){
    const c=s[i];if(q){if(c==='\\')i++;else if(c==='"')q=false;continue;}
    if(c==='"'){q=true;continue;}if(c==='('){depth++;continue;}if(c===')'){depth--;continue;}
    if(!depth){const m=s.slice(i).match(/^ (==|!=|<=|>=|<|>) /);if(m){
       const left=s.slice(0,i),right=s.slice(i+m[0].length);
       // These native functions return bool. Do not apply this simplification
       // to untyped variables/arrays/vectors/numeric or Null comparisons.
       if(m[1]==='=='&&right==='True'&&/^(Is Alive\(Event Player\)|Is Firing Secondary\(Event Player\)|Event Was Health Pack)$/.test(left))return left;
       return `Compare(${left}, ${m[1]}, ${right})`;
    }}
 }throw Error('No outer comparison: '+s);
}
let i=0;const changes=[];
const variant=base.replace(regex,(rule,name)=>{
 const index=i++,event=rule.match(/event \{\s*([^;]+);/)?.[1];
 if(!event?.startsWith('Player ')||!rule.includes('\n        Team 1;'))return rule;
 const body=rule.slice(rule.indexOf('    actions {'));
 if(/\b(?:Wait|Wait Until|Loop|Loop If|While|For Global Variable|For Player Variable|Call Subroutine|Start Rule|Rule Condition|Is True For All Conditions|Is True For Any Conditions)\b/.test(body))return rule;
 const block=rule.match(/    conditions \{([\s\S]*?)\n    \}/);if(!block)return rule;
 const lines=block[1].split('\n'),active=lines.filter(l=>/^\s*[A-Za-z_(]/.test(l)&&!/^\s*disabled\b/.test(l));
 if(!active.length)return rule;
 const leaves=active.map(predicate);let expression=leaves.at(-1);
 for(let j=leaves.length-2;j>=0;j--)expression=`And(${leaves[j]}, ${expression})`;
 const empty='    conditions {'+lines.filter(l=>!active.includes(l)).join('\n')+'\n    }';
 const start='        If('+expression+');\n',end='        End; // synchronous event guard\n';
 let after=rule.replace(block[0],empty).replace('    actions {\n','    actions {\n'+start);
 assert(after.endsWith('    }\n}'));after=after.slice(0,-7)+end+'    }\n}';
 assert.equal(after.replace(empty,block[0]).replace(start,'').replace(end,''),rule);
 changes.push({index,name,event,moved:active.length,predicates:leaves,before:rule,after});
 return after;
});
assert.equal(changes.length,11);
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(base,'en-US');await compiler.decompileAllRules(variant,'en-US');
 const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_lone_else\n';
 let delta=0;
 for(const c of changes){
    const aSrc=await compiler.decompileAllRules(c.before,'en-US',{declareUnknownNames:true});
    const bSrc=await compiler.decompileAllRules(c.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSrc,'en-US');const b=await compiler.compile(directives+bSrc,'en-US');
    c.delta=b.nbElements-a.nbElements;delta+=c.delta;
 }
 const header=(s,label)=>s.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${label}: gameplay Workshop visuals disabled; Pregame and debug HUD restored.\nNative world/gameplay remains. Check first Reload in each new match.\nVisual-handle-dependent branches may differ from production.\n*/`);
 fs.writeFileSync(f('AE-gameplay-no-visuals-control.ws.txt'),header(base,'AE control'));
 const cheapest=changes.reduce((a,b)=>a.delta<=b.delta?a:b);
 assert.equal(cheapest.name,'PLAYER PICKS UP HEALTH PACK');assert.equal(cheapest.delta,1);
 let cursor=0;
 const cheapVariant=base.replace(regex,rule=>cursor++===cheapest.index?cheapest.after:rule);
 assert.equal(cheapVariant.replace(cheapest.after,cheapest.before),base);
 await compiler.decompileAllRules(cheapVariant,'en-US');
 fs.writeFileSync(f('AF-healthpack-guard-no-gameplay-visuals.ws.txt'),header(cheapVariant,'AF healthpack guard (+1 element)'));
 fs.writeFileSync(f('AG-event-guards-no-gameplay-visuals.ws.txt'),header(variant,'AG expanded event guards'));
 // Preserve the earlier broad variant filename as an unpublished local artifact;
 // new tests are explicitly AF=one guard, AG=full package.
 const report={inputSha256:sha(v),acSha256:sha(ac),restoredPregameRules:restored,
   AF:{deltaFromAE:cheapest.delta,rules:[cheapest.name]},AG:{deltaFromAE:delta,movedConditions:changes.reduce((s,c)=>s+c.moved,0)},changes:changes.map(({before,after,...c})=>c),
   verification:'Matched gameplay visual suppression. Pregame/debug blocks restored directly from V. Only native Team1 event handlers with no waits/loops/subcalls changed. Guard undo recovers exact base rule. Native bool simplifications limited to three explicitly whitelisted bool-returning expressions. Full exports parsed, paired compilation measured guard deltas.',
   limitation:'No native game test; no CPU improvement measured. All comparisons on untyped variables retain explicit operands. Visual-ID suppression can alter handle-driven branches equally in both builds.'};
 fs.writeFileSync(f('AE-AF-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(fs.readFileSync(f('AC-no-gameplay-hud-control.ws.txt'),'utf8'),ac);
 console.log(JSON.stringify({...report,restoredPregameRules:restored.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
