// Compile and evaluate HUD boundary states. Does not simulate the client renderer.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');
const root = path.resolve(__dirname, '..');
function args(s) {
    let depth = 0, quoted = false, start = 0; const out = [];
    for (let i = 0; i < s.length; i++) {
        if (quoted && s[i] === '\\') { i++; continue; }
        if (s[i] === '"') quoted = !quoted;
        if (quoted) continue;
        if (s[i] === '(') depth++;
        if (s[i] === ')') depth--;
        if (s[i] === ',' && !depth) {out.push(s.slice(start,i).trim()); start = i+1;}
    }
    out.push(s.slice(start).trim()); return out;
}
function parse(s) {
    if (s.startsWith('"')) return {value: JSON.parse(s)};
    if (/^-?\d+(\.\d+)?$/.test(s)) return {value: Number(s)};
    const property = s.match(/^\(Local Player\)\.(\w+)$/);
    if (property) return {property: property[1]};
    const call = s.match(/^([^()]+)\((.*)\)$/);
    return call ? {name:call[1], args:args(call[2]).map(parse)} : {name:s};
}
function evaluate(n, player) {
    if ('value' in n) return n.value;
    if (n.property) return player[n.property] ?? 0;
    const at = i => evaluate(n.args[i], player);
    switch (n.name) {
        case 'Null': case 'False': return 0;
        case 'True': return 1;
        case 'Empty Array': return [];
        case 'Local Player': return player;
        case 'Total Time Elapsed': return 100;
        case 'Global.playerTargetList': case 'Global.healthpackPositionList': return [];
        case 'Array': return n.args.map((_,i)=>at(i));
        case 'Value In Array': return at(0)[at(1)];
        case 'Array Contains': return at(0).includes(at(1));
        case 'Remove From Array': return at(0).filter(x=>x!==at(1));
        case 'Is True For Any': return false; // no nearby allies in the fixture
        case 'Count Of': return at(0).length;
        case 'String Split': return at(0).split(at(1));
        case 'If-Then-Else': return at(0) ? at(1) : at(2);
        case 'And': return at(0) && at(1);
        case 'Or': return at(0) || at(1);
        case 'Compare': {
            const a=at(0), b=at(2);
            const equal=Array.isArray(a)&&Array.isArray(b) ? JSON.stringify(a)===JSON.stringify(b) : a===b;
            switch(n.args[1].name) {
                case '==': return equal;
                case '!=': return !equal;
                case '>': return a>b;
                case '>=': return a>=b;
                case '<': return a<b;
                case '<=': return a<=b;
            }
            break;
        }
        case 'Add': return at(0)+at(1);
        case 'Subtract': return at(0)-at(1);
        case 'Multiply': return at(0)*at(1);
        case 'Divide': return at(0)/at(1);
        case 'Min': return Math.min(at(0),at(1));
        case 'Max': return Math.max(at(0),at(1));
        case 'Round To Integer': return n.args[1].name==='Up' ? Math.ceil(at(0)) : n.args[1].name==='Down' ? Math.floor(at(0)) : Math.round(at(0));
        case 'Custom String': return at(0).replace(/\{(\d+)\}/g,(_,i)=>String(Number(i)+1<n.args.length ? at(Number(i)+1) : 0));
        case 'Char In String': return String(at(0)).charAt(at(1));
        case 'Button': case 'Color': case 'Hero': return n.args[0].name;
        case 'Input Binding String': return at(0);
        case 'Icon String': return '✓';
        case 'Hero Of': return player.hero || 'Ana';
    }
    throw Error(`Unsupported expression: ${JSON.stringify(n)}`);
}
function rules(s) {
    const matches=[...s.matchAll(/^rule \("([^"]+)"\) \{/gm)];
    return matches.map((m,i)=>({name:m[1],body:s.slice(m.index,matches[i+1]?.index??s.length).replace(/\n\/\/\d+ elements\s*$/,'')}));
}
const aliases=Object.fromEntries([...files['variables.opy'].matchAll(/^#!define (\w+) (\w+)\s*$/gm)].map(m=>[m[1],m[2]]));
function fixture(values) {
    return Object.fromEntries(Object.entries({...(values.augmentId===9 ? {augmentScavengerBackpack:[]} : {}), ...values}).map(([k,v])=>{
        while(aliases[k]) k=aliases[k]; return [k,v];
    }));
}
async function main() {
    await compiler.readyPromise;
    const baseline={...files};
    for (const name of ['global_start_menu.opy','augments.opy','player_initialization.opy','power_ups.opy']) {
        baseline[name]=execFileSync('git',['show',`HEAD:src/${name}`],{cwd:root,encoding:'utf8'}).replace(/\r\n/g,'\n');
    }
    const before=await compile(baseline);
    const menuOnly=await compile({...files,'player_initialization.opy':baseline['player_initialization.opy']});
    const after=await compile(files);
    assert.deepEqual(after.warnings,[]);
    const oldRules=rules(before.result), newRules=rules(after.result);
    const clean=r=>({...r,body:r.body.split('\n').filter(l=>!l.includes('Create HUD Text(')).join('\n')});
    assert.deepEqual(newRules.map(clean),oldRules.map(clean),'Gameplay actions or HUD visibility rules changed');
    assert.equal(after.result.match(/variables \{[\s\S]*?\n\}/)[0],before.result.match(/variables \{[\s\S]*?\n\}/)[0]);
    const rows=newRules.flatMap(r=>[...r.body.matchAll(/Create HUD Text\((.*)\);/g)].map(m=>({rule:r.name,fields:args(m[1]).map(parse)})));
    const combat=rows.filter(r=>r.rule==='ENHANCEMENT HUD and AUGMENT HUD (PERMANENT TABLES)').slice(0,2);
    assert.equal(combat.length,2);
    const descriptions=[];
    const enhancementMenu=rows.find(r=>JSON.stringify(r.fields[2]).includes('Critical hits deal +60%'));
    const augmentMenu=rows.find(r=>r.rule==='AUGMENT MENU');
    for(const [row,key,count] of [[enhancementMenu,'enhancementId',13],[augmentMenu,'augmentId',10]]) {
        for(let id=1;id<=count;id++) {
            const text=evaluate(row.fields[2],fixture({[key]:id})).trimEnd();
            assert(text.length<=151,`Menu ${key}=${id}: ${text.length}: ${text}`);
            descriptions.push({kind:'menu',key,id,text,length:text.length});
        }
    }
    const states=[{},
        {onlyEnhancement:2,infectionLevel:1.237,enhancementHybridCooldown:0},
        {onlyEnhancement:2,infectionLevel:5,enhancementHybridCooldown:19.2},
        {onlyEnhancement:4,enhancementPlagueCureTotal:999999.99},
        {onlyEnhancement:5,enhancementBattleResetCharges:2},
        {onlyEnhancement:6,enhancementBatteryPlacementCooldown:20},
        {onlyEnhancement:7,enhancementIsHitchhiking:1},
        {onlyEnhancement:8,enhancementPupCooldown:2},
        {onlyEnhancement:8,enhancementPupCooldown:0,enhancementIsPupBeamActive:1},
        {onlyEnhancement:8,enhancementPupCooldown:1,enhancementIsPupBeamActive:1},
        {onlyEnhancement:8,enhancementPupCooldown:2,enhancementIsPupBeamActive:1},
        {onlyEnhancement:9,enhancementCapacitorEnergy:999999},
        {onlyEnhancement:9,enhancementCapacitorEnergy:999999,enhancementCapacitorCharge:100},
        {onlyEnhancement:10,enhancementBulkStacks:999999,sizeScale:2.4925},
        {onlyEnhancement:11,enhancementHeldZombie:1,enhancementHoldUntil:104.2},
        {onlyEnhancement:12,enhancementBoltEnergy:350}, {onlyEnhancement:12,enhancementBoltBurst:-1},
        {onlyEnhancement:13,enhancementScrap:500},
        {onlyAugment:7,augmentBarrierHealth:10000},
        {onlyAugment:7,augmentBarrierHealth:10000,augmentBarrierPlacementCooldown:25},
        {onlyAugment:2,augmentDashCharges:0,augmentDashReadyAt:114},
        {onlyAugment:2,augmentDashCharges:1,augmentDashReadyAt:114},
        {onlyAugment:2,augmentDashCharges:2},
        {onlyAugment:4,augmentMeleePushReadyAt:109},
        {onlyAugment:4,augmentMeleePushReadyAt:100},
        {onlyAugment:3,augmentMovementReadyAt:116},
        {onlyAugment:6,augmentMovementReadyAt:116},
        {onlyAugment:8,augmentApothecaryReady:1,augmentApothecaryPosition:1},
        {onlyAugment:8,augmentApothecaryReady:1}, {onlyAugment:8,hero:'D.Va'}, {onlyAugment:8,hero:'D.Mon'},
        {onlyAugment:9,augmentScavengerBackpack:[1,2]}];
    for(const [row,key,count] of [[combat[0],'enhancementId',13],[combat[1],'augmentId',10]]) {
        for(let id=1;id<=count;id++) for(const state of states) {
            if (state.onlyEnhancement && (key!=='enhancementId' || id!==state.onlyEnhancement)) continue;
            if (state.onlyAugment && (key!=='augmentId' || id!==state.onlyAugment)) continue;
            const p=fixture({[key]:id,...state});
            const text=evaluate(row.fields[2],p).trimEnd();
            assert(text.length<=79,`Combat ${key}=${id}: ${text.length}: ${text}`);
            descriptions.push({kind:'combat',key,id,state,text,length:text.length});
        }
    }
    const text=(index,values)=>evaluate(combat[index].fields[2],fixture(values)).trimEnd();
    assert.equal(text(0,{enhancementId:7}),'[Crouch]: attach near ally');
    assert.equal(text(0,{enhancementId:7,enhancementIsHitchhiking:1}),'[Crouch]: detach');
    for(const ready of [0,1]) for(const position of [0,1]) {
        assert.equal(evaluate(combat[1].fields[8],fixture({augmentId:8,augmentApothecaryReady:ready,augmentApothecaryPosition:position})),ready?'Green':'White');
    }
    for(const [charges,color] of ['Red','Sky Blue','Green'].entries()) {
        assert.equal(evaluate(combat[1].fields[8],fixture({augmentId:2,augmentDashCharges:charges})),color);
    }
    for(const [charges,color] of ['White','Sky Blue','Green'].entries()) {
        assert.equal(evaluate(combat[0].fields[8],fixture({enhancementId:5,enhancementBattleResetCharges:charges})),color);
        assert.equal(evaluate(combat[1].fields[8],fixture({augmentId:9,augmentScavengerBackpack:Array(charges).fill(1)})),color);
    }
    for(const [scrap,color] of [[0,'White'],[49.99,'White'],[50,'Sky Blue'],[199.99,'Sky Blue'],[200,'Green'],[500,'Green']]) {
        assert.equal(evaluate(combat[0].fields[8],fixture({enhancementId:13,enhancementScrap:scrap})),color);
    }
    for(const [energy,color] of [[0,'White'],[49.99,'White'],[50,'Sky Blue'],[99.99,'Sky Blue'],[100,'Green'],[999999,'Green']]) {
        for(const charge of [0,1,100]) {
            assert.equal(evaluate(combat[0].fields[8],fixture({enhancementId:9,enhancementCapacitorEnergy:energy,enhancementCapacitorCharge:charge})),charge>0?'Yellow':color);
        }
    }
    for(const cooldown of [0,1,2]) for(const active of [0,1]) {
        const p=fixture({enhancementId:8,enhancementPupCooldown:cooldown,enhancementIsPupBeamActive:active});
        assert.equal(evaluate(combat[0].fields[2],p).trimEnd(),active?'Attacking':'Drone ready ✓');
        assert.equal(evaluate(combat[0].fields[8],p),active?'Red':'White');
    }
    assert.equal(text(0,{enhancementId:2,infectionLevel:1.237}),'[Melee]: explode for 123 dmg');
    assert.equal(text(0,{enhancementId:2,infectionLevel:5,enhancementHybridCooldown:19.2}),'Explosion: 20s');
    assert(text(0,{enhancementId:9,enhancementCapacitorCharge:100}).includes('Armed: +100 dmg/hit'));
    assert(!text(0,{enhancementId:9,enhancementCapacitorCharge:100}).includes('Hold'));
    assert.equal(aliases.augmentMeleePushReadyAt,aliases.augmentMovementReadyAt);
    for(const [push,ready] of [[109,false],[0,true],[100,true]]) {
        const p=fixture({augmentId:4,augmentMeleePushReadyAt:push});
        assert.equal(evaluate(combat[1].fields[8],p),ready?'Green':'Red');
        assert.equal(evaluate(combat[1].fields[2],p).trimEnd().endsWith(ready?'✓':'9s'),true);
    }
    for(const hero of ['D.Va','D.Mon']) assert(text(1,{augmentId:8,hero}).startsWith('Deal ultimate dmg'));
    assert.equal(text(1,{augmentId:8,augmentApothecaryReady:1}),'No known health packs');
    const exported=await compiler.compile(fs.readFileSync(path.join(root,'main.opy'),'utf8'),'en-US',root.replace(/\\/g,'/')+'/','main.opy');
    assert.deepEqual(exported.encounteredWarnings,[]);
    assert.equal(exported.nbElements,after.elements);
    assert.deepEqual(rules(exported.result),newRules);
    fs.writeFileSync(path.join(root,'main.ws.txt'),exported.result);
    const report={beforeElements:before.elements,afterElements:after.elements,elementDelta:after.elements-before.elements,
        menuElementDelta:menuOnly.elements-before.elements,combatElementDelta:after.elements-menuOnly.elements,
        warnings:after.warnings,menuLimit:151,combatLimit:79,cases:descriptions.length,
        changedRules:newRules.filter((r,i)=>r.body!==oldRules[i].body).map(r=>r.name),descriptions,
        limitation:'Character lengths use action names as bindings; font width and native client reevaluation require an in-game check.'};
    fs.writeFileSync(path.join(__dirname,'2026-11-14-hud-copy-validation.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({...report,descriptions:undefined},null,2));
}
main().catch(e=>{console.error(e);process.exitCode=1;});
