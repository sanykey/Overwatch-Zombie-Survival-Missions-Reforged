#!mainFile "../../main.opy"


rule "ENGINEER SCRAP INCOME":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.ENGINEER)
    @Condition eventPlayer.isAlive() == true

    eventPlayer.enhancementScrap = min(ENGINEER_SCRAP_MAX, eventPlayer.enhancementScrap + ENGINEER_SCRAP_PASSIVE_RATE)
    wait(1)
    if ruleCondition:
        loop()


macro transferEngineerArmor():
    # The target resolves on the second press: the visible ally closest to the crosshair
    # in the wide aim cone (within 15m) receives armor, otherwise it goes to self.
    # Use the first candidate immediately. No waits below.
    #!define scrapArmorGrantTarget tmp1
    scrapArmorGrantTarget = sorted(getPlayersInRadius(eventPlayer, ENGINEER_TRANSFER_RANGE, Team.1, LosCheck.SURFACES).filter(lambda ally: ally != eventPlayer and ally.isAlive() and eventPlayer.isInViewAngle(ally.getEyePosition(), ENGINEER_TRANSFER_ANGLE)), lambda x: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), x.getEyePosition())))[0]
    if scrapArmorGrantTarget != null:
        # Aiming at an ally: the action is ally-directed and never falls back to
        # self. Engineer armor caps at ENGINEER_ARMOR_MAX per target across every Engineer
        # donor; a grant is refused only at the full cap.
        if scrapArmorGrantTarget.scrapArmorAmount >= ENGINEER_ARMOR_MAX:
            smallMessage(eventPlayer, "Ally armor is full")
            return
    elif eventPlayer.scrapArmorAmount < ENGINEER_ARMOR_MAX:
        # No ally targeted and room below the cap: self-armor without a beam.
        scrapArmorGrantTarget = eventPlayer
    else:
        return
    # Keep the recipient in tmp1 while tmp0 holds the cost.
    # Synchronous through payment, with no waits or reevaluated readers.
    #!define scrapArmorGrantCost tmp0
    scrapArmorGrantCost = ENGINEER_ARMOR_SELF_COST if scrapArmorGrantTarget == eventPlayer else ENGINEER_ARMOR_ALLY_COST
    if eventPlayer.enhancementScrap < scrapArmorGrantCost:
        smallMessage(eventPlayer, "Not enough scrap")
        return
    eventPlayer.enhancementScrap -= scrapArmorGrantCost
    # Non-recoverable, fixed pool: healing never restores scrap armor. One
    # throw adds at most ENGINEER_ARMOR_STACK armor and tops the target up to the cap;
    # the wasted remainder of a partial refill is the thrower's loss.
    # Payment is complete. Reuse tmp0 for the amount applied to both the pool and the counter.
    #!define scrapArmorGrantAmount tmp0
    scrapArmorGrantAmount = min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount)
    scrapArmorGrantTarget.addHealthPool(Health.ARMOR, scrapArmorGrantAmount, false, false)
    scrapArmorGrantTarget.scrapArmorAmount += scrapArmorGrantAmount
    # Received-armor feedback: the transfer-beam-colored ring plus the turret
    # freeze sound, on the grant target (self or ally). One-shot; no scratch or
    # entity to clean up. The message quotes the full stack constant, so a
    # partial top-up near the cap still announces ENGINEER_ARMOR_STACK armor;
    # an ally transfer names the donor, self-armor stays nameless.
    smallMessage(scrapArmorGrantTarget, f"+{ENGINEER_ARMOR_STACK} armor" if scrapArmorGrantTarget == eventPlayer else f"+{ENGINEER_ARMOR_STACK} armor from {eventPlayer}")
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, scrapArmorGrantTarget, 4)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, scrapArmorGrantTarget, ENGINEER_TRANSFER_RANGE)
    # Self-armor creates no beam. A transfer moves the single beam to the new
    # ally and resets its ENGINEER_BEAM_DURATION lifetime; the endpoint must be a stable player
    # variable, never scratch, because the reevaluating beam reads it every frame.
    if scrapArmorGrantTarget != eventPlayer:
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + ENGINEER_ARMOR_ALLY_ULT_PCT)
        eventPlayer.enhancementScrapBeamTarget = scrapArmorGrantTarget
        if eventPlayer.enhancementScrapBeamEntity != null:
            destroyEffect(eventPlayer.enhancementScrapBeamEntity)
        createBeam(getAllPlayers(), Beam.BAD, eventPlayer, eventPlayer.enhancementScrapBeamTarget, Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.enhancementScrapBeamEntity = getLastCreatedEntity()
        eventPlayer.enhancementScrapBeamDeadline = getTotalTimeElapsed() + ENGINEER_BEAM_DURATION


rule "ENGINEER TURRET DEPLOY":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    @Condition uiPhaseAndId(eventPlayer.enhancementId == Enhancement.ENGINEER)
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false

    # Crouch is reserved for armor. The 0.25s Melee hold matches inventory
    # powerups. Guards run only after a confirmed hold, so taps stay silent.
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.enhancementScrap < ENGINEER_TURRET_COST:
        smallMessage(eventPlayer, "Not enough scrap")
        return
    eventPlayer.enhancementScrap -= ENGINEER_TURRET_COST
    deploySentryTurret()


rule "ENGINEER BEAM FADE":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.enhancementId == Enhancement.ENGINEER
    @Condition eventPlayer.enhancementScrapBeamEntity != null
    @Condition getTotalTimeElapsed() >= eventPlayer.enhancementScrapBeamDeadline

    destroyEffect(eventPlayer.enhancementScrapBeamEntity)
    eventPlayer.enhancementScrapBeamEntity = null
    eventPlayer.enhancementScrapBeamTarget = null


rule "ENGINEER BEAM DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.enhancementId == Enhancement.ENGINEER) and (eventPlayer.enhancementScrapBeamEntity != null):
        # Follow the project's supplied playerLeft cleanup pattern: consume the
        # departing player's effect ID synchronously in the departure event.
        destroyEffect(eventPlayer.enhancementScrapBeamEntity)


rule "ENGINEER SCRAP ARMOR DEPLETION":
    @Event playerTookDamage
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if (eventPlayer.scrapArmorAmount > 0) and (eventDamage > 0):
        # Damage order on armored targets: scrap stacks absorb first, the older
        # recoverable Kevlar pool last. Subtracting the full hit capped at the
        # modeled remainder is therefore exact: overflow into Kevlar and health
        # never touches this mirror, and healing cannot refill the non-recoverable
        # pools.
        eventPlayer.scrapArmorAmount = max(0, eventPlayer.scrapArmorAmount - eventDamage)


macro initializeEngineerMacro():
    # Scrap starts at Workshop's default zero and survives death and hero switches.
    # Only beam state is re-cleaned; death cleanup already destroyed it.
    eventPlayer.enhancementScrapBeamEntity = null
    eventPlayer.enhancementScrapBeamTarget = null


macro clearEngineerBeamOnDeathMacro():
    # Scrap itself survives death; only the transfer beam is torn down.
    destroyEffect(eventPlayer.enhancementScrapBeamEntity)
    eventPlayer.enhancementScrapBeamEntity = null
