#!mainFile "../../main.opy"



macro biowasteOutputMacro():
    # biowasteOutputType: next queued biowaste type, returned synchronously to assign to the selected holder.
    #!define biowasteOutputType tmp0
    biowasteOutputType = biomorphingQueuedTypeList[0]
    del biomorphingQueuedTypeList[0]
    if biomorphingQueuedTypeList == []:
        biomorphingQueuedTypeList = random.shuffle([0, 1, 2])


macro biowasteAssignmentMacro():
    # Synchronous inputs: biowasteOrbType = type, biowasteOrbPosition = position. No reevaluated arguments.
    #!define biowasteOrbType tmp0
    biomorphingResourceTypeList.append(biowasteOrbType)
    #!define biowasteOrbPosition tmp1
    biomorphingResourcePositionList.append(biowasteOrbPosition)
    createEffect(getAllPlayers(), Effect.ORB, biomorphingResourceColorList[biowasteOrbType], biowasteOrbPosition, 1, EffectReeval.NONE)
    biomorphingResourceEffectIdList.append(getLastCreatedEntity())
    createInWorldText(getAllPlayers(), biomorphingResourceNameList[biowasteOrbType], biowasteOrbPosition + offsetUpThreeQuartersConst, 1, Clip.NONE, WorldTextReeval.NONE)
    biomorphingResourceTextIdList.append(getLastCreatedText())


rule "BIOMORPHING GOAL START":
    @Condition currentObjectiveType == ObjectiveType.BIOMORPHING
    @Condition isObjectiveComplete == false
    @Condition isBiomorphingGoalPending == true
    @Condition isGameplayActive == true
    
    # biomorphingCleanupIndex: dedicated role name; storage is shared with placement attempts and Satellite firing steps.
    #Destroy all biowaste
    for biomorphingCleanupIndex in range(len(biomorphingResourceEffectIdList)):
        destroyEffect(biomorphingResourceEffectIdList[biomorphingCleanupIndex])
        destroyInWorldText(biomorphingResourceTextIdList[biomorphingCleanupIndex])
        wait()
    # The resource-type slot belongs to the Rescue NPC after an objective transition.
    if currentObjectiveType != ObjectiveType.BIOMORPHING:
        return
    biomorphingQueuedTypeList = random.shuffle([0, 1, 2])
    biomorphingDeferredTypeList = []
    biomorphingDeferredPositionList = []
    biomorphingResourceTypeList = []
    biomorphingResourcePositionList = []
    biomorphingResourceEffectIdList = []
    biomorphingResourceTextIdList = []
    getAllPlayers().biomorphingResourceAmount = 0
    getAllPlayers().biomorphingResourceType = null
    if biomorphingCapturePercent:
        biomorphingGoalColor = objectiveColor
        biomorphingGoalText = "Limit reached! The next goal is..."
    waitUntil(not biomorphingCapturePercent, 3)
    if not biomorphingCapturePercent and biomorphingGoalQueueList[0] == 3:
        del biomorphingGoalQueueList[0]
        biomorphingGoalQueueList.append(3)
        wait(0.15)
    # The resource-type slot belongs to the Rescue NPC after an objective transition.
    if currentObjectiveType != ObjectiveType.BIOMORPHING:
        return
    if biomorphingGoalQueueList[0] in [0, 1, 2]:
        biomorphingGoalText = ["Deposit a head for extra points", "Deposit an arm for extra points", "Deposit a leg for extra points"][biomorphingGoalQueueList[0]]
        biomorphingGoalColor = biomorphingResourceColorList[biomorphingGoalQueueList[0]]
    else:
        biomorphingGoalText = "Hand over your blood."
        playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, currentObjectivePosition, 200)
        biomorphingGoalColor = Color.RED
        getPlayers(Team.1).biomorphingResourceType = 3
        getPlayers(Team.1).biomorphingResourceAmount = 9999
    isBiomorphingGoalPending = false
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, biomorphingGoalColor, currentObjectivePosition, 200)


rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS":
    @Condition currentObjectiveType == ObjectiveType.BIOMORPHING
    @Condition isObjectiveComplete == false
    @Condition (len(biomorphingResourcePositionList) + (len(getLivingPlayers(Team.ALL).filter(lambda player: player.biomorphingResourceAmount > 0))) < 3 or biomorphingCapturePercent >= 100) == true
    @Condition isGameplayActive == true
    @Condition (biomorphingGoalQueueList[0] != 3 or biomorphingCapturePercent >= 100) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if biomorphingCapturePercent < 100:
        waitUntil(isBiomorphingGoalPending == false, Math.INFINITY)
        # biowasteCarrierIndex: index of a zombie not holding a full resource, to choose the next resource carrier.
        #!define biowasteCarrierIndex tmp0
        biowasteCarrierIndex = getPlayers(Team.2).index((getPlayers(Team.2).filter(lambda player: player.biomorphingResourceAmount != BIOMORPHING_RESOURCE_AMOUNT))[0])
        # biowasteCarrierCandidateList: current zombie list, to resolve the carrier index in biowasteCarrierIndex to a player.
        #!define biowasteCarrierCandidateList tmp1
        biowasteCarrierCandidateList = getPlayers(Team.2)
        # biowasteCarrier: selected zombie, kept while biowasteOutputMacro replaces biowasteCarrierIndex with its resource type.
        #!define biowasteCarrier tmp1
        biowasteCarrier = biowasteCarrierCandidateList[biowasteCarrierIndex]
        biowasteCarrier.biomorphingResourceAmount = BIOMORPHING_RESOURCE_AMOUNT
        biowasteOutputMacro()
        #!define biowasteAssignedType tmp0
        biowasteCarrier.biomorphingResourceType = biowasteAssignedType
    else:
        # biomorphingRewardItemIndex: reward-item index, to place four power-ups at 90-degree intervals around the objective.
        #!define biomorphingRewardItemIndex tmp0
        for biomorphingRewardItemIndex in range(4):
            supplyPowerUpIdList.append(random.randint(1, 13))
            supplyPowerUpPositionList.append(currentObjectivePosition + directionFromAngles(90 * biomorphingRewardItemIndex, 0))
        isObjectiveComplete = true
    if ruleCondition:
        loop()


rule "BIOWASTE IS PICKED UP":
    @Event eachPlayer
    @Condition currentObjectiveType == ObjectiveType.BIOMORPHING
    @Condition isGameplayActive == true
    @Condition isObjectiveComplete == false
    @Condition eventPlayer.biomorphingResourceAmount <= 0
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition biomorphingResourcePositionList != []
    @Condition (biomorphingResourcePositionList.any(lambda x: distance(x, eventPlayer) < 2 or distance(x, eventPlayer.getEyePosition()) < 2)) == true
    @Condition (not eventPlayer.isDummy() or eventPlayer.getTeam() == Team.2) == true
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    # biowastePickupPosition: nearest dropped biowaste position, to identify the resource being picked up.
    #!define biowastePickupPosition tmp0
    biowastePickupPosition = sorted(biomorphingResourcePositionList, lambda x: distance(eventPlayer, x))[0]
    # biowastePickupIndex: resource index shared by position, type and visual arrays, to pick up and remove the same orb.
    #!define biowastePickupIndex tmp1
    biowastePickupIndex = biomorphingResourcePositionList.index(biowastePickupPosition)
    eventPlayer.biomorphingResourceType = biomorphingResourceTypeList[biowastePickupIndex]
    destroyEffect(biomorphingResourceEffectIdList[biowastePickupIndex])
    destroyInWorldText(biomorphingResourceTextIdList[biowastePickupIndex])
    del biomorphingResourceTypeList[biowastePickupIndex]
    del biomorphingResourcePositionList[biowastePickupIndex]
    del biomorphingResourceEffectIdList[biowastePickupIndex]
    del biomorphingResourceTextIdList[biowastePickupIndex]
    eventPlayer.biomorphingResourceAmount = BIOMORPHING_RESOURCE_AMOUNT
    smallMessage(eventPlayer, "  Go to the deposit area!")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 50)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer.getPosition(), 2)


rule "PLAYER DELIVERS RESOURCE VALUE":
    @Event eachPlayer
    @Team 1
    @Condition currentObjectiveType == ObjectiveType.BIOMORPHING
    @Condition eventPlayer.invisibilityCount != true
    @Condition eventPlayer.biomorphingResourceAmount > 0
    @Condition eventPlayer.isAlive() == true
    @Condition distance(currentObjectivePosition, eventPlayer) < objectiveRad
    @Condition eventPlayer.isAfk != true
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    if not eventPlayer in objectivePlayerList:
        objectivePlayerList.append(eventPlayer)
    wait(0.125)
    # biowasteDepositTimeDivisor: deposit-time divisor for ordinary biowaste, used to calculate this tick's progress.
    #!define biowasteDepositTimeDivisor tmp0
    biowasteDepositTimeDivisor = 8.9
    #Extra points if correct biowaste type
    if biomorphingGoalQueueList[0] == eventPlayer.biomorphingResourceType:
        # biowasteDepositTimeDivisor: shorter deposit-time divisor for the requested resource, to award faster progress.
        biowasteDepositTimeDivisor = 2.9
    #Damage player if resource is blood, damage more if above health.
    damage(eventPlayer, eventPlayer, (50.33 if eventPlayer.getHealth() > 200 else 10.33) if biomorphingGoalQueueList[0] == 3 else 0)
    #(Amount per resource / dump time) x tick speed
    eventPlayer.biomorphingResourceAmount -= BIOMORPHING_RESOURCE_AMOUNT / 3 * 0.125
    #(Amount per resource / dump time) x tick speed, if resource is blood then this will go slower x the number of players
    biomorphingCapturePercent += (BIOMORPHING_RESOURCE_AMOUNT / (getNumberOfPlayers(Team.1) * 4.167 if biomorphingGoalQueueList[0] == 3 else biowasteDepositTimeDivisor)) * 0.125
    if biomorphingCapturePercent >= biomorphingNextCheckpoint:
        del biomorphingGoalQueueList[0]
        biomorphingCapturePercent = biomorphingNextCheckpoint
        isBiomorphingGoalPending = true
        biomorphingNextCheckpoint += 25
    if ruleCondition:
        loop()
    if eventPlayer.biomorphingResourceAmount <= 0:
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 75)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.getPosition() + offsetUpQuarterConst, 8)
        smallMessage(eventPlayer, "  Biowaste deposited!")
    objectivePlayerList.remove(eventPlayer)


rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED":
    @Event playerDied
    @Condition currentObjectiveType == ObjectiveType.BIOMORPHING
    @Condition eventPlayer.biomorphingResourceAmount >= BIOMORPHING_RESOURCE_AMOUNT
    @Condition biomorphingGoalQueueList[0] != 3
    
    biomorphingDeferredTypeList.append(eventPlayer.biomorphingResourceType)
    biomorphingDeferredPositionList.append(nearestWalkablePosition(eventPlayer))
    eventPlayer.biomorphingResourceAmount = 0
    eventPlayer.biomorphingResourceType = null


rule "BIOWASTE MANAGEMENT":
    @Condition biomorphingDeferredTypeList != []
    
    while biomorphingDeferredTypeList != []:
        # deferredBiowasteType: first queued biowaste type, passed to biowasteAssignmentMacro to create the dropped orb.
        #!define deferredBiowasteType tmp0
        deferredBiowasteType = biomorphingDeferredTypeList[0]
        # deferredBiowastePosition: matching queued drop position, passed to biowasteAssignmentMacro to place the orb.
        #!define deferredBiowastePosition tmp1
        deferredBiowastePosition = biomorphingDeferredPositionList[0]
        biowasteAssignmentMacro()
        del biomorphingDeferredTypeList[0]
        del biomorphingDeferredPositionList[0]
        wait(0.15)
