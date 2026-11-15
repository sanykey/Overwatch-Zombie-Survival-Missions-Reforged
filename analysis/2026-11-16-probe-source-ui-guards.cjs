const path=require('node:path');
const compiler=require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
(async()=>{
 await compiler.readyPromise;
 for(const [name,source] of Object.entries({
 pair:'globalvar phase\nplayervar id\nrule "p":\n    @Event eachPlayer\n    @Condition (phase and eventPlayer.id == 6) == 1\n    smallMessage(eventPlayer, "ok")\n',
 nullBarrier:'globalvar phase\nplayervar id\nrule "p":\n    @Event eachPlayer\n    @Condition (phase and eventPlayer.id == 6) != null\n    smallMessage(eventPlayer, "ok")\n',
 falseBarrier:'globalvar phase\nplayervar id\nrule "p":\n    @Event eachPlayer\n    @Condition (phase and eventPlayer.id == 6) != false\n    smallMessage(eventPlayer, "ok")\n',
 noOptPair:'#!disableOptimizations\nglobalvar phase\nplayervar id\nrule "p":\n    @Event eachPlayer\n    @Condition (phase and eventPlayer.id == 6) == true\n    smallMessage(eventPlayer, "ok")\n#!enableOptimizations\n',
 guard:'rule "g":\n    @Event playerDealtDamage\n    @Hero sierra\n    if eventAbility == Button.SECONDARY_FIRE and victim.getTeam() == Team.2:\n        victim.setStatusEffect(attacker, Status.HACKED, 3)\n'
 })){
  const r=await compiler.compile('#!optimizeForSize\n#!optimizeForSizeAggressive\n#!debugElementCount\n'+source,'en-US');
  console.log(name,r.nbElements,r.result);
 }
})().catch(e=>{console.error(e);process.exitCode=1;});
