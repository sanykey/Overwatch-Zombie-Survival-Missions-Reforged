// Run: node analysis/measure-zsmm-elements.cjs [--lordy | --chaos] [path/to/overpy.js]
// Compiles two decompiled Workshop snapshots in memory; never modifies their source.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');

function findCompiler() {
    const extensions = path.join(process.env.USERPROFILE, '.vscode', 'extensions');
    const versions = fs.readdirSync(extensions)
        .filter(name => name.startsWith('zezombye.overpy-'))
        .sort((a, b) => b.localeCompare(a, undefined, { numeric: true }));
    for (const version of versions) {
        const candidate = path.join(extensions, version, 'npm', 'overpy.js');
        if (fs.existsSync(candidate)) return candidate;
    }
    throw new Error('Pass the path to an installed OverPy npm/overpy.js as the first argument.');
}

async function main() {
    const args = process.argv.slice(2);
    const compareLordy = args.includes('--lordy');
    const compareChaos = args.includes('--chaos');
    if (compareLordy && compareChaos) throw new Error('Choose one comparison preset.');
    const compilerPath = path.resolve(args.find(arg => !arg.startsWith('--')) || findCompiler());
    const compilerVersion = JSON.parse(fs.readFileSync(path.join(path.dirname(compilerPath), 'package.json'), 'utf8')).version;
    const compiler = require(compilerPath);
    await compiler.readyPromise;
    const workspace = path.resolve(__dirname, '..');
    const inputs = [
        ['786TW', 'workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy'],
        compareChaos
            ? ['A3YV07', 'workshop-snapshots/ZSM Chaos (A3YV07)/2026-10-30 ZSM Chaos (A3YV07).opy']
            : compareLordy
                ? ['KT6ZY', "workshop-snapshots/Lordy's ZSM (KT6ZY)/2026-10-30 Lordy's ZSM (KT6ZY).opy"]
                : ['QZD5F', 'workshop-snapshots/ZSMM-remixed (QZD5F)/2026-10-30 ZSMM-remixed (QZD5F).opy'],
    ];
    const output = { compilerVersion, compilerPath, method: 'Compile OPY with original directives plus debugElementCount; counts include disabled rules.', versions: [] };
    const savedConsole = { log: console.log, warn: console.warn, error: console.error };
    try {
        console.log = console.warn = console.error = () => {};
        for (const [id, relativePath] of inputs) {
            const absolutePath = path.join(workspace, relativePath);
            const source = fs.readFileSync(absolutePath, 'utf8');
            const result = await compiler.compile(
                '#!debugElementCount\n' + source,
                'en-US',
                path.dirname(absolutePath).replace(/\\/g, '/') + '/',
                path.basename(absolutePath),
            );
            const header = result.result.slice(0, result.result.indexOf('*/'));
            const ruleCounts = [...header.matchAll(/^\s*(\d+): rule "(.*)" \(/gm)]
                .map(match => ({ name: match[2], elements: Number(match[1]) }));
            output.versions.push({
                id, relativePath,
                sourceSha256: crypto.createHash('sha256').update(source).digest('hex'),
                directives: source.match(/^#!.*$/gm) || [],
                elements: result.nbElements,
                warnings: result.encounteredWarnings.length,
                // Debug summary omits rules of size 1, including empty separators.
                elementsNotListedIndividually: result.nbElements - ruleCounts.reduce((sum, row) => sum + row.elements, 0),
                ruleCounts,
            });
        }
    } finally {
        Object.assign(console, savedConsole);
    }
    const [original, remix] = output.versions;
    const names = new Set([...original.ruleCounts, ...remix.ruleCounts].map(row => row.name));
    output.differencesByName = [...names].map(name => {
        const sum = version => version.ruleCounts.filter(row => row.name === name).reduce((n, row) => n + row.elements, 0);
        const before = sum(original), after = sum(remix);
        return { name, original: before, remix: after, delta: after - before };
    }).filter(row => row.delta).sort((a, b) => a.delta - b.delta);
    output.delta = remix.elements - original.elements;
    const outputStem = compareChaos ? 'Chaos-elements' : compareLordy ? 'Lordy-elements' : 'ZSMM-elements';
    const jsonPath = path.join(__dirname, outputStem + '.json');
    fs.writeFileSync(jsonPath, JSON.stringify(output, null, 2) + '\n', 'utf8');
    const csv = ['rule,original,remix,delta', ...output.differencesByName.map(row =>
        '"' + row.name.replace(/"/g, '""') + '",' + [row.original, row.remix, row.delta].join(','))];
    fs.writeFileSync(path.join(__dirname, outputStem + '-by-rule.csv'), '\uFEFF' + csv.join('\r\n') + '\r\n', 'utf8');
    console.log(JSON.stringify({ compilerVersion, counts: output.versions.map(({ id, elements, warnings }) => ({ id, elements, warnings })), delta: output.delta, jsonPath }, null, 2));
}

main().catch(error => { console.error(error.message); process.exitCode = 1; });
