// Matched AC/AD diagnostics: no Workshop visuals, then synchronous event guards.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const root=path.resolve(__dirname,'..'),file=s=>path.join(__dirname,'2026-11-16-'+s);
const originalPath=path.join(__dirname,'2026-11-15-pregame-text-V-phase-safe-full-menu.ws.txt');
const original=fs.readFileSync(originalPath,'utf8');
const prior=JSON.parse(fs.readFileSync(path.join(__dirname,'2026-11-15-pregame-text-V-validation.json'),'utf8'));
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
assert.equal(sha(original),prior.outputSha256);
const rulesRe=/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm;
const hudChanges=[];let index=0;
const noHud=original.replace(rulesRe,(rule,name)=>{
 const i=index++;
 // Compiler texture setup uses a real dummy's Last Created Entity; preserve it.
 if(name.startsWith('OverPy '))return rule;
 let creates=0,ids=0,destroys=0,nativeEntity=false;
 const out=rule.split('\n').map(line=>{
    if(/^\s*Create Dummy Bot\(/.test(line)){nativeEntity=true;return line;}
    if(/^\s*(Create HUD Text|Create In-World Text|Create Progress Bar HUD Text|Create Progress Bar In-World Text|Create Effect|Create Beam Effect|Create Icon|Play Effect|Small Message|Big Message|Set Objective Description)\(/.test(line)){
        if(/^\s*(Create Effect|Create Beam Effect|Create Icon)\(/.test(line))nativeEntity=false;
        creates++;return line.replace(/^(\s*)/,'$1disabled ');
    }
    if(/^\s*(Destroy HUD Text|Destroy In-World Text|Destroy Effect|Destroy Icon)\(/.test(line)){destroys++;return line.replace(/^(\s*)/,'$1disabled ');}
    if(/Last Text ID|Last Created Entity/.test(line)){
        assert(/^\s*(Set|Modify) (Global|Player) Variable/.test(line)||/^\s*(?:"|\/\/)/.test(line),'Unexpected visual ID use');
        if(/^\s*(?:"|\/\/)/.test(line))return line;
        return line.replace(/Last Text ID|Last Created Entity/g,match=>{
           if(match==='Last Created Entity'&&nativeEntity)return match;
           ids++;return 'Null';
        });
    }
    return line;
 }).join('\n');
 if(out!==rule)hudChanges.push({index:i,name,creates,ids,destroys});
 return out;
});
function predicate(line){
 const t=line.trim().replace(/;\s*\/\/.*$/,';').replace(/;$/,'');let d=0,q=false;
 for(let i=0;i<t.length;i++){
    const c=t[i];if(q){if(c==='\\')i++;else if(c==='"')q=false;continue;}
    if(c==='"'){q=true;continue;}if(c==='('){d++;continue;}if(c===')'){d--;continue;}
    if(!d){const m=t.slice(i).match(/^ (==|!=|<=|>=|<|>) /);if(m)return `Compare(${t.slice(0,i)}, ${m[1]}, ${t.slice(i+m[0].length)})`;}
 }throw Error('Outer comparison not found: '+t);
}
const guards=[];index=0;
const guarded=noHud.replace(rulesRe,(rule,name)=>{
 const i=index++;
 const event=rule.match(/event \{\s*([^;]+);/)?.[1];
 if(!event?.startsWith('Player ')||!rule.includes('\n        Team 1;'))return rule;
 const actionBlock=rule.slice(rule.indexOf('    actions {'));
 if(/\b(?:Wait|Wait Until|Loop|Loop If|While|For Global Variable|For Player Variable|Call Subroutine|Start Rule|Rule Condition|Is True For All Conditions|Is True For Any Conditions)\b/.test(actionBlock))return rule;
 const block=rule.match(/    conditions \{([\s\S]*?)\n    \}/);
 if(!block)return rule;
 const lines=block[1].split('\n');
   const active=lines.filter(l=>/^\s*[A-Za-z_(]/.test(l)&&!/^\s*disabled\b/.test(l))
     .filter(l=>/^\s*(?:Global\.isGameplayActive\b|\(Event Player\)\.(?:enhancementId|augmentId)\b)/.test(l));
 if(!active.length)return rule;
 const leaves=active.map(predicate);
 let conjunction=leaves.at(-1);
 for(let j=leaves.length-2;j>=0;j--)conjunction=`And(${leaves[j]}, ${conjunction})`;
 const start='        If('+conjunction+');\n',end='        End; // diagnostic eligibility guard\n';
 const empty='    conditions {'+lines.filter(l=>!active.includes(l)).join('\n')+'\n    }';
 let after=rule.replace(block[0],empty).replace('    actions {\n','    actions {\n'+start);
 assert(after.endsWith('    }\n}'));
 after=after.slice(0,-'    }\n}'.length)+end+'    }\n}';
 // Verify removing only the wrapper and restoring Conditions recovers AC.
 assert.equal(after.replace(empty,block[0]).replace(start,'').replace(end,''),rule);
 guards.push({index:i,name,event,predicates:leaves,before:rule,after});
 return after;
});
assert(guards.length>0);
const directives='#!debugElementCount\n#!disableOptimizations\n#!suppressWarnings w_dark_color w_wait_until w_lone_else w_ow2_rule_condition_chase w_start_rule_crash w_cancel_contrary_motion w_closest_player\n';
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(noHud,'en-US');
 await compiler.decompileAllRules(guarded,'en-US');
 let delta=0;
 for(const g of guards){
    const aSource=await compiler.decompileAllRules(g.before,'en-US',{declareUnknownNames:true});
    const bSource=await compiler.decompileAllRules(g.after,'en-US',{declareUnknownNames:true});
    const a=await compiler.compile(directives+aSource,'en-US');
    const b=await compiler.compile(directives+bSource,'en-US');
    g.delta=b.nbElements-a.nbElements;delta+=g.delta;
 }
 const header=(s,label)=>s.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic ${label}: all Workshop texts/effects/icons/beams/messages disabled, including Pregame and debug HUD.\nNative models, physical projectiles and game mechanics retained; visual-ID branches may differ.\nFirst gameplay Reload in each new match only. Do not use optional abilities/items.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('AC-no-gameplay-hud-control.ws.txt'),header(noHud,'AC control'));
 fs.writeFileSync(file('AD-nohud-event-guards.ws.txt'),header(guarded,'AD event-body guards'));
 const report={baseline:originalPath,inputSha256:sha(original),hudChanges,
   guards:guards.map(({before,after,...g})=>g),totalGuardDelta:delta,
   verification:'AC/AD have identical full visual suppression. Only phase/Enhancement/Augment eligibility predicates in short native Team1 event handlers without waits/loops/subcalls are moved. Other Conditions retained. Predicates moved intact to one If at Actions entry. Undoing each guard and restoring Conditions recovers AC rule byte-for-byte. Full exports parsed; per-rule paired no-optimization compilation measured guard cost.',
   limitations:'Diagnostic builds. Visual IDs now store Null; native dummy entity IDs preserved. Handle-driven branches may differ from normal gameplay. No reduction in runtime CPU proven; more event Actions enter and evaluate a guard. Native UI fault remains a symptom, not proven server-crash mechanism. All visual definitions still stored disabled. No native game test.'};
 fs.writeFileSync(file('AC-AD-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(originalPath,'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,hudChanges:hudChanges.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
