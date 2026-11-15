const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const compiler = require(path.join(process.env.USERPROFILE,'.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));
const file = s => path.join(__dirname,'2026-11-15-pregame-text-'+s);
const sha = s => crypto.createHash('sha256').update(s).digest('hex');
const control = fs.readFileSync(file('G-player-world-only.ws.txt'),'utf8');
const validation = JSON.parse(fs.readFileSync(file('G-validation.json'),'utf8'));
assert.equal(sha(control),validation.outputSha256);
const gate = '        If(Compare(Event Player, ==, Host Player));\n';
const end = '        End;\n';
let blocks = 0;
let body = control.replace(/^rule \("EFFECTS\/TEXT"\) \{[\s\S]*?^\}/gm, rule => {
    const lines = [...rule.matchAll(/^        Create In-World Text\([^\r\n]*\r?\n/gm)];
    assert.equal(lines.length,5);
    const start = lines[0].index, finish = lines[4].index + lines[4][0].length;
    const textBlock = rule.slice(start,finish);
    assert.equal(textBlock.split('\n').filter(l=>l.trim()).length,5);
    blocks++;
    return rule.slice(0,start)+gate+textBlock+end+rule.slice(finish);
});
assert.equal(blocks,1);
function norm(s) {return s.replace(/\/\*[\s\S]*?\*\//g,'').split('\n').map(l=>l.replace(/;\s*\/\/.*$/,';').trim()).filter(l=>l&&!l.startsWith('//')).join('\n');}
assert.equal(norm(body.replace(gate,'').replace(end+'    }\n}\n\nrule ("PLAYER SELECTS/RESELECTS HERO")','    }\n}\n\nrule ("PLAYER SELECTS/RESELECTS HERO")')),norm(control));
(async()=>{
    await compiler.readyPromise;
    const setup = '#!debugElementCount\nrule "probe":\n    @Event eachPlayer\n';
    const a = await compiler.compile(setup+'    smallMessage(eventPlayer, "probe")\n','en-US');
    const guardSource = await compiler.decompileAllRules('rule("probe") { event { Ongoing - Each Player; All; All; } actions { If(Compare(Event Player, ==, Host Player)); Small Message(Event Player, Custom String("probe")); End; } }','en-US');
    const b = await compiler.compile('#!debugElementCount\n'+guardSource,'en-US');
    const overhead = b.nbElements-a.nbElements;
    assert(b.result.includes('If(Compare(Event Player, ==, Host Player));'));
    const elements = validation.probeElements+overhead;
    body=body.replace(/^\/\*[\s\S]*?\*\//,`/* Diagnostic J: G with player world texts created only for Host Player.\nElement count: (total ${elements}); guard overhead ${overhead} measured with OverPy.\nMalevento + 5 standard lobby bots; host selects Shion, then Crouch.\n*/`);
    await compiler.decompileAllRules(body,'en-US');
    fs.writeFileSync(file('J-host-text-only.ws.txt'),body);
    const report={inputSha256:sha(control),outputSha256:sha(body),elements,deltaFromG:overhead,
        verified:'Added exactly one If(Event Player == Host Player) / End around five contiguous world-text creation calls in player Pregame visual rule. No Conditions, effects, settings or other actions changed. Decompiled successfully.',
        scenario:'Host in Team 1, Malevento, same five standard lobby bots, Shion -> Crouch; no Enhancement/Augment selection.',
        limitation:'Host must perform test. Fewer world texts and their evaluations, but all five bots remain. No native game test. Host transfer while rule is active is outside this diagnostic scenario.'};
    fs.writeFileSync(file('J-validation.json'),JSON.stringify(report,null,2)+'\n');
    assert.equal(sha(fs.readFileSync(file('G-player-world-only.ws.txt'),'utf8')),validation.outputSha256);
    console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
