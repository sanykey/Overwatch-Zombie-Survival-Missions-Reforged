# Аудит глобальных переменных — актуально на 2026-11-02

Проверены текущие исходники `src/main.opy` и все подключённые модули, включая `compressed numbers.opy` и `debug.opy`. После внедрения передач между фазами: **99 глобальных переменных, 108 переменных игрока и 27 218 элементов**. Относительно исходной базы 110 / 27 213 освобождены **11 глобальных слотов**, добавлены **5 элементов**. Выдаваемых предупреждений компилятора нет при сохранённых подавлениях проекта.

Реализованы девять основных пар из раздела «Оставшиеся варианты передачи слотов между фазами» и дополнительные пары `enhancementOptionList` → `biomorphingGoalText`, `startMenuSpacingAngle` → `biomorphingGoalColor`. Роли сохранены через `#!define`, физическое хранение — `phaseSlot0..10`. Полное сравнение **231 скомпилированного правила** с ревизией `1a313866755d0a00e6cc8bfcbfc323904c5ff02f` подтвердило эквивалентность после подстановки имён, кроме двух сбросов текста/цвета Biomorphing в `null` после удаления меню и защиты записи угла условием `isPregameSetup`. Поведение переходов и нагрузка в игре не измерялись.

Явных кандидатов на удаление без замены не обнаружено: у всех 99 переменных есть чтения или обращения в действиях помимо объявления/записи. Это не доказательство достижимости каждой ветки, но оснований удалять очередной слот как бесполезный сейчас нет.

## Область и обозначения

Каждая физическая переменная указана ровно один раз; имена ролей `#!define` не считаются дополнительными слотами. Порядок групп соответствует текущему `variables.opy`; данные генератора чисел и диагностики перечислены отдельно. **Ссылка в имени ведёт ко всем файлам, правилам/макросам и строкам обращений**, включая обращения через алиасы, в [индексе ссылок](global-variable-references-2026-11-01.md). [JSON использования](global-variable-usage-2026-11-01.json) содержит имена алиасов, полные строки и хеши текущих исходников. Имена этих файлов сохранены для существующих ссылок; дата их содержимого обновлена.

В таблицах перечислены основные потребители; полный список находится по ссылке в имени. Обозначения: `S` — `subroutines.opy`, `GS` — `global_startup.opy`, `GM` — `global_start_menu.opy`, `PM` — `player_start_menu.opy`, `GG` — `global_game_in_progress.opy`, `P` — `players_game_in_progress.opy`, `B` — `bots_game_in_progress.opy`, `Z` — `zombie_types.opy`, `SD` — `supply_drops.opy`, `PU` — `power_ups.opy`. Название задания означает соответствующий файл в `objective_types/`.

«Меню» заканчивается выключением `isPregameSetup`. **Генерация миссий идёт после меню, до `isGameplayActive = true`**. «Финал» включает поражение на любом задании. Префикс задания обозначает назначение состояния, а не гарантию прекращения всех его обработчиков сразу при переключении типа.

У булевых ролей префикс `is`, у постоянных массивов суффикс `List`. Для смешанных слотов сохранены нейтральные имена: `tmp0..2`, `phaseSlot0..10`, `objectiveProgressSlot`, `objectiveMotionSlot`, `menuFinaleMotionSlot` и `attackSpawnRooms`. Суффикс List у них скрывал бы часть допустимых типов. Глобальный `isVoting` и `player.isPregameVoting` — отдельные значения. [Имена и группы переменных игрока](player-variables-review-2026-11-02.md) актуализированы отдельно; физические 108 слотов игрока и вся логика сохранены.

## Имена ролей вместо исторических общих имён

Распределение памяти и время жизни сохранены. В коде конкретного задания используются имена его ролей; физические `*Slot` видны в объявлениях и индексе. Старые неоднозначные имена не оставлены как совместимые алиасы. Общие сбросы используют нейтральные роли `objectiveProgress`, `objectivePositionsList`, `objectiveNextCheckpoint`, `objectiveActor`. Значения с одинаковым смыслом для всех заданий (`objectiveRad`, `objectiveColor`, `objectivePlayerList`) сохраняют общие имена. `bossStateList` остаётся общим для боевых обработчиков, а модули Bosses/Egg используют свои алиасы того же массива.

| Прежнее имя | Текущие имена по контекстам |
| --- | --- |
| `testPos2` | Rescue: `rescueMinSpawnDistance`; Satellite: `satelliteMinTerminalSpacing`. |
| `testPos` | Генерация: `missionCandidatePosition`; Rescue: `rescueCandidatePosition`. |
| `objectiveCount1` | Генерация: `missionPlacementAttemptCount`; Biomorphing: `biomorphingCleanupIndex`; Satellite: `satelliteFiringStepsRemaining`. |
| `objectiveEntitiesCount` | `objectiveVisualCleanupIndex`: индекс удаления визуальных сущностей, не их количество. |
| `objectiveChase1` | Rescue: `rescueSavedRadius`; Kill Zone: `killZoneCenter`; Satellite: `satelliteLaserPosition`. |
| `objectiveCaptureValue` | `showdownCapturePercent`, `biomorphingCapturePercent`, `killZoneEliminationScore`, `satelliteTerminalProgressList`. |
| `objectiveResourcePositionList` | `biomorphingResourcePositionList` / `satelliteTerminalPositionList`. |
| `goalPost` | `showdownNextCheckpoint` / `biomorphingNextCheckpoint`. |
| `queuedGoalList` | `showdownContestingZombieList` / `biomorphingGoalQueueList`. |
| `survivorToRescue` | `rescueSurvivor` / `satelliteLaserTarget`. |
| Глобальный `chase1` | `pregameCountdown` / `nukeProjectilePosition`; прежнее поле `player.chase1` отдельно представлено `actorMotionSlot1` с собственными ролями. |
| `evacCount` | `finaleExplosionIndex`: взрывы и при победе, и при поражении. |
| `bossStateList` в задании | `bossesStateList` / `zombieEggStateList`; общие боевые правила используют `bossStateList`. |

Переименование охватывает инициализацию, переоцениваемые визуальные сущности, `chase`/`stopChasing`, условия и обработчики ботов. Проверка 231 скомпилированного правила учитывает отдельно глобальные обращения и поля игроков. Относительно предыдущего этапа поведение и размер сборки не изменились: 99 глобальных переменных / 27 218 элементов.

## Полный список действующих переменных

### 1. Общие временные слоты — 3

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`tmp0`](global-variable-references-2026-11-01.md#tmp0) | Смешанный | Все фазы; S, GS, GM, B, Z, SD, PU, enhancements и задания | Основной синхронный scratch: индекс, позиция, цель, промежуточное число. | Оставить общим. Значение не должно переживать ожидание/асинхронный вызов или попадать в переоценку без захвата. |
| [`tmp1`](global-variable-references-2026-11-01.md#tmp1) | Смешанный | Все фазы; GS, GM, Biomorphing, Satellite, SD, PU, enhancements | Второе одновременно нужное временное значение: сумма, список, индекс, цель. | Оставить: нельзя объединить с `tmp0`, когда оба значения нужны одновременно. |
| [`tmp2`](global-variable-references-2026-11-01.md#tmp2) | Смешанный | Меню/бой; GS, SD, enhancements | Третий одновременный scratch: выбор героя, палитра/обход предметов, игрок на трамплине. | Оставить: три одновременно живых значения действительно встречаются. |

### 2. Длительные слоты с передачей между фазами — 11

| Переменная | Тип | Фаза / основной код | Назначение | Контракт передачи |
| --- | --- | --- | --- | --- |
| [`phaseSlot0`](global-variable-references-2026-11-01.md#phaseslot0) | Массив → число | GM → S | `startMenuZombieColorList` → `objectiveVisualCleanupIndex`: палитра Zombie Mode, затем индекс очистки глобальных сущностей задания. | HUD удалён; `for` задаёт индекс перед чтением. Цикл с `wait()` сохранён. |
| [`phaseSlot1`](global-variable-references-2026-11-01.md#phaseslot1) | Массив → число | GM → GM, Biomorphing, Satellite | `startMenuObjectiveColorList` → `missionPlacementAttemptCount` / `biomorphingCleanupIndex` / `satelliteFiringStepsRemaining`. | HUD удалён; каждый потребитель задаёт счётчик. Финал этот слот не использует. |
| [`phaseSlot2`](global-variable-references-2026-11-01.md#phaseslot2) | Массив → число | GM → S, Rescue, Satellite | `startMenuEnhancementColorList` → `rescueMinSpawnDistance` / `satelliteMinTerminalSpacing`. | После удаления HUD Rescue присваивает 115, Satellite — 50 до чтений. |
| [`phaseSlot3`](global-variable-references-2026-11-01.md#phaseslot3) | Массив | GS, GM, PM → S, Biomorphing | `challengeVoteList` → `biomorphingResourceNameList`: доступность/подсчёт голосов, затем Head/Arm/Leg. | Голоса подсчитаны до выключения `isVoting`; имена присваиваются до биовизуалов. |
| [`phaseSlot4`](global-variable-references-2026-11-01.md#phaseslot4) | Массив | GS, GM, PM → S, Biomorphing, P | `objectiveTypeVoteList` → `biomorphingResourceColorList`: голоса типов, затем цвета ресурсов/крови и значков игроков. | Палитра целиком задаётся при входе в Biomorphing до HUD и выдачи ресурсов. |
| [`phaseSlot5`](global-variable-references-2026-11-01.md#phaseslot5) | Массив | GS, GM, PM → Biomorphing | `zombieVoteList` → `biomorphingQueuedTypeList`: голоса режима, затем очередь типов ресурсов 0/1/2. | Начало биоцели безусловно создаёт очередь; выдача ожидает снятия `isBiomorphingGoalPending`. |
| [`phaseSlot6`](global-variable-references-2026-11-01.md#phaseslot6) | Строка → вектор | GM → Extraction | `pregameGlitchText` → `extractionFlightDestination`: текст помех, затем общее направление вылета. | После меню больше нет писателей; финал задаёт вектор до `evacSurvivorList`. |
| [`phaseSlot7`](global-variable-references-2026-11-01.md#phaseslot7) | Булево → число | GM → Extraction | `isPregameGlitchActive` → `extractionFlightSpeed`: мигание, затем скорость полёта 2/10/2/50. | Оба ожидания эффекта имеют `ABORT_WHEN_FALSE`; скорость 2 задаётся до списка эвакуируемых. |
| [`phaseSlot8`](global-variable-references-2026-11-01.md#phaseslot8) | Массив → число | GS, GM → nukeMap | `mixedObjectiveTypeList` → `finaleExplosionIndex`: пул Mixed, затем индекс 400 финальных взрывов. | Передача после генерации, не при START GAME; финальный `for` задаёт индекс и при поражении. |
| [`phaseSlot9`](global-variable-references-2026-11-01.md#phaseslot9) | Массив → null/строка | GS, PM → GS, S, Biomorphing | `enhancementOptionList` → `biomorphingGoalText`: иконки меню, затем текст текущей биоцели. | После удаления меню в START GAME выполнен сброс в `null`; он сохраняет прежнее значение до первой биоцели. |
| [`phaseSlot10`](global-variable-references-2026-11-01.md#phaseslot10) | Число → null/цвет | GM, PM → GS, S, Biomorphing | `startMenuSpacingAngle` → `biomorphingGoalColor`: угол и готовность сцены (0 → 40), затем цвет биоцели/HUD/оповещений. | Запись 40 защищена `if isPregameSetup`; после удаления меню START GAME сбрасывает цвет в `null`. |

Эти слоты сохраняют значения через ожидания и переоценку; использовать их как `tmp` нельзя. Комментарии в `variables.opy` фиксируют обе роли, потребителей и границу передачи.

### 3. Константы цветов и позиций — 6

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`offsetUpThreeQuartersConst`](global-variable-references-2026-11-01.md#offsetupthreequartersconst) | Вектор | Меню и бой; GM, GG, Biomorphing, B | `vect(0, 0.75, 0)`, смещение значков/текстов. | Встраивание литерала освобождает слот, но добавляет 7 элементов. Второй приоритет. |
| [`offsetUpHalfConst`](global-variable-references-2026-11-01.md#offsetuphalfconst) | Вектор | Меню и бой; S, PM, GG, Z, SD | `vect(0, 0.5, 0)`, вертикальное смещение. | Встраивание: −1 слот, +7 элементов. |
| [`losOffsetConst`](global-variable-references-2026-11-01.md#losoffsetconst) | Вектор | Бой; S, B, Z, SD | `vect(0, 1.2, 0)`, смещение для проверок видимости. | Встраивание: −1 слот, +25 элементов; многократные обращения, разумно сохранить кеш. |
| [`colorChargeBatteryConst`](global-variable-references-2026-11-01.md#colorchargebatteryconst) | Цвет | Меню и бой; GM, enhancements | Постоянный RGB-цвет батареи. | Встраивание: −1 слот, +12 элементов. |
| [`dummyHoldingPositionConst`](global-variable-references-2026-11-01.md#dummyholdingpositionconst) | Вектор | Генерация зомби, Bosses, Zombie Egg; GS | `vect(500, 500, 500)`, внеигровая позиция ботов. | Встраивание: −1 слот, +23 элемента. |
| [`colorKevlarConst`](global-variable-references-2026-11-01.md#colorkevlarconst) | Цвет | Меню и бой; GM, enhancements | Постоянный RGB-цвет Kevlar. | Самая дешёвая дополнительная замена среди цветов/векторов: −1 слот, +5 элементов. |

### 4. Состояние и настройки матча — 12

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`isPregameSetup`](global-variable-references-2026-11-01.md#ispregamesetup) | Булево | Весь жизненный цикл; GS, GM, PM, S, P, B, debug | Идёт выбор героев/голосование; START GAME выключает флаг до генерации миссий и активации боя. | Сохранить отдельным флагом фазы. Он не совпадает с isGameplayActive и не описывает тип режима карты. |
| [`isSpecialGameMode`](global-variable-references-2026-11-01.md#isspecialgamemode) | Булево | Инициализация → бой; GS, GM, PM, GG, P | Постоянный признак особой обработки TDM/CTF/PUSH/CONTROL, независимый от предматчевой фазы и objective type. | Сохранить кеш определения базового режима. Значение нужно и в меню, и в бою. |
| [`isGameplayActive`](global-variable-references-2026-11-01.md#isgameplayactive) | Булево | Весь жизненный цикл; большинство модулей | Активная игровая часть, начинается после генерации и выключается при исходе матча. | Сохранить; отличается от `isGameInProgress()` и завершения меню. |
| [`isOvertimeActive`](global-variable-references-2026-11-01.md#isovertimeactive) | Булево | Конец таймера; GG | Однократность включения овертайма/телепорта зомби на обычных картах. | Полезный флаг, хотя всего две строки обращений. Удаление допускает повторные срабатывания при изменениях доступности зомби. |
| [`isVoting`](global-variable-references-2026-11-01.md#isvoting) | Булево | Предматчевое голосование; S, GS, GM, PM | Глобальный флаг голосования; поле игрока isPregameVoting показывает участие конкретного игрока. | Резерв после меню, но сначала исключить поздние вызовы setPrematchTimer. Общий флаг и поле игрока — разные данные. |
| [`difficultySetting`](global-variable-references-2026-11-01.md#difficultysetting) | Число | Меню, затем весь бой; S, PM, Showdown, P, B | Масштаб сложности по числу игроков; используется характеристиками и боевыми правилами. | Сохранить кеш; не путать с результатом голосования `challengeSetting`. |
| [`challengeSetting`](global-variable-references-2026-11-01.md#challengesetting) | Число | Меню → бой; GM, S, GG, P | Выбранный Challenge, влияет на урон/абилити/характеристики/возрождение. | Сохранить результат голосования. |
| [`zombieSetting`](global-variable-references-2026-11-01.md#zombiesetting) | Число | Меню → бой; GM, S, GG, Bosses | Выбранный режим состава/вероятностей зомби, также Shuffle и выбор боссов. | Не только меню: сохранить результат. |
| [`objectiveTypeSetting`](global-variable-references-2026-11-01.md#objectivetypesetting) | Число | Меню, генерация и HUD Bosses; GM, S, PM | Выбранный режим заданий либо Mixed; это не текущий тип. | До генерации необходим. Для освобождения после неё сначала убрать/обосновать отдельное чтение в HUD Bosses. |
| [`matchEndTime`](global-variable-references-2026-11-01.md#matchendtime) | Число | Инициализация → бой; GS, GG, P, B | Поправка порога времени: 0 либо 0.1 в зависимости от базового режима. | Можно вычислять выражением режима, но много потребителей; это дополнительный, менее выгодный кандидат. |
| [`uniqueSkinCap`](global-variable-references-2026-11-01.md#uniqueskincap) | Число | Весь бой; GS, Bosses, Egg | Настраиваемый лимит разных героев/скинов для создания зомби и боссов. | Сохранить настройку; замена на число потеряет пользовательскую конфигурацию. |
| [`numberOfBots`](global-variable-references-2026-11-01.md#numberofbots) | Число | Весь бой; GS, B | Настраиваемое число зомби и ограничение очереди появления. | Неизменяемая настройка, но не фиксированная константа 6; прямое встраивание Setting — отдельный компромисс. |

### 5. Карта и кеши появления — 10

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`walkCenter`](global-variable-references-2026-11-01.md#walkcenter) | Вектор | Инициализация, меню и бой; GS, GM, P | Центр карты для сетки, сцены меню и телепорта игроков на особых картах. | Сохранить: используется и при позднем входе игроков. |
| [`mapGridList`](global-variable-references-2026-11-01.md#mapgridlist) | Массив | Инициализация → бой/финал; GS, GM, задания, P, Z, SD | Сетка точек для размещения целей, телепортов, припасов и финальных эффектов. | Сохранить. Важный многократно используемый кеш дорогого поиска точек. |
| [`attackSpawnRooms`](global-variable-references-2026-11-01.md#attackspawnrooms) | Смешанный | Подготовка и бой; GS, GG | На обычных режимах — массив позиций комнат спавна; в отдельной ветке CTF сохраняется одна позиция. Эта ветка не участвует в стандартной ротации комнат. | Сохранить: данные нужны в бою. Из-за смешанного типа имя оставлено нейтральным, без List. |
| [`activeAttackSpawnRoom`](global-variable-references-2026-11-01.md#activeattackspawnroom) | Вектор | Подготовка и бой; GS, GG | Позиция действующей комнаты спавна. | Не гарантированно равна `attackSpawnRooms[spawnRoomIndex]`: индекс может продвинуться, а кандидат — быть отклонён. Удаление кеша изменит смысл. |
| [`spawnRoomIndex`](global-variable-references-2026-11-01.md#spawnroomindex) | Число | Подготовка и бой; GS, GG | Индекс при сборе комнат, затем индекс проверяемой комнаты спавна. | Уже используется в двух фазах, не освобождается после меню. |
| [`botSpawnPointList`](global-variable-references-2026-11-01.md#botspawnpointlist) | Массив | Весь бой; B | Кеш удачных позиций появления/телепорта. | Сохранить: экономит повторный поиск и проверки. |
| [`botSpawnPointTimerList`](global-variable-references-2026-11-01.md#botspawnpointtimerlist) | Массив | Весь бой; GS, B | Загруженность/задержки кешированных точек появления, растут при использовании и уменьшаются раз в секунду. | Сохранить; не равно очереди `botSpawnTimeList`. |
| [`botSpawnWaypointList`](global-variable-references-2026-11-01.md#botspawnwaypointlist) | Массив | Весь бой; B | Связанная с каждой кешированной точкой позиция для направления движения зомби. | Не дубликат `botSpawnPointList`; сохранить. |
| [`customTeleportPositionList`](global-variable-references-2026-11-01.md#customteleportpositionlist) | Массив | Весь бой; B | Передача специальных позиций от погибшего бота новому при создании/инициализации. | Полезная очередь, сохранить. |
| [`botSpawnTimeList`](global-variable-references-2026-11-01.md#botspawntimelist) | Массив | Весь бой; GS, B, Kill Zone, Satellite | Очередь задержек новых зомби, секундное уменьшение и отсрочка после задания. | Сохранить: работает параллельно всем типам миссий. |

### 6. Сцена предматчевого меню — 2

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`startPos`](global-variable-references-2026-11-01.md#startpos) | Вектор | Меню и выход из него; GM, PM | Центр сцены выбора героя, ориентир камеры и построения позиций игроков. | Резерв для объединения после остановки камер и завершения старых правил меню. Немедленная перезапись при смене флага опасна. |
| [`startCamPos`](global-variable-references-2026-11-01.md#startcampos) | Вектор | Меню и выход из него; GM, PM | Позиция камеры, построение сцены и мировых надписей. | Аналогично `startPos`: дождаться прекращения зависимых действий, затем можно переиспользовать. |

### 7. Общее состояние заданий — 17

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`objectivePositionList`](global-variable-references-2026-11-01.md#objectivepositionlist) | Массив | Генерация → весь бой/финал; S, GM, задания, P, B, Z, SD | Очередь позиций миссий; первый элемент — текущая, последний — эвакуация. | Сохранить. Нельзя заменить одной текущей позицией без потери очереди. |
| [`objectiveTypeList`](global-variable-references-2026-11-01.md#objectivetypelist) | Массив | Генерация → бой; S, GM, задания, P, B | Очередь типов; текущий тип читается напрямую как `objectiveTypeList[0]`, удаление первого элемента переключает задание. | Сохранить; промежуточный макрос для текущего типа удалён, результат компиляции не изменился. |
| [`objectiveSpacingList`](global-variable-references-2026-11-01.md#objectivespacinglist) | Массив | Конец построения сетки → генерация заданий; GS, GM | Две вычисленные дистанции между целями по размеру сетки. | Освобождается после генерации, а не при исчезновении меню. Возможен поздний reuse; учитывать отдельную корутину generateMapGrid. |
| [`objectiveValue`](global-variable-references-2026-11-01.md#objectivevalue) | Число | Обновление HUD/значков задания; S, P | Снимок типа, опубликованный при обновлении глобальных сущностей; сравнивается с player `objectiveTypeSnapshot`. | Сохранить. Замена на прямое чтение `objectiveTypeList[0]` меняет момент обновления относительно ожиданий и удаления HUD. |
| [`objectiveProgressSlot`](global-variable-references-2026-11-01.md#objectiveprogressslot) | Смешанный | Showdown, Biomorphing, Kill Zone, Satellite; S, B | Число для Showdown/Biomorphing/Kill Zone или массив трёх процентов терминалов Satellite. Это намеренно смешанный слот. | Уже переиспользуется между типами. Сохранить модель, обеспечить корректную инициализацию типа значения. |
| [`objectiveRad`](global-variable-references-2026-11-01.md#objectiverad) | Число | Практически весь бой; S, задания, B, Z | Радиус текущего задания: 0/3/3.5/10/20/30 и изменяемый радиус Showdown. | Уже общий. Это не константа; также является целью `chase`. |
| [`objectiveDescription`](global-variable-references-2026-11-01.md#objectivedescription) | Строка | Весь бой; S, GS, GG | Текст текущей задачи в общей верхней строке. | Сохранить; подстановка выражения выбора типа утяжелит постоянную переоценку. |
| [`objectiveColor`](global-variable-references-2026-11-01.md#objectivecolor) | Цвет | Showdown, Biomorphing, Satellite; S и задания | Цвет задания, включая мигание при потере прогресса. | Уже общий; не является неизменяемой палитрой. |
| [`isObjectiveComplete`](global-variable-references-2026-11-01.md#isobjectivecomplete) | Булево | Весь бой; S, GG, задания, P | Запрос завершения/смены задания, синхронизация правил и восстановления игроков. | Сохранить отдельным общим флагом. |
| [`objectivePlayerList`](global-variable-references-2026-11-01.md#objectiveplayerlist) | Массив | Весь бой; S, GG, задания, P, B | Участники текущей точки/ремонта/сдачи ресурсов/эвакуации. | Уже общий; не объединять с глобальным списком целей зомби. |
| [`objectiveEntityIdList`](global-variable-references-2026-11-01.md#objectiveentityidlist) | Массив | Весь бой и смена задания; S, Satellite | ID глобальных эффектов, HUD, значков и лазерных лучей для последующей очистки. | Сохранить. Список должен переживать создание и удаление задания. |
| [`objectivePositionsSlot`](global-variable-references-2026-11-01.md#objectivepositionsslot) | Массив | Biomorphing и Satellite; S, оба задания | Позиции биоресурсов либо терминалов. | Уже общий для двух режимов. |
| [`objectivePlacementSlot`](global-variable-references-2026-11-01.md#objectiveplacementslot) | Вектор | Генерация заданий, затем Survivor Rescue; GM, Rescue | Кандидат позиции, сохраняемый через ожидание. | Уже совмещены две фазы. Дополнительное объединение с состоянием других типов возможно после защиты переходов. |
| [`objectiveMotionSlot`](global-variable-references-2026-11-01.md#objectivemotionslot) | Смешанный | Survivor Rescue, Kill Zone, Satellite; S, задания, B | Сохранённый радиус Rescue, движущийся центр Kill Zone, позиция спутникового луча. | Уже полноценный общий слот состояния разных типов, аналог `enhancementValue`. |
| [`objectiveCheckpointSlot`](global-variable-references-2026-11-01.md#objectivecheckpointslot) | Число | Showdown и Biomorphing; S и оба задания | Следующий порог прогресса: 25/50/75/100. | Уже общий для двух типов. |
| [`objectiveQueueSlot`](global-variable-references-2026-11-01.md#objectivequeueslot) | Массив | Showdown и Biomorphing; S, оба задания, B | Зомби на точке либо очередь требуемых биоматериалов. | Уже общий, но B читает его вне строгой проверки типа, включая переоцениваемый значок. Не расширять объединение простым переименованием. |
| [`objectiveActorSlot`](global-variable-references-2026-11-01.md#objectiveactorslot) | Игрок | Survivor Rescue и Satellite; S, Rescue, Satellite, B | Спасаемый NPC либо текущая цель спутникового луча. | Уже совмещён. При расширении объединения учитывать фоновые правила и обращения после ожиданий. |

### 8. Состояние Biomorphing — 6

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`isBiomorphingGoalPending`](global-variable-references-2026-11-01.md#isbiomorphinggoalpending) | Булево | Biomorphing; S, задание | Запрос переключения биоцели/очистки ресурсов; сбрасывается также общим менеджером заданий. | Кандидат совмещения после защиты ожиданий; сброс сам по себе не останавливает выполняющееся правило. |
| [`biomorphingResourceTypeList`](global-variable-references-2026-11-01.md#biomorphingresourcetypelist) | Массив | Biomorphing | Тип каждого лежащего ресурса, параллельно массиву позиций. | Можно в будущем совмещать с состоянием других типов, например `phaseSlot2`, после устранения поздних записей из BIO GOAL START. |
| [`biomorphingDeferredTypeList`](global-variable-references-2026-11-01.md#biomorphingdeferredtypelist) | Массив | Biomorphing и его фоновые хвосты | Очередь типов ресурсов, выпавших при смерти, для отложенного создания. | Не освобождать просто при смене типа: `BIOWASTE MANAGEMENT` проверяет только длину этой очереди. |
| [`biomorphingDeferredPositionList`](global-variable-references-2026-11-01.md#biomorphingdeferredpositionlist) | Массив | Biomorphing и его фоновые хвосты | Позиции, соответствующие `biomorphingDeferredTypeList`. | Живёт одновременно с очередью типов; объединение в массив записей добавляет индексирование. Учитывать фоновый обработчик. |
| [`biomorphingResourceTextIdList`](global-variable-references-2026-11-01.md#biomorphingresourcetextidlist) | Массив | Biomorphing | ID мировых надписей лежащих ресурсов. | Сохранить до удаления надписей; не накладывать поверх ID других активных сущностей. |
| [`biomorphingResourceEffectIdList`](global-variable-references-2026-11-01.md#biomorphingresourceeffectidlist) | Массив | Biomorphing | ID эффектов лежащих ресурсов. | Сохранить до удаления эффектов. Наследование непустого массива палитры меню потребовало бы отдельного сброса. |

### 9. Эвакуация и финальные эффекты — 4

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`extractionZoneRad`](global-variable-references-2026-11-01.md#extractionzonerad) | Число | Инициализация → весь бой; S, Extraction, P | Начальное значение 300, затем сжимающийся купол. Его `<= 0` также означает поражение. | Сохранить до корректного переноса инициализации. Оставить 0 до эвакуации нельзя: WIN/LOSS проверяет его и раньше. |
| [`extractionSpeedUp`](global-variable-references-2026-11-01.md#extractionspeedup) | Число | Инициализация → эвакуация; GS, S, Extraction | Скорость сжатия: начальные 2.5, затем растёт от присутствия игроков. | Не константа. Для совместного слота с углом меню перенести начальную запись на завершённую границу фаз. |
| [`evacSurvivorList`](global-variable-references-2026-11-01.md#evacsurvivorlist) | Массив | Успешный финал и nukeMap | Снимок спасённых игроков, условие запуска анимации и исключение из финального убийства. | Сохранить снимок; `objectivePlayerList` — другой, изменяемый список. Возможна передача корректно очищенного слота после меню. |
| [`menuFinaleMotionSlot`](global-variable-references-2026-11-01.md#menufinalemotionslot) | Смешанный | Меню и финал; GS, GM, S, Extraction | Скрытый предматчевый таймер, затем летящая точка ядерного эффекта. | Уже совмещены разные фазы. Перед финальным использованием есть `stopChasing`; аналогичный контракт нужен новым совмещениям. |

### 10. Припасы и лежащие предметы — 8

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`supplyDropLandingPosition`](global-variable-references-2026-11-01.md#supplydroplandingposition) | Вектор | Весь бой; SD | Выбранная конечная позиция припасов, условия взаимодействия и отображения. | Сохранить отдельно от движущейся позиции. |
| [`supplyDropPosition`](global-variable-references-2026-11-01.md#supplydropposition) | Вектор | Весь бой; SD | Текущая позиция падающего ящика, цель `chase`, координата визуализации. | Не дубликат `supplyDropLandingPosition` во время падения. |
| [`isSupplyDropOpen`](global-variable-references-2026-11-01.md#issupplydropopen) | Булево | Весь бой; GS, SD | Ящик открыт/разрешён следующий, также управляет визуализацией. | Не выводится только из null позиции; сохранить. |
| [`supplyDropPowerUpCount`](global-variable-references-2026-11-01.md#supplydroppowerupcount) | Число | Инициализация → весь бой; GS, SD | Workshop Setting количества предметов и их расстановки. | Не заменять фиксированным 5; встраивание самого Setting можно рассматривать отдельно. |
| [`supplyPowerUpIdList`](global-variable-references-2026-11-01.md#supplypowerupidlist) | Массив | Весь бой; SD, PU, Biomorphing | ID типов всех лежащих предметов, включая награды Biomorphing. | Нельзя освобождать при выходе из Biomorphing: предметы остаются на земле. |
| [`supplyPowerUpPositionList`](global-variable-references-2026-11-01.md#supplypoweruppositionlist) | Массив | Весь бой; SD, PU, Biomorphing | Позиции предметов, параллельно `supplyPowerUpIdList`. | Сохранить; объединение в записи потребует второго индексирования. |
| [`supplyPowerUpTextIdList`](global-variable-references-2026-11-01.md#supplypoweruptextidlist) | Массив | Весь бой; SD, PU | ID подписей лежащих предметов для удаления при подборе/обмене. | Полезный список ID, сохранить до уничтожения текстов. |
| [`supplyPowerUpEffectIdList`](global-variable-references-2026-11-01.md#supplypowerupeffectidlist) | Массив | Весь бой; SD, PU | ID эффектов предметов для удаления при подборе/обмене. | Полезный список ID, живёт одновременно с `supplyPowerUpTextIdList`. |

### 11. Игроки, повторный вход и воскрешение — 5

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`playerTargetList`](global-variable-references-2026-11-01.md#playertargetlist) | Массив | Весь бой; S, GG, задания, P, B, Z, SD, enhancements | Доступные цели зомби, включая временно добавляемого спасаемого NPC. | Сохранить: не равен всем игрокам команды или участникам точки. |
| [`userNameList`](global-variable-references-2026-11-01.md#usernamelist) | Массив | Весь бой; P | Имена/идентификаторы для связывания повторно вошедшего игрока с сохранённой статистикой. | Сохранить совместно с `playerStatsList`. |
| [`playerStatsList`](global-variable-references-2026-11-01.md#playerstatslist) | Массив | Весь бой, включая выход/повторный вход; P | Сохранённые статус смерти, таймеры и позиция по индексу пользователя. | Сохранить: данные переживают отсутствие игрока. |
| [`healthpackPositionList`](global-variable-references-2026-11-01.md#healthpackpositionlist) | Массив | Весь бой; P, GG | Обнаруженные позиции аптечек, используется указателем лечения заражения. | Полезный накапливаемый кеш; сохранить. |
| [`mustReviveTime`](global-variable-references-2026-11-01.md#mustrevivetime) | Число | Весь бой; GS, P | Допустимое время спасения: начинает с 60, уменьшается после окончательных смертей до 30. | Сохранить: не константа 60. |

### 12. Общие характеристики зомби, мутации и боссы — 11

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`botHeroList`](global-variable-references-2026-11-01.md#botherolist) | Массив | После голосования → весь бой; GM, GS, S, Bosses, Egg | Таблица героев и порядок индексов всех характеристик зомби. | Сохранить: основа связанных таблиц. |
| [`botSpawnRateList`](global-variable-references-2026-11-01.md#botspawnratelist) | Массив | После голосования → весь бой; GM, GS, GG, Bosses | Веса появления; Shuffle перемешивает их во время матча. | Сохранить: не только настройка меню. |
| [`botBiteDamageList`](global-variable-references-2026-11-01.md#botbitedamagelist) | Массив | Весь бой; S | Таблица урона укусов по герою и сложности. | Сохранить кеш; объединение с другими таблицами добавит индексирование в инициализации зомби. |
| [`botBiteDurationList`](global-variable-references-2026-11-01.md#botbitedurationlist) | Массив | Весь бой; S | Таблица длительности укуса/эффекта по герою и сложности. | Аналогично: работает, не кандидат удаления. |
| [`botDamageDealtList`](global-variable-references-2026-11-01.md#botdamagedealtlist) | Массив | Весь бой; S | Таблица множителей наносимого урона; участвует также в калибровке укуса. | Сохранить кеш. |
| [`botHealthList`](global-variable-references-2026-11-01.md#bothealthlist) | Массив | Весь бой; S | Таблица здоровья зомби по герою и сложности. | Сохранить кеш; меняется при пересчёте числа игроков. |
| [`botThrottleSpeedList`](global-variable-references-2026-11-01.md#botthrottlespeedlist) | Массив | Весь бой; S | Таблица скорости движения по герою и сложности. | Сохранить кеш. |
| [`availableMutationList`](global-variable-references-2026-11-01.md#availablemutationlist) | Массив | Инициализация → весь бой; GS, S | Разрешённые мутации из Workshop Settings. | Сохранить: конфигурация и многократный выбор. |
| [`miniBossList`](global-variable-references-2026-11-01.md#minibosslist) | Массив | Весь бой; S, Bosses, B, Z | Список усиленных минибоссов, исключения и специальные способности. | Сохранить отдельно от `bossStateList`: обе категории существуют одновременно. |
| [`bossStateList`](global-variable-references-2026-11-01.md#bossstatelist) | Массив | Bosses, Zombie Egg и общие боевые правила; S, B, Z, SD, enhancements | Общее состояние Bosses/Zombie Egg: [0] — игрок-босс/яйцо, [1] — измерение высоты головы. Также читается общими боевыми правилами. | Уже общий для двух типов, но читается глобально. Не отдавать другому режиму без изоляции всех потребителей. |
| [`isSmolderEventActive`](global-variable-references-2026-11-01.md#issmoldereventactive) | Булево | Бой; S, GS, GG, P, Z | Глобальная фаза события Winston/Smolder, влияет на спавн, HUD, эффекты и способности. | Не принадлежит только одному objective type, сохранить отдельное состояние. |

### 13. Ротация героев задания Bosses — 2

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`bossesAvailableHeroList`](global-variable-references-2026-11-01.md#bossesavailableherolist) | Массив | Между всеми Bosses-заданиями; Bosses | Ротация ещё не выбранных героев босса; выбранный герой удаляется, список пополняется при исчерпании. | **Не освобождается на время другого типа задания**: сохранение очереди предотвращает ранние повторы боссов. |
| [`bossesExcludedHeroList`](global-variable-references-2026-11-01.md#bossesexcludedherolist) | Массив | Подготовлен после голосования; Bosses | Исключения из списка доступных героев большого босса. | Постоянный список, но нужен последующим Bosses; встраивание добавит литералы. |

### 14. Данные отдельных модулей — 2

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`numbersList`](global-variable-references-2026-11-01.md#numberslist) | Массив | Инициализация и бой; S, GM, compressed numbers | Общая сжатая таблица чисел для характеристик, вероятностей и индексов меню. | Сохранить: уже объединяет много таблиц без отдельных глобальных слотов для каждого исходного набора. |
| [`debugHud`](global-variable-references-2026-11-01.md#debughud) | Число | Все фазы; debug.opy | ID диагностического HUD для удаления/пересоздания после общей очистки текстов. | Полезен в debug-сборке. Удаление подключения debug освобождает слот, но также убирает диагностику и усиления хоста. Это изменение состава сборки. |

## Оставшиеся варианты передачи слотов между фазами

**Статус: девять основных передач внедрены; дополнительно внедрены передачи иконок улучшений тексту Biomorphing и угла меню цвету Biomorphing.** Заголовок сохранён для поиска исходных предложений. Все роли в таблице ниже — `#!define`-алиасы, а не отдельные `globalvar`; соответствующие физические слоты перечислены выше.

| До передачи | После передачи | Граница времени жизни и инициализация получателя |
| --- | --- | --- |
| `startMenuZombieColorList` | `objectiveVisualCleanupIndex` | После удаления предматчевого HUD; цикл очистки сначала присваивает индекс. |
| `startMenuObjectiveColorList` | `missionPlacementAttemptCount` / `biomorphingCleanupIndex` / `satelliteFiringStepsRemaining` | После удаления HUD; генерация миссий присваивает 0, Satellite позже запускает собственный for. |
| `startMenuEnhancementColorList` | `rescueMinSpawnDistance` / `satelliteMinTerminalSpacing` | После удаления HUD; Rescue присваивает 115, Satellite — 50 до чтений. |
| `challengeVoteList` | `biomorphingResourceNameList` | Подсчёт и меню закончены; таблица имён задаётся при входе в Biomorphing до создания его HUD. |
| `objectiveTypeVoteList` | `biomorphingResourceColorList` | Аналогично; таблица цветов задаётся перед зависимыми визуальными сущностями. |
| `zombieVoteList` | `biomorphingQueuedTypeList` | Подсчёт закончен; начало биоцели безусловно создаёт новую очередь до выдачи ресурсов. |
| `pregameGlitchText` | `extractionFlightDestination` | Меню и его тексты завершены; направление полёта записывается перед запуском эвакуации игроков. |
| `isPregameGlitchActive` | `extractionFlightSpeed` | Правило мигания прекращает изменения через ABORT_WHEN_FALSE; скорость 2 записывается до списка эвакуируемых. |
| `mixedObjectiveTypeList` | `finaleExplosionIndex` | Только после завершения генерации очереди миссий; финальный for присваивает счётчик до чтения. |
| `enhancementOptionList` | `biomorphingGoalText` | После удаления HUD и мировых надписей START GAME восстанавливает `null`, до первого создания биовизуалов. |
| `startMenuSpacingAngle` | `biomorphingGoalColor` | После удаления меню START GAME восстанавливает `null`; финальная запись угла 40 выполняется только при `isPregameSetup`. |

**Результат внедрения одиннадцати пар: 99 переменных, 27 218 элементов; −11 слотов и +5 элементов к исходной базе.** Девять основных пар сами по себе не добавляют элементов; сброс текста стоит 1 элемент. Передача угла цвету добавляет ещё 4: 3 на `if isPregameSetup` и 1 на сброс цвета. Относительно предыдущего этапа 100 / 27 214 это −1 слот / +4 элемента.

Для первых трёх пар критично удаление переоцениваемых HUD перед перезаписью палитр. Окончание голосования само по себе эту границу не создаёт: меню ещё видно. Для `mixedObjectiveTypeList` граница другая — окончание генерации, а не START GAME. Получатель должен присвоить значение до любого чтения; обнуление всех доноров одним пакетом не требуется и не заменяет эту проверку.

### Проверка рисков передачи

Проверены реальные писатели, первые чтения получателей, ожидания и переоцениваемые визуальные сущности. START GAME выключает `isPregameSetup`, удаляет HUD и мировые надписи без ожиданий между этими действиями, сбрасывает текст и только затем делает `wait(0.25)`. Генератор заданий ожидает выключения флага; первая перезапись палитры происходит при инициализации счётчика генерации. Прежние циклы и их ожидания сохранены.

Голосующие обработчики не содержат ожиданий внутри чтения/подсчёта таблиц. Цепочка `determineZombieMode` → `determineChallenge` → `determineObjectiveType` заканчивает подсчёт до `isVoting = false`; меню после этого читает выбранные настройки, а не таблицы голосов. Записи иконок и пула Mixed в SKIP ASSEMBLING HEROES расположены до его последующих ожиданий. Повторный вход во время боя не запускает предматчевые обработчики, поскольку их условия требуют `isPregameSetup`.

Оба ожидания SPECIAL EFFECT CONTROLS используют `ABORT_WHEN_FALSE`, поэтому прежний писатель флага мигания прекращается при выходе из меню. Направление и скорость полёта задаются до публикации `evacSurvivorList`; без этой публикации анимация игроков их не читает. Генерация полностью заканчивается до `isGameplayActive = true`; победа/поражение и `nukeMap` требуют уже начатого боя. Поэтому Mixed-пул можно отдавать финалу даже при поражении во время лазера: лазер пользуется другим физическим счётчиком (`phaseSlot1`).

`enhancementOptionList` → `biomorphingGoalText` внедрён со сбросом: без него HUD первого Biomorphing мог бы временно получить массив иконок вместо прежнего `null`, пока BIOMORPHING GOAL START проходит ожидания. После удаления меню старых читателей иконок нет; сброс расположен до возобновления генерации и создания HUD.

**Внедрено с защитой: `startMenuSpacingAngle` → `biomorphingGoalColor`.** GLOBAL MENU INITIALIZATION может продолжаться после обычных `wait()` при создании dummy или поиске сцены. Поэтому одного переименования недостаточно. Его единственная запись угла 40 теперь заключена в `if isPregameSetup`: если правило возобновится после START GAME, оно пропустит запись. До готовности меню слот по-прежнему равен нулю. Чтения угла в PLAYER MENU INITIALIZATION идут после прерываемого ожидания, без новых ожиданий до чтения; PLAYER SELECTS/RESELECTS HERO использует угол только в условии запуска, а после обычных ожиданий к нему не обращается. HUD меню угол не читает. После выключения предматчевого флага слот сбрасывается в `null` до ближайшего ожидания START GAME, сохраняя исходный цвет первого HUD до записи из BIOMORPHING GOAL START.

Поздние записи самого BIOMORPHING GOAL START теперь могут менять только цвет: меню к этому моменту закончено и повторно не запускается. В отличие от пары с `objectiveMotionSlot`, у второго владельца нет параллельного Satellite-chase или восстановления радиуса Rescue. Сценарий поздней записи угла проверяется по скомпилированному условию; планирование движка статически не моделируется.

**`startMenuSpacingAngle` → `extractionSpeedUp` больше не является свободным вариантом:** слот уже отдан цвету Biomorphing, который может записываться после ожиданий и при поражении. Ранняя инициализация скорости купола 2.5 сохранена. Прежние пробы угла/скорости удалены из актуальных результатов.

Статическая проверка не воспроизводит планирование Workshop. Контракт также запрещает принудительный повторный запуск меню/подсчёта голосов во время боя. Игровые сценарии перечислены в конце отчёта.

## Состояние разных заданий: что уже общее

| Слот | Значения по типам задания |
| --- | --- |
| `objectiveProgressSlot` | `showdownCapturePercent` / `biomorphingCapturePercent` / `killZoneEliminationScore` / `satelliteTerminalProgressList`. |
| `objectiveMotionSlot` | `rescueSavedRadius` / `killZoneCenter` / `satelliteLaserPosition`. |
| `objectiveActorSlot` | `rescueSurvivor` / `satelliteLaserTarget`. |
| `objectivePositionsSlot` | `biomorphingResourcePositionList` / `satelliteTerminalPositionList`. |
| `objectiveQueueSlot` | `showdownContestingZombieList` / `biomorphingGoalQueueList`. |
| `objectiveCheckpointSlot` | `showdownNextCheckpoint` / `biomorphingNextCheckpoint`. |
| `objectivePlacementSlot` | `missionCandidatePosition` / `rescueCandidatePosition`. |
| `phaseSlot1` | `missionPlacementAttemptCount` / `biomorphingCleanupIndex` / `satelliteFiringStepsRemaining`; до генерации — палитра меню. |
| `phaseSlot2` | `rescueMinSpawnDistance` / `satelliteMinTerminalSpacing`; до генерации — палитра меню. |
| `menuFinaleMotionSlot` | `pregameCountdown` / `nukeProjectilePosition`; перед передачей выполнен `stopChasing(pregameCountdown)`. |
| `bossStateList` | `bossesStateList` / `zombieEggStateList`; общий второй элемент — высота головы. |

Значительная часть ожидаемой экономии между типами уже реализована этими слотами. Большинство оставшегося специализированного состояния относится к Biomorphing и нужно одновременно внутри одного задания. Его поля нельзя объединить друг с другом только по принадлежности одной механике.

Дополнительные пары для дальнейшего анализа: `biomorphingResourceTypeList` ↔ `phaseSlot2`, `biomorphingGoalText` ↔ `objectiveActorSlot`. У них требуется защита передачи от поздних записей, старых визуальных сущностей и активных chase. Ранее предложенная `biomorphingGoalColor` ↔ `objectiveMotionSlot` не внедрена: вместо неё цвету передан угол меню с защитой последней записи. Дополнительная экономия не складывается автоматически с уже занятыми слотами.

### Уже объединённый счётчик phaseSlot1

В текущих исходниках один слот обслуживает три участка:

- Генерация миссий использует `missionPlacementAttemptCount` до `isGameplayActive = true` и завершает работу до запуска биоцелей.
- BIOMORPHING GOAL START использует `biomorphingCleanupIndex` только внутри начального цикла удаления эффектов и надписей. Последующий `waitUntil(biomorphingCapturePercent == 0, 3)` и оставшаяся часть правила счётчик не читают.
- Satellite использует `satelliteFiringStepsRemaining` в цикле стрельбы и выставляет `isObjectiveComplete = true` после завершения fireSatelliteMacro. В обратном направлении стрельбе предшествуют ремонт терминалов и подготовка выстрела.

Каждый участок задаёт своё начальное значение перед чтениями. Полный цикл очистки, обычный `wait()` и расположенные ниже сбросы массивов сохранены. Дополнительные действия и прерывания в эти циклы не добавлены. Текущая база учитывает и это прежнее объединение, и новые передачи фаз: **99 глобальных переменных, 27 218 элементов**. У каждого потребителя `phaseSlot1` теперь свой алиас; до генерации слот хранит палитру типов заданий.

`Wait.ABORT_WHEN_FALSE` в очистку не добавлен: при потере условия он прервал бы всё правило и мог оставить часть эффектов/надписей и сбросов необработанными. Сравнение скомпилированного кода подтвердило, что изменение ограничено общим счётчиком; игровой прогон переходов Biomorphing ↔ Satellite ещё не проводился.

### Что мешает расширять объединение простым переименованием

1. `BIOWASTE MANAGEMENT` проверяет только длину `biomorphingDeferredTypeList` и продолжает создание ресурсов через `wait(0.15)`. Тип задания его напрямую не останавливает.
2. `BIOMORPHING GOAL START` содержит ожидания и может позже записывать `biomorphingGoalText`, `biomorphingGoalColor`, очереди и `isBiomorphingGoalPending`. Это важно для объединения этих полей, даже когда счётчик очистки уже не нужен.
3. `SURVIVOR FOLLOW TARGET` после ожидания восстанавливает `objectiveRad` из `rescueSavedRadius` и очищает связанные с `rescueSurvivor` поля. Отдельная ветка восстановления ждёт до 20 секунд.
4. При поражении во время Satellite лазерная последовательность может ещё выполнять 40 шагов. Поэтому `phaseSlot1` ↔ `finaleExplosionIndex` опаснее `mixedObjectiveTypeList` ↔ `finaleExplosionIndex`.
5. Старые глобальные визуальные сущности удаляются по одной с ожиданиями. До удаления переоценка может читать прежние слоты. Значки биоресурсов у игроков удаляются отдельным обработчиком.
6. `bossesAvailableHeroList` сохраняет ротацию между Bosses-миссиями даже при другом текущем типе. Power-up награды также остаются на земле после окончания Biomorphing, поэтому массивы `supplyPowerUp*List` продолжают использоваться.

Для расширенного распределения сначала определить порядок выхода: завершить либо корректно отменить старую работу, удалить зависимые визуальные сущности и остановить нужные chase, затем передать слот новому владельцу. Одна проверка текущего типа не различает два последовательных задания одного типа. Если старый обработчик может пережить такой переход, потребуется различать экземпляры заданий или гарантировать его завершение. Стоимость дополнительного механизма в приведённые пробы не включена.

## Текущие измерения

Оставшиеся варианты заново скомпилированы относительно **99 переменных / 27 218 элементов**. [Полные результаты](global-variable-probes-2026-11-01.json) содержат 7 вариантов, изменённые файлы и предупреждения. Уже внедрённые пары исключены из проб. Компиляция подтверждает размер и разрешение имён, но не безопасность асинхронного времени жизни и не нагрузку сервера.

| Вариант | Глобальных | Элементов | Разница элементов |
| --- | ---: | ---: | ---: |
| Текущий код: одиннадцать передач фаз | 99 | 27 218 | 0 |
| Дополнительно: литерал цвета Kevlar | 98 | 27 223 | +5 |
| Дополнительно: шесть цветов/векторов литералами | 93 | 27 297 | +79 |

Шесть векторных/RGB-констант можно встроить независимо от фаз. Самый дешёвый отдельный вариант — `colorKevlarConst`: −1 слот и +5 элементов. Остальные цены указаны в их строках полного списка. Полный набор добавляет 79 элементов, около 0.29% текущей сборки, и размножает выражения в местах использования, включая переоцениваемые аргументы. Измерения нагрузки в игре нет; внедрённые передачи обходятся без этого компромисса.

Упаковка часто читаемых кешей/таблиц характеристик в один большой массив также сократит слоты, но добавит индексирование. После внедрения одиннадцати передач кеши позиций и таблицы зомби сохранены; упаковка остаётся отдельным компромиссом для дальнейшей работы.

## Приоритет и проверка при внедрении

После переименования полей игрока `verify-phase-slots.cjs` нормализует их имена отдельно от глобальных. Для `debug.opy` в исходной фазовой базе используется версия из коммита `9185ddd9b8bc76852ffacdafbfde932a3970f152`: настройка усилений хоста была изменена и закоммичена отдельно от логики слотов. Это исключение записано в `baselineOverrides` результата проверки. Сам рефакторинг playervar сравнивается целиком с этим коммитом без исключений.

Статически выполнено: проверка границ передачи и инициализации новых ролей; сравнение всех 231 скомпилированного правила; сборка через обычные `#!include` и обновление локального `src/main.ws.txt`; проверка времени жизни `tmp`; пересоздание индекса с разрешением алиасов и компиляционных проб. [Результат сравнения](phase-slots-validation.json) содержит исходную ревизию, обе базы, пары и хеши исходников. Воспроизведение: `node analysis/verify-phase-slots.cjs` и `node analysis/verify-global-temporaries.cjs`.

В игре ещё проверить:

1. Обычный и быстрый старт: цвета/помехи/иконки меню, затем первая миссия без старых текстов; отдельно особые режимы с dummy и обычные карты.
2. Позднее подключение во время меню и после начала боя: не должно быть повторного создания меню или записи голосов в уже переданные слоты.
3. Первый и повторный Biomorphing: до задания текст не содержит иконок, цвет не получает угол 40; таблицы цветов/имён и очередь ресурсов работают; очистка удаляет все эффекты и подписи. Отдельно быстрый старт с продолжающейся инициализацией сцены: поздняя запись угла должна быть пропущена.
4. Mixed с Rescue/Satellite, переходы Biomorphing ↔ Satellite, победа и поражение во время лазера. Проверить независимость финальных взрывов и спутникового счётчика, фазы вылета 2/10/2/50.

Если понадобятся ещё слоты, следующий независимый вариант — литерал Kevlar за +5 элементов. Дополнительное распределение objective-состояния требует защиты переходов и новой оценки стоимости; угол меню уже переиспользуется цветом Biomorphing.

`node analysis/audit-global-variables.cjs --probes --quiet` обновляет машинный индекс, ссылки и оставшиеся компиляционные пробы. Скрипт работает с подключёнными исходниками и не записывает `src/`. Идентификаторные алиасы собираются в один физический слот; их объявления — метаданные, а чтения/записи учитываются по строкам обращения к роли. Описания назначения, границ времени жизни и рисков в этом документе проверяются отдельно. Классификация записи/чтения в JSON синтаксическая; частота исполнения не выводится из количества упоминаний.
