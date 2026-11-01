# Все обращения к глобальным переменным — обновлено 2026-11-02

Сгенерировано `node analysis/audit-global-variables.cjs`. Только файлы, подключённые из `main.opy`.

В строках исключены комментарии, текстовые литералы, объявления и одноимённые поля игрока. Макросы учтены один раз в исходнике; ссылки на глобальные переменные в `#!define` сохранены. Инициализаторы констант находятся по ссылке на объявление. Полные тексты строк доступны в JSON.

Количество ссылок в скомпилированном Workshop учитывает раскрытие макросов и оптимизации. Само по себе оно не показывает частоту исполнения или время жизни.

## tmp0

Объявление: [variables.opy:65](../src/variables.opy#L65). Строк обращений: 195; упоминаний: 227; чтений вида Global в скомпилированном коде: 161.

- subroutines.opy — macro botStatManagementMacro(): [33](../src/subroutines.opy#L33), [34](../src/subroutines.opy#L34), [36](../src/subroutines.opy#L36), [37](../src/subroutines.opy#L37), [39](../src/subroutines.opy#L39), [41](../src/subroutines.opy#L41), [42](../src/subroutines.opy#L42).
- subroutines.opy — macro botEntityManagementMacro(): [145](../src/subroutines.opy#L145), [147](../src/subroutines.opy#L147), [150](../src/subroutines.opy#L150).
- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [242](../src/subroutines.opy#L242), [243](../src/subroutines.opy#L243), [381](../src/subroutines.opy#L381), [383](../src/subroutines.opy#L383), [386](../src/subroutines.opy#L386), [389](../src/subroutines.opy#L389), [392](../src/subroutines.opy#L392).
- subroutines.opy — def setDifficulty(): [411](../src/subroutines.opy#L411).
- subroutines.opy — def selectTarget(): [669](../src/subroutines.opy#L669), [670](../src/subroutines.opy#L670).
- subroutines.opy — def botRespawnInitialization(): [726](../src/subroutines.opy#L726), [727](../src/subroutines.opy#L727).
- global_startup.opy — macro botHeroRandomizationMacro(): [52](../src/global_startup.opy#L52), [56](../src/global_startup.opy#L56), [58](../src/global_startup.opy#L58), [63](../src/global_startup.opy#L63).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [240](../src/global_startup.opy#L240).
- global_startup.opy — def generateMapGrid(): [303](../src/global_startup.opy#L303), [305](../src/global_startup.opy#L305), [306](../src/global_startup.opy#L306), [307](../src/global_startup.opy#L307).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [45](../src/global_start_menu.opy#L45), [46](../src/global_start_menu.opy#L46).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [215](../src/global_start_menu.opy#L215), [216](../src/global_start_menu.opy#L216), [218](../src/global_start_menu.opy#L218), [220](../src/global_start_menu.opy#L220).
- global_start_menu.opy — def determineZombieMode(): [267](../src/global_start_menu.opy#L267), [268](../src/global_start_menu.opy#L268), [269](../src/global_start_menu.opy#L269), [271](../src/global_start_menu.opy#L271), [273](../src/global_start_menu.opy#L273), [274](../src/global_start_menu.opy#L274), [275](../src/global_start_menu.opy#L275), [276](../src/global_start_menu.opy#L276), [279](../src/global_start_menu.opy#L279).
- global_start_menu.opy — def setZombieMode(): [307](../src/global_start_menu.opy#L307).
- global_start_menu.opy — def determineChallenge(): [328](../src/global_start_menu.opy#L328), [329](../src/global_start_menu.opy#L329), [330](../src/global_start_menu.opy#L330), [332](../src/global_start_menu.opy#L332), [336](../src/global_start_menu.opy#L336), [338](../src/global_start_menu.opy#L338), [342](../src/global_start_menu.opy#L342), [344](../src/global_start_menu.opy#L344), [345](../src/global_start_menu.opy#L345), [346](../src/global_start_menu.opy#L346), [348](../src/global_start_menu.opy#L348), [349](../src/global_start_menu.opy#L349).
- global_start_menu.opy — def determineObjectiveType(): [361](../src/global_start_menu.opy#L361), [362](../src/global_start_menu.opy#L362), [363](../src/global_start_menu.opy#L363), [365](../src/global_start_menu.opy#L365), [367](../src/global_start_menu.opy#L367), [368](../src/global_start_menu.opy#L368), [369](../src/global_start_menu.opy#L369), [370](../src/global_start_menu.opy#L370), [373](../src/global_start_menu.opy#L373).
- player_start_menu.opy — def randomActions(): [238](../src/player_start_menu.opy#L238), [240](../src/player_start_menu.opy#L240), [242](../src/player_start_menu.opy#L242), [244](../src/player_start_menu.opy#L244), [250](../src/player_start_menu.opy#L250), [252](../src/player_start_menu.opy#L252), [254](../src/player_start_menu.opy#L254), [256](../src/player_start_menu.opy#L256).
- objective_types/objective_type_biomorphing.opy — macro biowasteOutputMacro(): [7](../src/objective_types/objective_type_biomorphing.opy#L7).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [15](../src/objective_types/objective_type_biomorphing.opy#L15), [17](../src/objective_types/objective_type_biomorphing.opy#L17), [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [82](../src/objective_types/objective_type_biomorphing.opy#L82), [86](../src/objective_types/objective_type_biomorphing.opy#L86), [89](../src/objective_types/objective_type_biomorphing.opy#L89), [92](../src/objective_types/objective_type_biomorphing.opy#L92), [94](../src/objective_types/objective_type_biomorphing.opy#L94).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [114](../src/objective_types/objective_type_biomorphing.opy#L114), [116](../src/objective_types/objective_type_biomorphing.opy#L116).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [145](../src/objective_types/objective_type_biomorphing.opy#L145), [149](../src/objective_types/objective_type_biomorphing.opy#L149), [155](../src/objective_types/objective_type_biomorphing.opy#L155).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [187](../src/objective_types/objective_type_biomorphing.opy#L187).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [57](../src/objective_types/objective_type_survivor_rescue.opy#L57), [59](../src/objective_types/objective_type_survivor_rescue.opy#L59).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [13](../src/objective_types/objective_type_satellite_uplink.opy#L13), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14), [34](../src/objective_types/objective_type_satellite_uplink.opy#L34), [35](../src/objective_types/objective_type_satellite_uplink.opy#L35), [50](../src/objective_types/objective_type_satellite_uplink.opy#L50), [51](../src/objective_types/objective_type_satellite_uplink.opy#L51), [52](../src/objective_types/objective_type_satellite_uplink.opy#L52), [54](../src/objective_types/objective_type_satellite_uplink.opy#L54), [56](../src/objective_types/objective_type_satellite_uplink.opy#L56).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [75](../src/objective_types/objective_type_satellite_uplink.opy#L75), [77](../src/objective_types/objective_type_satellite_uplink.opy#L77), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [84](../src/objective_types/objective_type_satellite_uplink.opy#L84), [86](../src/objective_types/objective_type_satellite_uplink.opy#L86).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [123](../src/objective_types/objective_type_satellite_uplink.opy#L123), [124](../src/objective_types/objective_type_satellite_uplink.opy#L124), [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126), [128](../src/objective_types/objective_type_satellite_uplink.opy#L128), [130](../src/objective_types/objective_type_satellite_uplink.opy#L130), [132](../src/objective_types/objective_type_satellite_uplink.opy#L132), [133](../src/objective_types/objective_type_satellite_uplink.opy#L133), [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136).
- bots_game_in_progress.opy — rule "BOT DIES": [129](../src/bots_game_in_progress.opy#L129), [130](../src/bots_game_in_progress.opy#L130).
- bots_game_in_progress.opy — def teleportBots(): [458](../src/bots_game_in_progress.opy#L458), [461](../src/bots_game_in_progress.opy#L461), [463](../src/bots_game_in_progress.opy#L463), [464](../src/bots_game_in_progress.opy#L464).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [492](../src/bots_game_in_progress.opy#L492), [493](../src/bots_game_in_progress.opy#L493), [496](../src/bots_game_in_progress.opy#L496), [497](../src/bots_game_in_progress.opy#L497), [498](../src/bots_game_in_progress.opy#L498).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)": [48](../src/zombie_types.opy#L48), [49](../src/zombie_types.opy#L49).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)": [236](../src/zombie_types.opy#L236), [237](../src/zombie_types.opy#L237), [238](../src/zombie_types.opy#L238), [239](../src/zombie_types.opy#L239).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)": [674](../src/zombie_types.opy#L674), [675](../src/zombie_types.opy#L675).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1288](../src/zombie_types.opy#L1288), [1289](../src/zombie_types.opy#L1289).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35), [37](../src/supply_drops.opy#L37).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [91](../src/supply_drops.opy#L91), [96](../src/supply_drops.opy#L96), [97](../src/supply_drops.opy#L97).
- supply_drops.opy — def playerForceField(): [152](../src/supply_drops.opy#L152), [153](../src/supply_drops.opy#L153), [154](../src/supply_drops.opy#L154).
- supply_drops.opy — def airStrike(): [207](../src/supply_drops.opy#L207), [210](../src/supply_drops.opy#L210), [211](../src/supply_drops.opy#L211), [212](../src/supply_drops.opy#L212), [213](../src/supply_drops.opy#L213), [214](../src/supply_drops.opy#L214), [216](../src/supply_drops.opy#L216).
- supply_drops.opy — def sentryTurret(): [262](../src/supply_drops.opy#L262), [263](../src/supply_drops.opy#L263), [264](../src/supply_drops.opy#L264), [276](../src/supply_drops.opy#L276), [279](../src/supply_drops.opy#L279), [280](../src/supply_drops.opy#L280), [283](../src/supply_drops.opy#L283), [284](../src/supply_drops.opy#L284).
- supply_drops.opy — def bouncePad(): [377](../src/supply_drops.opy#L377), [378](../src/supply_drops.opy#L378), [381](../src/supply_drops.opy#L381), [384](../src/supply_drops.opy#L384), [386](../src/supply_drops.opy#L386).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [30](../src/power_ups.opy#L30), [32](../src/power_ups.opy#L32), [47](../src/power_ups.opy#L47), [63](../src/power_ups.opy#L63), [66](../src/power_ups.opy#L66), [67](../src/power_ups.opy#L67), [68](../src/power_ups.opy#L68).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES": [238](../src/enhancements.opy#L238), [239](../src/enhancements.opy#L239).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [297](../src/enhancements.opy#L297), [298](../src/enhancements.opy#L298), [300](../src/enhancements.opy#L300), [301](../src/enhancements.opy#L301), [304](../src/enhancements.opy#L304), [305](../src/enhancements.opy#L305).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [420](../src/enhancements.opy#L420), [421](../src/enhancements.opy#L421), [422](../src/enhancements.opy#L422), [423](../src/enhancements.opy#L423), [424](../src/enhancements.opy#L424).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH": [445](../src/enhancements.opy#L445), [447](../src/enhancements.opy#L447), [449](../src/enhancements.opy#L449), [451](../src/enhancements.opy#L451), [453](../src/enhancements.opy#L453), [455](../src/enhancements.opy#L455).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [495](../src/enhancements.opy#L495), [500](../src/enhancements.opy#L500), [501](../src/enhancements.opy#L501).

## tmp1

Объявление: [variables.opy:66](../src/variables.opy#L66). Строк обращений: 46; упоминаний: 49; чтений вида Global в скомпилированном коде: 31.

- global_startup.opy — macro botHeroRandomizationMacro(): [60](../src/global_startup.opy#L60), [63](../src/global_startup.opy#L63), [67](../src/global_startup.opy#L67).
- global_start_menu.opy — def determineChallenge(): [334](../src/global_start_menu.opy#L334), [338](../src/global_start_menu.opy#L338), [340](../src/global_start_menu.opy#L340), [348](../src/global_start_menu.opy#L348).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [16](../src/objective_types/objective_type_biomorphing.opy#L16), [17](../src/objective_types/objective_type_biomorphing.opy#L17), [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [84](../src/objective_types/objective_type_biomorphing.opy#L84), [86](../src/objective_types/objective_type_biomorphing.opy#L86), [87](../src/objective_types/objective_type_biomorphing.opy#L87), [89](../src/objective_types/objective_type_biomorphing.opy#L89).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [116](../src/objective_types/objective_type_biomorphing.opy#L116), [117](../src/objective_types/objective_type_biomorphing.opy#L117), [118](../src/objective_types/objective_type_biomorphing.opy#L118), [119](../src/objective_types/objective_type_biomorphing.opy#L119), [120](../src/objective_types/objective_type_biomorphing.opy#L120), [121](../src/objective_types/objective_type_biomorphing.opy#L121), [122](../src/objective_types/objective_type_biomorphing.opy#L122), [123](../src/objective_types/objective_type_biomorphing.opy#L123).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [189](../src/objective_types/objective_type_biomorphing.opy#L189).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [80](../src/objective_types/objective_type_satellite_uplink.opy#L80), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [37](../src/supply_drops.opy#L37), [38](../src/supply_drops.opy#L38), [40](../src/supply_drops.opy#L40).
- supply_drops.opy — def airStrike(): [216](../src/supply_drops.opy#L216), [217](../src/supply_drops.opy#L217), [218](../src/supply_drops.opy#L218).
- supply_drops.opy — def bouncePad(): [381](../src/supply_drops.opy#L381), [384](../src/supply_drops.opy#L384).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [28](../src/power_ups.opy#L28), [66](../src/power_ups.opy#L66), [67](../src/power_ups.opy#L67), [68](../src/power_ups.opy#L68).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES": [236](../src/enhancements.opy#L236), [247](../src/enhancements.opy#L247), [250](../src/enhancements.opy#L250).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [300](../src/enhancements.opy#L300), [303](../src/enhancements.opy#L303), [304](../src/enhancements.opy#L304).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [497](../src/enhancements.opy#L497), [499](../src/enhancements.opy#L499), [500](../src/enhancements.opy#L500).

## tmp2

Объявление: [variables.opy:67](../src/variables.opy#L67). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

- global_startup.opy — macro botHeroRandomizationMacro(): [62](../src/global_startup.opy#L62), [63](../src/global_startup.opy#L63), [65](../src/global_startup.opy#L65), [67](../src/global_startup.opy#L67), [68](../src/global_startup.opy#L68).
- supply_drops.opy — def bouncePad(): [384](../src/supply_drops.opy#L384), [385](../src/supply_drops.opy#L385).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS": [499](../src/enhancements.opy#L499), [501](../src/enhancements.opy#L501).

## offsetUpThreeQuartersConst

Объявление: [variables.opy:70](../src/variables.opy#L70). Строк обращений: 4; упоминаний: 7; чтений вида Global в скомпилированном коде: 7.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [41](../src/global_start_menu.opy#L41).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [19](../src/objective_types/objective_type_biomorphing.opy#L19).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS": [336](../src/bots_game_in_progress.opy#L336).

## offsetUpHalfConst

Объявление: [variables.opy:71](../src/variables.opy#L71). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 7.

- subroutines.opy — macro botEntityManagementMacro(): [158](../src/subroutines.opy#L158).
- player_start_menu.opy — rule "EFFECTS/TEXT": [45](../src/player_start_menu.opy#L45).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [16](../src/global_game_in_progress.opy#L16).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [595](../src/zombie_types.opy#L595), [608](../src/zombie_types.opy#L608), [617](../src/zombie_types.opy#L617).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [70](../src/supply_drops.opy#L70).

## losOffsetConst

Объявление: [variables.opy:72](../src/variables.opy#L72). Строк обращений: 12; упоминаний: 16; чтений вида Global в скомпилированном коде: 16.

- subroutines.opy — def selectTarget(): [671](../src/subroutines.opy#L671).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG": [190](../src/bots_game_in_progress.opy#L190).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE": [241](../src/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET": [267](../src/bots_game_in_progress.opy#L267).
- bots_game_in_progress.opy — def teleportBots(): [470](../src/bots_game_in_progress.opy#L470).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1285](../src/zombie_types.opy#L1285), [1286](../src/zombie_types.opy#L1286).
- zombie_types.opy — def entityFloat(): [1459](../src/zombie_types.opy#L1459).
- supply_drops.opy — def stun(): [415](../src/supply_drops.opy#L415), [419](../src/supply_drops.opy#L419), [424](../src/supply_drops.opy#L424), [431](../src/supply_drops.opy#L431).

## colorChargeBatteryConst

Объявление: [variables.opy:73](../src/variables.opy#L73). Строк обращений: 2; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [171](../src/global_start_menu.opy#L171).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [99](../src/enhancements.opy#L99).

## dummyHoldingPositionConst

Объявление: [variables.opy:74](../src/variables.opy#L74). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 6.

- global_startup.opy — macro botHeroRandomizationMacro(): [54](../src/global_startup.opy#L54), [68](../src/global_startup.opy#L68), [70](../src/global_startup.opy#L70).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [16](../src/objective_types/objective_type_bosses.opy#L16).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [24](../src/objective_types/objective_type_zombie_egg.opy#L24).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [68](../src/objective_types/objective_type_zombie_egg.opy#L68).

## colorKevlarConst

Объявление: [variables.opy:75](../src/variables.opy#L75). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 2.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [171](../src/global_start_menu.opy#L171).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [20](../src/enhancements.opy#L20).

## isPregameSetup

Объявление: [variables.opy:78](../src/variables.opy#L78). Строк обращений: 39; упоминаний: 40; чтений вида Global в скомпилированном коде: 38.

- subroutines.opy — def enableDisableAbilities(): [505](../src/subroutines.opy#L505).
- global_startup.opy — rule "PREGAME QUICK TIPS FOR PLAYERS": [85](../src/global_startup.opy#L85).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [140](../src/global_startup.opy#L140), [159](../src/global_startup.opy#L159).
- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [175](../src/global_startup.opy#L175), [197](../src/global_startup.opy#L197).
- global_startup.opy — rule "START GAME": [266](../src/global_startup.opy#L266), [277](../src/global_startup.opy#L277).
- global_startup.opy — def generateMapGrid(): [308](../src/global_startup.opy#L308).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [10](../src/global_start_menu.opy#L10).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [211](../src/global_start_menu.opy#L211), [213](../src/global_start_menu.opy#L213).
- global_start_menu.opy — rule "END VOTING": [231](../src/global_start_menu.opy#L231).
- global_start_menu.opy — rule "MUSIC/ANNOUNCER CONTROL": [248](../src/global_start_menu.opy#L248), [253](../src/global_start_menu.opy#L253), [257](../src/global_start_menu.opy#L257).
- global_start_menu.opy — def setObjectiveType(): [389](../src/global_start_menu.opy#L389).
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

Объявление: [variables.opy:79](../src/variables.opy#L79). Строк обращений: 11; упоминаний: 11; чтений вида Global в скомпилированном коде: 10.

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

Объявление: [variables.opy:80](../src/variables.opy#L80). Строк обращений: 40; упоминаний: 41; чтений вида Global в скомпилированном коде: 39.

- subroutines.opy — def objectivesManagement(): [526](../src/subroutines.opy#L526).
- global_startup.opy — rule "SPAWN BOTS": [93](../src/global_startup.opy#L93).
- global_start_menu.opy — def setObjectiveType(): [418](../src/global_start_menu.opy#L418).
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
- enhancements.opy — rule "CHARGE BATTERY": [387](../src/enhancements.opy#L387).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [414](../src/enhancements.opy#L414).
- debug.opy — rule "[debug] Resource usage and server load": [32](../src/debug.opy#L32).

## isOvertimeActive

Объявление: [variables.opy:81](../src/variables.opy#L81). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 1.

- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [52](../src/global_game_in_progress.opy#L52), [58](../src/global_game_in_progress.opy#L58).

## isVoting

Объявление: [variables.opy:82](../src/variables.opy#L82). Строк обращений: 17; упоминаний: 19; чтений вида Global в скомпилированном коде: 17.

- subroutines.opy — def setPrematchTimer(): [476](../src/subroutines.opy#L476).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [143](../src/global_startup.opy#L143).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [53](../src/global_start_menu.opy#L53).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [58](../src/global_start_menu.opy#L58), [66](../src/global_start_menu.opy#L66), [96](../src/global_start_menu.opy#L96), [126](../src/global_start_menu.opy#L126), [162](../src/global_start_menu.opy#L162).
- global_start_menu.opy — rule "END VOTING": [230](../src/global_start_menu.opy#L230), [238](../src/global_start_menu.opy#L238).
- global_start_menu.opy — rule "MUSIC/ANNOUNCER CONTROL": [247](../src/global_start_menu.opy#L247).
- global_start_menu.opy — def determineObjectiveType(): [381](../src/global_start_menu.opy#L381).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [16](../src/player_start_menu.opy#L16).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [88](../src/player_start_menu.opy#L88).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)": [128](../src/player_start_menu.opy#L128).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)": [148](../src/player_start_menu.opy#L148).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)": [168](../src/player_start_menu.opy#L168).

## difficultySetting

Объявление: [variables.opy:83](../src/variables.opy#L83). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 10.

- subroutines.opy — def setDifficulty(): [399](../src/subroutines.opy#L399), [426](../src/subroutines.opy#L426), [436](../src/subroutines.opy#L436), [448](../src/subroutines.opy#L448).
- subroutines.opy — def botRespawnInitialization(): [724](../src/subroutines.opy#L724).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [151](../src/global_startup.opy#L151).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [23](../src/player_start_menu.opy#L23).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [71](../src/objective_types/objective_type_showdown.opy#L71).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [212](../src/players_game_in_progress.opy#L212).
- bots_game_in_progress.opy — rule "BOT DIES": [130](../src/bots_game_in_progress.opy#L130), [131](../src/bots_game_in_progress.opy#L131).

## challengeSetting

Объявление: [variables.opy:84](../src/variables.opy#L84). Строк обращений: 15; упоминаний: 18; чтений вида Global в скомпилированном коде: 14.

- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78).
- subroutines.opy — def setDifficulty(): [401](../src/subroutines.opy#L401).
- global_start_menu.opy — rule "END VOTING": [239](../src/global_start_menu.opy#L239).
- global_start_menu.opy — def determineChallenge(): [326](../src/global_start_menu.opy#L326), [344](../src/global_start_menu.opy#L344), [345](../src/global_start_menu.opy#L345), [346](../src/global_start_menu.opy#L346), [348](../src/global_start_menu.opy#L348), [349](../src/global_start_menu.opy#L349), [351](../src/global_start_menu.opy#L351), [352](../src/global_start_menu.opy#L352).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [18](../src/global_game_in_progress.opy#L18).
- global_game_in_progress.opy — rule "SWARM SHOOTOUT": [81](../src/global_game_in_progress.opy#L81).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [97](../src/global_game_in_progress.opy#L97).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED": [131](../src/players_game_in_progress.opy#L131).

## zombieSetting

Объявление: [variables.opy:85](../src/variables.opy#L85). Строк обращений: 20; упоминаний: 20; чтений вида Global в скомпилированном коде: 15.

- subroutines.opy — macro minibossMutationMacro(): [20](../src/subroutines.opy#L20).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [153](../src/global_startup.opy#L153).
- global_start_menu.opy — rule "END VOTING": [240](../src/global_start_menu.opy#L240).
- global_start_menu.opy — def determineZombieMode(): [265](../src/global_start_menu.opy#L265), [274](../src/global_start_menu.opy#L274), [275](../src/global_start_menu.opy#L275), [276](../src/global_start_menu.opy#L276), [278](../src/global_start_menu.opy#L278), [279](../src/global_start_menu.opy#L279), [281](../src/global_start_menu.opy#L281), [282](../src/global_start_menu.opy#L282).
- global_start_menu.opy — def setZombieMode(): [295](../src/global_start_menu.opy#L295), [299](../src/global_start_menu.opy#L299), [303](../src/global_start_menu.opy#L303), [310](../src/global_start_menu.opy#L310), [314](../src/global_start_menu.opy#L314), [318](../src/global_start_menu.opy#L318).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [24](../src/player_start_menu.opy#L24).
- global_game_in_progress.opy — rule "ZOMBIE SHUFFLE": [67](../src/global_game_in_progress.opy#L67).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [42](../src/objective_types/objective_type_bosses.opy#L42).

## objectiveTypeSetting

Объявление: [variables.opy:86](../src/variables.opy#L86). Строк обращений: 16; упоминаний: 17; чтений вида Global в скомпилированном коде: 11.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [283](../src/subroutines.opy#L283).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [155](../src/global_startup.opy#L155).
- global_start_menu.opy — rule "END VOTING": [241](../src/global_start_menu.opy#L241).
- global_start_menu.opy — def determineObjectiveType(): [359](../src/global_start_menu.opy#L359), [368](../src/global_start_menu.opy#L368), [369](../src/global_start_menu.opy#L369), [370](../src/global_start_menu.opy#L370), [372](../src/global_start_menu.opy#L372), [373](../src/global_start_menu.opy#L373), [375](../src/global_start_menu.opy#L375), [377](../src/global_start_menu.opy#L377), [379](../src/global_start_menu.opy#L379), [380](../src/global_start_menu.opy#L380).
- global_start_menu.opy — def setObjectiveType(): [392](../src/global_start_menu.opy#L392), [393](../src/global_start_menu.opy#L393).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [25](../src/player_start_menu.opy#L25).

## matchEndTime

Объявление: [variables.opy:87](../src/variables.opy#L87). Строк обращений: 12; упоминаний: 12; чтений вида Global в скомпилированном коде: 11.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [213](../src/global_startup.opy#L213).
- global_startup.opy — rule "START GAME": [287](../src/global_startup.opy#L287).
- global_startup.opy — def generateMapGrid(): [308](../src/global_startup.opy#L308).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [10](../src/global_game_in_progress.opy#L10), [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- global_game_in_progress.opy — rule "PREVENT MATCH TIME FROM UNPAUSING": [41](../src/global_game_in_progress.opy#L41), [44](../src/global_game_in_progress.opy#L44).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [53](../src/global_game_in_progress.opy#L53).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [212](../src/players_game_in_progress.opy#L212).
- bots_game_in_progress.opy — rule "BOT DIES": [150](../src/bots_game_in_progress.opy#L150).

## uniqueSkinCap

Объявление: [variables.opy:88](../src/variables.opy#L88). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — macro botHeroRandomizationMacro(): [56](../src/global_startup.opy#L56).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [260](../src/global_startup.opy#L260).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [12](../src/objective_types/objective_type_bosses.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [9](../src/objective_types/objective_type_zombie_egg.opy#L9).

## numberOfBots

Объявление: [variables.opy:89](../src/variables.opy#L89). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "SPAWN BOTS": [97](../src/global_startup.opy#L97).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [262](../src/global_startup.opy#L262).
- bots_game_in_progress.opy — rule "BOT DIES": [151](../src/bots_game_in_progress.opy#L151).

## walkCenter

Объявление: [variables.opy:92](../src/variables.opy#L92). Строк обращений: 10; упоминаний: 11; чтений вида Global в скомпилированном коде: 8.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [221](../src/global_startup.opy#L221), [223](../src/global_startup.opy#L223), [226](../src/global_startup.opy#L226).
- global_startup.opy — rule "START GAME": [276](../src/global_startup.opy#L276).
- global_startup.opy — def generateMapGrid(): [303](../src/global_startup.opy#L303).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [16](../src/global_start_menu.opy#L16), [18](../src/global_start_menu.opy#L18), [20](../src/global_start_menu.opy#L20), [21](../src/global_start_menu.opy#L21).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [91](../src/players_game_in_progress.opy#L91).

## mapGridList

Объявление: [variables.opy:93](../src/variables.opy#L93). Строк обращений: 20; упоминаний: 25; чтений вида Global в скомпилированном коде: 23.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [165](../src/global_startup.opy#L165).
- global_startup.opy — def generateMapGrid(): [300](../src/global_startup.opy#L300), [301](../src/global_startup.opy#L301), [303](../src/global_startup.opy#L303), [306](../src/global_startup.opy#L306), [307](../src/global_startup.opy#L307), [312](../src/global_startup.opy#L312).
- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [11](../src/global_start_menu.opy#L11).
- global_start_menu.opy — def setObjectiveType(): [400](../src/global_start_menu.opy#L400).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [97](../src/objective_types/objective_type_extraction_point.opy#L97).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [140](../src/objective_types/objective_type_extraction_point.opy#L140), [142](../src/objective_types/objective_type_extraction_point.opy#L142), [143](../src/objective_types/objective_type_extraction_point.opy#L143), [148](../src/objective_types/objective_type_extraction_point.opy#L148).
- objective_types/objective_type_bosses.opy — def bossReturn(): [206](../src/objective_types/objective_type_bosses.opy#L206).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [15](../src/objective_types/objective_type_survivor_rescue.opy#L15).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [75](../src/objective_types/objective_type_satellite_uplink.opy#L75).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [91](../src/players_game_in_progress.opy#L91).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [418](../src/zombie_types.opy#L418).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [37](../src/supply_drops.opy#L37).

## attackSpawnRooms

Объявление: [variables.opy:94](../src/variables.opy#L94). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [181](../src/global_startup.opy#L181), [184](../src/global_startup.opy#L184), [190](../src/global_startup.opy#L190), [193](../src/global_startup.opy#L193), [205](../src/global_startup.opy#L205).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [210](../src/global_startup.opy#L210).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [28](../src/global_game_in_progress.opy#L28), [31](../src/global_game_in_progress.opy#L31), [32](../src/global_game_in_progress.opy#L32).

## activeAttackSpawnRoom

Объявление: [variables.opy:95](../src/variables.opy#L95). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 1.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [205](../src/global_startup.opy#L205).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [25](../src/global_game_in_progress.opy#L25), [32](../src/global_game_in_progress.opy#L32).

## spawnRoomIndex

Объявление: [variables.opy:96](../src/variables.opy#L96). Строк обращений: 14; упоминаний: 15; чтений вида Global в скомпилированном коде: 9.

- global_startup.opy — rule "PREGAME SPAWN ROOM ROTATION": [182](../src/global_startup.opy#L182), [185](../src/global_startup.opy#L185), [191](../src/global_startup.opy#L191), [198](../src/global_startup.opy#L198), [199](../src/global_startup.opy#L199), [200](../src/global_startup.opy#L200), [202](../src/global_startup.opy#L202), [205](../src/global_startup.opy#L205).
- global_game_in_progress.opy — rule "ATTACK SPAWN ROOM CONTROL": [27](../src/global_game_in_progress.opy#L27), [28](../src/global_game_in_progress.opy#L28), [29](../src/global_game_in_progress.opy#L29), [31](../src/global_game_in_progress.opy#L31), [32](../src/global_game_in_progress.opy#L32), [33](../src/global_game_in_progress.opy#L33).

## botSpawnPointList

Объявление: [variables.opy:97](../src/variables.opy#L97). Строк обращений: 17; упоминаний: 17; чтений вида Global в скомпилированном коде: 13.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [230](../src/global_startup.opy#L230).
- bots_game_in_progress.opy — def enterExitTeleport(): [432](../src/bots_game_in_progress.opy#L432), [433](../src/bots_game_in_progress.opy#L433).
- bots_game_in_progress.opy — def teleportBots(): [458](../src/bots_game_in_progress.opy#L458), [461](../src/bots_game_in_progress.opy#L461), [463](../src/bots_game_in_progress.opy#L463), [465](../src/bots_game_in_progress.opy#L465), [474](../src/bots_game_in_progress.opy#L474), [475](../src/bots_game_in_progress.opy#L475), [476](../src/bots_game_in_progress.opy#L476), [477](../src/bots_game_in_progress.opy#L477).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [512](../src/bots_game_in_progress.opy#L512), [513](../src/bots_game_in_progress.opy#L513), [516](../src/bots_game_in_progress.opy#L516), [517](../src/bots_game_in_progress.opy#L517), [518](../src/bots_game_in_progress.opy#L518), [519](../src/bots_game_in_progress.opy#L519).

## botSpawnPointTimerList

Объявление: [variables.opy:98](../src/variables.opy#L98). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "SPAWN TIME CONTROL": [116](../src/global_startup.opy#L116), [120](../src/global_startup.opy#L120), [121](../src/global_startup.opy#L121).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [232](../src/global_startup.opy#L232).
- bots_game_in_progress.opy — def teleportBots(): [461](../src/bots_game_in_progress.opy#L461), [465](../src/bots_game_in_progress.opy#L465), [476](../src/bots_game_in_progress.opy#L476).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/bots_game_in_progress.opy#L515), [518](../src/bots_game_in_progress.opy#L518).

## botSpawnWaypointList

Объявление: [variables.opy:99](../src/variables.opy#L99). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 1.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [231](../src/global_startup.opy#L231).
- bots_game_in_progress.opy — def enterExitTeleport(): [433](../src/bots_game_in_progress.opy#L433).
- bots_game_in_progress.opy — def teleportBots(): [475](../src/bots_game_in_progress.opy#L475).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [514](../src/bots_game_in_progress.opy#L514), [517](../src/bots_game_in_progress.opy#L517).

## customTeleportPositionList

Объявление: [variables.opy:100](../src/variables.opy#L100). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [257](../src/global_startup.opy#L257).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [67](../src/bots_game_in_progress.opy#L67), [68](../src/bots_game_in_progress.opy#L68), [69](../src/bots_game_in_progress.opy#L69).
- bots_game_in_progress.opy — rule "BOT DIES": [154](../src/bots_game_in_progress.opy#L154).

## botSpawnTimeList

Объявление: [variables.opy:101](../src/variables.opy#L101). Строк обращений: 14; упоминаний: 20; чтений вида Global в скомпилированном коде: 13.

- global_startup.opy — rule "SPAWN BOTS": [97](../src/global_startup.opy#L97), [100](../src/global_startup.opy#L100), [101](../src/global_startup.opy#L101), [107](../src/global_startup.opy#L107), [109](../src/global_startup.opy#L109), [110](../src/global_startup.opy#L110).
- global_startup.opy — rule "SPAWN TIME CONTROL": [116](../src/global_startup.opy#L116), [118](../src/global_startup.opy#L118), [119](../src/global_startup.opy#L119).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [256](../src/global_startup.opy#L256).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [16](../src/objective_types/objective_type_kill_zone.opy#L16).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [63](../src/objective_types/objective_type_satellite_uplink.opy#L63).
- bots_game_in_progress.opy — rule "BOT DIES": [151](../src/bots_game_in_progress.opy#L151), [152](../src/bots_game_in_progress.opy#L152).

## startPos

Объявление: [variables.opy:104](../src/variables.opy#L104). Строк обращений: 21; упоминаний: 29; чтений вида Global в скомпилированном коде: 19.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [16](../src/global_start_menu.opy#L16), [18](../src/global_start_menu.opy#L18), [20](../src/global_start_menu.opy#L20), [21](../src/global_start_menu.opy#L21), [23](../src/global_start_menu.opy#L23), [26](../src/global_start_menu.opy#L26), [29](../src/global_start_menu.opy#L29), [30](../src/global_start_menu.opy#L30), [32](../src/global_start_menu.opy#L32), [34](../src/global_start_menu.opy#L34), [37](../src/global_start_menu.opy#L37), [39](../src/global_start_menu.opy#L39), [40](../src/global_start_menu.opy#L40), [41](../src/global_start_menu.opy#L41), [42](../src/global_start_menu.opy#L42), [46](../src/global_start_menu.opy#L46), [47](../src/global_start_menu.opy#L47).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [64](../src/global_start_menu.opy#L64), [66](../src/global_start_menu.opy#L66).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [67](../src/player_start_menu.opy#L67).

## startCamPos

Объявление: [variables.opy:105](../src/variables.opy#L105). Строк обращений: 13; упоминаний: 25; чтений вида Global в скомпилированном коде: 20.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [21](../src/global_start_menu.opy#L21), [35](../src/global_start_menu.opy#L35), [37](../src/global_start_menu.opy#L37), [38](../src/global_start_menu.opy#L38), [39](../src/global_start_menu.opy#L39), [41](../src/global_start_menu.opy#L41), [42](../src/global_start_menu.opy#L42), [46](../src/global_start_menu.opy#L46).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [64](../src/global_start_menu.opy#L64), [66](../src/global_start_menu.opy#L66).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [67](../src/player_start_menu.opy#L67), [79](../src/player_start_menu.opy#L79).

## startMenuSpacingAngle

Объявление: [variables.opy:106](../src/variables.opy#L106). Строк обращений: 4; упоминаний: 5; чтений вида Global в скомпилированном коде: 4.

- global_start_menu.opy — rule "GLOBAL MENU INITIALIZATION": [51](../src/global_start_menu.opy#L51).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION": [10](../src/player_start_menu.opy#L10), [26](../src/player_start_menu.opy#L26).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO": [60](../src/player_start_menu.opy#L60).

## startMenuZombieColorList

Объявление: [variables.opy:107](../src/variables.opy#L107). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [105](../src/global_start_menu.opy#L105), [129](../src/global_start_menu.opy#L129), [130](../src/global_start_menu.opy#L130), [131](../src/global_start_menu.opy#L131).

## startMenuObjectiveColorList

Объявление: [variables.opy:108](../src/variables.opy#L108). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [135](../src/global_start_menu.opy#L135), [165](../src/global_start_menu.opy#L165), [166](../src/global_start_menu.opy#L166), [167](../src/global_start_menu.opy#L167).

## startMenuEnhancementColorList

Объявление: [variables.opy:109](../src/variables.opy#L109). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [171](../src/global_start_menu.opy#L171), [203](../src/global_start_menu.opy#L203), [204](../src/global_start_menu.opy#L204), [205](../src/global_start_menu.opy#L205).

## challengeVoteList

Объявление: [variables.opy:110](../src/variables.opy#L110). Строк обращений: 16; упоминаний: 21; чтений вида Global в скомпилированном коде: 18.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [146](../src/global_startup.opy#L146).
- global_start_menu.opy — def determineChallenge(): [328](../src/global_start_menu.opy#L328), [329](../src/global_start_menu.opy#L329), [330](../src/global_start_menu.opy#L330), [332](../src/global_start_menu.opy#L332), [336](../src/global_start_menu.opy#L336), [338](../src/global_start_menu.opy#L338), [342](../src/global_start_menu.opy#L342), [344](../src/global_start_menu.opy#L344), [346](../src/global_start_menu.opy#L346).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)": [136](../src/player_start_menu.opy#L136), [137](../src/player_start_menu.opy#L137), [138](../src/player_start_menu.opy#L138), [140](../src/player_start_menu.opy#L140), [141](../src/player_start_menu.opy#L141), [142](../src/player_start_menu.opy#L142).

## zombieVoteList

Объявление: [variables.opy:111](../src/variables.opy#L111). Строк обращений: 14; упоминаний: 18; чтений вида Global в скомпилированном коде: 15.

- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [148](../src/global_startup.opy#L148).
- global_start_menu.opy — def determineZombieMode(): [267](../src/global_start_menu.opy#L267), [268](../src/global_start_menu.opy#L268), [269](../src/global_start_menu.opy#L269), [271](../src/global_start_menu.opy#L271), [273](../src/global_start_menu.opy#L273), [274](../src/global_start_menu.opy#L274), [276](../src/global_start_menu.opy#L276).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)": [156](../src/player_start_menu.opy#L156), [157](../src/player_start_menu.opy#L157), [158](../src/player_start_menu.opy#L158), [160](../src/player_start_menu.opy#L160), [161](../src/player_start_menu.opy#L161), [162](../src/player_start_menu.opy#L162).

## objectiveTypeVoteList

Объявление: [variables.opy:112](../src/variables.opy#L112). Строк обращений: 23; упоминаний: 27; чтений вида Global в скомпилированном коде: 18.

- global_startup.opy — macro setAvailableObjectivesMacro(): [7](../src/global_startup.opy#L7), [9](../src/global_startup.opy#L9), [11](../src/global_startup.opy#L11), [13](../src/global_startup.opy#L13), [15](../src/global_startup.opy#L15), [17](../src/global_startup.opy#L17), [19](../src/global_startup.opy#L19).
- global_start_menu.opy — def determineObjectiveType(): [361](../src/global_start_menu.opy#L361), [362](../src/global_start_menu.opy#L362), [363](../src/global_start_menu.opy#L363), [365](../src/global_start_menu.opy#L365), [367](../src/global_start_menu.opy#L367), [368](../src/global_start_menu.opy#L368), [370](../src/global_start_menu.opy#L370), [376](../src/global_start_menu.opy#L376), [379](../src/global_start_menu.opy#L379), [380](../src/global_start_menu.opy#L380).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)": [176](../src/player_start_menu.opy#L176), [177](../src/player_start_menu.opy#L177), [178](../src/player_start_menu.opy#L178), [180](../src/player_start_menu.opy#L180), [181](../src/player_start_menu.opy#L181), [182](../src/player_start_menu.opy#L182).

## enhancementOptionList

Объявление: [variables.opy:113](../src/variables.opy#L113). Строк обращений: 8; упоминаний: 10; чтений вида Global в скомпилированном коде: 9.

- global_startup.opy — macro enableEnhancementsMacro(): [35](../src/global_startup.opy#L35).
- player_start_menu.opy — rule "EFFECTS/TEXT": [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)": [193](../src/player_start_menu.opy#L193), [194](../src/player_start_menu.opy#L194), [195](../src/player_start_menu.opy#L195), [197](../src/player_start_menu.opy#L197), [198](../src/player_start_menu.opy#L198), [199](../src/player_start_menu.opy#L199).

## pregameGlitchText

Объявление: [variables.opy:114](../src/variables.opy#L114). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [85](../src/global_start_menu.opy#L85), [86](../src/global_start_menu.opy#L86).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [217](../src/global_start_menu.opy#L217), [219](../src/global_start_menu.opy#L219), [221](../src/global_start_menu.opy#L221).

## isPregameGlitchActive

Объявление: [variables.opy:115](../src/variables.opy#L115). Строк обращений: 5; упоминаний: 6; чтений вида Global в скомпилированном коде: 4.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [85](../src/global_start_menu.opy#L85), [86](../src/global_start_menu.opy#L86), [99](../src/global_start_menu.opy#L99).
- global_start_menu.opy — rule "SPECIAL EFFECT CONTROLS": [222](../src/global_start_menu.opy#L222), [224](../src/global_start_menu.opy#L224).

## objectivePositionList

Объявление: [variables.opy:118](../src/variables.opy#L118). Строк обращений: 109; упоминаний: 142; чтений вида Global в скомпилированном коде: 136.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [234](../src/subroutines.opy#L234), [236](../src/subroutines.opy#L236), [239](../src/subroutines.opy#L239), [243](../src/subroutines.opy#L243), [246](../src/subroutines.opy#L246), [249](../src/subroutines.opy#L249), [254](../src/subroutines.opy#L254), [257](../src/subroutines.opy#L257), [260](../src/subroutines.opy#L260), [263](../src/subroutines.opy#L263), [266](../src/subroutines.opy#L266), [269](../src/subroutines.opy#L269), [272](../src/subroutines.opy#L272), [275](../src/subroutines.opy#L275), [283](../src/subroutines.opy#L283), [286](../src/subroutines.opy#L286), [289](../src/subroutines.opy#L289), [294](../src/subroutines.opy#L294), [300](../src/subroutines.opy#L300), [303](../src/subroutines.opy#L303), [306](../src/subroutines.opy#L306), [312](../src/subroutines.opy#L312), [317](../src/subroutines.opy#L317), [320](../src/subroutines.opy#L320), [323](../src/subroutines.opy#L323), [331](../src/subroutines.opy#L331), [354](../src/subroutines.opy#L354), [357](../src/subroutines.opy#L357), [360](../src/subroutines.opy#L360), [363](../src/subroutines.opy#L363), [366](../src/subroutines.opy#L366), [371](../src/subroutines.opy#L371), [389](../src/subroutines.opy#L389).
- subroutines.opy — def objectivesManagement(): [535](../src/subroutines.opy#L535), [536](../src/subroutines.opy#L536), [545](../src/subroutines.opy#L545), [546](../src/subroutines.opy#L546), [551](../src/subroutines.opy#L551), [552](../src/subroutines.opy#L552), [563](../src/subroutines.opy#L563), [564](../src/subroutines.opy#L564), [565](../src/subroutines.opy#L565), [570](../src/subroutines.opy#L570), [573](../src/subroutines.opy#L573), [578](../src/subroutines.opy#L578), [624](../src/subroutines.opy#L624).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [242](../src/global_startup.opy#L242).
- global_start_menu.opy — def setObjectiveType(): [398](../src/global_start_menu.opy#L398), [400](../src/global_start_menu.opy#L400), [404](../src/global_start_menu.opy#L404), [407](../src/global_start_menu.opy#L407), [412](../src/global_start_menu.opy#L412), [413](../src/global_start_menu.opy#L413).
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
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [173](../src/objective_types/objective_type_survivor_rescue.opy#L173), [177](../src/objective_types/objective_type_survivor_rescue.opy#L177).
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
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1409](../src/zombie_types.opy#L1409).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35).

## objectiveTypeList

Объявление: [variables.opy:119](../src/variables.opy#L119). Строк обращений: 9; упоминаний: 12; чтений вида Global в скомпилированном коде: 50.

- variables.opy — module: [5](../src/variables.opy#L5).
- subroutines.opy — def objectivesManagement(): [574](../src/subroutines.opy#L574).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [243](../src/global_startup.opy#L243).
- global_start_menu.opy — def setObjectiveType(): [391](../src/global_start_menu.opy#L391), [393](../src/global_start_menu.opy#L393), [396](../src/global_start_menu.opy#L396), [398](../src/global_start_menu.opy#L398), [406](../src/global_start_menu.opy#L406), [416](../src/global_start_menu.opy#L416).

## objectiveSpacingList

Объявление: [variables.opy:120](../src/variables.opy#L120). Строк обращений: 3; упоминаний: 4; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — def generateMapGrid(): [312](../src/global_startup.opy#L312).
- global_start_menu.opy — def setObjectiveType(): [400](../src/global_start_menu.opy#L400), [404](../src/global_start_menu.opy#L404).

## mixedObjectiveTypeList

Объявление: [variables.opy:121](../src/variables.opy#L121). Строк обращений: 3; упоминаний: 4; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — macro setAvailableObjectivesMacro(): [21](../src/global_startup.opy#L21), [31](../src/global_startup.opy#L31).
- global_start_menu.opy — def setObjectiveType(): [396](../src/global_start_menu.opy#L396).

## objectiveValue

Объявление: [variables.opy:122](../src/variables.opy#L122). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [220](../src/subroutines.opy#L220), [232](../src/subroutines.opy#L232), [278](../src/subroutines.opy#L278), [292](../src/subroutines.opy#L292), [315](../src/subroutines.opy#L315), [326](../src/subroutines.opy#L326), [349](../src/subroutines.opy#L349), [369](../src/subroutines.opy#L369).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/players_game_in_progress.opy#L8).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/players_game_in_progress.opy#L321).

## objectiveCaptureValue

Объявление: [variables.opy:123](../src/variables.opy#L123). Строк обращений: 44; упоминаний: 46; чтений вида Global в скомпилированном коде: 30.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [272](../src/subroutines.opy#L272), [275](../src/subroutines.opy#L275), [294](../src/subroutines.opy#L294), [328](../src/subroutines.opy#L328), [371](../src/subroutines.opy#L371), [377](../src/subroutines.opy#L377), [381](../src/subroutines.opy#L381), [383](../src/subroutines.opy#L383), [392](../src/subroutines.opy#L392).
- subroutines.opy — def objectivesManagement(): [528](../src/subroutines.opy#L528), [589](../src/subroutines.opy#L589), [590](../src/subroutines.opy#L590), [602](../src/subroutines.opy#L602), [626](../src/subroutines.opy#L626), [638](../src/subroutines.opy#L638).
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

Объявление: [variables.opy:124](../src/variables.opy#L124). Строк обращений: 53; упоминаний: 58; чтений вида Global в скомпилированном коде: 47.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [243](../src/subroutines.opy#L243), [257](../src/subroutines.opy#L257), [260](../src/subroutines.opy#L260), [263](../src/subroutines.opy#L263), [266](../src/subroutines.opy#L266), [303](../src/subroutines.opy#L303), [306](../src/subroutines.opy#L306), [323](../src/subroutines.opy#L323), [334](../src/subroutines.opy#L334), [337](../src/subroutines.opy#L337), [340](../src/subroutines.opy#L340), [343](../src/subroutines.opy#L343), [346](../src/subroutines.opy#L346), [374](../src/subroutines.opy#L374), [383](../src/subroutines.opy#L383), [386](../src/subroutines.opy#L386), [389](../src/subroutines.opy#L389), [392](../src/subroutines.opy#L392).
- subroutines.opy — def objectivesManagement(): [535](../src/subroutines.opy#L535), [545](../src/subroutines.opy#L545), [551](../src/subroutines.opy#L551), [558](../src/subroutines.opy#L558), [564](../src/subroutines.opy#L564), [583](../src/subroutines.opy#L583), [590](../src/subroutines.opy#L590), [606](../src/subroutines.opy#L606), [617](../src/subroutines.opy#L617), [618](../src/subroutines.opy#L618), [623](../src/subroutines.opy#L623), [630](../src/subroutines.opy#L630), [635](../src/subroutines.opy#L635).
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
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1409](../src/zombie_types.opy#L1409).

## objectiveDescription

Объявление: [variables.opy:125](../src/variables.opy#L125). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — def objectivesManagement(): [580](../src/subroutines.opy#L580), [588](../src/subroutines.opy#L588), [597](../src/subroutines.opy#L597), [601](../src/subroutines.opy#L601), [615](../src/subroutines.opy#L615), [622](../src/subroutines.opy#L622), [629](../src/subroutines.opy#L629), [634](../src/subroutines.opy#L634).
- global_startup.opy — rule "START GAME": [292](../src/global_startup.opy#L292).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [10](../src/global_game_in_progress.opy#L10).

## objectiveColor

Объявление: [variables.opy:126](../src/variables.opy#L126). Строк обращений: 27; упоминаний: 31; чтений вида Global в скомпилированном коде: 26.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [254](../src/subroutines.opy#L254), [257](../src/subroutines.opy#L257), [260](../src/subroutines.opy#L260), [263](../src/subroutines.opy#L263), [266](../src/subroutines.opy#L266), [269](../src/subroutines.opy#L269), [272](../src/subroutines.opy#L272), [275](../src/subroutines.opy#L275), [294](../src/subroutines.opy#L294), [300](../src/subroutines.opy#L300), [371](../src/subroutines.opy#L371), [374](../src/subroutines.opy#L374), [377](../src/subroutines.opy#L377), [383](../src/subroutines.opy#L383), [386](../src/subroutines.opy#L386), [389](../src/subroutines.opy#L389), [392](../src/subroutines.opy#L392).
- subroutines.opy — def objectivesManagement(): [591](../src/subroutines.opy#L591), [605](../src/subroutines.opy#L605), [636](../src/subroutines.opy#L636).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [73](../src/objective_types/objective_type_showdown.opy#L73), [79](../src/objective_types/objective_type_showdown.opy#L79).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [45](../src/objective_types/objective_type_biomorphing.opy#L45).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [14](../src/objective_types/objective_type_satellite_uplink.opy#L14).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136), [141](../src/objective_types/objective_type_satellite_uplink.opy#L141).

## isObjectiveComplete

Объявление: [variables.opy:127](../src/variables.opy#L127). Строк обращений: 29; упоминаний: 29; чтений вида Global в скомпилированном коде: 21.

- subroutines.opy — def objectivesManagement(): [644](../src/subroutines.opy#L644).
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
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [171](../src/objective_types/objective_type_survivor_rescue.opy#L171).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [13](../src/objective_types/objective_type_kill_zone.opy#L13).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [6](../src/objective_types/objective_type_zombie_egg.opy#L6).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG": [21](../src/objective_types/objective_type_zombie_egg.opy#L21), [45](../src/objective_types/objective_type_zombie_egg.opy#L45), [50](../src/objective_types/objective_type_zombie_egg.opy#L50).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG": [57](../src/objective_types/objective_type_zombie_egg.opy#L57).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [70](../src/objective_types/objective_type_satellite_uplink.opy#L70).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [102](../src/objective_types/objective_type_satellite_uplink.opy#L102).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [118](../src/objective_types/objective_type_satellite_uplink.opy#L118), [143](../src/objective_types/objective_type_satellite_uplink.opy#L143).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [191](../src/players_game_in_progress.opy#L191).

## objectivePlayerList

Объявление: [variables.opy:128](../src/variables.opy#L128). Строк обращений: 48; упоминаний: 52; чтений вида Global в скомпилированном коде: 39.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [236](../src/subroutines.opy#L236), [246](../src/subroutines.opy#L246), [249](../src/subroutines.opy#L249), [254](../src/subroutines.opy#L254), [263](../src/subroutines.opy#L263), [266](../src/subroutines.opy#L266), [269](../src/subroutines.opy#L269), [272](../src/subroutines.opy#L272), [275](../src/subroutines.opy#L275), [300](../src/subroutines.opy#L300), [306](../src/subroutines.opy#L306), [309](../src/subroutines.opy#L309), [312](../src/subroutines.opy#L312), [374](../src/subroutines.opy#L374), [377](../src/subroutines.opy#L377).
- subroutines.opy — def objectivesManagement(): [527](../src/subroutines.opy#L527), [579](../src/subroutines.opy#L579).
- subroutines.opy — def selectTarget(): [655](../src/subroutines.opy#L655).
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

Объявление: [variables.opy:129](../src/variables.opy#L129). Строк обращений: 62; упоминаний: 62; чтений вида Global в скомпилированном коде: 7.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [222](../src/subroutines.opy#L222), [223](../src/subroutines.opy#L223), [224](../src/subroutines.opy#L224), [225](../src/subroutines.opy#L225), [226](../src/subroutines.opy#L226), [227](../src/subroutines.opy#L227), [228](../src/subroutines.opy#L228), [230](../src/subroutines.opy#L230), [237](../src/subroutines.opy#L237), [240](../src/subroutines.opy#L240), [244](../src/subroutines.opy#L244), [247](../src/subroutines.opy#L247), [250](../src/subroutines.opy#L250), [255](../src/subroutines.opy#L255), [258](../src/subroutines.opy#L258), [261](../src/subroutines.opy#L261), [264](../src/subroutines.opy#L264), [267](../src/subroutines.opy#L267), [270](../src/subroutines.opy#L270), [273](../src/subroutines.opy#L273), [276](../src/subroutines.opy#L276), [281](../src/subroutines.opy#L281), [284](../src/subroutines.opy#L284), [287](../src/subroutines.opy#L287), [290](../src/subroutines.opy#L290), [295](../src/subroutines.opy#L295), [298](../src/subroutines.opy#L298), [301](../src/subroutines.opy#L301), [304](../src/subroutines.opy#L304), [307](../src/subroutines.opy#L307), [310](../src/subroutines.opy#L310), [313](../src/subroutines.opy#L313), [318](../src/subroutines.opy#L318), [321](../src/subroutines.opy#L321), [324](../src/subroutines.opy#L324), [329](../src/subroutines.opy#L329), [332](../src/subroutines.opy#L332), [335](../src/subroutines.opy#L335), [338](../src/subroutines.opy#L338), [341](../src/subroutines.opy#L341), [344](../src/subroutines.opy#L344), [347](../src/subroutines.opy#L347), [352](../src/subroutines.opy#L352), [355](../src/subroutines.opy#L355), [358](../src/subroutines.opy#L358), [361](../src/subroutines.opy#L361), [364](../src/subroutines.opy#L364), [367](../src/subroutines.opy#L367), [372](../src/subroutines.opy#L372), [375](../src/subroutines.opy#L375), [378](../src/subroutines.opy#L378), [384](../src/subroutines.opy#L384), [387](../src/subroutines.opy#L387), [390](../src/subroutines.opy#L390), [393](../src/subroutines.opy#L393).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [229](../src/global_startup.opy#L229).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [15](../src/objective_types/objective_type_satellite_uplink.opy#L15), [22](../src/objective_types/objective_type_satellite_uplink.opy#L22), [25](../src/objective_types/objective_type_satellite_uplink.opy#L25), [28](../src/objective_types/objective_type_satellite_uplink.opy#L28), [31](../src/objective_types/objective_type_satellite_uplink.opy#L31), [36](../src/objective_types/objective_type_satellite_uplink.opy#L36).

## objectiveEntitiesCount

Объявление: [variables.opy:130](../src/variables.opy#L130). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 6.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [222](../src/subroutines.opy#L222), [223](../src/subroutines.opy#L223), [224](../src/subroutines.opy#L224), [225](../src/subroutines.opy#L225), [226](../src/subroutines.opy#L226), [227](../src/subroutines.opy#L227), [228](../src/subroutines.opy#L228).

## objectiveResourcePositionList

Объявление: [variables.opy:131](../src/variables.opy#L131). Строк обращений: 35; упоминаний: 44; чтений вида Global в скомпилированном коде: 34.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [312](../src/subroutines.opy#L312), [374](../src/subroutines.opy#L374), [377](../src/subroutines.opy#L377), [383](../src/subroutines.opy#L383), [386](../src/subroutines.opy#L386), [389](../src/subroutines.opy#L389), [392](../src/subroutines.opy#L392).
- subroutines.opy — def objectivesManagement(): [603](../src/subroutines.opy#L603), [637](../src/subroutines.opy#L637).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [219](../src/global_startup.opy#L219).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [16](../src/objective_types/objective_type_biomorphing.opy#L16).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [39](../src/objective_types/objective_type_biomorphing.opy#L39).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [74](../src/objective_types/objective_type_biomorphing.opy#L74).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [108](../src/objective_types/objective_type_biomorphing.opy#L108), [109](../src/objective_types/objective_type_biomorphing.opy#L109), [114](../src/objective_types/objective_type_biomorphing.opy#L114), [116](../src/objective_types/objective_type_biomorphing.opy#L116), [121](../src/objective_types/objective_type_biomorphing.opy#L121).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [13](../src/objective_types/objective_type_satellite_uplink.opy#L13), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [71](../src/objective_types/objective_type_satellite_uplink.opy#L71), [76](../src/objective_types/objective_type_satellite_uplink.opy#L76), [77](../src/objective_types/objective_type_satellite_uplink.opy#L77), [80](../src/objective_types/objective_type_satellite_uplink.opy#L80), [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [86](../src/objective_types/objective_type_satellite_uplink.opy#L86), [89](../src/objective_types/objective_type_satellite_uplink.opy#L89), [91](../src/objective_types/objective_type_satellite_uplink.opy#L91), [92](../src/objective_types/objective_type_satellite_uplink.opy#L92).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS": [106](../src/objective_types/objective_type_satellite_uplink.opy#L106).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS REPAIR TERMINALS": [123](../src/objective_types/objective_type_satellite_uplink.opy#L123), [125](../src/objective_types/objective_type_satellite_uplink.opy#L125), [126](../src/objective_types/objective_type_satellite_uplink.opy#L126), [135](../src/objective_types/objective_type_satellite_uplink.opy#L135), [136](../src/objective_types/objective_type_satellite_uplink.opy#L136).

## testPos

Объявление: [variables.opy:132](../src/variables.opy#L132). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

- global_start_menu.opy — def setObjectiveType(): [400](../src/global_start_menu.opy#L400), [401](../src/global_start_menu.opy#L401), [404](../src/global_start_menu.opy#L404), [406](../src/global_start_menu.opy#L406), [407](../src/global_start_menu.opy#L407).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [12](../src/objective_types/objective_type_survivor_rescue.opy#L12), [14](../src/objective_types/objective_type_survivor_rescue.opy#L14), [15](../src/objective_types/objective_type_survivor_rescue.opy#L15), [18](../src/objective_types/objective_type_survivor_rescue.opy#L18).

## testPos2

Объявление: [variables.opy:133](../src/variables.opy#L133). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — def objectivesManagement(): [640](../src/subroutines.opy#L640).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [13](../src/objective_types/objective_type_survivor_rescue.opy#L13), [15](../src/objective_types/objective_type_survivor_rescue.opy#L15), [16](../src/objective_types/objective_type_survivor_rescue.opy#L16).
- objective_types/objective_type_satellite_uplink.opy — rule "SET UP TERMINAL POSITIONS": [83](../src/objective_types/objective_type_satellite_uplink.opy#L83), [90](../src/objective_types/objective_type_satellite_uplink.opy#L90).

## objectiveCount1

Объявление: [variables.opy:134](../src/variables.opy#L134). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 4.

- global_start_menu.opy — def setObjectiveType(): [397](../src/global_start_menu.opy#L397), [408](../src/global_start_menu.opy#L408), [409](../src/global_start_menu.opy#L409), [411](../src/global_start_menu.opy#L411), [414](../src/global_start_menu.opy#L414).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [31](../src/objective_types/objective_type_biomorphing.opy#L31), [32](../src/objective_types/objective_type_biomorphing.opy#L32), [33](../src/objective_types/objective_type_biomorphing.opy#L33).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [42](../src/objective_types/objective_type_satellite_uplink.opy#L42), [57](../src/objective_types/objective_type_satellite_uplink.opy#L57).

## objectiveChase1

Объявление: [variables.opy:135](../src/variables.opy#L135). Строк обращений: 28; упоминаний: 43; чтений вида Global в скомпилированном коде: 35.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [334](../src/subroutines.opy#L334), [337](../src/subroutines.opy#L337), [340](../src/subroutines.opy#L340), [343](../src/subroutines.opy#L343), [346](../src/subroutines.opy#L346).
- subroutines.opy — def objectivesManagement(): [557](../src/subroutines.opy#L557), [558](../src/subroutines.opy#L558), [618](../src/subroutines.opy#L618), [624](../src/subroutines.opy#L624).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [101](../src/objective_types/objective_type_survivor_rescue.opy#L101).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [7](../src/objective_types/objective_type_kill_zone.opy#L7), [9](../src/objective_types/objective_type_kill_zone.opy#L9), [18](../src/objective_types/objective_type_kill_zone.opy#L18).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [10](../src/objective_types/objective_type_satellite_uplink.opy#L10), [14](../src/objective_types/objective_type_satellite_uplink.opy#L14), [21](../src/objective_types/objective_type_satellite_uplink.opy#L21), [24](../src/objective_types/objective_type_satellite_uplink.opy#L24), [27](../src/objective_types/objective_type_satellite_uplink.opy#L27), [30](../src/objective_types/objective_type_satellite_uplink.opy#L30), [35](../src/objective_types/objective_type_satellite_uplink.opy#L35), [40](../src/objective_types/objective_type_satellite_uplink.opy#L40), [43](../src/objective_types/objective_type_satellite_uplink.opy#L43), [44](../src/objective_types/objective_type_satellite_uplink.opy#L44), [47](../src/objective_types/objective_type_satellite_uplink.opy#L47), [50](../src/objective_types/objective_type_satellite_uplink.opy#L50), [64](../src/objective_types/objective_type_satellite_uplink.opy#L64).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [26](../src/bots_game_in_progress.opy#L26), [28](../src/bots_game_in_progress.opy#L28).

## goalPost

Объявление: [variables.opy:136](../src/variables.opy#L136). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 5.

- subroutines.opy — def objectivesManagement(): [530](../src/subroutines.opy#L530), [593](../src/subroutines.opy#L593), [612](../src/subroutines.opy#L612).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [47](../src/objective_types/objective_type_showdown.opy#L47), [48](../src/objective_types/objective_type_showdown.opy#L48), [50](../src/objective_types/objective_type_showdown.opy#L50).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [64](../src/objective_types/objective_type_showdown.opy#L64).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [156](../src/objective_types/objective_type_biomorphing.opy#L156), [158](../src/objective_types/objective_type_biomorphing.opy#L158), [160](../src/objective_types/objective_type_biomorphing.opy#L160).

## queuedGoalList

Объявление: [variables.opy:137](../src/variables.opy#L137). Строк обращений: 25; упоминаний: 28; чтений вида Global в скомпилированном коде: 20.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [275](../src/subroutines.opy#L275), [297](../src/subroutines.opy#L297), [309](../src/subroutines.opy#L309).
- subroutines.opy — def objectivesManagement(): [594](../src/subroutines.opy#L594), [610](../src/subroutines.opy#L610).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [17](../src/objective_types/objective_type_showdown.opy#L17), [18](../src/objective_types/objective_type_showdown.opy#L18), [26](../src/objective_types/objective_type_showdown.opy#L26).
- objective_types/objective_type_showdown.opy — rule "INCREASE OBJECTIVE CAPTURE PERCENTAGE": [39](../src/objective_types/objective_type_showdown.opy#L39).
- objective_types/objective_type_showdown.opy — rule "DECREASES CAPTURE PERCENTAGE": [62](../src/objective_types/objective_type_showdown.opy#L62), [71](../src/objective_types/objective_type_showdown.opy#L71).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [48](../src/objective_types/objective_type_biomorphing.opy#L48), [49](../src/objective_types/objective_type_biomorphing.opy#L49), [50](../src/objective_types/objective_type_biomorphing.opy#L50), [52](../src/objective_types/objective_type_biomorphing.opy#L52), [55](../src/objective_types/objective_type_biomorphing.opy#L55), [58](../src/objective_types/objective_type_biomorphing.opy#L58).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [76](../src/objective_types/objective_type_biomorphing.opy#L76).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [147](../src/objective_types/objective_type_biomorphing.opy#L147), [151](../src/objective_types/objective_type_biomorphing.opy#L151), [155](../src/objective_types/objective_type_biomorphing.opy#L155), [157](../src/objective_types/objective_type_biomorphing.opy#L157).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [174](../src/objective_types/objective_type_biomorphing.opy#L174).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION": [76](../src/bots_game_in_progress.opy#L76).
- bots_game_in_progress.opy — rule "BOT DIES": [127](../src/bots_game_in_progress.opy#L127).

## survivorToRescue

Объявление: [variables.opy:138](../src/variables.opy#L138). Строк обращений: 77; упоминаний: 109; чтений вида Global в скомпилированном коде: 104.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [323](../src/subroutines.opy#L323).
- subroutines.opy — def objectivesManagement(): [576](../src/subroutines.opy#L576), [616](../src/subroutines.opy#L616).
- objective_types/objective_type_survivor_rescue.opy — rule "SPAWN SURVIVOR TO BE RESCUED OR COMPLETE OBJECTIVE": [8](../src/objective_types/objective_type_survivor_rescue.opy#L8), [11](../src/objective_types/objective_type_survivor_rescue.opy#L11), [19](../src/objective_types/objective_type_survivor_rescue.opy#L19), [21](../src/objective_types/objective_type_survivor_rescue.opy#L21).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED": [32](../src/objective_types/objective_type_survivor_rescue.opy#L32), [35](../src/objective_types/objective_type_survivor_rescue.opy#L35), [36](../src/objective_types/objective_type_survivor_rescue.opy#L36), [37](../src/objective_types/objective_type_survivor_rescue.opy#L37), [43](../src/objective_types/objective_type_survivor_rescue.opy#L43), [44](../src/objective_types/objective_type_survivor_rescue.opy#L44).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR TO BE RESCUED DIES": [68](../src/objective_types/objective_type_survivor_rescue.opy#L68).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [79](../src/objective_types/objective_type_survivor_rescue.opy#L79), [80](../src/objective_types/objective_type_survivor_rescue.opy#L80), [81](../src/objective_types/objective_type_survivor_rescue.opy#L81), [82](../src/objective_types/objective_type_survivor_rescue.opy#L82), [83](../src/objective_types/objective_type_survivor_rescue.opy#L83), [85](../src/objective_types/objective_type_survivor_rescue.opy#L85), [86](../src/objective_types/objective_type_survivor_rescue.opy#L86), [87](../src/objective_types/objective_type_survivor_rescue.opy#L87), [88](../src/objective_types/objective_type_survivor_rescue.opy#L88), [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [91](../src/objective_types/objective_type_survivor_rescue.opy#L91), [93](../src/objective_types/objective_type_survivor_rescue.opy#L93), [99](../src/objective_types/objective_type_survivor_rescue.opy#L99), [102](../src/objective_types/objective_type_survivor_rescue.opy#L102), [103](../src/objective_types/objective_type_survivor_rescue.opy#L103), [104](../src/objective_types/objective_type_survivor_rescue.opy#L104), [105](../src/objective_types/objective_type_survivor_rescue.opy#L105), [106](../src/objective_types/objective_type_survivor_rescue.opy#L106), [107](../src/objective_types/objective_type_survivor_rescue.opy#L107), [108](../src/objective_types/objective_type_survivor_rescue.opy#L108), [109](../src/objective_types/objective_type_survivor_rescue.opy#L109).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [116](../src/objective_types/objective_type_survivor_rescue.opy#L116), [117](../src/objective_types/objective_type_survivor_rescue.opy#L117), [118](../src/objective_types/objective_type_survivor_rescue.opy#L118), [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [121](../src/objective_types/objective_type_survivor_rescue.opy#L121).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [129](../src/objective_types/objective_type_survivor_rescue.opy#L129), [131](../src/objective_types/objective_type_survivor_rescue.opy#L131), [132](../src/objective_types/objective_type_survivor_rescue.opy#L132).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [140](../src/objective_types/objective_type_survivor_rescue.opy#L140), [141](../src/objective_types/objective_type_survivor_rescue.opy#L141), [143](../src/objective_types/objective_type_survivor_rescue.opy#L143).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [148](../src/objective_types/objective_type_survivor_rescue.opy#L148), [149](../src/objective_types/objective_type_survivor_rescue.opy#L149), [151](../src/objective_types/objective_type_survivor_rescue.opy#L151), [152](../src/objective_types/objective_type_survivor_rescue.opy#L152), [153](../src/objective_types/objective_type_survivor_rescue.opy#L153), [155](../src/objective_types/objective_type_survivor_rescue.opy#L155).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [160](../src/objective_types/objective_type_survivor_rescue.opy#L160), [161](../src/objective_types/objective_type_survivor_rescue.opy#L161), [162](../src/objective_types/objective_type_survivor_rescue.opy#L162), [165](../src/objective_types/objective_type_survivor_rescue.opy#L165).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [172](../src/objective_types/objective_type_survivor_rescue.opy#L172), [173](../src/objective_types/objective_type_survivor_rescue.opy#L173), [175](../src/objective_types/objective_type_survivor_rescue.opy#L175), [176](../src/objective_types/objective_type_survivor_rescue.opy#L176), [177](../src/objective_types/objective_type_survivor_rescue.opy#L177), [178](../src/objective_types/objective_type_survivor_rescue.opy#L178), [180](../src/objective_types/objective_type_survivor_rescue.opy#L180), [181](../src/objective_types/objective_type_survivor_rescue.opy#L181), [182](../src/objective_types/objective_type_survivor_rescue.opy#L182), [184](../src/objective_types/objective_type_survivor_rescue.opy#L184), [186](../src/objective_types/objective_type_survivor_rescue.opy#L186), [188](../src/objective_types/objective_type_survivor_rescue.opy#L188), [190](../src/objective_types/objective_type_survivor_rescue.opy#L190).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [40](../src/objective_types/objective_type_satellite_uplink.opy#L40), [44](../src/objective_types/objective_type_satellite_uplink.opy#L44), [45](../src/objective_types/objective_type_satellite_uplink.opy#L45), [47](../src/objective_types/objective_type_satellite_uplink.opy#L47).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [19](../src/bots_game_in_progress.opy#L19), [20](../src/bots_game_in_progress.opy#L20), [22](../src/bots_game_in_progress.opy#L22).

## biomorphingQueuedTypeList

Объявление: [variables.opy:141](../src/variables.opy#L141). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- objective_types/objective_type_biomorphing.opy — macro biowasteOutputMacro(): [7](../src/objective_types/objective_type_biomorphing.opy#L7), [8](../src/objective_types/objective_type_biomorphing.opy#L8), [9](../src/objective_types/objective_type_biomorphing.opy#L9), [10](../src/objective_types/objective_type_biomorphing.opy#L10).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [35](../src/objective_types/objective_type_biomorphing.opy#L35).

## biomorphingGoalText

Объявление: [variables.opy:142](../src/variables.opy#L142). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [294](../src/subroutines.opy#L294).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [46](../src/objective_types/objective_type_biomorphing.opy#L46), [53](../src/objective_types/objective_type_biomorphing.opy#L53), [56](../src/objective_types/objective_type_biomorphing.opy#L56), [59](../src/objective_types/objective_type_biomorphing.opy#L59), [62](../src/objective_types/objective_type_biomorphing.opy#L62).

## biomorphingGoalColor

Объявление: [variables.opy:143](../src/variables.opy#L143). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [294](../src/subroutines.opy#L294).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [45](../src/objective_types/objective_type_biomorphing.opy#L45), [54](../src/objective_types/objective_type_biomorphing.opy#L54), [57](../src/objective_types/objective_type_biomorphing.opy#L57), [60](../src/objective_types/objective_type_biomorphing.opy#L60), [64](../src/objective_types/objective_type_biomorphing.opy#L64), [68](../src/objective_types/objective_type_biomorphing.opy#L68).

## isBiomorphingGoalPending

Объявление: [variables.opy:144](../src/variables.opy#L144). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — def objectivesManagement(): [531](../src/subroutines.opy#L531), [611](../src/subroutines.opy#L611).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [26](../src/objective_types/objective_type_biomorphing.opy#L26), [67](../src/objective_types/objective_type_biomorphing.opy#L67).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [80](../src/objective_types/objective_type_biomorphing.opy#L80).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE": [159](../src/objective_types/objective_type_biomorphing.opy#L159).

## biomorphingResourceTypeList

Объявление: [variables.opy:145](../src/variables.opy#L145). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 1.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [15](../src/objective_types/objective_type_biomorphing.opy#L15).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [38](../src/objective_types/objective_type_biomorphing.opy#L38).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [117](../src/objective_types/objective_type_biomorphing.opy#L117), [120](../src/objective_types/objective_type_biomorphing.opy#L120).

## biomorphingDeferredTypeList

Объявление: [variables.opy:146](../src/variables.opy#L146). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 3.

- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [36](../src/objective_types/objective_type_biomorphing.opy#L36).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [176](../src/objective_types/objective_type_biomorphing.opy#L176).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [183](../src/objective_types/objective_type_biomorphing.opy#L183), [185](../src/objective_types/objective_type_biomorphing.opy#L185), [187](../src/objective_types/objective_type_biomorphing.opy#L187), [191](../src/objective_types/objective_type_biomorphing.opy#L191).

## biomorphingDeferredPositionList

Объявление: [variables.opy:147](../src/variables.opy#L147). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 1.

- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [37](../src/objective_types/objective_type_biomorphing.opy#L37).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [177](../src/objective_types/objective_type_biomorphing.opy#L177).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE MANAGEMENT": [189](../src/objective_types/objective_type_biomorphing.opy#L189), [192](../src/objective_types/objective_type_biomorphing.opy#L192).

## biomorphingResourceTextIdList

Объявление: [variables.opy:148](../src/variables.opy#L148). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [20](../src/objective_types/objective_type_biomorphing.opy#L20).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [33](../src/objective_types/objective_type_biomorphing.opy#L33), [41](../src/objective_types/objective_type_biomorphing.opy#L41).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [119](../src/objective_types/objective_type_biomorphing.opy#L119), [123](../src/objective_types/objective_type_biomorphing.opy#L123).

## biomorphingResourceEffectIdList

Объявление: [variables.opy:149](../src/variables.opy#L149). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 3.

- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [18](../src/objective_types/objective_type_biomorphing.opy#L18).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [31](../src/objective_types/objective_type_biomorphing.opy#L31), [32](../src/objective_types/objective_type_biomorphing.opy#L32), [40](../src/objective_types/objective_type_biomorphing.opy#L40).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [118](../src/objective_types/objective_type_biomorphing.opy#L118), [122](../src/objective_types/objective_type_biomorphing.opy#L122).

## biomorphingResourceColorList

Объявление: [variables.opy:150](../src/variables.opy#L150). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 5.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [297](../src/subroutines.opy#L297), [306](../src/subroutines.opy#L306), [309](../src/subroutines.opy#L309).
- subroutines.opy — def objectivesManagement(): [608](../src/subroutines.opy#L608).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [17](../src/objective_types/objective_type_biomorphing.opy#L17).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).

## biomorphingResourceNameList

Объявление: [variables.opy:151](../src/variables.opy#L151). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [297](../src/subroutines.opy#L297).
- subroutines.opy — def objectivesManagement(): [609](../src/subroutines.opy#L609).
- objective_types/objective_type_biomorphing.opy — macro biowasteAssignmentMacro(): [19](../src/objective_types/objective_type_biomorphing.opy#L19).

## extractionZoneRad

Объявление: [variables.opy:154](../src/variables.opy#L154). Строк обращений: 9; упоминаний: 10; чтений вида Global в скомпилированном коде: 8.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [239](../src/subroutines.opy#L239).
- subroutines.opy — def objectivesManagement(): [582](../src/subroutines.opy#L582).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [217](../src/global_startup.opy#L217).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE": [33](../src/objective_types/objective_type_extraction_point.opy#L33), [34](../src/objective_types/objective_type_extraction_point.opy#L34).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [165](../src/players_game_in_progress.opy#L165), [166](../src/players_game_in_progress.opy#L166), [170](../src/players_game_in_progress.opy#L170).

## extractionSpeedUp

Объявление: [variables.opy:155](../src/variables.opy#L155). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — def objectivesManagement(): [582](../src/subroutines.opy#L582).
- global_startup.opy — rule "VARIABLE ASSIGNMENT": [218](../src/global_startup.opy#L218).
- objective_types/objective_type_extraction_point.opy — rule "PLAYERS IN EXTRACTION POINT CONTROL": [19](../src/objective_types/objective_type_extraction_point.opy#L19).

## extractionFlightSpeed

Объявление: [variables.opy:156](../src/variables.opy#L156). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 6.

- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [57](../src/objective_types/objective_type_extraction_point.opy#L57), [59](../src/objective_types/objective_type_extraction_point.opy#L59), [61](../src/objective_types/objective_type_extraction_point.opy#L61), [62](../src/objective_types/objective_type_extraction_point.opy#L62), [64](../src/objective_types/objective_type_extraction_point.opy#L64), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [112](../src/objective_types/objective_type_extraction_point.opy#L112), [116](../src/objective_types/objective_type_extraction_point.opy#L116), [118](../src/objective_types/objective_type_extraction_point.opy#L118), [121](../src/objective_types/objective_type_extraction_point.opy#L121).

## extractionFlightDestination

Объявление: [variables.opy:157](../src/variables.opy#L157). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 1.

- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [63](../src/objective_types/objective_type_extraction_point.opy#L63).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [111](../src/objective_types/objective_type_extraction_point.opy#L111).

## evacSurvivorList

Объявление: [variables.opy:158](../src/variables.opy#L158). Строк обращений: 5; упоминаний: 6; чтений вида Global в скомпилированном коде: 5.

- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL": [54](../src/objective_types/objective_type_extraction_point.opy#L54), [60](../src/objective_types/objective_type_extraction_point.opy#L60).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [113](../src/objective_types/objective_type_extraction_point.opy#L113), [114](../src/objective_types/objective_type_extraction_point.opy#L114).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [147](../src/objective_types/objective_type_extraction_point.opy#L147).

## evacCount

Объявление: [variables.opy:159](../src/variables.opy#L159). Строк обращений: 2; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- objective_types/objective_type_extraction_point.opy — def nukeMap(): [146](../src/objective_types/objective_type_extraction_point.opy#L146), [148](../src/objective_types/objective_type_extraction_point.opy#L148).

## chase1

Объявление: [variables.opy:160](../src/variables.opy#L160). Строк обращений: 11; упоминаний: 11; чтений вида Global в скомпилированном коде: 5.

- subroutines.opy — def setPrematchTimer(): [473](../src/subroutines.opy#L473), [480](../src/subroutines.opy#L480), [492](../src/subroutines.opy#L492).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [168](../src/global_startup.opy#L168), [169](../src/global_startup.opy#L169).
- global_start_menu.opy — rule "END VOTING": [235](../src/global_start_menu.opy#L235).
- objective_types/objective_type_extraction_point.opy — def nukeMap(): [139](../src/objective_types/objective_type_extraction_point.opy#L139), [140](../src/objective_types/objective_type_extraction_point.opy#L140), [142](../src/objective_types/objective_type_extraction_point.opy#L142), [143](../src/objective_types/objective_type_extraction_point.opy#L143), [144](../src/objective_types/objective_type_extraction_point.opy#L144).

## supplyDropLandingPosition

Объявление: [variables.opy:163](../src/variables.opy#L163). Строк обращений: 18; упоминаний: 31; чтений вида Global в скомпилированном коде: 28.

- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [27](../src/supply_drops.opy#L27), [32](../src/supply_drops.opy#L32), [40](../src/supply_drops.opy#L40), [42](../src/supply_drops.opy#L42), [44](../src/supply_drops.opy#L44), [45](../src/supply_drops.opy#L45), [47](../src/supply_drops.opy#L47), [49](../src/supply_drops.opy#L49), [50](../src/supply_drops.opy#L50).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [62](../src/supply_drops.opy#L62), [64](../src/supply_drops.opy#L64), [66](../src/supply_drops.opy#L66), [68](../src/supply_drops.opy#L68), [72](../src/supply_drops.opy#L72), [74](../src/supply_drops.opy#L74).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [97](../src/supply_drops.opy#L97).

## supplyDropPosition

Объявление: [variables.opy:164](../src/variables.opy#L164). Строк обращений: 14; упоминаний: 20; чтений вида Global в скомпилированном коде: 16.

- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [28](../src/supply_drops.opy#L28), [44](../src/supply_drops.opy#L44), [45](../src/supply_drops.opy#L45), [47](../src/supply_drops.opy#L47), [48](../src/supply_drops.opy#L48).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [62](../src/supply_drops.opy#L62), [64](../src/supply_drops.opy#L64), [68](../src/supply_drops.opy#L68), [72](../src/supply_drops.opy#L72), [74](../src/supply_drops.opy#L74).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [87](../src/supply_drops.opy#L87), [88](../src/supply_drops.opy#L88).

## isSupplyDropOpen

Объявление: [variables.opy:165](../src/variables.opy#L165). Строк обращений: 8; упоминаний: 8; чтений вида Global в скомпилированном коде: 5.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [247](../src/global_startup.opy#L247).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [19](../src/supply_drops.opy#L19), [29](../src/supply_drops.opy#L29).
- supply_drops.opy — rule "EFFECT/TEXT (GLOBAL)": [60](../src/supply_drops.opy#L60), [64](../src/supply_drops.opy#L64), [68](../src/supply_drops.opy#L68).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [85](../src/supply_drops.opy#L85), [86](../src/supply_drops.opy#L86).

## supplyDropPowerUpCount

Объявление: [variables.opy:166](../src/variables.opy#L166). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [259](../src/global_startup.opy#L259).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [91](../src/supply_drops.opy#L91), [96](../src/supply_drops.opy#L96).

## supplyPowerUpIdList

Объявление: [variables.opy:167](../src/variables.opy#L167). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 5.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [250](../src/global_startup.opy#L250).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [93](../src/objective_types/objective_type_biomorphing.opy#L93).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [93](../src/supply_drops.opy#L93), [108](../src/supply_drops.opy#L108), [112](../src/supply_drops.opy#L112), [119](../src/supply_drops.opy#L119).
- power_ups.opy — macro powerUpAssignmentMacro(): [7](../src/power_ups.opy#L7), [8](../src/power_ups.opy#L8), [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)": [82](../src/power_ups.opy#L82).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)": [96](../src/power_ups.opy#L96).

## supplyPowerUpPositionList

Объявление: [variables.opy:168](../src/variables.opy#L168). Строк обращений: 16; упоминаний: 18; чтений вида Global в скомпилированном коде: 11.

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

Объявление: [variables.opy:169](../src/variables.opy#L169). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 2.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [253](../src/global_startup.opy#L253).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [110](../src/supply_drops.opy#L110), [115](../src/supply_drops.opy#L115).
- power_ups.opy — macro powerUpAssignmentMacro(): [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [18](../src/power_ups.opy#L18).

## supplyPowerUpEffectIdList

Объявление: [variables.opy:170](../src/variables.opy#L170). Строк обращений: 8; упоминаний: 10; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [252](../src/global_startup.opy#L252).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)": [109](../src/supply_drops.opy#L109), [114](../src/supply_drops.opy#L114).
- power_ups.opy — macro powerUpAssignmentMacro(): [7](../src/power_ups.opy#L7), [8](../src/power_ups.opy#L8), [9](../src/power_ups.opy#L9).
- power_ups.opy — rule "POWER UP EFFECT/TEXT MANAGEMENT": [14](../src/power_ups.opy#L14), [17](../src/power_ups.opy#L17).

## playerTargetList

Объявление: [variables.opy:173](../src/variables.opy#L173). Строк обращений: 58; упоминаний: 62; чтений вида Global в скомпилированном коде: 55.

- subroutines.opy — def selectTarget(): [657](../src/subroutines.opy#L657), [661](../src/subroutines.opy#L661), [663](../src/subroutines.opy#L663), [665](../src/subroutines.opy#L665).
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
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [601](../src/zombie_types.opy#L601), [602](../src/zombie_types.opy#L602).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1285](../src/zombie_types.opy#L1285).
- supply_drops.opy — rule "GENERATE SUPPLY DROPS": [35](../src/supply_drops.opy#L35), [38](../src/supply_drops.opy#L38).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION": [117](../src/enhancements.opy#L117).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)": [417](../src/enhancements.opy#L417).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH": [441](../src/enhancements.opy#L441), [443](../src/enhancements.opy#L443).

## userNameList

Объявление: [variables.opy:174](../src/variables.opy#L174). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [237](../src/global_startup.opy#L237).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [64](../src/players_game_in_progress.opy#L64), [71](../src/players_game_in_progress.opy#L71).
- players_game_in_progress.opy — def updateUsers(): [364](../src/players_game_in_progress.opy#L364), [366](../src/players_game_in_progress.opy#L366), [368](../src/players_game_in_progress.opy#L368).

## playerStatsList

Объявление: [variables.opy:175](../src/variables.opy#L175). Строк обращений: 13; упоминаний: 13; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [238](../src/global_startup.opy#L238), [241](../src/global_startup.opy#L241).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [72](../src/players_game_in_progress.opy#L72), [73](../src/players_game_in_progress.opy#L73), [74](../src/players_game_in_progress.opy#L74), [75](../src/players_game_in_progress.opy#L75), [79](../src/players_game_in_progress.opy#L79), [80](../src/players_game_in_progress.opy#L80), [85](../src/players_game_in_progress.opy#L85).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [154](../src/players_game_in_progress.opy#L154), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## healthpackPositionList

Объявление: [variables.opy:176](../src/variables.opy#L176). Строк обращений: 6; упоминаний: 9; чтений вида Global в скомпилированном коде: 7.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [234](../src/global_startup.opy#L234).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK": [214](../src/players_game_in_progress.opy#L214), [215](../src/players_game_in_progress.opy#L215).

## mustReviveTime

Объявление: [variables.opy:177](../src/variables.opy#L177). Строк обращений: 5; упоминаний: 6; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [245](../src/global_startup.opy#L245).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION": [59](../src/players_game_in_progress.opy#L59).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER": [186](../src/players_game_in_progress.opy#L186), [188](../src/players_game_in_progress.opy#L188), [201](../src/players_game_in_progress.opy#L201).

## botHeroList

Объявление: [variables.opy:180](../src/variables.opy#L180). Строк обращений: 10; упоминаний: 10; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro botStatManagementMacro(): [33](../src/subroutines.opy#L33).
- subroutines.opy — def botRespawnInitialization(): [705](../src/subroutines.opy#L705).
- global_startup.opy — macro botHeroRandomizationMacro(): [52](../src/global_startup.opy#L52), [68](../src/global_startup.opy#L68), [70](../src/global_startup.opy#L70).
- global_start_menu.opy — def setZombieMode(): [291](../src/global_start_menu.opy#L291).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [12](../src/objective_types/objective_type_bosses.opy#L12).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [43](../src/objective_types/objective_type_bosses.opy#L43), [45](../src/objective_types/objective_type_bosses.opy#L45).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [9](../src/objective_types/objective_type_zombie_egg.opy#L9).

## botSpawnRateList

Объявление: [variables.opy:181](../src/variables.opy#L181). Строк обращений: 11; упоминаний: 12; чтений вида Global в скомпилированном коде: 4.

- global_startup.opy — macro botHeroRandomizationMacro(): [67](../src/global_startup.opy#L67), [70](../src/global_startup.opy#L70).
- global_start_menu.opy — def setZombieMode(): [297](../src/global_start_menu.opy#L297), [301](../src/global_start_menu.opy#L301), [305](../src/global_start_menu.opy#L305), [308](../src/global_start_menu.opy#L308), [312](../src/global_start_menu.opy#L312), [316](../src/global_start_menu.opy#L316), [320](../src/global_start_menu.opy#L320).
- global_game_in_progress.opy — rule "ZOMBIE SHUFFLE": [70](../src/global_game_in_progress.opy#L70).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [45](../src/objective_types/objective_type_bosses.opy#L45).

## botBiteDamageList

Объявление: [variables.opy:182](../src/variables.opy#L182). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [34](../src/subroutines.opy#L34).
- subroutines.opy — def setDifficulty(): [405](../src/subroutines.opy#L405), [428](../src/subroutines.opy#L428), [440](../src/subroutines.opy#L440), [452](../src/subroutines.opy#L452), [462](../src/subroutines.opy#L462).

## botBiteDurationList

Объявление: [variables.opy:183](../src/variables.opy#L183). Строк обращений: 5; упоминаний: 5; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [37](../src/subroutines.opy#L37).
- subroutines.opy — def setDifficulty(): [407](../src/subroutines.opy#L407), [424](../src/subroutines.opy#L424), [430](../src/subroutines.opy#L430), [442](../src/subroutines.opy#L442).

## botDamageDealtList

Объявление: [variables.opy:184](../src/variables.opy#L184). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro botStatManagementMacro(): [36](../src/subroutines.opy#L36), [41](../src/subroutines.opy#L41).
- subroutines.opy — def setDifficulty(): [414](../src/subroutines.opy#L414), [434](../src/subroutines.opy#L434), [446](../src/subroutines.opy#L446), [456](../src/subroutines.opy#L456), [466](../src/subroutines.opy#L466).

## botHealthList

Объявление: [variables.opy:185](../src/variables.opy#L185). Строк обращений: 6; упоминаний: 6; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — def setDifficulty(): [403](../src/subroutines.opy#L403), [422](../src/subroutines.opy#L422), [438](../src/subroutines.opy#L438), [450](../src/subroutines.opy#L450), [460](../src/subroutines.opy#L460).
- subroutines.opy — def botRespawnInitialization(): [705](../src/subroutines.opy#L705).

## botThrottleSpeedList

Объявление: [variables.opy:186](../src/variables.opy#L186). Строк обращений: 7; упоминаний: 7; чтений вида Global в скомпилированном коде: 1.

- subroutines.opy — macro botStatManagementMacro(): [39](../src/subroutines.opy#L39).
- subroutines.opy — def setDifficulty(): [409](../src/subroutines.opy#L409), [412](../src/subroutines.opy#L412), [432](../src/subroutines.opy#L432), [444](../src/subroutines.opy#L444), [454](../src/subroutines.opy#L454), [464](../src/subroutines.opy#L464).

## availableMutationList

Объявление: [variables.opy:187](../src/variables.opy#L187). Строк обращений: 4; упоминаний: 4; чтений вида Global в скомпилированном коде: 2.

- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78), [79](../src/subroutines.opy#L79).
- global_startup.opy — macro enableMutationsMacro(): [74](../src/global_startup.opy#L74), [81](../src/global_startup.opy#L81).

## miniBossList

Объявление: [variables.opy:188](../src/variables.opy#L188). Строк обращений: 16; упоминаний: 17; чтений вида Global в скомпилированном коде: 14.

- subroutines.opy — macro minibossMutationMacro(): [18](../src/subroutines.opy#L18).
- subroutines.opy — macro botEntityManagementMacro(): [178](../src/subroutines.opy#L178).
- subroutines.opy — def selectTarget(): [654](../src/subroutines.opy#L654).
- subroutines.opy — def botRespawnInitialization(): [724](../src/subroutines.opy#L724), [731](../src/subroutines.opy#L731).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [36](../src/objective_types/objective_type_bosses.opy#L36).
- bots_game_in_progress.opy — rule "BOT DIES": [134](../src/bots_game_in_progress.opy#L134), [145](../src/bots_game_in_progress.opy#L145).
- bots_game_in_progress.opy — rule "BOT TAKES DAMAGE AND SWITCHES TARGETS": [254](../src/bots_game_in_progress.opy#L254).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)": [398](../src/bots_game_in_progress.opy#L398).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE": [525](../src/bots_game_in_progress.opy#L525).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED": [406](../src/zombie_types.opy#L406).
- zombie_types.opy — rule "PROTECTOR (KIRIKO) USES CLEANSE": [1345](../src/zombie_types.opy#L1345).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)": [1384](../src/zombie_types.opy#L1384).
- zombie_types.opy — rule "CHARGER, STRIKER, SUCCESSOR USE ULT ON POINT (MINIBOSS)": [1408](../src/zombie_types.opy#L1408).

## bossStateList

Объявление: [variables.opy:189](../src/variables.opy#L189). Строк обращений: 110; упоминаний: 121; чтений вида Global в скомпилированном коде: 112.

- subroutines.opy — macro minibossMutationMacro(): [27](../src/subroutines.opy#L27).
- subroutines.opy — macro botStatManagementMacro(): [56](../src/subroutines.opy#L56).
- subroutines.opy — macro mutationsMacro(): [78](../src/subroutines.opy#L78).
- subroutines.opy — macro botEntityManagementMacro(): [125](../src/subroutines.opy#L125), [136](../src/subroutines.opy#L136), [167](../src/subroutines.opy#L167), [183](../src/subroutines.opy#L183), [203](../src/subroutines.opy#L203), [206](../src/subroutines.opy#L206).
- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [280](../src/subroutines.opy#L280), [286](../src/subroutines.opy#L286), [289](../src/subroutines.opy#L289), [351](../src/subroutines.opy#L351), [363](../src/subroutines.opy#L363).
- subroutines.opy — def objectivesManagement(): [575](../src/subroutines.opy#L575).
- subroutines.opy — def selectTarget(): [659](../src/subroutines.opy#L659).
- subroutines.opy — def botRespawnInitialization(): [698](../src/subroutines.opy#L698), [724](../src/subroutines.opy#L724).
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
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS": [434](../src/zombie_types.opy#L434).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE": [553](../src/zombie_types.opy#L553), [563](../src/zombie_types.opy#L563).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB": [622](../src/zombie_types.opy#L622).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)": [641](../src/zombie_types.opy#L641).
- zombie_types.opy — rule "STRIKER NORMAL PILE DRIVER": [746](../src/zombie_types.opy#L746).
- zombie_types.opy — rule "STALKER (MOIRA) FADE": [767](../src/zombie_types.opy#L767), [772](../src/zombie_types.opy#L772), [785](../src/zombie_types.opy#L785), [800](../src/zombie_types.opy#L800).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES": [860](../src/zombie_types.opy#L860).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES": [908](../src/zombie_types.opy#L908).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER": [925](../src/zombie_types.opy#L925), [938](../src/zombie_types.opy#L938).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST": [1011](../src/zombie_types.opy#L1011), [1013](../src/zombie_types.opy#L1013), [1014](../src/zombie_types.opy#L1014), [1052](../src/zombie_types.opy#L1052), [1068](../src/zombie_types.opy#L1068), [1070](../src/zombie_types.opy#L1070).
- zombie_types.opy — rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)": [1082](../src/zombie_types.opy#L1082).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH": [1114](../src/zombie_types.opy#L1114).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS": [1149](../src/zombie_types.opy#L1149), [1154](../src/zombie_types.opy#L1154).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER": [1201](../src/zombie_types.opy#L1201).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE": [1225](../src/zombie_types.opy#L1225).
- zombie_types.opy — rule "SMOLDER BOSS SLAM": [1251](../src/zombie_types.opy#L1251).
- zombie_types.opy — rule "SMOLDER SUPER SLAM": [1280](../src/zombie_types.opy#L1280).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1297](../src/zombie_types.opy#L1297).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS": [1310](../src/zombie_types.opy#L1310).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT": [1336](../src/zombie_types.opy#L1336).
- supply_drops.opy — def stun(): [428](../src/supply_drops.opy#L428), [432](../src/supply_drops.opy#L432).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE": [273](../src/enhancements.opy#L273).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE": [301](../src/enhancements.opy#L301).

## isSmolderEventActive

Объявление: [variables.opy:190](../src/variables.opy#L190). Строк обращений: 12; упоминаний: 13; чтений вида Global в скомпилированном коде: 9.

- subroutines.opy — macro botEntityManagementMacro(): [208](../src/subroutines.opy#L208), [211](../src/subroutines.opy#L211).
- subroutines.opy — def objectivesManagement(): [529](../src/subroutines.opy#L529).
- global_startup.opy — macro botHeroRandomizationMacro(): [53](../src/global_startup.opy#L53).
- global_game_in_progress.opy — rule "RANDOM ABILITIES": [97](../src/global_game_in_progress.opy#L97).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS": [121](../src/players_game_in_progress.opy#L121).
- zombie_types.opy — rule "SMOLDER BOSS SLAM": [1247](../src/zombie_types.opy#L1247).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1295](../src/zombie_types.opy#L1295).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS": [1314](../src/zombie_types.opy#L1314), [1321](../src/zombie_types.opy#L1321), [1324](../src/zombie_types.opy#L1324).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT": [1335](../src/zombie_types.opy#L1335).

## bossesAvailableHeroList

Объявление: [variables.opy:193](../src/variables.opy#L193). Строк обращений: 8; упоминаний: 8; чтений вида Global в скомпилированном коде: 3.

- global_startup.opy — rule "VARIABLE ASSIGNMENT": [255](../src/global_startup.opy#L255).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [41](../src/objective_types/objective_type_bosses.opy#L41), [43](../src/objective_types/objective_type_bosses.opy#L43), [45](../src/objective_types/objective_type_bosses.opy#L45), [46](../src/objective_types/objective_type_bosses.opy#L46), [47](../src/objective_types/objective_type_bosses.opy#L47), [50](../src/objective_types/objective_type_bosses.opy#L50), [55](../src/objective_types/objective_type_bosses.opy#L55).

## bossesExcludedHeroList

Объявление: [variables.opy:194](../src/variables.opy#L194). Строк обращений: 3; упоминаний: 3; чтений вида Global в скомпилированном коде: 2.

- global_start_menu.opy — def setZombieMode(): [293](../src/global_start_menu.opy#L293).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS": [46](../src/objective_types/objective_type_bosses.opy#L46), [47](../src/objective_types/objective_type_bosses.opy#L47).

## numbersList

Объявление: [compressed numbers.opy:6](../src/compressed%20numbers.opy#L6). Строк обращений: 28; упоминаний: 28; чтений вида Global в скомпилированном коде: 28.

- subroutines.opy — def setDifficulty(): [403](../src/subroutines.opy#L403), [405](../src/subroutines.opy#L405), [407](../src/subroutines.opy#L407), [414](../src/subroutines.opy#L414), [422](../src/subroutines.opy#L422), [424](../src/subroutines.opy#L424), [428](../src/subroutines.opy#L428), [430](../src/subroutines.opy#L430), [432](../src/subroutines.opy#L432), [434](../src/subroutines.opy#L434), [440](../src/subroutines.opy#L440), [442](../src/subroutines.opy#L442), [444](../src/subroutines.opy#L444), [446](../src/subroutines.opy#L446), [450](../src/subroutines.opy#L450), [452](../src/subroutines.opy#L452), [454](../src/subroutines.opy#L454), [456](../src/subroutines.opy#L456), [462](../src/subroutines.opy#L462), [464](../src/subroutines.opy#L464), [466](../src/subroutines.opy#L466).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [79](../src/global_start_menu.opy#L79), [107](../src/global_start_menu.opy#L107).
- global_start_menu.opy — def setZombieMode(): [297](../src/global_start_menu.opy#L297), [301](../src/global_start_menu.opy#L301), [312](../src/global_start_menu.opy#L312), [316](../src/global_start_menu.opy#L316), [320](../src/global_start_menu.opy#L320).

## debugHud

Объявление: [debug.opy:7](../src/debug.opy#L7). Строк обращений: 2; упоминаний: 2; чтений вида Global в скомпилированном коде: 1.

- debug.opy — rule "[debug] Resource usage and server load": [30](../src/debug.opy#L30), [33](../src/debug.opy#L33).
