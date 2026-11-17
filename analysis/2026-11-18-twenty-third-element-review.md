# Двадцать третья проверка оптимизаций

Статус: все три рекомендованных изменения внедрены 2026-11-18. База — `e06b82ebb23cad6124d0497fabd8c37e464479d0`, 30 011 элементов, с исправленным условием Living Projectile. Фактическая сборка main.opy — 30 004 элемента (−7), без предупреждений. Компилятор — OverPy 9.7.21. Импорт в игре, игровой функционал и Server Load здесь не проверялись.

| Вариант | Элементы | Экономия |
| --- | ---: | ---: |
| Kevlar: проверка Event Ability по двум значениям через in | 30 008 | 3 |
| Blaster: проверка Event Ability по двум значениям через in | 30 008 | 3 |
| Подбор предметов: сравнение массива с [] вместо его длины с 0 | 30 010 | 1 |
| **Три варианта вместе** | **30 004** | **7** |

Все три варианта рекомендуются по приоритету числа элементов. Предупреждений компилятора нет. Новых переменных, подпрограмм, циклов и ожиданий нет.

## Kevlar

В `src/abilities/augments.opy`, правиле `KEVLAR RANGED DAMAGE COMPENSATION`:

```python
# Было
if eventAbility == null or eventAbility == Button.MELEE:
    return
# Предлагается
if eventAbility in [null, Button.MELEE]:
    return
```

Остаются те же два исключения: отсутствие native ability и быстрый удар ближнего боя. Это проверка принадлежности двум значениям, а не замена сравнения с Null на проверку истинности. Остальные исключения для оружия Reinhardt/Junker Queen, множитель лечения и Actions совпадают с базой.

В экспорте ровно один Or из двух Compare заменяется `Array Contains(Array(Null, Button(Melee)), Event Ability)` внутри прежнего Abort If. Это не Any/All и не вложенный предикат.

## Blaster

В `src/game/zombie_types.opy`, правиле `BLASTER ROCKET HITS TARGET`:

```python
# Было
@Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ULTIMATE) == true
# Предлагается
@Condition (eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]) == true
```

Остаются только Primary Fire и Ultimate. В Workshop меняется лишь соответствующее выражение Condition на Array Contains; проверка защиты от DoT и все Actions совпадают с базой. Ветви длительности/силы горения для Ultimate сохраняются.

## Список предметов для подбора

В `src/items/supply_drops.opy`, правиле `PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)`:

```python
# Было
elif len(aimedPowerUpPositions) > 0 and not (...):
# Предлагается
elif aimedPowerUpPositions != [] and not (...):
```

В этом месте tmp0 гарантированно хранит массив, только что возвращённый Filtered Array. Между записью и этим elif нет ожиданий или вызовов, меняющих scratch. Тело предшествующего if может переиспользовать tmp0, но тогда данный elif не исполняется. Поэтому не возникает подмены len(default scalar) сравнением default scalar с []: проверяемое значение здесь всегда массив.

Меняется только `Compare(Count Of(Global.tmp0), >, Null)` на `Compare(Global.tmp0, !=, Empty Array)`. Сортировка предметов, порядок выбора, перенос активного предмета/резерва и все записи в четыре согласованных массива остаются прежними.

## Проверка

Запуск из корня: `node analysis/2026-11-18-twenty-third-element-candidates.cjs`.

[Скрипт](2026-11-18-twenty-third-element-candidates.cjs) читает закреплённый коммит и компилирует варианты в памяти; [результаты](2026-11-18-twenty-third-element-candidates.json) и пробные Workshop-экспорты сохраняются в analysis.

Проверка внедрения: `node analysis/2026-11-18-validate-twenty-third-element-implementation.cjs`. Она компилирует фактический main.opy, проверяет совпадение всех нормализованных правил с рекомендованными преобразованиями и отсутствие вложенных предикатов, затем обновляет локальный main.ws.txt. [Результаты](2026-11-18-twenty-third-element-implementation.json): изменились только три перечисленных правила; объявления переменных, остальные Conditions, selectTarget и LIVING PROJECTILE RELEASE сохранены.

Для каждого изменения полное нормализованное правило сравнивается с базой после единственной ожидаемой замены выражения. У совместного варианта меняются только три перечисленных правила. Проверены неизменность всех остальных Conditions, объявлений переменных, набора правил, полного selectTarget и полного LIVING PROJECTILE RELEASE. Защитные условия native UI не меняются. Запрещённая пользователем замена раннего LoS-поиска не применяется.

Вся скомпилированная сборка проходит проверку вложенности через `2026-11-18-workshop-predicate-nesting.cjs`: вложенных предикатов нет. Это проверка известного класса ошибок, не полный валидатор импорта в игру.

Компромисс: первые два изменения заменяют скалярные Or/Compare конструированием короткого двухэлементного массива и Array Contains. Экономия элементов измерена; ускорение не заявляется, стоимость исполнения может отличаться. При внедрении в игре стоит проверить Kevlar на быстрых ударах, обычной стрельбе и scripted damage, Blaster на Primary/Ultimate и защищённых от DoT целях, подбор предметов при пустом/непустом списке и заполненном резерве Scavenger.
