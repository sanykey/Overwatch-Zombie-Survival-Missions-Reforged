// One-time, exact-source extraction. Keeps action order, waits and reevaluation expressions.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const src = path.resolve(__dirname, '../src');
const read = name => fs.readFileSync(path.join(src, name), 'utf8').replace(/\r\n/g, '\n');
const files = Object.fromEntries(['augments.opy', 'variables.opy', 'includes.opy', 'player_events.opy', 'players_game_in_progress.opy', 'player_initialization.opy'].map(n => [n, read(n)]));
function block(source, startText, endText) {
    const start = source.indexOf(startText);
    assert(start >= 0, startText);
    const end = endText ? source.indexOf(endText, start + startText.length) : source.length;
    assert(end >= start, endText);
    return source.slice(start, end).trimEnd();
}
function rule(source, name) {
    const start = source.indexOf('rule "' + name + '":');
    assert(start >= 0, name);
    const next = source.slice(start + 1).search(/\n(?:rule |def |macro )/);
    return source.slice(start, next < 0 ? undefined : start + 1 + next).trimEnd();
}
const remove = (source, text) => source.includes(text + '\n\n\n') ? source.replace(text + '\n\n\n', '') : source.replace(text, '');
const dedent = text => text.split('\n').map(l => l.startsWith('    ') ? l.slice(4) : l).join('\n');
const body = r => r.slice(r.indexOf('\n\n') + 2);
const macro = (name, contents) => 'macro ' + name + '():\n' + contents + '\n';
let augments = files['augments.opy'];
const apothecaryRules = ['APOTHECARY CURE ICON', 'APOTHECARY CURE ICON DISCONNECT CLEANUP', 'APOTHECARY ULTIMATE RECHARGE'].map(n => rule(augments, n));
const barrierRule = rule(augments, 'LASER BARRICADE BLOCKS ZOMBIES');
for (const r of [...apothecaryRules, barrierRule]) augments = remove(augments, r);
const shared = rule(augments, 'CROUCH + INTERACT (APOTHECARY TELEPORT / LASER BARRICADE)');
const teleportBody = block(shared, '        # Keep both buttons held', '\n    else:');
const placementBody = block(shared, '        # -1 latches aiming');
augments = augments.replace(teleportBody, '        useApothecaryAugmentTeleportMacro()').replace(placementBody, '        placeLaserBarricadeAugmentMacro()');
const ready = shared.split('\n').find(l => l.startsWith('    @Condition ((eventPlayer.augmentId'));
const apothecaryReady = 'eventPlayer.augmentId == Augment.APOTHECARY and eventPlayer.augmentApothecaryReady == true and (eventPlayer.augmentApothecaryPosition != null or healthpackPositionList != [])';
const barrierReady = 'eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown == 0';
assert(ready.includes(apothecaryReady) && ready.includes(barrierReady));
augments = augments.replace(ready, '    @Condition (APOTHECARY_AUGMENT_TELEPORT_READY or LASER_BARRICADE_AUGMENT_PLACEMENT_READY) == true');
const menuDescription = prefix => augments.split('\n').find(l => l.trimStart().startsWith(prefix)).trim().replace(/,$/, '');
const apothecaryMenu = menuDescription('f"Packs:');
const barrierMenu = menuDescription('f"Deploy a wall');
augments = augments.replace(apothecaryMenu, 'APOTHECARY_AUGMENT_MENU_DESCRIPTION').replace(barrierMenu, 'LASER_BARRICADE_AUGMENT_MENU_DESCRIPTION');
let init = files['player_initialization.opy'];
const visuals = block(init, '        #Augment: Laser Barricade', '\n    # HUD lives in AUGMENT HUD');
init = init.replace(visuals, '        initializeLaserBarricadeAugmentMacro()');
const barrierHud = block(init, '        "{0}{1}".format(f"Hold', ' if localPlayer.augmentId == Augment.LASER_BARRICADE else').trim();
init = init.replace(barrierHud, 'LASER_BARRICADE_AUGMENT_HUD_DESCRIPTION');
const apothecaryHudStart = '(f"Hold [{inputBindingString(Button.CROUCH)}]+[{inputBindingString(Button.INTERACT)}]: teleport';
const apothecaryHud = block(init, apothecaryHudStart, ' if localPlayer.augmentId == Augment.APOTHECARY else');
init = init.replace(apothecaryHud, 'APOTHECARY_AUGMENT_HUD_DESCRIPTION');
const barrierColor = '(Color.RED if localPlayer.augmentBarrierPlacementCooldown > 0 else Color.GREEN)';
const apothecaryColor = 'Color.GREEN if localPlayer.augmentId == Augment.APOTHECARY and localPlayer.augmentApothecaryReady == true else Color.WHITE';
assert(init.includes(barrierColor) && init.includes(apothecaryColor));
init = init.replace(barrierColor, 'LASER_BARRICADE_AUGMENT_HUD_COLOR').replace(apothecaryColor, 'APOTHECARY_AUGMENT_HUD_COLOR');
let events = files['player_events.opy'];
const damageCondition = 'eventPlayer.augmentId == Augment.APOTHECARY and eventAbility == Button.ULTIMATE and eventPlayer.getHero() in [Hero.DVA, Hero.DMON]';
const damageBody = '        # Positive, non-self ultimate damage only; activation alone gives no charge.\n        eventPlayer.augmentApothecaryReady = true';
assert(events.includes(damageCondition) && events.includes(damageBody));
events = events.replace(damageCondition, 'APOTHECARY_AUGMENT_ULTIMATE_DAMAGE').replace(damageBody, '        rechargeApothecaryAugmentFromDamageMacro()');
const packRule = rule(files['players_game_in_progress.opy'], 'PLAYER PICKS UP HEALTH PACK');
let pack = packRule;
const packCureCondition = 'eventPlayer.augmentId == Augment.APOTHECARY or getPlayers(Team.1).any(lambda owner: owner.augmentId == Augment.APOTHECARY and owner.augmentApothecaryPosition != null and distance(owner.augmentApothecaryPosition, eventPlayer) <= 5)';
const cureBody = block(pack, '        # Cure one third', '\n    elif eventPlayer.isInfected:');
const healingBody = block(pack, '        # Only reduce existing infection');
assert(pack.includes(packCureCondition));
pack = pack.replace(packCureCondition, 'APOTHECARY_AUGMENT_PACK_CURES').replace(cureBody, '        cureApothecaryAugmentInfectionMacro()').replace(healingBody, '        pickUpApothecaryAugmentHealthPackMacro()');
events += '\n\n' + pack + '\n';
files['players_game_in_progress.opy'] = remove(files['players_game_in_progress.opy'], packRule);
files['player_events.opy'] = events;
files['player_initialization.opy'] = init;
files['augments.opy'] = augments;
const header = '#!mainFile "../main.opy"\n\n# Owned rules and inline fragments; shared storage contracts stay in variables.opy.\n\n';
files['apothecary.opy'] = header
    + '#!define APOTHECARY_AUGMENT_ULT_CHARGE 7\n'
    + '#!define APOTHECARY_AUGMENT_TELEPORT_READY (' + apothecaryReady + ')\n'
    + '#!define APOTHECARY_AUGMENT_ULTIMATE_DAMAGE (' + damageCondition + ')\n'
    + '#!define APOTHECARY_AUGMENT_PACK_CURES (' + packCureCondition + ')\n'
    + '#!define APOTHECARY_AUGMENT_MENU_DESCRIPTION (' + apothecaryMenu + ')\n'
    + '#!define APOTHECARY_AUGMENT_HUD_DESCRIPTION ' + apothecaryHud + '\n'
    + '#!define APOTHECARY_AUGMENT_HUD_COLOR (' + apothecaryColor + ')\n\n'
    + macro('useApothecaryAugmentTeleportMacro', dedent(teleportBody)) + '\n'
    + macro('rechargeApothecaryAugmentFromDamageMacro', dedent(damageBody)) + '\n'
    + macro('cureApothecaryAugmentInfectionMacro', dedent(cureBody)) + '\n'
    + macro('pickUpApothecaryAugmentHealthPackMacro', dedent(healingBody)) + '\n'
    + apothecaryRules.map(r => r.replace('rule "APOTHECARY ', 'rule "[APOTHECARY AUGMENT] ')).join('\n\n\n') + '\n';
files['laser_barricade.opy'] = header
    + '#!define LASER_BARRICADE_AUGMENT_HEIGHT 2\n'
    + '#!define LASER_BARRICADE_AUGMENT_WIDTH 5\n'
    + '#!define LASER_BARRICADE_AUGMENT_COOLDOWN 25\n'
    + '#!define LASER_BARRICADE_AUGMENT_PLACEMENT_READY (' + barrierReady + ')\n'
    + '#!define LASER_BARRICADE_AUGMENT_MENU_DESCRIPTION (' + barrierMenu + ')\n'
    + '#!define LASER_BARRICADE_AUGMENT_HUD_DESCRIPTION (' + barrierHud + ')\n'
    + '#!define LASER_BARRICADE_AUGMENT_HUD_COLOR ' + barrierColor + '\n\n'
    + macro('placeLaserBarricadeAugmentMacro', dedent(placementBody)) + '\n'
    + macro('initializeLaserBarricadeAugmentMacro', dedent(visuals)) + '\n'
    + barrierRule.replace('rule "LASER BARRICADE ', 'rule "[LASER_BARRICADE AUGMENT] ') + '\n';
files['variables.opy'] = files['variables.opy'].replace(/^#!define AUGMENT_APOTHECARY_ULT_CHARGE 7\n/m, '').replace(/^#!define LASER_BARRICADE_(HEIGHT 2|WIDTH 5|COOLDOWN 25)\n/gm, '');
files['includes.opy'] = files['includes.opy'].replace('#!include "augments.opy"', '#!include "apothecary.opy"\n#!include "laser_barricade.opy"\n#!include "augments.opy"');
const names = {'AUGMENT_APOTHECARY_ULT_CHARGE': 'APOTHECARY_AUGMENT_ULT_CHARGE', 'LASER_BARRICADE_HEIGHT': 'LASER_BARRICADE_AUGMENT_HEIGHT', 'LASER_BARRICADE_WIDTH': 'LASER_BARRICADE_AUGMENT_WIDTH', 'LASER_BARRICADE_COOLDOWN': 'LASER_BARRICADE_AUGMENT_COOLDOWN'};
for (const [name, contents] of Object.entries(files)) {
    let updated = contents;
    for (const [oldName, newName] of Object.entries(names)) updated = updated.replaceAll(oldName, newName);
    fs.writeFileSync(path.join(src, name), updated);
}
