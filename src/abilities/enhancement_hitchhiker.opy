#!mainFile "../../main.opy"

#!define HITCHHIKER_ATTACH_RANGE_SCALE 2
#!define HITCHHIKER_DETACH_RANGE_SCALE 3
#!define HITCHHIKER_DETACH_COOLDOWN 1.5
#!define HITCHHIKER_HEALTH_DIFFERENCE_THRESHOLD 0.01


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
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    if not eventPlayer.isAlive() or eventPlayer.hitchhikerCarrierPool != null:
        return

    # Pick the eligible carrier nearest the passenger's aim.
    eventPlayer.hitchhikerCarrier = (sorted(
        playerTargetList.exclude(eventPlayer).filter(lambda x: not x.isAttached and x.hitchhikerCarrierPool == null and not x.isCrowdControlled and distance(eventPlayer, x) < x.sizeScale * HITCHHIKER_ATTACH_RANGE_SCALE),
        lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition()))
    ))[0]
    if not entityExists(eventPlayer.hitchhikerCarrier):
        return

    # hitchhikerLocalAttachmentOffset: rotate the relative displacement into carrier space before any wait.
    #!define hitchhikerLocalAttachmentOffset tmp0
    hitchhikerLocalAttachmentOffset = localVector(
        (directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.hitchhikerCarrier, eventPlayer)), 0) + Vector.UP) * eventPlayer.hitchhikerCarrier.sizeScale,
        eventPlayer.hitchhikerCarrier, Transform.ROTATION
    )
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
    eventPlayer.hitchhikerCarrier.addHealthPool(Health.NORMAL, eventPlayer.initialMaxHealth, true, false)
    eventPlayer.hitchhikerCarrier.hitchhikerCarrierPool = [getLastCreatedHealthPool()]
    eventPlayer.hitchhikerCarrier.hitchhikerPassenger = eventPlayer

    # Forced release and hero switches clear the flag, ending either Crouch wait.
    waitUntil(not eventPlayer.hitchhikerAttached or not eventPlayer.isHoldingButton(Button.CROUCH), Math.INFINITY)
    waitUntil(not eventPlayer.hitchhikerAttached or eventPlayer.isHoldingButton(Button.CROUCH), Math.INFINITY)

    hitchhikerLandAtCarrier = true
    detachHitchhikerPassenger()
    wait(HITCHHIKER_DETACH_COOLDOWN)


rule "[HITCHHIKER] FORCE DETACH":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hitchhikerAttached == true
    @Condition (not entityExists(eventPlayer.hitchhikerCarrier)
        or eventPlayer.concat(eventPlayer.hitchhikerCarrier).any(lambda player: player.isDead() or not player.hasSpawned() or player.hasStatus(Status.KNOCKED_DOWN))
        or distance(eventPlayer, eventPlayer.hitchhikerCarrier) > HITCHHIKER_DETACH_RANGE_SCALE * eventPlayer.hitchhikerCarrier.sizeScale
    ) == true

    hitchhikerLandAtCarrier = true
    detachHitchhikerPassenger()


def detachHitchhikerPassenger():
    @Name "detachHitchhikerPassenger"
    # Synchronous: consume hitchhikerLandAtCarrier without yielding or retaining it.
    if not eventPlayer.hitchhikerAttached:
        return

    eventPlayer.detach()
    if hitchhikerLandAtCarrier and entityExists(eventPlayer.hitchhikerCarrier) and eventPlayer.hasSpawned() and distance(eventPlayer, eventPlayer.hitchhikerCarrier) < HITCHHIKER_DETACH_RANGE_SCALE * eventPlayer.hitchhikerCarrier.sizeScale:
        eventPlayer.teleport(eventPlayer.hitchhikerCarrier.getPosition())
    smallMessage(eventPlayer, "You have detached")
    eventPlayer.hitchhikerAttached = false
    if eventPlayer.getHero() == Hero.MEI:
        eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.hitchhikerCarrier = 0
    removeHealthPool(eventPlayer.hitchhikerPassengerPoolId)


rule "[HITCHHIKER] RELEASE CARRIER HEALTH POOL":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hitchhikerCarrierPool != null

    waitUntil(not entityExists(eventPlayer.hitchhikerPassenger) or eventPlayer.hitchhikerPassenger.hitchhikerCarrier != eventPlayer, Math.INFINITY)
    removeHealthPool(eventPlayer.hitchhikerCarrierPool[0])
    eventPlayer.hitchhikerPassenger = null
    eventPlayer.hitchhikerCarrierPool = null
    # Catch a new passenger who boards before this rule can rearm on a false condition.
    wait()
    if ruleCondition:
        loop()


rule "[HITCHHIKER] BALANCE LINKED HEALTH":
    @Event eachPlayer
    @Team 1
    # Hitchhiker owns the attachment flag on Team 1.
    @Condition eventPlayer.hitchhikerAttached == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hitchhikerCarrier.isAlive() == true
    @Condition abs(eventPlayer.getNormalizedHealth() - eventPlayer.hitchhikerCarrier.getNormalizedHealth()) > HITCHHIKER_HEALTH_DIFFERENCE_THRESHOLD

    # Carrier reference stays live until the health-sorted pair replaces it in tmp3.
    #!define hitchhikerHealthCarrier tmp3
    hitchhikerHealthCarrier = eventPlayer.hitchhikerCarrier
    # hitchhikerSharedHealthRatio: conserve combined HP at a shared health fraction.
    #!define hitchhikerSharedHealthRatio tmp0
    hitchhikerSharedHealthRatio = (eventPlayer.getHealth() + hitchhikerHealthCarrier.getHealth()) / (eventPlayer.getMaxHealth() + hitchhikerHealthCarrier.getMaxHealth())
    # hitchhikerHealthOrder: capture both players before either update. Give HP before taking it.
    #!define hitchhikerHealthOrder tmp3
    hitchhikerHealthOrder = sorted(eventPlayer.concat(hitchhikerHealthCarrier), lambda x: x.getNormalizedHealth())
    hitchhikerHealthOrder[0].setHealth(hitchhikerHealthOrder[0].getMaxHealth() * hitchhikerSharedHealthRatio)
    hitchhikerHealthOrder.last().setHealth(hitchhikerHealthOrder.last().getMaxHealth() * hitchhikerSharedHealthRatio)
    wait()
    if ruleCondition:
        loop()
