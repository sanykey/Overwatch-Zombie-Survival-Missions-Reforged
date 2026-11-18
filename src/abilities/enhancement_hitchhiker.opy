#!mainFile "../../main.opy"

#!define HITCHHIKER_ATTACH_RANGE_SCALE 2
#!define HITCHHIKER_DETACH_RANGE_SCALE 3
#!define HITCHHIKER_DETACH_COOLDOWN 1.5
#!define HITCHHIKER_HEALTH_DIFFERENCE_THRESHOLD 0.01


macro initializeHitchhikerMacro():
    eventPlayer.hitchhikerCarrier = 0
    eventPlayer.hitchhikerCarrier.startGrantingAssistFor(eventPlayer)


macro createHitchhikerHudMacro():
    # Attachment status subheaders: one persistent call each for the passenger
    # and the carrier, reevaluated per viewer; the carrier-side text reads the
    # passenger back-reference instead of scanning for it.
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.hitchhikerAttached),
        f"Attached to {heroIcon(localPlayer.hitchhikerCarrier.getHero())} {localPlayer.hitchhikerCarrier}",
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )
    hudSubheader(
        getPlayers(Team.1).filter(lambda player: player.hitchhikerPassenger != null
            and player.hitchhikerPassenger.hitchhikerAttached),
        f"{heroIcon(localPlayer.hitchhikerPassenger.getHero())} {localPlayer.hitchhikerPassenger} is attached",
        HudPosition.ACTUALLY_LEFT, 98.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING
    )


rule "[HITCHHIKER] ATTACH OR DETACH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or (eventPlayer.hitchhikerAttached and (
        not eventPlayer.hasSpawned()
        or not eventPlayer.hitchhikerCarrier.hasSpawned()
        or eventPlayer.isDead()
        or eventPlayer.hitchhikerCarrier.isDead()
        or not entityExists(eventPlayer.hitchhikerCarrier)
        or eventPlayer.hasStatus(Status.KNOCKED_DOWN)
        or eventPlayer.hitchhikerCarrier.hasStatus(Status.KNOCKED_DOWN)
        or distance(eventPlayer, eventPlayer.hitchhikerCarrier) > HITCHHIKER_DETACH_RANGE_SCALE * eventPlayer.hitchhikerCarrier.sizeScale
    ))) == true

    if not eventPlayer.hitchhikerAttached and eventPlayer.isAlive():
        if playerTargetList.exclude(eventPlayer).any(lambda x: not x.isAttached and distance(eventPlayer, x) < HITCHHIKER_ATTACH_RANGE_SCALE * x.sizeScale):
            # Select carrier.
            eventPlayer.hitchhikerCarrier = (sorted(playerTargetList.exclude(eventPlayer).filter(lambda x: not x.isCrowdControlled and distance(eventPlayer, x) < x.sizeScale * HITCHHIKER_ATTACH_RANGE_SCALE), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))))[0]
            # hitchhikerWorldAttachmentPosition: attachment position in world space, converted and captured before any wait.
            #!define hitchhikerWorldAttachmentPosition tmp0
            hitchhikerWorldAttachmentPosition = eventPlayer.hitchhikerCarrier.getPosition() + (directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.hitchhikerCarrier, eventPlayer)), 0) + Vector.UP) * eventPlayer.hitchhikerCarrier.sizeScale
            # hitchhikerLocalAttachmentOffset: convert the attachment position to the carrier's local coordinates.
            #!define hitchhikerLocalAttachmentOffset tmp0
            hitchhikerLocalAttachmentOffset = localVector(hitchhikerWorldAttachmentPosition, eventPlayer.hitchhikerCarrier, Transform.ROTATION_AND_TRANSLATION)
            # Place passenger behind the carrier.
            if hitchhikerLocalAttachmentOffset.z > 0:
                # hitchhikerLocalAttachmentOffset: mirror a forward offset behind the carrier.
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


rule "[HITCHHIKER] GRANT CARRIER HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hitchhikerPassenger != null

    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.hitchhikerPassenger.initialMaxHealth, true, false)
    eventPlayer.hitchhikerCarrierPoolId = getLastCreatedHealthPool()
    waitUntil(not entityExists(eventPlayer.hitchhikerPassenger), Math.INFINITY)
    removeHealthPool(eventPlayer.hitchhikerCarrierPoolId)


rule "[HITCHHIKER] BALANCE LINKED HEALTH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.HITCHHIKER
    @Condition eventPlayer.hitchhikerAttached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hitchhikerCarrier.isAlive() == true
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.hitchhikerCarrier.getNormalizedHealth()) > HITCHHIKER_HEALTH_DIFFERENCE_THRESHOLD

    # Carrier reference is synchronous through donor selection; tmp3 is dead before either Set Health.
    #!define hitchhikerHealthCarrier tmp3
    hitchhikerHealthCarrier = eventPlayer.hitchhikerCarrier
    # hitchhikerHealthTransferAmount: health to transfer this update; consumed by both setHealth actions before wait.
    #!define hitchhikerHealthTransferAmount tmp0
    hitchhikerHealthTransferAmount = (abs(eventPlayer.getHealth() * hitchhikerHealthCarrier.getMaxHealth() - hitchhikerHealthCarrier.getHealth() * eventPlayer.getMaxHealth())) / (eventPlayer.getMaxHealth() + hitchhikerHealthCarrier.getMaxHealth())
    # hitchhikerHealthRecipient: player with lower normalized health, receiving the transfer immediately.
    #!define hitchhikerHealthRecipient tmp1
    hitchhikerHealthRecipient = sorted(eventPlayer.concat(hitchhikerHealthCarrier), lambda x: x.getNormalizedHealth())[0]
    # hitchhikerHealthDonor: other player, giving the transfer immediately; keep all three scratch values distinct.
    #!define hitchhikerHealthDonor tmp2
    hitchhikerHealthDonor = eventPlayer.concat(hitchhikerHealthCarrier).exclude(hitchhikerHealthRecipient)
    hitchhikerHealthRecipient.setHealth(hitchhikerHealthRecipient.getHealth() + hitchhikerHealthTransferAmount)
    hitchhikerHealthDonor.setHealth(hitchhikerHealthDonor.getHealth() - hitchhikerHealthTransferAmount)
    wait()
    if ruleCondition:
        loop()
