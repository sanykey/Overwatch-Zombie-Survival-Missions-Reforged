const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='cfdf808ec3019b648c57e1ac0aaf863659228886';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
files.__numbersGenerator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
function array(f,file,name){const m=f[file].match(new RegExp('(?:globalvar )?'+name+' = \\[([^\\]]+)\\]'));assert(m,name);return {text:m[0],values:m[1].split(', ')};}
function paletteModel(f){const file='core/immutable_variables.opy',base=array(f,file,'augmentColorListConst').values;return {base,palette:[...base,'Color.PURPLE','Color.GRAY','Color.ROSE','null']};}
function colorTables(f){return [['core/immutable_variables.opy','powerUpColorListConst','POWERUP_COLORS'],['game/global_start_menu.opy','startMenuZombieColorList','ZOMBIE_MENU_COLORS'],['game/global_start_menu.opy','startMenuObjectiveColorList','OBJECTIVE_MENU_COLORS'],['game/global_start_menu.opy','startMenuEnhancementColorList','ENHANCEMENT_MENU_COLORS']].map(([file,name,id])=>({file,name,id,...array(f,file,name)}));}
const candidates={
 shared_color_indices(f){
  const {base,palette}=paletteModel(f),tables=colorTables(f),file='core/immutable_variables.opy';
  const oldPalette=array(f,file,'augmentColorListConst').text,newPalette='globalvar augmentColorListConst = ['+palette.join(', ')+']';
  f[file]=f[file].replace(oldPalette,newPalette);
  const rows=[];
  for(const table of tables){const indices=table.values.map(color=>{const i=palette.indexOf(color);assert(i>=0,color);return i;});assert.deepEqual(indices.map(i=>palette[i]),table.values);
   rows.push(`  { // ${table.name}: indices into the shared immutable palette.\n    offset: "NL_${table.id}_OFFSET", len: "NL_${table.id}_LEN",\n    list: [${indices.join(', ')}],\n  },`);
   const declaration=table.text.startsWith('globalvar ')?'globalvar ':'';
   const next=declaration+table.name+` = numbersList.slice(NL_${table.id}_OFFSET, NL_${table.id}_LEN).map(lambda index: augmentColorListConst[index])`;
   assert(f[table.file].includes(table.text));f[table.file]=f[table.file].replace(table.text,next);
   if(declaration){f[file]=f[file].replace(next+'\n','');f[file]=f[file].replace(newPalette,newPalette+'\n\n# Initialize after the shared palette; all original item colors and order are retained.\n'+next);}
  }
  f[file]=f[file].replace('# Immutable palette shared by the pregame menu and gameplay HUD; indexed by Augment.','# Shared immutable palette: Augment colors keep indices 0..10 unchanged.\n# Tail 11..14: Purple, Gray, Rose, Null; used to reconstruct the other palettes.');
  f[file]=f[file].replace('# Immutable palette indexed by item ID minus one; shared by ground items and their HUD.\n\n','');
  const marker='let numberIndex = 0;';assert(f.__numbersGenerator.includes(marker));f.__numbersGenerator=f.__numbersGenerator.replace(marker,'// Append palette indices after existing groups to preserve all previous offsets.\nnumbers.push(\n'+rows.join('\n')+'\n);\n\n'+marker);
  assert.deepEqual(palette.slice(0,base.length),base);
 },
};
candidates.shared_color_indices_with_challenge=(f,fields=[0,1,2])=>{
 candidates.shared_color_indices(f);const {palette}=paletteModel(files),file='game/global_start_menu.opy';
 const matches=[...files[file].matchAll(/\[(Color\.AQUA, (?:Color\.\w+|null)(?:, (?:Color\.\w+|null))+)\]\[localPlayer.pregameChallengeVote\]/g)];assert.equal(matches.length,3);
 const rows=matches.flatMap((m,i)=>{if(!fields.includes(i))return [];const values=m[1].split(', '),indices=values.map(v=>palette.indexOf(v));assert(indices.every(n=>n>=0));assert.deepEqual(indices.map(n=>palette[n]),values);const id='CHALLENGE_COLORS_'+i;assert(f[file].includes(m[0]));f[file]=f[file].replace(m[0],`numbersList.slice(NL_${id}_OFFSET, NL_${id}_LEN).map(lambda index: augmentColorListConst[index])[localPlayer.pregameChallengeVote]`);return [`  { // Challenge HUD color field ${i}: shared palette indices.\n    offset: "NL_${id}_OFFSET", len: "NL_${id}_LEN",\n    list: [${indices.join(', ')}],\n  },`];});
 const marker='let numberIndex = 0;';f.__numbersGenerator=f.__numbersGenerator.replace(marker,'numbers.push(\n'+rows.join('\n')+'\n);\n\n'+marker);
};
for(const field of [0,1,2])candidates['shared_color_indices_challenge_field_'+field]=f=>candidates.shared_color_indices_with_challenge(f,[field]);
const recommended=['shared_color_indices_challenge_field_0'];
async function main(){const baseline=await compile(files);assert.equal(baseline.nbElements,29802);const before=rules(baseline.result),report={baselineRef,baseline:baseline.nbElements,results:[],inGameValidation:false,serverLoadMeasured:false};for(const [name,fn] of Object.entries(candidates)){const f={...files};fn(f);const r=await compile(f),after=rules(r.result);assert.deepEqual(Object.keys(before),Object.keys(after));assert.deepEqual(nestedPredicates(r.result),[]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};report.results.push(row);console.log(row);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fourth-'+name+'.ws.txt'),r.result);}fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fourth-baseline.ws.txt'),baseline.result);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-fourth-element-candidates.json'),JSON.stringify(report,null,2)+'\n');}
module.exports={files,candidates,recommended,baselineRef,compile,rules,array,paletteModel,colorTables};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
