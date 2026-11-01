# Аудит всех globalvar — 2026-11-01

Проверен текущий `src/main.opy` со всеми подключёнными файлами, включая `compressed numbers.opy` и `debug.opy`. Обнаружено **115 глобальных переменных**; текущая сборка OverPy содержит **27 224 элемента**. Упоминание 118 переменных и 27 260 элементов в README относится к более раннему состоянию. Исходники игры в ходе аудита не изменялись.

Наиболее подходящий первый набор изменений: **115 → 102 переменные, 27 224 → 27 213 элементов**. Это четыре числовые константы и девять объединений непересекающихся состояний. Стоимость подтверждена компиляцией вариантов в памяти; корректность передачи состояния оценена по исходникам. Игровой прогон и измерение нагрузки не проводились, поэтому это предложение к внедрению, а не уже проверенная в игре оптимизация.

Полностью неиспользуемых глобальных переменных, аналогичных ранее удалённой `losList`, **не найдено**. У всех 115 есть обращения помимо записи/объявления. Основной резерв — время жизни данных и константы, а не удаление бесполезных объявлений.

## Как читать список

Каждая переменная ниже указана ровно один раз. Ссылка в её имени ведёт к **полному списку файлов, правил/макросов и строк обращений** в [индексе ссылок](global-variable-references-2026-11-01.md). Полные тексты строк, объявления, количество упоминаний и хеши исходников находятся в [JSON](global-variable-usage-2026-11-01.json).

В колонке «Основной код» перечислены главные потребители; полный набор, включая инициализацию и вспомогательные правила, находится по ссылке в имени. Сокращения: `S` — `subroutines.opy`, `GS` — `global_startup.opy`, `GM` — `global_start_menu.opy`, `PM` — `player_start_menu.opy`, `GG` — `global_game_in_progress.opy`, `P` — `players_game_in_progress.opy`, `B` — `bots_game_in_progress.opy`, `Z` — `zombie_types.opy`, `SD` — `supply_drops.opy`, `PU` — `power_ups.opy`. Название задания означает соответствующий файл в `objective_types/`.

«Меню» означает предматчевый интерфейс до `START GAME`. Генерация списка заданий выполняется **после выхода из меню**, до `isGameplayActive = true`; это отдельная фаза. «Финал» включает поражение на любом задании, а не только успешную эвакуацию.

## 1. Временные слоты и общие константы — 11

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`tmp0`](global-variable-references-2026-11-01.md#tmp0) | Все фазы; S, GS, GM, B, Z, SD, PU, enhancements и задания | Основной синхронный scratch: индекс, позиция, цель, промежуточное число. | Оставить общим. Значение не должно переживать ожидание/асинхронный вызов или попадать в переоценку без захвата. |
| [`tmp1`](global-variable-references-2026-11-01.md#tmp1) | Все фазы; GS, GM, Biomorphing, Satellite, SD, PU, enhancements | Второе одновременно нужное временное значение: сумма, список, индекс, цель. | Оставить: нельзя объединить с `tmp0`, когда оба значения нужны одновременно. |
| [`tmp2`](global-variable-references-2026-11-01.md#tmp2) | Меню/бой; GS, SD, enhancements | Третий одновременный scratch: выбор героя, палитра/обход предметов, игрок на трамплине. | Оставить: три одновременно живых значения действительно встречаются. |
| [`offsetUpThreeQuartersConst`](global-variable-references-2026-11-01.md#offsetupthreequartersconst) | Меню и бой; GM, GG, Biomorphing, B | `vect(0, 0.75, 0)`, смещение значков/текстов. | Встраивание литерала освобождает слот, но добавляет 7 элементов. Второй приоритет. |
| [`offsetUpHalfConst`](global-variable-references-2026-11-01.md#offsetuphalfconst) | Меню и бой; S, PM, GG, Z, SD | `vect(0, 0.5, 0)`, вертикальное смещение. | Встраивание: −1 слот, +7 элементов. |
| [`losOffsetConst`](global-variable-references-2026-11-01.md#losoffsetconst) | Бой; S, B, Z, SD | `vect(0, 1.2, 0)`, смещение для проверок видимости. | Встраивание: −1 слот, +25 элементов; многократные обращения, разумно сохранить кеш. |
| [`colorChargeBatteryConst`](global-variable-references-2026-11-01.md#colorchargebatteryconst) | Меню и бой; GM, enhancements | Постоянный RGB-цвет батареи. | Встраивание: −1 слот, +12 элементов. |
| [`dummyHoldingPositionConst`](global-variable-references-2026-11-01.md#dummyholdingpositionconst) | Генерация зомби, Bosses, Zombie Egg; GS | `vect(500, 500, 500)`, внеигровая позиция ботов. | Встраивание: −1 слот, +23 элемента. |
| [`colorKevlarConst`](global-variable-references-2026-11-01.md#colorkevlarconst) | Меню и бой; GM, enhancements | Постоянный RGB-цвет Kevlar. | Самая дешёвая дополнительная замена среди цветов/векторов: −1 слот, +5 элементов. |
| [`reviveRadius`](global-variable-references-2026-11-01.md#reviveradius) | Весь бой; P, SD | Неизменяемый радиус 5 для воскрешения и его визуализации. | Заменить числовым `#!define`: −1 слот, −5 элементов. |
| [`numbersList`](global-variable-references-2026-11-01.md#numberslist) | Инициализация и бой; S, GM, compressed numbers | Общая сжатая таблица чисел для характеристик, вероятностей и индексов меню. | Сохранить: уже объединяет много таблиц без отдельных глобальных слотов для каждого исходного набора. |

## 2. Данные меню — 15

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`startMenuZombieColors`](global-variable-references-2026-11-01.md#startmenuzombiecolors) | Только меню; GM | Палитра динамической строки Zombie Mode. | После удаления HUD передать слот `objectiveEntitiesCount`. |
| [`startMenuObjectiveColors`](global-variable-references-2026-11-01.md#startmenuobjectivecolors) | Только меню; GM | Палитра строки Objective Type по сырым ID. | После удаления HUD передать слот `objectiveCount1`. |
| [`startMenuEnhancementColors`](global-variable-references-2026-11-01.md#startmenuenhancementcolors) | Только меню; GM | Палитра строки Enhancement. | После удаления HUD передать слот `testPos2`. |
| [`startPos`](global-variable-references-2026-11-01.md#startpos) | Меню и выход из него; GM, PM | Центр сцены выбора героя, ориентир камеры и построения позиций игроков. | Резерв для объединения после остановки камер и завершения старых правил меню. Немедленная перезапись при смене флага опасна. |
| [`startCamPos`](global-variable-references-2026-11-01.md#startcampos) | Меню и выход из него; GM, PM | Позиция камеры, построение сцены и мировых надписей. | Аналогично `startPos`: дождаться прекращения зависимых действий, затем можно переиспользовать. |
| [`startMenuSpacingAngle`](global-variable-references-2026-11-01.md#startmenuspacingangle) | Меню; GM, PM | Угол 40° и одновременно признак завершённой инициализации меню: до готовности равен 0. | Возможна передача слота `extractionSpeedUp`, если перенести его начальную запись 2.5 на границу фаз и исключить позднюю запись из меню. Просто заменить на 40 нельзя. |
| [`startCamDistance`](global-variable-references-2026-11-01.md#startcamdistance) | Меню; GM, PM | Постоянная дистанция камеры 6.5. | Числовой `#!define`: −1 слот, −2 элемента. |
| [`specialEffectsStrings`](global-variable-references-2026-11-01.md#specialeffectsstrings) | Только меню; GM | Случайная «искажённая» надпись для Insanity/Pandora. | Передать слот `evacDestination`: направление эвакуации записывается перед первым использованием. |
| [`specialEffectsTiming`](global-variable-references-2026-11-01.md#specialeffectstiming) | Только меню; GM | Флаг мигания текста и цветов Insanity/Pandora. | Передать слот `evacRate`: финальная скорость присваивается до запуска эвакуации игроков. |
| [`challengeVotes`](global-variable-references-2026-11-01.md#challengevotes) | Меню и подсчёт голосов; GS, GM, PM | Доступность вариантов Challenge, затем их количества голосов. | После меню передать слот `biowasteTextLookUp`, инициализируемый при входе в Biomorphing. |
| [`zombieVotes`](global-variable-references-2026-11-01.md#zombievotes) | Меню и подсчёт голосов; GS, GM, PM | Доступность режимов зомби, затем количества голосов. | После меню передать слот `queuedBioType`, который заново заполняется в начале биоцели. |
| [`objectiveTypeVotes`](global-variable-references-2026-11-01.md#objectivetypevotes) | Меню и подсчёт голосов; GS, GM, PM | Доступность типов заданий и количества голосов. | После меню передать слот `biowasteColorLookUp`, заново задаваемый перед созданием Biomorphing HUD. |
| [`enhancementOptions`](global-variable-references-2026-11-01.md#enhancementoptions) | Только меню; GS, PM | Значки улучшений и таблица доступности при переключении выбора. | Можно объединить с `goalText`, сбросив получателя после удаления меню; проба даёт −1 слот, +1 элемент. |
| [`voting`](global-variable-references-2026-11-01.md#voting) | Меню и вызовы setPrematchTimer; S, GS, GM, PM | Флаг голосования, выбор поведения таймера, подсказок и управления. | Резерв после меню. Сначала исключить оставшиеся вызовы `setPrematchTimer`, читающие флаг без собственной проверки фазы. |
| [`startTime`](global-variable-references-2026-11-01.md#starttime) | Конец голосования → START GAME; GM, GS | Единственная запись 300, единственное чтение при установке времени матча. | Числовой `#!define`: −1 слот, −2 элемента. |

## 3. Общая механика заданий и уже совмещённое состояние — 20

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`objectiveEntitiesCount`](global-variable-references-2026-11-01.md#objectiveentitiescount) | Смена задания; S | Индекс удаления старых эффектов и текстов; цикл содержит `wait()`. | Сохранить длительное состояние, принять слот палитры меню. На `tmp` переводить нельзя. |
| [`objectivePositions`](global-variable-references-2026-11-01.md#objectivepositions) | Генерация → весь бой/финал; S, GM, задания, P, B, Z, SD | Очередь позиций миссий; первый элемент — текущая, последний — эвакуация. | Сохранить. Нельзя заменить одной текущей позицией без потери очереди. |
| [`objectiveTypes`](global-variable-references-2026-11-01.md#objectivetypes) | Генерация → бой; S, GM, макрос CURRENT_OBJECTIVE_TYPE | Очередь типов; удаление первого элемента переключает задание. | Сохранить; `CURRENT_OBJECTIVE_TYPE` уже не занимает отдельный слот. |
| [`objectiveCaptureValue`](global-variable-references-2026-11-01.md#objectivecapturevalue) | Showdown, Biomorphing, Kill Zone, Satellite; S, B | Общий прогресс: процент, счёт убийств либо массив трёх процентов терминалов. | Уже переиспользуется между типами. Сохранить модель, обеспечить корректную инициализацию типа значения. |
| [`objectiveRad`](global-variable-references-2026-11-01.md#objectiverad) | Практически весь бой; S, задания, B, Z | Радиус текущего задания: 0/3/3.5/10/20/30 и изменяемый радиус Showdown. | Уже общий. Это не константа; также является целью `chase`. |
| [`playersOnObjective`](global-variable-references-2026-11-01.md#playersonobjective) | Весь бой; S, GG, задания, P, B | Участники текущей точки/ремонта/сдачи ресурсов/эвакуации. | Уже общий; не объединять с глобальным списком целей зомби. |
| [`testPos`](global-variable-references-2026-11-01.md#testpos) | Генерация заданий, затем Survivor Rescue; GM, Rescue | Кандидат позиции, сохраняемый через ожидание. | Уже совмещены две фазы. Дополнительное объединение с состоянием других типов возможно после защиты переходов. |
| [`testPos2`](global-variable-references-2026-11-01.md#testpos2) | Survivor Rescue и Satellite; S, Rescue, Satellite | Минимальная дальность спавна NPC либо дистанция между терминалами; постепенно уменьшается. | Уже общий для двух типов; может принять палитру меню. Не обычный scratch. |
| [`objectiveValue`](global-variable-references-2026-11-01.md#objectivevalue) | Обновление HUD/значков задания; S, P | Снимок типа, опубликованный при обновлении глобальных сущностей; сравнивается с player `objectiveValue`. | Сохранить. Замена на `CURRENT_OBJECTIVE_TYPE` меняет момент обновления относительно ожиданий и удаления HUD. |
| [`objectiveEntities`](global-variable-references-2026-11-01.md#objectiveentities) | Весь бой и смена задания; S, Satellite | ID глобальных эффектов, HUD, значков и лазерных лучей для последующей очистки. | Сохранить. Список должен переживать создание и удаление задания. |
| [`objectiveResourcePositions`](global-variable-references-2026-11-01.md#objectiveresourcepositions) | Biomorphing и Satellite; S, оба задания | Позиции биоресурсов либо терминалов. | Уже общий для двух режимов. |
| [`objectiveDescription`](global-variable-references-2026-11-01.md#objectivedescription) | Весь бой; S, GS, GG | Текст текущей задачи в общей верхней строке. | Сохранить; подстановка выражения выбора типа утяжелит постоянную переоценку. |
| [`objectiveComplete`](global-variable-references-2026-11-01.md#objectivecomplete) | Весь бой; S, GG, задания, P | Запрос завершения/смены задания, синхронизация правил и восстановления игроков. | Сохранить отдельным общим флагом. |
| [`objectiveColor`](global-variable-references-2026-11-01.md#objectivecolor) | Showdown, Biomorphing, Satellite; S и задания | Цвет задания, включая мигание при потере прогресса. | Уже общий; не является неизменяемой палитрой. |
| [`objectiveCount1`](global-variable-references-2026-11-01.md#objectivecount1) | Генерация, затем Satellite; GM, Satellite | Количество неудачных попыток размещения, затем 40 шагов лазера. | Уже совмещён; принять палитру меню. Не совмещать с финальным счётчиком без остановки лазера при поражении. |
| [`objectiveChase1`](global-variable-references-2026-11-01.md#objectivechase1) | Survivor Rescue, Kill Zone, Satellite; S, задания, B | Сохранённый радиус Rescue, движущийся центр Kill Zone, позиция спутникового луча. | Уже полноценный общий слот состояния разных типов, аналог `enhancementValue`. |
| [`goalPost`](global-variable-references-2026-11-01.md#goalpost) | Showdown и Biomorphing; S и оба задания | Следующий порог прогресса: 25/50/75/100. | Уже общий для двух типов. |
| [`queuedGoalType`](global-variable-references-2026-11-01.md#queuedgoaltype) | Showdown и Biomorphing; S, оба задания, B | Зомби на точке либо очередь требуемых биоматериалов. | Уже общий, но B читает его вне строгой проверки типа, включая переоцениваемый значок. Не расширять объединение простым переименованием. |
| [`eliminationsNeededPerObjective`](global-variable-references-2026-11-01.md#eliminationsneededperobjective) | Только Kill Zone; S, Kill Zone | Неизменяемая цель 50, используется HUD и проверкой завершения. | Числовой `#!define`: −1 слот, −2 элемента. |
| [`survivorToRescue`](global-variable-references-2026-11-01.md#survivortorescue) | Survivor Rescue и Satellite; S, Rescue, Satellite, B | Спасаемый NPC либо текущая цель спутникового луча. | Уже совмещён. При расширении объединения учитывать фоновые правила и обращения после ожиданий. |

## 4. Состояние Biomorphing — 12

Все эти данные нужны одной механике, но несколько полей одновременно живут в пределах одного Biomorphing. Поэтому объединять их друг с другом только на основании принадлежности одному заданию нельзя.

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`queuedBioType`](global-variable-references-2026-11-01.md#queuedbiotype) | Biomorphing | Перемешанная очередь типов ресурсов 0/1/2 для назначения зомби. | Принять слот `zombieVotes`; начало биоцели полностью перезаписывает очередь. |
| [`goalText`](global-variable-references-2026-11-01.md#goaltext) | Biomorphing; S, задание | Текст требуемого материала или сдачи крови, с динамическим HUD. | Возможен слот `enhancementOptions` со сбросом после меню. |
| [`goalColor`](global-variable-references-2026-11-01.md#goalcolor) | Biomorphing; S, задание | Цвет текущей биоцели и её оповещения. | Кандидат общего objective-слота с `objectiveChase1`, но только после защиты старых правил/HUD на переходах. |
| [`biowasteTypes`](global-variable-references-2026-11-01.md#biowastetypes) | Biomorphing | Тип каждого лежащего ресурса, параллельно массиву позиций. | Можно в будущем совмещать с состоянием других типов, например `testPos2`, после устранения поздних записей из BIO GOAL START. |
| [`deferredType`](global-variable-references-2026-11-01.md#deferredtype) | Biomorphing и его фоновые хвосты | Очередь типов ресурсов, выпавших при смерти, для отложенного создания. | Не освобождать просто при смене типа: `BIOWASTE MANAGEMENT` проверяет только длину этой очереди. |
| [`goalCheck`](global-variable-references-2026-11-01.md#goalcheck) | Biomorphing; S, задание | Запрос переключения биоцели/очистки ресурсов; сбрасывается также общим менеджером заданий. | Кандидат совмещения после защиты ожиданий; сброс сам по себе не останавливает выполняющееся правило. |
| [`deferredPositions`](global-variable-references-2026-11-01.md#deferredpositions) | Biomorphing и его фоновые хвосты | Позиции, соответствующие `deferredType`. | Живёт одновременно с очередью типов; объединение в массив записей добавляет индексирование. Учитывать фоновый обработчик. |
| [`biowasteString`](global-variable-references-2026-11-01.md#biowastestring) | Biomorphing | ID мировых надписей лежащих ресурсов. | Сохранить до удаления надписей; не накладывать поверх ID других активных сущностей. |
| [`biowasteEffects`](global-variable-references-2026-11-01.md#biowasteeffects) | Biomorphing | ID эффектов лежащих ресурсов. | Сохранить до удаления эффектов. Наследование непустого массива палитры меню потребовало бы отдельного сброса. |
| [`biowasteCount`](global-variable-references-2026-11-01.md#biowastecount) | Очистка биоцели | Индекс удаления ресурсов; цикл содержит `wait()`. | Нельзя перенести в общий `tmp`. С `objectiveEntitiesCount` способен пересекаться уже при смене/инициализации цели. |
| [`biowasteColorLookUp`](global-variable-references-2026-11-01.md#biowastecolorlookup) | Biomorphing; S, задание, P | Цвета четырёх ресурсов, включая кровь; используется также переоцениваемыми значками игроков. | Принять слот `objectiveTypeVotes`. Дальнейшее освобождение после Biomorphing требует учесть оставшиеся значки. |
| [`biowasteTextLookUp`](global-variable-references-2026-11-01.md#biowastetextlookup) | Biomorphing; S, задание | Названия Head/Arm/Leg. | Принять слот `challengeVotes`; таблица присваивается при входе в Biomorphing. |

## 5. Эвакуация и финальная анимация — 7

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`evacCount`](global-variable-references-2026-11-01.md#evaccount) | Финал при победе или поражении; nukeMap | Счётчик 400 финальных взрывов, используется после каждого `wait()`. | Принять слот `mixedObjectivesPool`: генерация заданий к этому моменту закончена. |
| [`evacRate`](global-variable-references-2026-11-01.md#evacrate) | Успешный финал; Extraction | Управляет фазами подъёма и вылета игроков: 2/10/2/50. | Принять слот `specialEffectsTiming`, инициализируется до назначения участников эвакуации. |
| [`evacSurvivorList`](global-variable-references-2026-11-01.md#evacsurvivorlist) | Успешный финал и nukeMap | Снимок спасённых игроков, условие запуска анимации и исключение из финального убийства. | Сохранить снимок; `playersOnObjective` — другой, изменяемый список. Возможна передача корректно очищенного слота после меню. |
| [`evacDestination`](global-variable-references-2026-11-01.md#evacdestination) | Успешный финал; Extraction | Единожды выбранное случайное направление вылета. | Принять слот `specialEffectsStrings`; не пересчитывать random отдельно для каждого игрока. |
| [`extractionZoneRad`](global-variable-references-2026-11-01.md#extractionzonerad) | Инициализация → весь бой; S, Extraction, P | Начальное значение 300, затем сжимающийся купол. Его `<= 0` также означает поражение. | Сохранить до корректного переноса инициализации. Оставить 0 до эвакуации нельзя: WIN/LOSS проверяет его и раньше. |
| [`extractionSpeedUp`](global-variable-references-2026-11-01.md#extractionspeedup) | Инициализация → эвакуация; GS, S, Extraction | Скорость сжатия: начальные 2.5, затем растёт от присутствия игроков. | Не константа. Для совместного слота с углом меню перенести начальную запись на завершённую границу фаз. |
| [`chase1`](global-variable-references-2026-11-01.md#chase1) | Меню и финал; GS, GM, S, Extraction | Скрытый предматчевый таймер, затем летящая точка ядерного эффекта. | Уже совмещены разные фазы. Перед финальным использованием есть `stopChasing`; аналогичный контракт нужен новым совмещениям. |

## 6. Состояние матча, карты и игроков — 22

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`walkCenter`](global-variable-references-2026-11-01.md#walkcenter) | Инициализация, меню и бой; GS, GM, P | Центр карты для сетки, сцены меню и телепорта игроков на особых картах. | Сохранить: используется и при позднем входе игроков. |
| [`isGameplayActive`](global-variable-references-2026-11-01.md#isgameplayactive) | Весь жизненный цикл; большинство модулей | Активная игровая часть, начинается после генерации и выключается при исходе матча. | Сохранить; отличается от `isGameInProgress()` и завершения меню. |
| [`mustReviveTime`](global-variable-references-2026-11-01.md#mustrevivetime) | Весь бой; GS, P | Допустимое время спасения: начинает с 60, уменьшается после окончательных смертей до 30. | Сохранить: не константа 60. |
| [`overtime`](global-variable-references-2026-11-01.md#overtime) | Конец таймера; GG | Однократность включения овертайма/телепорта зомби на обычных картах. | Полезный флаг, хотя всего две строки обращений. Удаление допускает повторные срабатывания при изменениях доступности зомби. |
| [`difficultySetting`](global-variable-references-2026-11-01.md#difficultysetting) | Меню, затем весь бой; S, PM, Showdown, P, B | Масштаб сложности по числу игроков; используется характеристиками и боевыми правилами. | Сохранить кеш; не путать с результатом голосования `challengeSetting`. |
| [`zombieSetting`](global-variable-references-2026-11-01.md#zombiesetting) | Меню → бой; GM, S, GG, Bosses | Выбранный режим состава/вероятностей зомби, также Shuffle и выбор боссов. | Не только меню: сохранить результат. |
| [`challengeSetting`](global-variable-references-2026-11-01.md#challengesetting) | Меню → бой; GM, S, GG, P | Выбранный Challenge, влияет на урон/абилити/характеристики/возрождение. | Сохранить результат голосования. |
| [`objectiveTypeSetting`](global-variable-references-2026-11-01.md#objectivetypesetting) | Меню, генерация и HUD Bosses; GM, S, PM | Выбранный режим заданий либо Mixed; это не текущий тип. | До генерации необходим. Для освобождения после неё сначала убрать/обосновать отдельное чтение в HUD Bosses. |
| [`globalPlayerStats`](global-variable-references-2026-11-01.md#globalplayerstats) | Весь бой, включая выход/повторный вход; P | Сохранённые статус смерти, таймеры и позиция по индексу пользователя. | Сохранить: данные переживают отсутствие игрока. |
| [`healthpackPositions`](global-variable-references-2026-11-01.md#healthpackpositions) | Весь бой; P, GG | Обнаруженные позиции аптечек, используется указателем лечения заражения. | Полезный накапливаемый кеш; сохранить. |
| [`mapGrid`](global-variable-references-2026-11-01.md#mapgrid) | Инициализация → бой/финал; GS, GM, задания, P, Z, SD | Сетка точек для размещения целей, телепортов, припасов и финальных эффектов. | Сохранить. Важный многократно используемый кеш дорогого поиска точек. |
| [`attackSpawnRooms`](global-variable-references-2026-11-01.md#attackspawnrooms) | Подготовка и бой; GS, GG | Позиции комнат появления атакующих, собранные вращением спавнов. | Сохранить: нужен выбор безопасной комнаты во время матча. |
| [`activeAttackSpawnRoom`](global-variable-references-2026-11-01.md#activeattackspawnroom) | Подготовка и бой; GS, GG | Позиция действующей комнаты спавна. | Не гарантированно равна `attackSpawnRooms[spawnRoomIndex]`: индекс может продвинуться, а кандидат — быть отклонён. Удаление кеша изменит смысл. |
| [`specialGameModeSetup`](global-variable-references-2026-11-01.md#specialgamemodesetup) | Весь жизненный цикл; GS, GM, PM, S, P, B, debug | Флаг предматчевой подготовки; отделяет её от игрового состояния движка. | Сохранить; это граница передачи слотов, а не освободившийся после меню флаг. |
| [`specialGameMode`](global-variable-references-2026-11-01.md#specialgamemode) | Инициализация → бой; GS, GM, PM, GG, P | Особая обработка TDM/CTF/PUSH/CONTROL. | Сохранить дешёвый кеш определения режима; не путать с типом задания. |
| [`objectiveSpacing`](global-variable-references-2026-11-01.md#objectivespacing) | Конец построения сетки → генерация заданий; GS, GM | Две вычисленные дистанции между целями по размеру сетки. | Освобождается после генерации, а не при исчезновении меню. Возможен поздний reuse; учитывать отдельную корутину generateMapGrid. |
| [`playerTargetList`](global-variable-references-2026-11-01.md#playertargetlist) | Весь бой; S, GG, задания, P, B, Z, SD, enhancements | Доступные цели зомби, включая временно добавляемого спасаемого NPC. | Сохранить: не равен всем игрокам команды или участникам точки. |
| [`mixedObjectivesPool`](global-variable-references-2026-11-01.md#mixedobjectivespool) | Меню → завершение генерации; GS, GM | Разрешённые типы Mixed и исключение близких повторов при построении очереди. | После генерации передать слот `evacCount`, не отдавать его уже в START GAME. |
| [`users`](global-variable-references-2026-11-01.md#users) | Весь бой; P | Имена/идентификаторы для связывания повторно вошедшего игрока с сохранённой статистикой. | Сохранить совместно с `globalPlayerStats`. |
| [`spawnRoomIndex`](global-variable-references-2026-11-01.md#spawnroomindex) | Подготовка и бой; GS, GG | Индекс при сборе комнат, затем индекс проверяемой комнаты спавна. | Уже используется в двух фазах, не освобождается после меню. |
| [`matchEndTime`](global-variable-references-2026-11-01.md#matchendtime) | Инициализация → бой; GS, GG, P, B | Поправка порога времени: 0 либо 0.1 в зависимости от базового режима. | Можно вычислять выражением режима, но много потребителей; это дополнительный, менее выгодный кандидат. |
| [`debugHud`](global-variable-references-2026-11-01.md#debughud) | Все фазы; debug.opy | ID диагностического HUD для удаления/пересоздания после общей очистки текстов. | Полезен в debug-сборке. Удаление подключения debug освобождает слот, но также убирает диагностику и усиления хоста. Это изменение состава сборки. |

## 7. Зомби, боссы и телепортация — 20

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`botHeros`](global-variable-references-2026-11-01.md#botheros) | После голосования → весь бой; GM, GS, S, Bosses, Egg | Таблица героев и порядок индексов всех характеристик зомби. | Сохранить: основа связанных таблиц. |
| [`botSpawnRates`](global-variable-references-2026-11-01.md#botspawnrates) | После голосования → весь бой; GM, GS, GG, Bosses | Веса появления; Shuffle перемешивает их во время матча. | Сохранить: не только настройка меню. |
| [`biteDamages`](global-variable-references-2026-11-01.md#bitedamages) | Весь бой; S | Таблица урона укусов по герою и сложности. | Сохранить кеш; объединение с другими таблицами добавит индексирование в инициализации зомби. |
| [`biteDurations`](global-variable-references-2026-11-01.md#bitedurations) | Весь бой; S | Таблица длительности укуса/эффекта по герою и сложности. | Аналогично: работает, не кандидат удаления. |
| [`damageDealt`](global-variable-references-2026-11-01.md#damagedealt) | Весь бой; S | Таблица множителей наносимого урона; участвует также в калибровке укуса. | Сохранить кеш. |
| [`botHealthValues`](global-variable-references-2026-11-01.md#bothealthvalues) | Весь бой; S | Таблица здоровья зомби по герою и сложности. | Сохранить кеш; меняется при пересчёте числа игроков. |
| [`throttleSpeeds`](global-variable-references-2026-11-01.md#throttlespeeds) | Весь бой; S | Таблица скорости движения по герою и сложности. | Сохранить кеш. |
| [`bosses`](global-variable-references-2026-11-01.md#bosses) | Bosses, Zombie Egg и общие боевые правила; S, B, Z, SD, enhancements | Босс/яйцо и дополнительная высота головы в `[1]`; отличает их от обычных зомби. | Уже общий для двух типов, но читается глобально. Не отдавать другому режиму без изоляции всех потребителей. |
| [`miniBoss`](global-variable-references-2026-11-01.md#miniboss) | Весь бой; S, Bosses, B, Z | Список усиленных минибоссов, исключения и специальные способности. | Сохранить отдельно от `bosses`: обе категории существуют одновременно. |
| [`nonBossZombies`](global-variable-references-2026-11-01.md#nonbosszombies) | Подготовлен после голосования; Bosses | Исключения из списка доступных героев большого босса. | Постоянный список, но нужен последующим Bosses; встраивание добавит литералы. |
| [`availableMutations`](global-variable-references-2026-11-01.md#availablemutations) | Инициализация → весь бой; GS, S | Разрешённые мутации из Workshop Settings. | Сохранить: конфигурация и многократный выбор. |
| [`uniqueSkinCap`](global-variable-references-2026-11-01.md#uniqueskincap) | Весь бой; GS, Bosses, Egg | Настраиваемый лимит разных героев/скинов для создания зомби и боссов. | Сохранить настройку; замена на число потеряет пользовательскую конфигурацию. |
| [`botSpawnPoints`](global-variable-references-2026-11-01.md#botspawnpoints) | Весь бой; B | Кеш удачных позиций появления/телепорта. | Сохранить: экономит повторный поиск и проверки. |
| [`waypoints`](global-variable-references-2026-11-01.md#waypoints) | Весь бой; B | Связанная с каждой кешированной точкой позиция для направления движения зомби. | Не дубликат `botSpawnPoints`; сохранить. |
| [`availableBosses`](global-variable-references-2026-11-01.md#availablebosses) | Между всеми Bosses-заданиями; Bosses | Ротация ещё не выбранных героев босса; выбранный герой удаляется, список пополняется при исчерпании. | **Не освобождается на время другого типа задания**: сохранение очереди предотвращает ранние повторы боссов. |
| [`spawnTimes`](global-variable-references-2026-11-01.md#spawntimes) | Весь бой; GS, B, Kill Zone, Satellite | Очередь задержек новых зомби, секундное уменьшение и отсрочка после задания. | Сохранить: работает параллельно всем типам миссий. |
| [`numberOfBots`](global-variable-references-2026-11-01.md#numberofbots) | Весь бой; GS, B | Настраиваемое число зомби и ограничение очереди появления. | Неизменяемая настройка, но не фиксированная константа 6; прямое встраивание Setting — отдельный компромисс. |
| [`customTelePositions`](global-variable-references-2026-11-01.md#customtelepositions) | Весь бой; B | Передача специальных позиций от погибшего бота новому при создании/инициализации. | Полезная очередь, сохранить. |
| [`botSpawnPointTimers`](global-variable-references-2026-11-01.md#botspawnpointtimers) | Весь бой; GS, B | Загруженность/задержки кешированных точек появления, растут при использовании и уменьшаются раз в секунду. | Сохранить; не равно очереди `spawnTimes`. |
| [`gameSmolderEvent`](global-variable-references-2026-11-01.md#gamesmolderevent) | Бой; S, GS, GG, P, Z | Глобальная фаза события Winston/Smolder, влияет на спавн, HUD, эффекты и способности. | Не принадлежит только одному objective type, сохранить отдельное состояние. |

## 8. Припасы и лежащие предметы — 8

| Переменная | Фаза / основной код | Назначение | Предложение |
| --- | --- | --- | --- |
| [`supplyDropLanding`](global-variable-references-2026-11-01.md#supplydroplanding) | Весь бой; SD | Выбранная конечная позиция припасов, условия взаимодействия и отображения. | Сохранить отдельно от движущейся позиции. |
| [`supplyDropPosition`](global-variable-references-2026-11-01.md#supplydropposition) | Весь бой; SD | Текущая позиция падающего ящика, цель `chase`, координата визуализации. | Не дубликат `supplyDropLanding` во время падения. |
| [`powerUpIDs`](global-variable-references-2026-11-01.md#powerupids) | Весь бой; SD, PU, Biomorphing | ID типов всех лежащих предметов, включая награды Biomorphing. | Нельзя освобождать при выходе из Biomorphing: предметы остаются на земле. |
| [`powerUpPositions`](global-variable-references-2026-11-01.md#poweruppositions) | Весь бой; SD, PU, Biomorphing | Позиции предметов, параллельно `powerUpIDs`. | Сохранить; объединение в записи потребует второго индексирования. |
| [`supplyDropStatus`](global-variable-references-2026-11-01.md#supplydropstatus) | Весь бой; GS, SD | Ящик открыт/разрешён следующий, также управляет визуализацией. | Не выводится только из null позиции; сохранить. |
| [`powerUpText`](global-variable-references-2026-11-01.md#poweruptext) | Весь бой; SD, PU | ID подписей лежащих предметов для удаления при подборе/обмене. | Полезный список ID, сохранить до уничтожения текстов. |
| [`powerUpEffect`](global-variable-references-2026-11-01.md#powerupeffect) | Весь бой; SD, PU | ID эффектов предметов для удаления при подборе/обмене. | Полезный список ID, живёт одновременно с `powerUpText`. |
| [`numberOfPowerUpsPerSupplyDrop`](global-variable-references-2026-11-01.md#numberofpowerupspersupplydrop) | Инициализация → весь бой; GS, SD | Workshop Setting количества предметов и их расстановки. | Не заменять фиксированным 5; встраивание самого Setting можно рассматривать отдельно. |

## Конкретное объединение фаз без увеличения элементов

Варианты ниже используют **прямой глобальный слот**. Не требуется общий массив с доступом через `[index]`, дополнительный поиск, сортировка или периодическое правило копирования. Для читаемости у слота можно оставить два символических имени через `#!define`, документировав владельца каждой фазы; имена не должны создавать дополнительные `globalvar`.

| До передачи слота | После передачи | Когда прежнее значение больше не нужно / как получатель инициализируется |
| --- | --- | --- |
| [`startMenuZombieColors`](global-variable-references-2026-11-01.md#startmenuzombiecolors) | `objectiveEntitiesCount` | После `destroyAllHudTexts()` в START GAME; `for` очистки присваивает индекс до чтения. |
| [`startMenuObjectiveColors`](global-variable-references-2026-11-01.md#startmenuobjectivecolors) | `objectiveCount1` | После удаления HUD; setObjectiveType сначала присваивает 0, Satellite позже начинает собственный `for`. |
| [`startMenuEnhancementColors`](global-variable-references-2026-11-01.md#startmenuenhancementcolors) | `testPos2` | После удаления HUD; Rescue присваивает 115, Satellite — 50 до своих чтений. |
| [`challengeVotes`](global-variable-references-2026-11-01.md#challengevotes) | `biowasteTextLookUp` | Подсчёт и меню завершены; менеджер Biomorphing присваивает таблицу до создания зависящего от неё HUD. |
| [`objectiveTypeVotes`](global-variable-references-2026-11-01.md#objectivetypevotes) | `biowasteColorLookUp` | Аналогично; цвета задаются до создания Biomorphing HUD. |
| [`zombieVotes`](global-variable-references-2026-11-01.md#zombievotes) | `queuedBioType` | Подсчёт завершён; BIO GOAL START безусловно создаёт новую очередь до её извлечения макросом. |
| [`specialEffectsStrings`](global-variable-references-2026-11-01.md#specialeffectsstrings) | `evacDestination` | После завершения меню и удаления текстов; направление записывается перед включением эвакуации игроков. |
| [`specialEffectsTiming`](global-variable-references-2026-11-01.md#specialeffectstiming) | `evacRate` | Меню прекращает изменения через `Wait.ABORT_WHEN_FALSE`; скорость 2 записывается раньше `evacSurvivorList`. |
| [`mixedObjectivesPool`](global-variable-references-2026-11-01.md#mixedobjectivespool) | `evacCount` | После завершения генерации очереди миссий; финал доступен позже, его `for` присваивает счётчик. |

Это **девять освобождённых слотов, изменение числа элементов 0**. Здесь нельзя передавать все значения одним пакетом в момент `specialGameModeSetup = false`: у `mixedObjectivesPool` другая граница — окончание генерации. Не нужно физически очищать каждый донор при передаче, если получатель обязательно присваивает своё значение до любого чтения.

При внедрении особенно проверить первый Biomorphing: присваивание таблиц цветов/строк и очереди должно сохранить порядок. Меню должно завершиться, а переоцениваемые HUD должны быть удалены до повторного использования их палитр. Менять значения палитр уже после END VOTING, пока интерфейс ещё виден, нельзя.

## Что уже объединено между objective types

Подход с `enhancementValue` в глобальном состоянии уже применяется, хотя имена не всегда это показывают:

| Общий слот | Значения по типам |
| --- | --- |
| [`objectiveCaptureValue`](global-variable-references-2026-11-01.md#objectivecapturevalue) | Showdown: процент; Biomorphing: процент; Kill Zone: убийства; Satellite: массив прогресса терминалов. |
| [`objectiveChase1`](global-variable-references-2026-11-01.md#objectivechase1) | Rescue: исходный радиус; Kill Zone: центр; Satellite: позиция лазера. |
| [`survivorToRescue`](global-variable-references-2026-11-01.md#survivortorescue) | Rescue: NPC; Satellite: выбранный зомби для слежения. |
| [`objectiveResourcePositions`](global-variable-references-2026-11-01.md#objectiveresourcepositions) | Biomorphing: ресурсы; Satellite: терминалы. |
| [`queuedGoalType`](global-variable-references-2026-11-01.md#queuedgoaltype) | Showdown: зомби на точке; Biomorphing: очередь биоцелей. |
| [`goalPost`](global-variable-references-2026-11-01.md#goalpost) | Showdown и Biomorphing: следующий порог. |
| [`testPos2`](global-variable-references-2026-11-01.md#testpos2) | Rescue: минимальная дальность спавна; Satellite: расстояние между терминалами. |
| [`bosses`](global-variable-references-2026-11-01.md#bosses) | Bosses: большой босс; Zombie Egg: яйцо. |

Поэтому дальнейшая экономия только между типами меньше, чем можно ожидать по числу файлов. Большинство оставшихся специализированных глобальных полей — одновременно нужные данные Biomorphing. Для нового общего набора вроде `objectiveState1..N` нужно распределять слоты по одновременному времени жизни, а не просто переименовать все специализированные поля.

Есть дополнительные пары для следующего этапа: `goalColor` ↔ `objectiveChase1`, `biowasteTypes` ↔ `testPos2`, `goalText` ↔ `survivorToRescue`. Это **кандидаты после исправления переходов**, в экономию первого набора они не включены. Они также пересекаются с предложенными выше владельцами слотов: их экономию нельзя без проверки складывать с экономией меню.

### Почему один текущий тип ещё не обеспечивает безопасность

1. `BIOWASTE MANAGEMENT` проверяет только `len(deferredType) > 0` и продолжает работу через `wait(0.15)`. Перезапись этого слота состоянием другого режима может запустить создание биоресурсов уже после ухода с Biomorphing.
2. `BIOMORPHING GOAL START` удаляет эффекты с `wait()`, затем делает `waitUntil(..., 3)` и меняет текст, цвет, очереди и `goalCheck`. На этих ожиданиях нет полного прерывания при смене типа. Старый экземпляр может пережить переход.
3. `SURVIVOR FOLLOW TARGET` после `wait(0.25)` выполняет очистку и восстанавливает `objectiveRad` из `objectiveChase1`. Ветка восстановления после нокаута дополнительно ждёт до 20 секунд. Это поздние обращения к общим полям.
4. При поражении во время Satellite активная последовательность лазера содержит долгие ожидания и 40 шагов. `nukeMap` тоже работает с ожиданиями. Поэтому `objectiveCount1` ↔ `evacCount` опаснее предложенного `mixedObjectivesPool` ↔ `evacCount`.
5. `globalObjectiveEntityManagementMacro` удаляет старые глобальные эффекты по одному с ожиданиями. До удаления переоцениваемый эффект всё ещё может обращаться к прежнему состоянию. Часть значков Biomorphing вообще принадлежит игрокам и удаляется другим кодом.
6. `availableBosses` должен сохраняться между разными Bosses-миссиями, даже когда текущий тип другой. Иначе изменится ротация. Аналогично, наградные power-up не исчезают при смене типа.

Для расширенного объединения сначала нужны явные правила выхода из задания: прекратить старые обработчики или проверить актуальность после ожидания, удалить зависимые визуальные сущности, завершить/отменить отложенную работу и остановить соответствующие `chase`. Только после этого можно инициализировать нового владельца. Проверка одного текущего типа не различает два последовательных задания одного типа; там, где это существенно, нужна проверка экземпляра задания или гарантированное завершение старого обработчика. Стоимость такого механизма пока не измерена и не включена в таблицы экономии.

## Измерения и порядок внедрения

Все строки — варианты относительно текущих **115 / 27 224**, а не относительно старых отчётов. Полные результаты: [global-variable-probes-2026-11-01.json](global-variable-probes-2026-11-01.json). Предупреждений компилятора не получено; действуют существующие `suppressWarnings` проекта.

| Вариант | Глобальных | Элементов | Изменение элементов |
| --- | ---: | ---: | ---: |
| Текущий код | 115 | 27 224 | 0 |
| Четыре числовых `#!define` | 111 | 27 213 | −11 |
| Только три палитры меню в существующие длительные слоты | 112 | 27 224 | 0 |
| Только пять других передач состояния меню | 110 | 27 224 | 0 |
| Только Mixed pool → финальный счётчик | 114 | 27 224 | 0 |
| **Числовые константы + все девять передач** | **102** | **27 213** | **−11** |
| Дополнительно угол меню → скорость купола и options → goalText | 100 | 27 214 | −10 |
| Отдельно: все шесть векторных/RGB-констант литералами | 109 | 27 303 | +79 |

Вариант **100** требует переноса `extractionSpeedUp = 2.5` из VARIABLE ASSIGNMENT в START GAME, а также `goalText = null` после удаления меню. Компиляционная проба содержит эти изменения. Для переноса скорости нужно дополнительно убедиться, что GLOBAL MENU INITIALIZATION закончилось и позже не запишет 40 в тот же слот. Компиляция этого условия не доказывает; вариант 100 следует за основным набором, а не считается столь же готовым.

Порядок работ:

1. Четыре числовые константы. Сохранить исходные значения и проверить, что ни один потребитель не нуждается в прежнем 0 до инициализации. Для штатного запуска потребители расположены после нужных присваиваний; отдельно проверить граничный старт/позднее подключение.
2. Три палитры и затем остальные передачи из таблицы, сохранив порядок присваивания и границы жизни. Каждая отдельная передача не добавляет элементов и не вводит индексирование.
3. Прогнать обычный старт, быстрый старт готовых игроков, поздний вход; первый и повторный Biomorphing; Mixed с Rescue/Satellite; победу и поражение во время лазера. Это проверит конкретные места передачи и асинхронные хвосты.
4. Если нужны ещё слоты, сначала рассмотреть недорогую подстановку Kevlar (+5 элементов за слот), затем варианты на 100 и полноценное распределение objective-состояния после защиты переходов.

Известная стоимость полного встраивания шести векторов/цветов — +79 элементов, около 0.29% текущей сборки. Это небольшой абсолютный бюджет, однако оно размножает выражения в местах использования, в том числе в переоцениваемых аргументах. Нагрузка в игре не измерялась. Основной набор на 102 слота обходится без такого компромисса.

Складывание часто читаемых данных в один большой массив тоже освободит слоты, но добавит доступы по индексам. Для поставленной цели выгоднее сначала использовать прямые общие слоты фаз; таблицы характеристик зомби и кеши позиций пока сохранять.

## Воспроизводимость

`node analysis/audit-global-variables.cjs --probes --quiet` собирает список из подключённых исходников, создаёт индекс обращений и компилирует варианты **в памяти**. `src/` и Workshop-файл не перезаписываются. В JSON сохранены хеши исходников на момент аудита. Лексический список ссылок исключает комментарии, строки и поля игрока; классификация записей в JSON синтаксическая и не заменяет анализ времени жизни. Частота исполнения не выводится из количества упоминаний.

Проверены полнота списка из 115 имён и соответствие результатов компиляции; `git diff --check` не выявил ошибок. Модели производительности и подтверждения поведения в клиенте Overwatch этот аудит не даёт.
