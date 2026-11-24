#!mainFile "../../main.opy"


macro applyBrainKillerCritMacro():
    # Critical hits deal 50% more damage, 20% if the victim is a boss.
    damage(victim, eventPlayer, eventDamage * (BRAIN_KILLER_BOSS_CRIT_BONUS_PCT / 100 if victim in bossStateList else BRAIN_KILLER_CRIT_BONUS_PCT / 100))
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.RED, victim.getEyePosition() + directionTowards(eventPlayer.getEyePosition(), victim.getEyePosition()) * victim.sizeScale, 0.1 * victim.sizeScale)
