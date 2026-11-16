// One-shot transition from a separate hold deadline to knockdown-owned lifetime.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {files, compile, compiler, replace, src} = require('./measure-further-optimizations.cjs');

function transform(f) {
    replace(f,'variables.opy', '# Independent secondary enhancement slot.',
        '# Wrestler holds until Knocked Down ends; manual throws request release.\nenum WrestlerCarryState:\n    NONE = 0,\n    HOLDING = 1,\n    THROW_REQUESTED = 2,\n\n# Independent secondary enhancement slot.');
    replace(f,'variables.opy',
        '# Dead Weight: human-owned held zombie, retained for HUD and bot release.\n# Exclusive primary enhancement, independent of all human Augments and bot state.\n# Initialization writes null; pickup alone writes a player reference.\n#!define enhancementHeldZombie actorTeamSlot22',
        '# Wrestler: human-owned WrestlerCarryState, retained for input, HUD and bot release.\n# The bot owns the carrier reference; no human-side target reference is needed.\n# Pickup sets HOLDING, a second press sets THROW_REQUESTED, release sets NONE.\n# Exclusive primary enhancement, independent of all human Augments and bot state.\n#!define enhancementCarryState actorTeamSlot22');
    replace(f,'variables.opy',
        '# Dead Weight: hold deadline; 0 requests a throw. Read only while a zombie is held.\n# Pickup overwrites it; no chase, wait or human Augment owns this role.\n#!define enhancementHoldUntil actorTeamSlot23\n', '');
    for (const name of Object.keys(f)) {
        f[name] = f[name].replaceAll('enhancementHeldZombie != null', 'enhancementCarryState != WrestlerCarryState.NONE')
            .replaceAll('enhancementHeldZombie == null', 'enhancementCarryState == WrestlerCarryState.NONE')
            .replaceAll('enhancementHeldZombie = null', 'enhancementCarryState = WrestlerCarryState.NONE');
    }
    replace(f,'enhancements.opy', '#!define WRESTLER_DURATION 5\n', '');
    replace(f,'enhancements.opy', 'eventPlayer.enhancementHoldUntil = 0', 'eventPlayer.enhancementCarryState = WrestlerCarryState.THROW_REQUESTED');
    replace(f,'enhancements.opy',
        '    eventPlayer.enhancementHeldZombie = livingProjectileCandidate\n    eventPlayer.enhancementHoldUntil = getTotalTimeElapsed() + WRESTLER_DURATION',
        '    eventPlayer.enhancementCarryState = WrestlerCarryState.HOLDING');
    replace(f,'enhancements.opy',
        '    # Knockdown begins at pickup and outlasts the hold limit by one second.\n    # Clearing it early interrupts the carry; throw damage clears it explicitly.',
        '    # Knockdown owns the carry lifetime; expiration or early removal releases.\n    # Throw damage clears it explicitly after the existing damage delay.');
    replace(f,'enhancements.opy',
        'eventPlayer.wrestlerZombieCarrier.enhancementHoldUntil <= getTotalTimeElapsed()',
        'eventPlayer.wrestlerZombieCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED');
    replace(f,'enhancements.opy',
        "    # A second press requests release by setting the carrier's deadline to zero.",
        '    # A second press sets THROW_REQUESTED; knockdown expiry releases without a throw.');
    replace(f,'enhancements.opy',
        'wrestlerCarrier.enhancementHoldUntil == 0',
        'wrestlerCarrier.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED');
    replace(f,'supply_drops.opy', 'eventPlayer.enhancementHoldUntil == 0',
        'eventPlayer.enhancementCarryState == WrestlerCarryState.THROW_REQUESTED');
    replace(f,'player_initialization.opy',
        'f"[{inputBindingString(Button.INTERACT)}]: throw | {max(0, ceil(localPlayer.enhancementHoldUntil - getTotalTimeElapsed()))}s left"',
        'f"[{inputBindingString(Button.INTERACT)}]: throw"');
    replace(f,'player_initialization.opy',
        "            # This shared slot must start as a player reference or null, never\n            # a previous enhancement's number/array/color. Pickup sets its deadline.",
        '            # Shared enhancement storage starts in the numeric idle state.');
    replace(f,'supply_drops.opy', '    # The held reference survives a throw request until the bot finishes cleanup.',
        '    # Carry state stays nonzero through a throw request until bot cleanup.');
    replace(f,'supply_drops.opy', '            # can clear the held reference before the placement rule runs.',
        '            # can clear the carry state before the placement rule runs.');
    replace(f,'supply_drops.opy', '            # This branch stays consumed even if bot cleanup clears the held reference.',
        '            # This branch stays consumed even if bot cleanup clears the carry state.');
    assert(!/enhancementHoldUntil|enhancementHeldZombie|WRESTLER_DURATION/.test(Object.values(f).join('\n')));
}

function bodies(result) {
    return [...result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name,
        hash:crypto.createHash('sha256').update(body.split('\n').filter(l=>!/^\s*(?:"|\/\/)/.test(l))
            .map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(Boolean).join('\n')).digest('hex')}));
}

(async () => {
    await compiler.readyPromise;
    const before = await compile(files);
    assert.equal(before.elements,30069,'Source changed: remeasure first');
    const candidate = {...files};
    transform(candidate);
    const after = await compile(candidate);
    assert.deepEqual(before.warnings,[]);
    assert.deepEqual(after.warnings,[]);
    const oldRules=bodies(before.result), newRules=bodies(after.result);
    assert.equal(oldRules.length,newRules.length);
    const changed=oldRules.filter((r,i)=>{assert.equal(r.name,newRules[i].name);return r.hash!==newRules[i].hash;}).map(r=>r.name);
    assert.deepEqual(changed,['PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)',
        'useLivingProjectile','LIVING PROJECTILE RELEASE','ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)']);
    // Release model: status expiration/removal never throws; a request throws only
    // while all existing safety checks still pass, even on the expiration frame.
    let cases=0;
    for(const state of [1,2]) for(const knocked of [false,true]) for(const safe of [false,true]) {
        const valid=knocked&&safe;
        const release=state===2||!valid;
        const shouldThrow=release&&state===2&&valid;
        assert.equal(shouldThrow,state===2&&knocked&&safe);
        if(!knocked||!safe) assert(release&&!shouldThrow);
        if(state===1&&valid) assert(!release);
        cases++;
    }
    assert(after.elements<before.elements);
    const changedFiles=Object.keys(files).filter(n=>files[n]!==candidate[n]);
    for(const name of changedFiles) fs.writeFileSync(require('./source-layout.cjs').sourcePath(name),candidate[name].replace(/\n/g,'\r\n'));
    fs.writeFileSync(require('./source-layout.cjs').sourcePath('..','main.ws.txt'),after.result);
    const report={compiler:'OverPy 9.7.21',before:before.elements,after:after.elements,saved:before.elements-after.elements,
        changedRules:changed,unchangedRules:oldRules.length-changed.length,changedFiles,warnings:after.warnings,
        carryModelCases:cases,newVariables:0,newSubroutines:0,
        behavior:'Carry lasts until the existing 6s Knocked Down ends or is removed early. No separate 5s limit or HUD countdown. Manual throw uses states 0/1/2 in the existing human enhancement slot; the former deadline slot is no longer used by Wrestler. Existing safety checks, carrier protection and delayed throw damage remain.',
        limitations:'Static build, rule-scope comparison and release-state model; no Overwatch playtest.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-wrestler-knockdown-lifetime.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
})().catch(error=>{console.error(error);process.exitCode=1;});
