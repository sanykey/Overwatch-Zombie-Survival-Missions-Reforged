const fs=require('node:fs'),assert=require('node:assert/strict'),cp=require('node:child_process'),vm=require('node:vm'),path=require('node:path');
const {files,compile,compiler}=require('./measure-further-optimizations.cjs');
const {rules}=require('./verify-player-variables.cjs');
const {numbers}=require('./2026-11-13-verify-long-reach-numbers.cjs');
const {scenario,start}=require('./verify-augments.cjs');
(async()=>{
 await compiler.readyPromise;
 const original=p=>cp.execFileSync('git',['show','HEAD:src/'+p],{encoding:'utf8'}).replace(/\r\n/g,'\n');
 const before={...files,'augments.opy':original('augments.opy')};
 before['compressed numbers.opy']=before['compressed numbers.opy'].replace('    createNumbers()',vm.runInNewContext(original('create numbers.js')));
 const a=await compile(before),b=await compile(files);assert.deepEqual(b.warnings,[]);
 const allowed=new Set(['Initialize global variables','LONG REACH VENDETTA SWORD','LONG REACH CARNAGE']);
 assert.deepEqual(rules(b.result).filter(r=>!allowed.has(r.name)),rules(a.result).filter(r=>!allowed.has(r.name)));
 const oldNumbers=numbers(a),newNumbers=numbers(b);assert.equal(oldNumbers.length,newNumbers.length);
 const changed=oldNumbers.flatMap((v,i)=>v===newNumbers[i]?[]:[i]);assert.equal(changed.length,6);
 for(const i of changed)assert.equal(newNumbers[i],oldNumbers[i]*.75);
 const heroes=['Reinhardt','Brigitte','D.Mon','Genji','Ramattra','Torbj\u00f6rn'];
 const cases=[['Vendetta',4.3,45,{}],['Reinhardt',4,100,{}],['Brigitte',6,45,{}],['D.Mon',4,60,{}],['Genji',5,100,{ultimate:true}],['Ramattra',10,65,{maxArmor:375}],['Torbj\u00f6rn',2.5,70,{weapon:2}]];
 let checks=0;
 for(const [hero,radius,damage,extra] of cases){
  const traces=[];
  for(const [build,nums] of [[a,oldNumbers],[b,newNumbers]]){
   const map=new Map(rules(build.result).map(r=>[r.name,r]));
   const s=scenario(4,{hero,firing:true,...extra,targets:[{id:'hit',position:[0,0,radius+1],health:10000,alive:true,visible:true}]});
   s.player.initialMaxHealth=525;s.globals.numbersList=nums;s.globals.augmentMeleeWeaponHeroListConst=heroes;s.globals.augmentMeleeBtnHeroListConst=[heroes[0],heroes[1],heroes[5]];
   const t=start(map.get(hero==='Vendetta'?'LONG REACH VENDETTA SWORD':'LONG REACH MELEE WEAPONS'),s,map);
   for(let i=0;i<6;i++){s.time=t.deadline();t.resume();}
   assert(s.damage.length>=3);traces.push(s.damage.map(h=>({...h,targets:h.targets.map(t=>t.id)})));
  }
  assert.deepEqual(traces[1],traces[0].map(h=>({...h,amount:h.amount*.75})),hero);
  assert(traces[1].every(h=>h.amount===damage*.75));checks++;
 }
 const map=new Map(rules(b.result).map(r=>[r.name,r]));
 for(const cancelled of [false,true]){
  const state=scenario(4,{hero:'Junker Queen',ability2:true,targets:[4.5,4.501,13.5,13.501].map((z,i)=>({id:i,position:[0,0,z],health:10000,alive:true,visible:true}))});
  const task=start(map.get('LONG REACH CARNAGE'),state,map);
  if(cancelled)state.ability2=false;
  state.time=task.deadline();task.resume();
  assert.deepEqual(state.damage.map(h=>({amount:h.amount,targets:h.targets.map(t=>t.id)})),cancelled?[]:[{amount:78.75,targets:[1]},{amount:78.75,targets:[2]}]);
  state.time+=5;task.resume();assert.equal(state.damage.length,cancelled?0:2);
 }
 const root=path.resolve(__dirname,'..');const output=await compiler.compile(fs.readFileSync('main.opy','utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
 assert.deepEqual(output.encounteredWarnings,[]);assert.equal(output.nbElements,b.elements);assert.deepEqual(rules(output.result),rules(b.result));fs.writeFileSync('main.ws.txt',output.result);
 const report={before:a.elements,after:b.elements,delta:b.elements-a.elements,weaponCases:checks,carnageCases:2,warnings:b.warnings,unchanged:'All other rules, including Quick Melee',limitation:'Compiled action simulation; no in-game test'};
 fs.writeFileSync('analysis/2026-11-13-long-reach-damage-validation.json',JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
