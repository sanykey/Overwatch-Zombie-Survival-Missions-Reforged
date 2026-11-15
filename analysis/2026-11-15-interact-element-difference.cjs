const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
(async () => {
    await compiler.readyPromise;
    const current = fs.readFileSync(path.join(root, 'src/supply_drops.opy'), 'utf8');
    const prior = current.replace(
        '    @Condition isGameplayActive == true\n    @Condition eventPlayer.isDummy() == false\n    @Condition eventPlayer.isAlive() == true\n    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true',
        '    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true\n    @Condition eventPlayer.isAlive() == true\n    @Condition eventPlayer.isDummy() == false\n\n    if not isGameplayActive:\n        return'
    ).replace('        if ruleCondition and not eventPlayer.isHoldingButton(Button.CROUCH):',
        '        if not ruleCondition:\n            return\n        if isGameplayActive and not eventPlayer.isHoldingButton(Button.CROUCH):');
    for (const [name, source] of [['prior', prior], ['current', current]]) {
        const includes = fs.readFileSync(path.join(root, 'src/includes.opy'), 'utf8').replace('#!include "supply_drops.opy"', source.replace(/^#!mainFile.*$/gm, ''));
        const result = await compiler.compile(includes, 'en-US', path.join(root, 'src').replace(/\\/g, '/') + '/', 'includes.opy');
        const body = result.result.match(/rule \("PLAYER INTERACT[^\n]+\n([\s\S]*?)^\}/m)[1];
        console.log(JSON.stringify({name, elements: result.nbElements, warnings: result.encounteredWarnings, relevantLines: body.split('\n').filter(l => /Global.isGameplayActive ==|Abort If|Wait Until|If\(And\(Global.isGameplayActive|If\(And\(\(\(Compare\(Global.isGameplayActive/.test(l)).map(l => l.trim())}, null, 2));
    }
})().catch(e => {console.error(e); process.exitCode = 1;});
