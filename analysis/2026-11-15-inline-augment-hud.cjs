const fs = require('node:fs');
const path = require('node:path');
const src = path.resolve(__dirname, '../src');
const read = name => fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n');
let hud = read('player_initialization.opy');
let menu = read('augments.opy');
for (const name of ['apothecary.opy', 'laser_barricade.opy']) {
    const text = read(name).replace(/^#!define ((?:APOTHECARY|LASER_BARRICADE)_AUGMENT_(?:HUD_DESCRIPTION|HUD_COLOR|MENU_DESCRIPTION)) (.*)\n/gm, (_, alias, value) => {
        const keepParens = alias === 'APOTHECARY_AUGMENT_HUD_DESCRIPTION' || alias === 'LASER_BARRICADE_AUGMENT_HUD_COLOR';
        const expression = keepParens ? value : value.slice(1, -1);
        hud = hud.replaceAll(alias, expression);
        menu = menu.replaceAll(alias, expression);
        return '';
    });
    fs.writeFileSync(path.join(src, name), text);
}
fs.writeFileSync(path.join(src, 'player_initialization.opy'), hud);
fs.writeFileSync(path.join(src, 'augments.opy'), menu);
