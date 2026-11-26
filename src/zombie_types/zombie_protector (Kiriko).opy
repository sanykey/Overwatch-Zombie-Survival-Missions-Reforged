#!mainFile "../../main.opy"

rule "PROTECTOR (KIRIKO) USES CLEANSE":
    @Event eachPlayer
    @Team 2
    @Hero kiriko
    @Condition eventPlayer in miniBossList == true
    @Condition (getPlayersInRadius(eventPlayer, 5, Team.2, LosCheck.SURFACES_AND_ENEMY_BARRIERS).any(lambda player: player.botIsCrowdControlled or player.hasStatus(Status.HACKED) or player.getNormalizedHealth() < 0.5)) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) == false

    abilityThrowdown()
    wait(5)
