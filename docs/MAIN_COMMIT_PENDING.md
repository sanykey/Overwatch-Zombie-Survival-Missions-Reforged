# Коммиты `main`, внедрённые частично или проигнорированные

Состояние `stability-rebuild` на `19c704a`. В таблице 54 коммита, из них 19 внедрены частично и 35 проигнорированы. Порядок соответствует истории `main` до `c698c2b` включительно.

Перечень всех 99 коммитов и критерии сверки приведены в [полном аудите на `5835153`](MAIN_COMMIT_AUDIT.md). Для текущих статусов оставшихся коммитов используется таблица ниже.

| Коммит в `main` | Статус в `stability-rebuild` |
| --- | --- |
| `d0c46e6` — refactor: reorganize source folders and prefix ability files | **Внедрено частично.** Файлы разнесены по каталогам, способности получили префиксы. В `e87801e` инструменты перемещены в `src/tools`. Порядок `include` отличается, в частности для сжатых таблиц и Charge Battery. |
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
| `6762187` — perf: cache force field targets and simplify objective history threshold (-10) | **Внедрено частично по результату.** В `8acbdfd` Force Field сохраняет текущую цель и один раз за тик собирает список ближайших живых зомби. Упрощение порога истории смешанных целей отсутствует. |
| `7319276` — perf: reuse PUP and Reignited impulse directions (-4) | **Проигнорировано.** Повторное использование рассчитанных направлений импульса отсутствует. |
| `e06b82e` — perf: simplify grid validation and supply landing assignment (-8) | **Проигнорировано.** Проверка сетки и присваивание точки приземления дропа остались прежними. |
| `c0438dd` — perf: simplify ability and pickup checks (-7) | **Проигнорировано.** Проверки кнопок и подбора предмета не упрощены. Общая константа вместимости Scavenger пришла отдельно. |
| `e7f4fa5` — perf: simplify DoT timers, charge grants and vote initialization (-33) | **Проигнорировано.** Упрощения таймеров DoT и выдачи зарядов отсутствуют. Начальное значение для `selectVoteWinner` по-прежнему задают вызывающие правила. |
| `b5c271c` — perf: simplify bite and gas stream DoT timers (-17) | **Проигнорировано.** Укус и газ босса Roadhog сохраняют условную запись таймеров. В `main` присваивание через `max` позднее заменено условной записью в `5fcec33` и `1537f50`. |
| `044632d` — perf: share placement feedback and simplify numeric thresholds (-26) | **Проигнорировано.** Общая подпрограмма эффектов размещения и сокращения числовых проверок отсутствуют. |
| `55b4498` — perf: compress boss exclusion hero indices (-20) | **Проигнорировано.** Список исключённых героев боссов не переведён на сжатые индексы. |
| `7fd6b7e` — perf: compress miniboss and spawn metadata to save 19 elements | **Проигнорировано.** Сжатые таблицы индексов мини-боссов и метаданных спавна из этого коммита отсутствуют. В `5b24cee` смещения таблиц весов генерируются в JS как константа OverPy. |
| `c805b4e` — perf: share XZ projection and simplify barricade distance to save 18 elements | **Проигнорировано.** Общая XZ-проекция и упрощение дистанции до баррикады отсутствуют. |
| `409b4ca` — perf: create satellite center beams in a loop to save 24 elements | **Проигнорировано.** Центральные лучи Satellite Uplink не переведены на цикл. |
| `cfdf808` — perf: reuse synchronous position calculations to save 45 elements | **Проигнорировано.** Повторное использование вычисленных позиций, в том числе общей точки для выбора цели Grapnel/Wrestler, отсутствует. |
| `42c78b9` — perf: share color palettes through compressed indices to save 36 elements | **Проигнорировано.** Таблицы вынесены отдельно, но схемы с общей палитрой и сжатыми индексами нет. |
| `d9a07b0` — perf: index spawn metadata directly and flatten objective switches to save 18 elements | **Внедрено частично по результату.** В `5b24cee` смещение таблицы весов берётся напрямую из константы по номеру режима, а длина общая для всех режимов. Упрощение ветвления в `objectivesManagement` отсутствует. |
| `1e1efe0` — perf: hoist Scavenger crouch flag in PLAYER INTERACT to save 18 elements | **Проигнорировано.** Проверка Crouch по-прежнему повторяется в ветках `PLAYER INTERACT`. |
| `e27b53a` — docs: sync Dash/Double Jump rows with current code, drop stale verifier | **Внедрено частично.** Оба README описывают двойное нажатие Jump для Dash и Highrise с интервалами по 0,25 с из `5835153`. Старый верификатор удалён в `1be4242`. Полное описание Dash из `main`, включая сброс зарядов и поведение третьего нажатия, не перенесено. |
| `65e1678` — feat: scale Laser Barricade knockdown and increase push damage | **Внедрено частично.** В `24916e2` множитель 2,5 вынесен в константу, а каждые полные 4 900 урона стене дают 1 с опрокидывания. Повышение урона зомби до 25 пропущено по запросу. Итоговые 20 совпадают с `main` после `2e141c3`. |
| `e4a84e1` — feat: add Auspex Scan enhancement | **Проигнорировано.** Auspex Scan отсутствует. |
| `7373fa0` — refactor: share enhancement values and streamline HUD text | **Внедрено частично.** Общие константы и многие подписи существующих Enhancements перенесены, включая данные активного Bolt Strike для меню. Таблицы выбора и тексты для Auspex отсутствуют. |
| `60abf46` — fix: clarify enhancement and augment menu descriptions | **Внедрено частично.** В `51fe9cf` актуализированы описания доступных способностей и добавлено компактное форматирование дробей. В `94d5f12` описание Charge Battery обновлено до No Cooldowns на 10 с при старте ульты. Строка Auspex отсутствует вместе со способностью. |
| `3384826` — fix: clarify and standardize combat ability HUD text | **Внедрено частично.** В `51fe9cf` обновлён боевой HUD, включая таймер следующего заряда Dash и отдельный откат Highrise. Подсказка Highrise приведена к двойному нажатию в `75d1d38`. Строка Auspex отсутствует вместе со способностью. |
| `5d8c48b` — fix: reduce Auspex scan duration to five seconds | **Проигнорировано.** Auspex отсутствует. В `main` длительный скан позже заменён одиночным импульсом. |
| `897a170` — feat: rework Auspex Scan effects and damage credit | **Проигнорировано.** Эффекты и начисление урона Auspex отсутствуют вместе со способностью. |
| `0ce13aa` — feat: simplify Auspex Scan to a single pulse | **Проигнорировано.** Одиночный импульс Auspex отсутствует. |
| `08205a3` — feat: add performance test profiles and debug controls | **Внедрено частично.** Профиль нагрузки, HUD ресурсов, тест ввода и защита Team 1 доступны. В `9c514b6` добавлена метка `VERSION` со значением `2.0-d` в описании и HUD голосования. Исходный перебор кнопок, активация всех отладочных флагов и исходные значения пресета не перенесены. По умолчанию используется стандартный пул карт, Inspector и HUD ресурсов выключены. |
| `ecd4993` — feat: refine performance testing and add inspector diagnostics | **Внедрено частично.** Есть Inspector, логи нагрузки, автовоскрешение, отдельные пулы карт и сценарий ввода. Полный набор тестовых нажатий донора и его схема включения диагностики не перенесены. |
| `e70b530` — feat: override custom ability cooldowns for performance tests | **Внедрено частично.** Профиль переопределяет откаты имеющихся способностей. Для Bolt Strike проверены 1 с в нагрузочном профиле и 20 с в обычной сборке. Переопределение для Auspex отсутствует вместе со способностью. |
| `94461f3` — feat: update performance test settings and diagnostics | **Внедрено частично.** Есть раздельные фазы по 5 с в тестовом профиле, 50% урона Team 1, Biomorphing и расширенный лог нагрузки. Точное число зомби из этого коммита, `VERSION "1.0-d"` и прибавка невидимости отладочному хосту не перенесены. |
| `6b141ec` — perf: streamline Auspex Scan damage handling | **Проигнорировано.** Обработчика урона Auspex нет. |
| `ad1cb9d` — feat: add bot AI load diagnostics | **Внедрено частично.** Счётчики поиска целей и телепортов и вывод в Inspector перенесены в `e077317`. Число 11 из тестового профиля донора в текущей ветке заменено на 12. |
| `0bc6011` — fix: fall back to Showdown when objectives are disabled | **Проигнорировано.** Fallback на Showdown при отключённых целях не перенесён. |
| `ab139b7` — fix: remove stale miniboss entries and validate boss candidates | **Проигнорировано.** Очистка устаревших записей мини-боссов и дополнительная проверка кандидатов в боссы не перенесены. |
| `dbdf9c1` — perf: bound zombie spawn point cache | **Проигнорировано.** Ограниченный кеш точек спавна и его диагностика отсутствуют. |
| `9ef749a` — perf: bound supply drop landing point search | **Проигнорировано.** Ограничение поиска точки приземления дропа не перенесено. |
| `c698c2b` — revert: reduce repeated line-of-sight checks | **Проигнорировано.** В `main` этот коммит отменяет `2a4354a`. В `stability-rebuild` сохранены все три оптимизации по результату: кеш направления ствола в `0390d8d` с условным сбросом в `d98528b`, периодическая проверка видимости целей зомби в `8509dd8` и проверка расстояния до LoS при возврате босса в `19c704a`. |
