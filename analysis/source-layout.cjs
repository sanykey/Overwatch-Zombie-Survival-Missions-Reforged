// Dated probes retain their logical filenames and historical Git paths.
// Only working-tree I/O is mapped to the current physical layout.
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const moves = require('./2026-11-16-folder-layout-moves.json');
function sourcePath(...parts) {
    const old = path.posix.normalize(path.posix.join('src', ...parts));
    return path.join(root, moves[old] || old);
}
function logicalName(name) {
    const old = Object.keys(moves).find(key => moves[key] === 'src/' + name);
    return old ? old.slice(4) : name;
}
function probeSource(text) {
    // Probes flatten includes into a string compiled relative to src/.
    return text.replace(/(#!include ")([^"]+)(")/g,
        (_, begin, name, end) => begin + logicalName(name) + end)
        .replace(/__script__\("(?:\.\.\/)+tools\//g, '__script__("../tools/');
}
function readLegacyTree({normalize = true} = {}) {
    const files = {};
    function walk(dir, prefix = '') {
        for (const entry of fs.readdirSync(dir, {withFileTypes: true})) {
            const name = prefix + entry.name;
            if (entry.isDirectory()) walk(path.join(dir, entry.name), name + '/');
            else if (entry.name.endsWith('.opy')) {
                const text = fs.readFileSync(path.join(dir, entry.name), 'utf8');
                files[logicalName(name)] = normalize ? probeSource(text.replace(/\r\n/g, '\n')) : text;
            }
        }
    }
    walk(path.join(root, 'src'));
    return files;
}
module.exports = {sourcePath, logicalName, probeSource, readLegacyTree};
