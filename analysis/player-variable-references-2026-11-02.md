# Обращения к переменным игрока — 2026-11-02

Сгенерировано `node analysis/audit-player-variables.cjs`. Команда правила не доказывает команду получателя поля: учитывайте выражение слева от точки и вызовы подпрограмм. Алиасы собраны в физические слоты.

## botBiteDamage

Объявление: [variables.opy:271](../src/variables.opy#L271).

- subroutines.opy — macro botStatManagementMacro(): [35](../src/subroutines.opy#L35), [37](../src/subroutines.opy#L37).
- subroutines.opy — def explosionSequence(): [777](../src/subroutines.opy#L777), [780](../src/subroutines.opy#L780), [784](../src/subroutines.opy#L784).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [395](../src/bots_game_in_progress.opy#L395).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [152](../src/zombie_types.opy#L152).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [181](../src/zombie_types.opy#L181).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [242](../src/zombie_types.opy#L242).
- zombie_types.opy — rule "CHARGER KNOCKBACK" (event Team 2): [577](../src/zombie_types.opy#L577).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [890](../src/zombie_types.opy#L890), [895](../src/zombie_types.opy#L895).

## botBaseHealth

Объявление: [variables.opy:273](../src/variables.opy#L273).

- subroutines.opy — macro minibossMutationMacro(): [22](../src/subroutines.opy#L22).
- subroutines.opy — macro mutationsMacro(): [93](../src/subroutines.opy#L93), [99](../src/subroutines.opy#L99), [115](../src/subroutines.opy#L115).
- subroutines.opy — def botRespawnInitialization(): [712](../src/subroutines.opy#L712), [717](../src/subroutines.opy#L717), [750](../src/subroutines.opy#L750), [752](../src/subroutines.opy#L752).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [59](../src/objective_types/objective_type_bosses.opy#L59), [60](../src/objective_types/objective_type_bosses.opy#L60), [78](../src/objective_types/objective_type_bosses.opy#L78).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [11](../src/objective_types/objective_type_kill_zone.opy#L11).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [36](../src/objective_types/objective_type_zombie_egg.opy#L36), [37](../src/objective_types/objective_type_zombie_egg.opy#L37).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [50](../src/bots_game_in_progress.opy#L50), [54](../src/bots_game_in_progress.opy#L54).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [81](../src/bots_game_in_progress.opy#L81), [83](../src/bots_game_in_progress.opy#L83).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [130](../src/bots_game_in_progress.opy#L130), [132](../src/bots_game_in_progress.opy#L132).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [412](../src/bots_game_in_progress.opy#L412), [418](../src/bots_game_in_progress.opy#L418).

## isPlayerActive

Объявление: [variables.opy:276](../src/variables.opy#L276).

- subroutines.opy — def setPrematchTimer(): [494](../src/subroutines.opy#L494), [506](../src/subroutines.opy#L506).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [144](../src/global_startup.opy#L144).
- global_start_menu.opy — def determineZombieMode(): [277](../src/global_start_menu.opy#L277).
- global_start_menu.opy — def determineChallenge(): [340](../src/global_start_menu.opy#L340).
- global_start_menu.opy — def determineObjectiveType(): [376](../src/global_start_menu.opy#L376).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [36](../src/player_start_menu.opy#L36).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [83](../src/player_start_menu.opy#L83), [85](../src/player_start_menu.opy#L85).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [68](../src/players_game_in_progress.opy#L68), [78](../src/players_game_in_progress.opy#L78), [84](../src/players_game_in_progress.opy#L84), [94](../src/players_game_in_progress.opy#L94).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [107](../src/players_game_in_progress.opy#L107).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [127](../src/players_game_in_progress.opy#L127).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [149](../src/players_game_in_progress.opy#L149).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [259](../src/players_game_in_progress.opy#L259).

## isReviving

Объявление: [variables.opy:278](../src/variables.opy#L278).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [52](../src/players_game_in_progress.opy#L52).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [119](../src/players_game_in_progress.opy#L119), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/players_game_in_progress.opy#L155), [157](../src/players_game_in_progress.opy#L157), [163](../src/players_game_in_progress.opy#L163), [179](../src/players_game_in_progress.opy#L179), [199](../src/players_game_in_progress.opy#L199).

## reviveDuration

Объявление: [variables.opy:280](../src/variables.opy#L280).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [57](../src/players_game_in_progress.opy#L57), [58](../src/players_game_in_progress.opy#L58), [74](../src/players_game_in_progress.opy#L74).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [176](../src/players_game_in_progress.opy#L176), [177](../src/players_game_in_progress.opy#L177), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## isInfected

Объявление: [variables.opy:282](../src/variables.opy#L282).

- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [39](../src/objective_types/objective_type_extraction_point.opy#L39), [40](../src/objective_types/objective_type_extraction_point.opy#L40).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [55](../src/players_game_in_progress.opy#L55).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/players_game_in_progress.opy#L115).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [134](../src/players_game_in_progress.opy#L134).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [219](../src/players_game_in_progress.opy#L219), [221](../src/players_game_in_progress.opy#L221).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [242](../src/players_game_in_progress.opy#L242), [245](../src/players_game_in_progress.opy#L245).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/bots_game_in_progress.opy#L399), [400](../src/bots_game_in_progress.opy#L400), [401](../src/bots_game_in_progress.opy#L401).
- supply_drops.opy — def powerUpUsage(): [468](../src/supply_drops.opy#L468).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [81](../src/enhancements.opy#L81).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [375](../src/enhancements.opy#L375).

## rescueTimeRemaining

Объявление: [variables.opy:284](../src/variables.opy#L284).

- subroutines.opy — macro botStatManagementMacro(): [47](../src/subroutines.opy#L47).
- global_game_in_progress.opy — rule "OBJECTIVE COMPLETE": [133](../src/global_game_in_progress.opy#L133).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [59](../src/players_game_in_progress.opy#L59), [72](../src/players_game_in_progress.opy#L72), [86](../src/players_game_in_progress.opy#L86).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [150](../src/players_game_in_progress.opy#L150), [154](../src/players_game_in_progress.opy#L154), [160](../src/players_game_in_progress.opy#L160), [161](../src/players_game_in_progress.opy#L161), [165](../src/players_game_in_progress.opy#L165), [166](../src/players_game_in_progress.opy#L166), [168](../src/players_game_in_progress.opy#L168), [171](../src/players_game_in_progress.opy#L171), [182](../src/players_game_in_progress.opy#L182), [184](../src/players_game_in_progress.opy#L184), [201](../src/players_game_in_progress.opy#L201), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## infectionLevel

Объявление: [variables.opy:286](../src/variables.opy#L286).

- subroutines.opy — def explosionSequence(): [777](../src/subroutines.opy#L777).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [38](../src/objective_types/objective_type_extraction_point.opy#L38), [39](../src/objective_types/objective_type_extraction_point.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [60](../src/players_game_in_progress.opy#L60).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [133](../src/players_game_in_progress.opy#L133).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [218](../src/players_game_in_progress.opy#L218), [220](../src/players_game_in_progress.opy#L220).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [244](../src/players_game_in_progress.opy#L244), [246](../src/players_game_in_progress.opy#L246).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/bots_game_in_progress.opy#L399), [400](../src/bots_game_in_progress.opy#L400).
- supply_drops.opy — def powerUpUsage(): [467](../src/supply_drops.opy#L467), [469](../src/supply_drops.opy#L469), [504](../src/supply_drops.opy#L504).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/enhancements.opy#L29), [36](../src/enhancements.opy#L36).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [167](../src/enhancements.opy#L167), [171](../src/enhancements.opy#L171).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [376](../src/enhancements.opy#L376), [378](../src/enhancements.opy#L378), [379](../src/enhancements.opy#L379), [381](../src/enhancements.opy#L381), [382](../src/enhancements.opy#L382).

## invisibilityCount

Объявление: [variables.opy:288](../src/variables.opy#L288).

- subroutines.opy — def selectTarget(): [676](../src/subroutines.opy#L676).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [78](../src/player_start_menu.opy#L78).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [8](../src/objective_types/objective_type_showdown.opy#L8).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [150](../src/objective_types/objective_type_biomorphing.opy#L150).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [83](../src/objective_types/objective_type_survivor_rescue.opy#L83), [89](../src/objective_types/objective_type_survivor_rescue.opy#L89).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS" (event Team 1): [110](../src/objective_types/objective_type_satellite_uplink.opy#L110).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [40](../src/players_game_in_progress.opy#L40).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/players_game_in_progress.opy#L155), [156](../src/players_game_in_progress.opy#L156).
- hero_tuning.opy — rule "SOMBRA USES TRANSLOCATOR" (event Team 1): [22](../src/hero_tuning.opy#L22), [24](../src/hero_tuning.opy#L24).
- hero_tuning.opy — rule "DOOMFIST INVIS WHILE ULTING" (event Team 1): [34](../src/hero_tuning.opy#L34), [36](../src/hero_tuning.opy#L36).
- hero_tuning.opy — rule "MOIRA & VENTURE INVIS WHILE USING SKILL" (event Team 1): [46](../src/hero_tuning.opy#L46), [48](../src/hero_tuning.opy#L48).
- hero_tuning.opy — rule "TRACER INVIS WHILE RECALLING" (event Team 1): [58](../src/hero_tuning.opy#L58), [60](../src/hero_tuning.opy#L60).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [191](../src/bots_game_in_progress.opy#L191).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [241](../src/bots_game_in_progress.opy#L241), [242](../src/bots_game_in_progress.opy#L242).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [268](../src/bots_game_in_progress.opy#L268).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [451](../src/zombie_types.opy#L451).
- supply_drops.opy — def cloakingDevice(): [310](../src/supply_drops.opy#L310), [311](../src/supply_drops.opy#L311), [323](../src/supply_drops.opy#L323), [327](../src/supply_drops.opy#L327).

## infectionDamageOverTimeId

Объявление: [variables.opy:290](../src/variables.opy#L290).

- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [248](../src/players_game_in_progress.opy#L248).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [170](../src/enhancements.opy#L170).

## reconnectUserIndex

Объявление: [variables.opy:292](../src/variables.opy#L292).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [71](../src/players_game_in_progress.opy#L71), [72](../src/players_game_in_progress.opy#L72), [73](../src/players_game_in_progress.opy#L73), [74](../src/players_game_in_progress.opy#L74), [75](../src/players_game_in_progress.opy#L75), [79](../src/players_game_in_progress.opy#L79), [80](../src/players_game_in_progress.opy#L80), [85](../src/players_game_in_progress.opy#L85).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [368](../src/players_game_in_progress.opy#L368), [370](../src/players_game_in_progress.opy#L370).

## isAfk

Объявление: [variables.opy:294](../src/variables.opy#L294).

- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [154](../src/objective_types/objective_type_biomorphing.opy#L154).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [44](../src/players_game_in_progress.opy#L44).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [269](../src/players_game_in_progress.opy#L269), [273](../src/players_game_in_progress.opy#L273), [281](../src/players_game_in_progress.opy#L281), [282](../src/players_game_in_progress.opy#L282).
- players_game_in_progress.opy — rule "PLAYER TARGET (ADD)" (event Team 1): [330](../src/players_game_in_progress.opy#L330).

## isHeroSwitchRespawn

Объявление: [variables.opy:296](../src/variables.opy#L296).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [45](../src/players_game_in_progress.opy#L45).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [111](../src/players_game_in_progress.opy#L111).
- players_game_in_progress.opy — rule "PLAYER SWITCHES HERO" (event Team 1): [301](../src/players_game_in_progress.opy#L301).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [10](../src/enhancements.opy#L10).

## enhancementId

Объявление: [variables.opy:299](../src/variables.opy#L299).

- global_start_menu.opy — rule "EFFECTS/TEXTS": [176](../src/global_start_menu.opy#L176), [189](../src/global_start_menu.opy#L189), [202](../src/global_start_menu.opy#L202), [206](../src/global_start_menu.opy#L206), [207](../src/global_start_menu.opy#L207), [208](../src/global_start_menu.opy#L208).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [15](../src/player_start_menu.opy#L15).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [90](../src/player_start_menu.opy#L90).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)" (event Team 1): [195](../src/player_start_menu.opy#L195), [196](../src/player_start_menu.opy#L196), [197](../src/player_start_menu.opy#L197), [199](../src/player_start_menu.opy#L199), [200](../src/player_start_menu.opy#L200), [201](../src/player_start_menu.opy#L201).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [40](../src/objective_types/objective_type_survivor_rescue.opy#L40).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/players_game_in_progress.opy#L115), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [246](../src/players_game_in_progress.opy#L246), [247](../src/players_game_in_progress.opy#L247).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/bots_game_in_progress.opy#L399).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [12](../src/enhancements.opy#L12), [15](../src/enhancements.opy#L15), [17](../src/enhancements.opy#L17), [26](../src/enhancements.opy#L26), [38](../src/enhancements.opy#L38).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [163](../src/enhancements.opy#L163).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [182](../src/enhancements.opy#L182).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [220](../src/enhancements.opy#L220).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [273](../src/enhancements.opy#L273).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [284](../src/enhancements.opy#L284).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [296](../src/enhancements.opy#L296).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [320](../src/enhancements.opy#L320).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [329](../src/enhancements.opy#L329).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [373](../src/enhancements.opy#L373), [378](../src/enhancements.opy#L378).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [392](../src/enhancements.opy#L392).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [421](../src/enhancements.opy#L421).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [443](../src/enhancements.opy#L443).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [496](../src/enhancements.opy#L496).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [522](../src/enhancements.opy#L522).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [554](../src/enhancements.opy#L554).

## enhancementHitchhikerPassenger

Объявление: [variables.opy:301](../src/variables.opy#L301).

- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [468](../src/enhancements.opy#L468), [475](../src/enhancements.opy#L475).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [485](../src/enhancements.opy#L485), [487](../src/enhancements.opy#L487), [489](../src/enhancements.opy#L489).

## enhancementHitchhikerCarrierPoolId

Объявление: [variables.opy:303](../src/variables.opy#L303).

- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [488](../src/enhancements.opy#L488), [490](../src/enhancements.opy#L490).

## pregameState

Объявление: [variables.opy:307](../src/variables.opy#L307).

- subroutines.opy — def setPrematchTimer(): [492](../src/subroutines.opy#L492), [494](../src/subroutines.opy#L494), [499](../src/subroutines.opy#L499), [502](../src/subroutines.opy#L502), [506](../src/subroutines.opy#L506).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [67](../src/global_start_menu.opy#L67), [69](../src/global_start_menu.opy#L69), [71](../src/global_start_menu.opy#L71), [73](../src/global_start_menu.opy#L73), [75](../src/global_start_menu.opy#L75).
- global_start_menu.opy — rule "END VOTING": [237](../src/global_start_menu.opy#L237).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [19](../src/player_start_menu.opy#L19).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/player_start_menu.opy#L40), [43](../src/player_start_menu.opy#L43), [45](../src/player_start_menu.opy#L45), [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49), [51](../src/player_start_menu.opy#L51).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [61](../src/player_start_menu.opy#L61), [81](../src/player_start_menu.opy#L81).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [100](../src/player_start_menu.opy#L100), [106](../src/player_start_menu.opy#L106), [107](../src/player_start_menu.opy#L107), [108](../src/player_start_menu.opy#L108), [115](../src/player_start_menu.opy#L115), [116](../src/player_start_menu.opy#L116), [118](../src/player_start_menu.opy#L118).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [224](../src/player_start_menu.opy#L224).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [63](../src/players_game_in_progress.opy#L63).

## isPregameVoting

Объявление: [variables.opy:309](../src/variables.opy#L309).

- subroutines.opy — def setPrematchTimer(): [486](../src/subroutines.opy#L486), [492](../src/subroutines.opy#L492), [494](../src/subroutines.opy#L494).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [20](../src/player_start_menu.opy#L20).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [120](../src/player_start_menu.opy#L120).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [136](../src/player_start_menu.opy#L136).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [156](../src/player_start_menu.opy#L156).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [176](../src/player_start_menu.opy#L176).
- player_start_menu.opy — rule "UPDATE PREGAME VOTING STATUS" (event Team 1): [208](../src/player_start_menu.opy#L208), [215](../src/player_start_menu.opy#L215).

## rescueLeader

Объявление: [variables.opy:312](../src/variables.opy#L312).

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [38](../src/objective_types/objective_type_survivor_rescue.opy#L38), [53](../src/objective_types/objective_type_survivor_rescue.opy#L53), [61](../src/objective_types/objective_type_survivor_rescue.opy#L61), [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [91](../src/objective_types/objective_type_survivor_rescue.opy#L91), [103](../src/objective_types/objective_type_survivor_rescue.opy#L103).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [117](../src/objective_types/objective_type_survivor_rescue.opy#L117), [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [120](../src/objective_types/objective_type_survivor_rescue.opy#L120), [122](../src/objective_types/objective_type_survivor_rescue.opy#L122).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [143](../src/objective_types/objective_type_survivor_rescue.opy#L143), [144](../src/objective_types/objective_type_survivor_rescue.opy#L144), [146](../src/objective_types/objective_type_survivor_rescue.opy#L146).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [151](../src/objective_types/objective_type_survivor_rescue.opy#L151), [154](../src/objective_types/objective_type_survivor_rescue.opy#L154), [155](../src/objective_types/objective_type_survivor_rescue.opy#L155).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [19](../src/bots_game_in_progress.opy#L19), [22](../src/bots_game_in_progress.opy#L22).

## biomorphingResourceAmount

Объявление: [variables.opy:315](../src/variables.opy#L315).

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [303](../src/subroutines.opy#L303), [306](../src/subroutines.opy#L306), [315](../src/subroutines.opy#L315), [318](../src/subroutines.opy#L318).
- subroutines.opy — def objectivesManagement(): [612](../src/subroutines.opy#L612).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [48](../src/objective_types/objective_type_biomorphing.opy#L48), [75](../src/objective_types/objective_type_biomorphing.opy#L75).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [83](../src/objective_types/objective_type_biomorphing.opy#L83), [92](../src/objective_types/objective_type_biomorphing.opy#L92), [99](../src/objective_types/objective_type_biomorphing.opy#L99).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [119](../src/objective_types/objective_type_biomorphing.opy#L119), [140](../src/objective_types/objective_type_biomorphing.opy#L140).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [151](../src/objective_types/objective_type_biomorphing.opy#L151), [170](../src/objective_types/objective_type_biomorphing.opy#L170), [180](../src/objective_types/objective_type_biomorphing.opy#L180).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [190](../src/objective_types/objective_type_biomorphing.opy#L190), [195](../src/objective_types/objective_type_biomorphing.opy#L195).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).

## explosionInnerColor

Объявление: [variables.opy:318](../src/variables.opy#L318).

- subroutines.opy — macro botEntityManagementMacro(): [135](../src/subroutines.opy#L135).
- subroutines.opy — def explosionSequence(): [788](../src/subroutines.opy#L788).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [32](../src/enhancements.opy#L32).

## explosionOuterColor

Объявление: [variables.opy:320](../src/variables.opy#L320).

- subroutines.opy — macro botEntityManagementMacro(): [136](../src/subroutines.opy#L136).
- subroutines.opy — def explosionSequence(): [787](../src/subroutines.opy#L787).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [33](../src/enhancements.opy#L33).

## explosionScale

Объявление: [variables.opy:322](../src/variables.opy#L322).

- subroutines.opy — def explosionSequence(): [775](../src/subroutines.opy#L775), [787](../src/subroutines.opy#L787), [788](../src/subroutines.opy#L788), [790](../src/subroutines.opy#L790), [792](../src/subroutines.opy#L792).
- zombie_types.opy — def explosionWarning(): [1475](../src/zombie_types.opy#L1475).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [31](../src/enhancements.opy#L31).

## aiThrottleSpeedSlot

Объявление: [variables.opy:325](../src/variables.opy#L325).

Алиасы: `botThrottleSpeed`, `rescueThrottleSpeed`.

- subroutines.opy — macro botStatManagementMacro(): [40](../src/subroutines.opy#L40).
- subroutines.opy — def restoreDefaultFacingMovement(): [700](../src/subroutines.opy#L700), [702](../src/subroutines.opy#L702).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [57](../src/objective_types/objective_type_bosses.opy#L57).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [88](../src/objective_types/objective_type_survivor_rescue.opy#L88).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [118](../src/objective_types/objective_type_survivor_rescue.opy#L118).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [165](../src/objective_types/objective_type_survivor_rescue.opy#L165).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [272](../src/bots_game_in_progress.opy#L272).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [289](../src/bots_game_in_progress.opy#L289), [293](../src/bots_game_in_progress.opy#L293).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [313](../src/bots_game_in_progress.opy#L313).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [334](../src/bots_game_in_progress.opy#L334).
- bots_game_in_progress.opy — def enterExitTeleport(): [434](../src/bots_game_in_progress.opy#L434), [436](../src/bots_game_in_progress.opy#L436).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [552](../src/zombie_types.opy#L552).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [771](../src/zombie_types.opy#L771), [779](../src/zombie_types.opy#L779).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [880](../src/zombie_types.opy#L880).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1080](../src/zombie_types.opy#L1080).

## recoveryTimeSlot

Объявление: [variables.opy:331](../src/variables.opy#L331).

Алиасы: `reviveTimeRemaining`, `botRespawnDelay`.

- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [150](../src/objective_types/objective_type_bosses.opy#L150), [161](../src/objective_types/objective_type_bosses.opy#L161).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [10](../src/objective_types/objective_type_kill_zone.opy#L10), [15](../src/objective_types/objective_type_kill_zone.opy#L15).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [71](../src/objective_types/objective_type_zombie_egg.opy#L71).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [62](../src/objective_types/objective_type_satellite_uplink.opy#L62), [65](../src/objective_types/objective_type_satellite_uplink.opy#L65).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [58](../src/players_game_in_progress.opy#L58), [73](../src/players_game_in_progress.opy#L73).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [159](../src/players_game_in_progress.opy#L159), [175](../src/players_game_in_progress.opy#L175), [177](../src/players_game_in_progress.opy#L177), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [66](../src/bots_game_in_progress.opy#L66).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [149](../src/bots_game_in_progress.opy#L149), [150](../src/bots_game_in_progress.opy#L150), [151](../src/bots_game_in_progress.opy#L151), [153](../src/bots_game_in_progress.opy#L153).
- supply_drops.opy — def airStrike(): [226](../src/supply_drops.opy#L226).

## isCrowdControlled

Объявление: [variables.opy:337](../src/variables.opy#L337).

- subroutines.opy — def restoreDefaultFacingMovement(): [698](../src/subroutines.opy#L698).
- subroutines.opy — def botRespawnInitialization(): [729](../src/subroutines.opy#L729).
- subroutines.opy — def abilityPlacement(): [760](../src/subroutines.opy#L760).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [98](../src/bots_game_in_progress.opy#L98).
- bots_game_in_progress.opy — rule "BOT STUN MANAGEMENT" (event Team 2): [209](../src/bots_game_in_progress.opy#L209), [213](../src/bots_game_in_progress.opy#L213).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [274](../src/bots_game_in_progress.opy#L274).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [286](../src/bots_game_in_progress.opy#L286).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [305](../src/bots_game_in_progress.opy#L305).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [328](../src/bots_game_in_progress.opy#L328).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [358](../src/bots_game_in_progress.opy#L358), [375](../src/bots_game_in_progress.opy#L375).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [408](../src/bots_game_in_progress.opy#L408).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [24](../src/zombie_types.opy#L24).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [70](../src/zombie_types.opy#L70).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [87](../src/zombie_types.opy#L87).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [105](../src/zombie_types.opy#L105), [114](../src/zombie_types.opy#L114), [125](../src/zombie_types.opy#L125), [127](../src/zombie_types.opy#L127).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/zombie_types.opy#L196), [201](../src/zombie_types.opy#L201).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [264](../src/zombie_types.opy#L264).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [348](../src/zombie_types.opy#L348), [355](../src/zombie_types.opy#L355).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [411](../src/zombie_types.opy#L411).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [451](../src/zombie_types.opy#L451).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [504](../src/zombie_types.opy#L504).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [527](../src/zombie_types.opy#L527), [541](../src/zombie_types.opy#L541), [546](../src/zombie_types.opy#L546).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [589](../src/zombie_types.opy#L589), [604](../src/zombie_types.opy#L604), [613](../src/zombie_types.opy#L613).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [643](../src/zombie_types.opy#L643), [667](../src/zombie_types.opy#L667), [668](../src/zombie_types.opy#L668).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [704](../src/zombie_types.opy#L704), [727](../src/zombie_types.opy#L727).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [761](../src/zombie_types.opy#L761), [769](../src/zombie_types.opy#L769), [778](../src/zombie_types.opy#L778), [788](../src/zombie_types.opy#L788).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [824](../src/zombie_types.opy#L824), [830](../src/zombie_types.opy#L830), [853](../src/zombie_types.opy#L853).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [906](../src/zombie_types.opy#L906).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [929](../src/zombie_types.opy#L929), [950](../src/zombie_types.opy#L950).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1006](../src/zombie_types.opy#L1006), [1013](../src/zombie_types.opy#L1013), [1024](../src/zombie_types.opy#L1024), [1027](../src/zombie_types.opy#L1027), [1050](../src/zombie_types.opy#L1050).
- zombie_types.opy — rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)" (event Team 2): [1089](../src/zombie_types.opy#L1089).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1131](../src/zombie_types.opy#L1131).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1170](../src/zombie_types.opy#L1170).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1232](../src/zombie_types.opy#L1232).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1254](../src/zombie_types.opy#L1254), [1269](../src/zombie_types.opy#L1269).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1282](../src/zombie_types.opy#L1282).
- zombie_types.opy — rule "PROTECTOR (KIRIKO) USES CLEANSE" (event Team 2): [1352](../src/zombie_types.opy#L1352).
- zombie_types.opy — def abilityThrowdown(): [1454](../src/zombie_types.opy#L1454).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [450](../src/enhancements.opy#L450).

## actorCountdownSlot

Объявление: [variables.opy:339](../src/variables.opy#L339).

Алиасы: `powerUpNoCooldownsTimeRemaining`, `botChargerWindupProgress`.

- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [545](../src/zombie_types.opy#L545).
- supply_drops.opy — def noCooldowns(): [172](../src/supply_drops.opy#L172), [175](../src/supply_drops.opy#L175).

## controlStateSlot

Объявление: [variables.opy:345](../src/variables.opy#L345).

Алиасы: `isCrowdControlCooldownActive`, `botReturnTarget`.

- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203), [206](../src/objective_types/objective_type_bosses.opy#L206), [210](../src/objective_types/objective_type_bosses.opy#L210).
- hero_tuning.opy — rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE" (event Team 1): [7](../src/hero_tuning.opy#L7), [11](../src/hero_tuning.opy#L11).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [300](../src/zombie_types.opy#L300), [302](../src/zombie_types.opy#L302).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [933](../src/zombie_types.opy#L933), [939](../src/zombie_types.opy#L939).

## actorMotionSlot1

Объявление: [variables.opy:351](../src/variables.opy#L351).

Алиасы: `botGasProjectilePosition`, `botTentaclePosition`, `botBlasterCharge`, `botDaytakerCharge`, `botSmolderAnger`, `botEnsnarerMeleeAngle`, `rescueExtractionPosition`.

- subroutines.opy — macro botStatManagementMacro(): [63](../src/subroutines.opy#L63).
- subroutines.opy — macro botEntityManagementMacro(): [142](../src/subroutines.opy#L142), [145](../src/subroutines.opy#L145), [163](../src/subroutines.opy#L163), [166](../src/subroutines.opy#L166), [169](../src/subroutines.opy#L169), [197](../src/subroutines.opy#L197), [204](../src/subroutines.opy#L204), [208](../src/subroutines.opy#L208).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [185](../src/objective_types/objective_type_survivor_rescue.opy#L185), [187](../src/objective_types/objective_type_survivor_rescue.opy#L187), [189](../src/objective_types/objective_type_survivor_rescue.opy#L189), [191](../src/objective_types/objective_type_survivor_rescue.opy#L191).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [366](../src/bots_game_in_progress.opy#L366), [367](../src/bots_game_in_progress.opy#L367), [368](../src/bots_game_in_progress.opy#L368), [380](../src/bots_game_in_progress.opy#L380).
- zombie_types.opy — macro smolderEnragedMacro(): [12](../src/zombie_types.opy#L12).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [202](../src/zombie_types.opy#L202), [205](../src/zombie_types.opy#L205), [213](../src/zombie_types.opy#L213), [215](../src/zombie_types.opy#L215), [219](../src/zombie_types.opy#L219), [220](../src/zombie_types.opy#L220).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [599](../src/zombie_types.opy#L599), [602](../src/zombie_types.opy#L602), [604](../src/zombie_types.opy#L604), [605](../src/zombie_types.opy#L605), [606](../src/zombie_types.opy#L606), [610](../src/zombie_types.opy#L610), [612](../src/zombie_types.opy#L612), [621](../src/zombie_types.opy#L621), [624](../src/zombie_types.opy#L624).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [831](../src/zombie_types.opy#L831), [834](../src/zombie_types.opy#L834), [835](../src/zombie_types.opy#L835), [836](../src/zombie_types.opy#L836), [839](../src/zombie_types.opy#L839), [845](../src/zombie_types.opy#L845), [847](../src/zombie_types.opy#L847).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1014](../src/zombie_types.opy#L1014), [1016](../src/zombie_types.opy#L1016), [1024](../src/zombie_types.opy#L1024), [1026](../src/zombie_types.opy#L1026), [1029](../src/zombie_types.opy#L1029), [1030](../src/zombie_types.opy#L1030), [1036](../src/zombie_types.opy#L1036), [1042](../src/zombie_types.opy#L1042), [1043](../src/zombie_types.opy#L1043).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1214](../src/zombie_types.opy#L1214), [1215](../src/zombie_types.opy#L1215), [1218](../src/zombie_types.opy#L1218).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1235](../src/zombie_types.opy#L1235).
- zombie_types.opy — def spawnGasCloud(): [1498](../src/zombie_types.opy#L1498), [1500](../src/zombie_types.opy#L1500), [1501](../src/zombie_types.opy#L1501).

## actorMotionSlot2

Объявление: [variables.opy:367](../src/variables.opy#L367).

Алиасы: `botGasCloudTimeRemaining`, `extractionFlightPosition`.

- subroutines.opy — macro botEntityManagementMacro(): [159](../src/subroutines.opy#L159).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [56](../src/objective_types/objective_type_extraction_point.opy#L56), [57](../src/objective_types/objective_type_extraction_point.opy#L57), [58](../src/objective_types/objective_type_extraction_point.opy#L58), [60](../src/objective_types/objective_type_extraction_point.opy#L60), [62](../src/objective_types/objective_type_extraction_point.opy#L62), [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [170](../src/zombie_types.opy#L170), [172](../src/zombie_types.opy#L172), [173](../src/zombie_types.opy#L173), [188](../src/zombie_types.opy#L188), [189](../src/zombie_types.opy#L189).

## actorAbilitySlot2

Объявление: [variables.opy:373](../src/variables.opy#L373).

Алиасы: `botAuxiliaryState`, `rescueFollowMessage`, `botIsReigniteActive`, `botIsEnsnarerMeleeActive`.

- subroutines.opy — def botRespawnInitialization(): [731](../src/subroutines.opy#L731).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [155](../src/objective_types/objective_type_survivor_rescue.opy#L155), [158](../src/objective_types/objective_type_survivor_rescue.opy#L158).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [364](../src/bots_game_in_progress.opy#L364), [382](../src/bots_game_in_progress.opy#L382).
- zombie_types.opy — rule "REIGNITED USES ULTIMATE NEAR PLAYER" (event Team 2): [396](../src/zombie_types.opy#L396), [398](../src/zombie_types.opy#L398).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [409](../src/zombie_types.opy#L409), [421](../src/zombie_types.opy#L421).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [960](../src/zombie_types.opy#L960).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1157](../src/zombie_types.opy#L1157).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1192](../src/zombie_types.opy#L1192).

## initialMaxHealth

Объявление: [variables.opy:383](../src/variables.opy#L383).

- subroutines.opy — def botRespawnInitialization(): [713](../src/subroutines.opy#L713).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [39](../src/players_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [79](../src/bots_game_in_progress.opy#L79), [81](../src/bots_game_in_progress.opy#L81).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [21](../src/enhancements.opy#L21).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [466](../src/enhancements.opy#L466).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [487](../src/enhancements.opy#L487).

## isAttached

Объявление: [variables.opy:385](../src/variables.opy#L385).

Алиасы: `botIsAttached`, `enhancementIsHitchhiking`.

- subroutines.opy — def restoreDefaultFacingMovement(): [698](../src/subroutines.opy#L698).
- subroutines.opy — def botRespawnInitialization(): [725](../src/subroutines.opy#L725).
- subroutines.opy — def illariUlt(): [800](../src/subroutines.opy#L800).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [37](../src/objective_types/objective_type_bosses.opy#L37), [38](../src/objective_types/objective_type_bosses.opy#L38).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [43](../src/players_game_in_progress.opy#L43).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [260](../src/players_game_in_progress.opy#L260).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [97](../src/bots_game_in_progress.opy#L97).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [186](../src/bots_game_in_progress.opy#L186).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [304](../src/bots_game_in_progress.opy#L304).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [327](../src/bots_game_in_progress.opy#L327).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [409](../src/bots_game_in_progress.opy#L409).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/zombie_types.opy#L196).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [437](../src/zombie_types.opy#L437), [440](../src/zombie_types.opy#L440).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [449](../src/zombie_types.opy#L449), [454](../src/zombie_types.opy#L454).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [463](../src/zombie_types.opy#L463), [472](../src/zombie_types.opy#L472).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [479](../src/zombie_types.opy#L479), [485](../src/zombie_types.opy#L485).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [494](../src/zombie_types.opy#L494).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [541](../src/zombie_types.opy#L541).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1021](../src/zombie_types.opy#L1021), [1032](../src/zombie_types.opy#L1032), [1039](../src/zombie_types.opy#L1039), [1048](../src/zombie_types.opy#L1048), [1055](../src/zombie_types.opy#L1055).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/enhancements.opy#L117), [119](../src/enhancements.opy#L119), [121](../src/enhancements.opy#L121).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/enhancements.opy#L444), [447](../src/enhancements.opy#L447), [448](../src/enhancements.opy#L448), [463](../src/enhancements.opy#L463), [476](../src/enhancements.opy#L476).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [497](../src/enhancements.opy#L497).

## candidateTargetList

Объявление: [variables.opy:391](../src/variables.opy#L391).

Алиасы: `botPotentialTargetList`, `rescuePotentialLeaderList`, `enhancementBarrierTargetList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [295](../src/subroutines.opy#L295).
- subroutines.opy — def selectTarget(): [678](../src/subroutines.opy#L678).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [70](../src/objective_types/objective_type_bosses.opy#L70).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [104](../src/objective_types/objective_type_survivor_rescue.opy#L104).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [152](../src/objective_types/objective_type_survivor_rescue.opy#L152), [154](../src/objective_types/objective_type_survivor_rescue.opy#L154).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [136](../src/players_game_in_progress.opy#L136).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [140](../src/bots_game_in_progress.opy#L140).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [234](../src/enhancements.opy#L234), [240](../src/enhancements.opy#L240), [243](../src/enhancements.opy#L243).

## sizeScale

Объявление: [variables.opy:399](../src/variables.opy#L399).

- subroutines.opy — macro minibossMutationMacro(): [23](../src/subroutines.opy#L23).
- subroutines.opy — macro botStatManagementMacro(): [62](../src/subroutines.opy#L62), [64](../src/subroutines.opy#L64), [68](../src/subroutines.opy#L68).
- subroutines.opy — macro mutationsMacro(): [92](../src/subroutines.opy#L92), [93](../src/subroutines.opy#L93), [98](../src/subroutines.opy#L98), [99](../src/subroutines.opy#L99).
- subroutines.opy — macro botEntityManagementMacro(): [142](../src/subroutines.opy#L142), [145](../src/subroutines.opy#L145), [159](../src/subroutines.opy#L159), [163](../src/subroutines.opy#L163), [174](../src/subroutines.opy#L174), [179](../src/subroutines.opy#L179), [190](../src/subroutines.opy#L190), [193](../src/subroutines.opy#L193), [197](../src/subroutines.opy#L197), [204](../src/subroutines.opy#L204), [208](../src/subroutines.opy#L208).
- subroutines.opy — def restoreDefaultFacingMovement(): [700](../src/subroutines.opy#L700).
- subroutines.opy — def botRespawnInitialization(): [716](../src/subroutines.opy#L716), [719](../src/subroutines.opy#L719), [748](../src/subroutines.opy#L748).
- subroutines.opy — def explosionSequence(): [780](../src/subroutines.opy#L780).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [61](../src/objective_types/objective_type_bosses.opy#L61), [62](../src/objective_types/objective_type_bosses.opy#L62), [64](../src/objective_types/objective_type_bosses.opy#L64).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [38](../src/objective_types/objective_type_zombie_egg.opy#L38), [39](../src/objective_types/objective_type_zombie_egg.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [62](../src/players_game_in_progress.opy#L62).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [102](../src/bots_game_in_progress.opy#L102).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [337](../src/bots_game_in_progress.opy#L337).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [360](../src/bots_game_in_progress.opy#L360).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [51](../src/zombie_types.opy#L51).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [73](../src/zombie_types.opy#L73).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [181](../src/zombie_types.opy#L181), [203](../src/zombie_types.opy#L203), [205](../src/zombie_types.opy#L205).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [239](../src/zombie_types.opy#L239), [240](../src/zombie_types.opy#L240).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [256](../src/zombie_types.opy#L256), [266](../src/zombie_types.opy#L266), [267](../src/zombie_types.opy#L267), [268](../src/zombie_types.opy#L268), [269](../src/zombie_types.opy#L269).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [276](../src/zombie_types.opy#L276).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [299](../src/zombie_types.opy#L299).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [317](../src/zombie_types.opy#L317).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [336](../src/zombie_types.opy#L336), [357](../src/zombie_types.opy#L357).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [383](../src/zombie_types.opy#L383).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [442](../src/zombie_types.opy#L442).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [466](../src/zombie_types.opy#L466), [471](../src/zombie_types.opy#L471).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [592](../src/zombie_types.opy#L592), [599](../src/zombie_types.opy#L599), [600](../src/zombie_types.opy#L600), [612](../src/zombie_types.opy#L612), [618](../src/zombie_types.opy#L618), [621](../src/zombie_types.opy#L621).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [657](../src/zombie_types.opy#L657), [662](../src/zombie_types.opy#L662).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [708](../src/zombie_types.opy#L708), [722](../src/zombie_types.opy#L722), [723](../src/zombie_types.opy#L723).
- zombie_types.opy — rule "STRIKER NORMAL PILE DRIVER" (event Team 2): [753](../src/zombie_types.opy#L753).
- zombie_types.opy — rule "STALKER KNOCKBACK BLAST (BOSS)" (event Team 2): [814](../src/zombie_types.opy#L814).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [911](../src/zombie_types.opy#L911), [915](../src/zombie_types.opy#L915).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [930](../src/zombie_types.opy#L930), [947](../src/zombie_types.opy#L947), [950](../src/zombie_types.opy#L950).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [992](../src/zombie_types.opy#L992), [993](../src/zombie_types.opy#L993).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1008](../src/zombie_types.opy#L1008), [1018](../src/zombie_types.opy#L1018), [1022](../src/zombie_types.opy#L1022), [1062](../src/zombie_types.opy#L1062), [1064](../src/zombie_types.opy#L1064), [1066](../src/zombie_types.opy#L1066).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1106](../src/zombie_types.opy#L1106), [1107](../src/zombie_types.opy#L1107).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1118](../src/zombie_types.opy#L1118).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1135](../src/zombie_types.opy#L1135), [1142](../src/zombie_types.opy#L1142).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1155](../src/zombie_types.opy#L1155).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1189](../src/zombie_types.opy#L1189).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1205](../src/zombie_types.opy#L1205), [1220](../src/zombie_types.opy#L1220).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1257](../src/zombie_types.opy#L1257).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1288](../src/zombie_types.opy#L1288), [1290](../src/zombie_types.opy#L1290), [1291](../src/zombie_types.opy#L1291), [1296](../src/zombie_types.opy#L1296).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1389](../src/zombie_types.opy#L1389).
- zombie_types.opy — def abilityThrowdown(): [1457](../src/zombie_types.opy#L1457).
- zombie_types.opy — def entityFloat(): [1465](../src/zombie_types.opy#L1465).
- zombie_types.opy — def explosionWarning(): [1474](../src/zombie_types.opy#L1474), [1475](../src/zombie_types.opy#L1475).
- zombie_types.opy — def smolderBoost(): [1487](../src/zombie_types.opy#L1487), [1491](../src/zombie_types.opy#L1491), [1492](../src/zombie_types.opy#L1492).
- zombie_types.opy — def spawnGasCloud(): [1500](../src/zombie_types.opy#L1500).
- supply_drops.opy — def stun(): [437](../src/supply_drops.opy#L437).
- supply_drops.opy — def powerUpUsage(): [529](../src/supply_drops.opy#L529).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/enhancements.opy#L117), [149](../src/enhancements.opy#L149).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [278](../src/enhancements.opy#L278).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [423](../src/enhancements.opy#L423).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/enhancements.opy#L444), [448](../src/enhancements.opy#L448), [450](../src/enhancements.opy#L450), [453](../src/enhancements.opy#L453), [470](../src/enhancements.opy#L470).

## actorAbilitySlot1

Объявление: [variables.opy:401](../src/variables.opy#L401).

Алиасы: `botAbilityState`, `rescueIsExtracting`, `botIsBomberPrimed`, `botRusherHealthPoolId`, `botGasAimPosition`, `botIsReigniteAttackUsed`, `botRiderGrapplePosition`, `botChargerDestination`, `botTentacleTargetPosition`, `botIsStrikerStrikeActive`, `botIsDownfallenGrabbing`, `botIsEnsnarerBlocking`, `botSmolderState`.

- subroutines.opy — macro botEntityManagementMacro(): [163](../src/subroutines.opy#L163), [166](../src/subroutines.opy#L166), [169](../src/subroutines.opy#L169), [179](../src/subroutines.opy#L179), [208](../src/subroutines.opy#L208).
- subroutines.opy — def botRespawnInitialization(): [730](../src/subroutines.opy#L730).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [37](../src/objective_types/objective_type_survivor_rescue.opy#L37), [46](../src/objective_types/objective_type_survivor_rescue.opy#L46), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [80](../src/objective_types/objective_type_survivor_rescue.opy#L80).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [183](../src/objective_types/objective_type_survivor_rescue.opy#L183).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [120](../src/bots_game_in_progress.opy#L120), [123](../src/bots_game_in_progress.opy#L123).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [363](../src/bots_game_in_progress.opy#L363).
- zombie_types.opy — macro smolderEnragedMacro(): [11](../src/zombie_types.opy#L11).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [76](../src/zombie_types.opy#L76).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [120](../src/zombie_types.opy#L120), [140](../src/zombie_types.opy#L140).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [203](../src/zombie_types.opy#L203), [205](../src/zombie_types.opy#L205), [213](../src/zombie_types.opy#L213), [215](../src/zombie_types.opy#L215).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [377](../src/zombie_types.opy#L377), [379](../src/zombie_types.opy#L379), [386](../src/zombie_types.opy#L386).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [502](../src/zombie_types.opy#L502), [505](../src/zombie_types.opy#L505), [511](../src/zombie_types.opy#L511).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [552](../src/zombie_types.opy#L552).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [588](../src/zombie_types.opy#L588), [600](../src/zombie_types.opy#L600), [602](../src/zombie_types.opy#L602), [604](../src/zombie_types.opy#L604), [607](../src/zombie_types.opy#L607), [623](../src/zombie_types.opy#L623).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [641](../src/zombie_types.opy#L641).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [714](../src/zombie_types.opy#L714), [729](../src/zombie_types.opy#L729).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [907](../src/zombie_types.opy#L907).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [932](../src/zombie_types.opy#L932), [938](../src/zombie_types.opy#L938), [965](../src/zombie_types.opy#L965).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1162](../src/zombie_types.opy#L1162), [1174](../src/zombie_types.opy#L1174).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1193](../src/zombie_types.opy#L1193).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1204](../src/zombie_types.opy#L1204), [1212](../src/zombie_types.opy#L1212), [1215](../src/zombie_types.opy#L1215), [1216](../src/zombie_types.opy#L1216).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1231](../src/zombie_types.opy#L1231), [1234](../src/zombie_types.opy#L1234).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1251](../src/zombie_types.opy#L1251), [1266](../src/zombie_types.opy#L1266), [1273](../src/zombie_types.opy#L1273).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1281](../src/zombie_types.opy#L1281).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1303](../src/zombie_types.opy#L1303).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT" (event Team 2): [1340](../src/zombie_types.opy#L1340).
- zombie_types.opy — def explosionWarning(): [1479](../src/zombie_types.opy#L1479).

## objectiveTypeSnapshot

Объявление: [variables.opy:429](../src/variables.opy#L429).

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/players_game_in_progress.opy#L8), [9](../src/players_game_in_progress.opy#L9), [22](../src/players_game_in_progress.opy#L22).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/players_game_in_progress.opy#L321).

## visualEntityIdList

Объявление: [variables.opy:431](../src/variables.opy#L431).

Алиасы: `botVisualEntityIdList`, `playerObjectiveIconIdList`.

- subroutines.opy — macro minibossMutationMacro(): [28](../src/subroutines.opy#L28).
- subroutines.opy — macro botEntityManagementMacro(): [132](../src/subroutines.opy#L132), [133](../src/subroutines.opy#L133), [137](../src/subroutines.opy#L137), [143](../src/subroutines.opy#L143), [146](../src/subroutines.opy#L146), [153](../src/subroutines.opy#L153), [156](../src/subroutines.opy#L156), [160](../src/subroutines.opy#L160), [164](../src/subroutines.opy#L164), [167](../src/subroutines.opy#L167), [170](../src/subroutines.opy#L170), [175](../src/subroutines.opy#L175), [180](../src/subroutines.opy#L180), [191](../src/subroutines.opy#L191), [194](../src/subroutines.opy#L194), [198](../src/subroutines.opy#L198), [201](../src/subroutines.opy#L201), [205](../src/subroutines.opy#L205), [209](../src/subroutines.opy#L209), [214](../src/subroutines.opy#L214), [217](../src/subroutines.opy#L217), [221](../src/subroutines.opy#L221).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/players_game_in_progress.opy#L12), [13](../src/players_game_in_progress.opy#L13), [15](../src/players_game_in_progress.opy#L15), [26](../src/players_game_in_progress.opy#L26).

## visualCleanupIndex

Объявление: [variables.opy:437](../src/variables.opy#L437).

- subroutines.opy — macro botEntityManagementMacro(): [132](../src/subroutines.opy#L132), [133](../src/subroutines.opy#L133).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/players_game_in_progress.opy#L12), [13](../src/players_game_in_progress.opy#L13), [18](../src/players_game_in_progress.opy#L18), [19](../src/players_game_in_progress.opy#L19).

## actorLoopSlot

Объявление: [variables.opy:439](../src/variables.opy#L439).

Алиасы: `botEnsnarerUltimateIndex`, `powerUpBouncePadTimeRemaining`.

- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [369](../src/bots_game_in_progress.opy#L369).
- supply_drops.opy — def bouncePad(): [377](../src/supply_drops.opy#L377), [383](../src/supply_drops.opy#L383), [384](../src/supply_drops.opy#L384).

## abilityTargetList

Объявление: [variables.opy:445](../src/variables.opy#L445).

Алиасы: `botSpecialTargetList`, `explosionTargetList`.

- subroutines.opy — def explosionSequence(): [775](../src/subroutines.opy#L775), [777](../src/subroutines.opy#L777), [780](../src/subroutines.opy#L780), [782](../src/subroutines.opy#L782), [784](../src/subroutines.opy#L784).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [49](../src/zombie_types.opy#L49), [50](../src/zombie_types.opy#L50).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [235](../src/zombie_types.opy#L235), [241](../src/zombie_types.opy#L241), [242](../src/zombie_types.opy#L242), [243](../src/zombie_types.opy#L243).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [679](../src/zombie_types.opy#L679), [680](../src/zombie_types.opy#L680).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1164](../src/zombie_types.opy#L1164), [1165](../src/zombie_types.opy#L1165).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1290](../src/zombie_types.opy#L1290), [1291](../src/zombie_types.opy#L1291), [1294](../src/zombie_types.opy#L1294), [1295](../src/zombie_types.opy#L1295).
- zombie_types.opy — def entityFloat(): [1465](../src/zombie_types.opy#L1465).

## movementSpeedScale

Объявление: [variables.opy:451](../src/variables.opy#L451).

- subroutines.opy — macro botStatManagementMacro(): [46](../src/subroutines.opy#L46), [47](../src/subroutines.opy#L47).
- subroutines.opy — macro mutationsMacro(): [85](../src/subroutines.opy#L85), [86](../src/subroutines.opy#L86), [112](../src/subroutines.opy#L112), [113](../src/subroutines.opy#L113).
- subroutines.opy — macro botEntityManagementMacro(): [185](../src/subroutines.opy#L185).
- subroutines.opy — def illariUlt(): [806](../src/subroutines.opy#L806), [807](../src/subroutines.opy#L807), [816](../src/subroutines.opy#L816), [817](../src/subroutines.opy#L817).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [39](../src/objective_types/objective_type_survivor_rescue.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [41](../src/players_game_in_progress.opy#L41), [42](../src/players_game_in_progress.opy#L42).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [289](../src/bots_game_in_progress.opy#L289).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [313](../src/bots_game_in_progress.opy#L313).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [334](../src/bots_game_in_progress.opy#L334).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [361](../src/bots_game_in_progress.opy#L361).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [780](../src/zombie_types.opy#L780), [781](../src/zombie_types.opy#L781), [786](../src/zombie_types.opy#L786), [787](../src/zombie_types.opy#L787).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1210](../src/zombie_types.opy#L1210), [1211](../src/zombie_types.opy#L1211).
- zombie_types.opy — def smolderBoost(): [1493](../src/zombie_types.opy#L1493), [1494](../src/zombie_types.opy#L1494).
- supply_drops.opy — def cloakingDevice(): [304](../src/supply_drops.opy#L304), [305](../src/supply_drops.opy#L305), [329](../src/supply_drops.opy#L329), [330](../src/supply_drops.opy#L330).
- supply_drops.opy — def superNano(): [337](../src/supply_drops.opy#L337), [338](../src/supply_drops.opy#L338), [366](../src/supply_drops.opy#L366), [367](../src/supply_drops.opy#L367).

## damageOverTimeRemaining

Объявление: [variables.opy:453](../src/variables.opy#L453).

- subroutines.opy — def explosionSequence(): [785](../src/subroutines.opy#L785), [786](../src/subroutines.opy#L786).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [74](../src/bots_game_in_progress.opy#L74).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [157](../src/bots_game_in_progress.opy#L157).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [396](../src/bots_game_in_progress.opy#L396), [397](../src/bots_game_in_progress.opy#L397).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [154](../src/zombie_types.opy#L154), [155](../src/zombie_types.opy#L155).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [182](../src/zombie_types.opy#L182), [183](../src/zombie_types.opy#L183).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [243](../src/zombie_types.opy#L243), [244](../src/zombie_types.opy#L244).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [892](../src/zombie_types.opy#L892), [893](../src/zombie_types.opy#L893), [897](../src/zombie_types.opy#L897), [898](../src/zombie_types.opy#L898).

## actorTeamSlot0

Объявление: [variables.opy:455](../src/variables.opy#L455).

Алиасы: `botTeleportCenter`, `powerUpForceFieldTimeRemaining`.

- objective_types/objective_type_bosses.opy — def bossReturn(): [206](../src/objective_types/objective_type_bosses.opy#L206).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [70](../src/objective_types/objective_type_zombie_egg.opy#L70).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [13](../src/bots_game_in_progress.opy#L13), [16](../src/bots_game_in_progress.opy#L16), [20](../src/bots_game_in_progress.opy#L20), [22](../src/bots_game_in_progress.opy#L22), [28](../src/bots_game_in_progress.opy#L28), [36](../src/bots_game_in_progress.opy#L36), [39](../src/bots_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [197](../src/bots_game_in_progress.opy#L197).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [228](../src/bots_game_in_progress.opy#L228).
- bots_game_in_progress.opy — def teleportBots(): [460](../src/bots_game_in_progress.opy#L460), [470](../src/bots_game_in_progress.opy#L470).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [491](../src/bots_game_in_progress.opy#L491), [496](../src/bots_game_in_progress.opy#L496), [500](../src/bots_game_in_progress.opy#L500), [501](../src/bots_game_in_progress.opy#L501).
- supply_drops.opy — def playerForceField(): [149](../src/supply_drops.opy#L149), [154](../src/supply_drops.opy#L154).

## actorTeamSlot1

Объявление: [variables.opy:461](../src/variables.opy#L461).

Алиасы: `botIsSelectingTarget`, `powerUpReviveTarget`.

- subroutines.opy — def selectTarget(): [658](../src/subroutines.opy#L658), [690](../src/subroutines.opy#L690).
- subroutines.opy — def botRespawnInitialization(): [733](../src/subroutines.opy#L733).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [187](../src/bots_game_in_progress.opy#L187).
- supply_drops.opy — def instantRevive(): [133](../src/supply_drops.opy#L133), [135](../src/supply_drops.opy#L135), [136](../src/supply_drops.opy#L136), [137](../src/supply_drops.opy#L137), [139](../src/supply_drops.opy#L139).

## actorTeamSlot2

Объявление: [variables.opy:467](../src/variables.opy#L467).

Алиасы: `botReturnTime`, `botReturnPosition`, `powerUpItemId`.

- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED" (event Team 2): [186](../src/objective_types/objective_type_bosses.opy#L186), [187](../src/objective_types/objective_type_bosses.opy#L187), [188](../src/objective_types/objective_type_bosses.opy#L188), [190](../src/objective_types/objective_type_bosses.opy#L190), [191](../src/objective_types/objective_type_bosses.opy#L191).
- objective_types/objective_type_bosses.opy — def bossReturn(): [200](../src/objective_types/objective_type_bosses.opy#L200), [202](../src/objective_types/objective_type_bosses.opy#L202), [209](../src/objective_types/objective_type_bosses.opy#L209).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [106](../src/supply_drops.opy#L106), [112](../src/supply_drops.opy#L112), [125](../src/supply_drops.opy#L125).
- supply_drops.opy — def powerUpUsage(): [462](../src/supply_drops.opy#L462), [535](../src/supply_drops.opy#L535).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [34](../src/power_ups.opy#L34).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)" (event Team 1): [81](../src/power_ups.opy#L81), [84](../src/power_ups.opy#L84), [87](../src/power_ups.opy#L87).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)" (event Team 1): [94](../src/power_ups.opy#L94), [98](../src/power_ups.opy#L98), [101](../src/power_ups.opy#L101).

## actorTeamSlot3

Объявление: [variables.opy:475](../src/variables.opy#L475).

Алиасы: `botIsTeleporting`, `powerUpTradeDataList`, `pregameVoteList`, `rescuePathList`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [82](../src/global_start_menu.opy#L82), [90](../src/global_start_menu.opy#L90), [98](../src/global_start_menu.opy#L98), [99](../src/global_start_menu.opy#L99), [102](../src/global_start_menu.opy#L102), [103](../src/global_start_menu.opy#L103), [104](../src/global_start_menu.opy#L104), [110](../src/global_start_menu.opy#L110), [119](../src/global_start_menu.opy#L119), [128](../src/global_start_menu.opy#L128), [129](../src/global_start_menu.opy#L129), [132](../src/global_start_menu.opy#L132), [133](../src/global_start_menu.opy#L133), [134](../src/global_start_menu.opy#L134), [140](../src/global_start_menu.opy#L140), [152](../src/global_start_menu.opy#L152), [164](../src/global_start_menu.opy#L164), [165](../src/global_start_menu.opy#L165), [168](../src/global_start_menu.opy#L168), [169](../src/global_start_menu.opy#L169), [170](../src/global_start_menu.opy#L170).
- global_start_menu.opy — rule "END VOTING": [246](../src/global_start_menu.opy#L246), [247](../src/global_start_menu.opy#L247), [248](../src/global_start_menu.opy#L248).
- global_start_menu.opy — def determineZombieMode(): [277](../src/global_start_menu.opy#L277).
- global_start_menu.opy — def determineChallenge(): [340](../src/global_start_menu.opy#L340), [352](../src/global_start_menu.opy#L352).
- global_start_menu.opy — def determineObjectiveType(): [376](../src/global_start_menu.opy#L376).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [18](../src/player_start_menu.opy#L18), [23](../src/player_start_menu.opy#L23), [24](../src/player_start_menu.opy#L24), [25](../src/player_start_menu.opy#L25).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [90](../src/player_start_menu.opy#L90).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [138](../src/player_start_menu.opy#L138), [139](../src/player_start_menu.opy#L139), [140](../src/player_start_menu.opy#L140), [142](../src/player_start_menu.opy#L142), [143](../src/player_start_menu.opy#L143), [144](../src/player_start_menu.opy#L144).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [158](../src/player_start_menu.opy#L158), [159](../src/player_start_menu.opy#L159), [160](../src/player_start_menu.opy#L160), [162](../src/player_start_menu.opy#L162), [163](../src/player_start_menu.opy#L163), [164](../src/player_start_menu.opy#L164).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [178](../src/player_start_menu.opy#L178), [179](../src/player_start_menu.opy#L179), [180](../src/player_start_menu.opy#L180), [182](../src/player_start_menu.opy#L182), [183](../src/player_start_menu.opy#L183), [184](../src/player_start_menu.opy#L184).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [10](../src/objective_types/objective_type_bosses.opy#L10), [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [35](../src/objective_types/objective_type_survivor_rescue.opy#L35), [60](../src/objective_types/objective_type_survivor_rescue.opy#L60), [62](../src/objective_types/objective_type_survivor_rescue.opy#L62).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [120](../src/objective_types/objective_type_survivor_rescue.opy#L120), [122](../src/objective_types/objective_type_survivor_rescue.opy#L122).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [130](../src/objective_types/objective_type_survivor_rescue.opy#L130), [134](../src/objective_types/objective_type_survivor_rescue.opy#L134), [135](../src/objective_types/objective_type_survivor_rescue.opy#L135).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [156](../src/objective_types/objective_type_survivor_rescue.opy#L156).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [184](../src/objective_types/objective_type_survivor_rescue.opy#L184).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [8](../src/objective_types/objective_type_zombie_egg.opy#L8), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [59](../src/objective_types/objective_type_zombie_egg.opy#L59).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [42](../src/objective_types/objective_type_satellite_uplink.opy#L42), [46](../src/objective_types/objective_type_satellite_uplink.opy#L46), [49](../src/objective_types/objective_type_satellite_uplink.opy#L49).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [49](../src/bots_game_in_progress.opy#L49).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [95](../src/bots_game_in_progress.opy#L95).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [163](../src/bots_game_in_progress.opy#L163).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [184](../src/bots_game_in_progress.opy#L184).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [220](../src/bots_game_in_progress.opy#L220).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [237](../src/bots_game_in_progress.opy#L237).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [266](../src/bots_game_in_progress.opy#L266).
- bots_game_in_progress.opy — def enterExitTeleport(): [424](../src/bots_game_in_progress.opy#L424).
- bots_game_in_progress.opy — def teleportBots(): [446](../src/bots_game_in_progress.opy#L446), [452](../src/bots_game_in_progress.opy#L452), [474](../src/bots_game_in_progress.opy#L474), [483](../src/bots_game_in_progress.opy#L483).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [462](../src/zombie_types.opy#L462), [466](../src/zombie_types.opy#L466), [470](../src/zombie_types.opy#L470).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [482](../src/zombie_types.opy#L482).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [104](../src/supply_drops.opy#L104), [106](../src/supply_drops.opy#L106), [109](../src/supply_drops.opy#L109), [122](../src/supply_drops.opy#L122), [123](../src/supply_drops.opy#L123), [124](../src/supply_drops.opy#L124).
- supply_drops.opy — def sentryTurret(): [274](../src/supply_drops.opy#L274), [282](../src/supply_drops.opy#L282).
- supply_drops.opy — def stun(): [453](../src/supply_drops.opy#L453).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [531](../src/enhancements.opy#L531).

## actorTeamSlot4

Объявление: [variables.opy:485](../src/variables.opy#L485).

Алиасы: `botStalkerFadeIndex`, `botEnsnarerTargetIndex`, `powerUpEntityIdList`.

- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [772](../src/zombie_types.opy#L772), [777](../src/zombie_types.opy#L777).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1164](../src/zombie_types.opy#L1164), [1165](../src/zombie_types.opy#L1165).
- supply_drops.opy — def playerForceField(): [146](../src/supply_drops.opy#L146), [148](../src/supply_drops.opy#L148), [150](../src/supply_drops.opy#L150), [161](../src/supply_drops.opy#L161), [162](../src/supply_drops.opy#L162).
- supply_drops.opy — def noCooldowns(): [171](../src/supply_drops.opy#L171), [173](../src/supply_drops.opy#L173), [191](../src/supply_drops.opy#L191), [192](../src/supply_drops.opy#L192).
- supply_drops.opy — def airStrike(): [202](../src/supply_drops.opy#L202), [204](../src/supply_drops.opy#L204), [206](../src/supply_drops.opy#L206), [228](../src/supply_drops.opy#L228), [229](../src/supply_drops.opy#L229), [230](../src/supply_drops.opy#L230).
- supply_drops.opy — def healBeacon(): [237](../src/supply_drops.opy#L237), [239](../src/supply_drops.opy#L239), [241](../src/supply_drops.opy#L241), [243](../src/supply_drops.opy#L243), [245](../src/supply_drops.opy#L245), [254](../src/supply_drops.opy#L254), [255](../src/supply_drops.opy#L255), [256](../src/supply_drops.opy#L256), [257](../src/supply_drops.opy#L257).
- supply_drops.opy — def sentryTurret(): [266](../src/supply_drops.opy#L266), [268](../src/supply_drops.opy#L268), [273](../src/supply_drops.opy#L273), [275](../src/supply_drops.opy#L275), [277](../src/supply_drops.opy#L277), [295](../src/supply_drops.opy#L295), [296](../src/supply_drops.opy#L296).
- supply_drops.opy — def cloakingDevice(): [303](../src/supply_drops.opy#L303), [307](../src/supply_drops.opy#L307), [309](../src/supply_drops.opy#L309), [324](../src/supply_drops.opy#L324), [325](../src/supply_drops.opy#L325), [326](../src/supply_drops.opy#L326).
- supply_drops.opy — def superNano(): [336](../src/supply_drops.opy#L336), [340](../src/supply_drops.opy#L340), [342](../src/supply_drops.opy#L342), [344](../src/supply_drops.opy#L344), [346](../src/supply_drops.opy#L346), [348](../src/supply_drops.opy#L348), [358](../src/supply_drops.opy#L358), [359](../src/supply_drops.opy#L359), [360](../src/supply_drops.opy#L360), [361](../src/supply_drops.opy#L361), [362](../src/supply_drops.opy#L362), [365](../src/supply_drops.opy#L365).
- supply_drops.opy — def bouncePad(): [374](../src/supply_drops.opy#L374), [376](../src/supply_drops.opy#L376), [378](../src/supply_drops.opy#L378), [403](../src/supply_drops.opy#L403), [404](../src/supply_drops.opy#L404), [405](../src/supply_drops.opy#L405).
- supply_drops.opy — def ultimateCharger(): [411](../src/supply_drops.opy#L411), [413](../src/supply_drops.opy#L413), [420](../src/supply_drops.opy#L420), [421](../src/supply_drops.opy#L421).
- supply_drops.opy — def stun(): [427](../src/supply_drops.opy#L427), [430](../src/supply_drops.opy#L430), [455](../src/supply_drops.opy#L455), [456](../src/supply_drops.opy#L456).

## actorTeamSlot5

Объявление: [variables.opy:493](../src/variables.opy#L493).

Алиасы: `botTarget`, `powerUpAirStrikeIndex`.

- subroutines.opy — macro botEntityManagementMacro(): [200](../src/subroutines.opy#L200).
- subroutines.opy — def selectTarget(): [687](../src/subroutines.opy#L687), [688](../src/subroutines.opy#L688).
- subroutines.opy — def restoreDefaultFacingMovement(): [696](../src/subroutines.opy#L696), [698](../src/subroutines.opy#L698), [700](../src/subroutines.opy#L700).
- global_game_in_progress.opy — rule "TRIGGER OVERTIME MUSIC": [54](../src/global_game_in_progress.opy#L54), [60](../src/global_game_in_progress.opy#L60), [62](../src/global_game_in_progress.opy#L62).
- global_game_in_progress.opy — rule "SWARM SHOOTOUT" (event Team 2): [84](../src/global_game_in_progress.opy#L84).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [10](../src/objective_types/objective_type_bosses.opy#L10), [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [76](../src/objective_types/objective_type_bosses.opy#L76), [78](../src/objective_types/objective_type_bosses.opy#L78).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [92](../src/objective_types/objective_type_bosses.opy#L92).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [142](../src/objective_types/objective_type_bosses.opy#L142).
- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED" (event Team 2): [187](../src/objective_types/objective_type_bosses.opy#L187), [188](../src/objective_types/objective_type_bosses.opy#L188), [192](../src/objective_types/objective_type_bosses.opy#L192).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [8](../src/objective_types/objective_type_zombie_egg.opy#L8), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [135](../src/players_game_in_progress.opy#L135).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [76](../src/bots_game_in_progress.opy#L76).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [104](../src/bots_game_in_progress.opy#L104).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [139](../src/bots_game_in_progress.opy#L139).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [188](../src/bots_game_in_progress.opy#L188).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [219](../src/bots_game_in_progress.opy#L219).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [241](../src/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "BOT TAKES DAMAGE AND SWITCHES TARGETS" (event Team 2): [254](../src/bots_game_in_progress.opy#L254), [255](../src/bots_game_in_progress.opy#L255).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [267](../src/bots_game_in_progress.opy#L267), [268](../src/bots_game_in_progress.opy#L268), [270](../src/bots_game_in_progress.opy#L270).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [283](../src/bots_game_in_progress.opy#L283).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [311](../src/bots_game_in_progress.opy#L311).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [324](../src/bots_game_in_progress.opy#L324).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [357](../src/bots_game_in_progress.opy#L357), [360](../src/bots_game_in_progress.opy#L360), [361](../src/bots_game_in_progress.opy#L361), [367](../src/bots_game_in_progress.opy#L367).
- bots_game_in_progress.opy — def enterExitTeleport(): [432](../src/bots_game_in_progress.opy#L432), [437](../src/bots_game_in_progress.opy#L437).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [23](../src/zombie_types.opy#L23), [27](../src/zombie_types.opy#L27).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [69](../src/zombie_types.opy#L69), [73](../src/zombie_types.opy#L73).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [86](../src/zombie_types.opy#L86), [92](../src/zombie_types.opy#L92).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [104](../src/zombie_types.opy#L104), [109](../src/zombie_types.opy#L109).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [162](../src/zombie_types.opy#L162), [196](../src/zombie_types.opy#L196).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [254](../src/zombie_types.opy#L254), [256](../src/zombie_types.opy#L256).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [275](../src/zombie_types.opy#L275), [276](../src/zombie_types.opy#L276).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [315](../src/zombie_types.opy#L315), [317](../src/zombie_types.opy#L317), [318](../src/zombie_types.opy#L318).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [335](../src/zombie_types.opy#L335), [336](../src/zombie_types.opy#L336), [343](../src/zombie_types.opy#L343), [355](../src/zombie_types.opy#L355), [357](../src/zombie_types.opy#L357).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [436](../src/zombie_types.opy#L436).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [467](../src/zombie_types.opy#L467).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [480](../src/zombie_types.opy#L480), [482](../src/zombie_types.opy#L482).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [493](../src/zombie_types.opy#L493), [495](../src/zombie_types.opy#L495), [497](../src/zombie_types.opy#L497), [498](../src/zombie_types.opy#L498), [499](../src/zombie_types.opy#L499), [502](../src/zombie_types.opy#L502), [511](../src/zombie_types.opy#L511).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [526](../src/zombie_types.opy#L526), [533](../src/zombie_types.opy#L533), [534](../src/zombie_types.opy#L534), [552](../src/zombie_types.opy#L552).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [587](../src/zombie_types.opy#L587), [592](../src/zombie_types.opy#L592), [593](../src/zombie_types.opy#L593), [631](../src/zombie_types.opy#L631).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [640](../src/zombie_types.opy#L640), [646](../src/zombie_types.opy#L646), [667](../src/zombie_types.opy#L667), [668](../src/zombie_types.opy#L668).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [703](../src/zombie_types.opy#L703), [708](../src/zombie_types.opy#L708), [709](../src/zombie_types.opy#L709), [723](../src/zombie_types.opy#L723).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [760](../src/zombie_types.opy#L760), [764](../src/zombie_types.opy#L764).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [823](../src/zombie_types.opy#L823), [830](../src/zombie_types.opy#L830), [834](../src/zombie_types.opy#L834), [880](../src/zombie_types.opy#L880).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [905](../src/zombie_types.opy#L905), [910](../src/zombie_types.opy#L910), [911](../src/zombie_types.opy#L911), [913](../src/zombie_types.opy#L913), [915](../src/zombie_types.opy#L915).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [928](../src/zombie_types.opy#L928), [930](../src/zombie_types.opy#L930), [933](../src/zombie_types.opy#L933), [937](../src/zombie_types.opy#L937).
- zombie_types.opy — rule "DOWNFALLEN PULLS PLAYERS" (event Team 2): [975](../src/zombie_types.opy#L975), [976](../src/zombie_types.opy#L976).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [988](../src/zombie_types.opy#L988), [991](../src/zombie_types.opy#L991), [992](../src/zombie_types.opy#L992), [993](../src/zombie_types.opy#L993).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1005](../src/zombie_types.opy#L1005), [1013](../src/zombie_types.opy#L1013), [1023](../src/zombie_types.opy#L1023), [1063](../src/zombie_types.opy#L1063), [1064](../src/zombie_types.opy#L1064), [1073](../src/zombie_types.opy#L1073), [1080](../src/zombie_types.opy#L1080).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1102](../src/zombie_types.opy#L1102), [1105](../src/zombie_types.opy#L1105), [1106](../src/zombie_types.opy#L1106), [1107](../src/zombie_types.opy#L1107), [1108](../src/zombie_types.opy#L1108).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1118](../src/zombie_types.opy#L1118).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1130](../src/zombie_types.opy#L1130), [1135](../src/zombie_types.opy#L1135).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1155](../src/zombie_types.opy#L1155), [1156](../src/zombie_types.opy#L1156), [1178](../src/zombie_types.opy#L1178).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1189](../src/zombie_types.opy#L1189), [1190](../src/zombie_types.opy#L1190), [1191](../src/zombie_types.opy#L1191).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1203](../src/zombie_types.opy#L1203), [1205](../src/zombie_types.opy#L1205).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1239](../src/zombie_types.opy#L1239).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1257](../src/zombie_types.opy#L1257).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS" (event Team 2): [1317](../src/zombie_types.opy#L1317).
- zombie_types.opy — rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE" (event Team 2): [1363](../src/zombie_types.opy#L1363), [1364](../src/zombie_types.opy#L1364).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1385](../src/zombie_types.opy#L1385), [1388](../src/zombie_types.opy#L1388), [1389](../src/zombie_types.opy#L1389).
- zombie_types.opy — def abilityThrowdown(): [1457](../src/zombie_types.opy#L1457).
- supply_drops.opy — def airStrike(): [209](../src/supply_drops.opy#L209).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [527](../src/enhancements.opy#L527), [530](../src/enhancements.opy#L530).

## actorTeamSlot6

Объявление: [variables.opy:499](../src/variables.opy#L499).

Алиасы: `botBiteDuration`, `powerUpHealBeaconTimeRemaining`.

- subroutines.opy — macro botStatManagementMacro(): [38](../src/subroutines.opy#L38).
- subroutines.opy — macro mutationsMacro(): [104](../src/subroutines.opy#L104).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [395](../src/bots_game_in_progress.opy#L395), [396](../src/bots_game_in_progress.opy#L396), [397](../src/bots_game_in_progress.opy#L397).
- supply_drops.opy — def healBeacon(): [242](../src/supply_drops.opy#L242), [250](../src/supply_drops.opy#L250).

## actorTeamSlot7

Объявление: [variables.opy:505](../src/variables.opy#L505).

Алиасы: `botIsTeleportConfirmed`, `powerUpTurretTimeRemaining`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [60](../src/objective_types/objective_type_zombie_egg.opy#L60), [67](../src/objective_types/objective_type_zombie_egg.opy#L67).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [162](../src/bots_game_in_progress.opy#L162).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [193](../src/bots_game_in_progress.opy#L193), [198](../src/bots_game_in_progress.opy#L198).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [221](../src/bots_game_in_progress.opy#L221), [226](../src/bots_game_in_progress.opy#L226), [227](../src/bots_game_in_progress.opy#L227).
- bots_game_in_progress.opy — def teleportBots(): [449](../src/bots_game_in_progress.opy#L449).
- bots_game_in_progress.opy — def successfulTeleportStatus(): [508](../src/bots_game_in_progress.opy#L508), [509](../src/bots_game_in_progress.opy#L509).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/bots_game_in_progress.opy#L515), [519](../src/bots_game_in_progress.opy#L519).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [934](../src/zombie_types.opy#L934).
- supply_drops.opy — def sentryTurret(): [276](../src/supply_drops.opy#L276), [281](../src/supply_drops.opy#L281).

## actorTeamSlot8

Объявление: [variables.opy:511](../src/variables.opy#L511).

Алиасы: `botReigniteDestination`, `powerUpCloakTimeRemaining`.

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [413](../src/zombie_types.opy#L413), [422](../src/zombie_types.opy#L422), [423](../src/zombie_types.opy#L423), [425](../src/zombie_types.opy#L425), [427](../src/zombie_types.opy#L427).
- supply_drops.opy — def cloakingDevice(): [308](../src/supply_drops.opy#L308), [316](../src/supply_drops.opy#L316), [317](../src/supply_drops.opy#L317), [322](../src/supply_drops.opy#L322).

## actorTeamSlot9

Объявление: [variables.opy:517](../src/variables.opy#L517).

Алиасы: `botIsWallPhaseAllowed`, `powerUpSuperNanoTimeRemaining`.

- subroutines.opy — def botRespawnInitialization(): [728](../src/subroutines.opy#L728).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [91](../src/objective_types/objective_type_bosses.opy#L91).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [326](../src/bots_game_in_progress.opy#L326).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [342](../src/zombie_types.opy#L342).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [537](../src/zombie_types.opy#L537), [565](../src/zombie_types.opy#L565).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [715](../src/zombie_types.opy#L715), [730](../src/zombie_types.opy#L730).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [773](../src/zombie_types.opy#L773), [798](../src/zombie_types.opy#L798), [803](../src/zombie_types.opy#L803).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [944](../src/zombie_types.opy#L944), [963](../src/zombie_types.opy#L963).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1058](../src/zombie_types.opy#L1058), [1076](../src/zombie_types.opy#L1076).
- supply_drops.opy — def superNano(): [341](../src/supply_drops.opy#L341), [353](../src/supply_drops.opy#L353).

## actorTeamSlot10

Объявление: [variables.opy:523](../src/variables.opy#L523).

Алиасы: `botAbilityTarget`, `powerUpUltimateTimeRemaining`.

- subroutines.opy — def botRespawnInitialization(): [732](../src/subroutines.opy#L732).
- subroutines.opy — def illariUlt(): [799](../src/subroutines.opy#L799), [800](../src/subroutines.opy#L800), [801](../src/subroutines.opy#L801).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [50](../src/zombie_types.opy#L50), [51](../src/zombie_types.opy#L51), [53](../src/zombie_types.opy#L53), [56](../src/zombie_types.opy#L56).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [441](../src/zombie_types.opy#L441), [442](../src/zombie_types.opy#L442).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [450](../src/zombie_types.opy#L450), [451](../src/zombie_types.opy#L451), [453](../src/zombie_types.opy#L453).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [470](../src/zombie_types.opy#L470), [471](../src/zombie_types.opy#L471).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [481](../src/zombie_types.opy#L481), [482](../src/zombie_types.opy#L482), [484](../src/zombie_types.opy#L484).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [598](../src/zombie_types.opy#L598), [606](../src/zombie_types.opy#L606), [607](../src/zombie_types.opy#L607), [613](../src/zombie_types.opy#L613), [615](../src/zombie_types.opy#L615), [616](../src/zombie_types.opy#L616), [617](../src/zombie_types.opy#L617), [618](../src/zombie_types.opy#L618), [620](../src/zombie_types.opy#L620).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [680](../src/zombie_types.opy#L680), [681](../src/zombie_types.opy#L681), [683](../src/zombie_types.opy#L683), [686](../src/zombie_types.opy#L686).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [937](../src/zombie_types.opy#L937), [939](../src/zombie_types.opy#L939), [943](../src/zombie_types.opy#L943), [946](../src/zombie_types.opy#L946), [950](../src/zombie_types.opy#L950), [951](../src/zombie_types.opy#L951), [952](../src/zombie_types.opy#L952), [955](../src/zombie_types.opy#L955), [956](../src/zombie_types.opy#L956), [957](../src/zombie_types.opy#L957), [958](../src/zombie_types.opy#L958), [966](../src/zombie_types.opy#L966).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1018](../src/zombie_types.opy#L1018), [1019](../src/zombie_types.opy#L1019), [1021](../src/zombie_types.opy#L1021), [1022](../src/zombie_types.opy#L1022), [1031](../src/zombie_types.opy#L1031), [1032](../src/zombie_types.opy#L1032), [1039](../src/zombie_types.opy#L1039), [1048](../src/zombie_types.opy#L1048), [1053](../src/zombie_types.opy#L1053), [1054](../src/zombie_types.opy#L1054), [1055](../src/zombie_types.opy#L1055), [1062](../src/zombie_types.opy#L1062), [1064](../src/zombie_types.opy#L1064), [1066](../src/zombie_types.opy#L1066), [1067](../src/zombie_types.opy#L1067).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1295](../src/zombie_types.opy#L1295), [1296](../src/zombie_types.opy#L1296).
- supply_drops.opy — def ultimateCharger(): [412](../src/supply_drops.opy#L412), [416](../src/supply_drops.opy#L416).

## actorTeamSlot11

Объявление: [variables.opy:529](../src/variables.opy#L529).

Алиасы: `botTeleportPosition`, `powerUpStunBouncesRemaining`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [69](../src/objective_types/objective_type_zombie_egg.opy#L69), [70](../src/objective_types/objective_type_zombie_egg.opy#L70), [73](../src/objective_types/objective_type_zombie_egg.opy#L73).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [161](../src/bots_game_in_progress.opy#L161).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [228](../src/bots_game_in_progress.opy#L228).
- bots_game_in_progress.opy — def enterExitTeleport(): [433](../src/bots_game_in_progress.opy#L433), [434](../src/bots_game_in_progress.opy#L434).
- bots_game_in_progress.opy — def teleportBots(): [455](../src/bots_game_in_progress.opy#L455), [457](../src/bots_game_in_progress.opy#L457), [466](../src/bots_game_in_progress.opy#L466), [467](../src/bots_game_in_progress.opy#L467), [470](../src/bots_game_in_progress.opy#L470), [472](../src/bots_game_in_progress.opy#L472), [473](../src/bots_game_in_progress.opy#L473), [476](../src/bots_game_in_progress.opy#L476), [477](../src/bots_game_in_progress.opy#L477), [478](../src/bots_game_in_progress.opy#L478), [479](../src/bots_game_in_progress.opy#L479).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/bots_game_in_progress.opy#L515), [516](../src/bots_game_in_progress.opy#L516), [519](../src/bots_game_in_progress.opy#L519), [520](../src/bots_game_in_progress.opy#L520), [521](../src/bots_game_in_progress.opy#L521), [522](../src/bots_game_in_progress.opy#L522).
- supply_drops.opy — def stun(): [440](../src/supply_drops.opy#L440), [442](../src/supply_drops.opy#L442), [443](../src/supply_drops.opy#L443).

## actorTeamSlot12

Объявление: [variables.opy:535](../src/variables.opy#L535).

Алиасы: `botBossHealth`, `powerUpStunBeamPosition`.

- subroutines.opy — def botRespawnInitialization(): [734](../src/subroutines.opy#L734).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [60](../src/objective_types/objective_type_bosses.opy#L60).
- objective_types/objective_type_bosses.opy — rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)" (event Team 2): [114](../src/objective_types/objective_type_bosses.opy#L114), [115](../src/objective_types/objective_type_bosses.opy#L115).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [127](../src/objective_types/objective_type_bosses.opy#L127), [129](../src/objective_types/objective_type_bosses.opy#L129), [130](../src/objective_types/objective_type_bosses.opy#L130), [141](../src/objective_types/objective_type_bosses.opy#L141), [154](../src/objective_types/objective_type_bosses.opy#L154), [157](../src/objective_types/objective_type_bosses.opy#L157).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [37](../src/objective_types/objective_type_zombie_egg.opy#L37).
- supply_drops.opy — def stun(): [429](../src/supply_drops.opy#L429), [433](../src/supply_drops.opy#L433), [438](../src/supply_drops.opy#L438), [445](../src/supply_drops.opy#L445), [454](../src/supply_drops.opy#L454).

## actorTeamSlot13

Объявление: [variables.opy:541](../src/variables.opy#L541).

Алиасы: `botIsWallCollisionEnabled`, `powerUpTurretPosition`.

- subroutines.opy — def botRespawnInitialization(): [723](../src/subroutines.opy#L723).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [69](../src/objective_types/objective_type_bosses.opy#L69), [83](../src/objective_types/objective_type_bosses.opy#L83).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [90](../src/objective_types/objective_type_bosses.opy#L90), [98](../src/objective_types/objective_type_bosses.opy#L98), [102](../src/objective_types/objective_type_bosses.opy#L102).
- objective_types/objective_type_bosses.opy — rule "BOSS TAKES KNOCKBACK" (event Team 2): [173](../src/objective_types/objective_type_bosses.opy#L173), [177](../src/objective_types/objective_type_bosses.opy#L177).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [41](../src/objective_types/objective_type_zombie_egg.opy#L41), [42](../src/objective_types/objective_type_zombie_egg.opy#L42).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [325](../src/bots_game_in_progress.opy#L325), [341](../src/bots_game_in_progress.opy#L341), [349](../src/bots_game_in_progress.opy#L349).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [539](../src/zombie_types.opy#L539).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [653](../src/zombie_types.opy#L653), [672](../src/zombie_types.opy#L672).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [716](../src/zombie_types.opy#L716).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [762](../src/zombie_types.opy#L762), [774](../src/zombie_types.opy#L774).
- supply_drops.opy — def sentryTurret(): [265](../src/supply_drops.opy#L265), [267](../src/supply_drops.opy#L267), [272](../src/supply_drops.opy#L272), [274](../src/supply_drops.opy#L274), [278](../src/supply_drops.opy#L278), [279](../src/supply_drops.opy#L279), [282](../src/supply_drops.opy#L282), [283](../src/supply_drops.opy#L283), [286](../src/supply_drops.opy#L286), [287](../src/supply_drops.opy#L287), [288](../src/supply_drops.opy#L288), [290](../src/supply_drops.opy#L290), [297](../src/supply_drops.opy#L297).

## actorTeamSlot14

Объявление: [variables.opy:547](../src/variables.opy#L547).

Алиасы: `botIsFacingOverridden`, `powerUpStunTarget`.

- subroutines.opy — def restoreDefaultFacingMovement(): [697](../src/subroutines.opy#L697).
- subroutines.opy — def botRespawnInitialization(): [726](../src/subroutines.opy#L726).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [273](../src/bots_game_in_progress.opy#L273).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [285](../src/bots_game_in_progress.opy#L285).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [365](../src/bots_game_in_progress.opy#L365), [378](../src/bots_game_in_progress.opy#L378).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [43](../src/zombie_types.opy#L43), [59](../src/zombie_types.opy#L59).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [124](../src/zombie_types.opy#L124), [136](../src/zombie_types.opy#L136).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [195](../src/zombie_types.opy#L195), [206](../src/zombie_types.opy#L206).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [340](../src/zombie_types.opy#L340), [359](../src/zombie_types.opy#L359), [366](../src/zombie_types.opy#L366).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [501](../src/zombie_types.opy#L501), [509](../src/zombie_types.opy#L509).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [540](../src/zombie_types.opy#L540), [547](../src/zombie_types.opy#L547), [553](../src/zombie_types.opy#L553), [562](../src/zombie_types.opy#L562).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [665](../src/zombie_types.opy#L665), [689](../src/zombie_types.opy#L689).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [767](../src/zombie_types.opy#L767), [801](../src/zombie_types.opy#L801).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [829](../src/zombie_types.opy#L829), [841](../src/zombie_types.opy#L841), [850](../src/zombie_types.opy#L850), [878](../src/zombie_types.opy#L878).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1012](../src/zombie_types.opy#L1012), [1038](../src/zombie_types.opy#L1038), [1047](../src/zombie_types.opy#L1047), [1078](../src/zombie_types.opy#L1078).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1161](../src/zombie_types.opy#L1161), [1172](../src/zombie_types.opy#L1172).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1395](../src/zombie_types.opy#L1395), [1403](../src/zombie_types.opy#L1403).
- supply_drops.opy — def stun(): [437](../src/supply_drops.opy#L437), [438](../src/supply_drops.opy#L438), [441](../src/supply_drops.opy#L441), [445](../src/supply_drops.opy#L445), [446](../src/supply_drops.opy#L446), [447](../src/supply_drops.opy#L447), [448](../src/supply_drops.opy#L448), [451](../src/supply_drops.opy#L451), [453](../src/supply_drops.opy#L453).

## actorTeamSlot15

Объявление: [variables.opy:553](../src/variables.opy#L553).

Алиасы: `botIsThrottleOverridden`, `powerUpHealBeaconPosition`.

- subroutines.opy — def restoreDefaultFacingMovement(): [699](../src/subroutines.opy#L699).
- subroutines.opy — def botRespawnInitialization(): [727](../src/subroutines.opy#L727).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [32](../src/objective_types/objective_type_zombie_egg.opy#L32).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [96](../src/bots_game_in_progress.opy#L96).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [271](../src/bots_game_in_progress.opy#L271).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [284](../src/bots_game_in_progress.opy#L284).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [303](../src/bots_game_in_progress.opy#L303).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [41](../src/zombie_types.opy#L41), [58](../src/zombie_types.opy#L58).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [121](../src/zombie_types.opy#L121), [137](../src/zombie_types.opy#L137).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [193](../src/zombie_types.opy#L193), [207](../src/zombie_types.opy#L207).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [339](../src/zombie_types.opy#L339), [358](../src/zombie_types.opy#L358), [365](../src/zombie_types.opy#L365).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [528](../src/zombie_types.opy#L528), [542](../src/zombie_types.opy#L542), [548](../src/zombie_types.opy#L548), [563](../src/zombie_types.opy#L563).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [590](../src/zombie_types.opy#L590), [596](../src/zombie_types.opy#L596), [629](../src/zombie_types.opy#L629).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [642](../src/zombie_types.opy#L642), [651](../src/zombie_types.opy#L651), [664](../src/zombie_types.opy#L664), [688](../src/zombie_types.opy#L688), [692](../src/zombie_types.opy#L692).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [705](../src/zombie_types.opy#L705).
- zombie_types.opy — rule "STRIKER CANCEL BALL FORM" (event Team 2): [738](../src/zombie_types.opy#L738).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [770](../src/zombie_types.opy#L770), [800](../src/zombie_types.opy#L800).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [827](../src/zombie_types.opy#L827), [840](../src/zombie_types.opy#L840), [849](../src/zombie_types.opy#L849), [877](../src/zombie_types.opy#L877).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [940](../src/zombie_types.opy#L940), [961](../src/zombie_types.opy#L961).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1011](../src/zombie_types.opy#L1011), [1037](../src/zombie_types.opy#L1037), [1046](../src/zombie_types.opy#L1046), [1077](../src/zombie_types.opy#L1077).
- supply_drops.opy — def healBeacon(): [236](../src/supply_drops.opy#L236), [238](../src/supply_drops.opy#L238), [240](../src/supply_drops.opy#L240), [246](../src/supply_drops.opy#L246), [247](../src/supply_drops.opy#L247), [252](../src/supply_drops.opy#L252), [253](../src/supply_drops.opy#L253), [259](../src/supply_drops.opy#L259).

## actorTeamSlot16

Объявление: [variables.opy:559](../src/variables.opy#L559).

Алиасы: `botConfiguredHero`, `powerUpForceFieldPosition`.

- subroutines.opy — macro botEntityManagementMacro(): [129](../src/subroutines.opy#L129), [130](../src/subroutines.opy#L130).
- supply_drops.opy — def playerForceField(): [145](../src/supply_drops.opy#L145), [147](../src/supply_drops.opy#L147), [151](../src/supply_drops.opy#L151), [152](../src/supply_drops.opy#L152), [158](../src/supply_drops.opy#L158), [159](../src/supply_drops.opy#L159), [163](../src/supply_drops.opy#L163).

## actorTeamSlot17

Объявление: [variables.opy:565](../src/variables.opy#L565).

Алиасы: `botMutationId`, `powerUpBouncePadPosition`.

- subroutines.opy — macro mutationsMacro(): [81](../src/subroutines.opy#L81), [84](../src/subroutines.opy#L84), [91](../src/subroutines.opy#L91), [97](../src/subroutines.opy#L97), [103](../src/subroutines.opy#L103), [121](../src/subroutines.opy#L121).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [399](../src/bots_game_in_progress.opy#L399).
- supply_drops.opy — def bouncePad(): [373](../src/supply_drops.opy#L373), [375](../src/supply_drops.opy#L375), [379](../src/supply_drops.opy#L379), [380](../src/supply_drops.opy#L380), [385](../src/supply_drops.opy#L385), [389](../src/supply_drops.opy#L389), [400](../src/supply_drops.opy#L400).

## actorTeamSlot18

Объявление: [variables.opy:571](../src/variables.opy#L571).

Алиасы: `botIsInitializing`, `powerUpStunOrigin`.

- subroutines.opy — macro minibossMutationMacro(): [27](../src/subroutines.opy#L27).
- subroutines.opy — def botRespawnInitialization(): [709](../src/subroutines.opy#L709), [753](../src/subroutines.opy#L753).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [17](../src/objective_types/objective_type_bosses.opy#L17), [18](../src/objective_types/objective_type_bosses.opy#L18).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [58](../src/objective_types/objective_type_zombie_egg.opy#L58).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [48](../src/bots_game_in_progress.opy#L48).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [238](../src/bots_game_in_progress.opy#L238).
- bots_game_in_progress.opy — def teleportBots(): [450](../src/bots_game_in_progress.opy#L450).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE" (event Team 2): [531](../src/bots_game_in_progress.opy#L531).
- supply_drops.opy — def stun(): [429](../src/supply_drops.opy#L429), [435](../src/supply_drops.opy#L435), [442](../src/supply_drops.opy#L442), [443](../src/supply_drops.opy#L443), [451](../src/supply_drops.opy#L451), [453](../src/supply_drops.opy#L453).

## actorTeamSlot19

Объявление: [variables.opy:577](../src/variables.opy#L577).

Алиасы: `botKnockbackScale`, `powerUpTurretDirection`.

- subroutines.opy — macro botStatManagementMacro(): [52](../src/subroutines.opy#L52), [55](../src/subroutines.opy#L55), [56](../src/subroutines.opy#L56).
- subroutines.opy — macro mutationsMacro(): [109](../src/subroutines.opy#L109), [110](../src/subroutines.opy#L110), [112](../src/subroutines.opy#L112), [115](../src/subroutines.opy#L115).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [418](../src/bots_game_in_progress.opy#L418).
- supply_drops.opy — def sentryTurret(): [274](../src/supply_drops.opy#L274), [283](../src/supply_drops.opy#L283), [286](../src/supply_drops.opy#L286), [287](../src/supply_drops.opy#L287), [288](../src/supply_drops.opy#L288).

## actorTeamSlot20

Объявление: [variables.opy:583](../src/variables.opy#L583).

Алиасы: `botCustomTeleportPosition`, `powerUpAirStrikePosition`.

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [68](../src/objective_types/objective_type_zombie_egg.opy#L68).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [68](../src/bots_game_in_progress.opy#L68), [71](../src/bots_game_in_progress.opy#L71).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [154](../src/bots_game_in_progress.opy#L154), [155](../src/bots_game_in_progress.opy#L155).
- bots_game_in_progress.opy — def teleportBots(): [451](../src/bots_game_in_progress.opy#L451), [481](../src/bots_game_in_progress.opy#L481), [482](../src/bots_game_in_progress.opy#L482).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [515](../src/bots_game_in_progress.opy#L515).
- supply_drops.opy — def airStrike(): [201](../src/supply_drops.opy#L201), [203](../src/supply_drops.opy#L203), [205](../src/supply_drops.opy#L205), [213](../src/supply_drops.opy#L213).

## actorTeamSlot21

Объявление: [variables.opy:589](../src/variables.opy#L589).

Алиасы: `botLastTarget`, `powerUpTradeIndex`.

- subroutines.opy — def selectTarget(): [688](../src/subroutines.opy#L688).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [137](../src/objective_types/objective_type_bosses.opy#L137), [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [272](../src/bots_game_in_progress.opy#L272).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [196](../src/zombie_types.opy#L196), [198](../src/zombie_types.opy#L198).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [353](../src/zombie_types.opy#L353).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [541](../src/zombie_types.opy#L541).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [769](../src/zombie_types.opy#L769), [778](../src/zombie_types.opy#L778), [779](../src/zombie_types.opy#L779).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [830](../src/zombie_types.opy#L830), [852](../src/zombie_types.opy#L852).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1013](../src/zombie_types.opy#L1013).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1238](../src/zombie_types.opy#L1238).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1253](../src/zombie_types.opy#L1253).
- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [109](../src/supply_drops.opy#L109), [112](../src/supply_drops.opy#L112), [113](../src/supply_drops.opy#L113), [114](../src/supply_drops.opy#L114), [116](../src/supply_drops.opy#L116), [117](../src/supply_drops.opy#L117), [118](../src/supply_drops.opy#L118), [119](../src/supply_drops.opy#L119).

## actorTeamSlot22

Объявление: [variables.opy:595](../src/variables.opy#L595).

Алиасы: `botAbilityCooldown`, `botGasPositionList`, `enhancementHybridCooldown`, `enhancementBarrierFacing`, `enhancementPyroHitList`, `enhancementPlagueCureTotal`, `enhancementIsBattleResetReady`, `enhancementBatteryPosition`, `enhancementHitchhikerCarrier`, `enhancementPupColor`.

- subroutines.opy — macro botStatManagementMacro(): [73](../src/subroutines.opy#L73).
- subroutines.opy — macro botEntityManagementMacro(): [152](../src/subroutines.opy#L152), [155](../src/subroutines.opy#L155).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [41](../src/objective_types/objective_type_survivor_rescue.opy#L41).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [363](../src/bots_game_in_progress.opy#L363), [381](../src/bots_game_in_progress.opy#L381).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [210](../src/zombie_types.opy#L210), [213](../src/zombie_types.opy#L213), [215](../src/zombie_types.opy#L215), [217](../src/zombie_types.opy#L217), [223](../src/zombie_types.opy#L223).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [233](../src/zombie_types.opy#L233), [238](../src/zombie_types.opy#L238), [241](../src/zombie_types.opy#L241).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1154](../src/zombie_types.opy#L1154), [1181](../src/zombie_types.opy#L1181).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1399](../src/zombie_types.opy#L1399).
- zombie_types.opy — def abilityThrowdown(): [1458](../src/zombie_types.opy#L1458).
- zombie_types.opy — def spawnGasCloud(): [1498](../src/zombie_types.opy#L1498).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/enhancements.opy#L29), [73](../src/enhancements.opy#L73), [79](../src/enhancements.opy#L79), [82](../src/enhancements.opy#L82), [89](../src/enhancements.opy#L89), [90](../src/enhancements.opy#L90), [103](../src/enhancements.opy#L103), [105](../src/enhancements.opy#L105), [107](../src/enhancements.opy#L107), [109](../src/enhancements.opy#L109), [119](../src/enhancements.opy#L119), [121](../src/enhancements.opy#L121), [122](../src/enhancements.opy#L122), [123](../src/enhancements.opy#L123), [134](../src/enhancements.opy#L134), [143](../src/enhancements.opy#L143), [145](../src/enhancements.opy#L145), [151](../src/enhancements.opy#L151).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [166](../src/enhancements.opy#L166), [172](../src/enhancements.opy#L172), [173](../src/enhancements.opy#L173), [175](../src/enhancements.opy#L175).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [204](../src/enhancements.opy#L204).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [237](../src/enhancements.opy#L237).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [290](../src/enhancements.opy#L290).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [297](../src/enhancements.opy#L297), [299](../src/enhancements.opy#L299), [302](../src/enhancements.opy#L302), [306](../src/enhancements.opy#L306), [311](../src/enhancements.opy#L311).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [321](../src/enhancements.opy#L321), [323](../src/enhancements.opy#L323).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [330](../src/enhancements.opy#L330), [348](../src/enhancements.opy#L348), [355](../src/enhancements.opy#L355), [363](../src/enhancements.opy#L363), [367](../src/enhancements.opy#L367).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [377](../src/enhancements.opy#L377), [380](../src/enhancements.opy#L380), [383](../src/enhancements.opy#L383).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [405](../src/enhancements.opy#L405), [408](../src/enhancements.opy#L408), [409](../src/enhancements.opy#L409).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [422](../src/enhancements.opy#L422), [423](../src/enhancements.opy#L423), [427](../src/enhancements.opy#L427), [429](../src/enhancements.opy#L429).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [444](../src/enhancements.opy#L444), [450](../src/enhancements.opy#L450), [453](../src/enhancements.opy#L453), [456](../src/enhancements.opy#L456), [464](../src/enhancements.opy#L464), [466](../src/enhancements.opy#L466), [468](../src/enhancements.opy#L468), [470](../src/enhancements.opy#L470), [471](../src/enhancements.opy#L471), [475](../src/enhancements.opy#L475), [477](../src/enhancements.opy#L477).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [499](../src/enhancements.opy#L499), [501](../src/enhancements.opy#L501), [505](../src/enhancements.opy#L505), [508](../src/enhancements.opy#L508), [511](../src/enhancements.opy#L511).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [539](../src/enhancements.opy#L539).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [560](../src/enhancements.opy#L560), [570](../src/enhancements.opy#L570), [588](../src/enhancements.opy#L588), [595](../src/enhancements.opy#L595), [610](../src/enhancements.opy#L610).

## actorTeamSlot23

Объявление: [variables.opy:617](../src/variables.opy#L617).

Алиасы: `botGasRadiusList`, `enhancementBarrierEdgeDirection`, `enhancementBattleAbilityButton`, `enhancementBatteryReuseCooldown`, `enhancementHitchhikerPassengerPoolId`, `enhancementIsPupBeamActive`.

- subroutines.opy — macro botEntityManagementMacro(): [152](../src/subroutines.opy#L152), [155](../src/subroutines.opy#L155).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [42](../src/objective_types/objective_type_survivor_rescue.opy#L42).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [212](../src/zombie_types.opy#L212), [224](../src/zombie_types.opy#L224).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [239](../src/zombie_types.opy#L239), [240](../src/zombie_types.opy#L240), [241](../src/zombie_types.opy#L241).
- zombie_types.opy — def spawnGasCloud(): [1499](../src/zombie_types.opy#L1499).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [105](../src/enhancements.opy#L105), [107](../src/enhancements.opy#L107), [109](../src/enhancements.opy#L109), [141](../src/enhancements.opy#L141), [145](../src/enhancements.opy#L145), [147](../src/enhancements.opy#L147), [153](../src/enhancements.opy#L153).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/enhancements.opy#L230), [234](../src/enhancements.opy#L234).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [334](../src/enhancements.opy#L334), [336](../src/enhancements.opy#L336), [338](../src/enhancements.opy#L338), [340](../src/enhancements.opy#L340), [342](../src/enhancements.opy#L342), [344](../src/enhancements.opy#L344), [347](../src/enhancements.opy#L347), [351](../src/enhancements.opy#L351), [354](../src/enhancements.opy#L354), [359](../src/enhancements.opy#L359), [362](../src/enhancements.opy#L362), [365](../src/enhancements.opy#L365), [366](../src/enhancements.opy#L366).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [411](../src/enhancements.opy#L411).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [432](../src/enhancements.opy#L432), [433](../src/enhancements.opy#L433), [435](../src/enhancements.opy#L435).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [467](../src/enhancements.opy#L467), [478](../src/enhancements.opy#L478).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [541](../src/enhancements.opy#L541).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [562](../src/enhancements.opy#L562), [572](../src/enhancements.opy#L572), [590](../src/enhancements.opy#L590), [597](../src/enhancements.opy#L597), [612](../src/enhancements.opy#L612).

## actorTeamSlot24

Объявление: [variables.opy:631](../src/variables.opy#L631).

Алиасы: `botSpawnWaypoint`, `enhancementBarrierPlacementCooldown`, `enhancementBatteryReuseDuration`, `enhancementPupTarget`.

- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [229](../src/bots_game_in_progress.opy#L229).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [517](../src/bots_game_in_progress.opy#L517).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/enhancements.opy#L48), [50](../src/enhancements.opy#L50), [109](../src/enhancements.opy#L109), [110](../src/enhancements.opy#L110), [145](../src/enhancements.opy#L145), [149](../src/enhancements.opy#L149), [155](../src/enhancements.opy#L155).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [185](../src/enhancements.opy#L185), [211](../src/enhancements.opy#L211), [212](../src/enhancements.opy#L212), [214](../src/enhancements.opy#L214).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [432](../src/enhancements.opy#L432).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [526](../src/enhancements.opy#L526), [530](../src/enhancements.opy#L530), [531](../src/enhancements.opy#L531), [533](../src/enhancements.opy#L533), [543](../src/enhancements.opy#L543).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [555](../src/enhancements.opy#L555), [558](../src/enhancements.opy#L558), [565](../src/enhancements.opy#L565), [567](../src/enhancements.opy#L567), [568](../src/enhancements.opy#L568), [576](../src/enhancements.opy#L576), [578](../src/enhancements.opy#L578), [581](../src/enhancements.opy#L581), [582](../src/enhancements.opy#L582), [583](../src/enhancements.opy#L583), [586](../src/enhancements.opy#L586), [598](../src/enhancements.opy#L598), [602](../src/enhancements.opy#L602), [603](../src/enhancements.opy#L603), [604](../src/enhancements.opy#L604), [605](../src/enhancements.opy#L605), [615](../src/enhancements.opy#L615).

## actorTeamSlot25

Объявление: [variables.opy:641](../src/variables.opy#L641).

Алиасы: `botCandidateTarget`, `enhancementBarrierPosition`, `enhancementBatteryPlacementCooldown`, `enhancementIsPupFreezeAuraActive`.

- subroutines.opy — def selectTarget(): [682](../src/subroutines.opy#L682), [683](../src/subroutines.opy#L683), [687](../src/subroutines.opy#L687).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [60](../src/enhancements.opy#L60), [99](../src/enhancements.opy#L99), [101](../src/enhancements.opy#L101), [149](../src/enhancements.opy#L149), [157](../src/enhancements.opy#L157).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [198](../src/enhancements.opy#L198), [200](../src/enhancements.opy#L200), [202](../src/enhancements.opy#L202), [207](../src/enhancements.opy#L207), [208](../src/enhancements.opy#L208).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [224](../src/enhancements.opy#L224), [226](../src/enhancements.opy#L226), [228](../src/enhancements.opy#L228), [234](../src/enhancements.opy#L234), [237](../src/enhancements.opy#L237), [251](../src/enhancements.opy#L251), [254](../src/enhancements.opy#L254).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [395](../src/enhancements.opy#L395), [407](../src/enhancements.opy#L407), [412](../src/enhancements.opy#L412), [414](../src/enhancements.opy#L414).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [545](../src/enhancements.opy#L545).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [564](../src/enhancements.opy#L564), [574](../src/enhancements.opy#L574), [592](../src/enhancements.opy#L592).

## actorTeamSlot26

Объявление: [variables.opy:651](../src/variables.opy#L651).

Алиасы: `botIsTeleportAllowed`, `enhancementBarrierCorner1`, `enhancementPupPosition`.

- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [72](../src/bots_game_in_progress.opy#L72), [88](../src/bots_game_in_progress.opy#L88).
- bots_game_in_progress.opy — def teleportBots(): [450](../src/bots_game_in_progress.opy#L450).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [54](../src/enhancements.opy#L54), [58](../src/enhancements.opy#L58), [136](../src/enhancements.opy#L136), [138](../src/enhancements.opy#L138), [143](../src/enhancements.opy#L143), [145](../src/enhancements.opy#L145), [147](../src/enhancements.opy#L147).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [200](../src/enhancements.opy#L200), [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/enhancements.opy#L230), [234](../src/enhancements.opy#L234).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [532](../src/enhancements.opy#L532), [537](../src/enhancements.opy#L537), [548](../src/enhancements.opy#L548).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [558](../src/enhancements.opy#L558), [565](../src/enhancements.opy#L565), [600](../src/enhancements.opy#L600), [604](../src/enhancements.opy#L604), [613](../src/enhancements.opy#L613).

## actorTeamSlot27

Объявление: [variables.opy:659](../src/variables.opy#L659).

Алиасы: `botReigniteRisePosition`, `enhancementBarrierCorner2`, `enhancementPupCooldown`.

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [423](../src/zombie_types.opy#L423), [424](../src/zombie_types.opy#L424), [425](../src/zombie_types.opy#L425).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [56](../src/enhancements.opy#L56), [58](../src/enhancements.opy#L58), [134](../src/enhancements.opy#L134), [139](../src/enhancements.opy#L139), [141](../src/enhancements.opy#L141).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [202](../src/enhancements.opy#L202), [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [524](../src/enhancements.opy#L524).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [580](../src/enhancements.opy#L580), [607](../src/enhancements.opy#L607).

## actorTeamSlot28

Объявление: [variables.opy:667](../src/variables.opy#L667).

Алиасы: `botResourceIconIdList`, `enhancementBarrierHealth`.

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [18](../src/players_game_in_progress.opy#L18), [19](../src/players_game_in_progress.opy#L19), [21](../src/players_game_in_progress.opy#L21), [28](../src/players_game_in_progress.opy#L28).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/enhancements.opy#L48), [54](../src/enhancements.opy#L54), [56](../src/enhancements.opy#L56), [58](../src/enhancements.opy#L58), [60](../src/enhancements.opy#L60).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [196](../src/enhancements.opy#L196).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [222](../src/enhancements.opy#L222), [232](../src/enhancements.opy#L232), [246](../src/enhancements.opy#L246), [258](../src/enhancements.opy#L258), [263](../src/enhancements.opy#L263), [264](../src/enhancements.opy#L264), [265](../src/enhancements.opy#L265).

## team1PositionSlot

Объявление: [variables.opy:673](../src/variables.opy#L673).

Алиасы: `pregamePosition`, `rescueStartPosition`, `extractionDestination`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [71](../src/global_start_menu.opy#L71), [73](../src/global_start_menu.opy#L73), [75](../src/global_start_menu.opy#L75).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [26](../src/player_start_menu.opy#L26), [28](../src/player_start_menu.opy#L28).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/player_start_menu.opy#L40), [43](../src/player_start_menu.opy#L43), [45](../src/player_start_menu.opy#L45), [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49), [51](../src/player_start_menu.opy#L51), [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [73](../src/player_start_menu.opy#L73), [75](../src/player_start_menu.opy#L75), [79](../src/player_start_menu.opy#L79).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [225](../src/player_start_menu.opy#L225), [229](../src/player_start_menu.opy#L229), [231](../src/player_start_menu.opy#L231).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [36](../src/objective_types/objective_type_survivor_rescue.opy#L36), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).

## objectiveActorKindSlot

Объявление: [variables.opy:681](../src/variables.opy#L681).

Алиасы: `biomorphingResourceType`, `rescueMoodIcon`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [303](../src/subroutines.opy#L303), [312](../src/subroutines.opy#L312), [315](../src/subroutines.opy#L315).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [49](../src/objective_types/objective_type_biomorphing.opy#L49), [74](../src/objective_types/objective_type_biomorphing.opy#L74).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [102](../src/objective_types/objective_type_biomorphing.opy#L102).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [133](../src/objective_types/objective_type_biomorphing.opy#L133).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [164](../src/objective_types/objective_type_biomorphing.opy#L164).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [193](../src/objective_types/objective_type_biomorphing.opy#L193), [196](../src/objective_types/objective_type_biomorphing.opy#L196).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50), [51](../src/objective_types/objective_type_survivor_rescue.opy#L51).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [87](../src/objective_types/objective_type_survivor_rescue.opy#L87), [106](../src/objective_types/objective_type_survivor_rescue.opy#L106).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [179](../src/objective_types/objective_type_survivor_rescue.opy#L179).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).
