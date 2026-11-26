#!mainFile "../../main.opy"
subroutine daytakerAbortReset
subroutine applyBriefBurnAndRoot
subroutine reenableBotWallAndJump
subroutine restoreBotThrottle
subroutine beginBotOverride

subroutine startBlasterDaytakerFacing
subroutine playReignitedWarningPair
subroutine startBotThrottleAtTarget

subroutine resumeBotFacingAndMovement
subroutine resumeBotMovementAndFacing
subroutine smolderBoost
subroutine spawnGasCloud
subroutine abilityThrowdown
subroutine entityFloat
subroutine explosionWarning
subroutine selectIndexedAbilityTarget

# Include the Seismic Slam before shared alternate attack control to preserve Workshop rule order.
#!include "zombie_carrion (Jetpack Cat).opy"
#!include "zombie_basic (Reaper).opy"
#!include "zombie_bomber (Junkrat).opy"
#!include "zombie_rusher (Torbjorn).opy"
#!include "zombie_behemoth (Roadhog).opy"
#!include "zombie_brute_slam (Reinhardt).opy"


rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) < 5 * eventPlayer.sizeScale
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.WINSTON, Hero.JUNKER_QUEEN] == true

    if eventPlayer.getHero() == Hero.WINSTON and not eventPlayer.isUsingUltimate():
        return
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.startForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)
    wait(0.25)
    if eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        wait(7.75)
    eventPlayer.setPrimaryFireEnabled(false)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.ABILITY_2 if eventPlayer.getHero() == Hero.JUNKER_QUEEN else Button.PRIMARY_FIRE)


#!include "zombie_brute (Reinhardt).opy"
#!include "zombie_reignited (Anran).opy"
#!include "zombie_rider (Widowmaker).opy"
#!include "zombie_charger (Mauga).opy"
#!include "zombie_slimer (Mercy).opy"
#!include "zombie_prime_slimer (Emre).opy"
#!include "zombie_striker (Wrecking Ball).opy"
#!include "zombie_stalker (Moira).opy"
#!include "zombie_blaster (Pharah).opy"
#!include "zombie_downfallen (Sigma).opy"
#!include "zombie_gladiator (Junker Queen).opy"
#!include "zombie_daytaker (Illari).opy"
#!include "zombie_tunneler (Symmetra).opy"
#!include "zombie_cadaver (Ana).opy"
#!include "zombie_ensnarer (Hazard).opy"
#!include "zombie_smolder (Winston).opy"
#!include "zombie_protector (Kiriko).opy"
#!include "zombie_successor (Doomfist).opy"


rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())) < 20
    @Condition distance(eventPlayer, eventPlayer.botTarget) < 30 * eventPlayer.sizeScale
    @Condition eventPlayer in miniBossList == true
    @Condition eventPlayer.getHero() in [Hero.REINHARDT, Hero.JUNKER_QUEEN, Hero.KIRIKO, Hero.DOOMFIST, Hero.HAZARD] == true

    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.ORANGE, eventPlayer, 2.5)
    wait(0.4)
    eventPlayer.botIsFacingOverridden = true
    eventPlayer.stopFacing()
    eventPlayer.setUltCharge(100)
    if eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.botAbilityCooldown += 4
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(1)
    eventPlayer.forceButtonPress(Button.ULTIMATE if eventPlayer.getHero() in [Hero.JUNKER_QUEEN, Hero.KIRIKO] else Button.ABILITY_1)
    eventPlayer.botIsFacingOverridden = false
    restoreDefaultFacingMovement()
    eventPlayer.applyImpulse((2.5 if eventPlayer.getHero() in [Hero.DOOMFIST, Hero.HAZARD] else 0) * Vector.UP, 5 if eventPlayer.getHero() == Hero.HAZARD else 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isDead(), 15 if eventPlayer.getHero() == Hero.DOOMFIST else 30)
    eventPlayer.setUltCharge(0)


rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer in miniBossList == true
    @Condition (distance(eventPlayer, currentObjectivePosition) <= objectiveRad or len(objectivePositionList) == 1 and eventPlayer.isOnObjective()) == true
    @Condition eventPlayer.getHero() in [Hero.DOOMFIST, Hero.WRECKING_BALL, Hero.MAUGA] == true

    eventPlayer.cancelPrimaryAction()
    eventPlayer.setUltCharge(100)
    wait(0.15)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    if not eventPlayer.isUsingUltimate():
        loop()
    if eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.setMaxHealth(30)
        wait(1)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    if eventPlayer.getHero() == Hero.DOOMFIST and eventPlayer.isUsingUltimate():
        startRule(selectTarget, StartRuleBehavior.NOOP)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(false)
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(true)
    if eventPlayer.getHero() == Hero.MAUGA:
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
        eventPlayer.setMaxHealth(1)
    wait(30)


def abilityThrowdown():
    @Name "abilityThrowdown"

    if eventPlayer.hasStatus(Status.HACKED):
        return
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.startFacing(Vector.DOWN, 999)
    wait(0.3)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.allowButton(Button.MELEE)
    restoreDefaultFacingMovement()
    if eventPlayer.getHero() == Hero.HAZARD:
        wait(0.25)
        if eventPlayer.botIsCrowdControlled or eventPlayer.hasStatus(Status.HACKED):
            return
        (getPlayersInRadius(eventPlayer, 2, Team.2, LosCheck.SURFACES).filter(lambda player: player != eventPlayer)).applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, distance(eventPlayer.botTarget, eventPlayer) * (2 / eventPlayer.sizeScale), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.botAbilityCooldown += 2


def entityFloat():
    @Name "entityFloat"

    # Capture the bot's LoS endpoint once for this synchronous filter.
    #!define floatBotLoSEnd tmp0
    floatBotLoSEnd = eventPlayer.getPosition() + losOffsetConst
    eventPlayer.botSpecialTargetList = getLivingPlayers(Team.ALL).filter(lambda player: (
        player != eventPlayer
        and distance(eventPlayer, player) < 12 * eventPlayer.sizeScale
        and isInLoS(player.getPosition() + losOffsetConst, floatBotLoSEnd, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    ))


def selectIndexedAbilityTarget():
    @Name "selectIndexedAbilityTarget"

    # Read the caller's loop index synchronously and leave it available for the next iteration.
    #!define indexedAbilityTargetIndex tmp0
    eventPlayer.botAbilityTarget = eventPlayer.botSpecialTargetList[indexedAbilityTargetIndex]


def resumeBotMovementAndFacing():
    # Synchronous reset; preserve the caller's throttle-then-facing order and NOOP start.
    eventPlayer.botIsThrottleOverridden = false
    eventPlayer.botIsFacingOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


def resumeBotFacingAndMovement():
    # Synchronous reset; preserve the caller's facing-then-throttle order and NOOP start.
    eventPlayer.botIsFacingOverridden = false
    restoreBotThrottle()


def startBlasterDaytakerFacing():
    @Name "startBlasterDaytakerFacing"

    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botLastTarget.getEyePosition()), 0 if eventPlayer.botIsCrowdControlled or eventPlayer.isOnGround() and eventPlayer.botTarget == null else 100)


def startBotThrottleAtTarget():
    @Name "startBotThrottleAtTarget"

    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.botTarget), eventPlayer.botThrottleSpeed, Relativity.TO_WORLD)


def playReignitedWarningPair():
    @Name "playReignitedWarningPair"

    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 200)
    #Scaled
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer, 0.5 * eventPlayer.sizeScale)


def beginBotOverride():
    @Name "beginBotOverride"

    eventPlayer.botIsThrottleOverridden = true
    eventPlayer.stopThrottleInDirection()
    eventPlayer.botIsFacingOverridden = true


def restoreBotThrottle():
    @Name "restoreBotThrottle"

    eventPlayer.botIsThrottleOverridden = false
    startRule(restoreDefaultFacingMovement, StartRuleBehavior.NOOP)


def applyBriefBurnAndRoot():
    @Name "applyBriefBurnAndRoot"

    eventPlayer.setStatusEffect(null, Status.BURNING, 0.6)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.6)
