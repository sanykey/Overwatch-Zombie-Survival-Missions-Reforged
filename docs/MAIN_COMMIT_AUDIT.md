# Перенос коммитов `main` в `stability-rebuild`

Сверены 99 коммитов `main` после `2a76d9cad6b34ce2cedac8d7c45a7b796b29a314` до `c698c2b` включительно. Состояние `stability-rebuild` зафиксировано на `5835153`.

Из 99 коммитов 37 внедрены полностью, 17 внедрены частично и 45 проигнорированы. Частичные и проигнорированные переносы собраны в [отдельной таблице](MAIN_COMMIT_PENDING.md).

Статус отражает изменения в коде и документации, включая переносы под другими хешами. Исторические сборки и замеры из `analysis/` не учитываются при оценке игровых изменений. Для коммитов, удаляющих эти материалы, проверено наличие файлов.

| Коммит в `main` | Статус в `stability-rebuild` |
| --- | --- |
| `0bd71ab` — fix: move Hitchhiker last and exclude it from random selection | **Внедрено полностью.** Hitchhiker последний в меню и исключён из случайной выдачи. Таблицы HUD и ID согласованы в `1e5e5ae`. |
| `d0c46e6` — refactor: reorganize source folders and prefix ability files | **Внедрено частично.** Файлы разнесены по каталогам, способности получили префиксы. В `e87801e` инструменты перемещены в `src/tools`. Порядок `include` отличается, в частности для сжатых таблиц и Charge Battery. |
| `a0189c6` — refactor: extract enums and constants into dedicated core files | **Внедрено полностью.** Константы, enum и неизменяемые таблицы разнесены по файлам в `56e32d5`, `cf500cf` и `552801b`. |
| `8980599` — feat: rebalance Engineer crafting and use double crouch for armor | **Внедрено полностью.** Цены и объём брони перенесены в `f99fa93`. Двойное нажатие, удаление лома за ассисты и подсказки перенесены в `de9be92`. |
| `e27322c` — perf: reduce Workshop element count by 62 | **Внедрено частично по результату.** В `974d3e1` расчёт сопротивления использует уже вычисленный `isDotProtected`, а отдельный флаг HUD удалён. Общая подпрограмма снятия цели бота и остальные сокращения не перенесены. |
| `17841c2` — perf: reduce Workshop element count by 27 | **Внедрено частично по результату.** В `974d3e1` сопротивление рассчитывается после обновления флага защиты от DoT. Упрощения выбора кнопки Born to Battle и остальных правил из этой порции не перенесены. |
| `bf99081` — perf: reduce Workshop element count by 36 | **Проигнорировано.** Переписывание геометрии Laser Barricade и сопутствующие сокращения не перенесены. |
| `c9b8d18` — perf: reduce Workshop element count by 37 | **Проигнорировано.** Общие подпрограммы для смены комнаты спавна, кольца Showdown и очереди Biomorphing не перенесены. |
| `031ecfb` — perf: reduce Biomorphing Workshop element count by 14 | **Проигнорировано.** Выбор носителя и вычисление ближайшей позиции Biomorphing остались прежними. |
| `ef434df` — perf: reduce Workshop element count by 32 | **Проигнорировано.** Engineer по-прежнему сначала сохраняет список кандидатов, затем выбирает цель. Остальные сокращения этой порции также не перенесены. |
| `33abeac` — perf: reduce Workshop element count by 24 | **Проигнорировано.** Промежуточный результат проверки перезарядки Ammo Pack и остальные сокращения этой порции отсутствуют. |
| `996bd52` — perf: reduce Workshop element count by 26 | **Внедрено частично.** В `2d30358` исходная точка камеры вычисляется один раз за обновление. Текст Wrestler обновлён отдельно. Упрощение выбора путевой точки в Survivor Rescue не перенесено. |
| `2a9a927` — perf: reduce horizontal distance and boss text elements | **Проигнорировано.** Оптимизации горизонтальных расстояний и текста босса не перенесены. |
| `36517d8` — perf: simplify Slimer positions and visual expressions | **Внедрено частично по результату.** В `561571e` у портрета игрока один вызов `heroIcon`. Упрощения позиции Slimer и остальных визуальных выражений не перенесены. |
| `bc31f30` — perf: share synchronous action pairs and factor vector scales | **Внедрено частично.** Масштаб выносится за скобки при вычислении смещения Hitchhiker в `c8d9cc1`. Общие подпрограммы для остальных пар действий и вынос множителей в других правилах не перенесены. |
| `49c7820` — perf: remove redundant subroutines and cache prior clip ammo | **Проигнорировано.** Удаление подпрограмм и кеширование предыдущего боезапаса магазина не перенесены. |
| `47b34eb` — perf: simplify boss health initialization (-2) | **Проигнорировано.** Инициализация здоровья боссов осталась прежней. |
| `7be5c02` — perf: share armor grant and cache Hitchhiker and stun expressions (-9) | **Внедрено частично.** В `c8d9cc1` ссылка на носителя кешируется при балансировке здоровья Hitchhiker. Общий расчёт выдаваемой брони и упрощение выражения оглушения не перенесены. |
| `88f8406` — perf: simplify Dash axis signs and zero-vector check (-14) | **Проигнорировано.** Упрощение знаков осей и проверки нулевого вектора Dash не перенесено. |
| `1fff49d` — perf: remove empty boss and enhancement switch arms (-15) | **Проигнорировано.** Пустые ветки `switch` не удалены. |
| `82a51f5` — perf: share PUP and Smolder actions and simplify player initialization (-10) | **Проигнорировано.** Общие действия P.U.P. и Smolder и упрощение инициализации игрока не перенесены. |
| `d0cf55e` — perf: remove redundant Reignited guard and spawn hero snapshot (-9) | **Проигнорировано.** Проверка Reignited и сохранение героя для спавна остались прежними. |
| `6762187` — perf: cache force field targets and simplify objective history threshold (-10) | **Проигнорировано.** Кеш цели Force Field и упрощение порога истории целей отсутствуют. |
| `7319276` — perf: reuse PUP and Reignited impulse directions (-4) | **Проигнорировано.** Повторное использование рассчитанных направлений импульса отсутствует. |
| `e06b82e` — perf: simplify grid validation and supply landing assignment (-8) | **Проигнорировано.** Проверка сетки и присваивание точки приземления дропа остались прежними. |
| `c0438dd` — perf: simplify ability and pickup checks (-7) | **Проигнорировано.** Проверки кнопок и подбора предмета не упрощены. Общая константа вместимости Scavenger пришла отдельно. |
| `e7f4fa5` — perf: simplify DoT timers, charge grants and vote initialization (-33) | **Проигнорировано.** Упрощения таймеров DoT и выдачи зарядов отсутствуют. Начальное значение для `selectVoteWinner` по-прежнему задают вызывающие правила. |
| `b5c271c` — perf: simplify bite and gas stream DoT timers (-17) | **Проигнорировано.** Упрощённое продление DoT укуса и газа не перенесено. |
| `044632d` — perf: share placement feedback and simplify numeric thresholds (-26) | **Проигнорировано.** Общая подпрограмма эффектов размещения и сокращения числовых проверок отсутствуют. |
| `55b4498` — perf: compress boss exclusion hero indices (-20) | **Проигнорировано.** Список исключённых героев боссов не переведён на сжатые индексы. |
| `7fd6b7e` — perf: compress miniboss and spawn metadata to save 19 elements | **Проигнорировано.** Сжатые таблицы мини-боссов и метаданных спавна отсутствуют. |
| `c805b4e` — perf: share XZ projection and simplify barricade distance to save 18 elements | **Проигнорировано.** Общая XZ-проекция и упрощение дистанции до баррикады отсутствуют. |
| `409b4ca` — perf: create satellite center beams in a loop to save 24 elements | **Проигнорировано.** Центральные лучи Satellite Uplink не переведены на цикл. |
| `cfdf808` — perf: reuse synchronous position calculations to save 45 elements | **Проигнорировано.** Повторное использование вычисленных позиций, в том числе общей точки для выбора цели Grapnel/Wrestler, отсутствует. |
| `42c78b9` — perf: share color palettes through compressed indices to save 36 elements | **Проигнорировано.** Таблицы вынесены отдельно, но схемы с общей палитрой и сжатыми индексами нет. |
| `d9a07b0` — perf: index spawn metadata directly and flatten objective switches to save 18 elements | **Проигнорировано.** Прямая индексация метаданных спавна и упрощение ветвления целей отсутствуют. |
| `1e1efe0` — perf: hoist Scavenger crouch flag in PLAYER INTERACT to save 18 elements | **Проигнорировано.** Проверка Crouch по-прежнему повторяется в ветках `PLAYER INTERACT`. |
| `f8c9ef6` — feat: raise Grapnel contact damage to 75 and bind it to a define | **Внедрено полностью.** Урон 75, общая константа для действия и подсказки, вынесенные параметры Grapnel/Kevlar и описания присутствуют. |
| `3c000dd` — feat: add 75 pull damage and raise Wrestler throw damage to 100 | **Внедрено полностью.** Бросок на 100 перенесён в `5382e4f`, подтягивание на 75 и обновлённые описания — в `de9be92`. |
| `19cf162` — refactor: rename Long Reach/Leech identifiers to Telekinesis/Survivalist | **Внедрено полностью.** Имена в коде, путь файла Telekinesis и идентификаторы в генераторе переименованы в `2cfe0bb`. |
| `2446377` — perf: merge Dash/Highrise double-tap activation into one rule | **Внедрено полностью.** В `75d1d38` Dash и Highrise используют общее правило двойного нажатия Jump. Одиночный триггер Highrise в воздухе и его состояние удалены, HUD обновлён. В `5835153` интервалы отпускания и повторного нажатия выделены в отдельные константы по 0,25 с. В `main` используется общее окно 0,3 с на каждый шаг. |
| `e27b53a` — docs: sync Dash/Double Jump rows with current code, drop stale verifier | **Внедрено частично.** Оба README описывают двойное нажатие Jump для Dash и Highrise с интервалами по 0,25 с из `5835153`. Старый верификатор удалён в `1be4242`. Полное описание Dash из `main`, включая сброс зарядов и поведение третьего нажатия, не перенесено. |
| `25d4049` — chore: remove the 35 probe scripts orphaned by the harness deletion | **Внедрено полностью.** Все 35 скриптов удалены из текущего дерева в `1be4242`. |
| `fbef928` — chore: remove the feature-port audit script/report and their mentions | **Внедрено полностью.** Скрипт и отчёт удалены, ссылки на них сняты в `1be4242`. |
| `108afbb` — chore: remove camera-switch small message and rename 3D camera to 3P | **Внедрено полностью.** В HUD используется `3P camera`. Всплывающее сообщение при смене режима камеры удалено в `4795427`. |
| `2bf5c41` — chore: remove all remaining analysis scripts, reports and validation artifacts | **Внедрено полностью.** Содержимое каталога удалено в `1be4242`. Локальный каталог добавлен в `.gitignore`. |
| `fc80d6a` — docs: drop stale analysis/ references after directory removal | **Внедрено полностью.** Устаревшие ссылки и команды убраны из документации в `1be4242`. Для исторических материалов указан коммит `381a252`. |
| `69b8750` — feat: remove Ana self Super Nano on untargeted ultimate press | **Внедрено полностью.** Самоприменение Super Nano по нажатию ульты Аны без цели удалено в `01758d2`. Предмет Super Nano по-прежнему доступен. |
| `35f7a7c` — feat: remove the infected "Find a healthpack" HUD | **Внедрено полностью.** Мигающая подсказка удалена в `46cc45f`. Значок ближайшей аптечки и расстояние до неё сохранены. |
| `b35cf9b` — feat: remove the Apothecary augment | **Внедрено полностью.** Apothecary удалён из меню, случайной выдачи, HUD и игровых правил в `de9cfb9`. Индексы Scavenger и Survivalist обновлены. |
| `534dea7` — feat: replace Vaccine powerup with Cure vaccination | **Внедрено полностью.** В `da0bd25` отдельная Vaccine удалена. Cure снимает активное заражение или снижает уровень инфекции незаражённого игрока на 1,5. |
| `0ed86a5` — feat: remove the damage resistance marker from the health HUD | **Внедрено полностью.** Маркер `*` и его переменная удалены в `974d3e1`. Расчёт сопротивления и защита от DoT сохранены. |
| `cfa4276` — feat: reduce Telekinesis melee push cooldown to 15 seconds | **Внедрено полностью.** Перезарядка отталкивания 15 с в `5382e4f`. |
| `65e1678` — feat: scale Laser Barricade knockdown and increase push damage | **Проигнорировано.** Опрокидывание по-прежнему длится фиксированную 1 с, множитель 2,5 не вынесен из правила, урон остался 20. Изменение урона до 25 позже отменено и в `main`. |
| `e4a84e1` — feat: add Auspex Scan enhancement | **Проигнорировано.** Auspex Scan отсутствует. |
| `4ac6bee` — refactor: extract Hitchhiker enhancement into its own file | **Внедрено полностью.** Правила и макрос HUD Hitchhiker вынесены в отдельный файл, имена состояния согласованы. Извлечение выполнено в `97c5e68` и `1013e62`, итоговая реализация доведена в `c8d9cc1`. |
| `b1c4cb4` — fix: make Hitchhiker detach reliably | **Внедрено полностью.** В `c8d9cc1` ручное и принудительное отсоединение и смена героя используют общую очистку. Обновлены выбор цели, смещение и баланс здоровья. Тестовый пул был включён этим переносом, затем `05ccf59` вернул стандартный. |
| `cc7fa82` — fix: enforce single Hitchhiker pairs | **Внедрено полностью.** В `c8d9cc1` каждый игрок может входить только в одну пару. Место переносчика освобождается после снятия пула, в том числе при отключении пассажира. Перенесены HUD нагрузки и изменения отладки хоста. |
| `7921054` — fix: preserve player HUD portraits during Smolder enrage | **Внедрено полностью.** В `561571e` портрет выбирается по текущему или скопированному герою независимо от Smolder enrage. |
| `0426234` — feat: rework Bolt Strike into an active lightning strike | **Внедрено полностью.** В `9429744` пассивная цепь заменена активной молнией по двойному нажатию Crouch. Перенесены выбор цели, урон по области, оглушение, откат и HUD. |
| `1680c66` — docs: define hero ability HUD text style | **Внедрено полностью.** Правила сокращений и формулировок есть в `AGENTS.md`. |
| `807e01b` — feat: rebalance player damage by hero role | **Внедрено полностью.** Те же изменения настроек урона Team 1 перенесены в `0216778`. |
| `7373fa0` — refactor: share enhancement values and streamline HUD text | **Внедрено частично.** Общие константы и многие подписи существующих Enhancements перенесены, включая данные активного Bolt Strike для меню. Таблицы выбора и тексты для Auspex отсутствуют. |
| `0ab1b2f` — refactor: organize pregame menus and share HUD creation | **Внедрено полностью.** Файлы меню и макросы HUD выделены. В `381a252` создание Augment HUD перенесено в общее pregame-правило `EFFECTS/TEXTS` сразу после Enhancement HUD. |
| `60abf46` — fix: clarify enhancement and augment menu descriptions | **Внедрено частично.** В `51fe9cf` актуализированы описания доступных способностей и добавлено компактное форматирование дробей. Charge Battery описывает сброс откатов при старте ульты. Строка Auspex отсутствует вместе со способностью. |
| `3384826` — fix: clarify and standardize combat ability HUD text | **Внедрено частично.** В `51fe9cf` обновлён боевой HUD, включая таймер следующего заряда Dash и отдельный откат Highrise. Подсказка Highrise приведена к двойному нажатию в `75d1d38`. Строка Auspex отсутствует вместе со способностью. |
| `77d57fd` — refactor: share ability constants between HUD and gameplay | **Внедрено полностью.** HUD и игровые правила используют общие параметры Ammo Pack, Grapnel, Scavenger и Survivalist. В `51fe9cf` один коэффициент Telekinesis связан с HUD, Carnage и генератором таблицы урона. |
| `969c57d` — refactor: rename pregame ability HUD files | **Внедрено полностью.** Оба файла и подключения используют имена `start_menu_*_hud.opy`. |
| `2e141c3` — fix: reduce Laser Barricade contact damage | **Внедрено частично.** Код наносит итоговые 20 урона, и русское описание указывает 20. В английском README осталось 10. |
| `5d8c48b` — fix: reduce Auspex scan duration to five seconds | **Проигнорировано.** Auspex отсутствует. В `main` длительный скан позже заменён одиночным импульсом. |
| `db998c4` — feat: scale third-person camera with player size | **Внедрено полностью.** В `2d30358` высота и отступ камеры в режиме Precise масштабируются по размеру игрока, сохраняя обе проверки стен. |
| `99bb3db` — feat: grant No Cooldowns on Charge Battery ultimate activation | **Проигнорировано.** Charge Battery сохраняет прежний сброс перезарядок при ульте. Эффект No Cooldowns по этому событию отсутствует. |
| `2ca9dda` — feat: extend Charge Battery No Cooldowns to ten seconds | **Проигнорировано.** Десятисекундный эффект отсутствует вместе с механикой из `99bb3db`. |
| `2cac12c` — feat: increase Plague Doctor healing bonus to 40 percent | **Внедрено полностью.** Бонус 40% перенесён в `5382e4f` и отражён в HUD. |
| `897a170` — feat: rework Auspex Scan effects and damage credit | **Проигнорировано.** Эффекты и начисление урона Auspex отсутствуют вместе со способностью. |
| `0ce13aa` — feat: simplify Auspex Scan to a single pulse | **Проигнорировано.** Одиночный импульс Auspex отсутствует. |
| `7612e4d` — feat: disable Sierra Tracking Shot hack | **Внедрено полностью.** В `a0bb804` удалено правило наложения скриптового Hack при попадании Tracking Shot Сьерры. |
| `43fe001` — fix: clarify Brain Killer critical damage in the HUD | **Внедрено полностью.** Оба HUD показывают итоговые 160% критического урона и 120% по боссам. |
| `ce7828f` — chore: select the standard map pool | **Внедрено полностью.** В `05ccf59` выбран стандартный пул карт. |
| `08205a3` — feat: add performance test profiles and debug controls | **Внедрено частично.** Профиль нагрузки, HUD ресурсов, тест ввода и защита Team 1 доступны. HUD ресурсов включён в `c8d9cc1`, тестовый пул остаётся доступен. Исходный перебор кнопок, включение всех отладочных флагов, исходные значения пресета и метка `VERSION` не перенесены. |
| `ecd4993` — feat: refine performance testing and add inspector diagnostics | **Внедрено частично.** Есть Inspector, логи нагрузки, автовоскрешение, отдельные пулы карт и сценарий ввода. Полный набор тестовых нажатий донора и его схема включения диагностики не перенесены. |
| `e70b530` — feat: override custom ability cooldowns for performance tests | **Внедрено частично.** Профиль переопределяет откаты имеющихся способностей. Для Bolt Strike проверены 1 с в нагрузочном профиле и 20 с в обычной сборке. Переопределение для Auspex отсутствует вместе со способностью. |
| `94461f3` — feat: update performance test settings and diagnostics | **Внедрено частично.** Есть раздельные фазы по 5 с в тестовом профиле, 50% урона Team 1, Biomorphing и расширенный лог нагрузки. Точное число зомби из этого коммита, `VERSION "1.0-d"` и прибавка невидимости отладочному хосту не перенесены. |
| `6b141ec` — perf: streamline Auspex Scan damage handling | **Проигнорировано.** Обработчика урона Auspex нет. |
| `5fcec33` — perf: skip redundant bite timer writes | **Проигнорировано.** Пропуск лишних записей таймера укуса не перенесён. |
| `1537f50` — perf: skip redundant Roadhog gas timer writes | **Проигнорировано.** Пропуск лишних записей таймера газа Roadhog не перенесён. |
| `ad1cb9d` — feat: add bot AI load diagnostics | **Внедрено частично.** Счётчики поиска целей и телепортов и вывод в Inspector перенесены в `e077317`. Число 11 из тестового профиля донора в текущей ветке заменено на 12. |
| `068700a` — perf: cache nearby Force Field targets per tick | **Проигнорировано.** Список ближайших целей Force Field не кешируется на тик. |
| `021210c` — fix: bound weighted zombie spawn selection | **Проигнорировано.** Взвешенный выбор не ограничен вычисленной суммой весов. Метка `2.0-d` также отсутствует. |
| `0bc6011` — fix: fall back to Showdown when objectives are disabled | **Проигнорировано.** Fallback на Showdown при отключённых целях не перенесён. |
| `9d89b35` — fix: require at least two supply drop items | **Внедрено полностью.** В `43c2b0f` нижний предел настройки сброса припасов повышен до двух предметов. |
| `4c15fe3` — feat: log teleporting zombies without targets | **Внедрено полностью.** Поле `teleNoTargetBots` добавлено в лог AI через `e077317`. |
| `6044347` — docs: require OverPy macros for new predicates | **Внедрено полностью.** Требование использовать `macro` для новых предикатов есть в `AGENTS.md`. |
| `ab139b7` — fix: remove stale miniboss entries and validate boss candidates | **Проигнорировано.** Очистка устаревших записей мини-боссов и дополнительная проверка кандидатов в боссы не перенесены. |
| `dbdf9c1` — perf: bound zombie spawn point cache | **Проигнорировано.** Ограниченный кеш точек спавна и его диагностика отсутствуют. |
| `9ef749a` — perf: bound supply drop landing point search | **Проигнорировано.** Ограничение поиска точки приземления дропа не перенесено. |
| `2a4354a` — perf: reduce repeated line-of-sight checks | **Проигнорировано.** Оптимизация LoS отсутствует и в текущем `main`, где она отменена коммитом `c698c2b`. |
| `2673ca0` — fix: refresh active powerups without restarting their rules | **Проигнорировано.** Обновление активных powerups без перезапуска их правил не перенесено. |
| `c698c2b` — revert: reduce repeated line-of-sight checks | **Внедрено полностью по результату.** Сохранена исходная логика LoS, к которой `main` вернулся этим коммитом. Отдельный revert в `stability-rebuild` не требовался. |

Основа сверки — аудит первого этапа из истории Git, диффы и исходный код. Сборка Workshop для `5835153` со стандартным пулом карт содержит 29 760 элементов и компилируется без предупреждений. Проверка в матче не проводилась.
