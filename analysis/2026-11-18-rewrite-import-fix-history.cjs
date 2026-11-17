const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),cp=require('node:child_process');
const root=path.resolve(__dirname,'..');process.chdir(root);
const backup='backup/before-import-fix-rewrite-2026-11-18',stash='93da105b53cc3b74165b4fec2f48356201bcbc99';
const bad='b2c1adf7b077e0d797fe6deb686cb6715c2201b0';
function git(args,opts={}){return cp.execFileSync('git',args,{encoding:'utf8',...opts}).trim();}
function read(p){return fs.readFileSync(p,'utf8').replace(/\r\n/g,'\n');}
function write(p,s){fs.writeFileSync(p,s);}
function replace(p,a,b){const s=read(p);assert(s.includes(a),`${p}: ${a}`);write(p,s.replace(a,b));}
function run(p){const output=cp.execFileSync(process.execPath,[p],{encoding:'utf8',maxBuffer:8*1024*1024});write('analysis/2026-11-18-history-check-latest.log',output);}
function untrackedFromStash(p){return cp.execFileSync('git',['show',stash+'^3:'+p],{encoding:'utf8'});}
const commits=git(['rev-list','--reverse',bad+'^..'+backup]).split('\n');
const ordinals=['thirteenth','fourteenth','fifteenth','sixteenth','seventeenth','eighteenth','nineteenth','twentieth',null];
const expectedSavings=[2,9,14,15,10,9,10,4,8],mapping=[];
assert.equal(commits.length,9);
const replayed=git(['rev-list','--reverse',bad+'^..HEAD']).split('\n').filter(Boolean),resumeAt=replayed.length;
if(!process.argv.includes('--resume-prepared'))assert.equal(resumeAt,0);
let previousCount=30092;
for(let i=0;i<resumeAt;i++) {
 const p=`analysis/2026-11-${i<=4?'17':'18'}-${ordinals[i]}-element-implementation.json`;
 const result=JSON.parse(git(['show',replayed[i]+':'+p]));
 mapping.push({old:commits[i],new:replayed[i],elements:result.elements,saved:previousCount-result.elements});previousCount=result.elements;
}
for(let i=resumeAt;i<commits.length;i++) {
 const old=commits[i],prepared=i===resumeAt&&process.argv.includes('--resume-prepared');
 const added=git(['diff-tree','--no-commit-id','--name-only','-r',old]).split('\n');
 const analyses=added.filter(n=>n.startsWith('analysis/'));
 if(!prepared) {
 git(['cherry-pick','--no-commit',old]);
 if(i===0) {
  const file='src/abilities/enhancements.opy';
  replace(file,'    @Condition [eventPlayer.wrestlerZombieCarrier].any(lambda carrier: carrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not livingProjectileValid(carrier)) == true','    # Keep this outside any()/map()/filter(): livingProjectileValid already uses all().\n    # OverPy accepts nested collection predicates that the Workshop importer rejects.\n    @Condition (eventPlayer.wrestlerZombieCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED or not livingProjectileValid(eventPlayer.wrestlerZombieCarrier)) == true');
  const instruction=cp.execFileSync('git',['show',stash+':AGENTS.md'],{encoding:'utf8'}).split(/\r?\n/).find(s=>s.startsWith('- Successful OverPy compilation'));
  assert(instruction);replace('AGENTS.md','\n## Workshop Native UI Diagnostics','\n'+instruction+'\n\n## Workshop Native UI Diagnostics');
  write('analysis/2026-11-18-workshop-predicate-nesting.cjs',untrackedFromStash('analysis/2026-11-18-workshop-predicate-nesting.cjs'));
  const candidate='analysis/2026-11-17-thirteenth-element-candidates.cjs';
  replace(candidate,"['boss_egg_constant_health','carry_condition_owner_binding','select_first_visible_filter']","['boss_egg_constant_health']");
  replace(candidate,"['boss_egg_constant_health','carry_condition_owner_binding']","['boss_egg_constant_health']");
  replace(candidate,"name==='combined_recommended'?30071:30084",'30090');
  let s=read(candidate);
  s=s.replace("    assert(conditions(after[carry]).includes('Is True For Any(Array('));assert(conditions(after[carry]).includes('Is True For All(Array('));\n    assert.equal((conditions(after[carry]).match(/Current Array Element/g)||[]).length,7);","    assert.equal(after[carry],before[carry]);");
  s=s.replace("const expected=['BOT BECOMES BOSS #1','BOT BECOMES ZOMBIE EGG #1',carry];if(name==='combined_recommended')expected.push('selectTarget #1');","const expected=['BOT BECOMES BOSS #1','BOT BECOMES ZOMBIE EGG #1'];");
  s=s.replace('   report.results.push(row);',"   if(name==='carry_condition_owner_binding')row.rejectedForImportCompatibility=true;\n   if(name==='select_first_visible_filter')row.excludedByUser=true;\n   report.results.push(row);");write(candidate,s);
  const validator='analysis/2026-11-17-validate-thirteenth-element-implementation.cjs';s=read(validator);
  s=s.replace("['boss_egg_constant_health','carry_condition_owner_binding']","['boss_egg_constant_health']").replaceAll('30084','30090');
  s=s.replace("['BOT BECOMES BOSS #1','BOT BECOMES ZOMBIE EGG #1',carry]","['BOT BECOMES BOSS #1','BOT BECOMES ZOMBIE EGG #1']");
  s=s.replace(" assert(conditions(actual[carry]).includes('Is True For Any(Array('));assert(conditions(actual[carry]).includes('Is True For All(Array('));\n assert.equal((conditions(actual[carry]).match(/Current Array Element/g)||[]).length,7);"," assert.equal(actual[carry],before[carry]);");write(validator,s);
  const review='analysis/2026-11-17-thirteenth-element-review.md';
  write(review,read(review).replace(/^(# [^\n]+\n)/,'$1\n**После переноса исправления в этот коммит:** внедрено только постоянное здоровье Boss/Egg: 30 092 → 30 090 (−2). Вариант owner-binding ниже — отклонённая экспериментальная проба: Any вокруг livingProjectileValid создаёт запрещённый вложенный All. Исходные Conditions и Actions Living Projectile сохранены. Вариант filter()[0] по-прежнему исключён пользователем. Исторические оценки полного экспериментального пакета ниже не описывают внедрённую сборку.\n'));
 }else {
  for(const p of analyses) {
   let s=read(p);
   for(const pair of mapping) {
    s=s.replaceAll(pair.old,pair.new);
    for(const length of [8,7])s=s.replace(new RegExp('\\b'+pair.old.slice(0,length)+'\\b','g'),pair.new.slice(0,length));
   }
   // Only this commit's analysis files: all baselines after the rejected optimization grow by six.
   s=s.replace(/\b30[ \u202f\u00a0]?\d{3}\b/g,value=>{
    const n=Number(value.replace(/[ \u202f\u00a0]/g,''));if(n<30000||n>30100)return value;
    const next=String(n+6);return value.length===6?next.slice(0,2)+value[2]+next.slice(2):next;
   });write(p,s);
  }
 }
 }
 const candidates=ordinals[i]?[`analysis/2026-11-${i<=5?'17':'18'}-${ordinals[i]}-element-candidates.cjs`]:[
  'analysis/2026-11-18-twenty-first-element-candidates.cjs','analysis/2026-11-18-twenty-second-element-candidates.cjs'];
 // Eighteenth candidates were created on the 17th; its implementation validator on the 18th.
 const validator=i===8?'analysis/2026-11-18-validate-grid-and-supply-implementation.cjs':`analysis/2026-11-${i<=4?'17':'18'}-validate-${ordinals[i]}-element-implementation.cjs`;
 if(!prepared){for(const p of candidates)run(p);run(validator);}
 const actual=read('main.ws.txt');
 const {nestedPredicates}=require('./2026-11-18-workshop-predicate-nesting.cjs');assert.deepEqual(nestedPredicates(actual),[]);
 const json=i===8?'analysis/2026-11-18-grid-and-supply-implementation.json':`analysis/2026-11-${i<=4?'17':'18'}-${ordinals[i]}-element-implementation.json`;
 const result=JSON.parse(read(json));assert.equal(previousCount-result.elements,expectedSavings[i]);assert.deepEqual(result.warnings,[]);
 previousCount=result.elements;
 if(i===8) {
  for(const p of ['analysis/2026-11-18-living-projectile-import-fix.md','analysis/2026-11-18-validate-living-projectile-import-fix.cjs'])write(p,untrackedFromStash(p));
  replace('analysis/2026-11-18-living-projectile-import-fix.md','Коммит не создавался.','Исправление перенесено в переписанную версию исходного коммита; последующие коммиты пересобраны и переименованы с фактической экономией. Ссылки badRef и baselineRef в проверке намеренно указывают на сохранённую исходную историю для воспроизведения дефекта.');
  run('analysis/2026-11-18-validate-living-projectile-import-fix.cjs');
  write('analysis/2026-11-18-import-fix-history-rewrite.json',JSON.stringify({backupBranch:backup,originalTip:commits.at(-1),finalElements:previousCount,inGameValidation:false,commits:[...mapping,{old,new:'commit containing this report',elements:previousCount,saved:expectedSavings[i]}]},null,2)+'\n');
 }
 git(['add','--',...added]);
 if(i===0)git(['add','--','AGENTS.md','analysis/2026-11-18-workshop-predicate-nesting.cjs']);
 if(i===8)git(['add','--','analysis/2026-11-18-living-projectile-import-fix.md','analysis/2026-11-18-living-projectile-import-fix.json','analysis/2026-11-18-validate-living-projectile-import-fix.cjs','analysis/2026-11-18-import-fix-history-rewrite.json','analysis/2026-11-18-rewrite-import-fix-history.cjs']);
 git(['diff','--cached','--check']);
 const subject=i===0?'perf: simplify boss health initialization':git(['show','-s','--format=%s',old]);
 const message=subject+` (-${expectedSavings[i]})`;
 git(['commit','-m',message,'--author',git(['show','-s','--format=%an <%ae>',old])],{env:{...process.env,GIT_AUTHOR_DATE:git(['show','-s','--format=%aI',old])}});
 const rewritten=git(['rev-parse','HEAD']);mapping.push({old,new:rewritten,elements:previousCount,saved:expectedSavings[i]});
 console.log(JSON.stringify({step:i+1,old:old.slice(0,7),new:rewritten.slice(0,7),elements:previousCount,subject:message}));
}
console.log(JSON.stringify({done:true,mapping},null,2));
