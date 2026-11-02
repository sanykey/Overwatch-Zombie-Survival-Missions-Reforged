# Переменные игрока — 2026-11-02

**74 физических playervar, 99 globalvar, 27211 элементов.** Освобождены 33 слота относительно 107 полей ревизии `e83b831b2e182e0e6bc7fff6e0dad80946e556e8`; 130 смысловых алиасов.

29 полей Team 2 совмещены с предметами и состояниями улучшений Team 1. Голоса, данные обмена предметами и путь Rescue NPC используют один слот; позиция меню, начало пути NPC и направление финального полёта — другой. Тип биоресурса и настроение NPC совмещены с защитой поздних записей после смены задания.

[Обоснование безопасности и сценарии игрового прогона](player-slot-sharing-review-2026-11-02.md). [Полный индекс обращений](player-variable-references-2026-11-02.md). [Результат проверок](player-slot-sharing-validation.json).

Получатель поля определяет владельца, а не команда правила. Состояние позднего входа, общие эффекты и поля с чтением исходного нуля сохранены отдельно.

## Team 2 zombies: AI, abilities, bosses and bot visuals

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `botBiteDamage` | number | Difficulty/hero-scaled zombie bite damage, also used by zombie abilities and explosions. |
| `botBaseHealth` | number | Configured zombie maximum health, including mutations/boss overrides and recoil thresholds. |

## Team 1 players/allied actors: survival, infection and reconnect state

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `isPlayerActive` | bool | Player has completed initial menu activation; used by voting, roster and downed-player rules. |
| `isReviving` | bool | Nearby allies are currently advancing this player's revive progress. |
| `reviveDuration` | number | Required revive duration; restored from reconnect data and increased after revives. |
| `isInfected` | bool | Player infection has activated; infection rules, cures and Zombie Hybrid read this flag. |
| `rescueTimeRemaining` | number | Time left to rescue a downed player; reconnect cache and extraction dome may adjust it. |
| `infectionLevel` | number | Player infection/vaccine level; negative values represent vaccination. |
| `invisibilityCount` | number | Stacking invisibility/untargetability counter; hero abilities and Cloaking Device increment/decrement it. Not a boolean. |
| `infectionDamageOverTimeId` | number | Active player infection damage-over-time ID; Zombie Hybrid stops this same damage instance. |
| `reconnectUserIndex` | number | Player name index into userNameList/playerStatsList for reconnect restoration. |
| `isAfk` | bool | Player is treated as inactive/AFK and excluded from objectives or extraction counts. |
| `isHeroSwitchRespawn` | bool | Player has switched heroes; prevents repeating first-spawn and enhancement initialization. |

## Enhancements only (enhancement prefix; includes the Rescue Hitchhiker setup)

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `enhancementId` | number | Selected Enhancement enum; pregame selection, runtime behavior and Rescue Hitchhiker initialization. |
| `enhancementHitchhikerPassenger` | player | Passenger attached to this carrier; null when absent. Infection rules also query it. |
| `enhancementHitchhikerCarrierPoolId` | number | Extra health-pool ID granted to a Hitchhiker carrier, retained for removal. |

## Team 1 pregame selection and voting

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `pregameState` | number | PregameState hero-selection/readiness state; zero is also the late-join default. |
| `isPregameVoting` | bool | This Team 1 player is adjusting votes; separate from global isVoting. |

## Team 1 Survivor Rescue NPC

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `rescueLeader` | player | Team 1 player followed by the Rescue NPC; bot teleport logic reads the NPC's field. |

## Biomorphing carriers on both teams

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `biomorphingResourceAmount` | number | Biowaste amount carried by either team; Team 1 deposits it and blood uses sentinel 9999. |

## Explosion presentation shared by zombies and Zombie Hybrid

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `explosionInnerColor` | color | Inner explosion color shared by ordinary zombies and Zombie Hybrid. |
| `explosionOuterColor` | color | Outer explosion color shared by ordinary zombies and Zombie Hybrid. |
| `explosionScale` | number | Explosion radius/sound multiplier; zombie warning setup and Hybrid initialization assign it. |

## Both teams or multiple systems: shared stats, visuals and role-owned storage

| Слот | Тип | Назначение и роли |
| --- | --- | --- |
| `aiThrottleSpeedSlot` | number | Zombie movement throttle or Team 1 Rescue follow throttle; subroutines, bots and Rescue. Роли: `botThrottleSpeed` (number); `rescueThrottleSpeed` (number) |
| `recoveryTimeSlot` | number | Existing Team 1 revive countdown / Team 2 replacement delay; no additional slot sharing. Роли: `reviveTimeRemaining` (number); `botRespawnDelay` (number) |
| `isCrowdControlled` | bool | Set/reset on zombies by stun management; also queried on Team 1 Hitchhiker carriers (default false). |
| `actorCountdownSlot` | number | Existing Team 1 item countdown / Team 2 Charger windup progression. Роли: `powerUpNoCooldownsTimeRemaining` (number); `botChargerWindupProgress` (number) |
| `controlStateSlot` | mixed | Player crowd-control immunity flag or zombie boss return target; hero_tuning/zombie abilities/Bosses. Роли: `isCrowdControlCooldownActive` (bool); `botReturnTarget` (player) |
| `actorMotionSlot1` | mixed | Existing per-hero numeric/vector chase or Rescue extraction position; no change to chase lifetime. Роли: `botGasProjectilePosition` (vector); `botTentaclePosition` (vector); `botBlasterCharge` (number); `botDaytakerCharge` (number); `botSmolderAnger` (number); `botEnsnarerMeleeAngle` (number); `rescueExtractionPosition` (vector) |
| `actorMotionSlot2` | mixed | Team 2 toxic-cloud duration or Team 1 extraction flight position. Роли: `botGasCloudTimeRemaining` (number); `extractionFlightPosition` (vector) |
| `actorAbilitySlot2` | mixed | Existing zombie secondary state or temporary Rescue follow message. Роли: `botAuxiliaryState` (mixed); `rescueFollowMessage` (string); `botIsReigniteActive` (bool); `botIsEnsnarerMeleeActive` (bool) |
| `initialMaxHealth` | number | Cached native/player maximum health before custom scaling; used by infection and Hitchhiker health pools. |
| `isAttached` | bool | Actor is attached to a host; zombie attachment and Team 1 Hitchhiker share the same meaning. Роли: `botIsAttached` (bool); `enhancementIsHitchhiking` (bool) |
| `candidateTargetList` | array | Boss target-visibility snapshot, Rescue leader candidates or barricade collision targets; downed-player cleanup removes invalid candidates. Роли: `botPotentialTargetList` (array); `rescuePotentialLeaderList` (array); `enhancementBarrierTargetList` (array) |
| `sizeScale` | number | Actor size multiplier; shared by players, zombies, Rescue, item ranges and enhancements. |
| `actorAbilitySlot1` | mixed | Existing per-zombie ability state or Team 1 Rescue extraction flag. Роли: `botAbilityState` (mixed); `rescueIsExtracting` (bool); `botIsBomberPrimed` (bool); `botRusherHealthPoolId` (number); `botGasAimPosition` (vector); `botIsReigniteAttackUsed` (bool); `botRiderGrapplePosition` (vector); `botChargerDestination` (vector); `botTentacleTargetPosition` (vector); `botIsStrikerStrikeActive` (bool); `botIsDownfallenGrabbing` (bool); `botIsEnsnarerBlocking` (bool); `botSmolderState` (number) |
| `objectiveTypeSnapshot` | number | Last objective type whose per-actor visuals were initialized; used on both teams. |
| `visualEntityIdList` | array | Zombie effects or Team 1 objective icons retained for yielding cleanup. Роли: `botVisualEntityIdList` (array); `playerObjectiveIconIdList` (array) |
| `visualCleanupIndex` | number | Per-actor effect/icon cleanup index; the loops yield and cannot use global scratch. |
| `actorLoopSlot` | number | Existing Ensnarer melee loop index / Bounce Pad duration. Роли: `botEnsnarerUltimateIndex` (number); `powerUpBouncePadTimeRemaining` (number) |
| `abilityTargetList` | array | Zombie special-ability targets or common zombie/Hybrid explosion targets. Роли: `botSpecialTargetList` (array); `explosionTargetList` (array) |
| `movementSpeedScale` | number | Movement-speed multiplier used by zombie AI, players/Rescue, crowd control and supply items. |
| `damageOverTimeRemaining` | number | Tracked DoT duration, normally chased on zombies; one Rusher rule writes it on the victim. Preserve that receiver. |
| `actorTeamSlot0` | mixed | Team 2: botTeleportCenter; Team 1: powerUpForceFieldTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botTeleportCenter` (vector); `powerUpForceFieldTimeRemaining` (number) |
| `actorTeamSlot1` | mixed | Team 2: botIsSelectingTarget; Team 1: powerUpReviveTarget. Receivers, not rule teams, own the storage. Роли: `botIsSelectingTarget` (bool); `powerUpReviveTarget` (player) |
| `actorTeamSlot2` | mixed | Team 2: botReturnMotionSlot; Team 1: powerUpItemId. Receivers, not rule teams, own the storage. Роли: `botReturnTime` (number); `botReturnPosition` (vector); `powerUpItemId` (number) |
| `actorTeamSlot3` | mixed | Team 2 teleport flag; Team 1 human votes -> item trade data, or Rescue dummy path. Late vote writers are phase-guarded; trade indices 0 and 2 are assigned before reading. Роли: `botIsTeleporting` (bool); `powerUpTradeDataList` (array); `pregameVoteList` (array); `rescuePathList` (array) |
| `actorTeamSlot4` | mixed | Team 2: botLoopIndexSlot; Team 1: powerUpEntityIdList. Receivers, not rule teams, own the storage. Роли: `botStalkerFadeIndex` (number); `botEnsnarerTargetIndex` (number); `powerUpEntityIdList` (array) |
| `actorTeamSlot5` | mixed | Team 2: botTarget; Team 1: powerUpAirStrikeIndex. Receivers, not rule teams, own the storage. Роли: `botTarget` (player); `powerUpAirStrikeIndex` (number) |
| `actorTeamSlot6` | mixed | Team 2: botBiteDuration; Team 1: powerUpHealBeaconTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botBiteDuration` (number); `powerUpHealBeaconTimeRemaining` (number) |
| `actorTeamSlot7` | mixed | Team 2: botIsTeleportConfirmed; Team 1: powerUpTurretTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botIsTeleportConfirmed` (bool); `powerUpTurretTimeRemaining` (number) |
| `actorTeamSlot8` | mixed | Team 2: botReigniteDestination; Team 1: powerUpCloakTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botReigniteDestination` (vector); `powerUpCloakTimeRemaining` (number) |
| `actorTeamSlot9` | mixed | Team 2: botIsWallPhaseAllowed; Team 1: powerUpSuperNanoTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botIsWallPhaseAllowed` (bool); `powerUpSuperNanoTimeRemaining` (number) |
| `actorTeamSlot10` | mixed | Team 2: botAbilityTarget; Team 1: powerUpUltimateTimeRemaining. Receivers, not rule teams, own the storage. Роли: `botAbilityTarget` (player); `powerUpUltimateTimeRemaining` (number) |
| `actorTeamSlot11` | mixed | Team 2: botTeleportPosition; Team 1: powerUpStunBouncesRemaining. Receivers, not rule teams, own the storage. Роли: `botTeleportPosition` (vector); `powerUpStunBouncesRemaining` (number) |
| `actorTeamSlot12` | mixed | Team 2: botBossHealth; Team 1: powerUpStunBeamPosition. Receivers, not rule teams, own the storage. Роли: `botBossHealth` (number); `powerUpStunBeamPosition` (vector) |
| `actorTeamSlot13` | mixed | Team 2: botIsWallCollisionEnabled; Team 1: powerUpTurretPosition. Receivers, not rule teams, own the storage. Роли: `botIsWallCollisionEnabled` (bool); `powerUpTurretPosition` (vector) |
| `actorTeamSlot14` | mixed | Team 2: botIsFacingOverridden; Team 1: powerUpStunTarget. Receivers, not rule teams, own the storage. Роли: `botIsFacingOverridden` (bool); `powerUpStunTarget` (player) |
| `actorTeamSlot15` | mixed | Team 2: botIsThrottleOverridden; Team 1: powerUpHealBeaconPosition. Receivers, not rule teams, own the storage. Роли: `botIsThrottleOverridden` (bool); `powerUpHealBeaconPosition` (vector) |
| `actorTeamSlot16` | mixed | Team 2: botConfiguredHero; Team 1: powerUpForceFieldPosition. Receivers, not rule teams, own the storage. Роли: `botConfiguredHero` (hero); `powerUpForceFieldPosition` (vector) |
| `actorTeamSlot17` | mixed | Team 2: botMutationId; Team 1: powerUpBouncePadPosition. Receivers, not rule teams, own the storage. Роли: `botMutationId` (number); `powerUpBouncePadPosition` (vector) |
| `actorTeamSlot18` | mixed | Team 2: botIsInitializing; Team 1: powerUpStunOrigin. Receivers, not rule teams, own the storage. Роли: `botIsInitializing` (bool); `powerUpStunOrigin` (player) |
| `actorTeamSlot19` | mixed | Team 2: botKnockbackScale; Team 1: powerUpTurretDirection. Receivers, not rule teams, own the storage. Роли: `botKnockbackScale` (number); `powerUpTurretDirection` (vector) |
| `actorTeamSlot20` | mixed | Team 2: botCustomTeleportPosition; Team 1: powerUpAirStrikePosition. Receivers, not rule teams, own the storage. Роли: `botCustomTeleportPosition` (vector); `powerUpAirStrikePosition` (vector) |
| `actorTeamSlot21` | mixed | Team 2: botLastTarget; Team 1: powerUpTradeIndex. Receivers, not rule teams, own the storage. Роли: `botLastTarget` (player); `powerUpTradeIndex` (number) |
| `actorTeamSlot22` | mixed | Team 2: botAbilityStateSlot; Team 1: enhancementStateSlot1. Receivers, not rule teams, own the storage. Роли: `botAbilityCooldown` (number); `botGasPositionList` (array); `enhancementHybridCooldown` (number); `enhancementBarrierFacing` (vector); `enhancementPyroHitList` (array); `enhancementPlagueCureTotal` (number); `enhancementIsBattleResetReady` (bool); `enhancementBatteryPosition` (vector); `enhancementHitchhikerCarrier` (player); `enhancementPupColor` (color) |
| `actorTeamSlot23` | mixed | Team 2: botGasRadiusList; Team 1: enhancementStateSlot2. Receivers, not rule teams, own the storage. Роли: `botGasRadiusList` (array); `enhancementBarrierEdgeDirection` (vector); `enhancementBattleAbilityButton` (button); `enhancementBatteryReuseCooldown` (number); `enhancementHitchhikerPassengerPoolId` (number); `enhancementIsPupBeamActive` (bool) |
| `actorTeamSlot24` | mixed | Team 2: botSpawnWaypoint; Team 1: enhancementStateSlot3. Receivers, not rule teams, own the storage. Роли: `botSpawnWaypoint` (vector); `enhancementBarrierPlacementCooldown` (number); `enhancementBatteryReuseDuration` (number); `enhancementPupTarget` (player) |
| `actorTeamSlot25` | mixed | Team 2: botCandidateTarget; Team 1: enhancementStateSlot4. Receivers, not rule teams, own the storage. Роли: `botCandidateTarget` (player); `enhancementBarrierPosition` (vector); `enhancementBatteryPlacementCooldown` (number); `enhancementIsPupFreezeAuraActive` (bool) |
| `actorTeamSlot26` | mixed | Team 2: botIsTeleportAllowed; Team 1: enhancementPositionSlot. Receivers, not rule teams, own the storage. Роли: `botIsTeleportAllowed` (bool); `enhancementBarrierCorner1` (vector); `enhancementPupPosition` (vector) |
| `actorTeamSlot27` | mixed | Team 2: botReigniteRisePosition; Team 1: enhancementStateSlot6. Receivers, not rule teams, own the storage. Роли: `botReigniteRisePosition` (vector); `enhancementBarrierCorner2` (vector); `enhancementPupCooldown` (number) |
| `actorTeamSlot28` | mixed | Team 2: botResourceIconIdList; Team 1: enhancementBarrierHealth. Receivers, not rule teams, own the storage. Роли: `botResourceIconIdList` (array); `enhancementBarrierHealth` (number) |
| `team1PositionSlot` | mixed | Pregame position -> final extraction destination on humans; Rescue NPC path origin on its own actor. No chase owns this slot. Роли: `pregamePosition` (vector); `rescueStartPosition` (vector); `extractionDestination` (vector) |
| `objectiveActorKindSlot` | mixed | Biomorphing resource type on both teams, or Rescue NPC mood. Goal writers recheck the objective after waits; Rescue completes only after its dummy is destroyed. Роли: `biomorphingResourceType` (number); `rescueMoodIcon` (icon) |

## Проверки

`node analysis/verify-player-variables.cjs` проверяет все 231 скомпилированное правило, слоты и алиасы, граф вызовов получателей eventPlayer и время жизни scratch; выполняет обычную сборку через include. `node analysis/verify-phase-slots.cjs` сохраняет цепочку сравнения прежних globalvar. `node analysis/audit-player-variables.cjs` обновляет этот документ и индекс.

Все проверки статические. Игровой прогон не выполнялся. Для обновления импортируйте полный скрипт.
