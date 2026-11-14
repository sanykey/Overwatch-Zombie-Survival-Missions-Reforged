const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {start, scenario, applies} = require('./verify-augments.cjs');
const root = path.resolve(__dirname, '..');
const name = '[CHARGE_BATTERY] RESET COOLDOWNS ON ULTIMATE';
(async () => {
    await compiler.readyPromise;
    const baseline = {...files};
    for (const file of ['enhancements.opy', 'supply_drops.opy', 'global_start_menu.opy', 'augments.opy', 'variables.opy', 'dash.opy', 'subroutines.opy', 'player_initialization.opy', 'main.opy']) {
        baseline[file] = execFileSync('git', ['show', `HEAD:src/${file === 'main.opy' ? 'includes.opy' : file}`], {encoding:'utf8'}).replace(/\r\n/g, '\n');
    }
    const before = await compile(baseline), after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    const oldRules = rules(before.result), newRules = rules(after.result);
    const oldPowerup = oldRules.find(r => r.name === 'noCooldowns (20-29)').body;
    const powerup = newRules.find(r => r.name === 'noCooldowns (20-29)').body;
    const helper = newRules.find(r => r.name === 'Subroutine resetAbilityCooldowns').body;
    const reset = oldPowerup.slice(oldPowerup.indexOf('Set Ability Cooldown('), oldPowerup.indexOf('Wait(0.032'));
    const helperActions = helper.split('actions {\n')[1].replace(/\n\}$/, '')+'\n';
    assert.equal(helperActions, reset, 'Reset actions and Reaper exception must match the old powerup exactly');
    assert.equal(powerup.replace('Call Subroutine(resetAbilityCooldowns);\n', reset), oldPowerup);
    const activation = newRules.find(r => r.name === name).body;
    assert(activation.includes('Is Using Ultimate(Event Player) == True;'));
    assert(activation.includes('(Event Player).enhancementId == 6;'));
    assert(activation.includes('Global.isGameplayActive == True;'));
    assert.equal(activation.split('actions {\n')[1], 'Call Subroutine(resetAbilityCooldowns);\n}');
    assert(!newRules.some(r=>r.name.includes('HALVE NEW COOLDOWNS')));
    assert(!Object.values(files).some(source=>source.includes('enhancementBatteryCdState') || source.includes('BATTERY_CD_BUTTONS')));
    const compiled=new Map(newRules.map(r=>[r.name,r]));
    const activationRule=compiled.get(name);
    const buttons=['Ability 1','Ability 2','Primary Fire','Secondary Fire','Interact','Crouch','Jump','Reload'];
    let cases=0;
    for(let augmentId=0;augmentId<=10;augmentId++) for(const hero of ['Soldier: 76','Reaper']) {
        const state=scenario(augmentId,{ultimate:true,hero});
        state.player.enhancementId=6;
        state.player.actorTeamSlot21=9;
        state.player.augmentState0=190;
        state.player.augmentState1='live effect';
        state.player.augmentState2=1;
        state.player.augmentState3='live position';
        state.cooldowns=Object.fromEntries(buttons.map(b=>[b,10]));
        const original={...state.player};
        const task=start(activationRule,state,compiled);
        assert(task.done());
        assert(buttons.every(b=>state.cooldowns[b]===0));
        assert.deepEqual(state.player,original,'No augment state or timer snapshots may be written');
        assert.equal(state.abilityCharges['Ability 1'],2);
        assert.equal(state.abilityCharges['Secondary Fire'],2);
        assert.equal(state.abilityCharges['Ability 2'],hero==='Reaper'?undefined:2);
        assert.equal(state.cooldownWrites.length,8);
        // Completed actions leave later cooldowns untouched throughout the ultimate.
        state.time+=1;state.cooldowns['Ability 1']=10;task.resume();
        assert.equal(state.cooldowns['Ability 1'],10);
        state.ultimate=false;assert(!applies(activationRule,state));
        state.ultimate=true;start(activationRule,state,compiled);
        assert.equal(state.cooldowns['Ability 1'],0,'A new ultimate resets again');
        state.globals.isGameplayActive=false;assert(!applies(activationRule,state));
        cases++;
    }
    const allowed = new Set(['noCooldowns (20-29)', 'EFFECTS/TEXTS']);
    for (const old of oldRules) {
        const renamed = {'CHARGE BATTERY':'[CHARGE_BATTERY] PLACE BATTERY', 'CHARGE BATTERY (USAGE AND COOLDOWNS)':'[CHARGE_BATTERY] USAGE AND COOLDOWNS'};
        const next = newRules.find(r => r.name === (renamed[old.name] ?? old.name));
        assert(next, old.name);
        if (!allowed.has(old.name)) assert.equal(next.body, old.body, old.name);
    }
    assert.equal(newRules.length, oldRules.length + 2);
    // Compare a copy with identical behavior but duplicated reset actions.
    const inline = {...files};
    const helperStart = inline['supply_drops.opy'].indexOf('# Shared instantaneous reset;');
    const helperEnd = inline['supply_drops.opy'].indexOf('def noCooldowns():', helperStart);
    const sourceReset = inline['supply_drops.opy'].slice(helperStart, helperEnd).split('def resetAbilityCooldowns():\n')[1].trimEnd();
    inline['supply_drops.opy'] = (inline['supply_drops.opy'].slice(0,helperStart)+inline['supply_drops.opy'].slice(helperEnd))
        .replace('subroutine resetAbilityCooldowns\n','').replace('        resetAbilityCooldowns()', sourceReset.replace(/^/gm,'    '));
    inline['charge_battery.opy'] = inline['charge_battery.opy'].replace('    resetAbilityCooldowns()', sourceReset);
    inline['subroutines.opy'] = inline['subroutines.opy'].replace('subroutine resetAbilityCooldowns\n','');
    const duplicated = await compile(inline);
    assert.deepEqual(duplicated.warnings, []);
    const saved = {log:console.log,warn:console.warn,error:console.error};
    let exported;
    try {
        console.log=console.warn=console.error=()=>{};
        exported=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/', 'main.opy');
    } finally {Object.assign(console,saved);}
    assert.deepEqual(exported.encounteredWarnings, []);
    assert.deepEqual(rules(exported.result),newRules);
    fs.writeFileSync(path.join(root,'main.ws.txt'),exported.result);
    const report={beforeElements:before.elements,afterElements:after.elements,deltaElements:after.elements-before.elements,
        duplicatedResetElements:duplicated.elements,savedBySharedReset:duplicated.elements-after.elements,
        exportedElements:exported.nbElements,warnings:after.warnings,newVariables:0,
        removedWindowElements:30179-after.elements,behaviorCases:cases,
        verification:'Compiled actions execute one instantaneous reset per ultimate; subsequent cooldowns remain unchanged. Native powerup actions and Reaper exception preserved; no window state, timer polling or augment writes remain.',
        limitation:'No in-game test; once per activation relies on Workshop ongoing-rule false-to-true condition semantics.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-charge-battery-ultimate-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});

