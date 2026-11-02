# Обращения к переменным игрока — 2026-11-02

Сгенерировано `node analysis/audit-player-variables.cjs`. Команда правила не доказывает команду получателя поля: учитывайте выражение слева от точки и вызовы подпрограмм. Алиасы собраны в физические слоты.

## botTeleportCenter

Объявление: [variables.opy:267](../src/variables.opy#L267).

- objective_types/objective_type_bosses.opy — def bossReturn(): [206](../src/objective_types/objective_type_bosses.opy#L206).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [70](../src/objective_types/objective_type_zombie_egg.opy#L70).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [13](../src/bots_game_in_progress.opy#L13), [16](../src/bots_game_in_progress.opy#L16), [20](../src/bots_game_in_progress.opy#L20), [22](../src/bots_game_in_progress.opy#L22), [28](../src/bots_game_in_progress.opy#L28), [36](../src/bots_game_in_progress.opy#L36), [39](../src/bots_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [196](../src/bots_game_in_progress.opy#L196).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [227](../src/bots_game_in_progress.opy#L227).
- bots_game_in_progress.opy — def teleportBots(): [458](../src/bots_game_in_progress.opy#L458), [468](../src/bots_game_in_progress.opy#L468).
- bots_game_in_progress.opy — def locateAveragePlayerLocation(): [489](../src/bots_game_in_progress.opy#L489), [493](../src/bots_game_in_progress.opy#L493), [497](../src/bots_game_in_progress.opy#L497), [498](../src/bots_game_in_progress.opy#L498).

## botIsSelectingTarget

Объявление: [variables.opy:268](../src/variables.opy#L268).

- subroutines.opy — def selectTarget(): [650](../src/subroutines.opy#L650), [678](../src/subroutines.opy#L678).
- subroutines.opy — def botRespawnInitialization(): [721](../src/subroutines.opy#L721).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [186](../src/bots_game_in_progress.opy#L186).

## botReturnMotionSlot

Объявление: [variables.opy:269](../src/variables.opy#L269).

Алиасы: `botReturnTime`, `botReturnPosition`.

- objective_types/objective_type_bosses.opy — rule "BOSS TELEPORT TO TARGET IF NOT USED" (event Team 2): [186](../src/objective_types/objective_type_bosses.opy#L186), [187](../src/objective_types/objective_type_bosses.opy#L187), [188](../src/objective_types/objective_type_bosses.opy#L188), [190](../src/objective_types/objective_type_bosses.opy#L190), [191](../src/objective_types/objective_type_bosses.opy#L191).
- objective_types/objective_type_bosses.opy — def bossReturn(): [200](../src/objective_types/objective_type_bosses.opy#L200), [202](../src/objective_types/objective_type_bosses.opy#L202), [209](../src/objective_types/objective_type_bosses.opy#L209).

## botIsTeleporting

Объявление: [variables.opy:274](../src/variables.opy#L274).

- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [10](../src/objective_types/objective_type_bosses.opy#L10), [15](../src/objective_types/objective_type_bosses.opy#L15).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [8](../src/objective_types/objective_type_zombie_egg.opy#L8), [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [59](../src/objective_types/objective_type_zombie_egg.opy#L59).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [40](../src/objective_types/objective_type_satellite_uplink.opy#L40), [44](../src/objective_types/objective_type_satellite_uplink.opy#L44), [47](../src/objective_types/objective_type_satellite_uplink.opy#L47).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [49](../src/bots_game_in_progress.opy#L49).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [95](../src/bots_game_in_progress.opy#L95).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [162](../src/bots_game_in_progress.opy#L162).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [183](../src/bots_game_in_progress.opy#L183).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [219](../src/bots_game_in_progress.opy#L219).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [236](../src/bots_game_in_progress.opy#L236).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [265](../src/bots_game_in_progress.opy#L265).
- bots_game_in_progress.opy — def enterExitTeleport(): [423](../src/bots_game_in_progress.opy#L423).
- bots_game_in_progress.opy — def teleportBots(): [445](../src/bots_game_in_progress.opy#L445), [451](../src/bots_game_in_progress.opy#L451), [472](../src/bots_game_in_progress.opy#L472), [481](../src/bots_game_in_progress.opy#L481).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [458](../src/zombie_types.opy#L458), [462](../src/zombie_types.opy#L462), [466](../src/zombie_types.opy#L466).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [478](../src/zombie_types.opy#L478).
- supply_drops.opy — def sentryTurret(): [265](../src/supply_drops.opy#L265), [273](../src/supply_drops.opy#L273).
- supply_drops.opy — def stun(): [439](../src/supply_drops.opy#L439).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [519](../src/enhancements.opy#L519).

## botLoopIndexSlot

Объявление: [variables.opy:275](../src/variables.opy#L275).

Алиасы: `botStalkerFadeIndex`, `botEnsnarerTargetIndex`.

- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [767](../src/zombie_types.opy#L767), [772](../src/zombie_types.opy#L772).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1159](../src/zombie_types.opy#L1159), [1160](../src/zombie_types.opy#L1160).

## botBiteDamage

Объявление: [variables.opy:280](../src/variables.opy#L280).

- subroutines.opy — macro botStatManagementMacro(): [34](../src/subroutines.opy#L34), [36](../src/subroutines.opy#L36).
- subroutines.opy — def explosionSequence(): [764](../src/subroutines.opy#L764), [767](../src/subroutines.opy#L767), [771](../src/subroutines.opy#L771).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [394](../src/bots_game_in_progress.opy#L394).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [151](../src/zombie_types.opy#L151).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [180](../src/zombie_types.opy#L180).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [240](../src/zombie_types.opy#L240).
- zombie_types.opy — rule "CHARGER KNOCKBACK" (event Team 2): [573](../src/zombie_types.opy#L573).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [885](../src/zombie_types.opy#L885), [890](../src/zombie_types.opy#L890).

## botBiteDuration

Объявление: [variables.opy:281](../src/variables.opy#L281).

- subroutines.opy — macro botStatManagementMacro(): [37](../src/subroutines.opy#L37).
- subroutines.opy — macro mutationsMacro(): [100](../src/subroutines.opy#L100).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [394](../src/bots_game_in_progress.opy#L394), [395](../src/bots_game_in_progress.opy#L395), [396](../src/bots_game_in_progress.opy#L396).

## botIsTeleportConfirmed

Объявление: [variables.opy:282](../src/variables.opy#L282).

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [60](../src/objective_types/objective_type_zombie_egg.opy#L60), [67](../src/objective_types/objective_type_zombie_egg.opy#L67).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [161](../src/bots_game_in_progress.opy#L161).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [192](../src/bots_game_in_progress.opy#L192), [197](../src/bots_game_in_progress.opy#L197).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [220](../src/bots_game_in_progress.opy#L220), [225](../src/bots_game_in_progress.opy#L225), [226](../src/bots_game_in_progress.opy#L226).
- bots_game_in_progress.opy — def teleportBots(): [448](../src/bots_game_in_progress.opy#L448).
- bots_game_in_progress.opy — def successfulTeleportStatus(): [505](../src/bots_game_in_progress.opy#L505), [506](../src/bots_game_in_progress.opy#L506).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [512](../src/bots_game_in_progress.opy#L512), [516](../src/bots_game_in_progress.opy#L516).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [929](../src/zombie_types.opy#L929).

## botReigniteDestination

Объявление: [variables.opy:283](../src/variables.opy#L283).

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [411](../src/zombie_types.opy#L411), [418](../src/zombie_types.opy#L418), [419](../src/zombie_types.opy#L419), [421](../src/zombie_types.opy#L421), [423](../src/zombie_types.opy#L423).

## botIsWallPhaseAllowed

Объявление: [variables.opy:284](../src/variables.opy#L284).

- subroutines.opy — def botRespawnInitialization(): [716](../src/subroutines.opy#L716).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [91](../src/objective_types/objective_type_bosses.opy#L91).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [325](../src/bots_game_in_progress.opy#L325).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [340](../src/zombie_types.opy#L340).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [533](../src/zombie_types.opy#L533), [561](../src/zombie_types.opy#L561).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [710](../src/zombie_types.opy#L710), [725](../src/zombie_types.opy#L725).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [768](../src/zombie_types.opy#L768), [793](../src/zombie_types.opy#L793), [798](../src/zombie_types.opy#L798).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [939](../src/zombie_types.opy#L939), [958](../src/zombie_types.opy#L958).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1053](../src/zombie_types.opy#L1053), [1071](../src/zombie_types.opy#L1071).

## botAbilityTarget

Объявление: [variables.opy:285](../src/variables.opy#L285).

- subroutines.opy — def botRespawnInitialization(): [720](../src/subroutines.opy#L720).
- subroutines.opy — def illariUlt(): [786](../src/subroutines.opy#L786), [787](../src/subroutines.opy#L787), [788](../src/subroutines.opy#L788).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [49](../src/zombie_types.opy#L49), [50](../src/zombie_types.opy#L50), [52](../src/zombie_types.opy#L52), [55](../src/zombie_types.opy#L55).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [437](../src/zombie_types.opy#L437), [438](../src/zombie_types.opy#L438).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [446](../src/zombie_types.opy#L446), [447](../src/zombie_types.opy#L447), [449](../src/zombie_types.opy#L449).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [466](../src/zombie_types.opy#L466), [467](../src/zombie_types.opy#L467).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [477](../src/zombie_types.opy#L477), [478](../src/zombie_types.opy#L478), [480](../src/zombie_types.opy#L480).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [594](../src/zombie_types.opy#L594), [602](../src/zombie_types.opy#L602), [603](../src/zombie_types.opy#L603), [609](../src/zombie_types.opy#L609), [611](../src/zombie_types.opy#L611), [612](../src/zombie_types.opy#L612), [613](../src/zombie_types.opy#L613), [614](../src/zombie_types.opy#L614), [616](../src/zombie_types.opy#L616).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [675](../src/zombie_types.opy#L675), [676](../src/zombie_types.opy#L676), [678](../src/zombie_types.opy#L678), [681](../src/zombie_types.opy#L681).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [932](../src/zombie_types.opy#L932), [934](../src/zombie_types.opy#L934), [938](../src/zombie_types.opy#L938), [941](../src/zombie_types.opy#L941), [945](../src/zombie_types.opy#L945), [946](../src/zombie_types.opy#L946), [947](../src/zombie_types.opy#L947), [950](../src/zombie_types.opy#L950), [951](../src/zombie_types.opy#L951), [952](../src/zombie_types.opy#L952), [953](../src/zombie_types.opy#L953), [961](../src/zombie_types.opy#L961).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1013](../src/zombie_types.opy#L1013), [1014](../src/zombie_types.opy#L1014), [1016](../src/zombie_types.opy#L1016), [1017](../src/zombie_types.opy#L1017), [1026](../src/zombie_types.opy#L1026), [1027](../src/zombie_types.opy#L1027), [1034](../src/zombie_types.opy#L1034), [1043](../src/zombie_types.opy#L1043), [1048](../src/zombie_types.opy#L1048), [1049](../src/zombie_types.opy#L1049), [1050](../src/zombie_types.opy#L1050), [1057](../src/zombie_types.opy#L1057), [1059](../src/zombie_types.opy#L1059), [1061](../src/zombie_types.opy#L1061), [1062](../src/zombie_types.opy#L1062).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1289](../src/zombie_types.opy#L1289), [1290](../src/zombie_types.opy#L1290).

## botBossHealth

Объявление: [variables.opy:286](../src/variables.opy#L286).

- subroutines.opy — def botRespawnInitialization(): [722](../src/subroutines.opy#L722).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [60](../src/objective_types/objective_type_bosses.opy#L60).
- objective_types/objective_type_bosses.opy — rule "BOSS HEALTH CONTROL (ALL BOSS OBJECTIVES)" (event Team 2): [114](../src/objective_types/objective_type_bosses.opy#L114), [115](../src/objective_types/objective_type_bosses.opy#L115).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [127](../src/objective_types/objective_type_bosses.opy#L127), [129](../src/objective_types/objective_type_bosses.opy#L129), [130](../src/objective_types/objective_type_bosses.opy#L130), [141](../src/objective_types/objective_type_bosses.opy#L141), [154](../src/objective_types/objective_type_bosses.opy#L154), [157](../src/objective_types/objective_type_bosses.opy#L157).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [37](../src/objective_types/objective_type_zombie_egg.opy#L37).

## botIsWallCollisionEnabled

Объявление: [variables.opy:287](../src/variables.opy#L287).

- subroutines.opy — def botRespawnInitialization(): [711](../src/subroutines.opy#L711).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [69](../src/objective_types/objective_type_bosses.opy#L69), [83](../src/objective_types/objective_type_bosses.opy#L83).
- objective_types/objective_type_bosses.opy — rule "BOSS STUCK" (event Team 2): [90](../src/objective_types/objective_type_bosses.opy#L90), [98](../src/objective_types/objective_type_bosses.opy#L98), [102](../src/objective_types/objective_type_bosses.opy#L102).
- objective_types/objective_type_bosses.opy — rule "BOSS TAKES KNOCKBACK" (event Team 2): [173](../src/objective_types/objective_type_bosses.opy#L173), [177](../src/objective_types/objective_type_bosses.opy#L177).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [41](../src/objective_types/objective_type_zombie_egg.opy#L41), [42](../src/objective_types/objective_type_zombie_egg.opy#L42).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [324](../src/bots_game_in_progress.opy#L324), [340](../src/bots_game_in_progress.opy#L340), [348](../src/bots_game_in_progress.opy#L348).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [535](../src/zombie_types.opy#L535).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [649](../src/zombie_types.opy#L649), [668](../src/zombie_types.opy#L668).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [711](../src/zombie_types.opy#L711).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [757](../src/zombie_types.opy#L757), [769](../src/zombie_types.opy#L769).

## botIsFacingOverridden

Объявление: [variables.opy:288](../src/variables.opy#L288).

- subroutines.opy — def restoreDefaultFacingMovement(): [685](../src/subroutines.opy#L685).
- subroutines.opy — def botRespawnInitialization(): [714](../src/subroutines.opy#L714).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [272](../src/bots_game_in_progress.opy#L272).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [284](../src/bots_game_in_progress.opy#L284).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [364](../src/bots_game_in_progress.opy#L364), [377](../src/bots_game_in_progress.opy#L377).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [43](../src/zombie_types.opy#L43), [58](../src/zombie_types.opy#L58).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [123](../src/zombie_types.opy#L123), [135](../src/zombie_types.opy#L135).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [194](../src/zombie_types.opy#L194), [205](../src/zombie_types.opy#L205).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [338](../src/zombie_types.opy#L338), [357](../src/zombie_types.opy#L357), [364](../src/zombie_types.opy#L364).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [497](../src/zombie_types.opy#L497), [505](../src/zombie_types.opy#L505).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [536](../src/zombie_types.opy#L536), [543](../src/zombie_types.opy#L543), [549](../src/zombie_types.opy#L549), [558](../src/zombie_types.opy#L558).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [661](../src/zombie_types.opy#L661), [684](../src/zombie_types.opy#L684).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [762](../src/zombie_types.opy#L762), [796](../src/zombie_types.opy#L796).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [824](../src/zombie_types.opy#L824), [836](../src/zombie_types.opy#L836), [845](../src/zombie_types.opy#L845), [873](../src/zombie_types.opy#L873).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1007](../src/zombie_types.opy#L1007), [1033](../src/zombie_types.opy#L1033), [1042](../src/zombie_types.opy#L1042), [1073](../src/zombie_types.opy#L1073).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1156](../src/zombie_types.opy#L1156), [1167](../src/zombie_types.opy#L1167).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1389](../src/zombie_types.opy#L1389), [1397](../src/zombie_types.opy#L1397).

## botIsThrottleOverridden

Объявление: [variables.opy:289](../src/variables.opy#L289).

- subroutines.opy — def restoreDefaultFacingMovement(): [687](../src/subroutines.opy#L687).
- subroutines.opy — def botRespawnInitialization(): [715](../src/subroutines.opy#L715).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [32](../src/objective_types/objective_type_zombie_egg.opy#L32).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [96](../src/bots_game_in_progress.opy#L96).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [270](../src/bots_game_in_progress.opy#L270).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [283](../src/bots_game_in_progress.opy#L283).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [302](../src/bots_game_in_progress.opy#L302).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [41](../src/zombie_types.opy#L41), [57](../src/zombie_types.opy#L57).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [120](../src/zombie_types.opy#L120), [136](../src/zombie_types.opy#L136).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [192](../src/zombie_types.opy#L192), [206](../src/zombie_types.opy#L206).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [337](../src/zombie_types.opy#L337), [356](../src/zombie_types.opy#L356), [363](../src/zombie_types.opy#L363).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [524](../src/zombie_types.opy#L524), [538](../src/zombie_types.opy#L538), [544](../src/zombie_types.opy#L544), [559](../src/zombie_types.opy#L559).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [586](../src/zombie_types.opy#L586), [592](../src/zombie_types.opy#L592), [625](../src/zombie_types.opy#L625).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [638](../src/zombie_types.opy#L638), [647](../src/zombie_types.opy#L647), [660](../src/zombie_types.opy#L660), [683](../src/zombie_types.opy#L683), [687](../src/zombie_types.opy#L687).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [700](../src/zombie_types.opy#L700).
- zombie_types.opy — rule "STRIKER CANCEL BALL FORM" (event Team 2): [733](../src/zombie_types.opy#L733).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [765](../src/zombie_types.opy#L765), [795](../src/zombie_types.opy#L795).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [822](../src/zombie_types.opy#L822), [835](../src/zombie_types.opy#L835), [844](../src/zombie_types.opy#L844), [872](../src/zombie_types.opy#L872).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [935](../src/zombie_types.opy#L935), [956](../src/zombie_types.opy#L956).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1006](../src/zombie_types.opy#L1006), [1032](../src/zombie_types.opy#L1032), [1041](../src/zombie_types.opy#L1041), [1072](../src/zombie_types.opy#L1072).

## botConfiguredHero

Объявление: [variables.opy:290](../src/variables.opy#L290).

- subroutines.opy — macro botEntityManagementMacro(): [125](../src/subroutines.opy#L125), [126](../src/subroutines.opy#L126).

## botMutationId

Объявление: [variables.opy:291](../src/variables.opy#L291).

- subroutines.opy — macro mutationsMacro(): [79](../src/subroutines.opy#L79), [81](../src/subroutines.opy#L81), [87](../src/subroutines.opy#L87), [93](../src/subroutines.opy#L93), [99](../src/subroutines.opy#L99), [104](../src/subroutines.opy#L104), [117](../src/subroutines.opy#L117).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398).

## botBaseHealth

Объявление: [variables.opy:292](../src/variables.opy#L292).

- subroutines.opy — macro minibossMutationMacro(): [22](../src/subroutines.opy#L22).
- subroutines.opy — macro mutationsMacro(): [89](../src/subroutines.opy#L89), [95](../src/subroutines.opy#L95), [111](../src/subroutines.opy#L111).
- subroutines.opy — def botRespawnInitialization(): [700](../src/subroutines.opy#L700), [705](../src/subroutines.opy#L705), [737](../src/subroutines.opy#L737), [739](../src/subroutines.opy#L739).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [59](../src/objective_types/objective_type_bosses.opy#L59), [60](../src/objective_types/objective_type_bosses.opy#L60), [78](../src/objective_types/objective_type_bosses.opy#L78).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [11](../src/objective_types/objective_type_kill_zone.opy#L11).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [36](../src/objective_types/objective_type_zombie_egg.opy#L36), [37](../src/objective_types/objective_type_zombie_egg.opy#L37).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [50](../src/bots_game_in_progress.opy#L50), [54](../src/bots_game_in_progress.opy#L54).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [81](../src/bots_game_in_progress.opy#L81), [83](../src/bots_game_in_progress.opy#L83).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [129](../src/bots_game_in_progress.opy#L129), [131](../src/bots_game_in_progress.opy#L131).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [411](../src/bots_game_in_progress.opy#L411), [417](../src/bots_game_in_progress.opy#L417).

## botIsInitializing

Объявление: [variables.opy:293](../src/variables.opy#L293).

- subroutines.opy — macro minibossMutationMacro(): [27](../src/subroutines.opy#L27).
- subroutines.opy — def botRespawnInitialization(): [697](../src/subroutines.opy#L697), [740](../src/subroutines.opy#L740).
- objective_types/objective_type_bosses.opy — rule "SPAWN BOSS": [17](../src/objective_types/objective_type_bosses.opy#L17), [18](../src/objective_types/objective_type_bosses.opy#L18).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [58](../src/objective_types/objective_type_zombie_egg.opy#L58).
- bots_game_in_progress.opy — rule "Fix bot health" (event Team 2): [48](../src/bots_game_in_progress.opy#L48).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [237](../src/bots_game_in_progress.opy#L237).
- bots_game_in_progress.opy — def teleportBots(): [449](../src/bots_game_in_progress.opy#L449).
- bots_game_in_progress.opy — rule "MINIBOSS MESSAGE" (event Team 2): [528](../src/bots_game_in_progress.opy#L528).

## botKnockbackScale

Объявление: [variables.opy:294](../src/variables.opy#L294).

- subroutines.opy — macro botStatManagementMacro(): [50](../src/subroutines.opy#L50), [53](../src/subroutines.opy#L53), [54](../src/subroutines.opy#L54).
- subroutines.opy — macro mutationsMacro(): [105](../src/subroutines.opy#L105), [106](../src/subroutines.opy#L106), [108](../src/subroutines.opy#L108), [111](../src/subroutines.opy#L111).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [417](../src/bots_game_in_progress.opy#L417).

## botCustomTeleportPosition

Объявление: [variables.opy:295](../src/variables.opy#L295).

- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [68](../src/objective_types/objective_type_zombie_egg.opy#L68).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [68](../src/bots_game_in_progress.opy#L68), [71](../src/bots_game_in_progress.opy#L71).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [153](../src/bots_game_in_progress.opy#L153), [154](../src/bots_game_in_progress.opy#L154).
- bots_game_in_progress.opy — def teleportBots(): [450](../src/bots_game_in_progress.opy#L450), [479](../src/bots_game_in_progress.opy#L479), [480](../src/bots_game_in_progress.opy#L480).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [512](../src/bots_game_in_progress.opy#L512).

## botLastTarget

Объявление: [variables.opy:296](../src/variables.opy#L296).

- subroutines.opy — def selectTarget(): [676](../src/subroutines.opy#L676).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [137](../src/objective_types/objective_type_bosses.opy#L137), [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [271](../src/bots_game_in_progress.opy#L271).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [195](../src/zombie_types.opy#L195), [197](../src/zombie_types.opy#L197).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [351](../src/zombie_types.opy#L351).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [537](../src/zombie_types.opy#L537).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [764](../src/zombie_types.opy#L764), [773](../src/zombie_types.opy#L773), [774](../src/zombie_types.opy#L774).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [825](../src/zombie_types.opy#L825), [847](../src/zombie_types.opy#L847).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1008](../src/zombie_types.opy#L1008).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1233](../src/zombie_types.opy#L1233).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1248](../src/zombie_types.opy#L1248).

## botAbilityStateSlot

Объявление: [variables.opy:297](../src/variables.opy#L297).

Алиасы: `botAbilityCooldown`, `botGasPositionList`.

- subroutines.opy — macro botStatManagementMacro(): [71](../src/subroutines.opy#L71).
- subroutines.opy — macro botEntityManagementMacro(): [147](../src/subroutines.opy#L147), [150](../src/subroutines.opy#L150).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [362](../src/bots_game_in_progress.opy#L362), [380](../src/bots_game_in_progress.opy#L380).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [209](../src/zombie_types.opy#L209), [212](../src/zombie_types.opy#L212), [214](../src/zombie_types.opy#L214), [216](../src/zombie_types.opy#L216), [222](../src/zombie_types.opy#L222).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [232](../src/zombie_types.opy#L232), [236](../src/zombie_types.opy#L236), [239](../src/zombie_types.opy#L239).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1149](../src/zombie_types.opy#L1149), [1176](../src/zombie_types.opy#L1176).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1393](../src/zombie_types.opy#L1393).
- zombie_types.opy — def abilityThrowdown(): [1452](../src/zombie_types.opy#L1452).
- zombie_types.opy — def spawnGasCloud(): [1492](../src/zombie_types.opy#L1492).

## botGasRadiusList

Объявление: [variables.opy:302](../src/variables.opy#L302).

- subroutines.opy — macro botEntityManagementMacro(): [147](../src/subroutines.opy#L147), [150](../src/subroutines.opy#L150).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [211](../src/zombie_types.opy#L211), [223](../src/zombie_types.opy#L223).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [237](../src/zombie_types.opy#L237), [238](../src/zombie_types.opy#L238), [239](../src/zombie_types.opy#L239).
- zombie_types.opy — def spawnGasCloud(): [1493](../src/zombie_types.opy#L1493).

## botSpawnWaypoint

Объявление: [variables.opy:303](../src/variables.opy#L303).

- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [228](../src/bots_game_in_progress.opy#L228).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [514](../src/bots_game_in_progress.opy#L514).

## botCandidateTarget

Объявление: [variables.opy:304](../src/variables.opy#L304).

- subroutines.opy — def selectTarget(): [670](../src/subroutines.opy#L670), [671](../src/subroutines.opy#L671), [675](../src/subroutines.opy#L675).

## botIsTeleportAllowed

Объявление: [variables.opy:305](../src/variables.opy#L305).

- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [72](../src/bots_game_in_progress.opy#L72), [88](../src/bots_game_in_progress.opy#L88).
- bots_game_in_progress.opy — def teleportBots(): [449](../src/bots_game_in_progress.opy#L449).

## botMutationOutlineColor

Объявление: [variables.opy:306](../src/variables.opy#L306).

- subroutines.opy — macro mutationsMacro(): [84](../src/subroutines.opy#L84), [90](../src/subroutines.opy#L90), [96](../src/subroutines.opy#L96), [101](../src/subroutines.opy#L101), [112](../src/subroutines.opy#L112), [115](../src/subroutines.opy#L115), [118](../src/subroutines.opy#L118).

## botReigniteMotionSlot

Объявление: [variables.opy:307](../src/variables.opy#L307).

Алиасы: `botReigniteSource`, `botReigniteRisePosition`.

- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [417](../src/zombie_types.opy#L417), [418](../src/zombie_types.opy#L418), [419](../src/zombie_types.opy#L419), [420](../src/zombie_types.opy#L420), [421](../src/zombie_types.opy#L421).

## botResourceIconIdList

Объявление: [variables.opy:312](../src/variables.opy#L312).

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [18](../src/players_game_in_progress.opy#L18), [19](../src/players_game_in_progress.opy#L19), [21](../src/players_game_in_progress.opy#L21), [28](../src/players_game_in_progress.opy#L28).

## isPlayerActive

Объявление: [variables.opy:315](../src/variables.opy#L315).

- subroutines.opy — def setPrematchTimer(): [486](../src/subroutines.opy#L486), [498](../src/subroutines.opy#L498).
- global_startup.opy — rule "SKIP ASSEMBLING HEROES": [140](../src/global_startup.opy#L140).
- global_start_menu.opy — def determineZombieMode(): [271](../src/global_start_menu.opy#L271).
- global_start_menu.opy — def determineChallenge(): [332](../src/global_start_menu.opy#L332).
- global_start_menu.opy — def determineObjectiveType(): [365](../src/global_start_menu.opy#L365).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [36](../src/player_start_menu.opy#L36).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [83](../src/player_start_menu.opy#L83), [85](../src/player_start_menu.opy#L85).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [68](../src/players_game_in_progress.opy#L68), [78](../src/players_game_in_progress.opy#L78), [84](../src/players_game_in_progress.opy#L84), [94](../src/players_game_in_progress.opy#L94).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [107](../src/players_game_in_progress.opy#L107).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [127](../src/players_game_in_progress.opy#L127).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [149](../src/players_game_in_progress.opy#L149).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [259](../src/players_game_in_progress.opy#L259).

## isReviving

Объявление: [variables.opy:316](../src/variables.opy#L316).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [52](../src/players_game_in_progress.opy#L52).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [119](../src/players_game_in_progress.opy#L119), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/players_game_in_progress.opy#L155), [157](../src/players_game_in_progress.opy#L157), [163](../src/players_game_in_progress.opy#L163), [179](../src/players_game_in_progress.opy#L179), [199](../src/players_game_in_progress.opy#L199).

## reviveDuration

Объявление: [variables.opy:317](../src/variables.opy#L317).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [57](../src/players_game_in_progress.opy#L57), [58](../src/players_game_in_progress.opy#L58), [74](../src/players_game_in_progress.opy#L74).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [176](../src/players_game_in_progress.opy#L176), [177](../src/players_game_in_progress.opy#L177), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## isInfected

Объявление: [variables.opy:318](../src/variables.opy#L318).

- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [39](../src/objective_types/objective_type_extraction_point.opy#L39), [40](../src/objective_types/objective_type_extraction_point.opy#L40).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [55](../src/players_game_in_progress.opy#L55).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/players_game_in_progress.opy#L115).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [134](../src/players_game_in_progress.opy#L134).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [219](../src/players_game_in_progress.opy#L219), [221](../src/players_game_in_progress.opy#L221).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [242](../src/players_game_in_progress.opy#L242), [245](../src/players_game_in_progress.opy#L245).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398), [399](../src/bots_game_in_progress.opy#L399), [400](../src/bots_game_in_progress.opy#L400).
- supply_drops.opy — def powerUpUsage(): [454](../src/supply_drops.opy#L454).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [81](../src/enhancements.opy#L81).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [369](../src/enhancements.opy#L369).

## rescueTimeRemaining

Объявление: [variables.opy:319](../src/variables.opy#L319).

- subroutines.opy — macro botStatManagementMacro(): [45](../src/subroutines.opy#L45).
- global_game_in_progress.opy — rule "OBJECTIVE COMPLETE": [133](../src/global_game_in_progress.opy#L133).
- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [59](../src/players_game_in_progress.opy#L59), [72](../src/players_game_in_progress.opy#L72), [86](../src/players_game_in_progress.opy#L86).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [150](../src/players_game_in_progress.opy#L150), [154](../src/players_game_in_progress.opy#L154), [160](../src/players_game_in_progress.opy#L160), [161](../src/players_game_in_progress.opy#L161), [165](../src/players_game_in_progress.opy#L165), [166](../src/players_game_in_progress.opy#L166), [168](../src/players_game_in_progress.opy#L168), [171](../src/players_game_in_progress.opy#L171), [182](../src/players_game_in_progress.opy#L182), [184](../src/players_game_in_progress.opy#L184), [201](../src/players_game_in_progress.opy#L201), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).

## infectionLevel

Объявление: [variables.opy:320](../src/variables.opy#L320).

- subroutines.opy — def explosionSequence(): [764](../src/subroutines.opy#L764).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12).
- objective_types/objective_type_extraction_point.opy — rule "EXTRACTION ZONE INFECTION INCREASE" (event Team 1): [38](../src/objective_types/objective_type_extraction_point.opy#L38), [39](../src/objective_types/objective_type_extraction_point.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [60](../src/players_game_in_progress.opy#L60).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [133](../src/players_game_in_progress.opy#L133).
- players_game_in_progress.opy — rule "PLAYER PICKS UP HEALTH PACK" (event Team 1): [218](../src/players_game_in_progress.opy#L218), [220](../src/players_game_in_progress.opy#L220).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [244](../src/players_game_in_progress.opy#L244), [246](../src/players_game_in_progress.opy#L246).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398), [399](../src/bots_game_in_progress.opy#L399).
- supply_drops.opy — def powerUpUsage(): [453](../src/supply_drops.opy#L453), [455](../src/supply_drops.opy#L455), [490](../src/supply_drops.opy#L490).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/enhancements.opy#L29), [36](../src/enhancements.opy#L36).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [167](../src/enhancements.opy#L167), [171](../src/enhancements.opy#L171).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [370](../src/enhancements.opy#L370), [372](../src/enhancements.opy#L372), [373](../src/enhancements.opy#L373), [375](../src/enhancements.opy#L375), [376](../src/enhancements.opy#L376).

## team1PositionSlot

Объявление: [variables.opy:321](../src/variables.opy#L321).

Алиасы: `pregamePosition`, `rescueStartPosition`.

- global_start_menu.opy — rule "EFFECTS/TEXTS": [70](../src/global_start_menu.opy#L70), [72](../src/global_start_menu.opy#L72), [74](../src/global_start_menu.opy#L74).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [26](../src/player_start_menu.opy#L26), [28](../src/player_start_menu.opy#L28).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/player_start_menu.opy#L40), [43](../src/player_start_menu.opy#L43), [45](../src/player_start_menu.opy#L45), [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49), [51](../src/player_start_menu.opy#L51), [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [73](../src/player_start_menu.opy#L73), [75](../src/player_start_menu.opy#L75), [79](../src/player_start_menu.opy#L79).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [223](../src/player_start_menu.opy#L223), [227](../src/player_start_menu.opy#L227), [229](../src/player_start_menu.opy#L229).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [36](../src/objective_types/objective_type_survivor_rescue.opy#L36), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).

## extractionDestination

Объявление: [variables.opy:326](../src/variables.opy#L326).

- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).

## invisibilityCount

Объявление: [variables.opy:327](../src/variables.opy#L327).

- subroutines.opy — def selectTarget(): [667](../src/subroutines.opy#L667).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [78](../src/player_start_menu.opy#L78).
- objective_types/objective_type_showdown.opy — rule "PLAYERS ON OBJECTIVE CONTROL": [8](../src/objective_types/objective_type_showdown.opy#L8).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [134](../src/objective_types/objective_type_biomorphing.opy#L134).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [82](../src/objective_types/objective_type_survivor_rescue.opy#L82), [88](../src/objective_types/objective_type_survivor_rescue.opy#L88).
- objective_types/objective_type_satellite_uplink.opy — rule "PLAYERS AT TERMINALS CONTROLS" (event Team 1): [105](../src/objective_types/objective_type_satellite_uplink.opy#L105).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [40](../src/players_game_in_progress.opy#L40).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [155](../src/players_game_in_progress.opy#L155), [156](../src/players_game_in_progress.opy#L156).
- hero_tuning.opy — rule "SOMBRA USES TRANSLOCATOR" (event Team 1): [22](../src/hero_tuning.opy#L22), [24](../src/hero_tuning.opy#L24).
- hero_tuning.opy — rule "DOOMFIST INVIS WHILE ULTING" (event Team 1): [34](../src/hero_tuning.opy#L34), [36](../src/hero_tuning.opy#L36).
- hero_tuning.opy — rule "MOIRA & VENTURE INVIS WHILE USING SKILL" (event Team 1): [46](../src/hero_tuning.opy#L46), [48](../src/hero_tuning.opy#L48).
- hero_tuning.opy — rule "TRACER INVIS WHILE RECALLING" (event Team 1): [58](../src/hero_tuning.opy#L58), [60](../src/hero_tuning.opy#L60).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [190](../src/bots_game_in_progress.opy#L190).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [240](../src/bots_game_in_progress.opy#L240), [241](../src/bots_game_in_progress.opy#L241).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [267](../src/bots_game_in_progress.opy#L267).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [447](../src/zombie_types.opy#L447).
- supply_drops.opy — def cloakingDevice(): [299](../src/supply_drops.opy#L299), [300](../src/supply_drops.opy#L300), [312](../src/supply_drops.opy#L312), [316](../src/supply_drops.opy#L316).

## infectionDamageOverTimeId

Объявление: [variables.opy:328](../src/variables.opy#L328).

- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [248](../src/players_game_in_progress.opy#L248).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [170](../src/enhancements.opy#L170).

## reconnectUserIndex

Объявление: [variables.opy:329](../src/variables.opy#L329).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [71](../src/players_game_in_progress.opy#L71), [72](../src/players_game_in_progress.opy#L72), [73](../src/players_game_in_progress.opy#L73), [74](../src/players_game_in_progress.opy#L74), [75](../src/players_game_in_progress.opy#L75), [79](../src/players_game_in_progress.opy#L79), [80](../src/players_game_in_progress.opy#L80), [85](../src/players_game_in_progress.opy#L85).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [368](../src/players_game_in_progress.opy#L368), [370](../src/players_game_in_progress.opy#L370).

## isAfk

Объявление: [variables.opy:330](../src/variables.opy#L330).

- objective_types/objective_type_extraction_point.opy — rule "WIN/LOSS CONDITIONS": [71](../src/objective_types/objective_type_extraction_point.opy#L71).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [138](../src/objective_types/objective_type_biomorphing.opy#L138).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [44](../src/players_game_in_progress.opy#L44).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [269](../src/players_game_in_progress.opy#L269), [273](../src/players_game_in_progress.opy#L273), [281](../src/players_game_in_progress.opy#L281), [282](../src/players_game_in_progress.opy#L282).
- players_game_in_progress.opy — rule "PLAYER TARGET (ADD)" (event Team 1): [330](../src/players_game_in_progress.opy#L330).

## isHeroSwitchRespawn

Объявление: [variables.opy:331](../src/variables.opy#L331).

- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [45](../src/players_game_in_progress.opy#L45).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [111](../src/players_game_in_progress.opy#L111).
- players_game_in_progress.opy — rule "PLAYER SWITCHES HERO" (event Team 1): [301](../src/players_game_in_progress.opy#L301).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [10](../src/enhancements.opy#L10).

## enhancementId

Объявление: [variables.opy:334](../src/variables.opy#L334).

- global_start_menu.opy — rule "EFFECTS/TEXTS": [175](../src/global_start_menu.opy#L175), [188](../src/global_start_menu.opy#L188), [201](../src/global_start_menu.opy#L201), [205](../src/global_start_menu.opy#L205), [206](../src/global_start_menu.opy#L206), [207](../src/global_start_menu.opy#L207).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [15](../src/player_start_menu.opy#L15).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [53](../src/player_start_menu.opy#L53).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [88](../src/player_start_menu.opy#L88).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (MELEE , ENHANCEMENT SELECTION)" (event Team 1): [193](../src/player_start_menu.opy#L193), [194](../src/player_start_menu.opy#L194), [195](../src/player_start_menu.opy#L195), [197](../src/player_start_menu.opy#L197), [198](../src/player_start_menu.opy#L198), [199](../src/player_start_menu.opy#L199).
- global_game_in_progress.opy — rule "EFFECTS/TEXTS": [12](../src/global_game_in_progress.opy#L12), [14](../src/global_game_in_progress.opy#L14), [16](../src/global_game_in_progress.opy#L16).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [40](../src/objective_types/objective_type_survivor_rescue.opy#L40).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [115](../src/players_game_in_progress.opy#L115), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER INFECTION DAMAGE MANAGEMENT" (event Team 1): [246](../src/players_game_in_progress.opy#L246), [247](../src/players_game_in_progress.opy#L247).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [398](../src/bots_game_in_progress.opy#L398).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [12](../src/enhancements.opy#L12), [15](../src/enhancements.opy#L15), [17](../src/enhancements.opy#L17), [26](../src/enhancements.opy#L26), [38](../src/enhancements.opy#L38).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [163](../src/enhancements.opy#L163).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [182](../src/enhancements.opy#L182).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [220](../src/enhancements.opy#L220).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [269](../src/enhancements.opy#L269).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [280](../src/enhancements.opy#L280).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [292](../src/enhancements.opy#L292).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [314](../src/enhancements.opy#L314).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [323](../src/enhancements.opy#L323).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [367](../src/enhancements.opy#L367), [372](../src/enhancements.opy#L372).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [386](../src/enhancements.opy#L386).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [415](../src/enhancements.opy#L415).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [436](../src/enhancements.opy#L436).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [487](../src/enhancements.opy#L487).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [510](../src/enhancements.opy#L510).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [542](../src/enhancements.opy#L542).

## enhancementStateSlot1

Объявление: [variables.opy:335](../src/variables.opy#L335).

Алиасы: `enhancementHybridCooldown`, `enhancementBarrierFacing`, `enhancementPyroHitList`, `enhancementPlagueCureTotal`, `enhancementIsBattleResetReady`, `enhancementBatteryPosition`, `enhancementHitchhikerCarrier`, `enhancementPupColor`.

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [41](../src/objective_types/objective_type_survivor_rescue.opy#L41).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [29](../src/enhancements.opy#L29), [73](../src/enhancements.opy#L73), [79](../src/enhancements.opy#L79), [82](../src/enhancements.opy#L82), [89](../src/enhancements.opy#L89), [90](../src/enhancements.opy#L90), [103](../src/enhancements.opy#L103), [105](../src/enhancements.opy#L105), [107](../src/enhancements.opy#L107), [109](../src/enhancements.opy#L109), [119](../src/enhancements.opy#L119), [121](../src/enhancements.opy#L121), [122](../src/enhancements.opy#L122), [123](../src/enhancements.opy#L123), [134](../src/enhancements.opy#L134), [143](../src/enhancements.opy#L143), [145](../src/enhancements.opy#L145), [151](../src/enhancements.opy#L151).
- enhancements.opy — rule "ZOMBIE HYBRID" (event Team 1): [166](../src/enhancements.opy#L166), [172](../src/enhancements.opy#L172), [173](../src/enhancements.opy#L173), [175](../src/enhancements.opy#L175).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [204](../src/enhancements.opy#L204).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [236](../src/enhancements.opy#L236).
- enhancements.opy — rule "PYROTECHNIC SETS ENEMIES ON FIRE" (event Team 1): [286](../src/enhancements.opy#L286).
- enhancements.opy — rule "PYROTECHNIC APPLIES DAMAGE" (event Team 1): [293](../src/enhancements.opy#L293), [295](../src/enhancements.opy#L295), [297](../src/enhancements.opy#L297), [300](../src/enhancements.opy#L300), [305](../src/enhancements.opy#L305).
- enhancements.opy — rule "BORN TO BATTLE PLAYER EARNS ELIMINATION" (event Team 1): [315](../src/enhancements.opy#L315), [317](../src/enhancements.opy#L317).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [324](../src/enhancements.opy#L324), [342](../src/enhancements.opy#L342), [349](../src/enhancements.opy#L349), [357](../src/enhancements.opy#L357), [361](../src/enhancements.opy#L361).
- enhancements.opy — rule "PLAGUE DOCTOR REDUCES PLAYERS' INFECTION LEVELS" (event Team 1): [371](../src/enhancements.opy#L371), [374](../src/enhancements.opy#L374), [377](../src/enhancements.opy#L377).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [399](../src/enhancements.opy#L399), [402](../src/enhancements.opy#L402), [403](../src/enhancements.opy#L403).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [416](../src/enhancements.opy#L416), [417](../src/enhancements.opy#L417), [420](../src/enhancements.opy#L420), [422](../src/enhancements.opy#L422).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [437](../src/enhancements.opy#L437), [443](../src/enhancements.opy#L443), [445](../src/enhancements.opy#L445), [447](../src/enhancements.opy#L447), [455](../src/enhancements.opy#L455), [457](../src/enhancements.opy#L457), [459](../src/enhancements.opy#L459), [461](../src/enhancements.opy#L461), [462](../src/enhancements.opy#L462), [466](../src/enhancements.opy#L466), [468](../src/enhancements.opy#L468).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [490](../src/enhancements.opy#L490), [492](../src/enhancements.opy#L492), [495](../src/enhancements.opy#L495), [497](../src/enhancements.opy#L497), [499](../src/enhancements.opy#L499).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [527](../src/enhancements.opy#L527).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [548](../src/enhancements.opy#L548), [558](../src/enhancements.opy#L558), [576](../src/enhancements.opy#L576), [583](../src/enhancements.opy#L583), [598](../src/enhancements.opy#L598).

## enhancementStateSlot2

Объявление: [variables.opy:352](../src/variables.opy#L352).

Алиасы: `enhancementBarrierEdgeDirection`, `enhancementBattleAbilityButton`, `enhancementBatteryReuseCooldown`, `enhancementHitchhikerPassengerPoolId`, `enhancementIsPupBeamActive`.

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [42](../src/objective_types/objective_type_survivor_rescue.opy#L42).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [105](../src/enhancements.opy#L105), [107](../src/enhancements.opy#L107), [109](../src/enhancements.opy#L109), [141](../src/enhancements.opy#L141), [145](../src/enhancements.opy#L145), [147](../src/enhancements.opy#L147), [153](../src/enhancements.opy#L153).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/enhancements.opy#L230), [234](../src/enhancements.opy#L234).
- enhancements.opy — rule "BORN TO BATTLE PLAYER USES ABILITY CHARGE" (event Team 1): [328](../src/enhancements.opy#L328), [330](../src/enhancements.opy#L330), [332](../src/enhancements.opy#L332), [334](../src/enhancements.opy#L334), [336](../src/enhancements.opy#L336), [338](../src/enhancements.opy#L338), [341](../src/enhancements.opy#L341), [345](../src/enhancements.opy#L345), [348](../src/enhancements.opy#L348), [353](../src/enhancements.opy#L353), [356](../src/enhancements.opy#L356), [359](../src/enhancements.opy#L359), [360](../src/enhancements.opy#L360).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [405](../src/enhancements.opy#L405).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [425](../src/enhancements.opy#L425), [426](../src/enhancements.opy#L426), [428](../src/enhancements.opy#L428).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [458](../src/enhancements.opy#L458), [469](../src/enhancements.opy#L469).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [529](../src/enhancements.opy#L529).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [550](../src/enhancements.opy#L550), [560](../src/enhancements.opy#L560), [578](../src/enhancements.opy#L578), [585](../src/enhancements.opy#L585), [600](../src/enhancements.opy#L600).

## enhancementStateSlot3

Объявление: [variables.opy:363](../src/variables.opy#L363).

Алиасы: `enhancementBarrierPlacementCooldown`, `enhancementBatteryReuseDuration`, `enhancementPupTarget`.

- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/enhancements.opy#L48), [50](../src/enhancements.opy#L50), [109](../src/enhancements.opy#L109), [110](../src/enhancements.opy#L110), [145](../src/enhancements.opy#L145), [149](../src/enhancements.opy#L149), [155](../src/enhancements.opy#L155).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [185](../src/enhancements.opy#L185), [211](../src/enhancements.opy#L211), [212](../src/enhancements.opy#L212), [214](../src/enhancements.opy#L214).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [425](../src/enhancements.opy#L425).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [514](../src/enhancements.opy#L514), [518](../src/enhancements.opy#L518), [519](../src/enhancements.opy#L519), [521](../src/enhancements.opy#L521), [531](../src/enhancements.opy#L531).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [543](../src/enhancements.opy#L543), [546](../src/enhancements.opy#L546), [553](../src/enhancements.opy#L553), [555](../src/enhancements.opy#L555), [556](../src/enhancements.opy#L556), [564](../src/enhancements.opy#L564), [566](../src/enhancements.opy#L566), [569](../src/enhancements.opy#L569), [570](../src/enhancements.opy#L570), [571](../src/enhancements.opy#L571), [574](../src/enhancements.opy#L574), [586](../src/enhancements.opy#L586), [590](../src/enhancements.opy#L590), [591](../src/enhancements.opy#L591), [592](../src/enhancements.opy#L592), [593](../src/enhancements.opy#L593), [603](../src/enhancements.opy#L603).

## enhancementStateSlot4

Объявление: [variables.opy:370](../src/variables.opy#L370).

Алиасы: `enhancementBarrierPosition`, `enhancementBatteryPlacementCooldown`, `enhancementIsPupFreezeAuraActive`.

- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [60](../src/enhancements.opy#L60), [99](../src/enhancements.opy#L99), [101](../src/enhancements.opy#L101), [149](../src/enhancements.opy#L149), [157](../src/enhancements.opy#L157).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [198](../src/enhancements.opy#L198), [200](../src/enhancements.opy#L200), [202](../src/enhancements.opy#L202), [207](../src/enhancements.opy#L207), [208](../src/enhancements.opy#L208).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [224](../src/enhancements.opy#L224), [226](../src/enhancements.opy#L226), [228](../src/enhancements.opy#L228), [234](../src/enhancements.opy#L234), [236](../src/enhancements.opy#L236), [247](../src/enhancements.opy#L247), [250](../src/enhancements.opy#L250).
- enhancements.opy — rule "CHARGE BATTERY" (event Team 1): [389](../src/enhancements.opy#L389), [401](../src/enhancements.opy#L401), [406](../src/enhancements.opy#L406), [408](../src/enhancements.opy#L408).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [533](../src/enhancements.opy#L533).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [552](../src/enhancements.opy#L552), [562](../src/enhancements.opy#L562), [580](../src/enhancements.opy#L580).

## enhancementPositionSlot

Объявление: [variables.opy:377](../src/variables.opy#L377).

Алиасы: `enhancementBarrierCorner1`, `enhancementPupPosition`.

- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [54](../src/enhancements.opy#L54), [58](../src/enhancements.opy#L58), [136](../src/enhancements.opy#L136), [138](../src/enhancements.opy#L138), [143](../src/enhancements.opy#L143), [145](../src/enhancements.opy#L145), [147](../src/enhancements.opy#L147).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [200](../src/enhancements.opy#L200), [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [230](../src/enhancements.opy#L230), [234](../src/enhancements.opy#L234).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [520](../src/enhancements.opy#L520), [525](../src/enhancements.opy#L525), [536](../src/enhancements.opy#L536).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [546](../src/enhancements.opy#L546), [553](../src/enhancements.opy#L553), [588](../src/enhancements.opy#L588), [592](../src/enhancements.opy#L592), [601](../src/enhancements.opy#L601).

## enhancementStateSlot6

Объявление: [variables.opy:382](../src/variables.opy#L382).

Алиасы: `enhancementBarrierCorner2`, `enhancementPupCooldown`.

- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [52](../src/enhancements.opy#L52), [56](../src/enhancements.opy#L56), [58](../src/enhancements.opy#L58), [134](../src/enhancements.opy#L134), [139](../src/enhancements.opy#L139), [141](../src/enhancements.opy#L141).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [202](../src/enhancements.opy#L202), [206](../src/enhancements.opy#L206).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [512](../src/enhancements.opy#L512).
- enhancements.opy — rule "P.U.P. CONTROL" (event Team 1): [568](../src/enhancements.opy#L568), [595](../src/enhancements.opy#L595).

## enhancementBarrierHealth

Объявление: [variables.opy:387](../src/variables.opy#L387).

- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [48](../src/enhancements.opy#L48), [54](../src/enhancements.opy#L54), [56](../src/enhancements.opy#L56), [58](../src/enhancements.opy#L58), [60](../src/enhancements.opy#L60).
- enhancements.opy — rule "LASER BARRICADE (PLACEMENT)" (event Team 1): [196](../src/enhancements.opy#L196).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [222](../src/enhancements.opy#L222), [232](../src/enhancements.opy#L232), [242](../src/enhancements.opy#L242), [254](../src/enhancements.opy#L254), [259](../src/enhancements.opy#L259), [260](../src/enhancements.opy#L260), [261](../src/enhancements.opy#L261).

## enhancementHitchhikerPassenger

Объявление: [variables.opy:388](../src/variables.opy#L388).

- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [397](../src/bots_game_in_progress.opy#L397).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [459](../src/enhancements.opy#L459), [466](../src/enhancements.opy#L466).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [476](../src/enhancements.opy#L476), [478](../src/enhancements.opy#L478), [480](../src/enhancements.opy#L480).

## enhancementHitchhikerCarrierPoolId

Объявление: [variables.opy:389](../src/variables.opy#L389).

- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [479](../src/enhancements.opy#L479), [481](../src/enhancements.opy#L481).

## powerUpForceFieldTimeRemaining

Объявление: [variables.opy:392](../src/variables.opy#L392).

- supply_drops.opy — def playerForceField(): [145](../src/supply_drops.opy#L145), [150](../src/supply_drops.opy#L150).

## powerUpReviveTarget

Объявление: [variables.opy:393](../src/variables.opy#L393).

- supply_drops.opy — def instantRevive(): [129](../src/supply_drops.opy#L129), [131](../src/supply_drops.opy#L131), [132](../src/supply_drops.opy#L132), [133](../src/supply_drops.opy#L133), [135](../src/supply_drops.opy#L135).

## powerUpItemId

Объявление: [variables.opy:394](../src/variables.opy#L394).

- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [102](../src/supply_drops.opy#L102), [108](../src/supply_drops.opy#L108), [121](../src/supply_drops.opy#L121).
- supply_drops.opy — def powerUpUsage(): [448](../src/supply_drops.opy#L448), [521](../src/supply_drops.opy#L521).
- power_ups.opy — rule "EFFECT/TEXT (PERMANENT)": [32](../src/power_ups.opy#L32).
- power_ups.opy — rule "PLAYER DROPS POWER UP (MANUAL)" (event Team 1): [79](../src/power_ups.opy#L79), [82](../src/power_ups.opy#L82), [85](../src/power_ups.opy#L85).
- power_ups.opy — rule "PLAYER DROPS POWER UP (DEATH)" (event Team 1): [92](../src/power_ups.opy#L92), [96](../src/power_ups.opy#L96), [99](../src/power_ups.opy#L99).

## powerUpTradeDataList

Объявление: [variables.opy:395](../src/variables.opy#L395).

- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [100](../src/supply_drops.opy#L100), [102](../src/supply_drops.opy#L102), [105](../src/supply_drops.opy#L105), [118](../src/supply_drops.opy#L118), [119](../src/supply_drops.opy#L119), [120](../src/supply_drops.opy#L120).

## powerUpEntityIdList

Объявление: [variables.opy:396](../src/variables.opy#L396).

- supply_drops.opy — def playerForceField(): [142](../src/supply_drops.opy#L142), [144](../src/supply_drops.opy#L144), [146](../src/supply_drops.opy#L146), [156](../src/supply_drops.opy#L156), [157](../src/supply_drops.opy#L157).
- supply_drops.opy — def noCooldowns(): [166](../src/supply_drops.opy#L166), [168](../src/supply_drops.opy#L168), [186](../src/supply_drops.opy#L186), [187](../src/supply_drops.opy#L187).
- supply_drops.opy — def airStrike(): [197](../src/supply_drops.opy#L197), [199](../src/supply_drops.opy#L199), [201](../src/supply_drops.opy#L201), [220](../src/supply_drops.opy#L220), [221](../src/supply_drops.opy#L221), [222](../src/supply_drops.opy#L222).
- supply_drops.opy — def healBeacon(): [229](../src/supply_drops.opy#L229), [231](../src/supply_drops.opy#L231), [233](../src/supply_drops.opy#L233), [235](../src/supply_drops.opy#L235), [237](../src/supply_drops.opy#L237), [246](../src/supply_drops.opy#L246), [247](../src/supply_drops.opy#L247), [248](../src/supply_drops.opy#L248), [249](../src/supply_drops.opy#L249).
- supply_drops.opy — def sentryTurret(): [258](../src/supply_drops.opy#L258), [260](../src/supply_drops.opy#L260), [264](../src/supply_drops.opy#L264), [266](../src/supply_drops.opy#L266), [268](../src/supply_drops.opy#L268), [284](../src/supply_drops.opy#L284), [285](../src/supply_drops.opy#L285).
- supply_drops.opy — def cloakingDevice(): [292](../src/supply_drops.opy#L292), [296](../src/supply_drops.opy#L296), [298](../src/supply_drops.opy#L298), [313](../src/supply_drops.opy#L313), [314](../src/supply_drops.opy#L314), [315](../src/supply_drops.opy#L315).
- supply_drops.opy — def superNano(): [325](../src/supply_drops.opy#L325), [329](../src/supply_drops.opy#L329), [331](../src/supply_drops.opy#L331), [333](../src/supply_drops.opy#L333), [335](../src/supply_drops.opy#L335), [337](../src/supply_drops.opy#L337), [347](../src/supply_drops.opy#L347), [348](../src/supply_drops.opy#L348), [349](../src/supply_drops.opy#L349), [350](../src/supply_drops.opy#L350), [351](../src/supply_drops.opy#L351), [354](../src/supply_drops.opy#L354).
- supply_drops.opy — def bouncePad(): [363](../src/supply_drops.opy#L363), [365](../src/supply_drops.opy#L365), [367](../src/supply_drops.opy#L367), [389](../src/supply_drops.opy#L389), [390](../src/supply_drops.opy#L390), [391](../src/supply_drops.opy#L391).
- supply_drops.opy — def ultimateCharger(): [397](../src/supply_drops.opy#L397), [399](../src/supply_drops.opy#L399), [406](../src/supply_drops.opy#L406), [407](../src/supply_drops.opy#L407).
- supply_drops.opy — def stun(): [413](../src/supply_drops.opy#L413), [416](../src/supply_drops.opy#L416), [441](../src/supply_drops.opy#L441), [442](../src/supply_drops.opy#L442).

## powerUpAirStrikeIndex

Объявление: [variables.opy:397](../src/variables.opy#L397).

- supply_drops.opy — def airStrike(): [204](../src/supply_drops.opy#L204).

## powerUpHealBeaconTimeRemaining

Объявление: [variables.opy:398](../src/variables.opy#L398).

- supply_drops.opy — def healBeacon(): [234](../src/supply_drops.opy#L234), [242](../src/supply_drops.opy#L242).

## powerUpTurretTimeRemaining

Объявление: [variables.opy:399](../src/variables.opy#L399).

- supply_drops.opy — def sentryTurret(): [267](../src/supply_drops.opy#L267), [272](../src/supply_drops.opy#L272).

## powerUpCloakTimeRemaining

Объявление: [variables.opy:400](../src/variables.opy#L400).

- supply_drops.opy — def cloakingDevice(): [297](../src/supply_drops.opy#L297), [305](../src/supply_drops.opy#L305), [306](../src/supply_drops.opy#L306), [311](../src/supply_drops.opy#L311).

## powerUpSuperNanoTimeRemaining

Объявление: [variables.opy:401](../src/variables.opy#L401).

- supply_drops.opy — def superNano(): [330](../src/supply_drops.opy#L330), [342](../src/supply_drops.opy#L342).

## powerUpUltimateTimeRemaining

Объявление: [variables.opy:402](../src/variables.opy#L402).

- supply_drops.opy — def ultimateCharger(): [398](../src/supply_drops.opy#L398), [402](../src/supply_drops.opy#L402).

## powerUpStunBouncesRemaining

Объявление: [variables.opy:403](../src/variables.opy#L403).

- supply_drops.opy — def stun(): [426](../src/supply_drops.opy#L426), [428](../src/supply_drops.opy#L428), [429](../src/supply_drops.opy#L429).

## powerUpStunBeamPosition

Объявление: [variables.opy:404](../src/variables.opy#L404).

- supply_drops.opy — def stun(): [415](../src/supply_drops.opy#L415), [419](../src/supply_drops.opy#L419), [424](../src/supply_drops.opy#L424), [431](../src/supply_drops.opy#L431), [440](../src/supply_drops.opy#L440).

## powerUpTurretPosition

Объявление: [variables.opy:405](../src/variables.opy#L405).

- supply_drops.opy — def sentryTurret(): [257](../src/supply_drops.opy#L257), [259](../src/supply_drops.opy#L259), [263](../src/supply_drops.opy#L263), [265](../src/supply_drops.opy#L265), [269](../src/supply_drops.opy#L269), [270](../src/supply_drops.opy#L270), [273](../src/supply_drops.opy#L273), [274](../src/supply_drops.opy#L274), [276](../src/supply_drops.opy#L276), [277](../src/supply_drops.opy#L277), [278](../src/supply_drops.opy#L278), [280](../src/supply_drops.opy#L280), [286](../src/supply_drops.opy#L286).

## powerUpStunTarget

Объявление: [variables.opy:406](../src/variables.opy#L406).

- supply_drops.opy — def stun(): [423](../src/supply_drops.opy#L423), [424](../src/supply_drops.opy#L424), [427](../src/supply_drops.opy#L427), [431](../src/supply_drops.opy#L431), [432](../src/supply_drops.opy#L432), [433](../src/supply_drops.opy#L433), [434](../src/supply_drops.opy#L434), [437](../src/supply_drops.opy#L437), [439](../src/supply_drops.opy#L439).

## powerUpHealBeaconPosition

Объявление: [variables.opy:407](../src/variables.opy#L407).

- supply_drops.opy — def healBeacon(): [228](../src/supply_drops.opy#L228), [230](../src/supply_drops.opy#L230), [232](../src/supply_drops.opy#L232), [238](../src/supply_drops.opy#L238), [239](../src/supply_drops.opy#L239), [244](../src/supply_drops.opy#L244), [245](../src/supply_drops.opy#L245), [251](../src/supply_drops.opy#L251).

## powerUpForceFieldPosition

Объявление: [variables.opy:408](../src/variables.opy#L408).

- supply_drops.opy — def playerForceField(): [141](../src/supply_drops.opy#L141), [143](../src/supply_drops.opy#L143), [147](../src/supply_drops.opy#L147), [148](../src/supply_drops.opy#L148), [153](../src/supply_drops.opy#L153), [154](../src/supply_drops.opy#L154), [158](../src/supply_drops.opy#L158).

## powerUpBouncePadPosition

Объявление: [variables.opy:409](../src/variables.opy#L409).

- supply_drops.opy — def bouncePad(): [362](../src/supply_drops.opy#L362), [364](../src/supply_drops.opy#L364), [368](../src/supply_drops.opy#L368), [369](../src/supply_drops.opy#L369), [374](../src/supply_drops.opy#L374), [377](../src/supply_drops.opy#L377), [386](../src/supply_drops.opy#L386).

## powerUpStunOrigin

Объявление: [variables.opy:410](../src/variables.opy#L410).

- supply_drops.opy — def stun(): [415](../src/supply_drops.opy#L415), [421](../src/supply_drops.opy#L421), [428](../src/supply_drops.opy#L428), [429](../src/supply_drops.opy#L429), [437](../src/supply_drops.opy#L437), [439](../src/supply_drops.opy#L439).

## powerUpTurretDirection

Объявление: [variables.opy:411](../src/variables.opy#L411).

- supply_drops.opy — def sentryTurret(): [265](../src/supply_drops.opy#L265), [274](../src/supply_drops.opy#L274), [276](../src/supply_drops.opy#L276), [277](../src/supply_drops.opy#L277), [278](../src/supply_drops.opy#L278).

## powerUpAirStrikePosition

Объявление: [variables.opy:412](../src/variables.opy#L412).

- supply_drops.opy — def airStrike(): [196](../src/supply_drops.opy#L196), [198](../src/supply_drops.opy#L198), [200](../src/supply_drops.opy#L200), [207](../src/supply_drops.opy#L207).

## powerUpTradeIndex

Объявление: [variables.opy:413](../src/variables.opy#L413).

- supply_drops.opy — rule "PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)" (event Team 1): [105](../src/supply_drops.opy#L105), [108](../src/supply_drops.opy#L108), [109](../src/supply_drops.opy#L109), [110](../src/supply_drops.opy#L110), [112](../src/supply_drops.opy#L112), [113](../src/supply_drops.opy#L113), [114](../src/supply_drops.opy#L114), [115](../src/supply_drops.opy#L115).

## pregameVoteList

Объявление: [variables.opy:416](../src/variables.opy#L416).

- global_start_menu.opy — rule "EFFECTS/TEXTS": [81](../src/global_start_menu.opy#L81), [89](../src/global_start_menu.opy#L89), [97](../src/global_start_menu.opy#L97), [98](../src/global_start_menu.opy#L98), [101](../src/global_start_menu.opy#L101), [102](../src/global_start_menu.opy#L102), [103](../src/global_start_menu.opy#L103), [109](../src/global_start_menu.opy#L109), [118](../src/global_start_menu.opy#L118), [127](../src/global_start_menu.opy#L127), [128](../src/global_start_menu.opy#L128), [131](../src/global_start_menu.opy#L131), [132](../src/global_start_menu.opy#L132), [133](../src/global_start_menu.opy#L133), [139](../src/global_start_menu.opy#L139), [151](../src/global_start_menu.opy#L151), [163](../src/global_start_menu.opy#L163), [164](../src/global_start_menu.opy#L164), [167](../src/global_start_menu.opy#L167), [168](../src/global_start_menu.opy#L168), [169](../src/global_start_menu.opy#L169).
- global_start_menu.opy — rule "END VOTING": [241](../src/global_start_menu.opy#L241), [242](../src/global_start_menu.opy#L242), [243](../src/global_start_menu.opy#L243).
- global_start_menu.opy — def determineZombieMode(): [271](../src/global_start_menu.opy#L271).
- global_start_menu.opy — def determineChallenge(): [332](../src/global_start_menu.opy#L332), [342](../src/global_start_menu.opy#L342).
- global_start_menu.opy — def determineObjectiveType(): [365](../src/global_start_menu.opy#L365).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [18](../src/player_start_menu.opy#L18), [23](../src/player_start_menu.opy#L23), [24](../src/player_start_menu.opy#L24), [25](../src/player_start_menu.opy#L25).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [88](../src/player_start_menu.opy#L88).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [136](../src/player_start_menu.opy#L136), [137](../src/player_start_menu.opy#L137), [138](../src/player_start_menu.opy#L138), [140](../src/player_start_menu.opy#L140), [141](../src/player_start_menu.opy#L141), [142](../src/player_start_menu.opy#L142).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [156](../src/player_start_menu.opy#L156), [157](../src/player_start_menu.opy#L157), [158](../src/player_start_menu.opy#L158), [160](../src/player_start_menu.opy#L160), [161](../src/player_start_menu.opy#L161), [162](../src/player_start_menu.opy#L162).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [176](../src/player_start_menu.opy#L176), [177](../src/player_start_menu.opy#L177), [178](../src/player_start_menu.opy#L178), [180](../src/player_start_menu.opy#L180), [181](../src/player_start_menu.opy#L181), [182](../src/player_start_menu.opy#L182).

## pregameState

Объявление: [variables.opy:417](../src/variables.opy#L417).

- subroutines.opy — def setPrematchTimer(): [484](../src/subroutines.opy#L484), [486](../src/subroutines.opy#L486), [491](../src/subroutines.opy#L491), [494](../src/subroutines.opy#L494), [498](../src/subroutines.opy#L498).
- global_start_menu.opy — rule "EFFECTS/TEXTS": [66](../src/global_start_menu.opy#L66), [68](../src/global_start_menu.opy#L68), [70](../src/global_start_menu.opy#L70), [72](../src/global_start_menu.opy#L72), [74](../src/global_start_menu.opy#L74).
- global_start_menu.opy — rule "END VOTING": [235](../src/global_start_menu.opy#L235).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [19](../src/player_start_menu.opy#L19).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [40](../src/player_start_menu.opy#L40), [43](../src/player_start_menu.opy#L43), [45](../src/player_start_menu.opy#L45), [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49), [51](../src/player_start_menu.opy#L51).
- player_start_menu.opy — rule "PLAYER SELECTS/RESELECTS HERO" (event Team 1): [61](../src/player_start_menu.opy#L61), [81](../src/player_start_menu.opy#L81).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [98](../src/player_start_menu.opy#L98), [104](../src/player_start_menu.opy#L104), [105](../src/player_start_menu.opy#L105), [106](../src/player_start_menu.opy#L106), [113](../src/player_start_menu.opy#L113), [114](../src/player_start_menu.opy#L114), [116](../src/player_start_menu.opy#L116).
- player_start_menu.opy — rule "PREVENT PLAYERS FROM LEAVING START EARLY" (event Team 1): [222](../src/player_start_menu.opy#L222).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [63](../src/players_game_in_progress.opy#L63).

## isPregameVoting

Объявление: [variables.opy:418](../src/variables.opy#L418).

- subroutines.opy — def setPrematchTimer(): [478](../src/subroutines.opy#L478), [484](../src/subroutines.opy#L484), [486](../src/subroutines.opy#L486).
- player_start_menu.opy — rule "PLAYER MENU INITIALIZATION" (event Team 1): [20](../src/player_start_menu.opy#L20).
- player_start_menu.opy — rule "EFFECTS/TEXT" (event Team 1): [47](../src/player_start_menu.opy#L47), [49](../src/player_start_menu.opy#L49).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (JUMP AND CROUCH, CHANGE HERO/READY)" (event Team 1): [118](../src/player_start_menu.opy#L118).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ULTIMATE, DIFFICULTY VOTE)" (event Team 1): [134](../src/player_start_menu.opy#L134).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 1, ZOMBIE VOTE)" (event Team 1): [154](../src/player_start_menu.opy#L154).
- player_start_menu.opy — rule "PLAYER MENU CONTROLS (ABILITY 2, OBJECTIVE TYPE VOTE)" (event Team 1): [174](../src/player_start_menu.opy#L174).
- player_start_menu.opy — rule "UPDATE PREGAME VOTING STATUS" (event Team 1): [206](../src/player_start_menu.opy#L206), [213](../src/player_start_menu.opy#L213).

## rescueMoodIcon

Объявление: [variables.opy:421](../src/variables.opy#L421).

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50), [51](../src/objective_types/objective_type_survivor_rescue.opy#L51).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [86](../src/objective_types/objective_type_survivor_rescue.opy#L86), [105](../src/objective_types/objective_type_survivor_rescue.opy#L105).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [176](../src/objective_types/objective_type_survivor_rescue.opy#L176).

## rescueLeader

Объявление: [variables.opy:422](../src/variables.opy#L422).

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [38](../src/objective_types/objective_type_survivor_rescue.opy#L38), [53](../src/objective_types/objective_type_survivor_rescue.opy#L53), [60](../src/objective_types/objective_type_survivor_rescue.opy#L60), [61](../src/objective_types/objective_type_survivor_rescue.opy#L61).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [90](../src/objective_types/objective_type_survivor_rescue.opy#L90), [102](../src/objective_types/objective_type_survivor_rescue.opy#L102).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [116](../src/objective_types/objective_type_survivor_rescue.opy#L116), [118](../src/objective_types/objective_type_survivor_rescue.opy#L118), [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [121](../src/objective_types/objective_type_survivor_rescue.opy#L121).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET LETS GO": [140](../src/objective_types/objective_type_survivor_rescue.opy#L140), [141](../src/objective_types/objective_type_survivor_rescue.opy#L141), [143](../src/objective_types/objective_type_survivor_rescue.opy#L143).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [148](../src/objective_types/objective_type_survivor_rescue.opy#L148), [151](../src/objective_types/objective_type_survivor_rescue.opy#L151), [152](../src/objective_types/objective_type_survivor_rescue.opy#L152).
- bots_game_in_progress.opy — macro botTeleportCenterMacro(): [19](../src/bots_game_in_progress.opy#L19), [22](../src/bots_game_in_progress.opy#L22).

## rescuePathList

Объявление: [variables.opy:423](../src/variables.opy#L423).

- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [35](../src/objective_types/objective_type_survivor_rescue.opy#L35), [59](../src/objective_types/objective_type_survivor_rescue.opy#L59), [61](../src/objective_types/objective_type_survivor_rescue.opy#L61).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [119](../src/objective_types/objective_type_survivor_rescue.opy#L119), [121](../src/objective_types/objective_type_survivor_rescue.opy#L121).
- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [129](../src/objective_types/objective_type_survivor_rescue.opy#L129), [131](../src/objective_types/objective_type_survivor_rescue.opy#L131), [132](../src/objective_types/objective_type_survivor_rescue.opy#L132).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [153](../src/objective_types/objective_type_survivor_rescue.opy#L153).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [181](../src/objective_types/objective_type_survivor_rescue.opy#L181).

## biomorphingResourceType

Объявление: [variables.opy:426](../src/variables.opy#L426).

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [297](../src/subroutines.opy#L297), [306](../src/subroutines.opy#L306), [309](../src/subroutines.opy#L309).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [43](../src/objective_types/objective_type_biomorphing.opy#L43), [65](../src/objective_types/objective_type_biomorphing.opy#L65).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [89](../src/objective_types/objective_type_biomorphing.opy#L89).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [117](../src/objective_types/objective_type_biomorphing.opy#L117).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [147](../src/objective_types/objective_type_biomorphing.opy#L147).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [176](../src/objective_types/objective_type_biomorphing.opy#L176), [179](../src/objective_types/objective_type_biomorphing.opy#L179).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).

## biomorphingResourceAmount

Объявление: [variables.opy:427](../src/variables.opy#L427).

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [297](../src/subroutines.opy#L297), [300](../src/subroutines.opy#L300), [309](../src/subroutines.opy#L309), [312](../src/subroutines.opy#L312).
- subroutines.opy — def objectivesManagement(): [604](../src/subroutines.opy#L604).
- objective_types/objective_type_biomorphing.opy — rule "BIOMORPHING GOAL START": [42](../src/objective_types/objective_type_biomorphing.opy#L42), [66](../src/objective_types/objective_type_biomorphing.opy#L66).
- objective_types/objective_type_biomorphing.opy — rule "ZOMBIE GETS RESOURCE VALUE/OBJECTIVE GIVES POWERUPS": [74](../src/objective_types/objective_type_biomorphing.opy#L74), [82](../src/objective_types/objective_type_biomorphing.opy#L82), [87](../src/objective_types/objective_type_biomorphing.opy#L87).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE IS PICKED UP": [105](../src/objective_types/objective_type_biomorphing.opy#L105), [124](../src/objective_types/objective_type_biomorphing.opy#L124).
- objective_types/objective_type_biomorphing.opy — rule "PLAYER DELIVERS RESOURCE VALUE" (event Team 1): [135](../src/objective_types/objective_type_biomorphing.opy#L135), [153](../src/objective_types/objective_type_biomorphing.opy#L153), [163](../src/objective_types/objective_type_biomorphing.opy#L163).
- objective_types/objective_type_biomorphing.opy — rule "BIOWASTE HOLDER DIES, ORB IS QUEUED AND RESOURCE AMOUNT REMOVED": [173](../src/objective_types/objective_type_biomorphing.opy#L173), [178](../src/objective_types/objective_type_biomorphing.opy#L178).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [24](../src/players_game_in_progress.opy#L24).

## explosionInnerColor

Объявление: [variables.opy:430](../src/variables.opy#L430).

- subroutines.opy — macro botEntityManagementMacro(): [131](../src/subroutines.opy#L131).
- subroutines.opy — def explosionSequence(): [775](../src/subroutines.opy#L775).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [32](../src/enhancements.opy#L32).

## explosionOuterColor

Объявление: [variables.opy:431](../src/variables.opy#L431).

- subroutines.opy — macro botEntityManagementMacro(): [132](../src/subroutines.opy#L132).
- subroutines.opy — def explosionSequence(): [774](../src/subroutines.opy#L774).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [33](../src/enhancements.opy#L33).

## explosionScale

Объявление: [variables.opy:432](../src/variables.opy#L432).

- subroutines.opy — def explosionSequence(): [762](../src/subroutines.opy#L762), [774](../src/subroutines.opy#L774), [775](../src/subroutines.opy#L775), [777](../src/subroutines.opy#L777), [779](../src/subroutines.opy#L779).
- zombie_types.opy — def explosionWarning(): [1469](../src/zombie_types.opy#L1469).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [31](../src/enhancements.opy#L31).

## combatTargetSlot

Объявление: [variables.opy:435](../src/variables.opy#L435).

Алиасы: `botTarget`, `enhancementBarrierTarget`, `currentCombatTarget`.

- subroutines.opy — macro botEntityManagementMacro(): [195](../src/subroutines.opy#L195).
- subroutines.opy — def selectTarget(): [675](../src/subroutines.opy#L675), [676](../src/subroutines.opy#L676).
- subroutines.opy — def restoreDefaultFacingMovement(): [684](../src/subroutines.opy#L684), [686](../src/subroutines.opy#L686), [688](../src/subroutines.opy#L688).
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
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [138](../src/bots_game_in_progress.opy#L138).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [187](../src/bots_game_in_progress.opy#L187).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [218](../src/bots_game_in_progress.opy#L218).
- bots_game_in_progress.opy — rule "BOT TARGET VISIBLE" (event Team 2): [240](../src/bots_game_in_progress.opy#L240).
- bots_game_in_progress.opy — rule "BOT TAKES DAMAGE AND SWITCHES TARGETS" (event Team 2): [253](../src/bots_game_in_progress.opy#L253), [254](../src/bots_game_in_progress.opy#L254).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [266](../src/bots_game_in_progress.opy#L266), [267](../src/bots_game_in_progress.opy#L267), [269](../src/bots_game_in_progress.opy#L269).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [282](../src/bots_game_in_progress.opy#L282).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [310](../src/bots_game_in_progress.opy#L310).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [323](../src/bots_game_in_progress.opy#L323).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [356](../src/bots_game_in_progress.opy#L356), [359](../src/bots_game_in_progress.opy#L359), [360](../src/bots_game_in_progress.opy#L360), [366](../src/bots_game_in_progress.opy#L366).
- bots_game_in_progress.opy — def enterExitTeleport(): [431](../src/bots_game_in_progress.opy#L431), [436](../src/bots_game_in_progress.opy#L436).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [23](../src/zombie_types.opy#L23), [27](../src/zombie_types.opy#L27).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [68](../src/zombie_types.opy#L68), [72](../src/zombie_types.opy#L72).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [85](../src/zombie_types.opy#L85), [91](../src/zombie_types.opy#L91).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [103](../src/zombie_types.opy#L103), [108](../src/zombie_types.opy#L108).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [161](../src/zombie_types.opy#L161), [195](../src/zombie_types.opy#L195).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [252](../src/zombie_types.opy#L252), [254](../src/zombie_types.opy#L254).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [273](../src/zombie_types.opy#L273), [274](../src/zombie_types.opy#L274).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [313](../src/zombie_types.opy#L313), [315](../src/zombie_types.opy#L315), [316](../src/zombie_types.opy#L316).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [333](../src/zombie_types.opy#L333), [334](../src/zombie_types.opy#L334), [341](../src/zombie_types.opy#L341), [353](../src/zombie_types.opy#L353), [355](../src/zombie_types.opy#L355).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [432](../src/zombie_types.opy#L432).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [463](../src/zombie_types.opy#L463).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [476](../src/zombie_types.opy#L476), [478](../src/zombie_types.opy#L478).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [489](../src/zombie_types.opy#L489), [491](../src/zombie_types.opy#L491), [493](../src/zombie_types.opy#L493), [494](../src/zombie_types.opy#L494), [495](../src/zombie_types.opy#L495), [498](../src/zombie_types.opy#L498), [507](../src/zombie_types.opy#L507).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [522](../src/zombie_types.opy#L522), [529](../src/zombie_types.opy#L529), [530](../src/zombie_types.opy#L530), [548](../src/zombie_types.opy#L548).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [583](../src/zombie_types.opy#L583), [588](../src/zombie_types.opy#L588), [589](../src/zombie_types.opy#L589), [627](../src/zombie_types.opy#L627).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [636](../src/zombie_types.opy#L636), [642](../src/zombie_types.opy#L642), [663](../src/zombie_types.opy#L663), [664](../src/zombie_types.opy#L664).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [698](../src/zombie_types.opy#L698), [703](../src/zombie_types.opy#L703), [704](../src/zombie_types.opy#L704), [718](../src/zombie_types.opy#L718).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [755](../src/zombie_types.opy#L755), [759](../src/zombie_types.opy#L759).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [818](../src/zombie_types.opy#L818), [825](../src/zombie_types.opy#L825), [829](../src/zombie_types.opy#L829), [875](../src/zombie_types.opy#L875).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [900](../src/zombie_types.opy#L900), [905](../src/zombie_types.opy#L905), [906](../src/zombie_types.opy#L906), [908](../src/zombie_types.opy#L908), [910](../src/zombie_types.opy#L910).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [923](../src/zombie_types.opy#L923), [925](../src/zombie_types.opy#L925), [928](../src/zombie_types.opy#L928), [932](../src/zombie_types.opy#L932).
- zombie_types.opy — rule "DOWNFALLEN PULLS PLAYERS" (event Team 2): [970](../src/zombie_types.opy#L970), [971](../src/zombie_types.opy#L971).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [983](../src/zombie_types.opy#L983), [986](../src/zombie_types.opy#L986), [987](../src/zombie_types.opy#L987), [988](../src/zombie_types.opy#L988).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1000](../src/zombie_types.opy#L1000), [1008](../src/zombie_types.opy#L1008), [1018](../src/zombie_types.opy#L1018), [1058](../src/zombie_types.opy#L1058), [1059](../src/zombie_types.opy#L1059), [1068](../src/zombie_types.opy#L1068), [1075](../src/zombie_types.opy#L1075).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1097](../src/zombie_types.opy#L1097), [1100](../src/zombie_types.opy#L1100), [1101](../src/zombie_types.opy#L1101), [1102](../src/zombie_types.opy#L1102), [1103](../src/zombie_types.opy#L1103).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1113](../src/zombie_types.opy#L1113).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1125](../src/zombie_types.opy#L1125), [1130](../src/zombie_types.opy#L1130).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1150](../src/zombie_types.opy#L1150), [1151](../src/zombie_types.opy#L1151), [1173](../src/zombie_types.opy#L1173).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1184](../src/zombie_types.opy#L1184), [1185](../src/zombie_types.opy#L1185), [1186](../src/zombie_types.opy#L1186).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1198](../src/zombie_types.opy#L1198), [1200](../src/zombie_types.opy#L1200).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1234](../src/zombie_types.opy#L1234).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1252](../src/zombie_types.opy#L1252).
- zombie_types.opy — rule "SMOLDER BOSS EVENT STARTS" (event Team 2): [1311](../src/zombie_types.opy#L1311).
- zombie_types.opy — rule "SUCCESSOR (DOOMFIST) HOLDS BLOCK IF TARGET USE ULTIMATE" (event Team 2): [1357](../src/zombie_types.opy#L1357), [1358](../src/zombie_types.opy#L1358).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1379](../src/zombie_types.opy#L1379), [1382](../src/zombie_types.opy#L1382), [1383](../src/zombie_types.opy#L1383).
- zombie_types.opy — def abilityThrowdown(): [1451](../src/zombie_types.opy#L1451).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [239](../src/enhancements.opy#L239), [240](../src/enhancements.opy#L240), [242](../src/enhancements.opy#L242), [243](../src/enhancements.opy#L243), [244](../src/enhancements.opy#L244), [245](../src/enhancements.opy#L245), [247](../src/enhancements.opy#L247), [250](../src/enhancements.opy#L250).
- enhancements.opy — rule "P.U.P. TARGET" (event Team 1): [515](../src/enhancements.opy#L515), [518](../src/enhancements.opy#L518).

## aiThrottleSpeedSlot

Объявление: [variables.opy:442](../src/variables.opy#L442).

Алиасы: `botThrottleSpeed`, `rescueThrottleSpeed`.

- subroutines.opy — macro botStatManagementMacro(): [39](../src/subroutines.opy#L39).
- subroutines.opy — def restoreDefaultFacingMovement(): [688](../src/subroutines.opy#L688), [690](../src/subroutines.opy#L690).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [57](../src/objective_types/objective_type_bosses.opy#L57).
- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [143](../src/objective_types/objective_type_bosses.opy#L143).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [61](../src/objective_types/objective_type_survivor_rescue.opy#L61).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [87](../src/objective_types/objective_type_survivor_rescue.opy#L87).
- objective_types/objective_type_survivor_rescue.opy — rule "CREATE PATH": [117](../src/objective_types/objective_type_survivor_rescue.opy#L117).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR JUMP": [162](../src/objective_types/objective_type_survivor_rescue.opy#L162).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [271](../src/bots_game_in_progress.opy#L271).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [288](../src/bots_game_in_progress.opy#L288), [292](../src/bots_game_in_progress.opy#L292).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [312](../src/bots_game_in_progress.opy#L312).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [333](../src/bots_game_in_progress.opy#L333).
- bots_game_in_progress.opy — def enterExitTeleport(): [433](../src/bots_game_in_progress.opy#L433), [435](../src/bots_game_in_progress.opy#L435).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [548](../src/zombie_types.opy#L548).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [766](../src/zombie_types.opy#L766), [774](../src/zombie_types.opy#L774).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [875](../src/zombie_types.opy#L875).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1075](../src/zombie_types.opy#L1075).

## recoveryTimeSlot

Объявление: [variables.opy:447](../src/variables.opy#L447).

Алиасы: `reviveTimeRemaining`, `botRespawnDelay`.

- objective_types/objective_type_bosses.opy — rule "BOSS DIES (ALL BOSS OBJECTIVES)" (event Team 2): [150](../src/objective_types/objective_type_bosses.opy#L150), [161](../src/objective_types/objective_type_bosses.opy#L161).
- objective_types/objective_type_kill_zone.opy — rule "MODIFY KILL ZONE SCORE": [10](../src/objective_types/objective_type_kill_zone.opy#L10), [15](../src/objective_types/objective_type_kill_zone.opy#L15).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [71](../src/objective_types/objective_type_zombie_egg.opy#L71).
- objective_types/objective_type_satellite_uplink.opy — macro fireSatelliteMacro(): [59](../src/objective_types/objective_type_satellite_uplink.opy#L59), [62](../src/objective_types/objective_type_satellite_uplink.opy#L62).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [58](../src/players_game_in_progress.opy#L58), [73](../src/players_game_in_progress.opy#L73).
- players_game_in_progress.opy — rule "EFFECTS/TEXTS" (event Team 1): [117](../src/players_game_in_progress.opy#L117), [121](../src/players_game_in_progress.opy#L121).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [131](../src/players_game_in_progress.opy#L131).
- players_game_in_progress.opy — rule "REVIVE PLAYER OR ADVANCE DEATH TIMER" (event Team 1): [154](../src/players_game_in_progress.opy#L154), [159](../src/players_game_in_progress.opy#L159), [175](../src/players_game_in_progress.opy#L175), [177](../src/players_game_in_progress.opy#L177), [184](../src/players_game_in_progress.opy#L184), [203](../src/players_game_in_progress.opy#L203).
- players_game_in_progress.opy — def updateUsers(): [370](../src/players_game_in_progress.opy#L370).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [66](../src/bots_game_in_progress.opy#L66).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [148](../src/bots_game_in_progress.opy#L148), [149](../src/bots_game_in_progress.opy#L149), [150](../src/bots_game_in_progress.opy#L150), [152](../src/bots_game_in_progress.opy#L152).
- supply_drops.opy — def airStrike(): [218](../src/supply_drops.opy#L218).

## isCrowdControlled

Объявление: [variables.opy:452](../src/variables.opy#L452).

- subroutines.opy — def restoreDefaultFacingMovement(): [686](../src/subroutines.opy#L686).
- subroutines.opy — def botRespawnInitialization(): [717](../src/subroutines.opy#L717).
- subroutines.opy — def abilityPlacement(): [747](../src/subroutines.opy#L747).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [98](../src/bots_game_in_progress.opy#L98).
- bots_game_in_progress.opy — rule "BOT STUN MANAGEMENT" (event Team 2): [208](../src/bots_game_in_progress.opy#L208), [212](../src/bots_game_in_progress.opy#L212).
- bots_game_in_progress.opy — rule "DESELECT BOT TARGET" (event Team 2): [273](../src/bots_game_in_progress.opy#L273).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [285](../src/bots_game_in_progress.opy#L285).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [304](../src/bots_game_in_progress.opy#L304).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [327](../src/bots_game_in_progress.opy#L327).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [357](../src/bots_game_in_progress.opy#L357), [374](../src/bots_game_in_progress.opy#L374).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [407](../src/bots_game_in_progress.opy#L407).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [24](../src/zombie_types.opy#L24).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [69](../src/zombie_types.opy#L69).
- zombie_types.opy — rule "RUSHER (TORB) SPEED MECHANICS" (event Team 2): [86](../src/zombie_types.opy#L86).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [104](../src/zombie_types.opy#L104), [113](../src/zombie_types.opy#L113), [124](../src/zombie_types.opy#L124), [126](../src/zombie_types.opy#L126).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [195](../src/zombie_types.opy#L195), [200](../src/zombie_types.opy#L200).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [262](../src/zombie_types.opy#L262).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [346](../src/zombie_types.opy#L346), [353](../src/zombie_types.opy#L353).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [409](../src/zombie_types.opy#L409).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [447](../src/zombie_types.opy#L447).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [500](../src/zombie_types.opy#L500).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [523](../src/zombie_types.opy#L523), [537](../src/zombie_types.opy#L537), [542](../src/zombie_types.opy#L542).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [585](../src/zombie_types.opy#L585), [600](../src/zombie_types.opy#L600), [609](../src/zombie_types.opy#L609).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [639](../src/zombie_types.opy#L639), [663](../src/zombie_types.opy#L663), [664](../src/zombie_types.opy#L664).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [699](../src/zombie_types.opy#L699), [722](../src/zombie_types.opy#L722).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [756](../src/zombie_types.opy#L756), [764](../src/zombie_types.opy#L764), [773](../src/zombie_types.opy#L773), [783](../src/zombie_types.opy#L783).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [819](../src/zombie_types.opy#L819), [825](../src/zombie_types.opy#L825), [848](../src/zombie_types.opy#L848).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [901](../src/zombie_types.opy#L901).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [924](../src/zombie_types.opy#L924), [945](../src/zombie_types.opy#L945).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1001](../src/zombie_types.opy#L1001), [1008](../src/zombie_types.opy#L1008), [1019](../src/zombie_types.opy#L1019), [1022](../src/zombie_types.opy#L1022), [1045](../src/zombie_types.opy#L1045).
- zombie_types.opy — rule "DAYTAKER ATTACKS AT HALF HEALTH (BOSS)" (event Team 2): [1084](../src/zombie_types.opy#L1084).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1126](../src/zombie_types.opy#L1126).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1165](../src/zombie_types.opy#L1165).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1227](../src/zombie_types.opy#L1227).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1249](../src/zombie_types.opy#L1249), [1264](../src/zombie_types.opy#L1264).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1277](../src/zombie_types.opy#L1277).
- zombie_types.opy — rule "PROTECTOR (KIRIKO) USES CLEANSE" (event Team 2): [1346](../src/zombie_types.opy#L1346).
- zombie_types.opy — def abilityThrowdown(): [1448](../src/zombie_types.opy#L1448).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [443](../src/enhancements.opy#L443).

## actorCountdownSlot

Объявление: [variables.opy:453](../src/variables.opy#L453).

Алиасы: `powerUpNoCooldownsTimeRemaining`, `botChargerWindupProgress`.

- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [541](../src/zombie_types.opy#L541).
- supply_drops.opy — def noCooldowns(): [167](../src/supply_drops.opy#L167), [170](../src/supply_drops.opy#L170).

## controlStateSlot

Объявление: [variables.opy:458](../src/variables.opy#L458).

Алиасы: `isCrowdControlCooldownActive`, `botReturnTarget`.

- objective_types/objective_type_bosses.opy — def bossReturn(): [203](../src/objective_types/objective_type_bosses.opy#L203), [206](../src/objective_types/objective_type_bosses.opy#L206), [210](../src/objective_types/objective_type_bosses.opy#L210).
- hero_tuning.opy — rule "CC COOLDOWN FROM DOWNFALLEN/BRUTE" (event Team 1): [7](../src/hero_tuning.opy#L7), [11](../src/hero_tuning.opy#L11).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [298](../src/zombie_types.opy#L298), [300](../src/zombie_types.opy#L300).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [928](../src/zombie_types.opy#L928), [934](../src/zombie_types.opy#L934).

## actorMotionSlot1

Объявление: [variables.opy:463](../src/variables.opy#L463).

Алиасы: `botGasProjectilePosition`, `botTentaclePosition`, `botBlasterCharge`, `botDaytakerCharge`, `botSmolderAnger`, `botEnsnarerMeleeAngle`, `rescueExtractionPosition`.

- subroutines.opy — macro botStatManagementMacro(): [61](../src/subroutines.opy#L61).
- subroutines.opy — macro botEntityManagementMacro(): [138](../src/subroutines.opy#L138), [141](../src/subroutines.opy#L141), [158](../src/subroutines.opy#L158), [161](../src/subroutines.opy#L161), [164](../src/subroutines.opy#L164), [192](../src/subroutines.opy#L192), [199](../src/subroutines.opy#L199), [203](../src/subroutines.opy#L203).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [182](../src/objective_types/objective_type_survivor_rescue.opy#L182), [184](../src/objective_types/objective_type_survivor_rescue.opy#L184), [186](../src/objective_types/objective_type_survivor_rescue.opy#L186), [188](../src/objective_types/objective_type_survivor_rescue.opy#L188).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [365](../src/bots_game_in_progress.opy#L365), [366](../src/bots_game_in_progress.opy#L366), [367](../src/bots_game_in_progress.opy#L367), [379](../src/bots_game_in_progress.opy#L379).
- zombie_types.opy — macro smolderEnragedMacro(): [12](../src/zombie_types.opy#L12).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [201](../src/zombie_types.opy#L201), [204](../src/zombie_types.opy#L204), [212](../src/zombie_types.opy#L212), [214](../src/zombie_types.opy#L214), [218](../src/zombie_types.opy#L218), [219](../src/zombie_types.opy#L219).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [595](../src/zombie_types.opy#L595), [598](../src/zombie_types.opy#L598), [600](../src/zombie_types.opy#L600), [601](../src/zombie_types.opy#L601), [602](../src/zombie_types.opy#L602), [606](../src/zombie_types.opy#L606), [608](../src/zombie_types.opy#L608), [617](../src/zombie_types.opy#L617), [620](../src/zombie_types.opy#L620).
- zombie_types.opy — rule "BLASTER (PHARAH) CHARGES ROCKET THEN FIRES" (event Team 2): [826](../src/zombie_types.opy#L826), [829](../src/zombie_types.opy#L829), [830](../src/zombie_types.opy#L830), [831](../src/zombie_types.opy#L831), [834](../src/zombie_types.opy#L834), [840](../src/zombie_types.opy#L840), [842](../src/zombie_types.opy#L842).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1009](../src/zombie_types.opy#L1009), [1011](../src/zombie_types.opy#L1011), [1019](../src/zombie_types.opy#L1019), [1021](../src/zombie_types.opy#L1021), [1024](../src/zombie_types.opy#L1024), [1025](../src/zombie_types.opy#L1025), [1031](../src/zombie_types.opy#L1031), [1037](../src/zombie_types.opy#L1037), [1038](../src/zombie_types.opy#L1038).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1209](../src/zombie_types.opy#L1209), [1210](../src/zombie_types.opy#L1210), [1213](../src/zombie_types.opy#L1213).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1230](../src/zombie_types.opy#L1230).
- zombie_types.opy — def spawnGasCloud(): [1492](../src/zombie_types.opy#L1492), [1494](../src/zombie_types.opy#L1494), [1495](../src/zombie_types.opy#L1495).

## actorMotionSlot2

Объявление: [variables.opy:478](../src/variables.opy#L478).

Алиасы: `botGasCloudTimeRemaining`, `extractionFlightPosition`.

- subroutines.opy — macro botEntityManagementMacro(): [154](../src/subroutines.opy#L154).
- objective_types/objective_type_extraction_point.opy — rule "PLAYER EXTRACTION CONTROL" (event Team 1): [56](../src/objective_types/objective_type_extraction_point.opy#L56), [57](../src/objective_types/objective_type_extraction_point.opy#L57), [58](../src/objective_types/objective_type_extraction_point.opy#L58), [60](../src/objective_types/objective_type_extraction_point.opy#L60), [62](../src/objective_types/objective_type_extraction_point.opy#L62), [63](../src/objective_types/objective_type_extraction_point.opy#L63), [65](../src/objective_types/objective_type_extraction_point.opy#L65).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [169](../src/zombie_types.opy#L169), [171](../src/zombie_types.opy#L171), [172](../src/zombie_types.opy#L172), [187](../src/zombie_types.opy#L187), [188](../src/zombie_types.opy#L188).

## actorAbilitySlot2

Объявление: [variables.opy:483](../src/variables.opy#L483).

Алиасы: `botAuxiliaryState`, `rescueFollowMessage`, `botIsReigniteActive`, `botIsEnsnarerMeleeActive`.

- subroutines.opy — def botRespawnInitialization(): [719](../src/subroutines.opy#L719).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [50](../src/objective_types/objective_type_survivor_rescue.opy#L50).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [152](../src/objective_types/objective_type_survivor_rescue.opy#L152), [155](../src/objective_types/objective_type_survivor_rescue.opy#L155).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [363](../src/bots_game_in_progress.opy#L363), [381](../src/bots_game_in_progress.opy#L381).
- zombie_types.opy — rule "REIGNITED USES ULTIMATE NEAR PLAYER" (event Team 2): [394](../src/zombie_types.opy#L394), [396](../src/zombie_types.opy#L396).
- zombie_types.opy — rule "ZOMBIES SPAWN AT REIGNITED" (event Team 2): [407](../src/zombie_types.opy#L407), [417](../src/zombie_types.opy#L417).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [955](../src/zombie_types.opy#L955).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1152](../src/zombie_types.opy#L1152).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1187](../src/zombie_types.opy#L1187).

## initialMaxHealth

Объявление: [variables.opy:492](../src/variables.opy#L492).

- subroutines.opy — def botRespawnInitialization(): [701](../src/subroutines.opy#L701).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [39](../src/players_game_in_progress.opy#L39).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [79](../src/bots_game_in_progress.opy#L79), [81](../src/bots_game_in_progress.opy#L81).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [397](../src/bots_game_in_progress.opy#L397).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [21](../src/enhancements.opy#L21).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [457](../src/enhancements.opy#L457).
- enhancements.opy — rule "HITCHHIKER PARENT RECIEVES HEALTH POOL" (event Team 1): [478](../src/enhancements.opy#L478).

## isAttached

Объявление: [variables.opy:493](../src/variables.opy#L493).

Алиасы: `botIsAttached`, `enhancementIsHitchhiking`.

- subroutines.opy — def restoreDefaultFacingMovement(): [686](../src/subroutines.opy#L686).
- subroutines.opy — def botRespawnInitialization(): [713](../src/subroutines.opy#L713).
- subroutines.opy — def illariUlt(): [787](../src/subroutines.opy#L787).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [37](../src/objective_types/objective_type_bosses.opy#L37), [38](../src/objective_types/objective_type_bosses.opy#L38).
- objective_types/objective_type_zombie_egg.opy — rule "ASSIGN ZOMBIE TO BECOME EGG": [12](../src/objective_types/objective_type_zombie_egg.opy#L12).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [43](../src/players_game_in_progress.opy#L43).
- players_game_in_progress.opy — rule "PLAYER AFK" (event Team 1): [260](../src/players_game_in_progress.opy#L260).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [97](../src/bots_game_in_progress.opy#L97).
- bots_game_in_progress.opy — rule "TELEPORT BOTS WHEN NOT USED FOR TOO LONG" (event Team 2): [185](../src/bots_game_in_progress.opy#L185).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [303](../src/bots_game_in_progress.opy#L303).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [326](../src/bots_game_in_progress.opy#L326).
- bots_game_in_progress.opy — rule "BOTS RECOIL FROM DAMAGE" (event Team 2): [408](../src/bots_game_in_progress.opy#L408).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [195](../src/zombie_types.opy#L195).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [433](../src/zombie_types.opy#L433), [436](../src/zombie_types.opy#L436).
- zombie_types.opy — rule "RIDER DETACH WHEN DEAD OR TARGET IS DEAD" (event Team 2): [445](../src/zombie_types.opy#L445), [450](../src/zombie_types.opy#L450).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [459](../src/zombie_types.opy#L459), [468](../src/zombie_types.opy#L468).
- zombie_types.opy — rule "RIDER DETATCH FROM TEAMMATES WHILE ALIVE" (event Team 2): [475](../src/zombie_types.opy#L475), [481](../src/zombie_types.opy#L481).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [490](../src/zombie_types.opy#L490).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [537](../src/zombie_types.opy#L537).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1016](../src/zombie_types.opy#L1016), [1027](../src/zombie_types.opy#L1027), [1034](../src/zombie_types.opy#L1034), [1043](../src/zombie_types.opy#L1043), [1050](../src/zombie_types.opy#L1050).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/enhancements.opy#L117), [119](../src/enhancements.opy#L119), [121](../src/enhancements.opy#L121).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [437](../src/enhancements.opy#L437), [440](../src/enhancements.opy#L440), [441](../src/enhancements.opy#L441), [454](../src/enhancements.opy#L454), [467](../src/enhancements.opy#L467).
- enhancements.opy — rule "HITCHHIKER LIFEBONDS" (event Team 1): [488](../src/enhancements.opy#L488).

## aiLocationSlot

Объявление: [variables.opy:498](../src/variables.opy#L498).

Алиасы: `botTeleportPosition`, `rescuePathIndex`.

- objective_types/objective_type_survivor_rescue.opy — rule "DELETE PATH": [131](../src/objective_types/objective_type_survivor_rescue.opy#L131), [132](../src/objective_types/objective_type_survivor_rescue.opy#L132).
- objective_types/objective_type_zombie_egg.opy — rule "BOTS TELEPORT TO THE EGG" (event Team 2): [69](../src/objective_types/objective_type_zombie_egg.opy#L69), [70](../src/objective_types/objective_type_zombie_egg.opy#L70), [73](../src/objective_types/objective_type_zombie_egg.opy#L73).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [160](../src/bots_game_in_progress.opy#L160).
- bots_game_in_progress.opy — rule "UPDATE SUCCESSFUL TELEPORT STATUS" (event Team 2): [227](../src/bots_game_in_progress.opy#L227).
- bots_game_in_progress.opy — def enterExitTeleport(): [432](../src/bots_game_in_progress.opy#L432), [433](../src/bots_game_in_progress.opy#L433).
- bots_game_in_progress.opy — def teleportBots(): [454](../src/bots_game_in_progress.opy#L454), [456](../src/bots_game_in_progress.opy#L456), [464](../src/bots_game_in_progress.opy#L464), [465](../src/bots_game_in_progress.opy#L465), [468](../src/bots_game_in_progress.opy#L468), [470](../src/bots_game_in_progress.opy#L470), [471](../src/bots_game_in_progress.opy#L471), [474](../src/bots_game_in_progress.opy#L474), [475](../src/bots_game_in_progress.opy#L475), [476](../src/bots_game_in_progress.opy#L476), [477](../src/bots_game_in_progress.opy#L477).
- bots_game_in_progress.opy — def updateBotSpawnPoints(): [512](../src/bots_game_in_progress.opy#L512), [513](../src/bots_game_in_progress.opy#L513), [516](../src/bots_game_in_progress.opy#L516), [517](../src/bots_game_in_progress.opy#L517), [518](../src/bots_game_in_progress.opy#L518), [519](../src/bots_game_in_progress.opy#L519).

## candidateTargetList

Объявление: [variables.opy:503](../src/variables.opy#L503).

Алиасы: `botPotentialTargetList`, `rescuePotentialLeaderList`, `enhancementBarrierTargetList`.

- subroutines.opy — macro globalObjectiveEntityManagementMacro(): [289](../src/subroutines.opy#L289).
- subroutines.opy — def selectTarget(): [652](../src/subroutines.opy#L652), [655](../src/subroutines.opy#L655), [657](../src/subroutines.opy#L657), [661](../src/subroutines.opy#L661), [663](../src/subroutines.opy#L663), [665](../src/subroutines.opy#L665), [667](../src/subroutines.opy#L667), [669](../src/subroutines.opy#L669), [670](../src/subroutines.opy#L670).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [70](../src/objective_types/objective_type_bosses.opy#L70).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [88](../src/objective_types/objective_type_survivor_rescue.opy#L88), [89](../src/objective_types/objective_type_survivor_rescue.opy#L89), [103](../src/objective_types/objective_type_survivor_rescue.opy#L103).
- objective_types/objective_type_survivor_rescue.opy — rule "PLAYER SAYS GROUP UP TO SURVIVOR": [149](../src/objective_types/objective_type_survivor_rescue.opy#L149), [151](../src/objective_types/objective_type_survivor_rescue.opy#L151).
- players_game_in_progress.opy — rule "PLAYER GETS DOWNED" (event Team 1): [136](../src/players_game_in_progress.opy#L136).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [139](../src/bots_game_in_progress.opy#L139).
- enhancements.opy — rule "LASER BARRICADE BLOCKS ZOMBIES" (event Team 1): [234](../src/enhancements.opy#L234), [238](../src/enhancements.opy#L238), [239](../src/enhancements.opy#L239).

## sizeScale

Объявление: [variables.opy:510](../src/variables.opy#L510).

- subroutines.opy — macro minibossMutationMacro(): [23](../src/subroutines.opy#L23).
- subroutines.opy — macro botStatManagementMacro(): [60](../src/subroutines.opy#L60), [62](../src/subroutines.opy#L62), [66](../src/subroutines.opy#L66).
- subroutines.opy — macro mutationsMacro(): [88](../src/subroutines.opy#L88), [89](../src/subroutines.opy#L89), [94](../src/subroutines.opy#L94), [95](../src/subroutines.opy#L95).
- subroutines.opy — macro botEntityManagementMacro(): [138](../src/subroutines.opy#L138), [141](../src/subroutines.opy#L141), [154](../src/subroutines.opy#L154), [158](../src/subroutines.opy#L158), [169](../src/subroutines.opy#L169), [174](../src/subroutines.opy#L174), [185](../src/subroutines.opy#L185), [188](../src/subroutines.opy#L188), [192](../src/subroutines.opy#L192), [199](../src/subroutines.opy#L199), [203](../src/subroutines.opy#L203).
- subroutines.opy — def restoreDefaultFacingMovement(): [688](../src/subroutines.opy#L688).
- subroutines.opy — def botRespawnInitialization(): [704](../src/subroutines.opy#L704), [707](../src/subroutines.opy#L707), [735](../src/subroutines.opy#L735).
- subroutines.opy — def explosionSequence(): [767](../src/subroutines.opy#L767).
- objective_types/objective_type_bosses.opy — rule "BOT BECOMES BOSS" (event Team 2): [61](../src/objective_types/objective_type_bosses.opy#L61), [62](../src/objective_types/objective_type_bosses.opy#L62), [64](../src/objective_types/objective_type_bosses.opy#L64).
- objective_types/objective_type_zombie_egg.opy — rule "BOT BECOMES ZOMBIE EGG" (event Team 2): [38](../src/objective_types/objective_type_zombie_egg.opy#L38), [39](../src/objective_types/objective_type_zombie_egg.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [62](../src/players_game_in_progress.opy#L62).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [102](../src/bots_game_in_progress.opy#L102).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [336](../src/bots_game_in_progress.opy#L336).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [359](../src/bots_game_in_progress.opy#L359).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [50](../src/zombie_types.opy#L50).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [72](../src/zombie_types.opy#L72).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [180](../src/zombie_types.opy#L180), [202](../src/zombie_types.opy#L202), [204](../src/zombie_types.opy#L204).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [237](../src/zombie_types.opy#L237), [238](../src/zombie_types.opy#L238).
- zombie_types.opy — rule "BRUTE (REIN) SUPER SEISMIC SLAM" (event Team 2): [254](../src/zombie_types.opy#L254), [264](../src/zombie_types.opy#L264), [265](../src/zombie_types.opy#L265), [266](../src/zombie_types.opy#L266), [267](../src/zombie_types.opy#L267).
- zombie_types.opy — rule "BRUTE, GLADIATOR, AND SMOLDER ALTERNATE ATTACK CONTROL" (event Team 2): [274](../src/zombie_types.opy#L274).
- zombie_types.opy — rule "BRUTE KNOCKDOWN" (event Team 1): [297](../src/zombie_types.opy#L297).
- zombie_types.opy — rule "BRUTE FIRE STRIKE (BOSS)" (event Team 2): [315](../src/zombie_types.opy#L315).
- zombie_types.opy — rule "REIGNITED (ANRAN) ABILITIES" (event Team 2): [334](../src/zombie_types.opy#L334), [355](../src/zombie_types.opy#L355).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [381](../src/zombie_types.opy#L381).
- zombie_types.opy — rule "RIDER (WIDOWMAKER) ATTACH TO PLAYERS" (event Team 2): [438](../src/zombie_types.opy#L438).
- zombie_types.opy — rule "RIDER ATTACH TO TEAMMATES" (event Team 2): [462](../src/zombie_types.opy#L462), [467](../src/zombie_types.opy#L467).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [588](../src/zombie_types.opy#L588), [595](../src/zombie_types.opy#L595), [596](../src/zombie_types.opy#L596), [608](../src/zombie_types.opy#L608), [614](../src/zombie_types.opy#L614), [617](../src/zombie_types.opy#L617).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [653](../src/zombie_types.opy#L653), [658](../src/zombie_types.opy#L658).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [703](../src/zombie_types.opy#L703), [717](../src/zombie_types.opy#L717), [718](../src/zombie_types.opy#L718).
- zombie_types.opy — rule "STRIKER NORMAL PILE DRIVER" (event Team 2): [748](../src/zombie_types.opy#L748).
- zombie_types.opy — rule "STALKER KNOCKBACK BLAST (BOSS)" (event Team 2): [809](../src/zombie_types.opy#L809).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [906](../src/zombie_types.opy#L906), [910](../src/zombie_types.opy#L910).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [925](../src/zombie_types.opy#L925), [942](../src/zombie_types.opy#L942), [945](../src/zombie_types.opy#L945).
- zombie_types.opy — rule "GLADIATOR (JUNKERQUEEN) COMMAND SHOUT" (event Team 2): [987](../src/zombie_types.opy#L987), [988](../src/zombie_types.opy#L988).
- zombie_types.opy — rule "DAYTAKER (ILLARI) BURST" (event Team 2): [1003](../src/zombie_types.opy#L1003), [1013](../src/zombie_types.opy#L1013), [1017](../src/zombie_types.opy#L1017), [1057](../src/zombie_types.opy#L1057), [1059](../src/zombie_types.opy#L1059), [1061](../src/zombie_types.opy#L1061).
- zombie_types.opy — rule "TUNNELER (SYMMETRA) BUILDS PORTAL" (event Team 2): [1101](../src/zombie_types.opy#L1101), [1102](../src/zombie_types.opy#L1102).
- zombie_types.opy — rule "TUNNELER PORTAL LETS ZOMBIES THROUGH" (event Team 2): [1113](../src/zombie_types.opy#L1113).
- zombie_types.opy — rule "CADAVER (ANA) DETONATION" (event Team 2): [1130](../src/zombie_types.opy#L1130), [1137](../src/zombie_types.opy#L1137).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1150](../src/zombie_types.opy#L1150).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1184](../src/zombie_types.opy#L1184).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1200](../src/zombie_types.opy#L1200), [1215](../src/zombie_types.opy#L1215).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1252](../src/zombie_types.opy#L1252).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1283](../src/zombie_types.opy#L1283), [1285](../src/zombie_types.opy#L1285), [1286](../src/zombie_types.opy#L1286), [1290](../src/zombie_types.opy#L1290).
- zombie_types.opy — rule "BRUTE, GLADIATOR, SUCESSOR, ENSNARER AND PROTECTOR USE ABILITIY (MINIBOSS)" (event Team 2): [1383](../src/zombie_types.opy#L1383).
- zombie_types.opy — def abilityThrowdown(): [1451](../src/zombie_types.opy#L1451).
- zombie_types.opy — def entityFloat(): [1459](../src/zombie_types.opy#L1459).
- zombie_types.opy — def explosionWarning(): [1468](../src/zombie_types.opy#L1468), [1469](../src/zombie_types.opy#L1469).
- zombie_types.opy — def smolderBoost(): [1481](../src/zombie_types.opy#L1481), [1485](../src/zombie_types.opy#L1485), [1486](../src/zombie_types.opy#L1486).
- zombie_types.opy — def spawnGasCloud(): [1494](../src/zombie_types.opy#L1494).
- supply_drops.opy — def stun(): [423](../src/supply_drops.opy#L423).
- supply_drops.opy — def powerUpUsage(): [515](../src/supply_drops.opy#L515).
- enhancements.opy — rule "PLAYER ENHANCEMENT INITIALIZATION" (event Team 1): [117](../src/enhancements.opy#L117), [149](../src/enhancements.opy#L149).
- enhancements.opy — rule "BRAIN KILLER EXTRA DAMAGE" (event Team 1): [274](../src/enhancements.opy#L274).
- enhancements.opy — rule "CHARGE BATTERY (USAGE AND COOLDOWNS)" (event Team 1): [417](../src/enhancements.opy#L417).
- enhancements.opy — rule "HITCHHIKER ATTACH/DETATCH" (event Team 1): [437](../src/enhancements.opy#L437), [441](../src/enhancements.opy#L441), [443](../src/enhancements.opy#L443), [445](../src/enhancements.opy#L445), [461](../src/enhancements.opy#L461).

## actorAbilitySlot1

Объявление: [variables.opy:511](../src/variables.opy#L511).

Алиасы: `botAbilityState`, `rescueIsExtracting`, `botIsBomberPrimed`, `botRusherHealthPoolId`, `botGasAimPosition`, `botIsReigniteAttackUsed`, `botRiderGrapplePosition`, `botChargerDestination`, `botTentacleTargetPosition`, `botIsStrikerStrikeActive`, `botIsDownfallenGrabbing`, `botIsEnsnarerBlocking`, `botSmolderState`.

- subroutines.opy — macro botEntityManagementMacro(): [158](../src/subroutines.opy#L158), [161](../src/subroutines.opy#L161), [164](../src/subroutines.opy#L164), [174](../src/subroutines.opy#L174), [203](../src/subroutines.opy#L203).
- subroutines.opy — def botRespawnInitialization(): [718](../src/subroutines.opy#L718).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [37](../src/objective_types/objective_type_survivor_rescue.opy#L37), [46](../src/objective_types/objective_type_survivor_rescue.opy#L46), [48](../src/objective_types/objective_type_survivor_rescue.opy#L48).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR FOLLOW TARGET": [79](../src/objective_types/objective_type_survivor_rescue.opy#L79).
- objective_types/objective_type_survivor_rescue.opy — rule "SURVIVOR REACHES EXTRACTION SITE": [180](../src/objective_types/objective_type_survivor_rescue.opy#L180).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [120](../src/bots_game_in_progress.opy#L120), [123](../src/bots_game_in_progress.opy#L123).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [362](../src/bots_game_in_progress.opy#L362).
- zombie_types.opy — macro smolderEnragedMacro(): [11](../src/zombie_types.opy#L11).
- zombie_types.opy — rule "BOMBER (JUNKRAT) SELF DESTRUCT" (event Team 2): [75](../src/zombie_types.opy#L75).
- zombie_types.opy — rule "RUSHER MOLTEN CORE (BOSS)" (event Team 2): [119](../src/zombie_types.opy#L119), [139](../src/zombie_types.opy#L139).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [202](../src/zombie_types.opy#L202), [204](../src/zombie_types.opy#L204), [212](../src/zombie_types.opy#L212), [214](../src/zombie_types.opy#L214).
- zombie_types.opy — rule "REIGNITED ULTIMATE ATTACK COUNTER" (event Team 2): [375](../src/zombie_types.opy#L375), [377](../src/zombie_types.opy#L377), [384](../src/zombie_types.opy#L384).
- zombie_types.opy — rule "RIDER USE GRAPPLING HOOK" (event Team 2): [498](../src/zombie_types.opy#L498), [501](../src/zombie_types.opy#L501), [507](../src/zombie_types.opy#L507).
- zombie_types.opy — rule "CHARGER (MAUGA) CHARGE" (event Team 2): [548](../src/zombie_types.opy#L548).
- zombie_types.opy — rule "SLIMER (MERCY) TENTACLE GRAB" (event Team 2): [584](../src/zombie_types.opy#L584), [596](../src/zombie_types.opy#L596), [598](../src/zombie_types.opy#L598), [600](../src/zombie_types.opy#L600), [603](../src/zombie_types.opy#L603), [619](../src/zombie_types.opy#L619).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [637](../src/zombie_types.opy#L637).
- zombie_types.opy — rule "STRIKER (WRECKING BALL) PILE DRIVER" (event Team 2): [709](../src/zombie_types.opy#L709), [724](../src/zombie_types.opy#L724).
- zombie_types.opy — rule "DOWNFALLEN (SIGMA) FIRES" (event Team 2): [902](../src/zombie_types.opy#L902).
- zombie_types.opy — rule "DOWNFALLEN GRABS PLAYER" (event Team 2): [927](../src/zombie_types.opy#L927), [933](../src/zombie_types.opy#L933), [960](../src/zombie_types.opy#L960).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1157](../src/zombie_types.opy#L1157), [1169](../src/zombie_types.opy#L1169).
- zombie_types.opy — rule "ENSNARER LUNGE" (event Team 2): [1188](../src/zombie_types.opy#L1188).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1199](../src/zombie_types.opy#L1199), [1207](../src/zombie_types.opy#L1207), [1210](../src/zombie_types.opy#L1210), [1211](../src/zombie_types.opy#L1211).
- zombie_types.opy — rule "SMOLDER ACTIVATES FROM DAMAGE" (event Team 2): [1226](../src/zombie_types.opy#L1226), [1229](../src/zombie_types.opy#L1229).
- zombie_types.opy — rule "SMOLDER BOSS SLAM" (event Team 2): [1246](../src/zombie_types.opy#L1246), [1261](../src/zombie_types.opy#L1261), [1268](../src/zombie_types.opy#L1268).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1276](../src/zombie_types.opy#L1276).
- zombie_types.opy — rule "SMOLDER STAYS ENRAGE DURING BOSS EVENT": [1297](../src/zombie_types.opy#L1297).
- zombie_types.opy — rule "SMOLDER ACTIVATED FROM BOSS EVENT" (event Team 2): [1334](../src/zombie_types.opy#L1334).
- zombie_types.opy — def explosionWarning(): [1473](../src/zombie_types.opy#L1473).

## objectiveTypeSnapshot

Объявление: [variables.opy:538](../src/variables.opy#L538).

- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [8](../src/players_game_in_progress.opy#L8), [9](../src/players_game_in_progress.opy#L9), [22](../src/players_game_in_progress.opy#L22).
- players_game_in_progress.opy — rule "OBJECTIVE CHANGES AND PLAYER ENTITIES UPDATE": [321](../src/players_game_in_progress.opy#L321).

## visualEntityIdList

Объявление: [variables.opy:539](../src/variables.opy#L539).

Алиасы: `botVisualEntityIdList`, `playerObjectiveIconIdList`.

- subroutines.opy — macro minibossMutationMacro(): [28](../src/subroutines.opy#L28).
- subroutines.opy — macro botEntityManagementMacro(): [128](../src/subroutines.opy#L128), [129](../src/subroutines.opy#L129), [133](../src/subroutines.opy#L133), [139](../src/subroutines.opy#L139), [142](../src/subroutines.opy#L142), [148](../src/subroutines.opy#L148), [151](../src/subroutines.opy#L151), [155](../src/subroutines.opy#L155), [159](../src/subroutines.opy#L159), [162](../src/subroutines.opy#L162), [165](../src/subroutines.opy#L165), [170](../src/subroutines.opy#L170), [175](../src/subroutines.opy#L175), [186](../src/subroutines.opy#L186), [189](../src/subroutines.opy#L189), [193](../src/subroutines.opy#L193), [196](../src/subroutines.opy#L196), [200](../src/subroutines.opy#L200), [204](../src/subroutines.opy#L204), [209](../src/subroutines.opy#L209), [212](../src/subroutines.opy#L212), [216](../src/subroutines.opy#L216).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/players_game_in_progress.opy#L12), [13](../src/players_game_in_progress.opy#L13), [15](../src/players_game_in_progress.opy#L15), [26](../src/players_game_in_progress.opy#L26).

## visualCleanupIndex

Объявление: [variables.opy:544](../src/variables.opy#L544).

- subroutines.opy — macro botEntityManagementMacro(): [128](../src/subroutines.opy#L128), [129](../src/subroutines.opy#L129).
- players_game_in_progress.opy — macro playerObjectiveEntityManagementMacro(): [12](../src/players_game_in_progress.opy#L12), [13](../src/players_game_in_progress.opy#L13), [18](../src/players_game_in_progress.opy#L18), [19](../src/players_game_in_progress.opy#L19).

## actorLoopSlot

Объявление: [variables.opy:545](../src/variables.opy#L545).

Алиасы: `botEnsnarerUltimateIndex`, `powerUpBouncePadTimeRemaining`.

- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [368](../src/bots_game_in_progress.opy#L368).
- supply_drops.opy — def bouncePad(): [366](../src/supply_drops.opy#L366), [372](../src/supply_drops.opy#L372), [373](../src/supply_drops.opy#L373).

## abilityTargetList

Объявление: [variables.opy:550](../src/variables.opy#L550).

Алиасы: `botSpecialTargetList`, `explosionTargetList`.

- subroutines.opy — def explosionSequence(): [762](../src/subroutines.opy#L762), [764](../src/subroutines.opy#L764), [767](../src/subroutines.opy#L767), [769](../src/subroutines.opy#L769), [771](../src/subroutines.opy#L771).
- zombie_types.opy — rule "BASIC (REAPER) SHADOW STEP (BOSS)" (event Team 2): [48](../src/zombie_types.opy#L48), [49](../src/zombie_types.opy#L49).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [234](../src/zombie_types.opy#L234), [239](../src/zombie_types.opy#L239), [240](../src/zombie_types.opy#L240), [241](../src/zombie_types.opy#L241).
- zombie_types.opy — rule "PRIME SLIMER (EMRE) FLIGHT (BOSS)" (event Team 2): [674](../src/zombie_types.opy#L674), [675](../src/zombie_types.opy#L675).
- zombie_types.opy — rule "ENSNARER (HAZARD) BLOCKS PLAYERS" (event Team 2): [1159](../src/zombie_types.opy#L1159), [1160](../src/zombie_types.opy#L1160).
- zombie_types.opy — rule "SMOLDER SUPER SLAM" (event Team 2): [1285](../src/zombie_types.opy#L1285), [1286](../src/zombie_types.opy#L1286), [1288](../src/zombie_types.opy#L1288), [1289](../src/zombie_types.opy#L1289).
- zombie_types.opy — def entityFloat(): [1459](../src/zombie_types.opy#L1459).

## movementSpeedScale

Объявление: [variables.opy:555](../src/variables.opy#L555).

- subroutines.opy — macro botStatManagementMacro(): [44](../src/subroutines.opy#L44), [45](../src/subroutines.opy#L45).
- subroutines.opy — macro mutationsMacro(): [82](../src/subroutines.opy#L82), [83](../src/subroutines.opy#L83), [108](../src/subroutines.opy#L108), [109](../src/subroutines.opy#L109).
- subroutines.opy — macro botEntityManagementMacro(): [180](../src/subroutines.opy#L180).
- subroutines.opy — def illariUlt(): [793](../src/subroutines.opy#L793), [794](../src/subroutines.opy#L794), [803](../src/subroutines.opy#L803), [804](../src/subroutines.opy#L804).
- objective_types/objective_type_survivor_rescue.opy — rule "INITIALIZE SURVIVOR TO BE RESCUED" (event Team 1): [39](../src/objective_types/objective_type_survivor_rescue.opy#L39).
- players_game_in_progress.opy — rule "PLAYER INITIALIZATION" (event Team 1): [41](../src/players_game_in_progress.opy#L41), [42](../src/players_game_in_progress.opy#L42).
- bots_game_in_progress.opy — rule "KILL BOTS THAT ARE STUCK OR ARE NOT MOVING" (event Team 2): [101](../src/bots_game_in_progress.opy#L101).
- bots_game_in_progress.opy — rule "BOT WANDERS" (event Team 2): [288](../src/bots_game_in_progress.opy#L288).
- bots_game_in_progress.opy — rule "BOTS JUMP" (event Team 2): [312](../src/bots_game_in_progress.opy#L312).
- bots_game_in_progress.opy — rule "BOTS MOVE THROUGH SPAWN DOORS" (event Team 2): [333](../src/bots_game_in_progress.opy#L333).
- bots_game_in_progress.opy — rule "BOTS MELEE" (event Team 2): [360](../src/bots_game_in_progress.opy#L360).
- zombie_types.opy — rule "STALKER (MOIRA) FADE" (event Team 2): [775](../src/zombie_types.opy#L775), [776](../src/zombie_types.opy#L776), [781](../src/zombie_types.opy#L781), [782](../src/zombie_types.opy#L782).
- zombie_types.opy — rule "SMOLDER (WINSTON) SEES PLAYER" (event Team 2): [1205](../src/zombie_types.opy#L1205), [1206](../src/zombie_types.opy#L1206).
- zombie_types.opy — def smolderBoost(): [1487](../src/zombie_types.opy#L1487), [1488](../src/zombie_types.opy#L1488).
- supply_drops.opy — def cloakingDevice(): [293](../src/supply_drops.opy#L293), [294](../src/supply_drops.opy#L294), [318](../src/supply_drops.opy#L318), [319](../src/supply_drops.opy#L319).
- supply_drops.opy — def superNano(): [326](../src/supply_drops.opy#L326), [327](../src/supply_drops.opy#L327), [355](../src/supply_drops.opy#L355), [356](../src/supply_drops.opy#L356).

## damageOverTimeRemaining

Объявление: [variables.opy:556](../src/variables.opy#L556).

- subroutines.opy — def explosionSequence(): [772](../src/subroutines.opy#L772), [773](../src/subroutines.opy#L773).
- bots_game_in_progress.opy — rule "BOT INITIALIZATION" (event Team 2): [74](../src/bots_game_in_progress.opy#L74).
- bots_game_in_progress.opy — rule "BOT DIES" (event Team 2): [156](../src/bots_game_in_progress.opy#L156).
- bots_game_in_progress.opy — rule "BOTS INFLICT DAMAGE OVER TIME (INFECTION LEVEL MANAGEMENT)" (event Team 2): [395](../src/bots_game_in_progress.opy#L395), [396](../src/bots_game_in_progress.opy#L396).
- zombie_types.opy — rule "RUSHER MOLTEN CORE BURNS PLAYERS (BOSS)" (event Team 2): [153](../src/zombie_types.opy#L153), [154](../src/zombie_types.opy#L154).
- zombie_types.opy — rule "BEHEMOTH (ROAD) TOXIC CLOUD" (event Team 2): [181](../src/zombie_types.opy#L181), [182](../src/zombie_types.opy#L182).
- zombie_types.opy — rule "BEHEMOTH GAS STREAM (BOSS)" (event Team 2): [241](../src/zombie_types.opy#L241), [242](../src/zombie_types.opy#L242).
- zombie_types.opy — rule "BLASTER ROCKET HITS TARGET" (event Team 2): [887](../src/zombie_types.opy#L887), [888](../src/zombie_types.opy#L888), [892](../src/zombie_types.opy#L892), [893](../src/zombie_types.opy#L893).
