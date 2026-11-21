#!mainFile "../../main.opy"

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
    # Cache the DoT gate for the bite, rocket, Molten Core, gas and explosion rules.
    eventPlayer.isDotProtected = eventPlayer.isUsingUltimate() or (eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null)
    eventPlayer.setDamageReceived(0 if eventPlayer.augmentId == Augment.DASH and eventPlayer.augmentDashSmokeEntity != null else 50 if eventPlayer.isDotProtected or eventPlayer.powerUpSuperNanoGoodAuraId != 0 else 100)


rule "PLAYER ULTIMATE DAMAGE RESIST":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isUsingUltimate() == true

    applyDamageReceivedModifier()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    applyDamageReceivedModifier()


rule "REINHARDT SHIELD SLAM STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero reinhardt

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.isFiringSecondaryFire() == true) and (victim != attacker):
        # Shield-active damage is sufficient; no perk or event-ability check.
        victim.setStatusEffect(attacker, Status.STUNNED, 0.6)


rule "DMON SHIELD DOWN":
    @Event eachPlayer
    @Hero dmon
    @Team 1
    @Condition not eventPlayer.isFiringSecondaryFire()
    eventPlayer.dmonShieldDownTime = getTotalTimeElapsed()

rule "BRIGITTE AND DMON SHIELD STRIKE STUN":
    @Event playerDealtDamage
    @Team 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim != attacker

    # Surging Strike hits just after Power Barrier drops; Shield Bash keeps it active.
    # The ability filter excludes scripted damage and other abilities.
    # Keep hero eligibility synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if eventPlayer.getHero() == Hero.DMON and getTotalTimeElapsed() - eventPlayer.dmonShieldDownTime < 0.3:
        victim.setStatusEffect(attacker, Status.STUNNED, 0.6)
    elif eventPlayer.getHero() == Hero.BRIGITTE and eventPlayer.isFiringSecondaryFire() == true:
        victim.setStatusEffect(attacker, Status.STUNNED, 0.8)


rule "CASSIDY FLASHBANG STUN":
    @Event playerDealtDamage
    @Team 1
    @Hero cassidy

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventAbility == Button.ABILITY_2) and (victim != attacker):
        victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
