const fs = require('fs');
const path = require('path');
const compiler = require(path.join(process.env.USERPROFILE, '.vscode/extensions/zezombye.overpy-9.7.21/npm/overpy.js'));

(async () => {
    await compiler.readyPromise;
    const stage = process.argv[2] || 'before';
    const result = await compiler.compile(fs.readFileSync('src/includes.opy', 'utf8'), 'en-US', path.resolve('src').replace(/\\/g, '/') + '/', 'includes.opy');
    const summary = { elements: result.nbElements, warnings: result.encounteredWarnings };
    fs.writeFileSync(`analysis/2026-11-17-engineer-${stage}.json`, JSON.stringify(summary, null, 2));
    fs.writeFileSync(`analysis/2026-11-17-engineer-${stage}.ws.txt`, result.result);
    if (stage === 'after') fs.writeFileSync('main.ws.txt', result.result);
    console.log(JSON.stringify(summary));
})().catch(error => { console.error(error); process.exitCode = 1; });
