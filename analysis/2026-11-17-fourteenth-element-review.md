# Четырнадцатый поиск сокращений — 17 ноября 2026

База: `47b34eb31a984493f6720e483d80ac50903fb159`, **30 090 элемента**, OverPy 9.7.21. Первоначальные пробы выполнялись в памяти. По запросу пользователя три рекомендованных сокращения затем внедрены; корневой `main.ws.txt` пересобран.

## Рекомендуемый набор

| Кандидат | Экономия отдельно | Элементов отдельно |
|---|---:|---:|
| Engineer: одна величина фактической добавки брони для pool и счётчика | 6 | 30 084 |
| Hitchhiker Lifebonds: один снимок ссылки на носителя | 2 | 30 088 |
| Stun beam: общее выражение позиции origin внутри live map | 1 | 30 089 |

**Совместная компиляция: 30 090 → 30 081, −9 элементов (~0,030%), 0 предупреждений.** Новых правил, подпрограмм и global/player variables нет. Используются существующие временные слоты с локальными alias-именами.

Все Conditions, объявления переменных и набор правил совпали с базой. Изменились ровно `ENGINEER ARMOR TRANSFER`, `HITCHHIKER LIFEBONDS` и `stun (100-109)`. `selectTarget` и `applyDamageReceivedModifier` побуквенно совпали с базой после исключения аннотаций. Ранее исключённая пользователем замена раннего LoS-поиска на filter()[0] не применяется и не является частью этих проб.

## Engineer: общая фактическая добавка брони — −6

В `abilities/enhancements.opy`, после проверки средств и списания scrap:

```python
# Было
scrapArmorGrantTarget.addHealthPool(Health.ARMOR, min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount), false, false)
scrapArmorGrantTarget.scrapArmorAmount = min(ENGINEER_ARMOR_MAX, scrapArmorGrantTarget.scrapArmorAmount + ENGINEER_ARMOR_STACK)

# Предлагается
#!define scrapArmorGrantAmount tmp0
scrapArmorGrantAmount = min(ENGINEER_ARMOR_STACK, ENGINEER_ARMOR_MAX - scrapArmorGrantTarget.scrapArmorAmount)
scrapArmorGrantTarget.addHealthPool(Health.ARMOR, scrapArmorGrantAmount, false, false)
scrapArmorGrantTarget.scrapArmorAmount += scrapArmorGrantAmount
```

STACK = 75, MAX = 200. Счётчик хранит оставшуюся scrap-броню: исходное значение 0, выдачи ограничены 200, обработчик урона уменьшает его с ограничением снизу 0, смерть сбрасывает в 0. Перед выдачей полная броня уже отсечена существующим guard. Для допустимого диапазона 0..200:

```text
a + min(75, 200 - a) = min(200, a + 75)
```

Сохраняются и реальный размер добавленного pool, и новый счётчик. Проверены **20 010** значений, включая 0/75/125/200, точки около границы частичного пополнения и случайные дробные значения, в моделях float64 и пооперационного float32. Проверка не является эмуляцией health pools Workshop.

Жизнь временных значений: tmp0 раньше содержал стоимость, которая уже проверена и списана; tmp1 остаётся целью. Новый amount живёт только через Add Health Pool и немедленный Modify Player Variable. До его последнего чтения нет wait или вызовов подпрограмм. Оба флага Add Health Pool остаются False; в скомпилированном действии это проверено явно. Размер pool не должен начать читать последующие значения tmp0 при reevaluation.

Сохраняются приоритет союзника/себя, отказы при лимите и нехватке scrap, затраченная полная стоимость, исходный порядок pool → счётчик → сообщения/эффекты, текст о полном STACK при частичном пополнении и длительность beam. Нужен игровой прогон выдачи себе/союзнику, остатка 124/125/126/199, дробного остатка после урона, лимита нескольких Engineer и смерти цели.

Компромисс: одно дополнительное scratch-присваивание заменяет повторный расчёт нового capped-счётчика. Ускорение по element count не утверждается.

## Hitchhiker Lifebonds: carrier в tmp3 — −2

В начале Actions `HITCHHIKER LIFEBONDS`, перед расчётом transfer amount:

```python
#!define hitchhikerHealthCarrier tmp3
hitchhikerHealthCarrier = eventPlayer.enhancementHitchhikerCarrier
```

Пять обращений к прежней ссылке носителя в формуле amount, списке для выбора recipient и списке donor заменяются на alias. Формула величины обмена, сортировка normalized health, выбор donor, оба Set Health и их порядок остаются прежними.

Контракт слотов не пересекается: tmp0 — transfer amount, tmp1 — recipient, tmp2 — donor, tmp3 — carrier. Все чтения carrier заканчиваются **до первого Set Health**. После него и через wait alias не читается; это проверено по исходному участку. В расчёте и выборе donor нет waits, подпрограмм или записей ссылки носителя. Сохраняются прежние Conditions, включая живых обоих игроков и порог разницы здоровья.

Нужны игровые проверки лечения обоих направлений, равного/почти равного normalized health, разных maximum health, отсоединения и смерти носителя. Дополнительное присваивание scratch уменьшает повторные чтения поля; CPU не измерялся.

## Stun beam: общий origin внутри map — −1

В `items/supply_drops.opy` меняется только конечная точка создаваемого beam:

```python
[eventPlayer.powerUpStunOrigin.getPosition() + losOffsetConst].map(lambda origin: eventPlayer.powerUpStunBeamPosition + directionTowards(eventPlayer.powerUpStunBeamPosition, origin) * min(3, distance(eventPlayer.powerUpStunBeamPosition, origin)))[0]
```

Позиция origin раньше повторялась в directionTowards и distance. Теперь она вычисляется один раз на reevaluation самого выражения. Самостоятельного присваивания позиции, scratch, evalOnce и нового обновляющего правила нет. Прежний `EffectReeval.VISIBILITY_POSITION_AND_RADIUS` сохранён. Направление и distance получают прежние аргументы в прежнем порядке; ограничение длины min(3, ...) остаётся прежним.

Проверены **10 000** моделей результата и аргументов вызовов, включая совпадение lead/origin. Модель не тестирует реальную анимацию, стены или нативную переоценку. В игре проверить движение владельца и цели, отражения stun между игроками, смену origin и уничтожение beam по окончании.

Компромисс: создаются singleton array и Mapped Array при переоценке вместо повторного чтения origin/позиции/смещения. Это экономия одного элемента, не доказательство ускорения native math или визуала.

## Остальные пробы

| Кандидат | Результат | Решение |
|---|---:|---|
| Кеш Dash protection в tmp1 внутри applyDamageReceivedModifier | −10 | Не включён: нужен дополнительный аудит clobber-контракта вызывающих путей и времени чтения scratch в Set Damage Received |
| Список пар [target, center] в selectPullAimTarget | −2 | Не включён: новый формат вложенных массивов ради малого выигрыша; нативная вложенность и empty-result требуют отдельного игрового подтверждения |
| Singleton map с beam position вместо origin в Stun | +1 | Отклонён |
| Общие ветви мутаций размера | +9 | Отклонён |
| Hero in [singleHero] → Hero == singleHero | 0 | Компилятор уже выдаёт те же правила |

Особенность кандидата Dash: tmp0 нельзя использовать, так как вызывающий Dash хранит в нём направление будущего импульса через этот вызов. Предварительная проба использует tmp1, но одна компиляция не доказывает безопасность всех временных значений/нативных входов; эта проба остаётся за пределами рекомендуемого набора. В рекомендуемом наборе функция защиты целиком сохранена.

## Воспроизведение

```text
node analysis/2026-11-17-fourteenth-element-candidates.cjs
```

Скрипт закреплён на базовом коммите, пишет результаты и экспорты только в analysis и не применяет изменения к src/main.ws.txt. JSON содержит compiler version, базовый коммит, SHA-256 развёрнутых исходников, отдельные/совместные замеры, список изменённых правил и результаты проверок.

В совместной пробе автоматически сверены объявления переменных, порядок/набор правил, Conditions всех правил, точный список трёх изменённых правил, сохранение раннего LoS-поиска, флаги pool и граница жизни снимка carrier. Защитные uiPhaseAndId и событийные guards, порядок Pregame UI и waits не меняются.

## Внедрение

Три рекомендованных сокращения внесены в два игровых файла. Настоящая компиляция корневого `main.opy`: **30 081 элементов, −9, 0 предупреждений**. Исполняемые правила совпали с совместной проверенной пробой после исключения аннотаций компилятора.

Проверены прежние объявления переменных, набор правил и все Conditions, точный список трёх изменённых правил, сохранение `selectTarget` и `applyDamageReceivedModifier`, два False-флага Add Health Pool, отсутствие evalOnce в Stun beam и окончание жизни снимка carrier до первого Set Health. Отсеянные варианты не внедрялись.

После воспроизведения проб проверка внедрения:

```text
node analysis/2026-11-17-validate-fourteenth-element-implementation.cjs
```

Валидатор проверяет точные подстановки и настоящую сборку, затем обновляет локальный `main.ws.txt`, игнорируемый git по существующим настройкам. Флаг `--apply` применяет только три рекомендованных изменения поверх проверенной базы либо уже внедрённого варианта. [Результат внедрения](2026-11-17-fourteenth-element-implementation.json).

Игровой прогон и Server Load-профиль не выполнялись. Компромиссы временных присваиваний и singleton map, перечисленные сценарии игровых проверок и первый выбор героя в свежем матче с полными визуалами остаются в силе.

[Скрипт](2026-11-17-fourteenth-element-candidates.cjs) · [JSON](2026-11-17-fourteenth-element-candidates.json)
