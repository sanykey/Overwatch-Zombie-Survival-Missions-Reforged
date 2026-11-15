// Compile in-memory experiments only; do not change gameplay sources or main.ws.txt.
const fs = require('node:fs');
const path = require('node:path');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'src');
const read = name => fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n');
const supply = read('supply_drops.opy');
const augments = read('augments.opy');
function rule(text, name) {
    const start = text.indexOf('rule "' + name + '":');
    if (start < 0) throw new Error(name);
    const next = text.slice(start + 1).search(/\n(?:rule |def )/);
    return text.slice(start, next < 0 ? undefined : start + 1 + next).trimEnd();
}
const teleport = rule(augments, 'APOTHECARY TELEPORT');
const barrier = rule(augments, 'LASER BARRICADE (PLACEMENT)');
const menu = rule(augments, 'PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)');
const body = text => text.slice(text.indexOf('\n\n') + 2).trimEnd();
const indent = text => text.split('\n').map(l => l ? '    ' + l : l).join('\n');
const combined = `rule "EXPERIMENT COMBINED CROUCH INTERACT":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementCarryState == WrestlerCarryState.NONE) == true
    @Condition ((eventPlayer.augmentId == Augment.APOTHECARY and eventPlayer.augmentApothecaryReady == true and (eventPlayer.augmentApothecaryPosition != null or healthpackPositionList != [])) or (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown == 0)) == true

    if eventPlayer.augmentId == Augment.APOTHECARY:
${indent(body(teleport))}
    else:
${indent(body(barrier))}
`;
const menuSupply = supply.replace(
    '    @Condition eventPlayer.isAlive() == true\n    @Condition eventPlayer.isDummy() == false',
    '    @Condition ((isPregameSetup and eventPlayer.hasSpawned()) or (eventPlayer.isAlive() and not eventPlayer.isDummy())) == true'
).replace('    if not isGameplayActive:',
    `    if isPregameSetup and eventPlayer.hasSpawned():\n${body(menu)}\n    if not eventPlayer.isAlive() or eventPlayer.isDummy():\n        return\n    if not isGameplayActive:`);
(async () => {
    await compiler.readyPromise;
    const results = [];
    for (const [name, s, a] of [
        ['baseline', supply, augments],
        ['merge-crouch-handlers', supply, augments.replace(teleport, combined).replace(barrier, '')],
        ['merge-menu-into-interact', menuSupply, augments.replace(menu, '')],
    ]) {
        const input = read('includes.opy').replace('#!include "supply_drops.opy"', s.replace(/^#!mainFile.*$/gm, '')).replace('#!include "augments.opy"', a.replace(/^#!mainFile.*$/gm, ''));
        const result = await compiler.compile(input, 'en-US', src.replace(/\\/g, '/') + '/', 'includes.opy');
        const rules = [...result.result.matchAll(/^rule \("([^"\n]+)"\) \{([\s\S]*?)^\}/gm)].map(([,name,body]) => ({name,body}));
        const eachPlayer = rules.filter(r => r.body.includes('Ongoing - Each Player;'));
        const conditionCount = r => (r.body.match(/conditions \{([\s\S]*?)\}/)?.[1].match(/;\s*\/\//g) || []).length;
        const row = {name, elements: result.nbElements, delta: result.nbElements - (results[0]?.elements || result.nbElements), rules: rules.length, eachPlayerRules: eachPlayer.length, eachPlayerConditionRows: eachPlayer.reduce((n,r) => n + conditionCount(r), 0), warnings: result.encounteredWarnings};
        results.push(row);
    }
    fs.writeFileSync(path.join(__dirname, '2026-11-15-interact-rule-merge-results.json'), JSON.stringify(results, null, 2) + '\n');
    console.log(JSON.stringify(results, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
