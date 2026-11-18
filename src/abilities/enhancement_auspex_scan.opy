#!mainFile "../../main.opy"

enum AuspexScanField:
    OWNER = 0,
    EXPIRY = 1,
    CENTER = 2,
    MARKER_EFFECT = 3,
    NEXT_PULSE = 4,
    NEXT_RING = 5,

#!define auspexMarkOwner(bot) bot.botAuspexMark[0]
#!define auspexMarkExpiry(bot) bot.botAuspexMark[1]

rule "[AUSPEX SCAN] PLACE ON DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.AUSPEX_SCAN)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition getTotalTimeElapsed() >= eventPlayer.auspexReadyAt

    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), AUSPEX_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), AUSPEX_TAP_WINDOW)
    if not ruleCondition:
        return

    # Sample the second press. Cast beyond the range so the miss endpoint fails the range check.
    # Consume the hit before waiting; both visuals snapshot the position.
    #!define auspexPlacementHit tmp0
    auspexPlacementHit = raycastHitPosition(
        eventPlayer.getEyePosition(),
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (AUSPEX_RANGE + 1),
        getLivingPlayers(Team.2), null, false
    )
    if distance(eventPlayer.getEyePosition(), auspexPlacementHit) > AUSPEX_RANGE:
        return

    createEffect(getPlayers(Team.1), Effect.SPHERE, AUSPEX_COLOR, auspexPlacementHit,
        AUSPEX_MARKER_RADIUS, EffectReeval.VISIBILITY)
    auspexScanList[len(auspexScanList)] = [
        eventPlayer, getTotalTimeElapsed() + AUSPEX_SCAN_DURATION, auspexPlacementHit,
        getLastCreatedEntity(), getTotalTimeElapsed() + AUSPEX_SCAN_INTERVAL,
        getTotalTimeElapsed() + AUSPEX_RING_INTERVAL
    ]
    eventPlayer.auspexReadyAt = getTotalTimeElapsed() + AUSPEX_COOLDOWN
    eventPlayer.auspexFlashRadius = 0
    createEffect(getPlayers(Team.1), Effect.SPHERE, AUSPEX_COLOR, evalOnce(auspexPlacementHit),
        eventPlayer.auspexFlashRadius, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.auspexFlashEffect = getLastCreatedEntity()
    chaseOverTime(eventPlayer.auspexFlashRadius, AUSPEX_RADIUS, AUSPEX_FLASH_DURATION, ChaseTimeReeval.NONE)
    wait(AUSPEX_FLASH_DURATION)
    destroyEffect(eventPlayer.auspexFlashEffect)
    stopChasing(eventPlayer.auspexFlashRadius)
    eventPlayer.auspexFlashEffect = null


rule "[AUSPEX SCAN] FLASH DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    if eventPlayer.enhancementId == Enhancement.AUSPEX_SCAN and eventPlayer.auspexFlashEffect != null:
        destroyEffect(eventPlayer.auspexFlashEffect)


rule "[AUSPEX SCAN] PROCESS ACTIVE SPHERES":
    @Condition auspexScanList != []

    # Scratch holds one pass only and is consumed before the scheduler waits.
    #!define auspexWaveTime tmp0
    #!define auspexScan tmp1
    #!define auspexNextWave tmp2
    #!define auspexScanIndex tmp3
    auspexWaveTime = getTotalTimeElapsed()
    if isGameplayActive:
        auspexNextWave = auspexWaveTime + AUSPEX_SCAN_INTERVAL
        for auspexScanIndex in range(len(auspexScanList)):
            auspexScan = auspexScanList[auspexScanIndex]
            if auspexWaveTime >= auspexScan[AuspexScanField.NEXT_PULSE]:
                if entityExists(auspexScan[AuspexScanField.OWNER]):
                    (getPlayersInRadius(auspexScan[AuspexScanField.CENTER], AUSPEX_RADIUS, Team.2, LosCheck.OFF)
                        .filter(lambda bot: bot.isAlive() and bot.isDummy() and (
                            auspexMarkExpiry(bot) <= auspexWaveTime
                            or auspexMarkOwner(bot) == auspexScan[AuspexScanField.OWNER]
                        ))).botAuspexMark = [auspexScan[AuspexScanField.OWNER], auspexWaveTime + AUSPEX_MARK_DURATION]
                    if auspexWaveTime >= auspexScan[AuspexScanField.NEXT_RING]:
                        playEffect(getPlayers(Team.1), DynamicEffect.RING_EXPLOSION, AUSPEX_COLOR,
                            auspexScan[AuspexScanField.CENTER], AUSPEX_RADIUS * 2)
                        auspexScan[AuspexScanField.NEXT_RING] = max(
                            auspexScan[AuspexScanField.NEXT_RING] + AUSPEX_RING_INTERVAL,
                            auspexWaveTime + AUSPEX_SCAN_INTERVAL
                        )
                if auspexWaveTime >= auspexScan[AuspexScanField.EXPIRY]:
                    continue
                # Keep the placement cadence, skipping missed waves on a server stall.
                auspexScan[AuspexScanField.NEXT_PULSE] = min(
                    auspexScan[AuspexScanField.EXPIRY],
                    max(auspexScan[AuspexScanField.NEXT_PULSE] + AUSPEX_SCAN_INTERVAL, auspexWaveTime + AUSPEX_SCAN_INTERVAL / 2)
                )
                auspexScanList[auspexScanIndex] = auspexScan
            auspexNextWave = min(auspexNextWave, auspexScan[AuspexScanField.NEXT_PULSE])

    # Fixed lifetime makes expirations FIFO. Let the final wave apply before destroying the sphere.
    while auspexScanList != [] and (
        not isGameplayActive or auspexWaveTime >= auspexScanList[0][AuspexScanField.EXPIRY]
    ):
        destroyEffect(auspexScanList[0][AuspexScanField.MARKER_EFFECT])
        del auspexScanList[0]

    if auspexScanList != []:
        # Any new sphere's first wave is at least one interval after this pass.
        wait(auspexNextWave - getTotalTimeElapsed())
        loop()


rule "[AUSPEX SCAN] SHOW MARKED ZOMBIE":
    @Event eachPlayer
    @Team 2
    @Condition uiPhaseAndId(auspexMarkExpiry(eventPlayer) > getTotalTimeElapsed())
    @Condition eventPlayer.isAlive() == true

    createIcon(getPlayers(Team.1), eventPlayer.getEyePosition() - vect(0, 0.2, 0),
        Icon.EYE, IconReeval.VISIBILITY_AND_POSITION, AUSPEX_COLOR)
    eventPlayer.botAuspexEyeIcon = getLastCreatedEntity()
    # The expiry remains live, so a refresh keeps the existing icon.
    waitUntil(not isGameplayActive or not eventPlayer.isAlive()
        or auspexMarkExpiry(eventPlayer) <= getTotalTimeElapsed(), Math.INFINITY)
    destroyIcon(eventPlayer.botAuspexEyeIcon)


rule "[AUSPEX SCAN] CREDIT BONUS DAMAGE":
    @Event playerTookDamage
    @Team 2

    # Event eligibility stays in Actions for the native hero-menu workaround.
    if not isGameplayActive or auspexMarkExpiry(eventPlayer) <= getTotalTimeElapsed():
        return
    if attacker.getTeam() != Team.1 or eventDamage <= 0 or not eventPlayer.isAlive():
        return
    # Synchronous damage source. Damage() evaluates it before emitting any follow-up event.
    #!define auspexDamageSource tmp0
    auspexDamageSource = auspexMarkOwner(eventPlayer)
    # Damage() has no Event Ability. Guard only the owner's scripted hits on this
    # victim during the two-tick window in which the bonus can emit a follow-up event.
    if not entityExists(auspexDamageSource) or (
        attacker == auspexDamageSource and eventAbility == null
        and getTotalTimeElapsed() < eventPlayer.botAuspexBonusUntil
    ):
        return
    eventPlayer.botAuspexBonusUntil = getTotalTimeElapsed() + 0.032
    damage(eventPlayer, auspexDamageSource, eventDamage * AUSPEX_BONUS_DAMAGE)
