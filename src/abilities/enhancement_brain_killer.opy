#!mainFile "../../main.opy"


macro applyBrainKillerCritMacro():
    # Damage applies the intake modifier again. Use the crit amount before Auspex.
    damage(victim, eventPlayer,
        eventDamage * (1 - (victim.botAuspexBonusFraction if victim.botAuspexExpiry > 0 else 0))
        * (BRAIN_KILLER_BOSS_CRIT_BONUS_PCT / 100 if victim in bossStateList else BRAIN_KILLER_CRIT_BONUS_PCT / 100))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
