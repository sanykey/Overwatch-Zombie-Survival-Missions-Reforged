// Analysis only: transform copies and compile, leaving src/ and its export intact.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');
const {files, compile, compiler, src, replace, editBlock} = require('./measure-further-optimizations.cjs');
const {variants: previous} = require('./probe-additional-elements-2026-11-02.cjs');
const variants = {
    placement_check_helper(f) {
        f['variables.opy'] += '\n#!define probeInvalidPlacement tmp0\n';
        const block = '    if distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30:\n        return\n    if eventPlayer.isDead():\n        return';
        assert.equal(f['enhancements.opy'].split(block).length-1,2);
        f['enhancements.opy'] = 'subroutine probePlacementCheck\n'+f['enhancements.opy'].replaceAll(block,
            '    probePlacementCheck()\n    if probeInvalidPlacement:\n        return') +
            '\n\ndef probePlacementCheck():\n' +
            '    probeInvalidPlacement = distance(eventPlayer.getEyePosition(), raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 31, null, null, false)) > 30 or eventPlayer.isDead()\n';
        return {calls:2,scratch:'tmp0',sameRaycastArguments:true,waitsInHelper:0};
    },
    ability_toggle_merge(f) {
        editBlock(f,'subroutines.opy','def enableDisableAbilities():',b=> {
            const head=b.slice(0,b.indexOf('    if isPregameSetup:'));
            return head+'    if isPregameSetup:\n        eventPlayer.disableHeroHud()\n'+
                ['PrimaryFire','SecondaryFire','Ability1','Ability2','Ult','Melee'].map(a=>`    eventPlayer.set${a}Enabled(not isPregameSetup)`).join('\n')+
                '\n    if not isPregameSetup:\n        eventPlayer.enableHeroHud()\n\n\n';
        });
        return {settersBefore:12,settersAfter:6,waits:0,sameActionOrderPerPhase:true};
    },
    remove_angle_abs(f) {
        let removed=0;
        for(const name of Object.keys(f)) {
            const edits=[];
            for(const m of f[name].matchAll(/abs\(angleBetweenVectors\(/g)) {
                let depth=1,i=m.index+4;
                for(;i<f[name].length&&depth;i++) {if(f[name][i]==='(')depth++;if(f[name][i]===')')depth--;}
                assert.equal(depth,0);
                edits.push({start:m.index,end:i,text:f[name].slice(m.index+4,i-1)});
            }
            for(const e of edits.reverse())f[name]=f[name].slice(0,e.start)+e.text+f[name].slice(e.end);
            removed+=edits.length;
        }
        return {removed,compilerReturnType:'angleBetweenVectors: unsigned float'};
    },
    vote_winner_helper(f) {
        f['variables.opy']+='\n#!define probeWinnerVotes tmp1\n#!define probeWinner tmp2\n#!define probeWinnerIndex tmp0\n';
        assert(/SHOWDOWN = 1,/.test(f['variables.opy']) && /NO_PREFERENCE = 0,/.test(f['variables.opy']));
        const helperBody = '    for probeWinnerIndex in range(1, len(probeWinnerVotes)):\n'+
            '        if probeWinnerVotes[probeWinner] < probeWinnerVotes[probeWinnerIndex]:\n            probeWinner = probeWinnerIndex\n'+
            '        elif probeWinnerVotes[probeWinner] == probeWinnerVotes[probeWinnerIndex]:\n'+
            '            if probeWinner != 0 and random.randint(0, 1) == 0:\n                probeWinner = probeWinnerIndex\n';
        const canonical=s=>s.split('\n').filter(l=>l.trim()&&!l.trim().startsWith('#')).map(l=>l.trimEnd()).join('\n');
        const definitions=[['determineZombieMode','zombieVoteList','zombieModeVoteIndex','zombieSetting','1'],
            ['determineObjectiveType','objectiveTypeVoteList','objectiveTypeVoteIndex','objectiveTypeSetting','ObjectiveType.SHOWDOWN']];
        for(const[fn,list,index,winner,start]of definitions)editBlock(f,'global_start_menu.opy',`def ${fn}():`,b=>{
            const marker=`    for ${index} in range(${start}, len(${list})):`;
            const first=b.indexOf(marker),second=b.indexOf(marker,first+marker.length);
            assert(second>=0);
            const endMarker='    #If all players choose no preference';
            const end=b.indexOf(endMarker,second);assert(end>second);
            const originalLoop=b.slice(second,end).replaceAll(list,'probeWinnerVotes').replaceAll(index,'probeWinnerIndex')
                .replaceAll(winner,'probeWinner').replaceAll('ObjectiveType.SHOWDOWN','1').replaceAll('ObjectiveType.NO_PREFERENCE','0');
            assert.equal(canonical(originalLoop),canonical(helperBody),'Vote loop changed beyond storage aliases');
            return b.slice(0,second)+`    probeWinnerVotes = ${list}\n    probeWinner = ${winner}\n    probeVoteWinner()\n    ${winner} = probeWinner\n`+b.slice(end);
        });
        f['global_start_menu.opy']='subroutine probeVoteWinner\n'+f['global_start_menu.opy']+
            '\n\ndef probeVoteWinner():\n'+helperBody;
        return {calls:2,scratch:['tmp0','tmp1','tmp2'],originalLoopsStructurallyCompared:2,sameRandomCallConditions:true};
    },
    vote_counts_map(f) {
        for (const [fn, list, field, index, start] of [
            ['determineZombieMode','zombieVoteList','pregameZombieVote','zombieModeVoteIndex','1'],
            ['determineChallenge','challengeVoteList','pregameChallengeVote','challengeVoteIndex','1'],
            ['determineObjectiveType','objectiveTypeVoteList','pregameObjectiveVote','objectiveTypeVoteIndex','ObjectiveType.SHOWDOWN'],
        ]) {
            const old = `    for ${index} in range(${start}, len(${list})):\n` +
                `        if ${list}[${index}][1]:\n` +
                `            ${list}[${index}] = len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.${field} == ${index}))\n` +
                `        else:\n            ${list}[${index}] = -1`;
            replace(f, 'global_start_menu.opy', old,
                `    ${list} = ${list}.map(lambda option, i: option if i == 0 else len(getPlayers(Team.1).filter(lambda player: player.isPlayerActive and player.${field} == i)) if option[1] else -1)`);
        }
        return {loopsReplaced:3, nestedLambdaIndexNeedsReview:true};
    },
    gas_cloud_snapshots(f) {
        editBlock(f, 'zombie_types.opy', 'rule "BEHEMOTH GAS STREAM (BOSS)":', b => {
            const marker = '        eventPlayer.botSpecialTargetList.append(';
            const p = b.indexOf(marker); assert(p >= 0);
            return b.slice(0,p) + '        #!define probeGasPos tmp1\n        #!define probeGasRadius tmp2\n' +
                '        probeGasPos = eventPlayer.botGasPositionList[behemothGasCloudIndex]\n' +
                '        probeGasRadius = eventPlayer.botGasRadiusList[behemothGasCloudIndex]\n' +
                b.slice(p).replaceAll('eventPlayer.botGasPositionList[behemothGasCloudIndex]', 'probeGasPos')
                    .replaceAll('eventPlayer.botGasRadiusList[behemothGasCloudIndex]', 'probeGasRadius');
        });
        return {scratch:['tmp1','tmp2'], snapshotAfterRadiusGrowth:true};
    },
    boss_head_cache(f) {
        let reads = 0, updates = 0;
        for (const name of Object.keys(f)) {
            f[name] = f[name].split('\n').map(line => {
                const write = line.match(/^( *)(bossStateList|bossesStateList|zombieEggStateList)(\[[^\n]*?\])? = /);
                if (write && (!write[3] || write[3] === '[0]' || write[3].includes('.index('))) {
                    updates++;
                    return line + '\n' + write[1] + 'probeBossHead = ' + write[2] + '[0]';
                }
                return line.replace(/\b(?:bossStateList|bossesStateList|zombieEggStateList)\[0\]/g, () => {reads++;return 'probeBossHead';});
            }).join('\n');
        }
        f['variables.opy'] += '\nglobalvar probeBossHead\n';
        assert.equal(updates,6);
        return {reads,updates,addedGlobalSlots:1,originalMembershipArrayPreserved:true};
    },
    biomorph_goal_cache(f) {
        let reads = 0, updates = 0;
        for (const name of Object.keys(f)) {
            f[name] = f[name].split('\n').map(line => {
                const mutation = line.match(/^( *)(?:biomorphingGoalQueueList = |del biomorphingGoalQueueList\[0\]|biomorphingGoalQueueList\.append\()/);
                if (mutation) {updates++;return line+'\n'+mutation[1]+'probeBioGoal = biomorphingGoalQueueList[0]';}
                // This storage is also the Showdown contesting-player array; keep it in sync at generic writes.
                if (/^ *showdownContestingZombieList = |^ *showdownContestingZombieList\./.test(line)) return line;
                return line.replaceAll('biomorphingGoalQueueList[0]', () => {reads++;return 'probeBioGoal';});
            }).join('\n');
        }
        f['variables.opy'] += '\nglobalvar probeBioGoal\n';
        return {reads,updates,addedGlobalSlots:1,requiresPhaseAudit:true};
    },
    skin_cap_max(f) {
        const expr = '(getNumberOfSlots(Team.1) if getNumberOfPlayers(Team.1) <= getNumberOfSlots(Team.1) else getNumberOfPlayers(Team.1))';
        let occurrences=0;
        for(const name of Object.keys(f)) {
            occurrences += f[name].split(expr).length-1;
            f[name]=f[name].replaceAll(expr,'max(getNumberOfSlots(Team.1), getNumberOfPlayers(Team.1))');
        }
        assert.equal(occurrences,2);
        return {occurrences};
    },
    predicate_chains(f) {
        const cases = [
            ['bots_game_in_progress.opy', 'playerTargetList.filter(lambda x: x.invisibilityCount).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))',
                'playerTargetList.all(lambda x: not x.invisibilityCount or not isInLoS(x.getEyePosition(), eventPlayer.getPosition() + losOffsetConst))'],
            ['bots_game_in_progress.opy', 'playerTargetList.filter(lambda x: x.isInViewAngle(eventPlayer.botTeleportPosition, 55)).all(lambda x: not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))',
                'playerTargetList.all(lambda x: not x.isInViewAngle(eventPlayer.botTeleportPosition, 55) or not isInLoS(x.getEyePosition(), eventPlayer.botTeleportPosition + losOffsetConst))'],
            ['global_game_in_progress.opy', 'getPlayers(Team.1).filter(lambda player: player.hasSpawned()).all(lambda x: distance(x.getPosition(), attackSpawnRooms[spawnRoomIndex]) > 45)',
                'getPlayers(Team.1).all(lambda x: not x.hasSpawned() or distance(x.getPosition(), attackSpawnRooms[spawnRoomIndex]) > 45)'],
            ['objective_types/objective_type_satellite_uplink.opy', 'satelliteTerminalPositionList.filter(lambda _, i: satelliteTerminalProgressList[i] < 100).any(lambda x: distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)',
                'satelliteTerminalPositionList.any(lambda x, i: satelliteTerminalProgressList[i] < 100 and distance(x, eventPlayer.getPosition()) < objectiveRad and x.x != null)'],
        ];
        for(const [name,a,b] of cases)replace(f,name,a,b);
        return {cases:cases.length,emptyArrayTruthPreserved:true};
    },
    remaining_hud_helper(f) {
        editBlock(f,'subroutines.opy','macro globalObjectiveEntityManagementMacro():',b=>{
            let occurrences=0;
            b=b.replace(/^( *)hudSubheader\((?:getAllPlayers\(\)|getPlayers\(Team\.1\)), "Objectives Remaining: [^\n]+\n\1objectiveEntityIdList\.append\(getLastCreatedText\(\)\)/gm, (_,indent)=>{
                occurrences++;return indent+'probeRemainingHud()';
            });
            assert.equal(occurrences,4);
            return b;
        });
        f['subroutines.opy']='subroutine probeRemainingHud\n'+f['subroutines.opy']+ '\n\ndef probeRemainingHud():\n' +
            '    hudSubheader(getPlayers(Team.1) if objectiveValue == ObjectiveType.SURVIVOR_RESCUE else getAllPlayers(), "Giant Zombies Remaining: {0}".format(len(objectivePositionList) - 1) if objectiveValue == ObjectiveType.BOSSES and objectiveTypeSetting == ObjectiveType.BIOMORPHING else "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.VIOLET if objectiveValue == ObjectiveType.SURVIVOR_RESCUE else Color.LIME_GREEN if objectiveValue == ObjectiveType.ZOMBIE_EGG else Color.RED, HudReeval.VISIBILITY)\n' +
            '    objectiveEntityIdList.append(getLastCreatedText())\n';
        return {calls:4,addedSubroutines:1,sameCreationOrder:true,reevaluation:'VISIBILITY'};
    },
    two_remaining_huds(f) {
        f['variables.opy'] += '\n#!define probeRemainingColor tmp2\n';
        for(const color of ['RED','LIME_GREEN']) {
            const block=`        hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, Color.${color}, HudReeval.VISIBILITY)\n        objectiveEntityIdList.append(getLastCreatedText())`;
            replace(f,'subroutines.opy',block,`        probeRemainingColor = Color.${color}\n        probeTwoRemainingHud()`);
        }
        f['subroutines.opy']='subroutine probeTwoRemainingHud\n'+f['subroutines.opy']+
            '\n\ndef probeTwoRemainingHud():\n'+
            '    hudSubheader(getAllPlayers(), "Objectives Remaining: {0}".format(len(objectivePositionList) - 1), HudPosition.TOP, 1, probeRemainingColor, HudReeval.VISIBILITY)\n'+
            '    objectiveEntityIdList.append(getLastCreatedText())\n';
        return {calls:2,scratch:'tmp2',colorIsNotReevaluated:true,visibilityStillDynamic:true};
    },
    reconnect_row_snapshot(f) {
        const file='players_game_in_progress.opy',s=f[file];
        const start=s.indexOf('            eventPlayer.rescueTimeRemaining = playerStatsList[');
        const end=s.indexOf('                while eventPlayer.isAlive():',start);
        assert(start>=0&&end>start);
        const old=s.slice(start,end),expr='playerStatsList[eventPlayer.reconnectUserIndex]';
        assert.equal(old.split(expr).length-1,6);
        replace(f,file,old,'            #!define probeReconnectRow tmp0\n            probeReconnectRow = '+expr+'\n'+old.replaceAll(expr,'probeReconnectRow'));
        return {cachedReads:6,scratch:'tmp0',postWaitStatusReadUnchanged:true};
    },
    living_user_save_helper(f) {
        const row='playerStatsList[eventPlayer.reconnectUserIndex] = [0, eventPlayer.rescueTimeRemaining, eventPlayer.reviveTimeRemaining, eventPlayer.reviveDuration, eventPlayer.getPosition()]';
        const file='players_game_in_progress.opy';assert.equal(f[file].split(row).length-1,2);
        f[file]='subroutine probeSaveLivingUser\n'+f[file].replaceAll(row,'probeSaveLivingUser()')+
            '\n\ndef probeSaveLivingUser():\n    '+row+'\n';
        return {calls:2,waitsInHelper:0,scratchUsed:false};
    },
    barricade_dot_projection(f) {
        for(const target of ['player','target']) {
            const p=`vect(${target}.getPosition().x, eventPlayer.enhancementBarrierCorner1.y, ${target}.getPosition().z)`;
            const old=`abs(cosDeg(angleBetweenVectors(eventPlayer.enhancementBarrierEdgeDirection, directionTowards(eventPlayer.enhancementBarrierCorner1, ${p}))) * distance(eventPlayer.enhancementBarrierCorner1, ${p}))`;
            replace(f,'enhancements.opy',old,`abs(dotProduct(eventPlayer.enhancementBarrierEdgeDirection, ${p} - eventPlayer.enhancementBarrierCorner1))`);
        }
        return {occurrences:2,normalizedEdgeRequired:true,absoluteValueAndIndependentAnyConditionsPreserved:true,requiresInGameNumericalBoundaryValidation:true};
    },
    repeated_round_victories(f) {
        for(const team of [1,2]) {
            const line=`        declareRoundVictory(Team.${team})`;
            replace(f,'objective_types/objective_type_extraction_point.opy',Array(5).fill(line).join('\n'),
                `        #!define probeRoundIndex${team} tmp0\n        for probeRoundIndex${team} in range(5):\n    `+line);
        }
        return {sameVictoryCallCount:10,addedWaits:0};
    },
};

function count(f) {
    const s=Object.values(f).join('\n');
    return {globalVariables:(s.match(/^globalvar /gm)||[]).length,playerVariables:(s.match(/^playervar /gm)||[]).length};
}
async function main() {
    const exportBefore=fs.readFileSync(path.join(src,'main.ws.txt'));
    await compiler.readyPromise;
    const base=await compile(files);
    const report={date:'2026-11-03',baselineRef:execFileSync('git',['rev-parse','HEAD'],{encoding:'utf8'}).trim(),
        baseline:{elements:base.elements,...count(files)},candidates:[],combinations:[],srcChanged:false,
        inGameValidated:false,runtimeBenchmarked:false,warningsSuppressedByMainSource:true,
        sourceSha256:Object.fromEntries(Object.entries(files).map(([n,s])=>[n,crypto.createHash('sha256').update(s).digest('hex')]))};
    console.log(JSON.stringify({baseline:report.baseline}));
    for(const [name,transform] of Object.entries(variants)) {
        const f={...files};
        try {
            const detail=transform(f),r=await compile(f);
            const row={name,elements:r.elements,saved:base.elements-r.elements,...count(f),detail,emittedWarnings:r.warnings.length};
            report.candidates.push(row);console.log(JSON.stringify(row));
        }catch(e){const row={name,error:e.message};report.candidates.push(row);console.log(JSON.stringify(row));}
    }
    const core=['placement_check_helper','remove_angle_abs','vote_winner_helper','gas_cloud_snapshots','skin_cap_max','two_remaining_huds','reconnect_row_snapshot','living_user_save_helper'];
    const oldNoFields=['item_hud_format','bounce_pad_batch','objective_cleanup_id','average_target_loop','satellite_repair_count','ground_item_lookup'];
    for(const [name,oldChoices,newChoices]of [
        ['new_core',[],core],
        ['new_with_victory_loop',[],[...core,'repeated_round_victories']],
        ['all_without_new_variables',oldNoFields,core],
        ['all_with_seven_id_fields',[...oldNoFields,'hot_entity_fields'],core],
        ['all_with_21_id_fields',[...oldNoFields,'entity_fields'],core],
        ['including_numerical_projection',[...oldNoFields,'entity_fields'],[...core,'barricade_dot_projection']],
    ]) {
        const f={...files};
        for(const choice of oldChoices)previous[choice](f);
        for(const choice of newChoices)variants[choice](f);
        const r=await compile(f);
        const row={name,previousChoices:oldChoices,newChoices,elements:r.elements,saved:base.elements-r.elements,...count(f),emittedWarnings:r.warnings.length};
        report.combinations.push(row);console.log(JSON.stringify(row));
    }
    for(const[name,s]of Object.entries(files))assert.equal(fs.readFileSync(path.join(src,name),'utf8').replace(/\r\n/g,'\n'),s);
    assert.deepEqual(fs.readFileSync(path.join(src,'main.ws.txt')),exportBefore);
    fs.writeFileSync(path.join(__dirname,'more-elements-probes-2026-11-03.json'),JSON.stringify(report,null,2)+'\n');
}
main().catch(e=>{console.error(e);process.exitCode=1;});
