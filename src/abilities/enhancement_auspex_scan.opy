#!mainFile "../../main.opy"

subroutine applyAuspexPulse

enum AuspexScanField:
    OWNER = 0,
    EXPIRY = 1,
    CENTER = 2,
    NEXT_PULSE = 3,
    NEXT_RING = 4,

#!define auspexMarkOwner(bot) bot.botAuspexMark[0]
#!define auspexMarkExpiry(bot) bot.botAuspexMark[1]

# The pulse reads both scratch inputs synchronously and leaves them intact.
#!define auspexWaveTime tmp0
#!define auspexScan tmp1

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
    # The beam and scan row snapshot the hit before tmp0 becomes the wave time.
    #!define auspexPlacementHit tmp0
    auspexPlacementHit = raycastHitPosition(
        eventPlayer.getEyePosition(),
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (AUSPEX_RANGE + 1),
        getLivingPlayers(Team.2), null, false
    )
    if distance(eventPlayer.getEyePosition(), auspexPlacementHit) > AUSPEX_RANGE:
        return

    createBeam(getPlayers(Team.1), Beam.BAD, eventPlayer, auspexPlacementHit, AUSPEX_COLOR, EffectReeval.NONE)
    eventPlayer.enhancementAttackBeamEntity = getLastCreatedEntity()
    auspexScan = [
        eventPlayer, getTotalTimeElapsed() + AUSPEX_SCAN_DURATION, auspexPlacementHit,
        getTotalTimeElapsed() + AUSPEX_SCAN_INTERVAL,
        getTotalTimeElapsed() + AUSPEX_RING_INTERVAL
    ]
    auspexScanList[len(auspexScanList)] = auspexScan
    eventPlayer.auspexReadyAt = getTotalTimeElapsed() + AUSPEX_COOLDOWN
    auspexWaveTime = getTotalTimeElapsed()
    applyAuspexPulse()

    wait(BOLT_STRIKE_BEAM_DURATION, Wait.IGNORE_CONDITION)
    destroyEffect(eventPlayer.enhancementAttackBeamEntity)
    eventPlayer.enhancementAttackBeamEntity = null


def applyAuspexPulse():
    @Name "applyAuspexPulse"

    (getPlayersInRadius(auspexScan[AuspexScanField.CENTER], AUSPEX_RADIUS, Team.2, LosCheck.OFF)
        .filter(lambda bot: bot.isAlive() and bot.isDummy() and (
            auspexMarkExpiry(bot) <= auspexWaveTime
            or auspexMarkOwner(bot) == auspexScan[AuspexScanField.OWNER]
        ))).botAuspexMark = [auspexScan[AuspexScanField.OWNER], auspexWaveTime + AUSPEX_MARK_DURATION]
    # The Bosses objective shares its state slot with the Zombie Egg objective.
    (getPlayersInRadius(auspexScan[AuspexScanField.CENTER], AUSPEX_RADIUS, Team.2, LosCheck.OFF)
        .exclude(bossesStateList[0] if currentObjectiveType == ObjectiveType.BOSSES else null)
        .filter(lambda zombie: zombie.isAlive())).setStatusEffect(
            auspexScan[AuspexScanField.OWNER], Status.HACKED, AUSPEX_MARK_DURATION)


rule "[AUSPEX SCAN] PROCESS ACTIVE SCANS":
    @Condition auspexScanList != []

    # Scratch holds one pass only and is consumed before the scheduler waits.
    #!define auspexNextWave tmp2
    #!define auspexScanIndex tmp3
    auspexWaveTime = getTotalTimeElapsed()
    if isGameplayActive:
        auspexNextWave = auspexWaveTime + AUSPEX_SCAN_INTERVAL
        for auspexScanIndex in range(len(auspexScanList)):
            auspexScan = auspexScanList[auspexScanIndex]
            if auspexWaveTime >= auspexScan[AuspexScanField.NEXT_PULSE]:
                if entityExists(auspexScan[AuspexScanField.OWNER]):
                    applyAuspexPulse()
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

    # Fixed lifetime makes expirations FIFO. Apply the final wave before dropping the scan.
    while auspexScanList != [] and (
        not isGameplayActive or auspexWaveTime >= auspexScanList[0][AuspexScanField.EXPIRY]
    ):
        del auspexScanList[0]

    if auspexScanList != []:
        # New scans pulse at placement. Their next wave is at least one interval after this pass.
        wait(auspexNextWave - getTotalTimeElapsed())
        loop()


rule "[AUSPEX SCAN] CREDIT BONUS DAMAGE":
    @Event playerTookDamage
    @Team 2

    # Event eligibility stays in Actions for the native hero-menu workaround.
    if not isGameplayActive or auspexMarkExpiry(eventPlayer) <= getTotalTimeElapsed():
        return
    if attacker.getTeam() != Team.1 or eventDamage <= 0 or not eventPlayer.isAlive():
        return
    # Separate windows per attacker allow overlapping hits on the same zombie.
    # Workshop Damage() has no Event Ability, so native hits bypass the guard.
    if eventAbility == null and getTotalTimeElapsed() < eventPlayer.botAuspexBonusUntil[attacker.getSlot()]:
        return

    # Both scratch values are consumed synchronously before damage can emit another event.
    #!define auspexChargeOwner tmp0
    #!define auspexBonusDamage tmp1
    auspexChargeOwner = auspexMarkOwner(eventPlayer)
    if not entityExists(auspexChargeOwner):
        return
    auspexBonusDamage = eventDamage * (AUSPEX_BOSS_BONUS_DAMAGE if eventPlayer in bossStateList or eventPlayer in miniBossList else AUSPEX_BONUS_DAMAGE)
    if attacker != auspexChargeOwner:
        auspexChargeOwner.setUltCharge(auspexChargeOwner.getUltCharge() + auspexBonusDamage * AUSPEX_ULT_PCT_PER_BONUS_DAMAGE)
    eventPlayer.botAuspexBonusUntil[attacker.getSlot()] = getTotalTimeElapsed() + 0.032
    damage(eventPlayer, attacker, auspexBonusDamage)
