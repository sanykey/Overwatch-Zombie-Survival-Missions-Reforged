const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
const {args}=require('./verify-global-temporaries.cjs');
const {scenario,start}=require('./verify-augments.cjs');
// Evaluate only the pure functions emitted by the numeric decompressor. This
// tests the actual compressed string and decoder, including its rounding.
const scalar=x=>Array.isArray(x)?x[0]:x;
function decode(expr,element) {
    expr=expr.trim();
    if(/^-?\d+(?:\.\d+)?$/.test(expr)) return Number(expr);
    if(expr==='Null') return 0;
    if(expr==='Current Array Element') return element;
    if(expr.startsWith('"')) return JSON.parse(expr.replace(/[\u0000-\u001f]/g,c=>'\\u'+c.charCodeAt(0).toString(16).padStart(4,'0')));
    const name=expr.slice(0,expr.indexOf('(')),a=args(expr),v=i=>decode(a[i],element);
    switch(name) {
        case 'Custom String': {let s=v(0);for(let i=1;i<a.length;i++) s=s.replaceAll('{'+(i-1)+'}',String(v(i)));return s;}
        case 'First Of': return Array.isArray(v(0))?v(0)[0]:v(0);
        case 'Last Of': return v(0).at(-1);
        case 'String Split': return String(scalar(v(0))).split(String(scalar(v(1))));
        case 'Char In String': return String(scalar(v(0))).charAt(v(1));
        case 'Index Of String Char': return String(scalar(v(0))).indexOf(v(1));
        case 'Append To Array': return (Array.isArray(v(0))?v(0):[v(0)]).concat(v(1));
        case 'Mapped Array': return v(0).map(x=>decode(a[1],x));
        case 'Add': return v(0)+v(1);
        case 'Subtract': return v(0)-v(1);
        case 'Multiply': return v(0)*v(1);
        default: throw Error('Unsupported decoder function: '+name);
    }
}
function numbers(build) {
    const action=build.result.split('\n').find(l=>l.includes('Set Global Variable(numbersList,'));
    return decode(args(action)[1]);
}
const heroes=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbj\u00f6rn'];
const rows=[[4,100,.4,.56],[6,45,.2,.4],[4,60,.2,.456],[5,100,.15,0],[10,65,.15,.45],[2.5,70,.35,.35]];
async function main() {
    await compiler.readyPromise;
    const generator=fs.readFileSync('src/create numbers.js','utf8');
    const before={...files};
    const prefix=vm.runInNewContext(generator.replace('let numberIndex = 0;',"numbers.splice(numbers.findIndex(g=>g.offset==='NL_LONG_REACH_PROFILE_OFFSET'));\nlet numberIndex = 0;"));
    before['compressed numbers.opy']=before['compressed numbers.opy'].replace('    createNumbers()',prefix);
    const literal='    eventPlayer.augmentWeaponProfile = [\n'+rows.map((row,i)=>'        [Hero.'+['REINHARDT','BRIGITTE','DMON','GENJI','RAMATTRA','TORBJORN'][i]+', '+row.map((n,j)=>i===3&&j===3?'0.7 / 1.15 - 0.15':n).join(', ')+']').join(',\n')+'\n    ][AUGMENT_MELEE_WEAPON_HEROES.index(eventPlayer.getHero())]';
    before['augments.opy']=before['augments.opy'].replace(/^    eventPlayer\.augmentWeaponProfile = .*$/m,literal).replace('0.7 / 1.15 - 0.15 if eventPlayer.augmentWeaponProfile[0] == Hero.GENJI else eventPlayer.augmentWeaponProfile[4]','eventPlayer.augmentWeaponProfile[4]');
    const old=await compile(before),build=await compile(files);assert.deepEqual(build.warnings,[]);
    const oldNumbers=numbers(old),newNumbers=numbers(build);
    assert.deepEqual(newNumbers.slice(0,oldNumbers.length),oldNumbers,'Existing numeric data must not change');
    newNumbers.slice(oldNumbers.length).forEach((n,i)=>assert(Math.abs(n-rows.flat()[i])<1e-12,'Compressed profile value '+i));
    assert.equal(newNumbers.length-oldNumbers.length,24);
    const oldRules=rules(old.result),newRules=rules(build.result);
    const changed=new Set(['Initialize global variables','LONG REACH MELEE WEAPONS']);
    assert.deepEqual(newRules.filter(r=>!changed.has(r.name)),oldRules.filter(r=>!changed.has(r.name)));
    const oldMap=new Map(oldRules.map(r=>[r.name,r])),newMap=new Map(newRules.map(r=>[r.name,r]));
    const make=(hero,i)=>{const s=scenario(4,{hero,firing:true,ultimate:i===3,weapon:i===5?2:1,maxArmor:i===4?375:100,targets:[{id:'hit',position:[0,0,rows[i][0]+1],health:10000,alive:true,visible:true}]});s.player.initialMaxHealth=525;s.globals.augmentMeleeWeaponHeroListConst=heroes;s.globals.augmentMeleeBtnHeroListConst=[heroes[0],heroes[1],heroes[5]];return s;};
    let checks=0;
    for(let i=0;i<heroes.length;i++) for(const mode of ['hold','spam','release','hero-switch']) {
        const a=make(heroes[i],i),b=make(heroes[i],i);b.globals.numbersList=newNumbers;
        const ta=start(oldMap.get('LONG REACH MELEE WEAPONS'),a,oldMap),tb=start(newMap.get('LONG REACH MELEE WEAPONS'),b,newMap);
        // Advance through exact wait deadlines as well as input edges: a frame-only
        // test could miss a sub-millisecond regression in Genji's recovery.
        for(let tick=1;tick<=200;tick++) {
            const until=100+tick*.02;
            while(Math.min(ta.deadline(),tb.deadline())<=until) {
                const t=Math.min(ta.deadline(),tb.deadline());
                a.time=b.time=t;ta.resume();tb.resume();
                assert.equal(ta.deadline(),tb.deadline(),'Wait timing changed for '+heroes[i]);
            }
            for(const [s,t] of [[a,ta],[b,tb]]) {s.time=until;if(mode==='spam') s.buttons=tick%2?new Set():new Set(['Primary Fire']);if(mode==='release') {s.buttons.clear();s.firing=false;}if(mode==='hero-switch') s.hero='Ana';t.resume();}
        }
        assert.deepEqual(b.damage,a.damage);assert.deepEqual(b.effects,a.effects);checks++;
    }
    const report={before:old.elements,after:build.elements,saving:old.elements-build.elements,oldNumericValues:oldNumbers.length,addedNumericValues:24,parityCases:checks,warnings:build.warnings,genjiRecovery:0.7/1.15-.15,limitation:'Compiled decoder and actions checked; no in-game server performance measurement.'};
    assert.equal(report.saving,47);
    fs.writeFileSync('analysis/2026-11-13-long-reach-numbers-validation.json',JSON.stringify(report,null,2)+'\n');
    if(process.argv.includes('--export')) {const path=require('node:path'),root=path.resolve(__dirname,'..');const out=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');assert.deepEqual(out.encounteredWarnings,[]);assert.equal(out.nbElements,build.elements);assert.deepEqual(rules(out.result),newRules);fs.writeFileSync(path.join(root,'main.ws.txt'),out.result);}
    console.log(JSON.stringify(report,null,2));
}
if(require.main===module) main().catch(e=>{console.error(e);process.exitCode=1;});
module.exports={numbers};
