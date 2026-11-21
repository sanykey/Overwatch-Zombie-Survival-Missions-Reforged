#!mainFile "../../main.opy"


macro useRevivePowerUp():
    if not getDeadPlayers(Team.1).any(lambda player: distance(eventPlayer, player) <= REVIVE_RADIUS):
        return
    eventPlayer.activePowerUpIds.append(PowerUpItem.REVIVE)
    startRule(instantRevive, StartRuleBehavior.NOOP)


def instantRevive():
    @Name "instantRevive (0-9)"

    eventPlayer.powerUpReviveTarget = (sorted(getDeadPlayers(Team.1).filter(lambda player: distance(eventPlayer, player) <= REVIVE_RADIUS), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getPosition()))))[0]
    wait()
    eventPlayer.powerUpReviveTarget.setStatusEffect(null, Status.INVINCIBLE, 5)
    eventPlayer.powerUpReviveTarget.resurrect()
    waitUntil(eventPlayer.powerUpReviveTarget.isAlive(), 3)
    playAquaPowerUpSound()
    smallMessage([eventPlayer, eventPlayer.powerUpReviveTarget], "{0} {1}: \"I've got you. Now let's move!\"".format(eventPlayer, heroIcon(eventPlayer.getHero())))
    eventPlayer.activePowerUpIds.remove(PowerUpItem.REVIVE)
