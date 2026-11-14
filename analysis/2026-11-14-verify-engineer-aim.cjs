// Compare the current aim cone with the previous one in the same working tree.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const {files, compile, compiler} = require('./measure-further-optimizations.cjs');

(async () => {
    await compiler.readyPromise;
    const baseline = {...files, 'variables.opy': files['variables.opy'].replace(
        '#!define ENGINEER_TRANSFER_ANGLE 60', '#!define ENGINEER_TRANSFER_ANGLE 10')};
    assert.notEqual(baseline['variables.opy'], files['variables.opy']);
    const before = await compile(baseline);
    const after = await compile(files);
    assert.deepEqual(before.warnings, []);
    assert.deepEqual(after.warnings, []);
    // The entire compiled game differs only by the aim-angle literal.
    const start = before.result.indexOf('rule ("ENGINEER ARMOR TRANSFER")');
    assert(start >= 0);
    const head = before.result.slice(0, start);
    const tail = before.result.slice(start);
    assert.match(tail, /Is In View Angle\([^\n]*, 10\)/);
    assert.equal(after.result === head + tail.replace(
        /Is In View Angle\(([^\n]*), 10\)/, 'Is In View Angle($1, 60)'), true,
        'Only the Engineer aim-angle literal may change');
    assert.equal(before.elements, after.elements);
    fs.writeFileSync(path.join(__dirname, '..', 'main.ws.txt'), after.result);
    const report = {beforeElements: before.elements, afterElements: after.elements,
        deltaElements: after.elements - before.elements, addedVariables: 0,
        warnings: after.warnings, nativeGameplayVerified: false};
    fs.writeFileSync(path.join(__dirname, '2026-11-14-engineer-aim-validation.json'),
        JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report, null, 2));
})().catch(e => {console.error(e); process.exitCode = 1;});
