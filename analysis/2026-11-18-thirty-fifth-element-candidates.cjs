const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='42c78b9fc6f14e4c93442cb2f11a529df4612ae1';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
files.__numbersGenerator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
function region(f,file,start,end,fn){const i=f[file].indexOf(start),j=f[file].indexOf(end,i+start.length);assert(i>=0&&j>i);f[file]=f[file].slice(0,i)+fn(f[file].slice(i,j))+f[file].slice(j);}
function splitArgs(s){const out=[];let depth=0,quote=null,escape=false,start=0;for(let i=0;i<s.length;i++){const c=s[i];if(quote){if(escape)escape=false;else if(c==='\\')escape=true;else if(c===quote)quote=null;continue;}if(c==='"'||c==="'")quote=c;else if('([{'.includes(c))depth++;else if(')]}'.includes(c))depth--;else if(c===','&&!depth){out.push(s.slice(start,i).trim());start=i+1;}}out.push(s.slice(start).trim());assert.equal(depth,0);assert(!quote);return out;}
function menuHudCalls(source){const out=[];let from=0;while(true){const start=source.indexOf('    hudText(\n',from);if(start<0)break;let depth=1,quote=null,escape=false,i=start+'    hudText('.length;const argStart=i;for(;i<source.length;i++){const c=source[i];if(quote){if(escape)escape=false;else if(c==='\\')escape=true;else if(c===quote)quote=null;continue;}if(c==='"'||c==="'")quote=c;else if(c==='(')depth++;else if(c===')'&&!--depth)break;}assert.equal(depth,0);out.push({start,end:i+1,args:splitArgs(source.slice(argStart,i))});from=i+1;}return out;}
const c1='eventPlayer.augmentBarrierCorner1',c2='eventPlayer.augmentBarrierCorner2',h='LASER_BARRICADE_AUGMENT_HEIGHT * Vector.UP';
const candidates={
 menu_hud_loop(f){const file='game/global_start_menu.opy',calls=menuHudCalls(f[file]);assert.equal(calls.length,4);assert(calls.every(c=>c.args.length===10));for(const i of [0,4,9])assert(calls.every(c=>c.args[i]===calls[0].args[i]));
  const old=f[file].slice(calls[0].start,calls.at(-1).end),assignments=old.split('\n').filter(s=>/^    startMenu\w+ColorList = /.test(s));assert.equal(assignments.length,3);
  const args=calls[0].args.map((value,i)=>[1,2,3,6,7,8].includes(i)?'[\n'+calls.map(c=>'            '+c.args[i].replace(/\n/g,'\n            ')+',').join('\n')+'\n        ][evalOnce(menuHudCategoryIndex)]':i===5?'evalOnce(menuHudCategoryIndex)':value);
  const replacement=assignments.join('\n')+'\n    # Four viewer-driven cards; freeze only category identity, keep all content live.\n    #!define menuHudCategoryIndex tmp0\n    for menuHudCategoryIndex in range(4):\n        hudText(\n'+args.map(a=>'            '+a+',').join('\n')+'\n        )';
  f[file]=f[file].slice(0,calls[0].start)+replacement+f[file].slice(calls.at(-1).end);
 },
 spawn_metadata_direct_index(f){const file='game/global_start_menu.opy';for(const kind of ['OFFSETS','LENGTHS']){const old=`numbersList.slice(NL_SPAWN_MODE_${kind}_OFFSET, NL_SPAWN_MODE_${kind}_LEN)[zombieSetting - 1]`;assert(f[file].includes(old));f[file]=f[file].replace(old,`numbersList[(NL_SPAWN_MODE_${kind}_OFFSET - 1) + zombieSetting]`);}},
 objective_settings_array(f){region(f,'core/global_startup.opy','    #Set objective type votes empty\n','    #Mixed Objectives pool\n',s=>{const rows=[...s.matchAll(/objectiveTypeVoteList\[([^\]]+)\] = (.*)/g)];assert.equal(rows.length,7);const ids=['ObjectiveType.NO_PREFERENCE','ObjectiveType.SHOWDOWN','ObjectiveType.BOSSES',null,null,'ObjectiveType.KILL_ZONE','ObjectiveType.ZOMBIE_EGG','ObjectiveType.SATELLITE_UPLINK',null,'ObjectiveType.MIXED_OBJECTIVES'];const values=ids.map((id,i)=>id?rows.find(r=>r[1]===id)[2]:`objectiveTypeVoteList[${i}]`);return '    # Preserve gap entries 3, 4 and 8 when setup repeats; all enabled entries keep their settings.\n    objectiveTypeVoteList = [\n'+values.map(v=>'        '+v+',').join('\n')+'\n    ]\n';});},
 barrier_three_edges(f){region(f,'abilities/augment_laser_barricade.opy','    #Barricade side 1\n','    #Barricade health\n',()=>`    # Preserve side 1, side 2, top creation order; capture only the row index.
    #!define barrierEdgeVisualIndex tmp0
    for barrierEdgeVisualIndex in range(3):
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, [${c1} + ${h}, ${c2}, ${c2} + ${h}][evalOnce(barrierEdgeVisualIndex)], [${c1}, ${c2} + ${h}, ${c1} + ${h}][evalOnce(barrierEdgeVisualIndex)], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
`);},
 barrier_three_edges_conditional(f){region(f,'abilities/augment_laser_barricade.opy','    #Barricade side 1\n','    #Barricade health\n',()=>`    # Capture the edge identity; keep geometry and visibility live.
    #!define barrierEdgeVisualIndex tmp0
    for barrierEdgeVisualIndex in range(3):
        createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, (${c1} if evalOnce(barrierEdgeVisualIndex) == 0 else ${c2}) + (LASER_BARRICADE_AUGMENT_HEIGHT * evalOnce(barrierEdgeVisualIndex != 1)) * Vector.UP, (${c2} if evalOnce(barrierEdgeVisualIndex) == 1 else ${c1}) + (LASER_BARRICADE_AUGMENT_HEIGHT * evalOnce(barrierEdgeVisualIndex != 0)) * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
`);},
 barrier_four_edges(f){region(f,'abilities/augment_laser_barricade.opy','    #Barricade bottom\n','    #Barricade health\n',()=>`    # Preserve bottom, side 1, side 2, top creation order and bottom visibility.
    #!define barrierEdgeVisualIndex tmp0
    for barrierEdgeVisualIndex in range(4):
        createBeam(getAllPlayers().filter(lambda _: (eventPlayer.augmentBarrierPosition != null if evalOnce(barrierEdgeVisualIndex) == 0 else eventPlayer.augmentBarrierHealth > 0)), Beam.BAD, [${c1}, ${c1} + ${h}, ${c2}, ${c2} + ${h}][evalOnce(barrierEdgeVisualIndex)], [${c2}, ${c1}, ${c2} + ${h}, ${c1} + ${h}][evalOnce(barrierEdgeVisualIndex)], Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
`);},
};
candidates.table_combined=f=>{candidates.spawn_metadata_direct_index(f);candidates.objective_settings_array(f);};
async function main(){const baseline=await compile(files);assert.equal(baseline.nbElements,29766);const before=rules(baseline.result),report={baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};for(const [name,fn] of Object.entries(candidates)){const f={...files};fn(f);const r=await compile(f),after=rules(r.result);assert.deepEqual(Object.keys(before),Object.keys(after));assert.deepEqual(nestedPredicates(r.result),[]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};report.results.push(row);console.log(row);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fifth-'+name+'.ws.txt'),r.result);}fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fifth-baseline.ws.txt'),baseline.result);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fifth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');}
module.exports={files,candidates,baselineRef,compile,rules,menuHudCalls,splitArgs};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
