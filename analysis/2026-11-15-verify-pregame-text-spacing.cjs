const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),src=path.join(root,'src');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file=s=>path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha=s=>crypto.createHash('sha256').update(s).digest('hex');
function inline(f){return fs.readFileSync(f,'utf8').replace(/\r\n/g,'\n').replace(/^#!mainFile .*\n/gm,'').replace(/^#!writeToOutputFile.*\n/gm,'').replace(/^#!include "([^"]+)".*$/gm,(_,n)=>inline(path.resolve(path.dirname(f),n)));}
function norm(s){return s.replace(/\/\*[\s\S]*?\*\//g,'').split('\n').filter(l=>!/^\s*(?:\/\/|")/.test(l)).map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(Boolean).join('\n');}
const re=/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/m;
(async()=>{
 await compiler.readyPromise;
 const result=await compiler.compile(inline(path.join(src,'includes.opy')),'en-US',src.replace(/\\/g,'/')+'/', 'includes.opy');
 assert.deepEqual(result.encounteredWarnings,[]);
 const a=fs.readFileSync(file('A-control.ws.txt'),'utf8');
 const u=fs.readFileSync(file('U-full-menu-spaced.ws.txt'),'utf8');
 const rule=result.result.match(re)[0];
 assert.equal((rule.match(/Wait\(0.25, Abort When False\);/g)||[]).length,4);
 assert.equal((rule.match(/Create In-World Text\(/g)||[]).length,5);
 // All executable content except the four new waits must match frozen A.
 const withoutWaits=result.result.replace(re,block=>block.replace(/^\s*Wait\(0.25, Abort When False\);[^\n]*\n/gm,''));
 assert.equal(norm(withoutWaits),norm(a));
 const asU=result.result.replace(re,block=>block.replaceAll('Wait(0.25, Abort When False);','Wait(0.25, Ignore Condition);'));
 assert.equal(norm(asU),norm(u));
 assert.equal(result.nbElements,30295);
 // Validate lifetimes: both predicates become false at phase cleanup; no other
 // scratch state or actions were introduced by this change.
 assert(rule.includes('Global.isPregameSetup == True;'));
 assert(rule.includes('(Event Player).isPlayerActive == True;'));
 for(const name of ['main.ws.txt','src/includes.ws.txt'])fs.writeFileSync(path.join(root,name),result.result);
 fs.writeFileSync(file('V-phase-safe-full-menu.ws.txt'),result.result);
 const report={compiler:'OverPy 9.7.21',elements:result.nbElements,deltaFromA:8,warnings:result.encounteredWarnings,
   outputSha256:sha(result.result),verified:'All executable content matches frozen A except four Wait(0.25, Abort When False) actions. Changing only their behavior back to Ignore Condition matches user-validated U. Five original player text calls and both original rule Conditions retained.',
   exports:['main.ws.txt','src/includes.ws.txt','analysis/2026-11-15-pregame-text-V-phase-safe-full-menu.ws.txt'],
   tradeoff:'Adds 8 elements and four one-time waits per player; all five menu labels appear over 1 second. No new rules, variables or repeated polling. CPU improvement not measured.',
   limitation:'Native success reported for U. V/source cancellation mode has compiled structural verification only; needs game checks for hero selection, ending pregame during spacing, late join and Reload during gameplay.'};
 fs.writeFileSync(file('V-validation.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
