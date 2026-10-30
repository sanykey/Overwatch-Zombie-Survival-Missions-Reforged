#!mainFile "main.opy"

rule "Fix bot health":
    @Event eachPlayer
    @Team 2
    @Condition gameStatus == true
    @Condition eventPlayer.initializing != true
    @Condition eventPlayer.teleporting != true
    @Condition eventPlayer.getHealth() > eventPlayer.health + 5
    @Condition eventPlayer in bosses == false
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.health)
    if ruleCondition:
        loop()
