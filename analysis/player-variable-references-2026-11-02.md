# Обращения к переменным игрока — 2026-11-02

Сгенерировано `node analysis/audit-player-variables.cjs`. Команда правила не доказывает команду получателя поля: учитывайте выражение слева от точки и вызовы подпрограмм. Алиасы собраны в физические слоты.

## botBiteDamage

Объявление: [variables.opy:271](../src/core/variables.opy#L271).

- subroutines.opy — macro botStatManagementMacro(): [35](../src/core/subroutines.opy#L35), [37](../src/core/subroutines.opy#L37).
- subroutines.opy — def explosionSequence(): [777](../src/core/subroutines.opy#L777), [780](../src/core/subroutines.opy#L780), [784](../src/core/subroutines.opy#L784).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [395](../src/game/bots_game_in_progress.opy#L395).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [152](../src/game/zombie_types.opy#L152).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [181](../src/game/zombie_types.opy#L181).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [242](../src/game/zombie_types.opy#L242).
- zombie_types.opy — rule "CHARGER KNOCKBACK" (event Team 2): [577](../src/game/zombie_types.opy#L577).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [890](../src/game/zombie_types.opy#L890), [895](../src/game/zombie_types.opy#L895).

## botBaseHealth

Объявление: [variables.opy:273](../src/core/variables.opy#L273).

- subroutines.opy — macro minibossMutationMacro(): [22](../src/core/subroutines.opy#L22).
- subroutines.opy — macro mutationsMacro(): [93](../src/core/subroutines.opy#L93), [99](../src/core/subroutines.opy#L99), [115](../src/core/subroutines.opy#L115).
- subroutines.opy — def botRespawnInitialization(): [712](../src/core/subroutines.opy#L712), [717](../src/core/subroutines.opy#L717), [750](../src/core/subroutines.opy#L750), [752](../src/core/subroutines.opy#L752).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [59](../src/objective_types/objective_type_bosses.opy#L59), [60](../src/objective_types/objective_type_bosses.opy#L60), [78](../src/objective_types/objective_type_bosses.opy#L78).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [11](../src/objective_types/objective_type_kill_zone.opy#L11).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [36](../src/objective_types/objective_type_zombie_egg.opy#L36), [37](../src/objective_types/objective_type_zombie_egg.opy#L37).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [50](../src/game/bots_game_in_progress.opy#L50), [54](../src/game/bots_game_in_progress.opy#L54).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [81](../src/game/bots_game_in_progress.opy#L81), [83](../src/game/bots_game_in_progress.opy#L83).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [130](../src/game/bots_game_in_progress.opy#L130), [132](../src/game/bots_game_in_progress.opy#L132).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [412](../src/game/bots_game_in_progress.opy#L412), [418](../src/game/bots_game_in_progress.opy#L418).

## isPlayerActive

Объявление: [variables.opy:276](../src/core/variables.opy#L276).

- subroutines.opy — def setPrematchTimer(): [494](../src/core/subroutines.opy#L494), [506](../src/core/subroutines.opy#L506).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [144](../src/core/global_startup.opy#L144).
- global_start_menu.opy — def determineZombieMode(): [277](../src/game/global_start_menu.opy#L277).
- global_start_menu.opy — def determineChallenge(): [340](../src/game/global_start_menu.opy#L340).
- global_start_menu.opy — def determineObjectiveType(): [376](../src/game/global_start_menu.opy#L376).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [36](../src/game/player_start_menu.opy#L36).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [83](../src/game/player_start_menu.opy#L83), [85](../src/game/player_start_menu.opy#L85).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [68](../src/game/players_game_in_progress.opy#L68), [78](../src/game/players_game_in_progress.opy#L78), [84](../src/game/players_game_in_progress.opy#L84), [94](../src/game/players_game_in_progress.opy#L94).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [107](../src/game/players_game_in_progress.opy#L107).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [127](../src/game/players_game_in_progress.opy#L127).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [149](../src/game/players_game_in_progress.opy#L149).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [259](../src/game/players_game_in_progress.opy#L259).

## isReviving

Объявление: [variables.opy:278](../src/core/variables.opy#L278).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [52](../src/game/players_game_in_progress.opy#L52).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/game/players_game_in_progress.opy#L117), [119](../src/game/players_game_in_progress.opy#L119), [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/game/players_game_in_progress.opy#L155), [157](../src/game/players_game_in_progress.opy#L157), [163](../src/game/players_game_in_progress.opy#L163), [179](../src/game/players_game_in_progress.opy#L179), [199](../src/game/players_game_in_progress.opy#L199).

## reviveDuration

Объявление: [variables.opy:280](../src/core/variables.opy#L280).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [57](../src/game/players_game_in_progress.opy#L57), [58](../src/game/players_game_in_progress.opy#L58), [74](../src/game/players_game_in_progress.opy#L74).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/game/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/game/players_game_in_progress.opy#L154), [176](../src/game/players_game_in_progress.opy#L176), [177](../src/game/players_game_in_progress.opy#L177), [184](../src/game/players_game_in_progress.opy#L184), [203](../src/game/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/game/players_game_in_progress.opy#L370).

## isInfected

Объявление: [variables.opy:282](../src/core/variables.opy#L282).

- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/game/global_game_in_progress.opy#L12), [14](../src/game/global_game_in_progress.opy#L14), [16](../src/game/global_game_in_progress.opy#L16).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [39](../src/objective_types/objective_type_extraction_point.opy#L39), [40](../src/objective_types/objective_type_extraction_point.opy#L40).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [55](../src/game/players_game_in_progress.opy#L55).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/game/players_game_in_progress.opy#L115).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [134](../src/game/players_game_in_progress.opy#L134).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [219](../src/game/players_game_in_progress.opy#L219), [221](../src/game/players_game_in_progress.opy#L221).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [242](../src/game/players_game_in_progress.opy#L242), [245](../src/game/players_game_in_progress.opy#L245).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/game/bots_game_in_progress.opy#L399), [400](../src/game/bots_game_in_progress.opy#L400), [401](../src/game/bots_game_in_progress.opy#L401).
- supply_drops.opy — def powerUpUsage(): [468](../src/items/supply_drops.opy#L468).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [81](../src/abilities/enhancements.opy#L81).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [375](../src/abilities/enhancements.opy#L375).

## rescueTimeRemaining

Объявление: [variables.opy:284](../src/core/variables.opy#L284).

- subroutines.opy — macro botStatManagementMacro(): [47](../src/core/subroutines.opy#L47).
- global_game_in_progress.opy — rule "OBJECTIVE COMPLETE": [133](../src/game/global_game_in_progress.opy#L133).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [59](../src/game/players_game_in_progress.opy#L59), [72](../src/game/players_game_in_progress.opy#L72), [86](../src/game/players_game_in_progress.opy#L86).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/game/players_game_in_progress.opy#L117), [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [150](../src/game/players_game_in_progress.opy#L150), [154](../src/game/players_game_in_progress.opy#L154), [160](../src/game/players_game_in_progress.opy#L160), [161](../src/game/players_game_in_progress.opy#L161), [165](../src/game/players_game_in_progress.opy#L165), [166](../src/game/players_game_in_progress.opy#L166), [168](../src/game/players_game_in_progress.opy#L168), [171](../src/game/players_game_in_progress.opy#L171), [182](../src/game/players_game_in_progress.opy#L182), [184](../src/game/players_game_in_progress.opy#L184), [201](../src/game/players_game_in_progress.opy#L201), [203](../src/game/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/game/players_game_in_progress.opy#L370).

## infectionLevel

Объявление: [variables.opy:286](../src/core/variables.opy#L286).

- subroutines.opy — def explosionSequence(): [777](../src/core/subroutines.opy#L777).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/game/global_game_in_progress.opy#L12).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [38](../src/objective_types/objective_type_extraction_point.opy#L38), [39](../src/objective_types/objective_type_extraction_point.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [60](../src/game/players_game_in_progress.opy#L60).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [133](../src/game/players_game_in_progress.opy#L133).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [218](../src/game/players_game_in_progress.opy#L218), [220](../src/game/players_game_in_progress.opy#L220).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [244](../src/game/players_game_in_progress.opy#L244), [246](../src/game/players_game_in_progress.opy#L246).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/game/bots_game_in_progress.opy#L399), [400](../src/game/bots_game_in_progress.opy#L400).
- supply_drops.opy — def powerUpUsage(): [467](../src/items/supply_drops.opy#L467), [469](../src/items/supply_drops.opy#L469), [504](../src/items/supply_drops.opy#L504).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/abilities/enhancements.opy#L29), [36](../src/abilities/enhancements.opy#L36).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [167](../src/abilities/enhancements.opy#L167), [171](../src/abilities/enhancements.opy#L171).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [376](../src/abilities/enhancements.opy#L376), [378](../src/abilities/enhancements.opy#L378), [379](../src/abilities/enhancements.opy#L379), [381](../src/abilities/enhancements.opy#L381), [382](../src/abilities/enhancements.opy#L382).

## invisibilityCount

Объявление: [variables.opy:288](../src/core/variables.opy#L288).

- subroutines.opy — def selectTarget(): [676](../src/core/subroutines.opy#L676).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [78](../src/game/player_start_menu.opy#L78).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [8](../src/objective_types/objective_type_showdown.opy#L8).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [150](../src/objective_types/objective_type_biomorphing.opy#L150).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [83](../src/objective_types/objective_type_survivor_rescue.opy#L83), [89](../src/objective_types/objective_type_survivor_rescue.opy#L89).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS" (event Team 1): [110](../src/objective_types/objective_type_satellite_uplink.opy#L110).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [40](../src/game/players_game_in_progress.opy#L40).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/game/players_game_in_progress.opy#L155), [156](../src/game/players_game_in_progress.opy#L156).
- hero_tuning.opy — rule "SOMBRA USES TRANSLOCATOR" (event Team 1): [22](../src/abilities/hero_tuning.opy#L22), [24](../src/abilities/hero_tuning.opy#L24).
- hero_tuning.opy — rule "DOOMFIST INVIS WHILE ULTING" (event Team 1): [34](../src/abilities/hero_tuning.opy#L34), [36](../src/abilities/hero_tuning.opy#L36).
- hero_tuning.opy — rule "MOIRA & VENTURE INVIS WHILE USING SKILL" (event Team 1): [46](../src/abilities/hero_tuning.opy#L46), [48](../src/abilities/hero_tuning.opy#L48).
- hero_tuning.opy — rule "TRACER INVIS WHILE RECALLING" (event Team 1): [58](../src/abilities/hero_tuning.opy#L58), [60](../src/abilities/hero_tuning.opy#L60).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [191](../src/game/bots_game_in_progress.opy#L191).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [241](../src/game/bots_game_in_progress.opy#L241), [242](../src/game/bots_game_in_progress.opy#L242).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [268](../src/game/bots_game_in_progress.opy#L268).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [451](../src/game/zombie_types.opy#L451).
- supply_drops.opy — def cloakingDevice(): [310](../src/items/supply_drops.opy#L310), [311](../src/items/supply_drops.opy#L311), [323](../src/items/supply_drops.opy#L323), [327](../src/items/supply_drops.opy#L327).

## infectionDamageOverTimeId

Объявление: [variables.opy:290](../src/core/variables.opy#L290).

- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [248](../src/game/players_game_in_progress.opy#L248).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [170](../src/abilities/enhancements.opy#L170).

## reconnectUserIndex

Объявление: [variables.opy:292](../src/core/variables.opy#L292).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [71](../src/game/players_game_in_progress.opy#L71), [72](../src/game/players_game_in_progress.opy#L72), [73](../src/game/players_game_in_progress.opy#L73), [74](../src/game/players_game_in_progress.opy#L74), [75](../src/game/players_game_in_progress.opy#L75), [79](../src/game/players_game_in_progress.opy#L79), [80](../src/game/players_game_in_progress.opy#L80), [85](../src/game/players_game_in_progress.opy#L85).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/game/players_game_in_progress.opy#L154), [184](../src/game/players_game_in_progress.opy#L184), [203](../src/game/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [368](../src/game/players_game_in_progress.opy#L368), [370](../src/game/players_game_in_progress.opy#L370).

## isAfk

Объявление: [variables.opy:294](../src/core/variables.opy#L294).

- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [154](../src/objective_types/objective_type_biomorphing.opy#L154).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [44](../src/game/players_game_in_progress.opy#L44).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [269](../src/game/players_game_in_progress.opy#L269), [273](../src/game/players_game_in_progress.opy#L273), [281](../src/game/players_game_in_progress.opy#L281), [282](../src/game/players_game_in_progress.opy#L282).
- players_game_in_progress.opy — rule "PLAYER TARGET (ADD)" (event Team 1): [330](../src/game/players_game_in_progress.opy#L330).

## isHeroSwitchRespawn

Объявление: [variables.opy:296](../src/core/variables.opy#L296).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [45](../src/game/players_game_in_progress.opy#L45).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [111](../src/game/players_game_in_progress.opy#L111).
- players_game_in_progress.opy — rule "PLAYER SWITCHES HERO" (event Team 1): [301](../src/game/players_game_in_progress.opy#L301).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [10](../src/abilities/enhancements.opy#L10).

## enhancementId

Объявление: [variables.opy:299](../src/core/variables.opy#L299).

- global_start_menu.opy — rule "EFFECTS/TEXTS": [176](../src/game/global_start_menu.opy#L176), [189](../src/game/global_start_menu.opy#L189), [202](../src/game/global_start_menu.opy#L202), [206](../src/game/global_start_menu.opy#L206), [207](../src/game/global_start_menu.opy#L207), [208](../src/game/global_start_menu.opy#L208).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [15](../src/game/player_start_menu.opy#L15).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [53](../src/game/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [90](../src/game/player_start_menu.opy#L90).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)" (event Team 1): [195](../src/game/player_start_menu.opy#L195), [196](../src/game/player_start_menu.opy#L196), [197](../src/game/player_start_menu.opy#L197), [199](../src/game/player_start_menu.opy#L199), [200](../src/game/player_start_menu.opy#L200), [201](../src/game/player_start_menu.opy#L201).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/game/global_game_in_progress.opy#L12), [14](../src/game/global_game_in_progress.opy#L14), [16](../src/game/global_game_in_progress.opy#L16).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [40](../src/objective_types/objective_type_survivor_rescue.opy#L40).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/game/players_game_in_progress.opy#L115), [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [246](../src/game/players_game_in_progress.opy#L246), [247](../src/game/players_game_in_progress.opy#L247).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/game/bots_game_in_progress.opy#L399).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [12](../src/abilities/enhancements.opy#L12), [15](../src/abilities/enhancements.opy#L15), [17](../src/abilities/enhancements.opy#L17), [26](../src/abilities/enhancements.opy#L26), [38](../src/abilities/enhancements.opy#L38).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [163](../src/abilities/enhancements.opy#L163).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [182](../src/abilities/enhancements.opy#L182).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [220](../src/abilities/enhancements.opy#L220).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [273](../src/abilities/enhancements.opy#L273).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [284](../src/abilities/enhancements.opy#L284).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [296](../src/abilities/enhancements.opy#L296).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [320](../src/abilities/enhancements.opy#L320).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [329](../src/abilities/enhancements.opy#L329).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [373](../src/abilities/enhancements.opy#L373), [378](../src/abilities/enhancements.opy#L378).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [392](../src/abilities/enhancements.opy#L392).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [421](../src/abilities/enhancements.opy#L421).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [443](../src/abilities/enhancements.opy#L443).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [496](../src/abilities/enhancements.opy#L496).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [522](../src/abilities/enhancements.opy#L522).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [554](../src/abilities/enhancements.opy#L554).

## enhancementHitchhikerPassenger

Объявление: [variables.opy:301](../src/core/variables.opy#L301).

- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/game/bots_game_in_progress.opy#L398).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [468](../src/abilities/enhancements.opy#L468), [475](../src/abilities/enhancements.opy#L475).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [485](../src/abilities/enhancements.opy#L485), [487](../src/abilities/enhancements.opy#L487), [489](../src/abilities/enhancements.opy#L489).

## enhancementHitchhikerCarrierPoolId

Объявление: [variables.opy:303](../src/core/variables.opy#L303).

- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [488](../src/abilities/enhancements.opy#L488), [490](../src/abilities/enhancements.opy#L490).

## pregameState

Объявление: [variables.opy:307](../src/core/variables.opy#L307).

- subroutines.opy — def setPrematchTimer(): [492](../src/core/subroutines.opy#L492), [494](../src/core/subroutines.opy#L494), [499](../src/core/subroutines.opy#L499), [502](../src/core/subroutines.opy#L502), [506](../src/core/subroutines.opy#L506).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [67](../src/game/global_start_menu.opy#L67), [69](../src/game/global_start_menu.opy#L69), [71](../src/game/global_start_menu.opy#L71), [73](../src/game/global_start_menu.opy#L73), [75](../src/game/global_start_menu.opy#L75).
- global_start_menu.opy — rule "END VOTING": [237](../src/game/global_start_menu.opy#L237).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [19](../src/game/player_start_menu.opy#L19).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/game/player_start_menu.opy#L40), [43](../src/game/player_start_menu.opy#L43), [45](../src/game/player_start_menu.opy#L45), [47](../src/game/player_start_menu.opy#L47), [49](../src/game/player_start_menu.opy#L49), [51](../src/game/player_start_menu.opy#L51).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [61](../src/game/player_start_menu.opy#L61), [81](../src/game/player_start_menu.opy#L81).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [100](../src/game/player_start_menu.opy#L100), [106](../src/game/player_start_menu.opy#L106), [107](../src/game/player_start_menu.opy#L107), [108](../src/game/player_start_menu.opy#L108), [115](../src/game/player_start_menu.opy#L115), [116](../src/game/player_start_menu.opy#L116), [118](../src/game/player_start_menu.opy#L118).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [224](../src/game/player_start_menu.opy#L224).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [63](../src/game/players_game_in_progress.opy#L63).

## isPregameVoting

Объявление: [variables.opy:309](../src/core/variables.opy#L309).

- subroutines.opy — def setPrematchTimer(): [486](../src/core/subroutines.opy#L486), [492](../src/core/subroutines.opy#L492), [494](../src/core/subroutines.opy#L494).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [20](../src/game/player_start_menu.opy#L20).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [47](../src/game/player_start_menu.opy#L47), [49](../src/game/player_start_menu.opy#L49).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [120](../src/game/player_start_menu.opy#L120).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [136](../src/game/player_start_menu.opy#L136).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [156](../src/game/player_start_menu.opy#L156).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [176](../src/game/player_start_menu.opy#L176).
- player_start_menu.opy — rule "UPDATE PREGAME VOTING STATUS" (event Team 1): [208](../src/game/player_start_menu.opy#L208), [215](../src/game/player_start_menu.opy#L215).

## rescueLeader

Объявление: [variables.opy:312](../src/core/variables.opy#L312).

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [38](../src/objective_types/objective_type_survivor_rescue.opy#L38), [53](../src/objective_types/objective_type_survivor_rescue.opy#L53), [61](../src/objective_types/objective_type_survivor_rescue.opy#L61), [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [91](../src/objective_types/objective_type_survivor_rescue.opy#L91), [103](../src/objective_types/objective_type_survivor_rescue.opy#L103).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [117](../src/objective_types/objective_type_survivor_rescue.opy#L117), [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [120](../src/objective_types/objective_type_survivor_rescue.opy#L120), [122](../src/objective_types/objective_type_survivor_rescue.opy#L122).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [143](../src/objective_types/objective_type_survivor_rescue.opy#L143), [144](../src/objective_types/objective_type_survivor_rescue.opy#L144), [146](../src/objective_types/objective_type_survivor_rescue.opy#L146).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [151](../src/objective_types/objective_type_survivor_rescue.opy#L151), [154](../src/objective_types/objective_type_survivor_rescue.opy#L154), [155](../src/objective_types/objective_type_survivor_rescue.opy#L155).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [19](../src/game/bots_game_in_progress.opy#L19), [22](../src/game/bots_game_in_progress.opy#L22).

## biomorphingResourceAmount

Объявление: [variables.opy:315](../src/core/variables.opy#L315).

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [303](../src/core/subroutines.opy#L303), [306](../src/core/subroutines.opy#L306), [315](../src/core/subroutines.opy#L315), [318](../src/core/subroutines.opy#L318).
- subroutines.opy — def objectivesManagement(): [612](../src/core/subroutines.opy#L612).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [48](../src/objective_types/objective_type_biomorphing.opy#L48), [75](../src/objective_types/objective_type_biomorphing.opy#L75).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [83](../src/objective_types/objective_type_biomorphing.opy#L83), [92](../src/objective_types/objective_type_biomorphing.opy#L92), [99](../src/objective_types/objective_type_biomorphing.opy#L99).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [119](../src/objective_types/objective_type_biomorphing.opy#L119), [140](../src/objective_types/objective_type_biomorphing.opy#L140).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [151](../src/objective_types/objective_type_biomorphing.opy#L151), [170](../src/objective_types/objective_type_biomorphing.opy#L170), [180](../src/objective_types/objective_type_biomorphing.opy#L180).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [190](../src/objective_types/objective_type_biomorphing.opy#L190), [195](../src/objective_types/objective_type_biomorphing.opy#L195).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/game/players_game_in_progress.opy#L24).

## explosionInnerColor

Объявление: [variables.opy:318](../src/core/variables.opy#L318).

- subroutines.opy — macro botEntityManagementMacro(): [135](../src/core/subroutines.opy#L135).
- subroutines.opy — def explosionSequence(): [788](../src/core/subroutines.opy#L788).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [32](../src/abilities/enhancements.opy#L32).

## explosionOuterColor

Объявление: [variables.opy:320](../src/core/variables.opy#L320).

- subroutines.opy — macro botEntityManagementMacro(): [136](../src/core/subroutines.opy#L136).
- subroutines.opy — def explosionSequence(): [787](../src/core/subroutines.opy#L787).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [33](../src/abilities/enhancements.opy#L33).

## explosionScale

Объявление: [variables.opy:322](../src/core/variables.opy#L322).

- subroutines.opy — def explosionSequence(): [775](../src/core/subroutines.opy#L775), [787](../src/core/subroutines.opy#L787), [788](../src/core/subroutines.opy#L788), [790](../src/core/subroutines.opy#L790), [792](../src/core/subroutines.opy#L792).
- zombie_types.opy — def explosionWarning(): [1475](../src/game/zombie_types.opy#L1475).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [31](../src/abilities/enhancements.opy#L31).

## aiThrottleSpeedSlot

Объявление: [variables.opy:325](../src/core/variables.opy#L325).

Алиасы: `botThrottleSpeed`, `rescueThrottleSpeed`.

- subroutines.opy — macro botStatManagementMacro(): [40](../src/core/subroutines.opy#L40).
- subroutines.opy — def restoreDefaultFacingMovement(): [700](../src/core/subroutines.opy#L700), [702](../src/core/subroutines.opy#L702).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [57](../src/objective_types/objective_type_bosses.opy#L57).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [88](../src/objective_types/objective_type_survivor_rescue.opy#L88).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [118](../src/objective_types/objective_type_survivor_rescue.opy#L118).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [165](../src/objective_types/objective_type_survivor_rescue.opy#L165).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/game/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [272](../src/game/bots_game_in_progress.opy#L272).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [289](../src/game/bots_game_in_progress.opy#L289), [293](../src/game/bots_game_in_progress.opy#L293).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [313](../src/game/bots_game_in_progress.opy#L313).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [334](../src/game/bots_game_in_progress.opy#L334).
- bots_game_in_progress.opy — def enterExitTeleport(): [434](../src/game/bots_game_in_progress.opy#L434), [436](../src/game/bots_game_in_progress.opy#L436).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [552](../src/game/zombie_types.opy#L552).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [771](../src/game/zombie_types.opy#L771), [779](../src/game/zombie_types.opy#L779).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [880](../src/game/zombie_types.opy#L880).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1080](../src/game/zombie_types.opy#L1080).

## recoveryTimeSlot

Объявление: [variables.opy:331](../src/core/variables.opy#L331).

Алиасы: `reviveTimeRemaining`, `botRespawnDelay`.

- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [150](../src/objective_types/objective_type_bosses.opy#L150), [161](../src/objective_types/objective_type_bosses.opy#L161).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [10](../src/objective_types/objective_type_kill_zone.opy#L10), [15](../src/objective_types/objective_type_kill_zone.opy#L15).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [71](../src/objective_types/objective_type_zombie_egg.opy#L71).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [62](../src/objective_types/objective_type_satellite_uplink.opy#L62), [65](../src/objective_types/objective_type_satellite_uplink.opy#L65).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [58](../src/game/players_game_in_progress.opy#L58), [73](../src/game/players_game_in_progress.opy#L73).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/game/players_game_in_progress.opy#L117), [121](../src/game/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/game/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/game/players_game_in_progress.opy#L154), [159](../src/game/players_game_in_progress.opy#L159), [175](../src/game/players_game_in_progress.opy#L175), [177](../src/game/players_game_in_progress.opy#L177), [184](../src/game/players_game_in_progress.opy#L184), [203](../src/game/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/game/players_game_in_progress.opy#L370).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [66](../src/game/bots_game_in_progress.opy#L66).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [149](../src/game/bots_game_in_progress.opy#L149), [150](../src/game/bots_game_in_progress.opy#L150), [151](../src/game/bots_game_in_progress.opy#L151), [153](../src/game/bots_game_in_progress.opy#L153).
- supply_drops.opy — def airStrike(): [226](../src/items/supply_drops.opy#L226).

## isCrowdControlled

Объявление: [variables.opy:337](../src/core/variables.opy#L337).

- subroutines.opy — def restoreDefaultFacingMovement(): [698](../src/core/subroutines.opy#L698).
- subroutines.opy — def botRespawnInitialization(): [729](../src/core/subroutines.opy#L729).
- subroutines.opy — def abilityPlacement(): [760](../src/core/subroutines.opy#L760).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [98](../src/game/bots_game_in_progress.opy#L98).
- bots_game_in_progress.opy — rule "BOT STUN MANAGEMENT" (event Team 2): [209](../src/game/bots_game_in_progress.opy#L209), [213](../src/game/bots_game_in_progress.opy#L213).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [274](../src/game/bots_game_in_progress.opy#L274).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [286](../src/game/bots_game_in_progress.opy#L286).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [305](../src/game/bots_game_in_progress.opy#L305).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [328](../src/game/bots_game_in_progress.opy#L328).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [358](../src/game/bots_game_in_progress.opy#L358), [375](../src/game/bots_game_in_progress.opy#L375).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [408](../src/game/bots_game_in_progress.opy#L408).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [24](../src/game/zombie_types.opy#L24).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [70](../src/game/zombie_types.opy#L70).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [87](../src/game/zombie_types.opy#L87).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [105](../src/game/zombie_types.opy#L105), [114](../src/game/zombie_types.opy#L114), [125](../src/game/zombie_types.opy#L125), [127](../src/game/zombie_types.opy#L127).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/game/zombie_types.opy#L196), [201](../src/game/zombie_types.opy#L201).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [264](../src/game/zombie_types.opy#L264).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [348](../src/game/zombie_types.opy#L348), [355](../src/game/zombie_types.opy#L355).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [411](../src/game/zombie_types.opy#L411).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [451](../src/game/zombie_types.opy#L451).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [504](../src/game/zombie_types.opy#L504).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [527](../src/game/zombie_types.opy#L527), [541](../src/game/zombie_types.opy#L541), [546](../src/game/zombie_types.opy#L546).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [589](../src/game/zombie_types.opy#L589), [604](../src/game/zombie_types.opy#L604), [613](../src/game/zombie_types.opy#L613).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [643](../src/game/zombie_types.opy#L643), [667](../src/game/zombie_types.opy#L667), [668](../src/game/zombie_types.opy#L668).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [704](../src/game/zombie_types.opy#L704), [727](../src/game/zombie_types.opy#L727).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [761](../src/game/zombie_types.opy#L761), [769](../src/game/zombie_types.opy#L769), [778](../src/game/zombie_types.opy#L778), [788](../src/game/zombie_types.opy#L788).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [824](../src/game/zombie_types.opy#L824), [830](../src/game/zombie_types.opy#L830), [853](../src/game/zombie_types.opy#L853).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [906](../src/game/zombie_types.opy#L906).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [929](../src/game/zombie_types.opy#L929), [950](../src/game/zombie_types.opy#L950).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1006](../src/game/zombie_types.opy#L1006), [1013](../src/game/zombie_types.opy#L1013), [1024](../src/game/zombie_types.opy#L1024), [1027](../src/game/zombie_types.opy#L1027), [1050](../src/game/zombie_types.opy#L1050).
- zombie_types.opy — rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)" (event Team 2): [1089](../src/game/zombie_types.opy#L1089).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1131](../src/game/zombie_types.opy#L1131).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1170](../src/game/zombie_types.opy#L1170).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1232](../src/game/zombie_types.opy#L1232).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1254](../src/game/zombie_types.opy#L1254), [1269](../src/game/zombie_types.opy#L1269).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1282](../src/game/zombie_types.opy#L1282).
- zombie_types.opy — rule "PROTECTOR (KIRIKO) USES CLEANSE" (event Team 2): [1352](../src/game/zombie_types.opy#L1352).
- zombie_types.opy — def abilityThrowdown(): [1454](../src/game/zombie_types.opy#L1454).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [450](../src/abilities/enhancements.opy#L450).

## actorCountdownSlot

Объявление: [variables.opy:339](../src/core/variables.opy#L339).

Алиасы: `powerUpNoCooldownsTimeRemaining`, `botChargerWindupProgress`.

- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [545](../src/game/zombie_types.opy#L545).
- supply_drops.opy — def noCooldowns(): [172](../src/items/supply_drops.opy#L172), [175](../src/items/supply_drops.opy#L175).

## controlStateSlot

Объявление: [variables.opy:345](../src/core/variables.opy#L345).

Алиасы: `isCrowdControlCooldownActive`, `botReturnTarget`.

- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203), [206](../src/objective_types/objective_type_bosses.opy#L206), [210](../src/objective_types/objective_type_bosses.opy#L210).
- hero_tuning.opy — rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE" (event Team 1): [7](../src/abilities/hero_tuning.opy#L7), [11](../src/abilities/hero_tuning.opy#L11).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [300](../src/game/zombie_types.opy#L300), [302](../src/game/zombie_types.opy#L302).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [933](../src/game/zombie_types.opy#L933), [939](../src/game/zombie_types.opy#L939).

## actorMotionSlot1

Объявление: [variables.opy:351](../src/core/variables.opy#L351).

Алиасы: `botGasProjectilePosition`, `botTentaclePosition`, `botBlasterCharge`, `botDaytakerCharge`, `botSmolderAnger`, `botEnsnarerMeleeAngle`, `rescueExtractionPosition`.

- subroutines.opy — macro botStatManagementMacro(): [63](../src/core/subroutines.opy#L63).
- subroutines.opy — macro botEntityManagementMacro(): [142](../src/core/subroutines.opy#L142), [145](../src/core/subroutines.opy#L145), [163](../src/core/subroutines.opy#L163), [166](../src/core/subroutines.opy#L166), [169](../src/core/subroutines.opy#L169), [197](../src/core/subroutines.opy#L197), [204](../src/core/subroutines.opy#L204), [208](../src/core/subroutines.opy#L208).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [185](../src/objective_types/objective_type_survivor_rescue.opy#L185), [187](../src/objective_types/objective_type_survivor_rescue.opy#L187), [189](../src/objective_types/objective_type_survivor_rescue.opy#L189), [191](../src/objective_types/objective_type_survivor_rescue.opy#L191).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [366](../src/game/bots_game_in_progress.opy#L366), [367](../src/game/bots_game_in_progress.opy#L367), [368](../src/game/bots_game_in_progress.opy#L368), [380](../src/game/bots_game_in_progress.opy#L380).
- zombie_types.opy — macro smolderEnragedMacro(): [12](../src/game/zombie_types.opy#L12).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [202](../src/game/zombie_types.opy#L202), [205](../src/game/zombie_types.opy#L205), [213](../src/game/zombie_types.opy#L213), [215](../src/game/zombie_types.opy#L215), [219](../src/game/zombie_types.opy#L219), [220](../src/game/zombie_types.opy#L220).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [599](../src/game/zombie_types.opy#L599), [602](../src/game/zombie_types.opy#L602), [604](../src/game/zombie_types.opy#L604), [605](../src/game/zombie_types.opy#L605), [606](../src/game/zombie_types.opy#L606), [610](../src/game/zombie_types.opy#L610), [612](../src/game/zombie_types.opy#L612), [621](../src/game/zombie_types.opy#L621), [624](../src/game/zombie_types.opy#L624).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [831](../src/game/zombie_types.opy#L831), [834](../src/game/zombie_types.opy#L834), [835](../src/game/zombie_types.opy#L835), [836](../src/game/zombie_types.opy#L836), [839](../src/game/zombie_types.opy#L839), [845](../src/game/zombie_types.opy#L845), [847](../src/game/zombie_types.opy#L847).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1014](../src/game/zombie_types.opy#L1014), [1016](../src/game/zombie_types.opy#L1016), [1024](../src/game/zombie_types.opy#L1024), [1026](../src/game/zombie_types.opy#L1026), [1029](../src/game/zombie_types.opy#L1029), [1030](../src/game/zombie_types.opy#L1030), [1036](../src/game/zombie_types.opy#L1036), [1042](../src/game/zombie_types.opy#L1042), [1043](../src/game/zombie_types.opy#L1043).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1214](../src/game/zombie_types.opy#L1214), [1215](../src/game/zombie_types.opy#L1215), [1218](../src/game/zombie_types.opy#L1218).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1235](../src/game/zombie_types.opy#L1235).
- zombie_types.opy — def spawnGasCloud(): [1498](../src/game/zombie_types.opy#L1498), [1500](../src/game/zombie_types.opy#L1500), [1501](../src/game/zombie_types.opy#L1501).

## actorMotionSlot2

Объявление: [variables.opy:367](../src/core/variables.opy#L367).

Алиасы: `botGasCloudTimeRemaining`, `extractionFlightPosition`.

- subroutines.opy — macro botEntityManagementMacro(): [159](../src/core/subroutines.opy#L159).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [56](../src/objective_types/objective_type_extraction_point.opy#L56), [57](../src/objective_types/objective_type_extraction_point.opy#L57), [58](../src/objective_types/objective_type_extraction_point.opy#L58), [60](../src/objective_types/objective_type_extraction_point.opy#L60), [62](../src/objective_types/objective_type_extraction_point.opy#L62), [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [170](../src/game/zombie_types.opy#L170), [172](../src/game/zombie_types.opy#L172), [173](../src/game/zombie_types.opy#L173), [188](../src/game/zombie_types.opy#L188), [189](../src/game/zombie_types.opy#L189).

## actorAbilitySlot2

Объявление: [variables.opy:373](../src/core/variables.opy#L373).

Алиасы: `botAuxiliaryState`, `rescueFollowMessage`, `botIsReigniteActive`, `botIsEnsnarerMeleeActive`.

- subroutines.opy — def botRespawnInitialization(): [731](../src/core/subroutines.opy#L731).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [155](../src/objective_types/objective_type_survivor_rescue.opy#L155), [158](../src/objective_types/objective_type_survivor_rescue.opy#L158).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [364](../src/game/bots_game_in_progress.opy#L364), [382](../src/game/bots_game_in_progress.opy#L382).
- zombie_types.opy — rule "REIGNITED USES ULTIMATE NEAR PLAYER" (event Team 2): [396](../src/game/zombie_types.opy#L396), [398](../src/game/zombie_types.opy#L398).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [409](../src/game/zombie_types.opy#L409), [421](../src/game/zombie_types.opy#L421).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [960](../src/game/zombie_types.opy#L960).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1157](../src/game/zombie_types.opy#L1157).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1192](../src/game/zombie_types.opy#L1192).

## initialMaxHealth

Объявление: [variables.opy:383](../src/core/variables.opy#L383).

- subroutines.opy — def botRespawnInitialization(): [713](../src/core/subroutines.opy#L713).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [39](../src/game/players_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [79](../src/game/bots_game_in_progress.opy#L79), [81](../src/game/bots_game_in_progress.opy#L81).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/game/bots_game_in_progress.opy#L398).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [21](../src/abilities/enhancements.opy#L21).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [466](../src/abilities/enhancements.opy#L466).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [487](../src/abilities/enhancements.opy#L487).

## isAttached

Объявление: [variables.opy:385](../src/core/variables.opy#L385).

Алиасы: `botIsAttached`, `enhancementIsHitchhiking`.

- subroutines.opy — def restoreDefaultFacingMovement(): [698](../src/core/subroutines.opy#L698).
- subroutines.opy — def botRespawnInitialization(): [725](../src/core/subroutines.opy#L725).
- subroutines.opy — def illariUlt(): [800](../src/core/subroutines.opy#L800).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [37](../src/objective_types/objective_type_bosses.opy#L37), [38](../src/objective_types/objective_type_bosses.opy#L38).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [43](../src/game/players_game_in_progress.opy#L43).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [260](../src/game/players_game_in_progress.opy#L260).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [97](../src/game/bots_game_in_progress.opy#L97).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [186](../src/game/bots_game_in_progress.opy#L186).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [304](../src/game/bots_game_in_progress.opy#L304).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [327](../src/game/bots_game_in_progress.opy#L327).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [409](../src/game/bots_game_in_progress.opy#L409).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/game/zombie_types.opy#L196).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [437](../src/game/zombie_types.opy#L437), [440](../src/game/zombie_types.opy#L440).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [449](../src/game/zombie_types.opy#L449), [454](../src/game/zombie_types.opy#L454).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [463](../src/game/zombie_types.opy#L463), [472](../src/game/zombie_types.opy#L472).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [479](../src/game/zombie_types.opy#L479), [485](../src/game/zombie_types.opy#L485).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [494](../src/game/zombie_types.opy#L494).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [541](../src/game/zombie_types.opy#L541).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1021](../src/game/zombie_types.opy#L1021), [1032](../src/game/zombie_types.opy#L1032), [1039](../src/game/zombie_types.opy#L1039), [1048](../src/game/zombie_types.opy#L1048), [1055](../src/game/zombie_types.opy#L1055).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/abilities/enhancements.opy#L117), [119](../src/abilities/enhancements.opy#L119), [121](../src/abilities/enhancements.opy#L121).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/abilities/enhancements.opy#L444), [447](../src/abilities/enhancements.opy#L447), [448](../src/abilities/enhancements.opy#L448), [463](../src/abilities/enhancements.opy#L463), [476](../src/abilities/enhancements.opy#L476).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [497](../src/abilities/enhancements.opy#L497).

## candidateTargetList

Объявление: [variables.opy:391](../src/core/variables.opy#L391).

Алиасы: `botPotentialTargetList`, `rescuePotentialLeaderList`, `enhancementBarrierTargetList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [295](../src/core/subroutines.opy#L295).
- subroutines.opy — def selectTarget(): [678](../src/core/subroutines.opy#L678).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [70](../src/objective_types/objective_type_bosses.opy#L70).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [104](../src/objective_types/objective_type_survivor_rescue.opy#L104).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [152](../src/objective_types/objective_type_survivor_rescue.opy#L152), [154](../src/objective_types/objective_type_survivor_rescue.opy#L154).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [136](../src/game/players_game_in_progress.opy#L136).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [140](../src/game/bots_game_in_progress.opy#L140).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [234](../src/abilities/enhancements.opy#L234), [240](../src/abilities/enhancements.opy#L240), [243](../src/abilities/enhancements.opy#L243).

## sizeScale

Объявление: [variables.opy:399](../src/core/variables.opy#L399).

- subroutines.opy — macro minibossMutationMacro(): [23](../src/core/subroutines.opy#L23).
- subroutines.opy — macro botStatManagementMacro(): [62](../src/core/subroutines.opy#L62), [64](../src/core/subroutines.opy#L64), [68](../src/core/subroutines.opy#L68).
- subroutines.opy — macro mutationsMacro(): [92](../src/core/subroutines.opy#L92), [93](../src/core/subroutines.opy#L93), [98](../src/core/subroutines.opy#L98), [99](../src/core/subroutines.opy#L99).
- subroutines.opy — macro botEntityManagementMacro(): [142](../src/core/subroutines.opy#L142), [145](../src/core/subroutines.opy#L145), [159](../src/core/subroutines.opy#L159), [163](../src/core/subroutines.opy#L163), [174](../src/core/subroutines.opy#L174), [179](../src/core/subroutines.opy#L179), [190](../src/core/subroutines.opy#L190), [193](../src/core/subroutines.opy#L193), [197](../src/core/subroutines.opy#L197), [204](../src/core/subroutines.opy#L204), [208](../src/core/subroutines.opy#L208).
- subroutines.opy — def restoreDefaultFacingMovement(): [700](../src/core/subroutines.opy#L700).
- subroutines.opy — def botRespawnInitialization(): [716](../src/core/subroutines.opy#L716), [719](../src/core/subroutines.opy#L719), [748](../src/core/subroutines.opy#L748).
- subroutines.opy — def explosionSequence(): [780](../src/core/subroutines.opy#L780).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [61](../src/objective_types/objective_type_bosses.opy#L61), [62](../src/objective_types/objective_type_bosses.opy#L62), [64](../src/objective_types/objective_type_bosses.opy#L64).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [38](../src/objective_types/objective_type_zombie_egg.opy#L38), [39](../src/objective_types/objective_type_zombie_egg.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [62](../src/game/players_game_in_progress.opy#L62).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [102](../src/game/bots_game_in_progress.opy#L102).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [337](../src/game/bots_game_in_progress.opy#L337).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [360](../src/game/bots_game_in_progress.opy#L360).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [51](../src/game/zombie_types.opy#L51).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [73](../src/game/zombie_types.opy#L73).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [181](../src/game/zombie_types.opy#L181), [203](../src/game/zombie_types.opy#L203), [205](../src/game/zombie_types.opy#L205).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [239](../src/game/zombie_types.opy#L239), [240](../src/game/zombie_types.opy#L240).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [256](../src/game/zombie_types.opy#L256), [266](../src/game/zombie_types.opy#L266), [267](../src/game/zombie_types.opy#L267), [268](../src/game/zombie_types.opy#L268), [269](../src/game/zombie_types.opy#L269).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [276](../src/game/zombie_types.opy#L276).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [299](../src/game/zombie_types.opy#L299).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [317](../src/game/zombie_types.opy#L317).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [336](../src/game/zombie_types.opy#L336), [357](../src/game/zombie_types.opy#L357).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [383](../src/game/zombie_types.opy#L383).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [442](../src/game/zombie_types.opy#L442).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [466](../src/game/zombie_types.opy#L466), [471](../src/game/zombie_types.opy#L471).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [592](../src/game/zombie_types.opy#L592), [599](../src/game/zombie_types.opy#L599), [600](../src/game/zombie_types.opy#L600), [612](../src/game/zombie_types.opy#L612), [618](../src/game/zombie_types.opy#L618), [621](../src/game/zombie_types.opy#L621).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [657](../src/game/zombie_types.opy#L657), [662](../src/game/zombie_types.opy#L662).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [708](../src/game/zombie_types.opy#L708), [722](../src/game/zombie_types.opy#L722), [723](../src/game/zombie_types.opy#L723).
- zombie_types.opy — rule "STRIKER NORMAL PILE DRIVER" (event Team 2): [753](../src/game/zombie_types.opy#L753).
- zombie_types.opy — rule "STALKER KNOCKBACK BLAST (BOSS)" (event Team 2): [814](../src/game/zombie_types.opy#L814).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [911](../src/game/zombie_types.opy#L911), [915](../src/game/zombie_types.opy#L915).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [930](../src/game/zombie_types.opy#L930), [947](../src/game/zombie_types.opy#L947), [950](../src/game/zombie_types.opy#L950).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [992](../src/game/zombie_types.opy#L992), [993](../src/game/zombie_types.opy#L993).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1008](../src/game/zombie_types.opy#L1008), [1018](../src/game/zombie_types.opy#L1018), [1022](../src/game/zombie_types.opy#L1022), [1062](../src/game/zombie_types.opy#L1062), [1064](../src/game/zombie_types.opy#L1064), [1066](../src/game/zombie_types.opy#L1066).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1106](../src/game/zombie_types.opy#L1106), [1107](../src/game/zombie_types.opy#L1107).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1118](../src/game/zombie_types.opy#L1118).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1135](../src/game/zombie_types.opy#L1135), [1142](../src/game/zombie_types.opy#L1142).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1155](../src/game/zombie_types.opy#L1155).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1189](../src/game/zombie_types.opy#L1189).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1205](../src/game/zombie_types.opy#L1205), [1220](../src/game/zombie_types.opy#L1220).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1257](../src/game/zombie_types.opy#L1257).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1288](../src/game/zombie_types.opy#L1288), [1290](../src/game/zombie_types.opy#L1290), [1291](../src/game/zombie_types.opy#L1291), [1296](../src/game/zombie_types.opy#L1296).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1389](../src/game/zombie_types.opy#L1389).
- zombie_types.opy — def abilityThrowdown(): [1457](../src/game/zombie_types.opy#L1457).
- zombie_types.opy — def entityFloat(): [1465](../src/game/zombie_types.opy#L1465).
- zombie_types.opy — def explosionWarning(): [1474](../src/game/zombie_types.opy#L1474), [1475](../src/game/zombie_types.opy#L1475).
- zombie_types.opy — def smolderBoost(): [1487](../src/game/zombie_types.opy#L1487), [1491](../src/game/zombie_types.opy#L1491), [1492](../src/game/zombie_types.opy#L1492).
- zombie_types.opy — def spawnGasCloud(): [1500](../src/game/zombie_types.opy#L1500).
- supply_drops.opy — def stun(): [437](../src/items/supply_drops.opy#L437).
- supply_drops.opy — def powerUpUsage(): [529](../src/items/supply_drops.opy#L529).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/abilities/enhancements.opy#L117), [149](../src/abilities/enhancements.opy#L149).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [278](../src/abilities/enhancements.opy#L278).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [423](../src/abilities/enhancements.opy#L423).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/abilities/enhancements.opy#L444), [448](../src/abilities/enhancements.opy#L448), [450](../src/abilities/enhancements.opy#L450), [453](../src/abilities/enhancements.opy#L453), [470](../src/abilities/enhancements.opy#L470).

## actorAbilitySlot1

Объявление: [variables.opy:401](../src/core/variables.opy#L401).

Алиасы: `botAbilityState`, `rescueIsExtracting`, `botIsBomberPrimed`, `botRusherHealthPoolId`, `botGasAimPosition`, `botIsReigniteAttackUsed`, `botRiderGrapplePosition`, `botChargerDestination`, `botTentacleTargetPosition`, `botIsStrikerStrikeActive`, `botIsDownfallenGrabbing`, `botIsEnsnarerBlocking`, `botSmolderState`.

- subroutines.opy — macro botEntityManagementMacro(): [163](../src/core/subroutines.opy#L163), [166](../src/core/subroutines.opy#L166), [169](../src/core/subroutines.opy#L169), [179](../src/core/subroutines.opy#L179), [208](../src/core/subroutines.opy#L208).
- subroutines.opy — def botRespawnInitialization(): [730](../src/core/subroutines.opy#L730).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [37](../src/objective_types/objective_type_survivor_rescue.opy#L37), [46](../src/objective_types/objective_type_survivor_rescue.opy#L46), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [80](../src/objective_types/objective_type_survivor_rescue.opy#L80).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [183](../src/objective_types/objective_type_survivor_rescue.opy#L183).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [120](../src/game/bots_game_in_progress.opy#L120), [123](../src/game/bots_game_in_progress.opy#L123).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [363](../src/game/bots_game_in_progress.opy#L363).
- zombie_types.opy — macro smolderEnragedMacro(): [11](../src/game/zombie_types.opy#L11).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [76](../src/game/zombie_types.opy#L76).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [120](../src/game/zombie_types.opy#L120), [140](../src/game/zombie_types.opy#L140).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [203](../src/game/zombie_types.opy#L203), [205](../src/game/zombie_types.opy#L205), [213](../src/game/zombie_types.opy#L213), [215](../src/game/zombie_types.opy#L215).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [377](../src/game/zombie_types.opy#L377), [379](../src/game/zombie_types.opy#L379), [386](../src/game/zombie_types.opy#L386).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [502](../src/game/zombie_types.opy#L502), [505](../src/game/zombie_types.opy#L505), [511](../src/game/zombie_types.opy#L511).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [552](../src/game/zombie_types.opy#L552).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [588](../src/game/zombie_types.opy#L588), [600](../src/game/zombie_types.opy#L600), [602](../src/game/zombie_types.opy#L602), [604](../src/game/zombie_types.opy#L604), [607](../src/game/zombie_types.opy#L607), [623](../src/game/zombie_types.opy#L623).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [641](../src/game/zombie_types.opy#L641).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [714](../src/game/zombie_types.opy#L714), [729](../src/game/zombie_types.opy#L729).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [907](../src/game/zombie_types.opy#L907).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [932](../src/game/zombie_types.opy#L932), [938](../src/game/zombie_types.opy#L938), [965](../src/game/zombie_types.opy#L965).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1162](../src/game/zombie_types.opy#L1162), [1174](../src/game/zombie_types.opy#L1174).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1193](../src/game/zombie_types.opy#L1193).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1204](../src/game/zombie_types.opy#L1204), [1212](../src/game/zombie_types.opy#L1212), [1215](../src/game/zombie_types.opy#L1215), [1216](../src/game/zombie_types.opy#L1216).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1231](../src/game/zombie_types.opy#L1231), [1234](../src/game/zombie_types.opy#L1234).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1251](../src/game/zombie_types.opy#L1251), [1266](../src/game/zombie_types.opy#L1266), [1273](../src/game/zombie_types.opy#L1273).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1281](../src/game/zombie_types.opy#L1281).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1303](../src/game/zombie_types.opy#L1303).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT" (event Team 2): [1340](../src/game/zombie_types.opy#L1340).
- zombie_types.opy — def explosionWarning(): [1479](../src/game/zombie_types.opy#L1479).

## objectiveTypeSnapshot

Объявление: [variables.opy:429](../src/core/variables.opy#L429).

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/game/players_game_in_progress.opy#L8), [9](../src/game/players_game_in_progress.opy#L9), [22](../src/game/players_game_in_progress.opy#L22).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/game/players_game_in_progress.opy#L321).

## visualEntityIdList

Объявление: [variables.opy:431](../src/core/variables.opy#L431).

Алиасы: `botVisualEntityIdList`, `playerObjectiveIconIdList`.

- subroutines.opy — macro minibossMutationMacro(): [28](../src/core/subroutines.opy#L28).
- subroutines.opy — macro botEntityManagementMacro(): [132](../src/core/subroutines.opy#L132), [133](../src/core/subroutines.opy#L133), [137](../src/core/subroutines.opy#L137), [143](../src/core/subroutines.opy#L143), [146](../src/core/subroutines.opy#L146), [153](../src/core/subroutines.opy#L153), [156](../src/core/subroutines.opy#L156), [160](../src/core/subroutines.opy#L160), [164](../src/core/subroutines.opy#L164), [167](../src/core/subroutines.opy#L167), [170](../src/core/subroutines.opy#L170), [175](../src/core/subroutines.opy#L175), [180](../src/core/subroutines.opy#L180), [191](../src/core/subroutines.opy#L191), [194](../src/core/subroutines.opy#L194), [198](../src/core/subroutines.opy#L198), [201](../src/core/subroutines.opy#L201), [205](../src/core/subroutines.opy#L205), [209](../src/core/subroutines.opy#L209), [214](../src/core/subroutines.opy#L214), [217](../src/core/subroutines.opy#L217), [221](../src/core/subroutines.opy#L221).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/game/players_game_in_progress.opy#L12), [13](../src/game/players_game_in_progress.opy#L13), [15](../src/game/players_game_in_progress.opy#L15), [26](../src/game/players_game_in_progress.opy#L26).

## visualCleanupIndex

Объявление: [variables.opy:437](../src/core/variables.opy#L437).

- subroutines.opy — macro botEntityManagementMacro(): [132](../src/core/subroutines.opy#L132), [133](../src/core/subroutines.opy#L133).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/game/players_game_in_progress.opy#L12), [13](../src/game/players_game_in_progress.opy#L13), [18](../src/game/players_game_in_progress.opy#L18), [19](../src/game/players_game_in_progress.opy#L19).

## actorLoopSlot

Объявление: [variables.opy:439](../src/core/variables.opy#L439).

Алиасы: `botEnsnarerUltimateIndex`, `powerUpBouncePadTimeRemaining`.

- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [369](../src/game/bots_game_in_progress.opy#L369).
- supply_drops.opy — def bouncePad(): [377](../src/items/supply_drops.opy#L377), [383](../src/items/supply_drops.opy#L383), [384](../src/items/supply_drops.opy#L384).

## abilityTargetList

Объявление: [variables.opy:445](../src/core/variables.opy#L445).

Алиасы: `botSpecialTargetList`, `explosionTargetList`.

- subroutines.opy — def explosionSequence(): [775](../src/core/subroutines.opy#L775), [777](../src/core/subroutines.opy#L777), [780](../src/core/subroutines.opy#L780), [782](../src/core/subroutines.opy#L782), [784](../src/core/subroutines.opy#L784).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [49](../src/game/zombie_types.opy#L49), [50](../src/game/zombie_types.opy#L50).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [235](../src/game/zombie_types.opy#L235), [241](../src/game/zombie_types.opy#L241), [242](../src/game/zombie_types.opy#L242), [243](../src/game/zombie_types.opy#L243).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [679](../src/game/zombie_types.opy#L679), [680](../src/game/zombie_types.opy#L680).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1164](../src/game/zombie_types.opy#L1164), [1165](../src/game/zombie_types.opy#L1165).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1290](../src/game/zombie_types.opy#L1290), [1291](../src/game/zombie_types.opy#L1291), [1294](../src/game/zombie_types.opy#L1294), [1295](../src/game/zombie_types.opy#L1295).
- zombie_types.opy — def entityFloat(): [1465](../src/game/zombie_types.opy#L1465).

## movementSpeedScale

Объявление: [variables.opy:451](../src/core/variables.opy#L451).

- subroutines.opy — macro botStatManagementMacro(): [46](../src/core/subroutines.opy#L46), [47](../src/core/subroutines.opy#L47).
- subroutines.opy — macro mutationsMacro(): [85](../src/core/subroutines.opy#L85), [86](../src/core/subroutines.opy#L86), [112](../src/core/subroutines.opy#L112), [113](../src/core/subroutines.opy#L113).
- subroutines.opy — macro botEntityManagementMacro(): [185](../src/core/subroutines.opy#L185).
- subroutines.opy — def illariUlt(): [806](../src/core/subroutines.opy#L806), [807](../src/core/subroutines.opy#L807), [816](../src/core/subroutines.opy#L816), [817](../src/core/subroutines.opy#L817).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [39](../src/objective_types/objective_type_survivor_rescue.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [41](../src/game/players_game_in_progress.opy#L41), [42](../src/game/players_game_in_progress.opy#L42).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/game/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [289](../src/game/bots_game_in_progress.opy#L289).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [313](../src/game/bots_game_in_progress.opy#L313).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [334](../src/game/bots_game_in_progress.opy#L334).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [361](../src/game/bots_game_in_progress.opy#L361).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [780](../src/game/zombie_types.opy#L780), [781](../src/game/zombie_types.opy#L781), [786](../src/game/zombie_types.opy#L786), [787](../src/game/zombie_types.opy#L787).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1210](../src/game/zombie_types.opy#L1210), [1211](../src/game/zombie_types.opy#L1211).
- zombie_types.opy — def smolderBoost(): [1493](../src/game/zombie_types.opy#L1493), [1494](../src/game/zombie_types.opy#L1494).
- supply_drops.opy — def cloakingDevice(): [304](../src/items/supply_drops.opy#L304), [305](../src/items/supply_drops.opy#L305), [329](../src/items/supply_drops.opy#L329), [330](../src/items/supply_drops.opy#L330).
- supply_drops.opy — def superNano(): [337](../src/items/supply_drops.opy#L337), [338](../src/items/supply_drops.opy#L338), [366](../src/items/supply_drops.opy#L366), [367](../src/items/supply_drops.opy#L367).

## damageOverTimeRemaining

Объявление: [variables.opy:453](../src/core/variables.opy#L453).

- subroutines.opy — def explosionSequence(): [785](../src/core/subroutines.opy#L785), [786](../src/core/subroutines.opy#L786).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [74](../src/game/bots_game_in_progress.opy#L74).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [157](../src/game/bots_game_in_progress.opy#L157).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [396](../src/game/bots_game_in_progress.opy#L396), [397](../src/game/bots_game_in_progress.opy#L397).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [154](../src/game/zombie_types.opy#L154), [155](../src/game/zombie_types.opy#L155).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [182](../src/game/zombie_types.opy#L182), [183](../src/game/zombie_types.opy#L183).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [243](../src/game/zombie_types.opy#L243), [244](../src/game/zombie_types.opy#L244).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [892](../src/game/zombie_types.opy#L892), [893](../src/game/zombie_types.opy#L893), [897](../src/game/zombie_types.opy#L897), [898](../src/game/zombie_types.opy#L898).

## actorTeamSlot0

Объявление: [variables.opy:455](../src/core/variables.opy#L455).

Алиасы: `botTeleportCenter`, `powerUpForceFieldTimeRemaining`.

- objective_types/objective_type_bosses.opy — def bossReturn(): [206](../src/objective_types/objective_type_bosses.opy#L206).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [70](../src/objective_types/objective_type_zombie_egg.opy#L70).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [13](../src/game/bots_game_in_progress.opy#L13), [16](../src/game/bots_game_in_progress.opy#L16), [20](../src/game/bots_game_in_progress.opy#L20), [22](../src/game/bots_game_in_progress.opy#L22), [28](../src/game/bots_game_in_progress.opy#L28), [36](../src/game/bots_game_in_progress.opy#L36), [39](../src/game/bots_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [197](../src/game/bots_game_in_progress.opy#L197).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [228](../src/game/bots_game_in_progress.opy#L228).
- bots_game_in_progress.opy — def teleportBots(): [460](../src/game/bots_game_in_progress.opy#L460), [470](../src/game/bots_game_in_progress.opy#L470).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [491](../src/game/bots_game_in_progress.opy#L491), [496](../src/game/bots_game_in_progress.opy#L496), [500](../src/game/bots_game_in_progress.opy#L500), [501](../src/game/bots_game_in_progress.opy#L501).
- supply_drops.opy — def playerForceField(): [149](../src/items/supply_drops.opy#L149), [154](../src/items/supply_drops.opy#L154).

## actorTeamSlot1

Объявление: [variables.opy:461](../src/core/variables.opy#L461).

Алиасы: `botIsSelectingTarget`, `powerUpReviveTarget`.

- subroutines.opy — def selectTarget(): [658](../src/core/subroutines.opy#L658), [690](../src/core/subroutines.opy#L690).
- subroutines.opy — def botRespawnInitialization(): [733](../src/core/subroutines.opy#L733).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [187](../src/game/bots_game_in_progress.opy#L187).
- supply_drops.opy — def instantRevive(): [133](../src/items/supply_drops.opy#L133), [135](../src/items/supply_drops.opy#L135), [136](../src/items/supply_drops.opy#L136), [137](../src/items/supply_drops.opy#L137), [139](../src/items/supply_drops.opy#L139).

## actorTeamSlot2

Объявление: [variables.opy:467](../src/core/variables.opy#L467).

Алиасы: `botReturnTime`, `botReturnPosition`, `powerUpItemId`.

- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED" (event Team 2): [186](../src/objective_types/objective_type_bosses.opy#L186), [187](../src/objective_types/objective_type_bosses.opy#L187), [188](../src/objective_types/objective_type_bosses.opy#L188), [190](../src/objective_types/objective_type_bosses.opy#L190), [191](../src/objective_types/objective_type_bosses.opy#L191).
- objective_types/objective_type_bosses.opy — def bossReturn(): [200](../src/objective_types/objective_type_bosses.opy#L200), [202](../src/objective_types/objective_type_bosses.opy#L202), [209](../src/objective_types/objective_type_bosses.opy#L209).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [106](../src/items/supply_drops.opy#L106), [112](../src/items/supply_drops.opy#L112), [125](../src/items/supply_drops.opy#L125).
- supply_drops.opy — def powerUpUsage(): [462](../src/items/supply_drops.opy#L462), [535](../src/items/supply_drops.opy#L535).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [34](../src/items/power_ups.opy#L34).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)" (event Team 1): [81](../src/items/power_ups.opy#L81), [84](../src/items/power_ups.opy#L84), [87](../src/items/power_ups.opy#L87).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)" (event Team 1): [94](../src/items/power_ups.opy#L94), [98](../src/items/power_ups.opy#L98), [101](../src/items/power_ups.opy#L101).

## actorTeamSlot3

Объявление: [variables.opy:475](../src/core/variables.opy#L475).

Алиасы: `botIsTeleporting`, `powerUpTradeDataList`, `pregameVoteList`, `rescuePathList`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [82](../src/game/global_start_menu.opy#L82), [90](../src/game/global_start_menu.opy#L90), [98](../src/game/global_start_menu.opy#L98), [99](../src/game/global_start_menu.opy#L99), [102](../src/game/global_start_menu.opy#L102), [103](../src/game/global_start_menu.opy#L103), [104](../src/game/global_start_menu.opy#L104), [110](../src/game/global_start_menu.opy#L110), [119](../src/game/global_start_menu.opy#L119), [128](../src/game/global_start_menu.opy#L128), [129](../src/game/global_start_menu.opy#L129), [132](../src/game/global_start_menu.opy#L132), [133](../src/game/global_start_menu.opy#L133), [134](../src/game/global_start_menu.opy#L134), [140](../src/game/global_start_menu.opy#L140), [152](../src/game/global_start_menu.opy#L152), [164](../src/game/global_start_menu.opy#L164), [165](../src/game/global_start_menu.opy#L165), [168](../src/game/global_start_menu.opy#L168), [169](../src/game/global_start_menu.opy#L169), [170](../src/game/global_start_menu.opy#L170).
- global_start_menu.opy — rule "END VOTING": [246](../src/game/global_start_menu.opy#L246), [247](../src/game/global_start_menu.opy#L247), [248](../src/game/global_start_menu.opy#L248).
- global_start_menu.opy — def determineZombieMode(): [277](../src/game/global_start_menu.opy#L277).
- global_start_menu.opy — def determineChallenge(): [340](../src/game/global_start_menu.opy#L340), [352](../src/game/global_start_menu.opy#L352).
- global_start_menu.opy — def determineObjectiveType(): [376](../src/game/global_start_menu.opy#L376).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [18](../src/game/player_start_menu.opy#L18), [23](../src/game/player_start_menu.opy#L23), [24](../src/game/player_start_menu.opy#L24), [25](../src/game/player_start_menu.opy#L25).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [90](../src/game/player_start_menu.opy#L90).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [138](../src/game/player_start_menu.opy#L138), [139](../src/game/player_start_menu.opy#L139), [140](../src/game/player_start_menu.opy#L140), [142](../src/game/player_start_menu.opy#L142), [143](../src/game/player_start_menu.opy#L143), [144](../src/game/player_start_menu.opy#L144).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [158](../src/game/player_start_menu.opy#L158), [159](../src/game/player_start_menu.opy#L159), [160](../src/game/player_start_menu.opy#L160), [162](../src/game/player_start_menu.opy#L162), [163](../src/game/player_start_menu.opy#L163), [164](../src/game/player_start_menu.opy#L164).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [178](../src/game/player_start_menu.opy#L178), [179](../src/game/player_start_menu.opy#L179), [180](../src/game/player_start_menu.opy#L180), [182](../src/game/player_start_menu.opy#L182), [183](../src/game/player_start_menu.opy#L183), [184](../src/game/player_start_menu.opy#L184).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [10](../src/objective_types/objective_type_bosses.opy#L10), [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [35](../src/objective_types/objective_type_survivor_rescue.opy#L35), [60](../src/objective_types/objective_type_survivor_rescue.opy#L60), [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [120](../src/objective_types/objective_type_survivor_rescue.opy#L120), [122](../src/objective_types/objective_type_survivor_rescue.opy#L122).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [130](../src/objective_types/objective_type_survivor_rescue.opy#L130), [134](../src/objective_types/objective_type_survivor_rescue.opy#L134), [135](../src/objective_types/objective_type_survivor_rescue.opy#L135).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [156](../src/objective_types/objective_type_survivor_rescue.opy#L156).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [184](../src/objective_types/objective_type_survivor_rescue.opy#L184).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [8](../src/objective_types/objective_type_zombie_egg.opy#L8), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [59](../src/objective_types/objective_type_zombie_egg.opy#L59).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [42](../src/objective_types/objective_type_satellite_uplink.opy#L42), [46](../src/objective_types/objective_type_satellite_uplink.opy#L46), [49](../src/objective_types/objective_type_satellite_uplink.opy#L49).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [49](../src/game/bots_game_in_progress.opy#L49).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [95](../src/game/bots_game_in_progress.opy#L95).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [163](../src/game/bots_game_in_progress.opy#L163).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [184](../src/game/bots_game_in_progress.opy#L184).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [220](../src/game/bots_game_in_progress.opy#L220).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [237](../src/game/bots_game_in_progress.opy#L237).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [266](../src/game/bots_game_in_progress.opy#L266).
- bots_game_in_progress.opy — def enterExitTeleport(): [424](../src/game/bots_game_in_progress.opy#L424).
- bots_game_in_progress.opy — def teleportBots(): [446](../src/game/bots_game_in_progress.opy#L446), [452](../src/game/bots_game_in_progress.opy#L452), [474](../src/game/bots_game_in_progress.opy#L474), [483](../src/game/bots_game_in_progress.opy#L483).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [462](../src/game/zombie_types.opy#L462), [466](../src/game/zombie_types.opy#L466), [470](../src/game/zombie_types.opy#L470).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [482](../src/game/zombie_types.opy#L482).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [104](../src/items/supply_drops.opy#L104), [106](../src/items/supply_drops.opy#L106), [109](../src/items/supply_drops.opy#L109), [122](../src/items/supply_drops.opy#L122), [123](../src/items/supply_drops.opy#L123), [124](../src/items/supply_drops.opy#L124).
- supply_drops.opy — def sentryTurret(): [274](../src/items/supply_drops.opy#L274), [282](../src/items/supply_drops.opy#L282).
- supply_drops.opy — def stun(): [453](../src/items/supply_drops.opy#L453).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [531](../src/abilities/enhancements.opy#L531).

## actorTeamSlot4

Объявление: [variables.opy:485](../src/core/variables.opy#L485).

Алиасы: `botStalkerFadeIndex`, `botEnsnarerTargetIndex`, `powerUpEntityIdList`.

- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [772](../src/game/zombie_types.opy#L772), [777](../src/game/zombie_types.opy#L777).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1164](../src/game/zombie_types.opy#L1164), [1165](../src/game/zombie_types.opy#L1165).
- supply_drops.opy — def playerForceField(): [146](../src/items/supply_drops.opy#L146), [148](../src/items/supply_drops.opy#L148), [150](../src/items/supply_drops.opy#L150), [161](../src/items/supply_drops.opy#L161), [162](../src/items/supply_drops.opy#L162).
- supply_drops.opy — def noCooldowns(): [171](../src/items/supply_drops.opy#L171), [173](../src/items/supply_drops.opy#L173), [191](../src/items/supply_drops.opy#L191), [192](../src/items/supply_drops.opy#L192).
- supply_drops.opy — def airStrike(): [202](../src/items/supply_drops.opy#L202), [204](../src/items/supply_drops.opy#L204), [206](../src/items/supply_drops.opy#L206), [228](../src/items/supply_drops.opy#L228), [229](../src/items/supply_drops.opy#L229), [230](../src/items/supply_drops.opy#L230).
- supply_drops.opy — def healBeacon(): [237](../src/items/supply_drops.opy#L237), [239](../src/items/supply_drops.opy#L239), [241](../src/items/supply_drops.opy#L241), [243](../src/items/supply_drops.opy#L243), [245](../src/items/supply_drops.opy#L245), [254](../src/items/supply_drops.opy#L254), [255](../src/items/supply_drops.opy#L255), [256](../src/items/supply_drops.opy#L256), [257](../src/items/supply_drops.opy#L257).
- supply_drops.opy — def sentryTurret(): [266](../src/items/supply_drops.opy#L266), [268](../src/items/supply_drops.opy#L268), [273](../src/items/supply_drops.opy#L273), [275](../src/items/supply_drops.opy#L275), [277](../src/items/supply_drops.opy#L277), [295](../src/items/supply_drops.opy#L295), [296](../src/items/supply_drops.opy#L296).
- supply_drops.opy — def cloakingDevice(): [303](../src/items/supply_drops.opy#L303), [307](../src/items/supply_drops.opy#L307), [309](../src/items/supply_drops.opy#L309), [324](../src/items/supply_drops.opy#L324), [325](../src/items/supply_drops.opy#L325), [326](../src/items/supply_drops.opy#L326).
- supply_drops.opy — def superNano(): [336](../src/items/supply_drops.opy#L336), [340](../src/items/supply_drops.opy#L340), [342](../src/items/supply_drops.opy#L342), [344](../src/items/supply_drops.opy#L344), [346](../src/items/supply_drops.opy#L346), [348](../src/items/supply_drops.opy#L348), [358](../src/items/supply_drops.opy#L358), [359](../src/items/supply_drops.opy#L359), [360](../src/items/supply_drops.opy#L360), [361](../src/items/supply_drops.opy#L361), [362](../src/items/supply_drops.opy#L362), [365](../src/items/supply_drops.opy#L365).
- supply_drops.opy — def bouncePad(): [374](../src/items/supply_drops.opy#L374), [376](../src/items/supply_drops.opy#L376), [378](../src/items/supply_drops.opy#L378), [403](../src/items/supply_drops.opy#L403), [404](../src/items/supply_drops.opy#L404), [405](../src/items/supply_drops.opy#L405).
- supply_drops.opy — def ultimateCharger(): [411](../src/items/supply_drops.opy#L411), [413](../src/items/supply_drops.opy#L413), [420](../src/items/supply_drops.opy#L420), [421](../src/items/supply_drops.opy#L421).
- supply_drops.opy — def stun(): [427](../src/items/supply_drops.opy#L427), [430](../src/items/supply_drops.opy#L430), [455](../src/items/supply_drops.opy#L455), [456](../src/items/supply_drops.opy#L456).

## actorTeamSlot5

Объявление: [variables.opy:493](../src/core/variables.opy#L493).

Алиасы: `botTarget`, `powerUpAirStrikeIndex`.

- subroutines.opy — macro botEntityManagementMacro(): [200](../src/core/subroutines.opy#L200).
- subroutines.opy — def selectTarget(): [687](../src/core/subroutines.opy#L687), [688](../src/core/subroutines.opy#L688).
- subroutines.opy — def restoreDefaultFacingMovement(): [696](../src/core/subroutines.opy#L696), [698](../src/core/subroutines.opy#L698), [700](../src/core/subroutines.opy#L700).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [54](../src/game/global_game_in_progress.opy#L54), [60](../src/game/global_game_in_progress.opy#L60), [62](../src/game/global_game_in_progress.opy#L62).
- global_game_in_progress.opy — rule "SWARM SHOOTOUT" (event Team 2): [84](../src/game/global_game_in_progress.opy#L84).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [10](../src/objective_types/objective_type_bosses.opy#L10), [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [76](../src/objective_types/objective_type_bosses.opy#L76), [78](../src/objective_types/objective_type_bosses.opy#L78).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [92](../src/objective_types/objective_type_bosses.opy#L92).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [142](../src/objective_types/objective_type_bosses.opy#L142).
- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED" (event Team 2): [187](../src/objective_types/objective_type_bosses.opy#L187), [188](../src/objective_types/objective_type_bosses.opy#L188), [192](../src/objective_types/objective_type_bosses.opy#L192).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [8](../src/objective_types/objective_type_zombie_egg.opy#L8), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [135](../src/game/players_game_in_progress.opy#L135).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [76](../src/game/bots_game_in_progress.opy#L76).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [104](../src/game/bots_game_in_progress.opy#L104).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [139](../src/game/bots_game_in_progress.opy#L139).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [188](../src/game/bots_game_in_progress.opy#L188).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [219](../src/game/bots_game_in_progress.opy#L219).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [241](../src/game/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "BOT TAKES DAMAGE AND SWITCHES TARGETS" (event Team 2): [254](../src/game/bots_game_in_progress.opy#L254), [255](../src/game/bots_game_in_progress.opy#L255).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [267](../src/game/bots_game_in_progress.opy#L267), [268](../src/game/bots_game_in_progress.opy#L268), [270](../src/game/bots_game_in_progress.opy#L270).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [283](../src/game/bots_game_in_progress.opy#L283).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [311](../src/game/bots_game_in_progress.opy#L311).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [324](../src/game/bots_game_in_progress.opy#L324).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [357](../src/game/bots_game_in_progress.opy#L357), [360](../src/game/bots_game_in_progress.opy#L360), [361](../src/game/bots_game_in_progress.opy#L361), [367](../src/game/bots_game_in_progress.opy#L367).
- bots_game_in_progress.opy — def enterExitTeleport(): [432](../src/game/bots_game_in_progress.opy#L432), [437](../src/game/bots_game_in_progress.opy#L437).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [23](../src/game/zombie_types.opy#L23), [27](../src/game/zombie_types.opy#L27).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [69](../src/game/zombie_types.opy#L69), [73](../src/game/zombie_types.opy#L73).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [86](../src/game/zombie_types.opy#L86), [92](../src/game/zombie_types.opy#L92).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [104](../src/game/zombie_types.opy#L104), [109](../src/game/zombie_types.opy#L109).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [162](../src/game/zombie_types.opy#L162), [196](../src/game/zombie_types.opy#L196).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [254](../src/game/zombie_types.opy#L254), [256](../src/game/zombie_types.opy#L256).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [275](../src/game/zombie_types.opy#L275), [276](../src/game/zombie_types.opy#L276).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [315](../src/game/zombie_types.opy#L315), [317](../src/game/zombie_types.opy#L317), [318](../src/game/zombie_types.opy#L318).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [335](../src/game/zombie_types.opy#L335), [336](../src/game/zombie_types.opy#L336), [343](../src/game/zombie_types.opy#L343), [355](../src/game/zombie_types.opy#L355), [357](../src/game/zombie_types.opy#L357).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [436](../src/game/zombie_types.opy#L436).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [467](../src/game/zombie_types.opy#L467).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [480](../src/game/zombie_types.opy#L480), [482](../src/game/zombie_types.opy#L482).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [493](../src/game/zombie_types.opy#L493), [495](../src/game/zombie_types.opy#L495), [497](../src/game/zombie_types.opy#L497), [498](../src/game/zombie_types.opy#L498), [499](../src/game/zombie_types.opy#L499), [502](../src/game/zombie_types.opy#L502), [511](../src/game/zombie_types.opy#L511).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [526](../src/game/zombie_types.opy#L526), [533](../src/game/zombie_types.opy#L533), [534](../src/game/zombie_types.opy#L534), [552](../src/game/zombie_types.opy#L552).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [587](../src/game/zombie_types.opy#L587), [592](../src/game/zombie_types.opy#L592), [593](../src/game/zombie_types.opy#L593), [631](../src/game/zombie_types.opy#L631).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [640](../src/game/zombie_types.opy#L640), [646](../src/game/zombie_types.opy#L646), [667](../src/game/zombie_types.opy#L667), [668](../src/game/zombie_types.opy#L668).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [703](../src/game/zombie_types.opy#L703), [708](../src/game/zombie_types.opy#L708), [709](../src/game/zombie_types.opy#L709), [723](../src/game/zombie_types.opy#L723).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [760](../src/game/zombie_types.opy#L760), [764](../src/game/zombie_types.opy#L764).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [823](../src/game/zombie_types.opy#L823), [830](../src/game/zombie_types.opy#L830), [834](../src/game/zombie_types.opy#L834), [880](../src/game/zombie_types.opy#L880).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [905](../src/game/zombie_types.opy#L905), [910](../src/game/zombie_types.opy#L910), [911](../src/game/zombie_types.opy#L911), [913](../src/game/zombie_types.opy#L913), [915](../src/game/zombie_types.opy#L915).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [928](../src/game/zombie_types.opy#L928), [930](../src/game/zombie_types.opy#L930), [933](../src/game/zombie_types.opy#L933), [937](../src/game/zombie_types.opy#L937).
- zombie_types.opy — rule "DOWNFALLEN PULLS PLAYERS" (event Team 2): [975](../src/game/zombie_types.opy#L975), [976](../src/game/zombie_types.opy#L976).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [988](../src/game/zombie_types.opy#L988), [991](../src/game/zombie_types.opy#L991), [992](../src/game/zombie_types.opy#L992), [993](../src/game/zombie_types.opy#L993).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1005](../src/game/zombie_types.opy#L1005), [1013](../src/game/zombie_types.opy#L1013), [1023](../src/game/zombie_types.opy#L1023), [1063](../src/game/zombie_types.opy#L1063), [1064](../src/game/zombie_types.opy#L1064), [1073](../src/game/zombie_types.opy#L1073), [1080](../src/game/zombie_types.opy#L1080).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1102](../src/game/zombie_types.opy#L1102), [1105](../src/game/zombie_types.opy#L1105), [1106](../src/game/zombie_types.opy#L1106), [1107](../src/game/zombie_types.opy#L1107), [1108](../src/game/zombie_types.opy#L1108).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1118](../src/game/zombie_types.opy#L1118).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1130](../src/game/zombie_types.opy#L1130), [1135](../src/game/zombie_types.opy#L1135).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1155](../src/game/zombie_types.opy#L1155), [1156](../src/game/zombie_types.opy#L1156), [1178](../src/game/zombie_types.opy#L1178).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1189](../src/game/zombie_types.opy#L1189), [1190](../src/game/zombie_types.opy#L1190), [1191](../src/game/zombie_types.opy#L1191).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1203](../src/game/zombie_types.opy#L1203), [1205](../src/game/zombie_types.opy#L1205).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1239](../src/game/zombie_types.opy#L1239).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1257](../src/game/zombie_types.opy#L1257).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS" (event Team 2): [1317](../src/game/zombie_types.opy#L1317).
- zombie_types.opy — rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE" (event Team 2): [1363](../src/game/zombie_types.opy#L1363), [1364](../src/game/zombie_types.opy#L1364).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1385](../src/game/zombie_types.opy#L1385), [1388](../src/game/zombie_types.opy#L1388), [1389](../src/game/zombie_types.opy#L1389).
- zombie_types.opy — def abilityThrowdown(): [1457](../src/game/zombie_types.opy#L1457).
- supply_drops.opy — def airStrike(): [209](../src/items/supply_drops.opy#L209).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [527](../src/abilities/enhancements.opy#L527), [530](../src/abilities/enhancements.opy#L530).

## actorTeamSlot6

Объявление: [variables.opy:499](../src/core/variables.opy#L499).

Алиасы: `botBiteDuration`, `powerUpHealBeaconTimeRemaining`.

- subroutines.opy — macro botStatManagementMacro(): [38](../src/core/subroutines.opy#L38).
- subroutines.opy — macro mutationsMacro(): [104](../src/core/subroutines.opy#L104).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [395](../src/game/bots_game_in_progress.opy#L395), [396](../src/game/bots_game_in_progress.opy#L396), [397](../src/game/bots_game_in_progress.opy#L397).
- supply_drops.opy — def healBeacon(): [242](../src/items/supply_drops.opy#L242), [250](../src/items/supply_drops.opy#L250).

## actorTeamSlot7

Объявление: [variables.opy:505](../src/core/variables.opy#L505).

Алиасы: `botIsTeleportConfirmed`, `powerUpTurretTimeRemaining`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [60](../src/objective_types/objective_type_zombie_egg.opy#L60), [67](../src/objective_types/objective_type_zombie_egg.opy#L67).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [162](../src/game/bots_game_in_progress.opy#L162).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [193](../src/game/bots_game_in_progress.opy#L193), [198](../src/game/bots_game_in_progress.opy#L198).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [221](../src/game/bots_game_in_progress.opy#L221), [226](../src/game/bots_game_in_progress.opy#L226), [227](../src/game/bots_game_in_progress.opy#L227).
- bots_game_in_progress.opy — def teleportBots(): [449](../src/game/bots_game_in_progress.opy#L449).
- bots_game_in_progress.opy — def successfulTeleportStatus(): [508](../src/game/bots_game_in_progress.opy#L508), [509](../src/game/bots_game_in_progress.opy#L509).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/game/bots_game_in_progress.opy#L515), [519](../src/game/bots_game_in_progress.opy#L519).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [934](../src/game/zombie_types.opy#L934).
- supply_drops.opy — def sentryTurret(): [276](../src/items/supply_drops.opy#L276), [281](../src/items/supply_drops.opy#L281).

## actorTeamSlot8

Объявление: [variables.opy:511](../src/core/variables.opy#L511).

Алиасы: `botReigniteDestination`, `powerUpCloakTimeRemaining`.

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [413](../src/game/zombie_types.opy#L413), [422](../src/game/zombie_types.opy#L422), [423](../src/game/zombie_types.opy#L423), [425](../src/game/zombie_types.opy#L425), [427](../src/game/zombie_types.opy#L427).
- supply_drops.opy — def cloakingDevice(): [308](../src/items/supply_drops.opy#L308), [316](../src/items/supply_drops.opy#L316), [317](../src/items/supply_drops.opy#L317), [322](../src/items/supply_drops.opy#L322).

## actorTeamSlot9

Объявление: [variables.opy:517](../src/core/variables.opy#L517).

Алиасы: `botIsWallPhaseAllowed`, `powerUpSuperNanoTimeRemaining`.

- subroutines.opy — def botRespawnInitialization(): [728](../src/core/subroutines.opy#L728).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [91](../src/objective_types/objective_type_bosses.opy#L91).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [326](../src/game/bots_game_in_progress.opy#L326).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [342](../src/game/zombie_types.opy#L342).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [537](../src/game/zombie_types.opy#L537), [565](../src/game/zombie_types.opy#L565).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [715](../src/game/zombie_types.opy#L715), [730](../src/game/zombie_types.opy#L730).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [773](../src/game/zombie_types.opy#L773), [798](../src/game/zombie_types.opy#L798), [803](../src/game/zombie_types.opy#L803).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [944](../src/game/zombie_types.opy#L944), [963](../src/game/zombie_types.opy#L963).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1058](../src/game/zombie_types.opy#L1058), [1076](../src/game/zombie_types.opy#L1076).
- supply_drops.opy — def superNano(): [341](../src/items/supply_drops.opy#L341), [353](../src/items/supply_drops.opy#L353).

## actorTeamSlot10

Объявление: [variables.opy:523](../src/core/variables.opy#L523).

Алиасы: `botAbilityTarget`, `powerUpUltimateTimeRemaining`.

- subroutines.opy — def botRespawnInitialization(): [732](../src/core/subroutines.opy#L732).
- subroutines.opy — def illariUlt(): [799](../src/core/subroutines.opy#L799), [800](../src/core/subroutines.opy#L800), [801](../src/core/subroutines.opy#L801).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [50](../src/game/zombie_types.opy#L50), [51](../src/game/zombie_types.opy#L51), [53](../src/game/zombie_types.opy#L53), [56](../src/game/zombie_types.opy#L56).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [441](../src/game/zombie_types.opy#L441), [442](../src/game/zombie_types.opy#L442).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [450](../src/game/zombie_types.opy#L450), [451](../src/game/zombie_types.opy#L451), [453](../src/game/zombie_types.opy#L453).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [470](../src/game/zombie_types.opy#L470), [471](../src/game/zombie_types.opy#L471).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [481](../src/game/zombie_types.opy#L481), [482](../src/game/zombie_types.opy#L482), [484](../src/game/zombie_types.opy#L484).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [598](../src/game/zombie_types.opy#L598), [606](../src/game/zombie_types.opy#L606), [607](../src/game/zombie_types.opy#L607), [613](../src/game/zombie_types.opy#L613), [615](../src/game/zombie_types.opy#L615), [616](../src/game/zombie_types.opy#L616), [617](../src/game/zombie_types.opy#L617), [618](../src/game/zombie_types.opy#L618), [620](../src/game/zombie_types.opy#L620).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [680](../src/game/zombie_types.opy#L680), [681](../src/game/zombie_types.opy#L681), [683](../src/game/zombie_types.opy#L683), [686](../src/game/zombie_types.opy#L686).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [937](../src/game/zombie_types.opy#L937), [939](../src/game/zombie_types.opy#L939), [943](../src/game/zombie_types.opy#L943), [946](../src/game/zombie_types.opy#L946), [950](../src/game/zombie_types.opy#L950), [951](../src/game/zombie_types.opy#L951), [952](../src/game/zombie_types.opy#L952), [955](../src/game/zombie_types.opy#L955), [956](../src/game/zombie_types.opy#L956), [957](../src/game/zombie_types.opy#L957), [958](../src/game/zombie_types.opy#L958), [966](../src/game/zombie_types.opy#L966).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1018](../src/game/zombie_types.opy#L1018), [1019](../src/game/zombie_types.opy#L1019), [1021](../src/game/zombie_types.opy#L1021), [1022](../src/game/zombie_types.opy#L1022), [1031](../src/game/zombie_types.opy#L1031), [1032](../src/game/zombie_types.opy#L1032), [1039](../src/game/zombie_types.opy#L1039), [1048](../src/game/zombie_types.opy#L1048), [1053](../src/game/zombie_types.opy#L1053), [1054](../src/game/zombie_types.opy#L1054), [1055](../src/game/zombie_types.opy#L1055), [1062](../src/game/zombie_types.opy#L1062), [1064](../src/game/zombie_types.opy#L1064), [1066](../src/game/zombie_types.opy#L1066), [1067](../src/game/zombie_types.opy#L1067).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1295](../src/game/zombie_types.opy#L1295), [1296](../src/game/zombie_types.opy#L1296).
- supply_drops.opy — def ultimateCharger(): [412](../src/items/supply_drops.opy#L412), [416](../src/items/supply_drops.opy#L416).

## actorTeamSlot11

Объявление: [variables.opy:529](../src/core/variables.opy#L529).

Алиасы: `botTeleportPosition`, `powerUpStunBouncesRemaining`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [69](../src/objective_types/objective_type_zombie_egg.opy#L69), [70](../src/objective_types/objective_type_zombie_egg.opy#L70), [73](../src/objective_types/objective_type_zombie_egg.opy#L73).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [161](../src/game/bots_game_in_progress.opy#L161).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [228](../src/game/bots_game_in_progress.opy#L228).
- bots_game_in_progress.opy — def enterExitTeleport(): [433](../src/game/bots_game_in_progress.opy#L433), [434](../src/game/bots_game_in_progress.opy#L434).
- bots_game_in_progress.opy — def teleportBots(): [455](../src/game/bots_game_in_progress.opy#L455), [457](../src/game/bots_game_in_progress.opy#L457), [466](../src/game/bots_game_in_progress.opy#L466), [467](../src/game/bots_game_in_progress.opy#L467), [470](../src/game/bots_game_in_progress.opy#L470), [472](../src/game/bots_game_in_progress.opy#L472), [473](../src/game/bots_game_in_progress.opy#L473), [476](../src/game/bots_game_in_progress.opy#L476), [477](../src/game/bots_game_in_progress.opy#L477), [478](../src/game/bots_game_in_progress.opy#L478), [479](../src/game/bots_game_in_progress.opy#L479).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/game/bots_game_in_progress.opy#L515), [516](../src/game/bots_game_in_progress.opy#L516), [519](../src/game/bots_game_in_progress.opy#L519), [520](../src/game/bots_game_in_progress.opy#L520), [521](../src/game/bots_game_in_progress.opy#L521), [522](../src/game/bots_game_in_progress.opy#L522).
- supply_drops.opy — def stun(): [440](../src/items/supply_drops.opy#L440), [442](../src/items/supply_drops.opy#L442), [443](../src/items/supply_drops.opy#L443).

## actorTeamSlot12

Объявление: [variables.opy:535](../src/core/variables.opy#L535).

Алиасы: `botBossHealth`, `powerUpStunBeamPosition`.

- subroutines.opy — def botRespawnInitialization(): [734](../src/core/subroutines.opy#L734).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [60](../src/objective_types/objective_type_bosses.opy#L60).
- objective_types/objective_type_bosses.opy — rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)" (event Team 2): [114](../src/objective_types/objective_type_bosses.opy#L114), [115](../src/objective_types/objective_type_bosses.opy#L115).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [127](../src/objective_types/objective_type_bosses.opy#L127), [129](../src/objective_types/objective_type_bosses.opy#L129), [130](../src/objective_types/objective_type_bosses.opy#L130), [141](../src/objective_types/objective_type_bosses.opy#L141), [154](../src/objective_types/objective_type_bosses.opy#L154), [157](../src/objective_types/objective_type_bosses.opy#L157).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [37](../src/objective_types/objective_type_zombie_egg.opy#L37).
- supply_drops.opy — def stun(): [429](../src/items/supply_drops.opy#L429), [433](../src/items/supply_drops.opy#L433), [438](../src/items/supply_drops.opy#L438), [445](../src/items/supply_drops.opy#L445), [454](../src/items/supply_drops.opy#L454).

## actorTeamSlot13

Объявление: [variables.opy:541](../src/core/variables.opy#L541).

Алиасы: `botIsWallCollisionEnabled`, `powerUpTurretPosition`.

- subroutines.opy — def botRespawnInitialization(): [723](../src/core/subroutines.opy#L723).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [69](../src/objective_types/objective_type_bosses.opy#L69), [83](../src/objective_types/objective_type_bosses.opy#L83).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [90](../src/objective_types/objective_type_bosses.opy#L90), [98](../src/objective_types/objective_type_bosses.opy#L98), [102](../src/objective_types/objective_type_bosses.opy#L102).
- objective_types/objective_type_bosses.opy — rule "BOSS TAKES KNOCKBACK" (event Team 2): [173](../src/objective_types/objective_type_bosses.opy#L173), [177](../src/objective_types/objective_type_bosses.opy#L177).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [41](../src/objective_types/objective_type_zombie_egg.opy#L41), [42](../src/objective_types/objective_type_zombie_egg.opy#L42).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [325](../src/game/bots_game_in_progress.opy#L325), [341](../src/game/bots_game_in_progress.opy#L341), [349](../src/game/bots_game_in_progress.opy#L349).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [539](../src/game/zombie_types.opy#L539).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [653](../src/game/zombie_types.opy#L653), [672](../src/game/zombie_types.opy#L672).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [716](../src/game/zombie_types.opy#L716).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [762](../src/game/zombie_types.opy#L762), [774](../src/game/zombie_types.opy#L774).
- supply_drops.opy — def sentryTurret(): [265](../src/items/supply_drops.opy#L265), [267](../src/items/supply_drops.opy#L267), [272](../src/items/supply_drops.opy#L272), [274](../src/items/supply_drops.opy#L274), [278](../src/items/supply_drops.opy#L278), [279](../src/items/supply_drops.opy#L279), [282](../src/items/supply_drops.opy#L282), [283](../src/items/supply_drops.opy#L283), [286](../src/items/supply_drops.opy#L286), [287](../src/items/supply_drops.opy#L287), [288](../src/items/supply_drops.opy#L288), [290](../src/items/supply_drops.opy#L290), [297](../src/items/supply_drops.opy#L297).

## actorTeamSlot14

Объявление: [variables.opy:547](../src/core/variables.opy#L547).

Алиасы: `botIsFacingOverridden`, `powerUpStunTarget`.

- subroutines.opy — def restoreDefaultFacingMovement(): [697](../src/core/subroutines.opy#L697).
- subroutines.opy — def botRespawnInitialization(): [726](../src/core/subroutines.opy#L726).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [273](../src/game/bots_game_in_progress.opy#L273).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [285](../src/game/bots_game_in_progress.opy#L285).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [365](../src/game/bots_game_in_progress.opy#L365), [378](../src/game/bots_game_in_progress.opy#L378).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [43](../src/game/zombie_types.opy#L43), [59](../src/game/zombie_types.opy#L59).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [124](../src/game/zombie_types.opy#L124), [136](../src/game/zombie_types.opy#L136).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [195](../src/game/zombie_types.opy#L195), [206](../src/game/zombie_types.opy#L206).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [340](../src/game/zombie_types.opy#L340), [359](../src/game/zombie_types.opy#L359), [366](../src/game/zombie_types.opy#L366).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [501](../src/game/zombie_types.opy#L501), [509](../src/game/zombie_types.opy#L509).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [540](../src/game/zombie_types.opy#L540), [547](../src/game/zombie_types.opy#L547), [553](../src/game/zombie_types.opy#L553), [562](../src/game/zombie_types.opy#L562).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [665](../src/game/zombie_types.opy#L665), [689](../src/game/zombie_types.opy#L689).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [767](../src/game/zombie_types.opy#L767), [801](../src/game/zombie_types.opy#L801).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [829](../src/game/zombie_types.opy#L829), [841](../src/game/zombie_types.opy#L841), [850](../src/game/zombie_types.opy#L850), [878](../src/game/zombie_types.opy#L878).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1012](../src/game/zombie_types.opy#L1012), [1038](../src/game/zombie_types.opy#L1038), [1047](../src/game/zombie_types.opy#L1047), [1078](../src/game/zombie_types.opy#L1078).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1161](../src/game/zombie_types.opy#L1161), [1172](../src/game/zombie_types.opy#L1172).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1395](../src/game/zombie_types.opy#L1395), [1403](../src/game/zombie_types.opy#L1403).
- supply_drops.opy — def stun(): [437](../src/items/supply_drops.opy#L437), [438](../src/items/supply_drops.opy#L438), [441](../src/items/supply_drops.opy#L441), [445](../src/items/supply_drops.opy#L445), [446](../src/items/supply_drops.opy#L446), [447](../src/items/supply_drops.opy#L447), [448](../src/items/supply_drops.opy#L448), [451](../src/items/supply_drops.opy#L451), [453](../src/items/supply_drops.opy#L453).

## actorTeamSlot15

Объявление: [variables.opy:553](../src/core/variables.opy#L553).

Алиасы: `botIsThrottleOverridden`, `powerUpHealBeaconPosition`.

- subroutines.opy — def restoreDefaultFacingMovement(): [699](../src/core/subroutines.opy#L699).
- subroutines.opy — def botRespawnInitialization(): [727](../src/core/subroutines.opy#L727).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [32](../src/objective_types/objective_type_zombie_egg.opy#L32).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [96](../src/game/bots_game_in_progress.opy#L96).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [271](../src/game/bots_game_in_progress.opy#L271).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [284](../src/game/bots_game_in_progress.opy#L284).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [303](../src/game/bots_game_in_progress.opy#L303).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [41](../src/game/zombie_types.opy#L41), [58](../src/game/zombie_types.opy#L58).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [121](../src/game/zombie_types.opy#L121), [137](../src/game/zombie_types.opy#L137).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [193](../src/game/zombie_types.opy#L193), [207](../src/game/zombie_types.opy#L207).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [339](../src/game/zombie_types.opy#L339), [358](../src/game/zombie_types.opy#L358), [365](../src/game/zombie_types.opy#L365).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [528](../src/game/zombie_types.opy#L528), [542](../src/game/zombie_types.opy#L542), [548](../src/game/zombie_types.opy#L548), [563](../src/game/zombie_types.opy#L563).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [590](../src/game/zombie_types.opy#L590), [596](../src/game/zombie_types.opy#L596), [629](../src/game/zombie_types.opy#L629).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [642](../src/game/zombie_types.opy#L642), [651](../src/game/zombie_types.opy#L651), [664](../src/game/zombie_types.opy#L664), [688](../src/game/zombie_types.opy#L688), [692](../src/game/zombie_types.opy#L692).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [705](../src/game/zombie_types.opy#L705).
- zombie_types.opy — rule "STRIKER CANCEL BALL FORM" (event Team 2): [738](../src/game/zombie_types.opy#L738).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [770](../src/game/zombie_types.opy#L770), [800](../src/game/zombie_types.opy#L800).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [827](../src/game/zombie_types.opy#L827), [840](../src/game/zombie_types.opy#L840), [849](../src/game/zombie_types.opy#L849), [877](../src/game/zombie_types.opy#L877).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [940](../src/game/zombie_types.opy#L940), [961](../src/game/zombie_types.opy#L961).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1011](../src/game/zombie_types.opy#L1011), [1037](../src/game/zombie_types.opy#L1037), [1046](../src/game/zombie_types.opy#L1046), [1077](../src/game/zombie_types.opy#L1077).
- supply_drops.opy — def healBeacon(): [236](../src/items/supply_drops.opy#L236), [238](../src/items/supply_drops.opy#L238), [240](../src/items/supply_drops.opy#L240), [246](../src/items/supply_drops.opy#L246), [247](../src/items/supply_drops.opy#L247), [252](../src/items/supply_drops.opy#L252), [253](../src/items/supply_drops.opy#L253), [259](../src/items/supply_drops.opy#L259).

## actorTeamSlot16

Объявление: [variables.opy:559](../src/core/variables.opy#L559).

Алиасы: `botConfiguredHero`, `powerUpForceFieldPosition`.

- subroutines.opy — macro botEntityManagementMacro(): [129](../src/core/subroutines.opy#L129), [130](../src/core/subroutines.opy#L130).
- supply_drops.opy — def playerForceField(): [145](../src/items/supply_drops.opy#L145), [147](../src/items/supply_drops.opy#L147), [151](../src/items/supply_drops.opy#L151), [152](../src/items/supply_drops.opy#L152), [158](../src/items/supply_drops.opy#L158), [159](../src/items/supply_drops.opy#L159), [163](../src/items/supply_drops.opy#L163).

## actorTeamSlot17

Объявление: [variables.opy:565](../src/core/variables.opy#L565).

Алиасы: `botMutationId`, `powerUpBouncePadPosition`.

- subroutines.opy — macro mutationsMacro(): [81](../src/core/subroutines.opy#L81), [84](../src/core/subroutines.opy#L84), [91](../src/core/subroutines.opy#L91), [97](../src/core/subroutines.opy#L97), [103](../src/core/subroutines.opy#L103), [121](../src/core/subroutines.opy#L121).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/game/bots_game_in_progress.opy#L399).
- supply_drops.opy — def bouncePad(): [373](../src/items/supply_drops.opy#L373), [375](../src/items/supply_drops.opy#L375), [379](../src/items/supply_drops.opy#L379), [380](../src/items/supply_drops.opy#L380), [385](../src/items/supply_drops.opy#L385), [389](../src/items/supply_drops.opy#L389), [400](../src/items/supply_drops.opy#L400).

## actorTeamSlot18

Объявление: [variables.opy:571](../src/core/variables.opy#L571).

Алиасы: `botIsInitializing`, `powerUpStunOrigin`.

- subroutines.opy — macro minibossMutationMacro(): [27](../src/core/subroutines.opy#L27).
- subroutines.opy — def botRespawnInitialization(): [709](../src/core/subroutines.opy#L709), [753](../src/core/subroutines.opy#L753).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [17](../src/objective_types/objective_type_bosses.opy#L17), [18](../src/objective_types/objective_type_bosses.opy#L18).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [58](../src/objective_types/objective_type_zombie_egg.opy#L58).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [48](../src/game/bots_game_in_progress.opy#L48).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [238](../src/game/bots_game_in_progress.opy#L238).
- bots_game_in_progress.opy — def teleportBots(): [450](../src/game/bots_game_in_progress.opy#L450).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE" (event Team 2): [531](../src/game/bots_game_in_progress.opy#L531).
- supply_drops.opy — def stun(): [429](../src/items/supply_drops.opy#L429), [435](../src/items/supply_drops.opy#L435), [442](../src/items/supply_drops.opy#L442), [443](../src/items/supply_drops.opy#L443), [451](../src/items/supply_drops.opy#L451), [453](../src/items/supply_drops.opy#L453).

## actorTeamSlot19

Объявление: [variables.opy:577](../src/core/variables.opy#L577).

Алиасы: `botKnockbackScale`, `powerUpTurretDirection`.

- subroutines.opy — macro botStatManagementMacro(): [52](../src/core/subroutines.opy#L52), [55](../src/core/subroutines.opy#L55), [56](../src/core/subroutines.opy#L56).
- subroutines.opy — macro mutationsMacro(): [109](../src/core/subroutines.opy#L109), [110](../src/core/subroutines.opy#L110), [112](../src/core/subroutines.opy#L112), [115](../src/core/subroutines.opy#L115).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [418](../src/game/bots_game_in_progress.opy#L418).
- supply_drops.opy — def sentryTurret(): [274](../src/items/supply_drops.opy#L274), [283](../src/items/supply_drops.opy#L283), [286](../src/items/supply_drops.opy#L286), [287](../src/items/supply_drops.opy#L287), [288](../src/items/supply_drops.opy#L288).

## actorTeamSlot20

Объявление: [variables.opy:583](../src/core/variables.opy#L583).

Алиасы: `botCustomTeleportPosition`, `powerUpAirStrikePosition`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [68](../src/objective_types/objective_type_zombie_egg.opy#L68).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [68](../src/game/bots_game_in_progress.opy#L68), [71](../src/game/bots_game_in_progress.opy#L71).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [154](../src/game/bots_game_in_progress.opy#L154), [155](../src/game/bots_game_in_progress.opy#L155).
- bots_game_in_progress.opy — def teleportBots(): [451](../src/game/bots_game_in_progress.opy#L451), [481](../src/game/bots_game_in_progress.opy#L481), [482](../src/game/bots_game_in_progress.opy#L482).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/game/bots_game_in_progress.opy#L515).
- supply_drops.opy — def airStrike(): [201](../src/items/supply_drops.opy#L201), [203](../src/items/supply_drops.opy#L203), [205](../src/items/supply_drops.opy#L205), [213](../src/items/supply_drops.opy#L213).

## actorTeamSlot21

Объявление: [variables.opy:589](../src/core/variables.opy#L589).

Алиасы: `botLastTarget`, `powerUpTradeIndex`.

- subroutines.opy — def selectTarget(): [688](../src/core/subroutines.opy#L688).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [137](../src/objective_types/objective_type_bosses.opy#L137), [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [272](../src/game/bots_game_in_progress.opy#L272).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/game/zombie_types.opy#L196), [198](../src/game/zombie_types.opy#L198).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [353](../src/game/zombie_types.opy#L353).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [541](../src/game/zombie_types.opy#L541).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [769](../src/game/zombie_types.opy#L769), [778](../src/game/zombie_types.opy#L778), [779](../src/game/zombie_types.opy#L779).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [830](../src/game/zombie_types.opy#L830), [852](../src/game/zombie_types.opy#L852).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1013](../src/game/zombie_types.opy#L1013).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1238](../src/game/zombie_types.opy#L1238).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1253](../src/game/zombie_types.opy#L1253).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [109](../src/items/supply_drops.opy#L109), [112](../src/items/supply_drops.opy#L112), [113](../src/items/supply_drops.opy#L113), [114](../src/items/supply_drops.opy#L114), [116](../src/items/supply_drops.opy#L116), [117](../src/items/supply_drops.opy#L117), [118](../src/items/supply_drops.opy#L118), [119](../src/items/supply_drops.opy#L119).

## actorTeamSlot22

Объявление: [variables.opy:595](../src/core/variables.opy#L595).

Алиасы: `botAbilityCooldown`, `botGasPositionList`, `enhancementHybridCooldown`, `enhancementBarrierFacing`, `enhancementPyroHitList`, `enhancementPlagueCureTotal`, `enhancementIsBattleResetReady`, `enhancementBatteryPosition`, `enhancementHitchhikerCarrier`, `enhancementPupColor`.

- subroutines.opy — macro botStatManagementMacro(): [73](../src/core/subroutines.opy#L73).
- subroutines.opy — macro botEntityManagementMacro(): [152](../src/core/subroutines.opy#L152), [155](../src/core/subroutines.opy#L155).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [41](../src/objective_types/objective_type_survivor_rescue.opy#L41).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [363](../src/game/bots_game_in_progress.opy#L363), [381](../src/game/bots_game_in_progress.opy#L381).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [210](../src/game/zombie_types.opy#L210), [213](../src/game/zombie_types.opy#L213), [215](../src/game/zombie_types.opy#L215), [217](../src/game/zombie_types.opy#L217), [223](../src/game/zombie_types.opy#L223).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [233](../src/game/zombie_types.opy#L233), [238](../src/game/zombie_types.opy#L238), [241](../src/game/zombie_types.opy#L241).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1154](../src/game/zombie_types.opy#L1154), [1181](../src/game/zombie_types.opy#L1181).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1399](../src/game/zombie_types.opy#L1399).
- zombie_types.opy — def abilityThrowdown(): [1458](../src/game/zombie_types.opy#L1458).
- zombie_types.opy — def spawnGasCloud(): [1498](../src/game/zombie_types.opy#L1498).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/abilities/enhancements.opy#L29), [73](../src/abilities/enhancements.opy#L73), [79](../src/abilities/enhancements.opy#L79), [82](../src/abilities/enhancements.opy#L82), [89](../src/abilities/enhancements.opy#L89), [90](../src/abilities/enhancements.opy#L90), [103](../src/abilities/enhancements.opy#L103), [105](../src/abilities/enhancements.opy#L105), [107](../src/abilities/enhancements.opy#L107), [109](../src/abilities/enhancements.opy#L109), [119](../src/abilities/enhancements.opy#L119), [121](../src/abilities/enhancements.opy#L121), [122](../src/abilities/enhancements.opy#L122), [123](../src/abilities/enhancements.opy#L123), [134](../src/abilities/enhancements.opy#L134), [143](../src/abilities/enhancements.opy#L143), [145](../src/abilities/enhancements.opy#L145), [151](../src/abilities/enhancements.opy#L151).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [166](../src/abilities/enhancements.opy#L166), [172](../src/abilities/enhancements.opy#L172), [173](../src/abilities/enhancements.opy#L173), [175](../src/abilities/enhancements.opy#L175).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [204](../src/abilities/enhancements.opy#L204).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [237](../src/abilities/enhancements.opy#L237).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [290](../src/abilities/enhancements.opy#L290).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [297](../src/abilities/enhancements.opy#L297), [299](../src/abilities/enhancements.opy#L299), [302](../src/abilities/enhancements.opy#L302), [306](../src/abilities/enhancements.opy#L306), [311](../src/abilities/enhancements.opy#L311).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [321](../src/abilities/enhancements.opy#L321), [323](../src/abilities/enhancements.opy#L323).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [330](../src/abilities/enhancements.opy#L330), [348](../src/abilities/enhancements.opy#L348), [355](../src/abilities/enhancements.opy#L355), [363](../src/abilities/enhancements.opy#L363), [367](../src/abilities/enhancements.opy#L367).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [377](../src/abilities/enhancements.opy#L377), [380](../src/abilities/enhancements.opy#L380), [383](../src/abilities/enhancements.opy#L383).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [405](../src/abilities/enhancements.opy#L405), [408](../src/abilities/enhancements.opy#L408), [409](../src/abilities/enhancements.opy#L409).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [422](../src/abilities/enhancements.opy#L422), [423](../src/abilities/enhancements.opy#L423), [427](../src/abilities/enhancements.opy#L427), [429](../src/abilities/enhancements.opy#L429).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/abilities/enhancements.opy#L444), [450](../src/abilities/enhancements.opy#L450), [453](../src/abilities/enhancements.opy#L453), [456](../src/abilities/enhancements.opy#L456), [464](../src/abilities/enhancements.opy#L464), [466](../src/abilities/enhancements.opy#L466), [468](../src/abilities/enhancements.opy#L468), [470](../src/abilities/enhancements.opy#L470), [471](../src/abilities/enhancements.opy#L471), [475](../src/abilities/enhancements.opy#L475), [477](../src/abilities/enhancements.opy#L477).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [499](../src/abilities/enhancements.opy#L499), [501](../src/abilities/enhancements.opy#L501), [505](../src/abilities/enhancements.opy#L505), [508](../src/abilities/enhancements.opy#L508), [511](../src/abilities/enhancements.opy#L511).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [539](../src/abilities/enhancements.opy#L539).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [560](../src/abilities/enhancements.opy#L560), [570](../src/abilities/enhancements.opy#L570), [588](../src/abilities/enhancements.opy#L588), [595](../src/abilities/enhancements.opy#L595), [610](../src/abilities/enhancements.opy#L610).

## actorTeamSlot23

Объявление: [variables.opy:617](../src/core/variables.opy#L617).

Алиасы: `botGasRadiusList`, `enhancementBarrierEdgeDirection`, `enhancementBattleAbilityButton`, `enhancementBatteryReuseCooldown`, `enhancementHitchhikerPassengerPoolId`, `enhancementIsPupBeamActive`.

- subroutines.opy — macro botEntityManagementMacro(): [152](../src/core/subroutines.opy#L152), [155](../src/core/subroutines.opy#L155).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [42](../src/objective_types/objective_type_survivor_rescue.opy#L42).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [212](../src/game/zombie_types.opy#L212), [224](../src/game/zombie_types.opy#L224).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [239](../src/game/zombie_types.opy#L239), [240](../src/game/zombie_types.opy#L240), [241](../src/game/zombie_types.opy#L241).
- zombie_types.opy — def spawnGasCloud(): [1499](../src/game/zombie_types.opy#L1499).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [105](../src/abilities/enhancements.opy#L105), [107](../src/abilities/enhancements.opy#L107), [109](../src/abilities/enhancements.opy#L109), [141](../src/abilities/enhancements.opy#L141), [145](../src/abilities/enhancements.opy#L145), [147](../src/abilities/enhancements.opy#L147), [153](../src/abilities/enhancements.opy#L153).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [206](../src/abilities/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/abilities/enhancements.opy#L230), [234](../src/abilities/enhancements.opy#L234).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [334](../src/abilities/enhancements.opy#L334), [336](../src/abilities/enhancements.opy#L336), [338](../src/abilities/enhancements.opy#L338), [340](../src/abilities/enhancements.opy#L340), [342](../src/abilities/enhancements.opy#L342), [344](../src/abilities/enhancements.opy#L344), [347](../src/abilities/enhancements.opy#L347), [351](../src/abilities/enhancements.opy#L351), [354](../src/abilities/enhancements.opy#L354), [359](../src/abilities/enhancements.opy#L359), [362](../src/abilities/enhancements.opy#L362), [365](../src/abilities/enhancements.opy#L365), [366](../src/abilities/enhancements.opy#L366).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [411](../src/abilities/enhancements.opy#L411).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [432](../src/abilities/enhancements.opy#L432), [433](../src/abilities/enhancements.opy#L433), [435](../src/abilities/enhancements.opy#L435).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [467](../src/abilities/enhancements.opy#L467), [478](../src/abilities/enhancements.opy#L478).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [541](../src/abilities/enhancements.opy#L541).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [562](../src/abilities/enhancements.opy#L562), [572](../src/abilities/enhancements.opy#L572), [590](../src/abilities/enhancements.opy#L590), [597](../src/abilities/enhancements.opy#L597), [612](../src/abilities/enhancements.opy#L612).

## actorTeamSlot24

Объявление: [variables.opy:631](../src/core/variables.opy#L631).

Алиасы: `botSpawnWaypoint`, `enhancementBarrierPlacementCooldown`, `enhancementBatteryReuseDuration`, `enhancementPupTarget`.

- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [229](../src/game/bots_game_in_progress.opy#L229).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [517](../src/game/bots_game_in_progress.opy#L517).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/abilities/enhancements.opy#L48), [50](../src/abilities/enhancements.opy#L50), [109](../src/abilities/enhancements.opy#L109), [110](../src/abilities/enhancements.opy#L110), [145](../src/abilities/enhancements.opy#L145), [149](../src/abilities/enhancements.opy#L149), [155](../src/abilities/enhancements.opy#L155).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [185](../src/abilities/enhancements.opy#L185), [211](../src/abilities/enhancements.opy#L211), [212](../src/abilities/enhancements.opy#L212), [214](../src/abilities/enhancements.opy#L214).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [432](../src/abilities/enhancements.opy#L432).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [526](../src/abilities/enhancements.opy#L526), [530](../src/abilities/enhancements.opy#L530), [531](../src/abilities/enhancements.opy#L531), [533](../src/abilities/enhancements.opy#L533), [543](../src/abilities/enhancements.opy#L543).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [555](../src/abilities/enhancements.opy#L555), [558](../src/abilities/enhancements.opy#L558), [565](../src/abilities/enhancements.opy#L565), [567](../src/abilities/enhancements.opy#L567), [568](../src/abilities/enhancements.opy#L568), [576](../src/abilities/enhancements.opy#L576), [578](../src/abilities/enhancements.opy#L578), [581](../src/abilities/enhancements.opy#L581), [582](../src/abilities/enhancements.opy#L582), [583](../src/abilities/enhancements.opy#L583), [586](../src/abilities/enhancements.opy#L586), [598](../src/abilities/enhancements.opy#L598), [602](../src/abilities/enhancements.opy#L602), [603](../src/abilities/enhancements.opy#L603), [604](../src/abilities/enhancements.opy#L604), [605](../src/abilities/enhancements.opy#L605), [615](../src/abilities/enhancements.opy#L615).

## actorTeamSlot25

Объявление: [variables.opy:641](../src/core/variables.opy#L641).

Алиасы: `botCandidateTarget`, `enhancementBarrierPosition`, `enhancementBatteryPlacementCooldown`, `enhancementIsPupFreezeAuraActive`.

- subroutines.opy — def selectTarget(): [682](../src/core/subroutines.opy#L682), [683](../src/core/subroutines.opy#L683), [687](../src/core/subroutines.opy#L687).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/abilities/enhancements.opy#L52), [60](../src/abilities/enhancements.opy#L60), [99](../src/abilities/enhancements.opy#L99), [101](../src/abilities/enhancements.opy#L101), [149](../src/abilities/enhancements.opy#L149), [157](../src/abilities/enhancements.opy#L157).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [198](../src/abilities/enhancements.opy#L198), [200](../src/abilities/enhancements.opy#L200), [202](../src/abilities/enhancements.opy#L202), [207](../src/abilities/enhancements.opy#L207), [208](../src/abilities/enhancements.opy#L208).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [224](../src/abilities/enhancements.opy#L224), [226](../src/abilities/enhancements.opy#L226), [228](../src/abilities/enhancements.opy#L228), [234](../src/abilities/enhancements.opy#L234), [237](../src/abilities/enhancements.opy#L237), [251](../src/abilities/enhancements.opy#L251), [254](../src/abilities/enhancements.opy#L254).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [395](../src/abilities/enhancements.opy#L395), [407](../src/abilities/enhancements.opy#L407), [412](../src/abilities/enhancements.opy#L412), [414](../src/abilities/enhancements.opy#L414).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [545](../src/abilities/enhancements.opy#L545).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [564](../src/abilities/enhancements.opy#L564), [574](../src/abilities/enhancements.opy#L574), [592](../src/abilities/enhancements.opy#L592).

## actorTeamSlot26

Объявление: [variables.opy:651](../src/core/variables.opy#L651).

Алиасы: `botIsTeleportAllowed`, `enhancementBarrierCorner1`, `enhancementPupPosition`.

- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [72](../src/game/bots_game_in_progress.opy#L72), [88](../src/game/bots_game_in_progress.opy#L88).
- bots_game_in_progress.opy — def teleportBots(): [450](../src/game/bots_game_in_progress.opy#L450).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/abilities/enhancements.opy#L52), [54](../src/abilities/enhancements.opy#L54), [58](../src/abilities/enhancements.opy#L58), [136](../src/abilities/enhancements.opy#L136), [138](../src/abilities/enhancements.opy#L138), [143](../src/abilities/enhancements.opy#L143), [145](../src/abilities/enhancements.opy#L145), [147](../src/abilities/enhancements.opy#L147).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [200](../src/abilities/enhancements.opy#L200), [206](../src/abilities/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/abilities/enhancements.opy#L230), [234](../src/abilities/enhancements.opy#L234).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [532](../src/abilities/enhancements.opy#L532), [537](../src/abilities/enhancements.opy#L537), [548](../src/abilities/enhancements.opy#L548).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [558](../src/abilities/enhancements.opy#L558), [565](../src/abilities/enhancements.opy#L565), [600](../src/abilities/enhancements.opy#L600), [604](../src/abilities/enhancements.opy#L604), [613](../src/abilities/enhancements.opy#L613).

## actorTeamSlot27

Объявление: [variables.opy:659](../src/core/variables.opy#L659).

Алиасы: `botReigniteRisePosition`, `enhancementBarrierCorner2`, `enhancementPupCooldown`.

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [423](../src/game/zombie_types.opy#L423), [424](../src/game/zombie_types.opy#L424), [425](../src/game/zombie_types.opy#L425).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/abilities/enhancements.opy#L52), [56](../src/abilities/enhancements.opy#L56), [58](../src/abilities/enhancements.opy#L58), [134](../src/abilities/enhancements.opy#L134), [139](../src/abilities/enhancements.opy#L139), [141](../src/abilities/enhancements.opy#L141).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [202](../src/abilities/enhancements.opy#L202), [206](../src/abilities/enhancements.opy#L206).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [524](../src/abilities/enhancements.opy#L524).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [580](../src/abilities/enhancements.opy#L580), [607](../src/abilities/enhancements.opy#L607).

## actorTeamSlot28

Объявление: [variables.opy:667](../src/core/variables.opy#L667).

Алиасы: `botResourceIconIdList`, `enhancementBarrierHealth`.

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [18](../src/game/players_game_in_progress.opy#L18), [19](../src/game/players_game_in_progress.opy#L19), [21](../src/game/players_game_in_progress.opy#L21), [28](../src/game/players_game_in_progress.opy#L28).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/abilities/enhancements.opy#L48), [54](../src/abilities/enhancements.opy#L54), [56](../src/abilities/enhancements.opy#L56), [58](../src/abilities/enhancements.opy#L58), [60](../src/abilities/enhancements.opy#L60).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [196](../src/abilities/enhancements.opy#L196).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [222](../src/abilities/enhancements.opy#L222), [232](../src/abilities/enhancements.opy#L232), [246](../src/abilities/enhancements.opy#L246), [258](../src/abilities/enhancements.opy#L258), [263](../src/abilities/enhancements.opy#L263), [264](../src/abilities/enhancements.opy#L264), [265](../src/abilities/enhancements.opy#L265).

## team1PositionSlot

Объявление: [variables.opy:673](../src/core/variables.opy#L673).

Алиасы: `pregamePosition`, `rescueStartPosition`, `extractionDestination`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [71](../src/game/global_start_menu.opy#L71), [73](../src/game/global_start_menu.opy#L73), [75](../src/game/global_start_menu.opy#L75).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [26](../src/game/player_start_menu.opy#L26), [28](../src/game/player_start_menu.opy#L28).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/game/player_start_menu.opy#L40), [43](../src/game/player_start_menu.opy#L43), [45](../src/game/player_start_menu.opy#L45), [47](../src/game/player_start_menu.opy#L47), [49](../src/game/player_start_menu.opy#L49), [51](../src/game/player_start_menu.opy#L51), [53](../src/game/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [73](../src/game/player_start_menu.opy#L73), [75](../src/game/player_start_menu.opy#L75), [79](../src/game/player_start_menu.opy#L79).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [225](../src/game/player_start_menu.opy#L225), [229](../src/game/player_start_menu.opy#L229), [231](../src/game/player_start_menu.opy#L231).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [36](../src/objective_types/objective_type_survivor_rescue.opy#L36), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).

## objectiveActorKindSlot

Объявление: [variables.opy:681](../src/core/variables.opy#L681).

Алиасы: `biomorphingResourceType`, `rescueMoodIcon`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [303](../src/core/subroutines.opy#L303), [312](../src/core/subroutines.opy#L312), [315](../src/core/subroutines.opy#L315).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [49](../src/objective_types/objective_type_biomorphing.opy#L49), [74](../src/objective_types/objective_type_biomorphing.opy#L74).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [102](../src/objective_types/objective_type_biomorphing.opy#L102).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [133](../src/objective_types/objective_type_biomorphing.opy#L133).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [164](../src/objective_types/objective_type_biomorphing.opy#L164).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [193](../src/objective_types/objective_type_biomorphing.opy#L193), [196](../src/objective_types/objective_type_biomorphing.opy#L196).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50), [51](../src/objective_types/objective_type_survivor_rescue.opy#L51).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [87](../src/objective_types/objective_type_survivor_rescue.opy#L87), [106](../src/objective_types/objective_type_survivor_rescue.opy#L106).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [179](../src/objective_types/objective_type_survivor_rescue.opy#L179).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/game/players_game_in_progress.opy#L24).
