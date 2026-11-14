// Compile the current working tree, compare with the pre-change rule hashes, and refresh main.ws.txt.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const artifact = name => path.join(__dirname, '2026-11-14-charge-hotkey-' + name + '.json');
function rules(result) {
 return [...result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name, body,
  hash: crypto.createHash('sha256').update(body.split('\n').filter(l=>!/^\s*(?:"|\/\/)/.test(l))
   .map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(Boolean).join('\n')).digest('hex')}));
}
(async () => {
 await compiler.readyPromise;
 const compiled = await compiler.compile(fs.readFileSync(path.join(root,'src/includes.opy'),'utf8').replace(/^#!writeToOutputFile.*$/gm,''),
  'en-US', path.join(root,'src').replace(/\\/g,'/')+'/', 'includes.opy');
 assert.deepEqual(compiled.encounteredWarnings, []);
 const before = JSON.parse(fs.readFileSync(artifact('before'),'utf8'));
 const current = rules(compiled.result);
 const added = current.filter(r=>!before.rules.some(b=>b.name===r.name)).map(r=>r.name);
 const removed = before.rules.filter(r=>!current.some(b=>b.name===r.name)).map(r=>r.name);
 const changed = current.filter(r=>before.rules.some(b=>b.name===r.name) && !before.rules.some(b=>b.name===r.name && b.hash===r.hash)).map(r=>r.name);
 assert.deepEqual(added,['BOLT STRIKE AND OVERCHARGE ARM ON DOUBLE CROUCH']);
 assert.deepEqual(removed,['BOLT STRIKE ARMS CHARGE','OVERCHARGE ARMS CHARGE']);
 assert.deepEqual(changed,['EFFECTS/TEXTS','ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)']);
 const arm = current.find(r=>r.name===added[0]).body;
 assert(arm.includes('Wait Until(Not(Is Button Held(Event Player, Button(Crouch))), 0.3);'));
 assert(arm.includes('Wait Until(Is Button Held(Event Player, Button(Crouch)), 0.3);'));
 assert(arm.includes('Abort If Condition Is False;'));
 assert(!arm.includes('Button(Melee)'));
 // Model the two bounded input waits: lone press, long hold and slow second press cannot arm.
 const gesture = (release, second, eligible = true) => release <= 0.3 && second >= release && second-release <= 0.3 && eligible;
 assert(gesture(0.1,0.2));
 assert(gesture(0.29,0.58));
 assert(!gesture(Infinity,Infinity));
 assert(!gesture(0.31,0.4));
 assert(!gesture(0.1,Infinity));
 assert(!gesture(0.1,0.41));
 assert(!gesture(0.1,0.2,false));
 const report = {compiler:'OverPy 9.7.21',beforeElements:before.elements,afterElements:compiled.nbElements,
  deltaElements:compiled.nbElements-before.elements,warnings:compiled.encounteredWarnings,
  added,removed,changed,unchangedRules:current.length-added.length-changed.length,
  newVariables:0,inputModelCases:7,limitations:'Static compiled-rule comparison and bounded-wait input model; no in-game test.'};
 fs.writeFileSync(artifact('after'),JSON.stringify(report,null,2)+'\n');
 fs.writeFileSync(path.join(root,'main.ws.txt'),compiled.result);
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1});
