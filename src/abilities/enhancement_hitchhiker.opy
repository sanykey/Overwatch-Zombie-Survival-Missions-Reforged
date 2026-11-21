#!mainFile "../../main.opy"

macro initializeHitchhikerMacro():
    eventPlayer.hitchhikerCarrier = 0
    eventPlayer.hitchhikerCarrier.startGrantingAssistFor(eventPlayer)


macro createHitchhikerHudMacro():
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.hitchhikerAttached),
        "Attached to {0} {1}".format(heroIcon(localPlayer.hitchhikerCarrier.getHero()), localPlayer.hitchhikerCarrier),
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.hitchhikerPassenger != null and player.hitchhikerPassenger.hitchhikerAttached),
        "{0} {1} is attached".format(heroIcon(localPlayer.hitchhikerPassenger.getHero()), localPlayer.hitchhikerPassenger),
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )


rule "HITCHHIKER ATTACH/DETATCH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.hitchhikerAttached and (not eventPlayer.hasSpawned() or not eventPlayer.hitchhikerCarrier.hasSpawned() or eventPlayer.isDead() or eventPlayer.hitchhikerCarrier.isDead() or not entityExists(eventPlayer.hitchhikerCarrier) or eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN) or distance(eventPlayer, eventPlayer.hitchhikerCarrier) > HITCHHIKER_DETACH_RANGE_SCALE * eventPlayer.hitchhikerCarrier.sizeScale))) == true

    if not eventPlayer.hitchhikerAttached and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer, x) < 2 * x.sizeScale):
            #Select parent
            eventPlayer.hitchhikerCarrier = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.isCrowdControlled and distance(eventPlayer, x) < x.sizeScale * HITCHHIKER_ATTACH_RANGE_SCALE), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            # hitchhikerWorldAttachmentPosition: attachment position in world space, converted and captured before any wait.
            #!define hitchhikerWorldAttachmentPosition tmp0
            hitchhikerWorldAttachmentPosition = eventPlayer.hitchhikerCarrier.getPosition() + directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.hitchhikerCarrier, eventPlayer)), 0) * eventPlayer.hitchhikerCarrier.sizeScale + eventPlayer.hitchhikerCarrier.sizeScale * Vector.UP
            # hitchhikerLocalAttachmentOffset: convert the attachment position to the parent's local coordinates.
            #!define hitchhikerLocalAttachmentOffset tmp0
            hitchhikerLocalAttachmentOffset = localVector(hitchhikerWorldAttachmentPosition, eventPlayer.hitchhikerCarrier, Transform.ROTATION_AND_TRANSLATION)
            #Translate player behind parent
            if hitchhikerLocalAttachmentOffset.z > 0:
                # hitchhikerLocalAttachmentOffset: mirror a forward offset behind the parent.
                hitchhikerLocalAttachmentOffset *= vect(1, 1, -1)
            # hitchhikerLocalAttachmentOffset: raise the final local offset before capturing it in attachTo.
            hitchhikerLocalAttachmentOffset += Vector.UP
            eventPlayer.hitchhikerAttached = true
            # Cryo-Freeze while attached breaks the attachment, so Mei may not use Ability 1 while hitchhiking.
            if eventPlayer.getHero() == Hero.MEI:
                eventPlayer.disallowButton(Button.ABILITY_1)
            eventPlayer.attachTo(eventPlayer.hitchhikerCarrier, evalOnce(hitchhikerLocalAttachmentOffset))
            smallMessage(eventPlayer, "You are attached")
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.hitchhikerCarrier.initialMaxHealth, true, false)
            eventPlayer.hitchhikerPassengerPoolId = getLastCreatedHealthPool()
            eventPlayer.hitchhikerCarrier.hitchhikerPassenger = eventPlayer
    else:
        if entityExists(eventPlayer.hitchhikerCarrier) and eventPlayer.hasSpawned() and distance(eventPlayer, eventPlayer.hitchhikerCarrier) < HITCHHIKER_DETACH_RANGE_SCALE * eventPlayer.hitchhikerCarrier.sizeScale:
            eventPlayer.teleport(eventPlayer.hitchhikerCarrier.getPosition())
        else:
            eventPlayer.detach()
        smallMessage(eventPlayer, "You have detached")
        eventPlayer.hitchhikerCarrier.hitchhikerPassenger = null
        eventPlayer.hitchhikerAttached = false
        if eventPlayer.getHero() == Hero.MEI:
            eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.hitchhikerCarrier = 0
        removeHealthPool(eventPlayer.hitchhikerPassengerPoolId)
        wait(HITCHHIKER_DETACH_COOLDOWN)


rule "HITCHHIKER PARENT RECIEVES HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hitchhikerPassenger != null

    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.hitchhikerPassenger.initialMaxHealth, true, false)
    eventPlayer.hitchhikerCarrierPoolId = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.hitchhikerPassenger), Math.INFINITY)
    removeHealthPool(eventPlayer.hitchhikerCarrierPoolId)


rule "HITCHHIKER LIFEBONDS":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition eventPlayer.hitchhikerAttached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hitchhikerCarrier.isAlive() == true
    #Normalized health difference
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.hitchhikerCarrier.getNormalizedHealth()) > HITCHHIKER_HEALTH_DIFFERENCE_THRESHOLD

    # hitchhikerHealthTransferAmount: health to transfer this update; consumed by both setHealth actions before wait.
    #!define hitchhikerHealthTransferAmount tmp0
    hitchhikerHealthTransferAmount = (abs(eventPlayer.getHealth() * eventPlayer.hitchhikerCarrier.getMaxHealth() - eventPlayer.hitchhikerCarrier.getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + eventPlayer.hitchhikerCarrier.getMaxHealth())
    # hitchhikerHealthRecipient: player with lower normalized health, receiving the transfer immediately.
    #!define hitchhikerHealthRecipient tmp1
    hitchhikerHealthRecipient = sorted(eventPlayer.concat(eventPlayer.hitchhikerCarrier), lambda x: x.getNormalizedHealth())[0]
    # hitchhikerHealthDonor: other player, giving the transfer immediately; keep all three scratch values distinct.
    #!define hitchhikerHealthDonor tmp2
    hitchhikerHealthDonor = eventPlayer.concat(eventPlayer.hitchhikerCarrier).exclude(hitchhikerHealthRecipient)
    hitchhikerHealthRecipient.setHealth(hitchhikerHealthRecipient.getHealth() + hitchhikerHealthTransferAmount)
    hitchhikerHealthDonor.setHealth(hitchhikerHealthDonor.getHealth() - hitchhikerHealthTransferAmount)
    wait()
    if ruleCondition:
        loop()
