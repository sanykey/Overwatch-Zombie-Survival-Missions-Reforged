#!mainFile "../../main.opy"


macro initializePlagueDoctorMacro():
    # enhancementPlagueCureTotal: accumulated infection levels removed, including cure bonuses, displayed in the HUD.
    # Permanent +30% healing; infected targets receive another x1.25 (x1.625 total).
    eventPlayer.setHealingDealt(100 + PLAGUE_DOCTOR_HEAL_BONUS_PCT)
    startHealingModification(getPlayers(Team.1).filter(lambda player: player.isInfected), eventPlayer, PLAGUE_DOCTOR_INFECTED_HEAL_MULTIPLIER_PCT, HealingReeval.RECEIVERS_AND_HEALERS)
    eventPlayer.enhancementPlagueCureTotal = 0


macro applyPlagueDoctorHealingMacro():
    if eventPlayer.isInfected:
        eventPlayer.infectionLevel -= eventHealing / 500
        eventPlayer.enhancementPlagueCureTotal += eventHealing / 500
    if healee.infectionLevel >= 1 and healee.enhancementId != Enhancement.ZOMBIE_HYBRID:
        healee.infectionLevel -= eventHealing / 275
        eventPlayer.enhancementPlagueCureTotal += eventHealing / 275
        if healee.infectionLevel < 1:
            healee.infectionLevel -= 0.5
            eventPlayer.enhancementPlagueCureTotal += 0.5
            playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, healee, 1)
            smallMessage(eventPlayer, "You cured yourself!" if healee == eventPlayer else "You cured {0} {1}!".format(healee, heroIcon(healee.getHero())))
