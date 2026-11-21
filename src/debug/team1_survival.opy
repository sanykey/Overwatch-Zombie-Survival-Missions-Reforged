#!mainFile "../../main.opy"

rule "[debug] Team 1 unkillable during gameplay":
    @Event eachPlayer
    @Team 1
    @Condition DEBUG_TEAM1_SURVIVAL
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true

    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)
    waitUntil(isGameplayActive == false or eventPlayer.isDead() or eventPlayer.getTeam() != Team.1, Math.INFINITY)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


rule "[debug] Automatically revive downed Team 1 players":
    @Event playerDied
    @Team 1
    @Condition DEBUG_TEAM1_SURVIVAL
    @Condition isGameplayActive == true
    @Condition eventPlayer.isPlayerActive == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer.isHeroSwitchRespawn == false
    @Condition eventPlayer.rescueTimeRemaining > 0

    # Let PLAYER GETS DOWNED reset the timer and recover the body first.
    # REVIVE PLAYER OR ADVANCE DEATH TIMER handles the resurrection and cleanup.
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.reviveTimeRemaining = 0


rule "[debug] Heal and cure Team 1":
    @Condition DEBUG_TEAM1_SURVIVAL
    @Condition isGameplayActive == true

    # These scratch values are assigned and consumed after the wait.
    #!define debugInfectedPlayers tmp0
    #!define debugInfectedIndex tmp1
    #!define debugInfectionDot tmp2

    wait(20, Wait.ABORT_WHEN_FALSE)
    debugInfectedPlayers = getPlayers(Team.1).filter(lambda player: player.isInfected or player.infectionLevel > 0)
    for debugInfectedIndex in range(len(debugInfectedPlayers)):
        debugInfectionDot = debugInfectedPlayers[debugInfectedIndex].infectionDamageOverTimeId
        if debugInfectionDot != null:
            stopDamageOverTime(debugInfectionDot)
    debugInfectedPlayers.infectionDamageOverTimeId = null
    debugInfectedPlayers.isInfected = false
    # Leave negative infection levels that represent vaccination in place.
    debugInfectedPlayers.filter(lambda player: player.infectionLevel > 0).infectionLevel = 0
    heal(getPlayers(Team.1), null, 700)
    loop()
