# Все обращения к глобальным переменным — обновлено 2026-11-02

Сгенерировано `node analysis/audit-global-variables.cjs`. Только файлы, подключённые из `main.opy`.

В строках исключены комментарии, текстовые литералы, объявления и одноимённые поля игрока. Идентификаторные `#!define`-алиасы разрешены в физические слоты: объявления алиасов перечислены как имена ролей, обращения к ролям учтены по месту использования. Остальные тела макросов учтены один раз в исходнике. Инициализаторы констант находятся по ссылке на объявление. Полные тексты строк доступны в JSON.

Количество ссылок в скомпилированном Workshop учитывает раскрытие макросов и оптимизации. Само по себе оно не показывает частоту исполнения или время жизни.

## tmp0

Объявление: [variables.opy:66](../src/variables.opy#L66). Строк обращений: 199; упоминаний: 232; чтений вида Global в скомпилированном коде: 164.

- subroutines.opy — macro botStatManagementMacro(): [33](../src/subroutines.opy#L33), [34](../src/subroutines.opy#L34), [36](../src/subroutines.opy#L36), [37](../src/subroutines.opy#L37), [39](../src/subroutines.opy#L39), [41](../src/subroutines.opy#L41), [42](../src/subroutines.opy#L42).
- subroutines.opy — macro botEntityManagementMacro(): [146](../src/subroutines.opy#L146), [148](../src/subroutines.opy#L148), [151](../src/subroutines.opy#L151).
- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [243](../src/subroutines.opy#L243), [244](../src/subroutines.opy#L244), [382](../src/subroutines.opy#L382), [384](../src/subroutines.opy#L384), [387](../src/subroutines.opy#L387), [390](../src/subroutines.opy#L390), [393](../src/subroutines.opy#L393).
- subroutines.opy — def setDifficulty(): [412](../src/subroutines.opy#L412).
- subroutines.opy — def selectTarget(): [672](../src/subroutines.opy#L672), [673](../src/subroutines.opy#L673).
- subroutines.opy — def botRespawnInitialization(): [729](../src/subroutines.opy#L729), [730](../src/subroutines.opy#L730).
- global_startup.opy — macro botHeroRandomizationMacro(): [52](../src/global_startup.opy#L52), [56](../src/global_startup.opy#L56), [58](../src/global_startup.opy#L58), [63](../src/global_startup.opy#L63).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [240](../src/global_startup.opy#L240).
- global_startup.opy — def generateMapGrid(): [307](../src/global_startup.opy#L307), [309](../src/global_startup.opy#L309), [310](../src/global_startup.opy#L310), [311](../src/global_startup.opy#L311).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [45](../src/global_start_menu.opy#L45), [46](../src/global_start_menu.opy#L46).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [217](../src/global_start_menu.opy#L217), [218](../src/global_start_menu.opy#L218), [220](../src/global_start_menu.opy#L220), [222](../src/global_start_menu.opy#L222).
- global_start_menu.opy — def determineZombieMode(): [269](../src/global_start_menu.opy#L269), [270](../src/global_start_menu.opy#L270), [271](../src/global_start_menu.opy#L271), [273](../src/global_start_menu.opy#L273), [275](../src/global_start_menu.opy#L275), [276](../src/global_start_menu.opy#L276), [277](../src/global_start_menu.opy#L277), [278](../src/global_start_menu.opy#L278), [281](../src/global_start_menu.opy#L281).
- global_start_menu.opy — def setZombieMode(): [309](../src/global_start_menu.opy#L309).
- global_start_menu.opy — def determineChallenge(): [330](../src/global_start_menu.opy#L330), [331](../src/global_start_menu.opy#L331), [332](../src/global_start_menu.opy#L332), [334](../src/global_start_menu.opy#L334), [338](../src/global_start_menu.opy#L338), [340](../src/global_start_menu.opy#L340), [344](../src/global_start_menu.opy#L344), [346](../src/global_start_menu.opy#L346), [347](../src/global_start_menu.opy#L347), [348](../src/global_start_menu.opy#L348), [350](../src/global_start_menu.opy#L350), [351](../src/global_start_menu.opy#L351).
- global_start_menu.opy — def determineObjectiveType(): [363](../src/global_start_menu.opy#L363), [364](../src/global_start_menu.opy#L364), [365](../src/global_start_menu.opy#L365), [367](../src/global_start_menu.opy#L367), [369](../src/global_start_menu.opy#L369), [370](../src/global_start_menu.opy#L370), [371](../src/global_start_menu.opy#L371), [372](../src/global_start_menu.opy#L372), [375](../src/global_start_menu.opy#L375).
- player_start_menu.opy — def randomActions(): [238](../src/player_start_menu.opy#L238), [240](../src/player_start_menu.opy#L240), [242](../src/player_start_menu.opy#L242), [244](../src/player_start_menu.opy#L244), [250](../src/player_start_menu.opy#L250), [252](../src/player_start_menu.opy#L252), [254](../src/player_start_menu.opy#L254), [256](../src/player_start_menu.opy#L256).
- objective_types/objective_type_biomorphing.opy — macro biowasteOutputMacro(): [7](../src/objective_types/objective_type_biomorphing.opy#L7).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [15](../src/objective_types/objective_type_biomorphing.opy#L15), [17](../src/objective_types/objective_type_biomorphing.opy#L17), [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [82](../src/objective_types/objective_type_biomorphing.opy#L82), [86](../src/objective_types/objective_type_biomorphing.opy#L86), [89](../src/objective_types/objective_type_biomorphing.opy#L89), [92](../src/objective_types/objective_type_biomorphing.opy#L92), [94](../src/objective_types/objective_type_biomorphing.opy#L94).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [114](../src/objective_types/objective_type_biomorphing.opy#L114), [116](../src/objective_types/objective_type_biomorphing.opy#L116).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [145](../src/objective_types/objective_type_biomorphing.opy#L145), [149](../src/objective_types/objective_type_biomorphing.opy#L149), [155](../src/objective_types/objective_type_biomorphing.opy#L155).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [187](../src/objective_types/objective_type_biomorphing.opy#L187).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [57](../src/objective_types/objective_type_survivor_rescue.opy#L57), [59](../src/objective_types/objective_type_survivor_rescue.opy#L59).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [132](../src/objective_types/objective_type_survivor_rescue.opy#L132), [133](../src/objective_types/objective_type_survivor_rescue.opy#L133).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [13](../src/objective_types/objective_type_satellite_uplink.opy#L13), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14), [34](../src/objective_types/objective_type_satellite_uplink.opy#L34), [35](../src/objective_types/objective_type_satellite_uplink.opy#L35), [50](../src/objective_types/objective_type_satellite_uplink.opy#L50), [51](../src/objective_types/objective_type_satellite_uplink.opy#L51), [52](../src/objective_types/objective_type_satellite_uplink.opy#L52), [54](../src/objective_types/objective_type_satellite_uplink.opy#L54), [56](../src/objective_types/objective_type_satellite_uplink.opy#L56).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [75](../src/objective_types/objective_type_satellite_uplink.opy#L75), [77](../src/objective_types/objective_type_satellite_uplink.opy#L77), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [84](../src/objective_types/objective_type_satellite_uplink.opy#L84), [86](../src/objective_types/objective_type_satellite_uplink.opy#L86).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [123](../src/objective_types/objective_type_satellite_uplink.opy#L123), [124](../src/objective_types/objective_type_satellite_uplink.opy#L124), [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126), [128](../src/objective_types/objective_type_satellite_uplink.opy#L128), [130](../src/objective_types/objective_type_satellite_uplink.opy#L130), [132](../src/objective_types/objective_type_satellite_uplink.opy#L132), [133](../src/objective_types/objective_type_satellite_uplink.opy#L133), [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136).
- bots_game_in_progress.opy — rule "BOT DIES": [129](../src/bots_game_in_progress.opy#L129), [130](../src/bots_game_in_progress.opy#L130).
- bots_game_in_progress.opy — def teleportBots(): [458](../src/bots_game_in_progress.opy#L458), [461](../src/bots_game_in_progress.opy#L461), [463](../src/bots_game_in_progress.opy#L463), [464](../src/bots_game_in_progress.opy#L464).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [492](../src/bots_game_in_progress.opy#L492), [493](../src/bots_game_in_progress.opy#L493), [496](../src/bots_game_in_progress.opy#L496), [497](../src/bots_game_in_progress.opy#L497), [498](../src/bots_game_in_progress.opy#L498).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)": [48](../src/zombie_types.opy#L48), [49](../src/zombie_types.opy#L49).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)": [236](../src/zombie_types.opy#L236), [237](../src/zombie_types.opy#L237), [238](../src/zombie_types.opy#L238), [239](../src/zombie_types.opy#L239).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [418](../src/zombie_types.opy#L418), [419](../src/zombie_types.opy#L419).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)": [675](../src/zombie_types.opy#L675), [676](../src/zombie_types.opy#L676).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1289](../src/zombie_types.opy#L1289), [1290](../src/zombie_types.opy#L1290).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35), [37](../src/supply_drops.opy#L37).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [91](../src/supply_drops.opy#L91), [96](../src/supply_drops.opy#L96), [97](../src/supply_drops.opy#L97).
- supply_drops.opy — def playerForceField(): [152](../src/supply_drops.opy#L152), [153](../src/supply_drops.opy#L153), [154](../src/supply_drops.opy#L154).
- supply_drops.opy — def airStrike(): [207](../src/supply_drops.opy#L207), [210](../src/supply_drops.opy#L210), [211](../src/supply_drops.opy#L211), [212](../src/supply_drops.opy#L212), [213](../src/supply_drops.opy#L213), [214](../src/supply_drops.opy#L214), [216](../src/supply_drops.opy#L216).
- supply_drops.opy — def sentryTurret(): [262](../src/supply_drops.opy#L262), [263](../src/supply_drops.opy#L263), [264](../src/supply_drops.opy#L264), [276](../src/supply_drops.opy#L276), [279](../src/supply_drops.opy#L279), [280](../src/supply_drops.opy#L280), [283](../src/supply_drops.opy#L283), [284](../src/supply_drops.opy#L284).
- supply_drops.opy — def bouncePad(): [377](../src/supply_drops.opy#L377), [378](../src/supply_drops.opy#L378), [381](../src/supply_drops.opy#L381), [384](../src/supply_drops.opy#L384), [386](../src/supply_drops.opy#L386).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [30](../src/power_ups.opy#L30), [32](../src/power_ups.opy#L32), [47](../src/power_ups.opy#L47), [63](../src/power_ups.opy#L63), [66](../src/power_ups.opy#L66), [67](../src/power_ups.opy#L67), [68](../src/power_ups.opy#L68).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES": [238](../src/enhancements.opy#L238), [240](../src/enhancements.opy#L240).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [298](../src/enhancements.opy#L298), [299](../src/enhancements.opy#L299), [301](../src/enhancements.opy#L301), [302](../src/enhancements.opy#L302), [305](../src/enhancements.opy#L305), [306](../src/enhancements.opy#L306).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [421](../src/enhancements.opy#L421), [422](../src/enhancements.opy#L422), [423](../src/enhancements.opy#L423), [424](../src/enhancements.opy#L424), [425](../src/enhancements.opy#L425).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH": [446](../src/enhancements.opy#L446), [448](../src/enhancements.opy#L448), [450](../src/enhancements.opy#L450), [452](../src/enhancements.opy#L452), [454](../src/enhancements.opy#L454), [456](../src/enhancements.opy#L456).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [496](../src/enhancements.opy#L496), [501](../src/enhancements.opy#L501), [502](../src/enhancements.opy#L502).

## tmp1

Объявление: [variables.opy:67](../src/variables.opy#L67). Строк обращений: 56; упоминаний: 62; чтений вида Global в скомпилированном коде: 37.

- subroutines.opy — def selectTarget(): [653](../src/subroutines.opy#L653), [656](../src/subroutines.opy#L656), [658](../src/subroutines.opy#L658), [662](../src/subroutines.opy#L662), [664](../src/subroutines.opy#L664), [666](../src/subroutines.opy#L666), [668](../src/subroutines.opy#L668), [670](../src/subroutines.opy#L670), [672](../src/subroutines.opy#L672), [673](../src/subroutines.opy#L673).
- global_startup.opy — macro botHeroRandomizationMacro(): [60](../src/global_startup.opy#L60), [63](../src/global_startup.opy#L63), [67](../src/global_startup.opy#L67).
- global_start_menu.opy — def determineChallenge(): [336](../src/global_start_menu.opy#L336), [340](../src/global_start_menu.opy#L340), [342](../src/global_start_menu.opy#L342), [350](../src/global_start_menu.opy#L350).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [16](../src/objective_types/objective_type_biomorphing.opy#L16), [17](../src/objective_types/objective_type_biomorphing.opy#L17), [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [84](../src/objective_types/objective_type_biomorphing.opy#L84), [86](../src/objective_types/objective_type_biomorphing.opy#L86), [87](../src/objective_types/objective_type_biomorphing.opy#L87), [89](../src/objective_types/objective_type_biomorphing.opy#L89).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [116](../src/objective_types/objective_type_biomorphing.opy#L116), [117](../src/objective_types/objective_type_biomorphing.opy#L117), [118](../src/objective_types/objective_type_biomorphing.opy#L118), [119](../src/objective_types/objective_type_biomorphing.opy#L119), [120](../src/objective_types/objective_type_biomorphing.opy#L120), [121](../src/objective_types/objective_type_biomorphing.opy#L121), [122](../src/objective_types/objective_type_biomorphing.opy#L122), [123](../src/objective_types/objective_type_biomorphing.opy#L123).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [189](../src/objective_types/objective_type_biomorphing.opy#L189).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [80](../src/objective_types/objective_type_satellite_uplink.opy#L80), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [37](../src/supply_drops.opy#L37), [38](../src/supply_drops.opy#L38), [40](../src/supply_drops.opy#L40).
- supply_drops.opy — def airStrike(): [216](../src/supply_drops.opy#L216), [217](../src/supply_drops.opy#L217), [218](../src/supply_drops.opy#L218).
- supply_drops.opy — def bouncePad(): [381](../src/supply_drops.opy#L381), [384](../src/supply_drops.opy#L384).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [28](../src/power_ups.opy#L28), [66](../src/power_ups.opy#L66), [67](../src/power_ups.opy#L67), [68](../src/power_ups.opy#L68).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES": [236](../src/enhancements.opy#L236), [248](../src/enhancements.opy#L248), [251](../src/enhancements.opy#L251).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [301](../src/enhancements.opy#L301), [304](../src/enhancements.opy#L304), [305](../src/enhancements.opy#L305).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [498](../src/enhancements.opy#L498), [500](../src/enhancements.opy#L500), [501](../src/enhancements.opy#L501).

## tmp2

Объявление: [variables.opy:68](../src/variables.opy#L68). Строк обращений: 23; упоминаний: 33; чтений вида Global в скомпилированном коде: 23.

- subroutines.opy — macro mutationsMacro(): [85](../src/subroutines.opy#L85), [91](../src/subroutines.opy#L91), [97](../src/subroutines.opy#L97), [102](../src/subroutines.opy#L102), [113](../src/subroutines.opy#L113), [116](../src/subroutines.opy#L116).
- global_startup.opy — macro botHeroRandomizationMacro(): [62](../src/global_startup.opy#L62), [63](../src/global_startup.opy#L63), [65](../src/global_startup.opy#L65), [67](../src/global_startup.opy#L67), [68](../src/global_startup.opy#L68).
- supply_drops.opy — def bouncePad(): [384](../src/supply_drops.opy#L384), [385](../src/supply_drops.opy#L385).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES": [240](../src/enhancements.opy#L240), [241](../src/enhancements.opy#L241), [243](../src/enhancements.opy#L243), [244](../src/enhancements.opy#L244), [245](../src/enhancements.opy#L245), [246](../src/enhancements.opy#L246), [248](../src/enhancements.opy#L248), [251](../src/enhancements.opy#L251).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [500](../src/enhancements.opy#L500), [502](../src/enhancements.opy#L502).

## phaseSlot0

Объявление: [variables.opy:73](../src/variables.opy#L73). Строк обращений: 11; упоминаний: 11; чтений вида Global в скомпилированном коде: 9.

Алиасы ролей: `startMenuZombieColorList`, `objectiveVisualCleanupIndex`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [223](../src/subroutines.opy#L223), [224](../src/subroutines.opy#L224), [225](../src/subroutines.opy#L225), [226](../src/subroutines.opy#L226), [227](../src/subroutines.opy#L227), [228](../src/subroutines.opy#L228), [229](../src/subroutines.opy#L229).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [107](../src/global_start_menu.opy#L107), [131](../src/global_start_menu.opy#L131), [132](../src/global_start_menu.opy#L132), [133](../src/global_start_menu.opy#L133).

## phaseSlot1

Объявление: [variables.opy:77](../src/variables.opy#L77). Строк обращений: 14; упоминаний: 14; чтений вида Global в скомпилированном коде: 7.

Алиасы ролей: `startMenuObjectiveColorList`, `missionPlacementAttemptCount`, `biomorphingCleanupIndex`, `satelliteFiringStepsRemaining`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [137](../src/global_start_menu.opy#L137), [167](../src/global_start_menu.opy#L167), [168](../src/global_start_menu.opy#L168), [169](../src/global_start_menu.opy#L169).
- global_start_menu.opy — def setObjectiveType(): [399](../src/global_start_menu.opy#L399), [410](../src/global_start_menu.opy#L410), [411](../src/global_start_menu.opy#L411), [413](../src/global_start_menu.opy#L413), [416](../src/global_start_menu.opy#L416).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [31](../src/objective_types/objective_type_biomorphing.opy#L31), [32](../src/objective_types/objective_type_biomorphing.opy#L32), [33](../src/objective_types/objective_type_biomorphing.opy#L33).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [42](../src/objective_types/objective_type_satellite_uplink.opy#L42), [57](../src/objective_types/objective_type_satellite_uplink.opy#L57).

## phaseSlot2

Объявление: [variables.opy:84](../src/variables.opy#L84). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 5.

Алиасы ролей: `startMenuEnhancementColorList`, `rescueMinSpawnDistance`, `satelliteMinTerminalSpacing`.

- subroutines.opy — def objectivesManagement(): [641](../src/subroutines.opy#L641).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [173](../src/global_start_menu.opy#L173), [205](../src/global_start_menu.opy#L205), [206](../src/global_start_menu.opy#L206), [207](../src/global_start_menu.opy#L207).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [13](../src/objective_types/objective_type_survivor_rescue.opy#L13), [15](../src/objective_types/objective_type_survivor_rescue.opy#L15), [16](../src/objective_types/objective_type_survivor_rescue.opy#L16).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [90](../src/objective_types/objective_type_satellite_uplink.opy#L90).

## phaseSlot3

Объявление: [variables.opy:90](../src/variables.opy#L90). Строк обращений: 19; упоминаний: 24; чтений вида Global в скомпилированном коде: 20.

Алиасы ролей: `challengeVoteList`, `biomorphingResourceNameList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [298](../src/subroutines.opy#L298).
- subroutines.opy — def objectivesManagement(): [610](../src/subroutines.opy#L610).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [146](../src/global_startup.opy#L146).
- global_start_menu.opy — def determineChallenge(): [330](../src/global_start_menu.opy#L330), [331](../src/global_start_menu.opy#L331), [332](../src/global_start_menu.opy#L332), [334](../src/global_start_menu.opy#L334), [338](../src/global_start_menu.opy#L338), [340](../src/global_start_menu.opy#L340), [344](../src/global_start_menu.opy#L344), [346](../src/global_start_menu.opy#L346), [348](../src/global_start_menu.opy#L348).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)": [136](../src/player_start_menu.opy#L136), [137](../src/player_start_menu.opy#L137), [138](../src/player_start_menu.opy#L138), [140](../src/player_start_menu.opy#L140), [141](../src/player_start_menu.opy#L141), [142](../src/player_start_menu.opy#L142).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [19](../src/objective_types/objective_type_biomorphing.opy#L19).

## phaseSlot4

Объявление: [variables.opy:94](../src/variables.opy#L94). Строк обращений: 29; упоминаний: 33; чтений вида Global в скомпилированном коде: 23.

Алиасы ролей: `objectiveTypeVoteList`, `biomorphingResourceColorList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [298](../src/subroutines.opy#L298), [307](../src/subroutines.opy#L307), [310](../src/subroutines.opy#L310).
- subroutines.opy — def objectivesManagement(): [609](../src/subroutines.opy#L609).
- global_startup.opy — macro setAvailableObjectivesMacro(): [7](../src/global_startup.opy#L7), [9](../src/global_startup.opy#L9), [11](../src/global_startup.opy#L11), [13](../src/global_startup.opy#L13), [15](../src/global_startup.opy#L15), [17](../src/global_startup.opy#L17), [19](../src/global_startup.opy#L19).
- global_start_menu.opy — def determineObjectiveType(): [363](../src/global_start_menu.opy#L363), [364](../src/global_start_menu.opy#L364), [365](../src/global_start_menu.opy#L365), [367](../src/global_start_menu.opy#L367), [369](../src/global_start_menu.opy#L369), [370](../src/global_start_menu.opy#L370), [372](../src/global_start_menu.opy#L372), [378](../src/global_start_menu.opy#L378), [381](../src/global_start_menu.opy#L381), [382](../src/global_start_menu.opy#L382).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)": [176](../src/player_start_menu.opy#L176), [177](../src/player_start_menu.opy#L177), [178](../src/player_start_menu.opy#L178), [180](../src/player_start_menu.opy#L180), [181](../src/player_start_menu.opy#L181), [182](../src/player_start_menu.opy#L182).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [17](../src/objective_types/objective_type_biomorphing.opy#L17).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).

## phaseSlot5

Объявление: [variables.opy:98](../src/variables.opy#L98). Строк обращений: 19; упоминаний: 23; чтений вида Global в скомпилированном коде: 17.

Алиасы ролей: `zombieVoteList`, `biomorphingQueuedTypeList`.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [148](../src/global_startup.opy#L148).
- global_start_menu.opy — def determineZombieMode(): [269](../src/global_start_menu.opy#L269), [270](../src/global_start_menu.opy#L270), [271](../src/global_start_menu.opy#L271), [273](../src/global_start_menu.opy#L273), [275](../src/global_start_menu.opy#L275), [276](../src/global_start_menu.opy#L276), [278](../src/global_start_menu.opy#L278).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)": [156](../src/player_start_menu.opy#L156), [157](../src/player_start_menu.opy#L157), [158](../src/player_start_menu.opy#L158), [160](../src/player_start_menu.opy#L160), [161](../src/player_start_menu.opy#L161), [162](../src/player_start_menu.opy#L162).
- objective_types/objective_type_biomorphing.opy — macro biowasteOutputMacro(): [7](../src/objective_types/objective_type_biomorphing.opy#L7), [8](../src/objective_types/objective_type_biomorphing.opy#L8), [9](../src/objective_types/objective_type_biomorphing.opy#L9), [10](../src/objective_types/objective_type_biomorphing.opy#L10).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [35](../src/objective_types/objective_type_biomorphing.opy#L35).

## phaseSlot6

Объявление: [variables.opy:102](../src/variables.opy#L102). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 3.

Алиасы ролей: `pregameGlitchText`, `extractionFlightDestination`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [87](../src/global_start_menu.opy#L87), [88](../src/global_start_menu.opy#L88).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [219](../src/global_start_menu.opy#L219), [221](../src/global_start_menu.opy#L221), [223](../src/global_start_menu.opy#L223).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [63](../src/objective_types/objective_type_extraction_point.opy#L63).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [111](../src/objective_types/objective_type_extraction_point.opy#L111).

## phaseSlot7

Объявление: [variables.opy:106](../src/variables.opy#L106). Строк обращений: 15; упоминаний: 16; чтений вида Global в скомпилированном коде: 10.

Алиасы ролей: `isPregameGlitchActive`, `extractionFlightSpeed`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [87](../src/global_start_menu.opy#L87), [88](../src/global_start_menu.opy#L88), [101](../src/global_start_menu.opy#L101).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [224](../src/global_start_menu.opy#L224), [226](../src/global_start_menu.opy#L226).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [57](../src/objective_types/objective_type_extraction_point.opy#L57), [59](../src/objective_types/objective_type_extraction_point.opy#L59), [61](../src/objective_types/objective_type_extraction_point.opy#L61), [62](../src/objective_types/objective_type_extraction_point.opy#L62), [64](../src/objective_types/objective_type_extraction_point.opy#L64), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [112](../src/objective_types/objective_type_extraction_point.opy#L112), [116](../src/objective_types/objective_type_extraction_point.opy#L116), [118](../src/objective_types/objective_type_extraction_point.opy#L118), [121](../src/objective_types/objective_type_extraction_point.opy#L121).

## phaseSlot8

Объявление: [variables.opy:110](../src/variables.opy#L110). Строк обращений: 5; упоминаний: 7; чтений вида Global в скомпилированном коде: 4.

Алиасы ролей: `mixedObjectiveTypeList`, `finaleExplosionIndex`.

- global_startup.opy — macro setAvailableObjectivesMacro(): [21](../src/global_startup.opy#L21), [31](../src/global_startup.opy#L31).
- global_start_menu.opy — def setObjectiveType(): [398](../src/global_start_menu.opy#L398).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [147](../src/objective_types/objective_type_extraction_point.opy#L147), [149](../src/objective_types/objective_type_extraction_point.opy#L149).

## phaseSlot9

Объявление: [variables.opy:114](../src/variables.opy#L114). Строк обращений: 15; упоминаний: 17; чтений вида Global в скомпилированном коде: 10.

Алиасы ролей: `enhancementOptionList`, `biomorphingGoalText`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [295](../src/subroutines.opy#L295).
- global_startup.opy — macro enableEnhancementsMacro(): [35](../src/global_startup.opy#L35).
- global_startup.opy — rule "START GAME": [287](../src/global_startup.opy#L287).
- player_start_menu.opy — rule "EFFECTS/TEXT": [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)": [193](../src/player_start_menu.opy#L193), [194](../src/player_start_menu.opy#L194), [195](../src/player_start_menu.opy#L195), [197](../src/player_start_menu.opy#L197), [198](../src/player_start_menu.opy#L198), [199](../src/player_start_menu.opy#L199).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [46](../src/objective_types/objective_type_biomorphing.opy#L46), [53](../src/objective_types/objective_type_biomorphing.opy#L53), [56](../src/objective_types/objective_type_biomorphing.opy#L56), [59](../src/objective_types/objective_type_biomorphing.opy#L59), [62](../src/objective_types/objective_type_biomorphing.opy#L62).

## phaseSlot10

Объявление: [variables.opy:118](../src/variables.opy#L118). Строк обращений: 12; упоминаний: 13; чтений вида Global в скомпилированном коде: 6.

Алиасы ролей: `startMenuSpacingAngle`, `biomorphingGoalColor`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [295](../src/subroutines.opy#L295).
- global_startup.opy — rule "START GAME": [289](../src/global_startup.opy#L289).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [53](../src/global_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [10](../src/player_start_menu.opy#L10), [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [60](../src/player_start_menu.opy#L60).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [45](../src/objective_types/objective_type_biomorphing.opy#L45), [54](../src/objective_types/objective_type_biomorphing.opy#L54), [57](../src/objective_types/objective_type_biomorphing.opy#L57), [60](../src/objective_types/objective_type_biomorphing.opy#L60), [64](../src/objective_types/objective_type_biomorphing.opy#L64), [68](../src/objective_types/objective_type_biomorphing.opy#L68).

## offsetUpThreeQuartersConst

Объявление: [variables.opy:125](../src/variables.opy#L125). Строк обращений: 4; упоминаний: 7; чтений вида Global в скомпилированном коде: 7.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [41](../src/global_start_menu.opy#L41).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS": [336](../src/bots_game_in_progress.opy#L336).

## offsetUpHalfConst

Объявление: [variables.opy:126](../src/variables.opy#L126). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 7.

- subroutines.opy — macro botEntityManagementMacro(): [159](../src/subroutines.opy#L159).
- player_start_menu.opy — rule "EFFECTS/TEXT": [45](../src/player_start_menu.opy#L45).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [16](../src/global_game_in_progress.opy#L16).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [596](../src/zombie_types.opy#L596), [609](../src/zombie_types.opy#L609), [618](../src/zombie_types.opy#L618).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [70](../src/supply_drops.opy#L70).

## losOffsetConst

Объявление: [variables.opy:127](../src/variables.opy#L127). Строк обращений: 12; упоминаний: 16; чтений вида Global в скомпилированном коде: 16.

- subroutines.opy — def selectTarget(): [674](../src/subroutines.opy#L674).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG": [190](../src/bots_game_in_progress.opy#L190).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE": [241](../src/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET": [267](../src/bots_game_in_progress.opy#L267).
- bots_game_in_progress.opy — def teleportBots(): [470](../src/bots_game_in_progress.opy#L470).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1286](../src/zombie_types.opy#L1286), [1287](../src/zombie_types.opy#L1287).
- zombie_types.opy — def entityFloat(): [1460](../src/zombie_types.opy#L1460).
- supply_drops.opy — def stun(): [415](../src/supply_drops.opy#L415), [419](../src/supply_drops.opy#L419), [424](../src/supply_drops.opy#L424), [431](../src/supply_drops.opy#L431).

## colorChargeBatteryConst

Объявление: [variables.opy:128](../src/variables.opy#L128). Строк обращений: 2; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [173](../src/global_start_menu.opy#L173).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [99](../src/enhancements.opy#L99).

## dummyHoldingPositionConst

Объявление: [variables.opy:129](../src/variables.opy#L129). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 6.

- global_startup.opy — macro botHeroRandomizationMacro(): [54](../src/global_startup.opy#L54), [68](../src/global_startup.opy#L68), [70](../src/global_startup.opy#L70).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [16](../src/objective_types/objective_type_bosses.opy#L16).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [24](../src/objective_types/objective_type_zombie_egg.opy#L24).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [68](../src/objective_types/objective_type_zombie_egg.opy#L68).

## colorKevlarConst

Объявление: [variables.opy:130](../src/variables.opy#L130). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 2.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [173](../src/global_start_menu.opy#L173).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [20](../src/enhancements.opy#L20).

## isPregameSetup

Объявление: [variables.opy:133](../src/variables.opy#L133). Строк обращений: 40; упоминаний: 41; чтений вида Global в скомпилированном коде: 39.

- subroutines.opy — def enableDisableAbilities(): [506](../src/subroutines.opy#L506).
- global_startup.opy — rule "PREGAME QUICK TIPS FOR PLAYERS": [85](../src/global_startup.opy#L85).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [140](../src/global_startup.opy#L140), [159](../src/global_startup.opy#L159).
- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [175](../src/global_startup.opy#L175), [197](../src/global_startup.opy#L197).
- global_startup.opy — rule "START GAME": [266](../src/global_startup.opy#L266), [277](../src/global_startup.opy#L277).
- global_startup.opy — def generateMapGrid(): [312](../src/global_startup.opy#L312).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [10](../src/global_start_menu.opy#L10), [52](../src/global_start_menu.opy#L52).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [213](../src/global_start_menu.opy#L213), [215](../src/global_start_menu.opy#L215).
- global_start_menu.opy — rule "END VOTING": [233](../src/global_start_menu.opy#L233).
- global_start_menu.opy — rule "MUSIC/ANNOUNCER CONTROL": [250](../src/global_start_menu.opy#L250), [255](../src/global_start_menu.opy#L255), [259](../src/global_start_menu.opy#L259).
- global_start_menu.opy — def setObjectiveType(): [391](../src/global_start_menu.opy#L391).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [9](../src/player_start_menu.opy#L9).
- player_start_menu.opy — rule "EFFECTS/TEXT": [35](../src/player_start_menu.opy#L35).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [59](../src/player_start_menu.opy#L59).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)": [97](../src/player_start_menu.opy#L97).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)": [129](../src/player_start_menu.opy#L129).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)": [149](../src/player_start_menu.opy#L149).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)": [169](../src/player_start_menu.opy#L169).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)": [188](../src/player_start_menu.opy#L188).
- player_start_menu.opy — rule "UPDATE PREGAME VOTING STATUS": [205](../src/player_start_menu.opy#L205).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY": [220](../src/player_start_menu.opy#L220).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [6](../src/global_game_in_progress.opy#L6).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [22](../src/global_game_in_progress.opy#L22).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [99](../src/global_game_in_progress.opy#L99).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [35](../src/players_game_in_progress.opy#L35).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS": [109](../src/players_game_in_progress.opy#L109).
- players_game_in_progress.opy — rule "PLAYER AFK": [257](../src/players_game_in_progress.opy#L257).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [62](../src/bots_game_in_progress.opy#L62).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS": [221](../src/bots_game_in_progress.opy#L221).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE": [235](../src/bots_game_in_progress.opy#L235).
- bots_game_in_progress.opy — rule "BOT WANDERS": [289](../src/bots_game_in_progress.opy#L289).
- bots_game_in_progress.opy — rule "BOTS JUMP": [301](../src/bots_game_in_progress.opy#L301).
- debug.opy — rule "[debug] Resource usage and server load": [32](../src/debug.opy#L32).

## isSpecialGameMode

Объявление: [variables.opy:134](../src/variables.opy#L134). Строк обращений: 11; упоминаний: 11; чтений вида Global в скомпилированном коде: 10.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [161](../src/global_startup.opy#L161).
- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [177](../src/global_startup.opy#L177).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [215](../src/global_startup.opy#L215).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [14](../src/global_start_menu.opy#L14).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [27](../src/player_start_menu.opy#L27).
- player_start_menu.opy — rule "EFFECTS/TEXT": [38](../src/player_start_menu.opy#L38).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [72](../src/player_start_menu.opy#L72).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY": [226](../src/player_start_menu.opy#L226).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [24](../src/global_game_in_progress.opy#L24).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [57](../src/global_game_in_progress.opy#L57).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [89](../src/players_game_in_progress.opy#L89).

## isGameplayActive

Объявление: [variables.opy:135](../src/variables.opy#L135). Строк обращений: 40; упоминаний: 41; чтений вида Global в скомпилированном коде: 39.

- subroutines.opy — def objectivesManagement(): [527](../src/subroutines.opy#L527).
- global_startup.opy — rule "SPAWN BOTS": [93](../src/global_startup.opy#L93).
- global_start_menu.opy — def setObjectiveType(): [420](../src/global_start_menu.opy#L420).
- global_game_in_progress.opy — rule "PREVENT MATCH TIME FROM UNPAUSING": [40](../src/global_game_in_progress.opy#L40).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [51](../src/global_game_in_progress.opy#L51).
- global_game_in_progress.opy — rule "ZOMBIE SHUFFLE": [66](../src/global_game_in_progress.opy#L66).
- global_game_in_progress.opy — rule "OBJECTIVE COMPLETE": [129](../src/global_game_in_progress.opy#L129).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [10](../src/objective_types/objective_type_extraction_point.opy#L10), [23](../src/objective_types/objective_type_extraction_point.opy#L23).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE": [30](../src/objective_types/objective_type_extraction_point.opy#L30).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [70](../src/objective_types/objective_type_extraction_point.opy#L70), [76](../src/objective_types/objective_type_extraction_point.opy#L76).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [27](../src/objective_types/objective_type_biomorphing.opy#L27).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [75](../src/objective_types/objective_type_biomorphing.opy#L75).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [103](../src/objective_types/objective_type_biomorphing.opy#L103).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [6](../src/objective_types/objective_type_survivor_rescue.opy#L6).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [69](../src/objective_types/objective_type_satellite_uplink.opy#L69).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [148](../src/players_game_in_progress.opy#L148).
- players_game_in_progress.opy — rule "PLAYER SWITCHES HERO": [291](../src/players_game_in_progress.opy#L291).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [319](../src/players_game_in_progress.opy#L319).
- players_game_in_progress.opy — rule "PLAYER TARGET (ADD)": [329](../src/players_game_in_progress.opy#L329).
- hero_tuning.opy — rule "DOOMFIST INVIS WHILE ULTING": [31](../src/hero_tuning.opy#L31).
- hero_tuning.opy — rule "MOIRA & VENTURE INVIS WHILE USING SKILL": [42](../src/hero_tuning.opy#L42).
- hero_tuning.opy — rule "TRACER INVIS WHILE RECALLING": [55](../src/hero_tuning.opy#L55).
- bots_game_in_progress.opy — rule "Fix bot health": [47](../src/bots_game_in_progress.opy#L47).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING": [94](../src/bots_game_in_progress.opy#L94).
- bots_game_in_progress.opy — rule "TELEPORT BOTS (GENERAL)": [171](../src/bots_game_in_progress.opy#L171).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG": [184](../src/bots_game_in_progress.opy#L184).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE": [527](../src/bots_game_in_progress.opy#L527).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [21](../src/supply_drops.opy#L21).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [57](../src/supply_drops.opy#L57).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [82](../src/supply_drops.opy#L82).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [13](../src/power_ups.opy#L13).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [24](../src/power_ups.opy#L24).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)": [77](../src/power_ups.opy#L77).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [8](../src/enhancements.opy#L8).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)": [181](../src/enhancements.opy#L181).
- enhancements.opy — rule "CHARGE BATTERY": [388](../src/enhancements.opy#L388).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [415](../src/enhancements.opy#L415).
- debug.opy — rule "[debug] Resource usage and server load": [32](../src/debug.opy#L32).

## isOvertimeActive

Объявление: [variables.opy:136](../src/variables.opy#L136). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 1.

- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [52](../src/global_game_in_progress.opy#L52), [58](../src/global_game_in_progress.opy#L58).

## isVoting

Объявление: [variables.opy:137](../src/variables.opy#L137). Строк обращений: 17; упоминаний: 19; чтений вида Global в скомпилированном коде: 17.

- subroutines.opy — def setPrematchTimer(): [477](../src/subroutines.opy#L477).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [143](../src/global_startup.opy#L143).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [55](../src/global_start_menu.opy#L55).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [60](../src/global_start_menu.opy#L60), [68](../src/global_start_menu.opy#L68), [98](../src/global_start_menu.opy#L98), [128](../src/global_start_menu.opy#L128), [164](../src/global_start_menu.opy#L164).
- global_start_menu.opy — rule "END VOTING": [232](../src/global_start_menu.opy#L232), [240](../src/global_start_menu.opy#L240).
- global_start_menu.opy — rule "MUSIC/ANNOUNCER CONTROL": [249](../src/global_start_menu.opy#L249).
- global_start_menu.opy — def determineObjectiveType(): [383](../src/global_start_menu.opy#L383).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [16](../src/player_start_menu.opy#L16).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [88](../src/player_start_menu.opy#L88).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)": [128](../src/player_start_menu.opy#L128).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)": [148](../src/player_start_menu.opy#L148).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)": [168](../src/player_start_menu.opy#L168).

## difficultySetting

Объявление: [variables.opy:138](../src/variables.opy#L138). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 10.

- subroutines.opy — def setDifficulty(): [400](../src/subroutines.opy#L400), [427](../src/subroutines.opy#L427), [437](../src/subroutines.opy#L437), [449](../src/subroutines.opy#L449).
- subroutines.opy — def botRespawnInitialization(): [727](../src/subroutines.opy#L727).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [151](../src/global_startup.opy#L151).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [23](../src/player_start_menu.opy#L23).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [71](../src/objective_types/objective_type_showdown.opy#L71).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [212](../src/players_game_in_progress.opy#L212).
- bots_game_in_progress.opy — rule "BOT DIES": [130](../src/bots_game_in_progress.opy#L130), [131](../src/bots_game_in_progress.opy#L131).

## challengeSetting

Объявление: [variables.opy:139](../src/variables.opy#L139). Строк обращений: 15; упоминаний: 18; чтений вида Global в скомпилированном коде: 14.

- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78).
- subroutines.opy — def setDifficulty(): [402](../src/subroutines.opy#L402).
- global_start_menu.opy — rule "END VOTING": [241](../src/global_start_menu.opy#L241).
- global_start_menu.opy — def determineChallenge(): [328](../src/global_start_menu.opy#L328), [346](../src/global_start_menu.opy#L346), [347](../src/global_start_menu.opy#L347), [348](../src/global_start_menu.opy#L348), [350](../src/global_start_menu.opy#L350), [351](../src/global_start_menu.opy#L351), [353](../src/global_start_menu.opy#L353), [354](../src/global_start_menu.opy#L354).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [18](../src/global_game_in_progress.opy#L18).
- global_game_in_progress.opy — rule "SWARM SHOOTOUT": [81](../src/global_game_in_progress.opy#L81).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [97](../src/global_game_in_progress.opy#L97).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED": [131](../src/players_game_in_progress.opy#L131).

## zombieSetting

Объявление: [variables.opy:140](../src/variables.opy#L140). Строк обращений: 20; упоминаний: 20; чтений вида Global в скомпилированном коде: 15.

- subroutines.opy — macro minibossMutationMacro(): [20](../src/subroutines.opy#L20).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [153](../src/global_startup.opy#L153).
- global_start_menu.opy — rule "END VOTING": [242](../src/global_start_menu.opy#L242).
- global_start_menu.opy — def determineZombieMode(): [267](../src/global_start_menu.opy#L267), [276](../src/global_start_menu.opy#L276), [277](../src/global_start_menu.opy#L277), [278](../src/global_start_menu.opy#L278), [280](../src/global_start_menu.opy#L280), [281](../src/global_start_menu.opy#L281), [283](../src/global_start_menu.opy#L283), [284](../src/global_start_menu.opy#L284).
- global_start_menu.opy — def setZombieMode(): [297](../src/global_start_menu.opy#L297), [301](../src/global_start_menu.opy#L301), [305](../src/global_start_menu.opy#L305), [312](../src/global_start_menu.opy#L312), [316](../src/global_start_menu.opy#L316), [320](../src/global_start_menu.opy#L320).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [24](../src/player_start_menu.opy#L24).
- global_game_in_progress.opy — rule "ZOMBIE SHUFFLE": [67](../src/global_game_in_progress.opy#L67).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [42](../src/objective_types/objective_type_bosses.opy#L42).

## objectiveTypeSetting

Объявление: [variables.opy:141](../src/variables.opy#L141). Строк обращений: 16; упоминаний: 17; чтений вида Global в скомпилированном коде: 11.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [284](../src/subroutines.opy#L284).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [155](../src/global_startup.opy#L155).
- global_start_menu.opy — rule "END VOTING": [243](../src/global_start_menu.opy#L243).
- global_start_menu.opy — def determineObjectiveType(): [361](../src/global_start_menu.opy#L361), [370](../src/global_start_menu.opy#L370), [371](../src/global_start_menu.opy#L371), [372](../src/global_start_menu.opy#L372), [374](../src/global_start_menu.opy#L374), [375](../src/global_start_menu.opy#L375), [377](../src/global_start_menu.opy#L377), [379](../src/global_start_menu.opy#L379), [381](../src/global_start_menu.opy#L381), [382](../src/global_start_menu.opy#L382).
- global_start_menu.opy — def setObjectiveType(): [394](../src/global_start_menu.opy#L394), [395](../src/global_start_menu.opy#L395).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [25](../src/player_start_menu.opy#L25).

## matchEndTime

Объявление: [variables.opy:142](../src/variables.opy#L142). Строк обращений: 12; упоминаний: 12; чтений вида Global в скомпилированном коде: 11.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [213](../src/global_startup.opy#L213).
- global_startup.opy — rule "START GAME": [291](../src/global_startup.opy#L291).
- global_startup.opy — def generateMapGrid(): [312](../src/global_startup.opy#L312).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [10](../src/global_game_in_progress.opy#L10), [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- global_game_in_progress.opy — rule "PREVENT MATCH TIME FROM UNPAUSING": [41](../src/global_game_in_progress.opy#L41), [44](../src/global_game_in_progress.opy#L44).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [53](../src/global_game_in_progress.opy#L53).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [212](../src/players_game_in_progress.opy#L212).
- bots_game_in_progress.opy — rule "BOT DIES": [150](../src/bots_game_in_progress.opy#L150).

## uniqueSkinCap

Объявление: [variables.opy:143](../src/variables.opy#L143). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — macro botHeroRandomizationMacro(): [56](../src/global_startup.opy#L56).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [260](../src/global_startup.opy#L260).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [12](../src/objective_types/objective_type_bosses.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [9](../src/objective_types/objective_type_zombie_egg.opy#L9).

## numberOfBots

Объявление: [variables.opy:144](../src/variables.opy#L144). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "SPAWN BOTS": [97](../src/global_startup.opy#L97).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [262](../src/global_startup.opy#L262).
- bots_game_in_progress.opy — rule "BOT DIES": [151](../src/bots_game_in_progress.opy#L151).

## walkCenter

Объявление: [variables.opy:147](../src/variables.opy#L147). Строк обращений: 10; упоминаний: 11; чтений вида Global в скомпилированном коде: 8.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [221](../src/global_startup.opy#L221), [223](../src/global_startup.opy#L223), [226](../src/global_startup.opy#L226).
- global_startup.opy — rule "START GAME": [276](../src/global_startup.opy#L276).
- global_startup.opy — def generateMapGrid(): [307](../src/global_startup.opy#L307).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [16](../src/global_start_menu.opy#L16), [18](../src/global_start_menu.opy#L18), [20](../src/global_start_menu.opy#L20), [21](../src/global_start_menu.opy#L21).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [91](../src/players_game_in_progress.opy#L91).

## mapGridList

Объявление: [variables.opy:148](../src/variables.opy#L148). Строк обращений: 20; упоминаний: 25; чтений вида Global в скомпилированном коде: 23.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [165](../src/global_startup.opy#L165).
- global_startup.opy — def generateMapGrid(): [304](../src/global_startup.opy#L304), [305](../src/global_startup.opy#L305), [307](../src/global_startup.opy#L307), [310](../src/global_startup.opy#L310), [311](../src/global_startup.opy#L311), [316](../src/global_startup.opy#L316).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [11](../src/global_start_menu.opy#L11).
- global_start_menu.opy — def setObjectiveType(): [402](../src/global_start_menu.opy#L402).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [97](../src/objective_types/objective_type_extraction_point.opy#L97).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [141](../src/objective_types/objective_type_extraction_point.opy#L141), [143](../src/objective_types/objective_type_extraction_point.opy#L143), [144](../src/objective_types/objective_type_extraction_point.opy#L144), [149](../src/objective_types/objective_type_extraction_point.opy#L149).
- objective_types/objective_type_bosses.opy — def bossReturn(): [206](../src/objective_types/objective_type_bosses.opy#L206).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [15](../src/objective_types/objective_type_survivor_rescue.opy#L15).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [75](../src/objective_types/objective_type_satellite_uplink.opy#L75).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [91](../src/players_game_in_progress.opy#L91).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [419](../src/zombie_types.opy#L419).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [37](../src/supply_drops.opy#L37).

## attackSpawnRooms

Объявление: [variables.opy:149](../src/variables.opy#L149). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [181](../src/global_startup.opy#L181), [184](../src/global_startup.opy#L184), [190](../src/global_startup.opy#L190), [193](../src/global_startup.opy#L193), [205](../src/global_startup.opy#L205).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [210](../src/global_startup.opy#L210).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [28](../src/global_game_in_progress.opy#L28), [31](../src/global_game_in_progress.opy#L31), [32](../src/global_game_in_progress.opy#L32).

## activeAttackSpawnRoom

Объявление: [variables.opy:150](../src/variables.opy#L150). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 1.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [205](../src/global_startup.opy#L205).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [25](../src/global_game_in_progress.opy#L25), [32](../src/global_game_in_progress.opy#L32).

## spawnRoomIndex

Объявление: [variables.opy:151](../src/variables.opy#L151). Строк обращений: 14; упоминаний: 15; чтений вида Global в скомпилированном коде: 9.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [182](../src/global_startup.opy#L182), [185](../src/global_startup.opy#L185), [191](../src/global_startup.opy#L191), [198](../src/global_startup.opy#L198), [199](../src/global_startup.opy#L199), [200](../src/global_startup.opy#L200), [202](../src/global_startup.opy#L202), [205](../src/global_startup.opy#L205).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [27](../src/global_game_in_progress.opy#L27), [28](../src/global_game_in_progress.opy#L28), [29](../src/global_game_in_progress.opy#L29), [31](../src/global_game_in_progress.opy#L31), [32](../src/global_game_in_progress.opy#L32), [33](../src/global_game_in_progress.opy#L33).

## botSpawnPointList

Объявление: [variables.opy:152](../src/variables.opy#L152). Строк обращений: 17; упоминаний: 17; чтений вида Global в скомпилированном коде: 13.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [230](../src/global_startup.opy#L230).
- bots_game_in_progress.opy — def enterExitTeleport(): [432](../src/bots_game_in_progress.opy#L432), [433](../src/bots_game_in_progress.opy#L433).
- bots_game_in_progress.opy — def teleportBots(): [458](../src/bots_game_in_progress.opy#L458), [461](../src/bots_game_in_progress.opy#L461), [463](../src/bots_game_in_progress.opy#L463), [465](../src/bots_game_in_progress.opy#L465), [474](../src/bots_game_in_progress.opy#L474), [475](../src/bots_game_in_progress.opy#L475), [476](../src/bots_game_in_progress.opy#L476), [477](../src/bots_game_in_progress.opy#L477).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [512](../src/bots_game_in_progress.opy#L512), [513](../src/bots_game_in_progress.opy#L513), [516](../src/bots_game_in_progress.opy#L516), [517](../src/bots_game_in_progress.opy#L517), [518](../src/bots_game_in_progress.opy#L518), [519](../src/bots_game_in_progress.opy#L519).

## botSpawnPointTimerList

Объявление: [variables.opy:153](../src/variables.opy#L153). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "SPAWN TIME CONTROL": [116](../src/global_startup.opy#L116), [120](../src/global_startup.opy#L120), [121](../src/global_startup.opy#L121).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [232](../src/global_startup.opy#L232).
- bots_game_in_progress.opy — def teleportBots(): [461](../src/bots_game_in_progress.opy#L461), [465](../src/bots_game_in_progress.opy#L465), [476](../src/bots_game_in_progress.opy#L476).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/bots_game_in_progress.opy#L515), [518](../src/bots_game_in_progress.opy#L518).

## botSpawnWaypointList

Объявление: [variables.opy:154](../src/variables.opy#L154). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 1.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [231](../src/global_startup.opy#L231).
- bots_game_in_progress.opy — def enterExitTeleport(): [433](../src/bots_game_in_progress.opy#L433).
- bots_game_in_progress.opy — def teleportBots(): [475](../src/bots_game_in_progress.opy#L475).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [514](../src/bots_game_in_progress.opy#L514), [517](../src/bots_game_in_progress.opy#L517).

## customTeleportPositionList

Объявление: [variables.opy:155](../src/variables.opy#L155). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [257](../src/global_startup.opy#L257).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [67](../src/bots_game_in_progress.opy#L67), [68](../src/bots_game_in_progress.opy#L68), [69](../src/bots_game_in_progress.opy#L69).
- bots_game_in_progress.opy — rule "BOT DIES": [154](../src/bots_game_in_progress.opy#L154).

## botSpawnTimeList

Объявление: [variables.opy:156](../src/variables.opy#L156). Строк обращений: 14; упоминаний: 20; чтений вида Global в скомпилированном коде: 13.

- global_startup.opy — rule "SPAWN BOTS": [97](../src/global_startup.opy#L97), [100](../src/global_startup.opy#L100), [101](../src/global_startup.opy#L101), [107](../src/global_startup.opy#L107), [109](../src/global_startup.opy#L109), [110](../src/global_startup.opy#L110).
- global_startup.opy — rule "SPAWN TIME CONTROL": [116](../src/global_startup.opy#L116), [118](../src/global_startup.opy#L118), [119](../src/global_startup.opy#L119).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [256](../src/global_startup.opy#L256).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [16](../src/objective_types/objective_type_kill_zone.opy#L16).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [63](../src/objective_types/objective_type_satellite_uplink.opy#L63).
- bots_game_in_progress.opy — rule "BOT DIES": [151](../src/bots_game_in_progress.opy#L151), [152](../src/bots_game_in_progress.opy#L152).

## startPos

Объявление: [variables.opy:159](../src/variables.opy#L159). Строк обращений: 21; упоминаний: 29; чтений вида Global в скомпилированном коде: 19.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [16](../src/global_start_menu.opy#L16), [18](../src/global_start_menu.opy#L18), [20](../src/global_start_menu.opy#L20), [21](../src/global_start_menu.opy#L21), [23](../src/global_start_menu.opy#L23), [26](../src/global_start_menu.opy#L26), [29](../src/global_start_menu.opy#L29), [30](../src/global_start_menu.opy#L30), [32](../src/global_start_menu.opy#L32), [34](../src/global_start_menu.opy#L34), [37](../src/global_start_menu.opy#L37), [39](../src/global_start_menu.opy#L39), [40](../src/global_start_menu.opy#L40), [41](../src/global_start_menu.opy#L41), [42](../src/global_start_menu.opy#L42), [46](../src/global_start_menu.opy#L46), [47](../src/global_start_menu.opy#L47).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [66](../src/global_start_menu.opy#L66), [68](../src/global_start_menu.opy#L68).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [67](../src/player_start_menu.opy#L67).

## startCamPos

Объявление: [variables.opy:160](../src/variables.opy#L160). Строк обращений: 13; упоминаний: 25; чтений вида Global в скомпилированном коде: 20.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [21](../src/global_start_menu.opy#L21), [35](../src/global_start_menu.opy#L35), [37](../src/global_start_menu.opy#L37), [38](../src/global_start_menu.opy#L38), [39](../src/global_start_menu.opy#L39), [41](../src/global_start_menu.opy#L41), [42](../src/global_start_menu.opy#L42), [46](../src/global_start_menu.opy#L46).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [66](../src/global_start_menu.opy#L66), [68](../src/global_start_menu.opy#L68).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [67](../src/player_start_menu.opy#L67), [79](../src/player_start_menu.opy#L79).

## objectivePositionList

Объявление: [variables.opy:163](../src/variables.opy#L163). Строк обращений: 109; упоминаний: 142; чтений вида Global в скомпилированном коде: 136.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [235](../src/subroutines.opy#L235), [237](../src/subroutines.opy#L237), [240](../src/subroutines.opy#L240), [244](../src/subroutines.opy#L244), [247](../src/subroutines.opy#L247), [250](../src/subroutines.opy#L250), [255](../src/subroutines.opy#L255), [258](../src/subroutines.opy#L258), [261](../src/subroutines.opy#L261), [264](../src/subroutines.opy#L264), [267](../src/subroutines.opy#L267), [270](../src/subroutines.opy#L270), [273](../src/subroutines.opy#L273), [276](../src/subroutines.opy#L276), [284](../src/subroutines.opy#L284), [287](../src/subroutines.opy#L287), [290](../src/subroutines.opy#L290), [295](../src/subroutines.opy#L295), [301](../src/subroutines.opy#L301), [304](../src/subroutines.opy#L304), [307](../src/subroutines.opy#L307), [313](../src/subroutines.opy#L313), [318](../src/subroutines.opy#L318), [321](../src/subroutines.opy#L321), [324](../src/subroutines.opy#L324), [332](../src/subroutines.opy#L332), [355](../src/subroutines.opy#L355), [358](../src/subroutines.opy#L358), [361](../src/subroutines.opy#L361), [364](../src/subroutines.opy#L364), [367](../src/subroutines.opy#L367), [372](../src/subroutines.opy#L372), [390](../src/subroutines.opy#L390).
- subroutines.opy — def objectivesManagement(): [536](../src/subroutines.opy#L536), [537](../src/subroutines.opy#L537), [546](../src/subroutines.opy#L546), [547](../src/subroutines.opy#L547), [552](../src/subroutines.opy#L552), [553](../src/subroutines.opy#L553), [564](../src/subroutines.opy#L564), [565](../src/subroutines.opy#L565), [566](../src/subroutines.opy#L566), [571](../src/subroutines.opy#L571), [574](../src/subroutines.opy#L574), [579](../src/subroutines.opy#L579), [625](../src/subroutines.opy#L625).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [242](../src/global_startup.opy#L242).
- global_start_menu.opy — def setObjectiveType(): [400](../src/global_start_menu.opy#L400), [402](../src/global_start_menu.opy#L402), [406](../src/global_start_menu.opy#L406), [409](../src/global_start_menu.opy#L409), [414](../src/global_start_menu.opy#L414), [415](../src/global_start_menu.opy#L415).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [13](../src/objective_types/objective_type_extraction_point.opy#L13), [14](../src/objective_types/objective_type_extraction_point.opy#L14), [15](../src/objective_types/objective_type_extraction_point.opy#L15).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE": [32](../src/objective_types/objective_type_extraction_point.opy#L32), [34](../src/objective_types/objective_type_extraction_point.opy#L34), [43](../src/objective_types/objective_type_extraction_point.opy#L43).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [60](../src/objective_types/objective_type_extraction_point.opy#L60), [63](../src/objective_types/objective_type_extraction_point.opy#L63).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71), [108](../src/objective_types/objective_type_extraction_point.opy#L108), [111](../src/objective_types/objective_type_extraction_point.opy#L111).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [7](../src/objective_types/objective_type_showdown.opy#L7), [12](../src/objective_types/objective_type_showdown.opy#L12), [14](../src/objective_types/objective_type_showdown.opy#L14).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [31](../src/objective_types/objective_type_showdown.opy#L31), [46](../src/objective_types/objective_type_showdown.opy#L46), [49](../src/objective_types/objective_type_showdown.opy#L49), [52](../src/objective_types/objective_type_showdown.opy#L52).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [61](../src/objective_types/objective_type_showdown.opy#L61), [69](../src/objective_types/objective_type_showdown.opy#L69), [72](../src/objective_types/objective_type_showdown.opy#L72), [77](../src/objective_types/objective_type_showdown.opy#L77).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [19](../src/objective_types/objective_type_bosses.opy#L19).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [63](../src/objective_types/objective_type_biomorphing.opy#L63), [68](../src/objective_types/objective_type_biomorphing.opy#L68).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [94](../src/objective_types/objective_type_biomorphing.opy#L94).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [137](../src/objective_types/objective_type_biomorphing.opy#L137).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [15](../src/objective_types/objective_type_survivor_rescue.opy#L15).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [46](../src/objective_types/objective_type_survivor_rescue.opy#L46), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [83](../src/objective_types/objective_type_survivor_rescue.opy#L83), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [174](../src/objective_types/objective_type_survivor_rescue.opy#L174), [178](../src/objective_types/objective_type_survivor_rescue.opy#L178).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [34](../src/objective_types/objective_type_zombie_egg.opy#L34).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [64](../src/objective_types/objective_type_zombie_egg.opy#L64), [69](../src/objective_types/objective_type_zombie_egg.opy#L69), [72](../src/objective_types/objective_type_zombie_egg.opy#L72).
- objective_types/objective_type_zombie_egg.opy — rule "EGG SWITCHES THE POSITION FOR YOU": [82](../src/objective_types/objective_type_zombie_egg.opy#L82).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [10](../src/objective_types/objective_type_satellite_uplink.opy#L10).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [75](../src/objective_types/objective_type_satellite_uplink.opy#L75).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [141](../src/objective_types/objective_type_satellite_uplink.opy#L141).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/players_game_in_progress.opy#L8).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [88](../src/players_game_in_progress.opy#L88), [93](../src/players_game_in_progress.opy#L93).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [165](../src/players_game_in_progress.opy#L165), [166](../src/players_game_in_progress.opy#L166), [170](../src/players_game_in_progress.opy#L170), [186](../src/players_game_in_progress.opy#L186).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/players_game_in_progress.opy#L321).
- players_game_in_progress.opy — def teleportToClosestPlayer(): [358](../src/players_game_in_progress.opy#L358).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [13](../src/bots_game_in_progress.opy#L13), [39](../src/bots_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "BOT DIES": [136](../src/bots_game_in_progress.opy#L136).
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1410](../src/zombie_types.opy#L1410).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35).

## objectiveTypeList

Объявление: [variables.opy:164](../src/variables.opy#L164). Строк обращений: 52; упоминаний: 55; чтений вида Global в скомпилированном коде: 50.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [221](../src/subroutines.opy#L221).
- subroutines.opy — def objectivesManagement(): [534](../src/subroutines.opy#L534), [575](../src/subroutines.opy#L575), [587](../src/subroutines.opy#L587).
- subroutines.opy — def botRespawnInitialization(): [729](../src/subroutines.opy#L729).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [243](../src/global_startup.opy#L243).
- global_start_menu.opy — def setObjectiveType(): [393](../src/global_start_menu.opy#L393), [395](../src/global_start_menu.opy#L395), [398](../src/global_start_menu.opy#L398), [400](../src/global_start_menu.opy#L400), [408](../src/global_start_menu.opy#L408), [418](../src/global_start_menu.opy#L418).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [12](../src/objective_types/objective_type_extraction_point.opy#L12).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [6](../src/objective_types/objective_type_showdown.opy#L6).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [30](../src/objective_types/objective_type_showdown.opy#L30).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [60](../src/objective_types/objective_type_showdown.opy#L60), [67](../src/objective_types/objective_type_showdown.opy#L67), [75](../src/objective_types/objective_type_showdown.opy#L75).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [7](../src/objective_types/objective_type_bosses.opy#L7).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [32](../src/objective_types/objective_type_bosses.opy#L32).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK": [89](../src/objective_types/objective_type_bosses.opy#L89).
- objective_types/objective_type_bosses.opy — rule "BOSS TAKES KNOCKBACK": [172](../src/objective_types/objective_type_bosses.opy#L172).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [24](../src/objective_types/objective_type_biomorphing.opy#L24).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [72](../src/objective_types/objective_type_biomorphing.opy#L72).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [102](../src/objective_types/objective_type_biomorphing.opy#L102).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [133](../src/objective_types/objective_type_biomorphing.opy#L133).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [172](../src/objective_types/objective_type_biomorphing.opy#L172).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [5](../src/objective_types/objective_type_survivor_rescue.opy#L5).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [31](../src/objective_types/objective_type_survivor_rescue.opy#L31).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR TO BE RESCUED DIES": [67](../src/objective_types/objective_type_survivor_rescue.opy#L67).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [78](../src/objective_types/objective_type_survivor_rescue.opy#L78).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [115](../src/objective_types/objective_type_survivor_rescue.opy#L115).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [128](../src/objective_types/objective_type_survivor_rescue.opy#L128).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [140](../src/objective_types/objective_type_survivor_rescue.opy#L140).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [148](../src/objective_types/objective_type_survivor_rescue.opy#L148).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [160](../src/objective_types/objective_type_survivor_rescue.opy#L160).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [171](../src/objective_types/objective_type_survivor_rescue.opy#L171).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [6](../src/objective_types/objective_type_kill_zone.opy#L6).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [5](../src/objective_types/objective_type_zombie_egg.opy#L5).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [20](../src/objective_types/objective_type_zombie_egg.opy#L20).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [56](../src/objective_types/objective_type_zombie_egg.opy#L56).
- objective_types/objective_type_zombie_egg.opy — rule "EGG SWITCHES THE POSITION FOR YOU": [79](../src/objective_types/objective_type_zombie_egg.opy#L79).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [68](../src/objective_types/objective_type_satellite_uplink.opy#L68).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [101](../src/objective_types/objective_type_satellite_uplink.opy#L101).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [117](../src/objective_types/objective_type_satellite_uplink.opy#L117).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [9](../src/players_game_in_progress.opy#L9).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [12](../src/bots_game_in_progress.opy#L12), [15](../src/bots_game_in_progress.opy#L15), [18](../src/bots_game_in_progress.opy#L18), [24](../src/bots_game_in_progress.opy#L24), [33](../src/bots_game_in_progress.opy#L33).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE": [526](../src/bots_game_in_progress.opy#L526).

## objectiveSpacingList

Объявление: [variables.opy:165](../src/variables.opy#L165). Строк обращений: 3; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — def generateMapGrid(): [316](../src/global_startup.opy#L316).
- global_start_menu.opy — def setObjectiveType(): [402](../src/global_start_menu.opy#L402), [406](../src/global_start_menu.opy#L406).

## objectiveValue

Объявление: [variables.opy:166](../src/variables.opy#L166). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [221](../src/subroutines.opy#L221), [233](../src/subroutines.opy#L233), [279](../src/subroutines.opy#L279), [293](../src/subroutines.opy#L293), [316](../src/subroutines.opy#L316), [327](../src/subroutines.opy#L327), [350](../src/subroutines.opy#L350), [370](../src/subroutines.opy#L370).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/players_game_in_progress.opy#L8).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/players_game_in_progress.opy#L321).

## objectiveProgressSlot

Объявление: [variables.opy:167](../src/variables.opy#L167). Строк обращений: 44; упоминаний: 46; чтений вида Global в скомпилированном коде: 30.

Алиасы ролей: `objectiveProgress`, `showdownCapturePercent`, `biomorphingCapturePercent`, `killZoneEliminationScore`, `satelliteTerminalProgressList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [273](../src/subroutines.opy#L273), [276](../src/subroutines.opy#L276), [295](../src/subroutines.opy#L295), [329](../src/subroutines.opy#L329), [372](../src/subroutines.opy#L372), [378](../src/subroutines.opy#L378), [382](../src/subroutines.opy#L382), [384](../src/subroutines.opy#L384), [393](../src/subroutines.opy#L393).
- subroutines.opy — def objectivesManagement(): [529](../src/subroutines.opy#L529), [590](../src/subroutines.opy#L590), [591](../src/subroutines.opy#L591), [603](../src/subroutines.opy#L603), [627](../src/subroutines.opy#L627), [639](../src/subroutines.opy#L639).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [36](../src/objective_types/objective_type_showdown.opy#L36), [45](../src/objective_types/objective_type_showdown.opy#L45), [46](../src/objective_types/objective_type_showdown.opy#L46), [47](../src/objective_types/objective_type_showdown.opy#L47).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [64](../src/objective_types/objective_type_showdown.opy#L64), [71](../src/objective_types/objective_type_showdown.opy#L71), [72](../src/objective_types/objective_type_showdown.opy#L72).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [44](../src/objective_types/objective_type_biomorphing.opy#L44), [47](../src/objective_types/objective_type_biomorphing.opy#L47), [48](../src/objective_types/objective_type_biomorphing.opy#L48).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [74](../src/objective_types/objective_type_biomorphing.opy#L74), [76](../src/objective_types/objective_type_biomorphing.opy#L76), [79](../src/objective_types/objective_type_biomorphing.opy#L79).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [155](../src/objective_types/objective_type_biomorphing.opy#L155), [156](../src/objective_types/objective_type_biomorphing.opy#L156), [158](../src/objective_types/objective_type_biomorphing.opy#L158).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [11](../src/objective_types/objective_type_kill_zone.opy#L11), [12](../src/objective_types/objective_type_kill_zone.opy#L12).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [71](../src/objective_types/objective_type_satellite_uplink.opy#L71), [93](../src/objective_types/objective_type_satellite_uplink.opy#L93).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [106](../src/objective_types/objective_type_satellite_uplink.opy#L106).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [124](../src/objective_types/objective_type_satellite_uplink.opy#L124), [128](../src/objective_types/objective_type_satellite_uplink.opy#L128), [130](../src/objective_types/objective_type_satellite_uplink.opy#L130), [132](../src/objective_types/objective_type_satellite_uplink.opy#L132), [133](../src/objective_types/objective_type_satellite_uplink.opy#L133), [138](../src/objective_types/objective_type_satellite_uplink.opy#L138).
- bots_game_in_progress.opy — rule "BOT DIES": [131](../src/bots_game_in_progress.opy#L131), [135](../src/bots_game_in_progress.opy#L135).

## objectiveRad

Объявление: [variables.opy:173](../src/variables.opy#L173). Строк обращений: 53; упоминаний: 58; чтений вида Global в скомпилированном коде: 47.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [244](../src/subroutines.opy#L244), [258](../src/subroutines.opy#L258), [261](../src/subroutines.opy#L261), [264](../src/subroutines.opy#L264), [267](../src/subroutines.opy#L267), [304](../src/subroutines.opy#L304), [307](../src/subroutines.opy#L307), [324](../src/subroutines.opy#L324), [335](../src/subroutines.opy#L335), [338](../src/subroutines.opy#L338), [341](../src/subroutines.opy#L341), [344](../src/subroutines.opy#L344), [347](../src/subroutines.opy#L347), [375](../src/subroutines.opy#L375), [384](../src/subroutines.opy#L384), [387](../src/subroutines.opy#L387), [390](../src/subroutines.opy#L390), [393](../src/subroutines.opy#L393).
- subroutines.opy — def objectivesManagement(): [536](../src/subroutines.opy#L536), [546](../src/subroutines.opy#L546), [552](../src/subroutines.opy#L552), [559](../src/subroutines.opy#L559), [565](../src/subroutines.opy#L565), [584](../src/subroutines.opy#L584), [591](../src/subroutines.opy#L591), [607](../src/subroutines.opy#L607), [618](../src/subroutines.opy#L618), [619](../src/subroutines.opy#L619), [624](../src/subroutines.opy#L624), [631](../src/subroutines.opy#L631), [636](../src/subroutines.opy#L636).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [244](../src/global_startup.opy#L244).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [15](../src/objective_types/objective_type_extraction_point.opy#L15).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [108](../src/objective_types/objective_type_extraction_point.opy#L108).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [14](../src/objective_types/objective_type_showdown.opy#L14).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [37](../src/objective_types/objective_type_showdown.opy#L37), [49](../src/objective_types/objective_type_showdown.opy#L49).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [137](../src/objective_types/objective_type_biomorphing.opy#L137).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [46](../src/objective_types/objective_type_survivor_rescue.opy#L46), [53](../src/objective_types/objective_type_survivor_rescue.opy#L53).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [82](../src/objective_types/objective_type_survivor_rescue.opy#L82), [88](../src/objective_types/objective_type_survivor_rescue.opy#L88), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [94](../src/objective_types/objective_type_survivor_rescue.opy#L94), [101](../src/objective_types/objective_type_survivor_rescue.opy#L101).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [7](../src/objective_types/objective_type_kill_zone.opy#L7), [9](../src/objective_types/objective_type_kill_zone.opy#L9).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [106](../src/objective_types/objective_type_satellite_uplink.opy#L106).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126), [135](../src/objective_types/objective_type_satellite_uplink.opy#L135).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [26](../src/bots_game_in_progress.opy#L26).
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1410](../src/zombie_types.opy#L1410).

## objectiveDescription

Объявление: [variables.opy:174](../src/variables.opy#L174). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — def objectivesManagement(): [581](../src/subroutines.opy#L581), [589](../src/subroutines.opy#L589), [598](../src/subroutines.opy#L598), [602](../src/subroutines.opy#L602), [616](../src/subroutines.opy#L616), [623](../src/subroutines.opy#L623), [630](../src/subroutines.opy#L630), [635](../src/subroutines.opy#L635).
- global_startup.opy — rule "START GAME": [296](../src/global_startup.opy#L296).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [10](../src/global_game_in_progress.opy#L10).

## objectiveColor

Объявление: [variables.opy:175](../src/variables.opy#L175). Строк обращений: 27; упоминаний: 31; чтений вида Global в скомпилированном коде: 26.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [255](../src/subroutines.opy#L255), [258](../src/subroutines.opy#L258), [261](../src/subroutines.opy#L261), [264](../src/subroutines.opy#L264), [267](../src/subroutines.opy#L267), [270](../src/subroutines.opy#L270), [273](../src/subroutines.opy#L273), [276](../src/subroutines.opy#L276), [295](../src/subroutines.opy#L295), [301](../src/subroutines.opy#L301), [372](../src/subroutines.opy#L372), [375](../src/subroutines.opy#L375), [378](../src/subroutines.opy#L378), [384](../src/subroutines.opy#L384), [387](../src/subroutines.opy#L387), [390](../src/subroutines.opy#L390), [393](../src/subroutines.opy#L393).
- subroutines.opy — def objectivesManagement(): [592](../src/subroutines.opy#L592), [606](../src/subroutines.opy#L606), [637](../src/subroutines.opy#L637).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [73](../src/objective_types/objective_type_showdown.opy#L73), [79](../src/objective_types/objective_type_showdown.opy#L79).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [45](../src/objective_types/objective_type_biomorphing.opy#L45).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [14](../src/objective_types/objective_type_satellite_uplink.opy#L14).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136), [141](../src/objective_types/objective_type_satellite_uplink.opy#L141).

## isObjectiveComplete

Объявление: [variables.opy:176](../src/variables.opy#L176). Строк обращений: 29; упоминаний: 29; чтений вида Global в скомпилированном коде: 21.

- subroutines.opy — def objectivesManagement(): [645](../src/subroutines.opy#L645).
- global_game_in_progress.opy — rule "OBJECTIVE COMPLETE": [130](../src/global_game_in_progress.opy#L130).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [9](../src/objective_types/objective_type_extraction_point.opy#L9).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [69](../src/objective_types/objective_type_extraction_point.opy#L69).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [33](../src/objective_types/objective_type_showdown.opy#L33), [38](../src/objective_types/objective_type_showdown.opy#L38).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [63](../src/objective_types/objective_type_showdown.opy#L63).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [8](../src/objective_types/objective_type_bosses.opy#L8).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [33](../src/objective_types/objective_type_bosses.opy#L33).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)": [148](../src/objective_types/objective_type_bosses.opy#L148), [159](../src/objective_types/objective_type_bosses.opy#L159).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [25](../src/objective_types/objective_type_biomorphing.opy#L25).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [73](../src/objective_types/objective_type_biomorphing.opy#L73), [95](../src/objective_types/objective_type_biomorphing.opy#L95).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [104](../src/objective_types/objective_type_biomorphing.opy#L104).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [7](../src/objective_types/objective_type_survivor_rescue.opy#L7), [22](../src/objective_types/objective_type_survivor_rescue.opy#L22).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [172](../src/objective_types/objective_type_survivor_rescue.opy#L172).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [13](../src/objective_types/objective_type_kill_zone.opy#L13).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [6](../src/objective_types/objective_type_zombie_egg.opy#L6).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [21](../src/objective_types/objective_type_zombie_egg.opy#L21), [45](../src/objective_types/objective_type_zombie_egg.opy#L45), [50](../src/objective_types/objective_type_zombie_egg.opy#L50).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [57](../src/objective_types/objective_type_zombie_egg.opy#L57).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [70](../src/objective_types/objective_type_satellite_uplink.opy#L70).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [102](../src/objective_types/objective_type_satellite_uplink.opy#L102).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [118](../src/objective_types/objective_type_satellite_uplink.opy#L118), [143](../src/objective_types/objective_type_satellite_uplink.opy#L143).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [191](../src/players_game_in_progress.opy#L191).

## objectivePlayerList

Объявление: [variables.opy:177](../src/variables.opy#L177). Строк обращений: 48; упоминаний: 52; чтений вида Global в скомпилированном коде: 39.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [237](../src/subroutines.opy#L237), [247](../src/subroutines.opy#L247), [250](../src/subroutines.opy#L250), [255](../src/subroutines.opy#L255), [264](../src/subroutines.opy#L264), [267](../src/subroutines.opy#L267), [270](../src/subroutines.opy#L270), [273](../src/subroutines.opy#L273), [276](../src/subroutines.opy#L276), [301](../src/subroutines.opy#L301), [307](../src/subroutines.opy#L307), [310](../src/subroutines.opy#L310), [313](../src/subroutines.opy#L313), [375](../src/subroutines.opy#L375), [378](../src/subroutines.opy#L378).
- subroutines.opy — def objectivesManagement(): [528](../src/subroutines.opy#L528), [580](../src/subroutines.opy#L580).
- subroutines.opy — def selectTarget(): [656](../src/subroutines.opy#L656).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [246](../src/global_startup.opy#L246).
- global_game_in_progress.opy — rule "PLAYER LEAVES THE GAME": [118](../src/global_game_in_progress.opy#L118), [121](../src/global_game_in_progress.opy#L121).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [17](../src/objective_types/objective_type_extraction_point.opy#L17), [18](../src/objective_types/objective_type_extraction_point.opy#L18), [24](../src/objective_types/objective_type_extraction_point.opy#L24).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE": [35](../src/objective_types/objective_type_extraction_point.opy#L35).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71), [89](../src/objective_types/objective_type_extraction_point.opy#L89), [92](../src/objective_types/objective_type_extraction_point.opy#L92), [113](../src/objective_types/objective_type_extraction_point.opy#L113).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [20](../src/objective_types/objective_type_showdown.opy#L20), [21](../src/objective_types/objective_type_showdown.opy#L21), [25](../src/objective_types/objective_type_showdown.opy#L25).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [32](../src/objective_types/objective_type_showdown.opy#L32), [40](../src/objective_types/objective_type_showdown.opy#L40), [45](../src/objective_types/objective_type_showdown.opy#L45).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [141](../src/objective_types/objective_type_biomorphing.opy#L141), [142](../src/objective_types/objective_type_biomorphing.opy#L142), [167](../src/objective_types/objective_type_biomorphing.opy#L167).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [108](../src/objective_types/objective_type_satellite_uplink.opy#L108), [109](../src/objective_types/objective_type_satellite_uplink.opy#L109), [113](../src/objective_types/objective_type_satellite_uplink.opy#L113).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [119](../src/objective_types/objective_type_satellite_uplink.opy#L119), [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126).
- players_game_in_progress.opy — rule "PLAYER AFK": [266](../src/players_game_in_progress.opy#L266).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [35](../src/bots_game_in_progress.opy#L35), [36](../src/bots_game_in_progress.opy#L36).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [490](../src/bots_game_in_progress.opy#L490).

## objectiveEntityIdList

Объявление: [variables.opy:178](../src/variables.opy#L178). Строк обращений: 62; упоминаний: 62; чтений вида Global в скомпилированном коде: 7.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [223](../src/subroutines.opy#L223), [224](../src/subroutines.opy#L224), [225](../src/subroutines.opy#L225), [226](../src/subroutines.opy#L226), [227](../src/subroutines.opy#L227), [228](../src/subroutines.opy#L228), [229](../src/subroutines.opy#L229), [231](../src/subroutines.opy#L231), [238](../src/subroutines.opy#L238), [241](../src/subroutines.opy#L241), [245](../src/subroutines.opy#L245), [248](../src/subroutines.opy#L248), [251](../src/subroutines.opy#L251), [256](../src/subroutines.opy#L256), [259](../src/subroutines.opy#L259), [262](../src/subroutines.opy#L262), [265](../src/subroutines.opy#L265), [268](../src/subroutines.opy#L268), [271](../src/subroutines.opy#L271), [274](../src/subroutines.opy#L274), [277](../src/subroutines.opy#L277), [282](../src/subroutines.opy#L282), [285](../src/subroutines.opy#L285), [288](../src/subroutines.opy#L288), [291](../src/subroutines.opy#L291), [296](../src/subroutines.opy#L296), [299](../src/subroutines.opy#L299), [302](../src/subroutines.opy#L302), [305](../src/subroutines.opy#L305), [308](../src/subroutines.opy#L308), [311](../src/subroutines.opy#L311), [314](../src/subroutines.opy#L314), [319](../src/subroutines.opy#L319), [322](../src/subroutines.opy#L322), [325](../src/subroutines.opy#L325), [330](../src/subroutines.opy#L330), [333](../src/subroutines.opy#L333), [336](../src/subroutines.opy#L336), [339](../src/subroutines.opy#L339), [342](../src/subroutines.opy#L342), [345](../src/subroutines.opy#L345), [348](../src/subroutines.opy#L348), [353](../src/subroutines.opy#L353), [356](../src/subroutines.opy#L356), [359](../src/subroutines.opy#L359), [362](../src/subroutines.opy#L362), [365](../src/subroutines.opy#L365), [368](../src/subroutines.opy#L368), [373](../src/subroutines.opy#L373), [376](../src/subroutines.opy#L376), [379](../src/subroutines.opy#L379), [385](../src/subroutines.opy#L385), [388](../src/subroutines.opy#L388), [391](../src/subroutines.opy#L391), [394](../src/subroutines.opy#L394).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [229](../src/global_startup.opy#L229).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [15](../src/objective_types/objective_type_satellite_uplink.opy#L15), [22](../src/objective_types/objective_type_satellite_uplink.opy#L22), [25](../src/objective_types/objective_type_satellite_uplink.opy#L25), [28](../src/objective_types/objective_type_satellite_uplink.opy#L28), [31](../src/objective_types/objective_type_satellite_uplink.opy#L31), [36](../src/objective_types/objective_type_satellite_uplink.opy#L36).

## objectivePositionsSlot

Объявление: [variables.opy:179](../src/variables.opy#L179). Строк обращений: 35; упоминаний: 44; чтений вида Global в скомпилированном коде: 34.

Алиасы ролей: `objectivePositionsList`, `biomorphingResourcePositionList`, `satelliteTerminalPositionList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [313](../src/subroutines.opy#L313), [375](../src/subroutines.opy#L375), [378](../src/subroutines.opy#L378), [384](../src/subroutines.opy#L384), [387](../src/subroutines.opy#L387), [390](../src/subroutines.opy#L390), [393](../src/subroutines.opy#L393).
- subroutines.opy — def objectivesManagement(): [604](../src/subroutines.opy#L604), [638](../src/subroutines.opy#L638).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [219](../src/global_startup.opy#L219).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [16](../src/objective_types/objective_type_biomorphing.opy#L16).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [39](../src/objective_types/objective_type_biomorphing.opy#L39).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [74](../src/objective_types/objective_type_biomorphing.opy#L74).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [108](../src/objective_types/objective_type_biomorphing.opy#L108), [109](../src/objective_types/objective_type_biomorphing.opy#L109), [114](../src/objective_types/objective_type_biomorphing.opy#L114), [116](../src/objective_types/objective_type_biomorphing.opy#L116), [121](../src/objective_types/objective_type_biomorphing.opy#L121).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [13](../src/objective_types/objective_type_satellite_uplink.opy#L13), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [71](../src/objective_types/objective_type_satellite_uplink.opy#L71), [76](../src/objective_types/objective_type_satellite_uplink.opy#L76), [77](../src/objective_types/objective_type_satellite_uplink.opy#L77), [80](../src/objective_types/objective_type_satellite_uplink.opy#L80), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [86](../src/objective_types/objective_type_satellite_uplink.opy#L86), [89](../src/objective_types/objective_type_satellite_uplink.opy#L89), [91](../src/objective_types/objective_type_satellite_uplink.opy#L91), [92](../src/objective_types/objective_type_satellite_uplink.opy#L92).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [106](../src/objective_types/objective_type_satellite_uplink.opy#L106).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [123](../src/objective_types/objective_type_satellite_uplink.opy#L123), [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126), [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136).

## objectivePlacementSlot

Объявление: [variables.opy:184](../src/variables.opy#L184). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

Алиасы ролей: `missionCandidatePosition`, `rescueCandidatePosition`.

- global_start_menu.opy — def setObjectiveType(): [402](../src/global_start_menu.opy#L402), [403](../src/global_start_menu.opy#L403), [406](../src/global_start_menu.opy#L406), [408](../src/global_start_menu.opy#L408), [409](../src/global_start_menu.opy#L409).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [12](../src/objective_types/objective_type_survivor_rescue.opy#L12), [14](../src/objective_types/objective_type_survivor_rescue.opy#L14), [15](../src/objective_types/objective_type_survivor_rescue.opy#L15), [18](../src/objective_types/objective_type_survivor_rescue.opy#L18).

## objectiveMotionSlot

Объявление: [variables.opy:188](../src/variables.opy#L188). Строк обращений: 28; упоминаний: 43; чтений вида Global в скомпилированном коде: 35.

Алиасы ролей: `rescueSavedRadius`, `killZoneCenter`, `satelliteLaserPosition`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [335](../src/subroutines.opy#L335), [338](../src/subroutines.opy#L338), [341](../src/subroutines.opy#L341), [344](../src/subroutines.opy#L344), [347](../src/subroutines.opy#L347).
- subroutines.opy — def objectivesManagement(): [558](../src/subroutines.opy#L558), [559](../src/subroutines.opy#L559), [619](../src/subroutines.opy#L619), [625](../src/subroutines.opy#L625).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [101](../src/objective_types/objective_type_survivor_rescue.opy#L101).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [7](../src/objective_types/objective_type_kill_zone.opy#L7), [9](../src/objective_types/objective_type_kill_zone.opy#L9), [18](../src/objective_types/objective_type_kill_zone.opy#L18).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [10](../src/objective_types/objective_type_satellite_uplink.opy#L10), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14), [21](../src/objective_types/objective_type_satellite_uplink.opy#L21), [24](../src/objective_types/objective_type_satellite_uplink.opy#L24), [27](../src/objective_types/objective_type_satellite_uplink.opy#L27), [30](../src/objective_types/objective_type_satellite_uplink.opy#L30), [35](../src/objective_types/objective_type_satellite_uplink.opy#L35), [40](../src/objective_types/objective_type_satellite_uplink.opy#L40), [43](../src/objective_types/objective_type_satellite_uplink.opy#L43), [44](../src/objective_types/objective_type_satellite_uplink.opy#L44), [47](../src/objective_types/objective_type_satellite_uplink.opy#L47), [50](../src/objective_types/objective_type_satellite_uplink.opy#L50), [64](../src/objective_types/objective_type_satellite_uplink.opy#L64).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [26](../src/bots_game_in_progress.opy#L26), [28](../src/bots_game_in_progress.opy#L28).

## objectiveCheckpointSlot

Объявление: [variables.opy:193](../src/variables.opy#L193). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 5.

Алиасы ролей: `objectiveNextCheckpoint`, `showdownNextCheckpoint`, `biomorphingNextCheckpoint`.

- subroutines.opy — def objectivesManagement(): [531](../src/subroutines.opy#L531), [594](../src/subroutines.opy#L594), [613](../src/subroutines.opy#L613).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [47](../src/objective_types/objective_type_showdown.opy#L47), [48](../src/objective_types/objective_type_showdown.opy#L48), [50](../src/objective_types/objective_type_showdown.opy#L50).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [64](../src/objective_types/objective_type_showdown.opy#L64).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [156](../src/objective_types/objective_type_biomorphing.opy#L156), [158](../src/objective_types/objective_type_biomorphing.opy#L158), [160](../src/objective_types/objective_type_biomorphing.opy#L160).

## objectiveQueueSlot

Объявление: [variables.opy:198](../src/variables.opy#L198). Строк обращений: 25; упоминаний: 28; чтений вида Global в скомпилированном коде: 20.

Алиасы ролей: `showdownContestingZombieList`, `biomorphingGoalQueueList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [276](../src/subroutines.opy#L276), [298](../src/subroutines.opy#L298), [310](../src/subroutines.opy#L310).
- subroutines.opy — def objectivesManagement(): [595](../src/subroutines.opy#L595), [611](../src/subroutines.opy#L611).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [17](../src/objective_types/objective_type_showdown.opy#L17), [18](../src/objective_types/objective_type_showdown.opy#L18), [26](../src/objective_types/objective_type_showdown.opy#L26).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [39](../src/objective_types/objective_type_showdown.opy#L39).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [62](../src/objective_types/objective_type_showdown.opy#L62), [71](../src/objective_types/objective_type_showdown.opy#L71).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [48](../src/objective_types/objective_type_biomorphing.opy#L48), [49](../src/objective_types/objective_type_biomorphing.opy#L49), [50](../src/objective_types/objective_type_biomorphing.opy#L50), [52](../src/objective_types/objective_type_biomorphing.opy#L52), [55](../src/objective_types/objective_type_biomorphing.opy#L55), [58](../src/objective_types/objective_type_biomorphing.opy#L58).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [76](../src/objective_types/objective_type_biomorphing.opy#L76).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [147](../src/objective_types/objective_type_biomorphing.opy#L147), [151](../src/objective_types/objective_type_biomorphing.opy#L151), [155](../src/objective_types/objective_type_biomorphing.opy#L155), [157](../src/objective_types/objective_type_biomorphing.opy#L157).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [174](../src/objective_types/objective_type_biomorphing.opy#L174).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [76](../src/bots_game_in_progress.opy#L76).
- bots_game_in_progress.opy — rule "BOT DIES": [127](../src/bots_game_in_progress.opy#L127).

## objectiveActorSlot

Объявление: [variables.opy:202](../src/variables.opy#L202). Строк обращений: 77; упоминаний: 107; чтений вида Global в скомпилированном коде: 102.

Алиасы ролей: `objectiveActor`, `rescueSurvivor`, `satelliteLaserTarget`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [324](../src/subroutines.opy#L324).
- subroutines.opy — def objectivesManagement(): [577](../src/subroutines.opy#L577), [617](../src/subroutines.opy#L617).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [8](../src/objective_types/objective_type_survivor_rescue.opy#L8), [11](../src/objective_types/objective_type_survivor_rescue.opy#L11), [19](../src/objective_types/objective_type_survivor_rescue.opy#L19), [21](../src/objective_types/objective_type_survivor_rescue.opy#L21).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [32](../src/objective_types/objective_type_survivor_rescue.opy#L32), [35](../src/objective_types/objective_type_survivor_rescue.opy#L35), [36](../src/objective_types/objective_type_survivor_rescue.opy#L36), [37](../src/objective_types/objective_type_survivor_rescue.opy#L37), [43](../src/objective_types/objective_type_survivor_rescue.opy#L43), [44](../src/objective_types/objective_type_survivor_rescue.opy#L44).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR TO BE RESCUED DIES": [68](../src/objective_types/objective_type_survivor_rescue.opy#L68).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [79](../src/objective_types/objective_type_survivor_rescue.opy#L79), [80](../src/objective_types/objective_type_survivor_rescue.opy#L80), [81](../src/objective_types/objective_type_survivor_rescue.opy#L81), [82](../src/objective_types/objective_type_survivor_rescue.opy#L82), [83](../src/objective_types/objective_type_survivor_rescue.opy#L83), [85](../src/objective_types/objective_type_survivor_rescue.opy#L85), [86](../src/objective_types/objective_type_survivor_rescue.opy#L86), [87](../src/objective_types/objective_type_survivor_rescue.opy#L87), [88](../src/objective_types/objective_type_survivor_rescue.opy#L88), [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [91](../src/objective_types/objective_type_survivor_rescue.opy#L91), [93](../src/objective_types/objective_type_survivor_rescue.opy#L93), [99](../src/objective_types/objective_type_survivor_rescue.opy#L99), [102](../src/objective_types/objective_type_survivor_rescue.opy#L102), [103](../src/objective_types/objective_type_survivor_rescue.opy#L103), [104](../src/objective_types/objective_type_survivor_rescue.opy#L104), [105](../src/objective_types/objective_type_survivor_rescue.opy#L105), [106](../src/objective_types/objective_type_survivor_rescue.opy#L106), [107](../src/objective_types/objective_type_survivor_rescue.opy#L107), [108](../src/objective_types/objective_type_survivor_rescue.opy#L108), [109](../src/objective_types/objective_type_survivor_rescue.opy#L109).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [116](../src/objective_types/objective_type_survivor_rescue.opy#L116), [117](../src/objective_types/objective_type_survivor_rescue.opy#L117), [118](../src/objective_types/objective_type_survivor_rescue.opy#L118), [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [121](../src/objective_types/objective_type_survivor_rescue.opy#L121).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [129](../src/objective_types/objective_type_survivor_rescue.opy#L129), [132](../src/objective_types/objective_type_survivor_rescue.opy#L132), [133](../src/objective_types/objective_type_survivor_rescue.opy#L133).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [141](../src/objective_types/objective_type_survivor_rescue.opy#L141), [142](../src/objective_types/objective_type_survivor_rescue.opy#L142), [144](../src/objective_types/objective_type_survivor_rescue.opy#L144).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [149](../src/objective_types/objective_type_survivor_rescue.opy#L149), [150](../src/objective_types/objective_type_survivor_rescue.opy#L150), [152](../src/objective_types/objective_type_survivor_rescue.opy#L152), [153](../src/objective_types/objective_type_survivor_rescue.opy#L153), [154](../src/objective_types/objective_type_survivor_rescue.opy#L154), [156](../src/objective_types/objective_type_survivor_rescue.opy#L156).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [161](../src/objective_types/objective_type_survivor_rescue.opy#L161), [162](../src/objective_types/objective_type_survivor_rescue.opy#L162), [163](../src/objective_types/objective_type_survivor_rescue.opy#L163), [166](../src/objective_types/objective_type_survivor_rescue.opy#L166).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [173](../src/objective_types/objective_type_survivor_rescue.opy#L173), [174](../src/objective_types/objective_type_survivor_rescue.opy#L174), [176](../src/objective_types/objective_type_survivor_rescue.opy#L176), [177](../src/objective_types/objective_type_survivor_rescue.opy#L177), [178](../src/objective_types/objective_type_survivor_rescue.opy#L178), [179](../src/objective_types/objective_type_survivor_rescue.opy#L179), [181](../src/objective_types/objective_type_survivor_rescue.opy#L181), [182](../src/objective_types/objective_type_survivor_rescue.opy#L182), [183](../src/objective_types/objective_type_survivor_rescue.opy#L183), [185](../src/objective_types/objective_type_survivor_rescue.opy#L185), [187](../src/objective_types/objective_type_survivor_rescue.opy#L187), [189](../src/objective_types/objective_type_survivor_rescue.opy#L189), [191](../src/objective_types/objective_type_survivor_rescue.opy#L191).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [40](../src/objective_types/objective_type_satellite_uplink.opy#L40), [44](../src/objective_types/objective_type_satellite_uplink.opy#L44), [45](../src/objective_types/objective_type_satellite_uplink.opy#L45), [47](../src/objective_types/objective_type_satellite_uplink.opy#L47).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [19](../src/bots_game_in_progress.opy#L19), [20](../src/bots_game_in_progress.opy#L20), [22](../src/bots_game_in_progress.opy#L22).

## isBiomorphingGoalPending

Объявление: [variables.opy:208](../src/variables.opy#L208). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — def objectivesManagement(): [532](../src/subroutines.opy#L532), [612](../src/subroutines.opy#L612).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [26](../src/objective_types/objective_type_biomorphing.opy#L26), [67](../src/objective_types/objective_type_biomorphing.opy#L67).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [80](../src/objective_types/objective_type_biomorphing.opy#L80).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [159](../src/objective_types/objective_type_biomorphing.opy#L159).

## biomorphingResourceTypeList

Объявление: [variables.opy:209](../src/variables.opy#L209). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 1.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [15](../src/objective_types/objective_type_biomorphing.opy#L15).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [38](../src/objective_types/objective_type_biomorphing.opy#L38).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [117](../src/objective_types/objective_type_biomorphing.opy#L117), [120](../src/objective_types/objective_type_biomorphing.opy#L120).

## biomorphingDeferredTypeList

Объявление: [variables.opy:210](../src/variables.opy#L210). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 3.

- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [36](../src/objective_types/objective_type_biomorphing.opy#L36).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [176](../src/objective_types/objective_type_biomorphing.opy#L176).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [183](../src/objective_types/objective_type_biomorphing.opy#L183), [185](../src/objective_types/objective_type_biomorphing.opy#L185), [187](../src/objective_types/objective_type_biomorphing.opy#L187), [191](../src/objective_types/objective_type_biomorphing.opy#L191).

## biomorphingDeferredPositionList

Объявление: [variables.opy:211](../src/variables.opy#L211). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 1.

- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [37](../src/objective_types/objective_type_biomorphing.opy#L37).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [177](../src/objective_types/objective_type_biomorphing.opy#L177).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [189](../src/objective_types/objective_type_biomorphing.opy#L189), [192](../src/objective_types/objective_type_biomorphing.opy#L192).

## biomorphingResourceTextIdList

Объявление: [variables.opy:212](../src/variables.opy#L212). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [20](../src/objective_types/objective_type_biomorphing.opy#L20).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [33](../src/objective_types/objective_type_biomorphing.opy#L33), [41](../src/objective_types/objective_type_biomorphing.opy#L41).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [119](../src/objective_types/objective_type_biomorphing.opy#L119), [123](../src/objective_types/objective_type_biomorphing.opy#L123).

## biomorphingResourceEffectIdList

Объявление: [variables.opy:213](../src/variables.opy#L213). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 3.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [18](../src/objective_types/objective_type_biomorphing.opy#L18).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [31](../src/objective_types/objective_type_biomorphing.opy#L31), [32](../src/objective_types/objective_type_biomorphing.opy#L32), [40](../src/objective_types/objective_type_biomorphing.opy#L40).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [118](../src/objective_types/objective_type_biomorphing.opy#L118), [122](../src/objective_types/objective_type_biomorphing.opy#L122).

## extractionZoneRad

Объявление: [variables.opy:216](../src/variables.opy#L216). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 8.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [240](../src/subroutines.opy#L240).
- subroutines.opy — def objectivesManagement(): [583](../src/subroutines.opy#L583).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [217](../src/global_startup.opy#L217).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE": [33](../src/objective_types/objective_type_extraction_point.opy#L33), [34](../src/objective_types/objective_type_extraction_point.opy#L34).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [165](../src/players_game_in_progress.opy#L165), [166](../src/players_game_in_progress.opy#L166), [170](../src/players_game_in_progress.opy#L170).

## extractionSpeedUp

Объявление: [variables.opy:217](../src/variables.opy#L217). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — def objectivesManagement(): [583](../src/subroutines.opy#L583).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [218](../src/global_startup.opy#L218).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [19](../src/objective_types/objective_type_extraction_point.opy#L19).

## evacSurvivorList

Объявление: [variables.opy:218](../src/variables.opy#L218). Строк обращений: 5; упоминаний: 6; чтений вида Global в скомпилированном коде: 5.

- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [54](../src/objective_types/objective_type_extraction_point.opy#L54), [60](../src/objective_types/objective_type_extraction_point.opy#L60).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [113](../src/objective_types/objective_type_extraction_point.opy#L113), [114](../src/objective_types/objective_type_extraction_point.opy#L114).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [148](../src/objective_types/objective_type_extraction_point.opy#L148).

## menuFinaleMotionSlot

Объявление: [variables.opy:219](../src/variables.opy#L219). Строк обращений: 11; упоминаний: 11; чтений вида Global в скомпилированном коде: 5.

Алиасы ролей: `pregameCountdown`, `nukeProjectilePosition`.

- subroutines.opy — def setPrematchTimer(): [474](../src/subroutines.opy#L474), [481](../src/subroutines.opy#L481), [493](../src/subroutines.opy#L493).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [168](../src/global_startup.opy#L168), [169](../src/global_startup.opy#L169).
- global_start_menu.opy — rule "END VOTING": [237](../src/global_start_menu.opy#L237).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [140](../src/objective_types/objective_type_extraction_point.opy#L140), [141](../src/objective_types/objective_type_extraction_point.opy#L141), [143](../src/objective_types/objective_type_extraction_point.opy#L143), [144](../src/objective_types/objective_type_extraction_point.opy#L144), [145](../src/objective_types/objective_type_extraction_point.opy#L145).

## supplyDropLandingPosition

Объявление: [variables.opy:225](../src/variables.opy#L225). Строк обращений: 18; упоминаний: 31; чтений вида Global в скомпилированном коде: 28.

- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [27](../src/supply_drops.opy#L27), [32](../src/supply_drops.opy#L32), [40](../src/supply_drops.opy#L40), [42](../src/supply_drops.opy#L42), [44](../src/supply_drops.opy#L44), [45](../src/supply_drops.opy#L45), [47](../src/supply_drops.opy#L47), [49](../src/supply_drops.opy#L49), [50](../src/supply_drops.opy#L50).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [62](../src/supply_drops.opy#L62), [64](../src/supply_drops.opy#L64), [66](../src/supply_drops.opy#L66), [68](../src/supply_drops.opy#L68), [72](../src/supply_drops.opy#L72), [74](../src/supply_drops.opy#L74).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [97](../src/supply_drops.opy#L97).

## supplyDropPosition

Объявление: [variables.opy:226](../src/variables.opy#L226). Строк обращений: 14; упоминаний: 20; чтений вида Global в скомпилированном коде: 16.

- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [28](../src/supply_drops.opy#L28), [44](../src/supply_drops.opy#L44), [45](../src/supply_drops.opy#L45), [47](../src/supply_drops.opy#L47), [48](../src/supply_drops.opy#L48).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [62](../src/supply_drops.opy#L62), [64](../src/supply_drops.opy#L64), [68](../src/supply_drops.opy#L68), [72](../src/supply_drops.opy#L72), [74](../src/supply_drops.opy#L74).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [87](../src/supply_drops.opy#L87), [88](../src/supply_drops.opy#L88).

## isSupplyDropOpen

Объявление: [variables.opy:227](../src/variables.opy#L227). Строк обращений: 8; упоминаний: 8; чтений вида Global в скомпилированном коде: 5.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [247](../src/global_startup.opy#L247).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [19](../src/supply_drops.opy#L19), [29](../src/supply_drops.opy#L29).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [64](../src/supply_drops.opy#L64), [68](../src/supply_drops.opy#L68).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [86](../src/supply_drops.opy#L86).

## supplyDropPowerUpCount

Объявление: [variables.opy:228](../src/variables.opy#L228). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [259](../src/global_startup.opy#L259).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [91](../src/supply_drops.opy#L91), [96](../src/supply_drops.opy#L96).

## supplyPowerUpIdList

Объявление: [variables.opy:229](../src/variables.opy#L229). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 5.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [250](../src/global_startup.opy#L250).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [93](../src/objective_types/objective_type_biomorphing.opy#L93).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [93](../src/supply_drops.opy#L93), [108](../src/supply_drops.opy#L108), [112](../src/supply_drops.opy#L112), [119](../src/supply_drops.opy#L119).
- power_ups.opy — macro powerUpAssignmentMacro(): [7](../src/power_ups.opy#L7), [8](../src/power_ups.opy#L8), [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)": [82](../src/power_ups.opy#L82).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)": [96](../src/power_ups.opy#L96).

## supplyPowerUpPositionList

Объявление: [variables.opy:230](../src/variables.opy#L230). Строк обращений: 16; упоминаний: 18; чтений вида Global в скомпилированном коде: 11.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [251](../src/global_startup.opy#L251).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [94](../src/objective_types/objective_type_biomorphing.opy#L94).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [23](../src/supply_drops.opy#L23), [52](../src/supply_drops.opy#L52).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [70](../src/supply_drops.opy#L70).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [97](../src/supply_drops.opy#L97), [98](../src/supply_drops.opy#L98), [100](../src/supply_drops.opy#L100), [105](../src/supply_drops.opy#L105), [113](../src/supply_drops.opy#L113), [120](../src/supply_drops.opy#L120).
- power_ups.opy — macro powerUpAssignmentMacro(): [8](../src/power_ups.opy#L8), [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [14](../src/power_ups.opy#L14).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)": [83](../src/power_ups.opy#L83).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)": [97](../src/power_ups.opy#L97).

## supplyPowerUpTextIdList

Объявление: [variables.opy:231](../src/variables.opy#L231). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [253](../src/global_startup.opy#L253).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [110](../src/supply_drops.opy#L110), [115](../src/supply_drops.opy#L115).
- power_ups.opy — macro powerUpAssignmentMacro(): [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [18](../src/power_ups.opy#L18).

## supplyPowerUpEffectIdList

Объявление: [variables.opy:232](../src/variables.opy#L232). Строк обращений: 8; упоминаний: 10; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [252](../src/global_startup.opy#L252).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [109](../src/supply_drops.opy#L109), [114](../src/supply_drops.opy#L114).
- power_ups.opy — macro powerUpAssignmentMacro(): [7](../src/power_ups.opy#L7), [8](../src/power_ups.opy#L8), [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [14](../src/power_ups.opy#L14), [17](../src/power_ups.opy#L17).

## playerTargetList

Объявление: [variables.opy:235](../src/variables.opy#L235). Строк обращений: 58; упоминаний: 62; чтений вида Global в скомпилированном коде: 55.

- subroutines.opy — def selectTarget(): [658](../src/subroutines.opy#L658), [662](../src/subroutines.opy#L662), [664](../src/subroutines.opy#L664), [666](../src/subroutines.opy#L666).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [254](../src/global_startup.opy#L254).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [25](../src/global_game_in_progress.opy#L25).
- global_game_in_progress.opy — rule "PLAYER LEAVES THE GAME": [118](../src/global_game_in_progress.opy#L118), [120](../src/global_game_in_progress.opy#L120).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [19](../src/objective_types/objective_type_extraction_point.opy#L19).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71), [73](../src/objective_types/objective_type_extraction_point.opy#L73), [89](../src/objective_types/objective_type_extraction_point.opy#L89), [92](../src/objective_types/objective_type_extraction_point.opy#L92).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [82](../src/objective_types/objective_type_survivor_rescue.opy#L82), [88](../src/objective_types/objective_type_survivor_rescue.opy#L88), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [91](../src/objective_types/objective_type_survivor_rescue.opy#L91), [93](../src/objective_types/objective_type_survivor_rescue.opy#L93), [99](../src/objective_types/objective_type_survivor_rescue.opy#L99).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [7](../src/objective_types/objective_type_kill_zone.opy#L7).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [64](../src/objective_types/objective_type_zombie_egg.opy#L64).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [155](../src/players_game_in_progress.opy#L155), [156](../src/players_game_in_progress.opy#L156).
- players_game_in_progress.opy — rule "PLAYER AFK": [275](../src/players_game_in_progress.opy#L275).
- players_game_in_progress.opy — rule "PLAYER TARGET (ADD)": [333](../src/players_game_in_progress.opy#L333), [337](../src/players_game_in_progress.opy#L337).
- players_game_in_progress.opy — rule "PLAYER TARGET (REMOVE)": [346](../src/players_game_in_progress.opy#L346), [350](../src/players_game_in_progress.opy#L350).
- players_game_in_progress.opy — def teleportToClosestPlayer(): [358](../src/players_game_in_progress.opy#L358).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [13](../src/bots_game_in_progress.opy#L13), [16](../src/bots_game_in_progress.opy#L16), [20](../src/bots_game_in_progress.opy#L20), [26](../src/bots_game_in_progress.opy#L26), [28](../src/bots_game_in_progress.opy#L28), [39](../src/bots_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING": [102](../src/bots_game_in_progress.opy#L102).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG": [190](../src/bots_game_in_progress.opy#L190).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE": [240](../src/bots_game_in_progress.opy#L240), [241](../src/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET": [267](../src/bots_game_in_progress.opy#L267).
- bots_game_in_progress.opy — def teleportBots(): [456](../src/bots_game_in_progress.opy#L456), [470](../src/bots_game_in_progress.opy#L470).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [490](../src/bots_game_in_progress.opy#L490), [492](../src/bots_game_in_progress.opy#L492), [493](../src/bots_game_in_progress.opy#L493), [496](../src/bots_game_in_progress.opy#L496), [497](../src/bots_game_in_progress.opy#L497).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD": [180](../src/zombie_types.opy#L180).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)": [239](../src/zombie_types.opy#L239).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [602](../src/zombie_types.opy#L602), [603](../src/zombie_types.opy#L603).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1286](../src/zombie_types.opy#L1286).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35), [38](../src/supply_drops.opy#L38).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [117](../src/enhancements.opy#L117).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [418](../src/enhancements.opy#L418).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH": [442](../src/enhancements.opy#L442), [444](../src/enhancements.opy#L444).

## userNameList

Объявление: [variables.opy:236](../src/variables.opy#L236). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [237](../src/global_startup.opy#L237).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [64](../src/players_game_in_progress.opy#L64), [71](../src/players_game_in_progress.opy#L71).
- players_game_in_progress.opy — def updateUsers(): [364](../src/players_game_in_progress.opy#L364), [366](../src/players_game_in_progress.opy#L366), [368](../src/players_game_in_progress.opy#L368).

## playerStatsList

Объявление: [variables.opy:237](../src/variables.opy#L237). Строк обращений: 13; упоминаний: 13; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [238](../src/global_startup.opy#L238), [241](../src/global_startup.opy#L241).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [72](../src/players_game_in_progress.opy#L72), [73](../src/players_game_in_progress.opy#L73), [74](../src/players_game_in_progress.opy#L74), [75](../src/players_game_in_progress.opy#L75), [79](../src/players_game_in_progress.opy#L79), [80](../src/players_game_in_progress.opy#L80), [85](../src/players_game_in_progress.opy#L85).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [154](../src/players_game_in_progress.opy#L154), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## healthpackPositionList

Объявление: [variables.opy:238](../src/variables.opy#L238). Строк обращений: 6; упоминаний: 9; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [234](../src/global_startup.opy#L234).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [214](../src/players_game_in_progress.opy#L214), [215](../src/players_game_in_progress.opy#L215).

## mustReviveTime

Объявление: [variables.opy:239](../src/variables.opy#L239). Строк обращений: 5; упоминаний: 6; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [245](../src/global_startup.opy#L245).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [59](../src/players_game_in_progress.opy#L59).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [186](../src/players_game_in_progress.opy#L186), [188](../src/players_game_in_progress.opy#L188), [201](../src/players_game_in_progress.opy#L201).

## botHeroList

Объявление: [variables.opy:242](../src/variables.opy#L242). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro botStatManagementMacro(): [33](../src/subroutines.opy#L33).
- subroutines.opy — def botRespawnInitialization(): [708](../src/subroutines.opy#L708).
- global_startup.opy — macro botHeroRandomizationMacro(): [52](../src/global_startup.opy#L52), [68](../src/global_startup.opy#L68), [70](../src/global_startup.opy#L70).
- global_start_menu.opy — def setZombieMode(): [293](../src/global_start_menu.opy#L293).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [12](../src/objective_types/objective_type_bosses.opy#L12).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [43](../src/objective_types/objective_type_bosses.opy#L43), [45](../src/objective_types/objective_type_bosses.opy#L45).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [9](../src/objective_types/objective_type_zombie_egg.opy#L9).

## botSpawnRateList

Объявление: [variables.opy:243](../src/variables.opy#L243). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — macro botHeroRandomizationMacro(): [67](../src/global_startup.opy#L67), [70](../src/global_startup.opy#L70).
- global_start_menu.opy — def setZombieMode(): [299](../src/global_start_menu.opy#L299), [303](../src/global_start_menu.opy#L303), [307](../src/global_start_menu.opy#L307), [310](../src/global_start_menu.opy#L310), [314](../src/global_start_menu.opy#L314), [318](../src/global_start_menu.opy#L318), [322](../src/global_start_menu.opy#L322).
- global_game_in_progress.opy — rule "ZOMBIE SHUFFLE": [70](../src/global_game_in_progress.opy#L70).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [45](../src/objective_types/objective_type_bosses.opy#L45).

## botBiteDamageList

Объявление: [variables.opy:244](../src/variables.opy#L244). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [34](../src/subroutines.opy#L34).
- subroutines.opy — def setDifficulty(): [406](../src/subroutines.opy#L406), [429](../src/subroutines.opy#L429), [441](../src/subroutines.opy#L441), [453](../src/subroutines.opy#L453), [463](../src/subroutines.opy#L463).

## botBiteDurationList

Объявление: [variables.opy:245](../src/variables.opy#L245). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [37](../src/subroutines.opy#L37).
- subroutines.opy — def setDifficulty(): [408](../src/subroutines.opy#L408), [425](../src/subroutines.opy#L425), [431](../src/subroutines.opy#L431), [443](../src/subroutines.opy#L443).

## botDamageDealtList

Объявление: [variables.opy:246](../src/variables.opy#L246). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro botStatManagementMacro(): [36](../src/subroutines.opy#L36), [41](../src/subroutines.opy#L41).
- subroutines.opy — def setDifficulty(): [415](../src/subroutines.opy#L415), [435](../src/subroutines.opy#L435), [447](../src/subroutines.opy#L447), [457](../src/subroutines.opy#L457), [467](../src/subroutines.opy#L467).

## botHealthList

Объявление: [variables.opy:247](../src/variables.opy#L247). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — def setDifficulty(): [404](../src/subroutines.opy#L404), [423](../src/subroutines.opy#L423), [439](../src/subroutines.opy#L439), [451](../src/subroutines.opy#L451), [461](../src/subroutines.opy#L461).
- subroutines.opy — def botRespawnInitialization(): [708](../src/subroutines.opy#L708).

## botThrottleSpeedList

Объявление: [variables.opy:248](../src/variables.opy#L248). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [39](../src/subroutines.opy#L39).
- subroutines.opy — def setDifficulty(): [410](../src/subroutines.opy#L410), [413](../src/subroutines.opy#L413), [433](../src/subroutines.opy#L433), [445](../src/subroutines.opy#L445), [455](../src/subroutines.opy#L455), [465](../src/subroutines.opy#L465).

## availableMutationList

Объявление: [variables.opy:249](../src/variables.opy#L249). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78), [79](../src/subroutines.opy#L79).
- global_startup.opy — macro enableMutationsMacro(): [74](../src/global_startup.opy#L74), [81](../src/global_startup.opy#L81).

## miniBossList

Объявление: [variables.opy:250](../src/variables.opy#L250). Строк обращений: 16; упоминаний: 17; чтений вида Global в скомпилированном коде: 14.

- subroutines.opy — macro minibossMutationMacro(): [18](../src/subroutines.opy#L18).
- subroutines.opy — macro botEntityManagementMacro(): [179](../src/subroutines.opy#L179).
- subroutines.opy — def selectTarget(): [655](../src/subroutines.opy#L655).
- subroutines.opy — def botRespawnInitialization(): [727](../src/subroutines.opy#L727), [734](../src/subroutines.opy#L734).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [36](../src/objective_types/objective_type_bosses.opy#L36).
- bots_game_in_progress.opy — rule "BOT DIES": [134](../src/bots_game_in_progress.opy#L134), [145](../src/bots_game_in_progress.opy#L145).
- bots_game_in_progress.opy — rule "BOT TAKES DAMAGE AND SWITCHES TARGETS": [254](../src/bots_game_in_progress.opy#L254).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)": [398](../src/bots_game_in_progress.opy#L398).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE": [525](../src/bots_game_in_progress.opy#L525).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [406](../src/zombie_types.opy#L406).
- zombie_types.opy — rule "PROTECTOR (KIRIKO) USES CLEANSE": [1346](../src/zombie_types.opy#L1346).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)": [1385](../src/zombie_types.opy#L1385).
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1409](../src/zombie_types.opy#L1409).

## bossStateList

Объявление: [variables.opy:251](../src/variables.opy#L251). Строк обращений: 110; упоминаний: 121; чтений вида Global в скомпилированном коде: 112.

Алиасы ролей: `bossesStateList`, `zombieEggStateList`.

- subroutines.opy — macro minibossMutationMacro(): [27](../src/subroutines.opy#L27).
- subroutines.opy — macro botStatManagementMacro(): [56](../src/subroutines.opy#L56).
- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78).
- subroutines.opy — macro botEntityManagementMacro(): [126](../src/subroutines.opy#L126), [137](../src/subroutines.opy#L137), [168](../src/subroutines.opy#L168), [184](../src/subroutines.opy#L184), [204](../src/subroutines.opy#L204), [207](../src/subroutines.opy#L207).
- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [281](../src/subroutines.opy#L281), [287](../src/subroutines.opy#L287), [290](../src/subroutines.opy#L290), [352](../src/subroutines.opy#L352), [364](../src/subroutines.opy#L364).
- subroutines.opy — def objectivesManagement(): [576](../src/subroutines.opy#L576).
- subroutines.opy — def selectTarget(): [660](../src/subroutines.opy#L660).
- subroutines.opy — def botRespawnInitialization(): [701](../src/subroutines.opy#L701), [727](../src/subroutines.opy#L727).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [233](../src/global_startup.opy#L233).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [54](../src/global_game_in_progress.opy#L54), [60](../src/global_game_in_progress.opy#L60), [62](../src/global_game_in_progress.opy#L62).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [98](../src/global_game_in_progress.opy#L98).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [9](../src/objective_types/objective_type_bosses.opy#L9), [15](../src/objective_types/objective_type_bosses.opy#L15), [16](../src/objective_types/objective_type_bosses.opy#L16), [17](../src/objective_types/objective_type_bosses.opy#L17), [18](../src/objective_types/objective_type_bosses.opy#L18), [19](../src/objective_types/objective_type_bosses.opy#L19), [20](../src/objective_types/objective_type_bosses.opy#L20), [21](../src/objective_types/objective_type_bosses.opy#L21), [22](../src/objective_types/objective_type_bosses.opy#L22), [23](../src/objective_types/objective_type_bosses.opy#L23).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [34](../src/objective_types/objective_type_bosses.opy#L34), [75](../src/objective_types/objective_type_bosses.opy#L75), [80](../src/objective_types/objective_type_bosses.opy#L80).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK": [94](../src/objective_types/objective_type_bosses.opy#L94), [95](../src/objective_types/objective_type_bosses.opy#L95).
- objective_types/objective_type_bosses.opy — rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)": [112](../src/objective_types/objective_type_bosses.opy#L112).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)": [122](../src/objective_types/objective_type_bosses.opy#L122), [149](../src/objective_types/objective_type_bosses.opy#L149), [160](../src/objective_types/objective_type_bosses.opy#L160).
- objective_types/objective_type_bosses.opy — rule "BOSS TAKES KNOCKBACK": [174](../src/objective_types/objective_type_bosses.opy#L174).
- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED": [183](../src/objective_types/objective_type_bosses.opy#L183).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [7](../src/objective_types/objective_type_zombie_egg.opy#L7), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [22](../src/objective_types/objective_type_zombie_egg.opy#L22), [28](../src/objective_types/objective_type_zombie_egg.opy#L28), [46](../src/objective_types/objective_type_zombie_egg.opy#L46).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [62](../src/objective_types/objective_type_zombie_egg.opy#L62), [63](../src/objective_types/objective_type_zombie_egg.opy#L63).
- objective_types/objective_type_zombie_egg.opy — rule "EGG SWITCHES THE POSITION FOR YOU": [80](../src/objective_types/objective_type_zombie_egg.opy#L80).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [16](../src/bots_game_in_progress.opy#L16).
- bots_game_in_progress.opy — rule "Fix bot health": [51](../src/bots_game_in_progress.opy#L51).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [86](../src/bots_game_in_progress.opy#L86).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING": [100](../src/bots_game_in_progress.opy#L100).
- bots_game_in_progress.opy — rule "BOT DIES": [118](../src/bots_game_in_progress.opy#L118).
- bots_game_in_progress.opy — rule "TELEPORT BOTS (GENERAL)": [173](../src/bots_game_in_progress.opy#L173).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG": [189](../src/bots_game_in_progress.opy#L189).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS": [222](../src/bots_game_in_progress.opy#L222).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS": [331](../src/bots_game_in_progress.opy#L331), [341](../src/bots_game_in_progress.opy#L341), [349](../src/bots_game_in_progress.opy#L349).
- bots_game_in_progress.opy — rule "BOTS MELEE": [362](../src/bots_game_in_progress.opy#L362).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)": [398](../src/bots_game_in_progress.opy#L398).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)": [25](../src/zombie_types.opy#L25).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS": [90](../src/zombie_types.opy#L90).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)": [107](../src/zombie_types.opy#L107).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD": [164](../src/zombie_types.opy#L164), [173](../src/zombie_types.opy#L173), [186](../src/zombie_types.opy#L186), [190](../src/zombie_types.opy#L190).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)": [314](../src/zombie_types.opy#L314).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES": [332](../src/zombie_types.opy#L332).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [405](../src/zombie_types.opy#L405).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS": [435](../src/zombie_types.opy#L435).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE": [554](../src/zombie_types.opy#L554), [564](../src/zombie_types.opy#L564).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [623](../src/zombie_types.opy#L623).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)": [642](../src/zombie_types.opy#L642).
- zombie_types.opy — rule "STRIKER NORMAL PILE DRIVER": [747](../src/zombie_types.opy#L747).
- zombie_types.opy — rule "STALKER (MOIRA) FADE": [768](../src/zombie_types.opy#L768), [773](../src/zombie_types.opy#L773), [786](../src/zombie_types.opy#L786), [801](../src/zombie_types.opy#L801).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES": [861](../src/zombie_types.opy#L861).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES": [909](../src/zombie_types.opy#L909).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER": [926](../src/zombie_types.opy#L926), [939](../src/zombie_types.opy#L939).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST": [1012](../src/zombie_types.opy#L1012), [1014](../src/zombie_types.opy#L1014), [1015](../src/zombie_types.opy#L1015), [1053](../src/zombie_types.opy#L1053), [1069](../src/zombie_types.opy#L1069), [1071](../src/zombie_types.opy#L1071).
- zombie_types.opy — rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)": [1083](../src/zombie_types.opy#L1083).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH": [1115](../src/zombie_types.opy#L1115).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS": [1150](../src/zombie_types.opy#L1150), [1155](../src/zombie_types.opy#L1155).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER": [1202](../src/zombie_types.opy#L1202).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE": [1226](../src/zombie_types.opy#L1226).
- zombie_types.opy — rule "SMOLDER BOSS SLAM": [1252](../src/zombie_types.opy#L1252).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1281](../src/zombie_types.opy#L1281).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1298](../src/zombie_types.opy#L1298).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS": [1311](../src/zombie_types.opy#L1311).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT": [1337](../src/zombie_types.opy#L1337).
- supply_drops.opy — def stun(): [428](../src/supply_drops.opy#L428), [432](../src/supply_drops.opy#L432).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE": [274](../src/enhancements.opy#L274).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [302](../src/enhancements.opy#L302).

## isSmolderEventActive

Объявление: [variables.opy:254](../src/variables.opy#L254). Строк обращений: 12; упоминаний: 13; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro botEntityManagementMacro(): [209](../src/subroutines.opy#L209), [212](../src/subroutines.opy#L212).
- subroutines.opy — def objectivesManagement(): [530](../src/subroutines.opy#L530).
- global_startup.opy — macro botHeroRandomizationMacro(): [53](../src/global_startup.opy#L53).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [97](../src/global_game_in_progress.opy#L97).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS": [121](../src/players_game_in_progress.opy#L121).
- zombie_types.opy — rule "SMOLDER BOSS SLAM": [1248](../src/zombie_types.opy#L1248).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1296](../src/zombie_types.opy#L1296).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS": [1315](../src/zombie_types.opy#L1315), [1322](../src/zombie_types.opy#L1322), [1325](../src/zombie_types.opy#L1325).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT": [1336](../src/zombie_types.opy#L1336).

## bossesAvailableHeroList

Объявление: [variables.opy:257](../src/variables.opy#L257). Строк обращений: 8; упоминаний: 8; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [255](../src/global_startup.opy#L255).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [41](../src/objective_types/objective_type_bosses.opy#L41), [43](../src/objective_types/objective_type_bosses.opy#L43), [45](../src/objective_types/objective_type_bosses.opy#L45), [46](../src/objective_types/objective_type_bosses.opy#L46), [47](../src/objective_types/objective_type_bosses.opy#L47), [50](../src/objective_types/objective_type_bosses.opy#L50), [55](../src/objective_types/objective_type_bosses.opy#L55).

## bossesExcludedHeroList

Объявление: [variables.opy:258](../src/variables.opy#L258). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_start_menu.opy — def setZombieMode(): [295](../src/global_start_menu.opy#L295).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [46](../src/objective_types/objective_type_bosses.opy#L46), [47](../src/objective_types/objective_type_bosses.opy#L47).

## numbersList

Объявление: [compressed numbers.opy:6](../src/compressed%20numbers.opy#L6). Строк обращений: 28; упоминаний: 28; чтений вида Global в скомпилированном коде: 28.

- subroutines.opy — def setDifficulty(): [404](../src/subroutines.opy#L404), [406](../src/subroutines.opy#L406), [408](../src/subroutines.opy#L408), [415](../src/subroutines.opy#L415), [423](../src/subroutines.opy#L423), [425](../src/subroutines.opy#L425), [429](../src/subroutines.opy#L429), [431](../src/subroutines.opy#L431), [433](../src/subroutines.opy#L433), [435](../src/subroutines.opy#L435), [441](../src/subroutines.opy#L441), [443](../src/subroutines.opy#L443), [445](../src/subroutines.opy#L445), [447](../src/subroutines.opy#L447), [451](../src/subroutines.opy#L451), [453](../src/subroutines.opy#L453), [455](../src/subroutines.opy#L455), [457](../src/subroutines.opy#L457), [463](../src/subroutines.opy#L463), [465](../src/subroutines.opy#L465), [467](../src/subroutines.opy#L467).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [81](../src/global_start_menu.opy#L81), [109](../src/global_start_menu.opy#L109).
- global_start_menu.opy — def setZombieMode(): [299](../src/global_start_menu.opy#L299), [303](../src/global_start_menu.opy#L303), [314](../src/global_start_menu.opy#L314), [318](../src/global_start_menu.opy#L318), [322](../src/global_start_menu.opy#L322).

## debugHud

Объявление: [debug.opy:7](../src/debug.opy#L7). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 1.

- debug.opy — rule "[debug] Resource usage and server load": [30](../src/debug.opy#L30), [33](../src/debug.opy#L33).
