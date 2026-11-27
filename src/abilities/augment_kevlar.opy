#!mainFile "../../main.opy"

macro initializeKevlarAugment():
    # Reapply on each life. Dash is a different augment, so its temporary
    # knockback immunity and cleanup never overwrite a Kevlar player's resist.
    eventPlayer.setKnockbackReceived(100 - AUGMENT_KEVLAR_KNOCKBACK_RESIST)
    eventPlayer.addHealthPool(Health.ARMOR, AUGMENT_KEVLAR_ARMOR, true, false)


rule "KEVLAR RANGED DAMAGE COMPENSATION":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.augmentId == Augment.KEVLAR
    @Condition eventPlayer.isAlive() == true
    @Condition eventDamage > 0
    @Condition attacker != null
    @Condition attacker.getTeam() == Team.2

    # Refund half of the damage actually taken instead of a Set Damage Received
    # resist, so melee hits stay full-damage without proximity guesswork.
    # Scripted damage() has no ability (boss specials, DoT) and stays untouched.
    # Quick melee, zombie bites included, registers as Button.MELEE.
    if eventAbility in [null, Button.MELEE]:
        return

    # Native melee weapons pierce the compensation: they read as full damage
    # while their swing state is still active at the moment of impact.
    if attacker.getHero() == Hero.REINHARDT:
        if attacker.isFiringPrimaryFire():
            return
    elif attacker.getHero() == Hero.JUNKER_QUEEN:
        if attacker.isFiringSecondaryFire():
            return
    # elif attacker.getHero() == Hero.BRIGITTE:
    #     if attacker.isFiringPrimaryFire() or attacker.isMeleeing():
    #         return
    # elif attacker.getHero() == Hero.VENDETTA:
    #     if attacker.isFiringPrimaryFire():
    #         return
    # elif attacker.getHero() == Hero.TORBJORN:
    #     if attacker.getCurrentWeapon() == 2 and (attacker.isFiringPrimaryFire() or attacker.isMeleeing()):
    #         return

    heal(eventPlayer, null, eventDamage * (1 - AUGMENT_KEVLAR_RANGED_DMG_RESIST / 100))
