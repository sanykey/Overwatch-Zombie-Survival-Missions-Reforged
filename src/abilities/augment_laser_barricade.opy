#!mainFile "../../main.opy"

# Owned rules and inline fragments; shared storage contracts stay in variables.opy.

#!define LASER_BARRICADE_AUGMENT_HEIGHT 2
#!define LASER_BARRICADE_AUGMENT_WIDTH 6
#!define LASER_BARRICADE_AUGMENT_COOLDOWN 25
#!define LASER_BARRICADE_KNOCKDOWN_DAMAGE_THRESHOLD 4900
#!define LASER_BARRICADE_CONTACT_DAMAGE_MULTIPLIER 2.5

macro placeLaserBarricadeAugmentMacro():
    # -1 latches aiming until Interact release or death.
    # After entry, placement and cooldown ignore the common input conditions.
    # Clear the placement latch on every exit before starting the normal cooldown.
    eventPlayer.augmentBarrierPlacementCooldown = -1
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), 0.5)
    if not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead():
        eventPlayer.augmentBarrierPlacementCooldown = 0
        return
    # Synchronous feedback color; consumed by both Play Effects before the next wait.
    placementWindupColor = Color.BLUE
    playPlacementWindupFeedback()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isDead(), Math.INFINITY)
    eventPlayer.augmentBarrierPlacementCooldown = 0
    checkEnhancementPlacement()
    if isEnhancementPlacementInvalid:
        return
    #Laser Barrier health
    eventPlayer.augmentBarrierHealth = 10000
    #Barrier center point
    eventPlayer.augmentBarrierPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 30, null, getAllPlayers(), false)
    #Barrier corner 1
    eventPlayer.augmentBarrierCorner1 = eventPlayer.augmentBarrierPosition + worldVector((-0.5 * LASER_BARRICADE_AUGMENT_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
    #Barrier Corner 2
    eventPlayer.augmentBarrierCorner2 = eventPlayer.augmentBarrierPosition + worldVector((0.5 * LASER_BARRICADE_AUGMENT_WIDTH) * Vector.LEFT, eventPlayer, Transform.ROTATION)
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

rule "[LASER_BARRICADE AUGMENT] BLOCKS ZOMBIES":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.augmentId == Augment.LASER_BARRICADE
    #Barrier health is greater than 0
    @Condition eventPlayer.augmentBarrierHealth > 0
    #Blocked zombie: horizontal band, feet below wall top, eyes above wall base and distance from
    #the wall, all checked on the same zombie (separate gates could be satisfied by four different zombies).
    # horizontalMaskConst projects relative positions onto XZ.
    # Translate the wall-distance calculation to corner 1 to avoid rebuilding world points.
    # Keep the same projection in the target filter below; preserve the center and corner origins.
    @Condition getLivingPlayers(Team.2).any(lambda player: (magnitude((player.getPosition() - eventPlayer.augmentBarrierPosition) * horizontalMaskConst) < 0.5 * LASER_BARRICADE_AUGMENT_WIDTH) and (player.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_AUGMENT_HEIGHT) and (player.getEyePosition().y > eventPlayer.augmentBarrierPosition.y) and (magnitude((player.getPosition() - eventPlayer.augmentBarrierCorner1) * horizontalMaskConst - eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_AUGMENT_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, (player.getPosition() - eventPlayer.augmentBarrierCorner1) * horizontalMaskConst))))) < 1.5)) == true

    stopChasing(eventPlayer.augmentBarrierHealth)
    #Filter horizontal distance, feet height, eye height and distance from wall together.
    eventPlayer.augmentBarrierTargetList = getLivingPlayers(Team.2).filter(lambda target: (magnitude((target.getPosition() - eventPlayer.augmentBarrierPosition) * horizontalMaskConst) < 0.5 * LASER_BARRICADE_AUGMENT_WIDTH) and (target.getPosition().y < eventPlayer.augmentBarrierPosition.y + LASER_BARRICADE_AUGMENT_HEIGHT) and (target.getEyePosition().y > eventPlayer.augmentBarrierPosition.y) and (magnitude((target.getPosition() - eventPlayer.augmentBarrierCorner1) * horizontalMaskConst - eventPlayer.augmentBarrierEdgeDirection * (min(LASER_BARRICADE_AUGMENT_WIDTH, abs(dotProduct(eventPlayer.augmentBarrierEdgeDirection, (target.getPosition() - eventPlayer.augmentBarrierCorner1) * horizontalMaskConst))))) < 1.5))
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
            #Damage the barricade
            eventPlayer.augmentBarrierHealth -= barrierCollisionTarget.getMaxHealth() * LASER_BARRICADE_CONTACT_DAMAGE_MULTIPLIER
            barrierCollisionTarget.setStatusEffect(eventPlayer, Status.ROOTED, 0.5)
            # Each full threshold of contact damage adds one second of knockdown, including on a breaking hit.
            # The compiler folds the damage threshold conversion to max HP.
            if barrierCollisionTarget.getMaxHealth() >= LASER_BARRICADE_KNOCKDOWN_DAMAGE_THRESHOLD / LASER_BARRICADE_CONTACT_DAMAGE_MULTIPLIER:
                barrierCollisionTarget.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, floor(barrierCollisionTarget.getMaxHealth() / (LASER_BARRICADE_KNOCKDOWN_DAMAGE_THRESHOLD / LASER_BARRICADE_CONTACT_DAMAGE_MULTIPLIER)))
            damage(barrierCollisionTarget, eventPlayer, 20)
        # barrierImpulseVertical: shared vertical angle component of both impulse directions.
        #!define barrierImpulseVertical tmp3
        barrierImpulseVertical = (-1 if barrierCollisionTarget.getPosition().y > eventPlayer.augmentBarrierPosition.y else 1) * (90 + (verticalAngleOfDirection(raycastHitNormal(barrierCollisionTarget.getPosition(), barrierCollisionTarget.getPosition() + Vector.DOWN, null, getAllPlayers(), false))))
        if not magnitude(barrierCollisionTarget.getThrottle()):
            #If bot is not throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: distance(barrierCollisionTarget, x)))[0])), barrierImpulseVertical), 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            #If bot is throttling
            barrierCollisionTarget.applyImpulse(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer.augmentBarrierPosition, (sorted(barrierPushReferencePointList, lambda x: angleBetweenVectors(worldVector(barrierCollisionTarget.getThrottle(), barrierCollisionTarget, Transform.ROTATION), directionTowards(eventPlayer.augmentBarrierPosition, x)))).last())), barrierImpulseVertical), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    if eventPlayer.augmentBarrierHealth > 0:
        wait(3, Wait.RESTART_WHEN_TRUE)
    else:
        wait(6, Wait.RESTART_WHEN_TRUE)
        #If shield is regenerating from 0HP
        if eventPlayer.augmentBarrierHealth <= 0:
            eventPlayer.augmentBarrierHealth = 1
    chaseAtRate(eventPlayer.augmentBarrierHealth, 10000, 500, ChaseRateReeval.NONE)
    if ruleCondition:
        loop()
