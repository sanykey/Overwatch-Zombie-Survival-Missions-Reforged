# Двадцать шестая проверка оптимизаций

Статус: оба рекомендованных изменения внедрены 2026-11-18. База — `e7f4fa53b3c336ff97405a2a98f8af81c278f2f9`, 29 971 элемент. Фактическая сборка main.opy — 29 954 элемента (−17), без предупреждений. Компилятор — OverPy 9.7.21. Импорт в игре, игровой функционал и Server Load не проверялись.

| Вариант | Элементы | Экономия | Решение |
| --- | ---: | ---: | --- |
| Таймер DoT после укуса через max | 29 963 | 8 | Рекомендуется |
| Таймер потока газа Behemoth через max с прежним ограничением по целям | 29 962 | 9 | Рекомендуется |
| **Оба вместе** | **29 954** | **17** | **Без предупреждений** |
| Условный рост радиуса облака через числовое сравнение | 29 972 | −1 | Отклонён |

## Укусы

В `src/game/bots_game_in_progress.opy`, правиле `BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)`:

```python
# Было
if eventPlayer.damageOverTimeRemaining < eventPlayer.botBiteDuration:
    eventPlayer.damageOverTimeRemaining = eventPlayer.botBiteDuration
# Предлагается
eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, eventPlayer.botBiteDuration)
```

В экспорте получается один `Modify Player Variable(Event Player, damageOverTimeRemaining, Max, (Event Player).actorTeamSlot6)`. Получатель таймера остаётся eventPlayer (атакующий бот), хотя сам DoT применяется к victim. Это намеренное сохранение существующего поведения. Длительность, величина и источник DoT, защита от DoT и вся последующая логика заражения совпадают с базой.

## Поток газа Behemoth

В `src/game/zombie_types.opy`, правиле `BEHEMOTH GAS STREAM (BOSS)`:

```python
# Было
if eventPlayer.damageOverTimeRemaining < 2.5 and eventPlayer.botSpecialTargetList != []:
    eventPlayer.damageOverTimeRemaining = 2.5
# Предлагается
if eventPlayer.botSpecialTargetList != []:
    eventPlayer.damageOverTimeRemaining = max(eventPlayer.damageOverTimeRemaining, 2.5)
```

При пустом списке целей таймер, как и раньше, не изменяется. При непустом — новый Modify Max оставляет более длинный остаток или поднимает его до 2.5. Геометрия и рост облаков, список поражённых игроков, защита от DoT, величина урона и период 0.25 секунды сохраняются. Попытка сократить рост радиуса дала больший экспорт и в рекомендованный пакет не включена.

## Проверки и компромиссы

Запуск из корня: `node analysis/2026-11-18-twenty-sixth-element-candidates.cjs`.

[Скрипт](2026-11-18-twenty-sixth-element-candidates.cjs) читает закреплённый коммит и компилирует варианты в памяти. [Результаты](2026-11-18-twenty-sixth-element-candidates.json) и пробные Workshop-экспорты находятся в analysis.

Проверка внедрения: `node analysis/2026-11-18-validate-twenty-sixth-element-implementation.cjs`. Она компилирует фактический main.opy, сравнивает все нормализованные правила с рекомендованными преобразованиями и обновляет локальный main.ws.txt. [Результат](2026-11-18-twenty-sixth-element-implementation.json): изменились только два перечисленных правила; Conditions, объявления переменных, selectTarget, LIVING PROJECTILE RELEASE и BOT INITIALIZATION сохранены, вложенных предикатов нет.

Числовая модель проверяет 96 016 случаев нижней границы таймера и 192 032 случая газа с пустым/непустым списком, включая отрицательный остаток и входы float32/float64. Она не эмулирует Workshop.

В экспорте проверены получатель, длительность укуса, порог газа 2.5 и прежнее сравнение списка с пустым массивом. После удаления соответствующих старых/новых блоков все остальные Actions совпадают, включая пересчитанные смещения Skip. Проверены неизменность набора правил, объявлений переменных, всех Conditions, полного BOT INITIALIZATION (включая Chase), selectTarget и LIVING PROJECTILE RELEASE. Защитные механизмы native UI и ранний LoS-поиск не меняются. Вложенных предикатов нет.

Компромисс аналогичен предыдущему пакету: Modify Max выполняется и тогда, когда таймер уже достаточно длинный; раньше запись пропускалась. Новых запусков, циклов, ожиданий и переменных нет. Экономия измерена в элементах; ускорение не заявляется. При внедрении нужны игровые проверки продолжающегося Chase после повторных укусов, короткого DoT поверх длинного, потока газа с целями и без целей.
