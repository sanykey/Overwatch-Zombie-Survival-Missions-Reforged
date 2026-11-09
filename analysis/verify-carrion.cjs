// Validate Carrion's table integration against the immutable Remix snapshot and compile the export.
// Pass --write to update main.ws.txt after successful validation.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const root = path.resolve(__dirname, '..');
const read = name => fs.readFileSync(path.join(root, name), 'utf8');
const remix = read('workshop-snapshots/ZSMM-remixed (QZD5F)/2026-10-30 ZSMM-remixed (QZD5F).opy');
const tables = vm.runInNewContext(read('src/create numbers.js') + '\n; numbers');
const table = id => tables.find(g => g.offset === 'NL_' + id + '_OFFSET').list;
const menu = read('src/global_start_menu.opy');
const heroes = menu.match(/botHeroList = \[([^\]]+)\]/)[1].split(', ');
const catIndex = heroes.indexOf('Hero.JETPACK_CAT');
assert.equal(catIndex, 21, 'Append Carrion without moving existing hero indices');
assert.match(menu, /bossesExcludedHeroList = \[[^\]]*Hero\.JETPACK_CAT/);
assert.match(menu, /botSpawnRateList\[21\] = 5/);

// Old missing stat slots must stay zero, while Carrion must have usable values in every difficulty.
const sourceLists = name => [...remix.matchAll(new RegExp('^\\s+' + name + ' = \\[([^\\]]+)\\]', 'gm'))]
    .map(m => JSON.parse('[' + m[1].replaceAll('null', '0') + ']'));
const sourceStats = {
    HEALTH: sourceLists('botHealthValues'),
    DAMAGE: sourceLists('biteDamages'),
    DURATION: sourceLists('biteDurations'),
    THROTTLE: sourceLists('throttleSpeeds'),
    DEALT: sourceLists('damageDealt'),
};
const groups = [
    ['INSANITY', 0], ['NORMAL', 1], ['HARD', 2], ['LEGENDARY', 3], ['EXPERT', 4],
];
for (const [difficulty, sourceIndex] of groups) {
    const healthGroup = difficulty === 'INSANITY' ? 'INSANITY' : difficulty === 'LEGENDARY' ? 'LEGENDARY' : 'BASE';
    const durationGroup = ['LEGENDARY', 'EXPERT'].includes(difficulty) ? 'BASE' : difficulty;
    for (const [group, kind] of [
        ['BOT_HEALTH_' + healthGroup, 'HEALTH'],
        ['BITE_DAMAGE_' + difficulty, 'DAMAGE'],
        ['BITE_DURATIONS_' + durationGroup, 'DURATION'],
        ['DAMAGE_DEALT_' + difficulty, 'DEALT'],
        ...(difficulty === 'INSANITY' ? [] : [['THROTTLE_SPEEDS_' + difficulty, 'THROTTLE']]),
    ]) {
        const values = table(group);
        assert.equal(values.length, heroes.length, group + ' must reach Carrion');
        assert.equal(values[catIndex], sourceStats[kind][sourceIndex][5], group + ' must match Remix Cat');
    }
    assert(table('BOT_HEALTH_' + healthGroup)[catIndex] > 0);
    assert(table('DAMAGE_DEALT_' + difficulty)[catIndex] > 0, 'Bite recalibration divides by damage dealt');
}
const insanityCount = Number(read('src/subroutines.opy').match(/for insanityThrottleHeroIndex in range\((\d+)\)/)[1]);
assert.equal(insanityCount, heroes.length);
for (const mode of ['ALL_ZOMBIES', 'NEW_BLOOD', 'SHUFFLE', 'DINNER_RUSH', 'HAM_N_HAMMER']) {
    const weights = table('SPAWN_RATES_' + mode);
    assert(Math.abs(weights.reduce((sum, x) => sum + x, 0) - 100) < 1e-8, mode + ': weighted roll needs total 100');
    assert(weights.every(x => x >= 0));
    if (mode === 'ALL_ZOMBIES') {
        assert.equal(weights[catIndex], weights[heroes.indexOf('Hero.REINHARDT')]);
        assert(Math.abs(weights[catIndex] - 300 / 103) < 1e-6);
    } else {
        assert.equal(weights[catIndex] || 0, mode === 'NEW_BLOOD' ? 20 : 0);
    }
}

async function main() {
    const extdir = path.join(process.env.USERPROFILE, '.vscode/extensions');
    const ext = fs.readdirSync(extdir).filter(n => n.startsWith('zezombye.overpy-'))
        .sort((a, b) => b.localeCompare(a, undefined, {numeric: true}))[0];
    const compiler = require(path.join(extdir, ext, 'npm/overpy.js'));
    await compiler.readyPromise;
    const log = console.log;
    let build;
    try {
        console.log = () => {};
        build = await compiler.compile(read('src/includes.opy').replace(/^#!writeToOutputFile.*$/gm, ''),
            'en-US', root.replace(/\\/g, '/') + '/src/', 'includes.opy');
    } finally { console.log = log; }
    assert.deepEqual(build.encounteredWarnings, []);
    const abilities = build.result.match(/rule \("CARRION \(JETPACK CAT\) ABILITIES"\)[\s\S]*?\n}\n/)[0];
    const transport = build.result.match(/rule \("CARRION \(JETPACK CAT\) TRANSPORT"\)[\s\S]*?\n}\n/)[0];
    assert.match(abilities, /Jetpack Cat;/);
    assert.match(abilities, /!= Null/);
    assert.match(transport, /!= Null/);
    assert.match(transport, /Is Hero Being Played\(Hero\(Jetpack Cat\), Team 2\)/);
    assert.match(transport, /== False/);
    assert(!/Loop\(/.test(abilities + transport), 'Remix sequences must not become polling loops');
    if (process.argv.includes('--write')) fs.writeFileSync(path.join(root, 'main.ws.txt'), build.result);
    console.log(JSON.stringify({elements: build.nbElements, warnings: build.encounteredWarnings.length,
        catIndex, difficulties: groups.length, inGameValidated: false}));
}
main().catch(error => {console.error(error); process.exitCode = 1;});
