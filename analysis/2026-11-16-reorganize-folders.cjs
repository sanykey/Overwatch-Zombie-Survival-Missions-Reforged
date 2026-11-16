// One-time migration. Historical Git paths and recorded JSON evidence stay unchanged.
const fs = require('node:fs');
const path = require('node:path');
const cp = require('node:child_process');
const root = path.resolve(__dirname, '..');
const groups = {
    core: ['directives', 'settings', 'variables', 'subroutines', 'global_startup', 'ui_workarounds'],
    game: ['global_game_in_progress', 'players_game_in_progress', 'bots_game_in_progress', 'zombie_types'],
    ui: ['global_start_menu', 'player_start_menu', 'player_camera'],
    abilities: ['enhancements', 'augments', 'apothecary', 'charge_battery', 'dash', 'highrise', 'laser_barricade', 'long_reach', 'player_initialization', 'player_events', 'hero_tuning'],
    items: ['supply_drops', 'power_ups'],
    data: ['compressed numbers'],
    debug: ['debug'],
};
const moves = Object.fromEntries(Object.entries(groups).flatMap(([dir, names]) =>
    names.map(name => [`src/${name}.opy`, `src/${dir}/${name}.opy`])));
Object.assign(moves, {
    'src/build_date.js': 'tools/build_date.js',
    'src/create numbers.js': 'tools/create numbers.js',
    'WORKSHOP_NATIVE_UI_CORRUPTION.md': 'docs/WORKSHOP_NATIVE_UI_CORRUPTION.md',
    'CODE_REVIEW_REPORT.md': 'docs/CODE_REVIEW_REPORT.md',
    'CODE_REVIEW_REPORT.ru.md': 'docs/CODE_REVIEW_REPORT.ru.md',
});
const tracked = cp.execFileSync('git', ['ls-files', '-z'], {cwd: root, encoding: 'utf8'}).split('\0').filter(Boolean);
for (const [old, next] of Object.entries(moves)) {
    if (!fs.existsSync(path.join(root, old))) throw new Error('Already moved or missing: ' + old);
    if (fs.existsSync(path.join(root, next))) throw new Error('Destination exists: ' + next);
}
for (const [old, next] of Object.entries(moves)) {
    fs.mkdirSync(path.dirname(path.join(root, next)), {recursive: true});
    fs.renameSync(path.join(root, old), path.join(root, next));
}
const relative = (from, to) => path.posix.relative(path.posix.dirname(from), to);
for (const old of tracked) {
    const next = moves[old] || old;
    if (!/\.(md|opy|cjs|js)$/.test(next) || next.startsWith('workshop-snapshots/')) continue;
    let text = fs.readFileSync(path.join(root, next), 'utf8');
    const original = text;
    if (next.endsWith('.opy')) {
        text = text.replace(/(#!(?:include|mainFile) ")([^"]+)(")/g, (_, begin, target, end) => {
            const resolved = path.posix.normalize(path.posix.join(path.posix.dirname(old), target));
            return begin + relative(next, moves[resolved] || resolved) + end;
        });
        text = text.replace(/(__script__\(")([^"]+)("\))/g, (_, begin, target, end) => {
            const resolved = path.posix.normalize(path.posix.join(path.posix.dirname(old), target));
            return begin + relative(next, moves[resolved] || resolved) + end;
        });
    }
    if (next.endsWith('.md')) {
        // Resolve links against their old document location before relocating either endpoint.
        text = text.replace(/(\]\()(<[^>]+>|[^)\s]+)(\))/g, (whole, begin, target, end) => {
            const angle = target.startsWith('<');
            const raw = angle ? target.slice(1, -1) : target;
            if (/^(?:[a-z]+:|#|\/)/i.test(raw)) return whole;
            const [file, fragment = ''] = raw.split(/(?=#)/);
            const resolved = path.posix.normalize(path.posix.join(path.posix.dirname(old), file));
            const updated = relative(next, moves[resolved] || resolved) + fragment;
            return begin + (angle ? '<' + updated + '>' : updated) + end;
        });
        // Inline repository paths are rooted at the repository, independent of document location.
        for (const [from, to] of Object.entries(moves)) text = text.replaceAll('`' + from + '`', '`' + to + '`');
    }
    if (/\.(cjs|js)$/.test(next) && next.startsWith('analysis/')) {
        // Exact working-tree path literals only; never rewrite revision:path Git references.
        for (const [from, to] of Object.entries(moves)) {
            for (const quote of ["'", '"', '`']) text = text.replaceAll(quote + from + quote, quote + to + quote);
        }
        // Resolve dynamic legacy filenames used by archived probes through the shared mapping.
        text = text.replace(/path\.join\(src,\s*([^\n]*?)\)/g,
            (_, args) => "require('./source-layout.cjs').sourcePath(" + args + ')');
    }
    // Comments in gameplay files refer to the guide by repository path.
    if (next.endsWith('.opy')) text = text.replaceAll('WORKSHOP_NATIVE_UI_CORRUPTION.md', 'docs/WORKSHOP_NATIVE_UI_CORRUPTION.md');
    if (text !== original) fs.writeFileSync(path.join(root, next), text);
}
fs.writeFileSync(path.join(__dirname, '2026-11-16-folder-layout-moves.json'), JSON.stringify(moves, null, 2) + '\n');
console.log('Moved ' + Object.keys(moves).length + ' files.');
