#!mainFile "../../main.opy"

# Owned rules and inline fragments; shared storage contracts stay in variables.opy.

#!define APOTHECARY_AUGMENT_ULT_CHARGE 7

macro useApothecaryAugmentTeleportMacro():
    # Called synchronously on the Crouch + Jump input edge after charge validation.
    eventPlayer.augmentApothecaryReady = false
    # Play Effect snapshots departure before Teleport; no scratch or effect entity.
    # Bolt Strike's 1.5 flash scaled by three.
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 4.5)
    # Choose only when teleporting; keep the saved point reserved for actual pickups.
    eventPlayer.teleport(eventPlayer.augmentApothecaryPosition if eventPlayer.augmentApothecaryPosition != null else random.choice(healthpackPositionList))

macro rechargeApothecaryAugmentFromDamageMacro():
    # Positive, non-self ultimate damage only; activation alone gives no charge.
    eventPlayer.augmentApothecaryReady = true

macro cureApothecaryAugmentInfectionMacro():
    # Cure one third, at least 1: healing/ult/teleport remain personal bonuses.
    # Clamp to zero without granting vaccine; keep Hybrid's infection intact.
    if eventPlayer.infectionLevel > 0 and eventPlayer.enhancementId != Enhancement.ZOMBIE_HYBRID:
        eventPlayer.infectionLevel = max(0, eventPlayer.infectionLevel - max(1, eventPlayer.infectionLevel / 3))

macro pickUpApothecaryAugmentHealthPackMacro():
    # Only reduce existing infection; never create or increase vaccine reserves.
    # Scripted healing is not a health-pack event, so this cannot recurse.
    # Synchronous scratch: consumed immediately after Heal, with no waits/calls.
    # No healer is attributed, so no dealt-healing handler can overwrite this slot.
    #!define apothecaryHealthBefore tmp0
    apothecaryHealthBefore = eventPlayer.getHealth()
    heal(eventPlayer, null, eventHealing)
    if isGameplayActive and eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        eventPlayer.enhancementCapacitorEnergy += max(0, eventPlayer.getHealth() - apothecaryHealthBefore) / 3
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + APOTHECARY_AUGMENT_ULT_CHARGE)
    eventPlayer.augmentApothecaryPosition = eventPlayer.getPosition()

rule "[APOTHECARY AUGMENT] CURE ICON":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.augmentId == Augment.APOTHECARY)
    @Condition eventPlayer.augmentApothecaryPosition != null

    # One icon per owner, kept on that player's entity budget. Moving the saved
    # teleport point moves the same icon; death/hero changes leave it intact.
    # No alive/charge guard: a spent teleport or dead owner still has a point.
    createIcon(getPlayers(Team.1).filter(lambda player: isGameplayActive and not healthpacksCureNormally and player.isInfected and player.enhancementId != Enhancement.ZOMBIE_HYBRID), eventPlayer.augmentApothecaryPosition + offsetUpThreeQuartersConst + offsetUpHalfConst, Icon.POISON, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN)
    eventPlayer.augmentApothecaryCureIcon = getLastCreatedEntity()


rule "[APOTHECARY AUGMENT] CURE ICON DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; docs/WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.augmentId == Augment.APOTHECARY) and (eventPlayer.augmentApothecaryCureIcon != null):
        destroyIcon(eventPlayer.augmentApothecaryCureIcon)
