# Порядок и имена переменных игрока — 2026-11-02

**108 физических playervar, 99 globalvar, 27 218 элементов.** Число слотов, действия и время жизни не изменены. Объявления сгруппированы; 83 смысловых алиаса `#!define` раскрываются в существующие слоты. База сравнения — `9185ddd9b8bc76852ffacdafbfde932a3970f152`.

Комментарии к каждому физическому полю и каждой роли находятся в `src/variables.opy`. [Индекс обращений](player-variable-references-2026-11-02.md) содержит файлы, правила и строки, [JSON](player-variable-usage-2026-11-02.json) — полные выражения, команды правил и условия. [Проверка](player-variable-validation-2026-11-02.json) хранит сопоставление имён и хеши исходников.

## Принципы группировки

- Команда правила относится к владельцу события, а не обязательно к получателю поля. Проверены `eventPlayer`, `victim`, `attacker`, поля целей и коллекций, вызовы подпрограмм и Rescue NPC.
- `bot` означает поле зомби Team 2. Функциональные группы enhancements/power-ups имеют собственные префиксы; они остаются в этих группах даже при чтении из файла другой системы. Остальные поля только Team 1 разделены на выживание, меню и Rescue.
- Булевы роли используют `is...` или `botIs...` / `enhancementIs...` / `rescueIs...`; массивы заканчиваются на `List`. Нулевые/null-сбросы существующих ссылок и векторов сохранены. Числовые счётчики не превращены в булевы.
- Разные назначения одного слота имеют отдельные алиасы. Одинаковый смысл в разных потребителях сохраняет общее имя: например, `initialMaxHealth`, `sizeScale`, `movementSpeedScale`, `isCrowdControlled`.
- Новое совместное хранение не добавлялось. Порядок физических индексов мог измениться: импортировать следует полный скрипт.

## Важные случаи

- Старый `botTarget` также записывался на игроке владельце Laser Barricade. Теперь физический `combatTargetSlot` имеет роли `botTarget`, `enhancementBarrierTarget` и `currentCombatTarget` для общей очистки.
- Старый `botFollowTarget` принадлежит NPC Team 1: теперь это `rescueLeader`. Старый `botThrottleSpeed` хранится в `aiThrottleSpeedSlot` с ролями `botThrottleSpeed` / `rescueThrottleSpeed`.
- `specialCooldown` содержал флаг Team 1 и ссылку на цель босса. Теперь это `controlStateSlot`: `isCrowdControlCooldownActive` / `botReturnTarget`.
- `invisible` является счётчиком: способности и Cloaking Device делают `++`/`--`. Новое имя `invisibilityCount` сохраняет числовую семантику.
- `abilityArray1` не всегда массив: `botAbilityStateSlot` имеет роли `botAbilityCooldown` и `botGasPositionList`. `abilityArray2` всегда используется как массив радиусов: `botGasRadiusList`.
- Старые `chase1`/`chase2`, `botTempValue`/`botTempvalue2`, `telePos`, счётчики смешанных предметов/зомби сохранили физические слоты, но получили имена для конкретных способностей, Rescue и эвакуации.
- Поля `enhancementValue1..6` представлены хранилищами `enhancement*Slot` с ролями каждого улучшения. `enhancementValue7` принадлежит только баррикаде и переименован в `enhancementBarrierHealth`.
- `isCrowdControlled` читается и на потенциальном носителе Hitchhiker в Team 1, хотя записи состояния делает AI Team 2. `damageOverTimeRemaining` также оставлен общим: одна ветка Rusher пишет его на `victim`. Эти существующие получатели и ограничения не исправлялись при переименовании.
- Глобальные `isVoting`, `startPos`, `objectiveValue` сохранены отдельно от бывших одноимённых полей игрока. Проверка компиляции различает пространство `Global.*`, свойства игрока и аргументы player-variable действий.

## Состав групп

| Группа | Физических полей |
| --- | ---: |
| Только зомби Team 2 | 30 |
| Только Team 1: игроки и союзные акторы | 13 |
| Только функционал enhancements | 10 |
| Только функционал supply power-ups | 22 |
| Team 1: меню и голосование | 3 |
| Team 1: NPC Survivor Rescue | 3 |
| Biomorphing: носители ресурсов обеих команд | 2 |
| Общие взрывы зомби и Zombie Hybrid | 3 |
| Общие состояния и слоты нескольких функционалов | 22 |

## Полный список

### Только зомби Team 2

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`botTeleportCenter`](player-variable-references-2026-11-02.md#botteleportcenter) | `averagePlayersPos` | Вектор | Zombie teleport/search center; bot teleport rules, Egg and boss return. |
| [`botIsSelectingTarget`](player-variable-references-2026-11-02.md#botisselectingtarget) | `targeting` | Булево | selectTarget is running; blocks competing zombie target/teleport work. |
| [`botReturnMotionSlot`](player-variable-references-2026-11-02.md#botreturnmotionslot) | `mutationChase` | Смешанный | Boss return timer, then an eye-position snapshot; objective_type_bosses. Роли: `botReturnTime` (Число); `botReturnPosition` (Вектор). |
| [`botIsTeleporting`](player-variable-references-2026-11-02.md#botisteleporting) | `teleporting` | Булево | Zombie is inside enterExitTeleport; spawn/target/ability consumers also read it. |
| [`botLoopIndexSlot`](player-variable-references-2026-11-02.md#botloopindexslot) | `pForceFieldCount2_bCount1` | Число | Existing yielding loop index shared by Stalker fades and Ensnarer blocking. Роли: `botStalkerFadeIndex` (Число); `botEnsnarerTargetIndex` (Число). |
| [`botBiteDamage`](player-variable-references-2026-11-02.md#botbitedamage) | `biteDamage` | Число | Difficulty/hero-scaled zombie bite damage, also used by zombie abilities and explosions. |
| [`botBiteDuration`](player-variable-references-2026-11-02.md#botbiteduration) | `biteDuration` | Число | Zombie melee damage-over-time duration, including mutation overrides. |
| [`botIsTeleportConfirmed`](player-variable-references-2026-11-02.md#botisteleportconfirmed) | `successfullyTeleported` | Булево | Zombie teleport/spawn position has been accepted and may be added to the spawn cache. |
| [`botReigniteDestination`](player-variable-references-2026-11-02.md#botreignitedestination) | `anranPortal` | Вектор | Zombie emergence destination near Anran; false clears the position after the rise. |
| [`botIsWallPhaseAllowed`](player-variable-references-2026-11-02.md#botiswallphaseallowed) | `canWallPhase` | Булево | Zombie may pass spawn doors; special abilities temporarily disable this permission. |
| [`botAbilityTarget`](player-variable-references-2026-11-02.md#botabilitytarget) | `botSpecialTarget` | Игрок/null | Zombie special-ability target: teleport/grab host, flight target or affected player. |
| [`botBossHealth`](player-variable-references-2026-11-02.md#botbosshealth) | `bossHealth` | Число | Virtual boss/egg health adjusted by damage events; -1 when not a boss. |
| [`botIsWallCollisionEnabled`](player-variable-references-2026-11-02.md#botiswallcollisionenabled) | `wallCollisionEnabled` | Булево | Cached zombie environment-collision state, restored by abilities and spawn-door handling. |
| [`botIsFacingOverridden`](player-variable-references-2026-11-02.md#botisfacingoverridden) | `specialFacing` | Булево | Special zombie ability controls facing instead of normal target tracking. |
| [`botIsThrottleOverridden`](player-variable-references-2026-11-02.md#botisthrottleoverridden) | `specialThrottling` | Булево | Special zombie ability controls movement instead of the normal AI throttle. |
| [`botConfiguredHero`](player-variable-references-2026-11-02.md#botconfiguredhero) | `botHero` | Герой | Last zombie hero for which bot entity/stat initialization was performed. |
| [`botMutationId`](player-variable-references-2026-11-02.md#botmutationid) | `mutationValue` | Число | Selected mutation ID; zero means no mutation. |
| [`botBaseHealth`](player-variable-references-2026-11-02.md#botbasehealth) | `health` | Число | Configured zombie maximum health, including mutations/boss overrides and recoil thresholds. |
| [`botIsInitializing`](player-variable-references-2026-11-02.md#botisinitializing) | `initializing` | Булево | Zombie respawn/stat initialization is in progress; spawn/teleport/objective rules wait for it. |
| [`botKnockbackScale`](player-variable-references-2026-11-02.md#botknockbackscale) | `knockbackRecieved` | Число | Zombie knockback-received multiplier, including Brute/mutation adjustments. |
| [`botCustomTeleportPosition`](player-variable-references-2026-11-02.md#botcustomteleportposition) | `customTelePos` | Вектор | Special zombie replacement position carried from customTeleportPositionList; null when unused. |
| [`botLastTarget`](player-variable-references-2026-11-02.md#botlasttarget) | `lastTarget` | Игрок/null | Last visible/attacking target retained when zombie line of sight is lost. |
| [`botAbilityStateSlot`](player-variable-references-2026-11-02.md#botabilitystateslot) | `abilityArray1` | Смешанный | Zombie ability cooldown number or Behemoth cloud-position array; not always an array. Роли: `botAbilityCooldown` (Число); `botGasPositionList` (Массив). |
| [`botGasRadiusList`](player-variable-references-2026-11-02.md#botgasradiuslist) | `abilityArray2` | Массив | Boss Behemoth gas-cloud radii, aligned with botGasPositionList. |
| [`botSpawnWaypoint`](player-variable-references-2026-11-02.md#botspawnwaypoint) | `waypoint` | Вектор | Movement waypoint associated with the accepted zombie spawn point. |
| [`botCandidateTarget`](player-variable-references-2026-11-02.md#botcandidatetarget) | `testTarget` | Игрок/null | Candidate zombie target under line-of-sight testing in selectTarget. |
| [`botIsTeleportAllowed`](player-variable-references-2026-11-02.md#botisteleportallowed) | `canTeleport` | Булево | Zombie initialization has enabled teleport processing. |
| [`botMutationOutlineColor`](player-variable-references-2026-11-02.md#botmutationoutlinecolor) | `defaultOutlineColor` | Цвет | Mutation outline color; null if no mutation outline is active. |
| [`botReigniteMotionSlot`](player-variable-references-2026-11-02.md#botreignitemotionslot) | `anranPortalRise` | Смешанный | Anran emergence source actor, then the chased rise position. Роли: `botReigniteSource` (Игрок/null); `botReigniteRisePosition` (Вектор). |
| [`botResourceIconIdList`](player-variable-references-2026-11-02.md#botresourceiconidlist) | `botResourceEntity` | Массив | Zombie Biomorphing resource icon IDs; separate from the zombie visual-effect list. |

### Только Team 1: игроки и союзные акторы

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`isPlayerActive`](player-variable-references-2026-11-02.md#isplayeractive) | `playerActiveStatus` | Булево | Player has completed initial menu activation; used by voting, roster and downed-player rules. |
| [`isReviving`](player-variable-references-2026-11-02.md#isreviving) | `reviving` | Булево | Nearby allies are currently advancing this player's revive progress. |
| [`reviveDuration`](player-variable-references-2026-11-02.md#reviveduration) | `reviveStartTime` | Число | Required revive duration; restored from reconnect data and increased after revives. |
| [`isInfected`](player-variable-references-2026-11-02.md#isinfected) | `infected` | Булево | Player infection has activated; infection rules, cures and Zombie Hybrid read this flag. |
| [`rescueTimeRemaining`](player-variable-references-2026-11-02.md#rescuetimeremaining) | `deathTimer` | Число | Time left to rescue a downed player; reconnect cache and extraction dome may adjust it. |
| [`infectionLevel`](player-variable-references-2026-11-02.md#infectionlevel) | `infectionLvl` | Число | Player infection/vaccine level; negative values represent vaccination. |
| [`team1PositionSlot`](player-variable-references-2026-11-02.md#team1positionslot) | `startPos` | Вектор | Team 1 hero-selection position or Rescue NPC path origin. Роли: `pregamePosition` (Вектор); `rescueStartPosition` (Вектор). |
| [`extractionDestination`](player-variable-references-2026-11-02.md#extractiondestination) | `evacPos` | Вектор | Per-player final flight destination, calculated from the shared extraction direction. |
| [`invisibilityCount`](player-variable-references-2026-11-02.md#invisibilitycount) | `invisible` | Число | Stacking invisibility/untargetability counter; hero abilities and Cloaking Device increment/decrement it. Not a boolean. |
| [`infectionDamageOverTimeId`](player-variable-references-2026-11-02.md#infectiondamageovertimeid) | `infectionDamage` | Число | Active player infection damage-over-time ID; Zombie Hybrid stops this same damage instance. |
| [`reconnectUserIndex`](player-variable-references-2026-11-02.md#reconnectuserindex) | `userIndex` | Число | Player name index into userNameList/playerStatsList for reconnect restoration. |
| [`isAfk`](player-variable-references-2026-11-02.md#isafk) | `afk` | Булево | Player is treated as inactive/AFK and excluded from objectives or extraction counts. |
| [`isHeroSwitchRespawn`](player-variable-references-2026-11-02.md#isheroswitchrespawn) | `switchedHeroes` | Булево | Player has switched heroes; prevents repeating first-spawn and enhancement initialization. |

### Только функционал enhancements

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`enhancementId`](player-variable-references-2026-11-02.md#enhancementid) | `enhancementId` | Число | Selected Enhancement enum; pregame selection, runtime behavior and Rescue Hitchhiker initialization. |
| [`enhancementStateSlot1`](player-variable-references-2026-11-02.md#enhancementstateslot1) | `enhancementValue1` | Смешанный | Primary enhancement state; each enhancement owns a distinct role alias. Роли: `enhancementHybridCooldown` (Число); `enhancementBarrierFacing` (Вектор); `enhancementPyroHitList` (Массив); `enhancementPlagueCureTotal` (Число); `enhancementIsBattleResetReady` (Булево); `enhancementBatteryPosition` (Вектор); `enhancementHitchhikerCarrier` (Игрок/null); `enhancementPupColor` (Цвет). |
| [`enhancementStateSlot2`](player-variable-references-2026-11-02.md#enhancementstateslot2) | `enhancementValue2` | Смешанный | Secondary enhancement state shared by mutually selected enhancements. Роли: `enhancementBarrierEdgeDirection` (Вектор); `enhancementBattleAbilityButton` (Кнопка); `enhancementBatteryReuseCooldown` (Число); `enhancementHitchhikerPassengerPoolId` (Число); `enhancementIsPupBeamActive` (Булево). |
| [`enhancementStateSlot3`](player-variable-references-2026-11-02.md#enhancementstateslot3) | `enhancementValue3` | Смешанный | Barrier cooldown, battery reuse duration, or P.U.P. target. Роли: `enhancementBarrierPlacementCooldown` (Число); `enhancementBatteryReuseDuration` (Число); `enhancementPupTarget` (Игрок/null). |
| [`enhancementStateSlot4`](player-variable-references-2026-11-02.md#enhancementstateslot4) | `enhancementValue4` | Смешанный | Barrier center, battery placement timer, or P.U.P. freeze-aura flag. Роли: `enhancementBarrierPosition` (Вектор); `enhancementBatteryPlacementCooldown` (Число); `enhancementIsPupFreezeAuraActive` (Булево). |
| [`enhancementPositionSlot`](player-variable-references-2026-11-02.md#enhancementpositionslot) | `enhancementValue5` | Вектор | Barrier first corner or chased P.U.P. position. Роли: `enhancementBarrierCorner1` (Вектор); `enhancementPupPosition` (Вектор). |
| [`enhancementStateSlot6`](player-variable-references-2026-11-02.md#enhancementstateslot6) | `enhancementValue6` | Смешанный | Barrier second corner or P.U.P. ability cooldown. Роли: `enhancementBarrierCorner2` (Вектор); `enhancementPupCooldown` (Число). |
| [`enhancementBarrierHealth`](player-variable-references-2026-11-02.md#enhancementbarrierhealth) | `enhancementValue7` | Число | Laser Barricade health; placement, collision damage, regeneration and HUD. |
| [`enhancementHitchhikerPassenger`](player-variable-references-2026-11-02.md#enhancementhitchhikerpassenger) | `hitchhikerPassenger` | Игрок/null | Passenger attached to this carrier; null when absent. Infection rules also query it. |
| [`enhancementHitchhikerCarrierPoolId`](player-variable-references-2026-11-02.md#enhancementhitchhikercarrierpoolid) | `hitchhikerCarrierHealthPool` | Число | Extra health-pool ID granted to a Hitchhiker carrier, retained for removal. |

### Только функционал supply power-ups

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`powerUpForceFieldTimeRemaining`](player-variable-references-2026-11-02.md#powerupforcefieldtimeremaining) | `pForceFieldCount1` | Число | Remaining Force Field seconds; yielding loop and item HUD in supply_drops. |
| [`powerUpReviveTarget`](player-variable-references-2026-11-02.md#poweruprevivetarget) | `interactEntity` | Игрок/null | Dead Team 1 target retained across instantRevive waits. |
| [`powerUpItemId`](player-variable-references-2026-11-02.md#powerupitemid) | `currentPowerUp` | Число | Currently carried supply item ID; zero means no item. |
| [`powerUpTradeDataList`](player-variable-references-2026-11-02.md#poweruptradedatalist) | `powerUpTradeValues` | Массив | Trade record: aimed ground position at index 0 and previous item ID at index 2. |
| [`powerUpEntityIdList`](player-variable-references-2026-11-02.md#powerupentityidlist) | `powerUpEffects` | Массив | Sparse effect/HUD/damage-modification IDs owned by active items, keyed by item ID range. |
| [`powerUpAirStrikeIndex`](player-variable-references-2026-11-02.md#powerupairstrikeindex) | `pAirStrikeCount` | Число | Index of 50 air-strike impacts; retained across waits. |
| [`powerUpHealBeaconTimeRemaining`](player-variable-references-2026-11-02.md#poweruphealbeacontimeremaining) | `pHealBeaconCount` | Число | Remaining healing-beacon seconds; loop and HUD. |
| [`powerUpTurretTimeRemaining`](player-variable-references-2026-11-02.md#powerupturrettimeremaining) | `pSentryTurretCount` | Число | Remaining sentry-turret seconds; loop and HUD. |
| [`powerUpCloakTimeRemaining`](player-variable-references-2026-11-02.md#powerupcloaktimeremaining) | `pCloakingDeviceCount` | Число | Remaining cloak seconds and early-cancel threshold. |
| [`powerUpSuperNanoTimeRemaining`](player-variable-references-2026-11-02.md#powerupsupernanotimeremaining) | `pSuperNanoCount` | Число | Remaining Super Nano seconds; yielding loop and HUD. |
| [`powerUpUltimateTimeRemaining`](player-variable-references-2026-11-02.md#powerupultimatetimeremaining) | `pUltimateChargerCount` | Число | Remaining Ultimate Charger seconds; loop and HUD. |
| [`powerUpStunBouncesRemaining`](player-variable-references-2026-11-02.md#powerupstunbouncesremaining) | `pStunCount` | Число | Remaining stun-chain steps, also scaling the terminal stun duration. |
| [`powerUpStunBeamPosition`](player-variable-references-2026-11-02.md#powerupstunbeamposition) | `pStunChase1` | Вектор | Chased stun-chain beam endpoint retained across bounces/waits. |
| [`powerUpTurretPosition`](player-variable-references-2026-11-02.md#powerupturretposition) | `sentryTurretPosition` | Вектор | Placed sentry-turret position; zero clears it. |
| [`powerUpStunTarget`](player-variable-references-2026-11-02.md#powerupstuntarget) | `stunTarget` | Игрок/null | Next zombie hit by the active stun chain. |
| [`powerUpHealBeaconPosition`](player-variable-references-2026-11-02.md#poweruphealbeaconposition) | `healBeaconPosition` | Вектор | Placed healing-beacon position; zero clears it. |
| [`powerUpForceFieldPosition`](player-variable-references-2026-11-02.md#powerupforcefieldposition) | `forceFieldPosition` | Вектор | Placed Force Field position; zero clears it. |
| [`powerUpBouncePadPosition`](player-variable-references-2026-11-02.md#powerupbouncepadposition) | `bouncePadPosition` | Вектор | Placed Bounce Pad ground position. |
| [`powerUpStunOrigin`](player-variable-references-2026-11-02.md#powerupstunorigin) | `stunOrigin` | Игрок/null | Current beam origin in the stun chain: wearer first, then previous target. |
| [`powerUpTurretDirection`](player-variable-references-2026-11-02.md#powerupturretdirection) | `sentryTurretDirection` | Вектор | Current sentry firing direction, captured by turret visuals and raycasts. |
| [`powerUpAirStrikePosition`](player-variable-references-2026-11-02.md#powerupairstrikeposition) | `airStrikePosition` | Вектор | Ground center of the active air-strike area. |
| [`powerUpTradeIndex`](player-variable-references-2026-11-02.md#poweruptradeindex) | `powerUpTradeIndex` | Число | Index of the aimed ground item in the global supply item arrays. |

### Team 1: меню и голосование

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`pregameVoteList`](player-variable-references-2026-11-02.md#pregamevotelist) | `playerMenuStatus` | Массив | Player votes indexed by PlayerMenuStatusField; slots 0 and 1 stay unused. |
| [`pregameState`](player-variable-references-2026-11-02.md#pregamestate) | `pregameState` | Число | PregameState hero-selection/readiness state; zero is also the late-join default. |
| [`isPregameVoting`](player-variable-references-2026-11-02.md#ispregamevoting) | `isVoting` | Булево | This Team 1 player is adjusting votes; separate from global isVoting. |

### Team 1: NPC Survivor Rescue

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`rescueMoodIcon`](player-variable-references-2026-11-02.md#rescuemoodicon) | `randVal` | Иконка | Rescue NPC mood/status icon: halo, sad, dizzy or extraction celebration. |
| [`rescueLeader`](player-variable-references-2026-11-02.md#rescueleader) | `botFollowTarget` | Игрок/null | Team 1 player followed by the Rescue NPC; bot teleport logic reads the NPC's field. |
| [`rescuePathList`](player-variable-references-2026-11-02.md#rescuepathlist) | `path` | Массив | Recorded leader positions followed and trimmed by the Rescue NPC. |

### Biomorphing: носители ресурсов обеих команд

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`biomorphingResourceType`](player-variable-references-2026-11-02.md#biomorphingresourcetype) | `biowasteType` | Число | Material type carried by a player or zombie; null when empty and 3 for the blood goal. |
| [`biomorphingResourceAmount`](player-variable-references-2026-11-02.md#biomorphingresourceamount) | `playerObjectiveResourceValue` | Число | Biowaste amount carried by either team; Team 1 deposits it and blood uses sentinel 9999. |

### Общие взрывы зомби и Zombie Hybrid

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`explosionInnerColor`](player-variable-references-2026-11-02.md#explosioninnercolor) | `explosionColor1` | Цвет | Inner explosion color shared by ordinary zombies and Zombie Hybrid. |
| [`explosionOuterColor`](player-variable-references-2026-11-02.md#explosionoutercolor) | `explosionColor2` | Цвет | Outer explosion color shared by ordinary zombies and Zombie Hybrid. |
| [`explosionScale`](player-variable-references-2026-11-02.md#explosionscale) | `explosionSize` | Число | Explosion radius/sound multiplier; zombie warning setup and Hybrid initialization assign it. |

### Общие состояния и слоты нескольких функционалов

| Физическое поле | Прежнее имя | Тип | Назначение и алиасы |
| --- | --- | --- | --- |
| [`combatTargetSlot`](player-variable-references-2026-11-02.md#combattargetslot) | `botTarget` | Игрок/null | Zombie combat target or the current zombie hit by a player barricade; preserve existing sharing. Роли: `botTarget` (Игрок/null); `enhancementBarrierTarget` (Игрок/null); `currentCombatTarget` (Игрок/null). |
| [`aiThrottleSpeedSlot`](player-variable-references-2026-11-02.md#aithrottlespeedslot) | `botThrottleSpeed` | Число | Zombie movement throttle or Team 1 Rescue follow throttle; subroutines, bots and Rescue. Роли: `botThrottleSpeed` (Число); `rescueThrottleSpeed` (Число). |
| [`recoveryTimeSlot`](player-variable-references-2026-11-02.md#recoverytimeslot) | `reviveTimer` | Число | Existing Team 1 revive countdown / Team 2 replacement delay; no additional slot sharing. Роли: `reviveTimeRemaining` (Число); `botRespawnDelay` (Число). |
| [`isCrowdControlled`](player-variable-references-2026-11-02.md#iscrowdcontrolled) | `crowdControlled` | Булево | Set/reset on zombies by stun management; also queried on Team 1 Hitchhiker carriers (default false). |
| [`actorCountdownSlot`](player-variable-references-2026-11-02.md#actorcountdownslot) | `pNoCooldownsCount_bCount2` | Число | Existing Team 1 item countdown / Team 2 Charger windup progression. Роли: `powerUpNoCooldownsTimeRemaining` (Число); `botChargerWindupProgress` (Число). |
| [`controlStateSlot`](player-variable-references-2026-11-02.md#controlstateslot) | `specialCooldown` | Смешанный | Player crowd-control immunity flag or zombie boss return target; hero_tuning/zombie abilities/Bosses. Роли: `isCrowdControlCooldownActive` (Булево); `botReturnTarget` (Игрок/null). |
| [`actorMotionSlot1`](player-variable-references-2026-11-02.md#actormotionslot1) | `chase1` | Смешанный | Existing per-hero numeric/vector chase or Rescue extraction position; no change to chase lifetime. Роли: `botGasProjectilePosition` (Вектор); `botTentaclePosition` (Вектор); `botBlasterCharge` (Число); `botDaytakerCharge` (Число); `botSmolderAnger` (Число); `botEnsnarerMeleeAngle` (Число); `rescueExtractionPosition` (Вектор). |
| [`actorMotionSlot2`](player-variable-references-2026-11-02.md#actormotionslot2) | `chase2` | Смешанный | Team 2 toxic-cloud duration or Team 1 extraction flight position. Роли: `botGasCloudTimeRemaining` (Число); `extractionFlightPosition` (Вектор). |
| [`actorAbilitySlot2`](player-variable-references-2026-11-02.md#actorabilityslot2) | `botTempvalue2` | Смешанный | Existing zombie secondary state or temporary Rescue follow message. Роли: `botAuxiliaryState` (Смешанный); `rescueFollowMessage` (Строка); `botIsReigniteActive` (Булево); `botIsEnsnarerMeleeActive` (Булево). |
| [`initialMaxHealth`](player-variable-references-2026-11-02.md#initialmaxhealth) | `initialMaxHealth` | Число | Cached native/player maximum health before custom scaling; used by infection and Hitchhiker health pools. |
| [`isAttached`](player-variable-references-2026-11-02.md#isattached) | `attached` | Булево | Actor is attached to a host; zombie attachment and Team 1 Hitchhiker share the same meaning. Роли: `botIsAttached` (Булево); `enhancementIsHitchhiking` (Булево). |
| [`aiLocationSlot`](player-variable-references-2026-11-02.md#ailocationslot) | `telePos` | Смешанный | Zombie teleport candidate vector or Rescue path-trimming index. Роли: `botTeleportPosition` (Вектор); `rescuePathIndex` (Число). |
| [`candidateTargetList`](player-variable-references-2026-11-02.md#candidatetargetlist) | `potentialTargets` | Массив | Candidate list shared by zombie target selection, Rescue leader selection and barricade collision. Роли: `botPotentialTargetList` (Массив); `rescuePotentialLeaderList` (Массив); `enhancementBarrierTargetList` (Массив). |
| [`sizeScale`](player-variable-references-2026-11-02.md#sizescale) | `size` | Число | Actor size multiplier; shared by players, zombies, Rescue, item ranges and enhancements. |
| [`actorAbilitySlot1`](player-variable-references-2026-11-02.md#actorabilityslot1) | `botTempValue` | Смешанный | Existing per-zombie ability state or Team 1 Rescue extraction flag. Роли: `botAbilityState` (Смешанный); `rescueIsExtracting` (Булево); `botIsBomberPrimed` (Булево); `botRusherHealthPoolId` (Число); `botGasAimPosition` (Вектор); `botIsReigniteAttackUsed` (Булево); `botRiderGrapplePosition` (Вектор); `botChargerDestination` (Вектор); `botTentacleTargetPosition` (Вектор); `botIsStrikerStrikeActive` (Булево); `botIsDownfallenGrabbing` (Булево); `botIsEnsnarerBlocking` (Булево); `botSmolderState` (Число). |
| [`objectiveTypeSnapshot`](player-variable-references-2026-11-02.md#objectivetypesnapshot) | `objectiveValue` | Число | Last objective type whose per-actor visuals were initialized; used on both teams. |
| [`visualEntityIdList`](player-variable-references-2026-11-02.md#visualentityidlist) | `generalPlayerBotEntities` | Массив | Zombie effects or Team 1 objective icons retained for yielding cleanup. Роли: `botVisualEntityIdList` (Массив); `playerObjectiveIconIdList` (Массив). |
| [`visualCleanupIndex`](player-variable-references-2026-11-02.md#visualcleanupindex) | `entityCount` | Число | Per-actor effect/icon cleanup index; the loops yield and cannot use global scratch. |
| [`actorLoopSlot`](player-variable-references-2026-11-02.md#actorloopslot) | `pBouncePadCount1` | Число | Existing Ensnarer melee loop index / Bounce Pad duration. Роли: `botEnsnarerUltimateIndex` (Число); `powerUpBouncePadTimeRemaining` (Число). |
| [`abilityTargetList`](player-variable-references-2026-11-02.md#abilitytargetlist) | `botSpecialPotentialTargets` | Массив | Zombie special-ability targets or common zombie/Hybrid explosion targets. Роли: `botSpecialTargetList` (Массив); `explosionTargetList` (Массив). |
| [`movementSpeedScale`](player-variable-references-2026-11-02.md#movementspeedscale) | `movementSpeed` | Число | Movement-speed multiplier used by zombie AI, players/Rescue, crowd control and supply items. |
| [`damageOverTimeRemaining`](player-variable-references-2026-11-02.md#damageovertimeremaining) | `damageOverTimeDuration` | Число | Tracked DoT duration, normally chased on zombies; one Rusher rule writes it on the victim. Preserve that receiver. |

## Проверки и ограничения

`node analysis/verify-player-variables.cjs` сравнивает все 231 правила после замены имён: события, условия, действия, выражения, аргументы переоценки и chase. Обычная сборка через `#!include` также проверена, локальный `src/main.ws.txt` обновлён. Предупреждений нет при сохранённых подавлениях проекта.

`node analysis/audit-player-variables.cjs` пересоздаёт этот документ и индекс из проверенной классификации `analysis/player-variable-layout.cjs` и текущих исходников. Классификация владения не выводится автоматически из `@Team`.

Проверка в игре не проводилась. Сравнение подтверждает отсутствие изменений скомпилированной логики, но не моделирует планирование движка или перенос состояния уже идущего матча.
