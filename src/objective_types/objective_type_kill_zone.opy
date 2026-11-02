#!mainFile "../main.opy"


rule "MODIFY KILL ZONE SCORE":
    @Event playerDealtFinalBlow
    @Condition currentObjectiveType == ObjectiveType.KILL_ZONE
    @Condition playerTargetList.concat(victim).any(lambda x: distance(x.getPosition(), killZoneCenter) < objectiveRad) == true
    
    if distance(eventPlayer.getPosition(), killZoneCenter) < objectiveRad or distance(victim.getPosition(), killZoneCenter) < objectiveRad:
        victim.botRespawnDelay = 2
        killZoneEliminationScore += ceil(victim.botBaseHealth / 280)
        if killZoneEliminationScore >= ELIMINATIONS_NEEDED_PER_OBJECTIVE:
            isObjectiveComplete = true
            #Give all bots a long respawn time
            getPlayers(Team.2).botRespawnDelay = 12
            botSpawnTimeList = botSpawnTimeList.map(lambda _: 12)
    #Adjust Kill Zone Positions
    killZoneCenter += 0.5 * directionTowards(killZoneCenter, victim.getPosition())
