// One-time source integration from the 25-rule user-validated BA manifest.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..'),src=path.join(root,'src');
const manifest=JSON.parse(fs.readFileSync(path.join(__dirname,'2026-11-16-BA-validation.json'),'utf8'));
const reportName='docs/WORKSHOP_NATIVE_UI_CORRUPTION.md';
const files=Object.keys(require('./source-layout.cjs').readLegacyTree());
const replacements=new Map();
for(const t of manifest.rankedRemaining){
 let found;
 for(const f of files){
    const text=replacements.get(f)||fs.readFileSync(require('./source-layout.cjs').sourcePath(f),'utf8').replace(/\r\n/g,'\n');
    const start=text.indexOf('rule "'+t.name+'":\n');if(start<0)continue;
    assert(!found,'Duplicate source rule '+t.name);
    const tail=text.slice(start),next=tail.slice(1).search(/^(?:rule |def |macro |#!define|#!enableOptimizations|#!disableOptimizations)/m);
    const end=next<0?text.length:start+next+1;
    const block=text.slice(start,end);
    const conditions=[...block.matchAll(/^    @Condition (.*)$/gm)].map(m=>m[1]);
    let after;
    if(t.kind==='ongoing'){
       assert.equal(conditions[0],'isGameplayActive == true',t.name);
       assert(/^eventPlayer\.(enhancementId|augmentId) == /.test(conditions[1]),t.name);
       const two='    @Condition '+conditions[0]+'\n    @Condition '+conditions[1]+'\n';
       assert(block.includes(two));
       after=block.replace(two,'    # Native UI workaround: retain one phase/ID Condition; '+reportName+'.\n    @Condition uiPhaseAndId('+conditions[1]+')\n');
    }else{
       assert.equal(t.kind,'event');assert(conditions.length>0);
       assert(!/^    (?:wait\(|waitUntil\(|.*ruleCondition)/m.test(block));
       const lines=block.split('\n');
       let last=lines.reduce((n,l,i)=>/^    @/.test(l)?i:n,0);
       const header=lines.slice(0,last+1).filter(l=>!/^    @Condition /.test(l));
       const body=lines.slice(last+1);
       // Keep comments with their actions; trailing empty lines are normalized.
       while(body.length&&!body[0].trim())body.shift();
       while(body.length&&!body.at(-1).trim())body.pop();
       const guard=conditions.map(c=>'('+c+')').join(' and ');
       after=header.join('\n')+'\n\n    # Event eligibility stays synchronous; '+reportName+'.\n    if '+guard+':\n'+
          body.map(l=>l?'    '+l:l).join('\n')+'\n\n\n';
    }
    replacements.set(f,text.slice(0,start)+after+text.slice(end));
    found=f;
 }
 assert(found,'Source not found '+t.name);
}
assert.equal(manifest.rankedRemaining.filter(t=>t.kind==='ongoing').length,16);
assert.equal(manifest.rankedRemaining.filter(t=>t.kind==='event').length,9);
for(const [f,text] of replacements)fs.writeFileSync(require('./source-layout.cjs').sourcePath(f),text);
console.log(JSON.stringify({changedSourceFiles:[...replacements.keys()],rules:25,reportName},null,2));
