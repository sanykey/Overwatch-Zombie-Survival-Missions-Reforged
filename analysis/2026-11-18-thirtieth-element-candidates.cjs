const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),vm=require('node:vm');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='55b44985b3597c6ec4c8f2d9d80b5087dd6cc91d';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
files.__numbersGenerator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
function replace(f,file,a,b){assert(f[file].includes(a),a);f[file]=f[file].replace(a,b);}
function group(f,id,values){const marker='];\n\nlet numberIndex = 0;';assert(f.__numbersGenerator.includes(marker));f.__numbersGenerator=f.__numbersGenerator.replace(marker,`  { // ${id}: appended to preserve existing offsets.\n    offset: "NL_${id}_OFFSET",\n    len: "NL_${id}_LEN",\n    list: [${values.join(', ')}],\n  },\n`+marker);return `numbersList.slice(NL_${id}_OFFSET, NL_${id}_LEN)`;}
const candidates={
 miniboss_indices(f){const heroes=f['game/global_start_menu.opy'].match(/botHeroList = \[([^\]]+)\]/)[1].split(', '),old=f['core/subroutines.opy'].match(/random.choice\(\[(Hero.REINHARDT, Hero.WRECKING_BALL, Hero.JUNKER_QUEEN[^\]]+)\]\)/)[1];const selected=old.split(', '),indices=selected.map(h=>heroes.indexOf(h));assert(indices.every(i=>i>=0));assert.deepEqual(indices.map(i=>heroes[i]),selected);const table=group(f,'MINIBOSS_HERO',indices);replace(f,'core/subroutines.opy','random.choice(['+old+'])',`botHeroList[random.choice(${table})]`);},
 spawn_table_metadata(f){
  const source=f['game/global_start_menu.opy'],m=source.match(/numbersList.slice\(\[([^\]]+)\]\[zombieSetting - 1\], \[([^\]]+)\]\[zombieSetting - 1\]\)/);assert(m);
  const ids=m[1].split(', ').map(n=>n==='0'?null:n);
  const marker='let numberIndex = 0;';assert(f.__numbersGenerator.includes(marker));
  const generated=`// Mode 3 is constructed in OverPy. Derive metadata from the source groups\n// so changes to a spawn table update both its offset and length automatically.\nconst spawnModeGroups = ${JSON.stringify(ids)}.map(id =>\n  id === null ? null : numbers.find(group => group.offset === id));\nif (spawnModeGroups.some(group => group === undefined)) throw new Error("Missing spawn table");\nconst spawnModeOffsets = spawnModeGroups.map(group => group === null ? 0 :\n  numbers.slice(0, numbers.indexOf(group)).reduce((sum, entry) => sum + entry.list.length, 0));\nconst spawnModeLengths = spawnModeGroups.map(group => group === null ? 0 : group.list.length);\nnumbers.push(\n  { offset: "NL_SPAWN_MODE_OFFSETS_OFFSET", len: "NL_SPAWN_MODE_OFFSETS_LEN", list: spawnModeOffsets },\n  { offset: "NL_SPAWN_MODE_LENGTHS_OFFSET", len: "NL_SPAWN_MODE_LENGTHS_LEN", list: spawnModeLengths },\n);\n\n`;
  f.__numbersGenerator=f.__numbersGenerator.replace(marker,generated+marker);
  replace(f,'game/global_start_menu.opy',m[0],'numbersList.slice(numbersList.slice(NL_SPAWN_MODE_OFFSETS_OFFSET, NL_SPAWN_MODE_OFFSETS_LEN)[zombieSetting - 1], numbersList.slice(NL_SPAWN_MODE_LENGTHS_OFFSET, NL_SPAWN_MODE_LENGTHS_LEN)[zombieSetting - 1])');
 },
};
candidates.combined=f=>{candidates.miniboss_indices(f);candidates.spawn_table_metadata(f);};
async function main(){const baseline=await compile(files),before=rules(baseline.result);assert.equal(baseline.nbElements,29908);const report={baselineRef,baseline:baseline.nbElements,results:[]};for(const [name,fn] of Object.entries(candidates)){const f={...files};fn(f);const r=await compile(f);const after=rules(r.result);assert.deepEqual(nestedPredicates(r.result),[]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};report.results.push(row);console.log(row);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirtieth-'+name+'.ws.txt'),r.result);}fs.writeFileSync(path.join(__dirname,'2026-11-18-thirtieth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');}
module.exports={files,candidates,baselineRef,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
