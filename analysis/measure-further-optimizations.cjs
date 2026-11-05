// Read-only with respect to src/. Candidate sources are compiled in memory.
// After implementation, reproduce the original probes with --baseline-ref cf699010.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const args = process.argv.slice(2);
const refIndex = args.indexOf('--baseline-ref');
const baselineRef = refIndex < 0 ? null : args.splice(refIndex, 2)[1];
if (refIndex >= 0 && !baselineRef) throw new Error('--baseline-ref requires a Git revision');
// Dated checks use the logical key main.opy and Git revisions containing that name.
// Resolve it to the current include manifest only for reads of the working tree.
const sourcePath = name => path.join(src, name === 'main.opy' ? 'includes.opy' : name);
const readSource = name => baselineRef
    ? execFileSync('git', ['show', `${baselineRef}:src/${name}`], {cwd: root})
    : fs.readFileSync(sourcePath(name));
function readTree(dir, prefix = '') {
    return Object.fromEntries(fs.readdirSync(dir, {withFileTypes: true}).flatMap(e => {
        const diskName = prefix + e.name;
        const name = diskName === 'includes.opy' ? 'main.opy' : diskName;
        return e.isDirectory() ? Object.entries(readTree(path.join(dir,e.name),name+'/')) :
            e.name.endsWith('.opy') ? [[name, readSource(name).toString('utf8').replace(/\r\n/g,'\n')]] : [];
    }));
}
const files = readTree(src);
function source(f) {
    return f['main.opy'].replace(/^#!include "([^"]+)".*$/gm, (line,n) => n.startsWith('vas/') ? line : f[n].replace(/^#!mainFile .*\n/gm,''))
        .replace(/^#!writeToOutputFile.*\n/gm,'');
}
const extdir = path.join(process.env.USERPROFILE,'.vscode/extensions');
const ext = fs.readdirSync(extdir).filter(n=>n.startsWith('zezombye.overpy-')).sort((a,b)=>b.localeCompare(a,undefined,{numeric:true}))[0];
const compiler = require(path.join(extdir,ext,'npm/overpy.js'));
async function compile(f) {
    const saved = {log:console.log,warn:console.warn,error:console.error};
    try {
        console.log = console.warn = console.error = ()=>{};
        const r = await compiler.compile(source(f),'en-US',src.replace(/\\/g,'/')+'/', 'main.opy');
        return {elements:r.nbElements,warnings:r.encounteredWarnings,result:r.result};
    } finally {Object.assign(console,saved);}
}
function replace(f,file,old,next) {
    assert(f[file].includes(old), `Missing text in ${file}: ${old.slice(0,100)}`);
    f[file] = f[file].replace(old,next);
}
function editBlock(f,file,start,fn) {
    const i=f[file].indexOf(start); assert(i>=0,start);
    const tail=f[file].slice(i), next=tail.slice(1).search(/\n(?:rule |def |macro )/);
    const end=next<0?f[file].length:i+next+2;
    f[file]=f[file].slice(0,i)+fn(f[file].slice(i,end))+f[file].slice(end);
}
function splitFields(f,field,indices) {
    const initial=Object.values(f).join('\n');
    assert(!new RegExp('\\.'+field+'\\[(?!\\d+\\])').test(initial),'Dynamic indexing needs manual review: '+field);
    for(const i of indices) {
        const name='opt_'+field+'_'+i;
        assert(!initial.includes(name),'Variable name collision: '+name);
        assert(initial.includes('.'+field+'['+i+']'),'Missing field: '+field+'['+i+']');
        for(const file of Object.keys(f)) f[file]=f[file].replaceAll('.'+field+'['+i+']','.'+name);
        f['variables.opy']+=`\nplayervar ${name}\n`;
    }
}
const variants = {
    aggressive(f) {f['main.opy'] = '#!optimizeForSizeAggressive\n'+f['main.opy'];},
    hero_index(f) {
        f['variables.opy']+='\nplayervar optHeroIndex\n';
        editBlock(f,'subroutines.opy','macro botStatManagementMacro():',b=>b.replace('    eventPlayer.biteDamage =','    eventPlayer.optHeroIndex = botHeros.index(eventPlayer.getHero())\n    eventPlayer.biteDamage =').replaceAll('[botHeros.index(eventPlayer.getHero())]','[eventPlayer.optHeroIndex]'));
    },
    constant_colors(f) {
        const all=Object.values(f).join('\n');
        const counts={};
        for(const m of all.matchAll(/rgb\(\d+, \d+, \d+(?:, \d+)?\)/g)) counts[m[0]]=(counts[m[0]]||0)+1;
        let i=0;
        for(const [expr,count] of Object.entries(counts)) if(count>=3) {
            const name='optColor'+i++;
            for(const file of Object.keys(f)) f[file]=f[file].replaceAll(expr,name);
            f['variables.opy']+=`\nglobalvar ${name} = ${expr}\n`;
        }
    },
    constant_vectors(f) {
        const counts={};
        for(const m of Object.values(f).join('\n').matchAll(/vect\(-?\d+(?:\.\d+)?, -?\d+(?:\.\d+)?, -?\d+(?:\.\d+)?\)/g)) counts[m[0]]=(counts[m[0]]||0)+1;
        let i=0;
        for(const [expr,count] of Object.entries(counts)) if(['vect(500, 500, 500)', 'vect(0, 0.75, 0)', 'vect(0, 0.5, 0)'].includes(expr)) {
            const name='optVector'+i++;
            for(const file of Object.keys(f)) f[file]=f[file].replaceAll(expr,name);
            f['variables.opy']+=`\nglobalvar ${name} = ${expr}\n`;
        }
    },
    path_slice(f) {
        replace(f,'objective_types/objective_type_survivor_rescue.opy','survivorToRescue.path.filter(lambda _, i: i <= survivorToRescue.telePos)','survivorToRescue.path.slice(0, survivorToRescue.telePos + 1)');
    },
    enhancement_fields(f) {splitFields(f,'enhancementValues',[0,1,2,3,4,5,6]);},
    powerup_fields(f) {splitFields(f,'powerUpUsePositionsAndInfo',[50,101,31,40,10,80,100,51,30,81]);},
    trade_index(f) {splitFields(f,'powerUpTradeValues',[1]);},
    menu_state_fields(f) {
        splitFields(f,'playerMenuStatus',[0,1]);
        replace(f,'player_start_menu.opy','        eventPlayer.playerMenuStatus = [0, 0, 0, 0]', '        eventPlayer.playerMenuStatus = [0, 0, 0, 0]\n        eventPlayer.opt_playerMenuStatus_0 = 0\n        eventPlayer.opt_playerMenuStatus_1 = 0');
    },
    shared_smolder_actions(f) {
        const s=f['zombie_types.opy'];
        const start=s.indexOf('    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT');
        const end=s.indexOf('    wait(5)',start);
        const body=s.slice(start,end);
        assert.equal(s.split(body).length-1,2);
        f['zombie_types.opy']=s.replace('subroutine abilityThrowdown','subroutine optSmolderBoost\nsubroutine abilityThrowdown').replaceAll(body,'    optSmolderBoost()\n')+'\ndef optSmolderBoost():\n'+body+'\n';
    },
    redundant_wallphase(f) {
        editBlock(f,'subroutines.opy','def botRespawnInitialization():',b=>{
            const line='    eventPlayer.canWallPhase = true\n';
            assert.equal(b.split(line).length-1,2);
            return b.replace(line,'');
        });
    },
    shared_gas_cloud(f) {
        const s=f['zombie_types.opy'];
        const start=s.indexOf('            eventPlayer.abilityArray1.append(eventPlayer.chase1)');
        const end=s.indexOf('\n',s.indexOf('            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.chase1, 75)',start))+1;
        const body=s.slice(start,end); assert.equal(s.split(body).length-1,2);
        f['zombie_types.opy']=s.replace('subroutine abilityThrowdown','subroutine optGasCloud\nsubroutine abilityThrowdown').replaceAll(body,'            optGasCloud()\n')+'\ndef optGasCloud():\n'+body.replace(/^        /gm,'')+'\n';
    },
    barricade_filters(f) {
        editBlock(f,'enhancements.opy','rule "LASER BARRICADE BLOCKS ZOMBIES":',b=>{
            const re=/^    eventPlayer\.potentialTargets = (.+)\.filter\(lambda (\w+): (.+)\)$/gm;
            const rows=[...b.matchAll(re)]; assert.equal(rows.length,4);
            const expr=rows.map(m=>m[3].replace(new RegExp('(?<![.\\w])'+m[2]+'\\b','g'),'target')).map(p=>'('+p+')').join(' and ');
            let first=true;
            return b.replace(re,()=> {if(!first)return ''; first=false; return '    eventPlayer.potentialTargets = getLivingPlayers(Team.2).filter(lambda target: '+expr+')';});
        });
    },
};
async function main() {
    await compiler.readyPromise;
    assert(!files['main.opy'].includes('#!optimizeForSizeAggressive'), 'These probes need the pre-implementation source: use --baseline-ref cf699010');
    // The embedded JavaScript include resolves from disk; it must match the historical baseline.
    for(const name of ['vas/create numbers.js','vas/compressed numbers.opy']) {
        assert.equal(fs.readFileSync(sourcePath(name),'utf8').replace(/\r\n/g,'\n'),readSource(name).toString('utf8').replace(/\r\n/g,'\n'),'Historical include differs from disk: '+name);
    }
    const baseline=await compile(files);
    // Generated .ws.txt files are ignored by Git; reconstruct historical output from source.
    const originalOutput=baselineRef ? Buffer.from(baseline.result) : readSource('main.ws.txt');
    assert.equal(baseline.elements,Number(originalOutput.toString('utf8').match(/total (\d+)/)[1]),'Compiled baseline differs from main.ws.txt');
    const generator=readSource('vas/create numbers.js');
    const report={compiler:ext,baselineRef,baseline:baseline.elements,method:'Separate candidates compiled against selected baseline. No in-game validation. src/ unchanged. Source hashes normalize CRLF to LF.',warningsSuppressedByMainSource:true,sourceSha256:Object.fromEntries([...Object.entries(files),['vas/create numbers.js',generator],[baselineRef ? 'reconstructed-baseline.ws.txt' : 'main.ws.txt',originalOutput]].map(([n,s])=>[n,crypto.createHash('sha256').update(s).digest('hex')])),results:[]};
    console.log(JSON.stringify({baseline:baseline.elements}));
    const wanted=args;
    for(const [name,transform] of Object.entries(variants)) {
        if(wanted.length && !wanted.includes(name)) continue;
        const f={...files};
        try {transform(f); const r=await compile(f); const row={name,elements:r.elements,saved:baseline.elements-r.elements,warnings:r.warnings.length,changedFiles:Object.keys(f).filter(n=>f[n]!==files[n])};report.results.push(row);console.log(JSON.stringify(row));}
        catch(e){const row={name,error:e.message}; report.results.push(row);console.log(JSON.stringify(row));}
    }
    if(!wanted.length) {
        const basic=['enhancement_fields','powerup_fields','trade_index','menu_state_fields','shared_smolder_actions','shared_gas_cloud','barricade_filters','redundant_wallphase','hero_index'];
        report.combinations=[];
        for(const [name,choices] of [['basic',basic],['with_colors',[...basic,'constant_colors']],['colors_and_aggressive',[...basic,'constant_colors','aggressive']],['with_constants',[...basic,'constant_colors','constant_vectors']],['with_aggressive',[...basic,'constant_colors','constant_vectors','aggressive']]]) {
            const f={...files};
            try {
                for(const choice of choices) variants[choice](f);
                const r=await compile(f);
                const row={name,choices,elements:r.elements,saved:baseline.elements-r.elements,warnings:r.warnings.length,declaredGlobals:[...Object.values(f).join('\n').matchAll(/^globalvar /gm)].length,declaredPlayerVars:[...Object.values(f).join('\n').matchAll(/^playervar /gm)].length};
                report.combinations.push(row); console.log(JSON.stringify(row));
            } catch(e) {const row={name,error:e.message};report.combinations.push(row);console.log(JSON.stringify(row));}
        }
    }
    assert.deepEqual(readTree(src),files,'Source changed during measurement');
    if(!baselineRef) assert.deepEqual(readSource('main.ws.txt'),originalOutput,'Baseline output changed during measurement');
    assert.deepEqual(readSource('vas/create numbers.js'),generator,'Number generator changed during measurement');
    fs.writeFileSync(path.join(__dirname,'further-optimization-results.json'),JSON.stringify(report,null,2)+'\n');
}
module.exports={files,compile,variants,replace,editBlock,compiler,src};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
