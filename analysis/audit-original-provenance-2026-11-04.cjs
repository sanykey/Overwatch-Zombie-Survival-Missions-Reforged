// Source provenance for existing report entries; no game compilation or source writes.
// Run with --write to save the evidence JSON. Line references are checked against source text.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const original = 'workshop-snapshots/ZSMM (786TW)/2026-10-30 ZSMM (786TW).opy';
const read = file => fs.readFileSync(path.join(root, file), 'utf8').replace(/\r\n/g, '\n');
const text = read(original);
const lines = text.split('\n');
const hash = data => crypto.createHash('sha256').update(data).digest('hex');
function evidence(line, needle) {
    assert(lines[line - 1]?.includes(needle), `Original source mismatch at ${line}: ${needle}`);
    return {file: original, line, source: lines[line - 1].trim()};
}
const findings = [
    ['R01', [[1329, 'startRule(randomActions)'], [1516, 'wait(1)'], [6503, 'startRule(playerForceField)'], [6138, 'wait(0.032)']],
        'Повторный startRule с поведением RESTART по умолчанию и ожидающие цели уже присутствовали. Все 22 текущих случая сопоставлены ниже отдельно; извлечение powerUpUsage в другой файл не создало этот механизм риска.'],
    ['R02', [[518, 'random.uniform(0, 100)'], [521, 'while randVal > botCurrentSpawnRate'], [811, '5.263']],
        'В оригинале уже были те же 19 весов по 5.263, выбор из 0–100 и цикл накопления без ограничения индекса. Сумма 99.997 и опасный хвост диапазона унаследованы.'],
    ['R03', [[714, '5, 1, 10'], [6000, '120 / (numberOfPowerUpsPerSupplyDrop - 1)']],
        'Настройка уже разрешала один предмет, а размещение уже делило 120 на count − 1. Опасное значение шага не появилось при оптимизации.'],
    ['R04', [[947, 'while'], [964, 'random.choice(mixedObjectivesPool.exclude']],
        'Неограниченный выбор разрешённого задания и выбор из Mixed Pool без проверки непустоты уже были в оригинале.'],
    ['R05', [[6004, 'powerUpTradeValues[0]'], [6007, 'wait()'], [6009, 'powerUpPositions.index'], [6015, 'wait()'], [6016, 'del powerUpIDs']],
        'Подбор уже разделял выбор позиции, поиск индекса, выдачу и удаление общих массивов ожиданиями. Межигроковая гонка унаследована.'],
    ['R06', [[3095, 'eventPlayer.invisible = false'], [3096, 'eventPlayer.movementSpeed = 1'], [6296, 'eventPlayer.invisible--'], [6302, '/= 1.5'], [6339, '/= 1.5']],
        'Инициализация уже обнуляла невидимость/скорость, а старые Cloaking Device и Super Nano затем уменьшали счётчик/делили скорость. Переименование переменных не является источником конфликта жизненных циклов.'],
    ['R07', [[229, 'globalvar objectiveResourcePositions'], [2588, 'objectiveResourcePositions.append'], [2619, 'while len(deferredType) > 0'], [2625, 'wait(0.15)'], [2957, 'objectiveResourcePositions.append']],
        'Даже общий список ресурсов Biomorphing и терминалов Satellite существовал в оригинале: это objectiveResourcePositions. Старый обработчик очереди также не отменялся при смене задания. Новые имена алиасов objectivePositionsSlot не создали описанный риск; достижимость поздней записи по-прежнему требует проверки в игре.'],
    ['R08', [[1784, 'chaseAtRate(extractionZoneRad'], [1791, 'chaseAtRate(objectiveRad'], [4263, 'chaseAtRate(eventPlayer.abilityArray1'], [6684, 'chaseAtRate(eventPlayer.enhancementChase2']],
        'Разобранные конструкции chase и условия имеют аналоги в оригинале. Это происхождение кода, а не признание его ошибочным: 10 корректных случаев не являются дефектами, четыре остаются под наблюдением.'],
    ['R09', [[2246, 'while bosses.any'], [2248, 'waitUntil'], [2357, 'while eventPlayer.isDead()'], [2366, 'waitUntil'], [2703, 'if eventPlayer.isDead()'], [6101, 'while not eventPlayer.isOnGround()']],
        'Повторные воскрешения босса/NPC и ожидание приземления при сбросе предмета уже не имели общего срока завершения. Замена отдельных длительностей на Math.INFINITY не является первопричиной внешнего повтора.'],
    ['R10', [[6990, 'not x.attached'], [6992, 'not x.crowdControlled'], [7006, 'enhancementValues[13] = eventPlayer'], [7013, 'enhancementValues[13] = null']],
        'В оригинале уже расходились фильтры допуска/выбора переносчика; запись единственного пассажира и безусловная очистка могли перезаписать связь другого игрока.'],
    ['R11', [[5842, 'startForcingButton(Button.ABILITY_2)'], [5843, 'wait(10)']],
        'Удержание блока Doomfist без парного прекращения уже было в исходном правиле.'],
    ['R12', [[5451, '.attachTo('], [5468, '.attached = false'], [5469, 'return'], [5477, '.attached = false'], [5478, 'return']],
        'Обе аварийные ветки уже сбрасывали флаг attached и выходили без detach. Текущий daytakerAbortReset извлекает прежние присваивания; отсутствие detach не возникло при извлечении помощника.'],
    ['R13', [[5537, 'movementSpeed /= 3'], [5539, 'wait(1.5)'], [5541, 'return'], [5542, 'eventPlayer == eventPlayer.hasStatus'], [5547, 'movementSpeed *= 3']],
        'И сравнение сущности с булевым результатом hasStatus, и выход после смерти до восстановления скорости уже присутствовали.'],
    ['R14', [[5034, 'isInLoS(eventPlayer.chase1, x.getEyePosition()'], [5035, 'isInLoS(eventPlayer.chase1, eventPlayer.getEyePosition()']],
        'Проверка видимости кандидата и фактический фильтр щупальца Mercy уже использовали разные конечные точки луча.'],
    ['R15', [[2045, 'extractionSpeedUp +='], [3220, 'extractionZoneRad - distance'], [3221, '/ 2.5']],
        'Сравнение метров с секундами, деление на фиксированные 2.5 и ускорение купола уже сосуществовали в оригинале.'],
    ['R16', [[3761, 'eventPlayer.testTarget ='], [3762, 'isInLoS'], [3766, 'eventPlayer.botTarget = eventPlayer.testTarget']],
        'Прежний testTarget уже назначался до проверки видимости и публиковался после цикла без признака успешного поиска/сброса кандидата. Это тот же дефект, несмотря на новое имя botCandidateTarget.'],
    ['R17', [[2718, 'x != survivorToRescue'], [2720, 'sorted(playerTargetList.filter'], [2723, 'playerTargetList.append(survivorToRescue)']],
        'NPC уже готовил правильный список кандидатов, но выбирал лидера из другого списка, в который добавлялся сам.'],
    ['R18', [[6967, 'x.getUltCharge() < 100'], [6969, 'getLivingPlayers(Team.1).filter']],
        'Допуск батареи уже учитывал заряд и масштаб, а выбор получателя их терял и использовал другой источник игроков.'],
    ['R19', [[2527, 'or distance(x, eventPlayer.getEyePosition()) < 2'], [2531, 'sorted(objectiveResourcePositions']],
        'Условие близости к ногам или глазам и последующая сортировка всего списка только по ногам уже расходились.'],
    ['R20', [[2241, 'not miniBoss[player]'], [2120, 'not evacuatingSurvivorList[player]']],
        'Индексирование списков сущностью игрока уже было в обоих фильтрах. Для эвакуации старое имя списка — evacuatingSurvivorList, текущее — evacSurvivorList.'],
    ['R21', [[3718, 'isInLoS'], [3755, 'sorted(playerTargetList'], [3757, 'sorted(playerTargetList'], [3762, 'isInLoS']],
        'Унаследованный кандидат на оптимизацию: дорогие условия видимости и повторный обход/сортировки в selectTarget уже были. Текущие оценки нагрузки не являются замером оригинала.'],
    ['R22', [[6248, 'isInLoS'], [6255, '-0.125'], [6256, 'filter'], [6257, 'sorted(getLivingPlayers']],
        'Унаследованный кандидат на оптимизацию: турель уже повторяла проверки видимости в визуальном выражении, проверке наличия цели и сортировке цели.'],
    ['R23', [[2432, 'isInLoS(x, eventPlayer.averagePlayersPos.getEyePosition()) and distance']],
        'Унаследованный кандидат на оптимизацию: LoS уже стоял перед пространственным отбором в bossReturn. Исправление другого getClosestPlayer в этой механике не устранило описанные расходы.'],
    ['R24', [[6771, 'getLivingPlayers(Team.2).any'], [6777, 'getLivingPlayers(Team.2).any'], [6781, 'getLivingPlayers(Team.2).filter'], [6800, 'raycastHitNormal']],
        'Унаследованный кандидат на оптимизацию: многократные геометрические проходы баррикады, повторные сортировки и raycast уже были.'],
    ['R25', [[1566, 'sorted(healthpackPositions'], [1943, 'sorted(objectiveResourcePositions'], [6606, 'raycastHitPosition']],
        'Унаследованный кандидат на оптимизацию: повторные сортировки HUD по направлению взгляда и лучи предпросмотра баррикады присутствовали в оригинале.'],
    ['R26', [[3979, 'while eventPlayer.telePos == 0'], [3982, 'botSpawnPoints.index(x)'], [3986, 'botSpawnPoints.index(eventPlayer.telePos)']],
        'Повторные index по точкам и цикл поиска телепорта без явной отмены при отсутствии целей уже были.'],
    ['R27', [[757, 'while len(mapGrid) < 900'], [761, 'mapGrid.all'], [2948, 'mapGrid.filter']],
        'Унаследованный кандидат на оптимизацию: генерация сетки с проверками по накопленному массиву и повторная базовая фильтрация терминалов уже присутствовали.'],
    ['R28', [[6134, '-0.032'], [6136, 'getLivingPlayers(Team.2)['], [6137, 'getLivingPlayers(Team.2)[']],
        'Унаследованный кандидат на оптимизацию: силовое поле уже повторяло получение списка живых ботов внутри каждого короткого шага.'],
    ['R29', [[6837, '.append(victim)'], [6851, '.filter(lambda x: x =='], [6855, '.remove(eventPlayer.enhancementValues[3])']],
        'Унаследованный кандидат на оптимизацию: очередь Pyrotechnic уже хранила повторные ссылки и заново фильтровалась по каждой жертве.'],
    ['R30', [[6153, '-0.032'], [6154, 'setAbilityCooldown'], [6167, 'setAbilityCooldown']],
        'Унаследованный кандидат на оптимизацию: те же частые сбросы кулдаунов и зарядов уже выполнялись в оригинале.'],
    ['R31', [[2691, 'eventPlayer.path.filter'], [2751, '.path.append'], [2761, 'sorted(survivorToRescue.path']],
        'Путь NPC уже пополнялся без явного ограничения, повторно обходился в движении и сортировался ради ближайшей точки.'],
    ['R32', [[6188, 'range(50)'], [6193, 'playEffect'], [6196, 'playEffect'], [6356, '-0.125'], [6357, '% 0.25']],
        'Унаследованный кандидат на оптимизацию: Air Strike уже создавал четыре динамических эффекта на 50 шагов, Bounce Pad — кольцо каждые 0.25 секунды действия.'],
    ['R33', [[534, 'sorted(spawnTimes.map'], [7042, 'sorted(eventPlayer.concat'], [7043, '.exclude(']],
        'Унаследованные кандидаты на оптимизацию: сортировка таймеров и сортировка двух участников Hitchhiker уже присутствовали в оригинале.'],
    ['R34', [[3622, 'miniBoss[miniBoss.index(eventPlayer)] = 0'], [4332, 'miniBoss.append(eventPlayer)']],
        'Добавление минибоссов и замена записей нулями вместо удаления уже существовали; рост массива унаследован.'],
    ['R35', [[5930, 'len(powerUpPositions) < 12'], [2510, 'range(4)'], [6090, 'powerUpPositions.append'], [6104, 'powerUpPositions.append'], [451, '#!extension playMoreEffects']],
        'Предел 12 уже относился лишь к генератору, а награды Biomorphing и сбросы добавляли предметы вне него. Расширение playMoreEffects также было включено в оригинале: увеличенный бюджет визуальных объектов не является новым отличием Reforged и не обеспечивает общего лимита предметов.'],
    ['R36', [[5966, 'getAllPlayers().filter(lambda _:'], [6593, 'hudText'], [6600, 'chaseAtRate']],
        'Унаследованный кандидат на оптимизацию: фильтры зрителей с условием, не зависящим от параметра lambda, уже использовались. Число 50 относится к текущему дереву, а не к пересчёту исторического файла.'],
    ['R37', [[5939, 'while supplyDropLanding == null'], [5941, 'sorted(playerTargetList'], [5948, 'wait(0.25)']],
        'Цикл снабжения уже искал точку без общего предела попыток и без проверки актуальности фазы/наличия целей внутри цикла.'],
    ['R38', [[2363, 'Impulse.CANCEL_CONTRARY_MOTION'], [6137, 'Impulse.CANCEL_CONTRARY_MOTION'], [7137, 'Impulse.CANCEL_CONTRARY_MOTION']],
        'Все 20 текущих мест имеют соответствующий legacy-импульс в оригинале. Это унаследованная задача совместимости физики, а не 20 новых доказанных дефектов. В IM01 выбор цели изменён и защищён проверкой существования, но сам режим импульса уже был прежним.'],
].map(([id, refs, note]) => ({id, origin: id === 'R08' ? 'inherited-diagnostic' : 'inherited', note, evidence: refs.map(([line, needle]) => evidence(line, needle))}));

const starts = [
    [1164, 'determineZombieMode'], [789, 'determineChallenge'], [850, 'determineObjectiveType'], [950, 'setObjectiveType'],
    [1286, 'setPrematchTimer'], [1328, 'setPrematchTimer'], [1329, 'randomActions'], [1336, 'setPrematchTimer'],
    [1480, 'setPrematchTimer'], [1483, 'setPrematchTimer'], [1710, 'objectivesManagement'],
    [6500, 'instantRevive'], [6503, 'playerForceField'], [6506, 'noCooldowns'], [6512, 'airStrike'],
    [6515, 'healBeacon'], [6524, 'sentryTurret'], [6527, 'cloakingDevice'], [6530, 'superNano'],
    [6533, 'bouncePad'], [6536, 'ultimateCharger'], [6541, 'stun'],
].map(([line, target], i) => {
    const start = lines.findIndex(s => s === `def ${target}():`);
    assert(start >= 0, target);
    let end = start + 1;
    while (end < lines.length && !/^(rule|def|macro) /.test(lines[end])) end++;
    const waits = lines.slice(start + 1, end).flatMap((s, n) => /\bwait(?:Until)?\(/.test(s) ? [evidence(start + n + 2, 'wait')] : []);
    return {id: `SR${String(i + 1).padStart(2, '0')}`, origin: 'inherited-construction', target,
        call: evidence(line, `startRule(${target})`), definition: evidence(start + 1, `def ${target}():`), waits,
        inlinedHistoricalWaits: target === 'objectivesManagement' ? [evidence(1855, 'wait()')] : []};
});
const chaseRefs = [
    [[2041, 'objectiveRad'], [1785, 'objectiveRad = 10']],
    [[2059, 'extractionZoneRad < 200'], [1784, 'chaseAtRate(extractionZoneRad']],
    [[2060, '> extractionZoneRad'], [1784, 'chaseAtRate(extractionZoneRad']],
    [[2077, 'extractionZoneRad <= 0'], [1784, 'chaseAtRate(extractionZoneRad']],
    [[2156, '< objectiveRad'], [1791, 'chaseAtRate(objectiveRad']],
    [[2553, '< objectiveRad'], [1805, 'objectiveRad = 3.5']],
    [[2712, '< objectiveRad'], [2724, 'objectiveRad = 30']],
    [[2832, '< objectiveRad'], [1820, 'objectiveRad = 20']],
    [[2977, '< objectiveRad'], [1831, 'objectiveRad = 3']],
    [[5607, 'not eventPlayer.abilityArray1'], [4263, 'chaseAtRate(eventPlayer.abilityArray1, 0']],
    [[5891, '<= objectiveRad'], [1791, 'chaseAtRate(objectiveRad']],
    [[6712, 'infectionLvl >= 1'], [6600, 'chaseAtRate(eventPlayer.infectionLvl, 0']],
    [[6769, 'enhancementChase1 > 0'], [6810, 'enhancementChase1 = 1'], [6811, 'chaseAtRate']],
    [[7057, 'enhancementChase2 <= 0'], [6684, 'chaseAtRate(eventPlayer.enhancementChase2, 0']],
];
const chase = chaseRefs.map((refs, i) => ({id: `CH${String(i + 1).padStart(2, '0')}`, origin: 'inherited-construction', status: [1, 2, 4, 10].includes(i) ? 'monitoring' : 'not-a-defect', evidence: refs.map(([line, needle]) => evidence(line, needle))}));
const impulses = [2363, 4698, 4782, 4788, 5047, 5086, 5150, 5243, 5376, 5386, 5493, 5495, 5730, 5754, 4388, 4389, 6137, 6366, 6800, 7137]
    .map((line, i) => ({id: `IM${String(i + 1).padStart(2, '0')}`, origin: 'inherited-compatibility', evidence: evidence(line, 'Impulse.CANCEL_CONTRARY_MOTION')}));
assert.equal((text.match(/Impulse\.CANCEL_CONTRARY_MOTION\b/g) || []).length, 20);
const report = {
    date: '2026-11-04', original, originalSha256: hash(text), hashNormalization: 'UTF-8, CRLF -> LF',
    scope: 'Source comparison of existing report findings, not an in-game test or an exhaustive search for regressions.',
    excludedSourceFiles: ['src/debug.opy'],
    findings, starts, chase, impulses,
};
if (process.argv.includes('--write')) fs.writeFileSync(path.join(__dirname, 'original-provenance-2026-11-04.json'), JSON.stringify(report, null, 2) + '\n');
if (require.main === module) console.log(JSON.stringify({findings: findings.length, inherited: findings.filter(x => x.origin === 'inherited').length, mixed: findings.filter(x => x.origin === 'mixed').length, diagnosticGroup: findings.filter(x => x.origin === 'inherited-diagnostic').length, starts: starts.length, chase: chase.length, impulses: impulses.length, originalSha256: report.originalSha256}));
module.exports = report;
