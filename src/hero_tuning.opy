#!mainFile "../main.opy"

# Shared pickup effect, declared here before hero tuning uses it.
subroutine superNano


rule "ANA SELF SUPER NANO":
    @Event eachPlayer
    @Team 1
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() >= 100

    # Give native ally Nano priority. Ignore button release so a quick tap works.
    wait(0.128)
    # Revalidate after the wait. Never spend charge while casting or incapacitated.
    if [
        eventPlayer.isDead(),
        eventPlayer.isUsingUltimate(),
        eventPlayer.isUsingAbility1(),
        eventPlayer.isUsingAbility2(),
        eventPlayer.hasStatus(Status.HACKED),
        eventPlayer.isCrowdControlled,
    ].any():
        return
    # Retain the donor's approximate 41m/10-degree ally check for pending target
    # confirmation. Scan only on a charged ultimate press, not continuously.
    if getPlayersInRadius(eventPlayer, 41, Team.1, LosCheck.SURFACES).any(lambda player: player != eventPlayer and player.isAlive() and eventPlayer.isInViewAngle(player, 10)):
        return
    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false)
    # Same refresh/cleanup behavior as the pickup; leave inventory untouched.
    startRule(superNano)
    # Let the asynchronous effect initialize before checking its entity ID.
    wait()
    # Clear charge on death or effect cleanup, capped at the shared duration.
    waitUntil(eventPlayer.isDead() or eventPlayer.powerUpSuperNanoGoodAuraId == 0, SUPER_NANO_DURATION)
    eventPlayer.setUltEnabled(true)

rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isCrowdControlCooldownActive == true
    
    wait(8)
    eventPlayer.stopFacing()
    eventPlayer.isCrowdControlCooldownActive = false
    if ruleCondition:
        loop()


rule "SOMBRA USES TRANSLOCATOR":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    
    eventPlayer.invisibilityCount++
    waitUntil(eventPlayer.isUsingUltimate() or [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.MELEE].any(lambda x: eventPlayer.isHoldingButton(x) and not eventPlayer.getAbilityCooldown(x)), 6.5)
    eventPlayer.invisibilityCount--


rule "DOOMFIST INVIS WHILE ULTING":
    @Event eachPlayer
    @Team 1
    @Hero doomfist
    @Condition isGameplayActive == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.invisibilityCount++
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.invisibilityCount--


rule "MOIRA & VENTURE INVIS WHILE USING SKILL":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getHero() in [Hero.MOIRA, Hero.VENTURE] == true
    
    eventPlayer.invisibilityCount++
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.invisibilityCount--


rule "TRACER INVIS WHILE RECALLING":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition isGameplayActive == true
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.invisibilityCount++
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.invisibilityCount--


def applyDamageDealtModifier():
    @Name "applyDamageDealtModifier"
    # The only Team 1 Set Damage Dealt writers are the Soldier ultimate and the
    # HIGHRISE airborne bonus. Recompute their product at every state edge so
    # the multipliers stack instead of overwriting each other. Native damage
    # boosts and supplemental scripted damage apply on top of this multiplier.
    eventPlayer.setDamageDealt(100 * (1.5 if eventPlayer.getHero() == Hero.SOLDIER and eventPlayer.isUsingUltimate() else 1) * (1 + HIGHRISE_DAMAGE_BONUS / 100 if eventPlayer.augmentId == Augment.HIGHRISE and eventPlayer.isAlive() and eventPlayer.augmentJumpDamageActive == true else 1))


rule "SOLDIER TACTICAL VISOR DAMAGE BONUS":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() == true

    applyDamageDealtModifier()
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.getHero() != Hero.SOLDIER, Math.INFINITY)
    applyDamageDealtModifier()


def applyDamageReceivedModifier():
    @Name "applyDamageReceivedModifier"
    # The only Team 1 Set Damage Received writers are the Dash protection
    # window, the Super Nano power-up and the ultimate resist. Every state
    # edge calls this recompute; the strongest (lowest) intake wins and the
    # resists never stack. SWARM SHOOTOUT lowers intake through Start Damage
    # Modification, which multiplies on top and stays outside this recompute.
    eventPlayer.setDamageReceived(0 if eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null else 50 if eventPlayer.powerUpSuperNanoGoodAuraId != 0 or eventPlayer.isUsingUltimate() else 100)
    # Materialize the gate states for cheap readers (same edge coverage as the
    # intake above: ultimate start/end, Dash activation/fade, death, Nano
    # start/cleanup — the Nano edges rewrite them with unchanged values).
    # isDotProtected: the bite, rocket, Molten Core, gas and explosion rules
    # read it instead of re-evaluating the predicate per damage event.
    # hasDamageResist: the health-HUD `*` (any active resist from here).
    eventPlayer.isDotProtected = eventPlayer.isUsingUltimate() or (eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null)
    eventPlayer.hasDamageResist = (eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null) or eventPlayer.powerUpSuperNanoGoodAuraId != 0 or eventPlayer.isUsingUltimate()


rule "PLAYER ULTIMATE DAMAGE RESIST":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isUsingUltimate() == true

    applyDamageReceivedModifier()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    applyDamageReceivedModifier()


rule "SIERRA TRACKING SHOT HACK":
    @Event playerDealtDamage
    @Team 1
    @Hero sierra
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.getTeam() == Team.2

    # Match Tracking Shot's base mark duration from impact. No waits: every hit
    # can apply/refresh Hack, including when another source already hacked it.
    victim.setStatusEffect(attacker, Status.HACKED, 3)


rule "REINHARDT SHIELD SLAM STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition victim != attacker

    # Shield-active damage is sufficient; no perk or event-ability check.
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)


rule "BRIGITTE SHIELD BASH STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition victim != attacker

    # Shield Bash reports Primary Fire while Barrier Shield is active.
    # The ability filter excludes scripted damage and Whip Shot.
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)


rule "CASSIDY FLASHBANG STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != attacker
    
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
