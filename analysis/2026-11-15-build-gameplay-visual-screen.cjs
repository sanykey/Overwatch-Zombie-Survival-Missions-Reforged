// AA: broad visual screening, not a gameplay-preserving optimization.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
const input=fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8');
const prior=JSON.parse(fs.readFileSync(file('V-validation.json'),'utf8'));
assert.equal(sha(input),prior.outputSha256);
const protectedIndices=new Set([38,48,304]); // Global menu visuals, player menu visuals, Augment menu.
const create=/^(\s*)(Create HUD Text|Create In-World Text|Create Progress Bar HUD Text|Create Progress Bar In-World Text|Create Effect|Create Beam Effect|Create Icon|Play Effect)\(/;
const destroy=/^(\s*)(Destroy HUD Text|Destroy In-World Text|Destroy Effect|Destroy Icon)\(/;
const reportRules=[];
let index=0;
let output=input.replace(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm,(rule,name)=>{
 const i=index++;
 if(protectedIndices.has(i)||name==='[debug] Resource usage and server load'||name.startsWith('OverPy '))return rule;
 let creations=0,cleanup=0,idReads=0,nativeEntity=false;
 const after=rule.split('\n').map(line=>{
   // Rescue objectives use Last Created Entity for their physical dummy player.
   // Preserve this ownership; it is not a disposable visual handle.
   if(/^\s*Create Dummy Bot\(/.test(line)){nativeEntity=true;return line;}
   if(create.test(line)){
      if(/^\s*(Create Effect|Create Beam Effect|Create Icon)\(/.test(line))nativeEntity=false;
      creations++;return line.replace(create,'$1disabled $2(');
   }
   if(destroy.test(line)){cleanup++;return line.replace(destroy,'$1disabled $2(');}
   // Keep arrays aligned and scalar slots initialized, without capturing an ID
   // from a previous, unrelated create. Destruction is disabled above as well.
   if(/^\s*(Set (?:Global|Player) Variable(?: At Index)?|Modify (?:Global|Player) Variable)\(/.test(line)){
      return line.replace(/Last Created Entity|Last Text ID/g,match=>{
          if(match==='Last Created Entity'&&nativeEntity)return match;
          idReads++;return 'Null';
      });
   }
   assert(!/Last Created Entity|Last Text ID/.test(line)||/^\s*(?:"|\/\/)/.test(line),'Unreviewed ID use: '+name+' '+line);
   return line;
 }).join('\n');
 if(after!==rule)reportRules.push({index:i,name,creations,cleanup,idReads});
 return after;
});
assert(reportRules.reduce((s,r)=>s+r.creations,0)>100);
const aRules=[...input.matchAll(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm)];
const bRules=[...output.matchAll(/^rule \("([^"\n]+)"\) \{[\s\S]*?^\}/gm)];
assert.equal(aRules.length,bRules.length);
for(let i=0;i<aRules.length;i++){
 const cond=s=>s.match(/conditions \{[\s\S]*?\n    \}/)?.[0]||'';
 assert.equal(cond(aRules[i][0]),cond(bRules[i][0]));
 if(protectedIndices.has(i)||aRules[i][1]==='[debug] Resource usage and server load')assert.equal(aRules[i][0],bRules[i][0]);
}
assert.equal(input.slice(0,input.indexOf('rule (')),output.slice(0,output.indexOf('rule (')));
(async()=>{
 await compiler.readyPromise;
 await compiler.decompileAllRules(output,'en-US');
 output=output.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic AA: broad gameplay visual suppression; NOT a production build.\nPregame visuals and debug HUD preserved. Visual creations/playback and per-ID cleanup disabled elsewhere.\nVisual Last ID reads replaced by Null to avoid stale IDs; may alter handle-driven behavior.\nNo element-saving claim. Test first gameplay Reload only; do not deploy turrets/barriers or use powerups.\n*/`).replace(/^\/\/\d+ elements\r?\n/gm,'');
 fs.writeFileSync(file('AA-gameplay-visual-screen.ws.txt'),output);
 const totals=reportRules.reduce((s,r)=>({creations:s.creations+r.creations,cleanup:s.cleanup+r.cleanup,idReads:s.idReads+r.idReads}),{creations:0,cleanup:0,idReads:0});
 const report={inputSha256:sha(input),outputSha256:sha(output),totals,changedRules:reportRules,
   verification:'Settings/declarations, rule count, all Conditions and protected Pregame/debug blocks unchanged. Full decompiler accepted output. Visual creations/Play Effect and per-ID cleanup disabled in other rules, matching Last ID saves now store Null.',
   limitation:'Broad diagnostic screen only. ID-dependent branches may behave differently, so improvement cannot be attributed solely to rendering/CPU/object count. Native hero visuals, physical projectiles, barriers/other nonvisual entities and objective description remain. Do not deploy optional abilities/items. No native test or compiled savings claimed.'};
 fs.writeFileSync(file('AA-validation.json'),JSON.stringify(report,null,2)+'\n');
 assert.equal(sha(fs.readFileSync(file('V-phase-safe-full-menu.ws.txt'),'utf8')),prior.outputSha256);
 console.log(JSON.stringify({...report,changedRules:reportRules.length},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
