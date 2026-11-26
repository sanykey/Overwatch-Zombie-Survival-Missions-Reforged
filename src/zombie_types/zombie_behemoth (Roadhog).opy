#!mainFile "../../main.opy"

rule "BEHEMOTH (ROAD) TOXIC CLOUD":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition not eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    @Condition (eventPlayer in bossStateList or eventPlayer.getNormalizedHealth() < 0.5) == true

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAbilityResource(Button.ABILITY_2, 100)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    eventPlayer.botGasCloudTimeRemaining = 1.5
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.5)
    chaseAtRate(eventPlayer.botGasCloudTimeRemaining, 0, 1, ChaseRateReeval.NONE)
    while eventPlayer.botGasCloudTimeRemaining and not eventPlayer.getAbilityCooldown(Button.ABILITY_2):
        if eventPlayer in bossStateList:
            #Charge Ultimate For Boss Gas Attack
            eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)
            eventPlayer.setStatusEffect(eventPlayer, Status.ROOTED, 0.26)
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3)
        else:
            #Gas Attack
            (playerTargetList.filter(lambda x: not x.isDotProtected and isInLoS(eventPlayer.getEyePosition(), x.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, x) < 10 * eventPlayer.sizeScale and x.getEyePosition().y - eventPlayer.getPosition().y > 0 and x.getPosition().y - eventPlayer.getPosition().y < 2 * eventPlayer.sizeScale)).startDamageOverTime(eventPlayer, 2.5, eventPlayer.botBiteDamage * 0.231)
            eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, 2.5)
            eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
        waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, 0.25)
    #Cooldown
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 3 if eventPlayer in bossStateList else 8)
    eventPlayer.botGasCloudTimeRemaining = 0
    stopChasing(eventPlayer.botGasCloudTimeRemaining)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    if eventPlayer in bossStateList and eventPlayer.getUltCharge() >= 100:
        eventPlayer.setUltCharge(0)
        beginBotOverride()
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 1500 if eventPlayer.botIsAttached else 0 if eventPlayer.botIsCrowdControlled or eventPlayer.botTarget == null else 100)
        wait(1)
        waitUntil(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition())) < 5, 5)
        eventPlayer.stopFacing()
        eventPlayer.setStatusEffect(null, Status.STUNNED, 1)
        waitUntil(not eventPlayer.botIsCrowdControlled, 2)
        eventPlayer.botGasProjectilePosition = eventPlayer.getEyePosition()
        eventPlayer.botGasAimPosition = raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20 * eventPlayer.sizeScale, null, getAllPlayers(), false)
        #Launch Gas Projectile
        chaseAtRate(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition, 20 * eventPlayer.sizeScale / 3, ChaseRateReeval.NONE)
        resumeBotFacingAndMovement()
        #Gas Cloud Positions
        eventPlayer.botGasPositionList = []
        #Gas Cloud Areas of Effect
        eventPlayer.botGasRadiusList = []
        while distance(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition) > 0.1 and len(eventPlayer.botGasPositionList) < 3:
            spawnGasCloud()
            waitUntil(distance(eventPlayer.botGasProjectilePosition, eventPlayer.botGasAimPosition) <= 0.1 or len(eventPlayer.botGasPositionList) >= 3, 0.9)
        #If projectile hits wall
        if len(eventPlayer.botGasPositionList) < 3:
            spawnGasCloud()
        stopChasing(eventPlayer.botGasProjectilePosition)
        eventPlayer.botGasProjectilePosition = null
        waitUntil(eventPlayer.isDead(), 3)
        wait(5)
        eventPlayer.botGasPositionList = []
        eventPlayer.botGasRadiusList = []
    if ruleCondition:
        loop()


rule "BEHEMOTH GAS STREAM (BOSS)":
    @Event eachPlayer
    @Team 2
    @Hero roadhog
    @Condition eventPlayer.botGasPositionList != []

    eventPlayer.botSpecialTargetList = []
    # behemothGasCloudIndex: gas-cloud index, to expand its radius and collect newly hit players.
    #!define behemothGasCloudIndex tmp0
    for behemothGasCloudIndex in range(len(eventPlayer.botGasPositionList)):
        if eventPlayer.botGasRadiusList[behemothGasCloudIndex] < 6 * eventPlayer.sizeScale:
            eventPlayer.botGasRadiusList[behemothGasCloudIndex] += 0.2 * eventPlayer.sizeScale
        # Capture this cloud's position and post-growth radius; consume both before the tick wait.
        # Visual effects keep reading the original arrays so they continue to reevaluate normally.
        #!define behemothGasCloudPosition tmp1
        #!define behemothGasCloudRadius tmp2
        behemothGasCloudPosition = eventPlayer.botGasPositionList[behemothGasCloudIndex]
        behemothGasCloudRadius = eventPlayer.botGasRadiusList[behemothGasCloudIndex]
        eventPlayer.botSpecialTargetList.append(playerTargetList.filter(lambda x: not x in eventPlayer.botSpecialTargetList and not x.isDotProtected and distance(behemothGasCloudPosition, vect(x.getEyePosition().x, behemothGasCloudPosition.y, x.getEyePosition().z)) < behemothGasCloudRadius and abs(behemothGasCloudPosition.y - x.getEyePosition().y) < behemothGasCloudRadius / 5))
    eventPlayer.botSpecialTargetList.startDamageOverTime(eventPlayer, 2.5, eventPlayer.botBiteDamage * 0.1)
    if eventPlayer.damageOverTimeRemaining < 2.5 and eventPlayer.botSpecialTargetList != []:
        eventPlayer.damageOverTimeRemaining = 2.5
    wait(0.25)
    if ruleCondition:
        loop()

def spawnGasCloud():
    eventPlayer.botGasPositionList.append(eventPlayer.botGasProjectilePosition)
    eventPlayer.botGasRadiusList.append(0)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 0.4 * eventPlayer.sizeScale)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer.botGasProjectilePosition, 75)
