// Reviewed ownership/layout and the one-to-one mapping from the pre-refactor player slots.
// No new sharing is introduced. Local roles use tmp0..2; the outline-color slot was removed.
const A = (name, type, description) => ({name, type, description});
const F = (old, name, group, type, description, aliases = []) => ({old, name, group, type, description, aliases});
const groups = {
    bots: 'Team 2 zombies: AI, abilities, bosses and bot visuals',
    team1: 'Team 1 players/allied actors: survival, infection and reconnect state',
    enhancements: 'Enhancements only (enhancement prefix; includes the Rescue Hitchhiker setup)',
    powerups: 'Supply power-ups only (powerUp prefix)',
    pregame: 'Team 1 pregame selection and voting',
    rescue: 'Team 1 Survivor Rescue NPC',
    biomorphing: 'Biomorphing carriers on both teams',
    explosions: 'Explosion presentation shared by zombies and Zombie Hybrid',
    shared: 'Both teams or multiple systems: shared stats, visuals and role-owned storage'
};
const variables = [
    F('averagePlayersPos','botTeleportCenter','bots','vector','Zombie teleport/search center; bot teleport rules, Egg and boss return.'),
    F('targeting','botIsSelectingTarget','bots','bool','selectTarget is running; blocks competing zombie target/teleport work.'),
    F('mutationChase','botReturnMotionSlot','bots','mixed','Boss return timer, then an eye-position snapshot; objective_type_bosses.',[
        A('botReturnTime','number','Seconds without a target before boss return (chased to 15).'),
        A('botReturnPosition','vector','Boss eye-position snapshot written and cleared during return; currently not read.')]),
    F('teleporting','botIsTeleporting','bots','bool','Zombie is inside enterExitTeleport; spawn/target/ability consumers also read it.'),
    F('pForceFieldCount1','powerUpForceFieldTimeRemaining','powerups','number','Remaining Force Field seconds; yielding loop and item HUD in supply_drops.'),
    F('pForceFieldCount2_bCount1','botLoopIndexSlot','bots','number','Existing yielding loop index shared by Stalker fades and Ensnarer blocking.',[
        A('botStalkerFadeIndex','number','Repeated Moira fade/attack index.'), A('botEnsnarerTargetIndex','number','Index into Ensnarer affected targets.')]),
    F('botTarget','botTarget','bots','player','Zombie AI combat target; subroutines, bot abilities and objectives; cleared when its Team 1 target is downed.'),
    F('botThrottleSpeed','aiThrottleSpeedSlot','shared','number','Zombie movement throttle or Team 1 Rescue follow throttle; subroutines, bots and Rescue.',[
        A('botThrottleSpeed','number','Zombie per-hero/boss throttle in the range 0..1.'), A('rescueThrottleSpeed','number','Rescue follow throttle scaled by NPC health.')]),
    F('playerActiveStatus','isPlayerActive','team1','bool','Player has completed initial menu activation; used by voting, roster and downed-player rules.'),
    F('reviving','isReviving','team1','bool','Nearby allies are currently advancing this player\'s revive progress.'),
    F('reviveStartTime','reviveDuration','team1','number','Required revive duration; restored from reconnect data and increased after revives.'),
    F('reviveTimer','recoveryTimeSlot','shared','number','Existing Team 1 revive countdown / Team 2 replacement delay; no additional slot sharing.',[
        A('reviveTimeRemaining','number','Remaining time until a downed Team 1 player is revived.'), A('botRespawnDelay','number','Delay assigned to the next zombie replacement; bosses, objectives and air strike may change it.')]),
    F('interactEntity','powerUpReviveTarget','powerups','player','Dead Team 1 target retained across instantRevive waits.'),
    F('infected','isInfected','team1','bool','Player infection has activated; infection rules, cures and Zombie Hybrid read this flag.'),
    F('biteDamage','botBiteDamage','bots','number','Difficulty/hero-scaled zombie bite damage, also used by zombie abilities and explosions.'),
    F('biteDuration','botBiteDuration','bots','number','Zombie melee damage-over-time duration, including mutation overrides.'),
    F('randVal','rescueMoodIcon','rescue','icon','Rescue NPC mood/status icon: halo, sad, dizzy or extraction celebration.'),
    F('crowdControlled','isCrowdControlled','shared','bool','Set/reset on zombies by stun management; also queried on Team 1 Hitchhiker carriers (default false).'),
    F('deathTimer','rescueTimeRemaining','team1','number','Time left to rescue a downed player; reconnect cache and extraction dome may adjust it.'),
    F('infectionLvl','infectionLevel','team1','number','Player infection/vaccine level; negative values represent vaccination.'),
    F('currentPowerUp','powerUpItemId','powerups','number','Currently carried supply item ID; zero means no item.'),
    F('powerUpTradeValues','powerUpTradeDataList','powerups','array','Trade record: aimed ground position at index 0 and previous item ID at index 2.'),
    F('powerUpEffects','powerUpEntityIdList','powerups','array','Sparse effect/HUD/damage-modification IDs owned by active items, keyed by item ID range.'),
    F('pNoCooldownsCount_bCount2','actorCountdownSlot','shared','number','Existing Team 1 item countdown / Team 2 Charger windup progression.',[
        A('powerUpNoCooldownsTimeRemaining','number','No Cooldowns remaining seconds (15 down to 0).'), A('botChargerWindupProgress','number','Mauga charge windup progression from 0 to 1.')]),
    F('pAirStrikeCount','powerUpAirStrikeIndex','powerups','number','Index of 50 air-strike impacts; retained across waits.'),
    F('specialCooldown','controlStateSlot','shared','mixed','Player crowd-control immunity flag or zombie boss return target; hero_tuning/zombie abilities/Bosses.',[
        A('isCrowdControlCooldownActive','bool','Team 1 immunity window after Brute/Downfallen control.'), A('botReturnTarget','player','Boss return target retained across the return animation.')]),
    F('chase1','actorMotionSlot1','shared','mixed','Existing per-hero numeric/vector chase or Rescue extraction position; no change to chase lifetime.',[
        A('botGasProjectilePosition','vector','Behemoth traveling gas projectile position.'), A('botTentaclePosition','vector','Slimer chased tentacle endpoint.'),
        A('botBlasterCharge','number','Pharah rocket charging progression.'), A('botDaytakerCharge','number','Illari burst charging progression.'),
        A('botSmolderAnger','number','Winston anger/enrage progression; initialized to 2.'), A('botEnsnarerMeleeAngle','number','Hazard boss melee aiming offset, chased from -20 to 25.'),
        A('rescueExtractionPosition','vector','Rescue NPC flight position chased upward after reaching extraction.')]),
    F('chase2','actorMotionSlot2','shared','mixed','Team 2 toxic-cloud duration or Team 1 extraction flight position.',[
        A('botGasCloudTimeRemaining','number','Normal Behemoth toxic-cloud duration.'), A('extractionFlightPosition','vector','Player position chased through the extraction flight stages.')]),
    F('botFollowTarget','rescueLeader','rescue','player','Team 1 player followed by the Rescue NPC; bot teleport logic reads the NPC\'s field.'),
    F('botTempvalue2','actorAbilitySlot2','shared','mixed','Existing zombie secondary state or temporary Rescue follow message.',[
        A('botAuxiliaryState','mixed','Common reset/secondary zombie state.'), A('rescueFollowMessage','string','Temporary follower-selection message above the Rescue NPC.'),
        A('botIsReigniteActive','bool','Anran resurrection pulse is active; spawning zombies query this flag.'), A('botIsEnsnarerMeleeActive','bool','Hazard boss melee sequence is in progress.')]),
    F('playerMenuStatus','pregameVoteList','pregame','array','Player votes indexed by PlayerMenuStatusField; slots 0 and 1 stay unused.'),
    F('startPos','team1PositionSlot','team1','vector','Team 1 hero-selection position or Rescue NPC path origin.',[
        A('pregamePosition','vector','Per-player position in the pregame hero-selection scene.'), A('rescueStartPosition','vector','Rescue NPC spawn/path origin used by its progress HUD.')]),
    F('successfullyTeleported','botIsTeleportConfirmed','bots','bool','Zombie teleport/spawn position has been accepted and may be added to the spawn cache.'),
    F('biowasteType','biomorphingResourceType','biomorphing','number','Material type carried by a player or zombie; null when empty and 3 for the blood goal.'),
    F('anranPortal','botReigniteDestination','bots','vector','Zombie emergence destination near Anran; false clears the position after the rise.'),
    F('evacPos','extractionDestination','team1','vector','Per-player final flight destination, calculated from the shared extraction direction.'),
    F('canWallPhase','botIsWallPhaseAllowed','bots','bool','Zombie may pass spawn doors; special abilities temporarily disable this permission.'),
    F('pHealBeaconCount','powerUpHealBeaconTimeRemaining','powerups','number','Remaining healing-beacon seconds; loop and HUD.'),
    F('pSentryTurretCount','powerUpTurretTimeRemaining','powerups','number','Remaining sentry-turret seconds; loop and HUD.'),
    F('initialMaxHealth','initialMaxHealth','shared','number','Cached native/player maximum health before custom scaling; used by infection and Hitchhiker health pools.'),
    F('botSpecialTarget','botAbilityTarget','bots','player','Zombie special-ability target: teleport/grab host, flight target or affected player.'),
    F('attached','isAttached','shared','bool','Actor is attached to a host; zombie attachment and Team 1 Hitchhiker share the same meaning.',[
        A('botIsAttached','bool','Zombie is attached to another actor.'), A('enhancementIsHitchhiking','bool','Hitchhiker passenger is attached; shared Team 1 carrier queries use isAttached.')]),
    F('telePos','botTeleportPosition','bots','vector','Zombie teleport candidate/accepted position; bot teleport rules, Egg and spawn-cache updates; zero clears it.'),
    F('invisible','invisibilityCount','team1','number','Stacking invisibility/untargetability counter; hero abilities and Cloaking Device increment/decrement it. Not a boolean.'),
    F('pCloakingDeviceCount','powerUpCloakTimeRemaining','powerups','number','Remaining cloak seconds and early-cancel threshold.'),
    F('path','rescuePathList','rescue','array','Recorded leader positions followed and trimmed by the Rescue NPC.'),
    F('potentialTargets','candidateTargetList','shared','array','Boss target-visibility snapshot, Rescue leader candidates or barricade collision targets; downed-player cleanup removes invalid candidates.',[
        A('botPotentialTargetList','array','Final selectTarget candidate snapshot, retained for reevaluated boss-distance-text visibility; cleared on bot death/boss initialization.'),
        A('rescuePotentialLeaderList','array','Team 1 Rescue NPC leader candidates, retained for GROUP UP handling.'), A('enhancementBarrierTargetList','array','Zombies crossing the player\'s barricade, processed synchronously.')]),
    F('pSuperNanoCount','powerUpSuperNanoTimeRemaining','powerups','number','Remaining Super Nano seconds; yielding loop and HUD.'),
    F('size','sizeScale','shared','number','Actor size multiplier; shared by players, zombies, Rescue, item ranges and enhancements.'),
    F('bossHealth','botBossHealth','bots','number','Virtual boss/egg health adjusted by damage events; -1 when not a boss.'),
    F('wallCollisionEnabled','botIsWallCollisionEnabled','bots','bool','Cached zombie environment-collision state, restored by abilities and spawn-door handling.'),
    F('specialFacing','botIsFacingOverridden','bots','bool','Special zombie ability controls facing instead of normal target tracking.'),
    F('specialThrottling','botIsThrottleOverridden','bots','bool','Special zombie ability controls movement instead of the normal AI throttle.'),
    F('botTempValue','actorAbilitySlot1','shared','mixed','Existing per-zombie ability state or Team 1 Rescue extraction flag.',[
        A('botAbilityState','mixed','Generic state reset in botRespawnInitialization.'), A('rescueIsExtracting','bool','Rescue NPC has reached extraction and started its flight.'),
        A('botIsBomberPrimed','bool','Bomber self-destruct has been armed.'), A('botRusherHealthPoolId','number','Temporary Rusher boss health-pool ID.'),
        A('botGasAimPosition','vector','Behemoth gas projectile destination.'), A('botIsReigniteAttackUsed','bool','Anran ultimate attack has been consumed.'),
        A('botRiderGrapplePosition','vector','Widowmaker grapple hit position.'), A('botChargerDestination','vector','Optional saved Mauga charge destination.'),
        A('botTentacleTargetPosition','vector','Slimer tentacle destination or null while idle.'), A('botIsStrikerStrikeActive','bool','Wrecking Ball special pile-driver sequence is active; null clears it.'),
        A('botIsDownfallenGrabbing','bool','Sigma grab sequence is active.'), A('botIsEnsnarerBlocking','bool','Hazard blocking sequence is active.'),
        A('botSmolderState','number','Winston enrage/slam state 0, 1 or 2; intentionally not a boolean.')]),
    F('objectiveValue','objectiveTypeSnapshot','shared','number','Last objective type whose per-actor visuals were initialized; used on both teams.'),
    F('generalPlayerBotEntities','visualEntityIdList','shared','array','Zombie effects or Team 1 objective icons retained for yielding cleanup.',[
        A('botVisualEntityIdList','array','Per-zombie effects created by bot entity management/mutations.'), A('playerObjectiveIconIdList','array','Team 1 objective icons removed by player objective visual management.')]),
    F('entityCount','visualCleanupIndex','shared','number','Per-actor effect/icon cleanup index; the loops yield and cannot use global scratch.'),
    F('botHero','botConfiguredHero','bots','hero','Last zombie hero for which bot entity/stat initialization was performed.'),
    F('playerObjectiveResourceValue','biomorphingResourceAmount','biomorphing','number','Biowaste amount carried by either team; Team 1 deposits it and blood uses sentinel 9999.'),
    F('pBouncePadCount1','actorLoopSlot','shared','number','Existing Ensnarer melee loop index / Bounce Pad duration.',[
        A('botEnsnarerUltimateIndex','number','Repeated Hazard boss ultimate index.'), A('powerUpBouncePadTimeRemaining','number','Remaining Bounce Pad seconds.')]),
    F('infectionDamage','infectionDamageOverTimeId','team1','number','Active player infection damage-over-time ID; Zombie Hybrid stops this same damage instance.'),
    F('botSpecialPotentialTargets','abilityTargetList','shared','array','Zombie special-ability targets or common zombie/Hybrid explosion targets.',[
        A('botSpecialTargetList','array','Targets affected by zombie grabs, clouds, flight and slam abilities.'), A('explosionTargetList','array','Targets of explosionSequence, called by zombies and Team 1 Zombie Hybrid.')]),
    F('movementSpeed','movementSpeedScale','shared','number','Movement-speed multiplier used by zombie AI, players/Rescue, crowd control and supply items.'),
    F('mutationValue','botMutationId','bots','number','Selected mutation ID; zero means no mutation.'),
    F('health','botBaseHealth','bots','number','Configured zombie maximum health, including mutations/boss overrides and recoil thresholds.'),
    F('damageOverTimeDuration','damageOverTimeRemaining','shared','number','Tracked DoT duration, normally chased on zombies; one Rusher rule writes it on the victim. Preserve that receiver.'),
    F('pUltimateChargerCount','powerUpUltimateTimeRemaining','powerups','number','Remaining Ultimate Charger seconds; loop and HUD.'),
    F('pStunCount','powerUpStunBouncesRemaining','powerups','number','Remaining stun-chain steps, also scaling the terminal stun duration.'),
    F('initializing','botIsInitializing','bots','bool','Zombie respawn/stat initialization is in progress; spawn/teleport/objective rules wait for it.'),
    F('userIndex','reconnectUserIndex','team1','number','Player name index into userNameList/playerStatsList for reconnect restoration.'),
    F('knockbackRecieved','botKnockbackScale','bots','number','Zombie knockback-received multiplier, including Brute/mutation adjustments.'),
    F('pStunChase1','powerUpStunBeamPosition','powerups','vector','Chased stun-chain beam endpoint retained across bounces/waits.'),
    F('customTelePos','botCustomTeleportPosition','bots','vector','Special zombie replacement position carried from customTeleportPositionList; null when unused.'),
    F('lastTarget','botLastTarget','bots','player','Last visible/attacking target retained when zombie line of sight is lost.'),
    F('abilityArray1','botAbilityStateSlot','bots','mixed','Zombie ability cooldown number or Behemoth cloud-position array; not always an array.',[
        A('botAbilityCooldown','number','Remaining shared zombie special-ability cooldown.'), A('botGasPositionList','array','Boss Behemoth active gas-cloud positions.')]),
    F('abilityArray2','botGasRadiusList','bots','array','Boss Behemoth gas-cloud radii, aligned with botGasPositionList.'),
    F('waypoint','botSpawnWaypoint','bots','vector','Movement waypoint associated with the accepted zombie spawn point.'),
    F('testTarget','botCandidateTarget','bots','player','Candidate zombie target under line-of-sight testing in selectTarget.'),
    F('canTeleport','botIsTeleportAllowed','bots','bool','Zombie initialization has enabled teleport processing.'),
    F('explosionColor1','explosionInnerColor','explosions','color','Inner explosion color shared by ordinary zombies and Zombie Hybrid.'),
    F('explosionColor2','explosionOuterColor','explosions','color','Outer explosion color shared by ordinary zombies and Zombie Hybrid.'),
    F('afk','isAfk','team1','bool','Player is treated as inactive/AFK and excluded from objectives or extraction counts.'),
    F('explosionSize','explosionScale','explosions','number','Explosion radius/sound multiplier; zombie warning setup and Hybrid initialization assign it.'),
    F('switchedHeroes','isHeroSwitchRespawn','team1','bool','Player has switched heroes; prevents repeating first-spawn and enhancement initialization.'),
    F('anranPortalRise','botReigniteRisePosition','bots','vector','Zombie emergence position chased upward near Anran; zombie_types forces this position across the rise wait.'),
    F('botResourceEntity','botResourceIconIdList','bots','array','Zombie Biomorphing resource icon IDs; separate from the zombie visual-effect list.'),
    F('enhancementId','enhancementId','enhancements','number','Selected Enhancement enum; pregame selection, runtime behavior and Rescue Hitchhiker initialization.'),
    F('enhancementValue1','enhancementStateSlot1','enhancements','mixed','Primary enhancement state; each enhancement owns a distinct role alias.',[
        A('enhancementHybridCooldown','number','Zombie Hybrid explosion cooldown in seconds.'), A('enhancementBarrierFacing','vector','Barrier placement facing direction.'),
        A('enhancementPyroHitList','array','Pyrotechnic hit queue; repeated targets determine fire damage.'), A('enhancementPlagueCureTotal','number','Total infection levels cured by Plague Doctor.'),
        A('enhancementIsBattleResetReady','bool','Born to Battle has an unspent ability reset.'), A('enhancementBatteryPosition','vector','Placed Charge Battery position; zero clears it.'),
        A('enhancementHitchhikerCarrier','player','Hitchhiker carrier; zero when detached.'), A('enhancementPupColor','color','P.U.P. mode color.')]),
    F('enhancementValue2','enhancementStateSlot2','enhancements','mixed','Secondary enhancement state shared by mutually selected enhancements.',[
        A('enhancementBarrierEdgeDirection','vector','Direction from the first barrier corner toward the second.'), A('enhancementBattleAbilityButton','button','Born to Battle button whose charge/cooldown is reset.'),
        A('enhancementBatteryReuseCooldown','number','Battery remaining reuse cooldown.'), A('enhancementHitchhikerPassengerPoolId','number','Extra health-pool ID on the Hitchhiker passenger.'),
        A('enhancementIsPupBeamActive','bool','P.U.P. attack beam is active.')]),
    F('enhancementValue3','enhancementStateSlot3','enhancements','mixed','Barrier cooldown, battery reuse duration, or P.U.P. target.',[
        A('enhancementBarrierPlacementCooldown','number','Barrier remaining placement cooldown.'), A('enhancementBatteryReuseDuration','number','Full battery reuse cooldown used for progress scaling (10 seconds).'), A('enhancementPupTarget','player','Current P.U.P. enemy target; null while idle.')]),
    F('enhancementValue4','enhancementStateSlot4','enhancements','mixed','Barrier center, battery placement timer, or P.U.P. freeze-aura flag.',[
        A('enhancementBarrierPosition','vector','Placed barrier center.'), A('enhancementBatteryPlacementCooldown','number','Battery remaining placement cooldown.'), A('enhancementIsPupFreezeAuraActive','bool','P.U.P. freezing aura is visible.')]),
    F('enhancementValue5','enhancementPositionSlot','enhancements','vector','Barrier first corner or chased P.U.P. position.',[
        A('enhancementBarrierCorner1','vector','Barrier first lower corner.'), A('enhancementPupPosition','vector','Chased P.U.P. world position.')]),
    F('enhancementValue6','enhancementStateSlot6','enhancements','mixed','Barrier second corner or P.U.P. ability cooldown.',[
        A('enhancementBarrierCorner2','vector','Barrier second lower corner.'), A('enhancementPupCooldown','number','P.U.P. remaining ability cooldown (1 or 2 seconds).')]),
    F('enhancementValue7','enhancementBarrierHealth','enhancements','number','Laser Barricade health; placement, collision damage, regeneration and HUD.'),
    F('hitchhikerPassenger','enhancementHitchhikerPassenger','enhancements','player','Passenger attached to this carrier; null when absent. Infection rules also query it.'),
    F('hitchhikerCarrierHealthPool','enhancementHitchhikerCarrierPoolId','enhancements','number','Extra health-pool ID granted to a Hitchhiker carrier, retained for removal.'),
    F('sentryTurretPosition','powerUpTurretPosition','powerups','vector','Placed sentry-turret position; zero clears it.'),
    F('stunTarget','powerUpStunTarget','powerups','player','Next zombie hit by the active stun chain.'),
    F('healBeaconPosition','powerUpHealBeaconPosition','powerups','vector','Placed healing-beacon position; zero clears it.'),
    F('forceFieldPosition','powerUpForceFieldPosition','powerups','vector','Placed Force Field position; zero clears it.'),
    F('bouncePadPosition','powerUpBouncePadPosition','powerups','vector','Placed Bounce Pad ground position.'),
    F('stunOrigin','powerUpStunOrigin','powerups','player','Current beam origin in the stun chain: wearer first, then previous target.'),
    F('sentryTurretDirection','powerUpTurretDirection','powerups','vector','Current sentry firing direction, captured by turret visuals and raycasts.'),
    F('airStrikePosition','powerUpAirStrikePosition','powerups','vector','Ground center of the active air-strike area.'),
    F('powerUpTradeIndex','powerUpTradeIndex','powerups','number','Index of the aimed ground item in the global supply item arrays.'),
    F('pregameState','pregameState','pregame','number','PregameState hero-selection/readiness state; zero is also the late-join default.'),
    F('isVoting','isPregameVoting','pregame','bool','This Team 1 player is adjusting votes; separate from global isVoting.')
];
module.exports = {baselineRef: '9185ddd9b8bc76852ffacdafbfde932a3970f152', groups, variables};
