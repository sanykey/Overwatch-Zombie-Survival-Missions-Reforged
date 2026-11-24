#!mainFile "../../main.opy"

subroutine resetBattleAbilityCharge
subroutine startPupDefaultChase
subroutine resetPupColorAndBeam
subroutine applyBulkingSeasonStats

#!include "enhancement_zombie_hybrid.opy"
#!include "enhancement_pyrotechnic.opy"
#!include "enhancement_born_to_battle.opy"
#!include "enhancement_bulking_season.opy"
#!include "enhancement_brain_killer.opy"
#!include "enhancement_overcharge.opy"
#!include "enhancement_bolt_strike.opy"
#!include "enhancement_plague_doctor.opy"

def checkEnhancementPlacement():
    # Synchronous output only: no waits, asynchronous work or nested calls before the caller reads tmp0.
    # Keep the 31 m validation ray separate from each caller's 30 m placement ray and its player filters.
    # The caller must return on rejection; returning here alone would not cancel placement.
    isEnhancementPlacementInvalid = distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30 or eventPlayer.isDead()

#!include "enhancement_hitchhiker.opy"
#!include "enhancement_pup.opy"

rule "ENHANCEMENT ATTACK BEAM DISCONNECT CLEANUP":
    @Event playerLeft
    @Team 1

    # Event eligibility stays synchronous; WORKSHOP_NATIVE_UI_CORRUPTION.md.
    if eventPlayer.enhancementId in [Enhancement.WRESTLER, Enhancement.BOLT_STRIKE, Enhancement.AUSPEX_SCAN] and eventPlayer.enhancementAttackBeamEntity != null:
        destroyEffect(eventPlayer.enhancementAttackBeamEntity)

#!include "enhancement_wrestler.opy"
#!include "enhancement_engineer.opy"
#!include "enhancement_auspex_scan.opy"

rule "ENHANCEMENT DOUBLE CROUCH":
    @Event eachPlayer
    @Team 1
    @Condition isGameplayActive == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), ENHANCEMENT_CROUCH_TAP_WINDOW)
    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH), ENHANCEMENT_CROUCH_TAP_WINDOW)
    if not ruleCondition:
        return
    if eventPlayer.enhancementId == Enhancement.BOLT_STRIKE:
        useBoltStrike()
    elif eventPlayer.enhancementId == Enhancement.ENGINEER:
        transferEngineerArmor()
    elif eventPlayer.enhancementId == Enhancement.AUSPEX_SCAN:
        useAuspexScan()
    elif eventPlayer.enhancementId == Enhancement.OVERCHARGE:
        armOvercharge()
    elif eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        useZombieHybridExplosion()
    elif eventPlayer.enhancementId == Enhancement.BULKING_SEASON:
        toggleBulkingSeasonSize()
    elif eventPlayer.enhancementId == Enhancement.WRESTLER:
        useWrestlerPull()
    elif eventPlayer.enhancementId == Enhancement.HITCHHIKER:
        toggleHitchhikerAttachment()

#!include "enhancement_charge_battery.opy"


macro initializePlayerEnhancement():
    if eventPlayer.enhancementId == Enhancement.NO_PREFERENCE:
        # No preference and late-join zero state roll once for the current hero.
        # Hybrid/Bulking Season are tank-only and Plague Doctor/Overcharge are support-only.
        # Hitchhiker is after both upper bounds. Explicit choices and later spawns retain the ID.
        eventPlayer.enhancementId = random.randint(
            Enhancement.ZOMBIE_HYBRID if eventPlayer.getHero() in getTankHeroes() else Enhancement.BRAIN_KILLER,
            Enhancement.OVERCHARGE if eventPlayer.getHero() in getSupportHeroes() else Enhancement.AUSPEX_SCAN
        )
    #Zombie Hybrid
    if eventPlayer.enhancementId == Enhancement.ZOMBIE_HYBRID:
        initializeZombieHybridMacro()
    #Infection reduced if not selected
    else:
        chaseAtRate(eventPlayer.infectionLevel, 0, 0.015 if eventPlayer.infectionLevel > 0 else 0)
    switch eventPlayer.enhancementId:
        #Pyrotechnic
        case Enhancement.PYROTECHNIC:
            initializePyrotechnicMacro()
            break
        #Plague Doctor
        case Enhancement.PLAGUE_DOCTOR:
            initializePlagueDoctorMacro()
            break
        case Enhancement.OVERCHARGE:
            initializeOverchargeMacro()
            break
        case Enhancement.BULKING_SEASON:
            initializeBulkingSeasonMacro()
            break
        case Enhancement.WRESTLER:
            initializeWrestlerMacro()
            break
        #Engineer
        case Enhancement.ENGINEER:
            initializeEngineerMacro()
            break
        #Born to Battle
        case Enhancement.BORN_TO_BATTLE:
            initializeBornToBattleMacro()
            break
        #Charge Battery
        case Enhancement.CHARGE_BATTERY:
            initializeChargeBatteryMacro()
            break
        #P.U.P.
        case Enhancement.PUP:
            initializePupMacro()
