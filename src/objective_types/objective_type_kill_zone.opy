#!mainFile "../main.opy"


rule "MODIFY KILL ZONE SCORE":
    @Event playerDealtFinalBlow
    @Condition CURRENT_OBJECTIVE_TYPE == ObjectiveType.KILL_ZONE
    @Condition playerTargetList.concat(victim).any(lambda x: distance(x.getPosition(), objectiveChase1) < objectiveRad) == true
    
    if distance(eventPlayer.getPosition(), objectiveChase1) < objectiveRad or distance(victim.getPosition(), objectiveChase1) < objectiveRad:
        victim.reviveTimer = 2
        objectiveCaptureValue += ceil(victim.health / 280)
        if objectiveCaptureValue >= eliminationsNeededPerObjective:
            objectiveComplete = true
            #Give all bots a long respawn time
            getPlayers(Team.2).reviveTimer = 12
            spawnTimes = spawnTimes.map(lambda _: 12)
    #Adjust Kill Zone Positions
    objectiveChase1 += 0.5 * directionTowards(objectiveChase1, victim.getPosition())
