#!mainFile "../../main.opy"

# Owned rules and inline fragments; shared storage contracts stay in variables.opy.


macro placeLaserBarricadeAugmentMacro():
    # -1 latches aiming until Interact release or death.
    # After entry, placement and cooldown ignore the common input conditions.
    # Clear the placement latch on every exit before starting the normal cooldown.
    eventPlayer.augmentBarrierPlacementCooldown = -1
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), 0.5)
    if not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead():
        eventPlayer.augmentBarrierPlacementCooldown = 0
        return
    placementWindupColor = Color.BLUE
    playPlacementWindupFeedback()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), Math.INFINITY)
    eventPlayer.augmentBarrierPlacementCooldown = 0
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    #Laser Barrier health
    stopChasing(eventPlayer.augmentBarrierHealth)
    eventPlayer.augmentBarrierRegenAt = 0
    eventPlayer.augmentBarrierHealth = 10000
    #Barrier center point
    eventPlayer.augmentBarrierPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    # Compute the rotated half-width once and use it for both corners before any wait.
    #!define barrierCornerOffset tmp0
    barrierCornerOffset = worldVector((0.5 * LASER_BARRICADE_AUGMENT_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    eventPlayer.augmentBarrierCorner1 = eventPlayer.augmentBarrierPosition - barrierCornerOffset
    eventPlayer.augmentBarrierCorner2 = eventPlayer.augmentBarrierPosition + barrierCornerOffset
    # Horizontal push direction captured at placement; reference points are center +/- this vector.
    eventPlayer.augmentBarrierFacing = directionFromAngles(eventPlayer.getHorizontalFacingAngle(), 0)
    # Along-barrier direction, reused by collision checks.
    eventPlayer.augmentBarrierEdgeDirection = directionTowards(eventPlayer.augmentBarrierCorner1, eventPlayer.augmentBarrierCorner2)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.augmentBarrierPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.BLUE, eventPlayer.augmentBarrierPosition, 50)
    smallMessage(eventPlayer, "  Barricade placed!")
    #Laser Barrier cooldown
    eventPlayer.augmentBarrierPlacementCooldown = LASER_BARRICADE_AUGMENT_COOLDOWN
    while eventPlayer.augmentBarrierPlacementCooldown > 0:
        wait(1)
        eventPlayer.augmentBarrierPlacementCooldown += -1

macro initializeLaserBarricadeAugmentMacro():
    #Augment: Laser Barricade
    # augmentBarrierFacing: horizontal unit direction saved at placement, to reconstruct both push reference points.
    # augmentBarrierEdgeDirection: unit direction from corner 1 to corner 2, cached for zombie collision checks.
    # augmentBarrierPlacementCooldown: -1 while aiming; otherwise remaining placement cooldown in seconds (LASER_BARRICADE_AUGMENT_COOLDOWN on placement), for checks and HUD.
    # augmentBarrierPosition: placed barrier center in world coordinates, for collision checks, push points and HP text.
    # augmentBarrierCorner1: first lower corner in world coordinates, for beams and collision geometry.
    # augmentBarrierCorner2: second lower corner in world coordinates, for beams and the along-barrier direction.
    # augmentBarrierHealth: current barrier health (10000 on placement), for blocking, damage, regeneration and HUD.
    # HUD lives in AUGMENT HUD (PERMANENT TABLE).
    #Barricade placement visual
    createBeam(eventPlayer.filter(lambda _: eventPlayer.augmentBarrierPlacementCooldown == -1 and eventPlayer.isHoldingButton(Button.INTERACT) and distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) <= 30), Beam.BAD, worldVector(vect(-0.5 * LASER_BARRICADE_AUGMENT_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), worldVector(vect(0.5 * LASER_BARRICADE_AUGMENT_WIDTH, 0.1, 0), eventPlayer, Transform.ROTATION) + (raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)), Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Barricade bottom
    createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierPosition != null), Beam.BAD, eventPlayer.augmentBarrierCorner1, eventPlayer.augmentBarrierCorner2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Barricade side 1
    createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner1 + LASER_BARRICADE_AUGMENT_HEIGHT * Vector.UP, eventPlayer.augmentBarrierCorner1, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Barricade side 2
    createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner2, eventPlayer.augmentBarrierCorner2 + LASER_BARRICADE_AUGMENT_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Barricade top
    createBeam(getAllPlayers().filter(lambda _: eventPlayer.augmentBarrierHealth > 0), Beam.BAD, eventPlayer.augmentBarrierCorner2 + LASER_BARRICADE_AUGMENT_HEIGHT * Vector.UP, eventPlayer.augmentBarrierCorner1 + LASER_BARRICADE_AUGMENT_HEIGHT * Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Barricade health
    createInWorldText(getAllPlayers() if eventPlayer.augmentBarrierHealth > 0 else null, "{0}HP".format(ceil(eventPlayer.augmentBarrierHealth)), eventPlayer.augmentBarrierPosition + Vector.UP, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.BLUE)

macro barrierHorizontalOffset(target, origin):
    (target.getPosition() - origin) * horizontalMaskConst


macro isLaserBarricadeContact(target):
    (
        magnitude(barrierHorizontalOffset(target, eventPlayer.augmentBarrierPosition)) < 0.5 * LASER_BARRICADE_AUGMENT_WIDTH
        and target.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_AUGMENT_HEIGHT
        and target.getEyePosition().y > eventPlayer.augmentBarrierPosition.y
        # The wall direction keeps its vertical component on slopes. Only the target offset is projected onto XZ.
        and magnitude(barrierHorizontalOffset(target, eventPlayer.augmentBarrierCorner1) - eventPlayer.augmentBarrierEdgeDirection * min(
            LASER_BARRICADE_AUGMENT_WIDTH,
            abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, barrierHorizontalOffset(target, eventPlayer.augmentBarrierCorner1)))
        )) < 1.5
    )


macro pushLaserBarricadeContacts():
    # barrierPushReferencePointList: both push reference points, reconstructed from saved geometry and consumed before wait.
    #!define barrierPushReferencePointList tmp1
    barrierPushReferencePointList = [eventPlayer.augmentBarrierPosition + eventPlayer.augmentBarrierFacing, eventPlayer.augmentBarrierPosition + eventPlayer.augmentBarrierFacing * -1]
    # barrierCollisionTargetIndex: barricade target index, to damage and push each zombie crossing the barrier.
    #!define barrierCollisionTargetIndex tmp0
    for barrierCollisionTargetIndex in range(len(eventPlayer.augmentBarrierTargetList)):
        # barrierCollisionTarget: current zombie, consumed by this iteration's damage/push actions before wait.
        #!define barrierCollisionTarget tmp2
        barrierCollisionTarget = eventPlayer.augmentBarrierTargetList[barrierCollisionTargetIndex]
        if not barrierCollisionTarget.hasStatus(Status.ROOTED):
            # Reuse the contact damage for the wall debit and knockdown before tmp3 becomes the impulse angle.
            #!define barrierContactDamage tmp3
            barrierContactDamage = barrierCollisionTarget.getMaxHealth() * LASER_BARRICADE_CONTACT_DAMAGE_MULTIPLIER
            eventPlayer.augmentBarrierHealth -= barrierContactDamage
            barrierCollisionTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            # Each full threshold adds 1s of knockdown, capped at 1s for large bosses.
            if barrierContactDamage >= LASER_BARRICADE_KNOCKDOWN_DAMAGE_THRESHOLD:
                barrierCollisionTarget.setStatusEffect(
                    eventPlayer, Status.KNOCKED_DOWN,
                    1 if barrierCollisionTarget in bossStateList else floor(barrierContactDamage / LASER_BARRICADE_KNOCKDOWN_DAMAGE_THRESHOLD)
                )
            damage(barrierCollisionTarget, eventPlayer, 20)
        # Reuse the zombie's position for the height check and the ground-normal ray.
        #!define barrierCollisionPosition tmp3
        barrierCollisionPosition = barrierCollisionTarget.getPosition()
        # Reuse its slot for the vertical angle after the ray consumes the position.
        #!define barrierImpulseVertical tmp3
        barrierImpulseVertical = (-1 if barrierCollisionPosition.y > eventPlayer.augmentBarrierPosition.y else 1) * (
            90 + verticalAngleOfDirection(raycastHitNormal(barrierCollisionPosition, barrierCollisionPosition + Vector.DOWN, null, getAllPlayers(), false))
        )
        if not magnitude(barrierCollisionTarget.getThrottle()):
            # Choose the nearer side. A tie keeps the first reference point.
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, barrierPushReferencePointList[
                1 if distance(barrierCollisionTarget, barrierPushReferencePointList[1]) < distance(barrierCollisionTarget, barrierPushReferencePointList[0]) else 0
            ])), barrierImpulseVertical), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            # Choose the side with the larger angle to the movement input. A tie keeps the last reference point.
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, barrierPushReferencePointList[
                0 if angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.augmentBarrierPosition, barrierPushReferencePointList[0]))
                > angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.augmentBarrierPosition, barrierPushReferencePointList[1])) else 1
            ])), barrierImpulseVertical), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "[LASER_BARRICADE AUGMENT] BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.LASER_BARRICADE
    @Condition eventPlayer.augmentBarrierPosition != null

    if eventPlayer.augmentBarrierHealth > 0:
        # Use scratch for the scan. Only contact passes publish the list for the push loop.
        #!define barrierContacts tmp0
        barrierContacts = getLivingPlayers(Team.2).filter(lambda target: isLaserBarricadeContact(target))
        if barrierContacts != []:
            eventPlayer.augmentBarrierTargetList = barrierContacts
            if eventPlayer.augmentBarrierRegenAt != -1:
                stopChasing(eventPlayer.augmentBarrierHealth)
                eventPlayer.augmentBarrierRegenAt = -1
            pushLaserBarricadeContacts()
            wait(0.016, Wait.ABORT_WHEN_FALSE)
            loop()

    if eventPlayer.augmentBarrierRegenAt == -1:
        eventPlayer.augmentBarrierRegenAt = getTotalTimeElapsed() + (3 if eventPlayer.augmentBarrierHealth > 0 else 6)
    if eventPlayer.augmentBarrierRegenAt > 0 and getTotalTimeElapsed() >= eventPlayer.augmentBarrierRegenAt:
        eventPlayer.augmentBarrierRegenAt = 0
        if eventPlayer.augmentBarrierHealth <= 0:
            eventPlayer.augmentBarrierHealth = 1
        chaseAtRate(eventPlayer.augmentBarrierHealth, 10000, 500, ChaseRateReeval.NONE)
    # Idle walls sample less often. Contacts keep the original minimum wait between impulses.
    wait(0.064, Wait.ABORT_WHEN_FALSE)
    loop()
