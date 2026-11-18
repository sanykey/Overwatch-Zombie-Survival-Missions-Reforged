const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const {compile,rules}=require('./2026-11-18-twenty-ninth-element-candidates.cjs');
const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');
const root=path.resolve(__dirname,'..');process.chdir(root);
const baselineRef='7fd6b7e5ffcdc27622a0092709ca7909515031de';
const names=execFileSync('git',['ls-tree','-r','--name-only',baselineRef,'src'],{encoding:'utf8'}).trim().split('\n').filter(n=>n.endsWith('.opy'));
const files=Object.fromEntries(names.map(n=>[n.slice(4),execFileSync('git',['show',baselineRef+':'+n],{encoding:'utf8'}).replace(/\r\n/g,'\n')]));
files.__numbersGenerator=execFileSync('git',['show',baselineRef+':tools/create numbers.js'],{encoding:'utf8'}).replace(/\r\n/g,'\n');
function masks(f,value){let count=0;for(const name of names.map(n=>n.slice(4))){count+=f[name].split('vect(1, 0, 1)').length-1;f[name]=f[name].replaceAll('vect(1, 0, 1)',value);}assert.equal(count,15);}
const candidates={
 barrier_relative_distance(f){
  const file='abilities/augment_laser_barricade.opy';
  for(const who of ['player','target']){
   const old=`distance(vect(${who}.getPosition().x, eventPlayer.augmentBarrierCorner1.y, ${who}.getPosition().z), eventPlayer.augmentBarrierCorner1 + eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_AUGMENT_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, (${who}.getPosition() - eventPlayer.augmentBarrierCorner1) * vect(1, 0, 1))))))`;
   const next=`magnitude((${who}.getPosition() - eventPlayer.augmentBarrierCorner1) * vect(1, 0, 1) - eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_AUGMENT_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, (${who}.getPosition() - eventPlayer.augmentBarrierCorner1) * vect(1, 0, 1))))))`;
   assert(f[file].includes(old));f[file]=f[file].replace(old,next);
  }
 },
 xz_direction_sum(f){masks(f,'(Vector.LEFT + Vector.FORWARD)');},
 xz_cached_vector(f){masks(f,'horizontalMaskConst');f['core/immutable_variables.opy']+='\n# Componentwise projection onto XZ; immutable, shared by geometry and live HUDs.\nglobalvar horizontalMaskConst = vect(1, 0, 1)\n';},
 xz_cached_direction_sum(f){masks(f,'horizontalMaskConst');f['core/immutable_variables.opy']+='\n# Componentwise projection onto XZ; immutable, shared by geometry and live HUDs.\nglobalvar horizontalMaskConst = Vector.LEFT + Vector.FORWARD\n';},
};
candidates.combined=f=>{candidates.barrier_relative_distance(f);let count=0;for(const name of names.map(n=>n.slice(4))){count+=f[name].split('vect(1, 0, 1)').length-1;f[name]=f[name].replaceAll('vect(1, 0, 1)','horizontalMaskConst');}assert.equal(count,17);f['core/immutable_variables.opy']+='\n# Componentwise projection onto XZ; immutable, shared by geometry and live HUDs.\nglobalvar horizontalMaskConst = vect(1, 0, 1)\n';f['abilities/augment_laser_barricade.opy']=f['abilities/augment_laser_barricade.opy'].replace('# Componentwise multiplication by (1, 0, 1) projects relative positions onto XZ.','# horizontalMaskConst projects relative positions onto XZ.\n    # Translate the wall-distance calculation to corner 1 to avoid rebuilding world points.');};
async function main(){const baseline=await compile(files);assert.equal(baseline.nbElements,29889);const before=rules(baseline.result),report={baselineRef,baseline:baseline.nbElements,results:[]};for(const [name,fn] of Object.entries(candidates)){const f={...files};fn(f);const r=await compile(f),after=rules(r.result);assert.deepEqual(nestedPredicates(r.result),[]);const row={name,elements:r.nbElements,saved:baseline.nbElements-r.nbElements,warnings:r.encounteredWarnings,changedRules:Object.keys(before).filter(n=>before[n]!==after[n])};report.results.push(row);console.log(row);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-first-'+name+'.ws.txt'),r.result);}fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-first-baseline.ws.txt'),baseline.result);fs.writeFileSync(path.join(__dirname,'2026-11-18-thirty-first-element-candidates.json'),JSON.stringify(report,null,2)+'\n');}
module.exports={files,candidates,baselineRef,compile,rules};
if(require.main===module)main().catch(e=>{console.error(e);process.exitCode=1;});
