const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
const crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');
process.chdir(root);
const extdir=path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext=fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler=require(path.join(extdir,ext,'npm/overpy.js'));
function tree(dir,prefix='') {return Object.fromEntries(fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?Object.entries(tree(path.join(dir,e.name),prefix+e.name+'/')):e.name.endsWith('.opy')?[[prefix+e.name,fs.readFileSync(path.join(dir,e.name),'utf8').replace(/\r\n/g,'\n')]]:[]));}
const baselineRef='17841c26d6a9fbad591a07549fe833477f0cab5b';
const files=Object.fromEntries(Object.keys(tree('src')).map(name=>[name,
    execFileSync('git',['show',baselineRef+':src/'+name],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
function flatten(f,name='includes.opy') {
    return f[name].replace(/^#!include "([^"]+)".*$/gm,(_,n)=>flatten(f,path.posix.join(path.posix.dirname(name),n)))
        .replace(/^#!(?:mainFile|writeToOutputFile).*\n/gm,'')
        .replace(/__script__\("([^"]+)"\)/g,(_,n)=>'__script__("'+path.resolve('src',path.posix.dirname(name),n).replace(/\\/g,'/')+'")');
}
async function compile(f) {
    const saved=[console.log,console.warn,console.error];
    try {console.log=console.warn=console.error=()=>{};return await compiler.compile(flatten(f),'en-US',path.resolve('src').replace(/\\/g,'/')+'/', 'includes.opy');}
    finally {[console.log,console.warn,console.error]=saved;}
}
function replace(f,file,a,b) {assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function region(f,file,a,b,fn) {
    const i=f[file].indexOf(a),j=f[file].indexOf(b,i+a.length);assert(i>=0&&j>i,a);
    f[file]=f[file].slice(0,i)+fn(f[file].slice(i,j))+f[file].slice(j);
}
function duplicates(s) {
    const found=new Map();
    for(const block of s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule ('))) {
        const name=block.match(/^rule \("(.*)"\)/)[1];
        let run=[];
        const flush=()=>{
            for(let n=2;n<=Math.min(6,run.length);n++) for(let i=0;i+n<=run.length;i++) {
                const rows=run.slice(i,i+n),key=rows.map(r=>r.code).join('\n');
                const item=found.get(key)||{code:key,elements:rows.reduce((a,r)=>a+r.elements,0),rules:[]};
                item.rules.push(name);found.set(key,item);
            }
            run=[];
        };
        for(const line of (block.split('    actions {')[1]||'').split('\n')) {
            if(/^\s*(?:"|\/\/)/.test(line)||!line.trim()) continue;
            const m=line.match(/^\s*([A-Z][^\n]*;).*\/\/ (\d+) elements/);
            if(!m||/^(?:If|Else|End|Skip|Wait|Loop|Abort|Call Subroutine|Start Rule|For|While|Break|Continue)\b/.test(m[1])) {flush();continue;}
            run.push({code:m[1],elements:Number(m[2])});
        }
        flush();
    }
    return [...found.values()].filter(x=>x.rules.length>=2).map(x=>({...x,estimatedGrossSaving:(x.rules.length-1)*x.elements-x.rules.length-2})).sort((a,b)=>b.estimatedGrossSaving-a.estimatedGrossSaving).slice(0,20);
}
const candidates={
    shared_charged_ultimate(f) {
        let count=0;
        for(const name of Object.keys(f)) f[name]=f[name].replace(/^( +)eventPlayer\.setUltCharge\(100\)\n\1eventPlayer\.forceButtonPress\(Button\.ULTIMATE\)/gm,(_,indent)=>{count++;return indent+'useChargedUltimate()';});
        assert.equal(count,5);
        f['core/subroutines.opy']='subroutine useChargedUltimate\n'+f['core/subroutines.opy']+'\ndef useChargedUltimate():\n    @Name "useChargedUltimate"\n    eventPlayer.setUltCharge(100)\n    eventPlayer.forceButtonPress(Button.ULTIMATE)\n';
    },
    shared_long_respawn(f) {
        let count=0;
        for(const name of Object.keys(f)) f[name]=f[name].replace(/^( +)getPlayers\(Team\.2\)\.botRespawnDelay = 12\n\1botSpawnTimeList = botSpawnTimeList\.map\(lambda _: 12\)/gm,(_,indent)=>{count++;return indent+'delayZombieRespawns()';});
        assert.equal(count,2);
        f['core/subroutines.opy']='subroutine delayZombieRespawns\n'+f['core/subroutines.opy']+'\ndef delayZombieRespawns():\n    @Name "delayZombieRespawns"\n    getPlayers(Team.2).botRespawnDelay = 12\n    botSpawnTimeList = botSpawnTimeList.map(lambda _: 12)\n';
    },
    shared_boss_health(f) {
        let count=0;
        for(const name of Object.keys(f)) f[name]=f[name].replace(/^( +)eventPlayer\.botBaseHealth = 15000\n\1eventPlayer\.botBossHealth = eventPlayer\.botBaseHealth/gm,(_,indent)=>{count++;return indent+'setBossBaseHealth()';});
        assert.equal(count,2);
        f['core/subroutines.opy']='subroutine setBossBaseHealth\n'+f['core/subroutines.opy']+'\ndef setBossBaseHealth():\n    @Name "setBossBaseHealth"\n    eventPlayer.botBaseHealth = 15000\n    eventPlayer.botBossHealth = eventPlayer.botBaseHealth\n';
    },
    barrier_direct_vector_y(f) {
        const file='abilities/augment_laser_barricade.opy';
        assert.equal(f[file].split('eventPlayer.augmentBarrierPosition.getPosition().y').length-1,2);
        f[file]=f[file].replaceAll('eventPlayer.augmentBarrierPosition.getPosition().y','eventPlayer.augmentBarrierPosition.y');
    },
    barrier_dot_horizontal_projection(f) {
        const file='abilities/augment_laser_barricade.opy';
        for(const who of ['player','target']) replace(f,file,
            'vect('+who+'.getPosition().x, eventPlayer.augmentBarrierCorner1.y, '+who+'.getPosition().z) - eventPlayer.augmentBarrierCorner1',
            '('+who+'.getPosition() - eventPlayer.augmentBarrierCorner1) * vect(1, 0, 1)');
    },
    barrier_center_horizontal_distance(f) {
        const file='abilities/augment_laser_barricade.opy';
        for(const who of ['player','target']) replace(f,file,
            'distance(eventPlayer.augmentBarrierPosition, vect('+who+'.getPosition().x, eventPlayer.augmentBarrierPosition.getPosition().y, '+who+'.getPosition().z))',
            'magnitude(('+who+'.getPosition() - eventPlayer.augmentBarrierPosition) * vect(1, 0, 1))');
    },
};
function rules(s) {
    const counts={};return Object.fromEntries(s.split(/(?=^rule \()/m).filter(x=>x.startsWith('rule (')).map(x=>{
        const n=x.match(/^rule \("(.*)"\)/)[1],i=counts[n]=(counts[n]||0)+1;
        return [n+' #'+i,x.replace(/\/\/[^\n]*/g,'').replace(/\s+/g,' ').trim()];
    }));
}
async function main() {
    await compiler.readyPromise;
    const baseline=await compile(files);assert.equal(baseline.nbElements,30323);
    const baseRules=rules(baseline.result);
    const report={compiler:ext,baselineRef,baseline:baseline.nbElements,warnings:baseline.encounteredWarnings,sourceSha256:crypto.createHash('sha256').update(flatten(files)).digest('hex'),duplicates:duplicates(baseline.result),results:[]};
    // Deterministic finite coordinates, including exact wall-band threshold cases.
    let seed=123456789,geometryCases=0;
    const random=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return (seed/4294967296-0.5)*2000;};
    for(let i=0;i<10000;i++) {
        const p=[random(),random(),random()],c=[random(),random(),random()];
        if(i<8) {p[0]=c[0]+[0,1.5,3,3-1e-9,3+1e-9,-3,6,-6][i];p[2]=c[2];}
        const before=[p[0]-c[0],c[1]-c[1],p[2]-c[2]],after=p.map((v,j)=>(v-c[j])*(j===1?0:1));
        assert(before.every((v,j)=>v===after[j]));
        const len=v=>Math.sqrt(v.reduce((sum,x)=>sum+x*x,0));
        assert.equal(len(before),len(after));geometryCases++;
    }
    report.geometryModelCases=geometryCases;
    candidates.combined_recommended=f=>{
        candidates.shared_charged_ultimate(f);
        candidates.shared_long_respawn(f);
        candidates.barrier_dot_horizontal_projection(f);
        candidates.barrier_center_horizontal_distance(f);
    };
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,fn] of Object.entries(candidates)) {
        const f={...files};
        try {fn(f);const r=await compile(f),next=rules(r.result);const changedRules=[...new Set([...Object.keys(baseRules),...Object.keys(next)])].filter(n=>baseRules[n]!==next[n]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules};report.results.push(row);console.log(JSON.stringify(row));fs.writeFileSync(path.join(__dirname,'2026-11-17-third-probe-'+name+'.ws.txt'),r.result);}
        catch(e) {const row={name,error:String(e)};report.results.push(row);console.log(JSON.stringify(row));}
    }
    fs.writeFileSync(path.join(__dirname,'2026-11-17-third-element-candidates.json'),JSON.stringify(report,null,2)+'\n');
    fs.writeFileSync(path.join(__dirname,'2026-11-17-third-probe-baseline.ws.txt'),baseline.result);
}
module.exports={candidates,files};
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
