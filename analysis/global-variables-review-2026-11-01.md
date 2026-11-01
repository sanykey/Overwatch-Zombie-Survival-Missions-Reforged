# Аудит глобальных переменных — актуально на 2026-11-02

Проверены текущие исходники `src/main.opy` и все подключённые модули, включая `compressed numbers.opy` и `debug.opy`. Текущая база: **110 глобальных переменных, 108 переменных игрока и 27 213 элементов**. Выдаваемых предупреждений компилятора нет при сохранённых подавлениях проекта. Счётчик objectiveCount1 уже объединяет генерацию миссий, очистку Biomorphing и стрельбу Satellite; цикл очистки и его ожидания сохранены.

Все таблицы ниже содержат только существующие глобальные переменные с актуальными именами. Уже выполненные предложения исключены из плана. Основной оставшийся вариант — **девять передач слотов между фазами: сокращение со 110 до 101 глобальной переменной при тех же 27 213 элементах**. Это результат компиляционных проб в памяти; поведение переходов и нагрузка в игре не измерялись.

Явных кандидатов на удаление без замены не обнаружено: у всех 110 переменных есть чтения или обращения в действиях помимо объявления/записи. Это не доказательство достижимости каждой ветки, но оснований удалять очередной слот как бесполезный сейчас нет.

## Область и обозначения

Каждая переменная указана ровно один раз. Порядок групп соответствует текущему `variables.opy`; данные генератора чисел и диагностики перечислены отдельно. **Ссылка в имени ведёт ко всем файлам, правилам/макросам и строкам обращений** в [индексе ссылок](global-variable-references-2026-11-01.md). [JSON использования](global-variable-usage-2026-11-01.json) содержит полные строки и хеши текущих исходников. Имена этих файлов сохранены для существующих ссылок; дата их содержимого обновлена.

В таблицах перечислены основные потребители; полный список находится по ссылке в имени. Обозначения: `S` — `subroutines.opy`, `GS` — `global_startup.opy`, `GM` — `global_start_menu.opy`, `PM` — `player_start_menu.opy`, `GG` — `global_game_in_progress.opy`, `P` — `players_game_in_progress.opy`, `B` — `bots_game_in_progress.opy`, `Z` — `zombie_types.opy`, `SD` — `supply_drops.opy`, `PU` — `power_ups.opy`. Название задания означает соответствующий файл в `objective_types/`.

«Меню» заканчивается выключением `isPregameSetup`. **Генерация миссий идёт после меню, до `isGameplayActive = true`**. «Финал» включает поражение на любом задании. Префикс задания обозначает назначение состояния, а не гарантию прекращения всех его обработчиков сразу при переключении типа.

У булевых переменных префикс `is`, у постоянных массивов суффикс `List`. Для согласованных смешанных слотов сохранены нейтральные имена: `tmp0..2`, `objectiveCaptureValue`, `objectiveChase1`, `chase1` и `attackSpawnRooms`. Суффикс List у них скрывал бы часть допустимых типов. Глобальный `isVoting` и `player.isVoting` — отдельные значения; индекс обращений исключает одноимённые поля игрока.

## Полный список действующих переменных

### 1. Общие временные слоты — 3

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`tmp0`](global-variable-references-2026-11-01.md#tmp0) | Смешанный | Все фазы; S, GS, GM, B, Z, SD, PU, enhancements и задания | Основной синхронный scratch: индекс, позиция, цель, промежуточное число. | Оставить общим. Значение не должно переживать ожидание/асинхронный вызов или попадать в переоценку без захвата. |
| [`tmp1`](global-variable-references-2026-11-01.md#tmp1) | Смешанный | Все фазы; GS, GM, Biomorphing, Satellite, SD, PU, enhancements | Второе одновременно нужное временное значение: сумма, список, индекс, цель. | Оставить: нельзя объединить с `tmp0`, когда оба значения нужны одновременно. |
| [`tmp2`](global-variable-references-2026-11-01.md#tmp2) | Смешанный | Меню/бой; GS, SD, enhancements | Третий одновременный scratch: выбор героя, палитра/обход предметов, игрок на трамплине. | Оставить: три одновременно живых значения действительно встречаются. |

### 2. Константы цветов и позиций — 6

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`offsetUpThreeQuartersConst`](global-variable-references-2026-11-01.md#offsetupthreequartersconst) | Вектор | Меню и бой; GM, GG, Biomorphing, B | `vect(0, 0.75, 0)`, смещение значков/текстов. | Встраивание литерала освобождает слот, но добавляет 7 элементов. Второй приоритет. |
| [`offsetUpHalfConst`](global-variable-references-2026-11-01.md#offsetuphalfconst) | Вектор | Меню и бой; S, PM, GG, Z, SD | `vect(0, 0.5, 0)`, вертикальное смещение. | Встраивание: −1 слот, +7 элементов. |
| [`losOffsetConst`](global-variable-references-2026-11-01.md#losoffsetconst) | Вектор | Бой; S, B, Z, SD | `vect(0, 1.2, 0)`, смещение для проверок видимости. | Встраивание: −1 слот, +25 элементов; многократные обращения, разумно сохранить кеш. |
| [`colorChargeBatteryConst`](global-variable-references-2026-11-01.md#colorchargebatteryconst) | Цвет | Меню и бой; GM, enhancements | Постоянный RGB-цвет батареи. | Встраивание: −1 слот, +12 элементов. |
| [`dummyHoldingPositionConst`](global-variable-references-2026-11-01.md#dummyholdingpositionconst) | Вектор | Генерация зомби, Bosses, Zombie Egg; GS | `vect(500, 500, 500)`, внеигровая позиция ботов. | Встраивание: −1 слот, +23 элемента. |
| [`colorKevlarConst`](global-variable-references-2026-11-01.md#colorkevlarconst) | Цвет | Меню и бой; GM, enhancements | Постоянный RGB-цвет Kevlar. | Самая дешёвая дополнительная замена среди цветов/векторов: −1 слот, +5 элементов. |

### 3. Состояние и настройки матча — 12

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`isPregameSetup`](global-variable-references-2026-11-01.md#ispregamesetup) | Булево | Весь жизненный цикл; GS, GM, PM, S, P, B, debug | Идёт выбор героев/голосование; START GAME выключает флаг до генерации миссий и активации боя. | Сохранить отдельным флагом фазы. Он не совпадает с isGameplayActive и не описывает тип режима карты. |
| [`isSpecialGameMode`](global-variable-references-2026-11-01.md#isspecialgamemode) | Булево | Инициализация → бой; GS, GM, PM, GG, P | Постоянный признак особой обработки TDM/CTF/PUSH/CONTROL, независимый от предматчевой фазы и objective type. | Сохранить кеш определения базового режима. Значение нужно и в меню, и в бою. |
| [`isGameplayActive`](global-variable-references-2026-11-01.md#isgameplayactive) | Булево | Весь жизненный цикл; большинство модулей | Активная игровая часть, начинается после генерации и выключается при исходе матча. | Сохранить; отличается от `isGameInProgress()` и завершения меню. |
| [`isOvertimeActive`](global-variable-references-2026-11-01.md#isovertimeactive) | Булево | Конец таймера; GG | Однократность включения овертайма/телепорта зомби на обычных картах. | Полезный флаг, хотя всего две строки обращений. Удаление допускает повторные срабатывания при изменениях доступности зомби. |
| [`isVoting`](global-variable-references-2026-11-01.md#isvoting) | Булево | Предматчевое голосование; S, GS, GM, PM | Глобальный флаг голосования; отдельное поле игрока isVoting показывает участие конкретного игрока. | Резерв после меню, но сначала исключить поздние вызовы setPrematchTimer. Общий флаг и одноимённые поля игроков — разные данные. |
| [`difficultySetting`](global-variable-references-2026-11-01.md#difficultysetting) | Число | Меню, затем весь бой; S, PM, Showdown, P, B | Масштаб сложности по числу игроков; используется характеристиками и боевыми правилами. | Сохранить кеш; не путать с результатом голосования `challengeSetting`. |
| [`challengeSetting`](global-variable-references-2026-11-01.md#challengesetting) | Число | Меню → бой; GM, S, GG, P | Выбранный Challenge, влияет на урон/абилити/характеристики/возрождение. | Сохранить результат голосования. |
| [`zombieSetting`](global-variable-references-2026-11-01.md#zombiesetting) | Число | Меню → бой; GM, S, GG, Bosses | Выбранный режим состава/вероятностей зомби, также Shuffle и выбор боссов. | Не только меню: сохранить результат. |
| [`objectiveTypeSetting`](global-variable-references-2026-11-01.md#objectivetypesetting) | Число | Меню, генерация и HUD Bosses; GM, S, PM | Выбранный режим заданий либо Mixed; это не текущий тип. | До генерации необходим. Для освобождения после неё сначала убрать/обосновать отдельное чтение в HUD Bosses. |
| [`matchEndTime`](global-variable-references-2026-11-01.md#matchendtime) | Число | Инициализация → бой; GS, GG, P, B | Поправка порога времени: 0 либо 0.1 в зависимости от базового режима. | Можно вычислять выражением режима, но много потребителей; это дополнительный, менее выгодный кандидат. |
| [`uniqueSkinCap`](global-variable-references-2026-11-01.md#uniqueskincap) | Число | Весь бой; GS, Bosses, Egg | Настраиваемый лимит разных героев/скинов для создания зомби и боссов. | Сохранить настройку; замена на число потеряет пользовательскую конфигурацию. |
| [`numberOfBots`](global-variable-references-2026-11-01.md#numberofbots) | Число | Весь бой; GS, B | Настраиваемое число зомби и ограничение очереди появления. | Неизменяемая настройка, но не фиксированная константа 6; прямое встраивание Setting — отдельный компромисс. |

### 4. Карта и кеши появления — 10

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

### 5. Предматчевое меню и голосование — 12

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`startPos`](global-variable-references-2026-11-01.md#startpos) | Вектор | Меню и выход из него; GM, PM | Центр сцены выбора героя, ориентир камеры и построения позиций игроков. | Резерв для объединения после остановки камер и завершения старых правил меню. Немедленная перезапись при смене флага опасна. |
| [`startCamPos`](global-variable-references-2026-11-01.md#startcampos) | Вектор | Меню и выход из него; GM, PM | Позиция камеры, построение сцены и мировых надписей. | Аналогично `startPos`: дождаться прекращения зависимых действий, затем можно переиспользовать. |
| [`startMenuSpacingAngle`](global-variable-references-2026-11-01.md#startmenuspacingangle) | Число | Меню; GM, PM | Угол 40° и одновременно признак завершённой инициализации меню: до готовности равен 0. | Дополнительный вариант: слот extractionSpeedUp после переноса начальных 2.5 на завершённую границу меню. До готовности меню должен сохраняться 0. |
| [`startMenuZombieColorList`](global-variable-references-2026-11-01.md#startmenuzombiecolorlist) | Массив | Только меню; GM | Палитра динамической строки Zombie Mode. | После удаления HUD передать слот `objectiveEntitiesCount`. |
| [`startMenuObjectiveColorList`](global-variable-references-2026-11-01.md#startmenuobjectivecolorlist) | Массив | Только меню; GM | Палитра строки Objective Type по сырым ID. | После удаления HUD передать слот `objectiveCount1`. |
| [`startMenuEnhancementColorList`](global-variable-references-2026-11-01.md#startmenuenhancementcolorlist) | Массив | Только меню; GM | Палитра строки Enhancement. | После удаления HUD передать слот `testPos2`. |
| [`challengeVoteList`](global-variable-references-2026-11-01.md#challengevotelist) | Массив | Меню и подсчёт голосов; GS, GM, PM | Доступность вариантов Challenge, затем их количества голосов. | После меню передать слот `biomorphingResourceNameList`, инициализируемый при входе в Biomorphing. |
| [`zombieVoteList`](global-variable-references-2026-11-01.md#zombievotelist) | Массив | Меню и подсчёт голосов; GS, GM, PM | Доступность режимов зомби, затем количества голосов. | После меню передать слот `biomorphingQueuedTypeList`, который заново заполняется в начале биоцели. |
| [`objectiveTypeVoteList`](global-variable-references-2026-11-01.md#objectivetypevotelist) | Массив | Меню и подсчёт голосов; GS, GM, PM | Доступность типов заданий и количества голосов. | После меню передать слот `biomorphingResourceColorList`, заново задаваемый перед созданием Biomorphing HUD. |
| [`enhancementOptionList`](global-variable-references-2026-11-01.md#enhancementoptionlist) | Массив | Только меню; GS, PM | Значки улучшений и таблица доступности при переключении выбора. | Можно объединить с `biomorphingGoalText`, сбросив получателя после удаления меню; проба даёт −1 слот, +1 элемент. |
| [`pregameGlitchText`](global-variable-references-2026-11-01.md#pregameglitchtext) | Строка | Только меню; GM | Случайная «искажённая» надпись для Insanity/Pandora. | Передать слот `extractionFlightDestination`: направление эвакуации записывается перед первым использованием. |
| [`isPregameGlitchActive`](global-variable-references-2026-11-01.md#ispregameglitchactive) | Булево | Только меню; GM | Флаг мигания текста и цветов Insanity/Pandora. | Передать слот `extractionFlightSpeed`: финальная скорость присваивается до запуска эвакуации игроков. |

### 6. Общее состояние заданий — 21

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`objectivePositionList`](global-variable-references-2026-11-01.md#objectivepositionlist) | Массив | Генерация → весь бой/финал; S, GM, задания, P, B, Z, SD | Очередь позиций миссий; первый элемент — текущая, последний — эвакуация. | Сохранить. Нельзя заменить одной текущей позицией без потери очереди. |
| [`objectiveTypeList`](global-variable-references-2026-11-01.md#objectivetypelist) | Массив | Генерация → бой; S, GM, макрос CURRENT_OBJECTIVE_TYPE | Очередь типов; удаление первого элемента переключает задание. | Сохранить; `CURRENT_OBJECTIVE_TYPE` уже не занимает отдельный слот. |
| [`objectiveSpacingList`](global-variable-references-2026-11-01.md#objectivespacinglist) | Массив | Конец построения сетки → генерация заданий; GS, GM | Две вычисленные дистанции между целями по размеру сетки. | Освобождается после генерации, а не при исчезновении меню. Возможен поздний reuse; учитывать отдельную корутину generateMapGrid. |
| [`mixedObjectiveTypeList`](global-variable-references-2026-11-01.md#mixedobjectivetypelist) | Массив | Меню → завершение генерации; GS, GM | Разрешённые типы Mixed и исключение близких повторов при построении очереди. | После генерации передать слот `evacCount`, не отдавать его уже в START GAME. |
| [`objectiveValue`](global-variable-references-2026-11-01.md#objectivevalue) | Число | Обновление HUD/значков задания; S, P | Снимок типа, опубликованный при обновлении глобальных сущностей; сравнивается с player `objectiveValue`. | Сохранить. Замена на `CURRENT_OBJECTIVE_TYPE` меняет момент обновления относительно ожиданий и удаления HUD. |
| [`objectiveCaptureValue`](global-variable-references-2026-11-01.md#objectivecapturevalue) | Смешанный | Showdown, Biomorphing, Kill Zone, Satellite; S, B | Число для Showdown/Biomorphing/Kill Zone или массив трёх процентов терминалов Satellite. Это намеренно смешанный слот. | Уже переиспользуется между типами. Сохранить модель, обеспечить корректную инициализацию типа значения. |
| [`objectiveRad`](global-variable-references-2026-11-01.md#objectiverad) | Число | Практически весь бой; S, задания, B, Z | Радиус текущего задания: 0/3/3.5/10/20/30 и изменяемый радиус Showdown. | Уже общий. Это не константа; также является целью `chase`. |
| [`objectiveDescription`](global-variable-references-2026-11-01.md#objectivedescription) | Строка | Весь бой; S, GS, GG | Текст текущей задачи в общей верхней строке. | Сохранить; подстановка выражения выбора типа утяжелит постоянную переоценку. |
| [`objectiveColor`](global-variable-references-2026-11-01.md#objectivecolor) | Цвет | Showdown, Biomorphing, Satellite; S и задания | Цвет задания, включая мигание при потере прогресса. | Уже общий; не является неизменяемой палитрой. |
| [`isObjectiveComplete`](global-variable-references-2026-11-01.md#isobjectivecomplete) | Булево | Весь бой; S, GG, задания, P | Запрос завершения/смены задания, синхронизация правил и восстановления игроков. | Сохранить отдельным общим флагом. |
| [`objectivePlayerList`](global-variable-references-2026-11-01.md#objectiveplayerlist) | Массив | Весь бой; S, GG, задания, P, B | Участники текущей точки/ремонта/сдачи ресурсов/эвакуации. | Уже общий; не объединять с глобальным списком целей зомби. |
| [`objectiveEntityIdList`](global-variable-references-2026-11-01.md#objectiveentityidlist) | Массив | Весь бой и смена задания; S, Satellite | ID глобальных эффектов, HUD, значков и лазерных лучей для последующей очистки. | Сохранить. Список должен переживать создание и удаление задания. |
| [`objectiveEntitiesCount`](global-variable-references-2026-11-01.md#objectiveentitiescount) | Число | Смена задания; S | Индекс удаления старых эффектов и текстов; цикл содержит `wait()`. | Сохранить длительное состояние, принять слот палитры меню. На `tmp` переводить нельзя. |
| [`objectiveResourcePositionList`](global-variable-references-2026-11-01.md#objectiveresourcepositionlist) | Массив | Biomorphing и Satellite; S, оба задания | Позиции биоресурсов либо терминалов. | Уже общий для двух режимов. |
| [`testPos`](global-variable-references-2026-11-01.md#testpos) | Вектор | Генерация заданий, затем Survivor Rescue; GM, Rescue | Кандидат позиции, сохраняемый через ожидание. | Уже совмещены две фазы. Дополнительное объединение с состоянием других типов возможно после защиты переходов. |
| [`testPos2`](global-variable-references-2026-11-01.md#testpos2) | Число | Survivor Rescue и Satellite; S, Rescue, Satellite | Минимальная дальность спавна NPC либо дистанция между терминалами; постепенно уменьшается. | Уже общий для двух типов; может принять палитру меню. Не обычный scratch. |
| [`objectiveCount1`](global-variable-references-2026-11-01.md#objectivecount1) | Число | Генерация, Biomorphing и Satellite; GM и задания | Общий счётчик попыток размещения миссий, индекса очистки биоресурсов и оставшихся шагов лазера. | Уже совмещён для трёх участков. Может принять палитру меню; не совмещать с финальными взрывами при продолжающемся лазере. |
| [`objectiveChase1`](global-variable-references-2026-11-01.md#objectivechase1) | Смешанный | Survivor Rescue, Kill Zone, Satellite; S, задания, B | Сохранённый радиус Rescue, движущийся центр Kill Zone, позиция спутникового луча. | Уже полноценный общий слот состояния разных типов, аналог `enhancementValue`. |
| [`goalPost`](global-variable-references-2026-11-01.md#goalpost) | Число | Showdown и Biomorphing; S и оба задания | Следующий порог прогресса: 25/50/75/100. | Уже общий для двух типов. |
| [`queuedGoalList`](global-variable-references-2026-11-01.md#queuedgoallist) | Массив | Showdown и Biomorphing; S, оба задания, B | Зомби на точке либо очередь требуемых биоматериалов. | Уже общий, но B читает его вне строгой проверки типа, включая переоцениваемый значок. Не расширять объединение простым переименованием. |
| [`survivorToRescue`](global-variable-references-2026-11-01.md#survivortorescue) | Игрок | Survivor Rescue и Satellite; S, Rescue, Satellite, B | Спасаемый NPC либо текущая цель спутникового луча. | Уже совмещён. При расширении объединения учитывать фоновые правила и обращения после ожиданий. |

### 7. Состояние Biomorphing — 11

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`biomorphingQueuedTypeList`](global-variable-references-2026-11-01.md#biomorphingqueuedtypelist) | Массив | Biomorphing | Перемешанная очередь типов ресурсов 0/1/2 для назначения зомби. | Принять слот `zombieVoteList`; начало биоцели полностью перезаписывает очередь. |
| [`biomorphingGoalText`](global-variable-references-2026-11-01.md#biomorphinggoaltext) | Строка | Biomorphing; S, задание | Текст требуемого материала или сдачи крови, с динамическим HUD. | Возможен слот `enhancementOptionList` со сбросом после меню. |
| [`biomorphingGoalColor`](global-variable-references-2026-11-01.md#biomorphinggoalcolor) | Цвет | Biomorphing; S, задание | Цвет текущей биоцели и её оповещения. | Кандидат общего objective-слота с `objectiveChase1`, но только после защиты старых правил/HUD на переходах. |
| [`isBiomorphingGoalPending`](global-variable-references-2026-11-01.md#isbiomorphinggoalpending) | Булево | Biomorphing; S, задание | Запрос переключения биоцели/очистки ресурсов; сбрасывается также общим менеджером заданий. | Кандидат совмещения после защиты ожиданий; сброс сам по себе не останавливает выполняющееся правило. |
| [`biomorphingResourceTypeList`](global-variable-references-2026-11-01.md#biomorphingresourcetypelist) | Массив | Biomorphing | Тип каждого лежащего ресурса, параллельно массиву позиций. | Можно в будущем совмещать с состоянием других типов, например `testPos2`, после устранения поздних записей из BIO GOAL START. |
| [`biomorphingDeferredTypeList`](global-variable-references-2026-11-01.md#biomorphingdeferredtypelist) | Массив | Biomorphing и его фоновые хвосты | Очередь типов ресурсов, выпавших при смерти, для отложенного создания. | Не освобождать просто при смене типа: `BIOWASTE MANAGEMENT` проверяет только длину этой очереди. |
| [`biomorphingDeferredPositionList`](global-variable-references-2026-11-01.md#biomorphingdeferredpositionlist) | Массив | Biomorphing и его фоновые хвосты | Позиции, соответствующие `biomorphingDeferredTypeList`. | Живёт одновременно с очередью типов; объединение в массив записей добавляет индексирование. Учитывать фоновый обработчик. |
| [`biomorphingResourceTextIdList`](global-variable-references-2026-11-01.md#biomorphingresourcetextidlist) | Массив | Biomorphing | ID мировых надписей лежащих ресурсов. | Сохранить до удаления надписей; не накладывать поверх ID других активных сущностей. |
| [`biomorphingResourceEffectIdList`](global-variable-references-2026-11-01.md#biomorphingresourceeffectidlist) | Массив | Biomorphing | ID эффектов лежащих ресурсов. | Сохранить до удаления эффектов. Наследование непустого массива палитры меню потребовало бы отдельного сброса. |
| [`biomorphingResourceColorList`](global-variable-references-2026-11-01.md#biomorphingresourcecolorlist) | Массив | Biomorphing; S, задание, P | Цвета четырёх ресурсов, включая кровь; используется также переоцениваемыми значками игроков. | Принять слот `objectiveTypeVoteList`. Дальнейшее освобождение после Biomorphing требует учесть оставшиеся значки. |
| [`biomorphingResourceNameList`](global-variable-references-2026-11-01.md#biomorphingresourcenamelist) | Массив | Biomorphing; S, задание | Названия Head/Arm/Leg. | Принять слот `challengeVoteList`; таблица присваивается при входе в Biomorphing. |

### 8. Эвакуация и финальные эффекты — 7

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`extractionZoneRad`](global-variable-references-2026-11-01.md#extractionzonerad) | Число | Инициализация → весь бой; S, Extraction, P | Начальное значение 300, затем сжимающийся купол. Его `<= 0` также означает поражение. | Сохранить до корректного переноса инициализации. Оставить 0 до эвакуации нельзя: WIN/LOSS проверяет его и раньше. |
| [`extractionSpeedUp`](global-variable-references-2026-11-01.md#extractionspeedup) | Число | Инициализация → эвакуация; GS, S, Extraction | Скорость сжатия: начальные 2.5, затем растёт от присутствия игроков. | Не константа. Для совместного слота с углом меню перенести начальную запись на завершённую границу фаз. |
| [`extractionFlightSpeed`](global-variable-references-2026-11-01.md#extractionflightspeed) | Число | Успешный финал; Extraction | Управляет фазами подъёма и вылета игроков: 2/10/2/50. | Принять слот `isPregameGlitchActive`, инициализируется до назначения участников эвакуации. |
| [`extractionFlightDestination`](global-variable-references-2026-11-01.md#extractionflightdestination) | Вектор | Успешный финал; Extraction | Единожды выбранное случайное направление вылета. | Принять слот `pregameGlitchText`; не пересчитывать random отдельно для каждого игрока. |
| [`evacSurvivorList`](global-variable-references-2026-11-01.md#evacsurvivorlist) | Массив | Успешный финал и nukeMap | Снимок спасённых игроков, условие запуска анимации и исключение из финального убийства. | Сохранить снимок; `objectivePlayerList` — другой, изменяемый список. Возможна передача корректно очищенного слота после меню. |
| [`evacCount`](global-variable-references-2026-11-01.md#evaccount) | Число | Финал при победе или поражении; nukeMap | Счётчик 400 финальных взрывов, используется после каждого `wait()`. | Принять слот `mixedObjectiveTypeList`: генерация заданий к этому моменту закончена. |
| [`chase1`](global-variable-references-2026-11-01.md#chase1) | Смешанный | Меню и финал; GS, GM, S, Extraction | Скрытый предматчевый таймер, затем летящая точка ядерного эффекта. | Уже совмещены разные фазы. Перед финальным использованием есть `stopChasing`; аналогичный контракт нужен новым совмещениям. |

### 9. Припасы и лежащие предметы — 8

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

### 10. Игроки, повторный вход и воскрешение — 5

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`playerTargetList`](global-variable-references-2026-11-01.md#playertargetlist) | Массив | Весь бой; S, GG, задания, P, B, Z, SD, enhancements | Доступные цели зомби, включая временно добавляемого спасаемого NPC. | Сохранить: не равен всем игрокам команды или участникам точки. |
| [`userNameList`](global-variable-references-2026-11-01.md#usernamelist) | Массив | Весь бой; P | Имена/идентификаторы для связывания повторно вошедшего игрока с сохранённой статистикой. | Сохранить совместно с `playerStatsList`. |
| [`playerStatsList`](global-variable-references-2026-11-01.md#playerstatslist) | Массив | Весь бой, включая выход/повторный вход; P | Сохранённые статус смерти, таймеры и позиция по индексу пользователя. | Сохранить: данные переживают отсутствие игрока. |
| [`healthpackPositionList`](global-variable-references-2026-11-01.md#healthpackpositionlist) | Массив | Весь бой; P, GG | Обнаруженные позиции аптечек, используется указателем лечения заражения. | Полезный накапливаемый кеш; сохранить. |
| [`mustReviveTime`](global-variable-references-2026-11-01.md#mustrevivetime) | Число | Весь бой; GS, P | Допустимое время спасения: начинает с 60, уменьшается после окончательных смертей до 30. | Сохранить: не константа 60. |

### 11. Общие характеристики зомби, мутации и боссы — 11

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

### 12. Ротация героев задания Bosses — 2

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`bossesAvailableHeroList`](global-variable-references-2026-11-01.md#bossesavailableherolist) | Массив | Между всеми Bosses-заданиями; Bosses | Ротация ещё не выбранных героев босса; выбранный герой удаляется, список пополняется при исчерпании. | **Не освобождается на время другого типа задания**: сохранение очереди предотвращает ранние повторы боссов. |
| [`bossesExcludedHeroList`](global-variable-references-2026-11-01.md#bossesexcludedherolist) | Массив | Подготовлен после голосования; Bosses | Исключения из списка доступных героев большого босса. | Постоянный список, но нужен последующим Bosses; встраивание добавит литералы. |

### 13. Данные отдельных модулей — 2

| Переменная | Тип | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- | --- |
| [`numbersList`](global-variable-references-2026-11-01.md#numberslist) | Массив | Инициализация и бой; S, GM, compressed numbers | Общая сжатая таблица чисел для характеристик, вероятностей и индексов меню. | Сохранить: уже объединяет много таблиц без отдельных глобальных слотов для каждого исходного набора. |
| [`debugHud`](global-variable-references-2026-11-01.md#debughud) | Число | Все фазы; debug.opy | ID диагностического HUD для удаления/пересоздания после общей очистки текстов. | Полезен в debug-сборке. Удаление подключения debug освобождает слот, но также убирает диагностику и усиления хоста. Это изменение состава сборки. |

## Оставшиеся варианты передачи слотов между фазами

Это прямое совместное хранение в глобальном слоте: дополнительных массивов, индексирования, поиска или периодического копирования не требуется. При внедрении можно сохранить понятные символические имена каждой роли через `#!define`; два псевдонима не должны создавать два `globalvar`.

| До передачи | После передачи | Граница времени жизни и инициализация получателя |
| --- | --- | --- |
| `startMenuZombieColorList` | `objectiveEntitiesCount` | После удаления предматчевого HUD; цикл очистки сначала присваивает индекс. |
| `startMenuObjectiveColorList` | `objectiveCount1` | После удаления HUD; генерация миссий присваивает 0, Satellite позже запускает собственный for. |
| `startMenuEnhancementColorList` | `testPos2` | После удаления HUD; Rescue присваивает 115, Satellite — 50 до чтений. |
| `challengeVoteList` | `biomorphingResourceNameList` | Подсчёт и меню закончены; таблица имён задаётся при входе в Biomorphing до создания его HUD. |
| `objectiveTypeVoteList` | `biomorphingResourceColorList` | Аналогично; таблица цветов задаётся перед зависимыми визуальными сущностями. |
| `zombieVoteList` | `biomorphingQueuedTypeList` | Подсчёт закончен; начало биоцели безусловно создаёт новую очередь до выдачи ресурсов. |
| `pregameGlitchText` | `extractionFlightDestination` | Меню и его тексты завершены; направление полёта записывается перед запуском эвакуации игроков. |
| `isPregameGlitchActive` | `extractionFlightSpeed` | Правило мигания прекращает изменения через ABORT_WHEN_FALSE; скорость 2 записывается до списка эвакуируемых. |
| `mixedObjectiveTypeList` | `evacCount` | Только после завершения генерации очереди миссий; финальный for присваивает счётчик до чтения. |

**Совместная проба всех девяти пар: 101 переменная, 27 213 элементов, разница по элементам 0.** Это оставшаяся экономия от текущего состояния, а не сумма с уже внедрёнными изменениями.

Для первых трёх пар критично удаление переоцениваемых HUD перед перезаписью палитр. Окончание голосования само по себе эту границу не создаёт: меню ещё видно. Для `mixedObjectiveTypeList` граница другая — окончание генерации, а не START GAME. Получатель должен присвоить значение до любого чтения; обнуление всех доноров одним пакетом не требуется и не заменяет эту проверку.

### Два дополнительных варианта с условиями

- `startMenuSpacingAngle` → `extractionSpeedUp`: перенести исходные `extractionSpeedUp = 2.5` из VARIABLE ASSIGNMENT в START GAME после завершения меню. До готовности меню слот должен оставаться 0, затем хранить угол 40, после передачи — скорость 2.5. Обязательно исключить позднюю запись 40 из продолжающейся GLOBAL MENU INITIALIZATION. Компиляционная стоимость — 0 элементов.
- `enhancementOptionList` → `biomorphingGoalText`: после удаления меню выполнить `biomorphingGoalText = null`, сохранив прежнее начальное значение до первого биозадания. Полученный общий слот переживает ожидания. Компиляционная стоимость — +1 элемент.

Все девять основных и эти два варианта вместе дают **99 переменных, 27 214 элементов (+1)**. Проба включает перенос инициализации скорости и сброс текста, но не доказывает завершение всех старых обработчиков меню. Поэтому это следующий этап после основного набора.

## Состояние разных заданий: что уже общее

| Слот | Значения по типам задания |
| --- | --- |
| `objectiveCaptureValue` | Showdown/Biomorphing: процент; Kill Zone: счёт; Satellite: массив прогресса терминалов. |
| `objectiveChase1` | Rescue: исходный радиус; Kill Zone: центр; Satellite: позиция лазера. |
| `survivorToRescue` | Rescue: NPC; Satellite: выбранный зомби для слежения. |
| `objectiveResourcePositionList` | Biomorphing: ресурсы; Satellite: терминалы. |
| `queuedGoalList` | Showdown: зомби на точке; Biomorphing: очередь биоцелей. |
| `goalPost` | Showdown и Biomorphing: следующий порог прогресса. |
| `objectiveCount1` | Генерация миссий: попытки размещения; Biomorphing: индекс очистки; Satellite: оставшиеся шаги стрельбы. |
| `testPos2` | Rescue: минимальная дальность спавна; Satellite: расстояние между терминалами. |
| `bossStateList` | Bosses: большой босс; Zombie Egg: яйцо; общий второй элемент — высота головы. |

Значительная часть ожидаемой экономии между типами уже реализована этими слотами. Большинство оставшегося специализированного состояния относится к Biomorphing и нужно одновременно внутри одного задания. Его поля нельзя объединить друг с другом только по принадлежности одной механике.

Дополнительные пары для дальнейшего анализа: `biomorphingGoalColor` ↔ `objectiveChase1`, `biomorphingResourceTypeList` ↔ `testPos2`, `biomorphingGoalText` ↔ `survivorToRescue`. У них требуется защита передачи от поздних записей, старых визуальных сущностей и активных chase. Их экономия не включена в основной набор; она также не складывается автоматически с уже предложенными владельцами этих же слотов.

### Уже объединённый счётчик objectiveCount1

В текущих исходниках один слот обслуживает три участка:

- Генерация миссий использует его до `isGameplayActive = true` и завершает работу до запуска биоцелей.
- BIOMORPHING GOAL START использует его только внутри начального цикла удаления эффектов и надписей. Последующий `waitUntil(objectiveCaptureValue == 0, 3)` и оставшаяся часть правила счётчик не читают.
- Satellite использует его в цикле стрельбы и выставляет `isObjectiveComplete = true` после завершения fireSatelliteMacro. В обратном направлении стрельбе предшествуют ремонт терминалов и подготовка выстрела.

Каждый участок задаёт своё начальное значение перед чтениями. Полный цикл очистки, обычный `wait()` и расположенные ниже сбросы массивов сохранены. Дополнительные действия и прерывания не добавлены. Текущая база уже учитывает освобождённый слот: **110 глобальных переменных, 27 213 элементов**.

`Wait.ABORT_WHEN_FALSE` в очистку не добавлен: при потере условия он прервал бы всё правило и мог оставить часть эффектов/надписей и сбросов необработанными. Сравнение скомпилированного кода подтвердило, что изменение ограничено общим счётчиком; игровой прогон переходов Biomorphing ↔ Satellite ещё не проводился.

### Что мешает расширять объединение простым переименованием

1. `BIOWASTE MANAGEMENT` проверяет только длину `biomorphingDeferredTypeList` и продолжает создание ресурсов через `wait(0.15)`. Тип задания его напрямую не останавливает.
2. `BIOMORPHING GOAL START` содержит ожидания и может позже записывать `biomorphingGoalText`, `biomorphingGoalColor`, очереди и `isBiomorphingGoalPending`. Это важно для объединения этих полей, даже когда счётчик очистки уже не нужен.
3. `SURVIVOR FOLLOW TARGET` после ожидания восстанавливает `objectiveRad` из `objectiveChase1` и очищает связанные с `survivorToRescue` поля. Отдельная ветка восстановления ждёт до 20 секунд.
4. При поражении во время Satellite лазерная последовательность может ещё выполнять 40 шагов. Поэтому `objectiveCount1` ↔ `evacCount` опаснее `mixedObjectiveTypeList` ↔ `evacCount`.
5. Старые глобальные визуальные сущности удаляются по одной с ожиданиями. До удаления переоценка может читать прежние слоты. Значки биоресурсов у игроков удаляются отдельным обработчиком.
6. `bossesAvailableHeroList` сохраняет ротацию между Bosses-миссиями даже при другом текущем типе. Power-up награды также остаются на земле после окончания Biomorphing, поэтому массивы `supplyPowerUp*List` продолжают использоваться.

Для расширенного распределения сначала определить порядок выхода: завершить либо корректно отменить старую работу, удалить зависимые визуальные сущности и остановить нужные chase, затем передать слот новому владельцу. Одна проверка текущего типа не различает два последовательных задания одного типа. Если старый обработчик может пережить такой переход, потребуется различать экземпляры заданий или гарантировать его завершение. Стоимость дополнительного механизма в приведённые пробы не включена.

## Текущие измерения

Все варианты заново скомпилированы относительно **110 переменных / 27 213 элементов**. [Полные результаты](global-variable-probes-2026-11-01.json) содержат 16 вариантов, изменённые файлы и предупреждения. Компиляция подтверждает размер и разрешение имён, но не безопасность асинхронного времени жизни и не нагрузку сервера.

| Вариант | Глобальных | Элементов | Разница элементов |
| --- | ---: | ---: | ---: |
| Текущий код | 110 | 27 213 | 0 |
| Три палитры меню → длительные слоты | 107 | 27 213 | 0 |
| Пять остальных передач меню | 105 | 27 213 | 0 |
| Mixed pool → финальный счётчик | 109 | 27 213 | 0 |
| Все девять передач фаз | 101 | 27 213 | 0 |
| Девять передач + угол/скорость + options/текст | 99 | 27 214 | +1 |
| Девять передач + литерал цвета Kevlar | 100 | 27 218 | +5 |
| Отдельно: шесть цветов/векторов литералами | 104 | 27 292 | +79 |
| Девять передач + шесть цветов/векторов литералами | 95 | 27 292 | +79 |

Шесть векторных/RGB-констант можно встроить независимо от фаз. Самый дешёвый отдельный вариант — `colorKevlarConst`: −1 слот и +5 элементов. Остальные цены указаны в их строках полного списка. Полный набор добавляет 79 элементов, около 0.29% текущей сборки, и размножает выражения в местах использования, включая переоцениваемые аргументы. Измерения нагрузки в игре нет; основной вариант на 101 слот обходится без этого компромисса.

Упаковка часто читаемых кешей/таблиц характеристик в один большой массив также сократит слоты, но добавит индексирование. При текущей цели сначала выгоднее рассмотреть прямые передачи между фазами, сохранив кеши позиций и таблицы зомби.

## Приоритет и проверка при внедрении

1. Проверить три передачи палитр после удаления HUD, затем остальные передачи меню и отдельно завершение генерации для Mixed pool. Сохранять присваивание получателя до первого чтения и не менять скрытые флаги готовности.
2. Прогнать обычный и быстрый старт, позднее подключение, первый и повторный Biomorphing, Mixed с Rescue/Satellite, победу и поражение во время лазера.
3. Проверить переходы Biomorphing ↔ Satellite после объединения счётчика, включая поражение во время задания. Подтвердить полную очистку и отсутствие пересечения циклов.
4. Если нужны ещё слоты, сравнить +5 элементов за Kevlar, условный вариант на 99 слотов и дальнейшее распределение objective-состояния с защитой переходов.

`node analysis/audit-global-variables.cjs --probes --quiet` обновляет машинный индекс, ссылки и текущие компиляционные пробы. Скрипт работает с подключёнными исходниками и не записывает `src/`. Описания назначения, границ времени жизни и рисков в этом документе проверяются отдельно. Классификация записи/чтения в JSON синтаксическая; частота исполнения не выводится из количества упоминаний.
