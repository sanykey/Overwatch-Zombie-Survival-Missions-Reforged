// One-time source transformation: preserve both original action bodies verbatim.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const target = path.resolve(__dirname, '../src/augments.opy');
const source = fs.readFileSync(target, 'utf8').replace(/\r\n/g, '\n');
function rule(name) {
    const start = source.indexOf('rule "' + name + '":');
    assert(start >= 0, name + ' must exist');
    const next = source.slice(start + 1).search(/\n(?:rule |def )/);
    return source.slice(start, next < 0 ? undefined : start + 1 + next).trimEnd();
}
const teleport = rule('APOTHECARY TELEPORT');
const barrier = rule('LASER BARRICADE (PLACEMENT)');
const indentBody = r => r.slice(r.indexOf('\n\n') + 2).split('\n').map(l => l ? '    ' + l : l).join('\n');
const combined = `rule "CROUCH + INTERACT (APOTHECARY TELEPORT / LASER BARRICADE)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.enhancementId != Enhancement.WRESTLER or eventPlayer.enhancementCarryState == WrestlerCarryState.NONE) == true
    # State slots have different owners for each augment. Guard by augmentId:
    # Apothecary readiness is boolean; Barricade's shared slot is a vector.
    @Condition ((eventPlayer.augmentId == Augment.APOTHECARY and eventPlayer.augmentApothecaryReady == true and (eventPlayer.augmentApothecaryPosition != null or healthpackPositionList != [])) or (eventPlayer.augmentId == Augment.LASER_BARRICADE and eventPlayer.augmentBarrierPlacementCooldown == 0)) == true

    if eventPlayer.augmentId == Augment.APOTHECARY:
${indentBody(teleport)}
    else:
${indentBody(barrier)}
`;
const updated = source.replace(teleport, combined.trimEnd()).replace(barrier + '\n\n\n', '');
assert(!updated.includes('rule "LASER BARRICADE (PLACEMENT)":'));
assert(!updated.includes('rule "APOTHECARY TELEPORT":'));
fs.writeFileSync(target, updated);
