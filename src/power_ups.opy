#!mainFile "main.opy"

subroutine powerUpAssignment 3


rule "============================================== POWER UPS ====================================================":
    @Disabled
    @Delimiter


rule "POWER UP EFFECT/TEXT MANAGEMENT":
    @Condition gameStatus == true
    @Condition len(powerUpPositions) > len(powerUpEffect)
    @Condition len(availablePowerups) > 0
    
    powerUpAssignment()
    powerUpEffect.append(getLastCreatedEntity())
    powerUpText.append(getLastCreatedText())
    if ruleCondition:
        loop()


rule "EFFECT/TEXT (PERMANENT)":
    @Condition gameStatus == true
    @Condition len(availablePowerups) > 0
    
    #Cure hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 1), "CURE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to stop all damage over time and cure yourself".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Revive hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 2), "REVIVE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Look at a teammate and hold [{0}] to revive them".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Force field hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 3), "Force Field", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a force field".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #No cooldowns hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 4), "No Cooldowns", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to get fast cooldowns".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Air strike hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 5), "Air Strike", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to call in an air strike".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Heal beacon hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 6), "Beacon of Healing", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a healing beacon and gain bonus healing".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING)
    #Vaccine hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 7), "VACCINE", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to increase your resistance to infection".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    #Sentry turret hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 8), "Sentry Turret", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a sentry turret".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    #Cloaking Device hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 9), "Cloaking Device", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to become invisible to enemies".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    #Super Nano hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 10), "Super Nano", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to increase your damage and speed".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Bounce Pad hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 11), "Bounce Pad", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to place a bounce pad".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.PURPLE, Color.PURPLE, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    #Ultimate Charger hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 12), "Ultimate Charger", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to rapidly charge your ultimate".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    #Stun hud text
    hudText(getLivingPlayers(Team.1).filter(lambda player: player.currentPowerUp == 13), "Stun", "Hold [{0}] to drop your power up".format(inputBindingString(Button.RELOAD)), "Hold [{0}] to stun nearby enemies".format(inputBindingString(Button.INTERACT)), HudPosition.LEFT, 100, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "PLAYER DROPS POWER UP (MANUAL)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition gameStatus == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.currentPowerUp != 0
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0) if eventPlayer.isOnGround() else nearestWalkablePosition(eventPlayer.getPosition()))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)


rule "PLAYER DROPS POWER UP (DEATH)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.currentPowerUp != 0
    
    while not eventPlayer.isOnGround():
        wait(0.25)
    powerUpIDs.append(eventPlayer.currentPowerUp)
    powerUpPositions.append(eventPlayer.getPosition() + vect(0, 0.25, 0))
    wait()
    eventPlayer.currentPowerUp = 0
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 25)


def powerUpAssignment():
    @Name "powerUpAssignment"
    
    #Cure
    if powerUpIDs[len(powerUpEffect)] == 1:
        createEffect(getAllPlayers(), Effect.ORB, Color.GREEN, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "CURE", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Instant Revive
    elif powerUpIDs[len(powerUpEffect)] == 2:
        createEffect(getAllPlayers(), Effect.ORB, Color.YELLOW, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Revive", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Force Field
    elif powerUpIDs[len(powerUpEffect)] == 3:
        createEffect(getAllPlayers(), Effect.ORB, Color.BLUE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Force Field", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #No Cooldowns
    elif powerUpIDs[len(powerUpEffect)] == 4:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "No Cooldowns", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Air Strike
    elif powerUpIDs[len(powerUpEffect)] == 5:
        createEffect(getAllPlayers(), Effect.ORB, Color.ORANGE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Air Strike", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Beacon of Healing
    elif powerUpIDs[len(powerUpEffect)] == 6:
        createEffect(getAllPlayers(), Effect.ORB, Color.YELLOW, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Beacon of Healing", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Vaccine
    elif powerUpIDs[len(powerUpEffect)] == 7:
        createEffect(getAllPlayers(), Effect.ORB, Color.GREEN, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Vaccine", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Sentry Turret
    elif powerUpIDs[len(powerUpEffect)] == 8:
        createEffect(getAllPlayers(), Effect.ORB, Color.ORANGE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Sentry Turret", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Cloaking Device
    elif powerUpIDs[len(powerUpEffect)] == 9:
        createEffect(getAllPlayers(), Effect.ORB, Color.BLUE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Cloaking Device", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Super Nano
    elif powerUpIDs[len(powerUpEffect)] == 10:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Super Nano", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Bounce pad
    elif powerUpIDs[len(powerUpEffect)] == 11:
        createEffect(getAllPlayers(), Effect.ORB, Color.PURPLE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Bounce Pad", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Ultimate Charger
    elif powerUpIDs[len(powerUpEffect)] == 12:
        createEffect(getAllPlayers(), Effect.ORB, Color.RED, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Ultimate Charger", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    #Stun
    elif powerUpIDs[len(powerUpEffect)] == 13:
        createEffect(getAllPlayers(), Effect.ORB, Color.WHITE, powerUpPositions[len(powerUpEffect)], 1, EffectReeval.VISIBILITY)
        createInWorldText(getAllPlayers(), "Stun", powerUpPositions[len(powerUpText)], 1, Clip.SURFACES, WorldTextReeval.VISIBILITY)
