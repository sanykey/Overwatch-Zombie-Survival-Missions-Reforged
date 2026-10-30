#!mainFile "main.opy"

rule "============================================== HERO TUNING ====================================================":
    @Disabled
    @Delimiter


rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.specialCooldown == true
    
    wait(8)
    eventPlayer.stopFacing()
    eventPlayer.specialCooldown = false
    if ruleCondition:
        loop()


rule "SOMBRA USES TRANSLOCATOR":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.invisible++
    waitUntil(eventPlayer.isUsingUltimate() or [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.MELEE].any(lambda x: eventPlayer.isHoldingButton(x) and eventPlayer.getAbilityCooldown(x) == 0), 6.5)
    eventPlayer.invisible--


rule "DOOMFIST INVIS WHILE ULTING":
    @Event eachPlayer
    @Team 1
    @Hero doomfist
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.invisible--


rule "MOIRA & VENTURE INVIS WHILE USING SKILL":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getHero() in [Hero.MOIRA, Hero.VENTURE] == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.invisible--


rule "TRACER INVIS WHILE RECALLING":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition gameStatus == true
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.invisible++
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.invisible--


rule "CASSIDY GRENADE HACK":
    @Event playerDealtDamage
    @Team 1
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.hasStatus(Status.HACKED) == false
    @Condition victim != attacker
    
    victim.setStatusEffect(attacker, Status.HACKED, 1)
